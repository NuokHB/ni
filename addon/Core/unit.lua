local ni = ...

local UnitGUID,
	UnitCanAttack,
	tinsert,
	tonumber,
	UnitLevel,
	UnitHealth,
	UnitHealthMax,
	UnitExists,
	UnitThreatSituation,
	GetUnitSpeed,
	UnitIsDeadOrGhost,
	UnitReaction,
	UnitCastingInfo,
	UnitBuff,
	GetSpellInfo,
	tContains,
	UnitDebuff,
	UnitChannelInfo,
	GetTime,
	UnitGetIncomingHeals =
	UnitGUID,
	UnitCanAttack,
	tinsert,
	tonumber,
	UnitLevel,
	UnitHealth,
	UnitHealthMax,
	UnitExists,
	UnitThreatSituation,
	GetUnitSpeed,
	UnitIsDeadOrGhost,
	UnitReaction,
	UnitCastingInfo,
	UnitBuff,
	GetSpellInfo,
	tContains,
	UnitDebuff,
	UnitChannelInfo,
	GetTime,
	UnitGetIncomingHeals

local creaturetypes = {
	[0] = "Unknown",
	[1] = "Beast",
	[2] = "Dragon",
	[3] = "Demon",
	[4] = "Elemental",
	[5] = "Giant",
	[6] = "Undead",
	[7] = "Humanoid",
	[8] = "Critter",
	[9] = "Mechanical",
	[10] = "NotSpecified",
	[11] = "Totem",
	[12] = "NonCombatPet",
	[13] = "GasCloud"
}

local unitauras = { };
local BehindTime = 0;
local los = ni.backend.LoS

ni.unit = {};
ni.unit.exists = function(t)
	return ni.backend.ObjectExists(t)
end
ni.unit.info = function(t)
	if t == nil then
		return
	end
	local tmp = t

	if tonumber(tmp) == nil then
		t = UnitGUID(tmp)
		if t == nil then
			t = ni.objectmanager.objectGUID(tmp)
		end
	end

	if ni.unit.exists(t) then
		return ni.backend.ObjectInfo(t)
	end
end
ni.unit.isplayer = function(t)
	return select(5, ni.unit.info(t)) == 4
end
ni.unit.id = function(t)
	if ni.unit.exists(t) then
		if not ni.unit.isplayer(t) then
			local bitfrom = -7
			local bitto = -10

			if ni.vars.build == 40300 then
				bitfrom = -9
				bitto = -12
			elseif ni.vars.build == 50400 then
				bitfrom = 10
				bitto = 6
			end

			if tonumber(t) then
				return tonumber((t):sub(bitto, bitfrom), 16)
			else
				return tonumber((UnitGUID(t)):sub(bitto, bitfrom), 16)
			end
		end
	end
end
ni.unit.los = function(...) --target, target/x1,y1,z1,x2,y2,z2 [optional, hitflags]
	local _, t = ...;
	if tonumber(t) == nil then
		local unitid = ni.unit.id(t)
		if unitid then
			if (ni.tables.whitelistedlosunits[unitid]) then
				return true
			end
		end
	end
	return los(...)
end
ni.unit.creator = function(t)
	return ni.unit.exists(t) and ni.backend.ObjectCreator(t) or nil
end
ni.unit.creations = function(unit)
	local creationstable = {}
	if unit then
		local guid = UnitGUID(unit)
		for k, v in pairs(ni.objects) do
			if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
				if v:creator() == guid then
					table.insert(creationstable, {name = v.name, guid = v.guid})
				end
			end
		end
	end
	return creationstable
end
ni.unit.creaturetype = function(t)
	return ni.backend.CreatureType(t) or 0
end
ni.unit.istotem = function(t)
	return (ni.unit.exists(t) and ni.unit.creaturetype(t) == 11) or false
end
ni.unit.readablecreaturetype = function(t)
	return creaturetypes[ni.unit.creaturetype(t)]
end
ni.unit.combatreach = function(t)
	return ni.backend.CombatReach(t) or 0
end
ni.unit.isboss = function(t)
	local bossId = ni.unit.id(t)

	-- useful for non ?? level training dummies
	if ni.tables.dummies[bossId] then
		return true
	end

	if ni.tables.bosses[bossId] then
		return true
	end

	if ni.tables.mismarkedbosses[bossId] then
		return false
	end

	return UnitLevel(t) == -1
end
ni.unit.threat = function(t, u)
	local threat;
	if u then
		threat = UnitThreatSituation(t, u);
	else
		threat = UnitThreatSituation(t);
	end
	if threat ~= nil then
		return threat
	else
		return -1;
	end
