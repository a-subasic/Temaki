import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    signal login(string username, string password)
    width: 250
    height: 200

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
        }
    }

    Connections {
        target: button
        function onClicked() {
            var success = user.login(txtUsername.text, txtPassword.text)
            lblStatus.text = success
            popup.open()
        }
    }
}
