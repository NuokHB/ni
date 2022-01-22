-------------------
-- Rune functions
local ni = ...

ni.rune = {}
ni.runes = {
   frost = {},
   death = {},
   unholy = {},
   blood = {}
}

-- Localizations
local GetRuneCooldown = ni.client.get_function("GetRuneCooldown")
local GetRuneType = ni.client.get_function("GetRuneType")

--[[--
Returns the rune cooldown information for selected rune index.
 
Parameters:
- **index** `number`
 
Returns:
- **start** `number`
- **duration** `number`
- **enabled** `number`
@param index number
]]
function ni.rune.cooldown(index)
   return GetRuneCooldown(index)
end

--[[--
Gets the rune type by index
 
Parameters:
- **index** `number`
 
Returns:
- **rune_type** `number`
@param index number
]]
function ni.rune.type(index)
   return GetRuneType(index)
end

--[[--
Checks if a rune index is currently on cooldown
 
Parameters:
- **index** `number`
 
Returns:
- **on_cooldown** `boolean`
@param index number
]]
function ni.rune.on_cooldown(index)
   local start, duration = ni.rune.cooldown(index)
   if start == 0 then
      return false
   end
   if ni.client.get_time() - start > duration then
      return false
   end
   return true
end

--[[--
Returns the numbers of runes on cooldown and off cooldown for a specific type
 
Parameters:
- **rune_type** `number`
 
Returns:
- **on_cooldown** `number`
- **off_cooldown** `number`
]]
function ni.runes.status(rune_type)
	local runes_on_cooldown = 0
	local runes_off_cooldown = 0
	for i = 1, 6 do
		if ni.rune.type(i) == rune_type then
			if ni.rune.on_cooldown(i) then
				runes_on_cooldown = runes_on_cooldown + 1
			else
				runes_off_cooldown = runes_off_cooldown + 1
			end
		end
	end
	return runes_on_cooldown, runes_off_cooldown
end

--[[--
Returns the number of available runes
 
Returns:
- **runes_available** `number`
]]
function ni.runes.available()
	local runes_available = 0
	for i = 1, 6 do
      if not ni.rune.on_cooldown(i) then
   		runes_available = runes_available + 1
		end
	end
	return runes_available
end

--[[--
Returns the number of death runes
 
Returns:
- **death_runes** `number`
]]
function ni.runes.death.count()
	local death_runes = 0;
	for i = 1, 6 do
		if ni.rune.type(i) == 4 then
			death_runes = death_runes + 1;
		end
	end
	return death_runes;
end


--[[--
Returns the numbers of death runes on cooldown and off cooldown
 
Returns:
- **death_on_cooldown** `number`
- **death_off_cooldown** `number` 
]]
function ni.runes.death.status()
	return ni.runes.status(4)
end

--[[--
Returns the numbers of frost runes on cd and off cd
 
Returns:
- **frost_on_cooldown** `number`
- **frost_off_cooldown** `number` 
]]
function ni.rune.frost.status()
	return ni.runes.status(3)
end

--[[--
Returns the numbers of unholy runes on cooldown and off cooldown
 
Returns:
- **unholy_on_cooldown** `number`
- **unholy_off_cooldown** `number` 
]]
function ni.rune.unholy.status()
	return ni.runes.status(2)
end

--[[--
Returns the numbers of blood runes on ccooldown and off cooldown
 
Returns:
- **blood_on_cooldown** `number`
- **blood_off_cooldown** `number` 
]]
function ni.runes.blood.status()
	return ni.runes.status(1)
end