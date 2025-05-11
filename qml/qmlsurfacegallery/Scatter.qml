import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtDataVisualization

Item {
    id: mainView

    Data {
        id: seriesData
    }

    Theme3D {
        id: themeQt
        type: Theme3D.ThemeQt
        font.pointSize: 40
    }

    Theme3D {
        id: themeRetro
        type: Theme3D.ThemeRetro
    }

    RowLayout {
        id: buttonLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        uniformCellSizes: true

        Button {
            id: shadowToggle
            Layout.fillWidth: true

            text: scatterGraph.shadowsSupported ? "Hide Shadows" : "Shadows not supported"
            enabled: scatterGraph.shadowsSupported
            onClicked: {
                if (scatterGraph.shadowQuality === AbstractGraph3D.ShadowQualityNone) {
                    scatterGraph.shadowQuality = AbstractGraph3D.ShadowQualityHigh;
                    text = "Hide Shadows";
                } else {
                    scatterGraph.shadowQuality = AbstractGraph3D.ShadowQualityNone;
                    text = "Show Shadows";
                }
            }
        }

        Button {
            id: smoothToggle
            Layout.fillWidth: true

            text: "Use Smooth for Series One"
            onClicked: {
                if (!scatterSeries.meshSmooth) {
                    text = "Use Flat for Series One";
                    scatterSeries.meshSmooth = true;
                } else {
                    text = "Use Smooth for Series One";
                    scatterSeries.meshSmooth = false;
                }
            }
        }

        Button {
            id: cameraToggle
            Layout.fillWidth: true

            text: "Change Camera Placement"
            onClicked: {
                if (scatterGraph.scene.activeCamera.cameraPreset === Camera3D.CameraPresetFront) {
                    scatterGraph.scene.activeCamera.cameraPreset =
                            Camera3D.CameraPresetIsometricRightHigh;
                } else {
                    scatterGraph.scene.activeCamera.cameraPreset = Camera3D.CameraPresetFront;
                }
            }
        }

        Button {
            id: themeToggle
            Layout.fillWidth: true

            text: "Change Theme"
            onClicked: {
                if (scatterGraph.theme.type === Theme3D.ThemeRetro)
                    scatterGraph.theme = themeQt;
                else
                    scatterGraph.theme = themeRetro;
                if (scatterGraph.theme.backgroundEnabled)
                    backgroundToggle.text = "Hide Background";
                else
                    backgroundToggle.text = "Show Background";
            }
        }

        Button {
            id: backgroundToggle
            Layout.fillWidth: true

            text: "Hide Background"
            onClicked: {
                if (scatterGraph.theme.backgroundEnabled) {
                    scatterGraph.theme.backgroundEnabled = false;
                    text = "Show Background";
                } else {
                    scatterGraph.theme.backgroundEnabled = true;
                    text = "Hide Background";
                }
            }
        }
    }

    Item {
        id: dataView
        anchors.top: buttonLayout.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Scatter3D {
            id: scatterGraph
            anchors.fill: parent

            theme: themeQt
            shadowQuality: AbstractGraph3D.ShadowQualityHigh
            scene.activeCamera.cameraPreset: Camera3D.CameraPresetFront

            axisX.segmentCount: 3
            axisX.subSegmentCount: 2
            axisX.labelFormat: "%.2f"
            axisZ.segmentCount: 2
            axisZ.subSegmentCount: 2
            axisZ.labelFormat: "%.2f"
            axisY.segmentCount: 2
            axisY.subSegmentCount: 2
            axisY.labelFormat: "%.2f"

            Scatter3DSeries {
                id: scatterSeries
                itemLabelFormat: "Series 1: X:@xLabel Y:@yLabel Z:@zLabel"

                ItemModelScatterDataProxy {
                    itemModel: seriesData.model
                    xPosRole: "xPos"
                    yPosRole: "yPos"
                    zPosRole: "zPos"
                }
            }

            Scatter3DSeries {
                id: scatterSeriesTwo
                itemLabelFormat: "Series 2: X:@xLabel Y:@yLabel Z:@zLabel"
                itemSize: 0.05
                mesh: Abstract3DSeries.MeshCube

                ItemModelScatterDataProxy {
                    itemModel: seriesData.modelTwo
                    xPosRole: "xPos"
                    yPosRole: "yPos"
                    zPosRole: "zPos"
                }
            }
            Scatter3DSeries {
                id: scatterSeriesThree
                itemLabelFormat: "Series 3: X:@xLabel Y:@yLabel Z:@zLabel"
                itemSize: 0.1
                mesh: Abstract3DSeries.MeshMinimal

                ItemModelScatterDataProxy {
                    itemModel: seriesData.modelThree
                    xPosRole: "xPos"
                    yPosRole: "yPos"
                    zPosRole: "zPos"
                }
            }
        }
    }
}