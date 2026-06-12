local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

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

-- Frame chính (Tăng chiều cao lên 320 để vừa các nút mới)
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 320)
Frame.Position = UDim2.new(0.5, -150, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0,12)
FrameCorner.Parent = Frame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "⭐ Owner Admin Menu ⭐"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true

-- Nút đóng (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0,30,0,30)
CloseButton.Position = UDim2.new(1,-35,0,5)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(255,60,60)
CloseButton.TextColor3 = Color3.new(1,1,1)

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,8)
CloseCorner.Parent = CloseButton

-- HÀM TẠO NÚT NHANH (Để đỡ phải viết lại nhiều dòng UI)
local function createMenuButton(text, yOffset, color)
    local btn = Instance.new("TextButton")
    btn.Parent = Frame
    btn.Size = UDim2.new(0, 240, 0, 40)
    btn.Position = UDim2.new(0.5, -120, 0, yOffset)
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 16
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn
    return btn
end

-- TẠO CÁC NÚT CHỨC NĂNG MỚI
local SpeedButton   = createMenuButton("⚡ Tốc Độ: Bình Thường", 60, Color3.fromRGB(230, 126, 34))
local JumpButton    = createMenuButton("🦘 Sức Nhảy: Bình Thường", 110, Color3.fromRGB(46, 204, 113))
local NoclipButton  = createMenuButton("👻 Đi Xuyên Tường: TẮT", 160, Color3.fromRGB(155, 89, 182))
local FlyButton     = createMenuButton("🕊️ Chế Độ Bay: TẮT", 210, Color3.fromRGB(52, 152, 219))
local ServerInfoBtn = createMenuButton("ℹ️ Thử Thách Chủ Map", 260, Color3.fromRGB(0, 170, 255))

----------------------------------------------------
-- XỬ LÝ LOGIC CHỨC NĂNG (GIỐNG CHỦ MAP)
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
        
        -- Tạo lực vật lý để bay
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.maxTorque = Vector3.new(9e5, 9e5, 9e5)
        bodyGyro.cframe = HumanoidRootPart.CFrame
        bodyGyro.Parent = HumanoidRootPart
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
        bodyVelocity.maxForce = Vector3.new(9e5, 9e5, 9e5)
        bodyVelocity.Parent = HumanoidRootPart
        
        -- Vòng lặp xử lý di chuyển khi bay
        task.spawn(function()
            local Camera = workspace.CurrentCamera
            while flying do
                RunService.RenderStepped:Wait()
                local direction = Vector3.new(0,0,0)
                
                -- Đọc nút bấm từ bàn phím để di chuyển hướng bay
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

-- 5. Nút thông báo vui vẻ
ServerInfoBtn.MouseButton1Click:Connect(function()
    print("Bạn đang sở hữu quyền năng của một Admin thực thụ!")
    -- Có thể thêm lệnh giết toàn bộ map hoặc hồi máu tại đây nếu có Server Script
end)

----------------------------------------------------
-- HỆ THỐNG ĐIỀU KHIỂN MENU (Giữ nguyên của bạn)
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
