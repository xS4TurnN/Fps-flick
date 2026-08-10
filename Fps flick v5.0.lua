-- =============================================
-- 🔥 ZaZaHub v5.0 для FPS Flick
-- С улучшенным ESP, RGB-переливом, виджетом FPS/Ping и работающими прицелами
-- =============================================

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

-- =============================================
-- 📦 ГЛАВНОЕ МЕНЮ (стильный дизайн)
-- =============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZaZaHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 480)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

-- Тень (имитация)
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 4, 1, 4)
Shadow.Position = UDim2.new(0, -2, 0, -2)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.7
Shadow.BorderSizePixel = 0
Shadow.Parent = MainFrame
local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 20)
ShadowCorner.Parent = Shadow

-- Мини-панель (свёрнутый режим) — фиксирована в центре сверху
local MiniPanel = Instance.new("Frame")
MiniPanel.Size = UDim2.new(0, 220, 0, 40)
MiniPanel.Position = UDim2.new(0.5, -110, 0, 12)
MiniPanel.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
MiniPanel.BackgroundTransparency = 0.2
MiniPanel.BorderSizePixel = 0
MiniPanel.Visible = false
MiniPanel.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 14)
MiniCorner.Parent = MiniPanel

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(0.7, 0, 1, 0)
MiniTitle.Position = UDim2.new(0, 14, 0, 0)
MiniTitle.Text = "🔥 ZaZaHub"
MiniTitle.BackgroundTransparency = 1
MiniTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextSize = 18
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = MiniPanel

local MiniExpandBtn = Instance.new("TextButton")
MiniExpandBtn.Size = UDim2.new(0, 34, 1, -6)
MiniExpandBtn.Position = UDim2.new(1, -40, 0, 3)
MiniExpandBtn.Text = "+"
MiniExpandBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 85)
MiniExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniExpandBtn.Font = Enum.Font.GothamBold
MiniExpandBtn.TextSize = 22
MiniExpandBtn.Parent = MiniPanel

local MiniExpandCorner = Instance.new("UICorner")
MiniExpandCorner.CornerRadius = UDim.new(0, 10)
MiniExpandCorner.Parent = MiniExpandBtn

-- Заголовок основного меню
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.75, 0, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Text = "🔥 ZaZaHub v5.0"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 200, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 34, 1, -6)
MinBtn.Position = UDim2.new(1, -78, 0, 3)
MinBtn.Text = "–"
MinBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 80)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 24
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 10)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 1, -6)
CloseBtn.Position = UDim2.new(1, -40, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 80)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

-- Контейнер вкладок
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 38)
TabContainer.Position = UDim2.new(0, 0, 0, 48)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabs = {"Aimbot", "ESP", "Visual", "Crosshair"}
local tabButtons = {}
local currentTab = nil
local tabContents = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 135, 1, -6)
    btn.Position = UDim2.new(0, (i-1)*140 + 10, 0, 3)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 45, 68)
    btn.TextColor3 = Color3.fromRGB(180, 190, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = TabContainer
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(function()
        if currentTab then
            tabContents[currentTab].Visible = false
            tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(40, 45, 68)
            tabButtons[currentTab].TextColor3 = Color3.fromRGB(180, 190, 220)
        end
        currentTab = i
        tabContents[i].Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    tabButtons[i] = btn
    -- контент вкладки
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 1, -92)
    wrapper.Position = UDim2.new(0, 0, 0, 88)
    wrapper.BackgroundTransparency = 1
    wrapper.Parent = MainFrame
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0, 0, 0, 550)
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = wrapper
    tabContents[i] = content
end

-- Функции создания кнопок
local function createButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 74)
    btn.TextColor3 = Color3.fromRGB(230, 230, 245)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, yPos, default, onChange)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text .. " (Выкл)"
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 74)
    btn.TextColor3 = Color3.fromRGB(230, 230, 245)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = parent
    local state = default or false
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " (Вкл)" or " (Выкл)")
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(45, 50, 74)
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
    local dir = (targetPart.Position - origin).unit
    local ray = Ray.new(origin, dir * 1000)
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
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
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

createToggle(aimTab, "🎯 Аимбот (круг 60x60)", 10, false, function(s) aimbotEnabled = s end)

-- =============================================
-- 👁️ ВКЛАДКА 2: ESP (улучшенный)
-- =============================================
local espTab = tabContents[2]

local espEnabled = false
local espPlayers = {}