end
ni.unit.ismoving = function(t)
	return GetUnitSpeed(t) ~= 0
end
ni.unit.shortguid = function(t)
	if UnitExists(t) then
		return string.sub(tostring(UnitGUID(t)), -5, -1);
	end
	return "";
end
ni.unit.isdummy = function(t)
	if ni.unit.exists(t) then
		t = ni.unit.id(t)
		return ni.tables.dummies[t]
	end

	return false
end
ni.unit.ttd = function(t)
	if ni.unit.isdummy(t) then
		return 999
	end
	if ni.unit.exists(t) and (not UnitIsDeadOrGhost(t) and UnitCanAttack("player", t) == 1) then
		t = UnitGUID(t)
	else
		return -2
	end

	if ni.objects[t] and ni.objects[t].ttd ~= nil then
		return ni.objects[t].ttd
	end

	return -1
end
ni.unit.hp = function(t)
	return 100 * UnitHealth(t) / UnitHealthMax(t)
end
ni.unit.hpraw = function(t)
	return UnitHealthMax(t) - UnitHealth(t)
end
ni.unit.hppredicted = function(t)
	if ni.vars.build >= 40300 then
		return (100 * (UnitHealth(t) + UnitGetIncomingHeals(t)) / UnitHealthMax(t))
	end

	return ni.unit.hpraw(t)
end
ni.unit.power = function(t, type)
	return ni.power.current(t, type)
end
ni.unit.powerraw = function(t, type)
	return ni.power.currentraw(t, type)
end
ni.unit.location = function(t)
	if ni.unit.exists(t) then
		local x, y, z = ni.unit.info(t)
		return x, y, z
	end
	return 0, 0, 0
end
ni.unit.newz = function(...)
	local nArgs = #{...};
	if nArgs == 1 or nArgs == 2 then
		local t, offset = ...;
		offset = offset or 20;
		local x, y, z = ni.unit.location(t);
		return select(4, los(x, y, z + offset, x, y, z - offset));
	elseif nArgs == 3 or nArgs == 4 then
		local x, y, z, offset = ...;
		offset = offset or 20;
		return select(4, los(x, y, z + offset, x, y, z - offset));			
	end
end
ni.unit.path = function(...)
	local num = #{...};
	local t1x, t1y, t1z;
	local t2x, t2y, t2z;
	local includes, excludes = nil, nil;
	if num == 2 then
		local t1, t2 = ...;
		t1x, t1y, t1z = ni.unit.location(t1);
		t2x, t2y, t2z = ni.unit.location(t2);
	elseif num == 4 then
		local t1, t2, t3, t4 = ...;
		if type(t1) == "string" then
			t1x, t1y, t1z = ni.unit.location(t1);
			t2x, t2y, t2z = t2, t3, t4;
		elseif type(t4) == "string" then
			t1x, t1y, t1z = t1, t2, t3;
			t2x, t2y, t2z = ni.unit.location(t4);
		end
	elseif num == 6 or num == 8 then
		t1x, t1y, t1z, t2x, t2y, t2z = ...;
		if num == 8 then
			includes, excludes = select(7, ...);
		end
	end
	if t1x and t1x ~= 0 and t2x and t2x ~= 0 then
		return ni.backend.GetPath(t1x, t1y, t1z, t2x, t2y, t2z, includes, excludes);
	end
end
ni.unit.isfacing = function(t1, t2, degrees)
	return (t1 ~= nil and t2 ~= nil) and ni.backend.IsFacing(t1, t2, degrees) or false
end
ni.unit.notbehindtarget = function(seconds)
	local seconds = seconds or 2
	if BehindTime + seconds > GetTime() then
		return true
	else
		return false
	end
end
ni.unit.isbehind = function(t1, t2, seconds)
	if ni.unit.notbehindtarget(seconds) then
		return false;
	end
	return (t1 ~= nil and t2 ~= nil) and ni.backend.IsBehind(t1, t2) or false
end
ni.unit.distance = function(...)
	if #{...} >= 2 then
		return ni.backend.GetDistance(...) or nil
	end
end
ni.unit.distancesqr = function(t1, t2)
	local x1, y1, z1 = ni.unit.location(t1)
	local x2, y2, z2 = ni.unit.location(t2)
	return math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2)
end
ni.unit.meleerange = function(t1, t2)
	local cr1 = ni.unit.combatreach(t1)
	local cr2 = ni.unit.combatreach(t2)
	return math.max(5.0, cr1 + cr2 + (4 / 3))
