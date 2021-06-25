import QtQuick 2.7
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.1

import "qrc:/components"
import "qrc:/layouts" as Layouts
import "qrc:/editors"

Component {
    id: createTaskComp

    Dialog {
        id: createTaskDialog
        visible:false
        title: qsTr('Create Task - wip')
        width: 550
        height: 450
        standardButtons: Dialog.Discard | Dialog.Save
        anchors.centerIn: parent

        Component.onCompleted: {
            initMembers()
            initLabels()
        }

        function initMembers(){
            var memberList = user.project_members
            membersModel.clear()
            for(var i in memberList) {
                membersModel.append({"id": memberList[i].id, "name": memberList[i].username})
            }
        }

        function initLabels(){
            var labels = label.getLabels()
            var labelItems = labels.map(function(obj) {return {"id": obj.id, "name": obj.name}})
            labelMultiselect.initComboboxItems(labelItems)
        }

        ListModel {
            id: membersModel
        }

        onAccepted: {
            /* Validate Task title */
            if (taskTitleText.input.text.length == 0) {
                failedDialog.description = "Title is required!";
                createTaskDialog.open()
                failedDialog.open()
                return
            }

            /* Create Task */
            //var success = project.create(projectNameTxt.input.text, addMembersForm.selectedUserIds, user.id);

            /* If Creation failed, show message */
            if(!success) {
                failedDialog.description = "Task creation failed.";
                createTaskDialog.open()
                failedDialog.open()
                return
            } else {
                //sidebar.reloadProjects()
            }
        }

        onDiscarded: {
            createTaskDialog.close()
            createTaskDialog.destroy()
            console.log("Discard clicked!");
        }

        Page {
            id: taskForm
            width: parent.width
            height: parent.height - 60

            Column {
                id: column
                anchors.fill: parent
                spacing: 10
                Input {
                    id: taskTitleText
                    labelName: "Title"
                    errorText: "Title is required"
                }

                Label {
                    id: selectedOwnerId
                    visible: false
                }

                ComboBox {
                    property bool isSelected: false
                    id: membersCombobox
                    width: taskForm.width
                    displayText: "Assign Member"
                    textRole: "name"
                    model: membersModel
                    onCurrentTextChanged: {
                        isSelected = true
                        membersCombobox.displayText = membersCombobox.currentText
                        selectedOwnerId.text = membersModel.get(currentIndex).id
                    }
                }

                Multiselect {
                    id: labelMultiselect
                    title: "Labels"
                }

                Item {
                    width: parent.width
                    height: 80

                    Column {
                        anchors.fill: parent

                        Label {
                            text: "Estimated time (hours)"
                            height: 25
                        }

                        SpinBox {
                            id: estimatedTimeText
                        }
                    }
                }

            }
        }

        InfoDialog {
            id: failedDialog
            dialogTitle: "Create Task"
            description: ""
        }
    }
}
