--#################################################
--#  _   _                  _                 _  ##
--# | | | |_   _ _ __  _ __| | __ _ _ __   __| | ##
--# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` | ##
--# |  _  | |_| | |_) | |  | | (_| | | | | (_| | ##
--# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| ##
--#        |___/|_|                              ##
--#################################################
--# Config from c1ph3rD0ts by c1ph3rC4t          ##
--#################################################

hl.window_rule({
    name = "Move Steam (By Class)",
    match = {
        class = "^steam$",
    },
    workspace = "11",
})

hl.window_rule({
    name = "Move Steam (By Title)",
    match = {
        title = "^Steam$",
    },
    workspace = "11",
})

hl.window_rule({
    name = "Move osu!lazer (By Title)",
    match = {
        class = "^osu\\!$",
    },
    workspace = "12",
})

hl.window_rule({
    name = "Move osu!lazer (By Title)",
    match = {
        title = "^osu\\!$",
    },
    workspace = "12",
})

hl.window_rule({
    name = "Suppress Maximize",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "XWayland fix",
    match = {
        class = "^$",
        title = "^$",
        xwayland = 1,
        float = 1,
        fullscreen = 0,
        pin = 0,
    },
    no_initial_focus = true,
})

-- Password prompt focus rules
hl.window_rule({
    name = "GTK and GCR password prompt focus",
    match = {
        class = "^(Pinentry-gtk|gcr-prompter)$",
    },
    stay_focused = true,
})

hl.window_rule({
    name = "Veracrypt password prompt focus",
    match = {
        class = "^(veracrypt)$",
        title = "^((Enter password for).*|(Administrator privileges required))$",
    },
    stay_focused = true,
})

-- Remove annoying 1px black borders around screenshots
hl.layer_rule({
    name = "No anim for hyprshot",
    match = {
        class = "hyprpicker",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "No anim for selection",
    match = {
        namespace = "selection",
    },
    no_anim = true,
})

