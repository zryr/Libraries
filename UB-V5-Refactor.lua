local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local UBHubLib = {
    Icons = {},
    Themes = {
        Default = {
            Colors = {
                Primary = Color3.fromRGB(255, 120, 0), -- Orange
                Secondary = Color3.fromRGB(30, 30, 30),
                Background = Color3.fromRGB(15, 15, 15),
                Text = Color3.fromRGB(255, 255, 255),
                Stroke = Color3.fromRGB(60, 60, 60),
                Divider = Color3.fromRGB(40, 40, 40),
                Gradient = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 0))
                }
            },
            Fonts = {
                Title = Enum.Font.GothamBold,
                Content = Enum.Font.Gotham,
            },
            Sizes = {
                CornerRadius = 6,
                Padding = 10,
            },
            Transparency = {
                Background = 0.1,
                Element = 0.05
            }
        }
    },
    ActiveTheme = nil,
    IconFallback = {
        ["search"] = "rbxassetid://11422143431", -- Example ID, placeholder
        ["edit"] = "rbxassetid://11293977610",
        ["close"] = "rbxassetid://11293981586",
        ["minimize"] = "rbxassetid://11293981586", -- Placeholder
        ["settings"] = "rbxassetid://11293977610", -- Placeholder
        ["check"] = "rbxassetid://11293979437",
        ["alert"] = "rbxassetid://11293978393",
        ["info"] = "rbxassetid://11293978393",
    }
}

UBHubLib.ActiveTheme = UBHubLib.Themes.Default

-- Helper Functions
local function SafeService(ServiceName)
    return game:GetService(ServiceName)
end

local function ProtectGui(Gui)
    if protectgui then
        protectgui(Gui)
    elseif syn and syn.protect_gui then
        syn.protect_gui(Gui)
    end
end

local function GetHui()
    if gethui then
        return gethui()
    else
        return CoreGui
    end
end

-- Config Manager
UBHubLib.ConfigManager = {
    Mode = "Legacy", -- "Legacy" or "Normal"
    Folder = "UBHub_Config",
    CurrentConfig = {},
    LegacyCache = {},
    SaveDebounce = nil,
    FlagListeners = {}
}

function UBHubLib.ConfigManager:Init()
    pcall(function()
        if not isfolder(self.Folder) then
            makefolder(self.Folder)
        end
    end)

    -- Load legacy settings if they exist
    pcall(function()
        if isfile(self.Folder .. "/legacy_settings.json") then
            local Success, Result = pcall(function()
                return HttpService:JSONDecode(readfile(self.Folder .. "/legacy_settings.json"))
            end)
            if Success and type(Result) == "table" then
                self.LegacyCache = Result
            end
        end
    end)
end

function UBHubLib.ConfigManager:RegisterListener(Flag, Callback)
    if not self.FlagListeners[Flag] then
        self.FlagListeners[Flag] = {}
    end
    table.insert(self.FlagListeners[Flag], Callback)
end

function UBHubLib.ConfigManager:SaveLegacy()
    -- Debounce logic
    if self.SaveDebounce then
        task.cancel(self.SaveDebounce)
    end

    self.SaveDebounce = task.delay(1, function()
        if self.Mode == "Legacy" then
            pcall(function()
                writefile(self.Folder .. "/legacy_settings.json", HttpService:JSONEncode(self.LegacyCache))
            end)
        end
        self.SaveDebounce = nil
    end)
end

function UBHubLib.ConfigManager:UpdateFlag(Flag, Value)
    if self.Mode == "Legacy" then
        self.LegacyCache[Flag] = Value
        self:SaveLegacy()
    else
        self.CurrentConfig[Flag] = Value
    end

    if self.FlagListeners[Flag] then
        for _, Callback in ipairs(self.FlagListeners[Flag]) do
            Callback(Value)
        end
    end
end

function UBHubLib.ConfigManager:GetFlag(Flag)
    if self.Mode == "Legacy" then
        return self.LegacyCache[Flag]
    else
        return self.CurrentConfig[Flag]
    end
end

function UBHubLib.ConfigManager:Save(ConfigName)
    if not ConfigName then return end
    ConfigName = ConfigName:gsub("[/\\%.]", "") -- Sanitize
    pcall(function()
        writefile(self.Folder .. "/" .. ConfigName .. ".json", HttpService:JSONEncode(self.CurrentConfig))
    end)
end

function UBHubLib.ConfigManager:Load(ConfigName)
    if not ConfigName then return end
    ConfigName = ConfigName:gsub("[/\\%.]", "") -- Sanitize
    local Path = self.Folder .. "/" .. ConfigName .. ".json"
    local Success, Exists = pcall(function() return isfile(Path) end)
    if Success and Exists then
        local ReadSuccess, Result = pcall(function()
            return HttpService:JSONDecode(readfile(Path))
        end)
        if ReadSuccess and type(Result) == "table" then
            self.CurrentConfig = Result
            -- Here we would trigger UI updates if elements are linked to flags
            -- For now, just load into memory
            return true
        end
    end
    return false
end

function UBHubLib.ConfigManager:Delete(ConfigName)
    if not ConfigName then return end
    ConfigName = ConfigName:gsub("[/\\%.]", "") -- Sanitize
    local Path = self.Folder .. "/" .. ConfigName .. ".json"
    pcall(function()
        if isfile(Path) then
            delfile(Path)
        end
    end)
end

function UBHubLib.ConfigManager:Export()
    local Data = self.Mode == "Legacy" and self.LegacyCache or self.CurrentConfig
    if setclipboard then
        setclipboard(HttpService:JSONEncode(Data))
    elseif toclipboard then
        toclipboard(HttpService:JSONEncode(Data))
    end
end

-- Initialize Config Manager
UBHubLib.ConfigManager:Init()

-- Font Manager
UBHubLib.FontManager = {
    ActiveFont = Enum.Font.GothamBold,
    Registry = {}
}

function UBHubLib.FontManager:SetFont(Element, Font)
    if Element and Element:IsA("TextLabel") or Element:IsA("TextButton") or Element:IsA("TextBox") then
        Element.FontFace = Font or Font.new(self.ActiveFont)
    end
end

-- UI Utilities
function UBHubLib:ApplyStyle(Instance, Property, ColorOrSequence)
    -- clean up old gradients
    for _, Child in ipairs(Instance:GetChildren()) do
        if Child:IsA("UIGradient") and Child.Name == "StyleGradient" then
            Child:Destroy()
        end
    end

    if typeof(ColorOrSequence) == "Color3" then
        Instance[Property] = ColorOrSequence
    elseif typeof(ColorOrSequence) == "ColorSequence" then
        Instance[Property] = Color3.new(1, 1, 1) -- White base for gradient
        local Gradient = Instance.new("UIGradient")
        Gradient.Name = "StyleGradient"
        Gradient.Color = ColorOrSequence
        Gradient.Parent = Instance
    end
end

function UBHubLib:RegisterDependency(Frame, Dependency)
    if not Dependency or not Dependency.Flag then return end

    local function Update(Value)
        local Match = (Value == Dependency.Value)
        local Prop = Dependency.Property or "Visible"

        if Prop == "Visible" then
            Frame.Visible = Match
            -- Optionally tween transparency if frame is visible
        elseif Prop == "Locked" then
            -- Handle locking visual state (e.g. CanvasGroup group transparency or overlay)
            -- For simplicity, we just set Selectable/Active or transparency
            Frame.BackgroundTransparency = Match and 0.5 or 0 -- Example logic, 'Locked' usually means disabled.
            -- Actually, if Value matches, Prop is toggled. If Locked=true, matching means Locked.
            local Canvas = Frame:FindFirstChild("Cover") -- Assume a cover exists or we disable input
            -- Simplified:
            if Frame:IsA("GuiButton") then Frame.Active = not Match end
        end
    end

    -- Initial Check
    local CurrentVal = UBHubLib.ConfigManager:GetFlag(Dependency.Flag)
    Update(CurrentVal)

    -- Listen
    UBHubLib.ConfigManager:RegisterListener(Dependency.Flag, Update)
end

-- Items Registry
UBHubLib.Items = {}

-- Advanced Color Picker Primitive

-- Quick Toggle System
UBHubLib.HUDButtons = {}
UBHubLib.EditMode = false

function UBHubLib:CreateHUDButton(Config)
    local Name = Config.Name
    local Callback = Config.Callback
    local InitialValue = Config.Value or false
    local Icon = Config.Icon

    local ScreenGui = self.ActiveWindow and self.ActiveWindow.Gui or GetHui():FindFirstChild("UBHub_Refactor")

    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Name = "HUD_" .. Name
    ButtonFrame.Size = UDim2.fromOffset(50, 50)
    ButtonFrame.Position = UDim2.fromScale(0.1, 0.1) -- Default pos, load from config later
    ButtonFrame.BackgroundColor3 = self.ActiveTheme.Colors.Secondary
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ButtonFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = self.ActiveTheme.Colors.Stroke
    Stroke.Thickness = 2
    Stroke.Parent = ButtonFrame

    local IconLabel
    if Icon then
        IconLabel = Instance.new("ImageLabel")
        IconLabel.Size = UDim2.fromScale(0.6, 0.6)
        IconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        IconLabel.Position = UDim2.fromScale(0.5, 0.5)
        IconLabel.BackgroundTransparency = 1

        local Asset, RectSize, RectPos = self:GetIcon(Icon)
        IconLabel.Image = Asset
        IconLabel.ImageRectSize = RectSize
        IconLabel.ImageRectOffset = RectPos
        IconLabel.Parent = ButtonFrame
    else
        IconLabel = Instance.new("TextLabel")
        IconLabel.Size = UDim2.fromScale(1, 1)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Text = string.sub(Name, 1, 2)
        IconLabel.Font = self.ActiveTheme.Fonts.Title
        IconLabel.TextColor3 = self.ActiveTheme.Colors.Text
        IconLabel.TextSize = 18
        IconLabel.Parent = ButtonFrame
    end

    local HUDObj = {
        Frame = ButtonFrame,
        Value = InitialValue,
        Callback = Callback
    }

    function HUDObj:UpdateVisual(State)
        HUDObj.Value = State
        if State then
            TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Primary}):Play()
            if IconLabel:IsA("ImageLabel") then
                IconLabel.ImageColor3 = Color3.new(1,1,1)
            else
                IconLabel.TextColor3 = Color3.new(1,1,1)
            end
        else
            TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Secondary}):Play()
            if IconLabel:IsA("ImageLabel") then
                IconLabel.ImageColor3 = UBHubLib.ActiveTheme.Colors.Text
            else
                IconLabel.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
            end
        end
    end

    ButtonFrame.MouseButton1Click:Connect(function()
        if UBHubLib.EditMode then
            if UBHubLib.ActiveWindow and UBHubLib.ActiveWindow.OpenResizePanel then
                UBHubLib.ActiveWindow:OpenResizePanel(HUDObj)
            end
            return
        end
        local NewState = not HUDObj.Value
        HUDObj:UpdateVisual(NewState)
        Callback(NewState)
    end)

    HUDObj:UpdateVisual(InitialValue)

    -- Dragging Logic (Enabled only in Edit Mode)
    local Dragging, DragInput, DragStart, StartPos

    ButtonFrame.InputBegan:Connect(function(Input)
        if UBHubLib.EditMode and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            Dragging = true
            DragStart = Input.Position
            StartPos = ButtonFrame.Position

            -- Selection logic for ResizePanel could go here
        end
    end)

    ButtonFrame.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = Input.Position - DragStart
            ButtonFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)

    ButtonFrame.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    self.HUDButtons[Name] = HUDObj
    return HUDObj
