-- ███████████████████████████████████████████████████████████████
-- ███        MINESWEEPER HACK v4 - ULTIMATE BOMB DETECTOR   ███
-- ███    Kết hợp tất cả phương pháp phát hiện bom            ███
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
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- [1] TRẠNG THÁI
-- ============================================================
local MinesweeperHack = {
    Active = false,
    ShowBombs = false,
    AutoMove = false,
    AutoPlay = false,
    AutoFlag = false,
    Bombs = {},
    SafeCells = {},
    HighlightBombs = {},
    HighlightSafe = {},
    Connections = {},
    Threads = {},
    LastPosition = nil,
    BombCount = 0,
    SafeCount = 0,
    MovedCount = 0,
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

local function CopyText(text)
    pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif Clipboard and Clipboard.set then Clipboard.set(text) end
    end)
end

-- ============================================================
-- [3] PHÁT HIỆN BOM CỰC MẠNH - 10+ PHƯƠNG PHÁP
-- ============================================================

-- Phương pháp 1: Phát hiện qua Script
local function DetectBombsByScript()
    local bombs = {}
    local bombKeywords = {
        "explode", "explosion", "bomb", "mine", "detonate", 
        "blast", "kill", "death", "explosive", "boom",
        "damage", "destroy", "remove", "clear", "nuke",
        "crash", "break", "delete", "erase", "wipe",
        "chain", "reaction", "trigger", "activate", "ignite"
    }
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            local source = obj.Source or ""
            local name = obj.Name:lower()
            
            for _, keyword in ipairs(bombKeywords) do
                if source:lower():find(keyword) or name:find(keyword) then
                    local parent = obj.Parent
                    while parent and parent ~= Workspace do
                        if parent:IsA("Model") or parent:IsA("Part") then
                            table.insert(bombs, parent)
                            break
                        end
                        parent = parent.Parent
                    end
                    break
                end
            end
        end
    end
    return bombs
end

-- Phương pháp 2: Phát hiện qua Remote
local function DetectBombsByRemote()
    local bombs = {}
    local remoteKeywords = {
        "explode", "bomb", "mine", "detonate", "blast", 
        "kill", "damage", "death", "nuke", "crash",
        "trigger", "activate", "ignite", "boom", "remove"
    }
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            for _, keyword in ipairs(remoteKeywords) do
                if name:find(keyword) then
                    local parent = obj.Parent
                    while parent and parent ~= Workspace do
                        if parent:IsA("Model") or parent:IsA("Part") then
                            table.insert(bombs, parent)
                            break
                        end
                        parent = parent.Parent
                    end
                    break
                end
            end
        end
    end
    return bombs
end

-- Phương pháp 3: Phát hiện qua ClickDetector
local function DetectBombsByClickDetector()
    local bombs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") then
            local parent = obj.Parent
            if parent and (parent:IsA("Model") or parent:IsA("Part")) then
                local parentName = parent.Name:lower()
                if parentName:find("bomb") or parentName:find("mine") or 
                   parentName:find("cell") or parentName:find("tile") or
                   parentName:find("block") or parentName:find("square") then
                    table.insert(bombs, parent)
                end
            end
        end
    end
    return bombs
end

-- Phương pháp 4: Phát hiện qua ProximityPrompt
local function DetectBombsByProximity()
    local bombs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local parent = obj.Parent
            if parent and (parent:IsA("Model") or parent:IsA("Part")) then
                local parentName = parent.Name:lower()
                if parentName:find("bomb") or parentName:find("mine") or parentName:find("cell") then
                    table.insert(bombs, parent)
                end
            end
        end
    end
    return bombs
end

-- Phương pháp 5: Phát hiện qua TouchTransmitter
local function DetectBombsByTouch()
    local bombs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("TouchTransmitter") then
            local parent = obj.Parent
            if parent and (parent:IsA("Model") or parent:IsA("Part")) then
                local parentName = parent.Name:lower()
                if parentName:find("bomb") or parentName:find("mine") or parentName:find("cell") then
                    table.insert(bombs, parent)
                end
            end
        end
    end
    return bombs
