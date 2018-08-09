import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

CustomButton{
    id: button
    animationDuration: Constants.VISIBLE_DURATION
    easingType: Easing.OutQuad
    width: itemWidth*a
    height: itemHeight*a


    property string name;
    property real a;


    property int pixelSize      :   (button.a)*button.itemPixelSize;
    property int itemPixelSize  :   (Constants.MENUITEM_PIXEL_FACTOR/Constants.MENU_HREF)*main.app_height;
    property int itemHeight     :   (Constants.MENUITEM_HEIGHT_FACTOR)*button.pixelSize;
    property int itemWidth      :   (main.app_width)/2;


    Label{
        anchors.top: parent.top
        anchors.topMargin: button.pixelSize
        anchors.left: parent.left
        anchors.leftMargin: button.pixelSize
        font.pixelSize: button.pixelSize
        text: name
        color: Constants.TextInput.TEXT_COLOR
    }
}
