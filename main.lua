
--[[
    NEXUS | ALYA EDITION
    Creator: bloxfruit782gh
    Animated mobile GUI
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local CREATOR = "bloxfruit782gh"
local ALYA_IMAGE = "rbxassetid://113429355768131"

local T = {
    bg = Color3.fromRGB(12, 10, 19),
    panel = Color3.fromRGB(23, 19, 34),
    card = Color3.fromRGB(34, 27, 48),
    purple = Color3.fromRGB(155, 99, 230),
    light = Color3.fromRGB(211, 178, 255),
    white = Color3.fromRGB(245, 240, 255),
    gray = Color3.fromRGB(155, 146, 174),
    green = Color3.fromRGB(105, 220, 155)
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

local function outline(obj, color, thickness)
    make("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = 0.25
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

round(Main, 16)
outline(Main, T.purple, 1.5)

local Scale = make("UIScale", {
    Scale = 1
}, Main)

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local size = camera.ViewportSize
    Scale.Scale = math.min(
        1,
        size.X / 570,
        size.Y / 430
    )
end

updateScale()

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

-- ALYA BACKGROUND

local Background = make("ImageLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Image = ALYA_IMAGE,
    ImageTransparency = 0.70,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 0
}, Main)

make("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = T.bg,
    BackgroundTransparency = 0.13,
    BorderSizePixel = 0,
    ZIndex = 1
}, Main)

-- HEADER

local Header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 55),
    BackgroundColor3 = T.panel,
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    ZIndex = 3
}, Main)

make("TextLabel", {
    Size = UDim2.fromOffset(200, 55),
    Position = UDim2.fromOffset(18, 0),
    BackgroundTransparency = 1,
    Text = "N E X U S",
    TextColor3 = T.light,
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4
}, Header)

make("TextLabel", {
    Size = UDim2.fromOffset(110, 55),
    Position = UDim2.new(1, -125, 0, 0),
    BackgroundTransparency = 1,
    Text = "ALYA EDITION",
    TextColor3 = T.gray,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
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
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
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
outline(Icon, T.purple, 2)

local iconScale = make("UIScale", {
    Scale = 1
}, Icon)

-- ICON FLOATING ANIMATION

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

-- OPEN AND MINIMIZE

local function openGUI()
    Main.Visible = true
    Icon.Visible = false
    Main.BackgroundTransparency = 1
    Scale.Scale = 0.86

    tween(Main, {
        BackgroundTransparency = 0
    }, 0.3)

    tween(Scale, {
        Scale = 1
    }, 0.35, Enum.EasingStyle.Back)
end

local function minimizeGUI()
    tween(Scale, {
        Scale = 0.85
    }, 0.2)

    tween(Main, {
        BackgroundTransparency = 1
    }, 0.2)

    task.wait(0.22)

    Main.Visible = false
    Main.BackgroundTransparency = 0
    Scale.Scale = 1
    Icon.Visible = true
end

Icon.Activated:Connect(openGUI)

-- HEADER ALYA MINIMIZE BUTTON

local AlyaButton = make("ImageButton", {
    Size = UDim2.fromOffset(42, 42),
    Position = UDim2.new(1, -55, 0, 62),
    BackgroundTransparency = 1,
    Image = ALYA_IMAGE,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 6
}, Main)

round(AlyaButton, 50)
outline(AlyaButton, T.light, 1.5)

AlyaButton.Activated:Connect(minimizeGUI)

-- SIDEBAR

local Sidebar = make("Frame", {
    Size = UDim2.new(0, 125, 1, -70),
    Position = UDim2.fromOffset(10, 62),
    BackgroundColor3 = T.panel,
    BorderSizePixel = 0,
    ZIndex = 3
}, Main)

round(Sidebar, 12)

make("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Sidebar)

make("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 9),
    PaddingRight = UDim.new(0, 9)
}, Sidebar)

-- CONTENT

local Content = make("ScrollingFrame", {
    Size = UDim2.new(1, -155, 1, -78),
    Position = UDim2.fromOffset(145, 67),
    BackgroundColor3 = T.panel,
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = T.purple,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ZIndex = 3
}, Main)

round(Content, 12)

local ContentLayout = make("UIListLayout", {
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Content)

make("UIPadding", {
    PaddingTop = UDim.new(0, 14),
    PaddingLeft = UDim.new(0, 13),
    PaddingRight = UDim.new(0, 13),
    PaddingBottom = UDim.new(0, 12)
}, Content)

-- STATUS BAR

local Status = make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 17),
    Position = UDim2.new(0, 10, 1, -20),
    BackgroundTransparency = 1,
    Text = "NEXUS  |  READY",
    TextColor3 = T.gray,
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 4
}, Main)

local function notify(message)
    Status.Text = "NEXUS  |  " .. message

    task.delay(2, function()
        if Status.Parent then
            Status.Text = "NEXUS  |  READY"
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
    local obj = make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = T.light,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Content)

    return obj
end

local function description(text)
    local obj = make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = T.gray,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, Content)

    return obj
end

local function button(text, callback)
    local obj = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = T.card,
        Text = text,
        TextColor3 = T.white,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        AutoButtonColor = false
    }, Content)

    round(obj, 8)
    outline(obj, T.purple, 0.7)

    obj.MouseEnter:Connect(function()
        tween(obj, {
            BackgroundColor3 = Color3.fromRGB(53, 39, 73)
        }, 0.15)
    end)

    obj.MouseLeave:Connect(function()
        tween(obj, {
            BackgroundColor3 = T.card
        }, 0.15)
    end)

    obj.Activated:Connect(callback)
    return obj
end

-- TOGGLES

local states = {}
local toggleControls = {}