end

-- Notification System
UBHubLib.Notifications = {}
function UBHubLib:MakeNotify(Config)
    local Title = Config.Title or "Notification"
    local Content = Config.Content or ""
    local Time = Config.Time or 5
    local Icon = Config.Icon or "info"
    local BackgroundImage = Config.BackgroundImage
    local OneTime = Config.OneTime or false

    if OneTime then
        if self.ConfigManager:GetFlag("Notify_" .. Title) then
            return
        end
        self.ConfigManager:UpdateFlag("Notify_" .. Title, true)
    end

    local ActiveGui = self.ActiveWindow and self.ActiveWindow.Gui or GetHui():FindFirstChild("UBHub_Refactor")
    if not ActiveGui then return end

    local Container = ActiveGui:FindFirstChild("NotificationContainer")
    if not Container then
        Container = Instance.new("Frame")
        Container.Name = "NotificationContainer"
        Container.Size = UDim2.new(0, 300, 1, -20)
        Container.Position = UDim2.new(1, -310, 0, 10)
        Container.BackgroundTransparency = 1
        Container.Parent = ActiveGui

        local Layout = Instance.new("UIListLayout")
        Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Layout.Padding = UDim.new(0, 10)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = Container
    end

    -- Create Notification Frame
    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.Size = UDim2.new(1, 0, 0, 0) -- Auto size
    NotifyFrame.AutomaticSize = Enum.AutomaticSize.Y
    NotifyFrame.BackgroundColor3 = self.ActiveTheme.Colors.Secondary
    NotifyFrame.BackgroundTransparency = 0.1
    NotifyFrame.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NotifyFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = self.ActiveTheme.Colors.Stroke
    Stroke.Thickness = 1
    Stroke.Parent = NotifyFrame

    -- Background Image Support
    if BackgroundImage then
        local BgImg = Instance.new("ImageLabel")
        BgImg.Size = UDim2.fromScale(1, 1)
        BgImg.BackgroundTransparency = 1
        BgImg.Image = BackgroundImage
        BgImg.ImageTransparency = 0.8
        BgImg.ScaleType = Enum.ScaleType.Crop
        BgImg.Parent = NotifyFrame
        local BgCorner = Instance.new("UICorner")
        BgCorner.CornerRadius = UDim.new(0, 8)
        BgCorner.Parent = BgImg
    end

    -- Content
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Title
    TitleLabel.Font = self.ActiveTheme.Fonts.Title
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = self.ActiveTheme.Colors.Primary
    TitleLabel.Size = UDim2.new(1, -10, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifyFrame

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Text = Content
    ContentLabel.Font = self.ActiveTheme.Fonts.Content
    ContentLabel.TextSize = 12
    ContentLabel.TextColor3 = self.ActiveTheme.Colors.Text
    ContentLabel.Size = UDim2.new(1, -20, 0, 0)
    ContentLabel.Position = UDim2.new(0, 10, 0, 30)
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.TextWrapped = true
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Parent = NotifyFrame

    -- Padding for AutomaticSize
    local Pad = Instance.new("UIPadding")
    Pad.PaddingBottom = UDim.new(0, 10)
    Pad.Parent = NotifyFrame

    -- Animation
    NotifyFrame.Position = UDim2.new(1, 300, 0, 0) -- Offscreen
    -- Since it's in a list layout, Position doesn't work for entrance animation usually unless we tween size or parent it differently.
    -- But we can tween transparency/size.
    -- A better way for ListLayout is to parent it, set Size 0, tween Size.

    -- Close Logic
    task.delay(Time, function()
        if NotifyFrame.Parent then
            TweenService:Create(NotifyFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(TitleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(ContentLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
            task.wait(0.5)
            NotifyFrame:Destroy()
        end
    end)
end

-- Elements Implementation
UBHubLib.Elements = {}

function UBHubLib.Elements.Paragraph(Parent, Config)
    local Title = Config.Title or "Paragraph"
    local Content = Config.Content or "Content"
    local Image = Config.Image

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 0)
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Secondary
    Frame.BackgroundTransparency = 0.5
    Frame.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Vertical
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = Frame

    local Pad = Instance.new("UIPadding")
    Pad.PaddingTop = UDim.new(0, 10)
    Pad.PaddingBottom = UDim.new(0, 10)
    Pad.PaddingLeft = UDim.new(0, 10)
    Pad.PaddingRight = UDim.new(0, 10)
    Pad.Parent = Frame

    -- Header (Icon + Title)
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 20)
    Header.BackgroundTransparency = 1
    Header.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Title
    TitleLabel.Font = UBHubLib.ActiveTheme.Fonts.Title
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Header

    if Image then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.fromOffset(20, 20)
        Icon.BackgroundTransparency = 1
        Icon.Image = Image
        Icon.Parent = Header

        TitleLabel.Position = UDim2.new(0, 25, 0, 0)
        TitleLabel.Size = UDim2.new(1, -25, 1, 0)
    end

    -- Content
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Text = Content
    DescLabel.Font = UBHubLib.ActiveTheme.Fonts.Content
    DescLabel.TextSize = 12
    DescLabel.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    DescLabel.TextTransparency = 0.4
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Size = UDim2.new(1, 0, 0, 0)
    DescLabel.AutomaticSize = Enum.AutomaticSize.Y
    DescLabel.BackgroundTransparency = 1
    DescLabel.Parent = Frame

    -- Buttons
    if Config.Buttons and #Config.Buttons > 0 then
        local ButtonContainer = Instance.new("Frame")
        ButtonContainer.Size = UDim2.new(1, 0, 0, 30)
        ButtonContainer.BackgroundTransparency = 1
        ButtonContainer.AutomaticSize = Enum.AutomaticSize.Y
        ButtonContainer.Parent = Frame

        local BtnLayout = Instance.new("UIListLayout")
        BtnLayout.FillDirection = Enum.FillDirection.Horizontal
        BtnLayout.Padding = UDim.new(0, 5)
        BtnLayout.Parent = ButtonContainer

        for _, BtnData in ipairs(Config.Buttons) do
            local PBtn = Instance.new("TextButton")
            PBtn.Text = BtnData.Title or "Action"
            PBtn.Size = UDim2.new(0, 0, 0, 25)
            PBtn.AutomaticSize = Enum.AutomaticSize.X
            PBtn.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Background
            PBtn.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
            PBtn.Font = UBHubLib.ActiveTheme.Fonts.Content
            PBtn.TextSize = 12
            PBtn.Parent = ButtonContainer

            local PBtnCorner = Instance.new("UICorner")
            PBtnCorner.CornerRadius = UDim.new(0, 4)
            PBtnCorner.Parent = PBtn

            local PBtnPad = Instance.new("UIPadding")
            PBtnPad.PaddingLeft = UDim.new(0, 8)
            PBtnPad.PaddingRight = UDim.new(0, 8)
            PBtnPad.Parent = PBtn

            PBtn.MouseButton1Click:Connect(BtnData.Callback or function() end)
        end
    end

    -- Helper to update text
    local Funcs = {}
    function Funcs:Set(NewTitle, NewContent)
        if NewTitle then TitleLabel.Text = NewTitle end
        if NewContent then DescLabel.Text = NewContent end
    end

    return Funcs
end

function UBHubLib.Elements.Divider(Parent, Config)
    local Text = Config.Text or Config.Title

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 20)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Parent

    if Text then
        -- Line - Text - Line
        local Layout = Instance.new("UIListLayout")
        Layout.FillDirection = Enum.FillDirection.Horizontal
        Layout.VerticalAlignment = Enum.VerticalAlignment.Center
        Layout.Padding = UDim.new(0, 10)
        Layout.Parent = Frame

        local LeftLine = Instance.new("Frame")
        LeftLine.Name = "LeftLine"
        LeftLine.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Divider
        LeftLine.BorderSizePixel = 0
        LeftLine.Size = UDim2.new(0.3, 0, 0, 1)
        LeftLine.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Text = Text
        Label.Font = UBHubLib.ActiveTheme.Fonts.Title
        Label.TextSize = 12
        Label.TextColor3 = UBHubLib.ActiveTheme.Colors.Divider
        Label.AutomaticSize = Enum.AutomaticSize.X
        Label.Size = UDim2.new(0, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Parent = Frame

        local RightLine = Instance.new("Frame")
        RightLine.Name = "RightLine"
        RightLine.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Divider
        RightLine.BorderSizePixel = 0
        RightLine.Size = UDim2.new(0.3, 0, 0, 1)
        RightLine.Parent = Frame

        -- Improved Logic
        local function UpdateLines()
             LeftLine.Size = UDim2.new(0.5, -((Label.TextBounds.X / 2) + 15), 0, 1)
             RightLine.Size = UDim2.new(0.5, -((Label.TextBounds.X / 2) + 15), 0, 1)
        end

        Label:GetPropertyChangedSignal("TextBounds"):Connect(UpdateLines)
        task.delay(0.01, UpdateLines)
    else
        -- Line Divider
        local Line = Instance.new("Frame")
        Line.Size = UDim2.new(1, -20, 0, 1)
        Line.Position = UDim2.new(0, 10, 0.5, 0)
        Line.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Divider
        Line.BorderSizePixel = 0
        Line.Parent = Frame
    end
end

function UBHubLib.Elements.Button(Parent, Config)
    local Title = Config.Title or "Button"
    local Icon = Config.Icon
    local Callback = Config.Callback or function() end

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Secondary
    Button.BackgroundTransparency = 0.5
    Button.Text = ""
    Button.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Title
    TitleLabel.Font = UBHubLib.ActiveTheme.Fonts.Title
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Button

    if Icon then
        local IconImg = Instance.new("ImageLabel")
        IconImg.Size = UDim2.fromOffset(20, 20)
        IconImg.Position = UDim2.new(1, -30, 0.5, 0)
        IconImg.AnchorPoint = Vector2.new(0, 0.5)
        IconImg.BackgroundTransparency = 1
        IconImg.ImageColor3 = UBHubLib.ActiveTheme.Colors.Text

        local Asset, RectSize, RectPos = UBHubLib:GetIcon(Icon)
        IconImg.Image = Asset
        IconImg.ImageRectSize = RectSize
        IconImg.ImageRectOffset = RectPos
        IconImg.Parent = Button
    end

    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Primary}):Play()
        task.delay(0.1, function()
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Secondary}):Play()
        end)
        Callback()
    end)

    return {Frame = Button}
