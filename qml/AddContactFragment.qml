import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

Item {
    id: root
    visible: false
    enabled: false
    z: -max_z

    signal opening();
    signal closing();
    signal done(string text);


    property bool opened            :   visible;
    property int max_z              :   1000;

    property string icon_source     :   "icons/whiteprofileicon.png";
    property string title_text      :   "Add new contact";
    property string initial_text    :   "";

    property string username_hint   :   "Username";
    property string password_hint   :   "Shared password";
    property string repetition_hint :   "Repeat password";

    property int username_max_chars :   24;
    property int password_max_chars :   16;

    property string username_errstr     :   "Username too short!";
    property string password_errstr     :   "Password too weak!";
    property string repetition_errstr   :   "Passwords do not match";

    property int username_min_chars :   3;
    property int password_min_chars :   6;

    property bool counter_visible   :   true;

    property int echo_mode          :   TextInput.Normal;

    property string enteredUsername :   username_input.text.toString();
    property string enteredPassword :   password_input.text.toString();

    function notifyResult(success, str){
        notification = true;
        notificationValue = success;
        notificationString = str;
    }

    property bool notification          :   false;
    property bool notificationValue     :   false;
    property string notificationString    :   "";

    property string statusbar_color;
    property string dark_color      :   Qt.darker(statusbar_color,5).toString();


    property int vert_padding           :   0.035*dialog.maxHeight;
    property int hor_padding            :   0.07*dialog.width;
    property int title_pixelsize        :   0.055*dialog.maxHeight;
    property int text_toppadding        :   0.0375*dialog.maxHeight;
    property int text_pixelsize         :   0.052*dialog.maxHeight;
    property int error_pixelsize        :   0.7*text_pixelsize;
    property int max_error_pixelsize    :   (1.25)*error_pixelsize;
    property int buttons_pixelsize      :   0.04*dialog.maxHeight;
    property int buttons_bottompadding  :   0.05*dialog.maxHeight;
    property int buttons_spacing        :   0.086*dialog.width;


    function open(){
        root.enabled = true;
        opening();
        main_frame.changeStatusbarColor(parseInt(Qt.darker(statusbar_color,5).toString().replace("#","0xFF")));
        open_animation.start();
    }

    function close(){
        root.enabled = false;
        closing();
        main_frame.changeStatusbarColor(parseInt(statusbar_color.replace("#","0xFF")), 100);
        close_animation.start();
    }

    SequentialAnimation{
        id: open_animation

        PropertyAction{
            target: root
            property: "z"
            value: max_z
        }

        PropertyAction{
            target: root
            property: "visible"
            value: true
        }

        PropertyAnimation{
            target: dialog
            property: "opacity"
            to: 1
            duration: 100
        }
    }

    SequentialAnimation{
        id: close_animation

        PropertyAnimation{
            target: dialog
            property: "opacity"
            to: 0
            duration: 100
        }

        PropertyAction{
            target: root
            property: "visible"
            value: false
        }

        PropertyAction{
            target: root
            property: "z"
            value: -max_z
        }
    }


    Rectangle{
        id: background
        anchors.fill: parent
        color: "black"
        opacity: 0.8
        Button{
            id: background_disable
            anchors.fill: parent
            background: Rectangle{color:"transparent"}
            onClicked: {}
        }
    }

    Rectangle{
        id: dialog
        width: main.app_width*0.86
        height: cancel_text.y + cancel_text.height + buttons_bottompadding
        property int maxHeight: main.app_height*0.54
        anchors.top: parent.top
        anchors.topMargin: (parent.height-height)/2
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        radius: width/128
        color: "white"
        opacity: 0
        layer.enabled: true
        layer.effect: CustomElevation{
            source: dialog
        }

        Label{
            id: title
            anchors.top: parent.top
            anchors.topMargin: vert_padding
            anchors.left: parent.left
            anchors.leftMargin: hor_padding
            font.pixelSize: title_pixelsize;
            font.bold: false
            color: "black"
            topPadding: 0
            bottomPadding: 0
            rightPadding: 0
            leftPadding: 1.5*title_pixelsize
            text: root.title_text
            opacity: 0.8

            OpacityMask{
                anchors.top: parent.top
                anchors.topMargin: (parent.height-height)/2
                anchors.left: parent.left
                height: title_pixelsize
                width: title_pixelsize
                source: mask_bg
                maskSource: mask_src

                Rectangle{
                    id: mask_bg
                    anchors.fill: parent
                    color: "black"
                    visible: false
                }

                Image{
                    id: mask_src
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: root.icon_source
                    visible: false
                }

            }
        }

        CustomTextInput{
            id: username_input
            anchors.top: title.bottom
            anchors.topMargin: text_toppadding
            anchors.left: parent.left
            anchors.leftMargin: hor_padding
            width: parent.width - 2*hor_padding
            pixelsize: text_pixelsize
            initial_text: ""
            hint: root.username_hint
            max_chars: root.username_max_chars
            counter_visible: root.counter_visible
            echo_mode: TextInput.Normal
        }

        CustomTextInput{
            id: password_input
            anchors.top: username_input.bottom
            anchors.topMargin: text_pixelsize
            anchors.left: parent.left
            anchors.leftMargin: hor_padding
            width: parent.width - 2*hor_padding
            pixelsize: text_pixelsize
            initial_text: ""
            hint: root.password_hint
            max_chars: root.password_max_chars
            counter_visible: root.counter_visible
            echo_mode: TextInput.Password
        }

        CustomTextInput{
            id: repetition_input
            anchors.top: password_input.bottom
            anchors.topMargin: text_pixelsize
            anchors.left: parent.left
            anchors.leftMargin: hor_padding
            width: parent.width - 2*hor_padding
            pixelsize: text_pixelsize
            initial_text: ""
            hint: root.repetition_hint
            max_chars: password_input.text.length
            counter_visible: root.counter_visible
            echo_mode: TextInput.Password
        }




        Rectangle{
            id: error_root
            anchors.top: repetition_input.bottom
            anchors.topMargin: max_error_pixelsize
            anchors.left: parent.left
            anchors.leftMargin: (parent.width-(error_mask.width + error_label.anchors.leftMargin + error_label.paintedWidth))/2
            height: contentHeight
            visible: error

            property bool username_error    :   (username_input.text.length < username_min_chars);
            property bool password_error    :   (password_input.text.length < password_min_chars);
            property bool repetition_error  :   (password_input.text !== repetition_input.text);

            property bool error         :   (username_error || password_error || repetition_error || notification);
            property int pixelsize      :   error_pixelsize;
            property int labelWidth     :   repetition_input.width;

            property string errorString :   username_error?(username_errstr):(password_error?(password_errstr):(repetition_error?(repetition_errstr):(notification ? (notificationString):"")))

            property int max_error_pixelsize    :   (1.25)*pixelsize;
            property color error_color          :   Qt.tint(Constants.TextInput.TEXT_COLOR, addTransparency(Math.round(redness*255), "#FF0000"));
            property real redness               :   0;

            onUsername_errorChanged: {
                if(notification){
                    notification = false;
                    notificationValue = false;
                    notificationString = "";
                }
            }

            onPassword_errorChanged: {
                if(notification){
                    notification = false;
                    notificationValue = false;
                    notificationString = "";
                }
            }

            onRepetition_errorChanged: {
                if(notification){
                    notification = false;
                    notificationValue = false;
                    notificationString = "";
                }
            }

            SequentialAnimation{
                id: color_animation

                PropertyAnimation{
                    target: error_root
                    property: "redness"
                    to: 1
                    duration: 250
                    easing.type: Easing.OutQuad
                }


                PauseAnimation {
                    duration: 500
                }

                PropertyAnimation{
                    target: error_root
                    property: "redness"
                    to: 0
                    duration: 250
                    easing.type: Easing.InQuad
                }
            }

            SequentialAnimation{
                id: size_animation

                PropertyAnimation{
                    target: error_root
                    property: "pixelsize"
                    to: error_root.max_error_pixelsize
                    duration: 250
                    easing.type: Easing.OutQuad
                }


                PauseAnimation {
                    duration: 500
                }

                PropertyAnimation{
                    target: error_root
                    property: "pixelsize"
                    to: error_root.pixelsize
                    duration: 250
                    easing.type: Easing.InQuad
                }
            }

            function errorAnimation(){
                color_animation.start();
                size_animation.start();
            }

            function addTransparency(transparency,color){
                var has_one_character = transparency<=0x0F;
                var transparency_str = (has_one_character?("0"):("")) + transparency.toString(16);
                var final_color = "#" + transparency_str + color.substr(1);

                return final_color;
            }

            CustomMask{
                id: error_mask
                anchors.left: parent.left
                anchors.top: parent.top
                width: error_root.pixelsize
                height: error_root.pixelsize
                source: (notification && notificationValue) ? "icons/whiteokicon.png" : "icons/whitenokicon.png"
                color: error_root.error_color
            }

            Label{
                id: error_label
                width: error_root.label_width - error_mask.width - anchors.leftMargin
                anchors.left: error_mask.right
                anchors.leftMargin: 0.5*error_root.pixelsize
                anchors.top: parent.top
                font.pixelSize: error_root.pixelsize
                wrapMode: Label.Wrap
                text: error_root.error ? error_root.errorString:"";
                color: error_root.error_color
            }
        }


        Label{
            id: done_text
            anchors.right: parent.right
            anchors.rightMargin: buttons_spacing
            anchors.top: repetition_input.bottom
            anchors.topMargin: 4*root.max_error_pixelsize
            font.pixelSize: buttons_pixelsize
            text: "DONE"
            font.bold: done_button.pressed
            color: Constants.VIBRANT_COLOR

            CustomButton{
                id: done_button
                anchors.fill: parent

                onClicked:{
                    if(repetition_input.text.length>=root.username_min_chars){
                        done(repetition_input.text);
                    }
                    else{
                        error_root.errorAnimation();
                    }
                }
            }
        }

        Label{
            id: cancel_text
            anchors.right: done_text.left
            anchors.rightMargin: buttons_spacing
            anchors.top: repetition_input.bottom
            anchors.topMargin: 4*root.max_error_pixelsize
            font.pixelSize: buttons_pixelsize
            text: "CANCEL"
            font.bold: cancel_button.pressed
            color: Constants.VIBRANT_COLOR

            CustomButton{
                id: cancel_button
                anchors.fill: parent

                onClicked:{
                    close();
                }
            }
        }





    }

























}
