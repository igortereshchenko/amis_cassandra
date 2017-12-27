# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'client/designer_ui/new_user.ui'
#
# Created by: PyQt5 UI code generator 5.9.2
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_new_user_form(object):
    def setupUi(self, new_user_form):
        new_user_form.setObjectName("new_user_form")
        new_user_form.resize(288, 278)
        self.first_name_line_edit = QtWidgets.QLineEdit(new_user_form)
        self.first_name_line_edit.setGeometry(QtCore.QRect(40, 20, 201, 21))
        self.first_name_line_edit.setMaximumSize(QtCore.QSize(201, 16777215))
        self.first_name_line_edit.setAutoFillBackground(False)
        self.first_name_line_edit.setInputMethodHints(QtCore.Qt.ImhLatinOnly)
        self.first_name_line_edit.setMaxLength(30)
        self.first_name_line_edit.setFrame(True)
        self.first_name_line_edit.setCursorMoveStyle(QtCore.Qt.LogicalMoveStyle)
        self.first_name_line_edit.setClearButtonEnabled(False)
        self.first_name_line_edit.setObjectName("first_name_line_edit")
        self.email_line_edit = QtWidgets.QLineEdit(new_user_form)
        self.email_line_edit.setGeometry(QtCore.QRect(40, 110, 201, 21))
        self.email_line_edit.setMaximumSize(QtCore.QSize(201, 16777215))
        self.email_line_edit.setInputMethodHints(QtCore.Qt.ImhEmailCharactersOnly|QtCore.Qt.ImhLatinOnly)
        self.email_line_edit.setMaxLength(24)
        self.email_line_edit.setObjectName("email_line_edit")
        self.current_job_title_line_edit = QtWidgets.QLineEdit(new_user_form)
        self.current_job_title_line_edit.setGeometry(QtCore.QRect(40, 140, 201, 21))
        self.current_job_title_line_edit.setMaximumSize(QtCore.QSize(201, 16777215))
        self.current_job_title_line_edit.setInputMethodHints(QtCore.Qt.ImhLatinOnly)
        self.current_job_title_line_edit.setMaxLength(24)
        self.current_job_title_line_edit.setObjectName("current_job_title_line_edit")
        self.cancel_button = QtWidgets.QPushButton(new_user_form)
        self.cancel_button.setGeometry(QtCore.QRect(40, 230, 71, 23))
        self.cancel_button.setMaximumSize(QtCore.QSize(16777215, 16777213))
        self.cancel_button.setObjectName("cancel_button")
        self.apply_button = QtWidgets.QPushButton(new_user_form)
        self.apply_button.setGeometry(QtCore.QRect(160, 230, 71, 23))
        self.apply_button.setMaximumSize(QtCore.QSize(16777215, 16777213))
        self.apply_button.setObjectName("apply_button")
        self.surname_line_edit = QtWidgets.QLineEdit(new_user_form)
        self.surname_line_edit.setGeometry(QtCore.QRect(40, 50, 201, 21))
        self.surname_line_edit.setMaximumSize(QtCore.QSize(201, 16777215))
        self.surname_line_edit.setAutoFillBackground(False)
        self.surname_line_edit.setInputMethodHints(QtCore.Qt.ImhLatinOnly)
        self.surname_line_edit.setMaxLength(30)
        self.surname_line_edit.setFrame(True)
        self.surname_line_edit.setCursorMoveStyle(QtCore.Qt.LogicalMoveStyle)
        self.surname_line_edit.setClearButtonEnabled(False)
        self.surname_line_edit.setObjectName("surname_line_edit")
        self.middle_name_line_edit = QtWidgets.QLineEdit(new_user_form)
        self.middle_name_line_edit.setGeometry(QtCore.QRect(40, 80, 201, 21))
        self.middle_name_line_edit.setMaximumSize(QtCore.QSize(201, 16777215))
        self.middle_name_line_edit.setAutoFillBackground(False)
        self.middle_name_line_edit.setInputMethodHints(QtCore.Qt.ImhLatinOnly)
        self.middle_name_line_edit.setMaxLength(30)
        self.middle_name_line_edit.setFrame(True)
        self.middle_name_line_edit.setCursorMoveStyle(QtCore.Qt.LogicalMoveStyle)
        self.middle_name_line_edit.setClearButtonEnabled(False)
        self.middle_name_line_edit.setObjectName("middle_name_line_edit")
        self.birth_date_date_edit = QtWidgets.QDateEdit(new_user_form)
        self.birth_date_date_edit.setGeometry(QtCore.QRect(40, 190, 201, 22))
        self.birth_date_date_edit.setObjectName("birth_date_date_edit")
        self.label = QtWidgets.QLabel(new_user_form)
        self.label.setGeometry(QtCore.QRect(100, 170, 61, 16))
        self.label.setObjectName("label")

        self.retranslateUi(new_user_form)
        QtCore.QMetaObject.connectSlotsByName(new_user_form)

    def retranslateUi(self, new_user_form):
        _translate = QtCore.QCoreApplication.translate
        new_user_form.setWindowTitle(_translate("new_user_form", "Register"))
        self.first_name_line_edit.setPlaceholderText(_translate("new_user_form", "first name"))
        self.email_line_edit.setPlaceholderText(_translate("new_user_form", "email"))
        self.current_job_title_line_edit.setPlaceholderText(_translate("new_user_form", "address"))
        self.cancel_button.setText(_translate("new_user_form", "Cancel"))
        self.apply_button.setText(_translate("new_user_form", "Apply"))
        self.surname_line_edit.setPlaceholderText(_translate("new_user_form", "surname"))
        self.middle_name_line_edit.setPlaceholderText(_translate("new_user_form", "middle name"))
        self.label.setText(_translate("new_user_form", "Birth date"))

