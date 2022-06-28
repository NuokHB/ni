local ni = ...

ni.mount = {}

local IsMounted = ni.client.get_function("IsMounted")


--[[--
Dismounts the player if the player was mounted.
]]
ni.mount.dismount = function ()
   return ni.client.call_protected("Dismount")
end

--[[--
Returns if the player is mounted
 
Returns:
- **mounted** `boolean`
]]
function ni.mount.is_mounted()
   return IsMounted()
end