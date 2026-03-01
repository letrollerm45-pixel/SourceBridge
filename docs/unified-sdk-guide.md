# Unified Source SDK 2013 Integration Guide

This guide describes how to create a modular Source SDK 2013-based project that can launch multiple game experiences from one hub.

## 1) Clone and set up SDK 2013 foundation

### 1.1 Required tools

- Git 2.40+
- Python 3.10+ (optional helper scripts)
- CMake 3.25+ (if using modernized build wrappers)
- Visual Studio 2022 with:
  - Desktop development with C++
  - MSVC v143 toolset
  - Windows 10/11 SDK

### 1.2 Bootstrap the workspace

From repository root:

```bash
./scripts/bootstrap_unified_sdk.sh
```

or on Windows:

```powershell
./scripts/bootstrap_unified_sdk.ps1
```

This script will:

1. Clone Source SDK 2013 MP as `external/source-sdk-2013`.
2. Clone each repository listed in `games/games.manifest.json` to `external/games/<id>`.
3. Create integration branches named `integration/<id>` in each cloned game repo.

## 2) Integrating game codebases

> Important: Not all listed games have complete official source. Integrate only codebases with compatible licensing.

### 2.1 Recommended branch strategy

Inside `external/source-sdk-2013`:

```bash
git checkout -b unified/main
```

For each game:

```bash
./scripts/merge_game_branch.sh <game-id>
```

The helper performs an `--allow-unrelated-histories` merge from `external/games/<game-id>` into an import branch under SDK.

### 2.2 Conflict hotspots and resolution patterns

#### `game/server/hl2/*.cpp` (`hl2.dll` gameplay path)

- Keep SDK 2013 base for core entity registration.
- Port game-specific weapon/NPC behavior into separate files (`sb_<game>_*.cpp`) and register through factory tables.
- Avoid direct class name collisions by namespace prefixing (`SBTF_`, `SBP_`, etc.).

#### `game/server/mp/*.cpp` (`server.dll` multiplayer path)

- Move each game's ruleset into dedicated subclasses of `CGameRules`:
  - `CSBTFGameRules`
  - `CSBCSSGameRules`
- Add runtime selection via manifest key (`ruleset`).

#### `game/client/*` (`client.dll` and HUD/VGUI)

- Keep one top-level `CHud` registry.
- Register per-game HUD panels conditionally after module activation.

#### Shared interfaces (`igamesystem.h`, `filesystem.h`, `tier1` usage)

- Prefer adapter wrappers in `sourcebridge_module_loader.*`.
- Do not alter Valve interfaces unless unavoidable.

## 3) Hub launcher / game selector UI (VGUI)

### 3.1 Files in this repo

- `launcher/src/sourcebridge_hub_menu.h`
- `launcher/src/sourcebridge_hub_menu.cpp`
- `launcher/resource/SourceBridgeHub.res`
- `launcher/resource/SourceBridgeHubScheme.res`

### 3.2 Integration steps

1. Add C++ files to your client project (`game/client/client.vcxproj`).
2. Register the panel in your main menu flow (typically from `ClientMode` or front-end UI manager).
3. Copy resource files to your `game/resource` output.
4. Wire selected entry to:
   - Set active game context.
   - Mount content search paths.
   - Execute map or chapter start command.

## 4) Dynamic content and mode switching

Use one manifest (`games/games.manifest.json`) that defines:

- code branch/repo
- mount paths
- DLL module target names
- launch command (`map`, `changelevel`, or custom script)

At runtime:

1. Hub reads manifest.
2. Module loader unloads current ruleset (if any).
3. Filesystem mounts selected game paths.
4. Ruleset + HUD profile switches.
5. Launch command executes.

## 5) `gameinfo.txt` modular setup

Sample files provided under `modconfigs/`:

- `gameinfo.hl2bridge.txt`
- `gameinfo.tfbridge.txt`
- `gameinfo.portalbridge.txt`

Use these as templates for per-game mount groups.

## 6) Visual Studio 2022 modernization checklist

- Set toolset to `v143`.
- Add `_CRT_SECURE_NO_WARNINGS` where legacy CRT calls are expected.
- Replace removed `std::auto_ptr` with `std::unique_ptr`.
- Replace deprecated Winsock calls where warnings are elevated.
- Ensure `/Zc:__cplusplus` for modern standards detection.

## 7) Build and test loop

1. Build `tier0`, `tier1`, `vstdlib`, `mathlib` first.
2. Build `server` and `client` DLLs.
3. Launch with `-game <bridge_mod_folder>`.
4. Validate per game profile:
   - content mounts
   - HUD loads
   - map loads
   - save/load (singleplayer)
   - connect/disconnect (multiplayer)

## 8) Adding more games later

1. Add an entry in `games/games.manifest.json`.
2. Re-run bootstrap script.
3. Run merge helper for the new `id`.
4. Add a corresponding gameinfo template.
5. Register selector tile in `SourceBridgeHub.res` (or generated list).

## 9) Suggested compatibility matrix

Track this in your own CI or spreadsheet:

- Compile status (Win/Linux)
- Launch status
- Content mount status
- Multiplayer handshake status
- Known blockers

