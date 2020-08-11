local GetGlyphSocketInfo,
	GetContainerNumSlots,
	GetContainerItemID,
	GetItemSpell,
	GetInventoryItemID,
	GetItemCooldown,
	GetSpellCooldown,
	GetTime,
	IsFalling =
	GetGlyphSocketInfo,
	GetContainerNumSlots,
	GetContainerItemID,
	GetItemSpell,
	GetInventoryItemID,
	GetItemCooldown,
	GetSpellCooldown,
	GetTime,
	IsFalling

local CurrentMovingTime, CurrentStationaryTime, ResetMovementTime = 0, 0, 0.5;

ni.player = {
	moveto = function(...) --target/x,y,z
		ni.functions.moveto(...)
	end,
	clickat = function(...) --target/x,y,z/mouse
		ni.functions.clickat(...)
	end,
	stopmoving = function()
		ni.functions.stopmoving()
	end,
	lookat = function(target, inv) --inv true to look away
		ni.functions.lookat(target, inv)
	end,
	target = function(target)
		ni.functions.settarget(target)
	end,
	runtext = function(text)
		ni.debug.print(string.format("Running: %s", text))
		ni.functions.runtext(text)
	end,
	useitem = function(...) --itemid/name[, target]
		if #{...} > 1 then
			ni.debug.print(string.format("Using item %s on %s", ...))
		else
			ni.debug.print(string.format("Using item %s", ...))
		end
		ni.functions.item(...)
	end,
	useinventoryitem = function(slotid)
		ni.debug.print(string.format("Using Inventory Slot %s", slotid))
		ni.functions.inventoryitem(slotid)
	end,
	interact = function(target)
		ni.debug.print(string.format("Interacting with %s", target))
		ni.functions.interact(target)
	end,
	hasglyph = function(glyphid)
		for i = 1, 6 do
			if GetGlyphSocketInfo(i) then
				if select(3, GetGlyphSocketInfo(i)) == glyphid then
					return true
				end
			end
		end
		return false
	end,
	hasitem = function(itemid)
		return GetItemCount(itemid, false, false) > 0
	end,
	hasitemequipped = function(id)
		for i = 1, 19 do
			if GetInventoryItemID("player", i) == id then
				return true
			end
		end
		return false
	end,
	slotcastable = function(slotnum)
		return GetItemSpell(GetInventoryItemID("player", slotnum)) ~= nil
	end,
	slotcd = function(slotnum)
		if not ni.player.slotcastable(slotnum) then
			return 0
		end
		local start, duration, enable = GetItemCooldown(GetInventoryItemID("player", slotnum))
		if (start > 0 and duration > 0) then
			return start + duration - GetTime()
		end
		return 0
	end,
	itemcd = function(item)
		local start, duration, enable = GetItemCooldown(item)
		if (start > 0 and duration > 0) then
			return start + duration - GetTime()
		end
		return 0
	end,
	petcd = function(spell)
		local start, duration, enable = GetSpellCooldown(spell, "pet")
		if (start > 0 and duration > 0) then
			return start + duration - GetTime()
		else
			return 0
		end
	end,
	registermovement = function(elapsed)
		local speed = GetUnitSpeed("player");
		if speed ~= 0 then
			CurrentMovingTime = CurrentMovingTime + elapsed;
			CurrentStationaryTime = 0;
		else
			if CurrentStationaryTime < ResetMovementTime then
				CurrentStationaryTime = CurrentStationaryTime + elapsed;
			elseif CurrentStationaryTime > ResetMovementTime then
				CurrentMovingTime = 0;
			end
		end
	end,
	movingfor = function(duration)
		local duration = duration or 1;
		if CurrentMovingTime >= duration and not ni.unit.buff("player", 98767) then
			return true;
		end
		return false;
	end,
	getmovingtime = function()
		return CurrentMovingTime;
	end,
	ismoving = function()
		if ni.unit.ismoving("player") or IsFalling() then
			return true
		end
		return false
	end,
}

setmetatable(
	ni.player,
	{
		__index = function(_, k)
			return function(...)
				return ni.unit[k]("player", ...)
			end
		end
	}
)
