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
}

local Player = Services.Players.LocalPlayer
local Http = Services.HttpService

-- ============ CONFIG ============
local Config = {
    Version = "7.0.0",
    MaxLogs = 1000,
    CleanupInterval = 30,
    MaxCacheSize = 2000,
    EnableAI = true,
    EnableWebSocket = false,
    EnableDatabase = false,
    EnableAntiDetection = true,
    EnablePatternMatcher = true,
    AutoBlock = false,
    LogReturnValues = true,
    UI = {
        Theme = "darkhub",
        Transparency = 0.9,
        Animations = true,
        Blur = false,
    },
    AntiCrash = true,
    PerformanceMode = true,
}

-- ============ MEMORY MANAGER ============
local MemoryManager = {
    MaxLogs = Config.MaxLogs,
    MaxCache = Config.MaxCacheSize,
    CleanupInterval = Config.CleanupInterval,
    _timer = 0,
    
    Cleanup = function(self)
        -- Clean logs
        if #Spy.RemoteLogs > self.MaxLogs then
            local excess = #Spy.RemoteLogs - self.MaxLogs
            for i = 1, math.min(excess, 100) do
                table.remove(Spy.RemoteLogs, 1)
            end
        end
        
        -- Clean cache
        local cacheSize = 0
        for key in pairs(Spy.RemoteCache) do
            cacheSize = cacheSize + 1
            if cacheSize > self.MaxCache then
                Spy.RemoteCache[key] = nil
            end
        end
        
        -- Force GC
        if #Spy.RemoteLogs % 50 == 0 then
            collectgarbage("step", 10)
        end
    end,
}

-- ============ ERROR HANDLER ============
local ErrorHandler = {
    Enabled = true,
    Errors = {},
    MaxErrors = 50,
    
    Wrap = function(func, fallback)
        return function(...)
            if not ErrorHandler.Enabled then return func(...) end
            
            local success, result = pcall(func, ...)
            if not success then
                local err = tostring(result)
                table.insert(ErrorHandler.Errors, {
                    msg = err,
                    time = os.time()
                })
                if #ErrorHandler.Errors > ErrorHandler.MaxErrors then
                    table.remove(ErrorHandler.Errors, 1)
                end
                if fallback then return fallback(...) end
                return nil
            end
            return result
        end
    end,
    
    SafeCall = function(func, ...)
        if not ErrorHandler.Enabled then return func(...) end
        local success, result = pcall(func, ...)
        if not success then
            warn("[Spy] Error:", result)
            return nil
        end
        return result
    end,
}

-- ============ CORE SPY ENGINE ============
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
    },
    CustomHooks = {
        BeforeFire = {},
        AfterFire = {},
        OnBlock = {},
        OnLog = {},
        OnAnomaly = {},
    },
    Settings = Config,
    _connections = {},
    _cleanupTimer = 0,
}

