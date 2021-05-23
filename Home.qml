import QtQuick 2.12
import QtQuick.Layouts 1.13

import "qrc:/layouts" as Layouts

Item {
    id: homeScreen
    visible: true
    width: parent.width;
    height: parent.height;

    Layouts.Header {
        id: header
        width: parent.width
        Layout.preferredHeight: 40
        Layout.alignment: Qt.AlignRight
    }

    Layouts.Sidebar {
        id: sidebar
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignLeft
        topMargin: header.height
    }
}