end

-- Phương pháp 6: Phát hiện qua Animation (bom có animation nổ)
local function DetectBombsByAnimation()
    local bombs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Animation") or obj:IsA("Animator") then
            local parent = obj.Parent
            while parent and parent ~= Workspace do
                if parent:IsA("Model") or parent:IsA("Part") then
                    local parentName = parent.Name:lower()
                    if parentName:find("bomb") or parentName:find("mine") or parentName:find("cell") then
                        table.insert(bombs, parent)
                        break
                    end
                end
                parent = parent.Parent
            end
        end
    end
    return bombs
end

-- Phương pháp 7: Phát hiện qua ParticleEmitter (bom thường có hiệu ứng)
local function DetectBombsByParticle()
    local bombs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            local parent = obj.Parent
            while parent and parent ~= Workspace do
                if parent:IsA("Model") or parent:IsA("Part") then
                    local parentName = parent.Name:lower()
                    if parentName:find("bomb") or parentName:find("mine") or parentName:find("cell") then
                        table.insert(bombs, parent)
                        break
                    end
                end
                parent = parent.Parent
            end
        end
    end
    return bombs
end

-- Phương pháp 8: Phát hiện qua Sound (bom có âm thanh)
local function DetectBombsBySound()
    local bombs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            local parent = obj.Parent
            while parent and parent ~= Workspace do
                if parent:IsA("Model") or parent:IsA("Part") then
                    local parentName = parent.Name:lower()
                    if parentName:find("bomb") or parentName:find("mine") or parentName:find("cell") then
                        table.insert(bombs, parent)
                        break
                    end
                end
                parent = parent.Parent
            end
        end
    end
    return bombs
end

-- Phương pháp 9: Phát hiện qua tên + màu sắc + thuộc tính
local function DetectBombsByProperties()
    local bombs = {}
    local cells = {}
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = obj.Name:lower()
            if name:find("cell") or name:find("tile") or name:find("block") or 
               name:find("square") or name:find("grid") or name:find("field") then
                table.insert(cells, obj)
            end
        end
    end
    
    for _, cell in ipairs(cells) do
        local isBomb = false
        local name = cell.Name:lower()
        
        -- Tên
        if name:find("bomb") or name:find("mine") or name:find("explosive") or 
           name:find("danger") or name:find("deadly") or name:find("hazard") then
            isBomb = true
        end
        
        -- Attribute
        if cell:GetAttribute("IsBomb") or cell:GetAttribute("Mine") or 
           cell:GetAttribute("Danger") or cell:GetAttribute("Explosive") or
           cell:GetAttribute("Hidden") or cell:GetAttribute("Secret") then
            isBomb = true
        end
        
        -- Màu sắc (nếu là Part)
        if cell:IsA("Part") then
            local color = cell.Color
            if color == Color3.fromRGB(255, 0, 0) or color == Color3.fromRGB(200, 0, 0) or 
               color == Color3.fromRGB(255, 50, 50) or color == Color3.fromRGB(180, 0, 0) then
                isBomb = true
            end
        end
        
        -- Tag
        if CollectionService:HasTag(cell, "Bomb") or CollectionService:HasTag(cell, "Mine") or
           CollectionService:HasTag(cell, "Explosive") or CollectionService:HasTag(cell, "Danger") then
            isBomb = true
        end
        
        if isBomb then
            table.insert(bombs, cell)
        end
    end
    
    return bombs
end

-- Phương pháp 10: Phát hiện qua Configuration (cấu hình bom)
local function DetectBombsByConfig()
    local bombs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Configuration") or obj:IsA("Folder") then
            local name = obj.Name:lower()
            if name:find("bomb") or name:find("mine") or name:find("explosive") or name:find("danger") then
                local parent = obj.Parent
                while parent and parent ~= Workspace do
                    if parent:IsA("Model") or parent:IsA("Part") then
                        table.insert(bombs, parent)
                        break
                    end
                    parent = parent.Parent
                end
            end
        end
    end
    return bombs
