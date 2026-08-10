-- =============================================
-- 🔥 ZaZaHub v3.0 для FPS Flick
-- С улучшенным ESP, сворачиванием в панель и FPS/пингом
-- =============================================

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

-- =============================================
-- 📦 ГЛАВНОЕ МЕНЮ
-- =============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZaZaHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Основная рамка (полное меню)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 580, 0, 450)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- Мини-панель для свёрнутого режима (по центру сверху)
local MiniPanel = Instance.new("Frame")
MiniPanel.Size = UDim2.new(0, 200, 0, 40)
MiniPanel.Position = UDim2.new(0.5, -100, 0, 10)
MiniPanel.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MiniPanel.BackgroundTransparency = 0.2
MiniPanel.BorderSizePixel = 0
MiniPanel.Visible = false
MiniPanel.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 12)
MiniCorner.Parent = MiniPanel

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(0.7, 0, 1, 0)
MiniTitle.Position = UDim2.new(0, 10, 0, 0)
MiniTitle.Text = "🔥 ZaZaHub"
MiniTitle.BackgroundTransparency = 1
MiniTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextSize = 18
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = MiniPanel

local MiniExpandBtn = Instance.new("TextButton")
MiniExpandBtn.Size = UDim2.new(0, 30, 1, -6)
MiniExpandBtn.Position = UDim2.new(1, -35, 0, 3)
MiniExpandBtn.Text = "+"
MiniExpandBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MiniExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniExpandBtn.Font = Enum.Font.GothamBold
MiniExpandBtn.TextSize = 20
MiniExpandBtn.Parent = MiniPanel

local MiniExpandCorner = Instance.new("UICorner")
MiniExpandCorner.CornerRadius = UDim.new(0, 8)
MiniExpandCorner.Parent = MiniExpandBtn

-- Заголовок с кнопкой свернуть (в основном меню)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "🔥 ZaZaHub v3.0"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 200, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 1, -6)
MinBtn.Position = UDim2.new(1, -70, 0, 3)
MinBtn.Text = "–"
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 1, -6)
CloseBtn.Position = UDim2.new(1, -35, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Вкладки
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 35)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabs = {"Aimbot", "ESP", "Visual", "Crosshair"}
local tabButtons = {}
local currentTab = nil

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -85)
ContentContainer.Position = UDim2.new(0, 0, 0, 80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabContents = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, -4)
    btn.Position = UDim2.new(0, (i-1)*125 + 10, 0, 2)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    btn.TextColor3 = Color3.fromRGB(180, 190, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = TabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if currentTab then
            tabContents[currentTab].Visible = false
            tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(40, 45, 65)
            tabButtons[currentTab].TextColor3 = Color3.fromRGB(180, 190, 220)
        end
        currentTab = i
        tabContents[i].Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(70, 110, 180)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    tabButtons[i] = btn
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0, 0, 0, 500)
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = ContentContainer
    tabContents[i] = content
end

-- Вспомогательные функции создания кнопок
local function createButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, yPos, defaultValue, onChange)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text .. " (Выкл)"
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = parent
    local state = defaultValue or false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " (Вкл)" or " (Выкл)")
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(45, 50, 70)
        if onChange then onChange(state) end
    end)
    return btn
end

-- =============================================
-- 🎯 ВКЛАДКА 1: AIMBOT
-- =============================================
local aimTab = tabContents[1]

local aimbotEnabled = false
local aimbotCircle = Drawing.new("Circle")
aimbotCircle.Radius = 60
aimbotCircle.Thickness = 2
aimbotCircle.Color = Color3.fromRGB(0, 255, 100)
aimbotCircle.Filled = false
aimbotCircle.Transparency = 0.5
aimbotCircle.Visible = false

local function canSee(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).unit
    local ray = Ray.new(origin, direction * 1000)
    local hit, pos = workspace:FindPartOnRay(ray, Player.Character)
    if hit then
        return hit:IsDescendantOf(targetPart.Parent)
    end
    return false
end

