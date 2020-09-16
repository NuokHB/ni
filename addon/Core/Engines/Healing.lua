local UnitDebuff, UnitClass, tContains, tinsert, UnitHealthMax =
	UnitDebuff,
	UnitClass,
	tContains,
	tinsert,
	UnitHealthMax

local class = string.lower(select(2, UnitClass("player")))

ni.healing = {
	debufftoblacklist = function(id)
		if not tContains(ni.tables.blacklisteddispels, id) then
			tinsert(ni.tables.blacklisteddispels, id)
		end
	end,
	dontdispel = function(t)
		for k, v in pairs(ni.tables.blacklisteddispels) do
			if ni.unit.debuff(t, v) then
				return true
			end
		end
		return false
	end,
	candispel = function(t)
		local i = 1
		local debuff = UnitDebuff(t, i)

		if ni.healing.dontdispel(t) then
			return false
		end

		while debuff do
			local debufftype = select(5, UnitDebuff(t, i))

			if ni.tables.classes[class].dispel and tContains(ni.tables.classes[class].dispel, debufftype) then
				return true
			end

			i = i + 1
			debuff = UnitDebuff(t, i)
		end
		return false
	end,
	averagehp = function(n)
		local average = 0
		if #ni.members < n then
			for i = n, 0, -1 do
				if #ni.members >= i then
					n = i
					break
				end
			end
		end
		for i = 1, n do
			average = average + ni.members[i].hp
		end
		average = average / n
		return average
	end
}
local tanks = { };
ni.tanks = function()
	if ni.vars.units.mainTankEnabled and ni.vars.units.offTankEnabled then
		return ni.vars.units.mainTank, ni.vars.units.offTank
	end
	table.wipe(tanks);
	for i = 1, #ni.members do
		if ni.members[i].istank then
			tinsert(tanks, {unit = ni.members[i].unit, health = UnitHealthMax(ni.members[i].unit)})
		end
	end
	if #tanks > 1 then
		table.sort(
			tanks,
			function(x, y)
				return x.health > y.health
			end
		)
		if ni.vars.units.mainTankEnabled or ni.vars.units.offTankEnabled then
			if ni.vars.units.offTankEnabled and not ni.vars.units.mainTankEnabled then
				return tanks[1].unit, ni.vars.units.offTank
			elseif ni.vars.units.mainTankEnabled and not ni.vars.units.offTankEnabled then
				return ni.vars.units.mainTank, tanks[1].unit
			end
		else
			return tanks[1].unit, tanks[2].unit
		end
	end
	if #tanks == 1 then
		if ni.vars.units.offTankEnabled and not ni.vars.units.mainTankEnabled then
			return tanks[1].unit, ni.vars.units.offTank
		elseif ni.vars.units.mainTankEnabled and not ni.vars.units.offTankEnabled then
			return ni.vars.units.mainTank, tanks[1].unit
		else
			return tanks[1].unit, "focus"
		end
	end
	if ni.vars.units.mainTankEnabled then
		return ni.vars.units.mainTank, "focus"
	elseif ni.vars.units.offTankEnabled then
		return "focus", ni.vars.units.offTank
	else
		return "focus"
	end
end
