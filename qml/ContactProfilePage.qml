import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page{
    id: root
    visible:true

    property var statusbar_color    : contact.avatar_color_gui
    property string theme_color     : main.decToColor(statusbar_color);

    property string previous_page;

    property int href   :   1135;
    property int wref   :   720;
    property int cref   :   715;

    property int max_z  :   5;

    property int buttons_size           :   icons_size
    property int icons_size             :   (34/wref)*root.width;
    property int side_margin            :   (Constants.SIDE_FACTOR)*root.width;
    property int pad_buttons            :   (Constants.SPACING_FACTOR)*root.width;

    property int remaining_height       :   root.height-root.width;

    property int name_pixelsize         :  (50/href)*root.height;

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


    property int general_shadow_offset      :   root.height/400;
    property int relevant_shadow_offset     :   root.height/200;

    property int separator_top_margin   :   statusdate_pixelsize;
    property int presence_pixelsize     :   statusdate_pixelsize;
    property int presence_top_margin    :   statustext_top_margin-(statusindicator_top_margin+statusindicator_pixelsize);


    property int box_pixelsize  :   statusindicator_pixelsize;
    property int box_height     :   3*box_pixelsize;
    property int boxes_spacing  :   remaining_height/16;
    property int box_top_margin :   box_pixelsize;
    property int box_icon_size  :   (3/2)*box_pixelsize;
    property int boxtext_left_margin    :   (3/2)*left_margin;


    property int maz_z      :   10;
    property int options_z  :   max_z;
    property int toolbar_z  :   max_z-1;
    property int image_z    :   max_z-2;

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
        z: toolbar_z

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
        z: root.options_z;

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
            id: changelatchkey_option
            anchors.top: parent.top
            anchors.topMargin: a*options.vertical_pad
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: changelatchkey_option.height
                width: changelatchkey_option.width
                color: changelatchkey_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
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
                changelatchkey_option.action();
            }

            function action(){
                //open text_box
            }
        }

        Button{
            id: conversation_option
            anchors.top: changelatchkey_option.bottom
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: conversation_option.height
                width: conversation_option.width
                color: conversation_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
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

            onClicked: {
                conversation_option.action();
            }

            function action(){
                if(root.previous_page=="ConversationPage"){
                    root.StackView.view.pop();
                }
                else{
                    main_frame.loadConversationWith(contact.username_gui)
                    main_frame.refreshContactGUI(contact.username_gui);
                    root.StackView.view.replace("qrc:/ConversationPage.qml");
                }
            }
        }

        Button{
            id: clear_option
            anchors.top: conversation_option.bottom
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: clear_option.height
                width: clear_option.width
                color: clear_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
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

            onClicked: {
                clear_option.action();
            }

            function action(){
                //clear_conversation
            }
        }

        Button{
            id: block_option
            anchors.top: clear_option.bottom
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: block_option.height
                width: block_option.width
                color: block_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
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

            onClicked: {
                block_option.action();
            }

            function action(){
                //open text_box
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
        z: image_z

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
            verticalOffset: relevant_shadow_offset
            radius: 2*(verticalOffset)
            samples: (2*radius+1)
            cached: true
            color: Constants.DROPSHADOW_COLOR
            source: profileimage
        }


        Label {
            id: nametext
            anchors.left: parent.left
            anchors.leftMargin: name_pixelsize/2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: name_pixelsize/4
            font.bold: true
            font.pixelSize: name_pixelsize
            text: contact.username_gui
            color: "white"
            background: Rectangle{color:"transparent"}
        }
    }

    ScrollView{
        id: boxes_scroller
        anchors.top: image_container.bottom
        anchors.left: parent.left
        height: remaining_height
        width: root.width
        background: Rectangle{color:"transparent"}

        Column{
            anchors.fill: parent
            spacing: boxes_spacing

            Rectangle{
                id: status_container
                width: root.width
                height: status_container.computeHeight();
                color: "white"


                layer.enabled: true
                layer.effect: DropShadow {
                    width: status_container.width
                    height: status_container.height
                    horizontalOffset: 0
                    verticalOffset: general_shadow_offset
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
                    text: "Updated " + contact.status_date_gui;
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
                    font.pixelSize: presence_pixelsize
                    text: contact.presence_gui
                    color: Constants.ProfilePage.TEXT_COLOR
                    opacity: 0.6
                }

                function computeHeight(){
                    var height =
                            status_text.anchors.topMargin +
                            status_text.height +
                            status_date.anchors.topMargin +
                            status_date.height +
                            presence_separator.anchors.topMargin +
                            presence_separator.height +
                            presence_text.anchors.topMargin +
                            presence_text.height +
                            status_indicator.anchors.topMargin;

                    return height;
                }

            }

            Rectangle{
                id: latchkeybutton_container
                height: box_height
                width: root.width
                color: "white"

                layer.enabled: true
                layer.effect: DropShadow {
                    width: latchkeybutton_container.width
                    height: latchkeybutton_container.height
                    horizontalOffset: 0
                    verticalOffset: general_shadow_offset
                    radius: 2*(verticalOffset)
                    samples: (2*radius+1)
                    cached: true
                    color: Constants.DROPSHADOW_COLOR
                    source: latchkeybutton_container
                }

                OpacityMask{
                    id: latchkey_icon
                    anchors.top: parent.top
                    anchors.topMargin: parent.height/2 - height/2
                    anchors.left: parent.left
                    anchors.leftMargin: left_margin
                    height: box_icon_size
                    width: box_icon_size
                    source: latchkeyicon_bg
                    maskSource: latchkeyicon_mask
                    visible: true

                    Rectangle{
                        id: latchkeyicon_bg
                        height: parent.height
                        width: parent.width
                        color: theme_color
                        visible: false
                    }

                    Image{
                        id: latchkeyicon_mask
                        height: parent.height
                        width: parent.width
                        source: "icons/whitehandkeyicon.png"
                        visible: false
                    }

                }

                Rectangle{
                    anchors.top: parent.top
                    anchors.topMargin: parent.height/2 - height/2
                    anchors.left: latchkey_icon.right
                    anchors.leftMargin: boxtext_left_margin/2
                    height: box_icon_size
                    width: 1
                    color: theme_color
                }

                Label{
                    anchors.top: parent.top
                    anchors.topMargin: box_pixelsize
                    anchors.left: latchkey_icon.right
                    anchors.leftMargin: boxtext_left_margin
                    padding: 0
                    font.pixelSize: box_pixelsize
                    text: "Change latchkey"
                    color: root.theme_color
                }

                Button{
                    id: latchkey_button
                    anchors.fill: parent
                    background: Rectangle{
                        color: latchkey_button.pressed?(Constants.BOXBUTTON_PRESSED_COLOR):("transparent")
                    }

                    onClicked:{
                    }
                }

            }

            Rectangle{
                id: messagebutton_container
                height: box_height
                width: root.width
                color: "white"

                layer.enabled: true
                layer.effect: DropShadow {
                    width: messagebutton_container.width
                    height: messagebutton_container.height
                    horizontalOffset: 0
                    verticalOffset: general_shadow_offset
                    radius: 2*(verticalOffset)
                    samples: (2*radius+1)
                    cached: true
                    color: Constants.DROPSHADOW_COLOR
                    source: messagebutton_container
                }

                OpacityMask{
                    id: conversation_icon
                    anchors.top: parent.top
                    anchors.topMargin: parent.height/2-height/2
                    anchors.left: parent.left
                    anchors.leftMargin: left_margin
                    height: box_icon_size
                    width: box_icon_size
                    source: conversationicon_bg
                    maskSource: conversationicon_mask
                    visible: true

                    Rectangle{
                        id: conversationicon_bg
                        height: parent.height
                        width: parent.width
                        color: theme_color
                        visible: false
                    }

                    Image{
                        id: conversationicon_mask
                        height: parent.height
                        width: parent.width
                        source: "icons/whiteconversationicon.png"
                        visible: false
                    }

                }

                Rectangle{
                    anchors.top: parent.top
                    anchors.topMargin: parent.height/2 - height/2
                    anchors.left: conversation_icon.right
                    anchors.leftMargin: boxtext_left_margin/2
                    height: box_icon_size
                    width: 1
                    color: theme_color
                }

                Label{
                    anchors.top: parent.top
                    anchors.topMargin: box_pixelsize
                    anchors.left: conversation_icon.right
                    anchors.leftMargin: boxtext_left_margin
                    font.pixelSize: box_pixelsize
                    padding: 0
                    text: "Text contact"
                    color: root.theme_color
                }

                Button{
                    id: conversation_button
                    anchors.fill: parent
                    background: Rectangle{
                        color: conversation_button.pressed?(Constants.BOXBUTTON_PRESSED_COLOR):("transparent")
                    }

                    onClicked:{
                        conversation_option.action();
                    }
                }
            }

            Rectangle{
                id: clearbutton_container
                height: box_height
                width: root.width
                color: "white"

                layer.enabled: true
                layer.effect: DropShadow {
                    width: clearbutton_container.width
                    height: clearbutton_container.height
                    horizontalOffset: 0
                    verticalOffset: general_shadow_offset
                    radius: 2*(verticalOffset)
                    samples: (2*radius+1)
                    cached: true
                    color: Constants.DROPSHADOW_COLOR
                    source: clearbutton_container
                }

                OpacityMask{
                    id: clear_icon
                    anchors.top: parent.top
                    anchors.topMargin: parent.height/2 - height/2
                    anchors.left: parent.left
                    anchors.leftMargin: left_margin
                    height: box_icon_size
                    width: box_icon_size
                    source: clearicon_bg
                    maskSource: clearicon_mask
                    visible: true

                    Rectangle{
                        id: clearicon_bg
                        height: parent.height
                        width: parent.width
                        color: theme_color
                        visible: false
                    }

                    Image{
                        id: clearicon_mask
                        height: parent.height
                        width: parent.width
                        source: "icons/whitetrashicon.png"
                        visible: false
                    }

                }

                Rectangle{
                    anchors.top: parent.top
                    anchors.topMargin: parent.height/2 - height/2
                    anchors.left: clear_icon.right
                    anchors.leftMargin: boxtext_left_margin/2
                    height: box_icon_size
                    width: 1
                    color: theme_color
                }

                Label{
                    anchors.top: parent.top
                    anchors.topMargin: box_pixelsize
                    anchors.left: clear_icon.right
                    anchors.leftMargin: boxtext_left_margin
                    padding: 0
                    font.pixelSize: box_pixelsize
                    text: "Clear history"
                    color: root.theme_color
                }

                Button{
                    id: clear_button
                    anchors.fill: parent
                    background: Rectangle{
                        color: clear_button.pressed?(Constants.BOXBUTTON_PRESSED_COLOR):("transparent")
                    }

                    onClicked:{
                    }
                }

            }

            Rectangle{
                id: blockbutton_container
                height: box_height
                width: root.width
                color: "white"

                layer.enabled: true
                layer.effect: DropShadow {
                    width: blockbutton_container.width
                    height: blockbutton_container.height
                    horizontalOffset: 0
                    verticalOffset: general_shadow_offset
                    radius: 2*(verticalOffset)
                    samples: (2*radius+1)
                    cached: true
                    color: Constants.DROPSHADOW_COLOR
                    source: blockbutton_container
                }

                OpacityMask{
                    id: block_icon
                    anchors.top: parent.top
                    anchors.topMargin: parent.height/2 - height/2
                    anchors.left: parent.left
                    anchors.leftMargin: left_margin
                    height: box_icon_size
                    width: box_icon_size
                    source: blockicon_bg
                    maskSource: blockicon_mask
                    visible: true

                    Rectangle{
                        id: blockicon_bg
                        height: parent.height
                        width: parent.width
                        color: theme_color
                        visible: false
                    }

                    Image{
                        id: blockicon_mask
                        height: parent.height
                        width: parent.width
                        source: "icons/whiteblockicon.png"
                        visible: false
                    }

                }

                Rectangle{
                    anchors.top: parent.top
                    anchors.topMargin: parent.height/2 - height/2
                    anchors.left: block_icon.right
                    anchors.leftMargin: boxtext_left_margin/2
                    height: box_icon_size
                    width: 1
                    color: theme_color
                }

                Label{
                    anchors.top: parent.top
                    anchors.topMargin: box_pixelsize
                    anchors.left: block_icon.right
                    anchors.leftMargin: boxtext_left_margin
                    padding: 0
                    font.pixelSize: box_pixelsize
                    text: "Block contact"
                    color: root.theme_color
                }

                Button{
                    id: block_button
                    anchors.fill: parent
                    background: Rectangle{
                        color: block_button.pressed?(Constants.BOXBUTTON_PRESSED_COLOR):("transparent")
                    }

                    onClicked:{
                    }
                }

            }
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









































