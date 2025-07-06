-- Example Script for UB-V5-QOL Refactored Library

-- Wait for the game to be ready, especially for services
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--[[
    Loading the UB-V5-QOL Library:
    The line below fetches the library script from its raw GitHub URL and loads it.
    IMPORTANT: Replace "YOUR_RAW_GITHUB_URL_TO_UB-V5-QOL.LUA_HERE" with the actual URL.
]]
local UBHubLib -- Declare UBHubLib
local UB_V5_QOL_URL = "YOUR_RAW_GITHUB_URL_TO_UB-V5-QOL.LUA_HERE" -- <<<!!! IMPORTANT: REPLACE THIS URL !!!>>>

local success, result = pcall(function()
    local httpService = game:GetService("HttpService")
    local scriptSource, httpError = httpService:HttpGetAsync(UB_V5_QOL_URL)
    if not scriptSource then -- Check if HttpGetAsync failed
        error("Failed to fetch UB-V5-QOL.lua from URL: " .. UB_V5_QOL_URL .. "\nError: " .. tostring(httpError))
    end
    local loadedFunction, loadError = loadstring(scriptSource)
    if not loadedFunction then
        error("Failed to loadstring UB-V5-QOL.lua: " .. tostring(loadError))
    end
    local lib = loadedFunction() -- Execute the library code
    if type(lib) ~= "table" then
        error("UB-V5-QOL.lua did not return a table.")
    end
    UBHubLib = lib -- Assign to the outer local variable
end)

if not success then
    warn("Error loading UB-V5-QOL library:", result)
    if syn and syn.protect_gui then syn.protect_gui() end -- Attempt to prevent error UI from breaking
    game.CoreGui:FindFirstChild("UBHubGui"):Destroy() -- Cleanup if any part of UI was made
    error("UB-V5-QOL library loading failed. Cannot continue example script. Error: " .. tostring(result))
    return -- Stop script if library fails
end

if not UBHubLib then
    error("UB-V5-QOL Library failed to load correctly and UBHubLib is nil. This should not happen if pcall was successful.")
    return
end

-- Give the library a moment to fully initialize its own internal components (like fetching its own dependencies)
task.wait(0.5)

-- Main GUI Configuration
local guiConfig = {
    NameHub = "Refactored Hub Test",
    Description = "Showcasing All New Features!",
    Color = Color3.fromRGB(0, 180, 255), -- A distinct accent for the example title bar
    SaveFolder = "UBHubRefactorDemo" -- Unique folder for this example's configs
}
local Window = UBHubLib:MakeGui(guiConfig)

-- Define a custom theme to demonstrate theme switching
local MyDarkTheme = {
    Colors = {
        Primary = Color3.fromRGB(50, 50, 50), -- Darker primary
        Secondary = Color3.fromRGB(70, 70, 70),
        Accent = Color3.fromRGB(0, 150, 220), -- Blue accent
        ThemeHighlight = Color3.fromRGB(0, 180, 255),
        Text = Color3.fromRGB(220, 220, 220),
        Background = Color3.fromRGB(30, 30, 30), -- Dark background
        Stroke = Color3.fromRGB(100, 100, 100),
        TextLight = Color3.fromRGB(200, 200, 200),
        TextVeryLight = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(130, 130, 130),
        TextLocked = Color3.fromRGB(90,90,90),
        BackgroundLight = Color3.fromRGB(45, 45, 45),
        BackgroundTransparent = Color3.fromRGB(30, 30, 30),
        ItemHover = Color3.fromRGB(60, 60, 60),
        InputBackground = Color3.fromRGB(40, 40, 40),
        LockedOverlay = Color3.fromRGB(60,60,60),
        GradientExample = ColorSequence.new({ -- Example gradient
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
        })
    },
    Fonts = { Primary = "GothamBold", Secondary = "SourceSans" }, -- Keep same fonts or customize
    Sizes = Window.CurrentTheme.Sizes -- Reuse default sizes or customize
}

-- Apply the custom theme
Window.CurrentTheme = MyDarkTheme
if Window.ApplyThemeStyleHints then -- Check if function exists before calling
    Window:ApplyThemeStyleHints() -- Apply some immediate visual changes
end
UBHubLib:MakeNotify({Title = "Theme Loaded", Content = "MyDarkTheme has been applied!"})


-- For easy access to ConfigManager and other parts if needed
local ConfigManager = Window.ConfigManager
local FontManager = Window.FontManager
local ExternalIconManager = Window.ExternalIconManager -- Get the new icon manager

