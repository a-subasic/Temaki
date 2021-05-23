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

    StackView {
        id: stackView
        initialItem: Qt.resolvedUrl("pages/Login.qml")
        anchors.fill: parent
        visible: true
    }
}
