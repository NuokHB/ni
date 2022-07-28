local ni = ...

-- Prevent double loading (Shouldn't happen, but just to be safe)
if not ni.loaded_init then
    local base_path = ni.backend.GetBaseFolder()
    local core_path = base_path .. "addon\\core\\"
    local initial_files = {
        "io.lua",
        "client.lua",
        "utilities.lua",
        "memory.lua",
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

    -- As long as the files table isn't inserted to or removed from it'll stay in this order
    local core_files = {
        "events.lua",
        "gear.lua",
        "group.lua",
        "input.lua",
        "item.lua",
        "members.lua",
        "mount.lua",
        "navigation.lua",
        "object.lua",
        "objects.lua",
        "pet.lua",
        "player.lua",
        "power.lua",
        "profile.lua",
        "profiles.lua",
        "rune.lua",
        "runes.lua",
        "settings.lua",
        "spell.lua",
        "totem.lua",
        "ui.lua",
        "unit.lua",
        "update.lua",
        "world.lua"
    }

    function ni.load_files(files_to_load)
        local base_path = ni.backend.GetBaseFolder()
        local core_path = base_path .. "addon\\core\\"
        for _, file in ni.table.pairs(files_to_load) do
            local _, error = ni.io.load_file(core_path .. file, file)
            if error then
                ni.backend.Error(error)
            end
        end
    end

    ni.load_files(core_files)

    ni.events.initialize()
    ni.update.initialize()

    -- Load in the main settings file
    do
        local path = ni.settings.path .. ni.player.guid() .. "_main.json"
        ni.settings.main_path = path
        local saved_settings = ni.settings.load(path)
        if saved_settings then
            ni.settings.main = saved_settings
        else
            ni.settings.save(path, ni.settings.main)
        end
    end

    -- Load the profiles
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

    -- Start updating members and objects
    ni.update.register_callback("OBJECTS", ni.objects.update)
    ni.update.register_callback("MEMBERS", ni.members.update)
    ni.loaded = true
end

-- Event tracking for if we are in game or not
ni.in_game = false
-- Fires when entering the game
ni.PLAYER_ENTERING_WORLD = function(...)
    ni.utilities.log("PLAYER_ENTERING_WORLD")
    ni.in_game = true
    if not ni.loaded then
        ni.load_core()
    end
    local table_files = {
        "tables\\spells.lua"
    }
    ni.load_files(table_files)

end
-- Fires on logout or reload
ni.PLAYER_LOGOUT = function(...)
    ni.utilities.log("PLAYER_LOGOUT")
    ni.in_game = false
end
-- Fires on map changes ect
ni.PLAYER_LEAVING_WORLD = function(...)
    ni.utilities.log("PLAYER_LEAVING_WORLD")
    ni.in_game = false
end
-- Register the callbacks for all 3
ni.events.register_callback("PLAYER_ENTERING_WORLD", ni.PLAYER_ENTERING_WORLD)
ni.events.register_callback("PLAYER_LOGOUT", ni.PLAYER_LOGOUT)
ni.events.register_callback("PLAYER_LEAVING_WORLD", ni.PLAYER_LEAVING_WORLD)
ni.loaded_init = true
