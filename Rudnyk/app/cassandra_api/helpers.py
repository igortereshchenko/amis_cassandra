import json
from functools import wraps

from flask import jsonify
from cql_builder.builder import QueryBuilder
from cassandra.query import SimpleStatement
from cassandra import ConsistencyLevel as Level


from app.cassandra_api.connector import session


def jsonify_rows(func):
    """
    Wrap to json all rows selected from Cassandra
    :param func: original selector
    :return: jsonified rows
    """
    @wraps(func)
    def wrapper(*args, **kwargs):
        rows = _encode_rows(func(*args, **kwargs))
        return rows

    return wrapper


@jsonify_rows
def select_all(table):
    """
    Get all data from db table
    :param table: db table
    :return: list of dicts with data from table
    """
    rows = session.execute(f'SELECT JSON * FROM {table}')

    return rows


@jsonify_rows
def select_field(table, field):
    """
    Get one field from db table
    :param table: db table
    :param field: field for select
    :return: list of dicts with data from table
    """
    rows = session.execute(f'SELECT JSON {field} FROM {table}')

    return rows


def select_field_query_builder(table, field):
    select = (QueryBuilder.select_from(table).columns(field))
    query, args = select.statement()
    statement = SimpleStatement(query, consistency_level=Level.LOCAL_ONE)
    rows = session.execute(statement, args)
    emails = [{field: _.user_email} for _ in rows]

    return jsonify(emails)


@jsonify_rows
def get_user_info(email):
    """
    get all info about one user
    :return:
    """
    rows = session.execute(
        f"""
            SELECT JSON * FROM user_documents
            WHERE user_email = {email}
        """
    )

    return rows


@jsonify_rows
def get_document_info(title):
    """
    get all info about one doc
    :return:
    """
    rows = session.execute(
        f"""
            SELECT JSON * FROM document_users
            WHERE document_title = {title}
        """
    )

    return rows


@jsonify_rows
def get_user_documents(email):
    """

    :return:
    """
    rows = session.execute(
        f"""
            SELECT JSON documents FROM user_documents
            WHERE user_email = {email}
        """
    )

    return rows


def insert_data(table, data):
    """
    Insert data into db table
    :param table: db table
    :param data: insertion data
    :return:
    """
    data = json.dumps(data)
    message = 'data has been inserted successfully'

    try:
        session.execute(
            f"""INSERT INTO {table} JSON '{data}'"""
        )
    except Exception as e:
        message = f'data hasn`t been inserted because of exception: {e}'

    return {'message': message}


def update_user_documents(data):
    """
    Update user documents to new value
    :param data: user email and list of documents
    :return:
    """
    message = 'data has been update successfully'

    documents_data = data.get('documents')
    documents = set(documents_data) if documents_data else {}
    if len(documents) == 1:
        documents_tuple = str(tuple(documents)).replace(',', '')
    else:
        documents_tuple = tuple(documents)

    try:
        session.execute(
            f"""
            BEGIN BATCH

            UPDATE user_documents
            SET documents = {documents}
            WHERE user_email = '{data.get('user_email')}';

            UPDATE document_users
            SET users = users + {{'{data.get('user_email')}'}}
            WHERE document_title IN {documents_tuple};

            APPLY BATCH;
            """
        )
    except Exception as e:
        message = f'data has`t been update because of exception: {e}'

    return {'message': message}


def update_document_users(data):
    """
    Update document users to new value
    :param data: document title and list of users
    :return:
    """
    message = 'data has been update successfully'

    users_data = data.get('users')
    users = set(users_data) if users_data else {}

    if len(users) == 1:
        users_tuple = str(tuple(users)).replace(',', '')
    else:
        users_tuple = tuple(users)

    try:
        session.execute(
            f"""
            BEGIN BATCH

            UPDATE document_users
            SET users = {users}
            WHERE document_title = '{data.get('document_title')}'

            UPDATE user_documents
            SET documents = documents + {{'{data.get('document_title')}'}}
            WHERE user_email IN {users_tuple};

            APPLY BATCH;
            """
        )
    except Exception as e:
        message = f'data hasn`t been update because of exception: {e}'

    return {'message': message}


def delete_user_clq(email):
    """
    Delete user by email
    :param email: user email
    :return:
    """
    message = 'user has been deleted successfully'
    try:
        session.execute(
            f"""
            delete from user_documents
            where user_email = '{email}';
            """
        )
    except Exception as e:
        message = f'user hasn`t been deleted because of exception: {e}'

    return {'message': message}


def delete_document_clq(title):
    """
    Delete document by title
    :param title: document title
    :return:
    """
    message = 'document has been deleted successfully'
    try:
        query = f"""
            delete from document_users
            where document_title = '{title}'
            """
        statement = SimpleStatement(query, consistency_level=Level.ALL)
        session.execute(statement)
    except Exception as e:
        message = f'document hasn`t been deleted because of exception: {e}'

    return {'message': message}


def create_new_user(data):
    """
    Insert new user to db
    :param data: user data
    :return:
    """
    message = 'user has been created successfully'
    try:
        query = f"""
            insert into user_documents
              (user_email, user_birthdate, user_address,
               user_full_name, documents)
            values ('{data.get('email')}', '{data.get('birthdate')}',
            '{data.get('address')}',
            {{firstname: '{data.get('first_name')}',
             middlename: '{data.get('middlename')}',
             surname: '{data.get('surname')}'
             }},
             {{}}
            );
            """

        statement = SimpleStatement(query, consistency_level=Level.ALL)
        session.execute(statement)
    except Exception as e:
        message = f'user hasn`t been created because of exception: {e}'

    return {'message': message}


def create_new_document(data):
    """
    Insert new document to db
    :param data: user data
    :return:
    """
    message = 'user has been created successfully'

    try:
        query = f"""
            insert into document_users
              (document_title, document_description, document_date,
               document_chapters, users)
            values ('{data.get('title')}', '{data.get('description')}',
            '{data.get('date')}', {data.get('chapters')},
             {{}}
            );
            """
        statement = SimpleStatement(query, consistency_level=Level.ALL)
        session.execute(statement)
    except Exception as e:
        message = f'user hasn`t been created because of exception: {e}'

    return {'message': message}


def _encode_rows(rows):
    """
    Encode rows to json
    :param rows: result of select from Cassandra
    :return: json with rows
    """

    return json.dumps([json.loads(row[0]) for row in rows])
