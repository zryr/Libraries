import re

with open('UBHubLib_Icons_Fonts_Themes_Config.lua', 'r') as f:
    content = f.read()

# Replace `isfile` checks with pcalled isfile checks, as Codex can crash on isfolder/isfile with bad paths.
makefolder_search = """	pcall(function()
		if isfolder and not isfolder(self.RootFolder) then makefolder(self.RootFolder) end
		if isfolder and not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
	end)"""
makefolder_replace = """	pcall(function()
		local function safe_isfolder(path) local s, r = pcall(isfolder, path); return s and r end
		if isfolder and not safe_isfolder(self.RootFolder) then makefolder(self.RootFolder) end
		if isfolder and not safe_isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
	end)"""
content = content.replace(makefolder_search, makefolder_replace)

loadsettings_search = """function CoreSystems.ConfigManager:LoadSettings()
    if isfile and isfile(self.SettingsFile) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(self.SettingsFile))
        end)"""
loadsettings_replace = """function CoreSystems.ConfigManager:LoadSettings()
    if isfile then
        local exists = false
        pcall(function() exists = isfile(self.SettingsFile) end)
        if exists then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(self.SettingsFile))
            end)"""
content = content.replace(loadsettings_search, loadsettings_replace)

load_search = """function CoreSystems.ConfigManager:Load(configName)
    if not isfile or not readfile then return false end
    local path = self.ConfigFolder .. "/" .. configName .. ".json"

    if isfile(path) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)"""
load_replace = """function CoreSystems.ConfigManager:Load(configName)
    if not isfile or not readfile then return false end
    local path = self.ConfigFolder .. "/" .. configName .. ".json"

    local exists = false
    pcall(function() exists = isfile(path) end)

    if exists then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)"""
content = content.replace(load_search, load_replace)

with open('UBHubLib_Icons_Fonts_Themes_Config.lua', 'w') as f:
    f.write(content)

print("Patching Codex Compatibility complete")
