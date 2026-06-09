// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2026 c1ph3rC4t

import QtQuick
import Quickshell.Io

Item {
    id: root

    property int barCount: 24
    property int framerate: 60
    property int noiseReduction: 77
    property color barColor: "#8caaee"
    property int barSpacing: 2
    property int barRadius: 2

    property var levels: []

    Process {
        id: cava
        command: ["sh", "-c", `printf '[general]
bars = ${root.barCount}
framerate = ${root.framerate}
[input]
method = pipewire
source = auto
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 1000
bar_delimiter = 59
frame_delimiter = 10
channels = mono
mono_option = average
[smoothing]
noise_reduction = ${root.noiseReduction}
' | cava -p /dev/stdin`
        ]
        running: true

        onRunningChanged: {
            if (!running) running = true
        }

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                let vals = data.split(";").filter(s => s.length > 0)
                root.levels = vals.map(v => parseInt(v) / 1000.0)
            }
        }
    }

    Row {
        anchors.fill: parent
        spacing: root.barSpacing

        Repeater {
            model: root.levels.length

            Rectangle {
                required property int index

                width: (root.width - (root.levels.length - 1) * root.barSpacing) / root.levels.length
                height: Math.max(1, (root.levels[index] || 0) * root.height)
                anchors.bottom: parent.bottom
                radius: root.barRadius
                color: root.barColor

                Behavior on height { NumAnim{ type: NumAnim.Fast; overshoot: 4.0 } }
            }
        }
    }
}
