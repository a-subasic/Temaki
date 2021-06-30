import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import MyQMLEnums 13.37
import QtQml.Models 2.1
import QtQuick.Controls 2.13

import "qrc:/const.js" as Constants
import "qrc:/components"
import "qrc:/pages/components"
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

    property var memberFilter: [] = []
    property var labelPriorityFilter: [] = []
    property var labelTypeFilter: [] = []

    signal multiselectChange;
    signal initFilters;

    Component.onCompleted: {
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
        initFilters()

        var t = task.project_tasks
        tasksModel.clear()
        for(var i in t) {
            if (!memberFilter.includes(t[i].owner) && memberFilter.length != 0) continue
            if (!labelPriorityFilter.includes(t[i].label_priority) && labelPriorityFilter.length != 0) continue
            if (!labelTypeFilter.includes(t[i].label_type) && labelTypeFilter.length != 0) continue

            tasksModel.append({
                "id": t[i].id,
                "owner_id": t[i].owner_id,
                "estimated_time": t[i].estimated_time,
                "spent_time": t[i].spent_time,
                "status_id": t[i].status_id,
                "label_priority": t[i].label_priority,
                "label_type": t[i].label_type,
                "label_priority_id": t[i].label_priority_id,
                "label_type_id": t[i].label_type_id,
                "label_priority_color": t[i].label_priority_color,
                "label_type_color": t[i].label_type_color,
                "title": t[i].title,
                "owner": t[i].owner,
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

    Connections {
        target: label
        function onProjectLabelsChanged() {
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
                    function onMultiselectChange() {
                        membersMultiselect.initComboboxItems(board.memberUsernames);
                        priorityMultiselect.initComboboxItems(board.labelPriorities);
                        typeMultiselect.initComboboxItems(board.labelTypes);
                    }
                }

                Connections {
                    target: board
                    function onInitFilters() {
                        memberFilter = membersMultiselect.getSelectedItems().map(function(obj) { if (obj.selected )return obj.name})
                        labelPriorityFilter = priorityMultiselect.getSelectedItems().map(function(obj) { if (obj.selected )return obj.name})
                        labelTypeFilter = typeMultiselect.getSelectedItems().map(function(obj) { if (obj.selected )return obj.name})
                    }
                }

                Row {
                    spacing: 5

                    Multiselect {
                        id: membersMultiselect
                        title: "Members"
                        items: board.memberUsernames
                        onChecked: initTasks()
                    }

                    Multiselect {
                        id: priorityMultiselect
                        title: "Priority"
                        items: board.labelPriorities
                        onChecked: initTasks()
                    }

                    Multiselect {
                        id: typeMultiselect
                        title: "Type"
                        items: board.labelTypes
                        onChecked: initTasks()
                    }
                }

                Button {
                    anchors.right: parent.right
                    Layout.alignment: Qt.AlignRight
                    id: buttonAbout
                   visible: user ? user.role_id == User.Editor : false
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

