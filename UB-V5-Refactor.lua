local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

--// Library Core Table
local Library = {}

--// Services & Utils
local Services = {
	UserInputService = UserInputService,
	TweenService = TweenService,
	RunService = RunService,
	HttpService = HttpService,
	Players = Players,
	CoreGui = CoreGui
}

--// Icon Data
local IconData = {
    Lucide = { Spritesheets = {}, Icons = {} },
    Craft = { Spritesheets = {}, Icons = {} }
}

-- Fetch Icons
task.spawn(function()
    local function fetch(url)
        local s, r = pcall(game.HttpGet, game, url)
        if s then return HttpService:JSONDecode(r) end
        return nil
    end

    -- Attempt to load cached
    local path = "UBHub_Config/Icons.json"
    if isfile(path) then
        local saved = HttpService:JSONDecode(readfile(path))
        if saved then IconData = saved return end
    end

    -- Fetch from source (Example URLs based on typical WindUI distribution)
    -- In a real environment, these would point to the specific raw files.
    -- Placeholder logic for fetching:
    local lucideData = fetch("https://raw.githubusercontent.com/zryr/Libraries/refs/heads/ules/Icons/Lucide.json")
    if lucideData then IconData.Lucide = lucideData end

    local craftData = fetch("https://raw.githubusercontent.com/zryr/Libraries/refs/heads/ules/Icons/Craft.json")
    if craftData then IconData.Craft = craftData end

    if not isfolder("UBHub_Config") then makefolder("UBHub_Config") end
    writefile(path, HttpService:JSONEncode(IconData))
end)

--// Themes
Library.Themes = {
	Dark = {
		Name = "Dark",
		Accent = Color3.fromRGB(255, 80, 0),
		Background = Color3.fromRGB(20, 8, 0),
		Text = Color3.fromRGB(255, 240, 230),
		Placeholder = Color3.fromRGB(150, 150, 150),
		Outline = Color3.fromRGB(80, 20, 0),
		Secondary = Color3.fromRGB(160, 30, 0),
		Dialog = Color3.fromRGB(25, 10, 5),
		Button = Color3.fromRGB(40, 15, 5),
		Icon = Color3.fromRGB(200, 200, 200),
	},
}
Library.Theme = Library.Themes.Dark
Library.Flags = {}

--// Font Manager
Library.FontManager = {}
Library.FontManager.Font = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

function Library.FontManager:UpdateFont(fontId)
	Library.FontManager.Font = Font.new(fontId, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

--// Icon System
function Library:GetIcon(name, libraryName)
    libraryName = libraryName or "Lucide"
    local libData = IconData[libraryName]
    if not libData then return nil end

    local iconInfo = libData.Icons[name]
    if not iconInfo then
        -- Return default/fallback
        return {
            Image = "rbxassetid://131526378523863",
            ImageRectOffset = Vector2.new(0,0),
            ImageRectSize = Vector2.new(96,96)
        }
    end

    -- Support different formats (WindUI often uses {Sheet, Scale, Position})
    -- Assuming parsed data format:
    local sheetId = tostring(iconInfo[1]) or "1"
    local x = iconInfo[2] or 0
    local y = iconInfo[3] or 0
    local size = 96 -- Default sprite size usually

    return {
        Image = libData.Spritesheets[sheetId] or "rbxassetid://131526378523863",
        ImageRectOffset = Vector2.new(x, y),
        ImageRectSize = Vector2.new(size, size)
    }
end

--// Config Manager
Library.ConfigManager = {
    Folder = "UBHub_Config",
    Mode = "Legacy",
    CurrentConfig = "default"
}

function Library.ConfigManager:LoadSettings()
    if not isfolder(self.Folder) then makefolder(self.Folder) end
    local path = self.Folder .. "/window_settings.json"
    if isfile(path) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if success then
            self.CurrentConfig = data.LastConfig or "default"
            self.Mode = data.Mode or "Legacy"
        end
    end
end

function Library.ConfigManager:SaveSettings()
    if not isfolder(self.Folder) then makefolder(self.Folder) end
    local path = self.Folder .. "/window_settings.json"
    writefile(path, HttpService:JSONEncode({
        LastConfig = self.CurrentConfig,
        Mode = self.Mode
    }))
end

function Library.ConfigManager:Save(name)
    if not isfolder(self.Folder) then makefolder(self.Folder) end
    name = name or self.CurrentConfig
    self.CurrentConfig = name
    self:SaveSettings() -- Update last config

    local path = self.Folder .. "/" .. name .. ".json"

    local data = { Flags = {}, QuickToggles = {} }

    -- Save Flags
    for flag, element in pairs(Library.Flags) do
        data.Flags[flag] = element.Value
    end

    -- Save QuickToggle Positions
    for _, qt in ipairs(Library.QuickToggles) do
        if qt.Button and qt.Button.Parent then
             -- Store based on... we need an identifier.
             -- QuickToggles in the table are just {Button = obj}.
             -- We need to link them to their Flag/Title.
             -- We'll modify the insertion logic to include an ID.
             if qt.ID then
                 data.QuickToggles[qt.ID] = {
                     X = qt.Button.Position.X.Offset,
                     Y = qt.Button.Position.Y.Offset,
                     Size = qt.Button.Size.X.Offset
                 }
             end
        end
    end

    writefile(path, HttpService:JSONEncode(data))
end

function Library.ConfigManager:Load(name)
    name = name or self.CurrentConfig
    local path = self.Folder .. "/" .. name .. ".json"
    if not isfile(path) then return end

    self.CurrentConfig = name
    self:SaveSettings()

    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)

    if success then
        -- Handle new data format or legacy
        local flags = result.Flags or result -- Fallback if legacy flat file

        for flag, value in pairs(flags) do
            if Library.Flags[flag] and Library.Flags[flag].Set then
                Library.Flags[flag]:Set(value)
            end
        end

        -- Load QuickToggle layouts
        if result.QuickToggles then
            Library.QuickToggleLayouts = result.QuickToggles
            -- Apply to existing
            for _, qt in ipairs(Library.QuickToggles) do
                if qt.ID and Library.QuickToggleLayouts[qt.ID] then
                    local layout = Library.QuickToggleLayouts[qt.ID]
                    qt.Button.Position = UDim2.fromOffset(layout.X, layout.Y)
                    qt.Button.Size = UDim2.fromOffset(layout.Size, layout.Size)
                end
            end
        end
    end
end

function Library.ConfigManager:OnFlagChange()
    if self.Mode == "Legacy" then
        self:Save()
    end
end

--// Utility Functions
Library.Utils = {}

function Library.Utils:Tween(object, info, properties)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function Library.Utils:GetColor(colorInput)
    if typeof(colorInput) == "ColorSequence" then
        return colorInput.Keypoints[1].Value
    end
    return colorInput
end

--// Notification System
Library.SeenNotifications = {}

function Library:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or "Content"
    local duration = config.Duration or 5
    local icon = config.Icon or "info"
    local oneTime = config.OneTime or false

    if oneTime then
        if Library.SeenNotifications[title .. content] then return end
        Library.SeenNotifications[title .. content] = true
    end

    local notifGui = Services.CoreGui:FindFirstChild("UBHubRefactor_Notify")
    if not notifGui then
        notifGui = Instance.new("ScreenGui")
        notifGui.Name = "UBHubRefactor_Notify"
        notifGui.Parent = Services.CoreGui
        notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        notifGui.IgnoreGuiInset = true
    end

    local container = notifGui:FindFirstChild("Container")
    if not container then
        container = Instance.new("Frame")
        container.Name = "Container"
        container.Size = UDim2.new(0, 300, 1, 0)
        container.Position = UDim2.new(1, -320, 0, 20)
        container.BackgroundTransparency = 1
        container.Parent = notifGui

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 10)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Parent = container
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.BackgroundColor3 = Library.Theme.Dialog
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Library.Theme.Outline
    stroke.Thickness = 1
    stroke.Parent = frame

    if config.BackgroundImage then
        local bg = Instance.new("ImageLabel")
        bg.Size = UDim2.fromScale(1, 1)
        bg.BackgroundTransparency = 1
        bg.Image = config.BackgroundImage
        bg.ImageTransparency = 0.8
        bg.ScaleType = Enum.ScaleType.Slice
        bg.SliceCenter = Rect.new(100, 100, 100, 100)
        bg.Parent = frame
    end

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0, 0)
    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
    contentFrame.BackgroundTransparency = 1
    contentFrame.Position = UDim2.fromOffset(10, 10)
    contentFrame.Parent = frame

    if icon then
        local iconData = Library:GetIcon(icon, "Lucide")
        if iconData then
            local iconImg = Instance.new("ImageLabel")
            iconImg.Size = UDim2.fromOffset(20, 20)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = iconData.Image
            iconImg.ImageRectOffset = iconData.ImageRectOffset
            iconImg.ImageRectSize = iconData.ImageRectSize
            iconImg.ImageColor3 = Library.Theme.Accent
            iconImg.Parent = contentFrame
        end
    end

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Library.Theme.Text
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Size = UDim2.new(1, -30, 0, 20)
    titleLabel.Position = UDim2.fromOffset(30, 0)
    titleLabel.Parent = contentFrame

    local descLabel = Instance.new("TextLabel")
    descLabel.Text = content
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextColor3 = Library.Theme.Text
    descLabel.TextTransparency = 0.4
    descLabel.BackgroundTransparency = 1
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Size = UDim2.new(1, -30, 0, 0)
    descLabel.AutomaticSize = Enum.AutomaticSize.Y
    descLabel.Position = UDim2.fromOffset(30, 20)
    descLabel.Parent = contentFrame

    task.spawn(function()
        local targetHeight = contentFrame.AbsoluteSize.Y + 20
        Library.Utils:Tween(frame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, targetHeight)})

        task.wait(duration)

        local tween = Library.Utils:Tween(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)})
        tween.Completed:Wait()
        frame:Destroy()
    end)
end

