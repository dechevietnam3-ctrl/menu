-- ============ SPY V7.4 - ULTIMATE ANTI-HACK & BAN PROTECTION ============
-- 
-- 🎯 TÍNH NĂNG SPY CHÍNH:
-- 1. Remote Spy - Bắt tất cả remote gửi lên server
-- 2. Ban Detection - Phát hiện lệnh ban từ anti-cheat
-- 3. Auto Block - Tự động chặn remote nguy hiểm
-- 4. Anti-Cheat Traffic Monitor - Giám sát traffic anti-cheat
-- 5. Smart Protection - Tự động bảo vệ khi phát hiện nguy cơ
-- 6. Real-time Alert - Cảnh báo khi anti-cheat đang quét
-- 7. Log All Remotes - Ghi log tất cả remote
-- 8. Pattern Detection - Phát hiện pattern nguy hiểm
-- ===========================================================

-- ============ SERVICES ============
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

-- ============ SPY ENGINE ============
local SpyEngine = {
    Enabled = false,
    RemoteLogs = {},
    BlockedRemotes = {},
    SuspiciousRemotes = {},
    AntiCheatTraffic = {},
    BanDetected = false,
    BanCount = 0,
    LastBanAttempt = 0,
    ProtectionLevel = "Normal", -- Normal / High / Ultra
    Stats = {
        TotalRemotes = 0,
        BlockedCount = 0,
        BanAttempts = 0,
        SuspiciousCount = 0,
        ActiveConnections = 0,
    },
}

-- ============ ANTI-CHEAT PATTERNS ============
local BanPatterns = {
    -- Lệnh ban thường gặp
    BanCommands = {
        "Ban", "Kick", "Remove", "Delete", "Destroy",
        "Terminate", "Kill", "ExecuteBan", "BanPlayer",
        "KickPlayer", "RemovePlayer", "BanUser", "KickUser",
        "BanA", "BanB", "BanC", "KickA", "KickB",
    },
    -- Từ khóa nguy hiểm
    DangerousKeywords = {
        "cheat", "hack", "exploit", "detect", "ban",
        "kick", "suspicious", "unauthorized", "violation",
        "tamper", "inject", "modified", "memory",
        "speed", "fly", "jump", "noclip", "teleport",
        "godmode", "aimbot", "silentaim", "spinhack",
    },
    -- Remote nguy hiểm
    DangerousRemotes = {
        "BanPlayer", "KickPlayer", "ExecuteBan",
        "AntiCheatBan", "DetectionBan", "SecurityBan",
        "BanCheck", "KickCheck", "VerifyBan",
    },
}

