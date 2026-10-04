--[[
  SARAB HUB - Universal Edition
  Script by: Muhammad Majed
  Version: 7.0.0 (Clean Build)
  Support: Mobile + PC
--]]

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local IS_PC = UserInputService.MouseEnabled

-- ========== LOAD REX UI ==========
local Rex = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImDarkRex/Rex/main/Rex.lua"))()

-- ========== GLOBALS ==========
_G.AutoCollect = false
_G.AutoInteract = false
_G.InfiniteJump = false
_G.Fly = false
_G.Noclip = false
_G.GodMode = false
_G.AntiRagdoll = false
_G.AntiAfk = false
_G.FullBright = false
_G.ItemESP = false
_G.MonsterESP = false
_G.DoorESP = false
_G.FPSBoost = false
_G.NoFog = false
_G.FlySpeed = 50
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.ESPColor = Color3.fromRGB(255, 0, 0)
_G.FOV = 70
_G.InteractRange = 15
_G.AutoCollectDelay = 0.5
_G.UI_OPEN = true
_G.EFFECTS_ENABLED = true

local BTN_SIZE = IS_MOBILE and 65 or 60
local BTN_POS = IS_MOBILE and UDim2.new(0, 20, 0.35, -32) or UDim2.new(0, 30, 0.4, -30)

-- ========== STORY ==========
local StoryScenes = {
    {title = "Grocery Store", objective = "Collect items and talk to NPC", details = "Start inside the grocery store, collect the requested items.", position = Vector3.new(0, 5, 0)},
    {title = "School Key", objective = "Get school key from worker", details = "After grocery, get school key from the worker.", position = Vector3.new(50, 5, 50)},
    {title = "School", objective = "Break chain and enter", details = "Find chained entrance, break it and enter.", position = Vector3.new(100, 5, 100)},
    {title = "School Puzzle Start", objective = "Read notes and papers", details = "Examine the place and read notes.", position = Vector3.new(120, 5, 120)},
    {title = "Nasser & Abdullah", objective = "Find info about them", details = "The real story starts. Talk about Nasser and Abdullah.", position = Vector3.new(140, 5, 140)},
    {title = "Laboratory", objective = "Explore chemistry lab", details = "Go to chemistry lab and the locked door.", position = Vector3.new(160, 5, 160)},
    {title = "Note & Bathroom", objective = "Read the note", details = "Note related to Nasser's experiment.", position = Vector3.new(180, 5, 180)},
    {title = "Mysterious Message", objective = "Analyze the message", details = "Message from unknown person about monitoring.", position = Vector3.new(200, 5, 200)},
    {title = "Water Puzzle", objective = "Solve water puzzle", details = "Deal with valves and solve the puzzle.", position = Vector3.new(220, 5, 220)},
    {title = "Incomplete Truth", objective = "Collect all evidence", details = "The truth about Nasser, Abdullah and the lab.", position = Vector3.new(240, 5, 240)},
}

-- ========== HELPERS ==========
local function Notify(title, text, duration)
    pcall(function()
        Rex:Notify({Title = title, Text = text, Duration = duration or 3})
    end)
end

local function GetChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetDist(a, b)
    if not a or not b then return math.huge end
    return (a.Position - b.Position).Magnitude
end

local function TeleportTo(pos)
    local hrp = GetHRP()
    if hrp then hrp.CFrame = CFrame.new(pos) end
end

local function CreateESP(obj, color)
    if not obj or obj:FindFirstChild("SarabESP") then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "SarabESP"
    box.Adornee = obj
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4, 6, 4)
    box.Transparency = 0.5
    box.Color3 = color or _G.ESPColor
    box.Parent = obj
end

local function ClearAllESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("SarabESP") then obj.SarabESP:Destroy() end
    end
end

-- ========== EFFECTS ==========
local Effects = {}

