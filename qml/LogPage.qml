import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page{
    id: root
    visible:true

    property var statusbar_color    :   0x00000000;

    property int href                   :   1135;
    property int log_height             :   main.app_height + main.statusbar_height;

    property int logo_top_pad           :   (90/href)*log_height + main.statusbar_height;
    property int logo_size              :   (194/href)*log_height;

    property int usernameinput_top_pad  :   (190/href)*log_height;
    property int usernameinput_width    :   (3/4)*root.width;

    property int passwordinput_top_pad  :   (100/href)*log_height;
    property int passwordinput_width    :   (3/4)*root.width;

    property int errorlabel_center_pad  :   loginbutton_top_pad/2;

    property int loginbutton_top_pad    :   (91/href)*log_height;
    property int loginbutton_height     :   (90/href)*log_height;
    property int loginbutton_width      :   usernameinput_width;

    property int registerbutton_top_pad :   (29/href)*log_height;
    property int registerbutton_height  :   loginbutton_height;
    property int registerbutton_width   :   loginbutton_width;

    property int textarea_left_padding  :   (3/2)*input_pixelsize;

    property real density               :   main.density;

    property int input_pixelsize        :   (36/href)*log_height;
    property int input_bottom_pad       :   (12/href)*log_height;
    property int errorlabel_pixelsize   :   (12/18)*input_pixelsize;
    property int buttons_pixelsize      :   (15/18)*input_pixelsize;
    property int infolabel_pixelsize    :   (13/18)*input_pixelsize;
    property int placeicons_size        :   input_pixelsize;
    property int icons_bottom_pad       :   (3/2)*input_bottom_pad;

    property int erroricon_size         :   errorlabel_pixelsize;
    property int errorlabel_left_pad    :   1.5*erroricon_size;
    property int errorlabel_width       :   (7/8)*root.width;

    property string pw_char             :   "•";

    property int infolabel_top_pad      :   (98/href)*log_height;
    property int infolabel_bottom_pad   :   (72/href)*log_height;

    function handleTextChange(text_area){
        if(main.vkeyboard_height<0){
            main_frame.measureVKeyboardHeight();
        }

        if(errorlabellog.visible==true){
            errorlabellog.text = "";
            errorlabellog.visible = false;
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
            logUser();
        }
        else if(exceeds_length){
            text_area.text = text.substring(0,len-1);
            text_area.cursorPosition = text_area.length;
        }
    }

    function logUser(){
        var username = username_input.text;
        var is_alphanum = username.match(Constants.USERNAME_REGEX);
        var password = password_input.text;
        var username_too_short = username.length<Constants.MIN_USERNAME_LENGTH;
        var password_too_short = password.length<Constants.MIN_PASSWORD_LENGTH;

        if(!is_alphanum){
            errorlabellog.error = true;
            errorlabellog.text = "Username must be alphanumeric";
            errorlabellog.visible = true;
        }
        else if(username_too_short){
            errorlabellog.error = true;
            errorlabellog.text = "Username must be " + Constants.MIN_USERNAME_LENGTH + " caracters min.";
            errorlabellog.visible = true;
        }
        else if(password_too_short){
            errorlabellog.error = true;
            errorlabellog.text = "Password must be " + Constants.MIN_PASSWORD_LENGTH + " caracters min.";
            errorlabellog.visible = true;
        }
        else{
            log_frame.logIn(username_input.text,password_input.text);
        }
    }

    Connections{
        target: log_frame
        onUpdateErrorLabel:{
            errorlabellog.text = err_msg;
            errorlabellog.visible = true;
            errorlabellog.error = true;
        }

        onUserLoggedIn:{
            username_input.text = "";
            password_input.text = "";
            root.StackView.view.push("qrc:/ContactPage.qml");
        }
    }

    Rectangle{
        id: page_bg
        anchors.fill: parent
        smooth: true
        RadialGradient{
            id: page_grad
            anchors.fill: parent
            //horizontalOffset: -root.width/2
            horizontalOffset: 0
            verticalOffset: -log_height/2
            horizontalRadius: log_height
            verticalRadius: log_height
            cached: false
            gradient: Gradient{
                GradientStop{position: 0;   color: Constants.TOP_LOGIN_COLOR}
                GradientStop{position: 1; color: Constants.BOTTOM_LOGIN_COLOR}
            }
        }
    }

    OpacityMask{
        id: logo
        anchors.top: parent.top
        anchors.topMargin: logo_top_pad
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        height: logo_size
        width: logo_size
        source: logo_bg
        maskSource: logo_mask

        Image{
            id: logo_mask
            anchors.fill: parent
            source: "icons/whitelogoicon.png"
            visible: false
        }

        Rectangle{
            id: logo_bg
            anchors.fill: parent
            color: Constants.GENERAL_TEXT_WHITE
            visible: false
        }
    }

    TextArea{
        id: username_input
        anchors.bottom: logo.bottom
        anchors.bottomMargin: -usernameinput_top_pad
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        leftPadding: textarea_left_padding
        rightPadding: 0
        bottomPadding: input_bottom_pad
        width: usernameinput_width
        font.bold: false
        font.pixelSize: input_pixelsize
        selectByMouse: true
        //textFormat: TextEdit.PlainText
        mouseSelectionMode: TextInput.SelectCharacters
        color: Constants.RELEVANT_TEXT_WHITE

        OpacityMask{
            id: user_logo
            anchors.bottom: parent.bottom
            anchors.bottomMargin: icons_bottom_pad
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
    }

    Label{
        id: username_placeholder
        anchors.fill: username_input
        topPadding: username_input.topPadding
        bottomPadding: username_input.bottomPadding
        rightPadding: username_input.rightPadding
        leftPadding: username_input.leftPadding
        font.pixelSize: username_input.font.pixelSize
        text: "Username"
        visible: (username_input.text.length==0)&&(!username_input.activeFocus)
        color: Constants.GENERAL_TEXT_WHITE
    }

    TextArea{
        id: pw_hidden_input
        anchors.bottom: username_input.bottom
        anchors.bottomMargin: -passwordinput_top_pad
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        leftPadding: textarea_left_padding
        rightPadding: 0
        bottomPadding: input_bottom_pad
        width: usernameinput_width
        font.bold: true
        font.pixelSize: input_pixelsize
        font.letterSpacing: input_pixelsize/8
        selectByMouse: true
        //textFormat: TextEdit.PlainText
        mouseSelectionMode: TextInput.SelectCharacters
        visible: true
        enabled: true
        color: Constants.RELEVANT_TEXT_WHITE

        property bool changing : false

        onTextChanged:{
            if(!changing){
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
        anchors.bottom: username_input.bottom
        anchors.bottomMargin: -passwordinput_top_pad
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        leftPadding: textarea_left_padding
        rightPadding: 0
        bottomPadding: input_bottom_pad
        width: passwordinput_width
        font.bold: false
        font.pixelSize: input_pixelsize
        selectByMouse: true
        //textFormat: TextEdit.PlainText
        mouseSelectionMode: TextInput.SelectCharacters
        visible: false
        enabled: false
        color: Constants.RELEVANT_TEXT_WHITE
    }

    OpacityMask{
        id: password_logo
        anchors.bottom: password_input.bottom
        anchors.bottomMargin: icons_bottom_pad
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
        height: (password_input.activeFocus||pw_hidden_input.activeFocus)? 2:1
        width: password_input.width
        color: Constants.LINES_WHITE
    }

    Label{
        id: password_placeholder
        anchors.fill: pw_hidden_input
        topPadding: pw_hidden_input.topPadding
        bottomPadding: pw_hidden_input.bottomPadding
        rightPadding: pw_hidden_input.rightPadding
        leftPadding: pw_hidden_input.leftPadding
        font.pixelSize: password_input.font.pixelSize
        text: "Password"
        visible: (password_input.text.length==0)&&(!pw_hidden_input.activeFocus)
        color: Constants.GENERAL_TEXT_WHITE
    }

    Label{
        id:errorlabellog
        visible: false
        anchors.top: password_input.bottom
        anchors.topMargin: errorlabel_center_pad-(height/2)
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-(paintedWidth+leftPadding))/2
        width: errorlabel_width
        leftPadding: errorlabel_left_pad
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
                source: errorlabellog.error?"icons/whitenokicon.png":"icons/whiteokicon.png"
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
        id: login_button
        anchors.top: password_input.bottom
        anchors.topMargin: loginbutton_top_pad
        anchors.left : parent.left
        anchors.leftMargin: (parent.width-width)/2
        height: loginbutton_height
        width: loginbutton_width

        background: Rectangle {
            height: login_button.height
            width: login_button.width
            color: login_button.down ? Constants.BUTTON_WHITE : "transparent"
            border.color: Constants.LINES_WHITE
            border.width: 1
            //radius: 8
            radius: height/2
        }

        Text{
            id: button_text
            anchors.centerIn: parent
            font.pixelSize: buttons_pixelsize;
            font.bold: false
            text: "LOG IN"
            color: Constants.LINES_WHITE
        }

        onClicked:{
            logUser();
        }
    }

    Button{
        id: register_button
        anchors.top: login_button.bottom
        anchors.topMargin: registerbutton_top_pad
        anchors.left : parent.left
        anchors.leftMargin: (parent.width-width)/2
        height: loginbutton_height
        width: loginbutton_width

        background: Rectangle {
            height: register_button.height
            width: register_button.width
            color: register_button.down ? Constants.BUTTON_WHITE : "transparent"
            border.color: Constants.LINES_WHITE
            border.width: 1
            //radius: 8
            radius: height/2
        }

        Text{
            id: register_text
            anchors.centerIn: parent
            font.pixelSize: buttons_pixelsize;
            font.bold: false
            text: "SIGN UP"
            color: Constants.LINES_WHITE
        }

        onClicked:{
            root.StackView.view.push("qrc:/RegisterPage.qml");
        }
    }

    Label{
        id: info_label
        anchors.bottom: parent.bottom
        anchors.bottomMargin: infolabel_bottom_pad
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-(width+info_label2.width))/2
        font.bold: false
        font.pixelSize: infolabel_pixelsize
        color: Constants.LINES_WHITE
        text: "How does it work? "
    }

    Label{
        id: info_label2
        anchors.top: info_label.top
        anchors.left: info_label.right
        leftPadding: 0
        font.bold: true
        font.pixelSize: infolabel_pixelsize
        color: Constants.LINES_WHITE
        text: "Find out here"
    }

    Button{
        anchors.fill: info_label2
        background: Rectangle{
            color: "transparent"
        }
        onClicked: {
            Qt.openUrlExternally("http://192.168.0.158/projects/encryptalk");
        }
    }


    footer: Rectangle{
        id: footer;
        width: root.width
        height: root.height-(root.log_height);
        color: "#000000";
    }

    function goBack(){
        console.log("LogPage goBack was called");
        log_frame.closeApp();
    }
}






















