local function updateAimbot()
    if not aimbotEnabled then 
        aimbotCircle.Visible = false
        return 
    end
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    aimbotCircle.Position = center
    aimbotCircle.Visible = true
    local target = nil
    local shortestDist = math.huge
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and canSee(hrp) then
                local pos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).magnitude
                    if dist < 60 and dist < shortestDist then
                        shortestDist = dist
                        target = plr
                    end
                end
            end
        end
    end
    if target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        aimbotCircle.Color = Color3.fromRGB(255, 50, 50)
    else
        aimbotCircle.Color = Color3.fromRGB(0, 255, 100)
    end
end

createToggle(aimTab, "🎯 Аимбот (круг 60x60)", 10, false, function(state)
    aimbotEnabled = state
end)

-- =============================================
-- 👁️ ВКЛАДКА 2: ESP (с правильным размером)
-- =============================================
local espTab = tabContents[2]

local espEnabled = false
local espPlayers = {}

-- Функция вычисления размера квадрата в пикселях на основе расстояния
local function getBoxSize(worldPos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
    if not onScreen then return 60, 90 end -- fallback
    -- Расстояние от камеры до цели
    local dist = (Camera.CFrame.Position - worldPos).magnitude
    -- Базовый размер (высота персонажа ~5 studs, ширина ~2.5)
    local height = 5 -- studs
    local width = 2.5
    -- Пересчёт в пиксели: (size / dist) * (viewportSize / 2) / tan(FOV/2)
    local fov = 70 -- стандартный FOV
    local viewport = Camera.ViewportSize
    local scale = viewport.Y / (2 * math.tan(math.rad(fov/2)))
    local pixelHeight = (height / dist) * scale
    local pixelWidth = (width / dist) * scale
    return math.max(pixelWidth, 30), math.max(pixelHeight, 50) -- минимальный размер
end

local function createESP(player)
    if player == Player then return end
    if espPlayers[player] then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(0, 200, 255)
    box.Filled = false
    box.Transparency = 0.7
    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Color = Color3.fromRGB(0, 200, 255)
    line.Transparency = 0.5
    espPlayers[player] = {box = box, line = line}
end

local function updateESP()
    for player, data in pairs(espPlayers) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen and espEnabled then
                local boxW, boxH = getBoxSize(hrp.Position)
                data.box.Size = Vector2.new(boxW, boxH)
                data.box.Position = Vector2.new(pos.X - boxW/2, pos.Y - boxH/2)
                data.box.Visible = true
                local bottom = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                data.line.From = bottom
                data.line.To = Vector2.new(pos.X, pos.Y)
                data.line.Visible = true
            else
                data.box.Visible = false
                data.line.Visible = false
            end
        else
            data.box.Visible = false
            data.line.Visible = false
        end
    end
end

createToggle(espTab, "👁️ ESP (квадраты + линии)", 10, false, function(state)
    espEnabled = state
    if state then
        for _, plr in pairs(game.Players:GetPlayers()) do
            createESP(plr)
        end
    else
        for _, data in pairs(espPlayers) do
            data.box:Remove()
            data.line:Remove()
        end
        espPlayers = {}
    end
end)

-- =============================================
-- 🌈 ВКЛАДКА 3: VISUAL (FPS, Ping, Радуга)
-- =============================================
local visTab = tabContents[3]

-- Радужный режим
local rainbowEnabled = false
local rainbowSpeed = 5

local function updateRainbow()
    if not rainbowEnabled or not Player.Character then return end
    local hue = (tick() * rainbowSpeed) % 1
    local color = Color3.fromHSV(hue, 1, 1)
    for _, part in pairs(Player.Character:GetChildren()) do
        if part:IsA("BasePart") and (part.Name == "Right Arm" or part.Name == "Left Arm" or part.Name == "Torso") then
            part.Color = color
        end
    end
    local weapon = Player.Character:FindFirstChildWhichIsA("Tool")
    if weapon then
        for _, part in pairs(weapon:GetChildren()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromHSV((hue + 0.3) % 1, 1, 1)
            end
        end
    end
end

createToggle(visTab, "🌈 Радужные руки + оружие", 10, false, function(state)
    rainbowEnabled = state
    if not state then
        if Player.Character then
            for _, part in pairs(Player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.fromRGB(255, 255, 255)
                end
            end
            local weapon = Player.Character:FindFirstChildWhichIsA("Tool")
            if weapon then
                for _, part in pairs(weapon:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
        end
    end
end)

-- Регулятор скорости (кнопки)
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 30)
speedLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
speedLabel.Text = "Скорость перелива: " .. rainbowSpeed
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.Parent = visTab

local function updateSpeedLabel()
    speedLabel.Text = "Скорость перелива: " .. rainbowSpeed
end

createButton(visTab, "⬆ Увеличить скорость", 0.4, function()
    rainbowSpeed = math.min(rainbowSpeed + 1, 20)
    updateSpeedLabel()
end)

createButton(visTab, "⬇ Уменьшить скорость", 0.5, function()
    rainbowSpeed = math.max(rainbowSpeed - 1, 1)
    updateSpeedLabel()
end)

-- Сброс цвета
createButton(visTab, "🔄 Сбросить цвета", 0.6, function()
    if Player.Character then
        for _, part in pairs(Player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(255, 255, 255)
            end
        end
        local weapon = Player.Character:FindFirstChildWhichIsA("Tool")
        if weapon then
            for _, part in pairs(weapon:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end)

-- Отображение FPS и Ping
local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(0.9, 0, 0, 30)
statsLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
statsLabel.BackgroundTransparency = 1
statsLabel.TextColor3 = Color3.fromRGB(180, 220, 100)
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 14
statsLabel.Text = "FPS: 0 | Ping: 0ms"
statsLabel.Parent = visTab

local function updateStats()
    local fps = math.floor(1 / RunService.RenderStepped:Wait()) -- примерный FPS
    local ping = Stats:FindFirstChild("Data") and Stats.Data:FindFirstChild("Ping") and Stats.Data.Ping.Value or 0
    statsLabel.Text = "FPS: " .. fps .. " | Ping: " .. ping .. "ms"
end

-- Обновление статистики раз в секунду
spawn(function()
    while wait(1) do
        updateStats()
    end
end)

-- =============================================
-- 🎯 ВКЛАДКА 4: CROSSHAIR
-- =============================================
local crossTab = tabContents[4]

local crosshairType = 1
local crosshairEnabled = false
local crosshairParts = {}
local crosshairAngle = 0

local function createCrosshair(type)
    for _, obj in pairs(crosshairParts) do
        obj:Remove()
    end
    crosshairParts = {}
    if not crosshairEnabled then return end
    
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local size = 25
    local colors = {
        Color3.fromRGB(0, 255, 100),
        Color3.fromRGB(255, 200, 100),
        Color3.fromRGB(255, 50, 50)
    }
    
    if type == 1 then
        local h = Drawing.new("Line")
        h.From = Vector2.new(center.X - size, center.Y)
        h.To = Vector2.new(center.X + size, center.Y)
        h.Thickness = 2
        h.Color = colors[1]
        h.Transparency = 0.8
        table.insert(crosshairParts, h)
        local v = Drawing.new("Line")
        v.From = Vector2.new(center.X, center.Y - size)
        v.To = Vector2.new(center.X, center.Y + size)
        v.Thickness = 2
        v.Color = colors[1]
        v.Transparency = 0.8
        table.insert(crosshairParts, v)
    elseif type == 2 then
        for i = 0, 1 do
            local line = Drawing.new("Line")
            local offsetX = (i == 0) and -15 or 15
            local offsetY = (i == 0) and -10 or 10
            line.From = Vector2.new(center.X - size + offsetX, center.Y + offsetY)
            line.To = Vector2.new(center.X + size + offsetX, center.Y + offsetY)
            line.Thickness = 2
            line.Color = colors[2]
            line.Transparency = 0.8
            table.insert(crosshairParts, line)
        end
    elseif type == 3 then
        local c1 = Drawing.new("Circle")
        c1.Position = Vector2.new(center.X - 15, center.Y)
        c1.Radius = 12
        c1.Thickness = 2
        c1.Color = colors[3]
        c1.Filled = false
        c1.Transparency = 0.8
        table.insert(crosshairParts, c1)
        local c2 = Drawing.new("Circle")
        c2.Position = Vector2.new(center.X + 15, center.Y)
        c2.Radius = 12
        c2.Thickness = 2
        c2.Color = colors[3]
        c2.Filled = false
        c2.Transparency = 0.8
        table.insert(crosshairParts, c2)
        local line = Drawing.new("Line")
        line.From = Vector2.new(center.X - 15, center.Y + 10)
        line.To = Vector2.new(center.X + 15, center.Y - 10)
        line.Thickness = 2
        line.Color = colors[3]
        line.Transparency = 0.8
        table.insert(crosshairParts, line)
    end
end

local function rotateCrosshair()
    if not crosshairEnabled then return end
    crosshairAngle = crosshairAngle + 0.02
    local angle = crosshairAngle
    for _, obj in pairs(crosshairParts) do
        if obj:IsA("Line") then
            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local from = obj.From
            local to = obj.To
            local mid = (from + to) / 2
            local vec1 = from - mid
            local vec2 = to - mid
            local cosA = math.cos(angle)
            local sinA = math.sin(angle)
            local newVec1 = Vector2.new(vec1.X * cosA - vec1.Y * sinA, vec1.X * sinA + vec1.Y * cosA)
            local newVec2 = Vector2.new(vec2.X * cosA - vec2.Y * sinA, vec2.X * sinA + vec2.Y * cosA)
            obj.From = mid + newVec1
            obj.To = mid + newVec2
        end
    end
end

createToggle(crossTab, "🔄 Включить прицел", 10, false, function(state)
    crosshairEnabled = state
    if state then
        createCrosshair(crosshairType)
    else
        for _, obj in pairs(crosshairParts) do
            obj:Remove()
        end
        crosshairParts = {}
    end
end)

createButton(crossTab, "🎯 Прицел +", 55, function()
    crosshairType = 1
    if crosshairEnabled then createCrosshair(1) end
end)

createButton(crossTab, "🎯 Прицел ~", 100, function()
    crosshairType = 2
    if crosshairEnabled then createCrosshair(2) end
end)

createButton(crossTab, "🎯 Прицел &", 145, function()
    crosshairType = 3
    if crosshairEnabled then createCrosshair(3) end
end)

-- =============================================
-- 🔄 СВОРАЧИВАНИЕ / РАЗВОРАЧИВАНИЕ (в стиле Rayfield)
-- =============================================
local minimized = false

local function minimize()
    minimized = true
    MainFrame.Visible = false
    MiniPanel.Visible = true
    MinBtn.Text = "+"
end

local function expand()
    minimized = false
    MainFrame.Visible = true
    MiniPanel.Visible = false
    MinBtn.Text = "–"
end

MinBtn.MouseButton1Click:Connect(function()
    if minimized then
        expand()
    else
        minimize()
    end
end)

MiniExpandBtn.MouseButton1Click:Connect(function()
    expand()
end)

-- =============================================
-- 🔄 ОБНОВЛЕНИЯ В РЕАЛЬНОМ ВРЕМЕНИ
-- =============================================

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then updateAimbot() end
    if espEnabled then updateESP() end
    if rainbowEnabled then updateRainbow() end
    if crosshairEnabled then rotateCrosshair() end
end)

-- =============================================
-- 🧹 ЗАКРЫТИЕ СКРИПТА (очистка ресурсов)
-- =============================================
CloseBtn.MouseButton1Click:Connect(function()
    for _, data in pairs(espPlayers) do
        data.box:Remove()
        data.line:Remove()
    end
    for _, obj in pairs(crosshairParts) do
        obj:Remove()
    end
    aimbotCircle:Remove()
    ScreenGui:Destroy()
end)

-- =============================================
-- 🚀 ЗАПУСК
-- =============================================
tabButtons[1].MouseButton1Click:Fire()

print("🔥 ZaZaHub v3.0 загружен!")
print("✅ ESP с точными размерами")
print("✅ Радуга + сброс цвета")
print("✅ FPS и Ping на экране")
print("✅ Сворачивание в мини-панель (как Rayfield)")
```

---
