--[[
    AdvancedSpy Pro MAX - Ultimate Edition
    Với đầy đủ Service và hiệu ứng Animation
]]

-- ============ SERVICES ============
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ============ MAIN TABLE ============
local AdvancedSpy = {
    Version = "3.0.0",
    Enabled = false,
    Connections = {},
    RemoteLog = {},
    BlockedRemotes = {},
    ExcludedRemotes = {},
    WhitelistedRemotes = {},
    RemoteStats = {},
    CustomHooks = {},
    Animations = {},
    Settings = {
        Theme = "neon",
        MaxLogs = 2000,
        AutoBlock = false,
        LogReturnValues = true,
        Debug = true,
        ShowAllRemotes = false,
        AutoSave = true,
        FilterSensitive = true,
        LogToFile = false,
        NotificationSound = true,
        HighlightImportant = true,
        SmoothAnimations = true,
        BlurEffect = false,
        Transparency = 0.85
    },
    StartTime = os.time()
}

-- ============ ANIMATION MANAGER ============
local Animations = {
    -- Fade in effect
    FadeIn = function(object, duration, properties)
        duration = duration or 0.3
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(object, tweenInfo, properties or {BackgroundTransparency = 0})
        tween:Play()
        return tween
    end,
    
    -- Slide in effect
    SlideIn = function(object, fromPosition, toPosition, duration)
        duration = duration or 0.4
        object.Position = fromPosition
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(object, tweenInfo, {Position = toPosition})
        tween:Play()
        return tween
    end,
    
    -- Pulse effect
    Pulse = function(object, scale, duration)
        duration = duration or 0.5
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        local tween = TweenService:Create(object, tweenInfo, {Size = UDim2.fromScale(scale, scale)})
        tween:Play()
        return tween
    end,
    
    -- Color transition
    ColorTransition = function(object, color, duration)
        duration = duration or 0.3
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(object, tweenInfo, {BackgroundColor3 = color})
        tween:Play()
        return tween
    end,
    
    -- Glow effect
    Glow = function(object, color, duration)
        duration = duration or 1
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        local tween = TweenService:Create(object, tweenInfo, {
            BackgroundColor3 = color,
            BackgroundTransparency = 0.3
        })
        tween:Play()
        return tween
    end
}

