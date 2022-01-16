-------------------
-- Client functions for ni
local ni = ...

ni.client = {}

local GetTime = ni.backend.GetFunction("GetTime")
local GetBuildInfo = ni.backend.GetFunction("GetBuildInfo")


--[[--
Raise a lua error with the specified message.
 
Parameters:
- **message** `string`
@param message string
]]
function ni.client.error(message)
   return ni.backend.Error(message)
end

--[[--
Gets the client C function for the specified string.
 
Parameters:
- **name** `string`
- **binary_name** `string`
 
Returns:
- **function** `function`
 
Notes:
Not all binary functions are registered with the function string passed.
Some may require the binary name to be specified. I.E. tinsert in the binary
is just 'insert'. This function can return nil if a funciton isn't found.
@param name string
@param[opt] binary_name string
]]
function ni.client.get_function(name, binary_name)
   return ni.backend.GetFunction(name, binary_name)
end

--[[--
Registers a frame to be protected from enumeration with the games Lua.
 
Parameters:
- **frame** `frame`
 
Returns:
- **success** `boolean`
@param frame
]]
function ni.client.protect_frame(frame)
   return ni.backend.ProtectFrame(frame)
end

--[[--
Calls a function with the game taint triggering.
 
Parameters:
- **name** `string`
- **...** `functions args`
 
Returns:
- **...** `functions returns`
@param name string
@param[opt] ...
]]
function ni.client.call_protected(name, ...)
   return ni.backend.CallProtected(name, ...)
end

--[[--
Sets the last hardware action as if a key was pressed.
]]
function ni.client.reset_last_hardware_action()
   return ni.backend.ResetLastHardwareAction()
end

--[[--
Gets the computer uptime in seconds
 
Returns:
- **uptime** `number`
]]
function ni.client.get_time()
   return GetTime()
end

--[[--
Runs macro text securely
 
Parameters:
- **text** `string`
@param text string
]]
function ni.client.run_text(text)
   return ni.client.call_protected("RunMacroText", text)
end

--[[--
Gets the wow client build number

Returns:
- **build** `string`

Notes:
335 is 12340,
434 is 15595,
548 is 18414
]]
ni.client.build = select(4, GetBuildInfo())