---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use.
-- Returned as a table so other modules (keybindings) can require it.
return {
    terminal    = "ghostty",
    fileManager = "nautilus",  -- dolphin still installed as backup
    menu        = "pkill -x rofi || rofi -show drun",
}