-- ============ UI MANAGER WITH ANIMATIONS ============
local UI = {
    GUI = nil,
    CurrentTab = "Logs",
    Notifications = {},
    
    Create = function()
        -- Main GUI with blur effect
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AdvancedSpyProGUI"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = PlayerGui
        
        -- Background blur (optional)
        if AdvancedSpy.Settings.BlurEffect then
            local blur = Instance.new("BlurEffect")
            blur.Size = 10
            blur.Parent = Lighting
            AdvancedSpy.Connections.Blur = blur
        end
        
        -- Main Frame with animation
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 500, 0, 650)
        mainFrame.Position = UDim2.new(0.5, -250, 0.5, -325)
        mainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
        mainFrame.BackgroundTransparency = AdvancedSpy.Settings.Transparency
        mainFrame.BorderSizePixel = 0
        mainFrame.ClipsDescendants = true
        mainFrame.Parent = screenGui
        
        -- Corner radius
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
        
        -- Shadow effect
        local shadow = Instance.new("ImageLabel")
        shadow.Size = UDim2.new(1, 20, 1, 20)
        shadow.Position = UDim2.new(0, -10, 0, -10)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316048498"
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        shadow.ImageTransparency = 0.5
        shadow.Parent = mainFrame
        shadow.ZIndex = 0
        
        -- Animate entrance
        mainFrame.Position = UDim2.new(0.5, -250, 0.5, -400)
        Animations.SlideIn(mainFrame, UDim2.new(0.5, -250, 0.5, -400), UDim2.new(0.5, -250, 0.5, -325), 0.5)
        
        -- Title Bar with gradient
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mainFrame
        
        -- Title gradient
        local titleGradient = Instance.new("UIGradient")
        titleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 0, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 0, 30))
        })
        titleGradient.Parent = titleBar
        
        -- Glow line
        local glowLine = Instance.new("Frame")
        glowLine.Size = UDim2.new(1, 0, 0, 2)
        glowLine.Position = UDim2.new(0, 0, 1, -2)
        glowLine.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        glowLine.BackgroundTransparency = 0.3
        glowLine.Parent = titleBar
        
        -- Animate glow line
        Animations.Pulse(glowLine, 1.02, 1.5)
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -100, 1, 0)
        titleLabel.Position = UDim2.new(0, 15, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "🔮 AdvancedSpy Pro v" .. AdvancedSpy.Version
        titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        titleLabel.TextSize = 16
        titleLabel.Font = Enum.Font.GothamSemibold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextYAlignment = Enum.TextYAlignment.Center
        titleLabel.Parent = titleBar
        
        -- Control Buttons with animations
        local controls = {"✕", "🗕", "🗖"}
        local controlColors = {Color3.fromRGB(255, 50, 50), Color3.fromRGB(255, 200, 50), Color3.fromRGB(0, 200, 100)}
        for i, text in ipairs(controls) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 28, 1, -8)
            btn.Position = UDim2.new(1, -(i * 32), 0, 4)
            btn.BackgroundColor3 = controlColors[i]
            btn.BackgroundTransparency = 0.8
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 16
            btn.Font = Enum.Font.GothamBold
            btn.Parent = titleBar
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            -- Hover animation
            btn.MouseEnter:Connect(function()
                Animations.ColorTransition(btn, controlColors[i], 0.2)
                btn.BackgroundTransparency = 0.3
            end)
            
            btn.MouseLeave:Connect(function()
                Animations.ColorTransition(btn, controlColors[i], 0.2)
                btn.BackgroundTransparency = 0.8
            end)
            
            btn.MouseButton1Click:Connect(function()
                if text == "✕" then
                    AdvancedSpy:Destroy()
                elseif text == "🗕" then
                    local newSize = mainFrame.Size.Y.Scale == 0 and UDim2.new(0, 500, 0, 650) or UDim2.new(0, 500, 0, 40)
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
                    TweenService:Create(mainFrame, tweenInfo, {Size = newSize}):Play()
                else
                    local newSize = mainFrame.Size.X.Scale == 0 and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 500, 0, 650)
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
                    TweenService:Create(mainFrame, tweenInfo, {Size = newSize}):Play()
                end
            end)
        end
        
        -- Tab Bar with animations
        local tabBar = Instance.new("Frame")
        tabBar.Size = UDim2.new(1, 0, 0, 45)
        tabBar.Position = UDim2.new(0, 0, 0, 40)
        tabBar.BackgroundTransparency = 1
        tabBar.Parent = mainFrame
        
        local tabNames = {"📋 Logs", "📡 Remotes", "📊 Stats", "⚙️ Settings", "🔧 Hooks", "🎮 Control"}
        local tabButtons = {}
        
        for i, name in ipairs(tabNames) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1/#tabNames, -2, 1, -6)
            btn.Position = UDim2.new((i-1) * (1/#tabNames), 1, 0, 3)
            btn.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
            btn.BackgroundTransparency = 0.5
            btn.BorderSizePixel = 0
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(180, 180, 190)
            btn.TextSize = 11
            btn.Font = Enum.Font.GothamMedium
            btn.Parent = tabBar
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            -- Hover animation
            btn.MouseEnter:Connect(function()
                if not btn.Active then
                    Animations.ColorTransition(btn, Color3.fromRGB(40, 0, 80), 0.2)
                end
            end)
            
            btn.MouseLeave:Connect(function()
                if not btn.Active then
                    Animations.ColorTransition(btn, Color3.fromRGB(20, 0, 40), 0.2)
                end
            end)
            
            tabButtons[i] = btn
        end
        
        -- Tab Container
        local tabContainer = Instance.new("Frame")
        tabContainer.Size = UDim2.new(1, 0, 1, -85)
        tabContainer.Position = UDim2.new(0, 0, 0, 85)
        tabContainer.BackgroundTransparency = 1
        tabContainer.Parent = mainFrame
        
        -- Create Tabs
        local tabs = {
            Logs = UI.CreateLogTab(),
            Remotes = UI.CreateRemoteTab(),
            Stats = UI.CreateStatsTab(),
            Settings = UI.CreateSettingsTab(),
            Hooks = UI.CreateHooksTab(),
            Control = UI.CreateControlTab()
        }
        
        for name, content in pairs(tabs) do
            content.Visible = (name == "Logs")
            content.Parent = tabContainer
            tabs[name] = content
        end
        
        -- Tab switching with animation
        for i, btn in ipairs(tabButtons) do
            btn.MouseButton1Click:Connect(function()
                local tabName = tabNames[i]:match("%s*(.-)%s*$"):gsub("[^%w]", "")
                
                -- Hide all tabs with fade out
                for name, content in pairs(tabs) do
                    if content.Visible then
                        local fadeOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        TweenService:Create(content, fadeOut, {BackgroundTransparency = 1}):Play()
                        task.wait(0.1)
                        content.Visible = false
                    end
                end
                
                -- Show selected tab with fade in
                local content = tabs[tabName]
                if content then
                    content.Visible = true
                    content.BackgroundTransparency = 1
                    local fadeIn = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    TweenService:Create(content, fadeIn, {BackgroundTransparency = 0}):Play()
                end
                
                -- Update button styles
                for _, b in ipairs(tabButtons) do
                    b.Active = (b == btn)
                    local targetColor = (b == btn) and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(20, 0, 40)
                    Animations.ColorTransition(b, targetColor, 0.2)
                    b.TextColor3 = (b == btn) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
                end
                
                UI.CurrentTab = tabName
            end)
        end
        
        -- Setup drag
        UI.SetupDrag(titleBar, mainFrame)
        
        -- Keyboard shortcuts
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.F1 then
                mainFrame.Visible = not mainFrame.Visible
                UI.ShowNotification(mainFrame.Visible and "GUI Enabled" or "GUI Disabled")
            end
        end)
        
        UI.GUI = {
            ScreenGui = screenGui,
            Main = mainFrame,
            Tabs = tabs,
            TabContainer = tabContainer,
            TabButtons = tabButtons
        }
        
        return UI.GUI
    end,
    
    -- Tạo các tab (giữ nguyên từ phiên bản trước)
    CreateLogTab = function()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        
        -- Log list
        local logList = Instance.new("ScrollingFrame")
        logList.Size = UDim2.new(1, -10, 1, -10)
        logList.Position = UDim2.new(0, 5, 0, 5)
        logList.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
        logList.BackgroundTransparency = 0.5
        logList.ScrollBarThickness = 4
        logList.Parent = frame
        
        local logListCorner = Instance.new("UICorner")
        logListCorner.CornerRadius = UDim.new(0, 8)
        logListCorner.Parent = logList
        
        local logLayout = Instance.new("UIListLayout")
        logLayout.SortOrder = Enum.SortOrder.LayoutOrder
        logLayout.Padding = UDim.new(0, 2)
        logLayout.Parent = logList
        
        frame.LogList = logList
        return frame
    end,
    
    CreateRemoteTab = function()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        
        local remoteList = Instance.new("ScrollingFrame")
        remoteList.Size = UDim2.new(1, -10, 1, -10)
        remoteList.Position = UDim2.new(0, 5, 0, 5)
        remoteList.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
        remoteList.BackgroundTransparency = 0.5
        remoteList.ScrollBarThickness = 4
        remoteList.Parent = frame
        
        local remoteListCorner = Instance.new("UICorner")
        remoteListCorner.CornerRadius = UDim.new(0, 8)
        remoteListCorner.Parent = remoteList
        
        local remoteLayout = Instance.new("UIListLayout")
        remoteLayout.SortOrder = Enum.SortOrder.LayoutOrder
        remoteLayout.Padding = UDim.new(0, 2)
        remoteLayout.Parent = remoteList
        
        frame.RemoteList = remoteList
        return frame
    end,
    
    CreateStatsTab = function()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        
        local statsFrame = Instance.new("ScrollingFrame")
        statsFrame.Size = UDim2.new(1, -10, 1, -10)
        statsFrame.Position = UDim2.new(0, 5, 0, 5)
        statsFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
        statsFrame.BackgroundTransparency = 0.5
        statsFrame.ScrollBarThickness = 4
        statsFrame.Parent = frame
        
        local statsFrameCorner = Instance.new("UICorner")
        statsFrameCorner.CornerRadius = UDim.new(0, 8)
        statsFrameCorner.Parent = statsFrame
        
        local statsList = Instance.new("UIListLayout")
        statsList.SortOrder = Enum.SortOrder.LayoutOrder
        statsList.Padding = UDim.new(0, 5)
        statsList.Parent = statsFrame
        
        frame.StatsFrame = statsFrame
        frame.StatsList = statsList
        return frame
    end,
    
    CreateSettingsTab = function()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        
        local settingsFrame = Instance.new("ScrollingFrame")
        settingsFrame.Size = UDim2.new(1, -10, 1, -10)
        settingsFrame.Position = UDim2.new(0, 5, 0, 5)
        settingsFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
        settingsFrame.BackgroundTransparency = 0.5
        settingsFrame.ScrollBarThickness = 4
        settingsFrame.Parent = frame
        
        local settingsFrameCorner = Instance.new("UICorner")
        settingsFrameCorner.CornerRadius = UDim.new(0, 8)
        settingsFrameCorner.Parent = settingsFrame
        
        local settingsLayout = Instance.new("UIListLayout")
        settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        settingsLayout.Padding = UDim.new(0, 5)
        settingsLayout.Parent = settingsFrame
        
        frame.SettingsFrame = settingsFrame
        return frame
    end,
    
    CreateHooksTab = function()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        
        local hooksFrame = Instance.new("ScrollingFrame")
        hooksFrame.Size = UDim2.new(1, -10, 1, -10)
        hooksFrame.Position = UDim2.new(0, 5, 0, 5)
        hooksFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
        hooksFrame.BackgroundTransparency = 0.5
        hooksFrame.ScrollBarThickness = 4
        hooksFrame.Parent = frame
        
        local hooksFrameCorner = Instance.new("UICorner")
        hooksFrameCorner.CornerRadius = UDim.new(0, 8)
        hooksFrameCorner.Parent = hooksFrame
        
        local hooksLayout = Instance.new("UIListLayout")
        hooksLayout.SortOrder = Enum.SortOrder.LayoutOrder
        hooksLayout.Padding = UDim.new(0, 5)
        hooksLayout.Parent = hooksFrame
        
        frame.HooksFrame = hooksFrame
        return frame
    end,
    
    CreateControlTab = function()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        
        local controlFrame = Instance.new("Frame")
        controlFrame.Size = UDim2.new(1, -10, 1, -10)
        controlFrame.Position = UDim2.new(0, 5, 0, 5)
        controlFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
        controlFrame.BackgroundTransparency = 0.5
        controlFrame.Parent = frame
        
        local controlFrameCorner = Instance.new("UICorner")
        controlFrameCorner.CornerRadius = UDim.new(0, 8)
        controlFrameCorner.Parent = controlFrame
        
        -- Control buttons
        local controls = {
            {Text = "🔍 Scan Remotes", Action = function() UI.UpdateRemotes() end},
            {Text = "🗑️ Clear Logs", Action = function() AdvancedSpy:ClearLogs() end},
            {Text = "📊 Export Logs", Action = function() AdvancedSpy:ExportLogs() end},
            {Text = "🔄 Reset All", Action = function() AdvancedSpy:ResetAll() end},
            {Text = "📋 Copy Logs", Action = function() AdvancedSpy:CopyLogs() end}
        }
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.Parent = controlFrame
        
        for _, control in ipairs(controls) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
            btn.BorderSizePixel = 0
            btn.Text = control.Text
            btn.TextColor3 = Color3.fromRGB(200, 200, 210)
            btn.TextSize = 14
            btn.Font = Enum.Font.GothamMedium
            btn.Parent = controlFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
            btn.MouseEnter:Connect(function()
                Animations.ColorTransition(btn, Color3.fromRGB(50, 0, 100), 0.2)
            end)
            
            btn.MouseLeave:Connect(function()
                Animations.ColorTransition(btn, Color3.fromRGB(30, 0, 60), 0.2)
            end)
            
            btn.MouseButton1Click:Connect(control.Action)
        end
        
        return frame
    end,
    
    SetupDrag = function(dragObject, target)
        local dragging = false
        local dragStart = nil
        
        dragObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
            end
        end)
        
        dragObject.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        dragObject.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                target.Position = target.Position + UDim2.new(0, delta.X, 0, delta.Y)
                dragStart = input.Position
            end
        end)
    end,
    
    ShowNotification = function(text, duration)
        duration = duration or 2
        -- Simple notification system
        local notification = Instance.new("TextLabel")
        notification.Size = UDim2.new(0, 300, 0, 40)
        notification.Position = UDim2.new(0.5, -150, 0.1, 0)
        notification.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        notification.BackgroundTransparency = 0.1
        notification.Text = text
        notification.TextColor3 = Color3.fromRGB(255, 255, 255)
        notification.TextSize = 14
        notification.Font = Enum.Font.Gotham
        notification.Parent = UI.GUI.ScreenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = notification
        
        -- Animate in
        notification.Position = UDim2.new(0.5, -150, 0.05, -40)
        Animations.SlideIn(notification, UDim2.new(0.5, -150, 0.05, -40), UDim2.new(0.5, -150, 0.1, 0), 0.3)
        
        -- Auto remove
        task.wait(duration)
        Animations.FadeIn(notification, 0.3, {BackgroundTransparency = 1})
        task.wait(0.3)
        notification:Destroy()
    end,
    
    ClearLogs = function()
        if UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Logs and UI.GUI.Tabs.Logs.LogList then
            for _, child in ipairs(UI.GUI.Tabs.Logs.LogList:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end
        end
    end,
    
    UpdateStats = function()
        if not UI.GUI or not UI.GUI.Tabs or not UI.GUI.Tabs.Stats then return end
        
        local statsFrame = UI.GUI.Tabs.Stats.StatsFrame
        if not statsFrame then return end
        
        -- Clear existing stats
        for _, child in ipairs(statsFrame:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "StatsList" then
                child:Destroy()
            end
        end
        
        local stats = {
            {Label = "📊 Total Logs", Value = #AdvancedSpy.RemoteLog},
            {Label = "🚫 Blocked Remotes", Value = #AdvancedSpy.BlockedRemotes},
            {Label = "📡 Total Remotes", Value = #AdvancedSpy:GetAllRemotes()},
            {Label = "📈 Remote Calls", Value = AdvancedSpy.RemoteStats.Calls or 0},
            {Label = "⏱️ Uptime", Value = os.date("%H:%M:%S", os.time() - AdvancedSpy.StartTime)},
            {Label = "🔌 Active Hooks", Value = #AdvancedSpy.CustomHooks},
            {Label = "📦 Memory Usage", Value = string.format("%.1f MB", collectgarbage("count") / 1024)}
        }
        
        for _, stat in ipairs(stats) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -10, 0, 35)
            row.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
            row.BorderSizePixel = 0
            row.Parent = statsFrame
            
            local rowCorner = Instance.new("UICorner")
            rowCorner.CornerRadius = UDim.new(0, 6)
            rowCorner.Parent = row
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6, -5, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = stat.Label
            label.TextColor3 = Color3.fromRGB(200, 200, 210)
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row
            
            local value = Instance.new("TextLabel")
            value.Size = UDim2.new(0.3, -5, 1, 0)
            value.Position = UDim2.new(0.7, 0, 0, 0)
            value.BackgroundTransparency = 1
            value.Text = tostring(stat.Value)
            value.TextColor3 = Color3.fromRGB(0, 255, 200)
            value.TextSize = 14
            value.Font = Enum.Font.GothamBold
            value.TextXAlignment = Enum.TextXAlignment.Right
            value.Parent = row
        end
    end,
    
    UpdateRemotes = function()
        if not UI.GUI or not UI.GUI.Tabs or not UI.GUI.Tabs.Remotes then return end
        
        local remoteList = UI.GUI.Tabs.Remotes.RemoteList
        if not remoteList then return end
        
        -- Clear existing
        for _, child in ipairs(remoteList:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        local remotes = AdvancedSpy:GetAllRemotes()
        for _, remote in ipairs(remotes) do
            if AdvancedSpy.Settings.ShowAllRemotes or not AdvancedSpy:IsExcluded(remote) then
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -4, 0, 35)
                frame.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
                frame.BorderSizePixel = 0
                frame.Parent = remoteList
                
                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 6)
                frameCorner.Parent = frame
                
                -- Icon
                local icon = Instance.new("TextLabel")
                icon.Size = UDim2.new(0, 30, 1, 0)
                icon.BackgroundTransparency = 1
                icon.Text = Utilities.GetRemoteIcon(remote)
                icon.TextColor3 = Color3.fromRGB(200, 200, 210)
                icon.TextSize = 16
                icon.Font = Enum.Font.Gotham
                icon.Parent = frame
                
                local name = Instance.new("TextLabel")
                name.Size = UDim2.new(0.4, -5, 1, 0)
                name.Position = UDim2.new(0, 35, 0, 0)
                name.BackgroundTransparency = 1
                name.Text = remote.Name
                name.TextColor3 = AdvancedSpy:IsBlocked(remote) and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(200, 200, 210)
                name.TextSize = 12
                name.Font = Enum.Font.Gotham
                name.TextXAlignment = Enum.TextXAlignment.Left
                name.Parent = frame
                
                local path = Instance.new("TextLabel")
                path.Size = UDim2.new(0.3, -5, 1, 0)
                path.Position = UDim2.new(0.45, 5, 0, 0)
                path.BackgroundTransparency = 1
                local parent = remote.Parent
                path.Text = parent and parent.Name or "Root"
                path.TextColor3 = Color3.fromRGB(100, 100, 130)
                path.TextSize = 10
                path.Font = Enum.Font.Gotham
                path.TextXAlignment = Enum.TextXAlignment.Left
                path.Parent = frame
                
                local blockBtn = Instance.new("TextButton")
                blockBtn.Size = UDim2.new(0, 35, 1, -4)
                blockBtn.Position = UDim2.new(0.85, 0, 0, 2)
                blockBtn.BackgroundColor3 = AdvancedSpy:IsBlocked(remote) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 40, 40)
                blockBtn.BorderSizePixel = 0
                blockBtn.Text = AdvancedSpy:IsBlocked(remote) and "✅" or "⛔"
                blockBtn.TextSize = 16
                blockBtn.Font = Enum.Font.Gotham
                blockBtn.Parent = frame
                
                local blockCorner = Instance.new("UICorner")
                blockCorner.CornerRadius = UDim.new(0, 6)
                blockCorner.Parent = blockBtn
                
                blockBtn.MouseButton1Click:Connect(function()
                    if AdvancedSpy:IsBlocked(remote) then
                        AdvancedSpy:UnblockRemote(remote)
                        blockBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
                        blockBtn.Text = "⛔"
                        name.TextColor3 = Color3.fromRGB(200, 200, 210)
                        UI.ShowNotification("✅ Unblocked: " .. remote.Name)
                    else
                        AdvancedSpy:BlockRemote(remote)
                        blockBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                        blockBtn.Text = "✅"
                        name.TextColor3 = Color3.fromRGB(255, 70, 70)
                        UI.ShowNotification("⛔ Blocked: " .. remote.Name)
                    end
                end)
            end
        end
    end,
    
    AddLogEntry = function(logEntry)
        if not UI.GUI or not UI.GUI.Tabs or not UI.GUI.Tabs.Logs then return end
        
        local logList = UI.GUI.Tabs.Logs.LogList
        if not logList then return end
        
        -- Check if we need to trim
        while #logList:GetChildren() > AdvancedSpy.Settings.MaxLogs do
            local child = logList:GetChildren()[1]
            if child and child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 45)
        frame.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
        frame.BorderSizePixel = 0
        frame.AutomaticSize = Enum.AutomaticSize.Y
        frame.Parent = logList
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 6)
        frameCorner.Parent = frame
        
        -- Animate entry
        frame.BackgroundTransparency = 1
        Animations.FadeIn(frame, 0.3, {BackgroundTransparency = 0})
        
        -- Time
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Size = UDim2.new(0, 65, 0, 16)
        timeLabel.Position = UDim2.new(0, 5, 0, 2)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = os.date("%H:%M:%S")
        timeLabel.TextColor3 = Color3.fromRGB(100, 100, 130)
        timeLabel.TextSize = 10
        timeLabel.Font = Enum.Font.Gotham
        timeLabel.TextXAlignment = Enum.TextXAlignment.Left
        timeLabel.Parent = frame
        
        -- Remote name
        local remoteName = Instance.new("TextLabel")
        remoteName.Size = UDim2.new(0.6, -5, 0, 18)
        remoteName.Position = UDim2.new(0, 70, 0, 2)
        remoteName.BackgroundTransparency = 1
        remoteName.Text = Utilities.GetRemoteIcon(logEntry.Remote) .. " " .. logEntry.Remote.Name
        remoteName.TextColor3 = Color3.fromRGB(100, 200, 255)
        remoteName.TextSize = 13
        remoteName.Font = Enum.Font.GothamMedium
        remoteName.TextXAlignment = Enum.TextXAlignment.Left
        remoteName.Parent = frame
        
        -- Args
        local argsText = logEntry.Args and Utilities.FormatValue(logEntry.Args) or "{}"
        if AdvancedSpy.Settings.FilterSensitive and Utilities.IsSensitive(argsText) then
            argsText = "[🔒 SENSITIVE DATA HIDDEN]"
        end
        
        local argsLabel = Instance.new("TextLabel")
        argsLabel.Size = UDim2.new(1, -10, 0, 18)
        argsLabel.Position = UDim2.new(0, 5, 0, 22)
        argsLabel.BackgroundTransparency = 1
        argsLabel.Text = "📦 " .. string.sub(argsText, 1, 120) .. (string.len(argsText) > 120 and "..." or "")
        argsLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        argsLabel.TextSize = 11
        argsLabel.Font = Enum.Font.Gotham
        argsLabel.TextXAlignment = Enum.TextXAlignment.Left
        argsLabel.Parent = frame
        
        -- Highlight important events
        if AdvancedSpy.Settings.HighlightImportant then
            local importantKeywords = {"kick", "ban", "admin", "execute", "loadstring", "http", "fire", "teleport"}
            local nameLower = logEntry.Remote.Name:lower()
            for _, keyword in ipairs(importantKeywords) do
                if nameLower:find(keyword) then
                    frame.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
                    remoteName.TextColor3 = Color3.fromRGB(255, 200, 50)
                    -- Pulse effect for important events
                    Animations.Pulse(frame, 1.02, 0.5)
                    break
                end
            end
        end
        
        return frame
    end
}

