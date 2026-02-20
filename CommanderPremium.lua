--[[
    ⚡ КОМАНДИР ХАБ XENO EDITION ⚡
    Версия: 6.0
    Статус: ОПТИМИЗИРОВАН ПОД XENO
--]]

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== ПЕРЕМЕННЫЕ ==========
local REQUIRED_KEY = "9866"
local IS_AUTHORIZED = false
local GUI = nil
local IconButton = nil
local MainFrame = nil

-- ========== КРАСИВАЯ ЗАСТАВКА ==========
local KeyGUI = Instance.new("ScreenGui")
KeyGUI.Name = "CommanderKeySystem"
KeyGUI.Parent = game.CoreGui
KeyGUI.ResetOnSpawn = false
KeyGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGUI.DisplayOrder = 999

-- Затемненный фон
local BlackBG = Instance.new("Frame")
BlackBG.Parent = KeyGUI
BlackBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackBG.BackgroundTransparency = 0.5
BlackBG.Size = UDim2.new(1, 0, 1, 0)
BlackBG.Active = true

-- Окно ключа
local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = KeyGUI
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
KeyFrame.Size = UDim2.new(0, 400, 0, 300)
KeyFrame.Active = true
KeyFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = KeyFrame

-- Неоновая обводка
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(255, 50, 50)
UIStroke.Transparency = 0.3
UIStroke.Parent = KeyFrame

-- Заголовок
local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyTitle.Size = UDim2.new(1, 0, 0, 60)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "⚡ ПРЕМИУМ ДОСТУП ⚡"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 24

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = KeyTitle

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 255))
})
TitleGradient.Parent = KeyTitle

-- Инструкция
local KeyInstruction = Instance.new("TextLabel")
KeyInstruction.Parent = KeyFrame
KeyInstruction.BackgroundTransparency = 1
KeyInstruction.Position = UDim2.new(0, 0, 0, 80)
KeyInstruction.Size = UDim2.new(1, 0, 0, 40)
KeyInstruction.Font = Enum.Font.Gotham
KeyInstruction.Text = "ВВЕДИ КЛЮЧ ДОСТУПА"
KeyInstruction.TextColor3 = Color3.fromRGB(180, 180, 180)
KeyInstruction.TextSize = 16

-- Поле ввода
local KeyBox = Instance.new("TextBox")
KeyBox.Parent = KeyFrame
KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyBox.Position = UDim2.new(0.1, 0, 0, 140)
KeyBox.Size = UDim2.new(0.8, 0, 0, 50)
KeyBox.Font = Enum.Font.Gotham
KeyBox.PlaceholderText = "****"
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 24
KeyBox.ClearTextOnFocus = false

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 10)
BoxCorner.Parent = KeyBox

-- Кнопка
local KeyButton = Instance.new("TextButton")
KeyButton.Parent = KeyFrame
KeyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
KeyButton.Position = UDim2.new(0.25, 0, 0, 210)
KeyButton.Size = UDim2.new(0.5, 0, 0, 50)
KeyButton.Font = Enum.Font.GothamBold
KeyButton.Text = "АКТИВИРОВАТЬ"
KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyButton.TextSize = 18

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = KeyButton

-- Ошибка
local KeyError = Instance.new("TextLabel")
KeyError.Parent = KeyFrame
KeyError.BackgroundTransparency = 1
KeyError.Position = UDim2.new(0, 0, 0, 270)
KeyError.Size = UDim2.new(1, 0, 0, 20)
KeyError.Font = Enum.Font.Gotham
KeyError.Text = ""
KeyError.TextColor3 = Color3.fromRGB(255, 50, 50)
KeyError.TextSize = 14

