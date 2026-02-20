--[[
    ⚡ КОМАНДИР ХАБ ULTIMATE ⚡
    Версия: 9.0 FINAL
    Статус: ПОЛНОСТЬЮ РАБОЧАЯ ВЕРСИЯ
--]]

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== ПЕРЕМЕННЫЕ ==========
local REQUIRED_KEY = "9866"
local GUI = nil
local IconButton = nil
local MainFrame = nil

-- ========== НАСТРОЙКИ ==========
local settings = {
    KillAura = false,
    KillAuraRadius = 20,
    KillAuraSpeed = 0.3,
    KillAuraTargetMode = "Closest",
    KillAuraShowInfo = true,
    KillAuraDamageMult = 1,
    AutoFarm = false,
    AutoFarmRadius = 25,
    ESP = false,
    SpeedHack = false,
    SpeedValue = 16,
    NoClip = false,
    GodMode = false
}

-- ========== СИСТЕМА КЛЮЧЕЙ ==========
local KeyGUI = Instance.new("ScreenGui")
KeyGUI.Name = "CommanderKeySystem"
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
KeyTitle.Text = "⚡ ПРЕМИУМ ДОСТУП ⚡"
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
KeyBox.ClearTextOnFocus = false

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
local espObjects = {}

local function cleanupESP()
    for _, v in pairs(espObjects) do
        pcall(function() v:Destroy() end)
    end
    espObjects = {}
end

local function updateTargetInfo(target)
    if not target or not target:FindFirstChild("Humanoid") or not target:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoid = target.Humanoid
    local root = target.HumanoidRootPart
    
    local billboard = target:FindFirstChild("TargetInfo")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "TargetInfo"
        billboard.Parent = target
        billboard.Size = UDim2.new(0, 150, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        table.insert(espObjects, billboard)
        
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
        hpText.TextSize = 10
    end
    
    local frame = billboard:FindFirstChildOfClass("Frame")
    if frame then
        local nameLabel = frame:FindFirstChildOfClass("TextLabel")
        if nameLabel then
            nameLabel.Text = target.Name
        end
        
        local hpBar = frame:FindFirstChildOfClass("Frame")
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

local function findKillAuraTarget()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local root = char.HumanoidRootPart
    local myPos = root.Position
    local bestTarget = nil
    local bestDist = math.huge
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local humanoid = obj.Humanoid
            if humanoid.Health > 0 then
                local isPlayer = game.Players:GetPlayerFromCharacter(obj)
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
                
                if target and settings.KillAuraShowInfo then
                    updateTargetInfo(target)
                end
                
                if target then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
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
                            
                            target.Humanoid:TakeDamage(10 * settings.KillAuraDamageMult)
                        end
                    end
                end
            end)
            wait(settings.KillAuraSpeed)
        end
        cleanupESP()
    end)
end

