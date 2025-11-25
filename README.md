# ZGloom-macOS – Amiga Gloom port for macOS

> Native macOS port of the modern ZGloom engine, bringing the classic Amiga FPS **Gloom** (plus Gloom Deluxe, Gloom 3 and Zombie Massacre) to Intel and Apple Silicon Macs.

[![Latest release](https://img.shields.io/github/v/release/Andiweli/ZGloom-macOS?label=latest%20macOS%20release)](https://github.com/Andiweli/ZGloom-macOS/releases/latest)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)](https://github.com/Andiweli/ZGloom-macOS)
[![Engine](https://img.shields.io/badge/engine-SDL2%20%2B%20LibXMP-brightgreen.svg)](https://github.com/Andiweli/ZGloom-macOS)

ZGloom-macOS is a macOS port of the updated [ZGloomX86 Windows fork](https://github.com/Andiweli/ZGloomX86), adapted to run on macOS using **SDL2**, **SDL2_mixer** and **LibXMP**. It aims to stay faithful to the original Amiga Gloom engine while adding a fixed renderer, widescreen/FOV options and multi-game support for **Gloom**, **Gloom Deluxe**, **Gloom 3**, **Zombie Massacre** and selected mods.

---

## ✨ Key Features

- **Native macOS port of the Amiga Gloom engine**  
  Runs the original Gloom data files on macOS using a C++ core with SDL2.

- **Built-in multi-game launcher**  
  A simple launcher lets you choose between **Gloom**, **Gloom Deluxe**, **Gloom 3** and **Zombie Massacre** at startup.

- **4:3 and 16:9 display modes with FOV control**  
  Switch between classic 4:3 and a widescreen 16:9 mode and adjust the **field of view** to suit your monitor and taste.

- **Improved software renderer with lighting effects**  
  Uses the fixed ZGloom renderer with cleaner perspective plus dynamic **muzzle flash brightening** and colored floor reflections under projectiles and weapon upgrade orbs.

---

## 🎞️ Preview of current Game status

https://github.com/user-attachments/assets/7e1427e0-9a1e-416a-b115-55faf4cbe8fa

<img width="1280" height="1440" alt="image" src="https://github.com/user-attachments/assets/4a94d176-bc84-4a8f-9b77-20d3c2b51e43" />

---

## 📦 Download & Setup

1. Download the latest macOS build from the [**Releases**](https://github.com/Andiweli/ZGloom-macOS/releases) section of this repository.  
2. Extract the app bundle or archive to a folder of your choice.  
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

If you enjoy playing classic Amiga shooters on macOS, consider starring the repository so other retro and Gloom fans can discover it.

**Keywords / topics:**  
_amiga • gloom • macos • mac • source port • zgloom • gloom deluxe • zombie massacre • death mask • 8bit killer_
