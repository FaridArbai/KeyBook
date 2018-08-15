import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

Rectangle{
    width: (PLATFORM==="ANDROID")?(7*(main.density/3.5)):(2)
    height: pixelSize
    color: Constants.VIBRANT_COLOR

    property int pixelSize;

    SequentialAnimation on opacity{
        running: true
        loops: Animation.Infinite

        PropertyAction{
            value: 0
        }

        PauseAnimation {
            duration: 500
        }

        PropertyAction{
            value: 1
        }

        PauseAnimation {
            duration: 500
        }
    }
}
