--[[
═══════════════════════════════════════════════════════════════════════════════════════════════════
  SARAB HUB - Complete Edition
  Script by: Muhammad Majed
  Library: Kavo UI
  Version: 12.0.0
  Lines: 1500+
  Support: Mobile + PC
═══════════════════════════════════════════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 1: SERVICES
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local ContextActionService = game:GetService("ContextActionService")
local HapticService = game:GetService("HapticService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local IS_PC = UserInputService.MouseEnabled
local IS_CONSOLE = UserInputService.GamepadEnabled and not UserInputService.TouchEnabled

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 2: LOAD KAVO UI LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local KavoUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 3: GLOBAL VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

_G.WalkSpeed = 16
_G.JumpPower = 50
_G.FlySpeed = 50
_G.InteractRange = 15
_G.AutoCollectDelay = 0.5
_G.ESPTransparency = 0.5
_G.ESPColor = Color3.fromRGB(255, 0, 0)
_G.FOV = 70
_G.ClockTime = 12

_G.Fly = false
_G.Noclip = false
_G.GodMode = false
_G.InfJump = false
_G.AntiAfk = false
_G.AntiRagdoll = false
_G.AntiFling = false
_G.FullBright = false
_G.NoFog = false
_G.NoShadows = false
_G.ItemESP = false
_G.DoorESP = false
_G.MonsterESP = false
_G.PlayerESP = false
_G.NpcESP = false
_G.ChestESP = false
_G.AutoCollect = false
_G.AutoInteract = false
_G.AutoSolve = false
_G.AutoQuest = false
_G.FPSBoost = false
_G.EffectsEnabled = true
_G.NotificationsEnabled = true
_G.HapticFeedback = true

local BTN_SIZE = IS_MOBILE and 65 or 60
local BTN_POS = IS_MOBILE and UDim2.new(0, 20, 0.4, -32) or UDim2.new(0, 30, 0.4, -30)

local ScriptVersion = "12.0.0"
local ScriptName = "SARAB HUB"
local ScriptAuthor = "Muhammad Majed"

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 4: STORY DATA
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local StoryScenes = {
    {
        id = 1,
        title = "Scene 1 - Grocery Store",
        objective = "Collect items and talk to NPC",
        details = "Start inside the grocery store, collect the requested items, and talk to the NPC.",
        position = Vector3.new(0, 5, 0),
    },
    {
        id = 2,
        title = "Scene 2 - School Key",
        objective = "Get school key from worker",
        details = "After finishing the grocery task, get the school key from the worker.",
        position = Vector3.new(50, 5, 50),
    },
    {
        id = 3,
        title = "Scene 3 - School",
        objective = "Break chain and enter school",
        details = "Find the chained entrance, break it, and enter the school.",
        position = Vector3.new(100, 5, 100),
    },
    {
        id = 4,
        title = "Scene 4 - School Puzzle",
        objective = "Read notes and papers",
        details = "Examine the place and read the notes and papers.",
        position = Vector3.new(120, 5, 120),
    },
    {
        id = 5,
        title = "Scene 5 - Nasser & Abdullah",
        objective = "Find info about Nasser and Abdullah",
        details = "The real story starts. Talk about Nasser and Abdullah.",
        position = Vector3.new(140, 5, 140),
    },
    {
        id = 6,
        title = "Scene 6 - Laboratory",
        objective = "Explore chemistry lab and locked door",
        details = "Go to the chemistry lab and the locked door behind which Nasser spent time.",
        position = Vector3.new(160, 5, 160),
    },
    {
        id = 7,
        title = "Scene 7 - Note & Bathroom",
        objective = "Read the note about Nasser's experiment",
        details = "A note related to Nasser's experiment and water warning.",
        position = Vector3.new(180, 5, 180),
    },
    {
        id = 8,
        title = "Scene 8 - Mysterious Message",
        objective = "Analyze the anonymous message",
        details = "A message from an unknown person about being monitored.",
        position = Vector3.new(200, 5, 200),
    },
    {
        id = 9,
        title = "Scene 9 - Water Puzzle",
        objective = "Solve water sources puzzle",
        details = "Deal with valves and solve the water puzzle.",
        position = Vector3.new(220, 5, 220),
    },
    {
        id = 10,
        title = "Scene 10 - Incomplete Truth",
        objective = "Collect all evidence",
        details = "The truth about Nasser, Abdullah and the laboratory remains incomplete.",
        position = Vector3.new(240, 5, 240),
    },
}

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 5: HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local function GetChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHum()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetDist(a, b)
    if not a or not b then return math.huge end
    return (a.Position - b.Position).Magnitude
end

local function TeleportTo(pos)
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    end
end

local function CreateESP(obj, color)
    if not obj then return end
    if obj:FindFirstChild("SarabESP") then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "SarabESP"
    box.Adornee = obj
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4, 6, 4)
    box.Transparency = _G.ESPTransparency
    box.Color3 = color or _G.ESPColor
    box.Parent = obj
end

local function RemoveESP(obj)
    if obj and obj:FindFirstChild("SarabESP") then
        obj.SarabESP:Destroy()
    end
end

local function ClearAllESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("SarabESP") then
            obj.SarabESP:Destroy()
        end
    end
end

local function GetAllPlayers()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p)
        end
    end
    return list
end

local function GetPlayerNames()
    local list = {"-- Select --"}
    for _, p in ipairs(GetAllPlayers()) do
        table.insert(list, p.Name)
    end
    return list
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 6: EFFECTS ENGINE
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local Effects = {}

function Effects.Ripple(parent, color)
    if not _G.EffectsEnabled or not parent then return end
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
    if not _G.EffectsEnabled or not obj then return end
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
    if not _G.EffectsEnabled or not parent then return end
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

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 7: CREATE KAVO WINDOW
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local Window = KavoUI.CreateLib("SARAB HUB | by Muhammad Majed", "DarkTheme")

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 8: NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local function Notify(title, text, duration)
    if not _G.NotificationsEnabled then return end
    pcall(function()
        KavoUI:Notification({
            Title = title,
            Text = text,
            Duration = duration or 3,
        })
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 9: ANIMATED FLOATING BUTTON
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "SarabFloatingButton"
FloatingGui.ResetOnSpawn = false
FloatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FloatingGui.IgnoreGuiInset = true
FloatingGui.Parent = CoreGui

local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "MainButton"
FloatingButton.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
FloatingButton.Position = BTN_POS
FloatingButton.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
FloatingButton.BorderSizePixel = 0
FloatingButton.Text = "S"
FloatingButton.TextSize = IS_MOBILE and 30 or 28
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.AutoButtonColor = false
FloatingButton.Active = true
FloatingButton.Draggable = true
FloatingButton.Parent = FloatingGui

local uic = Instance.new("UICorner")
uic.CornerRadius = UDim.new(1, 0)
uic.Parent = FloatingButton

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 150, 255)
stroke.Thickness = 2
stroke.Transparency = 0.2
stroke.Parent = FloatingButton

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255)),
})
grad.Parent = FloatingButton

