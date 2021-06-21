import QtQuick 2.7
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import MyQMLEnums 13.37
import QtQml.Models 2.1

import "qrc:/const.js" as Constants
import "qrc:/components"
import "qrc:/editors" as Editors

Page {
    title: "Members"
    id: membersPage
    width: parent.width
    height: parent.height

    Component.onCompleted: {
        if(project.id !== -1) getProjectMembers(project.id)
    }

    function filterProjectMembers(text) {
        // Get all project members
        getProjectMembers(project.id)

        // Remove all project members not containing filter text
        for (var j=0; j< membersModel.count; j++)
        {
            if (membersModel.get(j).username.includes(text) === false &&
                membersModel.get(j).email.includes(text) === false &&
                membersModel.get(j).role_id.includes(text) === false)
            {
                membersModel.remove(j);
                j=-1; //read from the start! Because index has changed after removing
            }
        }
    }

    function getProjectMembers(id) {
        membersModel.clear()
        var members = user.getProjectMembers(id)
        for(var i in members) {
            membersModel.append({
                "id": members[i].id,
                "username": members[i].username,
                "email": members[i].email,
                "role_id": members[i].role_id,
            })
        }

        noProjectLoader.active = false
        membersLoader.active = true
    }

    Connections {
        target: project

        function onIdChanged(id) {
            membersPage.getProjectMembers(id)
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
        id: membersLoader
        sourceComponent: membersComponent
        active: false
        anchors.fill: parent
        anchors.margins: 25
    }

    Component {
        id: membersComponent

        ColumnLayout {
            anchors.fill: parent

            Item {
                id: actions
                height: 25
                Layout.fillWidth: true

                SearchBox {
                    id: filterMembers
                    height: parent.height
                    placeholder: "Search members..."
                    onFilterChanged: {
                        //console.log(text)
                        membersPage.filterProjectMembers(text)
                    }
                }

                Button {
                    anchors.right: parent.right
                    Layout.alignment: Qt.AlignRight
                    height: parent.height
                    id: addNewMembersButton
                    text: "Add New Members"
                    onClicked: {
                        var d = addMembersComp.createObject(homeScreen, {"parent" : homeScreen});
                        d.open()
                    }
                }

            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 15

                ListView {
                    id: membersListView
                    anchors.fill: parent
                    model: membersModel
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
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Username"
                            }
                            Label {
                                Layout.alignment: Qt.AlignLeft
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Email"
                            }
                            Label {
                                Layout.alignment: Qt.AlignLeft
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Role"
                            }
                            Label {
                                Layout.alignment: Qt.AlignLeft
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Action"
                            }
                        }
                    }
                    delegate: membersListDelegate
                    clip: true

                    /* Scrollbar and scroll behaviour */
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.vertical: ScrollBar {}
                }
            }
        }
    }

    ListModel {
        id: membersModel
    }


    /* Member Listview item */
    Component {
        id: membersListDelegate
        Rectangle {
            height: 30
            width: membersLoader.width
            color: "lightgrey"

            RowLayout {
                anchors.centerIn: parent
                width: parent.width - 10
                height: parent.height - 10

                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width * 0.25
                    text: model.username
                }
                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width * 0.25
                    text: model.email

                }
                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: parent.width * 0.25
                    text: model.role_id
                }
                Item {
                    Layout.alignment: Qt.AlignLeft
                    width: parent.width * 0.25
                    Layout.fillHeight: true
                    Button {
                        height: parent.height
                        text: "Remove"
                        onClicked: {
                        }
                    }
                }
            }
        }
    }

    Component {
        id: addMembersComp
        Dialog {
            id: addMembersDialog
            title: "Add Members"
            width: 550
            height: 450
            standardButtons: Dialog.Discard | Dialog.Save
            anchors.centerIn: parent

            Editors.AddMembers {
                id: addMembersForm
                anchors.top: addMembersDialog.top
                width: parent.width
                height: parent.height - 20
            }

            onAccepted: {
                /* Validate selected project members */
                if (addMembersForm.selectedUserIds.length === 0) {
                    failedDialog.description = "Select at least one project member!";
                    addMembersDialog.open()
                    failedDialog.open()
                    return
                }

                /* Add Members to project */
                //var success = project.create(projectNameTxt.input.text, addMembersForm.selectedUserIds, user.id);

                /* If Creation failed, show message */
                if(!success) {
                    failedDialog.description = "Adding members failed.";
                    addMembersDialog.open()
                    failedDialog.open()
                    return
                } else {
                    sidebar.reloadProjects()
                }
            }

            onDiscarded: {
                addMembersDialog.close()
                addMembersDialog.destroy()
                console.log("Discard clicked!");
            }
        }
    }

    InfoDialog {
        id: failedDialog
        dialogTitle: "Add Members"
        description: ""
    }
}