-- ============ UTILITIES ============
local Utilities = {
    Colors = {
        Success = Color3.fromRGB(0, 255, 100),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 200, 50),
        Info = Color3.fromRGB(50, 200, 255),
        Remote = Color3.fromRGB(150, 100, 255),
        Args = Color3.fromRGB(100, 255, 150),
        Value = Color3.fromRGB(255, 150, 100)
    },
    
    FormatValue = function(value, depth)
        depth = depth or 0
        if depth > 5 then return "... [max depth]" end
        
        local t = typeof(value)
        if t == "string" then
            return '"' .. value .. '"'
        elseif t == "number" or t == "boolean" then
            return tostring(value)
        elseif t == "table" then
            if #value > 0 then
                local str = "{"
                for i, v in ipairs(value) do
                    if i > 1 then str = str .. ", " end
                    str = str .. Utilities.FormatValue(v, depth + 1)
                    if string.len(str) > 200 then
                        str = str .. "... [truncated]"
                        break
                    end
                end
                return str .. "}"
            else
                local str = "{"
                local count = 0
                for k, v in pairs(value) do
                    if count > 0 then str = str .. ", " end
                    str = str .. tostring(k) .. " = " .. Utilities.FormatValue(v, depth + 1)
                    count = count + 1
                    if count > 20 then
                        str = str .. ", ..."
                        break
                    end
                end
                return str .. "}"
            end
        else
            return tostring(value)
        end
    end,
    
    GetRemoteIcon = function(remote)
        if remote:IsA("RemoteEvent") then
            return "📨"
        elseif remote:IsA("RemoteFunction") then
            return "📞"
        elseif remote:IsA("BindableEvent") then
            return "📡"
        elseif remote:IsA("BindableFunction") then
            return "☎️"
        else
            return "🔌"
        end
    end,
    
    IsSensitive = function(value)
        local sensitive = {"password", "token", "key", "secret", "auth", "cookie", "credit", "card"}
        local str = tostring(value):lower()
        for _, s in ipairs(sensitive) do
            if str:find(s) then
                return true
            end
        end
        return false
    end
}

