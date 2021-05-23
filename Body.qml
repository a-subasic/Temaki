import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

StackView {
    initialItem: "qrc:/pages/Board.qml"
    Layout.fillWidth: true
    anchors.top: header.bottom
    width: parent.width
    height: parent.width

    // animations: https://stackoverflow.com/questions/22784691/qml-stackview-custom-transition
    pushEnter: Transition {
        PropertyAnimation{
            property: "opacity"
            from: 0
            to: 1
            duration: 300
        }
    }

    pushExit: Transition {
        PropertyAnimation{
            property: "opacity"
            from: 1
            to: 0
            duration: 250
        }
    }
}

