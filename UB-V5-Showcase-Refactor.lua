local UBHubLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/UBHubLib/UBHub/main/UB-V5-QOL.lua"))()

local Window = UBHubLib:MakeGui({
    NameHub = "UB Hub V5 - Refactor Showcase",
    Description = "Demonstrating WindUI-inspired features",
    Color = Color3.fromRGB(255, 80, 0),
    SaveFolder = "UBHub_Refactored"
})

-- == Tab 1: Core Components ==
local MainTab = Window:CreateTab({
    Name = "Components",
    Icon = "layers"
})

Window:AddTabCategory("General")

local Section1 = MainTab:AddSection("Basic Inputs")

Section1:AddParagraph({
    Title = "Welcome to the Refactor",
    Content = "This paragraph has an image and a button.",
    Image = "info",
    Buttons = {
        {
            Title = "Click Me!",
            Callback = function()
                UBHubLib:MakeNotify({
                    Title = "Paragraph Button",
                    Content = "You clicked the paragraph button!",
                    Time = 3,
                    BackgroundImage = "check"
                })
            end
        }
    }
})

Section1:AddDivider({
    Text = "Toggle Examples",
    Thickness = 2
})

local MasterToggle = Section1:AddToggle({
    Title = "Master Toggle",
    Content = "Toggles the feature below.",
    Default = false,
    Flag = "Master_Toggle",
    Callback = function(val)
        print("Master:", val)
    end
})

Section1:AddToggle({
    Title = "Dependent Toggle",
    Content = "This toggle requires the Master Toggle to be ON.",
    Default = false,
    Flag = "Dependent_Toggle",
    Icon = "lock",
    Style = "Switch",
    Dependency = {
        Element = MasterToggle,
        Value = true,
        Property = "Locked"
    },
    Callback = function(val)
        print("Dependent:", val)
    end
})

Section1:AddToggle({
    Title = "HUD Quick Toggle",
    Content = "Click the 'Edit' icon next to me to spawn a HUD button!",
    Default = false,
    Flag = "HUD_Toggle",
    Icon = "zap",
    Style = "Checkbox",
    CanQuickToggle = true,
    Callback = function(val)
        print("Quick Toggle:", val)
    end
})

-- == Tab 2: Advanced ==
local AdvTab = Window:CreateTab({
    Name = "Advanced",
    Icon = "sparkles"
})

local Section2 = AdvTab:AddSection("Complex Elements")

Section2:AddDropdown({
    Title = "Advanced Dropdown",
    Content = "Searchable dropdown with multi-select",
    Multi = true,
    Options = {"Aimbot", "ESP", "Tracer", "Chams", "Spinbot"},
    Flag = "Adv_Dropdown",
    Callback = function(val)
        print("Selected:", game:GetService("HttpService"):JSONEncode(val))
    end
})

Section2:AddButton({
    Title = "Show Modal Dialog",
    Content = "Creates a pop-up confirmation dialog.",
    Icon = "alert-circle",
    Callback = function()
        MainTab:ShowDialog({
            Title = "Confirm Action",
            Content = "Are you sure you want to execute this script?",
            Buttons = {
                { Title = "Cancel", Variant = "Secondary", Callback = function() print("Cancelled") end },
                { Title = "Execute", Variant = "Primary", Callback = function() print("Executed") end }
            }
        })
    end
})

Section2:AddButton({
    Title = "Show One-Time Notification",
    Content = "This notification will only ever show once per config.",
    Icon = "bell",
    Callback = function()
        UBHubLib:MakeNotify({
            Title = "One-Time Info",
            Content = "This is a very important message that you only need to see once.",
            Time = 5,
            OneTime = true,
            BackgroundImage = "info"
        })
    end
})

Window:AddTabDivider()

-- The Customize tab is built automatically by the MakeGui function!
