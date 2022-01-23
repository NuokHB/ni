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
Implementation of ipairs.
 
Parameters:
- **table** `table`
 
Returns:
- **key** `number`
- **value**
@param table table
]]
function ni.utilities.ipairs(table)
   local function iterator(table, i)
      i = i + 1
      local v = table[i]
      -- Explicitly checking it's not nil, because it could be false
      if v ~= nil then 
         return i, v
      end
   end
   return iterator, table, 0
end

--[[--
Implementation of pairs.
 
Parameters:
- **table** `table`
 
Returns:
- **key**
- **value**
@param table table
]]
function ni.utilities.pairs(table)
   local function iterator(table, k)
      local v
      k, v = ni.backend.Next(table, k)
      -- Explicitly checking it's not nil, because it could be false
      if v ~= nil then
         return k, v
      end
   end
   return iterator, table, nil
end

-- TODO: Objects iterator

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

function ni.utilities.set_bit(item, bit)
   return ni.utilities.has_bit(item, bit) and item or item + bit
end

function ni.utilities.clear_bit(item, bit)
   return ni.utilities.has_bit(item, bit) and item - bit or item
end