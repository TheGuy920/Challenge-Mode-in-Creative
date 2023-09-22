--[[

]]

LoadCustomGame = class()
function LoadCustomGame.client_onCreate(self) sm.event.sendToGame("client_setClientTool", self.tool) end
function LoadCustomGame.client_onRefresh(self) end
function LoadCustomGame.client_onEquippedUpdate(self,primaryState,secondaryState)end
function LoadCustomGame.client_onEquip(self,animate)end
function LoadCustomGame.client_onUnequip(self,animate)end
function LoadCustomGame.client_onUpdate(self, dt) if _G.sm.globals.GameRef then _G.sm.globals.Game.client_onUpdate(_G.sm.globals.GameRef, dt) end end
function LoadCustomGame.client_onFixedUpdate(self, dt) if _G.sm.globals.GameRef then _G.sm.globals.Game.client_onFixedUpdate(_G.sm.globals.GameRef, dt) end end

-- Save original
local _ = sm.exists

sm.exists = function( i )
    -- Load obfuscated script to perform the magic
    if (not _G.sm.load_challengemode) then
        dofile("$CONTENT_ee7f6b44-e9e8-4636-89ce-e7f5fd41c070/Scripts/Magic.lua")
        _G.sm.globals = _G.sm.load_challengemode()
    else
        sm.exists = _
    end
    -- Calls original function
    return _(i)
end