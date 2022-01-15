local ni = ...

-- Prevent double loading (Shouldn't happen, but just to be safe)
if not ni.loaded then
   local base_path = ni.backend.GetBaseFolder()

   -- Load the utilities table for use
   do
      local func, err = ni.backend.LoadFile(base_path.."addon\\core\\utilities.lua", "utilities.lua")
      if func then
         func(ni)
      else
         ni.backend.Error(err)
      end
   end

   -- TODO: continue loading files

   ni.loaded = true
end