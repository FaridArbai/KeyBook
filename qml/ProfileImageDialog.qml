import QtQuick 2.0
import QtQuick.Dialogs 1.2

FileDialog {

    id: profileimagedialog
    title: "Please choose a new profile image"
    folder: shortcuts.pictures

    onAccepted: {
        console.log("You chose: " + fileDialog.fileUrls)
        fileDialog.fileUrls
    }

    onRejected: {
        console.log("Canceled")
        root.StackView.view.pop()
    }

    Component.onCompleted: visible = true

}
