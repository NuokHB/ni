local modules = { }
ni.utils = {
	loadfile = function(filename)
		return ni.functions.loadlua(filename);
	end,
	loadfiles = function(files)
		for _, v in ipairs(files) do
			if not ni.utils.loadfile(v) then
				ni.debug.log("Failed to load: " .. v, true);
				return false;
			end
		end
		return true;
	end,
	require = function(filename)
		if not filename then
			return;
		end
		if not filename:find(".lua") then
			filename = filename..".lua";
		end
		if modules[filename] then
			return modules[filename];
		else
			modules[filename] = ni.functions.require(filename);
			return modules[filename];
		end
	end,
	loaddatafile = function(filename)
		return ni.functions.loadlua("Rotations\\Data\\" .. filename);
	end,
	loaddatafiles = function(files)
		for _, v in ipairs(files) do
			if not ni.utils.loaddatafile(v) then
				ni.debug.log("Failed to load: "..v, true);
				return false;
			end
		end
		return true;
	end,
	splitstringbydelimiter = function(str, sep)
		if sep == nil then
			sep = "%s"
		end
		local t = {}
		for st in string.gmatch(str, "([^" .. sep .. "]+)") do
			table.insert(t, st)
		end
		return t
	end,
	splitstring = function(str)
                return ni.utils.splitstringbydelimiter(str, "|")
	end,
	splitstringtolower = function(str)
		str = string.lower(str)
		return ni.utils.splitstring(str)
	end,
	findand = function(str)
		return str and (string.match(str, "&&") and true) or nil
	end,
	firstcharacterupper = function(str)
		str = string.lower(str)
		return str:sub(1, 1):upper() .. str:sub(2)
	end,
	savesetting = function(filename, key, ...)
		return ni.functions.savesetting("Settings\\"..filename, key, ...);
	end,
	getsetting = function(filename, key, result_type)
		return ni.functions.getsetting("Settings\\"..filename, key, result_type);
	end,
	fileexists = function(filename)
		return ni.functions.fileexists(filename);
	end,
	resetlasthardwareaction = function()
		ni.functions.resetlasthardwareaction();
	end,
}
