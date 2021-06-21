import QtQuick 2.12
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.14

import "qrc:/layouts" as Layouts
import "qrc:/pages" as Pages

Grid {
    id: homeScreen
    visible: true
    width: parent.width;
    height: parent.height;

    /* Header */
    Layouts.Header {
        id: header
    }

    /* Sidebar */
    Layouts.Sidebar{
        id: sidebar
    }

    /* Body */
    Layouts.Body{
        id: bodyStackView
    }

}
