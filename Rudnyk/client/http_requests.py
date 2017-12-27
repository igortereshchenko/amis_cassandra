import requests

from app.urls import (
    DELETE_USER,
    DELETE_DOCUMENT,
    EMAILS,
    TITLES,
    USER_DOCUMENTS_TITLES,
    USER_INFO,
    DOCUMENT_INFO,
    SET_DOCUMENTS,
    SET_USERS,
    CREATE_USER,
    CREATE_DOCUMENT,
)


def get_users_emails():
    response = requests.get(EMAILS)

    return response.json()


def get_documents_titles():
    response = requests.get(TITLES)

    return response.json()


def get_user_document_titles(email):
    response = requests.get(USER_DOCUMENTS_TITLES.format(email))

    return response.json()


def get_user_info_request(email):
    response = requests.get(USER_INFO.format(email))

    return response.json()


def get_document_info_request(title):
    response = requests.get(DOCUMENT_INFO.format(title))

    return response.json()


def set_new_documents(data):
    requests.post(SET_DOCUMENTS, json=data)


def set_new_users(data):
    requests.post(SET_USERS, json=data)


def delete_user_request(data):
    requests.post(DELETE_USER, json=data)


def delete_document_request(data):
    requests.post(DELETE_DOCUMENT, json=data)


def create_user_request(data):
    requests.post(CREATE_USER, json=data)


def create_document_request(data):
    requests.post(CREATE_DOCUMENT, json=data)
