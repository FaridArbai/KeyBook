import QtQuick 2.6
import QtQuick.Controls 2.1
import "Constants.js" as Constants

Page {

    id: root
    visible:true

        header: ToolBar{

            height: 48

            Rectangle{
                anchors.fill: parent
                color: "#206d75"
            }

            ToolButton {
                id: backbutton
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: backbutton | changestatusbutton
                }

                Rectangle{
                    color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR
                    height: Constants.TOOLBUTTON_SIZE
                    width: Constants.TOOLBUTTON_SIZE

                    Image {
                        id: backicon
                        source: "icons/whitebackicon.png"
                        height: Constants.TOOLBUTTON_SIZE
                        width: Constants.TOOLBUTTON_SIZE
                    }
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
                color: "#16323d"
            }

            Rectangle {
                id: rectuserstatus
                width: 300
                height: 28 * 3 - 2
                anchors.top: enterstatus.bottom
                anchors.topMargin: 10
                border.width: 2
                border.color: "#021400"
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
                    color: changestatusbutton.down ? "#eefdff" : "#f6f6f6"
                    border.color: "#26282a"
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
