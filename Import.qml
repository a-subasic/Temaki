import QtQuick 2.0

Item {
    property var tasks

    Component.onCompleted: {
        console.log(JSON.stringify(tasks));
    }
}
