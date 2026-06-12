local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Nút mở/tắt menu ngoài màn hình
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -30)
ToggleButton.Text = "☰"
ToggleButton.TextScaled = true
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.TextColor3 = Color3.new(1,1,1)

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1,0)
ToggleCorner.Parent = ToggleButton

-- Frame chính (Tự động co giãn theo số lượng nút nhờ UIListLayout)
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 320, 0, 420) -- Tăng kích thước để vừa các tính năng mới
Frame.Position = UDim2.new(0.5, -160, 0.5, -210)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.ClipsDescendants = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0,12)
FrameCorner.Parent = Frame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundTransparency = 1
Title.Text = "⭐ Owner Admin Menu v2 ⭐"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold

-- Nút đóng (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0,30,0,30)
CloseButton.Position = UDim2.new(1,-35,0,7)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(255,60,60)
CloseButton.TextColor3 = Color3.new(1,1,1)

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,8)
CloseCorner.Parent = CloseButton

-- Thùng chứa các nút để cuộn hoặc sắp xếp tự động
local Container = Instance.new("ScrollingFrame")
Container.Parent = Frame
Container.Size = UDim2.new(1, 0, 1, -55)
Container.Position = UDim2.new(0, 0, 0, 50)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 480) -- Cho phép cuộn nếu nhiều nút
Container.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- HÀM TẠO NÚT NHANH 
local function createMenuButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.Size = UDim2.new(0, 260, 0, 38)
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn
    return btn
end

-- TẠO CÁC NÚT CHỨC NĂNG
local SpeedButton    = createMenuButton("⚡ Tốc Độ: Bình Thường", Color3.fromRGB(230, 126, 34))
local JumpButton     = createMenuButton("🦘 Sức Nhảy: Bình Thường", Color3.fromRGB(46, 204, 113))
local NoclipButton   = createMenuButton("👻 Đi Xuyên Tường: TẮT", Color3.fromRGB(155, 89, 182))
local FlyButton      = createMenuButton("🕊️ Chế Độ Bay: TẮT", Color3.fromRGB(52, 152, 219))
local GodButton      = createMenuButton("🛡️ Chế Độ Bất Tử: TẮT", Color3.fromRGB(192, 57, 43))
local EspButton      = createMenuButton("👁️ Nhìn Xuyên Tường (ESP): TẮT", Color3.fromRGB(241, 196, 15))
local TeleportBtn    = createMenuButton("🌀 Dịch Chuyển Đến Người Chơi", Color3.fromRGB(26, 188, 156))
local InfoClickTP    = createMenuButton("📍 Mẹo: Giữ Ctrl + Click để dịch chuyển", Color3.fromRGB(127, 140, 141))

----------------------------------------------------
-- XỬ LÝ LOGIC CHỨC NĂNG
----------------------------------------------------

-- 1. Siêu Tốc Độ (Speed)
local speedState = 0
SpeedButton.MouseButton1Click:Connect(function()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    speedState = (speedState + 1) % 3
    if speedState == 0 then
        Humanoid.WalkSpeed = 16
        SpeedButton.Text = "⚡ Tốc Độ: Bình Thường"
    elseif speedState == 1 then
        Humanoid.WalkSpeed = 50
        SpeedButton.Text = "⚡ Tốc Độ: Nhanh (50)"
    else
        Humanoid.WalkSpeed = 150
        SpeedButton.Text = "⚡ Tốc Độ: Bàn Thờ (150)"
    end
end)

-- 2. Siêu Nhảy (Jump Power)
local jumpState = false
JumpButton.MouseButton1Click:Connect(function()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    jumpState = not jumpState
    if jumpState then
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = 150
        JumpButton.Text = "🦘 Sức Nhảy: Cao (150)"
    else
        Humanoid.JumpPower = 50
        JumpButton.Text = "🦘 Sức Nhảy: Bình Thường"
    end
end)

-- 3. Đi Xuyên Tường (Noclip)
local noclip = false
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
    if noclip then
        local Character = Player.Character
        if Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- 4. Chế Độ Bay (Fly)
local flying = false
local flySpeed = 50
local bodyGyro, bodyVelocity

FlyButton.MouseButton1Click:Connect(function()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    flying = not flying
    
    if flying then
        FlyButton.Text = "🕊️ Chế Độ Bay: BẬT"
        FlyButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.maxTorque = Vector3.new(9e5, 9e5, 9e5)
        bodyGyro.cframe = HumanoidRootPart.CFrame
        bodyGyro.Parent = HumanoidRootPart
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
        bodyVelocity.maxForce = Vector3.new(9e5, 9e5, 9e5)
        bodyVelocity.Parent = HumanoidRootPart
        
        task.spawn(function()
            local Camera = workspace.CurrentCamera
            while flying do
                RunService.RenderStepped:Wait()
                local direction = Vector3.new(0,0,0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + Camera.CFrame.RightVector
                end
                
                bodyGyro.cframe = Camera.CFrame
                bodyVelocity.velocity = direction * flySpeed
            end
        end)
    else
        FlyButton.Text = "🕊️ Chế Độ Bay: TẮT"
        FlyButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end)

-- 5. Chế độ Bất Tử (God Mode Client)
local godMode = false
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
    if godMode then
        local Character = Player.Character
        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end
    end
end)

-- 6. Nhìn Xuyên Tường (ESP Highlight)
local espActive = false
EspButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        EspButton.Text = "👁️ Nhìn Xuyên Tường (ESP): BẬT"
        EspButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        EspButton.Text = "👁️ Nhìn Xuyên Tường (ESP): TẮT"
        EspButton.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
        -- Xóa toàn bộ ESP khi tắt
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("AdminESP") then
                p.Character.AdminESP:Destroy()
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if espActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                if not p.Character:FindFirstChild("AdminESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "AdminESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0
                    highlight.Parent = p.Character
                end
            end
        end
    end
end)

-- 7. Dịch Chuyển Đến Người Chơi Ngẫu Nhiên (Teleport)
local tpIndex = 1
TeleportBtn.MouseButton1Click:Connect(function()
    local allPlayers = Players:GetPlayers()
    -- Loại bỏ chính mình ra khỏi danh sách dịch chuyển
    local targets = {}
    for _, p in pairs(allPlayers) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(targets, p)
        end
    end
    
    if #targets > 0 then
        if tpIndex > #targets then tpIndex = 1 end
        local targetPlayer = targets[tpIndex]
        local MyChar = Player.Character
        if MyChar and MyChar:FindFirstChild("HumanoidRootPart") then
            MyChar.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            TeleportBtn.Text = "🌀 Đến: " .. targetPlayer.Name
            tpIndex = tpIndex + 1
        end
    else
        TeleportBtn.Text = "❌ Không tìm thấy ai khác!"
        task.wait(1)
        TeleportBtn.Text = "🌀 Dịch Chuyển Đến Người Chơi"
    end
end)

-- 8. Ctrl + Click để dịch chuyển (Click To Teleport)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local MyChar = Player.Character
        if MyChar and MyChar:FindFirstChild("HumanoidRootPart") and Mouse.Target then
            -- Dịch chuyển tới vị trí chuột trỏ vào + cao lên 3 block tránh lún đất
            MyChar.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)


----------------------------------------------------
-- HỆ THỐNG ĐIỀU KHIỂN MENU (Giữ nguyên gốc)
----------------------------------------------------

-- Ẩn/hiện menu
ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

-- Kéo menu (Drag)
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
