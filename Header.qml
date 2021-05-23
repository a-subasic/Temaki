import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3


ToolBar {
    id: toolbar
    height: 40
    RowLayout {
        anchors.right: parent.right
        Label {
            id: usernameLabel
            text: "TODO:username"
            // Layout.fillWidth: true
        }
        Button {
            id: logoutButton
            text: "LOGOUT"
            onClicked: todo.open()
        }
    }
}

