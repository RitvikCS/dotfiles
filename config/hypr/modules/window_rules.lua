--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Floating btop popup opened from the waybar stats icon
hl.window_rule({
    name  = "btop-popup",
    match = { class = "btop.popup" },

    float = true,
    size  = "1100 650",
    move  = "monitor_w-1114 60",
})

-- Blueman devices window (opened from the tray applet) as a small
-- floating popup under the right island
hl.window_rule({
    name  = "blueman-popup",
    match = { class = "blueman-manager" },

    float = true,
    size  = "900 560",
    move  = "monitor_w-914 60",
})

-- Waypaper as a floating dropdown under the left island (arch button / Super+W)
hl.window_rule({
    name  = "waypaper-popup",
    match = { class = "waypaper" },

    float = true,
    size  = "980 640",
    move  = "20 60",
})

-- Nautilus: slight translucency to match the desktop (compositor-side;
-- safer than theming libadwaita CSS). 1.0 = opaque if it ever annoys.
hl.window_rule({
    name  = "nautilus-translucent",
    match = { class = "org.gnome.Nautilus" },

    opacity = "0.92 0.85",   -- focused, unfocused
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})
