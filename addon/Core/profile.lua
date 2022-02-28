local ni = ...

ni.profile = {}

local GenerateUi = function(ui, parent)
   if ui == nil then
      return nil
   end
   if type(ui) ~= "table" then
      return nil
   end
   if ui.settingsfile then
      local callback = ui.callback
      local settings = ni.settings.load(ni.settings.path .. ui.settingsfile)
      if settings ~= nil then
         ui = settings
      end
      local save = function()
         ni.settings.save(ni.settings.path .. ui.settingsfile, ui)
      end
      for k, v in ni.table.ipairs(ui) do
         if type(v) == "table" then
            if v.type == "title" then
               local label = ni.ui.label(parent)
               label.Text = v.text

            elseif v.type == "separator" then
               ni.ui.separator(parent)

            elseif v.type == "checkbox" and v.key ~= nil then
               if v.enabled ~= nil then
                  local checkbox = ni.ui.checkbox(parent)
                  checkbox.Text = v.text
                  if callback then
                     checkbox.Callback = function(checked)
                        v.enabled = checked
                        callback(v.key, "enabled", v.enabled)
                        save()
                     end
                     callback(v.key, "enabled", v.enabled)
                     checkbox.Checked = v.enabled
                  end
               end

            elseif v.type == "combobox" and v.key ~= nil then
               local combobox = ni.ui.combobox(parent)
               local selected
               for _, v2 in ipairs(v.menu) do
                  local text
                  if v2.text ~= nil then
                     text = v2.text
                     combobox:Add(v2.text)
                  elseif v2.value ~= nil then
                     combobox:Add(v2.value)
                  end
                  if v2.selected then
                     combobox.Selected = text
                     selected = text
                  end
               end
               if callback then
                  combobox.Callback = function(s)
                     selected = s
                     callback(v.key, "menu", s)
                     save()
                  end
                  callback(v.key, "menu", selected)
               end

            elseif v.type == "slider" then
               local slider = ni.ui.slider(parent)
               slider.Text = v.text
               slider.Value = v.value
               slider.Min = v.min
               slider.Max = v.max
               if callback then
                  slider.Callback = function(value)
                     v.value = value
                     callback(v.key, "value", value)
                     save()
                  end
                  callback(v.key, "value", v.value)
               end
            end
         end
      end
   end
end

function ni.profile.new(name, queue, abilities, ui)
   local profile = {}
   profile.loaded = true
   profile.name = name
   function profile.execute(self)
      local temp_queue
      if type(queue) == "function" then
         temp_queue = queue()
      else
         temp_queue = queue
      end
      for i = 1, #temp_queue do
         local abilityinqueue = temp_queue[i]
         if abilities[abilityinqueue] ~= nil and abilities[abilityinqueue]() then
            break
         end
      end
   end
   profile.has_ui = ui ~= nil
   function profile.ui(tab)
      GenerateUi(ui, tab)
   end
   ni.profile[name] = profile
end
