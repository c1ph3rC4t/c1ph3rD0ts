// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2026 c1ph3rC4t

import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root
    property string labelText: ""
    property string valDisplayFormat: "{}%"

    property real val: 50
    property real maxVal: 100
    property real minVal: 0
    property real valPrec: 1
    property real dur: 2000

    property color barFgColor: "#8caaee"
    property color barBgColor: "#525c87"

    property real size: 150
    property real thickness: 30
    property real valTextSize: 28
    property real labelTextSize: 28
    
    implicitWidth: size
    implicitHeight: size
    Layout.preferredWidth: size
    Layout.preferredHeight: size

    Behavior on val { NumAnim { type: NumAnim.Slow; duration: dur; overshoot: 0.0 } }

    function clamp(val, min, max) {
        return Math.min(Math.max(val, min), max)
    }

    Shape {
        width: root.size
        height: root.size
        anchors.centerIn: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: root.thickness * root.size / 300
            strokeColor: barBgColor
            capStyle: ShapePath.RoundCap
            fillColor: "#00000000"
            PathAngleArc {
                centerX: root.size / 2
                centerY: root.size / 2
                radiusX: root.size / 2 - root.thickness * root.size / 600
                radiusY: root.size / 2 - root.thickness * root.size / 600
                startAngle: -90
                sweepAngle: 359.9
                moveToStart: true
            }
        }
        ShapePath {
            strokeWidth: root.thickness * root.size / 300
            strokeColor: barFgColor
            capStyle: ShapePath.RoundCap
            fillColor: "#00000000"
            PathAngleArc {
                centerX: root.size / 2
                centerY: root.size / 2
                radiusX: root.size / 2 - root.thickness * root.size / 600
                radiusY: root.size / 2 - root.thickness * root.size / 600
                startAngle: -90
                sweepAngle: (Math.max(minVal, clamp(val, minVal, maxVal) - minVal) / (maxVal - minVal)) * 359.9
                moveToStart: true
            }
        }
    }

    Text {
        color: "#8caaee"
        anchors.centerIn: parent
        font.family: "Fira Code Nerd Font Mono"
        font.pixelSize: root.valTextSize * root.size / 150
        text: valDisplayFormat.replace("{}", val.toFixed(valPrec))
    }

    Text {
        color: "#8caaee"
        anchors.centerIn: parent
        font.family: "Fira Code Nerd Font Mono"
        font.pixelSize: root.labelTextSize * root.size / 150
        text: root.labelText
        transform: Translate { y: root.labelTextSize * root.size / 125 }
    }
}
