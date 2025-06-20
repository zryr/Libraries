local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()

-- Attempt to capture existing Colours table if it's defined by the loader or another script part
local OldStaticColours = Colours -- This line should capture the OLD table if it existed
if type(OldStaticColours) ~= "table" then OldStaticColours = nil end -- Reset if not a table

-- Declare new upvalues for the theming system
local Colours = {}       -- New dynamic, global Colours table, will be populated by applyTheme
local Lucide             -- For Lucide icons (already added in a previous step)
-- DefaultThemes will be defined inside MakeGui as it uses tempOriginalColours

-- The old static Colours table that was here (lines 8-16 approx) is now removed.
-- Its values are captured by OldStaticColours and used in tempOriginalColours inside MakeGui.

local ProtectGui = protectgui or (syn and syn.protect_gui) or function(f) end
local CoreGui = game:GetService("CoreGui")
local SizeUI = UDim2.fromOffset(550, 330)
local function MakeDraggable(topbarobject, object)
	local function CustomPos(tbObject, obj) -- Renamed parameters for clarity
		obj.Size = UDim2.new(0, 400, 0, 300) -- Default size, can be overridden later
		local Dragging = nil
		local DragInput = nil
		local DragStart = nil
		local StartPosition = nil
		local DragTween = nil -- Renamed from Tween to avoid conflict

		local function UpdatePos(input)
			local Delta = input.Position - DragStart
			local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
			if DragTween then DragTween:Cancel() end
			DragTween = TweenService:Create(obj, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position = pos}) -- Slightly longer tween
			DragTween:Play()
		end

		tbObject.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = obj.Position
				if DragTween then DragTween:Cancel() end
				
				local changedConnection
				changedConnection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
						if changedConnection then changedConnection:Disconnect() end -- Disconnect self
					end
				end)
			end
		end)

		tbObject.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				DragInput = input -- Store the input object itself
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then -- Compare input objects
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
		Circle.ImageColor3 = Colours.ThemeHighlight
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
function UBHubLib:MakeNotify(NotifyConfig)
	local NotifyConfig = NotifyConfig or {}
	NotifyConfig.Title = NotifyConfig.Title or "UB Hub"
	NotifyConfig.Description = NotifyConfig.Description or "Notification"
	NotifyConfig.Content = NotifyConfig.Content or "Content"
	NotifyConfig.Color = NotifyConfig.Color or Colours.Primary
	NotifyConfig.Time = NotifyConfig.Time or 0.5
	NotifyConfig.Delay = NotifyConfig.Delay or 5
	local NotifyFunction = {}
	task.spawn(function()
		if not CoreGui:FindFirstChild("NotifyGui") then
			local NotifyGui = Instance.new("ScreenGui");
			NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			NotifyGui.Name = "NotifyGui"
			NotifyGui.Parent = CoreGui
		end
		if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
			local NotifyLayout = Instance.new("Frame");
			NotifyLayout.AnchorPoint = Vector2.new(1, 1)
			NotifyLayout.BackgroundColor3 = Colours.NotificationBackground -- Themed
			NotifyLayout.BackgroundTransparency = 0 -- Assuming opaque theme color
			NotifyLayout.BorderColor3 = Colours.Stroke -- Themed
			NotifyLayout.BorderSizePixel = 0
			NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
			NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
			NotifyLayout.Name = "NotifyLayout"
			NotifyLayout.Parent = CoreGui.NotifyGui
			local Count = 0
			CoreGui.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
				Count = 0
				for i, v in ipairs(CoreGui.NotifyGui.NotifyLayout:GetChildren()) do 
					if v:IsA("GuiObject") then 
						TweenService:Create(
							v,
							TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
							{Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12)*Count))}
						):Play()
						Count = Count + 1
					end
				end
			end)
		end
		local NotifyPosHeigh = 0
		for i, v in ipairs(CoreGui.NotifyGui.NotifyLayout:GetChildren()) do
            if v:IsA("GuiObject") then
			    NotifyPosHeigh = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
            end
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
		local NotifyCloseIcon -- Declare variable for the icon
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

		NotifyFrameReal.BackgroundColor3 = Colours.NotificationBackground -- Themed
		NotifyFrameReal.BorderColor3 = Colours.Stroke -- Themed
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

		DropShado.Image = "rbxassetid://6015897843"
		DropShado.ImageColor3 = Colours.Shadow -- Themed
		DropShado.ImageTransparency = 0.5 -- Keep transparency for shadow effect
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

		Top.BackgroundColor3 = Colours.NotificationActionsBackground -- Themed
		Top.BackgroundTransparency = 0 -- Assuming opaque theme color
		Top.BorderColor3 = Colours.Stroke -- Themed
		Top.BorderSizePixel = 0
		Top.Size = UDim2.new(1, 0, 0, 36)
		Top.Name = "Top"
		Top.Parent = NotifyFrameReal

		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = NotifyConfig.Title
		TextLabel.TextColor3 = Colours.TextColor -- Themed
		TextLabel.TextSize = 14
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Standard white, likely for transparency
		TextLabel.BackgroundTransparency = 1 -- Fully transparent background
		TextLabel.BorderColor3 = Colours.Stroke -- Themed
		TextLabel.BorderSizePixel = 0
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.Parent = Top
		TextLabel.Position = UDim2.new(0, 10, 0, 0)

		UIStroke.Color = Colours.Stroke -- Themed (or TextColor if preferred)
		UIStroke.Thickness = 0.30000001192092896
		UIStroke.Parent = TextLabel

		UICorner1_Notify.Parent = Top
		UICorner1_Notify.CornerRadius = UDim.new(0, 5)

		TextLabel1.Font = Enum.Font.GothamBold
		TextLabel1.Text = NotifyConfig.Description
		TextLabel1.TextColor3 = Colours.TextColor -- Themed
		TextLabel1.TextSize = 14
		TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel1.BackgroundColor3 = Colours.ThemeHighlight -- This was an old color, use a themed one
		TextLabel1.BackgroundTransparency = 1 -- Fully transparent background
		TextLabel1.BorderColor3 = Colours.Stroke -- Themed
		TextLabel1.BorderSizePixel = 0
		TextLabel1.Size = UDim2.new(1, 0, 1, 0)
		TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
		TextLabel1.Parent = Top

		UIStroke1_Notify.Color = Colours.Accent -- Themed (was NotifyConfig.Color)
		UIStroke1_Notify.Thickness = 0.4000000059604645
		UIStroke1_Notify.Parent = TextLabel1

		Close.Font = Enum.Font.SourceSans
		Close.Text = ""
		Close.TextColor3 = Colours.TextColor -- Themed (though text is empty)
		Close.TextSize = 14
		Close.AnchorPoint = Vector2.new(1, 0.5)
		Close.BackgroundColor3 = Colours.NotificationActionsBackground -- Themed
		Close.BackgroundTransparency = 1 -- Fully transparent, icon only
		Close.BorderColor3 = Colours.Stroke -- Themed
		Close.BorderSizePixel = 0
		Close.Position = UDim2.new(1, -5, 0.5, 0)
		Close.Size = UDim2.new(0, 25, 0, 25)
		Close.Name = "Close"
		Close.Parent = Top

		if Lucide and Lucide.ImageLabel then
			-- If there was an old ImageLabel, it might be good to destroy it if this function can be called multiple times,
			-- but given the current structure, MakeNotify seems to create new instances each time.
			-- For safety, let's check if an old one named "NotifyCloseIconInstance" exists and destroy it.
			local oldIcon = Close:FindFirstChild("NotifyCloseIconInstance")
			if oldIcon then oldIcon:Destroy() end

			NotifyCloseIcon = Lucide.ImageLabel("x", 18, {
				Parent = Close,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, -8, 1, -8),
				ImageColor3 = Colours.TextColor, -- Themed
				BackgroundTransparency = 1,
				Name = "NotifyCloseIconInstance"
			})
		else
			NotifyCloseIcon = Instance.new("ImageLabel")
			NotifyCloseIcon.Image = "rbxassetid://9886659671"
			NotifyCloseIcon.ImageColor3 = Colours.TextColor -- Themed
			NotifyCloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
			NotifyCloseIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Standard white, likely for transparency
			NotifyCloseIcon.BackgroundTransparency = 1 -- Fully transparent
			NotifyCloseIcon.BorderColor3 = Colours.Stroke -- Themed
			NotifyCloseIcon.BorderSizePixel = 0
			NotifyCloseIcon.Position = UDim2.new(0.49000001, 0, 0.5, 0)
			NotifyCloseIcon.Size = UDim2.new(1, -8, 1, -8)
			NotifyCloseIcon.Name = "NotifyCloseIconInstance"
			NotifyCloseIcon.Parent = Close
		end

		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.TextSize = 13
		TextLabel2.Text = NotifyConfig.Content
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Standard white, likely for transparency
		TextLabel2.BackgroundTransparency = 1 -- Fully transparent
		TextLabel2.TextColor3 = Colours.TextColor -- Themed (was a specific grey)
		TextLabel2.BorderColor3 = Colours.Stroke -- Themed
		TextLabel2.BorderSizePixel = 0
		TextLabel2.Position = UDim2.new(0, 10, 0, 27)
		TextLabel2.Parent = NotifyFrameReal
		TextLabel2.Size = UDim2.new(1, -20, 0, 13)

		TextLabel2.TextWrapped = true
		task.wait() -- Allow TextBounds to update
		TextLabel2.Size = UDim2.new(1, -20, 0, TextLabel2.TextBounds.Y) -- Dynamic height


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
function UBHubLib:MakeGui(GuiConfig)
	local GuiConfig = GuiConfig or {}
	GuiConfig.NameHub = GuiConfig.NameHub or "UB Hub"
	GuiConfig.Description = GuiConfig.Description or nil
	GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(255, 0, 255)
	GuiConfig["Logo Player"] = GuiConfig["Logo Player"] or "https://www.roblox.com/headshot-thumbnail/image?userId="..game:GetService("Players").LocalPlayer.UserId .."&width=420&height=420&format=png"
	GuiConfig["Name Player"] = GuiConfig["Name Player"] or tostring(game:GetService("Players").LocalPlayer.Name)
	GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 120
	GuiConfig["SaveFolder"] = GuiConfig["SaveFolder"] or false

	if HttpService and not (type(HttpService.JSONEncode) == "function" and type(HttpService.JSONDecode) == "function" and type(HttpService.GenerateGUID) == "function") then
		warn("UB Hub: HttpService is available, but required methods (JSONEncode, JSONDecode, GenerateGUID) are not. Save/Load and Web Backgrounds will be affected.")
		HttpService = nil
	elseif not HttpService then
		warn("UB Hub: HttpService is not available. Save/Load and Web Backgrounds will be affected.")
	end

	local FSO = {
		readfile = readfile,
		writefile = writefile,
		isfile = isfile,
		makefolder = makefolder,
		listfiles = listfiles,
		getcustomasset = getcustomasset
	}
	local fsFunctionsAvailable = true
	for funcName, funcRef in pairs(FSO) do
		if type(funcRef) ~= "function" then
			warn("UB Hub: File system function '" .. funcName .. "' is not available. Related functionality (Save/Load, Local Backgrounds) will be affected.")
			FSO[funcName] = nil
			fsFunctionsAvailable = false
		end
	end

	UBHubLib.Flags = UBHubLib.Flags or {}
	local Flags = UBHubLib.Flags

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

	local tempOriginalColours = {
		Primary = (OldStaticColours and OldStaticColours.Primary) or Color3.fromRGB(160,40,0),
		Secondary = (OldStaticColours and OldStaticColours.Secondary) or Color3.fromRGB(160,30,0),
		Accent = (OldStaticColours and OldStaticColours.Accent) or Color3.fromRGB(200,50,0),
		ThemeHighlight = (OldStaticColours and OldStaticColours.ThemeHighlight) or Color3.fromRGB(255,80,0),
		Text = (OldStaticColours and OldStaticColours.Text) or Color3.fromRGB(255,240,230),
		Background = (OldStaticColours and OldStaticColours.Background) or Color3.fromRGB(20,8,0),
		Stroke = (OldStaticColours and OldStaticColours.Stroke) or Color3.fromRGB(80,20,0)
	}

	local DefaultThemes = {
		["Rayfield Like"] = {
			TextColor = Color3.fromRGB(221, 221, 221), Background = Color3.fromRGB(30, 30, 30), Topbar = Color3.fromRGB(25, 25, 25), Shadow = Color3.fromRGB(10,10,10),
			NotificationBackground = Color3.fromRGB(35, 35, 35), NotificationActionsBackground = Color3.fromRGB(40, 40, 40),
			TabBackground = Color3.fromRGB(30, 30, 30), TabStroke = Color3.fromRGB(50, 50, 50), TabBackgroundSelected = Color3.fromRGB(45, 45, 45),
			TabTextColor = Color3.fromRGB(180, 180, 180), SelectedTabTextColor = Color3.fromRGB(221, 221, 221),
			ElementBackground = Color3.fromRGB(45, 45, 45), ElementBackgroundHover = Color3.fromRGB(55, 55, 55), SecondaryElementBackground = Color3.fromRGB(40, 40, 40),
			ElementStroke = Color3.fromRGB(60, 60, 60), SecondaryElementStroke = Color3.fromRGB(50, 50, 50),
			SliderBackground = Color3.fromRGB(40, 40, 40), SliderProgress = Color3.fromRGB(0, 122, 204), SliderStroke = Color3.fromRGB(60, 60, 60),
			ToggleBackground = Color3.fromRGB(40, 40, 40), ToggleEnabled = Color3.fromRGB(0, 122, 204), ToggleDisabled = Color3.fromRGB(60, 60, 60),
			ToggleEnabledStroke = Color3.fromRGB(0, 100, 180), ToggleDisabledStroke = Color3.fromRGB(80, 80, 80),
			ToggleEnabledOuterStroke = Color3.fromRGB(0, 122, 204), ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 50),
			DropdownSelected = Color3.fromRGB(50, 50, 50), DropdownUnselected = Color3.fromRGB(40, 40, 40),
			InputBackground = Color3.fromRGB(35, 35, 35), InputStroke = Color3.fromRGB(55, 55, 55), PlaceholderColor = Color3.fromRGB(120, 120, 120),
			Primary = Color3.fromRGB(0, 122, 204), Secondary = Color3.fromRGB(0, 100, 170), Accent = Color3.fromRGB(0, 150, 255), ThemeHighlight = Color3.fromRGB(0, 122, 204), Stroke = Color3.fromRGB(50, 50, 50),
			GuiConfigColor = Color3.fromRGB(0, 122, 204) -- Matches Primary for Rayfield
		},
		["Default Dark Original"] = { -- Mapped from tempOriginalColours and Rayfield for missing
			TextColor = tempOriginalColours.Text, Background = tempOriginalColours.Background, Topbar = tempOriginalColours.Background, Shadow = Color3.fromRGB(10,5,0),
			NotificationBackground = Color3.fromRGB(25,10,0), NotificationActionsBackground = Color3.fromRGB(30,12,0),
			TabBackground = tempOriginalColours.Background, TabStroke = tempOriginalColours.Stroke, TabBackgroundSelected = tempOriginalColours.Secondary,
			TabTextColor = tempOriginalColours.Text, SelectedTabTextColor = Color3.fromRGB(255,255,255),
			ElementBackground = Color3.fromRGB(30,15,5), ElementBackgroundHover = Color3.fromRGB(40,20,10), SecondaryElementBackground = Color3.fromRGB(25,10,0),
			ElementStroke = tempOriginalColours.Stroke, SecondaryElementStroke = Color3.fromRGB(60,15,0),
			SliderBackground = Color3.fromRGB(30,15,5), SliderProgress = tempOriginalColours.ThemeHighlight, SliderStroke = tempOriginalColours.Stroke,
			ToggleBackground = Color3.fromRGB(30,15,5), ToggleEnabled = tempOriginalColours.ThemeHighlight, ToggleDisabled = Color3.fromRGB(50,25,10),
			ToggleEnabledStroke = tempOriginalColours.Accent, ToggleDisabledStroke = tempOriginalColours.Stroke,
			ToggleEnabledOuterStroke = tempOriginalColours.ThemeHighlight, ToggleDisabledOuterStroke = Color3.fromRGB(40,20,10),
			DropdownSelected = tempOriginalColours.Secondary, DropdownUnselected = Color3.fromRGB(30,15,5),
			InputBackground = Color3.fromRGB(25,10,0), InputStroke = tempOriginalColours.Stroke, PlaceholderColor = Color3.fromRGB(150,100,80),
			Primary = tempOriginalColours.Primary, Secondary = tempOriginalColours.Secondary, Accent = tempOriginalColours.Accent, ThemeHighlight = tempOriginalColours.ThemeHighlight, Stroke = tempOriginalColours.Stroke,
			GuiConfigColor = tempOriginalColours.Primary -- Matches Primary for Original
		},
		["Default Light"] = {
			TextColor = Color3.fromRGB(10,10,10), Background = Color3.fromRGB(245,245,245), Topbar = Color3.fromRGB(235,235,235), Shadow = Color3.fromRGB(180,180,180),
			NotificationBackground = Color3.fromRGB(230,230,230), NotificationActionsBackground = Color3.fromRGB(220,220,220),
			TabBackground = Color3.fromRGB(240,240,240), TabStroke = Color3.fromRGB(200,200,200), TabBackgroundSelected = Color3.fromRGB(220,220,220),
			TabTextColor = Color3.fromRGB(50,50,50), SelectedTabTextColor = Color3.fromRGB(10,10,10),
			ElementBackground = Color3.fromRGB(220,220,220), ElementBackgroundHover = Color3.fromRGB(210,210,210), SecondaryElementBackground = Color3.fromRGB(225,225,225),
			ElementStroke = Color3.fromRGB(190,190,190), SecondaryElementStroke = Color3.fromRGB(200,200,200),
			SliderBackground = Color3.fromRGB(210,210,210), SliderProgress = Color3.fromRGB(0,122,204), SliderStroke = Color3.fromRGB(180,180,180),
			ToggleBackground = Color3.fromRGB(210,210,210), ToggleEnabled = Color3.fromRGB(0,122,204), ToggleDisabled = Color3.fromRGB(180,180,180),
			ToggleEnabledStroke = Color3.fromRGB(0,100,180), ToggleDisabledStroke = Color3.fromRGB(160,160,160),
			ToggleEnabledOuterStroke = Color3.fromRGB(0,122,204), ToggleDisabledOuterStroke = Color3.fromRGB(200,200,200),
			DropdownSelected = Color3.fromRGB(210,210,210), DropdownUnselected = Color3.fromRGB(220,220,220),
			InputBackground = Color3.fromRGB(230,230,230), InputStroke = Color3.fromRGB(200,200,200), PlaceholderColor = Color3.fromRGB(150,150,150),
			Primary = Color3.fromRGB(0,122,204), Secondary = Color3.fromRGB(0,100,170), Accent = Color3.fromRGB(0,150,255), ThemeHighlight = Color3.fromRGB(0,122,204), Stroke = Color3.fromRGB(200,200,200),
			GuiConfigColor = Color3.fromRGB(0,122,204) -- Example accent for Light
		},
		["Ocean Blue"] = {
			TextColor = Color3.fromRGB(220,230,240), Background = Color3.fromRGB(10,20,40), Topbar = Color3.fromRGB(20,30,50), Shadow = Color3.fromRGB(5,10,20),
			NotificationBackground = Color3.fromRGB(25,35,55), NotificationActionsBackground = Color3.fromRGB(30,40,60),
			TabBackground = Color3.fromRGB(15,25,45), TabStroke = Color3.fromRGB(40,50,70), TabBackgroundSelected = Color3.fromRGB(30,40,60),
			TabTextColor = Color3.fromRGB(180,190,200), SelectedTabTextColor = Color3.fromRGB(220,230,240),
			ElementBackground = Color3.fromRGB(30,40,60), ElementBackgroundHover = Color3.fromRGB(40,50,70), SecondaryElementBackground = Color3.fromRGB(25,35,55),
			ElementStroke = Color3.fromRGB(50,60,80), SecondaryElementStroke = Color3.fromRGB(40,50,70),
			SliderBackground = Color3.fromRGB(25,35,55), SliderProgress = Color3.fromRGB(0,150,255), SliderStroke = Color3.fromRGB(50,60,80),
			ToggleBackground = Color3.fromRGB(25,35,55), ToggleEnabled = Color3.fromRGB(0,150,255), ToggleDisabled = Color3.fromRGB(50,60,80),
			ToggleEnabledStroke = Color3.fromRGB(0,130,230), ToggleDisabledStroke = Color3.fromRGB(70,80,100),
			ToggleEnabledOuterStroke = Color3.fromRGB(0,150,255), ToggleDisabledOuterStroke = Color3.fromRGB(40,50,70),
			DropdownSelected = Color3.fromRGB(40,50,70), DropdownUnselected = Color3.fromRGB(30,40,60),
			InputBackground = Color3.fromRGB(20,30,50), InputStroke = Color3.fromRGB(40,50,70), PlaceholderColor = Color3.fromRGB(100,110,130),
			Primary = Color3.fromRGB(0,150,255), Secondary = Color3.fromRGB(0,120,210), Accent = Color3.fromRGB(0,180,255), ThemeHighlight = Color3.fromRGB(0,150,255), Stroke = Color3.fromRGB(40,50,70),
			GuiConfigColor = Color3.fromRGB(0,150,255) -- Example accent for Ocean
		}
	}

	local CurrentThemeName -- Will store the name of the currently active theme (string)
	local AllCreatedItemControls = { Sliders = {} } -- To store references to R,G,B sliders for dynamic updates

	local function SaveFile(Name, Value)
		if not (FSO.writefile and GuiConfig and GuiConfig.SaveFolder and HttpService) then
			if GuiConfig and GuiConfig.SaveFolder then
				warn("SaveFile: Cannot proceed. 'FSO.writefile' or 'HttpService' may not be available, or SaveFolder not set.")
			end
			return false
		end

		if Value == nil then
			UBHubLib.Flags[Name] = nil
		else
			UBHubLib.Flags[Name] = Value
		end

		local success, err = pcall(function()
			local path = GuiConfig.SaveFolder
			local encoded = HttpService:JSONEncode(UBHubLib.Flags)
			FSO.writefile(path, encoded)
		end)
		if not success then
			warn("SaveFile (for " .. (Name or "Unknown") .. ") failed:", err)
			return false
		end
		return true
	end
	local function LoadFile()
		if not (GuiConfig and GuiConfig["SaveFolder"]) then return false end
		local savePath = GuiConfig["SaveFolder"]
		if not (FSO.readfile and FSO.isfile and FSO.isfile(savePath) and HttpService) then
			if GuiConfig and GuiConfig.SaveFolder then
                local missing = {}
                if not FSO.readfile then table.insert(missing, "'FSO.readfile'") end
                if not FSO.isfile then table.insert(missing, "'FSO.isfile'") end
                if not HttpService then table.insert(missing, "'HttpService'") end
                warn("LoadFile: Cannot proceed. Missing: " .. table.concat(missing, ", ") .. ". Or save file does not exist.")
			end
			return false
		end
		local success, fileContent = pcall(FSO.readfile, savePath)
		if not success or not fileContent then
			warn("LoadFile: Failed to read file from path: " .. savePath .. (fileContent and (": " .. fileContent) or "")) -- Log pcall error if any
			return false
		end

		local decodeSuccess, config = pcall(HttpService.JSONDecode, HttpService, fileContent)
		if decodeSuccess and type(config) == "table" then
			UBHubLib.Flags = config
			return true
		end
		return false
	end; LoadFile() -- Called after UBHubLib.Flags is initialized

	local mediaFolder = "UBHubAssets"
	if FSO.makefolder and not FSO.isfile(mediaFolder) then
		FSO.makefolder(mediaFolder)
	elseif not FSO.makefolder and not (FSO.isfile and FSO.isfile(mediaFolder)) then -- Check isfile result too
         warn("ChangeTransparencyInternal: Cannot create mediaFolder '"..mediaFolder.."' as 'makefolder' is unavailable and folder does not exist.")
    end

	local function ChangeTransparencyInternal(transparencyValue)
		if Main then Main.BackgroundTransparency = transparencyValue end
		if BackgroundImage then BackgroundImage.ImageTransparency = transparencyValue end
		if BackgroundVideo then BackgroundVideo.BackgroundTransparency = transparencyValue end

		if GuiConfig then GuiConfig.MainBackgroundTransparency = transparencyValue end
		if Flags then
			Flags.MainBackgroundTransparency = transparencyValue
			SaveFile("MainBackgroundTransparency", transparencyValue)
		end
	end

	local function ChangeAssetInternal(mediaType, urlOrPath, filename)
		if not FSO.getcustomasset then
			warn("ChangeAssetInternal: 'getcustomasset' function is not available. Cannot change asset.")
			return
		end
		local assetId
		local success, err = pcall(function()
			if urlOrPath:match("^https?://") then
				if not HttpService then warn("ChangeAssetInternal: HttpService not available for web download."); error("HttpService missing") end
				if not FSO.writefile then warn("ChangeAssetInternal: FSO.writefile not available for web download."); error("FSO.writefile missing") end
				if not FSO.makefolder then warn("ChangeAssetInternal: FSO.makefolder not available for web download."); error("FSO.makefolder missing") end
				if not (FSO.isfile and FSO.isfile(mediaFolder)) then FSO.makefolder(mediaFolder) end

				local data
				local httpSuccess, httpResult = pcall(game.HttpGet, game, urlOrPath)
				if not httpSuccess then error("HttpGet failed: " .. tostring(httpResult)) end
				data = httpResult

				local extension = mediaType == "Image" and ".png" or ".mp4"
				if not filename or filename == "" then filename = HttpService:GenerateGUID(false) end
				if not filename:match("%..+$") then filename = filename .. extension end

				local filePath = mediaFolder .. "/" .. filename
				FSO.writefile(filePath, data)
				assetId = FSO.getcustomasset(filePath)
				if Flags then
					Flags.SavedBackgroundType = mediaType
					Flags.SavedBackgroundPath = filePath
					SaveFile("SavedBackgroundInfo", {Type = mediaType, Path = filePath})
				end
			else
				assetId = FSO.getcustomasset(urlOrPath)
				 if Flags then
					Flags.SavedBackgroundType = mediaType
					Flags.SavedBackgroundPath = urlOrPath
					SaveFile("SavedBackgroundInfo", {Type = mediaType, Path = urlOrPath})
				end
			end
		end)

		if not success or not assetId then
			warn("ChangeAssetInternal: Failed to load asset. Type:", mediaType, "URL/Path:", urlOrPath, "Error:", err or "Unknown error in pcall")
			return
		end

		if mediaType == "Image" then
			if BackgroundImage then BackgroundImage.Image = assetId end
			if BackgroundVideo then BackgroundVideo.Video = "" end
			_G.BGImage = assetId ~= "" and assetId ~= nil
			_G.BGVideo = false
		elseif mediaType == "Video" then
			if BackgroundVideo then BackgroundVideo.Video = assetId end
			if BackgroundImage then BackgroundImage.Image = "" end
			_G.BGVideo = assetId ~= "" and assetId ~= nil
			_G.BGImage = false
			if BackgroundVideo then BackgroundVideo.Playing = _G.BGVideo end
		end
	end

	local function ResetBackgroundInternal()
		if BackgroundImage then BackgroundImage.Image = "" end
		if BackgroundVideo then BackgroundVideo.Video = "" end
		_G.BGImage = false
		_G.BGVideo = false
		if Flags then
			Flags.SavedBackgroundType = nil
			Flags.SavedBackgroundPath = nil
			SaveFile("SavedBackgroundInfo", nil)
		end
	end

	if Flags.SavedBackgroundPath and Flags.SavedBackgroundType then
		if FSO.isfile and FSO.isfile(Flags.SavedBackgroundPath) then
			 ChangeAssetInternal(Flags.SavedBackgroundType, Flags.SavedBackgroundPath, nil)
		else
			 if FSO.isfile then
				warn("Saved background file not found:", Flags.SavedBackgroundPath)
			 end
			 Flags.SavedBackgroundType = nil
			 Flags.SavedBackgroundPath = nil
			 SaveFile("SavedBackgroundInfo", nil)
		end
	end
	if Flags.MainBackgroundTransparency ~= nil then
		-- This will be applied by applyTheme if it reads MainBackgroundTransparency,
		-- or we can call ChangeTransparencyInternal here after Main exists.
		-- For now, let applyTheme handle it or set it after Main is created.
		-- Let's ensure GuiConfig reflects this for applyTheme:
		if GuiConfig then GuiConfig.MainBackgroundTransparency = Flags.MainBackgroundTransparency end
	else
		if GuiConfig then GuiConfig.MainBackgroundTransparency = 0.1 end
		-- ChangeTransparencyInternal will be called by applyTheme or later if needed
	end


	task.spawn(function()
		local success, lucideSource = pcall(function()
			return game:HttpGet("https://raw.githubusercontent.com/latte-soft/lucide-roblox/main/src/lucide.lua")
		end)

		if success and lucideSource and lucideSource ~= "" then
			local loadSuccess, loadedFunc = pcall(loadstring(lucideSource))
			if loadSuccess and typeof(loadedFunc) == "function" then
				local pcallSuccess, returnedValue = pcall(loadedFunc)
				if pcallSuccess and typeof(returnedValue) == "table" then
					Lucide = returnedValue
				end
			end
		end

		if not Lucide then
			warn("Lucide failed to load. Using placeholder icons.")
			Lucide = {}
			function Lucide.ImageLabel(iconName, imageSize, propertyOverrides)
				local imageSize = imageSize or 20
				local label = Instance.new("ImageLabel")
				label.Size = UDim2.fromOffset(imageSize, imageSize)
				label.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
				label.Image = ""

				local text = Instance.new("TextLabel")
				text.Text = iconName and string.sub(iconName, 1, 1) or "?"
				text.Size = UDim2.new(1, 0, 1, 0)
				text.TextColor3 = Color3.fromRGB(255, 255, 255)
				text.BackgroundTransparency = 1
				text.Font = Enum.Font.SourceSansBold
				text.TextScaled = true
				text.Parent = label

				if propertyOverrides then
					for prop, value in pairs(propertyOverrides) do
						label[prop] = value
					end
				end
				return label
			end
		end
	end)

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
	-- local MaxRestore = Instance.new("TextButton"); -- MaxRestore seems unused, can be removed
	-- local ImageLabel = Instance.new("ImageLabel"); -- For MaxRestore, also unused
	local Close = Instance.new("TextButton");
	local ImageLabel1 = Instance.new("ImageLabel");
	local Min = Instance.new("TextButton");
	local ImageLabel2 = Instance.new("ImageLabel");
	local LayersTab = Instance.new("Frame");
	local UICorner2 = Instance.new("UICorner");
	local DecideFrame = Instance.new("Frame");
	-- local UIStroke3 = Instance.new("UIStroke"); -- For DecideFrame, if needed, now using BG color
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
	Main.BackgroundColor3 = Colours.Background -- This will be set by applyTheme
	Main.BackgroundTransparency = 0 -- Assuming opaque from theme
	Main.BorderColor3 = Colours.Stroke -- Themed
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
    UICorner.CornerRadius = UDim.new(0, 8) 

	UIStroke.Color = Colours.Stroke -- Themed
	UIStroke.Thickness = 1.600000023841858
	UIStroke.Parent = Main

	Top.BackgroundColor3 = Colours.Topbar -- This will be set by applyTheme
	Top.BackgroundTransparency = 0 -- Assuming opaque from theme
	Top.BorderColor3 = Colours.Stroke -- Themed
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 38)
	Top.Name = "Top"
	Top.Parent = Main

	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = GuiConfig.NameHub
	TextLabel.TextColor3 = Colours.Accent -- This will be set by applyTheme
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	TextLabel.BackgroundTransparency = 1 
	TextLabel.BorderColor3 = Colours.Stroke -- Themed
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, -100, 1, 0)
	TextLabel.Position = UDim2.new(0, 10, 0, 0)
	TextLabel.Parent = Top

	UICorner1.Parent = Top
    UICorner1.CornerRadius = UDim.new(0,5) 

	TextLabel1.Font = Enum.Font.GothamBold
	TextLabel1.Text = GuiConfig.Description
	TextLabel1.TextColor3 = Colours.TextColor -- This will be set by applyTheme (was Colours.Text)
	TextLabel1.TextSize = 14
	TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel1.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	TextLabel1.BackgroundTransparency = 1 
	TextLabel1.BorderColor3 = Colours.Stroke -- Themed
	TextLabel1.BorderSizePixel = 0
	TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0)
	TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
	TextLabel1.Parent = Top

	UIStroke1.Color = Colours.Accent -- Themed (was GuiConfig.Color)
	UIStroke1.Thickness = 0.4000000059604645
	UIStroke1.Parent = TextLabel1

	Close.Font = Enum.Font.SourceSans
	Close.Text = ""
	Close.TextColor3 = Colours.TextColor -- Themed (text is empty)
	Close.TextSize = 14
	Close.AnchorPoint = Vector2.new(1, 0.5)
	Close.BackgroundColor3 = Colours.Topbar -- Themed (or ElementBackground)
	Close.BackgroundTransparency = 1 -- Assuming icon only
	Close.BorderColor3 = Colours.Stroke -- Themed
	Close.BorderSizePixel = 0
	Close.Position = UDim2.new(1, -8, 0.5, 0)
	Close.Size = UDim2.new(0, 25, 0, 25)
	Close.Name = "Close"
	Close.Parent = Top

	ImageLabel1.Image = "rbxassetid://9886659671"
	ImageLabel1.ImageColor3 = Colours.TextColor -- Themed
	ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel1.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	ImageLabel1.BackgroundTransparency = 1
	ImageLabel1.BorderColor3 = Colours.Stroke -- Themed
	ImageLabel1.BorderSizePixel = 0
	ImageLabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
	ImageLabel1.Size = UDim2.new(1, -8, 1, -8)
	ImageLabel1.Parent = Close

	Min.Font = Enum.Font.SourceSans
	Min.Text = ""
	Min.TextColor3 = Colours.TextColor -- Themed (text is empty)
	Min.TextSize = 14
	Min.AnchorPoint = Vector2.new(1, 0.5)
	Min.BackgroundColor3 = Colours.Topbar -- Themed (or ElementBackground)
	Min.BackgroundTransparency = 1 -- Assuming icon only
	Min.BorderColor3 = Colours.Stroke -- Themed
	Min.BorderSizePixel = 0
	Min.Position = UDim2.new(1, -38, 0.5, 0) -- Adjusted position because MaxRestore is gone
	Min.Size = UDim2.new(0, 25, 0, 25)
	Min.Name = "Min"
	Min.Parent = Top

	ImageLabel2.Image = "rbxassetid://9886659276"
	ImageLabel2.ImageColor3 = Colours.TextColor -- Themed
	ImageLabel2.ImageTransparency = 0.2 -- Retain visual effect
	ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel2.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.BorderColor3 = Colours.Stroke -- Themed
	ImageLabel2.BorderSizePixel = 0
	ImageLabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel2.Size = UDim2.new(1, -9, 1, -9)
	ImageLabel2.Parent = Min

	LayersTab.BackgroundColor3 = Colours.TabBackground -- This will be set by applyTheme
	LayersTab.BackgroundTransparency = 0 -- Assuming opaque from theme
	LayersTab.BorderColor3 = Colours.Stroke -- Themed
	LayersTab.BorderSizePixel = 0
	LayersTab.Position = UDim2.new(0, 9, 0, 50)
	LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -59)
	LayersTab.Name = "LayersTab"
	LayersTab.Parent = Main

	UICorner2.CornerRadius = UDim.new(0, 2)
	UICorner2.Parent = LayersTab

	DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
	DecideFrame.BackgroundColor3 = Colours.Stroke -- This will be set by applyTheme
	DecideFrame.BackgroundTransparency = 0 -- Assuming opaque from theme (original was 0.5)
	DecideFrame.BorderColor3 = Colours.Stroke -- Themed (original was black)
	DecideFrame.BorderSizePixel = 0
	DecideFrame.Position = UDim2.new(0.5, 0, 0, 38)
	DecideFrame.Size = UDim2.new(1, 0, 0, 1)
	DecideFrame.Name = "DecideFrame"
	DecideFrame.Parent = Main

	Layers.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	Layers.BackgroundTransparency = 1
	Layers.BorderColor3 = Colours.Stroke -- Themed
	Layers.BorderSizePixel = 0
	Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 50)
	Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -59)
	Layers.Name = "Layers"
	Layers.Parent = Main

	UICorner6.CornerRadius = UDim.new(0, 2)
	UICorner6.Parent = Layers

	NameTab.Font = Enum.Font.GothamBold
	NameTab.Text = ""
	NameTab.TextColor3 = Colours.SelectedTabTextColor -- This will be set by applyTheme
	NameTab.TextSize = 24
	NameTab.TextWrapped = true
	NameTab.TextXAlignment = Enum.TextXAlignment.Left
	NameTab.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	NameTab.BackgroundTransparency = 1
	NameTab.BorderColor3 = Colours.Stroke -- Themed
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
	ScrollTab.ScrollBarImageColor3 = Colours.SecondaryElementBackground -- Themed
	ScrollTab.ScrollBarThickness = 0
	ScrollTab.Active = true
	ScrollTab.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	ScrollTab.BackgroundTransparency = 1
	ScrollTab.BorderColor3 = Colours.Stroke -- Themed
	ScrollTab.BorderSizePixel = 0
	ScrollTab.Size = UDim2.new(1, 0, 1, -50)
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = LayersTab

	UIListLayout.Padding = UDim.new(0, 3)
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
	-- NamePlayer is removed as per requirement
		
	Info.AnchorPoint = Vector2.new(1, 1)
	Info.BackgroundColor3 = Colours.TabBackground -- This will be set by applyTheme
	Info.BackgroundTransparency = 0 -- Assuming opaque from theme (original 0.95)
	Info.BorderColor3 = Colours.Stroke -- Themed
	Info.BorderSizePixel = 0
	Info.Position = UDim2.new(1, 0, 1, 0)
	Info.Size = UDim2.new(1, 0, 0, 40)
	Info.Name = "Info"
	Info.Parent = LayersTab

	InfoUICorner.CornerRadius = UDim.new(0, 5)
	InfoUICorner.Parent = Info

	LogoPlayerFrame.AnchorPoint = Vector2.new(0, 0.5)
	LogoPlayerFrame.BackgroundColor3 = Colours.ElementBackground -- Themed (or transparent)
	LogoPlayerFrame.BackgroundTransparency = 0 -- Assuming opaque (original 0.95)
	LogoPlayerFrame.BorderColor3 = Colours.Stroke -- Themed
	LogoPlayerFrame.BorderSizePixel = 0
	LogoPlayerFrame.Position = UDim2.new(0, 5, 0.5, 0)
	LogoPlayerFrame.Size = UDim2.new(0, 30, 0, 30)
	LogoPlayerFrame.Name = "LogoPlayerFrame"
	LogoPlayerFrame.Parent = Info

	LogoPlayerFrameUICorner.CornerRadius = UDim.new(0, 1000)
	LogoPlayerFrameUICorner.Parent = LogoPlayerFrame

	LogoPlayer.Image = GuiConfig["Logo Player"]
	LogoPlayer.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoPlayer.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	LogoPlayer.BackgroundTransparency = 1
	LogoPlayer.BorderColor3 = Colours.Stroke -- Themed
	LogoPlayer.BorderSizePixel = 0
	LogoPlayer.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogoPlayer.Size = UDim2.new(1, -5, 1, -5)
	LogoPlayer.Name = "LogoPlayer"
	LogoPlayer.Parent = LogoPlayerFrame

	LogoPlayerUICorner.CornerRadius = UDim.new(0, 1000)
	LogoPlayerUICorner.Parent = LogoPlayer

	NamePlayer.Font = Enum.Font.GothamBold
	NamePlayer.Text = GuiConfig["Name Player"]
	NamePlayer.TextColor3 = Colours.TextColor -- Themed
	NamePlayer.TextSize = 12
	NamePlayer.TextWrapped = true
	NamePlayer.TextXAlignment = Enum.TextXAlignment.Left
	NamePlayer.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	NamePlayer.BackgroundTransparency = 1
	NamePlayer.BorderColor3 = Colours.Stroke -- Themed
	NamePlayer.BorderSizePixel = 0
	NamePlayer.Position = UDim2.new(0, 40, 0, 0)
	NamePlayer.Size = UDim2.new(1, -45, 1, 0)
	NamePlayer.Name = "NamePlayer"
	-- NamePlayer.Parent = Info -- No longer parented

	-- Store references for later use by ThemesButton callback
	UBHubLib.MainUIPointers = UBHubLib.MainUIPointers or {}
	UBHubLib.MainUIPointers.LayersPageLayout = LayersPageLayout
	UBHubLib.MainUIPointers.ScrollTab = ScrollTab
	UBHubLib.TabReferences = UBHubLib.TabReferences or {}

	local ThemesButton = Instance.new("TextButton")
	ThemesButton.Name = "ThemesButton"
	ThemesButton.Text = "Themes"
	ThemesButton.Parent = Info
	ThemesButton.Font = Enum.Font.GothamBold
	ThemesButton.TextSize = 12
	ThemesButton.TextColor3 = Colours.TextColor -- Applied after applyTheme
	ThemesButton.BackgroundColor3 = Colours.ElementBackground -- Applied after applyTheme
	ThemesButton.AnchorPoint = Vector2.new(0, 0.5)
	-- Attempt to position next to LogoPlayerFrame, might need adjustment if LogoPlayerFrame size changes or if UIListLayout is used later
	ThemesButton.Position = UDim2.new(0, (LogoPlayerFrame and LogoPlayerFrame.AbsoluteSize.X or 30) + 10, 0.5, 0)
	ThemesButton.Size = UDim2.new(0, 60, 0, 25)

	local ThemesButtonCorner = Instance.new("UICorner")
	ThemesButtonCorner.CornerRadius = UDim.new(0,3)
	ThemesButtonCorner.Parent = ThemesButton

	ThemesButton.Activated:Connect(function()
		if UBHubLib.TabReferences["Themes"] and UBHubLib.TabReferences["Themes"].TabButton then
			local themesTabButton = UBHubLib.TabReferences["Themes"].TabButton
			-- Simulate the click on the actual themes tab button
			local FrameChoose
			if UBHubLib.MainUIPointers.ScrollTab then
				for _, s in ipairs(UBHubLib.MainUIPointers.ScrollTab:GetChildren()) do
					if s:IsA("GuiObject") then
						for _, v in ipairs(s:GetChildren()) do
							if v.Name == "ChooseFrame" then
								FrameChoose = v
								break
							end
						end
					end
					if FrameChoose then break end
				end
			end

			if FrameChoose and themesTabButton.Parent.LayoutOrder ~= UBHubLib.MainUIPointers.LayersPageLayout.CurrentPage.LayoutOrder then
				for _, TabFrame in ipairs(UBHubLib.MainUIPointers.ScrollTab:GetChildren()) do
					if TabFrame.Name == "Tab" then
						TweenService:Create(TabFrame,TweenInfo.new(0.001, Enum.EasingStyle.Linear),{BackgroundTransparency = 0.9990000128746033}):Play()
					end
				end
				TweenService:Create(themesTabButton.Parent, TweenInfo.new(0.001, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.92}):Play()
				TweenService:Create(FrameChoose,TweenInfo.new(0.01, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 2, 0, 9 + (33 * themesTabButton.Parent.LayoutOrder))}):Play()
				UBHubLib.MainUIPointers.LayersPageLayout:JumpToPage(themesTabButton.Parent.LayoutOrder) -- Assumes page instance is the parent of TabButton
				if NameTab and UBHubLib.TabReferences["Themes"].Name then
					NameTab.Text = UBHubLib.TabReferences["Themes"].Name
				end
				TweenService:Create(FrameChoose,TweenInfo.new(0.01, Enum.EasingStyle.Linear),{Size = UDim2.new(0, 1, 0, 20)}):Play()
			elseif themesTabButton.Parent.LayoutOrder == UBHubLib.MainUIPointers.LayersPageLayout.CurrentPage.LayoutOrder then
				-- Already on the tab, do nothing or maybe a small feedback
			else
				warn("ThemesButton: Could not switch to Themes tab. FrameChoose or other elements not found as expected.")
			end
		else
			warn("ThemesButton: Themes tab reference or its button not found.")
		end
	end)

	local GuiFunc = {}
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
    MinimizedIcon.BackgroundColor3 = Colours.ThemeHighlight -- Themed
	MinimizedIcon.Parent = ScreenGui
	MinimizedIcon.Draggable = true
	MinimizedIcon.Visible = false
	MinimizedIcon.BorderColor3 = Colours.ThemeHighlight -- Themed
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
	--// Blur
	local MoreBlur = Instance.new("Frame");
	local DropShadowHolder1 = Instance.new("Frame");
	local DropShadow1 = Instance.new("ImageLabel");
	local UICorner28 = Instance.new("UICorner");
	local ConnectButton = Instance.new("TextButton");
	
	MoreBlur.AnchorPoint = Vector2.new(1, 1)
	MoreBlur.BackgroundColor3 = Colours.Background -- Themed (or Shadow)
	MoreBlur.BackgroundTransparency = 0.7 -- Original was 0.999, now based on theme color, might need adjustment
	MoreBlur.BorderColor3 = Colours.Stroke -- Themed
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
	DropShadow1.ImageColor3 = Colours.Shadow -- Themed
	DropShadow1.ImageTransparency = 0.5 -- Retain for shadow effect
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
    UICorner28.CornerRadius = UDim.new(0,8) 

	ConnectButton.Font = Enum.Font.SourceSans
	ConnectButton.Text = ""
	ConnectButton.TextColor3 = Colours.TextColor -- Themed
	ConnectButton.TextSize = 14
	ConnectButton.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	ConnectButton.BackgroundTransparency = 1
	ConnectButton.BorderColor3 = Colours.Stroke -- Themed
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
	DropdownSelect.BackgroundColor3 = Colours.DropdownUnselected -- Themed (or ElementBackground)
	DropdownSelect.BorderColor3 = Colours.Stroke -- Themed
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

	UIStroke14.Color = Colours.Stroke -- Themed
	UIStroke14.Thickness = 2.5
	UIStroke14.Transparency = 0 -- Assuming opaque stroke from theme
	UIStroke14.Parent = DropdownSelect

	DropdownSelectReal.AnchorPoint = Vector2.new(0.5, 0.5)
	DropdownSelectReal.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
	DropdownSelectReal.BackgroundTransparency = 1
	DropdownSelectReal.BorderColor3 = Colours.Stroke -- Themed
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

	local isApplyingTheme = false -- Debounce flag to prevent re-entrancy issues

	local function applyTheme(themeIdentifier, isInitialLoad)
		if isApplyingTheme then return end -- Basic re-entrancy guard
		isApplyingTheme = true

		local themeToApply
		if type(themeIdentifier) == "string" then
			CurrentThemeName = themeIdentifier
			themeToApply = deepcopy(DefaultThemes[CurrentThemeName] or DefaultThemes["Rayfield Like"])
			if not DefaultThemes[CurrentThemeName] then
				warn("applyTheme: Theme '" .. CurrentThemeName .. "' not found. Using 'Rayfield Like'.")
			end
		elseif type(themeIdentifier) == "table" then
			if not DefaultThemes[CurrentThemeName] then CurrentThemeName = "Rayfield Like" end
			themeToApply = deepcopy(DefaultThemes[CurrentThemeName] or DefaultThemes["Rayfield Like"])
			for k,v in pairs(themeIdentifier) do
				if type(v) == "Color3" then
					themeToApply[k] = v
				end
			end
		else
			warn("applyTheme: Invalid themeIdentifier type. Expected string or table.")
			isApplyingTheme = false
			return
		end

		for k, v in pairs(themeToApply) do
			Colours[k] = v
		end

		if not isInitialLoad and type(themeIdentifier) == "string" then
			if Flags then
				for flagKey, flagValue in pairs(Flags) do
					if type(flagKey) == "string" and flagKey:match("^CustomColor_") then
						local parts = {}
						for part in flagKey:gmatch("([^_]+)") do table.insert(parts, part) end
						if #parts == 3 then
							local colorKeyName = parts[2]
							local componentLetter = parts[3]
							if Colours[colorKeyName] and type(Colours[colorKeyName]) == "Color3" then
								local r, g, b
								r, g, b = Colours[colorKeyName].R * 255, Colours[colorKeyName].G * 255, Colours[colorKeyName].B * 255
								local numVal = tonumber(flagValue)
								if numVal then
									if componentLetter == "R" then r = numVal end
									if componentLetter == "G" then g = numVal end
									if componentLetter == "B" then b = numVal end
									Colours[colorKeyName] = Color3.fromRGB(math.clamp(r,0,255), math.clamp(g,0,255), math.clamp(b,0,255))
								end
							end
						end
					end
				end
			end
		end

		if GuiConfig and Colours.GuiConfigColor then
			GuiConfig.Color = Colours.GuiConfigColor
		end

		-- Apply colors to static UI elements (ensure these instances are defined before applyTheme is called)
		if Main and Colours.Background then Main.BackgroundColor3 = Colours.Background end
		if Main and Colours.Stroke then Main.BorderColor3 = Colours.Stroke end -- Added from review
		if Top and Colours.Topbar then Top.BackgroundColor3 = Colours.Topbar end
		if Top and Colours.Stroke then Top.BorderColor3 = Colours.Stroke end -- Added from review
		if Info and Colours.TabBackground then Info.BackgroundColor3 = Colours.TabBackground end
		if Info and Colours.Stroke then Info.BorderColor3 = Colours.Stroke end -- Added from review
		if LayersTab and Colours.TabBackground then LayersTab.BackgroundColor3 = Colours.TabBackground end
		if LayersTab and Colours.Stroke then LayersTab.BorderColor3 = Colours.Stroke end -- Added from review
		if DecideFrame and Colours.Stroke then DecideFrame.BackgroundColor3 = Colours.Stroke end
		if NameTab and Colours.SelectedTabTextColor then NameTab.TextColor3 = Colours.SelectedTabTextColor end
		if TextLabel and Colours.Accent then TextLabel.TextColor3 = Colours.Accent end
		if TextLabel1 and Colours.TextColor then TextLabel1.TextColor3 = Colours.TextColor end -- Changed from Colours.Text
		if DropShadow and Colours.Shadow then DropShadow.ImageColor3 = Colours.Shadow end

		-- Ensure Main stroke is also updated by applyTheme
		if UIStroke and Colours.Stroke then UIStroke.Color = Colours.Stroke end

		-- ThemesButton in Info section (created in MakeGui)
		-- This needs to be updated if applyTheme is called after its creation and it's visible
		local themesButtonInInfo = Info and Info:FindFirstChild("ThemesButton")
		if themesButtonInInfo then
			if Colours.TextColor then themesButtonInInfo.TextColor3 = Colours.TextColor end
			if Colours.ElementBackground then themesButtonInInfo.BackgroundColor3 = Colours.ElementBackground end
		end

		-- MinimizedIcon colors
		if MinimizedIcon then
			if Colours.ThemeHighlight then
				MinimizedIcon.BackgroundColor3 = Colours.ThemeHighlight
				MinimizedIcon.BorderColor3 = Colours.ThemeHighlight
			end
		end

		-- MoreBlur Frame (Dropdown Popup Background)
		if MoreBlur then
			if Colours.Background then MoreBlur.BackgroundColor3 = Colours.Background end -- or Shadow
			if Colours.Stroke then MoreBlur.BorderColor3 = Colours.Stroke end
			local dsHolder = MoreBlur:FindFirstChild("DropShadowHolder")
			if dsHolder then
				local ds = dsHolder:FindFirstChild("DropShadow")
				if ds and Colours.Shadow then ds.ImageColor3 = Colours.Shadow end
			end
		end

		-- DropdownSelect Frame (actual dropdown list container in MoreBlur)
		if DropdownSelect then
			if Colours.DropdownUnselected then DropdownSelect.BackgroundColor3 = Colours.DropdownUnselected end
			if Colours.Stroke then DropdownSelect.BorderColor3 = Colours.Stroke end
			local strokeForDropdownSelect = DropdownSelect:FindFirstChildOfClass("UIStroke")
			if strokeForDropdownSelect and Colours.Stroke then strokeForDropdownSelect.Color = Colours.Stroke end
		end


		if (not isInitialLoad or type(themeIdentifier) == "table") and AllCreatedItemControls and AllCreatedItemControls.Sliders then
			for colorKey, sliders in pairs(AllCreatedItemControls.Sliders) do
				if Colours[colorKey] and type(Colours[colorKey]) == "Color3" then
					if sliders.R and sliders.R.Set then sliders.R:Set(math.floor(Colours[colorKey].R * 255 + 0.5), true) end
					if sliders.G and sliders.G.Set then sliders.G:Set(math.floor(Colours[colorKey].G * 255 + 0.5), true) end
					if sliders.B and sliders.B.Set then sliders.B:Set(math.floor(Colours[colorKey].B * 255 + 0.5), true) end
				end
			end
		end

		if Flags then
			Flags.SelectedTheme = CurrentThemeName
			for colorK, colorV in pairs(Colours) do
				if type(colorV) == "Color3" then
					Flags["CustomColor_" .. colorK .. "_R"] = math.floor(colorV.R * 255 + 0.5)
					Flags["CustomColor_" .. colorK .. "_G"] = math.floor(colorV.G * 255 + 0.5)
					Flags["CustomColor_" .. colorK .. "_B"] = math.floor(colorV.B * 255 + 0.5)
				end
			end
            if GuiConfig and GuiConfig.MainBackgroundTransparency ~= nil then
                UBHubLib.Flags.MainBackgroundTransparency = GuiConfig.MainBackgroundTransparency
            end

            if GuiConfig and GuiConfig.SaveFolder and FSO.writefile and HttpService then
                 local successSave, errSave = pcall(function()
                     local path = GuiConfig.SaveFolder
                     local encoded = HttpService:JSONEncode(UBHubLib.Flags)
                     FSO.writefile(path, encoded)
                 end)
                 if not successSave then
                     warn("Save (triggered by applyTheme) failed:", errSave)
                 end
            else
                if GuiConfig and GuiConfig.SaveFolder then
                    local missingFuncs = {}
                    if not FSO.writefile then table.insert(missingFuncs, "'FSO.writefile'") end
                    if not HttpService then table.insert(missingFuncs, "'HttpService'") end
                    if #missingFuncs > 0 then
                        warn("Saving is enabled in applyTheme, but required functions are missing: " .. table.concat(missingFuncs, ", "))
                    end
                end
            end
		end
		isApplyingTheme = false
	end

	CurrentThemeName = Flags.SelectedTheme or "Rayfield Like"
	applyTheme(CurrentThemeName, true)
	applyTheme(CurrentThemeName, false)

	UBHubLib.ApplyTheme = applyTheme
	UBHubLib.GetDefaultThemes = function() return DefaultThemes end -- Return a deepcopy if mutation is a concern
	UBHubLib.GetCurrentColours = function() return Colours end -- Return a deepcopy if mutation is a concern
	UBHubLib.AllCreatedItemControls = AllCreatedItemControls -- Expose for slider updates

	--// Tabs
	local Tabs = {}
	local CountTab = 0
	local CountDropdown = 0

	-- Store Tabs locally for Interface tab creation before returning
	local localTabsObject = Tabs


	function Tabs:CreateTab(TabConfig)
		local TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""
		local tabReturnData = {} -- Table to return references like the TabButton

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
		tabReturnData.TabFrame = Tab -- Store reference to the main tab frame
		local UICorner3 = Instance.new("UICorner");
		local TabButton = Instance.new("TextButton");
		tabReturnData.TabButton = TabButton -- Store reference to the TabButton
		local TabName = Instance.new("TextLabel")
		local FeatureImg
		local UIStroke2 = Instance.new("UIStroke");
		local UICorner4 = Instance.new("UICorner");

		if CountTab == 0 then
			Tab.BackgroundColor3 = Colours.TabBackgroundSelected -- Themed
			Tab.BackgroundTransparency = 0 -- Assuming opaque theme color
		else
			Tab.BackgroundColor3 = Colours.TabBackground -- Themed
			Tab.BackgroundTransparency = 0 -- Assuming opaque theme color
		end
		Tab.BorderColor3 = Colours.Stroke -- Themed
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
		TabName.TextColor3 = (CountTab == 0) and Colours.SelectedTabTextColor or Colours.TabTextColor -- Themed
		TabName.TextSize = 13
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
		TabName.BackgroundTransparency = 1
		TabName.BorderColor3 = Colours.Stroke -- Themed
		TabName.BorderSizePixel = 0
		TabName.Size = UDim2.new(1, 0, 1, 0)
		TabName.Position = UDim2.new(0, 30, 0, 0)
		TabName.Name = "TabName"
		TabName.Parent = Tab

		if typeof(TabConfig.Icon) == "string" and not string.find(TabConfig.Icon, "rbxassetid://") and Lucide and Lucide.ImageLabel then
			FeatureImg = Lucide.ImageLabel(TabConfig.Icon, 16, {
				Parent = Tab,
				Position = UDim2.new(0, 9, 0, 7),
				ImageColor3 = Colours.Text,
				BackgroundTransparency = 1,
				Name = "FeatureImg"
			})
		else
			FeatureImg = Instance.new("ImageLabel")
			FeatureImg.Image = TabConfig.Icon or ""
			FeatureImg.ImageColor3 = Colours.Text
			FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeatureImg.BackgroundTransparency = 0.9990000128746033
			FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureImg.BorderSizePixel = 0
			FeatureImg.Position = UDim2.new(0, 9, 0, 7)
			FeatureImg.Size = UDim2.new(0, 16, 0, 16)
			FeatureImg.Name = "FeatureImg"
			FeatureImg.Parent = Tab
		end

		if CountTab == 0 then
			LayersPageLayout:JumpToIndex(0)
			NameTab.Text = TabConfig.Name
			local ChooseFrame = Instance.new("Frame");
			ChooseFrame.BackgroundColor3 = Colours.ThemeHighlight -- Themed
			ChooseFrame.BorderColor3 = Colours.Stroke -- Themed
			ChooseFrame.BorderSizePixel = 0
			ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
			ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
			ChooseFrame.Name = "ChooseFrame"
			ChooseFrame.Parent = Tab

			UIStroke2.Color = Colours.ThemeHighlight -- Themed (was GuiConfig.Color)
			UIStroke2.Thickness = 1.600000023841858
			UIStroke2.Parent = ChooseFrame

			UICorner4.Parent = ChooseFrame
            UICorner4.CornerRadius = UDim.new(0,2) 
		end
		TabButton.Activated:Connect(function()
			CircleClick(TabButton, Mouse.X, Mouse.Y)
			local FrameChoose
			for _, s in ipairs(ScrollTab:GetChildren()) do
                if s:IsA("GuiObject") then
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
				for _, tabFrameInstance in ipairs(ScrollTab:GetChildren()) do
					if tabFrameInstance.Name == "Tab" then
						TweenService:Create(tabFrameInstance,TweenInfo.new(0.001, Enum.EasingStyle.Linear),{BackgroundColor3 = Colours.TabBackground, BackgroundTransparency = 0}):Play()
						local tn = tabFrameInstance:FindFirstChild("TabName")
						if tn then tn.TextColor3 = Colours.TabTextColor end
					end
				end
				TweenService:Create(Tab, TweenInfo.new(0.001, Enum.EasingStyle.Linear), {BackgroundColor3 = Colours.TabBackgroundSelected, BackgroundTransparency = 0}):Play()
				TabName.TextColor3 = Colours.SelectedTabTextColor
				TweenService:Create(FrameChoose,TweenInfo.new(0.01, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 2, 0, 9 + (33 * Tab.LayoutOrder))}):Play()
				LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
				NameTab.Text = TabConfig.Name
				TweenService:Create(FrameChoose,TweenInfo.new(0.01, Enum.EasingStyle.Linear),{Size = UDim2.new(0, 1, 0, 20)}):Play()
			end
		end)

		-- Store tab button reference for the "Themes" button in Info, if this is the Themes tab
		if TabConfig.Name == "Themes" and UBHubLib.TabReferences then
			UBHubLib.TabReferences["Themes"] = {
				TabButton = TabButton, -- The actual button instance
				Name = TabConfig.Name,
				ScrollFramePage = ScrolLayers -- The page instance for this tab
			}
		end

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
			SectionReal.BackgroundColor3 = Colours.SecondaryElementBackground -- Themed
			SectionReal.BackgroundTransparency = 0 -- Assuming opaque theme color
			SectionReal.BorderColor3 = Colours.Stroke -- Themed
			SectionReal.BorderSizePixel = 0
			SectionReal.LayoutOrder = 1
			SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
			SectionReal.Size = UDim2.new(1, 1, 0, 30)
			SectionReal.Name = "SectionReal"
			SectionReal.Parent = Section

			UICorner_SectionReal.CornerRadius = UDim.new(0, 4)
			UICorner_SectionReal.Parent = SectionReal

			SectionButton.Font = Enum.Font.SourceSans
			SectionButton.Text = ""
			SectionButton.TextColor3 = Colours.TextColor -- Themed (text is empty)
			SectionButton.TextSize = 14
			SectionButton.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
			SectionButton.BackgroundTransparency = 1
			SectionButton.BorderColor3 = Colours.Stroke -- Themed
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
			FeatureImg_Section.ImageColor3 = Colours.TextColor -- Themed
			FeatureImg_Section.AnchorPoint = Vector2.new(0.5, 0.5)
			FeatureImg_Section.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
			FeatureImg_Section.BackgroundTransparency = 1
			FeatureImg_Section.BorderColor3 = Colours.Stroke -- Themed
			FeatureImg_Section.BorderSizePixel = 0
			FeatureImg_Section.Position = UDim2.new(0.5, 0, 0.5, 0)
			FeatureImg_Section.Rotation = -90
			FeatureImg_Section.Size = UDim2.new(1, 6, 1, 6)
			FeatureImg_Section.Name = "FeatureImg"
			FeatureImg_Section.Parent = FeatureFrame

			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.Text = Title
			SectionTitle.TextColor3 = Colours.TextColor -- Themed
			SectionTitle.TextSize = 13
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.TextYAlignment = Enum.TextYAlignment.Top
			SectionTitle.AnchorPoint = Vector2.new(0, 0.5)
			SectionTitle.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.BorderColor3 = Colours.Stroke -- Themed
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
            UICorner1_Section.CornerRadius = UDim.new(0,2) 

			UIGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Colours.Stroke),
				ColorSequenceKeypoint.new(0.5, Colours.Primary),
				ColorSequenceKeypoint.new(1, Colours.Stroke)
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

			UICorner8.CornerRadius = UDim.new(0, 2)
			UICorner8.Parent = SectionAdd

			UIListLayout2.Padding = UDim.new(0, 3)
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
                local lineColor = DividerConfig.Color or Colours.Stroke -- Themed (was Colours.Accent)
                local textColor = DividerConfig.TextColor or Colours.SecondaryTextColor or Colours.TextColor -- Themed
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
                    DividerText.Font = Enum.Font.GothamBold
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
				local ParagraphFunc = {}
				
				local Paragraph = Instance.new("Frame");
				local UICorner14 = Instance.new("UICorner");
				local ParagraphTitle = Instance.new("TextLabel");

				Paragraph.BackgroundColor3 = Colours.ElementBackground -- Themed
				Paragraph.BackgroundTransparency = 0 -- Assuming opaque theme color
				Paragraph.BorderColor3 = Colours.Stroke -- Themed
				Paragraph.BorderSizePixel = 0
				Paragraph.LayoutOrder = CountItem
				Paragraph.Size = UDim2.new(1, 0, 0, 46) 
				Paragraph.Name = "Paragraph"
				Paragraph.Parent = SectionAdd

				UICorner14.CornerRadius = UDim.new(0, 4)
				UICorner14.Parent = Paragraph

				ParagraphTitle.Font = Enum.Font.GothamBold
				ParagraphTitle.Text = ParagraphConfig.Title .. " | " .. ParagraphConfig.Content
				ParagraphTitle.TextColor3 = Colours.TextColor -- Themed
				ParagraphTitle.TextSize = 13
                ParagraphTitle.TextWrapped = true
				ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
				ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
				ParagraphTitle.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				ParagraphTitle.BackgroundTransparency = 1
				ParagraphTitle.BorderColor3 = Colours.Stroke -- Themed
				ParagraphTitle.BorderSizePixel = 0
				ParagraphTitle.Position = UDim2.new(0, 10, 0, 10)
				ParagraphTitle.Size = UDim2.new(1, -20, 0, 13) 
				ParagraphTitle.Name = "ParagraphTitle"
				ParagraphTitle.Parent = Paragraph
				
                local function UpdateParagraphSize()
                    task.wait()
                    local textBounds = ParagraphTitle.TextBounds
                    local newHeight = textBounds.Y + 20 
                    Paragraph.Size = UDim2.new(1, 0, 0, math.max(newHeight, 46))
                    ParagraphTitle.Size = UDim2.new(1, -20, 0, textBounds.Y) 
                    UpdateSizeSection()
                end
                
                ParagraphTitle:GetPropertyChangedSignal("TextBounds"):Connect(UpdateParagraphSize)
                UpdateParagraphSize() 

				function ParagraphFunc:Set(NewParagraphConfig) 
					NewParagraphConfig = NewParagraphConfig or {}
					ParagraphConfig.Title = NewParagraphConfig.Title or ParagraphConfig.Title 
					ParagraphConfig.Content = NewParagraphConfig.Content or ParagraphConfig.Content
					ParagraphTitle.Text = ParagraphConfig.Title .. " | " .. ParagraphConfig.Content
                    UpdateParagraphSize() 
				end
				CountItem = CountItem + 1
				return ParagraphFunc
			end
			function Items:AddButton(ButtonConfig)
				local ButtonConfig = ButtonConfig or {}
				ButtonConfig.Title = ButtonConfig.Title or "Title"
				ButtonConfig.Content = ButtonConfig.Content or "Content"
				ButtonConfig.Icon = ButtonConfig.Icon or "rbxassetid://16932740082"
				ButtonConfig.Callback = ButtonConfig.Callback or function() end
				local ButtonFunc = {}

				local Button = Instance.new("Frame");
				local UICorner9 = Instance.new("UICorner");
				local ButtonTitle = Instance.new("TextLabel");
				local ButtonContent = Instance.new("TextLabel");
				local ButtonButton = Instance.new("TextButton");
				local FeatureFrame1 = Instance.new("Frame");
				local FeatureImg3 -- Declared here, instantiated below

				Button.BackgroundColor3 = Colours.ElementBackground -- Themed
				Button.BackgroundTransparency = 0 -- Assuming opaque theme color
				Button.BorderColor3 = Colours.ElementStroke -- Themed
				Button.BorderSizePixel = 0
				Button.LayoutOrder = CountItem
				Button.Size = UDim2.new(1, 0, 0, 46)
				Button.Name = "Button"
				Button.Parent = SectionAdd

				UICorner9.CornerRadius = UDim.new(0, 4)
				UICorner9.Parent = Button

				ButtonTitle.Font = Enum.Font.GothamBold
				ButtonTitle.Text = ButtonConfig.Title
				ButtonTitle.TextColor3 = Colours.TextColor -- Themed
				ButtonTitle.TextSize = 13
				ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
				ButtonTitle.TextYAlignment = Enum.TextYAlignment.Top
				ButtonTitle.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				ButtonTitle.BackgroundTransparency = 1
				ButtonTitle.BorderColor3 = Colours.Stroke -- Themed
				ButtonTitle.BorderSizePixel = 0
				ButtonTitle.Position = UDim2.new(0, 10, 0, 10)
				ButtonTitle.Size = UDim2.new(1, -100, 0, 13)
				ButtonTitle.Name = "ButtonTitle"
				ButtonTitle.Parent = Button

				ButtonContent.Font = Enum.Font.GothamBold
				ButtonContent.Text = ButtonConfig.Content
				ButtonContent.TextColor3 = Colours.SecondaryTextColor or Colours.TextColor -- Themed (prefer SecondaryTextColor if defined)
				ButtonContent.TextSize = 12
				ButtonContent.TextTransparency = (Colours.SecondaryTextColor == nil) and 0.6 or 0 -- Apply transparency if using base TextColor
				ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
				ButtonContent.TextYAlignment = Enum.TextYAlignment.Bottom
                ButtonContent.TextWrapped = true
				ButtonContent.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				ButtonContent.BackgroundTransparency = 1
				ButtonContent.BorderColor3 = Colours.Stroke -- Themed
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


				ButtonButton.Font = Enum.Font.SourceSans
				ButtonButton.Text = ""
				ButtonButton.TextColor3 = Colours.TextColor -- Themed (text is empty)
				ButtonButton.TextSize = 14
				ButtonButton.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				ButtonButton.BackgroundTransparency = 1
				ButtonButton.BorderColor3 = Colours.Stroke -- Themed
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

				local iconToUse = ButtonConfig.Icon or "rbxassetid://16932740082"

				if typeof(iconToUse) == "string" and not string.find(iconToUse, "rbxassetid://") and Lucide and Lucide.ImageLabel then
					FeatureImg3 = Lucide.ImageLabel(iconToUse, 20, {
						Parent = FeatureFrame1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 1, 0),
						ImageColor3 = Colours.Text,
						BackgroundTransparency = 1,
						Name = "FeatureImg"
					})
				else
					FeatureImg3 = Instance.new("ImageLabel")
					FeatureImg3.Image = iconToUse
					FeatureImg3.ImageColor3 = Colours.Text
					FeatureImg3.AnchorPoint = Vector2.new(0.5, 0.5)
					FeatureImg3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					FeatureImg3.BackgroundTransparency = 0.9990000128746033
					FeatureImg3.BorderColor3 = Color3.fromRGB(0, 0, 0)
					FeatureImg3.BorderSizePixel = 0
					FeatureImg3.Position = UDim2.new(0.5, 0, 0.5, 0)
					FeatureImg3.Size = UDim2.new(1, 0, 1, 0)
					FeatureImg3.Name = "FeatureImg"
					FeatureImg3.Parent = FeatureFrame1
				end

				ButtonButton.Activated:Connect(function()
					CircleClick(ButtonButton, Mouse.X, Mouse.Y)
					ButtonConfig.Callback()
				end)
				CountItem = CountItem + 1
				return ButtonFunc
			end
			function Items:AddToggle(ToggleConfig)
				local ToggleConfig = ToggleConfig or {}
				ToggleConfig.Title = ToggleConfig.Title or "no Title"
				ToggleConfig.Content = ToggleConfig.Content or ""
				ToggleConfig.Default = (ToggleConfig.Flag and Flags[ToggleConfig.Flag] ~= nil) and Flags[ToggleConfig.Flag] or ToggleConfig.Default or false                    
				ToggleConfig.Callback = ToggleConfig.Callback or function() end
				local ToggleFunc = {Value = ToggleConfig.Default}

				local Toggle = Instance.new("Frame");
				local UICorner20 = Instance.new("UICorner");
				local ToggleTitle = Instance.new("TextLabel");
				local ToggleContent = Instance.new("TextLabel");
				local ToggleButton = Instance.new("TextButton");
				local FeatureFrame2 = Instance.new("Frame");
				local UICorner22 = Instance.new("UICorner");
				local UIStroke8 = Instance.new("UIStroke");
				local ToggleCircle = Instance.new("Frame");
				local UICorner23 = Instance.new("UICorner");

				Toggle.BackgroundColor3 = Colours.ElementBackground -- Themed
				Toggle.BackgroundTransparency = 0 -- Assuming opaque theme color
				Toggle.BorderColor3 = Colours.Stroke -- Themed
				Toggle.BorderSizePixel = 0
				Toggle.LayoutOrder = CountItem
				Toggle.Size = UDim2.new(1, 0, 0, 46)
				Toggle.Name = "Toggle"
				Toggle.Parent = SectionAdd

				UICorner20.CornerRadius = UDim.new(0, 4)
				UICorner20.Parent = Toggle

				ToggleTitle.Font = Enum.Font.GothamBold
				ToggleTitle.Text = ToggleConfig.Title
				ToggleTitle.TextSize = 13
				ToggleTitle.TextColor3 = Colours.TextColor -- Themed (dynamic color change on toggle)
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
				ToggleTitle.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				ToggleTitle.BackgroundTransparency = 1
				ToggleTitle.BorderColor3 = Colours.Stroke -- Themed
				ToggleTitle.BorderSizePixel = 0
				ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
				ToggleTitle.Size = UDim2.new(1, -100, 0, 13)
				ToggleTitle.Name = "ToggleTitle"
				ToggleTitle.Parent = Toggle

				ToggleContent.Font = Enum.Font.GothamBold
				ToggleContent.Text = ToggleConfig.Content
				ToggleContent.TextColor3 = Colours.SecondaryTextColor or Colours.TextColor -- Themed
				ToggleContent.TextSize = 12
				ToggleContent.TextTransparency = (Colours.SecondaryTextColor == nil) and 0.6 or 0 -- Apply transparency if using base TextColor
				ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
				ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom
                ToggleContent.TextWrapped = true
				ToggleContent.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				ToggleContent.BackgroundTransparency = 1
				ToggleContent.BorderColor3 = Colours.Stroke -- Themed
				ToggleContent.BorderSizePixel = 0
				ToggleContent.Position = UDim2.new(0, 10, 0, 23)
				ToggleContent.Size = UDim2.new(1, -100, 0, 12)
				ToggleContent.Name = "ToggleContent"
				ToggleContent.Parent = Toggle
				
                local function UpdateToggleFrameSize()
                    task.wait()
                    local contentHeight = ToggleContent.TextBounds.Y
                    Toggle.Size = UDim2.new(1, 0, 0, math.max(46, 23 + contentHeight + 10))
                    ToggleContent.Size = UDim2.new(1, -100, 0, contentHeight)
                    UpdateSizeSection()
                end
                ToggleContent:GetPropertyChangedSignal("TextBounds"):Connect(UpdateToggleFrameSize)
                UpdateToggleFrameSize()


				ToggleButton.Font = Enum.Font.SourceSans
				ToggleButton.Text = ""
				ToggleButton.TextColor3 = Colours.TextColor -- Themed (text is empty)
				ToggleButton.TextSize = 14
				ToggleButton.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				ToggleButton.BackgroundTransparency = 1
				ToggleButton.BorderColor3 = Colours.Stroke -- Themed
				ToggleButton.BorderSizePixel = 0
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Name = "ToggleButton"
				ToggleButton.Parent = Toggle

				FeatureFrame2.AnchorPoint = Vector2.new(1, 0.5)
				FeatureFrame2.BackgroundColor3 = Colours.ToggleBackground -- Themed (dynamic change on toggle)
				FeatureFrame2.BackgroundTransparency = 0 -- Assuming opaque theme color
				FeatureFrame2.BorderColor3 = Colours.ToggleDisabledOuterStroke -- Themed (dynamic change on toggle)
				FeatureFrame2.BorderSizePixel = 0
				FeatureFrame2.Position = UDim2.new(1, -30, 0.5, 0)
				FeatureFrame2.Size = UDim2.new(0, 30, 0, 15)
				FeatureFrame2.Name = "FeatureFrame"
				FeatureFrame2.Parent = Toggle

				UICorner22.Parent = FeatureFrame2
                UICorner22.CornerRadius = UDim.new(0,8) 

				UIStroke8.Color = Colours.ToggleDisabledStroke -- Themed (dynamic change on toggle)
				UIStroke8.Thickness = 2
				UIStroke8.Transparency = 0 -- Assuming opaque theme color
				UIStroke8.Parent = FeatureFrame2

				ToggleCircle.BackgroundColor3 = Colours.TextColor -- Themed (or specific knob color)
				ToggleCircle.BorderColor3 = Colours.Stroke -- Themed
				ToggleCircle.BorderSizePixel = 0
				ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
                ToggleCircle.AnchorPoint = Vector2.new(0,0.5)
                ToggleCircle.Position = UDim2.new(0,0.5,0.5,0) 
				ToggleCircle.Name = "ToggleCircle"
				ToggleCircle.Parent = FeatureFrame2

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
                    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
					if Value then
						TweenService:Create(ToggleTitle, tweenInfo, {TextColor3 = Colours.ToggleEnabled}):Play() -- Or Colours.Accent
						TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(1, -ToggleCircle.AbsoluteSize.X - 0.5, 0.5, 0)}):Play()
						TweenService:Create(UIStroke8, tweenInfo, {Color = Colours.ToggleEnabledStroke, Transparency = 0}):Play()
						TweenService:Create(FeatureFrame2, tweenInfo, {BackgroundColor3 = Colours.ToggleEnabled, BorderColor3 = Colours.ToggleEnabledOuterStroke, BackgroundTransparency = 0}):Play()
					else
						TweenService:Create(ToggleTitle, tweenInfo, {TextColor3 = Colours.TextColor}):Play()
						TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(0, 0.5, 0.5, 0)}):Play()
						TweenService:Create(UIStroke8, tweenInfo, {Color = Colours.ToggleDisabledStroke, Transparency = 0}):Play()
						TweenService:Create(FeatureFrame2, tweenInfo, {BackgroundColor3 = Colours.ToggleBackground, BorderColor3 = Colours.ToggleDisabledOuterStroke, BackgroundTransparency = 0}):Play()
					end
				end
				ToggleFunc:Set(ToggleFunc.Value)
				CountItem = CountItem + 1
				return ToggleFunc
			end
			function Items:AddSlider(SliderConfig)
				local SliderConfig = SliderConfig or {}
				SliderConfig.Title = SliderConfig.Title or "Slider"
				SliderConfig.Content = SliderConfig.Content or "Content"
				SliderConfig.Increment = SliderConfig.Increment or 1
				SliderConfig.Min = SliderConfig.Min or 0
				SliderConfig.Max = SliderConfig.Max or 100
				SliderConfig.Default = (SliderConfig.Flag and Flags[SliderConfig.Flag] ~= nil) and Flags[SliderConfig.Flag] or SliderConfig.Default or SliderConfig.Min
				SliderConfig.Callback = SliderConfig.Callback or function() end
				local SliderFunc = {Value = SliderConfig.Default}
	
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

				Slider.BackgroundColor3 = Colours.ElementBackground -- Themed
				Slider.BackgroundTransparency = 0 -- Assuming opaque theme color
				Slider.BorderColor3 = Colours.Stroke -- Themed
				Slider.BorderSizePixel = 0
				Slider.LayoutOrder = CountItem
				Slider.Size = UDim2.new(1, 0, 0, 46)
				Slider.Name = "Slider"
				Slider.Parent = SectionAdd

				UICorner15.CornerRadius = UDim.new(0, 4)
				UICorner15.Parent = Slider

				SliderTitle.Font = Enum.Font.GothamBold
				SliderTitle.Text = SliderConfig.Title
				SliderTitle.TextColor3 = Colours.TextColor -- Themed
				SliderTitle.TextSize = 13
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
				SliderTitle.TextYAlignment = Enum.TextYAlignment.Top
				SliderTitle.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				SliderTitle.BackgroundTransparency = 1
				SliderTitle.BorderColor3 = Colours.Stroke -- Themed
				SliderTitle.BorderSizePixel = 0
				SliderTitle.Position = UDim2.new(0, 10, 0, 10)
				SliderTitle.Size = UDim2.new(1, -180, 0, 13)
				SliderTitle.Name = "SliderTitle"
				SliderTitle.Parent = Slider

				SliderContent.Font = Enum.Font.GothamBold
				SliderContent.Text = SliderConfig.Content
				SliderContent.TextColor3 = Colours.SecondaryTextColor or Colours.TextColor -- Themed
				SliderContent.TextSize = 12
				SliderContent.TextTransparency = (Colours.SecondaryTextColor == nil) and 0.6 or 0 -- Apply transparency if using base TextColor
                SliderContent.TextWrapped = true
				SliderContent.TextXAlignment = Enum.TextXAlignment.Left
				SliderContent.TextYAlignment = Enum.TextYAlignment.Bottom
				SliderContent.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				SliderContent.BackgroundTransparency = 1
				SliderContent.BorderColor3 = Colours.Stroke -- Themed
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
				SliderInput.BackgroundColor3 = Colours.InputBackground -- Themed (was Colours.Accent old static)
				SliderInput.BorderColor3 = Colours.Stroke -- Themed
				SliderInput.BorderSizePixel = 0
				SliderInput.Position = UDim2.new(1, -155, 0.5, 0)
				SliderInput.Size = UDim2.new(0, 28, 0, 20)
				SliderInput.Name = "SliderInput"
				SliderInput.Parent = Slider

				UICorner16.CornerRadius = UDim.new(0, 2)
				UICorner16.Parent = SliderInput

				TextBox.Font = Enum.Font.GothamBold
				TextBox.Text = tostring(SliderConfig.Default)
				TextBox.TextColor3 = Colours.TextColor -- Themed
				TextBox.TextSize = 13
				TextBox.TextWrapped = true
				TextBox.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				TextBox.BackgroundTransparency = 1
				TextBox.BorderColor3 = Colours.Stroke -- Themed (though likely not visible due to size)
				TextBox.BorderSizePixel = 0
				TextBox.Position = UDim2.new(0, -1, 0, 0)
				TextBox.Size = UDim2.new(1, 0, 1, 0)
				TextBox.Parent = SliderInput

				SliderFrame.AnchorPoint = Vector2.new(1, 0.5)
				SliderFrame.BackgroundColor3 = Colours.SliderBackground -- Themed
				SliderFrame.BackgroundTransparency = 0 -- Assuming opaque theme color
				SliderFrame.BorderColor3 = Colours.Stroke -- Themed
				SliderFrame.BorderSizePixel = 0
				SliderFrame.Position = UDim2.new(1, -20, 0.5, 0)
				SliderFrame.Size = UDim2.new(0, 100, 0, 3)
				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Slider

				UICorner17.Parent = SliderFrame
                UICorner17.CornerRadius = UDim.new(0,3) 

				SliderDraggable.AnchorPoint = Vector2.new(0, 0.5)
				SliderDraggable.BackgroundColor3 = Colours.SliderProgress -- Themed (was Colours.Accent old static)
				SliderDraggable.BorderColor3 = Colours.Stroke --Themed
				SliderDraggable.BorderSizePixel = 0
				SliderDraggable.Position = UDim2.new(0, 0, 0.5, 0)
				SliderDraggable.Size = UDim2.new(0.899999976, 0, 1, 0) 
				SliderDraggable.Name = "SliderDraggable"
				SliderDraggable.Parent = SliderFrame

				UICorner18.Parent = SliderDraggable
                UICorner18.CornerRadius = UDim.new(0,3) 

				SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
				SliderCircle.BackgroundColor3 = Colours.SliderProgress -- Themed (was Colours.ThemeHighlight old static, now matches progress)
				SliderCircle.BorderColor3 = Colours.Stroke -- Themed
				SliderCircle.BorderSizePixel = 0
				SliderCircle.Position = UDim2.new(1, 4, 0.5, 0)
				SliderCircle.Size = UDim2.new(0, 8, 0, 8)
				SliderCircle.Name = "SliderCircle"
				SliderCircle.Parent = SliderDraggable

				UICorner19.Parent = SliderCircle
                UICorner19.CornerRadius = UDim.new(0,8) 

				UIStroke6.Color = Colours.SliderStroke -- Themed (was GuiConfig.Color)
				UIStroke6.Parent = SliderCircle

				local Dragging = false
                local DragInputObject = nil 

				local function Round(Number, Factor)
					return math.floor(Number/Factor + 0.5) * Factor
				end
                
				function SliderFunc:Set(Value, fromInput)
                    fromInput = fromInput or false
					Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)
					if SliderFunc.Value ~= Value or fromInput then
						SliderFunc.Value = Value
						local formatValue = Value
						if SliderConfig.Increment < 1 then
							local decimalPlaces = math.max(0, -math.floor(math.log10(SliderConfig.Increment)))
							formatValue = string.format("%."..decimalPlaces.."f", Value)
						end
						TextBox.Text = tostring(formatValue)
						local scale = (Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                        scale = math.clamp(scale,0,1) 

						if Dragging or fromInput then 
							SliderDraggable.Size = UDim2.fromScale(scale, 1)
						else
							TweenService:Create(SliderDraggable,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.fromScale(scale, 1)}):Play()
						end
						SliderConfig.Callback(SliderFunc.Value)
                        if SliderConfig.Flag and typeof(SliderConfig.Flag) == "string" then
                            SaveFile(SliderConfig.Flag, SliderFunc.Value)
                        end
					end
				end

				SliderFrame.InputBegan:Connect(function(Input)
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
                
                UserInputService.InputChanged:Connect(function(Input)
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

				UserInputService.InputEnded:Connect(function(Input) 
					if Dragging and Input == DragInputObject then 
						if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
							Dragging = false 
                            DragInputObject = nil
						end 
					end 
				end)

				TextBox:GetPropertyChangedSignal("Text"):Connect(function()
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
                    if enterPressed or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then 
                        local numVal = tonumber(TextBox.Text)
                        if numVal ~= nil then
                            SliderFunc:Set(numVal, true)
                        else
                            SliderFunc:Set(SliderConfig.Min, true) 
                        end
                    end
				end)
				SliderFunc:Set(tonumber(SliderConfig.Default), true) 
				CountItem = CountItem + 1
				return SliderFunc
			end
			function Items:AddInput(InputConfig)
				local InputConfig = InputConfig or {}
				InputConfig.Title = InputConfig.Title or "Title"
				InputConfig.Content = InputConfig.Content or "Content"
                InputConfig.Default = (InputConfig.Flag and Flags[InputConfig.Flag] ~= nil) and Flags[InputConfig.Flag] or InputConfig.Default or ""
				InputConfig.Callback = InputConfig.Callback or function() end
				local InputFunc = {Value = InputConfig.Default}
				local Input = Instance.new("Frame");
				local UICorner12 = Instance.new("UICorner");
				local InputTitle = Instance.new("TextLabel");
				local InputContent = Instance.new("TextLabel");
				local InputFrame = Instance.new("Frame");
				local UICorner13 = Instance.new("UICorner");
				local InputTextBox = Instance.new("TextBox");

				Input.BackgroundColor3 = Colours.ElementBackground -- Themed
				Input.BackgroundTransparency = 0 -- Assuming opaque theme color
				Input.BorderColor3 = Colours.Stroke -- Themed
				Input.BorderSizePixel = 0
				Input.LayoutOrder = CountItem
				Input.Size = UDim2.new(1, 0, 0, 46)
				Input.Name = "Input"
				Input.Parent = SectionAdd

				UICorner12.CornerRadius = UDim.new(0, 4)
				UICorner12.Parent = Input

				InputTitle.Font = Enum.Font.GothamBold
				InputTitle.Text = InputConfig.Title
				InputTitle.TextColor3 = Colours.TextColor -- Themed
				InputTitle.TextSize = 13
				InputTitle.TextXAlignment = Enum.TextXAlignment.Left
				InputTitle.TextYAlignment = Enum.TextYAlignment.Top
				InputTitle.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				InputTitle.BackgroundTransparency = 1
				InputTitle.BorderColor3 = Colours.Stroke -- Themed
				InputTitle.BorderSizePixel = 0
				InputTitle.Position = UDim2.new(0, 10, 0, 10)
				InputTitle.Size = UDim2.new(1, -180, 0, 13)
				InputTitle.Name = "InputTitle"
				InputTitle.Parent = Input

				InputContent.Font = Enum.Font.GothamBold
				InputContent.Text = InputConfig.Content
				InputContent.TextColor3 = Colours.SecondaryTextColor or Colours.TextColor -- Themed
				InputContent.TextSize = 12
				InputContent.TextTransparency = (Colours.SecondaryTextColor == nil) and 0.6 or 0 -- Apply transparency if using base TextColor
				InputContent.TextWrapped = true
				InputContent.TextXAlignment = Enum.TextXAlignment.Left
				InputContent.TextYAlignment = Enum.TextYAlignment.Bottom
				InputContent.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				InputContent.BackgroundTransparency = 1
				InputContent.BorderColor3 = Colours.Stroke -- Themed
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
				InputFrame.BackgroundColor3 = Colours.InputBackground -- Themed
				InputFrame.BackgroundTransparency = 0 -- Assuming opaque theme color
				InputFrame.BorderColor3 = Colours.InputStroke -- Themed (or just Colours.Stroke)
				InputFrame.BorderSizePixel = 0
				InputFrame.ClipsDescendants = true
				InputFrame.Position = UDim2.new(1, -7, 0.5, 0)
				InputFrame.Size = UDim2.new(0, 148, 0, 30)
				InputFrame.Name = "InputFrame"
				InputFrame.Parent = Input

				UICorner13.CornerRadius = UDim.new(0, 4)
				UICorner13.Parent = InputFrame

				InputTextBox.CursorPosition = -1
				InputTextBox.Font = Enum.Font.GothamBold
				InputTextBox.PlaceholderColor3 = Colours.PlaceholderColor -- Themed
				InputTextBox.PlaceholderText = "Write your input there"
				InputTextBox.Text = tostring(InputFunc.Value)
				InputTextBox.TextColor3 = Colours.TextColor -- Themed
				InputTextBox.TextSize = 12
				InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
				InputTextBox.AnchorPoint = Vector2.new(0, 0.5)
				InputTextBox.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				InputTextBox.BackgroundTransparency = 1
				InputTextBox.BorderColor3 = Colours.Stroke -- Themed (though likely not visible)
				InputTextBox.BorderSizePixel = 0
				InputTextBox.Position = UDim2.new(0, 5, 0.5, 0)
				InputTextBox.Size = UDim2.new(1, -10, 1, -8)
				InputTextBox.Name = "InputTextBox"
				InputTextBox.Parent = InputFrame
				function InputFunc:Set(Value)
					InputTextBox.Text = tostring(Value) 
					InputFunc.Value = Value 
					InputConfig.Callback(Value)
					if InputConfig.Flag and typeof(InputConfig.Flag) == "string" then
						SaveFile(InputConfig.Flag,InputFunc.Value)
					end
				end
				InputTextBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
					    InputFunc:Set(InputTextBox.Text)
                    end
				end)
				CountItem = CountItem + 1
				return InputFunc
			end
			function Items:AddDropdown(DropdownConfig)
				local DropdownConfig = DropdownConfig or {}
				DropdownConfig.Title = DropdownConfig.Title or "No Title"
				DropdownConfig.Content = DropdownConfig.Content or ""
				DropdownConfig.Multi = DropdownConfig.Multi or false
				DropdownConfig.Options = DropdownConfig.Options or {}
				local savedValue = DropdownConfig.Flag and Flags[DropdownConfig.Flag]

				if DropdownConfig.Multi then
					DropdownConfig.Default = (savedValue and type(savedValue) == "table") and savedValue or (type(DropdownConfig.Default) == "table" and DropdownConfig.Default or {})
				else
                    local defaultSingle = type(savedValue) == "table" and savedValue[1] or savedValue
					DropdownConfig.Default = defaultSingle or DropdownConfig.Default
				end
				DropdownConfig.Callback = DropdownConfig.Callback or function() end

				local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options}
	
				local Dropdown = Instance.new("Frame");
				local DropdownButton = Instance.new("TextButton");
				local UICorner10 = Instance.new("UICorner");
				local DropdownTitle = Instance.new("TextLabel");
				local DropdownContent = Instance.new("TextLabel");
				local SelectOptionsFrame = Instance.new("Frame");
				local UICorner11 = Instance.new("UICorner");
				local OptionSelecting = Instance.new("TextLabel");
				local OptionImg = Instance.new("ImageLabel");

				Dropdown.BackgroundColor3 = Colours.ElementBackground -- Themed
				Dropdown.BackgroundTransparency = 0 -- Assuming opaque theme color
				Dropdown.BorderColor3 = Colours.Stroke -- Themed
				Dropdown.BorderSizePixel = 0
				Dropdown.LayoutOrder = CountItem
				Dropdown.Size = UDim2.new(1, 0, 0, 46)
				Dropdown.Name = "Dropdown"
				Dropdown.Parent = SectionAdd

				DropdownButton.Font = Enum.Font.SourceSans
				DropdownButton.Text = ""
				DropdownButton.TextColor3 = Colours.TextColor -- Themed (text is empty)
				DropdownButton.TextSize = 14
				DropdownButton.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				DropdownButton.BackgroundTransparency = 1
				DropdownButton.BorderColor3 = Colours.Stroke -- Themed
				DropdownButton.BorderSizePixel = 0
				DropdownButton.Size = UDim2.new(1, 0, 1, 0)
				DropdownButton.Name = "DropdownActivationButton"
				DropdownButton.Parent = Dropdown

				UICorner10.CornerRadius = UDim.new(0, 4)
				UICorner10.Parent = Dropdown

				DropdownTitle.Font = Enum.Font.GothamBold
				DropdownTitle.Text = DropdownConfig.Title
				DropdownTitle.TextColor3 = Colours.TextColor -- Themed
				DropdownTitle.TextSize = 13
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
				DropdownTitle.TextYAlignment = Enum.TextYAlignment.Top
				DropdownTitle.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				DropdownTitle.BackgroundTransparency = 1
				DropdownTitle.BorderColor3 = Colours.Stroke -- Themed
				DropdownTitle.BorderSizePixel = 0
				DropdownTitle.Position = UDim2.new(0, 10, 0, 10)
				DropdownTitle.Size = UDim2.new(1, -180, 0, 13)
				DropdownTitle.Name = "DropdownTitle"
				DropdownTitle.Parent = Dropdown

				DropdownContent.Font = Enum.Font.GothamBold
				DropdownContent.Text = DropdownConfig.Content
				DropdownContent.TextColor3 = Colours.SecondaryTextColor or Colours.TextColor -- Themed
				DropdownContent.TextSize = 12
				DropdownContent.TextTransparency = (Colours.SecondaryTextColor == nil) and 0.6 or 0 -- Apply transparency if using base TextColor
				DropdownContent.TextWrapped = true
				DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
				DropdownContent.TextYAlignment = Enum.TextYAlignment.Bottom
				DropdownContent.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				DropdownContent.BackgroundTransparency = 1
				DropdownContent.BorderColor3 = Colours.Stroke -- Themed
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
				SelectOptionsFrame.BackgroundColor3 = Colours.InputBackground -- Themed
				SelectOptionsFrame.BackgroundTransparency = 0 -- Assuming opaque theme color
				SelectOptionsFrame.BorderColor3 = Colours.InputStroke -- Themed (or just Colours.Stroke)
				SelectOptionsFrame.BorderSizePixel = 0
				SelectOptionsFrame.Position = UDim2.new(1, -7, 0.5, 0)
				SelectOptionsFrame.Size = UDim2.new(0, 148, 0, 30)
				SelectOptionsFrame.Name = "SelectOptionsFrame"
				SelectOptionsFrame.LayoutOrder = CountDropdown
				SelectOptionsFrame.Parent = Dropdown

				UICorner11.CornerRadius = UDim.new(0, 4)
				UICorner11.Parent = SelectOptionsFrame

				local ScrollSelect = Instance.new("ScrollingFrame"); -- Moved up for SearchBar access
				local SearchBar = Instance.new("TextBox") -- Moved up

				DropdownButton.Activated:Connect(function()
					if not MoreBlur.Visible then
						MoreBlur.Visible = true 
						DropPageLayout:JumpToIndex(SelectOptionsFrame.LayoutOrder)
                        SearchBar.Text = "" -- Clear search bar
                        ScrollSelect.CanvasPosition = Vector2.new(0,0) -- Reset scroll
						TweenService:Create(MoreBlur, TweenInfo.new(0.01), {BackgroundTransparency = 0.7}):Play()
						TweenService:Create(DropdownSelect, TweenInfo.new(0.01), {Position = UDim2.new(1, -11, 0.5, 0)}):Play()
					end
				end)

				OptionSelecting.Font = Enum.Font.GothamBold
				OptionSelecting.Text = ""
				OptionSelecting.TextColor3 = Colours.TextColor -- Themed
				OptionSelecting.TextSize = 12
				OptionSelecting.TextTransparency = 0.6 -- Retain original transparency for placeholder
				OptionSelecting.TextWrapped = true
				OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
				OptionSelecting.AnchorPoint = Vector2.new(0, 0.5)
				OptionSelecting.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				OptionSelecting.BackgroundTransparency = 1
				OptionSelecting.BorderColor3 = Colours.Stroke -- Themed
				OptionSelecting.BorderSizePixel = 0
				OptionSelecting.Position = UDim2.new(0, 5, 0.5, 0)
				OptionSelecting.Size = UDim2.new(1, -30, 1, -8)
				OptionSelecting.Name = "OptionSelecting"
				OptionSelecting.Parent = SelectOptionsFrame

				OptionImg.Image = "rbxassetid://16851841101"
				OptionImg.ImageColor3 = Colours.TextColor -- Themed
				OptionImg.AnchorPoint = Vector2.new(1, 0.5)
				OptionImg.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
				OptionImg.BackgroundTransparency = 1
				OptionImg.BorderColor3 = Colours.Stroke -- Themed
				OptionImg.BorderSizePixel = 0
				OptionImg.Position = UDim2.new(1, 0, 0.5, 0)
				OptionImg.Size = UDim2.new(0, 25, 0, 25)
				OptionImg.Name = "OptionImg"
				OptionImg.Parent = SelectOptionsFrame

				-- local ScrollSelect = Instance.new("ScrollingFrame"); -- Already declared above
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

				-- local SearchBar = Instance.new("TextBox") -- Already declared above
				SearchBar.Font = Enum.Font.GothamBold
				SearchBar.PlaceholderText = "Search 🔎" 
				SearchBar.PlaceholderColor3 = Colours.PlaceholderColor -- Themed
				SearchBar.Text = ""
				SearchBar.TextColor3 = Colours.TextColor -- Themed
				SearchBar.TextSize = 12
				SearchBar.BackgroundColor3 = Colours.SecondaryElementBackground -- Themed (was Colours.Secondary old static)
				SearchBar.BackgroundTransparency = 0 -- Assuming opaque theme color
				SearchBar.BorderColor3 = Colours.Stroke -- Themed
				SearchBar.BorderSizePixel = 1
				SearchBar.Size = UDim2.new(1, 0, 0, 20)
                SearchBar.LayoutOrder = -1 
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
					local UICorner37 = Instance.new("UICorner");
					local OptionButton = Instance.new("TextButton");
					local OptionText = Instance.new("TextLabel")
					local ChooseFrame = Instance.new("Frame");
					local UIStroke15 = Instance.new("UIStroke");
					local UICorner38 = Instance.new("UICorner");
					
					Option.BackgroundColor3 = Colours.DropdownUnselected -- Themed
					Option.BackgroundTransparency = 0 -- Assuming opaque theme color
					Option.BorderColor3 = Colours.Stroke -- Themed
					Option.BorderSizePixel = 0
					Option.LayoutOrder = Option.InitialLayoutOrder 
					Option.Size = UDim2.new(1, 0, 0, 30)
					Option.Name = "Option"
					Option.Parent = ScrollSelect
				
					UICorner37.CornerRadius = UDim.new(0, 3)
					UICorner37.Parent = Option
				
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
					OptionButton.Parent = Option

					OptionText.Font = Enum.Font.GothamBold
					OptionText.Text = OptionName
					OptionText.TextSize = 13
					OptionText.TextColor3 = Colours.TextColor -- Themed
					OptionText.TextXAlignment = Enum.TextXAlignment.Left
					OptionText.TextYAlignment = Enum.TextYAlignment.Center 
                    OptionText.Position = UDim2.new(0, 8, 0.5, 0) 
                    OptionText.AnchorPoint = Vector2.new(0, 0.5)
					OptionText.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder, should be transparent
					OptionText.BackgroundTransparency = 1
					OptionText.BorderColor3 = Colours.Stroke -- Themed
					OptionText.BorderSizePixel = 0
					OptionText.Size = UDim2.new(1, -100, 0, 13)
					OptionText.Name = "OptionText"
					OptionText.Parent = Option
	
					ChooseFrame.AnchorPoint = Vector2.new(0, 0.5)
					ChooseFrame.BackgroundColor3 = Colours.ThemeHighlight -- Themed
					ChooseFrame.BorderColor3 = Colours.Stroke -- Themed
					ChooseFrame.BorderSizePixel = 0
					ChooseFrame.Position = UDim2.new(0, 2, 0.5, 0)
					ChooseFrame.Size = UDim2.new(0, 0, 0, 0)
					ChooseFrame.Name = "ChooseFrame"
					ChooseFrame.Parent = Option
				
					UIStroke15.Color = Colours.ThemeHighlight -- Themed (was GuiConfig.Color)
					UIStroke15.Thickness = 1.600000023841858
					UIStroke15.Transparency = 0 -- Assuming opaque from theme
					UIStroke15.Parent = ChooseFrame
				
					UICorner38.Parent = ChooseFrame
                    UICorner38.CornerRadius = UDim.new(0,2) 

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
				function DropdownFunc:Set(Value)
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
							local chooseFrameSize = isSelected and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0)
							local optionBGColor = isSelected and Colours.DropdownSelected or Colours.DropdownUnselected
							local optionStrokeTransparency = isSelected and 0 or 1 -- Assuming opaque stroke for selected

							TweenService:Create(Drop.ChooseFrame, tweenInfoInOut, {Size = chooseFrameSize}):Play()
							TweenService:Create(Drop.ChooseFrame.UIStroke, tweenInfoInOut, {Transparency = optionStrokeTransparency}):Play()
							TweenService:Create(Drop, tweenInfoInOut, {BackgroundColor3 = optionBGColor, BackgroundTransparency = 0}):Play()

                            if DropdownConfig.Multi then 
                                if isSelected then
                                    Drop.LayoutOrder = -10000 + Drop.InitialLayoutOrder 
                                else
                                    Drop.LayoutOrder = Drop.InitialLayoutOrder 
                                end
                            end
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
				end
				function DropdownFunc:Refresh(RefreshList, Selecting)
                    local currentValue
                    if DropdownConfig.Multi then
                        currentValue = (savedValue and type(savedValue) == "table") and savedValue or (type(DropdownConfig.Default) == "table" and DropdownConfig.Default or {})
                    else
                         local defaultSingle = type(savedValue) == "table" and savedValue[1] or savedValue
					    currentValue = defaultSingle or DropdownConfig.Default
                    end

					RefreshList = RefreshList or {}
					Selecting = Selecting or currentValue

                    DropdownFunc:Clear() 
                    DropdownFunc.Value = DropdownConfig.Multi and {} or nil 

					for _, DropName in ipairs(RefreshList) do
						DropdownFunc:AddOption(DropName)
					end
					DropdownFunc.Options = RefreshList
					DropdownFunc:Set(Selecting)
				end
				DropdownFunc:Refresh(DropdownFunc.Options, DropdownFunc.Value)
				CountItem = CountItem + 1
				CountDropdown = CountDropdown + 1
				return DropdownFunc
			end
			CountSection = CountSection + 1
			return Items
		end
		CountTab = CountTab + 1
		tabReturnData.Sections = Sections -- Add the Sections methods to the return data
		return tabReturnData -- Return the table with references
	end

	-- Create "Interface" Tab and its content here, before returning Tabs
	local InterfaceTab = localTabsObject:CreateTab({ Name = "Interface", Icon = "sliders-horizontal" })
	local BGSettingsSection = InterfaceTab.Sections:AddSection("Background Settings")

	BGSettingsSection:AddSlider({
		Title = "UI Transparency",
		Content = "Adjust overall UI transparency.",
		Min = 0, Max = 1, Increment = 0.01,
		Default = Flags.MainBackgroundTransparency or 0.1,
		Flag = "MainUITransparencySlider",
		Callback = function(value)
			ChangeTransparencyInternal(value)
		end
	})

	local CustomBGSection = InterfaceTab.Sections:AddSection("Custom Background")
	-- Sub-section for Downloader
	local DownloaderSubSection = CustomBGSection:AddSection("[+] Background Downloader")
	local selectedMediaType = "Image"
	DownloaderSubSection:AddDropdown({
		Title = "Select Media Type",
		Options = {"Image", "Video"},
		Default = selectedMediaType,
		Callback = function(val) selectedMediaType = val[1] or val end
	})
	local bgUrlInput = DownloaderSubSection:AddInput({ Title = "Background URL", Default = "" })
	local bgFilenameInput = DownloaderSubSection:AddInput({ Title = "Filename (Optional)", Content = "Name to save as. Auto-generates if empty.", Default = "" })
	DownloaderSubSection:AddButton({
		Title = "Load Web Background",
		Icon = "download-cloud",
		Callback = function()
			if bgUrlInput and bgUrlInput.Value ~= "" then
				ChangeAssetInternal(selectedMediaType, bgUrlInput.Value, bgFilenameInput.Value)
			end
		end
	})

	-- Sub-section for Local Files
	local LocalFilesSubSection = CustomBGSection:AddSection("[-] Local Backgrounds")
	local localFilesDropdown = LocalFilesSubSection:AddDropdown({
		Title = "Select Local File",
		Options = {"(Refresh to see files)"},
		Default = "(Refresh to see files)"
	})
	local selectedLocalFile = ""
	-- Assuming dropdown value is a table for multi-select, or string for single.
	-- The provided Dropdown:Set implies it could be a direct value or table.
	-- Let's ensure selectedLocalFile gets the string.
	localFilesDropdown:GetPropertyChangedSignal("Value"):Connect(function()
		if type(localFilesDropdown.Value) == "table" then
			selectedLocalFile = localFilesDropdown.Value[1] or ""
		else
			selectedLocalFile = localFilesDropdown.Value or ""
		end
	end)

	LocalFilesSubSection:AddButton({
		Title = "Refresh Local Files",
		Icon = "refresh-cw",
		Callback = function()
			if FSO.makefolder and FSO.listfiles and FSO.isfile then
				if not FSO.isfile(mediaFolder) then FSO.makefolder(mediaFolder) end
				local files = FSO.listfiles(mediaFolder)
				local imageFiles = {}
				local videoFiles = {}
				for _, fileFullName in ipairs(files) do
					if fileFullName:match("%.png$") or fileFullName:match("%.jpg$") or fileFullName:match("%.jpeg$") or fileFullName:match("%.gif$") then
						table.insert(imageFiles, mediaFolder .. "/" .. fileFullName)
					elseif fileFullName:match("%.mp4$") or fileFullName:match("%.webm$") then
						table.insert(videoFiles, mediaFolder .. "/" .. fileFullName)
					end
				end
				local allFilesToDisplay = {}
				for _,f in ipairs(imageFiles) do table.insert(allFilesToDisplay, f) end
				for _,f in ipairs(videoFiles) do table.insert(allFilesToDisplay, f) end

				if #allFilesToDisplay == 0 then table.insert(allFilesToDisplay, "(No files found)") end

				if localFilesDropdown and localFilesDropdown.Refresh then
					localFilesDropdown:Refresh(allFilesToDisplay, allFilesToDisplay[1] or "(No files found)")
					if type(allFilesToDisplay[1]) == "string" then selectedLocalFile = allFilesToDisplay[1] else selectedLocalFile = "" end
				else
					warn("localFilesDropdown or its Refresh method not found.")
				end
			else
				warn("Refresh Local Files: 'FSO.listfiles', 'FSO.makefolder' or 'FSO.isfile' not available.")
			end
		end
	})
	LocalFilesSubSection:AddButton({
		Title = "Load Selected Local File",
		Icon = "folder-up",
		Callback = function()
			if selectedLocalFile and selectedLocalFile ~= "" and selectedLocalFile ~= "(No files found)" and selectedLocalFile ~= "(Refresh to see files)" then
				if FSO.getcustomasset then
					local mediaTypeForLocal = (selectedLocalFile:match("%.mp4$") or selectedLocalFile:match("%.webm$")) and "Video" or "Image"
					ChangeAssetInternal(mediaTypeForLocal, selectedLocalFile, nil)
				else
					warn("Load Selected Local File: 'FSO.getcustomasset' not available.")
				end
			else
				warn("No valid local file selected.")
			end
		end
	})
	CustomBGSection:AddButton({
		Title = "Reset Background",
		Icon = "rotate-ccw",
		Callback = function() ResetBackgroundInternal() end
	})

	-- Ensure initial transparency is correctly applied after Main is created and applyTheme has run.
	-- applyTheme should handle setting Main.BackgroundTransparency from GuiConfig.MainBackgroundTransparency
	-- which is now populated from Flags or default.
	if Flags.MainBackgroundTransparency ~= nil then
		ChangeTransparencyInternal(Flags.MainBackgroundTransparency) -- Re-apply if not covered by initial theme
	end


	return Tabs
