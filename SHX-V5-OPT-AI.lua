--[[
    Speed Hub X - Enhanced UI Library (Improved Self-Contained Version)
--]]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Executor-specific external loading (commented out for general use)
-- task.spawn(function() ... end)

local function GetPlayerGui()
    -- ... (GetPlayerGui function as defined in the previous "Improved Version")
    if RunService:IsStudio() then
        return Player and Player:FindFirstChildOfClass("PlayerGui")
    else
        return (Player and Player:FindFirstChildOfClass("PlayerGui")) or CoreGui
    end
end

local Custom = {} do
  Custom.ColorRGB = Color3.fromRGB(250, 7, 7) -- Default Red theme color
  -- ... (Custom:Create function as defined before)
  function Custom:Create(Name, Properties, Parent)
    local instance = Instance.new(Name)
    for prop, value in pairs(Properties) do
      instance[prop] = value
    end
    if Parent then
      instance.Parent = Parent
    end
    return instance
  end
  -- ... (Custom:EnabledAFK function as defined and improved before)
  function Custom:EnabledAFK()
    if not Player or not Player:IsA("Player") then return end
    local virtualUserSuccess, virtualUser = pcall(game.GetService, game, "VirtualUser")
    if not virtualUserSuccess or not virtualUser then return end
    if Player.Idled then
        Player.Idled:Connect(function()
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    virtualUser:Button2Down(Vector2.new(0, 0), cam.CFrame)
                    task.wait(1)
                    virtualUser:Button2Up(Vector2.new(0, 0), cam.CFrame)
                end
            end)
        end)
    end
  end
end
Custom:EnabledAFK()

local Open_Close_Button_Instance -- Forward declare
-- ... (CreateOpenCloseButton function as defined and improved before)
local function CreateOpenCloseButton()
    local guiParent = GetPlayerGui()
    if not guiParent then
        return { Visible = false, Activated = Instance.new("BindableEvent"), Destroy = function() end }
    end
    local screenGui = Custom:Create("ScreenGui", { Name = "OpenCloseHandlerScreenGui", ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false }, guiParent)
    local imageButton = Custom:Create("ImageButton", { Name = "OpenCloseToggle", BackgroundColor3 = Color3.fromRGB(30,30,30), BorderColor3 = Custom.ColorRGB, BorderSizePixel = 1, Position = UDim2.new(0.05,0,0.05,0), Size = UDim2.fromOffset(50,40), Image = "rbxassetid://82140212012109", ImageColor3 = Custom.ColorRGB, Visible = false }, screenGui)
    Custom:Create("UICorner", { CornerRadius = UDim.new(0,6) }, imageButton)
    local dragging, dragStartPos, elementStartPos, inputChangedConnection; imageButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging=true; dragStartPos=input.Position; elementStartPos=imageButton.Position; if inputChangedConnection then inputChangedConnection:Disconnect() end; inputChangedConnection=input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false; dragStartPos=nil; elementStartPos=nil; if inputChangedConnection then inputChangedConnection:Disconnect(); inputChangedConnection=nil end end end) end end); imageButton.InputChanged:Connect(function(input) if dragging and dragStartPos and elementStartPos and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then local delta=input.Position-dragStartPos; imageButton.Position=UDim2.new(elementStartPos.X.Scale,elementStartPos.X.Offset+delta.X,elementStartPos.Y.Scale,elementStartPos.Y.Offset+delta.Y) end end)
    return imageButton
end
Open_Close_Button_Instance = CreateOpenCloseButton()

-- ... (MakeDraggable function as defined and improved before)
local function MakeDraggable(dragHandle, targetObject)
    local dragging, dragStartPos, elementStartPos, inputChangedConnection; dragHandle.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; dragStartPos=input.Position; elementStartPos=targetObject.Position; if inputChangedConnection then inputChangedConnection:Disconnect() end; inputChangedConnection=input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false; dragStartPos=nil; elementStartPos=nil; if inputChangedConnection then inputChangedConnection:Disconnect(); inputChangedConnection=nil end end end) end end); dragHandle.InputChanged:Connect(function(input) if dragging and dragStartPos and elementStartPos and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then local delta=input.Position-dragStartPos; targetObject.Position=UDim2.new(elementStartPos.X.Scale,elementStartPos.X.Offset+delta.X,elementStartPos.Y.Scale,elementStartPos.Y.Offset+delta.Y) end end)
end

