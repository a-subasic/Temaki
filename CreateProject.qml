import QtQuick 2.7
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.1

import "qrc:/components"
import "qrc:/layouts"

Dialog {
    id: createProjectDialog
    title: qsTr('Create Project')
    width: 550
    height: 450
    standardButtons: Dialog.Discard | Dialog.Save
    anchors.centerIn: parent

    onAccepted: {

        /* Validate Project name */
        if (projectNameTxt.input.text.length == 0) {
            failedDialog.description = "Project name is required!";
            createProjectDialog.open()
            failedDialog.open()
            return
        }

        /* Validate selected project members */
        if (projectForm.selectedUserIds.length == 0) {
            failedDialog.description = "Select at least one project member!";
            createProjectDialog.open()
            failedDialog.open()
            return
        }

        /* Create Project */
        var success = project.create(projectNameTxt.input.text, projectForm.selectedUserIds, user.id);

        /* If Creation failed, show message */
        if(!success) {
            failedDialog.description = "Project creation failed.";
            createProjectDialog.open()
            failedDialog.open()
            return
        } else {
            projectForm.resetForm()
            sidebar.reloadProjects()
        }
    }

    onDiscarded: {
        projectForm.resetForm();
        createProjectDialog.close();
        console.log("Discard clicked!");
    }

    Page {
        anchors.fill: parent

        Item {
            id: projectForm

            property var selectedUserIds: [] = []

            /* Remove all unselected elements in list */
            function removeUnselectedUsersFromList(){
                for (var j=0; j<listModel.count; j++)
                {
                    if (projectForm.selectedUserIds.includes(listModel.get(j).id) === false){
                        listModel.remove(j);
                        j=0; //read from the start! Because index has changed after removing
                    }
                }
            }

            /* Reset and cleanup form */
            function resetForm(){
                projectNameTxt.input.text = "";
                projectForm.selectedUserIds = [];
                listModel.clear();
            }

            anchors.centerIn: parent
            width: parent.width - 20
            height: parent.height - 20

            /* Form: project name and search user input */
            Column {
                id: createProjectForm
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width * 0.6
                height: parent.height * 0.55
                spacing: 10

                Input {
                    id: projectNameTxt
                    labelName: "Project name"
                    errorText: "Project name is required"
                }

                Label {
                    text: qsTr("Members")
                }

                RowLayout {
                    width: parent.width

                    TextField {
                        id: memberSeachInput
                        width: parent.width
                        placeholderText: qsTr("Search users")
                    }

                    Button {
                        id: searchMembersButton
                        Layout.alignment: Qt.AlignRight
                        text: "Search"
                        onClicked: {
                            /* if input is empty, dont search and remove all unselected users from list if exists */
                            if (memberSeachInput.text == "") {
                                if (listModel.count > 0) {
                                    projectForm.removeUnselectedUsersFromList();
                                }
                                return
                            }

                            projectForm.removeUnselectedUsersFromList(); // Remove all unselected elements in list
                            var results = user.search(memberSeachInput.text) // Find users with username or email like input

                            /* Append results to list */
                            for(var i in results) {
                                if (projectForm.selectedUserIds.includes(results[i].id)) continue // dont add if user already selected

                                var objectToAppend = {"id": results[i].id,"username": results[i].username, "email": results[i].email, "roleid": results[i].roleid, "added": false};
                                listModel.append(objectToAppend) 
                            }
                            memberSeachInput.text = "" // reset input field
                        }
                    }
                }
            }

            /* Members search result and add/remove member form */
            Rectangle {
                width: parent.width
                height: parent.height * 0.5
                anchors.top: createProjectForm.bottom
                border.color: "gray"

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 10
                    height: parent.height - 10

                    ListModel {
                        id: listModel
                    }

                    ListView {
                        id: listView
                        anchors.fill: parent
                        width: parent.width
                        height: parent.height
                        model: listModel
                        header: RowLayout {
                            width: listView.width
                            height: 25
                            Label {
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Username"
                            }
                            Label {
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Email"
                            }
                            Label {
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Role"
                            }
                            Label {
                                Layout.preferredWidth: parent.width * 0.25
                                text: "Action"
                            }
                        }
                        delegate: listDelegate
                        clip: true

                        /* Scrollbar and scroll behaviour */
                        flickableDirection: Flickable.VerticalFlick
                        boundsBehavior: Flickable.StopAtBounds
                        ScrollBar.vertical: ScrollBar {}
                    }
                }
            }

            /* Member Listview item */
            Component {
                id: listDelegate
                RowLayout {
                    width: listView.width
                    height: 25
                    Label {
                        Layout.preferredWidth: parent.width * 0.25
                        text: model.username
                    }
                    Label {
                        Layout.preferredWidth: parent.width * 0.25
                        text: model.email
                    }
                    Label {
                        Layout.preferredWidth: parent.width * 0.25
                        text: model.roleid
                    }
                    Button {
                        Layout.fillHeight: true
                        text: { model.added ? "Remove" : "Add" }
                        onClicked: {
                            if (model.added) {
                                /* Remove */
                                model.added = false // mark user as not added
                                var remove = projectForm.selectedUserIds.indexOf(model.id); // find selected user index
                                projectForm.selectedUserIds.splice(remove, 1); // remove selected user from selectedUserIds
                            } else {
                                /* Add */
                                model.added = true; // mark user as added
                                projectForm.selectedUserIds.push(model.id) // add selected user to selectedUserIds
                            }
                        }
                    }
                }

            }

        }
    }

    InfoDialog {
        id: failedDialog
        dialogTitle: "Create Project Failed"
        description: ""
    }
}