end

-- Phương pháp 11: Phát hiện qua Humanoid (bom có thể là NPC)
local function DetectBombsByHumanoid()
    local bombs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Humanoid") then
            local parent = obj.Parent
            if parent and parent:IsA("Model") then
                local parentName = parent.Name:lower()
                if parentName:find("bomb") or parentName:find("mine") or 
                   parentName:find("explosive") or parentName:find("danger") then
                    table.insert(bombs, parent)
                end
            end
        end
    end
    return bombs
end

-- ============================================================
-- [4] PHÁT HIỆN BOM TỔNG HỢP (TẤT CẢ PHƯƠNG PHÁP)
-- ============================================================
local function DetectAllBombs()
    local allBombs = {}
    local methods = {
        {name = "Script", func = DetectBombsByScript},
        {name = "Remote", func = DetectBombsByRemote},
        {name = "ClickDetector", func = DetectBombsByClickDetector},
        {name = "ProximityPrompt", func = DetectBombsByProximity},
        {name = "TouchTransmitter", func = DetectBombsByTouch},
        {name = "Animation", func = DetectBombsByAnimation},
        {name = "Particle", func = DetectBombsByParticle},
        {name = "Sound", func = DetectBombsBySound},
        {name = "Properties", func = DetectBombsByProperties},
        {name = "Configuration", func = DetectBombsByConfig},
        {name = "Humanoid", func = DetectBombsByHumanoid},
    }
    
    for _, method in ipairs(methods) do
        local bombs = method.func()
        for _, bomb in ipairs(bombs) do
            local isDuplicate = false
            for _, existing in ipairs(allBombs) do
                if existing == bomb then
                    isDuplicate = true
                    break
                end
            end
            if not isDuplicate then
                table.insert(allBombs, bomb)
            end
        end
    end
    
    MinesweeperHack.Bombs = allBombs
    MinesweeperHack.BombCount = #allBombs
    
    return allBombs
end

-- ============================================================
-- [5] TÌM Ô AN TOÀN
-- ============================================================
local function FindSafeCells()
    local safeCells = {}
    local allCells = {}
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = obj.Name:lower()
            if name:find("cell") or name:find("tile") or name:find("block") or 
               name:find("square") or name:find("grid") or name:find("field") then
                table.insert(allCells, obj)
            end
        end
    end
    
    for _, cell in ipairs(allCells) do
        local isBomb = false
        for _, bomb in ipairs(MinesweeperHack.Bombs) do
            if cell == bomb then
                isBomb = true
                break
            end
        end
        if not isBomb then
            table.insert(safeCells, cell)
        end
    end
    
    MinesweeperHack.SafeCells = safeCells
    MinesweeperHack.SafeCount = #safeCells
    return safeCells
end

