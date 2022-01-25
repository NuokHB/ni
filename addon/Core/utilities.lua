-------------------
-- Utility functions for ni
local ni = ...

ni.utilities = {}

--[[--
Gets the HWID for the current users computer base64 encoded.
 
Returns:
- **hwid** `string`
]]
function ni.utilities.get_hwid()
   return ni.backend.GetHWID()
end

--[[--
Logs a message to the lua log file
 
Parameters:
- **message** `string`
@param message string
]]
function ni.utilities.log(message)
   ni.backend.Log(message)
end

--[[--
Checks if a bit is set on an integer
 
Parameters:
- **item** `number`
- **bit** `number`
 
Returns:
- **has_bit** `boolean`
@param item number
@param bit number
]]
function ni.utilities.has_bit(item, bit)
   return item % (bit + bit) >= bit
end

--[[--
Sets the bit of an integer
 
Parameters:
- **item** `number`
- **bit** `number`
 
Returns:
- **value** `number`
@param item number
@param bit number
]]
function ni.utilities.set_bit(item, bit)
   return ni.utilities.has_bit(item, bit) and item or item + bit
end

--[[--
Clears the bit from an integer
 
Parameters:
- **item** `number`
- **bit** `number`
 
Returns:
- **value** `number`
@param item number
@param bit number
]]
function ni.utilities.clear_bit(item, bit)
   return ni.utilities.has_bit(item, bit) and item - bit or item
end

--[[--
Encodes a lua table to a json string
 
Parameters:
- **table** `table`
 
Returns:
- **json** `string`
- **error** `string`
 
Notes:
Can return nil on the json string if there is an error.
@param table
]]
function ni.utilities.to_json(table)
   return ni.backend.ToJson(table)
end

--[[--
Decodes a json string to a lua table
 
Parameters:
- **json** `string`
 
Returns:
- **table** `table`
- **error** `string`
 
Notes:
Can return nil if the string is improperly formed.
@param json
]]
function ni.utilities.from_json(json)
   return ni.backend.FromJson(json)
end