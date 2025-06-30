local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

task.spawn(function()
	pcall(function()
		if game.PlaceId == 3623096087 then
			if game.Workspace:FindFirstChild("RobloxForwardPortals") then
				game.Workspace.RobloxForwardPortals:Destroy()
			end
		end
		loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Main/main/Library/GUI_ADS.lua"))()
	end)
end)

local Custom = {} do
  Custom.ColorRGB = Color3.fromRGB(250, 7, 7)

  function Custom:Create(Name, Properties, Parent)
    local _instance = Instance.new(Name)

    for i, v in pairs(Properties) do
      _instance[i] = v
    end

    if Parent then
      _instance.Parent = Parent
    end

    return _instance
  end

  function Custom:EnabledAFK()
    Player.Idled:Connect(function()
      VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      task.wait(1)
      VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
  end
end

Custom:EnabledAFK()

local function OpenClose()
  local ScreenGui = Custom:Create("ScreenGui", {
    Name = "OpenClose",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  }, RunService:IsStudio() and Player.PlayerGui or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")))

  local Close_ImageButton = Custom:Create("ImageButton", {
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BorderColor3 = Color3.fromRGB(255, 0, 0),
    Position = UDim2.new(0.1021, 0, 0.0743, 0),
    Size = UDim2.new(0, 59, 0, 49),
    Image = "rbxassetid://82140212012109",
    Visible = false
  }, ScreenGui)

  local UICorner = Custom:Create("UICorner", {
    Name = "MainCorner",
    CornerRadius = UDim.new(0, 9),
  }, Close_ImageButton)

  local dragging, dragStart, startPos = false, nil, nil

  local function UpdateDraggable(input)
    local delta = input.Position - dragStart
    Close_ImageButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
  end

  Close_ImageButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
      dragging = true
      dragStart = input.Position
      startPos = Close_ImageButton.Position

      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          dragging = false
        end
      end)
    end
  end)

  Close_ImageButton.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
      UpdateDraggable(input)
    end
  end)

  return Close_ImageButton
end

local Open_Close = OpenClose()

local function MakeDraggable(topbarobject, object)
  local dragging, dragStart, startPos = false, nil, nil

  local function UpdatePos(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    object.Position = newPos
  end

  topbarobject.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      dragStart = input.Position
      startPos = object.Position

      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          dragging = false
        end
      end)
    end
  end)

  topbarobject.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
      UpdatePos(input)
    end
  end)
end

function CircleClick(Button, X, Y)
	task.spawn(function()
		Button.ClipsDescendants = true
		
		local Circle = Instance.new("ImageLabel")
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
		Circle.ImageTransparency = 0.8999999761581421
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Name = "Circle"
		Circle.Parent = Button
		
		local NewX = X - Button.AbsolutePosition.X
		local NewY = Y - Button.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)

		local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5

		local Time = 0.5
		local TweenInfo = TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local Tween = TweenService:Create(Circle, TweenInfo, {
			Size = UDim2.new(0, Size, 0, Size),
			Position = UDim2.new(0.5, -Size/2, 0.5, -Size/2)
		})
		
		Tween:Play()
		
		Tween.Completed:Connect(function()
			for i = 1, 10 do
				Circle.ImageTransparency = Circle.ImageTransparency + 0.01
				wait(Time / 10)
			end
			Circle:Destroy()
		end)
	end)
end

local Speed_Library, Notification = {}, {}

Speed_Library.Unloaded = false

