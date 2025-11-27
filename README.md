# ZGloom-macOS – Amiga Gloom port for macOS (Intel & Apple Silicon)

Native macOS port of the modern **ZGloom** engine, bringing the classic Amiga FPS **Gloom** and its successors to both Intel and Apple Silicon Macs.

> Play Gloom, Gloom Deluxe, Gloom 3 and Zombie Massacre on macOS with a fixed renderer, widescreen support, post-processing overlays and save/load position – while staying faithful to the original Amiga gameplay.

[![Latest release](https://img.shields.io/github/v/release/Andiweli/ZGloom-macOS?label=latest%20macOS%20release)](https://github.com/Andiweli/ZGloom-macOS/releases/latest)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)](https://github.com/Andiweli/ZGloom-macOS)
[![Engine](https://img.shields.io/badge/engine-SDL2%20%2B%20LibXMP-brightgreen.svg)](https://github.com/Andiweli/ZGloom-macOS)

ZGloom-macOS is the macOS sibling of the Windows ZGloom fork, adapted to SDL2 / LibXMP and CMake/Xcode toolchains while keeping the same renderer, feature set and multi-game support.

For other platforms, see the companion projects [ZGloom-x86 (Windows)](https://github.com/Andiweli/ZGloom-x86), [ZGloom-Android](https://github.com/Andiweli/ZGloom-Android) and [ZGloom-Vita-Vita2D (PS Vita / PSTV)](https://github.com/Andiweli/ZGloom-Vita-Vita2D).

---

## 🕹 What is Gloom?

[Gloom](https://en.wikipedia.org/wiki/Gloom_(video_game)) was a 1995 Doom-like first-person shooter from **Black Magic Software** for the Commodore Amiga. It featured very messy and meaty graphics and required a powerful Amiga at the time (an A1200 with 030 CPU was still on the low end). The engine later powered several related games and successors, including:

- **Gloom Deluxe / Ultimate Gloom** – enhanced graphics and effects  
- **Gloom 3**  
- **Zombie Massacre**  
- Various full-game conversions of other 90’s Amiga titles

ZGloom is a modern reimplementation of this engine.

---

## ✨ Key Features

- Modern source port of the Amiga Gloom engine  
  Runs the original Gloom data files on macOS (Intel and Apple Silicon) using the modern ZGloom C++ engine.

- Supports multiple official games  
  Play **Gloom**, **Gloom Deluxe / Ultimate Gloom**, **Gloom 3** and **Zombie Massacre** (plus selected mods where available).

- Built-in multi-game launcher  
  If more than one game or mod is present, a simple launcher lets you pick what to play at startup.

- 4:3 and 16:9 display modes with FOV control  
  Switch between the classic 4:3 Amiga look and a widescreen 16:9 mode and adjust the field of view to match your monitor.

- Improved renderer, lighting and effects  
  Uses the fixed ZGloom renderer with cleaner perspective, fewer glitches and subtle lighting tweaks, including dynamic muzzle flashes and colored floor reflections under projectiles and weapon upgrade orbs.

- Atmospheric post-processing overlays (optional)  
  Enable vignette, film grain and scanlines for a more gritty, CRT-style presentation without changing gameplay.

- Save/Load position and extended options  
  Save your in-level position (including health, weapon and ammo state) and tweak many more options than in the original Amiga release.

---

## 🖼️ Gameplay-Video and Screenshots

https://github.com/user-attachments/assets/857e1e91-e915-4def-ba2c-2802171a71e5

<img width="1280" height="1440" alt="Gloom-Screenshots" src="https://github.com/user-attachments/assets/28813c0e-57ae-4a9e-a8b8-5bb13e805b36" />

---

## 📦 Download & Setup

1. Download the latest macOS build from the [**Releases**](https://github.com/Andiweli/ZGloom-macOS/releases) section of this repository.  
2. Extract the app bundle or archive to a folder of your choice, game data files are included.  
4. Start the app and choose a game from the launcher and play.

---

## 🛠 Building from Source (short version)

ZGloom-macOS is intended to be built with **CMake**, **SDL2**, **SDL2_mixer** and **LibXMP** on macOS.  
This build was built using Xcode on macOS 26.

- Install Xcode from the Apple AppStore
- Open Terminal and enter ``xcode-select --install``
- Install Homebrew as described [here](https://brew.sh/)
- Open Terminal again and enter
  ```
  brew install cmake ninja
  brew install sdl2 sdl2_mixer libxmp
  ```
-  Change to you project directory (e.g. ~/Projects/ZGloom)

### Now you can either use CMAKE
```
mkdir build-macos
cd build-macos

cmake .. \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
```
And wenn this works compile with ``cmake --build . --config Release``

### Or you can use Xcode
```
mkdir build-xcode
cd build-xcode

cmake .. \
  -G Xcode \
  -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
```
And then open the project file in Xcode or compile in Terminal using ``xcodebuild -project ZGloom.xcodeproj -configuration Release``

---

## ℹ️ About

ZGloom-macOS is a sibling of the Windows ZGloom fork, sharing:

- the **fixed renderer**  
- **multi-game support**  
- **widescreen / FOV options**
- background ambience credit goes to Prophet

If you enjoy playing classic Amiga shooters on macOS, consider starring the repository so other retro and Gloom fans can discover it.

**Keywords / topics:**  
_amiga • gloom • macos • mac • source port • zgloom • gloom deluxe • zombie massacre • death mask • 8bit killer_
