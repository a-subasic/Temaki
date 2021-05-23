import QtQuick 2.0
import QtQuick.Controls 2.15

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
                id: label1
                text: qsTr("Password")
            }

            TextField {
                id: txtPassword
                width: parent.width
                placeholderText: qsTr("")
                echoMode: TextInput.Password
            }

            Button {
                id: button
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Submit")
                onClicked: {
                    var success = user.login(txtUsername.text, txtPassword.text)
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
}