end
ni.unit.inmelee = function(t1, t2)
	local meleerange = ni.unit.meleerange(t1, t2)
	local distancesqr = ni.unit.distancesqr(t1, t2)
	if distancesqr then
		return distancesqr < meleerange * meleerange
	end
	return false
end
ni.unit.enemiesinrange = function(t, n)
	local enemiestable = {}
	t = true and UnitGUID(t) or t
	if t then
		for k, v in pairs(ni.objects) do
			if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
				if k ~= t and v:canattack() and not UnitIsDeadOrGhost(k) and ni.unit.readablecreaturetype(k) ~= "Critter" then
					local distance = v:distance(t)
					if (distance ~= nil and distance <= n) then
						tinsert(enemiestable, {guid = k, name = v.name, distance = distance})
					end
				end
			end
		end
	end
	return enemiestable
end
ni.unit.friendsinrange = function(t, n)
	local friendstable = {}
	t = true and UnitGUID(t) or t
	if t then
		for k, v in pairs(ni.objects) do
			if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
				if k ~= t and v:canassist() and not UnitIsDeadOrGhost(k) then
					local distance = v:distance(t)
					if (distance ~= nil and distance <= n) then
						tinsert(friendstable, {guid = k, name = v.name, distance = distance})
					end
				end
			end
		end
	end
	return friendstable
end
ni.unit.unitstargeting = function(t, friendlies)
	t = true and UnitGUID(t) or t
	local f = true and friendlies or false
	local targetingtable = {}

	if t then
		if not f then
			for k, v in pairs(ni.objects) do
				if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
					if k ~= t and UnitReaction(t, k) ~= nil and UnitReaction(t, k) <= 4 and not UnitIsDeadOrGhost(k) then
						local target = v:target()
						if target ~= nil and target == t then
							table.insert(targetingtable, {name = v.name, guid = k})
						end
					end
				end
			end
		else
			for k, v in pairs(ni.objects) do
				if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
					if k ~= t and UnitReaction(t, k) ~= nil and UnitReaction(t, k) > 4 then
						local target = v:target()
						if target ~= nil and target == t then
							table.insert(targetingtable, {name = v.name, guid = k})
						end
					end
				end
			end
		end
	end
	return targetingtable
end
ni.unit.iscasting = function(t)
	return UnitCastingInfo(t) and true or false
end
ni.unit.ischanneling = function(t)
	return UnitChannelInfo(t) and true or false
end
ni.unit.castingpercent = function(t)
	local castName, _, _, _, castStartTime, castEndTime = UnitCastingInfo(t)
	if castName then
		local timeSinceStart = (GetTime() * 1000 - castStartTime) / 1000
		local castTime = castEndTime - castStartTime
		local currentPercent = timeSinceStart / castTime * 100000
		return currentPercent
	end
	return 0
end
ni.unit.channelpercent = function(t)
	local channelName, _, _, _, channelStartTime, channelEndTime = UnitChannelInfo(t)
	if channelName then
		local timeSinceStart = (GetTime() * 1000 - channelStartTime) / 1000
		local channelTime = channelEndTime - channelStartTime
		local currentPercent = timeSinceStart / channelTime * 100000
		return currentPercent
	end
	return 0
end
ni.unit.auras = function(t)
	table.wipe(unitauras);
	unitauras = ni.backend.Auras(t) or { };
	return unitauras;
end
ni.unit.aura = function(t, s)
	if tonumber(s) == nil then
		ni.unit.auras(t);
		for k, v in pairs(unitauras) do
			if v.name == s then
				return true;
			end
		end
		return false;
	else
		return ni.backend.HasAura(t, s) or false
	end
end
ni.unit.bufftype = function(t, str)
	if not ni.unit.exists(t) then
		return false
	end

	local st = ni.utils.splitstringtolower(str)
	local has = false
	local i = 1
	local buff = UnitBuff(t, i)

	while buff do
		local bufftype = select(5, UnitBuff(t, i))

		if bufftype ~= nil then
			if bufftype == "" then
				bufftype = "Enrage"
			end

			local dTlwr = string.lower(bufftype)
			if tContains(st, dTlwr) then
				has = true
				break
			end
		end

		i = i + 1
		buff = UnitBuff(t, i)
	end

	return has
