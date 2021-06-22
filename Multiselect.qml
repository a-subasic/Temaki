import QtQuick 2.7
import QtQuick.Controls 2.15

ComboBox {
    id: comboBox
    property string title: "Select"
    property var items: []

    displayText: title

    model: ListModel {
        id: cbItems
        ListElement { name: "One"; selected: false }
        ListElement { name: "Two"; selected: false }
        ListElement { name: "Three"; selected: false }
    }

    /* If there are any items defined, default combobox values will be replaced */
    Component.onCompleted: {
        if (items.length !== 0) initComboboxItems(comboBox.items)
    }

    function initComboboxItems(items) {
        cbItems.clear()
        for (var i in items) {
            cbItems.append({"name": items[i], "selected": false})
        }
    }

    // ComboBox closes the popup when its items (anything AbstractButton derivative) are
    //  activated. Wrapping the delegate into a plain Item prevents that.
    delegate: Item {
        width: parent ? parent.width : 0
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

