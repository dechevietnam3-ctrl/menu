--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║  👁️ SPECTER EVADE ULTIMATE - Auto Play + ESP                  ║
    ║  Tác giả: Cộng đồng phát triển (Specter)                     ║
    ║  Version: 3.0 - Hỗ trợ Mobile/PC - Tối giản                  ║
    ╚══════════════════════════════════════════════════════════════════╝
--]]

-- ====== KIỂM TRA ======
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Đợi game load
if not game:IsLoaded() then game.Loaded:Wait() end

-- ====== NGÔN NGỮ ======
local Languages = {
    ["Tiếng Việt"] = {
        title = "👁️ SPECTER EVADE",
        toggle_esp = "🔴 TẮT ESP",
        toggle_auto = "🤖 TẮT AUTO",
        toggle_players = "👥 Người chơi",
        toggle_chasers = "👹 Chaser",
        toggle_items = "📦 Vật phẩm",
        toggle_coins = "🪙 Xu",
        toggle_traps = "⚠️ Bẫy",
        toggle_distance = "📏 Khoảng cách",
        toggle_names = "🏷️ Tên",
        auto_status = "Trạng thái:",
        auto_idle = "Đợi tìm chaser...",
        auto_hide = "Đang trốn...",
        auto_run = "Đang chạy...",
        auto_collect = "Đang nhặt vật phẩm...",
        notification = "Đã tải thành công!",
        settings = "⚙️ Cài đặt",
        language = "🌍 Ngôn ngữ",
        mobile_mode = "📱 Chế độ điện thoại",
        pc_mode = "💻 Chế độ PC",
    },
    ["English"] = {
        title = "👁️ SPECTER EVADE",
        toggle_esp = "🔴 ESP OFF",
        toggle_auto = "🤖 AUTO OFF",
        toggle_players = "👥 Players",
        toggle_chasers = "👹 Chaser",
        toggle_items = "📦 Items",
        toggle_coins = "🪙 Coins",
        toggle_traps = "⚠️ Traps",
        toggle_distance = "📏 Distance",
        toggle_names = "🏷️ Names",
        auto_status = "Status:",
        auto_idle = "Waiting for chaser...",
        auto_hide = "Hiding...",
        auto_run = "Running...",
        auto_collect = "Collecting items...",
        notification = "Loaded successfully!",
        settings = "⚙️ Settings",
        language = "🌍 Language",
        mobile_mode = "📱 Mobile mode",
        pc_mode = "💻 PC mode",
    }
}

-- ====== CẤU HÌNH ======
local Config = {
    Language = "Tiếng Việt",
    Enabled = true,
    AutoPlay = false,
    ShowPlayers = true,
    ShowChasers = true,
    ShowItems = true,
    ShowCoins = true,
    ShowTraps = true,
    ShowDistance = true,
    ShowNames = true,
    IsMobile = false,
}

local L = Languages[Config.Language]

-- ====== DỊCH ======
local function translate(key)
    return Languages[Config.Language][key] or key
end

-- ====== TẠO MENU TỐI GIẢN ======
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "SpecterGUI"

-- Kiểm tra mobile
local isMobile = UserInputService.TouchEnabled
Config.IsMobile = isMobile

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = isMobile and UDim2.new(0.85, 0, 0, 450) or UDim2.new(0, 280, 0, 420)
MainFrame.Position = isMobile and UDim2.new(0.075, 0, 0.1, 0) or UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Bo góc
local Corner = Instance.new("UICorner")
Corner.Parent = MainFrame
Corner.CornerRadius = UDim.new(0, 16)

-- Viền neon
local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(150, 50, 255)
Stroke.Thickness = 2
Stroke.Transparency = 0.3

-- ====== HEADER ======
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 16)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "👁️ SPECTER EVADE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = isMobile and 20 or 18
TitleLabel.Font = Enum.Font.GothamBold

