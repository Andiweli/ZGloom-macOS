#!/usr/bin/env bash
# package_macos_app_bundle.sh
#
# ZGloom macOS binary-only app updater.
#
# This script deliberately does one thing only: copy the finished built binary
# into an already existing ZGloom.app bundle. It does not copy dylibs, does not
# touch Info.plist, does not edit RPATHs and does not codesign. This matches a
# successful manual Finder/cp replacement as closely as possible.
#
# Recommended Xcode usage:
#   Select the scheme "ZGloom_Release_BuildAndCopy" and build with Cmd+B.
#
# Manual usage:
#   scripts/package_macos_app_bundle.sh /path/to/zgloom /path/to/ZGloom.app
#
# Optional overrides:
#   ZGLOOM_APP_BUNDLE="/path/to/ZGloom.app"
#   ZGLOOM_APP_EXECUTABLE_NAME="ZGloom"   # overrides CFBundleExecutable
#   ZGLOOM_CLEAR_QUARANTINE=0             # default: 1

set -euo pipefail

log() {
    printf '[ZGloom.app copy] %s\n' "$*"
}

unescape_path() {
    local p="$1"
    p="${p//\\ / }"
    p="${p//\\~/~}"
    printf '%s' "$p"
}

is_macho() {
    local f="$1"
    [ -f "$f" ] || return 1
    if command -v file >/dev/null 2>&1; then
        file "$f" 2>/dev/null | grep -Eq 'Mach-O|universal binary'
    else
        return 0
    fi
}

read_bundle_executable() {
    local plist="$1"
    [ -f "$plist" ] || return 1

    if [ -x /usr/libexec/PlistBuddy ]; then
        /usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$plist" 2>/dev/null && return 0
    fi

    if command -v plutil >/dev/null 2>&1; then
        plutil -extract CFBundleExecutable raw -o - "$plist" 2>/dev/null && return 0
    fi

    return 1
}

print_file_info() {
    local label="$1"
    local f="$2"
    log "$label: $f"
    if [ -f "$f" ] && command -v file >/dev/null 2>&1; then
        file "$f" 2>/dev/null | sed 's/^/[ZGloom.app copy]   /' || true
    fi
    if [ -f "$f" ] && command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$f" 2>/dev/null | sed 's/^/[ZGloom.app copy]   sha256 /' || true
    fi
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="${SRCROOT:-$(cd "${script_dir}/.." && pwd)}"
configuration="${CONFIGURATION:-Release}"
executable_name="${EXECUTABLE_NAME:-zgloom}"
clear_quarantine="${ZGLOOM_CLEAR_QUARANTINE:-1}"

source_binary="${1:-}"
if [ -n "$source_binary" ]; then
    source_binary="$(unescape_path "$source_binary")"
fi

# Prefer the exact Xcode build product first. The Release scheme passes this in
# explicitly, but these fallbacks make the script useful when run manually.
if [ -z "$source_binary" ]; then
    for candidate in \
        "${BUILT_PRODUCTS_DIR:-}/${executable_name}" \
        "${TARGET_BUILD_DIR:-}/${executable_name}" \
        "${project_root}/build-xcode/${configuration}/${executable_name}" \
        "${project_root}/build-xcode/Release/${executable_name}" \
        "${project_root}/build-xcode/Debug/${executable_name}"; do
        if [ -n "$candidate" ] && [ -f "$candidate" ]; then
            source_binary="$candidate"
            break
        fi
    done
fi

if [ -z "$source_binary" ] || [ ! -f "$source_binary" ]; then
    log "ERROR: source binary not found."
    log "  SRCROOT=${SRCROOT:-}"
    log "  CONFIGURATION=${CONFIGURATION:-}"
    log "  BUILT_PRODUCTS_DIR=${BUILT_PRODUCTS_DIR:-}"
    log "  TARGET_BUILD_DIR=${TARGET_BUILD_DIR:-}"
    log "  EXECUTABLE_NAME=${EXECUTABLE_NAME:-}"
    exit 1
fi

if ! is_macho "$source_binary"; then
    log "ERROR: source is not a Mach-O executable: $source_binary"
    file "$source_binary" 2>/dev/null | sed 's/^/[ZGloom.app copy]   /' || true
    exit 1
fi

app_bundle="${2:-${ZGLOOM_APP_BUNDLE:-}}"
if [ -n "$app_bundle" ]; then
    app_bundle="$(unescape_path "$app_bundle")"
else
    app_bundle="${project_root}/../ZGloom.app"
fi

info_plist="${app_bundle}/Contents/Info.plist"
macos_dir="${app_bundle}/Contents/MacOS"

if [ ! -d "$app_bundle" ] || [ ! -f "$info_plist" ] || [ ! -d "$macos_dir" ]; then
    log "ERROR: existing app bundle not found or incomplete: $app_bundle"
    exit 1
fi

bundle_executable="${ZGLOOM_APP_EXECUTABLE_NAME:-}"
if [ -z "$bundle_executable" ]; then
    bundle_executable="$(read_bundle_executable "$info_plist" | tr -d '\r' | head -n 1 || true)"
fi

if [ -z "$bundle_executable" ]; then
    log "ERROR: could not determine CFBundleExecutable from $info_plist"
    log "       Set ZGLOOM_APP_EXECUTABLE_NAME if your bundle uses a custom name."
    exit 1
fi

target_executable="${macos_dir}/${bundle_executable}"

log "Mode: binary-only exact replacement"
log "Configuration: ${configuration}"
print_file_info "Source" "$source_binary"
log "App bundle: $app_bundle"
log "Bundle executable name: $bundle_executable"
log "Target: $target_executable"

# Exact replacement, no helper magic. This intentionally overwrites the same
# executable the Finder launches according to Info.plist.
tmp_target="${target_executable}.new"
rm -f "$tmp_target"
cp -f "$source_binary" "$tmp_target"
chmod 755 "$tmp_target"
mv -f "$tmp_target" "$target_executable"
chmod 755 "$target_executable"

if [ "$clear_quarantine" != "0" ] && command -v xattr >/dev/null 2>&1; then
    xattr -d com.apple.quarantine "$target_executable" 2>/dev/null || true
fi

print_file_info "Copied" "$target_executable"

if cmp -s "$source_binary" "$target_executable"; then
    log "VERIFY OK: copied executable is byte-identical to source."
else
    log "ERROR: copied executable differs from source."
    exit 1
fi

log "Done. No dylibs, no RPATH edits, no codesign."