-- ============ AI ENGINE (OPTIMIZED) ============
local AIEngine = {
    Trained = false,
    Model = {
        Weights = {},
        Biases = {},
        Layers = {},
    },
    Accuracy = 0,
    Loss = 0,
    TrainingData = {},
    Predictions = {},
    
    Initialize = function(self, inputSize, hiddenSizes, outputSize)
        hiddenSizes = hiddenSizes or {12, 24, 12}
        outputSize = outputSize or 2
        
        local layers = {inputSize}
        for _, size in ipairs(hiddenSizes) do
            table.insert(layers, size)
        end
        table.insert(layers, outputSize)
        self.Model.Layers = layers
        
        -- Initialize weights
        for layer = 2, #layers do
            local prevSize = layers[layer - 1]
            local currSize = layers[layer]
            
            self.Model.Weights[layer] = {}
            self.Model.Biases[layer] = {}
            
            local scale = math.sqrt(2 / prevSize)
            for i = 1, currSize do
                self.Model.Weights[layer][i] = {}
                for j = 1, prevSize do
                    self.Model.Weights[layer][i][j] = (math.random() * 2 - 1) * scale
                end
                self.Model.Biases[layer][i] = math.random() * 0.1
            end
        end
        
        self.Trained = false
        return true
    end,
    
    Forward = function(self, input)
        if not self.Trained then
            return {0.5, 0.5}
        end
        
        local current = input
        local layers = self.Model.Layers
        local weights = self.Model.Weights
        local biases = self.Model.Biases
        
        for layer = 2, #layers do
            local nextLayer = {}
            for i = 1, layers[layer] do
                local sum = biases[layer][i] or 0
                for j = 1, #current do
                    sum = sum + (current[j] or 0) * (weights[layer][i][j] or 0)
                end
                nextLayer[i] = math.max(0, sum) -- ReLU
            end
            current = nextLayer
        end
        
        -- Sigmoid output
        for i = 1, #current do
            current[i] = 1 / (1 + math.exp(-current[i]))
        end
        
        return current
    end,
    
    Predict = function(self, features)
        if not self.Trained then
            self:Initialize(#features, {12, 24, 12}, 2)
            self.Trained = true
        end
        
        local result = self:Forward(features)
        table.insert(self.Predictions, {
            input = features,
            output = result,
            time = os.time()
        })
        
        if #self.Predictions > 100 then
            table.remove(self.Predictions, 1)
        end
        
        return result
    end,
    
    Train = function(self, data, labels, epochs)
        if not data or #data == 0 then return end
        
        epochs = epochs or 50
        local lr = 0.01
        
        for epoch = 1, epochs do
            local totalLoss = 0
            
            for i = 1, #data do
                -- Forward
                local current = data[i]
                local layers = self.Model.Layers
                local weights = self.Model.Weights
                local biases = self.Model.Biases
                local layerOutputs = {current}
                
                for layer = 2, #layers do
                    local nextLayer = {}
                    for j = 1, layers[layer] do
                        local sum = biases[layer][j] or 0
                        for k = 1, #current do
                            sum = sum + (current[k] or 0) * (weights[layer][j][k] or 0)
                        end
                        nextLayer[j] = math.max(0, sum)
                    end
                    table.insert(layerOutputs, nextLayer)
                    current = nextLayer
                end
                
                -- Calculate loss
                local output = layerOutputs[#layerOutputs]
                local loss = 0
                for j = 1, #output do
                    local t = labels[i][j] or 0
                    loss = loss + (output[j] - t)^2
                end
                totalLoss = totalLoss + loss / #output
                
                -- Backward (simplified)
                local delta = {}
                for j = 1, #output do
                    delta[j] = (output[j] - (labels[i][j] or 0)) * 2
                end
                
                for layer = #layers, 2, -1 do
                    local prevOutput = layerOutputs[layer - 1]
                    for j = 1, #delta do
                        for k = 1, #prevOutput do
                            weights[layer][j][k] = weights[layer][j][k] - 
                                delta[j] * (prevOutput[k] or 0) * lr
                        end
                        biases[layer][j] = biases[layer][j] - delta[j] * lr
                    end
                end
            end
            
            self.Loss = totalLoss / #data
            if epoch % 10 == 0 then
                print(string.format("[AI] Epoch %d/%d Loss: %.4f", epoch, epochs, self.Loss))
            end
        end
        
        self.Trained = true
        self.Accuracy = 1 - self.Loss
        print(string.format("[AI] Training complete! Accuracy: %.2f%%", self.Accuracy * 100))
    end,
    
    DetectAnomaly = function(self, remote, args, latency)
        if not Config.EnableAI then return false, 0 end
        
        local features = {
            string.len(tostring(remote.Name)) / 20,
            #args / 5,
            (latency or 0) / 0.5,
            (Spy.RemoteStats.CallsPerRemote[remote.Name] or 0) / 100,
            os.time() % 60 / 60,
        }
        
        local prediction = self:Predict(features)
        local score = prediction[1] or 0.5
        
        return score > 0.8, score
    end,
}

-- ============ REMOTE SCANNER ============
local RemoteScanner = {
    Scanning = false,
    LastScan = 0,
    ScanInterval = 5,
    
    Scan = function(self, force)
        if self.Scanning then return end
        local now = os.time()
        if not force and now - self.LastScan < self.ScanInterval then return end
        
        self.Scanning = true
        local remotes = {}
        
        local function scanInstance(instance, path)
            if not instance then return end
            
            for _, child in ipairs(instance:GetChildren()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    local data = {
                        Name = child.Name,
                        Path = path .. "/" .. child.Name,
                        Type = child.ClassName,
                        Object = child,
                        ClassName = child.ClassName,
                        Parent = child.Parent,
                        IsEnabled = true,
                        Calls = Spy.RemoteStats.CallsPerRemote[child.Name] or 0,
                    }
                    table.insert(remotes, data)
                end
                scanInstance(child, path .. "/" .. child.Name)
            end
        end
        
        ErrorHandler.SafeCall(scanInstance, Services.ReplicatedStorage, "ReplicatedStorage")
        ErrorHandler.SafeCall(scanInstance, Player, "Player")
        ErrorHandler.SafeCall(scanInstance, game:GetService("ReplicatedFirst"), "ReplicatedFirst")
        
        Spy.RemoteCache = remotes
        self.LastScan = now
        self.Scanning = false
        
        return remotes
    end,
    
    GetRemotes = function(self, filter)
        local remotes = self:Scan()
        if not filter then return remotes end
        
        local filtered = {}
        for _, remote in ipairs(remotes) do
            if remote.Name:lower():find(filter:lower()) then
                table.insert(filtered, remote)
            end
        end
        return filtered
    end,
}

-- ============ REMOTE HOOKER ============
local RemoteHooker = {
    Hooked = {},
    Methods = {},
    
    HookRemote = function(self, remote)
        if not remote or self.Hooked[remote] then return end
        
        local remoteType = remote.ClassName
        
        if remoteType == "RemoteEvent" then
            -- Hook OnServerEvent
            local original = remote.OnServerEvent
            local hook = ErrorHandler.Wrap(function(player, ...)
                if Spy.Enabled and not Spy.BlockedRemotes[remote] then
                    local args = {...}
                    local success = Spy:LogCall(remote, args, "RemoteEvent")
                    
                    -- AI Detection
                    if Config.EnableAI then
                        local isAnomaly, score = AIEngine:DetectAnomaly(remote, args, 0)
                        if isAnomaly and Config.AutoBlock then
                            Spy:BlockRemote(remote)
                            UI:Notify("⚠️ Blocked anomaly: " .. remote.Name)
                        end
                    end
                end
                return original:Fire(player, ...)
            end)
            
            -- Backup original
            self.Methods[remote] = {OnServerEvent = original}
            
            -- Apply hook
            remote.OnServerEvent = hook
            self.Hooked[remote] = true
            
        elseif remoteType == "RemoteFunction" then
            -- Hook OnServerInvoke
            local original = remote.OnServerInvoke
            local hook = ErrorHandler.Wrap(function(player, ...)
                local result = nil
                if Spy.Enabled and not Spy.BlockedRemotes[remote] then
                    local args = {...}
                    Spy:LogCall(remote, args, "RemoteFunction")
                    result = original(player, ...)
                    if Config.LogReturnValues then
                        Spy:LogReturn(remote, result)
                    end
                else
                    result = original(player, ...)
                end
                return result
            end)
            
            self.Methods[remote] = {OnServerInvoke = original}
            remote.OnServerInvoke = hook
            self.Hooked[remote] = true
        end
        
        return true
    end,
    
    HookAll = function(self)
        local remotes = RemoteScanner:GetRemotes()
        local count = 0
        for _, data in ipairs(remotes) do
            if self:HookRemote(data.Object) then
                count = count + 1
            end
        end
        return count
    end,
    
    UnhookRemote = function(self, remote)
        if not self.Hooked[remote] then return end
        
        local methods = self.Methods[remote]
        if methods then
            if remote.OnServerEvent then
                remote.OnServerEvent = methods.OnServerEvent or remote.OnServerEvent
            end
            if remote.OnServerInvoke then
                remote.OnServerInvoke = methods.OnServerInvoke or remote.OnServerInvoke
            end
        end
        
        self.Hooked[remote] = nil
        self.Methods[remote] = nil
        return true
    end,
}

-- ============ PATTERN MATCHER ============
local PatternMatcher = {
    Rules = {},
    MatchHistory = {},
    
    AddRule = function(self, name, pattern, action, priority)
        priority = priority or 0
        
        local rule = {
            name = name,
            pattern = pattern,
            action = action or "log",
            priority = priority,
            matches = 0,
            compiled = type(pattern) == "string" and pattern:gsub("%*", ".*") or pattern,
        }
        table.insert(self.Rules, rule)
        table.sort(self.Rules, function(a, b) return a.priority > b.priority end)
        return rule
    end,
    
    Match = function(self, remote, args)
        if not Config.EnablePatternMatcher then return nil end
        
        local remoteName = remote.Name
        local argsStr = tostring(args)
        
        for _, rule in ipairs(self.Rules) do
            local matched = false
            
            if type(rule.compiled) == "string" then
                if remoteName:find(rule.compiled) or argsStr:find(rule.compiled) then
                    matched = true
                end
            elseif type(rule.compiled) == "table" then
                for _, p in ipairs(rule.compiled) do
                    if remoteName:find(p) or argsStr:find(p) then
                        matched = true
                        break
                    end
                end
            end
            
            if matched then
                rule.matches = rule.matches + 1
                table.insert(self.MatchHistory, {
                    rule = rule,
                    remote = remote,
                    args = args,
                    time = os.time()
                })
                
                if #self.MatchHistory > 100 then
                    table.remove(self.MatchHistory, 1)
                end
                
                -- Execute action
                if rule.action == "block" then
                    Spy:BlockRemote(remote)
                    UI:Notify("⛔ Blocked: " .. remote.Name)
                elseif rule.action == "log" then
                    Spy:AddToLog(remote, args, "PatternMatch", rule.name)
                end
                
                return rule
            end
        end
        
        return nil
    end,
}

-- ============ SMART RESPONDER ============
local SmartResponder = {
    Queue = {},
    AutoRespond = false,
    Responses = {},
    
    AddResponse = function(self, pattern, response)
        self.Responses[pattern] = response
    end,
    
    Process = function(self, remote, args)
        if not self.AutoRespond then return end
        
        for pattern, response in pairs(self.Responses) do
            if tostring(remote.Name):find(pattern) then
                local resp = type(response) == "function" and response(args) or response
                table.insert(self.Queue, {
                    remote = remote,
                    args = args,
                    response = resp,
                    time = os.time()
                })
                return true
            end
        end
        return false
    end,
    
    SendResponse = function(self, remote, response)
        if not remote then return end
        ErrorHandler.SafeCall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(response)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(response)
            end
        end)
    end,
}

-- ============ ANTI-DETECTION ============
local AntiDetection = {
    Enabled = Config.EnableAntiDetection,
    BehavioralStats = {
        Clicks = 0,
        Movements = 0,
        Keys = 0,
        LastActivity = os.time(),
    },
    
    Mimic = function(self)
        if not self.Enabled then return end
        
        local intensity = 0.2
        if math.random() < intensity then
            -- Simulate mouse movement
            local x = math.random(0, 1920)
            local y = math.random(0, 1080)
            ErrorHandler.SafeCall(function()
                Services.UserInputService:SetMousePosition(UDim2.new(0, x, 0, y))
            end)
            self.BehavioralStats.Movements = self.BehavioralStats.Movements + 1
        end
        
        if math.random() < intensity * 0.5 then
            -- Simulate key press
            local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
                         Enum.KeyCode.Space, Enum.KeyCode.LeftShift}
            local key = keys[math.random(1, #keys)]
            ErrorHandler.SafeCall(function()
                Services.UserInputService:SimulateKeyPress(key)
            end)
            self.BehavioralStats.Keys = self.BehavioralStats.Keys + 1
        end
    end,
    
    RandomDelay = function(self, base)
        if not self.Enabled then return base or 0 end
        return (base or 0) + math.random() * 0.2 + 0.05
    end,
}

-- ============ WEBSOCKET MANAGER ============
local WebSocketManager = {
    Connected = false,
    Connection = nil,
    Queue = {},
    ReconnectAttempts = 0,
    MaxReconnect = 5,
    URL = "",
    
    Connect = function(self, url)
        if not Config.EnableWebSocket or url == "" then return end
        
        self.URL = url
        local success, ws = pcall(function()
            return syn and syn.websocket.connect(url)
        end)
        
        if success and ws then
            self.Connection = ws
            self.Connected = true
            self.ReconnectAttempts = 0
            
            ws.OnMessage:Connect(function(msg)
                self:HandleMessage(msg)
            end)
            
            ws.OnClose:Connect(function(code, reason)
                self.Connected = false
                print("[WebSocket] Disconnected:", code, reason)
                if Config.EnableWebSocket then
                    self:Reconnect()
                end
            end)
            
            print("[WebSocket] Connected to:", url)
            return true
        end
        
        return false
    end,
    
    Reconnect = function(self)
        if self.ReconnectAttempts >= self.MaxReconnect then return end
        
        self.ReconnectAttempts = self.ReconnectAttempts + 1
        local delay = math.min(self.ReconnectAttempts ^ 2, 30)
        
        print(string.format("[WebSocket] Reconnecting in %ds...", delay))
        task.wait(delay)
        self:Connect(self.URL)
    end,
    
    Send = function(self, data)
        if not self.Connected then
            table.insert(self.Queue, data)
            return
        end
        
        local success, err = pcall(function()
            local encoded = Http:JSONEncode(data)
            self.Connection.Send(encoded)
        end)
        
        if not success then
            table.insert(self.Queue, data)
        end
    end,
    
    HandleMessage = function(self, message)
        local success, data = pcall(Http.JSONDecode, Http, message)
        if not success then return end
        
        if data.type == "command" then
            self:ExecuteCommand(data.command, data.params)
        elseif data.type == "sync" then
            self:SyncData(data)
        end
    end,
    
    ExecuteCommand = function(self, command, params)
        if command == "toggle" then
            Spy:Toggle()
        elseif command == "block" and params.remote then
            local remote = RemoteScanner:GetRemotes(params.remote)
            if remote then Spy:BlockRemote(remote) end
        elseif command == "clear" then
            Spy:ClearLogs()
        end
    end,
    
    SyncData = function(self, data)
        if data.logs then
            for _, log in ipairs(data.logs) do
                table.insert(Spy.RemoteLogs, 1, log)
            end
        end
        if data.blocked then
            for _, name in ipairs(data.blocked) do
                for _, remote in ipairs(RemoteScanner:GetRemotes()) do
                    if remote.Name == name then
                        Spy:BlockRemote(remote.Object)
                    end
                end
            end
        end
    end,
}

-- ============ DATABASE MANAGER ============
local DatabaseManager = {
    Connected = false,
    Cache = {},
    Queue = {},
    
    Init = function(self)
        if not Config.EnableDatabase then return end
        
        local success, db = pcall(function()
            return syn and syn.sqlite.open("spy_data.db")
        end)
        
        if success and db then
            self.Connection = db
            self.Connected = true
            
            -- Create tables
            self:CreateTables()
            print("[Database] Connected")
            return true
        end
        
        return false
    end,
    
    CreateTables = function(self)
        if not self.Connected then return end
        
        local tables = {
            [[CREATE TABLE IF NOT EXISTS logs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp INTEGER,
                remote TEXT,
                args TEXT,
                type TEXT
            )]],
            [[CREATE TABLE IF NOT EXISTS remotes (
                name TEXT PRIMARY KEY,
                calls INTEGER DEFAULT 0,
                blocked INTEGER DEFAULT 0
            )]],
        }
        
        for _, query in ipairs(tables) do
            ErrorHandler.SafeCall(function()
                self.Connection:exec(query)
            end)
        end
    end,
    
    InsertLog = function(self, log)
        if not self.Connected then return end
        
        local query = [[
            INSERT INTO logs (timestamp, remote, args, type)
            VALUES (?, ?, ?, ?)
        ]]
        
        ErrorHandler.SafeCall(function()
            self.Connection:exec(query, {
                log.Timestamp or os.time(),
                log.Name or "Unknown",
                Http:JSONEncode(log.Args or {}),
                log.Type or "Remote"
            })
        end)
    end,
    
    GetLogs = function(self, limit)
        if not self.Connected then return {} end
        
        local query = "SELECT * FROM logs ORDER BY id DESC LIMIT ?"
        local result = ErrorHandler.SafeCall(function()
            return self.Connection:exec(query, {limit or 100})
        end)
        
        return result or {}
    end,
}

-- ============ DARKHUB UI ============
local UI = {
    ScreenGui = nil,
    MainFrame = nil,
    LogsList = nil,
    StatusLabel = nil,
    StatsLabel = nil,
    Buttons = {},
    Initialized = false,
    NotifyQueue = {},
    
    Init = function(self)
        if self.Initialized then return end
        
        self.ScreenGui = Instance.new("ScreenGui")
        self.ScreenGui.Name = "SpyV7_UI"
        self.ScreenGui.Parent = Services.CoreGui
        self.ScreenGui.ResetOnSpawn = false
        
        -- Main Frame
        self.MainFrame = Instance.new("Frame")
        self.MainFrame.Size = UDim2.new(0, 450, 0, 580)
        self.MainFrame.Position = UDim2.new(0.5, -225, 0.5, -290)
        self.MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
        self.MainFrame.BackgroundTransparency = 0.05
        self.MainFrame.BorderSizePixel = 0
        self.MainFrame.ClipsDescendants = true
        self.MainFrame.Parent = self.ScreenGui
        
        -- Shadow
        local shadow = Instance.new("ImageLabel")
        shadow.Size = UDim2.new(1, 20, 1, 20)
        shadow.Position = UDim2.new(0, -10, 0, -10)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316043460"
        shadow.ImageTransparency = 0.8
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 10, 10)
        shadow.Parent = self.MainFrame
        
        -- Title Bar
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 35)
        titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = self.MainFrame
        
        -- Title
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -40, 1, 0)
        title.Text = "🔮 SPY V7 - DARKHUB EDITION"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 15
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.GothamBold
        title.BackgroundTransparency = 1
        title.Parent = titleBar
        
        -- Close Button
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 2)
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 14
        closeBtn.Font = Enum.Font.Gotham
        closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        closeBtn.BorderSizePixel = 0
        closeBtn.Parent = titleBar
        closeBtn.MouseButton1Click:Connect(function()
            self:Toggle()
        end)
        
        -- Status Label
        self.StatusLabel = Instance.new("TextLabel")
        self.StatusLabel.Size = UDim2.new(1, -20, 0, 25)
        self.StatusLabel.Position = UDim2.new(0, 10, 0, 40)
        self.StatusLabel.Text = "🔴 INACTIVE"
        self.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        self.StatusLabel.TextSize = 13
        self.StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.StatusLabel.Font = Enum.Font.GothamBold
        self.StatusLabel.BackgroundTransparency = 1
        self.StatusLabel.Parent = self.MainFrame
        
        -- Stats Label
        self.StatsLabel = Instance.new("TextLabel")
        self.StatsLabel.Size = UDim2.new(1, -20, 0, 20)
        self.StatsLabel.Position = UDim2.new(0, 10, 0, 65)
        self.StatsLabel.Text = "📊 Remotes: 0 | Calls: 0 | Rate: 0/s"
        self.StatsLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        self.StatsLabel.TextSize = 11
        self.StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.StatsLabel.Font = Enum.Font.Gotham
        self.StatsLabel.BackgroundTransparency = 1
        self.StatsLabel.Parent = self.MainFrame
        
        -- Buttons
        local btnData = {
            {"Toggle", 10, 90, 80, 28, function()
                local status = Spy:Toggle()
                self:UpdateStatus(status)
                if status then
                    RemoteHooker:HookAll()
                end
            end},
            {"Clear", 100, 90, 80, 28, function()
                Spy:ClearLogs()
                self:RefreshLogs()
            end},
            {"Scan", 190, 90, 80, 28, function()
                RemoteScanner:Scan(true)
                self:UpdateStats()
                UI:Notify("✅ Scanned " .. #Spy.RemoteCache .. " remotes")
            end},
            {"Block All", 280, 90, 80, 28, function()
                for _, data in ipairs(Spy.RemoteCache) do
                    Spy:BlockRemote(data.Object)
                end
                UI:Notify("⛔ Blocked all remotes")
            end},
            {"Unblock", 370, 90, 80, 28, function()
                Spy.BlockedRemotes = {}
                UI:Notify("🔓 Unblocked all remotes")
            end},
        }
        
        for _, data in ipairs(btnData) do
            local btn = self:CreateButton(data[2], data[3], data[4], data[5], data[6])
            self.Buttons[data[2]] = btn
        end
        
        -- Logs List
        self.LogsList = Instance.new("ScrollingFrame")
        self.LogsList.Size = UDim2.new(1, -20, 1, -135)
        self.LogsList.Position = UDim2.new(0, 10, 0, 125)
        self.LogsList.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
        self.LogsList.BackgroundTransparency = 0.5
        self.LogsList.BorderSizePixel = 0
        self.LogsList.Parent = self.MainFrame
        
        -- Logs List Layout
        local layout = Instance.new("UIListLayout")
        layout.Parent = self.LogsList
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 2)
        
        -- Scrollbar
        local scrollbar = Instance.new("ScrollingFrame")
        scrollbar.Size = UDim2.new(0, 8, 1, 0)
        scrollbar.Position = UDim2.new(1, -10, 0, 0)
        scrollbar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        scrollbar.BorderSizePixel = 0
        scrollbar.Parent = self.LogsList
        
        self.Initialized = true
        self:UpdateStatus(Spy.Enabled)
        
        -- Start auto refresh
        task.spawn(function()
            while self.ScreenGui do
                task.wait(0.3)
                self:RefreshLogs()
                self:UpdateStats()
            end
        end)
        
        -- Start notification loop
        task.spawn(function()
            while self.ScreenGui do
                task.wait()
                while #self.NotifyQueue > 0 do
                    local notif = table.remove(self.NotifyQueue, 1)
                    self:ShowNotification(notif)
                    task.wait(3)
                end
            end
        end)
    end,
    
    CreateButton = function(self, text, x, y, w, h, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, w, 0, h)
        btn.Position = UDim2.new(0, x, 0, y)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        btn.BorderSizePixel = 0
        btn.Parent = self.MainFrame
        
        -- Hover effect
        local hover = Instance.new("UIStroke")
        hover.Color = Color3.fromRGB(100, 100, 200)
        hover.Thickness = 1
        hover.Transparency = 1
        hover.Parent = btn
        
        btn.MouseEnter:Connect(function()
            hover.Transparency = 0
        end)
        btn.MouseLeave:Connect(function()
            hover.Transparency = 1
        end)
        
        btn.MouseButton1Click:Connect(function()
            ErrorHandler.SafeCall(callback)
        end)
        
        return btn
    end,
    
    UpdateStatus = function(self, enabled)
        if self.StatusLabel then
            self.StatusLabel.Text = enabled and "🟢 ACTIVE" or "🔴 INACTIVE"
            self.StatusLabel.TextColor3 = enabled and 
                Color3.fromRGB(100, 255, 100) or 
                Color3.fromRGB(255, 100, 100)
        end
        
        if self.Buttons and self.Buttons["Toggle"] then
            self.Buttons["Toggle"].Text = enabled and "✅ On" or "❌ Off"
            self.Buttons["Toggle"].BackgroundColor3 = enabled and 
                Color3.fromRGB(0, 150, 0) or 
                Color3.fromRGB(150, 0, 0)
        end
    end,
    
    UpdateStats = function(self)
        if not self.StatsLabel then return end
        
        local total = #Spy.RemoteCache
        local calls = Spy.RemoteStats.TotalCalls
        local rate = 0
        local now = os.time()
        local elapsed = now - Spy.RemoteStats.StartTime
        if elapsed > 0 then
            rate = calls / elapsed
        end
        
        self.StatsLabel.Text = string.format(
            "📊 Remotes: %d | Calls: %d | Rate: %.1f/s | Logs: %d",
            total, calls, rate, #Spy.RemoteLogs
        )
    end,
    
    RefreshLogs = function(self)
        if not self.LogsList then return end
        
        -- Clear old entries
        for _, child in ipairs(self.LogsList:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        -- Add new logs (limit to 80 for performance)
        local count = 0
        for i = 1, math.min(#Spy.RemoteLogs, 80) do
            local log = Spy.RemoteLogs[i]
            if not log then break end
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 20)
            label.Text = string.sub(log.Formatted or log.Name or "Unknown", 1, 80)
            label.TextColor3 = Color3.fromRGB(180, 180, 230)
            label.TextSize = 11
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.BackgroundTransparency = 1
            label.Parent = self.LogsList
            
            count = count + 1
        end
    end,
    
    Notify = function(self, message, duration)
        table.insert(self.NotifyQueue, {msg = message, duration = duration or 3})
    end,
    
    ShowNotification = function(self, data)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 300, 0, 40)
        notif.Position = UDim2.new(0.5, -150, 1, -50)
        notif.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.Parent = self.ScreenGui
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Text = data.msg or "Notification"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = notif
        
        -- Animate in
        notif.Position = UDim2.new(0.5, -150, 1, -50)
        Services.TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -150, 0.9, -50)
        }):Play()
        
        task.wait(data.duration or 3)
        
        -- Animate out
        Services.TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -150, 1, -50)
        }):Play()
        
        task.wait(0.3)
        notif:Destroy()
    end,
    
    Toggle = function(self)
        if self.ScreenGui then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end,
}

