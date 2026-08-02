-- ============ SPY V7.2 - ANTI-HACK ASSESSMENT PRO MAX ============
-- 
-- 🎯 TÍNH NĂNG CHI TIẾT:
-- 1. Phát hiện Anti-Speed (chống chạy nhanh)
-- 2. Phát hiện Anti-Jump (chống nhảy cao)
-- 3. Phát hiện Anti-Fly (chống bay)
-- 4. Phát hiện Anti-Noclip (chống xuyên tường)
-- 5. Phát hiện Anti-Spin (chống xoay)
-- 6. Phát hiện Anti-Teleport (chống dịch chuyển)
-- 7. Phát hiện Anti-GodMode (chống bất tử)
-- 8. Phát hiện Anti-SilentAim (chống tự động ngắm)
-- 9. Phát hiện Anti-SpeedHack (chống tăng tốc)
-- 10. Phát hiện Anti-ClickTeleport (chống teleport click)
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

-- ============ ANTI-HACK DETECTION ENGINE ============
local AntiHackDetector = {
    Version = "7.3.0",
    
    -- Kết quả phát hiện
    DetectionResult = {
        GameName = "",
        SecurityScore = 0,
        AntiCheatType = "Unknown",
        RiskLevel = "Unknown",
        AntiSpeed = {detected = false, confidence = 0, details = ""},
        AntiJump = {detected = false, confidence = 0, details = ""},
        AntiFly = {detected = false, confidence = 0, details = ""},
        AntiNoclip = {detected = false, confidence = 0, details = ""},
        AntiSpin = {detected = false, confidence = 0, details = ""},
        AntiTeleport = {detected = false, confidence = 0, details = ""},
        AntiGodMode = {detected = false, confidence = 0, details = ""},
        AntiSilentAim = {detected = false, confidence = 0, details = ""},
        AntiSpeedHack = {detected = false, confidence = 0, details = ""},
        AntiClickTeleport = {detected = false, confidence = 0, details = ""},
        Vulnerabilities = {},
        Recommendations = {},
        ExecutorCompat = {},
        DetectedAntiCheats = {},
    },
    
    -- ============ PHÁT HIỆN CHI TIẾT ============
    
    -- 1. ANTI-SPEED (chống chạy nhanh)
    DetectAntiSpeed = function()
        local result = {detected = false, confidence = 0, details = ""}
        local checks = 0
        local found = 0
        
        -- Check 1: Remote kiểm tra tốc độ
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("speed") or name:find("velocity") or name:find("movement") or 
                   name:find("walk") or name:find("run") or name:find("sprint") then
                    found = found + 1
                end
            end
        end
        checks = checks + 1
        
        -- Check 2: Script xử lý tốc độ
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                local src = script:FindFirstChild("Source") and script.Source.Value or ""
                if type(src) == "string" then
                    if src:find("WalkSpeed") or src:find("MaxSpeed") or src:find("Velocity") then
                        found = found + 1
                        break
                    end
                end
            end
        end
        checks = checks + 1
        
        -- Check 3: Attribute hoặc Value
        if Player.Character then
            if Player.Character:FindFirstChild("WalkSpeed") or 
               Player.Character:FindFirstChild("MaxSpeed") or
               Player.Character:FindFirstChild("SpeedLimit") then
                found = found + 1
            end
        end
        checks = checks + 1
        
        -- Đánh giá
        local confidence = math.min((found / checks) * 100, 100)
        result.detected = confidence > 30
        result.confidence = confidence
        result.details = string.format("%s detected (confidence: %.1f%%)", 
            result.detected and "✅ Anti-Speed" or "❌ No Anti-Speed", confidence)
        
        return result
    end,
    
    -- 2. ANTI-JUMP (chống nhảy cao)
    DetectAntiJump = function()
        local result = {detected = false, confidence = 0, details = ""}
        local checks = 0
        local found = 0
        
        -- Check remote jump
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("jump") or name:find("jumpheight") or name:find("gravity") then
                    found = found + 1
                end
            end
        end
        checks = checks + 1
        
        -- Check script
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                local src = script:FindFirstChild("Source") and script.Source.Value or ""
                if type(src) == "string" then
                    if src:find("JumpPower") or src:find("JumpHeight") or src:find("Gravity") then
                        found = found + 1
                        break
                    end
                end
            end
        end
        checks = checks + 1
        
        -- Check Character
        if Player.Character then
            if Player.Character:FindFirstChild("JumpPower") or 
               Player.Character:FindFirstChild("JumpHeight") then
                found = found + 1
            end
        end
        checks = checks + 1
        
        local confidence = math.min((found / checks) * 100, 100)
        result.detected = confidence > 30
        result.confidence = confidence
        result.details = string.format("%s (confidence: %.1f%%)", 
            result.detected and "✅ Anti-Jump" or "❌ No Anti-Jump", confidence)
        
        return result
    end,
    
    -- 3. ANTI-FLY (chống bay)
    DetectAntiFly = function()
        local result = {detected = false, confidence = 0, details = ""}
        local checks = 0
        local found = 0
        
        -- Check remote fly
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("fly") or name:find("flight") or name:find("flying") or 
                   name:find("air") or name:find("hover") then
                    found = found + 1
                end
            end
        end
        checks = checks + 1
        
        -- Check script
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                local src = script:FindFirstChild("Source") and script.Source.Value or ""
                if type(src) == "string" then
                    if src:find("Fly") or src:find("Flight") or src:find("Flying") or 
                       src:find("CanFly") or src:find("IsFlying") then
                        found = found + 1
                        break
                    end
                end
            end
        end
        checks = checks + 1
        
        -- Check Humanoid properties
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local humanoid = Player.Character.Humanoid
            if humanoid:FindFirstChild("Fly") or 
               humanoid:FindFirstChild("CanFly") or
               humanoid:FindFirstChild("IsFlying") then
                found = found + 1
            end
        end
        checks = checks + 1
        
        local confidence = math.min((found / checks) * 100, 100)
        result.detected = confidence > 30
        result.confidence = confidence
        result.details = string.format("%s (confidence: %.1f%%)", 
            result.detected and "✅ Anti-Fly" or "❌ No Anti-Fly", confidence)
        
        return result
    end,
    
    -- 4. ANTI-NOCLIP (chống xuyên tường)
    DetectAntiNoclip = function()
        local result = {detected = false, confidence = 0, details = ""}
        local checks = 0
        local found = 0
        
        -- Check remote noclip
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("noclip") or name:find("nocli") or name:find("collision") or 
                   name:find("clip") or name:find("wall") or name:find("phase") then
                    found = found + 1
                end
            end
        end
        checks = checks + 1
        
        -- Check script
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                local src = script:FindFirstChild("Source") and script.Source.Value or ""
                if type(src) == "string" then
                    if src:find("Noclip") or src:find("NoClip") or src:find("Collision") or 
                       src:find("CanCollide") or src:find("Wall") then
                        found = found + 1
                        break
                    end
                end
            end
        end
        checks = checks + 1
        
        local confidence = math.min((found / checks) * 100, 100)
        result.detected = confidence > 30
        result.confidence = confidence
        result.details = string.format("%s (confidence: %.1f%%)", 
            result.detected and "✅ Anti-Noclip" or "❌ No Anti-Noclip", confidence)
        
        return result
    end,
    
    -- 5. ANTI-SPIN (chống xoay)
    DetectAntiSpin = function()
        local result = {detected = false, confidence = 0, details = ""}
        local checks = 0
        local found = 0
        
        -- Check remote spin
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("spin") or name:find("rotate") or name:find("rotation") or 
                   name:find("angle") or name:find("look") or name:find("turn") then
                    found = found + 1
                end
            end
        end
        checks = checks + 1
        
        -- Check script
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                local src = script:FindFirstChild("Source") and script.Source.Value or ""
                if type(src) == "string" then
                    if src:find("Spin") or src:find("Rotate") or src:find("Rotation") or 
                       src:find("Angle") or src:find("TurnSpeed") then
                        found = found + 1
                        break
                    end
                end
            end
        end
        checks = checks + 1
        
        local confidence = math.min((found / checks) * 100, 100)
        result.detected = confidence > 30
        result.confidence = confidence
        result.details = string.format("%s (confidence: %.1f%%)", 
            result.detected and "✅ Anti-Spin" or "❌ No Anti-Spin", confidence)
        
        return result
    end,
    
    -- 6. ANTI-TELEPORT (chống dịch chuyển)
    DetectAntiTeleport = function()
        local result = {detected = false, confidence = 0, details = ""}
        local checks = 0
        local found = 0
        
        -- Check remote teleport
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("teleport") or name:find("tele") or name:find("tp") or 
                   name:find("warp") or name:find("move") or name:find("position") then
                    found = found + 1
                end
            end
        end
        checks = checks + 1
        
        -- Check script
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                local src = script:FindFirstChild("Source") and script.Source.Value or ""
                if type(src) == "string" then
                    if src:find("Teleport") or src:find("Tele") or src:find("Warp") or 
                       src:find("TP") or src:find("Position") then
                        found = found + 1
                        break
                    end
                end
            end
        end
        checks = checks + 1
        
        local confidence = math.min((found / checks) * 100, 100)
        result.detected = confidence > 30
        result.confidence = confidence
        result.details = string.format("%s (confidence: %.1f%%)", 
            result.detected and "✅ Anti-Teleport" or "❌ No Anti-Teleport", confidence)
        
        return result
    end,
    
    -- 7. ANTI-GODMODE (chống bất tử)
    DetectAntiGodMode = function()
        local result = {detected = false, confidence = 0, details = ""}
        local checks = 0
        local found = 0
        
        -- Check remote godmode
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("god") or name:find("invincible") or name:find("immortal") or 
                   name:find("health") or name:find("damage") or name:find("hurt") then
                    found = found + 1
                end
            end
        end
        checks = checks + 1
        
        -- Check script
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                local src = script:FindFirstChild("Source") and script.Source.Value or ""
                if type(src) == "string" then
                    if src:find("God") or src:find("Invincible") or src:find("Immortal") or 
                       src:find("Health") or src:find("Damage") or src:find("Hurt") then
                        found = found + 1
                        break
                    end
                end
            end
        end
        checks = checks + 1
        
        local confidence = math.min((found / checks) * 100, 100)
        result.detected = confidence > 30
        result.confidence = confidence
        result.details = string.format("%s (confidence: %.1f%%)", 
            result.detected and "✅ Anti-GodMode" or "❌ No Anti-GodMode", confidence)
        
        return result
    end,
    
    -- 8. ANTI-SILENT AIM (chống tự động ngắm)
    DetectAntiSilentAim = function()
        local result = {detected = false, confidence = 0, details = ""}
        local checks = 0
        local found = 0
        
        -- Check remote aim
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("aim") or name:find("target") or name:find("lock") or 
                   name:find("shoot") or name:find("bullet") or name:find("fire") then
                    found = found + 1
                end
            end
        end
        checks = checks + 1
        
        -- Check script
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                local src = script:FindFirstChild("Source") and script.Source.Value or ""
                if type(src) == "string" then
                    if src:find("Aim") or src:find("Target") or src:find("Lock") or 
                       src:find("Shoot") or src:find("Bullet") or src:find("Fire") then
                        found = found + 1
                        break
                    end
                end
            end
        end
        checks = checks + 1
        
        local confidence = math.min((found / checks) * 100, 100)
        result.detected = confidence > 30
        result.confidence = confidence
        result.details = string.format("%s (confidence: %.1f%%)", 
            result.detected and "✅ Anti-SilentAim" or "❌ No Anti-SilentAim", confidence)
        
        return result
    end,
    
    -- 9. ANTI-SPEEDHACK (chống tăng tốc)
    DetectAntiSpeedHack = function()
        local result = {detected = false, confidence = 0, details = ""}
        local checks = 0
        local found = 0
        
        -- Check remote speedhack
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("speedhack") or name:find("hack") or name:find("cheat") or 
                   name:find("detect") or name:find("anti") then
                    found = found + 1
                end
            end
        end
        checks = checks + 1
        
        -- Check script
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                local src = script:FindFirstChild("Source") and script.Source.Value or ""
                if type(src) == "string" then
                    if src:find("SpeedHack") or src:find("AntiCheat") or src:find("Detect") then
                        found = found + 1
                        break
                    end
                end
            end
        end
        checks = checks + 1
        
        local confidence = math.min((found / checks) * 100, 100)
        result.detected = confidence > 30
        result.confidence = confidence
        result.details = string.format("%s (confidence: %.1f%%)", 
            result.detected and "✅ Anti-SpeedHack" or "❌ No Anti-SpeedHack", confidence)
        
        return result
    end,
    
    -- 10. ANTI-CLICK TELEPORT (chống teleport click)
    DetectAntiClickTeleport = function()
        local result = {detected = false, confidence = 0, details = ""}
        local checks = 0
        local found = 0
        
        -- Check remote click teleport
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("click") or name:find("mouse") or name:find("teleport") or 
                   name:find("move") or name:find("goto") or name:find("walkto") then
                    found = found + 1
                end
            end
        end
        checks = checks + 1
        
        -- Check script
        for _, script in pairs(Workspace:GetChildren()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                local src = script:FindFirstChild("Source") and script.Source.Value or ""
                if type(src) == "string" then
                    if src:find("Click") or src:find("Mouse") or src:find("Goto") or 
                       src:find("WalkTo") then
                        found = found + 1
                        break
                    end
                end
            end
        end
        checks = checks + 1
        
        local confidence = math.min((found / checks) * 100, 100)
        result.detected = confidence > 30
        result.confidence = confidence
        result.details = string.format("%s (confidence: %.1f%%)", 
            result.detected and "✅ Anti-ClickTeleport" or "❌ No Anti-ClickTeleport", confidence)
        
        return result
    end,
    
    -- ============ FULL SCAN ============
    FullScan = function()
        print("🔄 Scanning anti-hack systems...")
        
        local result = AntiHackDetector.DetectionResult
        result.GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown"
        
        -- Run all detections
        result.AntiSpeed = AntiHackDetector:DetectAntiSpeed()
        result.AntiJump = AntiHackDetector:DetectAntiJump()
        result.AntiFly = AntiHackDetector:DetectAntiFly()
        result.AntiNoclip = AntiHackDetector:DetectAntiNoclip()
        result.AntiSpin = AntiHackDetector:DetectAntiSpin()
        result.AntiTeleport = AntiHackDetector:DetectAntiTeleport()
        result.AntiGodMode = AntiHackDetector:DetectAntiGodMode()
        result.AntiSilentAim = AntiHackDetector:DetectAntiSilentAim()
        result.AntiSpeedHack = AntiHackDetector:DetectAntiSpeedHack()
        result.AntiClickTeleport = AntiHackDetector:DetectAntiClickTeleport()
        
        -- Calculate total security score
        local totalScore = 0
        local count = 0
        
        local detections = {
            result.AntiSpeed,
            result.AntiJump,
            result.AntiFly,
            result.AntiNoclip,
            result.AntiSpin,
            result.AntiTeleport,
            result.AntiGodMode,
            result.AntiSilentAim,
            result.AntiSpeedHack,
            result.AntiClickTeleport,
        }
        
        for _, detection in ipairs(detections) do
            if detection.detected then
                totalScore = totalScore + detection.confidence
            else
                totalScore = totalScore + (100 - detection.confidence) * 0.3
            end
            count = count + 1
        end
        
        result.SecurityScore = math.floor(totalScore / count)
        
        -- Risk level
        if result.SecurityScore >= 80 then
            result.RiskLevel = "🔴 HIGH - Strong anti-hack"
        elseif result.SecurityScore >= 60 then
            result.RiskLevel = "🟡 MEDIUM - Moderate protection"
        elseif result.SecurityScore >= 40 then
            result.RiskLevel = "🟢 LOW - Weak protection"
        else
            result.RiskLevel = "✅ VERY LOW - Almost no protection"
        end
        
        -- Detect general anti-cheat
        result.AntiCheatType = AntiHackDetector:DetectAntiCheatType()
        
        -- Generate recommendations
        result.Recommendations = AntiHackDetector:GenerateRecommendations(result)
        
        -- Executor compatibility
        result.ExecutorCompat = AntiHackDetector:CheckExecutorCompatibility(result.SecurityScore)
        
        print("✅ Scan complete!")
        return result
    end,
    
    -- ============ DETECT ANTI-CHEAT TYPE ============
    DetectAntiCheatType = function()
        local patterns = {
            Byfron = {"Byfron", "Hyperion", "AntiTamper", "RobloxSecurity"},
            EasyAntiCheat = {"EAC", "EasyAntiCheat", "AntiCheatClient"},
            BattlEye = {"BattlEye", "BE_Server", "AntiCheatService"},
            RobloxBuiltIn = {"RobloxSecurity", "CoreSecurity", "ProtectedCall"},
            Custom = {"AntiCheat", "AntiHack", "SecurityCheck", "Watchdog"},
        }
        
        local detected = {}
        for name, patternList in pairs(patterns) do
            for _, pattern in ipairs(patternList) do
                if ReplicatedStorage:FindFirstChild(pattern) or 
                   game:GetService("Lighting"):FindFirstChild(pattern) or
                   CoreGui:FindFirstChild(pattern) then
                    table.insert(detected, name)
                    break
                end
            end
        end
        
        return #detected > 0 and table.concat(detected, " + ") or "Unknown / None"
    end,
    
    -- ============ GENERATE RECOMMENDATIONS ============
    GenerateRecommendations = function(result)
        local recs = {}
        
        if result.AntiSpeed.detected and result.AntiSpeed.confidence > 70 then
            table.insert(recs, "⚠️ Anti-Speed is strong - avoid speed hacks")
        end
        
        if result.AntiJump.detected and result.AntiJump.confidence > 70 then
            table.insert(recs, "⚠️ Anti-Jump is strong - avoid jump hacks")
        end
        
        if result.AntiFly.detected and result.AntiFly.confidence > 70 then
            table.insert(recs, "⚠️ Anti-Fly is strong - avoid fly hacks")
        end
        
        if result.AntiNoclip.detected and result.AntiNoclip.confidence > 70 then
            table.insert(recs, "⚠️ Anti-Noclip is strong - avoid wall hacks")
        end
        
        if result.SecurityScore >= 80 then
            table.insert(recs, "🔴 High security - use only Synapse X or ScriptWare")
            table.insert(recs, "❌ Avoid free executors - high ban risk")
        elseif result.SecurityScore >= 60 then
            table.insert(recs, "🟡 Medium security - Krnl/Fluxus may work with caution")
            table.insert(recs, "✅ Synapse recommended for safety")
        else
            table.insert(recs, "🟢 Low security - most executors are compatible")
            table.insert(recs, "✅ Safe to use any executor")
        end
        
        return recs
    end,
    
    -- ============ CHECK EXECUTOR COMPATIBILITY ============
    CheckExecutorCompatibility = function(score)
        local compat = {}
        
        if score >= 80 then
            compat = {
                Synapse = {status = "🟡 Usable - High risk", score = 70},
                ScriptWare = {status = "🟡 Usable - High risk", score = 65},
                Krnl = {status = "🔴 Risky - Avoid", score = 25},
                Fluxus = {status = "🔴 Risky - Avoid", score = 20},
                Delta = {status = "🔴 Risky - Avoid", score = 15},
                Arceus = {status = "🔴 Risky - Avoid", score = 10},
            }
        elseif score >= 60 then
            compat = {
                Synapse = {status = "🟢 Good", score = 85},
                ScriptWare = {status = "🟢 Good", score = 80},
                Krnl = {status = "🟡 Moderate", score = 65},
                Fluxus = {status = "🟡 Moderate", score = 55},
                Delta = {status = "🟡 Moderate", score = 45},
                Arceus = {status = "🟡 Moderate", score = 40},
            }
        elseif score >= 40 then
            compat = {
                Synapse = {status = "🟢 Excellent", score = 95},
                ScriptWare = {status = "🟢 Excellent", score = 90},
                Krnl = {status = "🟢 Good", score = 85},
                Fluxus = {status = "🟢 Good", score = 80},
                Delta = {status = "🟢 Good", score = 75},
                Arceus = {status = "🟢 Good", score = 70},
            }
        else
            compat = {
                Synapse = {status = "🟢 Perfect", score = 100},
                ScriptWare = {status = "🟢 Perfect", score = 100},
                Krnl = {status = "🟢 Perfect", score = 95},
                Fluxus = {status = "🟢 Perfect", score = 95},
                Delta = {status = "🟢 Perfect", score = 90},
                Arceus = {status = "🟢 Perfect", score = 85},
            }
        end
        
        return compat
    end,
}

-- ============ BADGE NOTIFICATION ============
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
        
        -- Animation IN
        notif.Position = UDim2.new(0.5, -275, 0.5, 300)
        notif.BackgroundTransparency = 1
        
        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -275, 0.5, 200),
            BackgroundTransparency = 0.1,
        }):Play()
        
        TweenService:Create(progressFill, TweenInfo.new(duration or 4, Enum.EasingStyle.Linear), {
            Size = UDim2.new(1, 0, 1, 0),
        }):Play()
        
        task.wait(duration or 4)
        
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
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

