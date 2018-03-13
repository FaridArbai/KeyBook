import QtQuick 2.6
import QtQuick.Controls 2.1
import "Constants.js" as Constants;

Page {

    id: root
    visible:true

    property bool adding_contact : false;
    property bool buttons_blocked : false;
    property string entered_username : "";

    Connections{
        target: main_frame

        onReceivedRequestedContact:{
             main_frame.addRequestedContact(entered_username);
        }

        onFinishedAddingContact:{
            wait_box.visible = false;
            buttons_blocked = false;

            if(add_result==true){
                errorlabeladd.text =
                        entered_username +
                        "was added to your contact list";
                errorlabeladd.color = "green";
                errorlabeladd.visible = true;
            }
            else{
                errorlabeladd.text = err_msg;
                errorlabeladd.color = "red";
                errorlabeladd.visible = true;
            }
            adding_contact = false;
        }

        onWaitingForTooLong:{
            wait_box.visible = true;
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
                acceptedButtons: backbutton | addcontactbutton
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
            onClicked:
                if(!buttons_blocked){
                    root.StackView.view.pop()
                }
        }

        Label{
            text: "Add User"
            color: "white"
            font.pixelSize: 25
            font.bold: true
            anchors.centerIn: parent
        }
    }


    Rectangle{
        anchors.fill: parent
        anchors.leftMargin: (root.width - rectuseradd.width)/2
        anchors.topMargin: 120

        Text {
            id: enteruseradd
            text: "New contact:"
            font.bold: true
            font.pixelSize: 17
            color: "#16323d"
        }

        Rectangle {
            id: rectuseradd
            width: 300
            height: 28
            anchors.top: enteruseradd.bottom
            anchors.topMargin: 10
            border.width: 2
            radius: 4
            border.color: "#021400"

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
            }

            TextInput {
                id: contactinput           
                anchors.fill: parent
                font.bold: true
                anchors.leftMargin: 2
                font.pixelSize: 20
                selectByMouse: true
                mouseSelectionMode: TextInput.SelectCharacters
                maximumLength: 10
                enabled: buttons_blocked ? false : true

                onTextChanged: {
                    if(errorlabeladd.visible){
                        errorlabeladd.visible = false
                        errorlabeladd.text = ""
                    }
                }
                onAccepted:{
                    if(!buttons_blocked){
                        if(contactinput.text == ""){
                            errorlabeladd.visible = true
                            errorlabeladd.text = "Set a valid name"
                            errorlabeladd.color = "red"
                        }else{
                            entered_username = contactinput.text;
                            main_frame.addContact(entered_username);
                            adding_contact = true;
                            buttons_blocked = true;
                        }
                    }
                }
            }
        }

        Label{
            id:errorlabeladd
            text: ""
            visible: false
            font.pixelSize: 15
            anchors.top: rectuseradd.bottom
            anchors.topMargin: 10
        }

        Button{
            id: addcontactbutton
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | addcontactbutton
            }
            anchors.top: errorlabeladd.bottom
            anchors.topMargin: 10
            font.pixelSize: 14
            anchors.left : parent.left
            anchors.leftMargin: (rectuseradd.width - addcontactbutton.width)/2
            text: "Add User"
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 40
                color: addcontactbutton.down ? "#eefdff" : "#f6f6f6"
                border.color: "#26282a"
                border.width: 1
                radius: 4
            }
            onClicked: {
                if(!buttons_blocked){
                    if(contactinput.text == ""){
                        errorlabeladd.visible = true
                        errorlabeladd.text = "Set a valid name"
                        errorlabeladd.color = "red"
                    }else{
                        entered_username = contactinput.text;
                        main_frame.addContact(entered_username);
                        adding_contact = true;
                        buttons_blocked = true;
                    }
                }
            }
        }
    }

    Rectangle{
        id: wait_box;
        anchors.fill: parent
        height: parent.height
        width: parent.width
        visible: false;
        color: Qt.rgba(1,1,1,0.85);


        AnimatedImage{
            source: "icons/loading.gif"
            width: 3*parent.width/8
            height: 3*parent.width/8
            anchors.left: parent.left
            anchors.leftMargin: parent.width/2-width/2
            anchors.top: parent.top
            anchors.topMargin: parent.height/2-height/2
            fillMode: Image.PreserveAspectFit
        }
    }

}
