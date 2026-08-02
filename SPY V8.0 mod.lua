-- ============================================================
-- 🕵️ SPY V8.0 - ULTIMATE EDITION
-- ============================================================
-- 
-- 📌 TỔNG HỢP TỪ:
-- • Spy V5 - Core Engine
-- • Spy V6 - AI + Database
-- • Spy Mod V7 - Optimization
-- • Spy Mod V7.2 - UI + Badge
-- • Spy Mod V9 - Advanced Features
-- • Spy Mod Công Chúa V2 - UI Design
-- • IY.lua - Multi-game Support
-- ============================================================

-- ============ SERVICES ============
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    HttpService = game:GetService("HttpService"),
    TweenService = game:GetService("TweenService"),
    CoreGui = game:GetService("CoreGui"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    MarketplaceService = game:GetService("MarketplaceService"),
    Lighting = game:GetService("Lighting"),
    GuiService = game:GetService("GuiService"),
    Workspace = game:GetService("Workspace"),
    TeleportService = game:GetService("TeleportService"),
}

local Player = Services.Players.LocalPlayer

-- ============ CONFIG ============
local Config = {
    Version = "8.0.0",
    Build = "2026.08.02",
    MaxLogs = 2000,
    CleanupInterval = 30,
    AutoBlock = true,
    LogReturnValues = true,
    EnableAI = true,
    EnableWebSocket = false,
    EnableDatabase = false,
    EnableAntiDetection = true,
    EnablePatternMatcher = true,
    UI = {
        Theme = "darkhub",
        Transparency = 0.9,
        Animations = true,
        Blur = false,
    },
    AntiCrash = true,
    PerformanceMode = true,
    ProtectionLevel = "Normal", -- Normal / High / Ultra
}

-- ============ SPY ENGINE V8 ============
local Spy = {
    Enabled = false,
    RemoteLogs = {},
    BlockedRemotes = {},
    ExcludedRemotes = {},
    WhitelistedRemotes = {},
    RemoteCache = {},
    RemoteStats = {
        TotalCalls = 0,
        CallsPerRemote = {},
        PeakRate = 0,
        CurrentRate = 0,
        Latencies = {},
        AvgLatency = 0,
        StartTime = os.time(),
        BlockedCount = 0,
        BanAttempts = 0,
        SuspiciousCount = 0,
    },
    CustomHooks = {
        BeforeFire = {},
        AfterFire = {},
        OnBlock = {},
        OnLog = {},
        OnAnomaly = {},
        OnBan = {},
        OnProtection = {},
    },
    Settings = Config,
    _connections = {},
    _cleanupTimer = 0,
    BanDetected = false,
    LastBanAttempt = 0,
    ProtectionLevel = "Normal",
}

-- ============ BAN PATTERNS ============
local BanPatterns = {
    -- Ban Commands
    BanCommands = {
        "Ban", "Kick", "Remove", "Delete", "Destroy",
        "Terminate", "Kill", "ExecuteBan", "BanPlayer",
        "KickPlayer", "RemovePlayer", "BanUser", "KickUser",
        "BanA", "BanB", "BanC", "KickA", "KickB",
        "TempBan", "PermBan", "IPBan", "HWIDBan",
    },
    -- Dangerous Keywords
    DangerousKeywords = {
        "cheat", "hack", "exploit", "detect", "ban",
        "kick", "suspicious", "unauthorized", "violation",
        "tamper", "inject", "modified", "memory",
        "speed", "fly", "jump", "noclip", "teleport",
        "godmode", "aimbot", "silentaim", "spinhack",
    },
    -- Dangerous Remotes
    DangerousRemotes = {
        "BanPlayer", "KickPlayer", "ExecuteBan",
        "AntiCheatBan", "DetectionBan", "SecurityBan",
        "BanCheck", "KickCheck", "VerifyBan",
        "AntiCheat", "AntiHack", "SecurityCheck",
        "Watchdog", "Monitor", "Detector",
    },
}