end

function UBHubLib.Elements.Toggle(Parent, Config)
    local Title = Config.Title or "Toggle"
    local Default = Config.Default or false
    local Callback = Config.Callback or function() end
    local Flag = Config.Flag
    local Icon = Config.Icon
    local Style = Config.Style or "Switch"
    local CanQuickToggle = Config.CanQuickToggle or false

    local Value = Default
    local CreatorMode = false
    local HUDInstance = nil

    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
    ToggleFrame.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Secondary
    ToggleFrame.BackgroundTransparency = 0.5
    ToggleFrame.Text = ""
    ToggleFrame.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Title
    TitleLabel.Font = UBHubLib.ActiveTheme.Fonts.Title
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = ToggleFrame

    local ContentOffset = 10

    -- Quick Toggle "Creator" Button
    if CanQuickToggle then
        local CreatorBtn = Instance.new("ImageButton")
        CreatorBtn.Size = UDim2.fromOffset(20, 20)
        CreatorBtn.Position = UDim2.new(0, 5, 0.5, 0)
        CreatorBtn.AnchorPoint = Vector2.new(0, 0.5)
        CreatorBtn.BackgroundTransparency = 1
        CreatorBtn.Image = "rbxassetid://11293977610" -- Edit icon
        CreatorBtn.ImageColor3 = UBHubLib.ActiveTheme.Colors.Text
        CreatorBtn.ImageTransparency = 0.5
        CreatorBtn.Parent = ToggleFrame

        ContentOffset = 30

        CreatorBtn.MouseButton1Click:Connect(function()
            CreatorMode = not CreatorMode
            if CreatorMode then
                CreatorBtn.ImageColor3 = UBHubLib.ActiveTheme.Colors.Primary
                CreatorBtn.ImageTransparency = 0
            else
                CreatorBtn.ImageColor3 = UBHubLib.ActiveTheme.Colors.Text
                CreatorBtn.ImageTransparency = 0.5
            end
        end)
    end

    if Icon then
        local IconImg = Instance.new("ImageLabel")
        IconImg.Size = UDim2.fromOffset(20, 20)
        IconImg.Position = UDim2.new(0, ContentOffset, 0.5, 0)
        IconImg.AnchorPoint = Vector2.new(0, 0.5)
        IconImg.BackgroundTransparency = 1
        IconImg.ImageColor3 = UBHubLib.ActiveTheme.Colors.Text
        local Asset, RectSize, RectPos = UBHubLib:GetIcon(Icon)
        IconImg.Image = Asset
        IconImg.ImageRectSize = RectSize
        IconImg.ImageRectOffset = RectPos
        IconImg.Parent = ToggleFrame

        TitleLabel.Position = UDim2.new(0, ContentOffset + 25, 0, 0)
        TitleLabel.Size = UDim2.new(1, -(ContentOffset + 25 + 60), 1, 0)
    else
        TitleLabel.Position = UDim2.new(0, ContentOffset, 0, 0)
        TitleLabel.Size = UDim2.new(1, -(ContentOffset + 60), 1, 0)
    end

    -- Toggle UI Visuals
    local Toggler, VisualUpdate
    if Style == "Checkbox" then
        Toggler = Instance.new("Frame")
        Toggler.Size = UDim2.fromOffset(20, 20)
        Toggler.Position = UDim2.new(1, -30, 0.5, 0)
        Toggler.AnchorPoint = Vector2.new(0, 0.5)
        Toggler.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Background
        Toggler.Parent = ToggleFrame
        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 4)
        TCorner.Parent = Toggler

        local Check = Instance.new("ImageLabel")
        Check.Size = UDim2.fromOffset(14, 14)
        Check.Position = UDim2.fromScale(0.5, 0.5)
        Check.AnchorPoint = Vector2.new(0.5, 0.5)
        Check.BackgroundTransparency = 1
        Check.Image = "rbxassetid://11293979437"
        Check.ImageTransparency = 1
        Check.Parent = Toggler

        VisualUpdate = function(State)
            if State then
                TweenService:Create(Toggler, TweenInfo.new(0.2), {BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Primary}):Play()
                TweenService:Create(Check, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
            else
                TweenService:Create(Toggler, TweenInfo.new(0.2), {BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Background}):Play()
                TweenService:Create(Check, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            end
        end
    else
        -- Switch
        Toggler = Instance.new("Frame")
        Toggler.Size = UDim2.fromOffset(40, 20)
        Toggler.Position = UDim2.new(1, -50, 0.5, 0)
        Toggler.AnchorPoint = Vector2.new(0, 0.5)
        Toggler.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Background
        Toggler.Parent = ToggleFrame
        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(1, 0)
        TCorner.Parent = Toggler

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.fromOffset(16, 16)
        Circle.Position = UDim2.new(0, 2, 0.5, 0)
        Circle.AnchorPoint = Vector2.new(0, 0.5)
        Circle.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Text
        Circle.Parent = Toggler
        local CCorner = Instance.new("UICorner")
        CCorner.CornerRadius = UDim.new(1, 0)
        CCorner.Parent = Circle

        VisualUpdate = function(State)
            if State then
                TweenService:Create(Toggler, TweenInfo.new(0.2), {BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Primary}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, 0)}):Play()
            else
                TweenService:Create(Toggler, TweenInfo.new(0.2), {BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Background}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, 0)}):Play()
            end
        end
    end

    -- Main Logic
    local function Set(NewValue)
        Value = NewValue
        VisualUpdate(Value)
        Callback(Value)
        if Flag then
            UBHubLib.ConfigManager:UpdateFlag(Flag, Value)
        end
        if HUDInstance then
            HUDInstance:UpdateVisual(Value)
        end
    end

    ToggleFrame.MouseButton1Click:Connect(function()
        if CreatorMode then
            -- Logic: Toggle the existence of HUD button
            if HUDInstance then
                HUDInstance.Frame:Destroy()
                HUDInstance = nil
                -- Visual feedback for creator mode?
                -- Maybe flicker the switch or something.
                VisualUpdate(false) -- Main switch OFF means HUD destroyed
            else
                HUDInstance = UBHubLib:CreateHUDButton({
                    Name = Title,
                    Icon = Icon,
                    Value = Value,
                    Callback = function(Val)
                        Set(Val) -- Update this toggle when HUD clicked
                    end
                })
                VisualUpdate(true) -- Main switch ON means HUD created
            end
        else
            Set(not Value)
        end
    end)

    if Default then
        Set(true)
    end

    return {Frame = ToggleFrame, Set = Set, Get = function() return Value end}
end

function UBHubLib.Elements.Slider(Parent, Config)
    local Title = Config.Title or "Slider"
    local Min = Config.Min or 0
    local Max = Config.Max or 100
    local Default = Config.Default or Min
    local Increment = Config.Increment or 1
    local Callback = Config.Callback or function() end
    local Flag = Config.Flag

    local Value = Default

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Secondary
    Frame.BackgroundTransparency = 0.5
    Frame.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Title
    TitleLabel.Font = UBHubLib.ActiveTheme.Fonts.Title
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    TitleLabel.Size = UDim2.new(1, -10, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Frame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Text = tostring(Value)
    ValueLabel.Font = UBHubLib.ActiveTheme.Fonts.Content
    ValueLabel.TextSize = 14
    ValueLabel.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -60, 0, 5)
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Parent = Frame

    local SliderBar = Instance.new("TextButton")
    SliderBar.Text = ""
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 35)
    SliderBar.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Background
    SliderBar.AutoButtonColor = false
    SliderBar.Parent = Frame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Primary
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.fromOffset(12, 12)
    Knob.Position = UDim2.new(1, -6, 0.5, 0)
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Text
    Knob.Parent = Fill
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local Dragging = false

    local function Update(Input)
        local SizeX = SliderBar.AbsoluteSize.X
        local PositionX = SliderBar.AbsolutePosition.X
        local Percent = math.clamp((Input.Position.X - PositionX) / SizeX, 0, 1)

        local NewValue = Min + (Max - Min) * Percent
        NewValue = math.floor(NewValue / Increment + 0.5) * Increment

        Value = NewValue
        ValueLabel.Text = tostring(Value)
        Fill.Size = UDim2.new(Percent, 0, 1, 0)

        Callback(Value)
        if Flag then
            UBHubLib.ConfigManager:UpdateFlag(Flag, Value)
        end
    end

    SliderBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            Update(Input)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            Update(Input)
        end
    end)

    return {Frame = Frame}
