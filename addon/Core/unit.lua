-------------------
-- Unit functions for ni
local ni = ...

ni.unit = {}

-- Localizations to avoid hooks from servers
local UnitExists = ni.client.get_function("UnitExists")
local UnitThreatSituation = ni.client.get_function("UnitThreatSituation")
local UnitGUID = ni.client.get_function("UnitGUID")
local UnitHealth = ni.client.get_function("UnitHealth")
local UnitHealthMax = ni.client.get_function("UnitHealthMax")
local UnitCastingInfo = ni.client.get_function("UnitCastingInfo")
local UnitChannelInfo = ni.client.get_function("UnitChannelInfo")
local UnitIsDeadOrGhost = ni.client.get_function("UnitIsDeadOrGhost")
local UnitCanAttack = ni.client.get_function("UnitCanAttack")

--[[--
Table keys:
- **name** `string`
- **ID** `number`
@table aura
]]

--[[--
Gets the auras on the specified target.
 
Parameters:
- **target** `string`
 
Returns:
- **auras** `aura table`
@param target string
]]
function ni.unit.auras(target)
   return ni.backend.Auras(target) or {}
end

--[[--
Gets the best location that meets the criteria passed.
 
Parameters:
- **target** `string`
- **distance** `number`
- **radius** `number`
- **score** `number`
- **callback** `function`
- **friendly** `boolean`
- **height_max** `number`
- **max_distance** `number`
 
Returns:
- **x** `number`
- **y** `number`
- **z** `number`
@param target string
@param distance number
@param radius number
@param[opt] score number
@param[opt] callback function
@param[opt] friendly boolean
@param[opt] height_max number
@param[opt] max_distance number
]]
function ni.unit.best_location(target, distance, radius, score, callback, friendly, height_max, max_distance)
   return ni.backend.BestLocation(target, distance, radius, score, callback, friendly, height_max, max_distance)
end

--[[--
Wrapper for best_location for friendly target
 
Parameters:
- **target** `string`
- **distance** `number`
- **radius** `number`
- **score** `number`
- **callback** `function`
- **height_max** `number`
- **max_distance** `number`
 
Returns:
- **x** `number`
- **y** `number`
- **z** `number`
@param target string
@param distance number
@param radius number
@param[opt] score number
@param[opt] callback function
@param[opt] height_max number
@param[opt] max_distance number
]]
function ni.unit.best_helpful_location(target, distance, radius, score, callback, height_max, max_distance)
   return ni.backend.BestLocation(target, distance, radius, score, callback, true, height_max, max_distance)
end

--[[--
Wrapper for best_location for enemy target
 
Parameters:
- **target** `string`
- **distance** `number`
- **radius** `number`
- **score** `number`
- **callback** `function`
- **height_max** `number`
- **max_distance** `number`
 
Returns:
- **x** `number`
- **y** `number`
- **z** `number`
@param target string
@param distance number
@param radius number
@param[opt] score number
@param[opt] callback function
@param[opt] height_max number
@param[opt] max_distance number
]]
function ni.unit.best_damage_location(target, distance, radius, score, callback, height_max, max_distance)
   return ni.backend.BestLocation(target, distance, radius, score, callback, false, height_max, max_distance)
end

--[[--
Gets the combat reach for the specified target.
 
Parameters:
- **target** `string`
 
Returns:
- **combat_reach** `number`
@param target string
]]
function ni.unit.combat_reach(target)
   return ni.backend.CombatReach(target)
end

--[[--
Checks if the unit exists.
 
Parameters:
- **target** `string`
 
Returns:
- **exists** `boolean`
@param target string
]]
function ni.unit.exists(target)
   return UnitExists(target)
end

--[[--
Gets the targets guid
 
Parameters:
- **target** `string`
 
Returns:
- **guid** `string`
@param target string
]]
function ni.unit.guid(target)
   return UnitGUID(target)
end

