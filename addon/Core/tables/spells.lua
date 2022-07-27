local ni = ...
ni.spells = {}

local UnitClass = ni.client.get_function("UnitClass")
local class, _ = UnitClass("player")

local function register_spells(event)

   if not event == "PLAYER_ENTERING_WORLD" then
      return
   end

   -- COMMON
   ni.spells.common = {}
   ni.spells.auto_attack = ni.backend.GetSpellID("Auto Attack")
   ni.spells.auto_shot = ni.backend.GetSpellID("Auto Shot")
   ni.spells.skinning = ni.backend.GetSpellID("Skinning")
   ni.spells.enchanting = ni.backend.GetSpellID("Enchanting")

   if class == "Hunter" then
      ni.spells.arcane_shot = ni.backend.GetSpellID("Arcane Shot")
      ni.spells.aspect_of_the_dragonhawk = ni.backend.GetSpellID("Aspect of the Dragonhawk")
      ni.spells.aspect_of_the_hawk = ni.backend.GetSpellID("Aspect of the Hawk")
      ni.spells.aspect_of_the_monkey = ni.backend.GetSpellID("Aspect of the Monkey")
      ni.spells.aspect_of_the_viper = ni.backend.GetSpellID("Aspect of the Viper")
      ni.spells.explosive_trap = ni.backend.GetSpellID("Explosive Trap")
      ni.spells.feed_pet = ni.backend.GetSpellID("Feed Pet")
      ni.spells.hunters_mark = ni.backend.GetSpellID("Hunters Mark")
      ni.spells.mend_pet = ni.backend.GetSpellID("Mend Pet")
      ni.spells.mongoose_bite = ni.backend.GetSpellID("Mongoose Bite")
      ni.spells.multishot = ni.backend.GetSpellID("Multi-Shot")
      ni.spells.raptor_strike = ni.backend.GetSpellID("Raptor Strike")
      ni.spells.serpent_sting = ni.backend.GetSpellID("Serpent Sting")
      ni.spells.misdirection = ni.backend.GetSpellID("Misdirection")
      ni.spells.kill_command = ni.backend.GetSpellID("Kill Command")
      ni.spells.chimera_shot = ni.backend.GetSpellID("Chimera Shot")
      ni.spells.silencing_shot = ni.backend.GetSpellID("Silencing Shot")
      ni.spells.kill_shot = ni.backend.GetSpellID("Kill Shot")
      ni.spells.aimed_shot = ni.backend.GetSpellID("Aimed Shot")
      ni.spells.steady_shot = ni.backend.GetSpellID("Steady Shot")
      ni.spells.bestial_wrath = ni.backend.GetSpellID("Bestial Wrath")
      ni.spells.volley = ni.backend.GetSpellID("Volley")
   end
end

ni.events.register_callback("Spells", register_spells)