-- ============ REMOTE INTERCEPTOR ============
local RemoteInterceptor = {
    Blocked = {},
    Stats = {},
    Original = {}
}

function RemoteInterceptor:Init()
    -- Hook RemoteEvent FireServer
    local oldIndex = getrawmetatable(game).__index
    if oldIndex then
        getrawmetatable(game).__index = function(t, k)
            local original = oldIndex(t, k)
            if k == "FireServer" and typeof(original) == "function" then
                return function(...)
                    local args = {...}
                    self:ProcessFireServer(t, args)
                    return original(...)
                end
            end
            if k == "InvokeServer" and typeof(original) == "function" then
                return function(...)
                    local args = {...}
                    local returnVal = original(...)
                    self:ProcessInvokeServer(t, args, returnVal)
                    return returnVal
                end
            end
            return original
        end
    end
end

function RemoteInterceptor:ProcessFireServer(remote, args)
    if AdvancedSpy:IsBlocked(remote) then return end
    if AdvancedSpy:IsExcluded(remote) then return end
    
    self.Stats.Calls = (self.Stats.Calls or 0) + 1
    AdvancedSpy.RemoteStats.Calls = (AdvancedSpy.RemoteStats.Calls or 0) + 1
    
    local logEntry = {
        Remote = remote,
        Args = args,
        Timestamp = os.time(),
        Type = "FireServer"
    }
    
    AdvancedSpy:AddLogEntry(logEntry)
    
    -- Trigger custom hooks
    for name, hook in pairs(AdvancedSpy.CustomHooks) do
        pcall(hook, remote, args)
    end