-- ========== ПРОВЕРКА КЛЮЧА ==========
KeyButton.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text:gsub("%s+", "")
    
    if enteredKey == REQUIRED_KEY then
        IS_AUTHORIZED = true
        KeyButton.Text = "✓ УСПЕХ!"
        KeyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        KeyError.Text = ""
        
        -- Анимация закрытия
        TweenService:Create(KeyFrame, TweenInfo.new(0.5), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(BlackBG, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        
        wait(0.5)
        KeyGUI:Destroy()
        wait(0.2)
        createMainGUI()
    else
        KeyError.Text = "❌ НЕВЕРНЫЙ КЛЮЧ!"
        KeyBox.Text = ""
        TweenService:Create(KeyBox, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
        wait(0.1)
        TweenService:Create(KeyBox, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
    end
end)

KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then KeyButton.MouseButton1Click:Wait() end
end) -- ========== СОЗДАНИЕ ГЛАВНОГО ИНТЕРФЕЙСА ==========
function createMainGUI()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenInfo2 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    GUI = Instance.new("ScreenGui")
    GUI.Name = "CommanderPremium"
    GUI.Parent = game.CoreGui
    GUI.ResetOnSpawn = false
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.DisplayOrder = 999
    
    -- ========== НОВАЯ КРУТАЯ ИКОНКА С ПУЛЬСАЦИЕЙ ==========
    IconButton = Instance.new("ImageButton")
    IconButton.Parent = GUI
    IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    IconButton.BackgroundTransparency = 0.2
    IconButton.Position = UDim2.new(0.02, 0, 0.5, -30)
    IconButton.Size = UDim2.new(0, 65, 0, 65) -- Чуть больше
    IconButton.Image = "rbxassetid://3926305904" -- Красный бриллиант
    IconButton.ImageColor3 = Color3.fromRGB(255, 30, 30)
    IconButton.ScaleType = Enum.ScaleType.Fit
    IconButton.Draggable = true
    IconButton.Active = true
    IconButton.ZIndex = 999
    
    -- Сглаживание
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 25)
    IconCorner.Parent = IconButton
    
    -- Неоновая обводка для иконки
    local IconStroke = Instance.new("UIStroke")
    IconStroke.Thickness = 3
    IconStroke.Color = Color3.fromRGB(255, 0, 0)
    IconStroke.Transparency = 0.3
    IconStroke.Parent = IconButton
    
    -- Градиент для иконки
    local IconGradient = Instance.new("UIGradient")
    IconGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100))
    })
    IconGradient.Parent = IconButton
    
    -- Эффект пульсации
    spawn(function()
        while GUI and GUI.Parent do
            for i = 1, 10 do
                IconButton.Size = UDim2.new(0, 65 + i, 0, 65 + i)
                IconStroke.Transparency = 0.3 - (i * 0.02)
                wait(0.02)
            end
            for i = 10, 1, -1 do
                IconButton.Size = UDim2.new(0, 65 + i, 0, 65 + i)
                IconStroke.Transparency = 0.3 - (i * 0.02)
                wait(0.02)
            end
            wait(1)
        end
    end)
    
    -- ========== ТРОЙНАЯ СИСТЕМА КЛИКА ==========
    -- Способ 1: MouseButton1Click (стандарт)
    IconButton.MouseButton1Click:Connect(function()
        if MainFrame then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    -- Способ 2: Activated (универсальный)
    IconButton.Activated:Connect(function()
        if MainFrame then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    -- Способ 3: InputBegan (для Xeno)
    IconButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            if MainFrame then
                MainFrame.Visible = not MainFrame.Visible
            end
        end
    end)
    
    -- Защита от сброса (если Xeno перезагружает GUI)
    spawn(function()
        while GUI and GUI.Parent do
            wait(2)
            if IconButton and not IconButton:FindFirstChildOfClass("UICorner") then
                -- Если иконка потеряла свойства, восстанавливаем
                if not IconButton:FindFirstChildOfClass("UICorner") then
                    local newCorner = Instance.new("UICorner")
                    newCorner.CornerRadius = UDim.new(0, 25)
                    newCorner.Parent = IconButton
                end
            end
        end
    end)
    
    -- ========== ГЛАВНОЕ ОКНО ==========
    MainFrame = Instance.new("Frame")
    MainFrame.Parent = GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 600, 0, 500)
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 2
    MainStroke.Color = Color3.fromRGB(255, 30, 30)
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame
    
    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    })
    MainGradient.Parent = MainFrame
    
    -- ========== ЗАГОЛОВОК ==========
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
    TitleText.Text = "⚡ КОМАНДИР ХАБ XENO ⚡"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 20
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 30, 255))
    })
    TitleGradient.Parent = TitleText
    
    -- Кнопки
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
    MinimizeBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)     -- ========== ВКЛАДКИ ==========
    local TabFrame = Instance.new("Frame")
    TabFrame.Parent = MainFrame
    TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TabFrame.Position = UDim2.new(0, 0, 0, 50)
    TabFrame.Size = UDim2.new(1, 0, 1, -50)
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Parent = TabFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 10)
    TabContainer.Size = UDim2.new(0, 180, 1, -20)
    
    local TabHolder = Instance.new("Frame")
    TabHolder.Parent = TabFrame
    TabHolder.BackgroundTransparency = 1
    TabHolder.Position = UDim2.new(0, 200, 0, 10)
    TabHolder.Size = UDim2.new(1, -210, 1, -20)
    TabHolder.ClipsDescendants = true
    
    -- ТАБЫ
    local tabs = {"💢 ФАРМ", "🌀 ТЕЛЕПОРТ", "⚙️ РАЗНОЕ", "🔧 НАСТРОЙКИ"}
    local tabButtons = {}
    local tabContents = {}
    
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = TabContainer
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        btn.BackgroundTransparency = 0.3
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * 55)
        btn.Font = Enum.Font.GothamBold
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 16
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 12)
        btnCorner.Parent = btn
        
        local container = Instance.new("ScrollingFrame")
        container.Parent = TabHolder
        container.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        container.BackgroundTransparency = 0.2
        container.Size = UDim2.new(1, 0, 1, 0)
        container.Visible = (i == 1)
        container.CanvasSize = UDim2.new(0, 0, 0, 0)
        container.ScrollBarThickness = 6
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 15)
        containerCorner.Parent = container
        
        tabButtons[i] = btn
        tabContents[i] = container
        
        btn.MouseButton1Click:Connect(function()
            for j = 1, #tabContents do
                tabContents[j].Visible = (j == i)
                TweenService:Create(tabButtons[j], TweenInfo.new(0.3), {
                    BackgroundColor3 = (j == i) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(30, 30, 35)
                }):Play()
            end
        end)
    end
    
    -- ========== НАСТРОЙКИ ==========
    local settings = {
        AutoFarm = false,
        AutoFruit = false,
        ESP = false,
        SpeedHack = false,
        NoClip = false,
        GodMode = false,
        SpeedValue = 16,
        FarmRadius = 100
    }
    
    -- ========== ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ ==========
    function createToggle(parent, text, setting)
        local yOffset = (#parent:GetChildren() * 45) + 10
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        frame.Size = UDim2.new(0.9, 0, 0, 35)
        frame.Position = UDim2.new(0.05, 0, 0, yOffset)
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local toggle = Instance.new("TextButton")
        toggle.Parent = frame
        toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        toggle.Size = UDim2.new(0, 50, 0, 25)
        toggle.Position = UDim2.new(1, -60, 0.5, -12.5)
        toggle.Font = Enum.Font.GothamBold
        toggle.Text = "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 12
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggle
        
        toggle.MouseButton1Click:Connect(function()
            settings[setting] = not settings[setting]
            toggle.Text = settings[setting] and "ON" or "OFF"
            toggle.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        end)
        
        parent.CanvasSize = UDim2.new(0, 0, 0, yOffset + 45)
        return frame
    end
    
    function createButton(parent, text, callback)
        local yOffset = (#parent:GetChildren() * 45) + 10
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, 0, yOffset)
        btn.Font = Enum.Font.Gotham
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
        
        parent.CanvasSize = UDim2.new(0, 0, 0, yOffset + 45)
        return btn
    end
    
    function createSlider(parent, text, min, max, setting)
        local yOffset = (#parent:GetChildren() * 55) + 10
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        frame.Size = UDim2.new(0.9, 0, 0, 45)
        frame.Position = UDim2.new(0.05, 0, 0, yOffset)
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -20, 0.4, 0)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Font = Enum.Font.Gotham
        label.Text = text .. ": " .. settings[setting]
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 12
        
        parent.CanvasSize = UDim2.new(0, 0, 0, yOffset + 55)
        return frame
    end     -- ========== НАПОЛНЕНИЕ ТАБОВ ==========
    local farmContent = tabContents[1]
    createToggle(farmContent, "🤖 Автофарм мобов", "AutoFarm")
    createToggle(farmContent, "🍎 Автосбор фруктов", "AutoFruit")
    createToggle(farmContent, "👁️ ESP (видеть врагов)", "ESP")
    
    local teleportContent = tabContents[2]
    createButton(teleportContent, "🏝️ Первое море", function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(100, 50, 100)
        end
    end)
    createButton(teleportContent, "🏝️ Второе море", function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(1000, 50, 1000)
        end
    end)
    createButton(teleportContent, "🏝️ Третье море", function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(2000, 50, 2000)
        end
    end)
    
    local miscContent = tabContents[3]
    createToggle(miscContent, "⚡ Ускорение", "SpeedHack")
    createToggle(miscContent, "🚪 No Clip", "NoClip")
    createToggle(miscContent, "🛡️ God Mode", "GodMode")
    
    local settingsContent = tabContents[4]
    local infoFrame = Instance.new("Frame")
    infoFrame.Parent = settingsContent
    infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    infoFrame.Size = UDim2.new(0.9, 0, 0, 100)
    infoFrame.Position = UDim2.new(0.05, 0, 0, 10)
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 15)
    infoCorner.Parent = infoFrame
    
    local infoText = Instance.new("TextLabel")
    infoText.Parent = infoFrame
    infoText.BackgroundTransparency = 1
    infoText.Size = UDim2.new(1, -20, 1, -20)
    infoText.Position = UDim2.new(0, 10, 0, 10)
    infoText.Font = Enum.Font.Gotham
    infoText.Text = "⚡ КОМАНДИР ХАБ XENO\nВерсия 6.0\n\n🔑 Ключ: 9866\n🎨 Иконка с пульсацией"
    infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoText.TextSize = 14
    infoText.TextWrapped = true
    
    settingsContent.CanvasSize = UDim2.new(0, 0, 0, 150)
    
    -- ========== УПРАВЛЕНИЕ ОКНОМ ==========
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        wait(0.5)
        GUI:Destroy()
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
end

print("✅ XENO EDITION ЗАГРУЖЕН! Ключ: 9866")
