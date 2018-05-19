import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page{
    id: root
    visible:true

    property var statusbar_color    : contact.avatar_color_gui
    property string theme_color     : main.decToColor(statusbar_color);

    property int href   :   1135;
    property int wref   :   720;
    property int cref   :   715;

    property int max_z  :   5;

    property int buttons_size           :   icons_size
    property int icons_size             :   (34/wref)*root.width;
    property int side_margin            :   (Constants.SIDE_FACTOR)*root.width;
    property int pad_buttons            :   (Constants.SPACING_FACTOR)*root.width;

    property int remaining_height       :   root.height-root.width;

    property int name_pixelsize         :  (70/href)*root.height;

    property int statuscontainer_height :   (5/8)*remaining_height;
    property int statuscontainer_y      :   root.height-(root.width+(remaining_height-statuscontainer_height)/2);

    property int statusindicator_pixelsize  :   (79/cref)*statuscontainer_height; //18,16,14
    property int statustext_pixelsize       :   (70/cref)*statuscontainer_height;
    property int statusdate_pixelsize       :   (53/cref)*statuscontainer_height;
    property int statusindicator_top_margin :   (statuscontainer_height/6)-statusindicator_pixelsize/2;
    property int statustext_top_margin      :   statusindicator_top_margin + (7/4)*statusindicator_pixelsize;
    property int left_margin                :   (1/15)*root.width;

    property int status_max_width           :   root.width-2*left_margin;

    property int changestatusbutton_size    :   statustext_pixelsize;

    property int shadow_offset      :   root.height/200;


    property int separator_top_margin   :   statusdate_pixelsize
    property int presence_top_margin    :   statustext_top_margin-(statusindicator_top_margin+statusindicator_pixelsize);





    property int text_box_width      :   status_max_width + (root.width-status_max_width)/2;
    property int text_box_height     :   statuscontainer_height;
    property int text_box_radius     :   text_box_height/32;
    property int text_box_y          :   (root.width-text_box_height)/2;
    property int text_box_x          :   (root.width-text_box_width)/2;
    property int text_box_buttons_height :   text_box_height/4;
    property string text_box_buttons_bg    :   theme_color.replace("#FF",("#"+Constants.ProfilePage.BUTTONS_BG_TRANSPARENCY));

    property int statusline_width           :   status_max_width;
    property int statusline_height          :   (4/cref)*remaining_height;
    property int statusline_top_margin      :   (1/4)*statustext_pixelsize;

    property int text_box_maxchars_pixelsize    :   (3/4)*statustext_pixelsize;
    property int text_box_maxchars_width        :   3*text_box_maxchars_pixelsize;


    onStatusbar_colorChanged: {
        main_frame.changeStatusbarColor(statusbar_color);
    }

    Rectangle{
        id: background
        anchors.fill: parent
        color: Constants.ProfilePage.PADDING_COLOR
        z:-1
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
                backbutton.action();
            }

            function action(){
                root.goBack();
            }
        }

        ToolButton {
            id: options_button
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
                options.open();
            }

        }
    }

    Rectangle{
        id: options
        height: (1-a)*options_button.height + (a)*max_height;
        width:  (1-a)*options_button.width + (a)*max_width;
        y:  (1-a)*options_button.y + (a)*max_y;
        x:  (1-a)*options_button.x + (a)*max_x;
        radius: (Constants.MENU_RADIUS_FACTOR)*width
        color: Constants.MENU_COLOR;
        opacity: a*(Constants.MENU_TRANSPARENCY/0xFF);
        visible: enabled;
        enabled: a>(Constants.MENU_ENABLED_THRESHOLD);
        z: root.max_z;

        property real a             :   0;
        property int n_items        :   4;
        property int pixelsize      :   (Constants.MENUITEM_PIXEL_FACTOR/root.href)*root.height;
        property int vertical_pad   :   (Constants.MENU_VERTICALPAD_FACTOR)*pixelsize;
        property int max_height     :   n_items*(Constants.MENUITEM_HEIGHT_FACTOR)*pixelsize + 2*vertical_pad;
        property int max_width      :   (Constants.MENU_WIDTH_FACTOR)*root.width;
        property int item_height    :   (Constants.MENUITEM_HEIGHT_FACTOR)*pixelsize;
        property int item_width     :   max_width;
        property int border_margin  :   (Constants.MENU_BORDERMARGIN_FACTOR)*root.width;
        property int max_y          :   (border_margin);
        property int max_x          :   (root.width - (border_margin + max_width));



        function open(){
            open_menu.start();
        }

        function close(){
            close_menu.start();
        }

        PropertyAnimation{
            id: open_menu
            target: options
            property: "a"
            to: 1
            duration: Constants.MENU_TRANSITIONS_DURATION
        }

        PropertyAnimation{
            id: close_menu
            target: options
            property: "a"
            to: 0
            duration: Constants.MENU_TRANSITIONS_DURATION
        }

        Button{
            id: changeavatar_option
            anchors.top: parent.top
            anchors.topMargin: a*options.vertical_pad
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: changeavatar_option.height
                width: changeavatar_option.width
                color: changeavatar_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
            }

            Label{
                anchors.top: parent.top
                anchors.topMargin: parent.a*options.pixelsize
                anchors.left: parent.left
                anchors.leftMargin: parent.a*options.pixelsize
                padding: 0
                font.pixelSize: parent.a*options.pixelsize
                font.bold: false
                text: "Change latchkey"
                opacity: parent.a
            }

            onClicked: {
            }
        }

        Button{
            id: retouchavatar_option
            anchors.top: changeavatar_option.bottom
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: retouchavatar_option.height
                width: retouchavatar_option.width
                color: retouchavatar_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
            }

            Label{
                anchors.top: parent.top
                anchors.topMargin: parent.a*options.pixelsize
                anchors.left: parent.left
                anchors.leftMargin: parent.a*options.pixelsize
                padding: 0
                font.pixelSize: parent.a*options.pixelsize
                font.bold: false
                text: "Start conversation"
                opacity: parent.a
            }

            onClicked:{
            }
        }

        Button{
            id: changestatus_option
            anchors.top: retouchavatar_option.bottom
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: changestatus_option.height
                width: changestatus_option.width
                color: changestatus_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
            }

            Label{
                anchors.top: parent.top
                anchors.topMargin: parent.a*options.pixelsize
                anchors.left: parent.left
                anchors.leftMargin: parent.a*options.pixelsize
                padding: 0
                font.pixelSize: parent.a*options.pixelsize
                font.bold: false
                text: "Delete conversations"
                opacity: parent.a
            }

            onClicked:{
            }
        }

        Button{
            id: managecontacts_option
            anchors.top: changestatus_option.bottom
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: managecontacts_option.height
                width: managecontacts_option.width
                color: managecontacts_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
            }

            Label{
                anchors.top: parent.top
                anchors.topMargin: parent.a*options.pixelsize
                anchors.left: parent.left
                anchors.leftMargin: parent.a*options.pixelsize
                padding: 0
                font.pixelSize: parent.a*options.pixelsize
                font.bold: false
                text: "Block contact"
                opacity: parent.a
            }

            onClicked:{
                backbutton.action();
                options.close();
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
            source: contact.avatar_path_gui
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
    }

    Label {
        id: nametext
        anchors.left: parent.left
        anchors.leftMargin: name_pixelsize/2
        anchors.bottom: image_container.bottom
        anchors.bottomMargin: name_pixelsize/4
        font.bold: true
        font.pixelSize: name_pixelsize
        text: main_frame.getCurrentUsername()
        color: "white"
        background: Rectangle{color:"transparent"}
    }

    Rectangle{
        id: status_container
        anchors.top: image_container.bottom
        anchors.topMargin: ((remaining_height-height)/2)
        anchors.left: parent.left
        width: root.width
        color: "white"

        layer.enabled: true
        layer.effect: DropShadow {
            width: status_container.width
            height: status_container.height
            horizontalOffset: 0
            verticalOffset: root.height/200
            radius: 2*(verticalOffset)
            samples: (2*radius+1)
            cached: true
            color: Constants.DROPSHADOW_COLOR
            source: status_container
        }

        Label{
            id: status_indicator
            anchors.top: parent.top
            anchors.topMargin: statusindicator_top_margin
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            padding: 0
            font.bold: false
            font.pixelSize: statusindicator_pixelsize
            color: root.theme_color
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
            text:contact.status_gui
            width: status_max_width
            wrapMode: TextArea.Wrap
        }

        Label{
            id: status_date
            anchors.top: status_text.bottom
            anchors.topMargin: statustext_pixelsize/2
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            padding: 0
            font.bold: false
            font.pixelSize: statusdate_pixelsize
            color: Constants.ProfilePage.TEXT_COLOR
            opacity: 0.6
            text: "Last updated " + contact.status_date_gui;
        }

        Rectangle{
            id: presence_separator
            anchors.top: status_date.bottom
            anchors.topMargin: separator_top_margin
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            height: 1
            width: status_max_width
            color: Constants.ContactPage.SEPARATORS_COLOR
        }

        Label{
            id: presence_text
            anchors.top: presence_separator.top
            anchors.topMargin: statustext_pixelsize
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            font.pixelSize: statustext_pixelsize
            text: contact.presence_gui
            color: Constants.ProfilePage.TEXT_COLOR
        }

        Rectangle{
            anchors.top: presence_text.bottom
            width: parent.width
            height: statusindicator_top_margin
            color: "transparent"
        }

    }


    Button{
        id: options_antifocus
        height: root.height
        width: root.width
        z: options.enabled?(options.z-1):(-1)
        enabled: options.enabled

        background:Rectangle{color:"transparent"}

        onClicked:{
            options.close();
        }

    }

    function goBack(){
        root.StackView.view.pop();
    }

}









