-- ============ SPY HOOK ENGINE ============
local SpyHooker = {
    Hooked = {},
    OriginalFunctions = {},
    
    -- Hook tất cả remote
    HookAll = function()
        local count = 0
        for _, service in pairs({ReplicatedStorage, Player, game:GetService("ReplicatedFirst")}) do
            count = count + SpyHooker:HookService(service)
        end
        
        -- Hook workspace scripts
        SpyHooker:HookScripts()
        
        print(string.format("🕵️ Hooked %d remotes/scripts", count))
        return count
    end,
    
    -- Hook service
    HookService = function(service)
        local count = 0
        for _, child in ipairs(service:GetChildren()) do
            if child:IsA("RemoteEvent") then
                SpyHooker:HookRemoteEvent(child)
                count = count + 1
            elseif child:IsA("RemoteFunction") then
                SpyHooker:HookRemoteFunction(child)
                count = count + 1
            end
            
            -- Hook con cháu
            if child:GetChildren() then
                count = count + SpyHooker:HookService(child)
            end
        end
        return count
    end,
    
    -- Hook RemoteEvent
    HookRemoteEvent = function(remote)
        if SpyHooker.Hooked[remote] then return end
        
        local original = remote.OnServerEvent
        SpyHooker.OriginalFunctions[remote] = original
        
        remote.OnServerEvent = function(player, ...)
            if SpyEngine.Enabled then
                local args = {...}
                SpyEngine:ProcessRemote(remote, args, "RemoteEvent")
            end
            return original and original(player, ...)
        end
        
        SpyHooker.Hooked[remote] = true
    end,
    
    -- Hook RemoteFunction
    HookRemoteFunction = function(remote)
        if SpyHooker.Hooked[remote] then return end
        
        local original = remote.OnServerInvoke
        SpyHooker.OriginalFunctions[remote] = original
        
        remote.OnServerInvoke = function(player, ...)
            local args = {...}
            local result = nil
            
            if SpyEngine.Enabled then
                SpyEngine:ProcessRemote(remote, args, "RemoteFunction")
                result = original and original(player, ...)
                
                -- Log return value nếu có
                if result then
                    SpyEngine:LogReturn(remote, result)
                end
            else
                result = original and original(player, ...)
            end
            
            return result
        end
        
        SpyHooker.Hooked[remote] = true
    end,
    
    -- Hook scripts để phát hiện anti-cheat
    HookScripts = function()
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                SpyHooker.AnalyzeScript(script)
            end
        end
    end,
    
    -- Analyze script tìm anti-cheat
    AnalyzeScript = function(script)
        local src = script:FindFirstChild("Source") and script.Source.Value or ""
        if type(src) ~= "string" then return end
        
        -- Tìm pattern anti-cheat
        for keyword, _ in pairs(BanPatterns.DangerousKeywords) do
            if src:find(keyword) then
                SpyEngine:RegisterSuspiciousScript(script, keyword)
                break
            end
        end
    end,
}

-- ============ SPY ENGINE PROCESS ============
function SpyEngine:ProcessRemote(remote, args, type)
    if self.BlockedRemotes[remote] then 
        print(string.format("🛑 Blocked: %s", remote.Name))
        return 
    end
    
    -- Log remote
    self:LogRemote(remote, args, type)
    self.Stats.TotalRemotes = self.Stats.TotalRemotes + 1
    
    -- Check ban patterns
    local isBan, pattern = self:CheckBanPattern(remote, args)
    if isBan then
        self:HandleBanAttempt(remote, args, pattern)
        return
    end
    
    -- Check suspicious patterns
    local isSuspicious, keyword = self:CheckSuspicious(remote, args)
    if isSuspicious then
        self:HandleSuspicious(remote, args, keyword)
    end
    
    -- Auto block if needed
    if self.ProtectionLevel == "Ultra" and self:IsDangerous(remote, args) then
        self:BlockRemote(remote)
        self:Notify("🛡️ Auto-blocked: " .. remote.Name)
    end
end

-- ============ BAN PATTERN CHECK ============
function SpyEngine:CheckBanPattern(remote, args)
    local remoteName = remote.Name
    local argsStr = tostring(args)
    
    -- Check tên remote
    for _, pattern in ipairs(BanPatterns.BanCommands) do
        if remoteName:find(pattern) then
            return true, pattern
        end
    end
    
    -- Check args
    for _, arg in ipairs(args) do
        if type(arg) == "string" then
            for _, pattern in ipairs(BanPatterns.BanCommands) do
                if arg:find(pattern) then
                    return true, pattern
                end
            end
        end
    end
    
    -- Check args string
    for _, pattern in ipairs(BanPatterns.DangerousKeywords) do
        if argsStr:find(pattern) then
            return true, pattern
        end
    end
    
    return false, nil
end

-- ============ SUSPICIOUS CHECK ============
function SpyEngine:CheckSuspicious(remote, args)
    local remoteName = remote.Name
    local argsStr = tostring(args)
    
    for _, keyword in ipairs(BanPatterns.DangerousKeywords) do
        if remoteName:find(keyword) or argsStr:find(keyword) then
            return true, keyword
        end
    end
    
    return false, nil
end

