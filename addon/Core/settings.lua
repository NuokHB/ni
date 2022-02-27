local ni = ...

ni.settings = {}

--[[--
Saves the settings table to dest as a json file
 
Parameters:
- **table** `table`
- **file** `string`
 
Returns:
- **saved** `boolean`
@param file string
@param content string
]]
function ni.settings.save(table, file)
   local json, jerror = ni.utilities.to_json(table)
   if jerror then
      ni.client.error(jerror)
   end
   if ni.io.save_content(file, json) then
      return true
   end
   return false
end

--[[--
Loads the settings json file as a table
 
Parameters:
- **file** `string`
 
Returns:
- **table** `table`
@param file string
]]
function ni.settings.load(file)
   local content, cerr = ni.io.get_content(file)
   if cerr then
      ni.backend.Error(cerr)
   end
   if content then
      local json, jerror = ni.utilities.from_json(content)
      if jerror then
         ni.backend.Error(jerror)
      end
      return json
   end
end

--[[--
Default main settings
]]
ni.settings.main = {
   latency = 200,
   keys ={
      toggle = "F10",
      primary = "F1",
      secondary = "F2",
      generic = "F3",
   },
   profiles = {
      primary = {
         name = "None",
         enabled = false
      },
      secondary = {
         name = "None",
         enabled = false
      },
      generic = {
         name = "None",
         enabled = false
      },
   }
}
