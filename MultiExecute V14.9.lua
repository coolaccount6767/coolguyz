local p = game.Players.LocalPlayer
local v = {n=false, r=false, f=false, s=60, j=50, b=1, a=false, blocker=false, theme="Hacker", esp=false, ag=false}
local bs = {Vector3.new(75,3,82), Vector3.new(75,3,41), Vector3.new(72,3,-1), Vector3.new(79,3,-42), Vector3.new(81,3,-79)}
local m, u, r = p:GetMouse(), game:GetService("UserInputService"), game:GetService("RunService")

local target = (gethui and gethui()) or game:GetService("CoreGui")
local sg = Instance.new("ScreenGui", target)

local themes = {
    Hacker = {main = Color3.fromRGB(15, 15, 15), accent = Color3.fromRGB(0, 255, 150)},
    Blood = {main = Color3.fromRGB(15, 5, 5), accent = Color3.fromRGB(255, 0, 0)},
    Mystical = {main = Color3.fromRGB(10, 10, 45), accent = Color3.fromRGB(180, 0, 255)},
    Water = {main = Color3.fromRGB(0, 45, 110), accent = Color3.fromRGB(255, 255, 255)}
}
local cur = themes.Hacker

-- DESIGN: MODERN FRAME
local function applyStyle(obj, radius)
    local corner = Instance.new("UICorner", obj)
    corner.CornerRadius = UDim.new(0, radius or 6)
    local stroke = Instance.new("UIStroke", obj)
    stroke.Thickness, stroke.ApplyStrokeMode = 1.5, Enum.ApplyStrokeMode.Border
    stroke.Color = cur.accent
    return stroke
end

local f = Instance.new("Frame", sg)
f.Size, f.Position, f.BackgroundColor3 = UDim2.new(0, 185, 0, 500), UDim2.new(0.5, -92, 0.5, -250), cur.main
f.Visible, f.Active, f.Draggable = false, true, true
local fStroke = applyStyle(f, 8)

local l = Instance.new("TextLabel", f)
l.Size, l.Text, l.TextColor3, l.BackgroundTransparency = UDim2.new(1, 0, 0, 35), "GEMINI V2.0", cur.accent, 1
l.Font, l.TextSize = Enum.Font.GothamBold, 16

local hud = Instance.new("TextLabel", f)
hud.Size, hud.Position = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 32)
hud.TextSize, hud.TextColor3, hud.BackgroundTransparency = 10, Color3.new(0.8,0.8,0.8), 1
hud.Font = Enum.Font.Code

