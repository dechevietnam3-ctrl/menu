local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- Khử trùng lặp UI cũ
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

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1,0)
ToggleCorner.Parent = ToggleButton

-- Frame chính
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 350, 0, 500)
Frame.Position = UDim2.new(0.5, -175, 0.5, -250)
Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Frame.ClipsDescendants = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 16)
FrameCorner.Parent = Frame

-- Thanh tiêu đề (Dùng để kéo menu)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ OWNER ADMIN MENU V6 ULTRA ⚡"
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.TextSize = 14
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

-- Thùng chứa cuộn
local Container = Instance.new("ScrollingFrame")
Container.Parent = Frame
Container.Size = UDim2.new(1, -10, 1, -65)
Container.Position = UDim2.new(0, 5, 0, 55)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 1250) -- Tăng không gian cuộn cho chức năng mới
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- HÀM TẠO NÚT CÓ HIỆU ỨNG DI CHUỘW
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
        math.min(originalColor.R * 255 + 25, 255),
        math.min(originalColor.G * 255 + 25, 255),
        math.min(originalColor.B * 255 + 25, 255)
    )
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = originalColor}):Play()
    end)
    
    return btn
end

----------------------------------------------------
-- TẠO CÁC NÚT CHỨC NĂNG (ĐÃ SẮP XẾP)
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
local CamLockBtn       = createMenuButton("🔒 Cam Lock (Khóa cứng Camera): TẮT", Color3.fromRGB(192, 57, 43)) -- [MỚI V6]
local NoclipButton     = createMenuButton("👻 Đi Xuyên Tường: TẮT", Color3.fromRGB(155, 89, 182))
local FlyButton        = createMenuButton("🕊️ Chế Độ Bay v4: TẮT", Color3.fromRGB(52, 152, 219))
local WaterWalkBtn     = createMenuButton("🌊 Chạy Trên Nước (Jesus): TẮT", Color3.fromRGB(41, 128, 185)) -- [MỚI V6]
local FovButton        = createMenuButton("👁️ Góc Nhìn (FOV): Thường (70)", Color3.fromRGB(149, 165, 166)) -- [MỚI V6]
local AutoFarmBtn      = createMenuButton("💰 Tự Động Nhặt Đồ Gần Đây: TẮT", Color3.fromRGB(243, 156, 18)) -- [MỚI V6]
local GodButton        = createMenuButton("🛡️ Chế Độ Bất Tử: TẮT", Color3.fromRGB(192, 57, 43))
local EspButton        = createMenuButton("👁️ Nhìn Xuyên Tường (ESP): TẮT", Color3.fromRGB(241, 196, 15))
local TeleportToolBtn  = createMenuButton("🛠️ Nhận Tool Click Dịch Chuyển", Color3.fromRGB(39, 174, 96)) 
local TeleportBtn      = createMenuButton("🌀 Dịch Chuyển Đến Người Chơi", Color3.fromRGB(26, 188, 156))
local InfoClickTP      = createMenuButton("⌨️ Mẹo: RightShift ẩn menu / Ctrl+Click TP", Color3.fromRGB(80, 80, 80))

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

-- Hàm đồng bộ lại toàn bộ trạng thái khi nhân vật hồi sinh hoặc tải game
local function applyCharacterStats(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
    -- Đồng bộ Tốc độ
    if speedState == 0 then humanoid.WalkSpeed = 16
    elseif speedState == 1 then humanoid.WalkSpeed = 50
    elseif speedState == 2 then humanoid.WalkSpeed = 150 end
    
    -- Đồng bộ Nhảy
    if jumpState then
        humanoid.UseJumpPower = true; humanoid.JumpPower = 150
    else
        humanoid.JumpPower = 50
    end
end

Player.CharacterAdded:Connect(applyCharacterStats)
if Player.Character then applyCharacterStats(Player.Character) end

-- Đóng mở Menu mượt mà
local function setMenuVisible(visible)
    if visible then
        Frame.Visible = true
        TweenService:Create(Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 350, 0, 500)}):Play()
    else
        TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(0, 350, 0, 0)}):Play()
        task.delay(0.2, function() if not Frame.Visible then Frame.Visible = false end end)
    end
end

----------------------------------------------------
-- LOGIC CÁC CHỨC NĂNG (ĐÃ NÂNG CẤP VÀ THÊM MỚI)
----------------------------------------------------

-- 1. Siêu Tốc Độ
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

-- 2. Siêu Nhảy
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

-- 3. Nhảy kép & Nhảy vô hạn
local hasDoubleJumped = false
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
        if infJumpActive then
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

