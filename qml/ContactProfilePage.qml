import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import "Constants.js" as Constants

Page{
    id: root
    visible:true

    property string previous_page;

    property int data_fields_height     :   root.height - profileimage.height;
    property int presence_field_height  :   (2/8)*data_fields_height
    property int void_field_height      :   (1/8)*data_fields_height
    property int status_field_height    :   (5/8)*data_fields_height
    property int status_label_offset    :   (1/16)*data_fields_height
    property int status_text_offset     :   (7/32)*data_fields_height
    property int status_date_offset     :   (11/32)*data_fields_height
    property int delete_buttons_offset  :   (7/16)*data_fields_height
    property int left_margin            :   (1/15)*root.width
    property int right_margin           :   (1/15)*root.width


    Rectangle{
        anchors.fill: parent
        anchors.top : parent.top

        Image {
            id: profileimage
            width: parent.width
            height: parent.width
            anchors.left: parent.left
            anchors.top: parent.top
            source: contact.avatar_path_gui
            fillMode: Image.PreserveAspectCrop
        }

        Text {
            id: nametext
            anchors.bottom: profileimage.bottom
            anchors.bottomMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            text: contact.username_gui
            color: "white"
            font.bold: true
            font.pixelSize: 30
        }

        Rectangle{
            id: presence_field
            anchors.top: profileimage.bottom
            anchors.left: parent.left
            height: presence_field_height
            width: parent.width
            color: "white"

            Text{
                id: presencetext
                anchors.top: parent.top
                anchors.topMargin: parent.height/2-height/2
                anchors.left: parent.left
                anchors.leftMargin: left_margin
                text: contact.presence_gui
                font.bold: false
                font.pixelSize: 15
                font.italic: true
                color: "#828282"
            }

            ToolButton {
                id: chatbutton
                height: 40
                width: 40
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: right_margin
                anchors.topMargin: (parent.height/2)-height/2

                background: Rectangle {
                    radius: 20
                    color: "#31a7b4"
                }

                Image {
                    id: chaticon
                    anchors.centerIn: parent
                    source: "icons/whitechaticon.png"
                    height: 30
                    width: 30
                    fillMode: Image.PreserveAspectFit
                }

                onClicked:{
                    root.StackView.view.pop();
                    if(previous_page==="ContactPage"){
                        main_frame.loadConversationWith(contact.username_gui);
                        root.StackView.view.push("qrc:/ConversationPage.qml");
                    }
                }
            }

        }

        Rectangle{
            id: void_field
            anchors.top : presence_field.bottom
            anchors.left: parent.left
            height: void_field_height
            width: parent.width
            color: "#f2f2f2"
        }

        Rectangle{
            id: status_field
            anchors.top: void_field.bottom
            anchors.left: parent.left
            height: status_field_height
            width: parent.width
            color: "white"

            Text{
                id: status_label
                anchors.top: parent.top
                anchors.topMargin: status_label_offset
                anchors.left: parent.left
                anchors.leftMargin: left_margin
                text: "Status"
                font.bold: false
                font.pixelSize: 18
                font.italic: false
                color: Constants.TOOLBAR_COLOR
            }

            Text{
                id: status_text
                anchors.top: parent.top
                anchors.topMargin: status_text_offset
                anchors.left: parent.left
                anchors.leftMargin: left_margin
                text: contact.status_gui
                font.bold: false
                font.pixelSize: 16
                font.italic: true
                color: "#828282"
            }

            Text{
                id: status_date
                anchors.top: parent.top
                anchors.topMargin: status_date_offset
                anchors.left: parent.left
                anchors.leftMargin: left_margin
                anchors.right: parent.right
                text: contact.status_date_gui
                font.bold: false
                font.pixelSize: 14
                font.italic: false
                color: "#828282"
            }

            Rectangle{
                id: delete_buttons_rect
                anchors.top: parent.top
                anchors.topMargin: delete_buttons_offset
                anchors.left: parent.left
                anchors.leftMargin: left_margin
                anchors.right: parent.right
                color: "white"

                ToolButton {
                    id: deletebutton
                    height: 30
                    width: 30
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: right_margin
                    anchors.topMargin: (parent.height/2)-height/2

                    background: Rectangle {
                        radius: 15
                        color: "#31a7b4"
                    }

                    Image {
                        id: deleteicon
                        anchors.centerIn: parent
                        source: "icons/whitetrashicon.png"
                        height: 20
                        width: 20
                        fillMode: Image.PreserveAspectFit
                    }

                    onClicked: root.StackView.view.pop()
                }

                ToolButton {
                    id: blockbutton
                    height: 30
                    width: 30
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: (7/4)*right_margin + deletebutton.width
                    anchors.topMargin: (parent.height/2)-height/2

                    background: Rectangle {
                        radius: 15
                        color: "#31a7b4"
                    }

                    Image {
                        id: blockicon
                        anchors.centerIn: parent
                        source: "icons/whiteforbiddenicon.png"
                        height: 20
                        width: 20
                        fillMode: Image.PreserveAspectFit
                    }

                    onClicked: root.StackView.view.pop()
                }
            }
        }
    }

    ToolBar{
        height: 60
        width: parent.width
        anchors.top: parent.top
        anchors.left: parent.left

        background: Rectangle{
            color: "transparent"
        }

        ToolButton {
            id: backbutton
            height: 40
            width: 40
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: left_margin-(width/4)
            anchors.topMargin: (parent.height/2)-height/2
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                color: "transparent"
            }

            Image {
                id: backicon
                source: "icons/whitebackicon.png"
                height: 40
                width: 40
                fillMode: Image.PreserveAspectFit
            }

            onClicked: root.StackView.view.pop()
        }
    }


}
