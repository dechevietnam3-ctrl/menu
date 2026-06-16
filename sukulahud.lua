-- ==========================================
-- BANANA STYLE UI LIBRARY (UPDATED OVERHAUL)
-- ==========================================
local BananaLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function BananaLib:CreateWindow(titleText)
	local Window = { CurrentTab = nil, Tabs = {} }

	-- 1. ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BananaHub_Remake"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

	-- 2. Main Frame (Cửa sổ chính)
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 520, 0, 320)
	mainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
	mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 10)
	mainCorner.Parent = mainFrame

	-- Viền màu vàng chuối mỏng xung quanh menu
	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(245, 203, 12)
	mainStroke.Thickness = 1.5
	mainStroke.Parent = mainFrame

	-- 3. Sidebar (Thanh danh mục bên trái)
	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0, 140, 1, 0)
	sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	sidebar.BorderSizePixel = 0
	sidebar.Parent = mainFrame

	local sideCorner = Instance.new("UICorner")
	sideCorner.CornerRadius = UDim.new(0, 10)
	sideCorner.Parent = sidebar

	-- Thùng chứa các nút Tab (Hỗ trợ cuộn nếu nhiều tab)
	local tabContainer = Instance.new("ScrollingFrame")
	tabContainer.Size = UDim2.new(1, 0, 1, -50)
	tabContainer.Position = UDim2.new(0, 0, 0, 50)
	tabContainer.BackgroundTransparency = 1
	tabContainer.BorderSizePixel = 0
	tabContainer.ScrollBarThickness = 2
	tabContainer.ScrollBarImageColor3 = Color3.fromRGB(245, 203, 12)
	tabContainer.Parent = sidebar

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Padding = UDim.new(0, 5)
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabLayout.Parent = tabContainer

	-- Tiêu đề Hub
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundTransparency = 1
	title.Text = titleText or "BANANA HUB"
	title.TextColor3 = Color3.fromRGB(245, 203, 12) -- Màu vàng đặc trưng
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.Parent = sidebar

	-- 4. Nút Mở Menu (Floating Open Button) - MỚI CẬP NHẬT
	local openButton = Instance.new("TextButton")
	openButton.Size = UDim2.new(0, 45, 0, 45)
	openButton.Position = UDim2.new(0, 20, 0, 20) -- Mặc định ở góc trên bên trái màn hình
	openButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	openButton.Text = "🍌"
	openButton.TextSize = 20
	openButton.Font = Enum.Font.GothamBold
	openButton.Visible = false -- Chỉ hiện khi đóng menu chính
	openButton.Parent = screenGui

	local openCorner = Instance.new("UICorner")
	openCorner.CornerRadius = UDim.new(0, 25) -- Bo tròn hoàn toàn nút mở
	openCorner.Parent = openButton

	local openStroke = Instance.new("UIStroke")
	openStroke.Color = Color3.fromRGB(245, 203, 12)
	openStroke.Thickness = 1.5
	openStroke.Parent = openButton

	-- 5. Nút Thoát/Ẩn Menu (Close Button) - CẬP NHẬT LOGIC ẨN
	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -35, 0, 10)
	closeButton.BackgroundTransparency = 1
	closeButton.Text = "✕"
	closeButton.TextColor3 = Color3.fromRGB(245, 203, 12)
	closeButton.TextSize = 18
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = mainFrame

	-- Hiệu ứng hover cho nút thoát (Vàng -> Đỏ gay gắt)
	closeButton.MouseEnter:Connect(function()
		TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 75, 75)}):Play()
	end)
	closeButton.MouseLeave:Connect(function()
		TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(245, 203, 12)}):Play()
	end)

	-- Sự kiện khi click nút thoát: Ẩn menu chính, hiện nút mở lại
	closeButton.MouseButton1Click:Connect(function()
		mainFrame.Visible = false
		openButton.Visible = true
	end)

	-- Sự kiện khi click nút mở lại: Hiện menu chính, ẩn nút mở đi
	openButton.MouseButton1Click:Connect(function()
		mainFrame.Visible = true
		openButton.Visible = false
	end)

	-- 6. Content Area (Vùng chứa nội dung bên phải)
	local contentArea = Instance.new("Frame")
	contentArea.Size = UDim2.new(1, -155, 1, -50)
	contentArea.Position = UDim2.new(0, 145, 0, 45)
	contentArea.BackgroundTransparency = 1
	contentArea.Parent = mainFrame

	-- Logic Kéo Thả Menu Chính (Smooth Dragging)
	local dragging, dragInput, dragStart, startPos
	mainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	mainFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- Logic Kéo Thả Nút Mở Menu (Drag cho Open Button)
	local openDragging, openDragInput, openDragStart, openStartPos
	openButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			openDragging = true
			openDragStart = input.Position
			openStartPos = openButton.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then openDragging = false end
			end)
		end
	end)
	openButton.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then openDragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == openDragInput and openDragging then
			local delta = input.Position - openDragStart
			openButton.Position = UDim2.new(openStartPos.X.Scale, openStartPos.X.Offset + delta.X, openStartPos.Y.Scale, openStartPos.Y.Offset + delta.Y)
		end
	end)

	-- HÀM TẠO TAB MỚI
	function Window:CreateTab(tabName)
		local Tab = {}

		-- Trang chứa các chức năng của Tab này
		local page = Instance.new("ScrollingFrame")
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.Visible = false
		page.ScrollBarThickness = 4
		page.ScrollBarImageColor3 = Color3.fromRGB(245, 203, 12)
		page.Parent = contentArea

		local pageLayout = Instance.new("UIListLayout")
		pageLayout.Padding = UDim.new(0, 8)
		pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		pageLayout.Parent = page

		-- Nút bấm chuyển Tab trên Sidebar
		local tabButton = Instance.new("TextButton")
		tabButton.Size = UDim2.new(0, 120, 0, 35)
		tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		tabButton.Text = tabName
		tabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		tabButton.TextSize = 14
		tabButton.Font = Enum.Font.GothamMedium
		tabButton.AutoButtonColor = false
		tabButton.Parent = tabContainer

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = tabButton

		-- Kịch bản chuyển đổi Tab mượt mà
		local function selectTab()
			if Window.CurrentTab then
				Window.CurrentTab.Page.Visible = false
				TweenService:Create(Window.CurrentTab.Button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
			end
			Window.CurrentTab = {Page = page, Button = tabButton}
			page.Visible = true
			TweenService:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(245, 203, 12)}):Play()
		end

		tabButton.MouseButton1Click:Connect(selectTab)
		if not Window.CurrentTab then selectTab() end -- Tự động chọn tab đầu tiên

		-- HÀM TẠO NÚT BẤM (BUTTON) TRONG TAB
		function Tab:CreateButton(text, callback)
			local callback = callback or function() end
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(0, 350, 0, 35)
			button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
			button.Text = "  " .. text
			button.TextColor3 = Color3.fromRGB(230, 230, 230)
			button.TextSize = 14
			button.Font = Enum.Font.Gotham
			button.TextXAlignment = Enum.TextXAlignment.Left
			button.Parent = page

			local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = button
			local s = Instance.new("UIStroke") s.Color = Color3.fromRGB(40, 40, 40) s.Thickness = 1 s.Parent = button

			button.MouseButton1Click:Connect(function()
				-- Hiệu ứng nháy vàng nhẹ khi bấm nút
				button.BackgroundColor3 = Color3.fromRGB(245, 203, 12)
				button.TextColor3 = Color3.fromRGB(0, 0, 0)
				task.wait(0.1)
				button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
				button.TextColor3 = Color3.fromRGB(230, 230, 230)
				callback()
			end)
		end

		-- HÀM TẠO CÔNG TẮC BẬT/TẮT (TOGGLE) TRONG TAB
		function Tab:CreateToggle(text, callback)
			local callback = callback or function() end
			local toggled = false

			local toggleFrame = Instance.new("Frame")
			toggleFrame.Size = UDim2.new(0, 350, 0, 40)
			toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
			toggleFrame.Parent = page

			local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = toggleFrame
			local s = Instance.new("UIStroke") s.Color = Color3.fromRGB(40, 40, 40) s.Thickness = 1 s.Parent = toggleFrame

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -50, 1, 0)
			label.Position = UDim2.new(0, 10, 0, 0)
			label.BackgroundTransparency = 1
			label.Text = text
			label.TextColor3 = Color3.fromRGB(230, 230, 230)
			label.TextSize = 14
			label.Font = Enum.Font.Gotham
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = toggleFrame

			-- Hộp vuông hiển thị trạng thái On/Off
			local box = Instance.new("Frame")
			box.Size = UDim2.new(0, 22, 0, 22)
			box.Position = UDim2.new(1, -35, 0.5, -11)
			box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			box.Parent = toggleFrame

			local boxCorner = Instance.new("UICorner") boxCorner.CornerRadius = UDim.new(0, 4) boxCorner.Parent = box

			local function click()
				toggled = not toggled
				if toggled then
					TweenService:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245, 203, 12)}):Play()
				else
					TweenService:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
				end
				callback(toggled)
			end

			local clickBtn = Instance.new("TextButton")
			clickBtn.Size = UDim2.new(1, 0, 1, 0)
			clickBtn.BackgroundTransparency = 1
			clickBtn.Text = ""
			clickBtn.Parent = toggleFrame
			clickBtn.MouseButton1Click:Connect(click)
		end

		return Tab
	end

	return Window
