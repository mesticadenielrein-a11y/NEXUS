-- NEXUS GUI
-- Purple / Black Frost Edition
-- Mobile Friendly

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- CUSTOMIZE THESE
local CREATOR = "YOUR_ROBLOX_USERNAME"
local ALYA_IMAGE = "rbxassetid://YOUR_ALYA_IMAGE_ID"

local PURPLE = Color3.fromRGB(145, 90, 220)
local DARK = Color3.fromRGB(13, 11, 20)
local PANEL = Color3.fromRGB(24, 20, 35)
local TEXT = Color3.fromRGB(245, 240, 255)
local MUTED = Color3.fromRGB(165, 155, 185)

-- Remove previous GUI
local old = PlayerGui:FindFirstChild("NEXUS_GUI")
if old then
    old:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "NEXUS_GUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
end

local function stroke(object, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = 0.25
    s.Parent = object
end

local function tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quart),
        properties
    ):Play()
end

-- Main window
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(330, 420)
Main.Position = UDim2.new(0.5, -165, 0.5, -210)
Main.BackgroundColor3 = DARK
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui
corner(Main, 14)
stroke(Main, PURPLE, 1.5)

local Scale = Instance.new("UIScale")
Scale.Scale = 1
Scale.Parent = Main

-- Mobile scaling
local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local viewport = camera.ViewportSize
    Scale.Scale = math.min(
        1,
        viewport.X / 370,
        viewport.Y / 470
    )
end

updateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

-- Background image
local Background = Instance.new("ImageLabel")
Background.Name = "AlyaBackground"
Background.Size = UDim2.fromScale(1, 1)
Background.BackgroundTransparency = 1
Background.Image = ALYA_IMAGE
Background.ImageTransparency = 0.78
Background.ScaleType = Enum.ScaleType.Crop
Background.Parent = Main

local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.fromScale(1, 1)
Overlay.BackgroundColor3 = DARK
Overlay.BackgroundTransparency = 0.12
Overlay.BorderSizePixel = 0
Overlay.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = PANEL
Header.BackgroundTransparency = 0.08
Header.BorderSizePixel = 0
Header.Parent = Main

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, -90, 1, 0)
Logo.Position = UDim2.fromOffset(14, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "N E X U S"
Logo.TextColor3 = TEXT
Logo.TextSize = 19
Logo.Font = Enum.Font.GothamBold
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32, 30)
Close.Position = UDim2.new(1, -42, 0, 9)
Close.BackgroundColor3 = Color3.fromRGB(65, 35, 85)
Close.Text = "X"
Close.TextColor3 = TEXT
Close.Font = Enum.Font.GothamBold
Close.TextSize = 13
Close.Parent = Header
corner(Close, 8)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- Dragging
local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Welcome popup
local Welcome = Instance.new("Frame")
Welcome.Size = UDim2.fromOffset(280, 105)
Welcome.Position = UDim2.new(0.5, -140, 0.5, -52)
Welcome.BackgroundColor3 = Color3.fromRGB(28, 21, 42)
Welcome.BorderSizePixel = 0
Welcome.ZIndex = 10
Welcome.Parent = Main
corner(Welcome, 12)
stroke(Welcome, PURPLE, 1.5)

local WelcomeTitle = Instance.new("TextLabel")
WelcomeTitle.Size = UDim2.new(1, -12, 0, 38)
WelcomeTitle.Position = UDim2.fromOffset(6, 12)
WelcomeTitle.BackgroundTransparency = 1
WelcomeTitle.Text = "Welcome To Nexus Gui"
WelcomeTitle.TextColor3 = TEXT
WelcomeTitle.Font = Enum.Font.GothamBold
WelcomeTitle.TextSize = 17
WelcomeTitle.ZIndex = 11
WelcomeTitle.Parent = Welcome

local WelcomeSub = Instance.new("TextLabel")
WelcomeSub.Size = UDim2.new(1, -12, 0, 25)
WelcomeSub.Position = UDim2.fromOffset(6, 49)
WelcomeSub.BackgroundTransparency = 1
WelcomeSub.Text = "Enjoy The Script Pookie ♡"
WelcomeSub.TextColor3 = Color3.fromRGB(205, 170, 255)
WelcomeSub.Font = Enum.Font.Gotham
WelcomeSub.TextSize = 13
WelcomeSub.ZIndex = 11
WelcomeSub.Parent = Welcome

