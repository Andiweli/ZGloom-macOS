cmake_minimum_required(VERSION 3.15)
project(zgloom VERSION 1.0 LANGUAGES CXX)

# Use C++14
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Options
option(WITH_SDL2_MIXER "Try to find and link SDL2_mixer" ON)
option(WITH_XMP "Add xmp include dir (if xmp is present in repo at xmp/include)" ON)

# Try to find SDL2 via CMake config first
set(SDL2_FOUND_IN_CMAKE FALSE)
find_package(SDL2 CONFIG QUIET)
if (SDL2_FOUND)
    set(SDL2_FOUND_IN_CMAKE TRUE)
endif()

# Fallback to pkg-config if needed
if (NOT SDL2_FOUND_IN_CMAKE)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(PKGCFG_SDL2 QUIET sdl2)
    if (PKGCFG_SDL2_FOUND)
        set(SDL2_INCLUDE_DIRS ${PKGCFG_SDL2_INCLUDE_DIRS})
        set(SDL2_LIBRARIES ${PKGCFG_SDL2_LIBRARIES})
    else()
        message(FATAL_ERROR "SDL2 not found. Install SDL2 development packages or provide SDL2Config.")
    endif()
endif()

# Try to find SDL2_mixer (optional)
if (WITH_SDL2_MIXER)
    find_package(SDL2_mixer CONFIG QUIET)
    if (NOT SDL2_mixer_FOUND)
        # pkg-config fallback
        if (PKG_CONFIG_FOUND)
            pkg_check_modules(PKGCFG_SDL2_MIXER QUIET SDL2_mixer)
            if (PKGCFG_SDL2_MIXER_FOUND)
                set(SDL2_MIXER_INCLUDE_DIRS ${PKGCFG_SDL2_MIXER_INCLUDE_DIRS})
                set(SDL2_MIXER_LIBRARIES ${PKGCFG_SDL2_MIXER_LIBRARIES})
            else()
                message(WARNING "SDL2_mixer not found via CMake or pkg-config. Music/sound may be disabled.")
            endif()
        endif()
    endif()
endif()

# If xmp sources/headers are vendored under xmp/include add them
if (WITH_XMP AND EXISTS "${CMAKE_SOURCE_DIR}/xmp/include")
    set(XMP_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/xmp/include")
endif()

# Collect sources (recursive)
file(GLOB_RECURSE PROJECT_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_SOURCE_DIR}/*.cpp"
)

if (PROJECT_SOURCES STREQUAL "")
    message(FATAL_ERROR "No .cpp sources found in project root.")
endif()

add_executable(zgloom ${PROJECT_SOURCES})

# Include directories
# If SDL2 was found as CMake target, use the target's include dirs when linking.
if (TARGET SDL2::SDL2)
    target_link_libraries(zgloom PRIVATE SDL2::SDL2)
    # SDL2::SDL2main may exist in some setups
    if (TARGET SDL2::SDL2main)
        target_link_libraries(zgloom PRIVATE SDL2::SDL2main)
    endif()
else()
    # Use pkg-config variables
    if (DEFINED SDL2_INCLUDE_DIRS)
        target_include_directories(zgloom PRIVATE ${SDL2_INCLUDE_DIRS})
    endif()
    if (DEFINED SDL2_LIBRARIES)
        target_link_libraries(zgloom PRIVATE ${SDL2_LIBRARIES})
    endif()
endif()

# SDL2_mixer linking (if found)
if (TARGET SDL2_mixer::SDL2_mixer)
    target_link_libraries(zgloom PRIVATE SDL2_mixer::SDL2_mixer)
elseif (DEFINED SDL2_MIXER_LIBRARIES)
    target_include_directories(zgloom PRIVATE ${SDL2_MIXER_INCLUDE_DIRS})
    target_link_libraries(zgloom PRIVATE ${SDL2_MIXER_LIBRARIES})
endif()

# xmp include dir if present
if (DEFINED XMP_INCLUDE_DIR)
    target_include_directories(zgloom PRIVATE ${XMP_INCLUDE_DIR})
endif()

# libxmp linking on macOS (Homebrew)
if(APPLE)
    # Versuche, libxmp aus Homebrew zu finden
    find_library(XMP_LIB
        NAMES xmp libxmp
        PATHS
            /opt/homebrew/opt/libxmp/lib
            /opt/homebrew/lib
            /usr/local/lib
    )

    if(NOT XMP_LIB)
        message(FATAL_ERROR "libxmp not found (xmp_play_buffer etc.). Install via 'brew install libxmp' or adjust CMakeLists.txt.")
    endif()

    target_link_libraries(zgloom PRIVATE "${XMP_LIB}")
endif()

# Project headers in repo root
target_include_directories(zgloom PRIVATE ${CMAKE_SOURCE_DIR})

# Compiler flags
if (MSVC)
    target_compile_options(zgloom PRIVATE /W3 /EHsc)
    # MSVC uses /std:c++14 via CMAKE_CXX_STANDARD but set explicitly for older toolsets:
    target_compile_options(zgloom PRIVATE /std:c++14)
else()
    target_compile_options(zgloom PRIVATE -Wall -Wextra -Wpedantic)
    # Ensure position independent code on some systems if building shared libs later
    set_target_properties(zgloom PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()

# Helpful output
message(STATUS "C++ standard: ${CMAKE_CXX_STANDARD}")
if (TARGET SDL2::SDL2)
    message(STATUS "Using SDL2 CMake target")
else()
    message(STATUS "SDL2 include dirs: ${SDL2_INCLUDE_DIRS}")
endif()
if (DEFINED SDL2_MIXER_LIBRARIES)
    message(STATUS "SDL2_mixer: ${SDL2_MIXER_LIBRARIES}")
endif()
if (DEFINED XMP_INCLUDE_DIR)
    message(STATUS "Using xmp includes at: ${XMP_INCLUDE_DIR}")
endif()