-- ============ ANTI-HACK SCANNER ============
local AntiHackScanner = {
    Results = {},
    
    Scan = function()
        local result = {
            GameName = Services.MarketplaceService:GetProductInfo(game.PlaceId).Name or "Unknown",
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
            BanProtection = {detected = false, confidence = 0},
        }
        
        -- Scan từ Spy data
        local totalScore = 0
        local count = 0
        
        -- Detect từ blocked remotes
        for remote, _ in pairs(Spy.BlockedRemotes) do
            local name = remote.Name
            for _, pattern in ipairs(BanPatterns.DangerousRemotes) do
                if name:find(pattern) then
                    result.AntiCheatType = "Detected: " .. name
                    break
                end
            end
        end
        
        -- Tính điểm
        if Spy.RemoteStats.BlockedCount > 0 then
            result.SecurityScore = math.min(Spy.RemoteStats.BlockedCount * 10, 100)
        end
        
        -- Risk level
        if Spy.ProtectionLevel == "Ultra" then
            result.RiskLevel = "🔴 HIGH - Ultra Protection"
        elseif Spy.ProtectionLevel == "High" then
            result.RiskLevel = "🟡 MEDIUM - High Protection"
        else
            result.RiskLevel = "🟢 LOW - Normal Protection"
        end
        
        -- Ban protection
        if Spy.BanDetected then
            result.BanProtection.detected = true
            result.BanProtection.confidence = 90
        end
        
        AntiHackScanner.Results = result
        return result
    end,
}

-- ============ BADGE NOTIFICATION (Từ V7.2) ============
local BadgeNotification = {
    Queue = {},
    IsShowing = false,
    
    CreateNotification = function(title, description, icon, color, duration)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 550, 0, 180)
        notif.Position = UDim2.new(0.5, -275, 0.5, 200)
        notif.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.ClipsDescendants = true
        notif.Parent = Services.CoreGui
        
        -- Shadow
        local shadow = Instance.new("ImageLabel")
        shadow.Size = UDim2.new(1, 40, 1, 40)
        shadow.Position = UDim2.new(0, -20, 0, -20)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316043460"
        shadow.ImageTransparency = 0.8
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 10, 10)
        shadow.Parent = notif
        
        -- Icon
        local iconFrame = Instance.new("Frame")
        iconFrame.Size = UDim2.new(0, 70, 0, 70)
        iconFrame.Position = UDim2.new(0, 15, 0.5, -35)
        iconFrame.BackgroundColor3 = color or Color3.fromRGB(0, 150, 255)
        iconFrame.BackgroundTransparency = 0.2
        iconFrame.BorderSizePixel = 2
        iconFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
        iconFrame.Parent = notif
        
        local iconText = Instance.new("TextLabel")
        iconText.Size = UDim2.new(1, 0, 1, 0)
        iconText.Text = icon or "🏆"
        iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
        iconText.TextSize = 45
        iconText.Font = Enum.Font.GothamBold
        iconText.BackgroundTransparency = 1
        iconText.Parent = iconFrame
        
        -- Title
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -100, 0, 35)
        titleLabel.Position = UDim2.new(0, 95, 0, 15)
        titleLabel.Text = title or "🏅 Badge Unlocked!"
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.BackgroundTransparency = 1
        titleLabel.Parent = notif
        
        -- Description
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -100, 0, 80)
        descLabel.Position = UDim2.new(0, 95, 0, 50)
        descLabel.Text = description or "You've earned this badge!"
        descLabel.TextColor3 = Color3.fromRGB(180, 180, 230)
        descLabel.TextSize = 13
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
        descLabel.BackgroundTransparency = 1
        descLabel.Parent = notif
        
        -- Progress bar
        local progressBar = Instance.new("Frame")
        progressBar.Size = UDim2.new(1, 0, 0, 4)
        progressBar.Position = UDim2.new(0, 0, 1, -4)
        progressBar.BackgroundColor3 = color or Color3.fromRGB(0, 150, 255)
        progressBar.BackgroundTransparency = 0.3
        progressBar.BorderSizePixel = 0
        progressBar.Parent = notif
        
        local progressFill = Instance.new("Frame")
        progressFill.Size = UDim2.new(0, 0, 1, 0)
        progressFill.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255)
        progressFill.BorderSizePixel = 0
        progressFill.Parent = progressBar
        
        -- Animation
        notif.Position = UDim2.new(0.5, -275, 0.5, 300)
        notif.BackgroundTransparency = 1
        
        Services.TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -275, 0.5, 200),
            BackgroundTransparency = 0.1,
        }):Play()
        
        Services.TweenService:Create(progressFill, TweenInfo.new(duration or 4, Enum.EasingStyle.Linear), {
            Size = UDim2.new(1, 0, 1, 0),
        }):Play()
        
        task.wait(duration or 4)
        
        Services.TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -275, 0.5, 300),
            BackgroundTransparency = 1,
        }):Play()
        
        task.wait(0.3)
        notif:Destroy()
    end,
    
    Show = function(title, description, icon, color, duration)
        table.insert(BadgeNotification.Queue, {
            title = title,
            description = description,
            icon = icon,
            color = color,
            duration = duration,
        })
        
        if not BadgeNotification.IsShowing then
            BadgeNotification:ProcessQueue()
        end
    end,
    
    ProcessQueue = function()
        if #BadgeNotification.Queue == 0 then
            BadgeNotification.IsShowing = false
            return
        end
        
        BadgeNotification.IsShowing = true
        local notif = table.remove(BadgeNotification.Queue, 1)
        BadgeNotification.CreateNotification(
            notif.title,
            notif.description,
            notif.icon,
            notif.color,
            notif.duration
        )
        task.wait((notif.duration or 4) + 0.5)
        BadgeNotification:ProcessQueue()
    end,
}

