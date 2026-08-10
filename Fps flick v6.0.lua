-- =============================================
-- 🔥 ZaZaHub v7.0 для FPS Flick
-- Простой, быстрый, рабочий
-- =============================================

local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- =============================================
-- 📦 МЕНЮ (минимальное)
-- =============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZaZaHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 300)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 36)
Title.Text = "🔥 ZaZaHub v7.0"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 200, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local function createToggle(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
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
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " (Вкл)" or " (Выкл)")
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(45, 50, 74)
        callback(state)
    end)
    return btn
end

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -44)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 250)
scroll.ScrollBarThickness = 5
scroll.Parent = MainFrame

-- =============================================
-- 🎯 АИМБОТ (простой и мгновенный)
-- =============================================
local aimbotEnabled = false

local function getClosestPlayer()
    local center = Camera.ViewportSize / 2
    local target = nil
    local minDist = math.huge
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToScreenPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).magnitude
                if dist < 150 and dist < minDist then -- FOV ~150px
                    minDist = dist
                    target = plr
                end
            end
        end
    end
    return target
end

createToggle(scroll, "🎯 Аимбот (мгновенный)", 10, function(s)
    aimbotEnabled = s
end)

-- =============================================
-- 👁️ ESP (простой)
-- =============================================
local espEnabled = false
local espList = {}

local function createESP(player)
    if player == Player then return end
    if espList[player] then return end
    local box = Drawing.new("Square")
    box.Size = Vector2.new(40, 60)
    box.Thickness = 2
    box.Color = Color3.fromRGB(0, 200, 255)
    box.Filled = false
    box.Transparency = 0.6
    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Color = Color3.fromRGB(0, 200, 255)
    line.Transparency = 0.5
    espList[player] = {box = box, line = line}
end

local function updateESP()
    for plr, data in pairs(espList) do
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToScreenPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen and espEnabled then
                data.box.Position = Vector2.new(pos.X - 20, pos.Y - 30)
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

createToggle(scroll, "👁️ ESP (квадраты+линии)", 60, function(s)
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
-- 🌈 RGB
-- =============================================
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

createToggle(scroll, "🌈 RGB перелив", 110, function(s)
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
local fpsWidgetVisible = false
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

local function updateFPSWidget()
    if not fpsWidgetVisible then return end
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    local ping = 0
    if Stats:FindFirstChild("Data") and Stats.Data:FindFirstChild("Ping") then
        ping = Stats.Data.Ping.Value
    end
    fpsWidget.Text = "FPS: " .. fps .. " | Ping: " .. ping .. "ms"
end

createToggle(scroll, "📊 Показать FPS/Ping", 160, function(s)
    fpsWidgetVisible = s
    fpsWidget.Visible = s
end)

-- =============================================
-- 🔄 ОБНОВЛЕНИЯ
-- =============================================
RunService.RenderStepped:Connect(function()
    -- Аимбот (простой, мгновенный)
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end
    updateESP()
    updateRGB()
    updateFPSWidget()
end)

-- =============================================
-- 🚀 ЗАПУСК
-- =============================================
print("🔥 ZaZaHub v7.0 загружен! Аимбот работает мгновенно.")
