import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page{
    id: root

    property bool buttons_blocked : false;

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
        height: 60

        Rectangle{
            anchors.fill: parent
            color: "#206d75"
        }

        ToolButton {
            id: backbutton
            enabled: !(buttons_blocked)

            Rectangle{
                color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR
                height: Constants.TOOLBUTTON_SIZE
                width: Constants.TOOLBUTTON_SIZE

                Image {
                    id: backicon
                    source: "icons/whitebackicon.png"
                    height: Constants.TOOLBUTTON_SIZE
                    width: Constants.TOOLBUTTON_SIZE
                }
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton

            }

            anchors.left: parent.left
            anchors.leftMargin: (((parent.width)/4-width)/2)
            anchors.verticalCenter: parent.verticalCenter
            onClicked:{
                buttons_blocked = true;
                main_frame.logOutUser();
            }
        }


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

        ToolButton{
            id: profileiconbutton
            enabled: !(buttons_blocked)

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            Rectangle{
                color: profileiconbutton.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR
                height: Constants.TOOLBUTTON_SIZE
                width: Constants.TOOLBUTTON_SIZE

                Image {
                    id: profileicon
                    source: "icons/whiteprofileicon.png"
                    height: Constants.TOOLBUTTON_SIZE
                    width: Constants.TOOLBUTTON_SIZE
                }
            }

            anchors.left: parent.left
            anchors.leftMargin: (((parent.width)/4-width)/2) + (parent.width/4)*2
            anchors.verticalCenter: parent.verticalCenter

            onClicked: {
                root.StackView.view.push("qrc:/ProfilePage.qml")
            }

        }

        ToolButton {
            id: addcontactbutton
            enabled: !(buttons_blocked)

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            Rectangle{
                color: addcontactbutton.pressed ? Constants.PRESSED_COLOR:Constants.TOOLBAR_COLOR
                height: Constants.TOOLBUTTON_SIZE
                width: Constants.TOOLBUTTON_SIZE

                Image {
                    id: plusicon
                    source: "icons/whiteplusicon.png"
                    height: Constants.TOOLBUTTON_SIZE
                    width: Constants.TOOLBUTTON_SIZE
                }
            }

            anchors.left: parent.left
            anchors.leftMargin: (((parent.width)/4-width)/2) + (parent.width/4)*3
            anchors.verticalCenter: parent.verticalCenter
            onClicked:{
                root.StackView.view.push("qrc:/AddContactPage.qml")
            }
        }


    }

    ListView{
        id: contacts_view
        anchors.fill: parent
        topMargin: 15
        leftMargin: 15
        bottomMargin: 15
        rightMargin: 15
        spacing: 10
        height: 80
        model: ContactModel
        enabled: !(buttons_blocked)

        delegate: ItemDelegate {

            width: contacts_view.width - contacts_view.leftMargin - contacts_view.rightMargin
            height: avatar.height + 15
            leftPadding: avatar.implicitWidth + 32

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            Button{
                id: contactprofilebutton
                height: 70
                width: 70
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                enabled: !(buttons_blocked)

                Rectangle{
                    height: contactprofilebutton.height
                    width: contactprofilebutton.width
                    anchors.centerIn: parent
                    color: "white"

                    Image {
                        id: avatar
                        height: contactprofilebutton.height
                        width: contactprofilebutton.width
                        anchors.centerIn: parent
                        source: model.modelData.avatar_path_gui
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


                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: addcontactbutton | backbutton | contactprofilebutton
                }

                onClicked: {
                    main_frame.refreshContactGUI(model.modelData.username_gui)
                    root.StackView.view.push("qrc:/ContactProfilePage.qml",
                                             {previous_page : "ContactPage"});
                }

            }

            Label{
                id: nametext
                anchors.left: contactprofilebutton.right
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: (parent.height/2 - height)/2
                text: model.modelData.username_gui
                font.bold: true
                font.pixelSize: 15
                color: "#206d75"
            }

            Label{
                id: statustext
                anchors.left: contactprofilebutton.right
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin:(parent.height/2 - height)/2
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
                anchors.rightMargin: 15
                anchors.top: parent.top
                anchors.topMargin: (parent.height/2 - height)/2
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

