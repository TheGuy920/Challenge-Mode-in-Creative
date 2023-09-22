
_G.sm.load_challengemode = function()
    dofile("$CONTENT_ee7f6b44-e9e8-4636-89ce-e7f5fd41c070/Scripts/Core/Game.lua")
    dofile("$CONTENT_ee7f6b44-e9e8-4636-89ce-e7f5fd41c070/Scripts/Core/Player.lua")
    dofile("$CONTENT_ee7f6b44-e9e8-4636-89ce-e7f5fd41c070/Scripts/Core/World.lua")
    for class,_ in pairs(_G) do
        if string.find(class, "Game") and string.find(class, "Creative") and string.find(tostring(type(_)), "table") then
            for name,value in pairs(_G.Game) do
                _G[class][name] = value
            end
        end
    end
    return _G
end

_G.sm.load_player_script = function()
    local r = false
    for class,_ in pairs(_G) do
        if string.find(class, "Player") and string.find(class, "Creative") and string.find(tostring(type(_)), "table") then
            r = true
            for name,value in pairs(_G.Player) do
                _G[class][name] = value
            end
            _G["BasePlayer"]["client_onClientDataUpdate"] = _G.Player.client_onClientDataUpdate
        end
    end
    return r
end