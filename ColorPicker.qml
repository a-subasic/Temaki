import QtQuick 2.0
import QtQuick.Dialogs 1.0

Component {
    id: colorPickerComp

    ColorDialog {
        id: colorDialog
        title: "Please choose a color"

        onVisibleChanged: if(!visible) destroy(1)
    }
}
