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

-- Logitech
hl.on("hyprland.start", function()
    hl.exec_cmd(ui)
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("systemctl --user restart pipewire")
    hl.exec_cmd("systemctl --user restart wireplumber")
    hl.exec_cmd("systemctl --user restart pipewire-pulse")
    hl.exec_cmd("systemctl --user restart opentabletdriver.service")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("solaar --window=hide")
end)

