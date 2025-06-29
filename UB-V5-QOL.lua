local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()
local ProtectGui = protectgui or (syn and syn.protect_gui) or function(f) end
local CoreGui = cloneref(gethui()) or game:GetService("CoreGui")
local SizeUI = UDim2.new(0, 550, 0, 350)
LibraryCfg = {
	ShowPlayer = false,
	Undetected = false
}
UBDir = _G.Service or "UBHub5"
local Themes = {
    UB_Orange = {
        Primary = Color3.fromRGB(130, 30, 5),
        Secondary = Color3.fromRGB(115, 25, 5),
        Accent = Color3.fromRGB(155, 60, 25),
        ThemeHighlight = Color3.fromRGB(175, 75, 30),
        Text = Color3.fromRGB(235, 220, 210),
        Background = Color3.fromRGB(16, 6, 2),
        Stroke = Color3.fromRGB(65, 16, 5),
    },
    Blue = {
        Primary = Color3.fromRGB(15, 40, 85),
        Secondary = Color3.fromRGB(10, 30, 65),
        Accent = Color3.fromRGB(30, 70, 110),
        ThemeHighlight = Color3.fromRGB(50, 95, 140),
        Text = Color3.fromRGB(220, 230, 240),
        Background = Color3.fromRGB(5, 10, 20),
        Stroke = Color3.fromRGB(15, 30, 60),
    },
    Green = {
        Primary = Color3.fromRGB(15, 80, 40),
        Secondary = Color3.fromRGB(10, 60, 30),
        Accent = Color3.fromRGB(30, 100, 55),
        ThemeHighlight = Color3.fromRGB(50, 120, 75),
        Text = Color3.fromRGB(215, 235, 220),
        Background = Color3.fromRGB(4, 12, 6),
        Stroke = Color3.fromRGB(10, 45, 25),
    },
    Yellow = {
        Primary = Color3.fromRGB(100, 75, 10),
        Secondary = Color3.fromRGB(85, 65, 8),
        Accent = Color3.fromRGB(130, 100, 25),
        ThemeHighlight = Color3.fromRGB(150, 115, 40),
        Text = Color3.fromRGB(235, 225, 200),
        Background = Color3.fromRGB(12, 10, 4),
        Stroke = Color3.fromRGB(60, 45, 15),
    },
	Gray = {
		Primary = Color3.fromRGB(80, 80, 80),
		Secondary = Color3.fromRGB(60, 60, 60),
		Accent = Color3.fromRGB(100, 100, 100),
		ThemeHighlight = Color3.fromRGB(130, 130, 130),
		Text = Color3.fromRGB(230, 230, 230),
		Background = Color3.fromRGB(20, 20, 20),
		Stroke = Color3.fromRGB(50, 50, 50),
	},
	Purple = {
		Primary = Color3.fromRGB(90, 60, 130),
		Secondary = Color3.fromRGB(70, 45, 110),
		Accent = Color3.fromRGB(120, 80, 160),
		ThemeHighlight = Color3.fromRGB(145, 100, 185),
		Text = Color3.fromRGB(235, 225, 245),
		Background = Color3.fromRGB(15, 10, 20),
		Stroke = Color3.fromRGB(60, 40, 90),
	},
	Pink = {
		Primary = Color3.fromRGB(160, 60, 90),
		Secondary = Color3.fromRGB(130, 45, 70),
		Accent = Color3.fromRGB(190, 85, 115),
		ThemeHighlight = Color3.fromRGB(215, 110, 140),
		Text = Color3.fromRGB(245, 230, 235),
		Background = Color3.fromRGB(20, 10, 15),
		Stroke = Color3.fromRGB(90, 30, 50),
	},
	Brown = {
		Primary = Color3.fromRGB(100, 70, 40),
		Secondary = Color3.fromRGB(80, 55, 30),
		Accent = Color3.fromRGB(130, 95, 60),
		ThemeHighlight = Color3.fromRGB(160, 120, 75),
		Text = Color3.fromRGB(235, 225, 215),
		Background = Color3.fromRGB(18, 12, 8),
		Stroke = Color3.fromRGB(60, 40, 25),
	},
	Teal = {
		Primary = Color3.fromRGB(30, 100, 100),
		Secondary = Color3.fromRGB(20, 80, 80),
		Accent = Color3.fromRGB(50, 130, 130),
		ThemeHighlight = Color3.fromRGB(70, 160, 160),
		Text = Color3.fromRGB(220, 240, 240),
		Background = Color3.fromRGB(8, 18, 18),
		Stroke = Color3.fromRGB(25, 60, 60),
	},
	Black = {
		Primary = Color3.fromRGB(30, 30, 30),
		Secondary = Color3.fromRGB(20, 20, 20),
		Accent = Color3.fromRGB(50, 50, 50),
		ThemeHighlight = Color3.fromRGB(70, 70, 70),
		Text = Color3.fromRGB(230, 230, 230),
		Background = Color3.fromRGB(10, 10, 10),
		Stroke = Color3.fromRGB(60, 60, 60),
	},
	Orange = {
		Primary = Color3.fromRGB(200, 100, 30),
		Secondary = Color3.fromRGB(170, 85, 25),
		Accent = Color3.fromRGB(220, 120, 50),
		ThemeHighlight = Color3.fromRGB(240, 140, 70),
		Text = Color3.fromRGB(245, 230, 215),
		Background = Color3.fromRGB(25, 12, 4),
		Stroke = Color3.fromRGB(90, 45, 15),
	},
	Cyan = {
		Primary = Color3.fromRGB(20, 140, 160),
		Secondary = Color3.fromRGB(15, 110, 130),
		Accent = Color3.fromRGB(40, 170, 190),
		ThemeHighlight = Color3.fromRGB(60, 200, 220),
		Text = Color3.fromRGB(220, 245, 250),
		Background = Color3.fromRGB(8, 18, 20),
		Stroke = Color3.fromRGB(25, 70, 80),
	},
	Beige = {
		Primary = Color3.fromRGB(190, 170, 140),       
		Secondary = Color3.fromRGB(170, 150, 120),
		Accent = Color3.fromRGB(210, 190, 160),      
		ThemeHighlight = Color3.fromRGB(230, 210, 180),
		Text = Color3.fromRGB(50, 40, 30),           
		Background = Color3.fromRGB(240, 235, 225), 
		Stroke = Color3.fromRGB(150, 130, 100)     
	},
	Red = {
		Primary = Color3.fromRGB(140, 25, 25),
		Secondary = Color3.fromRGB(110, 20, 20),
		Accent = Color3.fromRGB(170, 50, 50),
		ThemeHighlight = Color3.fromRGB(190, 70, 70),
		Text = Color3.fromRGB(235, 220, 220),
		Background = Color3.fromRGB(12, 5, 5),
		Stroke = Color3.fromRGB(70, 15, 15),
	},
	Lime = {
        Primary = Color3.fromRGB(80, 130, 20),
        Secondary = Color3.fromRGB(65, 110, 15),
        Accent = Color3.fromRGB(100, 160, 35),
        ThemeHighlight = Color3.fromRGB(130, 190, 55),
        Text = Color3.fromRGB(235, 245, 225),
        Background = Color3.fromRGB(10, 15, 5),
        Stroke = Color3.fromRGB(50, 80, 25),
    },
    Rose = {
        Primary = Color3.fromRGB(160, 60, 80),
        Secondary = Color3.fromRGB(135, 50, 65),
        Accent = Color3.fromRGB(185, 85, 105),
        ThemeHighlight = Color3.fromRGB(210, 105, 125),
        Text = Color3.fromRGB(245, 225, 230),
        Background = Color3.fromRGB(20, 10, 12),
        Stroke = Color3.fromRGB(90, 30, 40),
    },
    Violet = {
        Primary = Color3.fromRGB(110, 60, 180),
        Secondary = Color3.fromRGB(90, 50, 150),
        Accent = Color3.fromRGB(135, 90, 200),
        ThemeHighlight = Color3.fromRGB(160, 115, 220),
        Text = Color3.fromRGB(240, 230, 250),
        Background = Color3.fromRGB(15, 10, 25),
        Stroke = Color3.fromRGB(70, 40, 120),
    }
}
local CurrentTheme = "UB_Orange"
local ThemeElements = {}
function GetThemes()
	local themenames = {}
	for theme, _ in pairs(Themes) do
		table.insert(themenames,theme)
	end
	return themenames
end
local function GetColor(colorName, element, property)
    if element and property then
        table.insert(ThemeElements, {
            element = element,
            property = property,
            colorName = colorName
        })
    end
    if Themes[CurrentTheme] and Themes[CurrentTheme][colorName] then
        return Themes[CurrentTheme][colorName]
    else
		return Color3.fromRGB(130, 30, 5)
    end
end
function SetTheme(themeName)
    CurrentTheme = themeName
    for _, sub in ipairs(ThemeElements) do
		local ok, err = pcall(function()
			sub.element[sub.property] = Themes[CurrentTheme][sub.colorName]
		end)
		if not ok then
			warn("Theme application failed:", err)
		end
	end
end
local function GetImageLink(ID)
    local success, result = pcall(function()
        return game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds="..ID.."&size=420x420&format=Png&isCircular=false")
    end)
    if not success then return nil end
    local Data = HttpService:JSONDecode(result)
    local info = Data and Data.data and Data.data[1]
    return info and info.imageUrl or nil
end
function LoadUIAsset(url, name)
    if not url or not name then
        warn("Missing URL or name")
        return "rbxassetid://0"
    end
    if not LibraryCfg.Undetected then
        return url
    end
    local assetid = url:match("rbxassetid://(%d+)")
    if assetid then
        local imageURL = GetImageLink(assetid)
        if imageURL then
            url = imageURL
        end
    end
    local baseFolder = "UBHub5"
    local mediaFolder = "UI_Media"
    if not isfolder(baseFolder) then
        makefolder(baseFolder)
    end
    if not isfolder(baseFolder.."/"..mediaFolder) then
        makefolder(baseFolder.."/"..mediaFolder)
    end
    local extension = url:match("%.(%w+)$") or "png"
    if not name:match("%..+$") then
        name = name .. "." .. extension
    end
    local filePath = baseFolder.."/"..mediaFolder.."/"..name
    if isfile(filePath) then
        return getcustomasset(filePath)
    end
    local success, err = pcall(function()
        local data = game:HttpGet(url, true)
        writefile(filePath, data)
    end)
    if not success then
        warn("UI Asset failed to load!", err)
        return "rbxassetid://0"
    end
    return getcustomasset(filePath)
end
local function MakeDraggable(topbarobject, object)
	local function CustomPos(topbarobject, object)
		object.Size = UDim2.new(0, 550, 0, 350)
		local Dragging = nil
		local DragInput = nil
		local DragStart = nil
		local StartPosition = nil
		local LastPosition = nil
		local Tween = nil

		local function UpdatePos(input)
			local Delta = input.Position - DragStart
			local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
			if Tween then Tween:Cancel() end
			Tween = TweenService:Create(object,TweenInfo.new(0.03, Enum.EasingStyle.Linear),{Position = pos})Tween:Play()
		end

		topbarobject.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position
				if Tween then Tween:Cancel() end
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)

		topbarobject.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				DragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then
				UpdatePos(input)
			end
		end)
	end
	CustomPos(topbarobject, object)
end
function CircleClick(Button, X, Y)
	spawn(function()
		Button.ClipsDescendants = true
		local Circle = Instance.new("ImageLabel")
		Circle.Image = LoadUIAsset("rbxassetid://266543268", "Circle.png")
		Circle.ImageColor3 = GetColor("ThemeHighlight",Circle,ImageColor3)
		Circle.ImageTransparency = 0.8999999761581421
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Name = "Circle"
		Circle.Parent = Button
		
		local NewX = X - Circle.AbsolutePosition.X
		local NewY = Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
		local Size = 0
		if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
			Size = Button.AbsoluteSize.X*1.5
		elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
			Size = Button.AbsoluteSize.Y*1.5
		elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then
			Size = Button.AbsoluteSize.X*1.5
		end

		local Time = 0.5
		Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size/2, 0.5, -Size/2), "Out", "Quad", Time, false, nil)
		for i=1,10 do
			Circle.ImageTransparency = Circle.ImageTransparency + 0.01
			wait(Time/10)
		end
		Circle:Destroy()
	end)
end

