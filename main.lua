--[[
    NEXUS | FROST EDITION V2
    Creator: bloxfruit782gh
    Private local build
    Original Alya floating icon preserved
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local CREATOR = "bloxfruit782gh"
local ALYA_IMAGE = "rbxassetid://113429355768131"

-- FROST PALETTE
local T = {
    bg = Color3.fromRGB(5, 13, 24),
    panel = Color3.fromRGB(9, 25, 42),
    panel2 = Color3.fromRGB(13, 36, 57),
    card = Color3.fromRGB(15, 44, 67),
    cardHover = Color3.fromRGB(22, 62, 88),
    ice = Color3.fromRGB(104, 211, 255),
    light = Color3.fromRGB(197, 239, 255),
    white = Color3.fromRGB(240, 250, 255),
    gray = Color3.fromRGB(145, 180, 201),
    muted = Color3.fromRGB(91, 132, 157),
    green = Color3.fromRGB(104, 230, 181),
    red = Color3.fromRGB(255, 116, 137)
}

local old = PlayerGui:FindFirstChild("NEXUS")
if old then old:Destroy() end

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function outline(obj, color, thickness, transparency)
    return make("UIStroke", {
        Color = color or T.ice,
        Thickness = thickness or 1,
        Transparency = transparency or 0.35
    }, obj)
end

local function gradient(obj, c1, c2, rotation)
    return make("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(1, c2)
        }),
        Rotation = rotation or 0
    }, obj)
end

local function tween(obj, props, duration, style)
    local animation = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.25,
            style or Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        props
    )
    animation:Play()
    return animation
end

local GUI = make("ScreenGui", {
    Name = "NEXUS",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 100
}, PlayerGui)

-- MAIN WINDOW
local Main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(540, 390),
    Position = UDim2.new(0.5, -270, 0.5, -195),
    BackgroundColor3 = T.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Visible = false
}, GUI)
round(Main, 17)
outline(Main, T.ice, 1.4, 0.22)
gradient(Main, Color3.fromRGB(8, 25, 42), Color3.fromRGB(4, 11, 22), 35)

local Scale = make("UIScale", {Scale = 1}, Main)

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local size = camera.ViewportSize
    Scale.Scale = math.min(1, size.X / 570, size.Y / 430)
end

updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

-- FROST AMBIENT LIGHT
local glow = make("Frame", {
    Name = "FrostGlow",
    Size = UDim2.new(1, 0, 0, 3),
    BackgroundColor3 = T.ice,
    BorderSizePixel = 0,
    ZIndex = 8
}, Main)
gradient(glow, Color3.fromRGB(65, 169, 255), Color3.fromRGB(204, 248, 255), 0)

-- HEADER
local Header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 55),
    BackgroundColor3 = T.panel,
    BorderSizePixel = 0,
    ZIndex = 3
}, Main)
gradient(Header, Color3.fromRGB(15, 48, 72), Color3.fromRGB(8, 24, 42), 0)

make("TextLabel", {
    Size = UDim2.fromOffset(205, 30),
    Position = UDim2.fromOffset(18, 7),
    BackgroundTransparency = 1,
    Text = "N E X U S",
    TextColor3 = T.light,
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4
}, Header)

make("TextLabel", {
    Size = UDim2.fromOffset(180, 15),
    Position = UDim2.fromOffset(19, 34),
    BackgroundTransparency = 1,
    Text = "F R O S T   E D I T I O N",
    TextColor3 = T.ice,
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4
}, Header)

-- DRAGGING
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

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- FLOATING ALYA ICON
-- Preserved: same asset, circular shape, size, position and float animation.
local Icon = make("ImageButton", {
    Name = "AlyaIcon",
    Size = UDim2.fromOffset(62, 62),
    Position = UDim2.new(0, 18, 0.5, -31),
    BackgroundColor3 = T.panel,
    Image = ALYA_IMAGE,
    ScaleType = Enum.ScaleType.Crop,
    Visible = true,
    AutoButtonColor = false
}, GUI)
round(Icon, 50)
outline(Icon, T.ice, 2, 0.12)

local iconScale = make("UIScale", {Scale = 1}, Icon)

task.spawn(function()
    while GUI.Parent do
        if Icon.Visible then
            tween(Icon, {
                Position = Icon.Position + UDim2.fromOffset(0, -5)
            }, 1, Enum.EasingStyle.Sine)
            task.wait(1)
            tween(Icon, {
                Position = Icon.Position + UDim2.fromOffset(0, 5)
            }, 1, Enum.EasingStyle.Sine)
            task.wait(1)
        else
            task.wait(0.2)
        end
    end
end)

