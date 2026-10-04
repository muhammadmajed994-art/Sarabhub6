--[[
═══════════════════════════════════════════════════════════════════════════════════════════════════
  🕵️ SARAB HUB — Kavo Ultimate Edition 🕵️
  Script by: Muhammad Majed
  Library: Kavo UI
  Version: 10.0.0 (1000+ Lines)
  Support: Mobile + PC
═══════════════════════════════════════════════════════════════════════════════════════════════════
  FEATURES:
  • Auto Collect Evidence
  • Auto Interact with Objects
  • Full Story Guide (10 Scenes)
  • Player Movement Mods (Speed, Jump, Fly, Noclip)
  • Combat Mods (God Mode, Anti Ragdoll, Anti AFK)
  • ESP System (Items, Doors, Monsters, Players)
  • Visual Mods (Full Bright, No Fog, FOV, Clock Time)
  • Utility Tools (Copy Info, Clear ESP, FPS Boost)
  • UI Settings (Theme, Keybind, Effects)
  • Animated Floating Button
  • Notification System
  • Mobile + PC Support
═══════════════════════════════════════════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [1] SERVICES & LIBRARIES
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

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local IS_PC = UserInputService.MouseEnabled
local IS_CONSOLE = UserInputService.GamepadEnabled and not UserInputService.TouchEnabled

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [2] LOAD KAVO UI LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local KavoUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [3] GLOBAL VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

_G.AutoCollect = false
_G.AutoInteract = false
_G.AutoQuest = false
_G.AutoSolve = false
_G.AutoHatch = false
_G.InfiniteJump = false
_G.Fly = false
_G.Noclip = false
_G.GodMode = false
_G.AntiRagdoll = false
_G.AntiAfk = false
_G.AntiFling = false
_G.FullBright = false
_G.ItemESP = false
_G.MonsterESP = false
_G.DoorESP = false
_G.PlayerESP = false
_G.NpcESP = false
_G.ChestESP = false
_G.FPSBoost = false
_G.NoFog = false
_G.NoShadows = false
_G.FlySpeed = 50
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.ESPColor = Color3.fromRGB(255, 0, 0)
_G.FOV = 70
_G.InteractRange = 15
_G.AutoCollectDelay = 0.5
_G.EFFECTS_ENABLED = true
_G.SHOW_NOTIFICATIONS = true
_G.ClockTime = 12
_G.ESPThickness = 0.5
_G.TeleportDelay = 0.5

local BTN_SIZE = IS_MOBILE and 65 or 60
local BTN_POS = IS_MOBILE and UDim2.new(0, 20, 0.35, -32) or UDim2.new(0, 30, 0.4, -30)

local ScriptVersion = "10.0.0"
local ScriptName = "SARAB HUB"
local ScriptAuthor = "Muhammad Majed"

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [4] STORY DATA (10 SCENES)
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local StoryScenes = {
    {
        id = 1,
        title = "🏪 البقالة",
        objective = "جمع الأغراض والتحدث مع الشخصية",
        details = "تبدأ كشخصية داخل البقالة، ويكون عندك طلب عادي لجمع مجموعة من الأغراض. المطلوب هو تنفيذ المهمة الحالية والتحدث مع الشخصية الموجودة هناك.",
        position = Vector3.new(0, 5, 0),
        completed = false,
    },
    {
        id = 2,
        title = "🔑 مفتاح المدرسة",
        objective = "الحصول على مفتاح المدرسة من العامل",
        details = "بعد إنهاء طلب البقالة، يتغير الهدف إلى الحصول على مفتاح المدرسة من العامل. بعدها تبدأ الرحلة باتجاه المدرسة.",
        position = Vector3.new(50, 5, 50),
        completed = false,
    },
    {
        id = 3,
        title = "🏫 المدرسة",
        objective = "فك السلسلة والدخول",
        details = "عند الوصول، تجد مدخلًا مقيدًا بسلسلة. بعد التعامل معه والدخول، تتحول اللعبة من مهمة عادية إلى تحقيق في شيء غريب يحدث داخل المدرسة.",
        position = Vector3.new(100, 5, 100),
        completed = false,
    },
    {
        id = 4,
        title = "📜 بداية اللغز",
        objective = "فحص المكان وقراءة الأوراق",
        details = "تبدأ في فحص المكان وقراءة الأوراق والملاحظات بدل الاعتماد على الحوار فقط. إحدى الأوراق الموجودة داخل المدرسة يمكن التفاعل معها وقراءتها.",
        position = Vector3.new(120, 5, 120),
        completed = false,
    },
    {
        id = 5,
        title = "👨‍🏫 ناصر وعبدالله",
        objective = "البحث عن معلومات حولهما",
        details = "هنا تبدأ القصة الحقيقية في الظهور. يتم الحديث عن ناصر، مدرس الكيمياء، وعن عبدالله ومقتنياته التي كانت موجودة في مكتبه. الشخصيات تتحدث أيضًا عن تصرفات ناصر الغريبة وغيابه.",
        position = Vector3.new(140, 5, 140),
        completed = false,
    },
    {
        id = 6,
        title = "🧪 المختبر",
        objective = "استكشاف مختبر الكيمياء",
        details = "الحديث يقودك إلى مختبر الكيمياء، خصوصًا إلى الباب المغلق الذي كان ناصر يقضي وقتًا خلفه. داخل هذا الجزء توجد صور ورموز وألوان وملاحظة تساعد في اللغز.",
        position = Vector3.new(160, 5, 160),
        completed = false,
    },
    {
        id = 7,
        title = "📝 الملاحظة والحمام",
        objective = "قراءة الملاحظة المرتبطة بتجربة ناصر",
        details = "تظهر ملاحظة مرتبطة بتجربة ناصر، وتذكر أيضًا أشياء غريبة يراها بعض الأشخاص وتحذيرًا متعلقًا بإهدار المياه. هذه الملاحظة تضيف معلومات للقصة، لكنها لا تثبت وحدها ما حدث أو من المسؤول.",
        position = Vector3.new(180, 5, 180),
        completed = false,
    },
    {
        id = 8,
        title = "📱 رسالة غامضة",
        objective = "تحليل الرسالة المجهولة",
        details = "تظهر رسالة من شخص مجهول تفيد بأن اللاعبين/الشخصيات تتم مراقبتهم. الرسالة تزيد الإحساس بأن هناك شخصًا يتابع ما يحدث، لكن المصدر لا يثبت أن هناك نظام مراقبة أو شخصية معينة وراء الرسالة.",
        position = Vector3.new(200, 5, 200),
        completed = false,
    },
    {
        id = 9,
        title = "💧 لغز مصادر المياه",
        objective = "التعامل مع الصمامات وحل اللغز",
        details = "تصل القصة إلى جزء آخر من المدرسة مرتبط بمصادر المياه والصمامات. المهمة تتطلب التعامل مع عدة مصادر، وهناك رسم وتعليمات مرتبطة باللغز.",
        position = Vector3.new(220, 5, 220),
        completed = false,
    },
    {
        id = 10,
        title = "❓ الحقيقة غير المكتملة",
        objective = "جمع كل الأدلة للوصول للحقيقة",
        details = "من هنا تبدأ المعلومات تصبح أقل وضوحًا. المعروف أن أحداث المدرسة مرتبطة بالغموض حول ناصر وعبدالله والمختبر، لكن لا يوجد حتى الآن توثيق موثوق يكشف كل الحقيقة أو النهاية الحالية بالكامل.",
        position = Vector3.new(240, 5, 240),
        completed = false,
    },
}

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [5] HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

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
    box.Transparency = _G.ESPThickness
    box.Color3 = color or _G.ESPColor
    box.Parent = obj
end

local function ClearAllESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("SarabESP") then
            obj.SarabESP:Destroy()
        end
    end
end

local function RemoveESP(obj)
    if obj and obj:FindFirstChild("SarabESP") then
        obj.SarabESP:Destroy()
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

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [6] EFFECTS ENGINE
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

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

function Effects.Glow(obj, color, speed)
    if not _G.EFFECTS_ENABLED or not obj then return nil end
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(100, 150, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = obj
    task.spawn(function()
        while obj and obj.Parent and _G.EFFECTS_ENABLED do
            TweenService:Create(stroke, TweenInfo.new(speed or 1, Enum.EasingStyle.Sine), {Transparency = 0, Thickness = 3}):Play()
            task.wait(speed or 1)
            if not obj or not obj.Parent then break end
            TweenService:Create(stroke, TweenInfo.new(speed or 1, Enum.EasingStyle.Sine), {Transparency = 0.6, Thickness = 2}):Play()
            task.wait(speed or 1)
        end
    end)
    return stroke
end

function Effects.FadeIn(obj, duration)
    if not _G.EFFECTS_ENABLED or not obj then return end
    obj.BackgroundTransparency = 1
    TweenService:Create(obj, TweenInfo.new(duration or 0.5), {BackgroundTransparency = 0}):Play()
end

function Effects.Pop(obj, scale, duration)
    if not _G.EFFECTS_ENABLED or not obj then return end
    local origSize = obj.Size
    local targetSize = UDim2.new(
        origSize.X.Scale * scale, origSize.X.Offset * scale,
        origSize.Y.Scale * scale, origSize.Y.Offset * scale
    )
    TweenService:Create(obj, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    task.wait(duration or 0.15)
    TweenService:Create(obj, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = origSize}):Play()
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [7] CREATE KAVO WINDOW
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local Window = KavoUI.CreateLib("SARAB HUB | Kavo Ultimate", "DarkTheme")

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [8] NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local function Notify(title, text, duration)
    if not _G.SHOW_NOTIFICATIONS then return end
    pcall(function()
        KavoUI:Notification({
            Title = title,
            Text = text,
            Duration = duration or 3,
        })
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [9] ANIMATED FLOATING BUTTON
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
FloatingButton.Text = "M"
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
glow.Size = UDim2.new(1, 30, 1, 30)
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

-- Slide In Animation
FloatingButton.Position = UDim2.new(-0.2, 0, BTN_POS.Y.Scale, BTN_POS.Y.Offset)
task.wait(0.3)
TweenService:Create(FloatingButton, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = BTN_POS}):Play()

-- Glow Pulse
task.spawn(function()
    while FloatingButton and FloatingButton.Parent do
        TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
            Size = UDim2.new(1, 40, 1, 40),
            BackgroundTransparency = 0.7,
        }):Play()
        task.wait(1.2)
        if not FloatingButton or not FloatingButton.Parent then break end
        TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
            Size = UDim2.new(1, 30, 1, 30),
            BackgroundTransparency = 0.85,
        }):Play()
        task.wait(1.2)
    end
