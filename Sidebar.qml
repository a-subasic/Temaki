import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Window 2.2

Drawer {
    id: sidebar
    visible: true
    width: 0.2 * mainWindow.width
    height: mainWindow.height

    StackView {
        id: stackview
        anchors.fill: parent
        Column {
            spacing: 10
            anchors.top: parent.top
            Button {
                id: newProjectButton
                text: "Create new project"
                width: stackview.width
                onClicked: todo.pop()
            }
            ComboBox { // https://stackoverflow.com/questions/50745414/alignment-of-text-in-qt-combobox
                id: projectsCombobox
                width: stackview.width
                displayText: "Select Project"
                model: [ "TODO1", "TODO2", "TODO3" ]
            }

            Button {
                id: boardButton
                text: "Board"
                width: stackview.width
            }
            Button {
                id: membersButton
                text: "Members"
                width: stackview.width
            }
            Button {
                id: labelsButton
                text: "Labels"
                width: stackview.width
            }
            Button {
                id: analyticsButton
                text: "Analytics"
                width: stackview.width
            }
        }
    }
}

