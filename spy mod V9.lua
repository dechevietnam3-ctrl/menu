-- Spy Mod V9 - Phiên bản nâng cấp cao cấp
-- Tác giả: Cộng đồng phát triển
-- Tính năng: Phát hiện, lấy vật phẩm, auto farm, teleport, ESP, và nhiều hơn nữa

local SpyMod = {
    Name = "Spy Mod V9",
    Version = "9.0",
    Author = "Cộng đồng",
    Settings = {
        AutoFarm = false,
        ESPEnabled = false,
        TeleportToItems = false,
        AutoCollect = false,
        NotifyWhenFound = true,
        ShowDistance = true,
        FilterByType = "All" -- All, Coin, Gem, Key, Star, Chest, Portal, Button
    }
}

-- Tạo Service
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Hàm tạo UI nâng cao
local function CreateAdvancedUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SpyModV9"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Frame với hiệu ứng Glass
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 380, 0, 550)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -275)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(100, 200, 255)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Gradient hiệu ứng
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 50))
    })
    Gradient.Rotation = 45
    Gradient.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    TitleBar.BackgroundTransparency = 0.3
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Text = "🔍 SPY MOD V9 - OBBY PRO"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = TitleBar
    
    -- Nút Minimize
    local MinButton = Instance.new("TextButton")
    MinButton.Size = UDim2.new(0, 30, 0, 30)
    MinButton.Position = UDim2.new(1, -70, 0, 7)
    MinButton.Text = "━"
    MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinButton.TextSize = 20
    MinButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    MinButton.BorderSizePixel = 0
    MinButton.Parent = TitleBar
    MinButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
    
    -- Nút Close
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 7)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.TextSize = 20
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TitleBar
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab System
    local TabSystem = Instance.new("Frame")
    TabSystem.Size = UDim2.new(1, 0, 0, 35)
    TabSystem.Position = UDim2.new(0, 0, 0, 45)
    TabSystem.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabSystem.BorderSizePixel = 0
    TabSystem.Parent = MainFrame
    
    -- Tạo các Tab
    local Tabs = {"📋 Items", "⚙️ Settings", "🛠 Tools", "📊 Stats"}
    local TabButtons = {}
    
    for i, tabName in ipairs(Tabs) do
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.25, 0, 1, 0)
        TabBtn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.TextScaled = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        TabBtn.BorderSizePixel = 0
        TabBtn.Parent = TabSystem
        TabButtons[i] = TabBtn
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, btn in ipairs(TabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            -- Ẩn tất cả các container
            for _, child in ipairs(MainFrame:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            
            -- Hiện container tương ứng
            local container = MainFrame:FindFirstChild("Tab" .. i)
            if container then
                container.Visible = true
            end
        end)
    end
    
    -- Tab 1: Items (Mặc định active)
    local ItemsContainer = Instance.new("ScrollingFrame")
    ItemsContainer.Size = UDim2.new(1, -10, 1, -100)
    ItemsContainer.Position = UDim2.new(0, 5, 0, 85)
    ItemsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    ItemsContainer.BackgroundTransparency = 0.5
    ItemsContainer.BorderSizePixel = 1
    ItemsContainer.BorderColor3 = Color3.fromRGB(100, 150, 200)
    ItemsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ItemsContainer.ScrollBarThickness = 10
    ItemsContainer.Parent = MainFrame
    
    -- Tab 2: Settings
    local SettingsContainer = Instance.new("ScrollingFrame")
    SettingsContainer.Size = UDim2.new(1, -10, 1, -100)
    SettingsContainer.Position = UDim2.new(0, 5, 0, 85)
    SettingsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    SettingsContainer.BackgroundTransparency = 0.5
    SettingsContainer.BorderSizePixel = 1
    SettingsContainer.BorderColor3 = Color3.fromRGB(100, 150, 200)
    SettingsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    SettingsContainer.ScrollBarThickness = 10
    SettingsContainer.Visible = false
    SettingsContainer.Parent = MainFrame
    
    -- Tab 3: Tools
    local ToolsContainer = Instance.new("ScrollingFrame")
    ToolsContainer.Size = UDim2.new(1, -10, 1, -100)
    ToolsContainer.Position = UDim2.new(0, 5, 0, 85)
    ToolsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    ToolsContainer.BackgroundTransparency = 0.5
    ToolsContainer.BorderSizePixel = 1
    ToolsContainer.BorderColor3 = Color3.fromRGB(100, 150, 200)
    ToolsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ToolsContainer.ScrollBarThickness = 10
    ToolsContainer.Visible = false
    ToolsContainer.Parent = MainFrame
    
    -- Tab 4: Stats
    local StatsContainer = Instance.new("ScrollingFrame")
    StatsContainer.Size = UDim2.new(1, -10, 1, -100)
    StatsContainer.Position = UDim2.new(0, 5, 0, 85)
    StatsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    StatsContainer.BackgroundTransparency = 0.5
    StatsContainer.BorderSizePixel = 1
    StatsContainer.BorderColor3 = Color3.fromRGB(100, 150, 200)
    StatsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    StatsContainer.ScrollBarThickness = 10
    StatsContainer.Visible = false
    StatsContainer.Parent = MainFrame
    
    -- Tạo các option settings
    local function CreateSetting(parent, label, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        frame.BorderSizePixel = 0
        frame.Parent = parent
        
        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.6, 0, 1, 0)
        labelText.Text = label
        labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.TextSize = 14
        labelText.BackgroundTransparency = 1
        labelText.Parent = frame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 60, 0, 30)
        toggleBtn.Position = UDim2.new(0.7, 0, 0.5, -15)
        toggleBtn.Text = default and "ON ✅" or "OFF ❌"
        toggleBtn.TextColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
        toggleBtn.TextScaled = true
        toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Parent = frame
        
        local isOn = default
        toggleBtn.MouseButton1Click:Connect(function()
            isOn = not isOn
            toggleBtn.Text = isOn and "ON ✅" or "OFF ❌"
            toggleBtn.TextColor3 = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
            toggleBtn.BackgroundColor3 = isOn and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
            callback(isOn)
        end)
        
        return {Toggle = toggleBtn, Frame = frame}
    end
    
    -- Tạo các setting
    local yPos = 5
    local function AddSetting(parent, label, default, callback)
        local setting = CreateSetting(parent, label, default, callback)
        setting.Frame.Position = UDim2.new(0, 0, 0, yPos)
        yPos = yPos + 45
        parent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
        return setting
    end
    
    -- Settings
    AddSetting(SettingsContainer, "Auto Farm (Tự động farm)", false, function(val)
        SpyMod.Settings.AutoFarm = val
    end)
    
    AddSetting(SettingsContainer, "ESP (Hiển thị vật phẩm)", false, function(val)
        SpyMod.Settings.ESPEnabled = val
        if val then
            EnableESP()
        else
            DisableESP()
        end
    end)
    
    AddSetting(SettingsContainer, "Auto Collect (Tự động thu thập)", false, function(val)
        SpyMod.Settings.AutoCollect = val
    end)
    
    AddSetting(SettingsContainer, "Teleport to Items", true, function(val)
        SpyMod.Settings.TeleportToItems = val
    end)
    
    AddSetting(SettingsContainer, "Show Distance", true, function(val)
        SpyMod.Settings.ShowDistance = val
    end)
    
    AddSetting(SettingsContainer, "Notify When Found", true, function(val)
        SpyMod.Settings.NotifyWhenFound = val
    end)
    
    -- Tools
    local function AddTool(parent, label, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, yPos)
        btn.Text = label
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.BackgroundColor3 = color or Color3.fromRGB(0, 150, 200)
        btn.BorderSizePixel = 0
        btn.Parent = parent
        btn.MouseButton1Click:Connect(callback)
        yPos = yPos + 45
        parent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
        return btn
    end
    
    yPos = 5
    AddTool(ToolsContainer, "🌀 Teleport to Nearest Item", Color3.fromRGB(0, 200, 100), function()
        TeleportToNearestItem()
    end)
    
    AddTool(ToolsContainer, "⚡ Speed Boost (x2)", Color3.fromRGB(255, 150, 0), function()
        if Humanoid then
            local oldSpeed = Humanoid.WalkSpeed
            Humanoid.WalkSpeed = oldSpeed * 2
            Notify("Speed Boost", "Tốc độ đã tăng gấp đôi!", 2)
            task.wait(10)
            Humanoid.WalkSpeed = oldSpeed
            Notify("Speed Boost", "Đã trở lại tốc độ bình thường", 2)
        end
    end)
    
    AddTool(ToolsContainer, "🪂 Jump Boost (x2)", Color3.fromRGB(150, 0, 255), function()
        if Humanoid then
            local oldJump = Humanoid.JumpPower
            Humanoid.JumpPower = oldJump * 2
            Notify("Jump Boost", "Sức bật đã tăng gấp đôi!", 2)
            task.wait(10)
            Humanoid.JumpPower = oldJump
            Notify("Jump Boost", "Đã trở lại bình thường", 2)
        end
    end)
    
    AddTool(ToolsContainer, "🛡️ Noclip (Đi xuyên tường)", Color3.fromRGB(0, 100, 255), function()
        local noclip = not getgenv().Noclip
        getgenv().Noclip = noclip
        if noclip then
            Notify("Noclip", "Đã bật noclip!", 2)
            game:GetService("RunService").Stepped:Connect(function()
                if getgenv().Noclip then
                    for _, part in ipairs(Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            Notify("Noclip", "Đã tắt noclip!", 2)
            for _, part in ipairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
    
    AddTool(ToolsContainer, "🔦 Highlight All Items", Color3.fromRGB(255, 200, 0), function()
        HighlightAllItems()
    end)
    
    yPos = 5
    -- Stats
    local StatsLabel = Instance.new("TextLabel")
    StatsLabel.Size = UDim2.new(1, -10, 0, 30)
    StatsLabel.Position = UDim2.new(0, 5, 0, yPos)
    StatsLabel.Text = "📊 Thống kê vật phẩm"
    StatsLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    StatsLabel.TextScaled = true
    StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatsLabel.BackgroundTransparency = 1
    StatsLabel.Parent = StatsContainer
    yPos = yPos + 40
    
    local StatsText = Instance.new("TextLabel")
    StatsText.Size = UDim2.new(1, -10, 0, 100)
    StatsText.Position = UDim2.new(0, 5, 0, yPos)
    StatsText.Text = "Đang cập nhật..."
    StatsText.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatsText.TextScaled = true
    StatsText.TextXAlignment = Enum.TextXAlignment.Left
    StatsText.BackgroundTransparency = 1
    StatsText.Parent = StatsContainer
    StatsContainer.CanvasSize = UDim2.new(0, 0, 0, yPos + 120)
    
    -- Cập nhật stats mỗi 5 giây
    game:GetService("RunService").Heartbeat:Connect(function()
        if StatsContainer.Visible then
            local total = #DetectedItems
            local types = {}
            for _, item in ipairs(DetectedItems) do
                local type = item.Type or "Unknown"
                types[type] = (types[type] or 0) + 1
            end
            
            local text = "Tổng số vật phẩm: " .. total .. "\n"
            for type, count in pairs(types) do
                text = text .. "▪ " .. type .. ": " .. count .. "\n"
            end
            text = text .. "\n📍 Vị trí: " .. tostring(RootPart.Position)
            StatsText.Text = text
        end
    end)
    
    -- Active tab đầu tiên
    TabButtons[1].BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
    
    return {
        MainFrame = MainFrame,
        ScreenGui = ScreenGui,
        ItemsContainer = ItemsContainer,
        DetectedItems = {}
    }
end

-- Hàm ESP
local ESPObjects = {}
local function EnableESP()
    DisableESP()
    for _, item in ipairs(DetectedItems) do
        if item.Instance and item.Instance:IsA("BasePart") then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = item.Instance
            highlight.FillColor = item.Color or Color3.fromRGB(255, 215, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = item.Instance
            table.insert(ESPObjects, highlight)
        end
    end
end

local function DisableESP()
    for _, obj in ipairs(ESPObjects) do
        obj:Destroy()
    end
    ESPObjects = {}
end

-- Hàm Teleport
local function TeleportToNearestItem()
    local nearest = nil
    local minDist = math.huge
    
    for _, item in ipairs(DetectedItems) do
        if item.Instance and item.Instance:IsA("BasePart") then
            local dist = (RootPart.Position - item.Instance.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = item
            end
        end
    end
    
    if nearest then
        RootPart.CFrame = CFrame.new(nearest.Instance.Position + Vector3.new(0, 3, 0))
        Notify("Teleport", "Đã dịch chuyển đến " .. nearest.Name, 2)
    else
        Notify("Teleport", "Không tìm thấy vật phẩm nào!", 2)
    end
end

-- Hàm Highlight
local function HighlightAllItems()
    for _, item in ipairs(DetectedItems) do
        if item.Instance and item.Instance:IsA("BasePart") then
            -- Tạo glow effect
            local highlight = Instance.new("Highlight")
            highlight.Adornee = item.Instance
            highlight.FillColor = Color3.fromRGB(255, 255, 0)
            highlight.FillTransparency = 0.3
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineTransparency = 0
            highlight.Parent = item.Instance
            
            -- Tự động xóa sau 5 giây
            game:GetService("Debris"):AddItem(highlight, 5)
        end
    end
    Notify("Highlight", "Đã highlight tất cả vật phẩm!", 2)
end

-- Hàm Notify
local function Notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- Hàm phát hiện vật phẩm nâng cao
local DetectedItems = {}
local function AdvancedDetectItems(container, depth)
    depth = depth or 0
    if depth > 5 then return end -- Giới hạn độ sâu
    
    for _, obj in ipairs(container:GetChildren()) do
        local itemFound = false
        local itemName = ""
        local itemColor = Color3.fromRGB(255, 215, 0)
        local itemType = "Unknown"
        
        -- Danh sách từ khóa phát hiện
        local keywords = {
            coin = {name = "🪙 Coin", color = Color3.fromRGB(255, 215, 0), type = "Coin"},
            xu = {name = "🪙 Xu", color = Color3.fromRGB(255, 215, 0), type = "Coin"},
            gem = {name = "💎 Gem", color = Color3.fromRGB(0, 255, 255), type = "Gem"},
            ngoc = {name = "💎 Ngọc", color = Color3.fromRGB(0, 255, 255), type = "Gem"},
            key = {name = "🔑 Key", color = Color3.fromRGB(255, 200, 0), type = "Key"},
            khoa = {name = "🔑 Chìa khóa", color = Color3.fromRGB(255, 200, 0), type = "Key"},
            star = {name = "⭐ Star", color = Color3.fromRGB(255, 255, 0), type = "Star"},
            sao = {name = "⭐ Sao", color = Color3.fromRGB(255, 255, 0), type = "Star"},
            chest = {name = "📦 Chest", color = Color3.fromRGB(200, 150, 50), type = "Chest"},
            ruong = {name = "📦 Rương", color = Color3.fromRGB(200, 150, 50), type = "Chest"},
            portal = {name = "🌀 Portal", color = Color3.fromRGB(150, 0, 255), type = "Portal"},
            cong = {name = "🌀 Cổng", color = Color3.fromRGB(150, 0, 255), type = "Portal"},
            button = {name = "🔘 Button", color = Color3.fromRGB(255, 100, 100), type = "Button"},
            nut = {name = "🔘 Nút", color = Color3.fromRGB(255, 100, 100), type = "Button"},
            diamond = {name = "💎 Diamond", color = Color3.fromRGB(0, 200, 255), type = "Diamond"},
            kimcuong = {name = "💎 Kim cương", color = Color3.fromRGB(0, 200, 255), type = "Diamond"},
            apple = {name = "🍎 Apple", color = Color3.fromRGB(255, 50, 50), type = "Apple"},
            tao = {name = "🍎 Táo", color = Color3.fromRGB(255, 50, 50), type = "Apple"}
        }
        
        -- Kiểm tra tên
        local lowerName = obj.Name:lower()
        for keyword, data in pairs(keywords) do
            if lowerName:find(keyword) then
                itemFound = true
                itemName = data.name .. " " .. obj.Name
                itemColor = data.color
                itemType = data.type
                break
            end
        end
        
        -- Kiểm tra màu sắc
        if not itemFound and obj:IsA("BasePart") and obj.BrickColor then
            local color = obj.BrickColor
            if color == BrickColor.new("Bright yellow") or color == BrickColor.new("Gold") or 
               color == BrickColor.new("New Yeller") or color == BrickColor.new("Toothpaste") then
                itemFound = true
                itemName = "💛 " .. obj.Name
                itemColor = Color3.fromRGB(255, 215, 0)
                itemType = "Gold"
            elseif color == BrickColor.new("Bright blue") or color == BrickColor.new("Cyan") or
                   color == BrickColor.new("Really blue") then
                itemFound = true
                itemName = "💙 " .. obj.Name
                itemColor = Color3.fromRGB(0, 150, 255)
                itemType = "Blue"
            elseif color == BrickColor.new("Bright red") or color == BrickColor.new("Really red") then
                itemFound = true
                itemName = "❤️ " .. obj.Name
                itemColor = Color3.fromRGB(255, 50, 50)
                itemType = "Red"
            elseif color == BrickColor.new("Bright green") or color == BrickColor.new("Really green") then
                itemFound = true
                itemName = "💚 " .. obj.Name
                itemColor = Color3.fromRGB(0, 255, 0)
                itemType = "Green"
            elseif color == BrickColor.new("Bright violet") or color == BrickColor.new("Really purple") then
                itemFound = true
                itemName = "💜 " .. obj.Name
                itemColor = Color3.fromRGB(200, 50, 255)
                itemType = "Purple"
            end
        end
        
        -- Kiểm tra thuộc tính Value
        if not itemFound and obj:IsA("IntValue") and obj.Value > 0 then
            itemFound = true
            itemName = "💎 " .. obj.Name .. " (" .. obj.Value .. ")"
            itemColor = Color3.fromRGB(0, 255, 0)
            itemType = "Value"
        end
        
        if itemFound then
            local itemData = {
                Name = obj.Name,
                Instance = obj,
                Color = itemColor,
                Type = itemType,
                Position = obj:IsA("BasePart") and obj.Position or nil,
                DisplayName = itemName
            }
            table.insert(DetectedItems, itemData)
        end
        
        -- Đệ quy tìm kiếm
        if obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("Part") or obj:IsA("Tool") then
            AdvancedDetectItems(obj, depth + 1)
        end
    end
end

-- Hàm scan chính
local function ScanItems()
    DetectedItems = {}
    AdvancedDetectItems(workspace)
    return DetectedItems
end

-- Hàm cập nhật UI
local function UpdateUI(container, items)
    -- Xóa các item cũ
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    if #items == 0 then
        local noItem = Instance.new("TextLabel")
        noItem.Size = UDim2.new(1, 0, 1, 0)
        noItem.Text = "❌ Không tìm thấy vật phẩm nào!\n\n🔄 Đang quét tự động..."
        noItem.TextColor3 = Color3.fromRGB(200, 200, 200)
        noItem.TextScaled = true
        noItem.BackgroundTransparency = 1
        noItem.Parent = container
        return
    end
    
    local yPos = 0
    for _, item in ipairs(items) do
        -- Tạo button cho mỗi item
        local itemBtn = Instance.new("TextButton")
        itemBtn.Size = UDim2.new(1, -10, 0, 40)
        itemBtn.Position = UDim2.new(0, 5, 0, yPos)
        itemBtn.Text = item.DisplayName or item.Name
        itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemBtn.TextXAlignment = Enum.TextXAlignment.Left
        itemBtn.TextSize = 14
        itemBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        itemBtn.BorderSizePixel = 2
        itemBtn.BorderColor3 = item.Color or Color3.fromRGB(255, 215, 0)
        itemBtn.Parent = container
        
        -- Hiển thị khoảng cách
        if SpyMod.Settings.ShowDistance and item.Instance and item.Instance:IsA("BasePart") then
            local dist = (RootPart.Position - item.Instance.Position).Magnitude
            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(0, 60, 1, 0)
            distLabel.Position = UDim2.new(1, -70, 0, 0)
            distLabel.Text = string.format("%.1fm", dist)
            distLabel.TextColor3 = dist < 10 and Color3.fromRGB(0, 255, 0) or 
                                   dist < 30 and Color3.fromRGB(255, 255, 0) or 
                                   Color3.fromRGB(255, 50, 50)
            distLabel.TextScaled = true
            distLabel.BackgroundTransparency = 1
            distLabel.Parent = itemBtn
        end
        
        itemBtn.MouseButton1Click:Connect(function()
            if item.Instance and item.Instance:IsA("BasePart") and SpyMod.Settings.TeleportToItems then
                RootPart.CFrame = CFrame.new(item.Instance.Position + Vector3.new(0, 3, 0))
                Notify("Teleport", "Đã dịch chuyển đến " .. item.Name, 2)
            elseif item.Instance then
                Notify("Info", "Vật phẩm: " .. item.Name, 2)
            end
        end)
        
        yPos = yPos + 45
    end
    
    container.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
end

-- Auto Farm
local function AutoFarm()
    if not SpyMod.Settings.AutoFarm then return end
    
    for _, item in ipairs(DetectedItems) do
        if item.Instance and item.Instance:IsA("BasePart") then
            local dist = (RootPart.Position - item.Instance.Position).Magnitude
            if dist < 50 then -- Chỉ farm trong phạm vi 50 studs
                -- Di chuyển đến vật phẩm
                RootPart.CFrame = CFrame.new(item.Instance.Position + Vector3.new(0, 3, 0))
                task.wait(0.5)
                
                if SpyMod.Settings.AutoCollect then
                    -- Thu thập vật phẩm (touch)
                    local touch = Instance.new("TouchTransmitter")
                    touch.Parent = RootPart
                    touch:Fire(item.Instance)
                end
            end
        end
    end
end

-- Khởi tạo chính
local function Initialize()
    print("🔍 Spy Mod V9 đang khởi tạo...")
    
    -- Tạo UI
    local UI = CreateAdvancedUI()
    
    -- Biến quản lý scan
    local scanRunning = false
    
    -- Hàm scan và update
    local function PerformScan()
        if scanRunning then return end
        scanRunning = true
        
        -- Scan
        local items = ScanItems()
        DetectedItems = items
        
        -- Cập nhật UI
        UpdateUI(UI.ItemsContainer, items)
        
        -- Cập nhật settings
        if SpyMod.Settings.ESPEnabled then
            EnableESP()
        end
        
        -- Notify
        if SpyMod.Settings.NotifyWhenFound and #items > 0 then
            Notify("Spy Mod V9", "Đã tìm thấy " .. #items .. " vật phẩm!", 2)
        end
        
        scanRunning = false
    end
    
    -- Scan lần đầu
    task.wait(1)
    PerformScan()
    
    -- Auto scan mỗi 5 giây
    game:GetService("RunService").Heartbeat:Connect(function()
        if UI.MainFrame.Visible then
            if not scanRunning then
                PerformScan()
            end
        end
    end)
    
    -- Auto Farm
    game:GetService("RunService").Heartbeat:Connect(function()
        if SpyMod.Settings.AutoFarm then
            AutoFarm()
        end
    end)
    
    -- Phím tắt
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.F9 then
            if UI.MainFrame then
                UI.MainFrame.Visible = not UI.MainFrame.Visible
            end
        end
        -- Phím tắt scan nhanh (F5)
        if input.KeyCode == Enum.KeyCode.F5 then
            PerformScan()
            Notify("Spy Mod V9", "Đã quét lại!", 1)
        end
    end)
    
    print("✅ Spy Mod V9 đã tải thành công!")
    print("📌 F9: Mở/đóng menu")
    print("📌 F5: Quét lại vật phẩm")
    print("📌 " .. #DetectedItems .. " vật phẩm đã được tìm thấy")
end

-- Chạy
pcall(Initialize)
