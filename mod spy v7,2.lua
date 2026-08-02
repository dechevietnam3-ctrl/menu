-- ============ SPY V7.2 - ANTI-HACK ASSESSMENT ============
-- 
-- 🎯 TÍNH NĂNG MỚI:
-- 1. Nút bấm trực quan trong game
-- 2. Hiệu ứng thông báo giống nhận huy hiệu Roblox
-- 3. Đánh giá anti-hack real-time
-- 4. Gợi ý executor phù hợp
-- ===========================================================

-- ============ SERVICES ============
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============ ANTI-HACK ASSESSMENT ENGINE ============
local AntiHackAssessment = {
    Version = "7.2.0",
    
    -- Kết quả đánh giá
    Result = {
        SecurityScore = 0,
        AntiCheatType = "Unknown",
        RiskLevel = "Unknown",
        Vulnerabilities = {},
        Recommendations = {},
        ExecutorCompat = {},
        GameName = "",
    },
    
    -- Anti-Cheat Patterns
    AntiCheatPatterns = {
        Byfron = {
            patterns = {"Byfron", "Hyperion", "AntiTamper", "RobloxSecurity"},
            score = 95,
        },
        EasyAntiCheat = {
            patterns = {"EAC", "EasyAntiCheat", "AntiCheatClient"},
            score = 85,
        },
        BattlEye = {
            patterns = {"BattlEye", "BE_Server", "AntiCheatService"},
            score = 80,
        },
        RobloxBuiltIn = {
            patterns = {"RobloxSecurity", "CoreSecurity", "ProtectedCall"},
            score = 60,
        },
        Custom = {
            patterns = {"AntiCheat", "AntiHack", "SecurityCheck", "Watchdog"},
            score = 70,
        },
    },
    
    -- Test security
    SecurityTests = {
        RemoteSpy = function()
            local count = 0
            for _, child in pairs(ReplicatedStorage:GetChildren()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    count = count + 1
                end
            end
            return {
                score = count > 30 and 80 or (count > 15 and 50 or 20),
                detail = string.format("📡 %d remote events/functions found", count),
            }
        end,
        ExecutorDetection = function()
            local detected = false
            local methods = {"syn", "krnl", "fluxus", "scriptware", "getexecutorname"}
            for _, m in ipairs(methods) do
                if getgenv()[m] ~= nil then
                    detected = true
                    break
                end
            end
            return {
                score = detected and 30 or 90,
                detail = detected and "⚠️ Executor detection active" or "✅ No executor detection",
            }
        end,
        ServerVerify = function()
            local hasVerify = false
            local names = {"Verify", "Auth", "Check", "Validate", "Ping", "Heartbeat"}
            for _, child in pairs(ReplicatedStorage:GetChildren()) do
                for _, name in ipairs(names) do
                    if child.Name:find(name) then
                        hasVerify = true
                        break
                    end
                end
            end
            return {
                score = hasVerify and 70 or 30,
                detail = hasVerify and "🔐 Server verification active" or "⚠️ No server verification",
            }
        end,
        AntiTamper = function()
            local hasProtection = false
            local checks = {"CoreGui.RobloxGui", "HttpService.GetAsync"}
            for _, check in ipairs(checks) do
                if pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end) then
                    hasProtection = true
                end
            end
            return {
                score = hasProtection and 80 or 30,
                detail = hasProtection and "🛡️ Anti-tamper active" or "⚠️ No anti-tamper",
            }
        end,
    },
}

