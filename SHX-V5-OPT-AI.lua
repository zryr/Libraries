--[[
    Speed Hub X - V5 UI Library (Refactored & Improved)
    Original Base: AhmadV99
    Further Development (Source Version): zryr (from GitHub link)
    Refactored By: AI
--]]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui") -- Store CoreGui reference

-- Function to get the most appropriate GUI parent
local function GetPlayerGuiParent()
    if RunService:IsStudio() then
        return Player and Player:FindFirstChildOfClass("PlayerGui")
    else
        -- For executors, CoreGui is often the target.
        -- Fallback chain: PlayerGui (if standard environment) -> gethui() (executor) -> cloneref(CoreGui) (executor) -> CoreGui
        return (Player and Player:FindFirstChildOfClass("PlayerGui")) or
               (getfenv().gethui and getfenv().gethui()) or
               (getfenv().cloneref and getfenv().cloneref(CoreGui)) or
               CoreGui
    end
end


--[[ Initial Ad/Game Specific Setup - Kept for original structure, but commented out HttpGet
task.spawn(function()
	pcall(function()
		if game.PlaceId == 3623096087 then -- Example PlaceId
			local robloxForwardPortals = game.Workspace:FindFirstChild("RobloxForwardPortals")
			if robloxForwardPortals then
				robloxForwardPortals:Destroy()
			end
		end
		-- loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Main/main/Library/GUI_ADS.lua"))()
        -- warn("GUI_ADS.lua loading skipped in this refactored library version.")
	end)
end)
--]]

local Custom = {} do
  Custom.ColorRGB = Color3.fromRGB(250, 7, 7) -- Default theme color

  function Custom:Create(instanceType, properties, parent)
    local instance = Instance.new(instanceType)
    for prop, value in pairs(properties) do
        pcall(function() instance[prop] = value end) -- Wrap in pcall for safety with properties
    end
    if parent then
        instance.Parent = parent
    end
    return instance
  end

  function Custom:EnableAFK()
    if not Player then return end -- Guard against no LocalPlayer
    local idledConnection
    idledConnection = Player.Idled:Connect(function()
      pcall(function()
          VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
          task.wait(1)
          VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      end)
    end)
    -- Consider adding a way to disable/disconnect this if the library is unloaded.
  end
end

if Player then -- Only enable AFK if Player exists
    Custom:EnableAFK()
end

-- Refactored OpenClose button (Minimize/Restore button)
local function CreateOpenCloseButton(guiParent)
    if not guiParent then
        warn("OpenClose: No GUI parent found.")
        return { Visible = false, Activated = Instance.new("BindableEvent"), Destroy = function() end } -- Dummy
    end

    local ScreenGui = Custom:Create("ScreenGui", {
        Name = "OpenCloseHandlerScreenGui", -- More descriptive
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        DisplayOrder = 999 -- Try to keep on top
    }, guiParent)

    local OpenCloseButton = Custom:Create("ImageButton", {
        Name = "OpenCloseButton",
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderColor3 = Custom.ColorRGB,
        BorderSizePixel = 1,
        Position = UDim2.new(0, 10, 0, 10), -- Default top-left
        Size = UDim2.fromOffset(50, 40),
        Image = "rbxassetid://82140212012109", -- Placeholder, ensure this is a valid icon for "open"
        Visible = false,
        ZIndex = 2
    }, ScreenGui)

    Custom:Create("UICorner", { CornerRadius = UDim.new(0, 6) }, OpenCloseButton)

    local dragging, dragStartPos, dragMouseStartPos = false, nil, nil
    local inputChangedConn, inputEndedConn

    OpenCloseButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = OpenCloseButton.Position
            dragMouseStartPos = input.Position

            -- Disconnect previous potentially lingering connections
            if inputChangedConn then inputChangedConn:Disconnect() end
            if inputEndedConn then inputEndedConn:Disconnect() end

            inputChangedConn = input.Changed:Connect(function()
                if dragging and dragMouseStartPos and dragStartPos then
                    local delta = input.Position - dragMouseStartPos
                    OpenCloseButton.Position = UDim2.new(
                        dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
                    )
                end
            end)
            inputEndedConn = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == input.UserInputType and endInput.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragStartPos = nil
                    dragMouseStartPos = nil
                    if inputChangedConn then inputChangedConn:Disconnect(); inputChangedConn = nil end
                    if inputEndedConn then inputEndedConn:Disconnect(); inputEndedConn = nil end -- Self-disconnect
                end
            end)
        end
    end)
    -- No InputChanged on OpenCloseButton needed if using input.Changed from InputBegan

    return OpenCloseButton
end

local Open_Close_Button_Instance -- Deferred initialization

-- Refactored MakeDraggable
local function MakeDraggable(dragHandle, draggableObject)
    local dragging, dragStartPos, dragMouseStartPos = false, nil, nil
    local inputChangedConn, inputEndedConn -- Store connections to disconnect them

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = draggableObject.Position -- Position of the object to be dragged
            dragMouseStartPos = input.Position      -- Mouse position when drag started

            -- Disconnect previous potentially lingering connections
            if inputChangedConn then inputChangedConn:Disconnect() end
            if inputEndedConn then inputEndedConn:Disconnect() end

            -- Listen for changes on the specific input object
            inputChangedConn = input.Changed:Connect(function()
                if dragging and dragMouseStartPos and dragStartPos then
                    local delta = input.Position - dragMouseStartPos
                    draggableObject.Position = UDim2.new(
                        dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
                    )
                end
            end)

            -- Listen globally for InputEnded to ensure drag stops
            inputEndedConn = UserInputService.InputEnded:Connect(function(endInput)
                 -- Check if it's the same input type that started the drag
                if endInput.UserInputType == input.UserInputType and endInput.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragStartPos = nil
                    dragMouseStartPos = nil
                    if inputChangedConn then inputChangedConn:Disconnect(); inputChangedConn = nil end
                    if inputEndedConn then inputEndedConn:Disconnect(); inputEndedConn = nil end -- Self-disconnect
                end
            end)
        end
    end)
