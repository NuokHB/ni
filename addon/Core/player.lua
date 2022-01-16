-------------------
-- Player functions for ni
local ni = ...

ni.player = {}

-- Localized functions
local setmetatable = ni.client.get_function("setmetatable")
local rawset = ni.client.get_function("rawset")

--[[--
Moves the player to the token or coordinates.
 
Parameters:
- **target** `token|guid`
 
Or
- **x** `number`
- **y** `number`
- **z** `number`
@param ...
]]
function ni.player.move_to(...)
   return ni.backend.MoveTo(...)
end

--[[--
Clicks at the location of the target, or coordinates.
 
Parameters:
- **target** `token|guid`
 
Or
- **x** `number`
- **y** `number`
- **z** `number`
@param ...
]]
function ni.player.click_at(...)
   return ni.backend.ClickAt(...)
end

--[[--
Gets the current map information for the player.
 
Returns:
- **map_id** `number`
- **tile_x** `number`
- **tile_y** `number`
]]
function ni.player.get_map_info()
   return ni.backend.GetMapInfo()
end

--[[--
Turns the player to a target, or away from it.
 
Parameters:
- **target** `token|guid`
- **away** `boolean`
@param target string
@param[opt] away boolean
]]
function ni.player.look_at(target, away)
   return ni.backend.LookAt(target, away)
end

--[[--
Stops the players movement.
]]
function ni.player.stop_moving()
   return ni.backend.StopMoving()
end

--[[--
Sets the player creature tracking value.
 
Parameters:
- **value** `number`
@param value
]]
function ni.player.set_creature_tracking(value)
   return ni.backend.SetCreatureTracking(value)
end

--[[--
Sets the player resource tracking value.
 
Parameters:
- **value** `number`
@param value
]]
function ni.player.set_resource_tracking(value)
   return ni.backend.SetResourceTracking(value)
end

--[[--
Sets the players target to the token passed
 
Parameters:
- **target** `string`
@param target string
]]
function ni.player.target(target)
   return ni.client.call_protected("TargetUnit", target)
end

-- Set ni.players metatable to allow unit functions.
setmetatable(ni.player, {
   __index = function(table, key)
      if ni.unit[key] then
         rawset(table, key, function(...)
            return ni.unit[k]("player", ...)
         end)
         return table[key]
      end
   end
})