--[[--
Gets the short guid
 
Parameters:
- **target** `string`
 
Returns:
- **short_guid** `string`
@param target string
]]
function ni.unit.short_guid(target)
   local guid = ni.unit.guid(target)
   return guid and string.sub(guid, -5, -1) or nil
end

--[[--
Gets the targets current health
 
Parameters:
- **target** `string`
 
Returns:
- **health** `number`
@param target string
]]
function ni.unit.health(target)
   return UnitHealth(target)
end

--[[--
Gets the targets max health
 
Parameters:
- **target** `string`
 
Returns:
- **max_health** `number`
@param target string
]]
function ni.unit.health_max(target)
   return UnitHealthMax(target)
end

--[[--
Gets the targets health deficit
 
Parameters:
- **target** `string`
 
Returns:
- **deficit** `number`
@param target string
]]
function ni.unit.health_deficit(target)
   return ni.unit.health_max(target) - ni.unit.health(target)
end

--[[--
Gets the targets health percent
 
Parameters:
- **target** `string`
 
Returns:
- **health_percent** `number`
@param target string
]]
function ni.unit.health_percent(target)
   return 100 * ni.unit.health(target) / ni.unit.health_max(target)
end

--[[--
Shorthand function for health_percent.

See [ni.unit.health_percent](#ni.unit.health_percent (target))
@param target string
]]
function ni.unit.hp(target)
   return ni.unit.health_percent(target)
end

--[[--
Gets the information of the specified target
 
Parameters:
- **target** `string`
 
Returns:
- **x** `number`
- **y** `number`
- **z** `number`
- **type** `number`
- **target** `string`
- **height** `number`
@param target string
]]
function ni.unit.info(target)
   return ni.backend.ObjectInfo(target)
end

--[[--
Gets the units target
 
Parameters:
- **target** `string`
 
Returns:
- **guid** `string`
@param target string
]]
function ni.unit.target(target)
   local _, _, _, _, guid = ni.unit.info(target)
   return guid
end

--[[--
Gets the units height
 
Parameters:
- **target** `string`
 
Returns:
- **height** `number`
@param target string
]]
function ni.unit.height(target)
   local _, _, _, _, _, height = ni.unit.info(target)
   return height
end

--[[--
Gets the location of the specified target.
 
Parameters:
- **target** `string`
 
Returns:
- **x** `number`
- **y** `number`
- **z** `number`
@param target string
]]
function ni.unit.location(target)
   return ni.object.location(target)
end

--[[--
Checks if one target is facing another.
 
Parameters:
- **target_a** `string`
- **target_b** `string`
- **field_of_view** `number`
 
Returns:
- **facing** `boolean`
@param target_a string
@param target_b string
@param[opt] field_of_view number
]]
function ni.unit.is_facing(target_a, target_b, field_of_view)
   return ni.backend.IsFacing(target_a, target_b, field_of_view)
end

--[[--
Checks if one target is behind another.
 
Parameters:
- **target_a** `string`
- **target_b** `string`
 
Returns:
- **behind** `boolean`
@param target_a string
@param target_b string
]]
function ni.unit.is_behind(target_a, target_b)
   return ni.backend.IsBehind(target_a, target_b)
end

--[[--
Checks if a target has a specific aura id or name.
 
Parameters:
- **target** `string`
- **aura** `number or string`
 
Returns:
- **has_aura** `boolean`
@param target string
@param aura
]]
function ni.unit.has_aura(target, aura)
   return ni.backend.HasAura(target, aura) or false
end

--[[--
Gets the distance between two targets.
 
Parameters:
- **target_a** `string`
- **target_b** `string`
 
Returns:
- **distance** `number`
@param target_a string
@param target_b string
]]
function ni.unit.distance(target_a, target_b)
   return ni.backend.GetDistance(target_a, target_b)
end

--[[--
Gets the GUID of the units creator.
 
Parameters:
- **target** `string`
 
Returns:
- **guid** `string`
@param target string
]]
function ni.unit.creator(target)
   return ni.object.creator(target)
end

--[[--
Gets the units dynamic flags.
 
Parameters:
- **target** `string`
 
Returns:
- **flags** `boolean`
 
Notes:
This function will return 9 different values which are all booleans for the
dynamic flags 1 - 9. (Dynamic flag titles may be different for expansions)
I was being lazy, and didn't want to type out the 9 different returns.
@param target string
]]
function ni.unit.dynamic_flags(target)
   return ni.backend.UnitDynamicFlags(target)
end

--[[--
Gets the units flags.
 
Parameters:
- **target** `string`
 
Returns:
- **flags** `boolean`
 
Notes:
This function will return 32 different values which are all booleans for the
dynamic flags 1 - 32. (Flag titles may be different for expansions)
I was being lazy, and didn't want to type out the 32 different returns.
@param target string
]]
function ni.unit.flags(target)
   return ni.backend.UnitFlags(target)
end

--[[--
Gets the units creature type.
 
Parameters:
- **target** `string`
 
Returns:
- **creature_type** `number`
@param target string
]]
function ni.unit.type(target)
   return ni.backend.CreatureType(target) or 0
end

--[[--
Checks if the unit is a totem
 
Parameters:
- **target** `string`
 
Returns:
- **is_totem** `boolean`
@param target string
]]
function ni.unit.is_totem(target)
   return ni.unit.type(target) == 11
end

--[[--
Checks the units threat to a target
 
Parameters:
- **target_a** `string`
- **target_b** `string`
 
Returns:
- **threat** `number`
@param target_a string
@param target_b string
]]
function ni.unit.threat(target_a, target_b)
   local threat = UnitThreatSituation(target_a, target_b)
   return threat and threat or -1
end

--[[--
Checks if two units are in line of sight of each other.
 
Parameters:
- **target_a** `string`
- **target_b** `string`
- **hit_flags** `number`
 
Returns:
- **success** `boolean`
- **intersection_x** `number`
- **intersection_y** `number`
- **intersection_z** `number`
@param target_a string
@param target_b string
@param[opt] hit_flags number
]]
function ni.unit.los(target_a, target_b, hit_flags)
   return ni.backend.LoS(target_a, target_b, hit_flags)
end

--[[--
Gets the units pointer
 
Parameters:
- **target** `string`
 
Returns:
- **pointer** `number`
- **hex_pointer** `string`
@param target string
]]
function ni.unit.pointer(target)
   return ni.object.pointer(target)
end

--[[--
Gets the units transport guid
 
Parameters:
- **target** `string`
 
Returns:
- **guid** `string`
@param target string
]]
function ni.unit.transport(target)
   return ni.object.transport(target)
end

--[[--
Gets the units facing in radians
 
Parameters:
- **target** `string`
 
Returns:
- **direction** `number`
@param target string
]]
function ni.unit.facing(target)
   return ni.backend.ObjectFacing(target)
end

--[[--
Gets the unit descriptor value for the given index
 
Parameters:
- **target** `string`
- **index** `number`
 
Returns:
- **descriptor** `number`
@param target string
@param index number
]]
function ni.unit.descriptor(target, index)
   return ni.object.descriptor(target, index)
end

--[[--
Gets the melee range between two units
 
Parameters:
- **target_a** `string`
- **target_b** `string`
 
Returns:
- **range** `number`
@param target_a string
@param target_b string
]]
function ni.unit.melee_range(target_a, target_b)
   local combat_reach_a = ni.unit.combat_reach(target_a)
   local combat_reach_b = ni.unit.combat_reach(target_b)
   return math.max(5.0, combat_reach_a + combat_reach_b + (4 / 3))
end

--[[--
Checks if unit is in melee range of another target
 
Parameters:
- **target_a** `string`
- **target_b** `string`
 
Returns:
- **in_melee** `boolean`
@param target_a string
@param target_b string
]]
function ni.unit.in_melee(target_a, target_b)
   local distance = ni.unit.distance(target_a, target_b)
   if not distance then
      return false
   end
   return distance < ni.unit.melee_range(target_a, target_b)
end

--[[--
Gets the casting information for the specified target
 
Parameters:
- **target** `string`
 
Returns:
- **...**
 
Notes:
See the returns for UnitCastingInfo
@param target string
]]
function ni.unit.casting(target)
   return UnitCastingInfo(target)
end

--[[--
Gets if the target is casting currently
 
Parameters:
- **target**
 
Returns:
- **casting** `boolean`
@param target string
]]
function ni.unit.is_casting(target)
   return ni.unit.casting(target) and true or false
end

--[[--
@local
Helper function to avoid the calculations being typed twice.
 
Parameters:
- **start_time** `number`
- **end_time** `number`
 
Returns:
- **percent_complete** `number`
@param start_time number
@param end_time number
]]
local function calculate_percentage(start_time, end_time)
   if not start_time or not end_time then
      return 0
   end
   local time_since_start = (ni.client.get_time() * 1000 - start_time) / 1000
   local time = end_time - start_time
   return time_since_start / time * 100000
end

--[[--
Gets the targets casting percentage completed
 
Parameters:
- **target** `string`
 
Returns:
- **percent_complete** `number`
@param target string
]]
function ni.unit.casting_percent(target)
   local _, _, _, _, start_time, end_time = ni.unit.casting(target)
   return calculate_percentage(start_time, end_time)
end

--[[--
Gets the channel information for the specified target
 
Parameters:
- **target** `string`
 
Returns:
- **...**
 
Notes:
See the returns for UnitChannelInfo
@param target string
]]
function ni.unit.channel(target)
   return UnitChannelInfo(target)
end

--[[--
Gets if the target is channeling currently
 
Parameters:
- **target**
 
Returns:
- **channeling** `boolean`
@param target string
]]
function ni.unit.is_channeling(target)
   return ni.unit.channel(target) and true or false
end

--[[--
Gets the targets channel percentage completed
 
Parameters:
- **target** `string`
 
Returns:
- **percent_complete** `number`
@param target string
]]
function ni.unit.channel_percent(target)
   local _, _, _, _, start_time, end_time = ni.unit.channel(target)
   return calculate_percentage(start_time, end_time)
end

--[[--
Gets if the target is dead or a ghost
 
Parameters:
- **target** `string`
 
Returns:
- **is_dead_or_ghost** `boolean`
@param target string
]]
function ni.unit.is_dead_or_ghost(target)
   return UnitIsDeadOrGhost(target)
end

--[[--
Checks to see if target_a can attack target_b
 
Parameters:
- **target_a** `string`
- **target_b** `string`
 
Returns:
- **unit_can_attack** `boolean`
@param target_a string
@param target_b string
]]
function ni.unit.can_attack(target_a, target_b)
   return UnitCanAttack(target_a, target_b)
end

--[[--
Gets the current power value for a unit
 
Parmeters:
- **target** `string`
- **power_type** `string or number`
 
Returns:
- **current**
@param target string
@param[opt] power_type
]]
function ni.unit.power(target, power_type)
   return ni.power.current(target, power_type)
end

--[[--
Gets the max power value for a unit
 
Parameters:
- **target** `string`
- **power_type** `string or number`
 
Returns:
- **max**
@param target string
@param[opt] power_type
]]
function ni.unit.power_max(target, power_type)
   return ni.power.max(target, power_type)
end

--[[--
Gets the power percentage for a unit
 
Parameters:
- **target** `string`
- **power_type** `string or number`
 
Returns:
- **percent**
@param target string
@param[opt] power_type
]]
function ni.unit.power_percent(target, power_type)
   return ni.power.percent(target, power_type)
end

--[[--
Gets the power deficit for a unit
 
Parameters:
- **target** `string`
- **power_type** `string or number`
 
Returns:
- **deficit** `number`
@param target
@param[opt] power_type
]]
function ni.unit.power_deficit(target, power_type)
   return ni.power.deficit(target, power_type)
end