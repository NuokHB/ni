ni = ni or { 
    -- secureload = %%SecureLoad%%,
	functions = {
		moveto = %%MoveTo%%,
		clickat = %%ClickAt%%,
		registercallback = %%RegisterCallback%%,
		auras = %%Auras%%,
		require = %%Require%%,
		getmapid = %%GetMapID%%,
		bestloc = %%BestLoc%%,
		combatreach = %%CombatReach%%,
		objectexists = %%ObjectExists%%,
		getom = %%GetOM%%,
		interact = %%Interact%%,
		item = %%Item%%,
		inventoryitem = %%InventoryItem%%,
		objectinfo = %%ObjectInfo%%,
		isfacing = %%IsFacing%%,
		isbehind = %%IsBehind%%,
		hasaura = %%HasAura%%,
		runtext = %%RunText%%,
		getdistance = %%GetDistance%%,
		lookat = %%LookAt%%,
		unitcreator = %%UnitCreator%%,
		settarget = %%SetTarget%%,
		stopmoving = %%StopMoving%%,
		unitdynamicflags = %%UnitDynamicFlags%%,
		unitflags = %%UnitFlags%%,
		creaturetype = %%CreatureType%%,
		cast = %%Cast%%,
		getspellid = %%GetSpellID%%,
		stopcasting = %%StopCasting%%,
		los = %%LoS%%,
		objectpointer = %%ObjectPointer%%,
		baseaddress = %%BaseAddress%%,
		objecttransport = %%ObjectTransport%%,
		objectfacing = %%ObjectFacing%%,
		resetlasthardwareaction = %%ResetLastHardwareAction%%,
		callprotected = %%CallProtected%%,
		webrequest = %%WebRequest%%,
		getrandomnamefor = %%GetRandomNameFor%%,
		loadcontent = %%LoadContent%%,
		savecontent = %%SaveContent%%,
		getbasefolder = %%GetBaseFolder%%,
		getprofilesfor = %%GetProfilesFor%%,
		getpath = %%GetPath%%,
		freemaps = %%FreeMaps%%,
		getdescriptor = %%GetDescriptor%%,
		setcreaturetracking = %%SetCreatureTracking%%,
		setresourcetracking = %%SetResourceTracking%%,
		readdistance = %%WebRequest%%,
		open = %%Open%%,
		read = %%Read%%,
		toggleconsole = %%ToggleConsole%%,
	}
}

local function addProtectedFunctions(randomFunc)
	--[[ 
	This is the section for making your own protected functions in game...

	The idea is to have it prepended from the name. If I made them all <Function>Safe then servers could look for that. The idea is to update the word you want from the variable 'prepend' to whatever you want. In this example the prepend is 'Safe' so, using CastSpellByName would be CastSpellByNameSafe. PLEASE CHANGE THE WORD TO YOUR OWN
	
	The functions table needs to be populated with each of the functions you want. I.E.:
	local functions = { "CastSpellByName", "CastSpellByID", "JumpOrAscendStart" }
	]]--

	local append = "SAFE"; -- Change to any word / symbols. Измените на любые слова / символы; ;
	if append == "SAFE" then append = randomFunc(20) end
	-- Add the functions you want to use here
	local functions = { "MoveForwardStop", "MoveForwardStart", "PetPassiveMode", "ToggleSpellAutocast", "TargetNearestEnemy",
	"StrafeLeftStart", "StrafeRightStart", "AttackTarget", "AssistUnit", "CancelShapeshiftForm", "CastShapeshiftForm",
	"CastSpell", "CastSpellByName", "ClearTarget", "PetAttack", "TargetNearestFriend", "TargetNearestEnemy", 
	"TargetLastTarget", "TargetLastEnemy", "SpellStopCasting", "SpellStopTargeting", "CastSpellByID",
	}
	-- End section to add to
	if #functions > 0 then
		for k, v in pairs(functions) do
			_G[v..append] = function(...)
				return ni.functions.callprotected(v, ...)
			end
		end
	end
end