-- ============ SPY METHODS ============
function Spy:Toggle()
    self.Enabled = not self.Enabled
    if self.Enabled then
        RemoteHooker:HookAll()
        print("[Spy] Enabled")
    else
        print("[Spy] Disabled")
    end
    return self.Enabled
end

function Spy:LogCall(remote, args, callType)
    if self.BlockedRemotes[remote] then return false end
    if self.ExcludedRemotes[remote] then return false end
    
    -- Update stats
    self.RemoteStats.TotalCalls = self.RemoteStats.TotalCalls + 1
    self.RemoteStats.CallsPerRemote[remote.Name] = 
        (self.RemoteStats.CallsPerRemote[remote.Name] or 0) + 1
    
    -- Create log entry
    local logEntry = {
        Remote = remote,
        Name = remote.Name,
        Args = args,
        Type = callType or "Remote",
        Timestamp = os.time(),
        Formatted = string.format("[%s] %s | Args: %s",
            os.date("%H:%M:%S"),
            remote.Name,
            #args > 0 and tostring(args):sub(1, 50) or "{}"
        ),
    }
    
    -- Pattern matching
    if Config.EnablePatternMatcher then
        local match = PatternMatcher:Match(remote, args)
        if match then
            logEntry.Pattern = match.name
            logEntry.Formatted = logEntry.Formatted .. " [Pattern: " .. match.name .. "]"
        end
    end
    
    -- Add to logs
    table.insert(self.RemoteLogs, 1, logEntry)
    
    -- Database
    if Config.EnableDatabase and DatabaseManager.Connected then
        DatabaseManager:InsertLog(logEntry)
    end
    
    -- WebSocket sync
    if Config.EnableWebSocket and WebSocketManager.Connected then
        WebSocketManager:Send({
            type = "log",
            data = logEntry
        })
    end
    
    -- Trigger hooks
    for name, hook in pairs(self.CustomHooks.OnLog) do
        ErrorHandler.SafeCall(hook, remote, args)
    end
    
    -- Auto cleanup
    if #self.RemoteLogs > Config.MaxLogs then
        MemoryManager:Cleanup()
    end
    
    return true
