import QtQuick 2.6
import QtQuick.Controls 2.1

Page {

    id: root
    visible:true

    Connections{   
        target: main_frame
        onFinishedAddingContact:{
            if(add_result){
                root.StackView.view.pop();
            }
            else{
                errorlabeladd.text = err_msg;
                errorlabeladd.color = "red";
                errorlabeladd.visible = true;
            }

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
            color: "white"
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
            color: "#16323d"
        }

        Rectangle {
            id: rectuseradd
            width: 300
            height: 28
            anchors.top: enteruseradd.bottom
            anchors.topMargin: 10
            border.width: 2
            radius: 4
            border.color: "#021400"


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
                        errorlabeladd.color = "red"
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
                color: addcontactbutton.down ? "#eefdff" : "#f6f6f6"
                border.color: "#26282a"
                border.width: 1
                radius: 4
            }
            onClicked: {
                if(contactinput.text == ""){
                    errorlabeladd.visible = true
                    errorlabeladd.text = "Set a valid name"
                    errorlabeladd.color = "red"
                }
                else{
                    main_frame.addContact(contactinput.text);
                }
            }
        }
    }

}
