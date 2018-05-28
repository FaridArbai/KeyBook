import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import "Constants.js" as Constants
import QtQuick.Dialogs 1.2

Page{
    id: root

    property var statusbar_color    :   Constants.CONTACTS_STATUSBAR_COLOR;

    property bool buttons_blocked : false;

    property int href   :   1135;
    property int wref   :   720;

    property int side_margin            :   (Constants.SIDE_FACTOR)*root.width;
    property int pad_buttons            :   (Constants.SPACING_FACTOR)*root.width;
    property int buttons_size           :   icons_size
    property int icons_size             :   (34/wref)*root.width;
    property int backicon_size          :   (3/4)*buttons_size;
    property int left_pad_headertext    :   (1/16)*root.width;

    property int avatar_container_width :   (165/724)*root.width;
    property int contact_height         :   (156/165)*avatar_container_width;
    property int avatar_right_pad       :   (1/6)*avatar_container_width;
    property int avatar_top_pad         :   (contact_height-avatar_image_size)/2;
    property int avatar_image_size      :   (2/3)*avatar_container_width;
    property int contactname_top_margin :   (1/3)*contact_height;
    property int lastmessage_top_margin :   (2/3)*contact_height;
    property int lastconnection_right_margin    :   avatar_right_pad;

    property int logo_pixelsize         :   icons_size;
    property int contactname_pixelsize  :   (30/wref)*root.width;
    property int lastmessage_pixelsize  :   (28/wref)*root.width;
    property int presence_pixelsize     :   (24/wref)*root.width;
    property int unread_pixelsize       :   (20/wref)*root.width;

    property int unread_container_pixelsize :   (5/4)*lastmessage_pixelsize;

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
            color: Constants.TOOLBAR_COLOR
        }

        ToolButton {
            id: backbutton
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: side_margin
            anchors.topMargin: (parent.height-height)/2
            enabled: !(buttons_blocked)
            height: buttons_size
            width: buttons_size
            background: Rectangle{color: Constants.TOOLBAR_COLOR}

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
            font.pixelSize: logo_pixelsize
            color: "white"
            text: "Latchword"
        }

        ToolButton{
            id: profileiconbutton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: side_margin
            anchors.topMargin: (parent.height-height)/2
            height: buttons_size
            width: buttons_size
            enabled: !(buttons_blocked)
            background: Rectangle{color: Constants.TOOLBAR_COLOR}

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
            anchors.topMargin: (parent.height-height)/2
            enabled: !(buttons_blocked)
            height: buttons_size
            width: buttons_size
            background: Rectangle{color: Constants.TOOLBAR_COLOR}

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
                height: contact_height
                width: avatar_container_width
                enabled: !(buttons_blocked)

                Rectangle{
                    anchors.fill: parent
                    color: "white"

                    Image {
                        id: avatar
                        anchors.top: parent.top
                        anchors.topMargin: avatar_top_pad
                        anchors.left: parent.left
                        anchors.leftMargin: avatar_right_pad
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
                anchors.topMargin: contactname_top_margin-height/2
                text: model.modelData.username_gui
                font.bold: true
                font.pixelSize: contactname_pixelsize
                color: Constants.ContactPage.CONTACTNAME_COLOR
            }

            Label{
                id: presencetext
                anchors.right: parent.right
                anchors.rightMargin: avatar_right_pad
                anchors.top: parent.top
                anchors.topMargin: contactname_label.anchors.topMargin+(contactname_label.font.pixelSize-font.pixelSize)
                text: model.modelData.shortpresence_gui
                font.pixelSize: presence_pixelsize
                color: Constants.ContactPage.PRESENCE_COLOR
            }

            Label{
                id: lastmessagetext
                anchors.left: avatar_button.right
                anchors.top:  parent.top
                anchors.topMargin: lastmessage_top_margin-height/2
                text: (model.modelData.last_message_gui.length>26)?(model.modelData.last_message_gui.substr(0,25)+"..."):(model.modelData.last_message_gui)
                font.pixelSize: lastmessage_pixelsize
                font.bold: unread_label.has_unread_message
                color: Constants.ContactPage.LASTMESSAGE_COLOR
            }

            Rectangle{
                id: unread_container
                anchors.right: parent.right
                anchors.rightMargin: avatar_right_pad
                anchors.top: lastmessagetext.top
                anchors.topMargin: (lastmessagetext.height-height)/2
                height: unread_container_pixelsize
                width: unread_container_pixelsize
                radius: width/2
                color: Constants.ContactPage.UNREAD_CONTAINER_COLOR
                visible: unread_label.has_unread_message

                Label{
                    id: unread_label
                    anchors.centerIn: parent
                    rightPadding: 0
                    leftPadding: 0
                    topPadding: 0
                    bottomPadding: 0
                    font.bold: false
                    font.pixelSize: unread_pixelsize
                    text: model.modelData.unread_messages_gui
                    color: Constants.ContactPage.UNREAD_TEXT_COLOR

                    property int surrounding_size       :   Math.max(height,width);
                    property bool has_unread_message    :   (text!="0");
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

            Rectangle{
                id: separator
                anchors.bottom: parent.bottom
                anchors.left: avatar_button.right
                anchors.right: parent.right
                anchors.rightMargin: avatar_right_pad
                height: 1
                color: "#DDDDDD"
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
