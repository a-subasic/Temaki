import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

Dialog {
    id: createProjectDialog
    title: qsTr('Create Project')
    width: 550
    height: 450
    standardButtons: Dialog.Cancel | Dialog.Ok
    anchors.centerIn: parent

    onAccepted: console.log("Ok clicked")
    onRejected: console.log("Cancel clicked")

    Page {
        anchors.fill: parent

        Item {
            anchors.centerIn: parent
            width: 350
            height: 250


            Column {
                id: column
                anchors.fill: parent
                spacing: 10

                Label {
                    id: projectNameLabel
                    text: qsTr("Project name")
                }

                TextField {
                    id: projectNameTxt
                    width: parent.width
                    placeholderText: qsTr("")
                }

                Label {
                    id: membersLabel
                    text: qsTr("Members")
                }

                TextField {
                    id: membersTxt
                    width: parent.width
                    placeholderText: qsTr("todo: search users in db")
                }

                Label {
                    id: todo
                    text: qsTr("todo: list selected users")
                }

            }
        }
    }
}
