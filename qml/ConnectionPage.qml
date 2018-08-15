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

    property int logo_top_pad           :   (90/href)*log_height + main.statusbar_height;
    property int logo_size              :   (194/href)*log_height;

    Rectangle{
        id: page_bg
        anchors.fill: parent
        color: Constants.TOOLBAR_COLOR
    }

    Component.onCompleted: {
        main_frame.changeStatusbarColor(statusbar_color);
        dots_controller.start();
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


    Rectangle{
        id: loading_box
        height: 3*logo.height/8;
        width: (loading_indicator.width + loading_text.anchors.leftMargin + loading_text.width)
        anchors.top: parent.top
        anchors.topMargin: (parent.height-height)/2
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - width)/2
        color: "transparent"
        clip: false

        OpacityMask{
            id: loading_indicator
            anchors.top: parent.top
            anchors.left: parent.left
            height: parent.height
            width: parent.height
            source: color_background
            maskSource: animated_mask

            AnimatedImage{
                id: animated_mask
                anchors.fill: parent
                source: "icons/loading.gif"
                fillMode: Image.PreserveAspectFit
                visible: false
                mipmap: true
            }

            Rectangle{
                id: color_background
                anchors.fill: parent
                color: Constants.GENERAL_TEXT_WHITE
                visible: false
            }
        }

        Label{
            id: loading_text
            font.pixelSize: (6/16)*loading_indicator.height
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.left: loading_indicator.right
            anchors.leftMargin: font.pixelSize
            text: "Connecting to server"
            color: Constants.GENERAL_TEXT_WHITE
        }

        Label{
            id: dots
            font.pixelSize: loading_text.font.pixelSize
            anchors.top: loading_text.top
            anchors.left: loading_text.right
            text: "..."
            color: Constants.GENERAL_TEXT_WHITE
        }
    }

    Timer{
        id: dots_controller
        interval: 1000
        repeat: true
        onTriggered: {
            if(dots.text.toString()==="..."){
                dots.text = "";
            }
            else{
                dots.text = dots.text + ".";
            }
        }
    }



































}
