import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

SwitchDelegate {
    id: control
    text: qsTr("SwitchDelegate")
    checked: true

    contentItem: Text {
        rightPadding: control.indicator.width + control.spacing
        text: control.text
        font: control.font
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
    }
}