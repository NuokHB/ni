local ni, tab = ...

local build = ni.client.build()
local GetNumSpellTabs = ni.client.get_function("GetNumSpellTabs")
if not GetNumSpellTabs then
   ni.backend.Error("Unable to get GetNumSpellTabs")
end
local GetSpellTabInfo = ni.client.get_function("GetSpellTabInfo")
if not GetSpellTabInfo then
   ni.backend.Error("Unable to get GetSpellTabInfo")
end
local GetSpellBookItemInfo = ni.client.get_function("GetSpellBookItemInfo")
if not GetSpellBookItemInfo and build > 12340 then
   ni.backend.Error("Unable to get GetSpellBookItemInfo")
end
local GetFlyoutInfo = ni.client.get_function("GetFlyoutInfo")
--local GetFlyoutSlotInfo = ni.client.get_function("GetFlyoutSlotInfo")

local GetSpellName = ni.client.get_function("GetSpellName")
if not GetSpellName and build == 12340 then
   ni.backend.Error("Unable to get GetSpellName")
end
local GetGlyphSocketInfo = ni.client.get_function("GetGlyphSocketInfo")
local GetNumGlyphSockets = ni.client.get_function("GetNumGlyphSockets")

local dump_ni = ni.ui.button(tab)
dump_ni.Text = "Ni Dump"
dump_ni.Callback = function()
   local string_dump = "Ni\n"
   local buffs = ni
   for index, value in ni.table.pairs(buffs) do
      local b = "["..index.."] "
      for i, v in ni.table.pairs(value) do
         b = b .. tostring(v).. ", "
         if type(v) == "table" then
            b = b .. "\n --Table: "
            for i2, v2 in ni.table.pairs(v) do
               b = b .. tostring(v2).. ", "
            end
         end
      end
      b = b.."\n"
      string_dump = string_dump..b
   end
   ni.utilities.log(string_dump)
end

ni.ui.separator(tab)

local object_button = ni.ui.button(tab)
object_button.Text = "Dump All"
object_button.Callback = function()
   ni.objects.update()
   local string_dump = "Objects Dump\n"
   for k, v in ni.table.opairs(ni.objects) do
      string_dump = string_dump .. string.format("[%s] type = %s, guid = %s, name = %s\n", k, v.type, v.guid, v.name)
   end
   ni.utilities.log(string_dump)
end

local enemies_button = ni.ui.button(tab)
enemies_button.Text = "Dump Enemies Player 100"
enemies_button.Callback = function()
   ni.objects.update()
   local enemies = ni.unit.enemies_in_range("player", 100)
   local string_dump = "Enemies Dump\n"
   string_dump = string_dump .. string.format("Found %s targets \n", ni.table.length(enemies))
   for k, v in ni.table.opairs(enemies) do
      string_dump =
         string_dump ..
         string.format("[%s] type = %s, guid = %s, name = %s, distance = %s\n", k, v.type, v.guid, v.name, v.distance)
   end
   ni.utilities.log(string_dump)
end

local enemies_button_target = ni.ui.button(tab)
enemies_button_target.Text = "Dump Enemies Target 20"
enemies_button_target.Callback = function()
   ni.objects.update()
   local enemies = ni.unit.enemies_in_range("target", 20)
   local string_dump = "Enemies Dump Target\n"
   string_dump = string_dump .. string.format("Found %s targets \n", ni.table.length(enemies))
   for k, v in ni.table.opairs(enemies) do
      string_dump =
         string_dump ..
         string.format("[%s] type = %s, guid = %s, name = %s, distance = %s\n", k, v.type, v.guid, v.name, v.distance)
   end
   ni.utilities.log(string_dump)
end

local friends_button = ni.ui.button(tab)
friends_button.Text = "Dump Friends"
friends_button.Callback = function()
   ni.objects.update()
   local friends = ni.unit.friends_in_range("player", 100)
   local string_dump = "Friends Dump\n"
   for k, v in ni.table.opairs(friends) do
      string_dump =
         string_dump ..
         string.format("[%s] type = %s, guid = %s, name = %s, distance = %s\n", k, v.type, v.guid, v.name, v.distance)
   end
   ni.utilities.log(string_dump)
end

local party_button = ni.ui.button(tab)
party_button.Text = "Dump Party Members"
party_button.Callback = function()
   ni.members.update()
   local party = ni.members
   local string_dump = "Party Dump\n"
   for k, v in ni.table.opairs(party) do
      string_dump =
         string_dump ..
         string.format(
            "[%s] %s, unit_id = %s, health_percent = %s\n",
            k,
            v.name(),
            v.unit_id,
            v.health_percent())
   end
   ni.utilities.log(string_dump)
