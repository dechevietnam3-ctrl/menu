--[[
    ╔════════════════════════════════════════════════════════════════════════════╗
    ║  👁️ SPECTER EVADE ULTIMATE V4.0                                         ║
    ║  Tác giả: Cộng đồng phát triển (Specter)                                ║
    ║  Tính năng: ESP, Auto Play, Speed, Fly, Noclip, Teleport, Anti-Crash   ║
    ║  Hỗ trợ: Mobile & PC - Tối ưu hóa                                      ║
    ║  Version: 4.0                                                           ║
    ╚════════════════════════════════════════════════════════════════════════════╝
--]]

-- ====== ANTI-CRASH & TỐI ƯU ======
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ====== KIỂM TRA NHANH ======
if not game:IsLoaded() then game.Loaded:Wait() end

-- ====== SETTINGS ======
local Settings = {
    Language = "Tiếng Việt",
    ESP = {
        Enabled = true,
        Players = true,
        Chasers = true,
        Items = true,
        Coins = true,
        Traps = true,
        Distance = true,
        Names = true,
        Health = true,
        Chams = false,
        Glow = false,
    },
    AutoPlay = {
        Enabled = false,
        AutoCollect = true,
        AutoEscape = true,
        AutoHide = true,
        AutoRunAway = true,
        AutoRevive = true,
        AutoDance = false,
    },
    Player = {
        Speed = 16,
        WalkSpeed = 16,
        JumpPower = 50,
        Fly = false,
        Noclip = false,
        InfiniteJump = false,
        AntiFall = true,
        AutoHeal = false,
    },
    Visual = {
        FullBright = false,
        FogOff = false,
        NoGravity = false,
    },
    Misc = {
        AntiKick = false,
        AntiCrash = true,
        NoStun = false,
        AutoRejoin = false,
    }
}

-- ====== NGÔN NGỮ ======
local Languages = {
    ["Tiếng Việt"] = {
        title = "👁️ SPECTER V4",
        esp = "👁️ ESP",
        esp_players = "👥 Người chơi",
        esp_chasers = "👹 Chaser",
        esp_items = "📦 Vật phẩm",
        esp_coins = "🪙 Xu",
        esp_traps = "⚠️ Bẫy",
        esp_distance = "📏 Khoảng cách",
        esp_names = "🏷️ Tên",
        esp_health = "❤️ Máu",
        auto = "🤖 Auto Play",
        auto_collect = "📦 Nhặt vật phẩm",
        auto_escape = "🏃 Chạy trốn",
        auto_hide = "🚪 Trốn",
        auto_revive = "💀 Hồi sinh",
        player = "👤 Người chơi",
        speed = "⚡ Tốc độ",
        jump = "🦘 Bật nhảy",
        fly = "✈️ Bay",
        noclip = "🌀 Xuyên tường",
        teleport = "🌀 Dich chuyển",
        visual = "🎨 Giao diện",
        fullbright = "☀️ Sáng",
        fogoff = "🌫️ Xóa sương mù",
        misc = "⚙️ Khác",
        antikick = "🛡️ Chống kick",
        norejoin = "🔄 Không reconnect",
        toggle_on = "BẬT",
        toggle_off = "TẮT",
        status_auto = "🤖 Auto Play:",
        status_idle = "Đợi tìm chaser...",
        status_hide = "Đang trốn...",
        status_run = "Đang chạy...",
        status_collect = "Đang nhặt vật phẩm...",
        status_escape = "Chạy khỏi chaser!",
        status_revive = "Đang hồi sinh...",
        notif_title = "✅ Specter Evade V4",
        notif_body = "Đã tải thành công! F1 Menu",
    },
    ["English"] = {
        title = "👁️ SPECTER V4",
        esp = "👁️ ESP",
        esp_players = "👥 Players",
        esp_chasers = "👹 Chaser",
        esp_items = "📦 Items",
        esp_coins = "🪙 Coins",
        esp_traps = "⚠️ Traps",
        esp_distance = "📏 Distance",
        esp_names = "🏷️ Names",
        esp_health = "❤️ Health",
        auto = "🤖 Auto Play",
        auto_collect = "📦 Collect items",
        auto_escape = "🏃 Escape",
        auto_hide = "🚪 Hide",
        auto_revive = "💀 Revive",
        player = "👤 Player",
        speed = "⚡ Speed",
        jump = "🦘 Jump",
        fly = "✈️ Fly",
        noclip = "🌀 Noclip",
        teleport = "🌀 Teleport",
        visual = "🎨 Visual",
        fullbright = "☀️ Bright",
        fogoff = "🌫️ Fog off",
        misc = "⚙️ Misc",
        antikick = "🛡️ Anti-kick",
        norejoin = "🔄 No rejoin",
        toggle_on = "ON",
        toggle_off = "OFF",
        status_auto = "🤖 Auto Play:",
        status_idle = "Waiting for chaser...",
        status_hide = "Hiding...",
        status_run = "Running...",
        status_collect = "Collecting items...",
        status_escape = "Escaping chaser!",
        status_revive = "Reviving...",
        notif_title = "✅ Specter Evade V4",
        notif_body = "Loaded! F1 Menu",
    }
}