-- ============ UI WITH BUTTONS ============
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
        AssessmentUI.ScreenGui.Name = "AntiHackAssessmentUI"
        AssessmentUI.ScreenGui.Parent = CoreGui
        AssessmentUI.ScreenGui.ResetOnSpawn = false
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 500, 0, 650)
        frame.Position = UDim2.new(0.5, -250, 0.5, -325)
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
        frame.BackgroundTransparency = 0.05
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.Parent = AssessmentUI.ScreenGui
        AssessmentUI.MainFrame = frame
        
        -- Title
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 45)
        titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -40, 1, 0)
        title.Text = "🛡️ Anti-Hack Assessment PRO"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 18
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.GothamBold
        title.BackgroundTransparency = 1
        title.Parent = titleBar
        
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
        
        -- Buttons
        local btnY = 55
        local btnHeight = 38
        local btnGap = 5
        
        local buttons = {
            {text = "🔍 SCAN ANTI-HACK", color = Color3.fromRGB(0, 150, 255), hover = Color3.fromRGB(0, 100, 200)},
            {text = "⚠️ CHECK EXPLOITS", color = Color3.fromRGB(255, 100, 0), hover = Color3.fromRGB(200, 80, 0)},
            {text = "💻 EXECUTOR CHECK", color = Color3.fromRGB(150, 50, 255), hover = Color3.fromRGB(100, 0, 200)},
            {text = "📊 SHOW SCORE", color = Color3.fromRGB(0, 200, 100), hover = Color3.fromRGB(0, 150, 50)},
        }
        
        for i, btnData in ipairs(buttons) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 220, 0, btnHeight)
            btn.Position = UDim2.new(0.5, -110, 0, btnY + (i-1) * (btnHeight + btnGap))
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
                    AssessmentUI:FullScan()
                end)
            elseif i == 2 then
                btn.MouseButton1Click:Connect(function()
                    AssessmentUI:ShowExploitCheck()
                end)
            elseif i == 3 then
                btn.MouseButton1Click:Connect(function()
                    AssessmentUI:ShowExecutorCheck()
                end)
            elseif i == 4 then
                btn.MouseButton1Click:Connect(function()
                    AssessmentUI:ShowScore()
                end)
            end
        end
        
        -- Result display
        local resultFrame = Instance.new("ScrollingFrame")
        resultFrame.Size = UDim2.new(1, -20, 1, -215)
        resultFrame.Position = UDim2.new(0, 10, 0, 205)
        resultFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
        resultFrame.BackgroundTransparency = 0.5
        resultFrame.BorderSizePixel = 0
        resultFrame.Parent = frame
        
        local resultLabel = Instance.new("TextLabel")
        resultLabel.Size = UDim2.new(1, -10, 1, -10)
        resultLabel.Position = UDim2.new(0, 5, 0, 5)
        resultLabel.Text = "👆 Click 'SCAN ANTI-HACK' to check all anti-hack systems\n\nThe scan will detect:\n• Anti-Speed • Anti-Jump • Anti-Fly\n• Anti-Noclip • Anti-Spin • Anti-Teleport\n• Anti-GodMode • Anti-SilentAim\n• Anti-SpeedHack • Anti-ClickTeleport"
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
    
    FullScan = function()
        AssessmentUI.ResultLabel.Text = "🔄 Scanning all anti-hack systems...\nPlease wait..."
        AssessmentUI.ResultLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        
        task.wait(1.5)
        
        local result = AntiHackDetector:FullScan()
        
        -- Build report
        local report = {}
        table.insert(report, "╔═══════════════════════════════════════════════════════╗")
        table.insert(report, string.format("  🎯 %s", result.GameName))
        table.insert(report, string.format("  🛡️ Anti-Cheat: %s", result.AntiCheatType))
        table.insert(report, string.format("  📊 Security Score: %d/100", result.SecurityScore))
        table.insert(report, string.format("  ⚡ Risk Level: %s", result.RiskLevel))
        table.insert(report, "╠═══════════════════════════════════════════════════════╣")
        
        -- List all detections
        local detections = {
            {name = "Anti-Speed", data = result.AntiSpeed},
            {name = "Anti-Jump", data = result.AntiJump},
            {name = "Anti-Fly", data = result.AntiFly},
            {name = "Anti-Noclip", data = result.AntiNoclip},
            {name = "Anti-Spin", data = result.AntiSpin},
            {name = "Anti-Teleport", data = result.AntiTeleport},
            {name = "Anti-GodMode", data = result.AntiGodMode},
            {name = "Anti-SilentAim", data = result.AntiSilentAim},
            {name = "Anti-SpeedHack", data = result.AntiSpeedHack},
            {name = "Anti-ClickTeleport", data = result.AntiClickTeleport},
        }
        
        for _, detection in ipairs(detections) do
            local icon = detection.data.detected and "✅" or "❌"
            table.insert(report, string.format("  %s %s (%.0f%%)", 
                icon, detection.name, detection.data.confidence))
        end
        
        table.insert(report, "╠═══════════════════════════════════════════════════════╣")
        
        if #result.Recommendations > 0 then
            table.insert(report, "  💡 RECOMMENDATIONS:")
            for _, rec in ipairs(result.Recommendations) do
                table.insert(report, string.format("    %s", rec))
            end
        end
        
        table.insert(report, "╚═══════════════════════════════════════════════════════╝")
        
        AssessmentUI.ResultLabel.Text = table.concat(report, "\n")
        AssessmentUI.ResultLabel.TextColor3 = result.SecurityScore >= 70 and 
            Color3.fromRGB(100, 255, 100) or 
            Color3.fromRGB(255, 200, 100)
        
        -- Show badge
        BadgeNotification.Show(
            string.format("🛡️ Security Score: %d/100", result.SecurityScore),
            string.format("Anti-Cheat: %s\nRisk Level: %s", 
                result.AntiCheatType, result.RiskLevel),
            result.SecurityScore >= 70 and "🛡️" or "⚠️",
            result.SecurityScore >= 70 and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(255, 150, 0),
            5
        )
    end,
    
    ShowExploitCheck = function()
        local result = AntiHackDetector.DetectionResult
        
        if result.SecurityScore == 0 then
            BadgeNotification.Show("⚠️ No Scan Yet", "Click 'SCAN ANTI-HACK' first!", "🔍", 
                Color3.fromRGB(255, 150, 0), 3)
            return
        end
        
        local desc = {}
        table.insert(desc, "⚠️ ANTI-EXPLOIT DETECTION:")
        
        local exploits = {
            {name = "Speed Hack", detected = result.AntiSpeed.detected, conf = result.AntiSpeed.confidence},
            {name = "Jump Hack", detected = result.AntiJump.detected, conf = result.AntiJump.confidence},
            {name = "Fly Hack", detected = result.AntiFly.detected, conf = result.AntiFly.confidence},
            {name = "Noclip", detected = result.AntiNoclip.detected, conf = result.AntiNoclip.confidence},
            {name = "Spin Hack", detected = result.AntiSpin.detected, conf = result.AntiSpin.confidence},
            {name = "Teleport", detected = result.AntiTeleport.detected, conf = result.AntiTeleport.confidence},
            {name = "GodMode", detected = result.AntiGodMode.detected, conf = result.AntiGodMode.confidence},
        }
        
        for _, exp in ipairs(exploits) do
            local icon = exp.detected and "🔴" or "🟢"
            table.insert(desc, string.format("%s %s (%.0f%%)", icon, exp.name, exp.conf))
        end
        
        BadgeNotification.Show("⚠️ Exploit Protection Check", table.concat(desc, "\n"), 
            "⚠️", Color3.fromRGB(255, 100, 50), 6)
    end,
    
    ShowExecutorCheck = function()
        local result = AntiHackDetector.DetectionResult
        
        if result.SecurityScore == 0 then
            BadgeNotification.Show("⚠️ No Scan Yet", "Click 'SCAN ANTI-HACK' first!", "🔍", 
                Color3.fromRGB(255, 150, 0), 3)
            return
        end
        
        local desc = {"💻 EXECUTOR COMPATIBILITY:"}
        for name, data in pairs(result.ExecutorCompat) do
            table.insert(desc, string.format("%s: %s", name, data.status))
        end
        
        BadgeNotification.Show("💻 Executor Check", table.concat(desc, "\n"), 
            "💻", Color3.fromRGB(150, 50, 255), 5)
    end,
    
    ShowScore = function()
        local result = AntiHackDetector.DetectionResult
        
        if result.SecurityScore == 0 then
            BadgeNotification.Show("⚠️ No Scan Yet", "Click 'SCAN ANTI-HACK' first!", "🔍", 
                Color3.fromRGB(255, 150, 0), 3)
            return
        end
        
        BadgeNotification.Show(
            string.format("📊 Security Score: %d/100", result.SecurityScore),
            string.format("Anti-Cheat: %s\nRisk Level: %s", 
                result.AntiCheatType, result.RiskLevel),
            "📊",
            Color3.fromRGB(0, 150, 255),
            4
        )
    end,
}

