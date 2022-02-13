-------------------
-- Members functions for ni
local ni = ...

--[[--
Table keys:
- **guid** `string`
- **name** `string`
- **unit_id** `string`
- **in_range** `boolean`
@table members
]]
ni.members = {}

--[[--
Updates the members table on call.
]]
function ni.members.update()
   for k, v in ni.table.opairs(ni.members) do
      ni.members[k] = nil
   end
   local group = ni.group.in_raid() and "raid" or "party"
   for i=1, ni.group.size() do
      local unit_id = group..i
      local guid = ni.unit.guid(unit_id)
      ni.members[guid] = {
         guid = guid,
         name = ni.unit.name(unit_id),
         unit_id = unit_id,
         in_range = ni.group.in_range(unit_id, 40)
      }
   end
   local player_guid = ni.player.guid()
   if not ni.table.contains_key(ni.members, player_guid) then
      ni.members[player_guid] = {
         guid = player_guid,
         name = ni.unit.name(player_guid),
         unit_id = "player",
         in_range = true
      }
   end
end