-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
  hl.exec_cmd("hyprlock")                 -- lock first: boot lands on the lock screen
  hl.exec_cmd("hypridle")                 -- idle daemon: lock/dpms/suspend timeouts
  hl.exec_cmd("nm-applet --indicator")    -- wifi dropdown in the waybar tray
  hl.exec_cmd("blueman-applet")           -- bluetooth dropdown (needs blueman installed)
  hl.exec_cmd("mako")
 -- hl.exec_cmd("hyprpolkitagent")
  hl.exec_cmd("waybar & hyprpaper")
  hl.exec_cmd("sleep 2 && waypaper --restore")  -- re-apply last waypaper pick once hyprpaper's IPC is up

end)
