local ni = ...

ni.bags = {}

local GetItemCount = ni.client.get_function("GetItemCount")
local GetItemInfo = ni.client.get_function("GetItemInfo")
local GetItemCooldown = ni.client.get_function("GetItemCooldown")

--[[--
Gets the items charges
 
Parameters:
- **item** `number`
 
Returns:
- **charges** `number`
@param item
]]
function ni.bags.charges(item)
   return GetItemCount(item, false, true)
end

--[[--
Gets the item count for an item
 
Parameters:
- **item** `number or string`

Returns:
- **count** `number`
@param item number 
]]
function ni.bags.count(item)
   return GetItemCount(item, false, false)
end

--[[--
Checks if the item is in the players bags.
 
Parameters:
- **item** `number or string`
 
Returns:
- **has_item** `boolean`
@param item number
]]
function ni.bags.has(item)
   return ni.bags.count(item) > 0
end

--[[--
Uses the item in the players bags
 
Parameters:
- **item** `number or string`
- **target** `string`
@param item
@param[opt] target string
]]
function ni.bags.use(item, target)
   if tonumber(item) then
      item = GetItemInfo(item)
   end
   return ni.client.call_protected("UseItemByName", item, target)
end

--[[--
Gets the cooldown time of an item
 
Parameters:
- **item** `number`
 
Returns:
-- **cooldown** `number`
@param item number
]]
function ni.bags.cooldown(item)
   local start, duration, enabled = GetItemCooldown(item)
   if start > 0 and duration > 0 then
      return start + duration - ni.client.get_time()
   end
   return 0
end