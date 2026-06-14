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

-- 3. NÚT TOGGLE (Mở Menu)
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -27)
ToggleButton.Text = "☰"
ToggleButton.TextScaled = true
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
local ToggleCorner = Instance.new("UICorner", ToggleButton)
ToggleCorner.CornerRadius = UDim.new(1, 0)

ToggleButton.MouseButton1Click:Connect(function() 
    Frame.Visible = not Frame.Visible 
end)

-- Kéo thả ToggleButton
local draggingToggle, dragStartToggle, startPosToggle
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true
        dragStartToggle = input.Position
        startPosToggle = ToggleButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartToggle
        ToggleButton.Position = UDim2.new(startPosToggle.X.Scale, startPosToggle.X.Offset + delta.X, startPosToggle.Y.Scale, startPosToggle.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        draggingToggle = false 
    end 
end)

-- Thanh tiêu đề
local TitleBar = Instance.new("Frame") -- Đổi từ TextButton thành Frame để tránh xung đột click
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ OWNER ADMIN MENU V6.2 PRO MAX ⚡"
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold

-- NÚT ĐÓNG (X) - ĐÃ SỬA LỖI
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -38, 0, 11)
CloseButton.Text = "✕"
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BackgroundColor3 = Color3.fromRGB(240, 50, 50)
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.ZIndex = 10 -- Đẩy ZIndex lên cao hẳn để không bị che khuất

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Chức năng tắt Menu khi bấm nút X
CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

-- KÉO THẢ MENU CHÍNH (Tính năng thêm giúp menu chuyên nghiệp hơn)
local dragToggle, dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragToggle then updateInput(input) end
end)

-- Thùng chứa cuộn
local Container = Instance.new("ScrollingFrame")
Container.Parent = Frame
Container.Size = UDim2.new(1, -10, 1, -65)
Container.Position = UDim2.new(0, 5, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 6
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
Container.BorderSizePixel = 0
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y 

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = Container
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)

-- Hàm tạo Button
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
    local hoverColor = Color3.new(
        math.min(originalColor.R + 0.15, 1),
        math.min(originalColor.G + 0.15, 1),
        math.min(originalColor.B + 0.15, 1)
    )
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = originalColor}):Play()
    end)
    
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 300, 0, 38)}):Play()
    end)
    
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 310, 0, 40)}):Play()
    end)
    
    return btn
end 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- 1. Tạo GUI
local HUD_Gui = Instance.new("ScreenGui")
HUD_Gui.Name = "StatsHUD"
HUD_Gui.ResetOnSpawn = false
HUD_Gui.Parent = Player:WaitForChild("PlayerGui")

local HUD_Frame = Instance.new("Frame")
HUD_Frame.Parent = HUD_Gui
HUD_Frame.Size = UDim2.new(0, 230, 0, 180)
HUD_Frame.Position = UDim2.new(1, -240, 0, 10)
HUD_Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
HUD_Frame.BackgroundTransparency = 0.3
HUD_Frame.BorderSizePixel = 0
Instance.new("UICorner", HUD_Frame).CornerRadius = UDim.new(0, 8)

-- Nút ẩn/hiện
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = HUD_Frame
ToggleBtn.Size = UDim2.new(0, 30, 0, 30)
ToggleBtn.Position = UDim2.new(1, -35, 0, 5)
ToggleBtn.Text = "-"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 4)

local HUD_Text = Instance.new("TextLabel")
HUD_Text.Parent = HUD_Frame
HUD_Text.Size = UDim2.new(1, -20, 1, -30)
HUD_Text.Position = UDim2.new(0, 10, 0, 35)
HUD_Text.BackgroundTransparency = 1
HUD_Text.TextColor3 = Color3.fromRGB(255, 255, 255)
HUD_Text.Font = Enum.Font.Code
HUD_Text.TextSize = 14
HUD_Text.TextXAlignment = Enum.TextXAlignment.Left
HUD_Text.TextYAlignment = Enum.TextYAlignment.Top
HUD_Text.TextWrapped = true

-- 2. Logic Di chuyển (Draggable)
local dragging, dragInput, dragStart, startPos
HUD_Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = HUD_Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        HUD_Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- 3. Logic Nút ẩn/hiện
local isMinimized = false
ToggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    HUD_Frame.Size = isMinimized and UDim2.new(0, 230, 0, 40) or UDim2.new(0, 230, 0, 180)
    HUD_Text.Visible = not isMinimized
    ToggleBtn.Text = isMinimized and "+" or "-"
