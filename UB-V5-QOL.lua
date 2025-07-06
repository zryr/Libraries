local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()

local function FetchAndLoadModule(url)
    local success, content = pcall(game.HttpGetAsync, game, url)
    if not success then
        warn("Failed to fetch module from URL:", url, "\nError:", content)
        return nil
    end

    local func, err = loadstring(content)
    if not func then
        warn("Failed to loadstring for module from URL:", url, "\nError:", err)
        return nil
    end

    local ok, module = pcall(func)
    if not ok then
        warn("Failed to execute module from URL:", url, "\nError:", module)
        return nil
    end
    return module
end

local FONT_MANAGER_URL = "https://raw.githubusercontent.com/zryr/Libraries/refs/heads/Jully/Core/FontManager.lua"
local CONFIG_MANAGER_URL = "https://raw.githubusercontent.com/zryr/Libraries/refs/heads/Jully/Core/ConfigManager.lua"
local ICON_MANAGER_URL = "https://raw.githubusercontent.com/zryr/Libraries/refs/heads/Jully/Icons/Main.lua"

local FontManager = FetchAndLoadModule(FONT_MANAGER_URL)
local ConfigManager = FetchAndLoadModule(CONFIG_MANAGER_URL)
local ExternalIconManager = FetchAndLoadModule(ICON_MANAGER_URL)

if not FontManager then error("CRITICAL: FontManager module failed to load. UI cannot continue.") end
if not ConfigManager then error("CRITICAL: ConfigManager module failed to load. UI cannot continue.") end
if not ExternalIconManager then error("CRITICAL: ExternalIconManager module failed to load. UI cannot continue.") end


FontManager:RegisterFont("GothamBold", Enum.Font.GothamBold)
FontManager:RegisterFont("SourceSans", Enum.Font.SourceSans)

-- ExternalIconManager.SetIconsType("lucide") -- This is already the default in its own Main.lua

local Themes = {
    Default = {
        Colors = {
            Primary = Color3.fromRGB(160, 40, 0),
            Secondary = Color3.fromRGB(160, 30, 0),
            Accent = Color3.fromRGB(200, 50, 0),
            ThemeHighlight = Color3.fromRGB(255, 80, 0),
            Text = Color3.fromRGB(255, 240, 230),
            Background = Color3.fromRGB(20, 8, 0),
            Stroke = Color3.fromRGB(80, 20, 0),
            TextLight = Color3.fromRGB(230, 230, 230),
            TextVeryLight = Color3.fromRGB(255, 255, 255),
            TextDark = Color3.fromRGB(150, 150, 150),
            TextLocked = Color3.fromRGB(100,100,100),
            BackgroundLight = Color3.fromRGB(30, 12, 0),
            BackgroundTransparent = Color3.fromRGB(20, 8, 0),
            ItemHover = Color3.fromRGB(40, 15, 0),
            InputBackground = Color3.fromRGB(25, 10, 0),
            LockedOverlay = Color3.fromRGB(50,50,50),
        },
        Fonts = { Primary = "GothamBold", Secondary = "SourceSans" },
        Sizes = {
            TitleBarHeight = 38, TabWidth = 120, SectionItemPadding = UDim.new(0, 3),
            DefaultCornerRadius = UDim.new(0, 4), LargeCornerRadius = UDim.new(0, 8), SmallCornerRadius = UDim.new(0, 2),
            ActionIconSize = UDim2.fromOffset(20, 20), CloseIconSize = UDim2.fromOffset(25, 25),
            DropdownItemHeight = 30, SectionHeaderHeight = 30, MainPadding = 9,
            TabButtonHeight = 30, TabBottomSectionHeight = 40, QuickToggleSize = UDim2.fromOffset(36,36)
        }
    }
}
local CurrentTheme = Themes.Default

local function GetColor(colorName)
    if CurrentTheme and CurrentTheme.Colors and CurrentTheme.Colors[colorName] then
        return CurrentTheme.Colors[colorName]
    else
        warn("GetColor: Color '" .. tostring(colorName) .. "' not found. Falling back to white.")
        return Color3.fromRGB(255, 255, 255)
    end
end

local ProtectGui = protectgui or (syn and syn.protect_gui) or function(f) end
local CoreGui = game:GetService("CoreGui")
local SizeUI = UDim2.fromOffset(550, 330)
local function MakeDraggable(topbarobject, object)
	local function CustomPos(tbObject, obj)
		local Dragging = nil
		local DragInput = nil
		local DragStart = nil
		local StartPosition = nil
		local DragTween = nil

		local function UpdatePos(input)
			local Delta = input.Position - DragStart
			local newPosUDim = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)

			if obj.Parent and obj.Parent:IsA("GuiObject") then
				local parentSize = obj.Parent.AbsoluteSize
				local objectSize = obj.AbsoluteSize
				newPosUDim = UDim2.new(
					StartPosition.X.Scale, math.clamp(StartPosition.X.Offset + Delta.X, 0, parentSize.X - objectSize.X),
					StartPosition.Y.Scale, math.clamp(StartPosition.Y.Offset + Delta.Y, 0, parentSize.Y - objectSize.Y)
				)
			end

			-- Removed Tween for quick toggle dragging responsiveness
            obj.Position = newPosUDim
		end

		tbObject.InputBegan:Connect(function(input)
			if not obj.Draggable then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = obj.Position
				-- if DragTween then DragTween:Cancel() end -- No tween for quick toggles
				
				local changedConnection
				changedConnection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
						if changedConnection then changedConnection:Disconnect() end
						if obj:GetAttribute("QuickToggleFlag") and ConfigManager then
							ConfigManager:SetFlag(obj:GetAttribute("QuickToggleFlag") .. "_Pos", {X = obj.Position.X.Offset, Y = obj.Position.Y.Offset})
						end
					end
				end)
			end
		end)

		tbObject.InputChanged:Connect(function(input)
			if not obj.Draggable then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				DragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if not obj.Draggable then return end
			if input == DragInput and Dragging then
				UpdatePos(input)
			end
		end)
	end
	CustomPos(topbarobject, object)
end

function CircleClick(Button, X, Y)
	task.spawn(function()
		Button.ClipsDescendants = true
		local Circle = Instance.new("ImageLabel")
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = CurrentTheme.Colors.ThemeHighlight
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
			task.wait(Time/10)
		end
		Circle:Destroy()
	end)
end

local UBHubLib = {}
local shownOneTimeNotifications = {}

function UBHubLib:MakeNotify(NotifyConfig)
	local NotifyConfig = NotifyConfig or {}
	NotifyConfig.Title = NotifyConfig.Title or "UB Hub"
	NotifyConfig.Description = NotifyConfig.Description or "Notification"
	NotifyConfig.Content = NotifyConfig.Content or "Content"
	NotifyConfig.Color = NotifyConfig.Color or CurrentTheme.Colors.Primary
	NotifyConfig.Time = NotifyConfig.Time or 0.5
	NotifyConfig.Delay = NotifyConfig.Delay or 5
	NotifyConfig.BackgroundImage = NotifyConfig.BackgroundImage or nil
	NotifyConfig.OneTime = NotifyConfig.OneTime or false
	NotifyConfig.OneTimeId = NotifyConfig.OneTimeId or (NotifyConfig.Title .. "::" .. NotifyConfig.Description)

	if NotifyConfig.OneTime then
		if shownOneTimeNotifications[NotifyConfig.OneTimeId] then
			return
		end
		shownOneTimeNotifications[NotifyConfig.OneTimeId] = true
	end

	local NotifyFunction = {}
	task.spawn(function()
		local NotifyGui = CoreGui:FindFirstChild("NotifyGui")
		if not NotifyGui then
			NotifyGui = Instance.new("ScreenGui");
			NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			NotifyGui.Name = "NotifyGui"
			NotifyGui.Parent = CoreGui
		end
		local NotifyLayoutFrame = NotifyGui:FindFirstChild("NotifyLayoutHolder")
		if not NotifyLayoutFrame then
			NotifyLayoutFrame = Instance.new("Frame")
            NotifyLayoutFrame.Name = "NotifyLayoutHolder"
            NotifyLayoutFrame.BackgroundTransparency = 1
            NotifyLayoutFrame.AnchorPoint = Vector2.new(1,1)
            NotifyLayoutFrame.Position = UDim2.new(1,-10,1,-10)
            NotifyLayoutFrame.Size = UDim2.new(0,320,1,-20)
            NotifyLayoutFrame.ClipsDescendants = true
            NotifyLayoutFrame.Parent = NotifyGui

			local NotifyLayout = Instance.new("UIListLayout");
			NotifyLayout.FillDirection = Enum.FillDirection.Vertical
			NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
			NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
			NotifyLayout.Padding = UDim.new(0,5)
			NotifyLayout.Name = "NotifyLayout"
			NotifyLayout.Parent = NotifyLayoutFrame
		end

		local NotifyFrame = Instance.new("Frame");
		local NotifyFrameReal = Instance.new("Frame");
		local UICorner = Instance.new("UICorner");
		local DropShadowHolder = Instance.new("Frame");
		local DropShado = Instance.new("ImageLabel");
		local Top = Instance.new("Frame");
		local TextLabel = Instance.new("TextLabel");
		local UIStroke = Instance.new("UIStroke");
		local UICorner1_Notify = Instance.new("UICorner");
		local TextLabel1 = Instance.new("TextLabel");
		local UIStroke1_Notify = Instance.new("UIStroke");
		local Close = Instance.new("TextButton");
		local ImageLabel = Instance.new("ImageLabel");
		local TextLabel2 = Instance.new("TextLabel");

		NotifyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
		NotifyFrame.Name = "NotifyFrame"
		NotifyFrame.BackgroundTransparency = 1
		NotifyFrame.Parent = NotifyGui.NotifyLayoutHolder
		NotifyFrame.LayoutOrder = #NotifyGui.NotifyLayoutHolder:GetChildren() + 1


		NotifyFrameReal.BackgroundColor3 = CurrentTheme.Colors.Primary
		NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrameReal.BorderSizePixel = 0
		NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
		NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
		NotifyFrameReal.Name = "NotifyFrameReal"
		NotifyFrameReal.Parent = NotifyFrame

		if NotifyConfig.BackgroundImage then
			local NotifyBGImage = NotifyFrameReal:FindFirstChild("NotifyBGImage") or Instance.new("ImageLabel")
			NotifyBGImage.Name = "NotifyBGImage"
			NotifyBGImage.Image = NotifyConfig.BackgroundImage
			NotifyBGImage.Size = UDim2.fromScale(1, 1)
			NotifyBGImage.BackgroundTransparency = 1
			NotifyBGImage.ZIndex = 0
			NotifyBGImage.ScaleType = Enum.ScaleType.Slice
			NotifyBGImage.SliceCenter = Rect.new(10,10, NotifyBGImage.ImageRectSize.X-10, NotifyBGImage.ImageRectSize.Y-10)
			NotifyBGImage.Parent = NotifyFrameReal
			NotifyFrameReal.BackgroundTransparency = 1
		end

		UICorner.Parent = NotifyFrameReal
		UICorner.CornerRadius = CurrentTheme.Sizes.LargeCornerRadius

		DropShadowHolder.BackgroundTransparency = 1
		DropShadowHolder.BorderSizePixel = 0
		DropShadowHolder.ZIndex = 0
		DropShadowHolder.Name = "DropShadowHolder"
		DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
		DropShadowHolder.Parent = NotifyFrameReal

		DropShado.Image = "rbxassetid://6015897843"
		DropShado.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShado.ImageTransparency = 0.5
		DropShado.ScaleType = Enum.ScaleType.Slice
		DropShado.SliceCenter = Rect.new(49, 49, 450, 450)
		DropShado.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShado.BackgroundTransparency = 1
		DropShado.BorderSizePixel = 0
		DropShado.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShado.Size = UDim2.new(1, 47, 1, 47)
		DropShado.ZIndex = 0
		DropShado.Name = "DropShado"
		DropShado.Parent = DropShadowHolder

		Top.BackgroundColor3 = CurrentTheme.Colors.Primary
		Top.BackgroundTransparency = 0.9990000128746033
		Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Top.BorderSizePixel = 0
		Top.Size = UDim2.new(1, 0, 0, 36)
		Top.Name = "Top"
		Top.Parent = NotifyFrameReal

		TextLabel.Font = FontManager:GetFont("GothamBold")
		TextLabel.Text = NotifyConfig.Title
		TextLabel.TextColor3 = CurrentTheme.Colors.Text
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

		UICorner1_Notify.Parent = Top
		UICorner1_Notify.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius

		TextLabel1.Font = FontManager:GetFont("GothamBold")
		TextLabel1.Text = NotifyConfig.Description
		TextLabel1.TextColor3 = CurrentTheme.Colors.Text
		TextLabel1.TextSize = 14
		TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel1.BackgroundColor3 = CurrentTheme.Colors.ThemeHighlight
		TextLabel1.BackgroundTransparency = 0.9990000128746033
		TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel1.BorderSizePixel = 0
		TextLabel1.Size = UDim2.new(1, 0, 1, 0)
		TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
		TextLabel1.Parent = Top

		UIStroke1_Notify.Color = NotifyConfig.Color
		UIStroke1_Notify.Thickness = 0.4000000059604645
		UIStroke1_Notify.Parent = TextLabel1

		Close.Font = FontManager:GetFont("SourceSans")
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

		ImageLabel.Image = "rbxassetid://9886659671"
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 0.9990000128746033
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.49000001, 0, 0.5, 0)
		ImageLabel.Size = UDim2.new(1, -8, 1, -8)
		ImageLabel.Parent = Close

		TextLabel2.Font = FontManager:GetFont("GothamBold")
		TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.TextSize = 13
		TextLabel2.Text = NotifyConfig.Content
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.BackgroundTransparency = 0.9990000128746033
		TextLabel2.TextColor3 = CurrentTheme.Colors.TextDark
		TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel2.BorderSizePixel = 0
		TextLabel2.Position = UDim2.new(0, 10, 0, 27)
		TextLabel2.Parent = NotifyFrameReal
		TextLabel2.Size = UDim2.new(1, -20, 0, 13)

		TextLabel2.TextWrapped = true
		task.wait()
		TextLabel2.Size = UDim2.new(1, -20, 0, TextLabel2.TextBounds.Y)


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
			TweenService:Create(
				NotifyFrameReal,
				TweenInfo.new(tonumber(NotifyConfig.Time) * 0.2, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 400, 0, 0)}):Play()
			task.wait(tonumber(NotifyConfig.Time) / 1.2)
			NotifyFrame:Destroy()
		end
		Close.Activated:Connect(function()
			NotifyFunction:Close()
		end)
		TweenService:Create(
			NotifyFrameReal,
			TweenInfo.new(tonumber(NotifyConfig.Time) * 0.2, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 0, 0, 0)}):Play()
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

local UBHubGui -- Forward declare
local GuiFunc = {} -- This will be the 'Window' object
GuiFunc.isEditMode = false -- For Quick Toggles Edit Mode
GuiFunc.ActiveQuickToggles = {} -- [flagName] = {Frame, Button, UpdateVisualsFunc, OriginalCallback, OriginalFlagValue, FeatureState }
GuiFunc.CurrentlyEditingQuickToggle = nil
GuiFunc.QuickToggleContainer = nil -- Will be a Frame in UBHubGui
GuiFunc.ResizePanel = nil -- Will be created in MakeGui
GuiFunc.SearchableElements = {} -- For Task #4 Search Functionality

-- Centralized function to handle dependency updates
local function HandleDependency(elementInstance, dependencyConfig, UpdateSizeSectionFunc, interactiveGuiObject, elementFuncTable)
	if not dependencyConfig or not dependencyConfig.Element or not dependencyConfig.Element.Changed then
		if dependencyConfig then warn("Dependency Error: Master element or its Changed event not found for element: " .. tostring(elementInstance.Name)) end
		return function() return false end
	end

	local masterElement = dependencyConfig.Element
	local triggerValue = dependencyConfig.Value
	local propertyToChange = dependencyConfig.Property
	local isCurrentlyLocked = false

	local function UpdateElementState()
		local masterValue = masterElement.Value
		local conditionMet = (masterValue == triggerValue)

		if propertyToChange == "Visible" then
			if elementInstance.Visible ~= conditionMet then
				elementInstance.Visible = conditionMet
				if UpdateSizeSectionFunc then UpdateSizeSectionFunc() end
			end
		elseif propertyToChange == "Locked" then
			isCurrentlyLocked = not conditionMet

			local mainTextLabel = elementInstance:FindFirstChild(elementInstance.Name .. "Title")
				or elementInstance:FindFirstChild("TitleLabel")
				or elementInstance:FindFirstChild("PickerLabel")
				or elementInstance:FindFirstChild("InputTitle")
				or elementInstance:FindFirstChild("DropdownTitle")
				or elementInstance:FindFirstChild("SliderTitle")
				or elementInstance:FindFirstChild("ParagraphText")
				or (elementInstance:IsA("TextLabel") and elementInstance)

			local contentTextLabel = elementInstance:FindFirstChild(elementInstance.Name .. "Content")
				or elementInstance:FindFirstChild("InputContent")
				or elementInstance:FindFirstChild("DropdownContent")
				or elementInstance:FindFirstChild("SliderContent")

			local frameToGreyOut = elementInstance:FindFirstChild("FeatureFrame")
				or elementInstance:FindFirstChild("CheckboxFrame")
				or elementInstance:FindFirstChild("SliderInput")
				or elementInstance:FindFirstChild("InputFrame")
				or elementInstance:FindFirstChild("SelectOptionsFrame")
				or elementInstance:FindFirstChild("ColorSwatchFrame")
				or (elementInstance:IsA("Frame") and not mainTextLabel and not contentTextLabel and interactiveGuiObject and interactiveGuiObject.Parent == elementInstance and interactiveGuiObject)

			if mainTextLabel then mainTextLabel.TextColor3 = isCurrentlyLocked and CurrentTheme.Colors.TextLocked or CurrentTheme.Colors.TextLight end
			if contentTextLabel then contentTextLabel.TextColor3 = isCurrentlyLocked and CurrentTheme.Colors.TextLocked or CurrentTheme.Colors.TextVeryLight end

			if frameToGreyOut and frameToGreyOut:IsA("Frame") then
				frameToGreyOut.BackgroundTransparency = isCurrentlyLocked and 0.8 or (frameToGreyOut.Name == "SelectOptionsFrame" and 0.9499 or (frameToGreyOut.Name == "CheckboxFrame" and 0 or 0.92))
				for _, child in ipairs(frameToGreyOut:GetChildren()) do
					if child:IsA("ImageLabel") then child.ImageTransparency = isCurrentlyLocked and 0.7 or 0 end
					if child:IsA("TextLabel") then child.TextColor3 = isCurrentlyLocked and CurrentTheme.Colors.TextLocked or CurrentTheme.Colors.TextVeryLight end
					if child:IsA("UIStroke") then child.Transparency = isCurrentlyLocked and 0.7 or (child.Name == "UIStroke8" and 0.9 or 0) end
				end
			elseif interactiveGuiObject and interactiveGuiObject:IsA("TextButton") and interactiveGuiObject.Parent == elementInstance then
				interactiveGuiObject.BackgroundColor3 = isCurrentlyLocked and CurrentTheme.Colors.LockedOverlay or CurrentTheme.Colors.Secondary
				interactiveGuiObject.TextColor3 = isCurrentlyLocked and CurrentTheme.Colors.TextLocked or CurrentTheme.Colors.Text
			end

			if interactiveGuiObject then
				if interactiveGuiObject:IsA("TextBox") then interactiveGuiObject.Editable = not isCurrentlyLocked end
			end
			if elementFuncTable then elementFuncTable.IsLocked = isCurrentlyLocked end
		end
	end

	masterElement.Changed:Connect(UpdateElementState)
	UpdateElementState()
	return function() return isCurrentlyLocked end
end


