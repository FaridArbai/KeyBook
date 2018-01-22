import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2

Page {

    /*
      En esta pagina se representa la información del contacto, cuando le das en la contact page al icono de un usuario te lleva
      a esta nueva página y se le pasa como parámetro el nombre del contacto y el estado. Habría que cargar el icono para el contacto
      al igual que se haría en la contact page y listo.
     */

    id: root
    visible:true

    var toolbar_Colour = "#206d75"
    var profile_Name_Colour = "white"
    var presence_Text_Colour = "white"

    header: ToolBar{

        id: toolbar
        height: 60

        Rectangle{
            anchors.fill: parent
            color: toolbar_Colour
        }

        ToolButton {
            id: backbutton

            height: 48

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | backbutton
            }

            BorderImage {
                id: backicon
                source: "icons/whitebackicon.png"
                height: 40
                width: 40
            }

            anchors.left: parent.left
            anchors.leftMargin: (((toolbar.width/4)-width)/2)
            anchors.verticalCenter: parent.verticalCenter
            onClicked: root.StackView.view.pop()
        }



        ToolButton {
            id: initconversationbutton

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: initconversationbutton | backbutton
            }

            BorderImage {
                id: initconversationicon
                source: "icons/whitechaticon.png"
                height: 40
                width: 40
            }

            anchors.left: parent.left
            anchors.leftMargin: (((toolbar.width/4)-width)/2) + (toolbar.width/4)
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                main_frame.loadConversationWith(contact.username_gui)
                root.StackView.view.push("qrc:/ConversationPage.qml")
            }
        }


        ToolButton {
            id: blockcontactbutton

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: initconversationbutton | backbutton
            }

            BorderImage {
                id: blockcontacticon
                source: "icons/whiteforbiddenicon.png"
                height: 40
                width: 40
            }

            anchors.left: parent.left
            anchors.leftMargin: (((toolbar.width/4)-width)/2) + (toolbar.width/4)*2
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                // send blockContact to server
            }
        }

        ToolButton {
            id: removecontactbutton

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: removecontactbutton | backbutton
            }

            BorderImage {
                id: removeicon
                source: "icons/whitetrashicon.png"
                height: 40
                width: 40
            }

            anchors.left: parent.left
            anchors.leftMargin: (((toolbar.width/4)-width)/2) + (toolbar.width/4)*3
            anchors.verticalCenter: parent.verticalCenter
            onClicked:{
                // delete contact
            }
        }


    }


    Rectangle{

        anchors.fill: parent

        Image {
            id: profileimage
            width: parent.width
            height: parent.width
            anchors.left: parent.left
            anchors.leftMargin: (parent.width-width)/2
            anchors.top: parent.top
            source: contact.avatar_path_gui
            fillMode: Image.PreserveAspectCrop
        }

        Text {
            id: nametext
            anchors.bottom: profileimage.bottom
            anchors.bottomMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: contact.username_gui
            color: profile_Name_Colour
            font.bold: true
            font.pixelSize: 40
        }

        Text {
            id: presencetext
            anchors.bottom: profileimage.bottom
            anchors.bottomMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: (parent.width-width-10)
            text: contact.presence_gui
            color: presence_Text_Colour
            font.bold: false
            font.pixelSize: 20
            font.italic: true
        }

        Rectangle{

            id: rectuserstatus
            width: parent.width - 100
            height: 28 * 3 - 2
            anchors.top: profileimage.bottom
            anchors.topMargin: (parent.height-profileimage.height-height)/2
            anchors.left: parent.left
            anchors.leftMargin: (parent.width-width)/2
            border.width: 0


            Text {
                id: statustext
                anchors.fill: parent
                wrapMode: TextInput.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: contact.status_gui+"\n On "+contact.status_date_gui
                font.pixelSize: 15
                font.italic: true
            }

        }



    }

}
