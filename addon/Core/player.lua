local ni = ...

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

ni.player = {}
ni.player.moveto = function(...) --target/x,y,z
	ni.backend.MoveTo(...)
end
ni.player.clickat = function(...) --target/x,y,z/mouse
	ni.backend.ClickAt(...)
end
ni.player.stopmoving = function()
	ni.backend.CallProtected("StrafeLeftStop");
	ni.backend.CallProtected("StrafeRightStop");
	ni.backend.CallProtected("TurnLeftStop");
	ni.backend.CallProtected("TurnRightStop");
	ni.backend.StopMoving();
end
ni.player.lookat = function(target, inv) --inv true to look away
	ni.backend.LookAt(target, inv)
end
ni.player.target = function(target)
    ni.backend.CallProtected("TargetUnit", target)
end
ni.player.runtext = function(text)
	ni.debug.print(string.format("Running: %s", text))
	ni.backend.CallProtected("RunMacroText", text)
end
ni.player.useitem = function(...) --itemid/name[, target]
	if #{...} > 1 then
		ni.debug.print(string.format("Using item %s on %s", ...))
	else
		ni.debug.print(string.format("Using item %s", ...))
	end
	local item = ...
	if tonumber(...) then
		item = GetItemInfo(item)
		if #{...} > 1 then
			local _, tar = ...
			ni.backend.CallProtected("UseItemByName", item, tar)
		else
			ni.backend.CallProtected("UseItemByName", item)
		end
	else
		ni.backend.CallProtected("UseItemByName", ...)
	end
end
ni.player.useinventoryitem = function(slotid)
	ni.debug.print(string.format("Using Inventory Slot %s", slotid))
	ni.backend.CallProtected("UseInventoryItem", slotid)
end
ni.player.interact = function(target)
	ni.debug.print(string.format("Interacting with %s", target))
	ni.backend.CallProtected("InteractUnit", UnitGUID(target))
end
ni.player.hasglyph = function(glyphid)
	for i = 1, 6 do
		if GetGlyphSocketInfo(i) then
			if select(3, GetGlyphSocketInfo(i)) == glyphid then
				return true
			end
		end
	end
	return false
end
ni.player.hasitem = function(itemid)
	return GetItemCount(itemid, false, false) > 0
end
ni.player.hasitemequipped = function(id)
	for i = 1, 19 do
		if GetInventoryItemID("player", i) == id then
			return true
		end
	end
	return false
end
ni.player.slotcastable = function(slotnum)
	return GetItemSpell(GetInventoryItemID("player", slotnum)) ~= nil
end
ni.player.slotcd = function(slotnum)
	if not ni.player.slotcastable(slotnum) then
		return 0
	end
	local start, duration, enable = GetItemCooldown(GetInventoryItemID("player", slotnum))
	if (start > 0 and duration > 0) then
		return start + duration - GetTime()
	end
	return 0
end
ni.player.itemcd = function(item)
	local start, duration, enable = GetItemCooldown(item)
	if (start > 0 and duration > 0) then
		return start + duration - GetTime()
	end
	return 0
end
ni.player.petcd = function(spell)
	local start, duration, enable = GetSpellCooldown(spell)
	if (start > 0 and duration > 0) then
		return start + duration - GetTime()
	else
		return 0
	end
end
ni.player.registermovement = function(elapsed)
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
end
ni.player.movingfor = function(duration)
	local duration = duration or 1;
	if CurrentMovingTime >= duration and not ni.unit.buff("player", 98767) then
		return true;
	end
	return false;
end
ni.player.getmovingtime = function()
	return CurrentMovingTime;
end
ni.player.ismoving = function()
	if ni.unit.ismoving("player") or IsFalling() then
		return true
	end
	return false
end

setmetatable(
	ni.player,
	{
		__index = function(t, k)
			if ni.unit[k] then
				rawset(t, k, function(...)
					return ni.unit[k]("player", ...);
				end);
				return t[k];
			end
		end
	}
)