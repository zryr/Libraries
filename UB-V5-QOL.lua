local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()
local ProtectGui = protectgui or (syn and syn.protect_gui) or function(f) end
local CoreGui = cloneref(gethui()) or game:GetService("CoreGui")
local SizeUI = UDim2.new(0, 550, 0, 350)

-- Library-wide counters moved to global scope
local CountTab = 0
local CountDropdown = 0

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
        local alreadyExists = false
        for _, existingEntry in ipairs(ThemeElements) do
            if existingEntry.element == element and existingEntry.property == property then
                -- Optional: Update colorName if it's different, though this might be complex if not needed.
                -- For now, just prevent duplicate. If it exists, its colorName will be updated by SetTheme anyway.
                alreadyExists = true
                break
            end
        end
        if not alreadyExists then
            table.insert(ThemeElements, {
                element = element,
                property = property,
                colorName = colorName
            })
        end
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

	-- Save theme persistence data
	if SaveFile then -- Ensure SaveFile is available (it should be in this scope)
		SaveFile("LastThemeName", themeName)
		if Flags.CustomUserThemes and Flags.CustomUserThemes[themeName] or themeName == "__customApplied" or themeName == "__loadedStartupTheme" then
			if Themes[themeName] then -- Ensure the theme data exists
				SaveFile("LastCustomThemeData", deepcopy(Themes[themeName]))
			end
		else
			-- If it's a default theme, we can clear any stale custom data
			SaveFile("LastCustomThemeData", nil)
		end
	end

	-- Existing SetTheme hook for color controls update (from previous step)
	-- This should remain if it's still the SetTheme being called by UI elements.
	-- If originalSetTheme_Settings is the one being called directly by UI, this logic needs to be in that.
	-- Assuming the global SetTheme is wrapped and this is the inner function.
	if isSettingsViewActive or (CurrentTheme == "__customApplied" and SettingsPage.Visible) then
		task.delay(0.05, updateAllColorControls)
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
local function MakeDraggable(topbarobject, objectToDrag)
	-- Register this topbarobject and the object it drags with the centralized handler
	if topbarobject and objectToDrag then
		draggableElements[topbarobject] = {objectToDrag = objectToDrag}
	else
		warn("MakeDraggable: topbarobject or objectToDrag is nil")
	end
	-- No internal event connections needed anymore.
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

			if not NotifyLayout:FindFirstChildOfClass("UIListLayout") then
				local ListLayout = Instance.new("UIListLayout")
				ListLayout.Parent = NotifyLayout
				ListLayout.FillDirection = Enum.FillDirection.Vertical
				ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
				ListLayout.Padding = UDim.new(0, 5)
			end
			-- Removed ChildRemoved connection for manual tweening; UIListLayout handles this.
		end
		-- Removed NotifyPosHeigh calculation and usage for NotifyFrame.Position
		local NotifyFrame = Instance.new("Frame");
		NotifyFrame.LayoutOrder = tick() -- Ensure new notifications appear correctly if SortOrder is LayoutOrder
		-- NotifyFrame.AnchorPoint default (0,0) is fine with UIListLayout Bottom alignment.
		-- NotifyFrame.Position is now controlled by UIListLayout.
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

		local waitbruh_instance = false -- Local to this specific notification instance's spawn
		function NotifyFunction:Close()
			if waitbruh_instance then
				return false
			end
			waitbruh_instance = true
			local tweenDuration = tonumber(NotifyConfig.Time) * 0.2
			TweenService:Create(NotifyFrameReal,TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 400, 0, 0)}):Play()
			task.wait(tweenDuration) -- Wait for the hide animation to complete
			NotifyFrame:Destroy()
		end
		Close.Activated:Connect(function()
			NotifyFunction:Close()
		end)
		TweenService:Create(NotifyFrameReal,TweenInfo.new(tonumber(NotifyConfig.Time) * 0.2, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.wait(tonumber(NotifyConfig.Delay)) -- This is the delay *before* auto-closing
		NotifyFunction:Close() -- This will now wait for its own animation before destroying
	end)
	return NotifyFunction
end
local Folder = "UBHub5"
local mediaFolder = "Asset"
if not isfolder(Folder) then
	makefolder(Folder)
end
function UBHubLib:MakeGui(GuiConfig)
	local function deepcopy(orig)
		local orig_type = type(orig)
		local copy
		if orig_type == 'table' then
			copy = {}
			for orig_key, orig_value in next, orig, nil do
				copy[deepcopy(orig_key)] = deepcopy(orig_value)
			end
			setmetatable(copy, deepcopy(getmetatable(orig)))
		else -- number, string, boolean, etc
			copy = orig
		end
		return copy
	end

	local GuiConfig = GuiConfig or {}

	-- Centralized Input Handling Variables for window drag/resize
	local isWindowDragging = false
	local isWindowResizing = false
	local windowDragTarget = nil      -- The main frame being dragged (e.g., DropShadowHolder)
	local windowDragInitiator = nil   -- The specific topbar element that initiated the drag (e.g., Top)
	local windowResizeTarget = nil    -- The main frame being resized (e.g., Main)
	local windowResizeInitiator = nil -- The specific resize handle that initiated resizing

	local windowDragStartMouse = Vector2.new()
	local windowDragStartPos = UDim2.new()
	local windowResizeStartMouse = Vector2.new()
	local windowResizeStartSize = UDim2.new()

	-- To store connection objects for later disconnect if GUI is destroyed
	local uisInputBeganConn, uisInputChangedConn, uisInputEndedConn

	-- Placeholder lists/maps to register draggable/resizable elements
	-- MakeDraggable will add to this: {topbar = objectToDrag}
	local draggableElements = {}
	-- MakeResizable will add to this: {resizeHandle = {objectToResize = object, saveFlag = flag, api = api}}
	local resizableElements = {}

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

	-- Centralized Input Handling Variables for window drag/resize
	local isWindowDragging = false
	local isWindowResizing = false
	local windowDragTarget = nil      -- The main frame being dragged (e.g., DropShadowHolder)
	local windowDragInitiator = nil   -- The specific topbar element that initiated the drag (e.g., Top)
	local windowResizeTarget = nil    -- The main frame being resized (e.g., Main)
	local windowResizeInitiator = nil -- The specific resize handle that initiated resizing

	local windowDragStartMouse = Vector2.new()
	local windowDragStartPos = UDim2.new()
	local windowResizeStartMouse = Vector2.new()
	local windowResizeStartSize = UDim2.new()

	local uisInputBeganConn, uisInputChangedConn, uisInputEndedConn

	local draggableElements = {} -- Key: topbarInstance, Value: {objectToDrag = frameInstance}
	local resizableElements = {} -- Key: resizeHandleInstance, Value: {objectToResize = frameInstance, saveFlag = "flagName", api = {handleSizeChange = func}}

	-- Setup UserInputService connections for centralized drag/resize
	if UserInputService then
		uisInputBeganConn = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if draggableElements[input.Target] then
					isWindowDragging = true
					windowDragInitiator = input.Target
					windowDragTarget = draggableElements[input.Target].objectToDrag
					windowDragStartMouse = input.Position
					windowDragStartPos = windowDragTarget.Position
				elseif resizableElements[input.Target] then
					local resizeData = resizableElements[input.Target]
					isWindowResizing = true
					windowResizeInitiator = input.Target
					windowResizeTarget = resizeData.objectToResize
					windowResizeStartMouse = input.Position
					windowResizeStartSize = windowResizeTarget.Size
				end
			end
		end)

		uisInputChangedConn = UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				if isWindowDragging and windowDragTarget then
					local delta = input.Position - windowDragStartMouse
					local newPos = UDim2.new(windowDragStartPos.X.Scale, windowDragStartPos.X.Offset + delta.X,
											 windowDragStartPos.Y.Scale, windowDragStartPos.Y.Offset + delta.Y)
					if TweenService then
						local currentTween = windowDragTarget:FindFirstChild("WindowDragTween")
						if currentTween then currentTween:Cancel(); currentTween:Destroy() end
						local tween = TweenService:Create(windowDragTarget, TweenInfo.new(0.03, Enum.EasingStyle.Linear), {Position = newPos})
						tween.Name = "WindowDragTween"
						tween.Parent = windowDragTarget
						tween:Play()
					else
						windowDragTarget.Position = newPos
					end
				elseif isWindowResizing and windowResizeTarget then
					local delta = input.Position - windowResizeStartMouse
					local resizeData = resizableElements[windowResizeInitiator]
					local newWidth = math.max(windowResizeStartSize.X.Offset + delta.X, 50)
					local newHeight = math.max(windowResizeStartSize.Y.Offset + delta.Y, 50)

					if resizeData and resizeData.api and resizeData.api.handleSizeChange then
						resizeData.api.handleSizeChange(UDim2.new(0, newWidth, 0, newHeight))
					else
						windowResizeTarget.Size = UDim2.new(0, newWidth, 0, newHeight)
						if resizeData and resizeData.saveFlag then
							SaveFile(resizeData.saveFlag, string.format("%d,%d", newWidth, newHeight))
							if resizeData.saveFlag == "UI_Size" then
								SaveFile("Blur", string.format("%d,%d", newWidth, newHeight))
							end
						end
					end
				end
			end
		end)

		uisInputEndedConn = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if isWindowDragging then
					isWindowDragging = false
					local currentTween = windowDragTarget and windowDragTarget:FindFirstChild("WindowDragTween")
					if currentTween then currentTween:Cancel(); currentTween:Destroy() end
					windowDragTarget = nil
					windowDragInitiator = nil
				end
				if isWindowResizing then
					isWindowResizing = false
					windowResizeTarget = nil
					windowResizeInitiator = nil
				end
			end
		end)
	end
	-- End of Centralized Input Handling Setup

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
			task.defer(function() -- Changed task.delay(0,...) to task.defer(...)
				ParagraphTitle.Size = UDim2.new(1, -16, 0, ParagraphTitle.TextBounds.Y); Paragraph.Size = UDim2.new(1,0,0, ParagraphTitle.TextBounds.Y + 20); SectionObject._UpdateSizeSection()
			end)
			function ParagraphFunc:Set(pConfig)
				ParagraphTitle.Text = (pConfig.Title or "T") .. " | " .. (pConfig.Content or "C");
				task.defer(function() -- Changed task.delay(0,...) to task.defer(...)
					ParagraphTitle.Size = UDim2.new(1,-16,0,ParagraphTitle.TextBounds.Y); Paragraph.Size = UDim2.new(1,0,0,ParagraphTitle.TextBounds.Y + 20); SectionObject._UpdateSizeSection()
				end)
			end
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
			ActualButton.Activated:Connect(function() circleClickFunc(ActualButton, mouseRef.X, mouseRef.Y); currentValue = not currentValue; if ToggleConfig.Flag then saveFileFunc(ToggleConfig.Flag, currentValue) end; ToggleConfig.Callback(currentValue); setToggleVisual(currentValue) end)
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
			local Dragger = Instance.new("TextButton", Bar); Dragger.Name = "Dragger"; Dragger.Text = ""; Dragger.Size = UDim2.new(0,10,0,10); Dragger.AnchorPoint = Vector2.new(0.5,0.5); Dragger.BackgroundColor3 = getColorFunc("ThemeHighlight", Dragger, "BackgroundColor3"); Dragger.BorderSizePixel = 0; Instance.new("UICorner", Dragger).CornerRadius = UDim.new(0,100); Dragger.ZIndex = 2

			local DraggerHitbox = Instance.new("TextButton", Bar) -- Larger hitbox
			DraggerHitbox.Name = "DraggerHitbox"
			DraggerHitbox.Text = ""
			DraggerHitbox.Size = UDim2.new(0, 20, 0, 20) -- Larger size for easier clicking
			DraggerHitbox.AnchorPoint = Vector2.new(0.5, 0.5)
			DraggerHitbox.BackgroundTransparency = 1 -- Invisible
			DraggerHitbox.ZIndex = Dragger.ZIndex + 1 -- Ensure it's on top of the visual dragger if necessary, or handle input priority.
			DraggerHitbox.BorderSizePixel = 0

			local currentValue = SliderConfig.Default
			local function UpdateSlider(value)
				value = math.clamp(math.floor(value/SliderConfig.Increment + 0.5) * SliderConfig.Increment, SliderConfig.Min, SliderConfig.Max);
				currentValue = value;
				SliderValueText.Text = tostring(value);
				local percent = (SliderConfig.Max - SliderConfig.Min == 0) and 0 or (value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min);
				Progress.Size = UDim2.new(percent,0,1,0);
				Dragger.Position = UDim2.new(percent,0,0.5,0);
				DraggerHitbox.Position = Dragger.Position -- Keep hitbox centered on visual dragger
				if SliderConfig.Flag then saveFileFunc(SliderConfig.Flag, currentValue) end;
				SliderConfig.Callback(currentValue)
			end
			UpdateSlider(currentValue)

			DraggerHitbox.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then local dragging = true; local conn; conn = UserInputService.InputChanged:Connect(function(subInput) if not dragging then conn:Disconnect() return end; if subInput.UserInputType == Enum.UserInputType.MouseMovement or subInput.UserInputType == Enum.UserInputType.Touch then local localPos = Bar.AbsolutePosition.X; local mousePos = subInput.Position.X; local percent = math.clamp((mousePos - localPos) / Bar.AbsoluteSize.X, 0, 1); UpdateSlider(SliderConfig.Min + percent * (SliderConfig.Max - SliderConfig.Min)) end end); DraggerHitbox.InputEnded:Connect(function() dragging = false conn:Disconnect() end) end end)
			SliderValueText.FocusLost:Connect(function() -- Removed enterPressed condition
				local num = tonumber(SliderValueText.Text)
				if num then
					UpdateSlider(num)
				else
					UpdateSlider(currentValue) -- Revert to last valid value if input is not a number
				end
			end)
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
			TextBox.FocusLost:Connect(function() -- Removed enterPressed condition
				currentValue = TextBox.Text
				if InputConfig.Flag then saveFileFunc(InputConfig.Flag, currentValue) end
				InputConfig.Callback(currentValue)
				-- No explicit revert logic here as AddInput usually accepts any text.
				-- If specific validation and revert were needed, it would be more complex.
			end)
			task.delay(0, function() local contentHeight = InputContent.TextBounds.Y; local titleHeight = InputTitle.TextBounds.Y; InputFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15)); SectionObject._UpdateSizeSection() end)
			CountItem = CountItem + 1; return { GetValue = function() return currentValue end, SetValue = function(val) currentValue = val; TextBox.Text = val; if InputConfig.Flag then saveFileFunc(InputConfig.Flag, currentValue) end; InputConfig.Callback(currentValue) end }
		end

		function SectionObject:AddDropdown(DropdownConfig)
			local DropdownConfig = DropdownConfig or {}
			DropdownConfig.Title = DropdownConfig.Title or "No Title"; DropdownConfig.Content = DropdownConfig.Content or ""; DropdownConfig.Multi = DropdownConfig.Multi or false; DropdownConfig.Options = DropdownConfig.Options or {};
			local savedValue = DropdownConfig.Flag and flagsRef[DropdownConfig.Flag] -- This will now always be a table if it exists from save

			-- Standardized default value handling:
			-- If savedValue exists (it will be a table), use it.
			-- Else, if DropdownConfig.Default is already a table (developer-provided default), use it.
			-- Else, default to an empty table.
			if savedValue ~= nil and type(savedValue) == "table" then
				DropdownConfig.Default = savedValue
			elseif type(DropdownConfig.Default) == "table" then
				-- Developer provided a table as default, use it
				DropdownConfig.Default = DropdownConfig.Default
			else
				-- Neither savedValue nor a table default from dev, so use empty table or single option if not multi
				if DropdownConfig.Multi then
					DropdownConfig.Default = {}
				else -- Single select, try to pick first option or make it empty table if no specific default string given
					DropdownConfig.Default = (type(DropdownConfig.Default) == "string" and {DropdownConfig.Default}) or {}
				end
			end

			DropdownConfig.Callback = DropdownConfig.Callback or function() end
			local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options} -- Value is now consistently a table
			local DropdownFrame = Instance.new("Frame"); DropdownFrame.Name = "Dropdown"; DropdownFrame.Parent = SectionObject._SectionAdd; DropdownFrame.LayoutOrder = CountItem; DropdownFrame.Size = UDim2.new(1,0,0,46); DropdownFrame.BackgroundTransparency = 0.935; DropdownFrame.BackgroundColor3 = getColorFunc("Secondary", DropdownFrame, "BackgroundColor3"); Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0,4)
			local DropdownTitle = Instance.new("TextLabel", DropdownFrame); DropdownTitle.Name = "DropdownTitle"; DropdownTitle.Font = Enum.Font.GothamBold; DropdownTitle.Text = DropdownConfig.Title; DropdownTitle.TextColor3 = getColorFunc("Text", DropdownTitle, "TextColor3"); DropdownTitle.TextSize = 13; DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left; DropdownTitle.TextYAlignment = Enum.TextYAlignment.Top; DropdownTitle.BackgroundTransparency=1; DropdownTitle.Position = UDim2.new(0,10,0,10); DropdownTitle.Size = UDim2.new(1,-180,0,13)
			local DropdownContent = Instance.new("TextLabel", DropdownFrame); DropdownContent.Name = "DropdownContent"; DropdownContent.Font = Enum.Font.Gotham; DropdownContent.Text = DropdownConfig.Content; DropdownContent.TextColor3 = getColorFunc("Text", DropdownContent, "TextColor3"); DropdownContent.TextSize = 12; DropdownContent.TextTransparency = 0.4; DropdownContent.TextWrapped = true; DropdownContent.TextXAlignment = Enum.TextXAlignment.Left; DropdownContent.TextYAlignment = Enum.TextYAlignment.Bottom; DropdownContent.BackgroundTransparency=1; DropdownContent.Position = UDim2.new(0,10,0,0); DropdownContent.Size = UDim2.new(1,-180,1,-10)
			local SelectOptionsFrame = Instance.new("Frame", DropdownFrame); SelectOptionsFrame.Name = "SelectOptionsFrame"; SelectOptionsFrame.AnchorPoint = Vector2.new(1,0.5); SelectOptionsFrame.BackgroundColor3 = getColorFunc("Primary", SelectOptionsFrame, "BackgroundColor3"); SelectOptionsFrame.BackgroundTransparency = 0.95; SelectOptionsFrame.BorderSizePixel = 0; SelectOptionsFrame.Position = UDim2.new(1,-7,0.5,0); SelectOptionsFrame.Size = UDim2.new(0,148,0,30); Instance.new("UICorner",SelectOptionsFrame).CornerRadius = UDim.new(0,4)
			local OptionSelecting = Instance.new("TextLabel",SelectOptionsFrame); OptionSelecting.Name = "OptionSelecting"; OptionSelecting.Font = Enum.Font.Gotham; OptionSelecting.TextColor3 = getColorFunc("Text", OptionSelecting, "TextColor3"); OptionSelecting.TextSize = 12; OptionSelecting.TextTransparency = 0.4; OptionSelecting.TextWrapped = true; OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left; OptionSelecting.AnchorPoint = Vector2.new(0,0.5); OptionSelecting.BackgroundTransparency = 1; OptionSelecting.Position = UDim2.new(0,5,0.5,0); OptionSelecting.Size = UDim2.new(1,-30,1,-8)
			local OptionImg = Instance.new("ImageLabel",SelectOptionsFrame); OptionImg.Name = "OptionImg"; OptionImg.Image = loadUIAssetFunc("rbxassetid://16851841101", "DropdownArrow_Internal"); OptionImg.ImageColor3 = getColorFunc("Text", OptionImg, "ImageColor3"); OptionImg.AnchorPoint = Vector2.new(1,0.5); OptionImg.BackgroundTransparency=1; OptionImg.Position = UDim2.new(1,0,0.5,0); OptionImg.Size = UDim2.new(0,25,0,25)
			local DropdownButton = Instance.new("TextButton", DropdownFrame); DropdownButton.Name = "DropdownButton"; DropdownButton.Text = ""; DropdownButton.Size = UDim2.new(1,0,1,0); DropdownButton.BackgroundTransparency = 1

			local currentDropdownID = CountDropdown; CountDropdown = CountDropdown + 1;
			SelectOptionsFrame.LayoutOrder = currentDropdownID

			local DropdownContainer = DropdownFolder:FindFirstChild("DropdownContainer_"..tostring(currentDropdownID))
			if not DropdownContainer then
				DropdownContainer = Instance.new("Frame", DropdownFolder); DropdownContainer.Name = "DropdownContainer_"..tostring(currentDropdownID);
				DropdownContainer.BackgroundTransparency = 1; DropdownContainer.Size = UDim2.new(1,0,1,0);
				local SearchBar_Dropdown = Instance.new("TextBox", DropdownContainer); SearchBar_Dropdown.Name = "SearchBar_Dropdown"; SearchBar_Dropdown.Font = Enum.Font.GothamBold; SearchBar_Dropdown.PlaceholderText = "🔎 Search"; SearchBar_Dropdown.PlaceholderColor3 = getColorFunc("Text", SearchBar_Dropdown, "PlaceholderColor3"); SearchBar_Dropdown.Text = ""; SearchBar_Dropdown.TextColor3 = getColorFunc("Text", SearchBar_Dropdown, "TextColor3"); SearchBar_Dropdown.TextSize = 12; SearchBar_Dropdown.BackgroundColor3 = getColorFunc("Secondary", SearchBar_Dropdown, "BackgroundColor3"); SearchBar_Dropdown.BackgroundTransparency = 0; SearchBar_Dropdown.BorderColor3 = getColorFunc("Stroke", SearchBar_Dropdown, "BorderColor3"); SearchBar_Dropdown.BorderSizePixel = 1; SearchBar_Dropdown.Size = UDim2.new(1,-10,0,25); SearchBar_Dropdown.Position = UDim2.new(0,5,0,5)
				local ScrollSelect = Instance.new("ScrollingFrame", DropdownContainer); ScrollSelect.Name = "ScrollSelect"; ScrollSelect.CanvasSize = UDim2.new(0,0,0,0); ScrollSelect.ScrollBarThickness = 0; ScrollSelect.Active = true; ScrollSelect.Position = UDim2.new(0,0,0,35); ScrollSelect.BackgroundTransparency=1; ScrollSelect.Size = UDim2.new(1,0,1,-35)
				local UIListLayout_Scroll = Instance.new("UIListLayout", ScrollSelect); UIListLayout_Scroll.Padding = UDim.new(0,3); UIListLayout_Scroll.SortOrder = Enum.SortOrder.LayoutOrder
				SearchBar_Dropdown:GetPropertyChangedSignal("Text"):Connect(function() local s = SearchBar_Dropdown.Text:lower(); for _,oF in ipairs(ScrollSelect:GetChildren()) do if oF:IsA("Frame") and oF.Name == "Option" then local oT = oF:FindFirstChild("OptionText"); if oT then oF.Visible = (s == "" or oT.Text:lower():find(s,1,true)) end end end end)
			end
			local SearchBar_Dropdown = DropdownContainer.SearchBar_Dropdown
			local ScrollSelect = DropdownContainer.ScrollSelect
			local UIListLayout_Scroll = ScrollSelect:FindFirstChildOfClass("UIListLayout")

			DropdownButton.Activated:Connect(function() circleClickFunc(DropdownButton, mouseRef.X, mouseRef.Y); if not MoreBlur.Visible then MoreBlur.Visible = true; DropPageLayout:JumpTo(DropdownContainer); tweenServiceRef:Create(MoreBlur, TweenInfo.new(0.2),{BackgroundTransparency = 0.7}):Play(); tweenServiceRef:Create(DropdownSelect, TweenInfo.new(0.2),{Position = UDim2.new(1,-11,0.5,0)}):Play() end end)

			local dropCountLocal = 0;
			function DropdownFunc:Clear() for i=#ScrollSelect:GetChildren(),1,-1 do local c = ScrollSelect:GetChildren()[i]; if c.Name == "Option" then c:Destroy() end end; DropdownFunc.Value={}; DropdownFunc.Options={}; OptionSelecting.Text = "Select Options"; dropCountLocal = 0; ScrollSelect.CanvasSize = UDim2.new(0,0,0,0); end
			function DropdownFunc:AddOption(oN)
				oN = oN or "Option"; local oF = Instance.new("Frame",ScrollSelect); oF.Name="Option"; oF.Size=UDim2.new(1,0,0,30); oF.BackgroundTransparency=0.97; oF.BackgroundColor3=getColorFunc("Secondary",oF,"BackgroundColor3"); Instance.new("UICorner",oF).CornerRadius=UDim.new(0,3); local oB=Instance.new("TextButton",oF); oB.Name="OptionButton"; oB.Text=""; oB.Size=UDim2.new(1,0,1,0); oB.BackgroundTransparency=1; local oT=Instance.new("TextLabel",oF); oT.Name="OptionText"; oT.Font=Enum.Font.Gotham; oT.Text=oN; oT.TextColor3=getColorFunc("Text",oT,"TextColor3"); oT.TextSize=13; oT.TextXAlignment=Enum.TextXAlignment.Left; oT.BackgroundTransparency=1; oT.Position=UDim2.new(0,8,0,0); oT.Size=UDim2.new(1,-16,1,0); local cF=Instance.new("Frame",oF); cF.Name="ChooseFrame"; cF.AnchorPoint=Vector2.new(0,0.5); cF.BackgroundColor3=getColorFunc("ThemeHighlight",cF,"BackgroundColor3"); cF.BorderSizePixel=0; cF.Position=UDim2.new(0,2,0.5,0); cF.Size=UDim2.new(0,0,0,0); Instance.new("UICorner",cF).CornerRadius=UDim.new(0,3); local cS=Instance.new("UIStroke",cF); cS.Color=getColorFunc("Secondary",cS,"Color"); cS.Thickness=1.6; cS.Transparency=1; dropCountLocal=dropCountLocal+1; oF.LayoutOrder=dropCountLocal;
				oB.Activated:Connect(function() circleClickFunc(oB, mouseRef.X, mouseRef.Y); if DropdownConfig.Multi then local fI=table.find(DropdownFunc.Value,oN); if fI then table.remove(DropdownFunc.Value,fI) else table.insert(DropdownFunc.Value,oN) end else DropdownFunc.Value={oN} end; DropdownFunc:Set(DropdownFunc.Value); if DropdownConfig.Flag then saveFileFunc(DropdownConfig.Flag, DropdownFunc.Value) end end)
				-- Optimized CanvasSize update:
				task.defer(function() ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_Scroll.AbsoluteContentSize.Y) end)
			end;
			function DropdownFunc:Set(val) if val then local nV=type(val)=="table" and val or {val}; local uV={}; for _,v_u in ipairs(nV) do if not table.find(uV,v_u) then table.insert(uV,v_u) end end; DropdownFunc.Value=uV end; for _,d_S in ipairs(ScrollSelect:GetChildren()) do if d_S:IsA("Frame") and d_S.Name=="Option" then local iTF=DropdownFunc.Value and table.find(DropdownFunc.Value,d_S.OptionText.Text); local tII=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut); local s_S=iTF and UDim2.new(0,1,0,12) or UDim2.new(0,0,0,0); local bT_S=iTF and 0.935 or 0.97; local tr_S=iTF and 0 or 1; tweenServiceRef:Create(d_S.ChooseFrame,tII,{Size=s_S}):Play(); tweenServiceRef:Create(d_S.ChooseFrame.UIStroke,tII,{Transparency=tr_S}):Play(); tweenServiceRef:Create(d_S,tII,{BackgroundTransparency=bT_S}):Play() end end; local dT=(DropdownFunc.Value and #DropdownFunc.Value>0) and table.concat(DropdownFunc.Value,", ") or "Select Options"; OptionSelecting.Text=dT; if DropdownConfig.Callback then DropdownConfig.Callback(DropdownFunc.Value or {}) end;
			end;
			function DropdownFunc:Refresh(rL,sEl) local cV=savedValue or DropdownConfig.Default; rL=rL or {}; sEl=sEl or cV; DropdownFunc:Clear(); DropdownFunc.Options=rL; for _,oR in pairs(rL) do DropdownFunc:AddOption(oR) end; DropdownFunc.Value=nil; DropdownFunc:Set(sEl); end;
			DropdownFunc:Refresh(DropdownConfig.Options, DropdownConfig.Default)
			task.delay(0, function() local contentHeight = DropdownContent.TextBounds.Y; local titleHeight = DropdownTitle.TextBounds.Y; DropdownFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15)); SectionObject._UpdateSizeSection() end)
			CountItem = CountItem + 1; return DropdownFunc;
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
		-- All table types (arrays, empty tables, dictionaries) will be saved as is.
		-- No special handling to extract single element from array.
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

	-- Load last theme on startup
	local themeToLoadOnStartup = Flags.LastThemeName
	if themeToLoadOnStartup then
		local customThemeData = Flags.LastCustomThemeData
		if customThemeData and ( (Flags.CustomUserThemes and Flags.CustomUserThemes[themeToLoadOnStartup]) or themeToLoadOnStartup == "__customApplied" or themeToLoadOnStartup == "__loadedStartupTheme" or not Themes[themeToLoadOnStartup] ) then
			-- If custom data exists AND (it's a known custom theme OR it was saved as __customApplied OR it was a previously loaded startup theme OR it's not a default theme anymore)
			-- Then prioritize loading this custom data.
			Themes["__loadedStartupTheme"] = deepcopy(customThemeData) -- Ensure deepcopy is available
			SetTheme("__loadedStartupTheme")
		elseif Themes[themeToLoadOnStartup] then
			-- It's a default theme name, and no overriding custom data was indicated for it.
			SetTheme(themeToLoadOnStartup)
		else
			-- Fallback if theme name is unknown and no applicable custom data.
			SetTheme(CurrentTheme) -- CurrentTheme is initialized to "UB_Orange" or similar
		end
	else
		-- No LastThemeName saved, use initial default.
		SetTheme(CurrentTheme)
	end

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
			SaveFlag = saveFlag,
			handleSizeChange = nil -- Will be assigned below
			-- SetSize function will remain as part of the API
		}

		local function handleSizeChange(newSize) -- This function will be called by the central handler
			object.Size = newSize
			resizeAPI.CurrentSize = newSize -- Update API's current size
			if saveFlag then
				local sizeString = string.format("%d,%d", newSize.X.Offset, newSize.Y.Offset)
				SaveFile(saveFlag, sizeString)
				if saveFlag == "UI_Size" then -- Special case for main UI size affecting Blur
					SaveFile("Blur", sizeString)
				end
			end
		end
		resizeAPI.handleSizeChange = handleSizeChange

		-- Register this resizeHandle and its associated data with the centralized handler
		if resizeHandle and object then
			resizableElements[resizeHandle] = {
				objectToResize = object,
				saveFlag = saveFlag,
				api = resizeAPI -- Pass the api so central handler can call handleSizeChange
			}
		else
			warn("MakeResizable: resizeHandle or object is nil")
		end
		-- Removed internal InputBegan and UserInputService.InputChanged connections for the handle.

		function resizeAPI:SetSize(newSize)
			local validatedWidth = math.max(newSize.X.Offset, 50)
			local validatedHeight = math.max(newSize.Y.Offset, 50)
			handleSizeChange(UDim2.new(0, validatedWidth, 0, validatedHeight))
		end
		return resizeAPI
	end
	local UBHubGui = Instance.new("ScreenGui");
	ProtectGui(UBHubGui) -- Protect the GUI
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
	else
		Main.Size = SizeUI -- Ensure Main has an initial size if not loaded
	end

	-- Initial DropShadowHolder Sizing based on Main's size
	DropShadowHolder.Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset + 47, Main.Size.Y.Scale, Main.Size.Y.Offset + 47)
	DropShadowHolder.Position = UDim2.new(0, math.floor(UBHubGui.AbsoluteSize.X / 2 - DropShadowHolder.AbsoluteSize.X / 2), 0, math.floor(UBHubGui.AbsoluteSize.Y / 2 - DropShadowHolder.AbsoluteSize.Y / 2))


	-- Connect DropShadowHolder resizing to Main's size changes
	Main:GetPropertyChangedSignal("Size"):Connect(function()
		DropShadowHolder.Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset + 47, Main.Size.Y.Scale, Main.Size.Y.Offset + 47)
		-- Recenter DropShadowHolder if its size changes significantly, assuming it's not anchored in a way that auto-centers.
		-- However, DropShadowHolder is the draggable element, so its position is user-controlled.
		-- Its position should only be set initially or when restoring from minimize.
	end)

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

	--// Settings Page Frame (ensure it's defined before CreateTab is called for settings)
	local SettingsPage = Instance.new("ScrollingFrame")
	SettingsPage.Name = "SettingsPage"
	SettingsPage.Size = Layers.Size -- Match the main content area size
	SettingsPage.Position = Layers.Position -- Match the main content area position
	SettingsPage.BackgroundTransparency = 0.999 -- Similar to LayersReal
	SettingsPage.BorderSizePixel = 0
	SettingsPage.Visible = false -- Initially hidden
	SettingsPage.Parent = Main
	SettingsPage.ScrollBarThickness = 6
	SettingsPage.ScrollingDirection = Enum.ScrollingDirection.Y
	SettingsPage.CanvasSize = UDim2.new(0,0,0,0) -- Initial canvas size

	local SettingsPageLayout = Instance.new("UIListLayout") -- UIListLayout for settings page content
	SettingsPageLayout.Parent = SettingsPage
	SettingsPageLayout.Padding = UDim.new(0, 5)
	SettingsPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SettingsPageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

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
	-- Adjusted ScrollTab Size: Original Y Scale 1, Offset -50.
	-- New Y Offset = -50 (original) - 40 (for settings tab) - 1 (for separator) = -91
	ScrollTab.Size = UDim2.new(1, 0, 1, -91)
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = LayersTab

	UIListLayout.Padding = UDim.new(0, 3)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = ScrollTab

	local function UpdateSize1()
		local OffsetY = 0
		for _, child in ScrollTab:GetChildren() do
			if child.Name ~= "UIListLayout" and child:IsA("Frame") then
				OffsetY = OffsetY + UIListLayout.Padding.Offset + child.Size.Y.Offset
			end
		end
		if #ScrollTab:GetChildren() > 1 then
			OffsetY = OffsetY - UIListLayout.Padding.Offset
		end
		ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
	end
	ScrollTab.ChildAdded:Connect(UpdateSize1)
	ScrollTab.ChildRemoved:Connect(UpdateSize1)

	-- Removing the old Info, LogoPlayer, NamePlayerButton, and their direct click logic.
	-- The variables isSettingsViewActive, lastSelectedTabName will be defined fresh for the new system.
	-- customizeButtonHighlighted is also removed as its role is covered by isSettingsViewActive and tab instance checks.

	local isSettingsViewActive = false -- Will be managed by tab click logic
	local lastSelectedTabName = ""   -- For restoring NameTab.Text
	local customizeButtonInstance = nil -- To store the Frame of the Customize tab for highlight management

	-- Define the actual Tab creation function and related variables here
	-- CountTab and CountDropdown are now global to the library script
	local ScrolLayersMap = {}
	local FrameToTabObjectMap = {} -- New map: Frame Instance -> TabObject

	-- The UIInstance:CreateTab function definition is here (as modified in Step 1)
	-- ... (Full UIInstance:CreateTab function code, already modified) ...
	-- Make sure the full function UIInstance:CreateTab is correctly placed above its first call.

	-- After UIInstance:CreateTab is defined:
	-- Create the Separator Line
	local SeparatorLine = Instance.new("Frame")
	SeparatorLine.Name = "SeparatorLine"
	SeparatorLine.Parent = LayersTab -- Parent to LayersTab
	SeparatorLine.Size = UDim2.new(1, 0, 0, 1)
	SeparatorLine.BackgroundColor3 = GetColor("Stroke")
	SeparatorLine.BorderSizePixel = 0
	SeparatorLine.LayoutOrder = 998 -- Visually just above the CustomizeTab
	SeparatorLine.Position = UDim2.new(0, 0, 1, -41) -- Positioned above the 40px settings tab

	-- Create the Customize Tab using the enhanced API
	local CustomizeTabObject = UIInstance:CreateTab({
		Name = "Customize",
		Icon = "rbxassetid://126800841735072",
		IsSettingsTab = true
	})
	if CustomizeTabObject then -- Ensure it was created
		customizeButtonInstance = CustomizeTabObject.Instance
		-- Settings population code removed from here. Will be pasted and adapted later.
	end

	-- The old direct population of SettingsPage (local PresetsSection = SettingsTab:AddSection("Presets") etc.)
	-- has been removed by the previous diff. That content will be added via CustomizeTabObject:AddSection in a later step.

	-- Create Separator Line (Done before creating the Customize Tab itself, but after ScrollTab is defined)
	local SeparatorLine = Instance.new("Frame", LayersTab) -- Parent directly
	SeparatorLine.Name = "SeparatorLine"
	SeparatorLine.Size = UDim2.new(1, 0, 0, 1)
	SeparatorLine.BackgroundColor3 = GetColor("Stroke")
	SeparatorLine.BorderSizePixel = 0
	SeparatorLine.LayoutOrder = 998 -- Just above the settings tab button visually, if LayersTab had a UIListLayout (which it doesn't directly manage like this)
	-- For manual positioning, LayoutOrder is less critical than Position.
	-- Position it to be just above the CustomizeTab (which is 40px high and at the bottom of LayersTab)
	SeparatorLine.Position = UDim2.new(0, 0, 1, -41) -- AnchorPoint (0,1) for LayersTab items from bottom
	SeparatorLine.AnchorPoint = Vector2.new(0,1)


	-- Create the Customize Tab using our API
	local CustomizeTab = UIInstance:CreateTab({
		Name = "Customize",
		Icon = "rbxassetid://126800841735072",
		IsSettingsTab = true
	})
	-- customizeButtonInstance is already declared in MakeGui scope, assign if CustomizeTab was created.
	if CustomizeTab and CustomizeTab.Instance then
		customizeButtonInstance = CustomizeTab.Instance
	end

	-- Settings Population Code (Pasted and Adapted)
	if CustomizeTab then -- Ensure CustomizeTab object exists before trying to add sections to it
		-- Helper functions for settings population (should be within MakeGui scope or passed appropriately)
		-- Note: deepcopy, SaveFile, GetColor, SetTheme, LoadUIAsset, UBHubLib:MakeNotify, Flags, Themes, CurrentTheme etc. are assumed to be in MakeGui's scope or accessible.

		local activeColorSliders = {} -- For Customize Colors section

		local function Color3ToHex(color3)
			if not color3 then return "000000" end
			return string.format("%02x%02x%02x", math.floor(color3.R * 255), math.floor(color3.G * 255), math.floor(color3.B * 255))
		end

		local function HexToColor3(hex)
			hex = hex:gsub("#", "")
			if #hex ~= 6 then return nil end
			local r = tonumber(hex:sub(1,2), 16)
			local g = tonumber(hex:sub(3,4), 16)
			local b = tonumber(hex:sub(5,6), 16)
			if r and g and b then
				return Color3.fromRGB(r, g, b)
			else
				return nil
			end
		end
		
		local function updateAllColorControls()
			if not SettingsPage.Visible then return end -- Only update if visible
			for key, controls in pairs(activeColorSliders) do
				if Themes[CurrentTheme] and Themes[CurrentTheme][key] then
					local currentColor = Themes[CurrentTheme][key]
					if controls.rSlider:GetValue() ~= math.floor(currentColor.R * 255) then controls.rSlider:SetValue(math.floor(currentColor.R * 255)) end
					if controls.gSlider:GetValue() ~= math.floor(currentColor.G * 255) then controls.gSlider:SetValue(math.floor(currentColor.G * 255)) end
					if controls.bSlider:GetValue() ~= math.floor(currentColor.B * 255) then controls.bSlider:SetValue(math.floor(currentColor.B * 255)) end
					if controls.hexInput:GetValue() ~= Color3ToHex(currentColor) then controls.hexInput:SetValue(Color3ToHex(currentColor)) end
				end
			end
		end

		-- Hook into SetTheme to update color controls
		local originalSetTheme_Settings = SetTheme -- Keep original SetTheme if not already aliased
		SetTheme = function(themeName)
			originalSetTheme_Settings(themeName) -- Call original
			if isSettingsViewActive or (CurrentTheme == "__customApplied" and SettingsPage.Visible) then -- Update if settings are visible or custom theme applied
				task.delay(0.05, updateAllColorControls) -- Delay slightly
			end
		end

		local function createColorEditor(section, colorKeyName, initialColor3) -- Takes section object
			section:AddDivider({Text = colorKeyName})
			local r, g, b = math.floor(initialColor3.R * 255), math.floor(initialColor3.G * 255), math.floor(initialColor3.B * 255)

			local hexInput = section:AddInput({
				Title = "Hex Code", Content = "e.g., #FF0000 or FF0000", Default = Color3ToHex(initialColor3),
				Callback = function(hexValue)
					local newColor = HexToColor3(hexValue)
					if newColor then
						Themes[CurrentTheme][colorKeyName] = newColor
						SetTheme(CurrentTheme)
					else
						hexInput:SetValue(Color3ToHex(Themes[CurrentTheme][colorKeyName]))
						UBHubLib:MakeNotify({Title = "Color Error", Description = "Invalid hex code."})
					end
				end
			})
			local rSlider = section:AddSlider({
				Title = "Red", Min = 0, Max = 255, Increment = 1, Default = r,
				Callback = function(newR)
					local oldColor = Themes[CurrentTheme][colorKeyName]
					Themes[CurrentTheme][colorKeyName] = Color3.fromRGB(newR, math.floor(oldColor.G * 255), math.floor(oldColor.B * 255))
					hexInput:SetValue(Color3ToHex(Themes[CurrentTheme][colorKeyName]))
					SetTheme(CurrentTheme)
				end
			})
			local gSlider = section:AddSlider({
				Title = "Green", Min = 0, Max = 255, Increment = 1, Default = g,
				Callback = function(newG)
					local oldColor = Themes[CurrentTheme][colorKeyName]
					Themes[CurrentTheme][colorKeyName] = Color3.fromRGB(math.floor(oldColor.R * 255), newG, math.floor(oldColor.B * 255))
					hexInput:SetValue(Color3ToHex(Themes[CurrentTheme][colorKeyName]))
					SetTheme(CurrentTheme)
				end
			})
			local bSlider = section:AddSlider({
				Title = "Blue", Min = 0, Max = 255, Increment = 1, Default = b,
				Callback = function(newB)
					local oldColor = Themes[CurrentTheme][colorKeyName]
					Themes[CurrentTheme][colorKeyName] = Color3.fromRGB(math.floor(oldColor.R * 255), math.floor(oldColor.G * 255), newB)
					hexInput:SetValue(Color3ToHex(Themes[CurrentTheme][colorKeyName]))
					SetTheme(CurrentTheme)
				end
			})
			activeColorSliders[colorKeyName] = {hexInput = hexInput, rSlider = rSlider, gSlider = gSlider, bSlider = bSlider}
		end

		-- Preset Management Section
		local PresetManagementSection = CustomizeTab:AddSection("Preset Management")
		local defaultThemesDropdown = PresetManagementSection:AddDropdown({
			Title = "Default Themes", Content = "Select a built-in theme", Options = GetThemes(),
			Callback = function(selected) end -- Callback can be empty if using button
		})
		PresetManagementSection:AddButton({
			Title = "Apply Default Theme", Content = "Apply the selected default theme",
			Callback = function()
				local selectedThemeValue = defaultThemesDropdown:GetValue()
				if selectedThemeValue and #selectedThemeValue > 0 then
					SetTheme(selectedThemeValue[1])
					UBHubLib:MakeNotify({Title = "Theme", Description = "Applied " .. selectedThemeValue[1]})
				else
					UBHubLib:MakeNotify({Title = "Theme", Description = "No theme selected."})
				end
			end
		})
		PresetManagementSection:AddDivider({Text = "Preset Settings"})
		local customPresetNameInput = PresetManagementSection:AddInput({
			Title = "Custom Preset Name", Content = "Name for your custom theme", Default = ""
		})
		local savedPresetsDropdown = PresetManagementSection:AddDropdown({
			Title = "Saved Presets", Content = "Select a saved custom theme", Options = {},
			Callback = function(selected) end
		})
		local deletePresetsDropdown = PresetManagementSection:AddDropdown({
			Title = "Saved Presets (for deletion)", Content = "Select preset to delete", Options = {},
			Callback = function(selected) end
		})

		local function refreshSavedPresetsDropdownsScoped() -- Scoped to avoid conflict if global exists
			Flags.CustomUserThemes = Flags.CustomUserThemes or {}
			local savedNames = {}
			for name, _ in pairs(Flags.CustomUserThemes) do table.insert(savedNames, name) end
			table.sort(savedNames)
			savedPresetsDropdown:Refresh(savedNames, savedPresetsDropdown:GetValue())
			deletePresetsDropdown:Refresh(savedNames, deletePresetsDropdown:GetValue())
		end

		PresetManagementSection:AddButton({
			Title = "Save Current Colors", Content = "Save current colors as new preset",
			Callback = function()
				local presetName = customPresetNameInput:GetValue()
				if not presetName or presetName == "" then
					UBHubLib:MakeNotify({Title = "Save Preset", Description = "Preset name cannot be empty."}); return
				end
				Flags.CustomUserThemes = Flags.CustomUserThemes or {}
				Flags.CustomUserThemes[presetName] = deepcopy(Themes[CurrentTheme]) -- deepcopy should be in scope
				SaveFile("CustomUserThemes", Flags.CustomUserThemes)
				refreshSavedPresetsDropdownsScoped()
				UBHubLib:MakeNotify({Title = "Save Preset", Description = "'" .. presetName .. "' saved."})
			end
		})
		refreshSavedPresetsDropdownsScoped() -- Initial population

		PresetManagementSection:AddButton({
			Title = "Apply Saved Preset", Content = "Apply the selected saved theme",
			Callback = function()
				local selectedValue = savedPresetsDropdown:GetValue()
				if selectedValue and #selectedValue > 0 then
					local presetName = selectedValue[1]
					if Flags.CustomUserThemes and Flags.CustomUserThemes[presetName] then
						Themes["__customApplied"] = deepcopy(Flags.CustomUserThemes[presetName])
						SetTheme("__customApplied")
						UBHubLib:MakeNotify({Title = "Theme", Description = "Applied '" .. presetName .. "'"})
					else
						UBHubLib:MakeNotify({Title = "Theme", Description = "Could not find: " .. presetName})
					end
				else
					UBHubLib:MakeNotify({Title = "Theme", Description = "No saved preset selected."})
				end
			end
		})
		PresetManagementSection:AddButton({
			Title = "Delete Saved Preset", Content = "Delete selected saved theme",
			Callback = function()
				local selectedValue = deletePresetsDropdown:GetValue()
				if selectedValue and #selectedValue > 0 then
					local presetName = selectedValue[1]
					if Flags.CustomUserThemes and Flags.CustomUserThemes[presetName] then
						Flags.CustomUserThemes[presetName] = nil
						SaveFile("CustomUserThemes", Flags.CustomUserThemes)
						refreshSavedPresetsDropdownsScoped()
						UBHubLib:MakeNotify({Title = "Delete Preset", Description = "'" .. presetName .. "' deleted."})
					else
						UBHubLib:MakeNotify({Title = "Delete Preset", Description = "Could not find: " .. presetName})
					end
				else
					UBHubLib:MakeNotify({Title = "Delete Preset", Description = "No preset selected."})
				end
			end
		})

		-- Interface Section (Backgrounds etc.)
		local InterfaceSection = CustomizeTab:AddSection("Interface")
		InterfaceSection:AddSlider({
			Title = "Window Transparency", Content = "Adjust background opacity", Min = 0, Max = 100,
			Increment = 1, Default = (Main.BackgroundTransparency or 0.1) * 100, -- Ensure default
			Callback = function(value) ChangeTransparency(value / 100) end,
			Flag = "UI_BackgroundTransparency"
		})
		local bgAssetInput = InterfaceSection:AddInput({
			Title = "Background Asset URL/Path", Content = "Image/video URL or local path",
			Default = Flags["CustomBackgroundURL"] or ""
		})
		InterfaceSection:AddButton({ Title = "Set Image Background", Callback = function()
			local assetUrl = bgAssetInput:GetValue()
			if assetUrl and assetUrl ~= "" then ChangeAsset("Image", assetUrl, "CustomBG_Img"); SaveFile("CustomBackgroundURL", assetUrl); SaveFile("CustomBackgroundType", "Image") end
		end})
		InterfaceSection:AddButton({ Title = "Set Video Background", Callback = function()
			local assetUrl = bgAssetInput:GetValue()
			if assetUrl and assetUrl ~= "" then ChangeAsset("Video", assetUrl, "CustomBG_Vid"); SaveFile("CustomBackgroundURL", assetUrl); SaveFile("CustomBackgroundType", "Video") end
		end})
		InterfaceSection:AddButton({ Title = "Reset Background", Callback = function()
			Reset(); SaveFile("CustomBackgroundURL", ""); SaveFile("CustomBackgroundType", "")
		end})

		-- Customize Colors Section
		local CustomizeColorsSection = CustomizeTab:AddSection("Customize Colors")
		local baseThemeForKeys = Themes.UB_Orange or next(Themes)
		if baseThemeForKeys then
			local sortedKeys = {}
			for key, valType in pairs(baseThemeForKeys) do
				if typeof(valType) == "Color3" then table.insert(sortedKeys, key) end
			end
			table.sort(sortedKeys)
			for _, key_name in ipairs(sortedKeys) do
				if Themes[CurrentTheme][key_name] then -- Ensure current theme has this key
					createColorEditor(CustomizeColorsSection, key_name, Themes[CurrentTheme][key_name])
				end
			end
		end
	end -- End of if CustomizeTab then

	task.defer(function()
		local firstUserTabFrame = nil
		for _, child in ipairs(ScrollTab:GetChildren()) do
			if child:IsA("Frame") and child.Name:match("^TabInstance_") then -- Identifies user tabs
				firstUserTabFrame = child
				break
			end
		end

		if firstUserTabFrame then
			local scrolLayer = ScrolLayersMap[firstUserTabFrame]
			if scrolLayer and scrolLayer:FindFirstChild("TabConfig_Name") then
				local reconstructedTabObject = {
					Instance = firstUserTabFrame,
					_ScrolLayers = scrolLayer,
					_TabConfig = { Name = scrolLayer.TabConfig_Name.Value },
					_IsSettingsTab = false
				}
				UIInstance:SelectTab(reconstructedTabObject)
			else
				warn("Could not select first user tab: ScrolLayer or TabConfig_Name not found for", firstUserTabFrame and firstUserTabFrame.Name)
				NameTab.Text = ""
				SettingsPage.Visible = false
				LayersReal.Visible = true
				if LayersPageLayout and #LayersFolder:GetChildren() > 0 then LayersPageLayout:JumpTo(LayersFolder:GetChildren()[1]) else if LayersPageLayout then LayersPageLayout:Clear() end end
			end
		else
			NameTab.Text = ""
			SettingsPage.Visible = false
			LayersReal.Visible = true
			if LayersPageLayout then LayersPageLayout:Clear() end
		end
	end)

	local GuiFunc = {}
	function GuiFunc:DestroyGui()
		if CoreGui:FindFirstChild("UBHubGui") then 
			UBHubGui:Destroy()
		end
	end
	local OldPos = DropShadowHolder.Position
	local OldSize = DropShadowHolder.Size
	local isMaximized = false -- State variable for maximize/restore
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
		OldPos = DropShadowHolder.Position -- Moved from MaxRestore
		OldSize = DropShadowHolder.Size   -- Moved from MaxRestore
		DropShadowHolder.Visible = false
		DropShadow.Visible = false
        MinimizedIcon.Visible = true
	end)
	MaxRestore.Activated:Connect(function()
		CircleClick(MaxRestore, Mouse.X, Mouse.Y)
		local maximizeIcon = LoadUIAsset("rbxassetid://9886659406", "MaxRestore.png")
		local restoreIcon = LoadUIAsset("rbxassetid://16598400946", "MaxRestoreA.png") -- Assuming 'A' means alternate/restore

		if isMaximized then -- Window was maximized, user wants to restore
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = OldPos}):Play()
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = OldSize}):Play()
			ImageLabel.Image = maximizeIcon
			isMaximized = false
		else -- Window was normal/restored, user wants to maximize
			-- OldPos and OldSize should have been captured when Min button was pressed, or on initial load.
			-- If OldPos/OldSize are not valid here (e.g. user never minimized), it might restore to initial default.
			-- This is acceptable as per current logic flow where Min.Activated captures these.
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)}):Play()
			ImageLabel.Image = restoreIcon
			isMaximized = true
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
	-- DropShadowHolder.Size = UDim2.new(0, 150 + TextLabel.TextBounds.X + 1 + TextLabel1.TextBounds.X, 0, 450) -- Deleted
	MakeDraggable(Top, DropShadowHolder)

	-- Responsive Resizing Logic
	Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local mainAbsSize = Main.AbsoluteSize -- This is the new size of the Main frame itself

		-- Fixed values from original layout
		local topBarHeight = 38
		local layersTabXPadding = 9 -- LayersTab X position offset
		local layersTabWidth = GuiConfig["Tab Width"]
		local layersTabYPos = 50
		local generalBottomMargin = 9
		local paddingBetweenTabsAndContent = 9

		-- Update LayersTab
		-- LayersTab.Position is UDim2.new(0, layersTabXPadding, 0, layersTabYPos) - this is fixed
		LayersTab.Size = UDim2.new(0, layersTabWidth, 0, mainAbsSize.Y - layersTabYPos - generalBottomMargin)

		-- ScrollTab is relative (Scale 1, Offset -41 for Y Size) to LayersTab, so its pixel height will adjust automatically
		-- when LayersTab's absolute Y size changes. No direct update needed for ScrollTab.Size here.
		-- SeparatorLine and CustomizeTab.Instance are also positioned relative to bottom of LayersTab, should be fine.

		-- Update Layers (main content area)
		local layersXPos = layersTabXPadding + layersTabWidth + paddingBetweenTabsAndContent
		-- Layers.Position Y is fixed at layersTabYPos
		Layers.Position = UDim2.new(0, layersXPos, 0, layersTabYPos)
		Layers.Size = UDim2.new(0, mainAbsSize.X - layersXPos - layersTabXPadding, 0, mainAbsSize.Y - layersTabYPos - generalBottomMargin)
														-- Using layersTabXPadding as the right margin for Layers content area

		-- Update SettingsPage (mirrors Layers)
		if SettingsPage then
			SettingsPage.Position = Layers.Position
			SettingsPage.Size = Layers.Size
		end

		-- MoreBlur is parented to Main with scale 1,1 so it auto-resizes.
	end)

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
	MoreBlur.Position = UDim2.new(0, 0, 0, 0) -- Cover full Main area
	MoreBlur.Size = UDim2.new(1, 0, 1, 0) -- Cover full Main area
	MoreBlur.Visible = false
	MoreBlur.Name = "MoreBlur"
	MoreBlur.Parent = Main
	MoreBlur.Size = UDim2.new(1, 0, 1, 0) -- Verified: Should fill parent
	MoreBlur.Position = UDim2.new(0, 0, 0, 0) -- Verified: Should align with parent's top-left
	-- MakeResizable call for MoreBlur and related savedSize logic for "Blur" is confirmed removed from previous steps.
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
	local ScrolLayersMap = {} -- Initialize ScrolLayersMap here
	function UIInstance:CreateTab(TabConfig)
		local TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""
		TabConfig.IsSettingsTab = TabConfig.IsSettingsTab or false -- New parameter

		local ScrolLayers -- This will be the content page for the tab
		local UIListLayout1 -- Layout for the content page

		if TabConfig.IsSettingsTab then
			-- For the settings tab, its content is the existing SettingsPage
			ScrolLayers = SettingsPage
			-- SettingsPage should already have its UIListLayout (SettingsPageLayout)
			UIListLayout1 = SettingsPage:FindFirstChildOfClass("UIListLayout") or SettingsPageLayout
		else
			-- For normal tabs, create a new ScrollingFrame and UIListLayout
			ScrolLayers = Instance.new("ScrollingFrame")
			ScrolLayers.Name = "ScrolLayers_UserTab_" .. TabConfig.Name
			ScrolLayers.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
			ScrolLayers.ScrollBarThickness = 0 -- Default for user tabs
			ScrolLayers.Active = true
			ScrolLayers.LayoutOrder = CountTab -- Used by LayersPageLayout
			ScrolLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ScrolLayers.BackgroundTransparency = 0.9990000128746033
			ScrolLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ScrolLayers.BorderSizePixel = 0
			ScrolLayers.Size = UDim2.new(1, 0, 1, 0)
			ScrolLayers.Parent = LayersFolder

			UIListLayout1 = Instance.new("UIListLayout")
			UIListLayout1.Padding = UDim.new(0, 3)
			UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout1.Parent = ScrolLayers
		end

		local TabConfigNameValue = Instance.new("StringValue")
		TabConfigNameValue.Name = "TabConfig_Name"
		TabConfigNameValue.Value = TabConfig.Name
		TabConfigNameValue.Parent = ScrolLayers -- Parent to the respective content scroller

		local Tab = Instance.new("Frame") -- This is the tab button itself
		local UICorner3 = Instance.new("UICorner")
		local TabButton = Instance.new("TextButton");
		local TabName = Instance.new("TextLabel")
		local FeatureImg = Instance.new("ImageLabel");
		-- UIStroke2 and UICorner4 for ChooseFrame will be handled differently or within normal tab logic

		Tab.Name = "TabInstance_" .. TabConfig.Name -- Make name more unique
		Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Base, will be overridden
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BorderSizePixel = 0

		if TabConfig.IsSettingsTab then
			Tab.Parent = LayersTab
			Tab.LayoutOrder = 999
			Tab.Size = UDim2.new(1, 0, 0, 40) -- Explicitly set size for settings tab
			Tab.Position = UDim2.new(0, 0, 1, -40)
			Tab.AnchorPoint = Vector2.new(0, 1) -- Anchor to bottom left for this positioning
			Tab.BackgroundTransparency = 0.95 -- Consistent with old Info frame
		else
			Tab.Parent = ScrollTab
			Tab.LayoutOrder = CountTab
			Tab.Size = UDim2.new(1, 0, 0, 30) -- Standard user tab height
			if CountTab == 0 and not LayersPageLayout.CurrentPage then -- Ensure first tab is highlighted only if no other tab is set as current
				Tab.BackgroundTransparency = 0.9200000166893005
			else
				Tab.BackgroundTransparency = 0.9990000128746033
			end
		end

		ScrolLayersMap[Tab] = ScrolLayers -- Populate the map for both types of tabs

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

		-- REMOVED: Auto-highlighting, JumpTo, NameTab.Text setting, and ChooseFrame creation from CreateTab.
		-- This will be handled by the new UIInstance:SelectTab method.

		TabButton.Activated:Connect(function()
			CircleClick(TabButton, Mouse.X, Mouse.Y)
			if UIInstance.SelectTab then
				UIInstance:SelectTab(TabObject) -- Pass the TabObject created in CreateTab
			else
				warn("UIInstance:SelectTab is not yet defined when TabButton was activated for:", TabConfig.Name)
			end
		end)

		local currentTabSectionCount = 0

		local TabObject = {}
		TabObject.Instance = Tab
		TabObject._ScrolLayers = ScrolLayers
		TabObject._UIListLayout = UIListLayout1 -- This is the UIListLayout of the ScrolLayers for this tab
		TabObject._IsSettingsTab = TabConfig.IsSettingsTab
		TabObject._TabConfig = TabConfig -- Store the original config for reference if needed

		FrameToTabObjectMap[Tab] = TabObject -- Populate the new map

		function TabObject:AddSection(Title)
			Title = Title or "Section"

			-- Define the updateParentScrollFunc specifically for this tab's ScrolLayers
			local function updateThisTabScrollFunc(scroller, padding)
				task.defer(function()
					local totalHeight = 0
					-- Iterate direct children of the scroller that are sections
					for _, child in ipairs(scroller:GetChildren()) do
						if child:IsA("Frame") and child.Name == "Section" then
							totalHeight = totalHeight + child.Size.Y.Offset + (padding and padding.Offset or 0)
						end
					end
					if #scroller:GetChildren() > 0 and padding then totalHeight = totalHeight - padding.Offset end -- Adjust for last padding
					if totalHeight < 0 then totalHeight = 0 end
					scroller.CanvasSize = UDim2.new(0, scroller.CanvasSize.X.Offset, 0, totalHeight)
				end)
			end

			-- Define the parentUIListLayoutPaddingRef for this tab's ScrolLayers
			local function getThisTabLayoutPadding()
				return self._UIListLayout and self._UIListLayout.Padding or UDim.new(0,3) -- Default if not found
			end

			local newSectionObject = InternalCreateSection(
				self._ScrolLayers,          -- parentScrolLayersInstance (this tab's content scroller)
				Title,                      -- sectionTitle
				currentTabSectionCount,     -- sectionLayoutOrder (specific to this tab)
				GuiConfig,                  -- guiConfigRef (from MakeGui scope)
				Flags,                      -- flagsRef (from MakeGui scope)
				Themes,                     -- themesRef (from MakeGui scope)
				function() return CurrentTheme end, -- currentThemeNameRef (CurrentTheme from MakeGui scope)
				GetColor,                   -- getColorFunc (from MakeGui scope)
				SetTheme,                   -- setThemeFunc (from MakeGui scope)
				LoadUIAsset,                -- loadUIAssetFunc (from MakeGui scope)
				SaveFile,                   -- saveFileFunc (from MakeGui scope)
				HttpService,                -- httpServiceRef (global or MakeGui scope)
				TweenService,               -- tweenServiceRef (global or MakeGui scope)
				Mouse,                      -- mouseRef (global or MakeGui scope)
				CircleClick,                -- circleClickFunc (from MakeGui scope)
				updateThisTabScrollFunc,    -- updateParentScrollFunc (specific to this tab's scroller)
				getThisTabLayoutPadding     -- parentUIListLayoutPaddingRef (specific to this tab's layout)
			)
			currentTabSectionCount = currentTabSectionCount + 1
			return newSectionObject
		end

		CountTab = CountTab + 1 -- Global counter for user tabs (used for LayoutOrder in ScrollTab)
		return TabObject -- Return the created TabObject
	end

	function UIInstance:SelectTab(tabObject)
		if not tabObject or not tabObject.Instance or not tabObject._ScrolLayers or not tabObject._TabConfig then
			warn("SelectTab: Invalid tabObject received.")
			return
		end

		local selectedTabFrame = tabObject.Instance
		local isSettings = tabObject._IsSettingsTab

		-- Unhighlight all user tabs in ScrollTab
		for _, child in ipairs(ScrollTab:GetChildren()) do
			if child:IsA("Frame") and child.Name:match("^TabInstance_") and child ~= selectedTabFrame then
				child.BackgroundTransparency = 0.9990000128746033 -- Default unselected
				local cf = child:FindFirstChild("ChooseFrame")
				if cf then cf.Visible = false end
			end
		end

		-- Unhighlight Customize tab if it's not the one being selected
		if customizeButtonInstance and customizeButtonInstance ~= selectedTabFrame then
			customizeButtonInstance.BackgroundTransparency = 0.95 -- Default unselected for settings tab
		end

		-- Highlight the selected tab
		if isSettings then
			selectedTabFrame.BackgroundTransparency = 0.92 -- Highlight for settings tab
		else
			selectedTabFrame.BackgroundTransparency = 0.9200000166893005 -- Highlight for user tab
			local cf = selectedTabFrame:FindFirstChild("ChooseFrame")
			if not cf then -- Create ChooseFrame if it doesn't exist for a user tab
				cf = Instance.new("Frame", selectedTabFrame)
				cf.Name = "ChooseFrame"
				cf.BackgroundColor3 = GetColor("ThemeHighlight")
				cf.BorderColor3 = Color3.fromRGB(0,0,0)
				cf.BorderSizePixel = 0
				cf.Position = UDim2.new(0,2,0,9)
				cf.Size = UDim2.new(0,1,0,12)
				local stroke = Instance.new("UIStroke", cf); stroke.Color = GetColor("Secondary"); stroke.Thickness = 1.6
				Instance.new("UICorner", cf)
			end
			cf.Visible = true
			TweenService:Create(cf, TweenInfo.new(0.2), {Size = UDim2.new(0,1,0,20)}):Play()
		end

		-- View switching
		if isSettings then
			if not isSettingsViewActive then -- Store last user tab name only when switching TO settings
				lastSelectedTabName = NameTab.Text
			end
			SettingsPage.Visible = true
			LayersReal.Visible = false
			NameTab.Text = "Settings"
			isSettingsViewActive = true
		else -- It's a user tab
			if isSettingsViewActive then -- If switching FROM settings, restore last user tab name (or set current)
				NameTab.Text = tabObject._TabConfig.Name -- This is more direct
			else
				NameTab.Text = tabObject._TabConfig.Name
			end
			SettingsPage.Visible = false
			LayersReal.Visible = true
			LayersPageLayout:JumpTo(tabObject._ScrolLayers)
			isSettingsViewActive = false
		end
	end

	task.defer(function()
		local firstUserTabFrame = nil
		if ScrollTab then -- Ensure ScrollTab exists
			for _, child in ipairs(ScrollTab:GetChildren()) do
				if child:IsA("Frame") and child.Name:match("^TabInstance_") and not child.Name:match("_Customize$") then -- Make sure it's not the settings tab if it somehow ended up in ScrollTab
					firstUserTabFrame = child
					break
				end
			end
		end

		if firstUserTabFrame then
			local tabObj = FrameToTabObjectMap[firstUserTabFrame]
			if tabObj then
				UIInstance:SelectTab(tabObj)
			else
				warn("MakeGui: Could not find TabObject for first user tab frame:", firstUserTabFrame.Name)
				-- Fallback: if no specific tab is selected, ensure a clean state
				NameTab.Text = ""
				SettingsPage.Visible = false
				LayersReal.Visible = true
				if LayersPageLayout and #LayersFolder:GetChildren() > 0 then
					LayersPageLayout:JumpTo(LayersFolder:GetChildren()[1])
				elseif LayersPageLayout then
					LayersPageLayout:Clear()
				end
			end
		else
			-- No user tabs found. Optionally select CustomizeTab or leave blank.
			-- If CustomizeTab exists and no user tabs, select CustomizeTab.
			if CustomizeTab and CustomizeTab.Instance then -- CustomizeTab is the TabObject from MakeGui
				UIInstance:SelectTab(CustomizeTab)
			else -- Absolute fallback: clear state
				NameTab.Text = ""
				SettingsPage.Visible = false
				LayersReal.Visible = true
				if LayersPageLayout then LayersPageLayout:Clear() end
			end
		end
	end)

	return UIInstance
end
return UBHubLib
