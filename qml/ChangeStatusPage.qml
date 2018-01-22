import QtQuick 2.6
import QtQuick.Controls 2.1

Page {

    id: root
    visible:true

    var toolbar_Colour = "#206d75"
    var toolbar_Text_Colour = "white"
    var status_Text_Colour = "#16323d"
    var status_Rectangle_BorderColour = "#021400"
    var button_BorderColour = "#26282a"
    var button_Colour = "#f6f6f6"
    var pressed_Button_Colour = "#eefdff"

        header: ToolBar{

            height: 48

            Rectangle{
                anchors.fill: parent
                color: toolbar_Colour
            }

            ToolButton {
                id: backbutton
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: backbutton | changestatusbutton
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

            Label{
                text: qsTr("Change Status")
                font.pixelSize: 25
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{

            anchors.fill: parent
            anchors.leftMargin: (root.width - rectuserstatus.width)/2
            anchors.topMargin: 120

            Text {
                id: enterstatus
                text: "Enter a new status"
                font.pixelSize: 17
                font.bold: true
                color: status_Text_Colour
            }

            Rectangle {
                id: rectuserstatus
                width: 300
                height: 28 * 3 - 2
                anchors.top: enterstatus.bottom
                anchors.topMargin: 10
                border.width: 2
                border.color: status_Rectangle_BorderColour
                radius: 4
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                }

                TextInput {
                    id: statusinput
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    maximumLength: 180
                    font.pixelSize: 20
                    selectByMouse: true
                    mouseSelectionMode: TextInput.SelectCharacters
                    autoScroll: false
                    wrapMode: TextInput.Wrap
                    onAccepted: {
                        if(statusinput.text != ""){
                            main_frame.updateUserStatus(statusinput.text);
                            root.StackView.view.pop()
                            statusinput.text = ""
                        }
                    }
                }
            }

            Label{
                id:errorlabelstatus
                text: ""
                visible: false
                anchors.top: rectuserstatus.bottom
                anchors.topMargin: 10
                font.pixelSize: 15
            }

            Button{
                id: changestatusbutton
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: backbutton | changestatusbutton
                }
                anchors.top: errorlabelstatus.bottom
                anchors.topMargin: 10
                anchors.left : parent.left
                anchors.leftMargin: (rectuserstatus.width - changestatusbutton.width)/2
                text: "Change Status"
                font.pixelSize: 14
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    color: changestatusbutton.down ? pressed_Button_Colour : button_Colour
                    border.color: button_BorderColour
                    border.width: 1
                    radius: 4
                }
                onClicked: {

                    if(statusinput.text != ""){
                        main_frame.updateUserStatus(statusinput.text);
                        root.StackView.view.pop()
                        statusinput.text = ""
                    }
                }
            }
        }
}