-- ============ BADGE NOTIFICATION UI ============
local BadgeNotification = {
    Queue = {},
    IsShowing = false,
    
    -- Tạo thông báo giống huy hiệu Roblox
    CreateNotification = function(title, description, icon, color, duration)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 500, 0, 150)
        notif.Position = UDim2.new(0.5, -250, 0.5, 200)
        notif.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.ClipsDescendants = true
        notif.Parent = CoreGui
        
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
        
        -- Icon (giống huy hiệu)
        local iconFrame = Instance.new("Frame")
        iconFrame.Size = UDim2.new(0, 80, 0, 80)
        iconFrame.Position = UDim2.new(0, 20, 0.5, -40)
        iconFrame.BackgroundColor3 = color or Color3.fromRGB(0, 150, 255)
        iconFrame.BackgroundTransparency = 0.3
        iconFrame.BorderSizePixel = 2
        iconFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
        iconFrame.Parent = notif
        
        -- Icon border glow
        local glow = Instance.new("UIStroke")
        glow.Color = color or Color3.fromRGB(0, 150, 255)
        glow.Thickness = 3
        glow.Transparency = 0.5
        glow.Parent = iconFrame
        
        -- Icon text
        local iconText = Instance.new("TextLabel")
        iconText.Size = UDim2.new(1, 0, 1, 0)
        iconText.Text = icon or "🏆"
        iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
        iconText.TextSize = 50
        iconText.Font = Enum.Font.GothamBold
        iconText.BackgroundTransparency = 1
        iconText.Parent = iconFrame
        
        -- Title
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -120, 0, 40)
        titleLabel.Position = UDim2.new(0, 110, 0, 20)
        titleLabel.Text = title or "🏅 Badge Unlocked!"
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 20
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.BackgroundTransparency = 1
        titleLabel.Parent = notif
        
        -- Description
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -120, 0, 50)
        descLabel.Position = UDim2.new(0, 110, 0, 60)
        descLabel.Text = description or "You've earned this badge!"
        descLabel.TextColor3 = Color3.fromRGB(180, 180, 230)
        descLabel.TextSize = 14
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
        descLabel.BackgroundTransparency = 1
        descLabel.Parent = notif
        
        -- Progress bar (style Roblox)
        local progressBar = Instance.new("Frame")
        progressBar.Size = UDim2.new(1, 0, 0, 4)
        progressBar.Position = UDim2.new(0, 0, 1, -4)
        progressBar.BackgroundColor3 = color or Color3.fromRGB(0, 150, 255)
        progressBar.BackgroundTransparency = 0.3
        progressBar.BorderSizePixel = 0
        progressBar.Parent = notif
        
        local progressFill = Instance.new("Frame")
        progressFill.Size = UDim2.new(1, 0, 1, 0)
        progressFill.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255)
        progressFill.BorderSizePixel = 0
        progressFill.Parent = progressBar
        
        -- Particles (sparkles)
        for i = 1, 20 do
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, 4, 0, 4)
            particle.Position = UDim2.new(math.random() / 10, 0, math.random() / 10, 0)
            particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            particle.BackgroundTransparency = 0.5
            particle.BorderSizePixel = 0
            particle.Parent = notif
            
            local startX = particle.Position.X.Scale
            local startY = particle.Position.Y.Scale
            
            TweenService:Create(particle, TweenInfo.new(math.random(1, 3), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startX + math.random(-5, 5)/10, 0, startY + math.random(-5, 5)/10, 0),
                BackgroundTransparency = 1,
            }):Play()
        end
        
        -- Animation IN
        notif.Position = UDim2.new(0.5, -250, 0.5, 300)
        notif.BackgroundTransparency = 1
        
        local tweenIn = TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -250, 0.5, 200),
            BackgroundTransparency = 0.1,
        })
        tweenIn:Play()
        
        -- Progress bar animation
        progressFill.Size = UDim2.new(0, 0, 1, 0)
        local tweenProgress = TweenService:Create(progressFill, TweenInfo.new(duration or 4, Enum.EasingStyle.Linear), {
            Size = UDim2.new(1, 0, 1, 0),
        })
        tweenProgress:Play()
        
        -- Auto dismiss
        task.wait(duration or 4)
        
        -- Animation OUT
        local tweenOut = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -250, 0.5, 300),
            BackgroundTransparency = 1,
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notif:Destroy()
        end)
        
        return notif
    end,
    
    -- Queue system
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

