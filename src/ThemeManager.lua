-- ThemeManager.lua
return function(dependencies)
    local FontManager = dependencies.FontManager
    if not FontManager then
        warn("ThemeManager Critical: FontManager dependency not provided!")
        -- Return a dummy ThemeManager or error out, as it's essential
        return {
            GetColor = function() return Color3.new(1,0,1) end,
            GetFont = function() return nil end,
            GetSize = function() return 0 end,
            ApplyFontToElement = function() end,
            AddThemedObject = function() end,
            ApplyThemeToObject = function() end,
            SetTheme = function() end,
            ReapplyCurrentTheme = function() end,
            Themes = {},
            CurrentTheme = { Fonts = {}, Colors = {}, Sizes = {} },
            UpdateThemeColorValue = function() end,
            GetThemeNames = function() return {} end,
        }
    end

    local TweenService = game:GetService("TweenService")
    local ThemeManager = {}

    ThemeManager.Themes = {
    Default = {
        Name = "Default",
        Colors = {
            Primary = Color3.fromRGB(160, 40, 0),
            Secondary = Color3.fromRGB(160, 30, 0),
            Accent = Color3.fromRGB(200, 50, 0),
            ThemeHighlight = Color3.fromRGB(255, 80, 0),
            Text = Color3.fromRGB(255, 240, 230),
            Background = Color3.fromRGB(20, 8, 0),
            Stroke = Color3.fromRGB(80, 20, 0),
            Locked = Color3.fromRGB(100, 100, 100), -- For locked elements
            DialogBackground = Color3.fromRGB(30,12,0), -- Slightly lighter than main BG for dialogs
            InputBackground = Color3.fromRGB(40,16,0), -- For text inputs, dropdowns
            ElementBackground = Color3.fromRGB(30, 12, 0), -- General element background
            ElementHover = Color3.fromRGB(50,20,0), -- Hover state for elements
            Icon = Color3.fromRGB(200,180,170), -- Default icon color
            Scrollbar = Color3.fromRGB(100,50,25),
            -- Gradient example (will be handled by ApplyColorToElement or similar)
            PrimaryGradient = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 40, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 0))
            })
        },
        Fonts = {
            Default = "Default", -- Refers to FontManager's "Default"
            Title = "Default",
            Button = "Default",
            Input = "Default",
            SectionTitle = "Default", -- Example
            Paragraph = "Default",    -- Example
        },
        Sizes = {
            CornerRadius = UDim.new(0, 6),
            SmallCornerRadius = UDim.new(0, 3),
            ButtonHeight = 35,
            InputHeight = 30,
            Padding = UDim.new(0, 10),
            SmallPadding = UDim.new(0, 5),
            StrokeThickness = 1,
            TextSize = 14,
            SmallTextSize = 12,
            TitleTextSize = 16,
            Full = UDim.new(0.5, 0), -- For pill shape corner radius
        }
    },
    -- Add more themes here later, e.g., Light, VapeV4 inspired
}
ThemeManager.CurrentTheme = ThemeManager.Themes.Default
ThemeManager.AllUIObjects = {} -- To store all themed objects for live updates

