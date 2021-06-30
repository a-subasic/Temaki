import QtQuick 2.0
import MyQMLEnums 13.37
import QtQml.Models 2.1
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import "qrc:/const.js" as Constants
import "qrc:/editors" as Editors

Column {
    property string statusLabel
    property int statusId

    Rectangle {
        id: tasksContainer
        width: item2.width/4 - 10 + row.spacing/4
        height: item2.height
        color: "lightgrey"
        border.color: "grey"

        Rectangle {
            id: status
            width: parent.width
            border.color: "black"
            border.width: 2
            color: "white"
            height: 40

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: statusLabel
            }
        }

        DropArea {
            width: parent.width
            height: parent.height - status.height
            anchors.top: status.bottom
            keys: [statusLabel]

            onEntered: {
                backlogBorder.border.color = "red"
                drag.source.caught = true
            }
            onExited: {
                backlogBorder.border.color = "transparent"
                drag.source.caught = false
            }

            onDropped: {
                backlogBorder.border.color = "transparent"
                task.updateTaskStatus(drag.source.task_id, statusId)
                task.getForProjectByStatus(project.id)
                initTasks()
            }

            Rectangle {
                id: backlogBorder
                border.color: 'transparent';
                border.width: 4
                color: 'transparent'
                z: 1
                anchors.fill: parent
            }


            ScrollView {
                id: scroll
                width: parent.width
                height: parent.height
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.interactive: true

                ListView {
                    width: parent.width
                    height: parent.height
                    focus: true
                    orientation: Qt.Vertical

                    model: tasksModel
                    delegate: Item {
                        property string task_id: id
                        property var myData: model

                        id: taskDraggable

                        width: tasksContainer.width
                        height: status_id == statusId ? 210 : 0
                        visible: status_id == statusId

                        property point beginDrag
                        property bool caught: false

                        property Item dragParent: dragContainer

                        Drag.active: dragArea.drag.active

                        Drag.keys: Object.keys(Constants.Status).filter(function(key) {
                                       return Constants.Status[key] !== statusLabel ? true : false
                                   })
                                   .map(function(key) {return Constants.Status[key]})

                        Rectangle {
                            id: taskContent
                            radius: 10
                            width: parent.width
                            height: 205
                            color: "lightblue"
                            border.color: "darkgrey"
                            border.width: 1
                            z: 2

                            Column {
                                anchors.fill: parent
                                anchors.margins: 5
                                spacing: 5

                                Text {
                                    verticalAlignment: Text.AlignVCenter
                                    width: taskContent.width - 10
                                    height: 40
                                    font.pointSize: 9
                                    wrapMode: Text.WordWrap
                                    text: title
                                }

                                Text {
                                    text: owner ? "Owner: " + owner : "Owner: Not assigned"
                                }

                                Text {
                                    property var priorityLabel: {"id": label_priority_id, "name": label_priority }
                                    Component.onCompleted: {
                                        myData["priorityLabelId"] = label_priority_id
                                    }
                                    text: label_priority ? "Priority: " + label_priority : "Priority: Not selected"
                                    color: label_priority_color ? label_priority_color : "black"
                                }

                                Text {
                                    property var typeLabel: {"id": label_type_id, "name": label_type }
                                    Component.onCompleted: {
                                        myData["typeLabelId"] = label_type_id
                                    }
                                    text: label_type ? "Type: " + label_type : "Type: Not selected"
                                    color: label_type_color ? label_type_color : "black"
                                }

                                Text {
                                    text: "Estimated time: " + estimated_time + "h"
                                }

                                Text {
                                    text: "Spent time: " + spent_time + "h"
                                }

                                Button {
                                    text: "Edit"
                                    height: 20
                                    visible: user.role_id == User.Editor
                                    Layout.alignment: Qt.AlignHCenter

                                    onClicked: {
                                        var d = editTaskComponent.createObject(homeScreen, { "parent" : homeScreen, "currentTask": myData });
                                        d.open()
                                    }
                                }

                                /* Edit Task Dialog */
                                Editors.EditTask {
                                    id: editTaskComponent
                                }

                                Text {
                                    font.pointSize: 6
                                    text: "#" + id
                                }
                            }
                        }

                        MouseArea {
                            id: dragArea
                            anchors.fill: parent
                            drag.target: taskDraggable

                            onPressed: {
                                taskContent.border.color = "darkblue"
                                taskDraggable.beginDrag = Qt.point(taskDraggable.x, taskDraggable.y);
                            }

                            onReleased: {
                                taskContent.border.color = "grey"
                                if(taskDraggable.caught) {
                                     taskDraggable.Drag.drop()
                                }
                            }
                        }

                        states: State {
                            when: dragArea.drag.active
                            ParentChange { target: taskDraggable; parent: dragParent }
                        }
                    }
                }
            }
        }
    }
}
