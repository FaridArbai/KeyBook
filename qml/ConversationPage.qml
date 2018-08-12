import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

Page {
    id: root
    opacity: 0
    property var statusbar_color    :   Constants.CONTACTS_STATUSBAR_COLOR;

    property int href   :   1135;
    property int wref   :   720;

    property int send_button_size       :   (1/8)*root.width;

    property int send_field_margin      :   (Constants.ConversationPage.SEND_FIELD_MARGIN)*root.height;
    property int messages_field_margin  :   (1/16)*root.width;

    property int initial_message_field_height   : send_button_size;
    property int max_message_field_height       :   6*textarea_pixelsize;

    property int message_field_height   :   initial_message_field_height;

    property int send_field_height      :   message_field_height + 2*send_field_margin;
    property int messages_field_height  :   root.height - (toolbar.height + send_field_height);

    property int text_area_width        :   root.width - (3*send_field_margin + send_button_size);
    property int scrollbar_width        :   initial_message_field_height/8;

    property int side_margin            :   (157/2880)*root.width;
    property int backimage_size         :   (34/wref)*root.width;
    property int backbutton_size        :   2*backimage_size;
    property int image_left_paddding    :   (1/32)*root.width;
    property int image_size             :   (3/4)*main.toolbar_height;
    property int image_top_padding      :   (1/8)*main.toolbar_height;

    property int presence_left_padding  :   (16/wref)*root.width;
    property int username_top_padding   :   (1/3)*main.toolbar_height;
    property int presence_top_padding   :   (2/3)*main.toolbar_height;


    property int username_pixelsize     :   (32/href)*root.height;
    property int presence_pixelsize     :   (24/href)*root.height;
    property int message_pixelsize      :   (24/href)*root.height;
    property int timestamp_pixelsize    :   (20/href)*root.height;
    property int textarea_pixelsize     :   (30/href)*root.height;

    property int options_pixelsize              :   0;
    property int options_pixelsize_closed       :   0;
    property int options_pixelsize_opened       :   (28/href)*root.height;

    property alias dialog   :   latchkey_dialog;

    background: Rectangle{
        id: bg_image
        color:"#F2F2F2"
        width: root.width
        height: root.height
        z: -1000

        Image{
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: "backgrounds/chatbackground.png"
            opacity: 0.2
            mipmap: true
        }
    }


    function addTransparency(transparency,color){
        var has_one_character = transparency<=0x0F;
        var transparency_str = (has_one_character?("0"):("")) + transparency.toString(16);
        var final_color = "#" + transparency_str + color.substr(1);

        return final_color;
    }


    Connections{
        target: main_frame

        onReceivedMessageForCurrentConversation:{
            main_frame.refreshMessagesGUI();
        }

        onVkeyboardClosed:{
            pane.anchors.bottomMargin = 0;
            bg_image.forceActiveFocus();
        }
    }

    CustomInputDialog{
        id: latchkey_dialog
        anchors.fill: parent
        statusbar_color: main.decToColor(root.statusbar_color);

        onDone:{
            main_frame.changePTPKeyOf(contact.username_gui, text);
            main_frame.refreshMessagesGUI();
            latchkey_dialog.close();
        }
    }


    Rectangle{
        id:toolbar
        anchors.top: parent.top
        anchors.left: parent.left
        height: main.toolbar_height
        width: root.width
        layer.enabled: true
        layer.effect: CustomElevation{
            source: toolbar
        }

        Rectangle{
            anchors.fill: parent
            color: Constants.TOOLBAR_COLOR
        }

        CustomButton {
            id:backbutton
            anchors.left: parent.left
            anchors.leftMargin: side_margin
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            height: backbutton_size
            width: backbutton_size
            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
            circular: true

            Image {
                id: backicon
                anchors.centerIn: parent
                height: backimage_size
                width: backimage_size
                fillMode: Image.PreserveAspectFit
                source: "icons/whitebackicon.png"
                z: -1
                mipmap: true
            }

            onClicked:{
                action();
            }

            function action(){
                main_frame.finishCurrentConversation();
                root.StackView.view.pop();
            }
        }

        CustomButton{
            id: avatar_button
            anchors.left: backbutton.right
            anchors.leftMargin: image_left_paddding
            anchors.top: parent.top
            anchors.topMargin: image_top_padding
            height: image_size
            width: image_size
            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
            circular: true

            Image {
                id: avatar
                anchors.fill: parent
                source: contact.avatar_path_gui
                fillMode: Image.PreserveAspectCrop
                mipmap: true
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }
                z:-1
            }

            Rectangle {
                id: mask
                height: image_size
                width: image_size
                radius: (image_size/2)
                visible: false
            }

            onClicked: {
                action();
            }

            function action(){
                main_frame.refreshContactGUI(contact.username_gui)
                root.StackView.view.push("qrc:/ContactProfilePage.qml",
                                         {previous_page : "ConversationPage"})
            }
        }

        CustomButton{
            id: contact_info_container
            anchors.top: parent.top
            anchors.left: avatar_button.right
            anchors.leftMargin: presence_left_padding
            anchors.bottom: parent.bottom
            anchors.right: options_button.left
            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
            animationDuration: Constants.VISIBLE_DURATION
            easingType: Easing.OutQuad

            Label{
                id: username_label
                anchors.top: parent.top
                anchors.topMargin: username_top_padding-height/2
                anchors.left: parent.left
                text: contact.username_gui
                color: "white"
                font.bold: true
                font.pixelSize: username_pixelsize
            }

            Label{
                id: presence_label
                anchors.top: parent.top
                anchors.topMargin: presence_top_padding-height/2
                anchors.left: parent.left
                text: contact.presence_gui
                color: "white"
                font.pixelSize: presence_pixelsize
            }

            onClicked: {
                main_frame.refreshContactGUI(contact.username_gui)
                root.StackView.view.push("qrc:/ContactProfilePage.qml",
                                         {previous_page : "ConversationPage"})
            }
        }

        CustomButton {
            id: options_button
            anchors.right: parent.right
            anchors.rightMargin: side_margin
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            height: backbutton_size
            width: backbutton_size
            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
            circular: true

            Image {
                id: optionsicon
                anchors.centerIn: parent
                height: backimage_size
                width: backimage_size
                fillMode: Image.PreserveAspectFit
                source: "icons/whiteoptionsicon.png"
                mipmap: true
                z:-1
            }

            onClicked:{
                menu.open();
            }
        }
    }

    Rectangle{
        id: messages_container
        anchors.top: toolbar.bottom
        anchors.left: parent.left
        anchors.leftMargin: messages_field_margin/4
        anchors.right: parent.right
        anchors.rightMargin: messages_field_margin/4
        anchors.bottom: pane.top
        color: "transparent"

        ListView {
            id: messages_view
            anchors.fill: parent
            bottomMargin: (8/href)*root.height
            displayMarginBeginning: 0
            displayMarginEnd: 0
            verticalLayoutDirection: ListView.BottomToTop
            spacing: Constants.ConversationPage.Message.SEPARATION*root.height
            model: MessageModel
            clip: true

            property int messages_scrollbar_width   :  (Constants.ConversationPage.Message.PAD_OUTTER*root.width - Constants.ConversationPage.Message.BUBBLE_WIDTH*root.height)/2;

            delegate: Rectangle{
                id: message_delegate
                width: messages_view.width
                height: new_day ? (new_day_box.height + message.height + new_day_box.anchors.topMargin + message.anchors.topMargin) : (message.height + message.anchors.topMargin)
                color: "transparent"

                readonly property bool reliable         :   model.modelData.reliability_gui;
                readonly property bool new_day          :   model.modelData.first_of_its_day_gui;
                readonly property bool first_of_group   :   model.modelData.first_of_group_gui;
                readonly property bool mine             :   (contact.username_gui !== model.modelData.sender_gui)
                readonly property int border_pad        :   Constants.ConversationPage.Message.PAD_OUTTER*root.width;
                readonly property int text_pad          :   Constants.ConversationPage.Message.PAD_INNER*root.width;
                readonly property int min_sep           :   Constants.ConversationPage.Message.MIN_PAD*root.width;
                readonly property int time_pad          :   Constants.ConversationPage.Message.TIME_PAD*root.width;

                readonly property int max_width             :   messages_view.width - border_pad - min_sep;

                readonly property int max_text_width        :   max_width;

                readonly property int messages_separation   :   Constants.ConversationPage.Message.SEPARATION*root.height;
                readonly property int timestamp_fits        :   (message.width - text_pad -  last_line_width) > (timestamp.paintedWidth)


                readonly property int last_line_width       :   (message_text_unwrapped.paintedWidth > message_text.paintedWidth)?(message_text_unwrapped.paintedWidth%message_text.paintedWidth):(message_text.paintedWidth);

                readonly property int box_radius            :   Constants.ConversationPage.Message.RADIUS*root.height;

                readonly property int new_day_pad           :   Constants.ConversationPage.Message.NEW_DAY_VPAD*root.height;
                readonly property int first_of_group_separation :   Constants.ConversationPage.Message.FIRST_OF_GROUP_SEPARATION*root.height;

                readonly property int bubble_width  :   Constants.ConversationPage.Message.BUBBLE_WIDTH*root.height;
                readonly property int bubble_height :   Constants.ConversationPage.Message.BUBBLE_HEIGHT*root.height;


                Rectangle{
                    id: new_day_box
                    anchors.top: parent.top
                    anchors.topMargin: new_day ? (new_day_pad - messages_view.spacing):0
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - width)/2
                    width: new_day ? new_day_text.width : 0
                    height: new_day ? new_day_text.height : 0
                    radius: box_radius
                    color: Constants.ConversationPage.NEW_DAY_BACKGROUND
                    visible: new_day
                    enabled: new_day
                    layer.enabled: true
                    layer.effect: DropShadow{
                        source: new_day_box
                        width: source.width
                        height: source.height
                        horizontalOffset: 0
                        verticalOffset: Math.round(messages_separation/4)
                        radius: 2*verticalOffset
                        samples: (2*radius+1)
                        cached: true
                        color: Constants.DROPSHADOW_COLOR
                    }

                    Label{
                        id: new_day_text
                        anchors.top: parent.top
                        anchors.left: parent.left
                        padding: text_pad
                        font.pixelSize: (new_day)?message_pixelsize:0
                        color: "black"
                        text: (new_day)?model.modelData.day_gui:""
                        visible: new_day
                        enabled: new_day
                        opacity: 0.7
                    }
                }

                Rectangle {
                    id: message
                    anchors.top: new_day_box.bottom
                    anchors.topMargin: ((new_day)?(new_day_pad):((first_of_group?(first_of_group_separation):(0))))
                    anchors.right: mine ? parent.right : undefined
                    anchors.left: mine ? undefined : parent.left
                    anchors.rightMargin: mine ? border_pad : 0
                    anchors.leftMargin: mine ? 0 : border_pad
                    width: Math.min(Math.max(message_text.implicitWidth, timestamp.implicitWidth), max_width)
                    height: message_text.height
                    color: (model.modelData.reliability_gui ? (mine ? Constants.ConversationPage.PERSONAL_MESSAGE_BACKGROUND : Constants.ConversationPage.CONTACT_MESSAGE_BACKGROUND) : Constants.ConversationPage.ERROR_MESSAGE_BACKGROUND)
                    radius: Constants.ConversationPage.Message.RADIUS*root.height;
                    layer.enabled: true
                    layer.effect: DropShadow{
                        width: message.width
                        height: message.height
                        horizontalOffset: 0
                        verticalOffset: Math.round(messages_separation/4)
                        radius: 2*verticalOffset
                        samples: (2*radius+1)
                        cached: true
                        color: Constants.DROPSHADOW_COLOR
                        source: message
                    }

                    Label{
                        id: message_text
                        color: ((model.modelData.reliability_gui)?(Constants.TextInput.TEXT_COLOR):("white"))
                        anchors.left: parent.left
                        padding: text_pad
                        wrapMode: Label.WordWrap
                        width: max_text_width
                        height: reliable ? ((timestamp_fits) ? implicitHeight : implicitHeight + font.pixelSize) : implicitHeight + 1.5*font.pixelSize
                        opacity: reliable ? 1 : 0.9
                        font.pixelSize: message_pixelsize
                        text: ((model.modelData.reliability_gui ? model.modelData.text_gui : Constants.ConversationPage.ERROR_MESSAGE))

                    }

                    Label {
                        id: timestamp
                        color: reliable ? "black" : "white"
                        opacity: 0.56
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        padding: time_pad
                        font.pixelSize: timestamp_pixelsize
                        text: model.modelData.timestamp_gui
                    }

                    Label {
                        id: changelatchkey_text
                        color: "white"
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        padding: text_pad
                        font.pixelSize: message_pixelsize
                        font.bold: !changelatchkey_button.pressed
                        text: "CHANGE LATCHKEY"
                        opacity: 0.9
                        visible: !reliable
                        enabled: !reliable

                        CustomButton{
                            id: changelatchkey_button
                            anchors.fill: parent
                            visible: !reliable
                            enabled: !reliable
                            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
                            onClicked:{
                                latchkey_dialog.open();
                            }
                        }
                    }

                    Label{
                        id: message_text_unwrapped
                        color: ((model.modelData.reliability_gui)?(mine ? "black" : "white"):("white"))
                        anchors.left: parent.left
                        padding: text_pad
                        wrapMode: Label.NoWrap
                        width: max_text_width
                        font.pixelSize: message_pixelsize
                        text: ((model.modelData.reliability_gui ? model.modelData.text_gui : Constants.ConversationPage.ERROR_MESSAGE))
                        visible: false
                    }
                }

                Rectangle{
                    id: arrow
                    width: message.radius - 1
                    height: bubble_height
                    color: message.color
                    anchors.right: mine ? message.right : undefined
                    anchors.left: mine ? undefined : message.left
                    anchors.top: message.top
                    visible: (first_of_group || new_day)
                    z: bubble.z + 1
                }

                OpacityMask{
                    id: bubble
                    width: bubble_width
                    height: bubble_height
                    anchors.top: arrow.top
                    anchors.left: mine ? arrow.right : undefined
                    anchors.leftMargin: mine ? -1 : undefined
                    anchors.right: mine ? undefined : arrow.left
                    anchors.rightMargin: mine ? undefined : -1
                    source: bubble_bg
                    maskSource: bubble_image
                    visible: (first_of_group || new_day)

                    layer.enabled: true
                    layer.effect: DropShadow{
                        source: bubble
                        width: source.width
                        height: source.height
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 2*verticalOffset
                        samples: (2*radius+1)
                        cached: true
                        color: Constants.DROPSHADOW_COLOR
                    }

                    Image{
                        id: bubble_image
                        anchors.fill: parent
                        source: mine ? "icons/whitebubblemineicon.png" : "icons/whitebubbleicon.png"
                        visible: false
                    }

                    Rectangle{
                        id: bubble_bg
                        anchors.fill: parent
                        color: message.color
                        visible: false
                    }

                }
            }

            ScrollBar.vertical: ScrollBar {}
        }
    }

    Rectangle{
        id: pane
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: send_field_height
        width: parent.width
        color:"transparent"

        Rectangle{
            id: message_field_container
            anchors.top: parent.top
            anchors.topMargin: send_field_margin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: send_field_margin
            anchors.left: parent.left
            anchors.leftMargin: send_field_margin
            width: text_area_width
            radius: send_button_size/2
            color: "white"
            clip: true
            layer.enabled: true
            layer.effect: CustomElevation{
                source: message_field_container
            }

            Flickable{
                id: flick
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                flickableDirection: Flickable.VerticalFlick
                //boundsBehavior: Flickable.StopAtBounds
                contentHeight: message_field.implicitHeight
                contentY: -((initial_message_field_height-textarea_pixelsize)/2)

                onContentYChanged: {
                    if(message_field.implicitHeight < message_field_height){
                        if(contentY!=(-(message_field_height - message_field.implicitHeight)/2)){
                            contentY = (-(message_field_height - message_field.implicitHeight)/2);
                        }
                    }
                }

                TextArea{
                    id: message_field
                    leftPadding: message_field_container.radius
                    rightPadding: message_field_container.radius + 2*scrollbar_width
                    topPadding: 0
                    bottomPadding: 0
                    width: flick.width
                    height: message_field_height + flick.contentY
                    wrapMode: TextArea.WordWrap
                    font.pixelSize: textarea_pixelsize
                    color: Constants.TextInput.TEXT_COLOR
                    cursorDelegate: CustomCursor{
                        pixelSize: textarea_pixelsize
                    }

                    property int lastImplicitHeight :   textarea_pixelsize;

                    onImplicitHeightChanged:{
                        var diff = (message_field.text.length==0)?0:(implicitHeight - lastImplicitHeight);
                        console.log("IMPLICIT HEIGHT: " + lastImplicitHeight + "/" + implicitHeight + "/" + diff + "/" + flick.contentY);

                        if(diff>0){
                            if(implicitHeight < max_message_field_height){
                                if(message_field_height>implicitHeight){
                                    flick.contentY = -(message_field_height-implicitHeight)/2;
                                }
                                else{
                                    message_field_height = implicitHeight;
                                    flick.contentY = 0;
                                }
                            }
                            else{
                                flick.contentY += diff;
                            }
                        }
                        else if (diff<0){
                            if(implicitHeight < max_message_field_height){
                                if(implicitHeight > initial_message_field_height){
                                    message_field_height = implicitHeight;
                                    flick.contentY = 0;
                                }
                                else{
                                    message_field_height = initial_message_field_height;
                                    flick.contentY = -(message_field_height-implicitHeight)/2;
                                }
                            }
                            else{
                                flick.contentY += diff;
                            }
                        }

                        lastImplicitHeight = implicitHeight;
                    }

                    Label{
                        id: placeholder
                        anchors.fill: parent
                        leftPadding: message_field.leftPadding
                        rightPadding: message_field.rightPadding
                        topPadding: message_field.topPadding
                        bottomPadding: message_field.bottomPadding
                        font.pixelSize: message_field.font.pixelSize
                        color: "#9A9A9A"
                        text: "Type a message"
                        visible: (message_field.text.length==0)
                    }

                    function refresh(){
                        message_field.lastImplicitHeight = textarea_pixelsize;
                        message_field.cursorPosition = 0;
                        message_field.text = "";
                        message_field.lastImplicitHeight = textarea_pixelsize;
                        message_field_height = initial_message_field_height;
                    }

                    onActiveFocusChanged: {
                        if(activeFocus==false){
                            pane.anchors.bottomMargin = 0;
                            flick_controller.enabled = true;
                            message_field.enabled = false;
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar{
                    //parent: flick.parent
                    anchors.left: parent.right
                    anchors.leftMargin: -(message_field_container.radius + (scrollbar_width/2))
                    anchors.top: parent.top
                    width: scrollbar_width
                    visible: (message_field.implicitHeight >= max_message_field_height)
                    policy: ScrollBar.AlwaysOn
                }
            }
        }



        Button{
            id: flick_controller
            anchors.fill: message_field_container
            background: Rectangle{color:"transparent"}
            onClicked:{
                pane.anchors.bottomMargin = main.vkeyboard_height;
                message_field.forceActiveFocus();
                flick_controller.enabled = false;
                message_field.enabled = true;
            }
        }

        Rectangle {
            id: send_button_container
            anchors.bottom: parent.bottom
            anchors.bottomMargin: send_field_margin
            anchors.left: message_field_container.right
            anchors.leftMargin: send_field_margin
            anchors.right: parent.right
            anchors.rightMargin: send_field_margin
            height: send_button_size
            //width: send_button_size
            color: Constants.ConversationPage.SENDBUTTON_COLOR
            radius: width/2
            layer.enabled: true
            layer.effect: CustomElevation{
                source: send_button_container
            }

            CustomButton{
                id: send_button
                anchors.fill: parent
                enabled: (message_field.text.replace(/\n/g, '').length>0)
                animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
                circular: true

                Image {
                    id: sendicon
                    anchors.top: parent.top
                    anchors.topMargin: (parent.height-height)/2
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width-width)/2 + (3*width/32)
                    width: 0.66*(parent.width/Math.sqrt(2))
                    height: 0.66*(parent.width/Math.sqrt(2))
                    fillMode: Image.PreserveAspectFit
                    source: "icons/whitesendicon.png"
                    opacity: 0.95
                    z: -1
                    mipmap: true
                }

                onClicked:{
                    main_frame.sendMessage(contact.username_gui, message_field.text);
                    message_field.refresh();
                }
            }
        }
    }

    CustomMenu{
        id: menu
        numItems: 2
        anchors.fill: parent
        z: 2000

        Column{
            spacing: 0
            x: menu.menuX;
            y: menu.menuY;

            CustomMenuItem{
                name: "View profile"
                a: menu.a

                onClicked: {
                    main_frame.refreshContactGUI(contact.username_gui)
                    root.StackView.view.push("qrc:/ContactProfilePage.qml",
                                             {previous_page : "ConversationPage"})
                    menu.close();
                }
            }

            CustomMenuItem{
                name: "Exit conversation"
                a: menu.a

                onClicked: {
                    backbutton.action();
                    menu.close();
                }
            }
        }
    }

    function goBack(){
        backbutton.action();
    }

    Keys.onBackPressed:{
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