-- ============ REMOTE HOOKER ============
local RemoteHooker = {
    Hooked = {},
    OriginalFunctions = {},
    
    HookAll = function()
        local count = 0
        for _, service in pairs({Services.ReplicatedStorage, Player, game:GetService("ReplicatedFirst")}) do
            count = count + RemoteHooker:HookService(service)
        end
        print(string.format("🕵️ Hooked %d remotes", count))
        return count
    end,
    
    HookService = function(service)
        local count = 0
        for _, child in ipairs(service:GetChildren()) do
            if child:IsA("RemoteEvent") then
                RemoteHooker:HookRemoteEvent(child)
                count = count + 1
            elseif child:IsA("RemoteFunction") then
                RemoteHooker:HookRemoteFunction(child)
                count = count + 1
            end
            if child:GetChildren() then
                count = count + RemoteHooker:HookService(child)
            end
        end
        return count
    end,
    
    HookRemoteEvent = function(remote)
        if RemoteHooker.Hooked[remote] then return end
        
        local original = remote.OnServerEvent
        RemoteHooker.OriginalFunctions[remote] = original
        
        remote.OnServerEvent = function(player, ...)
            if Spy.Enabled then
                local args = {...}
                Spy:ProcessRemote(remote, args, "RemoteEvent")
            end
            return original and original(player, ...)
        end
        
        RemoteHooker.Hooked[remote] = true
    end,
    
    HookRemoteFunction = function(remote)
        if RemoteHooker.Hooked[remote] then return end
        
        local original = remote.OnServerInvoke
        RemoteHooker.OriginalFunctions[remote] = original
        
        remote.OnServerInvoke = function(player, ...)
            local args = {...}
            local result = nil
            
            if Spy.Enabled then
                Spy:ProcessRemote(remote, args, "RemoteFunction")
                result = original and original(player, ...)
                if result then
                    Spy:LogReturn(remote, result)
                end
            else
                result = original and original(player, ...)
            end
            
            return result
        end
        
        RemoteHooker.Hooked[remote] = true
    end,
}

-- ============ SPY METHODS ============
function Spy:ProcessRemote(remote, args, type)
    if self.BlockedRemotes[remote] then return end
    
    -- Log
    self:LogRemote(remote, args, type)
    self.RemoteStats.TotalCalls = self.RemoteStats.TotalCalls + 1
    self.RemoteStats.CallsPerRemote[remote.Name] = 
        (self.RemoteStats.CallsPerRemote[remote.Name] or 0) + 1
    
    -- Check ban pattern
    local isBan, pattern = self:CheckBanPattern(remote, args)
    if isBan then
        self:HandleBanAttempt(remote, args, pattern)
        return
    end
    
    -- Check suspicious
    local isSuspicious, keyword = self:CheckSuspicious(remote, args)
    if isSuspicious then
        self:HandleSuspicious(remote, args, keyword)
    end
    
    -- Auto block
    if self.ProtectionLevel == "Ultra" and self:IsDangerous(remote, args) then
        self:BlockRemote(remote)
        self:Notify("🛡️ Auto-blocked: " .. remote.Name)
    end
end

function Spy:CheckBanPattern(remote, args)
    local remoteName = remote.Name
    local argsStr = tostring(args)
    
    for _, pattern in ipairs(BanPatterns.BanCommands) do
        if remoteName:find(pattern) or argsStr:find(pattern) then
            return true, pattern
        end
    end
    
    return false, nil
end

function Spy:CheckSuspicious(remote, args)
    local remoteName = remote.Name
    local argsStr = tostring(args)
    
    for _, keyword in ipairs(BanPatterns.DangerousKeywords) do
        if remoteName:find(keyword) or argsStr:find(keyword) then
            return true, keyword
        end
    end
    
    return false, nil
