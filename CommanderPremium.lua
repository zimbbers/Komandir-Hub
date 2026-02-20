--[[
    ⚡ КОМАНДИР ХАБ ⚡
    Версия: 11.0 FINAL
    Статус: ПОЛНОСТЬЮ РАБОЧАЯ ВЕРСИЯ
--]]

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- ========== ПЕРЕМЕННЫЕ ==========
local REQUIRED_KEY = "9866"
local GUI = nil
local IconButton = nil
local MainFrame = nil

-- ========== НАСТРОЙКИ ==========
local settings = {
    -- Kill Aura
    KillAura = false,
    KillAuraRadius = 20,
    KillAuraSpeed = 0.3,
    KillAuraDamage = 1,
    
    -- Автофарм
    AutoFarm = false,
    AutoFarmRadius = 25,
    AutoFarmSpeed = 0.3,
    
    -- ESP
    ESP = false,
    ESPHealth = true,
    ESPDistance = true,
    ESPName = true,
    
    -- Телепорт
    TeleportSmooth = false,
    
    -- Разное
    SpeedHack = false,
    SpeedValue = 16,
    NoClip = false,
    GodMode = false
}

-- ========== СИСТЕМА КЛЮЧЕЙ ==========
local KeyGUI = Instance.new("ScreenGui")
KeyGUI.Name = "CommanderKey"
KeyGUI.Parent = game.CoreGui
KeyGUI.ResetOnSpawn = false
KeyGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGUI.DisplayOrder = 999

local BlackBG = Instance.new("Frame")
BlackBG.Parent = KeyGUI
BlackBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackBG.BackgroundTransparency = 0.5
BlackBG.Size = UDim2.new(1, 0, 1, 0)
BlackBG.Active = true

local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = KeyGUI
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
KeyFrame.Size = UDim2.new(0, 400, 0, 300)
KeyFrame.Active = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyTitle.Size = UDim2.new(1, 0, 0, 60)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "⚡ КОМАНДИР ХАБ ⚡"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 24

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = KeyTitle

local KeyInstruction = Instance.new("TextLabel")
KeyInstruction.Parent = KeyFrame
KeyInstruction.BackgroundTransparency = 1
KeyInstruction.Position = UDim2.new(0, 0, 0, 80)
KeyInstruction.Size = UDim2.new(1, 0, 0, 40)
KeyInstruction.Font = Enum.Font.Gotham
KeyInstruction.Text = "ВВЕДИ КЛЮЧ ДОСТУПА"
KeyInstruction.TextColor3 = Color3.fromRGB(180, 180, 180)
KeyInstruction.TextSize = 16

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

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 10)
BoxCorner.Parent = KeyBox

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

local KeyError = Instance.new("TextLabel")
KeyError.Parent = KeyFrame
KeyError.BackgroundTransparency = 1
KeyError.Position = UDim2.new(0, 0, 0, 270)
KeyError.Size = UDim2.new(1, 0, 0, 20)
KeyError.Font = Enum.Font.Gotham
KeyError.Text = ""
KeyError.TextColor3 = Color3.fromRGB(255, 50, 50)
KeyError.TextSize = 14

KeyButton.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text:gsub("%s+", "")
    
    if enteredKey == REQUIRED_KEY then
        KeyButton.Text = "✓ УСПЕХ!"
        KeyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        KeyError.Text = ""
        
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
end)

-- ========== ФУНКЦИИ KILL AURA ==========
local function findKillAuraTarget()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local root = char.HumanoidRootPart
    local myPos = root.Position
    local bestTarget = nil
    local bestDist = settings.KillAuraRadius
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local humanoid = obj.Humanoid
            if humanoid and humanoid.Health > 0 then
                local isPlayer = Players:GetPlayerFromCharacter(obj)
                if not isPlayer then
                    local targetRoot = obj.HumanoidRootPart
                    local dist = (myPos - targetRoot.Position).Magnitude
                    
                    if dist <= settings.KillAuraRadius and dist < bestDist then
                        bestDist = dist
                        bestTarget = obj
                    end
                end
            end
        end
    end
    
    return bestTarget
end

local function killAuraLoop()
    spawn(function()
        while settings.KillAura do
            pcall(function()
                local target = findKillAuraTarget()
                local char = player.Character
                
                if target and char and char:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = target:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        char.HumanoidRootPart.CFrame = CFrame.lookAt(
                            char.HumanoidRootPart.Position,
                            Vector3.new(targetRoot.Position.X, char.HumanoidRootPart.Position.Y, targetRoot.Position.Z)
                        )
                        
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                        
                        if target:FindFirstChild("Humanoid") then
                            target.Humanoid:TakeDamage(10 * settings.KillAuraDamage)
                        end
                    end
                end
            end)
            wait(settings.KillAuraSpeed)
        end
    end)