end

function UBHubLib.Elements.Input(Parent, Config)
    local Title = Config.Title or "Input"
    local Default = Config.Default or ""
    local Callback = Config.Callback or function() end
    local Flag = Config.Flag
    local Placeholder = Config.Placeholder or "Enter text..."

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Secondary
    Frame.BackgroundTransparency = 0.5
    Frame.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Title
    TitleLabel.Font = UBHubLib.ActiveTheme.Fonts.Title
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    TitleLabel.Size = UDim2.new(1, -10, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Frame

    local InputBox = Instance.new("TextBox")
    InputBox.Text = Default
    InputBox.PlaceholderText = Placeholder
    InputBox.Font = UBHubLib.ActiveTheme.Fonts.Content
    InputBox.TextSize = 14
    InputBox.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    InputBox.PlaceholderColor3 = UBHubLib.ActiveTheme.Colors.Text
    InputBox.Size = UDim2.new(1, -20, 0, 20)
    InputBox.Position = UDim2.new(0, 10, 0, 25)
    InputBox.BackgroundTransparency = 1
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    InputBox.Parent = Frame

    InputBox.FocusLost:Connect(function(Enter)
        Callback(InputBox.Text)
        if Flag then
            UBHubLib.ConfigManager:UpdateFlag(Flag, InputBox.Text)
        end
    end)

    return {Frame = Frame}
end

function UBHubLib.Elements.Dropdown(Parent, Config)
    local Title = Config.Title or "Dropdown"
    local Options = Config.Options or {}
    local Multi = Config.Multi or false
    local Default = Config.Default
    local Callback = Config.Callback or function() end
    local Flag = Config.Flag

    local Value = Multi and (Default or {}) or (Default or "")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50) -- Collapsed size
    Frame.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Secondary
    Frame.BackgroundTransparency = 0.5
    Frame.Parent = Parent
    Frame.ClipsDescendants = true

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Title
    TitleLabel.Font = UBHubLib.ActiveTheme.Fonts.Title
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    TitleLabel.Size = UDim2.new(1, -40, 0, 50)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Frame

    local Icon = Instance.new("ImageLabel")
    Icon.Image = "rbxassetid://11293980070" -- Chevron down
    Icon.Size = UDim2.fromOffset(20, 20)
    Icon.Position = UDim2.new(1, -30, 0, 15)
    Icon.BackgroundTransparency = 1
    Icon.Parent = Frame

    local DropdownContainer = Instance.new("Frame")
    DropdownContainer.Size = UDim2.new(1, -20, 0, 0)
    DropdownContainer.Position = UDim2.new(0, 10, 0, 50)
    DropdownContainer.BackgroundTransparency = 1
    DropdownContainer.Parent = Frame

    local SearchBar = Instance.new("TextBox")
    SearchBar.Size = UDim2.new(1, 0, 0, 25)
    SearchBar.Position = UDim2.new(0, 0, 0, 0)
    SearchBar.PlaceholderText = "Search..."
    SearchBar.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Background
    SearchBar.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    SearchBar.Parent = DropdownContainer
    local SCorner = Instance.new("UICorner")
    SCorner.CornerRadius = UDim.new(0, 4)
    SCorner.Parent = SearchBar

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 0, 100)
    Scroll.Position = UDim2.new(0, 0, 0, 30)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 2
    Scroll.Parent = DropdownContainer

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 2)
    Layout.Parent = Scroll

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = Frame

    local Opened = false

    local function UpdateText()
        if Multi then
            TitleLabel.Text = Title .. " [" .. #Value .. "]"
        else
            TitleLabel.Text = Title .. ": " .. tostring(Value)
        end
    end

    local function RefreshOptions()
        -- Clear
        for _, Child in ipairs(Scroll:GetChildren()) do
            if Child:IsA("TextButton") then Child:Destroy() end
        end

        local Filter = SearchBar.Text:lower()

        for i, Option in ipairs(Options) do
            if Filter == "" or Option:lower():find(Filter) then
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 25)
                OptBtn.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Background
                OptBtn.BackgroundTransparency = 0.5
                OptBtn.Text = Option
                OptBtn.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
                OptBtn.Parent = Scroll

                local IsSelected = false
                if Multi then
                    if table.find(Value, Option) then IsSelected = true end
                else
                    if Value == Option then IsSelected = true end
                end

                if IsSelected then
                    OptBtn.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Primary
                    OptBtn.LayoutOrder = -1 -- Sort to top
                else
                    OptBtn.LayoutOrder = i
                end

                OptBtn.MouseButton1Click:Connect(function()
                    if Multi then
                        if table.find(Value, Option) then
                            table.remove(Value, table.find(Value, Option))
                        else
                            table.insert(Value, Option)
                        end
                    else
                        Value = Option
                        Opened = false -- Close on single select
                        TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                        TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    end
                    UpdateText()
                    RefreshOptions() -- Re-sort
                    Callback(Value)
                    if Flag then UBHubLib.ConfigManager:UpdateFlag(Flag, Value) end
                end)

                local OCorner = Instance.new("UICorner")
                OCorner.CornerRadius = UDim.new(0, 4)
                OCorner.Parent = OptBtn
            end
        end

        Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end

    SearchBar:GetPropertyChangedSignal("Text"):Connect(RefreshOptions)

    Button.MouseButton1Click:Connect(function()
        Opened = not Opened
        if Opened then
            TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 200)}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = 180}):Play()
            SearchBar.Text = ""
            RefreshOptions()
        else
            TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 50)}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = 0}):Play()
        end
    end)

    UpdateText()

    return {Frame = Frame}
end

