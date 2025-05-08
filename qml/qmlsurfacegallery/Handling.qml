import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "."

Item {
    id: mainView

    TabBar {
        id: tabBar
        width: parent.width

        TabButton {
            text: "Axis Dragging"
        }

        TabButton {
            text: "Axis Formatting"
        }
    }

    StackLayout {
        anchors.top: tabBar.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        currentIndex: tabBar.currentIndex

        AxisDragging {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        // AxisFormatting {
        //     Layout.fillHeight: true
        //     Layout.fillWidth: true
        //     portraitMode: mainView.portraitMode
        // }
    }
}