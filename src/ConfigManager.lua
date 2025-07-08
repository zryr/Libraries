-- ConfigManager.lua
return function(dependencies)
    local HttpService = game:GetService("HttpService")

    local ConfigManager = {
    CurrentMode = "Legacy", -- "Legacy" or "Normal"
    CurrentConfigName = "default_config",
    Flags = {}, -- This will hold the actual configuration data
    SaveFolderPath = "UBHub_Settings", -- Default save folder path
    WindowSettingsFileName = "window_settings.json",
    MainLibRef = nil, -- Reference to the main UBHubLib instance for callbacks if needed
    RegisteredElements = {} -- To store references to UI elements for applying loaded settings
}
ConfigManager.__index = ConfigManager

function ConfigManager.new(mainLibRef)
    local self = setmetatable({}, ConfigManager)
    self.MainLibRef = mainLibRef -- Store reference to the main library
    self.Flags = {} -- Initialize Flags for this instance
    self.RegisteredElements = {}
    -- Ensure the save folder exists (makefolder might be a global from the environment)
    if isfolder and makefolder and not isfolder(self.SaveFolderPath) then
        makefolder(self.SaveFolderPath)
    end
    self:_LoadWindowSettings() -- Load last selected config name
    return self
end

function ConfigManager:Init(flagsTable, saveFolderPath)
    -- flagsTable is the table used by the main library to store settings. We'll manage it.
    if flagsTable then self.Flags = flagsTable end
    if saveFolderPath then
        self.SaveFolderPath = saveFolderPath
        if isfolder and makefolder and not isfolder(self.SaveFolderPath) then
            makefolder(self.SaveFolderPath)
        end
    end
    self:_LoadWindowSettings()
    if self.CurrentConfigName and self.CurrentConfigName ~= "" then
        self:LoadConfig(self.CurrentConfigName, true) -- Load the last selected config silently
    else
        self:LoadConfig("default_config", true) -- Or load a default one
    end
end

function ConfigManager:SetMode(mode)
    if mode == "Legacy" or mode == "Normal" then
        self.CurrentMode = mode
        print("ConfigManager Mode set to:", mode)
    else
        warn("ConfigManager: Invalid mode specified. Use 'Legacy' or 'Normal'.")
    end
end

function ConfigManager:RegisterElement(elementName, elementObject, updateCallback)
    -- elementName: A unique string identifying the setting (e.g., "PlayerSpeedToggle")
    -- elementObject: The actual UI element object (e.g., the toggle returned by AddToggle)
    -- updateCallback: A function on the elementObject to set its value (e.g., elementObject:Set(value))
    self.RegisteredElements[elementName] = {
        Object = elementObject,
        UpdateCallback = updateCallback
    }
    -- Apply current flag value if it exists
    if self.Flags[elementName] ~= nil and updateCallback then
        pcall(updateCallback, elementObject, self.Flags[elementName])
    end
end


function ConfigManager:SaveSetting(key, value)
    self.Flags[key] = value
    if self.CurrentMode == "Legacy" then
        self:_PersistFlags(self.CurrentConfigName)
    end
end

function ConfigManager:LoadSetting(key, defaultValue)
    return self.Flags[key] or defaultValue
end

function ConfigManager:_PersistFlags(configName)
    if not configName or configName == "" then
        warn("ConfigManager: Cannot persist flags without a valid config name.")
        return false
    end
    if not writefile then
        warn("ConfigManager: writefile function is not available. Cannot save config.")
        return false
    end

    local path = self.SaveFolderPath .. "/" .. configName .. ".json"
    local success, err = pcall(function()
        local encoded = HttpService:JSONEncode(self.Flags)
        writefile(path, encoded)
    end)

    if not success then
        warn("ConfigManager: Save to " .. path .. " failed:", err)
        return false
    end
    print("ConfigManager: Config '" .. configName .. "' saved to " .. path)
    return true
end