function Effects.Ripple(parent, color)
    if not _G.EFFECTS_ENABLED or not parent then return end
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = color or Color3.fromRGB(100, 150, 255)
    ripple.BackgroundTransparency = 0.3
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 0
    ripple.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = ripple
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    local t = TweenService:Create(ripple, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1,
    })
    t:Play()
    t.Completed:Connect(function() ripple:Destroy() end)
end

function Effects.Shake(obj, intensity, duration)
    if not _G.EFFECTS_ENABLED or not obj then return end
    task.spawn(function()
        local orig = obj.Position
        local start = tick()
        while tick() - start < duration do
            obj.Position = orig + UDim2.new(0, math.random(-intensity, intensity), 0, math.random(-intensity, intensity))
            task.wait(0.02)
        end
        obj.Position = orig
    end)
end

function Effects.Particles(parent, color, count)
    if not _G.EFFECTS_ENABLED or not parent then return end
    for i = 1, (count or 8) do
        task.spawn(function()
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, 6, 0, 6)
            p.Position = UDim2.new(0.5, 0, 0.5, 0)
            p.BackgroundColor3 = color or Color3.fromRGB(100, 200, 255)
            p.BorderSizePixel = 0
            p.ZIndex = 10
            p.Parent = parent
            local cc = Instance.new("UICorner")
            cc.CornerRadius = UDim.new(1, 0)
            cc.Parent = p
            local angle = math.random(0, 360)
            local dist = math.random(40, 80)
            TweenService:Create(p, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, math.cos(math.rad(angle)) * dist, 0.5, math.sin(math.rad(angle)) * dist),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 2, 0, 2),
            }):Play()
            task.wait(0.8)
            p:Destroy()
        end)
    end
end

-- ========== WINDOW ==========
local Window = Rex:CreateWindow({
    Title = "SARAB HUB",
    Subtitle = "Universal Edition | by Muhammad Majed",
    Size = IS_MOBILE and UDim2.fromOffset(400, 300) or UDim2.fromOffset(650, 480),
    Theme = "Dark",
    KeyBind = Enum.KeyCode.RightShift,
    ToggleKey = Enum.KeyCode.RightShift,
    Acrylic = true,
    Transparency = 0.1,
})

-- ========== FLOATING BUTTON ==========
local FloatingGui = nil
local FloatingButton = nil