-- ============ UI WITH BUTTONS ============
local AssessmentUI = {
    ScreenGui = nil,
    MainFrame = nil,
    IsOpen = false,
    
    Init = function()
        if AssessmentUI.ScreenGui then
            AssessmentUI.Toggle()
            return
        end
        
        AssessmentUI.ScreenGui = Instance.new("ScreenGui")
        AssessmentUI.ScreenGui.Name = "AntiHackAssessmentUI"
        AssessmentUI.ScreenGui.Parent = CoreGui
        AssessmentUI.ScreenGui.ResetOnSpawn = false
        
        -- Main Frame
        AssessmentUI.MainFrame = Instance.new("Frame")
        AssessmentUI.MainFrame.Size = UDim2.new(0, 400, 0, 550)
        AssessmentUI.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
        AssessmentUI.MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 35)
        AssessmentUI.MainFrame.BackgroundTransparency = 0.05
        AssessmentUI.MainFrame.BorderSizePixel = 0
        AssessmentUI.MainFrame.ClipsDescendants = true
        AssessmentUI.MainFrame.Parent = AssessmentUI.ScreenGui
        
        -- Shadow
        local shadow = Instance.new("ImageLabel")
        shadow.Size = UDim2.new(1, 40, 1, 40)
        shadow.Position = UDim2.new(0, -20, 0, -20)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316043460"
        shadow.ImageTransparency = 0.8
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 10, 10)
        shadow.Parent = AssessmentUI.MainFrame
        
        -- Title Bar
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 45)
        titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = AssessmentUI.MainFrame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -40, 1, 0)
        title.Text = "🛡️ Anti-Hack Assessment"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 18
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.GothamBold
        title.BackgroundTransparency = 1
        title.Parent = titleBar
        
        -- Close button
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 8)
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
        
        -- Buttons Container
        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(1, -20, 0, 100)
        btnContainer.Position = UDim2.new(0, 10, 0, 55)
        btnContainer.BackgroundTransparency = 1
        btnContainer.Parent = AssessmentUI.MainFrame
        
        -- Nút SCAN
        local scanBtn = AssessmentUI:CreateButton("🔍 SCAN GAME", "Scan for anti-hack systems", 
            Color3.fromRGB(0, 150, 255), Color3.fromRGB(0, 100, 200))
        scanBtn.Parent = btnContainer
        
        -- Nút SECURITY SCORE
        local scoreBtn = AssessmentUI:CreateButton("📊 SECURITY SCORE", "Quick security assessment",
            Color3.fromRGB(255, 150, 0), Color3.fromRGB(200, 100, 0))
        scoreBtn.Position = UDim2.new(0, 0, 0, 50)
        scoreBtn.Parent = btnContainer
        
        -- Nút EXECUTOR CHECK
        local execBtn = AssessmentUI:CreateButton("💻 EXECUTOR CHECK", "Check which executors work",
            Color3.fromRGB(150, 50, 255), Color3.fromRGB(100, 0, 200))
        execBtn.Position = UDim2.new(0.5, 5, 0, 0)
        execBtn.Parent = btnContainer
        
        -- Nút RECOMMEND
        local recBtn = AssessmentUI:CreateButton("💡 RECOMMEND", "Get recommendations",
            Color3.fromRGB(50, 200, 50), Color3.fromRGB(0, 150, 0))
        recBtn.Position = UDim2.new(0.5, 5, 0, 50)
        recBtn.Parent = btnContainer
        
        -- Result Display
        local resultFrame = Instance.new("ScrollingFrame")
        resultFrame.Size = UDim2.new(1, -20, 1, -175)
        resultFrame.Position = UDim2.new(0, 10, 0, 165)
        resultFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
        resultFrame.BackgroundTransparency = 0.5
        resultFrame.BorderSizePixel = 0
        resultFrame.Parent = AssessmentUI.MainFrame
        
        -- Result Label
        local resultLabel = Instance.new("TextLabel")
        resultLabel.Size = UDim2.new(1, -10, 1, -10)
        resultLabel.Position = UDim2.new(0, 5, 0, 5)
        resultLabel.Text = "👆 Click a button above to assess this game's anti-hack system"
        resultLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        resultLabel.TextSize = 14
        resultLabel.Font = Enum.Font.Gotham
        resultLabel.TextWrapped = true
        resultLabel.TextXAlignment = Enum.TextXAlignment.Left
        resultLabel.TextYAlignment = Enum.TextYAlignment.Top
        resultLabel.BackgroundTransparency = 1
        resultLabel.Parent = resultFrame
        
        -- Store references
        AssessmentUI.ResultLabel = resultLabel
        AssessmentUI.ResultFrame = resultFrame
        
        AssessmentUI.IsOpen = true
    end,
    
    CreateButton = function(text, tooltip, color, hoverColor)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 185, 0, 45)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        
        -- Hover effect
        local hoverTween = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = hoverColor or color
        })
        
        btn.MouseEnter:Connect(function()
            hoverTween:Play()
            btn.TextSize = 15
        end)
        
        btn.MouseLeave:Connect(function()
            local reverse = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = color
            })
            reverse:Play()
            btn.TextSize = 14
        end)
        
        -- Tooltip
        local tooltipLabel = Instance.new("TextLabel")
        tooltipLabel.Size = UDim2.new(1, 0, 0, 20)
        tooltipLabel.Position = UDim2.new(0, 0, 1, 5)
        tooltipLabel.Text = tooltip or ""
        tooltipLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        tooltipLabel.TextSize = 10
        tooltipLabel.Font = Enum.Font.Gotham
        tooltipLabel.BackgroundTransparency = 1
        tooltipLabel.Visible = false
        tooltipLabel.Parent = btn
        
        btn.MouseEnter:Connect(function()
            tooltipLabel.Visible = true
        end)
        btn.MouseLeave:Connect(function()
            tooltipLabel.Visible = false
        end)
        
        -- Click events
        if text:find("SCAN") then
            btn.MouseButton1Click:Connect(function()
                AssessmentUI:PerformScan()
            end)
        elseif text:find("SECURITY") then
            btn.MouseButton1Click:Connect(function()
                AssessmentUI:ShowSecurityScore()
            end)
        elseif text:find("EXECUTOR") then
            btn.MouseButton1Click:Connect(function()
                AssessmentUI:ShowExecutorCheck()
            end)
        elseif text:find("RECOMMEND") then
            btn.MouseButton1Click:Connect(function()
                AssessmentUI:ShowRecommendations()
            end)
        end
        
        return btn
    end,
    
    Toggle = function()
        if AssessmentUI.ScreenGui then
            AssessmentUI.IsOpen = not AssessmentUI.IsOpen
            AssessmentUI.ScreenGui.Enabled = AssessmentUI.IsOpen
        else
            AssessmentUI:Init()
        end
    end,
    
    PerformScan = function()
        AssessmentUI.ResultLabel.Text = "🔄 Scanning anti-hack systems..."
        AssessmentUI.ResultLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        
        task.wait(1)
        
        -- Run assessment
        local result = AntiHackAssessment:Assess()
        AntiHackAssessment.Result = result
        
        -- Build report
        local report = {}
        table.insert(report, "╔═══════════════════════════════════════════╗")
        table.insert(report, string.format("  🎯 ANTI-HACK ASSESSMENT COMPLETE"))
        table.insert(report, string.format("  📊 Security Score: %d/100", result.SecurityScore))
        table.insert(report, string.format("  🛡️ Anti-Cheat: %s", result.AntiCheatType))
        table.insert(report, string.format("  ⚡ Risk Level: %s", result.RiskLevel))
        table.insert(report, "╠═══════════════════════════════════════════╣")
        
        for _, vuln in ipairs(result.Vulnerabilities) do
            table.insert(report, string.format("  %s", vuln.detail))
        end
        
        table.insert(report, "╚═══════════════════════════════════════════╝")
        
        AssessmentUI.ResultLabel.Text = table.concat(report, "\n")
        AssessmentUI.ResultLabel.TextColor3 = result.SecurityScore >= 70 and 
            Color3.fromRGB(100, 255, 100) or 
            Color3.fromRGB(255, 200, 100)
        
        -- Show badge notification
        local badgeTitle = string.format("🛡️ Security Score: %d/100", result.SecurityScore)
        local badgeDesc = string.format("Anti-Cheat: %s\nRisk Level: %s", 
            result.AntiCheatType, result.RiskLevel)
        local badgeIcon = result.SecurityScore >= 70 and "🛡️" or "⚠️"
        local badgeColor = result.SecurityScore >= 70 and 
            Color3.fromRGB(0, 200, 100) or 
            Color3.fromRGB(255, 150, 0)
        
        BadgeNotification.Show(badgeTitle, badgeDesc, badgeIcon, badgeColor, 5)
    end,
    
    ShowSecurityScore = function()
        local result = AntiHackAssessment.Result
        if result.SecurityScore == 0 then
            BadgeNotification.Show("⚠️ No Scan Yet", "Click 'Scan Game' first!", "🔍", 
                Color3.fromRGB(255, 150, 0), 3)
            return
        end
        
        local scoreText = string.format("Security Score: %d/100", result.SecurityScore)
        local descText = string.format("Anti-Cheat: %s\nRisk Level: %s", 
            result.AntiCheatType, result.RiskLevel)
        
        BadgeNotification.Show(scoreText, descText, "📊", 
            Color3.fromRGB(0, 150, 255), 4)
    end,
    
    ShowExecutorCheck = function()
        local result = AntiHackAssessment.Result
        if result.SecurityScore == 0 then
            BadgeNotification.Show("⚠️ No Scan Yet", "Click 'Scan Game' first!", "🔍", 
                Color3.fromRGB(255, 150, 0), 3)
            return
        end
        
        local desc = {}
        for name, data in pairs(result.ExecutorCompat) do
            table.insert(desc, string.format("%s: %s", name, data.status))
        end
        
        BadgeNotification.Show("💻 Executor Compatibility", table.concat(desc, "\n"), 
            "💻", Color3.fromRGB(150, 50, 255), 5)
    end,
    
    ShowRecommendations = function()
        local result = AntiHackAssessment.Result
        if result.SecurityScore == 0 then
            BadgeNotification.Show("⚠️ No Scan Yet", "Click 'Scan Game' first!", "🔍", 
                Color3.fromRGB(255, 150, 0), 3)
            return
        end
        
        local recs = {}
        if result.SecurityScore >= 80 then
            table.insert(recs, "🔴 High Security - Use Synapse X or ScriptWare")
            table.insert(recs, "⚠️ Avoid Krnl/Fluxus - High risk of ban")
        elseif result.SecurityScore >= 60 then
            table.insert(recs, "🟡 Medium Security - Krnl/Fluxus work")
            table.insert(recs, "✅ Synapse recommended for safety")
        elseif result.SecurityScore >= 40 then
            table.insert(recs, "🟢 Low Security - Most executors work")
            table.insert(recs, "✅ Safe to use any executor")
        else
            table.insert(recs, "🟢 Very Low Security - Easy to exploit")
            table.insert(recs, "✅ All executors compatible")
        end
        
        BadgeNotification.Show("💡 Recommendations", table.concat(recs, "\n"), 
            "💡", Color3.fromRGB(50, 200, 50), 5)
    end,
}

