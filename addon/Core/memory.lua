local memory = {
	baseaddress = function()
		return ni.backend.BaseAddress();
	end,
	objectpointer = function(object)
		return ni.backend.ObjectPointer(object);
	end,
	read = function(readtype, address, ...)
		return ni.backend.Read(readtype, address, ...);
	end
}
return memory;