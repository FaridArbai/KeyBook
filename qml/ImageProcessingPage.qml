import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import "Constants.js" as Constants

Page{
    id: root

    background:Rectangle{
        height:root.height;
        width:root.width;
        color:"black";
    }

    property string image_source;

    property int href   :   1135;
    property int wref   :   720;

    property int buttons_pixelsize      :   (34/href)*root.height;
    property int buttons_side_margin    :   (1/8)*root.width;
    property int buttons_bottom_margin  :   (1/10)*root.height;
    property int rotatebutton_size      :   2*buttons_pixelsize;

    property int imagecontainer_side_margin    :   (1/16)*root.width;

    property int lines_width        :   (2);
    property real spacing_factor    :   ((3-(2*Math.sqrt(2)))/6);
    property int lines_spacing      :   spacing_factor*canvas.width;

    property int angle  :   0;

    Button{
        id: cancel_button;
        anchors.right: rotate_button.left
        anchors.rightMargin: ((root.width-rotatebutton_size)/2-width)/2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: buttons_bottom_margin
        height: cancel_label.height
        width: cancel_label.width
        background: Rectangle{color:Constants.TRANSPARENT}

        Label{
            id: cancel_label
            padding:{
                top: 0
                bottom: 0
                left: 0
                right: 0
            }
            font.pixelSize: buttons_pixelsize
            color: Constants.RELEVANT_TEXT_WHITE
            text: "CANCEL"
        }

        onClicked: {
            root.goBack();
        }
    }

    Button{
        id: done_button;
        anchors.left: rotate_button.right
        anchors.leftMargin: ((root.width-rotatebutton_size)/2-width)/2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: buttons_bottom_margin
        height: done_label.height
        width: done_label.width
        background: Rectangle{color:Constants.TRANSPARENT}

        Label{
            id: done_label
            padding:{
                top: 0
                bottom: 0
                left: 0
                right: 0
            }
            font.pixelSize: buttons_pixelsize
            color: Constants.RELEVANT_TEXT_WHITE
            text: "DONE"
        }

        onClicked: {
            var x = (canvas.x/image.width)*image.sourceSize.width;
            var width = (canvas.width/image.width)*image.sourceSize.width;
            var y = (canvas.y/image.height)*image.sourceSize.height;
            var height = (canvas.height/image.height)*image.sourceSize.height;

            main_frame.saveRetouchedImage(image_source,x,y,width,height,image.angle);

            root.goBack();
        }
    }

    Button{
        id: rotate_button;
        anchors.left: parent.left;
        anchors.leftMargin: (root.width-width)/2;
        anchors.bottom: cancel_button.bottom
        anchors.bottomMargin: -((7/8)*height-buttons_pixelsize)/2
        height: rotatebutton_size
        width: rotatebutton_size
        background: Rectangle{color:Constants.TRANSPARENT}

        OpacityMask{
            anchors.fill: parent
            source: logo_bg
            maskSource: logo_mask

            Image{
                id: logo_mask
                anchors.fill: parent
                source: "icons/whiterotateicon.png"
                visible: false
            }

            Rectangle{
                id: logo_bg
                anchors.fill: parent
                color: Constants.RELEVANT_TEXT_WHITE
                visible: false
            }
        }

        onClicked: {
            image.last_size = image.size;
            image.angle = (image.angle + 90)%360;
        }
    }

    Slider{
        id: slider;
        anchors.bottom: cancel_button.top
        anchors.bottomMargin: buttons_bottom_margin
        anchors.left: parent.left
        anchors.leftMargin: buttons_side_margin
        width: (3/4)*root.width
        height: (3/4)*root.buttons_pixelsize
        value: (image_container.initial_canvas_size)/Math.min(image_container.height,image_container.width);

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: slider.width
            height: parent.height/8
            radius: height/2
            color: "grey"

            Rectangle{
                width: slider.visualPosition * parent.width
                height: parent.height
                color: "lightgrey"
                radius: parent.radius
            }
        }

        handle: Rectangle{
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight/2 - height/2
            height: slider.height
            width: slider.height
            radius: height/2
            color: slider.pressed ? "white" : "lightgrey"
            border.color: "grey"
        }

        onValueChanged: {
            var size = value*image.size;
            var dsize = size - canvas.width;
            var x = canvas.x - dsize/2;
            var y = canvas.y - dsize/2;

            if(x<0){
                x = 0;
            }
            else if(x+size>image.width){
                x = image.width - size;
            }

            if(y<0){
                y = 0;
            }
            else if(y+size>image.height){
                y = image.height - size;
            }

            canvas.x = x;
            canvas.y = y;
            canvas.height = size;
            canvas.width = size;
            //mask.maskSource = canvas
        }
    }


    Rectangle{
        id: image_container
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: slider.top
        anchors.margins: imagecontainer_side_margin
        color: "black"

        property int container_height   :   (image.keeps_axis)?(height):(width);
        property int container_width    :   (image.keeps_axis)?(width):(height);
        property real ratio             :   (container_width/container_height);
        property int initial_canvas_size:   Math.min(height,width)/2;

        Image{
            id: image
            anchors.centerIn: parent
            height: (is_portrait)?(parent.container_height):(parent.container_width/image.ratio)
            width: (is_portrait)?(parent.container_height*image.ratio):(parent.container_width)
            fillMode: Image.PreserveAspectFit
            source: image_source
            transformOrigin: Item.Center
            rotation: angle

            property int size           :   Math.min(height,width);
            property int last_size      :   0;
            property real ratio         :   (image.sourceSize.width/image.sourceSize.height);
            property int angle          :   0;
            property bool keeps_axis    :   ((angle==0)||(angle==180));
            property bool is_portrait   :   (ratio<image_container.ratio);


            MouseArea{
                id: image_bg
                anchors.fill: parent

                drag{
                    target: canvas
                    axis: Drag.XandYAxis
                    minimumX: 0
                    maximumX: image.width-canvas.width
                    minimumY: 0
                    maximumY: image.height-canvas.height
                }
            }

            Rectangle{
                id: canvas
                x: 0
                y: 0
                height: image_container.initial_canvas_size
                width:  image_container.initial_canvas_size
                //border.width: 1
                //border.color: "red"
                //color: "transparent"
                visible: false
            }

            onRotationChanged: {
                var scale_factor = (image.size/image.last_size);
                canvas.height = canvas.height*scale_factor;
                canvas.width = canvas.width*scale_factor;
                canvas.x = canvas.x*scale_factor;
                canvas.y = canvas.y*scale_factor;
            }
        }

        Rectangle{
            anchors.fill: image
            transformOrigin: Item.Center
            rotation: image.angle
            color: Constants.IMAGEPROCESSING_MASK
        }

        Rectangle{
            id: background_mask
            anchors.fill: image
            color: "transparent"
            visible: false

            Rectangle{
                id: moving_mask
                x: canvas.x
                y: canvas.y
                height: canvas.height
                width: canvas.width
                radius: width/2
                color: "white"
            }
        }


        Image{
            id: image2
            anchors.fill: image
            fillMode: Image.PreserveAspectFit
            source: image_source
            transformOrigin: Item.Center
            rotation: image.angle
            layer.enabled: true
            layer.effect: OpacityMask{
                maskSource: background_mask
            }
        }


        Rectangle{
            id: image_tracker
            anchors.fill: image
            transformOrigin: Item.Center
            rotation: image.angle
            color: "transparent"

            Rectangle{
                id: canvas_border
                x: canvas.x
                y: canvas.y
                height: canvas.height
                width: canvas.width
                radius: width/2
                border.width: lines_width
                border.color: "lightgrey"
                color: Constants.IMAGEPROCESSING_CANVAS_COLOR

                Rectangle{
                    id: vertical_line1
                    anchors.top: parent.top
                    anchors.topMargin: lines_spacing
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: lines_spacing
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width/3-width/2
                    width: lines_width
                    color: "lightgrey"
                }

                Rectangle{
                    id: vertical_line2
                    anchors.top: parent.top
                    anchors.topMargin: lines_spacing
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: lines_spacing
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width/3-width/2
                    width: lines_width
                    color: "lightgrey"
                }

                Rectangle{
                    id: horizontal_line1
                    anchors.left: parent.left
                    anchors.leftMargin: lines_spacing
                    anchors.right: parent.right
                    anchors.rightMargin: lines_spacing
                    anchors.top: parent.top
                    anchors.topMargin: parent.height/3-height/2
                    height: lines_width
                    color: "lightgrey"

                }

                Rectangle{
                    id: horizontal_line2
                    anchors.left: parent.left
                    anchors.leftMargin: lines_spacing
                    anchors.right: parent.right
                    anchors.rightMargin: lines_spacing
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height/3-height/2
                    height: lines_width
                    color: "lightgrey"
                }
            }
        }









        /**
        Rectangle{
            x: image.x + canvas.x
            y: image.y + canvas.y
            height: canvas.height
            width: canvas.width
            clip: true
            radius: width/2

            Image{
                x: -canvas.x
                y: -canvas.y
                width: Math.min(container_width, implicitWidth);
                height: Math.min(container_height, implicitHeight);
                fillMode: Image.PreserveAspectFit
                source: main_frame.getCurrentImagePath();
                layer.enabled: true
                layer.effect: OpacityMask{
                    maskSource: parent
                }
            }



            Rectangle{
                id: vertical_line1
                anchors.top: parent.top
                anchors.topMargin: lines_spacing
                anchors.bottom: parent.bottom
                anchors.bottomMargin: lines_spacing
                anchors.left: parent.left
                anchors.leftMargin: parent.width/3-width/2
                width: lines_width
                color: "lightgrey"
            }

            Rectangle{
                id: vertical_line2
                anchors.top: parent.top
                anchors.topMargin: lines_spacing
                anchors.bottom: parent.bottom
                anchors.bottomMargin: lines_spacing
                anchors.right: parent.right
                anchors.rightMargin: parent.width/3-width/2
                width: lines_width
                color: "lightgrey"
            }

            Rectangle{
                id: horizontal_line1
                anchors.left: parent.left
                anchors.leftMargin: lines_spacing
                anchors.right: parent.right
                anchors.rightMargin: lines_spacing
                anchors.top: parent.top
                anchors.topMargin: parent.height/3-height/2
                height: lines_width
                color: "lightgrey"

            }

            Rectangle{
                id: horizontal_line2
                anchors.left: parent.left
                anchors.leftMargin: lines_spacing
                anchors.right: parent.right
                anchors.rightMargin: lines_spacing
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height/3-height/2
                height: lines_width
                color: "lightgrey"
            }
        }
        **/























        /**
        Rectangle{
            id: bg
            anchors.fill: image
            color: "#00FFFFFF"
            visible: false

            Rectangle{
                id: fg
                x: canvas.x
                y: canvas.y
                width: canvas.width
                height: canvas.height
                color: "#FFFFFFFF"
                visible: false
            }
        }
        **/

        /**
        OpacityMask{
            id: mask
            x: canvas.x + image.x
            y: canvas.y + image.y
            height: canvas.height
            width: canvas.width
            source: image
            maskSource: canvas
        }
        **/

    }










































































    function goBack(){
        main_frame.changeStatusbarColor(Constants.CONTACTS_STATUSBAR_COLOR);
        root.StackView.view.pop();
    }
}










































