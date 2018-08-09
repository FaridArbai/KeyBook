import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants


Item {
    id: root
    opacity: 0;

    property int numItems;
    property real a :   0;

    property bool opened        :   false;
    property int menuWidth      :   root.width/2;
    property int menuHeight     :   root.numItems*(Constants.MENUITEM_HEIGHT_FACTOR)*root.pixelSize + 2*root.verticalPad;
    property int outterPad      :   root.width/64;

    property int pixelSize      :   (Constants.MENUITEM_PIXEL_FACTOR/Constants.MENU_HREF)*root.height;
    property int verticalPad    :   (Constants.MENU_VERTICALPAD_FACTOR)*root.pixelSize;

    property int itemHeight     :   (Constants.MENUITEM_HEIGHT_FACTOR)*root.pixelSize;
    property int itemWidth      :   root.menuWidth;
    property int itemVerticalPad    :   root.pixelSize/2;
    property int itemHorizontalPad  :   root.pixelSize;

    property int menuX  :   menu.x;
    property int menuY  :   menu.y + (root.verticalPad)*(root.a);

    function close(){
        console.log("closing");
        close_animation.start();
    }

    function open(){
        console.log("opening");
        open_animation.start();
    }


    SequentialAnimation{
        id: open_animation

        ParallelAnimation{
            PropertyAnimation{
                target: root
                property: "a"
                from: 0
                to: 1
            }

            PropertyAnimation{
                target: root
                property: "opacity"
                from: 0
                to: 1
            }
        }

        PropertyAction{
            target: root
            property: "opened"
            value: true
        }
    }

    SequentialAnimation{
        id: close_animation

        PropertyAction{
            target: root
            property: "opened"
            value: false
        }

        PropertyAnimation{
            target: root
            property: "opacity"
            from: 1
            to: 0
        }

        PropertyAction{
            target: root
            property: "a"
            value: 0
        }
    }


    Button{
        id: antifocus_button
        anchors.fill: parent
        background: Rectangle{color:"transparent"}
        enabled: root.opened

        onClicked:{
            root.close();
        }
    }

    Rectangle{
        id: menu
        width: (root.a)*root.menuWidth
        height: (root.a)*root.menuHeight
        radius: width/128;
        y: root.outterPad
        x: root.width - root.outterPad - width
        color: "white"
        layer.enabled: true
        layer.effect:CustomElevation{
            source: menu
        }

    }

}











































