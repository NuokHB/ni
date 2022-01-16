-------------------
-- Object functions for ni
local ni = ...

ni.object = {}

--[[--
Checks if the given object is within game memory
 
Parameters:
- **object** `string`
 
Returns:
- **exists** `boolean`
@param object string
]]
function ni.object.exists(object)
   return ni.backend.ObjectExists(object)
end

--[[--
Gets the objects type.
 
Parameters:
- **object** `string`
 
Returns:
- **type** `number`
@param object string
]]
function ni.object.type(object)
   local _, _, _, type = ni.backend.ObjectInfo(object)
   return type
end

--[[--
Gets if the object is a player
 
Parameters:
- **object** `string`
 
Returns:
- **is_player** `boolean`
@param object string
]]
function ni.object.is_player(object)
   return ni.object.type(object) == 4
end

--[[--
Gets if the object is a unit
 
Parameters:
- **object** `string`
 
Returns:
- **is_unit** `boolean`
@param object string
]]
function ni.object.is_unit(object)
   return ni.object.type(object) == 3
end

--[[--
Gets the object location information
 
Parameters:
- **token** `string`
 
Returns:
- **x** `number`
- **y** `number`
- **z** `number`
@param token string
]]
function ni.object.location(token)
   -- If you pass a unit/player it will return more.
   -- Doing this for sanity just so only 3 returns happen.
   local x, y, z = ni.backend.ObjectInfo(token)
   return x, y, z
end

--[[--
Gets the GUID of the objects creator.
 
Parameters:
- **object** `string`
 
Returns:
- **guid** `string`
@param object string
]]
function ni.object.creator(object)
   return ni.backend.ObjectCreator(object)
end

--[[--
Gets the objects pointer
 
Parameters:
- **object** `string`
 
Returns:
- **pointer** `number`
- **hex_pointer** `string`
@param object string
]]
function ni.object.pointer(object)
   return ni.backend.ObjectPointer(object)
end

--[[--
Gets the objects transport guid
 
Parameters:
- **object** `string`
 
Returns:
- **guid** `string`
@param object string
]]
function ni.object.transport(object)
   return ni.backend.ObjectTransport(object)
end

--[[--
Gets the object descriptor value for the given index
 
Parameters:
- **object** `string`
- **index** `number`
 
Returns:
- **descriptor** `number`
@param object string
@param index number
]]
function ni.object.descriptor(object, index)
   return ni.backend.ObjectDescriptor(object, index)
end