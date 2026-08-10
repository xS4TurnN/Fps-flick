-- =============================================
-- 🔥 ZaZaHub ULTIMATE+ для FPS Flick
-- - Круг аимбота 70x70 (радиус 70)
-- - Аимбот только по видимым целям
-- - ESP белый, RGB руки+оружие, FPS/Ping
-- - Меню сворачивается/разворачивается
-- =============================================

local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- Создаём GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZaZaHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- =============================================
-- МЕНЮ (как Rayfield)
-- =============================================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 360)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "🔥 ZaZaHub"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 200, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 1, -4)
MinBtn.Position = UDim2.new(1, -66, 0, 2)
MinBtn.Text = "–"
MinBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 80)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 1, -4)
CloseBtn.Position = UDim2.new(1, -34, 0, 2)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 80)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Мини-панель
local MiniPanel = Instance.new("Frame")
MiniPanel.Size = UDim2.new(0, 160, 0, 36)
MiniPanel.Position = UDim2.new(0.5, -80, 0, 10)
MiniPanel.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MiniPanel.BackgroundTransparency = 0.2
MiniPanel.BorderSizePixel = 0
MiniPanel.Visible = false
MiniPanel.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 12)
MiniCorner.Parent = MiniPanel

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(0.6, 0, 1, 0)
MiniTitle.Position = UDim2.new(0, 10, 0, 0)
MiniTitle.Text = "🔥 ZaZaHub"
MiniTitle.BackgroundTransparency = 1
MiniTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextSize = 16
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = MiniPanel

local MiniExpandBtn = Instance.new("TextButton")
MiniExpandBtn.Size = UDim2.new(0, 28, 1, -4)
MiniExpandBtn.Position = UDim2.new(1, -32, 0, 2)
MiniExpandBtn.Text = "+"
MiniExpandBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 80)
MiniExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniExpandBtn.Font = Enum.Font.GothamBold
MiniExpandBtn.TextSize = 20
MiniExpandBtn.Parent = MiniPanel

local MiniExpandCorner = Instance.new("UICorner")
MiniExpandCorner.CornerRadius = UDim.new(0, 8)
MiniExpandCorner.Parent = MiniExpandBtn

-- Контейнер кнопок
local Scroller = Instance.new("ScrollingFrame")
Scroller.Size = UDim2.new(1, 0, 1, -44)
Scroller.Position = UDim2.new(0, 0, 0, 40)
Scroller.BackgroundTransparency = 1
Scroller.CanvasSize = UDim2.new(0, 0, 0, 400)
Scroller.ScrollBarThickness = 6
Scroller.Parent = MainFrame

local function createToggle(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 34)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text .. " (Выкл)"
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 74)
    btn.TextColor3 = Color3.fromRGB(230, 230, 245)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = Scroller
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " (Вкл)" or " (Выкл)")
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(45, 50, 74)
        callback(state)
    end)
    return btn
end

-- =============================================
-- 🎯 АИМБОТ + КРУГ 70x70
-- =============================================

local aimbotEnabled = false
local aimbotCircle = Drawing.new("Circle")
aimbotCircle.Radius = 70
aimbotCircle.Thickness = 2
aimbotCircle.Color = Color3.fromRGB(0, 255, 100) -- зелёный по умолчанию
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

local function getClosestVisibleInFOV()
    local center = Camera.ViewportSize / 2
    local target = nil
    local minDist = math.huge
    local fovRadius = 70
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and canSee(hrp) then
                local pos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).magnitude
                    if dist < fovRadius and dist < minDist then
                        minDist = dist
                        target = plr
                    end
                end
            end
        end
    end
    return target
end

createToggle("🎯 Аимбот (круг 70)", 10, function(s)
    aimbotEnabled = s
    if not s then
        aimbotCircle.Visible = false
    end
end)

-- =============================================
-- 👁️ ESP (белый)
-- =============================================

local espEnabled = false
local espList = {}

local function createESP(player)
    if player == Player then return end
    if espList[player] then return end
    local box = Drawing.new("Square")
    box.Size = Vector2.new(45, 65)
    box.Thickness = 2
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Filled = false
    box.Transparency = 0.6
    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Color = Color3.fromRGB(255, 255, 255)
    line.Transparency = 0.5
    espList[player] = {box = box, line = line}
end

local function updateESP()
    for plr, data in pairs(espList) do
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToScreenPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen and espEnabled then
                data.box.Position = Vector2.new(pos.X - 22.5, pos.Y - 32.5)
                data.box.Visible = true
                local bottom = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
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

createToggle("👁️ ESP (белые)", 60, function(s)
    espEnabled = s
    if s then
        for _, plr in pairs(game.Players:GetPlayers()) do createESP(plr) end
    else
        for _, data in pairs(espList) do
            data.box:Remove()
            data.line:Remove()
        end
        espList = {}
    end
end)

-- =============================================
-- 🌈 RGB (руки + оружие)
-- =============================================

local rgbEnabled = false
local rgbSpeed = 1.0

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

createToggle("🌈 RGB (руки+оружие)", 110, function(s)
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
-- 📊 FPS/Ping
-- =============================================

local fpsEnabled = false
local fpsWidget = Instance.new("TextLabel")
fpsWidget.Size = UDim2.new(0, 180, 0, 28)
fpsWidget.Position = UDim2.new(0.5, -90, 0, 60)
fpsWidget.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fpsWidget.BackgroundTransparency = 0.4
fpsWidget.TextColor3 = Color3.fromRGB(0, 255, 100)
fpsWidget.Font = Enum.Font.GothamBold
fpsWidget.TextSize = 14
fpsWidget.Text = "FPS: 0 | Ping: 0ms"
fpsWidget.Visible = false
fpsWidget.Parent = ScreenGui

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 8)
fpsCorner.Parent = fpsWidget

local function updateFPS()
    if not fpsEnabled then return end
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    local ping = 0
    if Stats:FindFirstChild("Data") and Stats.Data:FindFirstChild("Ping") then
        ping = Stats.Data.Ping.Value
    end
    fpsWidget.Text = "FPS: " .. fps .. " | Ping: " .. ping .. "ms"
end

createToggle("📊 FPS/Ping", 160, function(s)
    fpsEnabled = s
    fpsWidget.Visible = s
end)

-- =============================================
-- 🔄 СВОРАЧИВАНИЕ
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
-- 🔄 ОБНОВЛЕНИЯ
-- =============================================

RunService.RenderStepped:Connect(function()
    -- Обновление круга
    if aimbotEnabled then
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        aimbotCircle.Position = center
        aimbotCircle.Visible = true
        -- Поиск цели
        local target = getClosestVisibleInFOV()
        if target then
            aimbotCircle.Color = Color3.fromRGB(255, 50, 50) -- красный при цели
            local targetPos = target.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        else
            aimbotCircle.Color = Color3.fromRGB(0, 255, 100) -- зелёный без цели
        end
    else
        aimbotCircle.Visible = false
    end

    updateESP()
    updateRGB()
    updateFPS()
end)

-- Не исчезает после катки
Player.CharacterAdded:Connect(function()
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end)

-- =============================================
-- 🧹 ЗАКРЫТИЕ
-- =============================================
CloseBtn.MouseButton1Click:Connect(function()
    for _, data in pairs(espList) do
        data.box:Remove()
        data.line:Remove()
    end
    aimbotCircle:Remove()
    fpsWidget:Destroy()
    ScreenGui:Destroy()
end)

print("🔥 ZaZaHub ULTIMATE+ загружен! Круг 70x70, аимбот только по видимым.")
