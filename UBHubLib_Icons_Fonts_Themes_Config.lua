local HttpService = game:GetService("HttpService")

local CoreSystems = {}

-- [[ 1. THEMES SYSTEM ]]
CoreSystems.Themes = {
    ["UB-V5 Default"] = {
        Colors = {
            Primary = Color3.fromRGB(160, 40, 0),
            Secondary = Color3.fromRGB(160, 30, 0),
            Accent = Color3.fromRGB(200, 50, 0),
            ThemeHighlight = Color3.fromRGB(255, 80, 0),
            Text = Color3.fromRGB(255, 240, 230),
            Background = Color3.fromRGB(20, 8, 0),
            Stroke = Color3.fromRGB(80, 20, 0),
            WindowBackground = Color3.fromRGB(20, 8, 0),
            ElementBackground = Color3.fromRGB(160, 30, 0),
            ElementTitle = Color3.fromRGB(255, 240, 230),
            ElementDesc = Color3.fromRGB(255, 255, 255),
            Outline = Color3.fromRGB(80, 20, 0)
        },
        Fonts = {
            Default = Enum.Font.GothamBold,
            Medium = Enum.Font.GothamMedium,
            Regular = Enum.Font.Gotham
        },
        Sizes = {
            UICorner = 8,
            TabPadding = 10,
        }
    },
    ["Dark"] = {
        Colors = {
            Primary = Color3.fromHex("#18181b"),
            Secondary = Color3.fromHex("#27272a"),
            Accent = Color3.fromHex("#3f3f46"),
            ThemeHighlight = Color3.fromHex("#0091FF"),
            Text = Color3.fromHex("#ffffff"),
            Background = Color3.fromHex("#09090b"),
            Stroke = Color3.fromHex("#27272a"),
            WindowBackground = Color3.fromHex("#101010"),
            ElementBackground = Color3.fromHex("#18181b"),
            ElementTitle = Color3.fromHex("#ffffff"),
            ElementDesc = Color3.fromHex("#a1a1aa"),
            Outline = Color3.fromHex("#3f3f46")
        },
        Fonts = {
            Default = Enum.Font.GothamBold,
            Medium = Enum.Font.GothamMedium,
            Regular = Enum.Font.Gotham
        },
        Sizes = {
            UICorner = 6,
            TabPadding = 8,
        }
    }
}

CoreSystems.CurrentTheme = "UB-V5 Default"

function CoreSystems.GetColor(colorName)
    local theme = CoreSystems.Themes[CoreSystems.CurrentTheme]
    return theme.Colors[colorName] or Color3.new(1, 1, 1)
end

function CoreSystems.ApplyGradient(element, colorSequence)
    local existingGradient = element:FindFirstChildOfClass("UIGradient")
    if existingGradient then
        existingGradient.Color = colorSequence
    else
        local gradient = Instance.new("UIGradient")
        gradient.Color = colorSequence
        gradient.Parent = element
    end
end

function CoreSystems.ApplyColor(element, property, colorValue)
    if typeof(colorValue) == "ColorSequence" then
        element[property] = Color3.new(1, 1, 1) -- Need white base for gradient
        CoreSystems.ApplyGradient(element, colorValue)
    else
        local existingGradient = element:FindFirstChildOfClass("UIGradient")
        if existingGradient then existingGradient:Destroy() end
        element[property] = colorValue
    end
end

-- [[ 2. FONT MANAGER ]]
CoreSystems.FontManager = {
    Fonts = {
        Default = Enum.Font.GothamBold,
    }
}

function CoreSystems.FontManager:Set(element, fontName)
    local theme = CoreSystems.Themes[CoreSystems.CurrentTheme]
    element.Font = theme.Fonts[fontName] or theme.Fonts.Default or Enum.Font.GothamBold
end

-- [[ 3. ICONS SYSTEM (HYBRID) ]]
CoreSystems.Icons = {
    Lucide = nil,
    Craft = nil,
    Fallback = {
        ["search"] = "rbxassetid://121018724060431",
        ["settings"] = "rbxassetid://80758916183665",
        ["check"] = "rbxassetid://93898873302694",
        ["triangle-alert"] = "rbxassetid://125920361880643",
        ["chevron-down"] = "rbxassetid://134243273101015",
        ["edit"] = "rbxassetid://5595830746",
        ["x"] = "rbxassetid://110786993356448"
    }
}

local function FetchIconLibrary(name, url)
    local success, response = pcall(function()
        if game and game.HttpGetAsync then
            return game:HttpGetAsync(url)
        end
        return nil
    end)

    if success and response then
        -- Very basic Lua table parsing logic, assumes strict formatting from the github source
        local icons = {}
        for line in response:gmatch("[^\r\n]+") do
            local key, value = line:match('%["([^"]+)"%]%s*=%s*"([^"]+)"')
            if key and value then
                icons[key] = value
            end
        end
        return icons
    end
    return nil
end

task.spawn(function()
    CoreSystems.Icons.Lucide = FetchIconLibrary("lucide", "https://raw.githubusercontent.com/Footagesus/Icons/main/lucide/dist/Icons.lua")
end)

