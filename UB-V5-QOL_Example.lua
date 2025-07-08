-- Comprehensive Example Script for UB-V5-QOL Library Refactor

print("UB-V5-QOL Example Script Loaded")

-- Wait for the game to be fully loaded (especially for services)
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Assuming the library is a child of this script or in a known location
-- Load the library from the specified GitHub URL
local LibraryURL = "https://raw.githubusercontent.com/zryr/Libraries/refs/heads/Jully/UB-V5-QOL.lua"
local success, libraryModule = pcall(function()
    return loadstring(game:HttpGet(LibraryURL))()
end)

if not success or not libraryModule then
    warn("Failed to load UB-V5-QOL library from URL. Error:", libraryModule)
    -- Fallback or error handling if needed, for now, script might not function fully.
    -- For testing, you might want a local require as a fallback:
    -- UBHubLib = require(script.Parent["UB-V5-QOL"])
    return
end

local UBHubLib = libraryModule

-- Access managers exposed by UBHubLib
local ThemeManager = UBHubLib.ThemeManager
local FontManager = UBHubLib.FontManager
local IconManager = UBHubLib.IconManager
-- ConfigManager is typically used via window.ConfigManager or UBHubLib.ConfigManager (instance)

if not ThemeManager then warn("Example Script: ThemeManager not found on UBHubLib!") end
if not FontManager then warn("Example Script: FontManager not found on UBHubLib!") end
if not IconManager then warn("Example Script: IconManager not found on UBHubLib!") end

--[[
    Task #5, Step 4: Final Verification Requirement:
    Produce a single, comprehensive example script. This script must serve as a
    complete test bed for the library. It must create a window and demonstrate
    the functionality of every major feature implemented in this project plan.
]]

-- Register a custom font (optional, for demonstration)
-- FontManager.RegisterFont("ComicSans", "rbxassetid://FONT_ID_HERE") -- Replace with an actual font ID if desired

-- Create the main window
local window = UBHubLib:MakeGui({
    NameHub = "UBV5 Refactor Showcase",
    Description = "Demonstrating new features",
    Size = UDim2.fromOffset(600, 450),
    -- SaveFolder will use the default "UBV5_Settings"
})

-- Access the window's specific ConfigManager
local windowConfig = window.ConfigManager
if not windowConfig then
    warn("Example: Could not get window.ConfigManager. Some features might not save/load correctly.")
    -- Create a dummy if needed for the script to run without erroring further
    windowConfig = {
        SaveSetting = function(k,v) print("Dummy SaveSetting:",k,v) end,
        LoadSetting = function(k,d) print("Dummy LoadSetting:",k); return d end,
        RegisterElement = function() end,
        SetMode = function() end,
        CreateConfig = function() end,
        LoadConfig = function() end,
        DeleteConfig = function() end,
        ExportConfig = function() end,
		_PersistFlags = function() end,
    }
end


-- == Section: Main Features & Elements ==
local mainTab = window:CreateTab({Name = "Main Demo", Icon = "home"})
local sectionFeatures = mainTab:AddSection("Core Features & Elements")

-- Paragraph with Image and Buttons
sectionFeatures:AddParagraph({
    Title = "Enhanced Paragraph",
    Content = "This paragraph demonstrates support for an optional icon and buttons below the content. Great for important messages or calls to action.",
    Image = "info", -- Lucide icon name
    ImageLib = "Lucide",
    Buttons = {
        {Text = "More Info", Callback = function() print("More Info button clicked!") end},
        {Text = "Dismiss", Callback = function() print("Dismiss button clicked!") end}
    }
})

sectionFeatures:AddDivider()

-- Advanced Toggles (Switch and Checkbox)
local mainToggle = sectionFeatures:AddToggle({
    Title = "Main Feature Toggle (Switch)",
    Default = false,
    Flag = "MainFeatureToggle",
    Icon = "power",
    CanQuickToggle = true, -- Enable quick toggle creation
    Callback = function(value)
        print("Main Feature Toggle changed to:", value)
        UBHubLib:MakeNotify({Title = "Main Toggle", Content = "State: " .. tostring(value)})
    end
})