local function CreateFloatingButton(toggleFunc)
    local sg = Instance.new("ScreenGui")
    sg.Name = "SarabFloatingButton"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.IgnoreGuiInset = true
    sg.Parent = CoreGui

    local btn = Instance.new("TextButton")
    btn.Name = "MainButton"
    btn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
    btn.Position = BTN_POS
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Draggable = true
    btn.Parent = sg

    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(1, 0)
    uic.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 150, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.2
    stroke.Parent = btn

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255)),
    })
    grad.Rotation = 0
    grad.Parent = btn

    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "M"
    icon.TextSize = IS_MOBILE and 30 or 28
    icon.Font = Enum.Font.GothamBold
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.ZIndex = 2
    icon.Parent = btn

    local ring = Instance.new("Frame")
    ring.Name = "Ring"
    ring.Size = UDim2.new(1, 10, 1, 10)
    ring.Position = UDim2.new(0.5, 0, 0.5, 0)
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.BackgroundTransparency = 1
    ring.ZIndex = 0
    ring.Parent = btn

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(1, 0)
    rc.Parent = ring

    local rstroke = Instance.new("UIStroke")
    rstroke.Color = Color3.fromRGB(100, 200, 255)
    rstroke.Thickness = 1.5
    rstroke.Transparency = 0.5
    rstroke.Parent = ring

    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 30, 1, 30)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    glow.BackgroundTransparency = 0.85
    glow.BorderSizePixel = 0
    glow.ZIndex = -1
    glow.Parent = btn

    local gc = Instance.new("UICorner")
    gc.CornerRadius = UDim.new(1, 0)
    gc.Parent = glow

    local isOpen = false

    -- Slide in animation
    btn.Position = UDim2.new(-0.2, 0, BTN_POS.Y.Scale, BTN_POS.Y.Offset)
    task.wait(0.3)
    TweenService:Create(btn, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = BTN_POS,
    }):Play()

    -- Glow pulse
    task.spawn(function()
        while btn and btn.Parent and _G.EFFECTS_ENABLED do
            TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(1, 40, 1, 40),
                BackgroundTransparency = 0.7,
            }):Play()
            task.wait(1.2)
            if not btn or not btn.Parent then break end
            TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(1, 30, 1, 30),
                BackgroundTransparency = 0.85,
            }):Play()
            task.wait(1.2)
        end
    end)

    -- Gradient rotation
    task.spawn(function()
        while btn and btn.Parent and _G.EFFECTS_ENABLED do
            for i = 0, 360, 10 do
                if not btn or not btn.Parent then break end
                grad.Rotation = i
                task.wait(0.03)
            end
        end
    end)

    -- Ring rotation
    task.spawn(function()
        while btn and btn.Parent and _G.EFFECTS_ENABLED do
            for i = 0, 360, 10 do
                if not btn or not btn.Parent then break end
                ring.Rotation = i
                task.wait(0.04)
            end
        end
    end)

    -- Ring pulse
    task.spawn(function()
        while btn and btn.Parent and _G.EFFECTS_ENABLED do
            TweenService:Create(rstroke, TweenInfo.new(1, Enum.EasingStyle.Sine), {Transparency = 0, Thickness = 2.5}):Play()
            task.wait(1)
            if not btn or not btn.Parent then break end
            TweenService:Create(rstroke, TweenInfo.new(1, Enum.EasingStyle.Sine), {Transparency = 0.6, Thickness = 1.5}):Play()
            task.wait(1)
        end
    end)

    local function HandleClick()
        isOpen = not isOpen
        Effects.Ripple(btn, isOpen and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 200, 255))
        Effects.Particles(btn, isOpen and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 200, 255), 12)
        Effects.Shake(btn, 4, 0.2)
        if isOpen then
            icon.Text = "X"
            btn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
            stroke.Color = Color3.fromRGB(255, 100, 100)
            glow.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        else
            icon.Text = "M"
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
            stroke.Color = Color3.fromRGB(100, 150, 255)
            glow.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        end
        if toggleFunc then toggleFunc() end
    end

    -- Mobile
    btn.TouchTap:Connect(function()
        if IS_MOBILE then HandleClick() end
    end)

    -- PC
    btn.MouseButton1Click:Connect(function()
        if IS_PC then HandleClick() end
    end)

    btn.MouseEnter:Connect(function()
        if IS_PC then
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, BTN_SIZE + 10, 0, BTN_SIZE + 10)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0, Thickness = 3}):Play()
            Effects.Particles(btn, Color3.fromRGB(100, 200, 255), 6)
        end
    end)

    btn.MouseLeave:Connect(function()
        if IS_PC then
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.2, Thickness = 2}):Play()
        end
    end)

    btn.MouseButton1Down:Connect(function()
        if IS_PC then
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, BTN_SIZE - 10, 0, BTN_SIZE - 10)}):Play()
        end
    end)

    btn.MouseButton1Up:Connect(function()
        if IS_PC then
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)}):Play()
        end
    end)

    return sg, btn
end

local function ToggleRexUI()
    pcall(function()
        if Rex.Toggle then
            Rex:Toggle()
            _G.UI_OPEN = not _G.UI_OPEN
        end
    end)
end

FloatingGui, FloatingButton = CreateFloatingButton(ToggleRexUI)

if IS_PC then
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            ToggleRexUI()
            if FloatingButton then
                Effects.Ripple(FloatingButton, Color3.fromRGB(100, 200, 255))
            end
        end
    end)
end

