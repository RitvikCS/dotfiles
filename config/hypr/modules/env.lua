-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- NVIDIA (was at the very top of the old single-file config)
hl.env("LIBVA_DRIVER_NAME","nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME","nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS","1")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Qt apps (Dolphin etc.): route theming through qt6ct-kde → Kvantum
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Hyprland doesn't set this like a real Plasma session does, so Dolphin
-- can't find the applications menu structure it needs to populate
-- "Open With" -> empty list, defaults never stick. See:
-- https://www.lorenzobettini.it/2024/05/fixing-the-empty-open-with-in-dolphin-in-hyprland/
hl.env("XDG_MENU_PREFIX", "plasma-")