end

-- Refactored CircleClick
function CircleClick(button, mouseX, mouseY)
    if not button or not button:IsA("GuiButton") then return end
	task.spawn(function()
		button.ClipsDescendants = true
		
		local circle = Custom:Create("ImageLabel", {
            Image = "rbxassetid://266543268", -- Ripple effect image
            ImageColor3 = Color3.fromRGB(120, 120, 120), -- Slightly lighter for better visibility on dark themes
            ImageTransparency = 0.85,
            BackgroundTransparency = 1,
            ZIndex = (button.ZIndex or 1) + 5, -- Ensure it's well above the button
            Name = "ClickCircleEffect",
            AnchorPoint = Vector2.new(0.5, 0.5), -- Anchor from center for scaling
            Position = UDim2.fromOffset(mouseX - button.AbsolutePosition.X, mouseY - button.AbsolutePosition.Y),
            Size = UDim2.fromOffset(0,0), -- Start small
            Parent = button
        })
		
		local targetSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.75 -- Slightly larger ripple
		local animationTime = 0.35
        local tweenInfoExpand = TweenInfo.new(animationTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local tweenInfoFade = TweenInfo.new(animationTime * 0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, animationTime * 0.4)

		local expandTween = TweenService:Create(circle, tweenInfoExpand, {
			Size = UDim2.fromOffset(targetSize, targetSize)
            -- Position remains anchored, no need to tween if already centered at click
		})
        local fadeTween = TweenService:Create(circle, tweenInfoFade, { ImageTransparency = 1 })
		
		expandTween:Play()
        fadeTween:Play()
		
		fadeTween.Completed:Connect(function()
			circle:Destroy()
		end)
	end)
end

-- Main Library Table
local Speed_Library = {}
Speed_Library.Unloaded = false
Speed_Library.ActiveNotifications = {} -- To manage active notifications

-- Refactored Notification System
function Speed_Library:SetNotification(config)
    local Title = config[1] or config.Title or "Notification"
    local Description = config[2] or config.Description or "" -- Optional description
    local Content = config[3] or config.Content or "This is a notification."
    local IconId = config[4] or config.Icon -- Optional icon
    local AnimTime = config[5] or config.Time or 0.4 -- Animation time
    local DisplayDelay = config[6] or config.Delay or 5 -- How long it stays

    local guiParent = GetPlayerGuiParent()
    if not guiParent then return { Close = function() end } end -- Dummy API

    -- Get or create the main ScreenGui for notifications
    local NotificationHostGui = guiParent:FindFirstChild("SpeedLibNotificationHost")
    if not NotificationHostGui then
        NotificationHostGui = Custom:Create("ScreenGui", {
            Name = "SpeedLibNotificationHost",
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false,
            DisplayOrder = 1000 -- High display order
        }, guiParent)
    end

    -- Get or create the layout frame for notifications
    local NotificationLayout = NotificationHostGui:FindFirstChild("NotificationStackLayout")
    if not NotificationLayout then
        NotificationLayout = Custom:Create("Frame", {
            Name = "NotificationStackLayout",
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -15, 1, -15), -- Bottom-right corner
            Size = UDim2.new(0, 320, 0, 0),      -- Width fixed, height dynamic
            BackgroundTransparency = 1,
            ClipsDescendants = true, -- Important for animations if items exceed bounds
        }, NotificationHostGui)
        Custom:Create("UIListLayout", {
            Parent = NotificationLayout,
            SortOrder = Enum.SortOrder.LayoutOrder, -- New notifications appear based on LayoutOrder
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 8)
        })
        -- Automatic height adjustment for the layout frame
        NotificationLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            NotificationLayout.Size = UDim2.new(0, NotificationLayout.AbsoluteSize.X, 0, NotificationLayout.AbsoluteContentSize.Y)
        end)
    end

    local notificationId = "Notification_" .. tostring(math.random(1e5, 1e6)) -- Unique ID

    local NotificationFrame = Custom:Create("Frame", {
        Name = notificationId,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 1,
        BorderColor3 = Color3.fromRGB(55,55,55),
        Size = UDim2.new(1, 0, 0, 80), -- Initial height, will adjust
        LayoutOrder = tick(), -- Newest on top (or bottom depending on list layout fill direction)
        ClipsDescendants = true,
    }, NotificationLayout)
    Custom:Create("UICorner", { CornerRadius = UDim.new(0, 6) }, NotificationFrame)
    Custom:Create("UIPadding", { PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,6)}, NotificationFrame)

    -- Optional Icon
    if IconId then
        Custom:Create("ImageLabel", { Image=IconId, Size=UDim2.fromOffset(20,20), Position=UDim2.new(0,0,0,0), BackgroundTransparency=1 }, NotificationFrame)
        -- TODO: Adjust layout of text if icon is present
    end

    local HeaderFrame = Custom:Create("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,20), Parent=NotificationFrame })
    local TitleLabel = Custom:Create("TextLabel", {
        Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Color3.fromRGB(240, 240, 240), TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(0,0,1,0), Parent = HeaderFrame
    })
    TitleLabel.Size = UDim2.new(0, TitleLabel.TextBounds.X + (Description ~= "" and 5 or 0), 1, 0)

    if Description ~= "" then
        local DescLabel = Custom:Create("TextLabel", {
            Font = Enum.Font.GothamSemibold, Text = Description, TextColor3 = Custom.ColorRGB, TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1,
            Position = UDim2.new(0, TitleLabel.AbsoluteSize.X, 0, 0), Size = UDim2.new(0,0,1,0), Parent = HeaderFrame
        })
        DescLabel.Size = UDim2.new(0, DescLabel.TextBounds.X, 1, 0)
    end
    local CloseButton = Custom:Create("ImageButton", { Image="rbxassetid://9886659671", AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=1,
        Position=UDim2.new(1,-2,0.5,0), Size=UDim2.fromOffset(16,16), ImageColor3=Color3.fromRGB(150,150,150), Parent=HeaderFrame })

    local ContentLabel = Custom:Create("TextLabel", {
        Font = Enum.Font.Gotham, Text = Content, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true,
        BackgroundTransparency = 1, Position = UDim2.new(0,0,0,HeaderFrame.AbsoluteSize.Y + 4), Size = UDim2.new(1,0,0,0), Parent = NotificationFrame
    })
    task.wait() -- Allow TextBounds to update
    ContentLabel.Size = UDim2.new(1,0,0, ContentLabel.TextBounds.Y)
    NotificationFrame.Size = UDim2.new(1,0,0, HeaderFrame.AbsoluteSize.Y + ContentLabel.AbsoluteSize.Y + 8)


    local notificationAPI = {}
    local isClosed = false

    function notificationAPI:Close()
        if isClosed or not NotificationFrame.Parent then return end
        isClosed = true
        Speed_Library.ActiveNotifications[notificationId] = nil -- Remove from active list

        local slideOutTween = TweenService:Create(NotificationFrame, TweenInfo.new(AnimTime * 0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = NotificationFrame.Position + UDim2.new(0, NotificationFrame.AbsoluteSize.X + 20, 0, 0) -- Slide right
        })
        local fadeOutTween = TweenService:Create(NotificationFrame, TweenInfo.new(AnimTime * 0.7, Enum.EasingStyle.Linear), { BackgroundTransparency = 1 })

        slideOutTween:Play()
        fadeOutTween:Play()
        slideOutTween.Completed:Connect(function()
            NotificationFrame:Destroy()
        end)
    end

    CloseButton.MouseEnter:Connect(function() CloseButton.ImageColor3 = Color3.fromRGB(220,220,220) end)
    CloseButton.MouseLeave:Connect(function() CloseButton.ImageColor3 = Color3.fromRGB(150,150,150) end)
    CloseButton.Activated:Connect(notificationAPI.Close)

    -- Entrance Animation
    NotificationFrame.Position = NotificationFrame.Position - UDim2.new(0, NotificationFrame.AbsoluteSize.X + 20, 0, 0) -- Start off-screen left
    local entranceTween = TweenService:Create(NotificationFrame, TweenInfo.new(AnimTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = NotificationFrame.Position + UDim2.new(0, NotificationFrame.AbsoluteSize.X + 20, 0, 0)
    })
    entranceTween:Play()
    Speed_Library.ActiveNotifications[notificationId] = notificationAPI

    -- Auto-close timer
    task.delay(DisplayDelay, function()
        if Speed_Library.ActiveNotifications[notificationId] and not isClosed then
            notificationAPI:Close()
        end
    end)

    return notificationAPI
end


-- CreateWindow function (main UI)
function Speed_Library:CreateWindow(config)
    local Title = config[1] or config.Title or "UI Library"
    local Description = config[2] or config.Description or "V1"
    local TabWidth = config[3] or config["Tab Width"] or 120
    local WindowSize = config[4] or config.SizeUi or UDim2.fromOffset(600, 400)

    local guiParent = GetPlayerGuiParent()
    if not guiParent then
        warn("CreateWindow: No GUI parent found.")
        return {} -- Return empty API table
    end
    Open_Close_Button_Instance = CreateOpenCloseButton(guiParent) -- Initialize the global open/close button

    local MainScreenGui = Custom:Create("ScreenGui", {
        Name = "SpeedLibMainScreenGui",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        DisplayOrder = 998 -- Below notifications and open/close button
    }, guiParent)

    local DraggableHolder = Custom:Create("Frame", {
        Name = "DraggableWindowHolder",
        BackgroundTransparency = 1,
        Size = WindowSize,
        Position = UDim2.new(0.5, -WindowSize.X.Offset / 2, 0.5, -WindowSize.Y.Offset / 2), -- Centered
        AnchorPoint = Vector2.new(0,0), -- For easier position calculation if size changes
        Visible = true -- Start visible
    }, MainScreenGui)

    -- Shadow (optional, can be styled)
    Custom:Create("ImageLabel", {
        Name = "WindowDropShadow", Image = "rbxassetid://6015897843", ImageColor3 = Color3.fromRGB(0,0,0), ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49,49,450,450), AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1, Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(1,15,1,15), ZIndex = -1
    }, DraggableHolder)

    local MainFrame = Custom:Create("Frame", {
        Name = "MainFrame", AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = Color3.fromRGB(25,25,25), BackgroundTransparency = 0.05,
        Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(1,0,1,0), BorderSizePixel=1, BorderColor3=Color3.fromRGB(45,45,45)
    }, DraggableHolder)
    Custom:Create("UICorner", {CornerRadius = UDim.new(0,8)}, MainFrame)

    local TopBar = Custom:Create("Frame", {
        Name = "TopBar", BackgroundColor3 = Color3.fromRGB(35,35,35), BackgroundTransparency = 0.1, Size = UDim2.new(1,0,0,38),
        BorderSizePixel=0
    }, MainFrame)
    -- TopBar corners are implicitly rounded by MainFrame's UICorner + ClipsDescendants on MainFrame (if you add it)

    local TitleLabel = Custom:Create("TextLabel", {
        Name = "TitleText", Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Color3.fromRGB(230,230,230), TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,0), Size = UDim2.new(0,0,1,0)
    }, TopBar)
    TitleLabel.Size = UDim2.new(0, TitleLabel.TextBounds.X + 5, 1, 0)

    local DescriptionLabel = Custom:Create("TextLabel", {
        Name = "DescriptionText", Font = Enum.Font.GothamSemibold, Text = Description, TextColor3 = Custom.ColorRGB, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.new(0, TitleLabel.AbsoluteSize.X + 10, 0,0), Size = UDim2.new(0,0,1,0)
    }, TopBar)
    DescriptionLabel.Size = UDim2.new(0, DescriptionLabel.TextBounds.X + 5, 1, 0)

    -- Auto-adjust window width based on title and description, if they exceed current width
    local requiredTopBarWidth = TitleLabel.AbsoluteSize.X + DescriptionLabel.AbsoluteSize.X + 80 -- 80 for buttons
    if requiredTopBarWidth > DraggableHolder.AbsoluteSize.X then
        local newWidth = requiredTopBarWidth
        DraggableHolder.Size = UDim2.fromOffset(newWidth, DraggableHolder.Size.Y.Offset)
        DraggableHolder.Position = UDim2.new(0.5, -newWidth/2, DraggableHolder.Position.Y.Scale, DraggableHolder.Position.Y.Offset)
    end

    local CloseButton = Custom:Create("ImageButton", { Name="CloseBtn", Image="rbxassetid://9886659671", AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=1, Position=UDim2.new(1,-10,0.5,0), Size=UDim2.fromOffset(20,20), ImageColor3=Color3.fromRGB(180,180,180) }, TopBar)
    local MinimizeButton = Custom:Create("ImageButton", { Name="MinimizeBtn", Image="rbxassetid://9886659276", AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=1, Position=UDim2.new(1,-38,0.5,0), Size=UDim2.fromOffset(20,20), ImageColor3=Color3.fromRGB(180,180,180) }, TopBar)
    CloseButton.MouseEnter:Connect(function() CloseButton.ImageColor3=Color3.fromRGB(240,240,240) end); CloseButton.MouseLeave:Connect(function() CloseButton.ImageColor3=Color3.fromRGB(180,180,180) end)
    MinimizeButton.MouseEnter:Connect(function() MinimizeButton.ImageColor3=Color3.fromRGB(240,240,240) end); MinimizeButton.MouseLeave:Connect(function() MinimizeButton.ImageColor3=Color3.fromRGB(180,180,180) end)

    Custom:Create("Frame", { Name="TopBarSeparator", BackgroundColor3=Color3.fromRGB(45,45,45), Position=UDim2.new(0.025,0,1,0), Size=UDim2.new(0.95,0,0,1), AnchorPoint=Vector2.new(0,1) }, TopBar) -- Separator line

    local ContentArea = Custom:Create("Frame", { Name="ContentArea", BackgroundTransparency=1, Position=UDim2.new(0,10,0,TopBar.AbsoluteSize.Y+8), Size=UDim2.new(1,-20,1,-(TopBar.AbsoluteSize.Y+8+10)) }, MainFrame)
    local TabsListScroll = Custom:Create("ScrollingFrame", { Name="TabsList", CanvasSize=UDim2.new(0,0,0,0), ScrollBarThickness=3, ScrollBarImageColor3=Custom.ColorRGB, BackgroundColor3=Color3.fromRGB(30,30,30), BackgroundTransparency=0.3, BorderSizePixel=0, Size=UDim2.new(0,TabWidth,1,0) }, ContentArea)
    Custom:Create("UICorner", {CornerRadius=UDim.new(0,4)}, TabsListScroll)
    local TabsListLayout = Custom:Create("UIListLayout", { Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center }, TabsListScroll)

    local ContentPagesHolder = Custom:Create("Frame", { Name="ContentPages", BackgroundTransparency=1, Position=UDim2.new(0,TabWidth+8,0,0), Size=UDim2.new(1,-(TabWidth+8),1,0) }, ContentArea)
    local CurrentTabNameLabel = Custom:Create("TextLabel", { Name="CurrentTabTitle", Font=Enum.Font.GothamBold, Text="", TextColor3=Color3.fromRGB(220,220,220), TextSize=17, TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1, Size=UDim2.new(1,0,0,25) }, ContentPagesHolder)
    local PagesContainer = Custom:Create("Frame", { Name="PagesActualContainer", BackgroundTransparency=1, ClipsDescendants=true, Position=UDim2.new(0,0,0,CurrentTabNameLabel.AbsoluteSize.Y+5), Size=UDim2.new(1,0,1,-(CurrentTabNameLabel.AbsoluteSize.Y+5)) }, ContentPagesHolder)
    local UIPagesFolder = Custom:Create("Folder", {Name="UIPages"}, PagesContainer)
    local ContentUIPageLayout = Custom:Create("UIPageLayout", { SortOrder=Enum.SortOrder.LayoutOrder, TweenTime=0.2, EasingDirection=Enum.EasingDirection.InOut, EasingStyle=Enum.EasingStyle.Quad }, UIPagesFolder)

    local function UpdateTabsListCanvas() task.wait(); local h=0; for _,c in ipairs(TabsListScroll:GetChildren()) do if c:IsA("GuiObject") and c~=TabsListLayout then h=h+c.AbsoluteSize.Y end end; TabsListScroll.CanvasSize=UDim2.fromOffset(0,h+(TabsListLayout.Padding.Offset*(math.max(0,#TabsListScroll:GetChildren()-2)))) end
    TabsListScroll.ChildAdded:Connect(UpdateTabsListCanvas); TabsListScroll.ChildRemoved:Connect(UpdateTabsListCanvas)

    MinimizeButton.Activated:Connect(function() CircleClick(MinimizeButton, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y); DraggableHolder.Visible=false; if Open_Close_Button_Instance then Open_Close_Button_Instance.Visible=true end end)
    if Open_Close_Button_Instance then Open_Close_Button_Instance.Activated:Connect(function() DraggableHolder.Visible=true; Open_Close_Button_Instance.Visible=false end) end
    CloseButton.Activated:Connect(function()
        CircleClick(CloseButton, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        Speed_Library.Unloaded = true
        -- Clean up all active notifications
        for id, notifApi in pairs(Speed_Library.ActiveNotifications) do notifApi:Close() end
        Speed_Library.ActiveNotifications = {}
        if Open_Close_Button_Instance then Open_Close_Button_Instance:Destroy() end
        MainScreenGui:Destroy() -- Destroy the entire UI
    end)
	MakeDraggable(TopBar, DraggableHolder)

    -- Dropdown Popup System (Global within MainScreenGui)
    local DropdownPopupOverlay = Custom:Create("Frame", { Name="DropdownPopupOverlay", BackgroundColor3=Color3.fromRGB(10,10,10), BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), ZIndex=500, Visible=false, Parent=MainScreenGui })
    local ClosePopupBGButton = Custom:Create("TextButton",{ Name="ClosePopupBG", Text="", BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), ZIndex=500 }, DropdownPopupOverlay)
    local DropdownContentHost = Custom:Create("Frame", { Name="DropdownContentHost", BackgroundColor3=Color3.fromRGB(40,40,40), BackgroundTransparency=0.05, BorderSizePixel=1, BorderColor3=Color3.fromRGB(60,60,60), Size=UDim2.fromOffset(200,220), ClipsDescendants=true, ZIndex=501 }, DropdownPopupOverlay)
    Custom:Create("UICorner",{CornerRadius=UDim.new(0,6)}, DropdownContentHost)
    Custom:Create("UIPadding",{PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5),PaddingTop=UDim.new(0,5),PaddingBottom=UDim.new(0,5)}, DropdownContentHost)
    local DropdownPages_ActualFolder = Custom:Create("Folder", {Name="DropdownPages_Folder"}, DropdownContentHost) -- To hold scrolling frames for each dropdown
    local Dropdown_UIPageLayout = Custom:Create("UIPageLayout", { TweenTime=0.01, SortOrder=Enum.SortOrder.LayoutOrder }, DropdownPages_ActualFolder)

    local function HideDropdownPopup() if not DropdownPopupOverlay.Visible then return end; local ti=TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out); TweenService:Create(DropdownPopupOverlay,ti,{BackgroundTransparency=1}):Play(); local sdt=TweenService:Create(DropdownContentHost,ti,{Size=UDim2.fromScale(0.8,0.8),Position=DropdownContentHost.Position+UDim2.fromOffset(DropdownContentHost.AbsoluteSize.X*0.1,DropdownContentHost.AbsoluteSize.Y*0.1)});sdt:Play();sdt.Completed:Connect(function()DropdownPopupOverlay.Visible=false;DropdownContentHost.Size=UDim2.fromOffset(200,220);DropdownContentHost.AnchorPoint=Vector2.new(0,0)end)end
    ClosePopupBGButton.Activated:Connect(HideDropdownPopup)

    -- Window API
    local WindowAPI = {}
    local currentActiveTabButtonFrame = nil
    local tabCreationOrder = 0
    local dropdownInstanceCounter = 0 -- To give unique names to dropdown pages

    function WindowAPI:CreateTab(tabConfig)
        local tabName = tabConfig[1] or tabConfig.Name or "Tab"
        local tabIconId = tabConfig[2] or tabConfig.Icon or "rbxassetid://3926305904" -- Default Roblox icon
        local order = tabCreationOrder; tabCreationOrder = tabCreationOrder + 1

        local TabContentPage = Custom:Create("ScrollingFrame", { Name=tabName.."_ContentPage", LayoutOrder=order, Parent=UIPagesFolder, BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), ScrollBarThickness=4, ScrollBarImageColor3=Custom.ColorRGB, CanvasSize=UDim2.new(0,0,0,0) })
        local TabContentLayout = Custom:Create("UIListLayout", { Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center }, TabContentPage)

        local TabButtonFrame = Custom:Create("Frame", { Name=tabName.."_Button", BackgroundColor3=Color3.fromRGB(50,50,50), BackgroundTransparency=0.7, Size=UDim2.new(0.9,0,0,35), LayoutOrder=order }, TabsListScroll)
        Custom:Create("UICorner",{CornerRadius=UDim.new(0,5)}, TabButtonFrame)
        local TabButton = Custom:Create("TextButton",{ Name="Activator", Text="", BackgroundTransparency=1, Size=UDim2.new(1,0,1,0) }, TabButtonFrame)
        Custom:Create("ImageLabel",{ Name="Icon", Image=tabIconId, BackgroundTransparency=1, Size=UDim2.fromOffset(18,18), Position=UDim2.new(0,10,0.5,-9) }, TabButtonFrame)
        Custom:Create("TextLabel",{ Name="Label", Font=Enum.Font.GothamSemibold, Text=tabName, TextColor3=Color3.fromRGB(180,180,180), TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1, Position=UDim2.new(0,36,0,0), Size=UDim2.new(1,-40,1,0) }, TabButtonFrame)
        local ActiveIndicator = Custom:Create("Frame", { Name="ActiveBar", BackgroundColor3=Custom.ColorRGB, Size=UDim2.new(0,3,0.7,0), Position=UDim2.new(0,0,0.15,0), Visible=false, Parent=TabButtonFrame })
        Custom:Create("UICorner",{CornerRadius=UDim.new(1,0)}, ActiveIndicator)

        TabButton.MouseEnter:Connect(function() if TabButtonFrame ~= currentActiveTabButtonFrame then TweenService:Create(TabButtonFrame,TweenInfo.new(0.15),{BackgroundTransparency=0.4}):Play() end end)
        TabButton.MouseLeave:Connect(function() if TabButtonFrame ~= currentActiveTabButtonFrame then TweenService:Create(TabButtonFrame,TweenInfo.new(0.15),{BackgroundTransparency=0.7}):Play() end end)
        TabButton.Activated:Connect(function()
            CircleClick(TabButton, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
            if currentActiveTabButtonFrame then
                currentActiveTabButtonFrame.ActiveBar.Visible = false
                currentActiveTabButtonFrame.Label.TextColor3 = Color3.fromRGB(180,180,180)
                TweenService:Create(currentActiveTabButtonFrame,TweenInfo.new(0.15),{BackgroundTransparency=0.7}):Play()
            end
            ActiveIndicator.Visible = true; TabButtonFrame.Label.TextColor3 = Color3.fromRGB(240,240,240)
            TweenService:Create(TabButtonFrame,TweenInfo.new(0.15),{BackgroundTransparency=0.2}):Play()
            currentActiveTabButtonFrame = TabButtonFrame
            ContentUIPageLayout:JumpTo(TabContentPage)
            CurrentTabNameLabel.Text = tabName
        end)
        if order == 0 then TabButton.Activated:Fire() end -- Activate first tab
        UpdateTabsListCanvas()

        -- Tab API
        local TabAPI = { ContentPage = TabContentPage } -- Expose ContentPage for direct manipulation if needed
        local sectionCreationOrder = 0

        function TabAPI:AddSection(sectionTitle, initiallyOpen)
            sectionTitle = sectionTitle or "Section"
            initiallyOpen = initiallyOpen == nil and true or initiallyOpen -- Default open

            local order = sectionCreationOrder; sectionCreationOrder = sectionCreationOrder + 1
            local SectionFrame = Custom:Create("Frame", { Name=sectionTitle.."Section", BackgroundColor3=Color3.fromRGB(30,30,30), BackgroundTransparency=0.3, Size=UDim2.new(0.95,0,0,35), LayoutOrder=order, ClipsDescendants=true }, TabContentPage)
            Custom:Create("UICorner",{CornerRadius=UDim.new(0,5)}, SectionFrame)
            local SectionHeader = Custom:Create("TextButton",{ Name="HeaderButton", Text="", BackgroundTransparency=1, Size=UDim2.new(1,0,0,35) }, SectionFrame)
            Custom:Create("TextLabel",{ Name="Title", Font=Enum.Font.GothamBold, Text=sectionTitle, TextColor3=Color3.fromRGB(210,210,210), TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1, Position=UDim2.new(0,10,0,0), Size=UDim2.new(1,-30,1,0) }, SectionHeader)
            local Chevron = Custom:Create("ImageLabel",{ Name="ChevronIcon", Image="rbxassetid://16851841101", ImageColor3=Color3.fromRGB(180,180,180), Rotation=0, AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=1, Position=UDim2.new(1,-10,0.5,0), Size=UDim2.fromOffset(15,15) }, SectionHeader)
            local ItemsContainer = Custom:Create("Frame", { Name="ItemsContainer", BackgroundTransparency=1, ClipsDescendants=true, Position=UDim2.new(0,0,0,35), Size=UDim2.new(1,0,0,0) }, SectionFrame) -- Height starts at 0
            local ItemsListLayout = Custom:Create("UIListLayout",{ Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center }, ItemsContainer)

            local isOpen = false
            local function UpdateSectionVisuals(shouldBeOpen, animate)
                animate = animate == nil and true or animate -- Default to animate
                local itemsHeight = 0; for _,item in ipairs(ItemsContainer:GetChildren()) do if item:IsA("GuiObject") and item~=ItemsListLayout then itemsHeight=itemsHeight+item.AbsoluteSize.Y+ItemsListLayout.Padding.Offset end end
                itemsHeight = math.max(0, itemsHeight - ItemsListLayout.Padding.Offset) -- Remove last padding
                local targetContainerHeight = shouldBeOpen and itemsHeight or 0
                local targetFrameHeight = 35 + targetContainerHeight + (shouldBeOpen and (itemsHeight > 0 and 5 or 0) or 0) -- Padding below items if open and has items
                local targetRotation = shouldBeOpen and 90 or 0
                local animTime = animate and 0.2 or 0

                TweenService:Create(ItemsContainer,TweenInfo.new(animTime),{Size=UDim2.new(1,0,0,targetContainerHeight)}):Play()
                local sizeTween = TweenService:Create(SectionFrame,TweenInfo.new(animTime),{Size=UDim2.new(SectionFrame.Size.X.Scale,SectionFrame.Size.X.Offset,0,targetFrameHeight)})
                sizeTween:Play()
                TweenService:Create(Chevron,TweenInfo.new(animTime),{Rotation=targetRotation}):Play()
                isOpen = shouldBeOpen
                sizeTween.Completed:Connect(function() TabContentPage.CanvasSize = UDim2.fromOffset(0, TabContentLayout.AbsoluteContentSize.Y + 20) end) -- Update tab scroll
            end
            SectionHeader.Activated:Connect(function() UpdateSectionVisuals(not isOpen) end)
            local function RefreshSectionLayout() UpdateSectionVisuals(isOpen, false) end -- Non-animated refresh
            ItemsContainer.ChildAdded:Connect(RefreshSectionLayout); ItemsContainer.ChildRemoved:Connect(RefreshSectionLayout)
            UpdateSectionVisuals(initiallyOpen, false) -- Initial state, no animation

            -- Section API
            local SectionAPI = {}
            local itemCreationOrder = 0
            local function CreateItemBaseFrame(height, itemNameSuffix) -- Helper for common item frame
                itemCreationOrder = itemCreationOrder + 1
                local ItemFrame = Custom:Create("Frame", { Name = (config.Name or "Item") .. (itemNameSuffix or ""), BackgroundColor3=Color3.fromRGB(40,40,40), BackgroundTransparency=0.4, Size=UDim2.new(0.95,0,0,height), LayoutOrder=itemCreationOrder }, ItemsContainer)
                Custom:Create("UICorner",{CornerRadius=UDim.new(0,4)}, ItemFrame)
                Custom:Create("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,5),PaddingBottom=UDim.new(0,5)}, ItemFrame)
                return ItemFrame
            end

            function SectionAPI:AddParagraph(paraConfig)
                -- Similar to your original AddParagraph, but using CreateItemBaseFrame
                -- Returns an API table with :Set({Title="", Content=""})
                -- Make sure to call RefreshSectionLayout() after text changes that affect size.
                -- For brevity, full implementation of each item is omitted here but should follow your established pattern.
                -- Example stub:
                local ItemFrame = CreateItemBaseFrame(40, "_Paragraph")
                local TitleLabel = Custom:Create("TextLabel", {Name="Title", Text=paraConfig.Title, Parent=ItemFrame, Size=UDim2.new(1,0,0,15), TextColor3=Color3.white, Font=Enum.Font.GothamBold, TextSize=13, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
                local ContentLabel = Custom:Create("TextLabel", {Name="Content", Text=paraConfig.Content, Parent=ItemFrame, Size=UDim2.new(1,0,1,-18), Position=UDim2.new(0,0,0,18), TextColor3=Color3.fromRGB(180,180,180), Font=Enum.Font.Gotham, TextSize=12, BackgroundTransparency=1, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top})
                local function UpdateParaSize() task.wait(); ContentLabel.Size = UDim2.new(1,0,0,ContentLabel.TextBounds.Y); ItemFrame.Size = UDim2.new(ItemFrame.Size.X.Scale,ItemFrame.Size.X.Offset,0,18+ContentLabel.AbsoluteSize.Y+10); RefreshSectionLayout() end
                ContentLabel:GetPropertyChangedSignal("TextBounds"):Connect(UpdateParaSize); UpdateParaSize()
                local ParaAPI = { Frame = ItemFrame }; function ParaAPI:Set(newConf) TitleLabel.Text=newConf.Title or TitleLabel.Text; ContentLabel.Text=newConf.Content or ContentLabel.Text; UpdateParaSize() end
                if paraConfig.Name then ItemFrame.Name = paraConfig.Name end -- Allow naming for external access
                ItemFrame.Api = ParaAPI -- Attach API to the frame itself
                return ParaAPI
            end
            function SectionAPI:AddSeperator(sepConfig) local ItemFrame=CreateItemBaseFrame(20,"_Separator"); ItemFrame.BackgroundTransparency=1; local Line=Custom:Create("Frame",{BackgroundColor3=Color3.fromRGB(60,60,60),Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0.5,-0.5)},ItemFrame); local TitleLabel=Custom:Create("TextLabel",{Text=sepConfig.Title or "",Font=Enum.Font.GothamBold,TextSize=11,TextColor3=Color3.fromRGB(150,150,150),BackgroundTransparency=1,Size=UDim2.new(0,0,1,0),TextXAlignment=Enum.TextXAlignment.Center},ItemFrame); task.wait(); TitleLabel.Size=UDim2.new(0,TitleLabel.TextBounds.X+10,1,0);TitleLabel.Position=UDim2.new(0.5,-(TitleLabel.AbsoluteSize.X/2),0,0);Line.BackgroundColor3=sepConfig.Title and Color3.fromRGB(40,40,40) or Color3.fromRGB(60,60,60); return {Frame=ItemFrame} end
            function SectionAPI:AddLine() local ItemFrame=CreateItemBaseFrame(8,"_Line"); ItemFrame.BackgroundTransparency=0.7; ItemFrame.BackgroundColor3=Color3.fromRGB(60,60,60);ItemFrame.Size=UDim2.new(1,0,0,2); Custom:Create("UICorner",{CornerRadius=UDim.new(1,0)},ItemFrame); return {Frame=ItemFrame} end

            -- Stubs for other item types - you'll need to implement these fully,
            -- ensuring they call RefreshSectionLayout() when their size might change.
            function SectionAPI:AddButton(btnConfig) local ItemFrame=CreateItemBaseFrame(35,"_Button"); local BtnAPI={Frame=ItemFrame}; ItemFrame.Api=BtnAPI; print("TODO: Implement AddButton fully"); return BtnAPI end
            function SectionAPI:AddToggle(tglConfig) local ItemFrame=CreateItemBaseFrame(35,"_Toggle"); local TglAPI={Frame=ItemFrame, Value=tglConfig.Default or false}; ItemFrame.Api=TglAPI; print("TODO: Implement AddToggle fully"); return TglAPI end
            function SectionAPI:AddSlider(sldConfig) local ItemFrame=CreateItemBaseFrame(50,"_Slider"); local SldAPI={Frame=ItemFrame, Value=sldConfig.Default or 0}; ItemFrame.Api=SldAPI; print("TODO: Implement AddSlider fully"); return SldAPI end
            function SectionAPI:AddInput(inpConfig) local ItemFrame=CreateItemBaseFrame(35,"_Input"); local InpAPI={Frame=ItemFrame, Value=inpConfig.Default or ""}; ItemFrame.Api=InpAPI; print("TODO: Implement AddInput fully"); return InAPI end

            function SectionAPI:AddDropdown(dropConfig)
                itemCreationOrder = itemCreationOrder + 1
                dropdownInstanceCounter = dropdownInstanceCounter + 1 -- Unique ID for this dropdown instance
                local dropdownPageName = "DropdownPage_" .. dropdownInstanceCounter

                local ItemFrame = CreateItemBaseFrame(dropConfig.Content and 45 or 35, "_Dropdown") -- Height based on if content text exists
                local DropdownAPI = { Frame = ItemFrame, Value = dropConfig.Default or (dropConfig.Multi and {} or {}), Options = dropConfig.Options or {} }
                ItemFrame.Api = DropdownAPI -- Attach API for external access

                -- Display for current selection + chevron
                local ClickableArea = Custom:Create("TextButton", {Name="ClickArea", Text="", BackgroundColor3=Color3.fromRGB(50,50,50), BackgroundTransparency=0.5, Size=UDim2.new(1,-30,1,0), Position=UDim2.new(0,0,0,0) }, ItemFrame)
                Custom:Create("UICorner", {CornerRadius=UDim.new(0,4)}, ClickableArea)
                local SelectedTextLabel = Custom:Create("TextLabel",{Name="SelectedValueDisplay", Font=Enum.Font.Gotham, Text="Select...", TextColor3=Color3.fromRGB(200,200,200), TextSize=12, BackgroundTransparency=1, Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,5,0,0), TextXAlignment=Enum.TextXAlignment.Left}, ClickableArea)
                local ChevronIcon = Custom:Create("ImageLabel",{Name="Chevron", Image="rbxassetid://16851841101", ImageColor3=Color3.fromRGB(180,180,180), Size=UDim2.fromOffset(12,12), AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-5,0.5,0), BackgroundTransparency=1}, ClickableArea)

                -- Create the actual scrolling frame for this dropdown's options inside the global popup
                local OptionsScroll = Custom:Create("ScrollingFrame", {Name=dropdownPageName, BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), CanvasSize=UDim2.new(0,0,0,0), ScrollBarThickness=3, ScrollBarImageColor3=Custom.ColorRGB, LayoutOrder=dropdownInstanceCounter}, DropdownPages_ActualFolder)
                local OptionsListLayout = Custom:Create("UIListLayout",{Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center}, OptionsScroll)
                local SearchBar = Custom:Create("TextBox", {Name="SearchBar", Font=Enum.Font.Gotham, PlaceholderText="Search...", TextColor3=Color3.white, TextSize=12, BackgroundColor3=Color3.fromRGB(50,50,50), BackgroundTransparency=0.2, Size=UDim2.new(0.9,0,0,25), LayoutOrder=-1}, OptionsScroll)
                Custom:Create("UICorner",{CornerRadius=UDim.new(0,3)}, SearchBar)


                local function UpdateSelectedTextDisplay()
                    if dropConfig.Multi then
                        SelectedTextLabel.Text = #DropdownAPI.Value > 0 and table.concat(DropdownAPI.Value, ", ") or "Select..."
                        if #DropdownAPI.Value > 2 then SelectedTextLabel.Text = #DropdownAPI.Value .. " selected" end
                    else
                        SelectedTextLabel.Text = #DropdownAPI.Value > 0 and DropdownAPI.Value[1] or "Select..."
                    end
                end

                local function RebuildOptionButtons(searchText)
                    searchText = searchText and searchText:lower() or ""
                    for _,child in ipairs(OptionsScroll:GetChildren()) do if child~=OptionsListLayout and child~=SearchBar then child:Destroy() end end
                    local totalHeight = SearchBar.AbsoluteSize.Y + OptionsListLayout.Padding.Offset
                    for _, optName in ipairs(DropdownAPI.Options) do
                        if searchText == "" or optName:lower():find(searchText) then
                            local isSelected = table.find(DropdownAPI.Value, optName)
                            local OptionBtnFrame = Custom:Create("Frame", {Name=optName, BackgroundColor3=isSelected and Custom.ColorRGB or Color3.fromRGB(55,55,55), BackgroundTransparency=isSelected and 0.3 or 0.6, Size=UDim2.new(0.9,0,0,28)}, OptionsScroll)
                            Custom:Create("UICorner",{CornerRadius=UDim.new(0,3)}, OptionBtnFrame)
                            local OptionBtn = Custom:Create("TextButton",{Text=optName, Font=Enum.Font.Gotham, TextColor3=Color3.white, TextSize=12, BackgroundTransparency=1, Size=UDim2.new(1,0,1,0)}, OptionBtnFrame)
                            OptionBtn.Activated:Connect(function()
                                CircleClick(OptionBtn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                                local valIdx = table.find(DropdownAPI.Value, optName)
                                if dropConfig.Multi then
                                    if valIdx then table.remove(DropdownAPI.Value, valIdx) else table.insert(DropdownAPI.Value, optName) end
                                else
                                    DropdownAPI.Value = {optName}; HideDropdownPopup()
                                end
                                UpdateSelectedTextDisplay()
                                RebuildOptionButtons(SearchBar.Text) -- Rebuild to update selection visuals
                                if dropConfig.Callback then dropConfig.Callback(DropdownAPI.Value) end
                            end)
                            totalHeight = totalHeight + OptionBtnFrame.AbsoluteSize.Y + OptionsListLayout.Padding.Offset
                        end
                    end
                    OptionsScroll.CanvasSize = UDim2.fromOffset(0, math.max(totalHeight - OptionsListLayout.Padding.Offset, DropdownContentHost.AbsoluteSize.Y - 10))
                end
                SearchBar:GetPropertyChangedSignal("Text"):Connect(function() RebuildOptionButtons(SearchBar.Text) end)

                ClickableArea.Activated:Connect(function()
                    Dropdown_UIPageLayout:JumpTo(OptionsScroll)
                    local pos = ClickableArea.AbsolutePosition + Vector2.new(0, ClickableArea.AbsoluteSize.Y + 5)
                    DropdownContentHost.Position = UDim2.fromOffset(pos.X, pos.Y)
                    DropdownContentHost.AnchorPoint = Vector2.new(pos.X / MainScreenGui.AbsoluteSize.X > 0.7 and 1 or 0, 0) -- Anchor right if too far right
                    if DropdownContentHost.AnchorPoint.X == 1 then DropdownContentHost.Position = UDim2.fromOffset(pos.X + ClickableArea.AbsoluteSize.X, pos.Y) end -- Adjust X if anchored right
                    DropdownContentHost.Size = UDim2.fromOffset(math.max(200, ClickableArea.AbsoluteSize.X), 220) -- Match width or min 200
                    DropdownPopupOverlay.Visible = true
                    TweenService:Create(DropdownPopupOverlay,TweenInfo.new(0.15),{BackgroundTransparency=0.7}):Play()
                    RebuildOptionButtons() -- Initial build
                end)

                function DropdownAPI:Set(newValue) DropdownAPI.Value = newValue; UpdateSelectedTextDisplay(); if dropConfig.Callback then dropConfig.Callback(DropdownAPI.Value) end end
                function DropdownAPI:Clear() DropdownAPI:Set(dropConfig.Multi and {} or {}) end
                function DropdownAPI:AddOption(optName) if not table.find(DropdownAPI.Options,optName) then table.insert(DropdownAPI.Options, optName) end end
                function DropdownAPI:Refresh(newOpts, newDef) DropdownAPI.Options=newOpts or DropdownAPI.Options; DropdownAPI:Set(newDef or (dropConfig.Multi and {} or {#DropdownAPI.Options>0 and DropdownAPI.Options[1] or nil})); RebuildOptionButtons() end
                UpdateSelectedTextDisplay() -- Initial text
                return DropdownAPI
            end


            return SectionAPI
        end
        return TabAPI
    end
    return WindowAPI
end

return Speed_Library