-- FLY LOGIC (FIXED & SMOOTH)
local flySpeed = 50
local bv, bg
local function toggleFly()
    if v.f then
        local char = p.Character or p.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        bv = Instance.new("BodyVelocity", root)
        bg = Instance.new("BodyGyro", root)
        bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        bg.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
        
        task.spawn(function()
            while v.f and char:Parent() do
                bg.CFrame = workspace.CurrentCamera.CFrame
                local dir = Vector3.new(0,0,0)
                if u:IsKeyDown(Enum.KeyCode.W) then dir = dir + workspace.CurrentCamera.CFrame.LookVector end
                if u:IsKeyDown(Enum.KeyCode.S) then dir = dir - workspace.CurrentCamera.CFrame.LookVector end
                if u:IsKeyDown(Enum.KeyCode.D) then dir = dir + workspace.CurrentCamera.CFrame.RightVector end
                if u:IsKeyDown(Enum.KeyCode.A) then dir = dir - workspace.CurrentCamera.CFrame.RightVector end
                bv.Velocity = dir * v.s
                r.RenderStepped:Wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end
end

-- BETTER BUTTONS
local function nb(parent, t, y, cb, c)
    local b = Instance.new("TextButton", parent)
    b.Size, b.Position, b.Text = UDim2.new(0.9, 0, 0, 26), UDim2.new(0.05, 0, 0, y), t
    b.BackgroundColor3, b.TextColor3 = c or Color3.fromRGB(30, 30, 30), Color3.new(1, 1, 1)
    b.BorderSizePixel = 0; b.Font = Enum.Font.GothamSemibold; b.TextSize = 12
    applyStyle(b, 4)
    b.MouseButton1Click:Connect(function() cb(b) end) return b 
end

-- STARTUP MENU
local startF = Instance.new("Frame", sg)
startF.Size, startF.Position, startF.BackgroundColor3 = UDim2.new(0, 200, 0, 260), UDim2.new(0.5, -100, 0.5, -130), cur.main
applyStyle(startF, 10)

for i=1, 5 do
    nb(startF, "BASE "..i, 45 + (i*35), function()
        v.b = i; p.Character:MoveTo(bs[i])
        startF:TweenPosition(UDim2.new(0.5, -100, 1.2, 0), "In", "Back", 0.5)
        task.wait(0.5); startF.Visible = false; f.Visible = true
    end)
end

-- MAIN FEATURES
nb(f, "NOCLIP", 60, function(b) v.n = not v.n b.TextColor3 = v.n and cur.accent or Color3.new(1,1,1) end)
nb(f, "NOREACT", 90, function(b) v.r = not v.r b.TextColor3 = v.r and cur.accent or Color3.new(1,1,1) end)
nb(f, "FLY (W,A,S,D)", 120, function(b) v.f = not v.f toggleFly() b.TextColor3 = v.f and cur.accent or Color3.new(1,1,1) end)
nb(f, "AUTOGRAB (1s)", 150, function(b) v.ag = not v.ag b.TextColor3 = v.ag and cur.accent or Color3.new(1,1,1) end)
nb(f, "3D MODEL ESP", 180, function(b) v.esp = not v.esp b.TextColor3 = v.esp and cur.accent or Color3.new(1,1,1) end)
nb(f, "SPEED BLOCKER", 210, function(b) v.blocker = not v.blocker b.TextColor3 = v.blocker and cur.accent or Color3.new(1,1,1) end)
nb(f, "TP TO BASE", 240, function() p.Character:MoveTo(bs[v.b]) end, Color3.fromRGB(45, 55, 85))

local function createReg(parent, label, y, def, valKey)
    local box = Instance.new("TextBox", parent)
    box.Size, box.Position, box.Text = UDim2.new(0.9, 0, 0, 26), UDim2.new(0.05, 0, 0, y), def.." "..label
    box.BackgroundColor3, box.TextColor3 = Color3.fromRGB(10,10,10), Color3.new(1,1,1)
    applyStyle(box, 4).Color = Color3.fromRGB(60,60,60)
    box.FocusLost:Connect(function() v[valKey] = tonumber(box.Text:match("%d+")) or def end)
end
createReg(f, "Speed", 280, 60, "s")
createReg(f, "Jump", 310, 50, "j")

nb(f, "CELESTIAL", 350, function() p.Character:MoveTo(Vector3.new(2737, 3, -7)) end)
nb(f, "SECRET", 380, function() p.Character:MoveTo(Vector3.new(2461, 3, -2)) end)
nb(f, "COSMIC", 410, function() p.Character:MoveTo(Vector3.new(2005, 3, -9)) end)

-- THEME SYSTEM
local tf = Instance.new("Frame", sg)
tf.Size, tf.Position, tf.BackgroundColor3 = UDim2.new(0, 130, 0, 160), UDim2.new(0.5, 100, 0.5, -80), cur.main
tf.Visible = false; local tfStroke = applyStyle(tf, 8)

nb(f, "THEMES", 450, function() tf.Visible = not tf.Visible end, Color3.fromRGB(70, 40, 90))

local function setT(name, y)
    nb(tf, name, y, function()
        cur = themes[name]
        f.BackgroundColor3, tf.BackgroundColor3, startF.BackgroundColor3 = cur.main, cur.main, cur.main
        fStroke.Color, tfStroke.Color, l.TextColor3 = cur.accent, cur.accent, cur.accent
        tf.Visible = false
    end)
end
setT("Hacker", 10); setT("Blood", 45); setT("Mystical", 80); setT("Water", 115)

-- AUTOGRAB & LOOPS
u.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.E and v.ag then
        local holdStart = tick()
        while u:IsKeyDown(Enum.KeyCode.E) do
            if tick() - holdStart >= 1.0 then p.Character:MoveTo(bs[v.b]) break end
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
