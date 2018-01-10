import QtQuick 2.6
import QtQuick.Controls 2.1

Page{
    id: root

    Connections{
        target: main_frame

        onReceivedForeignContact:{
            main_frame.addForeignContact();
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

            BorderImage {
                id: backiconid
                source: "icons/whitebackicon.png"
                height: 40
                width: 40
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
                main_frame.logOutUser()
                root.StackView.view.pop()
            }
        }


        ToolButton {
             id: groupbutton

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            BorderImage {
                id: groupicon
                source: "icons/whitegroupicon.png"
                height: 40
                width: 40
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

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            BorderImage {
                id: profileicon
                source: "icons/whiteprofileicon.png"
                height: 40
                width: 40
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

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            BorderImage {
                id: plusicon
                source: "icons/whiteplusicon.png"
                height: 40
                width: 40
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
        delegate: ItemDelegate {

            width: contacts_view.width - contacts_view.leftMargin - contacts_view.rightMargin
            height: avatar.implicitHeight + 40
            leftPadding: avatar.implicitWidth + 32

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: addcontactbutton | backbutton
            }

            Button{
                id: contactprofilebutton
                height: parent.height - 6
                width: parent.height - 6
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.verticalCenter: parent.verticalCenter

                BorderImage {
                    id: avatar
                    height: parent.height
                    width: parent.height
                    anchors.centerIn: parent
                    source: "file:///" + applicationDirPath + "/../" + "./data/common/images/default.png"
                }

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: addcontactbutton | backbutton | contactprofilebutton
                }

                onClicked: {
                    main_frame.refreshContactGUI(model.modelData.username_gui)
                    root.StackView.view.push("qrc:/ContactProfilePage.qml", { model: model })
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
                text: (model.modelData.status_gui.length>20)?(model.modelData.status_gui.substr(0,19)+"..."):(model.modelData.status_gui)
                font.pixelSize: 12
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
                font.pixelSize: 12
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
                main_frame.refreshContactGUI(model.modelData.username_gui)
                root.StackView.view.push("qrc:/ContactProfilePage.qml")
            }
        }
    }
}