function ConfigManager:_LoadWindowSettings()
    if not readfile or not isfile then
        warn("ConfigManager: readfile/isfile not available. Cannot load window settings.")
        return
    end
    local path = self.SaveFolderPath .. "/" .. self.WindowSettingsFileName
    if isfile(path) then
        local success, content = pcall(readfile, path)
        if success and content then
            local decodedSuccess, settings = pcall(HttpService.JSONDecode, HttpService, content)
            if decodedSuccess and type(settings) == "table" and settings.last_selected_config then
                self.CurrentConfigName = settings.last_selected_config
                print("ConfigManager: Loaded last selected config name:", self.CurrentConfigName)
            else
                warn("ConfigManager: Failed to decode window settings or last_selected_config not found.")
                 self.CurrentConfigName = "default_config"
            end
        else
            warn("ConfigManager: Failed to read window settings file at " .. path)
            self.CurrentConfigName = "default_config"
        end
    else
         self.CurrentConfigName = "default_config" -- Default if no settings file
    end
end

function ConfigManager:_SaveWindowSettings()
    if not writefile then
        warn("ConfigManager: writefile not available. Cannot save window settings.")
        return
    end
    local path = self.SaveFolderPath .. "/" .. self.WindowSettingsFileName
    local settings = { last_selected_config = self.CurrentConfigName }
    local success, err = pcall(function()
        local encoded = HttpService:JSONEncode(settings)
        writefile(path, encoded)
    end)
    if not success then
        warn("ConfigManager: Failed to save window settings to " .. path .. ":", err)
    end
end

function ConfigManager:CreateConfig(configName)
    if not configName or configName == "" then
        warn("ConfigManager: Cannot create config without a valid name.")
        return false
    end
    -- Essentially saves the current (potentially empty or default) flags under the new name.
    -- If you want a truly "empty" config, you might clear self.Flags first,
    -- or save an empty table specifically if the file doesn't exist.
    -- For simplicity, Create will just persist current state to new name.
    local oldConfigName = self.CurrentConfigName
    local oldFlags = {} -- Deep copy old flags if needed, or start fresh
    for k,v in pairs(self.Flags) do oldFlags[k] = v end

    self.CurrentConfigName = configName
    -- self.Flags = {} -- Option: Start with a fresh set of flags for a new config
    local success = self:_PersistFlags(configName)
    if success then
        self:_SaveWindowSettings() -- Save this new config as the last selected
    else
        -- Revert if save failed
        self.CurrentConfigName = oldConfigName
        -- self.Flags = oldFlags -- Revert flags if they were cleared
    end
    return success
end

function ConfigManager:LoadConfig(configName, silent)
    if not configName or configName == "" then
        warn("ConfigManager: Cannot load config without a valid name.")
        return false
    end
    if not readfile or not isfile then
        warn("ConfigManager: readfile/isfile function is not available. Cannot load config.")
        return false
    end

    local path = self.SaveFolderPath .. "/" .. configName .. ".json"
    if not isfile(path) then
        if not silent then warn("ConfigManager: Config file " .. path .. " not found. Creating and loading default values.") end
        self.Flags = {} -- Reset to empty or load library defaults
        -- Populate self.Flags with default values from all registered elements if desired
        for name, data in pairs(self.RegisteredElements) do
            if data.Object and data.Object.DefaultValue ~= nil then -- Assuming elements store a DefaultValue
                self.Flags[name] = data.Object.DefaultValue
            end
        end
        self.CurrentConfigName = configName
        self:_PersistFlags(configName) -- Save this new "default" config
        self:_SaveWindowSettings()
        self:_ApplyFlagsToElements()
        return true -- Technically loaded (a new default one)
    end

    local success, content = pcall(readfile, path)
    if success and content then
        local decodedSuccess, loadedFlags = pcall(HttpService.JSONDecode, HttpService, content)
        if decodedSuccess and type(loadedFlags) == "table" then
            self.Flags = loadedFlags
            self.CurrentConfigName = configName
            self:_SaveWindowSettings()
            if not silent then print("ConfigManager: Config '" .. configName .. "' loaded.") end
            self:_ApplyFlagsToElements()
            return true
        else
            if not silent then warn("ConfigManager: Failed to decode config file " .. path .. ". Error: " .. tostring(loadedFlags)) end
            return false
        end
    else
        if not silent then warn("ConfigManager: Failed to read config file " .. path .. ". Error: " .. tostring(content)) end
        return false
    end
