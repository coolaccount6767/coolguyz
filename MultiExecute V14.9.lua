local p = game.Players.LocalPlayer
local v = {n=false, r=false, f=false, s=60, b=1, a=false}
local bs = {Vector3.new(75,3,82), Vector3.new(75,3,41), Vector3.new(72,3,-1), Vector3.new(79,3,-42), Vector3.new(81,3,-79)}
local m, u, r = p:GetMouse(), game:GetService("UserInputService"), game:GetService("RunService")

-- DELTA COMPATIBILITY UI PARENT
local target = (gethui and gethui()) or game:GetService("CoreGui")
local sg = Instance.new("ScreenGui", target)
local f = Instance.new("Frame", sg)
-- Expanded height to 520 to fit the script log
f.Size, f.Position, f.BackgroundColor3 = UDim2.new(0, 150, 0, 520), UDim2.new(0.5, -75, 0.5, -260), Color3.fromRGB(20, 20, 20)
f.BorderSizePixel, f.BorderColor3, f.Active, f.Draggable = 2, Color3.fromRGB(0, 255, 150), true, true

local l = Instance.new("TextLabel", f)
l.Size, l.Text, l.TextColor3, l.BackgroundTransparency = UDim2.new(1, 0, 0, 25), "V14.8 FIXED", Color3.new(0, 1, 0.6), 1

--- RUNNED SCRIPTS SECTION ---
local logLabel = Instance.new("TextLabel", f)
logLabel.Size, logLabel.Position, logLabel.Text = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 310), "RUNNED SCRIPTS:"
logLabel.TextColor3, logLabel.BackgroundTransparency, logLabel.TextSize = Color3.new(0, 1, 0.6), 1, 12

local sc = Instance.new("ScrollingFrame", f)
sc.Size, sc.Position = UDim2.new(0.9, 0, 0, 170), UDim2.new(0.05, 0, 0, 335)
sc.BackgroundColor3, sc.BorderSizePixel = Color3.fromRGB(10, 10, 10), 0
sc.ScrollBarThickness, sc.CanvasSize = 4, UDim2.new(0, 0, 0, 0)

local uiList = Instance.new("UIListLayout", sc)
uiList.SortOrder = Enum.SortOrder.LayoutOrder

local function logScript(name)
    local txt = Instance.new("TextLabel", sc)
    txt.Size = UDim2.new(1, -5, 0, 18)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    txt.Text = "> " .. name
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.TextSize = 11
    sc.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y)
    sc.CanvasPosition = Vector2.new(0, sc.CanvasSize.Y.Offset)
end
------------------------------

local function nb(t, y, cb, c)
    local b = Instance.new("TextButton", f)
    b.Size, b.Position, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0.9, 0, 0, 24), UDim2.new(0.05, 0, 0, y), t, c or Color3.fromRGB(35, 35, 35), Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() 
        logScript(t) -- Logs the script name when clicked
        cb(b) 
    end) return b 
end

-- BUTTONS
nb("NOCLIP", 30, function(b) v.n = not v.n b.TextColor3 = v.n and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb("NOREACT", 56, function(b) v.r = not v.r b.TextColor3 = v.r and Color3.new(0,1,0) or Color3.new(1,1,1) end)
nb("FLY", 82, function(b) v.f = not v.f b.TextColor3 = v.f and Color3.new(0,1,0) or Color3.new(1,1,1)
    if v.f then local rt, h, cam = p.Character.HumanoidRootPart, p.Character.Humanoid, workspace.CurrentCamera
    local bv, bg = Instance.new("BodyVelocity", rt), Instance.new("BodyGyro", rt) bv.MaxForce, bg.MaxTorque = Vector3.new(1,1,1)*1e9, Vector3.new(1,1,1)*1e9
    task.spawn(function() while v.f do bg.CFrame = cam.CFrame bv.Velocity = (h.MoveDirection.Magnitude > 0) and cam.CFrame.LookVector * v.s or Vector3.new(0,0,0) task.wait() end bv:Destroy() bg:Destroy() end) end 
end)
nb("SAVE / TP", 108, function(b) if not v.sp then v.sp = p.Character.HumanoidRootPart.CFrame b.Text = "TP" else p.Character.HumanoidRootPart.CFrame = v.sp v.sp = nil b.Text = "SAVE" end end)
nb("AUTOBUY", 134, function(b) v.a = not v.a b.TextColor3 = v.a and Color3.new(0,0.7,1) or Color3.new(1,1,1)
    if v.a then task.spawn(function() while v.a do local rt = p.Character:FindFirstChild("HumanoidRootPart") if rt then rt.CFrame = CFrame.new(136, 3, 0) game:GetService("VirtualUser"):ClickButton1(Vector2.new(139, 4)) end task.wait(0.05) end end) end 
end)
nb("BASE CYCLE", 160, function(b) p.Character.HumanoidRootPart.CFrame = CFrame.new(bs[v.b]) v.b = (v.b % 5) + 1 b.Text = "BASE " .. v.b end, Color3.fromRGB(45, 65, 45))
nb("CELESTIAL", 186, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2737, 3, -7) end)
nb("SECRET", 212, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2461, 3, -2) end)
nb("COSMIC", 238, function() p.Character.HumanoidRootPart.CFrame = CFrame.new(2005, 3, -9) end)

local s = Instance.new("TextBox", f)
s.Size, s.Position, s.Text, s.BackgroundColor3, s.TextColor3 = UDim2.new(0.9, 0, 0, 25), UDim2.new(0.05, 0, 0, 270), "60 Speed", Color3.new(0,0,0), Color3.new(1,1,0)
s.FocusLost:Connect(function() v.s = tonumber(s.Text:match("%d+")) or 60 end)

r.Stepped:Connect(function() if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local rt = p.Character.HumanoidRootPart
    l.Text = math.floor(rt.Position.X) .. " | " .. math.floor(rt.Position.Y) .. " | " .. math.floor(rt.Position.Z)
    for _, x in pairs(p.Character:GetDescendants()) do if x:IsA("BasePart") then x.CanCollide = not v.n x.CanTouch = not v.r end end 
end end)
u.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.F5 then v.a = false end end)