end)

-- 4. Logic cập nhật
local startTime = os.time()
local fps = 0
local frameCount = 0

-- Tính FPS bằng cách đếm khung hình trong 1 giây
RunService.RenderStepped:Connect(function()
    frameCount += 1
end)

task.spawn(function()
    while task.wait(0.5) do
        -- Lấy FPS trung bình
        fps = frameCount * 2
        frameCount = 0

        if not HUD_Frame or not HUD_Frame.Parent then break end
        
        -- Logic đếm NPC (CẢNH BÁO: GetDescendants tốn tài nguyên, nếu game lớn hãy dùng CollectionService)
        local npcCount = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                npcCount += 1
            end
        end
        
 	    local char = Player.Character
		local hum = char and char:FindFirstChild("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")

		local speed = hum and math.floor(hum.WalkSpeed) or 0
		local jump = hum and (hum.UseJumpPower and math.floor(hum.JumpPower) or math.floor(hum.JumpHeight)) or 0
		local health = hum and math.floor(hum.Health) or 0
		local pos = root and root.Position or Vector3.new(0,0,0)

		local elapsed = os.time() - startTime
		local timeStr = string.format("%02d:%02d:%02d", math.floor(elapsed/3600), math.floor((elapsed%3600)/60), elapsed%60)
		local placeId = game.PlaceId	
		local mem = math.floor(Stats:GetTotalMemoryUsageMb())
        local ping = math.floor(Player:GetNetworkPing() * 1000)
			
		HUD_Text.Text = string.format(
			"⏱️ Time: %s\n🆔 Map ID: %d\n👥 Players: %d | NPC: %d\n⚡ Speed: %d | ⬆️ Jump: %d\n❤️ HP: %d\n📍 Pos: %.0f, %.0f, %.0f\n📶 FPS: %d | Ping: %dms\n💾 Mem: %d MB", 
			timeStr, placeId, #Players:GetPlayers(), npcCount, speed, jump, health, pos.X, pos.Y, pos.Z, fps, ping, mem
		)
	end
end)
-- Ví dụ tạo thử 1 nút test menu
createMenuButton("Test Tính Năng 1", Color3.fromRGB(0, 150, 255))

----------------------------------------------------
-- QUẢN LÝ TRẠNG THÁI TOÀN CỤC
----------------------------------------------------
local speedState = 0
local jumpState = false
local doubleJumpActive = false
local infJumpActive = false
local killAuraActive = false
local hitboxActive = false
local teamEspActive = false
local enemyEspActive = false
local spinBotActive = false
local antiRagdollActive = false
local aimbotActive = false
local camLockActive = false
local noclip = false
local myHitboxSmallActive = false
local flying = false
local waterWalkActive = false
local fpsBoostActive = false
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
local freezePlayerActive = false
local soundSpamActive = false
local ghostModeActive = false
local sitActive = false
local layActive = false
local loopDanceActive = false
local invisibleHeadActive = false
local currentDance = nil
-- Trạng thái Troll mới
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
local TeamEspBtn       = createMenuButton("👥 ESP Đồng đội: TẮT", Color3.fromRGB(46, 204, 113))
local EnemyEspBtn      = createMenuButton("💀 ESP Địch: TẮT", Color3.fromRGB(231, 76, 60))
local SpinBotButton    = createMenuButton("🔄 Spin Bot (Xoay tròn): TẮT", Color3.fromRGB(22, 160, 133)) 
local AntiRagdollBtn   = createMenuButton("🏋️ Chống Té Ngã: TẮT", Color3.fromRGB(127, 140, 141))
local AimbotButton     = createMenuButton("🎯 Khóa Mục Tiêu (R-Click): TẮT", Color3.fromRGB(231, 76, 60))
local CamLockBtn       = createMenuButton("🔒 Cam Lock (Khóa cứng Camera): TẮT", Color3.fromRGB(192, 57, 43))
local AntiKillBtn      = createMenuButton("🚨 Chống Chết khẩn cấp (Máu < 25%): TẮT", Color3.fromRGB(192, 41, 43))
local NoclipButton     = createMenuButton("👻 Đi Xuyên Tường: TẮT", Color3.fromRGB(155, 89, 182))
local FlyButton        = createMenuButton("🕊️ Chế Độ Bay v4 (Giữ E để Boost): TẮT", Color3.fromRGB(52, 152, 219))
local FovButton        = createMenuButton("👁️ Góc Nhìn (FOV): Thường (70)", Color3.fromRGB(149, 165, 166))
local AutoFarmBtn      = createMenuButton("💰 Tự Động Nhặt Đồ Gần Đây: TẮT", Color3.fromRGB(243, 156, 18))
local GodButton        = createMenuButton("🛡️ Chế Độ Bất Tử: TẮT", Color3.fromRGB(192, 57, 43))
local EspButton        = createMenuButton("👁️ Nhìn Xuyên Tường (ESP): TẮT", Color3.fromRGB(241, 196, 15))
local FullBrightBtn    = createMenuButton("💡 FullBright (Sáng Đêm): TẮT", Color3.fromRGB(241, 196, 15))
local XrayButton       = createMenuButton("🧱 X-Ray (Nhìn Xuyên Tường): TẮT", Color3.fromRGB(127, 140, 141)) 
local NpcEspBtn        = createMenuButton("👁️ ESP NPC: TẮT", Color3.fromRGB(241, 196, 15))
local NpcHitboxBtn     = createMenuButton("⭕ Hitbox NPC: TẮT", Color3.fromRGB(211, 84, 0))
local SpectateBtn      = createMenuButton("🔭 Xem Người Chơi (Spectate): TẮT", Color3.fromRGB(52, 152, 219))
local LayBtn           = createMenuButton("🛌 Buộc Nằm (Lay Down): TẮT", Color3.fromRGB(230, 126, 34)) 
local LoopDanceBtn    = createMenuButton("💃 Nhảy Múa Liên Tục: TẮT", Color3.fromRGB(46, 204, 113))

