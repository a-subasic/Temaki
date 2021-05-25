import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    property alias input: textField
    property bool isEmpty: textField.text.length === 0
    property bool isValid: !isEmpty && customErrorText.length === 0

    property string labelName: ""
    property string validatorRegex: "[a-zA-Z0-9]+"
    property string errorText: ""
    property string customErrorText: ""
    property bool isActive: false
    property var echo: TextInput.Normal

    width: parent.width
    height: 80

    Column {
        anchors.fill: parent

        Label {
            id: label
            text: qsTr(labelName)
            height: 25
        }

        TextField {
            id: textField
            width: parent.width
            placeholderText: qsTr("")
            validator: RegExpValidator {
                regExp: RegExp(validatorRegex)
            }
            onTextChanged: isActive = true
            echoMode: echo
        }

        Label {
            text: if(isActive) {
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
    }
}
