import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

ApplicationWindow {
    id: window
    width: app_width;
    height: app_height;
    visible: true

    property alias main                 :   window;
    property int toolbar_height         :   (app_height/10);
    property real density               :   main_frame.getDensity();
    property int app_height             :   main_frame.getAppHeight();
    property int app_width              :   main_frame.getAppWidth();
    property int statusbar_height       :   main_frame.getStatusbarHeight();
    property int navigationbar_height   :   main_frame.getNavigationbarHeight();
    property int vkeyboard_height       :   -1;

    Component.onCompleted: {
        console.log("MAIN COMPLEMETTED");
        if(CONNECTED===true){
            console.log("FOUND SERVER CONNECTED AT COMPLETED");
            if(stackView.currentItem.toString().indexOf("ConnectionPage")!==-1){
                console.log("REPLACING ITEM IN ON COMPLETED");
                stackView.replace("qrc:/LogPage.qml");
            }
        }
    }

    Connections{
        target: main_frame

        onReceivedForeignContact:{
            main_frame.addForeignContact();
        }

        onReceivedNewMessage:{
            main_frame.refreshContactsGUI();
        }

        onVkeyboardMeasured:{
            main.vkeyboard_height = vkeyboard_height;
            console.log("Current main height is : " + main.app_height);
            console.log("Signal received; VKbd : " + vkeyboard_height);
        }

        onConnectionFinished:{
            console.log("RECEIVED onConnectionFinished");
            stackView.replace("qrc:/LogPage.qml");
        }

        onOpenProgressDialog:{
            console.log("Received OPEN signal");
            if(!stackView.currentItem.progressDialog.opened){
                console.log("Opening dialog");
                stackView.currentItem.progressDialog.open();
            }
            console.log("Setting text");
            stackView.currentItem.progressDialog.text = progress_text;
        }

        onCloseProgressDialog:{
            console.log("Received close signal");
            if(stackView.currentItem.progressDialog.opened){
                console.log("Closing dialog");
                stackView.currentItem.progressDialog.close();
            }
        }
    }

    Timer{
        id: statusbar_controller
        interval: Constants.SHORT_DURATION
        onTriggered: {
            var statusbar_color = stackView.currentItem.statusbar_color;
            if(statusbar_color!==null){
                main_frame.changeStatusbarColor(statusbar_color)
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: ConnectionPage {}

        onCurrentItemChanged: {
            statusbar_controller.start();
        }

        pushEnter: Transition{
            SequentialAnimation{
                PropertyAnimation{
                    property: "opacity"
                    from: 0
                    to: 0
                    duration: 1
                }

                ParallelAnimation{
                    PropertyAnimation{
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: Constants.SHORT_DURATION
                    }

                    YAnimator{
                        from: main.toolbar_height
                        to: 0
                        duration: Constants.SHORT_DURATION
                    }
                }
            }
        }

        pushExit: Transition{
            PropertyAnimation{
                property: "opacity"
                from: 1
                to: 1
                duration: 2*Constants.SHORT_DURATION
            }
        }

        popEnter: Transition{
            PropertyAnimation{
                property: "opacity"
                from: 1
                to: 1
                duration: 2*Constants.SHORT_DURATION
            }
        }

        popExit: Transition{
            ParallelAnimation{
                PropertyAnimation{
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: Constants.SHORT_DURATION
                }
                YAnimator{
                    from: 0
                    to: main.toolbar_height
                    duration: Constants.SHORT_DURATION
                }
            }
        }

    }

    onClosing:{
        close.accepted = false;

        if(stackView.currentItem.dialog!==undefined){
            if(stackView.currentItem.dialog.opened===true){
               stackView.currentItem.dialog.close();
            }
            else{
                stackView.currentItem.goBack();
            }
        }
        else{
            stackView.currentItem.goBack();
        }
    }

    function decToColor(dec){
        if(dec<0){
            dec += 0xFFFFFFFF + 1;
        }
        return "#" + dec.toString(16).toUpperCase();
    }

}































