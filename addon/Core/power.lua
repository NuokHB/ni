-------------------
-- Power functions
local ni = ...

-- Localizations to avoid hooks from servers
local UnitPower = ni.utilities.get_function("UnitPower")
local UnitPowerMax = ni.utilities.get_function("UnitPowerMax")

ni.power = {}

--[[--
WoW Power types with there respective ingame value
]]
ni.power.power_types = {
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
- **power_type** `string`
 
Returns:
- **current power** `number`
@param target string
@param power_type string
]]
function ni.power.current_percent(target, power_type)
   if type(power_type) == "string" then
      power_type = ni.power.power_types[power_type]
   end

   return 100 * UnitPower(target, power_type) / UnitPowerMax(target, power_type)
end

--[[--
Returns the power type value for a target as raw value
 
Parameters:
- **target** `token|guid`
- **power_type** `string`
 
Returns:
- **current power** `number`
@param target string
@param power_type string
]]
function ni.power.current(target, power_type)
   if type(power_type) == "string" then
      power_type = ni.power.power_types[power_type]
   end

   return UnitPower(target, power_type)
end

--[[--
Returns the power type maximum value
 
Parameters:
- **target** `token|guid`
- **power_type** `string`
 
Returns:
- **max** `number`
@param target string
@param power_type string
]]
function ni.power.max(target, power_type)
   if type(power_type) == "string" then
      power_type = ni.power.power_types[power_type]
   end

   return UnitPowerMax(target, power_type)
end

--[[--
Returns if the power type is at maximum or full
 
Parameters:
- **target** `token|guid`
- **type** `string`
 
Returns:
- **ismax** `boolean`
@param target string
@param type string
]]
function ni.power.is_max(target, power_type)
   if type(power_type) == "string" then
      power_type = ni.power.power_types[power_type]
   end

   return UnitPower(target, power_type) == UnitPowerMax(target, power_type)
end
