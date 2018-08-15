import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

Item{
    id: mask
    property string source  :   "icons/whitenokicon.png";
    property color color    :   "#FF0000";


    OpacityMask {
        anchors.fill: parent
        source: color_background
        maskSource: image_mask

        Image{
            id: image_mask
            anchors.fill: parent
            source: mask.source
            fillMode: Image.PreserveAspectFit
            visible: false
            mipmap: true
        }

        Rectangle{
            id: color_background
            anchors.fill: parent
            color: mask.color
            visible: false
        }

    }
}
