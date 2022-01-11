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
-- Helper functions
--------------------
--[[
	Description: Gets the file extension from a given path
	Arguments:
		path - [string, required] Path containing an extension to get
	Returns:
		string or nil
]]
local function GetFileExtension(path)
	return path:match("^.+(%..+)$")
end
--[[
	Description: Gets the filename from a given path
	Arguments:
		path - [string, required] Path containing a filename
		strip - [boolean, optional] Strip the extension from the filename if true
	Returns:
		string or nil
]]
local function GetFilename(path, strip)
	local start, finish = path:find("[%w%s!-={-|]+[_%.].+")
	if not start or not finish then
		return nil
	end
	local result = path:sub(start, #path)
	if strip and result then
		return result:match("(.+)%..+$")
	end
	return result
end
--[[
	Description: Gets the profiles for the players class
	Arguments:
		none
	Returns:
		table [ key=integer, value=table ]
			value [table][ title, filename, path ]
]]
local function GetProfiles()
	local uc, ti = ni.backend.GetFunction("UnitClass"), ni.backend.GetFunction("tinsert", "insert")
	if not uc or not ti then
		ni.backend.Error("Unable to get cached functions for GetProfiles")
	end
	local class = select(2, uc("player")):lower()
	local contents = ni.backend.GetDirectoryContents("addon\\Rotations\\") or {}
	local files = {}
	for i = 1, #contents do
		if contents[i].is_dir and string.match(contents[i].path:lower(), class) then
			local sub_contents = ni.backend.GetDirectoryContents(contents[i].path) or {}
			local processed = false
			for i = 1, #sub_contents do
				if not sub_contents[i].is_dir then
					local extension = GetFileExtension(sub_contents[i].path)
					if extension == ".enc" or extension == ".lua" then
						local vers = 0
						local c
						local _, err
						ni.backend.ParseFile(
							sub_contents[i].path,
							function(content)
								vers = tonumber(string.match(content, "--Version:%s*(%d[,.%d]*)"))
								c = content
							end
						)
						ti(
							files,
							{
								title = GetFilename(sub_contents[i].path, true),
								filename = GetFilename(sub_contents[i].path),
								path = sub_contents[i].path,
								version = vers or 0,
								content = c
							}
						)
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
--[[
	Description: Parses and loads the table entry provided
	Arguments:
		entry - [table, required] Entry from the GetProfiles function (keys of: title, filename, path)
	Returns:
		none/nil
]]
local function LoadProfile(entry)
	local _, err =
		ni.backend.ParseFile(
		entry.path,
		function(content)
			local result, err = ni.backend.LoadString(content, string.format("@%s", entry.filename))
			if result ~= nil then
				result(ni)
				return true
			end
			ni.backend.MessageBox(err, entry.filename, 0x10)
			return false
		end
	)
end

-- Need to create method for loading everying up now
local function LoadFile(file)
	local dir = ni.backend.GetBaseFolder()
	local func, error = ni.backend.LoadFile(dir .. file)
	if error then
		ni.backend.Error(error, file)
	end
	return func
end

if not ni.loaded then
	ni.profiles = GetProfiles() or {}
	local dir = ni.backend.GetBaseFolder()
	local cf = ni.backend.GetFunction("CreateFrame")
	if not cf then
		ni.backend.Error("Unable to get CreateFrame")
	end
	ni.frames = {}
	local frame = cf("frame")
	local json = LoadFile("addon\\core\\json.lua")(ni)
	local unitname = ni.backend.GetFunction("UnitName")
	local vars = ni.backend.GetContent(dir .. "addon\\settings\\" .. unitname("player") .. ".json")
	ni.vars = (vars and json.decode(vars)) or LoadFile("addon\\core\\vars.lua")(ni)
	ni.vars.profiles.enabled = false
	ni.vars.profiles.genericenabled = false
	ni.vars.profiles.delay = 0
	local GetBuildInfo = ni.backend.GetFunction("GetBuildInfo")
	ni.vars.build = tonumber((select(4, GetBuildInfo())))
	ni.backend.SaveContent(dir .. "addon\\settings\\" .. unitname("player") .. ".json", json.encode(ni.vars))
	ni.debug = LoadFile("addon\\core\\debug.lua")(ni)
	ni.memory = LoadFile("addon\\core\\memory.lua")(ni)
	ni.rotation = LoadFile("addon\\core\\rotation.lua")(ni)
	ni.bootstrap = LoadFile("addon\\core\\bootstrap.lua")(ni)
	ni.tables = LoadFile("addon\\core\\tables.lua")(ni)
	ni.drtracker = LoadFile("addon\\core\\drtracker.lua")(ni)
	ni.utils = LoadFile("addon\\core\\utils.lua")(ni)
	ni.utils.json = json
	ni.utils.LoadProfile = LoadProfile
	ni.utils.LoadFile = LoadFile
	ni.utils.savesetting = function(filename, settings)
		if type(settings) == "table" then
			settings = json.encode(settings)
		end
		ni.backend.SaveContent(dir .. "addon\\Settings\\" .. filename, settings)
	end
	ni.utils.getsettings = function(filename)
		local content = ni.backend.GetContent(dir .. "addon\\Settings\\" .. filename)
		return content and json.decode(content) or {}
	end
	ni.frames, ni.combatlog, ni.delayfor, ni.icdtracker, ni.events = LoadFile("addon\\core\\frames.lua")(ni)
	ni.spell = LoadFile("addon\\core\\spell.lua")(ni)
	ni.power = LoadFile("addon\\core\\power.lua")(ni)
	ni.rune = LoadFile("addon\\core\\rune.lua")(ni)
	ni.unit = LoadFile("addon\\core\\unit.lua")(ni)
	ni.player = LoadFile("addon\\core\\player.lua")(ni)
	ni.healing = LoadFile("addon\\core\\healing.lua")(ni)
	ni.members = LoadFile("addon\\core\\members.lua")(ni)
	ni.objects, ni.objectmanager = LoadFile("addon\\core\\objectmanager.lua")(ni)
	ni.stopcastingtracker = LoadFile("addon\\core\\stopcastingtracker.lua")(ni)
	ni.ttd = LoadFile("addon\\core\\timetodie.lua")(ni)
	ni.OverlayUi = LoadFile("addon\\core\\OverlayUi.lua")(ni)
	ni.OverlayUi.window.Open = true
	ni.GUI = LoadFile("addon\\core\\gui.lua")(ni)
	ni.strongrand = LoadFile("addon\\core\\mwcrand.lua")(ni)
	local function RandomVariable(length)
		local res = ""
		for i = 1, length do
			res = res .. string.char(ni.strongrand.generate(97, 122))
		end
		return res
	end
	local generated_names = {}

	ni.utils.GenerateRandomName = function()
		local name = RandomVariable(20)
		while tContains(generated_names, name) do
			name = RandomVariable(20)
		end
		table.insert(generated_names, name)
		return name
	end
	--ni.main = LoadFile("addon\\core\\mainui.lua")(ni)
	ni.showstatus = function(str, enabled)
		if enabled then
			ni.frames.floatingtext:message("\124cff00ff00" .. str)
		else
			ni.frames.floatingtext:message("\124cffff0000" .. str)
		end
	end
	ni.toggleprofile = function(str)
		local unload = false
		if ni.vars.profiles.active == str then
			ni.vars.profiles.enabled = not ni.vars.profiles.enabled
			if ni.vars.profiles.enabled == false then
				unload = true
			end
		else
			unload = true
			ni.vars.profiles.enabled = true
			ni.vars.profiles.active = str
		end
		if unload then
			if ni.rotation.profile[ni.rotation.lastprofile] then
				if ni.rotation.profile[ni.rotation.lastprofile].unload then
					ni.rotation.profile[ni.rotation.lastprofile]:unload()
				end
				if ni.rotation.profile[ni.rotation.lastprofile].destroyGUI then
					ni.rotation.profile[ni.rotation.lastprofile]:destroyGUI()
				end
			end
		end
		if ni.vars.profiles.enabled then
			if ni.rotation.profile[str] then
				if ni.rotation.profile[str].load then
					ni.rotation.profile[str]:load()
				end
				if ni.rotation.profile[str].createGUI then
					ni.rotation.profile[str]:createGUI()
				end
			end
		end
		if ni.rotation.lastprofile ~= str then
			ni.rotation.lastprofile = str
		end
		ni.showstatus(str, ni.vars.profiles.enabled)
	end

	ni.togglegeneric = function(str)
		local unload = false
		if ni.vars.profiles.generic == str then
			ni.vars.profiles.genericenabled = not ni.vars.profiles.genericenabled
			if ni.vars.profiles.genericenabled == false then
				unload = true
			end
		else
			unload = true
			ni.vars.profiles.genericenabled = true
			ni.vars.profiles.generic = str
		end
		if unload then
			if ni.rotation.profile[ni.rotation.lastgeneric] then
				if ni.rotation.profile[ni.rotation.lastgeneric].unload then
					ni.rotation.profile[ni.rotation.lastgeneric]:unload()
				end
				if ni.rotation.profile[ni.rotation.lastgeneric].destroyGUI then
					ni.rotation.profile[ni.rotation.lastgeneric]:destroyGUI()
				end
			end
		end
		if ni.vars.profiles.genericenabled then
			if ni.rotation.profile[str] then
				if ni.rotation.profile[str].load then
					ni.rotation.profile[str]:load()
				end
				if ni.rotation.profile[str].createGUI then
					ni.rotation.profile[str]:createGUI()
				end
			end
		end
		if ni.rotation.lastgeneric ~= str then
			ni.rotation.lastgeneric = str
		end
		ni.showstatus(str, ni.vars.profiles.genericenabled)
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
	ni.frames.main:SetScript("OnUpdate", ni.frames.OnUpdate)
	ni.frames.main:SetScript("OnEvent", ni.frames.OnEvent)

	if ni.vars["global"] then
		_G[ni.vars["global"]] = ni
	end
	ni.backend.ProtectFrame(frame)
	ni.loaded = true
end
