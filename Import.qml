import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtQml.Models 2.1

import "qrc:/const.js" as Constants
import "qrc:/editors" as Editors

Page {
    property var tasksToImport
    id: importTasksPage
    width: parent.width
    height: parent.height
    visible: false

    Column {
        width: parent.width
        height: parent.height

        Editors.TasksTable {
            id: tasksTable
            width: parent.width
            height: parent.height - 65
            tasks: tasksToImport
        }

        Button {
            anchors.rightMargin: 25
            anchors.right: parent.right
            Layout.alignment: Qt.AlignRight
            text: "Import"
            onClicked: {
                var importTasks = tasksTable.getSelectedTasks();

                importTasks.forEach(t => {
                    task.create(
                        t.title,
                        project.id,
                        t.estimated_time,
                        t.spent_time,
                        task.statusExists(t.status),
                        label.labelExists(t.label_type),
                        label.labelExists(t.label_priority),
                        user.usernameExists(t.owner))
                    }
                )
            }
        }
    }
}

