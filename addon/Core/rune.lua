-------------------
-- Rune functions
local ni = ...

local ni.rune = {};

-- Localizations
local GetRuneCooldown = ni.client.get_function("GetRuneCooldown")
local GetRuneType = ni.client.get_function("GetRuneType")

--[[--
Returns the number of available runes to use
 
Returns:
- **available** `number`
]]
ni.rune.available = function()
	local runes_available = 0
	local cur_time = ni.client.get_time();
	for i = 1, 6 do
		local start, duration, ready = GetRuneCooldown(i);
		if start == 0 or cur_time - start > duration then
			runes_available = runes_available + 1
		end
	end
	return runes_available
end

--[[--
Returns the number of death runes
 
Returns:
- **death** `number`
]]
ni.rune.death = function()
	local death_runes = 0;
	for i = 1, 6 do
		if GetRuneType(i) == 4 then
			death_runes = death_runes + 1;
		end
	end
	return death_runes;
end

--[[--
Returns the numbers of runes on cd and runes off cd
 
Parameters:
- **rune_type** `number`
 
Returns:
- **cd** `number`, `number`
]]
ni.rune.cd = function(rune_type)
	local runes_on_cd = 0
	local runes_off_cd = 0
	local cur_time = ni.client.get_time();
	
	for i = 1, 6 do
		local start, duration, ready = GetRuneCooldown(i);
		if GetRuneType(i) == rune_type then
			if start ~= 0 and cur_time - start <= duration then
				runes_on_cd = runes_on_cd + 1
			else
				runes_off_cd = runes_off_cd + 1
			end
		end
	end
	return runes_on_cd, runes_off_cd
end

--[[--
Returns the number of death runes on cd
 
Returns:
- **death_cd** `number`
]]
ni.rune.death_cd = function()
	return ni.rune.cd(4)
end

--[[--
Returns the number of frost runes on cd
 
Returns:
- **frost_cd** `number`
]]
ni.rune.frost_cd = function()
	return ni.rune.cd(3)
end

--[[--
Returns the number of unholy runes on cd
 
Returns:
- **unholy_cd** `number`
]]
ni.rune.unholy_cd = function()
	return ni.rune.cd(2)
end

--[[--
Returns the number of blood runes on cd
 
Returns:
- **blood_cd** `number`
]]
ni.rune.blood_cd = function()
	return ni.rune.cd(1)
end