import QtQuick 2.0
import QtQuick.Controls 2.15

import "qrc:/const.js" as Constants
import "qrc:/components"

Page {
    id: registerPage
    width: mainWindow.width
    height: mainWindow.height

    Item {
        anchors.centerIn: parent
        width: 250
        height: 475

        Column {
            id: column
            anchors.fill: parent
            spacing: 5

            Input {
                id: username
                labelName: "Username"
                errorText: "Username is required"
            }

            Input {
                id: email
                labelName: "E-mail"
                validatorRegex: "[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}"
                errorText: "E-mail is in invalid format"
            }

            Input {
                id: password
                labelName: "Password"
                errorText: "Password is required"
                echo: TextInput.Password
            }

            Input {
                id: confirmPassword
                labelName: "Confirm Password"
                errorText: "Confirm Password is required"
                customErrorText: confirmPassword.input.text === password.input.text ? "" : "Passwords don't match"
                echo: TextInput.Password
            }

            Label {
                text: qsTr("Role")
            }

            ComboBox {
                id: role
                width: parent.width
                model: Constants.ROLES
            }

            Button {
                id: button
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Submit")
                onClicked: {
                    if(!username.isValid || !email.isValid || !password.isValid || !confirmPassword.isValid) {
                        failedDialog.open()
                    }
                    else {
                        var success = user.signUp(username.input.text, email.input.text, password.input.text, role.currentIndex + 1)
                        if(success) {
                            if (stackView.depth > 1) {
                                stackView.pop()
                            } else {
                                stackView.push("qrc:/Home.qml")
                            }
                        }
                        else {
                             failedDialog.open()
                        }
                    }
                }
            }

            Text {
                id: register
                text: "Already have an account? Sign in"
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor

                    onEntered: parent.color = "red"
                    onExited: parent.color = "black"
                    onClicked: {
                        if (stackView.depth > 1) {
                            stackView.pop()
                        } else {
                            stackView.push("qrc:/pages/Login.qml")
                        }
                    }
                }
            }
        }
    }

    InfoDialog {
        id: failedDialog
        dialogTitle: "Registration Failed"
        description: "Please provide valid values."
    }
}