-- ============ IS DANGEROUS ============
function SpyEngine:IsDangerous(remote, args)
    local remoteName = remote.Name
    local argsStr = tostring(args)
    
    -- Check dangerous remotes
    for _, pattern in ipairs(BanPatterns.DangerousRemotes) do
        if remoteName:find(pattern) then
            return true
        end
    end
    
    -- Check args for ban patterns
    for _, pattern in ipairs(BanPatterns.BanCommands) do
        if argsStr:find(pattern) then
            return true
        end
    end
    
    return false
end

-- ============ HANDLE BAN ATTEMPT ============
function SpyEngine:HandleBanAttempt(remote, args, pattern)
    self.BanDetected = true
    self.BanCount = self.BanCount + 1
    self.LastBanAttempt = os.time()
    self.Stats.BanAttempts = self.Stats.BanAttempts + 1
    
    -- Block remote ngay lập tức
    self:BlockRemote(remote)
    
    -- Log ban attempt
    local logEntry = {
        Remote = remote,
        Pattern = pattern,
        Args = args,
        Timestamp = os.time(),
        Formatted = string.format("🚨 BAN ATTEMPT! Remote: %s | Pattern: %s", 
            remote.Name, pattern),
    }
    table.insert(self.RemoteLogs, 1, logEntry)
    
    -- Hiển thị cảnh báo
    self:ShowBanAlert(remote, pattern)
    
    -- Tăng protection level
    if self.BanCount >= 3 then
        self.ProtectionLevel = "Ultra"
        self:Notify("🛡️ Protection level increased to ULTRA!")
    elseif self.BanCount >= 1 then
        self.ProtectionLevel = "High"
        self:Notify("🛡️ Protection level increased to HIGH!")
    end
    
    print(string.format("🚨 BAN ATTEMPT DETECTED! Remote: %s | Pattern: %s", 
        remote.Name, pattern))
end

-- ============ HANDLE SUSPICIOUS ============
function SpyEngine:HandleSuspicious(remote, args, keyword)
    self.Stats.SuspiciousCount = self.Stats.SuspiciousCount + 1
    
    if not self.SuspiciousRemotes[remote] then
        self.SuspiciousRemotes[remote] = {
            keyword = keyword,
            count = 0,
            firstSeen = os.time(),
        }
    end
    
    self.SuspiciousRemotes[remote].count = self.SuspiciousRemotes[remote].count + 1
    
    -- Nếu suspicious quá nhiều -> block
    if self.SuspiciousRemotes[remote].count >= 3 and self.ProtectionLevel == "Ultra" then
        self:BlockRemote(remote)
        self:Notify("🛡️ Auto-blocked suspicious remote: " .. remote.Name)
    end
end

-- ============ BLOCK REMOTE ============
function SpyEngine:BlockRemote(remote)
    if self.BlockedRemotes[remote] then return end
    
    self.BlockedRemotes[remote] = true
    self.Stats.BlockedCount = self.Stats.BlockedCount + 1
    
    -- Unhook remote
    SpyHooker.OriginalFunctions[remote] = nil
    SpyHooker.Hooked[remote] = nil
    
    -- Log
    local logEntry = {
        Remote = remote,
        Timestamp = os.time(),
        Formatted = string.format("🛑 Blocked: %s", remote.Name),
    }
    table.insert(self.RemoteLogs, 1, logEntry)
    
    print(string.format("🛑 Blocked remote: %s", remote.Name))
end

-- ============ UNBLOCK REMOTE ============
function SpyEngine:UnblockRemote(remote)
    if not self.BlockedRemotes[remote] then return end
    
    self.BlockedRemotes[remote] = nil
    SpyHooker:HookRemoteEvent(remote)
    
    print(string.format("🔓 Unblocked remote: %s", remote.Name))
end

