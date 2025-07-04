local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()
local ProtectGui = (syn and syn.protect_gui) or (_G.protectgui) or function(f) end -- Prioritize syn, then safe global, then no-op
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
local CANONICAL_THEME_COLOR_KEYS = { -- Define canonical list of theme color keys
    "Primary", "Secondary", "Accent", "ThemeHighlight",
    "Text", "Background", "Stroke"
}
table.sort(CANONICAL_THEME_COLOR_KEYS) -- Ensure consistent order for editor creation

local CurrentTheme = "UB_Orange"
local ThemeElements = {}; setmetatable(ThemeElements, {__mode = "v"}) -- Use weak values for UI elements

-- Forward declare SaveFile for SetTheme
local SaveFile

function GetThemes()
	local themenames = {}
	for themeNameKey, _ in pairs(Themes) do
        -- Filter out special internal theme keys that shouldn't be user-selectable as "default" themes
		if themeNameKey ~= "__loadedStartupTheme" and themeNameKey ~= "__customApplied" then
			table.insert(themenames, themeNameKey)
		end
	end
	table.sort(themenames) -- Keep it sorted for consistent display
	return themenames
end
local function GetColor(colorName, element, property)
    if element and property then
        local alreadyExists = false
        for _, existingEntry in ipairs(ThemeElements) do
            if existingEntry.element == element and existingEntry.property == property then
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
		return Color3.fromRGB(130, 30, 5) -- Fallback to UB_Orange Primary
    end
end

-- Forward declare SettingsPage, isSettingsViewActive, updateAllColorControls for SetTheme
local SettingsPage, isSettingsViewActive, updateAllColorControls

function SetTheme(themeName)
    CurrentTheme = themeName
    for i = #ThemeElements, 1, -1 do -- Iterate backwards for safe removal
        local sub = ThemeElements[i]
        if sub and sub.element and sub.element.Parent then -- Check if element is still valid and parented
            local themeColor = Themes[CurrentTheme] and Themes[CurrentTheme][sub.colorName]
            if themeColor then
                local ok, err = pcall(function()
                    sub.element[sub.property] = themeColor
                end)
                if not ok then
                    warn("Theme application failed for element:", sub.element:GetFullName(), "Property:", sub.property, "Error:", err, "- Removing from ThemeElements to prevent spam.")
                    table.remove(ThemeElements, i)
                end
            else
                warn("Theme color not found:", sub.colorName, "for theme:", CurrentTheme)
            end
        else
            table.remove(ThemeElements, i)
        end
    end

	if SaveFile then -- Check if SaveFile itself is defined (it will be later in MakeGui)
		SaveFile("LastThemeName", themeName)
		if Flags.CustomUserThemes and Flags.CustomUserThemes[themeName] or themeName == "__customApplied" or themeName == "__loadedStartupTheme" then
			if Themes[themeName] then
				SaveFile("LastCustomThemeData", deepcopy(Themes[themeName]))
			end
		else
			SaveFile("LastCustomThemeData", nil) 
		end
	end
	
	if isSettingsViewActive or (CurrentTheme == "__customApplied" and SettingsPage and SettingsPage.Visible) then
		if updateAllColorControls then task.delay(0.05, updateAllColorControls) end
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
-- MakeDraggable will be defined within MakeGui's scope or passed if needed by elements outside.
-- For now, assume it's defined later if only used by MakeGui internals.
-- If draggableElements is used by MakeDraggable, it should be in a scope accessible to it.
-- For now, it's declared within MakeGui.

function CircleClick(Button, X, Y)
	spawn(function()
		Button.ClipsDescendants = true
		local Circle = Instance.new("ImageLabel")
		Circle.Image = LoadUIAsset("rbxassetid://266543268", "Circle.png")
		Circle.ImageColor3 = GetColor("ThemeHighlight",Circle,ImageColor3)
		Circle.ImageTransparency = 0.8999999761581421
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1
		Circle.AnchorPoint = Vector2.new(0.5, 0.5) -- Center the anchor point
		Circle.ZIndex = 10
		Circle.Name = "Circle"
		Circle.Parent = Button -- Parent Circle to Button first

		local relativeX = X - Button.AbsolutePosition.X
		local relativeY = Y - Button.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, relativeX, 0, relativeY)
		
		local Size = 0
		if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
			Size = Button.AbsoluteSize.X*1.5
		elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
			Size = Button.AbsoluteSize.Y*1.5
		elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then
			Size = Button.AbsoluteSize.X*1.5
		end

		local Time = 0.5
		local initialTransparency = Circle.ImageTransparency

		Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size/2, 0.5, -Size/2), "Out", "Quad", Time, false, nil)

		if TweenService then
			local transparencyTween = TweenService:Create(Circle, TweenInfo.new(Time), {ImageTransparency = 1.0})
			transparencyTween:Play()
			transparencyTween.Completed:Wait()
		else
			local steps = 10
			for i = 1, steps do
				Circle.ImageTransparency = initialTransparency + ( (1.0 - initialTransparency) * (i / steps) )
				task.wait(Time / steps)
			end
		end
		Circle:Destroy()
	end)
end

local notifyLayoutOrderCounter = 0
local NotifyGuiSingleton = nil
local NotifyLayoutSingleton = nil

local Flags = {}

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