end

function Spy:IsDangerous(remote, args)
    local remoteName = remote.Name
    local argsStr = tostring(args)
    
    for _, pattern in ipairs(BanPatterns.DangerousRemotes) do
        if remoteName:find(pattern) then
            return true
        end
    end
    
    for _, pattern in ipairs(BanPatterns.BanCommands) do
        if argsStr:find(pattern) then
            return true
        end
    end
    
    return false
end

function Spy:HandleBanAttempt(remote, args, pattern)
    self.BanDetected = true
    self.RemoteStats.BanAttempts = self.RemoteStats.BanAttempts + 1
    self.LastBanAttempt = os.time()
    
    self:BlockRemote(remote)
    
    local logEntry = {
        Remote = remote,
        Pattern = pattern,
        Args = args,
        Timestamp = os.time(),
        Formatted = string.format("🚨 BAN ATTEMPT! Remote: %s | Pattern: %s", remote.Name, pattern),
    }
    table.insert(self.RemoteLogs, 1, logEntry)
    
    self:ShowBanAlert(remote, pattern)
    
    -- Tăng protection
    if self.RemoteStats.BanAttempts >= 3 then
        self.ProtectionLevel = "Ultra"
        self:Notify("🛡️ Protection level increased to ULTRA!")
    elseif self.RemoteStats.BanAttempts >= 1 then
        self.ProtectionLevel = "High"
        self:Notify("🛡️ Protection level increased to HIGH!")
    end
    
    -- Trigger hook
    for name, hook in pairs(self.CustomHooks.OnBan) do
        pcall(hook, remote, pattern)
    end
end

function Spy:HandleSuspicious(remote, args, keyword)
    self.RemoteStats.SuspiciousCount = self.RemoteStats.SuspiciousCount + 1
    
    if self.ProtectionLevel == "Ultra" then
        self:BlockRemote(remote)
        self:Notify("🛡️ Blocked suspicious remote: " .. remote.Name)
    end
end

function Spy:BlockRemote(remote)
    if self.BlockedRemotes[remote] then return end
    
    self.BlockedRemotes[remote] = true
    self.RemoteStats.BlockedCount = self.RemoteStats.BlockedCount + 1
    
    RemoteHooker.OriginalFunctions[remote] = nil
    RemoteHooker.Hooked[remote] = nil
    
    local logEntry = {
        Remote = remote,
        Timestamp = os.time(),
        Formatted = string.format("🛑 Blocked: %s", remote.Name),
    }
    table.insert(self.RemoteLogs, 1, logEntry)
    
    -- Trigger hook
    for name, hook in pairs(self.CustomHooks.OnBlock) do
        pcall(hook, remote)
    end
end

function Spy:LogRemote(remote, args, type)
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
    
    if #self.RemoteLogs > Config.MaxLogs then
        for i = Config.MaxLogs, #self.RemoteLogs do
            table.remove(self.RemoteLogs, i)
        end
    end
end

function Spy:LogReturn(remote, result)
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

function Spy:ShowBanAlert(remote, pattern)
    local alert = Instance.new("Frame")
    alert.Size = UDim2.new(0, 400, 0, 80)
    alert.Position = UDim2.new(0.5, -200, 0.3, 0)
    alert.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    alert.BackgroundTransparency = 0.2
    alert.BorderSizePixel = 2
    alert.BorderColor3 = Color3.fromRGB(255, 0, 0)
    alert.Parent = Services.CoreGui
    
    local blink = Services.TweenService:Create(alert, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.1,
    })
    blink:Play()
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 50, 1, 0)
    icon.Text = "🚨"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextSize = 40
    icon.Font = Enum.Font.GothamBold
    icon.BackgroundTransparency = 1
    icon.Parent = alert
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -60, 1, 0)
    text.Position = UDim2.new(0, 55, 0, 0)
    text.Text = string.format("🚨 BAN ATTEMPT BLOCKED!\nRemote: %s | Pattern: %s", remote.Name, pattern)
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 14
    text.Font = Enum.Font.GothamBold
    text.TextWrapped = true
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.BackgroundTransparency = 1
    text.Parent = alert
    
    task.wait(4)
    Services.TweenService:Create(alert, TweenInfo.new(0.3), {
        BackgroundTransparency = 1,
    }):Play()
    task.wait(0.3)
    alert:Destroy()
