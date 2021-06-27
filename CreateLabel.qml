import QtQuick 2.7
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.1
import QtQuick.Dialogs 1.0

import "qrc:/components"
import "qrc:/layouts" as Layouts
import "qrc:/editors"

Component {
    id: createLabelComp

    Dialog {
        id: createLabelDialog

        visible:false
        title: qsTr('Create Label')
        width: 400
        height: 350
        standardButtons: Dialog.Discard | Dialog.Save
        anchors.centerIn: parent

        Component.onCompleted: {
            initLabelTypesEnum()
        }

        function initLabelTypesEnum(){
            var labelTypes = label.getLabelTypesEnum()
            for(var i in labelTypes) {
                labelTypesModel.append({"id": labelTypes[i].id, "name": labelTypes[i].name})
            }
        }

        ListModel {
            id: labelTypesModel
        }

        onAccepted: {
            /* Validate Label name */
            if (!labelName.isValid) {
                failedDialog.description = "Name is required!";
                createLabelDialog.open()
                failedDialog.open()
                return
            }

            /* Validate Label type */
            if (!labelTypeCombobox.isSelected) {
                failedDialog.description = "Select Label type!";
                createLabelDialog.open()
                failedDialog.open()
                return
            }

            /* Create Label */
            var labelTypeId = labelTypeCombobox.model.get(labelTypeCombobox.currentIndex).id

            var success = label.create(labelName.input.text, labelTypeId, selectedColor.color);

            /* If Creation failed, show message */
            if(!success) {
                failedDialog.description = "Label creation failed.";
                createLabelDialog.open()
                failedDialog.open()
                return
            }
        }

        onDiscarded: {
            createLabelDialog.close()
            createLabelDialog.destroy()
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
                    id: labelName
                    labelName: "Name"
                    errorText: "Name is required"
                    validatorRegex: "^[A-Za-z0-9 _]*[A-Za-z0-9][A-Za-z0-9 _]*$"
                }

                ComboBox {
                    property bool isSelected: false
                    id: labelTypeCombobox
                    displayText: "Select Label Type"
                    textRole: "name"
                    width: parent.width
                    model: labelTypesModel
                    onCurrentTextChanged: {
                        labelTypeCombobox.displayText = labelTypeCombobox.currentText
                        isSelected = true
                    }
                }

                Button {
                    text: "Select Color"
                    background: Rectangle {
                        id: selectedColor
                        width: parent.width
                        height: parent.height
                        color: "gray"
                    }

                    onClicked: {
                        var colorDialog = colorPickerDialog.createObject(labelsPage, {"parent" : labelsPage});

                        colorDialog.accepted.connect(function(){
                            selectedColor.color = colorDialog.color
                        })

                        colorDialog.visible = true
                    }
                }

            }

        }

        InfoDialog {
            id: failedDialog
            dialogTitle: "Create Label"
            description: ""
        }

        ColorPicker {
            id: colorPickerDialog
        }
    }
}
