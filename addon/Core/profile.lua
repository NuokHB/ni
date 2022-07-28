local ni = ...

ni.profile = {}

local GenerateUi = function(ui, parent, name)
    if ui == nil then
        return nil
    end
    if type(ui) ~= "table" then
        return nil
    end
    if ui.settingsfile then
        local callback = ui.callback
        if not ni.io.file_exists then
            ni.settings.save(ni.settings.path .. ui.settingsfile, ui)
        end
        local settings = ni.settings.load(ni.settings.path .. ui.settingsfile)
        if settings ~= nil then
            ui = settings
        end
        local save = function()
            ni.settings.save(ni.settings.path .. ui.settingsfile, ui)
        end
        for k, v in ni.table.ipairs(ui) do
            if type(v) == "table" then
                if v.type == "label" then
                    local label = ni.ui.label(parent)
                    label.Text = v.text

                elseif v.type == "separator" then
                    ni.ui.separator(parent)

                elseif v.type == "input" and v.key ~= nil then
                    local input = ni.ui.input(parent, v.same_line)
                    input.Value = v.value
                    input.Text = v.text

                elseif v.type == "checkbox" and v.key ~= nil then
                    if v.enabled ~= nil then
                        local checkbox = ni.ui.checkbox(parent, v.same_line)
                        checkbox.Text = v.text
                        checkbox.Checked = v.enabled
                        checkbox.Callback = function(checked)
                            v.enabled = checked
                            if callback then
                                callback(v.key, "enabled", v.enabled)
                            end
                            save()
                        end
                    end

                elseif v.type == "combobox" and v.key ~= nil then
                    local combobox = ni.ui.combobox(parent)
                    combobox.Text = v.text
                    local selected
                    for _, v2 in ipairs(v.menu) do
                        local text
                        if v2.text ~= nil then
                            text = v2.text
                            combobox:Add(v2.text)
                        elseif v2.value ~= nil then
                            combobox:Add(v2.value)
                        end
                        if ni.settings.profile[name][v.key] == text then
                            combobox.Selected = text
                            selected = text
                        elseif v2.selected then
                            combobox.Selected = text
                            selected = text
                        end
                    end
                    if callback then
                        combobox.Callback = function(s)
                            selected = s
                            callback(v.key, "menu", s)
                            ni.settings.profile[name][v.key] = s
                            save()
                        end
                        callback(v.key, "menu", selected)
                    end

                elseif v.type == "slider" then
                    local slider = ni.ui.slider(parent)
                    slider.Text = v.text
                    if ni.settings.profile[name][v.key] ~= nil then
                        v.value = ni.settings.profile[name][v.key]
                    end
                    slider.Value = v.value
                    slider.Min = v.min
                    slider.Max = v.max
                    if callback then
                        slider.Callback = function(value)
                            v.value = value
                            callback(v.key, "value", value)
                            ni.settings.profile[name][v.key] = value
                            save()
                        end
                        callback(v.key, "value", v.value)
                    end
                end
            end
        end
    end
    ni.profile[name].ui = ui
end

function ni.profile.new(name, queue, abilities, ui, events)
    local profile = {}
    profile.loaded = true
    profile.name = name
    profile.ui_created = false
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
    function profile.events(...)
        events(...)
    end
    profile.has_ui = ui ~= nil
    function profile.create_ui(tab)
        GenerateUi(ui, tab, name)
        profile.ui_created = true
    end
    function profile.get_setting(key)
        for k, v in ipairs(ni.profile[name].ui) do
            if v.type == "checkbox" and v.key ~= nil and v.key == key then
                return v.enabled
            end
            if v.type == "combobox" then
                return v.selected
            end
            if v.type == "input" and v.key ~= nil and v.key == key then
                return v.value
            end
        end
    end

    ni.profile[name] = profile
end
