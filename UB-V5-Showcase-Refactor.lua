local UBHubLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/zryr/Libraries/refs/heads/Jules/UB-V5-Refactor.lua"))()


local Window = UBHubLib:CreateWindow({
    Name = "UB Hub Refactor Showcase",
    Icon = "rbxassetid://11422143431", -- Search icon as logo
    Theme = "Default"
})

local MainTab = Window:AddTab({ Name = "Main", Icon = "rbxassetid://11422143431" })
local VisualsTab = Window:AddTab({ Name = "Visuals", Icon = "rbxassetid://11293977610" })

-- Main Tab Elements
Window:AddTabCategory("General")

MainTab:AddParagraph({
    Title = "Welcome",
    Content = "This is a showcase of the refactored UB-V5 library.",
    Buttons = {
        { Title = "Discord", Callback = function() print("Discord link") end },
        { Title = "Docs", Callback = function() print("Docs link") end }
    }
})

MainTab:AddButton({
    Title = "Click Me",
    Icon = "check",
    Callback = function()
        UBHubLib:MakeNotify({
            Title = "Button Clicked",
            Content = "You clicked the button!",
            Time = 3
        })
    end
})

local ToggleA = MainTab:AddToggle({
    Title = "Enable Speed",
    Default = false,
    Flag = "SpeedEnabled",
    Callback = function(V)
        print("Speed:", V)
    end
})

MainTab:AddSlider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Flag = "WalkSpeed",
    Callback = function(V)
        print("WalkSpeed:", V)
    end,
    Dependency = { Flag = "SpeedEnabled", Value = true } -- Only visible if SpeedEnabled is true
})

MainTab:AddDivider({ Text = "Quick Toggles" })

MainTab:AddToggle({
    Title = "Flight (HUD)",
    Default = false,
    CanQuickToggle = true,
    Icon = "rbxassetid://11293981586",
    Callback = function(V)
        print("Flight:", V)
    end
})

-- Visuals Tab
VisualsTab:AddDropdown({
    Title = "ESP Mode",
    Options = {"Box", "Tracer", "Chams"},
    Multi = true,
    Callback = function(V)
        print("ESP:", V)
    end
})

VisualsTab:AddInput({
    Title = "Custom ESP Text",
    Default = "Enemy",
    Placeholder = "Name...",
    Callback = function(V)
        print("ESP Text:", V)
    end
})

-- Dialog Demo
Window:AddTabDivider()
local MiscTab = Window:AddTab({ Name = "Misc" })

MiscTab:AddButton({
    Title = "Show Dialog",
    Callback = function()
        Window:ShowDialog({
            Title = "Confirmation",
            Content = "Do you want to proceed with this action?",
            Buttons = {
                { Title = "Cancel", Callback = function() print("Cancelled") end },
                { Title = "Confirm", Variant = "Primary", Callback = function() print("Confirmed") end }
            }
        })
    end
})

-- Settings
Window:CreateSettingsTab()

-- Notify load
UBHubLib:MakeNotify({
    Title = "Loaded",
    Content = "UB Hub Refactor loaded successfully.",
    Time = 5,
    OneTime = true -- Will only show once per config save
})