end)

-- Gradient Rotation
task.spawn(function()
    while FloatingButton and FloatingButton.Parent do
        for i = 0, 360, 10 do
            if not FloatingButton or not FloatingButton.Parent then break end
            grad.Rotation = i
            task.wait(0.03)
        end
    end
end)

-- Handle Click
local function HandleFloatingClick()
    Effects.Ripple(FloatingButton, Color3.fromRGB(100, 200, 255))
    Effects.Particles(FloatingButton, Color3.fromRGB(100, 200, 255), 8)
    Effects.Shake(FloatingButton, 3, 0.15)
    pcall(function() KavoUI:ToggleUI() end)
end

FloatingButton.MouseButton1Click:Connect(function()
    if IS_PC then HandleFloatingClick() end
end)

FloatingButton.TouchTap:Connect(function()
    if IS_MOBILE then HandleFloatingClick() end
end)

-- PC Keybind
if IS_PC then
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            HandleFloatingClick()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [10] MAIN TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local MainTab = Window:NewTab("🏠 Home")
local MainSec = MainTab:NewSection("Player Information")

MainSec:NewLabel("👤 Player: " .. LocalPlayer.Name)
MainSec:NewLabel("🆔 User ID: " .. LocalPlayer.UserId)
MainSec:NewLabel("📱 Device: " .. (IS_MOBILE and "Mobile 📱" or IS_PC and "PC 💻" or "Console 🎮"))
MainSec:NewLabel("📅 Time: " .. os.date("%Y-%m-%d %H:%M:%S"))
MainSec:NewLabel("🎮 Game: " .. game.PlaceId)
MainSec:NewLabel("📌 Version: " .. ScriptVersion)

