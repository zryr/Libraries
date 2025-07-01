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
	local CountTab = 0
	local CountDropdown = 0 -- This will be part of dependencies, potentially as a table { Value = 0 } if modified by reference

	-- Master Dependencies Table
	local dependencies = {
		GetColor = GetColor,
		SetTheme = SetTheme,
		LoadUIAsset = LoadUIAsset,
		SaveFile = SaveFile, -- Will be defined later and added
		CircleClick = CircleClick,
		MakeNotify = UBHubLib.MakeNotify, -- Assuming UBHubLib is accessible here or pass UBHubLib itself
		Flags = Flags,
		CurrentThemeRef = function() return CurrentTheme end, -- Use a function to get current theme reactively
		Themes = Themes,
		TweenService = TweenService,
		HttpService = HttpService,
		Mouse = Mouse,
		UserInputService = UserInputService,
		GuiConfig = GuiConfig,
		UIInstance = UIInstance, -- For rare cases where elements might need to create other top-level things via UIInstance
		CountDropdownRef = { Value = CountDropdown } -- Pass as a table to modify by reference
		-- DropdownFolder, DropPageLayout, MoreBlur, DropdownSelect will be added later
	}

	-- Local helper function to create dropdown UI elements
	local function Helper_CreateDropdownElements(parentFrameForItems, DropdownConfig, dependencies)
		local DropdownConfig = DropdownConfig or {}
		DropdownConfig.Title = DropdownConfig.Title or "No Title"
		DropdownConfig.Content = DropdownConfig.Content or ""
		DropdownConfig.Multi = DropdownConfig.Multi or false
		DropdownConfig.Options = DropdownConfig.Options or {}
		local savedValue = DropdownConfig.Flag and dependencies.Flags[DropdownConfig.Flag]
		if DropdownConfig.Multi then
			DropdownConfig.Default = (savedValue and type(savedValue) == "table") and savedValue or (type(DropdownConfig.Default) == "table" and DropdownConfig.Default or {})
		else
			DropdownConfig.Default = savedValue or DropdownConfig.Default
		end
		DropdownConfig.Callback = DropdownConfig.Callback or function() end

		local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options}

		local currentDropdownID = dependencies.CountDropdownRef.Value
		dependencies.CountDropdownRef.Value = dependencies.CountDropdownRef.Value + 1

		local DropdownFrame = Instance.new("Frame")
		DropdownFrame.Name = "Dropdown"
		DropdownFrame.Parent = parentFrameForItems
		DropdownFrame.LayoutOrder = currentDropdownID -- Use the unique ID for layout order
		DropdownFrame.Size = UDim2.new(1,0,0,46)
		DropdownFrame.BackgroundTransparency = 0.935
		DropdownFrame.BackgroundColor3 = dependencies.GetColor("Secondary", DropdownFrame, "BackgroundColor3")
		Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0,4)

		local DropdownTitle = Instance.new("TextLabel", DropdownFrame)
		DropdownTitle.Name = "DropdownTitle"; DropdownTitle.Font = Enum.Font.GothamBold; DropdownTitle.Text = DropdownConfig.Title
		DropdownTitle.TextColor3 = dependencies.GetColor("Text", DropdownTitle, "TextColor3"); DropdownTitle.TextSize = 13
		DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left; DropdownTitle.TextYAlignment = Enum.TextYAlignment.Top
		DropdownTitle.BackgroundTransparency=1; DropdownTitle.Position = UDim2.new(0,10,0,10); DropdownTitle.Size = UDim2.new(1,-180,0,13)

		local DropdownContent = Instance.new("TextLabel", DropdownFrame)
		DropdownContent.Name = "DropdownContent"; DropdownContent.Font = Enum.Font.Gotham; DropdownContent.Text = DropdownConfig.Content
		DropdownContent.TextColor3 = dependencies.GetColor("Text", DropdownContent, "TextColor3"); DropdownContent.TextSize = 12
		DropdownContent.TextTransparency = 0.4; DropdownContent.TextWrapped = true; DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
		DropdownContent.TextYAlignment = Enum.TextYAlignment.Bottom; DropdownContent.BackgroundTransparency=1
		DropdownContent.Position = UDim2.new(0,10,0,0); DropdownContent.Size = UDim2.new(1,-180,1,-10)

		local SelectOptionsFrame = Instance.new("Frame", DropdownFrame)
		SelectOptionsFrame.Name = "SelectOptionsFrame"; SelectOptionsFrame.AnchorPoint = Vector2.new(1,0.5)
		SelectOptionsFrame.BackgroundColor3 = dependencies.GetColor("Primary", SelectOptionsFrame, "BackgroundColor3")
		SelectOptionsFrame.BackgroundTransparency = 0.95; SelectOptionsFrame.BorderSizePixel = 0
		SelectOptionsFrame.Position = UDim2.new(1,-7,0.5,0); SelectOptionsFrame.Size = UDim2.new(0,148,0,30)
		Instance.new("UICorner",SelectOptionsFrame).CornerRadius = UDim.new(0,4)

		local OptionSelecting = Instance.new("TextLabel",SelectOptionsFrame)
		OptionSelecting.Name = "OptionSelecting"; OptionSelecting.Font = Enum.Font.Gotham
		OptionSelecting.TextColor3 = dependencies.GetColor("Text", OptionSelecting, "TextColor3"); OptionSelecting.TextSize = 12
		OptionSelecting.TextTransparency = 0.4; OptionSelecting.TextWrapped = true; OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
		OptionSelecting.AnchorPoint = Vector2.new(0,0.5); OptionSelecting.BackgroundTransparency = 1
		OptionSelecting.Position = UDim2.new(0,5,0.5,0); OptionSelecting.Size = UDim2.new(1,-30,1,-8)

		local OptionImg = Instance.new("ImageLabel",SelectOptionsFrame)
		OptionImg.Name = "OptionImg"; OptionImg.Image = dependencies.LoadUIAsset("rbxassetid://16851841101", "DropdownArrow_Helper")
		OptionImg.ImageColor3 = dependencies.GetColor("Text", OptionImg, "ImageColor3"); OptionImg.AnchorPoint = Vector2.new(1,0.5)
		OptionImg.BackgroundTransparency=1; OptionImg.Position = UDim2.new(1,0,0.5,0); OptionImg.Size = UDim2.new(0,25,0,25)

		local DropdownButton = Instance.new("TextButton", DropdownFrame)
		DropdownButton.Name = "DropdownButton"; DropdownButton.Text = ""; DropdownButton.Size = UDim2.new(1,0,1,0); DropdownButton.BackgroundTransparency = 1

		SelectOptionsFrame.LayoutOrder = currentDropdownID -- This seems fine if it's for ordering elements *within* the dropdown frame itself.

		local DropdownContainer = dependencies.DropdownFolder:FindFirstChild("DropdownContainer_"..tostring(currentDropdownID))
		if not DropdownContainer then
			DropdownContainer = Instance.new("Frame", dependencies.DropdownFolder); DropdownContainer.Name = "DropdownContainer_"..tostring(currentDropdownID)
			DropdownContainer.BackgroundTransparency = 1; DropdownContainer.Size = UDim2.new(1,0,1,0)
			local SearchBar = Instance.new("TextBox", DropdownContainer); SearchBar.Name = "SearchBar_Dropdown"
			SearchBar.Font = Enum.Font.GothamBold; SearchBar.PlaceholderText = "🔎 Search"
			SearchBar.PlaceholderColor3 = dependencies.GetColor("Text", SearchBar, "PlaceholderColor3"); SearchBar.Text = ""
			SearchBar.TextColor3 = dependencies.GetColor("Text", SearchBar, "TextColor3"); SearchBar.TextSize = 12
			SearchBar.BackgroundColor3 = dependencies.GetColor("Secondary", SearchBar, "BackgroundColor3"); SearchBar.BackgroundTransparency = 0
			SearchBar.BorderColor3 = dependencies.GetColor("Stroke", SearchBar, "BorderColor3"); SearchBar.BorderSizePixel = 1
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
		local UIListLayout_Scroll_Instance = ScrollSelect_Instance and ScrollSelect_Instance:FindFirstChildOfClass("UIListLayout")

		DropdownButton.Activated:Connect(function()
			dependencies.CircleClick(DropdownButton, dependencies.Mouse.X, dependencies.Mouse.Y)
			if not dependencies.MoreBlur.Visible then
				dependencies.MoreBlur.Visible = true
				dependencies.DropPageLayout:JumpTo(DropdownContainer)
				dependencies.TweenService:Create(dependencies.MoreBlur, TweenInfo.new(0.2),{BackgroundTransparency = 0.7}):Play()
				dependencies.TweenService:Create(dependencies.DropdownSelect, TweenInfo.new(0.2),{Position = UDim2.new(1,-11,0.5,0)}):Play()
			end
		end)

		local dropCountLocal = 0 -- Local counter for options within this specific dropdown
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
			if not ScrollSelect_Instance or not UIListLayout_Scroll_Instance then return end
			oN = oN or "Option"
			local oF = Instance.new("Frame",ScrollSelect_Instance); oF.Name="Option"; oF.Size=UDim2.new(1,0,0,30)
			oF.BackgroundTransparency=0.97; oF.BackgroundColor3=dependencies.GetColor("Secondary",oF,"BackgroundColor3")
			Instance.new("UICorner",oF).CornerRadius=UDim.new(0,3)
			local oB=Instance.new("TextButton",oF); oB.Name="OptionButton"; oB.Text=""; oB.Size=UDim2.new(1,0,1,0); oB.BackgroundTransparency=1
			local oT=Instance.new("TextLabel",oF); oT.Name="OptionText"; oT.Font=Enum.Font.Gotham; oT.Text=oN
			oT.TextColor3=dependencies.GetColor("Text",oT,"TextColor3"); oT.TextSize=13; oT.TextXAlignment=Enum.TextXAlignment.Left
			oT.BackgroundTransparency=1; oT.Position=UDim2.new(0,8,0,0); oT.Size=UDim2.new(1,-16,1,0)
			local cF=Instance.new("Frame",oF); cF.Name="ChooseFrame"; cF.AnchorPoint=Vector2.new(0,0.5)
			cF.BackgroundColor3=dependencies.GetColor("ThemeHighlight",cF,"BackgroundColor3"); cF.BorderSizePixel=0
			cF.Position=UDim2.new(0,2,0.5,0); cF.Size=UDim2.new(0,0,0,0); Instance.new("UICorner",cF).CornerRadius=UDim.new(0,3)
			local cS=Instance.new("UIStroke",cF); cS.Color=dependencies.GetColor("Secondary",cS,"Color"); cS.Thickness=1.6; cS.Transparency=1
			dropCountLocal=dropCountLocal+1; oF.LayoutOrder=dropCountLocal

			oB.Activated:Connect(function()
				dependencies.CircleClick(oB, dependencies.Mouse.X, dependencies.Mouse.Y)
				if DropdownConfig.Multi then
					local fI=table.find(DropdownFunc.Value,oN)
					if fI then table.remove(DropdownFunc.Value,fI) else table.insert(DropdownFunc.Value,oN) end
				else DropdownFunc.Value={oN} end
				DropdownFunc:Set(DropdownFunc.Value)
				if DropdownConfig.Flag then dependencies.SaveFile(DropdownConfig.Flag, DropdownFunc.Value) end
			end)
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
					dependencies.TweenService:Create(d_S.ChooseFrame,tII,{Size=s_S}):Play()
					dependencies.TweenService:Create(d_S.ChooseFrame.UIStroke,tII,{Transparency=tr_S}):Play()
					dependencies.TweenService:Create(d_S,tII,{BackgroundTransparency=bT_S}):Play()
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
			task.defer(function() if ScrollSelect_Instance and UIListLayout_Scroll_Instance then ScrollSelect_Instance.CanvasSize = UDim2.new(0,0,0, UIListLayout_Scroll_Instance.AbsoluteContentSize.Y) end end)
		end

		DropdownFunc:Refresh(DropdownConfig.Options, DropdownConfig.Default)
		task.delay(0, function()
			local contentHeight = DropdownContent.TextBounds.Y; local titleHeight = DropdownTitle.TextBounds.Y
			DropdownFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15))
			-- No need to call parent's UpdateSectionSize from here as this helper creates a self-contained element.
			-- The parent (SectionObject) will call its own UpdateSectionSize when this dropdown (as an item) is added.
		end)
		-- The 'CountItemRef' from dependencies was for items within a Section, not for this helper's internal use.
		-- The DropdownFrame itself has its LayoutOrder set by currentDropdownID.
		return DropdownFunc
	end

	local function SaveFile(Name, Value)
		if not (writefile and dependencies.GuiConfig and dependencies.GuiConfig.SaveFolder) then -- Used dependencies
			return false
		end
		local valueToSave = Value
		if type(Value) == "table" and not (Value[1] and not next(Value)) then
			valueToSave = nil
		elseif type(Value) == "table" and #Value == 1 then
			valueToSave = Value[1]
		end
		dependencies.Flags[Name] = valueToSave -- Used dependencies
		local success, err = pcall(function()
			local path = dependencies.GuiConfig.SaveFolder -- Used dependencies
			local encoded = dependencies.HttpService:JSONEncode(dependencies.Flags) -- Used dependencies
			writefile(path, encoded)
		end)
		if not success then
			warn("Save failed:", err)
			return false
		end
		return true
	end
	dependencies.SaveFile = SaveFile -- Add to dependencies table now that it's defined

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

	LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad

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
	ScrollTab.Size = UDim2.new(1, 0, 1, -95) -- Adjusted for permanent Info (40px) + Separator (1px) + SettingsButton (40px) + Separator (1px) + Margin
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = LayersTab

	UIListLayout.Padding = UDim.new(0, 3)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = ScrollTab

	-- Separator Line above Player Info
	local SeparatorLinePlayerInfo = Instance.new("Frame")
	SeparatorLinePlayerInfo.Name = "SeparatorLinePlayerInfo"
	SeparatorLinePlayerInfo.Parent = LayersTab
	SeparatorLinePlayerInfo.BackgroundColor3 = GetColor("Stroke", SeparatorLinePlayerInfo, "BackgroundColor3")
	SeparatorLinePlayerInfo.BorderSizePixel = 0
	SeparatorLinePlayerInfo.Size = UDim2.new(1, 0, 0, 1)
	SeparatorLinePlayerInfo.LayoutOrder = 1 -- Ensure it's after ScrollTab in layout if using a UIListLayout for LayersTab children

	-- Player Info Frame (original, now static)
	local Info = Instance.new("Frame");
	local UICornerInfo = Instance.new("UICorner");
	local LogoPlayerFrame = Instance.new("Frame")
	local UICornerLogoFrame = Instance.new("UICorner");
	local LogoPlayer = Instance.new("ImageLabel");
	local UICornerLogoPlayer = Instance.new("UICorner");
	local NamePlayerLabel = Instance.new("TextLabel"); -- Changed from TextButton

	Info.AnchorPoint = Vector2.new(0, 0) -- Adjusted for LayoutOrder
	Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Info.BackgroundTransparency = 0.95
	Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Info.BorderSizePixel = 0
	Info.Size = UDim2.new(1, 0, 0, 40)
	Info.Name = "Info"
	Info.Parent = LayersTab
	Info.LayoutOrder = 2

	UICornerInfo.CornerRadius = UDim.new(0, 5)
	UICornerInfo.Parent = Info

	LogoPlayerFrame.AnchorPoint = Vector2.new(0, 0.5)
	LogoPlayerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoPlayerFrame.BackgroundTransparency = 0.95
	LogoPlayerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoPlayerFrame.BorderSizePixel = 0
	LogoPlayerFrame.Position = UDim2.new(0, 5, 0.5, 0)
	LogoPlayerFrame.Size = UDim2.new(0, 30, 0, 30)
	LogoPlayerFrame.Name = "LogoPlayerFrame"
	LogoPlayerFrame.Parent = Info

	UICornerLogoFrame.CornerRadius = UDim.new(0, 1000)
	UICornerLogoFrame.Parent = LogoPlayerFrame

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

	UICornerLogoPlayer.CornerRadius = UDim.new(0, 1000)
	UICornerLogoPlayer.Parent = LogoPlayer

	NamePlayerLabel.Name = "NamePlayerLabel"
	NamePlayerLabel.Text = GuiConfig["Name Player"]
	NamePlayerLabel.Font = Enum.Font.GothamBold
	NamePlayerLabel.TextColor3 = GetColor("Text", NamePlayerLabel, "TextColor3")
	NamePlayerLabel.TextSize = 12
	NamePlayerLabel.TextWrapped = true
	NamePlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
	NamePlayerLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NamePlayerLabel.BackgroundTransparency = 1
	NamePlayerLabel.BorderSizePixel = 0
	NamePlayerLabel.Position = UDim2.new(0, 40, 0, 0)
	NamePlayerLabel.Size = UDim2.new(1, -45, 1, 0)
	NamePlayerLabel.Parent = Info

	-- Separator Line below Player Info / above Settings Tab (created by CreateTab)
	local SettingsSeparator = Instance.new("Frame") -- Renamed for clarity from SeparatorLineSettings
	SettingsSeparator.Name = "SettingsSeparator"
	SettingsSeparator.Parent = LayersTab
	SettingsSeparator.BackgroundColor3 = GetColor("Stroke", SettingsSeparator, "BackgroundColor3")
	SettingsSeparator.BorderSizePixel = 0
	SettingsSeparator.Size = UDim2.new(1, 0, 0, 1)
	SettingsSeparator.LayoutOrder = 3 -- This will be between Info and the Settings Tab button

	-- The old manual SettingsTabButton and its children are removed by not re-adding them here.
	-- UIInstance:CreateTab({IsSettingsTab=true}) will create the new one.

	local function ClearAllTabHighlights()
		-- De-highlight normal tabs in ScrollTab
		for _, child in ipairs(ScrollTab:GetChildren()) do
			if child:IsA("Frame") and child.Name:match("_TabButton$") then
				TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.9990000128746033}):Play()
				local cf = child:FindFirstChild("ChooseFrame")
				if cf then cf.Visible = false end
			end
		end
		-- De-highlight the static Settings Tab (which is also a 'Tab' frame but parented to LayersTab)
		local settingsTabButtonInstance = LayersTab:FindFirstChild("Settings_TabButton") -- Find by specific name
		if settingsTabButtonInstance then
			TweenService:Create(settingsTabButtonInstance, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.9990000128746033}):Play() -- Standard inactive transparency
			local cf = settingsTabButtonInstance:FindFirstChild("ChooseFrame")
			if cf then cf.Visible = false end
		end
	end

	-- Add UIListLayout to LayersTab to manage ScrollTab, Separators, Info, and the future SettingsTabButton
	local LayersTabMainLayout = LayersTab:FindFirstChildOfClass("UIListLayout")
	if not LayersTabMainLayout then
		LayersTabMainLayout = Instance.new("UIListLayout", LayersTab)
		LayersTabMainLayout.SortOrder = Enum.SortOrder.LayoutOrder
		LayersTabMainLayout.Padding = UDim.new(0,0)
	end
	-- Ensure ScrollTab is ordered first by the layout
	ScrollTab.LayoutOrder = 0

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

	-- The old "Info" frame that was at the bottom of LayersTab (previously used for settings access)
	-- has been removed. Player info is now static at the top, and settings access is via the
	-- "Settings" tab created by UIInstance:CreateTab.

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

	-- Add late-initialized UI instances to dependencies table
	dependencies.DropdownFolder = DropdownFolder
	dependencies.DropPageLayout = DropPageLayout
	dependencies.MoreBlur = MoreBlur
	dependencies.DropdownSelect = DropdownSelect
	dependencies.LayersPageLayout = LayersPageLayout -- Added LayersPageLayout
	dependencies.NameTab = NameTab -- Added NameTab for text updates
	dependencies.ScrollTab = ScrollTab -- Added ScrollTab for highlight management
	dependencies.LayersTab = LayersTab -- Added LayersTab for finding Settings_TabButton
	dependencies.UBHubLib = UBHubLib -- Added UBHubLib for MakeNotify

	-- =================================================================
	-- BLOCK 2: Element Helper Functions
	-- These are placed before UIInstance:CreateTab
	-- =================================================================
	local function Helper_CreateButton(parent, config, dependencies, updateVisualsCallback)
		local config = config or {}
		config.Title = config.Title or "Button"
		config.Content = config.Content or ""
		config.Icon = config.Icon -- Keep as nil if not provided, let LoadUIAsset handle defaults if necessary
		config.Callback = config.Callback or function() end

		local ButtonFrame = Instance.new("Frame")
		ButtonFrame.Name = "ButtonElement"
		ButtonFrame.Parent = parent
		ButtonFrame.Size = UDim2.new(1,0,0,46) -- Default size, can be adjusted
		ButtonFrame.BackgroundTransparency = 0.935
		ButtonFrame.BackgroundColor3 = dependencies.GetColor("Secondary", ButtonFrame, "BackgroundColor3")
		Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0,4)
		-- LayoutOrder will be handled by the parent's UIListLayout

		local ButtonTitle = Instance.new("TextLabel", ButtonFrame)
		ButtonTitle.Name = "ButtonTitle"
		ButtonTitle.Font = Enum.Font.GothamBold
		ButtonTitle.Text = config.Title
		ButtonTitle.TextColor3 = dependencies.GetColor("Text", ButtonTitle, "TextColor3")
		ButtonTitle.TextSize = 13
		ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
		ButtonTitle.TextYAlignment = Enum.TextYAlignment.Top
		ButtonTitle.BackgroundTransparency=1
		ButtonTitle.Position = UDim2.new(0,10,0,10)
		ButtonTitle.Size = UDim2.new(1,- (config.Icon and 40 or 15) ,0,13) -- Adjust size if icon is present

		local ButtonContent = Instance.new("TextLabel", ButtonFrame)
		ButtonContent.Name = "ButtonContent"
		ButtonContent.Font = Enum.Font.Gotham
		ButtonContent.Text = config.Content
		ButtonContent.TextColor3 = dependencies.GetColor("Text", ButtonContent, "TextColor3")
		ButtonContent.TextSize = 12
		ButtonContent.TextTransparency = 0.4
		ButtonContent.TextWrapped = true
		ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
		ButtonContent.TextYAlignment = Enum.TextYAlignment.Bottom
		ButtonContent.BackgroundTransparency=1
		ButtonContent.Position = UDim2.new(0,10,0,0)
		ButtonContent.Size = UDim2.new(1,- (config.Icon and 40 or 15),1,-10)

		local ActualButton = Instance.new("TextButton", ButtonFrame)
		ActualButton.Name = "ActualButton"
		ActualButton.Text = ""
		ActualButton.Size = UDim2.new(1,0,1,0)
		ActualButton.BackgroundTransparency = 1
		ActualButton.Activated:Connect(function()
			dependencies.CircleClick(ActualButton, dependencies.Mouse.X, dependencies.Mouse.Y)
			if config.Callback then config.Callback() end
		end)

		if config.Icon then
			local IconFrame = Instance.new("Frame", ButtonFrame)
			IconFrame.Name = "IconFrame"
			IconFrame.AnchorPoint = Vector2.new(1,0.5)
			IconFrame.BackgroundTransparency = 1
			IconFrame.Position = UDim2.new(1,-10,0.5,0)
			IconFrame.Size = UDim2.new(0,25,0,25)
			local IconImage = Instance.new("ImageLabel", IconFrame)
			IconImage.Name = "ButtonIcon"
			IconImage.Image = dependencies.LoadUIAsset(config.Icon, "ButtonIcon_"..config.Title)
			IconImage.AnchorPoint = Vector2.new(0.5,0.5)
			IconImage.BackgroundTransparency = 1
			IconImage.Position = UDim2.new(0.5,0,0.5,0)
			IconImage.Size = UDim2.new(1,0,1,0)
		end

		task.defer(updateVisualsCallback)
		return {} -- Return an empty API table for now
	end

	local function Helper_CreateSlider(parent, config, dependencies, updateVisualsCallback)
		local config = config or {}
		config.Title = config.Title or "Slider"
		config.Min = config.Min or 0
		config.Max = config.Max or 100
		config.Increment = config.Increment or 1
		local savedValue = config.Flag and dependencies.Flags[config.Flag]
		config.Default = tonumber(savedValue or config.Default or config.Min)
		config.Callback = config.Callback or function() end

		local SliderFrame = Instance.new("Frame")
		SliderFrame.Name = "SliderElement"
		SliderFrame.Parent = parent
		SliderFrame.Size = UDim2.new(1,0,0,55)
		SliderFrame.BackgroundTransparency = 0.935
		SliderFrame.BackgroundColor3 = dependencies.GetColor("Secondary", SliderFrame, "BackgroundColor3")
		Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0,4)

		local SliderTitle = Instance.new("TextLabel", SliderFrame)
		SliderTitle.Name = "SliderTitle"; SliderTitle.Font = Enum.Font.GothamBold; SliderTitle.Text = config.Title
		SliderTitle.TextColor3 = dependencies.GetColor("Text", SliderTitle, "TextColor3"); SliderTitle.TextSize = 13
		SliderTitle.TextXAlignment = Enum.TextXAlignment.Left; SliderTitle.TextYAlignment = Enum.TextYAlignment.Top
		SliderTitle.BackgroundTransparency=1; SliderTitle.Position = UDim2.new(0,10,0,10); SliderTitle.Size = UDim2.new(1,-60,0,13)

		local SliderValueText = Instance.new("TextBox", SliderFrame)
		SliderValueText.Name = "SliderValueText"; SliderValueText.Font = Enum.Font.GothamBold
		SliderValueText.TextColor3 = dependencies.GetColor("Text", SliderValueText, "TextColor3"); SliderValueText.TextSize = 12
		SliderValueText.BackgroundTransparency = 0.8
		SliderValueText.BackgroundColor3 = dependencies.GetColor("Accent", SliderValueText, "BackgroundColor3")
		SliderValueText.Position = UDim2.new(1,-45,0,5); SliderValueText.Size = UDim2.new(0,40,0,20)
		Instance.new("UICorner", SliderValueText).CornerRadius = UDim.new(0,3)

		local Bar = Instance.new("Frame", SliderFrame)
		Bar.Name = "Bar"; Bar.BackgroundColor3 = dependencies.GetColor("Accent", Bar, "BackgroundColor3")
		Bar.BorderSizePixel = 0; Bar.Position = UDim2.new(0,10,1,-20); Bar.Size = UDim2.new(1,-20,0,5)
		Instance.new("UICorner", Bar).CornerRadius = UDim.new(0,100)

		local Progress = Instance.new("Frame", Bar)
		Progress.Name = "Progress"; Progress.BackgroundColor3 = dependencies.GetColor("ThemeHighlight", Progress, "BackgroundColor3")
		Progress.BorderSizePixel = 0; Instance.new("UICorner", Progress).CornerRadius = UDim.new(0,100)

		local DraggerHitbox = Instance.new("TextButton", Bar)
		DraggerHitbox.Name = "DraggerHitbox"; DraggerHitbox.Text = ""; DraggerHitbox.Size = UDim2.new(0,20,0,20)
		DraggerHitbox.AnchorPoint = Vector2.new(0.5,0.5); DraggerHitbox.BackgroundTransparency=1; DraggerHitbox.ZIndex=3

		local VisualDragger = Instance.new("Frame", DraggerHitbox)
		VisualDragger.Name = "VisualDragger"; VisualDragger.Size=UDim2.new(0,10,0,10); VisualDragger.AnchorPoint=Vector2.new(0.5,0.5)
		VisualDragger.Position=UDim2.new(0.5,0,0.5,0); VisualDragger.BackgroundColor3=dependencies.GetColor("ThemeHighlight",VisualDragger,"BackgroundColor3")
		VisualDragger.BorderSizePixel=0; Instance.new("UICorner",VisualDragger).CornerRadius=UDim.new(0,100)

		local SliderAPI = {}
		local currentValue = config.Default

		local function UpdateSliderVisuals(value)
			value = math.clamp(math.floor(value/config.Increment + 0.5) * config.Increment, config.Min, config.Max)
			currentValue = value
			SliderValueText.Text = tostring(value)
			local percent = (config.Max - config.Min == 0) and 0 or (value - config.Min) / (config.Max - config.Min)
			Progress.Size = UDim2.new(percent,0,1,0)
			DraggerHitbox.Position = UDim2.new(percent,0,0.5,0)
		end

		function SliderAPI:SetValue(value)
			UpdateSliderVisuals(value)
			if config.Flag and dependencies.SaveFile then dependencies.SaveFile(config.Flag, currentValue) end
			config.Callback(currentValue)
		end
		function SliderAPI:GetValue() return currentValue end

		DraggerHitbox.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				local dragging = true
				local inputChangedConn, inputEndedConn, draggerEndedConn
				inputChangedConn = dependencies.UserInputService.InputChanged:Connect(function(subInput)
					if dragging and (subInput.UserInputType == Enum.UserInputType.MouseMovement or subInput.UserInputType == Enum.UserInputType.Touch) then
						local localPos = Bar.AbsolutePosition.X
						local mousePos = subInput.Position.X
						local percent = math.clamp((mousePos - localPos) / Bar.AbsoluteSize.X, 0, 1)
						SliderAPI:SetValue(config.Min + percent * (config.Max - config.Min))
					end
				end)
				inputEndedConn = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then dragging = false; if inputChangedConn then inputChangedConn:Disconnect() end; if inputEndedConn then inputEndedConn:Disconnect() end; if draggerEndedConn then draggerEndedConn:Disconnect() end end
				end)
				draggerEndedConn = DraggerHitbox.InputEnded:Connect(function(endInput)
					if endInput.UserInputType == input.UserInputType then dragging = false; if inputChangedConn then inputChangedConn:Disconnect() end; if inputEndedConn then inputEndedConn:Disconnect() end; if draggerEndedConn then draggerEndedConn:Disconnect() end end
				end)
			end
		end)
		SliderValueText.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				local num = tonumber(SliderValueText.Text)
				if num then SliderAPI:SetValue(num) else SliderAPI:SetValue(currentValue) -- Revert if not a number
				end
			else
				SliderValueText.Text = tostring(currentValue) -- Revert if focus lost without enter
			end
		end)

		SliderAPI:SetValue(config.Default) -- Initialize
		task.defer(updateVisualsCallback)
		return SliderAPI
	end

	local function Helper_CreateToggle(parent, config, dependencies, updateVisualsCallback)
		local config = config or {}
		config.Title = config.Title or "Toggle"
		config.Content = config.Content or ""
		local savedValue = config.Flag and dependencies.Flags[config.Flag]
		config.Default = (savedValue ~= nil) and savedValue or config.Default or false
		config.Callback = config.Callback or function() end

		local ToggleFrame = Instance.new("Frame")
		ToggleFrame.Name = "ToggleElement"; ToggleFrame.Parent = parent
		ToggleFrame.Size = UDim2.new(1,0,0,46); ToggleFrame.BackgroundTransparency = 0.935
		ToggleFrame.BackgroundColor3 = dependencies.GetColor("Secondary", ToggleFrame, "BackgroundColor3")
		Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0,4)

		local ToggleTitle = Instance.new("TextLabel", ToggleFrame)
		ToggleTitle.Name = "ToggleTitle"; ToggleTitle.Font = Enum.Font.GothamBold; ToggleTitle.Text = config.Title
		ToggleTitle.TextColor3 = dependencies.GetColor("Text", ToggleTitle, "TextColor3"); ToggleTitle.TextSize = 13
		ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left; ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
		ToggleTitle.BackgroundTransparency=1; ToggleTitle.Position = UDim2.new(0,10,0,10); ToggleTitle.Size = UDim2.new(1,-50,0,13)

		local ToggleContent = Instance.new("TextLabel", ToggleFrame)
		ToggleContent.Name = "ToggleContent"; ToggleContent.Font = Enum.Font.Gotham; ToggleContent.Text = config.Content
		ToggleContent.TextColor3 = dependencies.GetColor("Text", ToggleContent, "TextColor3"); ToggleContent.TextSize = 12
		ToggleContent.TextTransparency = 0.4; ToggleContent.TextWrapped = true; ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
		ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom; ToggleContent.BackgroundTransparency=1
		ToggleContent.Position = UDim2.new(0,10,0,0); ToggleContent.Size = UDim2.new(1,-50,1,-10)

		local SwitchFrame = Instance.new("Frame", ToggleFrame)
		SwitchFrame.Name = "SwitchFrame"; SwitchFrame.AnchorPoint = Vector2.new(1,0.5)
		SwitchFrame.BackgroundColor3 = dependencies.GetColor("Accent", SwitchFrame, "BackgroundColor3")
		SwitchFrame.BackgroundTransparency = 0.5; SwitchFrame.BorderSizePixel = 0
		SwitchFrame.Position = UDim2.new(1,-10,0.5,0); SwitchFrame.Size = UDim2.new(0,30,0,15)
		Instance.new("UICorner", SwitchFrame).CornerRadius = UDim.new(0,100)

		local SwitchCircle = Instance.new("Frame", SwitchFrame)
		SwitchCircle.Name = "SwitchCircle"; SwitchCircle.BackgroundColor3 = dependencies.GetColor("ThemeHighlight", SwitchCircle, "BackgroundColor3")
		SwitchCircle.BorderSizePixel = 0; SwitchCircle.Size = UDim2.new(0,12,0,12)
		Instance.new("UICorner", SwitchCircle).CornerRadius = UDim.new(0,100)

		local ActualButton = Instance.new("TextButton", ToggleFrame)
		ActualButton.Name = "ActualButton"; ActualButton.Text = ""; ActualButton.Size = UDim2.new(1,0,1,0); ActualButton.BackgroundTransparency = 1

		local ToggleAPI = {}
		local currentValue = config.Default

		local function UpdateToggleVisual(value)
			SwitchCircle:TweenPosition(UDim2.new(value and 0.5 or 0, value and -1 or 1, 0.5, -6), "Out", "Quad", 0.15, true)
		end

		function ToggleAPI:SetValue(value)
			currentValue = value
			UpdateToggleVisual(currentValue)
			if config.Flag and dependencies.SaveFile then dependencies.SaveFile(config.Flag, currentValue) end
			config.Callback(currentValue)
		end
		function ToggleAPI:GetValue() return currentValue end

		ActualButton.Activated:Connect(function()
			dependencies.CircleClick(ActualButton, dependencies.Mouse.X, dependencies.Mouse.Y)
			ToggleAPI:SetValue(not currentValue)
		end)

		ToggleAPI:SetValue(config.Default) -- Initialize
		task.defer(updateVisualsCallback)
		return ToggleAPI
	end

	local function Helper_CreateInput(parent, config, dependencies, updateVisualsCallback)
		local config = config or {}
		config.Title = config.Title or "Input"
		config.Content = config.Content or ""
		config.Placeholder = config.Placeholder or "Enter text..."
		local savedValue = config.Flag and dependencies.Flags[config.Flag]
		config.Default = savedValue or config.Default or ""
		config.Callback = config.Callback or function() end

		local InputFrame = Instance.new("Frame")
		InputFrame.Name = "InputElement"; InputFrame.Parent = parent
		InputFrame.Size = UDim2.new(1,0,0,46); InputFrame.BackgroundTransparency = 0.935
		InputFrame.BackgroundColor3 = dependencies.GetColor("Secondary", InputFrame, "BackgroundColor3")
		Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0,4)

		local InputTitle = Instance.new("TextLabel", InputFrame)
		InputTitle.Name = "InputTitle"; InputTitle.Font = Enum.Font.GothamBold; InputTitle.Text = config.Title
		InputTitle.TextColor3 = dependencies.GetColor("Text", InputTitle, "TextColor3"); InputTitle.TextSize = 13
		InputTitle.TextXAlignment = Enum.TextXAlignment.Left; InputTitle.TextYAlignment = Enum.TextYAlignment.Top
		InputTitle.BackgroundTransparency=1; InputTitle.Position = UDim2.new(0,10,0,10); InputTitle.Size = UDim2.new(1,-160,0,13)

		local InputContent = Instance.new("TextLabel", InputFrame)
		InputContent.Name = "InputContent"; InputContent.Font = Enum.Font.Gotham; InputContent.Text = config.Content
		InputContent.TextColor3 = dependencies.GetColor("Text", InputContent, "TextColor3"); InputContent.TextSize = 12
		InputContent.TextTransparency = 0.4; InputContent.TextWrapped = true; InputContent.TextXAlignment = Enum.TextXAlignment.Left
		InputContent.TextYAlignment = Enum.TextYAlignment.Bottom; InputContent.BackgroundTransparency=1
		InputContent.Position = UDim2.new(0,10,0,0); InputContent.Size = UDim2.new(1,-160,1,-10)

		local TextBox = Instance.new("TextBox", InputFrame)
		TextBox.Name = "TextBox"; TextBox.Font = Enum.Font.Gotham; TextBox.Text = config.Default
		TextBox.PlaceholderText = config.Placeholder
		TextBox.PlaceholderColor3 = Color3.fromRGB(180,180,180) -- Standard placeholder color
		TextBox.TextColor3 = dependencies.GetColor("Text", TextBox, "TextColor3"); TextBox.TextSize = 12
		TextBox.BackgroundColor3 = dependencies.GetColor("Accent", TextBox, "BackgroundColor3")
		TextBox.AnchorPoint = Vector2.new(1,0.5)
		TextBox.Position = UDim2.new(1,-10,0.5,0); TextBox.Size = UDim2.new(0,140,0,24)
		Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0,3); TextBox.ClearTextOnFocus = false

		local InputAPI = {}
		local currentValue = config.Default

		function InputAPI:SetValue(value)
			currentValue = value
			TextBox.Text = currentValue
			if config.Flag and dependencies.SaveFile then dependencies.SaveFile(config.Flag, currentValue) end
			config.Callback(currentValue)
		end
		function InputAPI:GetValue() return currentValue end

		TextBox.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				InputAPI:SetValue(TextBox.Text)
			else
				TextBox.Text = currentValue -- Revert if focus lost without enter
			end
		end)

		InputAPI:SetValue(config.Default) -- Initialize
		task.defer(updateVisualsCallback)
		return InputAPI
	end

	local function Helper_CreateDropdown(parent, config, dependencies, updateVisualsCallback)
		-- This helper will reuse the more complex Helper_CreateDropdownElements from the main library body
		-- It acts as a simple wrapper to fit the pattern for section elements.
		local dropdownApi = Helper_CreateDropdownElements(parent, config, dependencies)
		-- Helper_CreateDropdownElements should handle its own sizing and add itself to parent.
		-- It needs 'parent' to be the frame where the dropdown UI is created.
		-- The LayoutOrder of the DropdownFrame created by Helper_CreateDropdownElements will be handled
		-- by the UIListLayout in 'parent' (which is SectionContentFrame).
		task.defer(updateVisualsCallback)
		return dropdownApi
	end

	local function Helper_CreateDivider(parent, config, dependencies, updateVisualsCallback)
		local config = config or {}
		config.Text = config.Text or nil -- Optional text for the divider
		config.Color = config.Color or dependencies.GetColor("Stroke")
		config.Thickness = config.Thickness or 1
		config.TextSize = config.TextSize or 12
		config.TextColor = config.TextColor or dependencies.GetColor("Text")
		config.Font = config.Font or Enum.Font.GothamBold

		local DividerContainer = Instance.new("Frame", parent)
		DividerContainer.Name = "DividerElement"
		DividerContainer.BackgroundTransparency = 1

		if not config.Text or config.Text == "" then
			DividerContainer.Size = UDim2.new(1,0,0,config.Thickness + 4) -- Line + padding
			local Line = Instance.new("Frame", DividerContainer)
			Line.Name = "FullLine"
			Line.BackgroundColor3 = config.Color
			Line.BorderSizePixel = 0
			Line.AnchorPoint = Vector2.new(0.5,0.5)
			Line.Position = UDim2.new(0.5,0,0.5,0)
			Line.Size = UDim2.new(1,-10,0,config.Thickness) -- -10 for padding
		else
			DividerContainer.Size = UDim2.new(1,0,0,config.TextSize + 8) -- Text height + padding
			local ListLayout = Instance.new("UIListLayout", DividerContainer)
			ListLayout.FillDirection = Enum.FillDirection.Horizontal
			ListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ListLayout.Padding = UDim.new(0,8)

			local Line1 = Instance.new("Frame", DividerContainer)
			Line1.Name="Line1"; Line1.BackgroundColor3=config.Color; Line1.BorderSizePixel=0
			Line1.Size=UDim2.new(0.35,0,0,config.Thickness); Line1.LayoutOrder=1 -- Flexible width

			local DividerText = Instance.new("TextLabel", DividerContainer)
			DividerText.Name="DividerText"; DividerText.Text=config.Text; DividerText.TextColor3=config.TextColor
			DividerText.Font=config.Font; DividerText.TextSize=config.TextSize; DividerText.BackgroundTransparency=1
			DividerText.AutomaticSize=Enum.AutomaticSize.X; DividerText.Size=UDim2.new(0,0,1,0); DividerText.LayoutOrder=2

			local Line2=Instance.new("Frame", DividerContainer)
			Line2.Name="Line2"; Line2.BackgroundColor3=config.Color; Line2.BorderSizePixel=0
			Line2.Size=UDim2.new(0.35,0,0,config.Thickness); Line2.LayoutOrder=3 -- Flexible width

			-- Use Change listener to adjust line widths to fill space
			local function adjustLines()
				local containerWidth = DividerContainer.AbsoluteSize.X - ListLayout.Padding.Offset * 2
				local textWidth = DividerText.AbsoluteSize.X
				local remainingWidth = containerWidth - textWidth
				local lineWidth = math.max(5, remainingWidth / 2) -- Min width of 5px
				Line1.Size = UDim2.new(0, lineWidth, 0, config.Thickness)
				Line2.Size = UDim2.new(0, lineWidth, 0, config.Thickness)
			end
			DividerContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(adjustLines)
			DividerText:GetPropertyChangedSignal("AbsoluteSize"):Connect(adjustLines)
			task.defer(adjustLines)
		end

		task.defer(updateVisualsCallback)
		return {}
	end

	local function Helper_CreateParagraph(parent, config, dependencies, updateVisualsCallback)
		local config = config or {}
		config.Title = config.Title or "Paragraph" -- Can be used as a header for the text
		config.Content = config.Content or "Some descriptive text."
		config.TitleColor = config.TitleColor or dependencies.GetColor("Text")
		config.ContentColor = config.ContentColor or dependencies.GetColor("Text")
		config.TitleFont = config.TitleFont or Enum.Font.GothamBold
		config.ContentFont = config.ContentFont or Enum.Font.Gotham
		config.TitleSize = config.TitleSize or 13
		config.ContentSize = config.ContentSize or 12

		local ParagraphFrame = Instance.new("Frame")
		ParagraphFrame.Name = "ParagraphElement"; ParagraphFrame.Parent = parent
		ParagraphFrame.BackgroundTransparency = 1 -- Usually transparent, just a container for text
		ParagraphFrame.Size = UDim2.new(1,0,0,10) -- Initial small height, will auto-size

		local UIList = Instance.new("UIListLayout", ParagraphFrame)
		UIList.Padding = UDim.new(0,3)
		UIList.SortOrder = Enum.SortOrder.LayoutOrder

		local ParagraphTitleLabel
		if config.Title and config.Title ~= "" then
			ParagraphTitleLabel = Instance.new("TextLabel", ParagraphFrame)
			ParagraphTitleLabel.Name = "ParagraphTitle"
			ParagraphTitleLabel.Font = config.TitleFont
			ParagraphTitleLabel.Text = config.Title
			ParagraphTitleLabel.TextColor3 = config.TitleColor
			ParagraphTitleLabel.TextSize = config.TitleSize
			ParagraphTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ParagraphTitleLabel.TextWrapped = true
			ParagraphTitleLabel.BackgroundTransparency = 1
			ParagraphTitleLabel.Size = UDim2.new(1,-10,0,0) -- Full width, auto Y height
			ParagraphTitleLabel.AutomaticSize = Enum.AutomaticSize.Y
			ParagraphTitleLabel.LayoutOrder = 1
		end

		local ParagraphContentLabel = Instance.new("TextLabel", ParagraphFrame)
		ParagraphContentLabel.Name = "ParagraphContent"
		ParagraphContentLabel.Font = config.ContentFont
		ParagraphContentLabel.Text = config.Content
		ParagraphContentLabel.TextColor3 = config.ContentColor
		ParagraphContentLabel.TextTransparency = 0.1 -- Slightly less prominent than title
		ParagraphContentLabel.TextSize = config.ContentSize
		ParagraphContentLabel.TextXAlignment = Enum.TextXAlignment.Left
		ParagraphContentLabel.TextWrapped = true
		ParagraphContentLabel.BackgroundTransparency = 1
		ParagraphContentLabel.Size = UDim2.new(1,-10,0,0) -- Full width, auto Y height
		ParagraphContentLabel.AutomaticSize = Enum.AutomaticSize.Y
		ParagraphContentLabel.LayoutOrder = 2

		local ParagraphAPI = {}
		function ParagraphAPI:SetText(newContent, newTitle)
			ParagraphContentLabel.Text = newContent or config.Content
			if ParagraphTitleLabel and newTitle then
				ParagraphTitleLabel.Text = newTitle
			end
			task.defer(updateVisualsCallback) -- Text change might affect height
		end

		task.defer(updateVisualsCallback) -- Initial call after elements are created
		return ParagraphAPI
	end

	-- This master 'dependencies' table will hold all shared resources.
	local dependencies = {
		-- Helper Functions
		GetColor = GetColor,
		SetTheme = SetTheme,
		GetThemes = GetThemes,
		LoadUIAsset = LoadUIAsset,
		SaveFile = SaveFile, -- Will be defined by the library and added, ensure it's here
		CircleClick = CircleClick,
		-- Shared UI Instances & Variables
		MoreBlur = MoreBlur,
		DropdownFolder = DropdownFolder,
		DropPageLayout = DropPageLayout,
		DropdownSelect = DropdownSelect,
		Mouse = Mouse,
		TweenService = TweenService,
		Flags = Flags,
		-- Global Counters (passed by reference via the table)
		CountDropdown = { Value = CountDropdown }, -- Pass as a table { Value = ... }
		-- Other necessary items from the old dependencies table that might be used by helpers
		HttpService = HttpService,
		UserInputService = UserInputService,
		GuiConfig = GuiConfig,
		UIInstance = UIInstance, -- For rare cases
		MakeNotify = UBHubLib.MakeNotify, -- Already in old dependencies
		CurrentThemeRef = function() return CurrentTheme end, -- Already in old dependencies
		LayersPageLayout = LayersPageLayout,
		NameTab = NameTab,
		ScrollTab = ScrollTab,
		LayersTab = LayersTab
	}
	-- Ensure SaveFile is part of dependencies, it's created locally in MakeGui
	-- If SaveFile is defined after this dependencies table, it needs to be added:
	-- dependencies.SaveFile = SaveFile (this is handled by the existing code structure)

	--// Tabs
	-- local CountTab = 0 -- This is initialized near the top of MakeGui
	-- local CountDropdown = 0 -- This is now dependencies.CountDropdown.Value

	-- API: CreateTab
	function UIInstance:CreateTab(TabConfig)
		local TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""

		local isSettingsTab = TabConfig.IsSettingsTab or false
		local parentForTabButton = isSettingsTab and LayersTab or ScrollTab -- Parent to main list or scroll frame

		-- Tab Button UI Creation (Frame, TextLabel, ImageLabel, etc.)
		local TabButtonFrame = Instance.new("Frame")
		TabButtonFrame.Name = TabConfig.Name .. "_TabButton"
		TabButtonFrame.Parent = parentForTabButton
		TabButtonFrame.Size = UDim2.new(1, 0, 0, 40) -- Standard height
		TabButtonFrame.BackgroundColor3 = dependencies.GetColor("Secondary") -- Example, adjust as needed
		TabButtonFrame.BackgroundTransparency = 0.95
		TabButtonFrame.LayoutOrder = isSettingsTab and 999 or CountTab -- Ensure settings tab is at the bottom
		Instance.new("UICorner", TabButtonFrame).CornerRadius = UDim.new(0, 4)

		local TabButton = Instance.new("TextButton", TabButtonFrame)
		TabButton.Name = "TabButton"
		TabButton.Text = ""
		TabButton.Size = UDim2.new(1,0,1,0)
		TabButton.BackgroundTransparency = 1

		local TabIcon = Instance.new("ImageLabel", TabButtonFrame)
		TabIcon.Name = "FeatureImg"
		TabIcon.Image = TabConfig.Icon
		TabIcon.Size = UDim2.new(0, 16, 0, 16) -- Adjust as needed
		TabIcon.Position = UDim2.new(0, 9, 0.5, -8) -- Adjust as needed
		TabIcon.BackgroundTransparency = 1

		local TabNameLabel = Instance.new("TextLabel", TabButtonFrame)
		TabNameLabel.Name = "TabName"
		TabNameLabel.Text = TabConfig.Name
		TabNameLabel.Font = Enum.Font.GothamBold
		TabNameLabel.TextColor3 = dependencies.GetColor("Text")
		TabNameLabel.TextSize = 13
		TabNameLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabNameLabel.BackgroundTransparency = 1
		TabNameLabel.Position = UDim2.new(0, 30, 0, 0) -- Adjust as needed
		TabNameLabel.Size = UDim2.new(1, -35, 1, 0) -- Adjust as needed

		local ChooseFrame = Instance.new("Frame", TabButtonFrame)
		ChooseFrame.Name = "ChooseFrame"
		ChooseFrame.BackgroundColor3 = dependencies.GetColor("ThemeHighlight")
		ChooseFrame.BorderSizePixel = 0
		ChooseFrame.Position = UDim2.new(0,2,0,9) -- Example position
		ChooseFrame.Size = UDim2.new(0,1,0,12) -- Example size
		ChooseFrame.Visible = false -- Initially hidden
		Instance.new("UICorner", ChooseFrame).CornerRadius = UDim.new(0,3)
		local chooseFrameStroke = Instance.new("UIStroke", ChooseFrame)
		chooseFrameStroke.Color = dependencies.GetColor("Secondary")
		chooseFrameStroke.Thickness = 1.6

		if not isSettingsTab then
			-- Create the corresponding content page for normal tabs
			local ScrolLayers = Instance.new("ScrollingFrame")
			ScrolLayers.Name = "ScrolLayers_" .. TabConfig.Name -- Unique name
			ScrolLayers.Parent = LayersFolder -- Parent to the folder holding all tab content pages
			ScrolLayers.LayoutOrder = CountTab
			ScrolLayers.Size = UDim2.new(1,0,1,0)
			ScrolLayers.BackgroundTransparency = 1
			ScrolLayers.ScrollBarThickness = 3
			ScrolLayers.CanvasSize = UDim2.new(0,0,0,0) -- Will be updated by UIListLayout
			local UIListLayoutContent = Instance.new("UIListLayout", ScrolLayers)
			UIListLayoutContent.Padding = UDim.new(0,3)
			UIListLayoutContent.SortOrder = Enum.SortOrder.LayoutOrder

			-- Connect button click for normal tabs
			TabButton.Activated:Connect(function()
				dependencies.CircleClick(TabButton, dependencies.Mouse.X, dependencies.Mouse.Y)

				-- Clear all other highlights (including settings tab if it exists)
				for _, child in ipairs(dependencies.ScrollTab:GetChildren()) do
					if child:IsA("Frame") and child.Name:match("_TabButton$") then
						child.BackgroundTransparency = 0.95
						local cf = child:FindFirstChild("ChooseFrame")
						if cf then cf.Visible = false end
					end
				end
				local settingsBtn = dependencies.LayersTab:FindFirstChild("Settings_TabButton")
				if settingsBtn then
					settingsBtn.BackgroundTransparency = 0.95
					local cfSettings = settingsBtn:FindFirstChild("ChooseFrame")
					if cfSettings then cfSettings.Visible = false end
				end

				TabButtonFrame.BackgroundTransparency = 0.85 -- Highlight
				ChooseFrame.Visible = true
				dependencies.LayersPageLayout:JumpTo(ScrolLayers)
				dependencies.NameTab.Text = TabConfig.Name
			end)

			local Tab = {}
			Tab.ContentPage = ScrolLayers -- This is the ScrollingFrame where sections will be added

			-- API: AddSection
			function Tab:AddSection(SectionTitle)
				SectionTitle = SectionTitle or "Section"
				local Section = {} -- This will be the returned Section object API

				-- Create Section UI (SectionFrame, SectionReal, SectionButton, Title, Arrow, SectionAdd for content)
				local SectionFrame = Instance.new("Frame")
				SectionFrame.Name = "Section_" .. SectionTitle
				SectionFrame.Parent = Tab.ContentPage -- Parent to the Tab's ScrollingFrame
				SectionFrame.BackgroundColor3 = dependencies.GetColor("Secondary")
				SectionFrame.BackgroundTransparency = 0.97
				SectionFrame.Size = UDim2.new(1,0,0,30) -- Initial collapsed height
				SectionFrame.ClipsDescendants = true
				Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0,4)
				-- LayoutOrder for sections within a tab will be handled by the UIListLayout in Tab.ContentPage

				local SectionHeader = Instance.new("TextButton", SectionFrame) -- Header acts as the button
				SectionHeader.Name = "SectionHeaderButton"
				SectionHeader.Text = ""
				SectionHeader.Size = UDim2.new(1,0,0,30)
				SectionHeader.BackgroundTransparency = 1

				local SectionTitleLabel = Instance.new("TextLabel", SectionHeader)
				SectionTitleLabel.Name = "SectionTitle"
				SectionTitleLabel.Text = SectionTitle
				SectionTitleLabel.Font = Enum.Font.GothamBold
				SectionTitleLabel.TextColor3 = dependencies.GetColor("Text")
				SectionTitleLabel.TextSize = 13
				SectionTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
				SectionTitleLabel.BackgroundTransparency = 1
				SectionTitleLabel.Position = UDim2.new(0,10,0.5,-7)
				SectionTitleLabel.Size = UDim2.new(1,-30,0,14)

				local SectionArrow = Instance.new("ImageLabel", SectionHeader)
				SectionArrow.Name = "SectionArrow"
				SectionArrow.Image = dependencies.LoadUIAsset("rbxassetid://16851841101", "DropdownArrowHelper.png") -- Generic Arrow
				SectionArrow.ImageColor3 = dependencies.GetColor("Text")
				SectionArrow.AnchorPoint = Vector2.new(1,0.5)
				SectionArrow.Position = UDim2.new(1,-10,0.5,0)
				SectionArrow.Size = UDim2.new(0,15,0,15)
				SectionArrow.Rotation = -90 -- Collapsed state
				SectionArrow.BackgroundTransparency = 1

				local SectionContentFrame = Instance.new("Frame", SectionFrame)
				SectionContentFrame.Name = "SectionContent"
				SectionContentFrame.BackgroundTransparency = 1
				SectionContentFrame.Size = UDim2.new(1,0,1,-30) -- Full width, height calculated dynamically
				SectionContentFrame.Position = UDim2.new(0,0,0,30) -- Below header
				SectionContentFrame.ClipsDescendants = true
				SectionContentFrame.Visible = false -- Collapsed by default
				local SectionContentLayout = Instance.new("UIListLayout", SectionContentFrame)
				SectionContentLayout.Padding = UDim.new(0,3)
				SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

				local isSectionOpen = false
				local function UpdateSectionVisuals()
					SectionContentFrame.Visible = isSectionOpen
					SectionArrow.Rotation = isSectionOpen and 0 or -90

					-- Recalculate SectionFrame height
					local contentHeight = 0
					if isSectionOpen then
						contentHeight = SectionContentLayout.AbsoluteContentSize.Y
						if #SectionContentFrame:GetChildren() > 1 then -- Has items besides layout
							contentHeight = contentHeight + (#SectionContentFrame:GetChildren() - 2) * SectionContentLayout.Padding.Offset
						end
					end
					SectionFrame.Size = UDim2.new(1,0,0, 30 + (isSectionOpen and contentHeight + 5 or 0)) -- 30 for header, 5 for padding

					-- Force update of parent ScrollingFrame's CanvasSize
					task.defer(function()
						if Tab.ContentPage and Tab.ContentPage:FindFirstChildOfClass("UIListLayout") then
							local listLayout = Tab.ContentPage:FindFirstChildOfClass("UIListLayout")
							Tab.ContentPage.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y)
						end
					end)
				end

				SectionHeader.Activated:Connect(function()
					dependencies.CircleClick(SectionHeader, dependencies.Mouse.X, dependencies.Mouse.Y)
					isSectionOpen = not isSectionOpen
					UpdateSectionVisuals()
				end)

				-- Define all element functions for the Section object
				function Section:AddButton(config)
					return Helper_CreateButton(SectionContentFrame, config, dependencies, UpdateSectionVisuals)
				end
				function Section:AddSlider(config)
					return Helper_CreateSlider(SectionContentFrame, config, dependencies, UpdateSectionVisuals)
				end
				function Section:AddToggle(config)
					return Helper_CreateToggle(SectionContentFrame, config, dependencies, UpdateSectionVisuals)
				end
				function Section:AddInput(config)
					return Helper_CreateInput(SectionContentFrame, config, dependencies, UpdateSectionVisuals)
				end
				function Section:AddDropdown(config)
					return Helper_CreateDropdown(SectionContentFrame, config, dependencies, UpdateSectionVisuals)
				end
				function Section:AddDivider(config)
					return Helper_CreateDivider(SectionContentFrame, config, dependencies, UpdateSectionVisuals)
				end
				function Section:AddParagraph(config)
					return Helper_CreateParagraph(SectionContentFrame, config, dependencies, UpdateSectionVisuals)
				end
				-- ... Add other element types in the same way ...

				UpdateSectionVisuals() -- Initial sizing
				return Section
			end

			CountTab = CountTab + 1
			-- Default to first tab selected if it's the very first one
			if CountTab == 1 then
				TabButton.Activated:Invoke() -- Simulate a click
			end
			return Tab

		else -- This is the special permanent Settings Tab
			-- It doesn't need a unique content page in LayersFolder.
			-- Its button click will show the 'SettingsContentPage' (which should be a pre-existing frame).

			-- The 'SettingsContentPage' needs to be defined in MakeGui and made visible by this button.
			-- For now, assume SettingsContentPage is a direct child of 'Layers' frame, sibling to 'LayersReal'.
			-- It should have its own ScrollingFrame and UIListLayout for its sections.

			-- Ensure SettingsContentPage exists and is correctly parented (e.g., to Layers)
			-- This example assumes 'SettingsContentPage' is already created and parented to 'Layers'
			-- and 'LayersReal' is the container for normal tab content.
			local settingsContentHost = Layers:FindFirstChild("SettingsContentPage")
			if not settingsContentHost then
				-- Create it if it doesn't exist (basic setup)
				settingsContentHost = Instance.new("Frame")
				settingsContentHost.Name = "SettingsContentPage"
				settingsContentHost.Parent = Layers -- Sibling to LayersReal
				settingsContentHost.Size = UDim2.new(1,0,1,0) -- Take full area of Layers
				settingsContentHost.Position = UDim2.new(0,0,0,33) -- Below NameTab
				settingsContentHost.Size = UDim2.new(1,0,1,-33)
				settingsContentHost.BackgroundTransparency = 1
				settingsContentHost.Visible = false -- Hidden by default

				local settingsScroll = Instance.new("ScrollingFrame", settingsContentHost)
				settingsScroll.Name = "SettingsScroll"
				settingsScroll.Size = UDim2.new(1,0,1,0)
				settingsScroll.BackgroundTransparency = 1
				settingsScroll.ScrollBarThickness = 3
				local settingsLayout = Instance.new("UIListLayout", settingsScroll)
				settingsLayout.Padding = UDim.new(0,3)
				settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
				-- Store this scroll view for the SettingsTab object
				-- This is a deviation from the user's block 3 which uses SettingsTab:AddSection.
				-- The user's block implies SettingsTab IS the tab object for settings.
			end


			TabButton.Activated:Connect(function()
				dependencies.CircleClick(TabButton, dependencies.Mouse.X, dependencies.Mouse.Y)

				-- Clear all other highlights
				for _, child in ipairs(dependencies.ScrollTab:GetChildren()) do
					if child:IsA("Frame") and child.Name:match("_TabButton$") then
						child.BackgroundTransparency = 0.95
						local cf = child:FindFirstChild("ChooseFrame")
						if cf then cf.Visible = false end
					end
				end

				TabButtonFrame.BackgroundTransparency = 0.85 -- Highlight
				ChooseFrame.Visible = true

				LayersReal.Visible = false -- Hide normal tab content area
				local sContentPage = Layers:FindFirstChild("SettingsContentPage")
				if sContentPage then sContentPage.Visible = true end

				dependencies.NameTab.Text = TabConfig.Name -- "Settings"
			end)

			-- The Settings Tab itself needs an object to call AddSection on.
			-- It won't have a ScrolLayers in LayersFolder, but its sections will go into SettingsContentPage's scroller.
			local SettingsTabAPI = {}
			local settingsContentScroller = settingsContentHost and settingsContentHost:FindFirstChild("SettingsScroll")

			function SettingsTabAPI:AddSection(SectionTitle)
				if not settingsContentScroller then
					warn("SettingsContentPage or its scroller not found for SettingsTab:AddSection")
					return { AddButton = function() warn("Settings scroller missing") end } -- Return dummy
				end
				-- This function now has access to the 'dependencies' table.
				-- It will create a Section UI and return a Section object.
				local Section = {}
				-- Create Section UI (similar to normal tab's AddSection, but parent to settingsContentScroller)
				local SectionFrame = Instance.new("Frame")
				SectionFrame.Name = "Section_" .. SectionTitle
				SectionFrame.Parent = settingsContentScroller -- Parent to the Settings ScrollFrame
				SectionFrame.BackgroundColor3 = dependencies.GetColor("Secondary")
				SectionFrame.BackgroundTransparency = 0.97
				SectionFrame.Size = UDim2.new(1,0,0,30)
				SectionFrame.ClipsDescendants = true
				Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0,4)

				local SectionHeader = Instance.new("TextButton", SectionFrame)
				SectionHeader.Name = "SectionHeaderButton"
				SectionHeader.Text = ""
				SectionHeader.Size = UDim2.new(1,0,0,30)
				SectionHeader.BackgroundTransparency = 1

				local SectionTitleLabel = Instance.new("TextLabel", SectionHeader)
				SectionTitleLabel.Name = "SectionTitle"
				SectionTitleLabel.Text = SectionTitle
				SectionTitleLabel.Font = Enum.Font.GothamBold
				SectionTitleLabel.TextColor3 = dependencies.GetColor("Text")
				SectionTitleLabel.TextSize = 13
				SectionTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
				SectionTitleLabel.BackgroundTransparency = 1
				SectionTitleLabel.Position = UDim2.new(0,10,0.5,-7)
				SectionTitleLabel.Size = UDim2.new(1,-30,0,14)

				local SectionArrow = Instance.new("ImageLabel", SectionHeader)
				SectionArrow.Name = "SectionArrow"
				SectionArrow.Image = dependencies.LoadUIAsset("rbxassetid://16851841101", "DropdownArrowHelper.png")
				SectionArrow.ImageColor3 = dependencies.GetColor("Text")
				SectionArrow.AnchorPoint = Vector2.new(1,0.5)
				SectionArrow.Position = UDim2.new(1,-10,0.5,0)
				SectionArrow.Size = UDim2.new(0,15,0,15)
				SectionArrow.Rotation = -90
				SectionArrow.BackgroundTransparency = 1

				local SectionContentFrame = Instance.new("Frame", SectionFrame)
				SectionContentFrame.Name = "SectionContent"
				SectionContentFrame.BackgroundTransparency = 1
				SectionContentFrame.Size = UDim2.new(1,0,1,-30)
				SectionContentFrame.Position = UDim2.new(0,0,0,30)
				SectionContentFrame.ClipsDescendants = true
				SectionContentFrame.Visible = false
				local SectionContentLayout = Instance.new("UIListLayout", SectionContentFrame)
				SectionContentLayout.Padding = UDim.new(0,3)
				SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

				local isSectionOpen = false
				local function UpdateSettingsSectionVisuals()
					SectionContentFrame.Visible = isSectionOpen
					SectionArrow.Rotation = isSectionOpen and 0 or -90
					local contentHeight = 0
					if isSectionOpen then
						contentHeight = SectionContentLayout.AbsoluteContentSize.Y
						if #SectionContentFrame:GetChildren() > 1 then
							contentHeight = contentHeight + (#SectionContentFrame:GetChildren() - 2) * SectionContentLayout.Padding.Offset
						end
					end
					SectionFrame.Size = UDim2.new(1,0,0, 30 + (isSectionOpen and contentHeight + 5 or 0))
					task.defer(function()
						if settingsContentScroller and settingsContentScroller:FindFirstChildOfClass("UIListLayout") then
							local listLayout = settingsContentScroller:FindFirstChildOfClass("UIListLayout")
							settingsContentScroller.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y)
						end
					end)
				end

				SectionHeader.Activated:Connect(function()
					dependencies.CircleClick(SectionHeader, dependencies.Mouse.X, dependencies.Mouse.Y)
					isSectionOpen = not isSectionOpen
					UpdateSettingsSectionVisuals()
				end)

				-- Define all element functions for the Section object
				function Section:AddButton(config)
					return Helper_CreateButton(SectionContentFrame, config, dependencies, UpdateSettingsSectionVisuals)
				end
				function Section:AddSlider(config)
					return Helper_CreateSlider(SectionContentFrame, config, dependencies, UpdateSettingsSectionVisuals)
				end
				function Section:AddToggle(config)
					return Helper_CreateToggle(SectionContentFrame, config, dependencies, UpdateSettingsSectionVisuals)
				end
				function Section:AddInput(config)
					return Helper_CreateInput(SectionContentFrame, config, dependencies, UpdateSettingsSectionVisuals)
				end
				function Section:AddDropdown(config)
					return Helper_CreateDropdown(SectionContentFrame, config, dependencies, UpdateSettingsSectionVisuals)
				end
				function Section:AddDivider(config)
					return Helper_CreateDivider(SectionContentFrame, config, dependencies, UpdateSettingsSectionVisuals)
				end
				function Section:AddParagraph(config)
					return Helper_CreateParagraph(SectionContentFrame, config, dependencies, UpdateSettingsSectionVisuals)
				end

				UpdateSettingsSectionVisuals()
				return Section
			end
			return SettingsTabAPI -- Returns the API for the settings tab.
		end
	end

	-- The existing settings population code (Preset Management, Interface Customization, Customize Colors)
	-- was already calling SettingsTabObject:AddSection and its element methods.
	-- This was part of my previous attempts to fix the settings tab.
	-- Block 3 from your instructions is to essentially *replace* that with a cleaner, specific example.
	-- So, I will remove the old population code for SettingsTabObject first, then add Block 3.

	-- REMOVE OLD SettingsTabObject POPULATION START (approx line 2197 to 2396)
	-- This includes:
	-- local PresetManagementSettingsSection_InSettings = SettingsTabObject:AddSection(...)
	-- ... all its elements ...
	-- local InterfaceSettingsSection_InSettings = SettingsTabObject:AddSection(...)
	-- ... all its elements ...
	-- local CustomizeColorsSettingsSection_InSettings = SettingsTabObject:AddSection(...)
	-- ... all its elements ...
	-- REMOVE OLD SettingsTabObject POPULATION END

	-- =================================================================
	-- BLOCK 3: Create and Populate the Settings Tab using the new API
	-- This goes at the end of MakeGui, before 'return UIInstance'
	-- =================================================================

	-- Use our new, robust API to create the permanent settings tab
	-- Note: UIInstance:CreateTab for settings is already called earlier in my refactored code
	-- and it returns the SettingsTabAPI object.
	-- The variable 'SettingsTabObject' from my previous code should hold this.
	-- If 'SettingsTabObject' isn't defined or is incorrect, this needs adjustment.
	-- Assuming SettingsTabObject is the correct API handle for the settings tab:

	local SettingsTab = SettingsTabObject -- Use the existing handle if valid, otherwise re-create.
	                                      -- The user's Block 1 CreateTab for IsSettingsTab = true *should* return the correct API.
	                                      -- Let's verify if SettingsTabObject is indeed the result of UIInstance:CreateTab({IsSettingsTab=true...})
	                                      -- In my current code (after Block 1 insertion), UIInstance:CreateTab *does* return SettingsTabAPI for settings.
	                                      -- And it is already called, but its result is not stored in a way Block 3 expects.
	                                      -- The previous instantiation of SettingsTabObject was for the *old* settings tab system.

	-- Correction: Block 1's `UIInstance:CreateTab` for the settings tab *already creates the button* and returns the API.
	-- Block 3 *uses* this API. The previous population code needs to be removed, and then Block 3's population code added.
	-- The line `local SettingsTab = UIInstance:CreateTab({...})` in Block 3 is redundant if CreateTab was already called for settings.
	-- Let's assume `SettingsTabObject` from the current code is the correct API handle returned by the *new* CreateTab.
	-- If not, I need to ensure `UIInstance:CreateTab` for settings is called here and its result used.

	-- The current code has:
	-- local SettingsTabObject = UIInstance:CreateTab({ Name = "Settings", Icon = "...", IsSettingsTab = true }, dependencies)
	-- This SettingsTabObject *is* the one we need to use.

	-- Populate the settings tab
	local InterfaceSection = SettingsTabObject:AddSection("Interface")
	InterfaceSection:AddSlider({
		Title = "Window Transparency",
		Min = 0, Max = 1, Default = 0.1, Increment = 0.01,
		Callback = function(val)
			if Main then Main.BackgroundTransparency = val end
			-- Also update image/video transparency if they are active
			local bgImage = Main and Main:FindFirstChild("MainImage")
			local bgVideo = Main and Main:FindFirstChild("MainVideo")
			if bgImage then bgImage.ImageTransparency = val end
			if bgVideo then bgVideo.BackgroundTransparency = val end

			if dependencies.Flags then dependencies.Flags["WindowTransparency"] = val end
			if dependencies.SaveFile then dependencies.SaveFile("WindowTransparency", val) end
		end
	})
	InterfaceSection:AddSlider({
		Title = "Tab List Width",
		Min = 80, Max = 250, Default = GuiConfig["Tab Width"] or 120, Increment = 1,
		Flag = "TabWidth", -- Assuming SaveFile uses this flag
		Callback = function(val)
			if dependencies.LayersTab then
				dependencies.LayersTab.Size = UDim2.new(0, val, dependencies.LayersTab.Size.Y.Scale, dependencies.LayersTab.Size.Y.Offset)
			end
			if Layers then -- Layers is the main content area next to tabs
				Layers.Position = UDim2.new(0, val + 18, Layers.Position.Y.Scale, Layers.Position.Y.Offset)
				Layers.Size = UDim2.new(1, -(val + 9 + 18), Layers.Size.Y.Scale, Layers.Size.Y.Offset)
			end
			if dependencies.GuiConfig then dependencies.GuiConfig["Tab Width"] = val end
			-- SaveFile is implicitly handled by the helper if 'Flag' is provided
		end
	})
	-- ... etc ... Add more elements to InterfaceSection if needed from original settings

	local PresetsSection = SettingsTabObject:AddSection("Presets")
	-- Add elements to PresetsSection. Example:
	local defaultThemes = {}
	if dependencies.GetThemes then defaultThemes = dependencies.GetThemes() end
	local themeDropdown = PresetsSection:AddDropdown({
		Title = "Select Theme",
		Options = defaultThemes,
		Default = CurrentTheme, -- Assumes CurrentTheme is available
		Callback = function(selectedTable)
			if selectedTable and #selectedTable > 0 then
				local themeName = selectedTable[1]
				if dependencies.SetTheme then dependencies.SetTheme(themeName) end
				if dependencies.MakeNotify then dependencies.MakeNotify({Title="Theme Changed", Content="Set to "..themeName}) end
			end
		end
	})
	PresetsSection:AddButton({
		Title = "Test Button",
		Content = "A test button in presets.",
		Callback = function()
			if dependencies.MakeNotify then dependencies.MakeNotify({Title="Test", Content="Presets button clicked!"}) end
		end
	})
	-- ... etc ... Add more elements to PresetsSection if needed

	return UIInstance
end
return UBHubLib
