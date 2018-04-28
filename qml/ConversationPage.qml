import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page {
    id: root

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
    property int options_pixelsize      :   (28/href)*root.height
    property int message_pixelsize      :   (24/href)*root.height;
    property int timestamp_pixelsize    :   (24/href)*root.height;
    property int textarea_pixelsize     :   (30/href)*root.height;


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
                color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TRANSPARENT
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
                main_frame.finishCurrentConversation()
                root.StackView.view.pop()
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
                main_frame.refreshContactGUI(contact.username_gui)
                root.StackView.view.push("qrc:/ContactProfilePage.qml",
                                         {previous_page : "Conversation_Page"})
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
                                         {previous_page : "Conversation_Page"})
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
                color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TRANSPARENT
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

            Menu {
                id: menu
                x: parent.width - width
                width: (root.width/2)
                transformOrigin: Menu.TopRight

                background: Rectangle{
                    height: menu.height
                    width: menu.width
                    radius: options_pixelsize
                    color: "white"
                }

                MenuItem {
                    text: "View contact"
                    font.pixelSize: options_pixelsize
                    bottomPadding: options_pixelsize
                    topPadding: options_pixelsize
                    onTriggered: menu.close();
                }
                MenuItem {
                    text: "Change latchkey"
                    font.pixelSize: options_pixelsize
                    bottomPadding: options_pixelsize
                    topPadding: options_pixelsize
                    onTriggered: menu.close();
                }
                MenuItem {
                    text: "Clear conversation"
                    font.pixelSize: options_pixelsize
                    bottomPadding: options_pixelsize
                    topPadding: options_pixelsize
                    onTriggered: menu.close();
                }
                MenuItem {
                    text: "Block contact"
                    font.pixelSize: options_pixelsize
                    bottomPadding: options_pixelsize
                    topPadding: options_pixelsize
                    onTriggered: menu.close();
                }
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
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: messages_field_margin
                displayMarginBeginning: 0
                displayMarginEnd: 0
                verticalLayoutDirection: ListView.BottomToTop
                spacing: (24/href)*root.height
                model: MessageModel

                delegate: Column {
                    anchors.right: sentByMe ? parent.right : undefined
                    spacing: (12/href)*root.height

                    readonly property bool sentByMe: (contact.username_gui !== model.modelData.sender_gui)

                    Row {
                        id: messageRow
                        spacing: (12/href)*root.height
                        anchors.right: sentByMe ? parent.right : undefined

                        Rectangle {
                            width: Math.min(messageText.implicitWidth + (48/href)*root.height,
                                            listView.width - (!sentByMe ? messageRow.spacing : 0)
                                            )
                            height: messageText.implicitHeight + (48/href)*root.height
                            color: sentByMe ? "#afe3e9" : "#107087"
                            radius: (8/href)*root.height

                            Label {
                                id: messageText
                                text: model.modelData.text_gui
                                color: sentByMe ? "black" : "white"
                                anchors.fill: parent
                                anchors.margins: (24/href)*root.height
                                wrapMode: Label.Wrap
                                font.pixelSize: message_pixelsize
                            }
                        }
                    }

                    Label {
                           id: timestampText
                           text: model.modelData.date_gui
                           color: "lightgrey"
                           anchors.right: sentByMe ? parent.right : undefined
                           font.pixelSize: timestamp_pixelsize
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
}


/**
        Rectangle{
            height: 60
            width: 60
            anchors.centerIn: parent
            anchors.left: backbutton.right
            anchors.leftMargin: 30
            anchors.verticalCenter: parent.verticalCenter
            color: "#206d75"

            Image{
                id: contactprofilebutton
                height: 60
                width: 60
                anchors.centerIn: parent
                anchors.left: backbutton.right
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                source: contact.avatar_path_gui
                fillMode: Image.PreserveAspectCrop
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }
            }

            Rectangle {
                id: mask
                height: contactprofilebutton.height
                width: contactprofilebutton.width
                radius: (contactprofilebutton.height/2)
                visible: false
            }
        }
**/
