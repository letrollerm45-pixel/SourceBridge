# SourceBridge Unified Source SDK 2013 Workspace

SourceBridge is a modular integration workspace that layers multiple Source-engine game codebases onto Source SDK 2013 and exposes them through a single launcher hub.

> ⚠️ **Scope note:** Valve has not released full gameplay source for every listed title. This project therefore combines:
> - Officially available Source SDK 2013 code.
> - Open-source forks/ports where licensing permits.
> - Per-game content mounting and modular client/server DLL loading.

## What this repo now includes

- A repeatable **bootstrap pipeline** for cloning SDK and game forks.
- A **merge workflow** for conflict-heavy targets like `hl2`, `mp`, and shared engine interfaces.
- A **VGUI game selector design** with C++ stubs and resource files.
- Build notes for **Visual Studio 2022**.
- A manifest-driven path to add additional games in the future.

## Quick start

1. Review `docs/unified-sdk-guide.md`.
2. Copy and edit `games/games.manifest.json` for the repos and branches you want.
3. Run:
   - Linux/macOS: `./scripts/bootstrap_unified_sdk.sh`
   - Windows PowerShell: `./scripts/bootstrap_unified_sdk.ps1`
4. Open generated solution/workspace and follow merge checklist from the guide.

## Repository layout

```text
SourceBridge/
├── docs/
│   └── unified-sdk-guide.md
├── games/
│   └── games.manifest.json
├── launcher/
│   ├── resource/
│   │   ├── SourceBridgeHub.res
│   │   └── SourceBridgeHubScheme.res
│   └── src/
│       ├── sourcebridge_hub_menu.cpp
│       ├── sourcebridge_hub_menu.h
│       ├── sourcebridge_module_loader.cpp
│       └── sourcebridge_module_loader.h
├── modconfigs/
│   ├── gameinfo.hl2bridge.txt
│   ├── gameinfo.portalbridge.txt
│   └── gameinfo.tfbridge.txt
└── scripts/
    ├── bootstrap_unified_sdk.ps1
    ├── bootstrap_unified_sdk.sh
    └── merge_game_branch.sh
```

## Next steps

- Wire `launcher/src/*` into your `game/client` project.
- Add each selected game's content mount path in the corresponding `gameinfo.*.txt`.
- Resolve compile drift as described in `docs/unified-sdk-guide.md`.