-- Nút Settings (bánh răng)
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Parent = Header
SettingsBtn.Size = UDim2.new(0, 40, 0, 40)
SettingsBtn.Position = UDim2.new(1, -45, 0, 5)
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Text = "⚙️"
SettingsBtn.TextSize = 22
SettingsBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- ====== SCROLLING FRAME ======
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, 0, 1, -60)
ScrollFrame.Position = UDim2.new(0, 0, 0, 55)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Parent = ScrollFrame
ScrollLayout.Padding = UDim.new(0, 5)
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ====== HÀM TẠO BUTTON ======
local function createButton(parent, text, color, callback, order)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.92, 0, 0, 45)
    btn.Position = UDim2.new(0.04, 0, 0, 0)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 80)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = isMobile and 18 or 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    -- Hiệu ứng hover (chỉ PC)
    if not isMobile then
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)
    end
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ====== HÀM TẠO TOGGLE ======
local function createToggle(parent, text, getter, setter, order)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.92, 0, 0, 35)
    frame.Position = UDim2.new(0.04, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order or 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = isMobile and 16 or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0.3, 0, 0.8, 0)
    btn.Position = UDim2.new(0.7, 0, 0.1, 0)
    btn.BackgroundColor3 = getter() and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
    btn.Text = getter() and "BẬT" or "TẮT"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = isMobile and 14 or 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        local newVal = not getter()
        setter(newVal)
        btn.BackgroundColor3 = newVal and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
        btn.Text = newVal and "BẬT" or "TẮT"
    end)
    
    return frame
end

-- ====== TẠO CÁC MỤC TRONG MENU ======
local yOrder = 0

-- Nút ESP On/Off
local espBtn = createButton(ScrollFrame, translate("toggle_esp"), Color3.fromRGB(200, 50, 50), function()
    Config.Enabled = not Config.Enabled
    espBtn.Text = Config.Enabled and translate("toggle_esp") or "🟢 " .. translate("toggle_esp"):gsub("🔴", "🟢")
    espBtn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
end, yOrder)
yOrder = yOrder + 1

-- Nút Auto Play
local autoBtn = createButton(ScrollFrame, translate("toggle_auto"), Color3.fromRGB(50, 100, 200), function()
    Config.AutoPlay = not Config.AutoPlay
    autoBtn.Text = Config.AutoPlay and translate("toggle_auto"):gsub("🤖", "🟢") or "🤖 " .. translate("toggle_auto")
    autoBtn.BackgroundColor3 = Config.AutoPlay and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(50, 100, 200)
    
    if Config.AutoPlay then
        game.StarterGui:SetCore("SendNotification", {
            Title = "🤖 Auto Play",
            Text = "Đã bật chế độ tự động!",
            Duration = 2
        })
    end
end, yOrder)
yOrder = yOrder + 1

-- Status Auto
local statusFrame = Instance.new("Frame")
statusFrame.Parent = ScrollFrame
statusFrame.Size = UDim2.new(0.92, 0, 0, 30)
statusFrame.Position = UDim2.new(0.04, 0, 0, 0)
statusFrame.BackgroundTransparency = 1
statusFrame.LayoutOrder = yOrder
yOrder = yOrder + 1

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = statusFrame
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = translate("auto_status") .. " " .. translate("auto_idle")
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
statusLabel.TextSize = isMobile and 14 or 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Các toggle
local toggles = {}

toggles.players = createToggle(ScrollFrame, translate("toggle_players"), 
    function() return Config.ShowPlayers end, 
    function(v) Config.ShowPlayers = v end, yOrder)
yOrder = yOrder + 1

toggles.chasers = createToggle(ScrollFrame, translate("toggle_chasers"),
    function() return Config.ShowChasers end,
    function(v) Config.ShowChasers = v end, yOrder)
yOrder = yOrder + 1

toggles.items = createToggle(ScrollFrame, translate("toggle_items"),
    function() return Config.ShowItems end,
    function(v) Config.ShowItems = v end, yOrder)
yOrder = yOrder + 1

toggles.coins = createToggle(ScrollFrame, translate("toggle_coins"),
    function() return Config.ShowCoins end,
    function(v) Config.ShowCoins = v end, yOrder)
yOrder = yOrder + 1

toggles.traps = createToggle(ScrollFrame, translate("toggle_traps"),
    function() return Config.ShowTraps end,
    function(v) Config.ShowTraps = v end, yOrder)
yOrder = yOrder + 1

toggles.distance = createToggle(ScrollFrame, translate("toggle_distance"),
    function() return Config.ShowDistance end,
    function(v) Config.ShowDistance = v end, yOrder)
yOrder = yOrder + 1

toggles.names = createToggle(ScrollFrame, translate("toggle_names"),
    function() return Config.ShowNames end,
    function(v) Config.ShowNames = v end, yOrder)
