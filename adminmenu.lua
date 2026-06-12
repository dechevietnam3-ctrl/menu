local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService") -- Cần thiết cho Auto-Rejoin/Leave
local GuiService = game:GetService("GuiService")          -- Cần thiết để bắt lỗi Kick

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera 

-- Khử trùng lặp UI cũ chống tràn RAM
local oldGui = Player:WaitForChild("PlayerGui"):FindFirstChild("PremiumMenu_v6_Ultra")
if oldGui then oldGui:Destroy() end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumMenu_v6_Ultra"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Nút mở/tắt menu ngoài màn hình
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -27)
ToggleButton.Text = "☰"
ToggleButton.TextScaled = true
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.ZIndex = 10

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1,0)
ToggleCorner.Parent = ToggleButton 

-- Frame chính
-- Frame chính
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 350, 0, 500)
Frame.Position = UDim2.new(0.5, -175, 0.5, -250)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.ClipsDescendants = true
Frame.Visible = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 16)
FrameCorner.Parent = Frame

-- Thanh tiêu đề
local TitleBar = Instance.new("TextButton")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundTransparency = 1
TitleBar.Text = ""
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ OWNER ADMIN MENU V6.2 PRO MAX ⚡"
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold

-- Nút đóng (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -38, 0, 11)
CloseButton.Text = "✕"
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BackgroundColor3 = Color3.fromRGB(240, 50, 50)
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.ZIndex = 5

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Thùng chứa cuộn (Đã tăng CanvasSize để chứa các nút Troll mới)
local Container = Instance.new("ScrollingFrame")
Container.Parent = Frame
Container.Size = UDim2.new(1, -10, 1, -65)
Container.Position = UDim2.new(0, 5, 0, 55)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 1800) 
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

-- THÊM ĐOẠN NÀY VÀO
local GridLayout = Instance.new("UIGridLayout")
GridLayout.Parent = Container
GridLayout.CellSize = UDim2.new(0, 140, 0, 40) -- Kích thước mỗi nút (Rộng, Cao)
GridLayout.CellPadding = UDim2.new(0, 10, 0, 10) -- Khoảng cách giữa các nút
GridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- HÀM TẠO NÚT
local function createMenuButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.Size = UDim2.new(0, 310, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local originalColor = btn.BackgroundColor3
    local hoverColor = Color3.fromRGB(
        math.min(originalColor.R * 255 + 20, 255),
        math.min(originalColor.G * 255 + 20, 255),
        math.min(originalColor.B * 255 + 20, 255)
    )
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = originalColor}):Play()
    end)
    
    return btn
end

----------------------------------------------------
-- QUẢN LÝ TRẠNG THÁI TOÀN CỤC
----------------------------------------------------
local speedState = 0
local jumpState = false
local doubleJumpActive = false
local infJumpActive = false
local killAuraActive = false
local hitboxActive = false
local spinBotActive = false
local antiRagdollActive = false
local aimbotActive = false
local camLockActive = false
local noclip = false
local flying = false
local waterWalkActive = false
local fovState = 0
local autoFarmActive = false
local godMode = false
local espActive = false
local triggerBotActive = false
local antiKillActive = false
local infiniteOxygenActive = false
local fullBrightActive = false
local originalAmbient, originalOutdoorAmbient

-- Trạng thái Troll mới
local flingActive = false
local annoyActive = false
local spamChatActive = false

