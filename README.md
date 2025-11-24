# ZGloom-macOS<br/>Amiga Gloom port for macOS

ZGloom-macOS is a modern **macOS source port** of the Amiga FPS **Gloom**, based on the updated ZGloom Windows fork.  
It runs the original Gloom engine on macOS using **SDL2** and **LibXMP**, with renderer fixes, widescreen support and multi-game launching.

The goal is to provide a faithful but slightly modernised Gloom experience on current Macs.

---

## ✨ Key Features

- **Native macOS port of the Amiga Gloom engine**  
  Runs the original Gloom data files on macOS using a C++ core with SDL2.

- **Supports original games and selected mods**  
  Works with the main Gloom titles and compatible mods such as **“Death Mask”** and **“8bit Killer”** (as long as they follow the original engine layout).

- **Built-in multi-game launcher**  
  When more than one game is installed, a simple launcher lets you choose between **Gloom**, **Gloom Deluxe**, **Gloom 3**, **Zombie Massacre** or supported mods at startup.

- **4:3 and 16:9 display modes with FOV control**  
  Switch between classic 4:3 and a widescreen 16:9 mode and adjust the **field of view** to suit your monitor and taste.

- **Improved software renderer with lighting effects**  
  Uses the fixed ZGloom renderer with cleaner perspective plus dynamic **muzzle flash brightening** and colored floor reflections under projectiles and weapon upgrade orbs.

- **In-game MOD music via LibXMP**  
  Drop tracker modules into the game data and use script `song_` commands for **per-level music**, similar to the original Amiga release.

---

## 📦 Download & Setup

1. Download the latest macOS build from the **Releases** section of this repository.  
2. Extract the app bundle or archive to a folder of your choice.  
3. Copy your original Gloom game data into the same directory as the executable (or into the configured data subfolders, as described in the release notes).  
4. Start the app; if multiple games/mods are present, choose one from the launcher and play.

You will need data from at least one of:

- **Gloom**
- **Gloom Deluxe / Ultimate Gloom**
- **Gloom 3**
- **Zombie Massacre**
- compatible mods (e.g. **Death Mask**, **8bit Killer**)

---

## 🛠 Building from Source (short version)

ZGloom-macOS is intended to be built with **CMake**, **SDL2**, **SDL2_mixer** and **LibXMP** on macOS:

- Install dependencies (for example via **Homebrew**: `brew install cmake sdl2 sdl2_mixer libxmp`).
- Clone this repository.
- Generate a build directory and run CMake for your preferred generator (Xcode or Ninja).
- Build the project and place your Gloom data next to the resulting binary.

More detailed build instructions (including Universal Binary notes for Intel + Apple Silicon) will be added as the macOS port matures.

---

## ℹ️ About

ZGloom-macOS is a sibling of the Windows ZGloom fork, sharing:

- the **fixed renderer**  
- **multi-game support**  
- **widescreen / FOV options**  
- and **LibXMP-based music playback**

If you enjoy playing classic Amiga shooters on macOS, consider starring the repository so other retro and Gloom fans can discover it.

**Keywords / topics:**  
_amiga • gloom • macos • mac • source port • zgloom • gloom deluxe • zombie massacre • death mask • 8bit killer_
