import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

Page {

    /*
      Esta página se refiere al perfil del propio usuario, tiene una imagen, un nombre y un estado. Tanto la imagen como el estado son clickables para poder cambiarlo,
      si clickas en la imagen abre el file dialog para poder seleccionar la nueva imagen. Cuando se selecciona la imagen se devuelve la ruta hasta ella como: file:///directorio
      Lo que habría que hacer sería almacenarla como icono del usuario y además enviársela al servidor para que los demás usuarios la acutalicen. Del mismo modo para el
      estado cuando se clicka te lleva a la ventana de cambiar estado. Ahora mismo está puesto como Name para el nombre y Status para el estado, habría que cargar
      el nombre y el estado del usuario.
      */

    id: root
    visible:true

    Connections{
        target: main_frame

        onStatusChanged:{
            statustext.text = new_status_gui + "\n On " + new_date_gui;
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

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: profileimagebutton | backbutton
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
            onClicked: root.StackView.view.pop()
        }

        Label{
            text: qsTr("Profile")
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
                profileimagefiledialog.open()
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
                    root.StackView.view.push("qrc:/ChangeStatusPage.qml")
                }
            }

        }
    }

    FileDialog{
        id: profileimagefiledialog
        title: "Choose the new profile image"
        nameFilters: [ "Image files (*.jpg *.png *.bmp)"]
        folder:shortcuts.desktop
        onAccepted: {
            var entered_path = this.fileUrl
            profileimage.source = entered_path
            main_frame.updateImagePath(entered_path.toString().replace("file:///",""));
        }
    }

}
