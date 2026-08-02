--[[
    AdvancedSpy Pro MAX - Ultimate Edition v5.0.0
    NÂNG CẤP TOÀN DIỆN: Anti-detection, Performance, Advanced Filter, Auto-Responder, Analytics, UI Enhancements, Security, Export Options
]]

-- ============ SERVICES ============
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpRbxApiService = game:GetService("HttpRbxApiService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ============ MAIN TABLE ============
local AdvancedSpy = {
    Version = "5.0.0",
    Enabled = false,
    Connections = {},
    RemoteLog = {},
    BlockedRemotes = {},
    ExcludedRemotes = {},
    WhitelistedRemotes = {},
    RemoteStats = {
        TotalCalls = 0,
        CallsPerRemote = {},
        LastSecond = 0,
        PeakRate = 0,
        Rates = {},
        Latency = {},
        ErrorRate = 0,
    },
    CustomHooks = {
        BeforeFire = {},
        AfterFire = {},
        BeforeInvoke = {},
        AfterInvoke = {},
        OnBlock = {},
        OnLog = {},
    },
    Settings = {
        Theme = "neon",
        MaxLogs = 500,
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
        Transparency = 0.85,
        ScanInterval = 5,
        -- 🆕 Advanced Settings
        UseDifferentialUpdates = true,
        EnableCache = true,
        CacheTTL = 60,
        RandomizeTiming = true,
        TimingJitter = 0.3,
        EnableHeatmap = true,
        IntegrityCheck = true,
        EncryptionEnabled = true,
        AutoResponderEnabled = false,
        RemoteResponderURL = "",
        ExportFormat = "json",
        ExportFilter = {},
        PatternMatchingEnabled = true,
        PatternRules = {},
        RateLimit = 1000,
        BurstThreshold = 100,
        AnomalyDetection = true,
        MachineLearning = false,
    },
    StartTime = os.time(),
    Cache = {
        Remotes = {},
        LastUpdate = 0,
        Updating = false,
        Checksum = "",
        Version = 1,
    },
    Backup = {
        MetaTable = nil,
        Index = nil,
        NewIndex = nil,
    },
    -- 🆕 Security & Anti-Detection
    Security = {
        EncryptionKey = "advancedspy_secure_key_" .. os.time(),
        IntegrityChecksum = "",
        SessionID = "",
        AntiTamper = false,
    },
    -- 🆕 Pattern Matching
    Patterns = {},
    -- 🆕 Auto-Responder Queue
    ResponderQueue = {},
    -- 🆕 Analytics Engine
    Analytics = {
        PatternDetected = {},
        Anomalies = {},
        Predictions = {},
        Performance = {},
    },
}

-- ============ ENCRYPTION UTILITY ============
local Encryption = {
    Key = AdvancedSpy.Security.EncryptionKey,
    
    Encrypt = function(data)
        if not AdvancedSpy.Settings.EncryptionEnabled then return data end
        local json = HttpService:JSONEncode(data)
        local encrypted = ""
        for i = 1, #json do
            local char = json:sub(i, i)
            local keyChar = AdvancedSpy.Security.EncryptionKey:sub((i - 1) % #AdvancedSpy.Security.EncryptionKey + 1, (i - 1) % #AdvancedSpy.Security.EncryptionKey + 1)
            encrypted = encrypted .. string.char(string.byte(char) ~ string.byte(keyChar))
        end
        return HttpService:Base64Encode(encrypted)
    end,
    
    Decrypt = function(encrypted)
        if not AdvancedSpy.Settings.EncryptionEnabled then return encrypted end
        local decoded = HttpService:Base64Decode(encrypted)
        local decrypted = ""
        for i = 1, #decoded do
            local char = decoded:sub(i, i)
            local keyChar = AdvancedSpy.Security.EncryptionKey:sub((i - 1) % #AdvancedSpy.Security.EncryptionKey + 1, (i - 1) % #AdvancedSpy.Security.EncryptionKey + 1)
            decrypted = decrypted .. string.char(string.byte(char) ~ string.byte(keyChar))
        end
        return HttpService:JSONDecode(decrypted)
    end,
    
    GenerateChecksum = function(data)
        local str = tostring(data)
        local hash = 0
        for i = 1, #str do
            hash = (hash * 31 + string.byte(str, i)) % 2^32
        end
        return string.format("%08x", hash)
    end,
}

-- ============ ANTI-DETECTION & RANDOMIZATION ============
local AntiDetection = {
    LastAction = 0,
    JitterOffset = 0,
    RandomizedPatterns = {},
    
    RandomizeTiming = function()
        if not AdvancedSpy.Settings.RandomizeTiming then return 0 end
        local jitter = AdvancedSpy.Settings.TimingJitter or 0.3
        return (math.random() * 2 - 1) * jitter
    end,
    
    RandomDelay = function(baseDelay)
        local jitter = AntiDetection.RandomizeTiming()
        return math.max(0, baseDelay + jitter)
    end,
    
    ScramblePattern = function(pattern)
        local scrambled = {}
        for i = 1, #pattern do
            local idx = math.random(1, #pattern)
            table.insert(scrambled, pattern[idx])
            table.remove(pattern, idx)
        end
        return scrambled
    end,
    
    GenerateFakeTraffic = function()
        -- Generate fake remote calls to hide real patterns
        local remotes = RemoteCache:GetAll()
        if #remotes > 0 then
            local fakeRemote = remotes[math.random(1, #remotes)]
            if fakeRemote and not AdvancedSpy:IsBlocked(fakeRemote) then
                pcall(function()
                    fakeRemote:FireServer("__fake_traffic_" .. math.random(1000, 9999))
                end)
            end
        end
    end,
    
    CleanTraces = function()
        -- Clean up any potential detection traces
        for _, connection in pairs(AdvancedSpy.Connections) do
            if type(connection) == "table" and connection.Disconnect then
                pcall(connection.Disconnect, connection)
            end
        end
    end,
}

-- ============ ADVANCED PATTERN MATCHING ============
local PatternMatcher = {
    Rules = AdvancedSpy.Settings.PatternRules,
    
    AddRule = function(name, pattern, action)
        local rule = {
            name = name,
            pattern = pattern,
            action = action or "log",
            compiled = nil,
            lastMatch = 0,
            matchCount = 0,
        }
        if type(pattern) == "string" then
            rule.compiled = PatternMatcher.CompilePattern(pattern)
        elseif type(pattern) == "table" then
            rule.compiled = pattern
        end
        table.insert(PatternMatcher.Rules, rule)
        AdvancedSpy.Settings.PatternRules = PatternMatcher.Rules
    end,
    
    CompilePattern = function(pattern)
        -- Convert regex-like pattern to Lua pattern
        local compiled = pattern
        compiled = compiled:gsub("%.", "\\.")
        compiled = compiled:gsub("%*", ".*")
        compiled = compiled:gsub("%?", ".")
        compiled = compiled:gsub("%+", ".+")
        compiled = compiled:gsub("%[", "[")
        compiled = compiled:gsub("%]", "]")
        return compiled
    end,
    
    Match = function(remote, args)
        if not AdvancedSpy.Settings.PatternMatchingEnabled then return nil end
        
        local remoteName = remote.Name
        local argsStr = tostring(args)
        
        for _, rule in ipairs(PatternMatcher.Rules) do
            local matched = false
            if type(rule.pattern) == "string" then
                matched = remoteName:find(rule.compiled) or argsStr:find(rule.compiled)
            elseif type(rule.pattern) == "table" then
                for _, p in ipairs(rule.pattern) do
                    if remoteName:find(p) or argsStr:find(p) then
                        matched = true
                        break
                    end
                end
            end
            
            if matched then
                rule.lastMatch = os.time()
                rule.matchCount = rule.matchCount + 1
                
                if rule.action == "block" then
                    AdvancedSpy:BlockRemote(remote)
                    UI.ShowNotification("⛔ Pattern blocked: " .. remoteName)
                elseif rule.action == "log" then
                    local logEntry = {
                        Remote = remote,
                        Args = args,
                        Pattern = rule.name,
                        Timestamp = os.time(),
                        Type = "PatternMatch",
                    }
                    table.insert(AdvancedSpy.RemoteLog, 1, logEntry)
                    UI.AddLogEntry(logEntry)
                elseif rule.action == "respond" then
                    AdvancedSpy:AddToResponderQueue(remote, args, rule.name)
                end
                
                return rule
            end
        end
        return nil
    end,
}

-- ============ AUTO-RESPONDER ============
local AutoResponder = {
    Queue = AdvancedSpy.ResponderQueue,
    IsProcessing = false,
    RemoteURL = AdvancedSpy.Settings.RemoteResponderURL,
    
    SetRemoteURL = function(url)
        if url and url ~= "" then
            AdvancedSpy.Settings.RemoteResponderURL = url
            AutoResponder.RemoteURL = url
            AdvancedSpy.Settings.AutoResponderEnabled = true
            UI.ShowNotification("🌐 Auto-Responder URL set")
        else
            AdvancedSpy.Settings.AutoResponderEnabled = false
            UI.ShowNotification("🔴 Auto-Responder disabled")
        end
    end,
    
    AddToQueue = function(remote, args, patternName)
        local entry = {
            remote = remote,
            args = args,
            pattern = patternName,
            timestamp = os.time(),
            id = Encryption.GenerateChecksum(tostring(remote) .. tostring(os.time())),
            retryCount = 0,
        }
        table.insert(AutoResponder.Queue, entry)
        if not AutoResponder.IsProcessing then
            AutoResponder:ProcessQueue()
        end
    end,
    
    ProcessQueue = function()
        if not AdvancedSpy.Settings.AutoResponderEnabled or #AutoResponder.Queue == 0 then
            AutoResponder.IsProcessing = false
            return
        end
        
        AutoResponder.IsProcessing = true
        local entry = table.remove(AutoResponder.Queue, 1)
        
        task.spawn(function()
            local success = AutoResponder:SendToRemote(entry)
            if not success and entry.retryCount < 3 then
                entry.retryCount = entry.retryCount + 1
                table.insert(AutoResponder.Queue, 1, entry)
                task.wait(AntiDetection.RandomDelay(1))
            end
            AutoResponder:ProcessQueue()
        end)
    end,
    
    SendToRemote = function(entry)
        if not AutoResponder.RemoteURL or AutoResponder.RemoteURL == "" then
            return false
        end
        
        local data = {
            remote = entry.remote.Name,
            args = Utilities.FormatValue(entry.args),
            pattern = entry.pattern,
            timestamp = os.date("%Y-%m-%d %H:%M:%S"),
            player = Player.Name,
            session = AdvancedSpy.Security.SessionID,
        }
        
        if AdvancedSpy.Settings.EncryptionEnabled then
            data = Encryption.Encrypt(data)
        end
        
        local success, err = pcall(function()
            local response = syn and syn.request({
                Url = AutoResponder.RemoteURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["X-Session-ID"] = AdvancedSpy.Security.SessionID,
                },
                Body = HttpService:JSONEncode(data),
            })
            return response
        end)
        
        if success and response and response.StatusCode == 200 then
            UI.ShowNotification("✅ Auto-responder sent: " .. entry.remote.Name)
            return true
        else
            warn("❌ Auto-responder failed:", err or "Unknown error")
            return false
        end
    end,
}

-- ============ ADVANCED ANALYTICS ============
local AnalyticsEngine = {
    Data = AdvancedSpy.Analytics,
    IsAnalyzing = false,
    
    Analyze = function()
        if AnalyticsEngine.IsAnalyzing then return end
        AnalyticsEngine.IsAnalyzing = true
        
        task.spawn(function()
            -- Pattern Detection
            local patterns = {}
            for remote, count in pairs(AdvancedSpy.RemoteStats.CallsPerRemote) do
                if count > 10 then
                    table.insert(patterns, {
                        remote = remote,
                        count = count,
                        frequency = count / os.difftime(os.time(), AdvancedSpy.StartTime),
                    })
                end
            end
            AnalyticsEngine.Data.PatternDetected = patterns
            
            -- Anomaly Detection
            local anomalies = {}
            local currentRate = 0
            for _, count in pairs(AdvancedSpy.RemoteStats.Rates) do
                currentRate = currentRate + count
            end
            if currentRate > AdvancedSpy.Settings.BurstThreshold then
                table.insert(anomalies, {
                    type = "Burst",
                    rate = currentRate,
                    threshold = AdvancedSpy.Settings.BurstThreshold,
                    timestamp = os.time(),
                })
            end
            
            -- Check for unusual patterns
            for remote, count in pairs(AdvancedSpy.RemoteStats.CallsPerRemote) do
                if count > AdvancedSpy.Settings.RateLimit then
                    table.insert(anomalies, {
                        type = "RateLimit",
                        remote = remote,
                        count = count,
                        limit = AdvancedSpy.Settings.RateLimit,
                    })
                end
            end
            AnalyticsEngine.Data.Anomalies = anomalies
            
            -- Performance Metrics
            AnalyticsEngine.Data.Performance = {
                MemoryUsage = collectgarbage("count") / 1024,
                Uptime = os.difftime(os.time(), AdvancedSpy.StartTime),
                LogCount = #AdvancedSpy.RemoteLog,
                CacheSize = #RemoteCache:GetAll(),
                HookCount = AnalyticsEngine:CountHooks(),
                ResponseTime = AnalyticsEngine:CalculateAverageLatency(),
            }
            
            AnalyticsEngine.IsAnalyzing = false
        end)
    end,
    
    CountHooks = function()
        local count = 0
        for _, hooks in pairs(AdvancedSpy.CustomHooks) do
            for _ in pairs(hooks) do count = count + 1 end
        end
        return count
    end,
    
    CalculateAverageLatency = function()
        local total = 0
        local count = 0
        for _, latency in pairs(AdvancedSpy.RemoteStats.Latency) do
            total = total + latency
            count = count + 1
        end
        return count > 0 and total / count or 0
    end,
    
    GenerateHeatmap = function()
        if not AdvancedSpy.Settings.EnableHeatmap then return {} end
        
        local heatmap = {}
        for remote, count in pairs(AdvancedSpy.RemoteStats.CallsPerRemote) do
            local remoteObj = RemoteCache:GetByName(remote)
            if remoteObj then
                local path = remoteObj:GetFullName()
                heatmap[path] = {
                    count = count,
                    percentage = count / AdvancedSpy.RemoteStats.TotalCalls * 100,
                    intensity = math.min(1, count / 100),
                }
            end
        end
        return heatmap
    end,
}

-- ============ UTILITIES (NÂNG CẤP) ============
local Utilities = {
    Colors = {
        Success = Color3.fromRGB(0, 255, 100),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 200, 50),
        Info = Color3.fromRGB(50, 200, 255),
        Remote = Color3.fromRGB(150, 100, 255),
        Args = Color3.fromRGB(100, 255, 150),
        Value = Color3.fromRGB(255, 150, 100),
        HeatLow = Color3.fromRGB(50, 50, 200),
        HeatMid = Color3.fromRGB(200, 200, 50),
        HeatHigh = Color3.fromRGB(200, 50, 50),
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
    end,
    
    -- 🆕 Export với filter
    ApplyFilter = function(data, filter)
        if not filter or #filter == 0 then return data end
        
        local filtered = {}
        for _, entry in ipairs(data) do
            local match = true
            for _, f in ipairs(filter) do
                if f.type == "remote" and entry.remote ~= f.value then
                    match = false
                    break
                elseif f.type == "type" and entry.type ~= f.value then
                    match = false
                    break
                elseif f.type == "pattern" and not entry.args:find(f.value) then
                    match = false
                    break
                end
            end
            if match then
                table.insert(filtered, entry)
            end
        end
        return filtered
    end,
}

-- ============ ENHANCED HOOK SYSTEM ============
local HookManager = {
    OriginalIndex = nil,
    OriginalNewIndex = nil,
    IsHooked = false,
    Protected = false,
}

function HookManager:Init()
    if self.IsHooked then return true end

    local success, meta = pcall(getrawmetatable, game)
    if not success or not meta then
        warn("❌ Cannot get metatable!")
        return false
    end

    self.OriginalIndex = meta.__index
    self.OriginalNewIndex = meta.__newindex

    local isReadonly = false
    local success, result = pcall(function()
        isReadonly = isreadonly(meta)
    end)

    if success and isReadonly then
        pcall(setreadonly, meta, false)
        self.Protected = true
    end

    local hookSuccess, err = pcall(function()
        meta.__index = newcclosure(function(self, key)
            if rawget(self, "__SPY_BYPASS") then
                return self.OriginalIndex(self, key)
            end

            local original = HookManager.OriginalIndex(self, key)

            if key == "FireServer" and type(original) == "function" then
                return newcclosure(function(...)
                    local args = {...}
                    local remote = self
                    
                    -- Anti-detection: Random delay
                    if AdvancedSpy.Settings.RandomizeTiming then
                        task.wait(AntiDetection.RandomizeTiming())
                    end

                    -- Before hook
                    local shouldExecute = true
                    for name, hook in pairs(AdvancedSpy.CustomHooks.BeforeFire) do
                        local success, result = pcall(hook, remote, args)
                        if success and result == false then
                            shouldExecute = false
                        end
                    end

                    if not shouldExecute then return end

                    -- Pattern matching
                    local patternMatch = PatternMatcher.Match(remote, args)
                    if patternMatch and patternMatch.action == "block" then
                        return
                    end

                    local results = {}
                    local startTime = tick()
                    local execSuccess, execErr = pcall(function()
                        local bypass = setmetatable({}, {
                            __index = function(t, k)
                                if k == "__SPY_BYPASS" then return true end
                                return HookManager.OriginalIndex(remote, k)
                            end
                        })

                        local result = HookManager.OriginalIndex(bypass, "FireServer")(unpack(args))
                        table.insert(results, result)
                    end)
                    
                    local endTime = tick()
                    table.insert(AdvancedSpy.RemoteStats.Latency, endTime - startTime)

                    if not execSuccess then
                        warn("⚠️ FireServer error:", execErr)
                        return
                    end

                    for name, hook in pairs(AdvancedSpy.CustomHooks.AfterFire) do
                        pcall(hook, remote, args, results[1])
                    end

                    AdvancedSpy:ProcessRemoteCall(remote, args, results[1], "FireServer", endTime - startTime)

                    return results[1]
                end)
            end

            if key == "InvokeServer" and type(original) == "function" then
                return newcclosure(function(...)
                    local args = {...}
                    local remote = self
                    
                    if AdvancedSpy.Settings.RandomizeTiming then
                        task.wait(AntiDetection.RandomizeTiming())
                    end

                    local shouldExecute = true
                    for name, hook in pairs(AdvancedSpy.CustomHooks.BeforeInvoke) do
                        local success, result = pcall(hook, remote, args)
                        if success and result == false then
                            shouldExecute = false
                        end
                    end

                    if not shouldExecute then return end

                    local patternMatch = PatternMatcher.Match(remote, args)
                    if patternMatch and patternMatch.action == "block" then
                        return
                    end

                    local results = {}
                    local startTime = tick()
                    local execSuccess, execErr = pcall(function()
                        local bypass = setmetatable({}, {
                            __index = function(t, k)
                                if k == "__SPY_BYPASS" then return true end
                                return HookManager.OriginalIndex(remote, k)
                            end
                        })

                        local result = HookManager.OriginalIndex(bypass, "InvokeServer")(unpack(args))
                        table.insert(results, result)
                    end)
                    local endTime = tick()
                    table.insert(AdvancedSpy.RemoteStats.Latency, endTime - startTime)

                    if not execSuccess then
                        warn("⚠️ InvokeServer error:", execErr)
                        return
                    end

                    for name, hook in pairs(AdvancedSpy.CustomHooks.AfterInvoke) do
                        pcall(hook, remote, args, results[1])
                    end

                    AdvancedSpy:ProcessRemoteCall(remote, args, results[1], "InvokeServer", endTime - startTime)

                    return results[1]
                end)
            end

            return original
        end)
    end)

    if not hookSuccess then
        warn("❌ Hook failed:", err)
        if self.Protected then
            pcall(setreadonly, meta, true)
        end
        return false
    end

    self.IsHooked = true
    AdvancedSpy.Backup.MetaTable = meta
    AdvancedSpy.Backup.Index = self.OriginalIndex
    AdvancedSpy.Backup.NewIndex = self.OriginalNewIndex

    print("✅ Hook system initialized successfully!")
    return true
end

function HookManager:Restore()
    if not self.IsHooked then return end

    local success, meta = pcall(getrawmetatable, game)
    if success and meta then
        if self.Protected then
            pcall(setreadonly, meta, false)
        end
        meta.__index = self.OriginalIndex
        meta.__newindex = self.OriginalNewIndex
        if self.Protected then
            pcall(setreadonly, meta, true)
        end
    end

    self.IsHooked = false
    print("✅ Hook system restored")
end

-- ============ SMART REMOTE CACHE (NÂNG CẤP) ============
local RemoteCache = {
    Remotes = {},
    ByName = {},
    ByType = {},
    LastUpdate = 0,
    IsUpdating = false,
    Version = 1,
    Differential = {
        Added = {},
        Removed = {},
        Modified = {},
    },
}

function RemoteCache:Update(force)
    if self.IsUpdating then return end
    if not force and (tick() - self.LastUpdate) < AdvancedSpy.Settings.ScanInterval then return end

    self.IsUpdating = true

    task.spawn(function()
        local oldRemotes = self.Remotes
        local newRemotes = {}
        local newByName = {}
        local newByType = {RemoteEvent = {}, RemoteFunction = {}, BindableEvent = {}, BindableFunction = {}}

        -- Differential update
        local allDescendants = game:GetDescendants()
        for _, obj in ipairs(allDescendants) do
            if obj:IsA("RemoteEvent") then
                table.insert(newByType.RemoteEvent, obj)
            elseif obj:IsA("RemoteFunction") then
                table.insert(newByType.RemoteFunction, obj)
            elseif obj:IsA("BindableEvent") then
                table.insert(newByType.BindableEvent, obj)
            elseif obj:IsA("BindableFunction") then
                table.insert(newByType.BindableFunction, obj)
            else
                goto continue
            end

            table.insert(newRemotes, obj)
            newByName[obj.Name] = obj

            ::continue::
        end

        -- Differential analysis
        if AdvancedSpy.Settings.UseDifferentialUpdates then
            self.Differential.Added = {}
            self.Differential.Removed = {}
            
            for _, remote in ipairs(newRemotes) do
                if not table.find(oldRemotes, remote) then
                    table.insert(self.Differential.Added, remote)
                end
            end
            
            for _, remote in ipairs(oldRemotes) do
                if not table.find(newRemotes, remote) then
                    table.insert(self.Differential.Removed, remote)
                end
            end
        end

        self.Remotes = newRemotes
        self.ByName = newByName
        self.ByType = newByType
        self.LastUpdate = tick()
        self.Version = self.Version + 1
        self.IsUpdating = false

        -- Integrity check
        if AdvancedSpy.Settings.IntegrityCheck then
            AdvancedSpy.Security.IntegrityChecksum = Encryption.GenerateChecksum(self.Remotes)
        end

        if UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Remotes then
            UI.UpdateRemotes()
        end
    end)
end

function RemoteCache:GetAll()
    return self.Remotes
end

function RemoteCache:GetByName(name)
    return self.ByName[name]
end

function RemoteCache:GetByType(typeName)
    return self.ByType[typeName] or {}
end

function RemoteCache:GetDifferential()
    return self.Differential
end

-- ============ ENHANCED LOGGING (NÂNG CẤP) ============
function AdvancedSpy:ProcessRemoteCall(remote, args, returnValue, callType, latency)
    if self:IsBlocked(remote) then return end
    if self:IsExcluded(remote) then return end

    self.RemoteStats.TotalCalls = (self.RemoteStats.TotalCalls or 0) + 1
    local remoteName = remote.Name
    self.RemoteStats.CallsPerRemote[remoteName] = (self.RemoteStats.CallsPerRemote[remoteName] or 0) + 1

    -- Rate limiting
    local currentTime = os.time()
    if currentTime ~= self.RemoteStats.LastSecond then
        self.RemoteStats.LastSecond = currentTime
        self.RemoteStats.Rates[currentTime] = 0
        for time in pairs(self.RemoteStats.Rates) do
            if currentTime - time > 60 then
                self.RemoteStats.Rates[time] = nil
            end
        end
    end
    self.RemoteStats.Rates[currentTime] = (self.RemoteStats.Rates[currentTime] or 0) + 1

    -- Anomaly detection
    if AdvancedSpy.Settings.AnomalyDetection then
        local currentRate = 0
        for _, count in pairs(self.RemoteStats.Rates) do
            currentRate = currentRate + count
        end
        if currentRate > self.RemoteStats.PeakRate then
            self.RemoteStats.PeakRate = currentRate
            if currentRate > AdvancedSpy.Settings.BurstThreshold then
                UI.ShowNotification("⚠️ Anomaly detected: Burst rate " .. currentRate .. " calls/sec")
                AnalyticsEngine:Analyze()
            end
        end
    end

    local logEntry = {
        Remote = remote,
        Args = args,
        ReturnValue = returnValue,
        Timestamp = currentTime,
        Type = callType,
        ID = #self.RemoteLog + 1,
        Latency = latency or 0,
        Pattern = PatternMatcher.Match(remote, args),
    }

    table.insert(self.RemoteLog, 1, logEntry)
    self:TrimLogs()

    UI.AddLogEntry(logEntry)
    UI.UpdateStats()

    for name, hook in pairs(self.CustomHooks[callType == "FireServer" and "AfterFire" or "AfterInvoke"] or {}) do
        pcall(hook, remote, args, returnValue)
    end
    
    -- Auto-responder
    if self.Settings.AutoResponderEnabled and logEntry.Pattern then
        AutoResponder:AddToQueue(remote, args, logEntry.Pattern.name)
    end
end

function AdvancedSpy:TrimLogs()
    while #self.RemoteLog > self.Settings.MaxLogs do
        table.remove(self.RemoteLog)
    end
end

function AdvancedSpy:GetAllRemotes()
    return RemoteCache:GetAll()
end

function AdvancedSpy:BlockRemote(remote)
    if not remote then return end
    self.BlockedRemotes[remote] = true
    print("⛔ Blocked remote: " .. remote.Name)
    
    for name, hook in pairs(self.CustomHooks.OnBlock) do
        pcall(hook, remote)
    end
end

function AdvancedSpy:UnblockRemote(remote)
    if not remote then return end
    self.BlockedRemotes[remote] = nil
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

function AdvancedSpy:AddHook(type, name, callback)
    if type ~= "BeforeFire" and type ~= "AfterFire" and type ~= "BeforeInvoke" and type ~= "AfterInvoke" 
       and type ~= "OnBlock" and type ~= "OnLog" then
        warn("Invalid hook type")
        return
    end
    if type(name) ~= "string" or type(callback) ~= "function" then
        warn("Invalid hook parameters")
        return
    end
    self.CustomHooks[type][name] = callback
    print("🔌 Added hook: " .. name .. " (" .. type .. ")")
    UI.ShowNotification("✅ Hook added: " .. name)
end

function AdvancedSpy:RemoveHook(type, name)
    if self.CustomHooks[type] and self.CustomHooks[type][name] then
        self.CustomHooks[type][name] = nil
        print("🔌 Removed hook: " .. name)
        UI.ShowNotification("❌ Hook removed: " .. name)
        return true
    end
    return false
end

function AdvancedSpy:ClearLogs()
    self.RemoteLog = {}
    UI.ClearLogs()
    UI.ShowNotification("🗑️ Logs cleared!")
end

-- ============ EXPORT WITH FILTERS (NÂNG CẤP) ============
function AdvancedSpy:ExportLogs(format, filter)
    format = format or self.Settings.ExportFormat or "json"
    filter = filter or self.Settings.ExportFilter or {}
    
    if #self.RemoteLog == 0 then
        UI.ShowNotification("⚠️ No logs to export!")
        return
    end

    local data = {
        metadata = {
            version = self.Version,
            timestamp = os.time(),
            date = os.date("%Y-%m-%d %H:%M:%S"),
            totalLogs = #self.RemoteLog,
            totalCalls = self.RemoteStats.TotalCalls,
            peakRate = self.RemoteStats.PeakRate,
            encryption = self.Settings.EncryptionEnabled and "enabled" or "disabled",
            session = self.Security.SessionID,
        },
        logs = {}
    }

    local rawLogs = {}
    for i, entry in ipairs(self.RemoteLog) do
        table.insert(rawLogs, {
            id = i,
            time = os.date("%H:%M:%S", entry.Timestamp),
            remote = entry.Remote.Name,
            remotePath = entry.Remote:GetFullName(),
            type = entry.Type,
            args = Utilities.FormatValue(entry.Args),
            returnValue = entry.ReturnValue and Utilities.FormatValue(entry.ReturnValue) or nil,
            latency = entry.Latency or 0,
            pattern = entry.Pattern and entry.Pattern.name or nil,
        })
    end
    
    -- Apply filter
    local filteredLogs = Utilities.ApplyFilter(rawLogs, filter)
    data.logs = filteredLogs
    data.metadata.totalLogs = #filteredLogs

    local output = ""
    if format == "json" then
        if self.Settings.EncryptionEnabled then
            output = Encryption.Encrypt(data)
        else
            output = HttpService:JSONEncode(data)
        end
    elseif format == "csv" then
        output = "ID,Time,Remote,Type,Args,Return,Latency,Pattern\n"
        for _, log in ipairs(data.logs) do
            output = output .. string.format("%d,%s,%s,%s,%s,%s,%.3f,%s\n",
                log.id, log.time, log.remote, log.type,
                log.args:gsub(",", ";"),
                log.returnValue and log.returnValue:gsub(",", ";") or "",
                log.latency or 0,
                log.pattern or ""
            )
        end
    elseif format == "html" then
        output = [[<html><head><title>AdvancedSpy Pro Export</title>
        <style>body{background:#0a0014;color:#ccc;font-family:monospace;}
        table{border-collapse:collapse;width:100%;}
        th,td{border:1px solid #333;padding:8px;text-align:left;}
        th{background:#1a0030;color:#0ff;}</style></head><body>]]
        output = output .. [[<h1>AdvancedSpy Pro Export</h1>
        <p>]] .. data.metadata.date .. [[ | Total: ]] .. data.metadata.totalLogs .. [[</p>
        <table><tr><th>ID</th><th>Time</th><th>Remote</th><th>Type</th><th>Args</th><th>Return</th><th>Latency</th><th>Pattern</th></tr>]]
        for _, log in ipairs(data.logs) do
            output = output .. string.format("<tr><td>%d</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%.3f</td><td>%s</td></tr>",
                log.id, log.time, log.remote, log.type, log.args or "", log.returnValue or "", log.latency or 0, log.pattern or "")
        end
        output = output .. "</table></body></html>"
    else
        -- Plain text
        output = string.format("=== AdvancedSpy Pro Export ===\n")
        output = output .. string.format("Time: %s\n", data.metadata.date)
        output = output .. string.format("Total Logs: %d\n", data.metadata.totalLogs)
        output = output .. string.format("Total Calls: %d\n\n", data.metadata.totalCalls)

        for _, log in ipairs(data.logs) do
            output = output .. string.format("[%s] %s | %s | %.3fms\n", log.time, log.remote, log.type, log.latency or 0)
            output = output .. string.format("  Args: %s\n", log.args)
            if log.returnValue then
                output = output .. string.format("  Return: %s\n", log.returnValue)
            end
            if log.pattern then
                output = output .. string.format("  Pattern: %s\n", log.pattern)
            end
            output = output .. "\n"
        end
    end

    local success, err = pcall(setclipboard, output)
    if success then
        UI.ShowNotification(string.format("📋 Logs exported (%d entries) to clipboard!", #data.logs))
    else
        print(output)
        UI.ShowNotification("⚠️ Cannot copy to clipboard, logs printed to console")
    end

    return output
end

function AdvancedSpy:CopyLogs()
    self:ExportLogs("text")
end

function AdvancedSpy:AddPatternRule(name, pattern, action)
    PatternMatcher.AddRule(name, pattern, action)
    UI.ShowNotification("✅ Pattern rule added: " .. name)
end

function AdvancedSpy:SetResponderURL(url)
    AutoResponder:SetRemoteURL(url)
end

function AdvancedSpy:ResetAll()
    self:ClearLogs()
    self.BlockedRemotes = {}
    self.CustomHooks = {
        BeforeFire = {},
        AfterFire = {},
        BeforeInvoke = {},
        AfterInvoke = {},
        OnBlock = {},
        OnLog = {},
    }
    self.RemoteStats = {
        TotalCalls = 0,
        CallsPerRemote = {},
        LastSecond = 0,
        PeakRate = 0,
        Rates = {},
        Latency = {},
        ErrorRate = 0,
    }
    self.Patterns = {}
    self.ResponderQueue = {}
    self.Analytics = {
        PatternDetected = {},
        Anomalies = {},
        Predictions = {},
        Performance = {},
    }
    UI.UpdateRemotes()
    UI.UpdateStats()
    UI.UpdateHooks()
    UI.ShowNotification("🔄 Reset all data!")
end

function AdvancedSpy:Destroy()
    print("🔮 Destroying AdvancedSpy Pro...")
    self.Enabled = false
    HookManager:Restore()
    AntiDetection.CleanTraces()

    if UI.GUI and UI.GUI.ScreenGui then
        UI.GUI.ScreenGui:Destroy()
    end

    if self.Connections.Blur then
        self.Connections.Blur:Destroy()
    end

    self.RemoteLog = {}
    self.BlockedRemotes = {}
    self.ExcludedRemotes = {}
    self.CustomHooks = {
        BeforeFire = {},
        AfterFire = {},
        BeforeInvoke = {},
        AfterInvoke = {},
        OnBlock = {},
        OnLog = {},
    }

    print("✅ AdvancedSpy Pro destroyed")
end

-- ============ ANIMATION MANAGER ============
local Animations = {
    FadeIn = function(object, duration, properties)
        duration = duration or 0.3
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(object, tweenInfo, properties or {BackgroundTransparency = 0})
        tween:Play()
        return tween
    end,

    SlideIn = function(object, fromPosition, toPosition, duration)
        duration = duration or 0.4
        object.Position = fromPosition
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(object, tweenInfo, {Position = toPosition})
        tween:Play()
        return tween
    end,

    Pulse = function(object, scale, duration)
        duration = duration or 0.5
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        local tween = TweenService:Create(object, tweenInfo, {Size = UDim2.fromScale(scale, scale)})
        tween:Play()
        return tween
    end,

    ColorTransition = function(object, color, duration)
        duration = duration or 0.3
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(object, tweenInfo, {BackgroundColor3 = color})
        tween:Play()
        return tween
    end,

    Glow = function(object, color, duration)
        duration = duration or 1
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        local tween = TweenService:Create(object, tweenInfo, {
            BackgroundColor3 = color,
            BackgroundTransparency = 0.3
        })
        tween:Play()
        return tween
    end,
    
    HeatMap = function(object, intensity)
        local color = Color3.fromRGB(
            50 + intensity * 150,
            200 - intensity * 150,
            50 + intensity * 50
        )
        local tween = TweenService:Create(object, TweenInfo.new(0.2), {BackgroundColor3 = color})
        tween:Play()
        return tween
    end,
}

-- ============ UI MANAGER (NÂNG CẤP) ============
local UI = {
    GUI = nil,
    CurrentTab = "Logs",
    Notifications = {},
    SearchText = "",
    CurrentFilter = "All",
    HeatmapEnabled = false,
    ColorScheme = "neon",

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
        mainFrame.Size = UDim2.new(0, 600, 0, 750)
        mainFrame.Position = UDim2.new(0.5, -300, 0.5, -375)
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
        mainFrame.Position = UDim2.new(0.5, -300, 0.5, -500)
        Animations.SlideIn(mainFrame, UDim2.new(0.5, -300, 0.5, -500), UDim2.new(0.5, -300, 0.5, -375), 0.5)

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
                    local newSize = mainFrame.Size.Y.Scale == 0 and UDim2.new(0, 600, 0, 750) or UDim2.new(0, 600, 0, 40)
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
                    TweenService:Create(mainFrame, tweenInfo, {Size = newSize}):Play()
                else
                    local newSize = mainFrame.Size.X.Scale == 0 and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 600, 0, 750)
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

        local tabNames = {"📋 Logs", "📡 Remotes", "📊 Stats", "⚙️ Settings", "🔧 Hooks", "🎮 Control", "🧠 Analytics"}
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

        -- SEARCH BAR
        local searchBar = Instance.new("Frame")
        searchBar.Size = UDim2.new(1, -10, 0, 32)
        searchBar.Position = UDim2.new(0, 5, 0, 88)
        searchBar.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
        searchBar.BackgroundTransparency = 0.5
        searchBar.BorderSizePixel = 0
        searchBar.Parent = mainFrame

        local searchCorner = Instance.new("UICorner")
        searchCorner.CornerRadius = UDim.new(0, 8)
        searchCorner.Parent = searchBar

        local searchInput = Instance.new("TextBox")
        searchInput.Size = UDim2.new(1, -10, 1, 0)
        searchInput.Position = UDim2.new(0, 5, 0, 0)
        searchInput.BackgroundTransparency = 1
        searchInput.Text = "🔍 Search remotes, logs, patterns..."
        searchInput.TextColor3 = Color3.fromRGB(150, 150, 180)
        searchInput.TextSize = 13
        searchInput.Font = Enum.Font.Gotham
        searchInput.Parent = searchBar

        searchInput:GetPropertyChangedSignal("Text"):Connect(function()
            UI.SearchText = searchInput.Text
            if searchInput.Text == "" or searchInput.Text == "🔍 Search remotes, logs, patterns..." then
                UI.SearchText = ""
            end
            UI.UpdateLogs()
            UI.UpdateRemotes()
        end)

        -- FILTER BUTTONS
        local filterFrame = Instance.new("Frame")
        filterFrame.Size = UDim2.new(1, -10, 0, 28)
        filterFrame.Position = UDim2.new(0, 5, 0, 122)
        filterFrame.BackgroundTransparency = 1
        filterFrame.Parent = mainFrame

        local filters = {"All", "FireServer", "InvokeServer", "RemoteEvent", "RemoteFunction"}
        for i, name in ipairs(filters) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1/#filters, -2, 1, -2)
            btn.Position = UDim2.new((i-1) * (1/#filters), 1, 0, 1)
            btn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(30, 0, 60)
            btn.BorderSizePixel = 0
            btn.Text = name
            btn.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 180)
            btn.TextSize = 11
            btn.Font = Enum.Font.GothamMedium
            btn.Parent = filterFrame

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                for _, b in ipairs(filterFrame:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
                        b.TextColor3 = Color3.fromRGB(150, 150, 180)
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)

                UI.CurrentFilter = name
                UI.UpdateLogs()
                UI.UpdateRemotes()
            end)
        end

        -- Tab Container
        local tabContainer = Instance.new("Frame")
        tabContainer.Size = UDim2.new(1, 0, 1, -155)
        tabContainer.Position = UDim2.new(0, 0, 0, 153)
        tabContainer.BackgroundTransparency = 1
        tabContainer.Parent = mainFrame

        -- Create Tabs
        local tabs = {
            Logs = UI.CreateLogTab(),
            Remotes = UI.CreateRemoteTab(),
            Stats = UI.CreateStatsTab(),
            Settings = UI.CreateSettingsTab(),
            Hooks = UI.CreateHooksTab(),
            Control = UI.CreateControlTab(),
            Analytics = UI.CreateAnalyticsTab(),
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

                for name, content in pairs(tabs) do
                    if content.Visible then
                        local fadeOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        TweenService:Create(content, fadeOut, {BackgroundTransparency = 1}):Play()
                        task.wait(0.1)
                        content.Visible = false
                    end
                end

                local content = tabs[tabName]
                if content then
                    content.Visible = true
                    content.BackgroundTransparency = 1
                    local fadeIn = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    TweenService:Create(content, fadeIn, {BackgroundTransparency = 0}):Play()
                end

                for _, b in ipairs(tabButtons) do
                    b.Active = (b == btn)
                    local targetColor = (b == btn) and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(20, 0, 40)
                    Animations.ColorTransition(b, targetColor, 0.2)
                    b.TextColor3 = (b == btn) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
                end

                UI.CurrentTab = tabName
                
                -- Update analytics tab when switched
                if tabName == "Analytics" then
                    AnalyticsEngine:Analyze()
                    UI.UpdateAnalytics()
                end
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
            TabButtons = tabButtons,
            SearchInput = searchInput,
            FilterFrame = filterFrame,
        }

        return UI.GUI
    end,

    -- ===== TABS =====
    CreateLogTab = function()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1

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

        local controls = {
            {Text = "🔍 Scan Remotes", Action = function() RemoteCache:Update(true) end},
            {Text = "🗑️ Clear Logs", Action = function() AdvancedSpy:ClearLogs() end},
            {Text = "📊 Export Logs", Action = function() AdvancedSpy:ExportLogs("text") end},
            {Text = "📦 Export JSON", Action = function() AdvancedSpy:ExportLogs("json") end},
            {Text = "📋 Export HTML", Action = function() AdvancedSpy:ExportLogs("html") end},
            {Text = "📋 Copy Logs", Action = function() AdvancedSpy:CopyLogs() end},
            {Text = "🔄 Reset All", Action = function() AdvancedSpy:ResetAll() end},
            {Text = "🌐 Set Responder URL", Action = function()
                local url = UI.ShowInputDialog("Enter Auto-Responder URL:", "https://your-server.com/api/respond")
                if url and url ~= "" then
                    AdvancedSpy:SetResponderURL(url)
                end
            end},
            {Text = "📝 Add Pattern Rule", Action = function()
                local name = UI.ShowInputDialog("Rule Name:", "block_kick")
                local pattern = UI.ShowInputDialog("Pattern (regex-like):", "kick|ban|admin")
                local action = UI.ShowInputDialog("Action (log/block/respond):", "block")
                if name and pattern and action then
                    AdvancedSpy:AddPatternRule(name, pattern, action)
                end
            end},
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

    -- 🆕 ANALYTICS TAB
    CreateAnalyticsTab = function()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1

        local analyticsFrame = Instance.new("ScrollingFrame")
        analyticsFrame.Size = UDim2.new(1, -10, 1, -10)
        analyticsFrame.Position = UDim2.new(0, 5, 0, 5)
        analyticsFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
        analyticsFrame.BackgroundTransparency = 0.5
        analyticsFrame.ScrollBarThickness = 4
        analyticsFrame.Parent = frame

        local analyticsFrameCorner = Instance.new("UICorner")
        analyticsFrameCorner.CornerRadius = UDim.new(0, 8)
        analyticsFrameCorner.Parent = analyticsFrame

        local analyticsLayout = Instance.new("UIListLayout")
        analyticsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        analyticsLayout.Padding = UDim.new(0, 5)
        analyticsLayout.Parent = analyticsFrame

        frame.AnalyticsFrame = analyticsFrame
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

    ShowInputDialog = function(title, default)
        -- Simple input dialog using GUI
        local dialog = Instance.new("Frame")
        dialog.Size = UDim2.new(0, 400, 0, 150)
        dialog.Position = UDim2.new(0.5, -200, 0.5, -75)
        dialog.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
        dialog.BackgroundTransparency = 0.1
        dialog.BorderSizePixel = 0
        dialog.Parent = UI.GUI.ScreenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = dialog

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 30)
        titleLabel.Position = UDim2.new(0, 10, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title or "Input"
        titleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
        titleLabel.TextSize = 16
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Parent = dialog

        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(1, -20, 0, 35)
        inputBox.Position = UDim2.new(0, 10, 0, 40)
        inputBox.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
        inputBox.Text = default or ""
        inputBox.TextColor3 = Color3.fromRGB(200, 200, 210)
        inputBox.TextSize = 14
        inputBox.Font = Enum.Font.Gotham
        inputBox.Parent = dialog

        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 8)
        inputCorner.Parent = inputBox

        local confirmBtn = Instance.new("TextButton")
        confirmBtn.Size = UDim2.new(0, 100, 0, 35)
        confirmBtn.Position = UDim2.new(0.5, -110, 1, -45)
        confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        confirmBtn.BorderSizePixel = 0
        confirmBtn.Text = "✅ Confirm"
        confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        confirmBtn.TextSize = 14
        confirmBtn.Font = Enum.Font.GothamBold
        confirmBtn.Parent = dialog

        local confirmCorner = Instance.new("UICorner")
        confirmCorner.CornerRadius = UDim.new(0, 8)
        confirmCorner.Parent = confirmBtn

        local cancelBtn = Instance.new("TextButton")
        cancelBtn.Size = UDim2.new(0, 100, 0, 35)
        cancelBtn.Position = UDim2.new(0.5, 10, 1, -45)
        cancelBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
        cancelBtn.BorderSizePixel = 0
        cancelBtn.Text = "❌ Cancel"
        cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        cancelBtn.TextSize = 14
        cancelBtn.Font = Enum.Font.GothamBold
        cancelBtn.Parent = dialog

        local cancelCorner = Instance.new("UICorner")
        cancelCorner.CornerRadius = UDim.new(0, 8)
        cancelCorner.Parent = cancelBtn

        local result = nil
        confirmBtn.MouseButton1Click:Connect(function()
            result = inputBox.Text
            dialog:Destroy()
        end)

        cancelBtn.MouseButton1Click:Connect(function()
            dialog:Destroy()
        end)

        dialog:WaitForChild("Corner")
        repeat task.wait() until not dialog.Parent or result ~= nil
        return result
    end,

    ShowNotification = function(text, duration)
        duration = duration or 2
        local notification = Instance.new("TextLabel")
        notification.Size = UDim2.new(0, 350, 0, 40)
        notification.Position = UDim2.new(0.5, -175, 0.1, 0)
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

        notification.Position = UDim2.new(0.5, -175, 0.05, -40)
        Animations.SlideIn(notification, UDim2.new(0.5, -175, 0.05, -40), UDim2.new(0.5, -175, 0.1, 0), 0.3)

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

    -- ===== UI UPDATE FUNCTIONS =====
    UpdateStats = function()
        if not UI.GUI or not UI.GUI.Tabs or not UI.GUI.Tabs.Stats then return end

        local statsFrame = UI.GUI.Tabs.Stats.StatsFrame
        if not statsFrame then return end

        for _, child in ipairs(statsFrame:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "StatsList" then
                child:Destroy()
            end
        end

        local stats = {
            {Label = "📊 Total Logs", Value = #AdvancedSpy.RemoteLog},
            {Label = "🚫 Blocked Remotes", Value = 0},
            {Label = "📡 Total Remotes", Value = #RemoteCache:GetAll()},
            {Label = "📈 Total Calls", Value = AdvancedSpy.RemoteStats.TotalCalls or 0},
            {Label = "⚡ Peak Rate (calls/sec)", Value = AdvancedSpy.RemoteStats.PeakRate or 0},
            {Label = "⏱️ Uptime", Value = os.date("%H:%M:%S", os.time() - AdvancedSpy.StartTime)},
            {Label = "🔌 Active Hooks", Value = 0},
            {Label = "📦 Memory Usage", Value = string.format("%.1f MB", collectgarbage("count") / 1024)},
            {Label = "⏳ Avg Latency", Value = string.format("%.2f ms", AnalyticsEngine:CalculateAverageLatency() * 1000)},
            {Label = "🔒 Encryption", Value = AdvancedSpy.Settings.EncryptionEnabled and "✅ On" or "❌ Off"},
            {Label = "🧩 Pattern Rules", Value = #PatternMatcher.Rules},
            {Label = "🔄 Cache Version", Value = RemoteCache.Version},
        }

        local hookCount = 0
        for _, hooks in pairs(AdvancedSpy.CustomHooks) do
            for _ in pairs(hooks) do hookCount = hookCount + 1 end
        end
        stats[7].Value = hookCount

        local blockedCount = 0
        for _ in pairs(AdvancedSpy.BlockedRemotes) do blockedCount = blockedCount + 1 end
        stats[2].Value = blockedCount

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

    UpdateAnalytics = function()
        if not UI.GUI or not UI.GUI.Tabs or not UI.GUI.Tabs.Analytics then return end

        local analyticsFrame = UI.GUI.Tabs.Analytics.AnalyticsFrame
        if not analyticsFrame then return end

        for _, child in ipairs(analyticsFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local data = AnalyticsEngine.Data
        
        -- Performance Metrics
        local perfSection = UI.CreateSection("📊 Performance Metrics")
        perfSection.Parent = analyticsFrame
        
        for key, value in pairs(data.Performance or {}) do
            local row = UI.CreateStatRow(key, tostring(value))
            row.Parent = perfSection
        end
        
        -- Pattern Detection
        local patternSection = UI.CreateSection("🎯 Pattern Detection")
        patternSection.Parent = analyticsFrame
        
        for _, pattern in ipairs(data.PatternDetected or {}) do
            local row = UI.CreateStatRow(pattern.remote, string.format("%d calls (%.1f/s)", pattern.count, pattern.frequency))
            row.Parent = patternSection
        end
        
        -- Anomalies
        local anomalySection = UI.CreateSection("⚠️ Anomalies Detected")
        anomalySection.Parent = analyticsFrame
        
        for _, anomaly in ipairs(data.Anomalies or {}) do
            local label = anomaly.type == "Burst" and "Burst Rate" or "Rate Limit: " .. anomaly.remote
            local value = anomaly.type == "Burst" and string.format("%d/s (threshold: %d)", anomaly.rate, anomaly.threshold) 
                or string.format("%d calls (limit: %d)", anomaly.count, anomaly.limit)
            local row = UI.CreateStatRow(label, value)
            row.Parent = anomalySection
        end
        
        -- Heatmap (if enabled)
        if AdvancedSpy.Settings.EnableHeatmap then
            local heatmapSection = UI.CreateSection("🔥 Heatmap")
            heatmapSection.Parent = analyticsFrame
            
            local heatmapData = AnalyticsEngine:GenerateHeatmap()
            local sorted = {}
            for path, data in pairs(heatmapData) do
                table.insert(sorted, {path = path, data = data})
            end
            table.sort(sorted, function(a, b) return a.data.count > b.data.count end)
            
            for i = 1, math.min(10, #sorted) do
                local item = sorted[i]
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, -10, 0, 25)
                row.BackgroundColor3 = Color3.fromRGB(
                    50 + item.data.intensity * 150,
                    200 - item.data.intensity * 150,
                    50 + item.data.intensity * 50
                )
                row.BackgroundTransparency = 0.3
                row.BorderSizePixel = 0
                row.Parent = heatmapSection
                
                local rowCorner = Instance.new("UICorner")
                rowCorner.CornerRadius = UDim.new(0, 6)
                rowCorner.Parent = row
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.7, -5, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = item.path
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 11
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row
                
                local value = Instance.new("TextLabel")
                value.Size = UDim2.new(0.25, -5, 1, 0)
                value.Position = UDim2.new(0.75, 0, 0, 0)
                value.BackgroundTransparency = 1
                value.Text = string.format("%d (%.1f%%)", item.data.count, item.data.percentage)
                value.TextColor3 = Color3.fromRGB(255, 255, 255)
                value.TextSize = 11
                value.Font = Enum.Font.GothamBold
                value.TextXAlignment = Enum.TextXAlignment.Right
                value.Parent = row
            end
        end
    end,

    CreateSection = function(title)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, -10, 0, 30)
        section.BackgroundTransparency = 1
        section.BorderSizePixel = 0
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = Color3.fromRGB(0, 255, 200)
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = section
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 1, -1)
        line.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        line.BackgroundTransparency = 0.3
        line.Parent = section
        
        section.Label = label
        section.Line = line
        return section
    end,

    CreateStatRow = function(label, value)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -10, 0, 25)
        row.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
        row.BackgroundTransparency = 0.5
        row.BorderSizePixel = 0
        
        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 6)
        rowCorner.Parent = row
        
        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.7, -5, 1, 0)
        labelText.Position = UDim2.new(0, 10, 0, 0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label
        labelText.TextColor3 = Color3.fromRGB(200, 200, 210)
        labelText.TextSize = 12
        labelText.Font = Enum.Font.Gotham
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.Parent = row
        
        local valueText = Instance.new("TextLabel")
        valueText.Size = UDim2.new(0.25, -5, 1, 0)
        valueText.Position = UDim2.new(0.75, 0, 0, 0)
        valueText.BackgroundTransparency = 1
        valueText.Text = value
        valueText.TextColor3 = Color3.fromRGB(0, 255, 200)
        valueText.TextSize = 12
        valueText.Font = Enum.Font.GothamBold
        valueText.TextXAlignment = Enum.TextXAlignment.Right
        valueText.Parent = row
        
        return row
    end,

    UpdateRemotes = function()
        if not UI.GUI or not UI.GUI.Tabs or not UI.GUI.Tabs.Remotes then return end

        local remoteList = UI.GUI.Tabs.Remotes.RemoteList
        if not remoteList then return end

        for _, child in ipairs(remoteList:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local remotes = RemoteCache:GetAll()
        local searchLower = (UI.SearchText or ""):lower()
        local filterType = UI.CurrentFilter or "All"

        for _, remote in ipairs(remotes) do
            if AdvancedSpy.Settings.ShowAllRemotes or not AdvancedSpy:IsExcluded(remote) then
                if searchLower ~= "" then
                    local nameLower = remote.Name:lower()
                    local pathLower = remote:GetFullName():lower()
                    if not nameLower:find(searchLower) and not pathLower:find(searchLower) then
                        goto skip
                    end
                end

                if filterType == "RemoteEvent" and not remote:IsA("RemoteEvent") then goto skip end
                if filterType == "RemoteFunction" and not remote:IsA("RemoteFunction") then goto skip end

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -4, 0, 35)
                frame.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
                frame.BorderSizePixel = 0
                frame.Parent = remoteList

                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 6)
                frameCorner.Parent = frame

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
            ::skip::
        end
    end,

    UpdateHooks = function()
        if not UI.GUI or not UI.GUI.Tabs or not UI.GUI.Tabs.Hooks then return end

        local hooksFrame = UI.GUI.Tabs.Hooks.HooksFrame
        if not hooksFrame then return end

        for _, child in ipairs(hooksFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local hookTypes = {"BeforeFire", "AfterFire", "BeforeInvoke", "AfterInvoke", "OnBlock", "OnLog"}
        for _, type in ipairs(hookTypes) do
            local typeLabel = Instance.new("TextLabel")
            typeLabel.Size = UDim2.new(1, -10, 0, 25)
            typeLabel.BackgroundTransparency = 1
            typeLabel.Text = "📌 " .. type
            typeLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
            typeLabel.TextSize = 14
            typeLabel.Font = Enum.Font.GothamBold
            typeLabel.TextXAlignment = Enum.TextXAlignment.Left
            typeLabel.Parent = hooksFrame

            local hooks = AdvancedSpy.CustomHooks[type] or {}
            local hasHooks = false
            for name, _ in pairs(hooks) do
                hasHooks = true
                local hookRow = Instance.new("Frame")
                hookRow.Size = UDim2.new(1, -20, 0, 30)
                hookRow.Position = UDim2.new(0, 10, 0, 30 + (table.find(hookTypes, type) - 1) * 35)
                hookRow.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
                hookRow.BorderSizePixel = 0
                hookRow.Parent = hooksFrame

                local hookCorner = Instance.new("UICorner")
                hookCorner.CornerRadius = UDim.new(0, 6)
                hookCorner.Parent = hookRow

                local hookName = Instance.new("TextLabel")
                hookName.Size = UDim2.new(0.7, -5, 1, 0)
                hookName.Position = UDim2.new(0, 10, 0, 0)
                hookName.BackgroundTransparency = 1
                hookName.Text = name
                hookName.TextColor3 = Color3.fromRGB(200, 200, 210)
                hookName.TextSize = 12
                hookName.Font = Enum.Font.Gotham
                hookName.TextXAlignment = Enum.TextXAlignment.Left
                hookName.Parent = hookRow

                local removeBtn = Instance.new("TextButton")
                removeBtn.Size = UDim2.new(0, 30, 1, -4)
                removeBtn.Position = UDim2.new(0.85, 0, 0, 2)
                removeBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
                removeBtn.BorderSizePixel = 0
                removeBtn.Text = "✕"
                removeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                removeBtn.TextSize = 14
                removeBtn.Font = Enum.Font.GothamBold
                removeBtn.Parent = hookRow

                local removeCorner = Instance.new("UICorner")
                removeCorner.CornerRadius = UDim.new(0, 6)
                removeCorner.Parent = removeBtn

                removeBtn.MouseButton1Click:Connect(function()
                    AdvancedSpy:RemoveHook(type, name)
                    UI.UpdateHooks()
                end)
            end

            if not hasHooks then
                local noHook = Instance.new("TextLabel")
                noHook.Size = UDim2.new(1, -20, 0, 20)
                noHook.Position = UDim2.new(0, 10, 0, 30 + (table.find(hookTypes, type) - 1) * 35)
                noHook.BackgroundTransparency = 1
                noHook.Text = "  No hooks active"
                noHook.TextColor3 = Color3.fromRGB(100, 100, 130)
                noHook.TextSize = 11
                noHook.Font = Enum.Font.Gotham
                noHook.TextXAlignment = Enum.TextXAlignment.Left
                noHook.Parent = hooksFrame
            end
        end
    end,

    UpdateLogs = function()
        if not UI.GUI or not UI.GUI.Tabs or not UI.GUI.Tabs.Logs then return end

        local logList = UI.GUI.Tabs.Logs.LogList
        if not logList then return end

        for _, child in ipairs(logList:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local searchLower = (UI.SearchText or ""):lower()
        local filterType = UI.CurrentFilter or "All"

        for _, entry in ipairs(AdvancedSpy.RemoteLog) do
            if filterType ~= "All" and entry.Type ~= filterType then
                if filterType == "RemoteEvent" and not entry.Remote:IsA("RemoteEvent") then goto skip end
                if filterType == "RemoteFunction" and not entry.Remote:IsA("RemoteFunction") then goto skip end
                if filterType ~= "RemoteEvent" and filterType ~= "RemoteFunction" and entry.Type ~= filterType then
                    goto skip
                end
            end

            if searchLower ~= "" then
                local nameLower = entry.Remote.Name:lower()
                local argsStr = Utilities.FormatValue(entry.Args):lower()
                if not nameLower:find(searchLower) and not argsStr:find(searchLower) then
                    goto skip
                end
            end

            UI.AddLogEntry(entry)
            ::skip::
        end
    end,

    AddLogEntry = function(logEntry)
        if not UI.GUI or not UI.GUI.Tabs or not UI.GUI.Tabs.Logs then return end

        local logList = UI.GUI.Tabs.Logs.LogList
        if not logList then return end

        while #logList:GetChildren() > AdvancedSpy.Settings.MaxLogs do
            local child = logList:GetChildren()[1]
            if child and child:IsA("Frame") then
                child:Destroy()
            end
        end

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 50)
        frame.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
        frame.BorderSizePixel = 0
        frame.AutomaticSize = Enum.AutomaticSize.Y
        frame.Parent = logList

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 6)
        frameCorner.Parent = frame

        frame.BackgroundTransparency = 1
        Animations.FadeIn(frame, 0.3, {BackgroundTransparency = 0})

        -- Heatmap coloring based on frequency
        if AdvancedSpy.Settings.EnableHeatmap then
            local count = AdvancedSpy.RemoteStats.CallsPerRemote[logEntry.Remote.Name] or 0
            local intensity = math.min(1, count / 100)
            Animations.HeatMap(frame, intensity)
        end

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

        local remoteName = Instance.new("TextLabel")
        remoteName.Size = UDim2.new(0.5, -5, 0, 18)
        remoteName.Position = UDim2.new(0, 70, 0, 2)
        remoteName.BackgroundTransparency = 1
        remoteName.Text = Utilities.GetRemoteIcon(logEntry.Remote) .. " " .. logEntry.Remote.Name
        remoteName.TextColor3 = Color3.fromRGB(100, 200, 255)
        remoteName.TextSize = 13
        remoteName.Font = Enum.Font.GothamMedium
        remoteName.TextXAlignment = Enum.TextXAlignment.Left
        remoteName.Parent = frame

        -- Latency indicator
        if logEntry.Latency then
            local latencyLabel = Instance.new("TextLabel")
            latencyLabel.Size = UDim2.new(0, 60, 0, 16)
            latencyLabel.Position = UDim2.new(0.85, 0, 0, 2)
            latencyLabel.BackgroundTransparency = 1
            latencyLabel.Text = string.format("%.1fms", logEntry.Latency * 1000)
            latencyLabel.TextColor3 = logEntry.Latency < 0.1 and Color3.fromRGB(0, 255, 100) 
                or logEntry.Latency < 0.5 and Color3.fromRGB(255, 200, 50) 
                or Color3.fromRGB(255, 50, 50)
            latencyLabel.TextSize = 10
            latencyLabel.Font = Enum.Font.Gotham
            latencyLabel.TextXAlignment = Enum.TextXAlignment.Right
            latencyLabel.Parent = frame
        end

        local argsText = logEntry.Args and Utilities.FormatValue(logEntry.Args) or "{}"
        if AdvancedSpy.Settings.FilterSensitive and Utilities.IsSensitive(argsText) then
            argsText = "[🔒 SENSITIVE DATA HIDDEN]"
        end

        local argsLabel = Instance.new("TextLabel")
        argsLabel.Size = UDim2.new(1, -10, 0, 18)
        argsLabel.Position = UDim2.new(0, 5, 0, 24)
        argsLabel.BackgroundTransparency = 1
        argsLabel.Text = "📦 " .. string.sub(argsText, 1, 120) .. (string.len(argsText) > 120 and "..." or "")
        argsLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        argsLabel.TextSize = 11
        argsLabel.Font = Enum.Font.Gotham
        argsLabel.TextXAlignment = Enum.TextXAlignment.Left
        argsLabel.Parent = frame

        -- Pattern match indicator
        if logEntry.Pattern then
            local patternLabel = Instance.new("TextLabel")
            patternLabel.Size = UDim2.new(0, 150, 0, 14)
            patternLabel.Position = UDim2.new(0, 5, 1, -16)
            patternLabel.BackgroundTransparency = 1
            patternLabel.Text = "🎯 Pattern: " .. logEntry.Pattern.name
            patternLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
            patternLabel.TextSize = 10
            patternLabel.Font = Enum.Font.Gotham
            patternLabel.TextXAlignment = Enum.TextXAlignment.Left
            patternLabel.Parent = frame
        end

        if AdvancedSpy.Settings.HighlightImportant then
            local importantKeywords = {"kick", "ban", "admin", "execute", "loadstring", "http", "fire", "teleport"}
            local nameLower = logEntry.Remote.Name:lower()
            for _, keyword in ipairs(importantKeywords) do
                if nameLower:find(keyword) then
                    frame.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
                    remoteName.TextColor3 = Color3.fromRGB(255, 200, 50)
                    Animations.Pulse(frame, 1.02, 0.5)
                    break
                end
            end
        end

        return frame
    end,
}

-- ============ INITIALIZATION ============
function AdvancedSpy:Init()
    print("🔮 Initializing AdvancedSpy Pro v" .. self.Version)
    print("📡 GIỮ NGUYÊN UI ĐẸP + NÂNG CẤP TOÀN DIỆN:")
    print("  ✅ Anti-Detection: Randomize timing, fake traffic, clean traces")
    print("  ✅ Performance: Differential updates, lazy loading, cache")
    print("  ✅ Advanced Filter: Regex-like pattern matching, auto-block")
    print("  ✅ Auto-Responder: Send to remote server with retry")
    print("  ✅ Analytics: Pattern detection, anomaly detection, heatmap")
    print("  ✅ UI Enhancements: Color coding, heatmap, tooltips")
    print("  ✅ Security: Integrity check, encryption, anti-tamper")
    print("  ✅ Export Options: JSON, CSV, HTML, text with filters")

    self.Security.SessionID = Encryption.GenerateChecksum(tostring(os.time()) .. tostring(math.random(10000, 99999)))

    if not HookManager:Init() then
        warn("⚠️ Hook initialization failed! Some features may not work.")
    end

    RemoteCache:Update(true)

    game.DescendantAdded:Connect(function(desc)
        if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") or 
           desc:IsA("BindableEvent") or desc:IsA("BindableFunction") then
            RemoteCache:Update(true)
        end
    end)

    game.DescendantRemoving:Connect(function(desc)
        if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") or 
           desc:IsA("BindableEvent") or desc:IsA("BindableFunction") then
            RemoteCache:Update(true)
        end
    end)

    UI.Create()

    -- Add default pattern rules
    self:AddPatternRule("admin_kick", "kick|ban|admin|execute", "block")
    self:AddPatternRule("exploit_detect", "loadstring|httpget|getfenv|setfenv", "log")
    self:AddPatternRule("teleport", "teleport|tpt|position", "log")

    task.spawn(function()
        while self.Enabled do
            task.wait(self.Settings.ScanInterval or 5)
            if self.Enabled then
                RemoteCache:Update()
                UI.UpdateStats()
                AnalyticsEngine:Analyze()
                -- Generate fake traffic periodically
                if math.random(1, 10) == 1 then
                    AntiDetection.GenerateFakeTraffic()
                end
            end
        end
    end)

    task.spawn(function()
        while self.Enabled do
            task.wait(1)
            if self.Enabled then
                UI.UpdateStats()
                UI.UpdateHooks()
                if UI.CurrentTab == "Analytics" then
                    UI.UpdateAnalytics()
                end
            end
        end
    end)

    self.Enabled = true
    print("✅ AdvancedSpy Pro v" .. self.Version .. " loaded successfully!")
    print("🎮 Press F1 to toggle GUI")
    print("🔍 Use search bar to filter logs and remotes")
    print("📊 Check Analytics tab for pattern detection and heatmap")
    print("🔒 Encryption enabled: " .. tostring(self.Settings.EncryptionEnabled))
    print("🎯 Pattern matching: " .. #PatternMatcher.Rules .. " rules loaded")

    UI.ShowNotification("✅ AdvancedSpy Pro v" .. self.Version .. " Loaded!", 3)
end

-- ============ STARTUP ============
AdvancedSpy:Init()

return AdvancedSpy
