--[[
    ⚡ КОМАНДИР ХАБ ПРЕМИУМ ⚡
    Версия: 3.0 ULTRA
    Статус: 🔒 ТРЕБУЕТСЯ КЛЮЧ
--]]

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ========== СИСТЕМА КЛЮЧЕЙ ==========
local REQUIRED_KEY = "9866"  -- Твой личный ключ
local IS_AUTHORIZED = false

-- Создаем GUI для ввода ключа
local KeyGUI = Instance.new("ScreenGui")
local KeyFrame = Instance.new("Frame")
local KeyTitle = Instance.new("TextLabel")
local KeyBox = Instance.new("TextBox")
local KeyButton = Instance.new("TextButton")
local KeyError = Instance.new("TextLabel")
local UICorner

KeyGUI.Name = "KeySystem"
KeyGUI.Parent = game.CoreGui
KeyGUI.ResetOnSpawn = false
KeyGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Затемненный фон
local BlackBG = Instance.new("Frame")
BlackBG.Parent = KeyGUI
BlackBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackBG.BackgroundTransparency = 0.5
BlackBG.Size = UDim2.new(1, 0, 1, 0)
BlackBG.Active = true

-- Окно ввода ключа
KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = KeyGUI
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
KeyFrame.Size = UDim2.new(0, 400, 0, 300)
KeyFrame.Active = true
KeyFrame.ClipsDescendants = true

UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = KeyFrame

-- Заголовок
KeyTitle.Name = "KeyTitle"
KeyTitle.Parent = KeyFrame
KeyTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
KeyTitle.Size = UDim2.new(1, 0, 0, 60)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "⚡ ПРЕМИУМ ДОСТУП ⚡"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 24

UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = KeyTitle

-- Градиент для заголовка
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))
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
KeyInstruction.TextColor3 = Color3.fromRGB(200, 200, 200)
KeyInstruction.TextSize = 16

-- Поле ввода
KeyBox.Name = "KeyBox"
KeyBox.Parent = KeyFrame
KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyBox.Position = UDim2.new(0.1, 0, 0, 140)
KeyBox.Size = UDim2.new(0.8, 0, 0, 50)
KeyBox.Font = Enum.Font.Gotham
KeyBox.PlaceholderText = "****"
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 24
KeyBox.ClearTextOnFocus = false

UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = KeyBox

-- Кнопка подтверждения
KeyButton.Name = "KeyButton"
KeyButton.Parent = KeyFrame
KeyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
KeyButton.Position = UDim2.new(0.25, 0, 0, 210)
KeyButton.Size = UDim2.new(0.5, 0, 0, 50)
KeyButton.Font = Enum.Font.GothamBold
KeyButton.Text = "АКТИВИРОВАТЬ"
KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyButton.TextSize = 18

UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = KeyButton

-- Сообщение об ошибке
KeyError.Name = "KeyError"
KeyError.Parent = KeyFrame
KeyError.BackgroundTransparency = 1
KeyError.Position = UDim2.new(0, 0, 0, 270)
KeyError.Size = UDim2.new(1, 0, 0, 20)
KeyError.Font = Enum.Font.Gotham
KeyError.Text = ""
KeyError.TextColor3 = Color3.fromRGB(255, 80, 80)
KeyError.TextSize = 14

