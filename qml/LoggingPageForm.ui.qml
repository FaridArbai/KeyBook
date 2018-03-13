import QtQuick 2.4

Item {
    width: 400
    height: 400

    TextEdit {
        id: textEdit
        x: 135
        y: 156
        width: 155
        height: 20
        text: qsTr("user...")
        font.bold: false
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
    }

    TextEdit {
        id: textEdit1
        x: 135
        y: 182
        width: 155
        height: 20
        text: qsTr("password...")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
    }

    Text {
        id: text1
        x: 102
        y: 162
        text: qsTr("User:")
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: text2
        x: 75
        y: 182
        width: 54
        height: 19
        text: qsTr("Password:")
        font.bold: true
        font.pixelSize: 12
    }
}
