import QtQuick 2.0
import QtQuick.Controls 2.14

Page {
    title: "Board"
    width: parent.width
    height: parent.height
    Label {
        anchors.centerIn: parent
        text: user.username + user.id
    }
    Button {
        text: "ckucj ne"
        onClicked: project.getAllForUser(user.id)
    }
}
