-- ConfigManager Module
local HttpService = game:GetService("HttpService")

local ConfigManager = {}
ConfigManager.Mode = "Legacy" -- "Legacy" or "Normal"
ConfigManager.Flags = {}
ConfigManager.CurrentConfigName = "default"
ConfigManager.SaveFolderName = "UBHubConfigs" -- Default save folder name
ConfigManager.WindowInstance = nil -- Will be set during Init
ConfigManager.UIElementSetters = {} -- Stores functions to update UI elements: [flagName] = function(value)

local GLOBAL_SETTINGS_FILE = "window_settings.json"

-- Private helper to save data to a JSON file
function ConfigManager:_SaveFileJSON(fileName, dataTable)
    if not writefile then
        warn("ConfigManager: writefile is not available. Cannot save file: " .. fileName)
        return false
    end
    local fullPath = self.SaveFolderName .. "/" .. fileName
    local success, err = pcall(function()
        local jsonString = HttpService:JSONEncode(dataTable)
        writefile(fullPath, jsonString)
    end)
    if not success then
        warn("ConfigManager: Failed to save JSON to " .. fullPath .. " - " .. tostring(err))
        return false
    end
    return true
end

-- Private helper to load data from a JSON file
function ConfigManager:_LoadFileJSON(fileName)
    if not readfile or not isfile then
        warn("ConfigManager: readfile/isfile is not available. Cannot load file: " .. fileName)
        return nil
    end
    local fullPath = self.SaveFolderName .. "/" .. fileName
    if not isfile(fullPath) then
        -- warn("ConfigManager: File not found at " .. fullPath)
        return nil
    end

    local success, result = pcall(function()
        local jsonString = readfile(fullPath)
        return HttpService:JSONDecode(jsonString)
    end)

    if not success then
        warn("ConfigManager: Failed to load/decode JSON from " .. fullPath .. " - " .. tostring(result))
        return nil
    end
    return result
end

function ConfigManager:Init(windowInstance, saveFolderName)
    self.WindowInstance = windowInstance
    self.SaveFolderName = saveFolderName or self.SaveFolderName

    if not isfolder(self.SaveFolderName) then
        makefolder(self.SaveFolderName)
    end

    self:LoadGlobalFlags() -- Loads last_selected_config
    if self.Flags.last_selected_config then
        self:LoadConfig(self.Flags.last_selected_config)
    else
        self:LoadConfig(self.CurrentConfigName) -- Load default if no last_selected
    end
end

function ConfigManager:SaveGlobalFlags()
    local globalSettings = {
        last_selected_config = self.CurrentConfigName
    }
    self:_SaveFileJSON(GLOBAL_SETTINGS_FILE, globalSettings)
end

function ConfigManager:LoadGlobalFlags()
    local loadedSettings = self:_LoadFileJSON(GLOBAL_SETTINGS_FILE)
    if loadedSettings and loadedSettings.last_selected_config then
        self.CurrentConfigName = loadedSettings.last_selected_config
        -- The actual loading of the config's flags happens in Init or LoadConfig
    end
end

-- Call this when a UI element that uses a flag is created
function ConfigManager:RegisterUIElement(flagName, setterFunction)
    self.UIElementSetters[flagName] = setterFunction
end

function ConfigManager:ApplyFlagsToUI()
    if not self.WindowInstance then return end
    -- This function needs to iterate through self.Flags
    -- and update the corresponding UI elements.
    -- This requires UI elements to be findable or to have registered their update functions.
    -- print("ConfigManager: Applying flags to UI...")
    for flagName, value in pairs(self.Flags) do
        if self.UIElementSetters[flagName] then
            pcall(self.UIElementSetters[flagName], value)
        else
            -- warn("ConfigManager: No setter registered for flag: " .. flagName)
        end
    end
end

function ConfigManager:SetFlag(name, value, noSave)
    self.Flags[name] = value
    if self.Mode == "Legacy" and not noSave then
        self:SaveCurrentConfig()
    end
end

function ConfigManager:GetFlag(name, defaultValue)
    if self.Flags[name] == nil then
        return defaultValue
    end
    return self.Flags[name]
end

function ConfigManager:CreateConfig(configName)
    if not configName or string.gsub(configName, "%s", "") == "" then
        warn("ConfigManager:CreateConfig - configName cannot be empty.")
        return false
    end
    local success = self:_SaveFileJSON(configName .. ".json", {}) -- Save empty table
    if success then
        -- print("ConfigManager: Created config " .. configName)
    end
    return success
