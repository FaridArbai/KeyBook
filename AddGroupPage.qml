import QtQuick 2.0
import QtQuick.Controls 2.1

Page {

    id: root

    header: ToolBar {

        id: toolbar

        height: 48

        Rectangle{
            anchors.fill: parent
            color: "#206d75"
        }

        ToolButton {
            id:backbutton

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | backbutton
            }

            BorderImage {
                id: backicon
                source: "icons/whitebackicon.png"
                height: 40
                width: 40
            }

            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            onClicked: root.StackView.view.pop()
        }

        Label {
            id: pageTitle
            text: qsTr("Add group")
            color: "white"
            font.bold: true
            font.pixelSize: 25
            anchors.centerIn: parent
        }
    }

    Text{
        text:qsTr("Building...")
        font.bold: true
        font.pixelSize: 70
        color: "#16323d"
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        anchors.top: parent.top
        anchors.topMargin: (parent.height-height)/2 - toolbar.height/2
    }

}
