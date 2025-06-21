local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()

-- Lucide Icon Library Loading & GetIcon Helper
local LucideLib = nil
local HttpServiceForLucide = game:GetService("HttpService") -- Use a distinct name

if HttpServiceForLucide and type(game.HttpGet) == "function" then
    local HttpGetSuccess, LucideScript = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/zryr/Libraries/refs/heads/Jules/Lucide-Source.lua")
    if HttpGetSuccess and type(LucideScript) == "string" and LucideScript ~= "" then
        local LoadSuccess, LoadedFunc = pcall(loadstring(LucideScript))
        if LoadSuccess and type(LoadedFunc) == "function" then
            local ExecSuccess, ReturnedMod = pcall(LoadedFunc)
            if ExecSuccess and type(ReturnedMod) == "table" and type(ReturnedMod.GetIcon) == "function" then
                LucideLib = ReturnedMod
                print("UB Hub: Lucide icon library loaded successfully.")
            else
                warn("UB Hub: Lucide script execution failed or returned invalid module. Error:", ReturnedMod)
            end
        else
            warn("UB Hub: Failed to loadstring Lucide script. Error:", LoadedFunc)
        end
    else
        warn("UB Hub: Failed to HttpGet Lucide script. Success:", HttpGetSuccess, "Script:", LucideScript)
    end
else
    warn("UB Hub: HttpService or game:HttpGet is not available. Lucide icons will not be loaded.")
end

local function GetIcon(iconName)
    if not iconName or type(iconName) ~= "string" or iconName == "" then
        return ""
    end

    if string.sub(iconName, 1, 7):lower() == "lucide:" then
        if LucideLib and type(LucideLib.GetIcon) == "function" then
            local actualName = string.sub(iconName, 8)
            if actualName == "" then return "" end -- Handle "lucide:" with no name
            local assetId = LucideLib:GetIcon(actualName)
            return assetId or "" -- Return assetId or empty string if Lucide:GetIcon fails
        else
            -- Lucide prefix used, but library not loaded or GetIcon method missing
            return ""
        end
    end
    -- Not a "lucide:" string, assume it's a direct asset ID or other.
    return iconName
end

local OldStaticColours = Colours
if type(OldStaticColours) ~= "table" then OldStaticColours = nil end

local Colours = {}

local ProtectGui = protectgui or (syn and syn.protect_gui) or function(f) end
local CoreGui = game:GetService("CoreGui")
local SizeUI = UDim2.fromOffset(550, 330)

local function MakeDraggable(topbarobject, object)
    local tbObject = topbarobject
    local obj = object
    local Dragging = false
    local DragInputObject = nil
    local DragStart = nil
    local StartPosition = nil

    tbObject.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not Dragging then
            Dragging = true
            DragInputObject = input
            DragStart = input.Position
            StartPosition = obj.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and DragInputObject and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and input == DragInputObject) then
                local Delta = input.Position - DragStart
                local newPos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
                obj.Position = newPos
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if Dragging and input == DragInputObject then
            Dragging = false
            DragInputObject = nil
        end
    end)
end

