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

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
hl.config({
    input = {
        kb_layout = "se,ru",
        kb_variant = "nodeadkeys",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        accel_profile = "flat",
        force_no_accel = true,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            disable_while_typing = true,
            middle_button_emulation = false,
        },
    },
    gestures = {
        workspace_swipe_distance = 120,
        workspace_swipe_min_speed_to_force = 5,
        workspace_swipe_cancel_ratio = 0.20,
        workspace_swipe_direction_lock_threshold = 20,
        workspace_swipe_forever = true,
        workspace_swipe_create_new = true,
    },
})

