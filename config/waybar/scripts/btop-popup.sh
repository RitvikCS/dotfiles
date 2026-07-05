#!/usr/bin/env bash
# Toggle a floating btop window under the waybar stats icon.
# Position/size come from the "btop-popup" window rule in hyprland.lua.
# Closes on: clicking the icon again, Escape, or clicking away.
# (ghostty rewrites its process title, so we track the window through
# hyprctl clients rather than pgrep)

popup_pid() {
    hyprctl clients -j 2>/dev/null | python3 -c '
import json, sys
for c in json.load(sys.stdin):
    if c["class"] == "btop.popup":
        print(c["pid"])
        break
'
}

pid=$(popup_pid)
if [ -n "$pid" ]; then
    kill "$pid" 2>/dev/null
    exit 0
fi

ghostty --class=btop.popup --gtk-single-instance=false --keybind=escape=quit -e btop &

# click-away: watch Hyprland's event socket and close the popup as soon
# as focus moves to any other window
python3 - <<'EOF' &
import json, os, signal, socket, subprocess

def close_popup():
    try:
        out = subprocess.run(["hyprctl", "clients", "-j"],
                             capture_output=True, text=True).stdout
        for c in json.loads(out):
            if c["class"] == "btop.popup":
                os.kill(c["pid"], signal.SIGTERM)
    except Exception:
        pass

path = os.path.join(os.environ["XDG_RUNTIME_DIR"], "hypr",
                    os.environ["HYPRLAND_INSTANCE_SIGNATURE"], ".socket2.sock")
s = socket.socket(socket.AF_UNIX)
s.connect(path)
seen = False
buf = b""
while True:
    data = s.recv(4096)
    if not data:
        break
    buf += data
    while b"\n" in buf:
        line, buf = buf.split(b"\n", 1)
        if line.startswith(b"closewindow>>") and seen:
            raise SystemExit          # closed by Escape/q — stop watching
        if not line.startswith(b"activewindow>>"):
            continue
        appid = line[len(b"activewindow>>"):].split(b",")[0].decode()
        if appid == "btop.popup":
            seen = True
        elif seen:
            close_popup()
            raise SystemExit
EOF