local checkboxToggle = sectionFeatures:AddToggle({
    Title = "Checkbox Style Toggle",
    Default = true,
    Style = "Checkbox",
    Flag = "CheckboxFeature",
    Icon = "check-square",
    Callback = function(value)
        print("Checkbox Feature changed to:", value)
    end
})
sectionFeatures:AddDivider()

-- Slider
local exampleSlider = sectionFeatures:AddSlider({
    Title = "Example Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Round = true,
    Suffix = "%",
    Icon = "sliders-horizontal",
    Flag = "ExampleSliderValue",
    Callback = function(value)
        print("Slider value changed to:", value)
    end
})

-- Input
local exampleInput = sectionFeatures:AddInput({
    Title = "Text Input",
    Default = "Hello World",
    Placeholder = "Enter some text...",
    Icon = "edit-3",
    Flag = "ExampleInputValue",
    Callback = function(value)
        print("Input value changed to:", value)
    end
})
sectionFeatures:AddDivider()

-- Dropdown (Advanced behavior will be tested by opening/closing)
local exampleDropdown = sectionFeatures:AddDropdown({
    Title = "Select Option(s)",
    MultiSelect = true,
    Icon = "chevron-down",
    Flag = "ExampleDropdownValue",
    Options = {
        {Name = "Option Alpha", Value = "alpha", Icon = "a-large-small"},
        {Name = "Option Beta", Value = "beta", Icon = "b-large-small"},
        {Name = "Option Gamma", Value = "gamma", Icon = "greek-cross"},
        {Name = "Option Delta", Value = "delta", Icon = "delta"},
        {Name = "Option Epsilon", Value = "epsilon", Icon = "pilcrow"},
        {Name = "Another Option", Value = "another"},
        {Name = "Yet Another", Value = "yetanother", Icon = "star"},
    },
    Default = {"beta", "delta"}, -- Default selected for multi-select
    Callback = function(value)
        print("Dropdown value changed to:")
        for _, v in pairs(value) do print("- ", v) end
    end
})

-- Color Picker Button
local exampleColorPicker = sectionFeatures:AddColorPicker({
    Title = "Choose Accent Color",
    Default = ThemeManager.GetColor("Accent") or Color3.fromRGB(255,80,0),
    Flag = "ExampleAccentColor", -- Will be saved as {R,G,B,A} table
    Callback = function(color, alpha)
        print("Color Picker changed to:", color, "Alpha:", alpha)
        -- Example of using it to change a theme color live
        ThemeManager.UpdateThemeColorValue("Accent", color)
        -- Note: Alpha from color picker isn't directly used by UpdateThemeColorValue which expects Color3
        -- If elements need transparency, it should be handled by their specific properties.
    end
})


-- == Section: Conditional Logic & Dependencies ==
local dependencySection = mainTab:AddSection("Dependencies & Conditional UI")

local conditionToggle = dependencySection:AddToggle({
    Title = "Enable Dependent Elements",
    Default = false,
    Flag = "ConditionToggle",
    Icon = "toggle-left"
})

dependencySection:AddParagraph({ Content = "The elements below depend on the toggle above."})

local dependentButton = dependencySection:AddButton({
    Title = "Visible if Toggle is ON",
    Icon = "eye",
    Callback = function() print("Dependent Button Clicked!") end,
    Dependency = {
        Element = conditionToggle, -- The toggle object itself
        Value = true,              -- Condition: Toggle must be true
        Property = "Visible"       -- Property to affect: Visibility
    }
})

local dependentInput = dependencySection:AddInput({
    Title = "Locked if Toggle is ON",
    Placeholder = "Cannot edit when locked",
    Icon = "lock",
    Dependency = {
        Element = conditionToggle,
        Value = true,
        Property = "Locked"
    }
})

