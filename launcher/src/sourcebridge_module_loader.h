#pragma once

#include <string>
#include <vector>

struct SourceBridgeGameProfile {
    std::string id;
    std::string display_name;
    std::vector<std::string> mounts;
    std::string launch_command;
    std::string mode;
};

class SourceBridgeModuleLoader {
public:
    bool ActivateProfile(const SourceBridgeGameProfile& profile);
    const SourceBridgeGameProfile* GetActiveProfile() const;

private:
    bool MountContentPaths(const SourceBridgeGameProfile& profile);
    bool SwitchRuleset(const SourceBridgeGameProfile& profile);
    bool RunLaunchCommand(const SourceBridgeGameProfile& profile);

    SourceBridgeGameProfile active_profile_{};
    bool has_active_profile_ = false;
};