-- ============ LOG REMOTE ============
function SpyEngine:LogRemote(remote, args, type)
    local logEntry = {
        Remote = remote,
        Args = args,
        Type = type,
        Timestamp = os.time(),
        Formatted = string.format("[%s] %s | Args: %s", 
            os.date("%H:%M:%S"),
            remote.Name,
            #args > 0 and tostring(args):sub(1, 50) or "{}"
        ),
    }
    table.insert(self.RemoteLogs, 1, logEntry)
    
    -- Giới hạn log
    if #self.RemoteLogs > 500 then
        for i = 500, #self.RemoteLogs do
            table.remove(self.RemoteLogs, i)
        end
    end
end

-- ============ LOG RETURN ============
function SpyEngine:LogReturn(remote, result)
    local logEntry = {
        Remote = remote,
        Args = {result},
        Type = "Return",
        Timestamp = os.time(),
        Formatted = string.format("[%s] %s | Return: %s",
            os.date("%H:%M:%S"),
            remote.Name,
            tostring(result):sub(1, 50)
        ),
    }
    table.insert(self.RemoteLogs, 1, logEntry)
end

-- ============ BAN ALERT ============
function SpyEngine:ShowBanAlert(remote, pattern)
    local alert = Instance.new("Frame")
    alert.Size = UDim2.new(0, 400, 0, 80)
    alert.Position = UDim2.new(0.5, -200, 0.3, 0)
    alert.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    alert.BackgroundTransparency = 0.2
    alert.BorderSizePixel = 2
    alert.BorderColor3 = Color3.fromRGB(255, 0, 0)
    alert.Parent = CoreGui
    
    -- Blink animation
    local blink = TweenService:Create(alert, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.1,
    })
    blink:Play()
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 50, 1, 0)
    icon.Text = "🚨"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextSize = 40
    icon.Font = Enum.Font.GothamBold
    icon.BackgroundTransparency = 1
    icon.Parent = alert
    
    -- Text
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -60, 1, 0)
    text.Position = UDim2.new(0, 55, 0, 0)
    text.Text = string.format("🚨 BAN ATTEMPT BLOCKED!\nRemote: %s | Pattern: %s", 
        remote.Name, pattern)
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 14
    text.Font = Enum.Font.GothamBold
    text.TextWrapped = true
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.BackgroundTransparency = 1
    text.Parent = alert
    
    -- Auto remove
    task.wait(4)
    TweenService:Create(alert, TweenInfo.new(0.3), {
        BackgroundTransparency = 1,
    }):Play()
    task.wait(0.3)
    alert:Destroy()
end

-- ============ NOTIFICATION ============
function SpyEngine:Notify(message)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(0.5, -150, 0.8, 0)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    notif.BackgroundTransparency = 0.2
    notif.BorderSizePixel = 0
    notif.Parent = CoreGui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = message
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = notif
    
    -- Animation
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -150, 0.75, 0),
    }):Play()
    
    task.wait(3)
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -150, 0.8, 0),
    }):Play()
    task.wait(0.3)
    notif:Destroy()
end

-- ============ ANTI-HACK DETECTOR (KẾT HỢP V7.3) ============
local AntiHackDetector = {
    DetectionResult = {},
    
    FullScan = function()
        print("🔄 Scanning anti-hack systems...")
        
        local result = {
            GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown",
            SecurityScore = 0,
            AntiCheatType = "Unknown",
            RiskLevel = "Unknown",
            AntiSpeed = {detected = false, confidence = 0},
            AntiJump = {detected = false, confidence = 0},
            AntiFly = {detected = false, confidence = 0},
            AntiNoclip = {detected = false, confidence = 0},
            AntiSpin = {detected = false, confidence = 0},
            AntiTeleport = {detected = false, confidence = 0},
            AntiGodMode = {detected = false, confidence = 0},
            AntiSilentAim = {detected = false, confidence = 0},
            AntiSpeedHack = {detected = false, confidence = 0},
            AntiClickTeleport = {detected = false, confidence = 0},
        }
        
        -- Scan với SpyEngine
        local detectedAntiCheat = {}
        for remote, _ in pairs(SpyEngine.BlockedRemotes) do
            table.insert(detectedAntiCheat, remote.Name)
        end
        
        if #detectedAntiCheat > 0 then
            result.AntiCheatType = "Detected: " .. table.concat(detectedAntiCheat, ", ")
        end
        
        -- Tính điểm dựa trên số lượng remote bị block
        local blockCount = SpyEngine.Stats.BlockedCount
        local totalRemotes = SpyEngine.Stats.TotalRemotes
        
        if totalRemotes > 0 then
            local blockRatio = blockCount / totalRemotes
            result.SecurityScore = math.floor(blockRatio * 100)
        end
        
        -- Risk level từ SpyEngine
        if SpyEngine.ProtectionLevel == "Ultra" then
            result.RiskLevel = "🔴 HIGH - Ultra Protection Active"
        elseif SpyEngine.ProtectionLevel == "High" then
            result.RiskLevel = "🟡 MEDIUM - High Protection Active"
        else
            result.RiskLevel = "🟢 LOW - Normal Protection"
        end
        
        AntiHackDetector.DetectionResult = result
        return result
    end,
}