function UBHubLib:MakeGui(GuiConfig)
	GuiConfig = GuiConfig or {}
	GuiConfig.NameHub = GuiConfig.NameHub or "UB Hub"
	GuiConfig.Description = GuiConfig.Description or nil
	GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(255, 0, 255)
	GuiConfig["Logo Player"] = GuiConfig["Logo Player"] or "https://www.roblox.com/headshot-thumbnail/image?userId="..game:GetService("Players").LocalPlayer.UserId .."&width=420&height=420&format=png"
	GuiConfig["Name Player"] = GuiConfig["Name Player"] or tostring(game:GetService("Players").LocalPlayer.Name)
	GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or CurrentTheme.Sizes.TabWidth

	local function SaveFile(Name, Value)
		ConfigManager:SetFlag(Name, Value)
		return true
	end

	UBHubGui = Instance.new("ScreenGui");
	ConfigManager:Init(UBHubGui, "UBHubConfigs")
	GuiFunc.ParentGui = UBHubGui
	GuiFunc.ConfigManager = ConfigManager
	GuiFunc.FontManager = FontManager
	GuiFunc.ExternalIconManager = ExternalIconManager -- Store reference to the new icon manager
	GuiFunc.CurrentTheme = CurrentTheme
	GuiFunc.ThemesTable = Themes
	GuiFunc.MakeDraggable = MakeDraggable

	GuiFunc.QuickToggleContainer = Instance.new("Frame")
	GuiFunc.QuickToggleContainer.Name = "QuickToggleContainer"
	GuiFunc.QuickToggleContainer.BackgroundTransparency = 1
	GuiFunc.QuickToggleContainer.Size = UDim2.fromScale(1,1)
	GuiFunc.QuickToggleContainer.Parent = UBHubGui

	local tempResizePanel = Instance.new("Frame") -- Temporary, will be assigned to GuiFunc.ResizePanel later
	tempResizePanel.Name = "ResizePanel"
	tempResizePanel.Visible = false
	tempResizePanel.Size = UDim2.fromOffset(220, 70)
	tempResizePanel.AnchorPoint = Vector2.new(0.5, 0.5)
	tempResizePanel.Position = UDim2.fromScale(0.5, 0.5)
	tempResizePanel.BackgroundColor3 = CurrentTheme.Colors.BackgroundLight
	tempResizePanel.BorderSizePixel = 1
	tempResizePanel.BorderColor3 = CurrentTheme.Colors.Stroke
	tempResizePanel.ZIndex = 60
	tempResizePanel.Parent = UBHubGui
	local ResizePanelCorner = Instance.new("UICorner")
	ResizePanelCorner.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
	ResizePanelCorner.Parent = tempResizePanel
	GuiFunc.ResizePanel = tempResizePanel


	-- Initial setup for ResizePanel (already created, now add components)
	local ResizePanelPadding = Instance.new("UIPadding")
	ResizePanelPadding.PaddingTop = UDim.new(0, 5)
	ResizePanelPadding.PaddingBottom = UDim.new(0, 5)
	ResizePanelPadding.PaddingLeft = UDim.new(0, 5)
	ResizePanelPadding.PaddingRight = UDim.new(0, 5)
	ResizePanelPadding.Parent = GuiFunc.ResizePanel

	local ResizeListLayout = Instance.new("UIListLayout")
	ResizeListLayout.Padding = UDim.new(0, 5)
	ResizeListLayout.FillDirection = Enum.FillDirection.Vertical
	ResizeListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ResizeListLayout.Parent = GuiFunc.ResizePanel

	local ResizeTitle = Instance.new("TextLabel")
	ResizeTitle.Name = "ResizeTitle"
	ResizeTitle.Size = UDim2.new(1,0,0,15)
	ResizeTitle.Text = "Resize Quick Toggle"
	ResizeTitle.Font = FontManager:GetFont(CurrentTheme.Fonts.Secondary)
	ResizeTitle.TextSize = 12
	ResizeTitle.TextColor3 = CurrentTheme.Colors.TextLight
	ResizeTitle.BackgroundTransparency = 1
	ResizeTitle.Parent = GuiFunc.ResizePanel

	local SizeSlider = Instance.new("Frame")
	SizeSlider.Name = "SizeSliderControl"
	SizeSlider.Size = UDim2.new(1, -10, 0, 16)
	SizeSlider.Position = UDim2.new(0.5,0,0,0)
	SizeSlider.AnchorPoint = Vector2.new(0.5,0)
	SizeSlider.BackgroundColor3 = CurrentTheme.Colors.Secondary
	SizeSlider.Parent = GuiFunc.ResizePanel
	local SizeSliderCorner = Instance.new("UICorner")
	SizeSliderCorner.CornerRadius = UDim.new(0,3)
	SizeSliderCorner.Parent = SizeSlider
	local SizeSliderFill = Instance.new("Frame")
	SizeSliderFill.Name = "Fill"
	SizeSliderFill.Size = UDim2.fromScale(0.5,1)
	SizeSliderFill.BackgroundColor3 = CurrentTheme.Colors.Accent
	SizeSliderFill.Parent = SizeSlider
	local SizeSliderFillCorner = Instance.new("UICorner")
	SizeSliderFillCorner.CornerRadius = UDim.new(0,3)
	SizeSliderFillCorner.Parent = SizeSliderFill
	local SizeSliderThumb = Instance.new("Frame")
	SizeSliderThumb.Name = "Thumb"
	SizeSliderThumb.Size = UDim2.fromOffset(8,16)
	SizeSliderThumb.AnchorPoint = Vector2.new(0.5,0.5)
	SizeSliderThumb.Position = UDim2.fromScale(0.5,0.5)
	SizeSliderThumb.BackgroundColor3 = CurrentTheme.Colors.ThemeHighlight
	SizeSliderThumb.Parent = SizeSliderFill
	local SizeSliderThumbCorner = Instance.new("UICorner")
	SizeSliderThumbCorner.CornerRadius = UDim.new(0,100)
	SizeSliderThumbCorner.Parent = SizeSliderThumb


	local SizeInput = Instance.new("TextBox")
	SizeInput.Name = "SizeInput"
	SizeInput.Size = UDim2.new(0, 50, 0, 20)
	SizeInput.AnchorPoint = Vector2.new(0.5,0)
	SizeInput.Position = UDim2.new(0.5,0,0,0)
	SizeInput.Font = FontManager:GetFont(CurrentTheme.Fonts.Secondary)
	SizeInput.TextSize = 12
	SizeInput.TextColor3 = CurrentTheme.Colors.Text
	SizeInput.BackgroundColor3 = CurrentTheme.Colors.InputBackground
	SizeInput.ClearTextOnFocus = false
	SizeInput.TextXAlignment = Enum.TextXAlignment.Center
	SizeInput.Parent = GuiFunc.ResizePanel

	local ResizePanelCloseButton = Instance.new("TextButton")
	ResizePanelCloseButton.Name = "CloseResizePanel"
	ResizePanelCloseButton.Size = UDim2.new(0,16,0,16)
	ResizePanelCloseButton.Position = UDim2.new(1,-5,0,5)
	ResizePanelCloseButton.AnchorPoint = Vector2.new(1,0)
	ResizePanelCloseButton.Text = "X"
	ResizePanelCloseButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
	ResizePanelCloseButton.TextSize = 12
	ResizePanelCloseButton.TextColor3 = CurrentTheme.Colors.Text
	ResizePanelCloseButton.BackgroundColor3 = CurrentTheme.Colors.Secondary
	ResizePanelCloseButton.Parent = GuiFunc.ResizePanel
	local ResizePanelCloseCorner = Instance.new("UICorner")
	ResizePanelCloseCorner.CornerRadius = UDim.new(0,100)
	ResizePanelCloseCorner.Parent = ResizePanelCloseButton
	ResizePanelCloseButton.Activated:Connect(function()
		GuiFunc.ResizePanel.Visible = false
		GuiFunc.CurrentlyEditingQuickToggle = nil
	end)
	GuiFunc.ResizePanel.Size = UDim2.fromOffset(150, ResizeTitle.AbsoluteSize.Y + SizeSlider.AbsoluteSize.Y + SizeInput.AbsoluteSize.Y + ResizeListLayout.Padding.Offset * 4 + ResizePanelPadding.PaddingTop.Offset + ResizePanelPadding.PaddingBottom.Offset)


	GuiFunc.ShowResizePanelFor = function(quickToggleInstance)
		if not quickToggleInstance or not quickToggleInstance.Frame then return end
		GuiFunc.CurrentlyEditingQuickToggle = quickToggleInstance

		local qtFrame = quickToggleInstance.Frame
		local currentSize = qtFrame.Size.X.Offset

		local minSize, maxSize = 20, 100

		local sizeInputBox = GuiFunc.ResizePanel:FindFirstChild("SizeInput", true)
		local sliderControl = GuiFunc.ResizePanel:FindFirstChild("SizeSliderControl", true)
		local sliderFill = sliderControl and sliderControl:FindFirstChild("Fill")

		if not sizeInputBox or not sliderControl or not sliderFill then
			warn("ResizePanel UI components not found!")
			return
		end

		sizeInputBox.Text = tostring(math.floor(currentSize))

		local function updateFillFromValue(value)
			local percentage = (value - minSize) / (maxSize - minSize)
			sliderFill.Size = UDim2.fromScale(math.clamp(percentage,0,1), 1)
		end
		updateFillFromValue(currentSize)

		if sliderControl.InputBeganConnection then sliderControl.InputBeganConnection:Disconnect() end
		if sliderControl.InputChangedConnection then sliderControl.InputChangedConnection:Disconnect() end
		if sliderControl.InputEndedConnection then sliderControl.InputEndedConnection:Disconnect() end
		if sizeInputBox.FocusLostConnection then sizeInputBox.FocusLostConnection:Disconnect() end

		local sliderDragging = false
		local dragStartPosX = nil
		local startFillScale = 0

		sliderControl.InputBeganConnection = sliderControl.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				sliderDragging = true
				dragStartPosX = input.Position.X
				startFillScale = sliderFill.Size.X.Scale
			end
		end)

		sliderControl.InputChangedConnection = UserInputService.InputChanged:Connect(function(input)
			if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local deltaX = (input.Position.X - dragStartPosX) / sliderControl.AbsoluteSize.X
				local newScale = math.clamp(startFillScale + deltaX, 0, 1)
				sliderFill.Size = UDim2.fromScale(newScale, 1)

				local newSize = minSize + (maxSize - minSize) * newScale
				newSize = math.floor(newSize)
				sizeInputBox.Text = tostring(newSize)
				qtFrame.Size = UDim2.fromOffset(newSize, newSize)
				if qtFrame:GetAttribute("QuickToggleFlag") and ConfigManager then
					ConfigManager:SetFlag(qtFrame:GetAttribute("QuickToggleFlag") .. "_Size", {X = newSize, Y = newSize})
				end
			end
		end)

		sliderControl.InputEndedConnection = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				sliderDragging = false
			end
		end)

		sizeInputBox.FocusLostConnection = sizeInputBox.FocusLost:Connect(function(enterPressed)
			local newSize = tonumber(sizeInputBox.Text)
			if newSize then
				newSize = math.clamp(newSize, minSize, maxSize)
				qtFrame.Size = UDim2.fromOffset(newSize, newSize)
				updateFillFromValue(newSize)
				if qtFrame:GetAttribute("QuickToggleFlag") and ConfigManager then
					ConfigManager:SetFlag(qtFrame:GetAttribute("QuickToggleFlag") .. "_Size", {X = newSize, Y = newSize})
				end
			else
				sizeInputBox.Text = tostring(math.floor(qtFrame.Size.X.Offset))
			end
		end)

		GuiFunc.ResizePanel.Position = UDim2.new(
			qtFrame.Position.X.Scale, qtFrame.Position.X.Offset + qtFrame.AbsoluteSize.X / 2 - GuiFunc.ResizePanel.AbsoluteSize.X / 2,
			qtFrame.Position.Y.Scale, qtFrame.Position.Y.Offset + qtFrame.AbsoluteSize.Y + 10
		)

		local screenSiz = UBHubGui.AbsoluteSize
		local panelSiz = GuiFunc.ResizePanel.AbsoluteSize
		GuiFunc.ResizePanel.Position = UDim2.new(
			0, math.clamp(GuiFunc.ResizePanel.AbsolutePosition.X, 0, screenSiz.X - panelSiz.X),
			0, math.clamp(GuiFunc.ResizePanel.AbsolutePosition.Y, 0, screenSiz.Y - panelSiz.Y)
		)
		GuiFunc.ResizePanel.Visible = true
	end


	local DropShadowHolder = Instance.new("Frame");
	local DropShadow = Instance.new("ImageLabel");
	local Main = Instance.new("Frame");

	-- Overlays & Effects
	local SearchOverlay = Instance.new("Frame")
	SearchOverlay.Name = "SearchOverlay"
	SearchOverlay.Size = UDim2.fromScale(1, 1)
	SearchOverlay.Visible = false
	SearchOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	SearchOverlay.BackgroundTransparency = 0.3
	SearchOverlay.ZIndex = 50
	SearchOverlay.Parent = UBHubGui
	GuiFunc.SearchOverlay = SearchOverlay -- Store reference

	if game:GetService("Lighting"):FindFirstChild("UBHubBlur") then
		game:GetService("Lighting").UBHubBlur:Destroy()
	end
	local BlurEffect = Instance.new("BlurEffect")
	BlurEffect.Name = "UBHubBlur"
	BlurEffect.Enabled = false
	BlurEffect.Size = 12
	BlurEffect.Parent = game:GetService("Lighting")
	GuiFunc.BlurEffect = BlurEffect

	-- ResizePanel already created and stored in GuiFunc.ResizePanel

	-- Search UI Elements (to be parented to SearchOverlay later)
	local SearchInput = Instance.new("TextBox")
	SearchInput.Name = "SearchInput"
	SearchInput.Size = UDim2.new(1, -20, 0, 30)
	SearchInput.Position = UDim2.new(0.5, 0, 0, 10)
	SearchInput.AnchorPoint = Vector2.new(0.5, 0)
	SearchInput.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
	SearchInput.TextSize = 14
	SearchInput.TextColor3 = CurrentTheme.Colors.Text
	SearchInput.PlaceholderText = "Search for elements..."
	SearchInput.PlaceholderColor3 = CurrentTheme.Colors.TextDark
	SearchInput.BackgroundColor3 = CurrentTheme.Colors.BackgroundLight
	SearchInput.ClearTextOnFocus = false
	SearchInput.ZIndex = SearchOverlay.ZIndex + 1
	SearchInput.Parent = SearchOverlay -- Parented here for now
	local SearchInputCorner = Instance.new("UICorner")
	SearchInputCorner.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
	SearchInputCorner.Parent = SearchInput
	GuiFunc.SearchInput = SearchInput -- Store reference

	local ResultsScrollFrame = Instance.new("ScrollingFrame")
	ResultsScrollFrame.Name = "ResultsScrollFrame"
	ResultsScrollFrame.Size = UDim2.new(1, -20, 1, -50) -- Below input, leave space for input and padding
	ResultsScrollFrame.Position = UDim2.new(0.5, 0, 0, 45) -- Position below SearchInput
	ResultsScrollFrame.AnchorPoint = Vector2.new(0.5, 0)
	ResultsScrollFrame.BackgroundTransparency = 1
	ResultsScrollFrame.BorderSizePixel = 0
	ResultsScrollFrame.ScrollBarThickness = 6
	ResultsScrollFrame.ScrollBarImageColor3 = CurrentTheme.Colors.Stroke
	ResultsScrollFrame.ZIndex = SearchOverlay.ZIndex + 1
	ResultsScrollFrame.Parent = SearchOverlay -- Parented here for now
	local ResultsListLayout = Instance.new("UIListLayout")
	ResultsListLayout.Padding = UDim.new(0, 5)
	ResultsListLayout.SortOrder = Enum.SortOrder.LayoutOrder -- Will be overridden by score later
	ResultsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ResultsListLayout.Parent = ResultsScrollFrame
	GuiFunc.SearchResultsContainer = ResultsScrollFrame -- Store reference

	local function PerformSearch(query)
		query = query:lower()
		local results = {}

		if #query < 1 then -- Clear results if query is too short or empty
			for _, child in ipairs(GuiFunc.SearchResultsContainer:GetChildren()) do
				if child:IsA("GuiObject") and child ~= ResultsListLayout then
					child:Destroy()
				end
			end
			return
		end

		for _, element in ipairs(GuiFunc.SearchableElements) do
			local score = 0
			local titleLower = element.Title:lower()
			local contentLower = (element.Content or ""):lower()
			local tabNameLower = (element.TabName or ""):lower()
			local sectionNameLower = (element.SectionName or ""):lower()

			if titleLower == query then
				score = score + 100
			end
			if titleLower:find(query, 1, true) then
				score = score + 50
			end
			if contentLower:find(query, 1, true) then
				score = score + 20
			end
			if tabNameLower:find(query, 1, true) or sectionNameLower:find(query, 1, true) then
				score = score + 10
			end

			-- Word matching for more points
			for wordInQuery in query:gmatch("%S+") do
				if titleLower:find(wordInQuery, 1, true) then score = score + 5 end
				if contentLower:find(wordInQuery, 1, true) then score = score + 2 end
			end


			if score > 0 then
				table.insert(results, {Data = element, Score = score})
			end
		end

		table.sort(results, function(a, b)
			return a.Score > b.Score
		end)

		-- Clear previous results (excluding layout)
		for _, child in ipairs(GuiFunc.SearchResultsContainer:GetChildren()) do
			if child:IsA("GuiObject") and child ~= ResultsListLayout then
				child:Destroy()
			end
		end

		-- Animated display will be handled by another function called from here
		GuiFunc:DisplaySearchResults(results)
	end

	GuiFunc.DisplaySearchResults = function(results)
		-- Clear previous results (already done in PerformSearch, but good for standalone calls if any)
		for _, child in ipairs(GuiFunc.SearchResultsContainer:GetChildren()) do
			if child:IsA("GuiObject") and child ~= ResultsListLayout then
				child:Destroy()
			end
		end

		if #results == 0 and GuiFunc.SearchInput.Text ~= "" then
			local NoResultsLabel = Instance.new("TextLabel")
			NoResultsLabel.Name = "NoResultsLabel"
			NoResultsLabel.Size = UDim2.new(1, -10, 0, 30)
			NoResultsLabel.Text = "No results found."
			NoResultsLabel.Font = FontManager:GetFont(CurrentTheme.Fonts.Secondary)
			NoResultsLabel.TextColor3 = CurrentTheme.Colors.TextDark
			NoResultsLabel.TextSize = 14
			NoResultsLabel.BackgroundTransparency = 1
			NoResultsLabel.LayoutOrder = 1
			NoResultsLabel.Parent = GuiFunc.SearchResultsContainer
			return
		end

		local canvasHeight = 0
		for i, resultItem in ipairs(results) do
			local elementData = resultItem.Data

			local ResultButton = Instance.new("TextButton")
			ResultButton.Name = "SearchResult_" .. (elementData.Title or "Unnamed")
			ResultButton.Text = "" -- Using TextLabels inside for better layout
			ResultButton.Size = UDim2.new(1, -10, 0, 50) -- Fixed height for now, can be dynamic
			ResultButton.BackgroundColor3 = CurrentTheme.Colors.BackgroundLight
			ResultButton.BackgroundTransparency = 1 -- Start transparent for fade-in
			ResultButton.LayoutOrder = i
			ResultButton.Parent = GuiFunc.SearchResultsContainer

			local ResultCorner = Instance.new("UICorner")
			ResultCorner.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
			ResultCorner.Parent = ResultButton

			local ResultListLayout = Instance.new("UIListLayout")
			ResultListLayout.Padding = UDim.new(0,3)
			ResultListLayout.FillDirection = Enum.FillDirection.Vertical
			ResultListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			ResultListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			ResultListLayout.Parent = ResultButton

			local TitleLabel = Instance.new("TextLabel")
			TitleLabel.Name = "ResultTitle"
			TitleLabel.Text = elementData.Title
			TitleLabel.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
			TitleLabel.TextColor3 = CurrentTheme.Colors.Text
			TitleLabel.TextSize = 14
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Size = UDim2.new(1, -10, 0, 16)
			TitleLabel.Parent = ResultButton

			local InfoLabel = Instance.new("TextLabel")
			InfoLabel.Name = "ResultInfo"
			InfoLabel.Text = string.format("[%s] %s > %s", elementData.Type, elementData.TabName, elementData.SectionName)
			InfoLabel.Font = FontManager:GetFont(CurrentTheme.Fonts.Secondary)
			InfoLabel.TextColor3 = CurrentTheme.Colors.TextDark
			InfoLabel.TextSize = 11
			InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
			InfoLabel.BackgroundTransparency = 1
			InfoLabel.Size = UDim2.new(1, -10, 0, 13)
			InfoLabel.Parent = ResultButton

			ResultButton.Activated:Connect(function()
				if elementData.OpenFunction then
					elementData.OpenFunction()
				end
				-- Close search overlay
				local searchHighlightTargetTransparency = 0 -- Assuming this means "off"
				TweenService:Create(SearchHighlight, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				TweenService:Create(GuiFunc.SearchOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
				TweenService:Create(GuiFunc.BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
				task.delay(0.3, function()
					GuiFunc.SearchOverlay.Visible = false
					GuiFunc.BlurEffect.Enabled = false
					GuiFunc.SearchInput.Text = ""
					for _, child in ipairs(GuiFunc.SearchResultsContainer:GetChildren()) do
						if child:IsA("GuiObject") and child ~= ResultsListLayout then
							child:Destroy()
						end
					end
				end)
			end)

			-- Cascade fade-in animation
			task.spawn(function()
				task.wait((i - 1) * 0.05)
				ResultButton.BackgroundTransparency = 1
				TweenService:Create(ResultButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
			end)
			canvasHeight = canvasHeight + ResultButton.AbsoluteSize.Y + ResultsListLayout.Padding.Offset
		end
		GuiFunc.SearchResultsContainer.CanvasSize = UDim2.new(0,0,0, canvasHeight)
	end

	SearchInput.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			PerformSearch(SearchInput.Text)
		end
	end)

	SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
		PerformSearch(SearchInput.Text) -- Live search
	end)

	-- Make the SearchOverlay background click close the search
	SearchOverlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			-- Check if the click was directly on the SearchOverlay itself, not its children (like input or results)
			local clickedOnChild = false
			for _, child in ipairs(SearchOverlay:GetChildren()) do
				if input.Position.X >= child.AbsolutePosition.X and input.Position.X <= child.AbsolutePosition.X + child.AbsoluteSize.X and
				   input.Position.Y >= child.AbsolutePosition.Y and input.Position.Y <= child.AbsolutePosition.Y + child.AbsoluteSize.Y then
					clickedOnChild = true
					break
				end
			end

			if not clickedOnChild then
				-- Close search overlay (copied logic from SearchIconButton.Activated)
				local searchHighlightTargetTransparency = 0
				TweenService:Create(SearchHighlight, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				TweenService:Create(GuiFunc.SearchOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
				TweenService:Create(GuiFunc.BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
				task.delay(0.3, function()
					if not GuiFunc.SearchOverlay.Visible then return end
					GuiFunc.SearchOverlay.Visible = false
					GuiFunc.BlurEffect.Enabled = false
					GuiFunc.SearchInput.Text = ""
					for _, child_result in ipairs(GuiFunc.SearchResultsContainer:GetChildren()) do
						if child_result:IsA("GuiObject") and child_result ~= ResultsListLayout then
							child_result:Destroy()
						end
					end
				end)
			end
		end
	end)


	local UICorner = Instance.new("UICorner");
	local UIStroke = Instance.new("UIStroke");
	local Top = Instance.new("Frame");
	local TextLabel = Instance.new("TextLabel");
	local UICorner1 = Instance.new("UICorner");
	local TextLabel1 = Instance.new("TextLabel");
	local UIStroke1 = Instance.new("UIStroke");

	local Close = Instance.new("TextButton");
	local ImageLabel1 = Instance.new("ImageLabel");
	local Min = Instance.new("TextButton");
	local ImageLabel2 = Instance.new("ImageLabel");
	local LayersTab = Instance.new("Frame");
	local UICorner2 = Instance.new("UICorner");
	local DecideFrame = Instance.new("Frame");

	local Layers = Instance.new("Frame");
	local UICorner6 = Instance.new("UICorner");
	local NameTab = Instance.new("TextLabel");
	local LayersReal = Instance.new("Frame");
	local LayersFolder = Instance.new("Folder");
	local LayersPageLayout = Instance.new("UIPageLayout");

	UBHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	UBHubGui.Name = "UBHubGui"
	UBHubGui.Parent = CoreGui
	GuiFunc.WindowInstance = UBHubGui

	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.BackgroundColor3 = Color3.new(0, 0, 0)
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.ZIndex = 0
	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = UBHubGui
	DropShadowHolder.Size = SizeUI
    DropShadowHolder.Position = UDim2.new(0, (UBHubGui.AbsoluteSize.X / 2 - DropShadowHolder.Size.X.Offset / 2), 0, (UBHubGui.AbsoluteSize.Y / 2 - DropShadowHolder.Size.Y.Offset / 2))
    DropShadow.Image = "rbxassetid://6015897843" 
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
	Main.BackgroundColor3 = CurrentTheme.Colors.Background
	Main.BackgroundTransparency = 0.1
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = SizeUI
	Main.Name = "Main"
	Main.Parent = DropShadow

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
    BackgroundVideo.Playing = true 
	BackgroundVideo.Parent = Main
    local BGImage = false 
    local BGVideo = false 

	function ChangeAsset(type, input, name)
		local mediaFolder = "Asset"
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
			warn("There was an error loading the asset:", err)
			return
		end
		if type == "Image" then
			BackgroundImage.Image = asset or ""
			BackgroundVideo.Video = ""
			BGImage = asset ~= "" and asset ~= nil
            BGVideo = false
		elseif type == "Video" then
			BackgroundVideo.Video = asset or ""
			BackgroundImage.Image = ""
			BGVideo = asset ~= "" and asset ~= nil
            BGImage = false
            BackgroundVideo.Playing = BGVideo 
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
		BackgroundImage.ImageTransparency = Trans 
		BackgroundVideo.BackgroundTransparency = Trans 
	end
	UICorner.Parent = Main
    UICorner.CornerRadius = CurrentTheme.Sizes.LargeCornerRadius

	UIStroke.Color = Color3.fromRGB(50, 50, 50) -- Might make this CurrentTheme.Colors.Stroke or a darker variant
	UIStroke.Thickness = 1.600000023841858
	UIStroke.Parent = Main

	Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Top.BackgroundTransparency = 0.9990000128746033
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, CurrentTheme.Sizes.TitleBarHeight)
	Top.Name = "Top"
	Top.Parent = Main

	TextLabel.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
	TextLabel.Text = GuiConfig.NameHub
	TextLabel.TextColor3 = CurrentTheme.Colors.Accent
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.BackgroundColor3 = CurrentTheme.Colors.Accent
	TextLabel.BackgroundTransparency = 1 
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, -100, 1, 0)
	TextLabel.Position = UDim2.new(0, 10, 0, 0)
	TextLabel.Parent = Top

	UICorner1.Parent = Top
    UICorner1.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius

	TextLabel1.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
	TextLabel1.Text = GuiConfig.Description
	TextLabel1.TextColor3 = CurrentTheme.Colors.Text
	TextLabel1.TextSize = 14
	TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel1.BackgroundColor3 = CurrentTheme.Colors.Accent
	TextLabel1.BackgroundTransparency = 1 
	TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel1.BorderSizePixel = 0
	-- TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0) -- Adjusted below
	TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
	TextLabel1.Parent = Top

	UIStroke1.Color = GuiConfig.Color
	UIStroke1.Thickness = 0.4000000059604645
	UIStroke1.Parent = TextLabel1

	-- Make space for Search and Edit icons by adjusting TextLabel1 size and position if needed
	-- TextLabel1 might need to be shorter or these icons are to its right.
	-- Assuming icons are to the right of TextLabel1, before Min/Close.

	local searchIconSize = 18
	local editIconSize = 18
	local iconPadding = 8

	local SearchIconButton = Instance.new("ImageButton")
	SearchIconButton.Name = "SearchButton"
	SearchIconButton.BackgroundTransparency = 1
	SearchIconButton.Size = UDim2.fromOffset(searchIconSize, searchIconSize)
	-- Position will be before Min button. Let's calculate from the right edge of Top bar.
	-- Min button is at (1, -38), Close is at (1, -8). Icon width + padding.
	SearchIconButton.Position = UDim2.new(1, -(38 + searchIconSize + iconPadding), 0.5, 0)
	SearchIconButton.AnchorPoint = Vector2.new(1, 0.5)
	SearchIconButton.Parent = Top
	local searchIconInfo = ExternalIconManager.Icon("search", "lucide")
	if searchIconInfo then
		SearchIconButton.Image = searchIconInfo[1] -- Spritesheet URL
		local iconData = searchIconInfo[2]
		SearchIconButton.ImageRectOffset = iconData.ImageRectOffset
		SearchIconButton.ImageRectSize = iconData.ImageRectSize
	else
		SearchIconButton.Image = "rbxassetid://13087513584" -- Fallback search icon
		warn("Search icon 'search' (lucide) not found by ExternalIconManager.")
	end

	local SearchHighlight = Instance.new("Frame")
	SearchHighlight.Name = "SearchHighlight"
	SearchHighlight.Size = UDim2.fromOffset(searchIconSize + 8, searchIconSize + 8)
	SearchHighlight.AnchorPoint = Vector2.new(0.5, 0.5)
	SearchHighlight.Position = UDim2.fromScale(0.5, 0.5)
	SearchHighlight.BackgroundColor3 = CurrentTheme.Colors.ThemeHighlight
	SearchHighlight.BackgroundTransparency = 1 -- Initially hidden
	SearchHighlight.ZIndex = SearchIconButton.ZIndex -1
	SearchHighlight.Parent = SearchIconButton
	local SearchHighlightCorner = Instance.new("UICorner")
	SearchHighlightCorner.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
	SearchHighlightCorner.Parent = SearchHighlight

	local EditIconButton = Instance.new("ImageButton")
	EditIconButton.Name = "EditButton"
	EditIconButton.BackgroundTransparency = 1
	EditIconButton.Image = "rbxassetid://5595830746"
	EditIconButton.Size = UDim2.fromOffset(editIconSize, editIconSize)
	EditIconButton.Position = UDim2.new(1, -(38 + searchIconSize + iconPadding + editIconSize + iconPadding), 0.5, 0)
	EditIconButton.AnchorPoint = Vector2.new(1, 0.5)
	EditIconButton.Parent = Top

	local EditHighlight = Instance.new("Frame")
	EditHighlight.Name = "EditHighlight"
	EditHighlight.Size = UDim2.fromOffset(editIconSize + 8, editIconSize + 8)
	EditHighlight.AnchorPoint = Vector2.new(0.5, 0.5)
	EditHighlight.Position = UDim2.fromScale(0.5, 0.5)
	EditHighlight.BackgroundColor3 = CurrentTheme.Colors.ThemeHighlight
	EditHighlight.BackgroundTransparency = 1 -- Initially hidden
	EditHighlight.ZIndex = EditIconButton.ZIndex -1
	EditHighlight.Parent = EditIconButton
	local EditHighlightCorner = Instance.new("UICorner")
	EditHighlightCorner.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
	EditHighlightCorner.Parent = EditHighlight

	EditIconButton.Activated:Connect(function()
		GuiFunc.isEditMode = not GuiFunc.isEditMode
		GuiFunc:UpdateEditModeVisuals()
		local targetTransparency = GuiFunc.isEditMode and 0.6 or 1
		TweenService:Create(EditHighlight, TweenInfo.new(0.2), {BackgroundTransparency = targetTransparency}):Play()
	end)

	SearchIconButton.Activated:Connect(function()
		local isOpening = not GuiFunc.SearchOverlay.Visible
		local searchHighlightTargetTransparency = isOpening and 0.6 or 1
		TweenService:Create(SearchHighlight, TweenInfo.new(0.2), {BackgroundTransparency = searchHighlightTargetTransparency}):Play()

		if isOpening then
			GuiFunc.SearchOverlay.Visible = true
			GuiFunc.BlurEffect.Enabled = true
			GuiFunc.SearchOverlay.BackgroundTransparency = 1 -- Start transparent for fade-in
			TweenService:Create(GuiFunc.SearchOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.3}):Play()
			TweenService:Create(GuiFunc.BlurEffect, TweenInfo.new(0.3), {Size = 16}):Play()
			GuiFunc.SearchInput:CaptureFocus()
		else
			TweenService:Create(GuiFunc.SearchOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			TweenService:Create(GuiFunc.BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
			task.delay(0.3, function()
				if not GuiFunc.SearchOverlay.Visible then return end -- Check if it wasn't reopened
				GuiFunc.SearchOverlay.Visible = false
				GuiFunc.BlurEffect.Enabled = false
				GuiFunc.SearchInput.Text = "" -- Clear input when closing
				for _, child in ipairs(GuiFunc.SearchResultsContainer:GetChildren()) do
					if child:IsA("GuiObject") and child ~= ResultsListLayout then
						child:Destroy()
					end
				end
			end)
		end
	end)

	-- Adjust TextLabel1 to not overlap with new icons
	local totalIconWidth = (searchIconSize + iconPadding + editIconSize + iconPadding)
	TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 15 + totalIconWidth + 38 + 8 + 5), 1, 0) -- 38 for Min, 8 for Close, 5 for safety margin


	Close.Font = FontManager:GetFont("SourceSans")
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

	ImageLabel1.Image = "rbxassetid://9886659671"
	ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel1.BackgroundTransparency = 0.9990000128746033
	ImageLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel1.BorderSizePixel = 0
	ImageLabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
	ImageLabel1.Size = UDim2.new(1, -8, 1, -8)
	ImageLabel1.Parent = Close

	Min.Font = FontManager:GetFont("SourceSans")
	Min.Text = ""
	Min.TextColor3 = Color3.fromRGB(0, 0, 0)
	Min.TextSize = 14
	Min.AnchorPoint = Vector2.new(1, 0.5)
	Min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Min.BackgroundTransparency = 0.9990000128746033
	Min.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Min.BorderSizePixel = 0
	Min.Position = UDim2.new(1, -38, 0.5, 0) -- Adjusted position because MaxRestore is gone
	Min.Size = UDim2.new(0, 25, 0, 25)
	Min.Name = "Min"
	Min.Parent = Top

	ImageLabel2.Image = "rbxassetid://9886659276"
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
	LayersTab.Position = UDim2.new(0, CurrentTheme.Sizes.MainPadding, 0, 50)
	LayersTab.Size = UDim2.new(0, CurrentTheme.Sizes.TabWidth, 1, -(CurrentTheme.Sizes.TitleBarHeight + CurrentTheme.Sizes.MainPadding + 10)) -- Adjusted for clarity
	LayersTab.Name = "LayersTab"
	LayersTab.Parent = Main

	UICorner2.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
	UICorner2.Parent = LayersTab

	DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
	DecideFrame.BackgroundColor3 = CurrentTheme.Colors.Stroke
	DecideFrame.BackgroundTransparency = 0.5 
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
	Layers.Position = UDim2.new(0, CurrentTheme.Sizes.TabWidth + CurrentTheme.Sizes.MainPadding * 2, 0, 50)
	Layers.Size = UDim2.new(1, -(CurrentTheme.Sizes.TabWidth + CurrentTheme.Sizes.MainPadding * 2 + CurrentTheme.Sizes.MainPadding), 1, -(CurrentTheme.Sizes.TitleBarHeight + CurrentTheme.Sizes.MainPadding + 10))
	Layers.Name = "Layers"
	Layers.Parent = Main

	UICorner6.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
	UICorner6.Parent = Layers

	NameTab.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
	NameTab.Text = ""
	NameTab.TextColor3 = CurrentTheme.Colors.TextVeryLight
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
	ScrollTab.Size = UDim2.new(1, 0, 1, -CurrentTheme.Sizes.TabBottomSectionHeight)
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = LayersTab

	UIListLayout.Padding = CurrentTheme.Sizes.SectionItemPadding
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = ScrollTab

	local function UpdateSize1()
		local OffsetY = 0
		for _, child in ipairs(ScrollTab:GetChildren()) do
			if child:IsA("GuiObject") and child ~= UIListLayout then
				OffsetY = OffsetY + 3 + child.Size.Y.Offset
			end
		end
		ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
	end
	ScrollTab.ChildAdded:Connect(UpdateSize1)
	ScrollTab.ChildRemoved:Connect(UpdateSize1)

	local Info = Instance.new("Frame");
	local InfoUICorner = Instance.new("UICorner"); 
	local LogoPlayerFrame = Instance.new("Frame")
	local LogoPlayerFrameUICorner = Instance.new("UICorner"); 
	local LogoPlayer = Instance.new("ImageLabel");
	local LogoPlayerUICorner = Instance.new("UICorner"); 
	local NamePlayer = Instance.new("TextLabel");
		
	Info.AnchorPoint = Vector2.new(1, 1)
	Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Info.BackgroundTransparency = 0.95
	Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Info.BorderSizePixel = 0
	Info.Position = UDim2.new(1, 0, 1, 0)
	Info.Size = UDim2.new(1, 0, 0, CurrentTheme.Sizes.TabBottomSectionHeight)
	Info.Name = "Info"
	Info.Parent = LayersTab

	InfoUICorner.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
	InfoUICorner.Parent = Info

	LogoPlayerFrame.AnchorPoint = Vector2.new(0, 0.5)
	LogoPlayerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoPlayerFrame.BackgroundTransparency = 0.95
	LogoPlayerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoPlayerFrame.BorderSizePixel = 0
	LogoPlayerFrame.Position = UDim2.new(0, 5, 0.5, 0)
	LogoPlayerFrame.Size = UDim2.new(0, 30, 0, 30)
	LogoPlayerFrame.Name = "LogoPlayerFrame"
	LogoPlayerFrame.Parent = Info

	LogoPlayerFrameUICorner.CornerRadius = UDim.new(0, 1000)
	LogoPlayerFrameUICorner.Parent = LogoPlayerFrame

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

	LogoPlayerUICorner.CornerRadius = UDim.new(0, 1000)
	LogoPlayerUICorner.Parent = LogoPlayer

	NamePlayer.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
	NamePlayer.Text = GuiConfig["Name Player"]
	NamePlayer.TextColor3 = CurrentTheme.Colors.TextLight
	NamePlayer.TextSize = 12
	NamePlayer.TextWrapped = true
	NamePlayer.TextXAlignment = Enum.TextXAlignment.Left
	NamePlayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NamePlayer.BackgroundTransparency = 0.9990000128746033
	NamePlayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NamePlayer.BorderSizePixel = 0
	NamePlayer.Position = UDim2.new(0, 40, 0, 0)
	NamePlayer.Size = UDim2.new(1, -45, 1, 0)
	NamePlayer.Name = "NamePlayer"
	NamePlayer.Parent = Info

	function GuiFunc:DestroyGui()
		if CoreGui:FindFirstChild("UBHubGui") then 
			UBHubGui:Destroy()
		end
        local openCloseGui = CoreGui:FindFirstChild("OpenClose") or (LocalPlayer.PlayerGui:FindFirstChild("OpenClose"))
        if openCloseGui then
            openCloseGui:Destroy()
        end
	end
	local OldPos = DropShadowHolder.Position
	local OldSize = DropShadowHolder.Size
	local MinimizedIcon = Instance.new("ImageButton")
	local ScreenGui = Instance.new("ScreenGui")
	do
		ProtectGui(ScreenGui)
	end
	ScreenGui.Name = "OpenClose"
	ScreenGui.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or (gethui and gethui()) or CoreGui 
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	MinimizedIcon.Image = _G.MinIcon or "rbxassetid://94513440833543"
	MinimizedIcon.Size = UDim2.new(0, 55, 0, 50)
	MinimizedIcon.Position = UDim2.new(0.1021, 0, 0.0743, 0)
	MinimizedIcon.BackgroundTransparency = 1 
    MinimizedIcon.BackgroundColor3 = CurrentTheme.Colors.ThemeHighlight
	MinimizedIcon.Parent = ScreenGui
	MinimizedIcon.Draggable = true
	MinimizedIcon.Visible = false
	MinimizedIcon.BorderColor3 = CurrentTheme.Colors.ThemeHighlight
	Min.Activated:Connect(function()
		CircleClick(Min, Mouse.X, Mouse.Y)
		DropShadowHolder.Visible = false
        MinimizedIcon.Visible = true
	end)

	MinimizedIcon.MouseButton1Click:Connect(function()
		DropShadowHolder.Visible = true
		MinimizedIcon.Visible = false
	end)

	Close.Activated:Connect(function()
		CircleClick(Close, Mouse.X, Mouse.Y)
		GuiFunc:DestroyGui()
	end)
	function GuiFunc:ToggleUI()
        if UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
             game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
        else
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
            task.wait() 
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
        end
	end
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.RightShift then
			if DropShadowHolder.Visible then
				DropShadowHolder.Visible = false
                MinimizedIcon.Visible = true 
			else
				DropShadowHolder.Visible = true
                MinimizedIcon.Visible = false 
			end
		end
	end)
	DropShadowHolder.Size = UDim2.new(0, 150 + TextLabel.TextBounds.X + 1 + (TextLabel1.Text and TextLabel1.TextBounds.X or 0), 0, 450)
	MakeDraggable(Top, DropShadowHolder)

	GuiFunc.ApplyThemeStyleHints = function()
		if not CurrentTheme then return end -- Should always exist but good check

		Main.BackgroundColor3 = GetColor("Background")
		if Top then -- Title bar frame
			-- Top is mostly transparent, but its children are what matter
			local titleText = Top:FindFirstChild("TextLabel") -- The main title
			if titleText then titleText.TextColor3 = GetColor("Accent") end

			local descriptionText = Top:FindFirstChild("TextLabel1") -- The description
			if descriptionText then descriptionText.TextColor3 = GetColor("Text") end
		end

		-- Update section underlines as their gradient uses Primary and Accent (GuiConfig.Color)
		-- This requires iterating through all sections, which is complex here.
		-- A full theme apply would do this. This is just for global hints.
		-- For now, section underlines will update when their specific tab is re-rendered or section toggled.
	end

	GuiFunc.UpdateEditModeVisuals = function()
		local targetTransparency = GuiFunc.isEditMode and 0.6 or 1
		TweenService:Create(EditHighlight, TweenInfo.new(0.2), {BackgroundTransparency = targetTransparency}):Play()

		if GuiFunc.isEditMode then
			GuiFunc.BlurEffect.Enabled = true
			TweenService:Create(GuiFunc.BlurEffect, TweenInfo.new(0.3), {Size = 16}):Play()

			for flag, qtInstance in pairs(GuiFunc.ActiveQuickToggles) do
				if qtInstance and qtInstance.Frame and qtInstance.Frame.Parent then
					qtInstance.Frame.Draggable = true
					qtInstance.Frame.BorderSizePixel = 1
					qtInstance.Frame.BorderColor3 = CurrentTheme.Colors.ThemeHighlight
				end
			end
		else
			TweenService:Create(GuiFunc.BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
			task.delay(0.3, function()
				if not GuiFunc.isEditMode then
					GuiFunc.BlurEffect.Enabled = false
				end
			end)

			for flag, qtInstance in pairs(GuiFunc.ActiveQuickToggles) do
				if qtInstance and qtInstance.Frame and qtInstance.Frame.Parent then
					qtInstance.Frame.Draggable = false
					qtInstance.Frame.BorderSizePixel = 0

					local posData = {X = qtInstance.Frame.Position.X.Offset, Y = qtInstance.Frame.Position.Y.Offset}
					local sizeData = {X = qtInstance.Frame.Size.X.Offset, Y = qtInstance.Frame.Size.Y.Offset}
					ConfigManager:SetFlag(flag .. "_Pos", posData)
					ConfigManager:SetFlag(flag .. "_Size", sizeData)
				end
			end
			if GuiFunc.CurrentlyEditingQuickToggle then
				GuiFunc.ResizePanel.Visible = false
				GuiFunc.CurrentlyEditingQuickToggle = nil
			end
		end
	end

	--// Blur
	local MoreBlur = Instance.new("Frame");
	local DropShadowHolder1 = Instance.new("Frame");
	local DropShadow1 = Instance.new("ImageLabel");
	local UICorner28 = Instance.new("UICorner");
	local ConnectButton = Instance.new("TextButton");
	
	MoreBlur.AnchorPoint = Vector2.new(1, 1)
	MoreBlur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MoreBlur.BackgroundTransparency = 0.999
	MoreBlur.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MoreBlur.BorderSizePixel = 0
	MoreBlur.ClipsDescendants = true
	MoreBlur.Position = UDim2.new(1, 8, 1, 8)
	MoreBlur.Size = UDim2.new(1, 154, 1, 54)
	MoreBlur.Visible = false
	MoreBlur.Name = "MoreBlur"
	MoreBlur.Parent = Layers

	DropShadowHolder1.BackgroundTransparency = 1
	DropShadowHolder1.BorderSizePixel = 0
	DropShadowHolder1.Size = UDim2.new(1, 0, 1, 0)
	DropShadowHolder1.ZIndex = 0
	DropShadowHolder1.Name = "DropShadowHolder"
	DropShadowHolder1.Parent = MoreBlur
	DropShadowHolder1.Visible = false 

	DropShadow1.Image = "rbxassetid://6015897843"
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
    UICorner28.CornerRadius = CurrentTheme.Sizes.LargeCornerRadius

	ConnectButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Secondary)
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
	DropdownSelect.BackgroundColor3 = CurrentTheme.Colors.Primary
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
	UICorner36.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
	UICorner36.Parent = DropdownSelect

	UIStroke14.Color = CurrentTheme.Colors.TextVeryLight
	UIStroke14.Thickness = 2.5
	UIStroke14.Transparency = 0.8
	UIStroke14.Parent = DropdownSelect

	DropdownSelectReal.AnchorPoint = Vector2.new(0.5, 0.5)
	DropdownSelectReal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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
	local Tabs = {}
	local CountTab = 0
	local CountDropdown = 0

	function Tabs:AddTabDivider()
		local Divider = Instance.new("Frame")
		Divider.Name = "TabDivider"
		Divider.Size = UDim2.new(1, -10, 0, 1) -- Full width minus some padding, 1px height
		Divider.BackgroundColor3 = CurrentTheme.Colors.Stroke
		Divider.BackgroundTransparency = 0.5
		Divider.BorderSizePixel = 0
		Divider.LayoutOrder = CountTab + 0.5 -- Try to place it between tabs
		Divider.Parent = ScrollTab -- Parent to the scrollable tab container
		-- Relies on UIListLayout in ScrollTab
		CountTab = CountTab + 1 -- Increment to ensure subsequent tabs/dividers have unique layout orders
	end

	-- Container for static tabs, will be placed at the bottom of LayersTab
	local StaticTabsContainer = Instance.new("Frame")
	StaticTabsContainer.Name = "StaticTabsContainer"
	StaticTabsContainer.BackgroundTransparency = 1
	StaticTabsContainer.Size = UDim2.new(1, 0, 0, 0) -- Auto-sizes with UIListLayout
	StaticTabsContainer.LayoutOrder = 2 -- Ensure it's below ScrollTab (LayoutOrder 0 or 1)
	StaticTabsContainer.Parent = LayersTab -- Parent to the main left panel for tabs

	local StaticTabsLayout = Instance.new("UIListLayout")
	StaticTabsLayout.FillDirection = Enum.FillDirection.Vertical
	StaticTabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	StaticTabsLayout.Padding = CurrentTheme.Sizes.SectionItemPadding
	StaticTabsLayout.Parent = StaticTabsContainer

	-- Adjust ScrollTab size to make space for StaticTabsContainer if it has children
	local function AdjustScrollTabSize()
		local staticTabsHeight = StaticTabsContainer.AbsoluteSize.Y
		if staticTabsHeight > 0 then
			ScrollTab.Size = UDim2.new(1,0,1, -(CurrentTheme.Sizes.TabBottomSectionHeight + staticTabsHeight + StaticTabsLayout.Padding.Offset))
		else
			ScrollTab.Size = UDim2.new(1,0,1, -CurrentTheme.Sizes.TabBottomSectionHeight)
		end
	end
	StaticTabsContainer.ChildAdded:Connect(AdjustScrollTabSize)
	StaticTabsContainer.ChildRemoved:Connect(AdjustScrollTabSize)
    StaticTabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(AdjustScrollTabSize)


	function Tabs:CreateTab(TabConfig)
		local TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.IconName = TabConfig.IconName or nil -- e.g., "home"
		TabConfig.IconLibrary = TabConfig.IconLibrary or "lucide" -- Default to lucide

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

		UICorner3.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
		UICorner3.Parent = Tab

		TabButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
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

		TabName.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
		TabName.Text = TabConfig.Name
		TabName.TextColor3 = CurrentTheme.Colors.TextVeryLight
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

		if TabConfig.IconName then
			local iconInfo = ExternalIconManager.Icon(TabConfig.IconName, TabConfig.IconLibrary)
			if iconInfo then
				FeatureImg.Image = iconInfo[1]
				local iconData = iconInfo[2]
				FeatureImg.ImageRectOffset = iconData.ImageRectOffset
				FeatureImg.ImageRectSize = iconData.ImageRectSize
			else
				warn("Tab icon '" .. TabConfig.IconName .. "' (" .. TabConfig.IconLibrary .. ") not found.")
				FeatureImg.Visible = false
			end
		else
			FeatureImg.Visible = false
		end
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
			ChooseFrame.BackgroundColor3 = CurrentTheme.Colors.ThemeHighlight
			ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ChooseFrame.BorderSizePixel = 0
			ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
			ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
			ChooseFrame.Name = "ChooseFrame"
			ChooseFrame.Parent = Tab

			UIStroke2.Color = GuiConfig.Color
			UIStroke2.Thickness = 1.600000023841858
			UIStroke2.Parent = ChooseFrame

			UICorner4.Parent = ChooseFrame
            UICorner4.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
		end
		TabButton.Activated:Connect(function()
			CircleClick(TabButton, Mouse.X, Mouse.Y)
			local FrameChoose
			for _, s in ipairs(ScrollTab:GetChildren()) do
                if s:IsA("Frame") and s.Name == "Tab" then -- Ensure it is a tab frame
				    for _, v in ipairs(s:GetChildren()) do
					    if v.Name == "ChooseFrame" then
						    FrameChoose = v
						    break
					    end
				    end
                end
                if FrameChoose then break end
			end
			if FrameChoose ~= nil and Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
				for _, TabFrame in ipairs(ScrollTab:GetChildren()) do
					if TabFrame.Name == "Tab" then
						TweenService:Create(TabFrame,TweenInfo.new(0.001, Enum.EasingStyle.Linear),{BackgroundTransparency = 0.9990000128746033}):Play()
						local cf = TabFrame:FindFirstChild("ChooseFrame")
						if cf then cf.Visible = false; cf.Size = UDim2.new(0,1,0,12) end -- Hide and reset others
					end    
				end
				TweenService:Create(Tab, TweenInfo.new(0.001, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.92}):Play()
				FrameChoose.Parent = Tab -- Ensure it's on the correct tab
				FrameChoose.Visible = true
				FrameChoose:TweenSize(UDim2.new(0,1,0,20), "Out", "Quad", 0.1)

				LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
				NameTab.Text = TabConfig.Name
			end
		end)
		--// Section 
		local Sections = {}
		local CountSection = 0
		function Sections:AddSection(Title)
			local Title = Title or "Title"
			local Section = Instance.new("Frame");
			local SectionDecideFrame = Instance.new("Frame");
			local UICorner1_Section = Instance.new("UICorner"); 
			local UIGradient = Instance.new("UIGradient");

			Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Section.BackgroundTransparency = 0.9990000128746033
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.LayoutOrder = CountSection
			Section.ClipsDescendants = true
			Section.Size = UDim2.new(1, 0, 0, 30)
			Section.Name = "Section"
			Section.Parent = ScrolLayers

			local SectionReal = Instance.new("Frame");
			local UICorner_SectionReal = Instance.new("UICorner"); 
			-- local UIStroke_SectionReal = Instance.new("UIStroke"); -- Seems unused
			local SectionButton = Instance.new("TextButton");
			local FeatureFrame = Instance.new("Frame");
			local FeatureImg_Section = Instance.new("ImageLabel"); 
			local SectionTitle = Instance.new("TextLabel");

			SectionReal.AnchorPoint = Vector2.new(0.5, 0)
			SectionReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionReal.BackgroundTransparency = 0.9350000023841858
			SectionReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionReal.BorderSizePixel = 0
			SectionReal.LayoutOrder = 1
			SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
			SectionReal.Size = UDim2.new(1, 1, 0, 30)
			SectionReal.Name = "SectionReal"
			SectionReal.Parent = Section

			UICorner_SectionReal.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
			UICorner_SectionReal.Parent = SectionReal

			SectionButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Secondary)
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

			FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
			FeatureFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			FeatureFrame.BackgroundTransparency = 0.9990000128746033
			FeatureFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureFrame.BorderSizePixel = 0
			FeatureFrame.Position = UDim2.new(1, -5, 0.5, 0)
			FeatureFrame.Size = UDim2.new(0, 20, 0, 20)
			FeatureFrame.Name = "FeatureFrame"
			FeatureFrame.Parent = SectionReal

			FeatureImg_Section.Image = "rbxassetid://16851841101"
			FeatureImg_Section.AnchorPoint = Vector2.new(0.5, 0.5)
			FeatureImg_Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeatureImg_Section.BackgroundTransparency = 0.9990000128746033
			FeatureImg_Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureImg_Section.BorderSizePixel = 0
			FeatureImg_Section.Position = UDim2.new(0.5, 0, 0.5, 0)
			FeatureImg_Section.Rotation = -90
			FeatureImg_Section.Size = UDim2.new(1, 6, 1, 6)
			FeatureImg_Section.Name = "FeatureImg"
			FeatureImg_Section.Parent = FeatureFrame

			SectionTitle.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
			SectionTitle.Text = Title
			SectionTitle.TextColor3 = CurrentTheme.Colors.TextLight
			SectionTitle.TextSize = 13
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.TextYAlignment = Enum.TextYAlignment.Top
			SectionTitle.AnchorPoint = Vector2.new(0, 0.5)
			SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.BackgroundTransparency = 0.9990000128746033
			SectionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionTitle.BorderSizePixel = 0
			SectionTitle.Position = UDim2.new(0, 10, 0.5, 0)
			SectionTitle.Size = UDim2.new(1, -50, 0, 13)
			SectionTitle.Name = "SectionTitle"
			SectionTitle.Parent = SectionReal

			SectionDecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionDecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionDecideFrame.AnchorPoint = Vector2.new(0.5, 0)
			SectionDecideFrame.BorderSizePixel = 0
			SectionDecideFrame.Position = UDim2.new(0.5, 0, 0, 33)
			SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
			SectionDecideFrame.Name = "SectionDecideFrame"
			SectionDecideFrame.Parent = Section

			UICorner1_Section.Parent = SectionDecideFrame
            UICorner1_Section.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius

			UIGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, CurrentTheme.Colors.Primary),
				ColorSequenceKeypoint.new(0.5, GuiConfig.Color), -- GuiConfig.Color might need to become CurrentTheme.Colors.Accent or similar
				ColorSequenceKeypoint.new(1, CurrentTheme.Colors.Primary)
			}
			UIGradient.Parent = SectionDecideFrame
			--// Section Add
			local SectionAdd = Instance.new("Frame");
			local UICorner8 = Instance.new("UICorner");
			local UIListLayout2 = Instance.new("UIListLayout");

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
			SectionAdd.Parent = Section

			UICorner8.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
			UICorner8.Parent = SectionAdd

			UIListLayout2.Padding = CurrentTheme.Sizes.SectionItemPadding
			UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout2.Parent = SectionAdd
			local OpenSection = true
			local function UpdateSizeScroll()
				task.wait() 
				local totalHeight = 0
				for _, child in ipairs(ScrolLayers:GetChildren()) do
					if child:IsA("Frame") and child ~= UIListLayout1 then 
						totalHeight += child.AbsoluteSize.Y + UIListLayout1.Padding.Offset
					end
				end
				ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
			end
            local isUpdatingSectionSize = false
			local function UpdateSizeSection()
                if isUpdatingSectionSize then return end
                isUpdatingSectionSize = true
                task.wait() 

				if OpenSection then
					local contentHeight = UIListLayout2.AbsoluteContentSize.Y
					local newHeight = 38 + contentHeight + (contentHeight > 0 and 3 or 0) 
					newHeight = math.max(newHeight, 30) 

					TweenService:Create(FeatureImg_Section, TweenInfo.new(0.3), {Rotation = -90}):Play()
					TweenService:Create(Section, TweenInfo.new(0.3), {Size = UDim2.new(1, 1, 0, newHeight)}):Play()
					TweenService:Create(SectionAdd, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, contentHeight)}):Play()
					TweenService:Create(SectionDecideFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 2)}):Play()
				else
					TweenService:Create(FeatureImg_Section, TweenInfo.new(0.3), {Rotation = 0}):Play()
					TweenService:Create(Section, TweenInfo.new(0.3), {Size = UDim2.new(1, 1, 0, 30)}):Play()
					TweenService:Create(SectionAdd, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
					TweenService:Create(SectionDecideFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 2)}):Play()
				end
                task.delay(0.3, function() 
                    isUpdatingSectionSize = false
                    UpdateSizeScroll()
                end)
			end
			SectionButton.Activated:Connect(function()
				CircleClick(SectionButton, Mouse.X, Mouse.Y)
				OpenSection = not OpenSection
                SectionAdd.Visible = true 
				UpdateSizeSection()
                if not OpenSection then
                    task.delay(0.3, function() SectionAdd.Visible = false end) 
                end
			end)
			SectionAdd.ChildAdded:Connect(UpdateSizeSection)
			SectionAdd.ChildRemoved:Connect(UpdateSizeSection)
            UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSizeSection) 
			UpdateSizeSection() 
			
			local Items = {}
			local CountItem = 0
            function Items:AddDivider(DividerConfig)
                DividerConfig = DividerConfig or {}
                local text = DividerConfig.Text or DividerConfig.Title or ""
                local thickness = DividerConfig.Thickness or 1
                local vPadding = DividerConfig.VerticalPadding or 5 -- Default vertical padding for text
                local lineColor = DividerConfig.Color or CurrentTheme.Colors.Accent
                local textColor = DividerConfig.TextColor or CurrentTheme.Colors.Text
                local textSize = DividerConfig.TextSize or 12
                local lineEndsPadding = DividerConfig.LineEndsPadding or 10
                local textToLineSpacing = DividerConfig.TextToLineSpacing or 5

                local DivParent = Instance.new("Frame")
                DivParent.Name = "DividerContainer"
                DivParent.BackgroundTransparency = 1
                DivParent.Size = UDim2.new(1, 0, 0, thickness + vPadding * 2)
                DivParent.LayoutOrder = CountItem
                DivParent.Parent = SectionAdd
                
                if text ~= "" then
                    local DividerText = Instance.new("TextLabel")
                    DividerText.Name = "DividerText"
                    DividerText.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
                    DividerText.Text = "- [ " .. text .. " ] -"
                    DividerText.TextColor3 = textColor
                    DividerText.TextSize = textSize
                    DividerText.TextXAlignment = Enum.TextXAlignment.Center
                    DividerText.TextYAlignment = Enum.TextYAlignment.Center
                    DividerText.BackgroundTransparency = 1
                    DividerText.Size = UDim2.new(1, 0, 1, 0)
                    DividerText.Position = UDim2.new(0.5, 0, 0.5, 0)
                    DividerText.AnchorPoint = Vector2.new(0.5, 0.5)
                    DividerText.Parent = DivParent
                    DivParent.Size = UDim2.new(1,0,0, DividerText.TextBounds.Y + vPadding * 2)
                else
                    local DividerLine = Instance.new("Frame")
                    DividerLine.Name = "DividerLine"
                    DividerLine.BackgroundColor3 = lineColor
                    DividerLine.BorderSizePixel = 0
                    DividerLine.Size = UDim2.new(1, -lineEndsPadding * 2, 0, thickness)
                    DividerLine.Position = UDim2.new(0, lineEndsPadding, 0.5, 0)
                    DividerLine.AnchorPoint = Vector2.new(0, 0.5)
                    DividerLine.Parent = DivParent
                end

                CountItem = CountItem + 1
            end
			function Items:AddParagraph(ParagraphConfig)
				local ParagraphConfig = ParagraphConfig or {}
				ParagraphConfig.Title = ParagraphConfig.Title or "Title"
				ParagraphConfig.Content = ParagraphConfig.Content or "Content"
				ParagraphConfig.IconName = ParagraphConfig.IconName or nil -- Was ParagraphConfig.Image
				ParagraphConfig.IconLibrary = ParagraphConfig.IconLibrary or "lucide"
				ParagraphConfig.ImageSize = ParagraphConfig.ImageSize or UDim2.fromOffset(24, 24) -- Remains for sizing the ImageLabel
				ParagraphConfig.Buttons = ParagraphConfig.Buttons or {} -- Table of {Text, Callback, Variant}
				ParagraphConfig.Dependency = ParagraphConfig.Dependency or nil
				local ParagraphFunc = {} -- No specific value/changed event for simple paragraph
				
				local Paragraph = Instance.new("Frame");
				local currentTabNameForSearch = NameTab.Text -- Capture at time of creation
				local currentSectionNameForSearch = Title -- Capture at time of creation
				local currentTabPageInstanceForSearch = ScrolLayers -- Capture at time of creation
				Paragraph.Name = "Paragraph"
				Paragraph.BackgroundTransparency = 1 -- Main frame is a container
				Paragraph.BorderSizePixel = 0
				Paragraph.LayoutOrder = CountItem
				Paragraph.Size = UDim2.new(1, 0, 0, 10) -- Initial small height, will be auto-sized by UIListLayout
				Paragraph.Parent = SectionAdd

				local ParagraphListLayout = Instance.new("UIListLayout")
				ParagraphListLayout.FillDirection = Enum.FillDirection.Vertical
				ParagraphListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ParagraphListLayout.Padding = UDim.new(0, 5) -- Padding between text/image area and buttons area
				ParagraphListLayout.Parent = Paragraph

				-- Frame for Text and optional Image
				local TextImageFrame = Instance.new("Frame")
				TextImageFrame.Name = "TextImageFrame"
				TextImageFrame.BackgroundTransparency = 1
				TextImageFrame.Size = UDim2.new(1,0,0,10) -- Will auto-size
				TextImageFrame.LayoutOrder = 1
				TextImageFrame.Parent = Paragraph
				local TextImageListLayout = Instance.new("UIListLayout")
				TextImageListLayout.FillDirection = Enum.FillDirection.Horizontal
				TextImageListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
				TextImageListLayout.Padding = UDim.new(0,5)
				TextImageListLayout.Parent = TextImageFrame

				local ParagraphImageLabel
				if ParagraphConfig.IconName then
					ParagraphImageLabel = Instance.new("ImageLabel")
					ParagraphImageLabel.Name = "ParagraphImage"

					local iconInfo = ExternalIconManager.Icon(ParagraphConfig.IconName, ParagraphConfig.IconLibrary)
					if iconInfo then
						ParagraphImageLabel.Image = iconInfo[1]
						local iconData = iconInfo[2]
						ParagraphImageLabel.ImageRectOffset = iconData.ImageRectOffset
						ParagraphImageLabel.ImageRectSize = iconData.ImageRectSize
					else
						warn("Paragraph icon '" .. ParagraphConfig.IconName .. "' (" .. ParagraphConfig.IconLibrary .. ") not found.")
						-- ImageLabel will be there but possibly without a visible image
					end

					ParagraphImageLabel.Size = ParagraphConfig.ImageSize
					ParagraphImageLabel.BackgroundTransparency = 1
					ParagraphImageLabel.LayoutOrder = 1
					ParagraphImageLabel.Parent = TextImageFrame
				end

				local ParagraphText = Instance.new("TextLabel");
				ParagraphText.Name = "ParagraphText"
				ParagraphText.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				ParagraphText.Text = ParagraphConfig.Title .. " | " .. ParagraphConfig.Content
				ParagraphText.TextColor3 = CurrentTheme.Colors.TextLight
				ParagraphText.TextSize = 13
                ParagraphText.TextWrapped = true
				ParagraphText.TextXAlignment = Enum.TextXAlignment.Left
				ParagraphText.TextYAlignment = Enum.TextYAlignment.Top
				ParagraphText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ParagraphText.BackgroundTransparency = 1
				ParagraphText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ParagraphText.BorderSizePixel = 0
				ParagraphText.Size = UDim2.new(1, ParagraphImageLabel and -(ParagraphConfig.ImageSize.X.Offset + 10) or -5, 0, 0)
				ParagraphText.AutomaticSize = Enum.AutomaticSize.Y
				ParagraphText.LayoutOrder = 2
				ParagraphText.Parent = TextImageFrame
				
				local ButtonsFrame
				if #ParagraphConfig.Buttons > 0 then
					ButtonsFrame = Instance.new("Frame")
					ButtonsFrame.Name = "ButtonsFrame"
					ButtonsFrame.BackgroundTransparency = 1
					ButtonsFrame.Size = UDim2.new(1,0,0,30)
					ButtonsFrame.LayoutOrder = 2
					ButtonsFrame.Parent = Paragraph

					local ButtonsListLayout = Instance.new("UIListLayout")
					ButtonsListLayout.FillDirection = Enum.FillDirection.Horizontal
					ButtonsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
					ButtonsListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
					ButtonsListLayout.Padding = UDim.new(0, 5)
					ButtonsListLayout.Parent = ButtonsFrame

					for i, btnConfig in ipairs(ParagraphConfig.Buttons) do
						local ParaButton = Instance.new("TextButton")
						ParaButton.Name = "ParagraphButton" .. i
						ParaButton.Text = btnConfig.Text or "Button"
						ParaButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Secondary)
						ParaButton.TextSize = 12
						ParaButton.TextColor3 = CurrentTheme.Colors.Text
						ParaButton.BackgroundColor3 = btnConfig.Variant == "Primary" and CurrentTheme.Colors.Accent or CurrentTheme.Colors.Secondary
						ParaButton.Size = UDim2.new(0,0,0,24)
						ParaButton.AutomaticSize = Enum.AutomaticSize.X
						ParaButton.PaddingLeft = UDim.new(0,8)
						ParaButton.PaddingRight = UDim.new(0,8)
						ParaButton.Parent = ButtonsFrame

						local UICorner_ParaBtn = Instance.new("UICorner")
						UICorner_ParaBtn.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
						UICorner_ParaBtn.Parent = ParaButton

						if btnConfig.Callback and type(btnConfig.Callback) == "function" then
							ParaButton.Activated:Connect(btnConfig.Callback)
						end
					end
				end

                task.wait()
                UpdateSizeSection()


				function ParagraphFunc:Set(NewParagraphConfig) 
					NewParagraphConfig = NewParagraphConfig or {}
					ParagraphConfig.Title = NewParagraphConfig.Title or ParagraphConfig.Title 
					ParagraphConfig.Content = NewParagraphConfig.Content or ParagraphConfig.Content
					ParagraphText.Text = ParagraphConfig.Title .. " | " .. ParagraphConfig.Content
                    -- TODO: Handle image and button updates if needed for :Set()
                    task.wait()
                    UpdateSizeSection()
				end

				if ParagraphConfig.Dependency then
					HandleDependency(Paragraph, ParagraphConfig.Dependency, UpdateSizeSection, ParagraphText, ParagraphFunc)
				end

				table.insert(GuiFunc.SearchableElements, {
					Title = ParagraphConfig.Title,
					Content = ParagraphConfig.Content,
					Type = "Paragraph",
					UIInstance = Paragraph,
					SectionName = currentSectionNameForSearch,
					TabName = currentTabNameForSearch,
					OpenFunction = function()
						if LayersPageLayout.CurrentPage ~= currentTabPageInstanceForSearch then
							LayersPageLayout:JumpTo(currentTabPageInstanceForSearch)
						end
						NameTab.Text = currentTabNameForSearch
						-- Ensure section is open (if applicable, paragraphs don't live in collapsible sections directly)
						-- Scroll to element if possible
						ScrolLayers.CanvasPosition = Vector2.new(0, Paragraph.AbsolutePosition.Y - ScrolLayers.AbsolutePosition.Y)
					end
				})

				CountItem = CountItem + 1
				return ParagraphFunc
			end
			function Items:AddButton(ButtonConfig)
				local ButtonConfig = ButtonConfig or {}
				ButtonConfig.Title = ButtonConfig.Title or "Title"
				ButtonConfig.Content = ButtonConfig.Content or "Content"
				ButtonConfig.IconName = ButtonConfig.IconName or nil -- Was ButtonConfig.Icon
				ButtonConfig.IconLibrary = ButtonConfig.IconLibrary or "lucide"
				ButtonConfig.Callback = ButtonConfig.Callback or function() end
				ButtonConfig.Dependency = ButtonConfig.Dependency or nil
				local ButtonFunc = {}

				local Button = Instance.new("Frame");
				local currentTabNameForSearch = NameTab.Text
				local currentSectionNameForSearch = Title
				local currentTabPageInstanceForSearch = ScrolLayers
				local currentSectionInstanceForSearch = Section
				local UICorner9 = Instance.new("UICorner");
				local ButtonTitle = Instance.new("TextLabel");
				local ButtonContent = Instance.new("TextLabel");
				local ButtonButton = Instance.new("TextButton");
				local FeatureFrame1 = Instance.new("Frame");
				local FeatureImg3 = Instance.new("ImageLabel");

				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.BackgroundTransparency = 0.9350000023841858
				Button.BorderColor3 = CurrentTheme.Colors.Secondary
				Button.BorderSizePixel = 0
				Button.LayoutOrder = CountItem
				Button.Size = UDim2.new(1, 0, 0, 46)
				Button.Name = "Button"
				Button.Parent = SectionAdd

				UICorner9.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
				UICorner9.Parent = Button

				ButtonTitle.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				ButtonTitle.Text = ButtonConfig.Title
				ButtonTitle.TextColor3 = CurrentTheme.Colors.TextLight
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
				ButtonTitle.Parent = Button

				ButtonContent.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				ButtonContent.Text = ButtonConfig.Content
				ButtonContent.TextColor3 = CurrentTheme.Colors.TextVeryLight
				ButtonContent.TextSize = 12
				ButtonContent.TextTransparency = 0.6000000238418579
				ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
				ButtonContent.TextYAlignment = Enum.TextYAlignment.Bottom
                ButtonContent.TextWrapped = true
				ButtonContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonContent.BackgroundTransparency = 0.9990000128746033
				ButtonContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonContent.BorderSizePixel = 0
				ButtonContent.Position = UDim2.new(0, 10, 0, 23)
				ButtonContent.Name = "ButtonContent"
				ButtonContent.Parent = Button
				ButtonContent.Size = UDim2.new(1, -100, 0, 12)

                local function UpdateButtonFrameSize()
                    task.wait()
                    local contentHeight = ButtonContent.TextBounds.Y
                    Button.Size = UDim2.new(1, 0, 0, math.max(46, 23 + contentHeight + 10)) 
                    ButtonContent.Size = UDim2.new(1, -100, 0, contentHeight)
                    UpdateSizeSection()
                end
                ButtonContent:GetPropertyChangedSignal("TextBounds"):Connect(UpdateButtonFrameSize)
                UpdateButtonFrameSize()


				ButtonButton.Font = FontManager:GetFont("SourceSans")
				ButtonButton.Text = ""
				ButtonButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ButtonButton.TextSize = 14
				ButtonButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				ButtonButton.BackgroundTransparency = 0.9990000128746033
				ButtonButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonButton.BorderSizePixel = 0
				ButtonButton.Size = UDim2.new(1, 0, 1, 0)
				ButtonButton.Name = "ButtonButton"
				ButtonButton.Parent = Button

				FeatureFrame1.AnchorPoint = Vector2.new(1, 0.5)
				FeatureFrame1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				FeatureFrame1.BackgroundTransparency = 0.9990000128746033
				FeatureFrame1.BorderColor3 = Color3.fromRGB(0, 0, 0)
				FeatureFrame1.BorderSizePixel = 0
				FeatureFrame1.Position = UDim2.new(1, -15, 0.5, 0)
				FeatureFrame1.Size = UDim2.new(0, 25, 0, 25)
				FeatureFrame1.Name = "FeatureFrame"
				FeatureFrame1.Parent = Button

				if ButtonConfig.IconName then
					local iconInfo = ExternalIconManager.Icon(ButtonConfig.IconName, ButtonConfig.IconLibrary)
					if iconInfo then
						FeatureImg3.Image = iconInfo[1]
						local iconData = iconInfo[2]
						FeatureImg3.ImageRectOffset = iconData.ImageRectOffset
						FeatureImg3.ImageRectSize = iconData.ImageRectSize
					else
						warn("Button icon '"..ButtonConfig.IconName.."' ("..ButtonConfig.IconLibrary..") not found.")
						FeatureImg3.Image = "rbxassetid://16932740082" -- Default/fallback if specified icon not found
					end
				else
					FeatureImg3.Image = "rbxassetid://16932740082" -- Default if no icon name provided
				end
				FeatureImg3.AnchorPoint = Vector2.new(0.5, 0.5)
				FeatureImg3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				FeatureImg3.BackgroundTransparency = 0.9990000128746033
				FeatureImg3.BorderColor3 = Color3.fromRGB(0, 0, 0)
				FeatureImg3.BorderSizePixel = 0
				FeatureImg3.Position = UDim2.new(0.5, 0, 0.5, 0)
				FeatureImg3.Size = UDim2.new(1, 0, 1, 0)
				FeatureImg3.Name = "FeatureImg"
				FeatureImg3.Parent = FeatureFrame1

				local isLockedByDependency = function() return false end
				if ButtonConfig.Dependency then
					isLockedByDependency = HandleDependency(Button, ButtonConfig.Dependency, UpdateSizeSection, ButtonButton, ButtonFunc)
				end

				ButtonButton.Activated:Connect(function()
					if isLockedByDependency() then return end
					CircleClick(ButtonButton, Mouse.X, Mouse.Y)
					ButtonConfig.Callback()
				end)

				table.insert(GuiFunc.SearchableElements, {
					Title = ButtonConfig.Title,
					Content = ButtonConfig.Content,
					Type = "Button",
					UIInstance = Button,
					SectionName = currentSectionNameForSearch,
					TabName = currentTabNameForSearch,
					OpenFunction = function()
						if LayersPageLayout.CurrentPage ~= currentTabPageInstanceForSearch then
							LayersPageLayout:JumpTo(currentTabPageInstanceForSearch)
						end
						NameTab.Text = currentTabNameForSearch
						if not OpenSection then OpenSection = true; UpdateSizeSection() end -- Open section
						task.wait(0.3) -- Wait for animations
						ScrolLayers.CanvasPosition = Vector2.new(0, Button.AbsolutePosition.Y - ScrolLayers.AbsolutePosition.Y)
					end
				})

				CountItem = CountItem + 1
				return ButtonFunc
			end
			function Items:AddToggle(ToggleConfig)
				local ToggleConfig = ToggleConfig or {}
				local currentTabNameForSearch = NameTab.Text
				local currentSectionNameForSearch = Title
				local currentTabPageInstanceForSearch = ScrolLayers
				local currentSectionInstanceForSearch = Section
				ToggleConfig.Title = ToggleConfig.Title or "no Title"
				ToggleConfig.Content = ToggleConfig.Content or ""
				ToggleConfig.IconName = ToggleConfig.IconName or nil -- Was ToggleConfig.Icon
				ToggleConfig.IconLibrary = ToggleConfig.IconLibrary or "lucide"
				ToggleConfig.Style = ToggleConfig.Style or "Default" -- "Default" or "Checkbox"
				ToggleConfig.CanQuickToggle = ToggleConfig.CanQuickToggle or false

				ToggleConfig.Default = (ToggleConfig.Flag and ConfigManager:GetFlag(ToggleConfig.Flag, ToggleConfig.Default)) or ToggleConfig.Default or false
				ToggleConfig.Callback = ToggleConfig.Callback or function() end
				ToggleConfig.Dependency = ToggleConfig.Dependency or nil

				local ToggleFunc = {Value = ToggleConfig.Default}
				ToggleFunc.Changed = Instance.new("BindableEvent")

				local Toggle = Instance.new("Frame");
				local UICorner20 = Instance.new("UICorner");

				local currentXOffset = 10
				local CreatorButtonInstance -- Store creator button instance
				local isCreatorActive = false -- Local state for this toggle's creator button
				local creatorButtonFlag = ToggleConfig.Flag and (ToggleConfig.Flag .. "_QuickToggleCreatorActive")

				if ToggleConfig.CanQuickToggle and ToggleConfig.Flag then -- Creator button only if flag exists
					isCreatorActive = ConfigManager:GetFlag(creatorButtonFlag, false)

					CreatorButtonInstance = Instance.new("ImageButton")
					CreatorButtonInstance.Name = "CreatorButton"
					CreatorButtonInstance.Size = UDim2.fromOffset(16,16)
					CreatorButtonInstance.Position = UDim2.new(0, currentXOffset, 0.5, 0)
					CreatorButtonInstance.AnchorPoint = Vector2.new(0, 0.5)
					CreatorButtonInstance.BackgroundTransparency = 1
					CreatorButtonInstance.Parent = Toggle

					local creatorIconName = isCreatorActive and "settings-2" or "plus-square"
					local creatorIconInfo = ExternalIconManager.Icon(creatorIconName, "lucide")
					if creatorIconInfo then
						CreatorButtonInstance.Image = creatorIconInfo[1]
						local iconData = creatorIconInfo[2]
						CreatorButtonInstance.ImageRectOffset = iconData.ImageRectOffset
						CreatorButtonInstance.ImageRectSize = iconData.ImageRectSize
						CreatorButtonInstance.ImageColor3 = isCreatorActive and CurrentTheme.Colors.ThemeHighlight or CurrentTheme.Colors.TextLight
					else
						warn("Creator button icon '"..creatorIconName.."' (lucide) not found.")
					end
					currentXOffset = currentXOffset + CreatorButtonInstance.Size.X.Offset + 5 -- 5 is padding
				end

				local ToggleIconImage
				if ToggleConfig.IconName then
					ToggleIconImage = Instance.new("ImageLabel")
					ToggleIconImage.Name = "ToggleIcon"
					local iconInfo = ExternalIconManager.Icon(ToggleConfig.IconName, ToggleConfig.IconLibrary)
					if iconInfo then
						ToggleIconImage.Image = iconInfo[1]
						local iconData = iconInfo[2]
						ToggleIconImage.ImageRectOffset = iconData.ImageRectOffset
						ToggleIconImage.ImageRectSize = iconData.ImageRectSize
					else
						warn("Toggle icon '"..ToggleConfig.IconName.."' ("..ToggleConfig.IconLibrary..") not found.")
						ToggleIconImage.Visible = false
					end
					ToggleIconImage.BackgroundTransparency = 1
					ToggleIconImage.Size = UDim2.fromOffset(16, 16)
					ToggleIconImage.Position = UDim2.new(0, currentXOffset, 0.5, 0)
					ToggleIconImage.AnchorPoint = Vector2.new(0, 0.5)
					ToggleIconImage.Parent = Toggle
					currentXOffset = currentXOffset + ToggleIconImage.Size.X.Offset + 5
				end

				local ToggleTitle = Instance.new("TextLabel");
				local ToggleContent = Instance.new("TextLabel");
				local ToggleButton = Instance.new("TextButton");
				local FeatureFrame2 = Instance.new("Frame");
				local UICorner22 = Instance.new("UICorner");
				local UIStroke8 = Instance.new("UIStroke");
				local ToggleCircle = Instance.new("Frame");
				local UICorner23 = Instance.new("UICorner");

				Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.BackgroundTransparency = 0.9350000023841858
				Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Toggle.BorderSizePixel = 0
				Toggle.LayoutOrder = CountItem
				Toggle.Size = UDim2.new(1, 0, 0, 46)
				Toggle.Name = "Toggle"
				Toggle.Parent = SectionAdd

				UICorner20.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
				UICorner20.Parent = Toggle

				ToggleTitle.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				ToggleTitle.Text = ToggleConfig.Title
				ToggleTitle.TextSize = 13
				ToggleTitle.TextColor3 = CurrentTheme.Colors.TextLight
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
				ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleTitle.BackgroundTransparency = 1
				ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleTitle.BorderSizePixel = 0
				ToggleTitle.Position = UDim2.new(0, currentXOffset, 0, 10)
				ToggleTitle.Size = UDim2.new(1, -(100 + currentXOffset + 5), 0, 13)
				ToggleTitle.Name = "ToggleTitle"
				ToggleTitle.Parent = Toggle

				ToggleContent.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				ToggleContent.Text = ToggleConfig.Content
				ToggleContent.TextColor3 = CurrentTheme.Colors.TextVeryLight
				ToggleContent.TextSize = 12
				ToggleContent.TextTransparency = 0.6000000238418579
				ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
				ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom
                ToggleContent.TextWrapped = true
				ToggleContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleContent.BackgroundTransparency = 1
				ToggleContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleContent.BorderSizePixel = 0
				ToggleContent.Position = UDim2.new(0, currentXOffset, 0, 23)
				ToggleContent.Size = UDim2.new(1, -(100 + currentXOffset + 5), 0, 12)
				ToggleContent.Name = "ToggleContent"
				ToggleContent.Parent = Toggle
				
                local function UpdateToggleFrameSize()
                    task.wait()
                    local contentHeight = ToggleContent.TextBounds.Y
                    Toggle.Size = UDim2.new(1, 0, 0, math.max(46, 23 + contentHeight + 10))
                    ToggleContent.Size = UDim2.new(1, -(100 + currentXOffset + 5), 0, contentHeight)
                    UpdateSizeSection()
                end
                ToggleContent:GetPropertyChangedSignal("TextBounds"):Connect(UpdateToggleFrameSize)
                UpdateToggleFrameSize()


				ToggleButton.Font = FontManager:GetFont("SourceSans")
				ToggleButton.Text = ""
				ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.TextSize = 14
				ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.BackgroundTransparency = 0.9990000128746033
				ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.BorderSizePixel = 0
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Name = "ToggleButton"
				ToggleButton.Parent = Toggle

				local CheckboxCheckmark
				if ToggleConfig.Style == "Checkbox" then
					FeatureFrame2.AnchorPoint = Vector2.new(1, 0.5)
					FeatureFrame2.BackgroundColor3 = CurrentTheme.Colors.Secondary
					FeatureFrame2.BackgroundTransparency = 0
					FeatureFrame2.BorderColor3 = CurrentTheme.Colors.Stroke
					FeatureFrame2.BorderSizePixel = 1
					FeatureFrame2.Position = UDim2.new(1, -20, 0.5, 0)
					FeatureFrame2.Size = UDim2.fromOffset(18, 18)
					FeatureFrame2.Name = "CheckboxFrame"
					FeatureFrame2.Parent = Toggle

					UICorner22.Parent = FeatureFrame2
			UICorner22.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius

					ToggleCircle.Visible = false

					CheckboxCheckmark = Instance.new("ImageLabel")
					CheckboxCheckmark.Name = "CheckboxCheckmark"
					local checkIconInfo = ExternalIconManager.Icon("check", "lucide")
					if checkIconInfo then
						CheckboxCheckmark.Image = checkIconInfo[1]
						local iconData = checkIconInfo[2]
						CheckboxCheckmark.ImageRectOffset = iconData.ImageRectOffset
						CheckboxCheckmark.ImageRectSize = iconData.ImageRectSize
					else
						warn("Checkbox 'check' (lucide) icon not found.")
						CheckboxCheckmark.Image = "rbxassetid://13088829194" -- Fallback
					end
					CheckboxCheckmark.ImageColor3 = CurrentTheme.Colors.TextVeryLight
					CheckboxCheckmark.BackgroundTransparency = 1
					CheckboxCheckmark.Size = UDim2.fromScale(0.75, 0.75)
					CheckboxCheckmark.Position = UDim2.fromScale(0.5, 0.5)
					CheckboxCheckmark.AnchorPoint = Vector2.new(0.5, 0.5)
					CheckboxCheckmark.Visible = ToggleFunc.Value
					CheckboxCheckmark.Parent = FeatureFrame2
				else
					FeatureFrame2.AnchorPoint = Vector2.new(1, 0.5)
					FeatureFrame2.BackgroundColor3 = CurrentTheme.Colors.Secondary
					FeatureFrame2.BackgroundTransparency = 0.9200000166893005
					FeatureFrame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
					FeatureFrame2.BorderSizePixel = 0
					FeatureFrame2.Position = UDim2.new(1, -30, 0.5, 0)
					FeatureFrame2.Size = UDim2.new(0, 30, 0, 15)
					FeatureFrame2.Name = "FeatureFrame"
					FeatureFrame2.Parent = Toggle

					UICorner22.Parent = FeatureFrame2
					UICorner22.CornerRadius = CurrentTheme.Sizes.LargeCornerRadius

					UIStroke8.Color = CurrentTheme.Colors.TextVeryLight
					UIStroke8.Thickness = 2
					UIStroke8.Transparency = 0.9
					UIStroke8.Parent = FeatureFrame2

					ToggleCircle.BackgroundColor3 = CurrentTheme.Colors.TextLight
					ToggleCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ToggleCircle.BorderSizePixel = 0
					ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
					ToggleCircle.AnchorPoint = Vector2.new(0,0.5)
					ToggleCircle.Position = UDim2.new(0,0.5,0.5,0)
					ToggleCircle.Name = "ToggleCircle"
					ToggleCircle.Parent = FeatureFrame2

					UICorner23.CornerRadius = UDim.new(0, 15)
					UICorner23.Parent = ToggleCircle
				end

				local isLockedByDependency = function() return false end
				local quickToggleUI = nil

				local function DestroyQuickToggle(flagName)
					if GuiFunc.ActiveQuickToggles[flagName] then
						if GuiFunc.ActiveQuickToggles[flagName].Frame and GuiFunc.ActiveQuickToggles[flagName].Frame.Parent then
							GuiFunc.ActiveQuickToggles[flagName].Frame:Destroy()
						end
						GuiFunc.ActiveQuickToggles[flagName] = nil
						ConfigManager:SetFlag(flagName .. "_QuickToggleData", nil)
						if GuiFunc.CurrentlyEditingQuickToggle and GuiFunc.CurrentlyEditingQuickToggle.OriginalFlag == flagName then
							GuiFunc.ResizePanel.Visible = false
							GuiFunc.CurrentlyEditingQuickToggle = nil
						end
					end
				end

				local function CreateOrShowQuickToggle(mainToggleFuncRef, TglConfig)
					if GuiFunc.ActiveQuickToggles[TglConfig.Flag] then return end

					local quickToggleData = ConfigManager:GetFlag(TglConfig.Flag .. "_QuickToggleData", {
						Pos = {X = 50, Y = 50 + (#table.getKeys(GuiFunc.ActiveQuickToggles) * (CurrentTheme.Sizes.QuickToggleSize.Y.Offset + 10))},
						Size = {X = CurrentTheme.Sizes.QuickToggleSize.X.Offset, Y = CurrentTheme.Sizes.QuickToggleSize.Y.Offset},
						State = mainToggleFuncRef.Value
					})

					local qtFrame = Instance.new("Frame")
					qtFrame.Name = TglConfig.Flag .. "_QuickToggleFrame"
					qtFrame.Size = UDim2.fromOffset(quickToggleData.Size.X, quickToggleData.Size.Y)
					qtFrame.Position = UDim2.fromOffset(quickToggleData.Pos.X, quickToggleData.Pos.Y)
					qtFrame.BackgroundTransparency = 0.3
					qtFrame.BackgroundColor3 = CurrentTheme.Colors.BackgroundLight
					qtFrame.BorderSizePixel = 0
					qtFrame.Draggable = GuiFunc.isEditMode
					qtFrame:SetAttribute("QuickToggleFlag", TglConfig.Flag)
					qtFrame.Parent = GuiFunc.QuickToggleContainer

					local qtCorner = Instance.new("UICorner")
					qtCorner.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
					qtCorner.Parent = qtFrame

					local qtButton = Instance.new("ImageButton")
					qtButton.Name = "QuickToggleButton"
					qtButton.Size = UDim2.fromScale(0.8, 0.8)
					qtButton.Position = UDim2.fromScale(0.5,0.5)
					qtButton.AnchorPoint = Vector2.new(0.5,0.5)
					qtButton.BackgroundTransparency = 1
					local iconNameForQuickToggle = TglConfig.IconName or "toggle-left" -- Use provided icon or default
					local iconLibForQuickToggle = TglConfig.IconLibrary or "lucide"

					local iconInfo = ExternalIconManager.Icon(iconNameForQuickToggle, iconLibForQuickToggle)
					if iconInfo then
						qtButton.Image = iconInfo[1]
						local iconData = iconInfo[2]
						qtButton.ImageRectOffset = iconData.ImageRectOffset
						qtButton.ImageRectSize = iconData.ImageRectSize
					else
						warn("Quick toggle icon '"..iconNameForQuickToggle.."' ("..iconLibForQuickToggle..") not found.")
						-- Button will be blank if icon not found, or could set a fallback text/image
					end
					qtButton.Parent = qtFrame
					MakeDraggable(qtButton, qtFrame)

					local currentFeatureState = quickToggleData.State

					local function UpdateQuickToggleVisual(state)
						qtButton.ImageColor3 = state and CurrentTheme.Colors.ThemeHighlight or CurrentTheme.Colors.TextDark
						qtFrame.BackgroundColor3 = state and CurrentTheme.Colors.Accent or CurrentTheme.Colors.BackgroundLight
					end
					UpdateQuickToggleVisual(currentFeatureState)

					quickToggleUI = {
						Frame = qtFrame,
						Button = qtButton,
						UpdateVisuals = UpdateQuickToggleVisual,
						OriginalCallback = TglConfig.Callback,
						OriginalFlag = TglConfig.Flag,
						CurrentState = currentFeatureState
					}
					GuiFunc.ActiveQuickToggles[TglConfig.Flag] = quickToggleUI

					qtButton.Activated:Connect(function()
						if GuiFunc.isEditMode then
							if GuiFunc.ShowResizePanelFor then GuiFunc:ShowResizePanelFor(quickToggleUI) end
						else
							quickToggleUI.CurrentState = not quickToggleUI.CurrentState
							quickToggleUI.UpdateVisuals(quickToggleUI.CurrentState)
							quickToggleUI.OriginalCallback(quickToggleUI.CurrentState)

							local currentData = ConfigManager:GetFlag(TglConfig.Flag .. "_QuickToggleData", {})
							currentData.State = quickToggleUI.CurrentState
							ConfigManager:SetFlag(TglConfig.Flag .. "_QuickToggleData", currentData)
						end
					end)

					if GuiFunc.isEditMode then
						qtFrame.Draggable = true
						qtFrame.BorderSizePixel = 1
						qtFrame.BorderColor3 = CurrentTheme.Colors.ThemeHighlight
					end
				end
				
				ToggleButton.Activated:Connect(function()
					if isLockedByDependency() then return end
					CircleClick(ToggleButton, Mouse.X, Mouse.Y)

					if ToggleConfig.CanQuickToggle and isCreatorActive then
						ToggleFunc.Value = not ToggleFunc.Value
						ToggleFunc:Set(ToggleFunc.Value, true)

						if ToggleFunc.Value then
							CreateOrShowQuickToggle(ToggleFunc, ToggleConfig)
						else
							DestroyQuickToggle(ToggleConfig.Flag)
						end
						SaveFile(ToggleConfig.Flag, ToggleFunc.Value)
						ToggleFunc.Changed:Fire(ToggleFunc.Value)
					else
						ToggleFunc.Value = not ToggleFunc.Value
						ToggleFunc:Set(ToggleFunc.Value)
						if ToggleConfig.CanQuickToggle then
							DestroyQuickToggle(ToggleConfig.Flag)
						end
					end
				end)

				function ToggleFunc:Set(Value, fromDependency)
					local oldValue = ToggleFunc.Value
					ToggleFunc.Value = Value

					if not fromDependency then
						if not (ToggleConfig.CanQuickToggle and isCreatorActive) then
							ToggleConfig.Callback(Value)
						end
						if ToggleConfig.Flag and typeof(ToggleConfig.Flag) == "string" then
							SaveFile(ToggleConfig.Flag, ToggleFunc.Value)
						end
					end

                    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

					if ToggleConfig.Style == "Checkbox" then
						if CheckboxCheckmark then CheckboxCheckmark.Visible = Value end
						TweenService:Create(FeatureFrame2, tweenInfo, {BackgroundColor3 = Value and CurrentTheme.Colors.ThemeHighlight or CurrentTheme.Colors.Secondary}):Play()
						TweenService:Create(ToggleTitle, tweenInfo, {TextColor3 = Value and CurrentTheme.Colors.ThemeHighlight or CurrentTheme.Colors.TextLight}):Play()
					else
						if Value then
							TweenService:Create(ToggleTitle, tweenInfo, {TextColor3 = CurrentTheme.Colors.ThemeHighlight}):Play()
							TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(1, -ToggleCircle.AbsoluteSize.X - 0.5, 0.5, 0)}):Play()
							TweenService:Create(UIStroke8, tweenInfo, {Color = CurrentTheme.Colors.ThemeHighlight, Transparency = 0}):Play()
							TweenService:Create(FeatureFrame2, tweenInfo, {BackgroundColor3 = CurrentTheme.Colors.ThemeHighlight, BackgroundTransparency = 0}):Play()
						else
							TweenService:Create(ToggleTitle, tweenInfo, {TextColor3 = CurrentTheme.Colors.TextLight}):Play()
							TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(0, 0.5, 0.5, 0)}):Play()
							TweenService:Create(UIStroke8, tweenInfo, {Color = CurrentTheme.Colors.TextVeryLight, Transparency = 0.9}):Play()
							TweenService:Create(FeatureFrame2, tweenInfo, {BackgroundColor3 = CurrentTheme.Colors.Secondary, BackgroundTransparency = 0.9200000166893005}):Play()
						end
					end
					if oldValue ~= Value and not fromDependency then
						ToggleFunc.Changed:Fire(Value)
					end
				end
				ToggleFunc:Set(ToggleFunc.Value, true)

				if ToggleConfig.Flag then
					ConfigManager:RegisterUIElement(ToggleConfig.Flag, function(val)
						ToggleFunc:Set(val, true)
						if ToggleConfig.CanQuickToggle and isCreatorActive then
							if val then CreateOrShowQuickToggle(ToggleFunc, ToggleConfig) else DestroyQuickToggle(ToggleConfig.Flag) end
						elseif GuiFunc.ActiveQuickToggles[ToggleConfig.Flag] then
							GuiFunc.ActiveQuickToggles[ToggleConfig.Flag].CurrentState = val
							GuiFunc.ActiveQuickToggles[ToggleConfig.Flag].UpdateVisuals(val)
						end
					end)
				end

				function ToggleFunc:AddDependency(depConfig)
					isLockedByDependency = HandleDependency(Toggle, depConfig, UpdateSizeSection, ToggleButton, self)
				end

				if ToggleConfig.Dependency then
					ToggleFunc:AddDependency(ToggleConfig.Dependency)
				end

				if CreatorButtonInstance then
					CreatorButtonInstance.Activated:Connect(function()
						isCreatorActive = not isCreatorActive
						ConfigManager:SetFlag(creatorButtonFlag, isCreatorActive)
						local creatorIconName = isCreatorActive and "settings-2" or "plus-square"
					local newIconInfo = ExternalIconManager.Icon(creatorIconName, "lucide")
					if newIconInfo then
						CreatorButtonInstance.Image = newIconInfo[1]
						local iconData = newIconInfo[2]
						CreatorButtonInstance.ImageRectOffset = iconData.ImageRectOffset
						CreatorButtonInstance.ImageRectSize = iconData.ImageRectSize
							CreatorButtonInstance.ImageColor3 = isCreatorActive and CurrentTheme.Colors.ThemeHighlight or CurrentTheme.Colors.TextLight
					else
						warn("Creator button (update) icon '"..creatorIconName.."' (lucide) not found.")
						end

						if not isCreatorActive then
							DestroyQuickToggle(ToggleConfig.Flag)
						else
							if ToggleFunc.Value then CreateOrShowQuickToggle(ToggleFunc, ToggleConfig) end
						end
					end)
					if isCreatorActive and ToggleFunc.Value then
						CreateOrShowQuickToggle(ToggleFunc, ToggleConfig)
					end
				end

				table.insert(GuiFunc.SearchableElements, {
					Title = ToggleConfig.Title,
					Content = ToggleConfig.Content,
					Type = "Toggle",
					UIInstance = Toggle,
					SectionName = currentSectionNameForSearch,
					TabName = currentTabNameForSearch,
					OpenFunction = function()
						if LayersPageLayout.CurrentPage ~= currentTabPageInstanceForSearch then
							LayersPageLayout:JumpTo(currentTabPageInstanceForSearch)
						end
						NameTab.Text = currentTabNameForSearch
						if not OpenSection then OpenSection = true; UpdateSizeSection() end
						task.wait(0.3)
						ScrolLayers.CanvasPosition = Vector2.new(0, Toggle.AbsolutePosition.Y - ScrolLayers.AbsolutePosition.Y)
					end
				})

				CountItem = CountItem + 1
				return ToggleFunc
			end
			function Items:AddSlider(SliderConfig)
				local SliderConfig = SliderConfig or {}
				local currentTabNameForSearch = NameTab.Text
				local currentSectionNameForSearch = Title
				local currentTabPageInstanceForSearch = ScrolLayers
				local currentSectionInstanceForSearch = Section
				SliderConfig.Title = SliderConfig.Title or "Slider"
				SliderConfig.Content = SliderConfig.Content or "Content"
				SliderConfig.Increment = SliderConfig.Increment or 1
				SliderConfig.Min = SliderConfig.Min or 0
				SliderConfig.Max = SliderConfig.Max or 100
				SliderConfig.Default = (SliderConfig.Flag and ConfigManager:GetFlag(SliderConfig.Flag, SliderConfig.Default)) or SliderConfig.Default or SliderConfig.Min
				SliderConfig.Callback = SliderConfig.Callback or function() end
				SliderConfig.Dependency = SliderConfig.Dependency or nil

				local SliderFunc = {Value = SliderConfig.Default}
				SliderFunc.Changed = Instance.new("BindableEvent")
	
				local Slider = Instance.new("Frame");
				local UICorner15 = Instance.new("UICorner");
				local SliderTitle = Instance.new("TextLabel");
				local SliderContent = Instance.new("TextLabel");
				local SliderInput = Instance.new("Frame");
				local UICorner16 = Instance.new("UICorner");
				local TextBox = Instance.new("TextBox");
				local SliderFrame = Instance.new("Frame"); 
				local UICorner17 = Instance.new("UICorner");
				local SliderDraggable = Instance.new("Frame"); 
				local UICorner18 = Instance.new("UICorner");
				local SliderCircle = Instance.new("Frame"); 
				local UICorner19 = Instance.new("UICorner");
				local UIStroke6 = Instance.new("UIStroke"); 

				Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Slider.BackgroundTransparency = 0.9350000023841858
				Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Slider.BorderSizePixel = 0
				Slider.LayoutOrder = CountItem
				Slider.Size = UDim2.new(1, 0, 0, 46)
				Slider.Name = "Slider"
				Slider.Parent = SectionAdd

				UICorner15.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
				UICorner15.Parent = Slider

				SliderTitle.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				SliderTitle.Text = SliderConfig.Title
				SliderTitle.TextColor3 = CurrentTheme.Colors.TextLight
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
				SliderTitle.Parent = Slider

				SliderContent.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				SliderContent.Text = SliderConfig.Content
				SliderContent.TextColor3 = CurrentTheme.Colors.TextVeryLight
				SliderContent.TextSize = 12
				SliderContent.TextTransparency = 0.6000000238418579
                SliderContent.TextWrapped = true
				SliderContent.TextXAlignment = Enum.TextXAlignment.Left
				SliderContent.TextYAlignment = Enum.TextYAlignment.Bottom
				SliderContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderContent.BackgroundTransparency = 0.9990000128746033
				SliderContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderContent.BorderSizePixel = 0
				SliderContent.Position = UDim2.new(0, 10, 0, 23)
				SliderContent.Size = UDim2.new(1, -180, 0, 12)
				SliderContent.Name = "SliderContent"
				SliderContent.Parent = Slider

                local function UpdateSliderFrameSize()
                    task.wait()
                    local contentHeight = SliderContent.TextBounds.Y
                    Slider.Size = UDim2.new(1, 0, 0, math.max(46, 23 + contentHeight + 10))
                    SliderContent.Size = UDim2.new(1, -180, 0, contentHeight)
                    UpdateSizeSection()
                end
                SliderContent:GetPropertyChangedSignal("TextBounds"):Connect(UpdateSliderFrameSize)
                UpdateSliderFrameSize()


				SliderInput.AnchorPoint = Vector2.new(0, 0.5)
				SliderInput.BackgroundColor3 = CurrentTheme.Colors.Accent
				SliderInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderInput.BorderSizePixel = 0
				SliderInput.Position = UDim2.new(1, -155, 0.5, 0)
				SliderInput.Size = UDim2.new(0, 28, 0, 20)
				SliderInput.Name = "SliderInput"
				SliderInput.Parent = Slider

				UICorner16.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
				UICorner16.Parent = SliderInput

				TextBox.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				TextBox.Text = tostring(SliderConfig.Default)
				TextBox.TextColor3 = CurrentTheme.Colors.TextVeryLight
				TextBox.TextSize = 13
				TextBox.TextWrapped = true
				TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				TextBox.BackgroundTransparency = 0.9990000128746033
				TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextBox.BorderSizePixel = 0
				TextBox.Position = UDim2.new(0, -1, 0, 0)
				TextBox.Size = UDim2.new(1, 0, 1, 0)
				TextBox.Parent = SliderInput

				SliderFrame.AnchorPoint = Vector2.new(1, 0.5)
				SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderFrame.BackgroundTransparency = 0.800000011920929
				SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderFrame.BorderSizePixel = 0
				SliderFrame.Position = UDim2.new(1, -20, 0.5, 0)
				SliderFrame.Size = UDim2.new(0, 100, 0, 3)
				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Slider

				UICorner17.Parent = SliderFrame
                UICorner17.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius

				SliderDraggable.AnchorPoint = Vector2.new(0, 0.5)
				SliderDraggable.BackgroundColor3 = CurrentTheme.Colors.Accent
				SliderDraggable.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderDraggable.BorderSizePixel = 0
				SliderDraggable.Position = UDim2.new(0, 0, 0.5, 0)
				SliderDraggable.Size = UDim2.new(0.899999976, 0, 1, 0) 
				SliderDraggable.Name = "SliderDraggable"
				SliderDraggable.Parent = SliderFrame

				UICorner18.Parent = SliderDraggable
                UICorner18.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius

				SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
				SliderCircle.BackgroundColor3 = CurrentTheme.Colors.ThemeHighlight
				SliderCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderCircle.BorderSizePixel = 0
				SliderCircle.Position = UDim2.new(1, 4, 0.5, 0)
				SliderCircle.Size = UDim2.new(0, 8, 0, 8)
				SliderCircle.Name = "SliderCircle"
				SliderCircle.Parent = SliderDraggable

				UICorner19.Parent = SliderCircle
                UICorner19.CornerRadius = CurrentTheme.Sizes.LargeCornerRadius

				UIStroke6.Color = CurrentTheme.Colors.ThemeHighlight -- Assuming GuiConfig.Color is ThemeHighlight
				UIStroke6.Parent = SliderCircle

				local Dragging = false
                local DragInputObject = nil 
                local UISInputChangedConnection = nil
                local UISInputEndedConnection = nil

				local function Round(Number, Factor)
					return math.floor(Number/Factor + 0.5) * Factor
				end
                
				local isLockedByDependency = function() return false end

				function SliderFunc:Set(Value, fromInputOrDependency)
                    fromInputOrDependency = fromInputOrDependency or false
					local oldValue = SliderFunc.Value
					Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)

					SliderFunc.Value = Value -- Set internal value first

					if SliderFunc.Value ~= oldValue or fromInputOrDependency then -- Update visuals if value changed OR if forced by input/dependency
						local formatValue = Value
						if SliderConfig.Increment < 1 then
							local decimalPlaces = math.max(0, -math.floor(math.log10(SliderConfig.Increment)))
							formatValue = string.format("%."..decimalPlaces.."f", Value)
						end
						TextBox.Text = tostring(formatValue)
						local scale = (Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                        scale = math.clamp(scale,0,1)

						if Dragging or fromInputOrDependency then
							SliderDraggable.Size = UDim2.fromScale(scale, 1)
						else
							TweenService:Create(SliderDraggable,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.fromScale(scale, 1)}):Play()
						end
					end

					if not fromInputOrDependency then -- Only call callback, save, and fire changed if not from dependency/initial set
						SliderConfig.Callback(SliderFunc.Value)
                        if SliderConfig.Flag and typeof(SliderConfig.Flag) == "string" then
                            SaveFile(SliderConfig.Flag, SliderFunc.Value)
                        end
						if oldValue ~= SliderFunc.Value then
							SliderFunc.Changed:Fire(SliderFunc.Value)
						end
					elseif oldValue ~= SliderFunc.Value and fromInputOrDependency == "input" then -- Special case for direct input that should still fire Changed
						SliderFunc.Changed:Fire(SliderFunc.Value)
					end
				end


				SliderFrame.InputBegan:Connect(function(Input)
					if isLockedByDependency() then return end
					if not Dragging and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then 
						Dragging = true
                        DragInputObject = Input

						local frameAbsPos = SliderFrame.AbsolutePosition
						local frameAbsSizeX = SliderFrame.AbsoluteSize.X
						local pressPosX = Input.Position.X
						local relativeX = pressPosX - frameAbsPos.X
						local SizeScale = math.clamp(relativeX / frameAbsSizeX, 0, 1)
						SliderFunc:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
					end 
				end)
                
                UISInputChangedConnection = UserInputService.InputChanged:Connect(function(Input)
					if isLockedByDependency() then Dragging = false; return end
					if Dragging and Input == DragInputObject then 
						if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then 
							local frameAbsPos = SliderFrame.AbsolutePosition
							local frameAbsSizeX = SliderFrame.AbsoluteSize.X
							local currentPosX = Input.Position.X
							local relativeX = currentPosX - frameAbsPos.X
							local SizeScale = math.clamp(relativeX / frameAbsSizeX, 0, 1)
							SliderFunc:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
						end
					end
				end)

				UISInputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
					if Dragging and Input == DragInputObject then 
						if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
							Dragging = false 
                            DragInputObject = nil
						end 
					end 
				end)

				Slider.Destroying:Connect(function()
					if UISInputChangedConnection then
						UISInputChangedConnection:Disconnect()
						UISInputChangedConnection = nil
					end
					if UISInputEndedConnection then
						UISInputEndedConnection:Disconnect()
						UISInputEndedConnection = nil
					end
				end)

				TextBox:GetPropertyChangedSignal("Text"):Connect(function()
					if isLockedByDependency() then TextBox.Text = tostring(SliderFunc.Value); return end
					local pattern = SliderConfig.Min < 0 and "[^-%d%.]" or "[^%d%.]" 
					local Valid = TextBox.Text:gsub(pattern, "")
					local decimalCount = select(2, Valid:gsub("%.", ""))
					if decimalCount > 1 then
						Valid = Valid:reverse():gsub("%.", "", 1):reverse()
					end
					if Valid:match("^0%d") and not Valid:match("^0%.") then
						Valid = Valid:sub(2)
					end
                    if Valid ~= TextBox.Text then 
					    TextBox.Text = Valid
                    end
				end)
				TextBox.FocusLost:Connect(function(enterPressed)
					if isLockedByDependency() then return end
                    if enterPressed or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then 
                        local numVal = tonumber(TextBox.Text)
                        if numVal ~= nil then
                            SliderFunc:Set(numVal, "input") -- Mark as direct input
                        else
                            SliderFunc:Set(SliderConfig.Min, "input")
                        end
                    end
				end)
				SliderFunc:Set(tonumber(SliderConfig.Default), true) -- Initial set from default/flag, mark as fromDependency to avoid initial callback spam

				if SliderConfig.Flag then
					ConfigManager:RegisterUIElement(SliderConfig.Flag, function(val) SliderFunc:Set(val, true) end)
				end

				function SliderFunc:AddDependency(depConfig)
					isLockedByDependency = HandleDependency(Slider, depConfig, UpdateSizeSection, TextBox, self) -- self is SliderFunc
				end

				if SliderConfig.Dependency then
					SliderFunc:AddDependency(SliderConfig.Dependency)
				end

				CountItem = CountItem + 1

				table.insert(GuiFunc.SearchableElements, {
					Title = SliderConfig.Title,
					Content = SliderConfig.Content,
					Type = "Slider",
					UIInstance = Slider,
					SectionName = currentSectionNameForSearch,
					TabName = currentTabNameForSearch,
					OpenFunction = function()
						if LayersPageLayout.CurrentPage ~= currentTabPageInstanceForSearch then
							LayersPageLayout:JumpTo(currentTabPageInstanceForSearch)
						end
						NameTab.Text = currentTabNameForSearch
						if not OpenSection then OpenSection = true; UpdateSizeSection() end
						task.wait(0.3)
						ScrolLayers.CanvasPosition = Vector2.new(0, Slider.AbsolutePosition.Y - ScrolLayers.AbsolutePosition.Y)
					end
				})
				return SliderFunc
			end

			function Items:AddInput(InputConfig)
				local InputConfig = InputConfig or {}
				local currentTabNameForSearch = NameTab.Text
				local currentSectionNameForSearch = Title
				local currentTabPageInstanceForSearch = ScrolLayers
				local currentSectionInstanceForSearch = Section
				InputConfig.Title = InputConfig.Title or "Title"
				InputConfig.Content = InputConfig.Content or "Content"
                InputConfig.Default = (InputConfig.Flag and ConfigManager:GetFlag(InputConfig.Flag, InputConfig.Default)) or InputConfig.Default or ""
				InputConfig.Callback = InputConfig.Callback or function() end
				InputConfig.Dependency = InputConfig.Dependency or nil

				local InputFunc = {Value = InputConfig.Default}
				InputFunc.Changed = Instance.new("BindableEvent")

				local Input = Instance.new("Frame");
				local UICorner12 = Instance.new("UICorner");
				local InputTitle = Instance.new("TextLabel");
				local InputContent = Instance.new("TextLabel");
				local InputFrame = Instance.new("Frame");
				local UICorner13 = Instance.new("UICorner");
				local InputTextBox = Instance.new("TextBox");

				Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Input.BackgroundTransparency = 0.9350000023841858
				Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Input.BorderSizePixel = 0
				Input.LayoutOrder = CountItem
				Input.Size = UDim2.new(1, 0, 0, 46)
				Input.Name = "Input"
				Input.Parent = SectionAdd

				UICorner12.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
				UICorner12.Parent = Input

				InputTitle.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				InputTitle.Text = InputConfig.Title
				InputTitle.TextColor3 = CurrentTheme.Colors.TextLight
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
				InputTitle.Parent = Input

				InputContent.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				InputContent.Text = InputConfig.Content
				InputContent.TextColor3 = CurrentTheme.Colors.TextVeryLight
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
				InputContent.Size = UDim2.new(1, -180, 0, 12)
				InputContent.Name = "InputContent"
				InputContent.Parent = Input

                local function UpdateInputFrameSize()
                    task.wait()
                    local contentHeight = InputContent.TextBounds.Y
                    Input.Size = UDim2.new(1, 0, 0, math.max(46, 23 + contentHeight + 10))
                    InputContent.Size = UDim2.new(1, -180, 0, contentHeight)
                    UpdateSizeSection()
                end
                InputContent:GetPropertyChangedSignal("TextBounds"):Connect(UpdateInputFrameSize)
                UpdateInputFrameSize()


				InputFrame.AnchorPoint = Vector2.new(1, 0.5)
				InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputFrame.BackgroundTransparency = 0.949999988079071
				InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputFrame.BorderSizePixel = 0
				InputFrame.ClipsDescendants = true
				InputFrame.Position = UDim2.new(1, -7, 0.5, 0)
				InputFrame.Size = UDim2.new(0, 148, 0, 30)
				InputFrame.Name = "InputFrame"
				InputFrame.Parent = Input

				UICorner13.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
				UICorner13.Parent = InputFrame

				InputTextBox.CursorPosition = -1
				InputTextBox.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				InputTextBox.PlaceholderColor3 = CurrentTheme.Colors.TextDark
				InputTextBox.PlaceholderText = "Write your input there"
				InputTextBox.Text = tostring(InputFunc.Value)
				InputTextBox.TextColor3 = CurrentTheme.Colors.TextVeryLight
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
				InputTextBox.Parent = InputFrame

				local isLockedByDependency = function() return false end

				function InputFunc:Set(Value, fromDependency)
					local oldValue = InputFunc.Value
					InputTextBox.Text = tostring(Value) 
					InputFunc.Value = Value 

					if not fromDependency then
						InputConfig.Callback(Value)
						if InputConfig.Flag and typeof(InputConfig.Flag) == "string" then
							SaveFile(InputConfig.Flag,InputFunc.Value)
						end
						if oldValue ~= Value then
							InputFunc.Changed:Fire(Value)
						end
					end
				end

				InputTextBox.FocusLost:Connect(function(enterPressed)
					if isLockedByDependency() then
						InputTextBox.Text = InputFunc.Value -- Revert if changed while locked
						return
					end
                    if enterPressed then
					    InputFunc:Set(InputTextBox.Text)
                    end
				end)
				InputTextBox:GetPropertyChangedSignal("Text"):Connect(function()
					if isLockedByDependency() then
						InputTextBox.Text = InputFunc.Value -- Prevent typing while locked
					end
				end)


				if InputConfig.Flag then
					ConfigManager:RegisterUIElement(InputConfig.Flag, function(val) InputFunc:Set(val, true) end)
				end
				InputFunc:Set(InputConfig.Default, true) -- Initial set

				function InputFunc:AddDependency(depConfig)
					isLockedByDependency = HandleDependency(Input, depConfig, UpdateSizeSection, InputTextBox, self) -- self is InputFunc
				end

				if InputConfig.Dependency then
					InputFunc:AddDependency(InputConfig.Dependency)
				end

				CountItem = CountItem + 1

				table.insert(GuiFunc.SearchableElements, {
					Title = InputConfig.Title,
					Content = InputConfig.Content,
					Type = "Input",
					UIInstance = Input,
					SectionName = currentSectionNameForSearch,
					TabName = currentTabNameForSearch,
					OpenFunction = function()
						if LayersPageLayout.CurrentPage ~= currentTabPageInstanceForSearch then
							LayersPageLayout:JumpTo(currentTabPageInstanceForSearch)
						end
						NameTab.Text = currentTabNameForSearch
						if not OpenSection then OpenSection = true; UpdateSizeSection() end
						task.wait(0.3)
						ScrolLayers.CanvasPosition = Vector2.new(0, Input.AbsolutePosition.Y - ScrolLayers.AbsolutePosition.Y)
					end
				})
				return InputFunc
			end

			function Items:AddDropdown(DropdownConfig)
				local DropdownConfig = DropdownConfig or {}
				local currentTabNameForSearch = NameTab.Text
				local currentSectionNameForSearch = Title
				local currentTabPageInstanceForSearch = ScrolLayers
				local currentSectionInstanceForSearch = Section
				DropdownConfig.Title = DropdownConfig.Title or "No Title"
				DropdownConfig.Content = DropdownConfig.Content or ""
				DropdownConfig.Multi = DropdownConfig.Multi or false
				DropdownConfig.Options = DropdownConfig.Options or {}

				local initialValue = DropdownConfig.Default
				if DropdownConfig.Flag then
					initialValue = ConfigManager:GetFlag(DropdownConfig.Flag, DropdownConfig.Default)
				end

				if DropdownConfig.Multi then
					DropdownConfig.Default = (initialValue and type(initialValue) == "table") and initialValue or (type(DropdownConfig.Default) == "table" and DropdownConfig.Default or {})
				else
					DropdownConfig.Default = initialValue
				end
				DropdownConfig.Callback = DropdownConfig.Callback or function() end
				DropdownConfig.Dependency = DropdownConfig.Dependency or nil

				local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options}
				DropdownFunc.Changed = Instance.new("BindableEvent")
	
				local Dropdown = Instance.new("Frame");
				local DropdownButton = Instance.new("TextButton");
				local UICorner10 = Instance.new("UICorner");
				local DropdownTitle = Instance.new("TextLabel");
				local DropdownContent = Instance.new("TextLabel");
				local SelectOptionsFrame = Instance.new("Frame");
				local UICorner11 = Instance.new("UICorner");
				local OptionSelecting = Instance.new("TextLabel");
				local OptionImg = Instance.new("ImageLabel");

				Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Dropdown.BackgroundTransparency = 0.9350000023841858
				Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Dropdown.BorderSizePixel = 0
				Dropdown.LayoutOrder = CountItem
				Dropdown.Size = UDim2.new(1, 0, 0, 46)
				Dropdown.Name = "Dropdown"
				Dropdown.Parent = SectionAdd

				DropdownButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Secondary)
				DropdownButton.Text = ""
				DropdownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.TextSize = 14
				DropdownButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.BackgroundTransparency = 0.9990000128746033
				DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.BorderSizePixel = 0
				DropdownButton.Size = UDim2.new(1, 0, 1, 0)
				DropdownButton.Name = "DropdownActivationButton"
				DropdownButton.Parent = Dropdown

				UICorner10.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
				UICorner10.Parent = Dropdown

				DropdownTitle.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				DropdownTitle.Text = DropdownConfig.Title
				DropdownTitle.TextColor3 = CurrentTheme.Colors.TextLight
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
				DropdownTitle.Parent = Dropdown

				DropdownContent.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				DropdownContent.Text = DropdownConfig.Content
				DropdownContent.TextColor3 = CurrentTheme.Colors.TextVeryLight
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
				DropdownContent.Size = UDim2.new(1, -180, 0, 12)
				DropdownContent.Name = "DropdownContent"
				DropdownContent.Parent = Dropdown

                local function UpdateDropdownFrameSize()
                    task.wait()
                    local contentHeight = DropdownContent.TextBounds.Y
                    Dropdown.Size = UDim2.new(1, 0, 0, math.max(46, 23 + contentHeight + 10))
                    DropdownContent.Size = UDim2.new(1, -180, 0, contentHeight)
                    UpdateSizeSection()
                end
                DropdownContent:GetPropertyChangedSignal("TextBounds"):Connect(UpdateDropdownFrameSize)
                UpdateDropdownFrameSize()


				SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
				SelectOptionsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SelectOptionsFrame.BackgroundTransparency = 0.949999988079071
				SelectOptionsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SelectOptionsFrame.BorderSizePixel = 0
				SelectOptionsFrame.Position = UDim2.new(1, -7, 0.5, 0)
				SelectOptionsFrame.Size = UDim2.new(0, 148, 0, 30)
				SelectOptionsFrame.Name = "SelectOptionsFrame"
				SelectOptionsFrame.LayoutOrder = CountDropdown
				SelectOptionsFrame.Parent = Dropdown

				UICorner11.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
				UICorner11.Parent = SelectOptionsFrame

				local ScrollSelect = Instance.new("ScrollingFrame");
				local SearchBar = Instance.new("TextBox")

				OptionSelecting.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				OptionSelecting.Text = ""
				OptionSelecting.TextColor3 = CurrentTheme.Colors.TextVeryLight
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

				OptionImg.Image = "rbxassetid://16851841101"
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


				local UIListLayout4 = Instance.new("UIListLayout");

				ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, 0)
				ScrollSelect.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
				ScrollSelect.ScrollBarThickness = 0
				ScrollSelect.Active = true
				ScrollSelect.LayoutOrder = CountDropdown
				ScrollSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ScrollSelect.BackgroundTransparency = 0.9990000128746033
				ScrollSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ScrollSelect.BorderSizePixel = 0
				ScrollSelect.Size = UDim2.new(1, 0, 1, 0)
				ScrollSelect.Name = "ScrollSelect"
				ScrollSelect.Parent = DropdownFolder


				SearchBar.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				SearchBar.PlaceholderText = "Search 🔎" 
				SearchBar.PlaceholderColor3 = CurrentTheme.Colors.TextDark
				SearchBar.Text = ""
				SearchBar.TextColor3 = CurrentTheme.Colors.TextVeryLight
				SearchBar.TextSize = 12
				SearchBar.BackgroundColor3 = CurrentTheme.Colors.Secondary
				SearchBar.BackgroundTransparency = 0.5
				SearchBar.BorderColor3 = CurrentTheme.Colors.Stroke
				SearchBar.BorderSizePixel = 1
				SearchBar.Size = UDim2.new(1, 0, 0, 20)
                SearchBar.LayoutOrder = -20000 -- Ensure it's always at the very top
				SearchBar.Parent = ScrollSelect

				SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
					local searchText = SearchBar.Text:lower()
					for _, optionFrame in ipairs(ScrollSelect:GetChildren()) do
						if optionFrame:IsA("Frame") and optionFrame.Name == "Option" then
							local optionText = optionFrame.OptionText.Text:lower()
							optionFrame.Visible = optionText:find(searchText) ~= nil
						end
					end
                    task.wait()
                    local visibleOffsetY = SearchBar.AbsoluteSize.Y + UIListLayout4.Padding.Offset
                    for _, child in ipairs(ScrollSelect:GetChildren()) do
                        if child:IsA("GuiObject") and child ~= SearchBar and child ~= UIListLayout4 and child.Visible then
                            visibleOffsetY = visibleOffsetY + child.AbsoluteSize.Y + UIListLayout4.Padding.Offset
                        end
                    end
                    ScrollSelect.CanvasSize = UDim2.new(0,0,0, visibleOffsetY)
				end)
				UIListLayout4.Padding = UDim.new(0, 3)
				UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout4.Parent = ScrollSelect

				local DropCount = 0
				function DropdownFunc:Clear()
					for _, DropFrame in ipairs(ScrollSelect:GetChildren()) do
						if DropFrame.Name == "Option" then
							DropFrame:Destroy()
						end
					end
                    DropdownFunc.Value = DropdownConfig.Multi and {} or nil
					DropdownFunc.Options = {}
					OptionSelecting.Text = "Select Options"
                    DropCount = 0
                    ScrollSelect.CanvasSize = UDim2.new(0,0,0,SearchBar.AbsoluteSize.Y + UIListLayout4.Padding.Offset) 
				end
				function DropdownFunc:AddOption(OptionName, IsDefault)
					OptionName = OptionName or "Option"
					local Option = Instance.new("Frame");
                    Option.InitialLayoutOrder = DropCount 
					Option:SetAttribute("CreationOrder", DropCount) -- For advanced dropdown sorting
					local UICorner37 = Instance.new("UICorner");
					local OptionButton = Instance.new("TextButton");
					local OptionText = Instance.new("TextLabel")
					local ChooseFrame = Instance.new("Frame");
					local UIStroke15 = Instance.new("UIStroke");
					local UICorner38 = Instance.new("UICorner");
					
					Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Option.BackgroundTransparency = 0.999
					Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Option.BorderSizePixel = 0
					Option.LayoutOrder = Option.InitialLayoutOrder 
					Option.Size = UDim2.new(1, 0, 0, CurrentTheme.Sizes.DropdownItemHeight)
					Option.Name = "Option"
					Option.Parent = ScrollSelect
				
					UICorner37.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
					UICorner37.Parent = Option
				
					OptionButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
					OptionButton.Text = ""
					OptionButton.TextColor3 = CurrentTheme.Colors.TextVeryLight
					OptionButton.TextSize = 13
					OptionButton.TextXAlignment = Enum.TextXAlignment.Left
					OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionButton.BackgroundTransparency = 0.9990000128746033
					OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionButton.BorderSizePixel = 0
					OptionButton.Size = UDim2.new(1, 0, 1, 0)
					OptionButton.Name = "OptionButton"
					OptionButton.Parent = Option

					OptionText.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
					OptionText.Text = OptionName
					OptionText.TextSize = 13
					OptionText.TextColor3 = CurrentTheme.Colors.TextLight
					OptionText.TextXAlignment = Enum.TextXAlignment.Left
					OptionText.TextYAlignment = Enum.TextYAlignment.Center 
                    OptionText.Position = UDim2.new(0, 8, 0.5, 0) 
                    OptionText.AnchorPoint = Vector2.new(0, 0.5)
					OptionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionText.BackgroundTransparency = 0.9990000128746033
					OptionText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionText.BorderSizePixel = 0
					OptionText.Size = UDim2.new(1, -100, 0, 13)
					OptionText.Name = "OptionText"
					OptionText.Parent = Option
	
					ChooseFrame.AnchorPoint = Vector2.new(0, 0.5)
					ChooseFrame.BackgroundColor3 = CurrentTheme.Colors.ThemeHighlight
					ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ChooseFrame.BorderSizePixel = 0
					ChooseFrame.Position = UDim2.new(0, 2, 0.5, 0)
					ChooseFrame.Size = UDim2.new(0, 0, 0, 0)
					ChooseFrame.Name = "ChooseFrame"
					ChooseFrame.Parent = Option
				
					UIStroke15.Color = CurrentTheme.Colors.ThemeHighlight -- Assuming GuiConfig.Color is ThemeHighlight
					UIStroke15.Thickness = 1.600000023841858
					UIStroke15.Transparency = 0.999
					UIStroke15.Parent = ChooseFrame
				
					UICorner38.Parent = ChooseFrame
                    UICorner38.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius

					OptionButton.Activated:Connect(function()
						CircleClick(OptionButton, Mouse.X, Mouse.Y) 
						if DropdownConfig.Multi then
                            local foundIndex = table.find(DropdownFunc.Value, OptionName)
							if not foundIndex then
								table.insert(DropdownFunc.Value, OptionName)
							else
								table.remove(DropdownFunc.Value, foundIndex)
							end
							DropdownFunc:Set(DropdownFunc.Value)
						else
							DropdownFunc.Value = OptionName 
							DropdownFunc:Set(DropdownFunc.Value)
                            if MoreBlur.Visible then
                                ConnectButton.Activated:Fire() 
                            end
						end
					end)
					local OffsetY = SearchBar.AbsoluteSize.Y + UIListLayout4.Padding.Offset
					for _, child in ipairs(ScrollSelect:GetChildren()) do
						if child:IsA("GuiObject") and child ~= SearchBar and child ~= UIListLayout4 and child.Visible then
							OffsetY = OffsetY + child.AbsoluteSize.Y + UIListLayout4.Padding.Offset
						end
					end
					ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
					DropCount = DropCount + 1
				end

				function DropdownFunc:Set(Value, fromDependency)
					local oldValue = DropdownFunc.Value
					if DropdownConfig.Multi and type(oldValue) == "table" then
						local oldTableCopy = {}
						for _, v_old_item in ipairs(oldValue) do table.insert(oldTableCopy, v_old_item) end
						oldValue = oldTableCopy
					end

					DropdownFunc.Value = Value

					for _, Drop in ipairs(ScrollSelect:GetChildren()) do
						if Drop:IsA("Frame") and Drop.Name == "Option" then
                            local isSelected
                            if DropdownConfig.Multi then
                                isSelected = table.find(DropdownFunc.Value, Drop.OptionText.Text)
                            else
                                isSelected = (DropdownFunc.Value == Drop.OptionText.Text)
                            end

							local tweenInfoInOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
							local Size = isSelected and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0)
							local BackgroundTransparency = isSelected and 0.935 or 0.999
							local StrokeTransparency = isSelected and 0 or 0.999
							TweenService:Create(Drop.ChooseFrame, tweenInfoInOut, {Size = Size}):Play()
							TweenService:Create(Drop.ChooseFrame.UIStroke, tweenInfoInOut, {Transparency = StrokeTransparency}):Play()
							TweenService:Create(Drop, tweenInfoInOut, {BackgroundTransparency = BackgroundTransparency}):Play()

                            if DropdownConfig.Multi then 
                                if isSelected then
                                    Drop.LayoutOrder = -10000 + (Drop:GetAttribute("CreationOrder") or 0)
                                else
                                    Drop.LayoutOrder = Drop:GetAttribute("CreationOrder") or 0
                                end
                            end
						end
					end
                    
					local valueChanged = false
					if DropdownConfig.Multi then
						if type(DropdownFunc.Value) == "table" and type(oldValue) == "table" then
							if #DropdownFunc.Value ~= #oldValue then
								valueChanged = true
							else
								local valSet = {}
								for _,v_set in ipairs(DropdownFunc.Value) do valSet[tostring(v_set)] = true end
								for _,old_v_set in ipairs(oldValue) do
									if not valSet[tostring(old_v_set)] then valueChanged = true; break end
								end
								if not valueChanged then
									local oldValSet = {}
									for _,v_set in ipairs(oldValue) do oldValSet[tostring(v_set)] = true end
									for _,cur_v_set in ipairs(DropdownFunc.Value) do
										if not oldValSet[tostring(cur_v_set)] then valueChanged = true; break end
									end
								end
							end
						elseif DropdownFunc.Value ~= oldValue then
							valueChanged = true
						end
					else
						if DropdownFunc.Value ~= oldValue then
							valueChanged = true
						end
					end

                    if DropdownConfig.Multi then
                        local selectedCount = #DropdownFunc.Value
                        if selectedCount == 0 then
                            OptionSelecting.Text = "Select Options"
                        else
                            OptionSelecting.Text = selectedCount .. (selectedCount == 1 and " item selected" or " items selected")
                        end
                    else 
                        if DropdownFunc.Value and DropdownFunc.Value ~= "" then
                            OptionSelecting.Text = tostring(DropdownFunc.Value)
                        else
                            OptionSelecting.Text = "Select Options"
                        end
                    end

					if not fromDependency then
						DropdownConfig.Callback(DropdownFunc.Value)
						if DropdownConfig.Flag and typeof(DropdownConfig.Flag) == "string" then
							local valueToSave
							if DropdownConfig.Multi then
								valueToSave = DropdownFunc.Value
							else
								valueToSave = {DropdownFunc.Value}
							end
							SaveFile(DropdownConfig.Flag, valueToSave)
						end
						if valueChanged then
							DropdownFunc.Changed:Fire(DropdownFunc.Value)
						end
					end
				end

				function DropdownFunc:Refresh(RefreshList, Selecting, fromDependencyInternal)
                    local valueToSelect = Selecting
                    if not fromDependencyInternal and DropdownConfig.Flag then
                        valueToSelect = ConfigManager:GetFlag(DropdownConfig.Flag, Selecting)
                    end

					RefreshList = RefreshList or {}
                    if DropdownConfig.Multi then
                        if type(valueToSelect) ~= "table" then valueToSelect = (valueToSelect ~= nil) and {valueToSelect} or {} end
                    else
                        if type(valueToSelect) == "table" then valueToSelect = valueToSelect[1] end
                    end

                    DropdownFunc:Clear() 
                    DropdownFunc.Value = DropdownConfig.Multi and {} or nil 

					for _, DropName in ipairs(RefreshList) do
						DropdownFunc:AddOption(DropName)
					end
					DropdownFunc.Options = RefreshList
					DropdownFunc:Set(valueToSelect, true)
				end
				DropdownFunc:Refresh(DropdownFunc.Options, DropdownFunc.Value, true)

				if DropdownConfig.Flag then
					ConfigManager:RegisterUIElement(DropdownConfig.Flag, function(val)
						DropdownFunc:Refresh(DropdownFunc.Options, val, true)
					end)
				end

				local isLockedByDependency = function() return false end
				function DropdownFunc:AddDependency(depConfig)
					isLockedByDependency = HandleDependency(Dropdown, depConfig, UpdateSizeSection, DropdownButton, self)
				end
				if DropdownConfig.Dependency then
					DropdownFunc:AddDependency(DropdownConfig.Dependency)
				end

				DropdownButton.Activated:ClearAllChildren()
				DropdownButton.Activated:Connect(function()
					if isLockedByDependency() then return end

					CircleClick(DropdownButton, Mouse.X, Mouse.Y)
					if not MoreBlur.Visible then
						MoreBlur.Visible = true
						DropPageLayout:JumpToIndex(SelectOptionsFrame.LayoutOrder)
						SearchBar.Text = ""
						ScrollSelect.CanvasPosition = Vector2.new(0,0)

						for _, optionFrame_iter in ipairs(ScrollSelect:GetChildren()) do
							if optionFrame_iter:IsA("Frame") and optionFrame_iter.Name == "Option" then
								local optionText = optionFrame_iter.OptionText.Text
								local isSelected_sort = false
								if DropdownConfig.Multi then
									isSelected_sort = table.find(DropdownFunc.Value, optionText)
								else
									isSelected_sort = (DropdownFunc.Value == optionText)
								end

								local creationOrder = optionFrame_iter:GetAttribute("CreationOrder") or 0
								if isSelected_sort then
									optionFrame_iter.LayoutOrder = -10000 + creationOrder
								else
									optionFrame_iter.LayoutOrder = creationOrder
								end
							end
						end
						SearchBar.LayoutOrder = -20000

						TweenService:Create(MoreBlur, TweenInfo.new(0.01), {BackgroundTransparency = 0.7}):Play()
						TweenService:Create(DropdownSelect, TweenInfo.new(0.01), {Position = UDim2.new(1, -11, 0.5, 0)}):Play()
					end
				end)


				CountItem = CountItem + 1
				CountDropdown = CountDropdown + 1

				table.insert(GuiFunc.SearchableElements, {
					Title = DropdownConfig.Title,
					Content = DropdownConfig.Content,
					Type = "Dropdown",
					UIInstance = Dropdown,
					SectionName = currentSectionNameForSearch,
					TabName = currentTabNameForSearch,
					OpenFunction = function()
						if LayersPageLayout.CurrentPage ~= currentTabPageInstanceForSearch then
							LayersPageLayout:JumpTo(currentTabPageInstanceForSearch)
						end
						NameTab.Text = currentTabNameForSearch
						if not OpenSection then OpenSection = true; UpdateSizeSection() end
						task.wait(0.3)
						ScrolLayers.CanvasPosition = Vector2.new(0, Dropdown.AbsolutePosition.Y - ScrolLayers.AbsolutePosition.Y)
					end
				})
				return DropdownFunc
			end

			function Items:AddColorPicker(ColorPickerConfig)
				local ColorPickerConfig = ColorPickerConfig or {}
				local currentTabNameForSearch = NameTab.Text
				local currentSectionNameForSearch = Title
				local currentTabPageInstanceForSearch = ScrolLayers
				local currentSectionInstanceForSearch = Section
				ColorPickerConfig.Title = ColorPickerConfig.Title or "Color Picker"
				ColorPickerConfig.Default = ColorPickerConfig.Default or Color3.fromRGB(255, 255, 255)
				ColorPickerConfig.Callback = ColorPickerConfig.Callback or function() end
				ColorPickerConfig.Flag = ColorPickerConfig.Flag or nil
				ColorPickerConfig.Dependency = ColorPickerConfig.Dependency or nil

				local ColorPickerFunc = {Value = ColorPickerConfig.Default}
				ColorPickerFunc.Changed = Instance.new("BindableEvent")

				local PickerButtonFrame = Instance.new("Frame")
				PickerButtonFrame.Name = "ColorPickerButtonFrame"
				PickerButtonFrame.BackgroundColor3 = CurrentTheme.Colors.BackgroundLight
				PickerButtonFrame.BackgroundTransparency = 0
				PickerButtonFrame.BorderSizePixel = 0
				PickerButtonFrame.LayoutOrder = CountItem
				PickerButtonFrame.Size = UDim2.new(1, 0, 0, 36)
				PickerButtonFrame.Parent = SectionAdd

				local UICorner_PickerButton = Instance.new("UICorner")
				UICorner_PickerButton.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
				UICorner_PickerButton.Parent = PickerButtonFrame

				local PickerLabel = Instance.new("TextLabel")
				PickerLabel.Name = "PickerLabel"
				PickerLabel.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				PickerLabel.Text = ColorPickerConfig.Title
				PickerLabel.TextColor3 = CurrentTheme.Colors.TextLight
				PickerLabel.TextSize = 13
				PickerLabel.TextXAlignment = Enum.TextXAlignment.Left
				PickerLabel.BackgroundTransparency = 1
				PickerLabel.Position = UDim2.new(0, 10, 0.5, 0)
				PickerLabel.AnchorPoint = Vector2.new(0, 0.5)
				PickerLabel.Size = UDim2.new(0, 200, 1, 0)
				PickerLabel.Parent = PickerButtonFrame

				local ColorSwatch = Instance.new("Frame")
				ColorSwatch.Name = "ColorSwatch"
				ColorSwatch.BackgroundColor3 = ColorPickerFunc.Value
				ColorSwatch.Size = UDim2.new(0, 24, 0, 24)
				ColorSwatch.Position = UDim2.new(1, -10, 0.5, 0)
				ColorSwatch.AnchorPoint = Vector2.new(1, 0.5)
				ColorSwatch.Parent = PickerButtonFrame
				local UICorner_Swatch = Instance.new("UICorner")
				UICorner_Swatch.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
				UICorner_Swatch.Parent = ColorSwatch
				local UIStroke_Swatch = Instance.new("UIStroke")
				UIStroke_Swatch.Color = CurrentTheme.Colors.Stroke
				UIStroke_Swatch.Thickness = 1
				UIStroke_Swatch.Parent = ColorSwatch

				local PickerButton = Instance.new("TextButton")
				PickerButton.Name = "PickerButton"
				PickerButton.Text = ""
				PickerButton.BackgroundTransparency = 1
				PickerButton.Size = UDim2.new(1, 0, 1, 0)
				PickerButton.Parent = PickerButtonFrame

				local PickerPopup = Instance.new("Frame")
				PickerPopup.Name = "ColorPickerPopup"
				PickerPopup.Visible = false
				PickerPopup.Size = UDim2.fromOffset(280, 320)
				PickerPopup.Position = UDim2.fromScale(0.5, 0.5)
				PickerPopup.AnchorPoint = Vector2.new(0.5, 0.5)
				PickerPopup.BackgroundColor3 = CurrentTheme.Colors.Background
				PickerPopup.BorderSizePixel = 1
				PickerPopup.BorderColor3 = CurrentTheme.Colors.Stroke
				PickerPopup.ZIndex = 100
				PickerPopup.Parent = UBHubGui


				local UICorner_Popup = Instance.new("UICorner")
				UICorner_Popup.CornerRadius = CurrentTheme.Sizes.LargeCornerRadius
				UICorner_Popup.Parent = PickerPopup

				local PopupHeader = Instance.new("TextLabel")
				PopupHeader.Name = "PopupHeader"
				PopupHeader.Size = UDim2.new(1,0,0,30)
				PopupHeader.BackgroundColor3 = CurrentTheme.Colors.BackgroundLight
				PopupHeader.Text = ColorPickerConfig.Title
				PopupHeader.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				PopupHeader.TextColor3 = CurrentTheme.Colors.Text
				PopupHeader.TextSize = 14
				PopupHeader.Parent = PickerPopup
				local UICorner_Header = Instance.new("UICorner")
				UICorner_Header.CornerRadius = CurrentTheme.Sizes.LargeCornerRadius
				UICorner_Header.Parent = PopupHeader
				UICorner_Header.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

				MakeDraggable(PopupHeader, PickerPopup)

				local SaturationValueFrame = Instance.new("Frame")
				SaturationValueFrame.Name = "SaturationValueFrame"
				SaturationValueFrame.Size = UDim2.fromOffset(200, 200)
				SaturationValueFrame.Position = UDim2.new(0.5, 0, 0, 40)
				SaturationValueFrame.AnchorPoint = Vector2.new(0.5, 0)
				SaturationValueFrame.BackgroundColor3 = Color3.new(1,1,1)
				SaturationValueFrame.Parent = PickerPopup

				local HueSlider = Instance.new("Frame")
				HueSlider.Name = "HueSlider"
				HueSlider.Size = UDim2.new(0, 200, 0, 20)
				HueSlider.Position = UDim2.new(0.5, 0, 0, 250)
				HueSlider.AnchorPoint = Vector2.new(0.5, 0)
				HueSlider.BackgroundColor3 = Color3.new(0.7,0.7,0.7)
				HueSlider.Parent = PickerPopup

				local ConfirmButton = Instance.new("TextButton")
				ConfirmButton.Name = "ConfirmButton"
				ConfirmButton.Size = UDim2.new(0.4, -5, 0, 30)
				ConfirmButton.Position = UDim2.new(0.25, 0, 1, -40)
				ConfirmButton.AnchorPoint = Vector2.new(0.5,1)
				ConfirmButton.BackgroundColor3 = CurrentTheme.Colors.Accent
				ConfirmButton.Text = "Confirm"
				ConfirmButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				ConfirmButton.TextColor3 = CurrentTheme.Colors.Text
				ConfirmButton.Parent = PickerPopup
				local UICorner_Confirm = Instance.new("UICorner")
				UICorner_Confirm.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
				UICorner_Confirm.Parent = ConfirmButton

				local CancelButton = Instance.new("TextButton")
				CancelButton.Name = "CancelButton"
				CancelButton.Size = UDim2.new(0.4, -5, 0, 30)
				CancelButton.Position = UDim2.new(0.75, 0, 1, -40)
				CancelButton.AnchorPoint = Vector2.new(0.5,1)
				CancelButton.BackgroundColor3 = CurrentTheme.Colors.Secondary
				CancelButton.Text = "Cancel"
				CancelButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
				CancelButton.TextColor3 = CurrentTheme.Colors.Text
				CancelButton.Parent = PickerPopup
				local UICorner_Cancel = Instance.new("UICorner")
				UICorner_Cancel.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
				UICorner_Cancel.Parent = CancelButton

				local isLockedByDependency = function() return false end
				if ColorPickerConfig.Dependency then
					isLockedByDependency = HandleDependency(PickerButtonFrame, ColorPickerConfig.Dependency, UpdateSizeSection, PickerButton, ColorPickerFunc)
				end

				PickerButton.Activated:Connect(function()
					if isLockedByDependency() then return end
					CircleClick(PickerButton, Mouse.X, Mouse.Y)
					PickerPopup.Visible = not PickerPopup.Visible
					if PickerPopup.Visible then
						-- TODO: Initialize picker with ColorPickerFunc.Value
						PickerPopup:TweenSizeAndPosition(
							UDim2.fromOffset(280,320), UDim2.fromScale(0.5,0.5),
							"Out", "Quad", 0.2, true
						)
					end
				end)

				ConfirmButton.Activated:Connect(function()
					-- TODO: Get color from picker UI
					local newColor = ColorPickerFunc.Value -- Placeholder
					local oldValue = ColorPickerFunc.Value
					ColorPickerFunc.Value = newColor
					ColorSwatch.BackgroundColor3 = ColorPickerFunc.Value
					ColorPickerConfig.Callback(ColorPickerFunc.Value)
					if ColorPickerConfig.Flag then SaveFile(ColorPickerConfig.Flag, {newColor.R*255, newColor.G*255, newColor.B*255}) end
					if oldValue ~= newColor then ColorPickerFunc.Changed:Fire(newColor) end
					PickerPopup.Visible = false
				end)

				CancelButton.Activated:Connect(function()
					PickerPopup.Visible = false
				end)

				function ColorPickerFunc:Set(value, fromDependency)
					local oldValue = ColorPickerFunc.Value
					ColorPickerFunc.Value = value
					ColorSwatch.BackgroundColor3 = value
					-- TODO: Update picker UI if visible
					if not fromDependency then
						ColorPickerConfig.Callback(value)
						if ColorPickerConfig.Flag then
							SaveFile(ColorPickerConfig.Flag, {value.R * 255, value.G * 255, value.B * 255})
						end
						if oldValue ~= value then
							ColorPickerFunc.Changed:Fire(value)
						end
					end
				end

                if ColorPickerConfig.Flag then
                    local loadedColorData = ConfigManager:GetFlag(ColorPickerConfig.Flag)
                    if type(loadedColorData) == "table" and #loadedColorData == 3 then
						local loadedC3 = Color3.fromRGB(loadedColorData[1], loadedColorData[2], loadedColorData[3])
                        ColorPickerFunc:Set(loadedC3, true)
                    end
                else
					ColorPickerFunc:Set(ColorPickerConfig.Default, true) -- Set default without firing callback initially
				end

				function ColorPickerFunc:AddDependency(depConfig)
					isLockedByDependency = HandleDependency(PickerButtonFrame, depConfig, UpdateSizeSection, PickerButton, self)
				end
				if ColorPickerConfig.Dependency then
					ColorPickerFunc:AddDependency(ColorPickerConfig.Dependency)
				end


				CountItem = CountItem + 1

				table.insert(GuiFunc.SearchableElements, {
					Title = ColorPickerConfig.Title,
					Content = "", -- Color pickers typically don't have a secondary content line in the main UI
					Type = "ColorPicker",
					UIInstance = PickerButtonFrame,
					SectionName = currentSectionNameForSearch,
					TabName = currentTabNameForSearch,
					OpenFunction = function()
						if LayersPageLayout.CurrentPage ~= currentTabPageInstanceForSearch then
							LayersPageLayout:JumpTo(currentTabPageInstanceForSearch)
						end
						NameTab.Text = currentTabNameForSearch
						if not OpenSection then OpenSection = true; UpdateSizeSection() end
						task.wait(0.3)
						ScrolLayers.CanvasPosition = Vector2.new(0, PickerButtonFrame.AbsolutePosition.Y - ScrolLayers.AbsolutePosition.Y)
					end
				})
				return ColorPickerFunc
			end

			CountSection = CountSection + 1
			return Items
		end
		CountTab = CountTab + 1
		return Sections
	end

	function Items:AddFrame(FrameConfig) -- Added to the Items table context
		local FrameConfig = FrameConfig or {}
		FrameConfig.Size = FrameConfig.Size or UDim2.new(1, 0, 0, 30)
		FrameConfig.Color = FrameConfig.Color -- Can be theme color name, Color3, or ColorSequence
		FrameConfig.LayoutOrder = FrameConfig.LayoutOrder or CountItem -- Use current CountItem

		local DisplayFrame = Instance.new("Frame")
		DisplayFrame.Name = FrameConfig.Name or "DisplayFrame"
		DisplayFrame.Size = FrameConfig.Size
		DisplayFrame.LayoutOrder = FrameConfig.LayoutOrder
		DisplayFrame.BorderSizePixel = 0
		DisplayFrame.Parent = SectionAdd -- Assumes SectionAdd is the correct parent from Items context

		if FrameConfig.Color then
			local colorValue = GetColor(FrameConfig.Color) -- Use GetColor to resolve theme names
			if typeof(colorValue) == "ColorSequence" then
				DisplayFrame.BackgroundColor3 = colorValue.Keypoints[1].Value -- Set a base color
				local gradient = Instance.new("UIGradient")
				gradient.Color = colorValue
				gradient.Parent = DisplayFrame
			elseif typeof(colorValue) == "Color3" then
				DisplayFrame.BackgroundColor3 = colorValue
			else -- Direct Color3 or ColorSequence value
				if typeof(FrameConfig.Color) == "ColorSequence" then
					DisplayFrame.BackgroundColor3 = FrameConfig.Color.Keypoints[1].Value
					local gradient = Instance.new("UIGradient")
					gradient.Color = FrameConfig.Color
					gradient.Parent = DisplayFrame
				elseif typeof(FrameConfig.Color) == "Color3" then
					DisplayFrame.BackgroundColor3 = FrameConfig.Color
				else
					DisplayFrame.BackgroundColor3 = Color3.fromRGB(100,100,100) -- Default fallback
				end
			end
		else
			DisplayFrame.BackgroundTransparency = 1 -- Transparent if no color
		end

		local UICorner_DisplayFrame = Instance.new("UICorner")
		UICorner_DisplayFrame.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
		UICorner_DisplayFrame.Parent = DisplayFrame

		CountItem = CountItem + 1
		UpdateSizeSection() -- Ensure section resizes
		return DisplayFrame -- Return the frame instance
	end


	function Tabs:AddStaticTab(TabConfig)
		local TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "StaticTab"
		TabConfig.IconName = TabConfig.IconName or nil -- Was TabConfig.Icon
		TabConfig.IconLibrary = TabConfig.IconLibrary or "lucide"

		-- Create the page content frame first (similar to CreateTab)
		local ScrolLayers = Instance.new("ScrollingFrame")
		local staticTabNameForSearch = TabConfig.Name -- Capture static tab name
		ScrolLayers.Name = TabConfig.Name .. "_Page" -- Ensure unique name for page
		ScrolLayers.ScrollBarImageColor3 = CurrentTheme.Colors.Stroke
		ScrolLayers.ScrollBarThickness = 0
		ScrolLayers.Active = true
		ScrolLayers.LayoutOrder = CountTab -- Use a high layout order to ensure it's at the end if pages are sorted
		ScrolLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrolLayers.BackgroundTransparency = 0.999
		ScrolLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrolLayers.BorderSizePixel = 0
		ScrolLayers.Size = UDim2.new(1, 0, 1, 0)
		ScrolLayers.Parent = LayersFolder

		local UIListLayout1 = Instance.new("UIListLayout")
		UIListLayout1.Padding = CurrentTheme.Sizes.SectionItemPadding
		UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout1.Parent = ScrolLayers

		-- Create the static tab button
		local TabButtonFrame = Instance.new("Frame")
		TabButtonFrame.Name = TabConfig.Name .. "_Button"
		TabButtonFrame.BackgroundTransparency = 0.999
		TabButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButtonFrame.BorderSizePixel = 0
		TabButtonFrame.LayoutOrder = TabConfig.LayoutOrder or 0 -- Allow custom ordering if needed
		TabButtonFrame.Size = UDim2.new(1, 0, 0, CurrentTheme.Sizes.TabButtonHeight)
		TabButtonFrame.Parent = StaticTabsContainer

		local UICorner_TabBtn = Instance.new("UICorner")
		UICorner_TabBtn.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
		UICorner_TabBtn.Parent = TabButtonFrame

		local ActualButton = Instance.new("TextButton")
		ActualButton.Name = "TabButton"
		ActualButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
		ActualButton.Text = "" -- Icon will be primary visual
		ActualButton.TextColor3 = CurrentTheme.Colors.TextVeryLight
		ActualButton.TextSize = 13
		ActualButton.BackgroundTransparency = 1
		ActualButton.Size = UDim2.new(1,0,1,0)
		ActualButton.Parent = TabButtonFrame

		local TabNameLabel = Instance.new("TextLabel")
		TabNameLabel.Name = "TabName"
		TabNameLabel.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
		TabNameLabel.Text = TabConfig.Name
		TabNameLabel.TextColor3 = CurrentTheme.Colors.TextVeryLight
		TabNameLabel.TextSize = 13
		TabNameLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabNameLabel.BackgroundTransparency = 1
		TabNameLabel.Size = UDim2.new(1, 0, 1, 0)
		TabNameLabel.Position = UDim2.new(0, 30, 0, 0) -- Assuming icon is to the left
		TabNameLabel.Parent = TabButtonFrame

		local FeatureImageLabel = Instance.new("ImageLabel")
		FeatureImageLabel.Name = "FeatureImg"
		FeatureImageLabel.Image = TabConfig.Icon
		FeatureImageLabel.BackgroundTransparency = 1
		FeatureImageLabel.Position = UDim2.new(0, 9, 0.5, 0)
		FeatureImageLabel.AnchorPoint = Vector2.new(0, 0.5)
		FeatureImageLabel.Size = UDim2.fromOffset(16,16)
		FeatureImageLabel.Parent = TabButtonFrame
		if TabConfig.IconName then
			local iconInfo = ExternalIconManager.Icon(TabConfig.IconName, TabConfig.IconLibrary)
			if iconInfo then
				FeatureImageLabel.Image = iconInfo[1]
				local iconData = iconInfo[2]
				FeatureImageLabel.ImageRectOffset = iconData.ImageRectOffset
				FeatureImageLabel.ImageRectSize = iconData.ImageRectSize
			else
				warn("Static tab icon '" .. TabConfig.IconName .. "' (" .. TabConfig.IconLibrary .. ") not found.")
				FeatureImageLabel.Visible = false
			end
		else
			FeatureImageLabel.Visible = false
		end

		-- Selection Indicator (similar to normal tabs)
		local ChooseFrame = Instance.new("Frame")
		ChooseFrame.Name = "ChooseFrame"
		ChooseFrame.BackgroundColor3 = CurrentTheme.Colors.ThemeHighlight
		ChooseFrame.BorderColor3 = Color3.fromRGB(0,0,0)
		ChooseFrame.BorderSizePixel = 0
		ChooseFrame.Position = UDim2.new(0,2,0.5,0)
		ChooseFrame.AnchorPoint = Vector2.new(0, 0.5)
		ChooseFrame.Size = UDim2.new(0,0,0,12) -- Initially hidden/small
		ChooseFrame.Visible = false -- Hide initially
		ChooseFrame.Parent = TabButtonFrame
		local UICorner_Choose = Instance.new("UICorner")
		UICorner_Choose.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
		UICorner_Choose.Parent = ChooseFrame


		ActualButton.Activated:Connect(function()
			CircleClick(ActualButton, Mouse.X, Mouse.Y)

			-- Deselect all other tabs (both normal and static)
			for _, child in ipairs(ScrollTab:GetChildren()) do
				if child:IsA("Frame") and child.Name == "Tab" then
					child.BackgroundTransparency = 0.999
					local cf = child:FindFirstChild("ChooseFrame")
					if cf then cf.Visible = false end
				end
			end
			for _, child in ipairs(StaticTabsContainer:GetChildren()) do
				if child:IsA("Frame") and child:FindFirstChild("TabButton") then
					child.BackgroundTransparency = 0.999
					local cf = child:FindFirstChild("ChooseFrame")
					if cf then cf.Visible = false end
				end
			end

			-- Select this static tab
			TabButtonFrame.BackgroundTransparency = 0.920 -- Highlight BG
			ChooseFrame.Visible = true
			ChooseFrame:TweenSize(UDim2.new(0,1,0,20), "Out", "Quad", 0.1)


			LayersPageLayout:JumpTo(ScrolLayers) -- Jump to the static tab's page
			NameTab.Text = TabConfig.Name -- Update the main title display
		end)

		AdjustScrollTabSize() -- Call to adjust size after adding

		local Sections = {}
		local CountSection = 0
		-- Copy AddSection structure from CreateTab, but parent items to ScrolLayers
		function Sections:AddSection(Title)
			local Title = Title or "Title"
			local Section = Instance.new("Frame");
			local SectionDecideFrame = Instance.new("Frame");
			local UICorner1_Section = Instance.new("UICorner");
			local UIGradient_Section = Instance.new("UIGradient");

			Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Section.BackgroundTransparency = 0.9990000128746033
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.LayoutOrder = CountSection
			Section.ClipsDescendants = true
			Section.Size = UDim2.new(1, 0, 0, CurrentTheme.Sizes.SectionHeaderHeight)
			Section.Name = "Section"
			Section.Parent = ScrolLayers -- Items for static tab go into its own page

			local SectionReal = Instance.new("Frame");
			local UICorner_SectionReal = Instance.new("UICorner");
			local SectionButton = Instance.new("TextButton");
			local FeatureFrame_Section = Instance.new("Frame");
			local FeatureImg_Sect = Instance.new("ImageLabel");
			local SectionTitle_Label = Instance.new("TextLabel");

			SectionReal.AnchorPoint = Vector2.new(0.5, 0)
			SectionReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionReal.BackgroundTransparency = 0.9350000023841858
			SectionReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionReal.BorderSizePixel = 0
			SectionReal.LayoutOrder = 1
			SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
			SectionReal.Size = UDim2.new(1, 1, 0, CurrentTheme.Sizes.SectionHeaderHeight)
			SectionReal.Name = "SectionReal"
			SectionReal.Parent = Section

			UICorner_SectionReal.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
			UICorner_SectionReal.Parent = SectionReal

			SectionButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Secondary)
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
			FeatureFrame_Section.Size = CurrentTheme.Sizes.ActionIconSize
			FeatureFrame_Section.Name = "FeatureFrame"
			FeatureFrame_Section.Parent = SectionReal

			FeatureImg_Sect.Image = "rbxassetid://16851841101" -- Default Arrow
			FeatureImg_Sect.AnchorPoint = Vector2.new(0.5, 0.5)
			FeatureImg_Sect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeatureImg_Sect.BackgroundTransparency = 0.9990000128746033
			FeatureImg_Sect.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureImg_Sect.BorderSizePixel = 0
			FeatureImg_Sect.Position = UDim2.new(0.5, 0, 0.5, 0)
			FeatureImg_Sect.Rotation = -90
			FeatureImg_Sect.Size = UDim2.new(1, 6, 1, 6)
			FeatureImg_Sect.Name = "FeatureImg"
			FeatureImg_Sect.Parent = FeatureFrame_Section

			SectionTitle_Label.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
			SectionTitle_Label.Text = Title
			SectionTitle_Label.TextColor3 = CurrentTheme.Colors.TextLight
			SectionTitle_Label.TextSize = 13
			SectionTitle_Label.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle_Label.TextYAlignment = Enum.TextYAlignment.Top
			SectionTitle_Label.AnchorPoint = Vector2.new(0, 0.5)
			SectionTitle_Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle_Label.BackgroundTransparency = 0.9990000128746033
			SectionTitle_Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionTitle_Label.BorderSizePixel = 0
			SectionTitle_Label.Position = UDim2.new(0, 10, 0.5, 0)
			SectionTitle_Label.Size = UDim2.new(1, -50, 0, 13)
			SectionTitle_Label.Name = "SectionTitle"
			SectionTitle_Label.Parent = SectionReal

			SectionDecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionDecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionDecideFrame.AnchorPoint = Vector2.new(0.5, 0)
			SectionDecideFrame.BorderSizePixel = 0
			SectionDecideFrame.Position = UDim2.new(0.5, 0, 0, CurrentTheme.Sizes.SectionHeaderHeight + 3)
			SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
			SectionDecideFrame.Name = "SectionDecideFrame"
			SectionDecideFrame.Parent = Section

			UICorner1_Section.Parent = SectionDecideFrame
            UICorner1_Section.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius

			UIGradient_Section.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, CurrentTheme.Colors.Primary),
				ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
				ColorSequenceKeypoint.new(1, CurrentTheme.Colors.Primary)
			}
			UIGradient_Section.Parent = SectionDecideFrame

			local SectionAdd_Frame = Instance.new("Frame");
			local UICorner_SectionAdd = Instance.new("UICorner");
			local UIListLayout_SectionAdd = Instance.new("UIListLayout");

			SectionAdd_Frame.AnchorPoint = Vector2.new(0.5, 0)
			SectionAdd_Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionAdd_Frame.BackgroundTransparency = 0.9990000128746033
			SectionAdd_Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionAdd_Frame.BorderSizePixel = 0
			SectionAdd_Frame.ClipsDescendants = true
			SectionAdd_Frame.LayoutOrder = 1
			SectionAdd_Frame.Position = UDim2.new(0.5, 0, 0, CurrentTheme.Sizes.SectionHeaderHeight + CurrentTheme.Sizes.SectionItemPadding.Offset + 3)
			SectionAdd_Frame.Size = UDim2.new(1, 0, 0, 100)
			SectionAdd_Frame.Name = "SectionAdd"
			SectionAdd_Frame.Parent = Section

			UICorner_SectionAdd.CornerRadius = CurrentTheme.Sizes.SmallCornerRadius
			UICorner_SectionAdd.Parent = SectionAdd_Frame

			UIListLayout_SectionAdd.Padding = CurrentTheme.Sizes.SectionItemPadding
			UIListLayout_SectionAdd.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_SectionAdd.Parent = SectionAdd_Frame

			local OpenSection = true
			local function UpdateSizeScroll_Static()
				task.wait()
				local totalHeight = 0
				for _, child_s in ipairs(ScrolLayers:GetChildren()) do
					if child_s:IsA("Frame") and child_s ~= UIListLayout1 then
						totalHeight += child_s.AbsoluteSize.Y + UIListLayout1.Padding.Offset
					end
				end
				ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
			end
            local isUpdatingSectionSize_Static = false
			local function UpdateSizeSection_Static()
                if isUpdatingSectionSize_Static then return end
                isUpdatingSectionSize_Static = true
                task.wait()

				if OpenSection then
					local contentHeight = UIListLayout_SectionAdd.AbsoluteContentSize.Y
					local newHeight = (CurrentTheme.Sizes.SectionHeaderHeight + 3) + contentHeight + (contentHeight > 0 and CurrentTheme.Sizes.SectionItemPadding.Offset or 0)
					newHeight = math.max(newHeight, CurrentTheme.Sizes.SectionHeaderHeight)

					TweenService:Create(FeatureImg_Sect, TweenInfo.new(0.3), {Rotation = -90}):Play()
					TweenService:Create(Section, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, newHeight)}):Play() -- Section size includes padding
					TweenService:Create(SectionAdd_Frame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, contentHeight)}):Play()
					TweenService:Create(SectionDecideFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 2)}):Play()
				else
					TweenService:Create(FeatureImg_Sect, TweenInfo.new(0.3), {Rotation = 0}):Play()
					TweenService:Create(Section, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, CurrentTheme.Sizes.SectionHeaderHeight)}):Play()
					TweenService:Create(SectionAdd_Frame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
					TweenService:Create(SectionDecideFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 2)}):Play()
				end
                task.delay(0.3, function()
                    isUpdatingSectionSize_Static = false
                    UpdateSizeScroll_Static()
                end)
			end
			SectionButton.Activated:Connect(function()
				CircleClick(SectionButton, Mouse.X, Mouse.Y)
				OpenSection = not OpenSection
                SectionAdd_Frame.Visible = true
				UpdateSizeSection_Static()
                if not OpenSection then
                    task.delay(0.3, function() SectionAdd_Frame.Visible = false end)
                end
			end)
			SectionAdd_Frame.ChildAdded:Connect(UpdateSizeSection_Static)
			SectionAdd_Frame.ChildRemoved:Connect(UpdateSizeSection_Static)
            UIListLayout_SectionAdd:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSizeSection_Static)
			UpdateSizeSection_Static()

			local StaticItems = {}
			local StaticCountItem = 0

			for itemName, itemFunc in pairs(Items) do
				if type(itemFunc) == "function" then
					StaticItems[itemName] = function(...)
						local args = {...}
						local originalParent
						local originalSectionAddRef = SectionAdd
						SectionAdd = SectionAdd_Frame
						local originalCountItemRef = CountItem
						CountItem = StaticCountItem

						local result = itemFunc(unpack(args))

						SectionAdd = originalSectionAddRef
						CountItem = originalCountItemRef
						StaticCountItem = StaticCountItem + 1
						return result
					end
				end
			end
			CountSection = CountSection + 1
			return StaticItems
		end

		return Sections
	end

	return Tabs
