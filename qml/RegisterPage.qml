import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page{
    id: root
    visible:true

    property bool adding_contact : false;
    property bool buttons_blocked : false;
    property string entered_username : "";

    property int side_margin            :   (1/32)*root.width;
    property int pad_buttons            :   (1/16)*root.width;
    property int buttons_size           :   (3/32)*root.width;
    property int icons_size             :   (34/720)*root.width;

    property int init_spacing           :   (15/100)*root.height-toolbar.height;
    property int textarea_width         :   (3/4)*root.width;
    property int textarea_height        :   (3/2)*input_pixelsize;

    property int label_spacing          :   (85/1000)*root.height;
    property int textarea_spacing       :   (130/100)*label_spacing;

    property int errorlabel_top_margin  :   (15/200)*root.height;
    property int button_top_margin      :   (1/10)*root.height;

    property int button_width           :   (3/8)*root.width;

    property int indicator_pixelsize    :   18;
    property int input_pixelsize        :   22;

    property int textarea_left_padding  :   (3/2)*input_pixelsize;


    property int errorlabel_pixelsize   :   15;
    property int erroricon_size         :   errorlabel_pixelsize;
    property int errorlabel_right_pad   :   1.5*erroricon_size;
    property int errorlabel_width       :   (7/8)*root.width;

    property bool show_pw   :   false;
    property bool show_pw2  :   false;
    property string pw_char :   "•";

    function handleTextChange(text_area){
        if(errorlabelreg.visible==true){
            errorlabelreg.text = "";
            errorlabelreg.visible = false;
        }

        var text = text_area.text;
        var len = text.length;
        var accepted = (text.indexOf("\n")!==(-1));
        var contains_badchar = ((text.indexOf(" ")!==(-1))||(text.indexOf("\\")!==(-1)));
        var exceeds_length =
                (text_area==username_input)?(len>Constants.MAX_USERNAME_LENGTH):(len>Constants.MAX_PASSWORD_LENGTH);

        if(contains_badchar){
            text = text.substr(0,text.length-1);
            text_area.text = text;
            text_area.cursorPosition = text_area.length;
        }
        else if(accepted){
            text_area.text = text_area.text.replace('\n','');
            text_area.cursorPosition = text_area.length;
            text_area.focus = false;
            pw_hidden_input.focus = false;
            pw2_hidden_input.focus = false;
            registerUser();
        }
        else if(exceeds_length){
            text_area.text = text.substring(0,len-1);
            text_area.cursorPosition = text_area.length;
        }
    }

    function registerUser(){
        var username = username_input.text;
        var is_alphanum = username.match(Constants.USERNAME_REGEX);
        var password = password_input.text;
        var password_repetition = password_repetition_input.text;
        var password_matches = (password===password_repetition);
        var username_too_short = username.length<Constants.MIN_USERNAME_LENGTH;
        var password_too_short = password.length<Constants.MIN_PASSWORD_LENGTH;

        if(!is_alphanum){
            errorlabelreg.error = true;
            errorlabelreg.text = "Username must be alphanumeric";
            errorlabelreg.visible = true;
        }
        else if(!password_matches){
            errorlabelreg.error = true;
            errorlabelreg.text = "Passwords do not match";
            errorlabelreg.visible = true;
        }
        else if(username_too_short){
            errorlabelreg.error = true;
            errorlabelreg.text = "Username must be " + Constants.MIN_USERNAME_LENGTH + " caracters min.";
            errorlabelreg.visible = true;
        }
        else if(password_too_short){
            errorlabelreg.error = true;
            errorlabelreg.text = "Password must be " + Constants.MIN_PASSWORD_LENGTH + " caracters min.";
            errorlabelreg.visible = true;
        }
        else{
            register_frame.signUp(username,password);
        }
    }

    Connections{
        target: register_frame

        onReceivedRegisterResponse:{
            errorlabelreg.text = feedback_message;
            errorlabelreg.error = (!success);
            errorlabelreg.visible = true;
        }

    }

    Rectangle{
        id: page_bg
        anchors.fill: parent

        RadialGradient{
            anchors.fill: parent
            //horizontalOffset: -root.width/2
            horizontalOffset: 0
            verticalOffset: -root.height/2
            horizontalRadius: root.height
            verticalRadius: root.height
            gradient: Gradient{
                GradientStop{position: 0;   color: Constants.TOP_LOGIN_COLOR}
                GradientStop{position: 1; color: Constants.BOTTOM_LOGIN_COLOR}
            }
        }
    }

    Rectangle{
        id: toolbar
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: main.toolbar_height
        color: "transparent"

        ToolButton {
            id: backbutton
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: side_margin
            anchors.verticalCenter: parent.verticalCenter
            enabled: !(buttons_blocked)
            height: buttons_size
            width: buttons_size
            background: backbutton_bg

            Rectangle{
                id: backbutton_bg;
                anchors.fill: parent;
                color: "transparent";
            }

            Rectangle{
                color: backbutton.pressed ? Constants.BUTTON_WHITE:"transparent"
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
            text: "New Account"
        }
    }

    Rectangle{
        anchors.top: toolbar.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        color: "transparent"

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
            id:  password_input_indicator
            anchors.top: username_input.bottom
            anchors.topMargin: label_spacing
            anchors.left: parent.left
            anchors.leftMargin: username_input.anchors.leftMargin
            topPadding: 0
            bottomPadding: 0
            font.bold: false
            font.pixelSize:indicator_pixelsize
            text: "Enter password"
            color: Constants.GENERAL_TEXT_WHITE
        }

        Button{
            id: pw_button
            anchors.top: password_input_indicator.top
            anchors.topMargin: (password_input_indicator.height-height)/2
            anchors.right: password_input.right
            height: latchicon_mask.height
            width: latchicon_mask.width
            background: Rectangle{
                color: "transparent"
            }

            OpacityMask{
                id: pw_button_image
                anchors.fill: parent
                source: pw_button_bg
                maskSource: pw_button_mask

                Image{
                    id: pw_button_mask
                    anchors.fill: parent
                    source: root.show_pw ? "icons/whitehideicon.png" : "icons/whiteshowicon.png"
                    visible: false
                }

                Rectangle{
                    id: pw_button_bg
                    anchors.fill: parent
                    color: Constants.GENERAL_TEXT_WHITE
                    visible: false
                }
            }

            onClicked:{
                root.show_pw = !root.show_pw;
            }
        }

        TextArea{
            id: pw_hidden_input
            anchors.top: password_input_indicator.top
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing-height
            anchors.leftMargin: (parent.width-width)/2
            leftPadding: textarea_left_padding
            rightPadding: 0
            width: textarea_width
            font.bold: true
            font.pixelSize: input_pixelsize
            font.letterSpacing: input_pixelsize/8
            selectByMouse: true
            //textFormat: TextEdit.PlainText
            mouseSelectionMode: TextInput.SelectCharacters
            visible: !root.show_pw
            enabled: (!buttons_blocked)&&(!root.show_pw)
            color: Constants.RELEVANT_TEXT_WHITE

            property bool changing : false

            onTextChanged:{
                if(enabled&&(!changing)){
                    changing = true;
                    if(text.length < password_input.text.length){
                        var len = text.length;
                        if(password_input.text.length!=0){
                            password_input.text = password_input.text.substring(0,len);
                            password_input.cursorPosition = password_input.length;
                        }
                    }
                    else{
                        var last_char = text.substring(text.length-1);
                        password_input.text = password_input.text + last_char;
                        password_input.cursorPosition = password_input.length;
                        handleTextChange(password_input);
                    }
                    resetDots();
                    changing = false;
                }
            }

            function resetDots(){
                var outter_call = (changing==false);
                if(outter_call){
                    changing = true;
                }

                var len = password_input.text.length;
                text = root.pw_char.repeat(len);
                cursorPosition = length;

                if(outter_call){
                    changing = false;
                }
            }
        }

        TextArea{
            id: password_input
            anchors.top: password_input_indicator.top
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
            visible: root.show_pw
            enabled: (!buttons_blocked)&&(root.show_pw)
            color: Constants.RELEVANT_TEXT_WHITE

            property bool changing : false;

            onTextChanged:{
                if(enabled&&(!changing)){
                    changing = true;

                    handleTextChange(password_input);
                    pw_hidden_input.resetDots();

                    changing = false;
                }
            }
        }

        OpacityMask{
            anchors.bottom: password_input.bottom
            anchors.bottomMargin: (3/2)*password_input.bottomPadding
            anchors.left: password_input.left
            height: input_pixelsize
            width: input_pixelsize
            source: latchicon_bg
            maskSource: latchicon_mask

            Image{
                id: latchicon_mask
                anchors.fill: parent
                source: "icons/whitepadlockicon.png"
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
            anchors.top: password_input.bottom
            anchors.left: password_input.left
            height: password_input.activeFocus? 2:1
            width: password_input.width
            color: Constants.LINES_WHITE
        }

        Label{
            id:  password_repetition_input_indicator
            anchors.top: password_input.bottom
            anchors.topMargin: label_spacing
            anchors.left: parent.left
            anchors.leftMargin: username_input.anchors.leftMargin
            topPadding: 0
            bottomPadding: 0
            font.bold: false
            font.pixelSize: indicator_pixelsize
            text: "Repeat password"
            color: Constants.GENERAL_TEXT_WHITE
        }

        Button{
            id: pw2_button
            anchors.top: password_repetition_input_indicator.top
            anchors.topMargin: (password_repetition_input_indicator.height-height)/2
            anchors.right: password_repetition_input.right
            height: latchicon2_mask.height
            width: latchicon2_mask.width
            background: Rectangle{
                color: "transparent"
            }

            OpacityMask{
                id: pw2_button_image
                anchors.fill: parent
                source: pw2_button_bg
                maskSource: pw2_button_mask

                Image{
                    id: pw2_button_mask
                    anchors.fill: parent
                    source: root.show_pw2 ? "icons/whitehideicon.png" : "icons/whiteshowicon.png"
                    visible: false
                }

                Rectangle{
                    id: pw2_button_bg
                    anchors.fill: parent
                    color: Constants.GENERAL_TEXT_WHITE
                    visible: false
                }
            }

            onClicked:{
                root.show_pw2 = !root.show_pw2;
            }
        }

        TextArea{
            id: pw2_hidden_input
            anchors.top: password_repetition_input_indicator.top
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing-height
            anchors.leftMargin: (parent.width-width)/2
            leftPadding: textarea_left_padding
            rightPadding: 0
            width: textarea_width
            font.bold: true
            font.pixelSize: input_pixelsize
            font.letterSpacing: input_pixelsize/8
            selectByMouse: true
            //textFormat: TextEdit.PlainText
            mouseSelectionMode: TextInput.SelectCharacters
            visible: !root.show_pw2
            enabled: (!buttons_blocked)&&(!root.show_pw2)
            color: Constants.RELEVANT_TEXT_WHITE

            property bool changing : false

            onTextChanged:{
                if(enabled&&(!changing)){
                    changing = true;
                    if(text.length < password_repetition_input.text.length){
                        var len = text.length;
                        if(password_repetition_input.text.length!=0){
                            password_repetition_input.text = password_repetition_input.text.substring(0,len);
                            password_repetition_input.cursorPosition = password_repetition_input.length;
                        }
                    }
                    else{
                        var last_char = text.substring(text.length-1);
                        password_repetition_input.text = password_repetition_input.text + last_char;
                        password_repetition_input.cursorPosition = password_repetition_input.length;
                        handleTextChange(password_repetition_input);
                    }
                    resetDots();
                    changing = false;
                }
            }

            function resetDots(){
                var outter_call = (changing==false);
                if(outter_call){
                    changing = true;
                }

                var len = password_repetition_input.text.length;
                text = root.pw_char.repeat(len);
                cursorPosition = length;

                if(outter_call){
                    changing = false;
                }
            }
        }

        TextArea{
            id: password_repetition_input
            anchors.top: password_repetition_input_indicator.top
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
            visible: root.show_pw2
            enabled: (!buttons_blocked)&&(root.show_pw2)
            color: Constants.RELEVANT_TEXT_WHITE

            property bool changing : false;

            onTextChanged:{
                if(enabled&&(!changing)){
                    changing = true;

                    handleTextChange(password_repetition_input);
                    pw2_hidden_input.resetDots();

                    changing = false;
                }
            }

        }

        OpacityMask{
            anchors.bottom: password_repetition_input.bottom
            anchors.bottomMargin: (3/2)*password_repetition_input.bottomPadding
            anchors.left: password_repetition_input.left
            height: input_pixelsize
            width: input_pixelsize
            source: latchicon2_bg
            maskSource: latchicon2_mask

            Image{
                id: latchicon2_mask
                anchors.fill: parent
                source: "icons/whitepadlockicon.png"
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
            anchors.top: password_repetition_input.bottom
            anchors.left: password_repetition_input.left
            height: password_repetition_input.activeFocus? 2:1
            width: password_repetition_input.width
            color: Constants.LINES_WHITE
        }

        Label{
            id:errorlabelreg
            visible: false
            anchors.top: password_repetition_input.bottom
            anchors.topMargin: errorlabel_top_margin
            anchors.left: parent.left
            anchors.leftMargin: (parent.width-(paintedWidth+leftPadding))/2
            width: errorlabel_width
            leftPadding: errorlabel_right_pad
            text: ""
            font.pixelSize: errorlabel_pixelsize
            color: Constants.RELEVANT_TEXT_WHITE;
            wrapMode: Label.WordWrap

            property bool error : true;

            OpacityMask{
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (parent.bottomPadding+((parent.height-height)/2))
                height: erroricon_size
                width: erroricon_size
                source: erroricon_bg
                maskSource: erroricon_mask

                Image{
                    id: erroricon_mask
                    anchors.fill: parent
                    source: errorlabelreg.error?"icons/whitenokicon.png":"icons/whiteokicon.png"
                    visible: false
                }

                Rectangle{
                    id: erroricon_bg
                    anchors.fill: parent
                    color: Constants.RELEVANT_TEXT_WHITE
                    visible: false
                }
            }
        }

        Button{
            id: addcontactbutton
            anchors.top: errorlabelreg.top
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
                text: "SIGN UP"
                color: Constants.LINES_WHITE
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | addcontactbutton
            }

            onClicked: {
                registerUser();
            }
        }
    }
}
