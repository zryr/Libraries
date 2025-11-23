local Library = loadfile("UB-V5-Refactor.lua")()

local Window = Library:CreateWindow({
    Title = "UB V5 Refactor Showcase",
    Author = "Jules",
    Icon = "rbxassetid://123456789", -- Placeholder
    IconLibrary = "Lucide",
    Folder = "UBShowcase"
})

-- Tab 1: Core Elements
local CoreTab = Window:AddTab({ Name = "Core Elements", Icon = "home" })

CoreTab:AddSection("Basic Inputs")

CoreTab:AddParagraph({
    Title = "Welcome",
    Content = "This showcase demonstrates the refactored UB-V5 library features, including WindUI-inspired styling, search, and edit mode."
})

CoreTab:AddButton({
    Title = "Test Notification",
    Callback = function()
        Library:Notify({
            Title = "Hello!",
            Content = "This is a test notification with a custom icon.",
            Duration = 3,
            Icon = "bell"
        })
    end
})

CoreTab:AddToggle({
    Title = "Standard Toggle",
    Default = false,
    Callback = function(v)
        print("Toggle:", v)
    end
})

CoreTab:AddToggle({
    Title = "Quick Toggle Supported",
    Default = false,
    CanQuickToggle = true, -- Enables the Creator Button
    Flag = "QuickToggleFlag",
    Callback = function(v)
        print("Quick Toggle:", v)
    end
})

CoreTab:AddSection("Values & Selection")

CoreTab:AddSlider({
    Title = "Test Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(v)
        print("Slider:", v)
    end
})

CoreTab:AddDropdown({
    Title = "Test Dropdown",
    Options = {"Option A", "Option B", "Option C", "Option D", "Option E"},
    Default = "Option A",
    Flag = "DropdownFlag",
    Callback = function(v)
        print("Dropdown:", v)
    end
})

CoreTab:AddColorPicker({
    Title = "Theme Accent",
    Default = Library.Theme.Accent,
    Callback = function(c)
        print("Color:", c)
        -- Library.Theme.Accent = c -- Real-time theme update test
    end
})

CoreTab:AddKeybind({
    Title = "Test Keybind",
    Default = Enum.KeyCode.K,
    Callback = function(k)
        print("Keybind:", k)
        Library:Notify({Title = "Keybind", Content = "Pressed: " .. k.Name})
    end
})

CoreTab:AddButton({
    Title = "Test Dialog",
    Callback = function()
        Window:ShowDialog({
            Title = "Confirmation",
            Content = "Do you want to proceed with this action?",
            Buttons = {
                {
                    Text = "Cancel",
                    Callback = function() print("Cancelled") end
                },
                {
                    Text = "Confirm",
                    Type = "Primary",
                    Callback = function() print("Confirmed") end
                }
            }
        })
    end
})

-- Tab 2: Advanced Logic
local AdvTab = Window:AddTab({ Name = "Advanced", Icon = "zap" })

AdvTab:AddSection("Dependencies")

AdvTab:AddParagraph({
    Title = "Instructions",
    Content = "Toggle the 'Master Switch' below to reveal hidden elements."
})

AdvTab:AddToggle({
    Title = "Master Switch",
    Flag = "MasterSwitch",
    Default = false
})

AdvTab:AddButton({
    Title = "Dependent Button",
    Dependency = { Flag = "MasterSwitch", Value = true, Property = "Visible" },
    Callback = function()
        print("You found me!")
    end
})

AdvTab:AddSlider({
    Title = "Locked Slider",
    Min = 0, Max = 10,
    Dependency = { Flag = "MasterSwitch", Value = false, Property = "Locked" }, -- Locked when Master is FALSE
    Callback = function(v) print(v) end
})

AdvTab:AddSection("Edit Mode Test")
AdvTab:AddParagraph({
    Title = "Edit Mode",
    Content = "Click the 'Edit' (pencil) icon in the top right. Then try to drag or resize the Quick Toggle button created in the Core tab."
})

-- Customize Tab is automatically added at the bottom.

return Window
