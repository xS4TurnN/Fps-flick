-- =============================================
-- 🔥 ZaZaHub v11.0 (полная версия)
-- - Аимбот 70px с проверкой видимости
-- - ESP коробками (квадраты + линии)
-- - ESP ников (имена над головами)
-- - Dodge (прыжок после выстрела)
-- - RGB перелив рук и оружия
-- - Fly (Хоумлендер)
-- - Fling (толкает игроков)
-- - Красивое горизонтальное меню с кнопкой сворачивания
-- =============================================

local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- =============================================
-- 📦 ГЛАВНОЕ МЕНЮ
-- =============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZaZaHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 400)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Заголовок с кнопками
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.Text = "🔥 ZaZaHub v11.0"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 210, 120)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Кнопка сворачивания
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 1, -6)
MinBtn.Position = UDim2.new(1, -72, 0, 3)
MinBtn.Text = "–"
MinBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 85)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
MinBtn.Parent = TitleBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 1, -6)
CloseBtn.Position = UDim2.new(1, -36, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 85)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Мини-панель (свёрнутое состояние)
local MiniPanel = Instance.new("Frame")
MiniPanel.Size = UDim2.new(0, 200, 0, 36)
MiniPanel.Position = UDim2.new(0.5, -100, 0, 12)
MiniPanel.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
MiniPanel.BackgroundTransparency = 0.2
MiniPanel.BorderSizePixel = 0
MiniPanel.Visible = false
MiniPanel.Parent = ScreenGui
local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 14)
MiniCorner.Parent = MiniPanel

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(0.6, 0, 1, 0)
MiniTitle.Position = UDim2.new(0, 14, 0, 0)
MiniTitle.Text = "🔥 ZaZaHub"
MiniTitle.BackgroundTransparency = 1
MiniTitle.TextColor3 = Color3.fromRGB(255, 210, 120)
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextSize = 17
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = MiniPanel

local MiniExpandBtn = Instance.new("TextButton")
MiniExpandBtn.Size = UDim2.new(0, 28, 1, -6)
MiniExpandBtn.Position = UDim2.new(1, -34, 0, 3)
MiniExpandBtn.Text = "+"
MiniExpandBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 85)
MiniExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniExpandBtn.Font = Enum.Font.GothamBold
MiniExpandBtn.TextSize = 20
MiniExpandBtn.Parent = MiniPanel
local MiniExpandCorner = Instance.new("UICorner")
MiniExpandCorner.CornerRadius = UDim.new(0, 8)
MiniExpandCorner.Parent = MiniExpandBtn

-- Логика сворачивания
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

-- Вкладки (горизонтальные)
local tabs = {"Combat", "Visual", "Trolling"}
local tabButtons = {}
local currentTab = nil
local tabContents = {}

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 36)
TabContainer.Position = UDim2.new(0, 0, 0, 44)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 155, 1, -6)
    btn.Position = UDim2.new(0, (i-1)*165 + 10, 0, 3)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 45, 72)
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
            tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(40, 45, 72)
            tabButtons[currentTab].TextColor3 = Color3.fromRGB(180, 190, 220)
        end
        currentTab = i
        tabContents[i].Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(70, 130, 210)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    tabButtons[i] = btn

    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 1, -88)
    wrapper.Position = UDim2.new(0, 0, 0, 84)
    wrapper.BackgroundTransparency = 1
    wrapper.Parent = MainFrame

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0, 0, 0, 500)
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = wrapper
    tabContents[i] = content
end

-- Функции создания элементов
local function createButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 78)
    btn.TextColor3 = Color3.fromRGB(230, 230, 245)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text .. " (Выкл)"
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 78)
    btn.TextColor3 = Color3.fromRGB(230, 230, 245)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " (Вкл)" or " (Выкл)")
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 190, 60) or Color3.fromRGB(45, 50, 78)
        if callback then callback(state) end
    end)
    return btn
end

-- =============================================
-- 🎯 ВКЛАДКА 1: COMBAT
-- =============================================
local combatTab = tabContents[1]

