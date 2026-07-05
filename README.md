# dotfiles

Arch Linux + **Hyprland 0.55** (Lua config) desktop, themed **Catppuccin Mocha** with a
blue `#89B4FA` accent throughout.

| Component | What |
|---|---|
| WM | Hyprland 0.55, modular Lua config (`config/hypr/modules/*.lua`) |
| Bar | Waybar — four "islands" (Arch pill / workspaces+title / clock / right stack) |
| Launcher | rofi 2.0 — adi1090x type-6 style-7, Mocha recolor (Super+R) |
| Power menu | rofi — adi1090x type-6 style-1, Mocha, hover-select + single-click (Super+M) |
| Notifications | mako |
| Lock / idle | hyprlock (boots straight into the lock screen) + hypridle |
| Wallpapers | waypaper + hyprpaper (Super+W picker) |
| Terminal | ghostty |
| Files | Nautilus (Super+E); Dolphin kept as backup |
| Qt theming | Kvantum OrchisDark + qt6ct-kde |
| GTK theming | Orchis-Dark widgets, Papirus-Dark icons, stock Adwaita-dark for libadwaita apps (deliberate — see gotchas) |
| Fonts | JetBrainsMono Nerd Font (v3) everywhere; Bebas Neue (lock clock); Icomoon-Feather (powermenu icons) — bundled in `fonts/` |

## Install

```sh
git clone https://github.com/RitvikCS/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
./install.sh
```

The script is interactive and re-runnable. It:

1. Installs packages — official (`packages/pacman.txt`) via pacman, AUR
   (`packages/aur.txt`) via yay (bootstraps yay itself if missing).
2. **Symlinks** configs from `config/` into `~/.config` and `home/` into `~`
   (repo stays the source of truth; anything it would replace is backed up to
   `~/.dotfiles-backup-<timestamp>/`).
3. Installs the bundled fonts and warns if Nerd Fonts **v2** leftovers are present
   (they shadow the v3 system font and break icons).
4. Applies the gsettings not stored in files (GTK theme / icons / dark mode).
5. Optionally (sudo): enables NetworkManager + Bluetooth, and installs the
   **getty@tty1 autologin** override (rewritten for the current `$USER`).

### Manual / machine-specific steps

- **Wallpapers are not in the repo** — drop yours into `~/Pictures/wallpapers`,
  then Super+W to pick. `config/waypaper/config.ini` records the last pick with an
  absolute path; waypaper rewrites it at runtime, so first launch just resets it.
- **Boot flow** (what autologin buys you): LUKS passphrase → getty autologin on tty1 →
  `~/.bash_profile` `exec start-hyprland` → hyprlock is the first thing on screen.
  Disk encryption itself is installer-time setup and out of scope here.
  (greetd/uwsm were evaluated and rejected — getty is simpler and works.)
- **NVIDIA**: `config/hypr/modules/env.lua` sets nvidia env vars. On non-NVIDIA
  hardware comment those lines out.
- **Monitor**: `config/hypr/modules/monitors.lua` is written for a 2560x1600 panel —
  adjust for your display.
- **hyprbars** (window titlebars) is configured but disabled by choice.
  To try it: `hyprpm add https://github.com/hyprwm/hyprland-plugins`,
  `hyprpm enable hyprbars`, and un-comment the module line in `config/hypr/hyprland.lua`.
  Run hyprpm from a real terminal (it needs the Hyprland session). Re-run
  `hyprpm update` after every Hyprland upgrade.

## Layout

```
config/          → symlinked to ~/.config/<name>
  hypr/          hyprland.lua + modules/ (env, monitors, programs, autostart,
                 look_and_feel, misc, input, keybindings, window_rules, hyprbars)
                 + hyprlock.conf, hypridle.conf, hyprpaper.conf
  waybar/        config.jsonc, style.css, scripts/
  rofi/          config.rasi (launcher theme via @theme line), launchers/,
                 powermenu/ (type-6 = active), colors/, images/
  mako/  waypaper/  ghostty/  Kvantum/  qt6ct/
  gtk-3.0/settings.ini  gtk-4.0/settings.ini  kdeglobals  mimeapps.list
home/            → ~/.bash_profile (tty1 → Hyprland), ~/.bashrc
fonts/           Icomoon-Feather.ttf, BebasNeue-Regular.ttf, GrapeNuts-Regular.ttf
system/          getty-autologin.conf → /etc/systemd/system/getty@tty1.service.d/
packages/        pacman.txt, aur.txt
install.sh
```

## Keybindings (the ones that matter)

| Bind | Action |
|---|---|
| Super+Q | terminal (ghostty) |
| Super+R | app launcher (toggle) |
| Super+M | power menu (toggle) |
| Super+W | wallpaper picker (toggle) |
| Super+E | file manager |
| Super+C / V / F / P / J | close / float / fullscreen / pseudo / split |
| Super+[1-0], +Shift | workspaces / move window |
| Super+S | scratchpad |
| Super+Print | region screenshot → clipboard |

Full list: `config/hypr/modules/keybindings.lua`.

## Gotchas (hard-won — read before "fixing" things)

- **Hyprland 0.55 IPC**: `hyprctl dispatch` needs the **Lua form**
  (`hyprctl dispatch 'hl.dsp.exit()'`); classic syntax fails *silently*. This applies
  inside scripts too (the powermenu logout).
- **rofi 2.0**: `font:` ignores `var()` — use literal font strings. Glyphs above
  U+FFFF render as tofu — BMP PUA only. Font Awesome 7 hijacks common F0xx codepoints
  with lookalikes — prefer nerd-font-exclusive or plain-unicode glyphs (U+23FB ⏻).
  Theme `background-image` paints a frame late regardless of file size — that's why the
  launcher uses a glyph watermark, not a photo. `fullscreen: true` breaks
  hover/hit-testing under Hyprland (why powermenu type-3 was abandoned).
- **PUA glyphs vs editors**: many editors (and AI tooling) silently strip PUA
  characters. The powermenu scripts' option variables are PUA glyphs — if they become
  empty strings, *Escape matches the empty `$shutdown`/`$yes` case patterns and powers
  the machine off*. Never retype them; copy whole files and verify with
  `hexdump` (each of the 8 option vars must be 3 bytes).
- **libadwaita apps (Nautilus) must NOT get theme CSS** in `~/.config/gtk-4.0/` —
  theme GTK4 CSS lags libadwaita and breaks layouts. `gtk-4.0/settings.ini` only, and
  stock Adwaita-dark for those apps is intentional.
- **Nerd Fonts v2 vs v3**: the font family is "JetBrainsMono Nerd Font" (v3, no space).
  Old v2 "Complete" TTFs in `~/.local/share/fonts` shadow it and break icons.

## Known issues (upstream, not config bugs)

- Waybar workspace **clicks** don't switch workspaces (waybar still speaks the classic
  Hyprland IPC; 0.55 wants Lua form — waiting on a waybar release).
- Waybar **tray menus** (nm-applet, blueman) don't open.
- The powermenu side image paints a split second late (rofi async image load; accepted).
- ghostty shows a hairline sliver below the window at 1.25 fractional scale (GTK buffer
  rounding; `window-decoration = none` already reduced it — not fixable app-side).

## Credits

- [adi1090x/rofi](https://github.com/adi1090x/rofi) — launcher/powermenu base themes
- [Catppuccin](https://github.com/catppuccin/catppuccin) — Mocha palette
- Orchis GTK/Kvantum themes, Papirus icons
