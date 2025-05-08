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

    TabBar {
        id: tabBar
        width: parent.width

        TabButton {
            text: "Height Map"
        }

        TabButton {
            text: "Spectrogram"
        }

        TabButton {
            text: "Oscilloscope"
        }

        TabButton {
            text: "Scatter"
        }

        TabButton {
            text: "Bars"
        }

        TabButton {
            text: "Axes"
        }

        TabButton {
            text: "Input"
        }

        TabButton {
            text: "Multigraph"
        }

        TabButton {
            text: "Equation"
        }
    }

    StackLayout {
        anchors.top: tabBar.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        currentIndex: tabBar.currentIndex

        SurfaceHeightMap {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        SurfaceSpectrogram {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        SurfaceOscilloscope {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Scatter {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Bars {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        AxisDragging {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        CustomInput {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        MultiGraph {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        // Equation {
        //     Layout.fillHeight: true
        //     Layout.fillWidth: true
        // }
    }
}
