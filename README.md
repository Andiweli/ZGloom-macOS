# ZGloom-macOS<br/>Amiga Gloom port for macOS

ZGloom-macOS is a modern **macOS source port** of the Amiga FPS **Gloom**, based on the updated ZGloom Windows fork.  
It runs the original Gloom engine on macOS using **SDL2** and **LibXMP**, with renderer fixes, widescreen support and multi-game launching.

The goal is to provide a faithful but slightly modernised Gloom experience on current Macs.

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

1. Download the latest macOS build from the **Releases** section of this repository.  
2. Extract the app bundle or archive to a folder of your choice.  
4. Start the app and choose one from the launcher and play.

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

If you enjoy playing classic Amiga shooters on macOS, consider starring the repository so other retro and Gloom fans can discover it.

**Keywords / topics:**  
_amiga • gloom • macos • mac • source port • zgloom • gloom deluxe • zombie massacre • death mask • 8bit killer_
