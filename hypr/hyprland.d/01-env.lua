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

-- env = LIBVA_DRIVER_NAME,nvidia
-- env = __GLX_VENDOR_LIBRARY_NAME,nvidia
-- env = NVD_BACKEND,direct

local HOME = os.getenv("HOME")

hl.env("XCURSOR_SIZE", tostring(cursorSize))
hl.env("XCURSOR_THEME", cursorTheme)
hl.env("HYPRCURSOR_SIZE", tostring(cursorSize))
hl.env("HYPRCURSOR_THEME", cursorTheme)

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CONFIG_DIRS", HOME .. "/.config/kdedefaults:/etc/xdg")
hl.env("XDG_CONFIG_HOME", HOME .. "/.config")
hl.env("XDG_DATA_HOME", HOME .. "/.local/share")
hl.env("XDG_STATE_HOME", HOME .. "/.local/state")
hl.env("XDG_CACHE_HOME", HOME .. "/.cache")
hl.env("XDG_DESKTOP_DIR", HOME .. "/Desktop")
hl.env("XDG_DOWNLOAD_DIR", HOME .. "/Downloads")
hl.env("XDG_TEMPLATES_DIR", HOME .. "/Templates")
hl.env("XDG_PUBLICSHARE_DIR", HOME .. "/Public")
hl.env("XDG_DOCUMENTS_DIR", HOME .. "/Documents")
hl.env("XDG_MUSIC_DIR", HOME .. "/Music")
hl.env("XDG_PICTURES_DIR", HOME .. "/Pictures")
hl.env("XDG_VIDEOS_DIR", HOME .. "/Videos")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("XDG_MENU_PREFIX", "plasma-")

hl.env("GDK_BACKEND", "wayland,x11")
hl.env("GTK_THEME", "catppuccin-frappe-sapphire-standard+default")

hl.env("TERMINAL", "kitty")