----------------------------------------------------
-- TẠO CÁC NÚT CHỨC NĂNG CƠ BẢN
----------------------------------------------------
local SpeedButton      = createMenuButton("⚡ Tốc Độ: Bình Thường", Color3.fromRGB(230, 126, 34))
local JumpButton       = createMenuButton("🦘 Sức Nhảy: Bình Thường", Color3.fromRGB(46, 204, 113))
local DoubleJumpBtn    = createMenuButton("🚀 Nhảy Kép: TẮT", Color3.fromRGB(44, 62, 80))
local InfJumpButton    = createMenuButton("🌌 Nhảy Vô Hạn: TẮT", Color3.fromRGB(52, 73, 94)) 
local KillAuraButton   = createMenuButton("⚔️ Kill Aura (Bán kính 20): TẮT", Color3.fromRGB(142, 68, 173)) 
local HitboxButton     = createMenuButton("⭕ Phóng To Hitbox Địch: TẮT", Color3.fromRGB(211, 84, 0))
local SpinBotButton    = createMenuButton("🔄 Spin Bot (Xoay tròn): TẮT", Color3.fromRGB(22, 160, 133)) 
local AntiRagdollBtn   = createMenuButton("🏋️ Chống Té Ngã: TẮT", Color3.fromRGB(127, 140, 141))
local AimbotButton     = createMenuButton("🎯 Khóa Mục Tiêu (R-Click): TẮT", Color3.fromRGB(231, 76, 60))
local CamLockBtn       = createMenuButton("🔒 Cam Lock (Khóa cứng Camera): TẮT", Color3.fromRGB(192, 57, 43))
local TriggerBotBtn    = createMenuButton("🤖 Trigger Bot (Tự Click Khi Thấy Địch): TẮT", Color3.fromRGB(41, 128, 185))
local AntiKillBtn      = createMenuButton("🚨 Chống Chết khẩn cấp (Máu < 25%): TẮT", Color3.fromRGB(192, 41, 43))
local NoclipButton     = createMenuButton("👻 Đi Xuyên Tường: TẮT", Color3.fromRGB(155, 89, 182))
local FlyButton        = createMenuButton("🕊️ Chế Độ Bay v4 (Giữ E để Boost): TẮT", Color3.fromRGB(52, 152, 219))
local WaterWalkBtn     = createMenuButton("🌊 Chạy Trên Nước (Jesus): TẮT", Color3.fromRGB(41, 128, 185))
local FovButton        = createMenuButton("👁️ Góc Nhìn (FOV): Thường (70)", Color3.fromRGB(149, 165, 166))
local AutoFarmBtn      = createMenuButton("💰 Tự Động Nhặt Đồ Gần Đây: TẮT", Color3.fromRGB(243, 156, 18))
local GodButton        = createMenuButton("🛡️ Chế Độ Bất Tử: TẮT", Color3.fromRGB(192, 57, 43))
local EspButton        = createMenuButton("👁️ Nhìn Xuyên Tường (ESP): TẮT", Color3.fromRGB(241, 196, 15))
local InfOxygenBtn     = createMenuButton("🤿 Vô Hạn Ô-xy (Dưới nước): TẮT", Color3.fromRGB(34, 166, 179))
local FullBrightBtn    = createMenuButton("💡 FullBright (Sáng Đêm): TẮT", Color3.fromRGB(241, 196, 15))
local MoonGravityBtn   = createMenuButton("🌕 Trọng Lực Thấp (Moon): TẮT", Color3.fromRGB(149, 165, 166))
local NightModeBtn     = createMenuButton("🌙 Chế Độ Ban Đêm: TẮT", Color3.fromRGB(44, 62, 80))
local GhostModeBtn     = createMenuButton("👻 Chế Độ Tàng Hình: TẮT", Color3.fromRGB(127, 140, 141))
local AutoClickBtn     = createMenuButton("🖱️ Auto Clicker: TẮT", Color3.fromRGB(230, 126, 34)) 
local BringAllBtn      = createMenuButton("👥 Kéo Mọi Người Đến Đây", Color3.fromRGB(155, 89, 182))
local RainbowBtn       = createMenuButton("🌈 Nhân Vật Cầu Vồng: TẮT", Color3.fromRGB(231, 76, 60))
local FreezeBtn        = createMenuButton("❄️ Đóng Băng Nhân Vật: TẮT", Color3.fromRGB(52, 152, 219)) 
local XRayBtn          = createMenuButton("🕶️ X-Ray (Nhìn xuyên tường): TẮT", Color3.fromRGB(52, 73, 94))
local SpectateBtn      = createMenuButton("👀 Theo Dõi Người Khác: TẮT", Color3.fromRGB(155, 89, 182))
local NpcEspBtn        = createMenuButton("🤖 ESP NPCs: TẮT", Color3.fromRGB(243, 156, 18)) 
local AutoRejoinBtn    = createMenuButton("🛡️ Auto-Rejoin (Nếu bị Kick): TẮT", Color3.fromRGB(192, 57, 43))
local StaffDetectBtn   = createMenuButton("🕵️ Staff Detector: TẮT", Color3.fromRGB(241, 196, 15))
local AutoLeaveBtn     = createMenuButton("🏃 Auto-Leave (Khi gặp Staff): TẮT", Color3.fromRGB(230, 126, 34)) 
local FPSBtn       = createMenuButton("🚀 FPS Booster: TẮT", Color3.fromRGB(41, 128, 185))
local PingLabel    = createMenuButton("📡 Ping: Đang đo...", Color3.fromRGB(127, 140, 141)) -- Cái này sẽ cập nhật liên tục
local HopperBtn    = createMenuButton("🔄 Server Hopper", Color3.fromRGB(142, 68, 173))
local CleanBtn     = createMenuButton("🧹 Dọn Rác (Lag): TẮT", Color3.fromRGB(231, 76, 60)) 

----------------------------------------------------
-- TẠO CÁC NÚT TROLL (MỚI)
----------------------------------------------------
local FlingBtn         = createMenuButton("🌪️ Fling (Xoay Chạm Văng Địch): TẮT", Color3.fromRGB(230, 50, 50))
local AnnoyBtn         = createMenuButton("🐒 Đu Bám Người Khác: TẮT", Color3.fromRGB(155, 89, 182))
local SpamChatBtn      = createMenuButton("💬 Chat Spammer: TẮT", Color3.fromRGB(52, 152, 219))

local DeleteToolBtn    = createMenuButton("💥 Nhận Tool Click Xóa Vật Thể", Color3.fromRGB(211, 84, 0))
local TeleportToolBtn  = createMenuButton("🛠️ Nhận Tool Click Dịch Chuyển", Color3.fromRGB(39, 174, 96)) 
local TeleportBtn      = createMenuButton("🌀 Dịch Chuyển Đến Người Chơi", Color3.fromRGB(26, 188, 156))
local InfoClickTP      = createMenuButton("⌨️ Mẹo: RightShift ẩn menu / Ctrl+Click TP", Color3.fromRGB(80, 80, 80))

-- Hàm áp dụng trạng thái khi hồi sinh
local function applyCharacterStats(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    task.wait(0.2)
    if speedState == 1 then humanoid.WalkSpeed = 50
    elseif speedState == 2 then humanoid.WalkSpeed = 150 end
    if jumpState then humanoid.UseJumpPower = true; humanoid.JumpPower = 150 end
end

Player.CharacterAdded:Connect(applyCharacterStats)
if Player.Character then applyCharacterStats(Player.Character) end

-- Đóng mở Menu mượt mà
local menuTweening = false
local function setMenuVisible(visible)
    if menuTweening then return end
    menuTweening = true
    if visible then
        Frame.Visible = true
        local tw = TweenService:Create(Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 350, 0, 500)})
        tw:Play()
        tw.Completed:Connect(function() menuTweening = false end)
    else
        local tw = TweenService:Create(Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 350, 0, 0)})
        tw:Play()
        tw.Completed:Connect(function() Frame.Visible = false; menuTweening = false end)
    end
