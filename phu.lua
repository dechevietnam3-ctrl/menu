local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- XÓA MENU CŨ NẾU CÓ ĐỂ TRÁNH TRÙNG LẶP LỖI
local PlayerGui = Player:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("RingtaFullSystem") then 
    PlayerGui.RingtaFullSystem:Destroy() 
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RingtaFullSystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

---------------------------------------------------------------------
-- 1. THANH TOP BAR NẰM NGANG CỐ ĐỊNH (Theo ảnh 1000048690_2.jpg)
---------------------------------------------------------------------
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Size = UDim2.new(0, 310, 0, 38)
TopBar.Position = UDim2.new(0.5, -155, 0, 15) -- Nằm chính giữa cạnh trên màn hình
TopBar.BackgroundColor3 = Color3.fromRGB(20, 18, 25) -- Nền tối huyền bí
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 5

local TopBarCorner = Instance.new("UICorner", TopBar)
TopBarCorner.CornerRadius = UDim.new(0, 8)

-- Viền LED Gradient Hồng Tím - Xanh Dương rực rỡ
local TopBarStroke = Instance.new("UIStroke", TopBar)
TopBarStroke.Thickness = 1.8
local TopBarGradient = Instance.new("UIGradient", TopBarStroke)
TopBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 45, 140)), -- Hồng tím bên trái
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 160, 255))   -- Xanh neon bên phải
})

-- Icon Di Chuyển (✥)
local DragIcon = Instance.new("TextLabel", TopBar)
DragIcon.Size = UDim2.new(0, 35, 1, 0)
DragIcon.Position = UDim2.new(0, 8, 0, 0)
DragIcon.Text = "✥"
DragIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
DragIcon.TextSize = 20
DragIcon.BackgroundTransparency = 1

-- Nút bấm chữ "Open RINGTA SCRIPTS" (Icon bàn tay chỉ ☝️)
local ToggleButton = Instance.new("TextButton", TopBar)
ToggleButton.Size = UDim2.new(1, -50, 1, 0)
ToggleButton.Position = UDim2.new(0, 45, 0, 0)
ToggleButton.Text = "☝️  Open RINGTA SCRIPTS"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamMedium
ToggleButton.TextSize = 14
ToggleButton.BackgroundTransparency = 1
ToggleButton.TextXAlignment = Enum.TextXAlignment.Left

---------------------------------------------------------------------
-- 2. BẢNG MENU CHÍNH CHIA ĐÔI RED-WINE (Theo ảnh 1000048689.jpg)
---------------------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 530, 0, 330)
MainFrame.Position = UDim2.new(0.5, -265, 0.5, -140) -- Căn giữa màn hình, dịch xuống dưới một chút
MainFrame.BackgroundColor3 = Color3.fromRGB(150, 25, 40) -- Màu đỏ rượu chuẩn Ringta
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- Mặc định ẩn, bấm thanh trên mới hiện
MainFrame.ZIndex = 2

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

-- Sidebar dọc bên trái
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 155, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(120, 20, 30) -- Đỏ sẫm tối hơn
SideBar.BorderSizePixel = 0
local SideBarCorner = Instance.new("UICorner", SideBar)
SideBarCorner.CornerRadius = UDim.new(0, 12)

-- Icon Ngôi sao + Tên Script ở góc trái Sidebar
local SideTitle = Instance.new("TextLabel", SideBar)
SideTitle.Size = UDim2.new(1, 0, 0, 40)
SideTitle.Text = "  ⭐ RINGTA SCRIPTS"
SideTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SideTitle.Font = Enum.Font.SourceSansBold
SideTitle.TextSize = 14
SideTitle.TextXAlignment = Enum.TextXAlignment.Left
SideTitle.BackgroundTransparency = 1

-- Khung bên phải chứa nội dung
local ContentHolder = Instance.new("Frame", MainFrame)
ContentHolder.Size = UDim2.new(1, -175, 1, -40)
ContentHolder.Position = UDim2.new(0, 165, 0, 35)
ContentHolder.BackgroundTransparency = 1

-- Tạo các trang Tab
local MainPage = Instance.new("Frame", ContentHolder)
MainPage.Size = UDim2.new(1, 0, 1, 0)
MainPage.BackgroundTransparency = 1
MainPage.Visible = true

-- Hàm tạo nút bấm danh mục (Tab Button) bên trái
local tabCount = 0
local function AddTab(name)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, 45 + (tabCount * 42))
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(235, 235, 235)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = Color3.fromRGB(140, 30, 40)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    tabCount = tabCount + 1
end