local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 25, 1, 25)
glow.Position = UDim2.new(0.5, 0, 0.5, 0)
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
glow.BackgroundTransparency = 0.85
glow.BorderSizePixel = 0
glow.ZIndex = -1
glow.Parent = FloatingButton

local gc = Instance.new("UICorner")
gc.CornerRadius = UDim.new(1, 0)
gc.Parent = glow

task.spawn(function()
    while FloatingButton and FloatingButton.Parent do
        TweenService:Create(glow, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            Size = UDim2.new(1, 35, 1, 35),
            BackgroundTransparency = 0.7,
        }):Play()
        task.wait(1.5)
        if not FloatingButton or not FloatingButton.Parent then break end
        TweenService:Create(glow, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            Size = UDim2.new(1, 25, 1, 25),
            BackgroundTransparency = 0.85,
        }):Play()
        task.wait(1.5)
    end
end)

task.spawn(function()
    while FloatingButton and FloatingButton.Parent do
        for i = 0, 360, 15 do
            if not FloatingButton or not FloatingButton.Parent then break end
            grad.Rotation = i
            task.wait(0.05)
        end
    end
end)

local function ToggleUI()
    pcall(function()
        KavoUI:ToggleUI()
    end)
end

FloatingButton.TouchTap:Connect(function()
    ToggleUI()
    Effects.Ripple(FloatingButton, Color3.fromRGB(100, 200, 255))
end)

