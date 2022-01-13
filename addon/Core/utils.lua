local ni = ...;
ni.utils = {}

ni.utils.splitstringbydelimiter = function(str, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for st in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(t, st)
	end
	return t
end;
ni.utils.splitstring = function(str)
	return ni.utils.splitstringbydelimiter(str, "|")
end;
ni.utils.splitstringtolower = function(str)
	str = string.lower(str)
	return ni.utils.splitstring(str)
end;
ni.utils.findand = function(str)
	return str and (string.match(str, "&&") and true) or nil
end;
ni.utils.firstcharacterupper = function(str)
	str = string.lower(str)
	return str:sub(1, 1):upper() .. str:sub(2)
end;
ni.utils.resetlasthardwareaction = function()
	ni.backend.ResetLastHardwareAction();
end;
ni.utils.savesetting = function(filename, settings)
    local dir = ni.backend.GetBaseFolder()
	if type(settings) == "table" then
    settings = ni.json.encode(settings);
	end
	ni.backend.SaveContent(dir.."addon\\Settings\\"..filename, settings);
end
ni.utils.getsettings = function(filename)
    local dir = ni.backend.GetBaseFolder()
	local content = ni.backend.GetContent(dir.."addon\\Settings\\"..filename);
	return content and ni.json.decode(content) or { };
end
local function RandomVariable(length)
    local res = ""
    for i = 1, length do
    res = res .. string.char(ni.strongrand.generate(97, 122))
    end
    return res
end
	
local generated_names = {}
ni.utils.GenerateRandomName = function()
	local name = RandomVariable(20);
    while tContains(generated_names, name) do
	name = RandomVariable(20);
	end
	table.insert(generated_names, name);
	return name;
end

ni.utils.mergetables = function(firsttable, secondtable)
	local tmp = {}

	for _, v in pairs(firsttable) do
		table.insert(tmp, v)
	end

	for _, v in pairs(secondtable) do
		table.insert(tmp, v)
	end

	return tmp
end;