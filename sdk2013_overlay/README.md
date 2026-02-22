# SourceBridge SDK 2013 Base

This overlay gives you a starting point for a custom **Source SDK 2013** main menu titled **SourceBridge** with:

1. Start Hosting
2. Options
3. Quit

## 1) Get SDK 2013 source

```bash
git clone https://github.com/ValveSoftware/source-sdk-2013.git third_party/source-sdk-2013
```

## 2) Copy this overlay into the SDK tree

From this repository root:

```bash
cp -r sdk2013_overlay/game/client/sourcebridge third_party/source-sdk-2013/sp/src/game/client/
```

## 3) Hook panel creation into the game UI

Edit `third_party/source-sdk-2013/sp/src/game/client/clientmode_shared.cpp` (or your custom client mode bootstrap) and create/show `CSourceBridgeMainMenuPanel` when the game starts.

A typical insertion point is where background/main menu VGUI is initialized.

## 4) Add the panel resource file to the game UI resource path

Copy:

```text
sdk2013_overlay/game/client/sourcebridge/SourceBridgeMainMenuPanel.res
```

to:

```text
third_party/source-sdk-2013/sp/game/mod_hl2/resource/ui/SourceBridgeMainMenuPanel.res
```

(or your mod game folder equivalent)

## 5) Build and run

Use standard Source SDK 2013 build flow (Visual Studio solution generation + compile).

---

This is intentionally a base scaffold so you can expand behaviors (server browser, dedicated hosting flow, settings categories, etc).
