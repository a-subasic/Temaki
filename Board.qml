import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import "qrc:/const.js" as Constants
import "qrc:/components"

Page {
    title: "Board"
    id: board
    width: parent.width
    height: parent.height

    Connections {
        target: project

        function onIdChanged(id) {
            task.getForProjectByStatus(id, 1)
            noProjectLoader.active = false
            boardLoader.active = true
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
        id: boardLoader
        sourceComponent: boardComponent
        active: false
        anchors.fill: parent
        anchors.margins: 5
    }

    Component {
        id: boardComponent

        ColumnLayout {
            anchors.fill: parent
            spacing: 5

            Item {
                id: actions
                height: 40
                Layout.fillWidth: true

                Row {
                    spacing: 5

                    Multiselect {
                     title: "Members"
                    }

                    Multiselect {
                     title: "Priority"
                    }

                    Multiselect {
                     title: "Type"
                    }
                }

                Button {
                    anchors.right: parent.right
                    Layout.alignment: Qt.AlignRight
                    id: buttonAbout
                    text: "Create task"
                }
            }

            Item {
                id: item2
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    id: row
                    anchors.fill: parent
                    spacing: 10

                    width: item2.width
                    height: item2.height

                    Column {
                        Rectangle {
                            width: item2.width/4 - 10 + row.spacing/4
                            height: item2.height
                            color: "lightgrey"
                            border.color: "grey"

                            Rectangle {
                                width: parent.width
                                border.color: "black"
                                border.width: 2
                                color: "white"
                                height: 40

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Constants.Status.BACKLOG
                                }
                            }
                        }
                    }
                    Column {
                        Rectangle {
                            width: item2.width/4 - 10 + row.spacing/4
                            height: item2.height
                            color: "lightgrey"
                            border.color: "grey"

                            Rectangle {
                                width: parent.width
                                border.color: "black"
                                border.width: 2
                                color: "white"
                                height: 40

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Constants.Status.ACTIVE
                                }
                            }
                        }
                    }
                    Column {
                        Rectangle {
                            width: item2.width/4 - 10 + row.spacing/4
                            height: item2.height
                            color: "lightgrey"
                            border.color: "grey"

                            Rectangle {
                                width: parent.width
                                border.color: "black"
                                border.width: 2
                                color: "white"
                                height: 40

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Constants.Status.IN_REVIEW
                                }
                            }
                        }
                    }
                    Column {
                        Rectangle {
                            width: item2.width/4 - 10 + row.spacing/4
                            height: item2.height
                            color: "lightgrey"
                            border.color: "grey"

                            Rectangle {
                                width: parent.width
                                border.color: "black"
                                border.width: 2
                                color: "white"
                                height: 40

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Constants.Status.CLOSED
                                }
                            }
                        }
                    }

                }
            }
        }
    }

//    ColumnLayout {
//        anchors.fill: parent

//        anchors.margins: 5
//        spacing: 5

//        Item {
//            id: actions
//            height: 40
//            Layout.fillWidth: true

//            Row {
//                spacing: 5

//                Multiselect {
//                 title: "Members"
//                }

//                Multiselect {
//                 title: "Priority"
//                }

//                Multiselect {
//                 title: "Type"
//                }
//            }

//            Button {
//                anchors.right: parent.right
//                Layout.alignment: Qt.AlignRight
//                id: buttonAbout
//                text: "Create task"
//            }
//        }

//        Item {
//            id: item2
//            Layout.fillWidth: true
//            Layout.fillHeight: true

//            RowLayout {
//                id: row
//                anchors.fill: parent
//                spacing: 10

//                width: item2.width
//                height: item2.height

//                Column {
//                    Rectangle {
//                        width: item2.width/4 - 10 + row.spacing/4
//                        height: item2.height
//                        color: "lightgrey"
//                        border.color: "grey"

//                        Rectangle {
//                            width: parent.width
//                            border.color: "black"
//                            border.width: 2
//                            color: "white"
//                            height: 40

//                            Label {
//                                anchors.horizontalCenter: parent.horizontalCenter
//                                anchors.verticalCenter: parent.verticalCenter
//                                text: Constants.Status.BACKLOG
//                            }
//                        }
//                    }
//                }
//                Column {
//                    Rectangle {
//                        width: item2.width/4 - 10 + row.spacing/4
//                        height: item2.height
//                        color: "lightgrey"
//                        border.color: "grey"

//                        Rectangle {
//                            width: parent.width
//                            border.color: "black"
//                            border.width: 2
//                            color: "white"
//                            height: 40

//                            Label {
//                                anchors.horizontalCenter: parent.horizontalCenter
//                                anchors.verticalCenter: parent.verticalCenter
//                                text: Constants.Status.ACTIVE
//                            }
//                        }
//                    }
//                }
//                Column {
//                    Rectangle {
//                        width: item2.width/4 - 10 + row.spacing/4
//                        height: item2.height
//                        color: "lightgrey"
//                        border.color: "grey"

//                        Rectangle {
//                            width: parent.width
//                            border.color: "black"
//                            border.width: 2
//                            color: "white"
//                            height: 40

//                            Label {
//                                anchors.horizontalCenter: parent.horizontalCenter
//                                anchors.verticalCenter: parent.verticalCenter
//                                text: Constants.Status.IN_REVIEW
//                            }
//                        }
//                    }
//                }
//                Column {
//                    Rectangle {
//                        width: item2.width/4 - 10 + row.spacing/4
//                        height: item2.height
//                        color: "lightgrey"
//                        border.color: "grey"

//                        Rectangle {
//                            width: parent.width
//                            border.color: "black"
//                            border.width: 2
//                            color: "white"
//                            height: 40

//                            Label {
//                                anchors.horizontalCenter: parent.horizontalCenter
//                                anchors.verticalCenter: parent.verticalCenter
//                                text: Constants.Status.CLOSED
//                            }
//                        }
//                    }
//                }

//            }
//        }
//    }
}