end

function ConfigManager:LoadConfig(configName)
    if not configName then
        warn("ConfigManager:LoadConfig - configName is nil.")
        return
    end
    -- print("ConfigManager: Attempting to load config: " .. configName)
    local loadedData = self:_LoadFileJSON(configName .. ".json")
    if loadedData then
        self.Flags = loadedData
        self.CurrentConfigName = configName
        self:ApplyFlagsToUI()
        self:SaveGlobalFlags() -- Update last_selected_config
        -- print("ConfigManager: Loaded config " .. configName)
        return true
    else
        -- If config doesn't exist, create it with current flags or empty?
        -- For now, if it doesn't exist, it just means flags remain as they are (or default)
        -- and we save the current flags under this new name if SaveCurrentConfig is called.
        -- Or, create an empty one:
        if configName == self.CurrentConfigName and not isfile(self.SaveFolderName .. "/" .. configName .. ".json") then
             -- print("ConfigManager: Config " .. configName .. " not found. Creating and saving current state as new default.")
             self.Flags = {} -- Start with fresh flags for a new default config if it didn't exist
             self:SaveCurrentConfig(configName) -- Save current (potentially empty) flags as this new config
        elseif not isfile(self.SaveFolderName .. "/" .. configName .. ".json") then
            -- print("ConfigManager: Config " .. configName .. " not found. Not loading.")
            return false -- Indicate failure to load
        end
    end
    return false
end

function ConfigManager:SaveCurrentConfig(configNameOverride)
    local name_to_save = configNameOverride or self.CurrentConfigName
    if not name_to_save then
        warn("ConfigManager:SaveCurrentConfig - No config name specified or set.")
        return false
    end
    -- print("ConfigManager: Saving current config as " .. name_to_save)
    return self:_SaveFileJSON(name_to_save .. ".json", self.Flags)
end

function ConfigManager:DeleteConfig(configName)
    if not configName then return false end
    -- print("ConfigManager: Deleting config " .. configName)
    local fullPath = self.SaveFolderName .. "/" .. configName .. ".json"
    if isfile and isfile(fullPath) then
        -- Roblox doesn't have a 'deletefile' function.
        -- This needs to be handled by the environment (e.g. Synapse X `delfile`)
        -- Or, we can "delete" by saving an empty table to it, effectively clearing it.
        -- For now, let's warn.
        if delfile then
             local success, err = pcall(function() delfile(fullPath) end)
             if not success then
                warn("ConfigManager: Failed to delete file: " .. fullPath .. " - " .. tostring(err))
                return false
             end
             return true
        else
            warn("ConfigManager: delfile function not available. Cannot truly delete config: " .. configName .. ". Clearing it instead.")
            return self:_SaveFileJSON(configName .. ".json", {deleted_marker=true}) -- Mark as deleted
        end
    end
    return false
end

function ConfigManager:ExportConfig(configName)
    local name_to_export = configName or self.CurrentConfigName
    local dataToExport = self.Flags
    if configName then -- If specific config name is given, load it temporarily
        local specificConfigData = self:_LoadFileJSON(name_to_export .. ".json")
        if specificConfigData then
            dataToExport = specificConfigData
        else
            warn("ConfigManager:ExportConfig - Config '" .. name_to_export .. "' not found for export.")
            return
        end
    end

    if setclipboard then
        local success, err = pcall(function()
            setclipboard(HttpService:JSONEncode(dataToExport))
        end)
        if success then
            -- print("ConfigManager: Config '" .. name_to_export .. "' copied to clipboard.")
            return true
        else
            warn("ConfigManager:ExportConfig - Failed to copy to clipboard: " .. tostring(err))
        end
    else
        warn("ConfigManager:ExportConfig - setclipboard is not available.")
    end
    return false
end

-- Method to get a list of available config files (excluding window_settings.json)
function ConfigManager:GetConfigList()
    local list = {}
    if listfiles then
        local files = listfiles(self.SaveFolderName)
        for _, filePath in ipairs(files) do
            local fileName = string.match(filePath, "[^/\\]+$") -- Extract file name from path
            if fileName and fileName ~= GLOBAL_SETTINGS_FILE and string.sub(fileName, -5) == ".json" then
                table.insert(list, string.sub(fileName, 1, -6)) -- Remove .json extension
            end
        end
    else
        warn("ConfigManager:GetConfigList - listfiles is not available.")
    end
    return list
end


return ConfigManager
