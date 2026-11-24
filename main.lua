--[[
    NEXUS GUI - ALYA EDITION
    Creator: bloxfruit782gh
    Mobile friendly
    Purple / Black theme
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- CONFIGURATION
local CREATOR = "bloxfruit782gh"

-- Replace with your uploaded Alya Roblox image asset ID
local ALYA_IMAGE = "rbxassetid://113429355768131"

local C = {
    Background = Color3.fromRGB(12, 10, 19),
    Panel = Color3.fromRGB(23, 19, 34),
    Panel2 = Color3.fromRGB(32, 25, 47),
    Purple = Color3.fromRGB(151, 96, 225),
    LightPurple = Color3.fromRGB(195, 153, 255),
    White = Color3.fromRGB(245, 240, 255),
    Gray = Color3.fromRGB(157, 148, 176),
    Green = Color3.fromRGB(115, 220, 160),
    Red = Color3.fromRGB(230, 105, 125)
}

local old = PlayerGui:FindFirstChild("NEXUS")
if old then old:Destroy() end

local GUI = Instance.new("ScreenGui")
GUI.Name = "NEXUS"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 999
GUI.Parent = PlayerGui

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function outline(obj, color, thickness)
    create("UIStroke", {
        Color = color or C.Purple,
        Thickness = thickness or 1,
        Transparency = 0.25
    }, obj)
end

local function animate(obj, properties, duration)
    TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.2,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    ):Play()
end

local function label(parent, text, size, position, fontSize, color)
    return create("TextLabel", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or C.White,
        TextSize = fontSize or 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }, parent)
end

-- MAIN WINDOW
local Main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(345, 440),
    Position = UDim2.new(0.5, -172, 0.5, -220),
    BackgroundColor3 = C.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, GUI)

round(Main, 15)
outline(Main, C.Purple, 1.5)

local Scale = create("UIScale", {
    Scale = 1
}, Main)

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local size = camera.ViewportSize
    Scale.Scale = math.min(
        1,
        size.X / 375,
        size.Y / 490
    )
end

updateScale()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

-- ALYA BACKGROUND
local Background = create("ImageLabel", {
    Name = "AlyaBackground",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Image = ALYA_IMAGE,
    ImageTransparency = 0.77,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 0
}, Main)

local DarkOverlay = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = C.Background,
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    ZIndex = 1
}, Main)

-- HEADER
local Header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 55),
    BackgroundColor3 = C.Panel,
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
    ZIndex = 2
}, Main)

local Logo = label(
    Header,
    "N E X U S",
    UDim2.new(0, 190, 1, 0),
    UDim2.fromOffset(17, 0),
    19,
    C.LightPurple
)
Logo.Font = Enum.Font.GothamBold
Logo.ZIndex = 3

local Version = label(
    Header,
    "ALYA EDITION",
    UDim2.fromOffset(100, 20),
    UDim2.new(1, -112, 0, 18),
    9,
    C.Gray
)
Version.TextXAlignment = Enum.TextXAlignment.Right
Version.ZIndex = 3

