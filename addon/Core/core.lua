local ni = ...

-- Prevent double loading (Shouldn't happen, but just to be safe)
if not ni.loaded then
   local base_path = ni.backend.GetBaseFolder()
   local core_path = base_path.."addon\\core\\"

   -- Load the utilities table for use
   do
      local func, err = ni.backend.LoadFile(core_path.."utilities.lua", "utilities.lua")
      if func then
         func(ni)
      else
         ni.backend.Error(err)
      end
   end

   -- As long as the files isn't inserted/removed it'll stay in this order
   local core_files = {
      "input.lua",
      "client.lua",
      "world.lua",
      "navigation.lua",
      "object.lua",
      "unit.lua",
      "player.lua"
   }

   -- Load each of the above files here
   for _, file in pairs(core_files) do
      local _, error = ni.utilities.load_file(core_path..file, file)
      if error then
         ni.backend.Error(error)
      end
   end

   -- TODO: continue loading files
   test = ni
   ni.loaded = true
end