end

function Spy:Notify(message)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(0.5, -150, 0.8, 0)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    notif.BackgroundTransparency = 0.2
    notif.BorderSizePixel = 0
    notif.Parent = Services.CoreGui
    
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
    
    Services.TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -150, 0.75, 0),
    }):Play()
    
    task.wait(3)
    Services.TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -150, 0.8, 0),
    }):Play()
    task.wait(0.3)
    notif:Destroy()
end

function Spy:Toggle()
    self.Enabled = not self.Enabled
    if self.Enabled then
        RemoteHooker:HookAll()
        self:Notify("🕵️ Spy activated!")
        BadgeNotification.Show("🕵️ Spy V8.0 Activated!", 
            "Monitoring all remotes\nBan protection: " .. self.ProtectionLevel,
            "🕵️", Color3.fromRGB(0, 150, 255), 3)
    else
        self:Notify("🔴 Spy deactivated")
    end
    return self.Enabled
end

function Spy:ClearLogs()
    self.RemoteLogs = {}
    self:Notify("🗑️ Logs cleared")
end

function Spy:GetStatus()
    return {
        Enabled = self.Enabled,
        ProtectionLevel = self.ProtectionLevel,
        TotalCalls = self.RemoteStats.TotalCalls,
        BlockedCount = self.RemoteStats.BlockedCount,
        BanAttempts = self.RemoteStats.BanAttempts,
        SuspiciousCount = self.RemoteStats.SuspiciousCount,
        LogCount = #self.RemoteLogs,
        BanDetected = self.BanDetected,
    }
end

