import QtQuick 2.0
import QtQuick.Controls 2.15

ComboBox {
    id: comboBox
    property string title: "Select"

    displayText: title

    model: ListModel {
        ListElement { name: "One"; selected: false }
        ListElement { name: "Two"; selected: false }
        ListElement { name: "Three"; selected: false }
    }

    // ComboBox closes the popup when its items (anything AbstractButton derivative) are
    //  activated. Wrapping the delegate into a plain Item prevents that.
    delegate: Item {
        width: parent.width
        height: checkDelegate.height

        function toggle() { checkDelegate.toggle() }

        CheckDelegate {
            id: checkDelegate
            anchors.fill: parent
            text: model.name
            highlighted: comboBox.highlightedIndex == index
            checked: model.selected
            onCheckedChanged: model.selected = checked
        }
    }

    // override space key handling to toggle items when the popup is visible
    Keys.onSpacePressed: {
        if (comboBox.popup.visible) {
            var currentItem = comboBox.popup.contentItem.currentItem
            if (currentItem) {
                currentItem.toggle()
                event.accepted = true
            }
        }
    }

    Keys.onReleased: {
        if (comboBox.popup.visible)
            event.accepted = (event.key === Qt.Key_Space)
    }
}