end

function RemoteInterceptor:ProcessInvokeServer(remote, args, returnValue)
    if AdvancedSpy:IsBlocked(remote) then return end
    if AdvancedSpy:IsExcluded(remote) then return end
    
    self.Stats.Calls = (self.Stats.Calls or 0) + 1
    AdvancedSpy.RemoteStats.Calls = (AdvancedSpy.RemoteStats.Calls or 0) + 1
    
    local logEntry = {
        Remote = remote,
        Args = args,
        ReturnValue = returnValue,
        Timestamp = os.time(),
        Type = "InvokeServer"
    }
    
    AdvancedSpy:AddLogEntry(logEntry)
    
    for name, hook in pairs(AdvancedSpy.CustomHooks) do
        pcall(hook, remote, args, returnValue)
    end
end

-- ============ MAIN CLASS ============

function AdvancedSpy:Init()
    if not game then
        warn("AdvancedSpy must be run within Roblox!")
        return
    end
    
    print("🔮 Initializing AdvancedSpy Pro v" .. self.Version)
    
    self.StartTime = os.time()
    RemoteInterceptor:Init()
    UI.Create()
    
    -- Initial updates
    UI.UpdateRemotes()
    UI.UpdateStats()
    
    -- Auto update loops
    task.spawn(function()
        while self.Enabled do
            task.wait(1)
            if self.Enabled then
                UI.UpdateStats()
            end
        end
    end)
    
    task.spawn(function()
        while self.Enabled do
            task.wait(3)
            if self.Enabled then
                UI.UpdateRemotes()
            end
        end
    end)
    
    self.Enabled = true
    print("✅ AdvancedSpy Pro v" .. self.Version .. " loaded successfully!")
    print("🎮 Press F1 to toggle GUI")
    UI.ShowNotification("✅ AdvancedSpy Pro Loaded!", 3)
