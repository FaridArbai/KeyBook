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

    property int buttons_size           :   2*icons_size
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

    property int shadow_offset      :   root.height/200;

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
    property int toolbar_z  :   max_z-1;
    property int image_z    :   max_z-2;

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

    property alias dialog   :   latchkey_dialog;

    Rectangle{
        id: background
        anchors.fill: parent
        color: Constants.ProfilePage.PADDING_COLOR
        z:-1
    }

    CustomInputDialog{
        id: latchkey_dialog
        anchors.fill: parent
        statusbar_color: main.decToColor(root.statusbar_color);

        onDone:{
            main_frame.changePTPKeyOf(contact.username_gui, text);

            if(root.previous_page=="ConversationPage"){
                main_frame.refreshMessagesGUI();
            }

            latchkey_dialog.close();
        }
    }

    Rectangle{
        id: toolbar
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: main.toolbar_height
        color: "transparent"
        z: toolbar_z

        CustomButton {
            id: backbutton
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.left: parent.left
            anchors.leftMargin: side_margin;
            height: buttons_size
            width: buttons_size
            circular: true
            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR

            Image {
                id: backicon
                anchors.centerIn: parent
                source: "icons/whitebackicon.png"
                height: icons_size
                width: icons_size
                mipmap: true
            }

            onClicked:{
                backbutton.action();
            }

            function action(){
                root.goBack();
            }
        }

        CustomButton {
            id: options_button
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.right: parent.right
            anchors.rightMargin: side_margin;
            height: buttons_size
            width: buttons_size
            circular: true
            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR

            Image {
                id: optionsicon
                anchors.centerIn: parent
                source: "icons/whiteoptionsicon.png"
                height: icons_size
                width: icons_size
                mipmap: true
            }

            onClicked:{
                menu.open();
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
        smooth: true
        layer.enabled: true
        layer.effect: CustomElevation{
            source: image_container
        }

        Image {
            id: profileimage
            width: parent.width
            height: parent.width
            source: contact.avatar_path_gui
            fillMode: Image.PreserveAspectCrop
            mipmap: true
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
                layer.effect: CustomElevation{
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
                layer.effect: CustomElevation {
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
                        mipmap: true
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

                CustomButton{
                    id: latchkey_button
                    anchors.fill: parent
                    animationDuration: Constants.VISIBLE_DURATION
                    easingType: Easing.OutQuad

                    onClicked:{
                        updatelatchkey_option.action();
                    }
                }

            }

            Rectangle{
                id: messagebutton_container
                height: box_height
                width: root.width
                color: "white"

                layer.enabled: true
                layer.effect: CustomElevation {
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
                        mipmap: true
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

                CustomButton{
                    id: conversation_button
                    anchors.fill: parent
                    animationDuration: Constants.VISIBLE_DURATION
                    easingType: Easing.OutQuad

                    onClicked:{
                        startconversation_option.action();
                    }
                }
            }

            Rectangle{
                id: clearbutton_container
                height: box_height
                width: root.width
                color: "white"

                layer.enabled: true
                layer.effect: CustomElevation {
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
                        mipmap: true
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

                CustomButton{
                    id: clear_button
                    anchors.fill: parent
                    animationDuration: Constants.VISIBLE_DURATION
                    easingType: Easing.OutQuad

                    onClicked:{
                    }
                }

            }
        }
    }

    CustomMenu{
        id: menu
        numItems: 3
        anchors.fill: parent
        z: 2000

        Column{
            spacing: 0
            x: menu.menuX;
            y: menu.menuY;

            CustomMenuItem{
                id: updatelatchkey_option
                name: "Update latchkey"
                a: menu.a
                onClicked: {
                    updatelatchkey_option.action();
                    menu.close();
                }

                function action(){
                    latchkey_dialog.open();
                }
            }

            CustomMenuItem{
                id: startconversation_option
                name: "Start conversation"
                a: menu.a
                onClicked: {
                    startconversation_option.action();
                    menu.close();
                }

                function action(){
                    if(root.previous_page=="ConversationPage"){
                        root.StackView.view.pop();
                    }
                    else{
                        main_frame.loadConversationWith(contact.username_gui);
                        main_frame.refreshContactGUI(contact.username_gui);
                        root.StackView.view.push("qrc:/ConversationPage.qml");
                    }
                }
            }+

            CustomMenuItem{
                id: exitprofile_option
                name: "Update latchkey"
                a: menu.a
                onClicked: {
                    root.StackView.view.pop();
                    menu.close();
                }
            }
        }
    }

    function goBack(){
        root.StackView.view.pop();
    }

    Keys.onBackPressed: {
        if(dialog.opened){
            dialog.close();
        }
        else if(menu.opened){
            menu.close();
        }
        else{
            root.goBack();
        }
    }

}









