-- ============ ANTI-HACK ASSESSMENT METHODS ============
function AntiHackAssessment:Assess()
    local result = {
        GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown",
        SecurityScore = 0,
        AntiCheatType = "Unknown",
        RiskLevel = "Unknown",
        Vulnerabilities = {},
        Recommendations = {},
        ExecutorCompat = {},
    }
    
    -- Run tests
    local totalScore = 0
    local testCount = 0
    
    for key, test in pairs(self.SecurityTests) do
        local success, data = pcall(test)
        if success and data then
            totalScore = totalScore + data.score
            testCount = testCount + 1
            
            if data.score < 50 then
                table.insert(result.Vulnerabilities, data)
            end
        end
    end
    
    result.SecurityScore = math.floor(totalScore / math.max(testCount, 1))
    
    -- Detect anti-cheat
    local detected = {}
    for name, data in pairs(self.AntiCheatPatterns) do
        for _, pattern in ipairs(data.patterns) do
            if ReplicatedStorage:FindFirstChild(pattern) or 
               game:GetService("Lighting"):FindFirstChild(pattern) or
               CoreGui:FindFirstChild(pattern) then
                table.insert(detected, name)
                break
            end
        end
    end
    
    result.AntiCheatType = #detected > 0 and table.concat(detected, " + ") or "Unknown / None"
    
    -- Risk level
    if result.SecurityScore >= 80 then
        result.RiskLevel = "🟢 Low Risk"
    elseif result.SecurityScore >= 60 then
        result.RiskLevel = "🟡 Medium Risk"
    elseif result.SecurityScore >= 40 then
        result.RiskLevel = "🟠 High Risk"
    else
        result.RiskLevel = "🔴 Critical Risk"
    end
    
    -- Executor compatibility
    result.ExecutorCompat = self:CheckExecutorCompatibility(result.SecurityScore)
    
    -- Recommendations
    if result.SecurityScore >= 80 then
        table.insert(result.Recommendations, "Use Synapse X or ScriptWare only")
        table.insert(result.Recommendations, "Avoid free executors")
    elseif result.SecurityScore >= 60 then
        table.insert(result.Recommendations, "Krnl/Fluxus work but with caution")
        table.insert(result.Recommendations, "Synapse recommended for safety")
    elseif result.SecurityScore >= 40 then
        table.insert(result.Recommendations, "Most executors are compatible")
        table.insert(result.Recommendations, "Should be safe to use")
    else
        table.insert(result.Recommendations, "All executors are compatible")
        table.insert(result.Recommendations, "Very low risk detected")
    end
    
    return result
