local ni = ...
local debug = {
	print = function(string)
		local p = ni.backend.GetFunction("print")
		if ni.vars.debug then
			p("\124cffff0000" .. string)
		end
	end,
	log = function(string)
	end
}
return debug
