import QtQuick 2.7
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.1

import "qrc:/components"
import "qrc:/layouts"

Item {
    id: addMembersForm
    property var selectedUserIds: [] = []
    property var ignoreUserIds: [] = [] // userIds to ignore when searching for users

    /* Remove all unselected elements in list */
    function removeUnselectedUsersFromList(){
        for (var j=0; j<listModel.count; j++)
        {
            if (addMembersForm.selectedUserIds.includes(listModel.get(j).id) === false){
                listModel.remove(j);
                j=-1; //read from the start! Because index has changed after removing
            }
        }
    }

    /* Reset and cleanup form */
    function resetForm(){
        addMembersForm.selectedUserIds = [];
        listModel.clear();
    }

    /* Form: search user input */
    Column {
        id: addMembersColumn
        anchors.left: parent.left
        anchors.top: parent.top
        spacing: 10

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
                            addMembersForm.removeUnselectedUsersFromList();
                        }
                        return
                    }

                    addMembersForm.removeUnselectedUsersFromList(); // Remove all unselected elements in list
                    var results = user.search(memberSeachInput.text, addMembersForm.ignoreUserIds) // Find users with username or email like input

                    /* Append results to list */
                    for(var i in results) {
                        if (addMembersForm.selectedUserIds.includes(results[i].id)) continue // dont add if user already selected

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
        anchors.top: addMembersColumn.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 10
        border.color: "lightgrey"

        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            border.color: "lightgrey"

            ListModel {
                id: listModel
            }

            ListView {
                id: listView
                anchors.fill: parent
                width: parent.width
                height: parent.height
                model: listModel
                header: Rectangle {
                    width: listView.width
                    height: 30
                    color: "lightgrey"
                    RowLayout {
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent
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

        Rectangle {
            width: listView.width
            height: 30
            border.color: "lightgrey"

            RowLayout {
                width: parent.width - 10
                height: parent.height - 10
                anchors.centerIn: parent

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
                    text: model.roleid
                }
                Item {
                    width: parent.width * 0.25
                    Layout.fillHeight: true
                    Button {
                        Layout.alignment: Qt.AlignCenter
                        height: parent.height
                        text: { model.added ? "Remove" : "Add" }
                        onClicked: {
                            if (model.added) {
                                /* Remove */
                                model.added = false // mark user as not added
                                var remove = addMembersForm.selectedUserIds.indexOf(model.id); // find selected user index
                                addMembersForm.selectedUserIds.splice(remove, 1); // remove selected user from selectedUserIds
                            } else {
                                /* Add */
                                model.added = true; // mark user as added
                                addMembersForm.selectedUserIds.push(model.id) // add selected user to selectedUserIds
                            }
                        }
                    }
                }
            }
        }
    }

}
