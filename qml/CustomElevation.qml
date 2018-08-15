import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Styles 1.4
import "Constants.js" as Constants

DropShadow{
    id: elevation
    width: source.width
    height: source.height
    horizontalOffset: 0
    verticalOffset: (5/3.5)*main.density
    radius: 2*verticalOffset
    samples: (2*radius+1)
    cached: true
    color: Constants.DROPSHADOW_COLOR
}
