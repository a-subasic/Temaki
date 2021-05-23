import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15

import "qrc:/pages" as Pages

Window {
    id: mainWindow
    width: 900
    height: 680
    visible: true
    title: qsTr("Temaki")

    /*
    Loader {
        source:"Home.qml";
        width: parent.width;
        height: parent.height;
    }*/

    StackView {
        id: stackView
        initialItem: Qt.resolvedUrl("pages/Login.qml")
        anchors.fill: parent
        visible: true
    }
}
