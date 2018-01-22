import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1

Page {
    id: root

    var toolbar_Colour = "#206d75"
    var contact_Name_Colour = "#206d75"
    var contact_Status_Colour = "#626665"
    var contact_Presence_Colour = "white"
    var contact_Presence_LastConnection_Colour = "white"
    var message_Own_Background_Colour = "#f1f2ff"
    var message_Other_Background_Colour = "#16323d"
    var message_Own_Text_Colour = "black"
    var message_Other_Text_Colour =  "white"
    var timestamp_Colour = "lightgrey"
    var write_Field_Background_Colour = "#e3ebee"



    Connections{
        target: main_frame

        onReceivedMessageForCurrentConversation:{
            main_frame.refreshMessagesGUI();
        }
    }

    header: ToolBar {

        id:toolbar
        height: 80

        Rectangle{
            anchors.fill: parent
            color: toolbar_Colour
        }

        ToolButton {

            id:backbutton

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | sendbutton
            }

            BorderImage {
                id: backicon
                source: "icons/whitebackicon.png"
                height: 40
                width: 40
            }

            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            onClicked:{
                main_frame.finishCurrentConversation()
                root.StackView.view.pop()
            }
        }


        Image{
            id: presenceimage
            height: 60
            width: 60
            anchors.left: backbutton.right
            anchors.leftMargin: 30
            anchors.verticalCenter: parent.verticalCenter
            source: contact.avatar_path_gui
            fillMode: Image.PreserveAspectCrop
        }

        Label{
            id: presencenametext
            text: contact.username_gui
            color: contact_Presence_Colour
            anchors.left: presenceimage.right
            anchors.leftMargin: 20
            anchors.top: parent.top
            anchors.topMargin: (parent.height/2 - height)/2
            font.bold: true
            font.pixelSize: 15

        }

        Label{
            id:presencelastconnectiontext
            text: contact.presence_gui
            color: contact_Presence_LastConnection_Colour
            anchors.bottom: parent.bottom
            anchors.bottomMargin: (parent.height/2 - height)/2
            anchors.left: presenceimage.right
            anchors.leftMargin: 20
            font.pixelSize: 10

        }
    }

    ColumnLayout {
        anchors.fill: parent

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: pane.leftPadding + messageField.leftPadding
            displayMarginBeginning: 40
            displayMarginEnd: 40
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
                                listView.width - (!sentByMe ? messageRow.spacing : 0))
                        height: messageText.implicitHeight + 24
                        color: sentByMe ? message_Own_Background_Colour : message_Other_Background_Colour
                        radius: 4

                        Label {
                            id: messageText
                            text: model.modelData.text_gui
                            color: sentByMe ? message_Own_Text_Colour : message_Other_Text_Colour
                            anchors.fill: parent
                            anchors.margins: 12
                            wrapMode: Label.Wrap

                        }
                    }
                }


                Label {                   
                       id: timestampText
                       text: model.modelData.date_gui
                       color: timestamp_Colour
                       anchors.right: sentByMe ? parent.right : undefined
                }

            }

            ScrollBar.vertical: ScrollBar {}
        }

        Pane {
            id: pane
            Layout.fillWidth: true

            RowLayout {


                Rectangle{
                    height:parent.height
                    width: parent.width-sendbutton.width
                    color: write_Field_Background_Colour
                    radius: 6
                }


                width: parent.width

                TextArea {
                    id: messageField
                    Layout.fillWidth: true
                    placeholderText: ("Compose message")
                    wrapMode: TextArea.Wrap 
                    selectByMouse: true
                    mouseSelectionMode: TextInput.SelectCharacters

                    onTextChanged:{
                        if((messageField.text.search("\n")!=(-1))&&(messageField.text!="\n")){
                            main_frame.sendMessage(contact.username_gui,
                                                   messageField.text.replace('\n',""));
                            messageField.text = ""
                            messageField.placeholderText = ("Compose another message")
                        }
                        else if(messageField.text=="\n"){
                            messageField.text = ""
                            messageField.placeholderText = ("Compose a valid message")
                        }
                    }
                }

                ToolButton {
                    id: sendbutton
                    enabled: messageField.length > 0

                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: backbutton | sendbutton
                    }

                    Image {
                        id: sendicon
                        source: "icons/whitesendicon.png"
                    }

                    onClicked:{
                        if(messageField.text!="\n"){
                            main_frame.sendMessage(contact.username_gui,
                                               messageField.text.replace('\n',""));
                            messageField.text = ""
                            messageField.placeholderText = ("Compose another message")
                        }
                        else if(messageField.text=="\n"){
                            messageField.text = ""
                            messageField.placeholderText = ("Compose a valid message")
                        }
                    }

                }


            }
        }
    }
}