end

----------------------------------------------------
-- LOGIC CHI TIẾT CÁC CHỨC NĂNG
----------------------------------------------------

-- Tốc Độ & Nhảy
SpeedButton.MouseButton1Click:Connect(function()
    speedState = (speedState + 1) % 3
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if speedState == 0 then
        if humanoid then humanoid.WalkSpeed = 16 end
        SpeedButton.Text = "⚡ Tốc Độ: Bình Thường"
    elseif speedState == 1 then
        if humanoid then humanoid.WalkSpeed = 50 end
        SpeedButton.Text = "⚡ Tốc Độ: Nhanh (50)"
    else
        if humanoid then humanoid.WalkSpeed = 150 end
        SpeedButton.Text = "⚡ Tốc Độ: Bàn Thờ (150)"
    end
end)

JumpButton.MouseButton1Click:Connect(function()
    jumpState = not jumpState
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if jumpState then
        if humanoid then humanoid.UseJumpPower = true; humanoid.JumpPower = 150 end
        JumpButton.Text = "🦘 Sức Nhảy: Cao (150)"
    else
        if humanoid then humanoid.JumpPower = 50 end
        JumpButton.Text = "🦘 Sức Nhảy: Bình Thường"
    end
end)

-- Nhảy kép & Vô hạn
local hasDoubleJumped = false
local lastJumpTime = 0

DoubleJumpBtn.MouseButton1Click:Connect(function()
    doubleJumpActive = not doubleJumpActive
    if doubleJumpActive then
        infJumpActive = false
        InfJumpButton.Text = "🌌 Nhảy Vô Hạn: TẮT"
        InfJumpButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
        DoubleJumpBtn.Text = "🚀 Nhảy Kép: BẬT"
        DoubleJumpBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        DoubleJumpBtn.Text = "🚀 Nhảy Kép: TẮT"
        DoubleJumpBtn.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
    end
end)

-- [FUNC] STAFF DETECTOR & AUTO-LEAVE
local staffDetectActive = false
local autoLeaveActive = false

local function checkStaff(plr)
    local name = string.lower(plr.Name)
    local display = string.lower(plr.DisplayName)
    return string.find(name, "admin") or string.find(display, "admin") or string.find(name, "mod") or string.find(name, "dev")
end

local function handleStaff(plr)
    if staffDetectActive and checkStaff(plr) then
        if autoLeaveActive then TeleportService:Teleport(game.PlaceId, Player) end
    end
end

Players.PlayerAdded:Connect(handleStaff)
for _, plr in pairs(Players:GetPlayers()) do handleStaff(plr) end

-- [FUNC] AUTO-REJOIN (KICK PROTECTION)
local autoRejoinActive = false
GuiService.ErrorMessageChanged:Connect(function()
    if autoRejoinActive and GuiService:GetErrorMessage() ~= "" then
        TeleportService:Teleport(game.PlaceId, Player)
    end
end)

-- [FUNC] AUTO CLEANER (FPS BOOST)
local cleanActive = false
RunService.Heartbeat:Connect(function()
    if cleanActive then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                obj:Destroy()
            end
        end
    end
end) 

InfJumpButton.MouseButton1Click:Connect(function()
    infJumpActive = not infJumpActive
    if infJumpActive then
        doubleJumpActive = false
        DoubleJumpBtn.Text = "🚀 Nhảy Kép: TẮT"
        DoubleJumpBtn.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
        InfJumpButton.Text = "🌌 Nhảy Vô Hạn: BẬT"
        InfJumpButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        InfJumpButton.Text = "🌌 Nhảy Vô Hạn: TẮT"
        InfJumpButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
    end
end)

UserInputService.JumpRequest:Connect(function()
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and root then
        if infJumpActive and os.clock() - lastJumpTime > 0.1 then
            lastJumpTime = os.clock()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        elseif doubleJumpActive and humanoid:GetState() == Enum.HumanoidStateType.Freefall and not hasDoubleJumped then
            hasDoubleJumped = true
            root.Velocity = Vector3.new(root.Velocity.X, humanoid.JumpPower * 1.2, root.Velocity.Z)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Landed then
        hasDoubleJumped = false
    end
end)

-- Các chức năng khác (Giữ nguyên từ bản gốc của bạn)
KillAuraButton.MouseButton1Click:Connect(function()
    killAuraActive = not killAuraActive
    KillAuraButton.Text = killAuraActive and "⚔️ Kill Aura: BẬT" or "⚔️ Kill Aura (Bán kính 20): TẮT"
    KillAuraButton.BackgroundColor3 = killAuraActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(142, 68, 173)
end)

