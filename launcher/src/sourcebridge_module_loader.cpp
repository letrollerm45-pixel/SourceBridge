#include "sourcebridge_module_loader.h"

// Integrators should replace stubs with actual filesystem/game-rules hooks.

bool SourceBridgeModuleLoader::ActivateProfile(const SourceBridgeGameProfile& profile) {
    if (!MountContentPaths(profile)) {
        return false;
    }

    if (!SwitchRuleset(profile)) {
        return false;
    }

    if (!RunLaunchCommand(profile)) {
        return false;
    }

    active_profile_ = profile;
    has_active_profile_ = true;
    return true;
}

const SourceBridgeGameProfile* SourceBridgeModuleLoader::GetActiveProfile() const {
    return has_active_profile_ ? &active_profile_ : nullptr;
}

bool SourceBridgeModuleLoader::MountContentPaths(const SourceBridgeGameProfile& profile) {
    (void)profile;
    return true;
}

bool SourceBridgeModuleLoader::SwitchRuleset(const SourceBridgeGameProfile& profile) {
    (void)profile;
    return true;
}

bool SourceBridgeModuleLoader::RunLaunchCommand(const SourceBridgeGameProfile& profile) {
    (void)profile;
    return true;
}
