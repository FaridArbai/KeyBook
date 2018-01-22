import QtQuick 2.0
import QtQuick.Controls 2.1

Page {

    id: root

    var toolbar_Colour = "#206d75"
    var toolbar_Text_Colour = "white"
    var building_Text_Colour = "#16323d"

    header: ToolBar {

        id: toolbar

        height: 48

        Rectangle{
            anchors.fill: parent
            color: toolbar_Colour
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
            color: toolbar_Text_Colour
            font.bold: true
            font.pixelSize: 25
            anchors.centerIn: parent
        }
    }

    Text{
        text:qsTr("Building...")
        font.bold: true
        font.pixelSize: 70
        color: building_Text_Colour
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        anchors.top: parent.top
        anchors.topMargin: (parent.height-height)/2 - toolbar.height/2
    }

}
