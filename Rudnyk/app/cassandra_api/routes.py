from flask import Blueprint, request, jsonify

from app.cassandra_api.constants import USER_DOCUMENTS, DOCUMENT_USERS
from app.cassandra_api.helpers import (
    delete_user_clq,
    delete_document_clq,
    select_all,
    select_field,
    select_field_query_builder,
    insert_data,
    get_user_info,
    get_document_info,
    get_user_documents,
    update_document_users,
    update_user_documents,
    create_new_user,
    create_new_document,
)


api = Blueprint('api', __name__)


@api.route('/')
def smoke():
    return 'smoke test'


@api.route('/user_info')
def user_info():
    email = request.args.get('email')

    user = get_user_info(email=email)

    return user


@api.route('/document_info')
def document_info():
    title = request.args.get('title')

    document = get_document_info(title=title)

    return document


@api.route('/user_documents_titles')
def user_documents_titles():
    email = request.args.get('email')

    titles = get_user_documents(email=email)

    return titles


@api.route('/document_users')
def document_users():
    users = select_all(table=DOCUMENT_USERS)

    return users


@api.route('/users_emails')
def users_emails():
    emails = select_field(table=USER_DOCUMENTS, field='user_email')

    return emails


@api.route('/users_emails_query_builder')
def users_emails_query_builder():
    emails = select_field_query_builder(
        table=USER_DOCUMENTS, field='user_email')

    return emails


@api.route('/documents_titles')
def documents_titles():
    titles = select_field(table=DOCUMENT_USERS, field='document_title')

    return titles


@api.route('/register_user', methods=["POST"])
def register_user():
    user_data = request.get_json()

    response = insert_data(table=USER_DOCUMENTS, data=user_data)

    return jsonify(response)


@api.route('/add_document', methods=["POST"])
def add_document():
    document_data = request.get_json()

    response = insert_data(table=DOCUMENT_USERS, data=document_data)

    return jsonify(response)


@api.route('/update_documents', methods=["POST"])
def update_documents():
    data = request.get_json()

    response = update_user_documents(data)

    return jsonify(response)


@api.route('/update_users', methods=['POST'])
def update_users():
    users = request.get_json()

    response = update_document_users(users)

    return jsonify(response)


@api.route('/delete_user', methods=['POST'])
def delete_user():
    email = request.get_json().get('email')

    response = delete_user_clq(email=email)

    return jsonify(response)


@api.route('/delete_document', methods=['POST'])
def delete_document():
    title = request.get_json().get('title')

    response = delete_document_clq(title=title)

    return jsonify(response)


@api.route('/create_user', methods=['POST'])
def create_user():
    data = request.get_json()

    response = create_new_user(data=data)

    return jsonify(response)


@api.route('/create_document', methods=['POST'])
def create_document():
    data = request.get_json()

    response = create_new_document(data=data)

    return jsonify(response)