end

-- Main execution part (example of how to use the library and add the Themes tab)
-- This part would typically be in a separate script that loads UBHubLib.
-- For the purpose of this task, it's appended here to make the file self-contained with the Themes tab functionality.
if not _G.UBHubLibLoaded then -- Prevent re-running this block if script is run multiple times in some environments
	_G.UBHubLibLoaded = true

	local MyLib = UBHubLib
	-- Default GuiConfig for the example. Users of the library would pass their own.
	local guiConfigForExample = {
		NameHub = "Universal Hub",
		Description = "V5 QOL",
		Color = Color3.fromRGB(255,0,0), -- Example color
		SaveFolder = "UBHubThemeSettings" -- Example save folder
	}
	local MainTabs = MyLib:MakeGui(guiConfigForExample)

	if MainTabs and MainTabs.CreateTab then
		local ThemesTab = MainTabs:CreateTab({ Name = "Themes", Icon = "palette" })

		local PresetsSection = ThemesTab.Sections:AddSection("Theme Presets")
		local DefaultThemes = MyLib.GetDefaultThemes()

		if DefaultThemes then
			for themeName, _ in pairs(DefaultThemes) do
				PresetsSection:AddButton({
					Title = themeName,
					Content = "Apply this theme preset.",
					Icon = "brush",
					Callback = function()
						MyLib.ApplyTheme(themeName, false)
					end
				})
			end
		end

		local CustomizeSection = ThemesTab.Sections:AddSection("Customize Colors")
		local orderedColorKeys = {
			"TextColor", "Background", "Topbar", "Shadow", "NotificationBackground", "NotificationActionsBackground",
			"TabBackground", "TabStroke", "TabBackgroundSelected", "TabTextColor", "SelectedTabTextColor",
			"ElementBackground", "ElementBackgroundHover", "SecondaryElementBackground", "ElementStroke", "SecondaryElementStroke",
			"SliderBackground", "SliderProgress", "SliderStroke", "ToggleBackground", "ToggleEnabled", "ToggleDisabled",
			"ToggleEnabledStroke", "ToggleDisabledStroke", "ToggleEnabledOuterStroke", "ToggleDisabledOuterStroke",
			"DropdownSelected", "DropdownUnselected", "InputBackground", "InputStroke", "PlaceholderColor",
			"Primary", "Secondary", "Accent", "ThemeHighlight", "Stroke", "GuiConfigColor"
		}

		local CurrentColours = MyLib.GetCurrentColours()

		if CurrentColours and MyLib.AllCreatedItemControls and MyLib.AllCreatedItemControls.Sliders then
			for _, colorKey in ipairs(orderedColorKeys) do
				if CurrentColours[colorKey] and type(CurrentColours[colorKey]) == "Color3" then
					local titlePrefix = colorKey
					MyLib.AllCreatedItemControls.Sliders[colorKey] = {} -- Ensure sub-table exists

					MyLib.AllCreatedItemControls.Sliders[colorKey].R = CustomizeSection:AddSlider({
						Title = titlePrefix .. " - Red", Content = "Red component for " .. titlePrefix,
						Min = 0, Max = 255, Increment = 1, Default = math.floor(CurrentColours[colorKey].R * 255 + 0.5),
						Flag = "CustomColor_" .. colorKey .. "_R",
						Callback = function(value)
							local modColours = MyLib.GetCurrentColours()
							modColours[colorKey] = Color3.fromRGB(value, math.floor(modColours[colorKey].G * 255 + 0.5), math.floor(modColours[colorKey].B * 255 + 0.5))
							MyLib.ApplyTheme(modColours, false)
						end
					})
					MyLib.AllCreatedItemControls.Sliders[colorKey].G = CustomizeSection:AddSlider({
						Title = titlePrefix .. " - Green", Content = "Green component for " .. titlePrefix,
						Min = 0, Max = 255, Increment = 1, Default = math.floor(CurrentColours[colorKey].G * 255 + 0.5),
						Flag = "CustomColor_" .. colorKey .. "_G",
						Callback = function(value)
							local modColours = MyLib.GetCurrentColours()
							modColours[colorKey] = Color3.fromRGB(math.floor(modColours[colorKey].R * 255 + 0.5), value, math.floor(modColours[colorKey].B * 255 + 0.5))
							MyLib.ApplyTheme(modColours, false)
						end
					})
					MyLib.AllCreatedItemControls.Sliders[colorKey].B = CustomizeSection:AddSlider({
						Title = titlePrefix .. " - Blue", Content = "Blue component for " .. titlePrefix,
						Min = 0, Max = 255, Increment = 1, Default = math.floor(CurrentColours[colorKey].B * 255 + 0.5),
						Flag = "CustomColor_" .. colorKey .. "_B",
						Callback = function(value)
							local modColours = MyLib.GetCurrentColours()
							modColours[colorKey] = Color3.fromRGB(math.floor(modColours[colorKey].R * 255 + 0.5), math.floor(modColours[colorKey].G * 255 + 0.5), value)
							MyLib.ApplyTheme(modColours, false)
						end
					})
				else
					warn("Customize Colors: Skipping sliders for key '" .. colorKey .. "' as it's not in CurrentColours or not a Color3.")
				end
			end
		else
			warn("ThemesTab: Could not populate Customize Colors section. CurrentColours or AllCreatedItemControls not available.")
		end
	else
		warn("UBHubLib:MakeGui did not return a valid Tabs object. Cannot create Themes tab.")
	end
end

return UBHubLib