-- 4. Kill Aura
KillAuraButton.MouseButton1Click:Connect(function()
    killAuraActive = not killAuraActive
    if killAuraActive then
        KillAuraButton.Text = "⚔️ Kill Aura: BẬT"
        KillAuraButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        KillAuraButton.Text = "⚔️ Kill Aura: TẮT"
        KillAuraButton.BackgroundColor3 = Color3.fromRGB(142, 68, 173)
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if killAuraActive and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = Player.Character.HumanoidRootPart
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHumanoid = p.Character:FindFirstChildOfClass("Humanoid")
                    local targetRoot = p.Character.HumanoidRootPart
                    
                    if targetHumanoid and targetHumanoid.Health > 0 and (targetRoot.Position - myRoot.Position).Magnitude <= 20 then
                        if tool then tool:Activate() end
                        targetHumanoid:TakeDamage(5) 
                    end
                end
            end
        end
    end
end)

-- 5. Hitbox Expander
HitboxButton.MouseButton1Click:Connect(function()
    hitboxActive = not hitboxActive
    if hitboxActive then
        HitboxButton.Text = "⭕ Phóng To Hitbox Địch: BẬT"
        HitboxButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        HitboxButton.Text = "⭕ Phóng To Hitbox Địch: TẮT"
        HitboxButton.BackgroundColor3 = Color3.fromRGB(211, 84, 0)
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
            hrp.Size = Vector3.new(10, 10, 10)
            hrp.Transparency = 0.7
            hrp.Color = Color3.fromRGB(255, 0, 0)
            hrp.CanCollide = false
        end
    end
end)

-- 6. Spin Bot
SpinBotButton.MouseButton1Click:Connect(function()
    spinBotActive = not spinBotActive
    if spinBotActive then
        SpinBotButton.Text = "🔄 Spin Bot: BẬT"
        SpinBotButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        SpinBotButton.Text = "🔄 Spin Bot: TẮT"
        SpinBotButton.BackgroundColor3 = Color3.fromRGB(22, 160, 133)
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
        spin.AngularVelocity = Vector3.new(0, 60, 0)
    else
        if root:FindFirstChild("SpinningObject") then root.SpinningObject:Destroy() end
    end
end)

-- 7. Chống té ngã (Anti-Ragdoll)
AntiRagdollBtn.MouseButton1Click:Connect(function()
    antiRagdollActive = not antiRagdollActive
    if antiRagdollActive then
        AntiRagdollBtn.Text = "🏋️ Chống Té Ngã: BẬT"
        AntiRagdollBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        AntiRagdollBtn.Text = "🏋️ Chống Té Ngã: TẮT"
        AntiRagdollBtn.BackgroundColor3 = Color3.fromRGB(127, 140, 141)
    end
end)

RunService.Heartbeat:Connect(function()
    if not antiRagdollActive then return end
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid:GetState() == Enum.HumanoidStateType.Ragdoll or humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

-- Hàm tìm người chơi gần nhất cho Aimbot và Camlock
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

-- 8. Aimbot (Giữ chuột phải)
AimbotButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    if aimbotActive then
        aimbotActive = true; camLockActive = false
        CamLockBtn.Text = "🔒 Cam Lock: TẮT"
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
        AimbotButton.Text = "🎯 Khóa Mục Tiêu (R-Click): BẬT"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        aimbotActive = false
        AimbotButton.Text = "🎯 Khóa Mục Tiêu (R-Click): TẮT"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    end
end)

-- 9. [MỚI] Cam Lock (Khóa cứng Camera vào mục tiêu không cần giữ chuột)
CamLockBtn.MouseButton1Click:Connect(function()
    camLockActive = not camLockActive
    if camLockActive then
        camLockActive = true; aimbotActive = false
        AimbotButton.Text = "🎯 Khóa Mục Tiêu (R-Click): TẮT"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        CamLockBtn.Text = "🔒 Cam Lock: BẬT"
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        camLockActive = false
        CamLockBtn.Text = "🔒 Cam Lock: TẮT"
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
    end
end)

RunService.RenderStepped:Connect(function()
    local target = ((aimbotActive and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) or camLockActive) and getClosestPlayer()
    if target and target.Character then
        local targetPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end
end)

-- 10. Đi xuyên tường (Noclip)
NoclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        NoclipButton.Text = "👻 Đi Xuyên Tường: BẬT"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        NoclipButton.Text = "👻 Đi Xuyên Tường: TẮT"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
    end
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

-- 11. Chế độ Bay v4
local flySpeed = 60
local bodyGyro, bodyVelocity
FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        FlyButton.Text = "🕊️ Chế Độ Bay v4: BẬT"
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
                
                bodyGyro.cframe = Camera.CFrame
                bodyVelocity.velocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.new(0, 0, 0)
            end
        end)
    else
        FlyButton.Text = "🕊️ Chế Độ Bay v4: TẮT"
        FlyButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end)

-- 12. [MỚI] Chạy trên nước (Water Walk / Jesus Mode)
WaterWalkBtn.MouseButton1Click:Connect(function()
    waterWalkActive = not waterWalkActive
    if waterWalkActive then
        WaterWalkBtn.Text = "🌊 Chạy Trên Nước: BẬT"
        WaterWalkBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        WaterWalkBtn.Text = "🌊 Chạy Trên Nước: TẮT"
        WaterWalkBtn.BackgroundColor3 = Color3.fromRGB(41, 128, 185)
    end
end)

