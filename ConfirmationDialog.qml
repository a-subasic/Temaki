import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

/*
  Confirmation Dialog
----------------------------------------------------------------------------------------------------------------
    Usage:
        - Use when user confirmation is required
        - set dialogTitle, description
        - define actions rejected/accepted
----------------------------------------------------------------------------------------------------------------
    Example:
        - check usage example in '/pages/Members.qml'

        ...
        onClicked: {
            var confirmDialog = confirmationComp.createObject(membersPage, {"dialogDescription" : "some text"});

            confirmDialog.accepted.connect(function(){
                console.log("accepted")
            })
            confirmDialog.rejected.connect(function(){
                console.log("rejected")
            })
            confirmDialog.visible = true
        }
        ...

        ConfirmationDialog {
            id: confirmationComp
        }
----------------------------------------------------------------------------------------------------------------
*/

Component {
    id: confirmationComp

    MessageDialog {
        id: confirmationDialog

        property string dialogTitle: "Please confirm."
        property string dialogDescription: ""

        signal rejected;
        signal accepted;

        title: dialogTitle
        text: dialogDescription
        icon: StandardIcon.Warning

        onVisibleChanged: if(!visible) destroy(1)

        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: accepted()
        onNo: rejected()
    }
}