end

function ConfigManager:_ApplyFlagsToElements()
    for name, data in pairs(self.RegisteredElements) do
        local value = self.Flags[name]
        if value ~= nil and data.UpdateCallback then
            -- The update callback should handle applying the value to the element
            -- e.g., for a toggle, it might be `data.Object:Set(value)`
            local success, err = pcall(data.UpdateCallback, data.Object, value)
            if not success then
                warn("ConfigManager: Error applying flag '"..name.."' to element:", err)
            end
        end
    end
end


function ConfigManager:DeleteConfig(configName)
    if not configName or configName == "" then
        warn("ConfigManager: Cannot delete config without a valid name.")
        return false
    end
    if not deletefile or not isfile then
        warn("ConfigManager: deletefile/isfile function is not available. Cannot delete config.")
        return false
    end

    local path = self.SaveFolderPath .. "/" .. configName .. ".json"
    if isfile(path) then
        local success, err = pcall(deletefile, path)
        if success then
            print("ConfigManager: Config '" .. configName .. "' deleted.")
            if self.CurrentConfigName == configName then
                self.CurrentConfigName = "default_config" -- Revert to default
                self.Flags = {} -- Clear flags or load default
                self:LoadConfig(self.CurrentConfigName, true) -- Load default config
            end
            return true
        else
            warn("ConfigManager: Failed to delete config file " .. path .. ":", err)
            return false
        end
    else
        warn("ConfigManager: Config file " .. path .. " not found for deletion.")
        return false
    end
end

function ConfigManager:OverwriteConfig(configName)
    if not configName or configName == "" then
        warn("ConfigManager: Cannot overwrite config without a valid name.")
        return false
    end
    -- Overwriting is essentially just saving the current Flags under that name.
    return self:_PersistFlags(configName)
end

function ConfigManager:ExportConfig(configName)
    if not configName or configName == "" then
        warn("ConfigManager: Cannot export config without a valid name.")
        return nil
    end

    local flagsToExport = self.Flags
    if self.CurrentConfigName ~= configName then
        -- If a different config is requested for export, try to load it temporarily
        -- This is a simplified approach; a more robust one might read the file directly without altering current state.
        local path = self.SaveFolderPath .. "/" .. configName .. ".json"
        if isfile and readfile and isfile(path) then
            local success, content = pcall(readfile, path)
            if success and content then
                local decodedSuccess, tempFlags = pcall(HttpService.JSONDecode, HttpService, content)
                if decodedSuccess then
                    flagsToExport = tempFlags
                else
                    warn("ConfigManager: Failed to decode " .. configName .. " for export. Exporting current config instead.")
                end
            else
                 warn("ConfigManager: Failed to read " .. configName .. " for export. Exporting current config instead.")
            end
        else
            warn("ConfigManager: Config " .. configName .. " not found for export. Exporting current config instead.")
        end
    end

    if flagsToExport then
        local success, encoded = pcall(HttpService.JSONEncode, HttpService, flagsToExport)
        if success then
            if setclipboard then
                setclipboard(encoded)
                print("ConfigManager: Config '" .. configName .. "' copied to clipboard.")
            else
                warn("ConfigManager: setclipboard function not available.")
            end
            return encoded
        else
            warn("ConfigManager: Failed to encode config '" .. configName .. "' for export:", encoded)
            return nil
        end
    end
    return nil
end

function ConfigManager:ListConfigs()
    local configs = {}
    if listfiles then
        local pathPattern = self.SaveFolderPath .. "/(.*)%.json"
        for _, filePath in ipairs(listfiles(self.SaveFolderPath)) do
            local name = filePath:match("/(%.%a+)%.json$") -- More robust extraction
            if name and name ~= self.WindowSettingsFileName:match("(.+)%.json$") then -- Exclude window_settings
                table.insert(configs, name)
            end
        end
    else
        warn("ConfigManager: listfiles function not available. Cannot list configs.")
    end
    return configs
end


return ConfigManager
end
