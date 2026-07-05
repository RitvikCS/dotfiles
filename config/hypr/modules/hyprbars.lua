------------------
---- HYPRBARS ----
------------------

-- Server-side titlebars (hyprpm plugin: hyprwm/hyprland-plugins → hyprbars).
-- Drag the bar to move a window; buttons on the right (plugin default),
-- Mocha palette to match waybar/rofi.
-- NOTE: button actions are shell commands; on Hyprland 0.55 `hyprctl dispatch`
-- takes the Lua form, NOT classic (`killactive` etc. silently fail).

-- Bail out quietly if the plugin isn't loaded (not enabled / failed build):
-- keeps the rest of the config clean instead of erroring on unknown keys.
if not (hl.plugin and hl.plugin.hyprbars) then
    return
end

hl.config({
    plugin = {
        hyprbars = {
            bar_height         = 26,
            bar_color          = "rgba(1e1e2eff)",   -- Mocha base
            col                = { text = "rgba(cdd6f4ff)" },  -- title text
            bar_text_size      = 10,
            bar_text_font      = "JetBrainsMono Nerd Font",
            bar_text_align     = "center",
            bar_part_of_window = true,
            icon_on_hover      = true,
        },
    },
})

-- Buttons (defined right-to-left: close is the rightmost)
hl.plugin.hyprbars.add_button({
    icon     = "✕",
    size     = 12,
    bg_color = "rgba(f38ba8ff)",   -- red: close
    fg_color = "rgba(11111bff)",
    action   = "hyprctl dispatch 'hl.dsp.window.close()'",
})
hl.plugin.hyprbars.add_button({
    icon     = "⤢",
    size     = 12,
    bg_color = "rgba(a6e3a1ff)",   -- green: fullscreen
    fg_color = "rgba(11111bff)",
    action   = "hyprctl dispatch 'hl.dsp.window.fullscreen()'",
})
hl.plugin.hyprbars.add_button({
    icon     = "◇",
    size     = 12,
    bg_color = "rgba(f9e2afff)",   -- yellow: toggle floating
    fg_color = "rgba(11111bff)",
    action   = "hyprctl dispatch 'hl.dsp.window.float({ action = \"toggle\" })'",
})

-- Firefox draws its own titlebar (CSD) — skip the extra bar.
-- If you'd rather have uniform bars everywhere, remove this rule and
-- untick "Title Bar" in Firefox's Customize Toolbar screen instead.
hl.window_rule({
    name  = "firefox-no-hyprbar",
    match = { class = "firefox" },

    ["hyprbars:no_bar"] = true,
})
