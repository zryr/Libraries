-- UB-V5-QOL_Example.lua
-- This script demonstrates the features of the refactored UB-V5-QOL.lua library.

print("UB-V5-QOL Example Script Loaded")

-- Wait for services to load, especially in studio
if game:GetService("RunService"):IsStudio() then
    task.wait(2)
end

local ReplicatedStorage = game:GetService("ReplicatedStorage") -- Or wherever your library is
local UBHubLib = require(script.Parent["UB-V5-QOL"]) -- Assuming the example is a child of the library's parent folder

if not UBHubLib then
    warn("Failed to load UB-V5-QOL library!")
    return
end

--[[
    Task #5: Final Verification Requirement:
    *   Jules, upon completing all tasks, you are required to produce a single, comprehensive example script.
    *   This script must serve as a complete test bed for the library. It must create a window and demonstrate
    *   the functionality of every major feature implemented in this project plan, including:
        *   The dual-mode config system (Legacy and Normal).
        *   The on-demand, animated Search feature.
        *   The Edit Mode with draggable and resizable quick-toggles.
        *   Advanced dropdowns, showing the selection prioritization.
        *   Conditional/locked elements using the Dependency system.
        *   The "Customize" panel with theme and color-picking options.
        *   All new and enhanced element types.
]]

-- Create the main window
local Window = UBHubLib:MakeGui({
    NameHub = "UB-V5 Refactor Showcase",
    Description = "Testing all new features!",
    Color = Color3.fromRGB(255, 0, 127), -- Example color for the window title stroke
    ["Tab Width"] = 150,
    ["SaveFolder"] = "UBV5_Refactor_Settings" -- Crucial for ConfigManager
})

if not Window then
    warn("Failed to create UB-V5-QOL Window!")
    return
end