local L = Languages[Settings.Language]
local function getText(key) return Languages[Settings.Language][key] or key end

-- ====== TẠO UI ======
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "SpecterV4"

local isMobile = UserInputService.TouchEnabled

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = isMobile and UDim2.new(0.92, 0, 0, 500) or UDim2.new(0, 320, 0, 480)
MainFrame.Position = isMobile and UDim2.new(0.04, 0, 0.05, 0) or UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

local Corner = Instance.new("UICorner")
Corner.Parent = MainFrame
Corner.CornerRadius = UDim.new(0, 16)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(150, 50, 255)
Stroke.Thickness = 2
Stroke.Transparency = 0.2

-- Header
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
Header.BackgroundTransparency = 0.15
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 16)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "👁️ SPECTER V4"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = isMobile and 22 or 20
TitleLabel.Font = Enum.Font.GothamBold

-- Nút đóng
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255,100,100)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 5)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local tabs = {}
local currentTab = nil

local function createTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Parent = TabContainer
    btn.Size = UDim2.new(0, 60, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    btn.Text = icon
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    -- Tooltip
    local tooltip = Instance.new("TextLabel")
    tooltip.Parent = btn
    tooltip.Size = UDim2.new(1, 0, 0, 15)
    tooltip.Position = UDim2.new(0, 0, 1, 2)
    tooltip.BackgroundTransparency = 1
    tooltip.Text = name
    tooltip.TextColor3 = Color3.fromRGB(150, 150, 200)
    tooltip.TextSize = 8
    tooltip.Font = Enum.Font.Gotham
    
    return btn
end

-- Nội dung tab
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Parent = MainFrame
ContentContainer.Size = UDim2.new(1, 0, 1, -100)
ContentContainer.Position = UDim2.new(0, 0, 0, 92)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.ScrollBarThickness = 3
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentContainer
ContentLayout.Padding = UDim.new(0, 4)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ====== HÀM TẠO UI ======
local function createToggle(parent, text, getter, setter, order)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.96, 0, 0, 32)
    frame.Position = UDim2.new(0.02, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order or 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 230)
    label.TextSize = isMobile and 15 or 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0.35, 0, 0.8, 0)
    btn.Position = UDim2.new(0.65, 0, 0.1, 0)
    btn.BackgroundColor3 = getter() and Color3.fromRGB(80, 220, 100) or Color3.fromRGB(220, 80, 80)
    btn.Text = getter() and getText("toggle_on") or getText("toggle_off")
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
        btn.BackgroundColor3 = newVal and Color3.fromRGB(80, 220, 100) or Color3.fromRGB(220, 80, 80)
        btn.Text = newVal and getText("toggle_on") or getText("toggle_off")
    end)
    
    return frame