end

local pet_button = ni.ui.button(tab)
pet_button.Text = "Dump Pet"
pet_button.Callback = function()
   ni.objects.update()
   local has_pet = ni.pet.exists()
   local string_dump = "Pet Dump\n"
   if not has_pet then
      string_dump = string_dump.."No pet found"
   else
      string_dump = string_dump.."Pet found\n"
      for i = 1, 10 do
         local name = ni.pet.action_info(i)
         if name then
            string_dump = string_dump.."  ["..i.."] "..name.."\n"
         end
      end
   end
   ni.utilities.log(string_dump)
end

ni.ui.separator(tab)

local unit_flags = ni.ui.button(tab)
unit_flags.Text = "UnitFlags Player"
unit_flags.Callback = function()
   local string_dump = "UnitFlags Player\n"
   for i = 1, 32 do
      local flag = ni.backend.UnitFlags("player")
      string_dump = string_dump .. string.format("Flag %s: %s\n", i, tostring(flag))
   end
   ni.utilities.log(string_dump)
end

local unit_flags_target = ni.ui.button(tab)
unit_flags_target.Text = "UnitFlags Target"
unit_flags_target.Callback = function()
   local string_dump = "UnitFlags Target\n"
   for i = 1, 32 do
      local flag = ni.backend.UnitFlags("target")
      string_dump = string_dump .. string.format("Flag %s: %s\n", i, tostring(flag))
   end
   ni.utilities.log(string_dump)
end

local playerDynamicFlags = ni.ui.button(tab)
playerDynamicFlags.Text = "UnitDynamicFlags Player"
playerDynamicFlags.Callback = function()
   local string_dump = "UnitDynamicFlags Player\n"
   for i = 1, 9 do
      local flag = ni.backend.UnitDynamicFlags("player")
      string_dump = string_dump .. string.format("Flag %s: %s\n", i, tostring(flag))
   end
   ni.utilities.log(string_dump)
end

local UnitDynamicFlags = ni.ui.button(tab)
UnitDynamicFlags.Text = "UnitDynamicFlags Target"
UnitDynamicFlags.Callback = function()
   local string_dump = "UnitDynamicFlags Target\n"
   for i = 1, 9 do
      local flag = ni.backend.UnitDynamicFlags("Target")
      string_dump = string_dump .. string.format("Flag %s: %s\n", i, tostring(flag))
   end
   ni.utilities.log(string_dump)
end

ni.ui.separator(tab)

local player_auras = ni.ui.button(tab)
player_auras.Text = "Player Buffs"
player_auras.Callback = function()
   local string_dump = "Player Buffs\n"
   local buffs = ni.player.buffs()
   for index, value in ni.table.pairs(buffs) do
      local b = "["..index.."] "
      for i, v in ni.table.pairs(value) do
         b = b .."["..i.."]".. tostring(v).. ", "
      end
      b = b.."\n"
      string_dump = string_dump..b
   end
   ni.utilities.log(string_dump)
end

local player_auras = ni.ui.button(tab)
player_auras.Text = "Player DeBuffs"
player_auras.Callback = function()
   local string_dump = "Player DeBuffs\n"
   local buffs = ni.player.debuffs()
   for index, value in ni.table.pairs(buffs) do
      local b = "["..index.."] "
      for i, v in ni.table.pairs(value) do
         b = b .."["..i.."]".. tostring(v).. ", "
      end
      b = b.."\n"
      string_dump = string_dump..b
   end
   ni.utilities.log(string_dump)
end

local player_auras = ni.ui.button(tab)
player_auras.Text = "Target Buffs"
player_auras.Callback = function()
   local string_dump = "Target Buffs\n"
   local buffs = ni.unit.buffs("target")
   for index, value in ni.table.pairs(buffs) do
      local b = "["..index.."] "
      for i, v in ni.table.pairs(value) do
         b = b .."["..i.."]".. tostring(v).. ", "
      end
      b = b.."\n"
      string_dump = string_dump..b
   end
   ni.utilities.log(string_dump)
end

local player_auras = ni.ui.button(tab)
player_auras.Text = "Target DeBuffs"
player_auras.Callback = function()
   local string_dump = "Target DeBuffs\n"
   local buffs = ni.unit.debuffs("target")
   for index, value in ni.table.pairs(buffs) do
      local b = "["..index.."] "
      for i, v in ni.table.pairs(value) do
         b = b .."["..i.."]".. tostring(v).. ", "
      end
      b = b.."\n"
      string_dump = string_dump..b
   end
   ni.utilities.log(string_dump)