function Speed_Library:SetNotification(Config)
  local Title = Config[1] or Config.Title or ""
  local Description = Config[2] or Config.Description or ""
	local Content = Config[3] or Config.Content or ""
  local Time = Config[5] or Config.Time or 0.5
  local Delay = Config[6] or Config.Delay or 5

  local NotificationGui = Custom:Create("ScreenGui", {
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Name = "NotificationGui"
  }, game:GetService("CoreGui"))

  local NotificationLayout = Custom:Create("Frame", {
    AnchorPoint = Vector2.new(1, 1),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.999,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(1, -30, 1, -30),
    Size = UDim2.new(0, 320, 1, 0),
    Name = "NotificationLayout"
  }, NotificationGui)

  local Count = 0

  NotificationLayout.ChildRemoved:Connect(function()
    Count = 0
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    
    for _, v in ipairs(NotificationLayout:GetChildren()) do
      local NewPOS = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * Count))
      local tween = TweenService:Create(v, tweenInfo, {Position = NewPOS})
      tween:Play()
      Count = Count + 1
    end
  end)

  local _Count = 0
  for _, v in ipairs(NotificationLayout:GetChildren()) do
    _Count = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
  end

  local NotificationFrame = Custom:Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 150),
    Name = "NotificationFrame",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 0, 1, -(_Count))
  }, NotificationLayout)

  local NotificationFrameReal = Custom:Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 400, 0, 0),
    Size = UDim2.new(1, 0, 1, 0),
    Name = "NotificationFrameReal"
  }, NotificationFrame)

  Custom:Create("UICorner", {
    CornerRadius = UDim.new(0, 8)
  }, NotificationFrameReal)

  local DropShadowHolder = Custom:Create("Frame", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, 0),
    ZIndex = 0,
    Name = "DropShadowHolder",
    Parent = NotificationFrameReal
  })

  local DropShadow = Custom:Create("ImageLabel", {
    Image = "rbxassetid://6015897843",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.5,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(1, 47, 1, 47),
    ZIndex = 0,
    Name = "DropShadow",
    Parent = DropShadowHolder
  })
 
  local Top = Custom:Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.999,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 36),
    Name = "Top",
    Parent = NotificationFrameReal
  })

  local TextLabel = Custom:Create("TextLabel", {
    Font = Enum.Font.GothamBold,
    Text = Title,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.999,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    Parent = Top
  })

  Custom:Create("UIStroke", {
    Color = Color3.fromRGB(255, 255, 255),
    Thickness = 0.3,
    Parent = TextLabel
  })

  Custom:Create("UICorner", {
    Parent = Top,
    CornerRadius = UDim.new(0, 5)
  })

  local TextLabel1 = Custom:Create("TextLabel", {
    Font = Enum.Font.GothamBold,
    Text = Description,
    TextColor3 = Custom.ColorRGB,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.999,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0),
    Parent = Top
  })

  Custom:Create("UIStroke", {
    Color = Custom.ColorRGB,
    Thickness = 0.4,
    Parent = TextLabel1
  })

  local Close = Custom:Create("TextButton", {
    Font = Enum.Font.SourceSans,
    Text = "",
    TextColor3 = Color3.fromRGB(0, 0, 0),
    TextSize = 14,
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.999,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(1, -5, 0.5, 0),
    Size = UDim2.new(0, 25, 0, 25),
    Name = "Close",
    Parent = Top
  })

  local ImageLabel = Custom:Create("ImageLabel", {
    Image = "rbxassetid://9886659671",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.999,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0.49, 0, 0.5, 0),
    Size = UDim2.new(1, -8, 1, -8),
    Parent = Close
  })

  local TextLabel2 = Custom:Create("TextLabel", {
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 13,
    Text = Content,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.999,
    TextColor3 = Color3.fromRGB(150, 150, 150),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 10, 0, 27),
    Size = UDim2.new(1, -20, 0, 13),
    Parent = NotificationFrameReal
  })

  TextLabel2.Size = UDim2.new(1, -20, 0, 13 + (13 * (TextLabel2.TextBounds.X // TextLabel2.AbsoluteSize.X)))
  TextLabel2.TextWrapped = true

  if TextLabel2.AbsoluteSize.Y < 27 then
    NotificationFrame.Size = UDim2.new(1, 0, 0, 65)
  else
    NotificationFrame.Size = UDim2.new(1, 0, 0, TextLabel2.AbsoluteSize.Y + 40)
  end

  local Waitted = false

  function Notification:Close()
    if Waitted then return false end
    Waitted = true

    local tween = TweenService:Create(NotificationFrameReal,TweenInfo.new(tonumber(Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut),{Position = UDim2.new(0, 400, 0, 0)})
    tween:Play()

    task.wait(tonumber(Time) / 1.2)

    NotificationFrame:Destroy()

    Waitted = false
  end

  Close.Activated:Connect(function()
    Notification:Close()
	end)

  TweenService:Create(NotificationFrameReal, TweenInfo.new(tonumber(Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0, 0, 0)} ):Play()
  task.wait(tonumber(Delay))
  Notification:Close()

  return Notification
end

function Speed_Library:CreateWindow(Config)
  local Title = Config[1] or Config.Title or ""
  local Description = Config[2] or Config.Description or ""
  local TabWidth = Config[3] or Config["Tab Width"] or 120
  local SizeUi = Config[4] or Config.SizeUi or UDim2.fromOffset(550, 315)

  local Funcs = {}

  local SpeedHubXGui = Custom:Create("ScreenGui", {
    Name = "SpeedHubXGui",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  }, RunService:IsStudio() and LocalPlayer.PlayerGui or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")))

  local DropShadowHolder = Custom:Create("Frame", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 455, 0, 350),
    ZIndex = 0,
    Name = "DropShadowHolder",
    Position = UDim2.new(0, (SpeedHubXGui.AbsoluteSize.X // 2 - 455 // 2), 0, (SpeedHubXGui.AbsoluteSize.Y // 2 - 350 // 2))
  }, SpeedHubXGui)

  local DropShadow = Custom:Create("ImageLabel", {
    Image = "rbxassetid://6015897843",
    ImageColor3 = Color3.fromRGB(15, 15, 15),
    ImageTransparency = 0.5,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = SizeUi,
    ZIndex = 0,
    Name = "DropShadow"
  }, DropShadowHolder)

  local Main = Custom:Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.1,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = SizeUi,
    Name = "Main"
  }, DropShadow)

  Custom:Create("UICorner", {}, Main)

  Custom:Create("UIStroke", {
    Color = Color3.fromRGB(50, 50, 50),
    Thickness = 1.6
  }, Main)

  local Top = Custom:Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 38),
    Name = "Top"
  }, Main)

  local TextLabel = Custom:Create("TextLabel", {
    Font = Enum.Font.GothamBold,
    Text = Title,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.new(0, 10, 0, 0)
  }, Top)

  Custom:Create("UICorner", {}, Top)

  local TextLabel1 = Custom:Create("TextLabel", {
    Font = Enum.Font.GothamBold,
    Text = Description,
    TextColor3 = Custom.ColorRGB,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0),
    Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
  }, Top)

  Custom:Create("UIStroke", {
    Color = Custom.ColorRGB,
    Thickness = 0.4
  }, TextLabel1)

  local Close = Custom:Create("TextButton", {
    Font = Enum.Font.SourceSans,
    Text = "",
    TextColor3 = Color3.fromRGB(0, 0, 0),
    TextSize = 14,
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(1, -8, 0.5, 0),
    Size = UDim2.new(0, 25, 0, 25),
    Name = "Close"
  }, Top)

  local ImageLabel1 = Custom:Create("ImageLabel", {
    Image = "rbxassetid://9886659671",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0.49, 0, 0.5, 0),
    Size = UDim2.new(1, -8, 1, -8)
  }, Close)

  local Min = Custom:Create("TextButton", {
    Font = Enum.Font.SourceSans,
    Text = "",
    TextColor3 = Color3.fromRGB(0, 0, 0),
    TextSize = 14,
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(1, -42, 0.5, 0),
    Size = UDim2.new(0, 25, 0, 25),
    Name = "Min"
  }, Top)

  Custom:Create("ImageLabel", {
    Image = "rbxassetid://9886659276",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(1, -8, 1, -8)
  }, Min)

  local LayersTab = Custom:Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 9, 0, 50),
    Size = UDim2.new(0, TabWidth, 1, -59),
    Name = "LayersTab"
  }, Main)

  Custom:Create("UICorner", {
    CornerRadius = UDim.new(0, 2)
  }, LayersTab)

  Custom:Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.85,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0, 38),
    Size = UDim2.new(1, 0, 0, 1),
    Name = "DecideFrame"
  }, Main)

  local Layers = Custom:Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0, TabWidth + 18, 0, 50),
    Size = UDim2.new(1, -(TabWidth + 9 + 18), 1, -59),
    Name = "Layers"
  }, Main)

  Custom:Create("UICorner", {
    CornerRadius = UDim.new(0, 2)
  }, Layers)

  local NameTab = Custom:Create("TextLabel", {
    Font = Enum.Font.GothamBold,
    Text = "",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 24,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 30),
    Name = "NameTab"
  }, Layers)

  local LayersReal = Custom:Create("Frame", {
    AnchorPoint = Vector2.new(0, 1),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.new(0, 0, 1, 0),
    Size = UDim2.new(1, 0, 1, -33),
    Name = "LayersReal"
  }, Layers)

  local LayersFolder = Custom:Create("Folder", {
    Name = "LayersFolder"
  }, LayersReal)

  local LayersPageLayout = Custom:Create("UIPageLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Name = "LayersPageLayout",
    TweenTime = 0.5,
    EasingDirection = Enum.EasingDirection.InOut,
    EasingStyle = Enum.EasingStyle.Quad
  }, LayersFolder)

  local ScrollTab = Custom:Create("ScrollingFrame", {
    CanvasSize = UDim2.new(0, 0, 2.10000002, 0),
    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
    ScrollBarThickness = 0,
    Active = true,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, -10),
    Name = "ScrollTab"
  }, LayersTab)

  local UIListLayout = Custom:Create("UIListLayout", {
    Padding = UDim.new(0, 0),
    SortOrder = Enum.SortOrder.LayoutOrder
  }, ScrollTab)

  local function UpdateSize()
    local _Total = 0

		for _, v in pairs(ScrollTab:GetChildren()) do
			if v.Name ~= "UIListLayout" then
				_Total = _Total + 3 + v.Size.Y.Offset
			end
		end

		ScrollTab.CanvasSize = UDim2.new(0, 0, 0, _Total)
  end

  ScrollTab.ChildAdded:Connect(UpdateSize)
  ScrollTab.ChildRemoved:Connect(UpdateSize)

  Min.Activated:Connect(function()
		CircleClick(Min, Player:GetMouse().X, Player:GetMouse().Y)
		DropShadowHolder.Visible = false

		if not Open_Close.Visible then Open_Close.Visible = true end
	end)

  Open_Close.Activated:Connect(function()
		DropShadowHolder.Visible = true
		if Open_Close.Visible then Open_Close.Visible = false end
	end)

  Close.Activated:Connect(function()
		CircleClick(Close, Player:GetMouse().X, Player:GetMouse().Y)
    if SpeedHubXGui then SpeedHubXGui:Destroy() end
		if not Speed_Library.Unloaded then Speed_Library.Unloaded = true end
	end)

  DropShadowHolder.Size = UDim2.new(0, 115 + TextLabel.TextBounds.X + 1 + TextLabel1.TextBounds.X, 0, 350)
	MakeDraggable(Top, DropShadowHolder)

  local function _Internal_Create_SHX_Dropdown(parentFrameForItems, DropdownConfig, extResources)
    -- extResources expected: Custom, DropdownFolder, DropPageLayout, MoreBlur, DropdownSelect,
    -- circleClick (global), PlayerMouse (via getter), TweenService (global),
    -- itemCount (direct value), countDropdownRef (passed as {Value=...})
    -- updateParentSizeFunc (optional callback from caller)

    local Config = DropdownConfig or {}
    Config.Title = Config.Title or "No Title"
    Config.Content = Config.Content or ""
    Config.Multi = Config.Multi or false
    Config.Options = Config.Options or {}
    Config.Default = Config.Default or (Config.Multi and {} or nil)
    Config.Callback = Config.Callback or function() end

    local DropdownFunc = {Value = Config.Default, Options = Config.Options}

    local DropdownFrame = extResources.Custom.Create("Frame", {
        Name = "Dropdown",
        Parent = parentFrameForItems,
        LayoutOrder = extResources.itemCount,
        Size = UDim2.new(1,0,0,35),
        BackgroundTransparency = 0.935,
        BackgroundColor3 = Color3.fromRGB(40,40,40)
    })
    if parentFrameForItems then DropdownFrame.Parent = parentFrameForItems end
    extResources.Custom.Create("UICorner", {CornerRadius = UDim.new(0,4)}, DropdownFrame)

    local DropdownTitle = extResources.Custom.Create("TextLabel", {
        Name = "DropdownTitle", Font = Enum.Font.GothamBold, Text = Config.Title,
        TextColor3 = Color3.fromRGB(230,230,230), TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        BackgroundTransparency=1, Position = UDim2.new(0,10,0,10), Size = UDim2.new(1,-180,0,13)
    }, DropdownFrame)

    local DropdownContent = extResources.Custom.Create("TextLabel", {
        Name = "DropdownContent", Font = Enum.Font.GothamBold, Text = Config.Content,
        TextColor3 = Color3.fromRGB(255,255,255), TextSize = 12, TextTransparency = 0.6,
        TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom,
        BackgroundTransparency=1, Position = UDim2.new(0,10,0,23), Size = UDim2.new(1,-180,0,12)
    }, DropdownFrame)

    task.delay(0, function()
        if not DropdownContent or not DropdownContent.Parent then return end
        DropdownContent.TextWrapped = false
        local textSizeX = DropdownContent.TextBounds.X
        local frameWidth = DropdownContent.AbsoluteSize.X > 0 and DropdownContent.AbsoluteSize.X or 1
        local lines = math.max(1, math.ceil(textSizeX / frameWidth))
        local contentHeight = lines * 12
        DropdownContent.Size = UDim2.new(1, -180, 0, contentHeight)
        if DropdownFrame and DropdownFrame.Parent then
             DropdownFrame.Size = UDim2.new(1, 0, 0, math.max(35, 10 + (DropdownTitle and DropdownTitle.TextBounds.Y or 13) + 5 + contentHeight + 10))
        end
        DropdownContent.TextWrapped = true
        if extResources.updateParentSizeFunc then extResources.updateParentSizeFunc() end
    end)

    local SelectOptionsFrame = extResources.Custom.Create("Frame", {
        Name = "SelectOptionsFrame", AnchorPoint = Vector2.new(1,0.5),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        BackgroundTransparency = 0.95, BorderSizePixel = 0,
        Position = UDim2.new(1,-7,0.5,0), Size = UDim2.new(0,148,0,30),
        LayoutOrder = extResources.countDropdownRef.Value
    }, DropdownFrame)
    extResources.Custom.Create("UICorner",{CornerRadius = UDim.new(0,4)}, SelectOptionsFrame)

    local OptionSelecting = extResources.Custom.Create("TextLabel", {
        Name = "OptionSelecting", Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 12, TextTransparency = 0.6, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
        AnchorPoint = Vector2.new(0,0.5), BackgroundTransparency = 1,
        Position = UDim2.new(0,5,0.5,0), Size = UDim2.new(1,-30,1,-8)
    }, SelectOptionsFrame)

    extResources.Custom.Create("ImageLabel", {
        Name = "OptionImg", Image = "rbxassetid://16851841101",
        ImageColor3 = Color3.fromRGB(231,231,231), AnchorPoint = Vector2.new(1,0.5),
        BackgroundTransparency=1, Position = UDim2.new(1,0,0.5,0), Size = UDim2.new(0,25,0,25)
    }, SelectOptionsFrame)

    local DropdownButton = extResources.Custom.Create("TextButton", {
        Name = "DropdownButton", Text = "", Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1
    }, DropdownFrame)

    local currentDropdownID = extResources.countDropdownRef.Value
    extResources.countDropdownRef.Value = extResources.countDropdownRef.Value + 1

    local DropdownContainer = extResources.DropdownFolder:FindFirstChild("DropdownContainer_"..tostring(currentDropdownID))
    if not DropdownContainer then
        DropdownContainer = extResources.Custom.Create("Frame", { Name = "DropdownContainer_"..tostring(currentDropdownID), Parent = extResources.DropdownFolder, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0) })
        local SearchBar = extResources.Custom.Create("TextBox", {
            Name = "SearchBar_Dropdown", Parent = DropdownContainer, Font = Enum.Font.GothamBold, PlaceholderText = "Search",
            PlaceholderColor3 = Color3.fromRGB(120,120,120), Text = "", TextColor3 = Color3.fromRGB(255,255,255), TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.9, BorderColor3 = Custom.ColorRGB, BorderSizePixel = 1,
            Size = UDim2.new(1,-10,0,20), Position = UDim2.new(0,5,0,5)
        })
        local ScrollSel = extResources.Custom.Create("ScrollingFrame", {
            Name = "ScrollSelect", Parent = DropdownContainer, CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 0, Active = true,
            Position = UDim2.new(0,0,0,25), BackgroundTransparency=1, Size = UDim2.new(1,0,1,-25)
        })
        extResources.Custom.Create("UIListLayout", { Parent = ScrollSel, Padding = UDim.new(0,3), SortOrder = Enum.SortOrder.LayoutOrder })

        SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
            local s = SearchBar.Text:lower()
            for _,oF in ipairs(ScrollSel:GetChildren()) do
                if oF:IsA("Frame") and oF.Name == "Option" then
                    local oT = oF:FindFirstChild("OptionText")
                    if oT then oF.Visible = (s == "" or oT.Text:lower():find(s,1,true)) end
                end
            end
        end)
    end

    local ScrollSelect_Instance = DropdownContainer:FindFirstChild("ScrollSelect")
    local UIListLayout_Scroll_Instance -- Define it here to be captured by AddOption and Refresh
	if ScrollSelect_Instance then UIListLayout_Scroll_Instance = ScrollSelect_Instance:FindFirstChildOfClass("UIListLayout") end

    if not ScrollSelect_Instance then warn("SHX_InternalDropdown: ScrollSelect_Instance not found for DropdownContainer: " .. DropdownContainer.Name) end
    if not UIListLayout_Scroll_Instance then warn("SHX_InternalDropdown: UIListLayout_Scroll_Instance not found in ScrollSelect_Instance for DropdownContainer: " .. DropdownContainer.Name) end

    DropdownButton.Activated:Connect(function()
        CircleClick(DropdownButton, Player:GetMouse().X, Player:GetMouse().Y)
        if not extResources.MoreBlur.Visible then
            extResources.MoreBlur.Visible = true
            extResources.DropPageLayout:JumpTo(DropdownContainer)
            TweenService:Create(extResources.MoreBlur, TweenInfo.new(0.2),{BackgroundTransparency = 0.7}):Play()
            TweenService:Create(extResources.DropdownSelect, TweenInfo.new(0.2),{Position = UDim2.new(1,-11,0.5,0)}):Play()
        end
    end)

    local dropCountLocal = 0
    function DropdownFunc:Clear()
        if not ScrollSelect_Instance then return end
        for i = #ScrollSelect_Instance:GetChildren(), 1, -1 do
            local child = ScrollSelect_Instance:GetChildren()[i]
            if child.Name == "Option" then child:Destroy() end
        end
        DropdownFunc.Value={}; DropdownFunc.Options={}; OptionSelecting.Text = "Select Options"; dropCountLocal = 0
        ScrollSelect_Instance.CanvasSize = UDim2.new(0,0,0,0)
    end

    function DropdownFunc:AddOption(oN)
        if not ScrollSelect_Instance  then
            warn("SHX_InternalDropdown:AddOption - ScrollSelect_Instance is nil. Cannot add option.")
            return
        end
        oN = oN or "Option"
        local oF = extResources.Custom.Create("Frame", { Name="Option", Size=UDim2.new(1,0,0,30), BackgroundTransparency=0.97, BackgroundColor3=Color3.fromRGB(45,45,45), Parent = ScrollSelect_Instance})
        extResources.Custom.Create("UICorner",{CornerRadius=UDim.new(0,3)},oF)
        local oB = extResources.Custom.Create("TextButton",{Name="OptionButton", Text="", Size=UDim2.new(1,0,1,0), BackgroundTransparency=1},oF)
        extResources.Custom.Create("TextLabel",{Name="OptionText", Font=Enum.Font.GothamBold, Text=oN, TextColor3=Color3.fromRGB(230,230,230), TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1, Position=UDim2.new(0,8,0,8), Size=UDim2.new(1,-16,1,-16)},oF)
        local cF = extResources.Custom.Create("Frame",{Name="ChooseFrame", AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=Custom.ColorRGB, BorderSizePixel=0, Position=UDim2.new(0,2,0.5,0), Size=UDim2.new(0,0,0,0)},oF)
        extResources.Custom.Create("UICorner",{CornerRadius=UDim.new(0,3)},cF)
        extResources.Custom.Create("UIStroke",{Color=Custom.ColorRGB, Thickness=1.6, Transparency=1},cF)
        dropCountLocal=dropCountLocal+1; oF.LayoutOrder=dropCountLocal

        oB.Activated:Connect(function()
            CircleClick(oB, Player:GetMouse().X, Player:GetMouse().Y)
            if Config.Multi then
                local fI=table.find(DropdownFunc.Value,oN)
                if fI then table.remove(DropdownFunc.Value,fI) else table.insert(DropdownFunc.Value,oN) end
            else
                DropdownFunc.Value={oN}
            end
            DropdownFunc:Set(DropdownFunc.Value)
        end)

        -- Manual CanvasSize calculation (UpdateCanvasSize function and its call) removed from AddOption.
        -- It will be handled by UIListLayout.AbsoluteContentSize in Refresh.
    end

    function DropdownFunc:Set(val)
        if not ScrollSelect_Instance then return end
        if val then
            local nV=type(val)=="table" and val or {val}
            local uV={}; for _,v_u in ipairs(nV) do if not table.find(uV,v_u) then table.insert(uV,v_u) end end
            DropdownFunc.Value=uV
        end
        for _,d_S in ipairs(ScrollSelect_Instance:GetChildren()) do
            if d_S:IsA("Frame") and d_S.Name=="Option" then
                local optionTextInstance = d_S:FindFirstChild("OptionText")
                if not optionTextInstance then continue end
                local iTF=DropdownFunc.Value and table.find(DropdownFunc.Value, optionTextInstance.Text)
                local tII=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut)
                local s_S=iTF and UDim2.new(0,1,0,12) or UDim2.new(0,0,0,0)
                local bT_S=iTF and 0.935 or 0.97; local tr_S=iTF and 0 or 0.999
                local chooseFrame = d_S:FindFirstChild("ChooseFrame")
                if chooseFrame then
                    TweenService:Create(chooseFrame,tII,{Size=s_S}):Play()
                    local chooseFrameStroke = chooseFrame:FindFirstChildOfClass("UIStroke")
                    if chooseFrameStroke then TweenService:Create(chooseFrameStroke,tII,{Transparency=tr_S}):Play() end
                end
                TweenService:Create(d_S,tII,{BackgroundTransparency=bT_S}):Play()
            end
        end
        local dT=(DropdownFunc.Value and #DropdownFunc.Value>0) and table.concat(DropdownFunc.Value,", ") or "Select Options"
        OptionSelecting.Text=dT
        if Config.Callback then Config.Callback(DropdownFunc.Value or {}) end
    end

    function DropdownFunc:Refresh(rL,sEl)
        rL=rL or {}; sEl=sEl or Config.Default
        DropdownFunc:Clear()
        DropdownFunc.Options=rL
        for _,oR in pairs(rL) do DropdownFunc:AddOption(oR) end
        DropdownFunc.Value=nil; DropdownFunc:Set(sEl)

        -- Set CanvasSize after all options are added
        task.defer(function()
            if ScrollSelect_Instance then
                -- Re-fetch UIListLayout_Scroll_Instance here as it's critical
                local currentLayout = ScrollSelect_Instance:FindFirstChildOfClass("UIListLayout")
                if currentLayout then
                    ScrollSelect_Instance.CanvasSize = UDim2.new(0,0,0, currentLayout.AbsoluteContentSize.Y)
                else
                    warn("_Internal_Create_SHX_Dropdown:Refresh - Could not find UIListLayout in ScrollSelect_Instance for CanvasSize.")
                end
            else
                 warn("_Internal_Create_SHX_Dropdown:Refresh - ScrollSelect_Instance was nil. Cannot set CanvasSize.")
            end
        end)
    end

    DropdownFunc:Refresh(Config.Options, Config.Default)

    return DropdownFunc
  end

  -- /// Blur
>>>>>>> REPLACE