--[[
    Core Library Systems Demonstration:
    This example script showcases various features of the UB-V5-QOL library.
    - Font Manager: Handles font registration and usage, applied via themes.
    - Icon Support: The ExternalIconManager provides icons (Lucide & Craft featured).
    - Gradient Support: Demonstrated with ColorSequence in themes.
    - Advanced Color Picker: See the "Customize" tab for theme color adjustments.
    - Enhanced Theming: Apply and customize themes (see "MyDarkTheme" below and "Customize" tab).
    - Configuration System: Save/load UI states (see "Customize" tab).
    - Global UI Features:
        - Top Bar Icons: Search (magnifying glass) and Edit Mode (pencil) are built into the window.
        - Overlays & Effects: Search overlay, blur effects, and quick toggle resize panels are integrated.
    - Tab Layout: Examples include standard tabs, tab dividers, and static tabs (like "Customize").
]]

-- Tab 1: Main Features & Elements
-- This tab demonstrates common UI elements and notification systems.
local Tab1 = Window:CreateTab({ Name = "Main Elements", IconName = "box", IconLibrary = "lucide" })

local Section1_1 = Tab1:AddSection("Basic Elements & Notifications")

Section1_1:AddParagraph({Title = "Theme & Gradient Demo", Content="The UI is now using 'MyDarkTheme'. Below is a frame with a gradient."})
Section1_1:AddFrame({
    Size = UDim2.new(1,0,0,40),
    Color = "GradientExample", -- This key is defined in MyDarkTheme.Colors as a ColorSequence
    LayoutOrder = 0 -- Place it early in the section
})
Section1_1:AddDivider() -- Add a visual separator

-- Enhanced Paragraph
local paragraphButtons = {
    {Text = "Notify Me!", Callback = function() UBHubLib:MakeNotify({ Title = "Paragraph Notify", Description = "Button Clicked!", Time = 0.3, Delay = 3}) end},
    {Text = "Hello", Callback = function() print("Hello from paragraph!") end}
}
Section1_1:AddParagraph({
    Title = "Enhanced Paragraph",
    Content = "This paragraph demonstrates image and button support.",
    IconName = "message-circle", -- Lucide icon name
    IconLibrary = "lucide",
    ImageSize = UDim2.fromOffset(20, 20), -- Keep ImageSize for controlling the ImageLabel's dimensions
    Buttons = paragraphButtons
})

-- Enhanced Notifications
Section1_1:AddButton({
    Title = "One-Time Notification",
    Content = "Shows a notification that only appears once per session.",
    Callback = function()
        UBHubLib:MakeNotify({
            Title = "One-Time Special!",
            Description = "You'll only see me once.",
            Content = "This notification uses the OneTime = true property.",
            Time = 0.5,
            Delay = 7,
            OneTime = true -- Key feature
        })
    end
})
Section1_1:AddButton({
    Title = "Notification with Background",
    Content = "Shows a notification with a custom background image.",
    Callback = function()
        UBHubLib:MakeNotify({
            Title = "Background Art",
            Description = "Pretty, isn't it?",
            Content = "This notification has a BackgroundImage property.",
            BackgroundImage = "rbxassetid://2853002300", -- Example texture
            Time = 0.5,
            Delay = 7
        })
    end
})

local Section1_2 = Tab1:AddSection("Advanced Toggles & Dialogs")
-- Advanced Toggles
Section1_2:AddToggle({
    Title = "Checkbox Style Toggle",
    Content = "This toggle uses Style = 'Checkbox'.",
    Style = "Checkbox",
    Default = false,
    Callback = function(val) print("Checkbox style toggled:", val) end
})
Section1_2:AddToggle({
    Title = "Toggle with Icon (Lucide)",
    Content = "This toggle has a Lucide icon.",
    IconName = "settings",
    IconLibrary = "lucide",
    Default = true,
    Callback = function(val) print("Icon toggle (lucide) toggled:", val) end
})
Section1_2:AddToggle({
    Title = "Toggle with Icon (Craft)",
    Content = "This toggle has a Craft icon.",
    IconName = "Discord", -- Assuming "Discord" is a valid icon name in your craft.lua
    IconLibrary = "craft",
    Default = false,
    Callback = function(val) print("Icon toggle (craft) toggled:", val) end
})

