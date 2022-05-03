-------------------
-- Members functions for ni
local ni = ...

local setmetatable = ni.client.get_function("setmetatable")
local rawset = ni.client.get_function("rawset")

--[[--
Table keys:
- **guid** `string`
- **unit_id** `string`
@table members
]]
ni.members = {}

local lastUpdate = 0
local updating = false

--[[--
Updates the members table on call.
]]
function ni.members.update()
   if updating then
      return
   end
   updating = true
   local time = ni.client.get_time()
   if time - lastUpdate < 1000 then
      return
   else
      lastUpdate = time
   end
   ni.table.owipe(ni.members)
   local group = ni.group.in_raid() and "raid" or "party"
   for i=1, ni.group.size() do
      local unit_id = group..i
      local guid = ni.unit.guid(unit_id)
      ni.members[guid] = {
         guid = guid,
         unit_id = unit_id,
      }
      setmetatable(ni.members[guid], {
         __index = function(table, key)
            if ni.unit[key] then
               rawset(table, key, function(...)
                  return ni.unit[key](unit_id, ...)
               end)
               return table[key]
            end
         end
      })
   end
   --Make sure we include the player in the table
   local player_guid = ni.player.guid()
   if not ni.table.contains_key(ni.members, player_guid) then
      ni.members[player_guid] = {
         guid = player_guid,
         unit_id = "player",
      }
      setmetatable(ni.members[player_guid], {
         __index = function(table, key)
            if ni.unit[key] then
               rawset(table, key, function(...)
                  return ni.unit[key]("player", ...)
               end)
               return table[key]
            end
         end
      })
   end
   updating = false
end