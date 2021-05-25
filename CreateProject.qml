import QtQuick 2.7
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.1

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
            width: parent.width - 20
            height: parent.height - 20

            /* Form: project name and search input */
            Column {
                id: column
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width * 0.6
                height: parent.height * 0.6
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

                RowLayout {
                    width: parent.width

                    TextField {
                        id: membersTxt
                        width: parent.width
                        placeholderText: qsTr("todo: search users in db")
                    }

                    Button {
                        Layout.alignment: Qt.AlignRight
                        id: searchMembersButton
                        text: "Search"
                        onClicked: {
                            /* Remove all elements in list */
                            listModel.clear();

                            /* Find users with username or email like input */
                            var results = user.search(membersTxt.text)

                            /* Append results to list */
                            for(var i in results) {
                                var objectToAppend = {"id": results[i].id,"username": results[i].username, "email": results[i].email, "roleid": results[i].roleid};

                                listModel.append(objectToAppend)
                                membersTxt.text = ""
                            }
                        }
                    }
                }
            }

            /* Listview component with search results - in progress */
            Rectangle {
                width: parent.width
                height: parent.height * 0.4
                anchors.top: column.bottom
                border.color: "gray"

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 10
                    height: parent.height - 10

                    ListModel {
                        id: listModel
                        /*ListElement {
                            username: "test username"
                            email: "test email"
                        }*/
                    }

                    Component {
                        id: listHeaderComponent
                        RowLayout {
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
                    }

                    Component {
                        id: listDelegate
                        RowLayout {
                            width: listView.width
                            height: 25
                            Label {
                                Layout.preferredWidth: parent.width * 0.25
                                text: model.id
                                visible: false
                            }
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
                                text: "Add"
                            }
                        }

                    }

                    ListView {
                        id: listView
                        anchors.fill: parent
                        width: parent.width
                        height: parent.height
                        model: listModel
                        header: listHeaderComponent
                        delegate: listDelegate
                        clip: true

                        /* Scrollbar and scroll behaviour */
                        flickableDirection: Flickable.VerticalFlick
                        boundsBehavior: Flickable.StopAtBounds
                        ScrollBar.vertical: ScrollBar {}
                    }
                }
            }
        }
    }
}
