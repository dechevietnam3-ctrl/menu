local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- Hủy Menu cũ tránh trùng lặp UI
local oldGui = Player:WaitForChild("PlayerGui"):FindFirstChild("PremiumMenu_v5_Pro")
if oldGui then oldGui:Destroy() end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumMenu_v5_Pro"
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
Frame.Size = UDim2.new(0, 340, 0, 480)
Frame.Position = UDim2.new(0.5, -170, 0.5, -240)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.ClipsDescendants = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 16)
FrameCorner.Parent = Frame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "⚡ OWNER ADMIN MENU V5 ULTRA ⚡"
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.TextSize = 15
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

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Thùng chứa các nút để cuộn
local Container = Instance.new("ScrollingFrame")
Container.Parent = Frame
Container.Size = UDim2.new(1, -10, 1, -65)
Container.Position = UDim2.new(0, 5, 0, 55)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 600) 
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- HÀM TẠO NÚT CÓ HIỆU ỨNG DI CHUỘT
local function createMenuButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.Size = UDim2.new(0, 300, 0, 40)
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

-- TẠO CÁC NÚT CHỨC NĂNG
local SpeedButton     = createMenuButton("⚡ Tốc Độ: Bình Thường", Color3.fromRGB(230, 126, 34))
local JumpButton      = createMenuButton("🦘 Sức Nhảy: Bình Thường", Color3.fromRGB(46, 204, 113))
local DoubleJumpBtn   = createMenuButton("🚀 Nhảy Kép (Double Jump): TẮT", Color3.fromRGB(44, 62, 80))
local InfJumpButton   = createMenuButton("🌌 Nhảy Vô Hạn: TẮT", Color3.fromRGB(52, 73, 94))
local KillAuraButton  = createMenuButton("⚔️ Kill Aura (Bán kính 20): TẮT", Color3.fromRGB(142, 68, 173))
local SpinBotButton   = createMenuButton("🔄 Spin Bot (Xoay tròn): TẮT", Color3.fromRGB(22, 160, 133))
local AimbotButton    = createMenuButton("🎯 Khóa Mục Tiêu (R-Click): TẮT", Color3.fromRGB(231, 76, 60))
local NoclipButton    = createMenuButton("👻 Đi Xuyên Tường: TẮT", Color3.fromRGB(155, 89, 182))
local FlyButton       = createMenuButton("🕊️ Chế Độ Bay v4: TẮT", Color3.fromRGB(52, 152, 219))
local GodButton       = createMenuButton("🛡️ Chế Độ Bất Tử: TẮT", Color3.fromRGB(192, 57, 43))
local EspButton       = createMenuButton("👁️ Nhìn Xuyên Tường (ESP): TẮT", Color3.fromRGB(241, 196, 15))
local TeleportToolBtn = createMenuButton("🛠️ Nhận Tool Click Dịch Chuyển", Color3.fromRGB(39, 174, 96))
local TeleportBtn     = createMenuButton("🌀 Dịch Chuyển Đến Người Chơi", Color3.fromRGB(26, 188, 156))
local InfoClickTP     = createMenuButton("⌨️ Mẹo: RightShift ẩn menu / Ctrl+Click TP", Color3.fromRGB(80, 80, 80))

----------------------------------------------------
-- QUẢN LÝ TRẠNG THÁI & TỰ KHỞI ĐỘNG LẠI KHI HỒI SINH
----------------------------------------------------
local speedState = 0
local jumpState = false
local doubleJumpActive = false
local infJumpActive = false
local killAuraActive = false
local spinBotActive = false
local aimbotActive = false
local noclip = false
local flying = false
local godMode = false
local espActive = false

local bodyGyro, bodyVelocity

