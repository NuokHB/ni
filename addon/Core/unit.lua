-------------------
-- Unit functions for ni
local ni = ...

ni.unit = {}

-- Localizations to avoid hooks from servers
local UnitExists = ni.client.get_function("UnitExists")

----------
-- Table keys:
-- - **name** `string`
-- - **ID** `number`
-- @table aura

----------
-- Gets the auras on the specified target.
-- 
-- Parameters:
-- - **target** `token|guid`
-- 
-- Returns:
-- - **auras** `aura table`
-- @param target string
function ni.unit.auras(target)
   return ni.backend.Auras(target)
end

----------
-- Gets the best location that meets the criteria passed.
-- 
-- Parameters:
-- - **target** `token|guid`
-- - **distance** `number`
-- - **radius** `number`
-- - **score** `number`
-- - **callback** `function`
-- - **friendly** `boolean`
-- - **height_max** `number`
-- - **max_distance** `number`
-- 
-- Returns:
-- - **x** `number`
-- - **y** `number`
-- - **z** `number`
-- @param target string
-- @param distance number
-- @param radius number
-- @param[opt] score number
-- @param[opt] callback function
-- @param[opt] friendly boolean
-- @param[opt] height_max number
-- @param[opt] max_distance number
function ni.unit.best_location(target, distance, radius, score, callback, friendly, height_max, max_distance)
   return ni.backend.BestLocation(target, distance, radius, score, callback, friendly, height_max, max_distance)
end

----------
-- Wrapper for best_location for friendly target
-- 
-- Parameters:
-- - **target** `token|guid`
-- - **distance** `number`
-- - **radius** `number`
-- - **score** `number`
-- - **callback** `function`
-- - **height_max** `number`
-- - **max_distance** `number`
-- 
-- Returns:
-- - **x** `number`
-- - **y** `number`
-- - **z** `number`
-- @param target string
-- @param distance number
-- @param radius number
-- @param[opt] score number
-- @param[opt] callback function
-- @param[opt] height_max number
-- @param[opt] max_distance number
function ni.unit.best_helpful_location(target, distance, radius, score, callback, height_max, max_distance)
   return ni.backend.BestLocation(target, distance, radius, score, callback, true, height_max, max_distance)
end

----------
-- Wrapper for best_location for enemy target
-- 
-- Parameters:
-- - **target** `token|guid`
-- - **distance** `number`
-- - **radius** `number`
-- - **score** `number`
-- - **callback** `function`
-- - **height_max** `number`
-- - **max_distance** `number`
-- 
-- Returns:
-- - **x** `number`
-- - **y** `number`
-- - **z** `number`
-- @param target string
-- @param distance number
-- @param radius number
-- @param[opt] score number
-- @param[opt] callback function
-- @param[opt] height_max number
-- @param[opt] max_distance number
function ni.unit.best_damage_location(target, distance, radius, score, callback, height_max, max_distance)
   return ni.backend.BestLocation(target, distance, radius, score, callback, false, height_max, max_distance)
end

----------
-- Gets the combat reach for the specified target.
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **combat_reach** `number`
-- @param target string
function ni.unit.combat_reach(target)
   return ni.backend.CombatReach(target)
end

----------
-- Checks if the unit exists.
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **exists** `boolean`
-- @param target string
function ni.unit.exists(target)
   return UnitExists(target)
end

----------
-- Gets the information of the specified target
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **x** `number`
-- - **y** `number`
-- - **z** `number`
-- - **facing** `number`
-- - **target** `string`
-- - **height** `number`
-- @param target string
function ni.unit.info(target)
   return ni.backend.ObjectInfo(target)
end

----------
-- Gets the location of the specified target.
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **x** `number`
-- - **y** `number`
-- - **z** `number`
-- @param target string
function ni.unit.location(target)
   return ni.object.location(target)
end

