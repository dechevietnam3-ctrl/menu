-- ███████████████████████████████████████████████████████████████
-- ███     RUN FOR BRAINROTS! - ULTIMATE HACK v2.0           ███
-- ███     Tự động chạy + thu thập + nâng cấp + auto farm    ███
-- ███████████████████████████████████████████████████████████████

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- [1] TRẠNG THÁI
-- ============================================================
local BrainrotHack = {
    Active = false,
    AutoRun = false,
    AutoCollect = false,
    AutoUpgrade = false,
    NoFall = false,
    SpeedHack = false,
    AutoJump = false,
    AutoPath = false,
    SpeedMultiplier = 3,
    CollectRadius = 60,
    Connections = {},
    Threads = {},
    Collected = 0,
    Money = 0,
    CoinsPerSecond = 0,
    CurrentPath = {},
    LastPosition = nil,
    FallProtection = false,
}

-- ============================================================
-- [2] HÀM TIỆN ÍCH
-- ============================================================
local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = tostring(title),
            Text = tostring(text),
            Duration = duration or 3,
        })
    end)
end

local function GetRoot(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid(character)
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function GetBoundingBox(instance)
    if instance:IsA("Part") then
        return instance.Position, instance.Size
    elseif instance:IsA("Model") then
        local primary = instance.PrimaryPart or instance:FindFirstChildOfClass("Part")
        if primary then
            return primary.Position, primary.Size
        end
    end
    return nil, nil
end

-- ============================================================
-- [3] TÌM ĐƯỜNG (PATHFINDING) - TỰ ĐỘNG CHẠY THEO ĐƯỜNG
-- ============================================================
local function FindPath()
    local path = {}
    local char = LocalPlayer.Character
    if not char then return path end
    
    local root = GetRoot(char)
    if not root then return path end
    
    -- Tìm các điểm trên đường
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("path") or name:find("road") or name:find("track") or 
               name:find("waypoint") or name:find("checkpoint") or name:find("platform") then
                local pos, _ = GetBoundingBox(obj)
                if pos then
                    table.insert(path, pos)
                end
            end
        end
    end
    
    -- Sắp xếp theo khoảng cách từ người chơi
    table.sort(path, function(a, b)
        local distA = (a - root.Position).Magnitude
        local distB = (b - root.Position).Magnitude
        return distA < distB
    end)
    
    BrainrotHack.CurrentPath = path
    return path
end

-- ============================================================
-- [4] TỰ ĐỘNG CHẠY THEO ĐƯỜNG (AUTO RUN)
-- ============================================================
local function AutoRun()
    if not BrainrotHack.AutoRun then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local hum = GetHumanoid(char)
    if not hum then return end
    
    local root = GetRoot(char)
    if not root then return end
    
    -- Tìm điểm tiếp theo trên đường
    local path = BrainrotHack.CurrentPath
    if #path == 0 then
        path = FindPath()
    end
    
    if #path > 0 then
        local targetPos = path[1]
        if targetPos then
            hum:MoveTo(targetPos)
            
            -- Nếu đến gần điểm, chuyển sang điểm tiếp theo
            local distance = (targetPos - root.Position).Magnitude
            if distance < 5 then
                table.remove(path, 1)
                BrainrotHack.CurrentPath = path
            end
        end
    else
        -- Không tìm thấy đường, chạy về phía camera
        local camera = Workspace.CurrentCamera
        if camera then
            local forward = camera.CFrame.LookVector
            hum:MoveTo(root.Position + forward * 20)
        end
    end
    
    -- Tăng tốc độ
    if BrainrotHack.SpeedHack then
        hum.WalkSpeed = 16 * BrainrotHack.SpeedMultiplier
    end
    
    -- Tự động nhảy khi gặp chướng ngại vật
    if BrainrotHack.AutoJump then
        local rayOrigin = root.Position + Vector3.new(0, 1, 0)
        local rayDirection = root.CFrame.LookVector * 4
        local raycast = Workspace:Raycast(rayOrigin, rayDirection)
        if raycast and raycast.Instance then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

-- ============================================================
-- [5] TÌM BRAINROT ĐỂ THU THẬP
-- ============================================================
local function FindBrainrots()
    local brainrots = {}
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("brainrot") or name:find("brain") or name:find("rot") or 
               name:find("collect") or name:find("item") or name:find("pickup") or
               name:find("coin") or name:find("reward") or name:find("cash") then
                table.insert(brainrots, obj)
            end
        end
    end
    
    return brainrots
end

-- ============================================================
-- [6] TỰ ĐỘNG THU THẬP BRAINROT (HÚT VỀ)
-- ============================================================
local function CollectBrainrots()
    if not BrainrotHack.AutoCollect then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = GetRoot(char)
    if not root then return end
    
    local playerPos = root.Position
    local brainrots = FindBrainrots()
    local collected = 0
    
    for _, brainrot in ipairs(brainrots) do
        if not BrainrotHack.AutoCollect then break end
        
        local brainrotPos = GetBoundingBox(brainrot)
        if brainrotPos then
            local distance = (brainrotPos - playerPos).Magnitude
            if distance < BrainrotHack.CollectRadius then
                -- Hút Brainrot về phía người chơi
                pcall(function()
                    if brainrot:IsA("Part") then
                        local direction = (playerPos - brainrotPos).Unit
                        brainrot.Position = brainrot.Position + direction * 2
                    elseif brainrot:IsA("Model") then
                        local primary = brainrot.PrimaryPart or brainrot:FindFirstChildOfClass("Part")
                        if primary then
                            local direction = (playerPos - primary.Position).Unit
                            primary.Position = primary.Position + direction * 2
                        end
                    end
                end)
                collected = collected + 1
            end
        end
    end
    
    if collected > 0 then
        BrainrotHack.Collected = BrainrotHack.Collected + collected
    end
end

-- ============================================================
-- [7] NO FALL - KHÔNG BỊ RƠI KHI SÀN BIẾN MẤT
-- ============================================================
local function NoFall()
    if not BrainrotHack.NoFall then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = GetRoot(char)
    if not root then return end
    
    -- Phát hiện đang rơi
    if root.Velocity.Y < -15 then
        root.Velocity = Vector3.new(root.Velocity.X, 15, root.Velocity.Z)
        BrainrotHack.FallProtection = true
    end
    
    -- Kiểm tra sàn phía dưới
    local rayOrigin = root.Position
    local rayDirection = Vector3.new(0, -5, 0)
    local raycast = Workspace:Raycast(rayOrigin, rayDirection)
    
    if not raycast or raycast.Distance > 3 then
        -- Không có sàn, tạo platform tạm thời
        local platform = Instance.new("Part")
        platform.Size = Vector3.new(6, 1, 6)
        platform.Position = root.Position - Vector3.new(0, 3, 0)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Transparency = 0.7
        platform.Color = Color3.fromRGB(0, 255, 255)
        platform.Material = Enum.Material.Neon
        platform.Parent = Workspace
        
        -- Xóa platform sau 3 giây
        Debris:AddItem(platform, 3)
        
        -- Cảnh báo
        if not BrainrotHack.FallProtection then
            Notify("⚠️ No Fall", "Sàn đã biến mất! Đã tạo platform tạm!", 1)
            BrainrotHack.FallProtection = true
        end
    else
        BrainrotHack.FallProtection = false
    end
end

-- ============================================================
-- [8] TỰ ĐỘNG NÂNG CẤP (UPGRADE)
-- ============================================================
local function AutoUpgrade()
    if not BrainrotHack.AutoUpgrade then return end
    
    -- Tìm các nút nâng cấp trong game
    local upgradeObjects = {}
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") or obj:IsA("TextButton") then
            local parent = obj.Parent
            if parent then
                local name = parent.Name:lower()
                if name:find("upgrade") or name:find("speed") or name:find("brainrot") or
                   name:find("shop") or name:find("buy") or name:find("purchase") or
                   name:find("base") or name:find("slot") or name:find("level") then
                    table.insert(upgradeObjects, obj)
                end
            end
        end
    end
    
    for _, obj in ipairs(upgradeObjects) do
        pcall(function()
            if obj:IsA("ClickDetector") then
                fireclickdetector(obj)
            elseif obj:IsA("ProximityPrompt") then
                fireproximityprompt(obj)
            elseif obj:IsA("TextButton") then
                obj:Activate()
            end
        end)
        task.wait(0.2)
    end
end

-- ============================================================
-- [9] ESP HIỂN THỊ BRAINROT VÀ ĐƯỜNG ĐI
-- ============================================================
local function ESPBrainrots()
    local brainrots = FindBrainrots()
    
    for _, brainrot in ipairs(brainrots) do
        -- Xóa highlight cũ
        local oldHighlight = brainrot:FindFirstChild("BrainrotESP")
        if oldHighlight then oldHighlight:Destroy() end
        
        -- Highlight màu hồng neon
        local highlight = Instance.new("Highlight")
        highlight.Name = "BrainrotESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 255)
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0.2
        highlight.Adornee = brainrot
        highlight.Parent = brainrot
        
        -- Billboard hiển thị icon
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = brainrot
        billboard.Size = UDim2.new(0, 40, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = brainrot
        
        local label = Instance.new("TextLabel")
        label.Parent = billboard
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "🧠"
        label.TextColor3 = Color3.fromRGB(255, 0, 255)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.ZIndex = 20
    end
    
    -- ESP đường đi
    local path = BrainrotHack.CurrentPath
    for i, pos in ipairs(path) do
        if i < #path then
            -- Vẽ line giữa các điểm (dùng Part)
            local line = Instance.new("Part")
            line.Size = Vector3.new(0.5, 0.5, (pos - path[i+1]).Magnitude)
            line.Position = (pos + path[i+1]) / 2
            line.Anchored = true
            line.CanCollide = false
            line.Transparency = 0.5
            line.Color = Color3.fromRGB(0, 255, 255)
            line.Material = Enum.Material.Neon
            line.Parent = Workspace
            
            -- Xóa line sau 5 giây
            Debris:AddItem(line, 5)
            
            -- Sphere tại các điểm
            local sphere = Instance.new("Part")
            sphere.Shape = Enum.PartType.Ball
            sphere.Size = Vector3.new(1, 1, 1)
            sphere.Position = pos
            sphere.Anchored = true
            sphere.CanCollide = false
            sphere.Transparency = 0.4
            sphere.Color = Color3.fromRGB(0, 255, 255)
            sphere.Material = Enum.Material.Neon
            sphere.Parent = Workspace
            Debris:AddItem(sphere, 5)
        end
    end
end

-- ============================================================
-- [10] TỰ ĐỘNG FARM (KẾT HỢP TẤT CẢ)
-- ============================================================
local function AutoFarm()
    if not BrainrotHack.Active then return end
    
    task.spawn(function()
        while BrainrotHack.Active do
            -- Chạy
            AutoRun()
            
            -- Thu thập Brainrot
            CollectBrainrots()
            
            -- Không rơi
            NoFall()
            
            -- Nâng cấp
            if BrainrotHack.AutoUpgrade then
                AutoUpgrade()
            end
            
            -- Tìm đường mới nếu cần
            if #BrainrotHack.CurrentPath < 3 then
                FindPath()
            end
            
            -- Cập nhật thống kê
            local char = LocalPlayer.Character
            if char then
                local hum = GetHumanoid(char)
                if hum then
                    BrainrotHack.Money = math.floor(hum.Health or 0)
                end
            end
            
            task.wait(0.05) -- Chạy nhanh để phản ứng kịp
        end
    end)
end

-- ============================================================
-- [11] BẬT/TẮT CÁC TÍNH NĂNG
-- ============================================================
local function ToggleAll()
    BrainrotHack.Active = not BrainrotHack.Active
    
    if BrainrotHack.Active then
        BrainrotHack.AutoRun = true
        BrainrotHack.AutoCollect = true
        BrainrotHack.NoFall = true
        BrainrotHack.SpeedHack = true
        BrainrotHack.AutoUpgrade = true
        BrainrotHack.AutoJump = true
        
        Notify("🚀 AUTO FARM", "ĐÃ BẬT TẤT CẢ!", 3)
        FindPath()
        AutoFarm()
    else
        BrainrotHack.AutoRun = false
        BrainrotHack.AutoCollect = false
        BrainrotHack.NoFall = false
        BrainrotHack.SpeedHack = false
        BrainrotHack.AutoUpgrade = false
        BrainrotHack.AutoJump = false
        
        local char = LocalPlayer.Character
        if char then
            local hum = GetHumanoid(char)
            if hum then
                hum.WalkSpeed = 16
            end
        end
        
        Notify("⏹️ AUTO FARM", "ĐÃ TẮT TẤT CẢ!", 3)
    end
end

local function ToggleAutoRun()
    BrainrotHack.AutoRun = not BrainrotHack.AutoRun
    if BrainrotHack.AutoRun then FindPath() end
    Notify("🏃 Auto Run", BrainrotHack.AutoRun and "ĐÃ BẬT" or "ĐÃ TẮT", 2)
end

local function ToggleAutoCollect()
    BrainrotHack.AutoCollect = not BrainrotHack.AutoCollect
    Notify("🧠 Auto Collect", BrainrotHack.AutoCollect and "ĐÃ BẬT" or "ĐÃ TẮT", 2)
end

local function ToggleAutoUpgrade()
    BrainrotHack.AutoUpgrade = not BrainrotHack.AutoUpgrade
    Notify("⬆️ Auto Upgrade", BrainrotHack.AutoUpgrade and "ĐÃ BẬT" or "ĐÃ TẮT", 2)
end

local function ToggleNoFall()
    BrainrotHack.NoFall = not BrainrotHack.NoFall
    Notify("🛡️ No Fall", BrainrotHack.NoFall and "ĐÃ BẬT - Không rơi!" or "ĐÃ TẮT", 2)
end

local function ToggleSpeedHack()
    BrainrotHack.SpeedHack = not BrainrotHack.SpeedHack
    if not BrainrotHack.SpeedHack then
        local char = LocalPlayer.Character
        if char then
            local hum = GetHumanoid(char)
            if hum then
                hum.WalkSpeed = 16
            end
        end
    end
    Notify("⚡ Speed Hack", BrainrotHack.SpeedHack and "ĐÃ BẬT" or "ĐÃ TẮT", 2)
end

local function ToggleAutoJump()
    BrainrotHack.AutoJump = not BrainrotHack.AutoJump
    Notify("🦘 Auto Jump", BrainrotHack.AutoJump and "ĐÃ BẬT" or "ĐÃ TẮT", 2)
end

-- ============================================================
-- [12] TẠO UI
-- ============================================================
local function CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotHack"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Size = UDim2.new(0, 280, 0, 380)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.ZIndex = 10
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 255)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Parent = mainFrame
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🧠 BRAINROT HACK v2"
    title.TextColor3 = Color3.fromRGB(255, 0, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 11
    
    -- Stats
    local stats = Instance.new("TextLabel")
    stats.Parent = mainFrame
    stats.Size = UDim2.new(1, 0, 0, 20)
    stats.Position = UDim2.new(0, 0, 0, 38)
    stats.BackgroundTransparency = 1
    stats.Text = "🧠 0 | 💰 0 | ⚡ x1"
    stats.TextColor3 = Color3.fromRGB(200, 200, 200)
    stats.TextSize = 11
    stats.Font = Enum.Font.Gotham
    stats.ZIndex = 11
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = mainFrame
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 12
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = mainFrame
    scroll.Size = UDim2.new(1, -10, 1, -75)
    scroll.Position = UDim2.new(0, 5, 0, 60)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 255)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ZIndex = 10
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    
    local padding = Instance.new("UIPadding")
    padding.Parent = scroll
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    
    local function CreateButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = scroll
        btn.Size = UDim2.new(1, -10, 0, 38)
        btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 50)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.ZIndex = 11
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = color or Color3.fromRGB(255, 0, 255)
        btnStroke.Thickness = 1
        btnStroke.Parent = btn
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = color and Color3.fromRGB(color.R * 1.5, color.G * 1.5, color.B * 1.5) or Color3.fromRGB(50, 50, 80),
                Size = UDim2.new(1, -5, 0, 42)
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = color or Color3.fromRGB(30, 30, 50),
                Size = UDim2.new(1, -10, 0, 38)
            }):Play()
        end)
        
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    -- Nút chức năng
    CreateButton("🚀 AUTO FARM (BẬT TẤT CẢ)", Color3.fromRGB(255, 0, 255), ToggleAll)
    CreateButton("🏃 Tự động chạy theo đường", Color3.fromRGB(100, 200, 255), ToggleAutoRun)
    CreateButton("🧠 Tự động thu thập", Color3.fromRGB(255, 200, 100), ToggleAutoCollect)
    CreateButton("⬆️ Tự động nâng cấp", Color3.fromRGB(100, 255, 100), ToggleAutoUpgrade)
    CreateButton("🛡️ No Fall (Không rơi)", Color3.fromRGB(255, 100, 100), ToggleNoFall)
    CreateButton("⚡ Speed Hack", Color3.fromRGB(255, 200, 50), ToggleSpeedHack)
    CreateButton("🦘 Tự động nhảy", Color3.fromRGB(200, 100, 255), ToggleAutoJump)
    
    -- Stats update loop
    task.spawn(function()
        while screenGui and screenGui.Parent do
            stats.Text = "🧠 " .. BrainrotHack.Collected .. 
                         " | 💰 " .. BrainrotHack.Money .. 
                         " | ⚡ x" .. BrainrotHack.SpeedMultiplier ..
                         " | 🛡️ " .. (BrainrotHack.NoFall and "ON" or "OFF")
            task.wait(0.5)
        end
    end)
    
    return screenGui
