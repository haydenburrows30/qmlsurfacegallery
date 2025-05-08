// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtDataVisualization

Rectangle {
    id: heightMapView
    color: surfacePlot.theme.windowColor

    property string currentHeightMapFile: ":/resources/heightmap.png"
    property string statusMessage: ""
    property bool loading: false

    property real maxX: 2000
    property real maxY: 2000
    property real maxZ: 2000
    property real aspectRatioSlider : 3.0

    property string color0: 'aliceblue'
    property string color1: 'antiquewhite'
    property string color2: 'aqua'
    property string color3: 'aquamarine'
    property string color4: 'azure'
    property string color5: 'beige'
    property string color6: 'bisque'
    property string color7: 'black'
    property string color8: 'blanchedalmond'
    property string color9: 'blue'
    property string color10: 'blueviolet'

    property var surfaceColor: [
        'aliceblue',
        'antiquewhite',
        'aqua',
        'aquamarine',
        'azure',
        'beige',
        'bisque',
        'black',
        'blanchedalmond',
        'blue',
        'blueviolet',
        'brown',
        'burlywood',
        'cadetblue',
        'chartreuse',
        'chocolate',
        'coral',
        'cornflowerblue',
        'cornsilk',
        'crimson',
        'cyan',
        'darkblue',
        'darkcyan',
        'darkgoldenrod',
        'darkgray',
        'darkgreen',
        'darkgrey',
        'darkkhaki',
        'darkmagenta',
        'darkolivegreen',
        'darkorange',
        'darkorchid',
        'darkred',
        'darksalmon',
        'darkseagreen',
        'darkslateblue',
        'darkslategray',
        'darkslategrey',
        'darkturquoise',
        'darkviolet',
        'deeppink',
        'deepskyblue',
        'dimgray',
        'dimgrey',
        'dodgerblue',
        'firebrick',
        'floralwhite',
        'forestgreen',
        'fuchsia',
        'gainsboro',
        'ghostwhite',
        'gold',
        'goldenrod',
        'gray',
        'grey',
        'green',
        'greenyellow',
        'honeydew',
        'hotpink',
        'indianred',
        'indigo',
        'ivory',
        'khaki',
        'lavender',
        'lavenderblush',
        'lawngreen',
        'lemonchiffon',
        'lightblue',
        'lightcoral',
        'lightcyan',
        'lightgoldenrodyellow',
        'lightgray',
        'lightgreen',
        'lightgrey',
        'lightpink',
        'lightsalmon',
        'lightseagreen',
        'lightskyblue',
        'lightslategray',
        'lightslategrey',
        'lightsteelblue',
        'lightyellow',
        'lime',
        'limegreen',
        'linen',
        'magenta',
        'maroon',
        'mediumaquamarine',
        'mediumblue',
        'mediumorchid',
        'mediumpurple',
        'mediumseagreen',
        'mediumslateblue',
        'mediumspringgreen',
        'mediumturquoise',
        'mediumvioletred',
        'midnightblue',
        'mintcream',
        'mistyrose',
        'moccasin',
        'navajowhite',
        'navy',
        'oldlace',
        'olive',
        'olivedrab',
        'orange',
        'orangered',
        'orchid',
        'palegoldenrod',
        'palegreen',
        'paleturquoise',
        'palevioletred',
        'papayawhip',
        'peachpuff',
        'peru',
        'pink',
        'plum',
        'powderblue',
        'purple',
        'red',
        'rosybrown',
        'royalblue',
        'saddlebrown',
        'salmon',
        'sandybrown',
        'seagreen',
        'seashell',
        'sienna',
        'silver',
        'skyblue',
        'slateblue',
        'slategray',
        'slategrey',
        'snow',
        'springgreen',
        'steelblue',
        'tan',
        'teal',
        'thistle',
        'tomato',
        'turquoise',
        'violet',
        'wheat',
        'white',
        'whitesmoke',
        'yellow',
        'yellowgreen'
    ]

    property var colorColor: {
        "aliceblue": "#f0f8ff",
        "antiquewhite": "#faebd7",
        "aqua": "#00ffff",
        "aquamarine": "#7fffd4",
        "azure": "#f0ffff",
        "beige": "#f5f5dc",
        "bisque": "#ffe4c4",
        "black": "#000000",
        "blanchedalmond": "#ffebcd",
        "blue": "#0000ff",
        "blueviolet": "#8a2be2",
        "brown": "#a52a2a",
        "burlywood": "#deb887",
        "cadetblue": "#5f9ea0",
        "chartreuse": "#7fff00",
        "chocolate": "#d2691e",
        "coral": "#ff7f50",
        "cornflowerblue": "#6495ed",
        "cornsilk": "#fff8dc",
        "crimson": "#dc143c",
        "cyan": "#00ffff",
        "darkblue": "#00008b",
        "darkcyan": "#008b8b",
        "darkgoldenrod": "#b8860b",
        "darkgray": "#a9a9a9",
        "darkgreen": "#006400",
        "darkgrey": "#a9a9a9",
        "darkkhaki": "#bdb76b",
        "darkmagenta": "#8b008b",
        "darkolivegreen": "#556b2f",
        "darkorange": "#ff8c00",
        "darkorchid": "#9932cc",
        "darkred": "#8b0000",
        "darksalmon": "#e9967a",
        "darkseagreen": "#8fbc8f",
        "darkslateblue": "#483d8b",
        "darkslategray": "#2f4f4f",
        "darkslategrey": "#2f4f4f",
        "darkturquoise": "#00ced1",
        "darkviolet": "#9400d3",
        "deeppink": "#ff1493",
        "deepskyblue": "#00bfff",
        "dimgray": "#696969",
        "dimgrey": "#696969",
        "dodgerblue": "#1e90ff",
        "firebrick": "#b22222",
        "floralwhite": "#fffaf0",
        "forestgreen": "#228b22",
        "fuchsia": "#ff00ff",
        "gainsboro": "#dcdcdc",
        "ghostwhite": "#f8f8ff",
        "gold": "#ffd700",
        "goldenrod": "#daa520",
        "gray": "#808080",
        "grey": "#808080",
        "green": "#008000",
        "greenyellow": "#adff2f",
        "honeydew": "#f0fff0",
        "hotpink": "#ff69b4",
        "indianred": "#cd5c5c",
        "indigo": "#4b0082",
        "ivory": "#fffff0",
        "khaki": "#f0e68c",
        "lavender": "#e6e6fa",
        "lavenderblush": "#fff0f5",
        "lawngreen": "#7cfc00",
        "lemonchiffon": "#fffacd",
        "lightblue": "#add8e6",
        "lightcoral": "#f08080",
        "lightcyan": "#e0ffff",
        "lightgoldenrodyellow": "#fafad2",
        "lightgray": "#d3d3d3",
        "lightgreen": "#90ee90",
        "lightgrey": "#d3d3d3",
        "lightpink": "#ffb6c1",
        "lightsalmon": "#ffa07a",
        "lightseagreen": "#20b2aa",
        "lightskyblue": "#87cefa",
        "lightslategray": "#778899",
        "lightslategrey": "#778899",
        "lightsteelblue": "#b0c4de",
        "lightyellow": "#ffffe0",
        "lime": "#00ff00",
        "limegreen": "#32cd32",
        "linen": "#faf0e6",
        "magenta": "#ff00ff",
        "maroon": "#800000",
        "mediumaquamarine": "#66cdaa",
        "mediumblue": "#0000cd",
        "mediumorchid": "#ba55d3",
        "mediumpurple": "#9370db",
        "mediumseagreen": "#3cb371",
        "mediumslateblue": "#7b68ee",
        "mediumspringgreen": "#00fa9a",
        "mediumturquoise": "#48d1cc",
        "mediumvioletred": "#c71585",
        "midnightblue": "#191970",
        "mintcream": "#f5fffa",
        "mistyrose": "#ffe4e1",
        "moccasin": "#ffe4b5",
        "navajowhite": "#ffdead",
        "navy": "#000080",
        "oldlace": "#fdf5e6",
        "olive": "#808000",
        "olivedrab": "#6b8e23",
        "orange": "#ffa500",
        "orangered": "#ff4500",
        "orchid": "#da70d6",
        "palegoldenrod": "#eee8aa",
        "palegreen": "#98fb98",
        "paleturquoise": "#afeeee",
        "palevioletred": "#db7093",
        "papayawhip": "#ffefd5",
        "peachpuff": "#ffdab9",
        "peru": "#cd853f",
        "pink": "#ffc0cb",
        "plum": "#dda0dd",
        "powderblue": "#b0e0e6",
        "purple": "#800080",
        "rebeccapurple": "#663399",
        "red": "#ff0000",
        "rosybrown": "#bc8f8f",
        "royalblue": "#4169e1",
        "saddlebrown": "#8b4513",
        "salmon": "#fa8072",
        "sandybrown": "#f4a460",
        "seagreen": "#2e8b57",
        "seashell": "#fff5ee",
        "sienna": "#a0522d",
        "silver": "#c0c0c0",
        "skyblue": "#87ceeb",
        "slateblue": "#6a5acd",
        "slategray": "#708090",
        "slategrey": "#708090",
        "snow": "#fffafa",
        "springgreen": "#00ff7f",
        "steelblue": "#4682b4",
        "tan": "#d2b48c",
        "teal": "#008080",
        "thistle": "#d8bfd8",
        "tomato": "#ff6347",
        "turquoise": "#40e0d0",
        "violet": "#ee82ee",
        "wheat": "#f5deb3",
        "white": "#ffffff",
        "whitesmoke": "#f5f5f5",
        "yellow": "#ffff00",
        "yellowgreen": "#9acd32"
    }

    // Buttons
    ColumnLayout {
        id: buttons
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        opacity: 0.7

        // Image selection
        RowLayout{
            Layout.fillWidth: true
            Layout.minimumHeight: 50

            Label {
                id: imageLabel
                text: "Height Map:"
                Layout.minimumWidth: 100
                color: surfacePlot.theme.labelTextColor
            }

            ImageSelector {
                Layout.fillWidth: true
                Layout.fillHeight: true

                onImageSelected: function(imagePath) {
                    loadHeightMap(imagePath);
                }
            }

            // Reload image
            Button {
                id: reloadButton
                text: "Reload"
                Layout.minimumWidth: 80
                Layout.fillHeight: true
                
                onClicked: {
                    // Force reload current heightmap
                    var currentFile = heightMapView.currentHeightMapFile;
                    heightMapProxy.heightMapFile = "";
                    Qt.callLater(function() {
                        loadHeightMap(currentFile);
                    });
                }
            }
        }

        // Controls
        RowLayout {
            Layout.fillWidth: true

            // Visuals
            GroupBox {
                id: groupBox3
                title: "Draw Mode:"
                Layout.minimumWidth: 300
                Layout.minimumHeight: groupBox1.height
                Layout.alignment: Qt.AlignTop

                label: Label {
                    text: groupBox3.title
                    color: surfacePlot.theme.labelTextColor
                    elide: Text.ElideRight
                }

                ColumnLayout {
                    anchors.fill: parent

                    // Draw mode
                    RowLayout {
                        Layout.fillWidth: true
                        uniformCellSizes: true

                        ComboBox {
                            id: drawComboBox
                            Layout.alignment: Qt.AlignTop
                            model: ["Surface","Wireframe","Both"]
                            Layout.fillWidth: true

                            currentIndex: 0

                            onCurrentTextChanged: {
                                if (currentText === "Surface") {
                                    heightSeries.drawMode = Surface3DSeries.DrawSurface
                                } else if (currentText === "Wireframe") {
                                    heightSeries.drawMode = Surface3DSeries.DrawWireframe
                                } else heightSeries.drawMode = Surface3DSeries.DrawSurfaceAndWireframe
                            }

                        }

                        // Wireframe color
                        Button {
                            id: surfaceGridColor
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            text: "Grid Color"
                            enabled: heightSeries.drawMode == Surface3DSeries.DrawWireframe | heightSeries.drawMode == Surface3DSeries.DrawSurfaceAndWireframe

                            onClicked: {
                                if (Qt.colorEqual(heightSeries.wireframeColor, "#000000")) {
                                    heightSeries.wireframeColor = "red";
                                    text = "Black";
                                } else {
                                    heightSeries.wireframeColor = "black";
                                    text = "Red";
                                }
                            }

                            ToolTip.text: "Enabled when surface is wireframe or both"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500
                        }
                    }

                    // FPS
                    RowLayout {
                        Layout.fillWidth: true
                        uniformCellSizes: true

                        Label {
                            text: "FPS: " + surfacePlot.currentFps.toFixed(0)
                            color: surfacePlot.theme.labelTextColor
                            Layout.fillWidth: true
                        }

                        SwitchDelegate {
                            id: fps
                            Layout.fillWidth: true

                            checked: false

                            ToolTip.text: "FPS - off or continuous"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500

                            onToggled: { 
                                if (surfacePlot.measureFps == false) {
                                    surfacePlot.measureFps = true

                                } else {
                                    surfacePlot.measureFps = false
                                }
                            }
                        }
                    }

                    // orthoProjection
                    RowLayout {
                        Layout.fillWidth: true
                        uniformCellSizes: true

                        Label {
                            text: "Ortho Projection:"
                            color: surfacePlot.theme.labelTextColor
                            Layout.fillWidth: true
                        }

                        SwitchDelegate {
                            id: ortho
                            Layout.fillWidth: true

                            checked: false

                            ToolTip.text: "orthoProjection - off or on"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500

                            onToggled: { 
                                if (surfacePlot.orthoProjection == false) {
                                    surfacePlot.orthoProjection = true

                                } else {
                                    surfacePlot.orthoProjection = false
                                }
                            }
                        }

                    }

                    // MSAA
                    RowLayout {
                        Layout.minimumWidth: 250
                        Label {
                            text: "MSAA"
                            color: surfacePlot.theme.labelTextColor
                        }

                        TextField {
                            id: msaaSlider
                            text: "4"
                            onTextChanged: surfacePlot.msaaSamples = parseFloat(text)

                            ToolTip.text: "The maximum X value for the generated surface points. Defaults to 2000."
                            ToolTip.visible: hovered
                            ToolTip.delay: 500


                        }
                        // Slider {
                            
                        // }

                        // Label {
                        //     text: msaaSlider.value
                        //     color: surfacePlot.theme.labelTextColor
                        // }
                    }
                }
            }

            // Options
            GroupBox {
                id: groupBox1
                title: "Options:"
                Layout.minimumWidth: 300
                Layout.alignment: Qt.AlignTop

                label: Label {
                    text: groupBox1.title
                    color: surfacePlot.theme.labelTextColor
                    elide: Text.ElideRight
                }

                ColumnLayout {
                    anchors.fill: parent

                    // Shading
                    RowLayout {
                        Layout.minimumWidth: 250

                        Label {
                            text: "Shading"
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 100
                        }

                        SwitchDelegate {
                            id: flatShadingToggle
                            enabled: heightSeries.flatShadingSupported
                            Layout.fillWidth: true

                            checked: true

                            ToolTip.text: "Shading - flat or smooth"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500

                            onToggled: { 
                                if (heightSeries.flatShadingEnabled) {
                                    heightSeries.flatShadingEnabled = false;
                                    shadSwitchLabel.text = "Smooth"
                                } else {
                                    heightSeries.flatShadingEnabled = true;
                                    shadSwitchLabel.text = "Flat"
                                }
                            }
                        }

                        Label {
                            id: shadSwitchLabel
                            text: heightSeries.flatShadingSupported ? "Smooth" : "Flat shading not\nsupported"
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 60
                        }
                    }

                    // Background
                    RowLayout {
                        Layout.minimumWidth: 250
                        Label {
                            text: "Background"
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 100
                        }
                        SwitchDelegate {
                            id: backgroundToggle
                            Layout.fillWidth: true

                            checked: true

                            ToolTip.text: "Background - on or off"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500

                            onToggled: {
                                if (surfacePlot.theme.backgroundEnabled) {
                                    surfacePlot.theme.backgroundEnabled = false;
                                    backSwitchLabel.text = "Off";
                                } else {
                                    surfacePlot.theme.backgroundEnabled = true;
                                    backSwitchLabel.text = "On";
                                }
                            }

                        }

                        Label {
                            id: backSwitchLabel
                            text: "On"
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 60
                        }
                    }

                    // Grid
                    RowLayout {
                        Layout.minimumWidth: 250
                        Label {
                            text: "Grid"
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 100
                        }
                        SwitchDelegate {
                            id: gridToggle
                            Layout.fillWidth: true

                            ToolTip.text: "Grid - on or off"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500

                            checked: true

                            onToggled: {
                                if (surfacePlot.theme.gridEnabled) {
                                    surfacePlot.theme.gridEnabled = false;
                                    gridSwitchLabel.text = "Off";
                                } else {
                                    surfacePlot.theme.gridEnabled = true;
                                    gridSwitchLabel.text = "On";
                                }
                            }

                        }

                        Label {
                            id: gridSwitchLabel
                            text: "On"
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 60
                        }
                    }

                    // quality
                    RowLayout {
                        Layout.minimumWidth: 250
                        Label {
                            text: "Quality"
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 100
                        }
                        SwitchDelegate {
                            id: shadowQualityButtons
                            Layout.fillWidth: true

                            ToolTip.text: "Shadow quality - low or high"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500

                            checked: true

                            onToggled: {
                                if (surfacePlot.shadowQuality == AbstractGraph3D.ShadowQualityLow) {
                                    surfacePlot.shadowQuality = AbstractGraph3D.ShadowQualityHigh;
                                    qualitySwitchLabel.text = "Low";
                                } else {
                                    surfacePlot.shadowQuality = AbstractGraph3D.ShadowQualityLow;
                                    qualitySwitchLabel.text = "High";
                                }
                            }

                        }

                        Label {
                            id: qualitySwitchLabel
                            text: "High"
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 60
                        }
                    }
                }
            }

            // Sliders XYZ
            GroupBox {
                id: groupBox2
                title: "XYZ:"
                Layout.minimumHeight: groupBox1.height
                Layout.minimumWidth: 300
                Layout.alignment: Qt.AlignTop

                ToolTip.text: "Since height maps do not contain values for X or Z axes" +
                ", these values need to be given separately using the minXValue, maxXValue, " +
                "minZValue, and maxZValue properties. The X-value corresponds to the image's horizontal direction," +
                " and the Z-value to the vertical. Setting any of these properties triggers an "+
                "asynchronous re-resolution of any existing height map."

                ToolTip.visible: hovered
                ToolTip.delay: 500

                label: Label {
                    text: groupBox2.title
                    color: surfacePlot.theme.labelTextColor
                    elide: Text.ElideRight
                }

                ColumnLayout {
                    anchors.fill: parent

                    // X slider
                    RowLayout {
                        Layout.minimumWidth: 250
                        Label {
                            text: "Max X"
                            color: surfacePlot.theme.labelTextColor
                        }
                        Slider {
                            id: xSlider
                            from: 1
                            to: 2000
                            stepSize: 1
                            value: maxX
                            onMoved: maxX = value

                            ToolTip.text: "The maximum X value for the generated surface points. Defaults to 2000."
                            ToolTip.visible: hovered
                            ToolTip.delay: 500
                        }

                        Label {
                            text: xSlider.value
                            color: surfacePlot.theme.labelTextColor
                        }
                    }

                    // Y slider
                    RowLayout {
                        Layout.minimumWidth: 250
                        Label {
                            text: "Max Y"
                            color: surfacePlot.theme.labelTextColor
                        }
                        Slider {
                            id: ySlider
                            from: 1
                            to: 2000
                            stepSize: 1
                            value: maxY
                            onMoved: maxY = value

                            ToolTip.text: "The maximum Y value for the generated surface points. Defaults to 2000."
                            ToolTip.visible: hovered
                            ToolTip.delay: 500
                        }

                        Label {
                            text: ySlider.value
                            color: surfacePlot.theme.labelTextColor
                        }
                    }

                    // Z slider
                    RowLayout {
                        Layout.minimumWidth: 250
                        Label {
                            text: "Max Z"
                            color: surfacePlot.theme.labelTextColor
                        }
                        Slider {
                            id: zSlider
                            from: 1
                            to: 2000
                            stepSize: 1
                            value: maxZ
                            onMoved: maxZ = value

                            ToolTip.text: "The maximum Z value for the generated surface points. Defaults to 2000."
                            ToolTip.visible: hovered
                            ToolTip.delay: 500
                        }

                        Label {
                            text: zSlider.value
                            color: surfacePlot.theme.labelTextColor
                        }
                    }

                    // Aspect ratio slider
                    RowLayout {
                        Layout.minimumWidth: 250
                        Label {
                            text: "Asp Ratio"
                            color: surfacePlot.theme.labelTextColor
                        }
                        Slider {
                            id: aspectSlider
                            from: 1
                            to: 5
                            stepSize: 1
                            value: aspectRatioSlider

                            onMoved: aspectRatioSlider = value

                            ToolTip.text: "The ratio of the graph scaling between the longest axis on the horizontal plane and the y-axis. Defaults to 3.0."
                            ToolTip.visible: hovered
                            ToolTip.delay: 500
                        }

                        Label {
                            text: aspectSlider.value
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 60
                        }
                    }
                }
            }

            // Colors
            GroupBox {
                id: groupBox4
                title: "Colors:"
                Layout.minimumWidth: 350
                Layout.minimumHeight: groupBox1.height

                label: Label {
                    text: groupBox4.title
                    color: surfacePlot.theme.labelTextColor
                    elide: Text.ElideRight
                }

                ColumnLayout {
                    anchors.fill: parent

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: "%"
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 60
                        }
                        Label {
                            text: "Name"
                            Layout.fillWidth: true 
                            color: surfacePlot.theme.labelTextColor
                        }
                        Label {
                            text: "Color"
                            Layout.fillWidth: true
                            color: surfacePlot.theme.labelTextColor
                        }

                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: "0.0"
                            Layout.minimumWidth: 60
                            color: surfacePlot.theme.labelTextColor
                        }

                        ComboBox {
                            id: colorBox0
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 0
                            onCurrentTextChanged: {
                                chosenColor0.color = currentText
                                color0 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor0
                            Layout.alignment: Qt.AlignTop
                            color: color0
                            Layout.minimumHeight: colorBox0.height
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: "0.1"; 
                            Layout.minimumWidth: 60
                            color: surfacePlot.theme.labelTextColor
                            }

                        ComboBox {
                            id: colorBox1
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 1
                            onCurrentTextChanged: {
                                chosenColor1.color = currentText
                                color1 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor1
                            Layout.alignment: Qt.AlignTop
                            color: color1
                            Layout.minimumHeight: colorBox1.height
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: "0.3"; 
                            Layout.minimumWidth: 60
                            color: surfacePlot.theme.labelTextColor

                        }

                        ComboBox {
                            id: colorBox2
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 2
                            onCurrentTextChanged: {
                                chosenColor2.color = currentText
                                color2 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor2
                            Layout.alignment: Qt.AlignTop
                            color: "pink"
                            Layout.minimumHeight: colorBox2.height
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: "0.4"; 
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 60
                            }

                        ComboBox {
                            id: colorBox3
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 3
                            onCurrentTextChanged: {
                                chosenColor3.color = currentText
                                color3 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor3
                            Layout.alignment: Qt.AlignTop
                            color: "pink"
                            Layout.minimumHeight: colorBox3.height
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: "0.5"
                            Layout.minimumWidth: 60
                            color: surfacePlot.theme.labelTextColor
                        }

                        ComboBox {
                            id: colorBox4
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 4
                            onCurrentTextChanged: {
                                chosenColor4.color = currentText
                                color4 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor4
                            Layout.alignment: Qt.AlignTop
                            color: "pink"
                            Layout.minimumHeight: colorBox4.height
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: "0.6"
                            Layout.minimumWidth: 60
                            color: surfacePlot.theme.labelTextColor
                        }

                        ComboBox {
                            id: colorBox5
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 5
                            onCurrentTextChanged: {
                                chosenColor5.color = currentText
                                color5 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor5
                            Layout.alignment: Qt.AlignTop
                            color: "pink"
                            Layout.minimumHeight: colorBox5.height
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: "0.6"
                            color: surfacePlot.theme.labelTextColor
                            Layout.minimumWidth: 60
                        }

                        ComboBox {
                            id: colorBox6
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 6
                            onCurrentTextChanged: {
                                chosenColor6.color = currentText
                                color6 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor6
                            Layout.alignment: Qt.AlignTop
                            color: "pink"
                            Layout.minimumHeight: colorBox6.height
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: "0.7"
                            Layout.minimumWidth: 60
                            color: surfacePlot.theme.labelTextColor
                        }

                        ComboBox {
                            id: colorBox7
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 7
                            onCurrentTextChanged: {
                                chosenColor7.color = currentText
                                color7 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor7
                            Layout.alignment: Qt.AlignTop
                            color: "pink"
                            Layout.minimumHeight: colorBox7.height
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: "0.8"
                            Layout.minimumWidth: 60
                            color: surfacePlot.theme.labelTextColor
                        }

                        ComboBox {
                            id: colorBox8
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 8
                            onCurrentTextChanged: {
                                chosenColor8.color = currentText
                                color8 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor8
                            Layout.alignment: Qt.AlignTop
                            color: "pink"
                            Layout.minimumHeight: colorBox8.height
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: "0.9"
                            Layout.minimumWidth: 60
                            color: surfacePlot.theme.labelTextColor}

                        ComboBox {
                            id: colorBox9
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 9
                            onCurrentTextChanged: {
                                chosenColor9.color = currentText
                                color9 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor9
                            Layout.alignment: Qt.AlignTop
                            color: "pink"
                            Layout.minimumHeight: colorBox9.height
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: "1.0"
                            Layout.minimumWidth: 60
                            color: surfacePlot.theme.labelTextColor
                        }

                        ComboBox {
                            id: colorBox10
                            Layout.alignment: Qt.AlignTop
                            model: surfaceColor

                            currentIndex: 10
                            onCurrentTextChanged: {
                                chosenColor10.color = currentText
                                color10 = currentText
                            }
                        }

                        Rectangle {
                            id: chosenColor10
                            Layout.alignment: Qt.AlignTop
                            color: "pink"
                            Layout.minimumHeight: colorBox10.height
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // Surface3D
            GroupBox {
                id: groupBox5
                title: "Test:"
                Layout.minimumWidth: 300
                Layout.minimumHeight: groupBox1.height
                Layout.alignment: Qt.AlignTop

                label: Label {
                    text: groupBox5.title
                    color: surfacePlot.theme.labelTextColor
                    elide: Text.ElideRight
                }

                ColumnLayout {
                    anchors.fill: parent

                    Label {
                        text: "Row Count: " + heightMapProxy.rowCount
                        color: surfacePlot.theme.labelTextColor
                        Layout.alignment: Qt.AlignTop
                    }

                    Label {
                        text: "Column Count: " + heightMapProxy.columnCount
                        color: surfacePlot.theme.labelTextColor
                        Layout.alignment: Qt.AlignTop
                    }

                    Label {
                        text: "Series: " + heightMapProxy.series
                        color: surfacePlot.theme.labelTextColor
                        Layout.alignment: Qt.AlignTop
                    }

                    Label {
                        text: "Type: " + heightMapProxy.type
                        color: surfacePlot.theme.labelTextColor
                        Layout.alignment: Qt.AlignTop
                    }

                    Label {
                        text: "Max X: " + heightMapProxy.maxXValue + "Max Y: " + heightMapProxy.maxYValue + "Max Z: " + heightMapProxy.maxZValue
                        color: surfacePlot.theme.labelTextColor
                        Layout.alignment: Qt.AlignTop
                    }

                    Label {
                        text: "File: " + heightMapProxy.heightMapFile
                        color: surfacePlot.theme.labelTextColor
                        Layout.alignment: Qt.AlignTop
                    }

                    Label {
                        text: "Autoscale Y: " + heightMapProxy.autoScaleY
                        color: surfacePlot.theme.labelTextColor
                        Layout.alignment: Qt.AlignTop
                    }

                    Label {
                        text: "Shadow supported: " + surfacePlot.shadowsSupported
                        color: surfacePlot.theme.labelTextColor
                        Layout.alignment: Qt.AlignTop
                    }

                    Label {
                        text: "MSAA samples: " + surfacePlot.msaaSamples
                        color: surfacePlot.theme.labelTextColor
                        Layout.alignment: Qt.AlignTop
                    }


                }
            }
        }
    }

    // 3D Surface
    Item {
        id: surfaceView
        anchors.top: buttons.bottom
        anchors.bottom: heightMapView.bottom
        anchors.left: heightMapView.left
        anchors.right: heightMapView.right

        ColorGradient {
            id: surfaceGradient
            ColorGradientStop { position: 0.0; color: color0 }
            ColorGradientStop { position: 0.1; color: color1 }
            ColorGradientStop { position: 0.2; color: color2 }
            ColorGradientStop { position: 0.3; color: color3 }
            ColorGradientStop { position: 0.4; color: color4 }
            ColorGradientStop { position: 0.5; color: color5 }
            ColorGradientStop { position: 0.6; color: color6 }
            ColorGradientStop { position: 0.7; color: color7 }
            ColorGradientStop { position: 0.8; color: color8 }
            ColorGradientStop { position: 0.9; color: color9 }
            ColorGradientStop { position: 1.0; color: color10 }
        }

        Surface3D {
            id: surfacePlot
            width: surfaceView.width
            height: surfaceView.height
            aspectRatio: aspectRatioSlider
            reflection: false
            measureFps: false
            orthoProjection: false
            msaaSamples: 8

            theme: Theme3D {
                type: Theme3D.ThemeStoneMoss
                font.family: "STCaiyun"
                font.pointSize: 35
                colorStyle: Theme3D.ColorStyleRangeGradient
                baseGradients: [surfaceGradient] // Use the custom gradient
            }

            shadowQuality: AbstractGraph3D.ShadowQualityLow
            selectionMode: AbstractGraph3D.SelectionSlice | AbstractGraph3D.SelectionItemAndRow
            scene.activeCamera.cameraPreset: Camera3D.CameraPresetIsometricLeft
            axisX.segmentCount: 10
            axisX.subSegmentCount: 2
            axisX.labelFormat: "%i"
            axisZ.segmentCount: 10
            axisZ.subSegmentCount: 2
            axisZ.labelFormat: "%i"
            axisY.segmentCount: 5
            axisY.subSegmentCount: 2
            axisY.labelFormat: "%i"
            axisY.title: "y"
            axisX.title: "x"
            axisZ.title: "z"
            axisY.titleVisible: true
            axisX.titleVisible: true
            axisZ.titleVisible: true

            Surface3DSeries {
                id: heightSeries
                flatShadingEnabled: false
                drawMode: Surface3DSeries.DrawSurface

                HeightMapSurfaceDataProxy {
                    id: heightMapProxy
                    heightMapFile: heightMapView.currentHeightMapFile
                    autoScaleY: true

                    minXValue: 0
                    maxXValue: maxX
                    minYValue: 0
                    maxYValue: maxY
                    minZValue: 0
                    maxZValue: maxZ
                    

                    onHeightMapFileChanged: {
                        if (heightMapFile !== "") {
                            // Reset error message when changing files
                            heightMapView.statusMessage = "";
                        }
                    }
                }
            }
        }

        // Loading indicator
        Rectangle {
            anchors.centerIn: parent
            width: 120
            height: 40
            color: "#AA000000"
            radius: 5
            visible: heightMapView.loading
            
            Row {
                anchors.centerIn: parent
                spacing: 10
                
                BusyIndicator {
                    width: 30
                    height: 30
                    running: heightMapView.loading
                }
                
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Loading..."
                    color: "white"
                    font.bold: true
                }
            }
        }

        // Status message for errors
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            width: statusText.width + 20
            height: statusText.height + 10
            radius: 5
            color: "#AA000000"
            visible: heightMapView.statusMessage !== ""
            
            Text {
                id: statusText
                anchors.centerIn: parent
                text: heightMapView.statusMessage
                color: "white"
                font.bold: true
            }
            
            // Auto-hide after 5 seconds
            Timer {
                running: heightMapView.statusMessage !== ""
                interval: 5000
                onTriggered: heightMapView.statusMessage = ""
            }
        }
    }

    function checkState() {
        if (heightSeries.drawMode & Surface3DSeries.DrawSurface)
            surfaceToggle.text = "Hide\nSurface";
        else
            surfaceToggle.text = "Show\nSurface";

        if (heightSeries.drawMode & Surface3DSeries.DrawWireframe)
            surfaceGridToggle.text = "Hide Surface\nGrid";
        else
            surfaceGridToggle.text = "Show Surface\nGrid";
    }

    // Function to handle image loading with error detection
    function loadHeightMap(path) {
        try {
            heightMapView.statusMessage = "";
            heightMapView.loading = true;

            // Instead of resetting to empty string, hold the old value until new one is ready
            let oldPath = heightMapProxy.heightMapFile;
            heightMapProxy.heightMapFile = path;

            // Create a timer to handle loading timeout
            var loadingTimer = Qt.createQmlObject(
                'import QtQuick; Timer { \
                    interval: 3000; \
                    running: true; \
                    repeat: false; \
                    onTriggered: { \
                        if (heightMapView.loading) { \
                            console.error("Height map loading timed out"); \
                            heightMapView.statusMessage = "Loading timed out"; \
                            heightMapView.loading = false; \
                            heightMapProxy.heightMapFile = oldPath; \
                        } \
                    } \
                }',
                heightMapView,
                'loadingTimer'
            );
            
            // Set a small delay to give the proxy time to load
            var finishTimer = Qt.createQmlObject(
                'import QtQuick; Timer { \
                    interval: 500; \
                    running: true; \
                    repeat: false; \
                    onTriggered: { \
                        heightMapView.loading = false; \
                    } \
                }',
                heightMapView,
                'finishTimer'
            );
        } catch (error) {
            console.error("Failed to load height map:", error);
            heightMapView.statusMessage = "Error loading height map: " + error;
            heightMapView.loading = false;
        }
    }
}
