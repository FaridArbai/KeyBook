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

    property int textarea_width         :   (3/4)*root.width;
    property int textarea_height        :   (3/24)*root.height;
    property int textarea_spacing       :   (1/4)*textarea_height;

    property int textarea_top_margin    :   (1/6)*root.height;

    property int button_width           :   3/8*root.width;




    function handleTextChange(text_area){
        if(errorlabeladd.visible==true){
            errorlabeladd.text = "";
            errorlabeladd.visible = false;
        }

        var text = text_area.text;
        var accepted = (text.indexOf("\n")!==(-1));

        if(accepted){
            text_area.text = text_area.text.replace('\n','');
            addContact();
        }
    }

    function addContact(){
        if(!buttons_blocked){
            if(username_input.text == ""){
                errorlabeladd.visible = true
                errorlabeladd.text = "Set a valid name"
                errorlabeladd.color = Constants.FAILURE_COLOR
            }else{
                entered_username = username_input.text;
                main_frame.addContact(entered_username);
                adding_contact = true;
                buttons_blocked = true;
            }
        }

    }


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
                errorlabeladd.color = Constants.SUCESS_COLOR;
                errorlabeladd.visible = true;
            }
            else{
                errorlabeladd.text = err_msg;
                errorlabeladd.color = Constants.FAILURE_COLOR;
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
        gradient: Gradient {
            GradientStop { position: 0.0; color: Constants.TOOLBAR_COLOR }
            GradientStop { position: 1.0; color: Constants.GRADIENT_TOOLBAR_COLOR }
        }

        TextArea{
            id: username_input
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: textarea_top_margin
            anchors.leftMargin: (parent.width-width)/2
            leftPadding: 0
            rightPadding: 0
            width: textarea_width
            font.bold: false
            font.pixelSize: 20
            selectByMouse: true
            mouseSelectionMode: TextInput.SelectCharacters
            enabled: (!buttons_blocked)
            color: "white"
            placeholderText: "Enter username"

            Rectangle{
                anchors.top: parent.bottom
                anchors.left: parent.left
                height: 1
                width: parent.width
                color: "white"
            }

            onTextChanged:{
                handleTextChange(username_input);
            }
        }

        TextArea{
            id: latchkey_input
            anchors.top: username_input.bottom
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing
            anchors.leftMargin: (parent.width-width)/2
            leftPadding: 0
            rightPadding: 0
            width: textarea_width
            font.bold: false
            font.pixelSize: 20
            selectByMouse: true
            mouseSelectionMode: TextInput.SelectCharacters
            enabled: (!buttons_blocked)
            color: "white"
            placeholderText: "Enter latchkey"

            Rectangle{
                anchors.top: parent.bottom
                anchors.left: parent.left
                height: 1
                width: parent.width
                color: "white"
            }

            onTextChanged:{
                handleTextChange(username_input);
            }

        }

        TextArea{
            id: latchkey_repetition_input
            anchors.top: latchkey_input.bottom
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing
            anchors.leftMargin: (parent.width-width)/2
            leftPadding: 0
            rightPadding: 0
            width: textarea_width
            font.bold: false
            font.pixelSize: 20
            selectByMouse: true
            mouseSelectionMode: TextInput.SelectCharacters
            enabled: (!buttons_blocked)
            color: "white"
            placeholderText: "Repeat latchkey"

            Rectangle{
                anchors.top: parent.bottom
                anchors.left: parent.left
                height: 1
                width: parent.width
                color: "white"
            }

            onTextChanged:{
                handleTextChange(username_input);
            }

        }

        Label{
            id:errorlabeladd
            visible: false
            anchors.top: latchkey_repetition_input.bottom
            anchors.topMargin: textarea_spacing
            anchors.left: parent.left
            anchors.leftMargin: (parent.width-width)/2
            text: ""
            font.pixelSize: 15
            color: "lightgrey"
        }

        Button{
            id: addcontactbutton
            anchors.top: errorlabeladd.bottom
            anchors.topMargin: textarea_spacing
            anchors.left : parent.left
            anchors.leftMargin: (parent.width-width)/2
            height: 3*button_text.font.pixelSize
            width: button_width

            background: Rectangle {
                height: addcontactbutton.height
                width: addcontactbutton.width
                color: addcontactbutton.down ? Constants.BRIGHTER_TOOLBAR_COLOR : Constants.TOOLBAR_COLOR
                border.color: "white"
                border.width: 1
                radius: width/2
            }

            Text{
                id: button_text
                anchors.centerIn: parent
                font.pixelSize: 15;
                font.bold: false
                text: "Add Contact"
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | addcontactbutton
            }

            onClicked: {
                if(!buttons_blocked){
                    if(username_input.text == ""){
                        errorlabeladd.visible = true
                        errorlabeladd.text = "Set a valid name"
                        errorlabeladd.color = Constants.FAILURE_COLOR
                    }
                    else{
                        entered_username = username_input.text;
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


