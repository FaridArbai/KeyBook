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
    clip: true

    MouseArea{
        anchors.fill: parent

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
    }

    Timer{
        id: click_delay
        interval: 250
        onTriggered: {
            button.clicked();
        }
    }

    Rectangle{
        id: bubble
        color: Constants.addTransparency(transparency,"#F0F0F0");
        width: 2*radius;
        height: 2*radius;
        radius: 0;
        x: initial_x - radius;
        y: initial_y - radius;

        z:100000

        property int initial_x      :   0;
        property int initial_y      :   0;
        property int transparency  :   0;
        property int max_radius       :   button.height;

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
                duration: 250
            }

            PropertyAnimation{
                target: bubble
                property: "transparency"
                from: 255
                to: 0
                duration: 250
            }
        }
    }
}
