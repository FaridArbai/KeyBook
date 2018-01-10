import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1

Page {
    id: root

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
            color: "#206d75"
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
            source: "icons/default.png"


        }

        Label{
            id: presencenametext
            text: contact.username_gui
            color: "white"
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
            color: "white"
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
                        color: sentByMe ? "#f1f2ff" : "#16323d"
                        radius: 4

                        Label {
                            id: messageText
                            text: model.modelData.text_gui
                            color: sentByMe ? "black" : "white"
                            anchors.fill: parent
                            anchors.margins: 12
                            wrapMode: Label.Wrap

                        }
                    }
                }


                Label {                   
                       id: timestampText
                       text: model.modelData.date_gui
                       color: "lightgrey"
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
                    color: "#e3ebee"
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

