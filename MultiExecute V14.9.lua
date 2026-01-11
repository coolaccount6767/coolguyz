local p = game.Players.LocalPlayer
local v = {n=false, r=false, f=false, s=60, j=50, b=1, a=false, blocker=false, theme="Hacker", esp=false}
local bs = {Vector3.new(75,3,82), Vector3.new(75,3,41), Vector3.new(72,3,-1), Vector3.new(79,3,-42), Vector3.new(81,3,-79)}
local m, u, r = p:GetMouse(), game:GetService("UserInputService"), game:GetService("RunService")

local target = (gethui and gethui()) or game:GetService("CoreGui")
local sg = Instance.new("ScreenGui", target)

-- Dynamic Theme Engine
local themes = {
    Hacker = {main = Color3.fromRGB(10, 10, 10), accent = Color3.fromRGB(0, 255, 150), font = Color3.new(1,1,1)},
    Blood = {main = Color3.fromRGB(15, 0, 0), accent = Color3.fromRGB(255, 0, 40), font = Color3.new(1,1,1)},
    Mystical = {main = Color3.fromRGB(10, 5, 30), accent = Color3.fromRGB(190, 0, 255), font = Color3.new(1,1,1)},
    Water = {main = Color3.fromRGB(0, 0, 0), accent = Color3.fromRGB(255, 255, 255), font = Color3.new(1,1,1)}
}
local cur = themes.Hacker

-- Premium Main Frame
local f = Instance.new("Frame", sg)
f.Size, f.Position, f.BackgroundColor3 = UDim2.new(0, 180, 0, 500), UDim2.new(0.5, -90, 0.5, -250), cur.main
f.BorderSizePixel, f.BorderColor3, f.Visible, f.Active, f.Draggable = 2, cur.accent, false, true, true

-- Title with Glow
local l = Instance.new("TextLabel", f)
l.Size, l.Text, l.TextColor3, l.BackgroundTransparency = UDim2.new(1, 0, 0, 35), "GEMINI | V18.0", cur.accent, 1
l.Font, l.TextSize = Enum.Font.GothamBold, 14

-- Coordinate HUD
local hud = Instance.new("TextLabel", f)
hud.Size, hud.Position = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 35)
hud.BackgroundTransparency, hud.TextColor3, hud.TextSize = 1, Color3.new(0.6, 0.6, 0.6), 10
hud.Font = Enum.Font.Code

-- Helper: Animated Button Creator
local function nb(parent, t, y, cb, c)
    local b = Instance.new("TextButton", parent)
    b.Size, b.Position, b.Text = UDim2.new(0.9, 0, 0, 24), UDim2.new(0.05, 0, 0, y), t
    b.BackgroundColor3, b.TextColor3 = c or Color3.fromRGB(25, 25, 25), Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.Font, b.TextSize = Enum.Font.Gotham, 11
    
    -- Hover effect
    b.MouseEnter:Connect(function() b.BackgroundColor3 = cur.accent; b.TextColor3 = Color3.new(0,0,0) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = c or Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(1,1,1) end)
    b.MouseButton1Click:Connect(function() cb(b) end) return b 
end

-- STARTUP SEQUENCE
local startF = Instance.new("Frame", sg)
startF.Size, startF.Position, startF.BackgroundColor3 = UDim2.new(0, 200, 0, 260), UDim2.new(0.5, -100, 0.5, -130), cur.main
startF.BorderSizePixel, startF.BorderColor3 = 2, cur.accent

local st = Instance.new("TextLabel", startF)
st.Size, st.Text, st.TextColor3, st.BackgroundTransparency = UDim2.new(1, 0, 0, 40), "SELECT YOUR BASE", cur.accent, 1
st.Font = Enum.Font.GothamBold

for i=1, 5 do
    nb(startF, "BASE "..i, 45 + (i*35), function()
        v.b = i
        p.Character.HumanoidRootPart.CFrame = CFrame.new(bs[i])
        startF:TweenPosition(UDim2.new(0.5, -100, 1, 50), "In", "Back", 0.5, true)
        task.wait(0.5); startF.Visible = false; f.Visible = true
    end)
end

-- MAIN FEATURES
nb(f, "NOCLIP", 70, function(b) v.n = not v.n b.BorderColor3 = v.n and cur.accent or Color3.new(0,0,0) end)
nb(f, "NOREACT", 98, function(b) v.r = not v.r end)
nb(f, "FLY", 126, function(b) v.f = not v.f end)
nb(f, "AUTOGRAB (1s)", 154, function(b) v.ag = not v.ag b.TextColor3 = v.ag and cur.accent or Color3.new(1,1,1) end)
nb(f, "3D MODEL ESP", 182, function(b) v.esp = not v.esp end)
nb(f, "BLOCK SPEED SYST", 210, function(b) v.blocker = not v.blocker end)
nb(f, "TP TO BASE", 238, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(bs[v.b]) end, Color3.fromRGB(40, 40, 60))

local function createReg(parent, label, y, def, valKey)
    local box = Instance.new("TextBox", parent)
    box.Size, box.Position, box.Text = UDim2.new(0.9, 0, 0, 25), UDim2.new(0.05, 0, 0, y), def.." "..label
    box.BackgroundColor3, box.TextColor3, box.BorderSizePixel = Color3.new(0,0,0), Color3.new(1,1,1), 0
    box.Font = Enum.Font.Code
    box.FocusLost:Connect(function() v[valKey] = tonumber(box.Text:match("%d+")) or def end)
end

createReg(f, "Speed", 270, 60, "s")
createReg(f, "Jump", 300, 50, "j")

-- TELEPORTS
nb(f, "CELESTIAL", 335, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2737, 3, -7) end)
nb(f, "SECRET", 363, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2461, 3, -2) end)
nb(f, "COSMIC", 391, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2005, 3, -9) end)
nb(f, "THEMES", 430, function() tf.Visible = not tf.Visible end, Color3.fromRGB(50, 20, 70))

-- THEME WINDOW
local tf = Instance.new("Frame", sg)
tf.Size, tf.Position, tf.BackgroundColor3 = UDim2.new(0, 120, 0, 150), UDim2.new(0.5, 100, 0.5, -50), cur.main
tf.BorderSizePixel, tf.BorderColor3, tf.Visible = 2, cur.accent, false

local function setT(n, y) nb(tf, n, y, function() 
    cur = themes[n]; f.BackgroundColor3 = cur.main; f.BorderColor3 = cur.accent; l.TextColor3 = cur.accent
    tf.BackgroundColor3 = cur.main; tf.BorderColor3 = cur.accent
end) end
setT("Hacker", 10); setT("Blood", 45); setT("Mystical", 80); setT("Water", 115)

-- CORE LOOPS
u.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.E and v.ag then
        local start = tick()
        while u:IsKeyDown(Enum.KeyCode.E) do
            if tick() - start >= 1 then p.Character.HumanoidRootPart.CFrame = CFrame.new(bs[v.b]) break end
            task.wait(0.1)
        end
    end
end)

r.Stepped:Connect(function()
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = p.Character.HumanoidRootPart
        hud.Text = string.format("X: %0.1f | Y: %0.1f | Z: %0.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
        if v.blocker then p.Character.Humanoid.WalkSpeed = v.s p.Character.Humanoid.JumpPower = v.j end
        for _, x in pairs(p.Character:GetDescendants()) do 
            if x:IsA("BasePart") then x.CanCollide = not v.n x.CanTouch = not v.r end 
        end
    end
end)