-- ============ UI ============
local AssessmentUI = {
    ScreenGui = nil,
    IsOpen = false,
    ResultLabel = nil,
    
    Init = function()
        if AssessmentUI.ScreenGui then
            AssessmentUI.Toggle()
            return
        end
        
        AssessmentUI.ScreenGui = Instance.new("ScreenGui")
        AssessmentUI.ScreenGui.Name = "SpyV74UI"
        AssessmentUI.ScreenGui.Parent = CoreGui
        AssessmentUI.ScreenGui.ResetOnSpawn = false
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 550, 0, 700)
        frame.Position = UDim2.new(0.5, -275, 0.5, -350)
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
        frame.BackgroundTransparency = 0.05
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.Parent = AssessmentUI.ScreenGui
        AssessmentUI.MainFrame = frame
        
        -- Title
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 50)
        titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -40, 1, 0)
        title.Text = "🕵️ Spy V7.4 - Anti-Hack & Ban Protection"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 17
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.GothamBold
        title.BackgroundTransparency = 1
        title.Parent = titleBar
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 10)
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 16
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        closeBtn.BorderSizePixel = 0
        closeBtn.Parent = titleBar
        closeBtn.MouseButton1Click:Connect(function()
            AssessmentUI.Toggle()
        end)
        
        -- Buttons
        local btnY = 60
        local btnHeight = 35
        local btnGap = 5
        
        local buttons = {
            {text = "🕵️ START SPY", color = Color3.fromRGB(0, 150, 255), hover = Color3.fromRGB(0, 100, 200)},
            {text = "🛑 STOP SPY", color = Color3.fromRGB(255, 50, 50), hover = Color3.fromRGB(200, 0, 0)},
            {text = "🔍 SCAN ANTI-HACK", color = Color3.fromRGB(0, 200, 100), hover = Color3.fromRGB(0, 150, 50)},
            {text = "📊 SHOW STATUS", color = Color3.fromRGB(255, 150, 0), hover = Color3.fromRGB(200, 100, 0)},
            {text = "🗑️ CLEAR LOGS", color = Color3.fromRGB(150, 50, 255), hover = Color3.fromRGB(100, 0, 200)},
        }
        
        for i, btnData in ipairs(buttons) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 240, 0, btnHeight)
            btn.Position = UDim2.new(0.5, -120, 0, btnY + (i-1) * (btnHeight + btnGap))
            btn.Text = btnData.text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 14
            btn.Font = Enum.Font.GothamBold
            btn.BackgroundColor3 = btnData.color
            btn.BorderSizePixel = 0
            btn.Parent = frame
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = btnData.hover}):Play()
                btn.TextSize = 15
            end)
            
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = btnData.color}):Play()
                btn.TextSize = 14
            end)
            
            -- Click events
            if i == 1 then
                btn.MouseButton1Click:Connect(function()
                    AssessmentUI:StartSpy()
                end)
            elseif i == 2 then
                btn.MouseButton1Click:Connect(function()
                    AssessmentUI:StopSpy()
                end)
            elseif i == 3 then
                btn.MouseButton1Click:Connect(function()
                    AssessmentUI:ScanAntiHack()
                end)
            elseif i == 4 then
                btn.MouseButton1Click:Connect(function()
                    AssessmentUI:ShowStatus()
                end)
            elseif i == 5 then
                btn.MouseButton1Click:Connect(function()
                    AssessmentUI:ClearLogs()
                end)
            end
        end
        
        -- Status bar
        local statusBar = Instance.new("Frame")
        statusBar.Size = UDim2.new(1, -20, 0, 30)
        statusBar.Position = UDim2.new(0, 10, 0, 245)
        statusBar.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
        statusBar.BorderSizePixel = 0
        statusBar.Parent = frame
        
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 1, 0)
        statusLabel.Text = "🔴 SPY INACTIVE | Protection: Normal | Blocks: 0"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        statusLabel.TextSize = 13
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.BackgroundTransparency = 1
        statusLabel.Parent = statusBar
        AssessmentUI.StatusLabel = statusLabel
        
        -- Result display
        local resultFrame = Instance.new("ScrollingFrame")
        resultFrame.Size = UDim2.new(1, -20, 1, -290)
        resultFrame.Position = UDim2.new(0, 10, 0, 280)
        resultFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
        resultFrame.BackgroundTransparency = 0.5
        resultFrame.BorderSizePixel = 0
        resultFrame.Parent = frame
        
        local resultLabel = Instance.new("TextLabel")
        resultLabel.Size = UDim2.new(1, -10, 1, -10)
        resultLabel.Position = UDim2.new(0, 5, 0, 5)
        resultLabel.Text = "🕵️ SPY V7.4 - Anti-Hack & Ban Protection\n\nPress 'START SPY' to begin monitoring\n\nSpy will:\n• Monitor all remote events\n• Detect and block ban attempts\n• Identify anti-cheat traffic\n• Log all suspicious activities\n• Auto-protect when under attack"
        resultLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        resultLabel.TextSize = 13
        resultLabel.Font = Enum.Font.Gotham
        resultLabel.TextWrapped = true
        resultLabel.TextXAlignment = Enum.TextXAlignment.Left
        resultLabel.TextYAlignment = Enum.TextYAlignment.Top
        resultLabel.BackgroundTransparency = 1
        resultLabel.Parent = resultFrame
        
        AssessmentUI.ResultLabel = resultLabel
        AssessmentUI.IsOpen = true
    end,
    
    Toggle = function()
        if AssessmentUI.ScreenGui then
            AssessmentUI.IsOpen = not AssessmentUI.IsOpen
            AssessmentUI.ScreenGui.Enabled = AssessmentUI.IsOpen
        else
            AssessmentUI:Init()
        end
    end,
    
    StartSpy = function()
        SpyEngine.Enabled = true
        SpyHooker:HookAll()
        
        AssessmentUI.StatusLabel.Text = "🟢 SPY ACTIVE | Protection: " .. SpyEngine.ProtectionLevel .. " | Blocks: " .. SpyEngine.Stats.BlockedCount
        AssessmentUI.StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        AssessmentUI.ResultLabel.Text = "🕵️ SPY ACTIVATED!\n\nMonitoring " .. SpyEngine.Stats.TotalRemotes .. " remotes...\n\nClick 'SCAN ANTI-HACK' to check protection levels"
        AssessmentUI.ResultLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        SpyEngine:Notify("🕵️ Spy activated! Monitoring all remotes...")
    end,
    
    StopSpy = function()
        SpyEngine.Enabled = false
        
        AssessmentUI.StatusLabel.Text = "🔴 SPY INACTIVE | Protection: Normal | Blocks: " .. SpyEngine.Stats.BlockedCount
        AssessmentUI.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        AssessmentUI.ResultLabel.Text = "🔴 SPY DEACTIVATED\n\nRemote monitoring stopped\n\nPress 'START SPY' to resume"
        AssessmentUI.ResultLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        SpyEngine:Notify("🔴 Spy deactivated")
    end,
    
    ScanAntiHack = function()
        if not SpyEngine.Enabled then
            AssessmentUI.ResultLabel.Text = "⚠️ Please start SPY first!\n\nPress 'START SPY' to begin monitoring"
            AssessmentUI.ResultLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            return
        end
        
        AssessmentUI.ResultLabel.Text = "🔄 Scanning anti-hack systems...\nPlease wait..."
        AssessmentUI.ResultLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        
        task.wait(1)
        
        local result = AntiHackDetector:FullScan()
        
        local report = {}
        table.insert(report, "╔═══════════════════════════════════════════════════════╗")
        table.insert(report, string.format("  🎯 %s", result.GameName))
        table.insert(report, string.format("  🛡️ Anti-Cheat: %s", result.AntiCheatType))
        table.insert(report, string.format("  📊 Security Score: %d/100", result.SecurityScore))
        table.insert(report, string.format("  ⚡ Risk Level: %s", result.RiskLevel))
        table.insert(report, "╠═══════════════════════════════════════════════════════╣")
        table.insert(report, string.format("  🛑 Blocked Remotes: %d", SpyEngine.Stats.BlockedCount))
        table.insert(report, string.format("  🚨 Ban Attempts: %d", SpyEngine.Stats.BanAttempts))
        table.insert(report, string.format("  ⚠️ Suspicious Remotes: %d", SpyEngine.Stats.SuspiciousCount))
        table.insert(report, string.format("  📡 Total Remotes: %d", SpyEngine.Stats.TotalRemotes))
        table.insert(report, "╠═══════════════════════════════════════════════════════╣")
        table.insert(report, "  💡 PROTECTION STATUS:")
        table.insert(report, string.format("    Level: %s", SpyEngine.ProtectionLevel))
        table.insert(report, string.format("    Active: %s", SpyEngine.Enabled and "✅" or "❌"))
        table.insert(report, string.format("    Ban Detected: %s", SpyEngine.BanDetected and "⚠️" or "✅"))
        table.insert(report, "╚═══════════════════════════════════════════════════════╝")
        
        AssessmentUI.ResultLabel.Text = table.concat(report, "\n")
        AssessmentUI.ResultLabel.TextColor3 = result.SecurityScore >= 70 and 
            Color3.fromRGB(100, 255, 100) or 
            Color3.fromRGB(255, 200, 100)
        
        -- Update status
        AssessmentUI.StatusLabel.Text = "🟢 SPY ACTIVE | Protection: " .. SpyEngine.ProtectionLevel .. " | Blocks: " .. SpyEngine.Stats.BlockedCount
    end,
    
    ShowStatus = function()
        if not SpyEngine.Enabled then
            AssessmentUI.ResultLabel.Text = "⚠️ SPY is not active!\n\nPress 'START SPY' to begin"
            AssessmentUI.ResultLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            return
        end
        
        local status = {}
        table.insert(status, "🕵️ SPY STATUS:")
        table.insert(status, "")
        table.insert(status, string.format("Status: %s", SpyEngine.Enabled and "✅ Active" or "❌ Inactive"))
        table.insert(status, string.format("Protection Level: %s", SpyEngine.ProtectionLevel))
        table.insert(status, string.format("Blocked Remotes: %d", SpyEngine.Stats.BlockedCount))
        table.insert(status, string.format("Ban Attempts: %d", SpyEngine.Stats.BanAttempts))
        table.insert(status, string.format("Suspicious Remotes: %d", SpyEngine.Stats.SuspiciousCount))
        table.insert(status, string.format("Total Remotes: %d", SpyEngine.Stats.TotalRemotes))
        table.insert(status, string.format("Ban Detected: %s", SpyEngine.BanDetected and "⚠️ Yes" : "✅ No"))
        table.insert(status, "")
        
        if SpyEngine.BanDetected then
            table.insert(status, "🚨 WARNING: Ban attempts detected!")
            table.insert(status, string.format("Last attempt: %s", os.date("%H:%M:%S", SpyEngine.LastBanAttempt)))
        else
            table.insert(status, "✅ No ban attempts detected")
        end
        
        table.insert(status, "")
        table.insert(status, "🛡️ Auto-protection is " .. (SpyEngine.ProtectionLevel == "Ultra" and "ACTIVE" : "Standby"))
        
        AssessmentUI.ResultLabel.Text = table.concat(status, "\n")
        AssessmentUI.ResultLabel.TextColor3 = SpyEngine.BanDetected and 
            Color3.fromRGB(255, 100, 100) or 
            Color3.fromRGB(100, 255, 100)
    end,
    
    ClearLogs = function()
        SpyEngine.RemoteLogs = {}
        AssessmentUI.ResultLabel.Text = "🗑️ Logs cleared!\n\nAll remote logs have been removed"
        AssessmentUI.ResultLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    end,
}