task.spawn(function()
    while task.wait(0.1) do
        if killAuraActive and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = Player.Character.HumanoidRootPart
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHumanoid = p.Character:FindFirstChildOfClass("Humanoid")
                    if targetHumanoid and targetHumanoid.Health > 0 and (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude <= 20 then
                        if tool then tool:Activate() end
                        targetHumanoid:TakeDamage(5) 
                    end
                end
            end
        end
    end
end)

HitboxButton.MouseButton1Click:Connect(function()
    hitboxActive = not hitboxActive
    HitboxButton.Text = hitboxActive and "⭕ Phóng To Hitbox Địch: BẬT" or "⭕ Phóng To Hitbox Địch: TẮT"
    HitboxButton.BackgroundColor3 = hitboxActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(211, 84, 0)
    if not hitboxActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                p.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not hitboxActive then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            if hrp.Size.X < 10 then 
                hrp.Size = Vector3.new(12, 12, 12)
                hrp.Transparency = 0.75
                hrp.Color = Color3.fromRGB(255, 0, 0)
                hrp.CanCollide = false
            end
        end
    end
end)

SpinBotButton.MouseButton1Click:Connect(function()
    spinBotActive = not spinBotActive
    SpinBotButton.Text = spinBotActive and "🔄 Spin Bot: BẬT" or "🔄 Spin Bot (Xoay tròn): TẮT"
    SpinBotButton.BackgroundColor3 = spinBotActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(22, 160, 133)
    if not spinBotActive then
        local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if root and root:FindFirstChild("SpinningObject") then root.SpinningObject:Destroy() end
    end
end)

RunService.Heartbeat:Connect(function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if spinBotActive then
        local spin = root:FindFirstChild("SpinningObject")
        if not spin then
            spin = Instance.new("BodyAngularVelocity")
            spin.Name = "SpinningObject"
            spin.MaxTorque = Vector3.new(0, math.huge, 0)
            spin.Parent = root
        end
        spin.AngularVelocity = Vector3.new(0, 65, 0)
    end
end) 

-- [FUNC] Kéo mọi người về phía bạn (Dễ troll nhất)
BringAllBtn.MouseButton1Click:Connect(function()
    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if myRoot then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
            end
        end
        BringAllBtn.Text = "✅ Đã kéo tất cả!"
        task.wait(1)
        BringAllBtn.Text = "👥 Kéo Mọi Người Đến Đây"
    end
end)

-- [FUNC] Nhân vật Cầu vồng (Hiệu ứng nhìn rất Pro)
local rainbowActive = false
RainbowBtn.MouseButton1Click:Connect(function()
    rainbowActive = not rainbowActive
    RainbowBtn.Text = rainbowActive and "🌈 Nhân Vật Cầu Vồng: BẬT" or "🌈 Nhân Vật Cầu Vồng: TẮT"
    RainbowBtn.BackgroundColor3 = rainbowActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(231, 76, 60)
end)

RunService.RenderStepped:Connect(function()
    if rainbowActive and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            end
        end
    end
end)

-- [FUNC] Đóng Băng Nhân Vật (Khóa cứng vị trí)
local freezeActive = false
FreezeBtn.MouseButton1Click:Connect(function()
    freezeActive = not freezeActive
    FreezeBtn.Text = freezeActive and "❄️ Đang Đóng Băng..." or "❄️ Đóng Băng Nhân Vật: TẮT"
    FreezeBtn.BackgroundColor3 = freezeActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(52, 152, 219)
    
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.Anchored = freezeActive
    end
end) 

AntiRagdollBtn.MouseButton1Click:Connect(function()
    antiRagdollActive = not antiRagdollActive
    AntiRagdollBtn.Text = antiRagdollActive and "🏋️ Chống Té Ngã: BẬT" or "🏋️ Chống Té Ngã: TẮT"
    AntiRagdollBtn.BackgroundColor3 = antiRagdollActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(127, 140, 141)
end)

RunService.Heartbeat:Connect(function()
    if not antiRagdollActive then return end
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
            if targetHum and targetHum.Health > 0 then
                local distance = (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = p
                end
            end
        end
    end
    return closestPlayer
end

AimbotButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    if aimbotActive then
        camLockActive = false
        CamLockBtn.Text = "🔒 Cam Lock: TẮT"
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
        AimbotButton.Text = "🎯 Khóa Mục Tiêu (R-Click): BẬT"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        AimbotButton.Text = "🎯 Khóa Mục Tiêu (R-Click): TẮT"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    end
end)

CamLockBtn.MouseButton1Click:Connect(function()
    camLockActive = not camLockActive
    if camLockActive then
        aimbotActive = false
        AimbotButton.Text = "🎯 Khóa Mục Tiêu (R-Click): TẮT"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        CamLockBtn.Text = "🔒 Cam Lock: BẬT"
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        CamLockBtn.Text = "🔒 Cam Lock: TẮT"
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
    end
end)

RunService.RenderStepped:Connect(function()
    local isRightClickPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local target = ((aimbotActive and isRightClickPressed) or camLockActive) and getClosestPlayer()
    if target and target.Character then
        local targetPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
        if targetPart then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position) end
    end
end)

TriggerBotBtn.MouseButton1Click:Connect(function()
    triggerBotActive = not triggerBotActive
    TriggerBotBtn.Text = triggerBotActive and "🤖 Trigger Bot: BẬT" or "🤖 Trigger Bot: TẮT"
    TriggerBotBtn.BackgroundColor3 = triggerBotActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(41, 128, 185)
end)

RunService.RenderStepped:Connect(function()
    if not triggerBotActive then return end
    local target = Mouse.Target
    if target and target.Parent then
        local targetChar = target.Parent
        if targetChar:FindFirstChildOfClass("Humanoid") and targetChar.Name ~= Player.Name then
            local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

-- [ĐÃ SỬA LỖI] Anti-Kill không bị nảy liên tục vô hạn
local antiKillCooldown = false
AntiKillBtn.MouseButton1Click:Connect(function()
    antiKillActive = not antiKillActive
    AntiKillBtn.Text = antiKillActive and "🚨 Chống Chết: BẬT" or "🚨 Chống Chết khẩn cấp: TẮT"
    AntiKillBtn.BackgroundColor3 = antiKillActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(192, 41, 43)
end)

RunService.Heartbeat:Connect(function()
    if not antiKillActive or antiKillCooldown then return end
    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if hum and root and hum.Health > 0 and hum.Health < (hum.MaxHealth * 0.25) then
        antiKillCooldown = true
        root.CFrame = root.CFrame + Vector3.new(0, 150, 0)
        root.Velocity = Vector3.new(0,0,0)
        AntiKillBtn.Text = "🚨 ĐÃ CỨU NGUY KHẨN CẤP!" 
        task.wait(2)
        AntiKillBtn.Text = antiKillActive and "🚨 Chống Chết: BẬT" or "🚨 Chống Chết khẩn cấp: TẮT"
        antiKillCooldown = false
    end
end)

NoclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipButton.Text = noclip and "👻 Đi Xuyên Tường: BẬT" or "👻 Đi Xuyên Tường: TẮT"
    NoclipButton.BackgroundColor3 = noclip and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(155, 89, 182)
end)

RunService.Stepped:Connect(function()
    if noclip and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

local flySpeed = 60
local bodyGyro, bodyVelocity
FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if flying and root then
        FlyButton.Text = "🕊️ Chế Độ Bay v4: BẬT (E để Boost)"
        FlyButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.maxTorque = Vector3.new(9e5, 9e5, 9e5)
        bodyGyro.cframe = root.CFrame
        bodyGyro.Parent = root
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.velocity = Vector3.new(0, 0, 0)
        bodyVelocity.maxForce = Vector3.new(9e5, 9e5, 9e5)
        bodyVelocity.Parent = root
        
        task.spawn(function()
            while flying and root and root.Parent do
                RunService.RenderStepped:Wait()
                local direction = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end
                
                local currentSpeed = UserInputService:IsKeyDown(Enum.KeyCode.E) and (flySpeed * 3) or flySpeed
                bodyGyro.cframe = Camera.CFrame
                bodyVelocity.velocity = direction.Magnitude > 0 and direction.Unit * currentSpeed or Vector3.new(0, 0, 0)
            end
        end)
    else
        FlyButton.Text = "🕊️ Chế Độ Bay v4: TẮT"
        FlyButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end)

WaterWalkBtn.MouseButton1Click:Connect(function()
    waterWalkActive = not waterWalkActive
    WaterWalkBtn.Text = waterWalkActive and "🌊 Chạy Trên Nước: BẬT" or "🌊 Chạy Trên Nước: TẮT"
    WaterWalkBtn.BackgroundColor3 = waterWalkActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(41, 128, 185)
end)

RunService.Heartbeat:Connect(function()
    if not waterWalkActive then return end
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local raycastResult = workspace:Raycast(root.Position, Vector3.new(0, -4, 0), raycastParams)
    if raycastResult and raycastResult.Instance then
        local mat = raycastResult.Material
        local name = raycastResult.Instance.Name:lower()
        if mat == Enum.Material.Water or name:find("water") or name:find("liquid") then
            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        end
    end
end)

FovButton.MouseButton1Click:Connect(function()
    fovState = (fovState + 1) % 4
    if fovState == 0 then Camera.FieldOfView = 70; FovButton.Text = "👁️ Góc Nhìn (FOV): Thường (70)"
    elseif fovState == 1 then Camera.FieldOfView = 90; FovButton.Text = "👁️ Góc Nhìn (FOV): Rộng (90)"
    elseif fovState == 2 then Camera.FieldOfView = 110; FovButton.Text = "👁️ Góc Nhìn (FOV): Pro (110)"
    else Camera.FieldOfView = 130; FovButton.Text = "👁️ Góc Nhìn (FOV): Hack (130)" end
end)

AutoFarmBtn.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    AutoFarmBtn.Text = autoFarmActive and "💰 Tự Động Nhặt Đồ: BẬT" or "💰 Tự Động Nhặt Đồ Gần Đây: TẮT"
    AutoFarmBtn.BackgroundColor3 = autoFarmActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(243, 156, 18)
end)

