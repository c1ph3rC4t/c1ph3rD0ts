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

    Behavior on val { NumAnim { type: NumAnim.Slow; duration: 2000; overshoot: 0.0 } }

    function arcPath(cx, cy, r, aDeg, nDeg) {
        aDeg = aDeg - 90
        const toRad = d => d * Math.PI / 180;
        const startX = cx + r * Math.cos(toRad(aDeg));
        const startY = cy + r * Math.sin(toRad(aDeg));
        const endX = cx + r * Math.cos(toRad(aDeg + nDeg));
        const endY = cy + r * Math.sin(toRad(aDeg + nDeg));
        const largeArc = Math.abs(nDeg) > 180 ? 1 : 0;
        const sweep = nDeg > 0 ? 1 : 0;
        return `M ${startX} ${startY} A ${r} ${r} 0 ${largeArc} ${sweep} ${endX} ${endY}`;
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
            PathSvg { path: arcPath(root.size / 2, root.size / 2, root.size / 2 - root.thickness * root.size / 600, -120, 240) }
        }
        ShapePath {
            strokeWidth: root.thickness * root.size / 300
            strokeColor: barFgColor
            capStyle: ShapePath.RoundCap
            fillColor: "#00000000"
            PathSvg { path: arcPath(root.size / 2, root.size / 2, root.size / 2 - root.thickness * root.size / 600, -120, (Math.max(minVal, val - minVal) / (maxVal - minVal)) * 240) }
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
        transform: Translate { y: root.labelTextSize * root.size / 100 }
    }
}