AddTab("Home")
AddTab("⭐ Main")
AddTab("🚀 Teleport")
AddTab("⚙️ Other Features")

---------------------------------------------------------------------
-- 3. BỘ NÚT ĐIỀU KHIỂN THOÁT RA VÀO LẠI (NẰM GÓC TRÊN PHẢI BẢNG ĐỎ)
---------------------------------------------------------------------
local WindowControls = Instance.new("Frame", MainFrame)
WindowControls.Size = UDim2.new(0, 100, 0, 30)
WindowControls.Position = UDim2.new(1, -105, 0, 5)
WindowControls.BackgroundTransparency = 1
WindowControls.ZIndex = 4

-- Nút X (Thoát/Đóng hẳn menu)
local CloseBtn = Instance.new("TextButton", WindowControls)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 2)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.BackgroundTransparency = 1

-- Nút ô vuông Ph phóng to (□)
local MaxBtn = Instance.new("TextButton", WindowControls)
MaxBtn.Size = UDim2.new(0, 25, 0, 25)
MaxBtn.Position = UDim2.new(1, -60, 0, 2)
MaxBtn.Text = "⬜"
MaxBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
MaxBtn.Font = Enum.Font.SourceSans
MaxBtn.TextSize = 12
MaxBtn.BackgroundTransparency = 1

-- Nút dấu trừ Thu nhỏ (-)
local MinBtn = Instance.new("TextButton", WindowControls)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -90, 0, 2)
MinBtn.Text = "━"
MinBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 10
MinBtn.BackgroundTransparency = 1

---------------------------------------------------------------------
-- 4. HÀNG TÍNH NĂNG CÓ CÔNG TẮC GẠT TRẮNG/ĐỎ (Giống ảnh 1000048689.jpg)
---------------------------------------------------------------------
local function AddFeatureToggle(text, yPos, action)
    local row = Instance.new("Frame", MainPage)
    row.Size = UDim2.new(1, 0, 0, 52)
    row.Position = UDim2.new(0, 0, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(135, 25, 35) -- Màu ô tính năng
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    
    local txt = Instance.new("TextLabel", row)
    txt.Size = UDim2.new(1, -70, 1, 0)
    txt.Position = UDim2.new(0, 12, 0, 0)
    txt.Text = text
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.Font = Enum.Font.SourceSansBold
    txt.TextSize = 16
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.BackgroundTransparency = 1
    
    -- Nút gạt Switch
    local switch = Instance.new("TextButton", row)
    switch.Size = UDim2.new(0, 46, 0, 22)
    switch.Position = UDim2.new(1, -58, 0.5, -11)
    switch.Text = ""
    switch.BackgroundColor3 = Color3.fromRGB(175, 35, 45) -- Mặc định màu Đỏ (OFF)
    local swCorner = Instance.new("UICorner", switch)
    swCorner.CornerRadius = UDim.new(1, 0)
    
    -- Viên tròn di chuyển bên trong công tắc
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local isOn = false
    switch.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            switch.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Bật gạt sang Trắng giống ảnh
            circle.Position = UDim2.new(1, -19, 0.5, -8)
            circle.BackgroundColor3 = Color3.fromRGB(150, 25, 40) -- Tròn đổi sang Đỏ
        else
            switch.BackgroundColor3 = Color3.fromRGB(175, 35, 45) -- Tắt về màu Đỏ
            circle.Position = UDim2.new(0, 3, 0.5, -8)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Tròn về Trắng
        end
        if action then action(isOn) end
    end)
end

-- Thêm 3 tính năng mẫu hoạt động cực mượt
AddFeatureToggle("Free Auto Bond", 10, function(state) print("Auto Bond:", state) end)
AddFeatureToggle("Bring Random Items To You", 70, function(state) print("Bring Items:", state) end)
AddFeatureToggle("Auto Hit Weapon", 130, function(state) print("Auto Hit:", state) end)

---------------------------------------------------------------------
-- 5. LOGIC DI CHUYỂN, ĐÓNG MỞ, VÀ THOÁT RA VÀO LẠI MƯỢT MÀ
---------------------------------------------------------------------
-- Bấm thanh ngang trên đầu để Ẩn / Hiện bảng Menu đỏ
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Bấm nút X hoặc dấu trừ (-) ở góc bảng menu đỏ để THOÁT RA (Ẩn menu đi ngay lập tức)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
MaxBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- Giữ nguyên code hệ thống KÉO THẢ DI CHUYỂN THANH TOP BAR từ code gốc của bạn
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    TopBar.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = TopBar.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