task.delay(2.5, function()
    if Welcome and Welcome.Parent then
        tween(Welcome, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        Welcome:Destroy()
    end
end)

-- Tabs
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1, -20, 0, 38)
Tabs.Position = UDim2.fromOffset(10, 57)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Main

local function makeTab(name, x)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5, -4, 1, 0)
    button.Position = UDim2.new(x, 0, 0, 0)
    button.BackgroundColor3 = PANEL
    button.Text = name
    button.TextColor3 = TEXT
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = Tabs
    corner(button, 8)
    return button
end

local HomeTab = makeTab("HOME", 0)
local FarmTab = makeTab("ANIMAL FARM", 0.5)

-- Content area
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -108)
Content.Position = UDim2.fromOffset(10, 103)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = PURPLE
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

local Padding = Instance.new("UIPadding")
Padding.PaddingBottom = UDim.new(0, 8)
Padding.Parent = Content

local function clearContent()
    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("GuiObject") and child ~= Layout and child ~= Padding then
            child:Destroy()
        end
    end
end

local function section(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -4, 0, 27)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(195, 160, 245)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Content
end

local function info(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -4, 0, 48)
    label.BackgroundColor3 = PANEL
    label.BackgroundTransparency = 0.08
    label.Text = text
    label.TextColor3 = TEXT
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.Parent = Content
    corner(label, 8)
end

local function makeButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 0, 38)
    button.BackgroundColor3 = PANEL
    button.Text = text
    button.TextColor3 = TEXT
    button.TextSize = 12
    button.Font = Enum.Font.GothamSemibold
    button.Parent = Content
    corner(button, 8)
    stroke(button, Color3.fromRGB(75, 55, 100), 1)

    button.MouseButton1Click:Connect(callback)
    return button
end

local function notify(message)
    local oldToast = Main:FindFirstChild("Toast")
    if oldToast then oldToast:Destroy() end

    local toast = Instance.new("TextLabel")
    toast.Name = "Toast"
    toast.Size = UDim2.new(1, -30, 0, 32)
    toast.Position = UDim2.new(0, 15, 1, -42)
    toast.BackgroundColor3 = Color3.fromRGB(45, 30, 65)
    toast.TextColor3 = TEXT
    toast.Text = message
    toast.TextSize = 11
    toast.Font = Enum.Font.GothamSemibold
    toast.ZIndex = 5
    toast.Parent = Main
    corner(toast, 8)

    task.delay(2, function()
        if toast.Parent then toast:Destroy() end
    end)
end

-- Feature toggle states
local states = {}

local function makeToggle(name)
    states[name] = false

    local button
    button = makeButton(name .. "  [OFF]", function()
        states[name] = not states[name]
        button.Text = name .. (states[name] and "  [ON]" or "  [OFF]")
        button.BackgroundColor3 = states[name] and
            Color3.fromRGB(65, 40, 95) or PANEL

        notify(name .. (states[name] and " enabled" or " disabled"))
    end)
end

local function stopAll()
    for name in pairs(states) do
        states[name] = false
    end

    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("TextButton") then
            local name = child.Text:match("^(.-)%s+%[")
            if name and states[name] ~= nil then
                child.Text = name .. "  [OFF]"
                child.BackgroundColor3 = PANEL
            end
        end
    end

    notify("All toggles turned off")
end

-- Home page
local function showHome()
    clearContent()

    section("WELCOME")
    info("Welcome to NEXUS. Your mobile-friendly control hub.")

    section("CREATOR")
    info("Created by: " .. CREATOR)

    section("NOTICE")
    info("Using this script may put your Roblox account at risk. Use at your own discretion.")

    section("INFORMATION")
    info("Animal Farm controls are currently interface toggles. They need game-specific integration before they can automate gameplay.")
end

-- Animal Farm page
local function showFarm()
    clearContent()

    section("ANIMAL FARM")
    info("Automation controls. Toggles are interface-only until connected to verified game controls.")

    section("FOOD")
    makeToggle("Auto Buy Food")

    section("TRAINING")
    makeToggle("Auto Train")
    makeToggle("Auto Upgrade Training")

    section("THROWING")
    makeToggle("Auto Throw")
    makeToggle("Auto Repeat")

    section("CONTROL")
    makeButton("STOP ALL", stopAll)
end

HomeTab.MouseButton1Click:Connect(function()
    showHome()
end)

FarmTab.MouseButton1Click:Connect(function()
    showFarm()
end)

showHome()
