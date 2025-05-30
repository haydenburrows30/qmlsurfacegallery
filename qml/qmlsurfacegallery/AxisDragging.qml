// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtDataVisualization

Item {
    id: axisDragView

    property int selectedAxisLabel: -1
    property real dragSpeedModifier: 100.0
    property int currentMouseX: -1
    property int currentMouseY: -1
    property int previousMouseX: -1
    property int previousMouseY: -1

    ListModel {
        id: graphModel
        ListElement{ xPos: 0.0; yPos: 0.0; zPos: 0.0; rotation: "@0,0,0,0" }
        ListElement{ xPos: 1.0; yPos: 1.0; zPos: 1.0; rotation: "@45,1,1,1" }
    }

    Timer {
        id: dataTimer
        interval: 1
        running: true
        repeat: true
        property bool isIncreasing: true
        property real rotationAngle: 0

        function generateQuaternion() {
            return "@" + Math.random() * 360 + "," + Math.random() + ","
                    + Math.random() + "," + Math.random();
        }

        function appendRow() {
            graphModel.append({"xPos": Math.random(),
                                  "yPos": Math.random(),
                                  "zPos": Math.random(),
                                  "rotation": generateQuaternion()
                              });
        }

        //! [10]
        onTriggered: {
            rotationAngle = rotationAngle + 1;
            qtCube.setRotationAxisAndAngle(Qt.vector3d(1, 0, 1), rotationAngle);
            //! [10]
            scatterSeries.setMeshAxisAndAngle(Qt.vector3d(1, 1, 1), rotationAngle);
            if (isIncreasing) {
                for (var i = 0; i < 10; i++)
                    appendRow();
                if (graphModel.count > 2002) {
                    scatterGraph.theme = isabelleTheme;
                    isIncreasing = false;
                }
            } else {
                graphModel.remove(2, 10);
                if (graphModel.count === 2) {
                    scatterGraph.theme = dynamicColorTheme;
                    isIncreasing = true;
                }
            }
        }
    }

    ThemeColor {
        id: dynamicColor
        ColorAnimation on color {
            from: "red"
            to: "yellow"
            duration: 2000
            loops: Animation.Infinite
        }
    }

    RowLayout {
        id: buttonLayout
        uniformCellSizes: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        Button {
            id: rangeToggle
            text: "Use Preset Range"
            Layout.fillWidth: true

            property bool autoRange: true
            onClicked: {
                if (autoRange) {
                    text = "Use Automatic Range";
                    scatterGraph.axisX.min = 0.3;
                    scatterGraph.axisX.max = 0.7;
                    scatterGraph.axisY.min = 0.3;
                    scatterGraph.axisY.max = 0.7;
                    scatterGraph.axisZ.min = 0.3;
                    scatterGraph.axisZ.max = 0.7;
                    autoRange = false;
                    dragSpeedModifier = 200.0;
                } else {
                    text = "Use Preset Range";
                    autoRange = true;
                    dragSpeedModifier = 100.0;
                }
                scatterGraph.axisX.autoAdjustRange = autoRange;
                scatterGraph.axisY.autoAdjustRange = autoRange;
                scatterGraph.axisZ.autoAdjustRange = autoRange;
            }
        }

        Button {
            id: orthoToggle
            text: "Display Orthographic"
            Layout.fillWidth: true

            onClicked: {
                if (scatterGraph.orthoProjection) {
                    text = "Display Orthographic";
                    scatterGraph.orthoProjection = false;
                    // Orthographic projection disables shadows, so we need to switch them back on
                    scatterGraph.shadowQuality = AbstractGraph3D.ShadowQualityMedium
                } else {
                    text = "Display Perspective";
                    scatterGraph.orthoProjection = true;
                }
            }
        }
    }

    Theme3D {
        id: dynamicColorTheme
        type: Theme3D.ThemeEbony
        baseColors: [dynamicColor]
        font.pointSize: 50
        labelBorderEnabled: true
        labelBackgroundColor: "gold"
        labelTextColor: "black"
    }

    Theme3D {
        id: isabelleTheme
        type: Theme3D.ThemeIsabelle
        font.pointSize: 50
        labelBorderEnabled: true
        labelBackgroundColor: "gold"
        labelTextColor: "black"
    }

    Scatter3D {
        id: scatterGraph

        anchors.top: buttonLayout.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        theme: dynamicColorTheme
        shadowQuality: AbstractGraph3D.ShadowQualityMedium
        scene.activeCamera.yRotation: 45.0
        scene.activeCamera.xRotation: 45.0
        scene.activeCamera.zoomLevel: 75.0

        Scatter3DSeries {
            id: scatterSeries
            itemLabelFormat: "X:@xLabel Y:@yLabel Z:@zLabel"
            mesh: Abstract3DSeries.MeshCube

            ItemModelScatterDataProxy {
                itemModel: graphModel
                xPosRole: "xPos"
                yPosRole: "yPos"
                zPosRole: "zPos"
                rotationRole: "rotation"
            }
        }

        customItemList: [
            Custom3DItem {
                id: qtCube
                meshFile: ":/resources/cube.obj"
                textureFile: ":resources/cubetexture.png"
                position: Qt.vector3d(0.65, 0.35, 0.65)
                scaling: Qt.vector3d(0.3, 0.3, 0.3)
            }
        ]

        onSelectedElementChanged: {
            if (selectedElement >= AbstractGraph3D.ElementAxisXLabel
                    && selectedElement <= AbstractGraph3D.ElementAxisZLabel) {
                selectedAxisLabel = selectedElement;
            } else {
                selectedAxisLabel = -1;
            }
        }
    }

    MouseArea {
        anchors.fill: scatterGraph
        hoverEnabled: true

        onPositionChanged: (mouse)=> {
                            currentMouseX = mouse.x;
                            currentMouseY = mouse.y;

                            if (pressed && selectedAxisLabel != -1)
                                axisDragView.dragAxis();

                            previousMouseX = currentMouseX;
                            previousMouseY = currentMouseY;
                        }

        onPressed: (mouse)=> {
                    scatterGraph.scene.selectionQueryPosition = Qt.point(mouse.x, mouse.y);
                }

        onReleased: {
            // We need to clear mouse positions and selected axis, because touch devices cannot
            // track position all the time
            selectedAxisLabel = -1;
            currentMouseX = -1;
            currentMouseY = -1;
            previousMouseX = -1;
            previousMouseY = -1;
        }

        onWheel: (wheel)=> {
                // Adjust zoom level based on what zoom range we're in.
                var zoomLevel = scatterGraph.scene.activeCamera.zoomLevel;
                if (zoomLevel > 100)
                    zoomLevel += wheel.angleDelta.y / 12.0;
                else if (zoomLevel > 50)
                    zoomLevel += wheel.angleDelta.y / 60.0;
                else
                    zoomLevel += wheel.angleDelta.y / 120.0;
                if (zoomLevel > 500)
                    zoomLevel = 500;
                else if (zoomLevel < 10)
                    zoomLevel = 10;

                scatterGraph.scene.activeCamera.zoomLevel = zoomLevel;
            }
    }

    function dragAxis() {
        // Do nothing if previous mouse position is uninitialized
        if (previousMouseX === -1)
            return;

        // Directional drag multipliers based on rotation. Camera is locked to 45 degrees, so we
        // can use one precalculated value instead of calculating xx, xy, zx and zy individually
        var cameraMultiplier = 0.70710678;

        // Calculate the mouse move amount
        var moveX = currentMouseX - previousMouseX;
        var moveY = currentMouseY - previousMouseY;

        // Adjust axes
        switch (selectedAxisLabel) {
        case AbstractGraph3D.ElementAxisXLabel:
            var distance = ((moveX - moveY) * cameraMultiplier) / dragSpeedModifier;
            // Check if we need to change min or max first to avoid invalid ranges
            if (distance > 0) {
                scatterGraph.axisX.min -= distance;
                scatterGraph.axisX.max -= distance;
            } else {
                scatterGraph.axisX.max -= distance;
                scatterGraph.axisX.min -= distance;
            }
            break;
        case AbstractGraph3D.ElementAxisYLabel:
            distance = moveY / dragSpeedModifier;
            // Check if we need to change min or max first to avoid invalid ranges
            if (distance > 0) {
                scatterGraph.axisY.max += distance;
                scatterGraph.axisY.min += distance;
            } else {
                scatterGraph.axisY.min += distance;
                scatterGraph.axisY.max += distance;
            }
            break;
        case AbstractGraph3D.ElementAxisZLabel:
            distance = ((moveX + moveY) * cameraMultiplier) / dragSpeedModifier;
            // Check if we need to change min or max first to avoid invalid ranges
            if (distance > 0) {
                scatterGraph.axisZ.max += distance;
                scatterGraph.axisZ.min += distance;
            } else {
                scatterGraph.axisZ.min += distance;
                scatterGraph.axisZ.max += distance;
            }
            break;
        }
    }
}