-- OPEN / MINIMIZE
local function openGUI()
    Main.Visible = true
    Icon.Visible = false
    Main.BackgroundTransparency = 1
    Scale.Scale = 0.86
    tween(Main, {BackgroundTransparency = 0}, 0.3)
    tween(Scale, {Scale = 1}, 0.35, Enum.EasingStyle.Back)
end

local function minimizeGUI()
    tween(Scale, {Scale = 0.85}, 0.2)
    tween(Main, {BackgroundTransparency = 1}, 0.2)
    task.wait(0.22)
    Main.Visible = false
    Main.BackgroundTransparency = 0
    Scale.Scale = 1
    Icon.Visible = true
end

Icon.Activated:Connect(openGUI)

-- MINIMIZE BUTTON
local Minimize = make("TextButton", {
    Size = UDim2.fromOffset(31, 29),
    Position = UDim2.new(1, -43, 0, 13),
    BackgroundColor3 = T.card,
    Text = "—",
    TextColor3 = T.light,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    AutoButtonColor = false,
    ZIndex = 6
}, Header)
round(Minimize, 9)
outline(Minimize, T.ice, 0.8, 0.5)
Minimize.Activated:Connect(minimizeGUI)

-- SIDEBAR
local Sidebar = make("Frame", {
    Size = UDim2.new(0, 128, 1, -77),
    Position = UDim2.fromOffset(10, 64),
    BackgroundColor3 = T.panel,
    BorderSizePixel = 0,
    ZIndex = 3
}, Main)
round(Sidebar, 13)
outline(Sidebar, T.ice, 0.7, 0.78)

make("TextLabel", {
    Size = UDim2.new(1, -18, 0, 24),
    Position = UDim2.fromOffset(9, 9),
    BackgroundTransparency = 1,
    Text = "NAVIGATION",
    TextColor3 = T.muted,
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left
}, Sidebar)

local NavHolder = make("Frame", {
    Size = UDim2.new(1, -16, 1, -45),
    Position = UDim2.fromOffset(8, 38),
    BackgroundTransparency = 1
}, Sidebar)

make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, NavHolder)

-- CONTENT
local Content = make("ScrollingFrame", {
    Size = UDim2.new(1, -158, 1, -80),
    Position = UDim2.fromOffset(148, 64),
    BackgroundColor3 = T.panel,
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = T.ice,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ZIndex = 3
}, Main)
round(Content, 13)
outline(Content, T.ice, 0.7, 0.78)

local ContentLayout = make("UIListLayout", {
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Content)

make("UIPadding", {
    PaddingTop = UDim.new(0, 14),
    PaddingLeft = UDim.new(0, 13),
    PaddingRight = UDim.new(0, 13),
    PaddingBottom = UDim.new(0, 13)
}, Content)

-- STATUS BAR
local Status = make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 14),
    Position = UDim2.new(0, 10, 1, -17),
    BackgroundTransparency = 1,
    Text = "●  NEXUS FROST  |  READY",
    TextColor3 = T.green,
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 4
}, Main)

local statusVersion = 0
local function notify(message, color)
    statusVersion = statusVersion + 1
    local version = statusVersion
    Status.Text = "●  " .. message
    Status.TextColor3 = color or T.ice
    task.delay(2.5, function()
        if Status.Parent and statusVersion == version then
            Status.Text = "●  NEXUS FROST  |  READY"
            Status.TextColor3 = T.green
        end
    end)
end

-- CONTENT HELPERS
local function clearContent()
    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("GuiObject")
        and child ~= ContentLayout then
            child:Destroy()
        end
    end
end

local function heading(text)
    return make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = string.upper(text),
        TextColor3 = T.ice,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Content)
end

local function description(text)
    return make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 43),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = T.gray,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, Content)
end

local function infoCard(title, body)
    local card = make("Frame", {
        Size = UDim2.new(1, 0, 0, 68),
        BackgroundColor3 = T.card,
        BorderSizePixel = 0
    }, Content)
    round(card, 10)
    outline(card, T.ice, 0.7, 0.75)

    make("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.fromOffset(10, 7),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = T.light,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    make("TextLabel", {
        Size = UDim2.new(1, -20, 0, 29),
        Position = UDim2.fromOffset(10, 30),
        BackgroundTransparency = 1,
        Text = body,
        TextColor3 = T.gray,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, card)
    return card
end

