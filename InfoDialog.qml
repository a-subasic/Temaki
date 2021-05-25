import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

Dialog {
    property string dialogTitle: "Title"
    property string description: "Description"

    title: dialogTitle
    standardButtons: Dialog.Ok
    anchors.centerIn: parent

    onAccepted: console.log("Ok clicked")
    onRejected: console.log("Cancel clicked")

    Text {
        text: description
    }

}
