import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15

import "qrc:/pages" as Pages

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Temaki")

    Popup {
        id: popup
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Label {
            id: lblStatus
            anchors.centerIn: parent
            text: ""
        }
    }

    Pages.Login {
        id: login
        width: 250
        height: 200
        anchors.centerIn: parent
    }
}