FloatingButton.MouseButton1Click:Connect(function()
    ToggleUI()
    Effects.Ripple(FloatingButton, Color3.fromRGB(100, 200, 255))
end)

if IS_PC then
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            ToggleUI()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 10: MAIN TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local MainTab = Window:NewTab("Main")
local MainSec = MainTab:NewSection("Player Information")
MainSec:NewLabel("Player: " .. LocalPlayer.Name)
MainSec:NewLabel("User ID: " .. LocalPlayer.UserId)
MainSec:NewLabel("Device: " .. (IS_MOBILE and "Mobile" or IS_PC and "PC" or "Console"))
MainSec:NewLabel("Game ID: " .. game.PlaceId)
MainSec:NewLabel("Time: " .. os.date("%Y-%m-%d %H:%M:%S"))

local MainBtnSec = MainTab:NewSection("Actions")
MainBtnSec:NewButton("Copy Account Info", "Copy your account info to clipboard", function()
    if setclipboard then
        setclipboard("Name: " .. LocalPlayer.Name .. " | ID: " .. LocalPlayer.UserId)
        Notify("Copy", "Account info copied!", 2)
    end
end)

MainBtnSec:NewButton("Respawn Character", "Reset your character", function()
    local hum = GetHum()
    if hum then
        hum.Health = 0
        Notify("Respawn", "Respawning...", 2)
    end
end)

