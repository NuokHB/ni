local ni = ...

local GetNumRaidMembers, GetNumPartyMembers, tinsert, UnitClass, UnitIsDeadOrGhost, UnitHealthMax, UnitName, UnitGUID =
	GetNumRaidMembers,
	GetNumPartyMembers,
	tinsert,
	UnitClass,
	UnitIsDeadOrGhost,
	UnitHealthMax,
	UnitName,
	UnitGUID

ni.members = {};
local memberssetup = {}
memberssetup.cache = {}
memberssetup.__index = {
	unit = "noob",
	name = "noob",
	class = "noob",
	guid = 0,
	shortguid = 0,
	role = "NOOB",
	range = false,
	dispel = false,
	hp = 100,
	threat = 0,
	target = "noobtarget",
	istank = false
}
memberssetup.cache.__index = {
	guid = 0,
	name = "Unknown",
	type = 0
}
local membersmt = {}
setmetatable(ni.members, membersmt)
membersmt.__call = function(_, ...)
	if ni.vars.build == 50400 then
		local group = IsInRaid() and "raid" or "party"
		local groupSize = IsInRaid() and GetNumGroupMembers() or GetNumGroupMembers() - 1
		if group == "party" then
			tinsert(ni.members, memberssetup:create("player"))
		end
		for i = 1, groupSize do
			local groupUnit = group .. i
			local groupMember = memberssetup:create(groupUnit)
			if groupMember then
				tinsert(ni.members, groupMember)
			end
		end
	else
		local group = GetNumRaidMembers() > 0 and "raid" or "party"
		local groupsize = group == "raid" and GetNumRaidMembers() or GetNumPartyMembers()
		if group == "party" then
			tinsert(ni.members, memberssetup:create("player"))
		end
		for i = 1, groupsize do
			local groupunit = group .. i
			local groupmember = memberssetup:create(groupunit)
			if groupmember then
				tinsert(ni.members, groupmember)
			end
		end
	end
end
membersmt.__index = {
	name = "members",
	author = "bubba"
}

function memberssetup:create(unit)
	if memberssetup.cache[ni.unit.shortguid(unit)] then
		return false
	end
	local o = {}
	setmetatable(o, memberssetup)
	if unit and type(unit) == "string" then
		o.unit = unit
	end
	function o:calculateistank()
		local oclass = select(2, UnitClass(o.unit));
		if oclass == "WARRIOR" and ni.unit.aura(o.guid, 71) then
			return true;
		elseif oclass == "DRUID" and (ni.unit.buff(o.unit, 9634, "EXACT") or ni.unit.buff(o.unit, 5487, "EXACT"))	then
			return true;
		elseif oclass == "PALADIN" and ni.unit.buff(o.unit, 25780) then
			return true;
		elseif ni.unit.aura(o.guid, 57340) then
			return true;
		elseif UnitGroupRolesAssigned(o.guid) == "TANK" then
			return true;
		end
		return false
	end
	function o:debufftype(str)
		return ni.unit.debufftype(o.guid, str)
	end
	function o:bufftype(str)
		return ni.unit.bufftype(o.guid, str)
	end
	function o:buff(buff, filter)
		return ni.unit.buff(o.guid, buff, filter)
	end
	function o:debuff(debuff, filter)
		return ni.unit.debuff(o.guid, debuff, filter)
	end
	function o:candispel()
		return ni.healing.candispel(o.unit)
	end
	function o:calculatehp()
		local hp = ni.unit.hp(o.unit)
		local hpraw = ni.unit.hpraw(o.unit)

		if o.istank then
			hp = hp - 5
		end
		if UnitIsDeadOrGhost(o.unit) == 1 then
			hp = 250
		end
		if o.dispel then
			hp = hp - 2
		end
		for i = 1, #ni.tables.cantheal do
			if ni.unit.debuff(o.unit, ni.tables.cantheal[i]) then
				hp = 100
				hpraw = UnitHealthMax(o.unit)
			end
		end
		for i = 1, #ni.tables.notneedheal do
			if ni.unit.buff(o.unit, ni.tables.notneedheal[i]) then
				hp = 100
				hpraw = UnitHealthMax(o.unit)
			end
		end
		return hp, hpraw
	end
	function o:inrange()
		if ni.unit.exists(o.guid) and ni.player.los(o.guid) then
			local dist = ni.player.distance(o.guid)
			if (dist ~= nil and dist < 40) then
				return true;
			else
				return false;
			end
		end
		return false;
	end
	function o:updatemember()
		o.name = UnitName(o.unit)
		o.class = select(2, UnitClass(o.unit))
		o.guid = UnitGUID(o.unit)
		o.shortguid = ni.unit.shortguid(o.unit)
		o.range = o:inrange()
		o.dispel = o:candispel()
		o.hp = o:calculatehp()
		o.threat = ni.unit.threat(o.unit)
		o.target = tostring(o.unit) .. "target"
		o.istank = o:calculateistank()
		memberssetup.cache[ni.unit.shortguid(o.unit)] = o
	end
	memberssetup.cache[ni.unit.shortguid(o.unit)] = o
	return o
end
local membersrange = { };
local membersbelow = { };
local memberswithbuff = { };
local memberswithbuffbelow = { };
local memberswithoutbuff = { };
local memberswithoutbuffbelow = { };
local memberswithdebuff = { };
local memberswithdebuffbelow = { };
local memberswithoutdebuff = { };
local memberswithoutdebuffbelow = { };

