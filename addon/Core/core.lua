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
	result = path:sub(start, #path)
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
						ti(
							files,
							{
								title = GetFilename(sub_contents[i].path, true),
								filename = GetFilename(sub_contents[i].path),
								path = sub_contents[i].path
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
	local gbi = ni.backend.GetFunction("GetBuildInfo")
	local _, err =
		ni.backend.ParseFile(
		entry.path,
		function(content)
			local version = string.match(content, "--Version:%s*(%d[,.%d]*)")
			if not version or version == select(4, gbi()) then
				local result, err = ni.backend.LoadString(content, string.format("@%s", entry.filename))
				if result then
					result(ni)
					return true
				end
				ni.backend.MessageBox(err, entry.filename, 0x10)
				return false
			end
		end
	)
end
-- Need to create method for loading everying up now
do
	local cf = ni.backend.GetFunction("CreateFrame")
	if not cf then
		ni.backend.Error("Unable to get CreateFrame")
	end
	ni.frames = {}
	local frame = cf("frame")
	frame:SetScript(
		"OnUpdate",
		function(self, elapsed)
		end
	)
	frame:RegisterAllEvents()
	frame:SetScript(
		"OnEvent",
		function(self, event, ...)
		end
	)
	ni.backend.ProtectFrame(frame)
	ni.frames.main = frame
	if not ni.loaded then
		local dir = ni.backend.GetBaseFolder()
		local json, jerr = ni.backend.LoadFile(dir .. "addon\\core\\json.lua")
		if jerr then
			ni.backend.Error(jerr)
		else
			json = json(ni)
		end
		local unitname = ni.backend.GetFunction("UnitName")
		local vars, verr = ni.backend.LoadFile(dir .. "addon\\core\\vars.lua")
		if verr then
			ni.backend.Error(verr)
		else
			ni.vars = vars(ni)
		end
		local vars = ni.backend.GetContent(dir .. "addon\\settings\\" .. unitname("player") .. ".json")
		ni.vars = (vars and json.decode(vars)) or ni.vars
		ni.vars.profiles.enabled = false
		ni.vars.profiles.genericenabled = false
		ni.vars.profiles.delay = 0
		local build = ni.backend.GetFunction("GetBuildInfo")
		ni.vars.build = select(4, build())
		ni.backend.SaveContent(dir .. "addon\\settings\\" .. unitname("player") .. ".json", json.encode(ni.vars))
		local debug, derr = ni.backend.LoadFile(dir .. "addon\\core\\debug.lua")
		if derr then
			ni.backend.Error(derr)
		else
			ni.debug = debug(ni)
		end
		local memory, merr = ni.backend.LoadFile(dir .. "addon\\core\\memory.lua")
		if merr then
			ni.backend.Error(merr)
		else
			ni.memory = memory(ni)
		end
		local rotation, rerr = ni.backend.LoadFile(dir .. "addon\\core\\rotation.lua")
		if rerr then
			ni.backend.Error(rerr)
		else
			ni.rotation = rotation(ni)
		end
		local bootstrap, berr = ni.backend.LoadFile(dir .. "addon\\core\\bootstrap.lua")
		if berr then
			ni.backend.Error(berr)
		else
			ni.bootstrap = bootstrap(ni)
		end
		local tables, terr = ni.backend.LoadFile(dir .. "addon\\core\\tables.lua")
		if terr then
			ni.backend.Error(terr)
		else
			ni.tables = tables(ni)
		end
		local drtracker, drerr = ni.backend.LoadFile(dir .. "addon\\core\\drtracker.lua")
		if drerr then
			ni.backend.Error(drerr)
		else
			ni.drtracker = drtracker(ni)
		end
		local utils, uerr = ni.backend.LoadFile(dir .. "addon\\core\\utils.lua")
		if uerr then
			ni.backend.Error(uerr)
		else
			ni.utils = utils(ni)
		end
		ni.utils.json = json
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
		local frames, ferr = ni.backend.LoadFile(dir .. "addon\\core\\frames.lua")
		if ferr then
			ni.backend.Error("frames")
			ni.backend.Error(ferr)
		else
			ni.frames, ni.combatlog, ni.delayfor, ni.icdtracker, ni.events = frames(ni)
		end
		local spell, serr = ni.backend.LoadFile(dir .. "addon\\core\\spell.lua")
		if serr then
			ni.backend.Error("spell")
			ni.backend.Error(serr)
		else
			ni.spell = spell(ni)
		end
		local power, perr = ni.backend.LoadFile(dir .. "addon\\core\\power.lua")
		if perr then
			ni.backend.Error("power")
			ni.backend.Error(perr)
		else
			ni.power = power(ni)
		end
		local rune, ruerr = ni.backend.LoadFile(dir .. "addon\\core\\rune.lua")
		if ruerr then
			ni.backend.Error("rune")
			ni.backend.Error(ruerr)
		else
			ni.rune = rune(ni)
		end
		local unit, unerr = ni.backend.LoadFile(dir .. "addon\\core\\unit.lua")
		if unerr then
			ni.backend.Error("unit")
			ni.backend.Error(unerr)
		else
			ni.unit = unit(ni)
		end
		local player, plerr = ni.backend.LoadFile(dir .. "addon\\core\\player.lua")
		if plerr then
			ni.backend.Error("player")
			ni.backend.Error(plerr)
		else
			ni.player = player(ni)
		end
		local healing, herr = ni.backend.LoadFile(dir .. "addon\\core\\healing.lua")
		if herr then
			ni.backend.Error("healing")
			ni.backend.Error(herr)
		else
			ni.healing = healing(ni)
		end
		local members, meerr = ni.backend.LoadFile(dir .. "addon\\core\\members.lua")
		if meerr then
			ni.backend.Error("members")
			ni.backend.Error(meerr)
		else
			ni.members = members(ni)
		end
		local objectmanager, objerr = ni.backend.LoadFile(dir .. "addon\\core\\objectmanager.lua")
		if objerr then
			ni.backend.Error("objectmanager")
			ni.backend.Error(objerr)
		else
			ni.objects, ni.objectmanager = objectmanager(ni)
		end
		local stopcastingtracker, scerr = ni.backend.LoadFile(dir .. "addon\\core\\stopcastingtracker.lua")
		if scerr then
			ni.backend.Error("stopcastingtracker")
			ni.backend.Error(scerr)
		else
			ni.stopcastingtracker = stopcastingtracker(ni)
		end
		local ttd, ttderr = ni.backend.LoadFile(dir .. "addon\\core\\timetodie.lua")
		if ttderr then
			ni.backend.Error("timetodie")
			ni.backend.Error(ttderr)
		else
			ni.ttd = ttd(ni)
		end
		local GUI, guierr = ni.backend.LoadFile(dir .. "addon\\core\\gui.lua")
		if guierr then
			ni.backend.Error("gui")
			ni.backend.Error(guierr)
		else
			ni.GUI = GUI(ni)
		end
		local strongrand, mwcerr = ni.backend.LoadFile(dir .. "addon\\core\\mwcrand.lua")
		if mwcerr then
			ni.backend.Error("mwcrand")
			ni.backend.Error(mwcerr)
		else
			ni.strongrand = strongrand(ni)
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
			local name = RandomVariable(20)
			while tContains(generated_names, name) do
				name = RandomVariable(20)
			end
			table.insert(generated_names, name)
			return name
		end
		local main, mainerr = ni.backend.LoadFile(dir .. "addon\\core\\mainui.lua")
		if mainerr then
			ni.backend.Error("mainerr")
			ni.backend.Error(mainerr)
		else
			ni.main = main(ni)
		end

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
		ni.loaded = true
	end
end
