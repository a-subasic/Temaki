import QtQuick.Layouts 1.3
import MyQMLEnums 13.37
import QtQml.Models 2.1

import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.0

import "qrc:/const.js" as Constants
import "qrc:/components"
import "qrc:/editors" as Editors

Page {
    title: "Labels"
    id: labelsPage
    width: parent.width
    height: parent.height

    Component.onCompleted: {
        label.getLabels()
        initLabels()
    }

    /* clear labelsModel (listView) and set values to labelsList */
    function initLabels() {
        labelsModel.clear() // clear current labelsModel
        for(var i in label.all_labels) { // set labelsModel values
            labelsModel.append({
                "id": label.all_labels[i].id,
                "name": label.all_labels[i].name,
                "type_id": label.all_labels[i].type_id,
                "type": label.all_labels[i].type,
                "color": label.all_labels[i].color,
            })
        }
        labelsLoader.active = true
    }

    /* reset labelsModel to labelsList and filter values */
    function filterProjectLabels(text) {
        initLabels()
        // Remove all project labels not containing filter text
        for (var j=0; j < labelsModel.count; j++)
        {
            if (labelsModel.get(j).name.includes(text) === false &&
                labelsModel.get(j).type.includes(text) === false &&
                labelsModel.get(j).color.includes(text) === false)
            {
                labelsModel.remove(j);
                j=-1; //read from the start! Because index has changed after removing
            }
        }
    }

    Connections {
        target: label
        function onLabelsChanged() {
            initLabels()
        }
    }

    Loader {
        id: labelsLoader
        sourceComponent: labelsComponent
        active: false
        anchors.fill: parent
        anchors.margins: 25
    }

    Component {
        id: labelsComponent

        ColumnLayout {
            anchors.fill: parent

            Item {
                id: actions
                height: 25
                Layout.fillWidth: true

                SearchBox {
                    id: filterLabels
                    height: parent.height
                    placeholder: "Search labels..."
                    onFilterChanged: {
                        labelsPage.filterProjectLabels(text)
                    }
                }

                Button {
                    anchors.right: parent.right
                    Layout.alignment: Qt.AlignRight
                    height: parent.height
                    id: createLabelBtn
                    visible: user.role_id == User.Editor
                    text: "Create new Label"
                    onClicked: {
                        var d = createLabelDialog.createObject(homeScreen, {"parent" : homeScreen});
                        d.open()
                    }
                }

            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 15

                ListView {
                    id: labelsListView
                    anchors.fill: parent
                    model: labelsModel
                    header: Rectangle {
                        width: parent.width
                        height: 30
                        border.color: "black"
                        color: "gray"

                        RowLayout {
                            anchors.centerIn: parent
                            width: parent.width - 10
                            height: parent.height - 10

                            Label {
                                Layout.alignment: Qt.AlignLeft
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Name"
                            }
                            Label {
                                Layout.alignment: Qt.AlignLeft
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Type"
                            }
                            Label {
                                Layout.alignment: Qt.AlignLeft
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Color"
                            }
                            Label {
                                Layout.alignment: Qt.AlignLeft
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Action"
                            }
                        }
                    }
                    delegate: labelsListDelegate
                    clip: true

                    /* Scrollbar and scroll behaviour */
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.vertical: ScrollBar {}
                }
            }
        }
    }

    ListModel {
        id: labelsModel
    }


    /* Label Listview item */
    Component {
        id: labelsListDelegate
        Rectangle {
            height: 30
            width: labelsLoader.width
            color: "lightgrey"

            RowLayout {
                anchors.centerIn: parent
                width: parent.width - 10
                height: parent.height - 10

                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width * 0.25
                    text: model.name
                }
                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width * 0.25
                    text: model.type

                }
                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width * 0.25
                    color: model.color
                    text: model.color
                }
                Item {
                    Layout.alignment: Qt.AlignLeft
                    width: parent.width * 0.25
                    Layout.fillHeight: true
                    Button {
                        id: removeBtn
                        height: parent.height
                        text: "Remove"
                        visible: user.role_id == User.Editor
                        onClicked: {
                            var description = "Are you sure you want to remove label '" + model.name + "'?"
                            var confirmDialog = confirmationComp.createObject(labelsPage, {"dialogDescription" : description});

                            confirmDialog.accepted.connect(function(){
                                label.removeLabel(project.id, model.id)
                                task.getForProjectByStatus(project.id)
                            })

                            confirmDialog.rejected.connect(function(){
                                console.log("rejected")
                            })

                            confirmDialog.visible = true
                        }
                    }
                }

            }
        }
    }

    Editors.CreateLabel {
        id: createLabelDialog

    }

    InfoDialog {
        id: failedDialog
        dialogTitle: "Add Label"
        description: ""
    }

    ConfirmationDialog {
        id: confirmationComp
    }
}
