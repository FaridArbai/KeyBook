import QtQuick 2.6
import QtQuick.Controls 2.1

ApplicationWindow {
    id: window
    width: 450
    height: 600
    visible: true

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: LogPage {}
    }

}
