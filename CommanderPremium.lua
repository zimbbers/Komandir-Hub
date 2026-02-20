--[[
    ⚡ КОМАНДИР ХАБ ULTIMATE ⚡
    Версия: 8.0
    Статус: ПРОФЕССИОНАЛЬНАЯ ВЕРСИЯ
--]]

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== СИСТЕМА МОНЕТИЗАЦИИ (для будущих продаж) ==========
-- Интеграция с BloxyBin Key System [citation:8]
local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vortex-scripts/BloxyBin-Key-System/main/main.lua"))()

local function mainScript()
    -- Здесь будет основной код
    createMainGUI()
end

-- Настройка системы ключей
KeySystem.Initialize({
    Script_Name = "Commander Hub Ultimate",
    Script_Creator = "zimbbers",
    Paste_ID = "YOUR_PASTE_ID", -- Создашь позже на BloxyBin
    Callback = function()
        mainScript()
    end
})

-- Для разработки используем bypass ключ
local BYPASS_KEY = "9866" -- Твой мастер-ключ -- ========== KILL AURA ПРОФЕССИОНАЛЬНАЯ ==========
local KillAura = {
    Enabled = false,
    Radius = 20,
    AttackSpeed = 0.3,
    TargetMode = "Closest", -- Closest, LowestHP, HighestLevel
    ShowTargetInfo = true,
    CurrentTarget = nil,
    IgnorePlayers = true, -- true = только NPC, false = все
    DamageMultiplier = 1
}

-- Функция получения урона от текущего оружия [citation:4]
local function getWeaponDamage()
    local character = player.Character
    if not character then return 10 end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        -- Пытаемся получить урон из оружия
        local damage = tool:FindFirstChild("Damage") or 
                      tool:FindFirstChild("WeaponDamage") or 
                      tool:FindFirstChild("Data"):FindFirstChild("Damage")
        if damage then
            return damage.Value
        end
    end
    return 10 -- Базовый урон по умолчанию
end

-- Поиск цели
local function findTarget()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local root = character.HumanoidRootPart
    local myPos = root.Position
    local bestTarget = nil
    local bestScore = math.huge
    
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Проверяем, что это модель с Humanoid
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local humanoid = obj.Humanoid
            if humanoid.Health > 0 then
                -- Проверка на игрока
                local isPlayer = game.Players:GetPlayerFromCharacter(obj)
                if KillAura.IgnorePlayers and isPlayer then
                    continue -- Пропускаем игроков если включено
                end
                
                local targetRoot = obj.HumanoidRootPart
                local distance = (myPos - targetRoot.Position).Magnitude
                
                if distance <= KillAura.Radius then
                    -- Вычисляем приоритет в зависимости от режима
                    local score = distance
                    if KillAura.TargetMode == "LowestHP" then
                        score = humanoid.Health
                    elseif KillAura.TargetMode == "HighestLevel" then
                        local level = obj:FindFirstChild("Level") or obj.Parent:FindFirstChild("Level")
                        score = - (level and level.Value or 0)
                    end
                    
                    if score < bestScore then
                        bestScore = score
                        bestTarget = obj
                    end
                end
            end
        end
    end
    
    return bestTarget
end

