-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- HYPRLAND CONFIG — modular layout (split 2026-07-04)      --
-- Each section lives in modules/<name>.lua; this file only --
-- loads them, in the same order as the old single file.    --
-- Fallback backup of the original: hyprland.lua.pre-modular --
-- Wiki: https://wiki.hypr.land/Configuring/Start/          --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

require("modules.env")           -- nvidia + cursor env vars
require("modules.monitors")      -- monitor layout & scaling
require("modules.programs")      -- terminal / file manager / menu (returns a table)
require("modules.autostart")     -- hyprlock, hypridle, waybar, mako, tray applets
require("modules.permissions")   -- (all commented out)
require("modules.look_and_feel") -- general, decoration, animations, layouts
require("modules.misc")
require("modules.input")         -- keyboard, touchpad, gestures, devices
require("modules.keybindings")   -- all binds (uses modules.programs)
require("modules.window_rules")  -- window/layer rules (popups etc.)
-- require("modules.hyprbars")      -- titlebars plugin config (needs hyprpm enable hyprbars)