task.spawn(function()
    while task.wait(0.3) do
        if autoFarmActive and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = Player.Character.HumanoidRootPart
            for _, object in pairs(workspace:GetDescendants()) do
                if object:IsA("BasePart") and object.Parent then
                    local name = object.Name:lower()
                    if name:find("coin") or name:find("token") or name:find("item") or name:find("drop") or name:find("diamond") then
                        local pcallSuccess, distance = pcall(function() return (object.Position - myRoot.Position).Magnitude end)
                        if pcallSuccess and distance and distance <= 60 then
                            object.CFrame = myRoot.CFrame
                        end
                    end
                end
            end
        end
    end
end)

-- [FUNC] Trọng lực thấp (Moon Gravity)
local moonGravityActive = false
MoonGravityBtn.MouseButton1Click:Connect(function()
    moonGravityActive = not moonGravityActive
    MoonGravityBtn.Text = moonGravityActive and "🌕 Trọng Lực Thấp: BẬT" or "🌕 Trọng Lực Thấp (Moon): TẮT"
    MoonGravityBtn.BackgroundColor3 = moonGravityActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(149, 165, 166)
    game:GetService("Workspace").Gravity = moonGravityActive and 50 or 196.2
end)

local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")

-- [FUNC] Auto-Rejoin khi bị Kick
local autoRejoinActive = false
AutoRejoinBtn.MouseButton1Click:Connect(function()
    autoRejoinActive = not autoRejoinActive
    AutoRejoinBtn.Text = autoRejoinActive and "🛡️ Auto-Rejoin: BẬT" or "🛡️ Auto-Rejoin: TẮT"
    AutoRejoinBtn.BackgroundColor3 = autoRejoinActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(192, 57, 43)
end)

