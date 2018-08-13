import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

Page{
    id: root
    visible:true

    property var statusbar_color    :   Constants.LOGIN_STATUSBAR_COLOR;

    property int href                   :   1135;
    property int log_height             :   main.app_height + main.statusbar_height;

    property int logo_top_pad           :   (25/href)*log_height + main.statusbar_height;
    property int logo_size              :   (170/href)*log_height;

    property int usernameinput_top_pad  :   (150/href)*log_height;
    property int usernameinput_width    :   (3/4)*root.width;

    property int passwordinput_top_pad  :   3*input_pixelsize;
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

        onValidCredentials:{
            log_frame.loadData(username);
        }

        onUserLoggedIn:{
            root.StackView.view.push("qrc:/ContactPage.qml");
            username_input.inputAlias.text = "";
            password_input.inputAlias.text = "";
        }
    }

    property alias progressDialog : progress_dialog;

    CustomProgressDialog{
        id: progress_dialog
        anchors.fill: parent
        statusbarColor: main.decToColor(root.statusbar_color)
    }



    Rectangle{
        id: page_bg
        anchors.fill: parent
        color: "#008696"
        /**
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
        **/
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
            mipmap: true
        }

        Rectangle{
            id: logo_bg
            anchors.fill: parent
            color: Constants.GENERAL_TEXT_WHITE
            visible: false
        }
    }

    CustomMask{
        id: username_icon
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - usernameinput_width)/2
        anchors.bottom: username_input.bottom
        height: input_pixelsize + username_input.bottomPadding
        width: height
        source: "icons/whiteusernameicon.png"
        color: username_input.inputAlias.activeFocus ? Constants.LogPage.FOCUS_COLOR : Constants.LogPage.HINT_COLOR;
    }

    CustomTextInput{
        id: username_input
        anchors.bottom: logo.bottom
        anchors.bottomMargin: -usernameinput_top_pad
        anchors.left: username_icon.right
        anchors.leftMargin: username_icon.width/2
        width: usernameinput_width - anchors.leftMargin - username_icon.width
        pixelsize: input_pixelsize
        textColor: Constants.LogPage.TEXT_COLOR;
        hintColor: Constants.LogPage.HINT_COLOR;
        focusColor: Constants.LogPage.FOCUS_COLOR;
        separatorColor: Constants.LogPage.SEPARATOR_COLOR;
        hint: "Username"
        counter_visible: false
        echo_mode: TextInput.Normal
        tabTarget: password_input.inputAlias

        onTextChanged: {
            if(main.vkeyboard_height<0){
                main_frame.measureVKeyboardHeight(main.app_height);
            }
        }
    }

    CustomMask{
        id: password_icon
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - passwordinput_width)/2
        anchors.bottom: password_input.bottom
        height: input_pixelsize + password_input.bottomPadding
        width: height
        source: "icons/whitepadlockicon.png"
        color: password_input.inputAlias.activeFocus ? Constants.LogPage.FOCUS_COLOR : Constants.LogPage.HINT_COLOR;
    }

    CustomTextInput{
        id: password_input
        anchors.bottom: username_input.bottom
        anchors.bottomMargin: -passwordinput_top_pad
        anchors.left: password_icon.right
        anchors.leftMargin: password_icon.width/2
        width: passwordinput_width - anchors.leftMargin - password_icon.width
        pixelsize: input_pixelsize
        textColor: Constants.LogPage.TEXT_COLOR;
        hintColor: Constants.LogPage.HINT_COLOR;
        focusColor: Constants.LogPage.FOCUS_COLOR;
        separatorColor: Constants.LogPage.SEPARATOR_COLOR;
        hint: "Password"
        counter_visible: false
        echo_mode: TextInput.Password
    }

    Label{
        id:errorlabellog
        visible: false
        anchors.top: password_input.bottom
        anchors.topMargin: 2*errorlabel_pixelsize
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-(paintedWidth+leftPadding))/2
        width: errorlabel_width
        leftPadding: errorlabel_left_pad
        text: ""
        font.pixelSize: errorlabel_pixelsize
        color: Constants.RELEVANT_TEXT_WHITE;
        wrapMode: Label.WordWrap

        property bool error : true;

        CustomMask{
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2;
            height: errorlabel_pixelsize
            width: errorlabel_pixelsize
            source: errorlabellog.error?"icons/whitenokicon.png":"icons/whiteokicon.png"
            color: Constants.RELEVANT_TEXT_WHITE
        }
    }


    CustomButton{
        id: login_button
        anchors.top: errorlabellog.bottom
        anchors.topMargin: errorlabellog.anchors.topMargin
        anchors.left : parent.left
        anchors.leftMargin: (parent.width-width)/2
        height: loginbutton_height
        width: loginbutton_width
        circular: true
        animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
        animationDuration: Constants.VISIBLE_DURATION
        easingType: Easing.OutQuad

        background: Rectangle {
            height: login_button.height
            width: login_button.width
            color: "transparent"
            border.color: Constants.LINES_WHITE
            border.width: 1
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

    CustomButton{
        id: register_button
        anchors.top: login_button.bottom
        anchors.topMargin: registerbutton_top_pad
        anchors.left : parent.left
        anchors.leftMargin: (parent.width-width)/2
        height: loginbutton_height
        width: loginbutton_width
        circular: true
        animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
        animationDuration: Constants.VISIBLE_DURATION
        easingType: Easing.OutQuad

        background: Rectangle {
            height: register_button.height
            width: register_button.width
            color: "transparent"
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
            Qt.openUrlExternally("http://www.faridarbai.com/projects/keybook");
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






















































