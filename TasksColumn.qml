import QtQuick 2.0
import QtQuick.Controls 2.14
import MyQMLEnums 13.37
import QtQml.Models 2.1

import "qrc:/const.js" as Constants

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
                initBoard()
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

                        id: taskDraggable

                        width: tasksContainer.width
                        height: status_id == statusId ? 105 : 0
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
                            width: parent.width
                            height: 100
                            color: "green"

                            Label {
                                anchors.centerIn: parent
                                text: title
                            }
                        }

                        MouseArea {
                            id: dragArea
                            anchors.fill: parent
                            drag.target: taskDraggable

                            onPressed: {
                                scroll.clip = false
                                taskDraggable.beginDrag = Qt.point(taskDraggable.x, taskDraggable.y);
                            }

                            onReleased: {
                                scroll.clip = true
                                if(taskDraggable.caught) {
//                                    backAnimX.from = taskDraggable.x;
//                                    backAnimX.to = beginDrag.x;
//                                    backAnimY.from = taskDraggable.y;
//                                    backAnimY.to = beginDrag.y;
//                                    backAnim.start()

                                     taskDraggable.Drag.drop()
                                }
                            }
                        }

//                        ParallelAnimation {
//                           id: backAnim
//                           SpringAnimation { id: backAnimX; target: taskDraggable; property: "x"; duration: 250; spring: 1; damping: 0.1 }
//                           SpringAnimation { id: backAnimY; target: taskDraggable; property: "y"; duration: 250; spring: 1; damping: 0.1 }
//                        }

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