local function button(text, callback, accent)
    local obj = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = accent and Color3.fromRGB(18, 75, 102) or T.card,
        Text = text,
        TextColor3 = T.white,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false
    }, Content)
    round(obj, 9)
    outline(obj, T.ice, 0.9, 0.48)

    obj.MouseEnter:Connect(function()
        tween(obj, {BackgroundColor3 = T.cardHover}, 0.14)
    end)
    obj.MouseLeave:Connect(function()
        tween(obj, {
            BackgroundColor3 = accent and Color3.fromRGB(18, 75, 102) or T.card
        }, 0.14)
    end)
    obj.Activated:Connect(callback)
    return obj
end

-- AUTO THROW ENGINE
-- Best-effort client-side meter tracking. Power direction and executor input
-- compatibility depend on the game and executor and must be tested in-game.
local states = {}
local toggleControls = {}
local autoThrowTarget = 20
local autoThrowRunning = false

local function runAutoThrow()
    if autoThrowRunning then return end
    autoThrowRunning = true

    task.spawn(function()
        local lastTap = 0
        local wasNearTarget = false

        while states["Auto Throw"] and GUI.Parent do
            local ok, err = pcall(function()
                local seq = PlayerGui:FindFirstChild("ThrowSequence")
                local meter = seq and seq:FindFirstChild("Meter")
                local bounds = meter and meter:FindFirstChild("Frame")
                local bar = meter and meter:FindFirstChild("Bar")
                local marker = bar and bar:FindFirstChild("Frame")

                if not meter or not bounds or not marker then
                    wasNearTarget = false
                    return
                end
                if not meter.Visible or not bounds.Visible or not marker.Visible then
                    wasNearTarget = false
                    return
                end

                local height = bounds.AbsoluteSize.Y
                if height <= 0 then return end

                local markerY = marker.AbsolutePosition.Y + marker.AbsoluteSize.Y / 2
                local ratio = math.clamp(
                    (markerY - bounds.AbsolutePosition.Y) / height, 0, 1
                )

                -- Assumption: top = power 20, bottom = power 1.
                local power = math.floor((1 - ratio) * 19 + 1.5)
                local nearTarget = power >= autoThrowTarget

                if nearTarget and not wasNearTarget
                and os.clock() - lastTap >= 0.65 then
                    lastTap = os.clock()
                    wasNearTarget = true

                    local x = bounds.AbsolutePosition.X + bounds.AbsoluteSize.X / 2
                    local y = bounds.AbsolutePosition.Y + bounds.AbsoluteSize.Y / 2

                    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
                    task.wait(0.05)
                    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
                elseif not nearTarget then
                    wasNearTarget = false
                end
            end)

            if not ok then
                warn("[NEXUS AUTO THROW]", err)
            end
            task.wait(0.025)
        end

        autoThrowRunning = false
    end)
end