-- DRAGGING
local function makeDraggable(object, handle)
    local dragging = false
    local start
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            startPosition = object.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - start
            object.Position = UDim2.new(
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
end

makeDraggable(Main, Header)

-- FLOATING ALYA ICON
local FloatingIcon = create("ImageButton", {
    Name = "AlyaIcon",
    Size = UDim2.fromOffset(58, 58),
    Position = UDim2.new(0, 20, 0.5, -29),
    BackgroundColor3 = C.Panel,
    Image = ALYA_IMAGE,
    ScaleType = Enum.ScaleType.Crop,
    Visible = false,
    AutoButtonColor = true
}, GUI)

round(FloatingIcon, 50)
outline(FloatingIcon, C.Purple, 2)
makeDraggable(FloatingIcon, FloatingIcon)

FloatingIcon.Activated:Connect(function()
    FloatingIcon.Visible = false
    Main.Visible = true
    animate(Main, {BackgroundTransparency = 0}, 0.2)
end)

-- TAP ALYA BACKGROUND TO MINIMIZE
local AlyaButton = create("ImageButton", {
    Name = "AlyaMinimize",
    Size = UDim2.fromOffset(42, 42),
    Position = UDim2.new(1, -52, 0, 64),
    BackgroundTransparency = 1,
    Image = ALYA_IMAGE,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 5
}, Main)

round(AlyaButton, 50)
outline(AlyaButton, C.LightPurple, 1.5)

AlyaButton.Activated:Connect(function()
    Main.Visible = false
    FloatingIcon.Visible = true
end)

-- SIDEBAR
local Sidebar = create("Frame", {
    Size = UDim2.new(0, 105, 1, -75),
    Position = UDim2.fromOffset(9, 65),
    BackgroundColor3 = C.Panel,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
    ZIndex = 2
}, Main)

round(Sidebar, 10)

local SideLayout = create("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Sidebar)

create("UIPadding", {
    PaddingTop = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 7),
    PaddingRight = UDim.new(0, 7)
}, Sidebar)

local Content = create("ScrollingFrame", {
    Size = UDim2.new(1, -132, 1, -80),
    Position = UDim2.fromOffset(124, 67),
    BackgroundColor3 = C.Panel,
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.Purple,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ZIndex = 2
}, Main)

round(Content, 10)

local ContentLayout = create("UIListLayout", {
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Content)

create("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 12)
}, Content)

-- STATUS
local Status = label(
    Main,
    "NEXUS  |  READY",
    UDim2.new(1, -20, 0, 18),
    UDim2.new(0, 10, 1, -21),
    9,
    C.Gray
)
Status.TextXAlignment = Enum.TextXAlignment.Center
Status.ZIndex = 3

-- CONTENT HELPERS
local function clearContent()
    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("GuiObject")
        and child ~= ContentLayout then
            child:Destroy()
        end
    end
end

local function section(text)
    local item = label(
        Content,
        text,
        UDim2.new(1, 0, 0, 25),
        UDim2.new(),
        11,
        C.LightPurple
    )
    item.Font = Enum.Font.GothamBold
end

local function description(text)
    local item = label(
        Content,
        text,
        UDim2.new(1, 0, 0, 55),
        UDim2.new(),
        11,
        C.Gray
    )
    item.TextWrapped = true
    item.TextYAlignment = Enum.TextYAlignment.Top
end

local function actionButton(text, callback)
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 37),
        BackgroundColor3 = C.Panel2,
        Text = text,
        TextColor3 = C.White,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false
    }, Content)

    round(button, 8)
    outline(button, Color3.fromRGB(83, 63, 112), 1)

    button.MouseEnter:Connect(function()
        animate(button, {BackgroundColor3 = Color3.fromRGB(54, 38, 76)})
    end)

    button.MouseLeave:Connect(function()
        animate(button, {BackgroundColor3 = C.Panel2})
    end)

    button.Activated:Connect(callback)
    return button
end

local function notify(message)
    Status.Text = "NEXUS  |  " .. message

    task.delay(2.5, function()
        if Status.Parent then
            Status.Text = "NEXUS  |  READY"
        end
    end)
end

-- FEATURE STATES
local states = {}

