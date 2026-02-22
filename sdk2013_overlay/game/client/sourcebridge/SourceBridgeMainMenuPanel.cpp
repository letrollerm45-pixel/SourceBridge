#include "cbase.h"
#include "SourceBridgeMainMenuPanel.h"

#include <engine/IEngineVGui.h>
#include <filesystem.h>
#include <vgui/ISurface.h>
#include <vgui/ISystem.h>
#include <vgui_controls/Button.h>

using namespace vgui;

CSourceBridgeMainMenuPanel::CSourceBridgeMainMenuPanel(Panel *pParent)
    : BaseClass(pParent, "SourceBridgeMainMenuPanel")
    , m_pStartHostingButton(new Button(this, "StartHostingButton", "Start Hosting", this, "start_hosting"))
    , m_pOptionsButton(new Button(this, "OptionsButton", "Options", this, "open_options"))
    , m_pQuitButton(new Button(this, "QuitButton", "Quit", this, "quit_game"))
{
    SetProportional(true);
    SetKeyBoardInputEnabled(true);
    SetMouseInputEnabled(true);

    LoadControlSettings("resource/ui/SourceBridgeMainMenuPanel.res");
}

CSourceBridgeMainMenuPanel::~CSourceBridgeMainMenuPanel() = default;

void CSourceBridgeMainMenuPanel::ApplySchemeSettings(IScheme *pScheme)
{
    BaseClass::ApplySchemeSettings(pScheme);
}

void CSourceBridgeMainMenuPanel::OnCommand(const char *command)
{
    if (!Q_stricmp(command, "start_hosting"))
    {
        engine->ClientCmd_Unrestricted("map background01\n");
        return;
    }

    if (!Q_stricmp(command, "open_options"))
    {
        engine->ClientCmd_Unrestricted("gameui_activate; gamemenucommand OpenOptionsDialog\n");
        return;
    }

    if (!Q_stricmp(command, "quit_game"))
    {
        engine->ClientCmd_Unrestricted("quit\n");
        return;
    }

    BaseClass::OnCommand(command);
}
