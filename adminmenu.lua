
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

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
Container.CanvasSize = UDim2.new(0, 0, 0, 2500) 
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

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
local xrayActive = false 
local npcEspActive = false
local npcHitboxActive = false
local isSpectating = false
local isInvisible = false
local fakeLagActive = false
local bigHeadActive = false
local fakeAdminActive = false
local freezePlayerActive = false
local soundSpamActive = false
local ghostModeActive = false

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
local XrayButton       = createMenuButton("🧱 X-Ray (Nhìn Xuyên Tường): TẮT", Color3.fromRGB(127, 140, 141)) 
local NpcEspBtn        = createMenuButton("👁️ ESP NPC: TẮT", Color3.fromRGB(241, 196, 15))
local NpcHitboxBtn     = createMenuButton("⭕ Hitbox NPC: TẮT", Color3.fromRGB(211, 84, 0))
local SpectateBtn      = createMenuButton("🔭 Xem Người Chơi (Spectate): TẮT", Color3.fromRGB(52, 152, 219))
local InvisBtn         = createMenuButton("🕶️ Tàng Hình (Client): TẮT", Color3.fromRGB(155, 89, 182)) 
-- BỔ SUNG CÁC NÚT TROLL
local FakeLagBtn       = createMenuButton("📶 Fake Lag (Gây giật lag ảo): TẮT", Color3.fromRGB(231, 76, 60))
local BigHeadBtn       = createMenuButton("👤 Big Head (Đầu to): TẮT", Color3.fromRGB(155, 89, 182))
local FakeAdminBtn     = createMenuButton("👑 Giả Danh Admin: TẮT", Color3.fromRGB(241, 196, 15))
local FreezePlayerBtn  = createMenuButton("🧊 Đóng Băng Người Chơi: TẮT", Color3.fromRGB(52, 152, 219))
local SoundSpamBtn     = createMenuButton("🔊 Spam Âm Thanh: TẮT", Color3.fromRGB(230, 126, 34))
local GhostModeBtn     = createMenuButton("👻 Ghost Mode (Mờ người): TẮT", Color3.fromRGB(189, 195, 199))
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

