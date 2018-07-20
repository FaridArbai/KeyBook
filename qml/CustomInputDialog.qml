import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

Item {
    id: container
    visible: false
    enabled: false
    z: -max_z

    signal opening();
    signal closing();
    signal done(string text);

    function open(){
        container.enabled = true;
        opening();
        open_animation.start();
    }

    function close(){
        container.enabled = false;
        closing();
        close_animation.start();
    }


    SequentialAnimation{
        id: open_animation

        PropertyAction{
            target: container
            property: "z"
            value: max_z
        }

        PropertyAction{
            target: container
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
            target: container
            property: "visible"
            value: false
        }

        PropertyAction{
            target: container
            property: "z"
            value: -max_z
        }
    }


    property bool opened            :   false;
    property string icon_source     :   "icons/whitehandkeyicon.png";
    property string title_text      :   "Update latchkey";
    property string initial_text    :   "";
    property string hint            :   "Type new Latchkey here";
    property int max_chars          :   16;
    property int min_chars          :   6;
    property int max_z              :   1000;

    property int vert_padding          :   0.15*dialog.height;
    property int hor_padding           :   0.07*dialog.width;
    property int title_pixelsize       :   0.13*dialog.height;
    property int text_toppadding       :   0.15*dialog.height;
    property int text_pixelsize        :   0.105*dialog.height;
    property int buttons_pixelsize     :   0.09*dialog.height;
    property int buttons_bottompadding :   0.15*dialog.height;
    property int buttons_spacing       :   0.086*dialog.width;

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
        width: container.width*0.86
        height: container.height*0.25
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
            text: "Update Latchkey"
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
                    source: "icons/whitehandkeyicon.png"
                    visible: false
                }

            }
        }

        TextArea{
            id: dialog_text
            anchors.top: title.bottom
            anchors.topMargin: text_toppadding
            anchors.left: parent.left
            anchors.leftMargin: hor_padding
            anchors.right: parent.right
            anchors.rightMargin: hor_padding
            rightPadding: 2*text_pixelsize
            font.pixelSize: text_pixelsize
            placeholderText: "Enter new latchkey here"
            text: ""
            color: "black"
            opacity: 0.7

            Label{
                id: counter
                anchors.right: parent.right
                anchors.rightMargin: text_pixelsize/2
                anchors.bottom: parent.bottom
                text: max_chars - dialog_text.text.length
                color: "black"
                font.pixelSize: (7/8)*text_pixelsize
            }

            onTextChanged:{
                var new_line = text.charAt(text.length-1)=='\n';
                var exceeds = (text.length>max_chars);
                var too_short = (text.length<min_chars);

                if(new_line||exceeds){
                    text = text.substring(0,text.length-1);
                    dialog_text.cursorPosition = dialog_text.length;
                }
            }

            onActiveFocusChanged: {
                if(activeFocus){
                    dialog_text.cursorPosition = dialog_text.length;
                }
            }
        }

        Rectangle{
            anchors.left: dialog_text.left
            anchors.top: dialog_text.bottom
            height: 5
            width: dialog_text.width
            color: Constants.TOOLBAR_COLOR
        }

        Label{
            id: done_text
            anchors.right: parent.right
            anchors.rightMargin: buttons_spacing
            anchors.bottom: parent.bottom
            anchors.bottomMargin: vert_padding
            font.pixelSize: buttons_pixelsize
            text: "DONE"
            font.bold: done_button.pressed
            color: Constants.VIBRANT_COLOR

            Button{
                id: done_button
                anchors.fill: parent
                background: Rectangle{color:"transparent"}
                onClicked:{
                    done(dialog_text.text);
                }
            }
        }

        Label{
            id: cancel_text
            anchors.right: done_text.left
            anchors.rightMargin: buttons_spacing
            anchors.bottom: parent.bottom
            anchors.bottomMargin: vert_padding
            font.pixelSize: buttons_pixelsize
            text: "CANCEL"
            font.bold: cancel_button.pressed
            color: Constants.VIBRANT_COLOR

            Button{
                id: cancel_button
                anchors.fill: parent
                background: Rectangle{color:"transparent"}
                onClicked:{
                    close();
                }
            }
        }





    }

























}
