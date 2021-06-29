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
    visible:false

    Editors.TasksTable {
        id: tasksTable
        width: parent.width
        height: parent.height
        tasks: task.project_tasks
    }

}

