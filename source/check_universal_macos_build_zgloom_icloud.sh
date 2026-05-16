#!/usr/bin/env bash
# check_universal_macos_build_zgloom_icloud.sh
# Prüft ZGloom macOS Universal-Build-Voraussetzungen.
#
# Standard-Projektpfad:
#   /Users/andreas.stuermer/Library/Mobile Documents/com~apple~CloudDocs/Documents/Xcode Projekte/ZGloom
#
# Nutzung:
#   chmod +x check_universal_macos_build_zgloom_icloud.sh
#   ./check_universal_macos_build_zgloom_icloud.sh
#
# Optional anderer Pfad:
#   ./check_universal_macos_build_zgloom_icloud.sh "/anderer/Pfad/ZGloom"

set -u

DEFAULT_ROOT="/Users/andreas.stuermer/Library/Mobile Documents/com~apple~CloudDocs/Documents/Xcode Projekte/ZGloom"
ROOT="${1:-$DEFAULT_ROOT}"

OK=0
WARN=0
FAIL=0

green() { printf "\033[32m%s\033[0m\n" "$*"; }
yellow(){ printf "\033[33m%s\033[0m\n" "$*"; }
red()   { printf "\033[31m%s\033[0m\n" "$*"; }
blue()  { printf "\033[36m%s\033[0m\n" "$*"; }

pass(){ green "✅ $*"; OK=$((OK+1)); }
warn(){ yellow "⚠️  $*"; WARN=$((WARN+1)); }
fail(){ red "❌ $*"; FAIL=$((FAIL+1)); }

has_cmd() { command -v "$1" >/dev/null 2>&1; }

print_header() {
  echo
  blue "== $* =="
}

contains_arch() {
  local file="$1"
  local arch="$2"
  lipo -archs "$file" 2>/dev/null | tr ' ' '\n' | grep -qx "$arch"
}

check_tool() {
  local tool="$1"
  if has_cmd "$tool"; then
    pass "$tool gefunden: $(command -v "$tool")"
  else
    fail "$tool fehlt"
  fi
}

find_dylib_candidates() {
  local lib="$1"
  local names=()

  case "$lib" in
    SDL2) names=("libSDL2.dylib" "SDL2.framework/SDL2") ;;
    SDL2_mixer) names=("libSDL2_mixer.dylib" "SDL2_mixer.framework/SDL2_mixer") ;;
    xmp|libxmp) names=("libxmp.dylib") ;;
    *) names=("lib${lib}.dylib") ;;
  esac

  local dirs=(
    "$ROOT/Frameworks/Universal"
    "$ROOT/Frameworks"
    "$ROOT/ZGloom/Frameworks/Universal"
    "$ROOT/ZGloom/Frameworks"
    "$ROOT/ZGloom/ZGloomCode/Frameworks/Universal"
    "$ROOT/ZGloom/ZGloomCode/Frameworks"
    "$ROOT/ZGloomCode/Frameworks/Universal"
    "$ROOT/ZGloomCode/Frameworks"
    "/opt/homebrew/lib"
    "/usr/local/lib"
    "/opt/homebrew/Frameworks"
    "/usr/local/Frameworks"
    "$ROOT"
    "$ROOT/ZGloom"
    "$ROOT/ZGloom/ZGloomCode"
    "$ROOT/ZGloomCode"
  )

  local found=()
  local d n path

  for d in "${dirs[@]}"; do
    for n in "${names[@]}"; do
      path="$d/$n"
      if [ -f "$path" ]; then
        found+=("$path")
      fi
    done
  done

  if has_cmd brew; then
    case "$lib" in
      SDL2)
        local p
        p="$(brew --prefix sdl2 2>/dev/null || true)"
        [ -n "$p" ] && [ -f "$p/lib/libSDL2.dylib" ] && found+=("$p/lib/libSDL2.dylib")
        if [ -x /usr/local/bin/brew ]; then
          p="$(arch -x86_64 /usr/local/bin/brew --prefix sdl2 2>/dev/null || true)"
          [ -n "$p" ] && [ -f "$p/lib/libSDL2.dylib" ] && found+=("$p/lib/libSDL2.dylib")
        fi
        ;;
      SDL2_mixer)
        local p
        p="$(brew --prefix sdl2_mixer 2>/dev/null || true)"
        [ -n "$p" ] && [ -f "$p/lib/libSDL2_mixer.dylib" ] && found+=("$p/lib/libSDL2_mixer.dylib")
        if [ -x /usr/local/bin/brew ]; then
          p="$(arch -x86_64 /usr/local/bin/brew --prefix sdl2_mixer 2>/dev/null || true)"
          [ -n "$p" ] && [ -f "$p/lib/libSDL2_mixer.dylib" ] && found+=("$p/lib/libSDL2_mixer.dylib")
        fi
        ;;
      xmp|libxmp)
        local p
        p="$(brew --prefix libxmp 2>/dev/null || true)"
        [ -n "$p" ] && [ -f "$p/lib/libxmp.dylib" ] && found+=("$p/lib/libxmp.dylib")
        if [ -x /usr/local/bin/brew ]; then
          p="$(arch -x86_64 /usr/local/bin/brew --prefix libxmp 2>/dev/null || true)"
          [ -n "$p" ] && [ -f "$p/lib/libxmp.dylib" ] && found+=("$p/lib/libxmp.dylib")
        fi
        ;;
    esac
  fi

  printf "%s\n" "${found[@]}" | awk 'NF && !seen[$0]++'
}

