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
        width: 200 //home.width > 800 ?  home.width / 6 : home.width / 3

        Repeater {
            model: [{name:"Surface Height Map", url:"SurfaceHeightMap.qml"},
            {name:"Surface Oscilloscope", url:"SurfaceOscilloscope.qml"},
            {name:"Surface Spectrogram", url:"SurfaceSpectrogram.qml"},
            {name:"Scatter", url:"Scatter.qml"},
            {name:"MultiGraph", url:"MultiGraph.qml"},
            {name:"Equation", url:"Equation.qml"},
            {name:"CustomInput", url:"CustomInput.qml"},
            {name:"AxisDragging", url:"AxisDragging.qml"},
            {name:"Axes", url:"Axes.qml"},
            {name:"Bars", url:"Bars.qml"},
            {name:"Layers", url:"Layers.qml"}]

            Button {
                text: modelData.name
                onClicked: {
                    stack.push(modelData.url)
                    mainView.menuText = modelData.name
                }
                Layout.fillWidth: true
            }
        }
    }
}