// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtDataVisualization
import QtQuick.Layouts

import SurfaceGallery

Item {
    id: oscilloscopeView

    property int sampleColumns: sampleSlider.value
    property int sampleRows: sampleColumns / 2
    property int sampleCache: 24
    property bool dataGenerating: false
    property bool lodEnabled: lodToggle.checked  // Level of Detail property

    onSampleRowsChanged: {
        surfaceSeries.selectedPoint = surfaceSeries.invalidSelectionPosition
        generateData()
    }

    DataSource {
        id: dataSource
        
        // Connect to the signals
        onDataReady: {
            oscilloscopeView.dataGenerating = false;
            statusText.text = "Data generation complete";
            progressBar.visible = false;
        }
        
        onDataProgress: function(percent) {
            progressBar.value = percent / 100.0;
        }
        
        // Set LOD enabled state
        Component.onCompleted: {
            dataSource.setLodEnabled(oscilloscopeView.lodEnabled);
        }
    }
    // Controls
    Rectangle {
        id: controlArea
        height: flatShadingToggle.implicitHeight * 2.5
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        color: surfaceGraph.theme.backgroundColor

        GridLayout {
            columns: 4
            anchors.fill: parent
            uniformCellWidths: true
            uniformCellHeights: true

            // Samples
            Rectangle {
                id: samples
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: surfaceGraph.theme.windowColor
                border.color: surfaceGraph.theme.gridLineColor
                border.width: 1
                radius: 4

                Row {
                    anchors.centerIn: parent
                    spacing: 10
                    padding: 5

                    Slider {
                        id: sampleSlider
                        from: oscilloscopeView.sampleCache * 2
                        to: from * 10
                        stepSize: oscilloscopeView.sampleCache

                        Component.onCompleted: value = from;
                    }

                    Text {
                        id: samplesText
                        text: "Samples: " + (oscilloscopeView.sampleRows * oscilloscopeView.sampleColumns)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: surfaceGraph.theme.labelTextColor
                    }
                }
            }

            // Frequency
            Rectangle {
                id: frequency
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: surfaceGraph.theme.windowColor
                border.color: surfaceGraph.theme.gridLineColor
                border.width: 1
                radius: 4

                Row {
                    anchors.centerIn: parent
                    spacing: 10
                    padding: 5

                    Slider {
                        id: frequencySlider
                        from: 2
                        to: 60
                        stepSize: 2
                        value: 30
                    }

                    Text {
                        id: frequencyText
                        text: "Freq: " + frequencySlider.value + " Hz"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: surfaceGraph.theme.labelTextColor
                    }
                }
            }

            // Level of Detail Toggle
            Rectangle {
                id: lodControl
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: surfaceGraph.theme.windowColor
                border.color: surfaceGraph.theme.gridLineColor
                border.width: 1
                radius: 4

                RowLayout {
                    anchors.centerIn: parent

                    Text {
                        text: "Level of Detail:"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: surfaceGraph.theme.labelTextColor
                    }

                    Switch {
                        id: lodToggle
                        checked: true
                        onCheckedChanged: {
                            dataSource.setLodEnabled(checked);
                            oscilloscopeView.lodEnabled = checked;
                        }
                    }
                }
            }

            // FPS
            Rectangle {
                id: fpsindicator
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: surfaceGraph.theme.windowColor
                border.color: surfaceGraph.theme.gridLineColor
                border.width: 1
                radius: 4

                Text {
                    id: fpsText
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: surfaceGraph.theme.labelTextColor
                }
            }

            // Selection
            Rectangle {
                id: selection
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: surfaceGraph.theme.windowColor
                border.color: surfaceGraph.theme.gridLineColor
                border.width: 1
                radius: 4

                Text {
                    id: selectionText
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: "No selection"
                    color: surfaceGraph.theme.labelTextColor
                }
            }

            // Cache control
            Button {
                id: cacheControl
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: "Clear\nCache"

                onClicked: dataSource.clearCache()

                contentItem: Text {
                    text: cacheControl.text
                    opacity: cacheControl.enabled ? 1.0 : 0.3
                    color: surfaceGraph.theme.labelTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    opacity: cacheControl.enabled ? 1 : 0.3
                    color: cacheControl.down ? surfaceGraph.theme.gridLineColor
                                            : surfaceGraph.theme.windowColor
                    border.color: cacheControl.down ? surfaceGraph.theme.labelTextColor
                                                : surfaceGraph.theme.gridLineColor
                    border.width: 1
                    radius: 2
                }
            }

            // Flat shading
            Button {
                id: flatShadingToggle
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: surfaceSeries.flatShadingSupported ? "Show\nSmooth" : "Flat\nnot supported"
                enabled: surfaceSeries.flatShadingSupported

                onClicked: {
                    if (surfaceSeries.flatShadingEnabled) {
                        surfaceSeries.flatShadingEnabled = false;
                        text = "Show\nFlat"
                    } else {
                        surfaceSeries.flatShadingEnabled = true;
                        text = "Show\nSmooth"
                    }
                }

                contentItem: Text {
                    text: flatShadingToggle.text
                    opacity: flatShadingToggle.enabled ? 1.0 : 0.3
                    color: surfaceGraph.theme.labelTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    opacity: flatShadingToggle.enabled ? 1 : 0.3
                    color: flatShadingToggle.down ? surfaceGraph.theme.gridLineColor
                                                : surfaceGraph.theme.windowColor
                    border.color: flatShadingToggle.down ? surfaceGraph.theme.labelTextColor
                                                        : surfaceGraph.theme.gridLineColor
                    border.width: 1
                    radius: 2
                }
            }

            // Surface grid
            Button {
                id: surfaceGridToggle
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: "Hide\nSurface Grid"

                onClicked: {
                    if (surfaceSeries.drawMode & Surface3DSeries.DrawWireframe) {
                        surfaceSeries.drawMode &= ~Surface3DSeries.DrawWireframe;
                        text = "Show\nSurface Grid";
                    } else {
                        surfaceSeries.drawMode |= Surface3DSeries.DrawWireframe;
                        text = "Hide\nSurface Grid";
                    }
                }

                contentItem: Text {
                    text: surfaceGridToggle.text
                    color: surfaceGraph.theme.labelTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    color: surfaceGridToggle.down ? surfaceGraph.theme.gridLineColor
                                                : surfaceGraph.theme.windowColor
                    border.color: surfaceGridToggle.down ? surfaceGraph.theme.labelTextColor
                                                        : surfaceGraph.theme.gridLineColor
                    border.width: 1
                    radius: 2
                }
            }
        }
    }

    Item {
        id: dataView
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height - controlArea.height

        // Status overlay with progress bar
        Rectangle {
            id: statusOverlay
            anchors.top: parent.top
            anchors.right: parent.right
            width: statusText.width + 20
            height: statusText.height + progressBar.height + 20
            color: "#80000000"
            visible: oscilloscopeView.dataGenerating
            radius: 5
            
            Text {
                id: statusText
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 10
                text: "Generating data..."
                color: "white"
                font.bold: true
            }
            
            ProgressBar {
                id: progressBar
                anchors.top: statusText.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 5
                width: statusText.width
                height: 10
                value: 0
            }
        }
        
        Surface3D {
            id: surfaceGraph
            anchors.fill: parent

            Surface3DSeries {
                id: surfaceSeries
                drawMode: Surface3DSeries.DrawSurfaceAndWireframe
                itemLabelFormat: "@xLabel, @zLabel: @yLabel"
                itemLabelVisible: false

                onItemLabelChanged: {
                    if (surfaceSeries.selectedPoint == surfaceSeries.invalidSelectionPosition)
                        selectionText.text = "No selection";
                    else
                        selectionText.text = surfaceSeries.itemLabel;
                }
            }

            shadowQuality: AbstractGraph3D.ShadowQualityNone
            selectionMode: AbstractGraph3D.SelectionSlice | AbstractGraph3D.SelectionItemAndColumn
            theme: Theme3D {
                type: Theme3D.ThemeIsabelle
                backgroundEnabled: false
            }
            scene.activeCamera.cameraPreset: Camera3D.CameraPresetFrontHigh

            axisX.labelFormat: "%d ms"
            axisY.labelFormat: "%d W"
            axisZ.labelFormat: "%d mV"
            axisX.min: 0
            axisY.min: 0
            axisZ.min: 0
            axisX.max: 1000
            axisY.max: 100
            axisZ.max: 800
            axisX.segmentCount: 4
            axisY.segmentCount: 4
            axisZ.segmentCount: 4
            measureFps: true
            renderingMode: AbstractGraph3D.RenderDirectToBackground

            // Cache property bindings to reduce evaluation
            property real currentFpsRounded: Math.round(currentFps * (currentFps > 10 ? 1 : 10)) / (currentFps > 10 ? 1 : 10)
            
            onCurrentFpsChanged: {
                fpsText.text = "FPS: " + currentFpsRounded;
            }

            Component.onCompleted: oscilloscopeView.generateData();
        }
    }

    function generateData() {
        oscilloscopeView.dataGenerating = true;
        statusText.text = "Generating data...";
        dataSource.generateData(oscilloscopeView.sampleCache, oscilloscopeView.sampleRows,
                                oscilloscopeView.sampleColumns,
                                surfaceGraph.axisX.min, surfaceGraph.axisX.max,
                                surfaceGraph.axisY.min, surfaceGraph.axisY.max,
                                surfaceGraph.axisZ.min, surfaceGraph.axisZ.max);
    }

    Timer {
        id: refreshTimer
        interval: 1000 / frequencySlider.value
        running: !oscilloscopeView.dataGenerating
        repeat: true
        onTriggered: dataSource.update(surfaceSeries);
    }
}
