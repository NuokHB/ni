local queue = {
	"Pause",
	"AspectoftheHawk",
	"HuntersMark",
	"SerpentSting",
	"ConcussiveShot",
	"ArcaneShot",
	"RaptorStrike",
	"AutoAttack",
}
local enables = {
	["ConcussiveShot"] = false,
}
local values = {
}
local inputs = {
}
local menus = {
}
local function GUICallback(key, item_type, value)
	if item_type == "enabled" then
		enables[key] = value;
	elseif item_type == "value" then
		values[key] = value;
	elseif item_type == "input" then
		inputs[key] = value;
	elseif item_type == "menu" then
		menus[key] = value;
	end
end
local items = {
	settingsfile = "BM_WotLK.xml",
	callback = GUICallback,
	{ type = "title", text = "BM WotLK" },
	{ type = "separator" },
	{
		type = "entry",
		text = "Concussive Shot",
		tooltip = "Use Concussive Shot",
		enabled = enables["ConcussiveShot"],
		key = "ConcussiveShot"
	},
};
local incombat = false;
local function CombatEventCatcher(event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		incombat = true;
	elseif event == "PLAYER_REGEN_ENABLED" then
		incombat = false;
	end
end
local function OnLoad()
	ni.combatlog.registerhandler("Prot-Cata", CombatEventCatcher);
	ni.GUI.AddFrame("Prot-Cata", items);
end
local function OnUnload()
	ni.combatlog.unregisterhandler("Prot-Cata");
	ni.GUI.DestroyFrame("Prot-Cata");
end

local spells = {
--Beast Mastery
AspectoftheHawkRank1 = {id = 13165, name = GetSpellInfo(13165)},
AspectoftheMonkey = {id = 13163, name = GetSpellInfo(13163)},
CallPet = {id = 883, name = GetSpellInfo(883)},
DismissPet = {id = 2641, name = GetSpellInfo(2641)},
FeedPet = {id = 6991, name = GetSpellInfo(6991)},
RevivePet = {id = 982, name = GetSpellInfo(982)},
TameBeast = {id = 1515, name = GetSpellInfo(1515)},
--Marksmanship
ArcaneShotRank1 = {id = 3044, name = GetSpellInfo(3044)},
AutoShot = {id = 75, name = GetSpellInfo(75)},
ConcussiveShot = {id = 5116, name = GetSpellInfo(5116)},
HuntersMarkRank1 = {id = 1130, name = GetSpellInfo(1130)},
SerpentStingRank1 = {id = 1978, name = GetSpellInfo(1978)},
SerpentStingRank2 = {id = 13549, name = GetSpellInfo(13549)},
--Survival
RaptorStrikeRank1 = {id = 2973, name = GetSpellInfo(2973)},
RaptorStrikeRank2 = {id = 14260, name = GetSpellInfo(14260)},
TrackBeasts = {id = 1494, name = GetSpellInfo(1494)},
TrackHumanoids = {id = 19883, name = GetSpellInfo(19883)},
--Talents
}

local enemies = {}

local function ActiveEnemies()
	table.wipe(enemies)
	enemies = ni.player.enemiesinrange(10)
	for k, v in ipairs(enemies) do
		if ni.player.threat(v.guid) == -1 then
			table.remove(enemies, k)
		end
	end
	return #enemies
end

local function FacingLosCast(spell, tar)
	if ni.player.isfacing(tar, 145) and ni.player.los(tar) and IsSpellInRange(spell, tar) == 1 then
		ni.spell.cast(spell, tar)
		ni.debug.log(string.format("Casting %s on %s", spell, tar))
		return true
	end
	return false
end

local function ValidUsable(id, tar)
	if ni.spell.available(id) and ni.spell.valid(tar, id, true, true) then
		return true
	end
	return false
end

local function InRange(tar)
	local distance = ni.unit.distance("player", tar);
	if distance > 5 and distance <= 35 then
			return true;
	end
	return false
end

local abilities = {
	["Pause"] = function()
		if IsMounted()
			or UnitIsDeadOrGhost("player")
			or not UnitExists("target")
			or UnitIsDeadOrGhost("target")
			or (UnitExists("target")
			and not UnitCanAttack("player", "target")) then
			return true
		end
	end,
	["AutoAttack"] = function()
		if not IsCurrentSpell(6603) and not IsCurrentSpell(75) then
			ni.spell.cast(75)
		end
	end,
	["RaptorStrike"] = function()
		if ValidUsable(spells.RaptorStrikeRank2.id, "target")
		and ni.unit.distance("player", "target") <= 5
		and FacingLosCast(spells.RaptorStrikeRank2.name, "target") then
				return true
		end
	end,
	["HuntersMark"] = function()
		if ValidUsable(spells.HuntersMarkRank1.id, "target")
		and ni.unit.debuffremaining("target", spells.HuntersMarkRank1.id) <= 2
		and FacingLosCast(spells.HuntersMarkRank1.name, "target") then
				return true
		end
	end,
	["SerpentSting"] = function()
		if ValidUsable(spells.SerpentStingRank1.id, "target")
		and InRange("target")
		and ni.unit.debuffremaining("target", spells.SerpentStingRank1.id, "player") <= 2
		and FacingLosCast(spells.SerpentStingRank1.name, "target") then
				return true
		end
	end,
	["ArcaneShot"] = function()
		if ValidUsable(spells.ArcaneShotRank1.id, "target")
		and InRange("target")
		and FacingLosCast(spells.ArcaneShotRank1.name, "target") then
				return true
		end
	end,
	["ConcussiveShot"]= function()
		if enables["ConcussiveShot"]
		and ValidUsable(spells.ConcussiveShot.id, "target")
		and InRange("target")
		and FacingLosCast(spells.ConcussiveShot.name, "target") then
				return true
		end
	end,
	["AspectoftheHawk"] = function()
		if ni.spell.available(spells.AspectoftheHawkRank1.id)
		and not ni.player.buff(spells.AspectoftheHawkRank1.id) then
			ni.spell.cast(spells.AspectoftheHawkRank1.name)
				return true
		end
	end,
}
ni.bootstrap.profile("BM_WotLK", queue, abilities, OnLoad, OnUnload);
