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

	--[[
		_Internal_CreateDropdown: Master function for creating dropdown UI elements.
		Parameters:
			- parentFrameForItems: The Frame where the main DropdownFrame UI element will be parented.
			- config: The DropdownConfig table containing settings like Title, Content, Options, etc.
			- resources: A table containing shared functions and UI instances needed by the dropdown logic. Expected keys:
				- getColorFunc: Function to get theme colors.
				- loadUIAssetFunc: Function to load UI assets.
				- DropdownFolder: Shared Folder instance for dropdown content pages.
				- DropPageLayout: UIPageLayout for the DropdownFolder.
				- MoreBlur: Frame for the blur effect when dropdown is open.
				- DropdownSelect: Frame for the dropdown selection panel.
				- circleClickFunc: Function for click visual effect.
				- mouseRef: Reference to the player's mouse.
				- tweenServiceRef: Reference to TweenService.
				- saveFileFunc: Function to save flag/setting.
				- flagsRef: Table of current flags/settings.
				- CountItemRef: A table { Value = number } to get and update the layout order.
	]]
	local function _Internal_CreateDropdown(parentFrameForItems, DropdownConfig, resources)
		local DropdownConfig = DropdownConfig or {}
		DropdownConfig.Title = DropdownConfig.Title or "No Title"
		DropdownConfig.Content = DropdownConfig.Content or ""
		DropdownConfig.Multi = DropdownConfig.Multi or false
		DropdownConfig.Options = DropdownConfig.Options or {}
		local savedValue = DropdownConfig.Flag and resources.flagsRef[DropdownConfig.Flag]
		if DropdownConfig.Multi then
			DropdownConfig.Default = (savedValue and type(savedValue) == "table") and savedValue or (type(DropdownConfig.Default) == "table" and DropdownConfig.Default or {})
		else
			DropdownConfig.Default = savedValue or DropdownConfig.Default
		end
		DropdownConfig.Callback = DropdownConfig.Callback or function() end

		local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options}

		local DropdownFrame = Instance.new("Frame")
		DropdownFrame.Name = "Dropdown"
		DropdownFrame.Parent = parentFrameForItems -- Use passed parent
		DropdownFrame.LayoutOrder = resources.CountItemRef.Value
		DropdownFrame.Size = UDim2.new(1,0,0,46)
		DropdownFrame.BackgroundTransparency = 0.935
		DropdownFrame.BackgroundColor3 = resources.getColorFunc("Secondary", DropdownFrame, "BackgroundColor3")
		Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0,4)

		local DropdownTitle = Instance.new("TextLabel", DropdownFrame)
		DropdownTitle.Name = "DropdownTitle"; DropdownTitle.Font = Enum.Font.GothamBold; DropdownTitle.Text = DropdownConfig.Title
		DropdownTitle.TextColor3 = resources.getColorFunc("Text", DropdownTitle, "TextColor3"); DropdownTitle.TextSize = 13
		DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left; DropdownTitle.TextYAlignment = Enum.TextYAlignment.Top
		DropdownTitle.BackgroundTransparency=1; DropdownTitle.Position = UDim2.new(0,10,0,10); DropdownTitle.Size = UDim2.new(1,-180,0,13)

		local DropdownContent = Instance.new("TextLabel", DropdownFrame)
		DropdownContent.Name = "DropdownContent"; DropdownContent.Font = Enum.Font.Gotham; DropdownContent.Text = DropdownConfig.Content
		DropdownContent.TextColor3 = resources.getColorFunc("Text", DropdownContent, "TextColor3"); DropdownContent.TextSize = 12
		DropdownContent.TextTransparency = 0.4; DropdownContent.TextWrapped = true; DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
		DropdownContent.TextYAlignment = Enum.TextYAlignment.Bottom; DropdownContent.BackgroundTransparency=1
		DropdownContent.Position = UDim2.new(0,10,0,0); DropdownContent.Size = UDim2.new(1,-180,1,-10)

		local SelectOptionsFrame = Instance.new("Frame", DropdownFrame)
		SelectOptionsFrame.Name = "SelectOptionsFrame"; SelectOptionsFrame.AnchorPoint = Vector2.new(1,0.5)
		SelectOptionsFrame.BackgroundColor3 = resources.getColorFunc("Primary", SelectOptionsFrame, "BackgroundColor3")
		SelectOptionsFrame.BackgroundTransparency = 0.95; SelectOptionsFrame.BorderSizePixel = 0
		SelectOptionsFrame.Position = UDim2.new(1,-7,0.5,0); SelectOptionsFrame.Size = UDim2.new(0,148,0,30)
		Instance.new("UICorner",SelectOptionsFrame).CornerRadius = UDim.new(0,4)

		local OptionSelecting = Instance.new("TextLabel",SelectOptionsFrame)
		OptionSelecting.Name = "OptionSelecting"; OptionSelecting.Font = Enum.Font.Gotham
		OptionSelecting.TextColor3 = resources.getColorFunc("Text", OptionSelecting, "TextColor3"); OptionSelecting.TextSize = 12
		OptionSelecting.TextTransparency = 0.4; OptionSelecting.TextWrapped = true; OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
		OptionSelecting.AnchorPoint = Vector2.new(0,0.5); OptionSelecting.BackgroundTransparency = 1
		OptionSelecting.Position = UDim2.new(0,5,0.5,0); OptionSelecting.Size = UDim2.new(1,-30,1,-8)

		local OptionImg = Instance.new("ImageLabel",SelectOptionsFrame)
		OptionImg.Name = "OptionImg"; OptionImg.Image = resources.loadUIAssetFunc("rbxassetid://16851841101", "DropdownArrow_Internal_Master")
		OptionImg.ImageColor3 = resources.getColorFunc("Text", OptionImg, "ImageColor3"); OptionImg.AnchorPoint = Vector2.new(1,0.5)
		OptionImg.BackgroundTransparency=1; OptionImg.Position = UDim2.new(1,0,0.5,0); OptionImg.Size = UDim2.new(0,25,0,25)

		local DropdownButton = Instance.new("TextButton", DropdownFrame)
		DropdownButton.Name = "DropdownButton"; DropdownButton.Text = ""; DropdownButton.Size = UDim2.new(1,0,1,0); DropdownButton.BackgroundTransparency = 1

		local currentDropdownID = CountDropdown; CountDropdown = CountDropdown + 1; -- CountDropdown is an upvalue to MakeGui
		SelectOptionsFrame.LayoutOrder = currentDropdownID

		local DropdownContainer = resources.DropdownFolder:FindFirstChild("DropdownContainer_"..tostring(currentDropdownID))
		if not DropdownContainer then
			DropdownContainer = Instance.new("Frame", resources.DropdownFolder); DropdownContainer.Name = "DropdownContainer_"..tostring(currentDropdownID)
			DropdownContainer.BackgroundTransparency = 1; DropdownContainer.Size = UDim2.new(1,0,1,0)
			local SearchBar = Instance.new("TextBox", DropdownContainer); SearchBar.Name = "SearchBar_Dropdown"
			SearchBar.Font = Enum.Font.GothamBold; SearchBar.PlaceholderText = "🔎 Search"
			SearchBar.PlaceholderColor3 = resources.getColorFunc("Text", SearchBar, "PlaceholderColor3"); SearchBar.Text = ""
			SearchBar.TextColor3 = resources.getColorFunc("Text", SearchBar, "TextColor3"); SearchBar.TextSize = 12
			SearchBar.BackgroundColor3 = resources.getColorFunc("Secondary", SearchBar, "BackgroundColor3"); SearchBar.BackgroundTransparency = 0
			SearchBar.BorderColor3 = resources.getColorFunc("Stroke", SearchBar, "BorderColor3"); SearchBar.BorderSizePixel = 1
			SearchBar.Size = UDim2.new(1,-10,0,25); SearchBar.Position = UDim2.new(0,5,0,5)

			local ScrollSel = Instance.new("ScrollingFrame", DropdownContainer); ScrollSel.Name = "ScrollSelect"
			ScrollSel.CanvasSize = UDim2.new(0,0,0,0); ScrollSel.ScrollBarThickness = 0; ScrollSel.Active = true
			ScrollSel.Position = UDim2.new(0,0,0,35); ScrollSel.BackgroundTransparency=1; ScrollSel.Size = UDim2.new(1,0,1,-35)

			local UIList = Instance.new("UIListLayout", ScrollSel); UIList.Padding = UDim.new(0,3); UIList.SortOrder = Enum.SortOrder.LayoutOrder

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

		local SearchBar_Dropdown_Instance = DropdownContainer:FindFirstChild("SearchBar_Dropdown")
		local ScrollSelect_Instance = DropdownContainer:FindFirstChild("ScrollSelect")
		local UIListLayout_Scroll_Instance
		if ScrollSelect_Instance then
			UIListLayout_Scroll_Instance = ScrollSelect_Instance:FindFirstChildOfClass("UIListLayout")
		else
			warn("_Internal_CreateDropdown: ScrollSelect_Instance not found in DropdownContainer: " .. DropdownContainer.Name)
		end
		if not SearchBar_Dropdown_Instance then warn("_Internal_CreateDropdown: SearchBar_Dropdown_Instance not found in DropdownContainer: " .. DropdownContainer.Name) end
		if not UIListLayout_Scroll_Instance then warn("_Internal_CreateDropdown: UIListLayout_Scroll_Instance not found in ScrollSelect_Instance for DropdownContainer: " .. DropdownContainer.Name) end

		DropdownButton.Activated:Connect(function()
			resources.circleClickFunc(DropdownButton, resources.mouseRef.X, resources.mouseRef.Y)
			if not resources.MoreBlur.Visible then
				resources.MoreBlur.Visible = true
				resources.DropPageLayout:JumpTo(DropdownContainer)
				resources.tweenServiceRef:Create(resources.MoreBlur, TweenInfo.new(0.2),{BackgroundTransparency = 0.7}):Play()
				resources.tweenServiceRef:Create(resources.DropdownSelect, TweenInfo.new(0.2),{Position = UDim2.new(1,-11,0.5,0)}):Play()
			end
		end)

		local dropCountLocal = 0
		function DropdownFunc:Clear()
			if not ScrollSelect_Instance then return end
			for i=#ScrollSelect_Instance:GetChildren(),1,-1 do
				local c = ScrollSelect_Instance:GetChildren()[i]
				if c.Name == "Option" then c:Destroy() end
			end
			DropdownFunc.Value={}; DropdownFunc.Options={}; OptionSelecting.Text = "Select Options"; dropCountLocal = 0
			ScrollSelect_Instance.CanvasSize = UDim2.new(0,0,0,0)
		end

		function DropdownFunc:AddOption(oN)
			if not ScrollSelect_Instance or not UIListLayout_Scroll_Instance then
				warn("_Internal_CreateDropdown:AddOption - ScrollSelect_Instance or UIListLayout_Scroll_Instance is nil.")
				return
			end
			oN = oN or "Option"
			local oF = Instance.new("Frame",ScrollSelect_Instance); oF.Name="Option"; oF.Size=UDim2.new(1,0,0,30)
			oF.BackgroundTransparency=0.97; oF.BackgroundColor3=resources.getColorFunc("Secondary",oF,"BackgroundColor3")
			Instance.new("UICorner",oF).CornerRadius=UDim.new(0,3)
			local oB=Instance.new("TextButton",oF); oB.Name="OptionButton"; oB.Text=""; oB.Size=UDim2.new(1,0,1,0); oB.BackgroundTransparency=1
			local oT=Instance.new("TextLabel",oF); oT.Name="OptionText"; oT.Font=Enum.Font.Gotham; oT.Text=oN
			oT.TextColor3=resources.getColorFunc("Text",oT,"TextColor3"); oT.TextSize=13; oT.TextXAlignment=Enum.TextXAlignment.Left
			oT.BackgroundTransparency=1; oT.Position=UDim2.new(0,8,0,0); oT.Size=UDim2.new(1,-16,1,0)
			local cF=Instance.new("Frame",oF); cF.Name="ChooseFrame"; cF.AnchorPoint=Vector2.new(0,0.5)
			cF.BackgroundColor3=resources.getColorFunc("ThemeHighlight",cF,"BackgroundColor3"); cF.BorderSizePixel=0
			cF.Position=UDim2.new(0,2,0.5,0); cF.Size=UDim2.new(0,0,0,0); Instance.new("UICorner",cF).CornerRadius=UDim.new(0,3)
			local cS=Instance.new("UIStroke",cF); cS.Color=resources.getColorFunc("Secondary",cS,"Color"); cS.Thickness=1.6; cS.Transparency=1
			dropCountLocal=dropCountLocal+1; oF.LayoutOrder=dropCountLocal

			oB.Activated:Connect(function()
				resources.circleClickFunc(oB, resources.mouseRef.X, resources.mouseRef.Y)
				if DropdownConfig.Multi then
					local fI=table.find(DropdownFunc.Value,oN)
					if fI then table.remove(DropdownFunc.Value,fI) else table.insert(DropdownFunc.Value,oN) end
				else
					DropdownFunc.Value={oN}
				end
				DropdownFunc:Set(DropdownFunc.Value)
				if DropdownConfig.Flag then resources.saveFileFunc(DropdownConfig.Flag, DropdownFunc.Value) end
			end)

			-- CanvasSize calculation removed from AddOption, will be handled in Refresh
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
					local iTF=DropdownFunc.Value and table.find(DropdownFunc.Value,d_S.OptionText.Text)
					local tII=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut)
					local s_S=iTF and UDim2.new(0,1,0,12) or UDim2.new(0,0,0,0)
					local bT_S=iTF and 0.935 or 0.97; local tr_S=iTF and 0 or 1
					resources.tweenServiceRef:Create(d_S.ChooseFrame,tII,{Size=s_S}):Play()
					resources.tweenServiceRef:Create(d_S.ChooseFrame.UIStroke,tII,{Transparency=tr_S}):Play()
					resources.tweenServiceRef:Create(d_S,tII,{BackgroundTransparency=bT_S}):Play()
				end
			end
			local dT=(DropdownFunc.Value and #DropdownFunc.Value>0) and table.concat(DropdownFunc.Value,", ") or "Select Options"
			OptionSelecting.Text=dT
			if DropdownConfig.Callback then DropdownConfig.Callback(DropdownFunc.Value or {}) end
		end

		function DropdownFunc:Refresh(rL,sEl)
			local cV=savedValue or DropdownConfig.Default
			rL=rL or {}; sEl=sEl or cV
			DropdownFunc:Clear()
			DropdownFunc.Options=rL
			for _,oR in pairs(rL) do DropdownFunc:AddOption(oR) end
			DropdownFunc.Value=nil; DropdownFunc:Set(sEl)

			-- Set CanvasSize after all options are added
			task.defer(function()
				if ScrollSelect_Instance and UIListLayout_Scroll_Instance then -- Ensure they are still valid
					ScrollSelect_Instance.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_Scroll_Instance.AbsoluteContentSize.Y)
				elseif ScrollSelect_Instance then -- Fallback if UIListLayout_Scroll_Instance became nil unexpectedly
					warn("_Internal_CreateDropdown:Refresh - UIListLayout_Scroll_Instance was nil, attempting to find again.")
					local currentLayout = ScrollSelect_Instance:FindFirstChildOfClass("UIListLayout")
					if currentLayout then
						ScrollSelect_Instance.CanvasSize = UDim2.new(0,0,0, currentLayout.AbsoluteContentSize.Y)
					else
						warn("_Internal_CreateDropdown:Refresh - Could not find UIListLayout in ScrollSelect_Instance for CanvasSize.")
					end
				end
			end)
		end

		DropdownFunc:Refresh(DropdownConfig.Options, DropdownConfig.Default)

		task.delay(0, function()
			local contentHeight = DropdownContent.TextBounds.Y; local titleHeight = DropdownTitle.TextBounds.Y
			DropdownFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15))
			-- SectionObject._UpdateSizeSection() -- This needs to be called by the caller if parent size needs update
		end)

		resources.CountItemRef.Value = resources.CountItemRef.Value + 1
		return DropdownFunc
	end


	local function InternalCreateSection(parentScrolLayersInstance, sectionTitle, sectionLayoutOrder,
                                     guiConfigRef, flagsRef, themesRef, currentThemeNameRef,
                                     getColorFunc, setThemeFunc, loadUIAssetFunc, saveFileFunc,
                                     httpServiceRef, tweenServiceRef, mouseRef, circleClickFunc,
                                     updateParentScrollFunc, parentUIListLayoutPaddingRef) -- Added Ref to padding

		sectionTitle = sectionTitle or "Section"

		local SectionFrame = Instance.new("Frame")
		SectionFrame.Name = "Section"
		SectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SectionFrame.BackgroundTransparency = 0.9990000128746033
		SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SectionFrame.BorderSizePixel = 0
		SectionFrame.LayoutOrder = sectionLayoutOrder
		SectionFrame.ClipsDescendants = true
		SectionFrame.Size = UDim2.new(1, 0, 0, 30)
		SectionFrame.Parent = parentScrolLayersInstance

		local SectionReal = Instance.new("Frame")
		SectionReal.Name = "SectionReal"
		SectionReal.AnchorPoint = Vector2.new(0.5, 0)
		SectionReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SectionReal.BackgroundTransparency = 0.9350000023841858
		SectionReal.BorderColor3 = Color3.fromRGB(0,0,0)
		SectionReal.BorderSizePixel = 0
		SectionReal.LayoutOrder = 1
		SectionReal.Position = UDim2.new(0.5,0,0,0)
		SectionReal.Size = UDim2.new(1,1,0,30)
		SectionReal.Parent = SectionFrame
		local UICorner_SR = Instance.new("UICorner", SectionReal)
		UICorner_SR.CornerRadius = UDim.new(0,4)
		-- UIStroke for SectionReal was not in the original Tab:AddSection, so omitted here.

		local SectionButton = Instance.new("TextButton")
		SectionButton.Name = "SectionButton"
		SectionButton.Font = Enum.Font.SourceSans
		SectionButton.Text = ""
		SectionButton.TextColor3 = Color3.fromRGB(0,0,0)
		SectionButton.TextSize = 14
		SectionButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
		SectionButton.BackgroundTransparency = 0.9990000128746033
		SectionButton.BorderColor3 = Color3.fromRGB(0,0,0)
		SectionButton.BorderSizePixel = 0
		SectionButton.Size = UDim2.new(1,0,1,0)
		SectionButton.Parent = SectionReal

		local FeatureFrame_Section = Instance.new("Frame", SectionReal)
		FeatureFrame_Section.Name = "FeatureFrame"
		FeatureFrame_Section.AnchorPoint = Vector2.new(1,0.5)
		FeatureFrame_Section.BackgroundColor3 = Color3.fromRGB(0,0,0)
		FeatureFrame_Section.BackgroundTransparency = 0.9990000128746033
		FeatureFrame_Section.BorderColor3 = Color3.fromRGB(0,0,0)
		FeatureFrame_Section.BorderSizePixel = 0
		FeatureFrame_Section.Position = UDim2.new(1,-5,0.5,0)
		FeatureFrame_Section.Size = UDim2.new(0,20,0,20)

		local FeatureImg_Section = Instance.new("ImageLabel", FeatureFrame_Section)
		FeatureImg_Section.Name = "FeatureImg"
		FeatureImg_Section.Image = loadUIAssetFunc("rbxassetid://16851841101", "FeatureImg_InternalSection") -- Unique name for asset
		FeatureImg_Section.AnchorPoint = Vector2.new(0.5,0.5)
		FeatureImg_Section.BackgroundColor3 = Color3.fromRGB(255,255,255)
		FeatureImg_Section.BackgroundTransparency = 0.9990000128746033
		FeatureImg_Section.BorderColor3 = Color3.fromRGB(0,0,0)
		FeatureImg_Section.BorderSizePixel = 0
		FeatureImg_Section.Position = UDim2.new(0.5,0,0.5,0)
		FeatureImg_Section.Rotation = -90
		FeatureImg_Section.Size = UDim2.new(1,6,1,6)

		local SectionTitleText = Instance.new("TextLabel", SectionReal)
		SectionTitleText.Name = "SectionTitle"
		SectionTitleText.Font = Enum.Font.GothamBold
		SectionTitleText.Text = sectionTitle
		SectionTitleText.TextColor3 = getColorFunc("Text", SectionTitleText, "TextColor3") -- Pass instance and property
		SectionTitleText.TextSize = 13
		SectionTitleText.TextXAlignment = Enum.TextXAlignment.Left
		SectionTitleText.TextYAlignment = Enum.TextYAlignment.Top -- Was Center in original Tab:AddSection, but Top in placeholder. Keeping Top for now.
		SectionTitleText.AnchorPoint = Vector2.new(0,0.5)
		SectionTitleText.BackgroundColor3 = Color3.fromRGB(255,255,255)
		SectionTitleText.BackgroundTransparency = 0.9990000128746033
		SectionTitleText.BorderColor3 = Color3.fromRGB(0,0,0)
		SectionTitleText.BorderSizePixel = 0
		SectionTitleText.Position = UDim2.new(0,10,0.5,0)
		SectionTitleText.Size = UDim2.new(1,-50,0,13)

		local SectionDecideFrame = Instance.new("Frame", SectionFrame)
		SectionDecideFrame.Name = "SectionDecideFrame"
		SectionDecideFrame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- Will be set by UIGradient
		SectionDecideFrame.BorderColor3 = Color3.fromRGB(0,0,0)
		SectionDecideFrame.AnchorPoint = Vector2.new(0.5,0)
		SectionDecideFrame.BorderSizePixel = 0
		SectionDecideFrame.Position = UDim2.new(0.5,0,0,33)
		SectionDecideFrame.Size = UDim2.new(0,0,0,2) -- Initially hidden/zero width for animation
		Instance.new("UICorner", SectionDecideFrame)

		local UIGradient_Section = Instance.new("UIGradient", SectionDecideFrame)
		UIGradient_Section.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, themesRef[currentThemeNameRef()].Primary), -- Use current theme's primary
			ColorSequenceKeypoint.new(0.5, guiConfigRef.Color),
			ColorSequenceKeypoint.new(1, themesRef[currentThemeNameRef()].Primary)  -- Use current theme's primary
		}

		local SectionAdd = Instance.new("Frame")
		SectionAdd.Name = "SectionAdd"
		SectionAdd.AnchorPoint = Vector2.new(0.5,0)
		SectionAdd.BackgroundColor3 = Color3.fromRGB(255,255,255)
		SectionAdd.BackgroundTransparency = 0.9990000128746033
		SectionAdd.BorderColor3 = Color3.fromRGB(0,0,0)
		SectionAdd.BorderSizePixel = 0
		SectionAdd.ClipsDescendants = true
		SectionAdd.LayoutOrder = 1
		SectionAdd.Position = UDim2.new(0.5,0,0,38)
		SectionAdd.Size = UDim2.new(1,0,0,0) -- Start with 0 height, will expand
		SectionAdd.Parent = SectionFrame
		Instance.new("UICorner", SectionAdd).CornerRadius = UDim.new(0,2)

		local UIListLayout_SectionAdd = Instance.new("UIListLayout", SectionAdd)
		UIListLayout_SectionAdd.Padding = UDim.new(0,3)
		UIListLayout_SectionAdd.SortOrder = Enum.SortOrder.LayoutOrder

		local OpenSection = false

		local function UpdateThisInternalSectionSize()
			if OpenSection then
				task.defer(function() -- Defer to allow content to render for AbsoluteContentSize
					local contentHeight = UIListLayout_SectionAdd.AbsoluteContentSize.Y
					local newHeight = math.max(38 + contentHeight + UIListLayout_SectionAdd.Padding.Offset, 30) -- Min height 30
					if #SectionAdd:GetChildren() == 0 then newHeight = 30; contentHeight = 0 end

					SectionFrame.Size = UDim2.new(1,0,0,newHeight)
					SectionAdd.Size = UDim2.new(1,0,0,contentHeight)
					SectionDecideFrame.Size = UDim2.new(1,0,0,2) -- Show separator line
					updateParentScrollFunc(parentScrolLayersInstance, parentUIListLayoutPaddingRef()) -- Call with the actual padding value
				end)
			else
				SectionFrame.Size = UDim2.new(1,0,0,30)
				SectionAdd.Size = UDim2.new(1,0,0,0)
				SectionDecideFrame.Size = UDim2.new(0,0,0,2) -- Hide separator line by setting width to 0
				updateParentScrollFunc(parentScrolLayersInstance, parentUIListLayoutPaddingRef()) -- Call with the actual padding value
			end
		end

		SectionButton.Activated:Connect(function()
			circleClickFunc(SectionButton, mouseRef.X, mouseRef.Y)
			OpenSection = not OpenSection
			if OpenSection then
				tweenServiceRef:Create(FeatureImg_Section, TweenInfo.new(0.3), {Rotation = 0}):Play() -- Open state rotation
				SectionAdd.Visible = true -- Make visible before sizing
			else
				tweenServiceRef:Create(FeatureImg_Section, TweenInfo.new(0.3), {Rotation = -90}):Play() -- Closed state
				-- Tween size to 0 then hide
				tweenServiceRef:Create(SectionAdd, TweenInfo.new(0.3), {Size = UDim2.new(1,0,0,0)}):Play()
				task.delay(0.3, function()
					if not OpenSection then SectionAdd.Visible = false end -- Hide after tween if still closed
				end)
			end
			UpdateThisInternalSectionSize() -- This will handle sizing based on OpenSection state
		end)

		SectionAdd.ChildAdded:Connect(UpdateThisInternalSectionSize)
		SectionAdd.ChildRemoved:Connect(UpdateThisInternalSectionSize)
		UpdateThisInternalSectionSize() -- Initial call to set correct size

		local SectionObject = {}
		SectionObject._SectionAdd = SectionAdd
		SectionObject._UpdateSizeSection = UpdateThisInternalSectionSize
		SectionObject._UpdateSizeScroll = function() updateParentScrollFunc(parentScrolLayersInstance, parentUIListLayoutPaddingRef()) end

		local CountItem = 0 -- This will be local to each SectionObject instance

		function SectionObject:AddParagraph(ParagraphConfig)
			local ParagraphConfig = ParagraphConfig or {}
			ParagraphConfig.Title = ParagraphConfig.Title or "Title"
			ParagraphConfig.Content = ParagraphConfig.Content or "Content"
			local ParagraphFunc = {}
			local Paragraph = Instance.new("Frame")
			Paragraph.Name = "Paragraph"; Paragraph.Parent = SectionObject._SectionAdd; Paragraph.LayoutOrder = CountItem;
			Paragraph.Size = UDim2.new(1,0,0,46); Paragraph.BackgroundTransparency = 0.935; Paragraph.BackgroundColor3 = getColorFunc("Secondary", Paragraph, "BackgroundColor3")
			Instance.new("UICorner", Paragraph).CornerRadius = UDim.new(0,4)
			local ParagraphTitle = Instance.new("TextLabel", Paragraph)
			ParagraphTitle.Name = "ParagraphTitle"; ParagraphTitle.Font = Enum.Font.GothamBold; ParagraphTitle.Text = ParagraphConfig.Title .. " | " .. ParagraphConfig.Content;
			ParagraphTitle.TextColor3 = getColorFunc("Text", ParagraphTitle, "TextColor3"); ParagraphTitle.TextSize = 13; ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left; ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top;
			ParagraphTitle.BackgroundTransparency = 1; ParagraphTitle.Position = UDim2.new(0,10,0,10); ParagraphTitle.Size = UDim2.new(1,-16,0,13); ParagraphTitle.TextWrapped = true
			task.delay(0, function()
				ParagraphTitle.Size = UDim2.new(1, -16, 0, ParagraphTitle.TextBounds.Y); Paragraph.Size = UDim2.new(1,0,0, ParagraphTitle.TextBounds.Y + 20); SectionObject._UpdateSizeSection()
			end)
			function ParagraphFunc:Set(pConfig) ParagraphTitle.Text = (pConfig.Title or "T") .. " | " .. (pConfig.Content or "C"); task.delay(0,function() ParagraphTitle.Size = UDim2.new(1,-16,0,ParagraphTitle.TextBounds.Y); Paragraph.Size = UDim2.new(1,0,0,ParagraphTitle.TextBounds.Y + 20); SectionObject._UpdateSizeSection() end) end
			CountItem = CountItem + 1; return ParagraphFunc
		end

		function SectionObject:AddButton(ButtonConfig)
			local ButtonConfig = ButtonConfig or {}; ButtonConfig.Title = ButtonConfig.Title or "Button"; ButtonConfig.Content = ButtonConfig.Content or ""; ButtonConfig.Icon = ButtonConfig.Icon or loadUIAssetFunc("rbxassetid://16932740082", "ButtonConfig_Internal.png"); ButtonConfig.Callback = ButtonConfig.Callback or function() end
			local ButtonFrame = Instance.new("Frame"); ButtonFrame.Name = "Button"; ButtonFrame.Parent = SectionObject._SectionAdd; ButtonFrame.LayoutOrder = CountItem;
			ButtonFrame.Size = UDim2.new(1,0,0,46); ButtonFrame.BackgroundTransparency = 0.935; ButtonFrame.BackgroundColor3 = getColorFunc("Secondary", ButtonFrame, "BackgroundColor3")
			Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0,4)
			local ButtonTitle = Instance.new("TextLabel", ButtonFrame); ButtonTitle.Name = "ButtonTitle"; ButtonTitle.Font = Enum.Font.GothamBold; ButtonTitle.Text = ButtonConfig.Title; ButtonTitle.TextColor3 = getColorFunc("Text", ButtonTitle, "TextColor3"); ButtonTitle.TextSize = 13; ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left; ButtonTitle.TextYAlignment = Enum.TextYAlignment.Top; ButtonTitle.BackgroundTransparency=1; ButtonTitle.Position = UDim2.new(0,10,0,10); ButtonTitle.Size = UDim2.new(1,-100,0,13)
			local ButtonContent = Instance.new("TextLabel", ButtonFrame); ButtonContent.Name = "ButtonContent"; ButtonContent.Font = Enum.Font.Gotham; ButtonContent.Text = ButtonConfig.Content; ButtonContent.TextColor3 = getColorFunc("Text", ButtonContent, "TextColor3"); ButtonContent.TextSize = 12; ButtonContent.TextTransparency = 0.4; ButtonContent.TextXAlignment = Enum.TextXAlignment.Left; ButtonContent.TextYAlignment = Enum.TextYAlignment.Bottom; ButtonContent.BackgroundTransparency=1; ButtonContent.Position = UDim2.new(0,10,0,0); ButtonContent.Size = UDim2.new(1,-100,1,-10); ButtonContent.TextWrapped = true
			local ActualButton = Instance.new("TextButton", ButtonFrame); ActualButton.Name = "ActualButton"; ActualButton.Text = ""; ActualButton.Size = UDim2.new(1,0,1,0); ActualButton.BackgroundTransparency = 1; ActualButton.Activated:Connect(function() circleClickFunc(ActualButton, mouseRef.X, mouseRef.Y); ButtonConfig.Callback() end)
			if ButtonConfig.Icon then
				local FeatureFrame1_Button = Instance.new("Frame", ButtonFrame); FeatureFrame1_Button.Name = "FeatureFrame"; FeatureFrame1_Button.AnchorPoint = Vector2.new(1,0.5); FeatureFrame1_Button.BackgroundTransparency = 1; FeatureFrame1_Button.Position = UDim2.new(1,-15,0.5,0); FeatureFrame1_Button.Size = UDim2.new(0,25,0,25)
				local FeatureImg3_Button = Instance.new("ImageLabel", FeatureFrame1_Button); FeatureImg3_Button.Name = "FeatureImg"; FeatureImg3_Button.Image = ButtonConfig.Icon; FeatureImg3_Button.AnchorPoint = Vector2.new(0.5,0.5); FeatureImg3_Button.BackgroundTransparency = 1; FeatureImg3_Button.Position = UDim2.new(0.5,0,0.5,0); FeatureImg3_Button.Size = UDim2.new(1,0,1,0)
			end
			task.delay(0, function() local contentHeight = ButtonContent.TextBounds.Y; local titleHeight = ButtonTitle.TextBounds.Y; ButtonFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15)); SectionObject._UpdateSizeSection() end)
			CountItem = CountItem + 1; return {}
		end

		function SectionObject:AddToggle(ToggleConfig)
			local ToggleConfig = ToggleConfig or {}; ToggleConfig.Title = ToggleConfig.Title or "Toggle"; ToggleConfig.Content = ToggleConfig.Content or ""; ToggleConfig.Default = (ToggleConfig.Flag and flagsRef[ToggleConfig.Flag] ~= nil) and flagsRef[ToggleConfig.Flag] or ToggleConfig.Default or false; ToggleConfig.Callback = ToggleConfig.Callback or function() end
			local ToggleFrame = Instance.new("Frame"); ToggleFrame.Name = "Toggle"; ToggleFrame.Parent = SectionObject._SectionAdd; ToggleFrame.LayoutOrder = CountItem;
			ToggleFrame.Size = UDim2.new(1,0,0,46); ToggleFrame.BackgroundTransparency = 0.935; ToggleFrame.BackgroundColor3 = getColorFunc("Secondary", ToggleFrame, "BackgroundColor3")
			Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0,4)
			local ToggleTitle = Instance.new("TextLabel", ToggleFrame); ToggleTitle.Name = "ToggleTitle"; ToggleTitle.Font = Enum.Font.GothamBold; ToggleTitle.Text = ToggleConfig.Title; ToggleTitle.TextColor3 = getColorFunc("Text", ToggleTitle, "TextColor3"); ToggleTitle.TextSize = 13; ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left; ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top; ToggleTitle.BackgroundTransparency=1; ToggleTitle.Position = UDim2.new(0,10,0,10); ToggleTitle.Size = UDim2.new(1,-100,0,13)
			local ToggleContent = Instance.new("TextLabel", ToggleFrame); ToggleContent.Name = "ToggleContent"; ToggleContent.Font = Enum.Font.Gotham; ToggleContent.Text = ToggleConfig.Content; ToggleContent.TextColor3 = getColorFunc("Text", ToggleContent, "TextColor3"); ToggleContent.TextSize = 12; ToggleContent.TextTransparency = 0.4; ToggleContent.TextXAlignment = Enum.TextXAlignment.Left; ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom; ToggleContent.BackgroundTransparency=1; ToggleContent.Position = UDim2.new(0,10,0,0); ToggleContent.Size = UDim2.new(1,-100,1,-10); ToggleContent.TextWrapped = true
			local SwitchFrame = Instance.new("Frame", ToggleFrame); SwitchFrame.Name = "SwitchFrame"; SwitchFrame.AnchorPoint = Vector2.new(1,0.5); SwitchFrame.BackgroundColor3 = getColorFunc("Accent", SwitchFrame, "BackgroundColor3"); SwitchFrame.BackgroundTransparency = 0.5; SwitchFrame.BorderSizePixel = 0; SwitchFrame.Position = UDim2.new(1,-15,0.5,0); SwitchFrame.Size = UDim2.new(0,30,0,15); Instance.new("UICorner", SwitchFrame).CornerRadius = UDim.new(0,100)
			local SwitchCircle = Instance.new("Frame", SwitchFrame); SwitchCircle.Name = "SwitchCircle"; SwitchCircle.BackgroundColor3 = getColorFunc("ThemeHighlight", SwitchCircle, "BackgroundColor3"); SwitchCircle.BorderSizePixel = 0; SwitchCircle.Position = UDim2.new(ToggleConfig.Default and 0.5 or 0, ToggleConfig.Default and -1 or 1, 0.5, -6); SwitchCircle.Size = UDim2.new(0,12,0,12); Instance.new("UICorner", SwitchCircle).CornerRadius = UDim.new(0,100)
			local ActualButton = Instance.new("TextButton", ToggleFrame); ActualButton.Name = "ActualButton"; ActualButton.Text = ""; ActualButton.Size = UDim2.new(1,0,1,0); ActualButton.BackgroundTransparency = 1
			local currentValue = ToggleConfig.Default
			local function setToggleVisual(value) SwitchCircle:TweenPosition(UDim2.new(value and 0.5 or 0, value and -1 or 1, 0.5, -6), "Out", "Quad", 0.15, true) end; setToggleVisual(currentValue)
			function ActualButton.Activated() circleClickFunc(ActualButton, mouseRef.X, mouseRef.Y); currentValue = not currentValue; if ToggleConfig.Flag then saveFileFunc(ToggleConfig.Flag, currentValue) end; ToggleConfig.Callback(currentValue); setToggleVisual(currentValue) end
			task.delay(0, function() local contentHeight = ToggleContent.TextBounds.Y; local titleHeight = ToggleTitle.TextBounds.Y; ToggleFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15)); SectionObject._UpdateSizeSection() end)
			CountItem = CountItem + 1; return { GetValue = function() return currentValue end, SetValue = function(val) currentValue = val; if ToggleConfig.Flag then saveFileFunc(ToggleConfig.Flag, currentValue) end; ToggleConfig.Callback(currentValue); setToggleVisual(currentValue); end }
		end

		function SectionObject:AddSlider(SliderConfig)
			local SliderConfig = SliderConfig or {}; SliderConfig.Title = SliderConfig.Title or "Slider"; SliderConfig.Content = SliderConfig.Content or ""; SliderConfig.Min = SliderConfig.Min or 0; SliderConfig.Max = SliderConfig.Max or 100; SliderConfig.Increment = SliderConfig.Increment or 1; local savedVal = SliderConfig.Flag and flagsRef[SliderConfig.Flag]; SliderConfig.Default = tonumber(savedVal or SliderConfig.Default or SliderConfig.Min); SliderConfig.Callback = SliderConfig.Callback or function() end
			local SliderFrame = Instance.new("Frame"); SliderFrame.Name = "Slider"; SliderFrame.Parent = SectionObject._SectionAdd; SliderFrame.LayoutOrder = CountItem;
			SliderFrame.Size = UDim2.new(1,0,0,55); SliderFrame.BackgroundTransparency = 0.935; SliderFrame.BackgroundColor3 = getColorFunc("Secondary", SliderFrame, "BackgroundColor3")
			Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0,4)
			local SliderTitle = Instance.new("TextLabel", SliderFrame); SliderTitle.Name = "SliderTitle"; SliderTitle.Font = Enum.Font.GothamBold; SliderTitle.Text = SliderConfig.Title; SliderTitle.TextColor3 = getColorFunc("Text", SliderTitle, "TextColor3"); SliderTitle.TextSize = 13; SliderTitle.TextXAlignment = Enum.TextXAlignment.Left; SliderTitle.TextYAlignment = Enum.TextYAlignment.Top; SliderTitle.BackgroundTransparency=1; SliderTitle.Position = UDim2.new(0,10,0,10); SliderTitle.Size = UDim2.new(1,-60,0,13)
			local SliderValueText = Instance.new("TextBox", SliderFrame); SliderValueText.Name = "SliderValueText"; SliderValueText.Font = Enum.Font.GothamBold; SliderValueText.Text = tostring(SliderConfig.Default); SliderValueText.TextColor3 = getColorFunc("Text", SliderValueText, "TextColor3"); SliderValueText.TextSize = 12; SliderValueText.BackgroundTransparency = 0.8; SliderValueText.BackgroundColor3 = getColorFunc("Accent", SliderValueText, "BackgroundColor3"); SliderValueText.Position = UDim2.new(1,-45,0,5); SliderValueText.Size = UDim2.new(0,40,0,20); Instance.new("UICorner", SliderValueText).CornerRadius = UDim.new(0,3)
			local Bar = Instance.new("Frame", SliderFrame); Bar.Name = "Bar"; Bar.BackgroundColor3 = getColorFunc("Accent", Bar, "BackgroundColor3"); Bar.BorderSizePixel = 0; Bar.Position = UDim2.new(0,10,1,-20); Bar.Size = UDim2.new(1,-20,0,5); Instance.new("UICorner", Bar).CornerRadius = UDim.new(0,100)
			local Progress = Instance.new("Frame", Bar); Progress.Name = "Progress"; Progress.BackgroundColor3 = getColorFunc("ThemeHighlight", Progress, "BackgroundColor3"); Progress.BorderSizePixel = 0; Instance.new("UICorner", Progress).CornerRadius = UDim.new(0,100)

			-- Task #3: Slider Usability Enhancement
			local DraggerHitbox = Instance.new("TextButton", Bar)
			DraggerHitbox.Name = "DraggerHitbox"
			DraggerHitbox.Text = ""
			DraggerHitbox.Size = UDim2.new(0, 20, 0, 20) -- Larger hitbox (e.g., 20x20 or 24x24)
			DraggerHitbox.AnchorPoint = Vector2.new(0.5, 0.5)
			DraggerHitbox.BackgroundTransparency = 1 -- Invisible hitbox
			DraggerHitbox.BorderSizePixel = 0
			DraggerHitbox.ZIndex = 3 -- Above visual dragger if visual is also child of Bar, or ensure it captures input

			local VisualDragger = Instance.new("Frame", DraggerHitbox) -- Visual part is child of hitbox
			VisualDragger.Name = "VisualDragger"
			VisualDragger.Size = UDim2.new(0, 10, 0, 10) -- Original visual size
			VisualDragger.AnchorPoint = Vector2.new(0.5, 0.5)
			VisualDragger.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centered in hitbox
			VisualDragger.BackgroundColor3 = getColorFunc("ThemeHighlight", VisualDragger, "BackgroundColor3")
			VisualDragger.BorderSizePixel = 0
			Instance.new("UICorner", VisualDragger).CornerRadius = UDim.new(0,100)
			VisualDragger.ZIndex = 2 -- Below hitbox input plane if necessary, but parent relationship handles this.

			local currentValue = SliderConfig.Default
			local function UpdateSlider(value)
				value = math.clamp(math.floor(value/SliderConfig.Increment + 0.5) * SliderConfig.Increment, SliderConfig.Min, SliderConfig.Max)
				currentValue = value
				SliderValueText.Text = tostring(value)
				local percent = (SliderConfig.Max - SliderConfig.Min == 0) and 0 or (value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
				Progress.Size = UDim2.new(percent,0,1,0)
				DraggerHitbox.Position = UDim2.new(percent,0,0.5,0) -- Move the hitbox
				if SliderConfig.Flag then saveFileFunc(SliderConfig.Flag, currentValue) end
				SliderConfig.Callback(currentValue)
			end
			UpdateSlider(currentValue)

			DraggerHitbox.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					local dragging = true
					local conn
					conn = UserInputService.InputChanged:Connect(function(subInput)
						if not dragging then conn:Disconnect() return end
						if subInput.UserInputType == Enum.UserInputType.MouseMovement or subInput.UserInputType == Enum.UserInputType.Touch then
							local localPos = Bar.AbsolutePosition.X
							local mousePos = subInput.Position.X
							local percent = math.clamp((mousePos - localPos) / Bar.AbsoluteSize.X, 0, 1)
							UpdateSlider(SliderConfig.Min + percent * (SliderConfig.Max - SliderConfig.Min))
						end
					end)
					-- Use DraggerHitbox.InputEnded or a connection to input.Changed for UserInputState.End
					local inputEndedConn
					inputEndedConn = input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragging = false
							if conn then conn:Disconnect() end
							if inputEndedConn then inputEndedConn:Disconnect() end
						end
					end)
					-- Fallback for InputEnded on the DraggerHitbox itself if Changed event isn't reliable for all cases
					local draggerInputEndedConn
					draggerInputEndedConn = DraggerHitbox.InputEnded:Connect(function(endInput)
						if endInput.UserInputType == input.UserInputType then -- Ensure it's the same input type ending
							dragging = false
							if conn then conn:Disconnect() end
							if inputEndedConn then inputEndedConn:Disconnect() end
							if draggerInputEndedConn then draggerInputEndedConn:Disconnect() end
						end
					end)
				end
			end)
			SliderValueText.FocusLost:Connect(function(enterPressed) if enterPressed then local num = tonumber(SliderValueText.Text); if num then UpdateSlider(num) else UpdateSlider(currentValue) end end end)
			CountItem = CountItem + 1; return { GetValue = function() return currentValue end, SetValue = UpdateSlider }
		end

		function SectionObject:AddInput(InputConfig)
			local InputConfig = InputConfig or {}; InputConfig.Title = InputConfig.Title or "Input"; InputConfig.Content = InputConfig.Content or ""; local savedVal = InputConfig.Flag and flagsRef[InputConfig.Flag]; InputConfig.Default = savedVal or InputConfig.Default or ""; InputConfig.Callback = InputConfig.Callback or function() end
			local InputFrame = Instance.new("Frame"); InputFrame.Name = "Input"; InputFrame.Parent = SectionObject._SectionAdd; InputFrame.LayoutOrder = CountItem;
			InputFrame.Size = UDim2.new(1,0,0,46); InputFrame.BackgroundTransparency = 0.935; InputFrame.BackgroundColor3 = getColorFunc("Secondary", InputFrame, "BackgroundColor3")
			Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0,4)
			local InputTitle = Instance.new("TextLabel", InputFrame); InputTitle.Name = "InputTitle"; InputTitle.Font = Enum.Font.GothamBold; InputTitle.Text = InputConfig.Title; InputTitle.TextColor3 = getColorFunc("Text", InputTitle, "TextColor3"); InputTitle.TextSize = 13; InputTitle.TextXAlignment = Enum.TextXAlignment.Left; InputTitle.TextYAlignment = Enum.TextYAlignment.Top; InputTitle.BackgroundTransparency=1; InputTitle.Position = UDim2.new(0,10,0,10); InputTitle.Size = UDim2.new(1,-100,0,13)
			local InputContent = Instance.new("TextLabel", InputFrame); InputContent.Name = "InputContent"; InputContent.Font = Enum.Font.Gotham; InputContent.Text = InputConfig.Content; InputContent.TextColor3 = getColorFunc("Text", InputContent, "TextColor3"); InputContent.TextSize = 12; InputContent.TextTransparency = 0.4; InputContent.TextXAlignment = Enum.TextXAlignment.Left; InputContent.TextYAlignment = Enum.TextYAlignment.Bottom; InputContent.BackgroundTransparency=1; InputContent.Position = UDim2.new(0,10,0,0); InputContent.Size = UDim2.new(1,-100,1,-10); InputContent.TextWrapped = true
			local TextBox = Instance.new("TextBox", InputFrame); TextBox.Name = "TextBox"; TextBox.Font = Enum.Font.Gotham; TextBox.Text = InputConfig.Default; TextBox.TextColor3 = getColorFunc("Text", TextBox, "TextColor3"); TextBox.TextSize = 12; TextBox.BackgroundColor3 = getColorFunc("Accent", TextBox, "BackgroundColor3"); TextBox.Position = UDim2.new(1,-155,0.5,-12); TextBox.Size = UDim2.new(0,150,0,24); Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0,3); TextBox.ClearTextOnFocus = false
			local currentValue = InputConfig.Default
			TextBox.FocusLost:Connect(function(enterPressed) if enterPressed then currentValue = TextBox.Text; if InputConfig.Flag then saveFileFunc(InputConfig.Flag, currentValue) end; InputConfig.Callback(currentValue) else TextBox.Text = currentValue end end)
			task.delay(0, function() local contentHeight = InputContent.TextBounds.Y; local titleHeight = InputTitle.TextBounds.Y; InputFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15)); SectionObject._UpdateSizeSection() end)
			CountItem = CountItem + 1; return { GetValue = function() return currentValue end, SetValue = function(val) currentValue = val; TextBox.Text = val; if InputConfig.Flag then saveFileFunc(InputConfig.Flag, currentValue) end; InputConfig.Callback(currentValue) end }
		end

		function SectionObject:AddDropdown(DropdownConfig)
			-- Prepare sharedResources table. These are variables from the scope of InternalCreateSection or MakeGui
			local resources = {
				getColorFunc = getColorFunc,
				loadUIAssetFunc = loadUIAssetFunc,
				DropdownFolder = DropdownFolder,
				DropPageLayout = DropPageLayout,
				MoreBlur = MoreBlur,
				DropdownSelect = DropdownSelect,
				circleClickFunc = circleClickFunc,
				mouseRef = mouseRef,
				tweenServiceRef = tweenServiceRef,
				saveFileFunc = saveFileFunc,
				flagsRef = flagsRef, -- This is 'Flags' in MakeGui scope, passed down to InternalCreateSection
				CountItemRef = { Value = CountItem } -- Pass CountItem by reference (as a table field)
			}
			local dropdownApi = _Internal_CreateDropdown(self._SectionAdd, DropdownConfig, resources)
			CountItem = resources.CountItemRef.Value -- Update CountItem from the returned ref

			-- After dropdown is created and CountItem is updated by _Internal_CreateDropdown,
            -- we might need to trigger a size update for the section if the new dropdown changed its total height.
            -- The _Internal_CreateDropdown already does a task.delay for its own frame size.
            -- This call ensures the parent section also re-evaluates its size.
            self._UpdateSizeSection()

			return dropdownApi
		end

		function SectionObject:AddDivider(DividerConfig)
			local DividerConfig = DividerConfig or {}
			DividerConfig.Text = DividerConfig.Text or nil
			local DividerContainer = Instance.new("Frame"); DividerContainer.Name = "Divider"; DividerContainer.Size = UDim2.new(1,0,0,20); DividerContainer.BackgroundTransparency=1; DividerContainer.LayoutOrder=CountItem; DividerContainer.Parent = SectionObject._SectionAdd
			if not DividerConfig.Text or DividerConfig.Text == "" then
				local Line=Instance.new("Frame",DividerContainer); Line.Name="FullLine"; Line.BackgroundColor3=DividerConfig.Color or getColorFunc("Stroke",Line,"BackgroundColor3"); Line.BorderSizePixel=0; Line.AnchorPoint=Vector2.new(0.5,0.5); Line.Position=UDim2.new(0.5,0,0.5,0); Line.Size=UDim2.new(1,-10,0,1)
			else
				DividerContainer.Size = UDim2.new(1,0,0,(DividerConfig.TextSize or 12)+8)
				local ListLayout=Instance.new("UIListLayout",DividerContainer); ListLayout.FillDirection=Enum.FillDirection.Horizontal; ListLayout.VerticalAlignment=Enum.VerticalAlignment.Center; ListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; ListLayout.SortOrder=Enum.SortOrder.LayoutOrder; ListLayout.Padding=UDim.new(0,8)
				local Line1=Instance.new("Frame",DividerContainer); Line1.Name="Line1"; Line1.BackgroundColor3=DividerConfig.Color or getColorFunc("Stroke",Line1,"BackgroundColor3"); Line1.BorderSizePixel=0; Line1.Size=UDim2.new(1,0,0,1); Line1.LayoutOrder=1
				local DividerText=Instance.new("TextLabel",DividerContainer); DividerText.Name="DividerText"; DividerText.Text=DividerConfig.Text; DividerText.TextColor3=DividerConfig.TextColor or getColorFunc("Text",DividerText,"TextColor3"); DividerText.Font=DividerConfig.Font or Enum.Font.GothamBold; DividerText.TextSize=DividerConfig.TextSize or 12; DividerText.BackgroundTransparency=1; DividerText.AutomaticSize=Enum.AutomaticSize.X; DividerText.Size=UDim2.new(0,0,1,0); DividerText.LayoutOrder=2
				local Line2=Instance.new("Frame",DividerContainer); Line2.Name="Line2"; Line2.BackgroundColor3=DividerConfig.Color or getColorFunc("Stroke",Line2,"BackgroundColor3"); Line2.BorderSizePixel=0; Line2.Size=UDim2.new(1,0,0,1); Line2.LayoutOrder=3
			end
			task.defer(function() SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll() end)
			CountItem=CountItem+1; return {}
		end

		return SectionObject
	end

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
	SettingsTab._SettingsPageLayout = SettingsPageLayout -- Store reference to the settings page's UIListLayout for padding

	local settingsSectionCount = 0 -- Local counter for sections within settings

	function SettingsTab:AddSection(Title)
		Title = Title or "Settings Section" -- Default title from InternalCreateSection will apply if nil

		-- Call InternalCreateSection, passing all necessary references
		local newSectionObject = InternalCreateSection(
			self._ScrolLayers,          -- parentScrolLayersInstance (which is SettingsPage for SettingsTab)
			Title,                      -- sectionTitle
			settingsSectionCount,       -- sectionLayoutOrder (using settingsSectionCount)
			GuiConfig,                  -- guiConfigRef
			Flags,                      -- flagsRef
			Themes,                     -- themesRef
			function() return CurrentTheme end, -- currentThemeNameRef (as a function)
			GetColor,                   -- getColorFunc
			SetTheme,                   -- setThemeFunc
			LoadUIAsset,                -- loadUIAssetFunc
			SaveFile,                   -- saveFileFunc
			HttpService,                -- httpServiceRef
			TweenService,               -- tweenServiceRef
			Mouse,                      -- mouseRef
			CircleClick,                -- circleClickFunc
			function(scroller, padding) -- updateParentScrollFunc for SettingsPage
				-- This function updates the CanvasSize of the SettingsPage
				task.defer(function()
					local totalHeight = 0
					for _, child in ipairs(scroller:GetChildren()) do -- scroller is SettingsPage here
						if child:IsA("Frame") and child.Name == "Section" then
							totalHeight = totalHeight + child.Size.Y.Offset + padding.Offset
						end
					end
					if #scroller:GetChildren() > 0 then totalHeight = totalHeight - padding.Offset end
					scroller.CanvasSize = UDim2.new(0,0,0, totalHeight)
				end)
			end,
			function() return self._SettingsPageLayout.Padding end -- parentUIListLayoutPaddingRef (for SettingsPage)
		)

		settingsSectionCount = settingsSectionCount + 1 -- Increment settings-specific section counter
		return newSectionObject -- Return the SectionObject created by InternalCreateSection
	end

	-- Initialize Flags.CustomUserThemes if it doesn't exist
	if not Flags.CustomUserThemes then
		Flags.CustomUserThemes = {}
		SaveFile("CustomUserThemes", Flags.CustomUserThemes) -- Save immediately if created
	end

	-- Helper function to get saved custom theme names
	local function GetSavedThemeNames()
		local names = {}
		if Flags.CustomUserThemes then
			for name, _ in pairs(Flags.CustomUserThemes) do
				table.insert(names, name)
			end
		end
		table.sort(names)
		return names
	end

	-- Helper function to convert Color3 to a savable hex string
	local function ColorToHex(color)
		return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
	end

	-- Helper function to convert hex string back to Color3
	local function HexToColor(hex)
		if type(hex) ~= "string" or not hex:match("^#%x%x%x%x%x%x$") then
			warn("Invalid hex color string:", hex)
			return Color3.new(1,0,0) -- Default to red on error
		end
		local r = tonumber(hex:sub(2,3), 16) / 255
		local g = tonumber(hex:sub(4,5), 16) / 255
		local b = tonumber(hex:sub(6,7), 16) / 255
		return Color3.new(r, g, b)
	end


	-- Section for Preset Management (Task #3)
	local PresetManagementSection = SettingsTab:AddSection("Preset Management")

	-- Dropdown for default themes
	local defaultThemesDropdown = PresetManagementSection:AddDropdown({
		Title = "Default Themes",
		Options = GetThemes(), -- GetThemes() returns a list of default theme names
		Callback = function(selected)
			-- Callback not strictly needed here if apply button is used
		end
	})

	-- Apply Preset Button
	PresetManagementSection:AddButton({
		Title = "Apply Default Theme",
		Content = "Apply the selected default theme",
		Callback = function()
			local selectedThemeNameTable = defaultThemesDropdown:GetValue() -- Returns a table
			if selectedThemeNameTable and #selectedThemeNameTable > 0 then
				local themeName = selectedThemeNameTable[1] -- Get the first selected (should only be one)
				if Themes[themeName] then
					SetTheme(themeName)
					UBHubLib:MakeNotify({ Title = "Theme Applied", Content = "'" .. themeName .. "' applied."})
					-- Potentially refresh color sliders if they are visible and part of another section
				else
					UBHubLib:MakeNotify({ Title = "Error", Content = "Default theme not found: " .. themeName})
				end
			else
				UBHubLib:MakeNotify({ Title = "Info", Content = "No default theme selected."})
			end
		end
	})

	PresetManagementSection:AddDivider({Text = "Custom Preset Settings"}) -- Using AddDivider from the section object

	-- TextBox for naming a custom preset
	local customPresetNameInput = PresetManagementSection:AddInput({
		Title = "Custom Preset Name",
		Content = "Enter a name for your custom preset",
		Default = ""
	})

	-- Save Current Colors Button
	PresetManagementSection:AddButton({
		Title = "Save Current Colors",
		Content = "Save the current color configuration as a new preset",
		Callback = function()
			local presetName = customPresetNameInput:GetValue()
			if not presetName or presetName == "" then
				UBHubLib:MakeNotify({ Title = "Preset Name Required", Content = "Please enter a name for your custom preset."})
				return
			end
			if Flags.CustomUserThemes[presetName] then
				UBHubLib:MakeNotify({ Title = "Preset Exists", Content = "A preset with this name already exists. Choose a different name or delete the existing one."})
				return
			end

			local currentColorsHex = {}
			if Themes[CurrentTheme] then -- Should always be true
				for colorKey, colorValue in pairs(Themes[CurrentTheme]) do
					if typeof(colorValue) == "Color3" then
						currentColorsHex[colorKey] = ColorToHex(colorValue)
					end
				end
				Flags.CustomUserThemes[presetName] = currentColorsHex
				SaveFile("CustomUserThemes", Flags.CustomUserThemes) -- Save all custom themes
				UBHubLib:MakeNotify({ Title = "Preset Saved", Content = "'" .. presetName .. "' has been saved."})
				-- Refresh saved presets dropdowns
				local savedNames = GetSavedThemeNames()
				savedPresetsDropdown:Refresh(savedNames, savedPresetsDropdown:GetValue())
				deletePresetDropdown:Refresh(savedNames, deletePresetDropdown:GetValue())
				customPresetNameInput:SetValue("") -- Clear input
			else
				UBHubLib:MakeNotify({ Title = "Error", Content = "Could not retrieve current theme colors."})
			end
		end
	})

	PresetManagementSection:AddDivider({}) -- Simple line divider

	-- Dropdown for saved presets
	local savedPresetsDropdown = PresetManagementSection:AddDropdown({
		Title = "Saved Custom Presets",
		Options = GetSavedThemeNames(),
		Callback = function(selected)
			-- Callback not strictly needed here
		end
	})

	-- Apply Saved Preset Button
	PresetManagementSection:AddButton({
		Title = "Apply Saved Preset",
		Content = "Apply the selected saved custom preset",
		Callback = function()
			local selectedPresetNameTable = savedPresetsDropdown:GetValue()
			if selectedPresetNameTable and #selectedPresetNameTable > 0 then
				local presetName = selectedPresetNameTable[1]
				if Flags.CustomUserThemes and Flags.CustomUserThemes[presetName] then
					local themeToApply = {}
					for colorKey, hexValue in pairs(Flags.CustomUserThemes[presetName]) do
						themeToApply[colorKey] = HexToColor(hexValue)
					end
					-- Create a temporary theme or update CurrentTheme carefully
					-- For simplicity, let's create a temporary theme name and apply it
					local tempThemeName = "__CUSTOM__" .. presetName
					Themes[tempThemeName] = themeToApply
					SetTheme(tempThemeName)
					-- CurrentTheme will be tempThemeName. If user saves again, it saves current visual colors.
					UBHubLib:MakeNotify({ Title = "Preset Applied", Content = "'" .. presetName .. "' applied."})
					-- After applying, remove the temporary theme entry if we don't want it persisting in Themes table
					-- task.delay(0.1, function() Themes[tempThemeName] = nil end) -- Or handle this more robustly
				else
					UBHubLib:MakeNotify({ Title = "Error", Content = "Saved preset not found: " .. presetName})
				end
			else
				UBHubLib:MakeNotify({ Title = "Info", Content = "No saved preset selected."})
			end
		end
	})

	PresetManagementSection:AddDivider({})

	-- Another "Saved Presets" Dropdown for deletion
	local deletePresetDropdown = PresetManagementSection:AddDropdown({
		Title = "Select Preset to Delete",
		Options = GetSavedThemeNames(),
		Callback = function(selected)
			-- Callback not strictly needed here
		end
	})

	-- Delete Saved Preset Button
	PresetManagementSection:AddButton({
		Title = "Delete Saved Preset",
		Content = "Delete the selected saved custom preset",
		Callback = function()
			local selectedPresetNameTable = deletePresetDropdown:GetValue()
			if selectedPresetNameTable and #selectedPresetNameTable > 0 then
				local presetName = selectedPresetNameTable[1]
				if Flags.CustomUserThemes and Flags.CustomUserThemes[presetName] then
					Flags.CustomUserThemes[presetName] = nil -- Remove from the table
					SaveFile("CustomUserThemes", Flags.CustomUserThemes) -- Save the updated table
					UBHubLib:MakeNotify({ Title = "Preset Deleted", Content = "'" .. presetName .. "' has been deleted."})
					-- Refresh dropdowns
					local savedNames = GetSavedThemeNames()
					savedPresetsDropdown:Refresh(savedNames)
					deletePresetDropdown:Refresh(savedNames)
				else
					UBHubLib:MakeNotify({ Title = "Error", Content = "Preset not found for deletion: " .. presetName})
				end
			else
				UBHubLib:MakeNotify({ Title = "Info", Content = "No preset selected for deletion."})
			end
		end
	})

	-- Section for Customizing Colors (Task #3)
	local CustomizeColorsSection = SettingsTab:AddSection("Customize Colors")

	local function FormatColorNameForDisplay(name)
		local words = {}
		-- Split by uppercase letters, but handle single-word lowercase names too
		if name:match("[a-z][A-Z]") then -- Mixed case with uppercase not at start
			for word in string.gmatch(name, "[%u%l][^%u]*") do -- More general split
				table.insert(words, word:sub(1,1):upper() .. word:sub(2):lower())
			end
		else -- Handles "Text", "Primary", "ThemeHighlight"
			for word in string.gmatch(name, "[A-Z]?[a-z]+") do
				table.insert(words, word:sub(1,1):upper() .. word:sub(2))
			end
			if #words == 0 and #name > 0 then -- Single word like "Text" or if all caps
				table.insert(words, name:sub(1,1):upper() .. name:sub(2):lower())
			end
		end
		return table.concat(words, " ")
	end

	-- Store references to sliders and inputs for two-way binding
	local colorControls = {}

	local function updateColorFromSliders(colorKeyName, component, value)
		local r, g, b
		local currentHex = colorControls[colorKeyName].hexInput:GetValue()
		local currentColor = HexToColor(currentHex) -- Get current color from hex to preserve other components

		r = (component == "R") and value or math.floor(currentColor.R * 255)
		g = (component == "G") and value or math.floor(currentColor.G * 255)
		b = (component == "B") and value or math.floor(currentColor.B * 255)

		local newColor = Color3.fromRGB(r, g, b)
		Themes[CurrentTheme][colorKeyName] = newColor
		SetTheme(CurrentTheme) -- Apply the theme change immediately
		colorControls[colorKeyName].hexInput:SetValue(ColorToHex(newColor))
	end

	local function updateSlidersFromHex(colorKeyName, hexValue)
		if not hexValue or not hexValue:match("^#%x%x%x%x%x%x$") then return end -- Validate hex
		local color = HexToColor(hexValue)
		Themes[CurrentTheme][colorKeyName] = color -- Update the theme table directly
		SetTheme(CurrentTheme) -- Apply the theme change

		colorControls[colorKeyName].rSlider:SetValue(math.floor(color.R * 255))
		colorControls[colorKeyName].gSlider:SetValue(math.floor(color.G * 255))
		colorControls[colorKeyName].bSlider:SetValue(math.floor(color.B * 255))
	end

	-- Function to create individual color editor (divider, hex, R, G, B sliders)
	local function CreateColorEditor(colorKey, initialColor3Value)
		local displayName = FormatColorNameForDisplay(colorKey)
		CustomizeColorsSection:AddDivider({ Text = displayName })

		colorControls[colorKey] = {} -- Initialize storage for this color's controls

		local initialHex = ColorToHex(initialColor3Value)

		-- Hex Input
		local hexInput = CustomizeColorsSection:AddInput({
			Title = displayName .. " Hex",
			Content = "Hexadecimal color code (e.g., #FF0000)",
			Default = initialHex,
			Callback = function(hexValue)
				if hexValue:match("^#%x%x%x%x%x%x$") then
					updateSlidersFromHex(colorKey, hexValue)
				else
					-- Optional: Notify user of invalid hex or revert
					UBHubLib:MakeNotify({Title="Invalid Hex", Content="Please use format #RRGGBB."})
					hexInput:SetValue(ColorToHex(Themes[CurrentTheme][colorKey])) -- Revert to current valid
				end
			end
		})
		colorControls[colorKey].hexInput = hexInput

		-- R Slider
		local rSlider = CustomizeColorsSection:AddSlider({
			Title = "Red", Min = 0, Max = 255, Increment = 1, Default = math.floor(initialColor3Value.R * 255),
			Callback = function(value) updateColorFromSliders(colorKey, "R", value) end
		})
		colorControls[colorKey].rSlider = rSlider

		-- G Slider
		local gSlider = CustomizeColorsSection:AddSlider({
			Title = "Green", Min = 0, Max = 255, Increment = 1, Default = math.floor(initialColor3Value.G * 255),
			Callback = function(value) updateColorFromSliders(colorKey, "G", value) end
		})
		colorControls[colorKey].gSlider = gSlider

		-- B Slider
		local bSlider = CustomizeColorsSection:AddSlider({
			Title = "Blue", Min = 0, Max = 255, Increment = 1, Default = math.floor(initialColor3Value.B * 255),
			Callback = function(value) updateColorFromSliders(colorKey, "B", value) end
		})
		colorControls[colorKey].bSlider = bSlider
	end

	-- Populate the Customize Colors section
	-- Iterate over a base theme to get all color keys, assuming all themes have the same keys.
	-- Use CurrentTheme to get initial values.
	local baseThemeForKeys = Themes[next(Themes)] -- Get the first theme in Themes as a template for keys
	if baseThemeForKeys then
		local sortedColorKeys = {}
		for key, _ in pairs(baseThemeForKeys) do
			if typeof(baseThemeForKeys[key]) == "Color3" then -- Ensure it's a color entry
				table.insert(sortedColorKeys, key)
			end
		end
		table.sort(sortedColorKeys) -- Sort keys for consistent order

		for _, colorKeyName in ipairs(sortedColorKeys) do
			-- Get the initial value from the CurrentTheme, or fallback to the base if not found (shouldn't happen)
			local initialColor = Themes[CurrentTheme][colorKeyName] or baseThemeForKeys[colorKeyName]
			CreateColorEditor(colorKeyName, initialColor)
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
	ScrollTab.Size = UDim2.new(1, 0, 1, -50) -- Adjusted for permanent Info (40px) + Separator (1px) + existing margin/padding difference
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = LayersTab

	UIListLayout.Padding = UDim.new(0, 3)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = ScrollTab

	-- Separator Line (Task #3)
	local SeparatorLine = Instance.new("Frame")
	SeparatorLine.Name = "SeparatorLine"
	SeparatorLine.Parent = LayersTab
	SeparatorLine.BackgroundColor3 = GetColor("Stroke")
	SeparatorLine.BorderSizePixel = 0
	SeparatorLine.Size = UDim2.new(1, 0, 0, 1)
	SeparatorLine.Position = UDim2.new(0, 0, 1, -41) -- Positioned above the 40px Info frame

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
	Info.Visible = true -- Made permanent as per Task #3
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
	-- NamePlayerButton.Text is now directly set on the TextLabel part of Info, which is now static "Customize"
	-- LogoPlayer.Image is set above.
	-- The NamePlayerButton itself is being repurposed or replaced by an invisible button.
	-- For clarity, I will rename NamePlayerButton to CustomizeLabel and then add the new invisible button.
	NamePlayerButton.Name = "CustomizeLabel" -- Renaming for clarity
	NamePlayerButton.Text = "Customize" -- Ensure this is set
	LogoPlayer.Image = "rbxassetid://126800841735072" -- Ensure this is set

	-- Task #3: Create an invisible button for the "Customize" tab functionality
	local CustomizeButton = Instance.new("TextButton")
	CustomizeButton.Name = "CustomizeButton"
	CustomizeButton.Parent = Info
	CustomizeButton.Size = UDim2.new(1, 0, 1, 0) -- Cover entire Info frame
	CustomizeButton.Text = ""
	CustomizeButton.BackgroundTransparency = 1
	CustomizeButton.ZIndex = Info.ZIndex + 1 -- Ensure it's on top to be clickable

	local isSettingsViewActive = false
	local lastSelectedTabName = "" -- To store the name of the last active tab
	local lastSelectedTabFrame = nil -- To store the actual tab frame for highlight management

	-- Function to remove highlight from all scrollable tabs
	local function ClearScrollTabHighlights()
		if ScrollTab then
			for _, child in ipairs(ScrollTab:GetChildren()) do
				if child:IsA("Frame") and child.Name == "Tab" then
					child.BackgroundTransparency = 0.9990000128746033 -- Default non-highlight transparency
					local chooseFrame = child:FindFirstChild("ChooseFrame")
					if chooseFrame then
						chooseFrame.Visible = false
					end
				end
			end
		end
	end

	-- Function to remove highlight from Customize button (Info frame)
	local function ClearCustomizeButtonHighlight()
		Info.BackgroundTransparency = 0.95 -- Default non-highlight transparency
		-- If we add a specific highlight element to Info later, we'll control that here.
	end

	CustomizeButton.MouseButton1Click:Connect(function()
		CircleClick(CustomizeButton, Mouse.X, Mouse.Y) -- Existing click effect
		isSettingsViewActive = not isSettingsViewActive

		if isSettingsViewActive then
			-- Store last active tab name if Layers is currently visible and a tab is selected
			if Layers.Visible and LayersPageLayout.CurrentPage then
				lastSelectedTabName = LayersPageLayout.CurrentPage:FindFirstChild("TabConfig_Name") and LayersPageLayout.CurrentPage.TabConfig_Name.Value or "Unknown Tab"
				-- Also store the frame if possible, though this might be tricky if it's not directly the 'Tab' frame
			elseif Layers.Visible then -- Fallback if no specific tab was current but Layers was visible
				local firstTab = ScrollTab:FindFirstChild("Tab")
				if firstTab and firstTab:FindFirstChild("TabName") then
					lastSelectedTabName = firstTab.TabName.Text
				else
					lastSelectedTabName = GuiConfig.NameHub -- Default if no tabs
				end
			end

			Layers.Visible = false
			SettingsPage.Visible = true
			NameTab.Text = "Settings"
			ClearScrollTabHighlights()
			-- Highlight Customize button (Info frame)
			Info.BackgroundTransparency = 0.85 -- Example highlight transparency
		else
			SettingsPage.Visible = false
			Layers.Visible = true
			NameTab.Text = lastSelectedTabName
			ClearCustomizeButtonHighlight()
			-- Re-highlight the last selected scrollable tab if one was active
			if lastSelectedTabFrame and lastSelectedTabFrame.Parent then -- Check if still valid
				lastSelectedTabFrame.BackgroundTransparency = 0.9200000166893005 -- Highlighted transparency
				local chooseFrame = lastSelectedTabFrame:FindFirstChild("ChooseFrame")
				if chooseFrame then
					chooseFrame.Visible = true
				end
			elseif LayersPageLayout.CurrentPage then -- Fallback to CurrentPage if lastSelectedTabFrame wasn't set/valid
				local currentTabButtonParent = nil
				-- We need to find the "Tab" frame associated with LayersPageLayout.CurrentPage
				for _, tabInstance in ipairs(ScrollTab:GetChildren()) do
					if tabInstance.Name == "Tab" and tabInstance.LayoutOrder == LayersPageLayout.CurrentPage.LayoutOrder then
						currentTabButtonParent = tabInstance
						break
					end
				end
				if currentTabButtonParent then
					currentTabButtonParent.BackgroundTransparency = 0.9200000166893005
					local cf = currentTabButtonParent:FindFirstChild("ChooseFrame")
					if cf then cf.Visible = true end
				end
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
	local CountDropdown = 0 -- Moved here from CreateTab
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
				ClearCustomizeButtonHighlight() -- Task #3: Clear customize highlight
				for _, TabFrameScroll in ScrollTab:GetChildren() do -- Renamed TabFrame to TabFrameScroll for clarity
					if TabFrameScroll.Name == "Tab" then
						TweenService:Create(TabFrameScroll,TweenInfo.new(0.2, Enum.EasingStyle.Linear),{BackgroundTransparency = 0.9990000128746033}):Play()
						local cf = TabFrameScroll:FindFirstChild("ChooseFrame")
						if cf then cf.Visible = false end -- Hide other choose frames
					end
				end
				TweenService:Create(Tab, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.92}):Play() -- Highlight this tab
				-- FrameChoose is the ChooseFrame of the *previously* selected tab. We need to position the *current* tab's ChooseFrame.
				local currentChooseFrame = Tab:FindFirstChild("ChooseFrame")
				if not currentChooseFrame then -- Create if it doesn't exist (should for all but first initially)
					currentChooseFrame = Instance.new("Frame")
					currentChooseFrame.Name = "ChooseFrame"
					currentChooseFrame.BackgroundColor3 = GetColor("ThemeHighlight",currentChooseFrame,"BackgroundColor3")
					currentChooseFrame.BorderSizePixel = 0
					currentChooseFrame.Position = UDim2.new(0, 2, 0, 9) -- Default position
					currentChooseFrame.Size = UDim2.new(0, 1, 0, 12) -- Default size
					currentChooseFrame.Parent = Tab
					local stroke = Instance.new("UIStroke", currentChooseFrame)
					stroke.Color = GetColor("Secondary",stroke,"Color")
					stroke.Thickness = 1.6
					Instance.new("UICorner", currentChooseFrame)
				end
				currentChooseFrame.Visible = true -- Make sure it's visible
				-- The old FrameChoose (previous tab's selector) should be hidden by the loop above or explicitly
				if FrameChoose and FrameChoose.Parent ~= Tab then FrameChoose.Visible = false end


				LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
				NameTab.Text = TabConfig.Name
				lastSelectedTabName = TabConfig.Name -- Update for when switching back from settings
				lastSelectedTabFrame = Tab -- Store this tab frame
				-- TweenService:Create(FrameChoose,TweenInfo.new(0.2, Enum.EasingStyle.Linear),{Size = UDim2.new(0, 1, 0, 20)}):Play() -- This was for the old choose frame, new one handles its own
			elseif Tab.LayoutOrder == LayersPageLayout.CurrentPage.LayoutOrder and SettingsPage.Visible then
				-- This case handles clicking the *already active* tab when settings are open, to switch back.
				isSettingsViewActive = false -- Deactivate settings view
				SettingsPage.Visible = false
				Layers.Visible = true
				NameTab.Text = TabConfig.Name -- Set NameTab to the current tab's name
				ClearCustomizeButtonHighlight()
				-- Ensure this tab is highlighted
				Tab.BackgroundTransparency = 0.92
				local cf = Tab:FindFirstChild("ChooseFrame")
				if cf then cf.Visible = true end
			end
		end)
		--// Section
		local CountSection = 0 -- Keep this counter for layout order if needed globally for sections

		-- Define Tab object structure and its AddSection method
		local Tab = {}
		Tab._ScrolLayers = ScrolLayers -- Store reference to the tab's content scroller
		Tab._UIListLayout = UIListLayout1 -- Store reference to the tab's content UIListLayout for padding

		function Tab:AddSection(Title)
			Title = Title or "Section" -- Default title from InternalCreateSection will apply if nil

			-- Call InternalCreateSection, passing all necessary references
			-- Note: CountSection is managed globally for now. If sections need to be ordered
			-- per tab independently, this counter would need to be part of the Tab object.
			local newSectionObject = InternalCreateSection(
				self._ScrolLayers,          -- parentScrolLayersInstance
				Title,                      -- sectionTitle
				CountSection,               -- sectionLayoutOrder
				GuiConfig,                  -- guiConfigRef
				Flags,                      -- flagsRef
				Themes,                     -- themesRef
				function() return CurrentTheme end, -- currentThemeNameRef (as a function)
				GetColor,                   -- getColorFunc
				SetTheme,                   -- setThemeFunc
				LoadUIAsset,                -- loadUIAssetFunc
				SaveFile,                   -- saveFileFunc
				HttpService,                -- httpServiceRef
				TweenService,               -- tweenServiceRef
				Mouse,                      -- mouseRef
				CircleClick,                -- circleClickFunc
				function(scroller, padding) -- updateParentScrollFunc
					-- This is the function that was originally UpdateSizeScroll_Section
					-- It updates the CanvasSize of the parent scroller (self._ScrolLayers for regular tabs)
					task.defer(function()
						local totalHeight = 0
						for _, child in ipairs(scroller:GetChildren()) do
							if child:IsA("Frame") and child.Name == "Section" then
								totalHeight = totalHeight + child.Size.Y.Offset + padding.Offset
							end
						end
						if #scroller:GetChildren() > 0 then totalHeight = totalHeight - padding.Offset end
						scroller.CanvasSize = UDim2.new(0,0,0, totalHeight)
					end)
				end,
				function() return self._UIListLayout.Padding end -- parentUIListLayoutPaddingRef (as a function returning the UDim value)
			)

			CountSection = CountSection + 1 -- Increment global section counter
			return newSectionObject -- Return the SectionObject created by InternalCreateSection
		end

		CountTab = CountTab + 1
		return Tab
	end
	return UIInstance
end
return UBHubLib