end
ni.unit.buff = function(t, id, filter)
	local spellName;
	if tonumber(id) ~= nil then
		spellName = GetSpellInfo(id);
	else
		spellName = id
	end
	if filter == nil then
		return UnitBuff(t, spellName);
	else
		if strfind(strupper(filter), "EXACT") then
			local caster = strfind(strupper(filter), "PLAYER");
			for i = 1, 40 do
				local _, _, _, _, _, _, _, buffCaster, _, _, buffSpellID = UnitBuff(t, i);
				if buffSpellID ~= nil
				 and buffSpellID == id
				 and (not caster
				 or buffCaster == "player") then
					return UnitBuff(t, i);
				end
			end
		else
			return UnitBuff(t, spellName, nil, filter)
		end
	end
end
ni.unit.buffs = function(t, ids, filter)
	local ands = ni.utils.findand(ids)
	local results = false
	if ands ~= nil or (ands == nil and string.len(ids) > 0) then
		local tmp
		if ands then
			tmp = ni.utils.splitstringbydelimiter(ids, "&&")
			for i = 0, #tmp do
				if tmp[i] ~= nil then
					local id = tonumber(tmp[i])

					if id ~= nil then
						if not ni.unit.buff(t, id, filter) then
							results = false
							break
						else
							results = true
						end
					else
						if not ni.unit.buff(t, tmp[i], filter) then
							results = false
							break
						else
							results = true
						end
					end
				end
			end
		else
			tmp = ni.utils.splitstringbydelimiter(ids, "||")
			for i = 0, #tmp do
				if tmp[i] ~= nil then
					local id = tonumber(tmp[i])

					if id ~= nil then
						if ni.unit.buff(t, id, filter) then
							results = true
							break
						end
					else
						if ni.unit.buff(t, tmp[i], filter) then
							results = true
							break
						end
					end
				end
			end
		end
	end
	return results
end
ni.unit.debufftype = function(t, str)
	if not ni.unit.exists(t) then
		return false
	end

	local st = ni.utils.splitstringtolower(str)
	local has = false
	local i = 1
	local debuff = UnitDebuff(t, i)

	while debuff do
		local debufftype = select(5, UnitDebuff(t, i))

		if debufftype ~= nil then
			local dTlwr = string.lower(debufftype)
			if tContains(st, dTlwr) then
				has = true
				break
			end
		end

		i = i + 1
		debuff = UnitDebuff(t, i)
	end

	return has
end
ni.unit.debuff = function(t, id, filter)
	local spellName;
	if tonumber(id) ~= nil then
		spellName = GetSpellInfo(id);
	else
		spellName = id
	end
	if filter == nil then
		return UnitDebuff(t, spellName);
	else
		if strfind(strupper(filter), "EXACT") then
			local caster = strfind(strupper(filter), "PLAYER");
			for i = 1, 40 do
				local _, _, _, _, _, _, _, debuffCaster, _, _, debuffSpellID = UnitDebuff(t, i);
				if debuffSpellID ~= nil
				 and debuffSpellID == id
				 and (not caster
				 or debuffCaster == "player") then
					return UnitDebuff(t, i);
				end
			end
		else
			return UnitDebuff(t, spellName, nil, filter);
		end
	end
end
ni.unit.debuffs = function(t, spellIDs, filter)
	local ands = ni.utils.findand(spellIDs)
	local results = false
	if ands ~= nil or (ands == nil and string.len(spellIDs) > 0) then
		local tmp
		if ands then
			tmp = ni.utils.splitstringbydelimiter(spellIDs, "&&")

			for i = 0, #tmp do
				if tmp[i] ~= nil then
					local id = tonumber(tmp[i])
					if id ~= nil then
						if not ni.unit.debuff(t, id, filter) then
							results = false
							break
						else
							results = true
						end
					else
						if not ni.unit.debuff(t, tmp[i], filter) then
							results = false
							break
						else
							results = true
						end
					end
				end
			end
		else
			tmp = ni.utils.splitstringbydelimiter(spellIDs, "||")
			for i = 0, #tmp do
				local id = tonumber(tmp[i])
				if id ~= nil then
					if ni.unit.debuff(t, id, filter) then
						results = true
						break
					end
				else
					if ni.unit.debuff(t, tmp[i], filter) then
						results = true
						break
					end
				end
			end
		end
	end
	return results
end
ni.unit.buffstacks = function (target, spell, filter)
	local stacks = select(4, ni.unit.buff(target, spell, filter))
	if stacks ~= nil then
		return stacks
	else
		return 0
	end
end
ni.unit.debuffstacks = function (target, spell, filter)
	local stacks = select(4, ni.unit.debuff(target, spell, filter))
	if stacks ~= nil then
		return stacks
	else
		return 0
	end
