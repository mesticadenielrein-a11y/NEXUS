
--[[
    NEXUS: TROLL GUI
    Purple / Black Edition
    v1.0
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

if pg:FindFirstChild("NEXUS") then
    pg.NEXUS:Destroy()
end

local purple = Color3.fromRGB(160, 75, 255)
local dark = Color3.fromRGB(17, 14, 24)
local panel = Color3.fromRGB(31, 25, 43)
local white = Color3.fromRGB(245, 240, 255)

local gui = Instance.new("ScreenGui")
gui.Name = "NEXUS"
gui.ResetOnSpawn = false
gui.Parent = pg

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(235, 285)
main.Position = UDim2.new(0.5, -117, 0.5, -142)
main.BackgroundColor3 = dark
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = purple
stroke.Thickness = 1.5

local top = Instance.new("TextButton")
top.Size = UDim2.new(1, 0, 0, 38)
top.BackgroundColor3 = panel
top.Text = "✦ NEXUS: TROLL GUI"
top.TextColor3 = white
top.TextSize = 14
top.Font = Enum.Font.GothamBlack
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 10)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(25, 25)
close.Position = UDim2.new(1, -30, 0, 6)
close.BackgroundColor3 = Color3.fromRGB(110, 40, 145)
close.Text = "×"
close.TextColor3 = white
close.TextSize = 18
close.Parent = main
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.Activated:Connect(function() gui:Destroy() end)

-- Drag support
local dragging, dragStart, startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local function popup(message)
    local toast = Instance.new("TextLabel")
    toast.Size = UDim2.fromOffset(260, 45)
    toast.Position = UDim2.new(0.5, -130, 0.15, 0)
    toast.BackgroundColor3 = panel
    toast.TextColor3 = white
    toast.Text = message
    toast.TextSize = 14
    toast.Font = Enum.Font.GothamBold
    toast.Parent = gui

    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 9)

    local s = Instance.new("UIStroke", toast)
    s.Color = purple

    task.delay(2.5, function()
        if toast.Parent then toast:Destroy() end
    end)
end

local function addButton(label, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.fromOffset(10, 0)
    b.BackgroundColor3 = panel
    b.Text = label
    b.TextColor3 = white
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.Parent = main

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    local s = Instance.new("UIStroke", b)
    s.Color = purple
    s.Transparency = 0.5

    b.Activated:Connect(callback)
end

local buttons = {
    {"💀 FAKE ERROR", function()
        popup("ERROR 404: BRAIN NOT FOUND 💀")
    end},
    {"📸 CAUGHT IN 4K", function()
        popup("YOU GOT CAUGHT IN 4K 📸")
    end},
    {"🗿 RIZZ METER", function()
        popup("RIZZ LEVEL: " .. math.random(0, 100) .. "%")
    end},
    {"🚨 SUS DETECTOR", function()
        popup("SCAN COMPLETE: 99.9% SUS")
    end},
    {"🤡 CLOWN CHECK", function()
        popup("CLOWN DETECTED 🤡")
    end},
    {"🔮 RANDOM MESSAGE", function()
        local msgs = {
            "bro is NOT him 💀",
            "WHO LET HIM COOK 😭",
            "NAH THAT'S CRAZY",
            "SUSPICIOUS ACTIVITY DETECTED"
        }
        popup(msgs[math.random(#msgs)])
    end}
}

for i, data in ipairs(buttons) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.fromOffset(10, 44 + (i - 1) * 37)
    b.BackgroundColor3 = panel
    b.Text = data[1]
    b.TextColor3 = white
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = main

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

    local s = Instance.new("UIStroke", b)
    s.Color = purple
    s.Transparency = 0.5

    b.Activated:Connect(data[2])
end

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -10, 0, 20)
footer.Position = UDim2.new(0, 5, 1, -22)
footer.BackgroundTransparency = 1
footer.Text = "NEXUS  •  GITHUB  •  v1.0"
footer.TextColor3 = Color3.fromRGB(160, 140, 180)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.Parent = main

-- End of NEXUS
