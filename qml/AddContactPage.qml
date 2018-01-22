import QtQuick 2.6
import QtQuick.Controls 2.1

Page {

    id: root
    visible:true

    var toolbar_Colour = "#206d75"
    var toolbar_Text_Colour = "white"
    var username_Text_Colour = "#16323d"
    var username_Rectangle_BorderColour = "#021400"
    var add_Button_BorderColour = "#26282a"
    var button_Colour = "#f6f6f6"
    var pressed_Button_Colour = "#eefdff"
    var error_Text_Colour = "red"

    Connections{   
        target: main_frame
        onFinishedAddingContact:{
            if(add_result){
                root.StackView.view.pop();
            }
            else{
                errorlabeladd.text = err_msg;
                errorlabeladd.color = error_Text_Colour;
                errorlabeladd.visible = true;
            }

        }

    }

    header: ToolBar{

        height: 48

        Rectangle{
            anchors.fill: parent
            color: toolbar_Colour
        }

        ToolButton {
            id: backbutton


            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | addcontactbutton
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
            text: qsTr("Add User")
            color: toolbar_Text_Colour
            font.pixelSize: 25
            font.bold: true
            anchors.centerIn: parent
        }
    }


    Rectangle{
        anchors.fill: parent
        anchors.leftMargin: (root.width - rectuseradd.width)/2
        anchors.topMargin: 120

        Text {
            id: enteruseradd
            text: "New contact:"
            font.bold: true
            font.pixelSize: 17
            color: username_Text_Colour
        }

        Rectangle {
            id: rectuseradd
            width: 300
            height: 28
            anchors.top: enteruseradd.bottom
            anchors.topMargin: 10
            border.width: 2
            radius: 4
            border.color: username_Rectangle_BorderColour


            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
            }

            TextInput {
                id: contactinput           
                anchors.fill: parent
                font.bold: true
                anchors.leftMargin: 2
                font.pixelSize: 20
                selectByMouse: true
                mouseSelectionMode: TextInput.SelectCharacters
                maximumLength: 10
                onTextChanged: {
                    if(errorlabeladd.visible){
                        errorlabeladd.visible = false
                        errorlabeladd.text = ""
                    }
                }
                onAccepted:{
                    if(contactinput.text == ""){
                        errorlabeladd.visible = true
                        errorlabeladd.text = "Set a valid name"
                        errorlabeladd.color = error_Text_Colour
                    }else{
                        main_frame.addContact(contactinput.text);
                    }
                }
            }
        }

        Label{
            id:errorlabeladd
            text: ""
            visible: false
            font.pixelSize: 15
            anchors.top: rectuseradd.bottom
            anchors.topMargin: 10
        }

        Button{
            id: addcontactbutton
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: backbutton | addcontactbutton
            }
            anchors.top: errorlabeladd.bottom
            anchors.topMargin: 10
            font.pixelSize: 14
            anchors.left : parent.left
            anchors.leftMargin: (rectuseradd.width - addcontactbutton.width)/2
            text: "Add User"
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 40
                color: addcontactbutton.down ? pressed_Button_Colour : button_Colour
                border.color: add_Button_BorderColour
                border.width: 1
                radius: 4
            }
            onClicked: {
                if(contactinput.text == ""){
                    errorlabeladd.visible = true
                    errorlabeladd.text = "Set a valid name"
                    errorlabeladd.color = error_Text_Colour
                }
                else{
                    main_frame.addContact(contactinput.text);
                }
            }
        }
    }

}