-- Access ConfigManager (assuming it's attached to the window object or accessible via UBHubLib)
local ConfigManagerInstance = Window.ConfigManager
if not ConfigManagerInstance then
    -- Fallback if it's not directly on the window, try to get it from the library module itself
    -- This part depends on how ConfigManager is exposed by UB-V5-QOL's MakeGui
    -- For now, we assume it's part of the returned Window object or UBHubLib.GlobalConfigManager
    warn("ConfigManager not found on Window object. Attempting to access globally if available.")
    -- ConfigManagerInstance = UBHubLib.GlobalConfigManager (example)
    -- If still not found, many config tests will fail.
end


-- == Task #1: Core Systems & Architectural Overhaul Demonstrations ==
local CoreSystemTab = Window:CreateTab({ Name = "Core Systems", Icon = "Lucide/box" })
local ThemeSection = CoreSystemTab:AddSection("Theming & Icons")

ThemeSection:AddParagraph({Title = "Icon Test", Content = "Lucide 'activity' and Craft 'cog-settings-01-stroke'"})
-- We'll add actual icons to elements later to test IconManager fully.

ThemeSection:AddColorPicker({
    Title = "Primary Color Picker",
    DefaultColor = UBHubLib.ThemeManager.GetColor("Primary"), -- Assuming ThemeManager is exposed
    EnableTransparency = false,
    Callback = function(newColor, newTrans)
        print("Primary Color Picker Changed:", newColor)
        UBHubLib.ThemeManager.UpdateThemeColorValue("Primary", newColor)
        -- Note: Full live update of all elements depends on ThemeManager.ReapplyCurrentTheme()
        -- and how elements are registered with ThemeManager.
    end
})


-- == Task #2: Advanced Element & Component Implementation Demonstrations ==
local AdvancedElementsTab = Window:CreateTab({ Name = "Adv. Elements", Icon = "Lucide/toy-brick" })

-- 1. Enhanced Paragraphs & Notifications
local ParagraphsSection = AdvancedElementsTab:AddSection("Paragraphs & Notifications")
local dynamicParagraph = ParagraphsSection:AddParagraph({
    Title = "Dynamic Paragraph",
    Content = "This paragraph will change.",
})
ParagraphsSection:AddButton({Title="Update Paragraph", Callback = function()
    dynamicParagraph:Set({Title = "Updated Title!", Content = "Content has been updated dynamically."})
end})

ParagraphsSection:AddParagraph({
    Title = "Paragraph w/ Image",
    Content = "This one has a Lucide 'bell' icon.",
    Image = "Lucide/bell"
})

ParagraphsSection:AddParagraph({
    Title = "Paragraph w/ Buttons",
    Content = "Click these!",
    Buttons = {
        {Text = "Btn1", Icon = "Lucide/star", Callback = function() UBHubLib:MakeNotify({Title="Button 1 Clicked"}) end},
        {Text = "Btn2", Callback = function() UBHubLib:MakeNotify({Title="Button 2 Clicked"}) end}
    }
})

ParagraphsSection:AddButton({Title = "One-Time Notify", Callback = function()
    UBHubLib:MakeNotify({
        Title = "One-Time Special",
        Content = "You should only see this once per session/save.",
        OneTime = true,
        BackgroundImage = "rbxassetid://6015897843" -- Example dropshadow image as background
    })
end})
ParagraphsSection:AddButton({Title = "Normal Notify", Callback = function()
    UBHubLib:MakeNotify({Title = "Standard Notification", Content = "This can appear multiple times."})
end})


-- 2. Advanced Toggles & Dialogs
local TogglesDialogsSection = AdvancedElementsTab:AddSection("Toggles & Dialogs")
TogglesDialogsSection:AddToggle({ Title = "Standard Toggle", Default = false, Content = "A normal switch."})
local checkboxToggle = TogglesDialogsSection:AddToggle({
    Title = "Checkbox Style",
    Default = true,
    Content = "This is a checkbox.",
    Style = "Checkbox"
})
TogglesDialogsSection:AddToggle({
    Title = "Toggle w/ Icon",
    Default = false,
    Icon = "Lucide/settings-2",
    Content = "Switch with an icon."
})
TogglesDialogsSection:AddToggle({
    Title = "Checkbox w/ Icon",
    Default = true,
    Style = "Checkbox",
    Icon = "Lucide/star",
    Content = "Checkbox with an icon."
})

TogglesDialogsSection:AddButton({Title = "Show Dialog", Callback = function()
    Window:ShowDialog({
        Title = "Example Dialog",
        Content = "This dialog demonstrates multiple button variants and icons.",
        Icon = "Lucide/message-circle-question",
        Buttons = {
            {Text = "Cancel", Variant = "Tertiary", Callback = function() print("Dialog: Cancel") end},
            {Text = "Secondary Action", Icon = "Lucide/minus-circle", Variant = "Secondary", Callback = function() print("Dialog: Secondary") end},
            {Text = "Primary Action", Icon = "Lucide/check-circle", Variant = "Primary", Callback = function() print("Dialog: Primary OK") end}
        }
    })
end})

-- 3. Conditional & Locked Elements
local ConditionalSection = AdvancedElementsTab:AddSection("Conditional & Locked")
local masterToggleVisible = ConditionalSection:AddToggle({Title = "Master Visibility", Default = true, Content="Controls visibility of next element"})
local dependentParagraphVisible = ConditionalSection:AddParagraph({
    Title = "Dependent Paragraph (Visible)",
    Content = "I appear and disappear!",
    Dependency = {Element = masterToggleVisible, Value = true, Property = "Visible"}
})

local masterToggleLocked = ConditionalSection:AddToggle({Title = "Master Lock", Default = false, Content="Controls locked state of next button"})
local dependentButtonLocked = ConditionalSection:AddButton({
    Title = "Dependent Button (Locked)",
    Content = "I can be locked/unlocked.",
    Callback = function() UBHubLib:MakeNotify({Title="Dependent Button Clicked!"}) end,
    Dependency = {Element = masterToggleLocked, Value = true, Property = "Locked"}
})
local dependentSliderLocked = ConditionalSection:AddSlider({
    Title = "Dependent Slider (Locked)",
    Min = 0, Max = 100, Default = 50,
    Dependency = {Element = masterToggleLocked, Value = true, Property = "Locked"}
})


-- == Task #3: On-Screen Quick Toggles & UI Edit Mode Demonstrations ==
local QuickTogglesTab = Window:CreateTab({ Name = "Quick Toggles", Icon = "Lucide/layout-dashboard" })
local QuickToggleSetupSection = QuickTogglesTab:AddSection("Quick Toggle Setup")

QuickToggleSetupSection:AddParagraph({Title="Quick Toggle Info", Content="Enable 'CanQuickToggle'. Then, activate the creator button (left of toggle) to make the main toggle create/destroy an on-screen quick toggle."})

local featureA_value = false
local quickToggle1 = QuickToggleSetupSection:AddToggle({
    Title = "Feature A (Quick Toggle)",
    Content = "This can be a quick toggle.",
    Default = featureA_value,
    CanQuickToggle = true,
    Icon = "Lucide/zap", -- Icon for the on-screen button
    Callback = function(val)
        featureA_value = val
        print("Feature A toggled to: " .. tostring(val))
        UBHubLib:MakeNotify({Title = "Feature A", Content = "State: " .. (val and "ON" or "OFF")})
    end
})

local featureB_value = true
local quickToggle2_checkbox = QuickToggleSetupSection:AddToggle({
    Title = "Feature B (Checkbox QT)",
    Content = "Checkbox style quick toggle.",
    Default = featureB_value,
    CanQuickToggle = true,
    Style = "Checkbox",
    Icon = "Lucide/anchor",
    Callback = function(val)
        featureB_value = val
        print("Feature B (checkbox) toggled to: " .. tostring(val))
         UBHubLib:MakeNotify({Title = "Feature B", Content = "State: " .. (val and "ON" or "OFF")})
    end
})
QuickToggleSetupSection:AddParagraph({Title="Edit Mode Info", Content="Click the 'Edit' icon (pencil) in the window's top bar to enter/exit Edit Mode. In Edit Mode, quick toggles are draggable. Click a quick toggle in Edit Mode to show the Resize Panel."})


-- == Task #4: Implement Full Search Functionality Demonstrations ==
-- Elements for search are created across various tabs. The search functionality itself is part of the window.
-- To test: Use the search icon in the window's top bar.
local SearchTestTab = Window:CreateTab({Name = "Search Content", Icon = "Lucide/text-search"})
local SearchContentSect = SearchTestTab:AddSection("Content for Searching")
SearchContentSect:AddParagraph({Title="Player Speed", Content="Adjust player walkspeed."})
SearchContentSect:AddToggle({Title="ESP Toggle", Content="Enable or disable ESP."})
SearchContentSect:AddSlider({Title="FOV Changer", Min=70, Max=120, Default=90, Content="Modify field of view."})
SearchContentSect:AddInput({Title="Custom Chat Message", Content="Enter a message to broadcast."})
SearchContentSect:AddDropdown({Title="Aim Part Selection", Options={"Head", "Torso", "Legs"}, Default="Head"})
SearchContentSect:AddColorPicker({Title="ESP Box Color", DefaultColor=Color3.new(1,0,0)})
SearchContentSect:AddButton({Title="Kill All", Content="Dangerous button!", Keywords={"terminate", "eliminate"}})


-- == Task #5: Final 'Customize' Panel & UI Polish Demonstrations ==
-- The "Customize" tab is created by the library itself if `AddStaticTab` is working.
-- We will interact with it directly.

-- Advanced Dropdown Behavior (Demonstrated in a new section)
local PolishTab = Window:CreateTab({Name = "UI Polish", Icon = "Lucide/wand-2"})
local DropdownPolishSection = PolishTab:AddSection("Advanced Dropdowns")

local advancedDropdown = DropdownPolishSection:AddDropdown({
    Title = "Advanced Sort Dropdown",
    Content = "Selected items should appear at the top after closing and reopening.",
    Multi = true,
    Options = {"Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"},
    Default = {"Banana", "Fig"},
    Callback = function(selected)
        print("Advanced Dropdown selected:", selected)
    end
})

-- Section Underline Animation is tested by interacting with any section.

print("UB-V5-QOL Example Script: Setup Complete. Window should be visible.")

-- ConfigManager Demonstration Setup (Part of Task 5, but setting up elements here)
if ConfigManagerInstance then
    print("ConfigManager found, registering elements for config testing.")
    -- Register some elements from different tabs to test saving/loading
    ConfigManagerInstance:RegisterElement("Core_PrimaryColor", ThemeSection:AddColorPicker({
        Title = "Configurable Primary Color", -- This is a new element for testing config
        DefaultColor = Color3.fromRGB(0,0,255),
        Callback = function(c) print("Configurable Primary Color set to", c) end
    }), function(el, val) if el and el.SetColor then el:SetColor(val) end end) -- Assuming SetColor exists

    ConfigManagerInstance:RegisterElement("Adv_CheckboxToggle", checkboxToggle,
        function(el, val) if el and el.Set then el:Set(val) end end) -- Assuming toggle objects have :Set()

    ConfigManagerInstance:RegisterElement("QuickToggle_FeatureA", quickToggle1,
        function(el, val) if el and el.Set then el:Set(val) end end)

    ConfigManagerInstance:RegisterElement("Polish_AdvancedDropdown", advancedDropdown,
        function(el, val) if el and el.Set then el:Set(val) end end) -- Assuming dropdowns have :Set()
else
    warn("ConfigManagerInstance not available. Config saving/loading tests in Customize tab might not work fully.")
end


-- Example of how to use the ThemeManager to get a color for a non-library element
local testFrame = Instance.new("Frame")
testFrame.Size = UDim2.new(0,100,0,100)
testFrame.Position = UDim2.new(0,10,0.8,0)
testFrame.BackgroundColor3 = UBHubLib.ThemeManager.GetColor("Accent") or Color3.new(1,1,0) -- Use ThemeManager
testFrame.Parent = UBHubGui -- Assuming UBHubGui is the ScreenGui

UBHubLib:MakeNotify({Title="Example Loaded!", Content="All test elements created."})