-- ============ KEYBIND ============
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F8 then
        AssessmentUI:Toggle()
    end
end)

-- ============ AUTO START ============
task.wait(1)
AssessmentUI:Init()

BadgeNotification.Show(
    "🛡️ Spy V7.3 PRO MAX Loaded!",
    "Press F8 to open Anti-Hack Assessment\nDetects 10+ anti-hack systems",
    "🔮",
    Color3.fromRGB(100, 50, 255),
    4
)

print([[
╔══════════════════════════════════════════════════════════════════╗
║  🛡️ SPY V7.2 - ANTI-HACK ASSESSMENT PRO MAX                    ║
║  ════════════════════════════════════════════════════════════  ║
║                                                               ║
║  🎯 DETECTS 10 ANTI-HACK TYPES:                               ║
║  • Anti-Speed • Anti-Jump • Anti-Fly                         ║
║  • Anti-Noclip • Anti-Spin • Anti-Teleport                   ║
║  • Anti-GodMode • Anti-SilentAim                             ║
║  • Anti-SpeedHack • Anti-ClickTeleport                       ║
║                                                               ║
║  📊 HIỂN THỊ CHI TIẾT:                                       ║
║  • Có hay không từng loại anti-hack                          ║
║  • Độ tin cậy (confidence %)                                  ║
║  • Điểm bảo mật tổng thể                                     ║
║  • Khuyến nghị sử dụng                                       ║
║                                                               ║
║  ⌨️ Nhấn F8 để mở UI                                        ║
╚══════════════════════════════════════════════════════════════════╝
]])

return {
    AntiHackDetector = AntiHackDetector,
    UI = AssessmentUI,
    BadgeNotification = BadgeNotification,
}
