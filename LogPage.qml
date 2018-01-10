import QtQuick 2.6
import QtQuick.Controls 2.1

Page{

        id: root
        visible:true 

        Connections{
            target: log_frame
            onUpdateErrorLabel:{
                error_label.text = err_msg
                error_label.visible = true
                error_label.color = "red";
            }

            onUserLoggedIn:{
                username_input.text = "";
                password_input.text = "";
                root.StackView.view.push("qrc:/ContactPage.qml");
            }
        }

        header: ToolBar{

            height: 48

            Rectangle{
                anchors.fill: parent
                color: "#206d75"
            }

            Label{
                text: qsTr("Login")
                font.bold: true
                color: "white"
                font.pixelSize: 25
                anchors.centerIn: parent
            }

        }

        Rectangle{

            anchors.fill: parent
            anchors.leftMargin: (parent.width - username_input_container.width)/2
            anchors.topMargin: 120

            Text {
                id: username_text_indicator
                text: "Username"
                font.pixelSize: 17
                font.bold: true
                color: "#16323d"
            }

            Text {
                id: password_text_indicator
                text: "Password"
                font.pixelSize: 17
                anchors.top: username_input_container.bottom
                anchors.topMargin: 10
                font.bold: true
                color: "#16323d"

            }

            Rectangle {
                id: username_input_container
                width: 300
                height: 28
                anchors.top: username_text_indicator.bottom
                anchors.topMargin: 2           
                anchors.leftMargin: 20
                border.width: 2
                radius: 4
                border.color: "#021400"

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                }

                TextInput {
                    id: username_input
                    font.bold: true
                    maximumLength: 10
                    font.pixelSize: 16
                    anchors.fill: parent
                    anchors.topMargin: 3
                    anchors.leftMargin: 4
                    KeyNavigation.tab: password_input
                    selectByMouse: true
                    mouseSelectionMode: TextInput.SelectCharacters

                    onAccepted: {
                        log_frame.logIn(username_input.text,password_input.text)
                    }
                }
            }

            Rectangle {
                id: password_input_container
                width: 300
                height: 28
                anchors.top: password_text_indicator.bottom
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
                    id: password_input
                    anchors.fill: parent
                    font.pixelSize: 16
                    maximumLength: 10
                    echoMode: TextInput.Password
                    anchors.topMargin: 3
                    anchors.leftMargin: 4
                    selectByMouse: true
                    mouseSelectionMode: TextInput.SelectCharacters
                    KeyNavigation.tab: username_input

                    onAccepted: {
                        log_frame.logIn(username_input.text,password_input.text)
                    }
                }
            }

            Label{
                id:error_label
                visible: false
                text: ""
                font.pixelSize: 15
                anchors.top: password_input_container.bottom
                anchors.topMargin: 12
            }

            Button{
                id: signin_button
                anchors.top: error_label.bottom
                anchors.topMargin: 10
                text: "Sign In"
                font.bold: true
                font.pixelSize: 14
                anchors.left: parent.left
                anchors.leftMargin: (username_input_container.width-signin_button.width)/2

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: signin_button | signup_button
                }

                onClicked: {
                    log_frame.logIn(username_input.text,password_input.text)
                }

                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    color: signin_button.down ? "#eefdff" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: 1
                    radius: 4
                }
            }

            Button{
                id: signup_button
                anchors.top: signin_button.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: (username_input_container.width-signin_button.width)/2
                font.bold: true
                font.pixelSize: 14
                text: "Sign Up"

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: signin_button | signup_button
                }
                onClicked:{
                    root.StackView.view.push("qrc:/RegisterPage.qml")
                }



                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    color: signup_button.down ? "#eefdff" : "#f6f6f6"
                    border.color: "#26282a"
                    border.width: 1
                    radius: 4
                }
            }
        }
}

