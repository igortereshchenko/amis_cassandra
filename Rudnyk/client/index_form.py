import sys
import re
from datetime import datetime

from PyQt5 import QtWidgets, QtCore

from client.http_requests import (
    delete_user_request,
    delete_document_request,
    get_users_emails,
    get_documents_titles,
    get_user_info_request,
    get_document_info_request,
    set_new_documents,
    set_new_users,
    create_user_request,
    create_document_request,
)
from client.ui import index_ui
from client.constants import (
    CASSANDRA_DATE_FORMAT,
    QT_DATE_FORMAT,
    QT_DATE_FROM_STRING,
)


class ExampleApp(QtWidgets.QMainWindow, index_ui.Ui_main):
    def __init__(self, parent=None):
        super(ExampleApp, self).__init__()
        self.setupUi(self)

        # add user info
        self.add_select_user_combo_box_items()
        self.add_documents_list_widget_items()
        self.set_user_info()
        self.select_user_combo_box.currentIndexChanged.connect(
            self.add_documents_list_widget_items)
        self.apply_docs_push_button.clicked.connect(self.set_user_documents)
        self.delete_user_push_button.clicked.connect(
            self.delete_user_message_box)

        # add docs info
        self.add_select_document_combo_box_items()
        self.add_users_list_widget_items()
        self.set_document_info()
        self.select_document_combo_box.currentIndexChanged.connect(
            self.add_users_list_widget_items)
        self.apply_users_push_button.clicked.connect(self.set_document_users)
        self.delete_document_push_button.clicked.connect(
            self.delete_document_message_box)

        # create user
        self.new_user_apply_button.clicked.connect(self.create_user)

        # create document
        self.new_doc_apply_button.clicked.connect(self.create_document)

        # clear buttons
        self.clear_docs_push_button.clicked.connect(self.clear_selected_docs)
        self.clear_users_push_button.clicked.connect(self.clear_selected_users)
        self.new_user_clear_button.clicked.connect(self.clear_new_user_form)
        self.new_doc_clear_button.clicked.connect(self.clear_new_doc_form)

    def clear_selected_docs(self):
        self.documents_list_widget.clearSelection()

    def clear_selected_users(self):
        self.users_list_widget.clearSelection()

    def clear_new_user_form(self):
        self.new_first_name_line_edit.clear()
        self.new_surname_line_edit.clear()
        self.new_middle_name_line_edit.clear()
        self.new_email_line_edit.clear()
        self.new_address_line_edit.clear()

    def clear_new_doc_form(self):
        self.new_title_line_edit.clear()
        self.new_description_line_edit.clear()
        self.new_chapters_line_edit.clear()

    def add_select_user_combo_box_items(self):
        self.select_user_combo_box.clear()
        emails = get_users_emails()
        for email in emails:
            self.select_user_combo_box.addItem(email.get('user_email'))

    def add_select_document_combo_box_items(self):
        self.select_document_combo_box.clear()
        titles = get_documents_titles()
        for title in titles:
            self.select_document_combo_box.addItem(title.get('document_title'))

    def add_documents_list_widget_items(self):
        self.documents_list_widget.clear()

        titles = self.get_available_documents_titles()
        self.documents_list_widget.addItems(titles)

        self.set_user_info()

    def add_users_list_widget_items(self):
        self.users_list_widget.clear()

        emails = self.get_available_users_emails()
        self.users_list_widget.addItems(emails)

        self.set_document_info()

    @staticmethod
    def get_available_documents_titles():
        documents = get_documents_titles()

        return [doc.get('document_title') for doc in documents]

    @staticmethod
    def get_available_users_emails():
        users = get_users_emails()

        return [user.get('user_email') for user in users]

    def get_user_info(self):
        email = self.select_user_combo_box.currentText()
        if email:
            info = get_user_info_request(email=email)

            return info[0]

    def get_document_info(self):
        title = self.select_document_combo_box.currentText()
        if title:
            info = get_document_info_request(title=title)

            return info[0]

    def set_user_info(self):
        user_info = self.get_user_info()
        if user_info:
            user_doc_titles = user_info.get('documents')

            docs_count = self.documents_list_widget.count()

            if user_doc_titles:
                for i in range(docs_count):
                    if self.documents_list_widget.item(i).text() \
                            in user_doc_titles:
                        self.documents_list_widget.item(i).setSelected(
                            True)

            full_name = user_info.get('user_full_name')

            self.first_name_line_edit.setText(
                full_name.get('firstname'))
            self.middle_name_line_edit.setText(
                full_name.get('middlename'))
            self.surname_line_edit.setText(full_name.get('surname'))
            self.email_line_edit.setText(user_info.get('user_email'))
            self.address_line_edit.setText(
                user_info.get('user_address'))

            qtdate = QtCore.QDate.fromString(
                user_info.get('user_birthdate'), QT_DATE_FROM_STRING)
            self.birth_date_date_edit.setDate(qtdate)

    def set_document_info(self):
        doc_info = self.get_document_info()
        if doc_info:
            doc_users_emails = doc_info.get('users')

            users_count = self.users_list_widget.count()

            if doc_users_emails:
                for i in range(users_count):
                    if self.users_list_widget.item(i).text() \
                            in doc_users_emails:
                        self.users_list_widget.item(i).setSelected(True)

            self.title_line_edit.setText(doc_info.get('document_title'))
            self.description_line_edit.setText(
                doc_info.get('document_description'))

            qtdate = QtCore.QDate.fromString(
                doc_info.get('document_date'), QT_DATE_FROM_STRING)
            self.publication_date_date_edit.setDate(qtdate)

            chapters = doc_info.get('document_chapters')
            if not chapters:
                chapters = []

            self.chapters_list_widget.clear()
            self.chapters_list_widget.addItems(chapters)

    def set_user_documents(self):
        documents = [str(x.text())
                     for x in self.documents_list_widget.selectedItems()]
        email = self.select_user_combo_box.currentText()
        if email:
            data = {'documents': documents, 'user_email': email}
            set_new_documents(data=data)
        else:
            self.documents_list_widget.clear()

    def set_document_users(self):
        users = [str(x.text())
                 for x in self.users_list_widget.selectedItems()]
        title = self.select_document_combo_box.currentText()
        if title:
            data = {'users': users, 'document_title': title}
            set_new_users(data=data)
        else:
            self.users_list_widget.clear()

    def delete_user_message_box(self):
        confirm_message = "Are you sure you want to delete this user?"
        reply = QtWidgets.QMessageBox.question(self, 'Delete user?',
                                               confirm_message,
                                               QtWidgets.QMessageBox.Yes,
                                               QtWidgets.QMessageBox.No)

        if reply == QtWidgets.QMessageBox.Yes:
            self.delete_user()
            self.set_user_documents()

    def delete_user(self):
        email = self.select_user_combo_box.currentText()

        data = {'email': email}
        delete_user_request(data=data)

        message = f'User with email = "{email}" has been deleted successfully'
        QtWidgets.QMessageBox.information(
            self, 'User has been deleted', message)

        self.add_select_user_combo_box_items()

    def delete_document_message_box(self):
        confirm_message = "Are you sure you want to delete this document?"
        reply = QtWidgets.QMessageBox.question(self, 'Delete document?',
                                               confirm_message,
                                               QtWidgets.QMessageBox.Yes,
                                               QtWidgets.QMessageBox.No)

        if reply == QtWidgets.QMessageBox.Yes:
            self.delete_document()
            self.set_document_users()

    def delete_document(self):
        title = self.select_document_combo_box.currentText()

        data = {'title': title}
        delete_document_request(data=data)

        message = f'Document with title = "{title}" has been deleted'
        QtWidgets.QMessageBox.information(
            self, 'Document has been deleted', message)

        self.add_select_document_combo_box_items()

    def create_user(self):
        first_name = self.new_first_name_line_edit.text()
        surname = self.new_surname_line_edit.text()
        middle_name = self.new_middle_name_line_edit.text()
        email = self.new_email_line_edit.text()
        address = self.new_address_line_edit.text()
        birth_date = self.new_birth_date_date_edit.text()
        b_date = datetime.strptime(
            birth_date, QT_DATE_FORMAT).strftime(CASSANDRA_DATE_FORMAT)

        if not email:
            message = 'email field is required'
            QtWidgets.QMessageBox.information(self, 'Required email', message,
                                              QtWidgets.QMessageBox.Ok)
        elif not self.validate_email(email=email):
            message = 'please input valid email address'
            QtWidgets.QMessageBox.information(self, 'Invalid email', message,
                                              QtWidgets.QMessageBox.Ok)
        elif email in self.get_available_users_emails():
            message = f'User with email = {email} exists, ' \
                      f'are you sure that you want replace this user info?'
            reply = QtWidgets.QMessageBox.critical(self, 'Replaced user?',
                                                   message,
                                                   QtWidgets.QMessageBox.Yes,
                                                   QtWidgets.QMessageBox.No)
            if reply == QtWidgets.QMessageBox.Yes:
                self.confirm_user_creation(
                    first_name, surname, middle_name, email, address, b_date)
        else:
            self.confirm_user_creation(
                first_name, surname, middle_name, email, address, b_date)

    def confirm_user_creation(
            self, first_name, surname, middle_name, email, address, b_date):
        data = {'first_name': first_name, 'surname': surname,
                'middlename': middle_name, 'email': email,
                'address': address,
                'birthdate': b_date}

        create_user_request(data=data)

        self.add_select_user_combo_box_items()

        message = 'User has been created successfully'
        QtWidgets.QMessageBox.information(
            self, 'User has been created', message)
        self.clear_new_user_form()

    def create_document(self):
        title = self.new_title_line_edit.text()
        description = self.new_description_line_edit.text()
        chapters = self.new_chapters_line_edit.text().split(',')
        publication_date = self.new_publication_date_date_edit.text()
        p_date = datetime.strptime(
            publication_date, QT_DATE_FORMAT).strftime(CASSANDRA_DATE_FORMAT)

        if not title:
            message = 'title field is required'
            QtWidgets.QMessageBox.information(self, 'Required title', message,
                                              QtWidgets.QMessageBox.Ok)
        elif title in self.get_available_users_emails():
            message = f'User with email = {title} exists, ' \
                      f'are you sure that you want replace this user info?'
            reply = QtWidgets.QMessageBox.critical(self, 'Replaced user?',
                                                   message,
                                                   QtWidgets.QMessageBox.Yes,
                                                   QtWidgets.QMessageBox.No)
            if reply == QtWidgets.QMessageBox.Yes:
                self.confirm_document_creation(
                    title, description, p_date, chapters)

        else:
            self.confirm_document_creation(
                title, description, p_date, chapters)

    def confirm_document_creation(
            self, title, description, publication_date, chapters):
        data = {'title': title, 'description': description,
                'date': publication_date, 'chapters': chapters}

        create_document_request(data=data)

        self.add_select_document_combo_box_items()

        message = 'Document has been created successfully'
        QtWidgets.QMessageBox.information(
            self, 'Document has been created', message)
        self.clear_new_doc_form()

    @staticmethod
    def validate_email(email):
        pattern = r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)"

        return re.match(pattern, email)


def main():
    app = QtWidgets.QApplication(sys.argv)
    form = ExampleApp()
    form.show()
    app.exec_()


if __name__ == '__main__':
    main()