-- BỔ SUNG CÁC NÚT TROLL
local FakeLagBtn       = createMenuButton("📶 Fake Lag (Gây giật lag ảo): TẮT", Color3.fromRGB(231, 76, 60))
----------------------------------------------------
-- TẠO CÁC NÚT TROLL (MỚI)
----------------------------------------------------
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

-- 1. Tạo khu vực nhập ID trong menu
local IDInput = Instance.new("TextBox")
IDInput.Parent = Container
IDInput.Size = UDim2.new(0, 310, 0, 40)
IDInput.PlaceholderText = "Nhập Place ID tại đây..."
IDInput.Text = ""
IDInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
IDInput.TextColor3 = Color3.new(1, 1, 1)
IDInput.Font = Enum.Font.Gotham
IDInput.TextSize = 14
local IDCorner = Instance.new("UICorner", IDInput)
IDCorner.CornerRadius = UDim.new(0, 8)

-- 2. Tạo nút Dịch chuyển
local JoinMapBtn = createMenuButton("🚀 Dịch chuyển đến Map ID", Color3.fromRGB(231, 76, 60))

-- 3. Logic xử lý
JoinMapBtn.MouseButton1Click:Connect(function()
	local targetPlaceId = tonumber(IDInput.Text)

	if targetPlaceId then
		JoinMapBtn.Text = "Đang chuyển..."
		local success, result = pcall(function()
			TeleportService:Teleport(targetPlaceId, Player)
		end)

		if not success then
			warn("Lỗi: " .. tostring(result))
			JoinMapBtn.Text = "Lỗi! Thử lại"
			task.wait(2)
			JoinMapBtn.Text = "🚀 Dịch chuyển đến Map ID"
		end
	else
		IDInput.Text = "ID không hợp lệ!"
		task.wait(1)
		IDInput.Text = ""
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

-- Giả định các biến đã được khởi tạo từ trước
local TeleportService = game:GetService("TeleportService")
local Player = game.Players.LocalPlayer


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

-- Hàm dọn dẹp tất cả ESP cũ
local function cleanupAllESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("AdminESP") then
            p.Character.AdminESP:Destroy()
        end
    end
end

-- Logic nút bấm
TeamEspBtn.MouseButton1Click:Connect(function()
    teamEspActive = not teamEspActive
    TeamEspBtn.Text = teamEspActive and "👥 ESP Đồng đội: BẬT" or "👥 ESP Đồng đội: TẮT"
    TeamEspBtn.BackgroundColor3 = teamEspActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(46, 204, 113)
end)

EnemyEspBtn.MouseButton1Click:Connect(function()
    enemyEspActive = not enemyEspActive
    EnemyEspBtn.Text = enemyEspActive and "💀 ESP Địch: BẬT" or "💀 ESP Địch: TẮT"
    EnemyEspBtn.BackgroundColor3 = enemyEspActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(231, 76, 60)
end)

-- Vòng lặp cập nhật ESP (Tối ưu)
RunService.Heartbeat:Connect(function()
    -- Nếu cả 2 đều tắt, thoát ngay để không gây lag
    if not teamEspActive and not enemyEspActive then return end

    local myTeam = Player.Team

    for _, p in pairs(Players:GetPlayers()) do
        -- Bỏ qua bản thân
        if p == Player or not p.Character then continue end
        
        local character = p.Character
        local espObj = character:FindFirstChild("AdminESP")
        
        local isTeammate = (myTeam and p.Team == myTeam)
        local shouldRender = (isTeammate and teamEspActive) or (not isTeammate and enemyEspActive)
        
        if shouldRender then
            -- Nếu cần render mà chưa có ESP, thì tạo mới
            if not espObj then
                espObj = Instance.new("Highlight")
                espObj.Name = "AdminESP"
                espObj.FillTransparency = 0.5
                espObj.OutlineTransparency = 0
                espObj.Parent = character
            end
            
            -- Cập nhật màu sắc (Xanh cho đồng đội, Đỏ cho địch)
            local targetColor = isTeammate and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            if espObj.FillColor ~= targetColor then
                espObj.FillColor = targetColor
            end
        else
            -- Nếu có ESP nhưng không nên hiển thị, xóa nó ngay
            if espObj then
                espObj:Destroy()
            end
        end
    end
end)

-- 2. Buộc Nằm (Lay Down)
LayBtn.MouseButton1Click:Connect(function()
    layActive = not layActive
    LayBtn.Text = layActive and "🛌 Buộc Nằm: BẬT" or "🛌 Buộc Nằm (Lay Down): TẮT"
    LayBtn.BackgroundColor3 = layActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(230, 126, 34)
end)

RunService.RenderStepped:Connect(function()
    if layActive and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        -- Xoay nhân vật để tạo hiệu ứng nằm
        Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90), 0, 0)
    end