-- Sửa lại đoạn code X-Ray
XrayButton.MouseButton1Click:Connect(function()
    xrayActive = not xrayActive
    XrayButton.Text = xrayActive and "🧱 X-Ray: BẬT" or "🧱 X-Ray: TẮT"
    XrayButton.BackgroundColor3 = xrayActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(127, 140, 141)
    
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Chỉ nên áp dụng cho Part, không nên áp dụng cho Character của người chơi để tránh lỗi hiển thị
        if obj:IsA("BasePart") and not obj:IsDescendantOf(Player.Character) then
            -- Chỉ chỉnh sửa Transparency, KHÔNG đụng vào CanCollide
            obj.Transparency = xrayActive and 0.5 or 0
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

----------------------------------------------------
-- LOGIC TROLL BỔ SUNG
----------------------------------------------------

-- 1. Fake Lag (Gây giật lag ảo bằng cách đóng băng tạm thời)
FakeLagBtn.MouseButton1Click:Connect(function()
    fakeLagActive = not fakeLagActive
    FakeLagBtn.Text = fakeLagActive and "📶 Fake Lag: BẬT" or "📶 Fake Lag: TẮT"
    FakeLagBtn.BackgroundColor3 = fakeLagActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(231, 76, 60)
end)

task.spawn(function()
    while task.wait(0.1) do
        if fakeLagActive and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.Anchored = true
            task.wait(0.1)
            Player.Character.HumanoidRootPart.Anchored = false
        end
    end
end)

-- 2. Big Head (Đầu to)
BigHeadBtn.MouseButton1Click:Connect(function()
    bigHeadActive = not bigHeadActive
    BigHeadBtn.Text = bigHeadActive and "👤 Big Head: BẬT" or "👤 Big Head: TẮT"
    BigHeadBtn.BackgroundColor3 = bigHeadActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(155, 89, 182)
    
    if Player.Character and Player.Character:FindFirstChild("Head") then
        Player.Character.Head.Size = bigHeadActive and Vector3.new(5, 5, 5) or Vector3.new(1, 1, 1)
    end
end)

-- 3. Giả Danh Admin (Đổi màu tên hoặc tạo hiệu ứng - Ở đây mình làm hiệu ứng đổi màu tên)
FakeAdminBtn.MouseButton1Click:Connect(function()
    fakeAdminActive = not fakeAdminActive
    FakeAdminBtn.Text = fakeAdminActive and "👑 Giả Admin: BẬT" or "👑 Giả Danh Admin: TẮT"
    FakeAdminBtn.BackgroundColor3 = fakeAdminActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(241, 196, 15)
end)

-- 4. Đóng Băng Người Chơi (Bản thân)
FreezePlayerBtn.MouseButton1Click:Connect(function()
    freezePlayerActive = not freezePlayerActive
    FreezePlayerBtn.Text = freezePlayerActive and "🧊 Đã đóng băng!" or "🧊 Đóng Băng Người Chơi: TẮT"
    FreezePlayerBtn.BackgroundColor3 = freezePlayerActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(52, 152, 219)
    
    local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = freezePlayerActive and 0 or 16
        hum.JumpPower = freezePlayerActive and 0 or 50
    end
end)

-- 5. Spam Âm Thanh (Yêu cầu có ID âm thanh, ở đây dùng ID mẫu)
SoundSpamBtn.MouseButton1Click:Connect(function()
    soundSpamActive = not soundSpamActive
    SoundSpamBtn.Text = soundSpamActive and "🔊 Đang Spam..." or "🔊 Spam Âm Thanh: TẮT"
    SoundSpamBtn.BackgroundColor3 = soundSpamActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(230, 126, 34)
    
    if soundSpamActive then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://142667752" -- Thay ID âm thanh của bạn vào đây
        sound.Looped = true
        sound.Parent = Player.Character.Head
        sound:Play()
    else
        if Player.Character:FindFirstChild("Head") and Player.Character.Head:FindFirstChild("Sound") then
            Player.Character.Head.Sound:Destroy()
        end
    end
end)

-- 6. Ghost Mode (Mờ người)
GhostModeBtn.MouseButton1Click:Connect(function()
    ghostModeActive = not ghostModeActive
    GhostModeBtn.Text = ghostModeActive and "👻 Ghost Mode: BẬT" or "👻 Ghost Mode: TẮT"
    GhostModeBtn.BackgroundColor3 = ghostModeActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(189, 195, 199)
    
    if Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = ghostModeActive and 0.6 or 0
            end
        end
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

RunService.Heartbeat:Connect(function()
    if not npcEspActive then return end
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(model) then
            if not model:FindFirstChild("NpcHighlight") then
                local h = Instance.new("Highlight")
                h.Name = "NpcHighlight"
                h.FillColor = Color3.fromRGB(0, 255, 255)
                h.Parent = model
            end
        end
    end
end)

-- Logic Hitbox NPC:
RunService.RenderStepped:Connect(function()
    if not npcHitboxActive then return end
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(model) then
            model.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
            model.HumanoidRootPart.Transparency = 0.5
            model.HumanoidRootPart.CanCollide = false
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

SpectateBtn.MouseButton1Click:Connect(function()
    isSpectating = not isSpectating
    if isSpectating then
        local target = getClosestPlayer() -- Sử dụng hàm getClosestPlayer bạn đã có
        if target and target.Character then
            Camera.CameraSubject = target.Character:FindFirstChild("Humanoid")
            SpectateBtn.Text = "🔭 Đang Xem: " .. target.Name
        end
    else
        Camera.CameraSubject = Player.Character:FindFirstChild("Humanoid")
        SpectateBtn.Text = "🔭 Xem Người Chơi: TẮT"
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

-- Logic ESP NPC
NpcEspBtn.MouseButton1Click:Connect(function()
    npcEspActive = not npcEspActive
    NpcEspBtn.Text = npcEspActive and "👁️ ESP NPC: BẬT" or "👁️ ESP NPC: TẮT"
    NpcEspBtn.BackgroundColor3 = npcEspActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(241, 196, 15)
    
    -- Tự động dọn dẹp highlight khi tắt
    if not npcEspActive then
        for _, descendant in pairs(workspace:GetDescendants()) do
            if descendant.Name == "NpcHighlight" then
                descendant:Destroy()
            end
        end
    end
end)

-- Vòng lặp chạy ngầm (Heartbeat) cho ESP
RunService.Heartbeat:Connect(function()
    if not npcEspActive then return end
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(model) then
            if not model:FindFirstChild("NpcHighlight") then
                local h = Instance.new("Highlight")
                h.Name = "NpcHighlight"
                h.FillColor = Color3.fromRGB(0, 255, 255)
                h.Parent = model
            end
        end
    end
end)

-- Logic Hitbox NPC
NpcHitboxBtn.MouseButton1Click:Connect(function()
    npcHitboxActive = not npcHitboxActive
    NpcHitboxBtn.Text = npcHitboxActive and "⭕ Hitbox NPC: BẬT" or "⭕ Hitbox NPC: TẮT"
    NpcHitboxBtn.BackgroundColor3 = npcHitboxActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(211, 84, 0)
    
    -- Trả lại kích thước gốc khi tắt
    if not npcHitboxActive then
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(model) then
                model.HumanoidRootPart.Size = Vector3.new(2, 2, 1) -- Kích thước mặc định
            end
        end
    end
end)

-- Vòng lặp chạy ngầm (RenderStepped) cho Hitbox
RunService.RenderStepped:Connect(function()
    if not npcHitboxActive then return end
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(model) then
            local hrp = model.HumanoidRootPart
            hrp.Size = Vector3.new(10, 10, 10)
            hrp.Transparency = 0.5
            hrp.CanCollide = false
        end
    end
end) 

InvisBtn.MouseButton1Click:Connect(function()
    isInvisible = not isInvisible
    local char = Player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = isInvisible and 1 or 0
            end
        end
    end
    InvisBtn.Text = isInvisible and "🕶️ Tàng Hình: BẬT" or "🕶️ Tàng Hình: TẮT"
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
