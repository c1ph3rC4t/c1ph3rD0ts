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

    property bool active: false
    property bool expandOnHover: true

    property color textColor: "#8caaee"
    property color textActiveColor: "#ffffff"
    property color rectColor: Qt.alpha(textColor, 0.4)
    property color rectActiveColor: textColor

    property int animDur: 180

    signal clicked()

    readonly property bool expanded: active || (expandOnHover && mouse.containsMouse)

    Layout.preferredWidth: text.implicitWidth + text.implicitHeight
    Layout.preferredHeight: text.implicitHeight
    Layout.alignment: Qt.AlignHCenter

    Rectangle {
        anchors.centerIn: parent
        width: root.expanded ? parent.width - text.implicitHeight / 2 : 0
        height: root.expanded ? parent.height : 0
        radius: width > height ? height / 2 : width / 2
        color: root.expanded ? root.rectActiveColor : root.rectColor

        Behavior on width { NumAnim { type: NumAnim.Fast; overshoot: 4.0 } }
        Behavior on color { ColAnim { type: ColAnim.Fast; overshoot: 4.0 } }
    }

    Text {
        id: text
        anchors.centerIn: parent
        text: root.text
        color: root.expanded ? root.textActiveColor : root.textColor
        font.family: "Fira Code Nerd Font Mono"
        font.pixelSize: root.textSize

        Behavior on color { ColAnim { type: ColAnim.Fast; overshoot: 4.0 } }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
