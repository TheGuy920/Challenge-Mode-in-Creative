dofile("$CONTENT_ee7f6b44-e9e8-4636-89ce-e7f5fd41c070/Scripts/Core/Util.lua")
Player = class(nil)

function Player.server_onCreate(self)
	print("Player.server_onCreate")
	ChallengePlayer.server_onCreate(self)
	self.start = sm.game.getCurrentTick()
	sm.event.sendToGame("server_playerScriptReady", self.player)
end

function Player.server_updateGameRules(self, rules)
	if rules and rules.settings then
		self.lasting_health_rule = rules.settings.enable_health == true
	else
		self.lasting_health_rule = false
	end
end

function Player.server_playerJoined(self, data)
	self:server_updateGameState(data.state)
	if self.sv.spawnparams == nil then
		ChallengePlayer.sv_init(self)
	end
end

function Player.cl_n_startFadeToBlack(self, param)
	BasePlayer.cl_n_startFadeToBlack(self, param)
end

function Player.server_updateGameState(self, State, caller)
	if not sm.isServerMode() or caller ~= nil then
		return
	end
	self.state = State

	self.network:sendToClients("client_updateGameState", self.state)

	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		self.server_ready = false
		ChallengePlayer.server_onCreate(self)
		self.network:sendToClient(self.player, "_client_onCreate")
	elseif self.player ~= sm.player.getAllPlayers()[1] then
		sm.container.beginTransaction()
		local inv = self.player:getInventory()
		for i = 1, inv:getSize() do
			sm.container.setItem(inv, i - 1, sm.uuid.getNil(), 1)
		end
		sm.container.endTransaction()
	end
end

function Player.client_updateGameState(self, State, caller)
	if sm.isServerMode() or caller ~= nil then
		return
	end
	self.state = State
end

function Player.cl_n_onEvent(self, data)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		BasePlayer.cl_n_onEvent(self, data)
	end
end

function Player.client_getMode(self, tool)
	sm.event.sendToTool(tool, "client_setMode", self.state)
end

function Player.cl_n_onInventoryChanges(self, data)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.cl_n_onInventoryChanges(self, data)
	end
end

