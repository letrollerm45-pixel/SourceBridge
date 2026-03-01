#pragma once

#include "sourcebridge_module_loader.h"

#include <vgui_controls/Frame.h>
#include <vector>

namespace vgui {
class ListPanel;
class Button;
}

class SourceBridgeHubMenu : public vgui::Frame {
    DECLARE_CLASS_SIMPLE(SourceBridgeHubMenu, vgui::Frame);

public:
    SourceBridgeHubMenu(vgui::Panel* parent, const char* panelName);
    ~SourceBridgeHubMenu() override = default;

    void ApplySchemeSettings(vgui::IScheme* scheme) override;
    void OnCommand(const char* command) override;

private:
    void LoadProfiles();
    void RefreshProfileList();
    const SourceBridgeGameProfile* GetSelectedProfile() const;

    std::vector<SourceBridgeGameProfile> profiles_;
    SourceBridgeModuleLoader module_loader_;

    vgui::ListPanel* profile_list_ = nullptr;
    vgui::Button* launch_button_ = nullptr;
};
