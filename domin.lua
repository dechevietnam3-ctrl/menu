-- ███████████████████████████████████████████████████████████████
-- ███        MINESWEEPER HACK - BOMB DETECTOR v1.0          ███
-- ███    Script hack cho game bLockerman's Minesweeper       ███
-- ███████████████████████████████████████████████████████████████

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- [1] TRẠNG THÁI
-- ============================================================
local MinesweeperHack = {
    Active = false,
    ShowBombs = false,
    AutoPlay = false,
    SafeMode = true,
    HighlightBombs = {},
    Connections = {},
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

-- ============================================================
-- [3] TÌM CÁC Ô (CELLS) TRONG GAME
-- ============================================================
local function FindGameCells()
    local cells = {}
    
    -- Tìm các ô trong game (thường là Part hoặc Model)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        -- Tìm các ô dựa trên tên hoặc thuộc tính đặc trưng
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = obj.Name:lower()
            if name:find("cell") or name:find("tile") or name:find("block") or name:find("square") then
                table.insert(cells, obj)
            end
        end
    end
    
    -- Nếu không tìm thấy, thử tìm trong ReplicatedStorage
    if #cells == 0 then
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("Part") then
                local name = obj.Name:lower()
                if name:find("cell") or name:find("tile") or name:find("block") then
                    table.insert(cells, obj)
                end
            end
        end
    end
    
    return cells
end

-- ============================================================
-- [4] PHÁT HIỆN BOM (MINES)
-- ============================================================
local function DetectBombs()
    local bombs = {}
    local cells = FindGameCells()
    
    for _, cell in ipairs(cells) do
        -- Kiểm tra các thuộc tính có thể chỉ ra bomb
        local isBomb = false
        
        -- Kiểm tra tên
        local name = cell.Name:lower()
        if name:find("bomb") or name:find("mine") or name:find("explosive") then
            isBomb = true
        end
        
        -- Kiểm tra thuộc tính (nếu có)
        if cell:GetAttribute("IsBomb") then
            isBomb = true
        end
        
        -- Kiểm tra màu sắc (thường bomb có màu đặc trưng)
        if cell:IsA("Part") then
            local color = cell.Color
            if color == Color3.fromRGB(255, 0, 0) or color == Color3.fromRGB(200, 0, 0) then
                isBomb = true
            end
        end
        
        if isBomb then
            table.insert(bombs, cell)
        end
    end
    
    return bombs
end

-- ============================================================
-- [5] HIỂN THỊ BOM (HIGHLIGHT)
-- ============================================================
local function HighlightBombs()
    -- Xóa highlight cũ
    for _, highlight in ipairs(MinesweeperHack.HighlightBombs) do
        pcall(highlight.Destroy, highlight)
    end
    MinesweeperHack.HighlightBombs = {}
    
    if not MinesweeperHack.ShowBombs then return end
    
    local bombs = DetectBombs()
    
    for _, bomb in ipairs(bombs) do
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.3
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Adornee = bomb
        highlight.Parent = bomb
        
        table.insert(MinesweeperHack.HighlightBombs, highlight)
    end
    
    Notify("Minesweeper Hack", "Đã tìm thấy " .. #bombs .. " quả bom!", 3)
end

-- ============================================================
-- [6] TỰ ĐỘNG CHƠI (AUTO PLAY)
-- ============================================================
local function AutoPlay()
    if not MinesweeperHack.AutoPlay then return end
    
    -- Tìm các ô an toàn và click vào chúng
    local cells = FindGameCells()
    local safeCells = {}
    
    for _, cell in ipairs(cells) do
        -- Kiểm tra ô có phải bom không
        local isBomb = false
        local name = cell.Name:lower()
        if name:find("bomb") or name:find("mine") then
            isBomb = true
        end
        
        if not isBomb then
            table.insert(safeCells, cell)
        end
    end
    
    -- Click vào các ô an toàn
    for _, cell in ipairs(safeCells) do
        if not MinesweeperHack.AutoPlay then break end
        
        -- Mô phỏng click
        pcall(function()
            if cell:IsA("Model") then
                local clickDetector = cell:FindFirstChildOfClass("ClickDetector")
                if clickDetector then
                    fireclickdetector(clickDetector)
                end
            elseif cell:IsA("Part") then
                local clickDetector = cell:FindFirstChildOfClass("ClickDetector")
                if clickDetector then
                    fireclickdetector(clickDetector)
                end
            end
        end)
        
        task.wait(0.05)
    end
end

-- ============================================================
-- [7] BẬT/TẮT CÁC TÍNH NĂNG
-- ============================================================
local function ToggleBombDetector()
    MinesweeperHack.ShowBombs = not MinesweeperHack.ShowBombs
    HighlightBombs()
    Notify("Bomb Detector", MinesweeperHack.ShowBombs and "ĐÃ BẬT - Bom sẽ hiển thị màu đỏ" or "ĐÃ TẮT", 2)
end

local function ToggleAutoPlay()
    MinesweeperHack.AutoPlay = not MinesweeperHack.AutoPlay
    
    if MinesweeperHack.AutoPlay then
        Notify("Auto Play", "Đã bật tự động chơi!", 2)
        task.spawn(function()
            while MinesweeperHack.AutoPlay do
                AutoPlay()
                task.wait(0.5)
            end
        end)
    else
        Notify("Auto Play", "Đã tắt tự động chơi", 2)
    end
end

-- ============================================================
-- [8] TẠO UI
-- ============================================================
local function CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MinesweeperHack"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Size = UDim2.new(0, 280, 0, 220)
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
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Parent = mainFrame
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "💣 MINESWEEPER HACK"
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 11
    
    -- Close button
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
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Scrolling Frame
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
    
    -- Hàm tạo button
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
    
    -- Các nút chức năng
    CreateButton("💣 Phát hiện bom", Color3.fromRGB(255, 50, 50), ToggleBombDetector)
    CreateButton("🤖 Tự động chơi", Color3.fromRGB(50, 200, 100), ToggleAutoPlay)
    CreateButton("🔄 Quét lại bom", Color3.fromRGB(100, 150, 255), function()
        HighlightBombs()
    end)
    CreateButton("❓ Tìm ô an toàn", Color3.fromRGB(200, 200, 100), function()
        local cells = FindGameCells()
        local safe = 0
        for _, cell in ipairs(cells) do
            local name = cell.Name:lower()
            if not name:find("bomb") and not name:find("mine") then
                safe = safe + 1
            end
        end
        Notify("Safe Cells", "Tìm thấy " .. safe .. " ô an toàn", 2)
    end)
    
    return screenGui
end

-- ============================================================
-- [9] PHÍM TẮT
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode
    
    if key == Enum.KeyCode.RightShift then
        local gui = LocalPlayer.PlayerGui:FindFirstChild("MinesweeperHack")
        if gui then
            gui:Destroy()
        else
            CreateUI()
        end
    end
    
    if key == Enum.KeyCode.F1 then
        ToggleBombDetector()
    end
    
    if key == Enum.KeyCode.F2 then
        ToggleAutoPlay()
    end
end)

-- ============================================================
-- [10] KHỞI TẠO
-- ============================================================
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("💣 MINESWEEPER HACK - Đang khởi tạo...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

task.wait(0.5)
CreateUI()

print("✅ MINESWEEPER HACK đã sẵn sàng!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("📖 HƯỚNG DẪN:")
print("   • Nhấn Right Shift để mở/tắt menu")
print("   • F1 - Bật/Tắt phát hiện bom")
print("   • F2 - Bật/Tắt tự động chơi")
print("   • Bom sẽ hiển thị màu đỏ khi bật detection")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

Notify("💣 Minesweeper Hack", "Đã tải thành công! Nhấn Right Shift để mở menu.", 4)

return {
    ToggleBombDetector = ToggleBombDetector,
    ToggleAutoPlay = ToggleAutoPlay,
    HighlightBombs = HighlightBombs,
    FindGameCells = FindGameCells,
    DetectBombs = DetectBombs,
}