-- ============================================================
-- [6] HIỂN THỊ BOM (ESP) + HIỂN THỊ Ô AN TOÀN
-- ============================================================
local function HighlightBombs()
    -- Xóa highlight cũ
    for _, highlight in ipairs(MinesweeperHack.HighlightBombs) do
        pcall(highlight.Destroy, highlight)
    end
    MinesweeperHack.HighlightBombs = {}
    
    for _, highlight in ipairs(MinesweeperHack.HighlightSafe) do
        pcall(highlight.Destroy, highlight)
    end
    MinesweeperHack.HighlightSafe = {}
    
    if not MinesweeperHack.ShowBombs then return end
    
    local bombs = DetectAllBombs()
    
    -- Highlight bom màu đỏ
    for _, bomb in ipairs(bombs) do
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.2
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Adornee = bomb
        highlight.Parent = bomb
        table.insert(MinesweeperHack.HighlightBombs, highlight)
        
        -- Billboard BOMB
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = bomb
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = bomb
        
        local label = Instance.new("TextLabel")
        label.Parent = billboard
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "💣 BOMB!"
        label.TextColor3 = Color3.fromRGB(255, 0, 0)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.ZIndex = 20
        table.insert(MinesweeperHack.HighlightBombs, billboard)
    end
    
    -- Highlight ô an toàn màu xanh (tùy chọn)
    if MinesweeperHack.AutoPlay then
        local safeCells = FindSafeCells()
        for _, cell in ipairs(safeCells) do
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.FillTransparency = 0.2
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0.5
            highlight.Adornee = cell
            highlight.Parent = cell
            table.insert(MinesweeperHack.HighlightSafe, highlight)
        end
    end
    
    Notify("Minesweeper Hack", "Đã tìm thấy " .. #bombs .. " quả bom!", 3)
end

-- ============================================================
-- [7] CẢNH BÁO KHI ĐẾN GẦN BOM
-- ============================================================
local function CheckBombProximity()
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = GetRoot(char)
    if not root then return end
    
    local playerPos = root.Position
    local nearBombs = {}
    
    for _, bomb in ipairs(MinesweeperHack.Bombs) do
        local bombPos, _ = GetBoundingBox(bomb)
        if bombPos then
            local distance = (bombPos - playerPos).Magnitude
            if distance < 20 then
                table.insert(nearBombs, {bomb = bomb, distance = distance})
            end
        end
    end
    
    table.sort(nearBombs, function(a, b) return a.distance < b.distance end)
    
    if #nearBombs > 0 then
        local closest = nearBombs[1]
        local color = closest.distance < 5 and "🔴" or closest.distance < 10 and "🟡" or "🟢"
        Notify("⚠️ CẢNH BÁO BOM! " .. color, 
            "Cách bom " .. math.floor(closest.distance) .. " studs!", 1)
    end
end

-- ============================================================
-- [8] TÌM Ô AN TOÀN GẦN NHẤT
-- ============================================================
local function FindClosestSafeCell()
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    
    local root = GetRoot(char)
    if not root then return nil, nil end
    
    local playerPos = root.Position
    local safeCells = FindSafeCells()
    local closest = nil
    local closestDist = math.huge
    local closestPos = nil
    
    for _, cell in ipairs(safeCells) do
        local cellPos, _ = GetBoundingBox(cell)
        if cellPos then
            local dist = (cellPos - playerPos).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = cell
                closestPos = cellPos
            end
        end
    end
    
    return closest, closestPos
end

-- ============================================================
-- [9] DI CHUYỂN ĐẾN Ô AN TOÀN
-- ============================================================
local function MoveToCell(targetCell)
    local char = LocalPlayer.Character
    if not char then return false end
    
    local root = GetRoot(char)
    if not root then return false end
    
    local targetPos, _ = GetBoundingBox(targetCell)
    if not targetPos then return false end
    
    local hum = GetHumanoid(char)
    if hum then
        hum:MoveTo(targetPos)
        MinesweeperHack.MovedCount = MinesweeperHack.MovedCount + 1
        return true
    end
    
    return false
end

-- ============================================================
-- [10] TỰ ĐỘNG DI CHUYỂN + AUTO PLAY
-- ============================================================
local function AutoMoveToSafe()
    if not MinesweeperHack.AutoMove then return end
    
    local target, targetPos = FindClosestSafeCell()
    if target then
        MoveToCell(target)
        Notify("Auto Move", "Đang di chuyển đến ô an toàn!", 1)
    else
        Notify("Auto Move", "Không tìm thấy ô an toàn!", 2)
    end
end

local function AutoPlayLoop()
    if not MinesweeperHack.AutoPlay then return end
    
    CheckBombProximity()
    
    local target, targetPos = FindClosestSafeCell()
    if not target then
        Notify("Auto Play", "Không tìm thấy ô an toàn!", 2)
        return
    end
    
    MoveToCell(target)
    task.wait(0.5)
    
    pcall(function()
        local clickDetector = target:FindFirstChildOfClass("ClickDetector")
        if clickDetector then
            fireclickdetector(clickDetector)
        end
    end)
    
    task.wait(0.3)
end

-- ============================================================
-- [11] TỰ ĐỘNG ĐÁNH DẤU BOM (FLAG)
-- ============================================================
local function AutoFlagBombs()
    if not MinesweeperHack.AutoFlag then return end
    
    for _, bomb in ipairs(MinesweeperHack.Bombs) do
        pcall(function()
            -- Tìm cách đánh dấu bom (tùy game)
            local clickDetector = bomb:FindFirstChildOfClass("ClickDetector")
            if clickDetector then
                -- Click chuột phải để đánh dấu (nếu game hỗ trợ)
                -- fireclickdetector(clickDetector, 1) -- right click
            end
        end)
    end
end

-- ============================================================
-- [12] BẬT/TẮT CÁC TÍNH NĂNG
-- ============================================================
local function ToggleBombDetector()
    MinesweeperHack.ShowBombs = not MinesweeperHack.ShowBombs
    if MinesweeperHack.ShowBombs then
        DetectAllBombs()
        HighlightBombs()
    else
        for _, highlight in ipairs(MinesweeperHack.HighlightBombs) do
            pcall(highlight.Destroy, highlight)
        end
        MinesweeperHack.HighlightBombs = {}
        for _, highlight in ipairs(MinesweeperHack.HighlightSafe) do
            pcall(highlight.Destroy, highlight)
        end
        MinesweeperHack.HighlightSafe = {}
    end
    Notify("Bomb Detector", MinesweeperHack.ShowBombs and "ĐÃ BẬT - Bom sẽ hiển thị" or "ĐÃ TẮT", 2)
end

local function ToggleAutoMove()
    MinesweeperHack.AutoMove = not MinesweeperHack.AutoMove
    
    if MinesweeperHack.AutoMove then
        Notify("Auto Move", "Đã bật tự động di chuyển!", 2)
        task.spawn(function()
            while MinesweeperHack.AutoMove do
                AutoMoveToSafe()
                task.wait(0.5)
            end
        end)
    else
        Notify("Auto Move", "Đã tắt tự động di chuyển", 2)
    end
end

local function ToggleAutoPlay()
    MinesweeperHack.AutoPlay = not MinesweeperHack.AutoPlay
    
    if MinesweeperHack.AutoPlay then
        Notify("Auto Play", "Đã bật tự động chơi!", 2)
        task.spawn(function()
            while MinesweeperHack.AutoPlay do
                AutoPlayLoop()
                task.wait(0.5)
            end
        end)
    else
        Notify("Auto Play", "Đã tắt tự động chơi", 2)
    end
end

local function ToggleAutoFlag()
    MinesweeperHack.AutoFlag = not MinesweeperHack.AutoFlag
    
    if MinesweeperHack.AutoFlag then
        Notify("Auto Flag", "Đã bật tự động đánh dấu bom!", 2)
        task.spawn(function()
            while MinesweeperHack.AutoFlag do
                AutoFlagBombs()
                task.wait(1)
            end
        end)
    else
        Notify("Auto Flag", "Đã tắt tự động đánh dấu bom", 2)
    end
end

-- ============================================================
-- [13] QUÉT TỰ ĐỘNG
-- ============================================================
local function ScanForBombs()
    task.wait(2)
    DetectAllBombs()
    FindSafeCells()
    Notify("Scan Complete", 
        "Bombs: " .. MinesweeperHack.BombCount .. 
        " | Safe: " .. MinesweeperHack.SafeCount, 3)
end

-- ============================================================
-- [14] TẠO UI
-- ============================================================
local function CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MinesweeperHack"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Size = UDim2.new(0, 280, 0, 320)
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
    stroke.Color = Color3.fromRGB(255, 200, 50)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Parent = mainFrame
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "💣 MINESWEEPER HACK v4"
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 11
    
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
    scroll.Size = UDim2.new(1, -10, 1, -45)
    scroll.Position = UDim2.new(0, 5, 0, 40)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 50)
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
        btnStroke.Color = color or Color3.fromRGB(255, 200, 50)
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
    
    CreateButton("💣 Phát hiện bom (ESP)", Color3.fromRGB(255, 50, 50), ToggleBombDetector)
    CreateButton("🚶 Tự động di chuyển", Color3.fromRGB(100, 200, 255), ToggleAutoMove)
    CreateButton("🤖 Tự động chơi", Color3.fromRGB(50, 200, 100), ToggleAutoPlay)
    CreateButton("🚩 Tự động đánh dấu bom", Color3.fromRGB(255, 200, 50), ToggleAutoFlag)
    CreateButton("🔍 Quét lại bom", Color3.fromRGB(100, 150, 255), function()
        DetectAllBombs()
        FindSafeCells()
        HighlightBombs()
        Notify("Scan", "Bombs: " .. MinesweeperHack.BombCount .. " | Safe: " .. MinesweeperHack.SafeCount, 3)
    end)
    CreateButton("📊 Thống kê", Color3.fromRGB(200, 200, 100), function()
        Notify("📊 Statistics", 
            "Bombs: " .. MinesweeperHack.BombCount .. 
            "\nSafe Cells: " .. MinesweeperHack.SafeCount ..
            "\nMoves: " .. MinesweeperHack.MovedCount, 3)
    end)
    
    return screenGui
