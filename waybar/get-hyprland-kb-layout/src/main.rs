// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2026 c1ph3rC4t

use serde_json::Value;
use std::process::Command;

fn main() {
    let output = Command::new("hyprctl")
        .args(["devices", "-j"])
        .output()
        .expect("Failed to execute hyprctl");

    let json: Value = serde_json::from_slice(&output.stdout).expect("Failed to parse JSON");

    let keymap = json["keyboards"]
        .as_array()
        .and_then(|keyboards| {
            keyboards
                .iter()
                .find(|kb| kb["main"].as_bool() == Some(true))
                .and_then(|kb| kb["active_keymap"].as_str())
        })
        .expect("Could not find main keyboard keymap");

    let lang_name = keymap
        .split(|c| c == '_' || c == ' ')
        .next()
        .expect("Empty keymap string");

    let code = isolang::Language::from_name(lang_name)
        .and_then(|lang| Some(lang.to_639_3()))
        .map(|code| code.to_uppercase())
        .unwrap_or_else(|| lang_name.to_uppercase());

    println!("{}", code);
}
