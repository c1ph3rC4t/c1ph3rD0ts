// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2026 c1ph3rC4t

import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string text: ""
    property int textSize: 30
    property real ballRatio: 0.5

    property bool active: false
    property bool expandOnHover: true

    property color textColor: "#8caaee"
    property color textActiveColor: "#ffffff"
    property color ballColor: Qt.alpha(textColor, 0.4)
    property color ballActiveColor: textColor

    property int animDur: 180

    signal clicked()

    readonly property bool expanded: active || (expandOnHover && mouse.containsMouse)

    Layout.preferredWidth: textSize * 3
    Layout.preferredHeight: textSize * 3
    Layout.alignment: Qt.AlignHCenter

    Rectangle {
        anchors.centerIn: parent
        width: root.expanded ? parent.width * root.ballRatio : 0
        height: width
        radius: width / 2
        color: root.expanded ? root.ballActiveColor : root.ballColor

        Behavior on width { NumberAnimation { duration: root.animDur; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: root.animDur } }
    }

    Text {
        anchors.centerIn: parent
        text: root.text
        color: root.expanded ? root.textActiveColor : root.textColor
        font.family: "Fira Code Nerd Font Mono"
        font.pixelSize: root.textSize

        Behavior on color { ColorAnimation { duration: root.animDur } }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