function CoreSystems.GetIcon(library, name)
    if not name then return "" end
    if typeof(name) == "string" and name:match("^rbxassetid://") or name:match("^http") then
        return name
    end

    local libData = nil
    if library == "lucide" then libData = CoreSystems.Icons.Lucide
    elseif library == "craft" then libData = CoreSystems.Icons.Craft end

    if libData and libData[name] then
        return libData[name]
    end

    return CoreSystems.Icons.Fallback[name] or "rbxassetid://0"
end

-- [[ 4. CONFIG MANAGER ]]
CoreSystems.ConfigManager = {
    Mode = "Legacy", -- "Legacy" or "Normal"
    CurrentConfig = "default",
    RootFolder = "UBHub5",
    ConfigFolder = "UBHub5/Configs",
    SettingsFile = "UBHub5/window_settings.json",
    Flags = {},
    QuickToggleLayouts = {},
    CustomUserThemes = {},
    _SaveDebounce = false
}

function CoreSystems.ConfigManager:Init(rootFolder)
    self.RootFolder = rootFolder or "UBHub5"
    self.ConfigFolder = self.RootFolder .. "/Configs"
    self.SettingsFile = self.RootFolder .. "/window_settings.json"

    pcall(function()
        if isfolder and not isfolder(self.RootFolder) then makefolder(self.RootFolder) end
        if isfolder and not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
    end)

    self:LoadSettings()
end

function CoreSystems.ConfigManager:LoadSettings()
    if isfile then
        local exists = false
        pcall(function() exists = isfile(self.SettingsFile) end)
        if exists then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(self.SettingsFile))
            end)
        if success and type(data) == "table" then
            self.Mode = data.Mode or "Legacy"
            self.CurrentConfig = data.LastConfig or "default"
            self:Load(self.CurrentConfig)
        end
    end
end

function CoreSystems.ConfigManager:SaveSettings()
    if writefile then
        local data = {
            Mode = self.Mode,
            LastConfig = self.CurrentConfig
        }
        pcall(function()
            writefile(self.SettingsFile, HttpService:JSONEncode(data))
        end)
    end
end

function CoreSystems.ConfigManager:Save(configName)
    if not writefile then return false end
    configName = configName or self.CurrentConfig
    local path = self.ConfigFolder .. "/" .. configName .. ".json"

    local dataToSave = {
        Flags = self.Flags,
        QuickToggleLayouts = self.QuickToggleLayouts,
        CustomUserThemes = self.CustomUserThemes
    }

    local success, err = pcall(function()
        writefile(path, HttpService:JSONEncode(dataToSave))
    end)

    if success then
        self.CurrentConfig = configName
        self:SaveSettings()
    else
        warn("Failed to save config:", err)
    end
    return success
end

function CoreSystems.ConfigManager:Load(configName)
    if not isfile or not readfile then return false end
    local path = self.ConfigFolder .. "/" .. configName .. ".json"

    local exists = false
    pcall(function() exists = isfile(path) end)

    if exists then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if success and type(data) == "table" then
            self.Flags = data.Flags or {}
            self.QuickToggleLayouts = data.QuickToggleLayouts or {}
            self.CustomUserThemes = data.CustomUserThemes or {}
            self.CurrentConfig = configName
            self:SaveSettings()
            return true
        end
    end
    return false
end

function CoreSystems.ConfigManager:Create(configName)
    self.CurrentConfig = configName
    self:Save(configName)
end

function CoreSystems.ConfigManager:Delete(configName)
    if delfile then
        local path = self.ConfigFolder .. "/" .. configName .. ".json"
        if isfile and isfile(path) then
            pcall(function() delfile(path) end)
        end
    end
end

function CoreSystems.ConfigManager:ExportConfig()
    local dataToSave = {
        Flags = self.Flags,
        QuickToggleLayouts = self.QuickToggleLayouts,
        CustomUserThemes = self.CustomUserThemes
    }
    local jsonStr = HttpService:JSONEncode(dataToSave)

    local success = pcall(function()
        if setclipboard then
            setclipboard(jsonStr)
        elseif toclipboard then
            toclipboard(jsonStr)
        else
            error("Clipboard unsupported")
        end
    end)

    if not success then
        print("[UBHub Export]:\n" .. jsonStr)
        return false
    end
    return true
end

function CoreSystems.ConfigManager:AllConfigs()
	local configs = {}
	if listfiles then
		pcall(function()
			for _, file in pairs(listfiles(self.ConfigFolder)) do
				if file:match("%.json$") then
					local name = file:match("([^/\]+)%.json$")
					if name then table.insert(configs, name) end
				end
			end
		end)
	end
	return configs
end
function CoreSystems.ConfigManager:UpdateFlag(flag, value)
    self.Flags[flag] = value
    if self.Mode == "Legacy" then
        if not self._SaveDebounce then
            self._SaveDebounce = true
            task.delay(1, function()
                self:Save(self.CurrentConfig)
                self._SaveDebounce = false
            end)
        end
    end
end

return CoreSystems