-- ========== MAIN TAB ==========
local MainTab = Window:CreateTab("Home", "home")
local MainSec = MainTab:CreateSection("Player Info")
MainSec:CreateLabel({Text = "Player: " .. LocalPlayer.Name, Color = Color3.fromRGB(100, 200, 255)})
MainSec:CreateLabel({Text = "ID: " .. LocalPlayer.UserId, Color = Color3.fromRGB(100, 200, 255)})
MainSec:CreateLabel({Text = "Device: " .. (IS_MOBILE and "Mobile" or "PC"), Color = Color3.fromRGB(100, 200, 255)})
MainSec:CreateLabel({Text = "Time: " .. os.date("%Y-%m-%d %H:%M:%S"), Color = Color3.fromRGB(100, 200, 255)})

-- ========== STORY TAB ==========
local StoryTab = Window:CreateTab("Story", "story")
local StorySec = StoryTab:CreateSection("Story Scenes")
StorySec:CreateLabel({Text = "Sarab - Story in Order", Color = Color3.fromRGB(255, 215, 0)})

for _, scene in ipairs(StoryScenes) do
    local sTitle = scene.title
    local sObj = scene.objective
    local sDet = scene.details
    local sPos = scene.position
    StorySec:CreateButton({
        Name = sTitle,
        Description = sObj,
        Callback = function()
            TeleportTo(sPos)
            Notify("Done", "Teleported to " .. sTitle, 2)
            Notify("Details", sDet, 6)
        end,
    })
end

-- ========== AUTO COLLECT TAB ==========
local CollectTab = Window:CreateTab("Collect", "collect")
local CollectSec = CollectTab:CreateSection("Auto Collect")

CollectSec:CreateToggle({
    Name = "Auto Collect Evidence",
    Description = "Collect all evidence and notes",
    Default = false,
    Callback = function(state)
        _G.AutoCollect = state
        if state then
            task.spawn(function()
                while _G.AutoCollect do
                    task.wait(_G.AutoCollectDelay)
                    pcall(function()
                        local hrp = GetHRP()
                        if not hrp then return end
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and obj:FindFirstChild("ClickDetector") then
                                if GetDist(hrp, obj) < _G.InteractRange then
                                    fireclickdetector(obj.ClickDetector)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end,
})

CollectSec:CreateToggle({
    Name = "Auto Interact",
    Description = "Interact with doors and notes",
    Default = false,
    Callback = function(state)
        _G.AutoInteract = state
        if state then
            task.spawn(function()
                while _G.AutoInteract do
                    task.wait(0.5)
                    pcall(function()
                        local hrp = GetHRP()
                        if not hrp then return end
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and obj:FindFirstChild("ClickDetector") then
                                if GetDist(hrp, obj) < _G.InteractRange then
                                    fireclickdetector(obj.ClickDetector)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end,
})

CollectSec:CreateSlider({
    Name = "Interact Range",
    Min = 5, Max = 50, Default = 15,
    Callback = function(v) _G.InteractRange = v end,
})

CollectSec:CreateSlider({
    Name = "Collect Delay",
    Min = 0.1, Max = 2, Default = 0.5,
    Callback = function(v) _G.AutoCollectDelay = v end,
})

-- ========== MOVEMENT TAB ==========
local MoveTab = Window:CreateTab("Movement", "movement")
local MoveSec = MoveTab:CreateSection("Speed")

MoveSec:CreateSlider({
    Name = "Walk Speed",
    Min = 16, Max = 500, Default = 16,
    Callback = function(v)
        _G.WalkSpeed = v
        local hum = GetHum()
        if hum then hum.WalkSpeed = v end
    end,
})

MoveSec:CreateSlider({
    Name = "Jump Power",
    Min = 50, Max = 500, Default = 50,
    Callback = function(v)
        _G.JumpPower = v
        local hum = GetHum()
        if hum then hum.JumpPower = v hum.UseJumpPower = true end
    end,
})

MoveSec:CreateToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
        if state then
            UserInputService.JumpRequest:Connect(function()
                if _G.InfiniteJump then
                    local hum = GetHum()
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end)
        end
    end,
})

MoveSec:CreateToggle({
    Name = "Fly",
    Default = false,
    Callback = function(state)
        _G.Fly = state
        if state then
            local hrp = GetHRP()
            if hrp then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "FlyVelocity"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = hrp
            end
        else
            local hrp = GetHRP()
            if hrp and hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
        end
    end,
})

MoveSec:CreateSlider({
    Name = "Fly Speed",
    Min = 10, Max = 500, Default = 50,
    Callback = function(v) _G.FlySpeed = v end,
})

MoveSec:CreateToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state) _G.Noclip = state end,
})

