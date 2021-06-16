import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import "qrc:/pages/" as Pages

Drawer {
    id: sidebarDrawer
    width: 0.2 * mainWindow.width
    height: mainWindow.height

    ListModel {
        id: projectsModel
    }

    Component.onCompleted: {
        var p = project.getAllForUser(user.id);
        for(var i in p) {
            projectsModel.append({"id": p[i].id, "name": p[i].name})
        }
    }

    StackView {
        id: sidebarStackView
        anchors.fill: parent

        Column {
            anchors.fill: parent
            ItemDelegate {
                text: qsTr("Create new project")
                width: parent.width
                onClicked: {
                    createProjectDialog.open()
                    sidebarDrawer.close()
                }
            }

            ComboBox { // https://stackoverflow.com/questions/50745414/alignment-of-text-in-qt-combobox
                id: projectsCombobox
                width: sidebarStackView.width
                displayText: "Select Project"
                textRole: "name"
                model: projectsModel
                onCurrentTextChanged: {
                    projectsCombobox.displayText = projectsCombobox.currentText
                    project.id = projectsModel.get(currentIndex).id
                    project.name = projectsModel.get(currentIndex).name
                }
            }

            ItemDelegate {
                text: qsTr("Board")
                width: parent.width
                onClicked: {
                    bodyStackView.push("qrc:/pages/Board.qml")
                    sidebarDrawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Members")
                width: parent.width
                onClicked: {
                    bodyStackView.push("qrc:/pages/Members.qml")
                    sidebarDrawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Labels")
                width: parent.width
                onClicked: {
                    bodyStackView.push("qrc:/pages/Labels.qml")
                    sidebarDrawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Analytics")
                width: parent.width
                onClicked: {
                    bodyStackView.push("qrc:/pages/Analytics.qml")
                    sidebarDrawer.close()
                }
            }
        }
    }
    Row {
        height: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: sidebarDrawer.horizontalCenter
        width: parent.width

        Button {
            text: "Import"
            width: parent.width/2
        }
        Button {
            text: "Export"
            width: parent.width/2
        }
    }
}