function Player._server_onCreate(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.server_onCreate(self)
		self.server_ready = true
	end
end

function Player._client_onCreate(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.client_onCreate(self)
		self.network:sendToServer("_server_onCreate")
	end
end

function Player.client_onCreate(self)
	ChallengePlayer.client_onCreate(self)
end

function Player.server_onDestroy(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.server_onDestroy(self)
	end
end

function Player.sv_updateTumbling(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		BasePlayer.sv_updateTumbling(self)
	end
end

function Player.client_onDestroy(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.client_onDestroy(self)
	end
end

function Player.server_onRefresh(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.server_onRefresh(self)
	end
end

function Player.client_onRefresh(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		BasePlayer.client_onRefresh(self)
	end
end

local waterSpeedFactor = 4
function Player.server_onFixedUpdate(self, timeStep)
	-- build mode
	if self.state == States.Build then
		if self.player.character ~= nil then
			if not self.player.character:isSwimming() then
				-- set thingies
				if sm.isHost then
					if self.player.character.publicData then
						self.player.character.publicData.waterMovementSpeedFraction = waterSpeedFactor
					end
				else
					if self.player.character.clientPublicData then
						self.player.character.clientPublicData.waterMovementSpeedFraction = waterSpeedFactor
					end
				end
				-- set swim
				self.player.character:setSwimming(true)
			end
		end
	end
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		if self.server_ready == true then
			ChallengePlayer.server_onFixedUpdate(self, timeStep)
		end
	end
end

function Player.sv_e_challengeReset(self)
	ChallengePlayer.sv_e_challengeReset(self)
end

function Player.sv_e_respawn(self)
	ChallengePlayer.sv_e_respawn(self)
end

function Player.client_onFixedUpdate(self, timeStep)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
	--ChallengePlayer.client_onFixedUpdate( self, timeStep )
	end
end

function Player.client_onUpdate(self, deltaTime)
	if self.client_updateGameState == nil then
		for index, value in pairs(Player) do
			local found = string.find(tostring(type(value)), "function")
			if found then
				print("DEFINED: ", index, value)
				self[index] = value
			end
		end
	end
	self.client_onUpdate = function( self, deltaTime )
		if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
			ChallengePlayer.client_onUpdate(self, deltaTime)
		end
	end
end

function Player.client_onClientDataUpdate(self, data)
	ChallengePlayer.client_onClientDataUpdate(self, data)
end

function Player.server_onProjectile(
	self,
	position,
	airTime,
	velocity,
	projectileName,
	shooter,
	damage,
	customData,
	normal,
	uuid)
	if self.state == States.Play or self.state == States.PlayBuild then
		ChallengePlayer.server_onProjectile(
			self,
			position,
			airTime,
			velocity,
			projectileName,
			shooter,
			damage,
			customData,
			normal,
			uuid
		)
	end
end

function Player.server_onExplosion(self, center, destructionLevel)
	if self.state == States.Play or self.state == States.PlayBuild then
		ChallengePlayer.server_onExplosion(self, center, destructionLevel)
	end
end

function Player.server_onMelee(self, position, attacker, damage, power, direction, normal)
	if self.state == States.Play or self.state == States.PlayBuild then
		BasePlayer.server_onMelee(self, position, attacker, damage, power, direction, normal)
	end
end

function Player.cl_n_endFadeToBlack(self, param)
	BasePlayer.cl_n_endFadeToBlack(self, param)
end

function Player.sv_e_onSpawnCharacter(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.sv_e_onSpawnCharacter(self)
	end
end

function Player.cl_localPlayerUpdate(self, dt)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.cl_localPlayerUpdate(self, position, attacker, damage, power, direction, normal)
	end
end

function Player.sv_takeDamage(self, damage, string)
	if self.state == States.Play or self.state == States.PlayBuild then
		ChallengePlayer.sv_takeDamage(self, damage, string)
	end
end

function Player.sv_init(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.sv_init(self)
	end
end

function Player.cl_init(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		BasePlayer.cl_init(self)
	end
end

function Player.server_onCollision(self, other, position, selfPointVelocity, otherPointVelocity, normal)
	if self.state == States.Play or self.state == States.PlayBuild then
		ChallengePlayer.server_onCollision(self, other, position, selfPointVelocity, otherPointVelocity, normal)
	end
end

function Player.server_onCollisionCrush(self)
	if self.state == States.Play or self.state == States.PlayBuild then
	--ChallengePlayer.server_onCollisionCrush( self )
	end
end

function Player.server_onShapeRemoved(self, items)
	--items = { { uuid = uuid, amount = integer, type = string }, .. }
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
	--ChallengePlayer.server_onShapeRemoved( self, items )
	end
end

function Player.server_onInventoryChanges(self, inventory, changes)
	--changes = { { uuid = Uuid, difference = integer, tool = Tool }, .. }
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		self.network:sendToClient(self.player, "cl_n_onInventoryChanges", {container = container, changes = changes})
	end
end

function Player.client_onInteract(self, character, state)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.client_onInteract(self, character, state)
	end
end

function Player.sv_n_tryRespawn(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.sv_n_tryRespawn(self, character, state)
	end
end

function Player.client_onCancel(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.client_onCancel(self)
	end
end

function Player.client_onReload(self)
	if self.state == States.Play or self.state == States.PlayBuild or self.state == States.Build then
		ChallengePlayer.client_onReload(self)
	end
end

function Player.cl_n_fillWater(self)
	BasePlayer.cl_n_fillWater(self)
end

function Player.server_destroyCharacter(self)
	--self.player:setCharacter(nil)
end

function Player._client_onLoadingScreenLifted(self)
	if self.state == States.PackMenu or self.state == States.PlayMenu then
		if self.player.character ~= nil then
			self.network:sendToServer("server_destroyCharacter")
		end
	end
end
