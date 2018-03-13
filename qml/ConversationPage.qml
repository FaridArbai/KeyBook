import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page {
    id: root

    property int send_button_size       :   (1/8)*root.width;

    property int send_field_margin      :   (1/32)*root.width;
    property int messages_field_margin  :   (1/16)*root.width;

    property int send_field_height      :   send_button_size + 2*send_field_margin;
    property int messages_field_height  :   root.height - (toolbar.height + send_field_height);

    property int text_area_width        :   root.width - (3*send_field_margin + send_button_size);

    property int arrow_left_padding     :   (1/32)*root.width;
    property int arrow_size             :   (1/16)*root.width;
    property int image_left_paddding    :   (1/16)*root.width;
    property int image_size             :   (3/4)*main.toolbar_height;
    property int image_top_padding      :   (1/8)*main.toolbar_height;
    property int presence_left_padding  :   (1/16)*root.width;
    property int username_top_padding   :   (1/3)*main.toolbar_height;
    property int presence_top_padding   :   (2/3)*main.toolbar_height;



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
            color: "#206d75"
        }

        ToolButton {
            id:backbutton
            anchors.left: parent.left
            anchors.leftMargin: arrow_left_padding
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            height: arrow_size
            width: arrow_size

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | send_button
            }

            Rectangle{
                color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR
                anchors.fill: parent

                Image {
                    id: backicon
                    anchors.fill: parent
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
                color: Constants.TOOLBAR_COLOR

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

        Rectangle{
            id: contact_info_container
            anchors.top: parent.top
            anchors.left: avatar_button.right
            anchors.leftMargin: presence_left_padding
            anchors.bottom: parent.bottom
            color: "transparent"

            Label{
                id: username_label
                anchors.top: parent.top
                anchors.topMargin: username_top_padding-height/2
                anchors.left: parent.left
                text: contact.username_gui
                color: "white"
                font.bold: true
                font.pixelSize: 16
            }

            Label{
                id: presence_label
                anchors.top: parent.top
                anchors.topMargin: presence_top_padding-height/2
                anchors.left: parent.left
                text: contact.presence_gui
                color: "white"
                font.pixelSize: 12
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
                spacing: 12
                model: MessageModel

                delegate: Column {
                    anchors.right: sentByMe ? parent.right : undefined
                    spacing: 6

                    readonly property bool sentByMe: (contact.username_gui !== model.modelData.sender_gui)

                    Row {
                        id: messageRow
                        spacing: 6
                        anchors.right: sentByMe ? parent.right : undefined

                        Rectangle {
                            width: Math.min(messageText.implicitWidth + 24,
                                            listView.width - (!sentByMe ? messageRow.spacing : 0)
                                            )
                            height: messageText.implicitHeight + 24
                            color: sentByMe ? "#afe3e9" : "#107087"
                            radius: 4

                            Label {
                                id: messageText
                                text: model.modelData.text_gui
                                color: sentByMe ? "black" : "white"
                                anchors.fill: parent
                                anchors.margins: 12
                                wrapMode: Label.Wrap
                                font.pixelSize: 12
                            }
                        }
                    }


                    Label {
                           id: timestampText
                           text: model.modelData.date_gui
                           color: "lightgrey"
                           anchors.right: sentByMe ? parent.right : undefined
                           font.pixelSize: 12
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
                font.pixelSize: 15

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
