-------------------

-- Power functions
local ni = ...

-- Localizations to avoid hooks from servers
local UnitPower = ni.utilities.get_function("UnitPower")
local UnitPowerMax = ni.utilities.get_function("UnitPowerMax")

local power = {}
power.types = {
   mana = 0,
   rage = 1,
   focus = 2,
   energy = 3,
   combopoints = 4,
   runes = 5,
   runicpower = 6,
   soulshards = 7,
   eclipse = 8,
   holy = 9,
   alternate = 10,
   darkforce = 11,
   chi = 12,
   shadoworbs = 13,
   burningembers = 14,
   demonicfury = 15
}

--[[--
Returns the power type value for a target as a percentage
 
Parameters:
- **target** `token|guid`
- **type** `string`

Returns:
- **current power** `number`
@param target string
@param type string
]]
function ni.power.current(target, type)
   if tonumber(type) == nil then
      type = power.types[type]
   end

   return 100 * UnitPower(target, type) / UnitPowerMax(target, type)
end

--[[--
Returns the power type value for a target as raw value
 
Parameters:
- **target** `token|guid`
- **type** `string`

Returns:
- **current power** `number`
@param target string
@param type string
]]
function ni.power.current_raw(target, type)
   if tonumber(type) == nil then
      type = power.types[type]
   end

   return UnitPower(target, type)
end

--[[--
Returns the power type maximum value
 
Parameters:
- **target** `token|guid`
- **type** `string`

Returns:
- **max** `number`
@param target string
@param type string
]]
function ni.power.max(target, type)
   if tonumber(type) == nil then
      type = power.types[type]
   end

   return UnitPowerMax(target, type)
end

--[[--
Returns if the power type is at maximum or full
 
Parameters:
- **target** `token|guid`
- **type** `string`

Returns:
- **ismax** `bool`
@param target string
@param type string
]]
function ni.power.ismax(target, type)
   if tonumber(type) == nil then
      type = power.types[type]
   end

   return UnitPower(target, type) == UnitPowerMax(target, type)
end