MainSec:NewDivider()

local CreditSec = MainTab:NewSection("Credits")
CreditSec:NewLabel("👨‍💻 Developer: " .. ScriptAuthor)
CreditSec:NewLabel("📚 Library: Kavo UI")
CreditSec:NewLabel("🎯 Purpose: Sarab Game Assistant")

MainSec:NewDivider()

MainSec:NewButton("📋 Copy Account Info", "Copy your account info to clipboard", function()
    if setclipboard then
        local info = "Name: " .. LocalPlayer.Name .. " | ID: " .. LocalPlayer.UserId
        setclipboard(info)
        Notify("📋 Copied", "Account info copied!", 2)
    end
end)

MainSec:NewButton("🔄 Rejoin Server", "Rejoin the current server", function()
    Notify("🔄 Rejoining", "Please wait...", 2)
    task.wait(1)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

MainSec:NewButton("🚪 Leave Game", "Leave the current game", function()
    LocalPlayer:Kick("Left via SARAB HUB")
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [11] STORY TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local StoryTab = Window:NewTab("📖 Story")
local StorySec = StoryTab:NewSection("Story Guide - 10 Scenes")

StorySec:NewLabel("🎬 Sarab - Story in Order")
StorySec:NewLabel("Click any scene to teleport")

for _, scene in ipairs(StoryScenes) do
    local sTitle = scene.title
    local sObj = scene.objective
    local sDet = scene.details
    local sPos = scene.position
    
    StorySec:NewButton(sTitle, sObj, function()
        TeleportTo(sPos)
        Notify("📍 Teleport", "Moved to: " .. sTitle, 2)
        task.wait(0.3)
        Notify("📝 Details", sDet, 6)
    end)
end

StorySec:NewDivider()

StorySec:NewButton("📜 Copy Full Story", "Copy the complete story to clipboard", function()
    local fullStory = "═══════════════════════════════\n"
    fullStory = fullStory .. "🎬 SARAB - FULL STORY\n"
    fullStory = fullStory .. "═══════════════════════════════\n\n"
    for _, scene in ipairs(StoryScenes) do
        fullStory = fullStory .. scene.title .. "\n"
        fullStory = fullStory .. "🎯 Objective: " .. scene.objective .. "\n"
        fullStory = fullStory .. "📝 " .. scene.details .. "\n\n"
        fullStory = fullStory .. "───────────────────────────────\n\n"
    end
    if setclipboard then
        setclipboard(fullStory)
        Notify("📜 Story", "Full story copied to clipboard!", 3)
    end
end)

StorySec:NewButton("🔄 Reset Progress", "Reset all scenes progress", function()
    for _, scene in ipairs(StoryScenes) do
        scene.completed = false
    end
    Notify("🔄 Reset", "Story progress reset!", 2)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [12] AUTO COLLECT TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local CollectTab = Window:NewTab("📦 Collect")
local CollectSec = CollectTab:NewSection("Auto Collect Evidence")

CollectSec:NewToggle("📦 Auto Collect Evidence", "Collect all evidence and notes automatically", function(state)
    _G.AutoCollect = state
    if state then
        Notify("📦 Auto Collect", "Enabled", 2)
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
    else
        Notify("📦 Auto Collect", "Disabled", 2)
    end
end)

CollectSec:NewToggle("🔍 Auto Interact", "Interact with doors, notes and objects", function(state)
    _G.AutoInteract = state
    if state then
        Notify("🔍 Auto Interact", "Enabled", 2)
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
    else
        Notify("🔍 Auto Interact", "Disabled", 2)
    end
end)

CollectSec:NewToggle("🎯 Auto Solve Puzzles", "Try to solve puzzles automatically", function(state)
    _G.AutoSolve = state
    if state then
        Notify("🎯 Auto Solve", "Enabled", 2)
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
        Notify("🎯 Auto Solve", "Disabled", 2)
    end
end)

CollectSec:NewSlider("📏 Interact Range", "Distance for interaction", 50, 5, function(v)
    _G.InteractRange = v
end)

CollectSec:NewSlider("⏱️ Collect Delay", "Time between each collect", 2, 0.1, function(v)
    _G.AutoCollectDelay = v
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [13] MOVEMENT TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local MoveTab = Window:NewTab("⚡ Movement")
local MoveSec = MoveTab:NewSection("Speed Mods")

MoveSec:NewSlider("🚀 Walk Speed", "Change your walking speed", 500, 16, function(v)
    _G.WalkSpeed = v
    local hum = GetHum()
    if hum then hum.WalkSpeed = v end
end)

MoveSec:NewSlider("🦘 Jump Power", "Change your jump power", 500, 50, function(v)
    _G.JumpPower = v
    local hum = GetHum()
    if hum then hum.JumpPower = v hum.UseJumpPower = true end
end)

MoveSec:NewToggle("♾️ Infinite Jump", "Jump infinitely in air", function(state)
    _G.InfiniteJump = state
    if state then
        Notify("♾️ Inf Jump", "Enabled", 2)
        UserInputService.JumpRequest:Connect(function()
            if _G.InfiniteJump then
                local hum = GetHum()
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    else
        Notify("♾️ Inf Jump", "Disabled", 2)
    end
end)

MoveSec:NewDivider()

local FlySec = MoveTab:NewSection("Flight Mods")

FlySec:NewToggle("✈️ Fly", "Enable flying mode", function(state)
    _G.Fly = state
    if state then
        Notify("✈️ Fly", "Enabled", 2)
        local hrp = GetHRP()
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp
        end
    else
        Notify("✈️ Fly", "Disabled", 2)
        local hrp = GetHRP()
        if hrp and hrp:FindFirstChild("FlyVelocity") then
            hrp.FlyVelocity:Destroy()
        end
    end
end)

FlySec:NewSlider("⚡ Fly Speed", "Flying speed", 500, 10, function(v)
    _G.FlySpeed = v
end)

FlySec:NewDivider()

local PhysSec = MoveTab:NewSection("Physics Mods")

PhysSec:NewToggle("🚶 Noclip", "Walk through walls", function(state)
    _G.Noclip = state
    Notify("🚶 Noclip", state and "Enabled" or "Disabled", 2)
end)

PhysSec:NewToggle("🛡️ God Mode", "Prevent taking damage", function(state)
    _G.GodMode = state
    if state then
        Notify("🛡️ God Mode", "Enabled", 2)
        local hum = GetHum()
        if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
    else
        Notify("🛡️ God Mode", "Disabled", 2)
    end
end)

PhysSec:NewToggle("🦴 Anti Ragdoll", "Prevent ragdolling", function(state)
    _G.AntiRagdoll = state
    Notify("🦴 Anti Ragdoll", state and "Enabled" or "Disabled", 2)
end)

PhysSec:NewToggle("💤 Anti AFK", "Prevent AFK kick", function(state)
    _G.AntiAfk = state
    if state then
        Notify("💤 Anti AFK", "Enabled", 2)
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        Notify("💤 Anti AFK", "Disabled", 2)
    end
end)

PhysSec:NewToggle("🌀 Anti Fling", "Prevent getting flung", function(state)
    _G.AntiFling = state
    Notify("🌀 Anti Fling", state and "Enabled" or "Disabled", 2)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [14] ESP TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local EspTab = Window:NewTab("👁️ ESP")
local EspSec = EspTab:NewSection("ESP Options")

EspSec:NewToggle("📦 Item ESP", "Highlight all items and notes", function(state)
    _G.ItemESP = state
    if state then
        Notify("📦 Item ESP", "Enabled", 2)
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
        Notify("📦 Item ESP", "Disabled", 2)
        ClearAllESP()
    end
end)

EspSec:NewToggle("🚪 Door ESP", "Highlight all doors", function(state)
    _G.DoorESP = state
    if state then
        Notify("🚪 Door ESP", "Enabled", 2)
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
        Notify("🚪 Door ESP", "Disabled", 2)
        ClearAllESP()
    end
end)

EspSec:NewToggle("👹 Monster ESP", "Highlight all monsters and entities", function(state)
    _G.MonsterESP = state
    if state then
        Notify("👹 Monster ESP", "Enabled", 2)
        task.spawn(function()
            while _G.MonsterESP do
                task.wait(0.5)
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("monster") or obj.Name:lower():find("ghost") or obj.Name:lower():find("entity")) then
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        if hrp then CreateESP(hrp, Color3.fromRGB(255, 0, 0)) end
                    end
                end
            end
        end)
    else
        Notify("👹 Monster ESP", "Disabled", 2)
        ClearAllESP()
    end
end)

EspSec:NewToggle("👤 Player ESP", "Highlight all players", function(state)
    _G.PlayerESP = state
    if state then
        Notify("👤 Player ESP", "Enabled", 2)
        task.spawn(function()
            while _G.PlayerESP do
                task.wait(0.5)
                for _, p in ipairs(GetAllPlayers()) do
                    if p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then CreateESP(hrp, Color3.fromRGB(0, 200, 255)) end
                    end
                end
            end
        end)
    else
        Notify("👤 Player ESP", "Disabled", 2)
        ClearAllESP()
    end
end)

EspSec:NewToggle("👥 NPC ESP", "Highlight all NPCs", function(state)
    _G.NpcESP = state
    if state then
        Notify("👥 NPC ESP", "Enabled", 2)
        task.spawn(function()
            while _G.NpcESP do
                task.wait(0.5)
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                        local hrp = obj:FindFirstChild("HumanoidRootPart")
                        if hrp then CreateESP(hrp, Color3.fromRGB(255, 165, 0)) end
                    end
                end
            end
        end)
    else
        Notify("👥 NPC ESP", "Disabled", 2)
        ClearAllESP()
    end
end)

EspSec:NewColorPicker("🎨 ESP Color", "Change ESP color", Color3.fromRGB(255, 0, 0), function(color)
    _G.ESPColor = color
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("SarabESP") then
            obj.SarabESP.Color3 = color
        end
    end
end)

EspSec:NewSlider("📏 ESP Transparency", "ESP box transparency", 1, 0, function(v)
    _G.ESPThickness = v
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("SarabESP") then
            obj.SarabESP.Transparency = v
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [15] VISUAL TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local VisualTab = Window:NewTab("🎨 Visual")
local VisualSec = VisualTab:NewSection("Lighting Mods")

VisualSec:NewToggle("🌞 Full Bright", "Increase game brightness", function(state)
    _G.FullBright = state
    if state then
        Notify("🌞 Full Bright", "Enabled", 2)
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
    else
        Notify("🌞 Full Bright", "Disabled", 2)
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        Lighting.Brightness = 1
    end
end)

VisualSec:NewToggle("🌫️ No Fog", "Remove fog from game", function(state)
    _G.NoFog = state
    if state then
        Notify("🌫️ No Fog", "Enabled", 2)
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    else
        Notify("🌫️ No Fog", "Disabled", 2)
    end
end)

VisualSec:NewToggle("🌑 No Shadows", "Remove shadows for performance", function(state)
    _G.NoShadows = state
    if state then
        Notify("🌑 No Shadows", "Enabled", 2)
        Lighting.GlobalShadows = false
    else
        Notify("🌑 No Shadows", "Disabled", 2)
        Lighting.GlobalShadows = true
    end
end)

VisualSec:NewSlider("🕐 Clock Time", "Change game time", 24, 0, function(v)
    _G.ClockTime = v
    Lighting.ClockTime = v
end)

VisualSec:NewSlider("📷 FOV", "Camera field of view", 120, 30, function(v)
    _G.FOV = v
    Camera.FieldOfView = v
end)

VisualSec:NewButton("🔄 Reset Lighting", "Reset lighting to default", function()
    Lighting.Ambient = Color3.fromRGB(70, 70, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    Lighting.Brightness = 1
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = true
    Notify("🔄 Reset", "Lighting reset to default", 2)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [16] TOOLS TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local ToolsTab = Window:NewTab("🛠️ Tools")
local ToolsSec = ToolsTab:NewSection("Utility Tools")

ToolsSec:NewButton("🗑️ Clear All ESP", "Remove all ESP boxes", function()
    ClearAllESP()
    Notify("🗑️ Clear ESP", "All ESP cleared!", 2)
end)

ToolsSec:NewButton("🔄 Rejoin Server", "Rejoin current server", function()
    Notify("🔄 Rejoin", "Rejoining...", 2)
    task.wait(1)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

ToolsSec:NewButton("📋 Copy Game ID", "Copy game PlaceId", function()
    if setclipboard then
        setclipboard(tostring(game.PlaceId))
        Notify("📋 Copied", "Game ID copied!", 2)
    end
end)

ToolsSec:NewButton("🎯 Respawn Character", "Respawn your character", function()
    local hum = GetHum()
    if hum then
        hum.Health = 0
        Notify("🎯 Respawn", "Respawning...", 2)
    end
end)

ToolsSec:NewDivider()

local PerfSec = ToolsTab:NewSection("Performance")

PerfSec:NewToggle("📊 FPS Boost", "Improve game performance", function(state)
    _G.FPSBoost = state
    if state then
        Notify("📊 FPS Boost", "Enabled", 2)
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") then
                obj.Enabled = false
            end
        end
    else
        Notify("📊 FPS Boost", "Disabled", 2)
    end
end)

PerfSec:NewButton("🔊 Remove Sounds", "Remove all game sounds", function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            obj:Destroy()
        end
    end
    Notify("🔊 Sounds", "All sounds removed!", 2)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [17] TELEPORT TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local TpTab = Window:NewTab("🚀 Teleport")
local TpSec = TpTab:NewSection("Quick Teleports")

TpSec:NewButton("🏪 Grocery Store", "Teleport to grocery store", function()
    TeleportTo(Vector3.new(0, 5, 0))
    Notify("📍", "Teleported to Grocery", 2)
end)

TpSec:NewButton("🏫 School", "Teleport to school", function()
    TeleportTo(Vector3.new(100, 5, 100))
    Notify("📍", "Teleported to School", 2)
end)

TpSec:NewButton("🧪 Laboratory", "Teleport to laboratory", function()
    TeleportTo(Vector3.new(160, 5, 160))
    Notify("📍", "Teleported to Laboratory", 2)
end)

TpSec:NewButton("💧 Water Puzzle", "Teleport to water puzzle", function()
    TeleportTo(Vector3.new(220, 5, 220))
    Notify("📍", "Teleported to Water Puzzle", 2)
end)

TpSec:NewDivider()

local PlayerTpSec = TpTab:NewSection("Player Teleport")

local selectedPlayerName = ""

PlayerTpSec:NewDropdown("Select Player", "Choose a player to teleport to", (function()
    local list = {"-- Select --"}
    for _, p in ipairs(GetAllPlayers()) do
        table.insert(list, p.Name)
    end
    return list
end)(), function(option)
    selectedPlayerName = option
end)

PlayerTpSec:NewButton("📍 Teleport to Player", "Go to selected player", function()
    if selectedPlayerName and selectedPlayerName ~= "-- Select --" then
        local target = Players:FindFirstChild(selectedPlayerName)
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                TeleportTo(hrp.Position)
                Notify("📍", "Teleported to " .. selectedPlayerName, 2)
            end
        else
            Notify("❌", "Player not found", 2)
        end
    else
        Notify("❌", "Select a player first", 2)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [18] SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

local SetTab = Window:NewTab("⚙️ Settings")
local SetSec = SetTab:NewSection("UI Settings")

SetSec:NewKeybind("⌨️ Toggle UI Key", "Press to toggle menu", Enum.KeyCode.RightShift, function()
    KavoUI:ToggleUI()
end)

SetSec:NewDropdown("🎨 Theme", "Change UI theme", {"DarkTheme", "BloodTheme", "Ocean", "Sentinel", "Synapse", "Serenity", "Twilight", "Vape"}, function(option)
    KavoUI:ChangeTheme(option)
    Notify("🎨 Theme", "Changed to: " .. option, 2)
end)

SetSec:NewDropdown("✨ Effects", "Toggle UI effects", {"On", "Off"}, function(option)
    _G.EFFECTS_ENABLED = (option == "On")
    Notify("✨ Effects", _G.EFFECTS_ENABLED and "Enabled" or "Disabled", 2)
end)

SetSec:NewDropdown("🔔 Notifications", "Toggle notifications", {"On", "Off"}, function(option)
    _G.SHOW_NOTIFICATIONS = (option == "On")
    Notify("🔔", _G.SHOW_NOTIFICATIONS and "Enabled" or "Disabled", 2)
end)

SetSec:NewDivider()

local InfoSec = SetTab:NewSection("Script Information")
InfoSec:NewLabel("📌 Version: " .. ScriptVersion)
InfoSec:NewLabel("👨‍💻 Developer: " .. ScriptAuthor)
InfoSec:NewLabel("📚 Library: Kavo UI")
InfoSec:NewLabel("🎯 Game: Sarab")
InfoSec:NewLabel("📱 Support: Mobile + PC")

SetSec:NewDivider()

SetSec:NewButton("💾 Save Settings", "Save current settings", function()
    local settings = {
        WalkSpeed = _G.WalkSpeed,
        JumpPower = _G.JumpPower,
        FlySpeed = _G.FlySpeed,
        FOV = _G.FOV,
        ESPColor = tostring(_G.ESPColor),
    }
    if writefile then
        writefile("SarabHub_Settings.json", HttpService:JSONEncode(settings))
        Notify("💾 Save", "Settings saved!", 2)
    end
end)

SetSec:NewButton("📂 Load Settings", "Load saved settings", function()
    if readfile and isfile and isfile("SarabHub_Settings.json") then
        local data = HttpService:JSONDecode(readfile("SarabHub_Settings.json"))
        _G.WalkSpeed = data.WalkSpeed or 16
        _G.JumpPower = data.JumpPower or 50
        _G.FlySpeed = data.FlySpeed or 50
        _G.FOV = data.FOV or 70
        Notify("📂 Load", "Settings loaded!", 2)
    else
        Notify("❌", "No saved settings found", 2)
    end
end)

SetSec:NewButton("👋 Close Script", "Close the entire script", function()
    if FloatingGui then FloatingGui:Destroy() end
    Notify("👋", "Script closed. Goodbye!", 3)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [19] UPDATE LOOP
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

RunService.Heartbeat:Connect(function(dt)
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
--  [20] PLAYER EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

Players.PlayerAdded:Connect(function(p)
    Notify("👋 New Player", p.Name .. " joined the server", 2)
end)

Players.PlayerRemoving:Connect(function(p)
    Notify("👋 Player Left", p.Name .. " left the server", 2)
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
--  [21] STARTUP SEQUENCE
-- ═══════════════════════════════════════════════════════════════════════════════════════════════

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

task.wait(1)

-- Startup Notifications
Notify("🕵️ SARAB HUB", "Script loaded successfully!", 4)
task.wait(0.5)
Notify("📱 Device", IS_MOBILE and "Mobile Mode 📱" or IS_PC and "PC Mode 💻" or "Console Mode 🎮", 3)
task.wait(0.5)
Notify("🧠 Floating Button", IS_MOBILE and "Tap the floating M icon" or "Click M or press RightShift", 5)
task.wait(0.5)
Notify("📖 Story Guide", "Open 'Story' tab for full walkthrough", 4)
task.wait(0.5)
Notify("✅ Version", "v" .. ScriptVersion .. " by " .. ScriptAuthor, 3)

-- Console Output
print("═══════════════════════════════════════════")
print("  🕵️ SARAB HUB — Kavo Ultimate Edition")
print("  ═══════════════════════════════════════")
print("  👨‍💻 Developer: " .. ScriptAuthor)
print("  📚 Library: Kavo UI")
print("  📌 Version: " .. ScriptVersion)
print("  🎮 Game: Sarab")
print("  📱 Device: " .. (IS_MOBILE and "Mobile" or IS_PC and "PC" or "Console"))
print("  ✅ Status: Loaded Successfully")
print("═══════════════════════════════════════════")
print("  🎯 Features Loaded:")
print("  • Auto Collect")
print("  • Auto Interact")
print("  • Auto Solve")
print("  • Movement Mods")
print("  • Flight System")
print("  • ESP System")
print("  • Visual Mods")
print("  • Story Guide")
print("  • Teleport System")
print("  • UI Settings")
print("═══════════════════════════════════════════")

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
--  [22] END OF SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════════════════════
