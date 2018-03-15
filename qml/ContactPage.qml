import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page{
    id: root

    property bool buttons_blocked : false;

    property int side_margin           :   (1/32)*root.width;
    property int pad_buttons            :   (1/16)*root.width;
    property int buttons_size           :   (3/32)*root.width;
    property int icons_size             :   (3/4)*buttons_size;
    property int left_pad_headertext    :   (1/16)*root.width;

    property int avatar_container_size  :   (4/17)*root.width;
    property int avatar_pad             :   (1/6)*root.width;
    property int avatar_image_size      :   (2/3)*avatar_container_size;
    property int contact_height         :   (2/15)*root.height;
    property int contactname_top_margin :   (1/3)*contact_height;
    property int lastmessage_top_margin :   (2/3)*contact_height;
    property int lastconnection_right_margin    :   (1/6)*root.width;

    Connections{
        target: main_frame
        onLogOut:{
            wait_box.visible = false;
            root.StackView.view.pop();
        }

        onWaitingForTooLong:{
            if(buttons_blocked==true){
                wait_box.visible = true;
            }
        }
    }

    header: ToolBar {
        id: toolbar
        height: main.toolbar_height

        Rectangle{
            anchors.fill: parent
            color: "#206d75"
        }

        ToolButton {
            id: backbutton
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: side_margin
            anchors.verticalCenter: parent.verticalCenter
            enabled: !(buttons_blocked)
            height: buttons_size
            width: buttons_size

            Rectangle{
                color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR
                anchors.fill: parent

                Image {
                    id: backicon                    
                    anchors.centerIn: parent
                    height: icons_size
                    width:  icons_size
                    source: "icons/whitebackicon.png"
                }
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton

            }

            onClicked:{
                buttons_blocked = true;
                main_frame.logOutUser();
            }
        }

        Text{
            id: logo_text
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.left: backbutton.right
            anchors.leftMargin: pad_buttons
            font.bold: false
            //font.family: ""
            font.pixelSize: 20
            color: "white"
            text: "Latchkey"
        }

        ToolButton{
            id: profileiconbutton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: side_margin
            anchors.verticalCenter: parent.verticalCenter
            height: buttons_size
            width: buttons_size
            enabled: !(buttons_blocked)

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            Rectangle{
                color: profileiconbutton.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR
                anchors.fill: parent

                Image {
                    id: profileicon
                    anchors.centerIn: parent
                    source: "icons/whiteprofileicon.png"
                    height: icons_size
                    width: icons_size
                }
            }

            onClicked: {
                root.StackView.view.push("qrc:/ProfilePage.qml")
            }

        }

        ToolButton {
            id: addcontactbutton
            anchors.top: parent.top
            anchors.right: profileiconbutton.left
            anchors.rightMargin: pad_buttons
            anchors.verticalCenter: parent.verticalCenter
            enabled: !(buttons_blocked)
            height: buttons_size
            width: buttons_size

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            Rectangle{
                color: addcontactbutton.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR
                height: icons_size
                width: icons_size
                anchors.fill: parent

                Image {
                    id: plusicon
                    source: "icons/whiteplusicon.png"
                    anchors.centerIn: parent
                    height: icons_size
                    width: icons_size
                }
            }

            onClicked:{
                root.StackView.view.push("qrc:/AddContactPage.qml")
            }
        }
    }

    ListView{
        id: contacts_view
        anchors.fill: parent
        topMargin: 0
        leftMargin: 0
        bottomMargin: 0
        rightMargin: 0
        spacing: 0
        model: ContactModel
        enabled: !(buttons_blocked)

        delegate: ItemDelegate {
            width: root.width
            height: contact_height

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            Button{
                id: avatar_button
                anchors.top: parent.top
                anchors.left: parent.left
                height: avatar_container_size
                width: avatar_container_size
                enabled: !(buttons_blocked)

                Rectangle{
                    anchors.fill: parent
                    color: "white"

                    Image {
                        id: avatar
                        anchors.centerIn: parent
                        height: avatar_image_size
                        width: avatar_image_size
                        source: model.modelData.avatar_path_gui
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: mask
                        }
                    }

                    Rectangle {
                        id: mask
                        height: avatar.height
                        width: avatar.width
                        radius: (avatar.height/2)
                        visible: false
                    }
                }


                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: addcontactbutton | backbutton | avatar_button
                }

                onClicked: {
                    main_frame.refreshContactGUI(model.modelData.username_gui)
                    root.StackView.view.push("qrc:/ContactProfilePage.qml",
                                             {previous_page : "ContactPage"});
                }
            }

            Label{
                id: contactname_label
                anchors.left: avatar_button.right
                anchors.top: parent.top
                anchors.topMargin: contactname_top_margin
                text: model.modelData.username_gui
                font.bold: true
                font.pixelSize: 15
                color: Constants.TOOLBAR_COLOR
            }

            Label{
                id: statustext
                anchors.left: avatar_button.right
                anchors.top: parent.top
                anchors.topMargin: lastmessage_top_margin
                text: (model.modelData.status_gui.length>10)?(model.modelData.status_gui.substr(0,9)+"..."):(model.modelData.status_gui)
                font.pixelSize: 11
                font.italic: true
                color: "#626665"
            }

            Label{
                id: lastmessagetext
                anchors.right: parent.right
                anchors.rightMargin: (messagesnotread.text == "0")?(15):(25+buttonmessagesnotread.width)
                anchors.bottom:  parent.bottom
                anchors.bottomMargin: (parent.height/2 - font.pixelSize)/2
                text: (model.modelData.last_message_gui.length>26)?(model.modelData.last_message_gui.substr(0,25)+"..."):(model.modelData.last_message_gui)
                font.pixelSize: 10
                color: "#626665"
            }

            Label{
                id: presencetext
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: lastmessage_top_margin
                color: "#626665"
                text: model.modelData.presence_gui
                horizontalAlignment: Text.AlignRight
                font.pixelSize: 10

            }

            Label{
                visible: messagesnotread.text != "0"
                id: buttonmessagesnotread
                anchors.right: parent.right
                rightPadding: 30
                anchors.rightMargin: 15
                anchors.bottom:  parent.bottom
                anchors.bottomMargin: (parent.height/2 - font.pixelSize)/2

                background: Rectangle{
                    implicitWidth: 10
                    implicitHeight: 10
                    anchors.rightMargin: 20
                    color: "#206d75"
                    border.color: "black"
                    border.width: 0
                    radius: 10

                    Text{
                        id: messagesnotread
                        color: "white"
                        anchors.centerIn: parent
                        text: model.modelData.unread_messages_gui
                        font.bold: true
                    }

                }
            }

            onClicked: {
                main_frame.loadConversationWith(model.modelData.username_gui)
                main_frame.refreshContactGUI(model.modelData.username_gui)
                root.StackView.view.push("qrc:/ConversationPage.qml")
            }

            onPressAndHold: {
                main_frame.refreshContactGUI(model.modelData.username_gui)
                root.StackView.view.push("qrc:/ContactProfilePage.qml",
                                         {previous_page : "ContactPage"});
            }
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

/**
        ToolButton {
            id: groupbutton
            enabled: !(buttons_blocked)

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            Rectangle{
                color: groupbutton.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR
                height: Constants.TOOLBUTTON_SIZE
                width: Constants.TOOLBUTTON_SIZE

                Image {
                    id: groupicon
                    source: "icons/whitegroupicon.png"
                    height: Constants.TOOLBUTTON_SIZE
                    width: Constants.TOOLBUTTON_SIZE
                }
            }

            anchors.left: parent.left
            anchors.leftMargin:(((parent.width)/4-width)/2) + (parent.width/4)
            anchors.verticalCenter: parent.verticalCenter

            onClicked: {
                root.StackView.view.push("qrc:/AddGroupPage.qml")
            }
        }
**/
