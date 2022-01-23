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

   -- As long as the files table isn't inserted to or removed from it'll stay in this order
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
      "rune.lua",
      "unit.lua",
      "player.lua",
      "spell.lua",
      "update.lua",
      "ui.lua"
   }

   -- Load each of the above files here
   for _, file in pairs(core_files) do
      local _, error = ni.io.load_file(core_path..file, file)
      if error then
         ni.backend.Error(error)
      end
   end

   ni.events.initialize()
   ni.update.initialize()

   ni.window = ni.ui.window("ni "..ni.__version, false)
   if ni.window then
      local tab_manager = ni.ui.tab_manager(ni.window)
      local main_tab = tab_manager:AddTab("Main")
      local toggle_key = "F10"
      local main_tab_manager = ni.ui.tab_manager(main_tab)
      do
         -- Setup the main window portion
         local selector_tab = main_tab_manager:AddTab("Selector")
         local plugin_label = ni.ui.label(selector_tab)
         plugin_label.Text = "Plugins:"
         local plugin_combo = ni.ui.combobox(selector_tab, true)
         plugin_combo.Text = "##plugins"
      end
      do
         local settings_tab = main_tab_manager:AddTab("Settings")
         local toggle_label = ni.ui.label(settings_tab)
         toggle_label.Text = "UI Toggle:"
         local toggle_combo = ni.ui.combobox(settings_tab, true)
         toggle_combo.Text = "##uitoggle"
         toggle_combo.Selected = toggle_key
         for i = 1, 12 do
            local key = string.format("F%d", i)
            toggle_combo:Add(key)
         end
         toggle_combo.Callback = function(selected)
            toggle_key = selected
         end
      end
      local tracker_tab = tab_manager:AddTab("Tracker")
      do
         -- Set up the tracking tabs
         local tracker_tab_manager = ni.ui.tab_manager(tracker_tab)
         do 
            local resource_tab = tracker_tab_manager:AddTab("Resources")
         end
         do
            local creature_tab = tracker_tab_manager:AddTab("Creatures")
         end
      end
      -- Create the callback for toggling the window open and close
      ni.input.register_callback("ni-main", function()
         if ni.input.key_down(toggle_key) then
            ni.window.Open = not ni.window.Open
            return true
         end
         return false
      end)
   end
   -- TODO: continue after loading files

   ni.loaded = true
end