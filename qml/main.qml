import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

ApplicationWindow {
    id: window
    width: (PLATFORM==="ANDROID")?(main_frame.getAppWidth()):((2.5)*main_frame.getAppWidth());
    height: (PLATFORM==="ANDROID")?(main_frame.getAppHeight()):main_frame.getAppHeight() + titlebar_height;
    visible: true
    flags: (PLATFORM==="DESKTOP")?(Qt.FramelessWindowHint | Qt.Window):(window.flags);
    color: "transparent"


    property alias main                     :   window;
    property alias conversationStackView    :   conversationView;
    property alias mainStackView            :   stackView;

    property int toolbar_height         :   (app_height/10);
    property real density               :   main_frame.getDensity();
    property int app_height             :   main_frame.getAppHeight() - 2*elevation_margins;
    property int app_width              :   main_frame.getAppWidth() - 2*elevation_margins;
    property int screen_height          :   (PLATFORM==="DESKTOP") ? main_frame.getScreenHeight() : app_height;
    property int screen_width           :   (PLATFORM==="DESKTOP") ? main_frame.getScreenWidth() : app_width;
    property int statusbar_height       :   main_frame.getStatusbarHeight();
    property int navigationbar_height   :   main_frame.getNavigationbarHeight();
    property int vkeyboard_height       :   -1;
    property int titlebar_height        :   (PLATFORM==="DESKTOP")?((150/3.5)*density):0;

    property int toolicons_size     :   (0.43)*titlebar_height;
    property int toolicons_spacing  :   (4/3)*toolicons_size;
    property int toolbuttons_width  :   (toolicons_size + 2*toolicons_spacing);

    property int shadow_margins     :   (PLATFORM==="DESKTOP")?(2*normal_elevation):(0);
    property int normal_elevation   :   (5/3.5)*density;
    property int picked_elevation   :   (3/2)*normal_elevation;

    property int vertical_offset    :   (PLATFORM==="DESKTOP")?1:0;
    property int horizontal_offset  :   (PLATFORM==="DESKTOP")?1:0;
    property int normal_radius      :   (PLATFORM==="DESKTOP")?5:0;
    property int pressed_radius     :   (PLATFORM==="DESKTOP")?8:0;
    property int elevation_margins  :   (PLATFORM==="DESKTOP")?10:0;

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
            main_frame.refreshConversationsGUI();
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
                if(PLATFORM==="ANDROID"){
                    main_frame.changeStatusbarColor(statusbar_color);
                }
                else{
                    titlebar.color = main.decToColor(statusbar_color);
                }
            }
        }
    }

    Rectangle{
        id: frame
        anchors.fill: parent
        anchors.margins: (PLATFORM==="DESKTOP")?elevation_margins:0
        radius: (PLATFORM==="DESKTOP")?(width/128):0
        color: "transparent"

        Rectangle{
            id: titlebar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: titlebar_height
            color: Constants.STATUSBAR_COLOR
            visible: (PLATFORM==="DESKTOP")
            enabled: (PLATFORM==="DESKTOP")
            clip: true

            MouseArea{
                id: controller
                anchors.fill: parent
                property real pressedX;
                property real pressedY;

                onPressed:{
                    pressedX = mouse.x;
                    pressedY = mouse.y;
                }

                onPositionChanged:{
                    if(window.visibility!=Window.FullScreen){
                        var next_x = window.x + (mouse.x - pressedX);
                        var next_y = window.y + (mouse.y - pressedY);

                        if((next_x>0)&&(next_x<(screen_width-window.width))){
                            window.x = next_x;
                        }

                        if((next_y>0)&&(next_y<(screen_height-window.height))){
                            window.y = next_y;
                        }
                    }
                }
            }


            CustomMask{
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: Math.round(width/2);
                anchors.topMargin: Math.round((parent.height-height)/2);
                width: Math.round(parent.height*(3/4));
                height: width
                source: "icons/whitelogoicon.png"
                color: Constants.GENERAL_TEXT_WHITE
                smooth: true
            }

            CustomButton{
                id: close_button
                anchors.right:  parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: toolbuttons_width
                animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
                enabled: PLATFORM === "DESKTOP";

                CustomMask{
                    id: close_icon
                    anchors.centerIn: parent
                    width: toolicons_size
                    height: toolicons_size
                    source: "icons/close.png"
                    color: Constants.GENERAL_TEXT_WHITE
                }

                onClicked: {
                    main.close()
                }
            }

            CustomButton{
                id: maximize_button
                anchors.right: close_button.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: toolbuttons_width
                animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
                enabled: PLATFORM === "DESKTOP";

                CustomMask{
                    id: maximize_icon
                    anchors.centerIn: parent
                    width: toolicons_size
                    height: toolicons_size
                    source: "icons/maximize.png"
                    color: Constants.GENERAL_TEXT_WHITE
                }

                onClicked: {
                    if(window.visibility===Window.FullScreen){
                        window.showNormal();
                    }
                    else{
                        window.showFullScreen();
                    }
                }
            }

            CustomButton{
                id: minimize_button
                anchors.right:  maximize_button.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: toolbuttons_width
                animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
                enabled: PLATFORM === "DESKTOP";

                CustomMask{
                    id: minimize_icon
                    anchors.centerIn: parent
                    width: toolicons_size
                    height: toolicons_size
                    source: "icons/minimize.png"
                    color: Constants.GENERAL_TEXT_WHITE
                }


                onClicked: {
                    window.showMinimized();
                }
            }


        }

        StackView {
            id: stackView
            anchors.top: (PLATFORM==="DESKTOP")?(titlebar.bottom):(parent.top)
            anchors.left: parent.left
            width: app_width
            anchors.bottom: parent.bottom
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

            replaceEnter: Transition{
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

            replaceExit: Transition{
                PropertyAnimation{
                    property: "opacity"
                    from: 1
                    to: 1
                    duration: 2*Constants.SHORT_DURATION
                }
            }

        }

        Rectangle{
            id: separator
            anchors.left: mainStackView.right
            anchors.top: mainStackView.top
            anchors.bottom: mainStackView.bottom
            width: (PLATFORM==="DESKTOP")?(1):(0)
            color: "#edeef0";
        }

        StackView {
            id: conversationView
            anchors.top: (PLATFORM==="DESKTOP")?titlebar.bottom:undefined
            anchors.left: (PLATFORM==="DESKTOP")?separator.right: undefined
            anchors.bottom: (PLATFORM==="DESKTOP")?parent.bottom:undefined
            width: (PLATFORM==="DESKTOP")?(window.width - stackView.width - 2*elevation_margins-1):(0)
            visible: (PLATFORM==="DESKTOP")
            enabled: (PLATFORM==="DESKTOP")
            initialItem: PlaceholderPage {}

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

            replaceEnter: Transition{
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

            replaceExit: Transition{
                PropertyAnimation{
                    property: "opacity"
                    from: 1
                    to: 1
                    duration: 2*Constants.SHORT_DURATION
                }
            }

            function reset(){
                replace("qrc:/PlaceholderPage.qml");
            }

            function inConversation(){
                return (currentItem.toString().indexOf("ConversationPage")===0);
            }

            function startConversation(){
                replace("qrc:/ConversationPage.qml");
            }
        }
    }

    DropShadow {
        anchors.fill: frame
        horizontalOffset: horizontal_offset
        verticalOffset: vertical_offset
        radius: controller.pressed ? pressed_radius : normal_radius
        samples: elevation_margins
        source: frame
        color: Constants.DROPSHADOW_COLOR
        visible: (PLATFORM==="DESKTOP")
        enabled: (PLATFORM==="DESKTOP")
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































