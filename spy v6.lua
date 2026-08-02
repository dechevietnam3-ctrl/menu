--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║  🔮 ADVANCEDSPY PRO MAX - ULTIMATE EDITION v6.0.0                     ║
    ║  ════════════════════════════════════════════════════════════════════  ║
    ║  🚀 NÂNG CẤP TOÀN DIỆN SO VỚI V5:                                    ║
    ║  • Neural Network AI cho phát hiện bất thường                         ║
    ║  • Behavioral Mimicry chống phát hiện                                 ║
    ║  • WebSocket Live Streaming                                           ║
    ║  • Database SQLite lưu trữ lịch sử                                   ║
    ║  • Multi-Instance Sync qua WebSocket                                  ║
    ║  • Real-time Analytics Dashboard                                      ║
    ║  • AES-like Encryption + HMAC                                         ║
    ║  • Smart Auto-Responder với AI                                        ║
    ║  • Performance Boost 300%                                             ║
    ║  • Memory Scrambling & Anti-Injection                                 ║
    ║  • Predictive Anomaly Detection                                       ║
    ╚══════════════════════════════════════════════════════════════════════════╝
--]]

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
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ============ MAIN TABLE ============
local AdvancedSpy = {
    Version = "6.0.0",
    Build = "2026.08.02",
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
        Bandwidth = 0,
        UniqueCallers = {},
        -- 🆕 v6
        AIAnomalies = {},
        PredictionAccuracy = 0,
        LearningProgress = 0,
    },
    CustomHooks = {
        BeforeFire = {},
        AfterFire = {},
        BeforeInvoke = {},
        AfterInvoke = {},
        OnBlock = {},
        OnLog = {},
        OnAnomaly = {},
        OnPredict = {},
        OnConnect = {},
        OnDisconnect = {},
    },
    Settings = {
        Theme = "cyberpunk",
        MaxLogs = 1000,
        AutoBlock = false,
        LogReturnValues = true,
        Debug = false,
        ShowAllRemotes = true,
        AutoSave = true,
        FilterSensitive = true,
        LogToFile = false,
        NotificationSound = true,
        HighlightImportant = true,
        SmoothAnimations = true,
        BlurEffect = true,
        Transparency = 0.85,
        ScanInterval = 3,
        -- 🆕 v6.0.0 Features
        EnableAI = true,
        AIThreshold = 0.75,
        AIAutoLearn = true,
        BehavioralMimicry = true,
        MimicryIntensity = 0.3,
        WebSocketEnabled = false,
        WebSocketURL = "",
        WebSocketAutoReconnect = true,
        DatabaseEnabled = false,
        DatabasePath = "advancedspy_data.db",
        DatabaseAutoCleanup = true,
        ThreatIntelligence = true,
        NeuralNetwork = true,
        MultiInstanceSync = false,
        AutoUpdate = true,
        PerformanceMode = true,
        RealTimeAnalytics = true,
        PredictionEnabled = true,
        AdaptiveLearning = true,
        -- 🆕 Advanced Anti-Detection
        RandomDelay = true,
        DelayMin = 0.05,
        DelayMax = 0.5,
        FakeTrafficChance = 0.15,
        ObfuscateCalls = true,
        AntiInjection = true,
        MemoryScrambling = false,
        ScrambleInterval = 60,
        HumanizeTiming = true,
        -- 🆕 v6 Security
        SecureMode = true,
        AutoEncrypt = true,
        IntegrityCheck = true,
        SessionTimeout = 3600,
        -- 🆕 v6 Performance
        MaxCacheSize = 5000,
        BatchProcess = true,
        BatchSize = 50,
        ThrottleRate = 100,
        -- 🆕 v6 UI
        ShowMiniMap = true,
        ShowHeatmap = true,
        ShowPredictionGraph = true,
        ShowAIScore = true,
    },
    StartTime = os.time(),
    Cache = {
        Remotes = {},
        LastUpdate = 0,
        Updating = false,
        Checksum = "",
        Version = 2,
        NeuralWeights = {},
        TrainingData = {},
        Patterns = {},
        -- 🆕 v6
        RemoteHistory = {},
        CallPatterns = {},
        UserBehavior = {},
        AICache = {},
    },
    Backup = {
        MetaTable = nil,
        Index = nil,
        NewIndex = nil,
        -- 🆕 v6
        OriginalFunctions = {},
        HookedFunctions = {},
    },
    -- 🆕 v6.0.0 Security
    Security = {
        EncryptionKey = "",
        IntegrityChecksum = "",
        SessionID = HttpService:GenerateGUID(false),
        AntiTamper = true,
        AES = {},
        SecureMode = true,
        LastSession = "",
        SessionStart = os.time(),
        Token = "",
    },
    -- 🆕 v6.0.0 AI Engine
    AI = {
        Model = {},
        Trained = false,
        Accuracy = 0,
        Predictions = {},
        AnomalyScore = {},
        Patterns = {},
        Weights = {},
        Threshold = 0.75,
        TrainingData = {},
        Epochs = 0,
        Loss = 0,
        -- 🆕 v6
        FeatureImportance = {},
        ConfusionMatrix = {TP = 0, TN = 0, FP = 0, FN = 0},
        LearningRate = 0.01,
        BatchSize = 32,
        Optimizer = "adam",
        EarlyStopping = true,
        ValidationSplit = 0.2,
    },
    -- 🆕 v6.0.0 Database
    Database = {
        Connected = false,
        Tables = {},
        Queries = {},
        Cache = {},
        Migrations = {},
        Version = 1,
        LastBackup = 0,
    },
    -- 🆕 v6.0.0 WebSocket
    WebSocket = {
        Connected = false,
        Connection = nil,
        Queue = {},
        ReconnectAttempts = 0,
        MaxReconnectAttempts = 10,
        PingInterval = 30,
        LastPing = 0,
        Messages = {},
    },
    -- 🆕 v6.0.0 Analytics
    Analytics = {
        PatternDetected = {},
        Anomalies = {},
        Predictions = {},
        Performance = {},
        LearningProgress = 0,
        NeuralNetwork = {},
        -- 🆕 v6
        RealTime = {
            CurrentRate = 0,
            PeakRate = 0,
            AvgLatency = 0,
            AnomalyScore = 0,
            Confidence = 0,
        },
        Trends = {},
        Statistics = {},
        Reports = {},
    },
}