GuiService.ErrorMessageChanged:Connect(function()
    if autoRejoinActive and GuiService:GetErrorMessage() ~= "" then
        TeleportService:Teleport(game.PlaceId, Player)
    end
end)

-- [FUNC] Staff Detector & Auto-Leave
local staffDetectActive = false
local autoLeaveActive = false

StaffDetectBtn.MouseButton1Click:Connect(function()
    staffDetectActive = not staffDetectActive
    StaffDetectBtn.Text = staffDetectActive and "🕵️ Staff Detector: BẬT" or "🕵️ Staff Detector: TẮT"
    StaffDetectBtn.BackgroundColor3 = staffDetectActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(241, 196, 15)
end)

AutoLeaveBtn.MouseButton1Click:Connect(function()
    autoLeaveActive = not autoLeaveActive
    AutoLeaveBtn.Text = autoLeaveActive and "🏃 Auto-Leave: BẬT" or "🏃 Auto-Leave: TẮT"
    AutoLeaveBtn.BackgroundColor3 = autoLeaveActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(230, 126, 34)
end)

-- Hàm kiểm tra Staff (Bạn có thể thêm tên admin cụ thể tại đây)
local function checkStaff(plr)
    local name = string.lower(plr.Name)
    local display = string.lower(plr.DisplayName)
    -- Kiểm tra từ khóa nhạy cảm
    if string.find(name, "admin") or string.find(display, "admin") or 
       string.find(name, "mod") or string.find(name, "dev") then
        return true
    end
    return false
end

-- Logic xử lý Staff
local function handleStaff(plr)
    if staffDetectActive then
        if checkStaff(plr) then
            warn("⚠️ Phát hiện Staff: " .. plr.Name)
            -- Nếu đang bật Auto-Leave thì thoát ngay
            if autoLeaveActive then
                TeleportService:Teleport(12345678, Player) -- Nơi bạn muốn trốn đến
            end
        end
    end
end

-- 1. Quét người chơi MỚI vào
Players.PlayerAdded:Connect(handleStaff)

-- 2. Quét người chơi ĐANG CÓ MẶT (QUAN TRỌNG - Bổ sung mới)
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= Player then
        handleStaff(plr)
    end
end

-- [FUNC] Chế Độ Ban Đêm
local nightModeActive = false
NightModeBtn.MouseButton1Click:Connect(function()
    nightModeActive = not nightModeActive
    NightModeBtn.Text = nightModeActive and "🌙 Chế Độ Ban Đêm: BẬT" or "🌙 Chế Độ Ban Đêm: TẮT"
    NightModeBtn.BackgroundColor3 = nightModeActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(44, 62, 80)
    Lighting.ClockTime = nightModeActive and 0 or 14
end)

-- [FUNC] Chế Độ Tàng Hình (Ghost)
local ghostActive = false
GhostModeBtn.MouseButton1Click:Connect(function()
    ghostActive = not ghostActive
    GhostModeBtn.Text = ghostActive and "👻 Đang Tàng Hình..." or "👻 Chế Độ Tàng Hình: TẮT"
    GhostModeBtn.BackgroundColor3 = ghostActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(127, 140, 141)
    
    local char = Player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = ghostActive and 1 or 0
            end
        end
    end
end)

-- [FUNC] Auto Clicker
local autoClickActive = false
AutoClickBtn.MouseButton1Click:Connect(function()
    autoClickActive = not autoClickActive
    AutoClickBtn.Text = autoClickActive and "🖱️ Auto Click: BẬT" or "🖱️ Auto Clicker: TẮT"
    AutoClickBtn.BackgroundColor3 = autoClickActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(230, 126, 34)
end)

task.spawn(function()
    while task.wait(0.1) do
        if autoClickActive then
            local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end) 

GodButton.MouseButton1Click:Connect(function()
    godMode = not godMode
    GodButton.Text = godMode and "🛡️ Chế Độ Bất Tử: BẬT" or "🛡️ Chế Độ Bất Tử: TẮT"
    GodButton.BackgroundColor3 = godMode and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(192, 57, 43)
end)

RunService.Heartbeat:Connect(function()
    if godMode and Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = humanoid.MaxHealth end
    end
end)

local espStorage = {}
local function removeESP(p)
    if espStorage[p] then
        pcall(function() espStorage[p]:Destroy() end)
        espStorage[p] = nil
    end
end

EspButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    EspButton.Text = espActive and "👁️ Nhìn Xuyên Tường (ESP): BẬT" or "👁️ Nhìn Xuyên Tường (ESP): TẮT"
    EspButton.BackgroundColor3 = espActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(241, 196, 15)
    if not espActive then for p, _ in pairs(espStorage) do removeESP(p) end end
end)

local function applyESP(p)
    if not espActive then return end
    if p == Player then return end
    removeESP(p)
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "AdminESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 80)
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Adornee = p.Character
        highlight.Parent = p.Character
        espStorage[p] = highlight
    end
end

RunService.Heartbeat:Connect(function()
    if not espActive then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if not espStorage[p] or not espStorage[p].Parent then applyESP(p) end
        end
    end
end)

Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(0.5); if espActive then applyESP(p) end end) end)
for _, p in pairs(Players:GetPlayers()) do p.CharacterAdded:Connect(function() task.wait(0.5); if espActive then applyESP(p) end end) end
Players.PlayerRemoving:Connect(function(p) removeESP(p) end)

InfOxygenBtn.MouseButton1Click:Connect(function()
    infiniteOxygenActive = not infiniteOxygenActive
    InfOxygenBtn.Text = infiniteOxygenActive and "🤿 Vô Hạn Ô-xy: BẬT" or "🤿 Vô Hạn Ô-xy (Dưới nước): TẮT"
    InfOxygenBtn.BackgroundColor3 = infiniteOxygenActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(34, 166, 179)
end)

