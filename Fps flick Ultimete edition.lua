-- =============================================
-- 🔥 ZaZaHub v8.0 для FPS Flick
-- - ESP ников (стабильные, не пропадают)
-- - Уворот (Dodge) после выстрела
-- - Аимбот с кругом 80px
-- - RGB перелив рук и оружия
-- - Без FPS/Ping (убрано)
-- =============================================

local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- =============================================
-- 📦 ГЛАВНОЕ МЕНЮ (3 вкладки)
-- =============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZaZaHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 420)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "🔥 ZaZaHub v8.0"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 200, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 1, -6)
CloseBtn.Position = UDim2.new(1, -38, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 80)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(espNameObjects) do obj:Remove() end
    aimbotCircle:Remove()
    ScreenGui:Destroy()
end)

-- Вкладки
local tabs = {"Combat", "ESP", "Visual"}
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
    btn.Size = UDim2.new(0, 150, 1, -4)
    btn.Position = UDim2.new(0, (i-1)*155 + 10, 0, 2)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 45, 68)
    btn.TextColor3 = Color3.fromRGB(180, 190, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = TabContainer
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
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
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 1, -88)
    wrapper.Position = UDim2.new(0, 0, 0, 84)
    wrapper.BackgroundTransparency = 1
    wrapper.Parent = MainFrame
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0, 0, 0, 400)
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = wrapper
    tabContents[i] = content
end

local function createToggle(parent, text, yPos, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 34)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text .. " (Выкл)"
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 74)
    btn.TextColor3 = Color3.fromRGB(230, 230, 245)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    local state = default or false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " (Вкл)" or " (Выкл)")
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(45, 50, 74)
        if callback then callback(state) end
    end)
    return btn
end

-- =============================================
-- 🎯 ВКЛАДКА 1: COMBAT (Аимбот + Уворот)
-- =============================================
local combatTab = tabContents[1]

-- Аимбот
local aimbotEnabled = false
local aimbotCircle = Drawing.new("Circle")
aimbotCircle.Radius = 80
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
    local fov = 80
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and canSee(hrp) then
                local pos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).magnitude
                    if dist < fov and dist < minDist then
                        minDist = dist
                        target = plr
                    end
                end
            end
        end
    end
    return target
end

createToggle(combatTab, "🎯 Аимбот (круг 80)", 10, false, function(s)
    aimbotEnabled = s
    if not s then aimbotCircle.Visible = false end
end)

-- Уворот (Dodge)
local dodgeEnabled = false
local lastShotTime = 0
local dodgeCooldown = 0.3

createToggle(combatTab, "💨 Уворот (прыжок после выстрела)", 60, false, function(s)
    dodgeEnabled = s
end)

-- Отслеживаем выстрел (ловим событие через RemoteEvent, если знаешь — можно повесить на FireServer)
-- Но проще сделать через клавишу мыши (левая кнопка) в комбинации с тем, что игрок стреляет.
-- Упростим: будем проверять, нажата ли левая кнопка мыши и был ли выстрел в этот момент.
-- Для FPS Flick можно ловить событие ввода.

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if dodgeEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Имитируем прыжок (пробел)
        UserInputService:SetKeyDown(Enum.KeyCode.Space, true)
        wait(0.05)
        UserInputService:SetKeyDown(Enum.KeyCode.Space, false)
    end
end

UserInputService.InputBegan:Connect(onInputBegan)

-- =============================================
-- 👁️ ВКЛАДКА 2: ESP (имена — стабильные)
-- =============================================
local espTab = tabContents[2]

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
    -- Соединение для обновления
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

local function clearESP()
    for _, obj in pairs(espNameObjects) do
        obj:Remove()
    end
    espNameObjects = {}
    for _, conn in pairs(espNameConnections) do
        conn:Disconnect()
    end
    espNameConnections = {}
end

createToggle(espTab, "👤 ESP ников (имена)", 10, false, function(s)
    espNameEnabled = s
    if s then
        for _, plr in pairs(Players:GetPlayers()) do
            createNameESP(plr)
        end
        -- Подключаем новых игроков
        local conn = Players.PlayerAdded:Connect(function(plr)
            if espNameEnabled then createNameESP(plr) end
        end)
        table.insert(espNameConnections, conn)
    else
        clearESP()
    end
end)

-- =============================================
-- 🌈 ВКЛАДКА 3: VISUAL (RGB + сброс цвета)
-- =============================================
local visTab = tabContents[3]

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

createToggle(visTab, "🌈 RGB перелив (руки+оружие)", 10, false, function(s)
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

-- Кнопка сброса цвета
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.9, 0, 0, 34)
resetBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
resetBtn.Text = "🔄 Сбросить цвета"
resetBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 74)
resetBtn.TextColor3 = Color3.fromRGB(230, 230, 245)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 14
resetBtn.Parent = visTab
local rCorner = Instance.new("UICorner")
rCorner.CornerRadius = UDim.new(0, 8)
rCorner.Parent = resetBtn
resetBtn.MouseButton1Click:Connect(function()
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
    -- RGB
    updateRGB()
end)

-- Не исчезает после катки
Player.CharacterAdded:Connect(function()
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    if espNameEnabled then
        clearESP()
        for _, plr in pairs(Players:GetPlayers()) do createNameESP(plr) end
    end
end)

-- =============================================
-- 🚀 ЗАПУСК
-- =============================================
tabButtons[1].MouseButton1Click:Fire()
print("🔥 ZaZaHub v8.0 загружен! ESP ников стабильный, уворот включён.")