local function toggle(name)
    states[name] = false

    local holder = make("Frame", {
        Size = UDim2.new(1, 0, 0, 43),
        BackgroundColor3 = T.card,
        BorderSizePixel = 0
    }, Content)

    round(holder, 8)

    make("TextLabel", {
        Size = UDim2.new(1, -65, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = T.white,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, holder)

    local switch = make("TextButton", {
        Size = UDim2.fromOffset(40, 22),
        Position = UDim2.new(1, -49, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(65, 58, 77),
        Text = "",
        AutoButtonColor = false
    }, holder)

    round(switch, 20)

    local knob = make("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = T.white,
        BorderSizePixel = 0
    }, switch)

    round(knob, 50)

    local function update()
        local enabled = states[name]

        tween(switch, {
            BackgroundColor3 = enabled and T.purple
                or Color3.fromRGB(65, 58, 77)
        }, 0.18)

        tween(knob, {
            Position = enabled
                and UDim2.fromOffset(21, 3)
                or UDim2.fromOffset(3, 3)
        }, 0.18)

        notify(name .. (enabled and " ON" or " OFF"))
    end

    switch.Activated:Connect(function()
        states[name] = not states[name]
        update()
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

    notify("ALL TOGGLES OFF")
end

-- HOME PAGE

local function homePage()
    clearContent()

    heading("WELCOME TO NEXUS")
    description("Your personal Roblox hub. Designed with a custom Alya theme and smooth mobile animations.")

    heading("CREATOR")
    description("Created by: " .. CREATOR)

    heading("ABOUT")
    description("NEXUS ALYA EDITION | Purple and black interface.")

    heading("ACCOUNT NOTICE")
    description("Using scripts may put your Roblox account at risk. Use at your own discretion.")

    heading("SYSTEM")
    description("Interface loaded. Game-specific automation still needs integration and testing.")
end

-- ANIMAL FARM PAGE

local function farmPage()
    clearContent()

    heading("ANIMAL FARM")
    description("Automation control panel. These switches currently control their visual state only.")

    heading("FOOD")
    toggle("Auto Buy Food")

    heading("TRAINING")
    toggle("Auto Train")
    toggle("Auto Upgrade Training")

    heading("THROWING")
    toggle("Auto Throw")
    toggle("Auto Repeat")

    heading("CONTROL")
    button("STOP ALL", stopAll)
end

-- PAGE ANIMATION

local currentPage = nil
local function changePage(name, callback)
    if currentPage == name then return end
    currentPage = name

    tween(Content, {
        BackgroundTransparency = 1
    }, 0.12)

    task.wait(0.12)
    callback()

    Content.Position = UDim2.fromOffset(153, 67)
    tween(Content, {
        Position = UDim2.fromOffset(145, 67),
        BackgroundTransparency = 0.12
    }, 0.22)
end

-- NAVIGATION

local navButtons = {}

local function nav(name, callback)
    local obj = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 39),
        BackgroundColor3 = T.card,
        Text = name,
        TextColor3 = T.white,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false
    }, Sidebar)

    round(obj, 8)

    obj.Activated:Connect(function()
        for _, b in ipairs(navButtons) do
            tween(b, {
                BackgroundColor3 = T.card
            }, 0.15)
        end

        tween(obj, {
            BackgroundColor3 = T.purple
        }, 0.18)

        changePage(name, callback)
    end)

    table.insert(navButtons, obj)
    return obj
end

nav("HOME", homePage)
nav("ANIMAL FARM", farmPage)

-- WELCOME POPUP

local Welcome = make("Frame", {
    Size = UDim2.fromOffset(280, 108),
    Position = UDim2.new(0.5, -140, 0.5, -54),
    BackgroundColor3 = T.panel,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 20
}, Main)

round(Welcome, 13)
outline(Welcome, T.purple, 1.5)

local WelcomeScale = make("UIScale", {
    Scale = 0.7
}, Welcome)

local WelcomeTitle = make("TextLabel", {
    Size = UDim2.new(1, -12, 0, 38),
    Position = UDim2.fromOffset(6, 12),
    BackgroundTransparency = 1,
    Text = "Welcome To Nexus Gui",
    TextColor3 = T.white,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    ZIndex = 21
}, Welcome)

local WelcomeSub = make("TextLabel", {
    Size = UDim2.new(1, -12, 0, 27),
    Position = UDim2.fromOffset(6, 53),
    BackgroundTransparency = 1,
    Text = "Enjoy The Script Pookie ♡",
    TextColor3 = T.light,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ZIndex = 21
}, Welcome)

WelcomeTitle.TextXAlignment = Enum.TextXAlignment.Center
WelcomeSub.TextXAlignment = Enum.TextXAlignment.Center

-- INITIAL OPEN ANIMATION

homePage()
Main.Visible = true
Icon.Visible = false
Main.BackgroundTransparency = 1
Scale.Scale = 0.88

tween(Main, {
    BackgroundTransparency = 0
}, 0.35)

tween(Scale, {
    Scale = 1
}, 0.4, Enum.EasingStyle.Back)

task.wait(0.1)

tween(Welcome, {
    BackgroundTransparency = 0
}, 0.3)

tween(WelcomeScale, {
    Scale = 1
}, 0.35, Enum.EasingStyle.Back)

task.delay(2.5, function()
    if Welcome.Parent then
        tween(WelcomeScale, {
            Scale = 0.8
        }, 0.2)

        tween(Welcome, {
            BackgroundTransparency = 1
        }, 0.2)

        task.wait(0.25)
        if Welcome.Parent then
            Welcome:Destroy()
        end
    end
end)

print("NEXUS ALYA EDITION loaded successfully.")