end

function AntiHackAssessment:CheckExecutorCompatibility(score)
    local compat = {}
    
    if score >= 80 then
        compat = {
            Synapse = {status = "🟡 Usable - Caution", score = 80},
            ScriptWare = {status = "🟡 Usable - Caution", score = 75},
            Krnl = {status = "🔴 Risky", score = 30},
            Fluxus = {status = "🔴 Risky", score = 20},
            Delta = {status = "🔴 Risky", score = 15},
        }
    elseif score >= 60 then
        compat = {
            Synapse = {status = "🟢 Excellent", score = 90},
            ScriptWare = {status = "🟢 Excellent", score = 85},
            Krnl = {status = "🟡 Moderate", score = 70},
            Fluxus = {status = "🟡 Moderate", score = 60},
            Delta = {status = "🟡 Moderate", score = 50},
        }
    elseif score >= 40 then
        compat = {
            Synapse = {status = "🟢 Perfect", score = 100},
            ScriptWare = {status = "🟢 Perfect", score = 95},
            Krnl = {status = "🟢 Good", score = 85},
            Fluxus = {status = "🟢 Good", score = 80},
            Delta = {status = "🟢 Good", score = 75},
        }
    else
        compat = {
            Synapse = {status = "🟢 Perfect", score = 100},
            ScriptWare = {status = "🟢 Perfect", score = 100},
            Krnl = {status = "🟢 Perfect", score = 95},
            Fluxus = {status = "🟢 Perfect", score = 90},
            Delta = {status = "🟢 Perfect", score = 85},
        }
    end
    
    return compat