end

local function createSlider(parent, text, min, max, getter, setter, order)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.96, 0, 0, 40)
    frame.Position = UDim2.new(0.02, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order or 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 230)
    label.TextSize = isMobile and 15 or 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.Size = UDim2.new(0.35, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.65, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(getter())
    valueLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    valueLabel.TextSize = isMobile and 15 or 13
    valueLabel.Font = Enum.Font.GothamBold
    
    -- Slider bar (chỉ PC)
    if not isMobile then
        local bar = Instance.new("Frame")
        bar.Parent = frame
        bar.Size = UDim2.new(0.6, 0, 0.2, 0)
        bar.Position = UDim2.new(0.02, 0, 0.7, 0)
        bar.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        bar.BorderSizePixel = 0
        
        local fill = Instance.new("Frame")
        fill.Parent = bar
        fill.Size = UDim2.new((getter() - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
        fill.BorderSizePixel = 0
        
        local drag = Instance.new("TextButton")
        drag.Parent = bar
        drag.Size = UDim2.new(0, 12, 1.5, 0)
        drag.Position = UDim2.new((getter() - min) / (max - min), -6, -0.25, 0)
        drag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        drag.Text = ""
        drag.BorderSizePixel = 0
        
        local dragCorner = Instance.new("UICorner")
        dragCorner.Parent = drag
        dragCorner.CornerRadius = UDim.new(1, 0)
        
        local dragging = false
        drag.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        drag.MouseButton1Up:Connect(function()
            dragging = false
        end)
        
        drag.MouseLeave:Connect(function()
            dragging = false
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = input.Position.X - bar.AbsolutePosition.X
                local percent = math.clamp(pos / bar.AbsoluteSize.X, 0, 1)
                local val = math.round(min + (max - min) * percent)
                setter(val)
                valueLabel.Text = tostring(val)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                drag.Position = UDim2.new(percent, -6, -0.25, 0)
            end
        end)
    end
    
    return frame
end

-- ====== TẠO TAB ======
local tabNames = {
    {name = "ESP", icon = "👁️"},
    {name = "Auto", icon = "🤖"},
    {name = "Player", icon = "👤"},
    {name = "Visual", icon = "🎨"},
    {name = "Misc", icon = "⚙️"},
}

local tabContents = {}

for _, tabInfo in ipairs(tabNames) do
    local btn = createTab(tabInfo.name, tabInfo.icon)
    tabContents[tabInfo.name] = {}
    
    btn.MouseButton1Click:Connect(function()
        ContentContainer:ClearAllChildren()
        ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        for _, child in pairs(tabContents[tabInfo.name]) do
            child.Parent = ContentContainer
        end
        
        local count = #tabContents[tabInfo.name]
        ContentContainer.CanvasSize = UDim2.new(0, 0, 0, count * 40 + 20)
    end)
    
    tabs[tabInfo.name] = btn
end

-- ====== NỘI DUNG TAB ======
local yOrder = 0

-- TAB ESP
yOrder = 0
local espContent = {}

espContent[yOrder+1] = createToggle(ContentContainer, getText("esp"), 
    function() return Settings.ESP.Enabled end,
    function(v) Settings.ESP.Enabled = v end, yOrder)
yOrder = yOrder + 1

espContent[yOrder+1] = createToggle(ContentContainer, getText("esp_players"),
    function() return Settings.ESP.Players end,
    function(v) Settings.ESP.Players = v end, yOrder)
yOrder = yOrder + 1

espContent[yOrder+1] = createToggle(ContentContainer, getText("esp_chasers"),
    function() return Settings.ESP.Chasers end,
    function(v) Settings.ESP.Chasers = v end, yOrder)
yOrder = yOrder + 1

espContent[yOrder+1] = createToggle(ContentContainer, getText("esp_items"),
    function() return Settings.ESP.Items end,
    function(v) Settings.ESP.Items = v end, yOrder)
yOrder = yOrder + 1

espContent[yOrder+1] = createToggle(ContentContainer, getText("esp_coins"),
    function() return Settings.ESP.Coins end,
    function(v) Settings.ESP.Coins = v end, yOrder)
yOrder = yOrder + 1

espContent[yOrder+1] = createToggle(ContentContainer, getText("esp_traps"),
    function() return Settings.ESP.Traps end,
    function(v) Settings.ESP.Traps = v end, yOrder)
yOrder = yOrder + 1

espContent[yOrder+1] = createToggle(ContentContainer, getText("esp_distance"),
    function() return Settings.ESP.Distance end,
    function(v) Settings.ESP.Distance = v end, yOrder)
yOrder = yOrder + 1

espContent[yOrder+1] = createToggle(ContentContainer, getText("esp_names"),
    function() return Settings.ESP.Names end,
    function(v) Settings.ESP.Names = v end, yOrder)
yOrder = yOrder + 1

espContent[yOrder+1] = createToggle(ContentContainer, getText("esp_health"),
    function() return Settings.ESP.Health end,
    function(v) Settings.ESP.Health = v end, yOrder)

tabContents["ESP"] = espContent

-- TAB AUTO
yOrder = 0
local autoContent = {}

autoContent[yOrder+1] = createToggle(ContentContainer, getText("auto"),
    function() return Settings.AutoPlay.Enabled end,
    function(v) 
        Settings.AutoPlay.Enabled = v
        if v then
            game.StarterGui:SetCore("SendNotification", {
                Title = "🤖 Auto Play",
                Text = "Đã bật chế độ tự động!",
                Duration = 2
            })
        end
    end, yOrder)
yOrder = yOrder + 1

autoContent[yOrder+1] = createToggle(ContentContainer, getText("auto_collect"),
    function() return Settings.AutoPlay.AutoCollect end,
    function(v) Settings.AutoPlay.AutoCollect = v end, yOrder)
yOrder = yOrder + 1

autoContent[yOrder+1] = createToggle(ContentContainer, getText("auto_escape"),
    function() return Settings.AutoPlay.AutoEscape end,
    function(v) Settings.AutoPlay.AutoEscape = v end, yOrder)
yOrder = yOrder + 1

autoContent[yOrder+1] = createToggle(ContentContainer, getText("auto_hide"),
    function() return Settings.AutoPlay.AutoHide end,
    function(v) Settings.AutoPlay.AutoHide = v end, yOrder)
yOrder = yOrder + 1

autoContent[yOrder+1] = createToggle(ContentContainer, getText("auto_revive"),
    function() return Settings.AutoPlay.AutoRevive end,
    function(v) Settings.AutoPlay.AutoRevive = v end, yOrder)

tabContents["Auto"] = autoContent

-- TAB PLAYER
yOrder = 0
local playerContent = {}

playerContent[yOrder+1] = createSlider(ContentContainer, getText("speed"), 16, 100,
    function() return Settings.Player.Speed end,
    function(v) 
        Settings.Player.Speed = v
        Settings.Player.WalkSpeed = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end, yOrder)
yOrder = yOrder + 1

playerContent[yOrder+1] = createSlider(ContentContainer, getText("jump"), 50, 200,
    function() return Settings.Player.JumpPower end,
    function(v) 
        Settings.Player.JumpPower = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = v
        end
    end, yOrder)
yOrder = yOrder + 1

playerContent[yOrder+1] = createToggle(ContentContainer, getText("fly"),
    function() return Settings.Player.Fly end,
    function(v) 
        Settings.Player.Fly = v
        if v then
            -- Enable fly
            local char = LocalPlayer.Character
            if char then
                local bp = char:FindFirstChild("BodyVelocity")
                if not bp then
                    bp = Instance.new("BodyVelocity")
                    bp.MaxForce = Vector3.new(1e4, 1e4, 1e4)
                    bp.Parent = char:FindFirstChild("HumanoidRootPart")
                end
                bp.Velocity = Vector3.new(0, 10, 0)
            end
        end
    end, yOrder)
yOrder = yOrder + 1

playerContent[yOrder+1] = createToggle(ContentContainer, getText("noclip"),
    function() return Settings.Player.Noclip end,
    function(v) Settings.Player.Noclip = v end, yOrder)

tabContents["Player"] = playerContent

-- TAB VISUAL
yOrder = 0
local visualContent = {}

visualContent[yOrder+1] = createToggle(ContentContainer, getText("fullbright"),
    function() return Settings.Visual.FullBright end,
    function(v) 
        Settings.Visual.FullBright = v
        if v then
            Lighting.Brightness = 10
            Lighting.Ambient = Color3.fromRGB(255,255,255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(127,127,127)
            Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
            Lighting.GlobalShadows = true
        end
    end, yOrder)
yOrder = yOrder + 1

visualContent[yOrder+1] = createToggle(ContentContainer, getText("fogoff"),
    function() return Settings.Visual.FogOff end,
    function(v) 
        Settings.Visual.FogOff = v
        if v then
            Lighting.FogEnd = 999999
            Lighting.FogStart = 999998
        else
            Lighting.FogEnd = 100
            Lighting.FogStart = 0
        end
    end, yOrder)

tabContents["Visual"] = visualContent

-- TAB MISC
yOrder = 0
local miscContent = {}

miscContent[yOrder+1] = createToggle(ContentContainer, getText("antikick"),
    function() return Settings.Misc.AntiKick end,
    function(v) Settings.Misc.AntiKick = v end, yOrder)

tabContents["Misc"] = miscContent

-- Active tab mặc định
for _, child in pairs(tabContents["ESP"]) do
    child.Parent = ContentContainer
end
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, #tabContents["ESP"] * 40 + 20)
tabs["ESP"].BackgroundColor3 = Color3.fromRGB(150, 50, 255)

-- ====== NÚT MENU ======
local MenuBtn = Instance.new("TextButton")
MenuBtn.Parent = ScreenGui
MenuBtn.Size = UDim2.new(0, 50, 0, 50)
MenuBtn.Position = isMobile and UDim2.new(0.85, 0, 0.85, 0) or UDim2.new(0.01, 0, 0.45, 0)
MenuBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
MenuBtn.BackgroundTransparency = 0.1
MenuBtn.Text = "👁️"
MenuBtn.TextColor3 = Color3.fromRGB(255,255,255)
MenuBtn.TextSize = 24
MenuBtn.Font = Enum.Font.GothamBold
MenuBtn.BorderSizePixel = 0

local MenuCorner = Instance.new("UICorner")
MenuCorner.Parent = MenuBtn
MenuCorner.CornerRadius = UDim.new(1, 0)

MenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        MenuBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        MenuBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    end
end)

-- ====== ESP SYSTEM ======
local espObjects = {}

local function createESP(character, color, text, isChaser)
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 55)
    billboard.Adornee = head
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.MaxDistance = 250
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    billboard.Enabled = Settings.ESP.Enabled
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = billboard
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = text or "Unknown"
    nameLabel.TextColor3 = color
    nameLabel.TextSize = isChaser and 20 or 14
    nameLabel.Font = isChaser and Enum.Font.GothamBold or Enum.Font.Gotham
    nameLabel.TextStrokeTransparency = 0.2
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Parent = billboard
    distLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
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

local function updateESP(data)
    if not data or not data.Head or not LocalPlayer.Character then return end
    local localHead = LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return end
    
    local dist = (localHead.Position - data.Head.Position).Magnitude
    if data.DistLabel then
        data.DistLabel.Text = string.format("%.1fm", dist)
        data.DistLabel.Visible = Settings.ESP.Distance
    end
    if data.NameLabel then
        data.NameLabel.Visible = Settings.ESP.Names
    end
end

local function isChaser(character)
    if not character then return false end
    local head = character:FindFirstChild("Head")
    if head and head.Size.Y > 2.5 then return true end
    
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

-- ====== ITEM/COIN/TRAP ESP ======
local function setupItemESP()
    RunService.Heartbeat:Connect(function()
        if not Settings.ESP.Enabled then
            for _, obj in pairs(espObjects) do
                if obj.Type == "Item" and obj.BillBoard then
                    obj.BillBoard.Enabled = false
                end
            end
            return
        end
        
        -- Items
        if Settings.ESP.Items then
            for _, item in ipairs(workspace:GetDescendants()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") and not espObjects[item] then
                    local handle = item:FindFirstChild("Handle")
                    if handle then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Size = UDim2.new(0, 120, 0, 30)
                        billboard.Adornee = handle
                        billboard.StudsOffset = Vector3.new(0, 1.5, 0)
                        billboard.MaxDistance = 120
                        billboard.AlwaysOnTop = true
                        billboard.Parent = handle
                        billboard.Enabled = Settings.ESP.Enabled
                        
                        local label = Instance.new("TextLabel")
                        label.Parent = billboard
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = "📦 " .. item.Name
                        label.TextColor3 = Color3.fromRGB(255, 200, 50)
                        label.TextSize = 13
                        label.Font = Enum.Font.GothamBold
                        label.TextStrokeTransparency = 0.2
                        label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                        
                        espObjects[item] = {Type = "Item", BillBoard = billboard}
                    end
                end
            end
        end
        
        -- Coins
        if Settings.ESP.Coins then
            for _, coin in ipairs(workspace:GetDescendants()) do
                if coin:IsA("Part") and coin.Name:lower():find("coin") and not espObjects["Coin_" .. coin.Name] then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 100, 0, 25)
                    billboard.Adornee = coin
                    billboard.StudsOffset = Vector3.new(0, 1.5, 0)
                    billboard.MaxDistance = 100
                    billboard.AlwaysOnTop = true
                    billboard.Parent = coin
                    billboard.Enabled = Settings.ESP.Enabled
                    
                    local label = Instance.new("TextLabel")
                    label.Parent = billboard
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "🪙 COIN"
                    label.TextColor3 = Color3.fromRGB(255, 215, 0)
                    label.TextSize = 14
                    label.Font = Enum.Font.GothamBold
                    label.TextStrokeTransparency = 0.2
                    label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                    
                    espObjects["Coin_" .. coin.Name] = {Type = "Coin", BillBoard = billboard}
                end
            end
        end
        
        -- Traps
        if Settings.ESP.Traps then
            for _, trap in ipairs(workspace:GetDescendants()) do
                if trap:IsA("Part") and trap.Name:lower():find("trap") and not espObjects["Trap_" .. trap.Name] then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = trap
                    highlight.FillColor = Color3.fromRGB(255, 100, 255)
                    highlight.FillTransparency = 0.4
                    highlight.OutlineColor = Color3.fromRGB(255,0,0)
                    highlight.OutlineTransparency = 0.2
                    highlight.Enabled = Settings.ESP.Enabled
                    
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 100, 0, 25)
                    billboard.Adornee = trap
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.MaxDistance = 80
                    billboard.AlwaysOnTop = true
                    billboard.Parent = trap
                    billboard.Enabled = Settings.ESP.Enabled
                    
                    local label = Instance.new("TextLabel")
                    label.Parent = billboard
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "⚠️ BẪY"
                    label.TextColor3 = Color3.fromRGB(255, 100, 255)
                    label.TextSize = 14
                    label.Font = Enum.Font.GothamBold
                    label.TextStrokeTransparency = 0.2
                    label.TextStrokeColor3 = Color3.fromRGB(255,0,0)
                    
                    espObjects["Trap_" .. trap.Name] = {Type = "Trap", BillBoard = billboard, Highlight = highlight}
                end
            end
        end
    end)
end

-- ====== AUTO PLAY ======
local autoStatus = "idle"

local function findNearest(type)
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil, math.huge end
    
    local nearest = nil
    local minDist = math.huge
    
    for obj, data in pairs(espObjects) do
        if data.Type == type and data.BillBoard and data.BillBoard.Adornee then
            local pos = data.BillBoard.Adornee.Position
            local dist = (localHead.Position - pos).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = {Object = obj, Distance = dist, Position = pos}
            end
        end
    end
    
    return nearest, minDist
end

local function findNearestChaser()
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil, math.huge end
    
    local nearest = nil
    local minDist = math.huge
    
    for _, obj in pairs(espObjects) do
        if obj.IsChaser and obj.Head then
            local dist = (localHead.Position - obj.Head.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = obj
            end
        end
    end
    
    return nearest, minDist
end

RunService.Heartbeat:Connect(function()
    if not Settings.AutoPlay.Enabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    
    local chaser, chaserDist = findNearestChaser()
    local item, itemDist = findNearest("Item")
    local coin, coinDist = findNearest("Coin")
    
    if chaser and chaserDist < 50 and Settings.AutoPlay.AutoEscape then
        autoStatus = "escape"
        local dir = (root.Position - chaser.Head.Position).Unit
        humanoid:MoveTo(root.Position + dir * 50)
        
    elseif chaser and chaserDist < 80 and Settings.AutoPlay.AutoHide then
        autoStatus = "hide"
        local randPos = root.Position + Vector3.new(math.random(-30, 30), 0, math.random(-30, 30))
        humanoid:MoveTo(randPos)
        
    elseif item and itemDist < 30 and Settings.AutoPlay.AutoCollect then
        autoStatus = "collect"
        humanoid:MoveTo(item.Position)
        
    elseif coin and coinDist < 30 and Settings.AutoPlay.AutoCollect then
        autoStatus = "collect"
        humanoid:MoveTo(coin.Position)
        
    else
        autoStatus = "idle"
        if math.random(1, 100) == 1 then
            humanoid:MoveTo(root.Position + Vector3.new(math.random(-40, 40), 0, math.random(-40, 40)))
        end
    end
end)

-- ====== NOCLIP ======
RunService.Heartbeat:Connect(function()
    if Settings.Player.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ====== FLY ======
RunService.Heartbeat:Connect(function()
    if Settings.Player.Fly and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bp = root:FindFirstChild("BodyVelocity")
            if not bp then
                bp = Instance.new("BodyVelocity")
                bp.MaxForce = Vector3.new(1e4, 1e4, 1e4)
                bp.Parent = root
            end
            
            local move = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 50, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 50, 0) end
            
            bp.Velocity = move
        end
    end
end)

-- ====== SPEED & JUMP ======
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Settings.Player.Speed
            humanoid.JumpPower = Settings.Player.JumpPower
        end
    end
end)

-- ====== PHÍM TẮT ======
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        MainFrame.Visible = not MainFrame.Visible
    end
    
    if input.KeyCode == Enum.KeyCode.F2 then
        Settings.ESP.Enabled = not Settings.ESP.Enabled
    end
    
    if input.KeyCode == Enum.KeyCode.F3 then
        Settings.AutoPlay.Enabled = not Settings.AutoPlay.Enabled
    end
end)

-- ====== KHỞI TẠO ======
setupItemESP()

-- Thông báo
print("╔════════════════════════════════════════════════════════════════╗")
print("║  👁️ SPECTER EVADE V4 - Đã tải thành công!                  ║")
print("║  F1: Menu    F2: ESP    F3: Auto Play                      ║")
print("║  Tác giả: Cộng đồng phát triển (Specter)                  ║")
print("╚════════════════════════════════════════════════════════════════╝")

game.StarterGui:SetCore("SendNotification", {
    Title = "✅ Specter Evade V4",
    Text = "Đã tải thành công! F1 để mở menu",
    Duration = 4
})

-- Nếu game khởi tạo lại, chạy lại
game:GetService("RunService").Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = Settings.Player.Speed
        humanoid.JumpPower = Settings.Player.JumpPower
    end