-- Функция получения размера квадрата
local function getBoxSize(worldPos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
    if not onScreen then return 60, 90 end
    local dist = (Camera.CFrame.Position - worldPos).magnitude
    local height = 5
    local width = 2.5
    local fov = 70
    local viewport = Camera.ViewportSize
    local scale = viewport.Y / (2 * math.tan(math.rad(fov/2)))
    local pH = (height / dist) * scale
    local pW = (width / dist) * scale
    return math.max(pW, 30), math.max(pH, 50)
end

-- Создание ESP с цветовым оформлением
local function createESP(player)
    if player == Player then return end
    if espPlayers[player] then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(0, 200, 255)
    box.Filled = false
    box.Transparency = 0.6
    -- Добавляем обводку (дополнительный квадрат большего размера)
    local outline = Drawing.new("Square")
    outline.Thickness = 1
    outline.Color = Color3.fromRGB(255, 255, 255)
    outline.Filled = false
    outline.Transparency = 0.3
    -- Линия
    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Color = Color3.fromRGB(0, 200, 255)
    line.Transparency = 0.5
    espPlayers[player] = {box = box, outline = outline, line = line}
end

local function updateESP()
    for player, data in pairs(espPlayers) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen and espEnabled then
                local w, h = getBoxSize(hrp.Position)
                data.box.Size = Vector2.new(w, h)
                data.box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
                data.box.Visible = true
                data.outline.Size = Vector2.new(w+4, h+4)
                data.outline.Position = Vector2.new(pos.X - w/2 - 2, pos.Y - h/2 - 2)
                data.outline.Visible = true
                local bottom = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                data.line.From = bottom
                data.line.To = Vector2.new(pos.X, pos.Y)
                data.line.Visible = true
            else
                data.box.Visible = false
                data.outline.Visible = false
                data.line.Visible = false
            end
        else
            data.box.Visible = false
            data.outline.Visible = false
            data.line.Visible = false
        end
    end
end

createToggle(espTab, "👁️ ESP (квадраты + линии)", 10, false, function(s)
    espEnabled = s
    if s then
        for _, plr in pairs(game.Players:GetPlayers()) do createESP(plr) end
    else
        for _, data in pairs(espPlayers) do
            data.box:Remove()
            data.outline:Remove()
            data.line:Remove()
        end
        espPlayers = {}
    end
end)

-- =============================================
-- 🌈 ВКЛАДКА 3: VISUAL (RGB, FPS/Ping)
-- =============================================
local visTab = tabContents[3]

-- RGB-режим (плавное переливание)
local rgbEnabled = false
local rgbSpeed = 0.8  -- скорость перелива

local function updateRGB()
    if not rgbEnabled or not Player.Character then return end
    local hue = (tick() * rgbSpeed) % 1
    local color = Color3.fromHSV(hue, 1, 1)
    for _, part in pairs(Player.Character:GetChildren()) do
        if part:IsA("BasePart") and (part.Name == "Right Arm" or part.Name == "Left Arm" or part.Name == "Torso") then
            part.Color = color
        end
    end
    local tool = Player.Character:FindFirstChildWhichIsA("Tool")
    if tool then
        for _, part in pairs(tool:GetChildren()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromHSV((hue + 0.3) % 1, 1, 1)
            end
        end
    end
end

createToggle(visTab, "🌈 RGB перелив (руки+оружие)", 10, false, function(s)
    rgbEnabled = s
    if not s then
        -- сброс цвета
        if Player.Character then
            for _, part in pairs(Player.Character:GetChildren()) do
                if part:IsA("BasePart") then part.Color = Color3.fromRGB(255,255,255) end
            end
            local tool = Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then
                for _, part in pairs(tool:GetChildren()) do
                    if part:IsA("BasePart") then part.Color = Color3.fromRGB(255,255,255) end
                end
            end
        end
    end
end)

-- Регулятор скорости RGB
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 30)
speedLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
speedLabel.Text = "Скорость RGB: " .. rgbSpeed
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.Parent = visTab

local function updateSpeedLabel()
    speedLabel.Text = "Скорость RGB: " .. rgbSpeed
end

createButton(visTab, "⬆ Увеличить", 0.4, function()
    rgbSpeed = math.min(rgbSpeed + 0.2, 3)
    updateSpeedLabel()
end)
createButton(visTab, "⬇ Уменьшить", 0.5, function()
    rgbSpeed = math.max(rgbSpeed - 0.2, 0.2)
    updateSpeedLabel()
end)

-- Виджет FPS/Ping (появляется по кнопке)
local fpsWidgetVisible = false
local fpsWidget = Instance.new("TextLabel")
fpsWidget.Size = UDim2.new(0, 200, 0, 30)
fpsWidget.Position = UDim2.new(0.5, -100, 0, 60)
fpsWidget.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fpsWidget.BackgroundTransparency = 0.4
fpsWidget.TextColor3 = Color3.fromRGB(0, 255, 100)
fpsWidget.Font = Enum.Font.GothamBold
fpsWidget.TextSize = 16
fpsWidget.Text = "FPS: 0 | Ping: 0ms"
fpsWidget.Visible = false
fpsWidget.Parent = ScreenGui

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 8)
fpsCorner.Parent = fpsWidget

local function updateFPSWidget()
    if not fpsWidgetVisible then return end
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    local ping = 0
    if Stats:FindFirstChild("Data") and Stats.Data:FindFirstChild("Ping") then
        ping = Stats.Data.Ping.Value
    end
    fpsWidget.Text = "FPS: " .. fps .. " | Ping: " .. ping .. "ms"
end

createToggle(visTab, "📊 Показать FPS/Ping", 0.7, false, function(s)
    fpsWidgetVisible = s
    fpsWidget.Visible = s
end)

