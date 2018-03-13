import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page {
    id: root
    visible:true

    property bool avatar_changed : false;
    property bool block_buttons : false;

    Connections{
        target: main_frame

        onStatusChanged:{
            statustext.text = new_status_gui + "\n On " + new_date_gui;
        }

        onAvatarChanged:{
            profileimage.source = main_frame.getCurrentImagePath();
            avatar_changed = true;
        }

        onFinishedUploadingImage:{
            avatar_changed = false;
            root.StackView.view.pop();
        }

        onWaitingForTooLong:{
            wait_box.visible = true;
        }
    }

    header: ToolBar{

        height: 48

        Rectangle{
            anchors.fill: parent
            color: "#206d75"
        }

        ToolButton {
            id: backbutton
            flat: true

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: profileimagebutton | backbutton
            }

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


            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            onClicked:{
                if(avatar_changed){
                    block_buttons = true;
                    main_frame.sendAvatar();
                }
                else{
                    root.StackView.view.pop()
                }
            }
        }

        Label{
            text: "Profile"
            color: "white"
            font.pixelSize: 20
            font.bold: true
            anchors.centerIn: parent
        }
    }

    Rectangle{
        anchors.fill: parent
        color: "white"
        height: parent.height
        width: parent.width

        Button{
            id: profileimagebutton
            width: parent.width
            height: parent.width
            anchors.left: parent.left
            anchors.leftMargin: (parent.width-width)/2
            anchors.top: parent.top   

            Image {
                id: profileimage
                width: parent.width
                height: parent.width
                source: main_frame.getCurrentImagePath()
                fillMode: Image.PreserveAspectCrop
            }


            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: profileimagebutton | backbutton

            }

            onClicked: {
                //profileimagefiledialog.open()
                if(block_buttons==false){
                    main_frame.openImagePicker();
                }
            }

        }


        Text {
            id: nametext
            anchors.left: parent.left
            anchors.leftMargin: parent.width/2 - width/2
            anchors.bottom: profileimagebutton.bottom
            anchors.bottomMargin: 30
            font.bold: true
            font.pixelSize: 35
            text: main_frame.getCurrentUsername()
            color: "white"
        }

        Rectangle{

            id: rectuserstatus
            width: parent.width - 100
            height: 28 * 3 - 2
            anchors.top: profileimagebutton.bottom
            anchors.topMargin: (parent.height-profileimagebutton.height-height)/2
            anchors.left: parent.left
            anchors.leftMargin: (parent.width-width)/2
            border.width: 0

            Button{
                id: statustextbutton
                anchors.fill: parent
                background:
                    Rectangle {
                        color: "#ffffff"
                        border.color: "#ffffff"
                        border.width: 1
                        radius: 4
                        Text {
                            id: statustext
                            anchors.fill: parent
                            wrapMode: TextInput.Wrap
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 15
                            text: main_frame.getCurrentStatus()+"\n On "+main_frame.getCurrentStatusDate()
                        }
                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: profileimagebutton | backbutton
                        }
                }

                onClicked: {
                    if(block_buttons==false){
                        root.StackView.view.push("qrc:/ChangeStatusPage.qml")
                    }
                }
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

















































