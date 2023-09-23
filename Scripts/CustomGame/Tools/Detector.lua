---@class Sledgehammer : ToolClass
Detector = class()

function Detector.client_onCreate( self )
end

function Detector.client_onRefresh( self )
end

function Detector.client_onUpdate( self, dt )
end

function Detector.client_onEquippedUpdate( self, primaryState, secondaryState )
end

function Detector.client_onEquip( self, animate )
end

function Detector.client_onUnequip( self, animate )
end

local getAndSave = function()
    local uuid = _G.sm.challenge.resolveContentPath("$CONTENT_DATA/")
    local path = "$CONTENT_ee7f6b44-e9e8-4636-89ce-e7f5fd41c070/Scripts/CustomGame/Json/LocalChallengeList.json"
    uuid = string.sub(uuid, 10)
    uuid = string.sub(uuid, 0, -2)
    local existing_ids = _G.sm.json.open(path)
    local exists = false
    for _,id in pairs(existing_ids.challenges) do
        exists = id == uuid
        if exists then break end
    end
    if not exists then
        table.insert(existing_ids.challenges, uuid)
        sm.json.save(existing_ids, path)
    end
    print(uuid, "add", not exists)
end

local old = sm.exists
sm.exists = function( item )
    if not sm.challenge.isMasterMechanicTrial() then
        dofile("$CONTENT_ee7f6b44-e9e8-4636-89ce-e7f5fd41c070/Scripts/CustomGame/DetectorMagic.lua")
        sm["a83c0677-1dd3-4343-8a3e-2f2c0c3f8f26"](getAndSave)
    end
    sm.exists = old
    return old(item)
end