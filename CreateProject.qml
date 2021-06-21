import QtQuick 2.7
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.1

import "qrc:/components"
import "qrc:/layouts" as Layouts
import "qrc:/editors"

Component {
    id: createProjectComp
    Dialog {
        id: createProjectDialog
        visible:false
        title: qsTr('Create Project')
        width: 550
        height: 450
        standardButtons: Dialog.Discard | Dialog.Save
        anchors.centerIn: parent

        onAccepted: {

            /* Validate Project name */
            if (projectNameTxt.input.text.length == 0) {
                failedDialog.description = "Project name is required!";
                createProjectDialog.open()
                failedDialog.open()
                return
            }

            /* Validate selected project members */
            if (addMembersForm.selectedUserIds.length === 0) {
                failedDialog.description = "Select at least one project member!";
                createProjectDialog.open()
                failedDialog.open()
                return
            }

            /* Create Project */
            var success = project.create(projectNameTxt.input.text, addMembersForm.selectedUserIds, user.id);

            /* If Creation failed, show message */
            if(!success) {
                failedDialog.description = "Project creation failed.";
                createProjectDialog.open()
                failedDialog.open()
                return
            } else {
                sidebar.reloadProjects()
            }
        }

        onDiscarded: {
            createProjectDialog.close()
            createProjectDialog.destroy()
            console.log("Discard clicked!");
        }

        Page {
            id: projectForm
            width: parent.width
            height: parent.height

            Input {
                id: projectNameTxt
                labelName: "Project name"
                errorText: "Project name is required"
            }

            AddMembers{
                id: addMembersForm
                anchors.top: projectNameTxt.bottom
                width: parent.width
                height: parent.height - 20
            }
        }

        InfoDialog {
            id: failedDialog
            dialogTitle: "Create Project Failed"
            description: ""
        }
    }
}