-- Аимбот (круг 70px, проверка видимости)
local aimbotEnabled = false
local aimbotCircle = Drawing.new("Circle")
aimbotCircle.Radius = 70
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

local function getClosestInFOV()
    local center = Camera.ViewportSize / 2
    local target = nil
    local minDist = math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and canSee(hrp) then
                local pos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).magnitude
                    if dist < 70 and dist < minDist then
                        minDist = dist
                        target = plr
                    end
                end
            end
        end
    end
    return target
end

createToggle(combatTab, "🎯 Аимбот (70px, не через стены)", 10, function(s)
    aimbotEnabled = s
    if not s then aimbotCircle.Visible = false end
end)

-- Dodge (прыжок после выстрела)
local dodgeEnabled = false

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if dodgeEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        UserInputService:SetKeyDown(Enum.KeyCode.Space, true)
        wait(0.05)
        UserInputService:SetKeyDown(Enum.KeyCode.Space, false)
    end
end
UserInputService.InputBegan:Connect(onInputBegan)

createToggle(combatTab, "💨 Dodge (прыжок после выстрела)", 60, function(s)
    dodgeEnabled = s
end)

-- =============================================
-- 👁️ ВКЛАДКА 2: VISUAL
-- =============================================
local visualTab = tabContents[2]

-- ESP ников (стабильный)
local espNameEnabled = false
local espNameObjects = {}
local espNameConnections = {}

local function createNameESP(player)
    if player == Player then return end
    if espNameObjects[player] then return end
    local text = Drawing.new("Text")
    text.Text = player.Name
    text.Size = 18
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Outline = true
    text.OutlineColor = Color3.fromRGB(0, 0, 0)
    text.Center = true
    text.Transparency = 0.8
    text.Visible = false
    espNameObjects[player] = text
    local conn = RunService.RenderStepped:Connect(function()
        if not espNameEnabled then
            text.Visible = false
            return
        end
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                text.Position = Vector2.new(pos.X, pos.Y - 50)
                text.Visible = true
            else
                text.Visible = false
            end
        else
            text.Visible = false
        end
    end)
    table.insert(espNameConnections, conn)
end

local function clearNameESP()
    for _, obj in pairs(espNameObjects) do obj:Remove() end
    espNameObjects = {}
    for _, conn in pairs(espNameConnections) do conn:Disconnect() end
    espNameConnections = {}
end

createToggle(visualTab, "👤 ESP ников", 10, function(s)
    espNameEnabled = s
    if s then
        for _, plr in pairs(Players:GetPlayers()) do createNameESP(plr) end
        local conn = Players.PlayerAdded:Connect(function(plr)
            if espNameEnabled then createNameESP(plr) end
        end)
        table.insert(espNameConnections, conn)
    else
        clearNameESP()
    end
end)

-- ESP коробками
local espBoxEnabled = false
local espBoxObjects = {}
local espBoxConnections = {}

local function createBoxESP(player)
    if player == Player then return end
    if espBoxObjects[player] then return end
    local box = Drawing.new("Square")
    box.Size = Vector2.new(50, 70)
    box.Thickness = 2
    box.Color = Color3.fromRGB(0, 200, 255)
    box.Filled = false
    box.Transparency = 0.6
    box.Visible = false
    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Color = Color3.fromRGB(0, 200, 255)
    line.Transparency = 0.5
    line.Visible = false
    espBoxObjects[player] = {box = box, line = line}
    local conn = RunService.RenderStepped:Connect(function()
        if not espBoxEnabled then
            box.Visible = false
            line.Visible = false
            return
        end
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                box.Position = Vector2.new(pos.X - 25, pos.Y - 35)
                box.Visible = true
                local bottom = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                line.From = bottom
                line.To = Vector2.new(pos.X, pos.Y)
                line.Visible = true
            else
                box.Visible = false
                line.Visible = false
            end
        else
            box.Visible = false
            line.Visible = false
        end
    end)
    table.insert(espBoxConnections, conn)
