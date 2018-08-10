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

    property int side_margin            :   (Constants.SIDE_FACTOR)*root.width;
    property int pad_buttons            :   (Constants.SPACING_FACTOR)*root.width;
    property int buttons_size           :   2*icons_size
    property int icons_size             :   (34/wref)*root.width;
    property int backicon_size          :   (3/4)*buttons_size;
    property int left_pad_headertext    :   (1/16)*root.width;

    property int avatar_container_width :   (165/724)*root.width;
    property int contact_height         :   (156/165)*avatar_container_width;
    property int avatar_right_pad       :   (1/6)*avatar_container_width;
    property int avatar_top_pad         :   (contact_height-avatar_image_size)/2;
    property int avatar_image_size      :   (2/3)*avatar_container_width;
    property int contactname_top_margin :   (1/3)*contact_height;
    property int lastmessage_top_margin :   (2/3)*contact_height;
    property int lastconnection_right_margin    :   avatar_right_pad;

    property int logo_pixelsize         :   icons_size;
    property int contactname_pixelsize  :   (30/wref)*root.width;
    property int lastmessage_pixelsize  :   (28/wref)*root.width;
    property int presence_pixelsize     :   (24/wref)*root.width;
    property int unread_pixelsize       :   (20/wref)*root.width;

    property int unread_container_pixelsize :   (5/4)*lastmessage_pixelsize;

    property string entered_username    :   "";
    property string entered_password    :   "";


    Connections{
        target: main_frame
        onLogOut:{
            wait_box.visible = false;
            root.StackView.view.pop();
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
        layer.enabled: true
        layer.effect: CustomElevation{
            source: toolbar
        }

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
            }

            onClicked:{
                action();
            }

            function action(){
                buttons_blocked = true;
                main_frame.logOutUser();
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

    ListView{
        id: contacts_view
        anchors.top: toolbar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        topMargin: 0
        leftMargin: 0
        bottomMargin: 0
        rightMargin: 0
        spacing: 0
        model: ContactModel
        enabled: !(buttons_blocked)

        delegate: ItemDelegate {
            width: root.width
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
                    root.StackView.view.push("qrc:/ConversationPage.qml")
                }

                onPressAndHold: {
                    main_frame.loadConversationWith(model.modelData.username_gui)
                    main_frame.refreshContactGUI(model.modelData.username_gui)
                    root.StackView.view.push("qrc:/ConversationPage.qml")
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
                                root.StackView.view.push("qrc:/ContactProfilePage.qml",
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
                color: Constants.ContactPage.CONTACTNAME_COLOR
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

    CustomButton{
        id: add_button
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: width/3
        anchors.rightMargin: width/3
        width: 0.1556*root.width
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
                    root.StackView.view.push("qrc:/ProfilePage.qml");
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
                    backbutton.action();
                    menu.close();
                }
            }
        }
    }

    function goBack(){
        backbutton.action();
    }

    Keys.onBackPressed:{
        if(searchbox.opened){
            searchbox.close();
        }
        else if(menu.opened){
            menu.close();
        }
        else if(addcontact_fragment.opened){
            addcontact_fragment.close();
        }
        else{
            root.goBack();
        }
    }



























}
