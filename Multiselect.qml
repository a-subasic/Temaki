import QtQuick 2.7
import QtQuick.Controls 2.15

ComboBox {
    id: comboBox

    property string title: "Select"
    property var maxHeight: 250
    property var items: []

    displayText: title

    model: ListModel {
        id: cbItems
    }

    /* Multiselect popup height and scroll behaviour */
    popup: Popup {
        y: comboBox.height + 1
        width: comboBox.width
        implicitHeight: contentItem.implicitHeight > maxHeight ? maxHeight : contentItem.implicitHeight;
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: comboBox.popup.visible ? comboBox.delegateModel : null
            currentIndex: comboBox.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    /* If there are any items defined, default combobox values will be replaced */
    Component.onCompleted: {
        if (items.length !== 0) initComboboxItems(comboBox.items)
    }

    function initComboboxItems(items) {
        cbItems.clear()
        for (var i in items) {
            cbItems.append({"id": items[i].id, "name": items[i].name, "selected": false})
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

