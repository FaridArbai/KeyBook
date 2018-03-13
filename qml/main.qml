import QtQuick 2.6
import QtQuick.Controls 2.1

ApplicationWindow {
    id: window
    width: 450
    height: 600
    visible: true

    property alias main :   window
    property int toolbar_height :   height/10;

    Connections{
        target: main_frame

        onReceivedForeignContact:{
            main_frame.addForeignContact();
        }

        onReceivedNewMessage:{
            main_frame.refreshContactsGUI();
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: LogPage {}
    }

}
