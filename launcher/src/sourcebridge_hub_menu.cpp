#include "sourcebridge_hub_menu.h"

#include <vgui/IScheme.h>
#include <vgui_controls/Button.h>
#include <vgui_controls/ListPanel.h>

SourceBridgeHubMenu::SourceBridgeHubMenu(vgui::Panel* parent, const char* panelName)
    : BaseClass(parent, panelName) {
    SetTitle("SourceBridge Hub", true);
    SetSize(900, 600);
    SetDeleteSelfOnClose(false);

    profile_list_ = new vgui::ListPanel(this, "GameProfileList");
    launch_button_ = new vgui::Button(this, "LaunchButton", "Launch", "LaunchSelectedGame");

    LoadProfiles();
    RefreshProfileList();
}

void SourceBridgeHubMenu::ApplySchemeSettings(vgui::IScheme* scheme) {
    BaseClass::ApplySchemeSettings(scheme);
    LoadControlSettings("resource/SourceBridgeHub.res");
}

void SourceBridgeHubMenu::OnCommand(const char* command) {
    if (!Q_stricmp(command, "LaunchSelectedGame")) {
        if (const SourceBridgeGameProfile* profile = GetSelectedProfile()) {
            module_loader_.ActivateProfile(*profile);
        }
        return;
    }

    BaseClass::OnCommand(command);
}

void SourceBridgeHubMenu::LoadProfiles() {
    profiles_.clear();

    profiles_.push_back({"hl2", "Half-Life 2", {"hl2", "hl2/custom"}, "map d1_trainstation_01", "singleplayer"});
    profiles_.push_back({"tf2", "Team Fortress 2", {"tf", "tf/custom"}, "map ctf_2fort", "multiplayer"});
    profiles_.push_back({"css", "Counter-Strike Source", {"cstrike", "cstrike/custom"}, "map de_dust2", "multiplayer"});
    profiles_.push_back({"portal", "Portal", {"portal", "portal/custom"}, "map testchmb_a_00", "singleplayer"});
}

void SourceBridgeHubMenu::RefreshProfileList() {
    if (!profile_list_) {
        return;
    }

    profile_list_->DeleteAllItems();
    profile_list_->AddColumnHeader(0, "display_name", "Game", 300, 0);
    profile_list_->AddColumnHeader(1, "mode", "Mode", 150, 0);

    for (const auto& profile : profiles_) {
        KeyValues* kv = new KeyValues("row");
        kv->SetString("display_name", profile.display_name.c_str());
        kv->SetString("mode", profile.mode.c_str());
        profile_list_->AddItem(kv, 0, false, false);
        kv->deleteThis();
    }
}

const SourceBridgeGameProfile* SourceBridgeHubMenu::GetSelectedProfile() const {
    if (!profile_list_) {
        return nullptr;
    }

    int itemId = profile_list_->GetSelectedItem(0);
    if (itemId < 0) {
        return nullptr;
    }

    int row = profile_list_->GetItemCurrentRow(itemId);
    if (row < 0 || row >= static_cast<int>(profiles_.size())) {
        return nullptr;
    }

    return &profiles_[row];
}
