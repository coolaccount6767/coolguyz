local p = game.Players.LocalPlayer
local v = {n=false, r=false, f=false, s=60, j=50, b=1, a=false, blocker=false, theme="Hacker", esp=false}
local bs = {Vector3.new(75,3,82), Vector3.new(75,3,41), Vector3.new(72,3,-1), Vector3.new(79,3,-42), Vector3.new(81,3,-79)}
local m, u, r = p:GetMouse(), game:GetService("UserInputService"), game:GetService("RunService")

local target = (gethui and gethui()) or game:GetService("CoreGui")
local sg = Instance.new("ScreenGui", target)

-- Color Palette
local themes = {
    Hacker = {main = Color3.fromRGB(15, 15, 15), accent = Color3.fromRGB(0, 255, 150)},
    Blood = {main = Color3.fromRGB(15, 5, 5), accent = Color3.fromRGB(255, 0, 0)},
    Mystical = {main = Color3.fromRGB(5, 5, 25), accent = Color3.fromRGB(180, 0, 255)}
}
local curTheme = themes.Hacker

-- Main Frame
local f = Instance.new("Frame", sg)
f.Size, f.Position, f.BackgroundColor3 = UDim2.new(0, 180, 0, 520), UDim2.new(0.5, -90, 0.5, -260), curTheme.main
f.BorderSizePixel, f.BorderColor3, f.Visible, f.Active, f.Draggable = 2, curTheme.accent, false, true, true

-- Theme Window
local tf = Instance.new("Frame", sg)
tf.Size, tf.Position, tf.BackgroundColor3 = UDim2.new(0, 130, 0, 130), UDim2.new(0.5, 100, 0.5, -50), curTheme.main
tf.BorderSizePixel, tf.BorderColor3, tf.Visible, tf.Active, tf.Draggable = 2, curTheme.accent, false, true, true

-- Startup Frame
local startF = Instance.new("Frame", sg)
startF.Size, startF.Position, startF.BackgroundColor3 = UDim2.new(0, 200, 0, 250), UDim2.new(0.5, -100, 0.5, -125), curTheme.main
startF.BorderSizePixel, startF.BorderColor3 = 2, curTheme.accent

local function updateTheme(name)
    v.theme = name
    curTheme = themes[name]
    f.BackgroundColor3 = curTheme.main
    f.BorderColor3 = curTheme.accent
    tf.BackgroundColor3 = curTheme.main
    tf.BorderColor3 = curTheme.accent
    startF.BackgroundColor3 = curTheme.main
    startF.BorderColor3 = curTheme.accent
end

-- ESP SYSTEM
local esp_folder = Instance.new("Folder", sg); esp_folder.Name = "ESP"
local function createESP(obj)
    if not obj:IsA("Model") or obj == p.Character then return end
    local b = Instance.new("BoxHandleAdornment", esp_folder)
    b.Adornee, b.AlwaysOnTop, b.ZIndex, b.Size = obj, true, 1, obj:GetExtentsSize()
    b.Color3, b.Transparency = curTheme.accent, 0.7
    
    local bl = Instance.new("BillboardGui", esp_folder)
    bl.Adornee, bl.AlwaysOnTop, bl.Size = obj, true, UDim2.new(0, 100, 0, 20)
    bl.ExtentsOffset = Vector3.new(0, 3, 0)
    local tl = Instance.new("TextLabel", bl)
    tl.Size, tl.Text, tl.TextColor3, tl.BackgroundTransparency = UDim2.new(1,0,1,0), obj.Name, curTheme.accent, 1
    tl.TextStrokeTransparency = 0; tl.TextSize = 10

    task.spawn(function()
        while obj:IsDescendantOf(workspace) and v.esp do task.wait(1) end
        b:Destroy(); bl:Destroy()
    end)
end

-- UI Helpers
local function nb(parent, t, y, cb, c)
    local b = Instance.new("TextButton", parent)
    b.Size, b.Position, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0.9, 0, 0, 24), UDim2.new(0.05, 0, 0, y), t, c or Color3.fromRGB(30, 30, 30), Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() cb(b) end) return b 
end

-- STARTUP MENU
local sl = Instance.new("TextLabel", startF)
sl.Size, sl.Text, sl.TextColor3, sl.BackgroundTransparency = UDim2.new(1, 0, 0, 30), "CHOOSE YOUR BASE", Color3.new(1,1,1), 1
for i=1, 5 do
    nb(startF, "BASE "..i, 30 + (i*35), function()
        v.b = i
        p.Character.HumanoidRootPart.CFrame = CFrame.new(bs[i])
        startF.Visible = false; f.Visible = true
    end)
end

-- MAIN MENU
local l = Instance.new("TextLabel", f)
l.Size, l.Text, l.TextColor3, l.BackgroundTransparency = UDim2.new(1, 0, 0, 25), "PREMIUM V16", Color3.new(1,1,1), 1

nb(f, "NOCLIP", 30, function(b) v.n = not v.n b.TextColor3 = v.n and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb(f, "NOREACT", 56, function(b) v.r = not v.r b.TextColor3 = v.r and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb(f, "FLY", 82, function(b) v.f = not v.f b.TextColor3 = v.f and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb(f, "3D MODEL ESP", 108, function(b) 
    v.esp = not v.esp
    b.TextColor3 = v.esp and Color3.new(0.7, 0, 1) or Color3.new(1,1,1)
    if v.esp then for _, o in pairs(workspace:GetChildren()) do createESP(o) end end
end)
nb(f, "BLOCK SPEED SYST", 134, function(b) v.blocker = not v.blocker b.TextColor3 = v.blocker and Color3.new(1,0,0) or Color3.new(1,1,1) end)
nb(f, "TP TO BASE", 160, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(bs[v.b]) end, Color3.fromRGB(40, 40, 60))

local function createReg(parent, label, y, def, valKey)
    local box = Instance.new("TextBox", parent)
    box.Size, box.Position, box.Text = UDim2.new(0.9, 0, 0, 25), UDim2.new(0.05, 0, 0, y), def.." "..label
    box.BackgroundColor3, box.TextColor3 = Color3.new(0,0,0), Color3.new(1,1,1)
    box.FocusLost:Connect(function() v[valKey] = tonumber(box.Text:match("%d+")) or def end)
end

createReg(f, "Speed", 195, 60, "s")
createReg(f, "Jump", 225, 50, "j")

nb(f, "CELESTIAL", 260, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2737, 3, -7) end)
nb(f, "SECRET", 286, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2461, 3, -2) end)
nb(f, "COSMIC", 312, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2005, 3, -9) end)
nb(f, "THEMES", 350, function() tf.Visible = not tf.Visible end, Color3.fromRGB(60, 30, 80))

-- THEME WINDOW
nb(tf, "HACKER", 10, function() updateTheme("Hacker") end)
nb(tf, "BLOOD", 40, function() updateTheme("Blood") end)
nb(tf, "MYSTICAL", 70, function() updateTheme("Mystical") end)

-- RUNNER LOGIC
r.Stepped:Connect(function()
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        if v.blocker then p.Character.Humanoid.WalkSpeed = v.s p.Character.Humanoid.JumpPower = v.j end
        for _, x in pairs(p.Character:GetDescendants()) do if x:IsA("BasePart") then x.CanCollide = not v.n x.CanTouch = not v.r end end
    end
end)