end

-- ========== ФУНКЦИИ АВТОФАРМА ==========
local function findAutoFarmTarget()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local root = char.HumanoidRootPart
    local myPos = root.Position
    local bestTarget = nil
    local bestDist = settings.AutoFarmRadius
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local humanoid = obj.Humanoid
            if humanoid and humanoid.Health > 0 then
                local isPlayer = Players:GetPlayerFromCharacter(obj)
                if not isPlayer then
                    local targetRoot = obj.HumanoidRootPart
                    local dist = (myPos - targetRoot.Position).Magnitude
                    
                    if dist <= settings.AutoFarmRadius and dist < bestDist then
                        bestDist = dist
                        bestTarget = obj
                    end
                end
            end
        end
    end
    
    return bestTarget
end

local function autoFarmLoop()
    spawn(function()
        while settings.AutoFarm do
            pcall(function()
                local target = findAutoFarmTarget()
                local char = player.Character
                
                if target and char and char:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = target:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        char.HumanoidRootPart.CFrame = CFrame.lookAt(
                            char.HumanoidRootPart.Position,
                            Vector3.new(targetRoot.Position.X, char.HumanoidRootPart.Position.Y, targetRoot.Position.Z)
                        )
                        
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                    end
                end
            end)
            wait(settings.AutoFarmSpeed)
        end
    end)
end

-- ========== ФУНКЦИИ ESP ==========
local espObjects = {}

local function updateESP()
    if not settings.ESP then
        for _, obj in pairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
        return
    end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local isPlayer = Players:GetPlayerFromCharacter(obj)
            if not isPlayer and not obj:FindFirstChild("CommanderESP") then
                local humanoid = obj.Humanoid
                local root = obj.HumanoidRootPart
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "CommanderESP"
                billboard.Parent = obj
                billboard.Size = UDim2.new(0, 150, 0, 60)
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
                
                if settings.ESPName then
                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Parent = frame
                    nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
                    nameLabel.Position = UDim2.new(0, 0, 0, 5)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.Text = obj.Name
                    nameLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                    nameLabel.TextSize = 14
                end
                
                if settings.ESPHealth then
                    local healthBar = Instance.new("Frame")
                    healthBar.Parent = frame
                    healthBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    healthBar.Size = UDim2.new(0.9, 0, 0.15, 0)
                    healthBar.Position = UDim2.new(0.05, 0, 0.35, 0)
                    
                    local barCorner = Instance.new("UICorner")
                    barCorner.CornerRadius = UDim.new(0, 4)
                    barCorner.Parent = healthBar
                    
                    local healthFill = Instance.new("Frame")
                    healthFill.Parent = healthBar
                    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    healthFill.Size = UDim2.new(1, 0, 1, 0)
                    
                    local fillCorner = Instance.new("UICorner")
                    fillCorner.CornerRadius = UDim.new(0, 4)
                    fillCorner.Parent = healthFill
                    
                    local healthText = Instance.new("TextLabel")
                    healthText.Parent = frame
                    healthText.Size = UDim2.new(1, 0, 0.2, 0)
                    healthText.Position = UDim2.new(0, 0, 0.55, 0)
                    healthText.BackgroundTransparency = 1
                    healthText.Font = Enum.Font.Gotham
                    healthText.Text = ""
                    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    healthText.TextSize = 10
                    
                    spawn(function()
                        while billboard and billboard.Parent do
                            if humanoid and humanoid.Parent then
                                local hpPercent = humanoid.Health / humanoid.MaxHealth
                                healthFill.Size = UDim2.new(hpPercent, 0, 1, 0)
                                healthFill.BackgroundColor3 = Color3.new(1 - hpPercent, hpPercent, 0)
                                healthText.Text = string.format("%.0f/%.0f", humanoid.Health, humanoid.MaxHealth)
                            end
                            wait(0.1)
                        end
                    end)
                end
                
                if settings.ESPDistance then
                    local distLabel = Instance.new("TextLabel")
                    distLabel.Parent = frame
                    distLabel.Size = UDim2.new(1, 0, 0.2, 0)
                    distLabel.Position = UDim2.new(0, 0, 0.75, 0)
                    distLabel.BackgroundTransparency = 1
                    distLabel.Font = Enum.Font.Gotham
                    distLabel.Text = ""
                    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    distLabel.TextSize = 10
                    
                    spawn(function()
                        while billboard and billboard.Parent do
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and root then
                                local dist = (root.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                distLabel.Text = string.format("%.0f studs", dist)
                            end
                            wait(0.1)
                        end
                    end)
                end
                
                table.insert(espObjects, billboard)
            end
        end
    end
end

-- ========== ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ ==========
local function speedHackLoop()
    spawn(function()
        while settings.SpeedHack do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = settings.SpeedValue
                end
            end)
            wait(1)
        end
    end)
