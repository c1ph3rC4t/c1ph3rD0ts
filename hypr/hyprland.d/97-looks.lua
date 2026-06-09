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

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.animation({
    leaf = "global",
    enabled = true,
    speed = 10,
    bezier = "default",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 5.39,
    bezier = "easeOutQuint",
})
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4.79,
    bezier = "easeOutQuint",
})
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4.1,
    bezier = "easeOutQuint",
    style = "slide bottom",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.49,
    bezier = "easeOutQuint",
    style = "slide bottom",
})
hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 1.73,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.46,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 3.03,
    bezier = "quick",
})
hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 3.81,
    bezier = "easeOutQuint",
})
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "fade",
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 1.5,
    bezier = "linear",
    style = "fade",
})
hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 1.79,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 1.39,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 4,
    bezier = "default",
    style = "slidefade 100%",
})

hl.config({
    general = {
        gaps_in = 7.5,
        gaps_out = { top = 70, right = 30, bottom = 30, left = 70 },
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(8caaeeff)", "rgba(8caaeeff)" }, angle = 45 },
            inactive_border = "rgba(32354aaa)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
        extend_border_grab_area = 0,
    },
    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 5,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
        middle_click_paste = false,
        disable_splash_rendering = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})

