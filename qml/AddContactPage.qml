import QtQuick 2.6
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "Constants.js" as Constants;

Page{
    id: root
    visible:true

    property bool adding_contact : false;
    property bool buttons_blocked : false;
    property string entered_username : "";

    property int side_margin            :   (1/32)*root.width;
    property int pad_buttons            :   (1/16)*root.width;
    property int buttons_size           :   (3/32)*root.width;
    property int icons_size             :   (3/4)*buttons_size;


    property int init_spacing           :   (15/100)*root.height-toolbar.height;
    property int textarea_width         :   (3/4)*root.width;
    property int textarea_height        :   (3/24)*root.height;

    property int label_spacing          :   (85/1000)*root.height;
    property int textarea_spacing       :   (130/100)*label_spacing;

    property int errorlabel_top_margin  :   (15/200)*root.height;
    property int button_top_margin      :   (1/10)*root.height;

    property int button_width           :   (3/8)*root.width;

    property int indicator_pixelsize    :   18;
    property int input_pixelsize        :   22;
    property int textarea_left_padding  :   (3/2)*input_pixelsize;

    function handleTextChange(text_area){
        if(errorlabeladd.visible==true){
            errorlabeladd.text = "";
            errorlabeladd.visible = false;
        }

        var text = text_area.text;
        var accepted = (text.indexOf("\n")!==(-1));
        var contains_whitespace = (text.indexOf(" ")!==(-1));

        if(contains_whitespace){
            text = text.substr(0,text.length-1);
            text_area.text = text;
            text_area.cursorPosition = text_area.length;
        }
        if(accepted){
            text_area.text = text_area.text.replace('\n','');
            text_area.cursorPosition = text_area.length;
            text_area.focus = false;
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
                        " was added to your contact list";
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
        id: toolbar
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

        Label{
            id: username_input_indicator
            anchors.top: parent.top
            anchors.topMargin: init_spacing
            anchors.left: parent.left
            anchors.leftMargin: username_input.anchors.leftMargin
            topPadding: 0
            bottomPadding: 0
            font.bold: false
            font.pixelSize:indicator_pixelsize
            text: "Enter Username"
            color: Constants.GENERAL_TEXT_WHITE
        }

        TextArea{
            id: username_input
            anchors.top: username_input_indicator.top
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing-height
            anchors.leftMargin: (parent.width-width)/2
            leftPadding: textarea_left_padding
            rightPadding: 0
            width: textarea_width
            font.bold: false
            font.pixelSize: input_pixelsize
            selectByMouse: true
            //textFormat: TextEdit.PlainText
            mouseSelectionMode: TextInput.SelectCharacters
            enabled: (!buttons_blocked)
            color: Constants.RELEVANT_TEXT_WHITE

            OpacityMask{
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (3/2)*parent.bottomPadding
                anchors.left: parent.left
                height: input_pixelsize
                width: input_pixelsize
                source: usericon_bg
                maskSource: usericon_mask

                Image{
                    id: usericon_mask
                    anchors.fill: parent
                    source: "icons/whiteusernameicon.png"
                    visible: false
                }

                Rectangle{
                    id: usericon_bg
                    anchors.fill: parent
                    color: Constants.GENERAL_TEXT_WHITE
                    visible: false
                }
            }

            Rectangle{
                anchors.top: parent.bottom
                anchors.left: parent.left
                height: username_input.activeFocus? 2:1
                width: parent.width
                color: Constants.LINES_WHITE
            }

            onTextChanged:{
                handleTextChange(username_input);
            }
        }

        Label{
            id:  latchkey_input_indicator
            anchors.top: username_input.bottom
            anchors.topMargin: label_spacing
            anchors.left: parent.left
            anchors.leftMargin: username_input.anchors.leftMargin
            topPadding: 0
            bottomPadding: 0
            font.bold: false
            font.pixelSize:indicator_pixelsize
            text: "Enter Latchkey"
            color: Constants.GENERAL_TEXT_WHITE
        }

        TextArea{
            id: latchkey_input
            anchors.top: latchkey_input_indicator.top
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing-height
            anchors.leftMargin: (parent.width-width)/2
            leftPadding: textarea_left_padding
            rightPadding: 0
            width: textarea_width
            font.bold: false
            font.pixelSize: input_pixelsize
            selectByMouse: true
            //textFormat: TextEdit.PlainText
            mouseSelectionMode: TextInput.SelectCharacters
            enabled: (!buttons_blocked)
            color: Constants.RELEVANT_TEXT_WHITE

            OpacityMask{
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (3/2)*parent.bottomPadding
                anchors.left: parent.left
                height: input_pixelsize
                width: input_pixelsize
                source: latchicon_bg
                maskSource: latchicon_mask

                Image{
                    id: latchicon_mask
                    anchors.fill: parent
                    source: "icons/whitelockicon.png"
                    visible: false
                }

                Rectangle{
                    id: latchicon_bg
                    anchors.fill: parent
                    color: Constants.GENERAL_TEXT_WHITE
                    visible: false
                }
            }

            Rectangle{
                anchors.top: parent.bottom
                anchors.left: parent.left
                height: latchkey_input.activeFocus? 2:1
                width: parent.width
                color: Constants.LINES_WHITE
            }

            onTextChanged:{
                handleTextChange(latchkey_input);
            }

        }

        Label{
            id:  latchkey_repetition_input_indicator
            anchors.top: latchkey_input.bottom
            anchors.topMargin: label_spacing
            anchors.left: parent.left
            anchors.leftMargin: username_input.anchors.leftMargin
            topPadding: 0
            bottomPadding: 0
            font.bold: false
            font.pixelSize: indicator_pixelsize
            text: "Repeat Latchkey"
            color: Constants.GENERAL_TEXT_WHITE
        }

        TextArea{
            id: latchkey_repetition_input
            anchors.top: latchkey_repetition_input_indicator.top
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing-height
            anchors.leftMargin: (parent.width-width)/2
            leftPadding: textarea_left_padding
            rightPadding: 0
            width: textarea_width
            font.bold: false
            font.pixelSize: input_pixelsize
            selectByMouse: true
            //textFormat: TextEdit.PlainText
            mouseSelectionMode: TextInput.SelectCharacters
            enabled: (!buttons_blocked)
            color: Constants.RELEVANT_TEXT_WHITE

            OpacityMask{
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (3/2)*parent.bottomPadding
                anchors.left: parent.left
                height: input_pixelsize
                width: input_pixelsize
                source: latchicon2_bg
                maskSource: latchicon2_mask

                Image{
                    id: latchicon2_mask
                    anchors.fill: parent
                    source: "icons/whitelockicon.png"
                    visible: false
                }

                Rectangle{
                    id: latchicon2_bg
                    anchors.fill: parent
                    color: Constants.GENERAL_TEXT_WHITE
                    visible: false
                }
            }

            Rectangle{
                anchors.top: parent.bottom
                anchors.left: parent.left
                height: latchkey_repetition_input.activeFocus? 2:1
                width: parent.width
                color: Constants.LINES_WHITE
            }

            onTextChanged:{
                handleTextChange(latchkey_repetition_input);
            }

        }

        Label{
            id:errorlabeladd
            visible: false
            anchors.top: latchkey_repetition_input.bottom
            anchors.topMargin: errorlabel_top_margin
            anchors.left: parent.left
            anchors.leftMargin: (parent.width-width)/2
            text: ""
            font.pixelSize: 15
            color: "lightgrey"
        }

        Button{
            id: addcontactbutton
            anchors.top: errorlabeladd.top
            anchors.topMargin: label_spacing
            anchors.left : parent.left
            anchors.leftMargin: (parent.width-width)/2
            height: 3*button_text.font.pixelSize
            width: textarea_width

            background: Rectangle {
                height: addcontactbutton.height
                width: addcontactbutton.width
                color: addcontactbutton.down ? Constants.BUTTON_WHITE : "transparent"
                border.color: Constants.LINES_WHITE
                border.width: 1
                //radius: 8
                radius: height/2
            }

            Text{
                id: button_text
                anchors.centerIn: parent
                font.pixelSize: 15;
                font.bold: false
                text: "ADD CONTACT"
                color: Constants.LINES_WHITE
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