local function toggle(name)
    states[name] = false

    local holder = make("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = T.card,
        BorderSizePixel = 0
    }, Content)
    round(holder, 10)
    outline(holder, T.ice, 0.6, 0.82)

    make("TextLabel", {
        Size = UDim2.new(1, -75, 1, 0),
        Position = UDim2.fromOffset(11, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = T.white,
        Font = Enum.Font.GothamSemibold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    }, holder)

    local switch = make("TextButton", {
        Size = UDim2.fromOffset(42, 23),
        Position = UDim2.new(1, -53, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(36, 62, 79),
        Text = "",
        AutoButtonColor = false
    }, holder)
    round(switch, 20)
    outline(switch, T.ice, 0.7, 0.75)

    local knob = make("Frame", {
        Size = UDim2.fromOffset(17, 17),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = T.white,
        BorderSizePixel = 0
    }, switch)
    round(knob, 50)

    local function update()
        local enabled = states[name]
        tween(switch, {
            BackgroundColor3 = enabled and Color3.fromRGB(38, 157, 205)
                or Color3.fromRGB(36, 62, 79)
        }, 0.18)
        tween(knob, {
            Position = enabled and UDim2.fromOffset(22, 3)
                or UDim2.fromOffset(3, 3)
        }, 0.18)
        notify(name .. (enabled and " ENABLED" or " DISABLED"),
            enabled and T.green or T.gray)
    end

    switch.Activated:Connect(function()
        states[name] = not states[name]
        update()
        if name == "Auto Throw" and states[name] then
            runAutoThrow()
        end
    end)

    toggleControls[name] = update
end

local function stopAll()
    for name in pairs(states) do
        states[name] = false
        if toggleControls[name] then
            toggleControls[name]()
        end
    end
    notify("ALL AUTOMATIONS STOPPED", T.red)
end

-- PAGES
local function homePage()
    clearContent()
    heading("WELCOME BACK")
    description("NEXUS FROST V2  |  A clean, icy interface built for mobile.")
    infoCard("NEXUS CORE", "Interface loaded and ready.")
    infoCard("CREATOR", CREATOR .. "  |  Founder of NEXUS.")
    infoCard("VISUAL THEME", "Frost glass • Ice blue • Deep navy.")
    heading("NOTICE")
    description("Game-specific automation may depend on game updates and executor compatibility. Use responsibly.")
end

local function farmPage()
    clearContent()
    heading("ANIMAL FARM")
    description("Automation controls. Enable only the features you want to test.")

    heading("FOOD")
    toggle("Auto Buy Food")

    heading("TRAINING")
    toggle("Auto Train")
    toggle("Auto Upgrade Training")

    heading("THROWING")
    toggle("Auto Throw")
    toggle("Auto Repeat")

    heading("CONTROL")
    button("STOP ALL AUTOMATIONS", stopAll, true)
end

-- NAVIGATION
local navButtons = {}
local currentPage = nil

local function changePage(name, callback)
    if currentPage == name then return end
    currentPage = name
    tween(Content, {BackgroundTransparency = 1}, 0.12)
    task.wait(0.12)
    callback()
    Content.Position = UDim2.fromOffset(153, 64)
    tween(Content, {
        Position = UDim2.fromOffset(148, 64),
        BackgroundTransparency = 0.08
    }, 0.22)
end

local function nav(name, callback, order)
    local obj = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = T.card,
        Text = name,
        TextColor3 = T.gray,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        AutoButtonColor = false,
        LayoutOrder = order or 1
    }, NavHolder)
    round(obj, 9)
    outline(obj, T.ice, 0.6, 0.85)

    obj.Activated:Connect(function()
        for _, b in ipairs(navButtons) do
            tween(b, {BackgroundColor3 = T.card}, 0.14)
            b.TextColor3 = T.gray
        end
        tween(obj, {BackgroundColor3 = Color3.fromRGB(22, 83, 111)}, 0.17)
        obj.TextColor3 = T.white
        changePage(name, callback)
    end)

    table.insert(navButtons, obj)
    return obj
end

nav("⌂   HOME", homePage, 1)
nav("❄   ANIMAL FARM", farmPage, 2)

-- WELCOME POPUP
local Welcome = make("Frame", {
    Size = UDim2.fromOffset(280, 108),
    Position = UDim2.new(0.5, -140, 0.5, -54),
    BackgroundColor3 = T.panel2,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 20
}, Main)
round(Welcome, 13)
outline(Welcome, T.ice, 1.2, 0.2)
gradient(Welcome, Color3.fromRGB(20, 68, 94), Color3.fromRGB(8, 25, 43), 25)

local WelcomeScale = make("UIScale", {Scale = 0.7}, Welcome)

make("TextLabel", {
    Size = UDim2.new(1, -12, 0, 38),
    Position = UDim2.fromOffset(6, 12),
    BackgroundTransparency = 1,
    Text = "WELCOME TO NEXUS",
    TextColor3 = T.white,
    Font = Enum.Font.GothamBlack,
    TextSize = 15,
    ZIndex = 21
}, Welcome)

make("TextLabel", {
    Size = UDim2.new(1, -12, 0, 27),
    Position = UDim2.fromOffset(6, 53),
    BackgroundTransparency = 1,
    Text = "FROST EDITION  ♡",
    TextColor3 = T.ice,
    Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 21 }, Welcome)


homePage()

Main.Visible = true

Icon.Visible = false

Main.BackgroundTransparency = 1

Scale.Scale = 0.88

tween (Main, {BackgroundTransparency = 0}, 0.35)

tween (Scale, {Scale = 1}, 0.4, Enum.EasingStyle.Back) tween (Welcome, {BackgroundTransparency = 0}, 0.3)

task.wait(0.1)

tween (WelcomeScale, {Scale = 1}, 0.35, Enum.EasingStyle.Back)

task.delay(2.5, function()
    if Welcome.Parent then
        tween(WelcomeScale, {Scale = 0.8}, 0.2)
        tween(Welcome, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.25)
        if Welcome.Parent then
            Welcome:Destroy()
        end
    end
end)

print("NEXUS FROST V2 loaded successfully.")