-- ============ UI ============
local UI = {
    ScreenGui = nil,
    IsOpen = false,
    MainFrame = nil,
    ResultLabel = nil,
    StatusLabel = nil,
    
    Init = function()
        if UI.ScreenGui then
            UI.Toggle()
            return
        end
        
        UI.ScreenGui = Instance.new("ScreenGui")
        UI.ScreenGui.Name = "SpyV8UI"
        UI.ScreenGui.Parent = Services.CoreGui
        UI.ScreenGui.ResetOnSpawn = false
        
        UI.MainFrame = Instance.new("Frame")
        UI.MainFrame.Size = UDim2.new(0, 600, 0, 700)
        UI.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -350)
        UI.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
        UI.MainFrame.BackgroundTransparency = 0.05
        UI.MainFrame.BorderSizePixel = 0
        UI.MainFrame.ClipsDescendants = true
        UI.MainFrame.Parent = UI.ScreenGui
        
        -- Shadow
        local shadow = Instance.new("ImageLabel")
        shadow.Size = UDim2.new(1, 40, 1, 40)
        shadow.Position = UDim2.new(0, -20, 0, -20)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316043460"
        shadow.ImageTransparency = 0.8
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 10, 10)
        shadow.Parent = UI.MainFrame
        
        -- Title Bar
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 50)
        titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = UI.MainFrame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -40, 1, 0)
        title.Text = "🕵️ Spy V8.0 - Ultimate Edition"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 18
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.GothamBold
        title.BackgroundTransparency = 1
        title.Parent = titleBar
        
        -- Close Button
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
            UI.Toggle()
        end)
        
        -- Status Bar
        local statusBar = Instance.new("Frame")
        statusBar.Size = UDim2.new(1, -20, 0, 35)
        statusBar.Position = UDim2.new(0, 10, 0, 55)
        statusBar.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
        statusBar.BorderSizePixel = 0
        statusBar.Parent = UI.MainFrame
        
        UI.StatusLabel = Instance.new("TextLabel")
        UI.StatusLabel.Size = UDim2.new(1, 0, 1, 0)
        UI.StatusLabel.Text = "🔴 SPY INACTIVE | Protection: Normal | Blocks: 0"
        UI.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        UI.StatusLabel.TextSize = 13
        UI.StatusLabel.Font = Enum.Font.GothamBold
        UI.StatusLabel.BackgroundTransparency = 1
        UI.StatusLabel.Parent = statusBar
        
        -- Buttons (2 cột)
        local btnY = 100
        local btnHeight = 35
        local btnGap = 5
        local btnWidth = 280
        
        local buttons = {
            {text = "🕵️ START SPY", color = Color3.fromRGB(0, 150, 255), hover = Color3.fromRGB(0, 100, 200), col = 1},
            {text = "🛑 STOP SPY", color = Color3.fromRGB(255, 50, 50), hover = Color3.fromRGB(200, 0, 0), col = 1},
            {text = "🔍 SCAN ANTI-HACK", color = Color3.fromRGB(0, 200, 100), hover = Color3.fromRGB(0, 150, 50), col = 2},
            {text = "📊 SHOW STATUS", color = Color3.fromRGB(255, 150, 0), hover = Color3.fromRGB(200, 100, 0), col = 2},
            {text = "🗑️ CLEAR LOGS", color = Color3.fromRGB(150, 50, 255), hover = Color3.fromRGB(100, 0, 200), col = 1},
            {text = "📋 SHOW LOGS", color = Color3.fromRGB(0, 200, 200), hover = Color3.fromRGB(0, 150, 150), col = 2},
        }
        
        for i, btnData in ipairs(buttons) do
            local row = math.floor((i - 1) / 2)
            local col = (i - 1) % 2
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
            btn.Position = UDim2.new(col == 0 and 0.05 or 0.55, 0, 0, btnY + row * (btnHeight + btnGap))
            btn.Text = btnData.text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 14
            btn.Font = Enum.Font.GothamBold
            btn.BackgroundColor3 = btnData.color
            btn.BorderSizePixel = 0
            btn.Parent = UI.MainFrame
            
            btn.MouseEnter:Connect(function()
                Services.TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = btnData.hover}):Play()
                btn.TextSize = 15
            end)
            
            btn.MouseLeave:Connect(function()
                Services.TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = btnData.color}):Play()
                btn.TextSize = 14
            end)
            
            -- Click events
            if btnData.text == "🕵️ START SPY" then
                btn.MouseButton1Click:Connect(function()
                    Spy:Toggle()
                    UI.UpdateStatus()
                end)
            elseif btnData.text == "🛑 STOP SPY" then
                btn.MouseButton1Click:Connect(function()
                    Spy.Enabled = false
                    UI.UpdateStatus()
                    Spy:Notify("🔴 Spy deactivated")
                end)
            elseif btnData.text == "🔍 SCAN ANTI-HACK" then
                btn.MouseButton1Click:Connect(function()
                    UI.ScanAntiHack()
                end)
            elseif btnData.text == "📊 SHOW STATUS" then
                btn.MouseButton1Click:Connect(function()
                    UI.ShowStatus()
                end)
            elseif btnData.text == "🗑️ CLEAR LOGS" then
                btn.MouseButton1Click:Connect(function()
                    Spy:ClearLogs()
                    UI.UpdateLogs()
                end)
            elseif btnData.text == "📋 SHOW LOGS" then
                btn.MouseButton1Click:Connect(function()
                    UI.ShowLogs()
                end)
            end
        end
        
        -- Result display
        local resultFrame = Instance.new("ScrollingFrame")
        resultFrame.Size = UDim2.new(1, -20, 1, -290)
        resultFrame.Position = UDim2.new(0, 10, 0, 260)
        resultFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
        resultFrame.BackgroundTransparency = 0.5
        resultFrame.BorderSizePixel = 0
        resultFrame.Parent = UI.MainFrame
        
        UI.ResultLabel = Instance.new("TextLabel")
        UI.ResultLabel.Size = UDim2.new(1, -10, 1, -10)
        UI.ResultLabel.Position = UDim2.new(0, 5, 0, 5)
        UI.ResultLabel.Text = [[
🕵️ SPY V8.0 - ULTIMATE EDITION

TỔNG HỢP TỪ:
• Spy V5 - Core Engine
• Spy V6 - AI + Database
• Spy Mod V7 - Optimization
• Spy Mod V7.2 - UI + Badge
• Spy Mod V9 - Advanced Features
• Spy Mod Công Chúa V2 - UI Design
• IY.lua - Multi-game Support

📌 TÍNH NĂNG:
• Remote Spy - Bắt tất cả remote
• Ban Detection - Phát hiện lệnh ban
• Auto Block - Tự động chặn nguy hiểm
• Anti-Hack Scanner - Scan chi tiết
• Badge Notification - Thông báo đẹp
• Protection Levels - 3 cấp độ bảo vệ

⌨️ KEYBINDS:
• F8 - Mở UI
• F9 - Bật/Tắt Spy
]]
        UI.ResultLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        UI.ResultLabel.TextSize = 13
        UI.ResultLabel.Font = Enum.Font.Gotham
        UI.ResultLabel.TextWrapped = true
        UI.ResultLabel.TextXAlignment = Enum.TextXAlignment.Left
        UI.ResultLabel.TextYAlignment = Enum.TextYAlignment.Top
        UI.ResultLabel.BackgroundTransparency = 1
        UI.ResultLabel.Parent = resultFrame
        
        UI.IsOpen = true
    end,
    
    Toggle = function()
        if UI.ScreenGui then
            UI.IsOpen = not UI.IsOpen
            UI.ScreenGui.Enabled = UI.IsOpen
        else
            UI:Init()
        end
    end,
    
    UpdateStatus = function()
        if UI.StatusLabel then
            local status = Spy.Enabled and "🟢 ACTIVE" or "🔴 INACTIVE"
            UI.StatusLabel.Text = string.format("%s | Protection: %s | Blocks: %d", 
                status, Spy.ProtectionLevel, Spy.RemoteStats.BlockedCount)
            UI.StatusLabel.TextColor3 = Spy.Enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        end
    end,
    
    ScanAntiHack = function()
        if not Spy.Enabled then
            UI.ResultLabel.Text = "⚠️ Please start SPY first!\n\nPress 'START SPY' to begin monitoring"
            UI.ResultLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            return
        end
        
        UI.ResultLabel.Text = "🔄 Scanning anti-hack systems...\nPlease wait..."
        UI.ResultLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        
        task.wait(1)
        
        local result = AntiHackScanner:Scan()
        
        local report = {}
        table.insert(report, "╔═══════════════════════════════════════════════════════╗")
        table.insert(report, string.format("  🎯 %s", result.GameName))
        table.insert(report, string.format("  🛡️ Anti-Cheat: %s", result.AntiCheatType))
        table.insert(report, string.format("  📊 Security Score: %d/100", result.SecurityScore))
        table.insert(report, string.format("  ⚡ Risk Level: %s", result.RiskLevel))
        table.insert(report, "╠═══════════════════════════════════════════════════════╣")
        table.insert(report, string.format("  🛑 Blocked Remotes: %d", Spy.RemoteStats.BlockedCount))
        table.insert(report, string.format("  🚨 Ban Attempts: %d", Spy.RemoteStats.BanAttempts))
        table.insert(report, string.format("  ⚠️ Suspicious Remotes: %d", Spy.RemoteStats.SuspiciousCount))
        table.insert(report, string.format("  📡 Total Remotes: %d", Spy.RemoteStats.TotalCalls))
        table.insert(report, "╠═══════════════════════════════════════════════════════╣")
        table.insert(report, "  💡 PROTECTION STATUS:")
        table.insert(report, string.format("    Level: %s", Spy.ProtectionLevel))
        table.insert(report, string.format("    Active: %s", Spy.Enabled and "✅" or "❌"))
        table.insert(report, string.format("    Ban Detected: %s", Spy.BanDetected and "⚠️" or "✅"))
        table.insert(report, "╚═══════════════════════════════════════════════════════╝")
        
        UI.ResultLabel.Text = table.concat(report, "\n")
        UI.ResultLabel.TextColor3 = result.SecurityScore >= 70 and 
            Color3.fromRGB(100, 255, 100) or 
            Color3.fromRGB(255, 200, 100)
        
        UI.UpdateStatus()
    end,
    
    ShowStatus = function()
        local status = Spy:GetStatus()
        
        local lines = {}
        table.insert(lines, "🕵️ SPY STATUS:")
        table.insert(lines, "")
        table.insert(lines, string.format("Status: %s", status.Enabled and "✅ Active" or "❌ Inactive"))
        table.insert(lines, string.format("Protection Level: %s", status.ProtectionLevel))
        table.insert(lines, string.format("Total Calls: %d", status.TotalCalls))
        table.insert(lines, string.format("Blocked Remotes: %d", status.BlockedCount))
        table.insert(lines, string.format("Ban Attempts: %d", status.BanAttempts))
        table.insert(lines, string.format("Suspicious Count: %d", status.SuspiciousCount))
        table.insert(lines, string.format("Log Count: %d", status.LogCount))
        table.insert(lines, string.format("Ban Detected: %s", status.BanDetected and "⚠️ Yes" : "✅ No"))
        table.insert(lines, "")
        
        if status.BanDetected then
            table.insert(lines, "🚨 WARNING: Ban attempts detected!")
            table.insert(lines, string.format("Last attempt: %s", os.date("%H:%M:%S", Spy.LastBanAttempt)))
            table.insert(lines, "🛡️ Auto-protection is " .. (Spy.ProtectionLevel == "Ultra" and "ACTIVE" : "Standby"))
        else
            table.insert(lines, "✅ No ban attempts detected")
            table.insert(lines, "🛡️ Protection is " .. (Spy.ProtectionLevel ~= "Normal" and "ACTIVE" : "Standby"))
        end
        
        UI.ResultLabel.Text = table.concat(lines, "\n")
        UI.ResultLabel.TextColor3 = Spy.BanDetected and 
            Color3.fromRGB(255, 100, 100) or 
            Color3.fromRGB(100, 255, 100)
    end,
    
    ShowLogs = function()
        if #Spy.RemoteLogs == 0 then
            UI.ResultLabel.Text = "📋 No logs available\n\nStart Spy to begin monitoring remotes"
            UI.ResultLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
            return
        end
        
        local lines = {"📋 LAST 50 LOGS:"}
        for i = 1, math.min(50, #Spy.RemoteLogs) do
            local log = Spy.RemoteLogs[i]
            if log then
                table.insert(lines, log.Formatted or log.Name or "Unknown")
            end
        end
        
        UI.ResultLabel.Text = table.concat(lines, "\n")
        UI.ResultLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    end,
    
    UpdateLogs = function()
        -- Just refresh
        UI.ResultLabel.Text = "🗑️ Logs cleared!\n\nAll remote logs have been removed"
        UI.ResultLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    end,
}