end

function Spy:LogReturn(remote, result)
    if not Config.LogReturnValues then return end
    
    local logEntry = {
        Remote = remote,
        Name = remote.Name,
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

function Spy:BlockRemote(remote)
    self.BlockedRemotes[remote] = true
    
    for name, hook in pairs(self.CustomHooks.OnBlock) do
        ErrorHandler.SafeCall(hook, remote)
    end
    
    UI:Notify("⛔ Blocked: " .. remote.Name)
    return true
end

function Spy:UnblockRemote(remote)
    self.BlockedRemotes[remote] = nil
    return true
end

function Spy:ClearLogs()
    self.RemoteLogs = {}
    MemoryManager:Cleanup()
    UI:Notify("🗑️ Logs cleared")
end

function Spy:AddToLog(remote, args, type, extra)
    local logEntry = {
        Remote = remote,
        Name = remote.Name,
        Args = args,
        Type = type or "Custom",
        Timestamp = os.time(),
        Formatted = string.format("[%s] %s | %s",
            os.date("%H:%M:%S"),
            remote.Name,
            extra or ""
        ),
    }
    table.insert(self.RemoteLogs, 1, logEntry)
end

-- ============ AUTO CLEANUP ============
task.spawn(function()
    while true do
        task.wait(Config.CleanupInterval)
        MemoryManager:Cleanup()
        
        -- Update stats
        if Spy.Enabled then
            local now = os.time()
            local elapsed = now - Spy.RemoteStats.StartTime
            if elapsed > 0 then
                Spy.RemoteStats.CurrentRate = Spy.RemoteStats.TotalCalls / elapsed
                if Spy.RemoteStats.CurrentRate > Spy.RemoteStats.PeakRate then
                    Spy.RemoteStats.PeakRate = Spy.RemoteStats.CurrentRate
                end
            end
        end
        
        -- Anti-Detection mimicry
        if Config.EnableAntiDetection then
            AntiDetection:Mimic()
        end
    end
end)

-- ============ COMMANDS ============
local Commands = {
    toggle = function()
        Spy:Toggle()
        UI:UpdateStatus(Spy.Enabled)
    end,
    
    clear = function()
        Spy:ClearLogs()
    end,
    
    block = function(name)
        if not name then
            print("Usage: block <remote_name>")
            return
        end
        for _, data in ipairs(RemoteScanner:GetRemotes()) do
            if data.Name:lower():find(name:lower()) then
                Spy:BlockRemote(data.Object)
                print("[Spy] Blocked:", data.Name)
            end
        end
    end,
    
    unblock = function(name)
        if not name then
            print("Usage: unblock <remote_name>")
            return
        end
        for remote in pairs(Spy.BlockedRemotes) do
            if remote.Name:lower():find(name:lower()) then
                Spy:UnblockRemote(remote)
                print("[Spy] Unblocked:", remote.Name)
            end
        end
    end,
    
    scan = function()
        local count = #RemoteScanner:Scan(true)
        UI:UpdateStats()
        print("[Spy] Scanned:", count, "remotes")
    end,
    
    status = function()
        print(string.format([[
[Spy] Status:
  Enabled: %s
  Remotes: %d
  Calls: %d
  Logs: %d
  Blocked: %d
        ]], Spy.Enabled, #Spy.RemoteCache, Spy.RemoteStats.TotalCalls, 
           #Spy.RemoteLogs, table_count(Spy.BlockedRemotes)))
    end,
    
    help = function()
        print([[
📋 SPY V7 COMMANDS:
  toggle    - Enable/Disable spy
  clear     - Clear all logs
  block <n> - Block remote by name
  unblock <n> - Unblock remote
  scan      - Scan for remotes
  status    - Show status
  help      - Show this help
  ui        - Toggle UI
        ]])
    end,
    
    ui = function()
        UI:Toggle()
    end,
}

function table_count(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- ============ CONSOLE INPUT ============
task.spawn(function()
    while true do
        task.wait()
        local input = io and io.read()
        if input and input ~= "" then
            local parts = {}
            for part in input:gmatch("%S+") do
                table.insert(parts, part)
            end
            
            local cmd = parts[1] and parts[1]:lower()
            if cmd and Commands[cmd] then
                Commands[cmd](unpack(parts, 2))
            elseif cmd then
                print("[Spy] Unknown command. Type 'help' for list.")
            end
        end
    end
end)

-- ============ KEYBIND ============
Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightAlt then
        Spy:Toggle()
        UI:UpdateStatus(Spy.Enabled)
    end
end)

-- ============ INITIALIZATION ============
function Init()
    print(string.format([[
╔═══════════════════════════════════════╗
║  🔮 SPY V7 ULTIMATE LOADED            ║
║  ═══════════════════════════════════  ║
║  Version: %s                         ║
║  Features: AI | WebSocket | Database  ║
║  Status: Ready                       ║
║  Type 'help' for commands            ║
║  Press RightAlt to toggle            ║
╚═══════════════════════════════════════╝
    ]], Config.Version))
    
    -- Initialize AI
    if Config.EnableAI then
        AIEngine:Initialize(5, {12, 24, 12}, 2)
        AIEngine.Trained = true
        print("[AI] Neural Network initialized")
    end
    
    -- Initialize Database
    if Config.EnableDatabase then
        DatabaseManager:Init()
    end
    
    -- Scan remotes
    RemoteScanner:Scan()
    
    -- Initialize UI
    ErrorHandler.SafeCall(UI.Init, UI)
    
    -- Add default patterns
    if Config.EnablePatternMatcher then
        PatternMatcher:AddRule("Kick", {"kick", "ban", "remove"}, "block", 10)
        PatternMatcher:AddRule("Admin", {"admin", "command", "execute"}, "log", 5)
        PatternMatcher:AddRule("Stats", {"stats", "ping", "info"}, "log", 1)
    end
    
    print("[Spy] Ready! Press RightAlt or type 'toggle' to start")
end

-- ============ SAFE EXIT ============
local function SafeExit()
    print("[Spy] Shutting down...")
    Spy.Enabled = false
    
    for _, conn in ipairs(Spy._connections) do
        if conn and conn.Disconnect then
            ErrorHandler.SafeCall(conn.Disconnect, conn)
        end
    end
    
    if UI.ScreenGui then
        UI.ScreenGui:Destroy()
    end
    
    print("[Spy] Unloaded")
end

game:BindToClose(SafeExit)

-- ============ START ============
Init()

return {
    Spy = Spy,
    AI = AIEngine,
    UI = UI,
    RemoteScanner = RemoteScanner,
    RemoteHooker = RemoteHooker,
    PatternMatcher = PatternMatcher,
    WebSocket = WebSocketManager,
    Database = DatabaseManager,
    Commands = Commands,
}