end

-- ============================================================
-- [13] PHÍM TẮT
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode
    
    if key == Enum.KeyCode.RightShift then
        local gui = LocalPlayer.PlayerGui:FindFirstChild("BrainrotHack")
        if gui then gui:Destroy() else CreateUI() end
    end
    
    if key == Enum.KeyCode.F1 then ToggleAll() end
    if key == Enum.KeyCode.F2 then ToggleAutoRun() end
    if key == Enum.KeyCode.F3 then ToggleAutoCollect() end
    if key == Enum.KeyCode.F4 then ToggleNoFall() end
    if key == Enum.KeyCode.F5 then ToggleSpeedHack() end
    if key == Enum.KeyCode.F6 then ToggleAutoJump() end
end)

-- ============================================================
-- [14] KHỞI TẠO
-- ============================================================
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🧠 BRAINROT HACK v2 - Đang khởi tạo...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

task.wait(0.5)
CreateUI()
FindPath()
ESPBrainrots()

print("✅ BRAINROT HACK v2 đã sẵn sàng!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("📖 HƯỚNG DẪN:")
print("   • Right Shift - Mở menu")
print("   • F1 - Bật/Tắt AUTO FARM (tất cả tính năng)")
print("   • F2 - Tự động chạy theo đường")
print("   • F3 - Tự động thu thập Brainrot")
print("   • F4 - Không rơi (No Fall)")
print("   • F5 - Speed Hack")
print("   • F6 - Tự động nhảy")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

Notify("🧠 Brainrot Hack v2", "Đã tải thành công! Nhấn Right Shift để mở menu.", 4)

return {
    ToggleAll = ToggleAll,
    ToggleAutoRun = ToggleAutoRun,
    ToggleAutoCollect = ToggleAutoCollect,
    ToggleNoFall = ToggleNoFall,
    ToggleSpeedHack = ToggleSpeedHack,
    ToggleAutoJump = ToggleAutoJump,
    ESPBrainrots = ESPBrainrots,
    AutoFarm = AutoFarm,
}