end

-- Call ApplyThemeStyleHints after UI is built and default theme is set
GuiFunc:ApplyThemeStyleHints()

function GuiFunc:ShowDialog(DialogConfig)
	local DialogConfig = DialogConfig or {}
	DialogConfig.Title = DialogConfig.Title or "Dialog"
	DialogConfig.Content = DialogConfig.Content or "This is the default dialog content."
	DialogConfig.Buttons = DialogConfig.Buttons or {{Text = "OK", Variant = "Primary"}}
	DialogConfig.CloseOnEsc = DialogConfig.CloseOnEsc == nil and true or DialogConfig.CloseOnEsc
	DialogConfig.HideCloseButton = DialogConfig.HideCloseButton or false
	DialogConfig.Width = DialogConfig.Width or 350
	DialogConfig.MaxContentHeight = DialogConfig.MaxContentHeight or 200

	local DialogOverlay = Instance.new("Frame")
	DialogOverlay.Name = "DialogOverlay"
	DialogOverlay.Size = UDim2.fromScale(1, 1)
	DialogOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
	DialogOverlay.BackgroundTransparency = 0.7
	DialogOverlay.ZIndex = 199
	DialogOverlay.Parent = UBHubGui

	local DialogFrame = Instance.new("Frame")
	DialogFrame.Name = "DialogFrame"
	DialogFrame.Size = UDim2.fromOffset(DialogConfig.Width, 150)
	DialogFrame.Position = UDim2.fromScale(0.5, 0.5)
	DialogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	DialogFrame.BackgroundColor3 = CurrentTheme.Colors.Background
	DialogFrame.BorderSizePixel = 1
	DialogFrame.BorderColor3 = CurrentTheme.Colors.Stroke
	DialogFrame.ZIndex = 200
	DialogFrame.Parent = DialogOverlay

	local UICorner_Dialog = Instance.new("UICorner")
	UICorner_Dialog.CornerRadius = CurrentTheme.Sizes.LargeCornerRadius
	UICorner_Dialog.Parent = DialogFrame

	local DialogListLayout = Instance.new("UIListLayout")
	DialogListLayout.FillDirection = Enum.FillDirection.Vertical
	DialogListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	DialogListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	DialogListLayout.Padding = UDim.new(0,10)
	DialogListLayout.Parent = DialogFrame

	local HeaderFrame = Instance.new("Frame")
	HeaderFrame.Name = "HeaderFrame"
	HeaderFrame.Size = UDim2.new(1, 0, 0, 35)
	HeaderFrame.BackgroundColor3 = CurrentTheme.Colors.BackgroundLight
	HeaderFrame.LayoutOrder = 1
	HeaderFrame.Parent = DialogFrame
	local UICorner_Header = Instance.new("UICorner")
    UICorner_Header.CornerRadius = CurrentTheme.Sizes.LargeCornerRadius
    UICorner_Header.Parent = HeaderFrame


	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "TitleLabel"
	TitleLabel.Size = UDim2.new(1, DialogConfig.HideCloseButton and -20 or -60, 1, 0)
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
	TitleLabel.Text = DialogConfig.Title
	TitleLabel.TextColor3 = CurrentTheme.Colors.Text
	TitleLabel.TextSize = 16
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Parent = HeaderFrame

	local escConnectionHolder = {Value = nil}

	local function CloseDialog()
		if escConnectionHolder.Value then
			escConnectionHolder.Value:Disconnect()
			escConnectionHolder.Value = nil
		end
		if DialogOverlay then
			DialogOverlay:Destroy()
		end
	end

	if not DialogConfig.HideCloseButton then
		local CloseButton = Instance.new("ImageButton")
		CloseButton.Name = "CloseDialogButton"
		CloseButton.Size = UDim2.fromOffset(16,16)
		CloseButton.Position = UDim2.new(1, -10, 0.5, 0)
		CloseButton.AnchorPoint = Vector2.new(1, 0.5)
		local closeIconInfo = ExternalIconManager.Icon("x", "lucide")
		if closeIconInfo then
			CloseButton.Image = closeIconInfo[1]
			local iconData = closeIconInfo[2]
			CloseButton.ImageRectOffset = iconData.ImageRectOffset
			CloseButton.ImageRectSize = iconData.ImageRectSize
		else
			warn("Dialog close icon 'x' (lucide) not found.")
			CloseButton.Image = "rbxassetid://9886659671" -- Fallback
		end
		CloseButton.ImageColor3 = CurrentTheme.Colors.Text
		CloseButton.BackgroundTransparency = 1
		CloseButton.Parent = HeaderFrame
		CloseButton.Activated:Connect(CloseDialog)
	end

	local ContentScroll = Instance.new("ScrollingFrame")
	ContentScroll.Name = "ContentScroll"
	ContentScroll.Size = UDim2.new(1, -20, 0, 10)
	ContentScroll.Position = UDim2.new(0.5,0,0,0)
	ContentScroll.AnchorPoint = Vector2.new(0.5,0)
	ContentScroll.BackgroundTransparency = 1
	ContentScroll.BorderSizePixel = 0
	ContentScroll.ScrollBarThickness = 6
	ContentScroll.LayoutOrder = 2
	ContentScroll.Parent = DialogFrame

	local ContentLabel = Instance.new("TextLabel")
	ContentLabel.Name = "ContentLabel"
	ContentLabel.Size = UDim2.new(1, 0, 0, 0)
	ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
	ContentLabel.Font = FontManager:GetFont(CurrentTheme.Fonts.Secondary)
	ContentLabel.Text = DialogConfig.Content
	ContentLabel.TextColor3 = CurrentTheme.Colors.TextLight
	ContentLabel.TextSize = 14
	ContentLabel.TextWrapped = true
	ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
	ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
	ContentLabel.BackgroundTransparency = 1
	ContentLabel.Parent = ContentScroll

	local ButtonsContainer = Instance.new("Frame")
	ButtonsContainer.Name = "ButtonsContainer"
	ButtonsContainer.Size = UDim2.new(1, -20, 0, 30)
	ButtonsContainer.Position = UDim2.new(0.5,0,0,0)
	ButtonsContainer.AnchorPoint = Vector2.new(0.5,0)
	ButtonsContainer.BackgroundTransparency = 1
	ButtonsContainer.LayoutOrder = 3
	ButtonsContainer.Parent = DialogFrame

	local ButtonsListLayout = Instance.new("UIListLayout")
	ButtonsListLayout.FillDirection = Enum.FillDirection.Horizontal
	ButtonsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	ButtonsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ButtonsListLayout.Padding = UDim.new(0, 10)
	ButtonsListLayout.Parent = ButtonsContainer

	for i, btnConfig in ipairs(DialogConfig.Buttons) do
		local DialogButton = Instance.new("TextButton")
		DialogButton.Name = "DialogButton" .. i
		DialogButton.Text = btnConfig.Text or "Button"
		DialogButton.Font = FontManager:GetFont(CurrentTheme.Fonts.Primary)
		DialogButton.TextSize = 14
		DialogButton.LayoutOrder = i
		DialogButton.Size = UDim2.new(0,0,1,0)
		DialogButton.AutomaticSize = Enum.AutomaticSize.X
		DialogButton.PaddingLeft = UDim.new(0,12)
		DialogButton.PaddingRight = UDim.new(0,12)

		if btnConfig.Variant == "Primary" then
			DialogButton.BackgroundColor3 = CurrentTheme.Colors.Accent
			DialogButton.TextColor3 = CurrentTheme.Colors.TextVeryLight
		elseif btnConfig.Variant == "Secondary" then
			DialogButton.BackgroundColor3 = CurrentTheme.Colors.Secondary
			DialogButton.TextColor3 = CurrentTheme.Colors.Text
		else
			DialogButton.BackgroundColor3 = CurrentTheme.Colors.BackgroundLight
			DialogButton.TextColor3 = CurrentTheme.Colors.TextLight
		end
		DialogButton.Parent = ButtonsContainer

		local UICorner_DBtn = Instance.new("UICorner")
		UICorner_DBtn.CornerRadius = CurrentTheme.Sizes.DefaultCornerRadius
		UICorner_DBtn.Parent = DialogButton

		DialogButton.Activated:Connect(function()
			CloseDialog()
			if btnConfig.Callback and type(btnConfig.Callback) == "function" then
				task.spawn(btnConfig.Callback)
			end
		end)
	end

	task.wait()
	local titleHeight = HeaderFrame.AbsoluteSize.Y
	local contentHeight = ContentLabel.AbsoluteSize.Y
	if contentHeight > DialogConfig.MaxContentHeight then
		ContentScroll.Size = UDim2.new(1, -20, 0, DialogConfig.MaxContentHeight)
		contentHeight = DialogConfig.MaxContentHeight
	else
		ContentScroll.Size = UDim2.new(1, -20, 0, contentHeight)
	end

	local buttonsHeight = ButtonsContainer.AbsoluteSize.Y
	local totalPadding = DialogListLayout.Padding.Offset * 3
	local totalHeight = titleHeight + contentHeight + buttonsHeight + totalPadding
	DialogFrame.Size = UDim2.fromOffset(DialogConfig.Width, totalHeight)

	if DialogConfig.CloseOnEsc then
		escConnectionHolder.Value = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if DialogOverlay.Parent == nil then if escConnectionHolder.Value then escConnectionHolder.Value:Disconnect() end return end
			if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Escape then
				CloseDialog()
			end
		end)
	end
	MakeDraggable(HeaderFrame, DialogFrame)
end

return UBHubLib

[end of UB-V5-QOL.lua]