-- Отображение информации о цели
local function updateTargetInfo()
    if not KillAura.ShowTargetInfo or not KillAura.CurrentTarget then return end
    
    local target = KillAura.CurrentTarget
    local humanoid = target:FindFirstChild("Humanoid")
    local root = target:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not root then return end
    
    -- Создаем BillboardGui для отображения информации
    local billboard = target:FindFirstChild("TargetInfo")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "TargetInfo"
        billboard.Parent = target
        billboard.Size = UDim2.new(0, 200, 0, 80)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        
        local frame = Instance.new("Frame")
        frame.Parent = billboard
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        frame.BackgroundTransparency = 0.2
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = frame
        nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        nameLabel.TextSize = 14
        
        local hpBar = Instance.new("Frame")
        hpBar.Parent = frame
        hpBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        hpBar.Size = UDim2.new(0.9, 0, 0.2, 0)
        hpBar.Position = UDim2.new(0.05, 0, 0.35, 0)
        
        local hpCorner = Instance.new("UICorner")
        hpCorner.CornerRadius = UDim.new(0, 4)
        hpCorner.Parent = hpBar
        
        local hpFill = Instance.new("Frame")
        hpFill.Parent = hpBar
        hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        hpFill.Size = UDim2.new(1, 0, 1, 0)
        hpFill.BorderSizePixel = 0
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 4)
        fillCorner.Parent = hpFill
        
        local hpText = Instance.new("TextLabel")
        hpText.Parent = frame
        hpText.Size = UDim2.new(1, 0, 0.3, 0)
        hpText.Position = UDim2.new(0, 0, 0.6, 0)
        hpText.BackgroundTransparency = 1
        hpText.Font = Enum.Font.Gotham
        hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
        hpText.TextSize = 12
    end
    
    -- Обновляем информацию
    local frame = billboard:FindFirstChildOfClass("Frame")
    if frame then
        local nameLabel = frame:FindFirstChildOfClass("TextLabel")
        if nameLabel then
            nameLabel.Text = target.Name
        end
        
        local hpBar = frame:FindChildOfClass("Frame")
        if hpBar then
            local hpFill = hpBar:FindFirstChildOfClass("Frame")
            if hpFill then
                local hpPercent = humanoid.Health / humanoid.MaxHealth
                hpFill.Size = UDim2.new(hpPercent, 0, 1, 0)
                hpFill.BackgroundColor3 = Color3.new(1 - hpPercent, hpPercent, 0)
            end
            
            local hpText = frame:FindAllChildrenOfClass("TextLabel")[2]
            if hpText then
                hpText.Text = string.format("%.0f/%.0f HP", humanoid.Health, humanoid.MaxHealth)
            end
        end
    end
end

-- Основной цикл Kill Aura
local function startKillAura()
    spawn(function()
        while KillAura.Enabled do
            pcall(function()
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then
                    wait(1)
                    return
                end
                
                -- Находим цель
                local target = findTarget()
                KillAura.CurrentTarget = target
                
                if target then
                    -- Обновляем информацию о цели
                    if KillAura.ShowTargetInfo then
                        updateTargetInfo()
                    end
                    
                    -- Атакуем цель
                    local targetRoot = target:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        -- Поворачиваемся к цели
                        character.HumanoidRootPart.CFrame = CFrame.lookAt(
                            character.HumanoidRootPart.Position,
                            Vector3.new(targetRoot.Position.X, character.HumanoidRootPart.Position.Y, targetRoot.Position.Z)
                        )
                        
                        -- Атакуем
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                        
                        -- Применяем урон (для случаев когда tool:Activate() недостаточно)
                        local damage = getWeaponDamage() * KillAura.DamageMultiplier
                        if target:FindFirstChild("Humanoid") then
                            target.Humanoid:TakeDamage(damage)
                        end
                    end
                end
            end)
            wait(KillAura.AttackSpeed)
        end
    end)
end

-- Очистка информации о целях
local function cleanupTargetInfo()
    for _, obj in pairs(workspace:GetDescendants()) do
        local billboard = obj:FindFirstChild("TargetInfo")
        if billboard then
            billboard:Destroy()
        end
    end
