local ni = ...;
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
--[[
	Description: Parses and loads the table entry provided
	Arguments:
		entry - [table, required] Entry from the GetProfiles function (keys of: title, filename, path)
	Returns:
		none/nil
]]
local function LoadProfile(entry)
	local gbi = ni.backend.GetFunction("GetBuildInfo")
	local _, err = ni.backend.ParseFile(entry.path, function(content)
		print("Parsing "..entry.title)
		local version = string.match(content, "--Version:%s*(%d[,.%d]*)")
		if not version or version == select(4,gbi()) then
			local result, err = ni.backend.LoadString(content, string.format("@%s", entry.filename))
			if result then
				result(ni)
				return true
			end
			ni.backend.MessageBox(err, entry.title, 0x10)
			return false
		end
	end)
end
-- Need to create method for loading everying up now
do
	local cf = ni.backend.GetFunction("CreateFrame")
	if not cf then
		ni.backend.Error("Unable to get CreateFrame")
	end
	ni.frames = {}
	local frame = cf("frame")
	frame:SetScript("OnUpdate", function(self, elapsed)
	
	end)
	frame:RegisterAllEvents()
	frame:SetScript("OnEvent", function(self, event, ...)
	
	end)
	ni.backend.ProtectFrame(frame)
	ni.frames.main = frame
end