local UBHubLib = {}
function UBHubLib:MakeNotify(NotifyConfig)
	local NotifyConfig = NotifyConfig or {}
	NotifyConfig.Title = NotifyConfig.Title or "UB Hub"
	NotifyConfig.Description = NotifyConfig.Description or "Notification"
	NotifyConfig.Content = NotifyConfig.Content or "Content"
	NotifyConfig.Color = GetColor("Primary",NotifyConfig,"BackgroundColor3")
	NotifyConfig.Time = NotifyConfig.Time or 0.5
	NotifyConfig.Delay = NotifyConfig.Delay or 5
	local NotifyFunction = {}
	spawn(function()
		if not CoreGui:FindFirstChild("NotifyGui") then
			local NotifyGui = Instance.new("ScreenGui");
			NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			NotifyGui.Name = "NotifyGui"
			NotifyGui.Parent = CoreGui
		end
		if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
			local NotifyLayout = Instance.new("Frame");
			NotifyLayout.AnchorPoint = Vector2.new(1, 1)
			NotifyLayout.BackgroundColor3 = GetColor("Primary",NotifyLayout,"BackgroundColor3")
			NotifyLayout.BackgroundTransparency = 0.9990000128746033
			NotifyLayout.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifyLayout.BorderSizePixel = 0
			NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
			NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
			NotifyLayout.Name = "NotifyLayout"
			NotifyLayout.Parent = CoreGui.NotifyGui
			local Count = 0
			CoreGui.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
				Count = 0
				for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
					TweenService:Create(
						v,
						TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
						{Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12)*Count))}
					):Play()
					Count = Count + 1
				end
			end)
		end
		local NotifyPosHeigh = 0
		for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
			NotifyPosHeigh = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
		end
		local NotifyFrame = Instance.new("Frame");
		local NotifyFrameReal = Instance.new("Frame");
		local UICorner = Instance.new("UICorner");
		local DropShadowHolder = Instance.new("Frame");
		local DropShado = Instance.new("ImageLabel");
		local Top = Instance.new("Frame");
		local TextLabel = Instance.new("TextLabel");
		local UIStroke = Instance.new("UIStroke");
		local UICorner1 = Instance.new("UICorner");
		local TextLabel1 = Instance.new("TextLabel");
		local UIStroke1 = Instance.new("UIStroke");
		local Close = Instance.new("TextButton");
		local ImageLabel = Instance.new("ImageLabel");
		local TextLabel2 = Instance.new("TextLabel");

		NotifyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
		NotifyFrame.Name = "NotifyFrame"
		NotifyFrame.BackgroundTransparency = 1
		NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout
		NotifyFrame.AnchorPoint = Vector2.new(0, 1)
		NotifyFrame.Position = UDim2.new(0, 0, 1, -(NotifyPosHeigh))

		NotifyFrameReal.BackgroundColor3 = GetColor("Primary",NotifyFrameReal,"BackgroundColor3")
		NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrameReal.BorderSizePixel = 0
		NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
		NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
		NotifyFrameReal.Name = "NotifyFrameReal"
		NotifyFrameReal.Parent = NotifyFrame

		UICorner.Parent = NotifyFrameReal
		UICorner.CornerRadius = UDim.new(0, 8)

		DropShadowHolder.BackgroundTransparency = 1
		DropShadowHolder.BorderSizePixel = 0
		DropShadowHolder.ZIndex = 0
		DropShadowHolder.Name = "DropShadowHolder"
		DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
		DropShadowHolder.Parent = NotifyFrameReal

		DropShado.Image = ""
		DropShado.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShado.ImageTransparency = 0.5
		DropShado.ScaleType = Enum.ScaleType.Slice
		DropShado.SliceCenter = Rect.new(49, 49, 450, 450)
		DropShado.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShado.BackgroundTransparency = 1
		DropShado.BorderSizePixel = 0
		DropShado.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShado.Size = NotifyFrameReal.Size
		DropShado.ZIndex = 0
		DropShado.Name = "DropShado"
		DropShado.Parent = DropShadowHolder

		Top.BackgroundColor3 = GetColor("Primary",Top,"BackgroundColor3")
		Top.BackgroundTransparency = 0.9990000128746033
		Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Top.BorderSizePixel = 0
		Top.Size = UDim2.new(1, 0, 0, 36)
		Top.Name = "Top"
		Top.Parent = NotifyFrameReal

		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = NotifyConfig.Title
		TextLabel.TextColor3 = GetColor("Text",TextLabel,"TextColor3")
		TextLabel.TextSize = 14
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 0.9990000128746033
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.Parent = Top
		TextLabel.Position = UDim2.new(0, 10, 0, 0)

		UIStroke.Color = Color3.fromRGB(255, 255, 255)
		UIStroke.Thickness = 0.30000001192092896
		UIStroke.Parent = TextLabel

		UICorner1.Parent = Top
		UICorner1.CornerRadius = UDim.new(0, 5)

		TextLabel1.Font = Enum.Font.GothamBold
		TextLabel1.Text = NotifyConfig.Description
		TextLabel1.TextColor3 = GetColor("Text",TextLabel1,"TextColor3")
		TextLabel1.TextSize = 14
		TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel1.BackgroundColor3 = GetColor("Text",TextLabel1,"BackgroundColor3")
		TextLabel1.BackgroundTransparency = 0.9990000128746033
		TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel1.BorderSizePixel = 0
		TextLabel1.Size = UDim2.new(1, 0, 1, 0)
		TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
		TextLabel1.Parent = Top

		UIStroke1.Color = NotifyConfig.Color
		UIStroke1.Thickness = 0.4000000059604645
		UIStroke1.Parent = TextLabel1

		Close.Font = Enum.Font.SourceSans
		Close.Text = ""
		Close.TextColor3 = Color3.fromRGB(0, 0, 0)
		Close.TextSize = 14
		Close.AnchorPoint = Vector2.new(1, 0.5)
		Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Close.BackgroundTransparency = 0.9990000128746033
		Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Close.BorderSizePixel = 0
		Close.Position = UDim2.new(1, -5, 0.5, 0)
		Close.Size = UDim2.new(0, 25, 0, 25)
		Close.Name = "Close"
		Close.Parent = Top

		ImageLabel.Image = LoadUIAsset("rbxassetid://9886659671", "ImageLable.png")
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 0.9990000128746033
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.49000001, 0, 0.5, 0)
		ImageLabel.Size = UDim2.new(1, -8, 1, -8)
		ImageLabel.Parent = Close

		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.TextSize = 13
		TextLabel2.Text = NotifyConfig.Content
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.BackgroundTransparency = 0.9990000128746033
		TextLabel2.TextColor3 = Color3.fromRGB(150.0000062584877, 150.0000062584877, 150.0000062584877)
		TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel2.BorderSizePixel = 0
		TextLabel2.Position = UDim2.new(0, 10, 0, 27)
		TextLabel2.Parent = NotifyFrameReal
		TextLabel2.Size = UDim2.new(1, -20, 0, 13)

		TextLabel2.Size = UDim2.new(1, -20, 0, 13 + (13 * math.floor(TextLabel2.TextBounds.X / TextLabel2.AbsoluteSize.X)))
		TextLabel2.TextWrapped = true

		if TextLabel2.AbsoluteSize.Y < 27 then
			NotifyFrame.Size = UDim2.new(1, 0, 0, 65)
		else
			NotifyFrame.Size = UDim2.new(1, 0, 0, TextLabel2.AbsoluteSize.Y + 40)
		end
		local waitbruh = false
		function NotifyFunction:Close()
			if waitbruh then
				return false
			end
			waitbruh = true
			TweenService:Create(NotifyFrameReal,TweenInfo.new(tonumber(NotifyConfig.Time) * 0.2, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 400, 0, 0)}):Play()
			task.wait(tonumber(NotifyConfig.Time) / 1.2)
			NotifyFrame:Destroy()
		end
		Close.Activated:Connect(function()
			NotifyFunction:Close()
		end)
		TweenService:Create(NotifyFrameReal,TweenInfo.new(tonumber(NotifyConfig.Time) * 0.2, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.wait(tonumber(NotifyConfig.Delay))
		NotifyFunction:Close()
	end)
	return NotifyFunction
end
local Folder = "UBHub5"
local mediaFolder = "Asset"
if not isfolder(Folder) then
	makefolder(Folder)
end
function UBHubLib:MakeGui(GuiConfig)
	local GuiConfig = GuiConfig or {}
	GuiConfig.NameHub = GuiConfig.NameHub or "UB Hub"
	if LibraryCfg.Undetected then
		GuiConfig.Description = "|UNDETECTED|"
	else
		GuiConfig.Description = ""
	end
	GuiConfig.Color = Color3.fromRGB(130, 30, 5)
	GuiConfig["Logo Player"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..game:GetService("Players").LocalPlayer.UserId .."&width=420&height=420&format=png"
	GuiConfig["Name Player"] = tostring(game:GetService("Players").LocalPlayer.Name)
	GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 120
	GuiConfig["SaveFolder"] = GuiConfig["SaveFolder"] or false
	local Flags = UBHubLib and UBHubLib.Flags or {}
	local UIInstance = {}
	local function SaveFile(Name, Value)
		if not (writefile and GuiConfig and GuiConfig.SaveFolder) then
			return false
		end
		local valueToSave = Value
		if type(Value) == "table" and not (Value[1] and not next(Value)) then
			valueToSave = nil
		elseif type(Value) == "table" and #Value == 1 then
			valueToSave = Value[1]
		end
		Flags[Name] = valueToSave
		local success, err = pcall(function()
			local path = GuiConfig.SaveFolder
			local encoded = HttpService:JSONEncode(Flags)
			writefile(path, encoded)
		end)
		if not success then
			warn("Save failed:", err)
			return false
		end
		return true
	end
	local function LoadFile()
		if not (GuiConfig and GuiConfig["SaveFolder"]) then return false end
		local savePath = GuiConfig["SaveFolder"]
		if not (readfile and isfile and isfile(savePath)) then return false end
		local success, config = pcall(function()
			return HttpService:JSONDecode(readfile(savePath))
		end)
		if success and type(config) == "table" then
			Flags = config
			return true
		end
		return false
	end; LoadFile()
	local function LoadUISize(saveFlag)
		LoadFile()
		if Flags[saveFlag] then
			local width, height = Flags[saveFlag]:match("(%d+),(%d+)")
			if width and height then
				return UDim2.new(0, tonumber(width), 0, tonumber(height))
			end
		end
		return nil
	end
	local function MakeResizable(object, saveFlag)
		local resizeHandle = Instance.new("Frame")
		resizeHandle.Name = "ResizeHandle"
		resizeHandle.AnchorPoint = Vector2.new(1, 1)
		resizeHandle.BackgroundColor3 = Color3.fromRGB(130, 30, 5)
		resizeHandle.BackgroundTransparency = 0.5
		resizeHandle.Size = UDim2.new(0, 20, 0, 20)
		resizeHandle.Position = UDim2.new(1, 0, 1, 0)
		resizeHandle.ZIndex = 10
		resizeHandle.Parent = object
		
		local resizeAPI = {
			CurrentSize = object.Size,
			SaveFlag = saveFlag
		}
		local dragging = false
		local dragStart
		local startSize
		local function handleSizeChange(newSize)
			object.Size = newSize
			resizeAPI.CurrentSize = newSize
			if saveFlag then
				local sizeString = string.format("%d,%d", newSize.X.Offset, newSize.Y.Offset)
				SaveFile(saveFlag, sizeString)
				if saveFlag == "UI_Size" then
					SaveFile("Blur", sizeString)
				end
			end
		end
		resizeHandle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startSize = object.Size
				local connection
				connection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						connection:Disconnect()
					end
				end)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				local newWidth = math.max(startSize.X.Offset + delta.X, 50)
				local newHeight = math.max(startSize.Y.Offset + delta.Y, 50)
				handleSizeChange(UDim2.new(0, newWidth, 0, newHeight))
			end
		end)
		function resizeAPI:SetSize(newSize)
			local validatedWidth = math.max(newSize.X.Offset, 50)
			local validatedHeight = math.max(newSize.Y.Offset, 50)
			handleSizeChange(UDim2.new(0, validatedWidth, 0, validatedHeight))
		end
		return resizeAPI
	end
	local UBHubGui = Instance.new("ScreenGui");
	local DropShadowHolder = Instance.new("Frame");
	local DropShadow = Instance.new("ImageLabel");
	local Main = Instance.new("Frame");
	local UICorner = Instance.new("UICorner");
	local UIStroke = Instance.new("UIStroke");
	local Top = Instance.new("Frame");
	local TextLabel = Instance.new("TextLabel");
	local UICorner1 = Instance.new("UICorner");
	local TextLabel1 = Instance.new("TextLabel");
	local UIStroke1 = Instance.new("UIStroke");
	local MaxRestore = Instance.new("TextButton");
	local ImageLabel = Instance.new("ImageLabel");
	local Close = Instance.new("TextButton");
	local ImageLabel1 = Instance.new("ImageLabel");
	local Min = Instance.new("TextButton");
	local ImageLabel2 = Instance.new("ImageLabel");
	local LayersTab = Instance.new("Frame");
	local UICorner2 = Instance.new("UICorner");
	local DecideFrame = Instance.new("Frame");
	local UIStroke3 = Instance.new("UIStroke");
	local Layers = Instance.new("Frame");
	local UICorner6 = Instance.new("UICorner");
	local NameTab = Instance.new("TextLabel");
	local LayersReal = Instance.new("Frame");
	local LayersFolder = Instance.new("Folder");
	local LayersPageLayout = Instance.new("UIPageLayout");

	UBHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	UBHubGui.Name = "UBHubGui"
	UBHubGui.Parent = CoreGui

	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.BackgroundColor3 = Color3.new(0, 0, 0)
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.ZIndex = 0
	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = UBHubGui
	DropShadowHolder.Size = SizeUI
  	DropShadowHolder.Position = UDim2.new(0,math.floor(UBHubGui.AbsoluteSize.X / 2 - DropShadowHolder.Size.X.Offset / 2),0,math.floor(UBHubGui.AbsoluteSize.Y / 2 - DropShadowHolder.Size.Y.Offset / 2))
	DropShadow.Image = ""
	DropShadow.ImageColor3 = Color3.fromRGB(15, 15, 15)
	DropShadow.ImageTransparency = 0.5
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 0
	DropShadow.Name = "DropShadow"
	DropShadow.Parent = DropShadowHolder
	
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = GetColor("Accent",Main,"BackgroundColor3")
	Main.BackgroundTransparency = 0.1
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = SizeUI
	Main.Name = "Main"
	Main.Parent = DropShadow
	local resizeAPI = MakeResizable(Main,"UI_Size")
	local savedSize = LoadUISize("UI_Size")
	if savedSize then
    	resizeAPI:SetSize(savedSize)
	end
	local BackgroundImage = Instance.new("ImageLabel")
	BackgroundImage.Name = "MainImage"
	BackgroundImage.Size = UDim2.new(1,0,1,0)
	BackgroundImage.BackgroundTransparency = 1
	BackgroundImage.Parent = Main

	local BackgroundVideo = Instance.new("VideoFrame")
	BackgroundVideo.Name = "MainVideo"
	BackgroundVideo.Size = UDim2.new(1,0,1,0)
	BackgroundVideo.BackgroundTransparency = 1
	BackgroundVideo.Looped = true
	BackgroundVideo.Parent = Main
	function ChangeAsset(type, input, name)
		local mediaFolder = UBDir .."/".."Asset"
		if not isfolder(mediaFolder) then
			makefolder(mediaFolder)
		end
		local asset
		local success, err = pcall(function()
			if input:match("^https?://") then
				local data = game:HttpGet(input)
				local extension = type == "Image" and ".png" or ".mp4"
				if not name:match("%..+$") then
					name = name .. extension
				end
				local filePath = mediaFolder.."/"..name
				writefile(filePath, data)
				asset = getcustomasset(filePath)
			elseif input == "Reset" then
				return
			else
				asset = getcustomasset(input)
			end
		end)
		if not success then
			warn("There have error to load asset:", err)
			return err
		end
		if type == "Image" then
			BackgroundImage.Image = asset or ""
			BackgroundVideo.Video = ""
			BGImage = true
		elseif type == "Video" then
			BackgroundVideo.Video = asset or ""
			BackgroundVideo.Looped = true
			BackgroundImage.Image = ""
			BackgroundVideo.Playing = true
			BGVideo = true
		end
	end
	function Reset()
		BackgroundVideo.Video = ""
		BackgroundImage.Image = ""
		BGVideo = false
		BGImage = false
	end
	function ChangeTransparency(Trans)
		Main.BackgroundTransparency = Trans
		if BGVideo or BGImage then
			BackgroundImage.ImageTransparency = Trans
			BackgroundVideo.BackgroundTransparency = Trans
		end
	end
	UICorner.Parent = Main

	UIStroke.Color = Color3.fromRGB(50, 50, 50)
	UIStroke.Thickness = 1.600000023841858
	UIStroke.Parent = Main

	Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Top.BackgroundTransparency = 0.9990000128746033
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 38)
	Top.Name = "Top"
	Top.Parent = Main

	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = GuiConfig.NameHub
	TextLabel.TextColor3 = GetColor("Text",TextLabel,"TextColor3")
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.BackgroundColor3 = GetColor("Accent",TextLabel,"BackgroundColor3")
	TextLabel.BackgroundTransparency = 0.9990000128746033
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, -100, 1, 0)
	TextLabel.Position = UDim2.new(0, 10, 0, 0)
	TextLabel.Parent = Top

	UICorner1.Parent = Top

	TextLabel1.Font = Enum.Font.GothamBold
	TextLabel1.Text = ""
	TextLabel1.TextColor3 = GetColor("Text",TextLabel1,"TextColor3")
	TextLabel1.TextSize = 14
	TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel1.BackgroundTransparency = 0.9990000128746033
	TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel1.BorderSizePixel = 0
	TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0)
	TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
	TextLabel1.Parent = Top

	UIStroke1.Color = GetColor("Secondary",UIStroke1,"Color")
	UIStroke1.Thickness = 0.4000000059604645
	UIStroke1.Parent = TextLabel1

	Close.Font = Enum.Font.SourceSans
	Close.Text = ""
	Close.TextColor3 = Color3.fromRGB(0, 0, 0)
	Close.TextSize = 14
	Close.AnchorPoint = Vector2.new(1, 0.5)
	Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Close.BackgroundTransparency = 0.9990000128746033
	Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Close.BorderSizePixel = 0
	Close.Position = UDim2.new(1, -8, 0.5, 0)
	Close.Size = UDim2.new(0, 25, 0, 25)
	Close.Name = "Close"
	Close.Parent = Top

	ImageLabel1.Image = LoadUIAsset("rbxassetid://9886659671", "ImageLabel1.png")
	ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel1.BackgroundTransparency = 0.9990000128746033
	ImageLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel1.BorderSizePixel = 0
	ImageLabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
	ImageLabel1.Size = UDim2.new(1, -8, 1, -8)
	ImageLabel1.Parent = Close

	Min.Font = Enum.Font.SourceSans
	Min.Text = ""
	Min.TextColor3 = Color3.fromRGB(0, 0, 0)
	Min.TextSize = 14
	Min.AnchorPoint = Vector2.new(1, 0.5)
	Min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Min.BackgroundTransparency = 0.9990000128746033
	Min.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Min.BorderSizePixel = 0
	Min.Position = UDim2.new(1, -50, 0.5, 0)
	Min.Size = UDim2.new(0, 25, 0, 25)
	Min.Name = "Min"
	Min.Parent = Top

	ImageLabel2.Image = LoadUIAsset("rbxassetid://9886659276", "ImageLabel2.png")
	ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel2.BackgroundTransparency = 0.9990000128746033
	ImageLabel2.ImageTransparency = 0.2
	ImageLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel2.BorderSizePixel = 0
	ImageLabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel2.Size = UDim2.new(1, -9, 1, -9)
	ImageLabel2.Parent = Min

	LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LayersTab.BackgroundTransparency = 0.9990000128746033
	LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LayersTab.BorderSizePixel = 0
	LayersTab.Position = UDim2.new(0, 9, 0, 50)
	LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -59)
	LayersTab.Name = "LayersTab"
	LayersTab.Parent = Main

	UICorner2.CornerRadius = UDim.new(0, 2)
	UICorner2.Parent = LayersTab

	DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
	DecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DecideFrame.BackgroundTransparency = 0.85
	DecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DecideFrame.BorderSizePixel = 0
	DecideFrame.Position = UDim2.new(0.5, 0, 0, 38)
	DecideFrame.Size = UDim2.new(1, 0, 0, 1)
	DecideFrame.Name = "DecideFrame"
	DecideFrame.Parent = Main

	Layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Layers.BackgroundTransparency = 0.9990000128746033
	Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Layers.BorderSizePixel = 0
	Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 50)
	Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -59)
	Layers.Name = "Layers"
	Layers.Parent = Main

	UICorner6.CornerRadius = UDim.new(0, 2)
	UICorner6.Parent = Layers

	NameTab.Font = Enum.Font.GothamBold
	NameTab.Text = ""
	NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
	NameTab.TextSize = 24
	NameTab.TextWrapped = true
	NameTab.TextXAlignment = Enum.TextXAlignment.Left
	NameTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameTab.BackgroundTransparency = 0.9990000128746033
	NameTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NameTab.BorderSizePixel = 0
	NameTab.Size = UDim2.new(1, 0, 0, 30)
	NameTab.Name = "NameTab"
	NameTab.Parent = Layers

	LayersReal.AnchorPoint = Vector2.new(0, 1)
	LayersReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LayersReal.BackgroundTransparency = 0.9990000128746033
	LayersReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LayersReal.BorderSizePixel = 0
	LayersReal.ClipsDescendants = true
	LayersReal.Position = UDim2.new(0, 0, 1, 0)
	LayersReal.Size = UDim2.new(1, 0, 1, -33)
	LayersReal.Name = "LayersReal"
	LayersReal.Parent = Layers

	LayersFolder.Name = "LayersFolder"
	LayersFolder.Parent = LayersReal

	LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LayersPageLayout.Name = "LayersPageLayout"
	LayersPageLayout.Parent = LayersFolder
	LayersPageLayout.TweenTime = 0.5
	LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
	LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad

	--// Settings Page Frame
	local SettingsPage = Instance.new("ScrollingFrame")
	SettingsPage.Name = "SettingsPage"
	SettingsPage.Size = Layers.Size
	SettingsPage.Position = Layers.Position
	SettingsPage.BackgroundTransparency = 1 -- Or match Layers BackgroundTransparency if preferred
	SettingsPage.BorderSizePixel = 0
	SettingsPage.Visible = false
	SettingsPage.Parent = Main
	SettingsPage.ScrollBarThickness = 6
	SettingsPage.ScrollingDirection = Enum.ScrollingDirection.Y -- Assuming vertical scrolling for settings

	local SettingsPageLayout = Instance.new("UIListLayout")
	SettingsPageLayout.Parent = SettingsPage
	SettingsPageLayout.Padding = UDim.new(0, 5) -- Standard padding
	SettingsPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SettingsPageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	--// Dummy Tab object for Settings Page
	local SettingsTab = {}
	SettingsTab._ScrolLayers = SettingsPage -- This is the settings page itself
	SettingsTab._IsSettingsTab = true -- Flag to differentiate if needed later

	local settingsSectionCount = 0 -- Local counter for sections within settings

	function SettingsTab:AddSection(Title)
		Title = Title or "Settings Section"
		local CurrentScrolLayers = self._ScrolLayers

		local SectionFrame = Instance.new("Frame")
		SectionFrame.Name = "Section"
		SectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SectionFrame.BackgroundTransparency = 0.9990000128746033
		SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SectionFrame.BorderSizePixel = 0
		SectionFrame.LayoutOrder = settingsSectionCount
		SectionFrame.ClipsDescendants = true
		SectionFrame.Size = UDim2.new(1, 0, 0, 30)
		SectionFrame.Parent = CurrentScrolLayers

		local SectionReal = Instance.new("Frame")
		SectionReal.Name = "SectionReal"
		SectionReal.AnchorPoint = Vector2.new(0.5, 0)
		SectionReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SectionReal.BackgroundTransparency = 0.935
		SectionReal.BorderColor3 = Color3.fromRGB(0,0,0)
		SectionReal.BorderSizePixel = 0
		SectionReal.LayoutOrder = 1
		SectionReal.Position = UDim2.new(0.5,0,0,0)
		SectionReal.Size = UDim2.new(1,1,0,30)
		SectionReal.Parent = SectionFrame
		local UICorner_SR = Instance.new("UICorner", SectionReal)
		UICorner_SR.CornerRadius = UDim.new(0,4)

		local SectionButton = Instance.new("TextButton")
		SectionButton.Name = "SectionButton"
		SectionButton.Text = ""
		SectionButton.Size = UDim2.new(1,0,1,0)
		SectionButton.BackgroundTransparency = 1
		SectionButton.Parent = SectionReal
		
		local FeatureFrame_Section = Instance.new("Frame", SectionReal)
		FeatureFrame_Section.Name = "FeatureFrame"
		FeatureFrame_Section.AnchorPoint = Vector2.new(1,0.5)
		FeatureFrame_Section.BackgroundTransparency = 1
		FeatureFrame_Section.Position = UDim2.new(1,-5,0.5,0)
		FeatureFrame_Section.Size = UDim2.new(0,20,0,20)
		
		local FeatureImg_Section = Instance.new("ImageLabel", FeatureFrame_Section)
		FeatureImg_Section.Name = "FeatureImg"
		FeatureImg_Section.Image = LoadUIAsset("rbxassetid://16851841101", "FeatureImg_SettingsSection")
		FeatureImg_Section.AnchorPoint = Vector2.new(0.5,0.5)
		FeatureImg_Section.BackgroundTransparency = 1
		FeatureImg_Section.Position = UDim2.new(0.5,0,0.5,0)
		FeatureImg_Section.Rotation = -90
		FeatureImg_Section.Size = UDim2.new(1,6,1,6)

		local SectionTitleText = Instance.new("TextLabel", SectionReal)
		SectionTitleText.Name = "SectionTitle"
		SectionTitleText.Font = Enum.Font.GothamBold
		SectionTitleText.Text = Title
		SectionTitleText.TextColor3 = GetColor("Text")
		SectionTitleText.TextSize = 13
		SectionTitleText.TextXAlignment = Enum.TextXAlignment.Left
		SectionTitleText.TextYAlignment = Enum.TextYAlignment.Center
		SectionTitleText.AnchorPoint = Vector2.new(0,0.5)
		SectionTitleText.BackgroundTransparency = 1
		SectionTitleText.Position = UDim2.new(0,10,0.5,0)
		SectionTitleText.Size = UDim2.new(1,-50,0,13)
		
		local SectionDecideFrame = Instance.new("Frame", SectionFrame)
		SectionDecideFrame.Name = "SectionDecideFrame"
		SectionDecideFrame.AnchorPoint = Vector2.new(0.5,0)
		SectionDecideFrame.BackgroundColor3 = GetColor("Primary")
		SectionDecideFrame.BorderSizePixel = 0
		SectionDecideFrame.Position = UDim2.new(0.5,0,0,33)
		SectionDecideFrame.Size = UDim2.new(0,0,0,2) -- Initially hidden
		Instance.new("UICorner", SectionDecideFrame)
		
		local SectionAdd = Instance.new("Frame")
		SectionAdd.Name = "SectionAdd"
		SectionAdd.AnchorPoint = Vector2.new(0.5,0)
		SectionAdd.BackgroundTransparency = 1
		SectionAdd.ClipsDescendants = true
		SectionAdd.LayoutOrder = 1
		SectionAdd.Position = UDim2.new(0.5,0,0,38)
		SectionAdd.Size = UDim2.new(1,0,0,0) -- Initially zero height
		SectionAdd.Parent = SectionFrame
		Instance.new("UICorner", SectionAdd).CornerRadius = UDim.new(0,2)
		
		local UIListLayout_SectionAdd = Instance.new("UIListLayout", SectionAdd)
		UIListLayout_SectionAdd.Padding = UDim.new(0,3)
		UIListLayout_SectionAdd.SortOrder = Enum.SortOrder.LayoutOrder

		local OpenSection = false
		local function UpdateSettingsPageScroll()
			task.defer(function()
				local totalHeight = 0
				for _, child in ipairs(SettingsPage:GetChildren()) do
					if child:IsA("Frame") and child.Name == "Section" then
						totalHeight = totalHeight + child.Size.Y.Offset + SettingsPageLayout.Padding.Offset
					end
				end
				if #SettingsPage:GetChildren() > 0 then totalHeight = totalHeight - SettingsPageLayout.Padding.Offset end
				SettingsPage.CanvasSize = UDim2.new(0,0,0, totalHeight)
			end)
		end

		local function UpdateThisSettingsSectionSize()
			if OpenSection then
				task.defer(function()
					local contentHeight = UIListLayout_SectionAdd.AbsoluteContentSize.Y
					local newHeight = math.max(38 + contentHeight + UIListLayout_SectionAdd.Padding.Offset, 30)
					SectionFrame.Size = UDim2.new(1,0,0,newHeight)
					SectionAdd.Size = UDim2.new(1,0,0,contentHeight)
					SectionDecideFrame.Size = UDim2.new(1,0,0,2)
					UpdateSettingsPageScroll()
				end)
			else
				SectionFrame.Size = UDim2.new(1,0,0,30)
				SectionAdd.Size = UDim2.new(1,0,0,0)
				SectionDecideFrame.Size = UDim2.new(0,0,0,2)
				UpdateSettingsPageScroll()
			end
		end
		
		SectionButton.Activated:Connect(function()
			OpenSection = not OpenSection
			FeatureImg_Section.Rotation = OpenSection and 0 or -90 -- Assuming 0 is open, -90 is closed for settings sections
			UpdateThisSettingsSectionSize()
		end)

		SectionAdd.ChildAdded:Connect(UpdateThisSettingsSectionSize)
		SectionAdd.ChildRemoved:Connect(UpdateThisSettingsSectionSize)
		UpdateSettingsPageScroll() -- Initial call

		local SectionObject = {}
		SectionObject._SectionAdd = SectionAdd
		SectionObject._UpdateSizeSection = UpdateThisSettingsSectionSize
		SectionObject._UpdateSizeScroll = UpdateSettingsPageScroll
		
		-- Populate SectionObject with item methods (copied from main Tab:AddSection, adapted)
		local CountItem = 0 -- Local to this section
		
		function SectionObject:AddParagraph(ParagraphConfig)
			local ParagraphConfig = ParagraphConfig or {}
			ParagraphConfig.Title = ParagraphConfig.Title or "Title"
			ParagraphConfig.Content = ParagraphConfig.Content or "Content"
			local ParagraphFunc = {}
			local Paragraph = Instance.new("Frame")
			Paragraph.Name = "Paragraph"; Paragraph.Parent = SectionObject._SectionAdd; Paragraph.LayoutOrder = CountItem;
			Paragraph.Size = UDim2.new(1,0,0,46); Paragraph.BackgroundTransparency = 0.935; Paragraph.BackgroundColor3 = GetColor("Secondary", Paragraph, "BackgroundColor3")
			Instance.new("UICorner", Paragraph).CornerRadius = UDim.new(0,4)
			local ParagraphTitle = Instance.new("TextLabel", Paragraph)
			ParagraphTitle.Name = "ParagraphTitle"; ParagraphTitle.Font = Enum.Font.GothamBold; ParagraphTitle.Text = ParagraphConfig.Title .. " | " .. ParagraphConfig.Content;
			ParagraphTitle.TextColor3 = GetColor("Text", ParagraphTitle, "TextColor3"); ParagraphTitle.TextSize = 13; ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left; ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top;
			ParagraphTitle.BackgroundTransparency = 1; ParagraphTitle.Position = UDim2.new(0,10,0,10); ParagraphTitle.Size = UDim2.new(1,-16,0,13); ParagraphTitle.TextWrapped = true
			task.delay(0, function() 
				ParagraphTitle.Size = UDim2.new(1, -16, 0, ParagraphTitle.TextBounds.Y); Paragraph.Size = UDim2.new(1,0,0, ParagraphTitle.TextBounds.Y + 20); SectionObject._UpdateSizeSection()
			end)
			function ParagraphFunc:Set(pConfig) ParagraphTitle.Text = (pConfig.Title or "T") .. " | " .. (pConfig.Content or "C"); task.delay(0,function() ParagraphTitle.Size = UDim2.new(1,-16,0,ParagraphTitle.TextBounds.Y); Paragraph.Size = UDim2.new(1,0,0,ParagraphTitle.TextBounds.Y + 20); SectionObject._UpdateSizeSection() end) end
			CountItem = CountItem + 1; return ParagraphFunc
		end
		function SectionObject:AddButton(ButtonConfig)
			local ButtonConfig = ButtonConfig or {}; ButtonConfig.Title = ButtonConfig.Title or "Button"; ButtonConfig.Content = ButtonConfig.Content or ""; ButtonConfig.Callback = ButtonConfig.Callback or function() end
			local ButtonFrame = Instance.new("Frame"); ButtonFrame.Name = "Button"; ButtonFrame.Parent = SectionObject._SectionAdd; ButtonFrame.LayoutOrder = CountItem;
			ButtonFrame.Size = UDim2.new(1,0,0,46); ButtonFrame.BackgroundTransparency = 0.935; ButtonFrame.BackgroundColor3 = GetColor("Secondary", ButtonFrame, "BackgroundColor3")
			Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0,4)
			local ButtonTitle = Instance.new("TextLabel", ButtonFrame); ButtonTitle.Name = "ButtonTitle"; ButtonTitle.Font = Enum.Font.GothamBold; ButtonTitle.Text = ButtonConfig.Title; ButtonTitle.TextColor3 = GetColor("Text", ButtonTitle, "TextColor3"); ButtonTitle.TextSize = 13; ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left; ButtonTitle.TextYAlignment = Enum.TextYAlignment.Top; ButtonTitle.BackgroundTransparency=1; ButtonTitle.Position = UDim2.new(0,10,0,10); ButtonTitle.Size = UDim2.new(1,-100,0,13)
			local ButtonContent = Instance.new("TextLabel", ButtonFrame); ButtonContent.Name = "ButtonContent"; ButtonContent.Font = Enum.Font.Gotham; ButtonContent.Text = ButtonConfig.Content; ButtonContent.TextColor3 = GetColor("Text", ButtonContent, "TextColor3"); ButtonContent.TextSize = 12; ButtonContent.TextTransparency = 0.4; ButtonContent.TextXAlignment = Enum.TextXAlignment.Left; ButtonContent.TextYAlignment = Enum.TextYAlignment.Bottom; ButtonContent.BackgroundTransparency=1; ButtonContent.Position = UDim2.new(0,10,0,0); ButtonContent.Size = UDim2.new(1,-100,1,-10); ButtonContent.TextWrapped = true
			local ActualButton = Instance.new("TextButton", ButtonFrame); ActualButton.Name = "ActualButton"; ActualButton.Text = ""; ActualButton.Size = UDim2.new(1,0,1,0); ActualButton.BackgroundTransparency = 1; ActualButton.Activated:Connect(ButtonConfig.Callback)
			task.delay(0, function() local contentHeight = ButtonContent.TextBounds.Y; local titleHeight = ButtonTitle.TextBounds.Y; ButtonFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15)); SectionObject._UpdateSizeSection() end)
			CountItem = CountItem + 1; return {}
		end
		function SectionObject:AddToggle(ToggleConfig)
			local ToggleConfig = ToggleConfig or {}; ToggleConfig.Title = ToggleConfig.Title or "Toggle"; ToggleConfig.Content = ToggleConfig.Content or ""; ToggleConfig.Default = (ToggleConfig.Flag and Flags[ToggleConfig.Flag] ~= nil) and Flags[ToggleConfig.Flag] or ToggleConfig.Default or false; ToggleConfig.Callback = ToggleConfig.Callback or function() end
			local ToggleFrame = Instance.new("Frame"); ToggleFrame.Name = "Toggle"; ToggleFrame.Parent = SectionObject._SectionAdd; ToggleFrame.LayoutOrder = CountItem;
			ToggleFrame.Size = UDim2.new(1,0,0,46); ToggleFrame.BackgroundTransparency = 0.935; ToggleFrame.BackgroundColor3 = GetColor("Secondary", ToggleFrame, "BackgroundColor3")
			Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0,4)
			local ToggleTitle = Instance.new("TextLabel", ToggleFrame); ToggleTitle.Name = "ToggleTitle"; ToggleTitle.Font = Enum.Font.GothamBold; ToggleTitle.Text = ToggleConfig.Title; ToggleTitle.TextColor3 = GetColor("Text", ToggleTitle, "TextColor3"); ToggleTitle.TextSize = 13; ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left; ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top; ToggleTitle.BackgroundTransparency=1; ToggleTitle.Position = UDim2.new(0,10,0,10); ToggleTitle.Size = UDim2.new(1,-100,0,13)
			local ToggleContent = Instance.new("TextLabel", ToggleFrame); ToggleContent.Name = "ToggleContent"; ToggleContent.Font = Enum.Font.Gotham; ToggleContent.Text = ToggleConfig.Content; ToggleContent.TextColor3 = GetColor("Text", ToggleContent, "TextColor3"); ToggleContent.TextSize = 12; ToggleContent.TextTransparency = 0.4; ToggleContent.TextXAlignment = Enum.TextXAlignment.Left; ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom; ToggleContent.BackgroundTransparency=1; ToggleContent.Position = UDim2.new(0,10,0,0); ToggleContent.Size = UDim2.new(1,-100,1,-10); ToggleContent.TextWrapped = true
			local SwitchFrame = Instance.new("Frame", ToggleFrame); SwitchFrame.Name = "SwitchFrame"; SwitchFrame.AnchorPoint = Vector2.new(1,0.5); SwitchFrame.BackgroundColor3 = GetColor("Accent", SwitchFrame, "BackgroundColor3"); SwitchFrame.BackgroundTransparency = 0.5; SwitchFrame.BorderSizePixel = 0; SwitchFrame.Position = UDim2.new(1,-15,0.5,0); SwitchFrame.Size = UDim2.new(0,30,0,15); Instance.new("UICorner", SwitchFrame).CornerRadius = UDim.new(0,100)
			local SwitchCircle = Instance.new("Frame", SwitchFrame); SwitchCircle.Name = "SwitchCircle"; SwitchCircle.BackgroundColor3 = GetColor("ThemeHighlight", SwitchCircle, "BackgroundColor3"); SwitchCircle.BorderSizePixel = 0; SwitchCircle.Position = UDim2.new(ToggleConfig.Default and 0.5 or 0, ToggleConfig.Default and -1 or 1, 0.5, -6); SwitchCircle.Size = UDim2.new(0,12,0,12); Instance.new("UICorner", SwitchCircle).CornerRadius = UDim.new(0,100)
			local ActualButton = Instance.new("TextButton", ToggleFrame); ActualButton.Name = "ActualButton"; ActualButton.Text = ""; ActualButton.Size = UDim2.new(1,0,1,0); ActualButton.BackgroundTransparency = 1
			local currentValue = ToggleConfig.Default
			function ActualButton.Activated() currentValue = not currentValue; if ToggleConfig.Flag then SaveFile(ToggleConfig.Flag, currentValue) end; ToggleConfig.Callback(currentValue); SwitchCircle:TweenPosition(UDim2.new(currentValue and 0.5 or 0, currentValue and -1 or 1, 0.5, -6), "Out", "Quad", 0.15, true) end
			task.delay(0, function() local contentHeight = ToggleContent.TextBounds.Y; local titleHeight = ToggleTitle.TextBounds.Y; ToggleFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15)); SectionObject._UpdateSizeSection() end)
			CountItem = CountItem + 1; return { GetValue = function() return currentValue end, SetValue = function(val) currentValue = val; if ToggleConfig.Flag then SaveFile(ToggleConfig.Flag, currentValue) end; ToggleConfig.Callback(currentValue); SwitchCircle:TweenPosition(UDim2.new(currentValue and 0.5 or 0, currentValue and -1 or 1, 0.5, -6), "Out", "Quad", 0.15, true) end }
		end
		function SectionObject:AddSlider(SliderConfig)
			local SliderConfig = SliderConfig or {}; SliderConfig.Title = SliderConfig.Title or "Slider"; SliderConfig.Content = SliderConfig.Content or ""; SliderConfig.Min = SliderConfig.Min or 0; SliderConfig.Max = SliderConfig.Max or 100; SliderConfig.Increment = SliderConfig.Increment or 1; local savedVal = SliderConfig.Flag and Flags[SliderConfig.Flag]; SliderConfig.Default = tonumber(savedVal or SliderConfig.Default or SliderConfig.Min); SliderConfig.Callback = SliderConfig.Callback or function() end
			local SliderFrame = Instance.new("Frame"); SliderFrame.Name = "Slider"; SliderFrame.Parent = SectionObject._SectionAdd; SliderFrame.LayoutOrder = CountItem;
			SliderFrame.Size = UDim2.new(1,0,0,55); SliderFrame.BackgroundTransparency = 0.935; SliderFrame.BackgroundColor3 = GetColor("Secondary", SliderFrame, "BackgroundColor3")
			Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0,4)
			local SliderTitle = Instance.new("TextLabel", SliderFrame); SliderTitle.Name = "SliderTitle"; SliderTitle.Font = Enum.Font.GothamBold; SliderTitle.Text = SliderConfig.Title; SliderTitle.TextColor3 = GetColor("Text", SliderTitle, "TextColor3"); SliderTitle.TextSize = 13; SliderTitle.TextXAlignment = Enum.TextXAlignment.Left; SliderTitle.TextYAlignment = Enum.TextYAlignment.Top; SliderTitle.BackgroundTransparency=1; SliderTitle.Position = UDim2.new(0,10,0,10); SliderTitle.Size = UDim2.new(1,-60,0,13)
			local SliderValueText = Instance.new("TextBox", SliderFrame); SliderValueText.Name = "SliderValueText"; SliderValueText.Font = Enum.Font.GothamBold; SliderValueText.Text = tostring(SliderConfig.Default); SliderValueText.TextColor3 = GetColor("Text", SliderValueText, "TextColor3"); SliderValueText.TextSize = 12; SliderValueText.BackgroundTransparency = 0.8; SliderValueText.BackgroundColor3 = GetColor("Accent", SliderValueText, "BackgroundColor3"); SliderValueText.Position = UDim2.new(1,-45,0,5); SliderValueText.Size = UDim2.new(0,40,0,20); Instance.new("UICorner", SliderValueText).CornerRadius = UDim.new(0,3)
			local Bar = Instance.new("Frame", SliderFrame); Bar.Name = "Bar"; Bar.BackgroundColor3 = GetColor("Accent", Bar, "BackgroundColor3"); Bar.BorderSizePixel = 0; Bar.Position = UDim2.new(0,10,1,-20); Bar.Size = UDim2.new(1,-20,0,5); Instance.new("UICorner", Bar).CornerRadius = UDim.new(0,100)
			local Progress = Instance.new("Frame", Bar); Progress.Name = "Progress"; Progress.BackgroundColor3 = GetColor("ThemeHighlight", Progress, "BackgroundColor3"); Progress.BorderSizePixel = 0; Instance.new("UICorner", Progress).CornerRadius = UDim.new(0,100)
			local Dragger = Instance.new("TextButton", Bar); Dragger.Name = "Dragger"; Dragger.Text = ""; Dragger.Size = UDim2.new(0,10,0,10); Dragger.AnchorPoint = Vector2.new(0.5,0.5); Dragger.BackgroundColor3 = GetColor("ThemeHighlight", Dragger, "BackgroundColor3"); Dragger.BorderSizePixel = 0; Instance.new("UICorner", Dragger).CornerRadius = UDim.new(0,100); Dragger.ZIndex = 2
			local currentValue = SliderConfig.Default
			local function UpdateSlider(value) value = math.clamp(math.floor(value/SliderConfig.Increment + 0.5) * SliderConfig.Increment, SliderConfig.Min, SliderConfig.Max); currentValue = value; SliderValueText.Text = tostring(value); local percent = (value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min); Progress.Size = UDim2.new(percent,0,1,0); Dragger.Position = UDim2.new(percent,0,0.5,0); if SliderConfig.Flag then SaveFile(SliderConfig.Flag, currentValue) end; SliderConfig.Callback(currentValue) end
			UpdateSlider(currentValue)
			Dragger.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then local dragging = true; local conn; conn = UserInputService.InputChanged:Connect(function(subInput) if not dragging then conn:Disconnect() return end; if subInput.UserInputType == Enum.UserInputType.MouseMovement or subInput.UserInputType == Enum.UserInputType.Touch then local localPos = Bar.AbsolutePosition.X; local mousePos = subInput.Position.X; local percent = math.clamp((mousePos - localPos) / Bar.AbsoluteSize.X, 0, 1); UpdateSlider(SliderConfig.Min + percent * (SliderConfig.Max - SliderConfig.Min)) end end); Dragger.InputEnded:Connect(function() dragging = false conn:Disconnect() end) end end)
			SliderValueText.FocusLost:Connect(function(enterPressed) if enterPressed then local num = tonumber(SliderValueText.Text); if num then UpdateSlider(num) else UpdateSlider(currentValue) end end end)
			CountItem = CountItem + 1; return { GetValue = function() return currentValue end, SetValue = UpdateSlider }
		end
		function SectionObject:AddInput(InputConfig)
			local InputConfig = InputConfig or {}; InputConfig.Title = InputConfig.Title or "Input"; InputConfig.Content = InputConfig.Content or ""; local savedVal = InputConfig.Flag and Flags[InputConfig.Flag]; InputConfig.Default = savedVal or InputConfig.Default or ""; InputConfig.Callback = InputConfig.Callback or function() end
			local InputFrame = Instance.new("Frame"); InputFrame.Name = "Input"; InputFrame.Parent = SectionObject._SectionAdd; InputFrame.LayoutOrder = CountItem;
			InputFrame.Size = UDim2.new(1,0,0,46); InputFrame.BackgroundTransparency = 0.935; InputFrame.BackgroundColor3 = GetColor("Secondary", InputFrame, "BackgroundColor3")
			Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0,4)
			local InputTitle = Instance.new("TextLabel", InputFrame); InputTitle.Name = "InputTitle"; InputTitle.Font = Enum.Font.GothamBold; InputTitle.Text = InputConfig.Title; InputTitle.TextColor3 = GetColor("Text", InputTitle, "TextColor3"); InputTitle.TextSize = 13; InputTitle.TextXAlignment = Enum.TextXAlignment.Left; InputTitle.TextYAlignment = Enum.TextYAlignment.Top; InputTitle.BackgroundTransparency=1; InputTitle.Position = UDim2.new(0,10,0,10); InputTitle.Size = UDim2.new(1,-100,0,13)
			local InputContent = Instance.new("TextLabel", InputFrame); InputContent.Name = "InputContent"; InputContent.Font = Enum.Font.Gotham; InputContent.Text = InputConfig.Content; InputContent.TextColor3 = GetColor("Text", InputContent, "TextColor3"); InputContent.TextSize = 12; InputContent.TextTransparency = 0.4; InputContent.TextXAlignment = Enum.TextXAlignment.Left; InputContent.TextYAlignment = Enum.TextYAlignment.Bottom; InputContent.BackgroundTransparency=1; InputContent.Position = UDim2.new(0,10,0,0); InputContent.Size = UDim2.new(1,-100,1,-10); InputContent.TextWrapped = true
			local TextBox = Instance.new("TextBox", InputFrame); TextBox.Name = "TextBox"; TextBox.Font = Enum.Font.Gotham; TextBox.Text = InputConfig.Default; TextBox.TextColor3 = GetColor("Text", TextBox, "TextColor3"); TextBox.TextSize = 12; TextBox.BackgroundColor3 = GetColor("Accent", TextBox, "BackgroundColor3"); TextBox.Position = UDim2.new(1,-155,0.5,-12); TextBox.Size = UDim2.new(0,150,0,24); Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0,3); TextBox.ClearTextOnFocus = false
			local currentValue = InputConfig.Default
			TextBox.FocusLost:Connect(function(enterPressed) if enterPressed then currentValue = TextBox.Text; if InputConfig.Flag then SaveFile(InputConfig.Flag, currentValue) end; InputConfig.Callback(currentValue) else TextBox.Text = currentValue end end)
			task.delay(0, function() local contentHeight = InputContent.TextBounds.Y; local titleHeight = InputTitle.TextBounds.Y; InputFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15)); SectionObject._UpdateSizeSection() end)
			CountItem = CountItem + 1; return { GetValue = function() return currentValue end, SetValue = function(val) currentValue = val; TextBox.Text = val; if InputConfig.Flag then SaveFile(InputConfig.Flag, currentValue) end; InputConfig.Callback(currentValue) end }
		end
		-- AddDropdown and AddDivider are more complex and will be adapted similarly
		-- For brevity, only including the structure for now.
		SectionObject.AddDropdown = Section.AddDropdown -- Assign existing complex functions
		SectionObject.AddDropdown = Section.AddDropdown -- Assign existing complex functions
		-- SectionObject.AddDivider = Section.AddDivider   -- This was an error, AddDivider is defined on Section, not SectionObject for settings
		-- Corrected: Define AddDivider for SectionObject within SettingsTab:AddSection if it's not inheriting properly
		-- Or ensure the AddDivider from the main Section definition is used.
		-- For now, let's assume the AddDivider from the main Section definition is what we want to use here too,
		-- or rather, that it was correctly defined on SectionObject as part of the copy.

		-- The crucial missing return was for SectionObject from SettingsTab:AddSection
		-- However, the diff where SettingsTab:AddSection was created already includes "return SectionObject"
		-- Let me re-check the diff where SettingsTab:AddSection was introduced.
		-- The diff was:
		--    SectionObject.AddDropdown = Section.AddDropdown -- Assign existing complex functions
		--    SectionObject.AddDivider = Section.AddDivider   -- Assign existing complex functions
		--    settingsSectionCount = settingsSectionCount + 1
		--    return SectionObject
		-- So the return IS there.
		-- The issue might be in how AddDivider was assigned or if SectionObject itself is not what's expected.

		-- Let's ensure all methods, including AddDivider, are correctly on SectionObject.
		-- The previous diff for populating SectionObject methods was:
		-- SectionObject.AddDropdown = Section.AddDropdown
		-- SectionObject.AddDivider = Section.AddDivider
		-- This implies it *should* be there.

		-- The user's provided code for AddDivider was "function Items:AddDivider(DividerConfig)"
		-- which I then integrated as "function Section:AddDivider(DividerConfig)"
		-- For SettingsTab, this should be "function SectionObject:AddDivider(DividerConfig)"

		-- Let's ensure the AddDivider is correctly defined for the SectionObject within SettingsTab:AddSection
		-- by copying the corrected AddDivider logic directly into it.

		function SectionObject:AddDivider(DividerConfig) -- Copied from user's corrected version
			local DividerConfig = DividerConfig or {}
			DividerConfig.Text = DividerConfig.Text or nil 
		
			local DividerContainer = Instance.new("Frame")
			DividerContainer.Name = "Divider"
			DividerContainer.Size = UDim2.new(1, 0, 0, 20) 
			DividerContainer.BackgroundTransparency = 1
			DividerContainer.LayoutOrder = CountItem -- This CountItem is local to SectionObject's methods scope
			DividerContainer.Parent = SectionObject._SectionAdd 
		
			if not DividerConfig.Text or DividerConfig.Text == "" then
				local Line = Instance.new("Frame")
				Line.Name = "FullLine"
				Line.BackgroundColor3 = DividerConfig.Color or Color3.fromRGB(120, 120, 120)
				Line.BorderSizePixel = 0
				Line.AnchorPoint = Vector2.new(0.5, 0.5)
				Line.Position = UDim2.new(0.5, 0, 0.5, 0)
				Line.Size = UDim2.new(1, -10, 0, 1) 
				Line.Parent = DividerContainer
			else
				DividerContainer.Size = UDim2.new(1, 0, 0, (DividerConfig.TextSize or 12) + 8)

				local ListLayout = Instance.new("UIListLayout")
				ListLayout.FillDirection = Enum.FillDirection.Horizontal
				ListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
				ListLayout.SortOrder = Enum.SortOrder.LayoutOrder 
				ListLayout.Padding = UDim.new(0, 8) 
				ListLayout.Parent = DividerContainer
		
				local Line1 = Instance.new("Frame")
				Line1.Name = "Line1"
				Line1.BackgroundColor3 = DividerConfig.Color or Color3.fromRGB(120, 120, 120)
				Line1.BorderSizePixel = 0
				Line1.Size = UDim2.new(1, 0, 0, 1) 
				Line1.LayoutOrder = 1
				Line1.Parent = DividerContainer
		
				local DividerText = Instance.new("TextLabel")
				DividerText.Name = "DividerText"
				DividerText.Text = DividerConfig.Text
				DividerText.TextColor3 = DividerConfig.TextColor or Color3.fromRGB(200, 200, 200)
				DividerText.Font = DividerConfig.Font or Enum.Font.GothamBold
				DividerText.TextSize = DividerConfig.TextSize or 12
				DividerText.BackgroundTransparency = 1
				DividerText.AutomaticSize = Enum.AutomaticSize.X 
				DividerText.Size = UDim2.new(0, 0, 1, 0) 
				DividerText.LayoutOrder = 2
				DividerText.Parent = DividerContainer
				
				local Line2 = Instance.new("Frame")
				Line2.Name = "Line2"
				Line2.BackgroundColor3 = DividerConfig.Color or Color3.fromRGB(120, 120, 120)
				Line2.BorderSizePixel = 0
				Line2.Size = UDim2.new(1, 0, 0, 1) 
				Line2.LayoutOrder = 3
				Line2.Parent = DividerContainer
			end
			
			task.defer(function()
				SectionObject._UpdateSizeSection()
				SectionObject._UpdateSizeScroll()
			end)
		
			CountItem = CountItem + 1
			return {} 
		end

		settingsSectionCount = settingsSectionCount + 1
		return SectionObject
	end

	-- Populate Settings Page
	local PresetsSection = SettingsTab:AddSection("Presets")
	local availableThemes = GetThemes()
	for _, themeName in ipairs(availableThemes) do
		PresetsSection:AddButton({
			Title = themeName,
			Content = "Click to apply this theme",
			Callback = function()
				SetTheme(themeName)
			end
		})
	end

	local InterfaceSection = SettingsTab:AddSection("Interface")
	-- Transparency Slider
	InterfaceSection:AddSlider({
		Title = "Window Transparency",
		Content = "Adjust background opacity",
		Min = 0,
		Max = 100, -- Representing 0.0 to 1.0
		Increment = 1,
		Default = Main.BackgroundTransparency * 100,
		Callback = function(value)
			ChangeTransparency(value / 100) -- ChangeTransparency expects 0-1
		end,
		Flag = "UI_BackgroundTransparency" -- Optional: For saving/loading if desired later
	})

	-- Custom Background
	local bgAssetInput = InterfaceSection:AddInput({
		Title = "Background Asset URL/Path",
		Content = "Enter image/video URL or local path",
		Default = Flags["CustomBackgroundURL"] or ""
	})

	InterfaceSection:AddButton({
		Title = "Set Image Background",
		Content = "Apply image from URL/Path",
		Callback = function()
			local assetUrl = bgAssetInput:GetValue()
			if assetUrl and assetUrl ~= "" then
				ChangeAsset("Image", assetUrl, "CustomBG_Img")
				SaveFile("CustomBackgroundURL", assetUrl) -- Save the URL
				SaveFile("CustomBackgroundType", "Image")
			end
		end
	})

	InterfaceSection:AddButton({
		Title = "Set Video Background",
		Content = "Apply video from URL/Path",
		Callback = function()
			local assetUrl = bgAssetInput:GetValue()
			if assetUrl and assetUrl ~= "" then
				ChangeAsset("Video", assetUrl, "CustomBG_Vid")
				SaveFile("CustomBackgroundURL", assetUrl) -- Save the URL
				SaveFile("CustomBackgroundType", "Video")
			end
		end
	})

	InterfaceSection:AddButton({
		Title = "Reset Background",
		Content = "Remove custom background",
		Callback = function()
			Reset()
			SaveFile("CustomBackgroundURL", "") -- Clear saved URL
			SaveFile("CustomBackgroundType", "")
		end
	})

	local CustomizeColorsSection = SettingsTab:AddSection("Customize Colors")
	local function createColorSliders(colorKeyName, initialColor3)
		CustomizeColorsSection:AddParagraph({Title = colorKeyName, Content = ""}) -- Simple label for the color property

		local r, g, b = math.floor(initialColor3.R * 255), math.floor(initialColor3.G * 255), math.floor(initialColor3.B * 255)

		local rSlider, gSlider, bSlider -- Forward declare for callbacks if needed, though direct update is fine

		rSlider = CustomizeColorsSection:AddSlider({
			Title = "Red", Content = "", Min = 0, Max = 255, Increment = 1, Default = r,
			Callback = function(newR)
				local currentColor = Themes[CurrentTheme][colorKeyName]
				Themes[CurrentTheme][colorKeyName] = Color3.fromRGB(newR, math.floor(currentColor.G * 255), math.floor(currentColor.B * 255))
				SetTheme(CurrentTheme)
			end
		})
		gSlider = CustomizeColorsSection:AddSlider({
			Title = "Green", Content = "", Min = 0, Max = 255, Increment = 1, Default = g,
			Callback = function(newG)
				local currentColor = Themes[CurrentTheme][colorKeyName]
				Themes[CurrentTheme][colorKeyName] = Color3.fromRGB(math.floor(currentColor.R * 255), newG, math.floor(currentColor.B * 255))
				SetTheme(CurrentTheme)
			end
		})
		bSlider = CustomizeColorsSection:AddSlider({
			Title = "Blue", Content = "", Min = 0, Max = 255, Increment = 1, Default = b,
			Callback = function(newB)
				local currentColor = Themes[CurrentTheme][colorKeyName]
				Themes[CurrentTheme][colorKeyName] = Color3.fromRGB(math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), newB)
				SetTheme(CurrentTheme)
			end
		})
	end

	-- Iterate over a sample theme to get all color keys, assuming all themes have the same keys
	local sampleThemeName = next(Themes) -- Get the first theme name as a sample
	if sampleThemeName then
		for key, colorValue in pairs(Themes[sampleThemeName]) do
			if typeof(colorValue) == "Color3" then
				-- We need to ensure CurrentTheme's values are used for defaults and updates.
				-- The createColorSliders function will read from Themes[CurrentTheme]
				-- For initial creation, we pass the current value from Themes[CurrentTheme]
				createColorSliders(key, Themes[CurrentTheme][key] or colorValue) 
			end
		end
	end

	--// Layer Tabs
	local ScrollTab = Instance.new("ScrollingFrame");
	local UIListLayout = Instance.new("UIListLayout");

	ScrollTab.CanvasSize = UDim2.new(0, 0, 1.10000002, 0)
	ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	ScrollTab.ScrollBarThickness = 0
	ScrollTab.Active = true
	ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollTab.BackgroundTransparency = 0.9990000128746033
	ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollTab.BorderSizePixel = 0
	ScrollTab.Size = UDim2.new(1, 0, 1, -50)
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = LayersTab

	UIListLayout.Padding = UDim.new(0, 3)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = ScrollTab

	local function UpdateSize1()
		local OffsetY = 0
		for _, child in ScrollTab:GetChildren() do
			if child.Name ~= "UIListLayout" then
				OffsetY = OffsetY + 3 + child.Size.Y.Offset
			end
		end
		ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
	end
	ScrollTab.ChildAdded:Connect(UpdateSize1)
	ScrollTab.ChildRemoved:Connect(UpdateSize1)

	local Info = Instance.new("Frame");
	local UICorner = Instance.new("UICorner");
	local LogoPlayerFrame = Instance.new("Frame")
	local UICorner1 = Instance.new("UICorner");
	local LogoPlayer = Instance.new("ImageLabel");
	local UICorner2 = Instance.new("UICorner");
	local NamePlayer = Instance.new("TextLabel");
		
	Info.AnchorPoint = Vector2.new(1, 1)
	Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Info.BackgroundTransparency = 0.95
	Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Info.BorderSizePixel = 0
	Info.Position = UDim2.new(1, 0, 1, 0)
	Info.Size = UDim2.new(1, 0, 0, 40)
	Info.Name = "Info"
	Info.Visible = LibraryCfg.ShowPlayer
	Info.Parent = LayersTab

	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = Info

	LogoPlayerFrame.AnchorPoint = Vector2.new(0, 0.5)
	LogoPlayerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoPlayerFrame.BackgroundTransparency = 0.95
	LogoPlayerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoPlayerFrame.BorderSizePixel = 0
	LogoPlayerFrame.Position = UDim2.new(0, 5, 0.5, 0)
	LogoPlayerFrame.Size = UDim2.new(0, 30, 0, 30)
	LogoPlayerFrame.Name = "LogoPlayerFrame"
	LogoPlayerFrame.Parent = Info

	UICorner1.CornerRadius = UDim.new(0, 1000)
	UICorner1.Parent = LogoPlayerFrame

	LogoPlayer.Image = GuiConfig["Logo Player"]
	LogoPlayer.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoPlayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoPlayer.BackgroundTransparency = 0.999
	LogoPlayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoPlayer.BorderSizePixel = 0
	LogoPlayer.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogoPlayer.Size = UDim2.new(1, -5, 1, -5)
	LogoPlayer.Name = "LogoPlayer"
	LogoPlayer.Parent = LogoPlayerFrame

	UICorner2.CornerRadius = UDim.new(0, 1000)
	UICorner2.Parent = LogoPlayer

	local NamePlayerButton = Instance.new("TextButton")
	NamePlayerButton.Name = "NamePlayerButton"
	NamePlayerButton.Text = GuiConfig["Name Player"]
	NamePlayerButton.Font = Enum.Font.GothamBold
	NamePlayerButton.TextColor3 = Color3.fromRGB(230, 230, 230)
	NamePlayerButton.TextSize = 12
	NamePlayerButton.TextWrapped = true
	NamePlayerButton.TextXAlignment = Enum.TextXAlignment.Left
	NamePlayerButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NamePlayerButton.BackgroundTransparency = 1 -- Make it look like a label initially
	NamePlayerButton.BorderSizePixel = 0
	NamePlayerButton.Position = UDim2.new(0, 40, 0, 0)
	NamePlayerButton.Size = UDim2.new(1, -45, 1, 0)
	NamePlayerButton.Parent = Info
	NamePlayerButton.AutoButtonColor = false

	local isSettingsViewActive = false
	local lastSelectedTabName = "" -- To store the name of the last active tab

	NamePlayerButton.MouseButton1Click:Connect(function()
		isSettingsViewActive = not isSettingsViewActive
		if isSettingsViewActive then
			if LayersPageLayout.CurrentPage then
				lastSelectedTabName = LayersPageLayout.CurrentPage:FindFirstChild("TabConfig_Name") and LayersPageLayout.CurrentPage.TabConfig_Name.Value or "Unknown Tab"
			else -- Fallback if no tab was ever selected or CurrentPage is nil
				-- Attempt to find the first tab's name as a default
				if ScrollTab:FindFirstChild("Tab") and ScrollTab.Tab:FindFirstChild("TabName") then
					lastSelectedTabName = ScrollTab.Tab.TabName.Text
				else
					lastSelectedTabName = GuiConfig.NameHub -- Default to hub name if no tabs
				end
			end
			Layers.Visible = false
			SettingsPage.Visible = true
			NameTab.Text = "Settings"
		else
			SettingsPage.Visible = false
			Layers.Visible = true
			NameTab.Text = lastSelectedTabName
			-- Try to re-select the actual current tab to refresh its content if needed,
			-- though just setting NameTab.Text might be sufficient for now.
			-- This assumes LayersPageLayout.CurrentPage is still valid.
			if LayersPageLayout.CurrentPage and LayersPageLayout.CurrentPage:FindFirstChild("TabButton") then
				-- To avoid re-triggering full tab selection logic if not necessary,
				-- we primarily ensure NameTab.Text is correct.
				-- A more robust way might involve a dedicated function to update NameTab.
			end
		end
	end)

	-- NamePlayer TextLabel removed, will be replaced by a TextButton below
	local GuiFunc = {}
	function GuiFunc:DestroyGui()
		if CoreGui:FindFirstChild("UBHubGui") then 
			UBHubGui:Destroy()
		end
	end
	local OldPos = DropShadowHolder.Position
	local OldSize = DropShadowHolder.Size
	local MinimizedIcon = Instance.new("ImageButton")
	local MinCorner = Instance.new("UICorner")
	local ScreenGui = Instance.new("ScreenGui")
	do
		ProtectGui(ScreenGui)
	end
	ScreenGui.Name = "افتحادخل"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	MinimizedIcon.Size = UDim2.new(0, 55, 0, 50)
	MinimizedIcon.Position = UDim2.new(0.1021, 0, 0.0743, 0)
	MinimizedIcon.BackgroundTransparency = 0
	MinimizedIcon.Parent = ScreenGui
	MinimizedIcon.Draggable = true
	MinimizedIcon.Visible = false
	MinimizedIcon.BorderColor3 = GetColor("ThemeHighlight",MinimizedIcon,"BorderColor3")
	if _G.Script == "UB" then
		MinimizedIcon.Image = LoadUIAsset("rbxassetid://123551041633320", "LogoUB.png")
	elseif _G.Script == "Swee" then
		MinimizedIcon.Image = LoadUIAsset("rbxassetid://135386452636194", "SweeHubLogo.png")
	else
		MinimizedIcon.Image = "rbxassetid://0"
	end
	MinCorner.CornerRadius = UDim.new(0, 40)
	MinCorner.Parent = MinimizedIcon
	Min.Activated:Connect(function()
		CircleClick(Min, Mouse.X, Mouse.Y)
		DropShadowHolder.Visible = false
		DropShadow.Visible = false
        MinimizedIcon.Visible = true
	end)
	MaxRestore.Activated:Connect(function()
		CircleClick(MaxRestore, Mouse.X, Mouse.Y)
		if ImageLabel.Image == LoadUIAsset("rbxassetid://9886659406", "MaxRestoreA.png")  then
			ImageLabel.Image = LoadUIAsset("rbxassetid://9886659406", "MaxRestoreA.png") 
			OldPos = DropShadowHolder.Position
			OldSize = DropShadowHolder.Size
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)}):Play()
		else
			ImageLabel.Image = LoadUIAsset("rbxassetid://9886659406", "MaxRestore.png")
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = OldPos}):Play()
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = OldSize}):Play()
		end
	end)
	MinimizedIcon.MouseButton1Click:Connect(function()
		DropShadowHolder.Visible = true
		DropShadow.Visible = true
		MinimizedIcon.Visible = false
	end)

	Close.Activated:Connect(function()
		GuiFunc:DestroyGui()
	end)
	function GuiFunc:ToggleUI()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "RightShift",false,game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "RightShift",false,game)
	end
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.RightShift then
			if DropShadowHolder.Visible then
				DropShadowHolder.Visible = false
			else
				DropShadowHolder.Visible = true
			end
		end
	end)
	DropShadowHolder.Size = UDim2.new(0, 150 + TextLabel.TextBounds.X + 1 + TextLabel1.TextBounds.X, 0, 450)
	MakeDraggable(Top, DropShadowHolder)
	--// Blur
	local MoreBlur = Instance.new("Frame");
	local DropShadowHolder1 = Instance.new("Frame");
	local DropShadow1 = Instance.new("ImageLabel");
	local UICorner28 = Instance.new("UICorner");
	local ConnectButton = Instance.new("TextButton");
	
	MoreBlur.AnchorPoint = Vector2.new(1, 1)
	MoreBlur.BackgroundColor3 = GetColor("Accent",MoreBlur,"BackgroundColor3")
	MoreBlur.BackgroundTransparency = 0.999
	MoreBlur.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MoreBlur.BorderSizePixel = 0
	MoreBlur.ClipsDescendants = true
	MoreBlur.Position = UDim2.new(1, 8, 1, 8)
	MoreBlur.Size = SizeUI
	MoreBlur.Visible = false
	MoreBlur.Name = "MoreBlur"
	MoreBlur.Parent = Layers
	local blurResizeAPI = MakeResizable(MoreBlur, "Blur")
	if savedSize then
		blurResizeAPI:SetSize(savedSize)
		SaveFile("Blur", string.format("%d,%d", savedSize.X.Offset, savedSize.Y.Offset))
	end
	DropShadowHolder1.BackgroundTransparency = 1
	DropShadowHolder1.BorderSizePixel = 0
	DropShadowHolder1.Size = UDim2.new(1, 0, 1, 0)
	DropShadowHolder1.ZIndex = 0
	DropShadowHolder1.Name = "DropShadowHolder"
	DropShadowHolder1.Parent = MoreBlur
	DropShadowHolder1.Visible = false

	DropShadow1.Image = LoadUIAsset("rbxassetid://6015897843", "DropShadow1.png")
	DropShadow1.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow1.ImageTransparency = 0.5
	DropShadow1.ScaleType = Enum.ScaleType.Slice
	DropShadow1.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow1.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow1.BackgroundTransparency = 1
	DropShadow1.BorderSizePixel = 0
	DropShadow1.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow1.Size = UDim2.new(1, 35, 1, 35)
	DropShadow1.ZIndex = 0
	DropShadow1.Name = "DropShadow"
	DropShadow1.Parent = DropShadowHolder1
	DropShadow1.Visible = false

	UICorner28.Parent = MoreBlur

	ConnectButton.Font = Enum.Font.SourceSans
	ConnectButton.Text = ""
	ConnectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	ConnectButton.TextSize = 14
	ConnectButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConnectButton.BackgroundTransparency = 0.999
	ConnectButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConnectButton.BorderSizePixel = 0
	ConnectButton.Size = UDim2.new(1, 0, 1, 0)
	ConnectButton.Name = "ConnectButton"
	ConnectButton.Parent = MoreBlur

	local DropdownSelect = Instance.new("Frame");
	local UICorner36 = Instance.new("UICorner");
	local UIStroke14 = Instance.new("UIStroke");
	local DropdownSelectReal = Instance.new("Frame");
	local DropdownFolder = Instance.new("Folder");
	local DropPageLayout = Instance.new("UIPageLayout");

	DropdownSelect.AnchorPoint = Vector2.new(1, 0.5)
	DropdownSelect.BackgroundColor3 = GetColor("Primary",DropdownSelect,"BackgroundColor3")
	DropdownSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownSelect.BorderSizePixel = 0
	DropdownSelect.LayoutOrder = 1
	DropdownSelect.Position = UDim2.new(1, 172, 0.5, 0)
	DropdownSelect.Size = UDim2.new(0, 160, 1, -16)
	DropdownSelect.Name = "DropdownSelect"
	DropdownSelect.ClipsDescendants = true
	DropdownSelect.Parent = MoreBlur

	ConnectButton.Activated:Connect(function()
		if MoreBlur.Visible then
			TweenService:Create(MoreBlur, TweenInfo.new(0.3), {BackgroundTransparency = 0.999}):Play()
			TweenService:Create(DropdownSelect, TweenInfo.new(0.3), {Position = UDim2.new(1, 172, 0.5, 0)}):Play()
			task.wait(0.3)
			MoreBlur.Visible = false
		end
	end)
	UICorner36.CornerRadius = UDim.new(0, 3)
	UICorner36.Parent = DropdownSelect

	UIStroke14.Color = Color3.fromRGB(255, 255, 255)
	UIStroke14.Thickness = 2.5
	UIStroke14.Transparency = 0.8
	UIStroke14.Parent = DropdownSelect

	DropdownSelectReal.AnchorPoint = Vector2.new(0.5, 0.5)
	DropdownSelectReal.BackgroundColor3 = GetColor("Primary",DropdownSelectReal,"BackgroundColor3")
	DropdownSelectReal.BackgroundTransparency = 0.9990000128746033
	DropdownSelectReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownSelectReal.BorderSizePixel = 0
	DropdownSelectReal.LayoutOrder = 1
	DropdownSelectReal.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropdownSelectReal.Size = UDim2.new(1, -10, 1, -10)
	DropdownSelectReal.Name = "DropdownSelectReal"
	DropdownSelectReal.Parent = DropdownSelect

	DropdownFolder.Name = "DropdownFolder"
	DropdownFolder.Parent = DropdownSelectReal

	DropPageLayout.EasingDirection = Enum.EasingDirection.InOut
	DropPageLayout.EasingStyle = Enum.EasingStyle.Quad
	DropPageLayout.TweenTime = 0.009999999776482582
	DropPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	DropPageLayout.Archivable = false
	DropPageLayout.Name = "DropPageLayout"
	DropPageLayout.Parent = DropdownFolder
	--// Tabs
	local CountTab = 0
	local CountDropdown = 0
	function UIInstance:CreateTab(TabConfig)
		local TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""

		local ScrolLayers = Instance.new("ScrollingFrame");
		local UIListLayout1 = Instance.new("UIListLayout");

		ScrolLayers.ScrollBarImageColor3 = Color3.fromRGB(80.00000283122063, 80.00000283122063, 80.00000283122063)
		ScrolLayers.ScrollBarThickness = 0
		ScrolLayers.Active = true
		ScrolLayers.LayoutOrder = CountTab
		ScrolLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrolLayers.BackgroundTransparency = 0.9990000128746033
		ScrolLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrolLayers.BorderSizePixel = 0
		ScrolLayers.Size = UDim2.new(1, 0, 1, 0)
		ScrolLayers.Name = "ScrolLayers"
		ScrolLayers.Parent = LayersFolder

		local TabConfigNameValue = Instance.new("StringValue")
		TabConfigNameValue.Name = "TabConfig_Name"
		TabConfigNameValue.Value = TabConfig.Name
		TabConfigNameValue.Parent = ScrolLayers

		UIListLayout1.Padding = UDim.new(0, 3)
		UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout1.Parent = ScrolLayers

		local Tab = Instance.new("Frame");
		local UICorner3 = Instance.new("UICorner");
		local TabButton = Instance.new("TextButton");
		local TabName = Instance.new("TextLabel")
		local FeatureImg = Instance.new("ImageLabel");
		local UIStroke2 = Instance.new("UIStroke");
		local UICorner4 = Instance.new("UICorner");

		Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		if CountTab == 0 then
			Tab.BackgroundTransparency = 0.9200000166893005
		else
			Tab.BackgroundTransparency = 0.9990000128746033
		end
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BorderSizePixel = 0
		Tab.LayoutOrder = CountTab
		Tab.Size = UDim2.new(1, 0, 0, 30)
		Tab.Name = "Tab"
		Tab.Parent = ScrollTab

		UICorner3.CornerRadius = UDim.new(0, 4)
		UICorner3.Parent = Tab

		TabButton.Font = Enum.Font.GothamBold
		TabButton.Text = ""
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.TextSize = 13
		TabButton.TextXAlignment = Enum.TextXAlignment.Left
		TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.BackgroundTransparency = 0.9990000128746033
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 1, 0)
		TabButton.Name = "TabButton"
		TabButton.Parent = Tab

		TabName.Font = Enum.Font.GothamBold
		TabName.Text = TabConfig.Name
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextSize = 13
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 0.9990000128746033
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Size = UDim2.new(1, 0, 1, 0)
		TabName.Position = UDim2.new(0, 30, 0, 0)
		TabName.Name = "TabName"
		TabName.Parent = Tab

		FeatureImg.Image = TabConfig.Icon
		FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FeatureImg.BackgroundTransparency = 0.9990000128746033
		FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FeatureImg.BorderSizePixel = 0
		FeatureImg.Position = UDim2.new(0, 9, 0, 7)
		FeatureImg.Size = UDim2.new(0, 16, 0, 16)
		FeatureImg.Name = "FeatureImg"
		FeatureImg.Parent = Tab
		if CountTab == 0 then
			LayersPageLayout:JumpToIndex(0)
			NameTab.Text = TabConfig.Name
			local ChooseFrame = Instance.new("Frame");
			ChooseFrame.BackgroundColor3 = GetColor("ThemeHighlight",ChooseFrame,"BackgroundColor3")
			ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ChooseFrame.BorderSizePixel = 0
			ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
			ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
			ChooseFrame.Name = "ChooseFrame"
			ChooseFrame.Parent = Tab

			UIStroke2.Color = GetColor("Secondary",UIStroke2,"Color")
			UIStroke2.Thickness = 1.600000023841858
			UIStroke2.Parent = ChooseFrame

			UICorner4.Parent = ChooseFrame
		end
		TabButton.Activated:Connect(function()
			CircleClick(TabButton, Mouse.X, Mouse.Y)
			local FrameChoose
			for a, s in ScrollTab:GetChildren() do
				for i, v in s:GetChildren() do
					if v.Name == "ChooseFrame" then
						FrameChoose = v
						break
					end
				end
			end
			if FrameChoose ~= nil and Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
				for _, TabFrame in ScrollTab:GetChildren() do
					if TabFrame.Name == "Tab" then
						TweenService:Create(TabFrame,TweenInfo.new(0.2, Enum.EasingStyle.Linear),{BackgroundTransparency = 0.9990000128746033}):Play()
					end    
				end
				TweenService:Create(Tab, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.92}):Play()
				TweenService:Create(FrameChoose,TweenInfo.new(0.2, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 2, 0, 9 + (33 * Tab.LayoutOrder))}):Play()
				LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
				NameTab.Text = TabConfig.Name
				TweenService:Create(FrameChoose,TweenInfo.new(0.2, Enum.EasingStyle.Linear),{Size = UDim2.new(0, 1, 0, 20)}):Play()
			end
		end)
		--// Section
		local CountSection = 0 -- Keep this counter for layout order if needed globally for sections

		-- Define Tab object structure and its AddSection method
		local Tab = {}
		Tab._ScrolLayers = ScrolLayers -- Store reference to the tab's content scroller

		function Tab:AddSection(Title)
			Title = Title or "Title"
			local CurrentScrolLayers = self._ScrolLayers -- Use the ScrolLayers specific to this Tab instance

			local SectionFrame = Instance.new("Frame"); -- Renamed from 'Section' to 'SectionFrame' to avoid conflict with the 'Section' object
			local SectionDecideFrame = Instance.new("Frame");
			local UICorner1_Section = Instance.new("UICorner"); -- Suffixing to avoid name collision
			local UIGradient_Section = Instance.new("UIGradient");

			SectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionFrame.BackgroundTransparency = 0.9990000128746033
			SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionFrame.BorderSizePixel = 0
			SectionFrame.LayoutOrder = CountSection -- This CountSection might need to be managed per-tab or reset if it's global
			SectionFrame.ClipsDescendants = true
			SectionFrame.Size = UDim2.new(1, 0, 0, 30)
			SectionFrame.Name = "Section" -- Original name, should be fine
			SectionFrame.Parent = CurrentScrolLayers

			local SectionReal = Instance.new("Frame");
			local UICorner_SectionReal = Instance.new("UICorner");
			local UIStroke_SectionReal = Instance.new("UIStroke");
			local SectionButton = Instance.new("TextButton");
			local FeatureFrame_Section = Instance.new("Frame");
			local FeatureImg_Section = Instance.new("ImageLabel");
			local SectionTitleText = Instance.new("TextLabel"); -- Renamed from SectionTitle

			SectionReal.AnchorPoint = Vector2.new(0.5, 0)
			SectionReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionReal.BackgroundTransparency = 0.9350000023841858
			SectionReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionReal.BorderSizePixel = 0
			SectionReal.LayoutOrder = 1
			SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
			SectionReal.Size = UDim2.new(1, 1, 0, 30)
			SectionReal.Name = "SectionReal"
			SectionReal.Parent = SectionFrame

			UICorner_SectionReal.CornerRadius = UDim.new(0, 4)
			UICorner_SectionReal.Parent = SectionReal

			SectionButton.Font = Enum.Font.SourceSans
			SectionButton.Text = ""
			SectionButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			SectionButton.TextSize = 14
			SectionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionButton.BackgroundTransparency = 0.9990000128746033
			SectionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionButton.BorderSizePixel = 0
			SectionButton.Size = UDim2.new(1, 0, 1, 0)
			SectionButton.Name = "SectionButton"
			SectionButton.Parent = SectionReal

			FeatureFrame_Section.AnchorPoint = Vector2.new(1, 0.5)
			FeatureFrame_Section.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			FeatureFrame_Section.BackgroundTransparency = 0.9990000128746033
			FeatureFrame_Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureFrame_Section.BorderSizePixel = 0
			FeatureFrame_Section.Position = UDim2.new(1, -5, 0.5, 0)
			FeatureFrame_Section.Size = UDim2.new(0, 20, 0, 20)
			FeatureFrame_Section.Name = "FeatureFrame"
			FeatureFrame_Section.Parent = SectionReal

			FeatureImg_Section.Image = LoadUIAsset("rbxassetid://16851841101", "FeatureImg")
			FeatureImg_Section.AnchorPoint = Vector2.new(0.5, 0.5)
			FeatureImg_Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeatureImg_Section.BackgroundTransparency = 0.9990000128746033
			FeatureImg_Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureImg_Section.BorderSizePixel = 0
			FeatureImg_Section.Position = UDim2.new(0.5, 0, 0.5, 0)
			FeatureImg_Section.Rotation = -90
			FeatureImg_Section.Size = UDim2.new(1, 6, 1, 6)
			FeatureImg_Section.Name = "FeatureImg"
			FeatureImg_Section.Parent = FeatureFrame_Section

			SectionTitleText.Font = Enum.Font.GothamBold
			SectionTitleText.Text = Title
			SectionTitleText.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
			SectionTitleText.TextSize = 13
			SectionTitleText.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitleText.TextYAlignment = Enum.TextYAlignment.Top
			SectionTitleText.AnchorPoint = Vector2.new(0, 0.5)
			SectionTitleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitleText.BackgroundTransparency = 0.9990000128746033
			SectionTitleText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionTitleText.BorderSizePixel = 0
			SectionTitleText.Position = UDim2.new(0, 10, 0.5, 0)
			SectionTitleText.Size = UDim2.new(1, -50, 0, 13)
			SectionTitleText.Name = "SectionTitle"
			SectionTitleText.Parent = SectionReal

			SectionDecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionDecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionDecideFrame.AnchorPoint = Vector2.new(0.5, 0)
			SectionDecideFrame.BorderSizePixel = 0
			SectionDecideFrame.Position = UDim2.new(0.5, 0, 0, 33)
			SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
			SectionDecideFrame.Name = "SectionDecideFrame"
			SectionDecideFrame.Parent = SectionFrame

			UICorner1_Section.Parent = SectionDecideFrame

			UIGradient_Section.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Themes.UB_Orange.Primary),
				ColorSequenceKeypoint.new(0.5, GuiConfig.Color), -- Assuming GuiConfig is accessible here or passed down
				ColorSequenceKeypoint.new(1, Themes.UB_Orange.Primary)
			}
			UIGradient_Section.Parent = SectionDecideFrame
			
			local SectionAdd = Instance.new("Frame");
			local UICorner8_SectionAdd = Instance.new("UICorner");
			local UIListLayout2_SectionAdd = Instance.new("UIListLayout");

			SectionAdd.AnchorPoint = Vector2.new(0.5, 0)
			SectionAdd.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionAdd.BackgroundTransparency = 0.9990000128746033
			SectionAdd.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionAdd.BorderSizePixel = 0
			SectionAdd.ClipsDescendants = true
			SectionAdd.LayoutOrder = 1 
			SectionAdd.Position = UDim2.new(0.5, 0, 0, 38)
			SectionAdd.Size = UDim2.new(1, 0, 0, 100) 
			SectionAdd.Name = "SectionAdd"
			SectionAdd.Parent = SectionFrame

			UICorner8_SectionAdd.CornerRadius = UDim.new(0, 2)
			UICorner8_SectionAdd.Parent = SectionAdd

			UIListLayout2_SectionAdd.Padding = UDim.new(0, 3)
			UIListLayout2_SectionAdd.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout2_SectionAdd.Parent = SectionAdd
			
			local OpenSection = false
			local function UpdateSizeScroll_Section() -- Renamed to avoid conflict
				game:GetService("RunService").Heartbeat:Wait()
				local totalHeight = 0
				for _, child in ipairs(CurrentScrolLayers:GetChildren()) do
					if child:IsA("Frame") and child.Name == "Section" then -- check for actual section frames
						totalHeight = totalHeight + child.Size.Y.Offset + UIListLayout1.Padding.Offset
					end
				end
				CurrentScrolLayers.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
			end

			local function UpdateSizeSection_Inner() -- Renamed
				if OpenSection then
					UIListLayout2_SectionAdd:GetPropertyChangedSignal("AbsoluteContentSize"):Wait()
					local contentHeight = UIListLayout2_SectionAdd.AbsoluteContentSize.Y
					local newHeight = math.max(38 + contentHeight + UIListLayout2_SectionAdd.Padding.Offset, 30)
					FeatureFrame_Section.Rotation = 90
					SectionFrame.Size = UDim2.new(1, 0, 0, newHeight) -- Use SectionFrame
					SectionAdd.Size = UDim2.new(1, 0, 0, contentHeight)
					SectionDecideFrame.Size = UDim2.new(1, 0, 0, 2)
					UpdateSizeScroll_Section()
				else
					FeatureFrame_Section.Rotation = 0
					SectionFrame.Size = UDim2.new(1, 0, 0, 30) -- Use SectionFrame
					SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
					UpdateSizeScroll_Section()
				end
			end

			SectionButton.Activated:Connect(function()
				CircleClick(SectionButton, Mouse.X, Mouse.Y)
				OpenSection = not OpenSection
				if OpenSection then
					TweenService:Create(FeatureImg_Section, TweenInfo.new(0.3), {Rotation = -90}):Play()
					local contentHeight = 0
					for _, child in ipairs(SectionAdd:GetChildren()) do
						if child:IsA("Frame") then
							contentHeight = contentHeight + child.AbsoluteSize.Y + UIListLayout2_SectionAdd.Padding.Offset
						end
					end
					if #SectionAdd:GetChildren() > 0 then contentHeight = contentHeight - UIListLayout2_SectionAdd.Padding.Offset end -- Adjust for last item padding

					SectionAdd.Size = UDim2.new(1, 0, 0, contentHeight)
					SectionFrame.Size = UDim2.new(1, 0, 0, 38 + contentHeight)
					SectionDecideFrame.Size = UDim2.new(1, 0, 0, 2)
					SectionAdd.Visible = true
					TweenService:Create(SectionAdd, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, contentHeight)}):Play()
				else
					TweenService:Create(FeatureImg_Section, TweenInfo.new(0.3), {Rotation = 0}):Play()
					TweenService:Create(SectionAdd, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
					task.delay(0.31, function()
						SectionAdd.Visible = false
						SectionFrame.Size = UDim2.new(1, 0, 0, 30)
						SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
						UpdateSizeScroll_Section()
					end)
				end
				UpdateSizeScroll_Section()
			end)
			
			SectionAdd.ChildAdded:Connect(UpdateSizeSection_Inner)
			SectionAdd.ChildRemoved:Connect(UpdateSizeSection_Inner)
			UpdateSizeScroll_Section() -- Initial call

			-- Define the Section object to be returned
			local Section = {}
			Section._SectionAdd = SectionAdd -- Store reference to this section's item container
			Section._UpdateSizeSection = UpdateSizeSection_Inner -- Expose for items to call
			Section._UpdateSizeScroll = UpdateSizeScroll_Section -- Expose for items to call

			local Items = {} -- This will be populated on the Section object directly
			local CountItem = 0

			function Section:AddParagraph(ParagraphConfig)
				local ParagraphConfig = ParagraphConfig or {}
				ParagraphConfig.Title = ParagraphConfig.Title or "Title"
				ParagraphConfig.Content = ParagraphConfig.Content or "Content"
				local ParagraphFunc = {}
				
				local Paragraph = Instance.new("Frame");
				local UICorner14 = Instance.new("UICorner");
				local ParagraphTitle = Instance.new("TextLabel");
				-- local ParagraphContent = Instance.new("TextLabel"); -- Not used

				Paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Paragraph.BackgroundTransparency = 0.9350000023841858
				Paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Paragraph.BorderSizePixel = 0
				Paragraph.LayoutOrder = CountItem
				Paragraph.Size = UDim2.new(1, 0, 0, 46)
				Paragraph.Name = "Paragraph"
				Paragraph.Parent = Section._SectionAdd -- Use Section's SectionAdd

				UICorner14.CornerRadius = UDim.new(0, 4)
				UICorner14.Parent = Paragraph

				ParagraphTitle.Font = Enum.Font.GothamBold
				ParagraphTitle.Text = ParagraphConfig.Title .. " | " .. ParagraphConfig.Content
				ParagraphTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
				ParagraphTitle.TextSize = 13
				ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
				ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
				ParagraphTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ParagraphTitle.BackgroundTransparency = 0.9990000128746033
				ParagraphTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ParagraphTitle.BorderSizePixel = 0
				ParagraphTitle.Position = UDim2.new(0, 10, 0, 10)
				ParagraphTitle.Size = UDim2.new(1, -16, 0, 13)
				ParagraphTitle.Name = "ParagraphTitle"
				ParagraphTitle.Parent = Paragraph
				ParagraphTitle.TextWrapped = true -- Enable wrapping
				
				task.delay(0, function() -- Delay to allow initial rendering for TextBounds
					ParagraphTitle.Size = UDim2.new(1, -16, 0, ParagraphTitle.TextBounds.Y)
					Paragraph.Size = UDim2.new(1, 0, 0, ParagraphTitle.TextBounds.Y + 20) -- Adjusted padding
					Section._UpdateSizeSection()
				end)


				function ParagraphFunc:Set(ParagraphConfig)
					local ParagraphConfig = ParagraphConfig or {}
					ParagraphConfig.Title = ParagraphConfig.Title or "Title"
					ParagraphConfig.Content = ParagraphConfig.Content or "Content"
					ParagraphTitle.Text = ParagraphConfig.Title .. " | " .. ParagraphConfig.Content
					task.delay(0, function()
						ParagraphTitle.Size = UDim2.new(1, -16, 0, ParagraphTitle.TextBounds.Y)
						Paragraph.Size = UDim2.new(1, 0, 0, ParagraphTitle.TextBounds.Y + 20)
						Section._UpdateSizeSection()
					end)
				end
				CountItem = CountItem + 1
				return ParagraphFunc
			end

			function Section:AddButton(ButtonConfig)
				local ButtonConfig = ButtonConfig or {}
				ButtonConfig.Title = ButtonConfig.Title or "Title"
				ButtonConfig.Content = ButtonConfig.Content or "Content"
				ButtonConfig.Icon = ButtonConfig.Icon or LoadUIAsset("rbxassetid://16932740082", "ButtonConfig.png")
				ButtonConfig.Callback = ButtonConfig.Callback or function() end
				local ButtonFunc = {}

				local ButtonFrame = Instance.new("Frame"); -- Renamed
				local UICorner9 = Instance.new("UICorner");
				local ButtonTitle = Instance.new("TextLabel");
				local ButtonContent = Instance.new("TextLabel");
				local ButtonButton = Instance.new("TextButton");
				local FeatureFrame1_Button = Instance.new("Frame"); -- Renamed
				local FeatureImg3_Button = Instance.new("ImageLabel"); -- Renamed

				ButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonFrame.BackgroundTransparency = 0.9350000023841858
				ButtonFrame.BorderColor3 = GetColor("Secondary",ButtonFrame,"BorderColor3")
				ButtonFrame.BorderSizePixel = 0
				ButtonFrame.LayoutOrder = CountItem
				ButtonFrame.Size = UDim2.new(1, 0, 0, 46)
				ButtonFrame.Name = "Button"
				ButtonFrame.Parent = Section._SectionAdd

				UICorner9.CornerRadius = UDim.new(0, 4)
				UICorner9.Parent = ButtonFrame

				ButtonTitle.Font = Enum.Font.GothamBold
				ButtonTitle.Text = ButtonConfig.Title
				ButtonTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
				ButtonTitle.TextSize = 13
				ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
				ButtonTitle.TextYAlignment = Enum.TextYAlignment.Top
				ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonTitle.BackgroundTransparency = 0.9990000128746033
				ButtonTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonTitle.BorderSizePixel = 0
				ButtonTitle.Position = UDim2.new(0, 10, 0, 10)
				ButtonTitle.Size = UDim2.new(1, -100, 0, 13)
				ButtonTitle.Name = "ButtonTitle"
				ButtonTitle.Parent = ButtonFrame

				ButtonContent.Font = Enum.Font.GothamBold
				ButtonContent.Text = ButtonConfig.Content
				ButtonContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				ButtonContent.TextSize = 12
				ButtonContent.TextTransparency = 0.6000000238418579
				ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
				ButtonContent.TextYAlignment = Enum.TextYAlignment.Bottom
				ButtonContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonContent.BackgroundTransparency = 0.9990000128746033
				ButtonContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonContent.BorderSizePixel = 0
				ButtonContent.Position = UDim2.new(0, 10, 0, 23)
				ButtonContent.Name = "ButtonContent"
				ButtonContent.Parent = ButtonFrame
				ButtonContent.TextWrapped = true
				
				task.delay(0, function()
					ButtonContent.Size = UDim2.new(1, -100, 0, ButtonContent.TextBounds.Y)
					ButtonFrame.Size = UDim2.new(1, 0, 0, ButtonContent.TextBounds.Y + ButtonTitle.AbsoluteSize.Y + 20) -- Adjusted padding
					Section._UpdateSizeSection()
				end)

				ButtonButton.Font = Enum.Font.SourceSans
				ButtonButton.Text = ""
				ButtonButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ButtonButton.TextSize = 14
				ButtonButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				ButtonButton.BackgroundTransparency = 0.9990000128746033
				ButtonButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonButton.BorderSizePixel = 0
				ButtonButton.Size = UDim2.new(1, 0, 1, 0)
				ButtonButton.Name = "ButtonButton"
				ButtonButton.Parent = ButtonFrame

				FeatureFrame1_Button.AnchorPoint = Vector2.new(1, 0.5)
				FeatureFrame1_Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				FeatureFrame1_Button.BackgroundTransparency = 0.9990000128746033
				FeatureFrame1_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
				FeatureFrame1_Button.BorderSizePixel = 0
				FeatureFrame1_Button.Position = UDim2.new(1, -15, 0.5, 0)
				FeatureFrame1_Button.Size = UDim2.new(0, 25, 0, 25)
				FeatureFrame1_Button.Name = "FeatureFrame"
				FeatureFrame1_Button.Parent = ButtonFrame

				FeatureImg3_Button.Image = ButtonConfig.Icon
				FeatureImg3_Button.AnchorPoint = Vector2.new(0.5, 0.5)
				FeatureImg3_Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				FeatureImg3_Button.BackgroundTransparency = 0.9990000128746033
				FeatureImg3_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
				FeatureImg3_Button.BorderSizePixel = 0
				FeatureImg3_Button.Position = UDim2.new(0.5, 0, 0.5, 0)
				FeatureImg3_Button.Size = UDim2.new(1, 0, 1, 0)
				FeatureImg3_Button.Name = "FeatureImg"
				FeatureImg3_Button.Parent = FeatureFrame1_Button

				ButtonButton.Activated:Connect(function()
					CircleClick(ButtonButton, Mouse.X, Mouse.Y)
					ButtonConfig.Callback()
				end)
				CountItem = CountItem + 1
				return ButtonFunc
			end

			function Section:AddToggle(ToggleConfig)
				local ToggleConfig = ToggleConfig or {}
				ToggleConfig.Title = ToggleConfig.Title or "no Title"
				ToggleConfig.Content = ToggleConfig.Content or ""
				ToggleConfig.Default = (ToggleConfig.Flag and Flags[ToggleConfig.Flag] ~= nil) and Flags[ToggleConfig.Flag] or ToggleConfig.Default or false                    
				ToggleConfig._originalCallback = ToggleConfig.Callback
				ToggleConfig.Callback = function(Value)
					if ToggleConfig.Async then
						task.spawn(ToggleConfig._originalCallback, Value)
					else
						ToggleConfig._originalCallback(Value)
					end
				end
				local ToggleFunc = {Value = ToggleConfig.Default, Options = ToggleConfig.Options, Selecting = ToggleConfig.Selecting}

				local ToggleFrame = Instance.new("Frame"); -- Renamed
				local UICorner20 = Instance.new("UICorner");
				local ToggleTitle = Instance.new("TextLabel");
				local ToggleContent = Instance.new("TextLabel");
				local ToggleButton = Instance.new("TextButton");
				-- local Frame = Instance.new("Frame"); -- Not used
				-- local ImageLabel3 = Instance.new("ImageLabel"); -- Not used
				-- local UICorner21 = Instance.new("UICorner"); -- Not used
				-- local TextButton = Instance.new("TextButton"); -- Not used
				local FeatureFrame2_Toggle = Instance.new("Frame"); -- Renamed
				local UICorner22 = Instance.new("UICorner");
				local UIStroke8 = Instance.new("UIStroke");
				local ToggleCircle = Instance.new("Frame");
				local UICorner23 = Instance.new("UICorner");

				ToggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleFrame.BackgroundTransparency = 0.9350000023841858
				ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleFrame.BorderSizePixel = 0
				ToggleFrame.LayoutOrder = CountItem
				ToggleFrame.Size = UDim2.new(1, 0, 0, 46)
				ToggleFrame.Name = "Toggle"
				ToggleFrame.Parent = Section._SectionAdd

				UICorner20.CornerRadius = UDim.new(0, 4)
				UICorner20.Parent = ToggleFrame

				ToggleTitle.Font = Enum.Font.GothamBold
				ToggleTitle.Text = ToggleConfig.Title
				ToggleTitle.TextSize = 13
				ToggleTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
				ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleTitle.BackgroundTransparency = 0.9990000128746033
				ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleTitle.BorderSizePixel = 0
				ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
				ToggleTitle.Size = UDim2.new(1, -100, 0, 13)
				ToggleTitle.Name = "ToggleTitle"
				ToggleTitle.Parent = ToggleFrame

				ToggleContent.Font = Enum.Font.GothamBold
				ToggleContent.Text = ToggleConfig.Content
				ToggleContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				ToggleContent.TextSize = 12
				ToggleContent.TextTransparency = 0.6000000238418579
				ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
				ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom
				ToggleContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleContent.BackgroundTransparency = 0.9990000128746033
				ToggleContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleContent.BorderSizePixel = 0
				ToggleContent.Position = UDim2.new(0, 10, 0, 23)
				ToggleContent.Name = "ToggleContent"
				ToggleContent.Parent = ToggleFrame
				ToggleContent.TextWrapped = true
				
				task.delay(0, function()
					ToggleContent.Size = UDim2.new(1, -100, 0, ToggleContent.TextBounds.Y)
					ToggleFrame.Size = UDim2.new(1, 0, 0, ToggleContent.TextBounds.Y + ToggleTitle.AbsoluteSize.Y + 20)
					Section._UpdateSizeSection()
				end)
				

				ToggleButton.Font = Enum.Font.SourceSans
				ToggleButton.Text = ""
				ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.TextSize = 14
				ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.BackgroundTransparency = 0.9990000128746033
				ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.BorderSizePixel = 0
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Name = "ToggleButton"
				ToggleButton.Parent = ToggleFrame

				FeatureFrame2_Toggle.AnchorPoint = Vector2.new(1, 0.5)
				FeatureFrame2_Toggle.BackgroundColor3 = GetColor("Secondary",FeatureFrame2_Toggle,"BackgroundColor3")
				FeatureFrame2_Toggle.BackgroundTransparency = 0.9200000166893005
				FeatureFrame2_Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				FeatureFrame2_Toggle.BorderSizePixel = 0
				FeatureFrame2_Toggle.Position = UDim2.new(1, -30, 0.5, 0)
				FeatureFrame2_Toggle.Size = UDim2.new(0, 30, 0, 15)
				FeatureFrame2_Toggle.Name = "FeatureFrame"
				FeatureFrame2_Toggle.Parent = ToggleFrame

				UICorner22.Parent = FeatureFrame2_Toggle

				UIStroke8.Color = Color3.fromRGB(255, 255, 255)
				UIStroke8.Thickness = 2
				UIStroke8.Transparency = 0.9
				UIStroke8.Parent = FeatureFrame2_Toggle

				ToggleCircle.BackgroundColor3 = Color3.fromRGB(230.00000149011612, 230.00000149011612, 230.00000149011612)
				ToggleCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleCircle.BorderSizePixel = 0
				ToggleCircle.Position = UDim2.new(0, 0, 0, 0)
				ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
				ToggleCircle.Name = "ToggleCircle"
				ToggleCircle.Parent = FeatureFrame2_Toggle

				UICorner23.CornerRadius = UDim.new(0, 15)
				UICorner23.Parent = ToggleCircle
				
				ToggleButton.Activated:Connect(function()
					CircleClick(ToggleButton, Mouse.X, Mouse.Y) 
					ToggleFunc.Value = not ToggleFunc.Value
					ToggleFunc:Set(ToggleFunc.Value)
					if ToggleConfig.Flag and typeof(ToggleConfig.Flag) == "string" then
                        SaveFile(ToggleConfig.Flag, ToggleFunc.Value)
                    end
				end)
				function ToggleFunc:Set(Value)
					ToggleConfig.Callback(Value)
					if Value then
						TweenService:Create(ToggleTitle,
							TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
							{TextColor3 = GetColor("Text",ToggleTitle,"TextColor3")} -- Fixed: ToggleTitle instead of TextColor3
						):Play()
						TweenService:Create(
							ToggleCircle,
							TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
							{Position = UDim2.new(0, 15, 0, 0)}
						):Play()
						TweenService:Create(
							UIStroke8,TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
							{Color = GetColor("Text",UIStroke8,"Color")}
						):Play()
						TweenService:Create(
							FeatureFrame2_Toggle, -- Fixed: Use renamed variable
							TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
							{BackgroundColor3 = GetColor("Text",FeatureFrame2_Toggle,"BackgroundColor3")}
						):Play()
					else
						TweenService:Create(
							ToggleTitle,
							TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
							{TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)}
						):Play()
						TweenService:Create(
							ToggleCircle,
							TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
							{Position = UDim2.new(0, 0, 0, 0)}
						):Play()
						TweenService:Create(
							UIStroke8,
							TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
							{Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9}
						):Play()
						TweenService:Create(
							FeatureFrame2_Toggle, -- Fixed: Use renamed variable
							TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
							{BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.9200000166893005}
						):Play()
					end
				end
				ToggleFunc:Set(ToggleFunc.Value)
				CountItem = CountItem + 1
				return ToggleFunc
			end

			function Section:AddSlider(SliderConfig)
				local SliderConfig = SliderConfig or {}
				SliderConfig.Title = SliderConfig.Title or "Slider"
				SliderConfig.Content = SliderConfig.Content or "Content"
				SliderConfig.Increment = SliderConfig.Increment or 1
				SliderConfig.Min = SliderConfig.Min or 0
				SliderConfig.Max = SliderConfig.Max or 100
				local savedValue = SliderConfig.Flag and Flags[SliderConfig.Flag] if savedValue ~= nil then savedValue = tonumber(savedValue) end
				SliderConfig.Default = tonumber(savedValue or SliderConfig.Default or 50)
				SliderConfig.Callback = SliderConfig.Callback or function() end
				local SliderFunc = {Value = SliderConfig.Default}
	
				local SliderFrameUI = Instance.new("Frame"); -- Renamed
				local UICorner15 = Instance.new("UICorner");
				local SliderTitle = Instance.new("TextLabel");
				local SliderContent = Instance.new("TextLabel");
				local SliderInput = Instance.new("Frame");
				local UICorner16 = Instance.new("UICorner");
				local TextBox_Slider = Instance.new("TextBox"); -- Renamed
				local SliderBarFrame = Instance.new("Frame"); -- Renamed
				local UICorner17 = Instance.new("UICorner");
				local SliderDraggable = Instance.new("Frame");
				local UICorner18 = Instance.new("UICorner");
				-- local UIStroke5 = Instance.new("UIStroke"); -- Not used
				local SliderCircle = Instance.new("Frame");
				local UICorner19 = Instance.new("UICorner");
				local UIStroke6_Slider = Instance.new("UIStroke"); -- Renamed
				-- local UIStroke7 = Instance.new("UIStroke"); -- Not used

				SliderFrameUI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderFrameUI.BackgroundTransparency = 0.9350000023841858
				SliderFrameUI.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderFrameUI.BorderSizePixel = 0
				SliderFrameUI.LayoutOrder = CountItem
				SliderFrameUI.Size = UDim2.new(1, 0, 0, 46)
				SliderFrameUI.Name = "Slider"
				SliderFrameUI.Parent = Section._SectionAdd

				UICorner15.CornerRadius = UDim.new(0, 4)
				UICorner15.Parent = SliderFrameUI

				SliderTitle.Font = Enum.Font.GothamBold
				SliderTitle.Text = SliderConfig.Title
				SliderTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
				SliderTitle.TextSize = 13
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
				SliderTitle.TextYAlignment = Enum.TextYAlignment.Top
				SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderTitle.BackgroundTransparency = 0.9990000128746033
				SliderTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderTitle.BorderSizePixel = 0
				SliderTitle.Position = UDim2.new(0, 10, 0, 10)
				SliderTitle.Size = UDim2.new(1, -180, 0, 13)
				SliderTitle.Name = "SliderTitle"
				SliderTitle.Parent = SliderFrameUI

				SliderContent.Font = Enum.Font.GothamBold
				SliderContent.Text = SliderConfig.Content
				SliderContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderContent.TextSize = 12
				SliderContent.TextTransparency = 0.6000000238418579
				SliderContent.TextXAlignment = Enum.TextXAlignment.Left
				SliderContent.TextYAlignment = Enum.TextYAlignment.Bottom
				SliderContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderContent.BackgroundTransparency = 0.9990000128746033
				SliderContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderContent.BorderSizePixel = 0
				SliderContent.Position = UDim2.new(0, 10, 0, 23)
				SliderContent.Name = "SliderContent"
				SliderContent.Parent = SliderFrameUI
				SliderContent.TextWrapped = true
				
				task.delay(0, function()
					SliderContent.Size = UDim2.new(1, -180, 0, SliderContent.TextBounds.Y)
					SliderFrameUI.Size = UDim2.new(1, 0, 0, SliderContent.TextBounds.Y + SliderTitle.AbsoluteSize.Y + 20)
					Section._UpdateSizeSection()
				end)

				SliderInput.AnchorPoint = Vector2.new(0, 0.5)
				SliderInput.BackgroundColor3 = GetColor("Accent",SliderInput,"BackgroundColor3")
				SliderInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderInput.BorderSizePixel = 0
				SliderInput.Position = UDim2.new(1, -155, 0.5, 0)
				SliderInput.Size = UDim2.new(0, 28, 0, 20)
				SliderInput.Name = "SliderInput"
				SliderInput.Parent = SliderFrameUI

				UICorner16.CornerRadius = UDim.new(0, 2)
				UICorner16.Parent = SliderInput

				TextBox_Slider.Font = Enum.Font.GothamBold
				TextBox_Slider.Text = tostring(SliderConfig.Default) -- Ensure string
				TextBox_Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextBox_Slider.TextSize = 13
				TextBox_Slider.TextWrapped = true
				TextBox_Slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				TextBox_Slider.BackgroundTransparency = 0.9990000128746033
				TextBox_Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextBox_Slider.BorderSizePixel = 0
				TextBox_Slider.Position = UDim2.new(0, -1, 0, 0)
				TextBox_Slider.Size = UDim2.new(1, 0, 1, 0)
				TextBox_Slider.Parent = SliderInput

				SliderBarFrame.AnchorPoint = Vector2.new(1, 0.5)
				SliderBarFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderBarFrame.BackgroundTransparency = 0.800000011920929
				SliderBarFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderBarFrame.BorderSizePixel = 0
				SliderBarFrame.Position = UDim2.new(1, -20, 0.5, 0)
				SliderBarFrame.Size = UDim2.new(0, 100, 0, 3)
				SliderBarFrame.Name = "SliderFrame"
				SliderBarFrame.Parent = SliderFrameUI

				UICorner17.Parent = SliderBarFrame

				SliderDraggable.AnchorPoint = Vector2.new(0, 0.5)
				SliderDraggable.BackgroundColor3 = GetColor("Accent",SliderDraggable,"BackgroundColor3")
				SliderDraggable.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderDraggable.BorderSizePixel = 0
				SliderDraggable.Position = UDim2.new(0, 0, 0.5, 0)
				SliderDraggable.Size = UDim2.new(0.899999976, 0, 0, 1) -- Should be UDim2.fromScale
				SliderDraggable.Name = "SliderDraggable"
				SliderDraggable.Parent = SliderBarFrame

				UICorner18.Parent = SliderDraggable

				SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
				SliderCircle.BackgroundColor3 = GetColor("ThemeHighlight",SliderCircle,"BackgroundColor3")
				SliderCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderCircle.BorderSizePixel = 0
				SliderCircle.Position = UDim2.new(1, 4, 0.5, 0)
				SliderCircle.Size = UDim2.new(0, 8, 0, 8)
				SliderCircle.Name = "SliderCircle"
				SliderCircle.Parent = SliderDraggable

				UICorner19.Parent = SliderCircle

				UIStroke6_Slider.Color = GetColor("Secondary",UIStroke6_Slider,"Color")
				UIStroke6_Slider.Parent = SliderCircle

				local Dragging_Slider = false -- Renamed
				-- local LastPos = nil -- Not used
				-- local ActiveTouch = nil -- Not used
				local function Round(Number, Factor)
					local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
					if Result < 0 then 
						Result = Result + Factor 
					end
					return Result
				end
				function SliderFunc:Set(Value)
					Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)
					if self.Value ~= Value then
						self.Value = Value
						local formatValue = Value
						if SliderConfig.Increment < 1 then
							local decimalPlaces = math.max(0, -math.floor(math.log10(SliderConfig.Increment)))
							formatValue = string.format("%."..decimalPlaces.."f", Value)
						end
						TextBox_Slider.Text = tostring(formatValue)
						local scale = (Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
						if UserInputService.TouchEnabled then
							SliderDraggable.Size = UDim2.fromScale(scale, 1)
							-- SliderBackground.Size = UDim2.new(1, 0, 1, 8) -- SliderBackground does not exist
						else
							TweenService:Create(SliderDraggable,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.fromScale(scale, 1)}):Play()
						end
						if SliderConfig.Flag then
							SaveFile(SliderConfig.Flag, self.Value)
						end
						SliderConfig.Callback(self.Value)
					end
				end
				
				SliderBarFrame.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
						Dragging_Slider = true
						local SizeScale = math.clamp((Input.Position.X - SliderBarFrame.AbsolutePosition.X) / SliderBarFrame.AbsoluteSize.X, 0, 1)
						SliderFunc:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
					end 
				end)
				SliderBarFrame.InputEnded:Connect(function(Input) 
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
						Dragging_Slider = false 
						if SliderConfig.Flag then
							SaveFile(SliderConfig.Flag, SliderFunc.Value)
						end
						SliderConfig.Callback(SliderFunc.Value)
					end 
				end)
				local tolerance_slider = 20 -- Renamed
				UserInputService.InputChanged:Connect(function(Input)
					if Dragging_Slider and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
						local relativeX = Input.Position.X - SliderBarFrame.AbsolutePosition.X
						if relativeX >= -tolerance_slider and relativeX <= SliderBarFrame.AbsoluteSize.X + tolerance_slider then
							local SizeScale = math.clamp(relativeX / SliderBarFrame.AbsoluteSize.X, 0, 1)
							-- if SliderConfig.Flag and typeof(SliderConfig.Flag) == "number" then -- This condition is problematic, typeof(string) is "string"
							-- 	SaveFile(SliderConfig.Flag, SliderConfig.Value) -- Should be SliderFunc.Value
							-- end
							SliderFunc:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
						end
					end
				end)
				TextBox_Slider:GetPropertyChangedSignal("Text"):Connect(function()
					local pattern = SliderConfig.Min < 0 and "[^-%d.]" or "[^%d.]"
					local Valid = TextBox_Slider.Text:gsub(pattern, "")
					local decimalCount = select(2, Valid:gsub("%.", ""))
					if decimalCount > 1 then
						Valid = Valid:reverse():gsub("%.", "", 1):reverse()
					end
					if Valid:match("^0%d") and not Valid:match("^0%.") then
						Valid = Valid:sub(2)
					end
					TextBox_Slider.Text = Valid
				end)
				TextBox_Slider.FocusLost:Connect(function()
					if TextBox_Slider.Text ~= "" then
						SliderFunc:Set(tonumber(TextBox_Slider.Text) or SliderConfig.Min)
					else
						SliderFunc:Set(SliderConfig.Min)
					end
				end)
				SliderFunc:Set(tonumber(SliderConfig.Default))
				-- SliderConfig.Callback(SliderFunc.Value) -- Called by Set
				CountItem = CountItem + 1
				return SliderFunc
			end

			function Section:AddInput(InputConfig)
				local InputConfig = InputConfig or {}
				InputConfig.Title = InputConfig.Title or "Title"
				InputConfig.Content = InputConfig.Content or "Content"
				InputConfig.Callback = InputConfig.Callback or function() end
				local InputFunc = {Value = InputConfig.Default, Options = InputConfig.Options, Selecting = InputConfig.Selecting} -- Default might be nil
				
				local InputFrameUI = Instance.new("Frame"); -- Renamed
				local UICorner12 = Instance.new("UICorner");
				local InputTitle = Instance.new("TextLabel");
				local InputContent = Instance.new("TextLabel");
				local InputTextBoxFrame = Instance.new("Frame"); -- Renamed
				local UICorner13 = Instance.new("UICorner");
				local InputTextBox = Instance.new("TextBox");

				InputFrameUI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputFrameUI.BackgroundTransparency = 0.9350000023841858
				InputFrameUI.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputFrameUI.BorderSizePixel = 0
				InputFrameUI.LayoutOrder = CountItem
				InputFrameUI.Size = UDim2.new(1, 0, 0, 46)
				InputFrameUI.Name = "Input"
				InputFrameUI.Parent = Section._SectionAdd

				UICorner12.CornerRadius = UDim.new(0, 4)
				UICorner12.Parent = InputFrameUI

				InputTitle.Font = Enum.Font.GothamBold
				InputTitle.Text = InputConfig.Title
				InputTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
				InputTitle.TextSize = 13
				InputTitle.TextXAlignment = Enum.TextXAlignment.Left
				InputTitle.TextYAlignment = Enum.TextYAlignment.Top
				InputTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputTitle.BackgroundTransparency = 0.9990000128746033
				InputTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputTitle.BorderSizePixel = 0
				InputTitle.Position = UDim2.new(0, 10, 0, 10)
				InputTitle.Size = UDim2.new(1, -180, 0, 13)
				InputTitle.Name = "InputTitle"
				InputTitle.Parent = InputFrameUI

				InputContent.Font = Enum.Font.GothamBold
				InputContent.Text = InputConfig.Content
				InputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				InputContent.TextSize = 12
				InputContent.TextTransparency = 0.6000000238418579
				InputContent.TextWrapped = true
				InputContent.TextXAlignment = Enum.TextXAlignment.Left
				InputContent.TextYAlignment = Enum.TextYAlignment.Bottom
				InputContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputContent.BackgroundTransparency = 0.9990000128746033
				InputContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputContent.BorderSizePixel = 0
				InputContent.Position = UDim2.new(0, 10, 0, 23)
				InputContent.Name = "InputContent"
				InputContent.Parent = InputFrameUI
				
				task.delay(0, function()
					InputContent.Size = UDim2.new(1, -180, 0, InputContent.TextBounds.Y)
					InputFrameUI.Size = UDim2.new(1, 0, 0, InputContent.TextBounds.Y + InputTitle.AbsoluteSize.Y + 20)
					Section._UpdateSizeSection()
				end)

				InputTextBoxFrame.AnchorPoint = Vector2.new(1, 0.5)
				InputTextBoxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputTextBoxFrame.BackgroundTransparency = 0.949999988079071
				InputTextBoxFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputTextBoxFrame.BorderSizePixel = 0
				InputTextBoxFrame.ClipsDescendants = true
				InputTextBoxFrame.Position = UDim2.new(1, -7, 0.5, 0)
				InputTextBoxFrame.Size = UDim2.new(0, 148, 0, 30)
				InputTextBoxFrame.Name = "InputFrame"
				InputTextBoxFrame.Parent = InputFrameUI

				UICorner13.CornerRadius = UDim.new(0, 4)
				UICorner13.Parent = InputTextBoxFrame

				InputTextBox.CursorPosition = -1
				InputTextBox.Font = Enum.Font.GothamBold
				InputTextBox.PlaceholderColor3 = Color3.fromRGB(120.00000044703484, 120.00000044703484, 120.00000044703484)
				InputTextBox.PlaceholderText = "Write your input there"
				InputTextBox.Text = tostring((InputConfig.Flag and Flags[InputConfig.Flag] ~= nil) and Flags[InputConfig.Flag] or InputConfig.Default or "")
				InputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				InputTextBox.TextSize = 12
				InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
				InputTextBox.AnchorPoint = Vector2.new(0, 0.5)
				InputTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputTextBox.BackgroundTransparency = 0.9990000128746033
				InputTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputTextBox.BorderSizePixel = 0
				InputTextBox.Position = UDim2.new(0, 5, 0.5, 0)
				InputTextBox.Size = UDim2.new(1, -10, 1, -8)
				InputTextBox.Name = "InputTextBox"
				InputTextBox.Parent = InputTextBoxFrame
				
				function InputFunc:Set(Value)
					InputTextBox.Text = Value
					InputFunc.Value = Value
					InputConfig.Callback(Value)
					if InputConfig.Flag and typeof(InputConfig.Flag) == "string" then
						SaveFile(InputConfig.Flag,InputFunc.Value)
					end
				end
				InputTextBox.FocusLost:Connect(function()
					InputFunc:Set(InputTextBox.Text)
				end)
				CountItem = CountItem + 1
				InputConfig.Callback(InputTextBox.Text) -- Initial callback with current text
				return InputFunc
			end

			function Section:AddDropdown(DropdownConfig)
				local DropdownConfig = DropdownConfig or {}
				DropdownConfig.Title = DropdownConfig.Title or "No Title"
				DropdownConfig.Content = DropdownConfig.Content or ""
				DropdownConfig.Multi = DropdownConfig.Multi or false
				DropdownConfig.Options = DropdownConfig.Options or {}
				-- local allOptions = {} -- Not used
				local savedValue = DropdownConfig.Flag and Flags[DropdownConfig.Flag]
				-- local isMulti = DropdownConfig.Multi -- Already available as DropdownConfig.Multi
				if DropdownConfig.Multi then
					DropdownConfig.Default = (savedValue and type(savedValue) == "table") and savedValue or (type(DropdownConfig.Default) == "table" and DropdownConfig.Default or {})
				else
					DropdownConfig.Default = savedValue or DropdownConfig.Default
				end
				DropdownConfig.Callback = DropdownConfig.Callback or function() end

				local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options}
	
				local DropdownFrame = Instance.new("Frame"); -- Renamed
				local DropdownButton = Instance.new("TextButton");
				local UICorner10 = Instance.new("UICorner");
				local DropdownTitle = Instance.new("TextLabel");
				local DropdownContent = Instance.new("TextLabel");
				local SelectOptionsFrame = Instance.new("Frame");
				local UICorner11 = Instance.new("UICorner");
				local ScrollSelect = Instance.new("ScrollingFrame");
				local SearchBar_Dropdown = Instance.new("TextBox") -- Renamed
				local OptionSelecting = Instance.new("TextLabel");
				local OptionImg = Instance.new("ImageLabel");

				DropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownFrame.BackgroundTransparency = 0.9350000023841858
				DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownFrame.BorderSizePixel = 0
				DropdownFrame.LayoutOrder = CountItem
				DropdownFrame.Size = UDim2.new(1, 0, 0, 46)
				DropdownFrame.Name = "Dropdown"
				DropdownFrame.Parent = Section._SectionAdd

				DropdownButton.Font = Enum.Font.SourceSans
				DropdownButton.Text = ""
				DropdownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.TextSize = 14
				DropdownButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.BackgroundTransparency = 0.9990000128746033
				DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.BorderSizePixel = 0
				DropdownButton.Size = UDim2.new(1, 0, 1, 0)
				DropdownButton.Name = "ToggleButton" -- This was ToggleButton, likely a copy-paste error, should be DropdownButton or similar
				DropdownButton.Parent = DropdownFrame

				UICorner10.CornerRadius = UDim.new(0, 4)
				UICorner10.Parent = DropdownFrame

				DropdownTitle.Font = Enum.Font.GothamBold
				DropdownTitle.Text = DropdownConfig.Title
				DropdownTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
				DropdownTitle.TextSize = 13
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
				DropdownTitle.TextYAlignment = Enum.TextYAlignment.Top
				DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownTitle.BackgroundTransparency = 0.9990000128746033
				DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownTitle.BorderSizePixel = 0
				DropdownTitle.Position = UDim2.new(0, 10, 0, 10)
				DropdownTitle.Size = UDim2.new(1, -180, 0, 13)
				DropdownTitle.Name = "DropdownTitle"
				DropdownTitle.Parent = DropdownFrame

				DropdownContent.Font = Enum.Font.GothamBold
				DropdownContent.Text = DropdownConfig.Content
				DropdownContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownContent.TextSize = 12
				DropdownContent.TextTransparency = 0.6000000238418579
				DropdownContent.TextWrapped = true
				DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
				DropdownContent.TextYAlignment = Enum.TextYAlignment.Bottom
				DropdownContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownContent.BackgroundTransparency = 0.9990000128746033
				DropdownContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownContent.BorderSizePixel = 0
				DropdownContent.Position = UDim2.new(0, 10, 0, 23)
				DropdownContent.Name = "DropdownContent"
				DropdownContent.Parent = DropdownFrame
				
				task.delay(0, function()
					DropdownContent.Size = UDim2.new(1, -180, 0, DropdownContent.TextBounds.Y)
					DropdownFrame.Size = UDim2.new(1, 0, 0, DropdownContent.TextBounds.Y + DropdownTitle.AbsoluteSize.Y + 20)
					Section._UpdateSizeSection()
				end)

				SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
				SelectOptionsFrame.BackgroundColor3 = GetColor("Primary",SelectOptionsFrame,"BackgroundColor3")
				SelectOptionsFrame.BackgroundTransparency = 0.949999988079071
				SelectOptionsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SelectOptionsFrame.BorderSizePixel = 0
				SelectOptionsFrame.Position = UDim2.new(1, -7, 0.5, 0)
				SelectOptionsFrame.Size = UDim2.new(0, 148, 0, 30)
				SelectOptionsFrame.Name = "SelectOptionsFrame"
				SelectOptionsFrame.LayoutOrder = CountDropdown -- This needs to be managed if it's global
				SelectOptionsFrame.Parent = DropdownFrame

				UICorner11.CornerRadius = UDim.new(0, 4)
				UICorner11.Parent = SelectOptionsFrame

				DropdownButton.Activated:Connect(function()
					if not MoreBlur.Visible then
						MoreBlur.Visible = true 
						DropPageLayout:JumpToIndex(SelectOptionsFrame.LayoutOrder)
						TweenService:Create(MoreBlur, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
						TweenService:Create(DropdownSelect, TweenInfo.new(0.2), {Position = UDim2.new(1, -11, 0.5, 0)}):Play()
					end
				end)

				OptionSelecting.Font = Enum.Font.GothamBold
				OptionSelecting.Text = ""
				OptionSelecting.TextColor3 = Color3.fromRGB(255, 255, 255)
				OptionSelecting.TextSize = 12
				OptionSelecting.TextTransparency = 0.6000000238418579
				OptionSelecting.TextWrapped = true
				OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
				OptionSelecting.AnchorPoint = Vector2.new(0, 0.5)
				OptionSelecting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				OptionSelecting.BackgroundTransparency = 0.9990000128746033
				OptionSelecting.BorderColor3 = Color3.fromRGB(0, 0, 0)
				OptionSelecting.BorderSizePixel = 0
				OptionSelecting.Position = UDim2.new(0, 5, 0.5, 0)
				OptionSelecting.Size = UDim2.new(1, -30, 1, -8)
				OptionSelecting.Name = "OptionSelecting"
				OptionSelecting.Parent = SelectOptionsFrame

				OptionImg.Image = LoadUIAsset("rbxassetid://16851841101", "OptionImg.png")
				OptionImg.ImageColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
				OptionImg.AnchorPoint = Vector2.new(1, 0.5)
				OptionImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				OptionImg.BackgroundTransparency = 0.9990000128746033
				OptionImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
				OptionImg.BorderSizePixel = 0
				OptionImg.Position = UDim2.new(1, 0, 0.5, 0)
				OptionImg.Size = UDim2.new(0, 25, 0, 25)
				OptionImg.Name = "OptionImg"
				OptionImg.Parent = SelectOptionsFrame

				local UIListLayout4_Dropdown = Instance.new("UIListLayout"); -- Renamed

				local DropdownContainer = Instance.new("Frame")
				DropdownContainer.BackgroundTransparency = 1
				DropdownContainer.Size = UDim2.new(1, 0, 1, 0)
				DropdownContainer.Name = "DropdownContainer"
				DropdownContainer.Parent = DropdownFolder -- DropdownFolder is defined much earlier in MakeGui

				SearchBar_Dropdown.Font = Enum.Font.GothamBold
				SearchBar_Dropdown.PlaceholderText = "🔎 Search Dropdown"
				SearchBar_Dropdown.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
				SearchBar_Dropdown.Text = ""
				SearchBar_Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
				SearchBar_Dropdown.TextSize = 12
				SearchBar_Dropdown.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				SearchBar_Dropdown.BackgroundTransparency = 0.9
				SearchBar_Dropdown.BorderColor3 = Color3.fromRGB(255, 255, 255)
				SearchBar_Dropdown.BorderSizePixel = 1
				SearchBar_Dropdown.Size = UDim2.new(1, -10, 0, 25)
				SearchBar_Dropdown.Parent = DropdownContainer
				SearchBar_Dropdown.Position = UDim2.new(0, 5, 0, 5) 

				ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, 0)
				ScrollSelect.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
				ScrollSelect.ScrollBarThickness = 0
				ScrollSelect.Active = true
				ScrollSelect.Position = UDim2.new(0, 0, 0, 30)
				ScrollSelect.LayoutOrder = CountDropdown -- This needs to be managed
				ScrollSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ScrollSelect.BackgroundTransparency = 0.9990000128746033
				ScrollSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ScrollSelect.BorderSizePixel = 0
				ScrollSelect.Size = UDim2.new(1, 0, 1, -30)
				ScrollSelect.Name = "ScrollSelect"
				ScrollSelect.Parent = DropdownContainer

				SearchBar_Dropdown:GetPropertyChangedSignal("Text"):Connect(function()
					local searchText = SearchBar_Dropdown.Text:lower()
					for _, optionFrame in ipairs(ScrollSelect:GetChildren()) do
						if optionFrame:IsA("Frame") and optionFrame.Name == "Option" then
							local optionText = optionFrame:FindFirstChild("OptionText")
							if optionText then
								local optionName = optionText.Text:lower()
								local isMatch = searchText == "" or string.find(optionName, searchText, 1, true) ~= nil
								optionFrame.Visible = isMatch
							end
						end
					end
				end)		
				UIListLayout4_Dropdown.Padding = UDim.new(0, 3)
				UIListLayout4_Dropdown.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout4_Dropdown.Parent = ScrollSelect

				local DropCount = 0
				function DropdownFunc:Clear()
					for _, DropFrameInScroll in ScrollSelect:GetChildren() do -- Renamed iterator
						if DropFrameInScroll.Name == "Option" then
							DropdownFunc.Value = {}
							DropdownFunc.Options = {}
							OptionSelecting.Text = "Select Options"
							DropFrameInScroll:Destroy()
						end
					end
				end
				function DropdownFunc:AddOption(OptionName)
					OptionName = OptionName or "Option"
					local OptionFrame = Instance.new("Frame"); -- Renamed
					local UICorner37_Opt = Instance.new("UICorner"); -- Renamed
					local OptionButton = Instance.new("TextButton");
					local OptionText = Instance.new("TextLabel")
					local ChooseFrame_Opt = Instance.new("Frame"); -- Renamed
					local UIStroke15_Opt = Instance.new("UIStroke"); -- Renamed
					local UICorner38_Opt = Instance.new("UICorner"); -- Renamed
					
					OptionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionFrame.BackgroundTransparency = 0.999
					OptionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionFrame.BorderSizePixel = 0
					OptionFrame.LayoutOrder = DropCount
					OptionFrame.Size = UDim2.new(1, 0, 0, 30)
					OptionFrame.Name = "Option"
					OptionFrame.Parent = ScrollSelect
				
					UICorner37_Opt.CornerRadius = UDim.new(0, 3)
					UICorner37_Opt.Parent = OptionFrame
				
					OptionButton.Font = Enum.Font.GothamBold
					OptionButton.Text = ""
					OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					OptionButton.TextSize = 13
					OptionButton.TextXAlignment = Enum.TextXAlignment.Left
					OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionButton.BackgroundTransparency = 0.9990000128746033
					OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionButton.BorderSizePixel = 0
					OptionButton.Size = UDim2.new(1, 0, 1, 0)
					OptionButton.Name = "OptionButton"
					OptionButton.Parent = OptionFrame

					OptionText.Font = Enum.Font.GothamBold
					OptionText.Text = OptionName
					OptionText.TextSize = 13
					OptionText.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
					OptionText.TextXAlignment = Enum.TextXAlignment.Left
					OptionText.TextYAlignment = Enum.TextYAlignment.Top
					OptionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionText.BackgroundTransparency = 0.9990000128746033
					OptionText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionText.BorderSizePixel = 0
					OptionText.Position = UDim2.new(0, 8, 0, 8)
					OptionText.Size = UDim2.new(1, -100, 0, 13)
					OptionText.Name = "OptionText"
					OptionText.Parent = OptionFrame
	
					ChooseFrame_Opt.AnchorPoint = Vector2.new(0, 0.5)
					ChooseFrame_Opt.BackgroundColor3 = GetColor("ThemeHighlight",ChooseFrame_Opt,"BackgroundColor3")
					ChooseFrame_Opt.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ChooseFrame_Opt.BorderSizePixel = 0
					ChooseFrame_Opt.Position = UDim2.new(0, 2, 0.5, 0)
					ChooseFrame_Opt.Size = UDim2.new(0, 0, 0, 0)
					ChooseFrame_Opt.Name = "ChooseFrame"
					ChooseFrame_Opt.Parent = OptionFrame
				
					UIStroke15_Opt.Color = GetColor("Secondary",UIStroke15_Opt,"Color")
					UIStroke15_Opt.Thickness = 1.600000023841858
					UIStroke15_Opt.Transparency = 0.999
					UIStroke15_Opt.Parent = ChooseFrame_Opt
				
					UICorner38_Opt.Parent = ChooseFrame_Opt
					OptionButton.Activated:Connect(function()
						CircleClick(OptionButton, Mouse.X, Mouse.Y) 
						if DropdownConfig.Multi then
							if OptionFrame.BackgroundTransparency > 0.95 then
								table.insert(DropdownFunc.Value, OptionName)
								DropdownFunc:Set(DropdownFunc.Value)
							else
								for i, valueInLoop in pairs(DropdownFunc.Value) do -- Renamed iterator
									if valueInLoop == OptionName then
										table.remove(DropdownFunc.Value, i)
										break
									end
								end
								DropdownFunc:Set(DropdownFunc.Value)
							end
						else
							DropdownFunc.Value = {OptionName}
							DropdownFunc:Set(DropdownFunc.Value)
						end
						if DropdownConfig.Flag and typeof(DropdownConfig.Flag) == "string" then
							local valueToSave
							if DropdownConfig.Multi then
								valueToSave = {}
								if typeof(DropdownFunc.Value) == "table" then
									for _, v_save in pairs(DropdownFunc.Value) do -- Renamed iterator
										if v_save ~= nil then
											table.insert(valueToSave, tostring(v_save))
										end
									end
								end
							else
								valueToSave = {}
								if typeof(DropdownFunc.Value) == "table" and #DropdownFunc.Value > 0 then
									table.insert(valueToSave, tostring(DropdownFunc.Value[1]))
								end
							end
							Flags[DropdownConfig.Flag] = valueToSave
							local success, err = pcall(function()
								local jsonData = HttpService:JSONEncode(Flags)
								writefile(GuiConfig.SaveFolder, jsonData)
								-- if isfile(GuiConfig.SaveFolder) then -- Debugging line, remove
								-- 	local content = readfile(GuiConfig.SaveFolder)
								-- end
							end)
							if not success then
								warn("[Save Failed]", err)
							end
						end
					end)
					local OffsetY = 0
					for _, child_scroll in ScrollSelect:GetChildren() do -- Renamed
						if child_scroll.Name ~= "UIListLayout" and child_scroll:IsA("Frame") then
							OffsetY = OffsetY + UIListLayout4_Dropdown.Padding.Offset + child_scroll.Size.Y.Offset
						end
					end
					ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
					DropCount = DropCount + 1
				end
				function DropdownFunc:Set(Value)
					if Value then
						local newValue = type(Value) == "table" and Value or {Value}
						local uniqueValues = {}
						for _, v_unique in ipairs(newValue) do -- Renamed
							if not table.find(uniqueValues, v_unique) then
								table.insert(uniqueValues, v_unique)
							end
						end
						DropdownFunc.Value = uniqueValues
					end
					for _, Drop_Set in pairs(ScrollSelect:GetChildren()) do -- Renamed
						if Drop_Set:IsA("Frame") and Drop_Set.Name == "Option" then
							local isTextFound = DropdownFunc.Value and table.find(DropdownFunc.Value, Drop_Set.OptionText.Text)
							local tweenInfoInOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
							local Size_Set = isTextFound and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0) -- Renamed
							local BackgroundTransparency_Set = isTextFound and 0.935 or 0.999 -- Renamed
							local Transparency_Set = isTextFound and 0 or 0.999 -- Renamed
							
							TweenService:Create(Drop_Set.ChooseFrame, tweenInfoInOut, {Size = Size_Set}):Play()
							TweenService:Create(Drop_Set.ChooseFrame.UIStroke, tweenInfoInOut, {Transparency = Transparency_Set}):Play()
							TweenService:Create(Drop_Set, tweenInfoInOut, {BackgroundTransparency = BackgroundTransparency_Set}):Play()
						end
					end
					local displayText = (DropdownFunc.Value and #DropdownFunc.Value > 0) and table.concat(DropdownFunc.Value, ", ") or "Select Options"
					OptionSelecting.Text = displayText
					if DropdownConfig.Callback then
						DropdownConfig.Callback(DropdownFunc.Value or {})
					end
				end
				function DropdownFunc:Refresh(RefreshList, Selecting)
					local currentValue = savedValue or DropdownConfig.Default
					RefreshList = RefreshList or {}
					Selecting = Selecting or currentValue
					for i = #ScrollSelect:GetChildren(), 1, -1 do
						local child_refresh = ScrollSelect:GetChildren()[i] -- Renamed
						if child_refresh.Name == "Option" then
							child_refresh:Destroy()
						end
					end
					DropdownFunc.Options = RefreshList
					for _, option_refresh in pairs(RefreshList) do -- Renamed
						DropdownFunc:AddOption(option_refresh)
					end
					DropdownFunc.Value = nil
					DropdownFunc:Set(Selecting)
				end
				DropdownFunc:Refresh(DropdownFunc.Options, DropdownFunc.Value)
				-- if DropdownConfig.Callback then  -- Called within Set and Refresh
				-- 	DropdownConfig.Callback(DropdownFunc.Value or {})
				-- end
				CountItem = CountItem + 1
				CountDropdown = CountDropdown + 1 -- This global counter might need to be per-UIInstance
				return DropdownFunc
			end

			function Section:AddDropdown(DropdownConfig)
				local DropdownConfig = DropdownConfig or {}
				DropdownConfig.Title = DropdownConfig.Title or "No Title"
				DropdownConfig.Content = DropdownConfig.Content or ""
				DropdownConfig.Multi = DropdownConfig.Multi or false
				DropdownConfig.Options = DropdownConfig.Options or {}
				-- local allOptions = {} -- Not used
				local savedValue = DropdownConfig.Flag and Flags[DropdownConfig.Flag]
				-- local isMulti = DropdownConfig.Multi -- Already available as DropdownConfig.Multi
				if DropdownConfig.Multi then
					DropdownConfig.Default = (savedValue and type(savedValue) == "table") and savedValue or (type(DropdownConfig.Default) == "table" and DropdownConfig.Default or {})
				else
					DropdownConfig.Default = savedValue or DropdownConfig.Default
				end
				DropdownConfig.Callback = DropdownConfig.Callback or function() end

				local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options}
	
				local DropdownFrame = Instance.new("Frame"); -- Renamed
				local DropdownButton = Instance.new("TextButton");
				local UICorner10 = Instance.new("UICorner");
				local DropdownTitle = Instance.new("TextLabel");
				local DropdownContent = Instance.new("TextLabel");
				local SelectOptionsFrame = Instance.new("Frame");
				local UICorner11 = Instance.new("UICorner");
				local ScrollSelect = Instance.new("ScrollingFrame");
				local SearchBar_Dropdown = Instance.new("TextBox") -- Renamed
				local OptionSelecting = Instance.new("TextLabel");
				local OptionImg = Instance.new("ImageLabel");

				DropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownFrame.BackgroundTransparency = 0.9350000023841858
				DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownFrame.BorderSizePixel = 0
				DropdownFrame.LayoutOrder = CountItem
				DropdownFrame.Size = UDim2.new(1, 0, 0, 46)
				DropdownFrame.Name = "Dropdown"
				DropdownFrame.Parent = Section._SectionAdd

				DropdownButton.Font = Enum.Font.SourceSans
				DropdownButton.Text = ""
				DropdownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.TextSize = 14
				DropdownButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.BackgroundTransparency = 0.9990000128746033
				DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.BorderSizePixel = 0
				DropdownButton.Size = UDim2.new(1, 0, 1, 0)
				DropdownButton.Name = "ToggleButton" -- This was ToggleButton, likely a copy-paste error, should be DropdownButton or similar
				DropdownButton.Parent = DropdownFrame

				UICorner10.CornerRadius = UDim.new(0, 4)
				UICorner10.Parent = DropdownFrame

				DropdownTitle.Font = Enum.Font.GothamBold
				DropdownTitle.Text = DropdownConfig.Title
				DropdownTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
				DropdownTitle.TextSize = 13
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
				DropdownTitle.TextYAlignment = Enum.TextYAlignment.Top
				DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownTitle.BackgroundTransparency = 0.9990000128746033
				DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownTitle.BorderSizePixel = 0
				DropdownTitle.Position = UDim2.new(0, 10, 0, 10)
				DropdownTitle.Size = UDim2.new(1, -180, 0, 13)
				DropdownTitle.Name = "DropdownTitle"
				DropdownTitle.Parent = DropdownFrame

				DropdownContent.Font = Enum.Font.GothamBold
				DropdownContent.Text = DropdownConfig.Content
				DropdownContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownContent.TextSize = 12
				DropdownContent.TextTransparency = 0.6000000238418579
				DropdownContent.TextWrapped = true
				DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
				DropdownContent.TextYAlignment = Enum.TextYAlignment.Bottom
				DropdownContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownContent.BackgroundTransparency = 0.9990000128746033
				DropdownContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownContent.BorderSizePixel = 0
				DropdownContent.Position = UDim2.new(0, 10, 0, 23)
				DropdownContent.Name = "DropdownContent"
				DropdownContent.Parent = DropdownFrame
				
				task.delay(0, function()
					DropdownContent.Size = UDim2.new(1, -180, 0, DropdownContent.TextBounds.Y)
					DropdownFrame.Size = UDim2.new(1, 0, 0, DropdownContent.TextBounds.Y + DropdownTitle.AbsoluteSize.Y + 20)
					Section._UpdateSizeSection()
				end)

				SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
				SelectOptionsFrame.BackgroundColor3 = GetColor("Primary",SelectOptionsFrame,"BackgroundColor3")
				SelectOptionsFrame.BackgroundTransparency = 0.949999988079071
				SelectOptionsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SelectOptionsFrame.BorderSizePixel = 0
				SelectOptionsFrame.Position = UDim2.new(1, -7, 0.5, 0)
				SelectOptionsFrame.Size = UDim2.new(0, 148, 0, 30)
				SelectOptionsFrame.Name = "SelectOptionsFrame"
				SelectOptionsFrame.LayoutOrder = CountDropdown -- This needs to be managed if it's global
				SelectOptionsFrame.Parent = DropdownFrame

				UICorner11.CornerRadius = UDim.new(0, 4)
				UICorner11.Parent = SelectOptionsFrame

				DropdownButton.Activated:Connect(function()
					if not MoreBlur.Visible then
						MoreBlur.Visible = true 
						DropPageLayout:JumpToIndex(SelectOptionsFrame.LayoutOrder)
						TweenService:Create(MoreBlur, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
						TweenService:Create(DropdownSelect, TweenInfo.new(0.2), {Position = UDim2.new(1, -11, 0.5, 0)}):Play()
					end
				end)

				OptionSelecting.Font = Enum.Font.GothamBold
				OptionSelecting.Text = ""
				OptionSelecting.TextColor3 = Color3.fromRGB(255, 255, 255)
				OptionSelecting.TextSize = 12
				OptionSelecting.TextTransparency = 0.6000000238418579
				OptionSelecting.TextWrapped = true
				OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
				OptionSelecting.AnchorPoint = Vector2.new(0, 0.5)
				OptionSelecting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				OptionSelecting.BackgroundTransparency = 0.9990000128746033
				OptionSelecting.BorderColor3 = Color3.fromRGB(0, 0, 0)
				OptionSelecting.BorderSizePixel = 0
				OptionSelecting.Position = UDim2.new(0, 5, 0.5, 0)
				OptionSelecting.Size = UDim2.new(1, -30, 1, -8)
				OptionSelecting.Name = "OptionSelecting"
				OptionSelecting.Parent = SelectOptionsFrame

				OptionImg.Image = LoadUIAsset("rbxassetid://16851841101", "OptionImg.png")
				OptionImg.ImageColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
				OptionImg.AnchorPoint = Vector2.new(1, 0.5)
				OptionImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				OptionImg.BackgroundTransparency = 0.9990000128746033
				OptionImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
				OptionImg.BorderSizePixel = 0
				OptionImg.Position = UDim2.new(1, 0, 0.5, 0)
				OptionImg.Size = UDim2.new(0, 25, 0, 25)
				OptionImg.Name = "OptionImg"
				OptionImg.Parent = SelectOptionsFrame

				local UIListLayout4_Dropdown = Instance.new("UIListLayout"); -- Renamed

				local DropdownContainer = Instance.new("Frame")
				DropdownContainer.BackgroundTransparency = 1
				DropdownContainer.Size = UDim2.new(1, 0, 1, 0)
				DropdownContainer.Name = "DropdownContainer"
				DropdownContainer.Parent = DropdownFolder -- DropdownFolder is defined much earlier in MakeGui

				SearchBar_Dropdown.Font = Enum.Font.GothamBold
				SearchBar_Dropdown.PlaceholderText = "🔎 Search Dropdown"
				SearchBar_Dropdown.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
				SearchBar_Dropdown.Text = ""
				SearchBar_Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
				SearchBar_Dropdown.TextSize = 12
				SearchBar_Dropdown.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				SearchBar_Dropdown.BackgroundTransparency = 0.9
				SearchBar_Dropdown.BorderColor3 = Color3.fromRGB(255, 255, 255)
				SearchBar_Dropdown.BorderSizePixel = 1
				SearchBar_Dropdown.Size = UDim2.new(1, -10, 0, 25)
				SearchBar_Dropdown.Parent = DropdownContainer
				SearchBar_Dropdown.Position = UDim2.new(0, 5, 0, 5) 

				ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, 0)
				ScrollSelect.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
				ScrollSelect.ScrollBarThickness = 0
				ScrollSelect.Active = true
				ScrollSelect.Position = UDim2.new(0, 0, 0, 30)
				ScrollSelect.LayoutOrder = CountDropdown -- This needs to be managed
				ScrollSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ScrollSelect.BackgroundTransparency = 0.9990000128746033
				ScrollSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ScrollSelect.BorderSizePixel = 0
				ScrollSelect.Size = UDim2.new(1, 0, 1, -30)
				ScrollSelect.Name = "ScrollSelect"
				ScrollSelect.Parent = DropdownContainer

				SearchBar_Dropdown:GetPropertyChangedSignal("Text"):Connect(function()
					local searchText = SearchBar_Dropdown.Text:lower()
					for _, optionFrame in ipairs(ScrollSelect:GetChildren()) do
						if optionFrame:IsA("Frame") and optionFrame.Name == "Option" then
							local optionText = optionFrame:FindFirstChild("OptionText")
							if optionText then
								local optionName = optionText.Text:lower()
								local isMatch = searchText == "" or string.find(optionName, searchText, 1, true) ~= nil
								optionFrame.Visible = isMatch
							end
						end
					end
				end)		
				UIListLayout4_Dropdown.Padding = UDim.new(0, 3)
				UIListLayout4_Dropdown.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout4_Dropdown.Parent = ScrollSelect

				local DropCount = 0
				function DropdownFunc:Clear()
					for _, DropFrameInScroll in ScrollSelect:GetChildren() do -- Renamed iterator
						if DropFrameInScroll.Name == "Option" then
							DropdownFunc.Value = {}
							DropdownFunc.Options = {}
							OptionSelecting.Text = "Select Options"
							DropFrameInScroll:Destroy()
						end
					end
				end
				function DropdownFunc:AddOption(OptionName)
					OptionName = OptionName or "Option"
					local OptionFrame = Instance.new("Frame"); -- Renamed
					local UICorner37_Opt = Instance.new("UICorner"); -- Renamed
					local OptionButton = Instance.new("TextButton");
					local OptionText = Instance.new("TextLabel")
					local ChooseFrame_Opt = Instance.new("Frame"); -- Renamed
					local UIStroke15_Opt = Instance.new("UIStroke"); -- Renamed
					local UICorner38_Opt = Instance.new("UICorner"); -- Renamed
					
					OptionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionFrame.BackgroundTransparency = 0.999
					OptionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionFrame.BorderSizePixel = 0
					OptionFrame.LayoutOrder = DropCount
					OptionFrame.Size = UDim2.new(1, 0, 0, 30)
					OptionFrame.Name = "Option"
					OptionFrame.Parent = ScrollSelect
				
					UICorner37_Opt.CornerRadius = UDim.new(0, 3)
					UICorner37_Opt.Parent = OptionFrame
				
					OptionButton.Font = Enum.Font.GothamBold
					OptionButton.Text = ""
					OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					OptionButton.TextSize = 13
					OptionButton.TextXAlignment = Enum.TextXAlignment.Left
					OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionButton.BackgroundTransparency = 0.9990000128746033
					OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionButton.BorderSizePixel = 0
					OptionButton.Size = UDim2.new(1, 0, 1, 0)
					OptionButton.Name = "OptionButton"
					OptionButton.Parent = OptionFrame

					OptionText.Font = Enum.Font.GothamBold
					OptionText.Text = OptionName
					OptionText.TextSize = 13
					OptionText.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
					OptionText.TextXAlignment = Enum.TextXAlignment.Left
					OptionText.TextYAlignment = Enum.TextYAlignment.Top
					OptionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionText.BackgroundTransparency = 0.9990000128746033
					OptionText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionText.BorderSizePixel = 0
					OptionText.Position = UDim2.new(0, 8, 0, 8)
					OptionText.Size = UDim2.new(1, -100, 0, 13)
					OptionText.Name = "OptionText"
					OptionText.Parent = OptionFrame
	
					ChooseFrame_Opt.AnchorPoint = Vector2.new(0, 0.5)
					ChooseFrame_Opt.BackgroundColor3 = GetColor("ThemeHighlight",ChooseFrame_Opt,"BackgroundColor3")
					ChooseFrame_Opt.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ChooseFrame_Opt.BorderSizePixel = 0
					ChooseFrame_Opt.Position = UDim2.new(0, 2, 0.5, 0)
					ChooseFrame_Opt.Size = UDim2.new(0, 0, 0, 0)
					ChooseFrame_Opt.Name = "ChooseFrame"
					ChooseFrame_Opt.Parent = OptionFrame
				
					UIStroke15_Opt.Color = GetColor("Secondary",UIStroke15_Opt,"Color")
					UIStroke15_Opt.Thickness = 1.600000023841858
					UIStroke15_Opt.Transparency = 0.999
					UIStroke15_Opt.Parent = ChooseFrame_Opt
				
					UICorner38_Opt.Parent = ChooseFrame_Opt
					OptionButton.Activated:Connect(function()
						CircleClick(OptionButton, Mouse.X, Mouse.Y) 
						if DropdownConfig.Multi then
							if OptionFrame.BackgroundTransparency > 0.95 then
								table.insert(DropdownFunc.Value, OptionName)
								DropdownFunc:Set(DropdownFunc.Value)
							else
								for i, valueInLoop in pairs(DropdownFunc.Value) do -- Renamed iterator
									if valueInLoop == OptionName then
										table.remove(DropdownFunc.Value, i)
										break
									end
								end
								DropdownFunc:Set(DropdownFunc.Value)
							end
						else
							DropdownFunc.Value = {OptionName}
							DropdownFunc:Set(DropdownFunc.Value)
						end
						if DropdownConfig.Flag and typeof(DropdownConfig.Flag) == "string" then
							local valueToSave
							if DropdownConfig.Multi then
								valueToSave = {}
								if typeof(DropdownFunc.Value) == "table" then
									for _, v_save in pairs(DropdownFunc.Value) do -- Renamed iterator
										if v_save ~= nil then
											table.insert(valueToSave, tostring(v_save))
										end
									end
								end
							else
								valueToSave = {}
								if typeof(DropdownFunc.Value) == "table" and #DropdownFunc.Value > 0 then
									table.insert(valueToSave, tostring(DropdownFunc.Value[1]))
								end
							end
							Flags[DropdownConfig.Flag] = valueToSave
							local success, err = pcall(function()
								local jsonData = HttpService:JSONEncode(Flags)
								writefile(GuiConfig.SaveFolder, jsonData)
								-- if isfile(GuiConfig.SaveFolder) then -- Debugging line, remove
								-- 	local content = readfile(GuiConfig.SaveFolder)
								-- end
							end)
							if not success then
								warn("[Save Failed]", err)
							end
						end
					end)
					local OffsetY = 0
					for _, child_scroll in ScrollSelect:GetChildren() do -- Renamed
						if child_scroll.Name ~= "UIListLayout" and child_scroll:IsA("Frame") then
							OffsetY = OffsetY + UIListLayout4_Dropdown.Padding.Offset + child_scroll.Size.Y.Offset
						end
					end
					ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
					DropCount = DropCount + 1
				end
				function DropdownFunc:Set(Value)
					if Value then
						local newValue = type(Value) == "table" and Value or {Value}
						local uniqueValues = {}
						for _, v_unique in ipairs(newValue) do -- Renamed
							if not table.find(uniqueValues, v_unique) then
								table.insert(uniqueValues, v_unique)
							end
						end
						DropdownFunc.Value = uniqueValues
					end
					for _, Drop_Set in pairs(ScrollSelect:GetChildren()) do -- Renamed
						if Drop_Set:IsA("Frame") and Drop_Set.Name == "Option" then
							local isTextFound = DropdownFunc.Value and table.find(DropdownFunc.Value, Drop_Set.OptionText.Text)
							local tweenInfoInOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
							local Size_Set = isTextFound and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0) -- Renamed
							local BackgroundTransparency_Set = isTextFound and 0.935 or 0.999 -- Renamed
							local Transparency_Set = isTextFound and 0 or 0.999 -- Renamed
							
							TweenService:Create(Drop_Set.ChooseFrame, tweenInfoInOut, {Size = Size_Set}):Play()
							TweenService:Create(Drop_Set.ChooseFrame.UIStroke, tweenInfoInOut, {Transparency = Transparency_Set}):Play()
							TweenService:Create(Drop_Set, tweenInfoInOut, {BackgroundTransparency = BackgroundTransparency_Set}):Play()
						end
					end
					local displayText = (DropdownFunc.Value and #DropdownFunc.Value > 0) and table.concat(DropdownFunc.Value, ", ") or "Select Options"
					OptionSelecting.Text = displayText
					if DropdownConfig.Callback then
						DropdownConfig.Callback(DropdownFunc.Value or {})
					end
				end
				function DropdownFunc:Refresh(RefreshList, Selecting)
					local currentValue = savedValue or DropdownConfig.Default
					RefreshList = RefreshList or {}
					Selecting = Selecting or currentValue
					for i = #ScrollSelect:GetChildren(), 1, -1 do
						local child_refresh = ScrollSelect:GetChildren()[i] -- Renamed
						if child_refresh.Name == "Option" then
							child_refresh:Destroy()
						end
					end
					DropdownFunc.Options = RefreshList
					for _, option_refresh in pairs(RefreshList) do -- Renamed
						DropdownFunc:AddOption(option_refresh)
					end
					DropdownFunc.Value = nil
					DropdownFunc:Set(Selecting)
				end
				DropdownFunc:Refresh(DropdownFunc.Options, DropdownFunc.Value)
				-- if DropdownConfig.Callback then  -- Called within Set and Refresh
				-- 	DropdownConfig.Callback(DropdownFunc.Value or {})
				-- end
				CountItem = CountItem + 1
				CountDropdown = CountDropdown + 1 -- This global counter might need to be per-UIInstance
				return DropdownFunc
			end

			function Section:AddDivider(DividerConfig)
				local DividerConfig = DividerConfig or {}
				DividerConfig.Text = DividerConfig.Text or nil -- Use nil to check for existence
			
				local DividerContainer = Instance.new("Frame")
				DividerContainer.Name = "Divider"
				DividerContainer.Size = UDim2.new(1, 0, 0, 20) 
				DividerContainer.BackgroundTransparency = 1
				DividerContainer.LayoutOrder = CountItem
				DividerContainer.Parent = Section._SectionAdd -- Corrected parent
			
				if not DividerConfig.Text or DividerConfig.Text == "" then
					local Line = Instance.new("Frame")
					Line.Name = "FullLine"
					Line.BackgroundColor3 = DividerConfig.Color or Color3.fromRGB(120, 120, 120)
					Line.BorderSizePixel = 0
					Line.AnchorPoint = Vector2.new(0.5, 0.5)
					Line.Position = UDim2.new(0.5, 0, 0.5, 0)
					Line.Size = UDim2.new(1, -10, 0, 1) 
					Line.Parent = DividerContainer
				else
					DividerContainer.Size = UDim2.new(1, 0, 0, (DividerConfig.TextSize or 12) + 8)

					local ListLayout = Instance.new("UIListLayout")
					ListLayout.FillDirection = Enum.FillDirection.Horizontal
					ListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
					ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
					ListLayout.SortOrder = Enum.SortOrder.LayoutOrder 
					ListLayout.Padding = UDim.new(0, 8) 
					ListLayout.Parent = DividerContainer
			
					local Line1 = Instance.new("Frame")
					Line1.Name = "Line1"
					Line1.BackgroundColor3 = DividerConfig.Color or Color3.fromRGB(120, 120, 120)
					Line1.BorderSizePixel = 0
					Line1.Size = UDim2.new(1, 0, 0, 1) 
					Line1.LayoutOrder = 1
					Line1.Parent = DividerContainer
			
					local DividerText = Instance.new("TextLabel")
					DividerText.Name = "DividerText"
					DividerText.Text = DividerConfig.Text
					DividerText.TextColor3 = DividerConfig.TextColor or Color3.fromRGB(200, 200, 200)
					DividerText.Font = DividerConfig.Font or Enum.Font.GothamBold
					DividerText.TextSize = DividerConfig.TextSize or 12
					DividerText.BackgroundTransparency = 1
					DividerText.AutomaticSize = Enum.AutomaticSize.X 
					DividerText.Size = UDim2.new(0, 0, 1, 0) 
					DividerText.LayoutOrder = 2
					DividerText.Parent = DividerContainer
					
					local Line2 = Instance.new("Frame")
					Line2.Name = "Line2"
					Line2.BackgroundColor3 = DividerConfig.Color or Color3.fromRGB(120, 120, 120)
					Line2.BorderSizePixel = 0
					Line2.Size = UDim2.new(1, 0, 0, 1) 
					Line2.LayoutOrder = 3
					Line2.Parent = DividerContainer
				end
				
				task.defer(function()
					Section._UpdateSizeSection()
					Section._UpdateSizeScroll()
				end)
			
				CountItem = CountItem + 1
				return {} 
			end
			
			CountSection = CountSection + 1
			return Section
		end
		
		CountTab = CountTab + 1
		return Tab
	end
	return UIInstance
end
return UBHubLib
