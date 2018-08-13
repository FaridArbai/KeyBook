import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page{
    id: root
    visible:true

    property var statusbar_color    :   Constants.LOGIN_STATUSBAR_COLOR;

    property bool adding_contact : false;
    property bool buttons_blocked : false;
    property string entered_username : "";

    property int href                   :   1135;
    property int reg_height             :   main.app_height;

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

    property int input_pixelsize        :   (36/href)*reg_height;

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

    property int button_pixelsize       :   (15/22)*(44/href)*reg_height;
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

    property int infolabel_pixelsize    :   (12/22)*((44/href)*reg_height);
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

    Rectangle{
        id: toolbar
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: main.toolbar_height
        color: "transparent"

        CustomButton {
            id: backbutton
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: side_margin
            anchors.topMargin: (parent.height-height)/2
            enabled: !(buttons_blocked)
            height: buttons_size
            width: buttons_size
            circular: true
            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR

            Image {
                id: backicon
                anchors.centerIn: parent
                height: icons_size
                width:  icons_size
                source: "icons/whitebackicon.png"
                mipmap: true
            }

            onClicked:{
                action();
            }

            function action(){
                if(!buttons_blocked){
                    root.StackView.view.pop()
                }
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

    CustomMask{
        id: username_icon
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - textarea_width)/2
        anchors.bottom: username_input.bottom
        height: input_pixelsize + username_input.bottomPadding
        width: height
        source: "icons/whiteusernameicon.png"
        color: username_input.inputAlias.activeFocus ? Constants.LogPage.FOCUS_COLOR : Constants.LogPage.HINT_COLOR;
    }

    CustomTextInput{
        id: username_input
        anchors.top: toolbar.bottom
        anchors.topMargin: input_pixelsize
        anchors.left: username_icon.right
        anchors.leftMargin: username_icon.width/2
        width: textarea_width - anchors.leftMargin - username_icon.width
        pixelsize: input_pixelsize
        textColor: Constants.LogPage.TEXT_COLOR;
        hintColor: Constants.LogPage.HINT_COLOR;
        focusColor: Constants.LogPage.FOCUS_COLOR;
        separatorColor: Constants.LogPage.SEPARATOR_COLOR;
        hint: "Enter username"
        counter_visible: false
        echo_mode: TextInput.Normal
        tabTarget: password_input.inputAlias
    }

    CustomMask{
        id: password_icon
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - textarea_width)/2
        anchors.bottom: password_input.bottom
        height: input_pixelsize + password_input.bottomPadding
        width: height
        source: "icons/whitepadlockicon.png"
        color: password_input.inputAlias.activeFocus ? Constants.LogPage.FOCUS_COLOR : Constants.LogPage.HINT_COLOR;
    }

    CustomTextInput{
        id: password_input
        anchors.top: username_input.bottom
        anchors.topMargin: input_pixelsize
        anchors.left: password_icon.right
        anchors.leftMargin: password_icon.width/2
        width: textarea_width - password_icon.width - anchors.leftMargin
        pixelsize: input_pixelsize
        textColor: Constants.LogPage.TEXT_COLOR;
        hintColor: Constants.LogPage.HINT_COLOR;
        focusColor: Constants.LogPage.FOCUS_COLOR;
        separatorColor: Constants.LogPage.SEPARATOR_COLOR;
        hint: "Enter password"
        counter_visible: false
        echo_mode: TextInput.Password
        tabTarget: password_repetition_input.inputAlias
    }

    CustomMask{
        id: password_repetition_icon
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - textarea_width)/2
        anchors.bottom: password_repetition_input.bottom
        height: input_pixelsize + password_repetition_input.bottomPadding
        width: height
        source: "icons/whitepadlockicon.png"
        color: password_repetition_input.inputAlias.activeFocus ? Constants.LogPage.FOCUS_COLOR : Constants.LogPage.HINT_COLOR;
    }

    CustomTextInput{
        id: password_repetition_input
        anchors.top: password_input.bottom
        anchors.topMargin: input_pixelsize
        anchors.left: password_repetition_icon.right
        anchors.leftMargin: password_repetition_icon.width/2
        width: textarea_width - password_repetition_icon.width - anchors.leftMargin
        pixelsize: input_pixelsize
        textColor: Constants.LogPage.TEXT_COLOR;
        hintColor: Constants.LogPage.HINT_COLOR;
        focusColor: Constants.LogPage.FOCUS_COLOR;
        separatorColor: Constants.LogPage.SEPARATOR_COLOR;
        hint: "Repeat password"
        counter_visible: false
        echo_mode: TextInput.Password
        tabTarget: password_input.inputAlias
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
                mipmap: true
            }

            Rectangle{
                id: erroricon_bg
                anchors.fill: parent
                color: Constants.RELEVANT_TEXT_WHITE
                visible: false
            }
        }
    }

    CustomButton{
        id: addcontactbutton
        anchors.top: errorlabelreg.bottom
        anchors.topMargin: errorlabelreg.anchors.topMargin
        anchors.left : parent.left
        anchors.leftMargin: (parent.width-width)/2
        height: button_height
        width: textarea_width
        circular: true
        animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
        animationDuration: Constants.VISIBLE_DURATION
        easingType: Easing.OutQuad

        background: Rectangle {
            height: addcontactbutton.height
            width: addcontactbutton.width
            color: "transparent"
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

    Label{
        id: preinfo_label
        anchors.top: addcontactbutton.bottom
        anchors.topMargin: infolabel_pixelsize
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        font.bold: false
        font.pixelSize: infolabel_pixelsize
        color: Constants.LINES_WHITE
        text: "By creating a Latchword account you agree to"
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
        text: "our "
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


    footer: Rectangle{
        id: footer;
        width: root.width
        height: root.height-(main.statusbar_height+main.app_height);
        color: "#000000";
    }

    function goBack(){
        backbutton.action();
    }
}






























