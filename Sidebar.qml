import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import "qrc:/pages/" as Pages

Drawer {
    id: sidebarDrawer
    width: 0.2 * mainWindow.width
    height: mainWindow.height

    StackView {
        id: sidebarStackView
        anchors.fill: parent

        Column {
            anchors.fill: parent
            ItemDelegate {
                text: qsTr("Create new project")
                width: parent.width
                onClicked: {
                    bodyStackView.push("qrc:/pages/AddNewProductPage.qml")
                    drawer.close()
                }
            }
            ComboBox { // https://stackoverflow.com/questions/50745414/alignment-of-text-in-qt-combobox
                id: projectsCombobox
                width: sidebarStackView.width
                displayText: "Select Project"
                model: [ "TODO1", "TODO2", "TODO3" ]
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
}
