// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtDataVisualization
import qmlsurfacegallery

import "."

ApplicationWindow {
    id: mainView
    minimumWidth: 1300
    minimumHeight: 1080
    visible: true

    property string menuText: "Home"

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                id: back
                text: stack.depth == 2 ? qsTr("‹") : qsTr("Home")
                onClicked: stack.popToIndex(0)
                ToolTip.delay: 500
                ToolTip.visible: hovered
                ToolTip.text: stack.depth == 2 ? "Return to main menu" : ""
                enabled: stack.depth == 2 ? true : false
            }
            Label {
                text: stack.depth == 2 ? menuText : "Home"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                text: qsTr("⋮")
                onClicked: menu.open()
            }
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: "MainMenu.qml"
    }
}