end

-- ==========================================
-- CÁCH KHỞI TẠO VÀ SỬ DỤNG MENU (MỚI)
-- ==========================================
local Window = BananaLib:CreateWindow("BANANA REMAKE")

-- Tạo Trang chính (Tab Main) - Hiện đang trống để bạn tự thêm tính năng
local MainTab = Window:CreateTab("Main")

-- Tạo Trang phụ (Tab Teleport) - Hiện đang trống để bạn tự thêm tính năng
local bloxtab = Window:CreateTab("Blox Fruits")

local growtab = Window:CreateTab("grow a garden 2 ")

growtab:CreateButton("Realkid hub", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))()
end)

growtab:CreateButton("Bingfrood dự đoán hạn giống ", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"))()
end)

growtab:CreateButton("colaGaG2 ", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Bubu2k/robloxscript/refs/heads/main/colaGaG2.lua"))()
end)


growtab:CreateButton("foxnameGaG2 ", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Bubu2k/robloxscript/refs/heads/main/foxnameGaG2.lua"))()
end)


growtab:CreateButton("Teddy Hub", function()
	-- Đợi game load xong hoàn toàn rồi mới chạy script
	repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/main.lua"))()
end)

bloxtab:CreateButton("BananaHub", function()
	loadstring(game:HttpGet("https://github.com/LuaCrack/ALLVERSIONFIXED/raw/refs/heads/main/ZisHrVn"))()
end)

bloxtab:CreateButton("HUB_VIP_BY_HAO", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/TranGiaHao-source/HaoModHub/refs/heads/main/HUB_VIP_BY_HAO"))()
end)

bloxtab:CreateButton("trauhubv10", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/trungdao2k4/buffalo/refs/heads/main/trauhubv10"))()
end)