end)

-- 3. Nhảy Múa Liên Tục
LoopDanceBtn.MouseButton1Click:Connect(function()
    loopDanceActive = not loopDanceActive
    LoopDanceBtn.Text = loopDanceActive and "💃 Đang Múa..." or "💃 Nhảy Múa Liên Tục: TẮT"
    LoopDanceBtn.BackgroundColor3 = loopDanceActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(46, 204, 113)
    
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if loopDanceActive and humanoid then
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://507777826" -- ID điệu nhảy mặc định
        currentDance = humanoid:LoadAnimation(animation)
        currentDance.Looped = true
        currentDance:Play()
    else
        if currentDance then currentDance:Stop() end
    end
end)
-- HÀM CẬP NHẬT HITBOX (Đã tối ưu)
local function updateHitboxes()
    -- Chỉ chạy vòng lặp khi tính năng đang được BẬT
    if not hitboxActive then return end 
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            -- Chỉ set thuộc tính khi chưa được phóng to để tránh spam thay đổi thuộc tính vật lý liên tục
            if hrp and hrp.Size.X ~= 12 then 
                hrp.Size = Vector3.new(12, 12, 12)
                hrp.Transparency = 0.75
                hrp.Color = Color3.fromRGB(255, 0, 0)
                hrp.CanCollide = false 
            end
        end
    end
end
-------------------------
-- Vòng lặp Heartbeat (Chạy nhẹ hơn)
RunService.Heartbeat:Connect(updateHitboxes)

-- XỬ LÝ NÚT BẤM
HitboxButton.MouseButton1Click:Connect(function()
    hitboxActive = not hitboxActive
    
    HitboxButton.Text = hitboxActive and "⭕ Phóng To Hitbox Địch: BẬT" or "⭕ Phóng To Hitbox Địch: TẮT"
    HitboxButton.BackgroundColor3 = hitboxActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(211, 84, 0)
    
    -- Reset ngay lập tức khi tắt
    if not hitboxActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Color = Color3.fromRGB(255, 255, 255)
                    hrp.CanCollide = true
                end
            end
        end
    end
end)
---------------------
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

NoclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    
    -- Cập nhật giao diện
    NoclipButton.Text = noclip and "👻 Đi Xuyên Tường: BẬT" or "👻 Đi Xuyên Tường: TẮT"
    NoclipButton.BackgroundColor3 = noclip and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(155, 89, 182)
    
    -- Nếu tắt noclip, khôi phục lại CanCollide
    if not noclip then
        setCollisions(false)

