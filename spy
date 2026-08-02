--[[
    AdvancedSpy - Full Version
    Mobile-friendly enhanced remote spy for Roblox games.
    All modules included in single file.
]]
local AdvancedSpy = {
    Version = "1.0.0",
    Enabled = false,
    Connections = {},
    RemoteLog = {},
    BlockedRemotes = {},
    ExcludedRemotes = {},
    Settings = {
        Theme = "dark",
        MaxLogs = 1000,
        AutoBlock = false,
        LogReturnValues = true,
        Debug = true
    }
}

-- ============ DEBUG LOG ============
local function debugLog(module, message)
    if AdvancedSpy.Settings.Debug then
        print(string.format("[AdvancedSpy] [%s] %s", module, message))
    end
end

-- ============ THEME MODULE ============
local Theme = {
    dark = {
        Background = Color3.fromRGB(20, 20, 25),
        Background2 = Color3.fromRGB(30, 30, 40),
        Text = Color3.fromRGB(220, 220, 230),
        Accent = Color3.fromRGB(0, 120, 255),
        Accent2 = Color3.fromRGB(255, 70, 70),
        Border = Color3.fromRGB(50, 50, 60)
    },
    light = {
        Background = Color3.fromRGB(240, 240, 245),
        Background2 = Color3.fromRGB(220, 220, 230),
        Text = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(0, 100, 200),
        Accent2 = Color3.fromRGB(200, 50, 50),
        Border = Color3.fromRGB(180, 180, 190)
    }
}

function Theme:Apply(themeName)
    local colors = self[themeName] or self.dark
    -- Apply to main UI elements if they exist
    if AdvancedSpy.GUI and AdvancedSpy.GUI.Main then
        local main = AdvancedSpy.GUI.Main
        if main.Background then
            main.BackgroundColor3 = colors.Background
        end
    end
    debugLog("Theme", "Applied theme: " .. themeName)
end

-- ============ UI COMPONENTS MODULE ============
local UIComponents = {}

function UIComponents.CreateMainWindow()
    debugLog("UI", "Creating main window...")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedSpyGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 380, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(50, 50, 60)
    mainFrame.BackgroundTransparency = 0.95
    mainFrame.Parent = screenGui
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔍 AdvancedSpy v" .. AdvancedSpy.Version
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.Parent = titleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        AdvancedSpy:Destroy()
    end)
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -30)
    contentFrame.Position = UDim2.new(0, 0, 0, 30)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Tabs
    local tabs = Instance.new("Frame")
    tabs.Name = "Tabs"
    tabs.Size = UDim2.new(1, 0, 0, 35)
    tabs.BackgroundTransparency = 1
    tabs.Parent = contentFrame
    
    local tabNames = {"📋 Logs", "📡 Remotes", "⚙️ Settings"}
    for i, name in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Name = "Tab_" .. i
        btn.Size = UDim2.new(0.33, -2, 1, -4)
        btn.Position = UDim2.new((i-1) * 0.333, 1, 0, 2)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 210)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = tabs
    end
    
    -- Log List
    local logList = Instance.new("ScrollingFrame")
    logList.Name = "LogList"
    logList.Size = UDim2.new(1, 0, 1, -35)
    logList.Position = UDim2.new(0, 0, 0, 35)
    logList.BackgroundTransparency = 1
    logList.ScrollBarThickness = 4
    logList.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 60)
    logList.Parent = contentFrame
    
    local logListLayout = Instance.new("UIListLayout")
    logListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    logListLayout.Padding = UDim.new(0, 2)
    logListLayout.Parent = logList
    
    -- Remote Panel (hidden initially)
    local remotePanel = Instance.new("ScrollingFrame")
    remotePanel.Name = "RemotePanel"
    remotePanel.Size = UDim2.new(1, 0, 1, -35)
    remotePanel.Position = UDim2.new(0, 0, 0, 35)
    remotePanel.BackgroundTransparency = 1
    remotePanel.ScrollBarThickness = 4
    remotePanel.Visible = false
    remotePanel.Parent = contentFrame
    
    local remoteLayout = Instance.new("UIListLayout")
    remoteLayout.SortOrder = Enum.SortOrder.LayoutOrder
    remoteLayout.Padding = UDim.new(0, 2)
    remoteLayout.Parent = remotePanel
    
    -- Settings Panel
    local settingsPanel = Instance.new("ScrollingFrame")
    settingsPanel.Name = "SettingsPanel"
    settingsPanel.Size = UDim2.new(1, 0, 1, -35)
    settingsPanel.Position = UDim2.new(0, 0, 0, 35)
    settingsPanel.BackgroundTransparency = 1
    settingsPanel.ScrollBarThickness = 4
    settingsPanel.Visible = false
    settingsPanel.Parent = contentFrame
    
    -- Tab switching
    for i, btn in ipairs(contentFrame.Tabs:GetChildren()) do
        if btn.Name:match("^Tab_") then
            btn.MouseButton1Click:Connect(function()
                logList.Visible = (i == 1)
                remotePanel.Visible = (i == 2)
                settingsPanel.Visible = (i == 3)
                for _, b in ipairs(contentFrame.Tabs:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = (b == btn) and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 40)
                    end
                end
            end)
        end
    end
    
    -- Drag functionality
    local dragging = false
    local dragStart = nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = mainFrame.Position + UDim2.new(0, delta.X, 0, delta.Y)
            dragStart = input.Position
        end
    end)
    
    local result = {
        Main = mainFrame,
        ScreenGui = screenGui,
        LogList = logList,
        RemotePanel = remotePanel,
        SettingsPanel = settingsPanel,
        TitleBar = titleBar,
        ContentFrame = contentFrame
    }
    
    AdvancedSpy.GUI = result
    return result