-- ============ AUTO PROTECTION LOOP ============
task.spawn(function()
    while true do
        task.wait(5)
        
        if SpyEngine.Enabled then
            -- Tự động giảm protection level nếu không có ban
            if SpyEngine.LastBanAttempt > 0 and os.time() - SpyEngine.LastBanAttempt > 120 then
                if SpyEngine.ProtectionLevel == "Ultra" then
                    SpyEngine.ProtectionLevel = "High"
                    SpyEngine:Notify("🛡️ Protection level decreased to HIGH")
                elseif SpyEngine.ProtectionLevel == "High" and SpyEngine.BanCount < 2 then
                    SpyEngine.ProtectionLevel = "Normal"
                    SpyEngine:Notify("🛡️ Protection level decreased to NORMAL")
                end
            end
            
            -- Update status bar
            if AssessmentUI.StatusLabel then
                AssessmentUI.StatusLabel.Text = "🟢 SPY ACTIVE | Protection: " .. SpyEngine.ProtectionLevel .. " | Blocks: " .. SpyEngine.Stats.BlockedCount
            end
        end
    end
end)

-- ============ KEYBIND ============
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F8 then
        AssessmentUI:Toggle()
    end
    
    if input.KeyCode == Enum.KeyCode.F9 then
        if SpyEngine.Enabled then
            AssessmentUI:StopSpy()
        else
            AssessmentUI:StartSpy()
        end
    end