end

function AdvancedSpy:AddLogEntry(logEntry)
    table.insert(self.RemoteLog, 1, logEntry)
    self:TrimLogs()
    UI.AddLogEntry(logEntry)
end

function AdvancedSpy:GetAllRemotes()
    local remotes = {}
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
            table.insert(remotes, obj)
        end
    end
    return remotes
end

function AdvancedSpy:BlockRemote(remote)
    if not remote then return end
    self.BlockedRemotes[remote] = true
    RemoteInterceptor.Blocked[remote] = true
    print("⛔ Blocked remote: " .. remote.Name)
end

function AdvancedSpy:UnblockRemote(remote)
    if not remote then return end
    self.BlockedRemotes[remote] = nil
    RemoteInterceptor.Blocked[remote] = nil
    print("✅ Unblocked remote: " .. remote.Name)
end

function AdvancedSpy:IsBlocked(remote)
    return remote and self.BlockedRemotes[remote] ~= nil
end

function AdvancedSpy:IsExcluded(remote)
    return remote and self.ExcludedRemotes[remote] ~= nil
end

function AdvancedSpy:ExcludeRemote(remote)
    if not remote then return end
    self.ExcludedRemotes[remote] = true
end

function AdvancedSpy:IncludeRemote(remote)
    if not remote then return end
    self.ExcludedRemotes[remote] = nil
