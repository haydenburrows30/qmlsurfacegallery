import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtDataVisualization
import "."

Item {
    id: mainView

    GraphData {
        id: data
    }

    RowLayout {
        id: buttonLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        uniformCellSizes: true

        Button {
            Layout.fillWidth: true
            text: "Clear Selections"
            onClicked: clearSelections() // call a helper function to keep button itself simpler
        }

        Button {
            Layout.fillWidth: true
            text: "Reset Cameras"
            onClicked: resetCameras() // call a helper function to keep button itself simpler
        }

        Button {
            Layout.fillWidth: true
            text: "Toggle Mesh Styles"
            onClicked: toggleMeshStyle() // call a helper function to keep button itself simpler
        }
    }

    GridLayout {
        id: gridLayout
        columns: 2
        anchors.top: buttonLayout.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            border.color: surfaceGraph.theme.gridLineColor
            border.width: 2

            Surface3D {
                id: surfaceGraph
                anchors.fill: parent
                anchors.margins: parent.border.width
                theme: Theme3D {
                    type: Theme3D.ThemePrimaryColors
                    font.pointSize: 60
                }
                scene.activeCamera.cameraPreset: Camera3D.CameraPresetIsometricLeftHigh

                Surface3DSeries {
                    itemLabelFormat: "Pop density at (@xLabel N, @zLabel E): @yLabel"
                    ItemModelSurfaceDataProxy {
                        itemModel: data.sharedData
                        // The surface data points are not neatly lined up in rows and columns,
                        // so we define explicit row and column roles.
                        rowRole: "row"
                        columnRole: "col"
                        xPosRole: "latitude"
                        zPosRole: "longitude"
                        yPosRole: "pop_density"
                    }
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            border.color: scatterGraph.theme.gridLineColor
            border.width: 2

            Scatter3D {
                id: scatterGraph
                anchors.fill: parent
                anchors.margins: parent.border.width
                theme: Theme3D {
                    type: Theme3D.ThemeDigia
                    font.pointSize: 60
                }
                scene.activeCamera.cameraPreset: Camera3D.CameraPresetIsometricLeftHigh

                Scatter3DSeries {
                    itemLabelFormat: "Pop density at (@xLabel N, @zLabel E): @yLabel"
                    ItemModelScatterDataProxy {
                        itemModel: data.sharedData
                        // Mapping model roles to scatter series item coordinates.
                        xPosRole: "latitude"
                        zPosRole: "longitude"
                        yPosRole: "pop_density"
                    }
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            border.color: barGraph.theme.gridLineColor
            border.width: 2

            Bars3D {
                id: barGraph
                anchors.fill: parent
                anchors.margins: parent.border.width
                theme: Theme3D {
                    type: Theme3D.ThemeQt
                    font.pointSize: 60
                }
                selectionMode: AbstractGraph3D.SelectionItemAndRow | AbstractGraph3D.SelectionSlice
                scene.activeCamera.cameraPreset: Camera3D.CameraPresetIsometricLeftHigh

                Bar3DSeries {
                    itemLabelFormat: "@seriesName: @valueLabel"
                    name: "Population density"

                    ItemModelBarDataProxy {
                        itemModel: data.sharedData
                        // Mapping model roles to bar series rows, columns, and values.
                        rowRole: "row"
                        columnRole: "col"
                        valueRole: "pop_density"
                    }
                }
            }
        }
    }

    function clearSelections() {
        barGraph.clearSelection()
        scatterGraph.clearSelection()
        surfaceGraph.clearSelection()
    }

    function resetCameras() {
        surfaceGraph.scene.activeCamera.cameraPreset = Camera3D.CameraPresetIsometricLeftHigh
        scatterGraph.scene.activeCamera.cameraPreset = Camera3D.CameraPresetIsometricLeftHigh
        barGraph.scene.activeCamera.cameraPreset = Camera3D.CameraPresetIsometricLeftHigh
        surfaceGraph.scene.activeCamera.zoomLevel = 100.0
        scatterGraph.scene.activeCamera.zoomLevel = 100.0
        barGraph.scene.activeCamera.zoomLevel = 100.0
    }

    function toggleMeshStyle() {
        if (barGraph.seriesList[0].meshSmooth === true) {
            barGraph.seriesList[0].meshSmooth = false
            if (surfaceGraph.seriesList[0].flatShadingSupported)
                surfaceGraph.seriesList[0].flatShadingEnabled = true
            scatterGraph.seriesList[0].meshSmooth = false
        } else {
            barGraph.seriesList[0].meshSmooth = true
            surfaceGraph.seriesList[0].flatShadingEnabled = false
            scatterGraph.seriesList[0].meshSmooth = true
        }
    }
}