yOrder = yOrder + 1

-- Cập nhật Canvas
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOrder * 45 + 50)

-- ====== SETTINGS POPUP ======
local SettingsPopup = Instance.new("Frame")
SettingsPopup.Parent = ScreenGui
SettingsPopup.Size = UDim2.new(0.8, 0, 0, 250)
SettingsPopup.Position = UDim2.new(0.1, 0, 0.2, 0)
SettingsPopup.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
SettingsPopup.BackgroundTransparency = 0.05
SettingsPopup.BorderSizePixel = 0
SettingsPopup.Visible = false

local PopupCorner = Instance.new("UICorner")
PopupCorner.Parent = SettingsPopup
PopupCorner.CornerRadius = UDim.new(0, 16)

local PopupStroke = Instance.new("UIStroke")
PopupStroke.Parent = SettingsPopup
PopupStroke.Color = Color3.fromRGB(150, 50, 255)
PopupStroke.Thickness = 2

local PopupTitle = Instance.new("TextLabel")
PopupTitle.Parent = SettingsPopup
PopupTitle.Size = UDim2.new(1, 0, 0, 40)
PopupTitle.BackgroundTransparency = 1
PopupTitle.Text = translate("settings")
PopupTitle.TextColor3 = Color3.fromRGB(255,255,255)
PopupTitle.TextSize = 20
PopupTitle.Font = Enum.Font.GothamBold

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = SettingsPopup
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255,100,100)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold

CloseBtn.MouseButton1Click:Connect(function()
    SettingsPopup.Visible = false
end)

-- Nút chọn ngôn ngữ
local LangBtn = createButton(SettingsPopup, "🌍 " .. translate("language"), Color3.fromRGB(60, 60, 100), function()
    if Config.Language == "Tiếng Việt" then
        Config.Language = "English"
    else
        Config.Language = "Tiếng Việt"
    end
    L = Languages[Config.Language]
    -- Cập nhật lại UI
    game.StarterGui:SetCore("SendNotification", {
        Title = "🌍 Ngôn ngữ",
        Text = "Đã chuyển sang: " .. Config.Language,
        Duration = 2
    })
    -- Refresh
    SettingsPopup.Visible = false
end, 0)

-- Chế độ mobile/pc
local ModeBtn = createButton(SettingsPopup, isMobile and translate("mobile_mode") or translate("pc_mode"), Color3.fromRGB(100, 60, 100), function()
    Config.IsMobile = not Config.IsMobile
    ModeBtn.Text = Config.IsMobile and translate("mobile_mode") or translate("pc_mode")
    game.StarterGui:SetCore("SendNotification", {
        Title = "📱 Chế độ",
        Text = Config.IsMobile and "Đã chuyển sang Mobile" or "Đã chuyển sang PC",
        Duration = 2
    })
end, 1)

SettingsBtn.MouseButton1Click:Connect(function()
    SettingsPopup.Visible = not SettingsPopup.Visible
end)

-- ====== ESP SYSTEM ======
local espObjects = {}
local espConnections = {}

-- Tạo ESP Box
local function createBox(character, color, text, isChaser)
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = head
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.MaxDistance = 200
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    billboard.Enabled = Config.Enabled
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = billboard
    nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = text or "Unknown"
    nameLabel.TextColor3 = color
    nameLabel.TextSize = isChaser and 18 or 14
    nameLabel.Font = isChaser and Enum.Font.GothamBold or Enum.Font.Gotham
    nameLabel.TextStrokeTransparency = 0.2
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Parent = billboard
    distLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = ""
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextSize = 11
    distLabel.Font = Enum.Font.Gotham
    
    return {
        BillBoard = billboard,
        NameLabel = nameLabel,
        DistLabel = distLabel,
        Head = head,
        Character = character,
        IsChaser = isChaser or false
    }
end

-- Cập nhật distance
local function updateDistance(data)
    if not data or not data.Head or not LocalPlayer.Character then return end
    
    local localHead = LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return end
    
    local dist = (localHead.Position - data.Head.Position).Magnitude
    if data.DistLabel then
        data.DistLabel.Text = string.format("%.1fm", dist)
        data.DistLabel.Visible = Config.ShowDistance
    end
    if data.NameLabel then
        data.NameLabel.Visible = Config.ShowNames
    end