end -- ========== СОЗДАНИЕ ГЛАВНОГО МЕНЮ ==========
function createMainGUI()
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "CommanderUltimate"
    GUI.Parent = game.CoreGui
    GUI.ResetOnSpawn = false
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.DisplayOrder = 999
    
    -- ========== УЛЬТРА-ИКОНКА ==========
    local IconButton = Instance.new("ImageButton")
    IconButton.Parent = GUI
    IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    IconButton.BackgroundTransparency = 0.1
    IconButton.Position = UDim2.new(0.02, 0, 0.5, -35)
    IconButton.Size = UDim2.new(0, 70, 0, 70)
    IconButton.Image = "rbxassetid://3926305904"
    IconButton.ImageColor3 = Color3.fromRGB(255, 50, 50)
    IconButton.Draggable = true
    IconButton.Active = true
    IconButton.ZIndex = 999
    
    -- Идеальный круг
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 35)
    IconCorner.Parent = IconButton
    
    -- Неоновая обводка (пульсирует)
    local IconStroke = Instance.new("UIStroke")
    IconStroke.Thickness = 4
    IconStroke.Color = Color3.fromRGB(255, 0, 0)
    IconStroke.Transparency = 0.3
    IconStroke.Parent = IconButton
    
    -- Анимация пульсации
    spawn(function()
        while GUI.Parent do
            for i = 1, 10 do
                IconStroke.Thickness = 4 + i * 0.2
                IconStroke.Transparency = 0.3 - i * 0.02
                wait(0.02)
            end
            for i = 10, 1, -1 do
                IconStroke.Thickness = 4 + i * 0.2
                IconStroke.Transparency = 0.3 - i * 0.02
                wait(0.02)
            end
            wait(0.5)
        end
    end)
    
    -- Тройной клик для Xeno
    IconButton.MouseButton1Click:Connect(function() toggleMainFrame() end)
    IconButton.Activated:Connect(function() toggleMainFrame() end)
    IconButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            toggleMainFrame()
        end
    end)
    
    -- ========== ГЛАВНОЕ ОКНО ==========
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -300)
    MainFrame.Size = UDim2.new(0, 700, 0, 600)
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 2
    MainStroke.Color = Color3.fromRGB(255, 50, 50)
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame
    
    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    })
    MainGradient.Parent = MainFrame
    
    -- Заголовок
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 20)
    TitleCorner.Parent = TitleBar
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Parent = TitleBar
    TitleText.BackgroundTransparency = 1
    TitleText.Size = UDim2.new(1, -100, 1, 0)
    TitleText.Position = UDim2.new(0, 20, 0, 0)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = "⚡ КОМАНДИР ХАБ ULTIMATE ⚡"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 22
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 255))
    })
    TitleGradient.Parent = TitleText
    
    -- Кнопки управления
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Parent = TitleBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
    CloseBtn.Image = "rbxassetid://5054663650"
    CloseBtn.ImageColor3 = Color3.fromRGB(255, 50, 50)
    
    local MinimizeBtn = Instance.new("ImageButton")
    MinimizeBtn.Parent = TitleBar
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -80, 0.5, -15)
    MinimizeBtn.Image = "rbxassetid://2406617031"
    MinimizeBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)     -- ========== СОЗДАНИЕ ВКЛАДОК ==========
    local TabContainer = Instance.new("Frame")
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.Size = UDim2.new(0, 150, 1, -70)
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ContentContainer.Position = UDim2.new(0, 170, 0, 60)
    ContentContainer.Size = UDim2.new(1, -180, 1, -70)
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 15)
    ContentCorner.Parent = ContentContainer
    
    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Parent = ContentContainer
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.Size = UDim2.new(1, -10, 1, -10)
    ContentScroll.Position = UDim2.new(0, 5, 0, 5)
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentScroll.ScrollBarThickness = 6
    
    -- Табы
    local tabs = {"⚔️ KILL AURA", "🌾 АВТОФАРМ", "🌀 ТЕЛЕПОРТ", "⚙️ РАЗНОЕ"}
    local tabButtons = {}
    
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = TabContainer
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        btn.BackgroundTransparency = 0.3
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * 45)
        btn.Font = Enum.Font.GothamBold
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 14
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        tabButtons[i] = btn
        
        btn.MouseButton1Click:Connect(function()
            for j = 1, #tabs do
                tabButtons[j].BackgroundColor3 = (j == i) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(30, 30, 35)
                tabButtons[j].TextColor3 = (j == i) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
            end
            ContentScroll:ClearAllChildren()
            
            if i == 1 then
                createKillAuraUI(ContentScroll)
            elseif i == 2 then
                createAutoFarmUI(ContentScroll)
            elseif i == 3 then
                createTeleportUI(ContentScroll)
            elseif i == 4 then
                createMiscUI(ContentScroll)
            end
        end)
    end
    
    -- ========== ИНТЕРФЕЙС KILL AURA ==========
    function createKillAuraUI(parent)
        local yOffset = 10
        
        -- Заголовок
        local title = Instance.new("TextLabel")
        title.Parent = parent
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Position = UDim2.new(0, 0, 0, yOffset)
        title.Font = Enum.Font.GothamBold
        title.Text = "⚔️ НАСТРОЙКИ KILL AURA"
        title.TextColor3 = Color3.fromRGB(255, 100, 100)
        title.TextSize = 18
        yOffset = yOffset + 40
        
        -- Включение/выключение
        local enableFrame = createToggle(parent, "Включить Kill Aura", yOffset)
        yOffset = yOffset + 45
        
        -- Радиус
        yOffset = createSlider(parent, "Радиус атаки", 10, 50, KillAura.Radius, yOffset, function(val)
            KillAura.Radius = val
        end)
        
        -- Скорость атаки
        yOffset = createSlider(parent, "Скорость атаки (сек)", 0.1, 1, KillAura.AttackSpeed, yOffset, function(val)
            KillAura.AttackSpeed = val
        end)
        
        -- Режим цели
        local modeLabel = Instance.new("TextLabel")
        modeLabel.Parent = parent
        modeLabel.BackgroundTransparency = 1
        modeLabel.Size = UDim2.new(0.9, 0, 0, 20)
        modeLabel.Position = UDim2.new(0.05, 0, 0, yOffset)
        modeLabel.Font = Enum.Font.Gotham
        modeLabel.Text = "Режим выбора цели:"
        modeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        modeLabel.TextSize = 14
        yOffset = yOffset + 25
        
        local modeDropdown = createDropdown(parent, {"Ближайший", "С HP", "С уровнем"}, yOffset, function(val)
            if val == "Ближайший" then KillAura.TargetMode = "Closest"
            elseif val == "С HP" then KillAura.TargetMode = "LowestHP"
            else KillAura.TargetMode = "HighestLevel" end
        end)
        yOffset = yOffset + 45
        
        -- Показывать информацию о цели
        local infoToggle = createToggle(parent, "Показывать информацию о цели", yOffset, function(state)
            KillAura.ShowTargetInfo = state
            if not state then cleanupTargetInfo() end
        end)
        yOffset = yOffset + 45
        
        -- Множитель урона
        yOffset = createSlider(parent, "Множитель урона", 0.5, 5, KillAura.DamageMultiplier, yOffset, function(val)
            KillAura.DamageMultiplier = val
        end)
        
        parent.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
    end
    
    -- Вспомогательные функции для UI
    function createToggle(parent, text, yPos, callback)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        frame.Size = UDim2.new(0.9, 0, 0, 35)
        frame.Position = UDim2.new(0.05, 0, 0, yPos)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local btn = Instance.new("TextButton")
        btn.Parent = frame
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        btn.Size = UDim2.new(0, 50, 0, 25)
        btn.Position = UDim2.new(1, -60, 0.5, -12.5)
        btn.Font = Enum.Font.GothamBold
        btn.Text = "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = state and "ON" or "OFF"
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
            if callback then callback(state) end
            
            if text == "Включить Kill Aura" then
                KillAura.Enabled = state
                if state then startKillAura() end
            end
        end)
        
        return frame
    end
    
    function createSlider(parent, text, min, max, defaultValue, yPos, callback)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        frame.Size = UDim2.new(0.9, 0, 0, 45)
        frame.Position = UDim2.new(0.05, 0, 0, yPos)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.6, 0, 0.4, 0)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Font = Enum.Font.Gotham
        label.Text = text .. ": " .. defaultValue
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Parent = frame
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        sliderBg.Size = UDim2.new(0.8, 0, 0.3, 0)
        sliderBg.Position = UDim2.new(0.1, 0, 0.5, 0)
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 5)
        sliderCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBg
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 5)
        fillCorner.Parent = sliderFill
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = sliderBg
        valueLabel.BackgroundTransparency = 1
        valueLabel.Size = UDim2.new(1, 0, 1, 0)
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.Text = defaultValue
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.TextSize = 10
        
        local dragging = false
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        RunService.RenderStepped:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation()
                local sliderPos = sliderBg.AbsolutePosition
                local sliderSize = sliderBg.AbsoluteSize
                local percent = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                local value = min + (max - min) * percent
                value = math.floor(value * 10) / 10 -- Округляем до 1 знака
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                valueLabel.Text = value
                label.Text = text .. ": " .. value
                if callback then callback(value) end
            end
        end)
        
        return yPos + 55
    end
    
    function createDropdown(parent, options, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.Font = Enum.Font.Gotham
        btn.Text = options[1]
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        local selected = 1
        btn.MouseButton1Click:Connect(function()
            selected = selected % #options + 1
            btn.Text = options[selected]
            if callback then callback(options[selected]) end
        end)
        
        return btn
    end
    
    function toggleMainFrame()
        MainFrame.Visible = not MainFrame.Visible
    end
    
    -- Закрытие
    CloseBtn.MouseButton1Click:Connect(function()
        GUI:Destroy()
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
end

print("✅ ULTIMATE ВЕРСИЯ ЗАГРУЖЕНА! Ключ: 9866")