MoveSec:CreateToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(state)
        _G.GodMode = state
        if state then
            local hum = GetHum()
            if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
        end
    end,
})

MoveSec:CreateToggle({
    Name = "Anti Ragdoll",
    Default = false,
    Callback = function(state) _G.AntiRagdoll = state end,
})

MoveSec:CreateToggle({
    Name = "Anti AFK",
    Default = false,
    Callback = function(state)
        _G.AntiAfk = state
        if state then
            LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end,
})

-- ========== ESP TAB ==========
local EspTab = Window:CreateTab("ESP", "esp")
local EspSec = EspTab:CreateSection("ESP")

EspSec:CreateToggle({
    Name = "Item ESP",
    Default = false,
    Callback = function(state)
        _G.ItemESP = state
        if state then
            task.spawn(function()
                while _G.ItemESP do
                    task.wait(0.5)
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("note") or obj.Name:lower():find("paper") or obj.Name:lower():find("key")) then
                            CreateESP(obj, Color3.fromRGB(255, 255, 0))
                        end
                    end
                end
            end)
        else
            ClearAllESP()
        end
    end,
})

EspSec:CreateToggle({
    Name = "Door ESP",
    Default = false,
    Callback = function(state)
        _G.DoorESP = state
        if state then
            task.spawn(function()
                while _G.DoorESP do
                    task.wait(0.5)
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj.Name:lower():find("door") then
                            CreateESP(obj, Color3.fromRGB(0, 255, 0))
                        end
                    end
                end
            end)
        else
            ClearAllESP()
        end
    end,
})

EspSec:CreateToggle({
    Name = "Monster ESP",
    Default = false,
    Callback = function(state)
        _G.MonsterESP = state
        if state then
            task.spawn(function()
                while _G.MonsterESP do
                    task.wait(0.5)
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and (obj.Name:lower():find("monster") or obj.Name:lower():find("ghost")) then
                            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if hrp then CreateESP(hrp, Color3.fromRGB(255, 0, 0)) end
                        end
                    end
                end
            end)
        else
            ClearAllESP()
        end
    end,
})

EspSec:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(c)
        _G.ESPColor = c
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:FindFirstChild("SarabESP") then obj.SarabESP.Color3 = c end
        end
    end,
})

EspSec:CreateToggle({
    Name = "Full Bright",
    Default = false,
    Callback = function(state)
        _G.FullBright = state
        if state then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 3
            Lighting.ClockTime = 12
        else
            Lighting.Ambient = Color3.fromRGB(70, 70, 70)
            Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
            Lighting.Brightness = 1
        end
    end,
})

EspSec:CreateToggle({
    Name = "No Fog",
    Default = false,
    Callback = function(state)
        _G.NoFog = state
        if state then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
        end
    end,
})

EspSec:CreateSlider({
    Name = "FOV",
    Min = 30, Max = 120, Default = 70,
    Callback = function(v)
        _G.FOV = v
        Camera.FieldOfView = v
    end,
})

-- ========== TOOLS TAB ==========
local ToolsTab = Window:CreateTab("Tools", "tools")
local ToolsSec = ToolsTab:CreateSection("Tools")