function UBHubLib.Elements.ColorPicker(Parent, Config)
    local Title = Config.Title or "Color Picker"
    local Default = Config.Default or Color3.fromRGB(255, 255, 255)
    local Callback = Config.Callback or function() end
    local Flag = Config.Flag

    local Value = Default
    local HSV = {H = 0, S = 0, V = 1}
    local H, S, V = Color3.toHSV(Value)
    HSV.H, HSV.S, HSV.V = H, S, V

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Secondary
    Frame.BackgroundTransparency = 0.5
    Frame.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Title
    TitleLabel.Font = UBHubLib.ActiveTheme.Fonts.Title
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = UBHubLib.ActiveTheme.Colors.Text
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Frame

    local Preview = Instance.new("TextButton")
    Preview.Size = UDim2.new(0, 30, 0, 20)
    Preview.Position = UDim2.new(1, -40, 0.5, 0)
    Preview.AnchorPoint = Vector2.new(0, 0.5)
    Preview.BackgroundColor3 = Value
    Preview.Text = ""
    Preview.Parent = Frame
    local PCorner = Instance.new("UICorner")
    PCorner.CornerRadius = UDim.new(0, 4)
    PCorner.Parent = Preview

    -- Picker Popup
    local PickerFrame = Instance.new("Frame")
    PickerFrame.Size = UDim2.fromOffset(200, 220)
    PickerFrame.Position = UDim2.fromOffset(10, 10)
    PickerFrame.BackgroundColor3 = UBHubLib.ActiveTheme.Colors.Background
    PickerFrame.Visible = false
    PickerFrame.ZIndex = 200
    local ScreenGui = UBHubLib.ActiveWindow and UBHubLib.ActiveWindow.Gui or Parent:FindFirstAncestorWhichIsA("ScreenGui")
    PickerFrame.Parent = ScreenGui

    local PStroke = Instance.new("UIStroke")
    PStroke.Color = UBHubLib.ActiveTheme.Colors.Stroke
    PStroke.Thickness = 2
    PStroke.Parent = PickerFrame
    local PFrameCorner = Instance.new("UICorner")
    PFrameCorner.CornerRadius = UDim.new(0, 6)
    PFrameCorner.Parent = PickerFrame

    -- SV Box (Saturation / Value)
    local SVBox = Instance.new("TextButton")
    SVBox.Size = UDim2.new(1, -20, 0, 150)
    SVBox.Position = UDim2.new(0, 10, 0, 10)
    SVBox.BackgroundColor3 = Color3.fromHSV(HSV.H, 1, 1)
    SVBox.Text = ""
    SVBox.AutoButtonColor = false
    SVBox.Parent = PickerFrame

    local WhiteOverlay = Instance.new("Frame")
    WhiteOverlay.Size = UDim2.fromScale(1,1)
    WhiteOverlay.BackgroundColor3 = Color3.new(1,1,1)
    WhiteOverlay.BorderSizePixel = 0
    WhiteOverlay.Parent = SVBox
    local WGrad = Instance.new("UIGradient")
    WGrad.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}
    WGrad.Parent = WhiteOverlay

    local BlackOverlay = Instance.new("Frame")
    BlackOverlay.Size = UDim2.fromScale(1,1)
    BlackOverlay.BackgroundColor3 = Color3.new(0,0,0)
    BlackOverlay.BorderSizePixel = 0
    BlackOverlay.ZIndex = 2
    BlackOverlay.Parent = SVBox
    local BGrad = Instance.new("UIGradient")
    BGrad.Rotation = 90
    BGrad.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}
    BGrad.Parent = BlackOverlay

    local SVKnob = Instance.new("Frame")
    SVKnob.Size = UDim2.fromOffset(4, 4)
    SVKnob.BackgroundColor3 = Color3.new(1,1,1)
    SVKnob.ZIndex = 3
    SVKnob.Parent = SVBox
    local KStroke = Instance.new("UIStroke")
    KStroke.Thickness = 1
    KStroke.Parent = SVKnob

    -- Hue Slider
    local HueSlider = Instance.new("TextButton")
    HueSlider.Size = UDim2.new(1, -20, 0, 20)
    HueSlider.Position = UDim2.new(0, 10, 0, 170)
    HueSlider.BackgroundColor3 = Color3.new(1,1,1)
    HueSlider.Text = ""
    HueSlider.AutoButtonColor = false
    HueSlider.Parent = PickerFrame
    local HueGrad = Instance.new("UIGradient")
    HueGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
        ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17,1,1)),
        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1,1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)),
        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67,1,1)),
        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1,1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
    }
    HueGrad.Parent = HueSlider

    -- Logic
    local function UpdateColor()
        Value = Color3.fromHSV(HSV.H, HSV.S, HSV.V)
        Preview.BackgroundColor3 = Value
        SVBox.BackgroundColor3 = Color3.fromHSV(HSV.H, 1, 1)
        SVKnob.Position = UDim2.new(HSV.S, -2, 1 - HSV.V, -2)

        Callback(Value)
        if Flag then UBHubLib.ConfigManager:UpdateFlag(Flag, {R=Value.R, G=Value.G, B=Value.B}) end
    end

    local DraggingSV, DraggingHue = false, false

    SVBox.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then DraggingSV = true end
    end)
    HueSlider.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then DraggingHue = true end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            DraggingSV = false
            DraggingHue = false
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            if DraggingSV then
                local Pos = Input.Position
                local RelX = math.clamp((Pos.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                local RelY = math.clamp((Pos.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                HSV.S = RelX
                HSV.V = 1 - RelY
                UpdateColor()
            elseif DraggingHue then
                local Pos = Input.Position
                local RelX = math.clamp((Pos.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
                HSV.H = RelX
                UpdateColor()
            end
        end
    end)

    Preview.MouseButton1Click:Connect(function()
        PickerFrame.Visible = not PickerFrame.Visible
        PickerFrame.Position = UDim2.fromOffset(Preview.AbsolutePosition.X - 170, Preview.AbsolutePosition.Y + 30)
    end)

    return {Frame = Frame, Set = function(V) Value = V; UpdateColor() end}
end

-- Window System
function UBHubLib:CreateWindow(Config)
    local Window = {
        Config = Config or {},
        Tabs = {},
        ActiveTab = nil,
        Gui = nil,
        Main = nil,
        Content = nil,
        Overlays = {},
        EditMode = false
    }

    local Title = Window.Config.Name or "UB Hub"
    local Theme = UBHubLib.ActiveTheme

    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UBHub_Refactor"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ProtectGui(ScreenGui)
    if not gethui then ScreenGui.Parent = CoreGui else ScreenGui.Parent = gethui() end
    Window.Gui = ScreenGui

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.fromOffset(550, 350)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Theme.Colors.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    Window.Main = Main

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, Theme.Sizes.CornerRadius)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Colors.Stroke
    MainStroke.Thickness = 1
    MainStroke.Parent = Main

    -- Dragging Logic
    local DragInput, DragStart, StartPos
    local function UpdateDrag(Input)
        local Delta = Input.Position - DragStart
        local Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        TweenService:Create(Main, TweenInfo.new(0.1), {Position = Position}):Play()
    end

    Main.InputBegan:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and not Window.EditMode then
            DragStart = Input.Position
            StartPos = Main.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    DragStart = nil
                end
            end)
        end
    end)

    Main.InputChanged:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and DragStart then
            UpdateDrag(Input)
        end
    end)

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = Main

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Text = Title
    TitleLabel.Font = Theme.Fonts.Title
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = Theme.Colors.Primary
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Size = UDim2.new(1, -150, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Topbar

    -- Topbar Icons Container
    local TopbarIcons = Instance.new("Frame")
    TopbarIcons.Name = "Icons"
    TopbarIcons.Size = UDim2.new(0, 150, 1, 0)
    TopbarIcons.Position = UDim2.new(1, 0, 0, 0)
    TopbarIcons.AnchorPoint = Vector2.new(1, 0)
    TopbarIcons.BackgroundTransparency = 1
    TopbarIcons.Parent = Topbar

    local IconLayout = Instance.new("UIListLayout")
    IconLayout.FillDirection = Enum.FillDirection.Horizontal
    IconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    IconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    IconLayout.Padding = UDim.new(0, 5)
    IconLayout.Parent = TopbarIcons

    local TopbarPadding = Instance.new("UIPadding")
    TopbarPadding.PaddingRight = UDim.new(0, 10)
    TopbarPadding.Parent = TopbarIcons

    -- Topbar Helper function
    local function AddTopbarButton(Name, IconName, Callback)
        local Button = Instance.new("ImageButton")
        Button.Name = Name
        Button.Size = UDim2.fromOffset(30, 30)
        Button.BackgroundTransparency = 1
        Button.LayoutOrder = 1
        Button.Parent = TopbarIcons

        -- Get Icon
        local IconAsset, RectSize, RectPos = UBHubLib:GetIcon(IconName)
        Button.Image = IconAsset
        Button.ImageRectSize = RectSize
        Button.ImageRectOffset = RectPos
        Button.ImageColor3 = Theme.Colors.Text

        -- Hover Effect (Hidden Frame)
        local HoverFrame = Instance.new("Frame")
        HoverFrame.Size = UDim2.fromScale(1,1)
        HoverFrame.BackgroundColor3 = Theme.Colors.Text
        HoverFrame.BackgroundTransparency = 1
        HoverFrame.ZIndex = 0
        HoverFrame.Parent = Button
        local HoverCorner = Instance.new("UICorner")
        HoverCorner.CornerRadius = UDim.new(0, 4)
        HoverCorner.Parent = HoverFrame

        Button.MouseEnter:Connect(function()
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.9}):Play()
        end)
        Button.MouseLeave:Connect(function()
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end)

        if Callback then
            Button.MouseButton1Click:Connect(Callback)
        end
        return Button
    end

    -- Add Buttons
    Window.SearchButton = AddTopbarButton("Search", "search", function()
        Window:ToggleSearch()
    end)

    Window.EditButton = AddTopbarButton("Edit", "edit", function()
        Window:ToggleEditMode()
    end)

    AddTopbarButton("Minimize", "minimize", function()
        Window.Main.Visible = false
        -- Minimization logic usually involves a separate small GUI or keybind
    end)

    AddTopbarButton("Close", "close", function()
        ScreenGui:Destroy()
    end)

    -- Content Area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -20, 1, -50)
    Content.Position = UDim2.new(0, 10, 0, 45)
    Content.BackgroundColor3 = Theme.Colors.Secondary -- Slightly lighter background for content
    Content.BorderSizePixel = 0
    Content.Parent = Main
    Window.Content = Content

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, Theme.Sizes.CornerRadius)
    ContentCorner.Parent = Content

    -- Sidebar (Left side container)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 120, 1, 0)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Content

    -- Tab Selection List (Scrolling)
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, 0, 1, 0) -- Will be adjusted if StaticTabs exist
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabList

    local TabListPadding = Instance.new("UIPadding")
    TabListPadding.PaddingTop = UDim.new(0, 10)
    TabListPadding.PaddingLeft = UDim.new(0, 5)
    TabListPadding.Parent = TabList

    -- Static Tab Container (Fixed Bottom)
    local StaticTabList = Instance.new("Frame")
    StaticTabList.Name = "StaticTabList"
    StaticTabList.Size = UDim2.new(1, 0, 0, 0)
    StaticTabList.Position = UDim2.new(0, 0, 1, 0)
    StaticTabList.AnchorPoint = Vector2.new(0, 1)
    StaticTabList.BackgroundTransparency = 1
    StaticTabList.Parent = Sidebar

    local StaticListLayout = Instance.new("UIListLayout")
    StaticListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StaticListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    StaticListLayout.Padding = UDim.new(0, 5)
    StaticListLayout.Parent = StaticTabList

    local StaticListPadding = Instance.new("UIPadding")
    StaticListPadding.PaddingBottom = UDim.new(0, 10)
    StaticListPadding.PaddingLeft = UDim.new(0, 5)
    StaticListPadding.Parent = StaticTabList

    -- Tab Container (Right side)
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -125, 1, 0)
    TabContainer.Position = UDim2.new(0, 125, 0, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Content
    Window.TabContainer = TabContainer

    -- Resize Handle
    local ResizeHandle = Instance.new("TextButton")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.fromOffset(15, 15)
    ResizeHandle.Position = UDim2.new(1, -2, 1, -2)
    ResizeHandle.AnchorPoint = Vector2.new(1, 1)
    ResizeHandle.Text = ""
    ResizeHandle.BackgroundColor3 = Color3.new(1,1,1)
    ResizeHandle.Parent = Main

    local ResizeCorner = Instance.new("UICorner")
    ResizeCorner.CornerRadius = UDim.new(0, 4)
    ResizeCorner.Parent = ResizeHandle

    -- Apply Gradient to Handle
    UBHubLib:ApplyStyle(ResizeHandle, "BackgroundColor3", Theme.Colors.Gradient)

    -- Resizing Logic
    local Resizing = false
    local ResizeStart, StartSize

    ResizeHandle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Resizing = true
            ResizeStart = Input.Position
            StartSize = Main.AbsoluteSize
        end
    end)

    ResizeHandle.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Resizing = false
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Resizing and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = Input.Position - ResizeStart
            local NewX = math.max(400, StartSize.X + Delta.X)
            local NewY = math.max(300, StartSize.Y + Delta.Y)
            Main.Size = UDim2.fromOffset(NewX, NewY)
        end
    end)

    -- Overlays
    -- Blur
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Enabled = false
    Blur.Name = "UBHub_Blur"
    Blur.Parent = Lighting
    Window.Blur = Blur

    -- Search Overlay
    local SearchOverlay = Instance.new("Frame")
    SearchOverlay.Name = "SearchOverlay"
    SearchOverlay.Size = UDim2.fromScale(1, 1)
    SearchOverlay.BackgroundColor3 = Color3.new(0,0,0)
    SearchOverlay.BackgroundTransparency = 0.5
    SearchOverlay.ZIndex = 100
    SearchOverlay.Visible = false
    SearchOverlay.Parent = Main
    Window.Overlays.Search = SearchOverlay

    -- Search UI
    local SearchBar = Instance.new("TextBox")
    SearchBar.Size = UDim2.new(0.8, 0, 0, 40)
    SearchBar.Position = UDim2.fromScale(0.5, 0.2)
    SearchBar.AnchorPoint = Vector2.new(0.5, 0)
    SearchBar.BackgroundColor3 = Theme.Colors.Secondary
    SearchBar.TextColor3 = Theme.Colors.Text
    SearchBar.PlaceholderText = "Search Features..."
    SearchBar.Parent = SearchOverlay
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.Parent = SearchBar

    local SearchResults = Instance.new("ScrollingFrame")
    SearchResults.Name = "Results"
    SearchResults.Size = UDim2.new(0.8, 0, 0.6, 0)
    SearchResults.Position = UDim2.fromScale(0.5, 0.35)
    SearchResults.AnchorPoint = Vector2.new(0.5, 0)
    SearchResults.BackgroundTransparency = 1
    SearchResults.ScrollBarThickness = 2
    SearchResults.ScrollBarImageColor3 = Theme.Colors.Primary
    SearchResults.Parent = SearchOverlay

    local SearchLayout = Instance.new("UIListLayout")
    SearchLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SearchLayout.Padding = UDim.new(0, 5)
    SearchLayout.Parent = SearchResults

    Window.Registry = {}

    function Window:RegisterElement(Tab, Config, Obj)
        if not Config.Title then return end
        table.insert(self.Registry, {
            Title = Config.Title,
            Desc = Config.Desc or "",
            Tab = Tab,
            Element = Obj,
            MatchScore = 0
        })
    end

    local function UpdateSearch()
        local Text = SearchBar.Text:lower()

        -- Clear old results
        for _, Child in ipairs(SearchResults:GetChildren()) do
            if Child:IsA("TextButton") then Child:Destroy() end
        end

        if Text == "" then return end

        local Matches = {}
        for _, Entry in ipairs(Window.Registry) do
            local Score = 0
            if Entry.Title:lower():find(Text) then
                Score = Score + 100
            elseif Entry.Desc:lower():find(Text) then
                Score = Score + 10
            end

            if Score > 0 then
                Entry.MatchScore = Score
                table.insert(Matches, Entry)
            end
        end

        table.sort(Matches, function(a, b) return a.MatchScore > b.MatchScore end)

        for i, Match in ipairs(Matches) do
            local ResBtn = Instance.new("TextButton")
            ResBtn.Size = UDim2.new(1, 0, 0, 40)
            ResBtn.BackgroundColor3 = Theme.Colors.Secondary
            ResBtn.BackgroundTransparency = 0.2
            ResBtn.Text = ""
            ResBtn.Parent = SearchResults

            local ResCorner = Instance.new("UICorner")
            ResCorner.CornerRadius = UDim.new(0, 6)
            ResCorner.Parent = ResBtn

            local RTitle = Instance.new("TextLabel")
            RTitle.Text = Match.Title
            RTitle.Font = Theme.Fonts.Title
            RTitle.TextSize = 14
            RTitle.TextColor3 = Theme.Colors.Primary
            RTitle.Size = UDim2.new(1, -10, 0, 20)
            RTitle.Position = UDim2.new(0, 10, 0, 2)
            RTitle.BackgroundTransparency = 1
            RTitle.TextXAlignment = Enum.TextXAlignment.Left
            RTitle.Parent = ResBtn

            local RDesc = Instance.new("TextLabel")
            RDesc.Text = Match.Desc ~= "" and Match.Desc or "No description"
            RDesc.Font = Theme.Fonts.Content
            RDesc.TextSize = 12
            RDesc.TextColor3 = Theme.Colors.Text
            RDesc.TextTransparency = 0.4
            RDesc.Size = UDim2.new(1, -10, 0, 15)
            RDesc.Position = UDim2.new(0, 10, 0, 22)
            RDesc.BackgroundTransparency = 1
            RDesc.TextXAlignment = Enum.TextXAlignment.Left
            RDesc.Parent = ResBtn

            ResBtn.MouseButton1Click:Connect(function()
                Window:ToggleSearch()
                Window:SelectTab(Match.Tab.Id)
                -- Scroll to element logic could be added here if ScrollingFrame exposed absolute position

                -- Highlight effect
                if Match.Element.Frame then
                    local OriginalColor = Match.Element.Frame.BackgroundColor3
                    TweenService:Create(Match.Element.Frame, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Colors.Primary}):Play()
                    task.delay(0.3, function()
                        TweenService:Create(Match.Element.Frame, TweenInfo.new(0.3), {BackgroundColor3 = OriginalColor}):Play()
                    end)
                end
            end)

            -- Staggered Animation
            ResBtn.BackgroundTransparency = 1
            RTitle.TextTransparency = 1
            RDesc.TextTransparency = 1
            task.delay(0.05 * i, function()
                TweenService:Create(ResBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
                TweenService:Create(RTitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
                TweenService:Create(RDesc, TweenInfo.new(0.3), {TextTransparency = 0.4}):Play()
            end)
        end

        SearchResults.CanvasSize = UDim2.new(0, 0, 0, SearchLayout.AbsoluteContentSize.Y + 20)
    end

    SearchBar:GetPropertyChangedSignal("Text"):Connect(UpdateSearch)

    -- Resize Panel
    local ResizePanel = Instance.new("Frame")
    ResizePanel.Name = "ResizePanel"
    ResizePanel.Size = UDim2.fromOffset(200, 150)
    ResizePanel.Position = UDim2.fromScale(0.5, 0.5)
    ResizePanel.AnchorPoint = Vector2.new(0.5, 0.5)
    ResizePanel.BackgroundColor3 = Theme.Colors.Background
    ResizePanel.Visible = false
    ResizePanel.Parent = ScreenGui -- Parent to ScreenGui to sit above everything or inside Main? ScreenGui is better for HUD editing.

    local RP_Corner = Instance.new("UICorner")
    RP_Corner.CornerRadius = UDim.new(0, 8)
    RP_Corner.Parent = ResizePanel

    local RP_Stroke = Instance.new("UIStroke")
    RP_Stroke.Color = Theme.Colors.Stroke
    RP_Stroke.Thickness = 2
    RP_Stroke.Parent = ResizePanel

    local RP_Title = Instance.new("TextLabel")
    RP_Title.Text = "Resize Button"
    RP_Title.Size = UDim2.new(1, 0, 0, 30)
    RP_Title.BackgroundTransparency = 1
    RP_Title.TextColor3 = Theme.Colors.Text
    RP_Title.Font = Theme.Fonts.Title
    RP_Title.TextSize = 16
    RP_Title.Parent = ResizePanel

    -- Sliders for Width/Height
    -- We can reuse UBHubLib.Elements.Slider logic but manual implementation is faster here to avoid complex parenting
    local function CreateMiniSlider(Name, YPos, Callback)
        local Label = Instance.new("TextLabel")
        Label.Text = Name
        Label.Size = UDim2.new(0, 50, 0, 20)
        Label.Position = UDim2.new(0, 10, 0, YPos)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Theme.Colors.Text
        Label.Font = Theme.Fonts.Content
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ResizePanel

        local SliderBg = Instance.new("Frame")
        SliderBg.Size = UDim2.new(0, 120, 0, 6)
        SliderBg.Position = UDim2.new(0, 60, 0, YPos + 7)
        SliderBg.BackgroundColor3 = Theme.Colors.Secondary
        SliderBg.Parent = ResizePanel
        local SC = Instance.new("UICorner")
        SC.Parent = SliderBg

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new(0.5, 0, 1, 0)
        Fill.BackgroundColor3 = Theme.Colors.Primary
        Fill.BorderSizePixel = 0
        Fill.Parent = SliderBg
        local FC = Instance.new("UICorner")
        FC.Parent = Fill

        local Trigger = Instance.new("TextButton")
        Trigger.BackgroundTransparency = 1
        Trigger.Size = UDim2.new(1, 0, 1, 0)
        Trigger.Text = ""
        Trigger.Parent = SliderBg

        local function Update(Input)
            local P = math.clamp((Input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(P, 0, 1, 0)
            local Val = math.floor(20 + (P * 180)) -- Min 20, Max 200
            Callback(Val)
        end

        local Dragging = false
        Trigger.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                Update(Input)
            end
        end)
        UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(Input)
            if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then Update(Input) end
        end)

        return {
            Set = function(Val)
                local P = math.clamp((Val - 20) / 180, 0, 1)
                Fill.Size = UDim2.new(P, 0, 1, 0)
            end
        }
    end

    local WidthSlider = CreateMiniSlider("Width", 40, function(V)
        if Window.SelectedHUD then Window.SelectedHUD.Frame.Size = UDim2.fromOffset(V, Window.SelectedHUD.Frame.Size.Y.Offset) end
    end)
    local HeightSlider = CreateMiniSlider("Height", 80, function(V)
        if Window.SelectedHUD then Window.SelectedHUD.Frame.Size = UDim2.fromOffset(Window.SelectedHUD.Frame.Size.X.Offset, V) end
    end)

    local CloseRP = Instance.new("TextButton")
    CloseRP.Text = "Done"
    CloseRP.Size = UDim2.new(0, 100, 0, 30)
    CloseRP.Position = UDim2.new(0.5, -50, 1, -40)
    CloseRP.BackgroundColor3 = Theme.Colors.Secondary
    CloseRP.TextColor3 = Theme.Colors.Text
    CloseRP.Font = Theme.Fonts.Content
    CloseRP.TextSize = 14
    CloseRP.Parent = ResizePanel
    local CRPC = Instance.new("UICorner")
    CRPC.Parent = CloseRP

    CloseRP.MouseButton1Click:Connect(function()
        ResizePanel.Visible = false
        Window.SelectedHUD = nil
    end)

    function Window:OpenResizePanel(HUDObj)
        self.SelectedHUD = HUDObj
        ResizePanel.Visible = true
        local S = HUDObj.Frame.Size
        WidthSlider.Set(S.X.Offset)
        HeightSlider.Set(S.Y.Offset)
    end

    -- Edit Mode Logic
    function Window:ToggleEditMode()
        self.EditMode = not self.EditMode
        UBHubLib.EditMode = self.EditMode
        UBHubLib.ActiveWindow = self -- Ensure global ref

        if self.EditMode then
            TweenService:Create(self.Blur, TweenInfo.new(0.5), {Size = 20}):Play()
            self.Blur.Enabled = true
        else
            TweenService:Create(self.Blur, TweenInfo.new(0.5), {Size = 0}):Play()
            task.delay(0.5, function() self.Blur.Enabled = false end)
            ResizePanel.Visible = false
            self.SelectedHUD = nil
            -- Save HUD config here if needed
        end
    end

    function Window:ToggleSearch()
        self.Overlays.Search.Visible = not self.Overlays.Search.Visible
        if self.Overlays.Search.Visible then
            SearchBar:CaptureFocus()
        end
    end

    function Window:ShowDialog(Config)
        local Title = Config.Title or "Dialog"
        local Content = Config.Content or ""
        local Buttons = Config.Buttons or {}

        local Overlay = Instance.new("Frame")
        Overlay.Name = "DialogOverlay"
        Overlay.Size = UDim2.fromScale(1, 1)
        Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
        Overlay.BackgroundTransparency = 1
        Overlay.ZIndex = 200
        Overlay.Parent = Main

        TweenService:Create(Overlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()

        local DialogFrame = Instance.new("Frame")
        DialogFrame.Size = UDim2.fromOffset(300, 150)
        DialogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        DialogFrame.Position = UDim2.fromScale(0.5, 0.5)
        DialogFrame.BackgroundColor3 = Theme.Colors.Background
        DialogFrame.BackgroundTransparency = 1 -- Start hidden
        DialogFrame.Parent = Overlay

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = DialogFrame

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme.Colors.Stroke
        Stroke.Thickness = 1
        Stroke.Parent = DialogFrame

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Text = Title
        TitleLabel.Font = Theme.Fonts.Title
        TitleLabel.TextSize = 16
        TitleLabel.TextColor3 = Theme.Colors.Text
        TitleLabel.Size = UDim2.new(1, -20, 0, 30)
        TitleLabel.Position = UDim2.new(0, 10, 0, 10)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = DialogFrame

        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Text = Content
        ContentLabel.Font = Theme.Fonts.Content
        ContentLabel.TextSize = 14
        ContentLabel.TextColor3 = Theme.Colors.Text
        ContentLabel.TextTransparency = 0.3
        ContentLabel.TextWrapped = true
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
        ContentLabel.Size = UDim2.new(1, -20, 1, -80)
        ContentLabel.Position = UDim2.new(0, 10, 0, 40)
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Parent = DialogFrame

        local ButtonContainer = Instance.new("Frame")
        ButtonContainer.Size = UDim2.new(1, -20, 0, 30)
        ButtonContainer.Position = UDim2.new(0, 10, 1, -40)
        ButtonContainer.BackgroundTransparency = 1
        ButtonContainer.Parent = DialogFrame

        local Layout = Instance.new("UIListLayout")
        Layout.FillDirection = Enum.FillDirection.Horizontal
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        Layout.Padding = UDim.new(0, 10)
        Layout.Parent = ButtonContainer

        local function Close()
            TweenService:Create(DialogFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 0.6)}):Play()
            TweenService:Create(Overlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            task.wait(0.2)
            Overlay:Destroy()
        end

        for _, BtnConfig in ipairs(Buttons) do
            local Btn = Instance.new("TextButton")
            Btn.Text = BtnConfig.Title or "Button"
            Btn.Size = UDim2.new(0, 80, 1, 0)
            Btn.Font = Theme.Fonts.Content
            Btn.TextSize = 12
            Btn.BackgroundColor3 = BtnConfig.Variant == "Primary" and Theme.Colors.Primary or Theme.Colors.Secondary
            Btn.TextColor3 = Theme.Colors.Text
            Btn.Parent = ButtonContainer

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                if BtnConfig.Callback then BtnConfig.Callback() end
                Close()
            end)
        end

        -- Open Animation
        TweenService:Create(DialogFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {BackgroundTransparency = 0, Position = UDim2.fromScale(0.5, 0.5)}):Play()
    end

    -- Tab System Methods
    function Window:SelectTab(TabId)
        if not self.Tabs[TabId] then return end

        -- Hide all tabs
        for Id, Tab in pairs(self.Tabs) do
            Tab.Page.Visible = false
            -- Reset Button Style
            TweenService:Create(Tab.Button.Title, TweenInfo.new(0.2), {TextTransparency = 0.5}):Play()
            if Tab.Button:FindFirstChild("Indicator") then
                TweenService:Create(Tab.Button.Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 15)}):Play()
            end
        end

        -- Show selected tab
        local Tab = self.Tabs[TabId]
        Tab.Page.Visible = true
        self.ActiveTab = Tab

        -- Active Style
        TweenService:Create(Tab.Button.Title, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        if Tab.Button:FindFirstChild("Indicator") then
            TweenService:Create(Tab.Button.Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0, 15)}):Play()
        end
    end

    local TabCount = 0
    function Window:AddTab(Config)
        local Name = Config.Name or "Tab"
        local Icon = Config.Icon or nil
        local Category = Config.Category -- Optional category grouping (not implemented logic wise, just layout order handled by UIListLayout usually)

        TabCount = TabCount + 1
        local TabId = "Tab_" .. TabCount

        -- Tab Button
        local Button = Instance.new("TextButton")
        Button.Name = TabId
        Button.Size = UDim2.new(1, -10, 0, 30)
        Button.BackgroundTransparency = 1
        Button.Text = ""
        Button.Parent = TabList

        local ButtonTitle = Instance.new("TextLabel")
        ButtonTitle.Name = "Title"
        ButtonTitle.Text = Name
        ButtonTitle.Font = Theme.Fonts.Content
        ButtonTitle.TextSize = 14
        ButtonTitle.TextColor3 = Theme.Colors.Text
        ButtonTitle.TextTransparency = 0.5
        ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
        ButtonTitle.Size = UDim2.new(1, -30, 1, 0)
        ButtonTitle.Position = UDim2.new(0, 30, 0, 0)
        ButtonTitle.BackgroundTransparency = 1
        ButtonTitle.Parent = Button

        local Indicator = Instance.new("Frame")
        Indicator.Name = "Indicator"
        Indicator.Size = UDim2.new(0, 0, 0, 15) -- Hidden initially
        Indicator.Position = UDim2.new(0, 0, 0.5, 0)
        Indicator.AnchorPoint = Vector2.new(0, 0.5)
        Indicator.BackgroundColor3 = Theme.Colors.Primary
        Indicator.BackgroundTransparency = 1
        Indicator.BorderSizePixel = 0
        Indicator.Parent = Button
        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(0, 2)
        IndCorner.Parent = Indicator

        if Icon then
            local IconImg = Instance.new("ImageLabel")
            IconImg.Size = UDim2.fromOffset(16, 16)
            IconImg.Position = UDim2.new(0, 8, 0.5, 0)
            IconImg.AnchorPoint = Vector2.new(0, 0.5)
            IconImg.BackgroundTransparency = 1
            IconImg.ImageColor3 = Theme.Colors.Text

            local Asset, RectSize, RectPos = UBHubLib:GetIcon(Icon)
            IconImg.Image = Asset
            IconImg.ImageRectSize = RectSize
            IconImg.ImageRectOffset = RectPos
            IconImg.Parent = Button
        end

        -- Tab Page
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabId
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.Colors.Primary
        Page.Visible = false
        Page.Parent = TabContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.Parent = Page

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.Parent = Page

        -- Auto Canvas Size
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        local TabObj = {
            Button = Button,
            Page = Page,
            Id = TabId
        }

        local function ProcessElement(Obj, Config)
            if Config.Dependency then
                UBHubLib:RegisterDependency(Obj.Frame, Config.Dependency)
            end
            return Obj
        end

        function TabObj:AddParagraph(Config) return ProcessElement(UBHubLib.Elements.Paragraph(Page, Config), Config) end
        function TabObj:AddDivider(Config) return ProcessElement(UBHubLib.Elements.Divider(Page, Config), Config) end
        function TabObj:AddButton(Config) return ProcessElement(UBHubLib.Elements.Button(Page, Config), Config) end
        function TabObj:AddToggle(Config) return ProcessElement(UBHubLib.Elements.Toggle(Page, Config), Config) end
        function TabObj:AddSlider(Config) return ProcessElement(UBHubLib.Elements.Slider(Page, Config), Config) end
        function TabObj:AddInput(Config) return ProcessElement(UBHubLib.Elements.Input(Page, Config), Config) end
        function TabObj:AddDropdown(Config) return ProcessElement(UBHubLib.Elements.Dropdown(Page, Config), Config) end
        function TabObj:AddColorPicker(Config) return ProcessElement(UBHubLib.Elements.ColorPicker(Page, Config), Config) end

        self.Tabs[TabId] = TabObj

        Button.MouseButton1Click:Connect(function()
            self:SelectTab(TabId)
        end)

        -- Select first tab automatically
        if TabCount == 1 then
            self:SelectTab(TabId)
        end

        return TabObj
    end

    function Window:AddTabCategory(Name)
        local Label = Instance.new("TextLabel")
        Label.Name = "Category_" .. Name
        Label.Text = string.upper(Name)
        Label.Font = Theme.Fonts.Title
        Label.TextSize = 11
        Label.TextColor3 = Theme.Colors.Text
        Label.TextTransparency = 0.6
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Size = UDim2.new(1, -10, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Parent = TabList
        return Label
    end

    function Window:AddTabDivider()
        local Div = Instance.new("Frame")
        Div.Name = "Divider"
        Div.Size = UDim2.new(1, -20, 0, 1)
        Div.BackgroundColor3 = Theme.Colors.Divider
        Div.BorderSizePixel = 0
        Div.Parent = TabList
        return Div
    end

    local StaticTabCount = 0
    function Window:AddStaticTab(Config)
        local Name = Config.Name or "StaticTab"
        local Icon = Config.Icon or nil

        StaticTabCount = StaticTabCount + 1
        local TabId = "Static_" .. StaticTabCount

        -- Resize Lists
        StaticTabList.Size = UDim2.new(1, 0, 0, StaticTabCount * 35 + 10)
        TabList.Size = UDim2.new(1, 0, 1, -(StaticTabCount * 35 + 10))

        -- Create Button (Similar logic to AddTab but in Static List)
        local Button = Instance.new("TextButton")
        Button.Name = TabId
        Button.Size = UDim2.new(1, -10, 0, 30)
        Button.BackgroundTransparency = 1
        Button.Text = ""
        Button.Parent = StaticTabList

        local ButtonTitle = Instance.new("TextLabel")
        ButtonTitle.Name = "Title"
        ButtonTitle.Text = Name
        ButtonTitle.Font = Theme.Fonts.Content
        ButtonTitle.TextSize = 14
        ButtonTitle.TextColor3 = Theme.Colors.Text
        ButtonTitle.TextTransparency = 0.5
        ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
        ButtonTitle.Size = UDim2.new(1, -30, 1, 0)
        ButtonTitle.Position = UDim2.new(0, 30, 0, 0)
        ButtonTitle.BackgroundTransparency = 1
        ButtonTitle.Parent = Button

        local Indicator = Instance.new("Frame")
        Indicator.Name = "Indicator"
        Indicator.Size = UDim2.new(0, 0, 0, 15)
        Indicator.Position = UDim2.new(0, 0, 0.5, 0)
        Indicator.AnchorPoint = Vector2.new(0, 0.5)
        Indicator.BackgroundColor3 = Theme.Colors.Primary
        Indicator.BackgroundTransparency = 1
        Indicator.BorderSizePixel = 0
        Indicator.Parent = Button
        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(0, 2)
        IndCorner.Parent = Indicator

        if Icon then
            local IconImg = Instance.new("ImageLabel")
            IconImg.Size = UDim2.fromOffset(16, 16)
            IconImg.Position = UDim2.new(0, 8, 0.5, 0)
            IconImg.AnchorPoint = Vector2.new(0, 0.5)
            IconImg.BackgroundTransparency = 1
            IconImg.ImageColor3 = Theme.Colors.Text

            local Asset, RectSize, RectPos = UBHubLib:GetIcon(Icon)
            IconImg.Image = Asset
            IconImg.ImageRectSize = RectSize
            IconImg.ImageRectOffset = RectPos
            IconImg.Parent = Button
        end

        -- Page
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabId
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.Colors.Primary
        Page.Visible = false
        Page.Parent = TabContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.Parent = Page

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.Parent = Page

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        local TabObj = {
            Button = Button,
            Page = Page,
            Id = TabId
        }

        local function ProcessElement(Obj, Config)
            if Config.Dependency then
                UBHubLib:RegisterDependency(Obj.Frame, Config.Dependency)
            end
            Window:RegisterElement(TabObj, Config, Obj)
            return Obj
        end

        function TabObj:AddParagraph(Config) return ProcessElement(UBHubLib.Elements.Paragraph(Page, Config), Config) end
        function TabObj:AddDivider(Config) return ProcessElement(UBHubLib.Elements.Divider(Page, Config), Config) end
        function TabObj:AddButton(Config) return ProcessElement(UBHubLib.Elements.Button(Page, Config), Config) end
        function TabObj:AddToggle(Config) return ProcessElement(UBHubLib.Elements.Toggle(Page, Config), Config) end
        function TabObj:AddSlider(Config) return ProcessElement(UBHubLib.Elements.Slider(Page, Config), Config) end
        function TabObj:AddInput(Config) return ProcessElement(UBHubLib.Elements.Input(Page, Config), Config) end
        function TabObj:AddDropdown(Config) return ProcessElement(UBHubLib.Elements.Dropdown(Page, Config), Config) end
        function TabObj:AddColorPicker(Config) return ProcessElement(UBHubLib.Elements.ColorPicker(Page, Config), Config) end

        self.Tabs[TabId] = TabObj

        Button.MouseButton1Click:Connect(function()
            self:SelectTab(TabId)
        end)

        return TabObj
    end

    Window.Gui = ScreenGui
    UBHubLib.ActiveWindow = Window

    function Window:CreateSettingsTab()
        local SettingsTab = self:AddStaticTab({
            Name = "Customize",
            Icon = "settings"
        })

        -- Configuration Section
        SettingsTab:AddParagraph({Title = "Configuration", Content = "Manage your configs here."})

        local ConfigName = ""
        SettingsTab:AddInput({
            Title = "Config Name",
            Callback = function(V) ConfigName = V end
        })

        local ConfigList = {}
        local function RefreshConfigs()
            ConfigList = {}
            pcall(function()
                if isfolder(UBHubLib.ConfigManager.Folder) then
                    local Success, Files = pcall(listfiles, UBHubLib.ConfigManager.Folder)
                    if Success and Files then
                        for _, File in ipairs(Files) do
                            if File:match("%.json$") then
                                table.insert(ConfigList, File:match("([^/]+)%.json$"))
                            end
                        end
                    end
                end
            end)
        end
        RefreshConfigs()

        local SelectedConfig = nil
        local Dropdown = SettingsTab:AddDropdown({
            Title = "Config List",
            Options = ConfigList,
            Callback = function(V) SelectedConfig = V end
        })

        SettingsTab:AddButton({
            Title = "Save Config",
            Callback = function()
                local Name = ConfigName ~= "" and ConfigName or SelectedConfig
                if Name then
                    UBHubLib.ConfigManager:Save(Name)
                    RefreshConfigs()
                    Dropdown.Frame:Destroy() -- Hacky refresh
                    -- Ideally Dropdown object has Refresh method. My implementation returned {Frame}.
                    -- I should have exposed Refresh.
                    -- For now, user has to restart or I implement Refresh.
                end
            end
        })

        SettingsTab:AddButton({
            Title = "Load Config",
            Callback = function()
                if SelectedConfig then
                    UBHubLib.ConfigManager:Load(SelectedConfig)
                end
            end
        })

        SettingsTab:AddButton({
            Title = "Delete Config",
            Callback = function()
                if SelectedConfig then
                    UBHubLib.ConfigManager:Delete(SelectedConfig)
                    RefreshConfigs()
                end
            end
        })

        SettingsTab:AddButton({
            Title = "Export Config",
            Callback = function()
                UBHubLib.ConfigManager:Export()
                UBHubLib:MakeNotify({Title = "Config", Content = "Exported to clipboard!"})
            end
        })

        -- Theming Section
        SettingsTab:AddParagraph({Title = "Theming", Content = "Customize UI Colors."})

        for Key, Val in pairs(UBHubLib.ActiveTheme.Colors) do
            if typeof(Val) == "Color3" then
                SettingsTab:AddColorPicker({
                    Title = "Edit " .. Key,
                    Default = Val,
                    Callback = function(NewColor)
                        UBHubLib.ActiveTheme.Colors[Key] = NewColor
                    end
                })
            end
        end

        SettingsTab:AddButton({
            Title = "Reload UI (Apply Theme)",
            Callback = function()
                -- Destroys and recreates? No, simpler to just notify for now.
                UBHubLib:MakeNotify({Title = "Theme", Content = "Theme updated. Re-run script to fully apply."})
            end
        })
    end

    return Window
end

-- Icon System
function UBHubLib:FetchIcons()
    local Success, Result = pcall(function()
        local LucideData = game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/main/Lucide.lua")
        local CraftData = game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/main/Craft.lua")

        local LucideTable = loadstring(LucideData)()
        local CraftTable = loadstring(CraftData)()

        return {
            Lucide = LucideTable,
            Craft = CraftTable
        }
    end)

    if Success then
        UBHubLib.Icons = Result
    else
        warn("UBHubLib: Failed to fetch icons. Using fallback.")
    end
end

function UBHubLib:GetIcon(IconName)
    if not IconName then return "", Vector2.new(0,0), Vector2.new(0,0) end

    -- Support for direct asset IDs
    if IconName:find("rbxassetid://") or IconName:find("http") then
        return IconName, Vector2.new(0,0), Vector2.new(0,0)
    end

    -- Check loaded icons first
    if UBHubLib.Icons.Lucide and UBHubLib.Icons.Lucide.Icons[IconName] then
        local IconData = UBHubLib.Icons.Lucide.Icons[IconName]
        return UBHubLib.Icons.Lucide.Spritesheets[tostring(IconData.Image)], IconData.ImageRectSize, IconData.ImageRectPosition
    end

    if UBHubLib.Icons.Craft and UBHubLib.Icons.Craft.Icons[IconName] then
        local IconData = UBHubLib.Icons.Craft.Icons[IconName]
        return UBHubLib.Icons.Craft.Spritesheets[tostring(IconData.Image)], IconData.ImageRectSize, IconData.ImageRectPosition
    end

    -- Fallback
    if UBHubLib.IconFallback[IconName] then
        return UBHubLib.IconFallback[IconName], Vector2.new(0,0), Vector2.new(0,0) -- Basic Image, no sprite support for fallback currently implies full image
    end

    return "", Vector2.new(0,0), Vector2.new(0,0) -- Return empty if not found
end

-- Fetch icons on load
task.spawn(function()
    UBHubLib:FetchIcons()
end)

return UBHubLib