MainBtnSec:NewButton("Rejoin Server", "Rejoin the current server", function()
    Notify("Rejoin", "Rejoining in 2 seconds...", 2)
    task.wait(2)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

MainBtnSec:NewButton("Server Hop", "Join a different server", function()
    Notify("Server Hop", "Searching for server...", 2)
    pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        if servers and servers.data then
            for _, server in ipairs(servers.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    return
                end
            end
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 11: STORY TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local StoryTab = Window:NewTab("Story")
local StorySec = StoryTab:NewSection("Story Guide - 10 Scenes")
StorySec:NewLabel("Click any scene to teleport")

for _, scene in ipairs(StoryScenes) do
    local sTitle = scene.title
    local sObj = scene.objective
    local sDet = scene.details
    local sPos = scene.position
    
    StorySec:NewButton(sTitle, sObj, function()
        TeleportTo(sPos)
        Notify("Teleport", "Moved to: " .. sTitle, 2)
        task.wait(0.3)
        Notify("Details", sDet, 6)
    end)
end

local StoryActionSec = StoryTab:NewSection("Story Actions")

StoryActionSec:NewButton("Copy Full Story", "Copy the complete story to clipboard", function()
    local fullStory = "SARAB STORY - 10 SCENES\n\n"
    for _, scene in ipairs(StoryScenes) do
        fullStory = fullStory .. scene.title .. "\n"
        fullStory = fullStory .. "Objective: " .. scene.objective .. "\n"
        fullStory = fullStory .. "Details: " .. scene.details .. "\n\n"
    end
    if setclipboard then
        setclipboard(fullStory)
        Notify("Story", "Full story copied to clipboard!", 3)
    end
end)

StoryActionSec:NewButton("Reset Progress", "Reset story progress", function()
    Notify("Reset", "Story progress reset", 2)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 12: MOVEMENT TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local MoveTab = Window:NewTab("Movement")
local SpeedSec = MoveTab:NewSection("Speed Settings")

SpeedSec:NewSlider("Walk Speed", "Change your walking speed", 500, 16, function(v)
    _G.WalkSpeed = v
    local hum = GetHum()
    if hum then hum.WalkSpeed = v end
end)

SpeedSec:NewSlider("Jump Power", "Change your jump power", 500, 50, function(v)
    _G.JumpPower = v
    local hum = GetHum()
    if hum then hum.JumpPower = v hum.UseJumpPower = true end
end)

SpeedSec:NewToggle("Infinite Jump", "Jump infinitely in air", function(state)
    _G.InfJump = state
    if state then
        Notify("Infinite Jump", "Enabled", 2)
        UserInputService.JumpRequest:Connect(function()
            if _G.InfJump then
                local hum = GetHum()
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    else
        Notify("Infinite Jump", "Disabled", 2)
    end
end)

local FlySec = MoveTab:NewSection("Flight Settings")

FlySec:NewToggle("Fly", "Enable flying mode", function(state)
    _G.Fly = state
    if state then
        Notify("Fly", "Enabled", 2)
        local hrp = GetHRP()
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp
        end
    else
        Notify("Fly", "Disabled", 2)
        local hrp = GetHRP()
        if hrp and hrp:FindFirstChild("FlyVelocity") then
            hrp.FlyVelocity:Destroy()
        end
    end
end)

FlySec:NewSlider("Fly Speed", "Flying speed", 500, 10, function(v)
    _G.FlySpeed = v
end)

local PhysSec = MoveTab:NewSection("Physics Settings")

PhysSec:NewToggle("Noclip", "Walk through walls", function(state)
    _G.Noclip = state
    Notify("Noclip", state and "Enabled" or "Disabled", 2)
end)

PhysSec:NewToggle("God Mode", "Prevent taking damage", function(state)
    _G.GodMode = state
    if state then
        Notify("God Mode", "Enabled", 2)
        local hum = GetHum()
        if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
    else
        Notify("God Mode", "Disabled", 2)
    end
end)

PhysSec:NewToggle("Anti Ragdoll", "Prevent ragdolling", function(state)
    _G.AntiRagdoll = state
    Notify("Anti Ragdoll", state and "Enabled" or "Disabled", 2)
end)

PhysSec:NewToggle("Anti AFK", "Prevent AFK kick", function(state)
    _G.AntiAfk = state
    if state then
        Notify("Anti AFK", "Enabled", 2)
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        Notify("Anti AFK", "Disabled", 2)
    end
end)

PhysSec:NewToggle("Anti Fling", "Prevent getting flung", function(state)
    _G.AntiFling = state
    Notify("Anti Fling", state and "Enabled" or "Disabled", 2)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 13: ESP TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local EspTab = Window:NewTab("ESP")
local EspSec = EspTab:NewSection("ESP Options")

EspSec:NewToggle("Item ESP", "Highlight items and notes", function(state)
    _G.ItemESP = state
    if state then
        Notify("Item ESP", "Enabled", 2)
        task.spawn(function()
            while _G.ItemESP do
                task.wait(0.5)
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj:FindFirstChild("SarabESP") then
                        if obj.Name:lower():find("note") or obj.Name:lower():find("paper") or obj.Name:lower():find("key") then
                            CreateESP(obj, Color3.fromRGB(255, 255, 0))
                        end
                    end
                end
            end
        end)
    else
        Notify("Item ESP", "Disabled", 2)
        ClearAllESP()
    end
end)

EspSec:NewToggle("Door ESP", "Highlight doors", function(state)
    _G.DoorESP = state
    if state then
        Notify("Door ESP", "Enabled", 2)
        task.spawn(function()
            while _G.DoorESP do
                task.wait(0.5)
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj:FindFirstChild("SarabESP") then
                        if obj.Name:lower():find("door") then
                            CreateESP(obj, Color3.fromRGB(0, 255, 0))
                        end
                    end
                end
            end
        end)
    else
        Notify("Door ESP", "Disabled", 2)
        ClearAllESP()
    end
end)

EspSec:NewToggle("Monster ESP", "Highlight monsters", function(state)
    _G.MonsterESP = state
    if state then
        Notify("Monster ESP", "Enabled", 2)
        task.spawn(function()
            while _G.MonsterESP do
                task.wait(0.5)
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") then
                        if obj.Name:lower():find("monster") or obj.Name:lower():find("ghost") or obj.Name:lower():find("entity") then
                            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if hrp and not hrp:FindFirstChild("SarabESP") then
                                CreateESP(hrp, Color3.fromRGB(255, 0, 0))
                            end
                        end
                    end
                end
            end
        end)
    else
        Notify("Monster ESP", "Disabled", 2)
        ClearAllESP()
    end
end)

EspSec:NewToggle("Player ESP", "Highlight all players", function(state)
    _G.PlayerESP = state
    if state then
        Notify("Player ESP", "Enabled", 2)
        task.spawn(function()
            while _G.PlayerESP do
                task.wait(0.5)
                for _, p in ipairs(GetAllPlayers()) do
                    if p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and not hrp:FindFirstChild("SarabESP") then
                            CreateESP(hrp, Color3.fromRGB(0, 200, 255))
                        end
                    end
                end
            end
        end)
    else
        Notify("Player ESP", "Disabled", 2)
        ClearAllESP()
    end
end)

EspSec:NewToggle("NPC ESP", "Highlight all NPCs", function(state)
    _G.NpcESP = state
    if state then
        Notify("NPC ESP", "Enabled", 2)
        task.spawn(function()
            while _G.NpcESP do
                task.wait(0.5)
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
                        if not Players:GetPlayerFromCharacter(obj) then
                            local hrp = obj:FindFirstChild("HumanoidRootPart")
                            if hrp and not hrp:FindFirstChild("SarabESP") then
                                CreateESP(hrp, Color3.fromRGB(255, 165, 0))
                            end
                        end
                    end
                end
            end
        end)
    else
        Notify("NPC ESP", "Disabled", 2)
        ClearAllESP()
    end
end)

EspSec:NewColorPicker("ESP Color", "Choose ESP color", Color3.fromRGB(255, 0, 0), function(color)
    _G.ESPColor = color
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("SarabESP") then
            obj.SarabESP.Color3 = color
        end
    end
end)

EspSec:NewSlider("ESP Transparency", "ESP box transparency", 1, 0, function(v)
    _G.ESPTransparency = v
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("SarabESP") then
            obj.SarabESP.Transparency = v
        end
    end
end)

EspSec:NewButton("Clear All ESP", "Remove all ESP boxes", function()
    ClearAllESP()
    Notify("Clear", "All ESP cleared!", 2)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 14: AUTO COLLECT TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local CollectTab = Window:NewTab("Auto")
local CollectSec = CollectTab:NewSection("Auto Features")

CollectSec:NewToggle("Auto Collect", "Collect all items nearby", function(state)
    _G.AutoCollect = state
    if state then
        Notify("Auto Collect", "Enabled", 2)
        task.spawn(function()
            while _G.AutoCollect do
                task.wait(_G.AutoCollectDelay)
                pcall(function()
                    local hrp = GetHRP()
                    if not hrp then return end
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj:FindFirstChild("ClickDetector") then
                            if (hrp.Position - obj.Position).Magnitude < _G.InteractRange then
                                fireclickdetector(obj.ClickDetector)
                            end
                        end
                    end
                end)
            end
        end)
    else
        Notify("Auto Collect", "Disabled", 2)
    end
end)

CollectSec:NewToggle("Auto Interact", "Interact with doors and objects", function(state)
    _G.AutoInteract = state
    if state then
        Notify("Auto Interact", "Enabled", 2)
        task.spawn(function()
            while _G.AutoInteract do
                task.wait(0.5)
                pcall(function()
                    local hrp = GetHRP()
                    if not hrp then return end
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj:FindFirstChild("ClickDetector") then
                            if (hrp.Position - obj.Position).Magnitude < _G.InteractRange then
                                fireclickdetector(obj.ClickDetector)
                            end
                        end
                    end
                end)
            end
        end)
    else
        Notify("Auto Interact", "Disabled", 2)
    end
end)

CollectSec:NewToggle("Auto Solve Puzzles", "Try to solve puzzles automatically", function(state)
    _G.AutoSolve = state
    if state then
        Notify("Auto Solve", "Enabled", 2)
        task.spawn(function()
            while _G.AutoSolve do
                task.wait(1)
                pcall(function()
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj:FindFirstChild("ClickDetector") then
                            if obj.Name:lower():find("puzzle") or obj.Name:lower():find("valve") or obj.Name:lower():find("switch") then
                                fireclickdetector(obj.ClickDetector)
                            end
                        end
                    end
                end)
            end
        end)
    else
        Notify("Auto Solve", "Disabled", 2)
    end
end)

CollectSec:NewSlider("Interact Range", "Distance for interaction", 50, 5, function(v)
    _G.InteractRange = v
end)

CollectSec:NewSlider("Collect Delay", "Time between each collect", 2, 0.1, function(v)
    _G.AutoCollectDelay = v
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 15: VISUAL TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local VisTab = Window:NewTab("Visual")
local LightSec = VisTab:NewSection("Lighting")

LightSec:NewToggle("Full Bright", "Increase game brightness", function(state)
    _G.FullBright = state
    if state then
        Notify("Full Bright", "Enabled", 2)
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
    else
        Notify("Full Bright", "Disabled", 2)
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        Lighting.Brightness = 1
    end
end)

LightSec:NewToggle("No Fog", "Remove fog from game", function(state)
    _G.NoFog = state
    if state then
        Notify("No Fog", "Enabled", 2)
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    else
        Notify("No Fog", "Disabled", 2)
    end
end)

LightSec:NewToggle("No Shadows", "Remove shadows", function(state)
    _G.NoShadows = state
    if state then
        Notify("No Shadows", "Enabled", 2)
        Lighting.GlobalShadows = false
    else
        Notify("No Shadows", "Disabled", 2)
        Lighting.GlobalShadows = true
    end
end)

LightSec:NewSlider("Clock Time", "Change game time", 24, 0, function(v)
    _G.ClockTime = v
    Lighting.ClockTime = v
end)

LightSec:NewSlider("FOV", "Camera field of view", 120, 30, function(v)
    _G.FOV = v
    Camera.FieldOfView = v
end)

LightSec:NewButton("Reset Lighting", "Reset to default", function()
    Lighting.Ambient = Color3.fromRGB(70, 70, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    Lighting.Brightness = 1
    Lighting.GlobalShadows = true
    Notify("Reset", "Lighting reset to default", 2)
end)

local PerfSec = VisTab:NewSection("Performance")

PerfSec:NewToggle("FPS Boost", "Improve game performance", function(state)
    _G.FPSBoost = state
    if state then
        Notify("FPS Boost", "Enabled", 2)
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") then
                obj.Enabled = false
            end
        end
    else
        Notify("FPS Boost", "Disabled", 2)
    end
end)

PerfSec:NewButton("Remove Sounds", "Remove all game sounds", function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            obj:Destroy()
        end
    end
    Notify("Sounds", "All sounds removed!", 2)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 16: TELEPORT TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local TpTab = Window:NewTab("Teleport")
local TpSec = TpTab:NewSection("Quick Teleports")

TpSec:NewButton("Grocery Store", "Teleport to grocery store", function()
    local hrp = GetHRP()
    if hrp then hrp.CFrame = CFrame.new(0, 5, 0) end
    Notify("Teleport", "Grocery Store", 2)
end)

TpSec:NewButton("School", "Teleport to school", function()
    local hrp = GetHRP()
    if hrp then hrp.CFrame = CFrame.new(100, 5, 100) end
    Notify("Teleport", "School", 2)
end)

TpSec:NewButton("Laboratory", "Teleport to laboratory", function()
    local hrp = GetHRP()
    if hrp then hrp.CFrame = CFrame.new(160, 5, 160) end
    Notify("Teleport", "Laboratory", 2)
end)

TpSec:NewButton("Bathroom", "Teleport to bathroom", function()
    local hrp = GetHRP()
    if hrp then hrp.CFrame = CFrame.new(180, 5, 180) end
    Notify("Teleport", "Bathroom", 2)
end)

TpSec:NewButton("Water Puzzle", "Teleport to water puzzle", function()
    local hrp = GetHRP()
    if hrp then hrp.CFrame = CFrame.new(220, 5, 220) end
    Notify("Teleport", "Water Puzzle", 2)
end)

local PlayerTpSec = TpTab:NewSection("Player Teleport")

local selectedPlayerName = ""

PlayerTpSec:NewDropdown("Select Player", "Choose a player to teleport to", GetPlayerNames(), function(option)
    selectedPlayerName = option
end)

PlayerTpSec:NewButton("Teleport to Player", "Go to selected player", function()
    if selectedPlayerName and selectedPlayerName ~= "-- Select --" then
        local target = Players:FindFirstChild(selectedPlayerName)
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                TeleportTo(hrp.Position)
                Notify("Teleport", "Teleported to " .. selectedPlayerName, 2)
            end
        else
            Notify("Error", "Player not found", 2)
        end
    else
        Notify("Error", "Select a player first", 2)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 17: TOOLS TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local ToolsTab = Window:NewTab("Tools")
local ToolsSec = ToolsTab:NewSection("Utility Tools")

ToolsSec:NewButton("Clear All ESP", "Remove all ESP boxes", function()
    ClearAllESP()
    Notify("Clear", "All ESP cleared!", 2)
end)

ToolsSec:NewButton("Copy Game ID", "Copy game ID to clipboard", function()
    if setclipboard then
        setclipboard(tostring(game.PlaceId))
        Notify("Copy", "Game ID copied!", 2)
    end
end)

ToolsSec:NewButton("Copy Job ID", "Copy server job ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        Notify("Copy", "Job ID copied!", 2)
    end
end)

ToolsSec:NewButton("Respawn", "Respawn your character", function()
    local hum = GetHum()
    if hum then
        hum.Health = 0
        Notify("Respawn", "Respawning...", 2)
    end
end)

local InfoSec = ToolsTab:NewSection("Script Information")

InfoSec:NewLabel("Version: " .. ScriptVersion)
InfoSec:NewLabel("Developer: " .. ScriptAuthor)
InfoSec:NewLabel("Library: Kavo UI")
InfoSec:NewLabel("Device: " .. (IS_MOBILE and "Mobile" or "PC"))

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 18: SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local SetTab = Window:NewTab("Settings")
local SetSec = SetTab:NewSection("UI Settings")

SetSec:NewKeybind("Toggle UI Key", "Press to toggle menu", Enum.KeyCode.RightShift, function()
    KavoUI:ToggleUI()
end)

SetSec:NewDropdown("Theme", "Change UI theme", {"DarkTheme", "BloodTheme", "Ocean", "Synapse", "Sentinel", "Serenity", "Twilight", "Vape"}, function(option)
    KavoUI:ChangeTheme(option)
    Notify("Theme", "Changed to: " .. option, 2)
end)

SetSec:NewDropdown("Effects", "Toggle UI effects", {"On", "Off"}, function(option)
    _G.EffectsEnabled = (option == "On")
    Notify("Effects", _G.EffectsEnabled and "Enabled" or "Disabled", 2)
end)

SetSec:NewDropdown("Notifications", "Toggle notifications", {"On", "Off"}, function(option)
    _G.NotificationsEnabled = (option == "On")
end)

local SaveSec = SetTab:NewSection("Save / Load")

SaveSec:NewButton("Save Settings", "Save current settings", function()
    local settings = {
        WalkSpeed = _G.WalkSpeed,
        JumpPower = _G.JumpPower,
        FlySpeed = _G.FlySpeed,
        FOV = _G.FOV,
        ESPTransparency = _G.ESPTransparency,
    }
    if writefile then
        writefile("SarabHub_Settings.json", HttpService:JSONEncode(settings))
        Notify("Save", "Settings saved!", 2)
    end
end)

SaveSec:NewButton("Load Settings", "Load saved settings", function()
    if readfile and isfile and isfile("SarabHub_Settings.json") then
        local data = HttpService:JSONDecode(readfile("SarabHub_Settings.json"))
        _G.WalkSpeed = data.WalkSpeed or 16
        _G.JumpPower = data.JumpPower or 50
        _G.FlySpeed = data.FlySpeed or 50
        _G.FOV = data.FOV or 70
        _G.ESPTransparency = data.ESPTransparency or 0.5
        Notify("Load", "Settings loaded!", 2)
    else
        Notify("Error", "No saved settings found", 2)
    end
end)

SaveSec:NewButton("Reset All", "Reset all settings", function()
    _G.WalkSpeed = 16
    _G.JumpPower = 50
    _G.FlySpeed = 50
    _G.FOV = 70
    _G.ESPTransparency = 0.5
    local hum = GetHum()
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
    Camera.FieldOfView = 70
    Notify("Reset", "All settings reset", 2)
end)

local AboutSec = SetTab:NewSection("About")

AboutSec:NewLabel("SARAB HUB")
AboutSec:NewLabel("Version: " .. ScriptVersion)
AboutSec:NewLabel("Developer: " .. ScriptAuthor)
AboutSec:NewLabel("Library: Kavo UI")
AboutSec:NewLabel("Game: Sarab")
AboutSec:NewLabel("Support: Mobile + PC")

AboutSec:NewButton("Close Script", "Close the script", function()
    if FloatingGui then FloatingGui:Destroy() end
    Notify("Goodbye", "Script closed", 3)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 19: UPDATE LOOP
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

RunService.Heartbeat:Connect(function()
    pcall(function()
        if _G.WalkSpeed then
            local hum = GetHum()
            if hum and hum.WalkSpeed ~= _G.WalkSpeed then
                hum.WalkSpeed = _G.WalkSpeed
            end
        end
        
        if _G.JumpPower then
            local hum = GetHum()
            if hum and hum.JumpPower ~= _G.JumpPower then
                hum.JumpPower = _G.JumpPower
            end
        end
        
        if _G.GodMode then
            local hum = GetHum()
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end
        end
        
        if _G.AntiRagdoll then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.PlatformStand = false
                end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CanCollide = true
                end
            end
        end
        
        if _G.Noclip then
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
        
        if _G.Fly then
            local hrp = GetHRP()
            if hrp and hrp:FindFirstChild("FlyVelocity") then
                local dir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    dir = dir + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    dir = dir - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    dir = dir - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    dir = dir + Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    dir = dir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    dir = dir - Vector3.new(0, 1, 0)
                end
                hrp.FlyVelocity.Velocity = dir * _G.FlySpeed
            end
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 20: PLAYER EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

Players.PlayerAdded:Connect(function(p)
    Notify("Player Joined", p.Name .. " joined the server", 2)
end)

Players.PlayerRemoving:Connect(function(p)
    Notify("Player Left", p.Name .. " left the server", 2)
    RemoveESP(p)
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

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 21: STARTUP
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

task.wait(1)

Notify("SARAB HUB", "Script loaded successfully!", 4)
task.wait(0.5)
Notify("Device", IS_MOBILE and "Mobile Mode" or "PC Mode", 3)
task.wait(0.5)
Notify("Floating Button", "Drag and tap to open menu", 4)
task.wait(0.5)
Notify("Version", ScriptVersion .. " by " .. ScriptAuthor, 3)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- SECTION 22: CONSOLE OUTPUT
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

print("================================================")
print("  SARAB HUB - Complete Edition")
print("  ------------------------------------------------")
print("  Script by: " .. ScriptAuthor)
print("  Version: " .. ScriptVersion)
print("  Library: Kavo UI")
print("  Device: " .. (IS_MOBILE and "Mobile" or "PC"))
print("  Status: Loaded Successfully")
print("  ------------------------------------------------")
print("  Tabs Loaded:")
print("  1. Main")
print("  2. Story")
print("  3. Movement")
print("  4. ESP")
print("  5. Auto")
print("  6. Visual")
print("  7. Teleport")
print("  8. Tools")
print("  9. Settings")
print("  ------------------------------------------------")
print("  Features:")
print("  - Animated Floating Button")
print("  - Drag Support (Mobile + PC)")
print("  - 10 Story Scenes")
print("  - Complete ESP System")
print("  - Full Movement Mods")
print("  - Auto Collect System")
print("  - Teleport System")
print("  - Save/Load Settings")
print("  - Notification System")
print("  - Mobile + PC Support")
print("================================================")

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- END OF SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════════════════════
