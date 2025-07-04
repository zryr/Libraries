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
	-- Step 1: Initialization
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
	GuiConfig["SaveFolder"] = GuiConfig["SaveFolder"] or false

	local UIInstance = { UserTabObjects = {} }
	local connections = {}          -- For managing event connections that need cleanup
	local draggableElements = {}    -- For MakeDraggable
	local resizableElements = {}    -- For MakeResizable
	-- Flags table is at script scope, already initialized

	-- Input handling variables (centralized)
	local isWindowDragging = false
	local isWindowResizing = false
	local windowDragTarget = nil
	local windowDragInitiator = nil
	local windowResizeTarget = nil
	local windowResizeInitiator = nil
	local windowDragStartMouse = Vector2.new()
	local windowDragStartPos = UDim2.new()
	local windowResizeStartMouse = Vector2.new()
	local windowResizeStartSize = UDim2.new()

	-- Placeholders for UI elements to be created in Step 2
	local UBHubGui, DropShadowHolder, Main, Top, TextLabel_Title, TextLabel_Description, UICorner_Top, UIStroke_Description
	local MaxRestore, ImageLabel_MaxRestoreIcon, Close, ImageLabel_CloseIcon, Min, ImageLabel_MinIcon
	local LayersTab, UICorner_LayersTab, ScrollTab, UIListLayout_ScrollTab, NewCustomizeButton, CustomizeButtonSeparator -- Renamed Separator_CustomizeButton
	local Layers, UICorner_Layers, NameTab, LayersReal, LayersFolder, LayersPageLayout
	local SettingsPage_UI, SettingsPageLayout_UI -- Renamed to avoid conflict with global SettingsPage
	local MoreBlur, ConnectButton_MoreBlur, DropdownSelect, DropdownFolder, DropPageLayout
	local ScreenGui_Minimized, MinimizedIcon, MinCorner_MinimizedIcon -- Renamed ScreenGui to ScreenGui_Minimized
	local BackgroundImage, BackgroundVideo -- For custom backgrounds
	local activeColorSliders = {} -- For theme customization
	local ScrolLayersMap = {} -- Maps Tab Frame to its ScrollingFrame content page
	local FrameToTabObjectMap = {} -- Maps Tab Frame to its TabObject
	-- local isSettingsViewActive = false -- Already global
	-- local lastSelectedTabName = "" -- Already global
	local customizeButtonInstance -- Will hold the NewCustomizeButton
	-- local MAXIMIZE_ICON_ASSET, RESTORE_ICON_ASSET -- These are loaded by LoadUIAsset, no need to pre-declare if only used in MakeGui
	local OldPos_MaxRestore, OldSize_MaxRestore -- For Max/Restore functionality
	local minimizedLastPosition, minimizedLastSize -- For Minimize/Restore from icon
	local isMaximized = false -- State for Max/Restore
	local BGImage, BGVideo -- Flags for background type, should be local to MakeGui if not used elsewhere.

	-- Helper function placeholders (will be fully defined in Step 3)
	local InternalCreateSection_Local, createColorEditor_Local, Color3ToHex_Local, HexToColor3_Local, updateAllColorControls_Local -- Add _Local to avoid conflict with global
	local SaveFile_Local, LoadFile_Local, LoadUISize_Local, MakeDraggable_Local, MakeResizable_Local, CircleClick_Local -- Add _Local
	local ChangeAsset_Local, ResetAsset_Local, ChangeTransparency_Local -- Add _Local
	-- GetThemes, GetColor, SetTheme, LoadUIAsset are global or defined outside MakeGui, so no _Local needed if they are the intended ones.
	-- However, to be safe, if they are intended to be *local helpers* for MakeGui, they should be defined *inside* MakeGui.
	-- The prompt implies these are part of the "Define All Helper and API Functions" step *within* MakeGui.

	-- Note: `Flags` is already at script scope. `Themes` and `CurrentTheme` are also at script scope.
	-- `deepcopy`, `HttpService`, `TweenService`, `Mouse`, `UserInputService`, `RunService`, `CoreGui`, `ProtectGui`
	-- are assumed to be available from the higher script scope.
	-- `SizeUI` from outer scope seems to be a default, can be kept or overridden.
	-- `CountTab` and `CountDropdown` are global library counters, correctly so.
	-- `LibraryCfg` and `UBDir` are global.
	-- `CANONICAL_THEME_COLOR_KEYS` is global.

	-- Ensure GuiConfig["Tab Width"] is a number for later calculations
	GuiConfig["Tab Width"] = tonumber(GuiConfig["Tab Width"]) or 120

	-- Step 2: Create ALL UI Instances

	UBHubGui = Instance.new("ScreenGui")
	ProtectGui(UBHubGui)
	UBHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	UBHubGui.Name = "UBHubGui"
	-- UBHubGui.Parent will be set at the end of MakeGui, or by ProtectGui if it handles parenting

	DropShadowHolder = Instance.new("Frame")
	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.BackgroundColor3 = Color3.new(0, 0, 0)
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.ZIndex = 0
	DropShadowHolder.Size = SizeUI -- Initial Size, will be adjusted
	DropShadowHolder.Position = UDim2.new(0.1, 0, 0.1, 0) -- Temporary, centered later
	DropShadowHolder.Parent = UBHubGui

	local DropShadow = Instance.new("ImageLabel") -- Local as it's only configured here
	DropShadow.Name = "DropShadow"
	DropShadow.Image = "" -- Will be set by theme or default
	DropShadow.ImageColor3 = Color3.fromRGB(15, 15, 15)
	DropShadow.ImageTransparency = 0.5
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 0, 1, 0)
	DropShadow.ZIndex = 0
	DropShadow.Parent = DropShadowHolder

	local SHADOW_PADDING = 24

	Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.AnchorPoint = Vector2.new(0, 0)
	-- Main.BackgroundColor3 will be set by theme
	Main.BackgroundTransparency = 0.1 -- Default, can be changed by theme/settings
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0, SHADOW_PADDING, 0, SHADOW_PADDING)
	Main.Size = UDim2.new(1, -2 * SHADOW_PADDING, 1, -2 * SHADOW_PADDING)
	Main.ZIndex = 1
	Main.Parent = DropShadowHolder

	UICorner_Top = Instance.new("UICorner") -- For Main frame
	UICorner_Top.Parent = Main

	local UIStroke_Main = Instance.new("UIStroke") -- For Main frame
	-- UIStroke_Main.Color will be set by theme
	UIStroke_Main.Thickness = 1.6
	UIStroke_Main.Parent = Main

	BackgroundImage = Instance.new("ImageLabel")
	BackgroundImage.Name = "MainImage"
	BackgroundImage.Size = UDim2.new(1,0,1,0)
	BackgroundImage.BackgroundTransparency = 1
	BackgroundImage.ImageTransparency = 1 -- Start transparent
	BackgroundImage.Parent = Main

	BackgroundVideo = Instance.new("VideoFrame")
	BackgroundVideo.Name = "MainVideo"
	BackgroundVideo.Size = UDim2.new(1,0,1,0)
	BackgroundVideo.BackgroundTransparency = 1
	BackgroundVideo.Looped = true
	BackgroundVideo.Playing = false -- Start paused
	BackgroundVideo.Parent = Main

	Top = Instance.new("Frame")
	Top.Name = "Top"
	-- Top.BackgroundColor3 will be set by theme
	Top.BackgroundTransparency = 0.999
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 38)
	Top.Parent = Main

	local mainTopPadding = Instance.new("UIPadding", Top)
	mainTopPadding.PaddingLeft = UDim.new(0, 10)
	mainTopPadding.PaddingRight = UDim.new(0, 85) -- Space for buttons

	local mainTopListLayout = Instance.new("UIListLayout", Top)
	mainTopListLayout.FillDirection = Enum.FillDirection.Horizontal
	mainTopListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	mainTopListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	mainTopListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	mainTopListLayout.Padding = UDim.new(0, 5)

	TextLabel_Title = Instance.new("TextLabel") -- Renamed from TextLabel
	TextLabel_Title.Name = "TitleText"
	TextLabel_Title.Font = Enum.Font.GothamBold
	TextLabel_Title.Text = GuiConfig.NameHub
	-- TextLabel_Title.TextColor3 will be set by theme
	TextLabel_Title.TextSize = 14
	TextLabel_Title.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel_Title.BackgroundTransparency = 1
	TextLabel_Title.Size = UDim2.new(0,0,1,0)
	TextLabel_Title.AutomaticSize = Enum.AutomaticSize.X
	TextLabel_Title.Parent = Top

	local UICorner_TopBar = Instance.new("UICorner") -- For the Top bar itself
    UICorner_TopBar.Parent = Top

	TextLabel_Description = Instance.new("TextLabel") -- Renamed from TextLabel1
	TextLabel_Description.Name = "DescriptionText"
	TextLabel_Description.Font = Enum.Font.GothamBold
	TextLabel_Description.Text = GuiConfig.Description
	-- TextLabel_Description.TextColor3 will be set by theme
	TextLabel_Description.TextSize = 14
	TextLabel_Description.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel_Description.BackgroundTransparency = 1
	TextLabel_Description.Size = UDim2.new(1,0,1,0)
	TextLabel_Description.Parent = Top

	UIStroke_Description = Instance.new("UIStroke") -- Renamed from UIStroke1
	-- UIStroke_Description.Color will be set by theme
	UIStroke_Description.Thickness = 0.4
	UIStroke_Description.Parent = TextLabel_Description

	Close = Instance.new("TextButton")
	Close.Name = "Close"
	Close.Font = Enum.Font.SourceSans
	Close.Text = ""
	Close.AnchorPoint = Vector2.new(1, 0.5)
	Close.BackgroundTransparency = 1
	Close.Position = UDim2.new(1, -8, 0.5, 0)
	Close.Size = UDim2.new(0, 25, 0, 25)
	Close.Parent = Top

	ImageLabel_CloseIcon = Instance.new("ImageLabel") -- Renamed from ImageLabel1
	ImageLabel_CloseIcon.Name = "CloseIcon"
	-- ImageLabel_CloseIcon.Image will be set by LoadUIAsset
	ImageLabel_CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_CloseIcon.BackgroundTransparency = 1
	ImageLabel_CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel_CloseIcon.Size = UDim2.new(1, -8, 1, -8)
	ImageLabel_CloseIcon.Parent = Close

	MaxRestore = Instance.new("TextButton")
	MaxRestore.Name = "MaxRestore"
	MaxRestore.Font = Enum.Font.SourceSans
	MaxRestore.Text = ""
	MaxRestore.AnchorPoint = Vector2.new(1, 0.5)
	MaxRestore.BackgroundTransparency = 1
	MaxRestore.Position = UDim2.new(1, -34, 0.5, 0) -- Adjusted for spacing
	MaxRestore.Size = UDim2.new(0, 25, 0, 25)
	MaxRestore.Parent = Top

	ImageLabel_MaxRestoreIcon = Instance.new("ImageLabel") -- Renamed from ImageLabel
	ImageLabel_MaxRestoreIcon.Name = "MaxRestoreIcon"
	-- ImageLabel_MaxRestoreIcon.Image will be set by LoadUIAsset
	ImageLabel_MaxRestoreIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_MaxRestoreIcon.BackgroundTransparency = 1
	ImageLabel_MaxRestoreIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel_MaxRestoreIcon.Size = UDim2.new(1, -8, 1, -8)
	ImageLabel_MaxRestoreIcon.Parent = MaxRestore -- Corrected Parent

	Min = Instance.new("TextButton")
	Min.Name = "Min"
	Min.Font = Enum.Font.SourceSans
	Min.Text = ""
	Min.AnchorPoint = Vector2.new(1, 0.5)
	Min.BackgroundTransparency = 1
	Min.Position = UDim2.new(1, -60, 0.5, 0) -- Adjusted for spacing
	Min.Size = UDim2.new(0, 25, 0, 25)
	Min.Parent = Top

	ImageLabel_MinIcon = Instance.new("ImageLabel") -- Renamed from ImageLabel2
	ImageLabel_MinIcon.Name = "MinIcon"
	-- ImageLabel_MinIcon.Image will be set by LoadUIAsset
	ImageLabel_MinIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_MinIcon.BackgroundTransparency = 1
	ImageLabel_MinIcon.ImageTransparency = 0.2 -- Default
	ImageLabel_MinIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel_MinIcon.Size = UDim2.new(1, -9, 1, -9)
	ImageLabel_MinIcon.Parent = Min

	local DecideFrame_TopSeparator = Instance.new("Frame") -- Renamed from DecideFrame
	DecideFrame_TopSeparator.Name = "DecideFrame_TopSeparator"
	DecideFrame_TopSeparator.AnchorPoint = Vector2.new(0.5, 0)
	-- DecideFrame_TopSeparator.BackgroundColor3 will be set by theme
	DecideFrame_TopSeparator.BackgroundTransparency = 0.85
	DecideFrame_TopSeparator.BorderSizePixel = 0
	DecideFrame_TopSeparator.Position = UDim2.new(0.5, 0, 0, 38)
	DecideFrame_TopSeparator.Size = UDim2.new(1, 0, 0, 1)
	DecideFrame_TopSeparator.Parent = Main

	local TOP_BAR_DESIGN_HEIGHT = Top.Size.Y.Offset
	local PADDING_BELOW_TOP_BAR = 10
	local LAYERS_TAB_X_PADDING = 9
	local GENERAL_BOTTOM_MARGIN = 9
	local PADDING_BETWEEN_TABS_AND_CONTENT = 9
	local LAYERS_TAB_WIDTH = GuiConfig["Tab Width"]

	local calculatedLayersTabYPos = TOP_BAR_DESIGN_HEIGHT + PADDING_BELOW_TOP_BAR
	local layersTabTotalVerticalSpaceToExclude = calculatedLayersTabYPos + GENERAL_BOTTOM_MARGIN
	local layersContentXStart = LAYERS_TAB_X_PADDING + LAYERS_TAB_WIDTH + PADDING_BETWEEN_TABS_AND_CONTENT
	local layersContentTotalHorizontalSpaceToExclude = layersContentXStart + LAYERS_TAB_X_PADDING

	LayersTab = Instance.new("Frame")
	LayersTab.Name = "LayersTab"
	LayersTab.BackgroundTransparency = 1
	LayersTab.BorderSizePixel = 0
	LayersTab.Position = UDim2.new(0, LAYERS_TAB_X_PADDING, 0, calculatedLayersTabYPos)
	LayersTab.Size = UDim2.new(0, LAYERS_TAB_WIDTH, 1, -layersTabTotalVerticalSpaceToExclude)
	LayersTab.Parent = Main

	UICorner_LayersTab = Instance.new("UICorner") -- Renamed from UICorner2
	UICorner_LayersTab.CornerRadius = UDim.new(0, 2)
	UICorner_LayersTab.Parent = LayersTab

	ScrollTab = Instance.new("ScrollingFrame")
	ScrollTab.Name = "ScrollTab"
	ScrollTab.CanvasSize = UDim2.new(0,0,0,0)
	ScrollTab.ScrollBarThickness = 0
	ScrollTab.Active = true
	ScrollTab.BackgroundTransparency = 1
	ScrollTab.BorderSizePixel = 0
	ScrollTab.Size = UDim2.new(1, 0, 1, -41) -- Leaves space for CustomizeButton
	ScrollTab.Parent = LayersTab

	UIListLayout_ScrollTab = Instance.new("UIListLayout") -- Renamed from UIListLayout
	UIListLayout_ScrollTab.Padding = UDim.new(0, 3)
	UIListLayout_ScrollTab.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_ScrollTab.Parent = ScrollTab

	NewCustomizeButton = Instance.new("TextButton")
	NewCustomizeButton.Name = "CustomizeButton"
	NewCustomizeButton.Text = ""
	NewCustomizeButton.AnchorPoint = Vector2.new(0, 1)
	NewCustomizeButton.Position = UDim2.new(0, 0, 1, 0)
	NewCustomizeButton.Size = UDim2.new(1, 0, 0, 40)
	-- NewCustomizeButton.BackgroundColor3 will be set by theme
	NewCustomizeButton.BackgroundTransparency = 0
	-- NewCustomizeButton.BorderColor3 will be set by theme
	NewCustomizeButton.BorderSizePixel = 1
	NewCustomizeButton.LayoutOrder = 1000
	NewCustomizeButton.Parent = LayersTab
	customizeButtonInstance = NewCustomizeButton -- Assign here

	local NewCustomizeButtonCorner = Instance.new("UICorner", NewCustomizeButton)
	NewCustomizeButtonCorner.CornerRadius = UDim.new(0, 4)

	local NewCustomizeIcon = Instance.new("ImageLabel", NewCustomizeButton)
	NewCustomizeIcon.Name = "CustomizeIcon"
	NewCustomizeIcon.Image = "rbxassetid://126800841735072" -- Placeholder, will be themed
	-- NewCustomizeIcon.ImageColor3 will be set by theme
	NewCustomizeIcon.BackgroundTransparency = 1
	NewCustomizeIcon.Size = UDim2.new(0, 20, 0, 20)
	NewCustomizeIcon.Position = UDim2.new(0, 10, 0.5, -10)

	local NewCustomizeText = Instance.new("TextLabel", NewCustomizeButton)
	NewCustomizeText.Name = "CustomizeText"
	NewCustomizeText.Text = "Customize"
	NewCustomizeText.Font = Enum.Font.GothamBold
	NewCustomizeText.TextSize = 14
	-- NewCustomizeText.TextColor3 will be set by theme
	NewCustomizeText.BackgroundTransparency = 1
	NewCustomizeText.TextXAlignment = Enum.TextXAlignment.Left
	NewCustomizeText.Size = UDim2.new(0, 100, 1, 0)
	NewCustomizeText.Position = UDim2.new(0, 35, 0, 0)

	CustomizeButtonSeparator = Instance.new("Frame")
	CustomizeButtonSeparator.Name = "CustomizeButtonSeparator"
	-- CustomizeButtonSeparator.BackgroundColor3 will be set by theme
	CustomizeButtonSeparator.BorderSizePixel = 0
	CustomizeButtonSeparator.Size = UDim2.new(1, 0, 0, 1)
	CustomizeButtonSeparator.AnchorPoint = Vector2.new(0, 1)
	CustomizeButtonSeparator.Position = UDim2.new(0, 0, 1, -NewCustomizeButton.Size.Y.Offset)
	CustomizeButtonSeparator.LayoutOrder = NewCustomizeButton.LayoutOrder - 1
	CustomizeButtonSeparator.Parent = LayersTab

	Layers = Instance.new("Frame")
	Layers.Name = "Layers"
	Layers.BackgroundTransparency = 1
	Layers.BorderSizePixel = 0
	Layers.Position = UDim2.new(0, layersContentXStart, 0, calculatedLayersTabYPos)
	Layers.Size = UDim2.new(1, -layersContentTotalHorizontalSpaceToExclude, 1, -layersTabTotalVerticalSpaceToExclude)
	Layers.Parent = Main

	UICorner_Layers = Instance.new("UICorner") -- Renamed from UICorner6
	UICorner_Layers.CornerRadius = UDim.new(0, 2)
	UICorner_Layers.Parent = Layers

	NameTab = Instance.new("TextLabel")
	NameTab.Name = "NameTab"
	NameTab.Font = Enum.Font.GothamBold
	NameTab.Text = ""
	-- NameTab.TextColor3 will be set by theme
	NameTab.TextSize = 24
	NameTab.TextWrapped = true
	NameTab.TextXAlignment = Enum.TextXAlignment.Left
	NameTab.BackgroundTransparency = 1
	NameTab.BorderSizePixel = 0
	NameTab.Size = UDim2.new(1, 0, 0, 30)
	NameTab.Parent = Layers

	LayersReal = Instance.new("Frame")
	LayersReal.Name = "LayersReal"
	LayersReal.AnchorPoint = Vector2.new(0, 1)
	LayersReal.BackgroundTransparency = 1
	LayersReal.BorderSizePixel = 0
	LayersReal.ClipsDescendants = true
	LayersReal.Position = UDim2.new(0, 0, 1, 0)
	LayersReal.Size = UDim2.new(1, 0, 1, -33)
	LayersReal.Parent = Layers

	LayersFolder = Instance.new("Folder")
	LayersFolder.Name = "LayersFolder"
	LayersFolder.Parent = LayersReal

	LayersPageLayout = Instance.new("UIPageLayout")
	LayersPageLayout.Name = "LayersPageLayout"
	LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LayersPageLayout.TweenTime = 0.5
	LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
	LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad
	LayersPageLayout.Parent = LayersFolder

	SettingsPage_UI = Instance.new("ScrollingFrame") -- Renamed
	SettingsPage_UI.Name = "SettingsPage" -- Keep logical name for API
	SettingsPage_UI.Size = Layers.Size
	SettingsPage_UI.Position = Layers.Position
	SettingsPage_UI.BackgroundTransparency = 1
	SettingsPage_UI.BorderSizePixel = 0
	SettingsPage_UI.Visible = false
	SettingsPage_UI.ScrollBarThickness = 6
	SettingsPage_UI.ScrollingDirection = Enum.ScrollingDirection.Y
	SettingsPage_UI.CanvasSize = UDim2.new(0,0,0,0)
	SettingsPage_UI.Parent = Main

	SettingsPageLayout_UI = Instance.new("UIListLayout") -- Renamed
	SettingsPageLayout_UI.Name = "SettingsPageLayout"
	SettingsPageLayout_UI.Padding = UDim.new(0, 5)
	SettingsPageLayout_UI.SortOrder = Enum.SortOrder.LayoutOrder
	SettingsPageLayout_UI.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SettingsPageLayout_UI.Parent = SettingsPage_UI

	MoreBlur = Instance.new("Frame")
	MoreBlur.Name = "MoreBlur"
	MoreBlur.AnchorPoint = Vector2.new(1, 1)
	-- MoreBlur.BackgroundColor3 will be set by theme
	MoreBlur.BackgroundTransparency = 0.999
	MoreBlur.BorderSizePixel = 0
	MoreBlur.ClipsDescendants = true
	MoreBlur.Position = UDim2.new(0, 0, 0, 0)
	MoreBlur.Size = UDim2.new(1, 0, 1, 0)
	MoreBlur.Visible = false
	MoreBlur.Parent = UBHubGui

	local UICorner_MoreBlur = Instance.new("UICorner")
	UICorner_MoreBlur.Parent = MoreBlur

	ConnectButton_MoreBlur = Instance.new("TextButton")
	ConnectButton_MoreBlur.Name = "ConnectButton_MoreBlur"
	ConnectButton_MoreBlur.Font = Enum.Font.SourceSans
	ConnectButton_MoreBlur.Text = ""
	ConnectButton_MoreBlur.BackgroundTransparency = 1 -- Fully transparent button
	ConnectButton_MoreBlur.Size = UDim2.new(1, 0, 1, 0)
	ConnectButton_MoreBlur.Parent = MoreBlur

	DropdownSelect = Instance.new("Frame")
	DropdownSelect.Name = "DropdownSelect"
	DropdownSelect.AnchorPoint = Vector2.new(1, 0.5)
	-- DropdownSelect.BackgroundColor3 will be set by theme
	DropdownSelect.BorderSizePixel = 0
	DropdownSelect.LayoutOrder = 1
	DropdownSelect.Position = UDim2.new(1, 172, 0.5, 0)
	DropdownSelect.Size = UDim2.new(0, 160, 0, 300)
	DropdownSelect.ClipsDescendants = true
	DropdownSelect.Parent = MoreBlur

	local UICorner_DropdownSelect = Instance.new("UICorner")
	UICorner_DropdownSelect.CornerRadius = UDim.new(0, 3)
	UICorner_DropdownSelect.Parent = DropdownSelect

	local UIStroke_DropdownSelect = Instance.new("UIStroke")
	-- UIStroke_DropdownSelect.Color will be set by theme
	UIStroke_DropdownSelect.Thickness = 2.5
	UIStroke_DropdownSelect.Transparency = 0.8
	UIStroke_DropdownSelect.Parent = DropdownSelect

	local DropdownSelectReal = Instance.new("Frame")
	DropdownSelectReal.Name = "DropdownSelectReal"
	DropdownSelectReal.AnchorPoint = Vector2.new(0.5, 0.5)
	-- DropdownSelectReal.BackgroundColor3 will be set by theme
	DropdownSelectReal.BackgroundTransparency = 1
	DropdownSelectReal.BorderSizePixel = 0
	DropdownSelectReal.LayoutOrder = 1
	DropdownSelectReal.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropdownSelectReal.Size = UDim2.new(1, -10, 1, -10)
	DropdownSelectReal.Parent = DropdownSelect

	DropdownFolder = Instance.new("Folder")
	DropdownFolder.Name = "DropdownFolder"
	DropdownFolder.Parent = DropdownSelectReal

	DropPageLayout = Instance.new("UIPageLayout")
	DropPageLayout.Name = "DropPageLayout"
	DropPageLayout.EasingDirection = Enum.EasingDirection.InOut
	DropPageLayout.EasingStyle = Enum.EasingStyle.Quad
	DropPageLayout.TweenTime = 0.01 -- Adjusted for faster switch
	DropPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	DropPageLayout.Parent = DropdownFolder

	ScreenGui_Minimized = Instance.new("ScreenGui") -- Renamed
	ProtectGui(ScreenGui_Minimized)
	ScreenGui_Minimized.Name = "UBHubMinimizedScreen" -- More descriptive
	ScreenGui_Minimized.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui_Minimized.Parent = CoreGui -- Parent explicitly

	MinimizedIcon = Instance.new("ImageButton")
	MinimizedIcon.Name = "MinimizedIcon"
	MinimizedIcon.Size = UDim2.new(0, 55, 0, 50)
	MinimizedIcon.AnchorPoint = Vector2.new(0, 1)
	MinimizedIcon.Position = UDim2.new(0.02, 0, 0.98, -10)
	MinimizedIcon.BackgroundTransparency = 0
	-- MinimizedIcon.BorderColor3 will be set by theme
	MinimizedIcon.Draggable = true -- Standard property
	MinimizedIcon.Visible = false
	MinimizedIcon.Parent = ScreenGui_Minimized

	MinCorner_MinimizedIcon = Instance.new("UICorner") -- Renamed
	MinCorner_MinimizedIcon.CornerRadius = UDim.new(0, 40)
	MinCorner_MinimizedIcon.Parent = MinimizedIcon

	-- Step 3: Define All Helper and API Functions

	-- Localized Helper Functions (to avoid conflict and ensure they use MakeGui's scope)
	-- Any functions that were previously global and are now intended to be local to MakeGui
	-- should be defined here (e.g., if SaveFile, LoadFile etc. were meant to be specific to this GUI instance)

	SaveFile_Local = function(Name, Value)
		if not (writefile and GuiConfig and GuiConfig.SaveFolder) then
			return false
		end
		local valueToSave = Value
		Flags[Name] = valueToSave -- Assumes Flags is the script-level table
		local success, err = pcall(function()
			local path = GuiConfig.SaveFolder
			local encoded = HttpService:JSONEncode(Flags)
			writefile(path, encoded)
		end)
		if not success then
			warn("SaveFile_Local failed:", err)
			return false
		end
		return true
	end

	LoadFile_Local = function()
		if not (GuiConfig and GuiConfig["SaveFolder"]) then return false end
		local savePath = GuiConfig["SaveFolder"]
		if not (readfile and isfile and isfile(savePath)) then return false end
		local success, configJson = pcall(readfile, savePath)
		if not success or not configJson then
			warn("LoadFile_Local: Failed to read save file or file is empty:", savePath)
			return false
		end

		local successDecode, loadedConfig = pcall(function() return HttpService:JSONDecode(configJson) end)

		if successDecode and type(loadedConfig) == "table" then
			for key, value in pairs(loadedConfig) do
				Flags[key] = value -- Merge loaded flags into the script-level Flags table
			end
			return true
		else
			warn("LoadFile_Local: Failed to decode save file or content is not a table:", savePath, successDecode and "" or loadedConfig)
			return false
		end
	end

	-- Call LoadFile_Local once to populate Flags table at the start of MakeGui if it hasn't been populated by script-level call yet.
	-- The prompt for Step 4 says "Call LoadFile() to populate Flags." - this implies it might be called again or for the first time there.
	-- For safety, we can ensure Flags is loaded early. If called again in Step 4, it will just re-read.
	if not Flags.HasBeenLoadedByMakeGui then -- Use a flag to ensure it's only loaded once this way if needed
	    LoadFile_Local()
	    Flags.HasBeenLoadedByMakeGui = true -- Mark that MakeGui tried to load it.
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
				else
					warn("LoadUISize_Local: Failed to convert parsed width/height to numbers for flag:", saveFlag, "Value:", savedValue)
				end
			else
				warn("LoadUISize_Local: Saved UI size string format is incorrect for flag:", saveFlag, "Value:", savedValue, "(Expected 'number,number')")
			end
		elseif savedValue ~= nil then
			warn("LoadUISize_Local: Saved UI size value is not a string for flag:", saveFlag, "Type:", type(savedValue))
		end
		return nil
	end

	-- Use global LoadUIAsset, GetColor, GetThemes, SetTheme, CircleClick directly as they don't depend on MakeGui's specific instance variables in their definition.
	-- Their behavior might change based on global CurrentTheme, which is fine.
	-- MakeDraggable and MakeResizable need to be local to MakeGui as they interact with draggableElements and resizableElements.

	MakeDraggable_Local = function(topbarobject, objectToDrag)
		if topbarobject and objectToDrag then
			draggableElements[topbarobject] = {objectToDrag = objectToDrag}
		else
			warn("MakeDraggable_Local: topbarobject or objectToDrag is nil")
		end
	end

	MakeResizable_Local = function(object, saveFlag)
		local resizeHandle = Instance.new("Frame")
		resizeHandle.Name = "ResizeHandle"
		resizeHandle.AnchorPoint = Vector2.new(1, 1)
		resizeHandle.BackgroundColor3 = GetColor("Accent") -- Use global GetColor
		resizeHandle.BackgroundTransparency = 0.5
		resizeHandle.Size = UDim2.new(0, 20, 0, 20)
		resizeHandle.Position = UDim2.new(1, 0, 1, 0)
		resizeHandle.ZIndex = 10
		resizeHandle.Parent = object

		local resizeAPI = {
			CurrentSize = object.Size,
			SaveFlag = saveFlag,
			handleSizeChange = nil
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
		else
			warn("MakeResizable_Local: resizeHandle or object is nil")
		end

		function resizeAPI:SetSize(newSize)
			local validatedWidth = math.max(newSize.X.Offset, 50)
			local validatedHeight = math.max(newSize.Y.Offset, 50)
			handleSizeChangeFunc(UDim2.new(0, validatedWidth, 0, validatedHeight))
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

	updateAllColorControls_Local = function()
		if SettingsPage_UI and not SettingsPage_UI.Visible then return end
		for key, controls in pairs(activeColorSliders) do
			if Themes[CurrentTheme] and Themes[CurrentTheme][key] then
				local currentColor = Themes[CurrentTheme][key]
				if controls.rSlider:GetValue() ~= math.floor(currentColor.R * 255) then controls.rSlider:SetValue(math.floor(currentColor.R * 255)) end
				if controls.gSlider:GetValue() ~= math.floor(currentColor.G * 255) then controls.gSlider:SetValue(math.floor(currentColor.G * 255)) end
				if controls.bSlider:GetValue() ~= math.floor(currentColor.B * 255) then controls.bSlider:SetValue(math.floor(currentColor.B * 255)) end
				if controls.hexInput:GetValue() ~= Color3ToHex_Local(currentColor) then controls.hexInput:SetValue(Color3ToHex_Local(currentColor)) end
			end
		end
	end

	-- Hook into global SetTheme to update color controls
	if not _G.originalSetTheme_UBHubLib_MakeGui then _G.originalSetTheme_UBHubLib_MakeGui = SetTheme end
	local originalGlobalSetTheme = _G.originalSetTheme_UBHubLib_MakeGui

	SetTheme_Local = function(themeName) -- This is the SetTheme that MakeGui's internals should call for theming its components
		originalGlobalSetTheme(themeName) -- Call the global SetTheme to update ThemeElements etc.
		-- Now update local controls if settings view is active
		if isSettingsViewActive or (CurrentTheme == "__customApplied" and SettingsPage_UI and SettingsPage_UI.Visible) then
			if updateAllColorControls_Local then task.delay(0.05, updateAllColorControls_Local) end
		end
	end


	createColorEditor_Local = function(section, colorKeyName, initialColor3)
		local function ensureMutableThemeAndApplyChange(targetColorKeyName, newFullColorValue)
			local isOriginalDefaultTheme = false
			if Themes[CurrentTheme] then
				local originalDefaultThemeNames = GetThemes()
				isOriginalDefaultTheme = table.find(originalDefaultThemeNames, CurrentTheme) ~= nil
			end

			if isOriginalDefaultTheme then
				Themes["__customApplied"] = deepcopy(Themes[CurrentTheme])
				Themes["__customApplied"][targetColorKeyName] = newFullColorValue
				SetTheme_Local("__customApplied")
			else
				if not Themes[CurrentTheme] then
					Themes[CurrentTheme] = {}
				end
				Themes[CurrentTheme][targetColorKeyName] = newFullColorValue
				SetTheme_Local(CurrentTheme)
			end
		end

		section:AddDivider({Text = colorKeyName})
		local r, g, b = math.floor(initialColor3.R * 255), math.floor(initialColor3.G * 255), math.floor(initialColor3.B * 255)

		local hexInput = section:AddInput({
			Title = "Hex Code", Content = "e.g., #FF0000 or FF0000", Default = Color3ToHex_Local(initialColor3),
			Callback = function(hexValue)
				local newColor = HexToColor3_Local(hexValue)
				if newColor then
					ensureMutableThemeAndApplyChange(colorKeyName, newColor)
				else
					if Themes[CurrentTheme] and Themes[CurrentTheme][colorKeyName] then
						hexInput:SetValue(Color3ToHex_Local(Themes[CurrentTheme][colorKeyName]))
					else
						hexInput:SetValue("000000")
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

	InternalCreateSection_Local = function(parentScrolLayersInstance, sectionTitle, sectionLayoutOrder,
                                     guiConfigRef, flagsRef, themesRef, currentThemeNameRefFunc, -- Pass func for currentThemeName
                                     getColorFunc, setThemeFunc, loadUIAssetFunc, saveFileFunc,
                                     httpServiceRef, tweenServiceRef, mouseRef, circleClickFunc,
                                     updateParentScrollFunc, parentUIListLayoutPaddingRef)

		sectionTitle = sectionTitle or "Section"

		local SectionFrame = Instance.new("Frame")
		SectionFrame.Name = "Section"
		SectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SectionFrame.BackgroundTransparency = 1 -- Fully transparent, color from SectionReal
		SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SectionFrame.BorderSizePixel = 0
		SectionFrame.LayoutOrder = sectionLayoutOrder
		SectionFrame.ClipsDescendants = true
		SectionFrame.Size = UDim2.new(1, 0, 0, 30) -- Initial height for header
		SectionFrame.Parent = parentScrolLayersInstance

		local SectionReal = Instance.new("Frame")
		SectionReal.Name = "SectionReal"
		SectionReal.AnchorPoint = Vector2.new(0.5, 0)
		SectionReal.BackgroundColor3 = getColorFunc("Secondary", SectionReal, "BackgroundColor3") -- Themed
		SectionReal.BackgroundTransparency = 0 -- Visible
		SectionReal.BorderColor3 = Color3.fromRGB(0,0,0)
		SectionReal.BorderSizePixel = 0
		SectionReal.LayoutOrder = 1
		SectionReal.Position = UDim2.new(0.5,0,0,0)
		SectionReal.Size = UDim2.new(1,-2,0,30) -- Slightly less wide for stroke effect from parent
		SectionReal.Parent = SectionFrame
		local UICorner_SR = Instance.new("UICorner", SectionReal)
		UICorner_SR.CornerRadius = UDim.new(0,4)

		local SectionButton = Instance.new("TextButton")
		SectionButton.Name = "SectionButton"
		SectionButton.Text = ""
		SectionButton.BackgroundTransparency = 1
		SectionButton.Size = UDim2.new(1,0,1,0)
		SectionButton.Parent = SectionReal

		local FeatureFrame_Section = Instance.new("Frame", SectionReal)
		FeatureFrame_Section.Name = "FeatureFrame"
		FeatureFrame_Section.AnchorPoint = Vector2.new(1,0.5)
		FeatureFrame_Section.BackgroundTransparency = 1
		FeatureFrame_Section.Position = UDim2.new(1,-5,0.5,0)
		FeatureFrame_Section.Size = UDim2.new(0,20,0,20)

		local FeatureImg_Section = Instance.new("ImageLabel", FeatureFrame_Section)
		FeatureImg_Section.Name = "FeatureImg"
		FeatureImg_Section.Image = loadUIAssetFunc("rbxassetid://16851841101", "FeatureImg_InternalSection")
		FeatureImg_Section.ImageColor3 = getColorFunc("Text", FeatureImg_Section, "ImageColor3")
		FeatureImg_Section.AnchorPoint = Vector2.new(0.5,0.5)
		FeatureImg_Section.BackgroundTransparency = 1
		FeatureImg_Section.Position = UDim2.new(0.5,0,0.5,0)
		FeatureImg_Section.Rotation = -90
		FeatureImg_Section.Size = UDim2.new(1,6,1,6)

		local SectionTitleText = Instance.new("TextLabel", SectionReal)
		SectionTitleText.Name = "SectionTitle"
		SectionTitleText.Font = Enum.Font.GothamBold
		SectionTitleText.Text = sectionTitle
		SectionTitleText.TextColor3 = getColorFunc("Text", SectionTitleText, "TextColor3")
		SectionTitleText.TextSize = 13
		SectionTitleText.TextXAlignment = Enum.TextXAlignment.Left
		SectionTitleText.TextYAlignment = Enum.TextYAlignment.Center
		SectionTitleText.AnchorPoint = Vector2.new(0,0.5)
		SectionTitleText.BackgroundTransparency = 1
		SectionTitleText.Position = UDim2.new(0,10,0.5,0)
		SectionTitleText.Size = UDim2.new(1,-50,1,0)

		local SectionDecideFrame = Instance.new("Frame", SectionFrame)
		SectionDecideFrame.Name = "SectionDecideFrame"
		SectionDecideFrame.AnchorPoint = Vector2.new(0.5,0)
		SectionDecideFrame.BorderSizePixel = 0
		SectionDecideFrame.Position = UDim2.new(0.5,0,0,33)
		SectionDecideFrame.Size = UDim2.new(1,0,0,2)
		SectionDecideFrame.Visible = false -- Initially hidden
		Instance.new("UICorner", SectionDecideFrame)

		local UIGradient_Section = Instance.new("UIGradient", SectionDecideFrame)
		UIGradient_Section.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, themesRef[currentThemeNameRefFunc()].Primary),
			ColorSequenceKeypoint.new(0.5, guiConfigRef.Color),
			ColorSequenceKeypoint.new(1, themesRef[currentThemeNameRefFunc()].Primary)
		}

		local SectionAdd = Instance.new("Frame")
		SectionAdd.Name = "SectionAdd"
		SectionAdd.AnchorPoint = Vector2.new(0.5,0)
		SectionAdd.BackgroundTransparency = 1
		SectionAdd.BorderSizePixel = 0
		SectionAdd.ClipsDescendants = true
		SectionAdd.LayoutOrder = 1
		SectionAdd.Position = UDim2.new(0.5,0,0,38)
		SectionAdd.Size = UDim2.new(1,0,0,0) -- Content height will be dynamic
		SectionAdd.Visible = false -- Initially hidden
		SectionAdd.Parent = SectionFrame
		Instance.new("UICorner", SectionAdd).CornerRadius = UDim.new(0,2)

		local UIListLayout_SectionAdd = Instance.new("UIListLayout", SectionAdd)
		UIListLayout_SectionAdd.Padding = UDim.new(0,3)
		UIListLayout_SectionAdd.SortOrder = Enum.SortOrder.LayoutOrder

		local OpenSection = false

		local function UpdateThisInternalSectionSize()
			local totalContentHeight = 0
			if OpenSection and SectionAdd.Visible then
				totalContentHeight = UIListLayout_SectionAdd.AbsoluteContentSize.Y
				if #SectionAdd:GetChildren() > 1 then -- Has more than just the layout
					totalContentHeight = totalContentHeight + UIListLayout_SectionAdd.Padding.Offset * (#SectionAdd:GetChildren() - 2)
				end
			end

			local headerHeight = SectionReal.AbsoluteSize.Y
			local decideFrameHeight = OpenSection and #SectionAdd:GetChildren() > 1 and SectionDecideFrame.Size.Y.Offset or 0
			local sectionAddVerticalPadding = OpenSection and #SectionAdd:GetChildren() > 1 and 5 or 0 -- Small padding if content exists

			SectionFrame.Size = UDim2.new(1, 0, 0, headerHeight + decideFrameHeight + totalContentHeight + sectionAddVerticalPadding)

			if updateParentScrollFunc and parentScrolLayersInstance and parentUIListLayoutPaddingRef then
				 updateParentScrollFunc(parentScrolLayersInstance, parentUIListLayoutPaddingRef())
			end
		end

		SectionButton.Activated:Connect(function()
			circleClickFunc(SectionButton, mouseRef.X, mouseRef.Y)
			OpenSection = not OpenSection

			SectionAdd.Visible = OpenSection
			SectionDecideFrame.Visible = OpenSection and #SectionAdd:GetChildren() > 1

			if OpenSection then
				tweenServiceRef:Create(FeatureImg_Section, TweenInfo.new(0.3), {Rotation = 0}):Play()
			else
				tweenServiceRef:Create(FeatureImg_Section, TweenInfo.new(0.3), {Rotation = -90}):Play()
			end
			UpdateThisInternalSectionSize()
		end)

		SectionAdd.ChildAdded:Connect(UpdateThisInternalSectionSize)
		SectionAdd.ChildRemoved:Connect(UpdateThisInternalSectionSize)
		UpdateThisInternalSectionSize() -- Initial call

		local SectionObject = {}
		SectionObject._SectionAdd = SectionAdd
		SectionObject._UpdateSizeSection = UpdateThisInternalSectionSize
		SectionObject._UpdateSizeScroll = function()
			if updateParentScrollFunc and parentScrolLayersInstance and parentUIListLayoutPaddingRef then
				updateParentScrollFunc(parentScrolLayersInstance, parentUIListLayoutPaddingRef())
			end
		end

		local CountItem = 0
		-- AddParagraph, AddButton, AddToggle, AddSlider, AddInput, AddDivider methods would be defined here,
		-- similar to how they were before, but using the local helper functions (e.g., getColorFunc which is GetColor)
		-- For brevity in this step, their full implementation is omitted but they would call UpdateThisInternalSectionSize and _UpdateSizeScroll.
		function SectionObject:AddParagraph(ParagraphConfig)
			local ParagraphConfig = ParagraphConfig or {}
			ParagraphConfig.Title = ParagraphConfig.Title or "Title"
			ParagraphConfig.Content = ParagraphConfig.Content or "Content"
			local ParagraphFunc = {}
			local Paragraph = Instance.new("Frame")
			Paragraph.Name = "Paragraph"; Paragraph.Parent = SectionObject._SectionAdd; Paragraph.LayoutOrder = CountItem;
			Paragraph.Size = UDim2.new(1,0,0,46); Paragraph.BackgroundTransparency = 0; Paragraph.BackgroundColor3 = getColorFunc("Secondary", Paragraph, "BackgroundColor3")
			Instance.new("UICorner", Paragraph).CornerRadius = UDim.new(0,4)
			local ParagraphTitle = Instance.new("TextLabel", Paragraph)
			ParagraphTitle.Name = "ParagraphTitle"; ParagraphTitle.Font = Enum.Font.GothamBold; ParagraphTitle.Text = ParagraphConfig.Title .. " | " .. ParagraphConfig.Content;
			ParagraphTitle.TextColor3 = getColorFunc("Text", ParagraphTitle, "TextColor3"); ParagraphTitle.TextSize = 13; ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left; ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top;
			ParagraphTitle.BackgroundTransparency = 1; ParagraphTitle.Position = UDim2.new(0,10,0,10); ParagraphTitle.Size = UDim2.new(1,-16,0,13); ParagraphTitle.TextWrapped = true
			task.defer(function()
				if ParagraphTitle and ParagraphTitle.Parent then
					ParagraphTitle.Size = UDim2.new(1, -16, 0, ParagraphTitle.TextBounds.Y); Paragraph.Size = UDim2.new(1,0,0, ParagraphTitle.TextBounds.Y + 20);
					SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll()
				end
			end)
			function ParagraphFunc:Set(pConfig)
				ParagraphTitle.Text = (pConfig.Title or "T") .. " | " .. (pConfig.Content or "C");
				task.defer(function()
					if ParagraphTitle and ParagraphTitle.Parent then
						ParagraphTitle.Size = UDim2.new(1,-16,0,ParagraphTitle.TextBounds.Y); Paragraph.Size = UDim2.new(1,0,0,ParagraphTitle.TextBounds.Y + 20);
						SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll()
					end
				end)
			end
			CountItem = CountItem + 1; SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll(); return ParagraphFunc
		end

		function SectionObject:AddButton(ButtonConfig)
			local ButtonConfig = ButtonConfig or {}; ButtonConfig.Title = ButtonConfig.Title or "Button"; ButtonConfig.Content = ButtonConfig.Content or ""; ButtonConfig.Icon = ButtonConfig.Icon or loadUIAssetFunc("rbxassetid://16932740082", "ButtonConfig_Internal.png"); ButtonConfig.Callback = ButtonConfig.Callback or function() end
			local ButtonFrame = Instance.new("Frame"); ButtonFrame.Name = "Button"; ButtonFrame.Parent = SectionObject._SectionAdd; ButtonFrame.LayoutOrder = CountItem;
			ButtonFrame.Size = UDim2.new(1,0,0,46); ButtonFrame.BackgroundTransparency = 0; ButtonFrame.BackgroundColor3 = getColorFunc("Secondary", ButtonFrame, "BackgroundColor3")
			Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0,4)
			local ButtonTitle = Instance.new("TextLabel", ButtonFrame); ButtonTitle.Name = "ButtonTitle"; ButtonTitle.Font = Enum.Font.GothamBold; ButtonTitle.Text = ButtonConfig.Title; ButtonTitle.TextColor3 = getColorFunc("Text", ButtonTitle, "TextColor3"); ButtonTitle.TextSize = 13; ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left; ButtonTitle.TextYAlignment = Enum.TextYAlignment.Top; ButtonTitle.BackgroundTransparency=1; ButtonTitle.Position = UDim2.new(0,10,0,10); ButtonTitle.Size = UDim2.new(1,-100,0,13)
			local ButtonContent = Instance.new("TextLabel", ButtonFrame); ButtonContent.Name = "ButtonContent"; ButtonContent.Font = Enum.Font.Gotham; ButtonContent.Text = ButtonConfig.Content; ButtonContent.TextColor3 = getColorFunc("Text", ButtonContent, "TextColor3"); ButtonContent.TextSize = 12; ButtonContent.TextTransparency = 0.4; ButtonContent.TextXAlignment = Enum.TextXAlignment.Left; ButtonContent.TextYAlignment = Enum.TextYAlignment.Bottom; ButtonContent.BackgroundTransparency=1; ButtonContent.Position = UDim2.new(0,10,0,0); ButtonContent.Size = UDim2.new(1,-100,1,-10); ButtonContent.TextWrapped = true
			local ActualButton = Instance.new("TextButton", ButtonFrame); ActualButton.Name = "ActualButton"; ActualButton.Text = ""; ActualButton.Size = UDim2.new(1,0,1,0); ActualButton.BackgroundTransparency = 1; ActualButton.Activated:Connect(function() circleClickFunc(ActualButton, mouseRef.X, mouseRef.Y); ButtonConfig.Callback() end)
			if ButtonConfig.Icon then
				local FeatureFrame1_Button = Instance.new("Frame", ButtonFrame); FeatureFrame1_Button.Name = "FeatureFrame"; FeatureFrame1_Button.AnchorPoint = Vector2.new(1,0.5); FeatureFrame1_Button.BackgroundTransparency = 1; FeatureFrame1_Button.Position = UDim2.new(1,-15,0.5,0); FeatureFrame1_Button.Size = UDim2.new(0,25,0,25)
				local FeatureImg3_Button = Instance.new("ImageLabel", FeatureFrame1_Button); FeatureImg3_Button.Name = "FeatureImg"; FeatureImg3_Button.Image = ButtonConfig.Icon; FeatureImg3_Button.AnchorPoint = Vector2.new(0.5,0.5); FeatureImg3_Button.BackgroundTransparency = 1; FeatureImg3_Button.Position = UDim2.new(0.5,0,0.5,0); FeatureImg3_Button.Size = UDim2.new(1,0,1,0)
			end
			task.delay(0, function()
				if ButtonContent and ButtonContent.Parent and ButtonTitle and ButtonTitle.Parent then
					local contentHeight = ButtonContent.TextBounds.Y; local titleHeight = ButtonTitle.TextBounds.Y; ButtonFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15));
					SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll()
				end
			end)
			CountItem = CountItem + 1; SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll(); return {}
		end

		function SectionObject:AddToggle(ToggleConfig)
			local ToggleConfig = ToggleConfig or {}; ToggleConfig.Title = ToggleConfig.Title or "Toggle"; ToggleConfig.Content = ToggleConfig.Content or ""; ToggleConfig.Default = (ToggleConfig.Flag and flagsRef[ToggleConfig.Flag] ~= nil) and flagsRef[ToggleConfig.Flag] or ToggleConfig.Default or false; ToggleConfig.Callback = ToggleConfig.Callback or function() end
			local ToggleFrame = Instance.new("Frame"); ToggleFrame.Name = "Toggle"; ToggleFrame.Parent = SectionObject._SectionAdd; ToggleFrame.LayoutOrder = CountItem;
			ToggleFrame.Size = UDim2.new(1,0,0,46); ToggleFrame.BackgroundTransparency = 0; ToggleFrame.BackgroundColor3 = getColorFunc("Secondary", ToggleFrame, "BackgroundColor3")
			Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0,4)
			local ToggleTitle = Instance.new("TextLabel", ToggleFrame); ToggleTitle.Name = "ToggleTitle"; ToggleTitle.Font = Enum.Font.GothamBold; ToggleTitle.Text = ToggleConfig.Title; ToggleTitle.TextColor3 = getColorFunc("Text", ToggleTitle, "TextColor3"); ToggleTitle.TextSize = 13; ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left; ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top; ToggleTitle.BackgroundTransparency=1; ToggleTitle.Position = UDim2.new(0,10,0,10); ToggleTitle.Size = UDim2.new(1,-100,0,13)
			local ToggleContent = Instance.new("TextLabel", ToggleFrame); ToggleContent.Name = "ToggleContent"; ToggleContent.Font = Enum.Font.Gotham; ToggleContent.Text = ToggleConfig.Content; ToggleContent.TextColor3 = getColorFunc("Text", ToggleContent, "TextColor3"); ToggleContent.TextSize = 12; ToggleContent.TextTransparency = 0.4; ToggleContent.TextXAlignment = Enum.TextXAlignment.Left; ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom; ToggleContent.BackgroundTransparency=1; ToggleContent.Position = UDim2.new(0,10,0,0); ToggleContent.Size = UDim2.new(1,-100,1,-10); ToggleContent.TextWrapped = true
			local SwitchFrame = Instance.new("Frame", ToggleFrame); SwitchFrame.Name = "SwitchFrame"; SwitchFrame.AnchorPoint = Vector2.new(1,0.5); SwitchFrame.BackgroundColor3 = getColorFunc("Accent", SwitchFrame, "BackgroundColor3"); SwitchFrame.BackgroundTransparency = 0.5; SwitchFrame.BorderSizePixel = 0; SwitchFrame.Position = UDim2.new(1,-15,0.5,0); SwitchFrame.Size = UDim2.new(0,30,0,15); Instance.new("UICorner", SwitchFrame).CornerRadius = UDim.new(0,100)
			local SwitchCircle = Instance.new("Frame", SwitchFrame); SwitchCircle.Name = "SwitchCircle"; SwitchCircle.BackgroundColor3 = getColorFunc("ThemeHighlight", SwitchCircle, "BackgroundColor3"); SwitchCircle.BorderSizePixel = 0; SwitchCircle.Position = UDim2.new(ToggleConfig.Default and 0.5 or 0, ToggleConfig.Default and -1 or 1, 0.5, -6); SwitchCircle.Size = UDim2.new(0,12,0,12); Instance.new("UICorner", SwitchCircle).CornerRadius = UDim.new(0,100)
			local ActualButton = Instance.new("TextButton", ToggleFrame); ActualButton.Name = "ActualButton"; ActualButton.Text = ""; ActualButton.Size = UDim2.new(1,0,1,0); ActualButton.BackgroundTransparency = 1
			local currentValue = ToggleConfig.Default
			local function setToggleVisual(value) SwitchCircle:TweenPosition(UDim2.new(value and 0.5 or 0, value and -1 or 1, 0.5, -6), "Out", "Quad", 0.15, true) end; setToggleVisual(currentValue)
			ActualButton.Activated:Connect(function() circleClickFunc(ActualButton, mouseRef.X, mouseRef.Y); currentValue = not currentValue; if ToggleConfig.Flag then saveFileFunc(ToggleConfig.Flag, currentValue) end; ToggleConfig.Callback(currentValue); setToggleVisual(currentValue) end)
			task.delay(0, function()
				if ToggleContent and ToggleContent.Parent and ToggleTitle and ToggleTitle.Parent then
					local contentHeight = ToggleContent.TextBounds.Y; local titleHeight = ToggleTitle.TextBounds.Y; ToggleFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15));
					SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll()
				end
			end)
			CountItem = CountItem + 1; SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll(); return { GetValue = function() return currentValue end, SetValue = function(val) currentValue = val; if ToggleConfig.Flag then saveFileFunc(ToggleConfig.Flag, currentValue) end; ToggleConfig.Callback(currentValue); setToggleVisual(currentValue); end }
		end

		function SectionObject:AddSlider(SliderConfig)
			local SliderConfig = SliderConfig or {}; SliderConfig.Title = SliderConfig.Title or "Slider"; SliderConfig.Content = SliderConfig.Content or ""; SliderConfig.Min = SliderConfig.Min or 0; SliderConfig.Max = SliderConfig.Max or 100; SliderConfig.Increment = SliderConfig.Increment or 1; local savedVal = SliderConfig.Flag and flagsRef[SliderConfig.Flag]; SliderConfig.Default = tonumber(savedVal or SliderConfig.Default or SliderConfig.Min); SliderConfig.Callback = SliderConfig.Callback or function() end
			local SliderFrame = Instance.new("Frame"); SliderFrame.Name = "Slider"; SliderFrame.Parent = SectionObject._SectionAdd; SliderFrame.LayoutOrder = CountItem;
			SliderFrame.Size = UDim2.new(1,0,0,55); SliderFrame.BackgroundTransparency = 0; SliderFrame.BackgroundColor3 = getColorFunc("Secondary", SliderFrame, "BackgroundColor3")
			Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0,4)
			local SliderTitle = Instance.new("TextLabel", SliderFrame); SliderTitle.Name = "SliderTitle"; SliderTitle.Font = Enum.Font.GothamBold; SliderTitle.Text = SliderConfig.Title; SliderTitle.TextColor3 = getColorFunc("Text", SliderTitle, "TextColor3"); SliderTitle.TextSize = 13; SliderTitle.TextXAlignment = Enum.TextXAlignment.Left; SliderTitle.TextYAlignment = Enum.TextYAlignment.Top; SliderTitle.BackgroundTransparency=1; SliderTitle.Position = UDim2.new(0,10,0,10); SliderTitle.Size = UDim2.new(1,-60,0,13)
			local valueToParse = SliderConfig.Min
			if savedVal ~= nil then valueToParse = savedVal elseif SliderConfig.Default ~= nil then valueToParse = SliderConfig.Default end
			local currentValue = tonumber(valueToParse)
			if type(currentValue) ~= "number" then warn("AddSlider: Initial value for slider '" .. SliderConfig.Title .. "' was not a valid number. Got: " .. tostring(valueToParse) .. ". Defaulting to Min value: " .. SliderConfig.Min); currentValue = SliderConfig.Min end
			local SliderValueText = Instance.new("TextBox", SliderFrame); SliderValueText.Name = "SliderValueText"; SliderValueText.Font = Enum.Font.GothamBold; SliderValueText.Text = ""; SliderValueText.TextColor3 = getColorFunc("Text", SliderValueText, "TextColor3"); SliderValueText.TextSize = 12; SliderValueText.BackgroundTransparency = 0; SliderValueText.BackgroundColor3 = getColorFunc("Accent", SliderValueText, "BackgroundColor3"); SliderValueText.Position = UDim2.new(1,-45,0,5); SliderValueText.Size = UDim2.new(0,40,0,20); Instance.new("UICorner", SliderValueText).CornerRadius = UDim.new(0,3)
			local Bar = Instance.new("Frame", SliderFrame); Bar.Name = "Bar"; Bar.BackgroundColor3 = getColorFunc("Accent", Bar, "BackgroundColor3"); Bar.BorderSizePixel = 0; Bar.Position = UDim2.new(0,10,1,-20); Bar.Size = UDim2.new(1,-20,0,5); Instance.new("UICorner", Bar).CornerRadius = UDim.new(0,100)
			local Progress = Instance.new("Frame", Bar); Progress.Name = "Progress"; Progress.BackgroundColor3 = getColorFunc("ThemeHighlight", Progress, "BackgroundColor3"); Progress.BorderSizePixel = 0; Instance.new("UICorner", Progress).CornerRadius = UDim.new(0,100)
			local Dragger = Instance.new("TextButton", Bar); Dragger.Name = "Dragger"; Dragger.Text = ""; Dragger.Size = UDim2.new(0,10,0,10); Dragger.AnchorPoint = Vector2.new(0.5,0.5); Dragger.BackgroundColor3 = getColorFunc("ThemeHighlight", Dragger, "BackgroundColor3"); Dragger.BorderSizePixel = 0; Instance.new("UICorner", Dragger).CornerRadius = UDim.new(0,100); Dragger.ZIndex = 2
			local DraggerHitbox = Instance.new("TextButton", Bar); DraggerHitbox.Name = "DraggerHitbox"; DraggerHitbox.Text = ""; DraggerHitbox.Size = UDim2.new(0, 24, 0, 24); DraggerHitbox.AnchorPoint = Vector2.new(0.5, 0.5); DraggerHitbox.BackgroundTransparency = 1; DraggerHitbox.ZIndex = Dragger.ZIndex + 1; DraggerHitbox.BorderSizePixel = 0
			local function UpdateSlider(value) value = tonumber(value); if type(value) ~= "number" then value = SliderConfig.Min end; value = math.clamp(math.floor(value/SliderConfig.Increment + 0.5) * SliderConfig.Increment, SliderConfig.Min, SliderConfig.Max); currentValue = value; SliderValueText.Text = tostring(value); local percent = (SliderConfig.Max - SliderConfig.Min == 0) and 0 or (value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min); Progress.Size = UDim2.new(percent,0,1,0); Dragger.Position = UDim2.new(percent,0,0.5,0); DraggerHitbox.Position = Dragger.Position; if SliderConfig.Flag then saveFileFunc(SliderConfig.Flag, currentValue) end; SliderConfig.Callback(currentValue) end
			UpdateSlider(currentValue)
			local dragConnection = nil; local inputEndedConnection = nil
			DraggerHitbox.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then local dragging = true; if dragConnection then dragConnection:Disconnect(); local idx = table.find(connections, dragConnection); if idx then table.remove(connections, idx); end; dragConnection = nil; end; if inputEndedConnection then inputEndedConnection:Disconnect(); local idx = table.find(connections, inputEndedConnection); if idx then table.remove(connections, idx); end; inputEndedConnection = nil; end; dragConnection = UserInputService.InputChanged:Connect(function(subInput) if not dragging then if dragConnection then dragConnection:Disconnect(); local idx = table.find(connections, dragConnection); if idx then table.remove(connections, idx); end; dragConnection = nil; end return end; if subInput.UserInputType == Enum.UserInputType.MouseMovement or subInput.UserInputType == Enum.UserInputType.Touch then local localPos = Bar.AbsolutePosition.X; local mousePos = subInput.Position.X; local percent = math.clamp((mousePos - localPos) / Bar.AbsoluteSize.X, 0, 1); UpdateSlider(SliderConfig.Min + percent * (SliderConfig.Max - SliderConfig.Min)) end end); table.insert(connections, dragConnection); inputEndedConnection = UserInputService.InputEnded:Connect(function(endInput) if endInput.UserInputType == input.UserInputType then dragging = false; if dragConnection then dragConnection:Disconnect(); local idx = table.find(connections, dragConnection); if idx then table.remove(connections, idx); end; dragConnection = nil; end; if inputEndedConnection then inputEndedConnection:Disconnect(); local idx = table.find(connections, inputEndedConnection); if idx then table.remove(connections, idx); end; inputEndedConnection = nil; end end end); table.insert(connections, inputEndedConnection) end end)
			SliderValueText.FocusLost:Connect(function(enterPressed) local num = tonumber(SliderValueText.Text); if num then UpdateSlider(num) else UpdateSlider(currentValue) end end)
			CountItem = CountItem + 1; SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll(); return { GetValue = function() return currentValue end, SetValue = UpdateSlider }
		end

		function SectionObject:AddInput(InputConfig)
			local InputConfig = InputConfig or {}; InputConfig.Title = InputConfig.Title or "Input"; InputConfig.Content = InputConfig.Content or ""; local savedVal = InputConfig.Flag and flagsRef[InputConfig.Flag]; InputConfig.Default = savedVal or InputConfig.Default or ""; InputConfig.Callback = InputConfig.Callback or function() end
			local InputFrame = Instance.new("Frame"); InputFrame.Name = "Input"; InputFrame.Parent = SectionObject._SectionAdd; InputFrame.LayoutOrder = CountItem;
			InputFrame.Size = UDim2.new(1,0,0,46); InputFrame.BackgroundTransparency = 0; InputFrame.BackgroundColor3 = getColorFunc("Secondary", InputFrame, "BackgroundColor3")
			Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0,4)
			local InputTitle = Instance.new("TextLabel", InputFrame); InputTitle.Name = "InputTitle"; InputTitle.Font = Enum.Font.GothamBold; InputTitle.Text = InputConfig.Title; InputTitle.TextColor3 = getColorFunc("Text", InputTitle, "TextColor3"); InputTitle.TextSize = 13; InputTitle.TextXAlignment = Enum.TextXAlignment.Left; InputTitle.TextYAlignment = Enum.TextYAlignment.Top; InputTitle.BackgroundTransparency=1; InputTitle.Position = UDim2.new(0,10,0,10); InputTitle.Size = UDim2.new(1,-100,0,13)
			local InputContent = Instance.new("TextLabel", InputFrame); InputContent.Name = "InputContent"; InputContent.Font = Enum.Font.Gotham; InputContent.Text = InputConfig.Content; InputContent.TextColor3 = getColorFunc("Text", InputContent, "TextColor3"); InputContent.TextSize = 12; InputContent.TextTransparency = 0.4; InputContent.TextXAlignment = Enum.TextXAlignment.Left; InputContent.TextYAlignment = Enum.TextYAlignment.Bottom; InputContent.BackgroundTransparency=1; InputContent.Position = UDim2.new(0,10,0,0); InputContent.Size = UDim2.new(1,-100,1,-10); InputContent.TextWrapped = true
			local TextBox = Instance.new("TextBox", InputFrame); TextBox.Name = "TextBox"; TextBox.Font = Enum.Font.Gotham; TextBox.Text = InputConfig.Default; TextBox.TextColor3 = getColorFunc("Text", TextBox, "TextColor3"); TextBox.TextSize = 12; TextBox.BackgroundColor3 = getColorFunc("Accent", TextBox, "BackgroundColor3"); TextBox.Position = UDim2.new(1,-155,0.5,-12); TextBox.Size = UDim2.new(0,150,0,24); Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0,3); TextBox.ClearTextOnFocus = false
			local currentValue = InputConfig.Default
			TextBox.FocusLost:Connect(function() currentValue = TextBox.Text; if InputConfig.Flag then saveFileFunc(InputConfig.Flag, currentValue) end; InputConfig.Callback(currentValue) end)
			task.delay(0, function() if InputContent and InputContent.Parent and InputTitle and InputTitle.Parent then local contentHeight = InputContent.TextBounds.Y; local titleHeight = InputTitle.TextBounds.Y; InputFrame.Size = UDim2.new(1,0,0,math.max(46, titleHeight + contentHeight + 15)); SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll() end end)
			CountItem = CountItem + 1; SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll(); return { GetValue = function() return currentValue end, SetValue = function(val) currentValue = val; TextBox.Text = val; if InputConfig.Flag then saveFileFunc(InputConfig.Flag, currentValue) end; InputConfig.Callback(currentValue) end }
		end

		function SectionObject:AddDropdown(DropdownConfig)
			local DropdownConfig = DropdownConfig or {}; DropdownConfig.Title = DropdownConfig.Title or "No Title"; DropdownConfig.Content = DropdownConfig.Content or ""; DropdownConfig.Multi = DropdownConfig.Multi or false; DropdownConfig.Options = DropdownConfig.Options or {}; local savedValue = DropdownConfig.Flag and flagsRef[DropdownConfig.Flag]; if savedValue ~= nil and type(savedValue) == "table" then DropdownConfig.Default = savedValue elseif type(DropdownConfig.Default) == "table" then DropdownConfig.Default = DropdownConfig.Default else if DropdownConfig.Multi then DropdownConfig.Default = {} else DropdownConfig.Default = (type(DropdownConfig.Default) == "string" and {DropdownConfig.Default}) or {} end end; DropdownConfig.Callback = DropdownConfig.Callback or function() end
			local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options}; local DropdownFrame = Instance.new("Frame"); DropdownFrame.Name = "Dropdown"; DropdownFrame.Parent = SectionObject._SectionAdd; DropdownFrame.LayoutOrder = CountItem; DropdownFrame.Size = UDim2.new(1,0,0,46); DropdownFrame.BackgroundTransparency = 0; DropdownFrame.BackgroundColor3 = getColorFunc("Secondary", DropdownFrame, "BackgroundColor3"); Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0,4)
			local DropdownTitle = Instance.new("TextLabel", DropdownFrame); DropdownTitle.Name = "DropdownTitle"; DropdownTitle.Font = Enum.Font.GothamBold; DropdownTitle.Text = DropdownConfig.Title; DropdownTitle.TextColor3 = getColorFunc("Text", DropdownTitle, "TextColor3"); DropdownTitle.TextSize = 13; DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left; DropdownTitle.TextYAlignment = Enum.TextYAlignment.Top; DropdownTitle.BackgroundTransparency=1; DropdownTitle.Position = UDim2.new(0,10,0,10); DropdownTitle.TextWrapped = true; DropdownTitle.Size = UDim2.new(1,-180,0,0); DropdownTitle.AutomaticSize = Enum.AutomaticSize.Y;
			local DropdownContent = Instance.new("TextLabel", DropdownFrame); DropdownContent.Name = "DropdownContent"; DropdownContent.Font = Enum.Font.Gotham; DropdownContent.Text = DropdownConfig.Content; DropdownContent.TextColor3 = getColorFunc("Text", DropdownContent, "TextColor3"); DropdownContent.TextSize = 12; DropdownContent.TextTransparency = 0.4; DropdownContent.TextWrapped = true; DropdownContent.TextXAlignment = Enum.TextXAlignment.Left; DropdownContent.TextYAlignment = Enum.TextYAlignment.Top; DropdownContent.BackgroundTransparency=1; DropdownContent.Size = UDim2.new(1,-180,0,0); DropdownContent.AutomaticSize = Enum.AutomaticSize.Y;
			local SelectOptionsFrame = Instance.new("Frame", DropdownFrame); SelectOptionsFrame.Name = "SelectOptionsFrame"; SelectOptionsFrame.AnchorPoint = Vector2.new(1,0.5); SelectOptionsFrame.BackgroundColor3 = getColorFunc("Primary", SelectOptionsFrame, "BackgroundColor3"); SelectOptionsFrame.BackgroundTransparency = 0; SelectOptionsFrame.BorderSizePixel = 0; SelectOptionsFrame.Position = UDim2.new(1,-7,0.5,0); SelectOptionsFrame.Size = UDim2.new(0,148,0,30); Instance.new("UICorner",SelectOptionsFrame).CornerRadius = UDim.new(0,4)
			local OptionSelecting = Instance.new("TextLabel",SelectOptionsFrame); OptionSelecting.Name = "OptionSelecting"; OptionSelecting.Font = Enum.Font.Gotham; OptionSelecting.TextColor3 = getColorFunc("Text", OptionSelecting, "TextColor3"); OptionSelecting.TextSize = 12; OptionSelecting.TextTransparency = 0.4; OptionSelecting.TextWrapped = true; OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left; OptionSelecting.AnchorPoint = Vector2.new(0,0.5); OptionSelecting.BackgroundTransparency = 1; OptionSelecting.Position = UDim2.new(0,5,0.5,0); OptionSelecting.Size = UDim2.new(1,-30,1,-8)
			local OptionImg = Instance.new("ImageLabel",SelectOptionsFrame); OptionImg.Name = "OptionImg"; OptionImg.Image = loadUIAssetFunc("rbxassetid://16851841101", "DropdownArrow_Internal"); OptionImg.ImageColor3 = getColorFunc("Text", OptionImg, "ImageColor3"); OptionImg.AnchorPoint = Vector2.new(1,0.5); OptionImg.BackgroundTransparency=1; OptionImg.Position = UDim2.new(1,0,0.5,0); OptionImg.Size = UDim2.new(0,25,0,25)
			local DropdownButton = Instance.new("TextButton", DropdownFrame); DropdownButton.Name = "DropdownButton"; DropdownButton.Text = ""; DropdownButton.Size = UDim2.new(1,0,1,0); DropdownButton.BackgroundTransparency = 1
			local currentDropdownID = CountDropdown; CountDropdown = CountDropdown + 1;
			local DropdownContainer = DropdownFolder:FindFirstChild("DropdownContainer_"..tostring(currentDropdownID)); if not DropdownContainer then DropdownContainer = Instance.new("Frame", DropdownFolder); DropdownContainer.Name = "DropdownContainer_"..tostring(currentDropdownID); DropdownContainer.BackgroundTransparency = 1; DropdownContainer.Size = UDim2.new(1,0,1,0); local SearchBar_Dropdown = Instance.new("TextBox", DropdownContainer); SearchBar_Dropdown.Name = "SearchBar_Dropdown"; SearchBar_Dropdown.Font = Enum.Font.GothamBold; SearchBar_Dropdown.PlaceholderText = "🔎 Search"; SearchBar_Dropdown.PlaceholderColor3 = getColorFunc("Text", SearchBar_Dropdown, "PlaceholderColor3"); SearchBar_Dropdown.Text = ""; SearchBar_Dropdown.TextColor3 = getColorFunc("Text", SearchBar_Dropdown, "TextColor3"); SearchBar_Dropdown.TextSize = 12; SearchBar_Dropdown.BackgroundColor3 = getColorFunc("Secondary", SearchBar_Dropdown, "BackgroundColor3"); SearchBar_Dropdown.BackgroundTransparency = 0; SearchBar_Dropdown.BorderColor3 = getColorFunc("Stroke", SearchBar_Dropdown, "BorderColor3"); SearchBar_Dropdown.BorderSizePixel = 1; SearchBar_Dropdown.Size = UDim2.new(1,-10,0,25); SearchBar_Dropdown.Position = UDim2.new(0,5,0,5); local ScrollSelect = Instance.new("ScrollingFrame", DropdownContainer); ScrollSelect.Name = "ScrollSelect"; ScrollSelect.CanvasSize = UDim2.new(0,0,0,0); ScrollSelect.ScrollBarThickness = 0; ScrollSelect.Active = true; ScrollSelect.Position = UDim2.new(0,0,0,35); ScrollSelect.BackgroundTransparency=1; ScrollSelect.Size = UDim2.new(1,0,1,-35); local UIListLayout_Scroll = Instance.new("UIListLayout", ScrollSelect); UIListLayout_Scroll.Padding = UDim.new(0,3); UIListLayout_Scroll.SortOrder = Enum.SortOrder.LayoutOrder; SearchBar_Dropdown:GetPropertyChangedSignal("Text"):Connect(function() local s = SearchBar_Dropdown.Text:lower(); for _,oF in ipairs(ScrollSelect:GetChildren()) do if oF:IsA("Frame") and oF.Name == "Option" then local oT = oF:FindFirstChild("OptionText"); if oT then oF.Visible = (s == "" or oT.Text:lower():find(s,1,true)) end end end end) end
			local ScrollSelect = DropdownContainer.ScrollSelect; local UIListLayout_Scroll = ScrollSelect:FindFirstChildOfClass("UIListLayout")
			DropdownButton.Activated:Connect(function() circleClickFunc(DropdownButton, mouseRef.X, mouseRef.Y); if not MoreBlur.Visible then MoreBlur.Visible = true; DropPageLayout:JumpTo(DropdownContainer); tweenServiceRef:Create(MoreBlur, TweenInfo.new(0.2),{BackgroundTransparency = 0.7}):Play(); tweenServiceRef:Create(DropdownSelect, TweenInfo.new(0.2),{Position = UDim2.new(1,-11,0.5,0)}):Play() end end)
			local dropCountLocal = 0; function DropdownFunc:Clear() for i=#ScrollSelect:GetChildren(),1,-1 do local c = ScrollSelect:GetChildren()[i]; if c.Name == "Option" then c:Destroy() end end; DropdownFunc.Value={}; DropdownFunc.Options={}; OptionSelecting.Text = "Select Options"; dropCountLocal = 0; ScrollSelect.CanvasSize = UDim2.new(0,0,0,0); end
			function DropdownFunc:AddOption(oN) oN = oN or "Option"; local oF = Instance.new("Frame",ScrollSelect); oF.Name="Option"; oF.Size=UDim2.new(1,0,0,30); oF.BackgroundTransparency=0; oF.BackgroundColor3=getColorFunc("Secondary",oF,"BackgroundColor3"); Instance.new("UICorner",oF).CornerRadius=UDim.new(0,3); local oB=Instance.new("TextButton",oF); oB.Name="OptionButton"; oB.Text=""; oB.Size=UDim2.new(1,0,1,0); oB.BackgroundTransparency=1; local oT=Instance.new("TextLabel",oF); oT.Name="OptionText"; oT.Font=Enum.Font.Gotham; oT.Text=oN; oT.TextColor3=getColorFunc("Text",oT,"TextColor3"); oT.TextSize=13; oT.TextXAlignment=Enum.TextXAlignment.Left; oT.BackgroundTransparency=1; oT.Position=UDim2.new(0,8,0,0); oT.Size=UDim2.new(1,-16,1,0); local cF=Instance.new("Frame",oF); cF.Name="ChooseFrame"; cF.AnchorPoint=Vector2.new(0,0.5); cF.BackgroundColor3=getColorFunc("ThemeHighlight",cF,"BackgroundColor3"); cF.BorderSizePixel=0; cF.Position=UDim2.new(0,2,0.5,0); cF.Size=UDim2.new(0,0,0,0); Instance.new("UICorner",cF).CornerRadius=UDim.new(0,3); local cS=Instance.new("UIStroke",cF); cS.Color=getColorFunc("Secondary",cS,"Color"); cS.Thickness=1.6; cS.Transparency=1; dropCountLocal=dropCountLocal+1; oF.LayoutOrder=dropCountLocal; oB.Activated:Connect(function() circleClickFunc(oB, mouseRef.X, mouseRef.Y); if DropdownConfig.Multi then local fI=table.find(DropdownFunc.Value,oN); if fI then table.remove(DropdownFunc.Value,fI) else table.insert(DropdownFunc.Value,oN) end else DropdownFunc.Value={oN} end; DropdownFunc:Set(DropdownFunc.Value); if DropdownConfig.Flag then saveFileFunc(DropdownConfig.Flag, DropdownFunc.Value) end end); task.defer(function() if UIListLayout_Scroll and UIListLayout_Scroll.Parent then ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_Scroll.AbsoluteContentSize.Y) end end) end;
			function DropdownFunc:Set(val) local pVT; if val then local nV=type(val)=="table" and val or {val}; pVT={}; for _,v_u in ipairs(nV) do if not table.find(pVT,v_u) then table.insert(pVT,v_u) end end else pVT={} end; DropdownFunc.Value=pVT; for _,d_S in ipairs(ScrollSelect:GetChildren()) do if d_S:IsA("Frame") and d_S.Name=="Option" then local iTF=DropdownFunc.Value and table.find(DropdownFunc.Value,d_S.OptionText.Text); local tII=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut); local s_S=iTF and UDim2.new(0,1,0,12) or UDim2.new(0,0,0,0); local bT_S=iTF and 0 or 0.97; local tr_S=iTF and 0 or 1; tweenServiceRef:Create(d_S.ChooseFrame,tII,{Size=s_S}):Play(); tweenServiceRef:Create(d_S.ChooseFrame.UIStroke,tII,{Transparency=tr_S}):Play(); tweenServiceRef:Create(d_S,tII,{BackgroundTransparency=bT_S}):Play() end end; local dT=(DropdownFunc.Value and #DropdownFunc.Value>0) and table.concat(DropdownFunc.Value,", ") or "Select Options"; OptionSelecting.Text=dT; if DropdownConfig.Callback then DropdownConfig.Callback(DropdownFunc.Value or {}) end; end;
			function DropdownFunc:Refresh(newOptionsList, valueToTryToSelect) DropdownFunc:Clear(); DropdownFunc.Options = newOptionsList or {}; for _, optName in ipairs(DropdownFunc.Options) do DropdownFunc:AddOption(optName) end; local validatedSelection = {}; if valueToTryToSelect and type(valueToTryToSelect) == "table" and #valueToTryToSelect > 0 then if DropdownConfig.Multi then for _, selOpt in ipairs(valueToTryToSelect) do if table.find(DropdownFunc.Options, selOpt) then table.insert(validatedSelection, selOpt) end end else if #valueToTryToSelect > 0 and table.find(DropdownFunc.Options, valueToTryToSelect[1]) then validatedSelection = {valueToTryToSelect[1]} end end end; DropdownFunc:Set(validatedSelection); end;
			DropdownFunc:Refresh(DropdownConfig.Options, DropdownConfig.Default)
			task.defer(function() if DropdownTitle and DropdownTitle.Parent and DropdownContent and DropdownContent.Parent and SelectOptionsFrame and SelectOptionsFrame.Parent then local titleHeight=DropdownTitle.AbsoluteSize.Y; DropdownContent.Position=UDim2.new(0,10,0,DropdownTitle.Position.Y.Offset+titleHeight+5); local contentHeight=DropdownContent.AbsoluteSize.Y; local totalTextHeight=DropdownTitle.Position.Y.Offset+titleHeight+5+contentHeight+10; local optionsFrameHeight=SelectOptionsFrame.AbsoluteSize.Y+16; DropdownFrame.Size=UDim2.new(1,0,0,math.max(46,totalTextHeight,optionsFrameHeight)); SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll() end end)
			CountItem = CountItem + 1; SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll(); return DropdownFunc;
		end

		function SectionObject:AddDivider(DividerConfig)
			local DividerConfig = DividerConfig or {}; DividerConfig.Text = DividerConfig.Text or nil; local DividerContainer = Instance.new("Frame"); DividerContainer.Name = "Divider"; DividerContainer.Size = UDim2.new(1,0,0,20); DividerContainer.BackgroundTransparency=1; DividerContainer.LayoutOrder=CountItem; DividerContainer.Parent = SectionObject._SectionAdd
			if not DividerConfig.Text or DividerConfig.Text == "" then local Line=Instance.new("Frame",DividerContainer); Line.Name="FullLine"; Line.BackgroundColor3=DividerConfig.Color or getColorFunc("Stroke",Line,"BackgroundColor3"); Line.BorderSizePixel=0; Line.AnchorPoint=Vector2.new(0.5,0.5); Line.Position=UDim2.new(0.5,0,0.5,0); Line.Size=UDim2.new(1,-10,0,1)
			else DividerContainer.Size = UDim2.new(1,0,0,(DividerConfig.TextSize or 12)+8); local ListLayout=Instance.new("UIListLayout",DividerContainer); ListLayout.FillDirection=Enum.FillDirection.Horizontal; ListLayout.VerticalAlignment=Enum.VerticalAlignment.Center; ListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; ListLayout.SortOrder=Enum.SortOrder.LayoutOrder; ListLayout.Padding=UDim.new(0,8); local Line1=Instance.new("Frame",DividerContainer); Line1.Name="Line1"; Line1.BackgroundColor3=DividerConfig.Color or getColorFunc("Stroke",Line1,"BackgroundColor3"); Line1.BorderSizePixel=0; Line1.Size=UDim2.new(1,0,0,1); Line1.LayoutOrder=1; local DividerText=Instance.new("TextLabel",DividerContainer); DividerText.Name="DividerText"; DividerText.Text=DividerConfig.Text; DividerText.TextColor3=DividerConfig.TextColor or getColorFunc("Text",DividerText,"TextColor3"); DividerText.Font=DividerConfig.Font or Enum.Font.GothamBold; DividerText.TextSize=DividerConfig.TextSize or 12; DividerText.BackgroundTransparency=1; DividerText.AutomaticSize=Enum.AutomaticSize.X; DividerText.Size=UDim2.new(0,0,1,0); DividerText.LayoutOrder=2; local Line2=Instance.new("Frame",DividerContainer); Line2.Name="Line2"; Line2.BackgroundColor3=DividerConfig.Color or getColorFunc("Stroke",Line2,"BackgroundColor3"); Line2.BorderSizePixel=0; Line2.Size=UDim2.new(1,0,0,1); Line2.LayoutOrder=3 end
			task.defer(function() SectionObject._UpdateSizeSection(); SectionObject._UpdateSizeScroll() end); CountItem=CountItem+1; return {}
		end
		return SectionObject
	end

	function UIInstance:SelectTab(tabObject)
		if not tabObject or not tabObject._ScrolLayers or not tabObject._TabConfig then -- Instance might be nil for settings tab
			warn("SelectTab: Invalid tabObject or missing critical properties.")
			return
		end

		local selectedTabFrameInstance = tabObject.Instance -- This is nil for the settings tab object
		local isSettings = tabObject._IsSettingsTab

		if ScrollTab then
			for _, child in ipairs(ScrollTab:GetChildren()) do
				if child:IsA("Frame") and child.Name:match("^TabInstance_") and child ~= selectedTabFrameInstance then
					child.BackgroundTransparency = 1
					local cf = child:FindFirstChild("ChooseFrame")
					if cf then cf.Visible = false; cf.Size = UDim2.new(0,3,0,0) end -- Reset size too
				end
			end
		end

		if customizeButtonInstance then
			customizeButtonInstance.BackgroundTransparency = 0.95
		end

		if isSettings then
			if customizeButtonInstance then
				customizeButtonInstance.BackgroundTransparency = 0.92
			end
		else
			if selectedTabFrameInstance then
				selectedTabFrameInstance.BackgroundTransparency = 0.92
				local cf = selectedTabFrameInstance:FindFirstChild("ChooseFrame")
				if cf then
					cf.Visible = true
					local targetSize = UDim2.new(0, 3, 1, -8)
					if TweenService then
						TweenService:Create(cf, TweenInfo.new(0.2), {Size = targetSize}):Play()
					else
						cf.Size = targetSize
					end
				end
			end
		end

		if isSettings then
			if not isSettingsViewActive then
				lastSelectedTabName = NameTab.Text -- Save current user tab name
			end
			SettingsPage_UI.Visible = true
			LayersReal.Visible = false
			NameTab.Text = "Customize"
			isSettingsViewActive = true
		else
			if tabObject._TabConfig then NameTab.Text = tabObject._TabConfig.Name end
			SettingsPage_UI.Visible = false
			LayersReal.Visible = true
			if LayersPageLayout and tabObject._ScrolLayers then LayersPageLayout:JumpTo(tabObject._ScrolLayers) end
			isSettingsViewActive = false
		end

		if not isSettings and SaveFile_Local then
			SaveFile_Local("LastSelectedUserTab", tabObject._TabConfig.Name)
		elseif isSettings and SaveFile_Local then
			SaveFile_Local("LastSelectedUserTab", nil)
		end
	end

	function UIInstance:CreateTab(TabConfig)
		local TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""
		TabConfig.IsSettingsTab = TabConfig.IsSettingsTab or false

		local ScrolLayers_TabContent
		local UIListLayout_TabContent

		if TabConfig.IsSettingsTab then
			ScrolLayers_TabContent = SettingsPage_UI
			UIListLayout_TabContent = SettingsPage_UI:FindFirstChildOfClass("UIListLayout") or SettingsPageLayout_UI
		else
			ScrolLayers_TabContent = Instance.new("ScrollingFrame")
			ScrolLayers_TabContent.Name = "ScrolLayers_UserTab_" .. TabConfig.Name
			ScrolLayers_TabContent.ScrollBarThickness = 6
			ScrolLayers_TabContent.Active = true
			ScrolLayers_TabContent.LayoutOrder = CountTab
			ScrolLayers_TabContent.BackgroundTransparency = 1
			ScrolLayers_TabContent.BorderSizePixel = 0
			ScrolLayers_TabContent.Size = UDim2.new(1, 0, 1, 0)
			ScrolLayers_TabContent.CanvasSize = UDim2.new(0,0,0,0)
			ScrolLayers_TabContent.Parent = LayersFolder

			UIListLayout_TabContent = Instance.new("UIListLayout")
			UIListLayout_TabContent.Padding = UDim.new(0, 3)
			UIListLayout_TabContent.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_TabContent.Parent = ScrolLayers_TabContent
		end

		local TabConfigNameValue = Instance.new("StringValue")
		TabConfigNameValue.Name = "TabConfig_Name"
		TabConfigNameValue.Value = TabConfig.Name
		TabConfigNameValue.Parent = ScrolLayers_TabContent

		local TabObject = {}
		local TabButtonFrame

		if TabConfig.IsSettingsTab then
			TabObject.Instance = nil
		else
			TabButtonFrame = Instance.new("Frame")
			TabButtonFrame.Name = "TabInstance_" .. TabConfig.Name
			TabButtonFrame.BackgroundTransparency = 1
			TabButtonFrame.BorderSizePixel = 0
			TabButtonFrame.Parent = ScrollTab
			TabButtonFrame.LayoutOrder = CountTab
			TabButtonFrame.Size = UDim2.new(1, 0, 0, 30)

			local UICorner3 = Instance.new("UICorner")
			UICorner3.CornerRadius = UDim.new(0, 4)
			UICorner3.Parent = TabButtonFrame

			local TabButton = Instance.new("TextButton");
			TabButton.Name = "TabButton"
			TabButton.Text = ""
			TabButton.BackgroundTransparency = 1
			TabButton.Size = UDim2.new(1, 0, 1, 0)
			TabButton.Parent = TabButtonFrame

			local TabName_Display = Instance.new("TextLabel") -- Renamed from TabName
			TabName_Display.Name = "TabNameDisplay"
			TabName_Display.Text = TabConfig.Name
			TabName_Display.Font = Enum.Font.GothamBold
			TabName_Display.TextColor3 = GetColor("Text", TabName_Display, "TextColor3")
			TabName_Display.TextSize = 13
			TabName_Display.TextXAlignment = Enum.TextXAlignment.Left
			TabName_Display.BackgroundTransparency = 1
			TabName_Display.Size = UDim2.new(1, 0, 1, 0)
			TabName_Display.Position = UDim2.new(0, 30, 0, 0)
			TabName_Display.Parent = TabButtonFrame

			local FeatureImg = Instance.new("ImageLabel");
			FeatureImg.Name = "FeatureImg"
			FeatureImg.Image = TabConfig.Icon
			FeatureImg.ImageColor3 = GetColor("Text", FeatureImg, "ImageColor3")
			FeatureImg.BackgroundTransparency = 1
			FeatureImg.Position = UDim2.new(0, 9, 0, 7)
			FeatureImg.Size = UDim2.new(0, 16, 0, 16)
			FeatureImg.Parent = TabButtonFrame

			local cf = Instance.new("Frame", TabButtonFrame)
			cf.Name = "ChooseFrame"
			cf.BackgroundColor3 = GetColor("ThemeHighlight", cf, "BackgroundColor3")
			cf.BorderSizePixel = 0
			cf.AnchorPoint = Vector2.new(0, 0.5)
			cf.Position = UDim2.new(0, 0, 0.5, 0)
			cf.Size = UDim2.new(0, 3, 0, 0)
			cf.Visible = false
			Instance.new("UICorner", cf).CornerRadius = UDim.new(0, 2)

			TabObject.Instance = TabButtonFrame
			ScrolLayersMap[TabButtonFrame] = ScrolLayers_TabContent
			FrameToTabObjectMap[TabButtonFrame] = TabObject

			TabButton.Activated:Connect(function()
				CircleClick(TabButton, Mouse.X, Mouse.Y) -- Mouse is global
				UIInstance:SelectTab(TabObject)
			end)
		end

		local currentTabSectionCount = 0
		TabObject._ScrolLayers = ScrolLayers_TabContent
		TabObject._UIListLayout = UIListLayout_TabContent
		TabObject._IsSettingsTab = TabConfig.IsSettingsTab
		TabObject._TabConfig = TabConfig

		if not TabConfig.IsSettingsTab then
			table.insert(UIInstance.UserTabObjects, TabObject)
		end

		function TabObject:AddSection(Title)
			Title = Title or "Section"
			local function updateThisTabScrollFunc(scroller, padding)
				task.defer(function()
					if not scroller or not scroller.Parent then return end
					local totalHeight = 0
					local layout = scroller:FindFirstChildOfClass("UIListLayout")
					if not layout then return end

					for _, child in ipairs(scroller:GetChildren()) do
						if child:IsA("GuiObject") and child ~= layout then
							totalHeight = totalHeight + child.AbsoluteSize.Y + layout.Padding.Offset
						end
					end
					if #scroller:GetChildren() > 1 then totalHeight = totalHeight - layout.Padding.Offset end
					if totalHeight < 0 then totalHeight = 0 end
					scroller.CanvasSize = UDim2.new(0, scroller.CanvasSize.X.Offset, 0, totalHeight)
				end)
			end

			local function getThisTabLayoutPadding()
				return self._UIListLayout and self._UIListLayout.Padding or UDim.new(0,3)
			end

			local newSectionObject = InternalCreateSection_Local(
				self._ScrolLayers, Title, currentTabSectionCount,
				GuiConfig, Flags, Themes, function() return CurrentTheme end,
				GetColor, SetTheme_Local, LoadUIAsset, SaveFile_Local,
				HttpService, TweenService, Mouse, CircleClick,
				updateThisTabScrollFunc, getThisTabLayoutPadding
			)
			currentTabSectionCount = currentTabSectionCount + 1
			return newSectionObject
		end

		CountTab = CountTab + 1
		if not TabConfig.IsSettingsTab and ScrollTab and UIListLayout_ScrollTab then -- Ensure ScrollTab's CanvasSize is updated for user tabs
			task.defer(function()
				if ScrollTab and UIListLayout_ScrollTab and UIListLayout_ScrollTab.Parent then
					ScrollTab.CanvasSize = UDim2.new(0,0,0, UIListLayout_ScrollTab.AbsoluteContentSize.Y)
				end
			end)
		end
		return TabObject
	end

	ChangeAsset_Local = function(type, input, name)
		local mediaFolder = UBDir .."/".."Asset"
		if not isfolder(mediaFolder) then makefolder(mediaFolder) end
		local asset
		local success, err = pcall(function()
			if input:match("^https?://") then
				local data = game:HttpGet(input)
				local extension = type == "Image" and ".png" or ".mp4"
				if not name:match("%..+$") then name = name .. extension end
				local filePath = mediaFolder.."/"..name
				writefile(filePath, data)
				asset = getcustomasset(filePath)
			elseif input == "Reset" then return
			else asset = getcustomasset(input) end
		end)
		if not success then warn("ChangeAsset_Local: Error loading asset:", err); return err end
		if type == "Image" then
			BackgroundImage.Image = asset or ""; BackgroundVideo.Video = ""; BGImage = true; BGVideo = false
		elseif type == "Video" then
			BackgroundVideo.Video = asset or ""; BackgroundImage.Image = ""; BGVideo = true; BGImage = false; BackgroundVideo.Playing = true
		end
	end

	ResetAsset_Local = function()
		BackgroundVideo.Video = ""; BackgroundImage.Image = ""; BGVideo = false; BGImage = false
	end

	ChangeTransparency_Local = function(Trans)
		Main.BackgroundTransparency = Trans
		if BGVideo or BGImage then
			BackgroundImage.ImageTransparency = Trans
			BackgroundVideo.BackgroundTransparency = Trans -- VideoFrame uses BackgroundTransparency for its visual content
		end
	end

	-- Define GuiFunc methods
	GuiFunc = {} -- Ensure GuiFunc is a table
	function GuiFunc:DestroyGui()
		for _, conn in ipairs(connections) do
			if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then
				conn:Disconnect()
			end
		end
		table.clear(connections)

		if UBHubGui and UBHubGui.Parent then
			UBHubGui:Destroy()
		end
		if ScreenGui_Minimized and ScreenGui_Minimized.Parent then
			ScreenGui_Minimized:Destroy()
		end
	end

	function GuiFunc:ToggleUI()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightShift,false,game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.RightShift,false,game)
	end

	-- Set up connections for Top bar buttons (Close, Min, MaxRestore)
	Close.Activated:Connect(function()
		CircleClick(Close, Mouse.X, Mouse.Y) -- Mouse is global
		GuiFunc:DestroyGui()
	end)

	Min.Activated:Connect(function()
		CircleClick(Min, Mouse.X, Mouse.Y)
		minimizedLastPosition = DropShadowHolder.Position
		minimizedLastSize = DropShadowHolder.Size
		DropShadowHolder.Visible = false
		-- DropShadow visibility is tied to DropShadowHolder's
        MinimizedIcon.Visible = true
	end)

	MaxRestore.Activated:Connect(function()
		CircleClick(MaxRestore, Mouse.X, Mouse.Y)
		MAXIMIZE_ICON_ASSET = MAXIMIZE_ICON_ASSET or LoadUIAsset("rbxassetid://9886659406", "MaxRestore_MaximizeIcon.png")
		RESTORE_ICON_ASSET = RESTORE_ICON_ASSET or LoadUIAsset("rbxassetid://16598400946", "MaxRestore_RestoreIcon.png")

		if isMaximized then
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = OldPos_MaxRestore}):Play()
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = OldSize_MaxRestore}):Play()
			ImageLabel_MaxRestoreIcon.Image = MAXIMIZE_ICON_ASSET
			isMaximized = false
		else
			OldPos_MaxRestore = DropShadowHolder.Position
			OldSize_MaxRestore = DropShadowHolder.Size
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)}):Play()
			ImageLabel_MaxRestoreIcon.Image = RESTORE_ICON_ASSET
			isMaximized = true
		end
	end)

	MinimizedIcon.MouseButton1Click:Connect(function()
		DropShadowHolder.Position = minimizedLastPosition
		DropShadowHolder.Size = minimizedLastSize
		DropShadowHolder.Visible = true
		MinimizedIcon.Visible = false
	end)

	-- Load assets for icons now that LoadUIAsset is available (if it's local, or confirm global is fine)
	-- Assuming LoadUIAsset is the global one for now.
	ImageLabel_CloseIcon.Image = LoadUIAsset("rbxassetid://9886659671", "CloseIcon.png")
	ImageLabel_MinIcon.Image = LoadUIAsset("rbxassetid://9886659276", "MinIcon.png")
	MAXIMIZE_ICON_ASSET = LoadUIAsset("rbxassetid://9886659406", "MaxRestore_MaximizeIcon.png")
	RESTORE_ICON_ASSET = LoadUIAsset("rbxassetid://16598400946", "MaxRestore_RestoreIcon.png")
	ImageLabel_MaxRestoreIcon.Image = MAXIMIZE_ICON_ASSET -- Set initial state

	if _G.Script == "UB" then
		MinimizedIcon.Image = LoadUIAsset("rbxassetid://123551041633320", "LogoUB.png")
	elseif _G.Script == "Swee" then
		MinimizedIcon.Image = LoadUIAsset("rbxassetid://135386452636194", "SweeHubLogo.png")
	else
		MinimizedIcon.Image = "rbxassetid://0" -- Fallback or placeholder
	end

	--[[ MakeGui Content will be built from here in subsequent steps ]]

	-- Step 4: Populate the Settings Page, Connect Events, and Finalize

	LoadFile_Local() -- Ensure flags are loaded before use, especially for theme and UI size.

	-- Set initial theme and UI size based on loaded flags
	local themeToLoadOnStartup = Flags.LastThemeName
	if themeToLoadOnStartup then
		local customThemeData = Flags.LastCustomThemeData
		if customThemeData and ( (Flags.CustomUserThemes and Flags.CustomUserThemes[themeToLoadOnStartup]) or themeToLoadOnStartup == "__customApplied" or themeToLoadOnStartup == "__loadedStartupTheme" or not Themes[themeToLoadOnStartup] ) then
			Themes["__loadedStartupTheme"] = deepcopy(customThemeData)
			SetTheme_Local("__loadedStartupTheme")
		elseif Themes[themeToLoadOnStartup] then
			SetTheme_Local(themeToLoadOnStartup)
		else
			SetTheme_Local(CurrentTheme)
		end
	else
		SetTheme_Local(CurrentTheme)
	end

	local loadedWindowSize = LoadUISize_Local("UI_Size")
	if loadedWindowSize then
		DropShadowHolder.Size = loadedWindowSize
	else
		DropShadowHolder.Size = UDim2.new(0, SizeUI.X.Offset + 2 * SHADOW_PADDING, 0, SizeUI.Y.Offset + 2 * SHADOW_PADDING)
	end
	task.defer(function() -- Centering after size is potentially set from save
		if UBHubGui and DropShadowHolder and UBHubGui.AbsoluteSize.X > 0 and UBHubGui.AbsoluteSize.Y > 0 and DropShadowHolder.AbsoluteSize.X > 0 then
			DropShadowHolder.Position = UDim2.new(
				0, math.floor((UBHubGui.AbsoluteSize.X - DropShadowHolder.AbsoluteSize.X) / 2),
				0, math.floor((UBHubGui.AbsoluteSize.Y - DropShadowHolder.AbsoluteSize.Y) / 2)
			)
		end
	end)

	-- Apply initial background if saved
	if Flags.CustomBackgroundURL and Flags.CustomBackgroundURL ~= "" then
		local bgType = Flags.CustomBackgroundType or "Image"
		ChangeAsset_Local(bgType, Flags.CustomBackgroundURL, "InitialBG")
	end
	if Flags.UI_BackgroundTransparency then
		ChangeTransparency_Local(Flags.UI_BackgroundTransparency / 100)
	else
		ChangeTransparency_Local(0.1) -- Default if not saved
	end


	MakeDraggable_Local(Top, DropShadowHolder)
	local resizeAPI = MakeResizable_Local(DropShadowHolder, "UI_Size") -- DropShadowHolder is the main resizable element

	-- Core Drag and Resize Logic (now uses _Local functions)
	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local currentTarget = input.Target
		local foundDraggable = nil
		local foundResizable = nil
		while currentTarget and currentTarget ~= UBHubGui do
			if draggableElements[currentTarget] then foundDraggable = currentTarget; break end
			if resizableElements[currentTarget] then foundResizable = currentTarget; break end
			if currentTarget == DropShadowHolder or currentTarget == Main then break end
			currentTarget = currentTarget.Parent
		end
		if foundDraggable then
			isWindowDragging = true; windowDragInitiator = foundDraggable; windowDragTarget = draggableElements[foundDraggable].objectToDrag
			windowDragStartMouse = Vector2.new(input.Position.X, input.Position.Y); windowDragStartPos = windowDragTarget.Position
		elseif foundResizable then
			isWindowResizing = true; windowResizeInitiator = foundResizable
			local resizeData = resizableElements[foundResizable]
			windowResizeTarget = resizeData.objectToResize
			windowResizeStartMouse = Vector2.new(input.Position.X, input.Position.Y); windowResizeStartSize = windowResizeTarget.Size
		end
	end))

	table.insert(connections, UserInputService.InputChanged:Connect(function(input)
		if not (isWindowDragging or isWindowResizing) then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local mouseDelta = Vector2.new(input.Position.X, input.Position.Y) - windowDragStartMouse
		if isWindowDragging and windowDragTarget then
			local newPosition = UDim2.new(
				windowDragStartPos.X.Scale, windowDragStartPos.X.Offset + mouseDelta.X,
				windowDragStartPos.Y.Scale, windowDragStartPos.Y.Offset + mouseDelta.Y
			)
			windowDragTarget.Position = newPosition
		elseif isWindowResizing and windowResizeTarget then
			local resizeData = resizableElements[windowResizeInitiator]
			if resizeData and resizeData.api and resizeData.api.handleSizeChange then
				local newSizeX = windowResizeStartSize.X.Offset + mouseDelta.X
				local newSizeY = windowResizeStartSize.Y.Offset + mouseDelta.Y
				newSizeX = math.max(newSizeX, 200); newSizeY = math.max(newSizeY, 150)
				resizeData.api.handleSizeChange(UDim2.new(0, newSizeX, 0, newSizeY))
			end
		end
	end))

	table.insert(connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if isWindowDragging then isWindowDragging = false; windowDragTarget = nil; windowDragInitiator = nil end
			if isWindowResizing then isWindowResizing = false; windowResizeTarget = nil; windowResizeInitiator = nil end
		end
	end))

	-- RightShift Toggle
	table.insert(connections, UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.RightShift then
			DropShadowHolder.Visible = not DropShadowHolder.Visible
			MinimizedIcon.Visible = not DropShadowHolder.Visible and not MinimizedIcon.Visible -- Show if main is hidden
		end
	end))

	-- Main content area resizing logic
	table.insert(connections, DropShadowHolder:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local mainAbsSize = Main.AbsoluteSize
		local topBarHeight = Top.AbsoluteSize.Y
		local layersTabXPadding = LAYERS_TAB_X_PADDING
		local layersTabWidth = GuiConfig["Tab Width"]
		local layersTabYPos = calculatedLayersTabYPos -- Use the calculated value from Step 2
		local generalBottomMargin = GENERAL_BOTTOM_MARGIN
		local paddingBetweenTabsAndContent = PADDING_BETWEEN_TABS_AND_CONTENT

		LayersTab.Size = UDim2.new(0, layersTabWidth, 0, mainAbsSize.Y - layersTabYPos - generalBottomMargin)
		local layersXPos = layersTabXPadding + layersTabWidth + paddingBetweenTabsAndContent
		Layers.Position = UDim2.new(0, layersXPos, 0, layersTabYPos)
		Layers.Size = UDim2.new(0, mainAbsSize.X - layersXPos - layersTabXPadding, 0, mainAbsSize.Y - layersTabYPos - generalBottomMargin) 

		if SettingsPage_UI then
			SettingsPage_UI.Position = Layers.Position
			SettingsPage_UI.Size = Layers.Size
		end
	end))


	-- Create the logical CustomizeTab object using UIInstance API
	local CustomizeTabObject = UIInstance:CreateTab({
		Name = "Customize",
		Icon = "rbxassetid://126800841735072", -- Placeholder icon, can be themed
		IsSettingsTab = true
	})

	-- Connect the NewCustomizeButton (created in Step 2) to select the CustomizeTabObject
	if customizeButtonInstance and CustomizeTabObject then
		NewCustomizeButton.Activated:Connect(function()
			CircleClick(NewCustomizeButton, Mouse.X, Mouse.Y)
			UIInstance:SelectTab(CustomizeTabObject)
		end)
	end

	-- Populate the Settings Page (CustomizeTabObject)
	if CustomizeTabObject then
		local PresetManagementSection = CustomizeTabObject:AddSection("Preset Management")
		local defaultThemesDropdown = PresetManagementSection:AddDropdown({
			Title = "Default Themes", Content = "Select a built-in theme", Options = GetThemes(),
			Callback = function(selected) end
		})
		PresetManagementSection:AddButton({ Title = "Apply Default Theme", Content = "Apply the selected default theme",
			Callback = function()
				local selectedValueTable = defaultThemesDropdown:GetValue()
				if selectedValueTable and #selectedValueTable > 0 then
					local themeToApply = selectedValueTable[1]
					SetTheme_Local(themeToApply) -- Use local SetTheme
					if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Theme Applied", Description = "Applied theme: " .. themeToApply, Time = 0.3, Delay = 2}) end
				else
					if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Theme Error", Description = "No default theme selected.", Time = 0.3, Delay = 2}) end
				end
			end
		})
		PresetManagementSection:AddDivider({Text = "Preset Settings"})
		local customPresetNameInput = PresetManagementSection:AddInput({ Title = "Custom Preset Name", Content = "Enter a name for your new preset", Default = "" })
		local customThemesDropdownApply, customThemesDropdownDelete
		local function refreshCustomPresetDropdownsLocal(dd1, dd2) -- Made local to this scope
			local savedNames = {}; Flags.CustomUserThemes = Flags.CustomUserThemes or {}; for name,_ in pairs(Flags.CustomUserThemes) do table.insert(savedNames, name) end; table.sort(savedNames)
			local sel1 = dd1 and dd1.Value or {}; local sel2 = dd2 and dd2.Value or {}
			if dd1 then dd1:Refresh(savedNames, sel1) end; if dd2 then dd2:Refresh(savedNames, sel2) end
		end
		PresetManagementSection:AddButton({ Title = "Save Current Colors", Content = "Save current colors as new preset",
			Callback = function()
				local presetName = customPresetNameInput:GetValue()
				if not presetName or presetName == "" then if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Save Error", Description = "Preset name cannot be empty."}) end; return end
				Flags.CustomUserThemes = Flags.CustomUserThemes or {}
				if Themes[CurrentTheme] then
					 Flags.CustomUserThemes[presetName] = deepcopy(Themes[CurrentTheme])
					 SaveFile_Local("CustomUserThemes", Flags.CustomUserThemes)
					 refreshCustomPresetDropdownsLocal(customThemesDropdownApply, customThemesDropdownDelete)
					 if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Preset Saved", Description = "'" .. presetName .. "' saved."}) end
				else
					 if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Save Error", Description = "Cannot get current theme data for: " .. CurrentTheme}) end
				end
			end
		})
		customThemesDropdownApply = PresetManagementSection:AddDropdown({ Title = "Apply Custom Preset", Content = "Select a saved preset", Options = {} })
		PresetManagementSection:AddButton({ Title = "Apply Selected Custom", Content = "Load and apply chosen theme",
			Callback = function()
				local valTable = customThemesDropdownApply:GetValue(); if valTable and #valTable > 0 then local pName = valTable[1]
					if Flags.CustomUserThemes and Flags.CustomUserThemes[pName] then Themes["__customApplied"] = deepcopy(Flags.CustomUserThemes[pName]); SetTheme_Local("__customApplied"); if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Preset Applied", Description="'"..pName.."' applied."}) end
					else if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Apply Error", Description="Cannot find preset: "..pName}) end end
				else if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Apply Error", Description="No preset selected."}) end end
			end
		})
		customThemesDropdownDelete = PresetManagementSection:AddDropdown({ Title = "Delete Custom Preset", Content = "Select preset to remove", Options = {} })
		PresetManagementSection:AddButton({ Title = "Delete Selected Custom", Content = "Remove chosen theme",
			Callback = function()
				local valTable = customThemesDropdownDelete:GetValue(); if valTable and #valTable > 0 then local pName = valTable[1]
					if Flags.CustomUserThemes and Flags.CustomUserThemes[pName] then Flags.CustomUserThemes[pName] = nil; SaveFile_Local("CustomUserThemes", Flags.CustomUserThemes); refreshCustomPresetDropdownsLocal(customThemesDropdownApply, customThemesDropdownDelete); if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Preset Deleted", Description="'"..pName.."' deleted."}) end
					else if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Delete Error", Description="Cannot find preset: "..pName}) end end
				else if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title="Delete Error", Description="No preset selected."}) end end
			end
		})
		refreshCustomPresetDropdownsLocal(customThemesDropdownApply, customThemesDropdownDelete)

		local InterfaceSection = CustomizeTabObject:AddSection("Interface")
		InterfaceSection:AddSlider({ Title = "Window Transparency", Content = "Adjust background opacity", Min = 0, Max = 100, Increment = 1, Default = (Main.BackgroundTransparency or 0.1) * 100, Callback = function(value) ChangeTransparency_Local(value / 100) end, Flag = "UI_BackgroundTransparency" })
		local bgAssetInput = InterfaceSection:AddInput({ Title = "Background Asset URL/Path", Content = "Image/video URL or local path", Default = Flags["CustomBackgroundURL"] or "" })
		InterfaceSection:AddButton({ Title = "Set Image Background", Callback = function() local assetUrl = bgAssetInput:GetValue(); if assetUrl and assetUrl ~= "" then ChangeAsset_Local("Image", assetUrl, "CustomBG_Img"); SaveFile_Local("CustomBackgroundURL", assetUrl); SaveFile_Local("CustomBackgroundType", "Image") end end})
		InterfaceSection:AddButton({ Title = "Set Video Background", Callback = function() local assetUrl = bgAssetInput:GetValue(); if assetUrl and assetUrl ~= "" then ChangeAsset_Local("Video", assetUrl, "CustomBG_Vid"); SaveFile_Local("CustomBackgroundURL", assetUrl); SaveFile_Local("CustomBackgroundType", "Video") end end})
		InterfaceSection:AddButton({ Title = "Reset Background", Callback = function() ResetAsset_Local(); SaveFile_Local("CustomBackgroundURL", ""); SaveFile_Local("CustomBackgroundType", "") end})
		
		local CustomizeColorsSection = CustomizeTabObject:AddSection("Customize Colors")
		if #CANONICAL_THEME_COLOR_KEYS > 0 then
			for _, colorKeyName in ipairs(CANONICAL_THEME_COLOR_KEYS) do
				local initialEditorColor = (Themes[CurrentTheme] and Themes[CurrentTheme][colorKeyName]) or Color3.new(0,0,0)
				if type(initialEditorColor) ~= "Color3" then initialEditorColor = Color3.new(0,0,0) end
				createColorEditor_Local(CustomizeColorsSection, colorKeyName, initialEditorColor)
			end
		else
		    if UBHubLib and UBHubLib.MakeNotify then UBHubLib:MakeNotify({Title = "Theme System Error", Description = "Cannot create color editors: Canonical color key list is empty."}) end
		end
	end

	task.defer(function()
		if UBHubGui and DropShadowHolder and UBHubGui.AbsoluteSize.X > 0 and UBHubGui.AbsoluteSize.Y > 0 and DropShadowHolder.AbsoluteSize.X > 0 then
			DropShadowHolder.Position = UDim2.new(0, math.floor((UBHubGui.AbsoluteSize.X - DropShadowHolder.AbsoluteSize.X) / 2), 0, math.floor((UBHubGui.AbsoluteSize.Y - DropShadowHolder.AbsoluteSize.Y) / 2))
		end
		local successfullySelectedSavedTab = false
		local lastSelectedUserTabNameFromFlags = Flags.LastSelectedUserTab -- Changed from LastSelectedTabName

		if lastSelectedUserTabNameFromFlags and UIInstance.UserTabObjects and #UIInstance.UserTabObjects > 0 then
			for _, tabObjInList in ipairs(UIInstance.UserTabObjects) do
				if tabObjInList._TabConfig and tabObjInList._TabConfig.Name == lastSelectedUserTabNameFromFlags then
					UIInstance:SelectTab(tabObjInList)
					successfullySelectedSavedTab = true
					break
				end
			end
			if not successfullySelectedSavedTab then
			    if SaveFile_Local then SaveFile_Local("LastSelectedUserTab", nil) end
			end
		end

		if not successfullySelectedSavedTab then
			if UIInstance.UserTabObjects and #UIInstance.UserTabObjects > 0 then
				local firstUserTabObject = UIInstance.UserTabObjects[1]
				if firstUserTabObject then UIInstance:SelectTab(firstUserTabObject) end
			elseif CustomizeTabObject then -- Select settings if no user tabs
				UIInstance:SelectTab(CustomizeTabObject)
			else
				warn("MakeGui: No user tabs and no CustomizeTabObject to select initially.")
				if NameTab then NameTab.Text = "" end
				if SettingsPage_UI then SettingsPage_UI.Visible = false end
				if LayersReal then LayersReal.Visible = true end
				if LayersPageLayout then LayersPageLayout:Clear() end
			end
		end
		if UBHubGui.Parent ~= CoreGui and ProtectGui then -- Ensure it's parented if ProtectGui didn't do it
			UBHubGui.Parent = CoreGui
		end
	end)
	
	return UIInstance
end
return UBHubLib
