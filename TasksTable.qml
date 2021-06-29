import QtQuick 2.0
import MyQMLEnums 13.37
import QtQml.Models 2.1
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import "qrc:/const.js" as Constants
import "qrc:/editors" as Editors

Item {
    id: exportTasksPage
    property var tasks: [] = []


    Component.onCompleted: {
        initTasks(exportTasksPage.tasks)
    }

    function getSelectedTasks() {
        var result = [];
        for (var j=0; j < tasksModel.count; j++)
        {
            if (tasksModel.get(j).selected === true)
            {
                result.push(tasksModel.get(j))
            }
        }
        return result;
    }

    function initTasks(tasks) {
        exportTasksPage.tasks = tasks;
        tasksModel.clear()

        for(var i in tasks) { // set membersModel values
            tasksModel.append({
                "title": tasks[i].title,
                "owner": tasks[i].owner,
                "estimated_time": tasks[i].estimated_time,
                "spent_time": tasks[i].spent_time,
                "status": "test",//Constants.Status[tasks[i].status_id],
                "label_priority": tasks[i].label_priority,
                "label_type": tasks[i].label_type,
                "selected": true,
            })
        }
    }

    Item {
        width: parent.width
        height: parent.height
        anchors.fill: parent
        anchors.margins: 25

        ListView {
            id: tasksListView
            anchors.fill: parent
            model: tasksModel
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
                        Layout.preferredWidth: parent.width / 8
                        text: "Title"
                    }
                    Label {
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: parent.width / 8
                        text: "Owner"
                    }
                    Label {
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: parent.width / 8
                        text: "Estimated time"
                    }
                    Label {
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: parent.width / 8
                        text: "Spent time"
                    }
                    Label {
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: parent.width / 8
                        text: "Status"
                    }
                    Label {
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: parent.width / 8
                        text: "Label Priority"
                    }
                    Label {
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: parent.width / 8
                        text: "Label Type"
                    }
                    Label {
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: parent.width / 8
                        text: "Action"
                    }
                }
            }
            delegate: tasksListDelegate
            clip: true

            /* Scrollbar and scroll behaviour */
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {}
        }
    }

    ListModel {
        id: tasksModel
    }


    /* Task Listview item */
    Component {
        id: tasksListDelegate
        Rectangle {
            height: 30
            width: tasksListView.width
            color: "lightgrey"

            RowLayout {
                anchors.centerIn: parent
                width: parent.width - 10
                height: parent.height - 10

                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width / 8
                    text: model.title
                }
                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width / 8
                    text: model.owner
                }
                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width / 8
                    text: model.estimated_time
                }
                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width / 8
                    text: model.spent_time
                }
                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width / 8
                    text: model.status
                }
                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width / 8
                    text: model.label_priority
                }
                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width / 8
                    text: model.label_type
                }
                Item {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width / 8
                    Layout.fillHeight: true
                    Button {
                        id: removeBtn
                        height: parent.height
                        text: model.selected ? "Remove" : "Add"
                        width: 60

                        background: Rectangle {
                            width: parent.width
                            height: parent.height
                            color: model.selected ? "gray" : "green"
                        }

                        onClicked: {
                            model.selected = !model.selected;
                        }
                    }
                }

            }
        }
    }
}