end

-- Kiểm tra Chaser
local function isChaser(character)
    if not character then return false end
    
    local head = character:FindFirstChild("Head")
    if head and head.Size.Y > 2.5 then
        return true
    end
    
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if torso then
        for _, child in ipairs(torso:GetChildren()) do
            if child:IsA("BasePart") and child:FindFirstChild("Highlight") then
                return true
            end
        end
    end
    
    return false
end

-- ESP cho Player
local function setupPlayerESP(player)
    if player == LocalPlayer then return end
    
    player.CharacterAdded:Connect(function(character)
        task.wait(0.3)
        if not character then return end
        
        local chase = isChaser(character)
        if chase and not Config.ShowChasers then return end
        if not chase and not Config.ShowPlayers then return end
        
        local color = chase and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 200, 255)
        local name = chase and "👹 CHASER" or player.Name
        
        local data = createBox(character, color, name, chase)
        if data then
            espObjects[player] = data
            local conn = RunService.RenderStepped:Connect(function()
                if not Config.Enabled then
                    if data.BillBoard then data.BillBoard.Enabled = false end
                    return
                end
                if data.BillBoard then data.BillBoard.Enabled = true end
                updateDistance(data)
            end)
            espConnections[player] = conn
        end
    end)
    
    if player.Character then
        task.wait(0.5)
        local character = player.Character
        local chase = isChaser(character)
        if chase and Config.ShowChasers or not chase and Config.ShowPlayers then
            local color = chase and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 200, 255)
            local name = chase and "👹 CHASER" or player.Name
            local data = createBox(character, color, name, chase)
            if data then
                espObjects[player] = data
                local conn = RunService.RenderStepped:Connect(function()
                    if not Config.Enabled then
                        if data.BillBoard then data.BillBoard.Enabled = false end
                        return
                    end
                    if data.BillBoard then data.BillBoard.Enabled = true end
                    updateDistance(data)
                end)
                espConnections[player] = conn
            end
        end
    end
end

-- ====== ITEM ESP ======
local function setupItemESP()
    RunService.RenderStepped:Connect(function()
        if not Config.Enabled or not Config.ShowItems then
            for _, obj in pairs(espObjects) do
                if obj.Type == "Item" and obj.BillBoard then
                    obj.BillBoard.Enabled = false
                end
            end
            return
        end
        
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Tool") and item:FindFirstChild("Handle") then
                local handle = item:FindFirstChild("Handle")
                if handle and not espObjects[item] then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 100, 0, 30)
                    billboard.Adornee = handle
                    billboard.StudsOffset = Vector3.new(0, 1.5, 0)
                    billboard.MaxDistance = 100
                    billboard.AlwaysOnTop = true
                    billboard.Parent = handle
                    billboard.Enabled = Config.Enabled
                    
                    local label = Instance.new("TextLabel")
                    label.Parent = billboard
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "📦 " .. item.Name
                    label.TextColor3 = Color3.fromRGB(255, 200, 50)
                    label.TextSize = 12
                    label.Font = Enum.Font.GothamBold
                    label.TextStrokeTransparency = 0.3
                    label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                    
                    espObjects[item] = {
                        Type = "Item",
                        BillBoard = billboard,
                        Label = label
                    }
                end
            end
        end
    end)
end

-- ====== COIN ESP ======
local function setupCoinESP()
    RunService.RenderStepped:Connect(function()
        if not Config.Enabled or not Config.ShowCoins then return end
        
        for _, coin in ipairs(workspace:GetDescendants()) do
            if coin:IsA("Part") or coin:IsA("MeshPart") then
                local name = coin.Name:lower()
                if name:find("coin") or name:find("gold") then
                    if not espObjects["Coin_" .. coin.Name] then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Size = UDim2.new(0, 80, 0, 25)
                        billboard.Adornee = coin
                        billboard.StudsOffset = Vector3.new(0, 1.5, 0)
                        billboard.MaxDistance = 80
                        billboard.AlwaysOnTop = true
                        billboard.Parent = coin
                        billboard.Enabled = Config.Enabled
                        
                        local label = Instance.new("TextLabel")
                        label.Parent = billboard
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = "🪙 COIN"
                        label.TextColor3 = Color3.fromRGB(255, 215, 0)
                        label.TextSize = 14
                        label.Font = Enum.Font.GothamBold
                        label.TextStrokeTransparency = 0.3
                        label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                        
                        espObjects["Coin_" .. coin.Name] = {
                            Type = "Coin",
                            BillBoard = billboard,
                            Label = label
                        }
                    end
                end
            end
        end
    end)
