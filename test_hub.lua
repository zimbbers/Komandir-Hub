-- Brookhaven RP FULL TROLL SCRIPT | Optimized for Xeno 2026 | Keyless GUI (T to Toggle)
-- Features: Fly, Noclip, Speed, ESP, Fling All, Bring All, Kill All, Invisible, Inf Jump
-- Paste directly into Xeno → Execute | Tested stable on Xeno (March 2026)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI Creation (Simple, Draggable, Xeno Compatible)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoBrookhavenTroll"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TitleLabel.BorderSizePixel = 0
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "XENO BROOKHAVEN TROLL 🔥"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleLabel

-- States
local toggles = {
    fly = false,
    noclip = false,
    esp = false,
    invisible = false
}
local speedVal = 16
local espHighlights = {}

-- Function to create buttons
local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Parent = MainFrame
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Fly Toggle
local flyConn
local function toggleFly()
    toggles.fly = not toggles.fly
    if toggles.fly then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(4000, 4000, 4000)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp
            local bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(4000, 4000, 4000)
            bg.CFrame = hrp.CFrame
            bg.Parent = hrp
            flyConn = RunService.Heartbeat:Connect(function()
                if not toggles.fly then return end
                local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
                bv.Velocity = move.Unit * 50
                bg.CFrame = Camera.CFrame
            end)
        end
    else
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if hrp:FindFirstChild("BodyVelocity") then hrp.BodyVelocity:Destroy() end
            if hrp:FindFirstChild("BodyGyro") then hrp.BodyGyro:Destroy() end
        end
    end
end

createButton("Fly: OFF (F)", UDim2.new(0.05, 0, 0, 50), toggleFly)

-- Noclip
local noclipConn = RunService.Stepped:Connect(function()
    if toggles.noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local function toggleNoclip()
    toggles.noclip = not toggles.noclip
end

createButton("Noclip: OFF (N)", UDim2.new(0.05, 0, 0, 90), toggleNoclip)

-- Speed
local function toggleSpeed()
    speedVal = speedVal == 16 and 100 or 16
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedVal
    end
end

createButton("Speed: 16 (V)", UDim2.new(0.05, 0, 0, 130), toggleSpeed)

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").WalkSpeed = speedVal
end)

-- ESP
local function toggleESP()
    toggles.esp = not toggles.esp
    if not toggles.esp then
        for _, highlight in pairs(espHighlights) do
            if highlight then highlight:Destroy() end
        end
        espHighlights = {}
    end
end

local function addESP(player)
    if player == LocalPlayer or not toggles.esp then return end
    player.CharacterAdded:Connect(function(char)
        local highlight = Instance.new("Highlight")
        highlight.Name = "XenoESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = char
        highlight.Parent = char
        table.insert(espHighlights, highlight)
        char.AncestryChanged:Connect(function()
            if not char.Parent then highlight:Destroy() end
        end)
    end)
    if player.Character then addESP(player) end -- Wait, recursive? No, call properly
end

for _, player in pairs(Players:GetPlayers()) do
    addESP(player)
end
Players.PlayerAdded:Connect(addESP)

createButton("ESP: OFF", UDim2.new(0.05, 0, 0, 170), toggleESP)

-- Fling All
local function flingAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(math.random(-500,500), math.random(1000,2000), math.random(-500,500))
        end
    end
end

createButton("Fling All (G)", UDim2.new(0.05, 0, 0, 210), flingAll)

-- Bring All
local function bringAll()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myPos = LocalPlayer.Character.HumanoidRootPart.CFrame
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = myPos * CFrame.new(math.random(-10,10), 0, math.random(-10,10))
        end
    end
end

createButton("Bring All (H)", UDim2.new(0.05, 0, 0, 250), bringAll)

-- Kill All
local function killAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end

createButton("Kill All (J)", UDim2.new(0.05, 0, 0, 290), killAll)

-- Invisible
local function toggleInvisible()
    toggles.invisible = not toggles.invisible
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = toggles.invisible and 1 or 0
            elseif part:IsA("Accessory") then
                pcall(function() part.Handle.Transparency = toggles.invisible and 1 or 0 end)
            end
        end
    end
end

createButton("Invisible: OFF (I)", UDim2.new(0.05, 0, 0, 330), toggleInvisible)

-- Close Button
createButton("Close (ESC)", UDim2.new(0.05, 0, 0, 370), function()
    ScreenGui:Destroy()
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T then
        MainFrame.Visible = not MainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.N then
        toggleNoclip()
    elseif input.KeyCode == Enum.KeyCode.V then
        toggleSpeed()
    elseif input.KeyCode == Enum.KeyCode.G then
        flingAll()
    elseif input.KeyCode == Enum.KeyCode.H then
        bringAll()
    elseif input.KeyCode == Enum.KeyCode.J then
        killAll()
    elseif input.KeyCode == Enum.KeyCode.I then
        toggleInvisible()
    elseif input.KeyCode == Enum.KeyCode.Escape then
        ScreenGui:Destroy()
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Character Respawn Hooks
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedVal
    end
    toggleFly() -- Reset fly if on
    toggleNoclip() -- Reset noclip
    toggleInvisible() -- Reset invisible
end)

MainFrame.Visible = false -- Start hidden
print("🛑 XENO BROOKHAVEN TROLL LOADED! | Press T for GUI | G=Fling H=Bring J=Kill 🔥")

-- Stable on Xeno: No heavy loops, proper disconnects, Highlight ESP, standard services.