check_lib_universal() {
  local lib="$1"
  local candidates
  candidates="$(find_dylib_candidates "$lib")"

  if [ -z "$candidates" ]; then
    fail "$lib nicht gefunden"
    case "$lib" in
      SDL2) echo "   Tipp: brew install sdl2" ;;
      SDL2_mixer) echo "   Tipp: brew install sdl2_mixer" ;;
      xmp|libxmp) echo "   Tipp: brew install libxmp" ;;
    esac
    return
  fi

  local found_arm=0
  local found_x86=0
  local universal=""
  local f

  while IFS= read -r f; do
    [ -z "$f" ] && continue

    local archs
    archs="$(lipo -archs "$f" 2>/dev/null || true)"

    if [ -z "$archs" ]; then
      warn "$lib gefunden, aber keine Mach-O-Architektur erkennbar: $f"
      continue
    fi

    echo "   $lib: $f"
    echo "      Architekturen: $archs"

    contains_arch "$f" "arm64" && found_arm=1
    contains_arch "$f" "x86_64" && found_x86=1

    if contains_arch "$f" "arm64" && contains_arch "$f" "x86_64"; then
      universal="$f"
      break
    fi
  done <<< "$candidates"

  if [ -n "$universal" ]; then
    pass "$lib ist Universal: $universal"
  elif [ "$found_arm" -eq 1 ] && [ "$found_x86" -eq 1 ]; then
    fail "$lib liegt getrennt als arm64 und x86_64 vor, aber nicht als einzelne Universal-Dylib"
    echo "   Nächster Schritt:"
    echo "   ./make_zgloom_universal_libs.sh \"$ROOT\""
  else
    fail "$lib gefunden, aber notwendige Architektur fehlt"
  fi
}

check_pkg_config_lib() {
  local pc="$1"
  if ! has_cmd pkg-config; then
    warn "pkg-config fehlt, überspringe pkg-config Prüfung für $pc"
    return
  fi

  if pkg-config --exists "$pc" 2>/dev/null; then
    pass "pkg-config findet $pc"
    echo "   cflags: $(pkg-config --cflags "$pc" 2>/dev/null || true)"
    echo "   libs:   $(pkg-config --libs "$pc" 2>/dev/null || true)"
  else
    warn "pkg-config findet $pc nicht"
  fi
}

