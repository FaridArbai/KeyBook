import QtQuick 2.9
import QtQuick.Controls 2.2

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

    Connections{
        target: main_frame

        onReceivedForeignContact:{
            main_frame.addForeignContact();
        }

        onReceivedNewMessage:{
            main_frame.refreshContactsGUI();
        }

        onVkeyboardHeightChanged:{
            main.vkeyboard_height = vkeyboard_height;
            console.log("Signal received; VKbd : " + vkeyboard_height);
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: LogPage {}

        onCurrentItemChanged: {
            var statusbar_color = currentItem.statusbar_color;
            if(statusbar_color!==null){
                main_frame.changeStatusbarColor(statusbar_color)
            }

        }
    }

    onClosing: {
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