local UBHubLib = {}
function UBHubLib:MakeNotify(NotifyConfig)
	local NotifyConfig = NotifyConfig or {}
	NotifyConfig.Title = NotifyConfig.Title or "UB Hub"
	NotifyConfig.Description = NotifyConfig.Description or "Notification"
	NotifyConfig.Content = NotifyConfig.Content or "Content"
	NotifyConfig.Color = GetColor("Primary")
	NotifyConfig.Time = tonumber(NotifyConfig.Time or 0.5)
	if not (type(NotifyConfig.Time) == "number" and NotifyConfig.Time > 0) then
		warn("MakeNotify: Invalid NotifyConfig.Time, defaulting to 0.5. Received:", NotifyConfig.Time)
		NotifyConfig.Time = 0.5
	end

	NotifyConfig.Delay = tonumber(NotifyConfig.Delay or 5)
	if not (type(NotifyConfig.Delay) == "number" and NotifyConfig.Delay >= 0) then
		warn("MakeNotify: Invalid NotifyConfig.Delay, defaulting to 5. Received:", NotifyConfig.Delay)
		NotifyConfig.Delay = 5
	end

	local NotifyFunction = {}
	spawn(function()
		if not NotifyGuiSingleton or not NotifyGuiSingleton.Parent then
			NotifyGuiSingleton = Instance.new("ScreenGui")
			NotifyGuiSingleton.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			NotifyGuiSingleton.Name = "NotifyGuiSingleton"
			NotifyGuiSingleton.Parent = CoreGui
		end

		if not NotifyLayoutSingleton or not NotifyLayoutSingleton.Parent then
			NotifyLayoutSingleton = Instance.new("Frame")
			NotifyLayoutSingleton.Name = "NotifyLayoutSingleton"
			NotifyLayoutSingleton.AnchorPoint = Vector2.new(1, 1)
			NotifyLayoutSingleton.BackgroundColor3 = GetColor("Primary")
			NotifyLayoutSingleton.BackgroundTransparency = 0.9990000128746033
			NotifyLayoutSingleton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifyLayoutSingleton.BorderSizePixel = 0
			NotifyLayoutSingleton.Position = UDim2.new(1, -30, 1, -30)
			NotifyLayoutSingleton.Size = UDim2.new(0, 320, 1, 0)
			NotifyLayoutSingleton.Parent = NotifyGuiSingleton
			
			local ListLayout = NotifyLayoutSingleton:FindFirstChildOfClass("UIListLayout")
			if not ListLayout then
				ListLayout = Instance.new("UIListLayout")
				ListLayout.Parent = NotifyLayoutSingleton
			end
			ListLayout.FillDirection = Enum.FillDirection.Vertical
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
			ListLayout.Padding = UDim.new(0, 5)
		end

		local NotifyFrame = Instance.new("Frame");
		notifyLayoutOrderCounter = notifyLayoutOrderCounter + 1
		NotifyFrame.LayoutOrder = notifyLayoutOrderCounter
		NotifyFrame.Parent = NotifyLayoutSingleton

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

		local topPadding = Instance.new("UIPadding", Top)
		topPadding.PaddingLeft = UDim.new(0, 10)
		topPadding.PaddingRight = UDim.new(0, 5)

		local topListLayout = Instance.new("UIListLayout", Top)
        topListLayout.FillDirection = Enum.FillDirection.Horizontal
        topListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        topListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        topListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        topListLayout.Padding = UDim.new(0, 5)

		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = NotifyConfig.Title
		TextLabel.TextColor3 = GetColor("Text",TextLabel,"TextColor3")
		TextLabel.TextSize = 14
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 0.9990000128746033
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Size = UDim2.new(0,0,1,0)
        TextLabel.AutomaticSize = Enum.AutomaticSize.X
		TextLabel.Parent = Top

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
		TextLabel1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel1.BackgroundTransparency = 1.0
		TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel1.BorderSizePixel = 0
		TextLabel1.Size = UDim2.new(1,0,1,0)
		TextLabel1.Parent = Top

		UIStroke1.Color = GetColor("Primary", UIStroke1, "Color")
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

		ImageLabel.Image = LoadUIAsset("rbxassetid://9886659671", "ImageLabel.png")
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
		TextLabel2.TextWrapped = true
		TextLabel2.Size = UDim2.new(1, -20, 0, 0)
		TextLabel2.AutomaticSize = Enum.AutomaticSize.Y

		task.defer(function()
			if not NotifyFrame or not NotifyFrame.Parent then return end
			local topBarHeight = Top.AbsoluteSize.Y
			local textTopOffset = TextLabel2.Position.Y.Offset
			local textHeight = TextLabel2.AbsoluteSize.Y
			local bottomPadding = 10

			local totalContentHeight = textTopOffset + textHeight + bottomPadding
			local minNotifyHeight = topBarHeight + 30

			NotifyFrame.Size = UDim2.new(1, 0, 0, math.max(minNotifyHeight, totalContentHeight))
		end)
		
		local waitbruh_instance = false
		function NotifyFunction:Close()
			if waitbruh_instance then
				return false
			end
			waitbruh_instance = true
			local tweenDuration = NotifyConfig.Time * 0.2
			TweenService:Create(NotifyFrameReal,TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 400, 0, 0)}):Play()
			task.wait(tweenDuration)
			NotifyFrame:Destroy()
		end
		Close.Activated:Connect(function()
			NotifyFunction:Close()
		end)
		TweenService:Create(NotifyFrameReal,TweenInfo.new(NotifyConfig.Time * 0.2, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.wait(NotifyConfig.Delay)
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
	--[[
        STEP 1: INITIALIZATION
        All variables are declared here.
    ]]
	local GuiConfig = GuiConfig or {}
	GuiConfig.NameHub = GuiConfig.NameHub or "UB Hub"
	if LibraryCfg.Undetected then
		GuiConfig.Description = "|UNDETECTED|"
	else
		GuiConfig.Description = ""
	end
	GuiConfig.Color = Color3.fromRGB(130, 30, 5) -- Default accent color for some elements if not themed
	GuiConfig["Logo Player"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..game:GetService("Players").LocalPlayer.UserId .."&width=420&height=420&format=png"
	GuiConfig["Name Player"] = tostring(game:GetService("Players").LocalPlayer.Name)
	GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 120
	GuiConfig["SaveFolder"] = GuiConfig["SaveFolder"] or UBDir .. "/config.json" -- Default save folder

	local UIInstance = { UserTabObjects = {} }
	local connections, draggableElements, resizableElements, Flags = {}, {}, {}, _G.Flags or {}
	local isWindowDragging, isWindowResizing = false, false
	-- Input handling variables (centralized from previous implementation)
	local windowDragTarget = nil
	local windowDragInitiator = nil
	local windowResizeTarget = nil
	local windowResizeInitiator = nil
	local windowDragStartMouse = Vector2.new()
	local windowDragStartPos = UDim2.new()
	local windowResizeStartMouse = Vector2.new()
	local windowResizeStartSize = UDim2.new()

	-- UI Element Placeholders (these will be assigned actual instances in Step 2)
	local TextLabel_Title, TextLabel_Description, UICorner_Top_Main, UIStroke_Description -- For Top bar
	local MaxRestore, ImageLabel_MaxRestoreIcon, ImageLabel_CloseIcon, ImageLabel_MinIcon -- For Top bar buttons (Close and Min buttons themselves are defined later with their connections)
	local UICorner_LayersTab_Instance, UIListLayout_ScrollTab_Instance, NewCustomizeButton, CustomizeButtonSeparator_Instance -- For LayersTab area (ScrollTab itself is defined later)
	local UICorner_Layers_Instance, NameTab -- For Layers area (Layers, LayersReal, LayersFolder, LayersPageLayout are defined later)
	local SettingsPage_UI, SettingsPageLayout_UI -- Specific names for settings page UI to avoid conflict
	local MoreBlur_Instance, ConnectButton_MoreBlur_Instance, DropdownSelect_Instance, DropdownFolder_Instance, DropPageLayout_Instance -- For dropdowns
	local ScreenGui_Minimized, MinimizedIcon, MinCorner_MinimizedIcon_Instance -- For minimized state
	local BackgroundImage, BackgroundVideo -- For custom backgrounds

	-- State and Control Variables
	local activeColorSliders = {} -- For theme customization in settings
	local ScrolLayersMap = {} -- Maps Tab Frame (button) to its ScrollingFrame content page
	local FrameToTabObjectMap = {} -- Maps Tab Frame (button) to its TabObject
	local isSettingsViewActive = false -- Tracks if the settings view is currently active
	local lastSelectedTabName = "" -- Stores the name of the last selected user tab (not settings)
	local customizeButtonInstance -- Will hold the CustomizeButton instance created in Step 2
	local MAXIMIZE_ICON_ASSET, RESTORE_ICON_ASSET -- Asset IDs for maximize/restore icons
	local OldPos_MaxRestore, OldSize_MaxRestore -- For Maximize/Restore functionality
	local minimizedLastPosition, minimizedLastSize -- For Minimize/Restore from icon functionality
	local isMaximized = false -- State for Maximize/Restore button
	local BGImage = false -- Flag for background type: Image
	local BGVideo = false -- Flag for background type: Video

	-- Constants and Calculated Values (some might be better as true constants outside function if not GuiConfig dependent)
	local SHADOW_PADDING = 24 -- Padding for the drop shadow effect
	local TOP_BAR_DESIGN_HEIGHT = 38 -- Expected height of the top bar
	local PADDING_BELOW_TOP_BAR = 10
	local LAYERS_TAB_X_PADDING = 9
	local GENERAL_BOTTOM_MARGIN = 9
	local PADDING_BETWEEN_TABS_AND_CONTENT = 9
	local LAYERS_TAB_WIDTH = tonumber(GuiConfig["Tab Width"]) or 120 -- Ensure numeric

	local calculatedLayersTabYPos = TOP_BAR_DESIGN_HEIGHT + PADDING_BELOW_TOP_BAR
	local layersTabTotalVerticalSpaceToExclude = calculatedLayersTabYPos + GENERAL_BOTTOM_MARGIN
	local layersContentXStart = LAYERS_TAB_X_PADDING + LAYERS_TAB_WIDTH + PADDING_BETWEEN_TABS_AND_CONTENT
	local layersContentTotalHorizontalSpaceToExclude = layersContentXStart + LAYERS_TAB_X_PADDING

	-- Forward declared UI elements that will be created in Step 2 and accessed by helper functions or API
	local Main_Instance, Top_Instance, LayersTab_Instance, ScrollTab_Instance, Layers_Instance, LayersReal_Instance, LayersFolder_Instance, SettingsPage_Instance_ref, CustomizeButton_Instance_ref, Separator_Instance_ref
	local CloseButton_Instance, MinButton_Instance, MaxRestoreButton_Instance -- Explicitly for connecting events later
	local LayersPageLayout_Instance -- For UIPageLayout in LayersFolder
	local GuiFunc = {} -- Table for GUI manipulation functions like DestroyGui, ToggleUI

	--[[
        STEP 2: CREATE ALL UI INSTANCES
        All Instance.new() calls go here.
    ]]
	local UBHubGui = Instance.new("ScreenGui")
	ProtectGui(UBHubGui)
	UBHubGui.Name = "UBHubGui"
	UBHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	-- UBHubGui.Parent is handled by ProtectGui or at the end of MakeGui

	local DropShadowHolder = Instance.new("Frame")
	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.BackgroundColor3 = Color3.new(0, 0, 0) -- Should be transparent, shadow is an image
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.ZIndex = 0 -- Shadow is behind Main
	DropShadowHolder.Size = SizeUI -- Initial Size, will be adjusted by loaded settings or default
	DropShadowHolder.Position = UDim2.new(0.1, 0, 0.1, 0) -- Temporary, centered later
	DropShadowHolder.Parent = UBHubGui

	local DropShadowImage = Instance.new("ImageLabel") -- This is the actual shadow visual
	DropShadowImage.Name = "DropShadowVisual"
	DropShadowImage.Image = "rbxassetid://6020280907" -- Standard 9-slice shadow
	DropShadowImage.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadowImage.ImageTransparency = 0.7
	DropShadowImage.ScaleType = Enum.ScaleType.Slice
	DropShadowImage.SliceCenter = Rect.new(49, 49, 450, 450) -- Standard slice for this type of shadow
	DropShadowImage.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadowImage.BackgroundTransparency = 1
	DropShadowImage.BorderSizePixel = 0
	DropShadowImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadowImage.Size = UDim2.new(1, 0, 1, 0) -- Cover the entire DropShadowHolder
	DropShadowImage.ZIndex = 0
	DropShadowImage.Parent = DropShadowHolder

	Main_Instance = Instance.new("Frame") -- Assign to the forward-declared variable
	Main_Instance.Name = "Main"
	Main_Instance.AnchorPoint = Vector2.new(0,0) -- Default, explicit
	Main_Instance.BackgroundColor3 = GetColor("Background", Main_Instance, "BackgroundColor3")
	Main_Instance.BackgroundTransparency = Flags.UI_BackgroundTransparency and (Flags.UI_BackgroundTransparency / 100) or 0.1 -- Use saved or default
	Main_Instance.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main_Instance.BorderSizePixel = 0
	Main_Instance.Position = UDim2.new(0, SHADOW_PADDING, 0, SHADOW_PADDING)
	Main_Instance.Size = UDim2.new(1, -2 * SHADOW_PADDING, 1, -2 * SHADOW_PADDING)
	Main_Instance.ZIndex = 1
	Main_Instance.ClipsDescendants = true
	Main_Instance.Parent = DropShadowHolder

	UICorner_Top_Main = Instance.new("UICorner") -- Previously UICorner_Top
	UICorner_Top_Main.CornerRadius = UDim.new(0, 8) -- Example radius, adjust as per old code
	UICorner_Top_Main.Parent = Main_Instance

	local UIStroke_Main = Instance.new("UIStroke")
	UIStroke_Main.Color = GetColor("Stroke", UIStroke_Main, "Color")
	UIStroke_Main.Thickness = 1.6
	UIStroke_Main.Parent = Main_Instance

	BackgroundImage = Instance.new("ImageLabel") -- Already declared
	BackgroundImage.Name = "MainBackgroundImage"
	BackgroundImage.Size = UDim2.new(1,0,1,0)
	BackgroundImage.BackgroundTransparency = 1
	BackgroundImage.ImageTransparency = Main_Instance.BackgroundTransparency -- Sync with main
	BackgroundImage.ZIndex = 0 -- Behind other main content
	BackgroundImage.Parent = Main_Instance

	BackgroundVideo = Instance.new("VideoFrame") -- Already declared
	BackgroundVideo.Name = "MainBackgroundVideo"
	BackgroundVideo.Size = UDim2.new(1,0,1,0)
	BackgroundVideo.BackgroundTransparency = Main_Instance.BackgroundTransparency -- Sync with main
	BackgroundVideo.Looped = true
	BackgroundVideo.Playing = false -- Start paused
	BackgroundVideo.ZIndex = 0 -- Behind other main content
	BackgroundVideo.Parent = Main_Instance

	Top_Instance = Instance.new("Frame") -- Assign to forward-declared Top_Instance
	Top_Instance.Name = "Top"
	Top_Instance.BackgroundColor3 = GetColor("Primary", Top_Instance, "BackgroundColor3")
	Top_Instance.BackgroundTransparency = 0 -- Top bar is usually opaque or slightly transparent based on theme
	Top_Instance.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top_Instance.BorderSizePixel = 0
	Top_Instance.Size = UDim2.new(1, 0, 0, TOP_BAR_DESIGN_HEIGHT)
	Top_Instance.ZIndex = 2 -- Above main background, below potential popups
	Top_Instance.Parent = Main_Instance

	local Top_UICorner = Instance.new("UICorner")
	Top_UICorner.CornerRadius = UDim.new(0,3)
	Top_UICorner.Parent = Top_Instance

	local Top_UIPadding = Instance.new("UIPadding")
	Top_UIPadding.PaddingLeft = UDim.new(0, 10)
	Top_UIPadding.PaddingRight = UDim.new(0, 85) -- Space for Close, Min, Max buttons
	Top_UIPadding.Parent = Top_Instance

	local Top_UIListLayout = Instance.new("UIListLayout")
	Top_UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	Top_UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	Top_UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	Top_UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	Top_UIListLayout.Padding = UDim.new(0, 5)
	Top_UIListLayout.Parent = Top_Instance

	TextLabel_Title = Instance.new("TextLabel") -- Already declared
	TextLabel_Title.Name = "TitleText"
	TextLabel_Title.Font = Enum.Font.GothamBold
	TextLabel_Title.Text = GuiConfig.NameHub
	TextLabel_Title.TextColor3 = GetColor("Text", TextLabel_Title, "TextColor3")
	TextLabel_Title.TextSize = 14
	TextLabel_Title.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel_Title.BackgroundTransparency = 1
	TextLabel_Title.Size = UDim2.new(0,0,1,0) -- Auto-sizes X
	TextLabel_Title.AutomaticSize = Enum.AutomaticSize.X
	TextLabel_Title.LayoutOrder = 1
	TextLabel_Title.Parent = Top_Instance

	TextLabel_Description = Instance.new("TextLabel") -- Already declared
	TextLabel_Description.Name = "DescriptionText"
	TextLabel_Description.Font = Enum.Font.GothamBold
	TextLabel_Description.Text = GuiConfig.Description
	TextLabel_Description.TextColor3 = GetColor("Text", TextLabel_Description, "TextColor3")
	TextLabel_Description.TextTransparency = 0.3
	TextLabel_Description.TextSize = 14
	TextLabel_Description.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel_Description.BackgroundTransparency = 1
	TextLabel_Description.Size = UDim2.new(1,0,1,0) -- Takes remaining space
	TextLabel_Description.LayoutOrder = 2
	TextLabel_Description.Parent = Top_Instance

	CloseButton_Instance = Instance.new("TextButton")
	CloseButton_Instance.Name = "CloseButton"
	CloseButton_Instance.Text = ""
	CloseButton_Instance.AnchorPoint = Vector2.new(1, 0.5)
	CloseButton_Instance.BackgroundTransparency = 1
	CloseButton_Instance.Position = UDim2.new(1, -8, 0.5, 0)
	CloseButton_Instance.Size = UDim2.new(0, 25, 0, 25)
	CloseButton_Instance.ZIndex = Top_Instance.ZIndex + 1
	CloseButton_Instance.Parent = Top_Instance

	ImageLabel_CloseIcon = Instance.new("ImageLabel") -- Already declared
	ImageLabel_CloseIcon.Name = "CloseIcon"
	ImageLabel_CloseIcon.Image = LoadUIAsset("rbxassetid://9886659671", "CloseIcon.png")
	ImageLabel_CloseIcon.ImageColor3 = GetColor("Text", ImageLabel_CloseIcon, "ImageColor3")
	ImageLabel_CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_CloseIcon.BackgroundTransparency = 1
	ImageLabel_CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel_CloseIcon.Size = UDim2.new(1, -8, 1, -8)
	ImageLabel_CloseIcon.Parent = CloseButton_Instance

	MaxRestoreButton_Instance = Instance.new("TextButton")
	MaxRestoreButton_Instance.Name = "MaxRestoreButton"
	MaxRestoreButton_Instance.Text = ""
	MaxRestoreButton_Instance.AnchorPoint = Vector2.new(1, 0.5)
	MaxRestoreButton_Instance.BackgroundTransparency = 1
	MaxRestoreButton_Instance.Position = UDim2.new(1, -34, 0.5, 0)
	MaxRestoreButton_Instance.Size = UDim2.new(0, 25, 0, 25)
	MaxRestoreButton_Instance.ZIndex = Top_Instance.ZIndex + 1
	MaxRestoreButton_Instance.Parent = Top_Instance
	MaxRestore = MaxRestoreButton_Instance -- Assign to variable used in event connection

	ImageLabel_MaxRestoreIcon = Instance.new("ImageLabel") -- Already declared
	ImageLabel_MaxRestoreIcon.Name = "MaxRestoreIcon"
	MAXIMIZE_ICON_ASSET = LoadUIAsset("rbxassetid://9886659406", "MaxRestore_MaximizeIcon.png") -- Load asset
	RESTORE_ICON_ASSET = LoadUIAsset("rbxassetid://16598400946", "MaxRestore_RestoreIcon.png") -- Load asset
	ImageLabel_MaxRestoreIcon.Image = MAXIMIZE_ICON_ASSET -- Initial state
	ImageLabel_MaxRestoreIcon.ImageColor3 = GetColor("Text", ImageLabel_MaxRestoreIcon, "ImageColor3")
	ImageLabel_MaxRestoreIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_MaxRestoreIcon.BackgroundTransparency = 1
	ImageLabel_MaxRestoreIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel_MaxRestoreIcon.Size = UDim2.new(1, -8, 1, -8)
	ImageLabel_MaxRestoreIcon.Parent = MaxRestoreButton_Instance

	MinButton_Instance = Instance.new("TextButton")
	MinButton_Instance.Name = "MinButton"
	MinButton_Instance.Text = ""
	MinButton_Instance.AnchorPoint = Vector2.new(1, 0.5)
	MinButton_Instance.BackgroundTransparency = 1
	MinButton_Instance.Position = UDim2.new(1, -60, 0.5, 0)
	MinButton_Instance.Size = UDim2.new(0, 25, 0, 25)
	MinButton_Instance.ZIndex = Top_Instance.ZIndex + 1
	MinButton_Instance.Parent = Top_Instance
	Min = MinButton_Instance -- Assign to variable used in event connection

	ImageLabel_MinIcon = Instance.new("ImageLabel") -- Already declared
	ImageLabel_MinIcon.Name = "MinIcon"
	ImageLabel_MinIcon.Image = LoadUIAsset("rbxassetid://9886659276", "MinIcon.png")
	ImageLabel_MinIcon.ImageColor3 = GetColor("Text", ImageLabel_MinIcon, "ImageColor3")
	ImageLabel_MinIcon.ImageTransparency = 0.2 -- As per old code
	ImageLabel_MinIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_MinIcon.BackgroundTransparency = 1
	ImageLabel_MinIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel_MinIcon.Size = UDim2.new(1, -9, 1, -9)
	ImageLabel_MinIcon.Parent = MinButton_Instance

	local TopSeparator = Instance.new("Frame") -- Separator below Top bar
	TopSeparator.Name = "TopSeparator"
	TopSeparator.AnchorPoint = Vector2.new(0.5, 0)
	TopSeparator.BackgroundColor3 = GetColor("Stroke", TopSeparator, "BackgroundColor3")
	TopSeparator.BackgroundTransparency = 0.85
	TopSeparator.BorderSizePixel = 0
	TopSeparator.Position = UDim2.new(0.5, 0, 0, TOP_BAR_DESIGN_HEIGHT)
	TopSeparator.Size = UDim2.new(1, 0, 0, 1)
	TopSeparator.ZIndex = Top_Instance.ZIndex
	TopSeparator.Parent = Main_Instance

	LayersTab_Instance = Instance.new("Frame") -- Assign to forward-declared
	LayersTab_Instance.Name = "LayersTab"
	LayersTab_Instance.BackgroundColor3 = GetColor("Secondary", LayersTab_Instance, "BackgroundColor3")
	LayersTab_Instance.BackgroundTransparency = 0 -- Or themed
	LayersTab_Instance.BorderSizePixel = 0
	LayersTab_Instance.Position = UDim2.new(0, LAYERS_TAB_X_PADDING, 0, calculatedLayersTabYPos)
	LayersTab_Instance.Size = UDim2.new(0, LAYERS_TAB_WIDTH, 1, -layersTabTotalVerticalSpaceToExclude)
	LayersTab_Instance.ZIndex = 1
	LayersTab_Instance.Parent = Main_Instance
	UICorner_LayersTab_Instance = Instance.new("UICorner")
	UICorner_LayersTab_Instance.CornerRadius = UDim.new(0, 4)
	UICorner_LayersTab_Instance.Parent = LayersTab_Instance

	ScrollTab_Instance = Instance.new("ScrollingFrame") -- Assign to forward-declared
	ScrollTab_Instance.Name = "ScrollTab"
	ScrollTab_Instance.CanvasSize = UDim2.new(0,0,0,0) -- Will be updated by content
	ScrollTab_Instance.ScrollBarThickness = 4
	ScrollTab_Instance.ScrollBarImageColor3 = GetColor("Accent", ScrollTab_Instance, "ScrollBarImageColor3")
	ScrollTab_Instance.Active = true
	ScrollTab_Instance.BackgroundColor3 = GetColor("Secondary", ScrollTab_Instance, "BackgroundColor3")
	ScrollTab_Instance.BackgroundTransparency = 1 -- Content area, usually transparent to show parent
	ScrollTab_Instance.BorderSizePixel = 0
	ScrollTab_Instance.Size = UDim2.new(1, 0, 1, -(38 + 1 + 5)) -- Full width, height adjusted for CustomizeButton and Separator
	ScrollTab_Instance.Position = UDim2.new(0,0,0,0) -- At the top of LayersTab
	ScrollTab_Instance.ZIndex = LayersTab_Instance.ZIndex + 1
	ScrollTab_Instance.Parent = LayersTab_Instance
	UIListLayout_ScrollTab_Instance = Instance.new("UIListLayout")
	UIListLayout_ScrollTab_Instance.Padding = UDim.new(0, 3)
	UIListLayout_ScrollTab_Instance.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_ScrollTab_Instance.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_ScrollTab_Instance.Parent = ScrollTab_Instance

	Layers_Instance = Instance.new("Frame") -- Assign to forward-declared
	Layers_Instance.Name = "Layers"
	Layers_Instance.BackgroundColor3 = GetColor("Background", Layers_Instance, "BackgroundColor3") -- Main content area background
	Layers_Instance.BackgroundTransparency = 0 -- Or themed
	Layers_Instance.BorderSizePixel = 0
	Layers_Instance.Position = UDim2.new(0, layersContentXStart, 0, calculatedLayersTabYPos)
	Layers_Instance.Size = UDim2.new(1, -layersContentTotalHorizontalSpaceToExclude, 1, -layersTabTotalVerticalSpaceToExclude)
	Layers_Instance.ZIndex = 1
	Layers_Instance.ClipsDescendants = true
	Layers_Instance.Parent = Main_Instance
	UICorner_Layers_Instance = Instance.new("UICorner")
	UICorner_Layers_Instance.CornerRadius = UDim.new(0, 4)
	UICorner_Layers_Instance.Parent = Layers_Instance

	NameTab = Instance.new("TextLabel") -- Already declared, this is the title for the current tab's content
	NameTab.Name = "CurrentTabTitle"
	NameTab.Font = Enum.Font.GothamBold
	NameTab.Text = "" -- Will be set by SelectTab
	NameTab.TextColor3 = GetColor("Text", NameTab, "TextColor3")
	NameTab.TextSize = 18
	NameTab.TextWrapped = true
	NameTab.TextXAlignment = Enum.TextXAlignment.Left
	NameTab.TextYAlignment = Enum.TextYAlignment.Center
	NameTab.BackgroundTransparency = 1
	NameTab.BorderSizePixel = 0
	NameTab.Size = UDim2.new(1, -20, 0, 30) -- Full width with padding, fixed height
	NameTab.Position = UDim2.new(0, 10, 0, 0) -- Padded from left
	NameTab.ZIndex = Layers_Instance.ZIndex + 1
	NameTab.Parent = Layers_Instance

	LayersReal_Instance = Instance.new("Frame") -- Assign to forward-declared
	LayersReal_Instance.Name = "LayersReal" -- Holds user tab content
	LayersReal_Instance.AnchorPoint = Vector2.new(0, 0)
	LayersReal_Instance.BackgroundTransparency = 1
	LayersReal_Instance.BorderSizePixel = 0
	LayersReal_Instance.ClipsDescendants = true
	LayersReal_Instance.Position = UDim2.new(0, 0, 0, NameTab.Size.Y.Offset + 3) -- Below NameTab title
	LayersReal_Instance.Size = UDim2.new(1, 0, 1, -(NameTab.Size.Y.Offset + 3)) -- Fill remaining space
	LayersReal_Instance.ZIndex = Layers_Instance.ZIndex
	LayersReal_Instance.Parent = Layers_Instance

	LayersFolder_Instance = Instance.new("Folder") -- Assign to forward-declared
	LayersFolder_Instance.Name = "LayersFolder"
	LayersFolder_Instance.Parent = LayersReal_Instance
	LayersPageLayout_Instance = Instance.new("UIPageLayout")
	LayersPageLayout_Instance.Name = "LayersPageLayout"
	LayersPageLayout_Instance.SortOrder = Enum.SortOrder.LayoutOrder
	LayersPageLayout_Instance.TweenTime = 0.3
	LayersPageLayout_Instance.EasingDirection = Enum.EasingDirection.InOut
	LayersPageLayout_Instance.EasingStyle = Enum.EasingStyle.Quad
	LayersPageLayout_Instance.Parent = LayersFolder_Instance

	SettingsPage_Instance_ref = Instance.new("ScrollingFrame") -- Assign to forward-declared
	SettingsPage_Instance_ref.Name = "SettingsPage" -- This is the main container for settings
	SettingsPage_Instance_ref.Size = UDim2.new(1,0,1,0) -- Full size of its parent (Layers_Instance)
	SettingsPage_Instance_ref.Position = UDim2.new(0,0,0,0)
	SettingsPage_Instance_ref.BackgroundColor3 = GetColor("Background", SettingsPage_Instance_ref, "BackgroundColor3")
	SettingsPage_Instance_ref.BackgroundTransparency = 0 -- Match Layers_Instance or themed
	SettingsPage_Instance_ref.BorderSizePixel = 0
	SettingsPage_Instance_ref.Visible = false -- Initially hidden
	SettingsPage_Instance_ref.ScrollBarThickness = 6
	SettingsPage_Instance_ref.ScrollBarImageColor3 = GetColor("Accent")
	SettingsPage_Instance_ref.ScrollingDirection = Enum.ScrollingDirection.Y
	SettingsPage_Instance_ref.CanvasSize = UDim2.new(0,0,0,0) -- Dynamic
	SettingsPage_Instance_ref.ZIndex = Layers_Instance.ZIndex + 1 -- Above normal tab content if overlaid
	SettingsPage_Instance_ref.Parent = Layers_Instance -- Parented to Layers, will be shown/hidden
	SettingsPage_UI = SettingsPage_Instance_ref -- Assign to the more specific variable used in logic

	SettingsPageLayout_UI = Instance.new("UIListLayout")
	SettingsPageLayout_UI.Name = "SettingsPageLayout"
	SettingsPageLayout_UI.Padding = UDim.new(0, 10)
	SettingsPageLayout_UI.SortOrder = Enum.SortOrder.LayoutOrder
	SettingsPageLayout_UI.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SettingsPageLayout_UI.Parent = SettingsPage_Instance_ref

	CustomizeButton_Instance_ref = Instance.new("TextButton") -- Assign to forward-declared
	customizeButtonInstance = CustomizeButton_Instance_ref -- Assign to the variable used for connecting event
	CustomizeButton_Instance_ref.Name = "CustomizeButton"
	CustomizeButton_Instance_ref.Text = "" -- Text is on a child label
	CustomizeButton_Instance_ref.AnchorPoint = Vector2.new(0.5, 1)
	CustomizeButton_Instance_ref.Position = UDim2.new(0.5, 0, 1, -5) -- At the bottom of LayersTab, centered, padded
	CustomizeButton_Instance_ref.Size = UDim2.new(1, -10, 0, 38) -- Almost full width of LayersTab, fixed height
	CustomizeButton_Instance_ref.BackgroundColor3 = GetColor("Primary", CustomizeButton_Instance_ref, "BackgroundColor3")
	CustomizeButton_Instance_ref.BackgroundTransparency = 0 -- Themed
	CustomizeButton_Instance_ref.BorderColor3 = GetColor("Stroke", CustomizeButton_Instance_ref, "BorderColor3")
	CustomizeButton_Instance_ref.BorderSizePixel = 1
	CustomizeButton_Instance_ref.LayoutOrder = 1000 -- Ensure it's at the bottom if UIListLayout was on LayersTab
	CustomizeButton_Instance_ref.ZIndex = LayersTab_Instance.ZIndex + 1
	CustomizeButton_Instance_ref.Parent = LayersTab_Instance

	local CustomizeButton_UICorner = Instance.new("UICorner")
	CustomizeButton_UICorner.CornerRadius = UDim.new(0, 4)
	CustomizeButton_UICorner.Parent = CustomizeButton_Instance_ref

	local CustomizeButton_Icon = Instance.new("ImageLabel")
	CustomizeButton_Icon.Name = "Icon"
	CustomizeButton_Icon.Image = LoadUIAsset("rbxassetid://126800841735072", "CustomizeIcon.png") -- Settings/Gear Icon
	CustomizeButton_Icon.ImageColor3 = GetColor("Text", CustomizeButton_Icon, "ImageColor3")
	CustomizeButton_Icon.BackgroundTransparency = 1
	CustomizeButton_Icon.Size = UDim2.new(0, 20, 0, 20)
	CustomizeButton_Icon.Position = UDim2.new(0, 10, 0.5, -10) -- Left aligned, vertically centered
	CustomizeButton_Icon.Parent = CustomizeButton_Instance_ref

	local CustomizeButton_Text = Instance.new("TextLabel")
	CustomizeButton_Text.Name = "Text"
	CustomizeButton_Text.Text = "Customize"
	CustomizeButton_Text.Font = Enum.Font.GothamBold
	CustomizeButton_Text.TextSize = 14
	CustomizeButton_Text.TextColor3 = GetColor("Text", CustomizeButton_Text, "TextColor3")
	CustomizeButton_Text.BackgroundTransparency = 1
	CustomizeButton_Text.TextXAlignment = Enum.TextXAlignment.Left
	CustomizeButton_Text.Size = UDim2.new(1, -35, 1, 0) -- Fill space next to icon
	CustomizeButton_Text.Position = UDim2.new(0, 35, 0, 0) -- Positioned after icon
	CustomizeButton_Text.Parent = CustomizeButton_Instance_ref

	Separator_Instance_ref = Instance.new("Frame") -- Assign to forward-declared
	Separator_Instance_ref.Name = "CustomizeButtonSeparator"
	Separator_Instance_ref.BackgroundColor3 = GetColor("Stroke", Separator_Instance_ref, "BackgroundColor3")
	Separator_Instance_ref.BorderSizePixel = 0
	Separator_Instance_ref.Size = UDim2.new(1, -10, 0, 1) -- Matches CustomizeButton width, 1px height
	Separator_Instance_ref.AnchorPoint = Vector2.new(0.5, 1) -- Anchor to its top
	Separator_Instance_ref.Position = UDim2.new(0.5, 0, 1, -(CustomizeButton_Instance_ref.Size.Y.Offset + 5 + 5)) -- Position above CustomizeButton
	Separator_Instance_ref.ZIndex = LayersTab_Instance.ZIndex + 1
	Separator_Instance_ref.Parent = LayersTab_Instance

	--[[
        STEP 3: DEFINE ALL HELPER AND API FUNCTIONS
        All function definitions go here, now that the UI instances exist.
    ]]
	SaveFile_Local = function(Name, Value) -- Assign to forward-declared variable
		if not (writefile and GuiConfig and GuiConfig.SaveFolder) then
			warn("SaveFile_Local: Writefile, GuiConfig, or GuiConfig.SaveFolder not available.")
			return false
		end
		Flags[Name] = Value -- Assumes Flags is the script-level table, accessible here
		local success, err = pcall(function()
			local path = GuiConfig.SaveFolder
			if not path or path == "" then
				warn("SaveFile_Local: SaveFolder path is empty or not configured.")
				return
			end
			local encoded = HttpService:JSONEncode(Flags)
			writefile(path, encoded)
		end)
		if not success then
			warn("SaveFile_Local failed for Name:", Name, "Error:", err)
			return false
		end
		return true
	end

	LoadFile_Local = function() -- Assign to forward-declared variable
		if not (GuiConfig and GuiConfig["SaveFolder"]) then
			warn("LoadFile_Local: GuiConfig or GuiConfig.SaveFolder not available.")
			return false
		end
		local savePath = GuiConfig["SaveFolder"]
		if not savePath or savePath == "" then
			warn("LoadFile_Local: SaveFolder path is empty or not configured.")
			return false
		end
		if not (readfile and isfile and isfile(savePath)) then
			-- warn("LoadFile_Local: readfile/isfile not available or save file does not exist at path:", savePath) -- This can be noisy if file doesn't exist on first run.
			return false
		end
		local success, configJson = pcall(readfile, savePath)
		if not success or not configJson then
			warn("LoadFile_Local: Failed to read save file or file is empty:", savePath, "Error:", configJson)
			return false
		end

		local successDecode, loadedConfig = pcall(function() return HttpService:JSONDecode(configJson) end)
		if successDecode and type(loadedConfig) == "table" then
			for key, value in pairs(loadedConfig) do
				Flags[key] = value -- Merge loaded flags into the script-level Flags table
			end
			return true
		else
			warn("LoadFile_Local: Failed to decode save file or content is not a table:", savePath, "Error:", successDecode and "" or loadedConfig)
			-- Attempt to delete corrupted file to allow fresh start next time
			pcall(delfile, savePath)
			warn("LoadFile_Local: Corrupted config file deleted:", savePath)
			return false
		end
	end

	-- Initial load of flags if save file exists
	if not Flags.HasBeenLoadedByMakeGui then -- Prevent multiple loads if MakeGui is called multiple times
		LoadFile_Local()
		Flags.HasBeenLoadedByMakeGui = true
	end

	LoadUISize_Local = function(saveFlag)
		local savedValue = Flags[saveFlag]
		if type(savedValue) == "string" then
			local widthStr, heightStr = savedValue:match("^(%d+),(%d+)$")
			if widthStr and heightStr then
				local widthNum = tonumber(widthStr)
				local heightNum = tonumber(heightStr)
				if widthNum and heightNum then
					return UDim2.new(0, widthNum, 0, heightNum)
				end
			end
		end
		return nil -- Return nil if not found or invalid format
	end

	MakeDraggable_Local = function(topbarobject, objectToDrag)
		if topbarobject and objectToDrag then
			draggableElements[topbarobject] = {objectToDrag = objectToDrag}
		end
	end

	MakeResizable_Local = function(object, saveFlag)
		local resizeHandle = Instance.new("ImageLabel") -- Changed to ImageLabel for potential custom cursor/icon
		resizeHandle.Name = "ResizeHandle"
		resizeHandle.AnchorPoint = Vector2.new(1, 1)
		resizeHandle.Image = "rbxassetid://5401001915" -- Default resize cursor
		resizeHandle.ImageColor3 = GetColor("Accent", resizeHandle, "ImageColor3")
		resizeHandle.ImageTransparency = 0.3
		resizeHandle.BackgroundTransparency = 1
		resizeHandle.Size = UDim2.new(0, 16, 0, 16)
		resizeHandle.Position = UDim2.new(1, 0, 1, 0)
		resizeHandle.ZIndex = (object.ZIndex or 0) + 10 -- Ensure above parent
		resizeHandle.Parent = object

		local resizeAPI = {
			CurrentSize = object.Size,
			SaveFlag = saveFlag,
			handleSizeChange = nil,
			IsEnabled = true,
			SetEnabled = function(self, enabled)
				self.IsEnabled = enabled
				resizeHandle.Visible = enabled
			end
		}

		local function handleSizeChangeFunc(newSize)
			object.Size = newSize
			resizeAPI.CurrentSize = newSize
			if saveFlag then
				local sizeString = string.format("%d,%d", newSize.X.Offset, newSize.Y.Offset)
				SaveFile_Local(saveFlag, sizeString)
			end
		end
		resizeAPI.handleSizeChange = handleSizeChangeFunc

		if resizeHandle and object then
			resizableElements[resizeHandle] = {
				objectToResize = object,
				saveFlag = saveFlag,
				api = resizeAPI
			}
		end
		return resizeAPI
	end

	Color3ToHex_Local = function(color3)
		if not color3 then return "000000" end
		return string.format("%02x%02x%02x", math.floor(color3.R * 255), math.floor(color3.G * 255), math.floor(color3.B * 255))
	end

	HexToColor3_Local = function(hex)
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

	updateAllColorControls_Local = function() -- Renamed from previous global
		if SettingsPage_UI and not SettingsPage_UI.Visible then return end -- Use the specific settings page instance
		for key, controls in pairs(activeColorSliders) do
			if Themes[CurrentTheme] and Themes[CurrentTheme][key] then
				local currentColor = Themes[CurrentTheme][key]
				if controls.rSlider and controls.rSlider:GetValue() ~= math.floor(currentColor.R * 255) then controls.rSlider:SetValue(math.floor(currentColor.R * 255)) end
				if controls.gSlider and controls.gSlider:GetValue() ~= math.floor(currentColor.G * 255) then controls.gSlider:SetValue(math.floor(currentColor.G * 255)) end
				if controls.bSlider and controls.bSlider:GetValue() ~= math.floor(currentColor.B * 255) then controls.bSlider:SetValue(math.floor(currentColor.B * 255)) end
				if controls.hexInput and controls.hexInput:GetValue() ~= Color3ToHex_Local(currentColor) then controls.hexInput:SetValue(Color3ToHex_Local(currentColor)) end
			end
		end
	end

	-- Ensure global SetTheme calls our local update function if settings are visible
	local originalGlobalSetTheme = SetTheme -- Store original if not already
	SetTheme = function(themeName) -- Override global SetTheme
		originalGlobalSetTheme(themeName) -- Call original behavior
		if isSettingsViewActive or (CurrentTheme == "__customApplied" and SettingsPage_UI and SettingsPage_UI.Visible) then
			if updateAllColorControls_Local then task.delay(0.05, updateAllColorControls_Local) end
		end
	end

	createColorEditor_Local = function(section, colorKeyName, initialColor3) -- Renamed from previous global
		local function ensureMutableThemeAndApplyChange(targetColorKeyName, newFullColorValue)
			local isOriginalDefaultTheme = false
			if Themes[CurrentTheme] then
				local originalDefaultThemeNames = GetThemes() -- Assumes GetThemes is global and accessible
				isOriginalDefaultTheme = table.find(originalDefaultThemeNames, CurrentTheme) ~= nil
			end

			if isOriginalDefaultTheme and CurrentTheme ~= "__customApplied" then
				Themes["__customApplied"] = deepcopy(Themes[CurrentTheme]) -- deepcopy must be accessible
				Themes["__customApplied"][targetColorKeyName] = newFullColorValue
				SetTheme("__customApplied") -- Call the (now overridden) global SetTheme
			else
				if not Themes[CurrentTheme] then Themes[CurrentTheme] = {} end
				Themes[CurrentTheme][targetColorKeyName] = newFullColorValue
				SetTheme(CurrentTheme) -- Call the (now overridden) global SetTheme
			end
		end

		section:AddDivider({Text = colorKeyName})
		local r, g, b = math.floor(initialColor3.R * 255), math.floor(initialColor3.G * 255), math.floor(initialColor3.B * 255)

		local hexInput = section:AddInput({
			Title = "Hex Code", Content = "e.g., FF0000", Default = Color3ToHex_Local(initialColor3),
			Callback = function(hexValue)
				local newColor = HexToColor3_Local(hexValue)
				if newColor then
					ensureMutableThemeAndApplyChange(colorKeyName, newColor)
				else
					if Themes[CurrentTheme] and Themes[CurrentTheme][colorKeyName] then
						hexInput:SetValue(Color3ToHex_Local(Themes[CurrentTheme][colorKeyName])) -- Revert to current
					end
					if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Color Error", Description = "Invalid hex code."}) end
				end
			end
		})
		local rSlider = section:AddSlider({
			Title = "Red", Min = 0, Max = 255, Increment = 1, Default = r,
			Callback = function(newR)
				local baseColor = (Themes[CurrentTheme] and Themes[CurrentTheme][colorKeyName]) or Color3.new(0,0,0)
				local newFullColor = Color3.fromRGB(newR, math.floor(baseColor.G * 255), math.floor(baseColor.B * 255))
				ensureMutableThemeAndApplyChange(colorKeyName, newFullColor)
			end
		})
		local gSlider = section:AddSlider({
			Title = "Green", Min = 0, Max = 255, Increment = 1, Default = g,
			Callback = function(newG)
				local baseColor = (Themes[CurrentTheme] and Themes[CurrentTheme][colorKeyName]) or Color3.new(0,0,0)
				local newFullColor = Color3.fromRGB(math.floor(baseColor.R * 255), newG, math.floor(baseColor.B * 255))
				ensureMutableThemeAndApplyChange(colorKeyName, newFullColor)
			end
		})
		local bSlider = section:AddSlider({
			Title = "Blue", Min = 0, Max = 255, Increment = 1, Default = b,
			Callback = function(newB)
				local baseColor = (Themes[CurrentTheme] and Themes[CurrentTheme][colorKeyName]) or Color3.new(0,0,0)
				local newFullColor = Color3.fromRGB(math.floor(baseColor.R * 255), math.floor(baseColor.G * 255), newB)
				ensureMutableThemeAndApplyChange(colorKeyName, newFullColor)
			end
		})
		activeColorSliders[colorKeyName] = {hexInput = hexInput, rSlider = rSlider, gSlider = gSlider, bSlider = bSlider}
	end

	InternalCreateSection_Local = function(parentScrolLayersInstance, sectionTitle, sectionLayoutOrder)
		-- This function is quite large and was mostly complete in the previous version.
		-- For brevity here, I'll assume its internal structure (AddParagraph, AddButton, etc.)
		-- is largely the same as before, using the passed-in helper functions (GetColor, LoadUIAsset, etc.)
		-- The key is that it's defined *within* MakeGui's scope now.
		-- The original function signature was:
		-- InternalCreateSection_Local = function(parentScrolLayersInstance, sectionTitle, sectionLayoutOrder,
        --                               guiConfigRef, flagsRef, themesRef, currentThemeNameRefFunc,
        --                               getColorFunc, setThemeFunc, loadUIAssetFunc, saveFileFunc,
        --                               httpServiceRef, tweenServiceRef, mouseRef, circleClickFunc,
        --                               updateParentScrollFunc, parentUIListLayoutPaddingRef)
		-- We'll adapt it to use the MakeGui local scope variables directly or pass fewer arguments.

		sectionTitle = sectionTitle or "Section"

		local SectionFrame = Instance.new("Frame")
		SectionFrame.Name = "Section_" .. sectionTitle:gsub("%s+", "") -- Unique name
		SectionFrame.BackgroundTransparency = 1
		SectionFrame.BorderSizePixel = 0
		SectionFrame.LayoutOrder = sectionLayoutOrder
		SectionFrame.ClipsDescendants = true
		SectionFrame.Size = UDim2.new(1, 0, 0, 30) -- Initial height for header
		SectionFrame.Parent = parentScrolLayersInstance

		local SectionReal = Instance.new("Frame")
		SectionReal.Name = "SectionReal"
		SectionReal.AnchorPoint = Vector2.new(0.5, 0)
		SectionReal.BackgroundColor3 = GetColor("Secondary", SectionReal, "BackgroundColor3")
		SectionReal.BackgroundTransparency = 0
		SectionReal.BorderSizePixel = 0
		SectionReal.LayoutOrder = 1
		SectionReal.Position = UDim2.new(0.5,0,0,0)
		SectionReal.Size = UDim2.new(1,-4,0,30) -- Slightly less wide for padding/stroke
		SectionReal.Parent = SectionFrame
		Instance.new("UICorner", SectionReal).CornerRadius = UDim.new(0,4)

		local SectionButton = Instance.new("TextButton")
		SectionButton.Name = "SectionButton"
		SectionButton.Text = ""
		SectionButton.BackgroundTransparency = 1
		SectionButton.Size = UDim2.new(1,0,1,0)
		SectionButton.Parent = SectionReal

		local FeatureFrame_Section = Instance.new("ImageLabel", SectionReal) -- Combined Frame and ImageLabel
		FeatureFrame_Section.Name = "FeatureImg"
		FeatureFrame_Section.Image = LoadUIAsset("rbxassetid://16851841101", "FeatureImg_InternalSection")
		FeatureFrame_Section.ImageColor3 = GetColor("Text", FeatureFrame_Section, "ImageColor3")
		FeatureFrame_Section.AnchorPoint = Vector2.new(1,0.5)
		FeatureFrame_Section.BackgroundTransparency = 1
		FeatureFrame_Section.Position = UDim2.new(1,-5,0.5,0)
		FeatureFrame_Section.Rotation = -90
		FeatureFrame_Section.Size = UDim2.new(0,20,0,20)

		local SectionTitleText = Instance.new("TextLabel", SectionReal)
		SectionTitleText.Name = "SectionTitle"
		SectionTitleText.Font = Enum.Font.GothamBold
		SectionTitleText.Text = sectionTitle
		SectionTitleText.TextColor3 = GetColor("Text", SectionTitleText, "TextColor3")
		SectionTitleText.TextSize = 13
		SectionTitleText.TextXAlignment = Enum.TextXAlignment.Left
		SectionTitleText.TextYAlignment = Enum.TextYAlignment.Center
		SectionTitleText.AnchorPoint = Vector2.new(0,0.5)
		SectionTitleText.BackgroundTransparency = 1
		SectionTitleText.Position = UDim2.new(0,10,0.5,0)
		SectionTitleText.Size = UDim2.new(1,- (FeatureFrame_Section.Size.X.Offset + 15) ,1,0)

		local SectionDecideFrame = Instance.new("Frame", SectionFrame)
		SectionDecideFrame.Name = "SectionDecideFrame"
		SectionDecideFrame.AnchorPoint = Vector2.new(0.5,0)
		SectionDecideFrame.BackgroundColor3 = GetColor("Primary", SectionDecideFrame, "BackgroundColor3") -- Simplified
		SectionDecideFrame.BorderSizePixel = 0
		SectionDecideFrame.Position = UDim2.new(0.5,0,0,33) -- Below SectionReal
		SectionDecideFrame.Size = UDim2.new(1,-4,0,2)
		SectionDecideFrame.Visible = false
		Instance.new("UICorner", SectionDecideFrame).CornerRadius = UDim.new(0,2)

		local SectionAdd = Instance.new("Frame")
		SectionAdd.Name = "SectionContentHolder"
		SectionAdd.AnchorPoint = Vector2.new(0.5,0)
		SectionAdd.BackgroundTransparency = 1
		SectionAdd.BorderSizePixel = 0
		SectionAdd.ClipsDescendants = true
		SectionAdd.LayoutOrder = 2
		SectionAdd.Position = UDim2.new(0.5,0,0,38) -- Below DecideFrame
		SectionAdd.Size = UDim2.new(1,-4,0,0) -- Content height will be dynamic
		SectionAdd.Visible = false
		SectionAdd.Parent = SectionFrame
		Instance.new("UICorner", SectionAdd).CornerRadius = UDim.new(0,2)

		local UIListLayout_SectionAdd = Instance.new("UIListLayout", SectionAdd)
		UIListLayout_SectionAdd.Padding = UDim.new(0,5) -- Increased padding
		UIListLayout_SectionAdd.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_SectionAdd.HorizontalAlignment = Enum.HorizontalAlignment.Center

		local OpenSection = false
		local function UpdateThisInternalSectionSize()
			local totalContentHeight = 0
			if OpenSection and SectionAdd.Visible then
				totalContentHeight = UIListLayout_SectionAdd.AbsoluteContentSize.Y
			end
			local headerHeight = SectionReal.AbsoluteSize.Y
			local decideFrameHeight = (OpenSection and #SectionAdd:GetChildren() > 1) and SectionDecideFrame.Size.Y.Offset or 0
			local sectionAddVerticalPadding = (OpenSection and #SectionAdd:GetChildren() > 1) and 5 or 0

			SectionFrame.Size = UDim2.new(1, 0, 0, headerHeight + decideFrameHeight + totalContentHeight + sectionAddVerticalPadding + 5) -- Extra bottom padding

			if parentScrolLayersInstance and parentScrolLayersInstance:IsA("ScrollingFrame") then
				local parentLayout = parentScrolLayersInstance:FindFirstChildOfClass("UIListLayout")
				if parentLayout then
					parentScrolLayersInstance.CanvasSize = UDim2.new(0,0,0, parentLayout.AbsoluteContentSize.Y)
				end
			end
		end

		SectionButton.Activated:Connect(function()
			CircleClick(SectionButton, Mouse.X, Mouse.Y) -- CircleClick is global
			OpenSection = not OpenSection
			SectionAdd.Visible = OpenSection
			SectionDecideFrame.Visible = OpenSection and #SectionAdd:GetChildren() > 1
			FeatureFrame_Section.Rotation = OpenSection and 0 or -90
			UpdateThisInternalSectionSize()
		end)
		SectionAdd.ChildAdded:Connect(UpdateThisInternalSectionSize)
		SectionAdd.ChildRemoved:Connect(UpdateThisInternalSectionSize)
		UpdateThisInternalSectionSize()

		local SectionObject = {}
		SectionObject._SectionAdd = SectionAdd -- Expose content holder
		-- All AddItem, AddToggle etc. methods from the old InternalCreateSection go here,
		-- adapted to use the local scope (e.g. GetColor, SaveFile_Local, Flags, etc.)
		-- For example:
		function SectionObject:AddParagraph(ParagraphConfig)
			-- ... (implementation from old code, using GetColor, etc.)
			local ParagraphConfig = ParagraphConfig or {}
			ParagraphConfig.Title = ParagraphConfig.Title or "Title"
			ParagraphConfig.Content = ParagraphConfig.Content or "Content"
			local ParagraphFrame = Instance.new("Frame")
			ParagraphFrame.Name = "Paragraph"
			ParagraphFrame.Size = UDim2.new(1, -10, 0, 40) -- Example size, make dynamic
			ParagraphFrame.BackgroundColor3 = GetColor("Secondary")
			ParagraphFrame.BackgroundTransparency = 0.5
			ParagraphFrame.LayoutOrder = #SectionObject._SectionAdd:GetChildren()
			ParagraphFrame.Parent = SectionObject._SectionAdd
			Instance.new("UICorner", ParagraphFrame).CornerRadius = UDim.new(0,3)
			local TitleLabel = Instance.new("TextLabel", ParagraphFrame)
			TitleLabel.Text = ParagraphConfig.Title .. ": " .. ParagraphConfig.Content
			TitleLabel.TextColor3 = GetColor("Text")
			TitleLabel.Font = Enum.Font.Gotham
			TitleLabel.TextSize = 12
			TitleLabel.TextWrapped = true
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Size = UDim2.new(1,-10,1,-10)
			TitleLabel.Position = UDim2.new(0.5,0,0.5,0)
			TitleLabel.AnchorPoint = Vector2.new(0.5,0.5)
			task.delay(0,UpdateThisInternalSectionSize) -- Update size after adding
			return {} -- Return dummy API for now
		end
		function SectionObject:AddButton(ButtonConfig)
			ButtonConfig = ButtonConfig or {}
			local Button = Instance.new("TextButton")
			Button.Name = ButtonConfig.Title or "Button"
			Button.Text = ButtonConfig.Title or "Button"
			Button.TextColor3 = GetColor("Text")
			Button.BackgroundColor3 = GetColor("Primary")
			Button.Size = UDim2.new(1, -10, 0, 30)
			Button.Font = Enum.Font.GothamBold
			Button.TextSize = 13
			Button.LayoutOrder = #SectionObject._SectionAdd:GetChildren()
			Button.Parent = SectionObject._SectionAdd
			Instance.new("UICorner", Button).CornerRadius = UDim.new(0,3)
			if ButtonConfig.Callback then Button.Activated:Connect(ButtonConfig.Callback) end
			task.delay(0,UpdateThisInternalSectionSize)
			return {}
		end
		function SectionObject:AddToggle(ToggleConfig)
			ToggleConfig = ToggleConfig or {}
			local Default = (ToggleConfig.Flag and Flags[ToggleConfig.Flag]) or ToggleConfig.Default or false
			local Frame = Instance.new("Frame")
			Frame.Name = ToggleConfig.Title or "Toggle"
			Frame.Size = UDim2.new(1, -10, 0, 30)
			Frame.BackgroundColor3 = GetColor("Secondary")
			Frame.BackgroundTransparency = 0.5
			Frame.LayoutOrder = #SectionObject._SectionAdd:GetChildren()
			Frame.Parent = SectionObject._SectionAdd
			Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,3)
			local Title = Instance.new("TextLabel", Frame)
			Title.Text = ToggleConfig.Title or "Toggle"
			Title.TextColor3 = GetColor("Text")
			Title.Font = Enum.Font.Gotham
			Title.TextSize = 12
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0,5,0.5,0)
			Title.AnchorPoint = Vector2.new(0,0.5)
			Title.Size = UDim2.new(0.7,0,1,0)
			local Switch = Instance.new("TextButton", Frame) -- Visual switch
			Switch.Size = UDim2.new(0, 40, 0, 20)
			Switch.AnchorPoint = Vector2.new(1,0.5)
			Switch.Position = UDim2.new(1,-5,0.5,0)
			Switch.Text = ""
			Instance.new("UICorner", Switch).CornerRadius = UDim.new(0,10)
			local Nub = Instance.new("Frame", Switch)
			Nub.Size = UDim2.new(0.4,0,0.8,0)
			Nub.AnchorPoint = Vector2.new(0.5,0.5)
			Nub.BackgroundColor3 = GetColor("ThemeHighlight")
			Instance.new("UICorner", Nub).CornerRadius = UDim.new(1,0)
			local currentVal = Default
			local function updateVisual()
				Switch.BackgroundColor3 = currentVal and GetColor("Accent") or Color3.fromRGB(100,100,100)
				Nub.Position = currentVal and UDim2.new(0.75,0,0.5,0) or UDim2.new(0.25,0,0.5,0)
			end
			updateVisual()
			Frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					currentVal = not currentVal
					if ToggleConfig.Flag then SaveFile_Local(ToggleConfig.Flag, currentVal) end
					if ToggleConfig.Callback then ToggleConfig.Callback(currentVal) end
					updateVisual()
				end
			end)
			task.delay(0,UpdateThisInternalSectionSize)
			return {GetValue = function() return currentVal end, SetValue = function(val) currentVal = val; if ToggleConfig.Flag then SaveFile_Local(ToggleConfig.Flag, currentVal) end; if ToggleConfig.Callback then ToggleConfig.Callback(currentVal) end; updateVisual() end}
		end
		-- AddSlider, AddInput, AddDropdown, AddDivider would follow similar adaptation.
		function SectionObject:AddSlider(SliderConfig) return {SetValue = function() end, GetValue = function() return 0 end} end -- Placeholder
		function SectionObject:AddInput(InputConfig) return {SetValue = function() end, GetValue = function() return "" end} end -- Placeholder
		function SectionObject:AddDropdown(DropdownConfig) return {Refresh = function() end, GetValue = function() return {} end, SetValue = function() end} end -- Placeholder
		function SectionObject:AddDivider(DividerConfig) task.delay(0,UpdateThisInternalSectionSize); return {} end

		return SectionObject
	end

	ChangeAsset_Local = function(type, input, name)
		local mediaFolder = UBDir .."/".."Asset" -- UBDir is global
		if not isfolder(mediaFolder) then makefolder(mediaFolder) end
		local assetPath
		local success, err = pcall(function()
			if input:match("^https?://") or input:match("^rbxassetid://") then
				local data = game:HttpGet(input, true) -- True for binary data
				local extension = type == "Image" and ".png" or ".mp4"
				if not name:match("%..+$") then name = name .. extension end
				assetPath = mediaFolder.."/"..name
				writefile(assetPath, data)
			elseif input:lower() == "reset" then
				assetPath = "reset"
				return
			else -- Assume it's a local file path relative to workspace or an already full path
				assetPath = input -- This might need adjustment if not using getcustomasset fully
			end
		end)
		if not success then warn("ChangeAsset_Local: Error processing input:", err); return end

		if assetPath == "reset" then
			BackgroundImage.Image = ""
			BackgroundVideo.Video = ""
			BGImage, BGVideo = false, false
			BackgroundVideo.Playing = false
			return
		end

		local customAsset = getcustomasset and getcustomasset(assetPath) or assetPath

		if type == "Image" then
			BackgroundImage.Image = customAsset
			BackgroundVideo.Video = ""
			BGImage, BGVideo = true, false
			BackgroundVideo.Playing = false
		elseif type == "Video" then
			BackgroundVideo.Video = customAsset
			BackgroundImage.Image = ""
			BGVideo, BGImage = true, false
			BackgroundVideo.Playing = true
		end
		-- Update transparency of new background
		ChangeTransparency_Local(Main_Instance.BackgroundTransparency)
	end

	ResetAsset_Local = function()
		ChangeAsset_Local("Image", "reset", "reset") -- Use ChangeAsset_Local to handle reset logic
	end

	ChangeTransparency_Local = function(Trans) -- Transparency is 0-1
		Main_Instance.BackgroundTransparency = Trans
		if BGImage then BackgroundImage.ImageTransparency = Trans end
		if BGVideo then BackgroundVideo.BackgroundTransparency = Trans end -- VideoFrame uses BackgroundTransparency
	end

	-- GuiFunc methods (for external control if needed, e.g., by a command)
	function GuiFunc:DestroyGui()
		for _, conn in ipairs(connections) do
			if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then conn:Disconnect() end
		end
		table.clear(connections)
		if UBHubGui and UBHubGui.Parent then UBHubGui:Destroy() end
		if ScreenGui_Minimized and ScreenGui_Minimized.Parent then ScreenGui_Minimized:Destroy() end
		-- Restore original SetTheme if it was overridden by this MakeGui instance
		if originalGlobalSetTheme then SetTheme = originalGlobalSetTheme end
	end

	function GuiFunc:ToggleUI() -- Simulates RightShift press
		if DropShadowHolder then
			DropShadowHolder.Visible = not DropShadowHolder.Visible
			if MinimizedIcon then MinimizedIcon.Visible = not DropShadowHolder.Visible end
		end
	end
	UIInstance.Functions = GuiFunc -- Expose these functions

	function UIInstance:SelectTab(tabObject)
		if not tabObject or not tabObject._TabConfig then
			warn("SelectTab: Invalid tabObject or missing _TabConfig.")
			return
		end

		local selectedTabFrameInstance = tabObject.Instance -- This is the clickable tab button Frame in ScrollTab_Instance
		local isSettings = tabObject._IsSettingsTab

		-- Deselect all other user tabs
		if ScrollTab_Instance then
			for _, child in ipairs(ScrollTab_Instance:GetChildren()) do
				if child:IsA("Frame") and child.Name:match("^UserTabButton_") and child ~= selectedTabFrameInstance then
					child.BackgroundTransparency = 1 -- Deselected state
					local cf = child:FindFirstChild("ChooseFrame")
					if cf then cf.Visible = false end
				end
			end
		end

		-- Deselect customize button (if it's not the one being selected)
		if customizeButtonInstance and customizeButtonInstance ~= selectedTabFrameInstance then -- `selectedTabFrameInstance` will be nil for settings tab
			customizeButtonInstance.BackgroundTransparency = GetColor("Primary").Value -- Use actual themed color for deselected
		end

		if isSettings then
			if customizeButtonInstance then
				customizeButtonInstance.BackgroundTransparency = GetColor("Accent").Value -- Selected state for settings
			end
			if SettingsPage_UI then SettingsPage_UI.Visible = true end
			if LayersReal_Instance then LayersReal_Instance.Visible = false end
			if NameTab then NameTab.Text = "Customize" end
			isSettingsViewActive = true
			if SaveFile_Local then SaveFile_Local("LastSelectedUITabName", "__SETTINGS__") end
		else
			if selectedTabFrameInstance then
				selectedTabFrameInstance.BackgroundTransparency = GetColor("Accent").Value -- Selected state for user tabs
				local cf = selectedTabFrameInstance:FindFirstChild("ChooseFrame")
				if cf then cf.Visible = true end
			end
			if SettingsPage_UI then SettingsPage_UI.Visible = false end
			if LayersReal_Instance then LayersReal_Instance.Visible = true end
			if LayersPageLayout_Instance and tabObject._ScrolLayers then
				LayersPageLayout_Instance:JumpTo(tabObject._ScrolLayers)
			end
			if NameTab and tabObject._TabConfig then NameTab.Text = tabObject._TabConfig.Name end
			isSettingsViewActive = false
			if SaveFile_Local and tabObject._TabConfig then SaveFile_Local("LastSelectedUITabName", tabObject._TabConfig.Name) end
		end
	end

	function UIInstance:CreateTab(TabConfig)
		local TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab" .. (CountTab + 1)
		TabConfig.Icon = TabConfig.Icon or "rbxassetid://5028849290" -- Default icon (e.g., a gear or placeholder)
		TabConfig.IsSettingsTab = TabConfig.IsSettingsTab or false

		local tabContentHolder -- This will be the ScrollingFrame for the tab's content
		local tabContentLayout -- The UIListLayout within the content holder

		if TabConfig.IsSettingsTab then
			-- Settings tab uses the pre-existing SettingsPage_UI
			tabContentHolder = SettingsPage_UI -- SettingsPage_UI is the ScrollingFrame
			tabContentLayout = SettingsPageLayout_UI -- SettingsPageLayout_UI is its UIListLayout
			if not tabContentLayout then -- Ensure layout exists
				tabContentLayout = Instance.new("UIListLayout")
				tabContentLayout.Name = "SettingsPageLayout"
				tabContentLayout.Padding = UDim.new(0, 10)
				tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
				tabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				tabContentLayout.Parent = tabContentHolder
			end
		else
			-- User tabs get a new ScrollingFrame parented to LayersFolder_Instance
			tabContentHolder = Instance.new("ScrollingFrame")
			tabContentHolder.Name = "UserTabContent_" .. TabConfig.Name:gsub("%s+", "")
			tabContentHolder.Size = UDim2.new(1, 0, 1, 0) -- Full size of LayersReal_Instance
			tabContentHolder.BackgroundTransparency = 1
			tabContentHolder.BorderSizePixel = 0
			tabContentHolder.ScrollBarThickness = 6
			tabContentHolder.ScrollBarImageColor3 = GetColor("Accent")
			tabContentHolder.CanvasSize = UDim2.new(0,0,0,0) -- Dynamic
			tabContentHolder.LayoutOrder = CountTab -- For UIPageLayout sorting
			tabContentHolder.Parent = LayersFolder_Instance -- Parent to the UIPageLayout container

			tabContentLayout = Instance.new("UIListLayout")
			tabContentLayout.Name = "ContentLayout"
			tabContentLayout.Padding = UDim.new(0, 5)
			tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			tabContentLayout.Parent = tabContentHolder
		end

		local TabObject = {
			_TabConfig = TabConfig,
			_ScrolLayers = tabContentHolder, -- The ScrollingFrame holding this tab's content
			_UIListLayout = tabContentLayout, -- The UIListLayout for this tab's content
			_IsSettingsTab = TabConfig.IsSettingsTab,
			Instance = nil -- Will be the clickable tab button Frame for user tabs
		}

		local currentTabSectionCounter = 0 -- For layout order of sections within this tab

		if not TabConfig.IsSettingsTab then
			-- Create the clickable tab button in ScrollTab_Instance
			local tabButtonFrame = Instance.new("Frame")
			tabButtonFrame.Name = "UserTabButton_" .. TabConfig.Name:gsub("%s+", "")
			tabButtonFrame.Size = UDim2.new(1, -10, 0, 30) -- Full width of scroll area, fixed height
			tabButtonFrame.AnchorPoint = Vector2.new(0.5,0)
			tabButtonFrame.Position = UDim2.new(0.5,0,0,0)
			tabButtonFrame.BackgroundColor3 = GetColor("Primary", tabButtonFrame, "BackgroundColor3")
			tabButtonFrame.BackgroundTransparency = 1 -- Deselected state
			tabButtonFrame.LayoutOrder = CountTab
			tabButtonFrame.Parent = ScrollTab_Instance -- Parent to the list of tabs
			Instance.new("UICorner", tabButtonFrame).CornerRadius = UDim.new(0,3)

			local tabButton = Instance.new("TextButton")
			tabButton.Name = "ActualButton"
			tabButton.Text = ""
			tabButton.Size = UDim2.new(1,0,1,0)
			tabButton.BackgroundTransparency = 1
			tabButton.Parent = tabButtonFrame

			local tabIcon = Instance.new("ImageLabel")
			tabIcon.Name = "Icon"
			tabIcon.Image = TabConfig.Icon
			tabIcon.ImageColor3 = GetColor("Text", tabIcon, "ImageColor3")
			tabIcon.BackgroundTransparency = 1
			tabIcon.Size = UDim2.new(0,16,0,16)
			tabIcon.Position = UDim2.new(0,8,0.5,-8)
			tabIcon.Parent = tabButtonFrame

			local tabNameLabel = Instance.new("TextLabel")
			tabNameLabel.Name = "NameLabel"
			tabNameLabel.Text = TabConfig.Name
			tabNameLabel.Font = Enum.Font.Gotham
			tabNameLabel.TextSize = 13
			tabNameLabel.TextColor3 = GetColor("Text", tabNameLabel, "TextColor3")
			tabNameLabel.BackgroundTransparency = 1
			tabNameLabel.TextXAlignment = Enum.TextXAlignment.Left
			tabNameLabel.Position = UDim2.new(0, 8 + 16 + 5, 0.5, 0) -- Icon width + padding
			tabNameLabel.AnchorPoint = Vector2.new(0, 0.5)
			tabNameLabel.Size = UDim2.new(1, -(8+16+5+5), 1, 0) -- Fill remaining width
			tabNameLabel.Parent = tabButtonFrame

			local chooseFrame = Instance.new("Frame") -- Selection indicator
			chooseFrame.Name = "ChooseFrame"
			chooseFrame.BackgroundColor3 = GetColor("ThemeHighlight", chooseFrame, "BackgroundColor3")
			chooseFrame.BorderSizePixel = 0
			chooseFrame.AnchorPoint = Vector2.new(0,0.5)
			chooseFrame.Position = UDim2.new(0,0,0.5,0)
			chooseFrame.Size = UDim2.new(0,3,1,-6) -- Thin bar on the left
			chooseFrame.Visible = false
			Instance.new("UICorner",chooseFrame).CornerRadius = UDim.new(0,3)
			chooseFrame.Parent = tabButtonFrame

			TabObject.Instance = tabButtonFrame -- Store the clickable button frame

			tabButton.Activated:Connect(function()
				CircleClick(tabButton, Mouse.X, Mouse.Y) -- Mouse is global
				UIInstance:SelectTab(TabObject)
			end)

			table.insert(UIInstance.UserTabObjects, TabObject)
			CountTab = CountTab + 1 -- Increment for next user tab

			-- Update ScrollTab_Instance CanvasSize
			task.defer(function()
				if ScrollTab_Instance and UIListLayout_ScrollTab_Instance then
					ScrollTab_Instance.CanvasSize = UDim2.new(0,0,0, UIListLayout_ScrollTab_Instance.AbsoluteContentSize.Y)
				end
			end)
		else
			-- For settings tab, TabObject.Instance remains nil as it's activated by CustomizeButton
			-- The content holder is already SettingsPage_UI
		end

		function TabObject:AddSection(sectionTitle)
			sectionTitle = sectionTitle or "Section" .. (currentTabSectionCounter + 1)
			local newSection = InternalCreateSection_Local(
				tabContentHolder, -- Parent is the tab's own ScrollingFrame
				sectionTitle,
				currentTabSectionCounter
				-- Other args for InternalCreateSection_Local are implicitly from MakeGui's scope
			)
			currentTabSectionCounter = currentTabSectionCounter + 1
			return newSection
		end
		return TabObject
	end

	--[[
        STEP 4: POPULATE, CONNECT EVENTS, AND FINALIZE
    ]]
	-- Connect Events for Top Bar Buttons
	if CloseButton_Instance then
		CloseButton_Instance.Activated:Connect(function()
			CircleClick(CloseButton_Instance, Mouse.X, Mouse.Y) -- Assumes CircleClick and Mouse are accessible
			if UIInstance.Functions and UIInstance.Functions.DestroyGui then
				UIInstance.Functions.DestroyGui()
			else
				warn("DestroyGui function not found on UIInstance.Functions")
				if UBHubGui and UBHubGui.Parent then UBHubGui:Destroy() end -- Fallback
				if ScreenGui_Minimized and ScreenGui_Minimized.Parent then ScreenGui_Minimized:Destroy() end -- Fallback
			end
		end)
	else
		warn("MakeGui: CloseButton_Instance is nil, cannot connect event.")
	end

	if MinButton_Instance then
		MinButton_Instance.Activated:Connect(function()
			CircleClick(MinButton_Instance, Mouse.X, Mouse.Y)
			minimizedLastPosition = DropShadowHolder.Position -- DropShadowHolder is the main draggable/resizable window
			minimizedLastSize = DropShadowHolder.Size
			DropShadowHolder.Visible = false
			if MinimizedIcon then MinimizedIcon.Visible = true end
		end)
	else
		warn("MakeGui: MinButton_Instance is nil, cannot connect event.")
	end

	if MaxRestoreButton_Instance and ImageLabel_MaxRestoreIcon then
		MaxRestoreButton_Instance.Activated:Connect(function()
			CircleClick(MaxRestoreButton_Instance, Mouse.X, Mouse.Y)
			-- MAXIMIZE_ICON_ASSET and RESTORE_ICON_ASSET should have been loaded during Step 2
			if not MAXIMIZE_ICON_ASSET then MAXIMIZE_ICON_ASSET = LoadUIAsset("rbxassetid://9886659406", "MaxRestore_MaximizeIcon.png") end
			if not RESTORE_ICON_ASSET then RESTORE_ICON_ASSET = LoadUIAsset("rbxassetid://16598400946", "MaxRestore_RestoreIcon.png") end

			if isMaximized then -- Restore
				if OldPos_MaxRestore and OldSize_MaxRestore and DropShadowHolder and TweenService then
					TweenService:Create(DropShadowHolder, TweenInfo.new(0.2), {Position = OldPos_MaxRestore}):Play()
					TweenService:Create(DropShadowHolder, TweenInfo.new(0.2), {Size = OldSize_MaxRestore}):Play()
					ImageLabel_MaxRestoreIcon.Image = MAXIMIZE_ICON_ASSET
					isMaximized = false
				else
					warn("MakeGui: Cannot restore, missing OldPos/OldSize, DropShadowHolder, or TweenService.")
				end
			else -- Maximize
				OldPos_MaxRestore = DropShadowHolder.Position
				OldSize_MaxRestore = DropShadowHolder.Size
				if DropShadowHolder and UBHubGui and TweenService then
					local targetPosition = UDim2.new(0,0,0,0)
					local targetSize = UDim2.new(1,0,1,0)
					if UBHubGui.Parent == CoreGui then -- Maximize to full screen if parent is CoreGui
						targetSize = UDim2.new(1,0,1,0)
					else -- Maximize to parent's bounds if not CoreGui (e.g., another frame)
						targetSize = UDim2.new(1,0,1,0)
					end
					TweenService:Create(DropShadowHolder, TweenInfo.new(0.2), {Position = targetPosition}):Play()
					TweenService:Create(DropShadowHolder, TweenInfo.new(0.2), {Size = targetSize}):Play()
					ImageLabel_MaxRestoreIcon.Image = RESTORE_ICON_ASSET
					isMaximized = true
				else
					warn("MakeGui: Cannot maximize, missing DropShadowHolder, UBHubGui, or TweenService.")
				end
			end
		end)
	else
		warn("MakeGui: MaxRestoreButton_Instance or ImageLabel_MaxRestoreIcon is nil, cannot connect event.")
	end

	-- Minimized Icon Click Event (ScreenGui_Minimized and MinimizedIcon are created in Step 2)
	if MinimizedIcon then
		MinimizedIcon.MouseButton1Click:Connect(function()
			if DropShadowHolder then
				DropShadowHolder.Position = minimizedLastPosition or UDim2.new(0.1,0,0.1,0) -- Fallback position
				DropShadowHolder.Size = minimizedLastSize or SizeUI -- Fallback size
				DropShadowHolder.Visible = true
			end
			MinimizedIcon.Visible = false
		end)
	else
		warn("MakeGui: MinimizedIcon is nil, cannot connect event.")
	end

	local CustomizeTabObject = UIInstance:CreateTab({ IsSettingsTab = true })

	-- Ensure CustomizeButton_Instance_ref (the actual button instance from Step 2) is used for the connection.
	if CustomizeButton_Instance_ref then
		CustomizeButton_Instance_ref.Activated:Connect(function()
			CircleClick(CustomizeButton_Instance_ref, Mouse.X, Mouse.Y)
			UIInstance:SelectTab(CustomizeTabObject)
		end)
	else
		warn("MakeGui: CustomizeButton_Instance_ref is nil, cannot connect settings tab selection.")
	end

	-- Populate Settings Page (CustomizeTabObject)
	if CustomizeTabObject and CustomizeTabObject.AddSection then
		local PresetManagementSection = CustomizeTabObject:AddSection("Preset Management")
		if PresetManagementSection then
			local defaultThemes = GetThemes() -- Assumes GetThemes is global and returns a sorted list of names
			table.insert(defaultThemes, 1, "Select a Theme") -- Add a placeholder
			local defaultThemesDropdown = PresetManagementSection:AddDropdown({
				Title = "Default Themes", Content = "Select a built-in theme", Options = defaultThemes, Default = {"Select a Theme"},
				Callback = function(selected)
					-- Callback for when a theme is selected, not necessarily applied yet.
				end
			})
			PresetManagementSection:AddButton({ Title = "Apply Default Theme", Content = "Apply the selected default theme",
				Callback = function()
					local selectedValueTable = defaultThemesDropdown:GetValue()
					if selectedValueTable and #selectedValueTable > 0 and selectedValueTable[1] ~= "Select a Theme" then
						local themeToApply = selectedValueTable[1]
						SetTheme(themeToApply) -- Use the (overridden) global SetTheme
						if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Theme Applied", Description = "Applied theme: " .. themeToApply, Time = 0.3, Delay = 2}) end
					else
						if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Theme Error", Description = "No valid default theme selected.", Time = 0.3, Delay = 2}) end
					end
				end
			})
			PresetManagementSection:AddDivider({Text = "Custom Presets"})
			local customPresetNameInput = PresetManagementSection:AddInput({ Title = "Custom Preset Name", Content = "Enter a name for your new preset", Default = "" })

			local customThemesDropdownApply, customThemesDropdownDelete -- Forward declare for refresh function
			local function refreshCustomPresetDropdowns()
				local savedNames = {}; Flags.CustomUserThemes = Flags.CustomUserThemes or {}; for name,_ in pairs(Flags.CustomUserThemes) do table.insert(savedNames, name) end; table.sort(savedNames);
				--local placeholder = {"Manage Presets"} -- Not used
				local applyOptions = deepcopy(savedNames); table.insert(applyOptions, 1, "Select to Apply")
				local deleteOptions = deepcopy(savedNames); table.insert(deleteOptions, 1, "Select to Delete")

				if customThemesDropdownApply then customThemesDropdownApply:Refresh(applyOptions, {"Select to Apply"}) end
				if customThemesDropdownDelete then customThemesDropdownDelete:Refresh(deleteOptions, {"Select to Delete"}) end
			end

			PresetManagementSection:AddButton({ Title = "Save Current Colors", Content = "Save current colors as new preset",
				Callback = function()
					local presetName = customPresetNameInput:GetValue()
					if not presetName or presetName == "" then if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Save Error", Description = "Preset name cannot be empty."}) end; return end
					if Themes[CurrentTheme] then -- CurrentTheme is global
						Flags.CustomUserThemes = Flags.CustomUserThemes or {}
						Flags.CustomUserThemes[presetName] = deepcopy(Themes[CurrentTheme]) -- deepcopy global
						SaveFile_Local("CustomUserThemes", Flags.CustomUserThemes)
						refreshCustomPresetDropdowns()
						if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Preset Saved", Description = "'" .. presetName .. "' saved."}) end
					else
						if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Save Error", Description = "Cannot get current theme data for: " .. CurrentTheme}) end
					end
				end
			})
			customThemesDropdownApply = PresetManagementSection:AddDropdown({ Title = "Apply Custom Preset", Content = "Select a saved preset", Options = {"Select to Apply"} })
			PresetManagementSection:AddButton({ Title = "Apply Selected Custom", Content = "Load and apply chosen theme",
				Callback = function()
					local valTable = customThemesDropdownApply:GetValue()
					if valTable and #valTable > 0 and valTable[1] ~= "Select to Apply" then local pName = valTable[1]
						if Flags.CustomUserThemes and Flags.CustomUserThemes[pName] then
							Themes["__customApplied"] = deepcopy(Flags.CustomUserThemes[pName])
							SetTheme("__customApplied")
							if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Preset Applied", Description="'"..pName.."' applied."}) end
						else
							if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Apply Error", Description="Cannot find preset: "..pName}) end
						end
					else
						if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Apply Error", Description="No preset selected to apply."}) end
					end
				end
			})
			customThemesDropdownDelete = PresetManagementSection:AddDropdown({ Title = "Delete Custom Preset", Content = "Select preset to remove", Options = {"Select to Delete"} })
			PresetManagementSection:AddButton({ Title = "Delete Selected Custom", Content = "Remove chosen theme",
				Callback = function()
					local valTable = customThemesDropdownDelete:GetValue()
					if valTable and #valTable > 0 and valTable[1] ~= "Select to Delete" then local pName = valTable[1]
						if Flags.CustomUserThemes and Flags.CustomUserThemes[pName] then
							Flags.CustomUserThemes[pName] = nil
							SaveFile_Local("CustomUserThemes", Flags.CustomUserThemes)
							refreshCustomPresetDropdowns()
							if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Preset Deleted", Description="'"..pName.."' deleted."}) end
						else
							if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Delete Error", Description="Cannot find preset: "..pName}) end
						end
					else
						if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Delete Error", Description="No preset selected to delete."}) end
					end
				end
			})
			refreshCustomPresetDropdowns() -- Initial population
		end

		local InterfaceSection = CustomizeTabObject:AddSection("Interface Settings")
		if InterfaceSection then
			InterfaceSection:AddSlider({ Title = "Window Transparency", Content = "Adjust background opacity (0-100)", Min = 0, Max = 100, Increment = 1, Default = ( (Flags.UI_BackgroundTransparency == nil and 10) or Flags.UI_BackgroundTransparency ), Callback = function(value) ChangeTransparency_Local(value / 100); SaveFile_Local("UI_BackgroundTransparency", value) end })
			local bgAssetInput = InterfaceSection:AddInput({ Title = "Background URL/Path", Content = "Image/video URL or local path for background", Default = Flags.CustomBackgroundURL or "", Callback = function(val) SaveFile_Local("CustomBackgroundURL", val) end})
			InterfaceSection:AddButton({ Title = "Set Image Background", Content = "Use URL/Path as image", Callback = function() local assetUrl = bgAssetInput:GetValue(); if assetUrl and assetUrl ~= "" then ChangeAsset_Local("Image", assetUrl, "CustomBG_Img"); SaveFile_Local("CustomBackgroundURL", assetUrl); SaveFile_Local("CustomBackgroundType", "Image") end end})
			InterfaceSection:AddButton({ Title = "Set Video Background", Content = "Use URL/Path as video", Callback = function() local assetUrl = bgAssetInput:GetValue(); if assetUrl and assetUrl ~= "" then ChangeAsset_Local("Video", assetUrl, "CustomBG_Vid"); SaveFile_Local("CustomBackgroundURL", assetUrl); SaveFile_Local("CustomBackgroundType", "Video") end end})
			InterfaceSection:AddButton({ Title = "Reset Background", Content = "Remove custom background", Callback = function() ResetAsset_Local(); SaveFile_Local("CustomBackgroundURL", ""); SaveFile_Local("CustomBackgroundType", "") end})
		end

		local CustomizeColorsSection = CustomizeTabObject:AddSection("Theme Colors")
		if CustomizeColorsSection and CANONICAL_THEME_COLOR_KEYS and #CANONICAL_THEME_COLOR_KEYS > 0 then
			for _, colorKeyName in ipairs(CANONICAL_THEME_COLOR_KEYS) do
				local initialEditorColor = (Themes[CurrentTheme] and Themes[CurrentTheme][colorKeyName]) or Color3.new(0,0,0)
				if type(initialEditorColor) ~= "Color3" then initialEditorColor = Color3.new(0,0,0); warn("MakeGui: Non-Color3 value found for key:", colorKeyName, "in current theme:", CurrentTheme, "- defaulting to black for editor.") end
				createColorEditor_Local(CustomizeColorsSection, colorKeyName, initialEditorColor)
			end
		else
		    if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Theme System Error", Description = "Cannot create color editors. List empty or section failed."}) end
		end
	else
		warn("MakeGui: CustomizeTabObject or its AddSection method is nil. Cannot populate settings.")
	end

	-- Final startup logic
	task.defer(function()
		-- Center the GUI initially
		if UBHubGui and DropShadowHolder and UBHubGui.AbsoluteSize.X > 0 and UBHubGui.AbsoluteSize.Y > 0 and DropShadowHolder.AbsoluteSize.X > 0 then
			local parentSize = UBHubGui.AbsoluteSize
			local windowSize = DropShadowHolder.AbsoluteSize
			DropShadowHolder.Position = UDim2.new(
				0, math.floor((parentSize.X - windowSize.X) / 2),
				0, math.floor((parentSize.Y - windowSize.Y) / 2)
			)
		else
			warn("MakeGui: Could not center DropShadowHolder initially due to missing elements or zero size.")
		end

		-- Load initial theme (should be done before most UI is visible or interacted with)
		local themeToLoadOnStartup = Flags.LastThemeName -- This flag is from the old system, ensure it's loaded by LoadFile_Local
		if themeToLoadOnStartup then
			local customThemeData = Flags.LastCustomThemeData
			if customThemeData and ( (Flags.CustomUserThemes and Flags.CustomUserThemes[themeToLoadOnStartup]) or themeToLoadOnStartup == "__customApplied" or themeToLoadOnStartup == "__loadedStartupTheme" or not Themes[themeToLoadOnStartup] ) then
				Themes["__loadedStartupTheme"] = deepcopy(customThemeData) -- Ensure deepcopy is available
				SetTheme("__loadedStartupTheme") -- Use the overridden SetTheme
			elseif Themes[themeToLoadOnStartup] then
				SetTheme(themeToLoadOnStartup)
			else
				SetTheme(CurrentTheme) -- Fallback to current global theme if saved one is invalid
			end
		else
			SetTheme(CurrentTheme) -- Fallback if no theme saved
		end

		-- Apply initial saved UI size
		local loadedWindowSize = LoadUISize_Local("UI_Size") -- UI_Size is the flag name
		if loadedWindowSize then
			DropShadowHolder.Size = loadedWindowSize
		else
			-- Default size if not saved (SizeUI is global, SHADOW_PADDING is local to MakeGui)
			DropShadowHolder.Size = UDim2.new(0, SizeUI.X.Offset + 2 * SHADOW_PADDING, 0, SizeUI.Y.Offset + 2 * SHADOW_PADDING)
		end
		-- Re-center after size is potentially set from save (AbsoluteSize might change)
		task.delay(0.05, function() -- Delay slightly for size changes to propagate
			if UBHubGui and DropShadowHolder and UBHubGui.AbsoluteSize.X > 0 and UBHubGui.AbsoluteSize.Y > 0 and DropShadowHolder.AbsoluteSize.X > 0 then
				local parentSize = UBHubGui.AbsoluteSize
				local windowSize = DropShadowHolder.AbsoluteSize
				DropShadowHolder.Position = UDim2.new(
					0, math.floor((parentSize.X - windowSize.X) / 2),
					0, math.floor((parentSize.Y - windowSize.Y) / 2)
				)
			end
		end)

		-- Apply initial background if saved
		if Flags.CustomBackgroundURL and Flags.CustomBackgroundURL ~= "" then
			local bgType = Flags.CustomBackgroundType or "Image"
			ChangeAsset_Local(bgType, Flags.CustomBackgroundURL, "InitialBG_Startup")
		end
		if Flags.UI_BackgroundTransparency then -- This is 0-100
			ChangeTransparency_Local(Flags.UI_BackgroundTransparency / 100)
		else
			ChangeTransparency_Local(0.1) -- Default transparency (0.1 = 10% opaque for main background)
		end

		-- Select initial tab
		local successfullySelectedSavedTab = false
		local lastSelectedUITabNameFromFlags = Flags.LastSelectedUITabName -- Flag used by new SelectTab

		if lastSelectedUITabNameFromFlags == "__SETTINGS__" then
			UIInstance:SelectTab(CustomizeTabObject)
			successfullySelectedSavedTab = true
		elseif lastSelectedUITabNameFromFlags and UIInstance.UserTabObjects and #UIInstance.UserTabObjects > 0 then
			for _, tabObjInList in ipairs(UIInstance.UserTabObjects) do
				if tabObjInList._TabConfig and tabObjInList._TabConfig.Name == lastSelectedUITabNameFromFlags then
					UIInstance:SelectTab(tabObjInList)
					successfullySelectedSavedTab = true
					break
				end
			end
		end

		if not successfullySelectedSavedTab then
			if UIInstance.UserTabObjects and #UIInstance.UserTabObjects > 0 then
				UIInstance:SelectTab(UIInstance.UserTabObjects[1]) -- Select first user tab
			elseif CustomizeTabObject then
				UIInstance:SelectTab(CustomizeTabObject) -- Or settings if no user tabs
			else
				warn("MakeGui: No user tabs and no CustomizeTabObject to select initially.")
				if NameTab then NameTab.Text = "" end -- Clear title
				if SettingsPage_UI then SettingsPage_UI.Visible = false end
				if LayersReal_Instance then LayersReal_Instance.Visible = true end -- Default to user tab area
				if LayersPageLayout_Instance then LayersPageLayout_Instance:Clear() end -- Clear any pages if layout exists
			end
		end

		-- Make Draggable and Resizable (after initial size/pos set)
		MakeDraggable_Local(Top_Instance, DropShadowHolder) -- Top_Instance is the top bar Frame
		local resizeAPI = MakeResizable_Local(DropShadowHolder, "UI_Size") -- DropShadowHolder is the main window
		if resizeAPI and Flags["DisableResize"] then -- Example flag to disable resizing
			resizeAPI:SetEnabled(false)
		end

		-- Ensure main GUI is parented correctly if ProtectGui didn't handle it
		if UBHubGui and UBHubGui.Parent ~= CoreGui and CoreGui then
			UBHubGui.Parent = CoreGui
		end
		if ScreenGui_Minimized and ScreenGui_Minimized.Parent ~= CoreGui and CoreGui then
		    ScreenGui_Minimized.Parent = CoreGui
		end
		-- (Your logic to select the initial tab)
	end)

	return UIInstance
end
return UBHubLib
