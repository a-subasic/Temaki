import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import MyQMLEnums 13.37
import QtQml.Models 2.1

import "qrc:/const.js" as Constants
import "qrc:/components"
import "qrc:/editors" as Editors

Page {
    title: "Board"
    id: board
    width: parent.width
    height: parent.height

    ListModel {
        id: tasksModel
    }

    property var memberUsernames: [] = []
    property var labelPriorities: [] = []
    property var labelTypes: [] = []

    signal multiselectChange;

    Component.onCompleted: {
        console.log("current project id", project.id)

        if(project.id !== -1) {
            initBoard()
        }
    }

    function initBoard() {
        /* Project labels */
        board.labelPriorities = [...new Set(label.project_labels.priorities.map(function(obj) {return obj.name;}))]
        board.labelTypes = [...new Set(label.project_labels.types.map(function(obj) {return obj.name;}))]
        multiselectChange()

        /* Project member */
        board.memberUsernames = user.project_members.map(function(obj) {return obj.username;})
        multiselectChange()

        /* Tasks */
        var t = task.project_tasks
        tasksModel.clear()
        for(var i in t) {
            tasksModel.append({
                "id": t[i].id,
                "owner_id": t[i].owner_id,
                "estimated_time": t[i].estimated_time,
                "spent_time": t[i].spent_time,
                "status_id": t[i].status_id,
                "title": t[i].title,
            })
        }
        noProjectLoader.active = false
        boardLoader.active = true
    }

    Connections {
        target: project
        function onIdChanged() {
            initBoard()
        }
    }

    Loader {
        id: noProjectLoader
        sourceComponent: noProjectComponent
        active: true
        anchors.fill: parent
    }

    Component {
        id: noProjectComponent

        Text {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            text: "No project selected"
        }
    }


    Loader {
        id: boardLoader
        sourceComponent: boardComponent
        active: false
        anchors.fill: parent
        anchors.margins: 5
    }

    Component {
        id: boardComponent

        ColumnLayout {
            anchors.fill: parent
            spacing: 5

            Item {
                id: actions
                height: 40
                Layout.fillWidth: true

                Connections {
                    target: board
                    onMultiselectChange: {
                        membersMultiselect.initComboboxItems(board.memberUsernames);
                        priorityMultiselect.initComboboxItems(board.labelPriorities);
                        typeMultiselect.initComboboxItems(board.labelTypes);
                    }
                }

                Row {
                    spacing: 5

                    Multiselect {
                        id: membersMultiselect
                        title: "Members"
                        items: board.memberUsernames

                    }

                    Multiselect {
                        id: priorityMultiselect
                        title: "Priority"
                        items: board.labelPriorities
                    }

                    Multiselect {
                        id: typeMultiselect
                        title: "Type"
                        items: board.labelTypes
                    }
                }

                Button {
                    anchors.right: parent.right
                    Layout.alignment: Qt.AlignRight
                    id: buttonAbout
                    text: "Create task"
                    onClicked: {
                        var d = createTaskComp.createObject(homeScreen, {"parent" : homeScreen});
                        d.open()
                    }
                }

                /* Create Task Component Dialog */
                Editors.CreateTask{
                    id: createTaskComp
                }
            }

            Item {
                id: item2
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    id: row
                    anchors.fill: parent
                    spacing: 10

                    Column {
                        Rectangle {
                            id: tasksContainer
                            width: item2.width/4 - 10 + row.spacing/4
                            height: item2.height
                            color: "lightgrey"
                            border.color: "grey"

                            Rectangle {
                                id: status1
                                width: parent.width
                                border.color: "black"
                                border.width: 2
                                color: "white"
                                height: 40

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Constants.Status.BACKLOG
                                }
                            }

                            ScrollView {
                                width: parent.width
                                height: parent.height - status1.height
                                anchors.top: status1.bottom
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
                                        width: tasksContainer.width
                                        height: status_id == Status.BACKLOG ? 105 : 0
                                        visible: status_id == Status.BACKLOG

                                        Rectangle {
                                            width: parent.width
                                            height: 100
                                            color: "green"

                                            Label {
                                                anchors.centerIn: parent
                                                text: title
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Column {
                        Rectangle {
                            width: item2.width/4 - 10 + row.spacing/4
                            height: item2.height
                            color: "lightgrey"
                            border.color: "grey"

                            Rectangle {
                                id: status2
                                width: parent.width
                                border.color: "black"
                                border.width: 2
                                color: "white"
                                height: 40

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Constants.Status.ACTIVE
                                }
                            }

                            ScrollView {
                                width: parent.width
                                height: parent.height - status2.height
                                anchors.top: status2.bottom
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
                                        width: tasksContainer.width
                                        height: status_id == Status.ACTIVE ? 105 : 0
                                        visible: status_id == Status.ACTIVE

                                        Rectangle {
                                            width: parent.width
                                            height: 100
                                            color: "green"

                                            Label {
                                                anchors.centerIn: parent
                                                text: title
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Column {
                        Rectangle {
                            width: item2.width/4 - 10 + row.spacing/4
                            height: item2.height
                            color: "lightgrey"
                            border.color: "grey"

                            Rectangle {
                                id: status3
                                width: parent.width
                                border.color: "black"
                                border.width: 2
                                color: "white"
                                height: 40

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Constants.Status.IN_REVIEW
                                }
                            }

                            ScrollView {
                                width: parent.width
                                height: parent.height - status3.height
                                anchors.top: status3.bottom
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
                                        width: tasksContainer.width
                                        height: status_id == Status.IN_REVIEW ? 105 : 0
                                        visible: status_id == Status.IN_REVIEW

                                        Rectangle {
                                            width: parent.width
                                            height: 100
                                            color: "green"

                                            Label {
                                                anchors.centerIn: parent
                                                text: title
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Column {
                        Rectangle {
                            width: item2.width/4 - 10 + row.spacing/4
                            height: item2.height
                            color: "lightgrey"
                            border.color: "grey"

                            Rectangle {
                                id: status4
                                width: parent.width
                                border.color: "black"
                                border.width: 2
                                color: "white"
                                height: 40

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Constants.Status.CLOSED
                                }
                            }

                            ScrollView {
                                width: parent.width
                                height: parent.height - status4.height
                                anchors.top: status4.bottom
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
                                        width: tasksContainer.width
                                        height: status_id == Status.CLOSED ? 105 : 0
                                        visible: status_id == Status.CLOSED

                                        Rectangle {
                                            width: parent.width
                                            height: 100
                                            color: "green"

                                            Label {
                                                anchors.centerIn: parent
                                                text: title
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