local function makeToggle(name)
    states[name] = false

    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = C.Panel2,
        BorderSizePixel = 0
    }, Content)

    round(holder, 8)

    label(
        holder,
        name,
        UDim2.new(1, -65, 1, 0),
        UDim2.fromOffset(10, 0),
        11,
        C.White
    )

    local switch = create("TextButton", {
        Size = UDim2.fromOffset(39, 21),
        Position = UDim2.new(1, -49, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(65, 58, 77),
        Text = "",
        AutoButtonColor = false
    }, holder)

    round(switch, 20)

    local knob = create("Frame", {
        Size = UDim2.fromOffset(15, 15),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = C.White,
        BorderSizePixel = 0
    }, switch)

    round(knob, 50)

    local function update()
        local enabled = states[name]

        animate(switch, {
            BackgroundColor3 = enabled and C.Purple
                or Color3.fromRGB(65, 58, 77)
        })

        animate(knob, {
            Position = enabled
                and UDim2.fromOffset(21, 3)
                or UDim2.fromOffset(3, 3)
        })

        notify(name .. (enabled and " ON" or " OFF"))
    end

    switch.Activated:Connect(function()
        states[name] = not states[name]
        update()
    end)
end

local function stopAll()
    for name in pairs(states) do
        states[name] = false
    end

    for _, item in ipairs(Content:GetDescendants()) do
        if item:IsA("TextButton") then
            local holder = item.Parent
            if holder and holder:IsA("Frame") then
                item.BackgroundColor3 = Color3.fromRGB(65, 58, 77)
                local knob = item:FindFirstChildOfClass("Frame")
                if knob then
                    knob.Position = UDim2.fromOffset(3, 3)
                end
            end
        end
    end

    notify("ALL TOGGLES OFF")
end

-- HOME PAGE
local function homePage()
    clearContent()

    section("WELCOME TO NEXUS")
    description("Your personal Roblox control hub. Built for mobile with a custom Alya theme.")

    section("CREATOR")
    description("Created by: " .. CREATOR)

    section("ABOUT")
    description("NEXUS ALYA EDITION | Purple and black interface.")

    section("ACCOUNT NOTICE")
    description("Using scripts may put your Roblox account at risk. Use at your own discretion.")

    section("STATUS")
    description("The interface is running. Game automation requires verified game-specific integration.")
end

-- ANIMAL FARM PAGE
local function farmPage()
    clearContent()

    section("ANIMAL FARM")
    description("Control panel for your Animal Farm gameplay.")

    section("FOOD")
    makeToggle("Auto Buy Food")

    section("TRAINING")
    makeToggle("Auto Train")
    makeToggle("Auto Upgrade Training")

    section("THROWING")
    makeToggle("Auto Throw")
    makeToggle("Auto Repeat")

    section("CONTROL")
    actionButton("STOP ALL", stopAll)
end

-- NAVIGATION
local function makeNav(name, callback)
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 37),
        BackgroundColor3 = C.Panel2,
        Text = name,
        TextColor3 = C.White,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    }, Sidebar)

    round(button, 7)

    button.Activated:Connect(function()
        for _, child in ipairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = C.Panel2
            end
        end

        button.BackgroundColor3 = C.Purple
        callback()
    end)

    return button
end

makeNav("HOME", homePage)
makeNav("ANIMAL FARM", farmPage)

homePage()

-- WELCOME POPUP
local Welcome = create("Frame", {
    Size = UDim2.fromOffset(275, 105),
    Position = UDim2.new(0.5, -137, 0.5, -52),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
    ZIndex = 20
}, Main)

round(Welcome, 12)
outline(Welcome, C.Purple, 2)

local WelcomeTitle = label(
    Welcome,
    "Welcome To Nexus Gui",
    UDim2.new(1, -12, 0, 38),
    UDim2.fromOffset(6, 12),
    16,
    C.White
)
WelcomeTitle.Font = Enum.Font.GothamBold
WelcomeTitle.TextXAlignment = Enum.TextXAlignment.Center
WelcomeTitle.ZIndex = 21

local WelcomeSubtitle = label(
    Welcome,
    "Enjoy The Script Pookie ♡",
    UDim2.new(1, -12, 0, 27),
    UDim2.fromOffset(6, 52),
    12,
    C.LightPurple
)
WelcomeSubtitle.TextXAlignment = Enum.TextXAlignment.Center
WelcomeSubtitle.ZIndex = 21

task.delay(2.5, function()
    if Welcome.Parent then
        animate(Welcome, {
            BackgroundTransparency = 1
        }, 0.3)

        task.wait(0.35)
        Welcome:Destroy()
    end
end)

print("NEXUS ALYA EDITION loaded.")