-- ========== СОЗДАНИЕ ИНТЕРФЕЙСА ==========
function createMainGUI()
    GUI = Instance.new("ScreenGui")
    GUI.Name = "CommanderUltimate"
    GUI.Parent = game.CoreGui
    GUI.ResetOnSpawn = false
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.DisplayOrder = 999
    
    -- Иконка
    IconButton = Instance.new("ImageButton")
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
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 35)
    IconCorner.Parent = IconButton
    
    local IconStroke = Instance.new("UIStroke")
    IconStroke.Thickness = 4
    IconStroke.Color = Color3.fromRGB(255, 0, 0)
    IconStroke.Transparency = 0.3
    IconStroke.Parent = IconButton
    
    -- Тройной клик
    IconButton.MouseButton1Click:Connect(function()
        if MainFrame then MainFrame.Visible = not MainFrame.Visible end
    end)
    
    IconButton.Activated:Connect(function()
        if MainFrame then MainFrame.Visible = not MainFrame.Visible end
    end)
    
    IconButton.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
            input.UserInputType == Enum.UserInputType.Touch) and MainFrame then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    -- Главное окно
    MainFrame = Instance.new("Frame")
    MainFrame.Parent = GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = MainFrame
    
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
    TitleText.TextSize = 20
    
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Parent = TitleBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
    CloseBtn.Image = "rbxassetid://5054663650"
    CloseBtn.ImageColor3 = Color3.fromRGB(255, 50, 50)
    
    CloseBtn.MouseButton1Click:Connect(function()
        GUI:Destroy()
    end)
    
    -- Простое меню
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = MainFrame
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    ToggleFrame.Position = UDim2.new(0.02, 0, 0.12, 0)
    ToggleFrame.Size = UDim2.new(0.96, 0, 0.86, 0)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 15)
    ToggleCorner.Parent = ToggleFrame
    
    local yPos = 10
    
    -- Kill Aura
    local kaLabel = Instance.new("TextLabel")
    kaLabel.Parent = ToggleFrame
    kaLabel.BackgroundTransparency = 1
    kaLabel.Position = UDim2.new(0.05, 0, 0, yPos)
    kaLabel.Size = UDim2.new(0.9, 0, 0, 30)
    kaLabel.Font = Enum.Font.GothamBold
    kaLabel.Text = "⚔️ KILL AURA"
    kaLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    kaLabel.TextSize = 18
    yPos = yPos + 35
    
    local kaToggle = Instance.new("TextButton")
    kaToggle.Parent = ToggleFrame
    kaToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    kaToggle.Position = UDim2.new(0.05, 0, 0, yPos)
    kaToggle.Size = UDim2.new(0.4, 0, 0, 30)
    kaToggle.Font = Enum.Font.GothamBold
    kaToggle.Text = "ВЫКЛ"
    kaToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local kaCorner = Instance.new("UICorner")
    kaCorner.CornerRadius = UDim.new(0, 8)
    kaCorner.Parent = kaToggle
    
    kaToggle.MouseButton1Click:Connect(function()
        settings.KillAura = not settings.KillAura
        kaToggle.Text = settings.KillAura and "ВКЛ" or "ВЫКЛ"
        kaToggle.BackgroundColor3 = settings.KillAura and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        if settings.KillAura then killAuraLoop() end
    end)
    
    -- ESP
    yPos = yPos + 45
    local espToggle = Instance.new("TextButton")
    espToggle.Parent = ToggleFrame
    espToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    espToggle.Position = UDim2.new(0.05, 0, 0, yPos)
    espToggle.Size = UDim2.new(0.4, 0, 0, 30)
    espToggle.Font = Enum.Font.GothamBold
    espToggle.Text = "ESP ВЫКЛ"
    espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 8)
    espCorner.Parent = espToggle
    
    espToggle.MouseButton1Click:Connect(function()
        settings.ESP = not settings.ESP
        espToggle.Text = settings.ESP and "ESP ВКЛ" or "ESP ВЫКЛ"
        espToggle.BackgroundColor3 = settings.ESP and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end)
    
    -- Телепорт
    yPos = yPos + 45
    local tpLabel = Instance.new("TextLabel")
    tpLabel.Parent = ToggleFrame
    tpLabel.BackgroundTransparency = 1
    tpLabel.Position = UDim2.new(0.05, 0, 0, yPos)
    tpLabel.Size = UDim2.new(0.9, 0, 0, 30)
    tpLabel.Font = Enum.Font.GothamBold
    tpLabel.Text = "🌀 ТЕЛЕПОРТ"
    tpLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    tpLabel.TextSize = 18
    yPos = yPos + 35
    
    local tp1 = Instance.new("TextButton")
    tp1.Parent = ToggleFrame
    tp1.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    tp1.Position = UDim2.new(0.05, 0, 0, yPos)
    tp1.Size = UDim2.new(0.4, 0, 0, 30)
    tp1.Font = Enum.Font.Gotham
    tp1.Text = "1 Море"
    tp1.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local tp1Corner = Instance.new("UICorner")
    tp1Corner.CornerRadius = UDim.new(0, 8)
    tp1Corner.Parent = tp1
    
    tp1.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(100, 50, 100)
        end
    end)
    
    local tp2 = Instance.new("TextButton")
    tp2.Parent = ToggleFrame
    tp2.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    tp2.Position = UDim2.new(0.55, 0, 0, yPos)
    tp2.Size = UDim2.new(0.4, 0, 0, 30)
    tp2.Font = Enum.Font.Gotham
    tp2.Text = "2 Море"
    tp2.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local tp2Corner = Instance.new("UICorner")
    tp2Corner.CornerRadius = UDim.new(0, 8)
    tp2Corner.Parent = tp2
    
    tp2.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(1000, 50, 1000)
        end
    end)
    
    yPos = yPos + 35
    
    local tp3 = Instance.new("TextButton")
    tp3.Parent = ToggleFrame
    tp3.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    tp3.Position = UDim2.new(0.05, 0, 0, yPos)
    tp3.Size = UDim2.new(0.4, 0, 0, 30)
    tp3.Font = Enum.Font.Gotham
    tp3.Text = "3 Море"
    tp3.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local tp3Corner = Instance.new("UICorner")
    tp3Corner.CornerRadius = UDim.new(0, 8)
    tp3Corner.Parent = tp3
    
    tp3.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(2000, 50, 2000)
        end
    end)
    
    local spawn = Instance.new("TextButton")
    spawn.Parent = ToggleFrame
    spawn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    spawn.Position = UDim2.new(0.55, 0, 0, yPos)
    spawn.Size = UDim2.new(0.4, 0, 0, 30)
    spawn.Font = Enum.Font.Gotham
    spawn.Text = "Спавн"
    spawn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local spawnCorner = Instance.new("UICorner")
    spawnCorner.CornerRadius = UDim.new(0, 8)
    spawnCorner.Parent = spawn
    
    spawn.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end)
end

print("✅ ULTIMATE ХАБ ЗАГРУЖЕН! Ключ: 9866")