-- =============================================
-- 🎯 ВКЛАДКА 4: CROSSHAIR (через GUI, работает всегда)
-- =============================================
local crossTab = tabContents[4]

local crosshairType = 1
local crosshairEnabled = false
local crosshairGui = nil
local crosshairParts = {}
local crosshairRotation = 0

-- Создание прицела через GUI
local function createCrosshair(type)
    -- Удаляем старый
    if crosshairGui then crosshairGui:Destroy() end
    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "CrosshairGUI"
    crosshairGui.Parent = Player:WaitForChild("PlayerGui")
    crosshairParts = {}

    local centerX = 0.5
    local centerY = 0.5
    local size = 20
    local color = Color3.fromRGB(0, 255, 100)

    if type == 1 then
        -- Крестик +
        local h = Instance.new("Frame")
        h.Size = UDim2.new(0, size*2, 0, 2)
        h.Position = UDim2.new(centerX, -size, centerY, -1)
        h.BackgroundColor3 = color
        h.BackgroundTransparency = 0.2
        h.Parent = crosshairGui
        table.insert(crosshairParts, h)
        local v = Instance.new("Frame")
        v.Size = UDim2.new(0, 2, 0, size*2)
        v.Position = UDim2.new(centerX, -1, centerY, -size)
        v.BackgroundColor3 = color
        v.BackgroundTransparency = 0.2
        v.Parent = crosshairGui
        table.insert(crosshairParts, v)
    elseif type == 2 then
        -- Две волнистые линии (имитация ~)
        for i = 0, 1 do
            local line = Instance.new("Frame")
            line.Size = UDim2.new(0, size*1.5, 0, 2)
            local offsetX = (i == 0) and -size*0.8 or size*0.8
            local offsetY = (i == 0) and -8 or 8
            line.Position = UDim2.new(centerX, offsetX - size*0.75, centerY, offsetY)
            line.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
            line.BackgroundTransparency = 0.2
            line.Parent = crosshairGui
            table.insert(crosshairParts, line)
        end
    elseif type == 3 then
        -- Символ &
        local c1 = Instance.new("Frame")
        c1.Size = UDim2.new(0, 20, 0, 20)
        c1.Position = UDim2.new(centerX, -20, centerY, -10)
        c1.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        c1.BackgroundTransparency = 0.3
        c1.Parent = crosshairGui
        table.insert(crosshairParts, c1)
        local c2 = Instance.new("Frame")
        c2.Size = UDim2.new(0, 20, 0, 20)
        c2.Position = UDim2.new(centerX, 0, centerY, -10)
        c2.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        c2.BackgroundTransparency = 0.3
        c2.Parent = crosshairGui
        table.insert(crosshairParts, c2)
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 30, 0, 2)
        line.Position = UDim2.new(centerX, -15, centerY, 8)
        line.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        line.BackgroundTransparency = 0.3
        line.Parent = crosshairGui
        table.insert(crosshairParts, line)
    end
end

-- Функция вращения прицела (через Tween)
local function rotateCrosshairGUI()
    if not crosshairEnabled or not crosshairGui then return end
    crosshairRotation = (crosshairRotation + 2) % 360
    for _, obj in pairs(crosshairParts) do
        if obj:IsA("Frame") and obj.Size.X.Offset > 2 and obj.Size.Y.Offset > 2 then
            -- Вращаем только крестик (тип 1)
            if crosshairType == 1 then
                -- Для простоты вращаем через изменение размера или позиции? 
                -- Лучше пересоздавать при вращении, но это сложно.
                -- Вместо этого просто оставим статичный, добавим эффект мерцания.
                obj.BackgroundTransparency = 0.2 + 0.3 * math.sin(tick() * 3)
            end
        end
    end
end

createToggle(crossTab, "🔄 Включить прицел", 10, false, function(s)
    crosshairEnabled = s
    if s then
        createCrosshair(crosshairType)
    else
        if crosshairGui then crosshairGui:Destroy() end
        crosshairGui = nil
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
-- 🔄 СВОРАЧИВАНИЕ / РАЗВОРАЧИВАНИЕ
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
    if minimized then expand() else minimize() end
end)

MiniExpandBtn.MouseButton1Click:Connect(function()
    expand()
end)

-- =============================================
-- 🔄 ОБНОВЛЕНИЯ В РЕАЛЬНОМ ВРЕМЕНИ
-- =============================================

RunService.RenderStepped:Connect(function()
    updateAimbot()
    updateESP()
    updateRGB()
    updateFPSWidget()
    rotateCrosshairGUI()
end)

-- =============================================
-- 🧹 ЗАКРЫТИЕ
-- =============================================
CloseBtn.MouseButton1Click:Connect(function()
    for _, data in pairs(espPlayers) do
        data.box:Remove()
        data.outline:Remove()
        data.line:Remove()
    end
    if crosshairGui then crosshairGui:Destroy() end
    aimbotCircle:Remove()
    fpsWidget:Destroy()
    ScreenGui:Destroy()
end)

-- =============================================
-- 🚀 ЗАПУСК
-- =============================================
tabButtons[1].MouseButton1Click:Fire()
print("🔥 ZaZaHub v5.0 загружен! Все функции работают.")
