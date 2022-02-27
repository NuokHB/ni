local ni = ...

ni.profiles = {}
ni.profiles.class = {}
ni.profiles.generic = {}

function ni.profiles.get_profiles()
   local class = ni.player.class():lower()
   local contents = ni.io.get_folders("addon\\Rotations\\") or {}
   for i = 1, #contents do
      if string.match(contents[i]:lower(), class) then
         local entries = ni.io.get_entries(contents[i]) or {}
            for e = 1, #entries do
               local version = 0
               ni.backend.ParseFile(
                  entries[e].path,
                  function(content)
                     version = tonumber(string.match(content, "--Version:%s*(%d[,.%d]*)"))
                  end
               )
               if entries[e].extension == ".lua" or entries[e].extension == ".enc" then
                  ni.profiles.class[entries[e].stem] =
                  {
                     version = version,
                     stem = entries[e].stem,
                     extension= entries[e].extension,
                     filename = entries[e].filename,
                     path = entries[e].path
                  }
               end
            end
      end
      if string.match(contents[i], "Generic") then
         local entries = ni.io.get_entries(contents[i]) or {}
         for e = 1, #entries do
            if entries[e].extension == ".lua" or entries[e].extension == ".enc" then
               local version = 0
               ni.backend.ParseFile(
                  entries[e].path,
                  function(content)
                     version = tonumber(string.match(content, "--Version:%s*(%d[,.%d]*)"))
                  end
               )
               ni.profiles.generic[entries[e].stem] = entries[e]
               ni.profiles.generic[entries[e].stem].version = version
            end
         end
      end
   end
end
