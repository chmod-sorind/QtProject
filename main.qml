import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import Qt.labs.folderlistmodel 2.1
import QtQuick.Dialogs 1.2
import QtQuick.XmlListModel 2.0

ApplicationWindow {
    id: root
    minimumWidth: splitView.implicitWidth
    minimumHeight: splitView.implicitHeight
    visible: true
    width: 640
    height: 480
    x: 700
    y: 300
    title: "Photo Viewer"

    toolBar: ToolBar {
        id: topToolBar
        RowLayout {
            width: parent.width
            ToolButton {
                id: openSDCard
                iconSource: "icons/OpenSDCard.png"
                onClicked: fileDialog.open()
            }
            ToolButton {
                id: openInPhotoViewer
                iconSource: "icons/open_in_new_window.png"
                onClicked: root.color = "yellow"
            }
            TextField {
                id: searchField
                Layout.fillWidth: true
            }
            ToolButton {
                id: searchButton
                iconSource: "icons/search.png"
                onClicked: fileListModel.nameFilters = [searchField.text]
            }
        }
    }

    FileDialog {
        id: fileDialog
        folder: shortcuts.home
        title: "Please Select Source Folder..."
        selectFolder: true
        property string rootFolder: folder.toString().replace("file:///", "file:/")
        onAccepted: {
            fileListModel.folder = rootFolder
        }
    }

    FolderListModel {
        id: fileListModel
        showFiles: true
        showDirs: false
        nameFilters: [ "*.jpg", "*.jpeg", "*.png"]
        folder: fileDialog.shortcuts.pictures

    }

    SplitView {
        id: splitView
        anchors.fill: parent
        width: parent.width

        TableView {
            id: contentTable
            frameVisible: false

            TableViewColumn {
                title: "File Name"
                role: "fileName"
            }

//            TableViewColumn {
//                title: "File Size"
//                role: "fileSize"
//            }

            model: fileListModel
        }
        Image {
            id: image
            fillMode: Image.PreserveAspectFit
            source: fileListModel.get(contentTable.currentRow, "fileURL")
        }
    }

    statusBar: StatusBar {
        RowLayout {
            width: parent.width
            Label {
                id: lableStatusBar
                text:image.source
                Layout.fillWidth: true
                elide: Text.ElideMiddle
            }
            ProgressBar {
                value: image.progress
            }
        }
    }
}
