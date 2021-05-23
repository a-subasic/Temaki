import QtQuick 2.0
import QtQuick.Controls 2.15

Page {
    id: registerPage
    width: mainWindow.width
    height: mainWindow.height

    Item {
        anchors.centerIn: parent
        width: 250
        height: 450


        Column {
            id: column
            anchors.fill: parent
            spacing: 10

            Label {
                id: label
                text: qsTr("Username")
            }

            TextField {
                id: txtUsername
                width: parent.width
                placeholderText: qsTr("")
            }

            Label {
                id: label2
                text: qsTr("E-mail")
            }

            TextField {
                id: txtEmail
                width: parent.width
                placeholderText: qsTr("")
            }

            Label {
                id: label1
                text: qsTr("Password")
            }

            TextField {
                id: txtPassword
                width: parent.width
                placeholderText: qsTr("")
                echoMode: TextInput.Password
            }

            Label {
                id: label3
                text: qsTr("Confirm Password")
            }

            TextField {
                id: txtConfirmPassword
                width: parent.width
                placeholderText: qsTr("")
                echoMode: TextInput.Password
            }

            Label {
                id: label4
                text: qsTr("Role Id")
            }

            TextField {
                id: txtRoleId
                width: parent.width
                placeholderText: qsTr("")
            }

            Button {
                id: button
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Submit")
                onClicked: {
                    var success = user.signUp(txtUsername.text, txtEmail.text, txtPassword.text, 1)
                    console.log(success);
                    if(success) {
                        if (stackView.depth > 1) {
                            stackView.pop()
                        } else {
                            stackView.push("qrc:/Home.qml")
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

}
