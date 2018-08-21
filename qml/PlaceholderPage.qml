import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

Page{
    id: root

    Rectangle{
        id: background
        anchors.fill: parent
        color: "#F8F9FB"
    }
    /**
    CustomMask{
        id: icon
        anchors.top: parent.top
        anchors.topMargin: (parent.height-height)/4
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        width: parent.height/4
        height: parent.height/4
        source: "icons/whitelogoicon.png"
        color: Constants.TextInput.TEXT_COLOR
    }**/

    Rectangle{
        id: icon_container
        anchors.top: parent.top
        anchors.topMargin: (parent.height-height)/4
        anchors.left: parent.left
        anchors.leftMargin: (parent.width-width)/2
        width: parent.height/2
        height: parent.height/2
        border.width: 1
        border.color: icon_background.color
        radius: width/2
        color: "white"

        layer.enabled: true
        layer.effect: OpacityMask{
            maskSource: Rectangle {
                width: icon_container.width
                height: icon_container.height
                radius: width/2
                color: "white"
            }
        }

        CustomMask{
            id: icon_background
            anchors.fill: parent
            source: "icons/network.png"
            color: "#F0F0F0"
        }

        Image{
            id: icon
            anchors.centerIn: parent
            width: parent.width/Math.sqrt(2)
            height: parent.height/Math.sqrt(2)
            fillMode: Image.PreserveAspectCrop
            source: "icons/devices.png"
        }
    }

    /**
    Rectangle{
        id: bottom_line
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 5
        color: Constants.TOOLBAR_COLOR
    }
    **/

}
