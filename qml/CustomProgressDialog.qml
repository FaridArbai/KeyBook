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
    z: -root.maxZ;

    property string text            :   "";
    property string statusbarColor  :   "";
    property int maxZ               :   1000;

    property bool opened    :   visible;

    property int wref           :   1440;
    property int dialog_width   :   (1255/wref)*main.app_width;
    property int dialog_height  :   (281/wref)*main.app_width;
    property int side_margin    :   (73/wref)*main.app_width;
    property int spinner_size   :   (132/wref)*main.app_width;
    property int text_pixelsize :   (49/wref)*main.app_width;

    function open(){
        main_frame.changeStatusbarColor(parseInt(Qt.darker(root.statusbarColor,5).toString().replace("#","0xFF")));
        open_animation.start();
    }

    function close(){
        main_frame.changeStatusbarColor(parseInt(root.statusbarColor.replace("#","0xFF")), 100);
        close_animation.start();
    }

    SequentialAnimation{
        id: open_animation

        PropertyAction{
            target: root
            property: "z"
            value: root.maxZ
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
            value: -root.maxZ
        }
    }


    Button{
        id: bg
        anchors.fill: parent
        background: Rectangle{
            color: "black"
            opacity: 0.8
        }

        onClicked:{}
    }

    Rectangle{
        id: dialog
        width: root.dialog_width
        height: root.dialog_height
        color: "white"
        radius: width/128
        anchors.centerIn: parent
        opacity: 0
        layer.enabled: true
        layer.effect: CustomElevation{
            source: dialog
        }
        /**
        AnimatedImage{
            id: spinner
            width: spinner_size
            height: spinner_size
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.left: parent.left
            anchors.leftMargin: root.side_margin
            source: "icons/loading.gif"
            fillMode: Image.PreserveAspectFit
        }
        **/

        OpacityMask{
            id: spinner
            width: spinner_size
            height: spinner_size
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.left: parent.left
            anchors.leftMargin: root.side_margin
            source: color_background
            maskSource: animated_mask

            AnimatedImage{
                id: animated_mask
                anchors.fill: parent
                source: "icons/loading.gif"
                fillMode: Image.PreserveAspectFit
                visible: false
            }

            Rectangle{
                id: color_background
                anchors.fill: parent
                color: Constants.VIBRANT_COLOR
                visible: false
            }
        }

        Label{
            id: dialog_text
            anchors.left: spinner.right
            anchors.leftMargin: side_margin
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            font.pixelSize: root.text_pixelsize
            text: root.text
            color: Constants.TextInput.TEXT_COLOR
        }
    }
























}
