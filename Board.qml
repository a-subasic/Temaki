import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import "qrc:/components"

Page {
    title: "Board"
    width: parent.width
    height: parent.height

    ColumnLayout {
        anchors.fill: parent

        anchors.margins: 5
        spacing: 5

        Item {
            id: actions
            height: 40
            Layout.fillWidth: true
            anchors {
//             top: parent.top
//             left: parent.left
//             right: parent.right
//             margins: 5
            }


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
                id:buttonAbout
                text: "Create task"
            }
        }

        Item {
            id: item2
            Layout.fillWidth: true
            Layout.fillHeight: true
//            anchors {
//             top: actions.bottom
//             left: parent.left
//             right: parent.right
//             bottom: parent.bottom
//             margins: 5
//            }

            Rectangle {
                width: item2.width
                height: item2.height
                color: "red"
            }
        }
    }
}

//Item {
//    width: parent.width
//    height: parent.height

//    Row {
//        anchors.top: parent.top
//        anchors.left: parent.left
//        anchors.right: parent.left
//        anchors.margins: 5
//        spacing: 5

//        Multiselect {
//            title: "Members"
//        }

//        Multiselect {
//            title: "Priority"
//        }

//        Multiselect {
//            title: "Type"
//        }

////        Button {
////            text: "Create task"
////        }
//        Item {
//            Layout.fillWidth: true

//        }
//        Button {
//            Layout.alignment: Qt.AlignRight
//            text: "create task"
//        }

//        Item {
//            Layout.fillWidth: true
//            height: parent.height
//            Button{
//                id:buttonAbout
//                text: "Create task"
//        }

//    }


    //    RowLayout {
    //        anchors.fill: parent
    //        id: gridLayout
    //        width: parent.width
    ////        columnSpacing: 2
    ////        rowSpacing: 5
    ////        columns: 6


    //        Multiselect {
    //            id: m1
    //            title: "Members"
    //        }

    //        Multiselect {
    //            id: m2
    //            title: "Priority"
    //        }

    //        Multiselect {
    //            id: m3
    //            title: "Type"
    //        }

    //        Button {
    //            anchors.right: parent.right
    //            text: "Create task"
    //        }
    //    }
//}

//Item {
//    width: 600
////    width: 800
////    title: "Board"
//    height: parent.height
////    height: parent.height

////    Column {
////        id: container
////        anchors.fill: parent
////        width: parent.width
////        height: parent.height
////        spacing: 10
////        anchors.margins: 10

////        Row {
////            id: row1

////            spacing: 10


////            Multiselect {
////                title: "Members"
////            }

////            Multiselect {
////                title: "Priority"
////            }

////            Multiselect {
////                title: "Type"
////            }

////            Button {
////                text: "Create task"
////            }
////        }

////        Row {
////            id: row2
////             width: parent.width
////            spacing: 10
////            height: container.height - row1.height - 100

////            Column {
////                width: (parent.width / 4)

////                spacing: 5
////                Rectangle {
////                    width: parent.width
////                    height: row2.height
////                    color: "red"
////                }
////            }

////            Column {
////                width: (parent.width / 4)
////                height: parent.height -100
////                spacing: 5
////                Rectangle {
////                      width: parent.width
////                    height: parent.height
////                    color: "red"
////                }
////            }

////            Column {
////                width: (parent.width / 4)
////                height: parent.height - 100
////                spacing: 5
////                Rectangle {
////                      width: parent.width
////                    height: parent.height
////                    color: "red"
////                }
////            }

////            Column {
////                width: (parent.width / 4)
////                height: parent.height - 100
////                spacing: 5
////                Rectangle {
////                      width: parent.width
////                    height: parent.height
////                    color: "red"
////                }
////            }


////        }

////    }

//    GridLayout {
//        width: 200
//        anchors.fill: parent
//        anchors.margins: 5
//        rows: 4
//        anchors.rightMargin: -225
//        columns: 5

//        Multiselect {
////            Layout.fillWidth: true
//            Layout.column: 0
//            title: "Members"
//        }

//        Multiselect {
////            Layout.fillWidth: true
//            Layout.column: 1
//            title: "Priority"
//        }

//        Multiselect {
////            Layout.fillWidth: true
//            Layout.column: 2
//            title: "Type"
//        }

//        Button {
////            Layout.fillWidth: true
//            Layout.column: 5
//            text: "Create task"
//        }

////        Rectangle {
////            Layout.fillWidth: true
////             Layout.fillHeight: true
////            color: "red"

////        }
////        Rectangle {
////            Layout.fillWidth: true
////             Layout.fillHeight: true
////            color: "red"

////        }
////        Rectangle {
////            Layout.fillWidth: true
////             Layout.fillHeight: true
////            color: "red"

////        }
////        Rectangle {
////            Layout.fillWidth: true
////             Layout.fillHeight: true
////            color: "red"

////        }
//    }

//}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.75;height:480;width:640}
}
##^##*/
