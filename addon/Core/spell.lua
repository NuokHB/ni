-------------------
-- Spell functions for ni
local ni = ...

ni.spell = {}

-- Localizations to avoid hooks from servers
local GetSpellCooldown = ni.core.get_function("GetSpellCooldown")
local GetSpellInfo = ni.core.get_function("GetSpellInfo")
local GetNetStats = ni.core.get_function("GetNetStats")
local UnitIsDeadOrGhost = ni.core.get_function("UnitIsDeadOrGhost")
local UnitCanAttack = ni.core.get_function("UnitCanAttack")
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
   if tonumber(i) then
      ni.client.call_protected("CastSpellById", ...)
   else
      ni.client.call_protected("CastSpellByName", ...)
   end
end

--[[--
Gets the spell name from id
 
Parameters:
- **name** `string`
]]
function ni.spell.get_spell_id(name)
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
   local start,
      duration = GetSpellCooldown(spell)
   local gcd_start = GetSpellCooldown(61304)

   if start == nil then
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
   local _,
      duration = GetSpellCooldown(61304)
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
   return select(7, GetSpellInfo(spell)) / 1000 + select(3, GetNetStats()) / 1000
end

--[[--
Returns true if the spell is instant cast
 
Parameters:
- **spell** `name|id`

Returns:
- **isinstant** `bool`
@param spell
]]
function ni.spell.is_instant(spell)
   return select(7, GetSpellInfo(spell)) == 0
end

--[[--
-- ToDo: Add in power class

Checks if a spell is valid to be cast on a unit
 
Parameters:
- **spell** `name|id`
- **target** `token|guid`
- **facing** `bool`
- **los** `bool`
- **friendly** `bool`

Returns:
- **valid** `bool`
@param spell
@param[opt] target string
@param[opt] facing bool
@param[opt] los bool
@param[opt] friendly bool
]]
function ni.spell.valid(spell, target, facing, los, friendly)
   friendly = true and friendly or false
   los = true and los or false
   facing = true and facing or los

   if tonumber(spell) == nil then
      spell = ni.spell.get_spell_id(spell)
      if spell == 0 then
         return false
      end
   end

   local name, _, _, cost, _, powertype = GetSpellInfo(spell)

   if
      ni.unit.exists(target) and
         ((not friendly and (not UnitIsDeadOrGhost(target) and UnitCanAttack("player", target) == 1)) or friendly) and
         IsSpellInRange(name, target) == 1 and
         (IsSpellKnown(spell) or (ni.client.build >= "50400" and IsPlayerSpell(spell))) and
         ni.power.current_raw("player ",powertype) >= cost and
         ((facing and ni.player.facing(target)) or not facing) and
         ((los and ni.player.los(target)) or not los)
    then
      return true
   end
end