local dependentSlider = dependencySection:AddSlider({
    Title = "Visible & Unlocked if Toggle is OFF",
    Icon = "activity",
    Dependency = { -- This will be visible when conditionToggle is false
        Element = conditionToggle,
        Value = false,
        Property = "Visible"
    }
    -- To make it also unlocked when toggle is OFF, you'd add another dependency or chain it.
    -- For simplicity, only showing visibility dependency here.
    -- A more complex scenario might involve a second invisible toggle that this one depends on for lock state,
    -- and that second toggle depends on the first one with an inverted value.
})


-- == Section: Dialogs & Notifications ==
local dialogsSection = mainTab:AddSection("Dialogs & Notifications")

dialogsSection:AddButton({
    Title = "Show Standard Dialog",
    Icon = "message-square",
    Callback = function()
        window:ShowDialog({
            Title = "Standard Dialog",
            Content = "This is a standard dialog with multiple button variants.",
            Buttons = {
                {Text = "Cancel", Variant = "Tertiary", Callback = function() print("Dialog: Cancelled") end},
                {Text = "Secondary Action", Variant = "Secondary", Callback = function() print("Dialog: Secondary action") end},
                {Text = "Confirm OK", Variant = "Primary", Callback = function() print("Dialog: Confirmed OK") end}
            },
            OnClose = function() print("Dialog was closed.") end
        })
    end
})

dialogsSection:AddButton({
    Title = "Show One-Time Notify",
    Icon = "bell",
    Callback = function()
        UBHubLib:MakeNotify({
            Title = "One-Time Offer!",
            Content = "This notification will only appear once per session thanks to OneTime = true.",
            Delay = 7,
            OneTime = true,
            OneTimeId = "SpecialOfferNotify_v1" -- Unique ID for this specific one-time message
        })
    end
})

dialogsSection:AddButton({
    Title = "Show Notify with BG Image",
    Icon = "image",
    Callback = function()
        UBHubLib:MakeNotify({
            Title = "Image Background",
            Content = "This notification has a custom background image (placeholder asset).",
            BackgroundImage = "rbxassetid://266543268" -- Placeholder image, use a real one
        })
    end
})


-- == Section: Edit Mode & Quick Toggles ==
-- This section is primarily to show that toggles with "CanQuickToggle" exist.
-- The actual Edit Mode is controlled by the top-bar Edit icon.
local quickToggleSection = mainTab:AddSection("Quick Toggles (Test with Edit Mode)")

quickToggleSection:AddParagraph({Content = "Enable 'CanQuickToggle' on toggles. Then, click the 'creator' icon next to the toggle (a small plus/check). After that, the main toggle switch will create/destroy an on-screen button. Activate Edit Mode (pencil icon in top bar) to drag these on-screen buttons."})

quickToggleSection:AddToggle({Title = "Draggable Feature A", CanQuickToggle = true, Flag = "QTA", Icon="mouse-pointer-2"})
quickToggleSection:AddToggle({Title = "Draggable Feature B", Style="Checkbox", CanQuickToggle = true, Flag = "QTB", Icon="move"})


-- == Section: Configuration Management (Demonstration) ==
-- The "Customize" tab will eventually house the UI for this.
-- This section demonstrates programmatic interaction.
local configDemoSection = mainTab:AddSection("Config Management (Programmatic)")

configDemoSection:AddParagraph({Content = "Use the 'Customize' tab (once implemented) for UI-based config management. Below are programmatic tests."})

configDemoSection:AddButton({Title = "Set ConfigMode: Normal", Callback = function() windowConfig:SetMode("Normal"); UBHubLib:MakeNotify({Title="Config", Content="Mode set to Normal. Save manually."}) end})
configDemoSection:AddButton({Title = "Set ConfigMode: Legacy", Callback = function() windowConfig:SetMode("Legacy"); UBHubLib:MakeNotify({Title="Config", Content="Mode set to Legacy. Auto-saves."}) end})

configDemoSection:AddButton({Title = "Save Config 'MySettings'", Callback = function()
    if windowConfig.CurrentMode == "Normal" then
        windowConfig:SaveConfig("MySettings")
        UBHubLib:MakeNotify({Title="Config", Content="'MySettings' saved."})
    else
        UBHubLib:MakeNotify({Title="Config Error", Content="Switch to Normal mode to use SaveConfig."})
    end
end})

