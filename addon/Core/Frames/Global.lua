local CreateFrame,
	GetZoneText,
	UnitExists,
	UnitGUID,
	UnitAffectingCombat,
	IsMounted,
	UnitIsUnit,
	UnitCastingInfo,
	UnitChannelInfo,
	GetTime,
	tremove,
	tinsert,
	unpack =
	CreateFrame,
	GetZoneText,
	UnitExists,
	UnitGUID,
	UnitAffectingCombat,
	IsMounted,
	UnitIsUnit,
	UnitCastingInfo,
	UnitChannelInfo,
	GetTime,
	tremove,
	tinsert,
	unpack

local lastclick = 0;
local totalelapsed = 0;
ni.frames.global = CreateFrame("Frame")
ni.frames.global_OnUpdate = function(self, elapsed)
	if UnitExists == nil or ni.functions.cast == nil or not GetZoneText() then
		totalelapsed = 0;
		return true
	end

	if select(11, ni.player.debuff(9454)) == 9454 then
		return true
	end

	if ni.vars.profiles.enabled then
		if ni.vars.combat.aoe or ni.vars.combat.cd and not ni.frames.notification:IsShown() then
			local aoe_str = ni.vars.combat.aoe and "\124cff00ff00Enabled" or "\124cffff0000Disabled";
			local cd_str = ni.vars.combat.cd and "\124cff00ff00Enabled" or "\124cffff0000Disabled";
			ni.frames.notification:message("\124cffFFC300AoE: "..aoe_str.." \124cffFFC300CD: "..cd_str);
		end
		ni.rotation.aoetoggle()
		ni.rotation.cdtoggle()
	else
		if ni.frames.notification:IsShown() then
			ni.frames.notification:Hide();
		end
	end

	local throttle = ni.vars.latency / 1000
	totalelapsed = totalelapsed + elapsed;
	self.st = elapsed + (self.st or 0)

	if self.st > throttle then
		totalelapsed = totalelapsed - throttle;
		self.st = 0

		if ni.vars.units.followEnabled then
			if ni.objectmanager.contains(ni.vars.units.follow) or UnitExists(ni.vars.units.follow) then
				local unit = ni.vars.units.follow
				local uGUID = ni.objectmanager.objectGUID(unit) or UnitGUID(unit)
				local followTar = nil
				local distance = nil

				if UnitAffectingCombat(uGUID) then
					local oTar = select(6, ni.unit.info(uGUID))
					if oTar ~= nil then
						followTar = oTar
					end
				end

				distance = ni.player.distance(uGUID)

				if not IsMounted() then
					if followTar ~= nil and ni.vars.combat.melee == true then
						distance = ni.player.distance(followTar)
						uGUID = followTar
					end
				end

				if followTar ~= nil then
					if not UnitIsUnit("target", followTar) then
						ni.player.target(followTar)
					end
				end

				if not ni.player.isfacing(uGUID) then
					ni.player.lookat(uGUID)
				end

				if
					not UnitCastingInfo("player") and not UnitChannelInfo("player") and distance ~= nil and distance > 1 and
						distance < 50 and
						GetTime() - lastclick > 1.5
				 then
					ni.player.moveto(uGUID)
					lastclick = GetTime()
				end

				if distance ~= nil and distance <= 1 and ni.player.ismoving() then
					ni.player.stopmoving()
				end
			end
		end

		if ni.vars.profiles.enabled or ni.vars.profiles.genericenabled then
			ni.player.registermovement(totalelapsed);
			if ni.vars.profiles.delay > GetTime() then
				return true;
			end
			if not ni.rotation.started then
				ni.rotation.started = true
			end
			if ni.vars.profiles.useEngine then
				ni.members:updatemembers()
			end
			if ni.rotation.stopmod() then
				return true
			end
			local count = #ni.spell.queue
			local i = 1
			while i <= count do
				local qRec = tremove(ni.spell.queue, i)
				local func = tremove(qRec, 1)
				local args = tremove(qRec, 1)
				local id, tar = unpack(args)
				ni.frames.spellqueue.update(id, true)

				if ni.spell.available(id) and ((not ni.spell.isinstant(id) and not ni.player.ismoving()) or ni.spell.isinstant(id)) then
					count = count - 1
					func(id, tar)
				else
					tinsert(ni.spell.queue, i, {func, args})
					i = i + 1
				end
			end
			if #ni.spell.queue == 0 then
				ni.frames.spellqueue.update()
			end
			if ni.vars.profiles.genericenabled then
				if ni.vars.profiles.generic ~= "none" and ni.vars.profiles.generic ~= "None" then
					if ni.rotation.profile[ni.vars.profiles.generic] then
						ni.rotation.profile[ni.vars.profiles.generic]:execute()
					end
				end
			end
			if ni.vars.profiles.enabled then
				if ni.vars.profiles.active ~= "none" and ni.vars.profiles.active ~= "None" then
					if ni.rotation.profile[ni.vars.profiles.active] then
						ni.rotation.profile[ni.vars.profiles.active]:execute()
					end
				end
			end
		else
			if ni.rotation.started then
				ni.rotation.started = false
			end
		end
	end
end
