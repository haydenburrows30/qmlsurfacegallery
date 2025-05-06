import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import SurfaceGallery

Rectangle {
    id: imageSelector
    
    property string selectedImage: ":/resources/heightmap.png"
    property var imageList: [
        { name: "Default Terrain", path: ":/resources/heightmap.png" },
        { name: "Map", path: ":/resources/map.jpeg" },
        { name: "Test", path: ":/resources/test.png" },
        { name: "Mountain", path: ":/resources/mountain.jpeg" },
        { name: "Browse...", path: "browse" }
    ]
    property int maxFileSize: 10 * 1024 * 1024  // 10MB in bytes
    
    signal imageSelected(string imagePath)
    
    color: "transparent"
    
    DataSource {
        id: dataSource
        onFileError: function(message) {
            errorDialog.text = message;
            errorDialog.open();
        }
        onFileAccepted: function(path) {
            imageSelector.selectedImage = path;
            imageSelector.imageSelected(path);
            
            // Add to model if not already present
            var found = false;
            for (var i = 0; i < imageSelector.imageList.length; i++) {
                if (imageSelector.imageList[i].path === path) {
                    found = true;
                    break;
                }
            }
            
            if (!found && !path.startsWith(":/")) {
                var fileName = path.substring(path.lastIndexOf('/') + 1);
                if (fileName === "") fileName = path;
                
                var tempList = imageSelector.imageList.slice();
                tempList.splice(tempList.length - 1, 0, { name: fileName, path: path });
                imageSelector.imageList = tempList;
                imageCombo.currentIndex = tempList.length - 2;
            }
        }
    }
    
    FileDialog {
        id: fileDialog
        title: "Select Height Map Image"
        nameFilters: ["Image files (*.png *.jpg *.jpeg *.bmp *.tif *.tiff)"]
        onAccepted: {
            dataSource.checkAndProcessFile(selectedFile);
        }
    }
    
    Dialog {
        id: errorDialog
        title: "Error"
        modal: true
        standardButtons: Dialog.Ok
        
        property alias text: messageText.text
        
        Text {
            id: messageText
            color: "red"
            wrapMode: Text.WordWrap
        }
        
        anchors.centerIn: parent
    }
    
    ComboBox {
        id: imageCombo
        anchors.fill: parent
        
        model: imageSelector.imageList
        textRole: "name"
        
        onCurrentIndexChanged: {
            // Get the selected item
            var selectedItem = imageSelector.imageList[currentIndex];
            
            // Handle "Browse..." option
            if (selectedItem.path === "browse") {
                fileDialog.open();
                return;
            }
            
            // Update selectedImage property and emit imageSelected signal
            imageSelector.selectedImage = selectedItem.path;
            imageSelector.imageSelected(selectedItem.path);
        }
        
        // Initialize with the first item
        Component.onCompleted: {
            currentIndex = 0;
        }
    }
}