end

local function noClipLoop()
    spawn(function()
        while settings.NoClip do
            pcall(function()
                local char = player.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            wait(0.1)
        end
    end)
end

local function godModeLoop()
    spawn(function()
        while settings.GodMode do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.MaxHealth = 9e9
                    char.Humanoid.Health = 9e9
                end
            end)
            wait(1)
        end
    end)
end

-- ========== ФУНКЦИИ ТЕЛЕПОРТА ==========
local function teleportTo(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if settings.TeleportSmooth then
            TweenService:Create(char.HumanoidRootPart, TweenInfo.new(1), {CFrame = CFrame.new(pos)}):Play()
        else
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end
end

-- ========== СОЗДАНИЕ ИНТЕРФЕЙСА ==========
function createMainGUI()
    GUI = Instance.new("ScreenGui")
    GUI.Name = "CommanderHub"
    GUI.Parent = game.CoreGui
    GUI.ResetOnSpawn = false
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.DisplayOrder = 999
    
    -- Иконка
    IconButton = Instance.new("ImageButton")
    IconButton.Parent = GUI
    IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    IconButton.BackgroundTransparency = 0.1
    IconButton.Position = UDim2.new(0.02, 0, 0.5, -35)
    IconButton.Size = UDim2.new(0, 70, 0, 70)
    IconButton.Image = "rbxassetid://3926305904"
    IconButton.ImageColor3 = Color3.fromRGB(255, 80, 80)
    IconButton.Draggable = true
    IconButton.Active = true
    IconButton.ZIndex = 999
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 35)
    IconCorner.Parent = IconButton
    
    -- Клик
    IconButton.MouseButton1Click:Connect(function()
        if MainFrame then MainFrame.Visible = not MainFrame.Visible end
    end)
    
    IconButton.Activated:Connect(function()
        if MainFrame then MainFrame.Visible = not MainFrame.Visible end
    end)
    
    -- Главное окно
    MainFrame = Instance.new("Frame")
    MainFrame.Parent = GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 600, 0, 500)
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame
    
    -- Заголовок
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 15)
    TitleCorner.Parent = TitleBar
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Parent = TitleBar
    TitleText.BackgroundTransparency = 1
    TitleText.Size = UDim2.new(1, -40, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = "⚡ КОМАНДИР ХАБ"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 20
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Parent = TitleBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
    CloseBtn.Image = "rbxassetid://5054663650"
    CloseBtn.ImageColor3 = Color3.fromRGB(255, 80, 80)
    
    CloseBtn.MouseButton1Click:Connect(function()
        GUI:Destroy()
    end)
    
    -- ========== ВКЛАДКИ ==========
    local TabFrame = Instance.new("Frame")
    TabFrame.Parent = MainFrame
    TabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabFrame.Position = UDim2.new(0, 0, 0, 45)
    TabFrame.Size = UDim2.new(1, 0, 1, -45)
    
    local Tabs = {"KILL AURA", "АВТОФАРМ", "ESP", "ТЕЛЕПОРТ", "РАЗНОЕ"}
    local TabButtons = {}
    local CurrentTab = 1
    
    for i, name in ipairs(Tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = TabFrame
        btn.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(40, 40, 45)
        btn.Position = UDim2.new(0, 5 + (i-1) * 115, 0, 10)
        btn.Size = UDim2.new(0, 105, 0, 30)
        btn.Font = Enum.Font.GothamBold
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        TabButtons[i] = btn
        
        btn.MouseButton1Click:Connect(function()
            for j, b in ipairs(TabButtons) do
                b.BackgroundColor3 = j == i and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(40, 40, 45)
            end
            CurrentTab = i
            updateTabContent()
        end)
    end
    
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Parent = TabFrame
    ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ContentFrame.Position = UDim2.new(0, 10, 0, 50)
    ContentFrame.Size = UDim2.new(1, -20, 1, -60)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.ScrollBarThickness = 8
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentFrame
    
    -- ========== ФУНКЦИИ ОБНОВЛЕНИЯ КОНТЕНТА ==========
    function createToggle(parent, text, setting, yPos)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        frame.Size = UDim2.new(0.9, 0, 0, 40)
        frame.Position = UDim2.new(0.05, 0, 0, yPos)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
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
        
        local btn = Instance.new("TextButton")
        btn.Parent = frame
        btn.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        btn.Size = UDim2.new(0, 50, 0, 25)
        btn.Position = UDim2.new(1, -60, 0.5, -12.5)
        btn.Font = Enum.Font.GothamBold
        btn.Text = settings[setting] and "ON" or "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            settings[setting] = not settings[setting]
            btn.Text = settings[setting] and "ON" or "OFF"
            btn.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
            
            if setting == "KillAura" and settings.KillAura then killAuraLoop() end
            if setting == "AutoFarm" and settings.AutoFarm then autoFarmLoop() end
            if setting == "ESP" and settings.ESP then updateESP() end
            if setting == "SpeedHack" and settings.SpeedHack then speedHackLoop() end
            if setting == "NoClip" and settings.NoClip then noClipLoop() end
            if setting == "GodMode" and settings.GodMode then godModeLoop() end
        end)
        
        return frame
    end
    
    function createSlider(parent, text, setting, min, max, yPos)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        frame.Size = UDim2.new(0.9, 0, 0, 45)
        frame.Position = UDim2.new(0.05, 0, 0, yPos)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -10, 0.4, 0)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Font = Enum.Font.Gotham
        label.Text = text .. ": " .. settings[setting]
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Parent = frame
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        sliderBg.Size = UDim2.new(0.8, 0, 0.3, 0)
        sliderBg.Position = UDim2.new(0.1, 0, 0.5, 0)
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 5)
        sliderCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBg
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        sliderFill.Size = UDim2.new((settings[setting] - min) / (max - min), 0, 1, 0)
        
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
                value = math.floor(value * 10) / 10
                settings[setting] = value
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                valueLabel.Text = value
                label.Text = text .. ": " .. value
            end
        end)
        
        return frame
    end
    
    function createButton(parent, text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        btn.Size = UDim2.new(0.4, 0, 0, 35)
        btn.Position = UDim2.new(0.3, 0, 0, yPos)
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
        
        return btn
    end
    
    function updateTabContent()
        ContentFrame:ClearAllChildren()
        local yPos = 10
        
        if CurrentTab == 1 then -- Kill Aura
            createToggle(ContentFrame, "Включить Kill Aura", "KillAura", yPos)
            yPos = yPos + 50
            createSlider(ContentFrame, "Радиус", "KillAuraRadius", 10, 50, yPos)
            yPos = yPos + 55
            createSlider(ContentFrame, "Скорость", "KillAuraSpeed", 0.1, 1, yPos)
            yPos = yPos + 55
            createSlider(ContentFrame, "Урон x", "KillAuraDamage", 0.5, 5, yPos)
            yPos = yPos + 55
            
        elseif CurrentTab == 2 then -- Автофарм
            createToggle(ContentFrame, "Включить автофарм", "AutoFarm", yPos)
            yPos = yPos + 50
            createSlider(ContentFrame, "Радиус", "AutoFarmRadius", 15, 50, yPos)
            yPos = yPos + 55
            createSlider(ContentFrame, "Скорость", "AutoFarmSpeed", 0.2, 1, yPos)
            yPos = yPos + 55
            
        elseif CurrentTab == 3 then -- ESP
            createToggle(ContentFrame, "Включить ESP", "ESP", yPos)
            yPos = yPos + 50
            createToggle(ContentFrame, "Показывать здоровье", "ESPHealth", yPos)
            yPos = yPos + 50
            createToggle(ContentFrame, "Показывать дистанцию", "ESPDistance", yPos)
            yPos = yPos + 50
            createToggle(ContentFrame, "Показывать имя", "ESPName", yPos)
            yPos = yPos + 50
            
        elseif CurrentTab == 4 then -- Телепорт
            createButton(ContentFrame, "1 Море", yPos, function()
                teleportTo(Vector3.new(100, 50, 100))
            end)
            yPos = yPos + 45
            
            createButton(ContentFrame, "2 Море", yPos, function()
                teleportTo(Vector3.new(1000, 50, 1000))
            end)
            yPos = yPos + 45
            
            createButton(ContentFrame, "3 Море", yPos, function()
                teleportTo(Vector3.new(2000, 50, 2000))
            end)
            yPos = yPos + 45
            
            createButton(ContentFrame, "Спавн", yPos, function()
                teleportTo(Vector3.new(0, 50, 0))
            end)
            yPos = yPos + 45
            
            createToggle(ContentFrame, "Плавный телепорт", "TeleportSmooth", yPos)
            yPos = yPos + 50
            
        elseif CurrentTab == 5 then -- Разное
            createToggle(ContentFrame, "Speed Hack", "SpeedHack", yPos)
            yPos = yPos + 50
            createSlider(ContentFrame, "Скорость", "SpeedValue", 16, 100, yPos)
            yPos = yPos + 55
            createToggle(ContentFrame, "No Clip", "NoClip", yPos)
            yPos = yPos + 50
            createToggle(ContentFrame, "God Mode", "GodMode", yPos)
            yPos = yPos + 50
        end
        
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
    end
    
    updateTabContent()
end

print("✅ КОМАНДИР ХАБ ЗАГРУЖЕН! Ключ: 9866")
