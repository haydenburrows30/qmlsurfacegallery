import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import SurfaceGallery

Rectangle {
    id: imageSelector
    
    property string selectedImage: ":/resources/heightmap.png"
    property var imageList: [
        { name: "Default Terrain", path: ":/resources/heightmap.png", tooltip: "Use aspect ratio 3", maxZ: 2000, aspratio: 3 },
        { name: "Map", path: ":/resources/map.jpeg", tooltip: "Use aspect ratio 3", maxZ: 2000, aspratio: 3 },
        { name: "Test", path: ":/resources/test.png", tooltip: "Use aspect ratio 3", maxZ: 2000, aspratio: 3 },
        { name: "Mountain", path: ":/resources/mountain.jpeg", tooltip: "Use aspect ratio 20", maxZ: 1000, aspratio: 20 },
        { name: "Moon", path: ":/resources/MoonDEM.png", tooltip: "Use aspect ratio 50", maxZ: 1000, aspratio: 50},
        { name: "World", path: ":/resources/world.jpeg",tooltip: "Use aspect ratio 50, Max Z 1000", maxZ: 1000, aspratio: 50 },
        { name: "Great Lakes", path: ":/resources/great_lakes.jpg", tooltip: "Use aspect ratio 40+ Max Z 1000", maxZ: 1000, aspratio: 40 },
        { name: "Browse...", path: "browse" }
    ]
    property int maxFileSize: 100 * 1024 * 1024  // 100MB in bytes

    property real maxZ: imageSelector.imageList[imageCombo.currentIndex].maxZ
    property real aspRatio: imageSelector.imageList[imageCombo.currentIndex].aspratio
    
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

        ToolTip.visible: hovered
        ToolTip.text: imageSelector.imageList[currentIndex].tooltip
        ToolTip.delay: 500
        
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