if not ni.loaded then
	local frame = CreateFrame("frame")
	frame:SetScript("OnUpdate",function(self)
		local func = IsLinuxClient()
		if func then
			ni.castdest = func
			self:Hide()
		end
	end)
	local loaded_files = { };
	local function pack(...)
		local n = select('#', ...)
		return setmetatable({...}, {
			__len = function() return n end,
		})
	end
	local function require(name)
		if not name:find(".lua") and not name:find(".enc") then
			name = name..".lua"
		end
		if not loaded_files[name] then
			loaded_files[name] = pack(ni.functions.require(name));
		end
		return unpack(loaded_files[name]);
	end
	local dir = ni.functions.getbasefolder();
	local json = require(dir.."addon\\core\\json.lua");
	local vars = ni.functions.loadcontent(dir.."addon\\settings\\"..UnitName("player")..".json");
	ni.vars = vars and json.decode(vars) or require(dir.."addon\\core\\vars.lua");
	ni.vars.profiles.enabled = false;
	ni.vars.profiles.genericenabled = false;
	ni.vars.profiles.delay = 0;
	ni.functions.savecontent(dir.."addon\\settings\\"..UnitName("player")..".json", json.encode(ni.vars));
	ni.vars.build = select(4, GetBuildInfo());
	ni.debug = require(dir.."addon\\core\\debug.lua");
	ni.memory = require(dir.."addon\\core\\memory.lua");
	ni.rotation = require(dir.."addon\\core\\rotation.lua");
	ni.bootstrap = require(dir.."addon\\core\\bootstrap.lua");
	ni.tables = require(dir.."addon\\core\\tables.lua");
	ni.drtracker = require(dir.."addon\\core\\drtracker.lua");
	ni.utils = require(dir.."addon\\core\\utils.lua");
	ni.utils.require = require;
	ni.utils.json = json;
	ni.utils.savesetting = function(filename, settings)
		if type(settings) == "table" then
			settings = json.encode(settings);
		end
		ni.functions.savecontent(dir.."addon\\Settings\\"..filename, settings);
	end;
	ni.utils.getsettings = function(filename)
		local content = ni.functions.loadcontent(dir.."addon\\Settings\\"..filename);
		return content and json.decode(content) or { };
	end;

	ni.frames, ni.combatlog, ni.delayfor, ni.icdtracker, ni.events = require(dir.."addon\\core\\frames.lua");
	ni.spell = require(dir.."addon\\core\\spell.lua");
	ni.power = require(dir.."addon\\core\\power.lua");
	ni.rune = require(dir.."addon\\core\\rune.lua");
	ni.unit = require(dir.."addon\\core\\unit.lua");
	ni.player = require(dir.."addon\\core\\player.lua");
	ni.healing, ni.tanks = require(dir.."addon\\core\\healing.lua");
	ni.members = require(dir.."addon\\core\\members.lua");
	ni.objects, ni.objectmanager = require(dir.."addon\\core\\objectmanager.lua");
	ni.stopcastingtracker = require(dir.."addon\\core\\stopcastingtracker.lua");
	ni.ttd = require(dir.."addon\\core\\timetodie.lua");
	ni.GUI = require(dir.."addon\\core\\gui.lua");
	local strongrand = require(dir.."addon\\core\\mwcrand.lua");
	ni.strongrand = strongrand

	local function RandomVariable(length)
                local res = ""
                for i = 1, length do
                        res = res .. string.char(strongrand.generate(97, 122))
                end
                return res
    	end

	local generated_names = { };

	ni.utils.GenerateRandomName = function()
		local name = RandomVariable(20);
		while tContains(generated_names, name) do
			name = RandomVariable(20);
		end
		table.insert(generated_names, name);
		return name;
	end

	ni.main = require(dir.."addon\\core\\mainui.lua");

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
		return %%ToggleConsole%% ~= nil;
	end
	ni.frames.main:SetScript("OnUpdate", ni.frames.OnUpdate);
	ni.frames.main:SetScript("OnEvent", ni.frames.OnEvent);

	addProtectedFunctions(RandomVariable)

	if ni.vars["global"] then
		_G[ni.vars["global"]] = ni;
	end
	ni.loaded = true
end
