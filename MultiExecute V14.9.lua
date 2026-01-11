local p = game.Players.LocalPlayer
local v = {n=false, r=false, f=false, s=60, j=50, b=1, a=false, blocker=false, theme="Hacker", esp=false, ag=false}
local bs = {Vector3.new(75,3,82), Vector3.new(75,3,41), Vector3.new(72,3,-1), Vector3.new(79,3,-42), Vector3.new(81,3,-79)}
local m, u, r = p:GetMouse(), game:GetService("UserInputService"), game:GetService("RunService")

-- UI Parent
local target = (gethui and gethui()) or game:GetService("CoreGui")
local sg = Instance.new("ScreenGui", target)

-- Themes Config
local themes = {
    Hacker = {main = Color3.fromRGB(15, 15, 15), accent = Color3.fromRGB(0, 255, 150)},
    Blood = {main = Color3.fromRGB(15, 5, 5), accent = Color3.fromRGB(255, 0, 0)},
    Mystical = {main = Color3.fromRGB(10, 10, 45), accent = Color3.fromRGB(180, 0, 255)},
    Water = {main = Color3.fromRGB(0, 35, 90), accent = Color3.fromRGB(255, 255, 255)} -- Blue/White
}
local cur = themes.Hacker

-- Main Frame
local f = Instance.new("Frame", sg)
f.Size, f.Position, f.BackgroundColor3 = UDim2.new(0, 175, 0, 480), UDim2.new(0.5, -87, 0.5, -240), cur.main
f.BorderSizePixel, f.BorderColor3, f.Visible, f.Active, f.Draggable = 2, cur.accent, false, true, true

-- Theme Window (Fixed Visibility)
local tf = Instance.new("Frame", sg)
tf.Size, tf.Position, tf.BackgroundColor3 = UDim2.new(0, 130, 0, 160), UDim2.new(0.5, 95, 0.5, -80), cur.main
tf.BorderSizePixel, tf.BorderColor3, tf.Visible, tf.Active, tf.Draggable = 2, cur.accent, false, true, true
tf.ZIndex = 5

local l = Instance.new("TextLabel", f)
l.Size, l.Text, l.TextColor3, l.BackgroundTransparency = UDim2.new(1, 0, 0, 25), "GEMINI PREMIUM", cur.accent, 1
l.Font = Enum.Font.GothamBold

local hud = Instance.new("TextLabel", f)
hud.Size, hud.Position = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 22)
hud.TextSize, hud.TextColor3, hud.BackgroundTransparency = 10, Color3.new(0.8,0.8,0.8), 1

-- Button Helper
local function nb(parent, t, y, cb, c)
    local b = Instance.new("TextButton", parent)
    b.Size, b.Position, b.Text = UDim2.new(0.9, 0, 0, 22), UDim2.new(0.05, 0, 0, y), t
    b.BackgroundColor3, b.TextColor3 = c or Color3.fromRGB(25, 25, 25), Color3.new(1, 1, 1)
    b.BorderSizePixel = 0; b.Font = Enum.Font.Gotham; b.ZIndex = parent.ZIndex + 1
    b.MouseButton1Click:Connect(function() cb(b) end) return b 
end

-- Startup Menu
local startF = Instance.new("Frame", sg)
startF.Size, startF.Position, startF.BackgroundColor3 = UDim2.new(0, 190, 0, 240), UDim2.new(0.5, -95, 0.5, -120), cur.main
startF.BorderSizePixel, startF.BorderColor3 = 2, cur.accent

for i=1, 5 do
    nb(startF, "BASE "..i, 40 + (i*33), function()
        v.b = i; if p.Character then p.Character:MoveTo(bs[i]) end
        startF.Visible = false; f.Visible = true
    end)
end

-- Main Buttons
nb(f, "NOCLIP", 45, function(b) v.n = not v.n b.TextColor3 = v.n and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb(f, "NOREACT", 71, function(b) v.r = not v.r b.TextColor3 = v.r and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb(f, "FLY", 97, function(b) v.f = not v.f b.TextColor3 = v.f and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb(f, "AUTOGRAB (1s)", 123, function(b) v.ag = not v.ag b.TextColor3 = v.ag and Color3.new(0, 0.8, 1) or Color3.new(1,1,1) end)
nb(f, "3D MODEL ESP", 149, function(b) v.esp = not v.esp b.TextColor3 = v.esp and cur.accent or Color3.new(1,1,1) end)
nb(f, "BLOCK SPEED SYST", 175, function(b) v.blocker = not v.blocker b.TextColor3 = v.blocker and Color3.new(1,0,0) or Color3.new(1,1,1) end)
nb(f, "TP TO BASE", 201, function() if p.Character then p.Character:MoveTo(bs[v.b]) end end, Color3.fromRGB(40, 40, 65))

local function createReg(parent, label, y, def, valKey)
    local box = Instance.new("TextBox", parent)
    box.Size, box.Position, box.Text = UDim2.new(0.9, 0, 0, 24), UDim2.new(0.05, 0, 0, y), def.." "..label
    box.BackgroundColor3, box.TextColor3, box.BorderSizePixel = Color3.new(0,0,0), Color3.new(1,1,1), 0
    box.FocusLost:Connect(function() v[valKey] = tonumber(box.Text:match("%d+")) or def end)
end
createReg(f, "Speed", 235, 60, "s")
createReg(f, "Jump", 265, 50, "j")

nb(f, "CELESTIAL", 300, function() if p.Character then p.Character:MoveTo(Vector3.new(2737, 3, -7)) end end)
nb(f, "SECRET", 326, function() if p.Character then p.Character:MoveTo(Vector3.new(2461, 3, -2)) end end)
nb(f, "COSMIC", 352, function() if p.Character then p.Character:MoveTo(Vector3.new(2005, 3, -9)) end end)

-- Fixed Themes Toggle
nb(f, "THEMES", 390, function() tf.Visible = not tf.Visible end, Color3.fromRGB(60, 30, 80))

local function setT(name, y)
    nb(tf, name, y, function()
        cur = themes[name]
        for _, frame in pairs({f, tf, startF}) do
            frame.BackgroundColor3 = cur.main
            frame.BorderColor3 = cur.accent
        end
        l.TextColor3 = cur.accent
        tf.Visible = false -- Closes after pick
    end)
end
setT("Hacker", 10); setT("Blood", 45); setT("Mystical", 80); setT("Water", 115)

-- Core Logic (Autograb & Loops)
u.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.E and v.ag then
        local holdStart = tick()
        while u:IsKeyDown(Enum.KeyCode.E) do
            if tick() - holdStart >= 1.0 then
                if p.Character then p.Character:MoveTo(bs[v.b]) end
                break
            end
            task.wait(0.05)
        end
    end
end)

r.Stepped:Connect(function()
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local hrp, hum = p.Character.HumanoidRootPart, p.Character.Humanoid
        hud.Text = math.floor(hrp.Position.X).." | "..math.floor(hrp.Position.Y).." | "..math.floor(hrp.Position.Z)
        if v.blocker then hum.WalkSpeed = v.s hum.JumpPower = v.j end
        for _, part in pairs(p.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = not v.n part.CanTouch = not v.r end
        end
    end
end)
