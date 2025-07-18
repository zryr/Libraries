local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()
local Colours

Colours = {
	Primary = Color3.fromRGB(160, 40, 0),
	Secondary = Color3.fromRGB(160, 30, 0),      
	Accent = Color3.fromRGB(200, 50, 0),         
	ThemeHighlight = Color3.fromRGB(255, 80, 0), -- Bright orange accent
	Text = Color3.fromRGB(255, 240, 230),        
	Background = Color3.fromRGB(20, 8, 0),      
	Stroke = Color3.fromRGB(80, 20, 0),          
}


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
			NotifyLayout.BackgroundColor3 = Colours.Primary
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

		NotifyFrameReal.BackgroundColor3 = Colours.Primary
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

		Top.BackgroundColor3 = Colours.Primary
		Top.BackgroundTransparency = 0.9990000128746033
		Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Top.BorderSizePixel = 0
		Top.Size = UDim2.new(1, 0, 0, 36)
		Top.Name = "Top"
		Top.Parent = NotifyFrameReal

		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = NotifyConfig.Title
		TextLabel.TextColor3 = Colours.Text
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
		UICorner1_Notify.CornerRadius = UDim.new(0, 5)

		TextLabel1.Font = Enum.Font.GothamBold
		TextLabel1.Text = NotifyConfig.Description
		TextLabel1.TextColor3 = Colours.Text
		TextLabel1.TextSize = 14
		TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel1.BackgroundColor3 = Colours.ThemeHighlight
		TextLabel1.BackgroundTransparency = 0.9990000128746033
		TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel1.BorderSizePixel = 0
		TextLabel1.Size = UDim2.new(1, 0, 1, 0)
		TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
		TextLabel1.Parent = Top

		UIStroke1_Notify.Color = NotifyConfig.Color
		UIStroke1_Notify.Thickness = 0.4000000059604645
		UIStroke1_Notify.Parent = TextLabel1

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

		ImageLabel.Image = "rbxassetid://9886659671"
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
	local Flags = UBHubLib and UBHubLib.Flags or {}
	local function SaveFile(Name, Value)
		if not (writefile and GuiConfig and GuiConfig.SaveFolder) then
			return false
		end
		local valueToSave = Value
		if type(Value) == "table" and not (Value[1] and not next(Value)) then 
			valueToSave = nil 
		elseif type(Value) == "table" and #Value == 1 and not GuiConfig.Multi then 
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
	Main.BackgroundColor3 = Colours.Background
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
    UICorner.CornerRadius = UDim.new(0, 8) 

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
	TextLabel.TextColor3 = Colours.Accent
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.BackgroundColor3 = Colours.Accent 
	TextLabel.BackgroundTransparency = 1 
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, -100, 1, 0)
	TextLabel.Position = UDim2.new(0, 10, 0, 0)
	TextLabel.Parent = Top

	UICorner1.Parent = Top
    UICorner1.CornerRadius = UDim.new(0,5) 

	TextLabel1.Font = Enum.Font.GothamBold
	TextLabel1.Text = GuiConfig.Description
	TextLabel1.TextColor3 = Colours.Text
	TextLabel1.TextSize = 14
	TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel1.BackgroundColor3 = Colours.Accent 
	TextLabel1.BackgroundTransparency = 1 
	TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel1.BorderSizePixel = 0
	TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0)
	TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
	TextLabel1.Parent = Top

	UIStroke1.Color = GuiConfig.Color
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

	ImageLabel1.Image = "rbxassetid://9886659671"
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
	LayersTab.Position = UDim2.new(0, 9, 0, 50)
	LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -59)
	LayersTab.Name = "LayersTab"
	LayersTab.Parent = Main

	UICorner2.CornerRadius = UDim.new(0, 2)
	UICorner2.Parent = LayersTab

	DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
	DecideFrame.BackgroundColor3 = Colours.Stroke 
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
	Info.Size = UDim2.new(1, 0, 0, 40)
	Info.Name = "Info"
	Info.Parent = LayersTab

	InfoUICorner.CornerRadius = UDim.new(0, 5)
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

	NamePlayer.Font = Enum.Font.GothamBold
	NamePlayer.Text = GuiConfig["Name Player"]
	NamePlayer.TextColor3 = Color3.fromRGB(230.00000149011612, 230.00000149011612, 230.00000149011612)
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
    MinimizedIcon.BackgroundColor3 = Colours.ThemeHighlight 
	MinimizedIcon.Parent = ScreenGui
	MinimizedIcon.Draggable = true
	MinimizedIcon.Visible = false
	MinimizedIcon.BorderColor3 = Colours.ThemeHighlight
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
    UICorner28.CornerRadius = UDim.new(0,8) 

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
	DropdownSelect.BackgroundColor3 = Colours.Primary
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
	function Tabs:CreateTab(TabConfig)
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
			ChooseFrame.BackgroundColor3 = Colours.ThemeHighlight
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
				for _, TabFrame in ipairs(ScrollTab:GetChildren()) do
					if TabFrame.Name == "Tab" then
						TweenService:Create(TabFrame,TweenInfo.new(0.001, Enum.EasingStyle.Linear),{BackgroundTransparency = 0.9990000128746033}):Play()
					end    
				end
				TweenService:Create(Tab, TweenInfo.new(0.001, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.92}):Play()
				TweenService:Create(FrameChoose,TweenInfo.new(0.01, Enum.EasingStyle.Linear),{Position = UDim2.new(0, 2, 0, 9 + (33 * Tab.LayoutOrder))}):Play()
				LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
				NameTab.Text = TabConfig.Name
				TweenService:Create(FrameChoose,TweenInfo.new(0.01, Enum.EasingStyle.Linear),{Size = UDim2.new(0, 1, 0, 20)}):Play()
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

			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.Text = Title
			SectionTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
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
            UICorner1_Section.CornerRadius = UDim.new(0,2) 

			UIGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Colours.Primary),
				ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
				ColorSequenceKeypoint.new(1, Colours.Primary)
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
                local lineColor = DividerConfig.Color or Colours.Accent
                local textColor = DividerConfig.TextColor or Colours.Text
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

				Paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Paragraph.BackgroundTransparency = 0.9350000023841858
				Paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Paragraph.BorderSizePixel = 0
				Paragraph.LayoutOrder = CountItem
				Paragraph.Size = UDim2.new(1, 0, 0, 46) 
				Paragraph.Name = "Paragraph"
				Paragraph.Parent = SectionAdd

				UICorner14.CornerRadius = UDim.new(0, 4)
				UICorner14.Parent = Paragraph

				ParagraphTitle.Font = Enum.Font.GothamBold
				ParagraphTitle.Text = ParagraphConfig.Title .. " | " .. ParagraphConfig.Content
				ParagraphTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
				ParagraphTitle.TextSize = 13
                ParagraphTitle.TextWrapped = true
				ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
				ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
				ParagraphTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ParagraphTitle.BackgroundTransparency = 0.9990000128746033
				ParagraphTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
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
				local FeatureImg3 = Instance.new("ImageLabel");

				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.BackgroundTransparency = 0.9350000023841858
				Button.BorderColor3 = Colours.Secondary
				Button.BorderSizePixel = 0
				Button.LayoutOrder = CountItem
				Button.Size = UDim2.new(1, 0, 0, 46)
				Button.Name = "Button"
				Button.Parent = SectionAdd

				UICorner9.CornerRadius = UDim.new(0, 4)
				UICorner9.Parent = Button

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
				ButtonTitle.Parent = Button

				ButtonContent.Font = Enum.Font.GothamBold
				ButtonContent.Text = ButtonConfig.Content
				ButtonContent.TextColor3 = Color3.fromRGB(255, 255, 255)
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

				FeatureImg3.Image = ButtonConfig.Icon
				FeatureImg3.AnchorPoint = Vector2.new(0.5, 0.5)
				FeatureImg3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				FeatureImg3.BackgroundTransparency = 0.9990000128746033
				FeatureImg3.BorderColor3 = Color3.fromRGB(0, 0, 0)
				FeatureImg3.BorderSizePixel = 0
				FeatureImg3.Position = UDim2.new(0.5, 0, 0.5, 0)
				FeatureImg3.Size = UDim2.new(1, 0, 1, 0)
				FeatureImg3.Name = "FeatureImg"
				FeatureImg3.Parent = FeatureFrame1

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

				Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.BackgroundTransparency = 0.9350000023841858
				Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
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
				ToggleTitle.Parent = Toggle

				ToggleContent.Font = Enum.Font.GothamBold
				ToggleContent.Text = ToggleConfig.Content
				ToggleContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				ToggleContent.TextSize = 12
				ToggleContent.TextTransparency = 0.6000000238418579
				ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
				ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom
                ToggleContent.TextWrapped = true
				ToggleContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleContent.BackgroundTransparency = 0.9990000128746033
				ToggleContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
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
				ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.TextSize = 14
				ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.BackgroundTransparency = 0.9990000128746033
				ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.BorderSizePixel = 0
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Name = "ToggleButton"
				ToggleButton.Parent = Toggle

				FeatureFrame2.AnchorPoint = Vector2.new(1, 0.5)
				FeatureFrame2.BackgroundColor3 = Colours.Secondary
				FeatureFrame2.BackgroundTransparency = 0.9200000166893005
				FeatureFrame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
				FeatureFrame2.BorderSizePixel = 0
				FeatureFrame2.Position = UDim2.new(1, -30, 0.5, 0)
				FeatureFrame2.Size = UDim2.new(0, 30, 0, 15)
				FeatureFrame2.Name = "FeatureFrame"
				FeatureFrame2.Parent = Toggle

				UICorner22.Parent = FeatureFrame2
                UICorner22.CornerRadius = UDim.new(0,8) 

				UIStroke8.Color = Color3.fromRGB(255, 255, 255)
				UIStroke8.Thickness = 2
				UIStroke8.Transparency = 0.9
				UIStroke8.Parent = FeatureFrame2

				ToggleCircle.BackgroundColor3 = Color3.fromRGB(230.00000149011612, 230.00000149011612, 230.00000149011612)
				ToggleCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
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
						TweenService:Create(ToggleTitle, tweenInfo, {TextColor3 = GuiConfig.Color}):Play()
						TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(1, -ToggleCircle.AbsoluteSize.X - 0.5, 0.5, 0)}):Play()
						TweenService:Create(UIStroke8, tweenInfo, {Color = GuiConfig.Color, Transparency = 0}):Play()
						TweenService:Create(FeatureFrame2, tweenInfo, {BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0}):Play()
					else
						TweenService:Create(ToggleTitle, tweenInfo, {TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)}):Play()
						TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(0, 0.5, 0.5, 0)}):Play()
						TweenService:Create(UIStroke8, tweenInfo, {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9}):Play()
						TweenService:Create(FeatureFrame2, tweenInfo, {BackgroundColor3 = Colours.Secondary, BackgroundTransparency = 0.9200000166893005}):Play()
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

				Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Slider.BackgroundTransparency = 0.9350000023841858
				Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Slider.BorderSizePixel = 0
				Slider.LayoutOrder = CountItem
				Slider.Size = UDim2.new(1, 0, 0, 46)
				Slider.Name = "Slider"
				Slider.Parent = SectionAdd

				UICorner15.CornerRadius = UDim.new(0, 4)
				UICorner15.Parent = Slider

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
				SliderTitle.Parent = Slider

				SliderContent.Font = Enum.Font.GothamBold
				SliderContent.Text = SliderConfig.Content
				SliderContent.TextColor3 = Color3.fromRGB(255, 255, 255)
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
				SliderInput.BackgroundColor3 = Colours.Accent
				SliderInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderInput.BorderSizePixel = 0
				SliderInput.Position = UDim2.new(1, -155, 0.5, 0)
				SliderInput.Size = UDim2.new(0, 28, 0, 20)
				SliderInput.Name = "SliderInput"
				SliderInput.Parent = Slider

				UICorner16.CornerRadius = UDim.new(0, 2)
				UICorner16.Parent = SliderInput

				TextBox.Font = Enum.Font.GothamBold
				TextBox.Text = tostring(SliderConfig.Default)
				TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                UICorner17.CornerRadius = UDim.new(0,3) 

				SliderDraggable.AnchorPoint = Vector2.new(0, 0.5)
				SliderDraggable.BackgroundColor3 = Colours.Accent
				SliderDraggable.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderDraggable.BorderSizePixel = 0
				SliderDraggable.Position = UDim2.new(0, 0, 0.5, 0)
				SliderDraggable.Size = UDim2.new(0.899999976, 0, 1, 0) 
				SliderDraggable.Name = "SliderDraggable"
				SliderDraggable.Parent = SliderFrame

				UICorner18.Parent = SliderDraggable
                UICorner18.CornerRadius = UDim.new(0,3) 

				SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
				SliderCircle.BackgroundColor3 = Colours.ThemeHighlight
				SliderCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderCircle.BorderSizePixel = 0
				SliderCircle.Position = UDim2.new(1, 4, 0.5, 0)
				SliderCircle.Size = UDim2.new(0, 8, 0, 8)
				SliderCircle.Name = "SliderCircle"
				SliderCircle.Parent = SliderDraggable

				UICorner19.Parent = SliderCircle
                UICorner19.CornerRadius = UDim.new(0,8) 

				UIStroke6.Color = GuiConfig.Color
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

				Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Input.BackgroundTransparency = 0.9350000023841858
				Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Input.BorderSizePixel = 0
				Input.LayoutOrder = CountItem
				Input.Size = UDim2.new(1, 0, 0, 46)
				Input.Name = "Input"
				Input.Parent = SectionAdd

				UICorner12.CornerRadius = UDim.new(0, 4)
				UICorner12.Parent = Input

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
				InputTitle.Parent = Input

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

				UICorner13.CornerRadius = UDim.new(0, 4)
				UICorner13.Parent = InputFrame

				InputTextBox.CursorPosition = -1
				InputTextBox.Font = Enum.Font.GothamBold
				InputTextBox.PlaceholderColor3 = Color3.fromRGB(120.00000044703484, 120.00000044703484, 120.00000044703484)
				InputTextBox.PlaceholderText = "Write your input there"
				InputTextBox.Text = tostring(InputFunc.Value)
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

				Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Dropdown.BackgroundTransparency = 0.9350000023841858
				Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Dropdown.BorderSizePixel = 0
				Dropdown.LayoutOrder = CountItem
				Dropdown.Size = UDim2.new(1, 0, 0, 46)
				Dropdown.Name = "Dropdown"
				Dropdown.Parent = SectionAdd

				DropdownButton.Font = Enum.Font.SourceSans
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

				UICorner10.CornerRadius = UDim.new(0, 4)
				UICorner10.Parent = Dropdown

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
				DropdownTitle.Parent = Dropdown

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
				SearchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 150) 
				SearchBar.Text = ""
				SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
				SearchBar.TextSize = 12
				SearchBar.BackgroundColor3 = Colours.Secondary 
				SearchBar.BackgroundTransparency = 0.5
				SearchBar.BorderColor3 = Colours.Stroke
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
					
					Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Option.BackgroundTransparency = 0.999
					Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
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
					OptionText.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
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
					ChooseFrame.BackgroundColor3 = Colours.ThemeHighlight
					ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ChooseFrame.BorderSizePixel = 0
					ChooseFrame.Position = UDim2.new(0, 2, 0.5, 0)
					ChooseFrame.Size = UDim2.new(0, 0, 0, 0)
					ChooseFrame.Name = "ChooseFrame"
					ChooseFrame.Parent = Option
				
					UIStroke15.Color = GuiConfig.Color
					UIStroke15.Thickness = 1.600000023841858
					UIStroke15.Transparency = 0.999
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
							local Size = isSelected and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0)
							local BackgroundTransparency = isSelected and 0.935 or 0.999
							local StrokeTransparency = isSelected and 0 or 0.999
							TweenService:Create(Drop.ChooseFrame, tweenInfoInOut, {Size = Size}):Play()
							TweenService:Create(Drop.ChooseFrame.UIStroke, tweenInfoInOut, {Transparency = StrokeTransparency}):Play()
							TweenService:Create(Drop, tweenInfoInOut, {BackgroundTransparency = BackgroundTransparency}):Play()

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
		return Sections
	end
	return Tabs
end
return UBHubLib