end

-- ============================================================
-- [15] PHÍM TẮT
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode
    
    if key == Enum.KeyCode.RightShift then
        local gui = LocalPlayer.PlayerGui:FindFirstChild("MinesweeperHack")
        if gui then gui:Destroy() else CreateUI() end
    end
    
    if key == Enum.KeyCode.F1 then ToggleBombDetector() end
    if key == Enum.KeyCode.F2 then ToggleAutoMove() end
    if key == Enum.KeyCode.F3 then ToggleAutoPlay() end
    if key == Enum.KeyCode.F4 then AutoMoveToSafe() end
    if key == Enum.KeyCode.F5 then ToggleAutoFlag() end
end)

-- ============================================================
-- [16] LOOP KIỂM TRA BOM
-- ============================================================
task.spawn(function()
    while true do
        task.wait(1)
        if MinesweeperHack.ShowBombs then
            CheckBombProximity()
        end
    end
end)

-- ============================================================
-- [17] KHỞI TẠO
-- ============================================================
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("💣 MINESWEEPER HACK v4 - Đang khởi tạo...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

task.wait(0.5)
CreateUI()
ScanForBombs()

print("✅ MINESWEEPER HACK v4 đã sẵn sàng!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("📖 HƯỚNG DẪN:")
print("   • Right Shift - Mở menu")
print("   • F1 - Phát hiện bom (ESP + cảnh báo)")
print("   • F2 - Tự động di chuyển đến ô an toàn")
print("   • F3 - Tự động chơi")
print("   • F4 - Di chuyển đến ô an toàn gần nhất")
print("   • F5 - Tự động đánh dấu bom")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔍 11 PHƯƠNG PHÁP PHÁT HIỆN BOM:")
print("   1. Script   2. Remote   3. ClickDetector")
print("   4. Proximity 5. Touch    6. Animation")
print("   7. Particle  8. Sound    9. Properties")
print("   10. Config   11. Humanoid")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

Notify("💣 Minesweeper Hack v4", "Đã tải thành công! 11 phương pháp phát hiện bom.", 4)

return {
    ToggleBombDetector = ToggleBombDetector,
    ToggleAutoMove = ToggleAutoMove,
    ToggleAutoPlay = ToggleAutoPlay,
    ToggleAutoFlag = ToggleAutoFlag,
    DetectAllBombs = DetectAllBombs,
    HighlightBombs = HighlightBombs,
    FindSafeCells = FindSafeCells,
    FindClosestSafeCell = FindClosestSafeCell,
    AutoMoveToSafe = AutoMoveToSafe,
}
