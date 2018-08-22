import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

Button {
    id: button
    background: Rectangle{color: "transparent"}

    property string animationColor  :   Constants.Button.DARK_ANIMATION_COLOR;
    property int animationDuration  :   Constants.Button.ANIMATION_DURATION;
    property bool circular          :   false;
    property int easingType         :   Easing.OutQuad;
    property bool asynchronous      :   false;

    MouseArea{
        id: mouse_area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            var max_hor = Math.max(mouseX, button.width-mouseX);
            var max_vert = Math.max(mouseY, button.height-mouseY);
            var size = Math.sqrt(max_hor*max_hor + max_vert*max_vert);
            bubble.initial_x = mouseX;
            bubble.initial_y = mouseY;
            bubble.max_radius = size;
            bubble.start();
            click_delay.start();
        }

        onPressAndHold: {
            var max_hor = Math.max(mouseX, button.width-mouseX);
            var max_vert = Math.max(mouseY, button.height-mouseY);
            var size = Math.sqrt(max_hor*max_hor + max_vert*max_vert);
            bubble.initial_x = mouseX;
            bubble.initial_y = mouseY;
            bubble.max_radius = size;
            bubble.start();
            click_delay.start();
        }

        onEntered: {
            expansion_area.animateEnter();
            exit_handler.start();
        }

        onExited: {
            expansion_area.animateExit();
        }
    }

    Timer{
        id: exit_handler
        interval: 250
        repeat: true
        onTriggered: {
            if((!mouse_area.containsMouse)){
                if(!expansion_area.exitAnimation.running){
                   if(expansion_area.bg_transparency>0){
                        expansion_area.exitAnimation.start();
                   }
                }
                stop();
            }
        }
    }

    Timer{
        id: click_delay
        interval: button.asynchronous ? 0 : button.animationDuration
        onTriggered: {
            button.clicked();
        }
    }

    Rectangle{
        id: expansion_area
        anchors.fill: parent
        color: Constants.addTransparency(bg_transparency,  button.animationColor);
        clip: true
        layer.enabled: circular
        layer.effect: OpacityMask{
            maskSource: mask
        }

        Rectangle{
            id: mask
            width: parent.width
            height: parent.height
            radius: width/2
            visible: false
        }

        property int bg_transparency    :   0;
        property int max_transparency   :  0;
        property alias exitAnimation    :   exit_animation;

        function animateEnter(){
            enter_animation.start();
        }

        function animateExit(){
            exit_animation.start();
        }

        PropertyAnimation{
            id: enter_animation
            target: expansion_area
            property: "bg_transparency"
            to: 32
            duration: 250
            easing.type: Easing.Linear
        }

        PropertyAnimation{
            id: exit_animation
            target: expansion_area
            property: "bg_transparency"
            to: 0
            duration: 250
            easing.type: Easing.Linear
        }

        Rectangle{
            id: bubble
            color: Constants.addTransparency(transparency,  button.animationColor);
            width: 2*radius;
            height: 2*radius;
            radius: 0;
            x: initial_x - radius;
            y: initial_y - radius;

            property int initial_x          :   0;
            property int initial_y          :   0;
            property int transparency       :   0;
            property int max_radius         :   button.height;

            function start(){
                bubble_animation.start();
            }

            ParallelAnimation{
                id: bubble_animation

                PropertyAnimation{
                    target: bubble
                    property: "radius"
                    from: 0
                    to: bubble.max_radius
                    duration: button.animationDuration
                    easing.type: button.easingType
                }

                PropertyAnimation{
                    target: bubble
                    property: "transparency"
                    from: 128
                    to: 0
                    duration: button.animationDuration
                    easing.type: button.easingType
                }
            }
        }
    }
}
