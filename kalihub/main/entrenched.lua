--this shit was unobfuscated


local getgenv, getnamecallmethod, hookmetamethod, hookfunction, newcclosure, checkcaller, gsub = getgenv, getnamecallmethod, hookmetamethod, hookfunction, newcclosure, checkcaller, string.gsub
if not getgenv().ED_AK then
local cloneref = cloneref or function(...) return ... end
local clonefunction = clonefunction or function(...) return ... end
local Plrs = cloneref(game:GetService("Players"))
local Me = cloneref(Plrs.LocalPlayer)
local FindFirstChild = clonefunction(game.FindFirstChild)
local CompareInst = (CompareInstances and function(a, b)
if typeof(a) == "Instance" and typeof(b) == "Instance" then return CompareInstances(a, b) end
end) or function(a, b) return typeof(a) == "Instance" and typeof(b) == "Instance" end
local CanCast = function(...) return pcall(FindFirstChild, game, ...) end
getgenv().ED_AK = { Enabled = true, CheckCaller = true }
local OldNC; OldNC = hookmetamethod(game, "__namecall", newcclosure(function(...)
local self, msg = ...; local method = getnamecallmethod()
if ((ED_AK.CheckCaller and not checkcaller()) or true) and CompareInst(self, Me) and gsub(method, "^%l", string.upper) == "Kick" and ED_AK.Enabled then
if CanCast(msg) then return end
end
return OldNC(...)
end))
local OldFn; OldFn = hookfunction(Me.Kick, newcclosure(function(...)
local self, msg = ...
if ((ED_AK.CheckCaller and not checkcaller()) or true) and CompareInst(self, Me) and ED_AK.Enabled then
if CanCast(msg) then return end
end
return OldFn(...)
end))
end
if getgenv().KaliEntrenched then pcall(getgenv().KaliEntrenched) end
local Players = game:GetService("Players")
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Storage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local ServerEvents = Storage:WaitForChild("ServerEvents")
local ClientEvents = Storage:WaitForChild("ClientEvents")
local Bin = { conns = {}, draws = {}, restore = {}, dead = false }
local function track(c) table.insert(Bin.conns, c); return c end
local function newDraw(class)
local d = Drawing.new(class)
table.insert(Bin.draws, d)
return d
end
local F = {
Silent = false, SilentLook = false,
SilentPart = "Head", SilentMiss = false, SilentMissPct = 10,
WHead = 20, WTorso = 60, WLimb = 20,
Rage = false, RageAuto = false, RageFullScreen = true,
Aimbot = false, AimSmooth = 5, AimPart = "Head", AimWall = false,
AimKey = Enum.UserInputType.MouseButton2,
Trigger = false, TriggerDelay = 0.02,
AimTeam = true,
FovShow = false, FovSize = 150, FovColor = Color3.fromRGB(255, 255, 255),
Snap = false, SnapColor = Color3.fromRGB(255, 255, 255),
NoRecoil = false, NoSpread = false,
FastBolt = false, BoltMult = 3,
RapidFire = false, FireRate = 600,
Melee = false, MeleeRange = 5,
Esp = false, EspBox = false, EspTracer = false, EspName = false,
EspDist = false, EspHealth = false, EspTeam = true,
EspTeamColor = false, EspVisColor = false, EspMax = 1000,
EspColor = Color3.fromRGB(255, 255, 255),
Clear = false, Bright = false,
Fly = false, FlySpeed = 35,
Speed = false, SpeedValue = 24,
AutoDeploy = false, AutoClaim = false, AutoRevive = false,
HitMark = false,
}
local RIG = {}
for _, n in ipairs({
"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart",
"LeftUpperArm", "LeftLowerArm", "LeftHand",
"RightUpperArm", "RightLowerArm", "RightHand",
"LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
"RightUpperLeg", "RightLowerLeg", "RightFoot",
}) do RIG[n] = true end
local NEAR = { "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg" }
local TORSO = { "UpperTorso", "LowerTorso" }
local LIMBS = { "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg" }
local visParams = RaycastParams.new()
visParams.FilterType = Enum.RaycastFilterType.Exclude
visParams.IgnoreWater = true
pcall(function() visParams.CollisionGroup = "Projectiles" end)
local function canSee(part, char)
visParams.FilterDescendantsInstances = { LP.Character, char }
local origin = Cam.CFrame.Position
return workspace:Raycast(origin, part.Position - origin, visParams) == nil
end
local shotParams = RaycastParams.new()
shotParams.FilterType = Enum.RaycastFilterType.Exclude
shotParams.IgnoreWater = true
pcall(function() shotParams.CollisionGroup = "Projectiles" end)
local function shotClear(part, char)
local myChar = LP.Character
local head = myChar and myChar:FindFirstChild("Head")
if not head then return false end
local origin = head.Position
shotParams.FilterDescendantsInstances = { myChar }
local hit = workspace:Raycast(origin, part.Position - origin, shotParams)
return hit ~= nil and hit.Instance:IsDescendantOf(char)
end
local GuiService = game:GetService("GuiService")
local function mousePoint()
local ok, p = pcall(function()
local dot = (LP.PlayerGui.GameGui.headsUpDisplay.Cursor.crossHair.targetDot.closestToTrueCenter) :: any
return dot.AbsolutePosition + GuiService:GetGuiInset()
end)
if ok and p then return p end
return Cam.ViewportSize / 2
end
local function enemyOf(p, teamCheck)
if p == LP then return nil end
local char = p.Character
if not char then return nil end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 then return nil end
if teamCheck and p.Team and LP.Team and p.Team == LP.Team then return nil end
return char, hum
end
local function gather(char, list)
local out = {}
for _, n in ipairs(list) do
local p = char:FindFirstChild(n)
if p and p:IsA("BasePart") then table.insert(out, p) end
end
return out
end
local function aimPartOf(char, mode, mouse)
if mode == "Closest" then
local best, bd = nil, math.huge
for _, p in ipairs(gather(char, NEAR)) do
local s, on = Cam:WorldToViewportPoint(p.Position)
if on then
local d = (Vector2.new(s.X, s.Y) - mouse).Magnitude
if d < bd then bd, best = d, p end
end
end
return best
elseif mode == "Random" then
local total = F.WHead + F.WTorso + F.WLimb
if total > 0 then
local roll = math.random(1, total)
local pool
if roll <= F.WHead then
pool = gather(char, { "Head" })
elseif roll <= F.WHead + F.WTorso then
pool = gather(char, TORSO)
else
pool = gather(char, LIMBS)
end
if #pool > 0 then return pool[math.random(1, #pool)] end
end
return char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
end
return char:FindFirstChild(mode) or char:FindFirstChild("HumanoidRootPart")
end
local function findTarget(mode, gate)
local mouse = mousePoint()
local fov = F.FovSize
if F.Rage and F.RageFullScreen then fov = math.huge end
local bestPlr, bestPart, bestDist = nil, nil, fov
for _, p in ipairs(Players:GetPlayers()) do
local char = enemyOf(p, F.AimTeam)
if char then
local part = aimPartOf(char, mode, mouse)
if part and RIG[part.Name] then
local s, on = Cam:WorldToViewportPoint(part.Position)
if on then
local d = (Vector2.new(s.X, s.Y) - mouse).Magnitude
if d <= bestDist then
local pass = true
if gate == "reach" then
pass = shotClear(part, char)
elseif gate == "sight" then
pass = canSee(part, char)
end
if pass then bestDist, bestPlr, bestPart = d, p, part end
end
end
end
end
end
return bestPlr, bestPart
end
local weaponState
local modTable, weaponEnv, onDeployed
do
local info = debug.getinfo or getinfo
for _, v in next, getgc(true) do
if type(v) == "function" then
local ok, i = pcall(info, v)
if ok and type(i) == "table" then
local name = i.name or ""
local source = tostring(i.source or "")
if source:find("WeaponModule") then
if not weaponEnv and name == "shootEffect" then
local ok2, env = pcall(getfenv, v)
if ok2 and type(env) == "table" and rawget(env, "bulletMagnetism") then weaponEnv = env end
end
if not modTable and name == "Equip" then
for _, u in next, getupvalues(v) do
if type(u) == "table" and rawget(u, "Shoot") and rawget(u, "speedChanger") then
modTable = u
break
end
end
end
elseif not onDeployed and name == "onDeployed" and source:find("InterfaceScript") then
onDeployed = v
end
end
end
if weaponEnv and modTable and onDeployed then break end
end
end
local saved = setmetatable({}, { __mode = "k" })
local function slotFor(tool)
local t = saved[tool]
if not t then t = {}; saved[tool] = t end
return t
end
local function applyMods(tool, state)
local s = slotFor(tool)
if F.NoRecoil then
if s.recoil == nil then
s.recoil = tool:GetAttribute("Recoil") or 0
s.pattern = state.RecoilPattern
end
tool:SetAttribute("Recoil", 0)
state.RecoilPattern = {}
elseif s.recoil ~= nil then
tool:SetAttribute("Recoil", s.recoil)
state.RecoilPattern = s.pattern
s.recoil, s.pattern = nil, nil
end
local bloom = tool:FindFirstChild("Bloom")
if F.NoSpread and bloom then
if s.bloom == nil then
s.bloom = bloom.Value
s.spread = tool:GetAttribute("SpreadDefault")
end
bloom.Value = 0
tool:SetAttribute("SpreadDefault", 1e6)
elseif s.bloom ~= nil then
if bloom then bloom.Value = s.bloom end
tool:SetAttribute("SpreadDefault", s.spread)
s.bloom, s.spread = nil, nil
end
if F.FastBolt then
if s.delay == nil then s.delay = tool:GetAttribute("FireDelay") or 1 end
tool:SetAttribute("FireDelay", 2 - (2 - s.delay) * F.BoltMult)
elseif s.delay ~= nil then
tool:SetAttribute("FireDelay", s.delay)
s.delay = nil
end
if F.RapidFire then
if s.rof == nil then s.rof = tool:GetAttribute("rateOfFire") or false end
tool:SetAttribute("rateOfFire", F.FireRate)
elseif s.rof ~= nil then
tool:SetAttribute("rateOfFire", s.rof or nil)
s.rof = nil
end
end
local function restoreMods()
for tool, s in pairs(saved) do
if typeof(tool) == "Instance" and tool.Parent then
if s.recoil ~= nil then tool:SetAttribute("Recoil", s.recoil) end
if s.spread ~= nil then tool:SetAttribute("SpreadDefault", s.spread) end
if s.bloom ~= nil then
local b = tool:FindFirstChild("Bloom")
if b then b.Value = s.bloom end
end
if s.delay ~= nil then tool:SetAttribute("FireDelay", s.delay) end
if s.rof ~= nil then tool:SetAttribute("rateOfFire", s.rof or nil) end
end
end
end
if weaponEnv then
local original = weaponEnv.bulletMagnetism
Bin.restore.magnet = function() weaponEnv.bulletMagnetism = original end
weaponEnv.bulletMagnetism = function(state, endPos)
if type(state) == "table" and typeof(state.Tool) == "Instance" then weaponState = state end
if (F.Silent or F.Rage) and type(state) == "table" and state.Character == LP.Character then
local skip = F.SilentMiss and math.random(1, 100) <= F.SilentMissPct
if not skip then
local _, part = findTarget(F.SilentPart, "reach")
if part then return part.Position end
end
end
return original(state, endPos)
end
end
if modTable then
local oldShoot = modTable.Shoot
Bin.restore.shoot = function() modTable.Shoot = oldShoot end
modTable.Shoot = function(s, ...)
if type(s) == "table" and typeof(s.Tool) == "Instance" then
weaponState = s
pcall(applyMods, s.Tool, s)
end
return oldShoot(s, ...)
end
local oldEquip = rawget(modTable, "Equip")
if type(oldEquip) == "function" then
Bin.restore.equip = function() modTable.Equip = oldEquip end
modTable.Equip = function(s, ...)
if type(s) == "table" and typeof(s.Tool) == "Instance" then weaponState = s end
return oldEquip(s, ...)
end
end
end
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
local method = getnamecallmethod()
if method == "FireServer" and not Bin.dead and F.SilentLook and typeof(self) == "Instance" then
local parent = self.Parent
if parent and parent.Name == "ServerEvents" and self.Name == "LookAngle" then
local n = select("#", ...)
if n >= 2 then
local args = { ... }
local _, part = findTarget(F.SilentPart, "reach")
if part then
args[2] = part.Position - Cam.CFrame.Position
setnamecallmethod(method)
return oldNamecall(self, table.unpack(args, 1, n))
end
end
end
end
setnamecallmethod(method)
return oldNamecall(self, ...)
end))
local function aimKeyDown()
local k = F.AimKey
if typeof(k) == "EnumItem" and k.EnumType == Enum.UserInputType then
return UIS:IsMouseButtonPressed(k)
end
return UIS:IsKeyDown(k)
end
local fovOut = newDraw("Circle"); fovOut.Thickness = 3; fovOut.Color = Color3.new(); fovOut.ZIndex = 1
local fovIn = newDraw("Circle"); fovIn.Transparency = 1; fovIn.Thickness = 1; fovIn.ZIndex = 2
local snapLine = newDraw("Line"); snapLine.Thickness = 1; snapLine.Visible = false
local marker = {}
for i = 1, 4 do
local l = newDraw("Line")
l.Thickness = 2
l.Color = Color3.fromRGB(255, 255, 255)
l.Visible = false
marker[i] = l
end
local markerUntil = 0
local esp = {}
local function makeEsp(p)
if esp[p] then return end
local d = {
box = newDraw("Square"),
name = newDraw("Text"),
health = newDraw("Line"),
tracer = newDraw("Line"),
}
d.name.Size = 16; d.name.Center = true; d.name.Outline = true
d.health.Thickness = 2
d.tracer.Thickness = 1
d.box.Thickness = 1; d.box.Filled = false
esp[p] = d
end
local function hideEsp(d)
d.box.Visible = false
d.name.Visible = false
d.health.Visible = false
d.tracer.Visible = false
end
for _, p in ipairs(Players:GetPlayers()) do makeEsp(p) end
track(Players.PlayerAdded:Connect(makeEsp))
track(Players.PlayerRemoving:Connect(function(p)
local d = esp[p]
if d then
for _, v in pairs(d) do pcall(function() v:Remove() end) end
esp[p] = nil
end
end))
track(RunS.RenderStepped:Connect(function()
if Bin.dead then return end
local mouse = mousePoint()
fovIn.Position = mouse; fovOut.Position = mouse
fovIn.Radius = F.FovSize; fovOut.Radius = F.FovSize
fovIn.Color = F.FovColor
fovIn.Visible = F.FovShow; fovOut.Visible = F.FovShow
if F.Aimbot and aimKeyDown() then
local _, part = findTarget(F.AimPart, F.AimWall and "sight" or nil)
if part then
local cf = Cam.CFrame
Cam.CFrame = cf:Lerp(CFrame.new(cf.Position, part.Position), 1 / math.max(1, F.AimSmooth))
end
end
if F.Snap then
local _, part = findTarget(F.SilentPart, "reach")
if part then
local s, on = Cam:WorldToViewportPoint(part.Position)
if on then
snapLine.From = mouse
snapLine.To = Vector2.new(s.X, s.Y)
snapLine.Color = F.SnapColor
snapLine.Visible = true
else
snapLine.Visible = false
end
else
snapLine.Visible = false
end
else
snapLine.Visible = false
end
if markerUntil > 0 then
if os.clock() > markerUntil then
markerUntil = 0
for i = 1, 4 do marker[i].Visible = false end
else
local off = { Vector2.new(-10, -10), Vector2.new(10, -10), Vector2.new(-10, 10), Vector2.new(10, 10) }
for i = 1, 4 do
local o = off[i]
marker[i].From = mouse + o * 0.4
marker[i].To = mouse + o
marker[i].Visible = true
end
end
end
local origin = Cam.CFrame.Position
for p, d in pairs(esp) do
local char = F.Esp and enemyOf(p, F.EspTeam)
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hrp or not hum or (hrp.Position - origin).Magnitude > F.EspMax then
hideEsp(d)
else
local s, on = Cam:WorldToViewportPoint(hrp.Position)
if not on then
hideEsp(d)
else
local top = Cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
local bot = Cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
local ext = bot.Y - top.Y
local w = ext / 2
local color = F.EspColor
if F.EspTeamColor and p.TeamColor then color = p.TeamColor.Color end
if F.EspVisColor then
color = canSee(hrp, char) and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(255, 90, 90)
end
d.box.Visible = F.EspBox
d.box.Size = Vector2.new(w, ext)
d.box.Position = Vector2.new(top.X - w / 2, top.Y)
d.box.Color = color
d.tracer.Visible = F.EspTracer
d.tracer.From = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y)
d.tracer.To = Vector2.new(s.X, s.Y)
d.tracer.Color = color
d.name.Visible = F.EspName or F.EspDist
d.name.Position = Vector2.new(top.X, top.Y - 18)
d.name.Color = color
d.name.Text = (F.EspName and p.Name or "")
.. (F.EspDist and (" [" .. math.floor((hrp.Position - origin).Magnitude) .. "]") or "")
d.health.Visible = F.EspHealth
if F.EspHealth then
local ratio = hum.Health / math.max(1, hum.MaxHealth)
d.health.From = Vector2.new(top.X - w / 2 - 4, bot.Y)
d.health.To = Vector2.new(top.X - w / 2 - 4, bot.Y - ext * ratio)
d.health.Color = Color3.new(1 - ratio, ratio, 0)
end
end
end
end
end))
track(RunS.Heartbeat:Connect(function()
if Bin.dead then return end
local char = LP.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hrp or not hum then return end
if F.Fly then
local dir = Vector3.zero
local move = hum.MoveDirection
if move.Magnitude > 0 then
local rel = Cam.CFrame:VectorToObjectSpace(move)
dir = (Cam.CFrame.LookVector * -rel.Z) + (Cam.CFrame.RightVector * rel.X)
end
local up = (UIS:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) + (UIS:IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0)
dir = dir + Vector3.new(0, up, 0)
if dir.Magnitude > 0 then dir = dir.Unit * F.FlySpeed end
hrp.AssemblyLinearVelocity = dir
elseif F.Speed then
local state = hum:GetState()
if state == Enum.HumanoidStateType.Running
or state == Enum.HumanoidStateType.RunningNoPhysics
or state == Enum.HumanoidStateType.Freefall then
local move = hum.MoveDirection
if move.Magnitude > 0 then
local flat = move.Unit * F.SpeedValue
local v = hrp.AssemblyLinearVelocity
hrp.AssemblyLinearVelocity = Vector3.new(flat.X, v.Y, flat.Z)
end
end
end
end))
track(ClientEvents.Hit.OnClientEvent:Connect(function()
if F.HitMark then markerUntil = os.clock() + 0.15 end
end))
local fireClock = 0
local function pullTrigger()
local state = weaponState
if not modTable or type(state) ~= "table" then return end
local tool = state.Tool
if typeof(tool) ~= "Instance" or tool.Parent ~= LP.Character then return end
if tool:GetAttribute("CanFire") == false then return end
local ammo = tool:FindFirstChild("AmmoLoaded")
if ammo and ammo.Value < 1 then return end
fireClock = os.clock()
pcall(modTable.Shoot, state, true)
end
local function fireTrigger()
local rageFire = F.Rage and F.RageAuto
if not F.Trigger and not rageFire then return end
if os.clock() - fireClock < F.TriggerDelay then return end
local _, part = findTarget(F.AimPart, "reach")
if not part then return end
if not rageFire then
local s, on = Cam:WorldToViewportPoint(part.Position)
if not on then return end
if (Vector2.new(s.X, s.Y) - mousePoint()).Magnitude > 12 then return end
end
pullTrigger()
end
local meleeClock = 0
local function fireMelee()
if not F.Melee then return end
local state = weaponState
if type(state) ~= "table" or typeof(state.Tool) ~= "Instance" then return end
local tool = state.Tool
if tool.Parent ~= LP.Character then return end
local dmg = tool:GetAttribute("MeleeDamage")
if not dmg or dmg <= 0 then return end
local cd = tool:GetAttribute("MeleeCooldown") or 0.7
if os.clock() - meleeClock < cd then return end
local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not hrp then return end
for _, p in ipairs(Players:GetPlayers()) do
local char, hum = enemyOf(p, true)
if char then
local part = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
if part and (part.Position - hrp.Position).Magnitude <= F.MeleeRange then
meleeClock = os.clock()
ServerEvents.Melee:FireServer(state, part, hum)
return
end
end
end
end
local deployClock = 0
local function autoDeploy()
if not F.AutoDeploy then return end
if os.clock() - deployClock < 2 then return end
if LP:GetAttribute("CanDeploy") ~= true then return end
local gui = LP:FindFirstChild("PlayerGui")
gui = gui and gui:FindFirstChild("GameGui")
local menu = gui and gui:FindFirstChild("Menu")
if not menu or not menu.Visible then return end
local main = menu:FindFirstChild("MainFrame")
local btn = main and main:FindFirstChild("Deploy")
if not btn or not btn.Visible or not btn.Interactable then return end
deployClock = os.clock()
if ServerEvents.Deploy:InvokeServer() == true and onDeployed then
pcall(onDeployed)
end
end
local claimClock = 0
local function autoClaim()
if not F.AutoClaim then return end
if os.clock() - claimClock < 1 then return end
local df = LP:FindFirstChild("dataFolder")
local list = df and df:FindFirstChild("AssignedMissions")
if not list then return end
for _, m in ipairs(list:GetChildren()) do
local goal = m:GetAttribute("Goal")
if goal and m.Value >= goal and m:GetAttribute("Rewarded") ~= true then
claimClock = os.clock()
ServerEvents.ClaimMissionReward:FireServer(m.Name)
return
end
end
end
local function autoRevive()
if not F.AutoRevive then return end
local char = LP.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp or not fireproximityprompt then return end
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LP and p.Team == LP.Team and p.Character then
local root = p.Character:FindFirstChild("HumanoidRootPart")
local prompt = root and root:FindFirstChildOfClass("ProximityPrompt")
if prompt and prompt.Enabled and (root.Position - hrp.Position).Magnitude <= prompt.MaxActivationDistance then
pcall(fireproximityprompt, prompt)
return
end
end
end
end
task.spawn(function()
while not Bin.dead do
pcall(fireTrigger)
pcall(fireMelee)
pcall(autoDeploy)
pcall(autoClaim)
pcall(autoRevive)
task.wait(0.05)
end
end)
local sky = {}
local function applyWorld()
local atm = Lighting:FindFirstChildOfClass("Atmosphere")
if atm then
if sky.density == nil then
sky.density = atm.Density
sky.haze = atm.Haze
sky.fog = Lighting.FogEnd
end
if F.Clear then
atm.Density = 0
atm.Haze = 0
Lighting.FogEnd = 100000
else
atm.Density = sky.density
atm.Haze = sky.haze
Lighting.FogEnd = sky.fog
end
end
local rain = LP:FindFirstChild("PlayerScripts")
rain = rain and rain:FindFirstChild("RainScript")
if rain then rain.Disabled = F.Clear end
if sky.ambient == nil then
sky.ambient = Lighting.Ambient
sky.outdoor = Lighting.OutdoorAmbient
sky.bright = Lighting.Brightness
end
if F.Bright then
Lighting.Ambient = Color3.fromRGB(180, 180, 180)
Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
Lighting.Brightness = 3
else
Lighting.Ambient = sky.ambient
Lighting.OutdoorAmbient = sky.outdoor
Lighting.Brightness = sky.bright
end
end
Bin.restore.world = function()
F.Clear = false
F.Bright = false
pcall(applyWorld)
end
local lib = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local guicfg = {
WindowName = "Kali Hub | Entrenched WW1",
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 100, MaxHeight = 600, InitialHeight = 430,
MinWidth = 300, MaxWidth = 800, InitialWidth = 520,
}
local win = lib:CreateWindow(guicfg, gethui())
local tabCombat = win:CreateTab("Combat")
local tabVisuals = win:CreateTab("Visuals")
local tabPlayer = win:CreateTab("Player")
local tabConfig = win:CreateTab("Settings")
local refreshSilent
do
local sec = tabCombat:CreateSection("Silent Aim")
local refresh
local look = sec:CreateToggle("Sync Look Angle", false, function(v) F.SilentLook = v end)
local part = sec:CreateDropdown("Hit Part", { "Head", "UpperTorso", "HumanoidRootPart", "Closest", "Random" }, function(v)
F.SilentPart = v
if refresh then refresh() end
end, "Head", false)
local miss = sec:CreateToggle("Miss Chance", false, function(v)
F.SilentMiss = v
if refresh then refresh() end
end)
local missPct = sec:CreateSlider("Miss Percent", 0, 100, 10, true, function(v) F.SilentMissPct = v end)
local wHead = sec:CreateSlider("Head Weight", 0, 100, 20, true, function(v) F.WHead = v end)
local wTorso = sec:CreateSlider("Torso Weight", 0, 100, 60, true, function(v) F.WTorso = v end)
local wLimb = sec:CreateSlider("Limb Weight", 0, 100, 20, true, function(v) F.WLimb = v end)
refresh = function()
local on = F.Silent or F.Rage
look:SetVisible(on)
part:SetVisible(on); miss:SetVisible(on)
missPct:SetVisible(on and F.SilentMiss)
local rand = on and F.SilentPart == "Random"
wHead:SetVisible(rand); wTorso:SetVisible(rand); wLimb:SetVisible(rand)
end
sec:CreateToggle("Silent Aim", false, function(v) F.Silent = v; refresh() end)
refresh()
refreshSilent = refresh
end
do
local sec = tabCombat:CreateSection("Ragebot")
local auto = sec:CreateToggle("Auto Fire", false, function(v) F.RageAuto = v end)
local full = sec:CreateToggle("Ignore FOV", true, function(v) F.RageFullScreen = v end)
sec:CreateToggle("Ragebot", false, function(v)
F.Rage = v
auto:SetVisible(v); full:SetVisible(v)
local r = refreshSilent
if r then r() end
end)
auto:SetVisible(false); full:SetVisible(false)
end
do
local sec = tabCombat:CreateSection("Aimbot")
local smooth = sec:CreateSlider("Smoothing", 1, 20, 5, true, function(v) F.AimSmooth = v end)
local part = sec:CreateDropdown("Hit Part", { "Head", "UpperTorso", "HumanoidRootPart", "Closest" }, function(v)
F.AimPart = v
end, "Head", false)
local wall = sec:CreateToggle("Visible Only", false, function(v) F.AimWall = v end)
local key = sec:CreateDropdown("Aim Key", { "Mouse 2", "Mouse 1", "E", "Q", "C" }, function(v)
if v == "Mouse 2" then F.AimKey = Enum.UserInputType.MouseButton2
elseif v == "Mouse 1" then F.AimKey = Enum.UserInputType.MouseButton1
else F.AimKey = Enum.KeyCode[v] end
end, "Mouse 2", false)
local function refresh()
local on = F.Aimbot
smooth:SetVisible(on); part:SetVisible(on); wall:SetVisible(on); key:SetVisible(on)
end
sec:CreateToggle("Aimbot", false, function(v) F.Aimbot = v; refresh() end)
refresh()
sec:CreateDivider()
local delay = sec:CreateSlider("Fire Delay", 0, 30, 2, true, function(v) F.TriggerDelay = v / 100 end)
sec:CreateToggle("Triggerbot", false, function(v) F.Trigger = v; delay:SetVisible(v) end)
delay:SetVisible(false)
end
do
local sec = tabCombat:CreateSection("Targeting", "right")
sec:CreateToggle("Team Check", true, function(v) F.AimTeam = v end)
sec:CreateSlider("FOV Size", 10, 500, 150, true, function(v) F.FovSize = v end)
local color = sec:CreateColorpicker("FOV Color", function(c) F.FovColor = c end)
sec:CreateToggle("Show FOV", false, function(v) F.FovShow = v; color:SetVisible(v) end)
color:SetVisible(false)
local snapColor = sec:CreateColorpicker("Snapline Color", function(c) F.SnapColor = c end)
sec:CreateToggle("Snapline", false, function(v) F.Snap = v; snapColor:SetVisible(v) end)
snapColor:SetVisible(false)
sec:CreateToggle("Hit Marker", false, function(v) F.HitMark = v end)
end
do
local sec = tabCombat:CreateSection("Gun Mods", "right")
sec:CreateToggle("No Recoil", false, function(v) F.NoRecoil = v end)
sec:CreateToggle("No Spread", false, function(v) F.NoSpread = v end)
local boltMult = sec:CreateSlider("Bolt Speed", 1, 8, 3, true, function(v) F.BoltMult = v end)
sec:CreateToggle("Fast Bolt", false, function(v) F.FastBolt = v; boltMult:SetVisible(v) end)
boltMult:SetVisible(false)
local rate = sec:CreateSlider("Rounds Per Minute", 200, 1400, 600, true, function(v) F.FireRate = v end)
sec:CreateToggle("Rapid Fire", false, function(v) F.RapidFire = v; rate:SetVisible(v) end)
rate:SetVisible(false)
sec:CreateDivider()
local range = sec:CreateSlider("Melee Range", 3, 8, 5, true, function(v) F.MeleeRange = v end)
sec:CreateToggle("Auto Melee", false, function(v) F.Melee = v; range:SetVisible(v) end)
range:SetVisible(false)
end
do
local sec = tabVisuals:CreateSection("Player ESP")
local box = sec:CreateToggle("Box", false, function(v) F.EspBox = v end)
local tracer = sec:CreateToggle("Tracers", false, function(v) F.EspTracer = v end)
local name = sec:CreateToggle("Names", false, function(v) F.EspName = v end)
local dist = sec:CreateToggle("Distance", false, function(v) F.EspDist = v end)
local health = sec:CreateToggle("Health Bar", false, function(v) F.EspHealth = v end)
local team = sec:CreateToggle("Team Check", true, function(v) F.EspTeam = v end)
local maxd = sec:CreateSlider("Max Distance", 100, 3000, 1000, true, function(v) F.EspMax = v end)
local color = sec:CreateColorpicker("ESP Color", function(c) F.EspColor = c end)
local teamColor = sec:CreateToggle("Use Team Colors", false, function(v) F.EspTeamColor = v end)
local visColor = sec:CreateToggle("Color By Visibility", false, function(v) F.EspVisColor = v end)
local function refresh()
local on = F.Esp
box:SetVisible(on); tracer:SetVisible(on); name:SetVisible(on)
dist:SetVisible(on); health:SetVisible(on); team:SetVisible(on)
maxd:SetVisible(on); color:SetVisible(on)
teamColor:SetVisible(on); visColor:SetVisible(on)
end
sec:CreateToggle("Enable ESP", false, function(v) F.Esp = v; refresh() end)
refresh()
end
do
local sec = tabVisuals:CreateSection("World", "right")
sec:CreateToggle("Clear Weather", false, function(v) F.Clear = v; pcall(applyWorld) end)
sec:CreateToggle("Full Bright", false, function(v) F.Bright = v; pcall(applyWorld) end)
end
do
local sec = tabPlayer:CreateSection("Movement")
local flySpeed = sec:CreateSlider("Fly Speed", 10, 90, 35, true, function(v) F.FlySpeed = v end)
sec:CreateToggle("Fly", false, function(v) F.Fly = v; flySpeed:SetVisible(v) end)
flySpeed:SetVisible(false)
local spd = sec:CreateSlider("Speed", 14, 34, 24, true, function(v) F.SpeedValue = v end)
sec:CreateToggle("Speed Boost", false, function(v) F.Speed = v; spd:SetVisible(v) end)
spd:SetVisible(false)
sec:CreateLabel("Fly: hold Space to rise, Ctrl to drop")
end
do
local sec = tabPlayer:CreateSection("Automation", "right")
sec:CreateToggle("Auto Deploy", false, function(v) F.AutoDeploy = v end)
sec:CreateToggle("Auto Claim Missions", false, function(v) F.AutoClaim = v end)
sec:CreateToggle("Auto Revive Allies", false, function(v) F.AutoRevive = v end)
end
do
local sec = tabConfig:CreateSection("Interface")
local fonts = {}
for _, v in ipairs(Enum.Font:GetEnumItems()) do table.insert(fonts, v.Name) end
sec:CreateDropdown("Font", fonts, function(v) win:SetFont(v) end, "Gotham", false)
sec:CreateLabel("Toggle menu: Right Alt")
sec:CreateButton("Unload", function()
if getgenv().KaliEntrenched then getgenv().KaliEntrenched() end
end)
end
local cm = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
cm:SetLibrary(lib); cm:SetWindow(win); cm:SetFolder("Kali Hub")
cm:BuildConfigSection(tabConfig); cm:LoadAutoloadConfig()
win:SetBackground("rbxassetid://133937513221602")
win:SetTileOffset(100)
win:SetTileScale(0.5)
getgenv().KaliEntrenched = function()
if Bin.dead then return end
Bin.dead = true
F.Silent = false; F.Rage = false; F.RageAuto = false; F.Aimbot = false; F.Trigger = false; F.Melee = false
F.Esp = false; F.Fly = false; F.Speed = false
F.AutoDeploy = false; F.AutoClaim = false; F.AutoRevive = false
for _, c in ipairs(Bin.conns) do pcall(function() c:Disconnect() end) end
for _, d in ipairs(Bin.draws) do pcall(function() d:Remove() end) end
pcall(restoreMods)
for _, fn in pairs(Bin.restore) do pcall(fn) end
pcall(function() win:Destroy() end)
getgenv().KaliEntrenched = nil
end