-- ... (CircleClick function as defined and improved before)
function CircleClick(button, x, y) if not button or not button:IsA("GuiButton") then return end; task.spawn(function() button.ClipsDescendants=true; local cI=Instance.new("ImageLabel");cI.Name="ClickEffectCircle";cI.Image="rbxassetid://266543268";cI.ImageColor3=Color3.fromRGB(120,120,120);cI.ImageTransparency=0.85;cI.BackgroundTransparency=1;cI.ZIndex=(button.ZIndex or 1)+10;cI.Parent=button;cI.Position=UDim2.fromOffset(x-button.AbsolutePosition.X,y-button.AbsolutePosition.Y);cI.AnchorPoint=Vector2.new(0.5,0.5);local tS=math.max(button.AbsoluteSize.X,button.AbsoluteSize.Y)*2;local aT=0.35;local sT=TweenService:Create(cI,TweenInfo.new(aT,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(tS,tS)});local fT=TweenService:Create(cI,TweenInfo.new(aT*0.6,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,aT*0.4),{ImageTransparency=1});sT:Play();fT:Play();fT.Completed:Connect(function()cI:Destroy()end)end) end

local Speed_Library = {}
Speed_Library.Unloaded = false
Speed_Library.ActiveNotifications = {}
local GlobalNotificationScreenGui, GlobalNotificationLayoutFrame = nil, nil
-- ... (GetOrCreateNotificationGui function as defined and improved before)
local function GetOrCreateNotificationGui() if GlobalNotificationScreenGui and GlobalNotificationScreenGui.Parent then return GlobalNotificationScreenGui,GlobalNotificationLayoutFrame end; local gP=GetPlayerGui()or CoreGui;GlobalNotificationScreenGui=Custom:Create("ScreenGui",{Name="GlobalNotificationGui_SHX",ZIndexBehavior=Enum.ZIndexBehavior.Sibling,ResetOnSpawn=false,DisplayOrder=99999},gP);GlobalNotificationLayoutFrame=Custom:Create("Frame",{Name="NotificationLayoutContainer",AnchorPoint=Vector2.new(1,1),BackgroundTransparency=1,Position=UDim2.new(1,-15,1,-15),Size=UDim2.new(0,320,0,0),ClipsDescendants=true},GlobalNotificationScreenGui);Custom:Create("UIListLayout",{Parent=GlobalNotificationLayoutFrame,SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Bottom,Padding=UDim.new(0,10)});return GlobalNotificationScreenGui,GlobalNotificationLayoutFrame end
-- ... (Speed_Library:SetNotification function as defined and improved before)
function Speed_Library:SetNotification(config) local t=config[1]or config.Title or"Notification";local d=config[2]or config.Description or"";local cT=config[3]or config.Content or"Notification content.";local aT=tonumber(config[5]or config.Time or 0.4);local dD=tonumber(config[6]or config.Delay or 5);local _,nL=GetOrCreateNotificationGui();if not nL then warn("SetNotification: Failed to get/create notification layout.");return{Close=function()end}end;local nF=Custom:Create("Frame",{Name="NotificationInstance",BackgroundColor3=Color3.fromRGB(35,35,35),BackgroundTransparency=0.1,BorderSizePixel=1,BorderColor3=Color3.fromRGB(55,55,55),Size=UDim2.new(1,0,0,0),LayoutOrder=tick(),ClipsDescendants=true},nL);Custom:Create("UICorner",{CornerRadius=UDim.new(0,6)},nF);Custom:Create("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},nF);local tB=Custom:Create("Frame",{Name="TopBar",BackgroundTransparency=1,Size=UDim2.new(1,0,0,20),Parent=nF});local tL=Custom:Create("TextLabel",{Name="TitleLabel",Font=Enum.Font.GothamBold,Text=t,TextColor3=Color3.fromRGB(240,240,240),TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Size=UDim2.new(0,0,1,0),Parent=tB});task.wait();tL.Size=UDim2.new(0,tL.TextBounds.X+(d~=""and 5 or 0),1,0);if d~=""then local dL=Custom:Create("TextLabel",{Name="DescriptionLabel",Font=Enum.Font.GothamSemibold,Text=" "..d,TextColor3=Custom.ColorRGB,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.new(0,tL.AbsoluteSize.X,0,0),Size=UDim2.new(0,0,1,0),Parent=tB});task.wait();dL.Size=UDim2.new(0,dL.TextBounds.X,1,0)end;local cB=Custom:Create("TextButton",{Name="CloseNotification",Text="",BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(18,18),Parent=tB});Custom:Create("ImageLabel",{Image="rbxassetid://9886659671",ImageColor3=Color3.fromRGB(180,180,180),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(1,-4,1,-4),Parent=cB});local cL=Custom:Create("TextLabel",{Name="ContentLabel",Font=Enum.Font.Gotham,Text=cT,TextColor3=Color3.fromRGB(190,190,190),TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,BackgroundTransparency=1,TextWrapped=true,Position=UDim2.new(0,0,0,tB.AbsoluteSize.Y+5),Size=UDim2.new(1,0,0,0),Parent=nF});task.wait();cL.Size=UDim2.new(1,0,0,cL.TextBounds.Y);nF.Size=UDim2.new(1,0,0,tB.AbsoluteSize.Y+5+cL.AbsoluteSize.Y+nF.UIPadding.PaddingTop.Offset+nF.UIPadding.PaddingBottom.Offset);local tNA={};local iC=false;function tNA:Close()if iC or not nF.Parent then return end;iC=true;table.remove(Speed_Library.ActiveNotifications,table.find(Speed_Library.ActiveNotifications,nF));local eT=TweenService:Create(nF,TweenInfo.new(aT*0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1});eT:Play();eT.Completed:Connect(function()nF:Destroy()end)end;cB.Activated:Connect(tNA.Close);local oS=nF.Size;nF.Size=UDim2.new(1,0,0,0);nF.BackgroundTransparency=1;local enT=TweenService:Create(nF,TweenInfo.new(aT,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=oS,BackgroundTransparency=0.1});enT:Play();table.insert(Speed_Library.ActiveNotifications,nF);task.delay(dD,function()if nF and nF.Parent then tNA:Close()end end);return tNA end

---

**Part 2: Guide to Merging `CreateWindow` and Sub-Components from `SHX-V5-OPT-AI.lua`**

This is where you'll do the main work. You need to copy the logic from the `Speed_Library:CreateWindow` function in `SHX-V5-OPT-AI.lua` and all its nested functions (`Tabs:CreateTab`, `Sections:AddSection`, `Item:Add<Type>`) into the `Speed_Library:CreateWindow` function below.

**Steps:**

1.  **Open `SHX-V5-OPT-AI.lua`** in a text editor.
2.  **Locate `function Speed_Library:CreateWindow(Config)`** in it.
3.  **Inside your script (this one), create the `Speed_Library:CreateWindow` function:**

    ```lua
    function Speed_Library:CreateWindow(Config)
        local Title = Config[1] or Config.Title or "Speed Hub X"
        local Description = Config[2] or Config.Description or "V5" -- Default description from zryr's lib
        local TabWidth = Config[3] or Config["Tab Width"] or 120
        local SizeUi = Config[4] or Config.SizeUi or UDim2.fromOffset(550, 315) -- Default size

        -- Crucial: Get the GUI parent using *this* script's GetPlayerGui
        local guiParent = GetPlayerGui()
        if not guiParent then
            warn("CreateWindow: Could not find suitable GUI parent. UI cannot be created.")
            return { CreateTab = function() warn("Dummy CreateTab: Window creation failed.") end } -- Return a dummy API
        end

        -- 1. Create the main ScreenGui (SpeedHubXGui) using Custom:Create
        local SpeedHubXGui = Custom:Create("ScreenGui", {
            Name = "SpeedHubXMainInstance", -- Unique name
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false
        }, guiParent)

        -- 2. Create DropShadowHolder, DropShadow, Main frame using Custom:Create
        --    Position and size them as in SHX-V5-OPT-AI.lua.
        --    Example for DropShadowHolder:
        local initialPosX = (guiParent.AbsoluteSize.X - SizeUi.X.Offset) / 2
        local initialPosY = (guiParent.AbsoluteSize.Y - SizeUi.Y.Offset) / 2

        local DropShadowHolder = Custom:Create("Frame", {
            Name = "DraggableWindowHolder",
            BackgroundTransparency = 1,
            Size = SizeUi,
            Position = UDim2.fromOffset(initialPosX, initialPosY),
            ZIndex = 0 -- Or as needed
            -- Parent will be SpeedHubXGui
        }, SpeedHubXGui)
        -- ... create DropShadow and MainFrame, parented to DropShadowHolder and MainFrame respectively.

        -- 3. Create TopBar, TitleLabel, DescriptionLabel, Close, Min buttons using Custom:Create
        --    Parent them to MainFrame or TopBar as appropriate.
        --    Dynamically adjust DropShadowHolder size based on Title and Description text bounds.
        --    local topBar = Custom:Create("Frame", {...}, Main)
        --    local titleTextLabel = Custom:Create("TextLabel", {...}, topBar)
        --    ... etc.
        --    MakeDraggable(topBar, DropShadowHolder) -- Use *this* script's MakeDraggable

        -- 4. Create LayersTab (TabsListScroll), DecideFrame, Layers (ContentPagesHolder),
        --    NameTab (CurrentTabNameLabel), LayersReal (PagesContainer), LayersFolder, LayersPageLayout
        --    ScrollTab (for tabs list), UIListLayout for ScrollTab.
        --    Use Custom:Create for all these.
        --    Connect ChildAdded/Removed for ScrollTab to its UpdateSize function.
        --    Example:
        --    local tabsListScroll = Custom:Create("ScrollingFrame", {... Name = "TabsListScroll", Parent = Main}) -- Or appropriate parent
        --    local contentPagesHolder = Custom:Create("Frame", {... Name = "ContentPagesHolder", Parent = Main})
        --    local currentTabNameLabel = Custom:Create("TextLabel", {... Name = "CurrentTabNameDisplay", Parent = contentPagesHolder})
        --    local pagesContainer = Custom:Create("Frame", {... Name="PagesContainerFrame", Parent = contentPagesHolder})
        --    local pagesFolderInstance = Custom:Create("Folder", {Name = "PagesFolder", Parent = pagesContainer})
        --    local uiPageLayoutInstance = Custom:Create("UIPageLayout", {... Parent = pagesFolderInstance})


        -- 5. Implement the Dropdown Popup System (MoreBlur, DropdownSelect, etc.)
        --    This is the floating panel that shows dropdown options.
        --    Create MoreBlur (rename to DropdownPopupOverlay), DropdownSelect (DropdownContentHolder), etc. using Custom:Create.
        --    Parent them to SpeedHubXGui.
        --    local dropdownPopupOverlay = Custom:Create("Frame", { Name = "DropdownPopupOverlay", ...}, SpeedHubXGui)
        --    local dropdownContentHolder = Custom:Create("Frame", { Name = "DropdownOptionsPanel", ...}, dropdownPopupOverlay)
        --    local dropdownPagesFolderInstance = Custom:Create("Folder", {Name = "DropdownItemsFolder", Parent = dropdownContentHolder})
        --    local dropdownUIPageLayoutInstance = Custom:Create("UIPageLayout", {... Parent = dropdownPagesFolderInstance})


        -- 6. Copy and Adapt Tabs:CreateTab function
        --    This is the most complex part.
        local TabsApi = {}
        local activeTabFrame = nil -- To keep track of the visually active tab button frame
        local tabLayoutOrderCounter = 0

        function TabsApi:CreateTab(tabConfig)
            local tabName = tabConfig[1] or tabConfig.Name or "Unnamed Tab"
            local tabIcon = tabConfig[2] or tabConfig.Icon or "" -- Default icon if needed
            local currentTabLayoutOrder = tabLayoutOrderCounter
            tabLayoutOrderCounter = tabLayoutOrderCounter + 1

            -- Create ScrolLayers (ContentPage for this tab) in pagesFolderInstance
            -- Use Custom:Create. This is a ScrollingFrame.
            local contentPageForTab = Custom:Create("ScrollingFrame", {
                Name = tabName .. "ContentPage",
                LayoutOrder = currentTabLayoutOrder,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = Custom.ColorRGB,
                CanvasSize = UDim2.new(0,0,0,0), -- Will be updated by its contents
                Parent = pagesFolderInstance -- Or whatever you named the UIPageLayout's parent
            })
            Custom:Create("UIListLayout", { Parent = contentPageForTab, Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center })


            -- Create Tab button frame in tabsListScroll (was ScrollTab)
            -- Use Custom:Create.
            local tabButtonFrameInstance = Custom:Create("Frame", {
                Name = tabName .. "Button",
                BackgroundColor3 = Color3.fromRGB(40,40,40), -- Example colors
                BackgroundTransparency = (currentTabLayoutOrder == 0) and 0.2 or 0.5, -- First tab slightly different
                Size = UDim2.new(1,0,0,35),
                LayoutOrder = currentTabLayoutOrder,
                Parent = tabsListScroll -- Or what you named it
            })
            Custom:Create("UICorner", {CornerRadius = UDim.new(0,4)}, tabButtonFrameInstance)
            -- ... Add Icon ImageLabel, Name TextLabel, and ActiveIndicator Frame to tabButtonFrameInstance

            -- Tab Activation Logic (adapted from zryr)
            local actualTabButton = Custom:Create("TextButton", {Name = "Activator", Text = "", BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Parent = tabButtonFrameInstance})
            actualTabButton.Activated:Connect(function()
                CircleClick(actualTabButton, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) -- Use *this* script's CircleClick

                if activeTabFrame and activeTabFrame ~= tabButtonFrameInstance then
                    -- Deactivate previously active tab button
                    activeTabFrame.BackgroundTransparency = 0.5
                    if activeTabFrame:FindFirstChild("ActiveIndicator") then activeTabFrame.ActiveIndicator.Visible = false end
                    if activeTabFrame:FindFirstChild("TabNameLabel") then activeTabFrame.TabNameLabel.TextColor3 = Color3.fromRGB(200,200,200) end
                end
                -- Activate current tab button
                tabButtonFrameInstance.BackgroundTransparency = 0.2
                if tabButtonFrameInstance:FindFirstChild("ActiveIndicator") then tabButtonFrameInstance.ActiveIndicator.Visible = true end
                if tabButtonFrameInstance:FindFirstChild("TabNameLabel") then tabButtonFrameInstance.TabNameLabel.TextColor3 = Color3.fromRGB(255,255,255) end
                activeTabFrame = tabButtonFrameInstance

                uiPageLayoutInstance:JumpTo(contentPageForTab) -- uiPageLayoutInstance is your main UIPageLayout
                currentTabNameLabel.Text = tabName -- currentTabNameLabel is the label at the top of content area
            end)

            if currentTabLayoutOrder == 0 then -- First tab
                activeTabFrame = tabButtonFrameInstance -- Set as initially active
                task.wait() -- Ensure UI is drawn before firing
                actualTabButton.Activated:Fire()
            end


            -- 7. Copy and Adapt Sections:AddSection function (nested inside CreateTab)
            local SectionsApi = {}
            local sectionLayoutOrderCounter = 0
            function SectionsApi:AddSection(sectionTitle, initiallyOpen)
                sectionTitle = sectionTitle or "Unnamed Section"
                initiallyOpen = initiallyOpen == nil and true or initiallyOpen
                local currentSectionLayoutOrder = sectionLayoutOrderCounter
                sectionLayoutOrderCounter = sectionLayoutOrderCounter + 1

                -- Create Section (main frame), SectionReal (header part), SectionButton (clickable header),
                -- FeatureFrame (chevron holder), FeatureImg (chevron), SectionTitle, SectionDecideFrame, SectionAdd (items container)
                -- Use Custom:Create for all. Parent them correctly within contentPageForTab.
                -- Implement the toggle logic for showing/hiding SectionAdd and updating Section's size and ScrolLayers' CanvasSize.
                -- The UpdateSizeScroll and UpdateSizeSection helper functions from zryr need to be adapted.
                -- Remember that ScrolLayers in zryr is contentPageForTab here.

                -- 8. Copy and Adapt Item:Add<Type> functions (nested inside AddSection)
                local ItemsApi = {}
                local itemLayoutOrderCounter = 0
                function ItemsApi:AddParagraph(paragraphConfig)
                    -- ... Create Paragraph frame, ParagraphTitle, ParagraphContent using Custom:Create
                    -- ... Implement UpdateParagraphSize and the :Set method for the returned API.
                    -- ... The returned object should be the Paragraph frame, with an .Api table attached if needed.
                    -- Example:
                    -- local paragraphFrame = Custom:Create("Frame", {... Parent = sectionItemsContainer})
                    -- local paragraphApi = { Set = function(newConf) ... end }
                    -- paragraphFrame.Api = paragraphApi -- Attach API
                    -- return paragraphFrame -- Return the UI element itself
                end
                function ItemsApi:AddButton(buttonConfig)
                    -- ... (similar adaptation for AddButton)
                end
                function ItemsApi:AddToggle(toggleConfig)
                    -- ... (similar adaptation for AddToggle)
                end
                function ItemsApi:AddSlider(sliderConfig)
                    -- ... (similar adaptation for AddSlider)
                    -- Make sure the UserInputService.InputChanged for dragging is connected/disconnected correctly.
                end
                function ItemsApi:AddInput(inputConfig)
                    -- ... (similar adaptation for AddInput)
                end

                -- THE CRITICAL AddDropdown with SEARCH BAR FIX:
                function ItemsApi:AddDropdown(dropdownConfig)
                    local Title = dropdownConfig[1] or dropdownConfig.Title or "Dropdown"
                    -- ... (get other config: Content, Multi, Options, Default, Callback)
                    itemLayoutOrderCounter = itemLayoutOrderCounter + 1
                    local currentDropdownLayoutOrder = CountDropdown -- Use the global CountDropdown from zryr for UIPageLayout index
                    CountDropdown = CountDropdown + 1 -- Increment the global one

                    local DropdownItemFrame = Custom:Create("Frame", { Name="DropdownItem", LayoutOrder=itemLayoutOrderCounter, BackgroundTransparency=0.935, Size=UDim2.new(1,0,0,35), Parent = sectionItemsContainer}) -- sectionItemsContainer is SectionAdd
                    -- ... (Create DropdownButton, UICorner, DropdownTitle, DropdownContent, SelectOptionsFrame (the clickable part))
                    -- ... (Create OptionSelecting TextLabel, OptionImg ImageLabel inside SelectOptionsFrame)

                    -- This ScrollSelect is for the POPUP
                    local scrollSelectInPopup = Custom:Create("ScrollingFrame", {
                        Name = Title .. "OptionsScroll", -- Unique name for the page layout
                        LayoutOrder = currentDropdownLayoutOrder, -- For DropPageLayout (dropdownUIPageLayoutInstance)
                        BackgroundTransparency = 1, -- Transparent background for the page
                        Size = UDim2.new(1,0,1,0),
                        CanvasSize = UDim2.new(0,0,0,0),
                        ScrollBarThickness = 3,
                        ScrollBarImageColor3 = Custom.ColorRGB,
                        Parent = dropdownPagesFolderInstance -- The Folder inside the popup that has UIPageLayout
                    })
                    Custom:Create("UIListLayout", {Parent = scrollSelectInPopup, Padding = UDim.new(0,3), SortOrder = Enum.SortOrder.LayoutOrder})

                    -- Create SearchBar (PARENTED TO scrollSelectInPopup)
                    local searchBarForDropdown = Custom:Create("TextBox", {
                        Font = Enum.Font.GothamBold, PlaceholderText = "Search", PlaceholderColor3 = Color3.fromRGB(120,120,120),
                        Text = "", TextColor3 = Color3.fromRGB(255,255,255), TextSize = 12,
                        BackgroundColor3 = Color3.fromRGB(25,25,25), BorderColor3 = Color3.fromRGB(50,50,50), BorderSizePixel = 1,
                        Size = UDim2.new(1,0,0,25), LayoutOrder = -1, -- Keep search bar at top
                        Parent = scrollSelectInPopup -- Parented to the options scroller in the popup
                    })
                    Custom:Create("UICorner", {CornerRadius = UDim.new(0,3)}, searchBarForDropdown)
                    Custom:Create("UIPadding", {PaddingLeft = UDim.new(0,5), PaddingRight = UDim.new(0,5)}, searchBarForDropdown)


                    local funcsDropdownApi = {Value = Default, Options = Options} -- API table for this dropdown

                    local function updateDropdownCanvasSize()
                        task.wait()
                        local offsetY = searchBarForDropdown.AbsoluteSize.Y + scrollSelectInPopup.UIListLayout.Padding.Offset
                        for _, child in ipairs(scrollSelectInPopup:GetChildren()) do
                            if child ~= scrollSelectInPopup.UIListLayout and child ~= searchBarForDropdown and child.Visible then
                                offsetY = offsetY + child.AbsoluteSize.Y + scrollSelectInPopup.UIListLayout.Padding.Offset
                            end
                        end
                        scrollSelectInPopup.CanvasSize = UDim2.fromOffset(0, offsetY)
                    end

                    -- SEARCH BAR LOGIC (CORRECTED)
                    searchBarForDropdown:GetPropertyChangedSignal("Text"):Connect(function()
                        local searchText = searchBarForDropdown.Text:lower()
                        for _, childFrame in ipairs(scrollSelectInPopup:GetChildren()) do
                            if childFrame ~= searchBarForDropdown and childFrame.Name ~= "UIListLayout" and childFrame:IsA("Frame") then -- Skip searchbar and layout
                                local optionTextLabel = childFrame:FindFirstChild("OptionText")
                                if optionTextLabel and optionTextLabel:IsA("TextLabel") then
                                    local optionText = optionTextLabel.Text:lower()
                                    childFrame.Visible = (searchText == "" or string.find(optionText, searchText) ~= nil)
                                end
                            end
                        end
                        updateDropdownCanvasSize()
                    end)

                    -- ... (Implement Funcs_Dropdown:Clear, :Set, :AddOption, :Refresh from zryr)
                    --    These methods will operate on `scrollSelectInPopup` and `funcsDropdownApi.Value/Options`.
                    --    `AddOption` creates the option frames and buttons inside `scrollSelectInPopup`.
                    --    Ensure CircleClick is called from this script.

                    -- DropdownButton (the one on the main UI, not in popup) Activated:Connect
                    -- This should make `dropdownPopupOverlay` visible, position `dropdownContentHolder` near the button,
                    -- and use `dropdownUIPageLayoutInstance:JumpToIndex(currentDropdownLayoutOrder)` or `JumpTo(scrollSelectInPopup)`.

                    -- funcsDropdownApi.Refresh(Options, Default) -- Initial population
                    -- DropdownItemFrame.Api = funcsDropdownApi -- Attach API
                    -- return DropdownItemFrame
                end


                function ItemsApi:AddSeperator(sepConfig)
                    -- ... (adaptation for AddSeperator)
                end
                function ItemsApi:AddLine(lineConfig)
                    -- ... (adaptation for AddLine)
                end

                -- Attach the API to the section frame itself or a returned table
                -- sectionFrame.Api = ItemsApi (example)
                -- return sectionFrame (the UI element) or ItemsApi
                return ItemsApi -- As per zryr structure
            end
            -- Attach API to the tab object
            -- tabButtonFrameInstance.Api = SectionsApi (example)
            -- return tabButtonFrameInstance
            local tabReturnObject = {
                AddSection = SectionsApi.AddSection,
                ContentPage = contentPageForTab -- Expose content page if needed for direct manipulation
            }
            return tabReturnObject -- As per zryr structure
        end

        -- Connect Min, Close buttons of the main window.
        -- Min.Activated:Connect ... Open_Close_Button_Instance.Visible = true
        -- Close.Activated:Connect ... SpeedHubXGui:Destroy(), Speed_Library.Unloaded = true

        -- The main return for CreateWindow
        return TabsApi -- This object has the :CreateTab method
    end
    ```

4.  **Return `Speed_Library`:** Ensure the very last line of your entire script is `return Speed_Library`.

---

**Part 3: Corrected `AddDropdown` (Conceptual - to be integrated into your merge)**

This is the corrected search logic part from my previous response, which you'd place inside your merged `ItemsApi:AddDropdown` function:

```lua
-- Inside your merged ItemsApi:AddDropdown, for the SearchBar:
searchBarForDropdown:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = searchBarForDropdown.Text:lower()
    for _, childFrameInPopup in ipairs(scrollSelectInPopup:GetChildren()) do -- scrollSelectInPopup is the ScrollingFrame in the popup
        -- IMPORTANT: Skip the SearchBar itself and the UIListLayout
        if childFrameInPopup ~= searchBarForDropdown and childFrameInPopup.Name ~= "UIListLayout" and childFrameInPopup:IsA("Frame") then
            -- Now, we are reasonably sure childFrameInPopup is an "Option" frame
            local optionTextLabel = childFrameInPopup:FindFirstChild("OptionText") -- The TextLabel holding the option's name
            if optionTextLabel and optionTextLabel:IsA("TextLabel") then
                local optionText = optionTextLabel.Text:lower()
                childFrameInPopup.Visible = (searchText == "" or string.find(optionText, searchText) ~= nil)
            else
                -- This frame might not be a standard option. For safety, keep visible or apply other logic.
                -- childFrameInPopup.Visible = true
            end
        elseif childFrameInPopup == searchBarForDropdown then
             childFrameInPopup.Visible = true -- SearchBar should always be visible
        end
    end
    -- Make sure to call a function that updates scrollSelectInPopup.CanvasSize here!
    -- e.g., updateDropdownCanvasSize()
end)
