-------------------
-- Spell functions for ni
local ni = ...

ni.spell = {}

-- Localizations to avoid hooks from servers
local GetSpellCooldown = ni.core.get_function("GetSpellCooldown")
local GetSpellInfo = ni.core.get_function("GetSpellInfo")
local IsSpellInRange = ni.core.get_function("IsSpellInRange")
local IsSpellKnown = ni.core.get_function("IsSpellKnown")
local IsPlayerSpell = ni.core.get_function("IsPlayerSpell")

--[[--
Casts a spell by name or id
 
Parameters:
- **spell** `name|id`
- **target** `token|guid`
@param spell
@param[opt] target string
]]
function ni.spell.cast(...)
   local i = ...
   if type(i) == "number" then
      ni.client.call_protected("CastSpellById", ...)
   else
      ni.client.call_protected("CastSpellByName", ...)
   end
end

--[[--
Gets the spell name from id
 
Parameters:
- **name** `string`
@param spell string
]]
function ni.spell.id(name)
   return ni.backend.GetSpellId(name)
end

--[[--
Gets a spells cooldown
 
Parameters:
- **spell** `name|id`
 
Returns:
- **duration** `number`
@param spell
]]
function ni.spell.cooldown(spell)
   local start, duration = GetSpellCooldown(spell)
   local gcd_start = GetSpellCooldown(61304)

   if not start then
      return -1
   end

   if (start > 0 and duration > 0 and start ~= gcd_start) then
      return start + duration - ni.client.get_time()
   else
      return 0
   end
end

--[[--
Returns if we are are currently on Global Cooldown
 
Returns:
- **gcd** `boolean`
]]
function ni.spell.gcd()
   local _, duration = GetSpellCooldown(61304)
   return duration ~= 0
end

--[[--
Gets a spells cast time
 
Parameters:
- **spell** `name|id`
 
Returns:
- **duration** `number`
@param spell
]]
function ni.spell.cast_time(spell)
   return select(7, GetSpellInfo(spell)) / 1000 + ni.client.get_net_stats() / 1000
end

--[[--
Returns true if the spell is instant cast
 
Parameters:
- **spell** `name|id`
 
Returns:
- **isinstant** `boolean`
@param spell
]]
function ni.spell.is_instant(spell)
   return select(7, GetSpellInfo(spell)) == 0
end

--[[--
Checks if a spell is valid to be cast on a unit
 
Parameters:
- **spell** `name|id`
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
         ((not is_facing and (not ni.unit.is_unit_is_dead_or_ghost(target) and ni.player.unit_can_attack(target) == 1)) or is_facing) and
         IsSpellInRange(name, target) == 1 and
         (IsSpellKnown(spell) or (ni.client.build() >= "50400" and IsPlayerSpell(spell))) and
         ni.power.current_raw("player ",powertype) >= cost and
         ((is_facing and ni.player.facing(target)) or not is_facing) and
         ((line_of_sight and ni.player.los(target)) or not line_of_sight)
    then
      return true
   end
end