-- Dialog
Section1_2:AddButton({
    Title = "Show Dialog",
    Content = "Opens a dialog with multiple button styles.",
    Callback = function()
        Window:ShowDialog({
            Title = "Example Dialog",
            Content = "This dialog demonstrates Primary, Secondary, and Tertiary buttons. What will you choose?",
            Buttons = {
                {Text = "Confirm Action", Variant = "Primary", Callback = function() print("Dialog: Primary action chosen!") end},
                {Text = "Alternative", Variant = "Secondary", Callback = function() print("Dialog: Secondary action chosen.") end},
                {Text = "Cancel", Variant = "Tertiary", Callback = function() print("Dialog: Tertiary action (Cancel) chosen.") end}
            },
            CloseOnEsc = true
        })
    end
})

Window:AddTabDivider()

-- Tab 2: Conditional Logic & Quick Toggles
-- This tab demonstrates how to make UI elements dependent on the state of others,
-- and how to create on-screen quick toggles for features.
local Tab2 = Window:CreateTab({ Name = "Conditional & Quick Toggles", IconName = "git-fork", IconLibrary = "lucide" })

local Section2_1 = Tab2:AddSection("Dependency System")
local MasterToggle = Section2_1:AddToggle({
    Title = "Master Control Toggle",
    Content = "Controls the visibility and locked state of other elements.",
    Default = true,
    Flag = "MasterToggleState"
})

Section2_1:AddParagraph({ Title = "Dependent Paragraph (Visible)", Content = "This paragraph's visibility depends on Master Control.", Dependency = {Element = MasterToggle, Value = true, Property = "Visible"}})
Section2_1:AddButton({ Title = "Dependent Button (Locked)", Content = "This button is locked/unlocked by Master Control.", Callback = function() print("Dependent button clicked!") end, Dependency = {Element = MasterToggle, Value = false, Property = "Locked"}})
local DependentToggle = Section2_1:AddToggle({ Title = "Dependent Toggle (Visible & Locked)", Content = "Visible if Master is ON, Locked if Master is OFF.", Default = true, Dependency = {Element = MasterToggle, Value = true, Property = "Visible"}})
-- Chained dependency for locked state (will be invisible if master is off, but also locked if master is off and this one is somehow visible)
DependentToggle:AddDependency({Element = MasterToggle, Value = false, Property = "Locked"})


local Section2_2 = Tab2:AddSection("On-Screen Quick Toggles & Edit Mode")
Section2_2:AddParagraph({Title="Quick Toggle Demo", Content="The toggle below can create an on-screen quick toggle. Enable Edit Mode (pencil icon in top bar) to drag/resize it."})

local FeatureA_QuickToggle = Section2_2:AddToggle({
    Title = "Feature A (Quick Toggle-able)",
    Content = "This feature can be controlled by an on-screen button.",
    Default = false,
    CanQuickToggle = true, -- Key feature
    Flag = "FeatureAQuick",
    Callback = function(val)
        print("Feature A (actual feature) toggled:", val)
        UBHubLib:MakeNotify({Title = "Feature A", Content = val and "Enabled" or "Disabled"})
    end
})
local FeatureB_QuickToggle = Section2_2:AddToggle({
    Title = "Feature B (Also Quick Toggle-able)",
    Content = "Another one for dragging and resizing.",
    Default = true,
    CanQuickToggle = true, -- Key feature
    Flag = "FeatureBQuick",
    IconName = "zap",
    IconLibrary = "lucide",
    Callback = function(val)
        print("Feature B (actual feature) toggled:", val)
        UBHubLib:MakeNotify({Title = "Feature B", Content = val and "Activated" or "Deactivated"})
    end
})


-- Tab 3: Advanced Dropdowns & Search Demo (Populate with many items for search)
local Tab3 = Window:CreateTab({ Name = "Advanced UI & Search", IconName = "list-checks", IconLibrary = "lucide" })
local Section3_1 = Tab3:AddSection("Advanced Dropdown")
local dropdownOptions = {}
for i = 1, 15 do
    table.insert(dropdownOptions, "Option " .. string.format("%02d", i))
end
local AdvDropdown = Section3_1:AddDropdown({
    Title = "Prioritized Dropdown",
    Content = "Selected items appear at the top on reopen. Search is also available.",
    Options = dropdownOptions,
    Default = {"Option 03", "Option 07"},
    Multi = true,
    Flag = "AdvancedDropdownDemo",
    Callback = function(val) print("Advanced Dropdown changed:", val) end
})

