import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtQml.Models 2.1

import "qrc:/const.js" as Constants
import "qrc:/editors" as Editors

Page {
    id: exportTasksPage
    width: parent.width
    height: parent.height


    Column {
        width: parent.width
        height: parent.height

        Editors.TasksTable {
            id: tasksTable
            width: parent.width
            height: parent.height - 200
            tasks: task.project_tasks
        }

        Button {
            height: 40
            width: 60
            text: "Export to file"
            onClicked: {
                fileDialog.open()
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose file destination"
        selectFolder: true
        folder: shortcuts.desktop
        onAccepted: {
            var path = fileDialog.fileUrl.toString();
            path = path.replace(/^(file:\/{3})/,"");
            var cleanPath = decodeURIComponent(path);

            var tasksToExport = tasksTable.getSelectedTasks()

            tasksToExport.forEach(t => {
                task.exportToFile(cleanPath, project.name, t.title, t.spent_time, t.estimated_time, t.satus, t.owner, t.label_type, t.label_priority)
            })
        }
    }

}

