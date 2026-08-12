-- =============================================
-- 🔥 ZaZaHub v10.0 Lite
-- Базовое меню с вкладками (гарантированно работает)
-- =============================================

local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZaZaHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 36)
Title.Text = "🔥 ZaZaHub v10.0"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 200, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Контейнер для вкладок
local tabs = {"Combat", "Visual", "Trolling"}
local tabButtons = {}
local currentTab = nil
local tabContents = {}

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*130 + 10, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    btn.TextColor3 = Color3.fromRGB(180, 190, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = TabContainer
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    btn.MouseButton1Click:Connect(function()
        if currentTab then
            tabContents[currentTab].Visible = false
            tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(40, 45, 65)
            tabButtons[currentTab].TextColor3 = Color3.fromRGB(180, 190, 220)
        end
        currentTab = i
        tabContents[i].Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    tabButtons[i] = btn

    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 1, -80)
    wrapper.Position = UDim2.new(0, 0, 0, 75)
    wrapper.BackgroundTransparency = 1
    wrapper.Parent = MainFrame

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0, 0, 0, 200)
    content.ScrollBarThickness = 5
    content.Visible = false
    content.Parent = wrapper
    tabContents[i] = content
end

-- Функции создания кнопок
local function createToggle(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text .. " (Выкл)"
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " (Вкл)" or " (Выкл)")
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(45, 50, 70)
        if callback then callback(state) end
    end)
    return btn
end

-- =============================================
-- ВКЛАДКА 1: COMBAT (Аимбот)
-- =============================================
local combatTab = tabContents[1]

local aimbotEnabled = false
local aimbotCircle = Drawing.new("Circle")
aimbotCircle.Radius = 70
aimbotCircle.Thickness = 2
aimbotCircle.Color = Color3.fromRGB(0, 255, 100)
aimbotCircle.Filled = false
aimbotCircle.Transparency = 0.5
aimbotCircle.Visible = false

local Camera = workspace.CurrentCamera

local function getClosestInFOV()
    local center = Camera.ViewportSize / 2
    local target = nil
    local minDist = math.huge
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
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

createToggle(combatTab, "🎯 Аимбот 70px", 10, function(s)
    aimbotEnabled = s
    if not s then aimbotCircle.Visible = false end
end)

-- =============================================
-- ВКЛАДКА 2: VISUAL (ESP ников)
-- =============================================
local visualTab = tabContents[2]

local espEnabled = false
local espTexts = {}

local function updateESP()
    for player, text in pairs(espTexts) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen and espEnabled then
                text.Position = Vector2.new(pos.X, pos.Y - 40)
                text.Visible = true
            else
                text.Visible = false
            end
        else
            text.Visible = false
        end
    end
end

createToggle(visualTab, "👤 ESP ников", 10, function(s)
    espEnabled = s
    if s then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= Player and not espTexts[plr] then
                local text = Drawing.new("Text")
                text.Text = plr.Name
                text.Size = 18
                text.Color = Color3.fromRGB(255, 255, 255)
                text.Outline = true
                text.OutlineColor = Color3.fromRGB(0, 0, 0)
                text.Center = true
                text.Transparency = 0.8
                text.Visible = false
                espTexts[plr] = text
            end
        end
        game:GetService("RunService").RenderStepped:Connect(function()
            if espEnabled then updateESP() end
        end)
    else
        for _, text in pairs(espTexts) do text:Remove() end
        espTexts = {}
    end
end)

-- =============================================
-- ВКЛАДКА 3: TROLLING (Fly)
-- =============================================
local trollTab = tabContents[3]

local flyEnabled = false
local flyBodyVelocity = nil

createToggle(trollTab, "🦸 Fly (Хоумлендер)", 10, function(s)
    flyEnabled = s
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
end)

-- =============================================
-- 🔄 ОБНОВЛЕНИЕ АИМБОТА
-- =============================================
game:GetService("RunService").RenderStepped:Connect(function()
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

-- =============================================
-- 🚀 ЗАПУСК
-- =============================================
tabButtons[1].MouseButton1Click:Fire()
print("🔥 ZaZaHub v10.0 Lite загружен!")