ToolsSec:CreateButton({
    Name = "Copy Account Info",
    Callback = function()
        if setclipboard then
            setclipboard("Name: " .. LocalPlayer.Name .. " | ID: " .. LocalPlayer.UserId)
            Notify("Done", "Copied account info", 2)
        end
    end,
})

ToolsSec:CreateButton({
    Name = "Clear All ESP",
    Callback = function()
        ClearAllESP()
        Notify("Done", "Cleared all ESP", 2)
    end,
})

ToolsSec:CreateToggle({
    Name = "FPS Boost",
    Default = false,
    Callback = function(state)
        _G.FPSBoost = state
        if state then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") then
                    obj.Enabled = false
                end
            end
        end
    end,
})

-- ========== SETTINGS TAB ==========
local SetTab = Window:CreateTab("Settings", "settings")
local SetSec = SetTab:CreateSection("UI Settings")

SetSec:CreateDropdown({
    Name = "Theme",
    Options = {"Dark", "Light", "Blood", "Ocean", "Synapse", "Sentinel"},
    Default = "Dark",
    Callback = function(option)
        pcall(function() Rex:SetTheme(option) end)
        Notify("Done", "Theme changed to: " .. option, 2)
    end,
})

SetSec:CreateDropdown({
    Name = "Effects",
    Options = {"On", "Off"},
    Default = "On",
    Callback = function(option)
        _G.EFFECTS_ENABLED = (option == "On")
        Notify("Effects", _G.EFFECTS_ENABLED and "Effects ON" or "Effects OFF", 2)
    end,
})

SetSec:CreateLabel({Text = "Version: 7.0.0", Color = Color3.fromRGB(200, 200, 200)})
SetSec:CreateLabel({Text = "Developer: Muhammad Majed", Color = Color3.fromRGB(200, 200, 200)})

SetSec:CreateButton({
    Name = "Close Script",
    Callback = function()
        if FloatingGui then FloatingGui:Destroy() end
        pcall(function() Rex:Destroy() end)
        Notify("Goodbye", "Script closed", 3)
    end,
})

-- ========== UPDATE LOOP ==========
RunService.Heartbeat:Connect(function()
    pcall(function()
        if _G.WalkSpeed then
            local hum = GetHum()
            if hum and hum.WalkSpeed ~= _G.WalkSpeed then hum.WalkSpeed = _G.WalkSpeed end
        end
        if _G.JumpPower then
            local hum = GetHum()
            if hum and hum.JumpPower ~= _G.JumpPower then hum.JumpPower = _G.JumpPower end
        end
        if _G.GodMode then
            local hum = GetHum()
            if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
        end
        if _G.AntiRagdoll then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.PlatformStand = false end
            end
        end
        if _G.Noclip then
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
        if _G.Fly then
            local hrp = GetHRP()
            if hrp and hrp:FindFirstChild("FlyVelocity") then
                local dir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
                hrp.FlyVelocity.Velocity = dir * _G.FlySpeed
            end
        end
    end)
end)

-- ========== PLAYER EVENTS ==========
Players.PlayerAdded:Connect(function(p)
    Notify("New Player", p.Name .. " joined", 2)
end)

Players.PlayerRemoving:Connect(function(p)
    Notify("Player Left", p.Name .. " left", 2)
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if _G.WalkSpeed then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = _G.WalkSpeed
            hum.JumpPower = _G.JumpPower
        end
    end
end)

-- ========== STARTUP ==========
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

task.wait(1)
Notify("SARAB HUB", "Script loaded successfully!", 4)
Notify("Device", IS_MOBILE and "Mobile Mode" or "PC Mode", 3)
Notify("Floating Button", IS_MOBILE and "Tap the floating icon" or "Click icon or RightShift", 5)

print("========================================")
print("  SARAB HUB - Universal Edition")
print("  Script by: Muhammad Majed")
print("  Version: 7.0.0")
print("  Device: " .. (IS_MOBILE and "Mobile" or "PC"))
print("  Status: Loaded Successfully")
print("========================================")
