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
    }
}
