import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page {
    id: root

    property bool avatar_changed : false;
    property bool block_buttons : false;

    property int href   :   1135;
    property int wref   :   720;
    property int cref   :   715;

    property int buttons_size           :   icons_size
    property int icons_size             :   (34/wref)*root.width;
    property int side_margin            :   (Constants.SIDE_FACTOR)*root.width;
    property int pad_buttons            :   (Constants.SPACING_FACTOR)*root.width;

    property int remaining_height       :   root.height-root.width;

    property int name_pixelsize         :  (70/href)*root.height;

    property int statuscontainer_height :   (5/8)*remaining_height;

    property int statusindicator_pixelsize  :   (79/cref)*statuscontainer_height; //18,16,14
    property int statustext_pixelsize       :   (70/cref)*statuscontainer_height;
    property int statusdate_pixelsize       :   (53/cref)*statuscontainer_height;
    property int statusindicator_top_margin :   (statuscontainer_height/6)-statusindicator_pixelsize/2;
    property int statustext_top_margin      :   (5*statuscontainer_height/12)-statusindicator_pixelsize/2;
    property int left_margin                :   (1/15)*root.width;

    property int status_max_width           :   root.width-(3*left_margin+changestatus_button.width+separator.anchors.rightMargin);

    property int changestatusbutton_size    :   statustext_pixelsize;

    property int shadow_offset      :   root.height/200;

    property int text_box_width      :   status_max_width + (root.width-status_max_width)/2;
    property int text_box_height     :   statuscontainer_height;
    property int text_box_radius     :   text_box_height/32;
    property int text_box_y          :   (root.width-text_box_height)/2;
    property int text_box_x          :   (root.width-text_box_width)/2;
    property int text_box_buttons_height :   text_box_height/4;

    property int statusline_width           :   status_max_width;
    property int statusline_height          :   (4/cref)*remaining_height;
    property int text_box_maxchars_width    :   3*statustext_pixelsize;

    function openRetoucher(image_source){
        main_frame.changeStatusbarColor(Constants.IMAGEPROCESSING_STATUSBAR_COLOR);
        root.StackView.view.push("qrc:/ImageProcessingPage.qml",
                                 {image_source : image_source});
    }

    Rectangle{
        id: background
        anchors.fill: parent
        color: Constants.ProfilePage.PADDING_COLOR
        z:-1
    }

    Connections{
        target: main_frame

        onStatusChanged:{
            statustext.text = new_status_gui + "\n On " + new_date_gui;
        }

        onAvatarChanged:{
            profileimage.source = main_frame.getCurrentImagePath();
            avatar_changed = true;
        }

        onAvatarChanging:{
            openRetoucher(selected_image_path);
        }

        onFinishedUploadingImage:{
            avatar_changed = false;
            root.StackView.view.pop();
        }

        onWaitingForTooLong:{
            wait_box.visible = true;
        }
    }

    Rectangle{
        id: toolbar
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: main.toolbar_height
        color: "transparent"
        z: 1

        ToolButton {
            id: backbutton
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.left: parent.left
            anchors.leftMargin: side_margin;
            height: buttons_size
            width: buttons_size

            background: Rectangle{
                anchors.fill: parent
                color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TRANSPARENT

                Image {
                    id: backicon
                    anchors.centerIn: parent
                    source: "icons/whitebackicon.png"
                    height: icons_size
                    width: icons_size
                }
            }

            onClicked:{
                if(avatar_changed){
                    block_buttons = true;
                    main_frame.sendAvatar();
                }
                else{
                    root.StackView.view.pop()
                }
            }
        }

        ToolButton {
            id: optionsbutton
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.right: parent.right
            anchors.rightMargin: side_margin;
            height: buttons_size
            width: buttons_size

            background: Rectangle{
                anchors.fill: parent
                color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TRANSPARENT

                Image {
                    id: optionsicon
                    anchors.centerIn: parent
                    source: "icons/whiteoptionsicon.png"
                    height: icons_size
                    width: icons_size
                }
            }

            onClicked:{
                root.openRetoucher(profileimage.source);
            }
        }
    }

    Rectangle{
        id: image_container
        anchors.left: parent.left
        anchors.top: parent.top
        width: parent.width
        height: parent.width
        color: "white"

        Image {
            id: profileimage
            width: parent.width
            height: parent.width
            source: main_frame.getCurrentImagePath()
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        DropShadow {
            anchors.fill: parent
            horizontalOffset: 0
            verticalOffset: root.height/200
            radius: 2*(verticalOffset)
            samples: (2*radius+1)
            cached: true
            color: Constants.DROPSHADOW_COLOR
            source: profileimage
        }

        Button{
            id: changeavatar_button
            anchors.fill: parent
            background:Rectangle{color:"transparent"}

            onClicked: {
                //profileimagefiledialog.open()
                if(block_buttons==false){
                    main_frame.openImagePicker();
                }
            }
        }
    }


    Label {
        id: nametext
        anchors.left: parent.left
        anchors.leftMargin: name_pixelsize/2
        anchors.bottom: image_container.bottom
        anchors.bottomMargin: name_pixelsize/2
        font.bold: true
        font.pixelSize: name_pixelsize
        text: main_frame.getCurrentUsername()
        color: "white"
        background: Rectangle{color:"transparent"}
    }

    DropShadow {
        anchors.fill: status_container_bg
        horizontalOffset: 0
        verticalOffset: root.height/200
        radius: 2*(verticalOffset)
        samples: (2*radius+1)
        cached: true
        color: Constants.DROPSHADOW_COLOR
        source: status_container_bg
    }

    Rectangle{
        id: status_container_bg
        anchors.fill: status_container
        color: "white"
        visible: false
    }

    Rectangle{
        id: status_container
        anchors.top: image_container.bottom
        anchors.topMargin: (remaining_height-height)/2;
        anchors.left: parent.left
        anchors.right: parent.right
        height: statuscontainer_height
        color: "transparent"

        Label{
            id: status_indicator
            anchors.top: parent.top
            anchors.topMargin: statusindicator_top_margin
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            padding: 0
            font.bold: false
            font.pixelSize: statusindicator_pixelsize
            color: Constants.ProfilePage.STATUSINDICATOR_COLOR
            text: "Status"
        }

        Label{
            id: status_text
            anchors.top: parent.top
            anchors.topMargin: statustext_top_margin
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            padding: 0
            font.bold: false
            font.pixelSize: statustext_pixelsize
            color: Constants.ProfilePage.TEXT_COLOR
            text: main_frame.getCurrentStatus();
        }

        Label{
            id: status_date
            anchors.top: status_text.bottom
            anchors.topMargin: statustext_pixelsize
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            padding: 0
            font.bold: false
            font.italic: true
            font.pixelSize: statusdate_pixelsize
            color: Constants.ProfilePage.TEXT_COLOR
            text: "Last updated on " + main_frame.getCurrentStatusDate();
        }

        Button{
            id: changestatus_button
            anchors.top: status_text.top
            anchors.topMargin: status_text.height/2-height/2
            anchors.right: parent.right
            anchors.rightMargin: left_margin
            height: changestatusbutton_size
            width: changestatusbutton_size

            background: Rectangle{color:"transparent"}

            OpacityMask{
                id: changestatus_icon
                anchors.fill: parent
                source: changestatus_source
                maskSource: changestatus_mask


                Rectangle{
                    id: changestatus_source
                    anchors.centerIn: parent
                    height: statustext_pixelsize
                    width: statustext_pixelsize
                    color: Constants.ProfilePage.TEXT_COLOR
                    visible: false
                }

                Image{
                    id: changestatus_mask
                    anchors.centerIn: parent
                    height: statustext_pixelsize
                    width: statustext_pixelsize
                    fillMode: Image.PreserveAspectFit
                    source: "icons/whitepencilicon.png"
                    visible: false
                }
            }

            onClicked: {
                text_box.open();

                /**
                if(block_buttons==false){
                    root.StackView.view.push("qrc:/ChangeStatusPage.qml")
                }
                **/
            }
        }

        Rectangle{
            id: separator
            anchors.top: changestatus_button.top
            anchors.topMargin: changestatus_button.height/2 - height/2
            anchors.right: changestatus_button.left
            anchors.rightMargin: 3*left_margin/4
            width: 1
            height: 2*changestatus_button.height
            color: Constants.ProfilePage.TEXT_COLOR
        }
    }

    Rectangle{
        id: text_box
        y: (1-a)*(changestatus_button.y+status_container.y) + a*(text_box_y);
        x: (1-a)*changestatus_button.x + a*(text_box_x);
        width: (1-a)*changestatusbutton_size + a*text_box_width
        height: (1-a)*changestatusbutton_size + a*text_box_height
        radius: text_box_radius
        visible: enabled
        enabled: (a>ath)
        color: Constants.ProfilePage.TEXTBOX_COLOR
        z: 3
        opacity: a

        layer.enabled: visible
        layer.effect: DropShadow{
            height: text_box.height
            width: text_box.width
            verticalOffset: shadow_offset
            horizontalOffset: shadow_offset
            radius: 2*verticalOffset
            samples: 2*radius+1
            color: Constants.DROPSHADOW_COLOR
        }

        property real a     :   0;
        property real ath   :   0.05;



        function open(){
            show.start();
        }

        function close(){
            hide.start();
        }

        PropertyAnimation{
            id: show
            target: text_box
            property: "a"
            to: 1
            duration: 250

            onRunningChanged:{
                if(running==false){
                    new_status.forceActiveFocus();
                }
            }
        }

        PropertyAnimation{
            id: hide
            target: text_box
            property: "a"
            to: 0
            duration: 250
        }

        Button{
            id: text_box_touch_protector
            anchors.fill: parent
            background:Rectangle{color:"transparent"}
            onClicked:{}
        }

        Label{
            id: text_box_indicator
            anchors.top: parent.top
            anchors.topMargin: (statusindicator_top_margin)*text_box.a
            anchors.left: parent.left
            anchors.leftMargin: left_margin*(text_box.a)
            font.bold:  false
            font.pixelSize: statusindicator_pixelsize*text_box.a
            color: Constants.ProfilePage.STATUSINDICATOR_COLOR;
            text: "Update status"
        }

        TextArea{
            id: new_status
            anchors.top: parent.top
            anchors.topMargin: (statustext_top_margin)*text_box.a
            anchors.left: parent.left
            anchors.leftMargin: left_margin*(text_box.a)
            width: (status_max_width - text_box_maxchars_width)*text_box.a
            font.bold: false
            font.pixelSize: statustext_pixelsize*text_box.a
            text: status_text.text
            background: Rectangle{color:"transparent"}

            onActiveFocusChanged: {
                if(activeFocus){
                    cursorPosition = length;
                }
            }
        }

        Rectangle{
            id: status_line
            anchors.bottom: new_status.bottom
            anchors.left: new_status.left
            width: statusline_width*(text_box.a)
            height: statusline_height
            color: Constants.ProfilePage.STATUSINDICATOR_COLOR;
        }

        Label{
            id: remaining_chars
            anchors.top: status_text.top
            anchors.right: status_line.right
            anchors.rightMargin: statusline_width/2-width/2
            font.pixelSize: statustext_pixelsize
            font.bold: false
            text: Constants.ProfilePage.STATUS_MAXCHARS - status_text.length
        }

        Rectangle{
            id: horizontal_line
            anchors.bottom: parent.bottom
            anchors.bottomMargin: text_box_buttons_height
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Constants.ContactPage.SEPARATORS_COLOR
        }

        Rectangle{
            id: vertical_line
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: parent.width/2
            height: text_box_buttons_height
            width: 1
            color: Constants.ContactPage.SEPARATORS_COLOR
        }

        Button{
            id: cancel_button
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            height: text_box_buttons_height
            width: parent.width/2
            background: Rectangle{color:"transparent"}

            Label{
                id: cancel_text
                anchors.centerIn: parent
                font.bold: false
                font.pixelSize: (text_box.a)*statusindicator_pixelsize
                color: Constants.ProfilePage.STATUSINDICATOR_COLOR
                text: "Cancel"
            }

            onClicked: {
                text_box.close();
            }
        }

        Button{
            id: ok_button
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: text_box_buttons_height
            width: parent.width/2
            background: Rectangle{color:"transparent"}

            Label{
                id: ok_text
                anchors.centerIn: parent
                font.bold: false
                font.pixelSize: (text_box.a)*statusindicator_pixelsize
                color: Constants.ProfilePage.STATUSINDICATOR_COLOR
                text: "OK"
            }
        }
    }


    Button{
        id: hide_button
        anchors.fill: parent
        background:Rectangle{color:"transparent"}
        z: (text_box.enabled)?(text_box.z-1):(-1)

        onClicked:{
            text_box.close();
        }

    }





    Rectangle{
        id: wait_box;
        anchors.fill: parent
        height: parent.height
        width: parent.width
        visible: false;
        color: Qt.rgba(1,1,1,0.85);


        AnimatedImage{
            source: "icons/loading.gif"
            width: 3*parent.width/8
            height: 3*parent.width/8
            anchors.left: parent.left
            anchors.leftMargin: parent.width/2-width/2
            anchors.top: parent.top
            anchors.topMargin: parent.height/2-height/2
            fillMode: Image.PreserveAspectFit
        }

    }

}

















