local Section3_2 = Tab3:AddSection("Items for Search Demo")
for i = 1, 20 do
    local itemType = i % 5
    if itemType == 0 then
        Section3_2:AddToggle({Title = "Searchable Toggle " .. i, Content = "A toggle item for search testing.", Flag = "SearchToggle"..i})
    elseif itemType == 1 then
        Section3_2:AddButton({Title = "Searchable Button " .. i, Content = "A button item for search.", Callback = function() print("Search button " .. i .. " clicked") end})
    elseif itemType == 2 then
        Section3_2:AddSlider({Title = "Searchable Slider " .. i, Content = "A slider for search.", Min=0, Max=100, Default=i*5, Flag = "SearchSlider"..i})
    elseif itemType == 3 then
        Section3_2:AddInput({Title = "Searchable Input " .. i, Content = "Text input for search.", Default="Test"..i, Flag = "SearchInput"..i})
    else
        Section3_2:AddParagraph({Title = "Searchable Paragraph " .. i, Content = "Some text content to test search functionality."})
    end
end

--[[
    Customize Panel (Static Tab):
    This static tab demonstrates configuration management (saving/loading UI settings)
    and theme customization (adjusting colors). Static tabs are always visible at the
    bottom of the tab list and are useful for settings or persistent actions.
]]
local CustomizeTab = Window:AddStaticTab({Name = "Customize", IconName = "settings-2", IconLibrary = "lucide", LayoutOrder = 99})

local ConfigSection = CustomizeTab:AddSection("Configuration Management")

-- ConfigSection:AddLabel({Text = "Config Mode:"}) -- AddLabel doesn't exist, using Paragraph
ConfigSection:AddParagraph({Title = "Config Mode Instruction", Content = "Select configuration behavior."})
local ModeToggle = ConfigSection:AddToggle({
    Title = "Config Mode",
    Content = ConfigManager.Mode == "Legacy" and "Legacy (Saves on change)" or "Normal (Manual save)",
    Default = ConfigManager.Mode == "Legacy",
    Callback = function(val)
        ConfigManager:SetMode(val and "Legacy" or "Normal") -- Use ConfigManager's SetMode
        ModeToggle.Content = ConfigManager.Mode == "Legacy" and "Legacy (Saves on change)" or "Normal (Manual save)" -- Update content string of the toggle object
        ModeToggle:Set(val, true) -- Visually update toggle without re-firing callback
        print("Config Mode set to: " .. ConfigManager.Mode)
        UBHubLib:MakeNotify({Title="Config Mode", Content = "Switched to " .. ConfigManager.Mode .. " mode."})
    end
})
-- Note: ToggleFunc does not have a :SetContent method by default.
-- The above ModeToggle.Content update is a conceptual placeholder.
-- A more robust way would be to have the AddToggle function return an object that allows content update,
-- or re-create/update a separate TextLabel if dynamic content updates are critical.
-- For now, the primary state (Default and visual toggle) will update.

local CurrentConfigInput = ConfigSection:AddInput({
    Title = "Config Name",
    Default = ConfigManager:GetCurrentConfigName() or "default",
    Flag = "_CurrentConfigNameDisplay_Demo" -- Ensure flags are somewhat unique if multiple examples run
})

local ConfigsDropdown -- Forward declare for refresh

ConfigSection:AddButton({
    Title = "Create/Save Config",
    Content="Save current UI settings to the name above.",
    Callback = function()
        local name = CurrentConfigInput.Value
        if name and #name > 0 then
            ConfigManager:SaveConfig(name) -- SaveConfig handles both create and overwrite
            UBHubLib:MakeNotify({Title="Config", Content= "'"..name.."' saved."})
            if ConfigsDropdown then ConfigsDropdown:Refresh(ConfigManager:GetConfigList(), name) end
            ConfigManager:SetCurrentConfigName(name) -- Ensure this is set as current
        else
            UBHubLib:MakeNotify({Title="Config Error", Content= "Config name cannot be empty."})
        end
    end
})

ConfigsDropdown = ConfigSection:AddDropdown({
    Title = "Load Config",
    Options = ConfigManager:GetConfigList(),
    Default = ConfigManager:GetCurrentConfigName(),
    Callback = function(val)
        if val and val ~= "" then
            local success = ConfigManager:LoadConfig(val)
            if success then
                CurrentConfigInput:Set(val)
                UBHubLib:MakeNotify({Title="Config", Content= "'"..val.."' loaded."})
                 -- The UI elements should update based on ConfigManager:ApplyFlagsToUI() called internally by LoadConfig
            else
                UBHubLib:MakeNotify({Title="Config Error", Content= "Failed to load '"..val.."'."})
            end
        end
    end
})