configDemoSection:AddButton({Title = "Load Config 'MySettings'", Callback = function()
    windowConfig:LoadConfig("MySettings")
    UBHubLib:MakeNotify({Title="Config", Content="'MySettings' loaded."})
    -- UI elements should update automatically if registered with ConfigManager
end})

configDemoSection:AddButton({Title = "Export Current Config", Callback = function()
    local success = windowConfig:ExportConfig()
    if success then
        UBHubLib:MakeNotify({Title="Config", Content="Current config copied to clipboard!"})
    else
        UBHubLib:MakeNotify({Title="Config Error", Content="Failed to copy config."})
    end
end})


-- == Section: Search & Customize Placeholders ==
-- These tasks are pending full implementation, but their UI entry points can be shown.
local pendingSection = mainTab:AddSection("Pending Features (UI Shells)")
pendingSection:AddParagraph({Content = "Search button is in the top bar. The 'Customize' tab is below."})


-- == Static Tab: Customize (Placeholder Content) ==
local customizeTab = window:AddStaticTab({Name = "Customize", Icon = "settings-2"})
local customizeSection = customizeTab:AddSection("UI Customization")

customizeSection:AddParagraph({
    Title = "Configuration & Theming",
    Content = "This area will allow you to manage saved configurations (Create, Load, Delete, Overwrite, Export) and switch between 'Normal' and 'Legacy' save modes. You will also be able to select themes and customize theme colors here using the advanced color picker."
})
customizeSection:AddParagraph({
    Title = "NOTE:",
    Content = "The UI for these settings is part of Task #5 and is not yet implemented in this example version. The 'Config Management (Programmatic)' section demonstrates some of the underlying ConfigManager API."
})


-- Make the first tab active by default
-- This logic might be internal to MakeGui, but explicit activation can be useful.
-- (Assuming MakeGui already makes the first created non-static tab active)

print("UB-V5-QOL Example Script Finished Setup")

-- Example of how to make the window draggable by its top bar
-- MakeDraggable is an internal function, but if exposed or if Main.TopBar is accessible:
-- if UBHubLib.WindowObject and UBHubLib.WindowObject:FindFirstChild("TopBar") then
--    MakeDraggable(UBHubLib.WindowObject.TopBar, UBHubLib.WindowObject.Parent.Parent) -- Drags DropShadowHolder
-- end

-- Test notification
task.wait(1)
UBHubLib:MakeNotify({
    Title = "Library Ready!",
    Content = "UB-V5 QOL Refactor example is up and running.",
    Delay = 7
})

-- Demonstrate Gradient Support
local gradientSection = mainTab:AddSection("Gradient Demonstration")
local gradientFrame = Instance.new("Frame")
gradientFrame.Size = UDim2.new(1, -10, 0, 50)
gradientFrame.Position = UDim2.new(0,5,0,0)
gradientFrame.Parent = gradientSection -- This is not how AddSection works. Items are added via itemsTable:Add...
-- Let's add it properly using a dummy paragraph to get the section's content frame,
-- or ideally, AddSection would return the content frame or an Items table directly.
-- For now, creating a dummy item to get parent.
local tempParentForGradient = gradientSection:AddParagraph({Title="", Content=""}).Object.Parent -- Get SectionContent frame

gradientFrame.Parent = tempParentForGradient
ThemeManager.AddThemedObject(gradientFrame, {
    BackgroundColor3 = "PrimaryGradient", -- This should be a ColorSequence in the theme
    CornerRadius = "SmallCornerRadius"
})
gradientSection:AddParagraph({Title="Gradient Frame", Content="The frame above should have a gradient if 'PrimaryGradient' is a ColorSequence in the theme."})

-- Ensure PrimaryGradient exists in the default theme for testing
if not ThemeManager.Themes.Default.Colors.PrimaryGradient then
	ThemeManager.Themes.Default.Colors.PrimaryGradient = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 40, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 50, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 0))
	})
	ThemeManager.ReapplyCurrentTheme() -- Re-apply if added dynamically
end