end

local function clearBoxESP()
    for _, data in pairs(espBoxObjects) do
        data.box:Remove()
        data.line:Remove()
    end
    espBoxObjects = {}
    for _, conn in pairs(espBoxConnections) do conn:Disconnect() end
    espBoxConnections = {}
end

createToggle(visualTab, "📦 ESP коробками", 60, function(s)
    espBoxEnabled = s
    if s then
        for _, plr in pairs(Players:GetPlayers()) do createBoxESP(plr) end
        local conn = Players.PlayerAdded:Connect(function(plr)
            if espBoxEnabled then createBoxESP(plr) end
        end)
        table.insert(espBoxConnections, conn)
    else
        clearBoxESP()
    end
end)

-- RGB подсветка рук и оружия
local rgbEnabled = false
local rgbSpeed = 1.2
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

createToggle(visualTab, "🌈 RGB (руки+оружие)", 110, function(s)
    rgbEnabled = s
    if not s then
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

-- =============================================
-- 🎭 ВКЛАДКА 3: TROLLING
-- =============================================
local trollTab = tabContents[3]

-- Fly (Хоумлендер)
local flyEnabled = false
local flyBodyVelocity = nil

local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        if Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                flyBodyVelocity.Velocity = Vector3.new(0, 30, 0)
                flyBodyVelocity.Parent = hrp
            end
        end
    else
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    end
end

createButton(trollTab, "🦸 Fly (вкл/выкл)", 10, function()
    toggleFly()
end)

-- Fling (толчок игроков)
local flingEnabled = false
local flingRadius = 30
local flingForce = 6000

local function flingPlayers()
    if not Player.Character then return end
    local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if targetHrp then
                local dist = (targetHrp.Position - hrp.Position).magnitude
                if dist < flingRadius then
                    local dir = (targetHrp.Position - hrp.Position).unit
                    local force = Instance.new("BodyVelocity")
                    force.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    force.Velocity = dir * flingForce + Vector3.new(0, 2000, 0)
                    force.Parent = targetHrp
                    game:GetService("Debris"):AddItem(force, 0.5)
                end
            end
        end
    end
end

createToggle(trollTab, "💥 Fling (радиус 30)", 60, function(s)
    flingEnabled = s
    if s then
        -- Запускаем постоянный флинг
        while flingEnabled do
            flingPlayers()
            wait(0.5)
        end
    end
end)

-- =============================================
-- 🔄 ОБНОВЛЕНИЯ
-- =============================================

RunService.RenderStepped:Connect(function()
    -- Аимбот
    if aimbotEnabled then
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        aimbotCircle.Position = center
        aimbotCircle.Visible = true
        local target = getClosestInFOV()
        if target then
            aimbotCircle.Color = Color3.fromRGB(255, 50, 50)
            local targetPos = target.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        else
            aimbotCircle.Color = Color3.fromRGB(0, 255, 100)
        end
    else
        aimbotCircle.Visible = false
    end

    -- RGB
    if rgbEnabled then updateRGB() end
end)

-- Перепривязка GUI после катки
Player.CharacterAdded:Connect(function(char)
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    if espNameEnabled then
        clearNameESP()
        for _, plr in pairs(Players:GetPlayers()) do createNameESP(plr) end
    end
    if espBoxEnabled then
        clearBoxESP()
        for _, plr in pairs(Players:GetPlayers()) do createBoxESP(plr) end
    end
end)

-- =============================================
-- 🧹 ОЧИСТКА ПРИ ЗАКРЫТИИ
-- =============================================
CloseBtn.MouseButton1Click:Connect(function()
    clearNameESP()
    clearBoxESP()
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    aimbotCircle:Remove()
    ScreenGui:Destroy()
end)

-- =============================================
-- 🚀 ЗАПУСК
-- =============================================
tabButtons[1].MouseButton1Click:Fire()
print("🔥 ZaZaHub v11.0 загружен! Все функции работают.")
