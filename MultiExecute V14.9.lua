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
local allStrokes = {}
local allAccents = {}

-- DESIGN HELPERS
local function applyStyle(obj, radius, isAccent)
    local corner = Instance.new("UICorner", obj)
    corner.CornerRadius = UDim.new(0, radius or 6)
    local stroke = Instance.new("UIStroke", obj)
    stroke.Thickness, stroke.ApplyStrokeMode = 1.5, Enum.ApplyStrokeMode.Border
    stroke.Color = cur.accent
    table.insert(allStrokes, stroke)
    if isAccent then table.insert(allAccents, obj) end
    return stroke
end

local function updateUIThemes()
    for _, s in pairs(allStrokes) do s.Color = cur.accent end
    for _, t in pairs(allAccents) do 
        if t:IsA("TextLabel") or t:IsA("TextButton") then t.TextColor3 = cur.accent end 
    end
end

-- MAIN FRAME
local f = Instance.new("Frame", sg)
f.Size, f.Position, f.BackgroundColor3 = UDim2.new(0, 185, 0, 500), UDim2.new(0.5, -92, 0.5, -250), cur.main
f.Visible, f.Active, f.Draggable = false, true, true
applyStyle(f, 8)

local l = Instance.new("TextLabel", f)
l.Size, l.Text, l.BackgroundTransparency = UDim2.new(1, 0, 0, 35), "GEMINI V3", 1
l.Font, l.TextSize = Enum.Font.GothamBold, 16
l.TextColor3 = cur.accent
table.insert(allAccents, l)

-- STARTUP MENU
local startF = Instance.new("Frame", sg)
startF.Size, startF.Position, startF.BackgroundColor3 = UDim2.new(0, 200, 0, 260), UDim2.new(0.5, -100, 0.5, -130), cur.main
applyStyle(startF, 10)

local st = Instance.new("TextLabel", startF)
st.Size, st.Text, st.BackgroundTransparency = UDim2.new(1, 0, 0, 40), "Chose Ur Base", 1
st.Font, st.TextSize = Enum.Font.GothamBold, 18
st.TextColor3 = cur.accent
table.insert(allAccents, st)

-- BUTTON CREATOR
local function nb(parent, t, y, cb, c)
    local b = Instance.new("TextButton", parent)
    b.Size, b.Position, b.Text = UDim2.new(0.9, 0, 0, 26), UDim2.new(0.05, 0, 0, y), t
    b.BackgroundColor3, b.TextColor3 = c or Color3.fromRGB(30, 30, 30), Color3.new(1, 1, 1)
    b.BorderSizePixel = 0; b.Font = Enum.Font.GothamSemibold; b.TextSize = 11
    applyStyle(b, 4)
    b.MouseButton1Click:Connect(function() cb(b) end) return b 
end

for i=1, 5 do
    nb(startF, "BASE "..i, 45 + (i*35), function()
        v.b = i; p.Character:MoveTo(bs[i])
        startF.Visible = false; f.Visible = true
    end)
end

-- FLY SYSTEM (FIXED)
local cam = workspace.CurrentCamera
r.RenderStepped:Connect(function()
    if v.f and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = p.Character.HumanoidRootPart
        local moveDir = Vector3.new(0,0,0)
        if u:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
        if u:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
        if u:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
        if u:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
        
        hrp.Velocity = Vector3.new(0,0.1,0) -- Anti-fall
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (moveDir * (v.s/50))
        end
    end
end)

-- FEATURES
nb(f, "NOCLIP", 60, function(b) v.n = not v.n b.TextColor3 = v.n and cur.accent or Color3.new(1,1,1) end)
nb(f, "NOREACT", 90, function(b) v.r = not v.r b.TextColor3 = v.r and cur.accent or Color3.new(1,1,1) end)
nb(f, "FLY (W,A,S,D)", 120, function(b) v.f = not v.f b.TextColor3 = v.f and cur.accent or Color3.new(1,1,1) end)
nb(f, "AUTOGRAB (1s)", 150, function(b) v.ag = not v.ag b.TextColor3 = v.ag and cur.accent or Color3.new(1,1,1) end)
nb(f, "TP TO BASE", 180, function() p.Character:MoveTo(bs[v.b]) end, Color3.fromRGB(45, 55, 85))

local function createReg(parent, label, y, def, valKey)
    local box = Instance.new("TextBox", parent)
    box.Size, box.Position, box.Text = UDim2.new(0.9, 0, 0, 26), UDim2.new(0.05, 0, 0, y), def.." "..label
    box.BackgroundColor3, box.TextColor3 = Color3.fromRGB(10,10,10), Color3.new(1,1,1)
    applyStyle(box, 4)
    box.FocusLost:Connect(function() v[valKey] = tonumber(box.Text:match("%d+")) or def end)
end
createReg(f, "Speed", 220, 60, "s")
createReg(f, "Jump", 250, 50, "j")

nb(f, "CELESTIAL", 290, function() p.Character:MoveTo(Vector3.new(2737, 3, -7)) end)
nb(f, "SECRET", 320, function() p.Character:MoveTo(Vector3.new(2461, 3, -2)) end)
nb(f, "COSMIC", 350, function() p.Character:MoveTo(Vector3.new(2005, 3, -9)) end)

-- THEME SYSTEM (FIXED OUTLINES)
local tf = Instance.new("Frame", sg)
tf.Size, tf.Position, tf.BackgroundColor3 = UDim2.new(0, 130, 0, 160), UDim2.new(0.5, 100, 0.5, -80), cur.main
tf.Visible = false; applyStyle(tf, 8)

nb(f, "THEMES", 450, function() tf.Visible = not tf.Visible end, Color3.fromRGB(70, 40, 90))

local function setT(name, y)
    nb(tf, name, y, function()
        cur = themes[name]
        f.BackgroundColor3 = cur.main
        tf.BackgroundColor3 = cur.main
        startF.BackgroundColor3 = cur.main
        updateUIThemes()
        tf.Visible = false
    end)
end
setT("Hacker", 10); setT("Blood", 45); setT("Mystical", 80); setT("Water", 115)

-- LOOPS
u.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.E and v.ag then
        local s = tick()
        while u:IsKeyDown(Enum.KeyCode.E) do
            if tick()-s >= 1 then p.Character:MoveTo(bs[v.b]) break end
            task.wait(0.05)
        end
    end
end)

r.Stepped:Connect(function()
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        if v.blocker then p.Character.Humanoid.WalkSpeed = v.s p.Character.Humanoid.JumpPower = v.j end
        for _, x in pairs(p.Character:GetDescendants()) do
            if x:IsA("BasePart") then x.CanCollide = not v.n x.CanTouch = not v.r end
        end
    end
end)