check_xcode_project_settings() {
  print_header "Projektprüfung"

  if [ ! -d "$ROOT" ]; then
    fail "Projektpfad existiert nicht: $ROOT"
    return
  fi

  pass "Projektpfad gefunden: $ROOT"

  local xcodeproj
  xcodeproj="$(find "$ROOT" -maxdepth 4 -name "*.xcodeproj" -type d | head -n 1 || true)"

  if [ -z "$xcodeproj" ]; then
    warn "Kein .xcodeproj innerhalb von $ROOT gefunden"
  else
    pass "Xcode-Projekt gefunden: $xcodeproj"

    local pbx="$xcodeproj/project.pbxproj"
    if [ -f "$pbx" ]; then
      local deployment
      deployment="$(grep -E "MACOSX_DEPLOYMENT_TARGET" "$pbx" | head -n 1 | sed -E 's/.*= *([^;]+);/\1/' | tr -d ' ')"
      if [ -n "$deployment" ]; then
        pass "MACOSX_DEPLOYMENT_TARGET: $deployment"
      else
        warn "MACOSX_DEPLOYMENT_TARGET nicht eindeutig gefunden"
      fi

      if grep -q "ARCHS" "$pbx"; then
        echo "   ARCHS-Einträge:"
        grep -E "ARCHS|VALID_ARCHS|EXCLUDED_ARCHS" "$pbx" | sed 's/^/   /' | head -n 30
      else
        warn "Keine expliziten ARCHS-Einträge gefunden; Xcode-Default wird genutzt"
      fi

      if grep -q "Frameworks/Universal" "$pbx"; then
        pass "Xcode-Projekt enthält Frameworks/Universal"
      else
        warn "Xcode-Projekt enthält Frameworks/Universal noch nicht sichtbar"
        echo "   In Xcode unter Build Settings > Library Search Paths ergänzen:"
        echo "   \$(PROJECT_DIR)/Frameworks/Universal"
      fi

      if grep -q "ONLY_ACTIVE_ARCH = YES" "$pbx"; then
        warn "ONLY_ACTIVE_ARCH = YES gefunden; Release sollte auf NO stehen"
      elif grep -q "ONLY_ACTIVE_ARCH = NO" "$pbx"; then
        pass "ONLY_ACTIVE_ARCH = NO gefunden"
      else
        warn "ONLY_ACTIVE_ARCH nicht eindeutig gefunden"
      fi
    else
      warn "project.pbxproj nicht gefunden"
    fi

    local scheme
    scheme="$(find "$xcodeproj" -path "*/xcshareddata/xcschemes/*.xcscheme" -type f | head -n 1 || true)"
    if [ -n "$scheme" ]; then
      pass "Shared Scheme gefunden: $scheme"
      if grep -q 'buildArchitectures = "Standard"' "$scheme"; then
        pass 'Scheme buildArchitectures = "Standard"'
      elif grep -q 'buildArchitectures = "Automatic"' "$scheme"; then
        warn 'Scheme buildArchitectures = "Automatic"; kann auf aktivem Mac nur arm64 bauen'
      else
        warn "Scheme buildArchitectures nicht eindeutig gefunden"
      fi
    else
      warn "Kein Shared Scheme gefunden"
    fi
  fi

  local cmake
  cmake="$(find "$ROOT" -maxdepth 4 -name "CMakeLists.txt" -type f | head -n 1 || true)"
  if [ -n "$cmake" ]; then
    pass "CMakeLists.txt gefunden: $cmake"
    if grep -q "CMAKE_OSX_ARCHITECTURES" "$cmake"; then
      echo "   CMAKE_OSX_ARCHITECTURES:"
      grep "CMAKE_OSX_ARCHITECTURES" "$cmake" | sed 's/^/   /'
    else
      warn "CMAKE_OSX_ARCHITECTURES nicht in CMakeLists.txt gesetzt"
      echo "   Für Universal-CMake-Build typischerweise:"
      echo "   -DCMAKE_OSX_ARCHITECTURES=\"arm64;x86_64\""
    fi
  else
    warn "Keine CMakeLists.txt gefunden"
  fi
}

check_build_output_if_present() {
  print_header "Vorhandene App/Binary prüfen"

  local bins=()

  while IFS= read -r app; do
    [ -z "$app" ] && continue
    local macos_dir="$app/Contents/MacOS"
    if [ -d "$macos_dir" ]; then
      while IFS= read -r b; do
        [ -n "$b" ] && bins+=("$b")
      done < <(find "$macos_dir" -maxdepth 1 -type f 2>/dev/null)
    fi
  done < <(find "$ROOT" -maxdepth 8 -name "*.app" -type d 2>/dev/null)

  while IFS= read -r b; do
    [ -n "$b" ] && bins+=("$b")
  done < <(find "$ROOT" -maxdepth 8 -type f -name "zgloom" 2>/dev/null)

  if [ "${#bins[@]}" -eq 0 ]; then
    warn "Keine vorhandene .app/Binary im Projekt gefunden; Build-Output-Prüfung übersprungen"
    return
  fi

  local seen=""
  local b
  for b in "${bins[@]}"; do
    case "$seen" in
      *"|$b|"*) continue ;;
    esac
    seen="$seen|$b|"

    echo "   Binary: $b"
    local archs
    archs="$(lipo -archs "$b" 2>/dev/null || true)"
    if [ -z "$archs" ]; then
      warn "Keine lipo-Architektur erkennbar: $b"
      continue
    fi
    echo "      Architekturen: $archs"

    local all=1
    local a
    for a in arm64 x86_64; do
      if ! contains_arch "$b" "$a"; then
        all=0
      fi
    done

    if [ "$all" -eq 1 ]; then
      pass "Binary ist Universal: $b"
    else
      fail "Binary ist nicht Universal: $b"
    fi

    if has_cmd otool; then
      echo "      Dynamische Libraries:"
      otool -L "$b" 2>/dev/null | sed 's/^/      /' | head -n 60

      if otool -L "$b" 2>/dev/null | grep -E "/opt/homebrew/.*/libSDL2|/usr/local/.*/libSDL2" >/dev/null; then
        warn "Binary referenziert Homebrew-SDL2; für sauberes Bundle besser @rpath/Frameworks/Universal nutzen"
      fi
    fi
  done
}