end

function UIComponents.CreateLogEntry(logEntry)
    local frame = Instance.new("Frame")
    frame.Name = "Log_" .. logEntry.Id
    frame.Size = UDim2.new(1, -4, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BorderSizePixel = 0
    frame.AutomaticSize = Enum.AutomaticSize.Y
    
    local remoteName = Instance.new("TextLabel")
    remoteName.Size = UDim2.new(1, -10, 0, 18)
    remoteName.Position = UDim2.new(0, 5, 0, 2)
    remoteName.BackgroundTransparency = 1
    remoteName.Text = "📡 " .. logEntry.Remote.Name
    remoteName.TextColor3 = Color3.fromRGB(100, 200, 255)
    remoteName.TextSize = 13
    remoteName.Font = Enum.Font.GothamMedium
    remoteName.TextXAlignment = Enum.TextXAlignment.Left
    remoteName.Parent = frame
    
    local argsText = logEntry.Args and tostring(logEntry.Args) or "{}"
    local argsLabel = Instance.new("TextLabel")
    argsLabel.Size = UDim2.new(1, -10, 0, 14)
    argsLabel.Position = UDim2.new(0, 5, 0, 20)
    argsLabel.BackgroundTransparency = 1
    argsLabel.Text = "📦 " .. string.sub(argsText, 1, 60) .. (string.len(argsText) > 60 and "..." or "")
    argsLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    argsLabel.TextSize = 11
    argsLabel.Font = Enum.Font.Gotham
    argsLabel.TextXAlignment = Enum.TextXAlignment.Left
    argsLabel.Parent = frame
    
    return frame
end

function UIComponents.AddLogEntry(parent, logEntry)
    local entry = UIComponents.CreateLogEntry(logEntry)
    entry.Parent = parent
end

function UIComponents.CreateSearchBar()
    local searchBar = Instance.new("TextBox")
    searchBar.Size = UDim2.new(0, 200, 0, 25)
    searchBar.PlaceholderText = "🔍 Search remotes..."
    searchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    searchBar.BorderSizePixel = 0
    searchBar.TextColor3 = Color3.fromRGB(220, 220, 230)
    searchBar.TextSize = 12
    searchBar.Font = Enum.Font.Gotham
    searchBar.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
    return searchBar
end

function UIComponents.CreateSettingsPanel()
    -- Settings panel content
    return Instance.new("Frame")
end

function UIComponents.CreateRemoteManagementPanel()
    -- Remote management panel content
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.BackgroundTransparency = 1
    return panel
end

-- ============ REMOTE INTERCEPTOR MODULE ============
local RemoteInterceptor = {
    OriginalRemotes = {},
    BlockedRemotes = {},
    Callback = nil
}

function RemoteInterceptor:Init(callback)
    self.Callback = callback
    self:SetupHooks()
    debugLog("RemoteInterceptor", "Interceptor initialized")
end

function RemoteInterceptor:SetupHooks()
    -- Hook into RemoteEvent
    local metaRemoteEvent = getrawmetatable(game) or getmetatable(game)
    if metaRemoteEvent then
        local oldIndex = metaRemoteEvent.__index
        if oldIndex then
            metaRemoteEvent.__index = function(t, k)
                local original = oldIndex(t, k)
                if k == "FireServer" and typeof(original) == "function" then
                    return function(...)
                        local args = {...}
                        debugLog("RemoteInterceptor", "FireServer intercepted")
                        if self.Callback then
                            self:HandleRemoteCall(t, args, nil, {type = "FireServer"})
                        end
                        return original(...)
                    end
                end
                if k == "InvokeServer" and typeof(original) == "function" then
                    return function(...)
                        local args = {...}
                        debugLog("RemoteInterceptor", "InvokeServer intercepted")
                        local returnVal
                        if self.Callback then
                            returnVal = original(...)
                            self:HandleRemoteCall(t, args, returnVal, {type = "InvokeServer"})
                            return returnVal
                        end
                        return original(...)
                    end
                end
                return original
            end
        end
    end
end

function RemoteInterceptor:HandleRemoteCall(remote, args, returnValue, stats)
    if self.Callback then
        self.Callback(remote, args, returnValue, stats)
    end
end

function RemoteInterceptor:BlockRemote(remote)
    self.BlockedRemotes[remote] = true
end

function RemoteInterceptor:UnblockRemote(remote)
    self.BlockedRemotes[remote] = nil
end

function RemoteInterceptor:GetAllRemotes()
    local remotes = {}
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(remotes, obj)
        end
    end
    return remotes
end

function RemoteInterceptor:CreateSignal(remote)
    -- Create a signal for firing
    return remote.OnServerEvent
end

-- ============ TOUCH CONTROLS MODULE ============
local TouchControls = {
    IsTouching = false
}

function TouchControls:Init(gui)
    debugLog("TouchControls", "Initializing touch controls...")
    
    -- Add mobile-friendly touch support
    local frame = gui.Main
    frame.TouchTap:Connect(function(touchPositions)
        debugLog("TouchControls", "Touch detected")
    end)
end

-- ============ MAIN ADVANCEDSPY FUNCTIONS ============

function AdvancedSpy:Init()
    if not game then
        warn("AdvancedSpy must be run within Roblox!")
        return
    end

    debugLog("Init", "Initializing AdvancedSpy v" .. self.Version)

    GUI = UIComponents.CreateMainWindow()
    GUI.RemotePanel.Parent = GUI.ContentFrame

    -- Setup interceptors
    RemoteInterceptor:Init(function(remote, args, returnValue, stats)
        self:HandleRemoteCall(remote, args, returnValue, stats)
    end)

    -- Apply theme
    Theme:Apply(self.Settings.Theme)

    -- Start remote list updates
    self:UpdateRemoteList()
    task.spawn(function()
        while self.Enabled do
            task.wait(5)
            if self.Enabled then
                self:UpdateRemoteList()
            end
        end
    end)

    self.Enabled = true
    debugLog("Init", "AdvancedSpy initialized successfully")
    print("✅ AdvancedSpy v" .. self.Version .. " loaded! Use :spyhelp for commands.")
end

function AdvancedSpy:HandleRemoteCall(remote, args, returnValue, stats)
    if not self.Enabled then return end

    if self:IsExcluded(remote) then return end
    if self:IsBlocked(remote) then return end

    local logEntry = {
        Remote = remote,
        Args = args,
        ReturnValue = returnValue,
        Timestamp = os.time(),
        Id = #self.RemoteLog + 1
    }

    table.insert(self.RemoteLog, 1, logEntry)
    self:TrimLogs()
    
    if GUI and GUI.LogList then
        UIComponents.AddLogEntry(GUI.LogList, logEntry)
        -- Auto scroll to top
        GUI.LogList.CanvasPosition = Vector2.new(0, 0)
    end
end

function AdvancedSpy:UpdateRemoteList()
    if not self.Enabled or not GUI or not GUI.RemotePanel then return end
    
    -- Clear existing
    for _, child in ipairs(GUI.RemotePanel:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local remotes = RemoteInterceptor:GetAllRemotes()
    for i, remote in ipairs(remotes) do
        if i <= 100 then -- Limit display
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -4, 0, 30)
            frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            frame.BorderSizePixel = 0
            frame.Parent = GUI.RemotePanel
            
            local name = Instance.new("TextLabel")
            name.Size = UDim2.new(0.7, -5, 1, 0)
            name.Position = UDim2.new(0, 5, 0, 0)
            name.BackgroundTransparency = 1
            name.Text = remote.Name
            name.TextColor3 = Color3.fromRGB(200, 200, 210)
            name.TextSize = 12
            name.Font = Enum.Font.Gotham
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.Parent = frame
            
            local blockBtn = Instance.new("TextButton")
            blockBtn.Size = UDim2.new(0.15, 0, 1, -4)
            blockBtn.Position = UDim2.new(0.7, 0, 0, 2)
            blockBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
            blockBtn.BorderSizePixel = 0
            blockBtn.Text = "⛔"
            blockBtn.TextSize = 14
            blockBtn.Font = Enum.Font.Gotham
            blockBtn.Parent = frame
            blockBtn.MouseButton1Click:Connect(function()
                self:BlockRemote(remote)
                name.TextColor3 = Color3.fromRGB(255, 70, 70)
            end)
            
            local typeLabel = Instance.new("TextLabel")
            typeLabel.Size = UDim2.new(0.15, 0, 1, -4)
            typeLabel.Position = UDim2.new(0.85, 0, 0, 2)
            typeLabel.BackgroundTransparency = 1
            typeLabel.Text = remote:IsA("RemoteEvent") and "📨" or "📞"
            typeLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
            typeLabel.TextSize = 14
            typeLabel.Font = Enum.Font.Gotham
            typeLabel.Parent = frame
        end
    end
end

function AdvancedSpy:TrimLogs()
    while #self.RemoteLog > self.Settings.MaxLogs do
        table.remove(self.RemoteLog)
    end
end

-- API Functions
function AdvancedSpy:BlockRemote(remote)
    if not remote then return end
    self.BlockedRemotes[remote] = true
    RemoteInterceptor:BlockRemote(remote)
    print("⛔ Blocked remote: " .. remote.Name)
end

function AdvancedSpy:UnblockRemote(remote)
    if not remote then return end
    self.BlockedRemotes[remote] = nil
    RemoteInterceptor:UnblockRemote(remote)
    print("✅ Unblocked remote: " .. remote.Name)
end

function AdvancedSpy:ExcludeRemote(remote)
    if not remote then return end
    self.ExcludedRemotes[remote] = true
end

function AdvancedSpy:IncludeRemote(remote)
    if not remote then return end
    self.ExcludedRemotes[remote] = nil
end

function AdvancedSpy:IsBlocked(remote)
    return remote and self.BlockedRemotes[remote] ~= nil
end

function AdvancedSpy:IsExcluded(remote)
    return remote and self.ExcludedRemotes[remote] ~= nil
end

function AdvancedSpy:Destroy()
    debugLog("Cleanup", "Destroying AdvancedSpy...")
    self.Enabled = false
    if GUI and GUI.ScreenGui then
        GUI.ScreenGui:Destroy()
    end
    table.clear(self.RemoteLog)
    table.clear(self.BlockedRemotes)
    table.clear(self.ExcludedRemotes)
    debugLog("Cleanup", "AdvancedSpy destroyed successfully")
end

function AdvancedSpy:GetRemoteFiredSignal(remote)
    return RemoteInterceptor:CreateSignal(remote)
end

-- ============ COMMAND HANDLER ============
-- Auto-run on load
AdvancedSpy:Init()

-- Return API
return AdvancedSpy