----------
-- Checks if one target is facing another.
-- 
-- Parameters:
-- - **target_a** `string`
-- - **target_b** `string`
-- - **field_of_view** `number`
-- 
-- Returns:
-- - **facing** `boolean`
-- @param target_a string
-- @param target_b string
-- @param[opt] field_of_view number
function ni.unit.is_facing(target_a, target_b, field_of_view)
   return ni.backend.IsFacing(target_a, target_b, field_of_view)
end

----------
-- Checks if one target is behind another.
-- 
-- Parameters:
-- - **target_a** `string`
-- - **target_b** `string`
-- 
-- Returns:
-- - **behind** `boolean`
-- @param target_a string
-- @param target_b string
function ni.unit.is_behind(target_a, target_b)
   return ni.backend.IsBehind(target_a, target_b)
end

----------
-- Checks if a target has a specific aura id.
-- 
-- Parameters:
-- - **target** `string`
-- - **id** `number`
-- 
-- Returns:
-- - **has_aura** `boolean`
-- @param target string
-- @param id number
function ni.unit.has_aura(target, id)
   return ni.backend.HasAura(target, id)
end

----------
-- Gets the distance between two targets.
-- 
-- Parameters:
-- - **target_a** `string`
-- - **target_b** `string`
-- 
-- Returns:
-- - **distance** `number`
-- @param target_a string
-- @param target_b string
function ni.unit.distance(target_a, target_b)
   return ni.backend.GetDistance(target_a, target_b)
end

----------
-- Gets the GUID of the units creator.
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **guid** `string`
-- @param target string
function ni.unit.creator(target)
   return ni.object.creator(target)
end

----------
-- Gets the units dynamic flags.
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **flags** `boolean`
-- 
-- Notes:
-- This function will return 9 different values which are all booleans for the
-- dynamic flags 1 - 9. (Dynamic flag titles may be different for expansions)
-- I was being lazy, and didn't want to type out the 9 different returns.
-- @param target string
function ni.unit.dynamic_flags(target)
   return ni.backend.UnitDynamicFlags(target)
end

----------
-- Gets the units flags.
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **flags** `boolean`
-- 
-- Notes:
-- This function will return 32 different values which are all booleans for the
-- dynamic flags 1 - 32. (Flag titles may be different for expansions)
-- I was being lazy, and didn't want to type out the 32 different returns.
-- @param target string
function ni.unit.flags(target)
   return ni.backend.UnitFlags(target)
end

----------
-- Gets the units creature type.
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **creature_type** `number`
-- @param target string
function ni.unit.type(target)
   return ni.backend.CreatureType(target)
end

----------
-- Checks if two units are in line of sight of each other.
-- 
-- Parameters:
-- - **target_a** `string`
-- - **target_b** `string`
-- - **hit_flags** `number`
-- 
-- Returns:
-- - **success** `boolean`
-- - **intersection_x** `number`
-- - **intersection_y** `number`
-- - **intersection_z** `number`
-- @param target_a string
-- @param target_b string
-- @param[opt] hit_flags number
function ni.unit.los(target_a, target_b, hit_flags)
   return ni.backend.LoS(target_a, target_b, hit_flags)
end

----------
-- Gets the units pointer
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **pointer** `number`
-- - **hex_pointer** `string`
-- @param target string
function ni.unit.pointer(target)
   return ni.object.pointer(target)
end

----------
-- Gets the units transport guid
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **guid** `string`
-- @param target string
function ni.unit.transport(target)
   return ni.object.transport(target)
end

----------
-- Gets the units facing in radians
-- 
-- Parameters:
-- - **target** `string`
-- 
-- Returns:
-- - **direction** `number`
-- @param target string
function ni.unit.facing(target)
   return ni.backend.ObjectFacing(target)
end

----------
-- Gets the unit descriptor value for the given index
-- 
-- Parameters:
-- - **target** `string`
-- - **index** `number`
-- 
-- Returns:
-- - **descriptor** `number`
-- @param target string
-- @param index number
function ni.unit.descriptor(target, index)
   return ni.object.descriptor(target, index)
end