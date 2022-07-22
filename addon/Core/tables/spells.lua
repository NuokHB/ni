local ni = ...
ni.spells = {}

local UnitClass = ni.client.get_function("UnitClass")
local class, _ = UnitClass("player")

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
end

-- local spells_to_load = {
   
-- }

-- for spell_name, _ in ni.table.pairs(spells_to_load) do
--    local spell_id = ni.backend.GetSpellID(spell_name)
--    if ni.spell.known(spell_id) then
--       spell_name = string.lower(spell_name)
--       spell_name = spell_name:gsub(" ", "_")
--       spell_name = spell_name:gsub("-", "_")
--       ni.spells[spell_name] = spell_id
--    end
-- end