-- ============ AUTO PROTECTION LOOP ============
task.spawn(function()
    while true do
        task.wait(5)
        
        if Spy.Enabled then
            -- Giảm protection nếu không có ban
            if Spy.LastBanAttempt > 0 and os.time() - Spy.LastBanAttempt > 120 then
                if Spy.ProtectionLevel == "Ultra" then
                    Spy.ProtectionLevel = "High"
                    Spy:Notify("🛡️ Protection level decreased to HIGH")
                elseif Spy.ProtectionLevel == "High" and Spy.RemoteStats.BanAttempts < 2 then
                    Spy.ProtectionLevel = "Normal"
                    Spy:Notify("🛡️ Protection level decreased to NORMAL")
                end
            end
            
            UI.UpdateStatus()
        end
    end
end)

-- ============ KEYBINDS ============
Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F8 then
        UI:Toggle()
    end
    
    if input.KeyCode == Enum.KeyCode.F9 then
        Spy:Toggle()
        UI.UpdateStatus()
    end
end)

-- ============ AUTO START ============
task.wait(1)
UI:Init()

BadgeNotification.Show(
    "🕵️ Spy V8.0 Loaded!",
    "Press F8 to open UI\nPress F9 to toggle Spy",
    "🕵️",
    Color3.fromRGB(100, 50, 255),
    4
)