ConfigSection:AddButton({
    Title = "Delete Config",
    Content="Delete the config specified in 'Config Name'.",
    Callback = function()
        local name = CurrentConfigInput.Value
        if name and #name > 0 then
            local success = ConfigManager:DeleteConfig(name)
            if success then
                 UBHubLib:MakeNotify({Title="Config", Content= "'"..name.."' deleted."})
                 local newCurrent = ConfigManager:GetCurrentConfigName() -- May have changed if deleted config was current
                 CurrentConfigInput:Set(newCurrent)
                 if ConfigsDropdown then ConfigsDropdown:Refresh(ConfigManager:GetConfigList(), newCurrent) end
            else
                UBHubLib:MakeNotify({Title="Config Error", Content= "Failed to delete '"..name.."'."})
            end
        else
            UBHubLib:MakeNotify({Title="Config Error", Content= "Config name cannot be empty."})
        end
    end
})
ConfigSection:AddButton({
    Title = "Export to Clipboard",
    Content="Copy current active config to clipboard.",
    Callback = function()
    -- ExportConfig in ConfigManager was designed to take no arguments and export the currently active config's flags
    if ConfigManager:ExportConfig() then -- Adjusted to match ConfigManager's design
        UBHubLib:MakeNotify({Title="Config", Content= "Current active config exported to clipboard."})
    else
        UBHubLib:MakeNotify({Title="Config Error", Content= "Failed to export."})
    end
end})


local ThemingSection = CustomizeTab:AddSection("Theming Engine")
ThemingSection:AddParagraph({Title="Theme Customization", Content="Change theme colors below. Requires 'Normal' config mode and manual save to persist across sessions."})

local themeColorsToEdit = {"Primary", "Secondary", "Accent", "ThemeHighlight", "Text", "Background", "Stroke"}
for _, colorName in ipairs(themeColorsToEdit) do
    ThemingSection:AddColorPicker({
        Title = colorName .. " Color",
        Default = Window.CurrentTheme.Colors[colorName], -- Access CurrentTheme from Window
        Flag = "ThemeColor_"..colorName, -- Save under a specific flag
        Callback = function(newColor)
            Window.CurrentTheme.Colors[colorName] = newColor
            -- TODO: Add a Window:ApplyTheme() function to redraw affected elements or make this live.
            -- For now, some elements might not update until re-interaction.
            print(colorName .. " color changed to:", newColor)
        end
    })
end
-- Example of a ColorSequence for a theme color (if supported by elements)
-- Window.CurrentTheme.Colors.Background = ColorSequence.new({
--     ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,30)),
--     ColorSequenceKeypoint.new(1, Color3.fromRGB(60,60,60))
-- })
-- And then an element would need to check typeof(bgColor) == "ColorSequence"

-- Placeholder for Font selection dropdown if FontManager and Theming are expanded
ThemingSection:AddParagraph({Title="Font Selection", Content="Font selection UI would go here."})


-- Select the first tab by default
Window.SelectTab(Tab1)

print("Example Script Loaded for UB-V5-QOL Refactored")

-- Make the GUI visible if it's hidden by default (depends on library's Show/Hide logic)
-- Assuming there's a ToggleUI method or similar on the Window or a global toggle key like RightShift
-- For now, let's assume it's visible by default or the user knows how to open it.

-- To test search: Click search icon, type "Toggle 5" or "Slider 10"
-- To test edit mode: Click pencil icon, drag/resize a quick toggle.
-- To test configs: Go to Customize, change mode, save/load.
-- To test dependencies: Interact with "Master Control Toggle" in "Conditional & Quick Toggles" tab.
-- To test dialogs: Click "Show Dialog" button.
-- To test advanced dropdown: Select items, close, reopen dropdown in "Advanced UI & Search" tab.
-- To test color picker: Go to Customize -> Theming Engine.

--[[
    Testing Global Window Features:
    - Search: Click the magnifying glass icon (🔍) in the window's top bar.
      Try searching for element titles like "Toggle 5" or "Searchable Slider 10".
    - Edit Mode (for Quick Toggles): Click the pencil icon (✏️) in the window's top bar.
      This allows you to drag and resize any active on-screen Quick Toggles.
      Click the pencil icon again to save their positions and sizes.
    - Minimize/Close: Use the standard window controls on the top bar.
    - Toggle UI Visibility: Press the RightShift key to hide/show the entire UI.
]]

-- Cleanup function for when the script is removed (e.g., in an exploit environment)
script.Destroying:Connect(function()
    if Window and Window.DestroyGui then
        Window:DestroyGui()
    end
    local blur = game:GetService("Lighting"):FindFirstChild("UBHubBlur")
    if blur then
        blur:Destroy()
    end
    print("Example Script Cleaned Up")
end)
