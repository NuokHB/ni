local ni = ...

-- Prevent double loading (Shouldn't happen, but just to be safe)
if not ni.loaded_init then
   local base_path = ni.backend.GetBaseFolder()
   local core_path = base_path .. "addon\\core\\"
   local initial_files = {
      "io.lua",
      "client.lua",
      "utilities.lua",
      "table.lua",
      "events.lua"
   }

   -- Load the utilities table for use
   for i = 1, #initial_files do
      local file = initial_files[i]
      local func, err = ni.backend.LoadFile(core_path .. file, file)
      if func then
         func(ni)
      else
         ni.backend.Error(err)
      end
   end

   -- Seed the random number generator
   ni.utilities.randomseed(ni.client.get_time())

   -- Setup the main frame for functions used later
   ni.frame = ni.client.get_function("CreateFrame")("frame", nil, UIParent)
   ni.frame:RegisterAllEvents()
   ni.backend.ProtectFrame(ni.frame, UIParent)
   ni.events.initialize()

   ni.load_core = function()
      local core_files = {
         "input.lua",
         "world.lua",
         "navigation.lua",
         "item.lua",
         "gear.lua",
         "object.lua",
         "power.lua",
         "rune.lua",
         "runes.lua",
         "unit.lua",
         "player.lua",
         "spell.lua",
         "update.lua",
         "objects.lua",
         "group.lua",
         "members.lua",
         "pet.lua",
         "totem.lua",
         "profiles.lua",
         "profile.lua",
         "ui.lua",
         "settings.lua"
      }

      -- Load each of the above files here
      for _, file in ni.table.pairs(core_files) do
         local _,
            error = ni.io.load_file(core_path .. file, file)
         if error then
            ni.backend.Error(error)
         end
      end

      ni.update.initialize()

      -- Load in the main settings file
      do
         local path = ni.settings.path .. "main.json"
         ni.settings.main_path = path
         local saved_settings = ni.settings.load(path)
         if saved_settings then
            ni.settings.main = saved_settings
         else
            ni.settings.save(path, ni.settings.main)
         end
      end

      --Load the profiles
      do
         ni.profiles.get_profiles()
         ni.profiles.load_all()
      end

      -- Load the window
      do
         local window_init = core_path .. "components\\main_window\\init.lua"
         local func, err = ni.io.load_buffer(window_init, string.format("@%s", window_init))
         if err then
            ni.backend.Error(err)
         else
            func(ni, core_path)
         end
      end
      ni.loaded = true
   end

   -- Setup loading in the core files to prevent some functions not being avalible
   ni.in_game = false
   ni.PLAYER_ENTERING_WORLD = function(...)
      ni.utilities.log("PLAYER_ENTERING_WORLD")
      ni.in_game = true
      if not ni.loaded then
         ni.load_core()
      end
   end
   ni.PLAYER_LOGOUT = function(...)
      ni.utilities.log("PLAYER_LOGOUT")
      ni.in_game = false
   end
   ni.events.register_callback("PLAYER_ENTERING_WORLD", ni.PLAYER_ENTERING_WORLD)
   ni.events.register_callback("PLAYER_LOGOUT", ni.PLAYER_LOGOUT)
   ni.loaded_init = true
end