-- Hàm tự động re-apply trạng thái cũ khi nhân vật hồi sinh
local function applyCharacterStats(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
    if speedState == 0 then humanoid.WalkSpeed = 16
    elseif speedState == 1 then humanoid.WalkSpeed = 50
    elseif speedState == 2 then humanoid.WalkSpeed = 150 end
    
    if jumpState then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 150
    else
        humanoid.JumpPower = 50
    end
    
    -- Reset trạng thái bay khi hồi sinh tránh bị kẹt vật lý cũ
    if flying then
        flying = false
        FlyButton.Text = "🕊️ Chế Độ Bay v4: TẮT"
        FlyButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
    end
end

Player.CharacterAdded:Connect(applyCharacterStats)
if Player.Character then applyCharacterStats(Player.Character) end

----------------------------------------------------
-- XỬ LÝ LOGIC CHỨC NĂNG
----------------------------------------------------

-- 1. Siêu Tốc Độ
SpeedButton.MouseButton1Click:Connect(function()
    speedState = (speedState + 1) % 3
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
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
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if jumpState then
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 150
        end
        JumpButton.Text = "🦘 Sức Nhảy: Cao (150)"
    else
        if humanoid then humanoid.JumpPower = 50 end
        JumpButton.Text = "🦘 Sức Nhảy: Bình Thường"
    end
end)

-- 3. Nhảy kép (Double Jump)
local hasDoubleJumped = false
DoubleJumpBtn.MouseButton1Click:Connect(function()
    doubleJumpActive = not doubleJumpActive
    if doubleJumpActive then
        infJumpActive = false
        InfJumpButton.Text = "🌌 Nhảy Vô Hạn: TẮT"
        InfJumpButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
        DoubleJumpBtn.Text = "🚀 Nhảy Kép (Double Jump): BẬT"
        DoubleJumpBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        DoubleJumpBtn.Text = "🚀 Nhảy Kép (Double Jump): TẮT"
        DoubleJumpBtn.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
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

-- 4. Nhảy Vô Hạn
InfJumpButton.MouseButton1Click:Connect(function()
    infJumpActive = not infJumpActive
    if infJumpActive then
        doubleJumpActive = false
        DoubleJumpBtn.Text = "🚀 Nhảy Kép (Double Jump): TẮT"
        DoubleJumpBtn.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
        InfJumpButton.Text = "🌌 Nhảy Vô Hạn: BẬT"
        InfJumpButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        InfJumpButton.Text = "🌌 Nhảy Vô Hạn: TẮT"
        InfJumpButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
    end
end)

RunService.Heartbeat:Connect(function()
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Landed then
        hasDoubleJumped = false
    end
end)

-- 5. Kill Aura
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
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
                    local targetHumanoid = p.Character:FindFirstChildOfClass("Humanoid")
                    local targetRoot = p.Character.HumanoidRootPart
                    
                    if targetHumanoid.Health > 0 and (targetRoot.Position - myRoot.Position).Magnitude <= 20 then
                        if tool then tool:Activate() end
                        targetHumanoid:TakeDamage(5) 
                    end
                end
            end
        end
    end
end)

-- 6. Spin Bot
SpinBotButton.MouseButton1Click:Connect(function()
    spinBotActive = not spinBotActive
    if spinBotActive then
        SpinBotButton.Text = "🔄 Spin Bot (Xoay tròn): BẬT"
        SpinBotButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        SpinBotButton.Text = "🔄 Spin Bot (Xoay tròn): TẮT"
        SpinBotButton.BackgroundColor3 = Color3.fromRGB(22, 160, 133)
    end
end)

RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        local spin = root:FindFirstChild("Spinning")
        
        if spinBotActive then
            if not spin then
                spin = Instance.new("BodyAngularVelocity")
                spin.Name = "Spinning"
                spin.MaxTorque = Vector3.new(0, math.huge, 0)
                spin.AngularVelocity = Vector3.new(0, 50, 0)
                spin.Parent = root
            end
        else
            if spin then spin:Destroy() end
        end
    end
end)

-- 7. Aimbot / Lock Camera
AimbotButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    if aimbotActive then
        AimbotButton.Text = "🎯 Khóa Mục Tiêu (R-Click): BẬT"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        AimbotButton.Text = "🎯 Khóa Mục Tiêu (R-Click): TẮT"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    end
end)

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local pRoot = p.Character.HumanoidRootPart
            local distance = (pRoot.Position - myRoot.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = p
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if aimbotActive and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
        end
    end
end)

-- 8. Đi Xuyên Tường (Noclip)
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

-- 9. Chế Độ Bay v4
FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        FlyButton.Text = "🕊️ Chế Độ Bay v4: BẬT"
        FlyButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
        
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        
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
            local flySpeed = 60
            while flying and root and root.Parent do
                RunService.RenderStepped:Wait()
                local direction = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end
                
                if bodyGyro and bodyVelocity then
                    bodyGyro.cframe = Camera.CFrame
                    bodyVelocity.velocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.new(0, 0, 0)
                end
            end
        end)
    else
        FlyButton.Text = "🕊️ Chế Độ Bay v4: TẮT"
        FlyButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
        if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    end
end)

-- 10. Chế độ Bất Tử (God Mode)
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

-- 11. Nhìn Xuyên Tường ESP
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
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if not p.Character:FindFirstChild("AdminESP") then
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

-- 12. Nhận Tool Click Để Dịch Chuyển (Teleport Tool)
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
            local character = Player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root and Mouse.Target then
                root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
        
        tool.Parent = backpack
        TeleportToolBtn.Text = "✅ Đã thêm vào Kho đồ (Backpack)!"
        task.wait(1)
        TeleportToolBtn.Text = "🛠️ Nhận Tool Click Dịch Chuyển"
    end
end)

-- 13. Dịch Chuyển Đến Người Chơi
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
        local myChar = Player.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            TeleportBtn.Text = "🌀 Đến: " .. targetPlayer.Name
            tpIndex = tpIndex + 1
        end
    else
        TeleportBtn.Text = "❌ Không tìm thấy ai khác!"
        task.wait(1)
        TeleportBtn.Text = "🌀 Dịch Chuyển Đến Người Chơi"
    end
end)

-- Ctrl + Click để dịch chuyển nhanh
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local myChar = Player.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") and Mouse.Target then
            myChar.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- Phím tắt RightShift để ẩn/hiện nhanh Menu
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Frame.Visible = not Frame.Visible
    end
end)

----------------------------------------------------
-- ĐIỀU KHIỂN & HIỆU ỨNG LED RGB TIÊU ĐỀ
----------------------------------------------------
RunService.RenderStepped:Connect(function()
    local hue = (tick() % 5) / 5
    Title.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
end)

ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

-- Hệ thống kéo (Drag) Menu mượt mà chống kẹt chuột
local dragging, dragInput, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end
end)
