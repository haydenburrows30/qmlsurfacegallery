import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

Page {
    id: home

    property string menuText: "3D Gallery"

    ColumnLayout {
        anchors.centerIn: parent
        width: 200

        Label {
            text: "3D Gallery"
            font.pixelSize: 32
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            Layout.bottomMargin: 30
        }

        Repeater {
            model: [{name:"Surface Height Map", url:"SurfaceHeightMap.qml", tooltip: "Select an image to generate a height map"},
            {name:"Surface Oscilloscope", url:"SurfaceOscilloscope.qml", tooltip: "Select an waveform to generate"},
            {name:"Surface Spectrogram", url:"SurfaceSpectrogram.qml", tooltip: ""},
            {name:"Scatter", url:"Scatter.qml", tooltip: "Scatter 3D"},
            {name:"MultiGraph", url:"MultiGraph.qml", tooltip: "3D bar, surface and scatter plot"},
            {name:"Equation", url:"Equation.qml", tooltip: "Custom equation surface"},
            {name:"CustomInput", url:"CustomInput.qml", tooltip: "Scatter rotating chart"},
            {name:"AxisDragging", url:"AxisDragging.qml", tooltip: "Scatter chart"},
            // {name:"Axes", url:"Axes.qml", tooltip: "Select an image to generate a height map"},
            {name:"Bars", url:"Bars.qml", tooltip: "Financial bar chart"},
            {name:"Layers", url:"Layers.qml", tooltip: "Ground, sea and tectonic surface chart"}]

            Button {
                text: modelData.name
                onClicked: {
                    stack.push(modelData.url)
                    mainView.menuText = modelData.name
                }
                Layout.fillWidth: true
                ToolTip.text: modelData.tooltip
                ToolTip.visible: hovered
                ToolTip.delay: 500
            }
        }
    }
}