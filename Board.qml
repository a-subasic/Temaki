import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import MyQMLEnums 13.37
import QtQml.Models 2.1
import QtQuick.Controls 2.13

import "qrc:/const.js" as Constants
import "qrc:/components"
import "qrc:/editors" as Editors
import "qrc:/pages/components"

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
        board.labelPriorities = [...new Set(label.project_labels.priorities.map(function(obj) {return {"id": obj.id, "name": obj.name};}))]
        board.labelTypes = [...new Set(label.project_labels.types.map(function(obj) {return {"id": obj.id, "name": obj.name};}))]
        multiselectChange()

        /* Project member */
        board.memberUsernames = user.project_members.map(function(obj) {return {"id": obj.id, "name": obj.username}})
        multiselectChange()

        /* Tasks */
        initTasks()
        noProjectLoader.active = false
        boardLoader.active = true
    }

    /* Reloads tasks into board */
    function initTasks() {
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
    }

    Connections {
        target: project
        function onIdChanged() {
            initBoard()
        }
    }

    Connections {
        target: task
        function onProjectTasksChanged() {
            initTasks()
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
                    function onMultiselectChange() {
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

                    TasksColumn {
                        statusLabel: Constants.Status.BACKLOG
                        statusId: Status.BACKLOG
                    }

                    TasksColumn {
                        statusLabel: Constants.Status.ACTIVE
                        statusId: Status.ACTIVE
                    }

                    TasksColumn {
                        statusLabel: Constants.Status.IN_REVIEW
                        statusId: Status.IN_REVIEW
                    }

                    TasksColumn {
                        statusLabel: Constants.Status.CLOSED
                        statusId: Status.CLOSED
                    }
                }
            }
        }
    }

    Item {
        id: dragContainer
        anchors.fill: parent
    }
}