print_header "System"
echo "Projektpfad: $ROOT"
echo "macOS: $(sw_vers -productVersion 2>/dev/null || echo unbekannt)"
echo "CPU: $(uname -m)"
echo

check_tool xcodebuild
check_tool clang
check_tool lipo
check_tool file
check_tool otool
check_tool codesign
check_tool install_name_tool

if xcode-select -p >/dev/null 2>&1; then
  pass "xcode-select aktiv: $(xcode-select -p)"
else
  fail "xcode-select ist nicht eingerichtet"
fi

if has_cmd xcodebuild; then
  echo "   Xcode:"
  xcodebuild -version 2>/dev/null | sed 's/^/   /'
fi

print_header "Optionale Build-Tools"
for t in cmake pkg-config ninja; do
  if has_cmd "$t"; then
    pass "$t gefunden: $(command -v "$t")"
    "$t" --version 2>/dev/null | head -n 1 | sed 's/^/   /'
  else
    warn "$t fehlt"
  fi
done

print_header "Homebrew"
if has_cmd brew; then
  pass "Homebrew gefunden: $(command -v brew)"
  echo "   Prefix: $(brew --prefix 2>/dev/null || true)"
else
  warn "Homebrew nicht gefunden"
fi

print_header "Libraries für Universal-Build"
check_lib_universal "SDL2"
check_lib_universal "SDL2_mixer"
check_lib_universal "xmp"

print_header "pkg-config"
check_pkg_config_lib "sdl2"
check_pkg_config_lib "SDL2_mixer"
check_pkg_config_lib "libxmp"

check_xcode_project_settings
check_build_output_if_present

print_header "Zusammenfassung"
echo "OK:       $OK"
echo "Warnung:  $WARN"
echo "Fehler:   $FAIL"

if [ "$FAIL" -eq 0 ]; then
  green "✅ Grundsätzlich bereit für einen Universal-Build."
  if [ "$WARN" -gt 0 ]; then
    yellow "⚠️  Es gibt Warnungen. Für ZGloom können sie harmlos sein, aber bitte oben prüfen."
  fi
  exit 0
else
  red "❌ Noch nicht bereit für einen sauberen Universal-Build."
  echo
  echo "Wenn die Libraries getrennt als arm64 und x86_64 vorhanden sind, ausführen:"
  echo "  ./make_zgloom_universal_libs.sh \"$ROOT\""
  exit 1
fi