end)

-- ============ AUTO START ============
task.wait(1)
AssessmentUI:Init()

print([[
╔══════════════════════════════════════════════════════════════════╗
║  🕵️ SPY V7.4 - ULTIMATE ANTI-HACK & BAN PROTECTION             ║
║  ════════════════════════════════════════════════════════════  ║
║                                                               ║
║  🔍 SPY ENGINE:                                               ║
║  • Bắt toàn bộ remote events                                 ║
║  • Phát hiện lệnh ban từ anti-cheat                          ║
║  • Tự động block remote nguy hiểm                            ║
║  • Log tất cả traffic                                        ║
║                                                               ║
║  🛡️ BAN PROTECTION:                                          ║
║  • Phát hiện ban attempt                                     ║
║  • Cảnh báo real-time                                        ║
║  • Auto block remote                                         ║
║  • Tăng protection level khi bị tấn công                    ║
║                                                               ║
║  ⌨️ KEYBINDS:                                                 ║
║  • F8 - Mở UI                                                ║
║  • F9 - Bật/Tắt Spy                                         ║
╚══════════════════════════════════════════════════════════════════╝
]])

-- ============ AUTO START SPY ============
task.wait(0.5)
AssessmentUI:StartSpy()

return {
    Spy = SpyEngine,
    UI = AssessmentUI,
    Detector = AntiHackDetector,
}