memberssetup.set = function()
	function ni.members:updatemembers()
		for i = 1, #ni.members do
			ni.members[i]:updatemember()
		end

		table.sort(
			ni.members,
			function(x, y)
				if x.range and y.range then
					return x.hp < y.hp
				elseif x.range then
					return true
				elseif y.range then
					return false
				else
					return x.hp < y.hp
				end
			end
		)
	end
	function ni.members.reset()
		table.wipe(ni.members)
		table.wipe(memberssetup.cache)
		memberssetup.set()
	end
	function ni.members.below(percent)
		local total = 0;
		for i = 1, #ni.members do
			if ni.members[i].hp < percent then
				total = total + 1;
			end
		end
		return total;
	end
	function ni.members.average()
		local count = #ni.members;
		local average = 0;
		for i = 1, count do
			average = average + ni.members[i].hp;
		end
		return average/count;
	end
	function ni.members.averageof(count)
		local m = count;
		local average = 0;
		if #ni.members < m then
			for i = m, 0, -1 do
				if #ni.members >= i then
					m = i;
					break;
				end
			end
		end
		for i = 1, m do
			average = average + ni.members[i].hp;
		end
		return average/m;
	end
	function ni.members.inrange(unit, distance)
		table.wipe(membersrange);
		for _, v in ipairs(ni.members) do
			if not UnitIsUnit(v.unit, unit) then
				local unitdistance = ni.unit.distance(v.unit, unit);
				if unitdistance ~= nil and unitdistance <= distance then
					tinsert(membersrange, v);
				end
			end
		end
		return membersrange;
	end
	function ni.members.inrangebelow(unit, distance, hp)
		table.wipe(membersbelow);
		ni.members.inrange(unit, distance);
		for _, v in ipairs(membersrange) do
			if v.hp < hp then
				tinsert(membersbelow, v);
			end
		end
		return membersbelow;
	end
	function ni.members.inrangewithbuff(unit, distance, buff, filter)
		table.wipe(memberswithbuff);
		ni.members.inrange(unit, distance);
		for _, v in ipairs(membersrange) do
			if v:buff(buff, filter) then
				tinsert(memberswithbuff, v);
			end
		end
		return memberswithbuff;
	end
	function ni.members.inrangewithbuffbelow(unit, distance, buff, hp, filter)
		table.wipe(memberswithbuffbelow);
		ni.members.inrange(unit, distance);
		for _, v in ipairs(membersrange) do
			if v:buff(buff, filter) 
			 and v.hp < hp then
				tinsert(memberswithbuffbelow, v);
			end
		end
		return memberswithbuffbelow;
	end
	function ni.members.inrangewithoutbuff(unit, distance, buff, filter)
		table.wipe(memberswithoutbuff);
		ni.members.inrange(unit, distance);
		for _, v in ipairs(membersrange) do
			if not v:buff(buff, filter) then
				tinsert(memberswithoutbuff, v);
			end
		end
		return memberswithoutbuff
	end
	function ni.members.inrangewithoutbuffbelow(unit, distance, buff, hp, filter)
		table.wipe(memberswithoutbuffbelow);
		ni.members.inrange(unit, distance);
		for _, v in ipairs(membersrange) do
			if not v:buff(buff, filter) 
			 and v.hp < hp then
				tinsert(memberswithoutbuffbelow, v);
			end
		end
		return memberswithoutbuffbelow
	end
	function ni.members.inrangewithdebuff(unit, distance, debuff, filter)
		table.wipe(memberswithdebuff);
		ni.members.inrange(unit, distance);
		for _, v in ipairs(membersrange) do
			if v:debuff(debuff, filter) then
				tinsert(memberswithdebuff, v);
			end
		end
		return memberswithdebuff;
	end
	function ni.members.inrangewithdebuffbelow(unit, distance, debuff, hp, filter)
		table.wipe(memberswithdebuffbelow);
		ni.members.inrange(unit, distance);
		for _, v in ipairs(membersrange) do
			if v:debuff(debuff, filter) 
			 and v.hp < hp then
				tinsert(memberswithdebuffbelow, v);
			end
		end
		return memberswithdebuffbelow;
	end
	function ni.members.inrangewithoutdebuff(unit, distance, debuff, filter)
		table.wipe(memberswithoutdebuff);
		ni.members.inrange(unit, distance);
		for _, v in ipairs(membersrange) do
			if not v:debuff(debuff, filter) then
				tinsert(memberswithoutdebuff, v);
			end
		end
		return memberswithoutdebuff
	end
	function ni.members.inrangewithoutdebuffbelow(unit, distance, debuff, hp, filter)
		table.wipe(memberswithoutdebuffbelow);
		ni.members.inrange(unit, distance);
		for _, v in ipairs(membersrange) do
			if not v:debuff(debuff, filter) 
			 and v.hp < hp then
				tinsert(memberswithoutdebuffbelow, v);
			end
		end
		return memberswithoutdebuffbelow
	end
	function ni.members.addcustom(unit)
		local groupMember = memberssetup:create(unit);
		if groupMember then
			tinsert(ni.members, groupMember);
		end
	end
	function ni.members.removecustom(unit)
		for k, v in ipairs(ni.members) do
			if v.unit == unit then
				memberssetup.cache[ni.unit.shortguid(unit)] = nil;
				tremove(ni.members, k);
			end
		end
	end
	ni.members()
end
memberssetup.set()