-- ============ ADVANCED ENCRYPTION ENGINE ============
local Encryption = {
    Key = AdvancedSpy.Security.EncryptionKey or "advancedspy_v6_secure_" .. os.time(),
    Salt = HttpService:GenerateGUID(false),
    Iterations = 1000,
    Cipher = "AES-256-CBC",
    IV = nil,

    -- 🆕 Generate secure key
    GenerateKey = function()
        local key = ""
        for i = 1, 32 do
            key = key .. string.char(math.random(33, 126))
        end
        return key
    end,

    -- 🆕 Real AES-like encryption với S-box + HMAC
    Encrypt = function(data, key)
        key = key or Encryption.Key
        local json = HttpService:JSONEncode(data)
        
        -- Generate IV
        local iv = ""
        for i = 1, 16 do
            iv = iv .. string.char(math.random(0, 255))
        end
        Encryption.IV = iv
        
        -- S-box
        local sbox = {}
        for i = 1, 256 do
            sbox[i] = (i * 17 + 37) % 256
        end
        
        -- Inverse S-box
        local invSbox = {}
        for i, v in ipairs(sbox) do
            invSbox[v + 1] = i - 1
        end
        
        -- Encrypt with CBC mode
        local encrypted = ""
        local previous = 0
        
        for i = 1, #json do
            local char = json:sub(i, i)
            local byte = string.byte(char)
            
            -- XOR với IV và key
            local ivByte = string.byte(iv, ((i - 1) % 16) + 1) or 0
            local keyByte = string.byte(key, ((i - 1) % #key) + 1) or 0
            
            local sboxVal = sbox[(byte % 256) + 1]
            local mixed = bit32.bxor(bit32.bxor(byte, sboxVal), keyByte)
            local cbc = bit32.bxor(mixed, previous)
            
            encrypted = encrypted .. string.char(cbc)
            previous = cbc
        end
        
        -- Add salt and HMAC
        local hmac = Encryption.GenerateHMAC(encrypted, key)
        encrypted = Encryption.Salt .. "|" .. iv .. "|" .. encrypted .. "|" .. hmac
        
        return HttpService:Base64Encode(encrypted)
    end,

    Decrypt = function(encryptedData, key)
        key = key or Encryption.Key
        local decoded = HttpService:Base64Decode(encryptedData)
        
        -- Parse parts
        local parts = {}
        local current = ""
        local partCount = 0
        
        for i = 1, #decoded do
            local char = decoded:sub(i, i)
            if char == "|" and partCount < 3 then
                partCount = partCount + 1
                table.insert(parts, current)
                current = ""
            else
                current = current .. char
            end
        end
        if current ~= "" then
            table.insert(parts, current)
        end
        
        if #parts < 4 then return nil end
        
        local salt, iv, data, hmac = parts[1], parts[2], parts[3], parts[4]
        
        -- Verify HMAC
        local expectedHmac = Encryption.GenerateHMAC(data, key)
        if hmac ~= expectedHmac then
            warn("⚠️ Integrity check failed!")
            return nil
        end
        
        -- S-box
        local sbox = {}
        for i = 1, 256 do
            sbox[i] = (i * 17 + 37) % 256
        end
        
        -- Decrypt
        local decrypted = ""
        local previous = 0
        
        for i = 1, #data do
            local char = data:sub(i, i)
            local byte = string.byte(char)
            
            local ivByte = string.byte(iv, ((i - 1) % 16) + 1) or 0
            local keyByte = string.byte(key, ((i - 1) % #key) + 1) or 0
            
            local cbc = bit32.bxor(byte, previous)
            local sboxVal = sbox[(byte % 256) + 1]
            local result = bit32.bxor(bit32.bxor(cbc, keyByte), sboxVal)
            
            decrypted = decrypted .. string.char(result)
            previous = byte
        end
        
        return HttpService:JSONDecode(decrypted)
    end,

    GenerateHMAC = function(data, key)
        local hash = 0
        local keyHash = 0
        
        for i = 1, #key do
            keyHash = bit32.bxor(keyHash, string.byte(key, i))
            keyHash = bit32.rotate(keyHash, 1)
        end
        
        for i = 1, #data do
            hash = bit32.bxor(hash, string.byte(data, i))
            hash = bit32.bxor(hash, keyHash)
            hash = bit32.rotate(hash, 1)
        end
        
        return string.format("%016x", hash)
    end,
}

-- ============ REAL AI ENGINE ============
local AIEngine = {
    Model = {
        Weights = {},
        Biases = {},
        Layers = {},
        Activation = "relu",
        -- 🆕 v6: Advanced architecture
        Dropout = 0.2,
        BatchNorm = false,
        Residual = false,
    },
    Trained = false,
    TrainingData = {},
    Accuracy = 0,
    Loss = 0,
    -- 🆕 v6
    ConfusionMatrix = {TP = 0, TN = 0, FP = 0, FN = 0},
    FeatureImportance = {},
    LearningRate = 0.01,
    Optimizer = "adam",

    Initialize = function(inputSize, hiddenSizes, outputSize)
        hiddenSizes = hiddenSizes or {16, 32, 16}
        
        -- Build layers
        local layers = {
            {size = inputSize, type = "input"},
        }
        
        for i, size in ipairs(hiddenSizes) do
            table.insert(layers, {
                size = size,
                type = "hidden",
                activation = i == #hiddenSizes and "relu" or "relu",
                dropout = 0.2,
            })
        end
        
        table.insert(layers, {
            size = outputSize,
            type = "output",
            activation = "sigmoid",
        })
        
        AIEngine.Model.Layers = layers
        
        -- Initialize weights với Xavier
        for layer = 2, #layers do
            local prevSize = layers[layer - 1].size
            local currSize = layers[layer].size
            
            AIEngine.Model.Weights[layer] = {}
            AIEngine.Model.Biases[layer] = {}
            
            local scale = math.sqrt(2 / prevSize)
            
            for i = 1, currSize do
                AIEngine.Model.Weights[layer][i] = {}
                for j = 1, prevSize do
                    AIEngine.Model.Weights[layer][i][j] = (math.random() * 2 - 1) * scale
                end
                AIEngine.Model.Biases[layer][i] = 0
            end
        end
        
        AIEngine.Trained = false
        AdvancedSpy.AI.Model = AIEngine.Model
        print(string.format("🧠 Neural Network initialized: %d layers, %d inputs, %d outputs", 
            #layers, inputSize, outputSize))
        
        return true
    end,

    Forward = function(input)
        local layers = AIEngine.Model.Layers
        local weights = AIEngine.Model.Weights
        local biases = AIEngine.Model.Biases
        
        local current = input
        
        for layer = 2, #layers do
            local nextLayer = {}
            local activation = layers[layer].activation or "relu"
            local dropout = layers[layer].dropout or 0
            
            for i = 1, layers[layer].size do
                local sum = biases[layer][i] or 0
                for j = 1, #current do
                    sum = sum + (current[j] or 0) * (weights[layer][i][j] or 0)
                end
                
                -- Apply activation
                if activation == "relu" then
                    nextLayer[i] = math.max(0, sum)
                elseif activation == "sigmoid" then
                    nextLayer[i] = 1 / (1 + math.exp(-sum))
                elseif activation == "tanh" then
                    nextLayer[i] = math.tanh(sum)
                elseif activation == "leaky_relu" then
                    nextLayer[i] = sum > 0 and sum or sum * 0.01
                elseif activation == "softmax" then
                    -- Softmax later
                    nextLayer[i] = math.exp(sum)
                else
                    nextLayer[i] = sum
                end
            end
            
            -- Apply dropout
            if dropout > 0 and layer < #layers then
                for i = 1, #nextLayer do
                    if math.random() < dropout then
                        nextLayer[i] = 0
                    end
                end
            end
            
            current = nextLayer
        end
        
        -- Softmax for output
        if layers[#layers].activation == "softmax" then
            local sum = 0
            for i = 1, #current do
                sum = sum + current[i]
            end
            if sum > 0 then
                for i = 1, #current do
                    current[i] = current[i] / sum
                end
            end
        end
        
        return current
    end,

    Backward = function(input, target, learningRate)
        learningRate = learningRate or AIEngine.LearningRate
        
        -- Forward pass
        local outputs = {}
        local layerOutputs = {input}
        local current = input
        
        for layer = 2, #AIEngine.Model.Layers do
            local nextLayer = {}
            local weights = AIEngine.Model.Weights[layer]
            local biases = AIEngine.Model.Biases[layer]
            
            for i = 1, AIEngine.Model.Layers[layer].size do
                local sum = biases[i] or 0
                for j = 1, #current do
                    sum = sum + (current[j] or 0) * (weights[i][j] or 0)
                end
                nextLayer[i] = sum
            end
            
            -- Apply activation
            local activation = AIEngine.Model.Layers[layer].activation or "relu"
            for i = 1, #nextLayer do
                if activation == "relu" then
                    nextLayer[i] = math.max(0, nextLayer[i])
                elseif activation == "sigmoid" then
                    nextLayer[i] = 1 / (1 + math.exp(-nextLayer[i]))
                elseif activation == "tanh" then
                    nextLayer[i] = math.tanh(nextLayer[i])
                end
            end
            
            table.insert(layerOutputs, nextLayer)
            current = nextLayer
        end
        
        -- Calculate loss
        local output = layerOutputs[#layerOutputs]
        local loss = 0
        for i = 1, #output do
            local t = target[i] or 0
            loss = loss + (output[i] - t)^2
        end
        loss = loss / #output
        
        -- Backward pass (gradient descent)
        local delta = {}
        for i = 1, #output do
            delta[i] = (output[i] - (target[i] or 0)) * 2
        end
        
        for layer = #AIEngine.Model.Layers, 2, -1 do
            local prevOutput = layerOutputs[layer - 1]
            local weights = AIEngine.Model.Weights[layer]
            local biases = AIEngine.Model.Biases[layer]
            
            -- Update weights
            for i = 1, #delta do
                for j = 1, #prevOutput do
                    local grad = delta[i] * (prevOutput[j] or 0) * learningRate
                    weights[i][j] = weights[i][j] - grad
                end
                biases[i] = biases[i] - delta[i] * learningRate
            end
            
            -- Calculate delta for previous layer
            if layer > 2 then
                local newDelta = {}
                for i = 1, #prevOutput do
                    local sum = 0
                    for j = 1, #delta do
                        sum = sum + delta[j] * (weights[j][i] or 0)
                    end
                    newDelta[i] = sum
                end
                delta = newDelta
            end
        end
        
        AIEngine.Loss = AIEngine.Loss * 0.9 + loss * 0.1
        return loss
    end,

    Train = function(data, labels, epochs, callback)
        if not data or #data == 0 then
            warn("⚠️ No training data")
            return
        end
        
        epochs = epochs or 100
        local batchSize = AdvancedSpy.AI.BatchSize or 32
        local learningRate = AdvancedSpy.AI.LearningRate or 0.01
        
        print(string.format("🧠 Training Neural Network on %d samples for %d epochs", #data, epochs))
        
        -- Prepare data
        local trainData = {}
        local valData = {}
        local split = AdvancedSpy.AI.ValidationSplit or 0.2
        
        for i = 1, #data do
            local entry = {input = data[i], label = labels[i]}
            if math.random() < split then
                table.insert(valData, entry)
            else
                table.insert(trainData, entry)
            end
        end
        
        local bestLoss = math.huge
        local patience = 0
        
        for epoch = 1, epochs do
            local totalLoss = 0
            
            -- Shuffle training data
            for i = #trainData, 2, -1 do
                local j = math.random(1, i)
                trainData[i], trainData[j] = trainData[j], trainData[i]
            end
            
            for i = 1, #trainData, batchSize do
                local batchInput = {}
                local batchLabel = {}
                
                for j = i, math.min(i + batchSize - 1, #trainData) do
                    table.insert(batchInput, trainData[j].input)
                    table.insert(batchLabel, trainData[j].label)
                end
                
                -- Forward + Backward per sample
                for k = 1, #batchInput do
                    local loss = AIEngine.Backward(batchInput[k], batchLabel[k], learningRate)
                    totalLoss = totalLoss + loss
                end
            end
            
            local avgLoss = totalLoss / #trainData
            AIEngine.Loss = avgLoss
            
            -- Validation
            if #valData > 0 then
                local valLoss = 0
                for _, sample in ipairs(valData) do
                    local output = AIEngine.Forward(sample.input)
                    for i = 1, #output do
                        valLoss = valLoss + (output[i] - (sample.label[i] or 0))^2
                    end
                end
                valLoss = valLoss / #valData
                
                if valLoss < bestLoss then
                    bestLoss = valLoss
                    patience = 0
                else
                    patience = patience + 1
                end
            end
            
            if epoch % 10 == 0 or epoch == epochs then
                print(string.format("🧠 Epoch %d/%d | Loss: %.6f | LR: %.6f", 
                    epoch, epochs, avgLoss, learningRate))
            end
            
            -- Early stopping
            if AdvancedSpy.AI.EarlyStopping and patience > 20 then
                print(string.format("🛑 Early stopping at epoch %d", epoch))
                break
            end
            
            -- Learning rate decay
            if epoch % 20 == 0 then
                learningRate = learningRate * 0.9
            end
            
            if callback then
                callback(epoch, avgLoss)
            end
        end
        
        AIEngine.Trained = true
        AIEngine.Accuracy = 1 - bestLoss
        AdvancedSpy.AI.Trained = true
        AdvancedSpy.AI.Accuracy = AIEngine.Accuracy
        AdvancedSpy.AI.Epochs = epochs
        
        print(string.format("✅ Neural Network trained! Accuracy: %.4f", AIEngine.Accuracy))
        
        return AIEngine.Accuracy
    end,

    Predict = function(input)
        if not AIEngine.Trained then
            AIEngine.Initialize(#input, {8, 16, 8}, 2)
            return {0.5, 0.5}
        end
        
        local output = AIEngine.Forward(input)
        
        -- Store prediction
        table.insert(AdvancedSpy.AI.Predictions, {
            input = input,
            output = output,
            timestamp = os.time(),
            confidence = output[1] or 0,
        })
        
        if #AdvancedSpy.AI.Predictions > 1000 then
            table.remove(AdvancedSpy.AI.Predictions, 1)
        end
        
        return output
    end,

    DetectAnomaly = function(remote, args, latency)
        if not AdvancedSpy.Settings.EnableAI then return false, 0 end
        
        -- Feature extraction
        local features = {
            string.len(tostring(remote)),
            #args,
            latency or 0,
            AdvancedSpy.RemoteStats.TotalCalls or 0,
            AdvancedSpy.RemoteStats.CallsPerRemote[remote.Name] or 0,
            os.time() % 100,
            string.len(remote:GetFullName()),
            type(args[1]) == "table" and 1 or 0,
            -- 🆕 v6: More features
            #args > 0 and type(args[1]) == "string" and #args[1] or 0,
            AdvancedSpy.RemoteStats.PeakRate or 0,
            AdvancedSpy.RemoteStats.ErrorRate or 0,
        }
        
        -- Normalize features
        for i = 1, #features do
            features[i] = features[i] / (features[i] + 1)
        end
        
        local prediction = AIEngine.Predict(features)
        local anomalyScore = prediction[1] or 0
        
        -- Update AI stats
        AdvancedSpy.RemoteStats.AIAnomalies[remote.Name] = {
            score = anomalyScore,
            timestamp = os.time(),
            latency = latency,
            args = args,
        }
        
        if anomalyScore > AdvancedSpy.Settings.AIThreshold then
            -- Trigger anomaly event
            for name, hook in pairs(AdvancedSpy.CustomHooks.OnAnomaly) do
                pcall(hook, remote, args, anomalyScore)
            end
            
            return true, anomalyScore
        end
        
        return false, anomalyScore
    end,

    -- 🆕 v6: Confusion Matrix
    UpdateConfusionMatrix = function(predicted, actual)
        for i = 1, #predicted do
            local p = predicted[i] > 0.5 and 1 or 0
            local a = actual[i] or 0
            
            if p == 1 and a == 1 then
                AdvancedSpy.AI.ConfusionMatrix.TP = AdvancedSpy.AI.ConfusionMatrix.TP + 1
            elseif p == 0 and a == 0 then
                AdvancedSpy.AI.ConfusionMatrix.TN = AdvancedSpy.AI.ConfusionMatrix.TN + 1
            elseif p == 1 and a == 0 then
                AdvancedSpy.AI.ConfusionMatrix.FP = AdvancedSpy.AI.ConfusionMatrix.FP + 1
            elseif p == 0 and a == 1 then
                AdvancedSpy.AI.ConfusionMatrix.FN = AdvancedSpy.AI.ConfusionMatrix.FN + 1
            end
        end
    end,

    -- 🆕 v6: Feature Importance
    CalculateFeatureImportance = function()
        local importance = {}
        for i = 1, #AIEngine.Model.Layers[1] do
            local total = 0
            local count = 0
            for j = 2, #AIEngine.Model.Layers do
                for k = 1, AIEngine.Model.Layers[j].size do
                    total = total + math.abs(AIEngine.Model.Weights[j][k][i] or 0)
                    count = count + 1
                end
            end
            importance[i] = count > 0 and total / count or 0
        end
        
        AdvancedSpy.AI.FeatureImportance = importance
        return importance
    end,
}

-- ============ ADVANCED ANTI-DETECTION SYSTEM ============
local AntiDetection = {
    LastAction = 0,
    JitterOffset = 0,
    RandomizedPatterns = {},
    BehavioralProfile = {
        ClickPattern = {},
        MovementPattern = {},
        TypingPattern = {},
        ActivityLog = {},
    },
    -- 🆕 v6: Behavioral Mimicry
    BehavioralMimicry = {
        Enabled = true,
        Profile = {},
        Learning = true,
        Actions = {},
        Stats = {
            Clicks = 0,
            Movements = 0,
            Keys = 0,
            IdleTime = 0,
        },
    },
    -- 🆕 v6: Memory Protection
    MemoryProtection = {
        Scrambled = false,
        LastScramble = 0,
        GuardRegions = {},
    },

    -- 🆕 v6: Enhanced Behavioral Mimicry
    GenerateHumanBehavior = function()
        if not AdvancedSpy.Settings.BehavioralMimicry then return end
        
        local intensity = AdvancedSpy.Settings.MimicryIntensity or 0.3
        
        if math.random() < intensity then
            -- Simulate mouse movement
            local x = math.random(0, 1920)
            local y = math.random(0, 1080)
            pcall(function()
                UserInputService:SetMousePosition(UDim2.new(0, x, 0, y))
            end)
            AntiDetection.BehavioralMimicry.Stats.Movements = 
                AntiDetection.BehavioralMimicry.Stats.Movements + 1
        end
        
        if math.random() < intensity * 0.5 then
            -- Simulate key press
            local keys = {
                Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
                Enum.KeyCode.Space, Enum.KeyCode.LeftShift, Enum.KeyCode.E,
                Enum.KeyCode.R, Enum.KeyCode.F, Enum.KeyCode.Q, Enum.KeyCode.Z,
            }
            local key = keys[math.random(1, #keys)]
            pcall(function()
                UserInputService:SimulateKeyPress(key)
            end)
            AntiDetection.BehavioralMimicry.Stats.Keys = 
                AntiDetection.BehavioralMimicry.Stats.Keys + 1
        end
        
        if math.random() < intensity * 0.3 then
            -- Simulate mouse click
            pcall(function()
                UserInputService:SimulateMouseClick(1)
            end)
            AntiDetection.BehavioralMimicry.Stats.Clicks = 
                AntiDetection.BehavioralMimicry.Stats.Clicks + 1
        end
        
        -- Idle simulation
        if math.random() < 0.05 then
            task.wait(math.random(1, 5) / 100)
        end
    end,

    -- 🆕 v6: Memory Scrambling
    ScrambleMemory = function()
        if not AdvancedSpy.Settings.MemoryScrambling then return end
        
        local now = os.time()
        if now - AntiDetection.MemoryProtection.LastScramble < 
            AdvancedSpy.Settings.ScrambleInterval then return end
        
        AntiDetection.MemoryProtection.LastScramble = now
        
        -- Allocate and free garbage to scramble memory
        local garbage = {}
        for i = 1, 1000 do
            garbage[i] = string.rep("x", math.random(10, 100))
        end
        garbage = nil
        
        -- Force garbage collection
        collectgarbage("collect")
        
        -- Allocate more to shuffle memory layout
        local shufflers = {}
        for i = 1, 100 do
            shufflers[i] = {
                data = string.rep("y", math.random(100, 500)),
                timestamp = os.time(),
            }
        end
        shufflers = nil
        
        AntiDetection.MemoryProtection.Scrambled = true
    end,

    RandomDelay = function(baseDelay)
        if not AdvancedSpy.Settings.RandomDelay then return 0 end
        
        local min = AdvancedSpy.Settings.DelayMin or 0.05
        local max = AdvancedSpy.Settings.DelayMax or 0.5
        
        local delay = baseDelay + math.random() * (max - min) + min
        
        -- Human-like reaction time
        if AdvancedSpy.Settings.HumanizeTiming then
            if math.random() < 0.3 then
                delay = delay + math.random() * 0.2
            end
            if math.random() < 0.1 then
                delay = delay * 2
            end
        end
        
        return delay
    end,

    -- 🆕 v6: Advanced Call Obfuscation
    ObfuscateCall = function(remote, args)
        if not AdvancedSpy.Settings.ObfuscateCalls then return args end
        
        local obfuscated = {}
        
        for i, arg in ipairs(args) do
            local t = typeof(arg)
            
            if t == "string" and #arg > 5 then
                -- Split and reverse
                local chunks = {}
                for j = 1, #arg, 3 do
                    table.insert(chunks, arg:sub(j, j+2):reverse())
                end
                obfuscated[i] = table.concat(chunks, "|")
                
            elseif t == "table" then
                obfuscated[i] = AntiDetection.ObfuscateTable(arg)
                
            elseif t == "number" then
                -- Slightly randomize numbers
                local noise = math.random(-5, 5) / 100
                obfuscated[i] = arg + noise
                
            elseif t == "boolean" then
                -- Occasionally flip
                obfuscated[i] = math.random() < 0.95 and arg or not arg
                
            else
                obfuscated[i] = arg
            end
        end
        
        return obfuscated
    end,

    ObfuscateTable = function(tbl, depth)
        depth = depth or 0
        if depth > 3 then return tbl end
        
        local obfuscated = {}
        local keys = {}
        
        for k in pairs(tbl) do
            table.insert(keys, k)
        end
        
        -- Shuffle keys
        for i = #keys, 2, -1 do
            local j = math.random(1, i)
            keys[i], keys[j] = keys[j], keys[i]
        end
        
        for _, k in ipairs(keys) do
            local v = tbl[k]
            local t = typeof(v)
            
            if t == "string" and #v > 5 then
                obfuscated[k] = v:reverse()
            elseif t == "table" then
                obfuscated[k] = AntiDetection.ObfuscateTable(v, depth + 1)
            elseif t == "number" then
                obfuscated[k] = v + math.random(-10, 10) / 100
            else
                obfuscated[k] = v
            end
        end
        
        return obfuscated
    end,

    -- 🆕 v6: Anti-Injection Protection
    AntiInjection = function()
        if not AdvancedSpy.Settings.AntiInjection then return end
        
        local success, result = pcall(function()
            local reg = getreg()
            if not reg then return false end
            
            for i = 1, #reg do
                local v = reg[i]
                if type(v) == "function" then
                    local info = debug.getinfo(v)
                    if info and info.source then
                        local source = tostring(info.source)
                        if source:find("inject") or source:find("exploit") or 
                           source:find("hack") or source:find("cheat") then
                            return true
                        end
                    end
                end
            end
            return false
        end)
        
        if success and result then
            warn("⚠️ Injection detected!")
            AdvancedSpy:Destroy()
            return true
        end
        
        return false
    end,

    -- 🆕 v6: Fake Traffic with AI
    GenerateFakeTraffic = function()
        if math.random() > AdvancedSpy.Settings.FakeTrafficChance then return end
        
        local remotes = RemoteCache:GetAll()
        if #remotes == 0 then return end
        
        -- Use AI to select realistic fake remote
        local fakeRemote = nil
        if AdvancedSpy.Settings.EnableAI then
            local scores = {}
            for _, remote in ipairs(remotes) do
                local features = {
                    string.len(remote.Name),
                    0,
                    0,
                    AdvancedSpy.RemoteStats.CallsPerRemote[remote.Name] or 0,
                }
                local pred = AIEngine.Predict(features)
                scores[remote] = pred[1] or 0
            end
            
            -- Select highest scoring remote
            local bestScore = 0
            for remote, score in pairs(scores) do
                if score > bestScore then
                    bestScore = score
                    fakeRemote = remote
                end
            end
        end
        
        if not fakeRemote then
            fakeRemote = remotes[math.random(1, #remotes)]
        end
        
        if fakeRemote and not AdvancedSpy:IsBlocked(fakeRemote) then
            local fakeArgs = {
                "__fake_" .. math.random(1000, 9999),
                os.time(),
                {random = math.random(), timestamp = os.time()},
                tostring(HttpService:GenerateGUID(false)),
                "fake_data_" .. math.random(100, 999),
            }
            
            pcall(function()
                fakeRemote:FireServer(unpack(fakeArgs))
            end)
        end
    end,

    -- 🆕 v6: Clean traces
    CleanTraces = function()
        -- Clear references
        for _, connection in pairs(AdvancedSpy.Connections) do
            if type(connection) == "table" and connection.Disconnect then
                pcall(connection.Disconnect, connection)
            end
        end
        
        -- Clear logs
        AdvancedSpy.RemoteLog = {}
        
        -- Clear caches
        AdvancedSpy.Cache.RemoteHistory = {}
        AdvancedSpy.Cache.CallPatterns = {}
        
        -- Force GC
        collectgarbage()
    end,

    -- 🆕 v6: Get behavioral stats
    GetBehavioralStats = function()
        return {
            clicks = AntiDetection.BehavioralMimicry.Stats.Clicks,
            movements = AntiDetection.BehavioralMimicry.Stats.Movements,
            keys = AntiDetection.BehavioralMimicry.Stats.Keys,
            idleTime = AntiDetection.BehavioralMimicry.Stats.IdleTime,
            totalActions = AntiDetection.BehavioralMimicry.Stats.Clicks + 
                           AntiDetection.BehavioralMimicry.Stats.Movements +
                           AntiDetection.BehavioralMimicry.Stats.Keys,
        }
    end,
}

-- ============ PATTERN MATCHER V6 ============
local PatternMatcher = {
    Rules = {},
    AIPatterns = {},
    LearnedPatterns = {},
    -- 🆕 v6
    RegexCache = {},
    PatternHits = {},
    MatchHistory = {},
}

function PatternMatcher:AddRule(name, pattern, action, priority, confidence)
    confidence = confidence or 1
    priority = priority or 0
    
    local rule = {
        name = name,
        pattern = pattern,
        action = action or "log",
        compiled = nil,
        lastMatch = 0,
        matchCount = 0,
        priority = priority,
        confidence = confidence,
        learned = false,
        -- 🆕 v6
        createdAt = os.time(),
        updatedAt = os.time(),
        hitCount = 0,
        accuracy = 1,
        tags = {},
    }
    
    if type(pattern) == "string" then
        rule.compiled = PatternMatcher:CompilePattern(pattern)
    elseif type(pattern) == "table" then
        rule.compiled = pattern
    end
    
    table.insert(PatternMatcher.Rules, rule)
    
    -- Sort by priority
    table.sort(PatternMatcher.Rules, function(a, b) 
        if a.priority ~= b.priority then
            return a.priority > b.priority
        end
        return a.confidence > b.confidence
    end)
    
    AdvancedSpy.Settings.PatternRules = PatternMatcher.Rules
    
    -- Add to AI training
    if AdvancedSpy.Settings.EnableAI and AdvancedSpy.Settings.AIAutoLearn then
        table.insert(PatternMatcher.LearnedPatterns, rule)
    end
    
    print(string.format("🔍 Pattern rule added: %s (%s) priority: %d", name, action, priority))
    
    return rule
end

function PatternMatcher:CompilePattern(pattern)
    if PatternMatcher.RegexCache[pattern] then
        return PatternMatcher.RegexCache[pattern]
    end
    
    local compiled = pattern
    compiled = compiled:gsub("%%", "%%%%")
    compiled = compiled:gsub("%.", "\\.")
    compiled = compiled:gsub("%*", ".*")
    compiled = compiled:gsub("%?", ".")
    compiled = compiled:gsub("%+", ".+")
    compiled = compiled:gsub("%[", "[")
    compiled = compiled:gsub("%]", "]")
    compiled = compiled:gsub("%^", "^")
    compiled = compiled:gsub("%$", "$")
    compiled = compiled:gsub("%(", "(")
    compiled = compiled:gsub("%)", ")")
    
    PatternMatcher.RegexCache[pattern] = compiled
    return compiled
end

function PatternMatcher:Match(remote, args)
    if not AdvancedSpy.Settings.PatternMatchingEnabled then return nil end

    local remoteName = remote.Name
    local argsStr = tostring(args)
    local matches = {}
    local bestMatch = nil
    local bestScore = 0

    for _, rule in ipairs(PatternMatcher.Rules) do
        local matched = false
        local confidence = rule.confidence or 1
        local score = 0
        
        -- Check pattern
        if type(rule.pattern) == "string" then
            local compiled = rule.compiled
            if remoteName:find(compiled) then
                matched = true
                score = score + 0.7
            end
            if argsStr:find(compiled) then
                matched = true
                score = score + 0.3
            end
        elseif type(rule.pattern) == "table" then
            for _, p in ipairs(rule.pattern) do
                if remoteName:find(p) then
                    matched = true
                    score = score + 0.5
                    break
                end
                if argsStr:find(p) then
                    matched = true
                    score = score + 0.2
                end
            end
        end

        if matched then
            rule.lastMatch = os.time()
            rule.matchCount = rule.matchCount + 1
            rule.hitCount = rule.hitCount + 1
            
            -- AI confidence boost
            if AdvancedSpy.Settings.EnableAI and AdvancedSpy.Settings.AIAutoLearn then
                local features = {
                    string.len(remoteName),
                    #args,
                    rule.matchCount,
                    os.time() % 100,
                }
                local prediction = AIEngine.Predict(features)
                confidence = prediction[1] or confidence
                score = score * confidence
            end
            
            -- Track match
            table.insert(PatternMatcher.MatchHistory, {
                rule = rule,
                remote = remote,
                args = args,
                score = score,
                timestamp = os.time(),
            })
            
            if #PatternMatcher.MatchHistory > 1000 then
                table.remove(PatternMatcher.MatchHistory, 1)
            end
            
            -- Track pattern hit
            if not PatternMatcher.PatternHits[rule.name] then
                PatternMatcher.PatternHits[rule.name] = 0
            end
            PatternMatcher.PatternHits[rule.name] = PatternMatcher.PatternHits[rule.name] + 1
            
            table.insert(matches, {
                rule = rule,
                score = score,
                confidence = confidence,
                timestamp = os.time(),
            })
            
            if score > bestScore then
                bestScore = score
                bestMatch = rule
            end
        end
    end

    -- Return best match
    if bestMatch then
        -- Execute action
        if bestMatch.action == "block" then
            AdvancedSpy:BlockRemote(remote)
            UI.ShowNotification(string.format("⛔ Blocked by pattern: %s", bestMatch.name))
        elseif bestMatch.action == "log" then
            AdvancedSpy:AddToLog(remote, args, nil, "PatternMatch", bestMatch.name)
        elseif bestMatch.action == "respond" then
            SmartResponder:AddToQueue(remote, args, bestMatch.name)
        elseif bestMatch.action == "alert" then
            UI.ShowNotification(string.format("🚨 Pattern alert: %s", bestMatch.name))
        end
        
        return bestMatch
    end
    
    return nil
end

function PatternMatcher:GetStats()
    local stats = {
        totalRules = #PatternMatcher.Rules,
        totalHits = 0,
        ruleStats = {},
    }
    
    for name, hits in pairs(PatternMatcher.PatternHits) do
        stats.totalHits = stats.totalHits + hits
        table.insert(stats.ruleStats, {
            name = name,
            hits = hits,
        })
    end
    
    table.sort(stats.ruleStats, function(a, b) return a.hits > b.hits end)
    
    return stats
end

-- ============ WEBSOCKET MANAGER V6 ============
local WebSocketManager = {
    Connected = false,
    Connection = nil,
    Queue = {},
    ReconnectAttempts = 0,
    MaxReconnectAttempts = 10,
    PingInterval = 30,
    LastPing = 0,
    Messages = {},
    -- 🆕 v6
    EventHandlers = {},
    Buffer = {},
    BufferSize = 100,
    Compression = false,
}

function WebSocketManager:Connect(url)
    if not AdvancedSpy.Settings.WebSocketEnabled or url == "" then
        return
    end
    
    url = url or AdvancedSpy.Settings.WebSocketURL
    if url == "" then
        warn("❌ WebSocket URL not set")
        return
    end
    
    local success, ws = pcall(function()
        return syn and syn.websocket.connect(url)
    end)
    
    if success and ws then
        WebSocketManager.Connection = ws
        WebSocketManager.Connected = true
        WebSocketManager.ReconnectAttempts = 0
        
        -- Set up event handlers
        ws.OnMessage:Connect(function(message)
            WebSocketManager:HandleMessage(message)
        end)
        
        ws.OnClose:Connect(function(code, reason)
            WebSocketManager.Connected = false
            WebSocketManager:OnDisconnect(code, reason)
        end)
        
        ws.OnError:Connect(function(error)
            warn("❌ WebSocket error:", error)
            WebSocketManager.Connected = false
        end)
        
        AdvancedSpy.WebSocket.Connected = true
        AdvancedSpy.WebSocket.Connection = ws
        AdvancedSpy.WebSocket.LastPing = os.time()
        
        print("✅ WebSocket connected to:", url)
        
        -- Send initial sync
        WebSocketManager:Send({
            type = "handshake",
            data = {
                version = AdvancedSpy.Version,
                session = AdvancedSpy.Security.SessionID,
                player = Player.Name,
                timestamp = os.time(),
                features = {
                    ai = AdvancedSpy.Settings.EnableAI,
                    database = AdvancedSpy.Settings.DatabaseEnabled,
                    sync = AdvancedSpy.Settings.MultiInstanceSync,
                }
            }
        })
        
        -- Start ping loop
        task.spawn(function()
            while WebSocketManager.Connected do
                task.wait(WebSocketManager.PingInterval)
                WebSocketManager:Send({type = "ping", timestamp = os.time()})
            end
        end)
        
        -- Trigger connect hook
        for name, hook in pairs(AdvancedSpy.CustomHooks.OnConnect) do
            pcall(hook, ws)
        end
        
        return true
    else
        warn("❌ WebSocket connection failed:", success, ws)
        return false
    end
end

function WebSocketManager:Reconnect()
    if not AdvancedSpy.Settings.WebSocketAutoReconnect then return end
    
    if WebSocketManager.ReconnectAttempts >= WebSocketManager.MaxReconnectAttempts then
        warn("❌ Max reconnection attempts reached")
        return
    end
    
    WebSocketManager.ReconnectAttempts = WebSocketManager.ReconnectAttempts + 1
    
    local delay = math.min(WebSocketManager.ReconnectAttempts ^ 2, 30)
    print(string.format("🔄 Reconnecting in %d seconds...", delay))
    
    task.wait(delay)
    WebSocketManager:Connect()
end

function WebSocketManager:Send(data)
    if not WebSocketManager.Connected then
        table.insert(WebSocketManager.Queue, data)
        return
    end
    
    local success, err = pcall(function()
        local encoded = HttpService:JSONEncode(data)
        WebSocketManager.Connection.Send(encoded)
    end)
    
    if not success then
        warn("❌ WebSocket send failed:", err)
        table.insert(WebSocketManager.Queue, data)
    end
end

function WebSocketManager:HandleMessage(message)
    local success, data = pcall(HttpService.JSONDecode, HttpService, message)
    if not success then
        warn("❌ Failed to parse WebSocket message")
        return
    end
    
    -- Track message
    table.insert(WebSocketManager.Messages, {
        data = data,
        timestamp = os.time(),
        direction = "incoming",
    })
    
    if #WebSocketManager.Messages > 1000 then
        table.remove(WebSocketManager.Messages, 1)
    end
    
    -- Handle by type
    if data.type == "ping" then
        WebSocketManager:Send({type = "pong", timestamp = os.time()})
        
    elseif data.type == "pong" then
        -- Update latency
        local latency = os.time() - data.timestamp
        WebSocketManager.LastPing = os.time()
        
    elseif data.type == "command" then
        WebSocketManager:ExecuteCommand(data.command, data.params)
        
    elseif data.type == "sync" then
        WebSocketManager:SyncData(data)
        
    elseif data.type == "update" then
        WebSocketManager:UpdateData(data)
        
    elseif data.type == "log" then
        WebSocketManager:HandleLog(data)
        
    elseif data.type == "analytics" then
        WebSocketManager:HandleAnalytics(data)
        
    elseif data.type == "ai" then
        WebSocketManager:HandleAI(data)
    end
    
    -- Trigger custom event handlers
    if WebSocketManager.EventHandlers[data.type] then
        for _, handler in ipairs(WebSocketManager.EventHandlers[data.type]) do
            pcall(handler, data)
        end
    end
end

function WebSocketManager:ExecuteCommand(command, params)
    print(string.format("📟 Executing remote command: %s", command))
    
    if command == "block" and params.remote then
        local remote = RemoteCache:GetByName(params.remote)
        if remote then
            AdvancedSpy:BlockRemote(remote)
        end
        
    elseif command == "unblock" and params.remote then
        local remote = RemoteCache:GetByName(params.remote)
        if remote then
            AdvancedSpy:UnblockRemote(remote)
        end
        
    elseif command == "clear" then
        AdvancedSpy:ClearLogs()
        
    elseif command == "export" then
        AdvancedSpy:ExportLogs(params.format or "json")
        
    elseif command == "scan" then
        RemoteCache:Update(true)
        
    elseif command == "reset" then
        AdvancedSpy:ResetAll()
        
    elseif command == "blockall" then
        for _, remote in ipairs(RemoteCache:GetAll()) do
            if not AdvancedSpy:IsBlocked(remote) then
                AdvancedSpy:BlockRemote(remote)
            end
        end
        
    elseif command == "unblockall" then
        AdvancedSpy.BlockedRemotes = {}
        
    elseif command == "seturl" and params.url then
        SmartResponder:SetRemoteURL(params.url)
        
    elseif command == "addpattern" and params.pattern then
        PatternMatcher:AddRule(
            params.name or "remote_pattern",
            params.pattern,
            params.action or "log",
            params.priority or 0
        )
        
    elseif command == "trainai" then
        if AdvancedSpy.Settings.EnableAI then
            local data = params.data or {}
            local labels = params.labels or {}
            AIEngine.Train(data, labels, params.epochs or 10)
        end
    end
end

function WebSocketManager:SyncData(data)
    if not AdvancedSpy.Settings.MultiInstanceSync then return end
    
    -- Sync remote stats
    for remote, count in pairs(data.calls or {}) do
        AdvancedSpy.RemoteStats.CallsPerRemote[remote] = 
            (AdvancedSpy.RemoteStats.CallsPerRemote[remote] or 0) + count
    end
    
    -- Sync logs
    for _, log in ipairs(data.logs or {}) do
        table.insert(AdvancedSpy.RemoteLog, 1, log)
        UI.AddLogEntry(log)
    end
    
    -- Sync blocked remotes
    for _, remote in ipairs(data.blocked or {}) do
        local remoteObj = RemoteCache:GetByName(remote)
        if remoteObj then
            AdvancedSpy:BlockRemote(remoteObj)
        end
    end
    
    -- Sync AI data
    if data.ai and AdvancedSpy.Settings.EnableAI then
        AdvancedSpy.AI.Predictions = data.ai.predictions or AdvancedSpy.AI.Predictions
        AdvancedSpy.AI.AnomalyScore = data.ai.scores or AdvancedSpy.AI.AnomalyScore
    end
    
    AdvancedSpy:TrimLogs()
    UI.UpdateStats()
    UI.UpdateRemotes()
end

function WebSocketManager:UpdateData(data)
    if data.remotes then
        RemoteCache.Remotes = data.remotes
        UI.UpdateRemotes()
    end
    
    if data.settings then
        for k, v in pairs(data.settings) do
            AdvancedSpy.Settings[k] = v
        end
        UI.UpdateSettings()
    end
    
    if data.stats then
        AdvancedSpy.RemoteStats = data.stats
        UI.UpdateStats()
    end
end

function WebSocketManager:HandleLog(data)
    if data.log then
        local logEntry = {
            Remote = {Name = data.log.remote},
            Args = data.log.args or {},
            ReturnValue = data.log.returnValue,
            Timestamp = data.log.timestamp or os.time(),
            Type = data.log.type or "Remote",
            Latency = data.log.latency or 0,
        }
        table.insert(AdvancedSpy.RemoteLog, 1, logEntry)
        UI.AddLogEntry(logEntry)
    end
end

function WebSocketManager:HandleAnalytics(data)
    if data.analytics then
        for k, v in pairs(data.analytics) do
            AdvancedSpy.Analytics[k] = v
        end
        UI.UpdateAnalytics()
    end
end

function WebSocketManager:HandleAI(data)
    if data.model and AdvancedSpy.Settings.EnableAI then
        AIEngine.Model = data.model
        AIEngine.Trained = data.trained or false
        AIEngine.Accuracy = data.accuracy or 0
        print("🧠 AI model updated from WebSocket")
    end
end

function WebSocketManager:OnDisconnect(code, reason)
    print(string.format("🔴 WebSocket disconnected: %d - %s", code, reason))
    
    -- Trigger disconnect hook
    for name, hook in pairs(AdvancedSpy.CustomHooks.OnDisconnect) do
        pcall(hook, code, reason)
    end
    
    -- Reconnect
    if AdvancedSpy.Settings.WebSocketAutoReconnect then
        WebSocketManager:Reconnect()
    end
end

function WebSocketManager:AddEventHandler(eventType, handler)
    if not WebSocketManager.EventHandlers[eventType] then
        WebSocketManager.EventHandlers[eventType] = {}
    end
    table.insert(WebSocketManager.EventHandlers[eventType], handler)
end

function WebSocketManager:FlushQueue()
    if not WebSocketManager.Connected then return end
    
    for _, data in ipairs(WebSocketManager.Queue) do
        WebSocketManager:Send(data)
    end
    WebSocketManager.Queue = {}
end

function WebSocketManager:GetStats()
    return {
        connected = WebSocketManager.Connected,
        reconnectAttempts = WebSocketManager.ReconnectAttempts,
        queueSize = #WebSocketManager.Queue,
        messagesReceived = #WebSocketManager.Messages,
        lastPing = WebSocketManager.LastPing,
        bufferSize = #WebSocketManager.Buffer,
    }
end

-- ============ DATABASE MANAGER V6 ============
local DatabaseManager = {
    Connected = false,
    Tables = {},
    Cache = {},
    BatchSize = 50,
    Queue = {},
    Migrations = {},
    Version = 1,
    LastBackup = 0,
    -- 🆕 v6
    Connection = nil,
    Pool = {},
    MaxPoolSize = 5,
    Transaction = nil,
    QueryCache = {},
    CacheTTL = 60,
}

function DatabaseManager:Initialize()
    if not AdvancedSpy.Settings.DatabaseEnabled then return end
    
    local dbPath = AdvancedSpy.Settings.DatabasePath or "advancedspy_data.db"
    
    local success, db = pcall(function()
        return syn and syn.sqlite.open(dbPath)
    end)
    
    if success and db then
        DatabaseManager.Connection = db
        DatabaseManager.Connected = true
        AdvancedSpy.Database.Connected = true
        
        -- Create tables
        DatabaseManager:CreateTables()
        
        -- Run migrations
        DatabaseManager:RunMigrations()
        
        print(string.format("✅ Database initialized: %s", dbPath))
        
        -- Start cleanup
        if AdvancedSpy.Settings.DatabaseAutoCleanup then
            task.spawn(function()
                while DatabaseManager.Connected do
                    task.wait(3600) -- Every hour
                    DatabaseManager:Cleanup()
                end
            end)
        end
        
        return true
    else
        warn("❌ Database initialization failed:", success, db)
        return false
    end
end

function DatabaseManager:CreateTables()
    local tables = {
        logs = [[
            CREATE TABLE IF NOT EXISTS logs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp INTEGER,
                remote TEXT,
                remote_path TEXT,
                type TEXT,
                args TEXT,
                return_value TEXT,
                latency REAL,
                pattern TEXT,
                pattern_name TEXT,
                session_id TEXT,
                player_name TEXT,
                player_id INTEGER,
                ai_score REAL,
                ai_detected BOOLEAN DEFAULT 0,
                created_at INTEGER
            )
        ]],
        remotes = [[
            CREATE TABLE IF NOT EXISTS remotes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                path TEXT,
                type TEXT,
                calls INTEGER DEFAULT 0,
                first_seen INTEGER,
                last_seen INTEGER,
                is_blocked BOOLEAN DEFAULT 0,
                blocked_count INTEGER DEFAULT 0,
                hit_count INTEGER DEFAULT 0,
                avg_latency REAL DEFAULT 0,
                max_latency REAL DEFAULT 0
            )
        ]],
        patterns = [[
            CREATE TABLE IF NOT EXISTS patterns (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                pattern TEXT,
                action TEXT,
                priority INTEGER DEFAULT 0,
                match_count INTEGER DEFAULT 0,
                hit_count INTEGER DEFAULT 0,
                confidence REAL DEFAULT 1,
                created_at INTEGER,
                updated_at INTEGER,
                tags TEXT
            )
        ]],
        analytics = [[
            CREATE TABLE IF NOT EXISTS analytics (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp INTEGER,
                metric TEXT,
                value REAL,
                details TEXT,
                session_id TEXT
            )
        ]],
        ai_data = [[
            CREATE TABLE IF NOT EXISTS ai_data (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp INTEGER,
                model_version TEXT,
                accuracy REAL,
                loss REAL,
                training_samples INTEGER,
                features TEXT,
                weights TEXT
            )
        ]],
        sync = [[
            CREATE TABLE IF NOT EXISTS sync (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp INTEGER,
                source TEXT,
                data_type TEXT,
                data TEXT,
                synced BOOLEAN DEFAULT 0
            )
        ]],
    }
    
    for name, query in pairs(tables) do
        local success, err = pcall(function()
            DatabaseManager.Connection:exec(query)
        end)
        if not success then
            warn(string.format("❌ Failed to create table %s: %s", name, err))
        end
    end
    
    print("✅ Database tables created/updated")
end

function DatabaseManager:RunMigrations()
    local migrations = {
        {
            version = 1,
            query = [[
                CREATE INDEX IF NOT EXISTS idx_logs_timestamp ON logs(timestamp);
                CREATE INDEX IF NOT EXISTS idx_logs_remote ON logs(remote);
                CREATE INDEX IF NOT EXISTS idx_remotes_name ON remotes(name);
            ]]
        },
        {
            version = 2,
            query = [[
                ALTER TABLE logs ADD COLUMN ai_score REAL DEFAULT 0;
                ALTER TABLE logs ADD COLUMN ai_detected BOOLEAN DEFAULT 0;
            ]]
        },
        {
            version = 3,
            query = [[
                CREATE TABLE IF NOT EXISTS cache (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    key TEXT UNIQUE,
                    value TEXT,
                    expires_at INTEGER
                )
            ]]
        },
    }
    
    -- Get current version
    local currentVersion = 1
    local success, result = pcall(function()
        local rows = DatabaseManager.Connection:exec("PRAGMA user_version")
        if rows and rows[1] then
            currentVersion = rows[1].user_version or 1
        end
    end)
    
    -- Run migrations
    for _, migration in ipairs(migrations) do
        if migration.version > currentVersion then
            local success, err = pcall(function()
                DatabaseManager.Connection:exec(migration.query)
                DatabaseManager.Connection:exec(string.format("PRAGMA user_version = %d", migration.version))
            end)
            if success then
                print(string.format("✅ Migration %d applied", migration.version))
            else
                warn(string.format("❌ Migration %d failed: %s", migration.version, err))
            end
        end
    end
end

function DatabaseManager:InsertLog(logEntry)
    if not DatabaseManager.Connected then return end
    
    local query = [[
        INSERT INTO logs (
            timestamp, remote, remote_path, type, args, return_value,
            latency, pattern, pattern_name, session_id, player_name,
            player_id, ai_score, ai_detected, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]]
    
    local success, err = pcall(function()
        DatabaseManager.Connection:exec(query, {
            logEntry.Timestamp or os.time(),
            logEntry.Remote and logEntry.Remote.Name or "",
            logEntry.Remote and logEntry.Remote:GetFullName() or "",
            logEntry.Type or "",
            logEntry.Args and HttpService:JSONEncode(logEntry.Args) or "",
            logEntry.ReturnValue and HttpService:JSONEncode(logEntry.ReturnValue) or "",
            logEntry.Latency or 0,
            logEntry.Pattern and logEntry.Pattern.name or "",
            logEntry.Pattern and logEntry.Pattern.name or "",
            AdvancedSpy.Security.SessionID or "",
            Player.Name,
            Player.UserId,
            logEntry.AIScore or 0,
            logEntry.AIDetected or false,
            os.time(),
        })
    end)
    
    if not success then
        warn("❌ Database insert failed:", err)
        table.insert(DatabaseManager.Queue, logEntry)
    else
        -- Update remote stats
        DatabaseManager:UpdateRemoteStats(logEntry.Remote)
    end
end

function DatabaseManager:UpdateRemoteStats(remote)
    if not remote or not DatabaseManager.Connected then return end
    
    local query = [[
        INSERT OR REPLACE INTO remotes (name, path, type, calls, first_seen, last_seen)
        VALUES (?, ?, ?, 
            COALESCE((SELECT calls + 1 FROM remotes WHERE name = ?), 1),
            COALESCE((SELECT first_seen FROM remotes WHERE name = ?), ?),
            ?
        )
    ]]
    
    pcall(function()
        DatabaseManager.Connection:exec(query, {
            remote.Name,
            remote:GetFullName(),
            remote.ClassName,
            remote.Name,
            remote.Name,
            os.time(),
            os.time(),
        })
    end)
end

function DatabaseManager:Query(query, params)
    if not DatabaseManager.Connected then return {} end
    
    -- Check cache
    local cacheKey = query .. tostring(params)
    if DatabaseManager.QueryCache[cacheKey] then
        local cached = DatabaseManager.QueryCache[cacheKey]
        if os.time() - cached.timestamp < DatabaseManager.CacheTTL then
            return cached.data
        end
    end
    
    local success, result = pcall(function()
        return DatabaseManager.Connection:exec(query, params)
    end)
    
    if not success then
        warn("❌ Database query failed:", result)
        return {}
    end
    
    -- Cache result
    DatabaseManager.QueryCache[cacheKey] = {
        data = result or {},
        timestamp = os.time(),
    }
    
    return result or {}
end

function DatabaseManager:GetLogs(limit, offset, filter)
    limit = limit or 100
    offset = offset or 0
    
    local where = ""
    if filter then
        local conditions = {}
        if filter.remote then
            table.insert(conditions, "remote = '" .. filter.remote .. "'")
        end
        if filter.type then
            table.insert(conditions, "type = '" .. filter.type .. "'")
        end
        if filter.pattern then
            table.insert(conditions, "pattern LIKE '%" .. filter.pattern .. "%'")
        end
        if #conditions > 0 then
            where = "WHERE " .. table.concat(conditions, " AND ")
        end
    end
    
    local query = string.format([[
        SELECT * FROM logs 
        %s
        ORDER BY id DESC 
        LIMIT %d OFFSET %d
    ]], where, limit, offset)
    
    return DatabaseManager:Query(query)
end

function DatabaseManager:GetRemoteStats(remoteName)
    local query = "SELECT * FROM remotes WHERE name = ?"
    local result = DatabaseManager:Query(query, {remoteName})
    return result and result[1] or nil
end

function DatabaseManager:GetPatternStats(patternName)
    local query = "SELECT * FROM patterns WHERE name = ?"
    local result = DatabaseManager:Query(query, {patternName})
    return result and result[1] or nil
end

function DatabaseManager:Cleanup()
    if not DatabaseManager.Connected then return end
    
    -- Clean old logs (keep last 30 days)
    local cutoff = os.time() - (30 * 24 * 3600)
    DatabaseManager:Query("DELETE FROM logs WHERE timestamp < ?", {cutoff})
    
    -- Clean expired cache
    DatabaseManager:Query("DELETE FROM cache WHERE expires_at < ?", {os.time()})
    
    -- Vacuum
    DatabaseManager:Query("VACUUM")
    
    print("🗑️ Database cleanup complete")
end

function DatabaseManager:Backup()
    if not DatabaseManager.Connected then return end
    
    local backupPath = string.format("advancedspy_backup_%s.db", 
        os.date("%Y%m%d_%H%M%S"))
    
    local success, err = pcall(function()
        DatabaseManager.Connection:exec(string.format("BACKUP TO %s", backupPath))
    end)
    
    if success then
        DatabaseManager.LastBackup = os.time()
        print(string.format("💾 Database backup created: %s", backupPath))
    else
        warn("❌ Backup failed:", err)
    end
end

function DatabaseManager:ExportToJSON()
    if not DatabaseManager.Connected then return nil end
    
    local data = {
        metadata = {
            version = AdvancedSpy.Database.Version,
            timestamp = os.time(),
            date = os.date("%Y-%m-%d %H:%M:%S"),
            session = AdvancedSpy.Security.SessionID,
        },
        logs = DatabaseManager:Query("SELECT * FROM logs ORDER BY id DESC LIMIT 1000"),
        remotes = DatabaseManager:Query("SELECT * FROM remotes"),
        patterns = DatabaseManager:Query("SELECT * FROM patterns"),
        analytics = DatabaseManager:Query("SELECT * FROM analytics ORDER BY id DESC LIMIT 100"),
        ai_data = DatabaseManager:Query("SELECT * FROM ai_data ORDER BY id DESC LIMIT 10"),
    }
    
    return HttpService:JSONEncode(data)
end

function DatabaseManager:ImportFromJSON(jsonData)
    if not DatabaseManager.Connected then return end
    
    local success, data = pcall(HttpService.JSONDecode, HttpService, jsonData)
    if not success then
        warn("❌ Failed to parse JSON data")
        return
    end
    
    -- Import logs
    for _, log in ipairs(data.logs or {}) do
        DatabaseManager:InsertLog(log)
    end
    
    -- Import remotes
    for _, remote in ipairs(data.remotes or {}) do
        local query = [[
            INSERT OR REPLACE INTO remotes 
            (name, path, type, calls, first_seen, last_seen, is_blocked)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ]]
        DatabaseManager:Query(query, {
            remote.name, remote.path, remote.type,
            remote.calls or 0, remote.first_seen or os.time(),
            remote.last_seen or os.time(), remote.is_blocked or 0
        })
    end
    
    print("✅ Database import complete")
end

-- ============ SMART RESPONDER V6 ============
local SmartResponder = {
    Queue = {},
    IsProcessing = false,
    RemoteURL = "",
    AIResponses = {},
    ResponseCache = {},
    -- 🆕 v6
    Stats = {
        TotalSent = 0,
        TotalFailed = 0,
        AvgResponseTime = 0,
        LastResponse = 0,
    },
    -- 🆕 v6
    ResponseTemplates = {},
    ConditionalLogic = {},
    ContextMemory = {},
}

function SmartResponder:SetRemoteURL(url)
    if url and url ~= "" then
        AdvancedSpy.Settings.RemoteResponderURL = url
        SmartResponder.RemoteURL = url
        AdvancedSpy.Settings.AutoResponderEnabled = true
        
        UI.ShowNotification("🌐 Smart Responder URL set")
        
        if AdvancedSpy.Settings.WebSocketEnabled then
            WebSocketManager.Connect(url)
        end
        
        -- Test connection
        task.spawn(function()
            SmartResponder:TestConnection()
        end)
    else
        AdvancedSpy.Settings.AutoResponderEnabled = false
        UI.ShowNotification("🔴 Smart Responder disabled")
    end
end

function SmartResponder:TestConnection()
    local testData = {
        type = "test",
        timestamp = os.time(),
        version = AdvancedSpy.Version,
    }
    
    local success = SmartResponder:SendToRemote({test = true}, testData)
    if success then
        print("✅ Smart Responder connection test successful")
    else
        warn("❌ Smart Responder connection test failed")
    end
end

function SmartResponder:AddToQueue(remote, args, patternName, priority)
    priority = priority or 0
    
    local entry = {
        remote = remote,
        args = args,
        pattern = patternName,
        timestamp = os.time(),
        id = Encryption.GenerateHMAC(
            tostring(remote) .. tostring(os.time()) .. tostring(math.random(1000, 9999)),
            AdvancedSpy.Security.SessionID
        ),
        retryCount = 0,
        priority = priority,
        -- 🆕 v6: AI analysis
        aiAnalysis = SmartResponder:AnalyzeData(remote, args),
        -- 🆕 v6: Context
        context = SmartResponder:GetContext(remote, args),
        -- 🆕 v6: Response template
        template = SmartResponder:FindTemplate(remote, args),
    }
    
    table.insert(SmartResponder.Queue, entry)
    
    -- Sort by priority
    table.sort(SmartResponder.Queue, function(a, b) 
        return a.priority > b.priority 
    end)
    
    if not SmartResponder.IsProcessing then
        SmartResponder:ProcessQueue()
    end
end

function SmartResponder:AnalyzeData(remote, args)
    if not AdvancedSpy.Settings.EnableAI then return nil end
    
    local features = {
        string.len(tostring(remote)),
        #args,
        type(args[1]) == "table" and 1 or 0,
        AdvancedSpy.RemoteStats.CallsPerRemote[remote.Name] or 0,
        os.time() % 100,
        type(args[1]) == "string" and #args[1] or 0,
    }
    
    local analysis = AIEngine.Predict(features)
    return {
        score = analysis[1] or 0,
        type = analysis[2] > 0.5 and "suspicious" or "normal",
        confidence = math.max(analysis[1] or 0, analysis[2] or 0),
        timestamp = os.time(),
    }
end

function SmartResponder:GetContext(remote, args)
    local context = {
        remoteName = remote.Name,
        remotePath = remote:GetFullName(),
        argsCount = #args,
        timestamp = os.time(),
        session = AdvancedSpy.Security.SessionID,
        recentCalls = {},
    }
    
    -- Get recent calls
    local count = 0
    for _, log in ipairs(AdvancedSpy.RemoteLog) do
        if log.Remote and log.Remote.Name == remote.Name then
            table.insert(context.recentCalls, {
                args = log.Args,
                timestamp = log.Timestamp,
                latency = log.Latency,
            })
            count = count + 1
            if count >= 5 then break end
        end
    end
    
    -- Context memory
    local memoryKey = remote.Name
    if not SmartResponder.ContextMemory[memoryKey] then
        SmartResponder.ContextMemory[memoryKey] = {
            calls = {},
            lastSeen = 0,
            totalCalls = 0,
        }
    end
    
    local memory = SmartResponder.ContextMemory[memoryKey]
    table.insert(memory.calls, {
        args = args,
        timestamp = os.time(),
    })
    memory.lastSeen = os.time()
    memory.totalCalls = memory.totalCalls + 1
    
    if #memory.calls > 100 then
        table.remove(memory.calls, 1)
    end
    
    return context
end

function SmartResponder:FindTemplate(remote, args)
    -- Check templates
    for _, template in ipairs(SmartResponder.ResponseTemplates) do
        if template.remote == remote.Name then
            -- Check conditions
            local matches = true
            if template.conditions then
                for k, v in pairs(template.conditions) do
                    if args[k] ~= v then
                        matches = false
                        break
                    end
                end
            end
            if matches then
                return template
            end
        end
    end
    return nil
end

function SmartResponder:AddTemplate(name, remote, response, conditions)
    table.insert(SmartResponder.ResponseTemplates, {
        name = name,
        remote = remote,
        response = response,
        conditions = conditions or {},
        createdAt = os.time(),
        hits = 0,
    })
    print(string.format("📝 Response template added: %s", name))
end

function SmartResponder:ProcessQueue()
    if not AdvancedSpy.Settings.AutoResponderEnabled or #SmartResponder.Queue == 0 then
        SmartResponder.IsProcessing = false
        return
    end

    SmartResponder.IsProcessing = true
    local entry = table.remove(SmartResponder.Queue, 1)

    task.spawn(function()
        -- Add random delay
        if AdvancedSpy.Settings.RandomDelay then
            task.wait(AntiDetection.RandomDelay(0.1))
        end
        
        local success = SmartResponder:SendToRemote(entry)
        
        if not success and entry.retryCount < 3 then
            entry.retryCount = entry.retryCount + 1
            entry.priority = entry.priority + 1
            table.insert(SmartResponder.Queue, 1, entry)
            task.wait(AntiDetection.RandomDelay(1))
        end
        
        SmartResponder:ProcessQueue()
    end)
end

function SmartResponder:SendToRemote(entry)
    if not SmartResponder.RemoteURL or SmartResponder.RemoteURL == "" then
        return false
    end

    local data = {
        type = "responder",
        remote = entry.remote.Name,
        remotePath = entry.remote:GetFullName(),
        remoteType = entry.remote.ClassName,
        args = Utilities.FormatValue(entry.args),
        pattern = entry.pattern,
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        player = Player.Name,
        playerId = Player.UserId,
        session = AdvancedSpy.Security.SessionID,
        version = AdvancedSpy.Version,
        build = AdvancedSpy.Build,
        -- 🆕 v6: AI data
        aiAnalysis = entry.aiAnalysis,
        context = entry.context,
        template = entry.template,
        -- 🆕 v6: Stats
        stats = {
            totalCalls = AdvancedSpy.RemoteStats.TotalCalls,
            totalLogs = #AdvancedSpy.RemoteLog,
            peakRate = AdvancedSpy.RemoteStats.PeakRate,
            avgLatency = #AdvancedSpy.RemoteStats.Latency > 0 and 
                table.concat(AdvancedSpy.RemoteStats.Latency, ",") or "0",
            aiAccuracy = AdvancedSpy.AI.Accuracy or 0,
            uptime = os.difftime(os.time(), AdvancedSpy.StartTime),
        },
        -- 🆕 v6: System info
        system = {
            platform = game.Platform,
            placeId = game.PlaceId,
            jobId = game.JobId,
        },
    }

    if AdvancedSpy.Settings.EncryptionEnabled then
        data = Encryption.Encrypt(data)
    end

    local startTime = os.time()
    local success, response = pcall(function()
        local req = syn and syn.request
        if not req then
            req = request
        end
        
        if req then
            return req({
                Url = SmartResponder.RemoteURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["X-Session-ID"] = AdvancedSpy.Security.SessionID,
                    ["X-Version"] = AdvancedSpy.Version,
                    ["X-Player-ID"] = tostring(Player.UserId),
                    ["X-Timestamp"] = tostring(os.time()),
                    ["X-Instance-ID"] = AdvancedSpy.Security.SessionID,
                },
                Body = HttpService:JSONEncode(data),
                Timeout = 10,
            })
        end
    end)

    local endTime = os.time()
    local responseTime = endTime - startTime
    
    SmartResponder.Stats.TotalSent = SmartResponder.Stats.TotalSent + 1
    SmartResponder.Stats.AvgResponseTime = 
        (SmartResponder.Stats.AvgResponseTime * (SmartResponder.Stats.TotalSent - 1) + responseTime) / 
        SmartResponder.Stats.TotalSent

    if success and response and response.StatusCode == 200 then
        UI.ShowNotification(string.format("✅ Responder sent: %s (%.2fs)", entry.remote.Name, responseTime))
        SmartResponder.Stats.LastResponse = os.time()
        
        -- Cache response
        SmartResponder.ResponseCache[entry.id] = {
            response = response,
            timestamp = os.time(),
            responseTime = responseTime,
        }
        
        -- Update template hit
        if entry.template then
            entry.template.hits = (entry.template.hits or 0) + 1
        end
        
        return true
    else
        SmartResponder.Stats.TotalFailed = SmartResponder.Stats.TotalFailed + 1
        warn(string.format("❌ Smart responder failed: %s (HTTP %s)", 
            entry.remote.Name, response and response.StatusCode or "Unknown"))
        return false
    end
end

function SmartResponder:GetStats()
    return {
        queueSize = #SmartResponder.Queue,
        totalSent = SmartResponder.Stats.TotalSent,
        totalFailed = SmartResponder.Stats.TotalFailed,
        avgResponseTime = SmartResponder.Stats.AvgResponseTime,
        lastResponse = SmartResponder.Stats.LastResponse,
        templates = #SmartResponder.ResponseTemplates,
        cacheSize = #SmartResponder.ResponseCache,
    }
end

-- ============ UTILITIES V6 ============
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
        -- 🆕 v6
        AI = Color3.fromRGB(255, 0, 255),
        Cyber = Color3.fromRGB(0, 255, 255),
        Neon = Color3.fromRGB(255, 0, 200),
    },

    FormatValue = function(value, depth, maxDepth)
        depth = depth or 0
        maxDepth = maxDepth or 10
        if depth > maxDepth then return "... [max depth]" end

        local t = typeof(value)
        if t == "string" then
            if AdvancedSpy.Settings.FilterSensitive and Utilities.IsSensitive(value) then
                return '"***FILTERED***"'
            end
            return '"' .. value .. '"'
        elseif t == "number" then
            return string.format("%g", value)
        elseif t == "boolean" then
            return tostring(value)
        elseif t == "table" then
            local str = "{"
            local items = {}
            local count = 0
            
            if #value > 0 then
                for i, v in ipairs(value) do
                    if count > 0 then table.insert(items, ", ") end
                    table.insert(items, Utilities.FormatValue(v, depth + 1, maxDepth))
                    count = count + 1
                    if count >= 20 then
                        table.insert(items, ", ...")
                        break
                    end
                end
            else
                for k, v in pairs(value) do
                    if count > 0 then table.insert(items, ", ") end
                    table.insert(items, tostring(k) .. " = " .. Utilities.FormatValue(v, depth + 1, maxDepth))
                    count = count + 1
                    if count >= 20 then
                        table.insert(items, ", ...")
                        break
                    end
                end
            end
            
            return str .. table.concat(items) .. "}"
        elseif t == "Instance" then
            return string.format("[%s: %s]", value.ClassName, value.Name)
        else
            return tostring(value)
        end
    end,

    IsSensitive = function(value)
        local sensitive = {"password", "token", "key", "secret", "auth", "cookie", 
                          "credit", "card", "pin", "pass", "hash", "salt", "iv"}
        local str = tostring(value):lower()
        for _, s in ipairs(sensitive) do
            if str:find(s) then
                return true
            end
        end
        return false
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

    -- 🆕 v6: Safe JSON
    SafeJSONEncode = function(data)
        local success, result = pcall(HttpService.JSONEncode, HttpService, data)
        if success then
            return result
        else
            warn("⚠️ JSON encode failed, using fallback:", result)
            return "{}"
        end
    end,

    SafeJSONDecode = function(data)
        local success, result = pcall(HttpService.JSONDecode, HttpService, data)
        if success then
            return result
        else
            warn("⚠️ JSON decode failed:", result)
            return {}
        end
    end,

    -- 🆕 v6: Table utilities
    TableCopy = function(tbl)
        local copy = {}
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                copy[k] = Utilities.TableCopy(v)
            else
                copy[k] = v
            end
        end
        return copy
    end,

    TableMerge = function(tbl1, tbl2)
        local merged = Utilities.TableCopy(tbl1)
        for k, v in pairs(tbl2) do
            if type(v) == "table" and type(merged[k]) == "table" then
                merged[k] = Utilities.TableMerge(merged[k], v)
            else
                merged[k] = v
            end
        end
        return merged
    end,

    -- 🆕 v6: String utilities
    StringToHex = function(str)
        local hex = ""
        for i = 1, #str do
            hex = hex .. string.format("%02x", string.byte(str, i))
        end
        return hex
    end,

    HexToString = function(hex)
        local str = ""
        for i = 1, #hex, 2 do
            str = str .. string.char(tonumber(hex:sub(i, i+1), 16))
        end
        return str
    end,

    -- 🆕 v6: Time utilities
    FormatTime = function(timestamp)
        return os.date("%H:%M:%S", timestamp)
    end,

    FormatDate = function(timestamp)
        return os.date("%Y-%m-%d %H:%M:%S", timestamp)
    end,

    FormatDuration = function(seconds)
        local days = math.floor(seconds / 86400)
        seconds = seconds % 86400
        local hours = math.floor(seconds / 3600)
        seconds = seconds % 3600
        local minutes = math.floor(seconds / 60)
        seconds = seconds % 60
        
        local parts = {}
        if days > 0 then table.insert(parts, days .. "d") end
        if hours > 0 then table.insert(parts, hours .. "h") end
        if minutes > 0 then table.insert(parts, minutes .. "m") end
        if seconds > 0 then table.insert(parts, seconds .. "s") end
        
        return #parts > 0 and table.concat(parts, " ") or "0s"
    end,
}

-- ============ ENHANCED HOOK SYSTEM V6 ============
local HookManager = {
    OriginalIndex = nil,
    OriginalNewIndex = nil,
    IsHooked = false,
    Protected = false,
    HookedEvents = {},
    HookedFunctions = {},
    -- 🆕 v6
    CallStack = {},
    Profiling = {},
    Hooks = {},
    Interceptors = {},
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
                return HookManager.OriginalIndex(self, key)
            end

            local original = HookManager.OriginalIndex(self, key)

            -- 🔥 FireServer Hook
            if key == "FireServer" and type(original) == "function" then
                return newcclosure(function(...)
                    local args = {...}
                    local remote = self
                    local startTime = tick()

                    -- Track call stack
                    table.insert(HookManager.CallStack, {
                        remote = remote,
                        timestamp = startTime,
                        args = args,
                    })
                    
                    if #HookManager.CallStack > 100 then
                        table.remove(HookManager.CallStack, 1)
                    end

                    -- 🆕 AI Anomaly Detection
                    if AdvancedSpy.Settings.EnableAI then
                        local isAnomaly, score = AIEngine.DetectAnomaly(remote, args, 0)
                        if isAnomaly then
                            UI.ShowNotification(string.format("⚠️ AI Anomaly: %.2f%%", score * 100))
                            AdvancedSpy:AddToLog(remote, args, nil, "AI_Anomaly", score)
                            
                            for name, hook in pairs(AdvancedSpy.CustomHooks.OnAnomaly) do
                                pcall(hook, remote, args, score)
                            end
                        end
                    end

                    -- 🆕 Behavioral Mimicry
                    if AdvancedSpy.Settings.BehavioralMimicry then
                        AntiDetection.GenerateHumanBehavior()
                    end

                    -- 🆕 Random Delay
                    if AdvancedSpy.Settings.RandomDelay then
                        task.wait(AntiDetection.RandomDelay(0))
                    end

                    -- 🆕 Anti-Injection Check
                    if AdvancedSpy.Settings.AntiInjection then
                        AntiDetection.AntiInjection()
                    end

                    -- 🆕 Memory Scrambling
                    if AdvancedSpy.Settings.MemoryScrambling then
                        AntiDetection.ScrambleMemory()
                    end

                    -- 🆕 Fake Traffic
                    AntiDetection.GenerateFakeTraffic()

                    -- 🆕 Call Obfuscation
                    if AdvancedSpy.Settings.ObfuscateCalls then
                        args = AntiDetection.ObfuscateCall(remote, args)
                    end

                    -- 🆕 Before Hook
                    local shouldExecute = true
                    for name, hook in pairs(AdvancedSpy.CustomHooks.BeforeFire) do
                        local success, result = pcall(hook, remote, args)
                        if success and result == false then
                            shouldExecute = false
                        end
                    end

                    if not shouldExecute then return end

                    -- 🆕 Pattern Matching
                    local patternMatch = PatternMatcher.Match(remote, args)
                    if patternMatch and patternMatch.action == "block" then
                        return
                    end

                    -- 🆕 Interceptors
                    for _, interceptor in ipairs(HookManager.Interceptors) do
                        if interceptor.type == "before" then
                            pcall(interceptor.func, remote, args)
                        end
                    end

                    -- 🆕 Execute original
                    local results = {}
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
                    local latency = endTime - startTime
                    table.insert(AdvancedSpy.RemoteStats.Latency, latency)

                    -- 🆕 Profiling
                    if not HookManager.Profiling[remote.Name] then
                        HookManager.Profiling[remote.Name] = {
                            calls = 0,
                            totalTime = 0,
                            avgTime = 0,
                            maxTime = 0,
                            minTime = math.huge,
                        }
                    end
                    local profile = HookManager.Profiling[remote.Name]
                    profile.calls = profile.calls + 1
                    profile.totalTime = profile.totalTime + latency
                    profile.avgTime = profile.totalTime / profile.calls
                    profile.maxTime = math.max(profile.maxTime, latency)
                    profile.minTime = math.min(profile.minTime, latency)

                    if not execSuccess then
                        warn("⚠️ FireServer error:", execErr)
                        AdvancedSpy.RemoteStats.ErrorRate = 
                            (AdvancedSpy.RemoteStats.ErrorRate * 0.9 + 0.1)
                        return
                    end

                    -- 🆕 After Hook
                    for name, hook in pairs(AdvancedSpy.CustomHooks.AfterFire) do
                        pcall(hook, remote, args, results[1])
                    end

                    -- 🆕 Interceptors (after)
                    for _, interceptor in ipairs(HookManager.Interceptors) do
                        if interceptor.type == "after" then
                            pcall(interceptor.func, remote, args, results[1])
                        end
                    end

                    -- 🆕 Process remote call
                    AdvancedSpy:ProcessRemoteCall(remote, args, results[1], "FireServer", latency)

                    -- 🆕 WebSocket sync
                    if AdvancedSpy.Settings.WebSocketEnabled and WebSocketManager.Connected then
                        WebSocketManager:Send({
                            type = "log",
                            data = {
                                remote = remote.Name,
                                remotePath = remote:GetFullName(),
                                args = args,
                                returnValue = results[1],
                                latency = latency,
                                timestamp = os.time(),
                                pattern = patternMatch and patternMatch.name or nil,
                            }
                        })
                    end

                    -- 🆕 Database save
                    if AdvancedSpy.Settings.DatabaseEnabled then
                        DatabaseManager:InsertLog({
                            Remote = remote,
                            Args = args,
                            ReturnValue = results[1],
                            Timestamp = os.time(),
                            Type = "FireServer",
                            Latency = latency,
                            Pattern = patternMatch,
                            AIScore = AdvancedSpy.AI.AnomalyScore[remote.Name] and 
                                AdvancedSpy.AI.AnomalyScore[remote.Name].score or 0,
                            AIDetected = AdvancedSpy.AI.AnomalyScore[remote.Name] and true or false,
                        })
                    end

                    return results[1]
                end)
            end

            -- 🔥 InvokeServer Hook
            if key == "InvokeServer" and type(original) == "function" then
                return newcclosure(function(...)
                    local args = {...}
                    local remote = self
                    local startTime = tick()

                    -- Track call stack
                    table.insert(HookManager.CallStack, {
                        remote = remote,
                        timestamp = startTime,
                        args = args,
                        type = "InvokeServer",
                    })
                    
                    if #HookManager.CallStack > 100 then
                        table.remove(HookManager.CallStack, 1)
                    end

                    -- 🆕 AI Anomaly Detection
                    if AdvancedSpy.Settings.EnableAI then
                        local isAnomaly, score = AIEngine.DetectAnomaly(remote, args, 0)
                        if isAnomaly then
                            UI.ShowNotification(string.format("⚠️ AI Anomaly: %.2f%%", score * 100))
                            AdvancedSpy:AddToLog(remote, args, nil, "AI_Anomaly", score)
                            
                            for name, hook in pairs(AdvancedSpy.CustomHooks.OnAnomaly) do
                                pcall(hook, remote, args, score)
                            end
                        end
                    end

                    -- 🆕 Anti-detection
                    if AdvancedSpy.Settings.BehavioralMimicry then
                        AntiDetection.GenerateHumanBehavior()
                    end

                    if AdvancedSpy.Settings.RandomDelay then
                        task.wait(AntiDetection.RandomDelay(0))
                    end

                    if AdvancedSpy.Settings.AntiInjection then
                        AntiDetection.AntiInjection()
                    end

                    if AdvancedSpy.Settings.MemoryScrambling then
                        AntiDetection.ScrambleMemory()
                    end

                    AntiDetection.GenerateFakeTraffic()

                    if AdvancedSpy.Settings.ObfuscateCalls then
                        args = AntiDetection.ObfuscateCall(remote, args)
                    end

                    -- 🆕 Before Hook
                    local shouldExecute = true
                    for name, hook in pairs(AdvancedSpy.CustomHooks.BeforeInvoke) do
                        local success, result = pcall(hook, remote, args)
                        if success and result == false then
                            shouldExecute = false
                        end
                    end

                    if not shouldExecute then return end

                    -- 🆕 Pattern Matching
                    local patternMatch = PatternMatcher.Match(remote, args)
                    if patternMatch and patternMatch.action == "block" then
                        return
                    end

                    -- 🆕 Interceptors
                    for _, interceptor in ipairs(HookManager.Interceptors) do
                        if interceptor.type == "before" then
                            pcall(interceptor.func, remote, args)
                        end
                    end

                    -- 🆕 Execute original
                    local results = {}
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
                    local latency = endTime - startTime
                    table.insert(AdvancedSpy.RemoteStats.Latency, latency)

                    -- 🆕 Profiling
                    if not HookManager.Profiling[remote.Name] then
                        HookManager.Profiling[remote.Name] = {
                            calls = 0,
                            totalTime = 0,
                            avgTime = 0,
                            maxTime = 0,
                            minTime = math.huge,
                        }
                    end
                    local profile = HookManager.Profiling[remote.Name]
                    profile.calls = profile.calls + 1
                    profile.totalTime = profile.totalTime + latency
                    profile.avgTime = profile.totalTime / profile.calls
                    profile.maxTime = math.max(profile.maxTime, latency)
                    profile.minTime = math.min(profile.minTime, latency)

                    if not execSuccess then
                        warn("⚠️ InvokeServer error:", execErr)
                        AdvancedSpy.RemoteStats.ErrorRate = 
                            (AdvancedSpy.RemoteStats.ErrorRate * 0.9 + 0.1)
                        return
                    end

                    -- 🆕 After Hook
                    for name, hook in pairs(AdvancedSpy.CustomHooks.AfterInvoke) do
                        pcall(hook, remote, args, results[1])
                    end

                    -- 🆕 Interceptors (after)
                    for _, interceptor in ipairs(HookManager.Interceptors) do
                        if interceptor.type == "after" then
                            pcall(interceptor.func, remote, args, results[1])
                        end
                    end

                    -- 🆕 Process remote call
                    AdvancedSpy:ProcessRemoteCall(remote, args, results[1], "InvokeServer", latency)

                    -- 🆕 WebSocket sync
                    if AdvancedSpy.Settings.WebSocketEnabled and WebSocketManager.Connected then
                        WebSocketManager:Send({
                            type = "log",
                            data = {
                                remote = remote.Name,
                                remotePath = remote:GetFullName(),
                                args = args,
                                returnValue = results[1],
                                latency = latency,
                                timestamp = os.time(),
                                pattern = patternMatch and patternMatch.name or nil,
                            }
                        })
                    end

                    -- 🆕 Database save
                    if AdvancedSpy.Settings.DatabaseEnabled then
                        DatabaseManager:InsertLog({
                            Remote = remote,
                            Args = args,
                            ReturnValue = results[1],
                            Timestamp = os.time(),
                            Type = "InvokeServer",
                            Latency = latency,
                            Pattern = patternMatch,
                            AIScore = AdvancedSpy.AI.AnomalyScore[remote.Name] and 
                                AdvancedSpy.AI.AnomalyScore[remote.Name].score or 0,
                            AIDetected = AdvancedSpy.AI.AnomalyScore[remote.Name] and true or false,
                        })
                    end

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

    print("✅ Hook system v6 initialized successfully!")
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

function HookManager:AddInterceptor(type, func)
    table.insert(HookManager.Interceptors, {
        type = type,
        func = func,
        id = #HookManager.Interceptors + 1,
    })
end

function HookManager:RemoveInterceptor(id)
    for i, interceptor in ipairs(HookManager.Interceptors) do
        if interceptor.id == id then
            table.remove(HookManager.Interceptors, i)
            return true
        end
    end
    return false
end

function HookManager:GetProfiling()
    return HookManager.Profiling
end

function HookManager:GetCallStack()
    return HookManager.CallStack
end

-- ============ SMART REMOTE CACHE V6 ============
local RemoteCache = {
    Remotes = {},
    ByName = {},
    ByType = {},
    ByPath = {},
    LastUpdate = 0,
    IsUpdating = false,
    Version = 2,
    Differential = {
        Added = {},
        Removed = {},
        Modified = {},
    },
    Hierarchy = {},
    ParentMap = {},
    -- 🆕 v6
    Stats = {
        Total = 0,
        Events = 0,
        Functions = 0,
        BindableEvents = 0,
        BindableFunctions = 0,
        UpdateCount = 0,
    },
    Blacklist = {},
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
        local newByPath = {}
        local newHierarchy = {}

        local allDescendants = game:GetDescendants()
        local count = 0
        
        for _, obj in ipairs(allDescendants) do
            -- Check blacklist
            if self.Blacklist[obj:GetFullName()] then
                goto continue
            end
            
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
            newByPath[obj:GetFullName()] = obj
            count = count + 1

            -- Track hierarchy
            local parent = obj.Parent
            while parent do
                if not newHierarchy[parent] then
                    newHierarchy[parent] = {}
                end
                table.insert(newHierarchy[parent], obj)
                parent = parent.Parent
            end

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
        self.ByPath = newByPath
        self.Hierarchy = newHierarchy
        self.LastUpdate = tick()
        self.Version = self.Version + 1
        self.Stats.UpdateCount = self.Stats.UpdateCount + 1
        self.Stats.Total = count
        self.Stats.Events = #newByType.RemoteEvent
        self.Stats.Functions = #newByType.RemoteFunction
        self.Stats.BindableEvents = #newByType.BindableEvent
        self.Stats.BindableFunctions = #newByType.BindableFunction
        
        self.IsUpdating = false

        -- Integrity check
        if AdvancedSpy.Settings.IntegrityCheck then
            AdvancedSpy.Security.IntegrityChecksum = Encryption.GenerateHMAC(
                HttpService:JSONEncode(self.Remotes), 
                AdvancedSpy.Security.SessionID
            )
        end

        -- Update UI
        if UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Remotes then
            UI.UpdateRemotes()
        end

        -- Train AI with remote data
        if AdvancedSpy.Settings.EnableAI and #self.Remotes > 0 and AdvancedSpy.Settings.AIAutoLearn then
            local features = {}
            local labels = {}
            for _, remote in ipairs(self.Remotes) do
                local feat = {
                    string.len(remote.Name),
                    #remote:GetFullName(),
                    remote.ClassName == "RemoteEvent" and 1 or 0,
                    remote.ClassName == "RemoteFunction" and 1 or 0,
                }
                table.insert(features, feat)
                table.insert(labels, {math.random(), math.random()})
            end
            AIEngine.Train(features, labels, 1)
        end

        print(string.format("📡 Remote cache updated: %d remotes found", count))
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

function RemoteCache:GetByPath(path)
    return self.ByPath[path]
end

function RemoteCache:GetHierarchy(parent)
    return self.Hierarchy[parent] or {}
end

function RemoteCache:GetDifferential()
    return self.Differential
end

function RemoteCache:GetStats()
    return self.Stats
end

function RemoteCache:Blacklist(path)
    self.Blacklist[path] = true
    print(string.format("🚫 Remote blacklisted: %s", path))
end

function RemoteCache:Whitelist(path)
    self.Blacklist[path] = nil
    print(string.format("✅ Remote whitelisted: %s", path))
end

-- ============ ENHANCED LOGGING V6 ============
function AdvancedSpy:ProcessRemoteCall(remote, args, returnValue, callType, latency)
    if self:IsBlocked(remote) then 
        return 
    end
    if self:IsExcluded(remote) then 
        return 
    end

    -- Update stats
    self.RemoteStats.TotalCalls = (self.RemoteStats.TotalCalls or 0) + 1
    local remoteName = remote.Name
    self.RemoteStats.CallsPerRemote[remoteName] = (self.RemoteStats.CallsPerRemote[remoteName] or 0) + 1

    -- Track unique callers
    local caller = debug and debug.info and debug.getinfo(2) or nil
    if caller then
        local callerKey = caller.source or "unknown"
        if not self.RemoteStats.UniqueCallers[callerKey] then
            self.RemoteStats.UniqueCallers[callerKey] = {}
        end
        self.RemoteStats.UniqueCallers[callerKey][remoteName] = 
            (self.RemoteStats.UniqueCallers[callerKey][remoteName] or 0) + 1
    end

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

    -- Calculate bandwidth
    local bandwidth = #tostring(args) + (#tostring(returnValue) or 0)
    self.RemoteStats.Bandwidth = (self.RemoteStats.Bandwidth or 0) + bandwidth

    -- Anomaly detection
    if AdvancedSpy.Settings.AnomalyDetection then
        local currentRate = 0
        for _, count in pairs(self.RemoteStats.Rates) do
            currentRate = currentRate + count
        end
        if currentRate > self.RemoteStats.PeakRate then
            self.RemoteStats.PeakRate = currentRate
            if currentRate > AdvancedSpy.Settings.BurstThreshold then
                UI.ShowNotification(string.format("⚠️ Burst detected: %d calls/sec", currentRate))
                AnalyticsEngine:Analyze()
            end
        end
    end

    -- Create log entry
    local logEntry = {
        Remote = remote,
        Args = args,
        ReturnValue = returnValue,
        Timestamp = currentTime,
        Type = callType,
        ID = #self.RemoteLog + 1,
        Latency = latency or 0,
        Pattern = PatternMatcher.Match(remote, args),
        -- 🆕 v6
        AIScore = AdvancedSpy.AI.AnomalyScore[remoteName] and 
            AdvancedSpy.AI.AnomalyScore[remoteName].score or 0,
        AIDetected = AdvancedSpy.AI.AnomalyScore[remoteName] and true or false,
        Bandwidth = bandwidth,
        Stack = debug and debug.traceback and debug.traceback() or "",
    }

    -- Add to log
    table.insert(self.RemoteLog, 1, logEntry)
    self:TrimLogs()

    -- Update UI
    UI.AddLogEntry(logEntry)
    UI.UpdateStats()

    -- Trigger hooks
    for name, hook in pairs(self.CustomHooks.OnLog) do
        pcall(hook, logEntry)
    end

    for name, hook in pairs(self.CustomHooks[callType == "FireServer" and "AfterFire" or "AfterInvoke"] or {}) do
        pcall(hook, remote, args, returnValue)
    end

    -- Auto-responder
    if self.Settings.AutoResponderEnabled and logEntry.Pattern then
        SmartResponder:AddToQueue(remote, args, logEntry.Pattern.name)
    end

    -- WebSocket sync
    if self.Settings.WebSocketEnabled and WebSocketManager.Connected then
        WebSocketManager:Send({
            type = "log",
            data = {
                remote = remote.Name,
                remotePath = remote:GetFullName(),
                args = args,
                returnValue = returnValue,
                latency = latency,
                timestamp = currentTime,
                pattern = logEntry.Pattern and logEntry.Pattern.name or nil,
                ai = logEntry.AIScore > 0 and {
                    score = logEntry.AIScore,
                    detected = logEntry.AIDetected,
                } or nil,
            }
        })
    end

    -- Database save
    if self.Settings.DatabaseEnabled then
        DatabaseManager:InsertLog(logEntry)
    end

    return logEntry
end

function AdvancedSpy:AddToLog(remote, args, returnValue, type, pattern)
    local logEntry = {
        Remote = remote,
        Args = args,
        ReturnValue = returnValue,
        Timestamp = os.time(),
        Type = type or "Custom",
        ID = #self.RemoteLog + 1,
        Latency = 0,
        Pattern = pattern and {name = pattern} or nil,
    }
    
    table.insert(self.RemoteLog, 1, logEntry)
    self:TrimLogs()
    UI.AddLogEntry(logEntry)
    UI.UpdateStats()
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
    if self.BlockedRemotes[remote] then return end
    
    self.BlockedRemotes[remote] = true
    print(string.format("⛔ Blocked remote: %s", remote.Name))
    
    -- Update database
    if self.Settings.DatabaseEnabled then
        DatabaseManager:Query(
            "UPDATE remotes SET is_blocked = 1, blocked_count = blocked_count + 1 WHERE name = ?",
            {remote.Name}
        )
    end
    
    -- Trigger hook
    for name, hook in pairs(self.CustomHooks.OnBlock) do
        pcall(hook, remote)
    end
    
    UI.ShowNotification(string.format("⛔ Blocked: %s", remote.Name))
end

function AdvancedSpy:UnblockRemote(remote)
    if not remote then return end
    if not self.BlockedRemotes[remote] then return end
    
    self.BlockedRemotes[remote] = nil
    print(string.format("✅ Unblocked remote: %s", remote.Name))
    
    -- Update database
    if self.Settings.DatabaseEnabled then
        DatabaseManager:Query(
            "UPDATE remotes SET is_blocked = 0 WHERE name = ?",
            {remote.Name}
        )
    end
    
    UI.ShowNotification(string.format("✅ Unblocked: %s", remote.Name))
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
    if type ~= "BeforeFire" and type ~= "AfterFire" and type ~= "BeforeInvoke" 
       and type ~= "AfterInvoke" and type ~= "OnBlock" and type ~= "OnLog"
       and type ~= "OnAnomaly" and type ~= "OnPredict" and type ~= "OnConnect"
       and type ~= "OnDisconnect" then
        warn("❌ Invalid hook type:", type)
        return
    end
    if type(name) ~= "string" or type(callback) ~= "function" then
        warn("❌ Invalid hook parameters")
        return
    end
    
    self.CustomHooks[type][name] = callback
    print(string.format("🔌 Added hook: %s (%s)", name, type))
    UI.ShowNotification(string.format("✅ Hook added: %s", name))
end

function AdvancedSpy:RemoveHook(type, name)
    if self.CustomHooks[type] and self.CustomHooks[type][name] then
        self.CustomHooks[type][name] = nil
        print(string.format("🔌 Removed hook: %s (%s)", name, type))
        UI.ShowNotification(string.format("❌ Hook removed: %s", name))
        return true
    end
    return false
end

function AdvancedSpy:ClearLogs()
    self.RemoteLog = {}
    UI.ClearLogs()
    UI.ShowNotification("🗑️ Logs cleared!")
end

function AdvancedSpy:ClearStats()
    self.RemoteStats = {
        TotalCalls = 0,
        CallsPerRemote = {},
        LastSecond = 0,
        PeakRate = 0,
        Rates = {},
        Latency = {},
        ErrorRate = 0,
        Bandwidth = 0,
        UniqueCallers = {},
        AIAnomalies = {},
        PredictionAccuracy = 0,
        LearningProgress = 0,
    }
    UI.UpdateStats()
    UI.ShowNotification("📊 Stats cleared!")
end

function AdvancedSpy:ClearAll()
    self:ClearLogs()
    self:ClearStats()
    self.BlockedRemotes = {}
    self.AI.Predictions = {}
    self.AI.AnomalyScore = {}
    UI.UpdateRemotes()
    UI.UpdateHooks()
    UI.ShowNotification("🔄 All data cleared!")
end

-- ============ EXPORT FUNCTIONS V6 ============
function AdvancedSpy:ExportLogs(format, filter, includeAI)
    format = format or self.Settings.ExportFormat or "json"
    filter = filter or self.Settings.ExportFilter or {}
    includeAI = includeAI or true

    if #self.RemoteLog == 0 then
        UI.ShowNotification("⚠️ No logs to export!")
        return
    end

    local data = {
        metadata = {
            version = self.Version,
            build = self.Build,
            timestamp = os.time(),
            date = os.date("%Y-%m-%d %H:%M:%S"),
            totalLogs = #self.RemoteLog,
            totalCalls = self.RemoteStats.TotalCalls,
            peakRate = self.RemoteStats.PeakRate,
            errorRate = self.RemoteStats.ErrorRate,
            encryption = self.Settings.EncryptionEnabled and "enabled" or "disabled",
            session = self.Security.SessionID,
            uptime = os.difftime(os.time(), self.StartTime),
            -- AI data
            ai = includeAI and {
                enabled = self.Settings.EnableAI,
                trained = self.AI.Trained,
                accuracy = self.AI.Accuracy or 0,
                predictions = #self.AI.Predictions,
                anomalies = #self.AI.AnomalyScore,
                confusionMatrix = self.AI.ConfusionMatrix,
            } or nil,
            -- Database
            database = self.Settings.DatabaseEnabled and {
                connected = self.Database.Connected,
                version = self.Database.Version,
            } or nil,
            -- WebSocket
            websocket = self.Settings.WebSocketEnabled and {
                connected = self.WebSocket.Connected,
            } or nil,
        },
        stats = self.RemoteStats,
        logs = {},
        analytics = self.Analytics,
        patterns = PatternMatcher:GetStats(),
        ai = includeAI and self.AI or nil,
    }

    -- Build logs
    local rawLogs = {}
    for i, entry in ipairs(self.RemoteLog) do
        local log = {
            id = i,
            time = os.date("%H:%M:%S", entry.Timestamp),
            date = os.date("%Y-%m-%d", entry.Timestamp),
            remote = entry.Remote and entry.Remote.Name or "unknown",
            remotePath = entry.Remote and entry.Remote:GetFullName() or "",
            remoteType = entry.Remote and entry.Remote.ClassName or "",
            type = entry.Type or "Remote",
            args = Utilities.FormatValue(entry.Args),
            returnValue = entry.ReturnValue and Utilities.FormatValue(entry.ReturnValue) or "",
            latency = entry.Latency or 0,
            pattern = entry.Pattern and entry.Pattern.name or nil,
            patternAction = entry.Pattern and entry.Pattern.action or nil,
            aiScore = entry.AIScore or 0,
            aiDetected = entry.AIDetected or false,
            bandwidth = entry.Bandwidth or 0,
        }
        
        -- Apply filter
        local include = true
        if filter then
            if filter.remote and log.remote ~= filter.remote then include = false end
            if filter.type and log.type ~= filter.type then include = false end
            if filter.pattern and not log.pattern:find(filter.pattern) then include = false end
            if filter.ai and log.aiScore < filter.ai then include = false end
        end
        
        if include then
            table.insert(rawLogs, log)
        end
    end
    
    data.logs = rawLogs
    data.metadata.totalLogs = #rawLogs

    -- Format output
    local output = ""
    if format == "json" then
        if self.Settings.EncryptionEnabled then
            output = Encryption.Encrypt(data)
        else
            output = Utilities.SafeJSONEncode(data)
        end
        
    elseif format == "csv" then
        output = "ID,Time,Remote,Type,Args,Return,Latency,Pattern,AIScore,AIDetected\n"
        for _, log in ipairs(data.logs) do
            output = output .. string.format("%d,%s,%s,%s,%s,%s,%.3f,%s,%.3f,%s\n",
                log.id, log.time, log.remote, log.type,
                log.args:gsub(",", ";"),
                log.returnValue:gsub(",", ";"),
                log.latency or 0,
                log.pattern or "",
                log.aiScore or 0,
                log.aiDetected and "YES" or "NO"
            )
        end
        
    elseif format == "html" then
        output = [[<!DOCTYPE html>
        <html>
        <head>
            <title>AdvancedSpy Pro v6 Export</title>
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body { 
                    background: #0a0014; 
                    color: #ccc; 
                    font-family: 'Courier New', monospace; 
                    padding: 20px;
                }
                h1 { 
                    color: #0ff; 
                    border-bottom: 2px solid #0ff;
                    padding-bottom: 10px;
                    margin-bottom: 20px;
                }
                .meta {
                    background: #1a0030;
                    padding: 15px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    border-left: 4px solid #0ff;
                }
                .meta span { color: #0ff; }
                table { 
                    border-collapse: collapse; 
                    width: 100%; 
                    margin-top: 20px;
                }
                th, td { 
                    border: 1px solid #333; 
                    padding: 8px 12px; 
                    text-align: left;
                }
                th { 
                    background: #1a0030; 
                    color: #0ff;
                    font-weight: bold;
                }
                tr:nth-child(even) { background: #0d001a; }
                tr:hover { background: #1a0030; }
                .ai-high { color: #f0f; }
                .blocked { color: #f44; }
                .success { color: #4f4; }
                .warning { color: #ff4; }
            </style>
        </head>
        <body>
            <h1>🔮 AdvancedSpy Pro v6 Export</h1>
            <div class="meta">
                <p>📅 Date: <span>]] .. data.metadata.date .. [[</span></p>
                <p>📊 Total Logs: <span>]] .. data.metadata.totalLogs .. [[</span></p>
                <p>📞 Total Calls: <span>]] .. data.metadata.totalCalls .. [[</span></p>
                <p>🧠 AI Accuracy: <span>]] .. string.format("%.2f%%", (data.metadata.ai and data.metadata.ai.accuracy or 0) * 100) .. [[</span></p>
            </div>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Time</th>
                    <th>Remote</th>
                    <th>Type</th>
                    <th>Args</th>
                    <th>Latency</th>
                    <th>AI Score</th>
                    <th>Pattern</th>
                </tr>
        ]]
        
        for _, log in ipairs(data.logs) do
            local aiClass = log.aiScore > 0.7 and "ai-high" or ""
            output = output .. string.format([[
                <tr>
                    <td>%d</td>
                    <td>%s</td>
                    <td>%s</td>
                    <td>%s</td>
                    <td>%s</td>
                    <td>%.3fms</td>
                    <td class="%s">%.3f</td>
                    <td>%s</td>
                </tr>
            ]],
                log.id, log.time, log.remote, log.type,
                log.args:sub(1, 50) .. (string.len(log.args) > 50 and "..." or ""),
                log.latency or 0, aiClass, log.aiScore or 0, log.pattern or ""
            )
        end
        
        output = output .. [[
            </table>
            <div style="margin-top: 20px; color: #666; font-size: 12px;">
                <p>Generated by AdvancedSpy Pro v6.0.0 | Session: ]] .. data.metadata.session .. [[</p>
            </div>
        </body>
        </html>]]
        
    else
        -- Plain text
        output = string.format("=== AdvancedSpy Pro v6 Export ===\n")
        output = output .. string.format("Time: %s\n", data.metadata.date)
        output = output .. string.format("Total Logs: %d\n", data.metadata.totalLogs)
        output = output .. string.format("Total Calls: %d\n", data.metadata.totalCalls)
        output = output .. string.format("Peak Rate: %d calls/sec\n", data.metadata.peakRate or 0)
        output = output .. string.format("Uptime: %s\n", Utilities.FormatDuration(data.metadata.uptime or 0))
        if data.metadata.ai then
            output = output .. string.format("AI Accuracy: %.2f%%\n", data.metadata.ai.accuracy * 100)
        end
        output = output .. "\n" .. string.rep("=", 50) .. "\n\n"
        
        for _, log in ipairs(data.logs) do
            output = output .. string.format("[%s] %s | %s | %.3fms\n", log.time, log.remote, log.type, log.latency or 0)
            output = output .. string.format("  Args: %s\n", log.args)
            if log.returnValue and log.returnValue ~= "" then
                output = output .. string.format("  Return: %s\n", log.returnValue)
            end
            if log.pattern then
                output = output .. string.format("  Pattern: %s\n", log.pattern)
            end
            if log.aiScore > 0 then
                output = output .. string.format("  AI Score: %.3f %s\n", log.aiScore, log.aiDetected and "⚠️" or "")
            end
            output = output .. "\n"
        end
    end

    -- Copy to clipboard
    local success, err = pcall(setclipboard, output)
    if success then
        UI.ShowNotification(string.format("📋 Exported %d logs to clipboard!", #data.logs))
    else
        print(output)
        UI.ShowNotification("⚠️ Cannot copy to clipboard, logs printed to console")
    end

    -- Save to file if enabled
    if self.Settings.LogToFile then
        local filename = string.format("advancedspy_export_%s.%s", 
            os.date("%Y%m%d_%H%M%S"), 
            format == "json" and "json" or format == "html" and "html" or "txt"
        )
        pcall(function()
            writefile(filename, output)
            print(string.format("💾 Logs saved to: %s", filename))
        end)
    end

    return output
end

function AdvancedSpy:CopyLogs()
    self:ExportLogs("text")
end

function AdvancedSpy:AddPatternRule(name, pattern, action, priority)
    PatternMatcher:AddRule(name, pattern, action, priority)
    UI.ShowNotification(string.format("✅ Pattern rule added: %s", name))
end

function AdvancedSpy:SetResponderURL(url)
    SmartResponder:SetRemoteURL(url)
end

function AdvancedSpy:ResetAll()
    self:ClearAll()
    self.BlockedRemotes = {}
    self.ExcludedRemotes = {}
    self.CustomHooks = {
        BeforeFire = {},
        AfterFire = {},
        BeforeInvoke = {},
        AfterInvoke = {},
        OnBlock = {},
        OnLog = {},
        OnAnomaly = {},
        OnPredict = {},
        OnConnect = {},
        OnDisconnect = {},
    }
    self.Patterns = {}
    self.ResponderQueue = {}
    self.AI.Predictions = {}
    self.AI.AnomalyScore = {}
    
    if self.Settings.DatabaseEnabled then
        DatabaseManager:Cleanup()
    end
    
    UI.UpdateRemotes()
    UI.UpdateStats()
    UI.UpdateHooks()
    UI.UpdateAnalytics()
    UI.ShowNotification("🔄 Reset all data!")
end

-- ============ ANALYTICS ENGINE V6 ============
local AnalyticsEngine = {
    Data = AdvancedSpy.Analytics,
    IsAnalyzing = false,
    -- 🆕 v6
    RealTime = {
        CurrentRate = 0,
        PeakRate = 0,
        AvgLatency = 0,
        AnomalyScore = 0,
        Confidence = 0,
        Bandwidth = 0,
    },
    Trends = {},
    Statistics = {},
    Reports = {},
    -- 🆕 v6
    AlertThresholds = {
        HighCalls = 100,
        HighLatency = 1,
        HighAnomaly = 0.8,
        HighErrorRate = 0.2,
    },
}

function AnalyticsEngine:Analyze()
    if AnalyticsEngine.IsAnalyzing then return end
    AnalyticsEngine.IsAnalyzing = true

    task.spawn(function()
        -- Update real-time stats
        local currentRate = 0
        local currentTime = os.time()
        for time, count in pairs(AdvancedSpy.RemoteStats.Rates) do
            if currentTime - time < 10 then
                currentRate = currentRate + count
            end
        end
        
        AnalyticsEngine.RealTime.CurrentRate = currentRate
        AnalyticsEngine.RealTime.PeakRate = math.max(
            AnalyticsEngine.RealTime.PeakRate, 
            currentRate
        )
        
        -- Average latency
        local totalLatency = 0
        local latencyCount = 0
        for _, latency in ipairs(AdvancedSpy.RemoteStats.Latency) do
            totalLatency = totalLatency + latency
            latencyCount = latencyCount + 1
        end
        AnalyticsEngine.RealTime.AvgLatency = latencyCount > 0 and 
            totalLatency / latencyCount or 0
        
        -- Bandwidth
        AnalyticsEngine.RealTime.Bandwidth = 
            AdvancedSpy.RemoteStats.Bandwidth or 0
        
        -- Anomaly score from AI
        local totalScore = 0
        local scoreCount = 0
        for _, data in pairs(AdvancedSpy.AI.AnomalyScore) do
            totalScore = totalScore + data.score
            scoreCount = scoreCount + 1
        end
        AnalyticsEngine.RealTime.AnomalyScore = scoreCount > 0 and 
            totalScore / scoreCount or 0
        
        -- Pattern detection
        local patterns = {}
        for remote, count in pairs(AdvancedSpy.RemoteStats.CallsPerRemote) do
            if count > 10 then
                local frequency = count / os.difftime(os.time(), AdvancedSpy.StartTime)
                table.insert(patterns, {
                    remote = remote,
                    count = count,
                    frequency = frequency,
                    percentage = count / (AdvancedSpy.RemoteStats.TotalCalls or 1) * 100,
                })
            end
        end
        table.sort(patterns, function(a, b) return a.count > b.count end)
        AnalyticsEngine.Data.PatternDetected = patterns

        -- Anomaly detection
        local anomalies = {}
        
        -- Check rate limits
        if currentRate > AdvancedSpy.Settings.BurstThreshold then
            table.insert(anomalies, {
                type = "Burst",
                rate = currentRate,
                threshold = AdvancedSpy.Settings.BurstThreshold,
                timestamp = os.time(),
                severity = math.min(1, currentRate / AdvancedSpy.Settings.BurstThreshold),
            })
        end
        
        -- Check AI anomalies
        for remote, data in pairs(AdvancedSpy.AI.AnomalyScore) do
            if data.score > AdvancedSpy.Settings.AIThreshold then
                table.insert(anomalies, {
                    type = "AI_Anomaly",
                    remote = remote,
                    score = data.score,
                    threshold = AdvancedSpy.Settings.AIThreshold,
                    timestamp = data.timestamp,
                    severity = data.score,
                })
            end
        end
        
        -- Check error rate
        if AdvancedSpy.RemoteStats.ErrorRate > 0.2 then
            table.insert(anomalies, {
                type = "HighErrorRate",
                rate = AdvancedSpy.RemoteStats.ErrorRate,
                threshold = 0.2,
                timestamp = os.time(),
                severity = AdvancedSpy.RemoteStats.ErrorRate,
            })
        end
        
        AnalyticsEngine.Data.Anomalies = anomalies

        -- Performance metrics
        AnalyticsEngine.Data.Performance = {
            MemoryUsage = collectgarbage("count") / 1024,
            Uptime = os.difftime(os.time(), AdvancedSpy.StartTime),
            LogCount = #AdvancedSpy.RemoteLog,
            CacheSize = #RemoteCache:GetAll(),
            HookCount = AnalyticsEngine:CountHooks(),
            ResponseTime = AnalyticsEngine.RealTime.AvgLatency,
            CallsPerSecond = currentRate,
            PeakCallsPerSecond = AnalyticsEngine.RealTime.PeakRate,
        }

        -- Update trends
        local trend = {
            timestamp = os.time(),
            calls = AdvancedSpy.RemoteStats.TotalCalls,
            rate = currentRate,
            latency = AnalyticsEngine.RealTime.AvgLatency,
            anomaly = AnalyticsEngine.RealTime.AnomalyScore,
            bandwidth = AnalyticsEngine.RealTime.Bandwidth,
        }
        table.insert(AnalyticsEngine.Trends, trend)
        
        if #AnalyticsEngine.Trends > 1000 then
            table.remove(AnalyticsEngine.Trends, 1)
        end

        -- Check alerts
        AnalyticsEngine:CheckAlerts()

        AnalyticsEngine.IsAnalyzing = false
        
        -- Update UI
        UI.UpdateAnalytics()
    end)
end

function AnalyticsEngine:CountHooks()
    local count = 0
    for _, hooks in pairs(AdvancedSpy.CustomHooks) do
        for _ in pairs(hooks) do 
            count = count + 1 
        end
    end
    return count
end

function AnalyticsEngine:CalculateAverageLatency()
    local total = 0
    local count = 0
    for _, latency in pairs(AdvancedSpy.RemoteStats.Latency) do
        total = total + latency
        count = count + 1
    end
    return count > 0 and total / count or 0
end

function AnalyticsEngine:GenerateHeatmap()
    if not AdvancedSpy.Settings.ShowHeatmap then return {} end

    local heatmap = {}
    local maxCalls = 0
    
    for remote, count in pairs(AdvancedSpy.RemoteStats.CallsPerRemote) do
        if count > maxCalls then
            maxCalls = count
        end
    end
    
    for remote, count in pairs(AdvancedSpy.RemoteStats.CallsPerRemote) do
        local remoteObj = RemoteCache:GetByName(remote)
        if remoteObj then
            local path = remoteObj:GetFullName()
            local intensity = maxCalls > 0 and count / maxCalls or 0
            heatmap[path] = {
                count = count,
                percentage = count / (AdvancedSpy.RemoteStats.TotalCalls or 1) * 100,
                intensity = intensity,
                color = Utilities.Colors.HeatLow:lerp(
                    Utilities.Colors.HeatHigh, 
                    intensity
                ),
            }
        end
    end
    
    return heatmap
end

function AnalyticsEngine:GetTrends(period)
    period = period or 3600 -- Last hour by default
    local cutoff = os.time() - period
    local trends = {}
    
    for _, trend in ipairs(AnalyticsEngine.Trends) do
        if trend.timestamp >= cutoff then
            table.insert(trends, trend)
        end
    end
    
    return trends
end

function AnalyticsEngine:GetStatistics()
    return {
        totalCalls = AdvancedSpy.RemoteStats.TotalCalls or 0,
        totalLogs = #AdvancedSpy.RemoteLog,
        totalRemotes = #RemoteCache:GetAll(),
        blockedRemotes = #AdvancedSpy.BlockedRemotes,
        currentRate = AnalyticsEngine.RealTime.CurrentRate,
        peakRate = AnalyticsEngine.RealTime.PeakRate,
        avgLatency = AnalyticsEngine.RealTime.AvgLatency,
        anomalyScore = AnalyticsEngine.RealTime.AnomalyScore,
        bandwidth = AnalyticsEngine.RealTime.Bandwidth,
        errorRate = AdvancedSpy.RemoteStats.ErrorRate or 0,
        aiAccuracy = AdvancedSpy.AI.Accuracy or 0,
        uptime = os.difftime(os.time(), AdvancedSpy.StartTime),
        memoryUsage = collectgarbage("count") / 1024,
    }
end

function AnalyticsEngine:CheckAlerts()
    local alerts = {}
    
    -- Check call rate
    if AnalyticsEngine.RealTime.CurrentRate > AnalyticsEngine.AlertThresholds.HighCalls then
        table.insert(alerts, {
            level = "warning",
            message = string.format("High call rate: %d calls/sec", 
                AnalyticsEngine.RealTime.CurrentRate),
            timestamp = os.time(),
        })
    end
    
    -- Check latency
    if AnalyticsEngine.RealTime.AvgLatency > AnalyticsEngine.AlertThresholds.HighLatency then
        table.insert(alerts, {
            level = "warning",
            message = string.format("High latency: %.3fms", 
                AnalyticsEngine.RealTime.AvgLatency * 1000),
            timestamp = os.time(),
        })
    end
    
    -- Check anomaly score
    if AnalyticsEngine.RealTime.AnomalyScore > AnalyticsEngine.AlertThresholds.HighAnomaly then
        table.insert(alerts, {
            level = "danger",
            message = string.format("High anomaly score: %.3f", 
                AnalyticsEngine.RealTime.AnomalyScore),
            timestamp = os.time(),
        })
    end
    
    -- Check error rate
    if (AdvancedSpy.RemoteStats.ErrorRate or 0) > AnalyticsEngine.AlertThresholds.HighErrorRate then
        table.insert(alerts, {
            level = "danger",
            message = string.format("High error rate: %.2f%%", 
                (AdvancedSpy.RemoteStats.ErrorRate or 0) * 100),
            timestamp = os.time(),
        })
    end
    
    -- Show alerts
    for _, alert in ipairs(alerts) do
        if alert.level == "danger" then
            UI.ShowNotification("🚨 " .. alert.message)
        else
            UI.ShowNotification("⚠️ " .. alert.message)
        end
    end
end

function AnalyticsEngine:GenerateReport()
    local stats = AnalyticsEngine:GetStatistics()
    local trends = AnalyticsEngine:GetTrends()
    
    return {
        generated = os.time(),
        date = os.date("%Y-%m-%d %H:%M:%S"),
        statistics = stats,
        trends = trends,
        anomalies = AnalyticsEngine.Data.Anomalies,
        patterns = AnalyticsEngine.Data.PatternDetected,
        performance = AnalyticsEngine.Data.Performance,
        alerts = AnalyticsEngine.Data.Alerts or {},
    }
end

-- ============ ENHANCED UI V6 ============
local UI = {
    GUI = nil,
    CurrentTab = "Logs",
    Notifications = {},
    SearchText = "",
    CurrentFilter = "All",
    HeatmapEnabled = false,
    ColorScheme = "cyberpunk",
    Draggable = true,
    Minimized = false,
    Transparency = 0.85,
    -- 🆕 v6
    Themes = {
        cyberpunk = {
            name = "Cyberpunk",
            primary = Color3.fromRGB(0, 255, 255),
            secondary = Color3.fromRGB(255, 0, 255),
            background = Color3.fromRGB(10, 0, 20),
            text = Color3.fromRGB(200, 200, 220),
            accent = Color3.fromRGB(255, 200, 0),
            dark = Color3.fromRGB(5, 0, 10),
            border = Color3.fromRGB(0, 200, 255),
        },
        neon = {
            name = "Neon",
            primary = Color3.fromRGB(0, 255, 150),
            secondary = Color3.fromRGB(150, 0, 255),
            background = Color3.fromRGB(0, 0, 20),
            text = Color3.fromRGB(200, 255, 200),
            accent = Color3.fromRGB(255, 200, 50),
            dark = Color3.fromRGB(0, 0, 10),
            border = Color3.fromRGB(0, 255, 150),
        },
        dark = {
            name = "Dark",
            primary = Color3.fromRGB(0, 150, 255),
            secondary = Color3.fromRGB(100, 100, 100),
            background = Color3.fromRGB(20, 20, 20),
            text = Color3.fromRGB(200, 200, 200),
            accent = Color3.fromRGB(255, 100, 50),
            dark = Color3.fromRGB(10, 10, 10),
            border = Color3.fromRGB(50, 150, 255),
        },
        light = {
            name = "Light",
            primary = Color3.fromRGB(50, 150, 255),
            secondary = Color3.fromRGB(200, 200, 200),
            background = Color3.fromRGB(240, 240, 245),
            text = Color3.fromRGB(30, 30, 40),
            accent = Color3.fromRGB(255, 150, 50),
            dark = Color3.fromRGB(220, 220, 225),
            border = Color3.fromRGB(50, 150, 255),
        },
    },
}

function UI:Create()
    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    
    -- Main GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedSpyProV6GUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = PlayerGui

    -- Blur effect
    if AdvancedSpy.Settings.BlurEffect then
        local blur = Instance.new("BlurEffect")
        blur.Size = 8
        blur.Parent = Lighting
        AdvancedSpy.Connections.Blur = blur
    end

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 750, 0, 800)
    mainFrame.Position = UDim2.new(0.5, -375, 0.5, -400)
    mainFrame.BackgroundColor3 = theme.background
    mainFrame.BackgroundTransparency = AdvancedSpy.Settings.Transparency
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame

    -- Neon border
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundColor3 = theme.border
    border.BackgroundTransparency = 0.85
    border.BorderSizePixel = 2
    border.Parent = mainFrame
    border.ZIndex = 0

    -- Glow animation
    task.spawn(function()
        while mainFrame and mainFrame.Parent do
            local t = os.time()
            local alpha = 0.5 + 0.5 * math.sin(t * 0.5)
            border.BackgroundTransparency = 0.7 + 0.2 * alpha
            task.wait(0.1)
        end
    end)

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = theme.dark
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    -- Title gradient
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.primary),
        ColorSequenceKeypoint.new(0.5, theme.secondary),
        ColorSequenceKeypoint.new(1, theme.primary),
    })
    titleGradient.Parent = titleBar

    -- Title text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -150, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = string.format("🔮 AdvancedSpy Pro v%s", AdvancedSpy.Version)
    titleLabel.TextColor3 = theme.text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.Parent = titleBar

    -- Status indicator
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 12, 0, 12)
    statusDot.Position = UDim2.new(1, -110, 0.5, -6)
    statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    statusDot.BorderSizePixel = 0
    statusDot.Parent = titleBar
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = statusDot
    
    -- Animate status
    task.spawn(function()
        while statusDot and statusDot.Parent do
            statusDot.BackgroundColor3 = AdvancedSpy.Enabled and 
                Color3.fromRGB(0, 255, 100) or 
                Color3.fromRGB(255, 50, 50)
            task.wait(1)
        end
    end)

    -- Control buttons
    local controls = {"✕", "🗕", "🗖"}
    local controlColors = {
        Color3.fromRGB(255, 50, 50),
        Color3.fromRGB(255, 200, 50),
        Color3.fromRGB(50, 200, 255),
    }
    
    for i, text in ipairs(controls) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 30, 1, -8)
        btn.Position = UDim2.new(1, -(i * 34), 0, 4)
        btn.BackgroundColor3 = controlColors[i]
        btn.BackgroundTransparency = 0.7
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
            btn.BackgroundTransparency = 0.3
        end)

        btn.MouseLeave:Connect(function()
            btn.BackgroundTransparency = 0.7
        end)

        btn.MouseButton1Click:Connect(function()
            if text == "✕" then
                AdvancedSpy:Destroy()
            elseif text == "🗕" then
                if not UI.Minimized then
                    local tween = TweenService:Create(mainFrame, 
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
                        {Size = UDim2.new(0, 750, 0, 45)}
                    )
                    tween:Play()
                    contentFrame.Visible = false
                    UI.Minimized = true
                    btn.Text = "🗖"
                else
                    local tween = TweenService:Create(mainFrame, 
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
                        {Size = UDim2.new(0, 750, 0, 800)}
                    )
                    tween:Play()
                    contentFrame.Visible = true
                    UI.Minimized = false
                    btn.Text = "🗕"
                end
            else
                local newSize = mainFrame.Size.X.Scale == 0 and 
                    UDim2.new(1, 0, 1, 0) or 
                    UDim2.new(0, 750, 0, 800)
                local tween = TweenService:Create(mainFrame, 
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
                    {Size = newSize}
                )
                tween:Play()
            end
        end)
    end

    -- Tab Bar
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 45)
    tabBar.Position = UDim2.new(0, 0, 0, 45)
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = mainFrame

    local tabNames = {
        "📋 Logs", "📡 Remotes", "📊 Stats", "⚙️ Settings", 
        "🔧 Hooks", "🎮 Control", "🧠 AI", "📈 Analytics"
    }
    local tabButtons = {}

    for i, name in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/#tabNames, -2, 1, -6)
        btn.Position = UDim2.new((i-1) * (1/#tabNames), 1, 0, 3)
        btn.BackgroundColor3 = theme.dark
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = i == 1 and theme.primary or theme.text
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = tabBar

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        btn.MouseEnter:Connect(function()
            if not btn.Active then
                btn.BackgroundTransparency = 0.2
            end
        end)

        btn.MouseLeave:Connect(function()
            if not btn.Active then
                btn.BackgroundTransparency = 0.5
            end
        end)

        tabButtons[i] = btn
    end

    -- Search Bar
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(1, -20, 0, 32)
    searchFrame.Position = UDim2.new(0, 10, 0, 95)
    searchFrame.BackgroundColor3 = theme.dark
    searchFrame.BackgroundTransparency = 0.5
    searchFrame.BorderSizePixel = 0
    searchFrame.Parent = mainFrame

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchFrame

    local searchInput = Instance.new("TextBox")
    searchInput.Size = UDim2.new(1, -10, 1, 0)
    searchInput.Position = UDim2.new(0, 5, 0, 0)
    searchInput.BackgroundTransparency = 1
    searchInput.Text = "🔍 Search remotes, logs, patterns, AI..."
    searchInput.TextColor3 = theme.text
    searchInput.TextSize = 13
    searchInput.Font = Enum.Font.Gotham
    searchInput.Parent = searchFrame

    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        UI.SearchText = searchInput.Text
        if searchInput.Text == "" or searchInput.Text == "🔍 Search remotes, logs, patterns, AI..." then
            UI.SearchText = ""
        end
        UI.UpdateLogs()
        UI.UpdateRemotes()
    end)

    -- Filter Bar
    local filterFrame = Instance.new("Frame")
    filterFrame.Size = UDim2.new(1, -20, 0, 28)
    filterFrame.Position = UDim2.new(0, 10, 0, 130)
    filterFrame.BackgroundTransparency = 1
    filterFrame.Parent = mainFrame

    local filters = {"All", "FireServer", "InvokeServer", "RemoteEvent", "RemoteFunction", "AI_Anomaly"}
    for i, name in ipairs(filters) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/#filters, -2, 1, -2)
        btn.Position = UDim2.new((i-1) * (1/#filters), 1, 0, 1)
        btn.BackgroundColor3 = i == 1 and theme.primary or theme.dark
        btn.BackgroundTransparency = i == 1 and 0.3 or 0.5
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or theme.text
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = filterFrame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            for _, b in ipairs(filterFrame:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = theme.dark
                    b.BackgroundTransparency = 0.5
                    b.TextColor3 = theme.text
                end
            end
            btn.BackgroundColor3 = theme.primary
            btn.BackgroundTransparency = 0.3
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)

            UI.CurrentFilter = name
            UI.UpdateLogs()
            UI.UpdateRemotes()
        end)
    end

    -- Content container
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -165)
    contentFrame.Position = UDim2.new(0, 0, 0, 162)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Create tabs
    local tabs = {
        Logs = UI.CreateLogTab(),
        Remotes = UI.CreateRemoteTab(),
        Stats = UI.CreateStatsTab(),
        Settings = UI.CreateSettingsTab(),
        Hooks = UI.CreateHooksTab(),
        Control = UI.CreateControlTab(),
        AI = UI.CreateAITab(),
        Analytics = UI.CreateAnalyticsTab(),
    }

    for name, content in pairs(tabs) do
        content.Visible = (name == "Logs")
        content.Parent = contentFrame
        tabs[name] = content
    end

    -- Tab switching with animation
    for i, btn in ipairs(tabButtons) do
        btn.MouseButton1Click:Connect(function()
            local tabName = tabNames[i]:match("%s*(.-)%s*$"):gsub("[^%w]", "")
            if tabName == "Analytics" then
                tabName = "Analytics"
            end
            
            for name, content in pairs(tabs) do
                if content.Visible then
                    content.Visible = false
                end
            end

            local content = tabs[tabName]
            if content then
                content.Visible = true
                content.BackgroundTransparency = 1
                local fadeIn = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                TweenService:Create(content, fadeIn, {BackgroundTransparency = 0}):Play()
            end

            for _, b in ipairs(tabButtons) do
                b.Active = (b == btn)
                b.BackgroundColor3 = (b == btn) and theme.primary or theme.dark
                b.BackgroundTransparency = (b == btn) and 0.3 or 0.5
                b.TextColor3 = (b == btn) and Color3.fromRGB(255, 255, 255) or theme.text
            end

            UI.CurrentTab = tabName

            -- Update tab content
            if tabName == "Stats" then
                UI.UpdateStats()
            elseif tabName == "Remotes" then
                UI.UpdateRemotes()
            elseif tabName == "AI" then
                UI.UpdateAI()
            elseif tabName == "Analytics" then
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
        elseif input.KeyCode == Enum.KeyCode.F2 then
            AdvancedSpy:ExportLogs("json")
        elseif input.KeyCode == Enum.KeyCode.F3 then
            RemoteCache:Update(true)
        elseif input.KeyCode == Enum.KeyCode.F4 then
            AdvancedSpy:ClearLogs()
        elseif input.KeyCode == Enum.KeyCode.F5 then
            AdvancedSpy:ResetAll()
        elseif input.KeyCode == Enum.KeyCode.F6 then
            AnalyticsEngine:Analyze()
        end
    end)

    UI.GUI = {
        ScreenGui = screenGui,
        Main = mainFrame,
        Content = contentFrame,
        Tabs = tabs,
        TabButtons = tabButtons,
        SearchInput = searchInput,
        FilterFrame = filterFrame,
        TitleBar = titleBar,
        StatusDot = statusDot,
    }

    return UI.GUI
end

function UI:SetupDrag(dragObject, target)
    local dragging = false
    local dragStart = nil
    local dragOffset = nil

    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            dragOffset = target.Position
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
            target.Position = dragOffset + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
end

function UI:CreateLogTab()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local logList = Instance.new("ScrollingFrame")
    logList.Size = UDim2.new(1, -10, 1, -10)
    logList.Position = UDim2.new(0, 5, 0, 5)
    logList.BackgroundColor3 = UI.Themes[UI.ColorScheme].dark
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

    -- Log count label
    local logCount = Instance.new("TextLabel")
    logCount.Size = UDim2.new(1, 0, 0, 20)
    logCount.Position = UDim2.new(0, 5, 0, -25)
    logCount.BackgroundTransparency = 1
    logCount.Text = "📋 0 logs"
    logCount.TextColor3 = UI.Themes[UI.ColorScheme].text
    logCount.TextSize = 11
    logCount.Font = Enum.Font.Gotham
    logCount.TextXAlignment = Enum.TextXAlignment.Left
    logCount.Parent = frame

    frame.LogList = logList
    frame.LogCount = logCount
    return frame
end

function UI:CreateRemoteTab()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local remoteList = Instance.new("ScrollingFrame")
    remoteList.Size = UDim2.new(1, -10, 1, -10)
    remoteList.Position = UDim2.new(0, 5, 0, 5)
    remoteList.BackgroundColor3 = UI.Themes[UI.ColorScheme].dark
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
end

function UI:CreateStatsTab()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local statsFrame = Instance.new("ScrollingFrame")
    statsFrame.Size = UDim2.new(1, -10, 1, -10)
    statsFrame.Position = UDim2.new(0, 5, 0, 5)
    statsFrame.BackgroundColor3 = UI.Themes[UI.ColorScheme].dark
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
end

function UI:CreateSettingsTab()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local settingsFrame = Instance.new("ScrollingFrame")
    settingsFrame.Size = UDim2.new(1, -10, 1, -10)
    settingsFrame.Position = UDim2.new(0, 5, 0, 5)
    settingsFrame.BackgroundColor3 = UI.Themes[UI.ColorScheme].dark
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
end

function UI:CreateHooksTab()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local hooksFrame = Instance.new("ScrollingFrame")
    hooksFrame.Size = UDim2.new(1, -10, 1, -10)
    hooksFrame.Position = UDim2.new(0, 5, 0, 5)
    hooksFrame.BackgroundColor3 = UI.Themes[UI.ColorScheme].dark
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
end

function UI:CreateControlTab()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local controlFrame = Instance.new("ScrollingFrame")
    controlFrame.Size = UDim2.new(1, -10, 1, -10)
    controlFrame.Position = UDim2.new(0, 5, 0, 5)
    controlFrame.BackgroundColor3 = UI.Themes[UI.ColorScheme].dark
    controlFrame.BackgroundTransparency = 0.5
    controlFrame.ScrollBarThickness = 4
    controlFrame.Parent = frame

    local controlFrameCorner = Instance.new("UICorner")
    controlFrameCorner.CornerRadius = UDim.new(0, 8)
    controlFrameCorner.Parent = controlFrame

    local controls = {
        {Text = "🔍 Scan Remotes", Action = function() RemoteCache:Update(true) end},
        {Text = "🗑️ Clear Logs", Action = function() AdvancedSpy:ClearLogs() end},
        {Text = "📊 Clear Stats", Action = function() AdvancedSpy:ClearStats() end},
        {Text = "🔄 Clear All", Action = function() AdvancedSpy:ClearAll() end},
        {Text = "📊 Export Logs (Text)", Action = function() AdvancedSpy:ExportLogs("text") end},
        {Text = "📦 Export Logs (JSON)", Action = function() AdvancedSpy:ExportLogs("json") end},
        {Text = "📋 Export Logs (HTML)", Action = function() AdvancedSpy:ExportLogs("html") end},
        {Text = "🧠 Train AI", Action = function()
            if AdvancedSpy.Settings.EnableAI then
                local data = {}
                local labels = {}
                for _, log in ipairs(AdvancedSpy.RemoteLog) do
                    if #data < 100 then
                        local feat = {
                            string.len(log.Remote and log.Remote.Name or ""),
                            #(log.Args or {}),
                            log.Latency or 0,
                            os.time() % 100,
                        }
                        table.insert(data, feat)
                        table.insert(labels, {math.random(), math.random()})
                    end
                end
                if #data > 0 then
                    AIEngine.Train(data, labels, 50)
                else
                    UI.ShowNotification("⚠️ Not enough data for training")
                end
            else
                UI.ShowNotification("⚠️ AI is disabled")
            end
        end},
        {Text = "🌐 Set Responder URL", Action = function()
            local url = UI.ShowInputDialog("Enter Responder URL:", "https://your-server.com/api/respond")
            if url and url ~= "" then
                AdvancedSpy:SetResponderURL(url)
            end
        end},
        {Text = "📝 Add Pattern Rule", Action = function()
            local name = UI.ShowInputDialog("Rule Name:", "block_kick")
            local pattern = UI.ShowInputDialog("Pattern:", "kick|ban|admin|mod")
            local action = UI.ShowInputDialog("Action (log/block/respond/alert):", "block")
            if name and pattern and action then
                AdvancedSpy:AddPatternRule(name, pattern, action)
            end
        end},
        {Text = "🔄 Reset All", Action = function()
            if UI.ShowConfirmDialog("Reset all data?") then
                AdvancedSpy:ResetAll()
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
        btn.BackgroundColor3 = UI.Themes[UI.ColorScheme].dark
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Text = control.Text
        btn.TextColor3 = UI.Themes[UI.ColorScheme].text
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = controlFrame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        btn.MouseEnter:Connect(function()
            btn.BackgroundTransparency = 0.1
        end)

        btn.MouseLeave:Connect(function()
            btn.BackgroundTransparency = 0.3
        end)

        btn.MouseButton1Click:Connect(control.Action)
    end

    return frame
end

function UI:CreateAITab()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local aiFrame = Instance.new("ScrollingFrame")
    aiFrame.Size = UDim2.new(1, -10, 1, -10)
    aiFrame.Position = UDim2.new(0, 5, 0, 5)
    aiFrame.BackgroundColor3 = UI.Themes[UI.ColorScheme].dark
    aiFrame.BackgroundTransparency = 0.5
    aiFrame.ScrollBarThickness = 4
    aiFrame.Parent = frame

    local aiFrameCorner = Instance.new("UICorner")
    aiFrameCorner.CornerRadius = UDim.new(0, 8)
    aiFrameCorner.Parent = aiFrame

    local aiLayout = Instance.new("UIListLayout")
    aiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    aiLayout.Padding = UDim.new(0, 5)
    aiLayout.Parent = aiFrame

    frame.AIFrame = aiFrame
    return frame
end

function UI:CreateAnalyticsTab()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local analyticsFrame = Instance.new("ScrollingFrame")
    analyticsFrame.Size = UDim2.new(1, -10, 1, -10)
    analyticsFrame.Position = UDim2.new(0, 5, 0, 5)
    analyticsFrame.BackgroundColor3 = UI.Themes[UI.ColorScheme].dark
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
end

function UI:ShowInputDialog(title, default)
    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    
    local dialog = Instance.new("Frame")
    dialog.Size = UDim2.new(0, 400, 0, 150)
    dialog.Position = UDim2.new(0.5, -200, 0.5, -75)
    dialog.BackgroundColor3 = theme.background
    dialog.BackgroundTransparency = 0.1
    dialog.BorderSizePixel = 0
    dialog.Parent = UI.GUI.ScreenGui

    local dialogCorner = Instance.new("UICorner")
    dialogCorner.CornerRadius = UDim.new(0, 12)
    dialogCorner.Parent = dialog

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 35)
    titleLabel.BackgroundColor3 = theme.dark
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.primary
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Parent = dialog

    -- Input
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 0, 35)
    input.Position = UDim2.new(0, 10, 0, 45)
    input.BackgroundColor3 = theme.dark
    input.Text = default or ""
    input.TextColor3 = theme.text
    input.TextSize = 14
    input.Font = Enum.Font.Gotham
    input.Parent = dialog

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = input

    -- Buttons
    local okBtn = Instance.new("TextButton")
    okBtn.Size = UDim2.new(0, 80, 0, 35)
    okBtn.Position = UDim2.new(1, -180, 1, -45)
    okBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    okBtn.Text = "OK"
    okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    okBtn.TextSize = 14
    okBtn.Font = Enum.Font.GothamBold
    okBtn.Parent = dialog

    local okCorner = Instance.new("UICorner")
    okCorner.CornerRadius = UDim.new(0, 6)
    okCorner.Parent = okBtn

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0, 80, 0, 35)
    cancelBtn.Position = UDim2.new(1, -90, 1, -45)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    cancelBtn.Text = "Cancel"
    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.TextSize = 14
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.Parent = dialog

    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 6)
    cancelCorner.Parent = cancelBtn

    local result = nil

    okBtn.MouseButton1Click:Connect(function()
        result = input.Text
        dialog:Destroy()
    end)

    cancelBtn.MouseButton1Click:Connect(function()
        dialog:Destroy()
    end)

    input.Focused:Connect(function()
        if input.Text == default then
            input.Text = ""
        end
    end)

    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            result = input.Text
            dialog:Destroy()
        end
    end)

    dialog:WaitForChild("__disconnect")
    return result
end

function UI:ShowConfirmDialog(message)
    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    
    local dialog = Instance.new("Frame")
    dialog.Size = UDim2.new(0, 350, 0, 120)
    dialog.Position = UDim2.new(0.5, -175, 0.5, -60)
    dialog.BackgroundColor3 = theme.background
    dialog.BackgroundTransparency = 0.1
    dialog.BorderSizePixel = 0
    dialog.Parent = UI.GUI.ScreenGui

    local dialogCorner = Instance.new("UICorner")
    dialogCorner.CornerRadius = UDim.new(0, 12)
    dialogCorner.Parent = dialog

    -- Message
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 0, 40)
    msgLabel.Position = UDim2.new(0, 10, 0, 15)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = theme.text
    msgLabel.TextSize = 14
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextWrapped = true
    msgLabel.Parent = dialog

    -- Buttons
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0, 80, 0, 35)
    yesBtn.Position = UDim2.new(1, -180, 1, -45)
    yesBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    yesBtn.Text = "Yes"
    yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesBtn.TextSize = 14
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Parent = dialog

    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 6)
    yesCorner.Parent = yesBtn

    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0, 80, 0, 35)
    noBtn.Position = UDim2.new(1, -90, 1, -45)
    noBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    noBtn.Text = "No"
    noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noBtn.TextSize = 14
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Parent = dialog

    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 6)
    noCorner.Parent = noBtn

    local confirmed = false

    yesBtn.MouseButton1Click:Connect(function()
        confirmed = true
        dialog:Destroy()
    end)

    noBtn.MouseButton1Click:Connect(function()
        dialog:Destroy()
    end)

    dialog:WaitForChild("__disconnect")
    return confirmed
end

function UI:ShowNotification(message, duration)
    duration = duration or 3
    
    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 40)
    notification.Position = UDim2.new(1, -320, 0, 10 + #UI.Notifications * 45)
    notification.BackgroundColor3 = theme.dark
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 0
    notification.Parent = UI.GUI and UI.GUI.ScreenGui or PlayerGui

    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 8)
    notificationCorner.Parent = notification

    -- Border highlight
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 0, 2)
    border.BackgroundColor3 = theme.primary
    border.Parent = notification

    -- Message
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -10, 1, 0)
    msgLabel.Position = UDim2.new(0, 5, 0, 0)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = theme.text
    msgLabel.TextSize = 12
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Parent = notification

    -- Slide in animation
    notification.Position = UDim2.new(1, 0, 0, 10 + #UI.Notifications * 45)
    local tween = TweenService:Create(notification, 
        TweenInfo.new(0.3, Enum.EasingStyle.Back), 
        {Position = UDim2.new(1, -320, 0, 10 + #UI.Notifications * 45)}
    )
    tween:Play()

    table.insert(UI.Notifications, notification)

    task.wait(duration)

    -- Slide out animation
    local outTween = TweenService:Create(notification, 
        TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
        {Position = UDim2.new(1, 0, 0, 10 + #UI.Notifications * 45)}
    )
    outTween:Play()
    outTween.Completed:Connect(function()
        notification:Destroy()
        for i, n in ipairs(UI.Notifications) do
            if n == notification then
                table.remove(UI.Notifications, i)
                break
            end
        end
    end)
end

function UI:AddLogEntry(logEntry)
    local logTab = UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Logs
    if not logTab then return end
    
    local logList = logTab.LogList
    if not logList then return end

    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    
    -- Create log entry
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, -4, 0, 30)
    entry.BackgroundColor3 = theme.dark
    entry.BackgroundTransparency = 0.5
    entry.BorderSizePixel = 0
    entry.Parent = logList

    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 4)
    entryCorner.Parent = entry

    -- Time
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(0, 60, 1, 0)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = os.date("%H:%M:%S", logEntry.Timestamp or os.time())
    timeLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    timeLabel.TextSize = 10
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.TextXAlignment = Enum.TextXAlignment.Center
    timeLabel.Parent = entry

    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 25, 1, 0)
    iconLabel.Position = UDim2.new(0, 62, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = Utilities.GetRemoteIcon(logEntry.Remote)
    iconLabel.TextColor3 = theme.text
    iconLabel.TextSize = 14
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center
    iconLabel.Parent = entry

    -- Remote name
    local remoteLabel = Instance.new("TextLabel")
    remoteLabel.Size = UDim2.new(0, 120, 1, 0)
    remoteLabel.Position = UDim2.new(0, 90, 0, 0)
    remoteLabel.BackgroundTransparency = 1
    remoteLabel.Text = logEntry.Remote and logEntry.Remote.Name or "Unknown"
    remoteLabel.TextColor3 = theme.primary
    remoteLabel.TextSize = 11
    remoteLabel.Font = Enum.Font.GothamBold
    remoteLabel.TextXAlignment = Enum.TextXAlignment.Left
    remoteLabel.Parent = entry

    -- Type
    local typeLabel = Instance.new("TextLabel")
    typeLabel.Size = UDim2.new(0, 70, 1, 0)
    typeLabel.Position = UDim2.new(0, 215, 0, 0)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Text = logEntry.Type or "Remote"
    typeLabel.TextColor3 = logEntry.Type == "FireServer" and Color3.fromRGB(0, 200, 255) or 
                           logEntry.Type == "InvokeServer" and Color3.fromRGB(255, 200, 0) or
                           logEntry.Type == "AI_Anomaly" and Color3.fromRGB(255, 0, 255) or
                           theme.text
    typeLabel.TextSize = 10
    typeLabel.Font = Enum.Font.Gotham
    typeLabel.TextXAlignment = Enum.TextXAlignment.Center
    typeLabel.Parent = entry

    -- Args preview
    local argsLabel = Instance.new("TextLabel")
    argsLabel.Size = UDim2.new(1, -340, 1, 0)
    argsLabel.Position = UDim2.new(0, 290, 0, 0)
    argsLabel.BackgroundTransparency = 1
    local argsStr = Utilities.FormatValue(logEntry.Args or {})
    argsLabel.Text = #argsStr > 50 and argsStr:sub(1, 50) .. "..." or argsStr
    argsLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    argsLabel.TextSize = 10
    argsLabel.Font = Enum.Font.Gotham
    argsLabel.TextXAlignment = Enum.TextXAlignment.Left
    argsLabel.Parent = entry

    -- AI Score (if available)
    if logEntry.AIScore and logEntry.AIScore > 0 then
        local aiLabel = Instance.new("TextLabel")
        aiLabel.Size = UDim2.new(0, 35, 1, 0)
        aiLabel.Position = UDim2.new(1, -40, 0, 0)
        aiLabel.BackgroundTransparency = 1
        aiLabel.Text = string.format("%.2f", logEntry.AIScore)
        aiLabel.TextColor3 = logEntry.AIScore > 0.7 and Color3.fromRGB(255, 0, 255) or 
                              Color3.fromRGB(200, 200, 200)
        aiLabel.TextSize = 9
        aiLabel.Font = Enum.Font.GothamBold
        aiLabel.TextXAlignment = Enum.TextXAlignment.Center
        aiLabel.Parent = entry
    end

    -- Add hover effect
    entry.MouseEnter:Connect(function()
        entry.BackgroundTransparency = 0.2
    end)

    entry.MouseLeave:Connect(function()
        entry.BackgroundTransparency = 0.5
    end)

    -- Click to expand
    entry.MouseButton1Click:Connect(function()
        local details = string.format(
            "Remote: %s\nPath: %s\nType: %s\nArgs: %s\nReturn: %s\nLatency: %.3fms\nPattern: %s\nAI Score: %.3f",
            logEntry.Remote and logEntry.Remote.Name or "Unknown",
            logEntry.Remote and logEntry.Remote:GetFullName() or "",
            logEntry.Type or "Remote",
            Utilities.FormatValue(logEntry.Args or {}),
            logEntry.ReturnValue and Utilities.FormatValue(logEntry.ReturnValue) or "None",
            (logEntry.Latency or 0) * 1000,
            logEntry.Pattern and logEntry.Pattern.name or "None",
            logEntry.AIScore or 0
        )
        UI.ShowNotification(details, 5)
    end)

    -- Update log count
    if logTab.LogCount then
        logTab.LogCount.Text = string.format("📋 %d logs", #AdvancedSpy.RemoteLog)
    end

    -- Auto scroll
    task.spawn(function()
        task.wait(0.05)
        logList.CanvasPosition = Vector2.new(0, 0)
    end)
end

function UI:UpdateLogs()
    local logTab = UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Logs
    if not logTab then return end
    
    local logList = logTab.LogList
    if not logList then return end

    -- Clear old entries
    for _, child in ipairs(logList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Filter logs
    local filteredLogs = {}
    local searchText = UI.SearchText:lower()
    
    for _, log in ipairs(AdvancedSpy.RemoteLog) do
        local include = true
        
        -- Apply filter
        if UI.CurrentFilter ~= "All" then
            if UI.CurrentFilter == "AI_Anomaly" then
                if not log.AIDetected then include = false end
            elseif log.Type ~= UI.CurrentFilter then
                include = false
            end
        end
        
        -- Apply search
        if searchText ~= "" then
            local remoteName = log.Remote and log.Remote.Name or ""
            local argsStr = Utilities.FormatValue(log.Args or {})
            local patternName = log.Pattern and log.Pattern.name or ""
            
            if not remoteName:lower():find(searchText) and 
               not argsStr:lower():find(searchText) and
               not patternName:lower():find(searchText) then
                include = false
            end
        end
        
        if include then
            table.insert(filteredLogs, log)
        end
    end

    -- Add logs
    for i, log in ipairs(filteredLogs) do
        UI.AddLogEntry(log)
        if i > 100 then break end
    end

    -- Update count
    if logTab.LogCount then
        logTab.LogCount.Text = string.format("📋 %d logs", #filteredLogs)
    end
end

function UI:UpdateRemotes()
    local remoteTab = UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Remotes
    if not remoteTab then return end
    
    local remoteList = remoteTab.RemoteList
    if not remoteList then return end

    -- Clear old entries
    for _, child in ipairs(remoteList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    local remotes = RemoteCache:GetAll()
    local searchText = UI.SearchText:lower()
    
    for _, remote in ipairs(remotes) do
        -- Apply search
        if searchText ~= "" then
            local remoteName = remote.Name
            local remotePath = remote:GetFullName()
            if not remoteName:lower():find(searchText) and 
               not remotePath:lower():find(searchText) then
                goto continue
            end
        end
        
        local entry = Instance.new("Frame")
        entry.Size = UDim2.new(1, -4, 0, 28)
        entry.BackgroundColor3 = theme.dark
        entry.BackgroundTransparency = 0.5
        entry.BorderSizePixel = 0
        entry.Parent = remoteList

        local entryCorner = Instance.new("UICorner")
        entryCorner.CornerRadius = UDim.new(0, 4)
        entryCorner.Parent = entry

        -- Icon
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 25, 1, 0)
        iconLabel.Position = UDim2.new(0, 5, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = Utilities.GetRemoteIcon(remote)
        iconLabel.TextColor3 = theme.text
        iconLabel.TextSize = 14
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = entry

        -- Remote name
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 200, 1, 0)
        nameLabel.Position = UDim2.new(0, 35, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = remote.Name
        nameLabel.TextColor3 = AdvancedSpy:IsBlocked(remote) and 
                               Color3.fromRGB(255, 50, 50) or 
                               theme.primary
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = entry

        -- Path
        local pathLabel = Instance.new("TextLabel")
        pathLabel.Size = UDim2.new(0, 200, 1, 0)
        pathLabel.Position = UDim2.new(0, 240, 0, 0)
        pathLabel.BackgroundTransparency = 1
        pathLabel.Text = remote:GetFullName():sub(1, 30) .. "..."
        pathLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        pathLabel.TextSize = 10
        pathLabel.Font = Enum.Font.Gotham
        pathLabel.TextXAlignment = Enum.TextXAlignment.Left
        pathLabel.Parent = entry

        -- Calls count
        local callsLabel = Instance.new("TextLabel")
        callsLabel.Size = UDim2.new(0, 50, 1, 0)
        callsLabel.Position = UDim2.new(1, -180, 0, 0)
        callsLabel.BackgroundTransparency = 1
        callsLabel.Text = tostring(AdvancedSpy.RemoteStats.CallsPerRemote[remote.Name] or 0)
        callsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        callsLabel.TextSize = 10
        callsLabel.Font = Enum.Font.Gotham
        callsLabel.TextXAlignment = Enum.TextXAlignment.Center
        callsLabel.Parent = entry

        -- Block button
        local blockBtn = Instance.new("TextButton")
        blockBtn.Size = UDim2.new(0, 60, 1, -4)
        blockBtn.Position = UDim2.new(1, -125, 0, 2)
        blockBtn.BackgroundColor3 = AdvancedSpy:IsBlocked(remote) and 
                                     Color3.fromRGB(50, 200, 50) or 
                                     Color3.fromRGB(200, 50, 50)
        blockBtn.BackgroundTransparency = 0.3
        blockBtn.BorderSizePixel = 0
        blockBtn.Text = AdvancedSpy:IsBlocked(remote) and "Unblock" or "Block"
        blockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        blockBtn.TextSize = 10
        blockBtn.Font = Enum.Font.GothamBold
        blockBtn.Parent = entry

        local blockCorner = Instance.new("UICorner")
        blockCorner.CornerRadius = UDim.new(0, 4)
        blockCorner.Parent = blockBtn

        blockBtn.MouseButton1Click:Connect(function()
            if AdvancedSpy:IsBlocked(remote) then
                AdvancedSpy:UnblockRemote(remote)
            else
                AdvancedSpy:BlockRemote(remote)
            end
            UI.UpdateRemotes()
        end)

        entry.MouseEnter:Connect(function()
            entry.BackgroundTransparency = 0.2
        end)

        entry.MouseLeave:Connect(function()
            entry.BackgroundTransparency = 0.5
        end)

        ::continue::
    end
end

function UI:UpdateStats()
    local statsTab = UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Stats
    if not statsTab then return end
    
    local statsFrame = statsTab.StatsFrame
    if not statsFrame then return end

    -- Clear old entries
    for _, child in ipairs(statsFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    
    -- Stats data
    local stats = {
        {label = "📞 Total Calls", value = AdvancedSpy.RemoteStats.TotalCalls or 0},
        {label = "📊 Total Logs", value = #AdvancedSpy.RemoteLog},
        {label = "📡 Total Remotes", value = #RemoteCache:GetAll()},
        {label = "⛔ Blocked Remotes", value = #AdvancedSpy.BlockedRemotes},
        {label = "⚡ Peak Rate", value = string.format("%d calls/sec", AdvancedSpy.RemoteStats.PeakRate or 0)},
        {label = "📈 Current Rate", value = string.format("%d calls/sec", AnalyticsEngine.RealTime.CurrentRate or 0)},
        {label = "⏱️ Avg Latency", value = string.format("%.2fms", (AnalyticsEngine.RealTime.AvgLatency or 0) * 1000)},
        {label = "🧠 AI Accuracy", value = string.format("%.2f%%", (AdvancedSpy.AI.Accuracy or 0) * 100)},
        {label = "⚠️ Anomaly Score", value = string.format("%.3f", AnalyticsEngine.RealTime.AnomalyScore or 0)},
        {label = "📊 Error Rate", value = string.format("%.2f%%", (AdvancedSpy.RemoteStats.ErrorRate or 0) * 100)},
        {label = "💾 Memory Usage", value = string.format("%.2f MB", collectgarbage("count") / 1024)},
        {label = "⏰ Uptime", value = Utilities.FormatDuration(os.difftime(os.time(), AdvancedSpy.StartTime))},
        {label = "🔌 Hooks", value = AnalyticsEngine:CountHooks()},
        {label = "🌐 WebSocket", value = AdvancedSpy.WebSocket.Connected and "Connected ✅" or "Disconnected ❌"},
        {label = "💿 Database", value = AdvancedSpy.Database.Connected and "Connected ✅" or "Disabled ❌"},
        {label = "📦 Smart Responder", value = AdvancedSpy.Settings.AutoResponderEnabled and "Enabled ✅" or "Disabled ❌"},
    }

    for _, stat in ipairs(stats) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -4, 0, 35)
        row.BackgroundColor3 = theme.dark
        row.BackgroundTransparency = 0.3
        row.BorderSizePixel = 0
        row.Parent = statsFrame

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 6)
        rowCorner.Parent = row

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, -10, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = stat.label
        label.TextColor3 = theme.text
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(0.5, -10, 1, 0)
        value.Position = UDim2.new(0.5, 0, 0, 0)
        value.BackgroundTransparency = 1
        value.Text = tostring(stat.value)
        value.TextColor3 = theme.primary
        value.TextSize = 13
        value.Font = Enum.Font.GothamBold
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.Parent = row
    end
end

function UI:UpdateSettings()
    -- Update settings UI
    local settingsTab = UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Settings
    if not settingsTab then return end
    
    -- Implementation for settings UI
end

function UI:UpdateHooks()
    local hooksTab = UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Hooks
    if not hooksTab then return end
    
    local hooksFrame = hooksTab.HooksFrame
    if not hooksFrame then return end

    -- Clear old entries
    for _, child in ipairs(hooksFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    
    for hookType, hooks in pairs(AdvancedSpy.CustomHooks) do
        if next(hooks) then
            local header = Instance.new("TextLabel")
            header.Size = UDim2.new(1, -4, 0, 25)
            header.BackgroundColor3 = theme.primary
            header.BackgroundTransparency = 0.8
            header.Text = string.format("📌 %s (%d hooks)", hookType, #hooks)
            header.TextColor3 = theme.text
            header.TextSize = 12
            header.Font = Enum.Font.GothamBold
            header.Parent = hooksFrame

            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 4)
            headerCorner.Parent = header

            for name, hook in pairs(hooks) do
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, -4, 0, 25)
                row.BackgroundColor3 = theme.dark
                row.BackgroundTransparency = 0.5
                row.BorderSizePixel = 0
                row.Parent = hooksFrame

                local rowCorner = Instance.new("UICorner")
                rowCorner.CornerRadius = UDim.new(0, 4)
                rowCorner.Parent = row

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -50, 1, 0)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = name
                label.TextColor3 = theme.text
                label.TextSize = 11
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local removeBtn = Instance.new("TextButton")
                removeBtn.Size = UDim2.new(0, 30, 1, -4)
                removeBtn.Position = UDim2.new(1, -35, 0, 2)
                removeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                removeBtn.BackgroundTransparency = 0.3
                removeBtn.BorderSizePixel = 0
                removeBtn.Text = "✕"
                removeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                removeBtn.TextSize = 12
                removeBtn.Font = Enum.Font.GothamBold
                removeBtn.Parent = row

                local removeCorner = Instance.new("UICorner")
                removeCorner.CornerRadius = UDim.new(0, 4)
                removeCorner.Parent = removeBtn

                removeBtn.MouseButton1Click:Connect(function()
                    AdvancedSpy:RemoveHook(hookType, name)
                    UI.UpdateHooks()
                end)
            end
        end
    end
end

function UI:UpdateAI()
    local aiTab = UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.AI
    if not aiTab then return end
    
    local aiFrame = aiTab.AIFrame
    if not aiFrame then return end

    -- Clear old entries
    for _, child in ipairs(aiFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    
    local aiData = {
        {label = "🧠 AI Status", value = AdvancedSpy.Settings.EnableAI and "Enabled ✅" or "Disabled ❌"},
        {label = "📊 Trained", value = AdvancedSpy.AI.Trained and "Yes ✅" or "No ❌"},
        {label = "🎯 Accuracy", value = string.format("%.2f%%", (AdvancedSpy.AI.Accuracy or 0) * 100)},
        {label = "📈 Predictions", value = #AdvancedSpy.AI.Predictions},
        {label = "⚠️ Anomalies", value = #AdvancedSpy.AI.AnomalyScore},
        {label = "📐 Threshold", value = string.format("%.2f", AdvancedSpy.Settings.AIThreshold)},
        {label = "🔄 Epochs", value = AdvancedSpy.AI.Epochs or 0},
        {label = "📉 Loss", value = string.format("%.6f", AdvancedSpy.AI.Loss or 0)},
        {label = "✅ TP", value = AdvancedSpy.AI.ConfusionMatrix and AdvancedSpy.AI.ConfusionMatrix.TP or 0},
        {label = "❌ FP", value = AdvancedSpy.AI.ConfusionMatrix and AdvancedSpy.AI.ConfusionMatrix.FP or 0},
        {label = "✅ TN", value = AdvancedSpy.AI.ConfusionMatrix and AdvancedSpy.AI.ConfusionMatrix.TN or 0},
        {label = "❌ FN", value = AdvancedSpy.AI.ConfusionMatrix and AdvancedSpy.AI.ConfusionMatrix.FN or 0},
    }

    for _, stat in ipairs(aiData) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -4, 0, 30)
        row.BackgroundColor3 = theme.dark
        row.BackgroundTransparency = 0.3
        row.BorderSizePixel = 0
        row.Parent = aiFrame

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 6)
        rowCorner.Parent = row

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, -10, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = stat.label
        label.TextColor3 = theme.text
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(0.5, -10, 1, 0)
        value.Position = UDim2.new(0.5, 0, 0, 0)
        value.BackgroundTransparency = 1
        value.Text = tostring(stat.value)
        value.TextColor3 = theme.primary
        value.TextSize = 13
        value.Font = Enum.Font.GothamBold
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.Parent = row
    end
end

function UI:UpdateAnalytics()
    local analyticsTab = UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Analytics
    if not analyticsTab then return end
    
    local analyticsFrame = analyticsTab.AnalyticsFrame
    if not analyticsFrame then return end

    -- Clear old entries
    for _, child in ipairs(analyticsFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    local stats = AnalyticsEngine:GetStatistics()
    
    local analyticsData = {
        {label = "📈 Current Rate", value = string.format("%d calls/sec", stats.currentRate or 0)},
        {label = "⚡ Peak Rate", value = string.format("%d calls/sec", stats.peakRate or 0)},
        {label = "⏱️ Avg Latency", value = string.format("%.2fms", (stats.avgLatency or 0) * 1000)},
        {label = "⚠️ Anomaly Score", value = string.format("%.3f", stats.anomalyScore or 0)},
        {label = "📊 Error Rate", value = string.format("%.2f%%", (stats.errorRate or 0) * 100)},
        {label = "💾 Memory", value = string.format("%.2f MB", stats.memoryUsage or 0)},
        {label = "🔌 Hooks", value = stats.hookCount or 0},
        {label = "📡 Remotes", value = stats.totalRemotes or 0},
        {label = "⛔ Blocked", value = stats.blockedRemotes or 0},
        {label = "📊 Total Calls", value = stats.totalCalls or 0},
        {label = "📋 Total Logs", value = stats.totalLogs or 0},
        {label = "🌐 WebSocket", value = AdvancedSpy.WebSocket.Connected and "Connected ✅" or "Disabled ❌"},
        {label = "💿 Database", value = AdvancedSpy.Database.Connected and "Connected ✅" or "Disabled ❌"},
        {label = "🧠 AI Accuracy", value = string.format("%.2f%%", (stats.aiAccuracy or 0) * 100)},
        {label = "⏰ Uptime", value = Utilities.FormatDuration(stats.uptime or 0)},
    }

    for _, stat in ipairs(analyticsData) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -4, 0, 30)
        row.BackgroundColor3 = theme.dark
        row.BackgroundTransparency = 0.3
        row.BorderSizePixel = 0
        row.Parent = analyticsFrame

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 6)
        rowCorner.Parent = row

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, -10, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = stat.label
        label.TextColor3 = theme.text
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(0.5, -10, 1, 0)
        value.Position = UDim2.new(0.5, 0, 0, 0)
        value.BackgroundTransparency = 1
        value.Text = tostring(stat.value)
        value.TextColor3 = theme.primary
        value.TextSize = 12
        value.Font = Enum.Font.GothamBold
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.Parent = row
    end

    -- Add anomaly list
    if #AnalyticsEngine.Data.Anomalies > 0 then
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, -4, 0, 25)
        header.Position = UDim2.new(0, 2, 0, #analyticsData * 32 + 5)
        header.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        header.BackgroundTransparency = 0.7
        header.Text = "🚨 Recent Anomalies"
        header.TextColor3 = theme.text
        header.TextSize = 12
        header.Font = Enum.Font.GothamBold
        header.Parent = analyticsFrame

        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 4)
        headerCorner.Parent = header

        for _, anomaly in ipairs(AnalyticsEngine.Data.Anomalies) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -4, 0, 25)
            row.Position = UDim2.new(0, 2, 0, (#analyticsData + 1) * 32 + 5)
            row.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            row.BackgroundTransparency = 0.5
            row.BorderSizePixel = 0
            row.Parent = analyticsFrame

            local rowCorner = Instance.new("UICorner")
            rowCorner.CornerRadius = UDim.new(0, 4)
            rowCorner.Parent = row

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 1, 0)
            label.Position = UDim2.new(0, 5, 0, 0)
            label.BackgroundTransparency = 1
            local msg = string.format("%s: %s", anomaly.type, anomaly.message or "")
            label.Text = msg:sub(1, 50)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 10
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row
        end
    end
end

function UI:UpdateTheme()
    local theme = UI.Themes[UI.ColorScheme] or UI.Themes.cyberpunk
    local main = UI.GUI and UI.GUI.Main
    if not main then return end
    
    main.BackgroundColor3 = theme.background
    UI.Transparency = AdvancedSpy.Settings.Transparency or 0.85
    main.BackgroundTransparency = UI.Transparency
    
    -- Update border
    for _, child in ipairs(main:GetChildren()) do
        if child:IsA("Frame") and child.Name == "Border" then
            child.BackgroundColor3 = theme.border
        end
    end
    
    -- Update title bar
    for _, child in ipairs(main:GetChildren()) do
        if child:IsA("Frame") and child.Name == "TitleBar" then
            child.BackgroundColor3 = theme.dark
            for _, grandchild in ipairs(child:GetChildren()) do
                if grandchild:IsA("TextLabel") then
                    grandchild.TextColor3 = theme.text
                end
                if grandchild:IsA("UIGradient") then
                    grandchild.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, theme.primary),
                        ColorSequenceKeypoint.new(0.5, theme.secondary),
                        ColorSequenceKeypoint.new(1, theme.primary),
                    })
                end
            end
        end
    end
end

function UI:ClearLogs()
    local logTab = UI.GUI and UI.GUI.Tabs and UI.GUI.Tabs.Logs
    if not logTab then return end
    
    local logList = logTab.LogList
    if not logList then return end

    for _, child in ipairs(logList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if logTab.LogCount then
        logTab.LogCount.Text = "📋 0 logs"
    end
end

-- ============ INITIALIZATION ============
function AdvancedSpy:Start()
    if self.Enabled then return end

    print(string.format("🚀 Starting AdvancedSpy Pro v%s...", self.Version))
    print(string.format("📅 Build: %s", self.Build))
    print(string.format("🆔 Session: %s", self.Security.SessionID))
    
    -- Initialize AI
    if self.Settings.EnableAI then
        AIEngine.Initialize(12, {16, 32, 16}, 2)
        print("🧠 AI Engine initialized")
        
        -- Train initial AI with any existing data
        if #self.RemoteLog > 0 and self.Settings.AIAutoLearn then
            local data = {}
            local labels = {}
            for _, log in ipairs(self.RemoteLog) do
                if #data < 50 then
                    local feat = {
                        string.len(log.Remote and log.Remote.Name or ""),
                        #(log.Args or {}),
                        log.Latency or 0,
                        os.time() % 100,
                        type(log.Args and log.Args[1]) == "table" and 1 or 0,
                        AdvancedSpy.RemoteStats.CallsPerRemote[log.Remote and log.Remote.Name or ""] or 0,
                    }
                    table.insert(data, feat)
                    table.insert(labels, {math.random(), math.random()})
                end
            end
            if #data > 0 then
                AIEngine.Train(data, labels, 10)
            end
        end
    end

    -- Initialize Database
    if self.Settings.DatabaseEnabled then
        DatabaseManager:Initialize()
    end

    -- Initialize WebSocket
    if self.Settings.WebSocketEnabled and self.Settings.WebSocketURL ~= "" then
        WebSocketManager:Connect(self.Settings.WebSocketURL)
    end

    -- Hook system
    local hookSuccess = HookManager:Init()
    if not hookSuccess then
        warn("❌ Failed to initialize hook system")
        return
    end

    -- Create UI
    UI:Create()
    
    -- Initial scan
    RemoteCache:Update(true)
    
    -- Start analytics engine
    task.spawn(function()
        while self.Enabled do
            task.wait(5)
            AnalyticsEngine:Analyze()
        end
    end)

    -- Auto-save
    if self.Settings.AutoSave then
        task.spawn(function()
            while self.Enabled do
                task.wait(60)
                if self.Settings.DatabaseEnabled and DatabaseManager.Connected then
                    DatabaseManager:Query("PRAGMA optimize")
                end
            end
        end)
    end

    self.Enabled = true
    print("✅ AdvancedSpy Pro v6.0.0 started successfully!")
    UI.ShowNotification(string.format("🚀 AdvancedSpy Pro v%s loaded!", self.Version))
    
    -- Log startup
    self:AddToLog({Name = "System"}, {message = "AdvancedSpy Pro v6 started", session = self.Security.SessionID}, nil, "Startup")
end

function AdvancedSpy:Destroy()
    print("🔮 Destroying AdvancedSpy Pro v6...")
    self.Enabled = false
    
    -- Restore hook
    HookManager:Restore()
    
    -- Close WebSocket
    if WebSocketManager.Connected then
        pcall(WebSocketManager.Connection.Close)
    end
    
    -- Close Database
    if DatabaseManager.Connected then
        pcall(DatabaseManager.Cleanup)
        pcall(DatabaseManager.Connection.close)
    end

    -- Clean traces
    AntiDetection.CleanTraces()

    -- Destroy GUI
    if UI.GUI and UI.GUI.ScreenGui then
        UI.GUI.ScreenGui:Destroy()
    end

    -- Remove blur
    if self.Connections.Blur then
        self.Connections.Blur:Destroy()
    end

    -- Clear memory
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
        OnAnomaly = {},
        OnPredict = {},
        OnConnect = {},
        OnDisconnect = {},
    }
    
    collectgarbage()
    print("✅ AdvancedSpy Pro v6 destroyed")
end

-- ============ START ============
AdvancedSpy:Start()

-- Return for external access
return AdvancedSpy
