-------------------
-- Spell functions for ni
local ni = ...

ni.spell = {}

-- Localizations to avoid hooks from servers
local GetSpellCooldown = ni.client.get_function("GetSpellCooldown")
local GetSpellInfo = ni.client.get_function("GetSpellInfo")
local IsSpellInRange = ni.client.get_function("IsSpellInRange")
local IsSpellKnown = ni.client.get_function("IsSpellKnown")
local IsPlayerSpell = ni.client.get_function("IsPlayerSpell")

--[[--
Gets the spell information
 
Parameters:
- **spell** `string or number`
 
Returns:
- **...**
 
Notes:
Wrapper for GetSpellInfo. See that for appropriate documentation.
@param spell
]]
function ni.spell.info(spell)
   return GetSpellInfo(spell)
end

--[[--
Casts a spell by name or id
 
Parameters:
- **spell** `string or number`
- **target** `string`
@param spell
@param[opt] target string
]]
function ni.spell.cast(...)
   local spell = ...
   if type(spell) == "number" then
      ni.client.call_protected("CastSpellById", ...)
   else
      ni.client.call_protected("CastSpellByName", ...)
   end
end

--[[--
Gets the spell name from id
 
Parameters:
- **name** `string`
@param name string
]]
function ni.spell.id(name)
   return ni.backend.GetSpellId(name)
end

--[[--
Gets a spells cooldown information
 
Parameters:
- **spell** `string or number`
 
Returns:
- **start** `number`
- **duration** `number`
- **enabled** `number`
@param spell
]]
function ni.spell.cooldown(spell)
   return GetSpellCooldown(spell)
end

--[[--
Returns if we are are currently on Global Cooldown
 
Returns:
- **start** `number`
- **duration** `number`
- **enabled** `number`
]]
function ni.spell.global_cooldown()
   return ni.spell.cooldown(61304)
end

--[[--
Gets the remaining cooldown time
 
Parameters:
- **spell** `string or number`
 
Returns:
- **remaining** `number`
@param spell
]]
function ni.spell.cooldown_remaining(spell)
   local start, duration = ni.spell.cooldown(spell)
   if not start then
      return 0
   end
   local gcd_start = ni.spell.global_cooldown()
   if (start > 0 and duration > 0 and start ~= gcd_start) then
      return start + duration - ni.client.get_time()
   else
      return 0
   end
end

--[[--
Returns if we are currently on global cooldown
 
Returns:
- **on_gcd** `boolean`
]]
function ni.spell.on_global_cooldown()
   local _, duration = ni.spell.global_cooldown()
   return duration ~= 0
end

--[[--
Short hand for on_global_cooldown.

See: [ni.spell.on_global_cooldown](#ni.spell.on_global_cooldown ())
]]
function ni.spell.on_gcd()
   return ni.spell.on_global_cooldown()
end

--[[--
Gets a spells cast time
 
Parameters:
- **spell** `string or number`
 
Returns:
- **duration** `number`
@param spell
]]
function ni.spell.cast_time(spell)
   local _, _, _, _, _, _, cast_time = ni.spell.info(spell)
   return cast_time / 1000 + ni.client.get_net_stats() / 1000
end

--[[--
Returns true if the spell is instant cast
 
Parameters:
- **spell** `string or number`
 
Returns:
- **is_instant** `boolean`
@param spell
]]
function ni.spell.is_instant(spell)
   local _, _, _, _, _, _, cast_time = ni.spell.info(spell)
   return cast_time == 0
end

-- TODO: Re visit to clean up for easier readability.
-- Currently does not conform to the style guidelines.
--[[--
Checks if a spell is valid to be cast on a unit
 
Parameters:
- **spell** `string|number`
- **target** `token|guid`
- **is_facing** `boolean`
- **line_of_sight** `boolean`
- **is_friendly** `boolean`
 
Returns:
- **valid** `boolean`
@param spell
@param target string
@param[opt] is_facing boolean
@param[opt] line_of_sight boolean
@param[opt] is_friendly boolean
]]
function ni.spell.valid(spell, target, is_facing, line_of_sight, is_friendly)
   is_friendly = true and is_friendly or false
   line_of_sight = true and line_of_sight or false
   is_facing = true and is_facing or false

   if type(spell) =="string" then
      spell = ni.spell.id(spell)
      if spell == 0 then
         return false
      end
   end

   local name, _, _, cost, _, powertype = GetSpellInfo(spell)

   if ni.unit.exists(target) and
         ((not is_facing and (not ni.unit.is_dead_or_ghost(target) and ni.player.can_attack(target) == 1)) or is_facing) and
         IsSpellInRange(name, target) == 1 and
         (IsSpellKnown(spell) or (ni.client.build() >= "50400" and IsPlayerSpell(spell))) and
         ni.power.current_raw("player ",powertype) >= cost and
         ((is_facing and ni.player.facing(target)) or not is_facing) and
         ((line_of_sight and ni.player.los(target)) or not line_of_sight)
    then
      return true
   end
end