local function GetDescendantTextElements(parent)
    local textElements = {}
    for _, descendant in ipairs(parent:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
            table.insert(textElements, descendant)
        end
    end
    return textElements
end

function ThemeManager.ApplyFontToElement(element, fontType)
    local fontName = ThemeManager.CurrentTheme.Fonts[fontType] or ThemeManager.CurrentTheme.Fonts.Default
    if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
        FontManager.ApplyFont(element, fontName)
    elseif element:IsA("Frame") then -- Apply to all text descendants if it's a container
        for _, textChild in ipairs(GetDescendantTextElements(element)) do
            FontManager.ApplyFont(textChild, fontName)
        end
    end
end

function ThemeManager.ApplyColorToElement(element, colorType, propertyName)
    propertyName = propertyName or "BackgroundColor3" -- Default property
    local colorValue = ThemeManager.CurrentTheme.Colors[colorType]

    if not colorValue then
        warn("ThemeManager: Color '"..tostring(colorType).."' not found in current theme.")
        return
    end

    if typeof(colorValue) == "Color3" then
        if element[propertyName] ~= colorValue then
             element[propertyName] = colorValue
        end
        -- Remove existing UIGradient if we're setting a flat color
        local oldGradient = element:FindFirstChild("ThemeUIGradient")
        if oldGradient then
            oldGradient:Destroy()
        end
    elseif typeof(colorValue) == "ColorSequence" then
        local gradient = element:FindFirstChild("ThemeUIGradient") or Instance.new("UIGradient")
        gradient.Name = "ThemeUIGradient"
        gradient.Color = colorValue
        gradient.Parent = element
    end
end

function ThemeManager.ApplySizeToElement(element, sizeType, propertyName)
    local sizeValue = ThemeManager.CurrentTheme.Sizes[sizeType]
    if sizeValue == nil then
        warn("ThemeManager.ApplySizeToElement: SizeType '" .. tostring(sizeType) .. "' not found in theme sizes.")
        return
    end

    if propertyName == "CornerRadius" then
        if typeof(sizeValue) == "UDim" then
            local uiCorner = element:FindFirstChildWhichIsA("UICorner")
            if not uiCorner then
                uiCorner = Instance.new("UICorner")
                uiCorner.Parent = element
            end
            if uiCorner.CornerRadius ~= sizeValue then
                uiCorner.CornerRadius = sizeValue
            end
        else
            warn("ThemeManager.ApplySizeToElement: CornerRadius value for sizeType '" .. tostring(sizeType) .. "' is not a UDim. Got: " .. typeof(sizeValue))
        end
    else
        -- Original behavior for other properties
        if element[propertyName] ~= sizeValue then
            element[propertyName] = sizeValue
        end
    end
end


function ThemeManager.GetColor(colorName)
    return ThemeManager.CurrentTheme.Colors[colorName] or Color3.new(1,0,1) -- Magenta fallback for missing
end

function ThemeManager.GetFont(fontType) -- Returns Font object or path
    local fontNameKey = ThemeManager.CurrentTheme.Fonts[fontType] or ThemeManager.CurrentTheme.Fonts.Default
    return FontManager.GetFont(fontNameKey)
end

function ThemeManager.GetSize(sizeName, defaultValue)
    local sizeValue = ThemeManager.CurrentTheme.Sizes[sizeName]
    if sizeValue == nil then
        warn("ThemeManager: Size '" .. tostring(sizeName) .. "' not found in current theme. Using default.")
        -- Provide sensible defaults based on expected type or a generic one
        if defaultValue ~= nil then
            return defaultValue
        elseif type(sizeName) == "string" and (sizeName:lower():match("radius") or sizeName:lower():match("padding")) then
            return UDim.new(0,0) -- Default for UDim based sizes
        elseif type(sizeName) == "string" and sizeName:lower():match("height") then
            return 30 -- Default height
        elseif type(sizeName) == "string" and sizeName:lower():match("width") then
            return 100 -- Default width
        elseif type(sizeName) == "string" and sizeName:lower():match("thickness") then
            return 1 -- Default thickness
        elseif type(sizeName) == "string" and sizeName:lower():match("textsize") then
            return 12 -- Default text size
        else
            return 0 -- Generic numerical default
        end
    end
    return sizeValue
end

function ThemeManager.AddThemedObject(obj, propertiesToTheme)
    -- propertiesToTheme is a table like: {BackgroundColor3 = "Primary", TextColor3 = "Text", FontFace = "ButtonFont"}
    if not ThemeManager.AllUIObjects[obj] then
        ThemeManager.AllUIObjects[obj] = propertiesToTheme
    else -- merge if already exists
        for prop, themeKey in pairs(propertiesToTheme) do
            ThemeManager.AllUIObjects[obj][prop] = themeKey
        end
    end
    ThemeManager.ApplyThemeToObject(obj, propertiesToTheme)
end

function ThemeManager.ApplyThemeToObject(obj, properties)
    for property, themeKey in pairs(properties) do
        if property:lower():match("color") then
            ThemeManager.ApplyColorToElement(obj, themeKey, property)
        elseif property:lower():match("font") then -- e.g. FontFace, Font
            ThemeManager.ApplyFontToElement(obj, themeKey) -- themeKey here is the font type like "Title"
        elseif property:lower():match("size") or property:lower():match("radius") or property:lower():match("padding") or property:lower():match("thickness") then
            ThemeManager.ApplySizeToElement(obj, themeKey, property)
        else
            -- For other properties, assume direct value from theme (e.g. Sizes table)
            local value = ThemeManager.CurrentTheme.Sizes[themeKey] or ThemeManager.CurrentTheme.Colors[themeKey] -- or other theme tables
            if value ~= nil and obj[property] ~= value then
                 obj[property] = value
            end
        end
    end
end


function ThemeManager.UpdateThemeColorValue(colorName, newColor, newTransparency)
    if ThemeManager.CurrentTheme.Colors[colorName] then
        if typeof(newColor) == "Color3" then
            ThemeManager.CurrentTheme.Colors[colorName] = newColor
            -- Transparency is not directly part of Color3, handle separately if needed by elements
        else
            warn("ThemeManager.UpdateThemeColorValue: newColor is not a Color3 value.")
        end
        ThemeManager.ReapplyCurrentTheme() -- Re-apply to all themed objects
    else
        warn("ThemeManager.UpdateThemeColorValue: Color '" .. colorName .. "' does not exist in the current theme.")
    end
end

function ThemeManager.LoadThemes(customThemesTable)
    for themeName, themeData in pairs(customThemesTable) do
        ThemeManager.Themes[themeName] = themeData
    end
end

function ThemeManager.GetThemeNames()
    local names = {}
    for name, _ in pairs(ThemeManager.Themes) do
        table.insert(names, name)
    end
    return names
end

function ThemeManager.SetTheme(themeName)
    if ThemeManager.Themes[themeName] then
        ThemeManager.CurrentTheme = ThemeManager.Themes[themeName]
        ThemeManager.ReapplyCurrentTheme()
        print("Theme set to: " .. themeName)
    else
        warn("ThemeManager: Theme '" .. themeName .. "' not found.")
    end
end

function ThemeManager.ReapplyCurrentTheme()
    for obj, properties in pairs(ThemeManager.AllUIObjects) do
        if obj and obj.Parent then -- Check if object still exists
            ThemeManager.ApplyThemeToObject(obj, properties)
        else
            ThemeManager.AllUIObjects[obj] = nil -- Remove destroyed objects
        end
    end
end

-- Initialize with a default theme if not already set (e.g. if UB-V5-QOL used its own color table)
if not ThemeManager.Themes["Default"] then
    ThemeManager.Themes["Default"] = {
        Name = "Default",
        Colors = { Primary = Color3.new(0,0,0) }, Fonts = { Default = "SourceSans" }, Sizes = { Padding = UDim.new(0,5) }
    }
end
ThemeManager.CurrentTheme = ThemeManager.Themes.Default -- Ensure CurrentTheme is set

return ThemeManager
end
