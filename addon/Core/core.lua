local ni = ...
--[[ Backend functions:
	MoveTo
	ClickAt
	RegisterCallback
	Auras
	GetMapInfo
	BestLocation
	CombatReach
	ObjectExists
	GetObjects
	ObjectInfo
	IsFacing
	IsBehind
	HasAura
	Encrypt
	Decrypt
	ParseFile
	LoadFile
	LoadString
	GetContent
	SaveContent
	GetBaseFolder
	GetDistance
	LookAt
	ObjectCreator
	StopMoving
	UnitDynamicFlags
	UnitFlags
	CreatureType
	GetSpellID
	LoS
	ObjectPointer
	BaseAddress
	ObjectTransport
	ObjectFacing
	ResetLastHardwareAction
	CallProtected
	GetDirectoryContents
	GetPath
	FreeMaps
	ObjectDescriptor
	SetCreatureTracking
	SetResourceTracking
	WebRequest
	Read
	Open
	ToggleConsole
	ProtectFrame
	PacketCallback
	GetHWID
	GetFunction
	Error
	MessageBox

]] 

local function GetFileExtension(path)
	return path:match("^.+(%..+)$")
end

local function GetFilename(path, strip)
    local start, finish = path:find('[%w%s!-={-|]+[_%.].+')
	if not start or not finish then
		return nil
	end
    result = path:sub(start,#path)
	if strip and result then
		return result:match("(.+)%..+$")
	end
	return result
end

local function GetProfiles()
	local uc, ti = ni.backend.GetFunction("UnitClass"), ni.backend.GetFunction("tinsert", "insert")
	if not uc or not ti then	
		ni.backend.Error("Unable to get cached functions for GetProfiles")
	end
	local class = select(2, uc("player")):lower()
	local dir = ni.backend.GetBaseFolder()
	local contents = ni.backend.GetDirectoryContents(dir.."addon\\Rotations\\") or {}
	local files = {}
	for i = 1, #contents do
		if contents[i].is_dir and string.match(contents[i].path:lower(), class) then
			local sub_contents = ni.backend.GetDirectoryContents(contents[i].path) or {}
			local processed = false
			for i = 1, #sub_contents do
				if not sub_contents[i].is_dir then
					local extension = GetFileExtension(sub_contents[i].path)
					if extension == ".enc" or extension == ".lua" then
						ti(files, { title = GetFilename(sub_contents[i].path, true), filename = GetFilename(sub_contents[i].path), path = sub_contents[i].path})
						if not processed then
							processed = true
						end
					end
				end
			end
			if processed then
				break
			end
		end
	end
	return files
end

local function LoadProfile(entry)
	local gbi = ni.backend.GetFunction("GetBuildInfo")
	local _, err = ni.backend.ParseFile(entry.path, function(content)
		local version = string.match(content, "--Version:%s*(%d*)")
		if not version or version == select(4,gbi()) then
			local result, err = ni.backend.LoadString(content, string.format("@%s", entry.filename))
			if result then
				result(ni)
				return true
			end
			ni.backend.MessageBox(err, entry.filename, 0x10)
			return false
		end
	end)
end

if not ni.loaded then

    local dir = ni.backend.GetBaseFolder()
    local function LoadCoreFile(entry)
    local func, err = ni.backend.LoadFile(dir.."addon\\core\\"..entry)
    if err then
    ni.backend.Error(err)
    else
    func(ni)
    end
    end

    LoadCoreFile("json.lua")
    local vars = ni.backend.GetContent(dir.."addon\\settings\\"..UnitName("player")..".json")
    if vars ~= nil 
    then
    ni.vars = vars and ni.json.decode(vars)
    else
    LoadCoreFile("vars.lua")
    end

    ni.vars.profiles.enabled = false;
    ni.vars.profiles.genericenabled = false;
    ni.vars.profiles.delay = 0;
	ni.vars.build = select(4, GetBuildInfo())
    ni.backend.SaveContent(dir.."addon\\settings\\"..UnitName("player")..".json", ni.json.encode(ni.vars))
	local corefiles = {"mwcrand.lua", "debug.lua", "memory.lua", "rotation.lua", "bootstrap.lua", "tables.lua", "drtracker.lua", "utils.lua", "frames.lua", "spell.lua", "power.lua", "rune.lua", "unit.lua", "player.lua", "healing.lua", "members.lua", "objectmanager.lua", "stopcastingtracker.lua", "timetodie.lua", "gui.lua", "mainui.lua", }
	
	for i = 1, #corefiles do
	LoadCoreFile(corefiles[i])
	end
	
   	ni.showstatus = function(str, enabled)
		if enabled then
			ni.frames.floatingtext:message("\124cff00ff00" .. str)
		else
			ni.frames.floatingtext:message("\124cffff0000" .. str)
		end
	end
	ni.toggleprofile = function(str)
		local unload = false;
		if ni.vars.profiles.active == str then
			ni.vars.profiles.enabled = not ni.vars.profiles.enabled;
			if ni.vars.profiles.enabled == false then
				unload = true;
			end
		else
			unload = true;
			ni.vars.profiles.enabled = true;
			ni.vars.profiles.active = str;
		end
		if unload then
			if ni.rotation.profile[ni.rotation.lastprofile] then
				if ni.rotation.profile[ni.rotation.lastprofile].unload then
					ni.rotation.profile[ni.rotation.lastprofile]:unload();
				end
				if ni.rotation.profile[ni.rotation.lastprofile].destroyGUI then
					ni.rotation.profile[ni.rotation.lastprofile]:destroyGUI();
				end
			end
		end
		if ni.vars.profiles.enabled then
			if ni.rotation.profile[str] then
				if ni.rotation.profile[str].load then
					ni.rotation.profile[str]:load();
				end
				if ni.rotation.profile[str].createGUI then
					ni.rotation.profile[str]:createGUI();
				end
			end
		end
		if ni.rotation.lastprofile ~= str then
			ni.rotation.lastprofile = str;
		end
		ni.showstatus(str, ni.vars.profiles.enabled);
	end

	ni.togglegeneric = function(str)
		local unload = false;
		if ni.vars.profiles.generic == str then
			ni.vars.profiles.genericenabled = not ni.vars.profiles.genericenabled;
			if ni.vars.profiles.genericenabled == false then
				unload = true;
			end
		else
			unload = true;
			ni.vars.profiles.genericenabled = true;
			ni.vars.profiles.generic = str;
		end
		if unload then
			if ni.rotation.profile[ni.rotation.lastgeneric] then
				if ni.rotation.profile[ni.rotation.lastgeneric].unload then
					ni.rotation.profile[ni.rotation.lastgeneric]:unload();
				end
				if ni.rotation.profile[ni.rotation.lastgeneric].destroyGUI then
					ni.rotation.profile[ni.rotation.lastgeneric]:destroyGUI();
				end
			end
		end
		if ni.vars.profiles.genericenabled then
			if ni.rotation.profile[str] then
				if ni.rotation.profile[str].load then
					ni.rotation.profile[str]:load();
				end
				if ni.rotation.profile[str].createGUI then
					ni.rotation.profile[str]:createGUI();
				end
			end
		end
		if ni.rotation.lastgeneric ~= str then
			ni.rotation.lastgeneric = str;
		end
		ni.showstatus(str, ni.vars.profiles.genericenabled);
	end

	ni.showintstatus = function()
		if ni.vars.profiles.interrupt then
			ni.frames.floatingtext:message("Interrupts: \124cff00ff00Enabled")
		else
			ni.frames.floatingtext:message("Interrupts: \124cffff0000Disabled")
		end
	end

	ni.updatefollow = function(enabled)
		if enabled then
			ni.frames.floatingtext:message("Auto follow: \124cff00ff00Enabled")
		else
			ni.frames.floatingtext:message("Auto follow: \124cffff0000Disabled")
		end
	end

	ni.getspellidfromactionbar = function()
		local focus = GetMouseFocus():GetName()
		if string.match(focus, "Button") then
			local button = _G[focus]
			local slot =
				ActionButton_GetPagedID(button) or ActionButton_CalculateAction(button) or button:GetAttribute("action") or 0
			if HasAction(slot) then
				local aType, aID, _, aMaxID = GetActionInfo(slot)
				if aType == "spell" then
					return aMaxID ~= nil and aMaxID or aID
				end
			end
		end
	end
	ni.functionsregistered = function()
		return ni.backend.ToggleConsole ~= nil
	end
	ni.frames.main:SetScript("OnUpdate", ni.frames.OnUpdate);
	ni.frames.main:SetScript("OnEvent", ni.frames.OnEvent);

	if ni.vars["global"] then
		_G[ni.vars["global"]] = ni;
	end
	ni.loaded = true

end