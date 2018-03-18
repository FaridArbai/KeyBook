import QtQuick 2.6
import QtQuick.Controls 2.1
import "Constants.js" as Constants;

Page {

    id: root
    visible:true

    property bool adding_contact : false;
    property bool buttons_blocked : false;
    property string entered_username : "";

    property int side_margin            :   (1/32)*root.width;
    property int pad_buttons            :   (1/16)*root.width;
    property int buttons_size           :   (3/32)*root.width;
    property int icons_size             :   (3/4)*buttons_size;

    property int textarea_width         :   (1/2)*root.width;
    property int textarea_height        :   (3/24)*root.height;
    property int textarea_spacing       :   (1/4)*textarea_height;

    property int textarea_top_margin    :   (1/6)*root.height;

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
        height: main.toolbar_height

        Rectangle{
            anchors.fill: parent
            color: Constants.TOOLBAR_COLOR
        }

        ToolButton {
            id: backbutton
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: side_margin
            anchors.verticalCenter: parent.verticalCenter
            enabled: !(buttons_blocked)
            height: buttons_size
            width: buttons_size

            Rectangle{
                color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR
                anchors.fill: parent

                Image {
                    id: backicon
                    anchors.centerIn: parent
                    height: icons_size
                    width:  icons_size
                    source: "icons/whitebackicon.png"
                }
            }

            onClicked:
                if(!buttons_blocked){
                    root.StackView.view.pop()
                }
        }

        Label{
            id: logo_text
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.left: backbutton.right
            anchors.leftMargin: pad_buttons
            font.bold: false
            //font.family: ""
            font.pixelSize: 20
            color: "white"
            text: "New Contact"
        }
    }


    Rectangle{
        anchors.fill: parent
        color: Constants.TOOLBAR_COLOR

        TextInput{
            id: username_input
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: textarea_top_margin
            anchors.horizontalCenter: parent.horizontalCenter
            height: textarea_height
            width: textarea_width
            font.bold: false
            font.pixelSize: 15
            mouseSelectionMode: TextInput.SelectCharacters
            selectByMouse: true
            enabled: buttons_blocked ? false:true
            text: "Username"

            Rectangle{
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: "white"
            }


            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
            }

            onTextChanged: {
                if(errorlabeladd.visible){
                    errorlabeladd.visible = false;
                    errorlabeladd.text = "";
                }
            }

            onAccepted:{
                if(!buttons_blocked){
                    if(contact_input.text == ""){
                        errorlabeladd.visible = true
                        errorlabeladd.text = "Set a valid name"
                        errorlabeladd.color = "red"
                    }else{
                        entered_username = contact_input.text;
                        main_frame.addContact(entered_username);
                        adding_contact = true;
                        buttons_blocked = true;
                    }
                }
            }

        }

        Label{
            id:errorlabeladd
            text: ""
            visible: false
            font.pixelSize: 15
            anchors.top: username_input.bottom
            anchors.topMargin: 10
        }

        Button{
            id: addcontactbutton
            anchors.top: errorlabeladd.bottom
            anchors.topMargin: 10
            font.pixelSize: 14
            anchors.left : parent.left
            anchors.leftMargin: (username_input.width - addcontactbutton.width)/2
            text: "Add User"


            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | addcontactbutton
            }

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
                    if(contact_input.text == ""){
                        errorlabeladd.visible = true
                        errorlabeladd.text = "Set a valid name"
                        errorlabeladd.color = "red"
                    }else{
                        entered_username = contact_input.text;
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