-- ========== ПРОВЕРКА КЛЮЧА ==========
KeyButton.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text:gsub("%s+", "")  -- Убираем пробелы

    if enteredKey == REQUIRED_KEY then
        IS_AUTHORIZED = true

        -- Анимация успеха
        KeyButton.Text = "✓ УСПЕХ!"
        KeyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        KeyError.Text = ""

        -- Плавное закрытие окна ключа
        TweenService:Create(KeyFrame, TweenInfo.new(0.5), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(BlackBG, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()

        wait(0.5)
        KeyGUI:Destroy()  -- Удаляем окно ввода ключа

        -- Запускаем основное меню
        wait(0.1)
        createMainGUI()

    else
        -- Неправильный ключ
        KeyError.Text = "❌ НЕВЕРНЫЙ КЛЮЧ!"
        KeyBox.Text = ""

        -- Анимация ошибки
        TweenService:Create(KeyBox, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
        wait(0.1)
        TweenService:Create(KeyBox, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
    end
end)

-- Ввод с клавиатуры (Enter)
KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        KeyButton.MouseButton1Click:Wait()
    end
end)

-- ========== ФУНКЦИЯ СОЗДАНИЯ ОСНОВНОГО ИНТЕРФЕЙСА ==========
function createMainGUI()
    -- ========== НАСТРОЙКИ АНИМАЦИЙ ==========
    local tweenInfo = TweenInfo.new(
        0.5,                    -- Длительность
        Enum.EasingStyle.Quad,  -- Стиль
        Enum.EasingDirection.Out -- Направление
    )

    local tweenInfo2 = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )

    -- ========== ГЛАВНЫЙ ИНТЕРФЕЙС ==========
    local GUI = Instance.new("ScreenGui")
    local IconButton = Instance.new("ImageButton")
    local MainFrame = Instance.new("Frame")
    local TitleBar = Instance.new("Frame")
    local TitleText = Instance.new("TextLabel")
    local CloseBtn = Instance.new("ImageButton")
    local MinimizeBtn = Instance.new("ImageButton")
    local TabFrame = Instance.new("Frame")
    local TabContainer = Instance.new("Frame")
    local TabHolder = Instance.new("Folder")

    -- Настройки GUI
    GUI.Name = "CommanderPremium"
    GUI.Parent = game.CoreGui
    GUI.ResetOnSpawn = false
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.DisplayOrder = 999

    -- ========== ИКОНКА НА ЭКРАНЕ ==========
    IconButton.Name = "IconButton"
    IconButton.Parent = GUI
    IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    IconButton.BackgroundTransparency = 0.2
    IconButton.Position = UDim2.new(0.02, 0, 0.5, -30)
    IconButton.Size = UDim2.new(0, 60, 0, 60)
    IconButton.Image = "rbxassetid://3926305904"
    IconButton.ImageColor3 = Color3.fromRGB(255, 100, 100)
    IconButton.ScaleType = Enum.ScaleType.Fit
    IconButton.Draggable = true
    IconButton.Active = true
    IconButton.ZIndex = 999

    -- Сглаживание иконки
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 20)
    IconCorner.Parent = IconButton

    -- Градиент для иконки
    local IconGradient = Instance.new("UIGradient")
    IconGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 150))
    })
    IconGradient.Parent = IconButton

    -- ========== ГЛАВНОЕ ОКНО ==========
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 600, 0, 500)
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true

    -- Сглаживание главного окна
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = MainFrame

    -- Обводка
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 2
    MainStroke.Color = Color3.fromRGB(255, 100, 100)
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame

    -- Градиент фона
    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 35))
    })
    MainGradient.Parent = MainFrame

    -- ========== ЗАГОЛОВОК ==========
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.ZIndex = 10

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 20)
    TitleCorner.Parent = TitleBar

    TitleText.Name = "TitleText"
    TitleText.Parent = TitleBar
    TitleText.BackgroundTransparency = 1
    TitleText.Size = UDim2.new(1, -100, 1, 0)
    TitleText.Position = UDim2.new(0, 20, 0, 0)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = "⚡ КОМАНДИР ХАБ ПРЕМИУМ ⚡"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 20
    TitleText.TextXAlignment = Enum.TextXAlignment.Left

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))
    })
    TitleGradient.Parent = TitleText

    -- ========== КНОПКИ УПРАВЛЕНИЯ ==========
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = TitleBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
    CloseBtn.Image = "rbxassetid://5054663650"
    CloseBtn.ImageColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.ZIndex = 11

    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Parent = TitleBar
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -80, 0.5, -15)
    MinimizeBtn.Image = "rbxassetid://2406617031"
    MinimizeBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.ZIndex = 11

    -- ========== ВКЛАДКИ ==========
    TabFrame.Name = "TabFrame"
    TabFrame.Parent = MainFrame
    TabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabFrame.Position = UDim2.new(0, 0, 0, 50)
    TabFrame.Size = UDim2.new(1, 0, 1, -50)
    TabFrame.ZIndex = 5

    TabContainer.Name = "TabContainer"
    TabContainer.Parent = TabFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 10)
    TabContainer.Size = UDim2.new(0, 180, 1, -20)

    TabHolder.Name = "TabHolder"
    TabHolder.Parent = TabFrame
    TabHolder.BackgroundTransparency = 1
    TabHolder.Position = UDim2.new(0, 200, 0, 10)
    TabHolder.Size = UDim2.new(1, -210, 1, -20)
    TabHolder.ClipsDescendants = true

    -- ========== ТАБЫ ==========
    local tabs = {"💢 ФАРМ", "🌀 ТЕЛЕПОРТ", "⚙️ РАЗНОЕ", "🔧 НАСТРОЙКИ"}
    local tabButtons = {}
    local tabContents = {}

    for i, tabName in ipairs(tabs) do
        -- Кнопка таба
        local btn = Instance.new("TextButton")
        btn.Name = "TabBtn" .. i
        btn.Parent = TabContainer
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.BackgroundTransparency = 0.3
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * 55)
        btn.Font = Enum.Font.GothamBold
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 16
        btn.ZIndex = 6

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 12)
        btnCorner.Parent = btn

        local btnGradient = Instance.new("UIGradient")
        btnGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50))
        })
        btnGradient.Parent = btn

        -- Контейнер для контента таба
        local container = Instance.new("ScrollingFrame")
        container.Name = "Content" .. i
        container.Parent = TabHolder
        container.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        container.BackgroundTransparency = 0.2
        container.Size = UDim2.new(1, 0, 1, 0)
        container.Position = UDim2.new(0, 0, 0, 0)
        container.Visible = (i == 1)
        container.CanvasSize = UDim2.new(0, 0, 0, 0)
        container.ScrollBarThickness = 6
        container.ZIndex = 7

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 15)
        containerCorner.Parent = container

        tabButtons[i] = btn
        tabContents[i] = container

        -- Переключение табов
        btn.MouseButton1Click:Connect(function()
            for j = 1, #tabContents do
                tabContents[j].Visible = (j == i)
                TweenService:Create(tabButtons[j], TweenInfo.new(0.3), {
                    BackgroundColor3 = (j == i) and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(35, 35, 45),
                    TextColor3 = (j == i) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                }):Play()
            end
        end)
    end

    -- ========== ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ ==========
    function createButton(parent, text, callback)
        local yOffset = (#parent:GetChildren() * 50) + 10
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        btn.Size = UDim2.new(0.9, 0, 0, 40)
        btn.Position = UDim2.new(0.05, 0, 0, yOffset)
        btn.Font = Enum.Font.Gotham
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.ZIndex = 8

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Thickness = 1
        btnStroke.Color = Color3.fromRGB(255, 100, 100)
        btnStroke.Transparency = 0.7
        btnStroke.Parent = btn

        btn.MouseButton1Click:Connect(callback)

        -- Анимация
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0.92, 0, 0, 42)}):Play()
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0.9, 0, 0, 40)}):Play()
        end)

        parent.CanvasSize = UDim2.new(0, 0, 0, yOffset + 60)
        return btn
    end

    function createToggle(parent, text, setting)
        local yOffset = (#parent:GetChildren() * 50) + 10
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        frame.Size = UDim2.new(0.9, 0, 0, 40)
        frame.Position = UDim2.new(0.05, 0, 0, yOffset)
        frame.ZIndex = 8

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 10)
        frameCorner.Parent = frame

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 9

        local toggle = Instance.new("ImageButton")
        toggle.Parent = frame
        toggle.BackgroundTransparency = 1
        toggle.Size = UDim2.new(0, 30, 0, 30)
        toggle.Position = UDim2.new(1, -40, 0.5, -15)
        toggle.Image = settings[setting] and "rbxassetid://7024467922" or "rbxassetid://7024467305"
        toggle.ImageColor3 = settings[setting] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)
        toggle.ZIndex = 9

        toggle.MouseButton1Click:Connect(function()
            settings[setting] = not settings[setting]
            toggle.Image = settings[setting] and "rbxassetid://7024467922" or "rbxassetid://7024467305"
            toggle.ImageColor3 = settings[setting] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)

            if setting == "AutoFarm" and settings.AutoFarm then startAutoFarm() end
            if setting == "AutoFruit" and settings.AutoFruit then startAutoFruit() end
            if setting == "ESP" and settings.ESP then startESP() else stopESP() end
            if setting == "SpeedHack" and settings.SpeedHack then startSpeedHack() end
            if setting == "NoClip" and settings.NoClip then startNoClip() end
            if setting == "GodMode" and settings.GodMode then startGodMode() end
        end)

        parent.CanvasSize = UDim2.new(0, 0, 0, yOffset + 60)
        return frame
    end

    function createSlider(parent, text, min, max, setting)
        local yOffset = (#parent:GetChildren() * 60) + 10
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        frame.Size = UDim2.new(0.9, 0, 0, 50)
        frame.Position = UDim2.new(0.05, 0, 0, yOffset)
        frame.ZIndex = 8

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 10)
        frameCorner.Parent = frame

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -20, 0.4, 0)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Font = Enum.Font.Gotham
        label.Text = text .. ": " .. settings[setting]
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 9

        local sliderBg = Instance.new("Frame")
        sliderBg.Parent = frame
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        sliderBg.Size = UDim2.new(0.9, 0, 0.3, 0)
        sliderBg.Position = UDim2.new(0.05, 0, 0.5, 0)
        sliderBg.ZIndex = 9

        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 5)
        sliderCorner.Parent = sliderBg

        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBg
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        sliderFill.Size = UDim2.new((settings[setting] - min) / (max - min), 0, 1, 0)
        sliderFill.ZIndex = 10

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 5)
        fillCorner.Parent = sliderFill

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = sliderBg
        valueLabel.BackgroundTransparency = 1
        valueLabel.Size = UDim2.new(1, 0, 1, 0)
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.Text = settings[setting]
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.TextSize = 10
        valueLabel.ZIndex = 11

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

        game:GetService("RunService").RenderStepped:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation()
                local sliderPos = sliderBg.AbsolutePosition
                local sliderSize = sliderBg.AbsoluteSize
                local percent = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percent)
                settings[setting] = value
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                valueLabel.Text = value
                label.Text = text .. ": " .. value
            end
        end)

        parent.CanvasSize = UDim2.new(0, 0, 0, yOffset + 70)
        return frame
    end

    -- ========== НАСТРОЙКИ ==========
    local settings = {
        AutoFarm = false,
        AutoFruit = false,
        AutoQuest = false,
        AutoBoss = false,
        ESP = false,
        SpeedHack = false,
        NoClip = false,
        GodMode = false,
        SpeedValue = 16,
        FarmRadius = 100
    }

    -- ========== НАПОЛНЕНИЕ ТАБОВ ==========

    -- ФАРМ
    local farmContent = tabContents[1]
    createToggle(farmContent, "Автофарм мобов", "AutoFarm")
    createToggle(farmContent, "Автосбор фруктов", "AutoFruit")
    createToggle(farmContent, "Автоквесты", "AutoQuest")
    createToggle(farmContent, "Фарм боссов", "AutoBoss")
    createSlider(farmContent, "Радиус фарма", 50, 200, "FarmRadius")

    -- ТЕЛЕПОРТ
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

    createButton(teleportContent, "🔄 На спавн", function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end)

    -- РАЗНОЕ
    local miscContent = tabContents[3]
    createToggle(miscContent, "ESP (видеть врагов)", "ESP")
    createToggle(miscContent, "⚡ Ускорение", "SpeedHack")
    createSlider(miscContent, "Скорость", 16, 100, "SpeedValue")
    createToggle(miscContent, "🚪 No Clip", "NoClip")
    createToggle(miscContent, "🛡️ God Mode", "GodMode")

    -- НАСТРОЙКИ
    local settingsContent = tabContents[4]
    local infoFrame = Instance.new("Frame")
    infoFrame.Parent = settingsContent
    infoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    infoFrame.Size = UDim2.new(0.9, 0, 0, 120)
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
    infoText.Text = "⚡ КОМАНДИР ХАБ ПРЕМИУМ\nВерсия 3.0 ULTRA\n\n🔥 Нажми на иконку слева\n🎨 Дизайн: Neon Glass"
    infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoText.TextSize = 14
    infoText.TextWrapped = true

    settingsContent.CanvasSize = UDim2.new(0, 0, 0, 150)

    -- ========== АНИМАЦИЯ ИКОНКИ ==========
    local isOpen = false

    IconButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen

        if isOpen then
            -- Показываем меню с анимацией
            MainFrame.Visible = true
            TweenService:Create(MainFrame, tweenInfo, {
                Size = UDim2.new(0, 600, 0, 500),
                Position = UDim2.new(0.5, -300, 0.5, -250),
                BackgroundTransparency = 0.1
            }):Play()

            -- Анимация иконки
            TweenService:Create(IconButton, tweenInfo2, {
                Size = UDim2.new(0, 70, 0, 70),
                Rotation = 360
            }):Play()

            TweenService:Create(IconButton, tweenInfo, {
                ImageColor3 = Color3.fromRGB(255, 150, 150)
            }):Play()
        else
            -- Прячем меню с анимацией
            TweenService:Create(MainFrame, tweenInfo, {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1
            }):Play()

            TweenService:Create(IconButton, tweenInfo2, {
                Size = UDim2.new(0, 60, 0, 60),
                Rotation = 0
            }):Play()

            TweenService:Create(IconButton, tweenInfo, {
                ImageColor3 = Color3.fromRGB(255, 100, 100)
            }):Play()

            wait(0.5)
            MainFrame.Visible = false
        end
    end)

    -- Закрытие окна
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        wait(0.5)
        GUI:Destroy()
    end)

    -- Свернуть в иконку
    MinimizeBtn.MouseButton1Click:Connect(function()
        isOpen = false
        TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0
