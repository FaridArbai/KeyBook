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

    property int href   :   1135;
    property int wref   :   720;

    property int buttons_pixelsize      :   (34/href)*root.height;
    property int buttons_side_margin    :   (1/8)*root.width;
    property int buttons_bottom_margin  :   (1/10)*root.height;
    property int rotatebutton_size      :   2*buttons_pixelsize;

    property int imagecontainer_side_margin    :   (1/32)*root.width;

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
            root.goBack();
        }
    }

    Button{
        id: rotate_button;
        anchors.left: parent.left;
        anchors.leftMargin: (root.width-width)/2;
        anchors.bottom: cancel_button.bottom
        anchors.bottomMargin: -((17/16)*height-buttons_pixelsize)/2
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
            console.log(image.sourceSize.height);
            console.log(image.sourceSize.width);
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
        value: 0.5

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
    }


    Rectangle{
        id: image_container
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: slider.bottom
        anchors.margins: imagecontainer_side_margin
        color: "white"

        Image{
            id: image
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: main_frame.getCurrentImagePath();
        }
    }










































































    function goBack(){
        main_frame.changeStatusbarColor(Constants.CONTACTS_STATUSBAR_COLOR);
        root.StackView.view.pop();
    }
}










































