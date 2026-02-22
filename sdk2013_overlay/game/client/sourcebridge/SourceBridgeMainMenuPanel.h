#pragma once

#include <vgui_controls/EditablePanel.h>

namespace vgui
{
class Button;
}

class CSourceBridgeMainMenuPanel final : public vgui::EditablePanel
{
    DECLARE_CLASS_SIMPLE(CSourceBridgeMainMenuPanel, vgui::EditablePanel);

public:
    explicit CSourceBridgeMainMenuPanel(vgui::Panel *pParent);
    ~CSourceBridgeMainMenuPanel() override;

    void ApplySchemeSettings(vgui::IScheme *pScheme) override;
    void OnCommand(const char *command) override;

private:
    vgui::Button *m_pStartHostingButton;
    vgui::Button *m_pOptionsButton;
    vgui::Button *m_pQuitButton;
};
