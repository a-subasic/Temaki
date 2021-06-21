import QtQuick 2.0
import QtQuick.Controls 2.15

/*
----------------------------------------------------------------------------------------------------------
    Usage:
        - this component can be used for search inputs; in order to keep consistent style
        - you can catch the text changes (see 'Example' below) and implement a filter function
----------------------------------------------------------------------------------------------------------
    Validation:
        - text needs to be string, otherwise warning is shown and value isn't sent
        - you can toggle this behavior by setting 'validate' to true/false
        - can also send your own custom 'validationRegex'
----------------------------------------------------------------------------------------------------------
    Example:
        - check usage example in '/pages/Members.qml'

        SearchBox {
            id: filterMembers
            onFilterChanged: {
                console.log(text)
            }
        }
----------------------------------------------------------------------------------------------------------
*/
 FocusScope {
     id: focusScope

     property alias input: searchTextInput
     property bool isValid: customErrorText.length === 0

     property string placeholder: "Type something..."
     property string validatorRegex: "[a-zA-Z0-9]+"
     property string errorText: ""
     property string customErrorText: ""
     property bool isActive: false
     property bool validate: true
     property var echo: TextInput.Normal

     signal filterChanged(var text);

     width: 250; height: 28

     BorderImage {
         source: "../images/lineedit-bg.png"
         width: parent.width; height: parent.height
         border { left: 4; top: 4; right: 4; bottom: 4 }
     }

     BorderImage {
         source: "../images/lineedit-bg-focus.png"
         width: parent.width; height: parent.height
         border { left: 4; top: 4; right: 4; bottom: 4 }
         visible: parent.wantsFocus ? true : false
     }

     Text {
         id: searchTextInput
         anchors.fill: parent; anchors.leftMargin: 8
         verticalAlignment: Text.AlignVCenter
         text: placeholder
         color: "gray"
         font.italic: true
     }

     MouseArea {
         anchors.fill: parent
         onClicked: { focusScope.focus = true; }
     }

     TextInput {
         id: textField
         anchors { left: parent.left; leftMargin: 8; right: clear.left; rightMargin: 8; verticalCenter: parent.verticalCenter }
         focus: true
         validator: RegExpValidator {
             regExp: RegExp(validatorRegex)
         }
         onTextChanged: if(isValid) focusScope.filterChanged(textField.text)
     }

     Label {
         text: if(isActive && validate) {
                   if(!textField.acceptableInput)
                       return errorText;
                   else
                       return customErrorText;
               }
               else {
                   return ""
               }

         color: "red"
     }

     Image {
         id: clear
         anchors { right: parent.right; rightMargin: 8; verticalCenter: parent.verticalCenter }
         source: "../images/clear.png"
         opacity: 0

         MouseArea {
             anchors.fill: parent
             onClicked: { textField.text = ''; focusScope.focus = true }
         }
     }

     states: State {
         name: "hasText"; when: textField.text != ''
         PropertyChanges { target: searchTextInput; opacity: 0 }
         PropertyChanges { target: clear; opacity: 1 }
     }

     transitions: [
         Transition {
             from: ""; to: "hasText"
             NumberAnimation { exclude: searchTextInput; properties: "opacity" }
         },
         Transition {
             from: "hasText"; to: ""
             NumberAnimation { properties: "opacity" }
         }
     ]
 }
