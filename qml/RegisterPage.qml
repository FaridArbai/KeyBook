import QtQuick 2.6
import QtQuick.Controls 2.1
import "Constants.js" as Constants

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
                id: backbutton

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: backicon | signupbuttonreg
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
                text: "Register"
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
                    maximumLength: 16
                    font.pixelSize: 16
                    anchors.topMargin: 2
                    anchors.leftMargin: 2
                    KeyNavigation.tab: passwordreg
                    selectByMouse: true
                    mouseSelectionMode: TextInput.SelectCharacters
                    onAccepted: {
                        var min_username_length = 3;
                        var username = userinputreg.text;
                        var username_contains_space = (username.indexOf(" ")>(-1));
                        var is_alphanum = username.match(/^[0-9a-zA-Z]+$/);
                        var min_password_length = 6;
                        var password = passwordreg.text;
                        var password_contains_space = (password.indexOf(" ")>(-1));
                        var password_contains_slash = (password.indexOf("\\")>(-1));

                        if(username.length<min_username_length){
                            errorlabelreg.text = "Username is too short! (3 characters min.)";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else if(username_contains_space){
                            errorlabelreg.text = "Whitespace in username is forbidden";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else if(!is_alphanum){
                            errorlabelreg.text = "Username should be alphanumeric";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else if(password.length<min_password_length){
                            errorlabelreg.text = "Password is too short! (6 characters min.)";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else if(password_contains_space){
                            errorlabelreg.text = "Whitespace in password is forbidden";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else if(password_contains_slash){
                            errorlabelreg.text = "Slash character in password is forbidden";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else{
                            register_frame.signUp(userinputreg.text, passwordreg.text);
                        }
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
                        var min_username_length = 3;
                        var username = userinputreg.text;
                        var username_contains_space = (username.indexOf(" ")>(-1));
                        var is_alphanum = username.match(/^[0-9a-zA-Z]+$/);
                        var min_password_length = 6;
                        var password = passwordreg.text;
                        var password_contains_space = (password.indexOf(" ")>(-1));
                        var password_contains_slash = (password.indexOf("\\")>(-1));

                        if(username.length<min_username_length){
                            errorlabelreg.text = "Username is too short! (3 characters min.)";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else if(username_contains_space){
                            errorlabelreg.text = "Whitespace in username is forbidden";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else if(!is_alphanum){
                            errorlabelreg.text = "Username should be alphanumeric";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else if(password.length<min_password_length){
                            errorlabelreg.text = "Password is too short! (6 characters min.)";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else if(password_contains_space){
                            errorlabelreg.text = "Whitespace in password is forbidden";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else if(password_contains_slash){
                            errorlabelreg.text = "Slash character in password is forbidden";
                            errorlabelreg.color = "red";
                            errorlabelreg.visible = "true";
                        }
                        else{
                            register_frame.signUp(userinputreg.text, passwordreg.text);
                        }
                    }
                }
            }


            Label{
                id:errorlabelreg
                visible: false
                anchors.top: rectpasswordreg.bottom
                anchors.topMargin: 10
                anchors.leftMargin: (parent.width-errorlabelreg.width)/2
                font.pixelSize: 13

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
                    var min_username_length = 3;
                    var username = userinputreg.text;
                    var username_contains_space = (username.indexOf(" ")>(-1));
                    var is_alphanum = username.match(/^[0-9a-zA-Z]+$/);
                    var min_password_length = 6;
                    var password = passwordreg.text;
                    var password_contains_space = (password.indexOf(" ")>(-1));
                    var password_contains_slash = (password.indexOf("\\")>(-1));

                    if(username.length<min_username_length){
                        errorlabelreg.text = "Username is too short! (3 characters min.)";
                        errorlabelreg.color = "red";
                        errorlabelreg.visible = "true";
                    }
                    else if(username_contains_space){
                        errorlabelreg.text = "Whitespace in username is forbidden";
                        errorlabelreg.color = "red";
                        errorlabelreg.visible = "true";
                    }
                    else if(!is_alphanum){
                        errorlabelreg.text = "Username should be alphanumeric";
                        errorlabelreg.color = "red";
                        errorlabelreg.visible = "true";
                    }
                    else if(password.length<min_password_length){
                        errorlabelreg.text = "Password is too short! (6 characters min.)";
                        errorlabelreg.color = "red";
                        errorlabelreg.visible = "true";
                    }
                    else if(password_contains_space){
                        errorlabelreg.text = "Whitespace in password is forbidden";
                        errorlabelreg.color = "red";
                        errorlabelreg.visible = "true";
                    }
                    else if(password_contains_slash){
                        errorlabelreg.text = "Slash character in password is forbidden";
                        errorlabelreg.color = "red";
                        errorlabelreg.visible = "true";
                    }
                    else{
                        register_frame.signUp(userinputreg.text, passwordreg.text);
                    }
                }

            }
        }
  }
