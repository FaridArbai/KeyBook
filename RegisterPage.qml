import QtQuick 2.6
import QtQuick.Controls 2.1


Page{
        id: root
        visible:true

        Connections{          
            target: register_frame

            onUpdateFeedbackLabel:{
                errorlabelreg.text = feedback_message
                errorlabelreg.visible = true
                errorlabelreg.color = feedback_color
                if(success){
                    userinputreg = "";
                    passwordreg = "";
                }
            }

        }

        header: ToolBar{

            height: 48

            Rectangle{
                anchors.fill: parent
                color: "#206d75"
            }

            ToolButton {

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: backicon | signupbuttonreg
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
                text: qsTr("Register")
                color: "white"
                font.bold: true
                font.pixelSize: 25
                anchors.centerIn: parent
            }
        }


        Rectangle{

            anchors.fill: parent
            anchors.leftMargin: (parent.width - rectuserreg.width)/2
            anchors.topMargin: 120

            Text {
                id: enteruserreg
                text: "Enter User"
                font.pixelSize: 17
                font.bold: true
                color: "#16323d"
            }

            Text {
                id: enterpasswordreg
                text: "Enter Password"
                font.pixelSize: 17
                anchors.top: rectuserreg.bottom
                anchors.topMargin: 10
                font.bold: true
                color: "#16323d"
            }

            Rectangle {
                id: rectuserreg
                width: 300
                height: 28
                anchors.top: enteruserreg.bottom
                anchors.topMargin: 2
                anchors.leftMargin: 20
                border.width: 2
                border.color: "#021400"
                radius: 4

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                }

                TextInput {                 
                    id: userinputreg
                    anchors.fill: parent
                    font.bold: true
                    maximumLength: 10
                    font.pixelSize: 16
                    anchors.topMargin: 2
                    anchors.leftMargin: 2
                    KeyNavigation.tab: passwordreg
                    selectByMouse: true
                    mouseSelectionMode: TextInput.SelectCharacters
                    onAccepted: {
                        register_frame.signUp(userinputreg.text, passwordreg.text);
                    }
                }
            }

            Rectangle {
                id: rectpasswordreg
                width: 300
                height: 28
                anchors.top: enterpasswordreg.bottom
                anchors.topMargin: 2
                anchors.leftMargin: 20
                border.width: 2
                border.color: "#021400"
                radius: 4
                KeyNavigation.tab: userinputreg

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                }

                TextInput {
                    id: passwordreg
                    anchors.fill: parent
                    font.pixelSize: 16
                    anchors.topMargin: 2
                    anchors.leftMargin: 2
                    maximumLength: 10
                    echoMode: TextInput.Password
                    selectByMouse: true
                    mouseSelectionMode: TextInput.SelectCharacters
                    onAccepted: {
                        register_frame.signUp(userinputreg.text, passwordreg.text);
                    }
                }
            }


            Label{
                id:errorlabelreg
                visible: false
                anchors.top: rectpasswordreg.bottom
                anchors.topMargin: 10
                font.pixelSize: 20
            }

            Button{
                id: signupbuttonreg
                anchors.top: errorlabelreg.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: (rectuserreg.width - signupbuttonreg.width)/2
                text: "Sign Up"
                font.bold: true
                font.pixelSize: 14

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: backicon | signupbuttonreg
                }

                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    color: signupbuttonreg.down ? "#eefdff" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: 1
                    radius: 4
                }

                onClicked: {
                    register_frame.signUp(userinputreg.text, passwordreg.text);
                }

            }
        }
  }
