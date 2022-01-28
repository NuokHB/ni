-------------------
-- Members functions for ni
local ni = ...

--[[--
Table keys:
- **guid** `string`
- **type** `string`
- **name** `string`
- **unit_id** `string`
- **class** `string`
- **is_tank** `boolean`
- **in_range** `boolean`
@table members
]]
ni.members = {}

--[[--
Updates the members table on call.
]]
function ni.members.update()
   ni.members = {}
   local group = ni.group.in_raid() and "raid" or "party"
   for i=1, ni.group.size() do
      local unit_id = group..i
      local guid = ni.unit.guid(unit_id)
      ni.members[guid] = {
         guid = guid,
         type = 4,
         name = ni.unit.name(unit_id),
         unit_id = unit_id,
         class = ni.unit.class(unit_id),
         is_tank = ni.group.is_tank(unit_id),
      }
   end
end