RunService.Heartbeat:Connect(function()
    if infiniteOxygenActive and Player.Character then
        local data = Player.Character:FindFirstChild("Oxygen") or Player.Character:FindFirstChild("Air")
        if data and data:IsA("ValueBase") then data.Value = 100 end
    end
end)

originalAmbient = Lighting.Ambient
originalOutdoorAmbient = Lighting.OutdoorAmbient
FullBrightBtn.MouseButton1Click:Connect(function()
    fullBrightActive = not fullBrightActive
    FullBrightBtn.Text = fullBrightActive and "💡 FullBright: BẬT" or "💡 FullBright (Sáng Đêm): TẮT"
    FullBrightBtn.BackgroundColor3 = fullBrightActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(241, 196, 15)
    if not fullBrightActive then
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalOutdoorAmbient
    end
end)

RunService.RenderStepped:Connect(function()
    if fullBrightActive then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end
end)

----------------------------------------------------
-- LOGIC TROLL MỚI THÊM VÀO
----------------------------------------------------

-- [TROLL 1] Fling (Cối Xay Gió)
FlingBtn.MouseButton1Click:Connect(function()
    flingActive = not flingActive
    FlingBtn.Text = flingActive and "🌪️ Fling (Xoay Siêu Tốc): BẬT" or "🌪️ Fling (Xoay Chạm Văng Địch): TẮT"
    FlingBtn.BackgroundColor3 = flingActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(230, 50, 50)
end)

RunService.Stepped:Connect(function()
    if flingActive and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        -- Tạo lực xoay ảo ảnh hưởng đến Physics của đối thủ khi va chạm
        root.RotVelocity = Vector3.new(0, 50000, 0)
    end
end)

-- [TROLL 2] Đu Bám Người Khác
AnnoyBtn.MouseButton1Click:Connect(function()
    annoyActive = not annoyActive
    AnnoyBtn.Text = annoyActive and "🐒 Đu Bám Người Khác: BẬT" or "🐒 Đu Bám Người Khác: TẮT"
    AnnoyBtn.BackgroundColor3 = annoyActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(155, 89, 182)
end)

RunService.Heartbeat:Connect(function()
    if annoyActive then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                -- Dịch chuyển và "ngồi" trên đầu mục tiêu
                Player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
end)

-- [FUNC] X-Ray (Làm tường trở nên trong suốt)
local xrayActive = false
XRayBtn.MouseButton1Click:Connect(function()
    xrayActive = not xrayActive
    XRayBtn.Text = xrayActive and "🕶️ X-Ray: ĐANG BẬT" or "🕶️ X-Ray: TẮT"
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
            if xrayActive then
                if obj.Transparency < 0.5 then obj.Transparency = 0.5 end
            else
                obj.Transparency = 0 -- Trả về mặc định
            end
        end
    end
end)

-- [FUNC] Theo Dõi (Spectate)
local spectateActive = false
SpectateBtn.MouseButton1Click:Connect(function()
    spectateActive = not spectateActive
    SpectateBtn.Text = spectateActive and "👀 Đang theo dõi..." or "👀 Theo Dõi Người Khác: TẮT"
    if not spectateActive then Camera.CameraSubject = Player.Character:FindFirstChildOfClass("Humanoid") end
end)

RunService.RenderStepped:Connect(function()
    if spectateActive then
        local target = getClosestPlayer() -- Sử dụng hàm getClosestPlayer có sẵn trong code của bạn
        if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end)

-- [FUNC] NPC ESP
local npcEspActive = false
local npcHighlights = {}

NpcEspBtn.MouseButton1Click:Connect(function()
    npcEspActive = not npcEspActive
    NpcEspBtn.Text = npcEspActive and "🤖 ESP NPCs: BẬT" or "🤖 ESP NPCs: TẮT"
    if not npcEspActive then
        for _, h in pairs(npcHighlights) do h:Destroy() end
        npcHighlights = {}
    end
end)