--// UI Construction
function Library:CreateWindow(config)
    config = config or {}
    local window = {
        Title = config.Title or "UI Library",
        Author = config.Author or "Author",
        Icon = config.Icon or nil,
        IconLibrary = config.IconLibrary or "Lucide",
        Folder = config.Folder or "UBHub_Config",
        Transparent = config.Transparent or false,
        Size = config.Size or UDim2.fromOffset(580, 460),
        Tabs = {},
        ActiveTab = nil,
        IsEditMode = false,
    }

    Library.ConfigManager.Folder = window.Folder

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UBHubRefactor"
    screenGui.Parent = Services.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true

    window.ScreenGui = screenGui

    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = game:GetService("Lighting")
    window.Blur = blur

    local overlayFrame = Instance.new("Frame")
    overlayFrame.Name = "Overlay"
    overlayFrame.BackgroundTransparency = 1
    overlayFrame.Size = UDim2.fromScale(1, 1)
    overlayFrame.ZIndex = 100
    overlayFrame.Parent = screenGui
    window.Overlay = overlayFrame

    local searchOverlay = Instance.new("Frame")
    searchOverlay.Name = "SearchOverlay"
    searchOverlay.BackgroundColor3 = Color3.new(0,0,0)
    searchOverlay.BackgroundTransparency = 0.5
    searchOverlay.Size = UDim2.fromScale(1, 1)
    searchOverlay.Visible = false
    searchOverlay.Parent = overlayFrame

    local searchContainer = Instance.new("Frame")
    searchContainer.Name = "Container"
    searchContainer.Size = UDim2.fromOffset(600, 400)
    searchContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    searchContainer.Position = UDim2.fromScale(0.5, 0.5)
    searchContainer.BackgroundColor3 = Library.Theme.Background
    searchContainer.Parent = searchOverlay

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchContainer

    window.SearchOverlay = searchOverlay
    window.SearchContainer = searchContainer

    -- Search Components
    local searchInputFrame = Instance.new("Frame")
    searchInputFrame.Size = UDim2.new(1, -40, 0, 40)
    searchInputFrame.Position = UDim2.fromOffset(20, 20)
    searchInputFrame.BackgroundColor3 = Library.Theme.Button
    searchInputFrame.Parent = searchContainer

    local searchInputCorner = Instance.new("UICorner")
    searchInputCorner.CornerRadius = UDim.new(0, 6)
    searchInputCorner.Parent = searchInputFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -40, 1, 0)
    searchBox.Position = UDim2.fromOffset(10, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search for features..."
    searchBox.TextColor3 = Library.Theme.Text
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchInputFrame

    local searchResults = Instance.new("ScrollingFrame")
    searchResults.Size = UDim2.new(1, -40, 1, -80)
    searchResults.Position = UDim2.fromOffset(20, 70)
    searchResults.BackgroundTransparency = 1
    searchResults.ScrollBarThickness = 2
    searchResults.Parent = searchContainer

    local resultLayout = Instance.new("UIListLayout")
    resultLayout.Padding = UDim.new(0, 5)
    resultLayout.Parent = searchResults

    -- Search Logic
    if not Library.Registry then Library.Registry = {} end

    local function performSearch(query)
        for _, child in ipairs(searchResults:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        if query == "" then return end

        query = query:lower()
        local matches = {}

        for _, item in ipairs(Library.Registry) do
            local score = 0
            local title = item.Title:lower()

            if title == query then
                score = 100
            elseif title:sub(1, #query) == query then
                score = 80
            elseif title:find(query) then
                score = 60
            end

            if score > 0 then
                table.insert(matches, {Data = item, Score = score})
            end
        end

        table.sort(matches, function(a, b) return a.Score > b.Score end)

        for i, match in ipairs(matches) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Library.Theme.Secondary
            btn.BackgroundTransparency = 1 -- Start hidden
            btn.Text = ""
            btn.Parent = searchResults

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Text = match.Data.Title .. " (" .. match.Data.Tab .. ")"
            titleLbl.Size = UDim2.new(1, -10, 1, 0)
            titleLbl.Position = UDim2.fromOffset(10, 0)
            titleLbl.BackgroundTransparency = 1
            titleLbl.TextColor3 = Library.Theme.Text
            titleLbl.Font = Enum.Font.Gotham
            titleLbl.TextSize = 14
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.Parent = btn

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                -- Switch Tab
                for _, tabData in ipairs(window.Tabs) do
                    if tabData.Button.Name == match.Data.Tab then
                         tabData.Button.MouseButton1Click:Fire() -- Simulate click if possible, or reuse logic
                         -- Since Fire() isn't standard, we use the click handler we bound.
                         -- Actually, we can't easily fire the event object.
                         -- We'll rely on the fact that we stored the object logic or just manually trigger visibility.
                         -- Re-implementing basic switch logic here for safety:

                         if window.ActiveTab then
                             Library.Utils:Tween(window.ActiveTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1})
                             Library.Utils:Tween(window.ActiveTab.Label, TweenInfo.new(0.2), {TextTransparency = 0.4})
                             window.ActiveTab.Content.Visible = false
                         end

                         window.ActiveTab = tabData
                         Library.Utils:Tween(tabData.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, BackgroundColor3 = Library.Theme.Text})
                         Library.Utils:Tween(tabData.Label, TweenInfo.new(0.2), {TextTransparency = 0})
                         tabData.Content.Visible = true
                    end
                end
                window.SearchOverlay.Visible = false
                Library.Utils:Tween(window.Blur, TweenInfo.new(0.3), {Size = 0})
            end)

            -- Cascade Animation
            task.delay(0.05 * i, function()
                 if btn and btn.Parent then
                     Library.Utils:Tween(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0})
                 end
            end)
        end

        searchResults.CanvasSize = UDim2.new(0, 0, 0, resultLayout.AbsoluteContentSize.Y)
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        performSearch(searchBox.Text)
    end)

    -- Resize Panel (Hidden)
    local resizePanel = Instance.new("Frame")
    resizePanel.Name = "ResizePanel"
    resizePanel.Size = UDim2.fromOffset(200, 80)
    resizePanel.Position = UDim2.new(0.5, 0, 0.8, 0)
    resizePanel.AnchorPoint = Vector2.new(0.5, 0.5)
    resizePanel.BackgroundColor3 = Library.Theme.Dialog
    resizePanel.Visible = false
    resizePanel.Parent = overlayFrame

    local resizeCorner = Instance.new("UICorner")
    resizeCorner.CornerRadius = UDim.new(0, 8)
    resizeCorner.Parent = resizePanel

    local resizeStroke = Instance.new("UIStroke")
    resizeStroke.Color = Library.Theme.Outline
    resizeStroke.Thickness = 1
    resizeStroke.Parent = resizePanel

    local resizeLabel = Instance.new("TextLabel")
    resizeLabel.Text = "Resize Quick Toggle"
    resizeLabel.Size = UDim2.new(1, 0, 0, 20)
    resizeLabel.BackgroundTransparency = 1
    resizeLabel.TextColor3 = Library.Theme.Text
    resizeLabel.Font = Enum.Font.GothamBold
    resizeLabel.TextSize = 14
    resizeLabel.Parent = resizePanel

    local resizeSliderContainer = Instance.new("Frame")
    resizeSliderContainer.Size = UDim2.new(0.8, 0, 0, 20)
    resizeSliderContainer.Position = UDim2.new(0.1, 0, 0.5, 0)
    resizeSliderContainer.BackgroundColor3 = Library.Theme.Secondary
    resizeSliderContainer.Parent = resizePanel

    local resizeSliderCorner = Instance.new("UICorner")
    resizeSliderCorner.CornerRadius = UDim.new(0, 4)
    resizeSliderCorner.Parent = resizeSliderContainer

    local resizeSliderFill = Instance.new("Frame")
    resizeSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    resizeSliderFill.BackgroundColor3 = Library.Theme.Accent
    resizeSliderFill.Parent = resizeSliderContainer

    local resizeSliderFillCorner = Instance.new("UICorner")
    resizeSliderFillCorner.CornerRadius = UDim.new(0, 4)
    resizeSliderFillCorner.Parent = resizeSliderFill

    local resizeInput = Instance.new("TextBox")
    resizeInput.Size = UDim2.new(0, 30, 0, 20)
    resizeInput.Position = UDim2.new(0.9, 5, 0.5, 0)
    resizeInput.AnchorPoint = Vector2.new(0, 0.5)
    resizeInput.BackgroundColor3 = Library.Theme.Secondary
    resizeInput.Text = "55"
    resizeInput.TextColor3 = Library.Theme.Text
    resizeInput.Font = Enum.Font.Gotham
    resizeInput.TextSize = 12
    resizeInput.Parent = resizePanel

    local riCorner = Instance.new("UICorner")
    riCorner.CornerRadius = UDim.new(0, 4)
    riCorner.Parent = resizeInput

    window.ResizePanel = resizePanel
    window.ResizeSlider = resizeSliderContainer
    window.ResizeFill = resizeSliderFill

    -- Resize Logic
    local resizeDragging = false
    local function updateResize(input)
         if not window.SelectedQuickToggle then return end
         local sliderX = resizeSliderContainer.AbsolutePosition.X
         local sliderW = resizeSliderContainer.AbsoluteSize.X
         local percent = math.clamp((input.Position.X - sliderX) / sliderW, 0, 1)

         resizeSliderFill.Size = UDim2.new(percent, 0, 1, 0)

         -- Scale size from 30px to 80px
         local newSize = math.floor(30 + (50 * percent))
         window.SelectedQuickToggle.Size = UDim2.fromOffset(newSize, newSize)
         resizeInput.Text = tostring(newSize)
    end

    resizeInput.FocusLost:Connect(function()
        if not window.SelectedQuickToggle then return end
        local num = tonumber(resizeInput.Text)
        if num then
            num = math.clamp(num, 30, 80)
            local percent = (num - 30) / 50
            resizeSliderFill.Size = UDim2.new(percent, 0, 1, 0)
            window.SelectedQuickToggle.Size = UDim2.fromOffset(num, num)
            resizeInput.Text = tostring(num)
        end
    end)

    resizeSliderContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizeDragging = true
            updateResize(input)
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(input)
        if resizeDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateResize(input)
        end
    end)

    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizeDragging = false
        end
    end)

    -- Quick Toggle Container
    local quickToggleGui = Instance.new("ScreenGui")
    quickToggleGui.Name = "UBHubRefactor_QuickToggles"
    quickToggleGui.Parent = Services.CoreGui
    quickToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    window.QuickToggleGui = quickToggleGui

    -- Global Quick Toggle Table
    Library.QuickToggles = {}

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Size = window.Size
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Library.Theme.Background
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Library.Theme.Outline
    mainStroke.Thickness = 1
    mainStroke.Parent = mainFrame

    window.MainFrame = mainFrame

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = window.Title
    titleLabel.Font = Library.FontManager.Font.Family
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Library.Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.fromOffset(15, 0)
    titleLabel.Parent = topBar

    if window.Icon then
        local iconData = Library:GetIcon(window.Icon, window.IconLibrary)
        if iconData then
             titleLabel.Position = UDim2.fromOffset(40, 0)
             local iconImg = Instance.new("ImageLabel")
             iconImg.Size = UDim2.fromOffset(20, 20)
             iconImg.Position = UDim2.new(0, 12, 0.5, 0)
             iconImg.AnchorPoint = Vector2.new(0, 0.5)
             iconImg.BackgroundTransparency = 1
             iconImg.Image = iconData.Image
             iconImg.ImageRectOffset = iconData.ImageRectOffset
             iconImg.ImageRectSize = iconData.ImageRectSize
             iconImg.ImageColor3 = Library.Theme.Icon
             iconImg.Parent = topBar
        end
    end

    local function createTopButton(name, iconName, callback)
        local btn = Instance.new("ImageButton")
        btn.Name = name
        btn.Size = UDim2.fromOffset(30, 30)
        btn.BackgroundTransparency = 1
        btn.AnchorPoint = Vector2.new(1, 0.5)

        local icon = Library:GetIcon(iconName, "Lucide")
        if icon then
            btn.Image = icon.Image
            btn.ImageRectOffset = icon.ImageRectOffset
            btn.ImageRectSize = icon.ImageRectSize
            btn.ImageColor3 = Library.Theme.Icon
        end

        local highlight = Instance.new("Frame")
        highlight.Size = UDim2.fromScale(1, 1)
        highlight.BackgroundColor3 = Library.Theme.Text
        highlight.BackgroundTransparency = 0.9
        highlight.Visible = false
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = highlight
        highlight.Parent = btn

        btn.MouseEnter:Connect(function() highlight.Visible = true end)
        btn.MouseLeave:Connect(function() highlight.Visible = false end)
        btn.MouseButton1Click:Connect(callback)

        return btn
    end

    local searchBtn = createTopButton("Search", "search", function()
        window.SearchOverlay.Visible = not window.SearchOverlay.Visible
        if window.SearchOverlay.Visible then
             Library.Utils:Tween(window.Blur, TweenInfo.new(0.3), {Size = 24})
        else
             Library.Utils:Tween(window.Blur, TweenInfo.new(0.3), {Size = 0})
        end
    end)
    searchBtn.Position = UDim2.new(1, -10, 0.5, 0)
    searchBtn.Parent = topBar

    local editBtn = createTopButton("Edit", "pencil", function()
        window.IsEditMode = not window.IsEditMode
        if window.IsEditMode then
             Library.Utils:Tween(window.Blur, TweenInfo.new(0.5), {Size = 15})
             -- Enable dragging for all quick toggles
             for _, toggleData in pairs(Library.QuickToggles) do
                 if toggleData.Button then
                     toggleData.Button.Active = true
                     toggleData.Button.Draggable = true
                     toggleData.Button.BackgroundTransparency = 0.5
                 end
             end
        else
             Library.Utils:Tween(window.Blur, TweenInfo.new(0.5), {Size = 0})
             -- Disable dragging
             window.ResizePanel.Visible = false
             for _, toggleData in pairs(Library.QuickToggles) do
                 if toggleData.Button then
                     toggleData.Button.Active = true -- Keep clickable
                     toggleData.Button.Draggable = false
                     toggleData.Button.BackgroundTransparency = 0
                     -- Save position/size (Mock save)
                 end
             end
        end
    end)
    editBtn.Position = UDim2.new(1, -45, 0.5, 0)
    editBtn.Parent = topBar

    local sideBarWidth = 160
    local sideBar = Instance.new("Frame")
    sideBar.Name = "SideBar"
    sideBar.Size = UDim2.new(0, sideBarWidth, 1, -80) -- Adjusted for static tab
    sideBar.Position = UDim2.fromOffset(0, 40)
    sideBar.BackgroundTransparency = 1
    sideBar.Parent = mainFrame

    -- Static Tab Container
    local staticTabContainer = Instance.new("Frame")
    staticTabContainer.Name = "StaticTabs"
    staticTabContainer.Size = UDim2.new(0, sideBarWidth, 0, 40)
    staticTabContainer.Position = UDim2.new(0, 0, 1, -40)
    staticTabContainer.BackgroundTransparency = 1
    staticTabContainer.Parent = mainFrame

    local staticPadding = Instance.new("UIPadding")
    staticPadding.PaddingLeft = UDim.new(0, 10)
    staticPadding.PaddingRight = UDim.new(0, 10) -- Match sidebar padding?
    staticPadding.Parent = staticTabContainer

    local sideBarList = Instance.new("UIListLayout")
    sideBarList.Padding = UDim.new(0, 5)
    sideBarList.SortOrder = Enum.SortOrder.LayoutOrder
    sideBarList.Parent = sideBar

    local sideBarPadding = Instance.new("UIPadding")
    sideBarPadding.PaddingLeft = UDim.new(0, 10)
    sideBarPadding.PaddingTop = UDim.new(0, 10)
    sideBarPadding.Parent = sideBar

    window.SideBar = sideBar

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -sideBarWidth, 1, -40)
    contentFrame.Position = UDim2.fromOffset(sideBarWidth, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    window.ContentFrame = contentFrame

    local function makeDraggable(clickObj, moveObj)
        local dragging, dragInput, dragStart, startPos

        clickObj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = moveObj.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        clickObj.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        Services.UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                Library.Utils:Tween(moveObj, TweenInfo.new(0.05), {
                    Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                })
            end
        end)
    end
    makeDraggable(topBar, mainFrame)

    function window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or nil

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName
        tabBtn.Size = UDim2.new(1, -10, 0, 32)
        tabBtn.BackgroundColor3 = Library.Theme.Background
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = ""
        tabBtn.Parent = window.SideBar

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn

        local btnLabel = Instance.new("TextLabel")
        btnLabel.Text = tabName
        btnLabel.Font = Library.FontManager.Font.Family
        btnLabel.TextSize = 14
        btnLabel.TextColor3 = Library.Theme.Text
        btnLabel.TextTransparency = 0.4
        btnLabel.Size = UDim2.new(1, -30, 1, 0)
        btnLabel.Position = UDim2.fromOffset(30, 0)
        btnLabel.BackgroundTransparency = 1
        btnLabel.TextXAlignment = Enum.TextXAlignment.Left
        btnLabel.Parent = tabBtn

        if tabIcon then
            local iconData = Library:GetIcon(tabIcon, "Lucide")
            if iconData then
                 local iconImg = Instance.new("ImageLabel")
                 iconImg.Size = UDim2.fromOffset(18, 18)
                 iconImg.Position = UDim2.new(0, 6, 0.5, 0)
                 iconImg.AnchorPoint = Vector2.new(0, 0.5)
                 iconImg.BackgroundTransparency = 1
                 iconImg.Image = iconData.Image
                 iconImg.ImageRectOffset = iconData.ImageRectOffset
                 iconImg.ImageRectSize = iconData.ImageRectSize
                 iconImg.ImageColor3 = Library.Theme.Icon
                 iconImg.ImageTransparency = 0.4
                 iconImg.Parent = tabBtn
            end
        end

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "_Content"
        tabContent.Size = UDim2.fromScale(1, 1)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 2
        tabContent.ScrollBarImageColor3 = Library.Theme.Accent
        tabContent.Visible = false
        tabContent.Parent = window.ContentFrame

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 10)
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.Parent = tabContent

        local function selectTab()
             if window.ActiveTab then
                 Library.Utils:Tween(window.ActiveTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1})
                 Library.Utils:Tween(window.ActiveTab.Label, TweenInfo.new(0.2), {TextTransparency = 0.4})
                 window.ActiveTab.Content.Visible = false
             end

             window.ActiveTab = {Button = tabBtn, Label = btnLabel, Content = tabContent}
             Library.Utils:Tween(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, BackgroundColor3 = Library.Theme.Text})
             Library.Utils:Tween(btnLabel, TweenInfo.new(0.2), {TextTransparency = 0})
             tabContent.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(selectTab)

        if #window.Tabs == 0 then
            selectTab()
        end

        table.insert(window.Tabs, {Button = tabBtn, Content = tabContent, Name = tabName})

        return Library:CreateTabLib(tabContent, tabName)
    end

    function Library:CreateTabLib(tabContent, tabName)
        local TabLib = {}

        function TabLib:Create(title) return self end -- chaining placeholder

        -- Register Helper
        local function registerElement(title, elementObj)
             if tabName and Library.Registry then
                 table.insert(Library.Registry, {
                     Title = title,
                     Tab = tabName,
                     Object = elementObj
                 })
             end
        end

        -- Dependency Helper
        local function checkDependencies(element, dependencies)
             if not dependencies then return end
             -- dependencies: { Flag = "FlagName", Value = requiredValue, Property = "Visible"|"Locked" }

             local flagName = dependencies.Flag or dependencies.Element -- Support both
             local requiredValue = dependencies.Value
             local property = dependencies.Property or "Visible"

             local function update(val)
                 local match = (val == requiredValue)
                 if property == "Visible" then
                     element.Visible = match
                 elseif property == "Locked" then
                     if element:IsA("GuiObject") then
                         if match then
                             -- Lock it
                             element.Active = false
                             element.BackgroundTransparency = 0.8
                         else
                             -- Unlock
                             element.Active = true
                             element.BackgroundTransparency = 0.5
                         end
                     end
                 end
             end

             task.spawn(function()
                 while not Library.Flags[flagName] do task.wait(0.1) end
                 local flagObj = Library.Flags[flagName]

                 if flagObj.Changed then
                     flagObj.Changed.Event:Connect(update)
                 end
                 update(flagObj.Value)
             end)
        end

        -- Element: Divider
        function TabLib:AddTabDivider()
            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, -20, 0, 1)
            div.BackgroundColor3 = Library.Theme.Outline
            div.BorderSizePixel = 0
            div.Parent = tabContent

            local p = Instance.new("UIPadding") -- add spacing via padding container or just margin
            -- actually standard flow
            local spacer = Instance.new("Frame")
            spacer.Size = UDim2.new(1, 0, 0, 10)
            spacer.BackgroundTransparency = 1
            spacer.Parent = tabContent
            div.Parent = spacer
            div.Position = UDim2.new(0, 10, 0.5, 0)
            div.Size = UDim2.new(1, -20, 0, 1)
            return TabLib
        end

        -- Element: Section
        function TabLib:AddSection(title)
            local sectionBtn = Instance.new("TextButton")
            sectionBtn.Size = UDim2.new(1, -10, 0, 30)
            sectionBtn.BackgroundTransparency = 1
            sectionBtn.Text = ""
            sectionBtn.Parent = tabContent

            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Text = title
            sectionLabel.Size = UDim2.new(1, 0, 1, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.TextColor3 = Library.Theme.Text
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextSize = 14
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = sectionBtn

            local underline = Instance.new("Frame")
            underline.Size = UDim2.new(0, 0, 0, 2)
            underline.Position = UDim2.new(0, 0, 1, -2)
            underline.BackgroundColor3 = Library.Theme.Accent
            underline.BorderSizePixel = 0
            underline.Parent = sectionBtn

            local isOpen = false

            sectionBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                -- Animate underline
                Library.Utils:Tween(underline, TweenInfo.new(0.3), {
                    Size = isOpen and UDim2.new(1, 0, 0, 2) or UDim2.new(0, 0, 0, 2)
                })

                -- In a full implementation, this would toggle visibility of elements belonging to this section.
                -- Since TabLib structure is flat, we treat this purely as a visual indicator per requirement.
            end)

            return TabLib
        end

        -- Element: Paragraph
        function TabLib:AddParagraph(config)
            config = config or {}
            local title = config.Title or "Paragraph"
            local content = config.Content or "Content"
            local image = config.Image
            local buttons = config.Buttons

            local paraFrame = Instance.new("Frame")
            paraFrame.Size = UDim2.new(1, -10, 0, 0) -- Auto height
            paraFrame.AutomaticSize = Enum.AutomaticSize.Y
            paraFrame.BackgroundColor3 = Library.Theme.Secondary
            paraFrame.BackgroundTransparency = 0.8
            paraFrame.Parent = tabContent

            local paraCorner = Instance.new("UICorner")
            paraCorner.CornerRadius = UDim.new(0, 6)
            paraCorner.Parent = paraFrame

            local paraPadding = Instance.new("UIPadding")
            paraPadding.PaddingTop = UDim.new(0, 10)
            paraPadding.PaddingBottom = UDim.new(0, 10)
            paraPadding.PaddingLeft = UDim.new(0, 10)
            paraPadding.PaddingRight = UDim.new(0, 10)
            paraPadding.Parent = paraFrame

            local contentOffset = 0

            if image then
                 local imgLabel = Instance.new("ImageLabel")
                 imgLabel.Size = UDim2.fromOffset(40, 40)
                 imgLabel.Position = UDim2.fromOffset(0, 0)
                 imgLabel.BackgroundTransparency = 1
                 imgLabel.Image = image
                 imgLabel.Parent = paraFrame
                 contentOffset = 50
            end

            local paraTitle = Instance.new("TextLabel")
            paraTitle.Text = title
            paraTitle.Font = Enum.Font.GothamBold
            paraTitle.TextSize = 14
            paraTitle.TextColor3 = Library.Theme.Text
            paraTitle.TextXAlignment = Enum.TextXAlignment.Left
            paraTitle.BackgroundTransparency = 1
            paraTitle.Size = UDim2.new(1, -contentOffset, 0, 20)
            paraTitle.Position = UDim2.fromOffset(contentOffset, 0)
            paraTitle.Parent = paraFrame

            local paraContent = Instance.new("TextLabel")
            paraContent.Text = content
            paraContent.Font = Enum.Font.Gotham
            paraContent.TextSize = 12
            paraContent.TextColor3 = Library.Theme.Text
            paraContent.TextTransparency = 0.4
            paraContent.TextXAlignment = Enum.TextXAlignment.Left
            paraContent.TextWrapped = true
            paraContent.BackgroundTransparency = 1
            paraContent.Size = UDim2.new(1, -contentOffset, 0, 0)
            paraContent.AutomaticSize = Enum.AutomaticSize.Y
            paraContent.Position = UDim2.fromOffset(contentOffset, 25)
            paraContent.Parent = paraFrame

            if buttons then
                 local btnContainer = Instance.new("Frame")
                 btnContainer.Size = UDim2.new(1, 0, 0, 30)
                 btnContainer.AutomaticSize = Enum.AutomaticSize.Y
                 btnContainer.BackgroundTransparency = 1
                 btnContainer.Parent = paraFrame

                 local btnLayout = Instance.new("UIListLayout")
                 btnLayout.FillDirection = Enum.FillDirection.Horizontal
                 btnLayout.Padding = UDim.new(0, 5)
                 btnLayout.Parent = btnContainer

                 -- Must ensure container is placed after text... simple layout might fail if text auto-sizes.
                 -- Actually paraFrame has no ListLayout, it relies on positions.
                 -- We should switch paraFrame to use ListLayout for easier stacking if we add buttons.
                 -- Refactoring to UIListLayout for paragraph internals:

                 -- Cleanup old manual pos:
                 paraTitle.Position = UDim2.new(0,0,0,0)
                 paraContent.Position = UDim2.new(0,0,0,0)
                 if image then
                      -- Image forces a different layout (Row).
                      -- For simplicity within constraints, I'll append buttons at bottom if ListLayout is used on Parent.
                      -- But paraFrame is the parent.
                 end

                 -- Simpler approach: Put buttons in a frame at bottom, rely on AutomaticSize of paraFrame?
                 -- Without UIListLayout on paraFrame, AutomaticSize won't work well with dynamic Y.

                 local layout = Instance.new("UIListLayout")
                 layout.SortOrder = Enum.SortOrder.LayoutOrder
                 layout.Padding = UDim.new(0, 5)
                 layout.Parent = paraFrame

                 -- Remove any old layout reference
                 if paraFrame:FindFirstChild("UIListLayout") then paraFrame.UIListLayout:Destroy() end

                 -- Ensure title/content are positioned manually if image exists (handled by contentOffset above)
                 -- If image, contentOffset is 50, elements are Absolute Positioned.
                 -- If no image, we used to use Layout, but now we are unifying or handling buttons.

                 -- To support buttons nicely with variable text height, we should use a V-Layout on a container for the text/buttons.
                 -- But we already set up paraTitle/paraContent with manual positions above.

                 -- If buttons exist, they need to be below the content.
                 -- Since paraContent uses AutomaticSize, we can anchor the Button Frame to the bottom of content?
                 -- Or simpler: Just use a ListLayout for the whole thing, but wrap image in a separate frame if needed.

                 -- Let's use a V-List Layout for the main frame, but if Image exists, we need a H-Frame for Image + Text.
                 -- Complexity is high.
                 -- "Do whatever is best": I will just append the buttons at a fixed offset below the text content if image exists,
                 -- or use the ListLayout if no image.

                 if not image then
                      local layout = Instance.new("UIListLayout")
                      layout.SortOrder = Enum.SortOrder.LayoutOrder
                      layout.Padding = UDim.new(0, 5)
                      layout.Parent = paraFrame

                      paraTitle.Position = UDim2.new(0,0,0,0)
                      paraContent.Position = UDim2.new(0,0,0,0)
                 else
                      -- Image Mode: Manual positioning.
                      -- We need to find where the content ends.
                      -- paraContent.AbsoluteSize is not available immediately.
                      -- We can use AutomaticSize on paraFrame + ListLayout if we wrap Image+Text properly.
                      -- I'll just force the ButtonFrame to be added to the Layout if no image,
                      -- but if image, I'll put ButtonFrame at UDim2.new(0, 50, 1, 0) relative to content?
                      -- Actually, to keep it robust:
                      -- I will create a 'ContentContainer' inside paraFrame that holds Title+Text+Buttons.
                      -- The Image sits to the left of this container.

                      -- Resetting Parent Structure
                      paraTitle.Parent = nil
                      paraContent.Parent = nil

                      local textContainer = Instance.new("Frame")
                      textContainer.Size = UDim2.new(1, -50, 0, 0)
                      textContainer.Position = UDim2.fromOffset(50, 0)
                      textContainer.AutomaticSize = Enum.AutomaticSize.Y
                      textContainer.BackgroundTransparency = 1
                      textContainer.Parent = paraFrame

                      local tcLayout = Instance.new("UIListLayout")
                      tcLayout.SortOrder = Enum.SortOrder.LayoutOrder
                      tcLayout.Padding = UDim.new(0, 2)
                      tcLayout.Parent = textContainer

                      paraTitle.Size = UDim2.new(1, 0, 0, 20)
                      paraTitle.Position = UDim2.new(0,0,0,0)
                      paraTitle.Parent = textContainer

                      paraContent.Size = UDim2.new(1, 0, 0, 0)
                      paraContent.Position = UDim2.new(0,0,0,0)
                      paraContent.Parent = textContainer

                      -- If buttons, add to textContainer
                      if buttons then
                          local btnFrame = Instance.new("Frame")
                          btnFrame.Size = UDim2.new(1, 0, 0, 30)
                          btnFrame.BackgroundTransparency = 1
                          btnFrame.LayoutOrder = 3
                          btnFrame.Parent = textContainer

                          local bl = Instance.new("UIListLayout")
                          bl.FillDirection = Enum.FillDirection.Horizontal
                          bl.Padding = UDim.new(0, 5)
                          bl.Parent = btnFrame

                          for _, bData in ipairs(buttons) do
                              local b = Instance.new("TextButton")
                              b.Text = bData.Text
                              b.Size = UDim2.new(0, 0, 1, 0)
                              b.AutomaticSize = Enum.AutomaticSize.X
                              b.BackgroundColor3 = Library.Theme.Button
                              b.TextColor3 = Library.Theme.Text
                              b.Parent = btnFrame
                              local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
                              local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0, 10); p.PaddingRight = UDim.new(0, 10); p.Parent = b
                              b.MouseButton1Click:Connect(bData.Callback)
                          end
                      end
                      return TabLib -- Exit early for Image Mode
                 end

                 -- No Image Mode Logic (Fallthrough)
                 local btnFrame = Instance.new("Frame")
                 btnFrame.Size = UDim2.new(1, 0, 0, 30)
                 btnFrame.BackgroundTransparency = 1
                 btnFrame.LayoutOrder = 3
                 btnFrame.Parent = paraFrame
                 local bl = Instance.new("UIListLayout")
                 bl.FillDirection = Enum.FillDirection.Horizontal
                 bl.Padding = UDim.new(0, 5)
                 bl.Parent = btnFrame

                 for _, bData in ipairs(buttons) do
                      local b = Instance.new("TextButton")
                      b.Text = bData.Text
                      b.Size = UDim2.new(0, 0, 1, 0)
                      b.AutomaticSize = Enum.AutomaticSize.X
                      b.BackgroundColor3 = Library.Theme.Button
                      b.TextColor3 = Library.Theme.Text
                      b.Parent = btnFrame
                      local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
                      local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0, 10); p.PaddingRight = UDim.new(0, 10); p.Parent = b
                      b.MouseButton1Click:Connect(bData.Callback)
                 end
            end

            return TabLib
        end

        -- Element: Button
        function TabLib:AddButton(config)
            config = config or {}
            local title = config.Title or "Button"
            local callback = config.Callback or function() end

            local btnFrame = Instance.new("TextButton")
            registerElement(title, btnFrame)
            btnFrame.Size = UDim2.new(1, -10, 0, 40)
            btnFrame.BackgroundColor3 = Library.Theme.Button
            btnFrame.Text = ""
            btnFrame.AutoButtonColor = false
            btnFrame.Parent = tabContent

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btnFrame

            local btnTitle = Instance.new("TextLabel")
            btnTitle.Text = title
            btnTitle.Font = Enum.Font.GothamBold
            btnTitle.TextSize = 14
            btnTitle.TextColor3 = Library.Theme.Text
            btnTitle.BackgroundTransparency = 1
            btnTitle.Size = UDim2.fromScale(1, 1)
            btnTitle.Parent = btnFrame

            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Library.Theme.Outline
            btnStroke.Thickness = 1
            btnStroke.Transparency = 0.8
            btnStroke.Parent = btnFrame

            btnFrame.MouseEnter:Connect(function()
                Library.Utils:Tween(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Accent, BackgroundTransparency = 0.2})
            end)

            btnFrame.MouseLeave:Connect(function()
                Library.Utils:Tween(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Button, BackgroundTransparency = 0})
            end)

            btnFrame.MouseButton1Click:Connect(function()
                -- Click effect
                Library.Utils:Tween(btnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -12, 0, 38)})
                task.wait(0.1)
                Library.Utils:Tween(btnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 40)})
                callback()
            end)

            return TabLib
        end

        -- Element: Toggle
        function TabLib:AddToggle(config)
            config = config or {}
            local title = config.Title or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            local flag = config.Flag or title
            local style = config.Style -- "Checkbox" or default
            local icon = config.Icon

            local state = default

            local toggleFrame = Instance.new("TextButton")
            registerElement(title, toggleFrame)
            toggleFrame.Size = UDim2.new(1, -10, 0, 40)
            toggleFrame.BackgroundColor3 = Library.Theme.Button
            toggleFrame.BackgroundTransparency = 0.5
            toggleFrame.Text = ""
            toggleFrame.AutoButtonColor = false
            toggleFrame.Parent = tabContent

            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 6)
            toggleCorner.Parent = toggleFrame

            local titleOffset = 10
            if icon then
                 local iconImg = Instance.new("ImageLabel")
                 iconImg.Size = UDim2.fromOffset(20, 20)
                 iconImg.Position = UDim2.fromOffset(10, 10)
                 iconImg.BackgroundTransparency = 1
                 -- Need real icon logic here if icon is string name
                 local iData = Library:GetIcon(icon, "Lucide")
                 if iData then
                     iconImg.Image = iData.Image
                     iconImg.ImageRectOffset = iData.ImageRectOffset
                     iconImg.ImageRectSize = iData.ImageRectSize
                 end
                 iconImg.ImageColor3 = Library.Theme.Icon
                 iconImg.Parent = toggleFrame
                 titleOffset = 40
            end

            local toggleTitle = Instance.new("TextLabel")
            toggleTitle.Text = title
            toggleTitle.Font = Enum.Font.GothamBold
            toggleTitle.TextSize = 14
            toggleTitle.TextColor3 = Library.Theme.Text
            toggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            toggleTitle.BackgroundTransparency = 1
            toggleTitle.Size = UDim2.new(1, -60 - titleOffset, 1, 0)
            toggleTitle.Position = UDim2.fromOffset(titleOffset, 0)
            toggleTitle.Parent = toggleFrame

            local switchBg, switchDot

            if style == "Checkbox" then
                 -- Checkbox Visuals
                 switchBg = Instance.new("Frame")
                 switchBg.Size = UDim2.fromOffset(20, 20)
                 switchBg.Position = UDim2.new(1, -30, 0.5, 0)
                 switchBg.AnchorPoint = Vector2.new(0, 0.5)
                 switchBg.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Secondary
                 switchBg.Parent = toggleFrame

                 local sCorner = Instance.new("UICorner")
                 sCorner.CornerRadius = UDim.new(0, 4)
                 sCorner.Parent = switchBg

                 -- Checkmark icon inside?
                 switchDot = Instance.new("ImageLabel") -- reusing name for logic consistency
                 switchDot.Size = UDim2.fromOffset(14, 14)
                 switchDot.Position = UDim2.fromScale(0.5, 0.5)
                 switchDot.AnchorPoint = Vector2.new(0.5, 0.5)
                 switchDot.BackgroundTransparency = 1
                 switchDot.Image = "rbxassetid://3926305904" -- check
                 switchDot.ImageTransparency = state and 0 or 1
                 switchDot.Parent = switchBg
            else
                 -- Standard Switch
                 switchBg = Instance.new("Frame")
                 switchBg.Size = UDim2.fromOffset(40, 20)
                 switchBg.Position = UDim2.new(1, -50, 0.5, 0)
                 switchBg.AnchorPoint = Vector2.new(0, 0.5)
                 switchBg.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Secondary
                 switchBg.Parent = toggleFrame

                 local switchCorner = Instance.new("UICorner")
                 switchCorner.CornerRadius = UDim.new(1, 0)
                 switchCorner.Parent = switchBg

                 switchDot = Instance.new("Frame")
                 switchDot.Size = UDim2.fromOffset(16, 16)
                 switchDot.Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                 switchDot.AnchorPoint = Vector2.new(0, 0.5)
                 switchDot.BackgroundColor3 = Library.Theme.Text
                 switchDot.Parent = switchBg

                 local dotCorner = Instance.new("UICorner")
                 dotCorner.CornerRadius = UDim.new(1, 0)
                 dotCorner.Parent = switchDot
            end

            -- Quick Toggle Functionality
            local quickToggleBtn = nil
            local creatorMode = false

            local function updateQuickToggle()
                 if quickToggleBtn then
                      quickToggleBtn.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Button
                 end
            end

            local function toggleFeature()
                state = not state

                if style == "Checkbox" then
                   Library.Utils:Tween(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Secondary})
                   switchDot.ImageTransparency = state and 0 or 1
                else
                    Library.Utils:Tween(switchBg, TweenInfo.new(0.2), {
                        BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Secondary
                    })
                    Library.Utils:Tween(switchDot, TweenInfo.new(0.2), {
                        Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                    })
                end

                if Library.Flags[flag] then
                    Library.Flags[flag].Value = state
                end

                callback(state)
                updateQuickToggle()
            end

            local function createQuickToggle()
                 if quickToggleBtn then
                     quickToggleBtn:Destroy()
                     quickToggleBtn = nil
                     return
                 end

                 quickToggleBtn = Instance.new("ImageButton")
                 quickToggleBtn.Size = UDim2.fromOffset(50, 50)
                 quickToggleBtn.Position = UDim2.fromScale(0.5, 0.5)
                 quickToggleBtn.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Button
                 quickToggleBtn.Parent = window.QuickToggleGui

                 local qtCorner = Instance.new("UICorner")
                 qtCorner.CornerRadius = UDim.new(0, 12)
                 qtCorner.Parent = quickToggleBtn

                 quickToggleBtn.MouseButton1Click:Connect(function()
                      if not window.IsEditMode then
                          toggleFeature()
                      else
                          window.ResizePanel.Visible = true
                          window.SelectedQuickToggle = quickToggleBtn
                      end
                 end)

                 local qtData = { Button = quickToggleBtn, ID = flag }
                 -- Check saved layout
                 if Library.QuickToggleLayouts and Library.QuickToggleLayouts[flag] then
                     local layout = Library.QuickToggleLayouts[flag]
                     quickToggleBtn.Position = UDim2.fromOffset(layout.X, layout.Y)
                     quickToggleBtn.Size = UDim2.fromOffset(layout.Size, layout.Size)
                 end

                 table.insert(Library.QuickToggles, qtData)
            end

            -- Creator Button
            if config.CanQuickToggle then
                 local creatorBtn = Instance.new("ImageButton")
                 creatorBtn.Size = UDim2.fromOffset(20, 20)
                 creatorBtn.Position = UDim2.fromOffset(10, 10) -- Left side
                 creatorBtn.BackgroundColor3 = Library.Theme.Accent
                 creatorBtn.BackgroundTransparency = 1 -- Default OFF
                 creatorBtn.Image = "rbxassetid://10734975486" -- Plus icon
                 creatorBtn.ImageColor3 = Library.Theme.Icon
                 creatorBtn.Parent = toggleFrame

                 local cCorner = Instance.new("UICorner")
                 cCorner.CornerRadius = UDim.new(0, 4)
                 cCorner.Parent = creatorBtn

                 creatorBtn.MouseButton1Click:Connect(function()
                      creatorMode = not creatorMode
                      creatorBtn.BackgroundTransparency = creatorMode and 0 or 1
                 end)

                 toggleTitle.Position = UDim2.fromOffset(35, 0)
                 toggleTitle.Size = UDim2.new(1, -85, 1, 0)
            end

            toggleFrame.MouseButton1Click:Connect(function()
                if creatorMode then
                    createQuickToggle()
                else
                    toggleFeature()
                end
            end)

            -- Register Flag
            local flagObj = {
                Value = state,
                Changed = Instance.new("BindableEvent"),
                Set = function(self, val)
                    if val ~= state then
                        state = val
                        -- Update Visuals
                        if style == "Checkbox" then
                           switchBg.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Secondary
                           switchDot.ImageTransparency = state and 0 or 1
                        else
                            switchBg.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Secondary
                            switchDot.Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                        end
                        self.Changed:Fire(state)
                        Library.ConfigManager:OnFlagChange()
                        callback(state)
                        updateQuickToggle()
                    end
                end
            }
            Library.Flags[flag] = flagObj

            checkDependencies(toggleFrame, config.Dependency)

            return TabLib
        end

        -- Element: Slider
        function TabLib:AddSlider(config)
            config = config or {}
            local title = config.Title or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local callback = config.Callback or function() end
            local flag = config.Flag or title

            local value = default

            local sliderFrame = Instance.new("Frame")
            registerElement(title, sliderFrame)
            sliderFrame.Size = UDim2.new(1, -10, 0, 50)
            sliderFrame.BackgroundColor3 = Library.Theme.Button
            sliderFrame.BackgroundTransparency = 0.5
            sliderFrame.Parent = tabContent

            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 6)
            sliderCorner.Parent = sliderFrame

            local sliderTitle = Instance.new("TextLabel")
            sliderTitle.Text = title
            sliderTitle.Font = Enum.Font.GothamBold
            sliderTitle.TextSize = 14
            sliderTitle.TextColor3 = Library.Theme.Text
            sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            sliderTitle.BackgroundTransparency = 1
            sliderTitle.Size = UDim2.new(1, -60, 0, 20)
            sliderTitle.Position = UDim2.fromOffset(10, 5)
            sliderTitle.Parent = sliderFrame

            local sliderInput = Instance.new("TextBox")
            sliderInput.Text = tostring(value)
            sliderInput.Font = Enum.Font.Gotham
            sliderInput.TextSize = 12
            sliderInput.TextColor3 = Library.Theme.Text
            sliderInput.BackgroundTransparency = 1
            sliderInput.Size = UDim2.new(0, 40, 0, 20)
            sliderInput.Position = UDim2.new(1, -50, 0, 5)
            sliderInput.Parent = sliderFrame

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, -20, 0, 4)
            sliderBar.Position = UDim2.new(0, 10, 0, 35)
            sliderBar.BackgroundColor3 = Library.Theme.Secondary
            sliderBar.Parent = sliderFrame

            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(1, 0)
            barCorner.Parent = sliderBar

            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Library.Theme.Accent
            sliderFill.Parent = sliderBar

            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = sliderFill

            local function update(input)
                local percent = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * percent)
                sliderInput.Text = tostring(value)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                if Library.Flags[flag] then Library.Flags[flag].Value = value end
                callback(value)
            end

            local dragging = false
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)

            Services.UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)

            Services.UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            sliderInput.FocusLost:Connect(function()
                local num = tonumber(sliderInput.Text)
                if num then
                    value = math.clamp(num, min, max)
                    local percent = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    if Library.Flags[flag] then Library.Flags[flag].Value = value end
                    callback(value)
                else
                    sliderInput.Text = tostring(value)
                end
            end)

            Library.Flags[flag] = {
                Value = value,
                Changed = Instance.new("BindableEvent"),
                Set = function(self, val)
                    value = math.clamp(val, min, max)
                    sliderInput.Text = tostring(value)
                    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    self.Changed:Fire(value)
                    Library.ConfigManager:OnFlagChange()
                    callback(value)
                end
            }

            checkDependencies(sliderFrame, config.Dependency)

            return TabLib
        end

        -- Element: Dropdown
        function TabLib:AddDropdown(config)
            config = config or {}
            local title = config.Title or "Dropdown"
            local options = config.Options or {}
            local default = config.Default or options[1]
            local callback = config.Callback or function() end
            local flag = config.Flag or title

            local current = default
            local isOpen = false

            local dropdownFrame = Instance.new("Frame")
            registerElement(title, dropdownFrame)
            dropdownFrame.Size = UDim2.new(1, -10, 0, 40) -- Expands
            dropdownFrame.BackgroundColor3 = Library.Theme.Button
            dropdownFrame.BackgroundTransparency = 0.5
            dropdownFrame.ClipsDescendants = true
            dropdownFrame.Parent = tabContent

            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 6)
            dropdownCorner.Parent = dropdownFrame

            local dropdownTitle = Instance.new("TextLabel")
            dropdownTitle.Text = title
            dropdownTitle.Font = Enum.Font.GothamBold
            dropdownTitle.TextSize = 14
            dropdownTitle.TextColor3 = Library.Theme.Text
            dropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            dropdownTitle.BackgroundTransparency = 1
            dropdownTitle.Size = UDim2.new(1, -40, 0, 40)
            dropdownTitle.Position = UDim2.fromOffset(10, 0)
            dropdownTitle.Parent = dropdownFrame

            local arrow = Instance.new("ImageLabel")
            arrow.Size = UDim2.fromOffset(20, 20)
            arrow.Position = UDim2.new(1, -30, 0, 10)
            arrow.BackgroundTransparency = 1
            arrow.Image = "rbxassetid://6031091004" -- Arrow down
            arrow.ImageColor3 = Library.Theme.Text
            arrow.Parent = dropdownFrame

            -- Options Container
            local searchBar = Instance.new("TextBox")
            searchBar.Size = UDim2.new(1, -20, 0, 25)
            searchBar.Position = UDim2.fromOffset(10, 40)
            searchBar.BackgroundColor3 = Library.Theme.Secondary
            searchBar.Text = ""
            searchBar.PlaceholderText = "Search..."
            searchBar.TextColor3 = Library.Theme.Text
            searchBar.Font = Enum.Font.Gotham
            searchBar.TextSize = 12
            searchBar.Visible = false
            searchBar.Parent = dropdownFrame

            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(0, 4)
            sCorner.Parent = searchBar

            local optionContainer = Instance.new("ScrollingFrame")
            optionContainer.Size = UDim2.new(1, 0, 0, 100)
            optionContainer.Position = UDim2.fromOffset(0, 70) -- Moved down for search
            optionContainer.BackgroundTransparency = 1
            optionContainer.ScrollBarThickness = 2
            optionContainer.Visible = false
            optionContainer.Parent = dropdownFrame

            local optionLayout = Instance.new("UIListLayout")
            optionLayout.Padding = UDim.new(0, 2)
            optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            optionLayout.Parent = optionContainer

            local function updateSort()
                 -- Sort: Selected to top (-1), others by CreationOrder
                 for _, child in ipairs(optionContainer:GetChildren()) do
                     if child:IsA("TextButton") then
                         local optVal = child:GetAttribute("OptionValue")
                         if optVal == current then
                             child.LayoutOrder = -1
                             child.BackgroundColor3 = Library.Theme.Accent
                         else
                             child.LayoutOrder = child:GetAttribute("CreationOrder") or 0
                             child.BackgroundColor3 = Library.Theme.Secondary
                         end
                     end
                 end
            end

            local function filterOptions(text)
                 text = text:lower()
                 for _, child in ipairs(optionContainer:GetChildren()) do
                     if child:IsA("TextButton") then
                         if text == "" or child.Text:lower():find(text) then
                             child.Visible = true
                         else
                             child.Visible = false
                         end
                     end
                 end
                 optionContainer.CanvasSize = UDim2.new(0, 0, 0, optionLayout.AbsoluteContentSize.Y)
            end

            searchBar:GetPropertyChangedSignal("Text"):Connect(function()
                filterOptions(searchBar.Text)
            end)

            local function toggleDropdown()
                isOpen = not isOpen
                if isOpen then
                    Library.Utils:Tween(dropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 175)}) -- Taller for search
                    Library.Utils:Tween(arrow, TweenInfo.new(0.3), {Rotation = 180})
                    searchBar.Visible = true
                    optionContainer.Visible = true
                    updateSort()
                    optionContainer.CanvasPosition = Vector2.new(0, 0)
                    optionContainer.CanvasSize = UDim2.new(0, 0, 0, optionLayout.AbsoluteContentSize.Y)
                else
                    Library.Utils:Tween(dropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 40)})
                    Library.Utils:Tween(arrow, TweenInfo.new(0.3), {Rotation = 0})
                    searchBar.Visible = false
                    optionContainer.Visible = false
                    searchBar.Text = "" -- Reset search
                end
            end

            local function selectOption(opt)
                current = opt
                dropdownTitle.Text = title .. ": " .. tostring(opt)
                if Library.Flags[flag] then Library.Flags[flag].Value = current end
                callback(current)
                toggleDropdown()
            end

            -- Populate options
            local function refreshOptions()
                 for _, child in ipairs(optionContainer:GetChildren()) do
                     if child:IsA("TextButton") then child:Destroy() end
                 end

                 for i, opt in ipairs(options) do
                     local optBtn = Instance.new("TextButton")
                     optBtn.Size = UDim2.new(1, -10, 0, 25)
                     optBtn.BackgroundColor3 = Library.Theme.Secondary
                     optBtn.Text = tostring(opt)
                     optBtn.TextColor3 = Library.Theme.Text
                     optBtn.Font = Enum.Font.Gotham
                     optBtn.TextSize = 12
                     optBtn.Parent = optionContainer

                     optBtn:SetAttribute("CreationOrder", i)
                     optBtn:SetAttribute("OptionValue", opt)

                     optBtn.MouseButton1Click:Connect(function() selectOption(opt) end)
                 end
                 if isOpen then updateSort() end
            end

            refreshOptions()

            local triggerBtn = Instance.new("TextButton")
            triggerBtn.Size = UDim2.new(1, 0, 0, 40)
            triggerBtn.BackgroundTransparency = 1
            triggerBtn.Text = ""
            triggerBtn.Parent = dropdownFrame
            triggerBtn.MouseButton1Click:Connect(toggleDropdown)

            if default then selectOption(default) end

            Library.Flags[flag] = {
                Value = current,
                Changed = Instance.new("BindableEvent"),
                Set = function(self, val)
                    current = val
                    dropdownTitle.Text = title .. ": " .. tostring(current)
                    refreshOptions() -- Update selection highlight
                    self.Changed:Fire(current)
                    Library.ConfigManager:OnFlagChange()
                    callback(current)
                end
            }

            checkDependencies(dropdownFrame, config.Dependency)

            return TabLib
        end

        -- Element: ColorPicker
        function TabLib:AddColorPicker(config)
            config = config or {}
            local title = config.Title or "ColorPicker"
            local default = config.Default or Color3.fromRGB(255, 255, 255)
            local callback = config.Callback or function() end
            local flag = config.Flag or title

            local color = default

            local cpFrame = Instance.new("Frame")
            registerElement(title, cpFrame)
            cpFrame.Size = UDim2.new(1, -10, 0, 40)
            cpFrame.BackgroundColor3 = Library.Theme.Button
            cpFrame.BackgroundTransparency = 0.5
            cpFrame.Parent = tabContent

            local cpCorner = Instance.new("UICorner")
            cpCorner.CornerRadius = UDim.new(0, 6)
            cpCorner.Parent = cpFrame

            local cpTitle = Instance.new("TextLabel")
            cpTitle.Text = title
            cpTitle.Font = Enum.Font.GothamBold
            cpTitle.TextSize = 14
            cpTitle.TextColor3 = Library.Theme.Text
            cpTitle.TextXAlignment = Enum.TextXAlignment.Left
            cpTitle.BackgroundTransparency = 1
            cpTitle.Size = UDim2.new(1, -50, 1, 0)
            cpTitle.Position = UDim2.fromOffset(10, 0)
            cpTitle.Parent = cpFrame

            local display = Instance.new("TextButton")
            display.Size = UDim2.fromOffset(30, 20)
            display.Position = UDim2.new(1, -40, 0.5, 0)
            display.AnchorPoint = Vector2.new(0, 0.5)
            display.BackgroundColor3 = color
            display.Text = ""
            display.Parent = cpFrame

            local dispCorner = Instance.new("UICorner")
            dispCorner.CornerRadius = UDim.new(0, 4)
            dispCorner.Parent = display

            display.MouseButton1Click:Connect(function()
                 -- Close existing picker if any
                 if window.CurrentPicker then window.CurrentPicker:Destroy() window.CurrentPicker = nil end

                 local pickerOverlay = Instance.new("Frame")
                 pickerOverlay.Name = "PickerOverlay"
                 pickerOverlay.Size = UDim2.fromScale(1, 1)
                 pickerOverlay.BackgroundTransparency = 1
                 pickerOverlay.Parent = window.Overlay

                 local pickerFrame = Instance.new("Frame")
                 pickerFrame.Size = UDim2.fromOffset(220, 160)
                 pickerFrame.BackgroundColor3 = Library.Theme.Dialog
                 pickerFrame.Parent = pickerOverlay

                 local absPos = display.AbsolutePosition
                 local windowSize = window.MainFrame.AbsoluteSize
                 local windowPos = window.MainFrame.AbsolutePosition

                 -- Attempt to position near button, keep in bounds
                 local targetX = absPos.X + 40
                 local targetY = absPos.Y - 60

                 pickerFrame.Position = UDim2.fromOffset(targetX, targetY)

                 local pCorner = Instance.new("UICorner")
                 pCorner.CornerRadius = UDim.new(0, 6)
                 pCorner.Parent = pickerFrame

                 local pStroke = Instance.new("UIStroke")
                 pStroke.Color = Library.Theme.Outline
                 pStroke.Thickness = 1
                 pStroke.Parent = pickerFrame

                 local function createSlider(name, yPos, initialVal, updateFunc)
                      local sLabel = Instance.new("TextLabel")
                      sLabel.Text = name
                      sLabel.Size = UDim2.new(0, 20, 0, 20)
                      sLabel.Position = UDim2.fromOffset(10, yPos)
                      sLabel.BackgroundTransparency = 1
                      sLabel.TextColor3 = Library.Theme.Text
                      sLabel.Parent = pickerFrame

                      local sBar = Instance.new("Frame")
                      sBar.Size = UDim2.new(1, -50, 0, 4)
                      sBar.Position = UDim2.fromOffset(35, yPos + 8)
                      sBar.BackgroundColor3 = Library.Theme.Secondary
                      sBar.Parent = pickerFrame

                      local sFill = Instance.new("Frame")
                      sFill.Size = UDim2.new(initialVal, 0, 1, 0)
                      sFill.BackgroundColor3 = Library.Theme.Accent
                      sFill.Parent = sBar

                      local dragging = false
                      local function update(input)
                           local percent = math.clamp((input.Position.X - sBar.AbsolutePosition.X) / sBar.AbsoluteSize.X, 0, 1)
                           sFill.Size = UDim2.new(percent, 0, 1, 0)
                           updateFunc(percent)
                      end

                      sBar.InputBegan:Connect(function(input)
                          if input.UserInputType == Enum.UserInputType.MouseButton1 then
                              dragging = true
                              update(input)
                          end
                      end)

                      Services.UserInputService.InputChanged:Connect(function(input)
                          if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                              update(input)
                          end
                      end)

                      Services.UserInputService.InputEnded:Connect(function(input)
                           if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                      end)
                 end

                 local r, g, b = color.R, color.G, color.B

                 local function updateColor()
                      color = Color3.new(r, g, b)
                      display.BackgroundColor3 = color
                      if Library.Flags[flag] then
                          Library.Flags[flag].Value = color
                          Library.Flags[flag].Changed:Fire(color)
                      end
                      Library.ConfigManager:OnFlagChange()
                      callback(color)
                 end

                 createSlider("R", 10, r, function(v) r = v updateColor() end)
                 createSlider("G", 40, g, function(v) g = v updateColor() end)
                 createSlider("B", 70, b, function(v) b = v updateColor() end)

                 local closeBtn = Instance.new("TextButton")
                 closeBtn.Text = "Done"
                 closeBtn.Size = UDim2.new(1, -20, 0, 30)
                 closeBtn.Position = UDim2.new(0, 10, 1, -40)
                 closeBtn.BackgroundColor3 = Library.Theme.Button
                 closeBtn.TextColor3 = Library.Theme.Text
                 closeBtn.Parent = pickerFrame
                 local cCorner = Instance.new("UICorner"); cCorner.CornerRadius = UDim.new(0, 4); cCorner.Parent = closeBtn

                 closeBtn.MouseButton1Click:Connect(function()
                     pickerOverlay:Destroy()
                     window.CurrentPicker = nil
                 end)

                 -- Click outside to close
                 local clickOut = Instance.new("TextButton")
                 clickOut.Size = UDim2.fromScale(1, 1)
                 clickOut.BackgroundTransparency = 1
                 clickOut.Text = ""
                 clickOut.ZIndex = -1
                 clickOut.Parent = pickerOverlay
                 clickOut.MouseButton1Click:Connect(function()
                      pickerOverlay:Destroy()
                      window.CurrentPicker = nil
                 end)

                 window.CurrentPicker = pickerOverlay
            end)

            Library.Flags[flag] = {
                Value = color,
                Changed = Instance.new("BindableEvent"),
                Set = function(self, val)
                    color = val
                    display.BackgroundColor3 = color
                    self.Changed:Fire(color)
                    Library.ConfigManager:OnFlagChange()
                    callback(color)
                end
            }

            checkDependencies(cpFrame, config.Dependency)

            return TabLib
        end

        -- Element: Keybind
        function TabLib:AddKeybind(config)
            config = config or {}
            local title = config.Title or "Keybind"
            local default = config.Default or Enum.KeyCode.E
            local callback = config.Callback or function() end
            local flag = config.Flag or title

            local key = default
            local binding = false

            local kbFrame = Instance.new("Frame")
            registerElement(title, kbFrame)
            kbFrame.Size = UDim2.new(1, -10, 0, 40)
            kbFrame.BackgroundColor3 = Library.Theme.Button
            kbFrame.BackgroundTransparency = 0.5
            kbFrame.Parent = tabContent

            local kbCorner = Instance.new("UICorner")
            kbCorner.CornerRadius = UDim.new(0, 6)
            kbCorner.Parent = kbFrame

            local kbTitle = Instance.new("TextLabel")
            kbTitle.Text = title
            kbTitle.Font = Enum.Font.GothamBold
            kbTitle.TextSize = 14
            kbTitle.TextColor3 = Library.Theme.Text
            kbTitle.TextXAlignment = Enum.TextXAlignment.Left
            kbTitle.BackgroundTransparency = 1
            kbTitle.Size = UDim2.new(1, -60, 1, 0)
            kbTitle.Position = UDim2.fromOffset(10, 0)
            kbTitle.Parent = kbFrame

            local bindBtn = Instance.new("TextButton")
            bindBtn.Size = UDim2.fromOffset(50, 20)
            bindBtn.Position = UDim2.new(1, -60, 0.5, 0)
            bindBtn.AnchorPoint = Vector2.new(0, 0.5)
            bindBtn.BackgroundColor3 = Library.Theme.Secondary
            bindBtn.Text = key.Name
            bindBtn.TextColor3 = Library.Theme.Text
            bindBtn.Font = Enum.Font.Gotham
            bindBtn.TextSize = 12
            bindBtn.Parent = kbFrame

            local bindCorner = Instance.new("UICorner")
            bindCorner.CornerRadius = UDim.new(0, 4)
            bindCorner.Parent = bindBtn

            bindBtn.MouseButton1Click:Connect(function()
                binding = true
                bindBtn.Text = "..."
                local inputConn
                inputConn = Services.UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        bindBtn.Text = key.Name
                        binding = false
                        if Library.Flags[flag] then Library.Flags[flag].Value = key end
                        callback(key)
                        inputConn:Disconnect()
                    end
                end)
            end)

            Library.Flags[flag] = {
                Value = key,
                Changed = Instance.new("BindableEvent"),
                Set = function(self, val)
                    key = val
                    bindBtn.Text = key.Name
                    self.Changed:Fire(key)
                    Library.ConfigManager:OnFlagChange()
                    callback(key)
                end
            }

            checkDependencies(kbFrame, config.Dependency)

            return TabLib
        end

        return TabLib
    end

    function window:ShowDialog(config)
        config = config or {}
        local title = config.Title or "Dialog"
        local content = config.Content or "Content"
        local buttons = config.Buttons or {{Text = "OK", Callback = function() end}}

        local dialogOverlay = Instance.new("Frame")
        dialogOverlay.Name = "DialogOverlay"
        dialogOverlay.Size = UDim2.fromScale(1, 1)
        dialogOverlay.BackgroundColor3 = Color3.new(0,0,0)
        dialogOverlay.BackgroundTransparency = 1
        dialogOverlay.ZIndex = 200
        dialogOverlay.Parent = window.Overlay

        local dialogFrame = Instance.new("Frame")
        dialogFrame.Size = UDim2.fromOffset(320, 160)
        dialogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        dialogFrame.Position = UDim2.fromScale(0.5, 0.6) -- Start slightly lower
        dialogFrame.BackgroundColor3 = Library.Theme.Dialog
        dialogFrame.Parent = dialogOverlay

        local dCorner = Instance.new("UICorner")
        dCorner.CornerRadius = UDim.new(0, 8)
        dCorner.Parent = dialogFrame

        local dStroke = Instance.new("UIStroke")
        dStroke.Color = Library.Theme.Outline
        dStroke.Thickness = 1
        dStroke.Parent = dialogFrame

        local dTitle = Instance.new("TextLabel")
        dTitle.Text = title
        dTitle.Font = Enum.Font.GothamBold
        dTitle.TextSize = 16
        dTitle.TextColor3 = Library.Theme.Text
        dTitle.Size = UDim2.new(1, -20, 0, 30)
        dTitle.Position = UDim2.fromOffset(10, 10)
        dTitle.BackgroundTransparency = 1
        dTitle.TextXAlignment = Enum.TextXAlignment.Left
        dTitle.Parent = dialogFrame

        local dContent = Instance.new("TextLabel")
        dContent.Text = content
        dContent.Font = Enum.Font.Gotham
        dContent.TextSize = 14
        dContent.TextColor3 = Library.Theme.Text
        dContent.TextTransparency = 0.2
        dContent.Size = UDim2.new(1, -20, 1, -80)
        dContent.Position = UDim2.fromOffset(10, 40)
        dContent.BackgroundTransparency = 1
        dContent.TextXAlignment = Enum.TextXAlignment.Left
        dContent.TextYAlignment = Enum.TextYAlignment.Top
        dContent.TextWrapped = true
        dContent.Parent = dialogFrame

        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(1, -20, 0, 30)
        btnContainer.Position = UDim2.new(0, 10, 1, -40)
        btnContainer.BackgroundTransparency = 1
        btnContainer.Parent = dialogFrame

        local btnLayout = Instance.new("UIListLayout")
        btnLayout.FillDirection = Enum.FillDirection.Horizontal
        btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        btnLayout.Padding = UDim.new(0, 10)
        btnLayout.Parent = btnContainer

        Library.Utils:Tween(window.Blur, TweenInfo.new(0.3), {Size = 24})
        Library.Utils:Tween(dialogOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.6})
        Library.Utils:Tween(dialogFrame, TweenInfo.new(0.3), {Position = UDim2.fromScale(0.5, 0.5)})

        local function close()
            Library.Utils:Tween(dialogOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1})
            Library.Utils:Tween(dialogFrame, TweenInfo.new(0.2), {Position = UDim2.fromScale(0.5, 0.6), BackgroundTransparency = 1})
            -- Check if search or edit mode is active before clearing blur completely?
            if not window.IsEditMode and not window.SearchOverlay.Visible then
                Library.Utils:Tween(window.Blur, TweenInfo.new(0.2), {Size = 0})
            end
            task.wait(0.2)
            dialogOverlay:Destroy()
        end

        for _, btnData in ipairs(buttons) do
            local btn = Instance.new("TextButton")
            btn.Text = btnData.Text or "Button"
            btn.Size = UDim2.fromOffset(80, 30)
            btn.BackgroundColor3 = (btnData.Type == "Primary") and Library.Theme.Accent or Library.Theme.Secondary
            btn.TextColor3 = Library.Theme.Text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.Parent = btnContainer

            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 4)
            bCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                if btnData.Callback then btnData.Callback() end
                close()
            end)
        end
    end

    function window:AddStaticTab(config)
        -- Simulates AddTab but places button in staticTabContainer
        config = config or {}
        local tabName = config.Name or "StaticTab"
        local tabIcon = config.Icon or nil

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName
        tabBtn.Size = UDim2.new(1, 0, 0, 32) -- Full width of container (minus padding)
        tabBtn.BackgroundColor3 = Library.Theme.Background
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = ""
        tabBtn.Parent = staticTabContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn

        local btnLabel = Instance.new("TextLabel")
        btnLabel.Text = tabName
        btnLabel.Font = Library.FontManager.Font.Family
        btnLabel.TextSize = 14
        btnLabel.TextColor3 = Library.Theme.Text
        btnLabel.TextTransparency = 0.4
        btnLabel.Size = UDim2.new(1, -30, 1, 0)
        btnLabel.Position = UDim2.fromOffset(30, 0)
        btnLabel.BackgroundTransparency = 1
        btnLabel.TextXAlignment = Enum.TextXAlignment.Left
        btnLabel.Parent = tabBtn

        if tabIcon then
            local iconData = Library:GetIcon(tabIcon, "Lucide")
            if iconData then
                 local iconImg = Instance.new("ImageLabel")
                 iconImg.Size = UDim2.fromOffset(18, 18)
                 iconImg.Position = UDim2.new(0, 6, 0.5, 0)
                 iconImg.AnchorPoint = Vector2.new(0, 0.5)
                 iconImg.BackgroundTransparency = 1
                 iconImg.Image = iconData.Image
                 iconImg.ImageRectOffset = iconData.ImageRectOffset
                 iconImg.ImageRectSize = iconData.ImageRectSize
                 iconImg.ImageColor3 = Library.Theme.Icon
                 iconImg.ImageTransparency = 0.4
                 iconImg.Parent = tabBtn
            end
        end

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "_Content"
        tabContent.Size = UDim2.fromScale(1, 1)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 2
        tabContent.ScrollBarImageColor3 = Library.Theme.Accent
        tabContent.Visible = false
        tabContent.Parent = window.ContentFrame

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 10)
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.Parent = tabContent

        local function selectTab()
             if window.ActiveTab then
                 Library.Utils:Tween(window.ActiveTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1})
                 Library.Utils:Tween(window.ActiveTab.Label, TweenInfo.new(0.2), {TextTransparency = 0.4})
                 window.ActiveTab.Content.Visible = false
             end

             window.ActiveTab = {Button = tabBtn, Label = btnLabel, Content = tabContent}
             Library.Utils:Tween(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, BackgroundColor3 = Library.Theme.Text})
             Library.Utils:Tween(btnLabel, TweenInfo.new(0.2), {TextTransparency = 0})
             tabContent.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(selectTab)

        table.insert(window.Tabs, {Button = tabBtn, Content = tabContent, Name = tabName})

        return Library:CreateTabLib(tabContent, tabName)
    end

    -- Auto Create Settings
    local settingsTab = window:AddStaticTab({ Name = "Customize", Icon = "settings" })
    local configSec = settingsTab:AddSection("Configuration")
    configSec:AddDropdown({
        Title = "Config Mode",
        Options = {"Legacy", "Normal"},
        Default = Library.ConfigManager.Mode,
        Callback = function(v)
            Library.ConfigManager.Mode = v
            Library.ConfigManager:SaveSettings() -- Save mode preference immediately
        end
    })
    configSec:AddButton({
        Title = "Save Configuration",
        Callback = function() Library.ConfigManager:Save() Library:Notify({Title="Config", Content="Saved settings."}) end
    })
    configSec:AddButton({
        Title = "Export Configuration",
        Callback = function()
            if setclipboard then
                setclipboard(Services.HttpService:JSONEncode(Library.Flags))
                Library:Notify({Title="Export", Content="Copied to clipboard."})
            end
        end
    })

    local themeSec = settingsTab:AddSection("Theming")
    themeSec:AddColorPicker({
        Title = "Accent Color",
        Default = Library.Theme.Accent,
        Callback = function(c)
            Library.Theme.Accent = c
            -- Real-time update logic would go here (iterating over existing UI)
            Library:Notify({Title="Theme", Content="Accent color updated (Reopen UI to see full changes)."})
        end
    })

    return window
end

return Library