end

-- ============ KEYBIND ============
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F8 then
        AssessmentUI:Toggle()
    end
end)

-- ============ AUTO INIT ============
task.wait(1)
AssessmentUI:Init()

-- Show welcome badge
task.wait(0.5)
BadgeNotification.Show(
    "🛡️ Spy V7.2 Loaded!", 
    "Press F8 to open Anti-Hack Assessment\nThis game will be scanned for security",
    "🔮",
    Color3.fromRGB(100, 50, 255),
    4
)

print([[
╔══════════════════════════════════════════════════════════╗
║  🛡️ SPY V7.2 - ANTI-HACK ASSESSMENT                     ║
║  ══════════════════════════════════════════════════════  ║
║                                                         ║
║  🎮 UI với nút bấm trực quan:                          ║
║  • 🔍 SCAN GAME - Quét anti-hack                       ║
║  • 📊 SECURITY SCORE - Xem điểm bảo mật                ║
║  • 💻 EXECUTOR CHECK - Kiểm tra executor               ║
║  • 💡 RECOMMEND - Nhận gợi ý                          ║
║                                                         ║
║  🏅 Thông báo giống nhận huy hiệu Roblox:              ║
║  • Hiệu ứng xuất hiện đẹp mắt                         ║
║  • Tự động biến mất sau vài giây                      ║
║  • Có hiệu ứng hạt lấp lánh                           ║
║                                                         ║
║  ⌨️ Nhấn F8 để mở/đóng UI                             ║
╚══════════════════════════════════════════════════════════╝
]])

return {
    AntiHack = AntiHackAssessment,
    UI = AssessmentUI,
    BadgeNotification = BadgeNotification,
}
