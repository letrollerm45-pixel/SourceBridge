# SourceBridge
SourceMod that runs a server that can be joined from almost every source engine game.

## Windows automation
Use `automate_everything.bat` to run a one-click workflow that:
- prepares local folders (`logs`, `build`, `server`),
- syncs git + submodules,
- attempts Node/.NET dependency restore + build when matching project files exist,
- optionally starts `server\srcds.exe` if present.

Run it by double-clicking the file or from Command Prompt:

```bat
automate_everything.bat
```
