import QtQuick 2.0
import QtQuick.Controls 2.15

import "qrc:/components"

Page {
    id: loginPage
    width: mainWindow.width
    height: mainWindow.height

    Item {
        anchors.centerIn: parent
        width: 250
        height: 220

        Column {
            id: column
            anchors.fill: parent
            spacing: 10

            Input {
                id: username
                labelName: "Username"
                errorText: "Username is required"
            }

            Input {
                id: password
                labelName: "Password"
                errorText: "Password is required"
                echo: TextInput.Password
            }


            Button {
                id: button
                width: parent.width
                text: qsTr("Submit")
                onClicked: {
                    if(!username.isValid || !password.isValid) {
                        failedDialog.open()
                    }
                    else {
                        var success = user.login(username.input.text, password.input.text)
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
                text: "Don't have an account? Sign up"
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
                            stackView.push("qrc:/pages/Register.qml")
                        }
                    }
                }
            }
        }
    }

    InfoDialog {
        id: failedDialog
        dialogTitle: "Login Failed"
        description: "Please provide valid values."
    }
}
