-------------------
-- Navigation functions for ni
local ni = ...

ni.navigation = {}

--[[--
Table keys:
- **x** `number`
- **y** `number`
- **z** `number`
@table xyz
]]

--[[--
Gets a path from start to end point with navigation mesh.
 
Parameters:
- **x1** `number`
- **y1** `number`
- **z1** `number`
- **x2** `number`
- **y2** `number`
- **z2** `number`
- **includes** `number`
- **excludes** `number`
 
Returns:
- **path** `xyz table`
@param x1 number
@param y1 number
@param z1 number
@param x2 number
@param y2 number
@param z2 number
@param[opt] includes number
@param[opt] excludes number
]]
function ni.navigation.get_path(x1, y1, z1, x2, y2, z2, includes, excludes)
   return ni.backend.GetPath(x1, y1, z1, x2, y2, z2, includes, excludes)
end

--[[--
Frees the maps loaded in memory.
]]
function ni.navigation.free_maps()
   return ni.backend.FreeMaps()
end