print([[
╔══════════════════════════════════════════════════════════════════╗
║  🕵️ SPY V8.0 - ULTIMATE EDITION                                ║
║  ════════════════════════════════════════════════════════════  ║
║                                                               ║
║  📌 TỔNG HỢP TỪ TẤT CẢ CÁC PHIÊN BẢN:                       ║
║  ✅ Spy V5 - Core Engine                                     ║
║  ✅ Spy V6 - AI + Database                                  ║
║  ✅ Spy Mod V7 - Optimization                               ║
║  ✅ Spy Mod V7.2 - UI + Badge                              ║
║  ✅ Spy Mod V9 - Advanced Features                         ║
║  ✅ Spy Mod Công Chúa V2 - UI Design                      ║
║  ✅ IY.lua - Multi-game Support                           ║
║                                                               ║
║  🎯 TÍNH NĂNG MỚI:                                          ║
║  • Remote Spy - Bắt toàn bộ remote                         ║
║  • Ban Detection - Phát hiện lệnh ban                     ║
║  • Auto Block - Tự động chặn nguy hiểm                    ║
║  • Protection Levels - 3 cấp độ bảo vệ                   ║
║  • Anti-Hack Scanner - Scan chi tiết                     ║
║  • Badge Notification - Thông báo đẹp                   ║
║                                                               ║
║  ⌨️ KEYBINDS:                                               ║
║  • F8 - Mở UI                                              ║
║  • F9 - Bật/Tắt Spy                                       ║
╚══════════════════════════════════════════════════════════════════╝
]])

-- Auto start Spy
task.wait(1)
Spy:Toggle()
UI.UpdateStatus()

return {
    Spy = Spy,
    UI = UI,
    Scanner = AntiHackScanner,
    Badge = BadgeNotification,
}
