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

    property int href                   :   1135;
    property int reg_height             :   main.app_height+main.statusbar_height;

    property int side_margin            :   (1/32)*root.width;
    property int pad_buttons            :   (1/16)*root.width;
    property int buttons_size           :   (3/32)*root.width;
    property int icons_size             :   (34/720)*root.width;

    property int init_spacing           :   (15/100)*reg_height-toolbar.height;

    property int init_spacing_down      :   (15/100)*reg_height-toolbar.height;
    property int init_spacing_up        :   20;

    property int textarea_width         :   (3/4)*root.width;
    property int textarea_height        :   (3/2)*input_pixelsize;

    property int textarea_spacing       :   (130/100)*(85/1000)*reg_height;

    property int textarea_spacing_down  :   (130/100)*(85/1000)*reg_height;
    property int textarea_spacing_up    :   (3/2)*input_pixelsize;

    property int label_spacing          :   (40/1000)*reg_height;

    property int label_spacing_down     :   (40/1000)*reg_height;
    property int label_spacing_up       :   20;

    property int button_top_margin      :   (1/10)*reg_height;

    property int button_width           :   (3/8)*root.width;

    property int input_pixelsize        :   (44/href)*reg_height;

    property int indicator_pixelsize    :   (18/22)*input_pixelsize;

    property int indicator_pixelsize_down   :   (18/22)*input_pixelsize;
    property int indicator_pixelsize_up     :   0;

    property int input_bottom_pad       :   (12/href)*reg_height;

    property int placeicons_size        :   input_pixelsize;
    property int placeicons_bottom_pad  :   (3/2)*input_bottom_pad;

    property int textarea_left_padding  :   (3/2)*input_pixelsize;

    property int header_pixelsize       :   (20/22)*input_pixelsize;

    property int error_spacing          :   (100/150)*textarea_spacing;

    property int errorlabel_top_margin  :   (error_spacing-errorlabel_pixelsize);
    property int errorlabel_pixelsize   :   (13/22)*input_pixelsize;
    property int erroricon_size         :   errorlabel_pixelsize;
    property int errorlabel_right_pad   :   (3/2)*erroricon_size;
    property int errorlabel_width       :   (7/8)*root.width;

    property int button_pixelsize       :   (15/22)*input_pixelsize;
    property int button_height          :   3*button_pixelsize;

    property int button_top_magin       :   error_spacing;

    property int showbutton_size        :   (9/8)*input_pixelsize;
    property int showbutton_top_margin  :   (indicator_pixelsize_down - showbutton_size)/2;

    property int showbutton_top_margin_down :   (indicator_pixelsize_down - showbutton_size)/2;
    property int showbutton_top_margin_up   :   (textarea_spacing_up - showbutton_size - placeicons_bottom_pad);

    property bool show_pw   :   false;
    property bool show_pw2  :   false;
    property string pw_char :   "•";

    property int placeholder_pixelsize          :   (20/22)*input_pixelsize;
    property int placeholder_bottom_pad         :   (20/22)*input_bottom_pad;

    property int placeholder_transparency       :   0x00;

    property int placeholder_transparency_down  :   0x00;
    property int placeholder_transparency_up    :   0xA0;

    property int infolabel_pixelsize    :   (12/22)*input_pixelsize;
    property int infolabel_top_pad      :   (98/href)*reg_height;
    property int infolabel_bottom_pad   :   (72/href)*reg_height;


    function transparentWhite(transparency){
        var has_two_digits = (transparency>0x0f);
        var transparency_str = transparency.toString(16);
        var header = has_two_digits?(transparency_str):("0"+transparency_str);
        var rgb_white = "FFFFFF";
        var transparent_white = "#"+header+rgb_white;

        return transparent_white
    }

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
            verticalOffset: -reg_height/2
            horizontalRadius: reg_height
            verticalRadius: reg_height
            gradient: Gradient{
                GradientStop{position: 0;   color: Constants.TOP_LOGIN_COLOR}
                GradientStop{position: 1; color: Constants.BOTTOM_LOGIN_COLOR}
            }
        }
    }

    Rectangle{
        id: toolbar
        anchors.top: parent.top
        anchors.topMargin: main.statusbar_height
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
            font.pixelSize: header_pixelsize
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
            visible: font.pixelSize > 5
        }

        Label{
            id: username_placeholder
            anchors.bottom: username_input.bottom
            anchors.left: username_input.left
            bottomPadding: placeholder_bottom_pad
            leftPadding: username_input.leftPadding
            font.pixelSize: placeholder_pixelsize
            text: "Enter username"
            visible: (username_input.text.length==0)&&(!username_input.activeFocus)
            color: transparentWhite(placeholder_transparency)
        }

        TextArea{
            id: username_input
            anchors.top: username_input_indicator.top
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing-height
            anchors.leftMargin: (parent.width-width)/2
            bottomPadding: input_bottom_pad
            leftPadding: textarea_left_padding
            rightPadding: placeicons_size
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
                anchors.bottomMargin: placeicons_bottom_pad
                anchors.left: parent.left
                height: placeicons_size
                width: placeicons_size
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

            onActiveFocusChanged: {
                changeLayout();
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
            visible: font.pixelSize > 5
        }

        Label{
            id: password_placeholder
            anchors.bottom: password_input.bottom
            anchors.left: password_input.left
            bottomPadding: placeholder_bottom_pad
            leftPadding: password_input.leftPadding
            font.pixelSize: placeholder_pixelsize
            text: "Enter password"
            visible: (password_input.text.length==0)&&(!(password_input.activeFocus||pw_hidden_input.activeFocus))
            color: transparentWhite(placeholder_transparency)
        }

        TextArea{
            id: pw_hidden_input
            anchors.top: password_input_indicator.top
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing-height
            anchors.leftMargin: (parent.width-width)/2
            bottomPadding: input_bottom_pad
            leftPadding: textarea_left_padding
            rightPadding: placeicons_size
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

            onActiveFocusChanged: {
                changeLayout();
            }
        }

        TextArea{
            id: password_input
            anchors.top: password_input_indicator.top
            anchors.left: parent.left
            bottomPadding: input_bottom_pad
            anchors.topMargin: textarea_spacing-height
            anchors.leftMargin: (parent.width-width)/2
            leftPadding: textarea_left_padding
            rightPadding: placeicons_size
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

            onActiveFocusChanged: {
                changeLayout();
            }
        }

        OpacityMask{
            anchors.bottom: password_input.bottom
            anchors.bottomMargin: placeicons_bottom_pad
            anchors.left: password_input.left
            height: placeicons_size
            width: placeicons_size
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

        Button{
            id: pw_button
            anchors.top: password_input_indicator.top
            anchors.topMargin: showbutton_top_margin;
            anchors.right: password_input.right
            height: showbutton_size
            width: showbutton_size
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
                    source: root.show_pw ? "icons/whiteshowicon.png" : "icons/whitehideicon.png"
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
            visible: font.pixelSize > 5
        }

        Label{
            id: password_repetition_placeholder
            anchors.bottom: password_repetition_input.bottom
            anchors.left: password_repetition_input.left
            topPadding: password_repetition_input.topPadding
            bottomPadding: placeholder_bottom_pad
            leftPadding: password_repetition_input.leftPadding
            rightPadding: password_repetition_input.rightPadding
            font.pixelSize: placeholder_pixelsize
            text: "Repeat password"
            visible: (password_repetition_input.text.length==0)&&(!(password_repetition_input.activeFocus||pw2_hidden_input.activeFocus))
            color: transparentWhite(placeholder_transparency)
        }

        TextArea{
            id: pw2_hidden_input
            anchors.top: password_repetition_input_indicator.top
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing-height
            anchors.leftMargin: (parent.width-width)/2
            bottomPadding: input_bottom_pad
            leftPadding: textarea_left_padding
            rightPadding: placeicons_size
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

            onActiveFocusChanged: {
                changeLayout();
            }

        }

        TextArea{
            id: password_repetition_input
            anchors.top: password_repetition_input_indicator.top
            anchors.left: parent.left
            anchors.topMargin: textarea_spacing-height
            anchors.leftMargin: (parent.width-width)/2
            bottomPadding: input_bottom_pad
            leftPadding: textarea_left_padding
            rightPadding: placeicons_size
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

            onActiveFocusChanged: {
                changeLayout();
            }
        }

        OpacityMask{
            anchors.bottom: password_repetition_input.bottom
            anchors.bottomMargin: placeicons_bottom_pad
            anchors.left: password_repetition_input.left
            height: placeicons_size
            width: placeicons_size
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

        Button{
            id: pw2_button
            anchors.top: password_repetition_input_indicator.top
            anchors.topMargin: showbutton_top_margin
            anchors.right: password_repetition_input.right
            height: showbutton_size
            width: showbutton_size
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
                    source: root.show_pw2 ? "icons/whiteshowicon.png" : "icons/whitehideicon.png"
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

        Label{
            id:errorlabelreg
            visible: false
            anchors.top: password_repetition_input.bottom
            anchors.topMargin: errorlabel_top_margin
            anchors.left: parent.left
            anchors.leftMargin: (parent.width-(paintedWidth+leftPadding))/2
            width: errorlabel_width
            leftPadding: errorlabel_right_pad
            topPadding: 0
            bottomPadding: 0
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
            anchors.topMargin: button_top_margin
            anchors.left : parent.left
            anchors.leftMargin: (parent.width-width)/2
            height: button_height
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
                font.pixelSize: button_pixelsize;
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

    Label{
        id: preinfo_label
        anchors.bottom: parent.bottom
        anchors.bottomMargin: infolabel_bottom_pad + height
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        font.bold: false
        font.pixelSize: infolabel_pixelsize
        color: Constants.LINES_WHITE
        text: "By creating a Latchword account, you agree"
    }

    Label{
        id: info_label
        anchors.top: preinfo_label.bottom
        anchors.topMargin: (infolabel_pixelsize/8)
        anchors.left: parent.left
        anchors.leftMargin: preinfo_label.anchors.leftMargin
        font.bold: false
        font.pixelSize: infolabel_pixelsize
        color: Constants.LINES_WHITE
        text: "to our "
    }

    Label{
        id: termsofservice_label
        anchors.top: info_label.top
        anchors.left: info_label.right
        leftPadding: 0
        font.bold: true
        font.underline: termsofservice_button.down
        font.pixelSize: infolabel_pixelsize
        color: Constants.LINES_WHITE
        text: "Terms of Service "
    }

    Label{
        id: joining_label
        anchors.top: termsofservice_label.top
        anchors.left: termsofservice_label.right
        leftPadding: 0
        font.bold: false
        font.pixelSize: infolabel_pixelsize
        color: Constants.LINES_WHITE
        text: "and "
    }

    Label{
        id: privacypolicy_label
        anchors.top: joining_label.top
        anchors.left: joining_label.right
        leftPadding: 0
        font.bold: true
        font.underline: privacypolicy_button.down
        font.pixelSize: infolabel_pixelsize
        color: Constants.LINES_WHITE
        text: "Privacy Policy"
    }

    Button{
        id: termsofservice_button
        anchors.fill: termsofservice_label
        background: Rectangle{
            color: "transparent"
        }
        onClicked: {
            Qt.openUrlExternally("http://192.168.0.158/projects/encryptalk");
        }
    }

    Button{
        id: privacypolicy_button
        anchors.fill: privacypolicy_label
        background: Rectangle{
            color: "transparent"
        }
        onClicked: {
            Qt.openUrlExternally("http://192.168.0.158/projects/encryptalk");
        }
    }



    function changeLayout(){
        var focus =
                username_input.activeFocus ||
                password_input.activeFocus ||
                pw_hidden_input.activeFocus ||
                password_repetition_input.activeFocus ||
                pw2_hidden_input.activeFocus;

        if(focus){
            push_down_labels.running = false;
            push_up_labels.running = true;

            expand_indicators.running = false;
            shrink_indicators.running = true;

            push_up_showbuttons.running = false;
            push_down_showbuttons.running = true;

            push_down_top.running = false;
            push_up_top.running = true;

            push_down_textareas.running = false;
            push_up_textareas.running = true;

            push_down_placeholders.running = false;
            push_up_placeholders.running = true;
        }
        else{
            push_up_labels.running = false;
            push_down_labels.running = true;

            shrink_indicators.running = false;
            expand_indicators.running = true;

            push_down_showbuttons.running = false;
            push_up_showbuttons.running = true;

            push_up_textareas.running = false;
            push_down_textareas.running = true;

            push_up_placeholders.running = false;
            push_down_placeholders.running = true;
        }
    }

    PropertyAnimation{
        id: push_up_labels
        target: root
        property: "label_spacing"
        to: label_spacing_up
        duration: 250
    }

    PropertyAnimation{
        id: shrink_indicators
        target: root
        property: "indicator_pixelsize"
        to: root.indicator_pixelsize_up
        duration: 250
    }

    PropertyAnimation{
        id: push_down_showbuttons
        target: root
        property: "showbutton_top_margin"
        to: showbutton_top_margin_up
        duration: 250
    }

    PropertyAnimation{
        id: push_up_top
        target: root
        property: "init_spacing"
        to: init_spacing_up
        duration: 250
    }

    PropertyAnimation{
        id: push_up_textareas
        target: root
        property: "textarea_spacing"
        to: textarea_spacing_up
        duration: 250
    }

    PropertyAnimation{
        id: push_down_labels
        target: root
        property: "label_spacing"
        to: label_spacing_down
        duration: 250
    }

    PropertyAnimation{
        id: expand_indicators
        target: root
        property: "indicator_pixelsize"
        to: root.indicator_pixelsize_down
        duration: 250
    }

    PropertyAnimation{
        id: push_up_showbuttons
        target: root
        property: "showbutton_top_margin"
        to: showbutton_top_margin_down
        duration: 250
    }

    PropertyAnimation{
        id: push_down_top
        target: root
        property: "init_spacing"
        to: init_spacing_down
        duration: 250
    }

    PropertyAnimation{
        id: push_down_textareas
        target: root
        property: "textarea_spacing"
        to: textarea_spacing_down
        duration: 250
    }



    PropertyAnimation{
        id: push_up_placeholders
        target: root
        property: "placeholder_transparency"
        to: placeholder_transparency_up
        duration: 250
    }
    PropertyAnimation{
        id: push_down_placeholders
        target: root
        property: "placeholder_transparency"
        to: placeholder_transparency_down
        duration: 250
    }


    footer: Rectangle{
        id: footer;
        width: root.width
        height: root.height-(main.statusbar_height+main.app_height);
        color: "#000000";
    }
}






