end

ni.ui.separator(tab)

local function stripname(name)
   name = string.gsub(name, "%s+", "")
   name = string.gsub(name, "'", "")
   name = string.gsub(name, "-", "")
   name = string.gsub(name, ":", "")
   name = string.gsub(name, ",", "")
   return name
end

local spell_button = ni.ui.button(tab)
spell_button.Text = "Dump Spell Book"
spell_button.Callback = function()
   ni.utilities.log("Spells Dump")
   local spell_string = "--Version: " .. build .. "\n"
   local pet_string = "--Pet\n"
   local tabs = GetNumSpellTabs()
   for i = 1, tabs do
      local tabname,
         _,
         offset,
         numSpells,
         _,
         offspecID = GetSpellTabInfo(i)
      spell_string = spell_string .. string.format("--%s\n", tabname)
      local tabEnd = offset + numSpells
      local dumped_names = {}
      for j = offset + 1, tabEnd do
         if build == 12340 then
            local spellName, rank = GetSpellName(j, BOOKTYPE_SPELL) --/dump GetSpellName(10, BOOKTYPE_SPELL)
            local spellNamePet, rankPet = GetSpellName(j, BOOKTYPE_PET)
            if spellName and not dumped_names[spellName] then
               local spellId = ni.spell.id(spellName)
               if not spellId then
                  spell_string = spell_string .. string.format("  --Failed to get id for %s (%s)\n", spellName, rank)
               end
               spell_string = spell_string .. string.format("  %s = {id = %s, name = ni.spell.info(%s)},\n",
                     stripname(spellName),
                     spellId,
                     spellId,
                     spellId
                  )
                  dumped_names[spellName] = spellId
            end
            if spellNamePet and not dumped_names[spellNamePet] then
               local spellId = ni.spell.id(spellNamePet)
               if not spellId then
                  pet_string = pet_string .. string.format("  --Failed to get id for %s (%s)\n", spellNamePet, rankPet)
               end
               pet_string = pet_string .. string.format("  %s = {id = %s, name = ni.spell.info(%s)},\n",
                     stripname(spellNamePet),
                     spellId,
                     spellId,
                     spellId
                  )
                  dumped_names[spellNamePet] = spellId
            end
         elseif build > 12340 then
            if offspecID == nil or offspecID == 0 then
               local type,
                  id = GetSpellBookItemInfo(j, "player")
               if type == "FLYOUT" then
                  local _,
                     _,
                     numSlots = GetFlyoutInfo(id)
                  for o = 1, numSlots do
                     local flyoutID = GetFlyoutSlotInfo(id, o)
                     local flyoutname = ni.spell.info(flyoutID)
                     spell_string =
                        spell_string ..
                        string.format(
                           "  %s = {id = %s, name = ni.spell.info(%s)},\n",
                           stripname(flyoutname),
                           flyoutID,
                           flyoutID,
                           flyoutID
                        )
                  end
               end
               if (type == "SPELL" or type == "FUTURESPELL") then
                  local spellname,
                     rank = ni.spell.info(id)
                  if not string.match(rank, "Guild") then
                     if (string.match(rank, "Cat")) then
                        spellname = spellname .. "Cat"
                     end
                     if (string.match(rank, "Bear")) then
                        spellname = spellname .. "Bear"
                     end
                     spell_string =
                        spell_string ..
                        string.format("  %s = {id = %s, name = ni.spell.info(%s)},\n", stripname(spellname), id, id, id)
                  end
               end
            end
         end
      end
   end
   if string.len(pet_string) > 6 then
      spell_string = spell_string ..pet_string
   end
   ni.utilities.log(spell_string)

end

local glyph_button = ni.ui.button(tab)
glyph_button.Text = "Dump Glyphs"
glyph_button.Callback = function ()
   local glyph_string = "--Glyphs Dump\n"
   for slot = 1, GetNumGlyphSockets() do
      local enabled, glyph_type, glyph_id
      if build >= 15595 then
         enabled, _, _, glyph_id = GetGlyphSocketInfo(slot)
      else
         enabled, _, glyph_id = GetGlyphSocketInfo(slot)
      end
      if glyph_id and glyph_id ~= 0 then
         local name = ni.spell.info(glyph_id)
         glyph_string = glyph_string .. string.format("local %s = ni.player.has_glyph(%s) \n", stripname(name), glyph_id)
      end
   end
   ni.utilities.log(glyph_string)
end
