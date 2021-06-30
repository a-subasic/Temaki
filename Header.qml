import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.14

Row {
    width: parent.width
    height: 40

    ToolBar {
        id: headerToolbar
        width: parent.width

        ToolButton {
            id: toolButton
            anchors.left: parent.left
            text: "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (sidebar.depth > 1) {
                    sidebar.pop()
                }
                sidebar.open()
            }
        }

        Label {
            text: homeScreen.screenName
            anchors.left: toolButton.right
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            text: project ? project.name : "No Project Selected"
            anchors.centerIn: parent
        }

        ToolButton {
            anchors.right: logoutButton.left
            id: usernameLabel
            text: user ? user.username : "Anonymous"
        }
        ToolButton {
            anchors.right: parent.right
            id: logoutButton
            text: "LOGOUT"
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    project.id = -1
                    stackView.push("qrc:/Login.qml")
                }
            }
        }
    }
}