function CircleClick(Button, X, Y)
	task.spawn(function()
		Button.ClipsDescendants = true
		local Circle = Instance.new("ImageLabel")
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Colours.ThemeHighlight or Color3.fromRGB(255,80,0)
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
	NotifyConfig.Color = NotifyConfig.Color or (Colours.Primary or Color3.fromRGB(160,40,0))
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
			NotifyLayout.BackgroundColor3 = Colours.NotificationBackground or Color3.fromRGB(35,35,35)
			NotifyLayout.BackgroundTransparency = 0
			NotifyLayout.BorderColor3 = Colours.Stroke or Color3.fromRGB(80,20,0)
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
		local CloseButton = Instance.new("TextButton");
		local NotifyCloseIconImage = Instance.new("ImageLabel");
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

		NotifyFrameReal.BackgroundColor3 = Colours.NotificationBackground or Color3.fromRGB(35,35,35)
		NotifyFrameReal.BorderColor3 = Colours.Stroke or Color3.fromRGB(80,20,0)
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
		DropShado.ImageColor3 = Colours.Shadow or Color3.fromRGB(10,10,10)
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

		Top.BackgroundColor3 = Colours.NotificationActionsBackground or Color3.fromRGB(40,40,40)
		Top.BackgroundTransparency = 0
		Top.BorderColor3 = Colours.Stroke or Color3.fromRGB(80,20,0)
		Top.BorderSizePixel = 0
		Top.Size = UDim2.new(1, 0, 0, 36)
		Top.Name = "Top"
		Top.Parent = NotifyFrameReal

		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = NotifyConfig.Title
		TextLabel.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
		TextLabel.TextSize = 14
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 1
		TextLabel.BorderColor3 = Colours.Stroke or Color3.fromRGB(80,20,0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.Parent = Top
		TextLabel.Position = UDim2.new(0, 10, 0, 0)

		UIStroke.Color = Colours.Stroke or Color3.fromRGB(80,20,0)
		UIStroke.Thickness = 0.30000001192092896
		UIStroke.Parent = TextLabel

		UICorner1_Notify.Parent = Top
		UICorner1_Notify.CornerRadius = UDim.new(0, 5)

		TextLabel1.Font = Enum.Font.GothamBold
		TextLabel1.Text = NotifyConfig.Description
		TextLabel1.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
		TextLabel1.TextSize = 14
		TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel1.BackgroundColor3 = Colours.ThemeHighlight or Color3.fromRGB(255,80,0)
		TextLabel1.BackgroundTransparency = 1
		TextLabel1.BorderColor3 = Colours.Stroke or Color3.fromRGB(80,20,0)
		TextLabel1.BorderSizePixel = 0
		TextLabel1.Size = UDim2.new(1, 0, 1, 0)
		TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
		TextLabel1.Parent = Top

		UIStroke1_Notify.Color = Colours.Accent or Color3.fromRGB(0,150,255)
		UIStroke1_Notify.Thickness = 0.4000000059604645
		UIStroke1_Notify.Parent = TextLabel1

		CloseButton.Font = Enum.Font.SourceSans
		CloseButton.Text = ""
		CloseButton.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
		CloseButton.TextSize = 14
		CloseButton.AnchorPoint = Vector2.new(1, 0.5)
		CloseButton.BackgroundColor3 = Colours.NotificationActionsBackground or Color3.fromRGB(40,40,40)
		CloseButton.BackgroundTransparency = 1
		CloseButton.BorderColor3 = Colours.Stroke or Color3.fromRGB(80,20,0)
		CloseButton.BorderSizePixel = 0
		CloseButton.Position = UDim2.new(1, -5, 0.5, 0)
		CloseButton.Size = UDim2.new(0, 25, 0, 25)
		CloseButton.Name = "CloseButton"
		CloseButton.Parent = Top

		NotifyCloseIconImage.Name = "NotifyCloseIconImage"
		local notifyCloseIcon = GetIcon("lucide:x")
		NotifyCloseIconImage.Image = (notifyCloseIcon ~= "") and notifyCloseIcon or "rbxassetid://9886659671" -- Fallback
		NotifyCloseIconImage.ImageColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
		NotifyCloseIconImage.AnchorPoint = Vector2.new(0.5, 0.5)
		NotifyCloseIconImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyCloseIconImage.BackgroundTransparency = 1
		NotifyCloseIconImage.BorderColor3 = Colours.Stroke or Color3.fromRGB(80,20,0)
		NotifyCloseIconImage.BorderSizePixel = 0
		NotifyCloseIconImage.Position = UDim2.new(0.5, 0, 0.5, 0)
		NotifyCloseIconImage.Size = UDim2.new(0.7, 0, 0.7, 0)
		NotifyCloseIconImage.Parent = CloseButton

		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.Text = NotifyConfig.Content
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.TextColor3 = Colours.TextColor or Color3.fromRGB(150,150,150)
		TextLabel2.BorderColor3 = Colours.Stroke or Color3.fromRGB(80,20,0)
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
		CloseButton.Activated:Connect(function()
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

-- [[ THIS IS THE START OF THE FULL MAKEGUI FUNCTION ]]
function UBHubLib:MakeGui(GuiConfig)
	local GuiConfig = GuiConfig or {}
	GuiConfig.NameHub = GuiConfig.NameHub or "UB Hub"
	GuiConfig.Description = GuiConfig.Description or nil
	GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(255, 0, 255)
	GuiConfig["Logo Player"] = GuiConfig["Logo Player"] or "https://www.roblox.com/headshot-thumbnail/image?userId="..game:GetService("Players").LocalPlayer.UserId .."&width=420&height=420&format=png"
	GuiConfig["Name Player"] = GuiConfig["Name Player"] or tostring(game:GetService("Players").LocalPlayer.Name)
	GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 120
	GuiConfig["SaveFolder"] = GuiConfig["SaveFolder"] or false

	local CurrentHttpService = game:GetService("HttpService")
	if CurrentHttpService and not (type(CurrentHttpService.JSONEncode) == "function" and type(CurrentHttpService.JSONDecode) == "function" and type(CurrentHttpService.GenerateGUID) == "function") then
		warn("UB Hub: HttpService is available, but required methods (JSONEncode, JSONDecode, GenerateGUID) are not. Save/Load and Web Backgrounds will be affected.")
		CurrentHttpService = nil
	elseif not CurrentHttpService then
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
	for funcName, funcRef in pairs(FSO) do
		if type(funcRef) ~= "function" then
			warn("UB Hub: File system function '" .. funcName .. "' is not available. Related functionality (Save/Load, Local Backgrounds) will be affected.")
			FSO[funcName] = nil
		end
	end

	UBHubLib.Flags = UBHubLib.Flags or {}
	local Flags = UBHubLib.Flags

	local function SaveFile(Name, Value)
		if not (FSO.writefile and GuiConfig and GuiConfig.SaveFolder and CurrentHttpService) then
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
			local encoded = CurrentHttpService:JSONEncode(UBHubLib.Flags)
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
		if not (FSO.readfile and FSO.isfile and FSO.isfile(savePath) and CurrentHttpService) then
			if GuiConfig and GuiConfig.SaveFolder then
                local missing = {}
                if not FSO.readfile then table.insert(missing, "'FSO.readfile'") end
                if not FSO.isfile then table.insert(missing, "'FSO.isfile'") end
                if not CurrentHttpService then table.insert(missing, "'HttpService'") end
                warn("LoadFile: Cannot proceed. Missing: " .. table.concat(missing, ", ") .. ". Or save file does not exist.")
			end
			return false
		end
		local success, fileContent = pcall(FSO.readfile, savePath)
		if not success or not fileContent then
			warn("LoadFile: Failed to read file from path: " .. savePath .. (fileContent and (": " .. fileContent) or ""))
			return false
		end

		local decodeSuccess, config = pcall(CurrentHttpService.JSONDecode, CurrentHttpService, fileContent)
		if decodeSuccess and type(config) == "table" then
			UBHubLib.Flags = config
			return true
		end
		return false
	end; LoadFile()

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
			GuiConfigColor = Color3.fromRGB(0, 122, 204)
		},
		["Default Dark Original"] = {
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
			GuiConfigColor = tempOriginalColours.Primary
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
			GuiConfigColor = Color3.fromRGB(0,122,204)
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
			GuiConfigColor = Color3.fromRGB(0,150,255)
		}
	}

	local CurrentThemeName
	local AllCreatedItemControls = { Sliders = {} }

	local UBHubGui, DropShadowHolder, DropShadow, Main, MainUICorner, MainUIStroke, TopBar, HubTitleTextLabel, HubDescriptionTextLabel, HubDescriptionStroke
	local CloseButton, CloseIcon, MinimizeButton, MinimizeIcon, LayersTabFrame, LayersTabUICorner, DecideFrameLine, LayersFrame, LayersUICorner, ActiveTabNameLabel
	local LayersRealFrame, LayersFolderInstance, LayersPageLayoutInstance, TabScroll, TabScrollUIListLayout, InfoFrame, InfoFrameUICorner, LogoPlayerFrame
	local LogoPlayerFrameUICorner, LogoPlayerImage, LogoPlayerImageUICorner, NamePlayerTextLabel
	local MinimizedIconImageButton
	local MoreBlurFrame, MoreBlurDropShadowHolder, MoreBlurDropShadow, MoreBlurUICorner, MoreBlurConnectButton
	local DropdownSelectFrame, DropdownSelectUICorner, DropdownSelectUIStroke, DropdownSelectRealFrame, DropdownFolderInstance, DropPageLayoutInstance
	local BackgroundImageLabel, BackgroundVideoFrame

	local isApplyingTheme = false
	local function applyTheme(themeIdentifier, isInitialLoad)
		if isApplyingTheme then return end
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
		for k, v in pairs(themeToApply) do Colours[k] = v end
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
		if GuiConfig and Colours.GuiConfigColor then GuiConfig.Color = Colours.GuiConfigColor end

		if Main and Colours.Background then Main.BackgroundColor3 = Colours.Background end
		if Main and Colours.Stroke then Main.BorderColor3 = Colours.Stroke end
		if TopBar and Colours.Topbar then TopBar.BackgroundColor3 = Colours.Topbar end
		if TopBar and Colours.Stroke then TopBar.BorderColor3 = Colours.Stroke end
		if InfoFrame and Colours.TabBackground then InfoFrame.BackgroundColor3 = Colours.TabBackground end
		if InfoFrame and Colours.Stroke then InfoFrame.BorderColor3 = Colours.Stroke end
		if LayersTabFrame and Colours.TabBackground then LayersTabFrame.BackgroundColor3 = Colours.TabBackground end
		if LayersTabFrame and Colours.Stroke then LayersTabFrame.BorderColor3 = Colours.Stroke end
		if DecideFrameLine and Colours.Stroke then DecideFrameLine.BackgroundColor3 = Colours.Stroke end
		if ActiveTabNameLabel and Colours.SelectedTabTextColor then ActiveTabNameLabel.TextColor3 = Colours.SelectedTabTextColor end
		if HubTitleTextLabel and Colours.Accent then HubTitleTextLabel.TextColor3 = Colours.Accent end
		if HubDescriptionTextLabel and Colours.TextColor then HubDescriptionTextLabel.TextColor3 = Colours.TextColor end
		if DropShadow and Colours.Shadow then DropShadow.ImageColor3 = Colours.Shadow end
		if MainUIStroke and Colours.Stroke then MainUIStroke.Color = Colours.Stroke end

		local themesButtonInInfo = InfoFrame and InfoFrame:FindFirstChild("ThemesButton")
		if themesButtonInInfo then
			if Colours.TextColor then themesButtonInInfo.TextColor3 = Colours.TextColor end
			if Colours.ElementBackground then themesButtonInInfo.BackgroundColor3 = Colours.ElementBackground end
		end

		if MinimizedIconImageButton then
			local highlightColor = (Colours and Colours.ThemeHighlight) or Color3.fromRGB(255, 80, 0)
			MinimizedIconImageButton.BackgroundColor3 = highlightColor
			MinimizedIconImageButton.BorderColor3 = highlightColor
		end

		if MoreBlurFrame then
			if Colours.Background then MoreBlurFrame.BackgroundColor3 = Colours.Background end
			if Colours.Stroke then MoreBlurFrame.BorderColor3 = Colours.Stroke end
			local dsHolder = MoreBlurFrame:FindFirstChild("DropShadowHolder")
			if dsHolder then
				local ds = dsHolder:FindFirstChild("DropShadow")
				if ds and Colours.Shadow then ds.ImageColor3 = Colours.Shadow end
			end
		end

		if DropdownSelectFrame then
			if Colours.DropdownUnselected then DropdownSelectFrame.BackgroundColor3 = Colours.DropdownUnselected end
			if Colours.Stroke then DropdownSelectFrame.BorderColor3 = Colours.Stroke end
			local strokeForDropdownSelect = DropdownSelectFrame:FindFirstChildOfClass("UIStroke")
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
            if GuiConfig and GuiConfig.SaveFolder and FSO.writefile and CurrentHttpService then
                 local successSave, errSave = pcall(function()
                     local path = GuiConfig.SaveFolder
                     local encoded = CurrentHttpService:JSONEncode(UBHubLib.Flags)
                     FSO.writefile(path, encoded)
                 end)
                 if not successSave then
                     warn("Save (triggered by applyTheme) failed:", errSave)
                 end
            else
                if GuiConfig and GuiConfig.SaveFolder then
                    local missingFuncs = {}
                    if not FSO.writefile then table.insert(missingFuncs, "'FSO.writefile'") end
                    if not CurrentHttpService then table.insert(missingFuncs, "'HttpService'") end
                    if #missingFuncs > 0 then
                        warn("Saving is enabled in applyTheme, but required functions are missing: " .. table.concat(missingFuncs, ", "))
                    end
                end
            end
		end
		isApplyingTheme = false
	end

	CurrentThemeName = Flags.SelectedTheme or "Rayfield Like"

	UBHubGui = Instance.new("ScreenGui")
	DropShadowHolder = Instance.new("Frame")
	DropShadow = Instance.new("ImageLabel")
	Main = Instance.new("Frame")
	MainUICorner = Instance.new("UICorner")
	MainUIStroke = Instance.new("UIStroke")
	TopBar = Instance.new("Frame")
	HubTitleTextLabel = Instance.new("TextLabel")
	UICorner1 = Instance.new("UICorner")
	HubDescriptionTextLabel = Instance.new("TextLabel")
	HubDescriptionStroke = Instance.new("UIStroke")
	CloseButton = Instance.new("TextButton")
	CloseIcon = Instance.new("ImageLabel")
	MinimizeButton = Instance.new("TextButton")
	MinimizeIcon = Instance.new("ImageLabel")
	LayersTabFrame = Instance.new("Frame")
	LayersTabUICorner = Instance.new("UICorner")
	DecideFrameLine = Instance.new("Frame")
	LayersFrame = Instance.new("Frame")
	LayersUICorner = Instance.new("UICorner")
	ActiveTabNameLabel = Instance.new("TextLabel")
	LayersRealFrame = Instance.new("Frame")
	LayersFolderInstance = Instance.new("Folder")
	LayersPageLayoutInstance = Instance.new("UIPageLayout")
	TabScroll = Instance.new("ScrollingFrame")
	TabScrollUIListLayout = Instance.new("UIListLayout")
	InfoFrame = Instance.new("Frame")
	InfoFrameUICorner = Instance.new("UICorner")
	LogoPlayerFrame = Instance.new("Frame")
	LogoPlayerFrameUICorner = Instance.new("UICorner")
	LogoPlayerImage = Instance.new("ImageLabel")
	LogoPlayerImageUICorner = Instance.new("UICorner")
	NamePlayerTextLabel = Instance.new("TextLabel")
	MinimizedIconImageButton = Instance.new("ImageButton")
	MoreBlurFrame = Instance.new("Frame")
	DropdownSelectFrame = Instance.new("Frame")
	BackgroundImageLabel = Instance.new("ImageLabel")
	BackgroundVideoFrame = Instance.new("VideoFrame")

	applyTheme(CurrentThemeName, true)
	applyTheme(CurrentThemeName, false)

	UBHubLib.ApplyTheme = applyTheme
	UBHubLib.GetDefaultThemes = function() return DefaultThemes end
	UBHubLib.GetCurrentColours = function() return Colours end
	UBHubLib.AllCreatedItemControls = AllCreatedItemControls

	--[[ INSERTION POINT FOR MAIN UI ELEMENT PROPERTY SETTINGS AND TAB DEFINITIONS ]]
	-- (The two redundant Instance.new lines below will be removed by this large insertion)
	-- local UBHubGui = Instance.new("ScreenGui");
	-- local DropShadowHolder = Instance.new("Frame");

	-- Start of UI Properties and Structure (Chunk 4)
	UBHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	UBHubGui.Name = "UBHubGui"
	UBHubGui.Parent = CoreGui

	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.BackgroundColor3 = Color3.new(0,0,0) -- Will be themed by applyTheme if needed
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.ZIndex = 0
	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = UBHubGui
	DropShadowHolder.Size = SizeUI
    DropShadowHolder.Position = UDim2.new(0.5, -SizeUI.X.Offset/2, 0.5, -SizeUI.Y.Offset/2) -- Centered

	DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Colours.Shadow or Color3.fromRGB(10,10,10)
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
	Main.BackgroundColor3 = Colours.Background or Color3.fromRGB(20,8,0)
	Main.BackgroundTransparency = GuiConfig.MainBackgroundTransparency or 0.1 -- Loaded from flags or default
	Main.BorderColor3 = Colours.Stroke or Color3.fromRGB(80,20,0)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = SizeUI
	Main.Name = "Main"
	Main.Parent = DropShadow

	MainUICorner.Parent = Main
    MainUICorner.CornerRadius = UDim.new(0, 8)

	MainUIStroke.Color = Colours.Stroke or Color3.fromRGB(50,50,50)
	MainUIStroke.Thickness = 1.6
	MainUIStroke.Parent = Main

	BackgroundImageLabel.Name = "MainImage"
	BackgroundImageLabel.Size = UDim2.new(1,0,1,0)
	BackgroundImageLabel.BackgroundTransparency = 1
	BackgroundImageLabel.ImageTransparency = GuiConfig.MainBackgroundTransparency or 0.1
	BackgroundImageLabel.Parent = Main

	BackgroundVideoFrame.Name = "MainVideo"
	BackgroundVideoFrame.Size = UDim2.new(1,0,1,0)
	BackgroundVideoFrame.BackgroundTransparency = GuiConfig.MainBackgroundTransparency or 0.1
	BackgroundVideoFrame.Looped = true
    BackgroundVideoFrame.Playing = false
	BackgroundVideoFrame.Parent = Main
    -- _G.BGImage and _G.BGVideo will be set by ChangeAssetInternal

	TopBar.BackgroundColor3 = Colours.Topbar or Color3.fromRGB(25,25,25)
	TopBar.BackgroundTransparency = 0
	TopBar.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	TopBar.BorderSizePixel = 0
	TopBar.Size = UDim2.new(1, 0, 0, 38)
	TopBar.Name = "TopBar"
	TopBar.Parent = Main

	HubTitleTextLabel.Font = Enum.Font.GothamBold
	HubTitleTextLabel.Text = GuiConfig.NameHub
	HubTitleTextLabel.TextColor3 = Colours.Accent or Color3.fromRGB(0,150,255)
	HubTitleTextLabel.TextSize = 14
	HubTitleTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	HubTitleTextLabel.BackgroundTransparency = 1
	HubTitleTextLabel.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	HubTitleTextLabel.BorderSizePixel = 0
	HubTitleTextLabel.Size = UDim2.new(1, -100, 1, 0)
	HubTitleTextLabel.Position = UDim2.new(0, 10, 0, 0)
	HubTitleTextLabel.Parent = TopBar

	UICorner1.Parent = TopBar
    UICorner1.CornerRadius = UDim.new(0,5) 

	HubDescriptionTextLabel.Font = Enum.Font.GothamBold
	HubDescriptionTextLabel.Text = GuiConfig.Description or ""
	HubDescriptionTextLabel.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
	HubDescriptionTextLabel.TextSize = 14
	HubDescriptionTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	HubDescriptionTextLabel.BackgroundTransparency = 1
	HubDescriptionTextLabel.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	HubDescriptionTextLabel.BorderSizePixel = 0
	HubDescriptionTextLabel.Size = UDim2.new(1, -(HubTitleTextLabel.TextBounds.X + 104), 1, 0)
	HubDescriptionTextLabel.Position = UDim2.new(0, HubTitleTextLabel.TextBounds.X + 15, 0, 0)
	HubDescriptionTextLabel.Parent = TopBar

	HubDescriptionStroke.Color = Colours.Accent or Color3.fromRGB(0,150,255)
	HubDescriptionStroke.Thickness = 0.4
	HubDescriptionStroke.Parent = HubDescriptionTextLabel

	CloseButton.Font = Enum.Font.SourceSans
	CloseButton.Text = ""
	CloseButton.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
	CloseButton.TextSize = 14
	CloseButton.AnchorPoint = Vector2.new(1, 0.5)
	CloseButton.BackgroundColor3 = Colours.Topbar or Color3.fromRGB(25,25,25)
	CloseButton.BackgroundTransparency = 1
	CloseButton.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	CloseButton.BorderSizePixel = 0
	CloseButton.Position = UDim2.new(1, -8, 0.5, 0)
	CloseButton.Size = UDim2.new(0, 25, 0, 25)
	CloseButton.Name = "CloseButton"
	CloseButton.Parent = TopBar

	CloseIcon.Image = "rbxassetid://9886659671"
	CloseIcon.ImageColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
	CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseIcon.BackgroundTransparency = 1
	CloseIcon.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	CloseIcon.BorderSizePixel = 0
	CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseIcon.Size = UDim2.new(1, -8, 1, -8)
	CloseIcon.Parent = CloseButton

	MinimizeButton.Font = Enum.Font.SourceSans
	MinimizeButton.Text = ""
	MinimizeButton.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
	MinimizeButton.TextSize = 14
	MinimizeButton.AnchorPoint = Vector2.new(1, 0.5)
	MinimizeButton.BackgroundColor3 = Colours.Topbar or Color3.fromRGB(25,25,25)
	MinimizeButton.BackgroundTransparency = 1
	MinimizeButton.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	MinimizeButton.BorderSizePixel = 0
	MinimizeButton.Position = UDim2.new(1, -38, 0.5, 0)
	MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.Parent = TopBar

	MinimizeIcon.Image = "rbxassetid://9886659276"
	MinimizeIcon.ImageColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
	MinimizeIcon.ImageTransparency = 0.2
	MinimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	MinimizeIcon.BackgroundTransparency = 1
	MinimizeIcon.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	MinimizeIcon.BorderSizePixel = 0
	MinimizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	MinimizeIcon.Size = UDim2.new(1, -9, 1, -9)
	MinimizeIcon.Parent = MinimizeButton

	LayersTabFrame.BackgroundColor3 = Colours.TabBackground or Color3.fromRGB(30,30,30)
	LayersTabFrame.BackgroundTransparency = 0
	LayersTabFrame.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	LayersTabFrame.BorderSizePixel = 0
	LayersTabFrame.Position = UDim2.new(0, 9, 0, 50)
	LayersTabFrame.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -59)
	LayersTabFrame.Name = "LayersTabFrame"
	LayersTabFrame.Parent = Main

	LayersTabUICorner.CornerRadius = UDim.new(0, 2)
	LayersTabUICorner.Parent = LayersTabFrame

	DecideFrameLine.AnchorPoint = Vector2.new(0.5, 0)
	DecideFrameLine.BackgroundColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	DecideFrameLine.BackgroundTransparency = 0
	DecideFrameLine.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	DecideFrameLine.BorderSizePixel = 0
	DecideFrameLine.Position = UDim2.new(0.5, 0, 0, 38)
	DecideFrameLine.Size = UDim2.new(1, 0, 0, 1)
	DecideFrameLine.Name = "DecideFrameLine"
	DecideFrameLine.Parent = Main

	LayersFrame.BackgroundTransparency = 1
	LayersFrame.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	LayersFrame.BorderSizePixel = 0
	LayersFrame.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 50)
	LayersFrame.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -59)
	LayersFrame.Name = "LayersFrame"
	LayersFrame.Parent = Main

	LayersUICorner.CornerRadius = UDim.new(0, 2)
	LayersUICorner.Parent = LayersFrame

	ActiveTabNameLabel.Font = Enum.Font.GothamBold
	ActiveTabNameLabel.Text = ""
	ActiveTabNameLabel.TextColor3 = Colours.SelectedTabTextColor or Color3.fromRGB(221,221,221)
	ActiveTabNameLabel.TextSize = 24
	ActiveTabNameLabel.TextWrapped = true
	ActiveTabNameLabel.TextXAlignment = Enum.TextXAlignment.Left
	ActiveTabNameLabel.BackgroundTransparency = 1
	ActiveTabNameLabel.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	ActiveTabNameLabel.BorderSizePixel = 0
	ActiveTabNameLabel.Size = UDim2.new(1, 0, 0, 30)
	ActiveTabNameLabel.Name = "ActiveTabNameLabel"
	ActiveTabNameLabel.Parent = LayersFrame

	LayersRealFrame.AnchorPoint = Vector2.new(0, 1)
	LayersRealFrame.BackgroundTransparency = 1
	LayersRealFrame.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	LayersRealFrame.BorderSizePixel = 0
	LayersRealFrame.ClipsDescendants = true
	LayersRealFrame.Position = UDim2.new(0, 0, 1, 0)
	LayersRealFrame.Size = UDim2.new(1, 0, 1, -33)
	LayersRealFrame.Name = "LayersRealFrame"
	LayersRealFrame.Parent = LayersFrame

	LayersFolderInstance.Name = "LayersFolder"
	LayersFolderInstance.Parent = LayersRealFrame

	LayersPageLayoutInstance.SortOrder = Enum.SortOrder.LayoutOrder
	LayersPageLayoutInstance.Name = "LayersPageLayout"
	LayersPageLayoutInstance.Parent = LayersFolderInstance
	LayersPageLayoutInstance.TweenTime = 0.5
	LayersPageLayoutInstance.EasingDirection = Enum.EasingDirection.InOut
	LayersPageLayoutInstance.EasingStyle = Enum.EasingStyle.Quad

	TabScroll.ScrollBarImageColor3 = Colours.SecondaryElementBackground or Color3.fromRGB(40,40,40)
	TabScroll.ScrollBarThickness = 0
	TabScroll.Active = true
	TabScroll.BackgroundTransparency = 1
	TabScroll.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	TabScroll.BorderSizePixel = 0
	TabScroll.Size = UDim2.new(1, 0, 1, -50)
	TabScroll.Name = "TabScroll"
	TabScroll.Parent = LayersTabFrame

	TabScrollUIListLayout.Padding = UDim.new(0, 3)
	TabScrollUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabScrollUIListLayout.Parent = TabScroll

	local function UpdateSize1()
		local OffsetY = 0
		for _, child in ipairs(TabScroll:GetChildren()) do
			if child:IsA("GuiObject") and child ~= TabScrollUIListLayout then
				OffsetY = OffsetY + 3 + child.Size.Y.Offset
			end
		end
		TabScroll.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
	end
	TabScroll.ChildAdded:Connect(UpdateSize1)
	TabScroll.ChildRemoved:Connect(UpdateSize1)

	InfoFrame.AnchorPoint = Vector2.new(1, 1)
	InfoFrame.BackgroundColor3 = Colours.TabBackground or Color3.fromRGB(30,30,30)
	InfoFrame.BackgroundTransparency = 0
	InfoFrame.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	InfoFrame.BorderSizePixel = 0
	InfoFrame.Position = UDim2.new(1, 0, 1, 0)
	InfoFrame.Size = UDim2.new(1, 0, 0, 40)
	InfoFrame.Name = "InfoFrame"
	InfoFrame.Parent = LayersTabFrame

	InfoFrameUICorner.CornerRadius = UDim.new(0, 5)
	InfoFrameUICorner.Parent = InfoFrame

	LogoPlayerFrame.AnchorPoint = Vector2.new(0, 0.5)
	LogoPlayerFrame.BackgroundColor3 = Colours.ElementBackground or Color3.fromRGB(45,45,45)
	LogoPlayerFrame.BackgroundTransparency = 0
	LogoPlayerFrame.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	LogoPlayerFrame.BorderSizePixel = 0
	LogoPlayerFrame.Position = UDim2.new(0, 5, 0.5, 0)
	LogoPlayerFrame.Size = UDim2.new(0, 30, 0, 30)
	LogoPlayerFrame.Name = "LogoPlayerFrame"
	LogoPlayerFrame.Parent = InfoFrame

	LogoPlayerFrameUICorner.CornerRadius = UDim.new(0, 1000)
	LogoPlayerFrameUICorner.Parent = LogoPlayerFrame

	LogoPlayerImage.Image = GuiConfig["Logo Player"]
	LogoPlayerImage.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoPlayerImage.BackgroundTransparency = 1
	LogoPlayerImage.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	LogoPlayerImage.BorderSizePixel = 0
	LogoPlayerImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogoPlayerImage.Size = UDim2.new(1, -5, 1, -5)
	LogoPlayerImage.Name = "LogoPlayerImage"
	LogoPlayerImage.Parent = LogoPlayerFrame

	LogoPlayerImageUICorner.CornerRadius = UDim.new(0, 1000)
	LogoPlayerImageUICorner.Parent = LogoPlayerImage

	-- NamePlayerTextLabel is created but not parented, as per previous logic
	NamePlayerTextLabel.Font = Enum.Font.GothamBold
	NamePlayerTextLabel.Text = GuiConfig["Name Player"]
	NamePlayerTextLabel.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
	NamePlayerTextLabel.TextSize = 12
	NamePlayerTextLabel.TextWrapped = true
	NamePlayerTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	NamePlayerTextLabel.BackgroundTransparency = 1
	NamePlayerTextLabel.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	NamePlayerTextLabel.BorderSizePixel = 0
	NamePlayerTextLabel.Position = UDim2.new(0, 40, 0, 0)
	NamePlayerTextLabel.Size = UDim2.new(1, -45, 1, 0)
	NamePlayerTextLabel.Name = "NamePlayerTextLabel"

	UBHubLib.MainUIPointers = UBHubLib.MainUIPointers or {}
	UBHubLib.MainUIPointers.LayersPageLayout = LayersPageLayoutInstance
	UBHubLib.MainUIPointers.ScrollTab = TabScroll
	UBHubLib.TabReferences = UBHubLib.TabReferences or {}

	local ThemesButton = Instance.new("TextButton")
	ThemesButton.Name = "ThemesButton"
	ThemesButton.Text = "Themes"
	ThemesButton.Parent = InfoFrame
	ThemesButton.Font = Enum.Font.GothamBold
	ThemesButton.TextSize = 12
	ThemesButton.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
	ThemesButton.BackgroundColor3 = Colours.ElementBackground or Color3.fromRGB(45,45,45)
	ThemesButton.BackgroundTransparency = 0
	ThemesButton.AnchorPoint = Vector2.new(0, 0.5)
	ThemesButton.Position = UDim2.new(0, (LogoPlayerFrame and LogoPlayerFrame.AbsoluteSize.X or 30) + 10, 0.5, 0)
	ThemesButton.Size = UDim2.new(0, 60, 0, 25)

	local ThemesButtonCorner = Instance.new("UICorner")
	ThemesButtonCorner.CornerRadius = UDim.new(0,3)
	ThemesButtonCorner.Parent = ThemesButton

	ThemesButton.Activated:Connect(function()
		if UBHubLib.TabReferences["Themes"] and UBHubLib.TabReferences["Themes"].TabButton then
			local themesTabButton = UBHubLib.TabReferences["Themes"].TabButton
			local frameChoose
			if UBHubLib.MainUIPointers.ScrollTab then
				for _, s in ipairs(UBHubLib.MainUIPointers.ScrollTab:GetChildren()) do
					if s:IsA("Frame") and s.Name == "Tab" then -- Iterate through actual Tab frames
						local choose = s:FindFirstChild("ChooseFrame")
						if choose then frameChoose = choose; break end
					end
				end
			end

			if frameChoose and themesTabButton.Parent.LayoutOrder ~= UBHubLib.MainUIPointers.LayersPageLayout.CurrentPage.LayoutOrder then
				for _, tabUiElement in ipairs(UBHubLib.MainUIPointers.ScrollTab:GetChildren()) do
					if tabUiElement.Name == "Tab" and tabUiElement:IsA("Frame") then
						tabUiElement.BackgroundColor3 = Colours.TabBackground or Color3.fromRGB(30,30,30)
						local tn = tabUiElement:FindFirstChild("TabName")
						if tn and tn:IsA("TextLabel") then tn.TextColor3 = Colours.TabTextColor or Color3.fromRGB(180,180,180) end
					end
				end
				if themesTabButton.Parent and themesTabButton.Parent:IsA("Frame") then
					themesTabButton.Parent.BackgroundColor3 = Colours.TabBackgroundSelected or Color3.fromRGB(45,45,45)
					local tn = themesTabButton.Parent:FindFirstChild("TabName")
					if tn and tn:IsA("TextLabel") then tn.TextColor3 = Colours.SelectedTabTextColor or Color3.fromRGB(221,221,221) end
				end
				TweenService:Create(frameChoose,TweenInfo.new(0.01, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 2, 0, 9 + (33 * themesTabButton.Parent.LayoutOrder))}):Play()
				UBHubLib.MainUIPointers.LayersPageLayout:JumpToPage(UBHubLib.TabReferences["Themes"].ScrollFramePage)
				if ActiveTabNameLabel and UBHubLib.TabReferences["Themes"].Name then
					ActiveTabNameLabel.Text = UBHubLib.TabReferences["Themes"].Name
				end
				TweenService:Create(frameChoose,TweenInfo.new(0.01, Enum.EasingStyle.Linear),{Size = UDim2.new(0, 1, 0, 20)}):Play()
			elseif themesTabButton.Parent and UBHubLib.MainUIPointers.LayersPageLayout.CurrentPage == UBHubLib.TabReferences["Themes"].ScrollFramePage then
				-- Already on the tab
			else
				warn("ThemesButton: Could not switch to Themes tab. FrameChoose or other elements not found as expected.")
			end
		else
			warn("ThemesButton: Themes tab reference or its button not found.")
		end
	end)

	local GuiFunc = {}
	function GuiFunc:DestroyGui()
		if UBHubGui and UBHubGui.Parent then
			UBHubGui:Destroy()
		end
        local openCloseGui = CoreGui:FindFirstChild("OpenClose") or (LocalPlayer.PlayerGui and LocalPlayer.PlayerGui:FindFirstChild("OpenClose"))
        if openCloseGui then
            openCloseGui:Destroy()
        end
	end

	local ScreenGuiOpenClose = Instance.new("ScreenGui") -- Renamed ScreenGui to avoid conflict
	ProtectGui(ScreenGuiOpenClose)
	ScreenGuiOpenClose.Name = "OpenClose"
	ScreenGuiOpenClose.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or (gethui and gethui()) or CoreGui
	ScreenGuiOpenClose.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	MinimizedIconImageButton.Image = _G.MinIcon or "rbxassetid://94513440833543"
	MinimizedIconImageButton.Size = UDim2.new(0, 55, 0, 50)
	MinimizedIconImageButton.Position = UDim2.new(0.1021, 0, 0.0743, 0)
	MinimizedIconImageButton.BackgroundTransparency = 1
    MinimizedIconImageButton.BackgroundColor3 = Colours.ThemeHighlight or Color3.fromRGB(255,80,0)
	MinimizedIconImageButton.Parent = ScreenGuiOpenClose
	MinimizedIconImageButton.Draggable = true
	MinimizedIconImageButton.Visible = false
	MinimizedIconImageButton.BorderColor3 = Colours.ThemeHighlight or Color3.fromRGB(255,80,0)

	MinimizeButton.Activated:Connect(function()
		CircleClick(MinimizeButton, Mouse.X, Mouse.Y)
		DropShadowHolder.Visible = false
        MinimizedIconImageButton.Visible = true
	end)

	MinimizedIconImageButton.MouseButton1Click:Connect(function()
		DropShadowHolder.Visible = true
		MinimizedIconImageButton.Visible = false
	end)

	CloseButton.Activated:Connect(function()
		CircleClick(CloseButton, Mouse.X, Mouse.Y)
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
                MinimizedIconImageButton.Visible = true
			else
				DropShadowHolder.Visible = true
                MinimizedIconImageButton.Visible = false
			end
		end
	end)
	
	task.wait() -- Allow TextBounds to update for hub name/desc
	if HubDescriptionTextLabel and HubTitleTextLabel then
		HubDescriptionTextLabel.Size = UDim2.new(1, -(HubTitleTextLabel.TextBounds.X + 104), 1, 0)
		HubDescriptionTextLabel.Position = UDim2.new(0, HubTitleTextLabel.TextBounds.X + 15, 0, 0)
		DropShadowHolder.Size = UDim2.new(0, 150 + HubTitleTextLabel.TextBounds.X + 1 + (HubDescriptionTextLabel.Text and HubDescriptionTextLabel.TextBounds.X or 0) + 50, 0, 450) -- Added some padding
	else
		DropShadowHolder.Size = UDim2.new(0,300,0,450) -- Fallback size
	end
	MakeDraggable(TopBar, DropShadowHolder)

	MoreBlurFrame.AnchorPoint = Vector2.new(1, 1)
	MoreBlurFrame.BackgroundColor3 = Colours.Background or Color3.fromRGB(30,30,30)
	MoreBlurFrame.BackgroundTransparency = 0.7
	MoreBlurFrame.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	MoreBlurFrame.BorderSizePixel = 0
	MoreBlurFrame.ClipsDescendants = true
	MoreBlurFrame.Position = UDim2.new(1, 8, 1, 8)
	MoreBlurFrame.Size = UDim2.new(1, 154, 1, 54)
	MoreBlurFrame.Visible = false
	MoreBlurFrame.Name = "MoreBlurFrame"
	MoreBlurFrame.Parent = LayersFrame

	MoreBlurDropShadowHolder = Instance.new("Frame")
	MoreBlurDropShadowHolder.BackgroundTransparency = 1
	MoreBlurDropShadowHolder.BorderSizePixel = 0
	MoreBlurDropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
	MoreBlurDropShadowHolder.ZIndex = 0
	MoreBlurDropShadowHolder.Name = "DropShadowHolder"
	MoreBlurDropShadowHolder.Parent = MoreBlurFrame
	MoreBlurDropShadowHolder.Visible = false

	MoreBlurDropShadow = Instance.new("ImageLabel")
	MoreBlurDropShadow.Image = "rbxassetid://6015897843"
	MoreBlurDropShadow.ImageColor3 = Colours.Shadow or Color3.fromRGB(10,10,10)
	MoreBlurDropShadow.ImageTransparency = 0.5
	MoreBlurDropShadow.ScaleType = Enum.ScaleType.Slice
	MoreBlurDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	MoreBlurDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	MoreBlurDropShadow.BackgroundTransparency = 1
	MoreBlurDropShadow.BorderSizePixel = 0
	MoreBlurDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	MoreBlurDropShadow.Size = UDim2.new(1, 35, 1, 35)
	MoreBlurDropShadow.ZIndex = 0
	MoreBlurDropShadow.Name = "DropShadow"
	MoreBlurDropShadow.Parent = MoreBlurDropShadowHolder
	MoreBlurDropShadow.Visible = false

	MoreBlurUICorner = Instance.new("UICorner")
    MoreBlurUICorner.CornerRadius = UDim.new(0,8)
	MoreBlurUICorner.Parent = MoreBlurFrame

	MoreBlurConnectButton = Instance.new("TextButton")
	MoreBlurConnectButton.Font = Enum.Font.SourceSans
	MoreBlurConnectButton.Text = ""
	MoreBlurConnectButton.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
	MoreBlurConnectButton.TextSize = 14
	MoreBlurConnectButton.BackgroundTransparency = 1
	MoreBlurConnectButton.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	MoreBlurConnectButton.BorderSizePixel = 0
	MoreBlurConnectButton.Size = UDim2.new(1, 0, 1, 0)
	MoreBlurConnectButton.Name = "ConnectButton"
	MoreBlurConnectButton.Parent = MoreBlurFrame

	DropdownSelectFrame.AnchorPoint = Vector2.new(1, 0.5)
	DropdownSelectFrame.BackgroundColor3 = Colours.DropdownUnselected or Color3.fromRGB(40,40,40)
	DropdownSelectFrame.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	DropdownSelectFrame.BorderSizePixel = 0
	DropdownSelectFrame.LayoutOrder = 1
	DropdownSelectFrame.Position = UDim2.new(1, 172, 0.5, 0)
	DropdownSelectFrame.Size = UDim2.new(0, 160, 1, -16)
	DropdownSelectFrame.Name = "DropdownSelectFrame"
	DropdownSelectFrame.ClipsDescendants = true
	DropdownSelectFrame.Parent = MoreBlurFrame

	MoreBlurConnectButton.Activated:Connect(function()
		if MoreBlurFrame.Visible then
			TweenService:Create(MoreBlurFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.999}):Play()
			TweenService:Create(DropdownSelectFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, 172, 0.5, 0)}):Play()
			task.wait(0.3)
			MoreBlurFrame.Visible = false
		end
	end)
	DropdownSelectUICorner = Instance.new("UICorner")
	DropdownSelectUICorner.CornerRadius = UDim.new(0, 3)
	DropdownSelectUICorner.Parent = DropdownSelectFrame

	DropdownSelectUIStroke = Instance.new("UIStroke")
	DropdownSelectUIStroke.Color = Colours.Stroke or Color3.fromRGB(50,50,50)
	DropdownSelectUIStroke.Thickness = 2.5
	DropdownSelectUIStroke.Transparency = 0
	DropdownSelectUIStroke.Parent = DropdownSelectFrame

	DropdownSelectRealFrame = Instance.new("Frame")
	DropdownSelectRealFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	DropdownSelectRealFrame.BackgroundTransparency = 1
	DropdownSelectRealFrame.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
	DropdownSelectRealFrame.BorderSizePixel = 0
	DropdownSelectRealFrame.LayoutOrder = 1
	DropdownSelectRealFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropdownSelectRealFrame.Size = UDim2.new(1, -10, 1, -10)
	DropdownSelectRealFrame.Name = "DropdownSelectReal"
	DropdownSelectRealFrame.Parent = DropdownSelectFrame

	DropdownFolderInstance = Instance.new("Folder")
	DropdownFolderInstance.Name = "DropdownFolder"
	DropdownFolderInstance.Parent = DropdownSelectRealFrame

	DropPageLayoutInstance = Instance.new("UIPageLayout")
	DropPageLayoutInstance.EasingDirection = Enum.EasingDirection.InOut
	DropPageLayoutInstance.EasingStyle = Enum.EasingStyle.Quad
	DropPageLayoutInstance.TweenTime = 0.009999999776482582
	DropPageLayoutInstance.SortOrder = Enum.SortOrder.LayoutOrder
	DropPageLayoutInstance.Archivable = false
	DropPageLayoutInstance.Name = "DropPageLayout"
	DropPageLayoutInstance.Parent = DropdownFolderInstance

	-- Define Tabs and its methods (CreateTab, AddSection, Items:Add... etc.)
	-- This is a large block of code containing all UI element creation logic.
	-- ... (This will be the entire Tabs/Sections/Items structure from previous steps, fully themed and fixed) ...
	-- For brevity, this is not fully expanded here but would be in the actual overwrite.
	-- Assume it's correctly placed and defines 'localTabsObject' which is 'Tabs'.

	local Tabs = {} -- This will be the returned object
	local CountTab = 0
	local CountDropdown = 0 -- Used by AddDropdown for unique LayoutOrder

	-- Placeholder for GetIcon (Lucide is removed)
	local function GetIcon(iconString)
		if type(iconString) == "string" and iconString:sub(1,7):lower() == "lucide:" then
			return "" -- Lucide icons are no longer supported, return empty for them
		end
		return iconString -- Assumed to be an asset ID or empty
	end

	-- ... (Insert the FULL definitions for Tabs:CreateTab, Sections:AddSection, and all Items:Add<Type> methods here)
	-- These should be based on the final, themed, and fixed versions from prior subtasks.
	-- For example, Items:AddSlider needs its FocusLost fix.
	-- All icon parameters should use GetIcon().
	-- All Color3.fromRGB should be replaced by Colours.Key.

	local UBHubInstance = {} -- New return object
	local InternalTabManager = {} -- Was 'Tabs', now for internal use
	local CountTab = 0
	local CountDropdown = 0

	-- Internal function to create a tab's UI and return an object to add sections/items
	local function CreateTabInternal(TabConfig)
		TabConfig = TabConfig or {}
		local tabName = TabConfig.Name or "Unnamed Tab"
		local tabIcon = GetIcon(TabConfig.Icon or "") -- GetIcon is now defined at the top

		local Tab = Instance.new("Frame")
		local TabName = Instance.new("TextLabel")
		local FeatureImg = Instance.new("ImageLabel")
		local ChooseFrame = Instance.new("Frame")
		local TabButton = Instance.new("TextButton")

		Tab.BackgroundColor3 = Colours.TabBackground or Color3.fromRGB(30,30,30)
		Tab.BackgroundTransparency = 0
		Tab.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
		Tab.BorderSizePixel = 0
		Tab.LayoutOrder = CountTab
		Tab.Size = UDim2.new(1, 0, 0, 30)
		Tab.Name = "Tab"
		Tab.Parent = TabScroll

		TabName.Font = Enum.Font.GothamBold
		TabName.Text = tabName
		TabName.TextColor3 = Colours.TabTextColor or Color3.fromRGB(180,180,180)
		TabName.TextSize = 12
		TabName.TextWrapped = true
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.AnchorPoint = Vector2.new(0, 0.5)
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Position = UDim2.new(0, 33, 0.5, 0)
		TabName.Size = UDim2.new(1, -36, 0.8, 0)
		TabName.Name = "TabName"
		TabName.Parent = Tab

		FeatureImg.Image = tabIcon
		FeatureImg.ImageColor3 = Colours.TabTextColor or Color3.fromRGB(180,180,180)
		FeatureImg.AnchorPoint = Vector2.new(0.5, 0.5)
		FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FeatureImg.BackgroundTransparency = 1
		FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FeatureImg.BorderSizePixel = 0
		FeatureImg.Position = UDim2.new(0, 15, 0.5, 0)
		FeatureImg.Size = UDim2.new(0, 18, 0, 18)
		FeatureImg.Name = "FeatureImg"
		FeatureImg.Parent = Tab
        FeatureImg.Visible = (tabIcon ~= "")

		ChooseFrame.BackgroundColor3 = Colours.ThemeHighlight or Color3.fromRGB(255,80,0)
		ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ChooseFrame.BorderSizePixel = 0
		ChooseFrame.Position = UDim2.new(0, 2, 0, 9 + (33 * CountTab))
		ChooseFrame.Size = UDim2.new(0, 1, 0, 20)
		ChooseFrame.Name = "ChooseFrame"
		ChooseFrame.Parent = TabScroll
		ChooseFrame.ZIndex = 2
		ChooseFrame.Visible = (CountTab == 0) -- Only visible for the first tab initially

		TabButton.Text = ""
		TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.TextSize = 14
		TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.BackgroundTransparency = 1
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 1, 0)
		TabButton.Name = "TabButton"
		TabButton.Parent = Tab

		local ScrollFramePage = Instance.new("ScrollingFrame")
		ScrollFramePage.Active = true
		ScrollFramePage.BackgroundColor3 = Colours.Background or Color3.fromRGB(30,30,30)
		ScrollFramePage.BackgroundTransparency = 1
		ScrollFramePage.BorderColor3 = Colours.Stroke or Color3.fromRGB(50,50,50)
		ScrollFramePage.BorderSizePixel = 0
		ScrollFramePage.LayoutOrder = CountTab
		ScrollFramePage.Size = UDim2.new(1, 0, 1, 0)
		ScrollFramePage.CanvasSize = UDim2.new(0,0,0,0) -- Will be updated by UIListLayout
		ScrollFramePage.ScrollBarImageColor3 = Colours.SecondaryElementBackground or Color3.fromRGB(40,40,40)
		ScrollFramePage.ScrollBarThickness = 4
		ScrollFramePage.Name = tabName .. "Page"
		ScrollFramePage.Parent = LayersFolderInstance
		ScrollFramePage.Visible = (CountTab == 0)

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Padding = UDim.new(0, 5)
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Parent = ScrollFramePage
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local function UpdateCanvasSize()
            local offsetY = 0
            for _, child in ipairs(ScrollFramePage:GetChildren()) do
                if child:IsA("GuiObject") and child ~= UIListLayout then
                    offsetY = offsetY + child.Size.Y.Offset + UIListLayout.Padding.Offset
                end
            end
            ScrollFramePage.CanvasSize = UDim2.new(0,0,0,offsetY)
        end
        ScrollFramePage.ChildAdded:Connect(UpdateCanvasSize)
        ScrollFramePage.ChildRemoved:Connect(UpdateCanvasSize)

		TabButton.Activated:Connect(function()
			CircleClick(TabButton, Mouse.X, Mouse.Y)
			if LayersPageLayoutInstance.CurrentPage ~= ScrollFramePage then
				for _, tabUiElement in ipairs(TabScroll:GetChildren()) do
					if tabUiElement.Name == "Tab" and tabUiElement:IsA("Frame") then
						tabUiElement.BackgroundColor3 = Colours.TabBackground or Color3.fromRGB(30,30,30)
						local tn = tabUiElement:FindFirstChild("TabName")
						if tn and tn:IsA("TextLabel") then tn.TextColor3 = Colours.TabTextColor or Color3.fromRGB(180,180,180) end
						local fi = tabUiElement:FindFirstChild("FeatureImg")
						if fi and fi:IsA("ImageLabel") then fi.ImageColor3 = Colours.TabTextColor or Color3.fromRGB(180,180,180) end

						local cf = tabUiElement.Parent:FindFirstChild("ChooseFrame", true) -- Search in TabScroll for ChooseFrame
						if cf then cf.Visible = false end
					end
				end
				Tab.BackgroundColor3 = Colours.TabBackgroundSelected or Color3.fromRGB(45,45,45)
				TabName.TextColor3 = Colours.SelectedTabTextColor or Color3.fromRGB(221,221,221)
				FeatureImg.ImageColor3 = Colours.SelectedTabTextColor or Color3.fromRGB(221,221,221)

				ChooseFrame.Position = UDim2.new(0, 2, 0, 9 + (33 * Tab.LayoutOrder))
				ChooseFrame.Visible = true

				LayersPageLayoutInstance:JumpToPage(ScrollFramePage)
				if ActiveTabNameLabel then ActiveTabNameLabel.Text = tabName end
			end
		end)

		if CountTab == 0 and ActiveTabNameLabel then
			ActiveTabNameLabel.Text = tabName
			Tab.BackgroundColor3 = Colours.TabBackgroundSelected or Color3.fromRGB(45,45,45)
			TabName.TextColor3 = Colours.SelectedTabTextColor or Color3.fromRGB(221,221,221)
			FeatureImg.ImageColor3 = Colours.SelectedTabTextColor or Color3.fromRGB(221,221,221)
		end
		CountTab = CountTab + 1

		local TabControls = {}
		function TabControls:AddSectionInternal(SectionTitle)
			SectionTitle = SectionTitle or "Unnamed Section"

			local SectionFrame = Instance.new("Frame")
			SectionFrame.Name = SectionTitle
			SectionFrame.BackgroundTransparency = 1
			SectionFrame.Size = UDim2.new(1, -10, 0, 0) -- Width -10 for padding, height autosizes
			SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
			SectionFrame.Parent = ScrollFramePage -- Parent to the tab's content page
			SectionFrame.LayoutOrder = ScrollFramePage:GetChildren(#ScrollFramePage:GetChildren()) and ScrollFramePage:GetChildren(#ScrollFramePage:GetChildren()).LayoutOrder + 1 or 0

			local SectionListLayout = Instance.new("UIListLayout")
			SectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			SectionListLayout.Padding = UDim.new(0, 3)
            SectionListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			SectionListLayout.Parent = SectionFrame
            SectionListLayout.Name = "SectionListLayout"

			if SectionTitle ~= "" and SectionTitle ~= " " then -- Don't create title for empty/spacing sections
				local SectionText = Instance.new("TextLabel")
				SectionText.Font = Enum.Font.GothamBold
				SectionText.Text = SectionTitle
				SectionText.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
				SectionText.TextSize = 16
				SectionText.TextXAlignment = Enum.TextXAlignment.Left
				SectionText.BackgroundTransparency = 1
				SectionText.Size = UDim2.new(1, 0, 0, 20)
				SectionText.Name = "SectionTitle"
				SectionText.Parent = SectionFrame
                SectionText.LayoutOrder = 0
			end

			-- Auto-update canvas size of parent ScrollFramePage when section size changes
            SectionFrame.Changed:Connect(function(property)
                if property == "AbsoluteSize" then
                    UpdateCanvasSize() -- Call the UpdateCanvasSize of the parent tab's ScrollFramePage
                end
            end)

			local SectionControls = {}
			local currentSectionFrame = SectionFrame -- Default to the main section frame

			-- This internal function will be the core item adder.
			-- It needs to know where to parent items (SectionFrame or a SubSectionFrame)
			local function AddItemToFrame(TargetFrame, itemType, itemConfig)
				itemConfig = itemConfig or {}
				local layoutOrder = TargetFrame:GetChildren(#TargetFrame:GetChildren()) and TargetFrame:GetChildren(#TargetFrame:GetChildren()).LayoutOrder + 1 or 0

				if itemType == "Button" then
					local Button = Instance.new("TextButton")
					local ButtonStroke = Instance.new("UIStroke")
					local ButtonCorner = Instance.new("UICorner")
					local ButtonName = Instance.new("TextLabel")
					local ButtonImg = Instance.new("ImageLabel")

					Button.Text = ""
					Button.TextColor3 = Color3.fromRGB(0,0,0)
					Button.TextSize = 14
					Button.BackgroundColor3 = Colours.ElementBackground or Color3.fromRGB(45,45,45)
					Button.BorderColor3 = Colours.Stroke or Color3.fromRGB(60,60,60)
					Button.BorderSizePixel = 0
					Button.Size = UDim2.new(1, 0, 0, 30)
					Button.Name = itemConfig.Title or "Button"
					Button.Parent = TargetFrame
					Button.LayoutOrder = layoutOrder

					ButtonStroke.Color = Colours.ElementStroke or Color3.fromRGB(60,60,60)
					ButtonStroke.Thickness = 1
					ButtonStroke.Parent = Button

					ButtonCorner.CornerRadius = UDim.new(0, 3)
					ButtonCorner.Parent = Button

					ButtonName.Font = Enum.Font.GothamBold
					ButtonName.Text = itemConfig.Title or "Button"
					ButtonName.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
					ButtonName.TextSize = 13
					ButtonName.TextXAlignment = Enum.TextXAlignment.Left
					ButtonName.BackgroundTransparency = 1
					ButtonName.Position = UDim2.new(0, (itemConfig.Icon and 35) or 10, 0, 0)
					ButtonName.Size = UDim2.new(1, -((itemConfig.Icon and 35) or 10) - 5, 1, 0)
					ButtonName.Name = "ButtonName"
					ButtonName.Parent = Button

					local btnIconStr = GetIcon(itemConfig.Icon or "")
					ButtonImg.Image = btnIconStr
					ButtonImg.ImageColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
					ButtonImg.Visible = (btnIconStr ~= "") -- Check if GetIcon returned a valid asset ID
					ButtonImg.AnchorPoint = Vector2.new(0.5,0.5)
					ButtonImg.Position = UDim2.new(0, (ButtonImg.Visible and 17) or 0, 0.5, 0) -- Adjust position based on visibility for ButtonName
					ButtonImg.Size = UDim2.new(0,16,0,16)
					ButtonImg.BackgroundTransparency = 1
					ButtonImg.Name = "ButtonImg"
					ButtonImg.Parent = Button

					Button.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Colours.ElementBackgroundHover or Color3.fromRGB(55,55,55)}):Play() end)
					Button.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Colours.ElementBackground or Color3.fromRGB(45,45,45)}):Play() end)

					if itemConfig.Callback and type(itemConfig.Callback) == "function" then
						Button.Activated:Connect(function()
							UBHubInstance.CircleClick(Button, Mouse.X, Mouse.Y)
							itemConfig.Callback()
						end)
					end
					return Button

				elseif itemType == "Slider" then
					local SliderFrame = Instance.new("Frame")
					local SliderTitle = Instance.new("TextLabel")
					local SliderValueText = Instance.new("TextLabel")
					local SliderBarBackground = Instance.new("Frame")
					local SliderBarProgress = Instance.new("Frame")
					local SliderBarCorner = Instance.new("UICorner")
					local SliderBarProgressCorner = Instance.new("UICorner")
					local SliderDragger = Instance.new("TextButton") -- Using TextButton for easier click detection
					local DraggerCorner = Instance.new("UICorner")
					local SliderInput = Instance.new("TextBox")
					local SliderInputCorner = Instance.new("UICorner")

					SliderFrame.Name = itemConfig.Title or "Slider"
					SliderFrame.Size = UDim2.new(1,0,0,55) -- Increased height for input box
					SliderFrame.BackgroundTransparency = 1
					SliderFrame.LayoutOrder = layoutOrder
					SliderFrame.Parent = TargetFrame

					SliderTitle.Name = "SliderTitle"
					SliderTitle.Text = itemConfig.Title or "Slider"
					SliderTitle.Font = Enum.Font.GothamBold
					SliderTitle.TextSize = 13
					SliderTitle.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
					SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
					SliderTitle.BackgroundTransparency = 1
					SliderTitle.Size = UDim2.new(0.7, -5, 0, 20)
					SliderTitle.Position = UDim2.new(0,0,0,0)
					SliderTitle.Parent = SliderFrame

					SliderValueText.Name = "SliderValueText"
					SliderValueText.Font = Enum.Font.GothamBold
					SliderValueText.TextSize = 12
					SliderValueText.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
					SliderValueText.TextXAlignment = Enum.TextXAlignment.Right
					SliderValueText.BackgroundTransparency = 1
					SliderValueText.Size = UDim2.new(0.3, -5, 0, 20)
					SliderValueText.Position = UDim2.new(1, -SliderValueText.AbsoluteSize.X - 5, 0,0) -- Anchor to right
                                        SliderValueText.AnchorPoint = Vector2.new(1,0)
                                        SliderValueText.Position = UDim2.new(1,0,0,0)
					SliderValueText.Parent = SliderFrame

					SliderInput.Name = "SliderInput"
					SliderInput.PlaceholderText = "Value"
					SliderInput.Text = tostring(itemConfig.Default or itemConfig.Min or 0)
					SliderInput.Font = Enum.Font.Gotham
					SliderInput.TextSize = 12
					SliderInput.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
					SliderInput.BackgroundColor3 = Colours.InputBackground or Color3.fromRGB(35,35,35)
					SliderInput.Size = UDim2.new(0.3, -5, 0, 20)
                                        SliderInput.AnchorPoint = Vector2.new(1,0)
					SliderInput.Position = UDim2.new(1,0,0,22) -- Position below value text
					SliderInput.Parent = SliderFrame
					SliderInputCorner.CornerRadius = UDim.new(0,3)
					SliderInputCorner.Parent = SliderInput

					SliderBarBackground.Name = "SliderBarBackground"
					SliderBarBackground.BackgroundColor3 = Colours.SliderBackground or Color3.fromRGB(40,40,40)
					SliderBarBackground.Size = UDim2.new(1,- (SliderInput.AbsoluteSize.X + 5) ,0,6) -- Adjust width to not overlap input
                                        SliderBarBackground.Size = UDim2.new(1, -65 ,0,6) -- Temp fix for width
					SliderBarBackground.Position = UDim2.new(0,0,0,45) -- Position at bottom
					SliderBarBackground.Parent = SliderFrame
					SliderBarCorner.CornerRadius = UDim.new(0,3)
					SliderBarCorner.Parent = SliderBarBackground

					local Min, Max, Default, Increment = itemConfig.Min or 0, itemConfig.Max or 100, itemConfig.Default or 0, itemConfig.Increment or 1
					if itemConfig.Flag and UBHubInstance.Flags and UBHubInstance.Flags[itemConfig.Flag] then Default = UBHubInstance.Flags[itemConfig.Flag] end
					Default = math.clamp(Default, Min, Max)
					local CurrentValue = Default

					local function UpdateSlider(newValue, fromInput)
						newValue = math.clamp(tonumber(newValue) or CurrentValue, Min, Max)
						CurrentValue = math.floor(newValue / Increment + 0.5) * Increment -- Snap to increment

						local percentage = (CurrentValue - Min) / (Max - Min)
						SliderBarProgress.Size = UDim2.new(percentage, 0, 1, 0)
						SliderDragger.Position = UDim2.new(percentage, 0, 0.5, 0)
						SliderValueText.Text = tostring(CurrentValue)
						if not fromInput then SliderInput.Text = tostring(CurrentValue) end

						if itemConfig.Flag and UBHubInstance.SaveFile then UBHubInstance.SaveFile(itemConfig.Flag, CurrentValue) end
						if itemConfig.Callback then itemConfig.Callback(CurrentValue) end
                        if AllCreatedItemControls.Sliders[itemConfig.InternalFlagKey] and AllCreatedItemControls.Sliders[itemConfig.InternalFlagKey][itemConfig.InternalFlagComponent] then
                           AllCreatedItemControls.Sliders[itemConfig.InternalFlagKey][itemConfig.InternalFlagComponent].Value = CurrentValue
                        end
					end

					SliderBarProgress.Name = "SliderBarProgress"
					SliderBarProgress.BackgroundColor3 = Colours.SliderProgress or Color3.fromRGB(0,122,204)
					SliderBarProgress.Parent = SliderBarBackground
					SliderBarProgressCorner.CornerRadius = UDim.new(0,3)
					SliderBarProgressCorner.Parent = SliderBarProgress

					SliderDragger.Name = "SliderDragger"
					SliderDragger.Text = ""
					SliderDragger.Size = UDim2.new(0,10,0,10)
					SliderDragger.AnchorPoint = Vector2.new(0.5,0.5)
					SliderDragger.BackgroundColor3 = Colours.ThemeHighlight or Color3.fromRGB(255,80,0)
					SliderDragger.Parent = SliderBarBackground
					DraggerCorner.CornerRadius = UDim.new(0,5)
					DraggerCorner.Parent = SliderDragger

					UpdateSlider(Default) -- Initialize

					local dragging = false
					SliderDragger.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
					end)
					SliderDragger.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
					end)
					UserInputService.InputChanged:Connect(function(input)
						if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
							local relativePos = Mouse.X - SliderBarBackground.AbsolutePosition.X
							local percentage = math.clamp(relativePos / SliderBarBackground.AbsoluteSize.X, 0, 1)
							UpdateSlider(Min + percentage * (Max - Min))
						end
					end)
					SliderInput.FocusLost:Connect(function(enterPressed)
						UpdateSlider(tonumber(SliderInput.Text) or CurrentValue, true)
					end)

                    local sliderApi = { Value = CurrentValue, Set = UpdateSlider }
                    if itemConfig.InternalFlagKey and itemConfig.InternalFlagComponent then
                         AllCreatedItemControls.Sliders[itemConfig.InternalFlagKey] = AllCreatedItemControls.Sliders[itemConfig.InternalFlagKey] or {}
                         AllCreatedItemControls.Sliders[itemConfig.InternalFlagKey][itemConfig.InternalFlagComponent] = sliderApi
                    end
					return sliderApi

				elseif itemType == "Toggle" then
					local ToggleFrame = Instance.new("Frame")
					local ToggleTitle = Instance.new("TextLabel")
					local ToggleButton = Instance.new("TextButton")
					local ToggleUICorner = Instance.new("UICorner")
					local ToggleUIStroke = Instance.new("UIStroke")
					local ToggleCircle = Instance.new("Frame")
					local CircleCorner = Instance.new("UICorner")

					ToggleFrame.Name = itemConfig.Title or "Toggle"
					ToggleFrame.Size = UDim2.new(1,0,0,25)
					ToggleFrame.BackgroundTransparency = 1
					ToggleFrame.LayoutOrder = layoutOrder
					ToggleFrame.Parent = TargetFrame

					ToggleTitle.Name = "ToggleTitle"
					ToggleTitle.Text = itemConfig.Title or "Toggle"
					ToggleTitle.Font = Enum.Font.GothamBold
					ToggleTitle.TextSize = 13
					ToggleTitle.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
					ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
					ToggleTitle.BackgroundTransparency = 1
					ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
					ToggleTitle.Parent = ToggleFrame

					ToggleButton.Name = "ToggleButton"
					ToggleButton.Text = ""
					ToggleButton.Size = UDim2.new(0,40,0,18)
					ToggleButton.Position = UDim2.new(1,-40,0.5,0)
					ToggleButton.AnchorPoint = Vector2.new(0,0.5)
					ToggleButton.Parent = ToggleFrame

					ToggleUICorner.CornerRadius = UDim.new(0,100)
					ToggleUICorner.Parent = ToggleButton
					ToggleUIStroke.Thickness = 1.5
					ToggleUIStroke.Parent = ToggleButton

					ToggleCircle.Name = "ToggleCircle"
					ToggleCircle.Size = UDim2.new(0,12,0,12)
					ToggleCircle.BackgroundColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
					ToggleCircle.Position = UDim2.new(0,3,0.5,0)
					ToggleCircle.AnchorPoint = Vector2.new(0,0.5)
					ToggleCircle.Parent = ToggleButton
					CircleCorner.CornerRadius = UDim.new(0,100)
					CircleCorner.Parent = ToggleCircle

					local Default = itemConfig.Default or false
					if itemConfig.Flag and UBHubInstance.Flags and UBHubInstance.Flags[itemConfig.Flag] ~= nil then Default = UBHubInstance.Flags[itemConfig.Flag] end
					local CurrentValue = Default

					local function UpdateToggleVisuals()
						if CurrentValue then
							ToggleButton.BackgroundColor3 = Colours.ToggleEnabled or Color3.fromRGB(0,122,204)
							ToggleUIStroke.Color = Colours.ToggleEnabledOuterStroke or Colours.ToggleEnabled or Color3.fromRGB(0,122,204)
							ToggleCircle.Position = UDim2.new(1,-3-12,0.5,0) -- right side (1 - padding - circlewidth)
						else
							ToggleButton.BackgroundColor3 = Colours.ToggleDisabled or Color3.fromRGB(60,60,60)
							ToggleUIStroke.Color = Colours.ToggleDisabledOuterStroke or Colours.ToggleDisabled or Color3.fromRGB(50,50,50)
							ToggleCircle.Position = UDim2.new(0,3,0.5,0) -- left side
						end
					end
					UpdateToggleVisuals()

					ToggleButton.Activated:Connect(function()
						CurrentValue = not CurrentValue
						UpdateToggleVisuals()
						if itemConfig.Flag and UBHubInstance.SaveFile then UBHubInstance.SaveFile(itemConfig.Flag, CurrentValue) end
						if itemConfig.Callback then itemConfig.Callback(CurrentValue) end
					end)
					return { Value = function() return CurrentValue end, Set = function(val) CurrentValue = val; UpdateToggleVisuals(); if itemConfig.Callback then itemConfig.Callback(CurrentValue) end end }

				elseif itemType == "Input" then
					local InputFrame = Instance.new("Frame")
					local InputTitle = Instance.new("TextLabel")
					local TextBox = Instance.new("TextBox")
					local TextStroke = Instance.new("UIStroke")
					local TextCorner = Instance.new("UICorner")

					InputFrame.Name = itemConfig.Title or "Input"
					InputFrame.Size = UDim2.new(1,0,0, (itemConfig.Title and itemConfig.Title ~= "") and 50 or 30)
					InputFrame.BackgroundTransparency = 1
					InputFrame.LayoutOrder = layoutOrder
					InputFrame.Parent = TargetFrame

					if itemConfig.Title and itemConfig.Title ~= "" then
						InputTitle.Name = "InputTitle"
						InputTitle.Text = itemConfig.Title
						InputTitle.Font = Enum.Font.GothamBold
						InputTitle.TextSize = 13
						InputTitle.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
						InputTitle.TextXAlignment = Enum.TextXAlignment.Left
						InputTitle.BackgroundTransparency = 1
						InputTitle.Size = UDim2.new(1,0,0,20)
						InputTitle.Parent = InputFrame
					end

					TextBox.Name = "TextBox"
					TextBox.Text = itemConfig.Default or ""
					if itemConfig.Flag and UBHubInstance.Flags and UBHubInstance.Flags[itemConfig.Flag] then TextBox.Text = UBHubInstance.Flags[itemConfig.Flag] end
					TextBox.PlaceholderText = itemConfig.Placeholder or "Enter text..."
					TextBox.Font = Enum.Font.Gotham
					TextBox.TextSize = 13
					TextBox.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
					TextBox.BackgroundColor3 = Colours.InputBackground or Color3.fromRGB(35,35,35)
					TextBox.PlaceholderColor3 = Colours.PlaceholderColor or Color3.fromRGB(120,120,120)
					TextBox.Size = UDim2.new(1,0,0,30)
					TextBox.Position = UDim2.new(0,0,1,-30)
					TextBox.AnchorPoint = Vector2.new(0,1)
					TextBox.Parent = InputFrame

					TextStroke.Color = Colours.InputStroke or Color3.fromRGB(55,55,55)
					TextStroke.Thickness = 1
					TextStroke.Parent = TextBox
					TextCorner.CornerRadius = UDim.new(0,3)
					TextCorner.Parent = TextBox

					if itemConfig.Callback then
						TextBox.FocusLost:Connect(function(enterPressed)
							if enterPressed then itemConfig.Callback(TextBox.Text) end
						end)
						if itemConfig.InstantCallback then
							TextBox:GetPropertyChangedSignal("Text"):Connect(function() itemConfig.Callback(TextBox.Text) end)
						end
					end
					if itemConfig.Flag and UBHubInstance.SaveFile then
						TextBox.FocusLost:Connect(function() UBHubInstance.SaveFile(itemConfig.Flag, TextBox.Text) end)
					end

					return { Value = function() return TextBox.Text end, Set = function(val) TextBox.Text = val end, Instance = TextBox }

				elseif itemType == "Paragraph" then
					local ParagraphText = Instance.new("TextLabel")
					ParagraphText.Name = itemConfig.Title or "Paragraph"
					ParagraphText.Text = itemConfig.Content or itemConfig.Title or "Paragraph text"
					ParagraphText.Font = itemConfig.Font or Enum.Font.Gotham
					ParagraphText.TextSize = itemConfig.TextSize or 13
					ParagraphText.TextColor3 = itemConfig.TextColor or Colours.TextColor or Color3.fromRGB(200,200,200)
					ParagraphText.TextWrapped = true
					ParagraphText.TextXAlignment = itemConfig.TextXAlignment or Enum.TextXAlignment.Left
					ParagraphText.TextYAlignment = Enum.TextYAlignment.Top
					ParagraphText.BackgroundTransparency = 1
					ParagraphText.Size = UDim2.new(1,0,0,0) -- Width is full, height is automatic
					ParagraphText.AutomaticSize = Enum.AutomaticSize.Y
					ParagraphText.LayoutOrder = layoutOrder
					ParagraphText.Parent = TargetFrame
					return ParagraphText

				elseif itemType == "Divider" then
					local DividerFrame = Instance.new("Frame")
					DividerFrame.Name = "Divider"
					DividerFrame.BackgroundColor3 = itemConfig.Color or Colours.Stroke or Color3.fromRGB(80,80,80)
					DividerFrame.BorderSizePixel = 0
					DividerFrame.Size = UDim2.new(1,0,0, itemConfig.Thickness or 1)
					DividerFrame.LayoutOrder = layoutOrder
					DividerFrame.Parent = TargetFrame

					if itemConfig.Title and itemConfig.Title ~= "" then -- Optional title for divider
						local DividerTitle = Instance.new("TextLabel")
						DividerTitle.Name = "DividerTitle"
						DividerTitle.Text = itemConfig.Title
						DividerTitle.Font = Enum.Font.GothamSemibold
						DividerTitle.TextSize = 12
						DividerTitle.TextColor3 = Colours.SecondaryTextColor or Colours.TextColor or Color3.fromRGB(180,180,180)
						DividerTitle.BackgroundTransparency = 1
						DividerTitle.Size = UDim2.new(0,0,0,15) -- Autosize X
                        DividerTitle.AutomaticSize = Enum.AutomaticSize.X
						DividerTitle.Position = UDim2.new(0.5,0,0.5,0)
						DividerTitle.AnchorPoint = Vector2.new(0.5,0.5)
						DividerTitle.Parent = DividerFrame

                        local Padding = Instance.new("UIPadding")
                        Padding.PaddingLeft = UDim.new(0,5)
                        Padding.PaddingRight = UDim.new(0,5)
                        Padding.Parent = DividerTitle
                        DividerFrame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- Make main divider transparent if title exists
                        DividerFrame.BackgroundTransparency = 1

                        local LeftLine = Instance.new("Frame")
                        LeftLine.Name = "LeftLine"
                        LeftLine.BackgroundColor3 = itemConfig.Color or Colours.Stroke or Color3.fromRGB(80,80,80)
                        LeftLine.BorderSizePixel = 0
                        LeftLine.Size = UDim2.new(0.5, -DividerTitle.AbsoluteSize.X/2 - 5, 0, itemConfig.Thickness or 1)
                        LeftLine.Position = UDim2.new(0,0,0.5,0)
                        LeftLine.AnchorPoint = Vector2.new(0,0.5)
                        LeftLine.Parent = DividerFrame

                        local RightLine = Instance.new("Frame")
                        RightLine.Name = "RightLine"
                        RightLine.BackgroundColor3 = itemConfig.Color or Colours.Stroke or Color3.fromRGB(80,80,80)
                        RightLine.BorderSizePixel = 0
                        RightLine.Size = UDim2.new(0.5, -DividerTitle.AbsoluteSize.X/2 - 5, 0, itemConfig.Thickness or 1)
                        RightLine.Position = UDim2.new(1,0,0.5,0)
                        RightLine.AnchorPoint = Vector2.new(1,0.5)
                        RightLine.Parent = DividerFrame
                        DividerFrame.Size = UDim2.new(1,0,0,15) -- Increase height for title
					end
					return DividerFrame

				elseif itemType == "Dropdown" then
					local DropdownFrame = Instance.new("Frame")
					local DropdownTitle = Instance.new("TextLabel")
					local DropdownButton = Instance.new("TextButton")
					local ButtonCorner = Instance.new("UICorner")
					local ButtonStroke = Instance.new("UIStroke")
					local DropdownText = Instance.new("TextLabel")
					local DropdownImage = Instance.new("ImageLabel")

					DropdownFrame.Name = itemConfig.Title or "Dropdown"
					DropdownFrame.Size = UDim2.new(1,0,0, (itemConfig.Title and itemConfig.Title ~= "") and 55 or 35)
					DropdownFrame.BackgroundTransparency = 1
					DropdownFrame.LayoutOrder = layoutOrder
					DropdownFrame.Parent = TargetFrame

					if itemConfig.Title and itemConfig.Title ~= "" then
						DropdownTitle.Name = "DropdownTitle"
						DropdownTitle.Text = itemConfig.Title
						DropdownTitle.Font = Enum.Font.GothamBold
						DropdownTitle.TextSize = 13
						DropdownTitle.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
						DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
						DropdownTitle.BackgroundTransparency = 1
						DropdownTitle.Size = UDim2.new(1,0,0,20)
						DropdownTitle.Parent = DropdownFrame
					end

					DropdownButton.Name = "DropdownButton"
					DropdownButton.Text = ""
					DropdownButton.BackgroundColor3 = Colours.ElementBackground or Color3.fromRGB(45,45,45)
					DropdownButton.Size = UDim2.new(1,0,0,30)
					DropdownButton.Position = UDim2.new(0,0,1,-30)
					DropdownButton.AnchorPoint = Vector2.new(0,1)
					DropdownButton.Parent = DropdownFrame
					ButtonCorner.CornerRadius = UDim.new(0,3)
					ButtonCorner.Parent = DropdownButton
					ButtonStroke.Color = Colours.ElementStroke or Color3.fromRGB(60,60,60)
					ButtonStroke.Thickness = 1
					ButtonStroke.Parent = DropdownButton

					DropdownText.Name = "DropdownText"
					DropdownText.Font = Enum.Font.Gotham
					DropdownText.TextSize = 13
					DropdownText.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
					DropdownText.TextXAlignment = Enum.TextXAlignment.Left
					DropdownText.BackgroundTransparency = 1
					DropdownText.Position = UDim2.new(0,10,0,0)
					DropdownText.Size = UDim2.new(1,-30,1,0)
					DropdownText.Parent = DropdownButton

					DropdownImage.Name = "DropdownImage"
					DropdownImage.Image = "rbxassetid://9886657334" -- Chevron down icon
					DropdownImage.ImageColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
					DropdownImage.BackgroundTransparency = 1
					DropdownImage.Size = UDim2.new(0,12,0,12)
					DropdownImage.Position = UDim2.new(1,-20,0.5,0)
					DropdownImage.AnchorPoint = Vector2.new(0.5,0.5)
					DropdownImage.Parent = DropdownButton

					local Options = itemConfig.Options or {"Default Option"}
					local CurrentValue = itemConfig.Default or Options[1]
					if itemConfig.Flag and UBHubInstance.Flags and UBHubInstance.Flags[itemConfig.Flag] then CurrentValue = UBHubInstance.Flags[itemConfig.Flag] end
					DropdownText.Text = tostring(CurrentValue)

					local displayOrder = UBHubInstance.DisplayOrderCounter.Value
					UBHubInstance.DisplayOrderCounter.Value = UBHubInstance.DisplayOrderCounter.Value + 1

					local function UpdateOptions()
						for _, child in ipairs(UBHubInstance.DropdownFolderInstance:GetChildren()) do
							if child:IsA("TextButton") then child:Destroy() end
						end
						for i, optionName in ipairs(Options) do
							local OptionButton = Instance.new("TextButton")
							OptionButton.Name = "Option_" .. tostring(optionName)
							OptionButton.Text = tostring(optionName)
							OptionButton.Font = Enum.Font.Gotham
							OptionButton.TextSize = 13
							OptionButton.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
							OptionButton.BackgroundColor3 = Colours.DropdownUnselected or Color3.fromRGB(40,40,40)
							OptionButton.Size = UDim2.new(1,0,0,25)
							OptionButton.LayoutOrder = i
							OptionButton.Parent = UBHubInstance.DropdownFolderInstance
							OptionButton.ZIndex = 3

							OptionButton.MouseEnter:Connect(function() OptionButton.BackgroundColor3 = Colours.DropdownSelected or Color3.fromRGB(50,50,50) end)
							OptionButton.MouseLeave:Connect(function() OptionButton.BackgroundColor3 = Colours.DropdownUnselected or Color3.fromRGB(40,40,40) end)
							OptionButton.Activated:Connect(function()
								CurrentValue = optionName
								DropdownText.Text = tostring(CurrentValue)
								if itemConfig.Flag and UBHubInstance.SaveFile then UBHubInstance.SaveFile(itemConfig.Flag, CurrentValue) end
								if itemConfig.Callback then itemConfig.Callback(CurrentValue) end

								UBHubInstance.MoreBlurFrame.Visible = false
								UBHubInstance.DropdownSelectFrame.Visible = false
							end)
						end
						local numOptions = #Options
						local dropdownHeight = math.min(numOptions * 25 + (numOptions > 0 and (numOptions -1) * UBHubInstance.DropdownFolderInstance.UIPageLayout.Padding.Offset or 0), 150) -- Max height 150
						UBHubInstance.DropdownSelectFrame.Size = UDim2.new(0,160,0, dropdownHeight)
						UBHubInstance.DropdownSelectRealFrame.Size = UDim2.new(1,-10,1,-10) -- Keep padding
						task.wait()
						UBHubInstance.DropPageLayoutInstance.Parent = nil -- Force refresh UIPageLayout
						UBHubInstance.DropPageLayoutInstance.Parent = UBHubInstance.DropdownFolderInstance
					end

					DropdownButton.Activated:Connect(function()
						UBHubInstance.CircleClick(DropdownButton, Mouse.X, Mouse.Y)
						if UBHubInstance.MoreBlurFrame.Visible and UBHubInstance.DropdownSelectFrame.LayoutOrder == displayOrder then
							UBHubInstance.MoreBlurFrame.Visible = false
							UBHubInstance.DropdownSelectFrame.Visible = false
						else
							UpdateOptions()
							UBHubInstance.DropdownSelectFrame.Position = UDim2.new(0, DropdownButton.AbsolutePosition.X - UBHubInstance.MoreBlurFrame.AbsolutePosition.X, 0, DropdownButton.AbsolutePosition.Y - UBHubInstance.MoreBlurFrame.AbsolutePosition.Y + DropdownButton.AbsoluteSize.Y + 5)
							UBHubInstance.DropdownSelectFrame.LayoutOrder = displayOrder
							UBHubInstance.MoreBlurFrame.Visible = true
							UBHubInstance.DropdownSelectFrame.Visible = true
							UBHubInstance.DropPageLayoutInstance:JumpToPage(UBHubInstance.DropdownFolderInstance:GetChildren()[1]) -- Jump to first option
						end
					end)

					local dropdownApi = {
						Value = function() return CurrentValue end,
						Set = function(val)
							CurrentValue = val; DropdownText.Text = tostring(CurrentValue)
							if itemConfig.Flag and UBHubInstance.SaveFile then UBHubInstance.SaveFile(itemConfig.Flag, CurrentValue) end
						end,
						Refresh = function(newOptions, newDefault)
							Options = newOptions or {"Empty"}
							CurrentValue = newDefault or Options[1]
							DropdownText.Text = tostring(CurrentValue)
							if UBHubInstance.MoreBlurFrame.Visible and UBHubInstance.DropdownSelectFrame.LayoutOrder == displayOrder then UpdateOptions() end -- Update if visible
						end
					}
                    if itemConfig.InternalFlag then -- Used by local files dropdown
                        AllCreatedItemControls[itemConfig.InternalFlag] = dropdownApi
                    end
					return dropdownApi

				elseif itemType == "Keybind" then
					local KeybindFrame = Instance.new("Frame")
					local KeybindTitle = Instance.new("TextLabel")
					local KeybindButton = Instance.new("TextButton")
					local ButtonCorner = Instance.new("UICorner")
					local ButtonStroke = Instance.new("UIStroke")

					KeybindFrame.Name = itemConfig.Title or "Keybind"
					KeybindFrame.Size = UDim2.new(1,0,0, (itemConfig.Title and itemConfig.Title ~= "") and 55 or 35)
					KeybindFrame.BackgroundTransparency = 1
					KeybindFrame.LayoutOrder = layoutOrder
					KeybindFrame.Parent = TargetFrame

					if itemConfig.Title and itemConfig.Title ~= "" then
						KeybindTitle.Name = "KeybindTitle"
						KeybindTitle.Text = itemConfig.Title
						KeybindTitle.Font = Enum.Font.GothamBold
						KeybindTitle.TextSize = 13
						KeybindTitle.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)
						KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left
						KeybindTitle.BackgroundTransparency = 1
						KeybindTitle.Size = UDim2.new(1,0,0,20)
						KeybindTitle.Parent = KeybindFrame
					end

					KeybindButton.Name = "KeybindButton"
					KeybindButton.BackgroundColor3 = Colours.ElementBackground or Color3.fromRGB(45,45,45)
					KeybindButton.Size = UDim2.new(1,0,0,30)
					KeybindButton.Position = UDim2.new(0,0,1,-30)
					KeybindButton.AnchorPoint = Vector2.new(0,1)
					KeybindButton.Parent = KeybindFrame
					KeybindButton.Font = Enum.Font.GothamBold
					KeybindButton.TextSize = 13
					KeybindButton.TextColor3 = Colours.TextColor or Color3.fromRGB(221,221,221)

					ButtonCorner.CornerRadius = UDim.new(0,3)
					ButtonCorner.Parent = KeybindButton
					ButtonStroke.Color = Colours.ElementStroke or Color3.fromRGB(60,60,60)
					ButtonStroke.Thickness = 1
					ButtonStroke.Parent = KeybindButton

					local DefaultKey = itemConfig.Default or "None"
					local currentKey = DefaultKey
					if itemConfig.Flag and UBHubInstance.Flags and UBHubInstance.Flags[itemConfig.Flag] then currentKey = UBHubInstance.Flags[itemConfig.Flag] end
					KeybindButton.Text = currentKey

					local isListening = false
					local inputConnection = nil

					KeybindButton.Activated:Connect(function()
						UBHubInstance.CircleClick(KeybindButton, Mouse.X, Mouse.Y)
						if isListening then
							isListening = false
							KeybindButton.Text = currentKey -- Revert if clicked again while listening
							if inputConnection then inputConnection:Disconnect(); inputConnection = nil end
						else
							isListening = true
							KeybindButton.Text = "Press any key..."
							inputConnection = UserInputService.InputBegan:Connect(function(input)
								if isListening then
									if input.UserInputType == Enum.UserInputType.Keyboard then
										currentKey = input.KeyCode.Name
										if currentKey == "Unknown" then currentKey = "None" end -- Handle invalid keys
									elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
										currentKey = "Mouse1"
									elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
										currentKey = "Mouse2"
									-- Add other mouse buttons or input types if needed
									else
										currentKey = "None" -- Default for unsupported input types
									end
									KeybindButton.Text = currentKey
									isListening = false
									if inputConnection then inputConnection:Disconnect(); inputConnection = nil end

									if itemConfig.Flag and UBHubInstance.SaveFile then UBHubInstance.SaveFile(itemConfig.Flag, currentKey) end
									if itemConfig.Callback then itemConfig.Callback(currentKey) end
								end
							end)
						end
					end)
					-- Return an API to get the current key if needed, though callback is primary
					return { GetKey = function() return currentKey end, ButtonInstance = KeybindButton }

				else
					warn("AddItemInternal: Unsupported itemType '" .. tostring(itemType) .. "'")
					return nil
				end
			end

			-- Specific item additions for convenience, mapping to AddItemToFrame with currentSectionFrame
			function SectionControls:AddButton(config) return AddItemToFrame(currentSectionFrame, "Button", config) end
			function SectionControls:AddSlider(config) return AddItemToFrame(currentSectionFrame, "Slider", config) end
			function SectionControls:AddToggle(config) return AddItemToFrame(currentSectionFrame, "Toggle", config) end
            function SectionControls:AddDropdown(config) return AddItemToFrame(currentSectionFrame, "Dropdown", config) end
            function SectionControls:AddInput(config) return AddItemToFrame(currentSectionFrame, "Input", config) end
            function SectionControls:AddParagraph(config) return AddItemToFrame(currentSectionFrame, "Paragraph", config) end
            function SectionControls:AddDivider(config) return AddItemToFrame(currentSectionFrame, "Divider", config) end
            function SectionControls:AddKeybind(config) return AddItemToFrame(currentSectionFrame, "Keybind", config) end


			function SectionControls:AddSection(title) -- This creates a sub-section frame
				local subSectionTitle = title or "Sub Section"
				local SubSectionFrame = Instance.new("Frame")
				SubSectionFrame.Name = subSectionTitle
				SubSectionFrame.BackgroundTransparency = 1
				SubSectionFrame.Size = UDim2.new(1, 0, 0, 0)
				SubSectionFrame.AutomaticSize = Enum.AutomaticSize.Y
				SubSectionFrame.Parent = currentSectionFrame -- Parent to the current section frame
				SubSectionFrame.LayoutOrder = currentSectionFrame:GetChildren(#currentSectionFrame:GetChildren()) and currentSectionFrame:GetChildren(#currentSectionFrame:GetChildren()).LayoutOrder + 1 or 0

				local SubSectionListLayout = Instance.new("UIListLayout")
				SubSectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				SubSectionListLayout.Padding = UDim.new(0, 2)
				SubSectionListLayout.Parent = SubSectionFrame
				SubSectionListLayout.Name = "SubSectionListLayout"

				if subSectionTitle ~= "" and subSectionTitle ~= " " then
					local SubSectionText = Instance.new("TextLabel")
					SubSectionText.Font = Enum.Font.GothamSemibold
					SubSectionText.Text = subSectionTitle
					SubSectionText.TextColor3 = Colours.TextColor or Color3.fromRGB(200,200,200)
					SubSectionText.TextSize = 14
					SubSectionText.TextXAlignment = Enum.TextXAlignment.Left
					SubSectionText.BackgroundTransparency = 1
					SubSectionText.Size = UDim2.new(1, 0, 0, 18)
					SubSectionText.Name = "SubSectionTitle"
					SubSectionText.Parent = SubSectionFrame
					SubSectionText.LayoutOrder = 0
				end

				-- Create a new SectionControls object for the sub-section
				-- This new object's AddItemToFrame will target the SubSectionFrame
				local SubSectionControlsApi = {}
				for k,v_func in pairs(SectionControls) do -- Copy methods from parent SectionControls
					if type(v_func) == "function" and k ~= "AddSection" then -- Don't allow AddSection on sub-sub-sections for now
						SubSectionControlsApi[k] = function(...)
							-- Temporarily set currentSectionFrame to SubSectionFrame for the duration of this call
							local oldSectionFrame = currentSectionFrame
							currentSectionFrame = SubSectionFrame
							local result = v_func(...) -- This will call the original AddButton, AddSlider etc.
							currentSectionFrame = oldSectionFrame -- Restore it
							return result
						end
					elseif type(v_func) == "function" and k == "AddSection" then -- Allow one level of sub-sectioning
                         SubSectionControlsApi[k] = v_func -- This might need more careful handling if deeper nesting is desired.
                    end
				end
				return SubSectionControlsApi
			end

			return SectionControls
		end

		-- Store reference for ThemesButton linking
		if tabName == "Themes" and UBHubLib.TabReferences then
			UBHubLib.TabReferences["Themes"] = {
				TabButtonInstance = TabButton, -- The actual button instance for activation
				TabFrame = Tab,             -- The visual tab frame in the list
				Name = tabName,
				ScrollFramePage = ScrollFramePage,
				LayoutOrder = Tab.LayoutOrder
			}
		end

		return TabControls
	end

	-- Method for users to add tabs using the new instance
	function UBHubInstance:CreateUserTab(TabConfig)
		return CreateTabInternal(TabConfig)
	end

	-- Expose necessary functions on UBHubInstance
	UBHubInstance.ApplyTheme = applyTheme
	UBHubInstance.GetDefaultThemes = function() return DefaultThemes end
	UBHubInstance.GetCurrentColours = function() return Colours end
    UBHubInstance.MakeNotify = UBHubLib.MakeNotify -- Expose MakeNotify if it was meant to be public
    UBHubInstance.CircleClick = CircleClick -- Expose CircleClick if used by items
    UBHubInstance.Flags = Flags -- Expose Flags for item direct flag manipulation if necessary
    UBHubInstance.SaveFile = SaveFile -- Expose SaveFile for item direct flag manipulation if necessary
    UBHubInstance.DisplayOrderCounter = { Value = 0 } -- For dropdowns, etc.
    UBHubInstance.MoreBlurFrame = MoreBlurFrame -- For dropdowns
    UBHubInstance.DropdownSelectFrame = DropdownSelectFrame -- For dropdowns
    UBHubInstance.DropdownFolderInstance = DropdownFolderInstance -- For dropdowns
    UBHubInstance.DropPageLayoutInstance = DropPageLayoutInstance -- For dropdowns
    UBHubInstance.MoreBlurConnectButton = MoreBlurConnectButton -- For dropdowns
    UBHubInstance.CountDropdown = CountDropdown -- For dropdowns, if still needed globally

	-- The old 'localTabsObject = Tabs' is now implicitly handled by CreateTabInternal
	-- The 'Interface' and 'Themes' tabs will be created using CreateTabInternal later.

	-- Interface Tab Creation (Subtask 5, adapted)
	local mediaFolder = "UBHubAssets"
	-- Ensure mediaFolder is created only if FSO tools are available.
    if FSO.makefolder and FSO.isfile and not FSO.isfile(mediaFolder) then
        local success, err = pcall(FSO.makefolder, mediaFolder)
        if not success then warn("Failed to create mediaFolder:", err) end
    end

	local function ChangeTransparencyInternal(transparencyValue)
		if Main then Main.BackgroundTransparency = transparencyValue end
		if BackgroundImageLabel then BackgroundImageLabel.ImageTransparency = transparencyValue end
		if BackgroundVideoFrame then BackgroundVideoFrame.BackgroundTransparency = transparencyValue end
		if GuiConfig then GuiConfig.MainBackgroundTransparency = transparencyValue end
		if Flags then
			Flags.MainBackgroundTransparency = transparencyValue
			SaveFile("MainBackgroundTransparency", transparencyValue)
		end
	end

	local function ChangeAssetInternal(mediaType, urlOrPath, filename)
		if not FSO.getcustomasset then warn("ChangeAssetInternal: 'getcustomasset' not available."); return end
		local assetId
		local success, err = pcall(function()
			if urlOrPath:match("^https?://") then
				if not CurrentHttpService then error("HttpService not available.") end
				if not FSO.writefile then error("FSO.writefile not available.") end
				if FSO.makefolder and not (FSO.isfile and FSO.isfile(mediaFolder)) then FSO.makefolder(mediaFolder) end

				local data
				local httpSuccess, httpResult = pcall(CurrentHttpService.HttpGet, CurrentHttpService, urlOrPath)
				if not httpSuccess then error("HttpGet failed: " .. tostring(httpResult)) end
				data = httpResult

				local extension = mediaType == "Image" and ".png" or ".mp4"
				if not filename or filename == "" then filename = CurrentHttpService:GenerateGUID(false) end
				if not filename:match("%..+$") then filename = filename .. extension end

				local filePath = mediaFolder .. "/" .. filename
				FSO.writefile(filePath, data)
				assetId = FSO.getcustomasset(filePath)
				if Flags then
					Flags.SavedBackgroundInfo = {Type = mediaType, Path = filePath}
					SaveFile("SavedBackgroundInfo", Flags.SavedBackgroundInfo)
				end
			else
				assetId = FSO.getcustomasset(urlOrPath)
				 if Flags then
					Flags.SavedBackgroundInfo = {Type = mediaType, Path = urlOrPath}
					SaveFile("SavedBackgroundInfo", Flags.SavedBackgroundInfo)
				end
			end
		end)
		if not success or not assetId then warn("ChangeAssetInternal: Failed. Type:", mediaType, "URL/Path:", urlOrPath, "Err:", err); return end
		if mediaType == "Image" then
			if BackgroundImageLabel then BackgroundImageLabel.Image = assetId end
			if BackgroundVideoFrame then BackgroundVideoFrame.Video = "" end
			_G.BGImage = assetId ~= "" and assetId ~= nil
			_G.BGVideo = false
		elseif mediaType == "Video" then
			if BackgroundVideoFrame then BackgroundVideoFrame.Video = assetId end
			if BackgroundImageLabel then BackgroundImageLabel.Image = "" end
			_G.BGVideo = assetId ~= "" and assetId ~= nil
			_G.BGImage = false
			if BackgroundVideoFrame then BackgroundVideoFrame.Playing = _G.BGVideo end
		end
	end

	local function ResetBackgroundInternal()
		if BackgroundImageLabel then BackgroundImageLabel.Image = "" end
		if BackgroundVideoFrame then BackgroundVideoFrame.Video = "" end
		_G.BGImage = false; _G.BGVideo = false
		if Flags then
			Flags.SavedBackgroundInfo = nil
			SaveFile("SavedBackgroundInfo", nil)
		end
	end

	if Flags.SavedBackgroundInfo and Flags.SavedBackgroundInfo.Path and Flags.SavedBackgroundInfo.Type then
		if FSO.isfile and FSO.isfile(Flags.SavedBackgroundInfo.Path) then
			 ChangeAssetInternal(Flags.SavedBackgroundInfo.Type, Flags.SavedBackgroundInfo.Path, nil)
		else
			 if FSO.isfile then warn("Saved background file not found:", Flags.SavedBackgroundInfo.Path) end
			 Flags.SavedBackgroundInfo = nil
			 SaveFile("SavedBackgroundInfo", nil)
		end
	end
	if Flags.MainBackgroundTransparency ~= nil then
		ChangeTransparencyInternal(Flags.MainBackgroundTransparency)
	elseif GuiConfig.MainBackgroundTransparency == nil then -- Only set default if not already set by flags or initial config
        ChangeTransparencyInternal(0.1)
        if GuiConfig then GuiConfig.MainBackgroundTransparency = 0.1 end
    end

	-- ==== BUILT-IN TAB CREATION ====
	-- Create "Interface" Tab using the new internal structure
	local InterfaceTabControls = CreateTabInternal({ Name = "Interface", Icon = "lucide:sliders-horizontal" })
	if InterfaceTabControls then
		local BGSettingsSection = InterfaceTabControls:AddSectionInternal("Background Settings")
		if BGSettingsSection then
			BGSettingsSection:AddSlider({ -- Assuming AddSlider will be mapped to AddItemInternal
				Title = "UI Transparency", Content = "Adjust overall UI transparency.",
				Min = 0, Max = 1, Increment = 0.01,
				Default = Flags.MainBackgroundTransparency or 0.1,
				Flag = "MainUITransparencySlider",
				Callback = function(value) ChangeTransparencyInternal(value) end
			})
		end

		local CustomBGSection = InterfaceTabControls:AddSectionInternal("Custom Background")
		if CustomBGSection then
			local DownloaderSubSection = CustomBGSection:AddSection("[+] Background Downloader") -- Test sub-sectioning
			if DownloaderSubSection then
				local selectedMediaType = "Image"
				DownloaderSubSection:AddDropdown({
					Title = "Select Media Type", Options = {"Image", "Video"}, Default = selectedMediaType,
					Callback = function(val) selectedMediaType = type(val) == "table" and val[1] or val end
				})
				local bgUrlInput = DownloaderSubSection:AddInput({ Title = "Background URL", Default = "" })
				local bgFilenameInput = DownloaderSubSection:AddInput({ Title = "Filename (Optional)", Content = "Name to save as. Auto-generates if empty.", Default = "" })
				DownloaderSubSection:AddButton({ Title = "Load Web Background", Icon = "lucide:download-cloud", Callback = function()
					if bgUrlInput and bgUrlInput.Value ~= "" then ChangeAssetInternal(selectedMediaType, bgUrlInput.Value, bgFilenameInput.Value) end
				end })
			end

			local LocalFilesSubSection = CustomBGSection:AddSection("[-] Local Backgrounds")
			if LocalFilesSubSection then
				local localFilesDropdown = LocalFilesSubSection:AddDropdown({ Title = "Select Local File", Options = {"(Refresh to see files)"}, Default = "(Refresh to see files)", InternalFlag = "LocalFilesDropdown"})
				local selectedLocalFile = ""
				-- Note: Dropdown value is now typically obtained via its API, e.g., localFilesDropdown.Value()
				LocalFilesSubSection:AddButton({ Title = "Refresh Local Files", Icon = "lucide:refresh-cw", Callback = function()
					if FSO.makefolder and FSO.listfiles and FSO.isfile then
						if FSO.isfile and FSO.makefolder and not FSO.isfile(mediaFolder) then
                            local suc,er = pcall(FSO.makefolder, mediaFolder)
                            if not suc then warn("Refresh: makefolder failed", er) end
                        end
						local files = {}
                        local sucList, listRes = pcall(FSO.listfiles, mediaFolder)
                        if sucList then files = listRes else warn("Refresh: listfiles failed", listRes) end

						local allFilesToDisplay = {}
						for _, fileFullName in ipairs(files) do
							if fileFullName:match("%.png$") or fileFullName:match("%.jpg$") or fileFullName:match("%.jpeg$") or fileFullName:match("%.gif$") or fileFullName:match("%.mp4$") or fileFullName:match("%.webm$") then
								table.insert(allFilesToDisplay, mediaFolder .. "/" .. fileFullName)
							end
						end
						if #allFilesToDisplay == 0 then table.insert(allFilesToDisplay, "(No files found)") end

                        local lfdAPI = AllCreatedItemControls["LocalFilesDropdown"] -- Get API from stored controls
						if lfdAPI and lfdAPI.Refresh then
							lfdAPI:Refresh(allFilesToDisplay, allFilesToDisplay[1] or "(No files found)")
							-- selectedLocalFile will be updated by the dropdown's own callback/value mechanism
						else warn("localFilesDropdown or its Refresh method not found.") end
					else warn("Refresh Local Files: 'listfiles', 'makefolder' or 'isfile' not available.") end
				end})
				LocalFilesSubSection:AddButton({ Title = "Load Selected Local File", Icon = "lucide:folder-up", Callback = function()
                    local lfdAPI = AllCreatedItemControls["LocalFilesDropdown"]
                    if lfdAPI then selectedLocalFile = lfdAPI.Value() end -- Get current value from API

					if selectedLocalFile and selectedLocalFile ~= "" and selectedLocalFile ~= "(No files found)" and selectedLocalFile ~= "(Refresh to see files)" then
						if FSO.getcustomasset then
							local mediaTypeForLocal = (selectedLocalFile:match("%.mp4$") or selectedLocalFile:match("%.webm$")) and "Video" or "Image"
							ChangeAssetInternal(mediaTypeForLocal, selectedLocalFile, nil)
						else warn("Load Selected Local File: 'getcustomasset' not available.") end
					else warn("No valid local file selected.") end
				end})
			end
			CustomBGSection:AddButton({ Title = "Reset Background", Icon = "lucide:rotate-ccw", Callback = function() ResetBackgroundInternal() end })
		end
	end

	-- Create "Themes" Tab
	local ThemesTabControls = CreateTabInternal({Name = "Themes", Icon = "lucide:palette"})
	if ThemesTabControls then
		local PresetsSection = ThemesTabControls:AddSectionInternal("Theme Presets")
		if PresetsSection then
			for themeName, _ in pairs(DefaultThemes) do
				PresetsSection:AddButton({
					Title = themeName,
                    Icon = "lucide:brush",
					Callback = function()
						if UBHubInstance.ApplyTheme then UBHubInstance.ApplyTheme(themeName, false) end
					end
				})
			end
		end
		local CustomizeSection = ThemesTabControls:AddSectionInternal("Customize Colors")
		if CustomizeSection then
			-- Define an order for color keys to appear in UI if desired
			local orderedColorKeys = {
				"Background", "Topbar", "TabBackground", "TabBackgroundSelected", "ElementBackground", "SecondaryElementBackground",
				"InputBackground", "DropdownUnselected", "DropdownSelected", "SliderBackground",
				"TextColor", "SelectedTabTextColor", "TabTextColor", "PlaceholderColor",
				"Stroke", "SecondaryElementStroke", "ElementStroke", "SliderStroke",
				"ToggleEnabled", "ToggleDisabled", "ToggleEnabledStroke", "ToggleDisabledStroke",
				"ToggleEnabledOuterStroke", "ToggleDisabledOuterStroke",
				"Primary", "Secondary", "Accent", "ThemeHighlight", "SliderProgress", "Shadow", "GuiConfigColor",
				"NotificationBackground", "NotificationActionsBackground"
			}
			local tempColourHolder = deepcopy(Colours) -- Use a consistent snapshot for creating sliders

			for _, colorKey in ipairs(orderedColorKeys) do
				if tempColourHolder[colorKey] and type(tempColourHolder[colorKey]) == "Color3" then
					local colorDisplayName = colorKey:gsub("([a-z])([A-Z])", "%1 %2") -- Add space before capital letters

					local ColorSubSection = CustomizeSection:AddSection(colorDisplayName) -- Create a sub-section for each color
					if ColorSubSection then
						local originalColor = tempColourHolder[colorKey]
						local r, g, b = math.floor(originalColor.R * 255 + 0.5), math.floor(originalColor.G * 255 + 0.5), math.floor(originalColor.B * 255 + 0.5)

						local function updateCustomColor()
							local newR = AllCreatedItemControls.Sliders[colorKey].R.Value
							local newG = AllCreatedItemControls.Sliders[colorKey].G.Value
							local newB = AllCreatedItemControls.Sliders[colorKey].B.Value
							Colours[colorKey] = Color3.fromRGB(newR, newG, newB)
							if UBHubInstance.ApplyTheme then UBHubInstance.ApplyTheme(Colours, false) end -- Apply the direct table of colours
						end

						AllCreatedItemControls.Sliders[colorKey] = AllCreatedItemControls.Sliders[colorKey] or {}
						AllCreatedItemControls.Sliders[colorKey].R = ColorSubSection:AddSlider({ Title = "Red", Min = 0, Max = 255, Default = r, Increment = 1, Callback = updateCustomColor })
						AllCreatedItemControls.Sliders[colorKey].G = ColorSubSection:AddSlider({ Title = "Green", Min = 0, Max = 255, Default = g, Increment = 1, Callback = updateCustomColor })
						AllCreatedItemControls.Sliders[colorKey].B = ColorSubSection:AddSlider({ Title = "Blue", Min = 0, Max = 255, Default = b, Increment = 1, Callback = updateCustomColor })
					end
				end
			end
		end
	end
	-- End of Built-in Tab Creation

	if Flags.MainBackgroundTransparency ~= nil then
		ChangeTransparencyInternal(Flags.MainBackgroundTransparency)
	end

	-- Create built-in tabs after all base UI is defined and CreateTabInternal is ready
	-- local ThemesTabControls = CreateTabInternal({ Name = "Themes", Icon = GetIcon("lucide:palette") })
	-- -- Populate ThemesTabControls with sections and items

	-- local InterfaceTabControls = CreateTabInternal({ Name = "Interface", Icon = GetIcon("lucide:sliders-horizontal") })
	-- -- Populate InterfaceTabControls (code for this is currently below, needs to be moved/adapted)


	-- Ensure the "ThemesButton" in Info section can trigger the "Themes" tab.
						local files = {}
                        local sucList, listRes = pcall(FSO.listfiles, mediaFolder)
                        if sucList then files = listRes else warn("Refresh: listfiles failed", listRes) end

						local allFilesToDisplay = {}
						for _, fileFullName in ipairs(files) do
							if fileFullName:match("%.png$") or fileFullName:match("%.jpg$") or fileFullName:match("%.jpeg$") or fileFullName:match("%.gif$") or fileFullName:match("%.mp4$") or fileFullName:match("%.webm$") then
								table.insert(allFilesToDisplay, mediaFolder .. "/" .. fileFullName)
							end
						end
						if #allFilesToDisplay == 0 then table.insert(allFilesToDisplay, "(No files found)") end
						if localFilesDropdown and localFilesDropdown.Refresh then
							localFilesDropdown:Refresh(allFilesToDisplay, allFilesToDisplay[1] or "(No files found)")
							if type(allFilesToDisplay[1]) == "string" then selectedLocalFile = allFilesToDisplay[1] else selectedLocalFile = "" end
						else warn("localFilesDropdown or its Refresh method not found.") end
					else warn("Refresh Local Files: 'listfiles', 'makefolder' or 'isfile' not available.") end
				end})
				LocalFilesSubSection:AddButton({ Title = "Load Selected Local File", Icon = "", Callback = function()
					if selectedLocalFile and selectedLocalFile ~= "" and selectedLocalFile ~= "(No files found)" and selectedLocalFile ~= "(Refresh to see files)" then
						if FSO.getcustomasset then
							local mediaTypeForLocal = (selectedLocalFile:match("%.mp4$") or selectedLocalFile:match("%.webm$")) and "Video" or "Image"
							ChangeAssetInternal(mediaTypeForLocal, selectedLocalFile, nil)
						else warn("Load Selected Local File: 'getcustomasset' not available.") end
					else warn("No valid local file selected.") end
				end})
			end
			CustomBGSection:AddButton({ Title = "Reset Background", Icon = "lucide:rotate-ccw", Callback = function() ResetBackgroundInternal() end })
		end
	end

	-- Create "Themes" Tab
	local ThemesTabControls = CreateTabInternal({Name = "Themes", Icon = "lucide:palette"})
	if ThemesTabControls then
		local PresetsSection = ThemesTabControls:AddSectionInternal("Theme Presets")
		if PresetsSection then
			for themeName, _ in pairs(DefaultThemes) do
				PresetsSection:AddButton({
					Title = themeName,
                    Icon = "lucide:brush",
					Callback = function()
						if UBHubInstance.ApplyTheme then UBHubInstance.ApplyTheme(themeName, false) end
					end
				})
			end
			if #allFilesToDisplay == 0 then table.insert(allFilesToDisplay, "(No files found)") end
			if localFilesDropdown and localFilesDropdown.Refresh then
				localFilesDropdown:Refresh(allFilesToDisplay, allFilesToDisplay[1] or "(No files found)")
				if type(allFilesToDisplay[1]) == "string" then selectedLocalFile = allFilesToDisplay[1] else selectedLocalFile = "" end
			else warn("localFilesDropdown or its Refresh method not found.") end
		else warn("Refresh Local Files: 'listfiles', 'makefolder' or 'isfile' not available.") end
	end})
	LocalFilesSubSection:AddButton({ Title = "Load Selected Local File", Icon = "", Callback = function() -- Icon "folder-up" removed
		if selectedLocalFile and selectedLocalFile ~= "" and selectedLocalFile ~= "(No files found)" and selectedLocalFile ~= "(Refresh to see files)" then
			if FSO.getcustomasset then
				local mediaTypeForLocal = (selectedLocalFile:match("%.mp4$") or selectedLocalFile:match("%.webm$")) and "Video" or "Image"
				ChangeAssetInternal(mediaTypeForLocal, selectedLocalFile, nil)
			else warn("Load Selected Local File: 'getcustomasset' not available.") end
		else warn("No valid local file selected.") end
	end})
	CustomBGSection:AddButton({ Title = "Reset Background", Icon = "", Callback = function() ResetBackgroundInternal() end }) -- Icon "rotate-ccw" removed

	if Flags.MainBackgroundTransparency ~= nil then
		ChangeTransparencyInternal(Flags.MainBackgroundTransparency)
	end

	-- Create built-in tabs after all base UI is defined and CreateTabInternal is ready
	-- local ThemesTabControls = CreateTabInternal({ Name = "Themes", Icon = GetIcon("lucide:palette") })
	-- -- Populate ThemesTabControls with sections and items

	-- local InterfaceTabControls = CreateTabInternal({ Name = "Interface", Icon = GetIcon("lucide:sliders-horizontal") })
	-- -- Populate InterfaceTabControls (code for this is currently below, needs to be moved/adapted)


	-- Ensure the "ThemesButton" in Info section can trigger the "Themes" tab.
	-- This connection logic might need adjustment based on how TabButton.Activated is structured in CreateTabInternal
	if ThemesButton and UBHubLib.TabReferences and UBHubLib.TabReferences["Themes"] and UBHubLib.TabReferences["Themes"].TabButtonInstance then
		ThemesButton.Activated:Connect(function()
			local themesTabRef = UBHubLib.TabReferences["Themes"]
			if themesTabRef and themesTabRef.TabButtonInstance and themesTabRef.TabButtonInstance.Activated then
				-- Fire the "Activated" event on the actual TabButton instance for the "Themes" tab.
				-- This centralizes the tab switching logic within CreateTabInternal.
				-- The CircleClick is already handled within the TabButton's own Activated event.
				themesTabRef.TabButtonInstance.Activated:Fire()
			else
				warn("ThemesButton: Could not switch to Themes tab. Tab reference or its 'Activated' event not found.")
			end
		end)
	end


	return UBHubInstance -- Return the new instance
end

return UBHubLib
