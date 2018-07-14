import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

Page {
    id: root

    property var statusbar_color    :   Constants.CONTACTS_STATUSBAR_COLOR;

    property int href   :   1135;
    property int wref   :   720;

    property int send_button_size       :   (1/8)*root.width;

    property int send_field_margin      :   (1/32)*root.width;
    property int messages_field_margin  :   (1/16)*root.width;

    property int send_field_height      :   send_button_size + 2*send_field_margin;
    property int messages_field_height  :   root.height - (toolbar.height + send_field_height);

    property int text_area_width        :   root.width - (3*send_field_margin + send_button_size);

    property int side_margin            :   (157/2880)*root.width;
    property int backimage_size         :   (34/wref)*root.width;
    property int backbutton_size        :   backimage_size;
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

    property int menu_width             :   backimage_size;
    property int menu_width_closed      :   backimage_size;
    property int menu_width_opened      :   root.width/2;

    property string menu_color          :   addTransparency(menu_transparency,Constants.MENU_COLOR);
    property string options_color       :   addTransparency(menu_transparency,Constants.MENUFONT_COLOR);

    property int menu_transparency          :   Constants.ZERO_TRANSPARENCY;
    property int menu_transparency_closed   :   Constants.ZERO_TRANSPARENCY;
    property int menu_transparency_open     :   Constants.MENU_TRANSPARENCY;

    property int menu_margins           :   (1/32)*root.width;

    property real menu_factor           :   0;
    property real menu_factor_closed    :   0;
    property real menu_factor_opened    :   1;

    property bool menu_opened   :   (menu_factor>0.05);



















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
    }

    header: ToolBar {
        id:toolbar
        height: main.toolbar_height
        leftPadding: 0
        rightPadding: 0
        topPadding: 0
        bottomPadding: 0


        Rectangle{
            anchors.fill: parent
            color: Constants.TOOLBAR_COLOR
        }

        ToolButton {
            id:backbutton
            anchors.left: parent.left
            anchors.leftMargin: side_margin
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            height: backbutton_size
            width: backbutton_size
            background: Rectangle{color:Constants.TOOLBAR_COLOR}

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | send_button
            }

            Rectangle{
                color: backbutton.pressed ? Constants.PRESSED_COLOR:"transparent"
                anchors.fill: parent

                Image {
                    id: backicon
                    anchors.centerIn: parent
                    height: backimage_size
                    width: backimage_size
                    fillMode: Image.PreserveAspectFit
                    source: "icons/whitebackicon.png"
                }
            }

            onClicked:{
                action();
            }

            function action(){
                main_frame.finishCurrentConversation();
                root.StackView.view.pop();
            }
        }

        Button{
            id: avatar_button
            anchors.left: backbutton.right
            anchors.leftMargin: image_left_paddding
            anchors.top: parent.top
            anchors.topMargin: image_top_padding
            height: image_size
            width: image_size

            Rectangle{
                id: avatar_container
                anchors.fill: parent
                color: avatar_button.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR

                Image {
                    id: avatar
                    anchors.fill: parent
                    source: contact.avatar_path_gui
                    fillMode: Image.PreserveAspectCrop
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: mask
                    }
                }

                Rectangle {
                    id: mask
                    height: image_size
                    width: image_size
                    radius: (image_size/2)
                    visible: false
                }
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | avatar_button
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

        Button{
            id: contact_info_container
            anchors.top: parent.top
            anchors.left: avatar_button.right
            anchors.leftMargin: presence_left_padding
            anchors.bottom: parent.bottom
            width: Math.max(username_label.width,presence_label.width)
            background: bg

            Rectangle{
                id: bg
                anchors.fill: contact_info_container
                color: contact_info_container.pressed ? Constants.PRESSED_COLOR : "transparent"
            }

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

        ToolButton {
            id: options_button
            anchors.right: parent.right
            anchors.rightMargin: side_margin
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            height: backbutton_size
            width: backbutton_size
            background: Rectangle{color:Constants.TOOLBAR_COLOR}

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | send_button
            }

            Rectangle{
                color: backbutton.pressed ? Constants.PRESSED_COLOR:"transparent"
                anchors.fill: parent

                Image {
                    id: optionsicon
                    anchors.centerIn: parent
                    height: backimage_size
                    width: backimage_size
                    fillMode: Image.PreserveAspectFit
                    source: "icons/whiteoptionsicon.png"
                }
            }

            onClicked:{
                menu.open();
            }
        }

        Rectangle{
            id: menu
            anchors.top: options_button.top
            anchors.topMargin: -menu_factor*(options_button.anchors.topMargin-menu_margins);
            anchors.right: options_button.right
            anchors.rightMargin: -menu_factor*(options_button.anchors.rightMargin-menu_margins);
            z: 2
            radius: options_pixelsize/2
            color: menu_color
            height: 1*(3*options_pixelsize) + options_pixelsize
            width: menu_width
            enabled: false


            Rectangle{
                id: viewcontact_option
                anchors.top: parent.top
                anchors.topMargin: options_pixelsize/2
                anchors.left: parent.left
                width: menu_width
                height: 3*options_pixelsize
                color: "transparent"

                Label{
                    anchors.top: parent.top
                    anchors.topMargin: options_pixelsize
                    anchors.left: parent.left
                    anchors.leftMargin: options_pixelsize
                    topPadding: 0
                    leftPadding: 0
                    bottomPadding: 0
                    rightPadding: 0
                    font.pixelSize: options_pixelsize
                    color: options_color
                    text: "View contact"
                    visible: menu_opened
                }

                Button{
                    anchors.fill: parent
                    background: Rectangle{color:"transparent"}
                    onClicked: {
                        avatar_button.action();
                    }
                }
            }

            function open(){
                menu.enable();
                close_menu.running = false;
                close_factor.running = false;
                close_options.running = false;
                clarify_menu.running = false;
                open_menu.running = true;
                open_factor.running = true;
                open_options.running = true;
                colorize_menu.running = true;
            }

            function hide(){
                open_menu.running = false;
                open_factor.running = false;
                open_options.running = false;
                colorize_menu.running = false;
                close_menu.running = true;
                close_factor.running = true;
                close_options.running = true;
                clarify_menu.running = true;
                menu.disable();
            }

            function disable(){
                menu.enabled = false;
                //menu.visible = false;
            }

            function enable(){
                menu.enabled = true;
                //menu.visible = true;
            }

            onActiveFocusChanged: {
                menu.hide();
            }
        }
    }

    Button{
        id: background_touch
        anchors.fill: parent
        z: menu_opened?(menu.z-1):(-1);
        background:Rectangle{color:"transparent"}
        onClicked: {
            if(menu_opened){
                menu.hide();
            }
        }
    }

    Rectangle{
        id: messages_container
        anchors.top: parent.top
        //anchors.topMargin: toolbar.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: send_field_height

        ColumnLayout{
            id: messages_layout
            anchors.fill: parent

            ListView {
                id: contacts_view
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: messages_field_margin
                displayMarginBeginning: 0
                displayMarginEnd: 0
                verticalLayoutDirection: ListView.TopToBottom
                spacing: Constants.ConversationPage.Message.SEPARATION*root.height
                model: MessageModel

                delegate: Rectangle{
                    width: root.width
                    color: "transparent"

                    readonly property bool mine: (contact.username_gui !== model.modelData.sender_gui)
                    readonly property int border_pad    :   Constants.ConversationPage.Message.PAD_OUTTER*root.width;
                    readonly property int text_pad      :   Constants.ConversationPage.Message.PAD_INNER*root.width;
                    readonly property int min_sep       :   Constants.ConversationPage.Message.MIN_PAD*root.width;
                    readonly property int time_pad      :   Constants.ConversationPage.Message.TIME_PAD*root.width;
                    readonly property int max_width     :   root.width - border_pad - min_sep;
                    readonly property int max_text_width        :   max_width - 2*text_pad;
                    readonly property int messages_separation   :   Constants.ConversationPage.Message.SEPARATION*root.height;
                    readonly property int timestamp_fits        :   (message.width - text_pad - time_pad - last_line_width) > ((5/4)*timestamp.paintedWidth)
                    readonly property int last_line_width       :   (message_text_unwrapped.paintedWidth > messageText.paintedWidth)?(message_text_unwrapped.paintedWidth%messageText.paintedWidth):(messageText.paintedWidth);

                    Rectangle{
                        id: new_day_box
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width)/2
                        radius: Constants.ConversationPage.Message.RADIUS*root.height;
                        color: "blue"
                        visible: model.modelData.first_of_its_day_gui
                        enabled: model.modelData.first_of_its_day_gui


                        Label{
                            font.pixelSize: (model.modelData.first_of_its_day_gui)?message_pixelsize:0
                            text: (model.modelData.first_of_its_day_gui)?"new_day":""
                            visible: model.modelData.first_of_its_day_gui
                            enabled: model.modelData.first_of_its_day_gui
                        }
                    }

                    Rectangle {
                    id: message
                    anchors.top: model.modelData.first_of_its_day_gui ? new_day_box.top : undefined
                    anchors.topMargin: model.modelData.first_of_its_day_gui ? Constants.ConversationPage.Message.SEPARATION*root.height : undefined
                    anchors.right: mine ? parent.right : undefined
                    anchors.rightMargin: mine ? border_pad : 0
                    anchors.leftMargin: mine ? 0 : border_pad
                    width: Math.min(messageText.implicitWidth + 2*text_pad, max_width)
                    height: messageText.height
                    color: (model.modelData.reliability_gui ? (mine ? "#afe3e9" : "#107087") : Constants.ConversationPage.ERROR_MESSAGE_BACKGROUND)
                    radius: Constants.ConversationPage.Message.RADIUS*root.height;
                    layer.enabled: true
                    layer.effect: DropShadow{
                        width: message.width
                        height: message.height
                        horizontalOffset: 0
                        verticalOffset: Math.round(messages_separation/2)
                        radius: 2*verticalOffset
                        samples: (2*radius+1)
                        cached: true
                        color: Constants.DROPSHADOW_COLOR
                        source: message
                    }

                    Label{
                        id: messageText
                        color: ((model.modelData.reliability_gui)?(mine ? "black" : "white"):("white"))
                        anchors.left: parent.left
                        padding: text_pad
                        wrapMode: Label.Wrap
                        width: max_text_width
                        font.pixelSize: message_pixelsize
                        text: ((model.modelData.reliability_gui ? model.modelData.text_gui : Constants.ConversationPage.ERROR_MESSAGE) + (timestamp_fits?(""):("\n")))
                    }

                    Label {
                        id: timestamp
                        color: "white"
                        anchors.right: parent.right
                        anchors.rightMargin: time_pad
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: time_pad
                        font.pixelSize: timestamp_pixelsize
                        text: model.modelData.timestamp_gui
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
                }

                ScrollBar.vertical: ScrollBar {}
            }
        }

    }

    Pane{
        id: pane
        anchors.top: messages_container.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        //height: send_field_height
        //width: parent.width
        contentHeight: send_field_height
        contentWidth: parent.width
        Layout.fillWidth: true
        Layout.fillHeight: true
        leftPadding: 0
        rightPadding: 0
        topPadding: 0
        bottomPadding: 0

        Rectangle{
            id: message_field_container
            anchors.top: parent.top
            anchors.topMargin: send_field_margin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: send_field_margin
            anchors.left: parent.left
            anchors.leftMargin: send_field_margin
            //height: send_button_size
            width: text_area_width
            color: "#d7f1f4"
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: height/2
        }

        Flickable{
            id: flick
            anchors.top: message_field_container.top
            anchors.topMargin: message_field_container.height/2-message_field.font.pixelSize/2
            anchors.bottom: parent.bottom
            anchors.left: message_field_container.left
            anchors.leftMargin: message_field_container.radius
            anchors.right: message_field_container.right
            anchors.rightMargin: message_field_container.radius
            width: message_field_container.width-2*message_field_container.radius
            flickableDirection: Flickable.VerticalFlick

            TextArea.flickable: TextArea{
                id: message_field
                leftPadding: 0
                rightPadding: 0
                topPadding: 0
                bottomPadding: message_field_container.anchors.bottomMargin
                placeholderText : ("Type a message")
                wrapMode: TextEdit.WordWrap
                font.pixelSize: textarea_pixelsize

                onTextChanged:{
                    if((message_field.text.search("\n")!=(-1))&&(message_field.text!="\n")){
                        main_frame.sendMessage(contact.username_gui,
                                               message_field.text.replace('\n',""));
                        message_field.text = ""
                        message_field.placeholderText = ("Type another message")
                    }
                    else if(message_field.text=="\n"){
                        message_field.text = ""
                        message_field.placeholderText = ("Type a valid message")
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }

        Rectangle {
            id: send_button_container
            anchors.top: parent.top
            anchors.topMargin: send_field_margin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: send_field_margin
            anchors.left: message_field_container.right
            anchors.leftMargin: send_field_margin
            anchors.right: parent.right
            anchors.rightMargin: send_field_margin
            //height: send_button_size
            //width: send_button_size
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true

            ToolButton{
                id: send_button
                anchors.fill: parent
                enabled: message_field.length>0

                background: Rectangle{
                    anchors.fill: send_button
                    color: "transparent"
                }

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: backbutton | send_button
                }

                Image {
                    id: sendicon
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "icons/whitesendicon.png"
                }

                onClicked:{
                    if(message_field.text!="\n"){
                        main_frame.sendMessage(contact.username_gui,
                                           message_field.text.replace('\n',""));
                        message_field.text = ""
                        message_field.placeholderText = ("Type another message")
                    }
                    else if(message_field.text=="\n"){
                        message_field.text = ""
                        message_field.placeholderText = ("Type a valid message")
                    }
                }

            }
        }
    }

    PropertyAnimation{
        id: open_menu
        target: root
        property: "menu_width"
        to: menu_width_opened
        duration: 250
    }

    PropertyAnimation{
        id: open_factor
        target: root
        property: "menu_factor"
        to: menu_factor_opened
        duration: 250
    }

    PropertyAnimation{
        id: close_menu
        target: root
        property: "menu_width"
        to: menu_width_closed
        duration: 250
    }

    PropertyAnimation{
        id: close_factor
        target: root
        property: "menu_factor"
        to: menu_factor_closed
        duration: 250
    }

    PropertyAnimation{
        id: open_options
        target: root
        property: "options_pixelsize"
        to: options_pixelsize_opened
        duration: 250
    }

    PropertyAnimation{
        id: close_options
        target: root
        property: "options_pixelsize"
        to: options_pixelsize_closed
        duration: 250
    }

    PropertyAnimation{
        id: colorize_menu
        target: root
        property: "menu_transparency"
        to: menu_transparency_open
        duration: 250
    }

    PropertyAnimation{
        id: clarify_menu
        target: root
        property: "menu_transparency"
        to: menu_transparency_closed
        duration: 250
    }

    function goBack(){
        backbutton.action();
    }
}



