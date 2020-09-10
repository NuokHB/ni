ni.debug = {
	print = function(string)
		if ni.vars.debug then
			print("\124cffff0000" .. string)
		end
	end,
	log = function(str, bool) --bool is optional, true for error message, empty or false for normal
		bool = bool or false;
		str = tostring(str)
		return ni.functions.addlog(str, bool)
	end,
	popup = function(title, text)
		ni.functions.popup(title, text)
	end
}
