import re

with open('UBHubLib_Icons_Fonts_Themes_Config.lua', 'r') as f:
    content = f.read()

delete_search = """function CoreSystems.ConfigManager:Delete(configName)
	if delfile then
		local path = self.ConfigFolder .. "/" .. configName .. ".json"
		if isfile and isfile(path) then
			pcall(function() delfile(path) end)
		end
	end
end"""
delete_replace = """function CoreSystems.ConfigManager:Delete(configName)
	if delfile then
		local path = self.ConfigFolder .. "/" .. configName .. ".json"
		local exists = false
		pcall(function() exists = isfile(path) end)
		if exists then
			pcall(function() delfile(path) end)
		end
	end
end"""
content = content.replace(delete_search, delete_replace)

allconfigs_add = """function CoreSystems.ConfigManager:AllConfigs()
	local configs = {}
	if listfiles then
		pcall(function()
			for _, file in pairs(listfiles(self.ConfigFolder)) do
				if file:match("%.json$") then
					local name = file:match("([^/\\]+)%.json$")
					if name then table.insert(configs, name) end
				end
			end
		end)
	end
	return configs
end
"""
content = content.replace("function CoreSystems.ConfigManager:UpdateFlag(flag, value)", allconfigs_add + "function CoreSystems.ConfigManager:UpdateFlag(flag, value)")

with open('UBHubLib_Icons_Fonts_Themes_Config.lua', 'w') as f:
    f.write(content)
