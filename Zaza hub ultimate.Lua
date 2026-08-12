-- =============================================
-- 🔥 ZaZaHub v9.0 для FPS Flick
-- - Combat: Аимбот 70px + Dodge (прыжок после выстрела)
-- - Visual: ESP ников + ESP коробками (стабильные)
-- - Trolling: Fly (как Хоумлендер) + Fling (выкидывание игроков)
-- - Меню горизонтальное, красивое, сворачивается
-- - Меню скрывается во время катки и появляется после
-- =============================================

local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- =============================================
-- 📦 ГЛАВНОЕ МЕНЮ (горизонтальное, красивое)
-- =============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZaZaHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 540, 0, 440)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

-- Тень
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 8, 1, 8)
Shadow.Position = UDim2.new(0, -4, 0, -4)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.BorderSizePixel = 0
Shadow.Parent = MainFrame
local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 20)
ShadowCorner.Parent = Shadow

-- Заголовок с кнопками
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Text = "🔥 ZaZaHub v9.0"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 210, 120)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Кнопка сворачивания
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 34, 1, -8)
MinBtn.Position = UDim2.new(1, -78, 0, 4)
MinBtn.Text = "–"
MinBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 85)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 24
MinBtn.Parent = TitleBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 1, -8)
CloseBtn.Position = UDim2.new(1, -40, 0, 4)
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
MiniPanel.Size = UDim2.new(0, 200, 0, 38)
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
MiniTitle.TextSize = 18
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = MiniPanel

local MiniExpandBtn = Instance.new("TextButton")
MiniExpandBtn.Size = UDim2.new(0, 30, 1, -6)
MiniExpandBtn.Position = UDim2.new(1, -36, 0, 3)
MiniExpandBtn.Text = "+"
MiniExpandBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 85)
MiniExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniExpandBtn.Font = Enum.Font.GothamBold
MiniExpandBtn.TextSize = 22
MiniExpandBtn.Parent = MiniPanel
local MiniExpandCorner = Instance.new("UICorner")
MiniExpandCorner.CornerRadius = UDim.new(0, 8)
MiniExpandCorner.Parent = MiniExpandBtn

-- Логика сворачивания/разворачивания
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

-- Скрываем меню во время катки (когда игрок в игре)
local function onCharacterAdded(character)
    -- Если персонаж появился (катка началась), сворачиваем меню
    if not minimized then
        minimize()
    end
end

local function onCharacterRemoved()
    -- Если персонаж исчез (катка закончилась), разворачиваем
    if minimized then
        expand()
    end
end

Player.CharacterAdded:Connect(onCharacterAdded)
Player.CharacterRemoved:Connect(onCharacterRemoved)

-- Вкладки (горизонтальные)
local tabs = {"Combat", "Visual", "Trolling"}
local tabButtons = {}
local currentTab = nil
local tabContents = {}

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 48)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 1, -6)
    btn.Position = UDim2.new(0, (i-1)*170 + 10, 0, 3)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 45, 72)
    btn.TextColor3 = Color3.fromRGB(180, 190, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 17
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
    wrapper.Size = UDim2.new(1, 0, 1, -96)
    wrapper.Position = UDim2.new(0, 0, 0, 92)
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
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 78)
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

local function createToggle(parent, text, yPos, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text .. " (Выкл)"
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 78)
    btn.TextColor3 = Color3.fromRGB(230, 230, 245)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    local state = default or false
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

-- Аимбот (круг 70px)
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

createToggle(combatTab, "🎯 Аимбот (круг 70)", 10, false, function(s)
    aimbotEnabled = s
    if not s then aimbotCircle.Visible = false end
end)

-- Dodge (прыжок после выстрела)
local dodgeEnabled = false

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if dodgeEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Имитация прыжка
        UserInputService:SetKeyDown(Enum.KeyCode.Space, true)
        wait(0.05)
        UserInputService:SetKeyDown(Enum.KeyCode.Space, false)
    end
end

UserInputService.InputBegan:Connect(onInputBegan)

createToggle(combatTab, "💨 Dodge (прыжок после выстрела)", 60, false, function(s)
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

createToggle(visualTab, "👤 ESP ников", 10, false, function(s)
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

createToggle(visualTab, "📦 ESP коробками", 60, false, function(s)
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

-- =============================================
-- 🌈 ВКЛАДКА 3: TROLLING
-- =============================================
local trollTab = tabContents[3]

-- Fly (как Хоумлендер)
local flyEnabled = false
local flyBodyVelocity = nil

local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        -- Создаём BodyVelocity для управления полётом
        if Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                flyBodyVelocity.Velocity = Vector3.new(0, 20, 0) -- начальный подъём
                flyBodyVelocity.Parent = hrp
                -- Анимация "руки в стороны" как у Хоумлендера
                local anim = Instance.new("Animation")
                -- В реальном проекте нужна анимация, но мы просто поднимем руки через Tween
                -- Упростим: вращение торса
                local torso = Player.Character:FindFirstChild("UpperTorso")
                if torso then
                    TweenService:Create(torso, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {CFrame = torso.CFrame * CFrame.Angles(0, 0, math.rad(-20))}):Play()
                end
            end
        end
        -- Обновление скорости в RenderStepped
        local conn = RunService.RenderStepped:Connect(function()
            if not flyEnabled or not Player.Character then
                if flyBodyVelocity then flyBodyVelocity:Destroy() end
                conn:Disconnect()
                return
            end
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and flyBodyVelocity then
                -- Управление: WASD для движения, пробел вверх, Shift вниз
                local move = Vector3.new(
                    (Input.IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (Input.IsKeyDown(Enum.KeyCode.A) and 1 or 0),
                    (Input.IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (Input.IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0),
                    (Input.IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (Input.IsKeyDown(Enum.KeyCode.W) and 1 or 0)
                )
                local velocity = move * 50
                flyBodyVelocity.Velocity = velocity
            end
        end)
        table.insert(espNameConnections, conn) -- просто сохраним в список для очистки
    else
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        -- Сброс анимации
        local torso = Player.Character and Player.Character:FindFirstChild("UpperTorso")
        if torso then
            TweenService:Create(torso, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {CFrame = torso.CFrame * CFrame.Angles(0, 0, 0)}):Play()
        end
    end
end

createButton(trollTab, "🦸 Fly (как Хоумлендер)", 10, function()
    toggleFly()
end)

-- Fling (выкидывание игроков)
local flingEnabled = false
local flingForce = 5000

createButton(trollTab, "💥 Fling (выкинуть игроков)", 60, function()
    if not Player.Character then return end
    local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if targetHrp then
                local dir = (targetHrp.Position - hrp.Position).unit
                -- Создаём толчок
                local force = Instance.new("BodyVelocity")
                force.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                force.Velocity = dir * flingForce + Vector3.new(0, 2000, 0)
                force.Parent = targetHrp
                game:GetService("Debris"):AddItem(force, 0.5)
            end
        end
    end
    print("💥 Fling activated!")
end)

-- =============================================
-- 🔄 ОБНОВЛЕНИЯ В РЕАЛЬНОМ ВРЕМЕНИ
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
end)

-- Перенос GUI при смене персонажа (чтобы не исчезало)
Player.CharacterAdded:Connect(function(char)
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    -- Если были включены ESP, пересоздать
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
print("🔥 ZaZaHub v9.0 загружен! Меню сворачивается автоматически на катке.")
