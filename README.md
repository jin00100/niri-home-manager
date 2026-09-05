<h1 align="center">iNiR</h1>

<p align="center">
  <b>A streamlined, personalized desktop shell for Niri, built on Quickshell</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-2.30.0-blue?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/compositor-Niri-purple?style=flat-square" alt="Compositor">
  <img src="https://img.shields.io/badge/framework-Quickshell-orange?style=flat-square" alt="Framework">
  <img src="https://img.shields.io/badge/license-GPL--3.0-green?style=flat-square" alt="License">
</p>

---

<details open>
<summary><b>Overview & Architecture</b></summary>

### What is iNiR?

iNiR is a complete, modular desktop environment and shell interface for Linux. It provides the top bar, dock, notification hub, settings dashboard, audio controls, app launchers, and dynamic wallpaper theming layer.

### System Architecture

```
User Applications
       ↓
iNiR (Shell: Bar, Panels, Overview, Notifications, Settings)
       ↓
Quickshell (Qt6 / QML Shell Runtime Engine)
       ↓
Niri (Scrollable-Tiling Wayland Compositor)
       ↓
Wayland / DRM / GPU
```

Everything is configured via the interactive settings GUI (`Super+,`) or standard configuration files (`config.json` and modular KDL files).

</details>

---

## Key Highlights & Personalized Features

### 1. Curated Media & Anime Hub
- **Anime & Booru Discovery**: Search and browse high-resolution artwork across major Booru image boards directly inside the shell.
- **AniList Anime Schedule**: Real-time airing countdowns, schedules, and episode tracking integrated into the sidebar.
- **Streamlined Performance**: Zero unwanted background pollers, zero external AI daemons, zero bloated webview scrapers.

### 2. Fluid Mist & Volumetric Smoke Window Shaders
- Custom domain-warped GLSL fluid dynamics shaders for Niri window lifecycle animations.
- Dynamic smoke dissipation with smooth alpha falloff on window open and close transitions.
- Interactive animation switching via `niri-anim-switcher` (`Mod+Alt+A`).

### 3. Integrated DevOps & Terminal Suite
- **Fish & Bash Integration**: Modular environment loader with cached Kubernetes (`kubectl`) and `helm` autocompletions.
- **Starship Prompt**: Dual-mode prompt with automatic SSH remote IP pills and system detection.
- **Zellij Multiplexer**: Configured with the modern `cyber-blue` color theme and ergonomic keybindings.
- **Yazi Modern File Manager**: Integrated with `githead` status tracking and custom preview handlers.
- **Neovim Configuration**: Fast `lazy.nvim` plugin architecture with LSP, Treesitter, and Git integrations.
- **Kitty Terminal**: Tuned block cursor with smooth trail decay physics.

### 4. Input Method (Fcitx5) Ready
- **Fcitx5 Chinese Pinyin Suite**: Registered into system dependencies and installer (`fcitx5-im`, `fcitx5-chinese-addons`, `fcitx5-pinyin-zhwiki`).
- **Seamless Wayland Integration**: Compositor environment variables (`XMODIFIERS`, `QT_IM_MODULE`) and daemon autostart configured out of the box.
- **Ergonomic Switching**: Effortless switching between English and Pinyin via <kbd>Ctrl</kbd> + <kbd>Space</kbd> or <kbd>Shift</kbd>.

---

## Core Shell Features

### Dual Panel Families (`Super+Shift+W` to toggle)
- **Material ii**: Floating dynamic bar, comprehensive sidebars, app dock, and 8 customizable visual styles (Material, Cards, Aurora glass blur, iNiR, Angel neo-brutalism, Regalia, ZZZ, Cookie Shapes).
- **Waffle**: Compact bottom taskbar, Windows 11-style launcher, quick settings action center, and calendar center.

### Dynamic Material You Theming
- Extracts harmonic color palettes from any wallpaper dynamically.
- Automatically synchronizes colors across GTK3/4, Qt6, terminal emulators (Kitty, Ghostty, Alacritty, Foot), Discord/Vesktop, and shell overlays.
- Built-in theme presets: Regalia, Gruvbox, Catppuccin, Rosé Pine, and custom user definitions.

### Modular Bar & Desktop Widgets
- 6 interchangeable bar layouts: Classic, Islands, Scenic, Frame, Material 3 capsules, and Pill bar.
- Wallpaper desktop widgets: Digital/analog clocks, system load monitor, weather, and media controls.

### Region Capture & Snip Tools
- **Interactive Screenshot**: Full visual marquee selection with loupe magnification, dimensions, and instant clipboard copying.
- **Screen Recording**: High-framerate regional screen recording with optional audio capture.
- **OCR Text Extraction**: Fast optical character recognition for selected screen areas.

---

## Essential Shortcuts

| Shortcut | Action |
|---|---|
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd> | Interactive Region Screenshot (Select, copy to clipboard, or save) |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd> | Snip & Region Tool Menu (Screenshot, OCR, Record) |
| <kbd>Super</kbd> + <kbd>Space</kbd> | App Launcher & Workspace Overview |
| <kbd>Super</kbd> + <kbd>V</kbd> | Clipboard History Manager |
| <kbd>Super</kbd> + <kbd>,</kbd> | Shell Settings Dashboard |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | Toggle Panel Family (Material ii ↔ Waffle) |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>A</kbd> | Window Shader Animation Switcher |
| <kbd>Super</kbd> + <kbd>T</kbd> / <kbd>Return</kbd> | Launch Default Terminal |
| <kbd>Super</kbd> + <kbd>Q</kbd> | Close Window (with unsaved work confirmation) |
| <kbd>Super</kbd> + <kbd>M</kbd> | Fullscreen Window Toggle |
| <kbd>Super</kbd> + <kbd>/</kbd> | Interactive Keybind Cheatsheet |
| <kbd>Ctrl</kbd> + <kbd>Space</kbd> | Toggle Input Method (Pinyin / English) |

---

## Maintenance & Control CLI

The shell includes built-in diagnostic and management commands via `inir` and `./setup`:

```bash
# Everyday shell control
inir run                        # Launch or attach to shell instance
inir settings                   # Open graphical settings interface
inir restart                    # Reload runtime and restart UI
inir logs                       # Inspect recent shell logs
inir doctor                     # Run automated diagnostic checks
inir ipc shellUpdate open       # Open graphical shell update overlay

# Updates, snapshots & recovery
./setup update --local          # Sync local repo changes to runtime with automatic snapshot
./setup update                  # Pull latest commits from remote, migrate configs, and reload
./setup rollback                # Restore from a previous snapshot
./setup status                  # Display current installation and runtime status
./setup doctor                  # Inspect dependencies and environment health
./setup install -y              # Full setup pipeline
```

---

## System Requirements

- **Compositor**: [Niri](https://github.com/YaLTeR/niri) (v25.02+ recommended).
- **Runtime**: [Quickshell](https://quickshell.outfoxxed.me/) (Qt 6.8+).
- **Platform**: Linux (Arch Linux recommended; Fedora and Debian supported).
- **Display**: Wayland session.

---
