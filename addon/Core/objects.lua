-------------------
-- Objects functions for ni
local ni = ...

ni.objects = {}

--[[--
@local
Enumeration callback for getting the objects
 
Parameters:
- **t** `number`
- **g** `string`
- **n** `string`
@param t
@param g
@param n
]]
local function enumerate(t, g, n)
   local enumeration_table = {type = t, guid = g, name = n}
   ni.objects[g] = enumeration_table
end

local lastUpdate = 0

--[[--
Updates the objects table on call.
]]
function ni.objects.update()
   if not ni.in_game then
      ni.table.owipe(ni.objects)
      return
   end
   local time = ni.client.get_time()
   if time - lastUpdate < ni.settings.main.latency then
      return
   else
      lastUpdate = time
   end
   for k, v in ni.table.opairs(ni.objects) do
      if not ni.object.exists(k) then
         ni.objects[k] = nil
      end
   end
   ni.backend.GetObjects(enumerate)
end