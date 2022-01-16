-------------------
-- Utility functions for ni
local ni = ...

ni.utilities = {}

--[[--
Checks if a table contains a key.
 
Returns:
- **contains** `boolean`
@param table table
@param key
]]
function ni.utilities.table_contains_key(table, key)
   return table[key] ~= nil
end

--[[--
Checks if a table contains a value.
 
Returns:
- **contains** `boolean`
@param table table
@param value
]]
function ni.utilities.table_contains_value(table, value)
   for _, v in pairs(table) do
      if v == value then
         return true
      end
   end
   return false
end

--[[--
Gets the HWID for the current users computer base64 encoded.
 
Returns:
- **hwid** `string`
]]
function ni.utilities.get_hwid()
   return ni.backend.GetHWID()
end