end

-- ====== TRAP ESP ======
local function setupTrapESP()
    RunService.RenderStepped:Connect(function()
        if not Config.Enabled or not Config.ShowTraps then return end
        
        for _, trap in ipairs(workspace:GetDescendants()) do
            if trap:IsA("Part") or trap:IsA("MeshPart") then
                local name = trap.Name:lower()
                if name:find("trap") or name:find("spike") or name:find("hazard") then
                    if not espObjects["Trap_" .. trap.Name] then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = trap
                        highlight.FillColor = Color3.fromRGB(255, 100, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineColor = Color3.fromRGB(255,0,0)
                        highlight.OutlineTransparency = 0.2
                        highlight.Enabled = Config.Enabled
                        
                        local billboard = Instance.new("BillboardGui")
                        billboard.Size = UDim2.new(0, 80, 0, 25)
                        billboard.Adornee = trap
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.MaxDistance = 60
                        billboard.AlwaysOnTop = true
                        billboard.Parent = trap
                        billboard.Enabled = Config.Enabled
                        
                        local label = Instance.new("TextLabel")
                        label.Parent = billboard
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = "⚠️ BẪY"
                        label.TextColor3 = Color3.fromRGB(255, 100, 255)
                        label.TextSize = 14
                        label.Font = Enum.Font.GothamBold
                        label.TextStrokeTransparency = 0.3
                        label.TextStrokeColor3 = Color3.fromRGB(255,0,0)
                        
                        espObjects["Trap_" .. trap.Name] = {
                            Type = "Trap",
                            BillBoard = billboard,
                            Label = label,
                            Highlight = highlight
                        }
                    end
                end
            end
        end
    end)
end

-- ====== AUTO PLAY SYSTEM ======
local autoState = "idle" -- idle, hide, run, collect
local targetItem = nil
local targetCoin = nil
local nearestChaser = nil
local hidePosition = nil

local function findNearestChaser()
    local nearest = nil
    local minDist = math.huge
    
    for player, data in pairs(espObjects) do
        if data.IsChaser and data.Head then
            local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
            if localHead then
                local dist = (localHead.Position - data.Head.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = {Player = player, Distance = dist, Head = data.Head}
                end
            end
        end
    end
    
    return nearest, minDist
end

local function findNearestItem()
    local nearest = nil
    local minDist = math.huge
    
    for obj, data in pairs(espObjects) do
        if data.Type == "Item" and data.BillBoard and data.BillBoard.Adornee then
            local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
            if localHead then
                local pos = data.BillBoard.Adornee.Position
                local dist = (localHead.Position - pos).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = {Object = obj, Distance = dist, Position = pos}
                end
            end
        end
    end
    
    return nearest, minDist
end

local function findNearestCoin()
    local nearest = nil
    local minDist = math.huge
    
    for obj, data in pairs(espObjects) do
        if data.Type == "Coin" and data.BillBoard and data.BillBoard.Adornee then
            local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
            if localHead then
                local pos = data.BillBoard.Adornee.Position
                local dist = (localHead.Position - pos).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = {Object = obj, Distance = dist, Position = pos}
                end
            end
        end
    end
    
    return nearest, minDist
end

local function findHidePosition()
    -- Tìm vị trí trốn (xung quanh bản đồ, tránh xa chaser)
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil end
    
    local bestPos = nil
    local bestScore = -math.huge
    
    -- Thử các vị trí ngẫu nhiên xung quanh
    for i = 1, 20 do
        local angle = math.random() * 2 * math.pi
        local dist = 30 + math.random() * 20
        local pos = localHead.Position + Vector3.new(math.cos(angle) * dist, 0, math.sin(angle) * dist)
        
        -- Kiểm tra xem có gần chaser không
        local isSafe = true
        for player, data in pairs(espObjects) do
            if data.IsChaser and data.Head then
                if (pos - data.Head.Position).Magnitude < 20 then
                    isSafe = false
                    break
                end
            end
        end
        
        if isSafe then
            return pos
        end
    end
    
    return nil
end

-- Auto Play loop
RunService.RenderStepped:Connect(function()
    if not Config.AutoPlay or not Config.Enabled then
        statusLabel.Text = translate("auto_status") .. " " .. translate("auto_idle")
        return
    end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    -- Tìm chaser gần nhất
    local chaser, chaserDist = findNearestChaser()
    
    -- Tìm item và coin
    local item, itemDist = findNearestItem()
    local coin, coinDist = findNearestCoin()
    
    -- Quyết định hành động
    if chaser and chaserDist < 50 then
        -- Chaser gần -> chạy trốn
        autoState = "run"
        statusLabel.Text = translate("auto_status") .. " " .. translate("auto_run")
        
        -- Chạy theo hướng ngược lại
        local dir = (rootPart.Position - chaser.Head.Position).Unit
        local runPos = rootPart.Position + dir * 30
        humanoid:MoveTo(runPos)
        
    elseif chaser and chaserDist < 80 then
        -- Chaser ở xa vừa -> tìm chỗ trốn
        autoState = "hide"
        statusLabel.Text = translate("auto_status") .. " " .. translate("auto_hide")
        
        local hidePos = findHidePosition()
        if hidePos then
            humanoid:MoveTo(hidePos)
        else
            -- Nếu không tìm thấy chỗ trốn, chạy ngẫu nhiên
            local randPos = rootPart.Position + Vector3.new(math.random(-30, 30), 0, math.random(-30, 30))
            humanoid:MoveTo(randPos)
        end
        
    else
        -- Không có chaser gần -> thu thập item và coin
        if item and itemDist < 30 then
            autoState = "collect"
            statusLabel.Text = translate("auto_status") .. " " .. translate("auto_collect")
            humanoid:MoveTo(item.Position)
        elseif coin and coinDist < 30 then
            autoState = "collect"
            statusLabel.Text = translate("auto_status") .. " " .. translate("auto_collect")
            humanoid:MoveTo(coin.Position)
        else
            -- Di chuyển ngẫu nhiên để tìm vật phẩm
            autoState = "idle"
            statusLabel.Text = translate("auto_status") .. " " .. translate("auto_idle")
            
            if math.random(1, 100) == 1 then
                local randPos = rootPart.Position + Vector3.new(math.random(-50, 50), 0, math.random(-50, 50))
                humanoid:MoveTo(randPos)
            end
        end
    end
end)

-- ====== KHỞI TẠO ======
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        setupPlayerESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    setupPlayerESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        if espObjects[player].BillBoard then espObjects[player].BillBoard:Destroy() end
        espObjects[player] = nil
    end
    if espConnections[player] then
        espConnections[player]:Disconnect()
        espConnections[player] = nil
    end
end)

setupItemESP()
setupCoinESP()
setupTrapESP()

-- ====== PHÍM TẮT ======
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        Config.Enabled = not Config.Enabled
        espBtn.Text = Config.Enabled and translate("toggle_esp") or "🟢 " .. translate("toggle_esp"):gsub("🔴", "🟢")
        espBtn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
    end
    
    if input.KeyCode == Enum.KeyCode.F2 then
        Config.AutoPlay = not Config.AutoPlay
        autoBtn.Text = Config.AutoPlay and translate("toggle_auto"):gsub("🤖", "🟢") or "🤖 " .. translate("toggle_auto")
        autoBtn.BackgroundColor3 = Config.AutoPlay and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(50, 100, 200)
    end
    
    if input.KeyCode == Enum.KeyCode.F3 then
        SettingsPopup.Visible = not SettingsPopup.Visible
    end
end)

-- ====== THÔNG BÁO ======
print("╔════════════════════════════════════════════════════════════╗")
print("║  👁️ SPECTER EVADE ULTIMATE - Đã tải thành công!         ║")
print("║  F1: Bật/Tắt ESP    F2: Bật/Tắt Auto Play              ║")
print("║  F3: Mở Settings    Hỗ trợ Mobile & PC                 ║")
print("║  Tác giả: Cộng đồng phát triển (Specter)              ║")
print("╚════════════════════════════════════════════════════════════╝")

game.StarterGui:SetCore("SendNotification", {
    Title = "👁️ SPECTER EVADE ULTIMATE",
    Text = "Đã tải thành công! F1: ESP | F2: Auto | F3: Settings",
    Duration = 4
})
