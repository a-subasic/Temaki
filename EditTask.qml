import QtQuick 2.7
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.1

import "qrc:/components"
import "qrc:/layouts" as Layouts
import "qrc:/editors"


Component {
    id: editTaskComp

    Dialog {
        property var currentTask

        id: editTaskDialog
        visible:false
        title: qsTr('Edit task')
        width: 400
        height: 400
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
           for(var i in labels) {
               if (labels[i].type === "Priority") {
                   labelPriorityModel.append({"id": labels[i].id, "name": labels[i].name})
               } else {
                   labelTypeModel.append({"id": labels[i].id, "name": labels[i].name})
               }
           }
        }

        function findElement(myModel, myId) {
           for(var i = 0; i < myModel.count; i++) {
               var element = myModel.get(i);

               if(parseInt(myId) === parseInt(element.id)) {
                   return i;
               }
           }
        }

        ListModel {
           id: membersModel
        }

        ListModel {
           id: labelTypeModel
        }

        ListModel {
           id: labelPriorityModel
        }

        onAccepted: {
            /* Validate Task title */
            if (!taskTitleText.isValid) {
                failedDialog.description = "Title is required!";
                createTaskDialog.open()
                failedDialog.open()
                return
            }

            /* Create Task */
            var labelPriorityId = labelPriorityCombobox.isSelected ? labelPriorityCombobox.model.get(labelPriorityCombobox.currentIndex).id : null
            var labelTypeId = labelTypeCombobox.isSelected ? labelTypeCombobox.model.get(labelTypeCombobox.currentIndex).id : null
            var ownerId = membersCombobox.isSelected ? membersCombobox.model.get(membersCombobox.currentIndex).id : null

            var success = task.update(project.id, currentTask.id, taskTitleText.input.text, estimatedTimeText.value, spentTimeText.value, labelTypeId, labelPriorityId, ownerId);

            /* If Creation failed, show message */
            if(!success) {
                failedDialog.description = "Task creation failed.";
                editTaskDialog.open()
                failedDialog.open()
                return
            } else {
                //sidebar.reloadProjects()
            }
        }

        onDiscarded: {
            editTaskDialog.close()
            editTaskDialog.destroy()
            console.log("Discard clicked!");
        }

        Page {
            id: taskForm
            width: parent.width
            height: parent.height - 60

            Column {
                id: column
                anchors.fill: parent
                spacing: 20

                Input {
                    id: taskTitleText
                    inputText: currentTask.title
                    labelName: "Title"
                    errorText: "Title is required"
                    validatorRegex: "^[A-Za-z0-9 _]*[A-Za-z0-9][A-Za-z0-9 _]*$"
                }

                ComboBox {
                   property bool isSelected: false
                   id: membersCombobox
                   displayText: "Assign Member"
                   textRole: "name"
                   width: parent.width
                   model: membersModel
                   currentIndex: currentTask.owner_id ? findElement(membersModel, currentTask.owner_id) : -1
                   onCurrentTextChanged: {
                       membersCombobox.displayText = membersCombobox.currentText
                       isSelected = true
                   }
                }

                Row {
                   width: parent.width
                   spacing: 10

                   ComboBox {
                       property bool isSelected: false
                       id: labelTypeCombobox
                       displayText: "Select Label"
                       textRole: "name"
                       width: parent.width/2 - parent.spacing/2
                       model: labelTypeModel
                       currentIndex: currentTask.typeLabelId ? findElement(labelTypeModel, currentTask.typeLabelId) : -1
                       onCurrentTextChanged: {
                           labelTypeCombobox.displayText = labelTypeCombobox.currentText
                           isSelected = true
                       }
                   }

                   ComboBox {
                       property bool isSelected: false
                       id: labelPriorityCombobox
                       displayText: "Select Priority"
                       textRole: "name"
                       width: parent.width/2 - parent.spacing/2
                       model: labelPriorityModel
                       currentIndex: currentTask.priorityLabelId ? findElement(labelPriorityModel, currentTask.priorityLabelId) : -1
                       onCurrentTextChanged: {
                           labelPriorityCombobox.displayText = labelPriorityCombobox.currentText
                           isSelected = true
                       }
                   }
                }

                Row {
                    width: parent.width
                    spacing: 10

                    Column {
                        width: parent.width/2-5
                        spacing: 5
                        Label {
                            text: "Estimated time (hours)"
                        }

                        SpinBox {
                            width: parent.width
                            id: estimatedTimeText
                            value: currentTask.estimated_time
                        }
                    }

                    Column {
                        width: parent.width/2-5
                        spacing: 5
                        Label {
                            text: "Spent time (hours)"
                        }

                        SpinBox {
                            width: parent.width
                            id: spentTimeText
                            value: currentTask.spent_time
                        }
                    }
                }
            }

        }

        InfoDialog {
            id: failedDialog
            dialogTitle: "Create Task"
        }
    }
}