end

function AdvancedSpy:AddHook(name, callback)
    if type(name) ~= "string" or type(callback) ~= "function" then
        warn("Invalid hook parameters")
        return
    end
    self.CustomHooks[name] = callback
    print("🔌 Added hook: " .. name)
    UI.ShowNotification("✅ Hook added: " .. name)
end

function AdvancedSpy:RemoveHook(name)
    if self.CustomHooks[name] then
        self.CustomHooks[name] = nil
        print("🔌 Removed hook: " .. name)
        UI.ShowNotification("❌ Hook removed: " .. name)
        return true
    end
    return false
end

function AdvancedSpy:TrimLogs()
    while #self.RemoteLog > self.Settings.MaxLogs do
        table.remove(self.RemoteLog)
    end
end

function AdvancedSpy:ClearLogs()
    self.RemoteLog = {}
    UI.ClearLogs()
    UI.ShowNotification("🗑️ Logs cleared!")
end

function AdvancedSpy:ExportLogs()
    if #self.RemoteLog == 0 then
        UI.ShowNotification("⚠️ No logs to export!")
        return
    end
    
    local data = ""
    for i, entry in ipairs(self.RemoteLog) do
        data = data .. string.format("[%s] %s | Args: %s\n", 
            os.date("%H:%M:%S", entry.Timestamp),
            entry.Remote.Name,
            Utilities.FormatValue(entry.Args)
        )
    end
    
    -- Copy to clipboard
    setclipboard(data)
    UI.ShowNotification("📋 Logs copied to clipboard! (" .. #self.RemoteLog .. " entries)")
end

function AdvancedSpy:CopyLogs()
    self:ExportLogs()
end

function AdvancedSpy:ResetAll()
    self:ClearLogs()
    self.BlockedRemotes = {}
    self.CustomHooks = {}
    self.RemoteStats = {}
    UI.UpdateRemotes()
    UI.UpdateStats()
    UI.UpdateHooks()
    UI.ShowNotification("🔄 Reset all data!")
end

function AdvancedSpy:Destroy()
    print("🔮 Destroying AdvancedSpy Pro...")
    self.Enabled = false
    
    if UI.GUI and UI.GUI.ScreenGui then
        UI.GUI.ScreenGui:Destroy()
    end
    
    if self.Connections.Blur then
        self.Connections.Blur:Destroy()
    end
    
    self.RemoteLog = {}
    self.BlockedRemotes = {}
    self.ExcludedRemotes = {}
    self.CustomHooks = {}
    
    print("✅ AdvancedSpy Pro destroyed")
end

-- ============ STARTUP ============
AdvancedSpy:Init()

return AdvancedSpy
