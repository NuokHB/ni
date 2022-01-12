local ni = ...
local GetGlyphSocketInfo,
	GetContainerNumSlots,
	GetContainerItemID,
	GetItemSpell,
	GetInventoryItemID,
	GetItemCooldown,
	GetSpellCooldown,
	GetTime,
	IsFalling,
	UnitGUID =
	ni.backend.GetFunction("GetGlyphSocketInfo"),
	ni.backend.GetFunction("GetContainerNumSlots"),
	ni.backend.GetFunction("GetContainerItemID"),
	ni.backend.GetFunction("GetItemSpell"),
	ni.backend.GetFunction("GetInventoryItemID"),
	ni.backend.GetFunction("GetItemCooldown"),
	ni.backend.GetFunction("GetSpellCoolown"),
	ni.backend.GetFunction("GetTime"),
	ni.backend.GetFunction("IsFalling"),
	ni.backend.GetFunction("UnitGUID")

local CurrentMovingTime, CurrentStationaryTime, ResetMovementTime = 0, 0, 0.5

local player = {}
player.moveto = function(...) --target/x,y,z
	ni.backend.MoveTo(...)
end
player.clickat = function(...) --target/x,y,z/mouse
	ni.backend.ClickAt(...)
end
player.stopmoving = function()
	ni.backend.CallProtected(StrafeLeftStop)
	ni.backend.CallProtected(StrafeRightStop)
	ni.backend.CallProtected(TurnLeftStop)
	ni.backend.CallProtected(TurnRightStop)
	ni.backend.StopMoving()
end
player.lookat = function(target, inv) --inv true to look away
	ni.backend.LookAt(target, inv)
end
player.target = function(target)
	ni.backend.CallProtected("TargetUnit", target)
end
player.runtext = function(text)
	ni.debug.print(string.format("Running: %s", text))
	ni.backend.CallProtected("RunMacroText", text)
end
player.useitem = function(...) --itemid/name[, target]
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
player.useinventoryitem = function(slotid)
	ni.debug.print(string.format("Using Inventory Slot %s", slotid))
	ni.backend.CallProtected("UseInventoryItem", slotid)
end
player.interact = function(target)
	ni.debug.print(string.format("Interacting with %s", target))
	ni.backend.CallProtected("InteractUnit", UnitGUID(target))
end
player.hasglyph = function(glyphid)
	for i = 1, 6 do
		if GetGlyphSocketInfo(i) then
			if select(3, GetGlyphSocketInfo(i)) == glyphid then
				return true
			end
		end
	end
	return false
end
player.hasitem = function(itemid)
	return GetItemCount(itemid, false, false) > 0
end
player.hasitemequipped = function(id)
	for i = 1, 19 do
		if GetInventoryItemID("player", i) == id then
			return true
		end
	end
	return false
end
player.slotcastable = function(slotnum)
	return GetItemSpell(GetInventoryItemID("player", slotnum)) ~= nil
end
player.slotcd = function(slotnum)
	if not player.slotcastable(slotnum) then
		return 0
	end
	local start, duration, enable = GetItemCooldown(GetInventoryItemID("player", slotnum))
	if (start > 0 and duration > 0) then
		return start + duration - GetTime()
	end
	return 0
end
player.itemcd = function(item)
	local start, duration, enable = GetItemCooldown(item)
	if (start > 0 and duration > 0) then
		return start + duration - GetTime()
	end
	return 0
end
player.petcd = function(spell)
	local start, duration, enable = GetSpellCooldown(spell)
	if (start > 0 and duration > 0) then
		return start + duration - GetTime()
	else
		return 0
	end
end
player.registermovement = function(elapsed)
	local speed = GetUnitSpeed("player")
	if speed ~= 0 then
		CurrentMovingTime = CurrentMovingTime + elapsed
		CurrentStationaryTime = 0
	else
		if CurrentStationaryTime < ResetMovementTime then
			CurrentStationaryTime = CurrentStationaryTime + elapsed
		elseif CurrentStationaryTime > ResetMovementTime then
			CurrentMovingTime = 0
		end
	end
end
player.movingfor = function(duration)
	local duration = duration or 1
	if CurrentMovingTime >= duration and not ni.unit.buff("player", 98767) then
		return true
	end
	return false
end
player.getmovingtime = function()
	return CurrentMovingTime
end
player.ismoving = function()
	if ni.unit.ismoving("player") or IsFalling() then
		return true
	end
	return false
end

setmetatable(
	player,
	{
		__index = function(t, k)
			if ni.unit[k] then
				rawset(
					t,
					k,
					function(...)
						return ni.unit[k]("player", ...)
					end
				)
				return t[k]
			end
		end
	}
)
return player
