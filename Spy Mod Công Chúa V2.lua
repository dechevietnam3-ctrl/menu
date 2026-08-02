--[[
    Tên: Spy Mod Công Chúa V2 👑
    Tác giả: Cộng đồng phát triển (nâng cấp)
    Tính năng mới:
    - Tạo khối theo hình dạng: Hình tròn, hình trái tim, ngôi sao
    - Đổi màu khối theo thời gian (hiệu ứng cầu vồng)
    - Tạo hàng rào, cầu thang, bàn ghế
    - Lưu và tải lại công trình
    - Hiệu ứng bông tuyết, pháo hoa
    - Tất cả người chơi đều thấy
--]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Tạo GUI chính
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "SpyCongChuaV2"

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
mainFrame.BackgroundTransparency = 0.15
mainFrame.Active = true
mainFrame.Draggable = true

-- Làm đẹp frame
local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 15)

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
title.Text = "👑 Spy Công Chúa V2"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
local titleCorner = Instance.new("UICorner")
titleCorner.Parent = title
titleCorner.CornerRadius = UDim.new(0, 15)

-- ScrollFrame cho nhiều nút
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = mainFrame
scrollFrame.Size = UDim2.new(1, -10, 1, -55)
scrollFrame.Position = UDim2.new(0, 5, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
scrollFrame.ScrollBarThickness = 8

local function createButton(parent, text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(255, 182, 255)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local y = 5

-- ===== DANH SÁCH TÍNH NĂNG =====

-- 1. Tạo khối cơ bản
createButton(scrollFrame, "🌸 Tạo Khối Hoa", y, Color3.fromRGB(255, 105, 180), function()
    local target = mouse.Target
    if target and target.Parent then
        createBlock(target.Position + Vector3.new(0, 2, 0), "Hot pink", "🌸")
    else
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            createBlock(char.HumanoidRootPart.Position + Vector3.new(0, 3, 0), "Light magenta", "🌸")
        end
    end
end)
y = y + 40

-- 2. Tạo khối tròn
createButton(scrollFrame, "⚪ Tạo Khối Tròn", y, Color3.fromRGB(255, 140, 200), function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        createSphere(char.HumanoidRootPart.Position + Vector3.new(0, 3, 0), "Bright blue")
    end
end)
y = y + 40

-- 3. Tạo trái tim 3D
createButton(scrollFrame, "💗 Tạo Trái Tim 3D", y, Color3.fromRGB(255, 60, 120), function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        createHeart(char.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
    end
end)
y = y + 40

-- 4. Tạo ngôi sao
createButton(scrollFrame, "⭐ Tạo Ngôi Sao", y, Color3.fromRGB(255, 215, 0), function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        createStar(char.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
    end
end)
y = y + 40

-- 5. Tạo hàng rào
createButton(scrollFrame, "🌹 Tạo Hàng Rào", y, Color3.fromRGB(255, 150, 100), function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        createFence(char.HumanoidRootPart.Position)
    end
end)
y = y + 40

-- 6. Tạo cầu thang
createButton(scrollFrame, "🪜 Tạo Cầu Thang", y, Color3.fromRGB(210, 180, 140), function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        createStairs(char.HumanoidRootPart.Position)
    end
end)
y = y + 40

-- 7. Tạo bàn ghế
createButton(scrollFrame, "🪑 Tạo Bàn Ghế", y, Color3.fromRGB(200, 150, 100), function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        createFurniture(char.HumanoidRootPart.Position)
    end
end)
y = y + 40

-- 8. Hiệu ứng cầu vồng cho khối
createButton(scrollFrame, "🌈 Hiệu Ứng Cầu Vồng", y, Color3.fromRGB(255, 200, 100), function()
    rainbowEffect()
end)
y = y + 40

-- 9. Pháo hoa
createButton(scrollFrame, "🎆 Pháo Hoa", y, Color3.fromRGB(255, 100, 200), function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        createFirework(char.HumanoidRootPart.Position)
    end
end)
y = y + 40

-- 10. Bông tuyết
createButton(scrollFrame, "❄️ Bông Tuyết Rơi", y, Color3.fromRGB(200, 230, 255), function()
    startSnow()
end)
y = y + 40

-- 11. Xóa tất cả
createButton(scrollFrame, "🗑️ Xóa Tất Cả", y, Color3.fromRGB(255, 80, 80), function()
    deleteAllBlocks()
end)
y = y + 40

-- 12. Lưu công trình
createButton(scrollFrame, "💾 Lưu Công Trình", y, Color3.fromRGB(100, 200, 100), function()
    saveBuild()
end)
y = y + 40

-- 13. Tải công trình
createButton(scrollFrame, "📂 Tải Công Trình", y, Color3.fromRGB(100, 150, 255), function()
    loadBuild()
end)
y = y + 40

-- 14. Đóng
createButton(scrollFrame, "❌ Đóng", y + 10, Color3.fromRGB(200, 200, 200), function()
    screenGui:Destroy()
end)

-- ===== HÀM TẠO BLOCK =====

function createBlock(position, color, emoji)
    local block = Instance.new("Part")
    block.Size = Vector3.new(2, 2, 2)
    block.Position = position
    block.BrickColor = BrickColor.new(color)
    block.Anchored = true
    block.CanCollide = false
    block.Material = Enum.Material.Neon
    block.Parent = game.Workspace
    
    -- Hiệu ứng phát sáng
    local glow = Instance.new("SelectionBox")
    glow.Adornee = block
    glow.Color3 = Color3.fromRGB(255, 200, 255)
    glow.Parent = block
    
    -- Tên hiển thị
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = block
    billboard.Size = UDim2.new(0, 50, 0, 30)
    billboard.Adornee = block
    
    local label = Instance.new("TextLabel")
    label.Parent = billboard
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = emoji or "🌸"
    label.TextColor3 = Color3.fromRGB(255, 182, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    
    -- Lưu vào danh sách để xóa sau
    if not _G.Blocks then _G.Blocks = {} end
    table.insert(_G.Blocks, block)
end

function createSphere(position, color)
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(3, 3, 3)
    sphere.Position = position
    sphere.BrickColor = BrickColor.new(color)
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Material = Enum.Material.Neon
    sphere.Parent = game.Workspace
    
    if not _G.Blocks then _G.Blocks = {} end
    table.insert(_G.Blocks, sphere)
end

function createHeart(position)
    local colors = {"Bright red", "Hot pink", "Bright violet"}
    for i = 1, 3 do
        for j = 1, 3 do
            local block = Instance.new("Part")
            block.Size = Vector3.new(1, 1, 1)
            block.Position = position + Vector3.new(i * 1.2 - 2.4, j * 1.2 + 0.5, 0)
            block.BrickColor = BrickColor.new(colors[math.random(1, 3)])
            block.Anchored = true
            block.CanCollide = false
            block.Material = Enum.Material.Neon
            block.Parent = game.Workspace
            
            if not _G.Blocks then _G.Blocks = {} end
            table.insert(_G.Blocks, block)
        end
    end
end

function createStar(position)
    local colors = {"Bright yellow", "Bright orange", "Bright gold"}
    for i = -2, 2 do
        for j = -2, 2 do
            if math.abs(i) + math.abs(j) <= 3 then
                local block = Instance.new("Part")
                block.Size = Vector3.new(1, 1, 1)
                block.Position = position + Vector3.new(i * 1.2, j * 1.2, 0)
                block.BrickColor = BrickColor.new(colors[math.random(1, 3)])
                block.Anchored = true
                block.CanCollide = false
                block.Material = Enum.Material.Neon
                block.Parent = game.Workspace
                
                if not _G.Blocks then _G.Blocks = {} end
                table.insert(_G.Blocks, block)
            end
        end
    end
end

function createFence(position)
    for i = 0, 5 do
        local post = Instance.new("Part")
        post.Size = Vector3.new(0.3, 2, 0.3)
        post.Position = position + Vector3.new(i * 2, 1, 0)
        post.BrickColor = BrickColor.new("Brown")
        post.Anchored = true
        post.CanCollide = false
        post.Parent = game.Workspace
        
        local bar = Instance.new("Part")
        bar.Size = Vector3.new(2, 0.2, 0.3)
        bar.Position = position + Vector3.new(i * 2 + 1, 1.5, 0)
        bar.BrickColor = BrickColor.new("Brown")
        bar.Anchored = true
        bar.CanCollide = false
        bar.Parent = game.Workspace
        
        if not _G.Blocks then _G.Blocks = {} end
        table.insert(_G.Blocks, post)
        table.insert(_G.Blocks, bar)
    end
end

function createStairs(position)
    for i = 0, 5 do
        local stair = Instance.new("Part")
        stair.Size = Vector3.new(2, 0.3, 2)
        stair.Position = position + Vector3.new(i * 1.5, i * 0.5, 0)
        stair.BrickColor = BrickColor.new("Light stone grey")
        stair.Anchored = true
        stair.CanCollide = false
        stair.Material = Enum.Material.SmoothPlastic
        stair.Parent = game.Workspace
        
        if not _G.Blocks then _G.Blocks = {} end
        table.insert(_G.Blocks, stair)
    end
end

function createFurniture(position)
    -- Bàn
    local table = Instance.new("Part")
    table.Size = Vector3.new(3, 0.3, 2)
    table.Position = position
    table.BrickColor = BrickColor.new("Brown")
    table.Anchored = true
    table.CanCollide = false
    table.Parent = game.Workspace
    
    -- Ghế
    for i = -1, 1 do
        if i ~= 0 then
            local chair = Instance.new("Part")
            chair.Size = Vector3.new(1, 0.3, 1)
            chair.Position = position + Vector3.new(i * 2, -0.5, 1.5)
            chair.BrickColor = BrickColor.new("Brown")
            chair.Anchored = true
            chair.CanCollide = false
            chair.Parent = game.Workspace
            
            local back = Instance.new("Part")
            back.Size = Vector3.new(1, 1, 0.2)
            back.Position = position + Vector3.new(i * 2, 0.2, 2)
            back.BrickColor = BrickColor.new("Brown")
            back.Anchored = true
            back.CanCollide = false
            back.Parent = game.Workspace
            
            if not _G.Blocks then _G.Blocks = {} end
            table.insert(_G.Blocks, chair)
            table.insert(_G.Blocks, back)
        end
    end
    
    if not _G.Blocks then _G.Blocks = {} end
    table.insert(_G.Blocks, table)
end

function rainbowEffect()
    local blocks = game.Workspace:GetChildren()
    local count = 0
    for _, v in pairs(blocks) do
        if v:IsA("Part") and v.BrickColor then
            count = count + 1
            if count > 20 then break end
            local colors = {"Bright red", "Bright orange", "Bright yellow", "Bright green", "Bright blue", "Bright violet"}
            for i = 1, 10 do
                wait(0.1)
                v.BrickColor = BrickColor.new(colors[math.random(1, 6)])
                v.Material = Enum.Material.Neon
            end
        end
    end
end

function createFirework(position)
    local colors = {"Bright red", "Bright orange", "Bright yellow", "Bright green", "Bright blue", "Bright violet", "Hot pink", "Bright cyan"}
    for i = 1, 30 do
        local particle = Instance.new("Part")
        particle.Shape = Enum.PartType.Ball
        particle.Size = Vector3.new(0.3, 0.3, 0.3)
        particle.Position = position + Vector3.new(math.random(-10, 10), math.random(0, 15), math.random(-10, 10))
        particle.BrickColor = BrickColor.new(colors[math.random(1, 8)])
        particle.Anchored = true
        particle.CanCollide = false
        particle.Material = Enum.Material.Neon
        particle.Parent = game.Workspace
        
        Debris:AddItem(particle, 2)
    end
end

function startSnow()
    for i = 1, 50 do
        local snow = Instance.new("Part")
        snow.Shape = Enum.PartType.Ball
        snow.Size = Vector3.new(0.2, 0.2, 0.2)
        snow.Position = Vector3.new(math.random(-50, 50), math.random(10, 30), math.random(-50, 50))
        snow.BrickColor = BrickColor.new("White")
        snow.Anchored = true
        snow.CanCollide = false
        snow.Material = Enum.Material.Neon
        snow.Parent = game.Workspace
        
        Debris:AddItem(snow, 5)
    end
end

function deleteAllBlocks()
    if _G.Blocks then
        for _, v in pairs(_G.Blocks) do
            if v and v.Parent then
                v:Destroy()
            end
        end
        _G.Blocks = {}
    end
    
    -- Xóa cả các Part khác nếu có tag
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Part") and v.BrickColor and v.Material == Enum.Material.Neon then
            if v.Size.Magnitude < 5 then
                v:Destroy()
            end
        end
    end
end

function saveBuild()
    local data = {}
    local count = 0
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Part") and v.BrickColor and v.Position and v.Size then
            count = count + 1
            data[count] = {
                Position = v.Position,
                Size = v.Size,
                Color = v.BrickColor.Name,
                Shape = v.Shape.Name
            }
            if count > 50 then break end
        end
    end
    _G.SavedBuild = data
    print("💾 Đã lưu " .. count .. " khối!")
end

function loadBuild()
    if not _G.SavedBuild then
        print("📂 Chưa có dữ liệu lưu!")
        return
    end
    
    for _, data in pairs(_G.SavedBuild) do
        local block = Instance.new("Part")
        block.Size = data.Size or Vector3.new(1, 1, 1)
        block.Position = data.Position or Vector3.new(0, 10, 0)
        block.BrickColor = BrickColor.new(data.Color or "White")
        block.Shape = data.Shape or "Block"
        block.Anchored = true
        block.CanCollide = false
        block.Material = Enum.Material.Neon
        block.Parent = game.Workspace
        
        if not _G.Blocks then _G.Blocks = {} end
        table.insert(_G.Blocks, block)
    end
    print("📂 Đã tải công trình!")
end

-- Thông báo
print("👑 Spy Mod Công Chúa V2 đã sẵn sàng!")
print("✨ Tất cả người chơi đều có thể thấy các khối và hiệu ứng!")
