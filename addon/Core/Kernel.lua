ni = {}
ni.frames = {}
ni.vars = {}
ni.utils = {}
ni.rotation = {}
ni.combat = {}
ni.tables = {}
ni.delays = {}
ni.debug = {}
ni.ui = {}
ni.unit = {}
ni.player = {}
ni.rune = {}
ni.spell = {}
ni.power = {}
ni.objectmanager = {}
ni.objects = {}
ni.members = {}
ni.healing = {}
ni.tanks = {}
ni.stopcastingtracker = {}
ni.data = {}
ni.functions = { };
local funcs = {
	["addlog"] = %%AddLog%%,
	["popup"] = %%PopUp%%,
	["loadlua"] = %%LoadFile%%,
	["test"] = %%Test%%,
	["objectexists"] = %%ObjectExists%%,
	["los"] = %%LoS%%,
	["unitcreator"] = %%UnitCreator%%,
	["creaturetype"] = %%CreatureType%%,
	["combatreach"] = %%CombatReach%%,
	["unitflags"] = %%UnitFlags%%,
	["cast"] = %%Cast%%,
	["getobjects"] = %%GetOM%%,
}
function ni.functions.addlog(...)
	local f = %%AddLog%%
	if type(f) == "function" then
		return f(...);
	end
end
function ni.functions.popup(...)
	local f = %%PopUp%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.loadlua(...)
	local f = %%LoadFile%%
	if type(f) == "function" then
		return f(...);
	end
end
function ni.functions.test(...)
	local f = %%Test%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.objectexists(...)
	local f = %%ObjectExists%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.los(...)
	local f = %%LoS%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.unitcreator(...)
	local f = %%UnitCreator%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.creaturetype(...)
	local f = %%CreatureType%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.combatreach(...)
	local f = %%CombatReach%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.unitflags(...)
	local f = %%UnitFlags%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.unitdynamicflags(...)
	local f = %%UnitDynamicFlags%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.objectinfo(...)
	local f = %%ObjectInfo%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.isfacing(...)
	local f = %%IsFacing%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.getdistance(...)
	local f = %%GetDistance%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.isbehind(...)
	local f = %%IsBehind%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.aura(...)
	local f = %%HasAura%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.moveto(...)
	local f = %%MoveTo%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.clickat(...)
	local f = %%ClickAt%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.stopmoving(...)
	local f = %%StopMoving%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.lookat(...)
	local f = %%LookAt%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.settarget(...)
	local f = %%SetTarget%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.runtext(...)
	local f = %%RunText%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.item(...)
	local f = %%Item%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.inventoryitem(...)
	local f = %%InventoryItem%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.interact(...)
	local f = %%Interact%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.cast(...)
	local f = %%Cast%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.getspellid(...)
	local f = %%GetSpellID%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.stopcasting(...)
	local f = %%StopCasting%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.getobjects(...)
	local f = %%GetOM%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.keypressed(...)
	local f = %%KeyPressed%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.objectpointer(...)
	local f = %%ObjectPointer%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.read(...)
	local f = %%Read%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.baseaddress(...)
	local f = %%BaseAddress%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.transport(...)
	local f = %%Transport%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.vtables(...)
	local f = %%vtables%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.facing(...)
	local f = %%Facing%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.getsetting(...)
	local f = %%GetSetting%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.savesetting(...)
	local f = %%SaveSetting%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.fileexists(...)
	local f = %%FileExists%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.resetlasthardwareaction(...)
	local f = %%ResetLastHardwareAction%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.auras(...)
	local f = %%Auras%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.safeexec(...)
	local f = %%SafeExec%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.safeget(...)
	local f = %%SafeGet%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.bestaoeloc(...)
	local f = %%BestAoELoc%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.getpath(...)
	local f = %%GetPath%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.require(...)
	local f = %%Require%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.getmapid(...)
	local f = %%GetMapID%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.freemaps(...)
	local f = %%FreeMaps%%
	if type(f) == "function" then
		return f(...)
	end
end
function ni.functions.getfunction(func)
	for k, v in pairs(funcs) do
		if func == k then
			return type(v)
		end
	end
	return "nil"
end