RunService.Heartbeat:Connect(function()
    if not waterWalkActive then return end
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Phát hiện các khối nước (hoặc các khối có thuộc tính Material là Water) bên dưới chân
    local raycastParams = RaycastParams.new()
    raycastParams.FilterPlayers = {Player}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local raycastResult = workspace:Raycast(root.Position, Vector3.new(0, -4, 0), raycastParams)
    if raycastResult and (raycastResult.Material == Enum.Material.Water or raycastResult.Instance.Name:lower():find("water")) then
        root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z) -- Giữ nhân vật không bị chìm xuống
    end
end)

-- 13. [MỚI] Góc nhìn rộng (FOV Changer)
FovButton.MouseButton1Click:Connect(function()
    fovState = (fovState + 1) % 4
    if fovState == 0 then
        Camera.FieldOfView = 70
        FovButton.Text = "👁️ Góc Nhìn (FOV): Thường (70)"
    elseif fovState == 1 then
        Camera.FieldOfView = 90
        FovButton.Text = "👁️ Góc Nhìn (FOV): Rộng (90)"
    elseif fovState == 2 then
        Camera.FieldOfView = 110
        FovButton.Text = "👁️ Góc Nhìn (FOV): Pro (110)"
    else
        Camera.FieldOfView = 130
        FovButton.Text = "👁️ Góc Nhìn (FOV): Hack (130)"
    end
end)

-- 14. [MỚI] Tự động nhặt đồ xung quanh (Auto Farm/Collect Part/Coin)
AutoFarmBtn.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    if autoFarmActive then
        AutoFarmBtn.Text = "💰 Tự Động Nhặt Đồ: BẬT"
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        AutoFarmBtn.Text = "💰 Tự Động Nhặt Đồ: TẮT"
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(243, 156, 18)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if autoFarmActive and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = Player.Character.HumanoidRootPart
            -- Tìm kiếm các vật phẩm rơi tự do trong Workspace để tự động dịch chuyển chúng lại gần
            for _, object in pairs(workspace:GetDescendants()) do
                if object:IsA("BasePart") and (object.Name:lower():find("coin") or object.Name:lower():find("token") or object.Name:lower():find("item") or object.Name:lower():find("drop")) then
                    local distance = (object.Position - myRoot.Position).Magnitude
                    if distance <= 60 then -- Bán kính tự hút đồ là 60 studs
                        object.CFrame = myRoot.CFrame
                    end
                end
            end
        end
    end
end)

-- 15. Bất Tử (God Mode)
GodButton.MouseButton1Click:Connect(function()
    godMode = not godMode
    if godMode then
        GodButton.Text = "🛡️ Chế Độ Bất Tử: BẬT"
        GodButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        GodButton.Text = "🛡️ Chế Độ Bất Tử: TẮT"
        GodButton.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
    end
end)

RunService.Heartbeat:Connect(function()
    if godMode and Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = humanoid.MaxHealth end
    end
end)

-- 16. Wallhack ESP (Được tối ưu dọn dẹp bộ nhớ)
EspButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        EspButton.Text = "👁️ Nhìn Xuyên Tường (ESP): BẬT"
        EspButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        EspButton.Text = "👁️ Nhìn Xuyên Tường (ESP): TẮT"
        EspButton.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("AdminESP") then
                p.Character.AdminESP:Destroy()
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not espActive then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local oldEsp = p.Character:FindFirstChild("AdminESP")
            if not oldEsp then
                local highlight = Instance.new("Highlight")
                highlight.Name = "AdminESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 80)
                highlight.FillTransparency = 0.4
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0
                highlight.Adornee = p.Character
                highlight.Parent = p.Character
            end
        end
    end
end)

-- Đảm bảo xóa ESP khi người chơi thoát game để không rò rỉ bộ nhớ
Players.PlayerRemoving:Connect(function(p)
    if p.Character and p.Character:FindFirstChild("AdminESP") then
        p.Character.AdminESP:Destroy()
    end
end)

-- 17. Dịch chuyển (Tool & Phím Tắt)
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

-- Phím tắt Ctrl + Click dịch chuyển
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Mouse.Target then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- Phím tắt RightShift Đóng/Mở mượt mà
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        setMenuVisible(not Frame.Visible)
    end
end)

ToggleButton.MouseButton1Click:Connect(function() setMenuVisible(not Frame.Visible) end)
CloseButton.MouseButton1Click:Connect(function() setMenuVisible(false) end)

----------------------------------------------------
-- LED RGB & DRAG SYSTEM (Hệ thống kéo mượt)
----------------------------------------------------
RunService.RenderStepped:Connect(function()
    Title.TextColor3 = Color3.fromHSV((tick() % 5) / 5, 0.8, 1)
end)

local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        TweenService:Create(Frame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end
end)
