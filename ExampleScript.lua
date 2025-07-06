-- Example Script for UB-V5-QOL Refactored Library

-- Wait for the game to be ready, especially for services
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Assuming the library is placed in ReplicatedStorage and named UB-V5-QOL
local UBHubLib = require(ReplicatedStorage:WaitForChild("UB-V5-QOL"))

-- Give the library a moment to fully initialize its own internal components if needed
task.wait(0.5)

-- Main GUI Configuration
local guiConfig = {
    NameHub = "Refactored Hub Test",
    Description = "Showcasing All New Features!",
    Color = Color3.fromRGB(0, 180, 255), -- A distinct accent for the example
    SaveFolder = "UBHubRefactorDemo" -- Unique folder for this example's configs
}
local Window = UBHubLib:MakeGui(guiConfig)

-- For easy access to ConfigManager and other parts if needed
local ConfigManager = Window.ConfigManager -- Assuming ConfigManager is attached to Window object
local FontManager = Window.FontManager -- Assuming FontManager is available
local IconManager = Window.IconManager -- Assuming IconManager is available


--[[
    Task #1: Core Systems & Architectural Overhaul
    - Font Manager: Implicitly used by all text. We'll add a font demonstration in Customize.
    - Icon Support (Lucide & Craft): We'll use Lucide icons.
    - Gradient Support: Will be shown in Theming via ColorSequences.
    - Advanced Color Picker Element: Will be added to Customize tab.
    - Enhanced Theming: Will be demonstrated in Customize tab.
    - Dual-Mode Config System: UI will be in Customize tab.
    - Top Bar Icons: Search & Edit are part of the Window.
    - Overlays & Effects: SearchOverlay, BlurEffect, ResizePanel are part of the Window.
    - Tab Layout: AddTabDivider, AddStaticTab.
]]

-- Tab 1: Main Features & Elements
local Tab1 = Window:CreateTab({ Name = "Main Elements", Icon = IconManager:GetIcon("lucide", "box", 16)?.Url or "" })

local Section1_1 = Tab1:AddSection("Basic Elements & Notifications")

-- Enhanced Paragraph
local paragraphButtons = {
    {Text = "Notify Me!", Callback = function() UBHubLib:MakeNotify({ Title = "Paragraph Notify", Description = "Button Clicked!", Time = 0.3, Delay = 3}) end},
    {Text = "Hello", Callback = function() print("Hello from paragraph!") end}
}
local paragraphIcon = IconManager:GetIcon("lucide", "message-circle", 20)
Section1_1:AddParagraph({
    Title = "Enhanced Paragraph",
    Content = "This paragraph demonstrates image and button support.",
    Image = paragraphIcon?.Url, -- Optional image
    ImageSize = UDim2.fromOffset(paragraphIcon and 20 or 0, paragraphIcon and 20 or 0),
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
local toggleIcon = IconManager:GetIcon("lucide", "settings", 16)
Section1_2:AddToggle({
    Title = "Toggle with Icon",
    Content = "This toggle has an icon property.",
    Icon = toggleIcon?.Url,
    Default = true,
    Callback = function(val) print("Icon toggle toggled:", val) end
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
local Tab2 = Window:CreateTab({ Name = "Conditional & Quick Toggles", Icon = IconManager:GetIcon("lucide", "git-fork", 16)?.Url or "" })

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
    Icon = IconManager:GetIcon("lucide", "zap", 16)?.Url,
    Callback = function(val)
        print("Feature B (actual feature) toggled:", val)
        UBHubLib:MakeNotify({Title = "Feature B", Content = val and "Activated" or "Deactivated"})
    end
})


-- Tab 3: Advanced Dropdowns & Search Demo (Populate with many items for search)
local Tab3 = Window:CreateTab({ Name = "Advanced UI & Search", Icon = IconManager:GetIcon("lucide", "list-checks", 16)?.Url or "" })
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
    Task #5: Final 'Customize' Panel & UI Polish
    - Create SettingsPage Frame & Implement View-Switching (Done by static tab)
    - Populate SettingsPage using library's own API:
        - Section: "Configuration"
        - Section: "Theming"
    - Final UX Polish:
        - Advanced Dropdown Behavior (Implemented in AddDropdown)
        - Section Underline Animation (Part of Section open/close)
]]
local CustomizeTab = Window:AddStaticTab({Name = "Customize", Icon = IconManager:GetIcon("lucide", "settings-2", 16)?.Url or "", LayoutOrder = 99})

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