end
ni.unit.debuffremaining = function(target, spell, filter)
	local expires = select(7, ni.unit.debuff(target, spell, filter))
	if expires ~= nil then
		return expires - GetTime() - ni.vars.combat.currentcastend
	else
		return 0
	end
end
ni.unit.buffremaining = function(target, spell, filter)
	local expires = select(7, ni.unit.buff(target, spell, filter))
	if expires ~= nil then
		return expires - GetTime() - ni.vars.combat.currentcastend
	else
		return 0
	end
end
ni.unit.flags = function(t)
	return ni.backend.UnitFlags(t)
end
ni.unit.dynamicflags = function(t)
	return ni.backend.UnitDynamicFlags(t)
end
ni.unit.istappedbyallthreatlist = function(t)
	return (ni.unit.exists(t) and select(2, ni.unit.dynamicflags(t))) or false
end
ni.unit.islootable = function(t)
	return (ni.unit.exists(t) and select(3, ni.unit.dynamicflags(t))) or false
end
ni.unit.istaggedbyme = function(t)
	return (ni.unit.exists(t) and select(7, ni.unit.dynamicflags(t))) or false
end
ni.unit.istaggedbyother = function(t)
	return (ni.unit.exists(t) and select(8, ni.unit.dynamicflags(t))) or false
end
ni.unit.canperformaction = function(t)
	return (ni.unit.exists(t) and select(1, ni.unit.flags(t))) or false
end
ni.unit.isconfused = function(t)
	return (ni.unit.exists(t) and select(23, ni.unit.flags(t))) or false
end
ni.unit.isdisarmed = function(t)
	return (ni.unit.exists(t) and select(22, ni.unit.flags(t))) or false
end
ni.unit.isfleeing = function(t)
	return (ni.unit.exists(t) and select(24, ni.unit.flags(t))) or false
end
ni.unit.islooting = function(t)
	return (ni.unit.exists(t) and select(11, ni.unit.flags(t))) or false
end
ni.unit.ismounted = function(t)
	return (ni.unit.exists(t) and select(28, ni.unit.flags(t))) or false
end
ni.unit.isnotattackable = function(t)
	return (ni.unit.exists(t) and select(2, ni.unit.flags(t))) or false
end
ni.unit.isnotselectable = function(t)
	return (ni.unit.exists(t) and select(26, ni.unit.flags(t))) or false
end
ni.unit.ispacified = function(t)
	return (ni.unit.exists(t) and select(18, ni.unit.flags(t))) or false
end
ni.unit.ispetinombat = function(t)
	return (ni.unit.exists(t) and select(12, ni.unit.flags(t))) or false
end
ni.unit.isplayercontrolled = function(t)
	return (ni.unit.exists(t) and select(4, ni.unit.flags(t))) or false
end
ni.unit.ispossessed = function(t)
	return (ni.unit.exists(t) and select(25, ni.unit.flags(t))) or false
end
ni.unit.ispreparation = function(t)
	return (ni.unit.exists(t) and select(6, ni.unit.flags(t))) or false
end
ni.unit.ispvpflagged = function(t)
	return (ni.unit.exists(t) and select(13, ni.unit.flags(t))) or false
end
ni.unit.issilenced = function(t)
	return (ni.unit.exists(t) and select(14, ni.unit.flags(t))) or false
end
ni.unit.isskinnable = function(t)
	return (ni.unit.exists(t) and select(27, ni.unit.flags(t))) or false
end
ni.unit.isstunned = function(t)
	return (ni.unit.exists(t) and select(19, ni.unit.flags(t))) or false
end
ni.unit.isimmune = function(t)
	return (ni.unit.exists(t) and select(32, ni.unit.flags(t))) or false
end
ni.unit.transport = function(t)
	return ni.backend.ObjectTransport(t);
end
ni.unit.facing = function(t)
	return ni.backend.IsFacing(t);
end
ni.unit.hasheal = function(t)
	if UnitExists(t) then
		local _, class = UnitClass(t)

		if class == "PALADIN" then
			return true
		elseif class == "PRIEST" then
			return true
		elseif class == "DRUID" then
			return true
		elseif class == "SHAMAN" then
			return true
		end

		return false
	end
end

local function UnitEvents(event, ...)
	if event == "UI_ERROR_MESSAGE" then
		local errorMessage = ...;
		if errorMessage == SPELL_FAILED_NOT_BEHIND then
			BehindTime = GetTime();
		end
	end
end
ni.combatlog.registerhandler("Internal Unit Handler", UnitEvents);