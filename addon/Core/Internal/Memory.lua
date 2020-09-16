ni.memory = {
	baseaddress = function()
		return ni.functions.baseaddress();
	end,
	objectpointer = function(object)
		return ni.functions.objectpointer(object);
	end,
	read = function(readtype, address, ...) --readtype: float, double, uint64_t; address: address to read; ...: optional offsets
		return ni.functions.read(readtype, address, ...);
	end,
}