local p = game.Players.LocalPlayer
local v = {n=false, r=false, f=false, s=60, j=50, b=1, a=false, blocker=false, theme="Hacker"}
local bs = {Vector3.new(75,3,82), Vector3.new(75,3,41), Vector3.new(72,3,-1), Vector3.new(79,3,-42), Vector3.new(81,3,-79)}
local m, u, r = p:GetMouse(), game:GetService("UserInputService"), game:GetService("RunService")

local target = (gethui and gethui()) or game:GetService("CoreGui")
local sg = Instance.new("ScreenGui", target)

-- Color Palette
local themes = {
    Hacker = Color3.fromRGB(0, 255, 150),
    Blood = Color3.fromRGB(255, 0, 0)
}
local curCol = themes.Hacker

-- Main Frame (Hidden at start)
local f = Instance.new("Frame", sg)
f.Size, f.Position, f.BackgroundColor3 = UDim2.new(0, 180, 0, 580), UDim2.new(0.5, -90, 0.5, -290), Color3.fromRGB(15, 15, 15)
f.BorderSizePixel, f.BorderColor3, f.Visible, f.Active, f.Draggable = 2, curCol, false, true, true

-- Theme Window
local tf = Instance.new("Frame", sg)
tf.Size, tf.Position, tf.BackgroundColor3 = UDim2.new(0, 120, 0, 100), UDim2.new(0.5, 100, 0.5, -50), Color3.fromRGB(20, 20, 20)
tf.BorderSizePixel, tf.BorderColor3, tf.Visible, tf.Active, tf.Draggable = 2, curCol, false, true, true

-- Startup Frame
local startF = Instance.new("Frame", sg)
startF.Size, startF.Position, startF.BackgroundColor3 = UDim2.new(0, 200, 0, 250), UDim2.new(0.5, -100, 0.5, -125), Color3.fromRGB(15, 15, 15)
startF.BorderSizePixel, startF.BorderColor3 = 2, curCol

local function updateTheme(newTheme)
    v.theme = newTheme
    curCol = themes[newTheme]
    f.BorderColor3 = curCol
    tf.BorderColor3 = curCol
    startF.BorderColor3 = curCol
end

-- UI Helpers
local function nb(parent, t, y, cb, c)
    local b = Instance.new("TextButton", parent)
    b.Size, b.Position, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0.9, 0, 0, 24), UDim2.new(0.05, 0, 0, y), t, c or Color3.fromRGB(30, 30, 30), Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() cb(b) end) return b 
end

local function createReg(parent, label, y, def, valKey)
    local box = Instance.new("TextBox", parent)
    box.Size, box.Position, box.Text = UDim2.new(0.9, 0, 0, 25), UDim2.new(0.05, 0, 0, y), def.." "..label
    box.BackgroundColor3, box.TextColor3 = Color3.new(0,0,0), Color3.new(1,1,1)
    box.FocusLost:Connect(function() v[valKey] = tonumber(box.Text:match("%d+")) or def end)
end

-- STARTUP MENU BUTTONS
local sl = Instance.new("TextLabel", startF)
sl.Size, sl.Text, sl.TextColor3, sl.BackgroundTransparency = UDim2.new(1, 0, 0, 30), "CHOOSE YOUR BASE", Color3.new(1,1,1), 1

for i=1, 5 do
    nb(startF, "BASE "..i, 30 + (i*35), function()
        v.b = i
        p.Character.HumanoidRootPart.CFrame = CFrame.new(bs[i])
        startF.Visible = false
        f.Visible = true
    end)
end

-- MAIN MENU CONTENT
local l = Instance.new("TextLabel", f)
l.Size, l.Text, l.TextColor3, l.BackgroundTransparency = UDim2.new(1, 0, 0, 25), "PREMIUM V15", curCol, 1

nb(f, "NOCLIP", 30, function(b) v.n = not v.n b.TextColor3 = v.n and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb(f, "NOREACT", 56, function(b) v.r = not v.r b.TextColor3 = v.r and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb(f, "FLY", 82, function(b) v.f = not v.f b.TextColor3 = v.f and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb(f, "BLOCK SPEED SYST", 108, function(b) v.blocker = not v.blocker b.TextColor3 = v.blocker and Color3.new(1,0,0) or Color3.new(1,1,1) end)
nb(f, "TP TO BASE", 134, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(bs[v.b]) end, Color3.fromRGB(40, 40, 60))

createReg(f, "Speed", 165, 60, "s")
createReg(f, "Jump", 195, 50, "j")

nb(f, "CELESTIAL", 230, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2737, 3, -7) end)
nb(f, "SECRET", 256, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2461, 3, -2) end)
nb(f, "THEMES", 282, function() tf.Visible = not tf.Visible end, Color3.fromRGB(60, 30, 80))

-- THEME WINDOW BUTTONS
nb(tf, "HACKER (GREEN)", 10, function() updateTheme("Hacker") end)
nb(tf, "BLOOD (RED)", 45, function() updateTheme("Blood") end)

-- RUNNER LOGIC
r.Stepped:Connect(function()
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        local hum = p.Character.Humanoid
        -- Blocker Logic
        if v.blocker then
            hum.WalkSpeed = v.s
            hum.JumpPower = v.j
        end
        -- Visuals
        l.TextColor3 = curCol
        for _, x in pairs(p.Character:GetDescendants()) do 
            if x:IsA("BasePart") then x.CanCollide = not v.n x.CanTouch = not v.r end 
        end
    end
end)