RunService.Heartbeat:Connect(function()
    if not npcEspActive then return end
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(model) then
            if not model:FindFirstChild("NpcHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "NpcHighlight"
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.Adornee = model
                highlight.Parent = model
                table.insert(npcHighlights, highlight)
            end
        end
    end
end) 

-- [TROLL 3] Spam Chat
SpamChatBtn.MouseButton1Click:Connect(function()
    spamChatActive = not spamChatActive
    SpamChatBtn.Text = spamChatActive and "💬 Chat Spammer: BẬT" or "💬 Chat Spammer: TẮT"
    SpamChatBtn.BackgroundColor3 = spamChatActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(52, 152, 219)
end)

task.spawn(function()
    while task.wait(2.5) do
        if spamChatActive then
            local messages = {
                "Bạn đang bị troller bởi Chủ server!",
                "Owner Admin Menu V6.2 Pro Max quá xịn!",
                "Lag quá à? Do mình múa quạt đó!"
            }
            local msg = messages[math.random(1, #messages)]
            
            -- Tương thích cả TextChatService (mới) và DefaultChatSystem (cũ)
            pcall(function()
                if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
                    local channel = game:GetService("TextChatService").TextChannels:FindFirstChild("RBXGeneral")
                    if channel then channel:SendAsync(msg) end
                elseif game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") then
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
                end
            end)
        end
    end
end)

-- 1. Ping Checker (Dùng TextLabel thay vì Button cho chuyên nghiệp)
    local PingLabel = Instance.new("TextLabel")
    PingLabel.Parent = parentFrame
    PingLabel.Size = UDim2.new(1, 0, 0, 30)
    PingLabel.Text = "📡 Ping: Đang đo..."
    PingLabel.BackgroundColor3 = Color3.fromRGB(127, 140, 141)
    
    task.spawn(function()
        while task.wait(1) do
            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            PingLabel.Text = "📡 Ping: " .. math.floor(ping) .. "ms"
        end
    end)

    -- 2. Server Hopper (Dùng pcall để tránh lỗi nếu game chặn Teleport)
    local HopperBtn = createMenuButton("🔄 Server Hopper", Color3.fromRGB(142, 68, 173))
    HopperBtn.Parent = parentFrame
    HopperBtn.MouseButton1Click:Connect(function()
        local success, err = pcall(function()
            TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
        end)
        if not success then warn("Hopper Error: " .. tostring(err)) end
    end)

    -- 3. FPS Booster (Sử dụng lệnh trực tiếp vào Lighting)
    local fpsActive = false
    local FPSBtn = createMenuButton("🚀 FPS Booster: TẮT", Color3.fromRGB(41, 128, 185))
    FPSBtn.Parent = parentFrame
    FPSBtn.MouseButton1Click:Connect(function()
        fpsActive = not fpsActive
        FPSBtn.Text = fpsActive and "🚀 FPS Booster: BẬT" or "🚀 FPS Booster: TẮT"
        game:GetService("Lighting").GlobalShadows = not fpsActive
    end)
    
    -- 4. Dọn Rác (Clean)
    local cleanActive = false
    local CleanBtn = createMenuButton("🧹 Dọn Rác: TẮT", Color3.fromRGB(231, 76, 60))
    CleanBtn.Parent = parentFrame
    CleanBtn.MouseButton1Click:Connect(function()
        cleanActive = not cleanActive
        CleanBtn.Text = cleanActive and "🧹 Đang dọn..." or "🧹 Dọn Rác: TẮT"
        if cleanActive then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") then
                    obj:Destroy()
                end
            end
        end
    end)
end

----------------------------------------------------
-- CÁC CÔNG CỤ DỊCH CHUYỂN
----------------------------------------------------
DeleteToolBtn.MouseButton1Click:Connect(function()
    local backpack = Player:FindFirstChildOfClass("Backpack")
    if backpack then
        if backpack:FindFirstChild("Deleter Tool") or (Player.Character and Player.Character:FindFirstChild("Deleter Tool")) then
            DeleteToolBtn.Text = "⚠️ Đã có Tool này rồi!"
            task.wait(1)
            DeleteToolBtn.Text = "💥 Nhận Tool Click Xóa Vật Thể"
            return
        end
        local tool = Instance.new("Tool")
        tool.Name = "Deleter Tool"
        tool.RequiresHandle = false
        tool.Activated:Connect(function()
            if Mouse.Target and not Mouse.Target:IsA("Terrain") then
                if not Mouse.Target:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
                    Mouse.Target:Destroy()
                end
            end
        end)
        tool.Parent = backpack
        DeleteToolBtn.Text = "✅ Đã thêm Thùng Rác vào Kho!"
        task.wait(1)
        DeleteToolBtn.Text = "💥 Nhận Tool Click Xóa Vật Thể"
    end
end)

TeleportToolBtn.MouseButton1Click:Connect(function()
    local backpack = Player:FindFirstChildOfClass("Backpack")
    if backpack then
        if backpack:FindFirstChild("Teleport Tool") or (Player.Character and Player.Character:FindFirstChild("Teleport Tool")) then
            TeleportToolBtn.Text = "⚠️ Bạn đã có Tool này rồi!"
            task.wait(1)
            TeleportToolBtn.Text = "🛠️ Nhận Tool Click Dịch Chuyển"
            return
        end
        local tool = Instance.new("Tool")
        tool.Name = "Teleport Tool"
        tool.RequiresHandle = false
        tool.Activated:Connect(function()
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Mouse.Target then
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
        tool.Parent = backpack
        TeleportToolBtn.Text = "✅ Đã thêm vào Kho đồ!"
        task.wait(1)
        TeleportToolBtn.Text = "🛠️ Nhận Tool Click Dịch Chuyển"
    end
end)

local tpIndex = 1
TeleportBtn.MouseButton1Click:Connect(function()
    local targets = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(targets, p)
        end
    end
    if #targets > 0 then
        if tpIndex > #targets then tpIndex = 1 end
        local targetPlayer = targets[tpIndex]
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            TeleportBtn.Text = "🌀 Đến: " .. targetPlayer.Name
            tpIndex = tpIndex + 1
        end
    else
        TeleportBtn.Text = "❌ Không tìm thấy ai khác!"
        task.wait(1)
        TeleportBtn.Text = "🌀 Dịch Chuyển Đến Người Chơi"
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Mouse.Target then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then setMenuVisible(not Frame.Visible) end
end)

ToggleButton.MouseButton1Click:Connect(function() setMenuVisible(not Frame.Visible) end)
CloseButton.MouseButton1Click:Connect(function() setMenuVisible(false) end)

----------------------------------------------------
-- DRAG GUI MƯỢT MÀ
----------------------------------------------------
RunService.RenderStepped:Connect(function() Title.TextColor3 = Color3.fromHSV((tick() % 4) / 4, 0.8, 1) end)

local dragToggle = nil
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true; dragStart = input.Position; startPos = Frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(Frame, TweenInfo.new(0.08, Enum.EasingStyle.OutQuad), {Position = targetPos}):Play()
    end
end)
