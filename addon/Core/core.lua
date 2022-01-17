local ni = ...

-- Prevent double loading (Shouldn't happen, but just to be safe)
if not ni.loaded then
   local base_path = ni.backend.GetBaseFolder()
   local core_path = base_path.."addon\\core\\"
   local initial_files = {
      "io.lua",
      "client.lua"
   }

   -- Load the utilities table for use
   for i = 1, #initial_files do
      local file = initial_files[i]
      local func, err = ni.backend.LoadFile(core_path..file, file)
      if func then
         func(ni)
      else
         ni.backend.Error(err)
      end
   end

   -- Setup the main frame for functions used later
   ni.frame = ni.client.get_function("CreateFrame")("frame", nil, UIParent)
   ni.frame:RegisterAllEvents()
   ni.backend.ProtectFrame(ni.frame, UIParent)

   -- As long as the files isn't inserted/removed it'll stay in this order
   local core_files = {
      "utilities.lua",
      "input.lua",
      "events.lua",
      "world.lua",
      "navigation.lua",
      "item.lua",
      "gear.lua",
      "object.lua",
      "power.lua",
      "unit.lua",
      "player.lua",
      "spell.lua"
   }

   -- Load each of the above files here
   for _, file in pairs(core_files) do
      local _, error = ni.io.load_file(core_path..file, file)
      if error then
         ni.backend.Error(error)
      end
   end

   ni.events.initialize()
   -- TODO: continue after loading files

   ni.loaded = true
end