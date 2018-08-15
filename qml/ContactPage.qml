import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import "Constants.js" as Constants
import QtQuick.Dialogs 1.2

Page{
    id: root

    property var statusbar_color    :   Constants.CONTACTS_STATUSBAR_COLOR;

    property bool buttons_blocked : false;

    property int href   :   1135;
    property int wref   :   720;

    property int swipebar_height        :   (96/href)*main.app_height;
    property int swipebar_pixelsize     :   (22/href)*main.app_height;
    property int swipeline_height       :   (7/href)*main.app_height;

    property int side_margin            :   (Constants.SIDE_FACTOR)*main.app_width;
    property int pad_buttons            :   (Constants.SPACING_FACTOR)*main.app_width;
    property int buttons_size           :   2*icons_size
    property int icons_size             :   (34/wref)*main.app_width;
    property int backicon_size          :   (3/4)*buttons_size;
    property int left_pad_headertext    :   (1/16)*main.app_width;

    property int avatar_container_width :   (165/724)*main.app_width;
    property int contact_height         :   (156/165)*avatar_container_width;
    property int avatar_right_pad       :   (1/6)*avatar_container_width;
    property int avatar_top_pad         :   (contact_height-avatar_image_size)/2;
    property int avatar_image_size      :   (2/3)*avatar_container_width;
    property int contactname_top_margin :   (1/3)*contact_height;
    property int lastmessage_top_margin :   (2/3)*contact_height;
    property int lastconnection_right_margin    :   avatar_right_pad;

    property int logo_pixelsize         :   icons_size;
    property int contactname_pixelsize  :   (30/wref)*main.app_width;
    property int lastmessage_pixelsize  :   (28/wref)*main.app_width;
    property int presence_pixelsize     :   (24/wref)*main.app_width;
    property int unread_pixelsize       :   (20/wref)*main.app_width;

    property int unread_container_pixelsize :   (5/4)*lastmessage_pixelsize;

    property string entered_username    :   "";
    property string entered_password    :   "";

    property alias progressDialog : progress_dialog;

    CustomProgressDialog{
        id: progress_dialog
        anchors.fill: parent
        statusbarColor: main.decToColor(root.statusbar_color)
        maxZ: 10001
    }


    Connections{
        target: main_frame
        onLogOut:{
            wait_box.visible = false;
            if(PLATFORM==="DESKTOP"){
                main.conversationStackView.reset();
                main.mainStackView.pop();
            }
            else{
                main.mainStackView.pop();
            }
        }

        onWaitingForTooLong:{
            if(buttons_blocked==true){
                wait_box.visible = true;
            }
        }

        onReceivedRequestedContact:{
            main_frame.addRequestedContact(entered_username, entered_password);
        }

        onFinishedAddingContact:{
            buttons_blocked = false;
            var str;

            if(add_result==true){
                str = entered_username + " has been added succesfully";
            }
            else{
                str = err_msg;
            }

            console.log(str);

            addcontact_fragment.notifyResult(add_result, str);
        }

        onVkeyboardClosed:{
            if(searchbox.opened){
                searchbox.close();
            }
        }
    }

    AddContactFragment{
        id: addcontact_fragment
        anchors.fill: parent
        statusbar_color: main.decToColor(root.statusbar_color);

        onDone:{
            entered_username = addcontact_fragment.enteredUsername;
            entered_password = addcontact_fragment.enteredPassword;
            main_frame.addContact(entered_username);
            buttons_blocked = true;
        }
    }

    Rectangle {
        id: toolbar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: main.toolbar_height
        color: Constants.TOOLBAR_COLOR
        z: contacts_view.z + 1

        CustomButton {
            id: backbutton
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: side_margin
            anchors.topMargin: (parent.height-height)/2
            height: buttons_size
            width: buttons_size
            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR;
            circular: true
            visible: false
            enabled: false

            Image {
                id: backicon
                anchors.centerIn: parent
                height: icons_size
                width:  icons_size
                source: "icons/whitebackicon.png"
                mipmap: true
            }

            onClicked:{
                action();
            }

            function action(){
                if(searchbox.opened){
                    searchbox.close();
                }
                else if(menu.opened){
                    menu.close();
                }
                else if(addcontact_fragment.opened){
                    addcontact_fragment.close();
                }
                else if(searchbox.opened){
                    searchbox.close();
                }
                else{
                    main_frame.logOutUser();
                }
            }
        }

        Text{
            id: logo_text
            anchors.top: parent.top
            anchors.topMargin: (parent.height-logo_pixelsize)/2
            anchors.left: backbutton.left
            anchors.leftMargin: 0
            font.bold: false
            font.pixelSize: logo_pixelsize
            color: "white"
            text: "KeyBook"
        }

        CustomButton{
            id: options_button
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: side_margin
            anchors.topMargin: (parent.height-height)/2
            height: buttons_size
            width: buttons_size
            enabled: !(buttons_blocked)
            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR;
            circular: true

            Image {
                id: profileicon
                anchors.centerIn: parent
                source: "icons/whiteoptionsicon.png"
                height: icons_size
                width: icons_size
                mipmap: true
            }

            onClicked: {
                menu.open();
            }

        }

        CustomButton {
            id: search_button
            anchors.top: parent.top
            anchors.right: options_button.left
            anchors.rightMargin: pad_buttons
            anchors.topMargin: (parent.height-height)/2
            enabled: !(buttons_blocked)
            height: buttons_size
            width: buttons_size
            animationColor: Constants.Button.LIGHT_ANIMATION_COLOR;
            circular: true

            Image {
                id: plusicon
                source: "icons/whitesearchicon.png"
                anchors.centerIn: parent
                height: icons_size
                width: icons_size
                mipmap: true
            }

            onClicked:{
                searchbox.open();
            }
        }


        Rectangle{
            id: searchbox
            x: search_button.x*(1-a) + a*(logo_text.x + logo_text.width + side_margin);
            y: (parent.height - height)/2
            width: buttons_size*(1-a) + a*(options_button.x - logo_text.x - logo_text.width - side_margin)
            height: buttons_size
            radius: height/2;
            color: "white"
            clip: true
            opacity: a
            enabled: (searchbox.opened)

            Label{
                id: search_hint
                anchors.left: search_text.left
                anchors.top: search_text.top
                leftPadding: search_text.leftPadding
                topPadding: search_text.topPadding
                font.pixelSize: logo_pixelsize
                text: "Type name"
                color: Constants.TextInput.HINT_COLOR
                visible: (search_text.text.length==0)
            }

            TextInput{
                id: search_text
                anchors.left: parent.left
                leftPadding: searchbox.radius
                anchors.top: parent.top
                topPadding: (parent.height - logo_pixelsize)/2
                width: parent.width - searchbox.radius
                height: parent.height

                font.pixelSize: logo_pixelsize
                color: Constants.TextInput.TEXT_COLOR
                cursorDelegate: CustomCursor{
                    pixelSize: logo_pixelsize
                }

                onTextChanged:{
                    main_frame.refreshContactsGUI(search_text.text);
                    main_frame.refreshConversationsGUI(search_text.text);
                }

                onActiveFocusChanged: {
                    if(!activeFocus){
                        searchbox.close();
                    }
                }
            }

            property real a: 0;
            property bool opened : (a>0.99);

            function open(){
                open_animation.start();
                search_text.forceActiveFocus();
            }

            function close(){
                main_frame.refreshContactsGUI();
                main_frame.refreshConversationsGUI();
                close_animation.start();
            }

            PropertyAnimation{
                target: searchbox
                property: "a"
                id: open_animation
                from: 0
                to: 1
            }

            PropertyAnimation{
                target: searchbox
                property: "a"
                id: close_animation
                from: 1
                to: 0
            }
        }
    }


    Rectangle{
        id: swipebar
        anchors.top: toolbar.bottom
        anchors.topMargin: -(logo_text.y/2)
        anchors.left: parent.left
        anchors.right: parent.right
        height: swipebar_height
        z: contacts_view.z + 1
        color: Constants.TOOLBAR_COLOR
        layer.enabled: true
        layer.effect: CustomElevation{
            source: swipebar
        }

        CustomButton{
            id: conversations_button
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width/2
            height: parent.height
            asynchronous: true
            animationDuration: 250

            Label{
                id: conversations_label
                anchors.left: parent.left
                anchors.leftMargin: (parent.width-width)/2
                anchors.top: parent.top
                anchors.topMargin: (parent.height - swipebar_pixelsize)/2
                text: "CONVERSATIONS"
                font.pixelSize: swipebar_pixelsize
                font.bold: true
                color: swipe_view.currentIndex===0 ? "white" : Constants.GENERAL_TEXT_WHITE
            }

            onClicked:{
                swipe_view.currentIndex = 0;
            }
        }

        CustomButton{
            id: contacts_button
            anchors.right: parent.right
            anchors.top: parent.top
            width: parent.width/2
            height: parent.height
            asynchronous: true
            animationDuration: 250

            Label{
                id: contacts_label
                anchors.left: parent.left
                anchors.leftMargin: (parent.width-width)/2
                anchors.top: parent.top
                anchors.topMargin: (parent.height - swipebar_pixelsize)/2
                text: "CONTACTS"
                font.pixelSize: swipebar_pixelsize
                font.bold: true
                color: swipe_view.currentIndex === 1 ? "white" : Constants.GENERAL_TEXT_WHITE
            }

            onClicked:{
                swipe_view.currentIndex = 1;
            }
        }

        Rectangle{
            id: swipeline
            anchors.bottom: parent.bottom
            height: swipeline_height
            width: parent.width/2
            x: 0

            function slide(){
                if(swipe_view.currentIndex===0){
                    swipe_left.start();
                }
                else{
                    swipe_right.start();
                }
            }

            PropertyAnimation{
                id: swipe_right
                target: swipeline
                property: "x"
                from: 0
                to: swipeline.width
                duration: 200
            }

            PropertyAnimation{
                id: swipe_left
                target: swipeline
                property: "x"
                from: swipeline.width
                to: 0
                duration: 200
            }
        }

    }

    SwipeView{
        id: swipe_view
        anchors.top: swipebar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        currentIndex: 0

        onCurrentIndexChanged: {
            swipeline.slide();
        }

        ListView{
            id: conversation_view
            topMargin: 0
            leftMargin: 0
            bottomMargin: 0
            rightMargin: 0
            spacing: 0
            model: ConversationsContactModel
            enabled: !(buttons_blocked)

            delegate: ItemDelegate {
                width: main.app_width
                height: contact_height
                background: Rectangle{color: "transparent"}

                CustomButton{
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    animationDuration: Constants.VISIBLE_DURATION;
                    easingType: Easing.OutQuad

                    onClicked: {
                        main_frame.loadConversationWith(model.modelData.username_gui)
                        main_frame.refreshContactGUI(model.modelData.username_gui)
                        if(PLATFORM==="DESKTOP"){
                            main.conversationStackView.startConversation();
                        }
                        else{
                            main.mainStackView.push("qrc:/ConversationPage.qml")
                        }
                    }

                    onPressAndHold: {
                        main_frame.loadConversationWith(model.modelData.username_gui)
                        main_frame.refreshContactGUI(model.modelData.username_gui)
                        if(PLATFORM==="DESKTOP"){
                            main.conversationStackView.startConversation();
                        }
                        else{
                            main.mainStackView.push("qrc:/ConversationPage.qml")
                        }
                    }
                }

                Rectangle{
                    id: avatar_button
                    anchors.top: parent.top
                    anchors.left: parent.left
                    height: contact_height
                    width: avatar_container_width
                    color: "transparent"
                    enabled: !(buttons_blocked)

                    Rectangle{
                        anchors.fill: parent
                        color: "transparent"

                        Image {
                            id: avatar
                            anchors.top: parent.top
                            anchors.topMargin: avatar_top_pad
                            anchors.left: parent.left
                            anchors.leftMargin: avatar_right_pad
                            height: avatar_image_size
                            width: avatar_image_size
                            source: model.modelData.avatar_path_gui
                            fillMode: Image.PreserveAspectCrop
                            mipmap: true
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: mask
                            }

                            CustomButton{
                                anchors.fill: parent
                                circular: true
                                animationColor: "#FFFFFF"

                                onClicked: {
                                    main_frame.refreshContactGUI(model.modelData.username_gui)
                                    main.mainStackView.push("qrc:/ContactProfilePage.qml",
                                                             {previous_page : "ContactPage"});
                                }
                            }
                        }

                        Rectangle {
                            id: mask
                            height: avatar.height
                            width: avatar.width
                            radius: (avatar.height/2)
                            visible: false
                        }
                    }
                }

                Label{
                    id: contactname_label
                    anchors.left: avatar_button.right
                    anchors.top: parent.top
                    anchors.topMargin: contactname_top_margin-height/2
                    text: model.modelData.username_gui
                    font.bold: true
                    font.pixelSize: contactname_pixelsize
                    color: Constants.TOOLBAR_COLOR
                }

                Label{
                    id: presencetext
                    anchors.right: parent.right
                    anchors.rightMargin: avatar_right_pad
                    anchors.top: parent.top
                    anchors.topMargin: contactname_label.anchors.topMargin+(contactname_label.font.pixelSize-font.pixelSize)
                    text: model.modelData.shortpresence_gui
                    font.pixelSize: presence_pixelsize
                    color: Constants.ContactPage.PRESENCE_COLOR
                }

                Label{
                    id: lastmessagetext
                    anchors.left: avatar_button.right
                    anchors.top:  parent.top
                    anchors.topMargin: lastmessage_top_margin-height/2
                    text: reliable ? ( model.modelData.last_message_gui ): "Update contact's latchkey"
                    font.pixelSize: lastmessage_pixelsize
                    width: (unread_container.x - x - font.pixelSize)
                    elide: Text.ElideRight
                    font.bold: reliable ? unread_label.has_unread_message : true
                    color: reliable ? Constants.ContactPage.LASTMESSAGE_COLOR : Constants.ConversationPage.ERROR_MESSAGE_BACKGROUND;

                    property bool reliable : model.modelData.last_message_reliability;
                }

                Rectangle{
                    id: unread_container
                    anchors.right: parent.right
                    anchors.rightMargin: avatar_right_pad
                    anchors.top: lastmessagetext.top
                    anchors.topMargin: (lastmessagetext.height-height)/2
                    height: unread_container_pixelsize
                    width: unread_container_pixelsize
                    radius: width/2
                    color: Constants.ContactPage.UNREAD_CONTAINER_COLOR
                    visible: unread_label.has_unread_message

                    Label{
                        id: unread_label
                        anchors.centerIn: parent
                        rightPadding: 0
                        leftPadding: 0
                        topPadding: 0
                        bottomPadding: 0
                        font.bold: false
                        font.pixelSize: unread_pixelsize
                        text: model.modelData.unread_messages_gui
                        color: Constants.ContactPage.UNREAD_TEXT_COLOR

                        property int surrounding_size       :   Math.max(height,width);
                        property bool has_unread_message    :   (text!="0");
                    }
                }

                Rectangle{
                    id: separator
                    anchors.bottom: parent.bottom
                    anchors.left: avatar_button.right
                    anchors.right: parent.right
                    anchors.rightMargin: avatar_right_pad
                    height: 1
                    color: "#DDDDDD"
                }

            }
        }

        ListView{
            id: contacts_view
            topMargin: 0
            leftMargin: 0
            bottomMargin: 0
            rightMargin: 0
            spacing: 0
            model: ContactsContactModel
            enabled: !(buttons_blocked)

            delegate: ItemDelegate {
                width: main.app_width
                height: contact_height
                background: Rectangle{color: "transparent"}

                CustomButton{
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    animationDuration: Constants.VISIBLE_DURATION;
                    easingType: Easing.OutQuad

                    onClicked: {
                        main_frame.loadConversationWith(model.modelData.username_gui)
                        main_frame.refreshContactGUI(model.modelData.username_gui)
                        if(PLATFORM==="DESKTOP"){
                            main.conversationStackView.startConversation();
                        }
                        else{
                            main.mainStackView.push("qrc:/ConversationPage.qml")
                        }
                    }

                    onPressAndHold: {
                        main_frame.loadConversationWith(model.modelData.username_gui)
                        main_frame.refreshContactGUI(model.modelData.username_gui)
                        if(PLATFORM==="DESKTOP"){
                            main.conversationStackView.startConversation();
                        }
                        else{
                            main.mainStackView.push("qrc:/ConversationPage.qml")
                        }
                    }
                }

                Rectangle{
                    id: avatar_button2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    height: contact_height
                    width: avatar_container_width
                    color: "transparent"
                    enabled: !(buttons_blocked)

                    Rectangle{
                        anchors.fill: parent
                        color: "transparent"

                        Image {
                            id: avatar2
                            anchors.top: parent.top
                            anchors.topMargin: avatar_top_pad
                            anchors.left: parent.left
                            anchors.leftMargin: avatar_right_pad
                            height: avatar_image_size
                            width: avatar_image_size
                            source: model.modelData.avatar_path_gui
                            fillMode: Image.PreserveAspectCrop
                            mipmap: true
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: mask2
                            }

                            CustomButton{
                                anchors.fill: parent
                                circular: true
                                animationColor: "#FFFFFF"

                                onClicked: {
                                    main_frame.refreshContactGUI(model.modelData.username_gui)
                                    main.mainStackView.push("qrc:/ContactProfilePage.qml",
                                                             {previous_page : "ContactPage"});
                                }
                            }
                        }

                        Rectangle {
                            id: mask2
                            height: avatar2.height
                            width: avatar2.width
                            radius: (avatar2.height/2)
                            visible: false
                        }
                    }
                }

                Label{
                    id: contactname_label2
                    anchors.left: avatar_button2.right
                    anchors.top: parent.top
                    anchors.topMargin: contactname_top_margin-height/2
                    text: model.modelData.username_gui
                    font.bold: true
                    font.pixelSize: contactname_pixelsize
                    color: Constants.ContactPage.CONTACTNAME_COLOR
                }

                Label{
                    id: presencetext2
                    anchors.right: parent.right
                    anchors.rightMargin: avatar_right_pad
                    anchors.top: parent.top
                    anchors.topMargin: contactname_label2.anchors.topMargin+(contactname_label2.font.pixelSize-font.pixelSize)
                    text: model.modelData.shortpresence_gui
                    font.pixelSize: presence_pixelsize
                    color: Constants.ContactPage.PRESENCE_COLOR
                }

                Label{
                    id: lastmessagetext2
                    anchors.left: avatar_button2.right
                    anchors.top:  parent.top
                    anchors.topMargin: lastmessage_top_margin-height/2
                    text: model.modelData.status_gui
                    font.pixelSize: lastmessage_pixelsize
                    width: (parent.width - x - avatar_right_pad)
                    elide: Text.ElideRight
                    color: Constants.ContactPage.LASTMESSAGE_COLOR

                    property bool reliable : model.modelData.last_message_reliability;
                }

                Rectangle{
                    id: separator2
                    anchors.bottom: parent.bottom
                    anchors.left: avatar_button2.right
                    anchors.right: parent.right
                    anchors.rightMargin: avatar_right_pad
                    height: 1
                    color: "#DDDDDD"
                }

            }
        }
    }


    CustomButton{
        id: add_button
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: width/3
        anchors.rightMargin: width/3
        width: 0.1556*main.app_width
        height: width
        circular: true
        clip: true
        animationColor: Constants.Button.LIGHT_ANIMATION_COLOR
        layer.enabled: true
        layer.effect: CustomElevation{
            verticalOffset: 10
        }


        Rectangle{
            anchors.fill: parent
            radius: width
            color: Constants.VIBRANT_COLOR
            z: -1
        }

        Image{
            anchors.centerIn: parent
            height: 0.5*parent.height/Math.sqrt(2);
            width: 0.5*parent.width /Math.sqrt(2);
            source: "icons/whiteaddcontacticon.png"
            fillMode: Image.PreserveAspectFit
            opacity: 0.9
        }

        onClicked:{
            addcontact_fragment.open();
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

    CustomMenu{
        id: menu
        numItems: 4
        anchors.fill: parent
        z: 2000

        Column{
            spacing: 0
            x: menu.menuX;
            y: menu.menuY;

            CustomMenuItem{
                name: "Profile"
                a: menu.a

                onClicked: {
                    main.mainStackView.push("qrc:/ProfilePage.qml");
                    menu.close();
                }
            }

            CustomMenuItem{
                name: "Add contact"
                a: menu.a

                onClicked: {
                    addcontact_fragment.open();
                    menu.close();
                }
            }

            CustomMenuItem{
                name: "About"
                a: menu.a

                onClicked: {
                    menu.close();
                }
            }

            CustomMenuItem{
                name: "Log Out"
                a: menu.a

                onClicked: {
                    if(searchbox.opened){
                        searchbox.close();
                    }
                    menu.close();
                    backbutton.action();
                }
            }
        }
    }

    function goBack(){
        backbutton.action();
    }

    Keys.onBackPressed:{
        root.goBack();
    }



























}
