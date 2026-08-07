-- Akbarshox Fly v3 | Полная Rainbow версия (Обновлено: Быстрое закрытие)

local player = game.Players.LocalPlayer
local flying = false
local speed = 80
local minimized = false

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local sg = Instance.new("ScreenGui")
sg.Name = "AkbarshoxFlyV3"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 165)
frame.Position = UDim2.new(0.5, -110, 0.12, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = sg

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -85, 0, 32)
title.Position = UDim2.new(0, 12, 0, 6)
title.BackgroundTransparency = 1
title.Text = "⚡ Akbarshox Fly v3"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 15.5
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -64, 0, 8)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "–"
minimizeBtn.TextSize = 24
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 8)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextSize = 26
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.9, 0, 0, 45)
toggle.Position = UDim2.new(0.05, 0, 0, 46)
toggle.Text = "FLY"
toggle.TextColor3 = Color3.new(0,0,0)
toggle.TextSize = 17
toggle.Font = Enum.Font.GothamBold
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 12)

local minus10 = Instance.new("TextButton")
minus10.Size = UDim2.new(0, 52, 0, 38)
minus10.Position = UDim2.new(0.05, 0, 0, 100)
minus10.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
minus10.Text = "-10"
minus10.TextColor3 = Color3.new(1,1,1)
minus10.TextSize = 15
minus10.Font = Enum.Font.GothamBold
minus10.Parent = frame
Instance.new("UICorner", minus10).CornerRadius = UDim.new(0, 10)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 72, 0, 38)
speedBox.Position = UDim2.new(0.5, -36, 0, 100)
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
speedBox.Text = "80"
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.TextSize = 18
speedBox.Font = Enum.Font.GothamBold
speedBox.Parent = frame
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 10)

local plus10 = Instance.new("TextButton")
plus10.Size = UDim2.new(0, 52, 0, 38)
plus10.Position = UDim2.new(0.73, 0, 0, 100)
plus10.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
plus10.Text = "+10"
plus10.TextColor3 = Color3.new(1,1,1)
plus10.TextSize = 15
plus10.Font = Enum.Font.GothamBold
plus10.Parent = frame
Instance.new("UICorner", plus10).CornerRadius = UDim.new(0, 10)

local bv, bg = nil, nil

-- === РАДУЖНАЯ АНИМАЦИЯ ===
RunService.RenderStepped:Connect(function()
    local hue = (tick() % 4) / 4
    local color = Color3.fromHSV(hue, 1, 1)
    
    title.TextColor3 = color
    toggle.BackgroundColor3 = color
    minimizeBtn.TextColor3 = color
    closeBtn.TextColor3 = color
    minus10.TextColor3 = color
    plus10.TextColor3 = color
    speedBox.TextColor3 = color
end)

local function tweenSize(newSize)
    TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {Size = newSize}):Play()
end

local function startFly()
    if flying then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    flying = true
    hum.PlatformStand = true

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(99999, 99999, 99999)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(99999, 99999, 99999)
    bg.P = 12500
    bg.Parent = root

    toggle.Text = "STOP"
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = false end
    toggle.Text = "FLY"
end

toggle.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

minus10.MouseButton1Click:Connect(function()
    speed = math.max(10, speed - 10)
    speedBox.Text = tostring(speed)
end)

plus10.MouseButton1Click:Connect(function()
    speed = speed + 10
    speedBox.Text = tostring(speed)
end)

speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val then speed = val else speedBox.Text = tostring(speed) end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        toggle.Visible = false
        minus10.Visible = false
        speedBox.Visible = false
        plus10.Visible = false
        minimizeBtn.Text = "+"
        tweenSize(UDim2.new(0, 220, 0, 48))
    else
        minimizeBtn.Text = "–"
        tweenSize(UDim2.new(0, 220, 0, 165))
        task.wait(0.25)
        toggle.Visible = true
        minus10.Visible = true
        speedBox.Visible = true
        plus10.Visible = true
    end
end)

-- Исправленная кнопка закрытия
closeBtn.MouseButton1Click:Connect(function()
    stopFly() -- Останавливаем полет перед выходом
    frame.Visible = false -- Прячем меню сразу
    
    local thank = Instance.new("TextLabel", sg)
    thank.Size = UDim2.new(0.9, 0, 0, 100)
    thank.Position = UDim2.new(0.05, 0, 0.4, 0)
    thank.BackgroundTransparency = 1
    thank.Text = "Thank You For Using\nAkbarshox Fly v3"
    thank.TextColor3 = Color3.new(1, 1, 1)
    thank.TextSize = 28
    thank.Font = Enum.Font.GothamBold
    thank.TextWrapped = true
    
    -- Радуга для прощальной надписи
    task.spawn(function()
        while thank.Parent do
            local hue = (tick() % 3) / 3
            thank.TextColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait(0.05)
        end
    end)
    
    task.wait(2.5)
    sg:Destroy()
end)

-- Логика управления полетом
local function getJoystickVector()
    local success, result = pcall(function()
        local pm = player.PlayerScripts:FindFirstChild("PlayerModule")
        if pm then
            local cm = pm:FindFirstChild("ControlModule")
            if cm then return require(cm):GetMoveVector() end
        end
        return Vector3.new(0,0,0)
    end)
    return success and result or Vector3.new(0,0,0)
end

RunService.RenderStepped:Connect(function()
    if not flying or not bv then return end
    local cam = workspace.CurrentCamera
    local move = getJoystickVector()
    local vertical = 0
    local uis = game:GetService("UserInputService")
    
    if uis:IsKeyDown(Enum.KeyCode.Space) then vertical = 1 end
    if uis:IsKeyDown(Enum.KeyCode.LeftControl) then vertical = -1 end

    local finalDir = Vector3.new(move.X, vertical, move.Z)
    if finalDir.Magnitude > 0 then
        bv.Velocity = cam.CFrame:VectorToWorldSpace(finalDir.Unit) * speed
    else
        bv.Velocity = Vector3.new(0,0,0)
    end
    if bg then bg.CFrame = cam.CFrame end
end)

print("✅ Akbarshox Fly v3 | Полная версия готова")
