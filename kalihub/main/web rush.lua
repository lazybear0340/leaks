--this shit was unobfuscated


if getgenv().KaliWebRush then pcall(getgenv().KaliWebRush) end
local Players = game:GetService("Players")
local RunS = game:GetService("RunService")
local Storage = game:GetService("ReplicatedStorage")
local Collection = game:GetService("CollectionService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local NetFolder = Storage:WaitForChild("Packages"):WaitForChild("Net")
local R_AttackStart = NetFolder:WaitForChild("RE/AttackStart")
local R_Attack = NetFolder:WaitForChild("RE/Attack")
local R_Hurt = NetFolder:WaitForChild("RE/Hurt")
local R_Die = NetFolder:WaitForChild("RE/Die")
local R_Dodge = NetFolder:WaitForChild("RE/Dodge")
local R_NPCMelee = NetFolder:WaitForChild("RE/NPCAttackMelee")
local RemoteFolder = Storage:WaitForChild("Remotes")
local R_Settings = RemoteFolder:WaitForChild("SettingsChange")
local Missions = RemoteFolder:WaitForChild("Missions")
local Bin = { conns = {}, dead = false }
local function track(c) table.insert(Bin.conns, c) return c end
local function newDraw(class)
local d = Drawing.new(class)
d.Visible = false
return d
end
local F = {
KillAura = false, AuraRange = 60, AuraDelay = 0.28, AuraCrimeOnly = false,
AutoDodge = false, DodgeDelay = 0.12,
TargetRange = false, TargetRadius = 120,
AutoMissions = false, MissionRate = 5.2,
AutoCrime = false, CrimeHold = 14,
Skills = false,
SwingBoost = false, SpeedCap = 357,
EnemyEsp = false, EnemyBox = true, EnemyName = true, EnemyDist = true, EnemyTracer = false,
EnemyColor = Color3.fromRGB(255, 80, 80), EnemyMax = 400,
CrimeEsp = false, CrimeColor = Color3.fromRGB(255, 200, 60),
PlayerEsp = false, PlayerBox = true, PlayerName = true, PlayerDist = true,
PlayerColor = Color3.fromRGB(120, 190, 255), PlayerMax = 900,
Skin = nil, SkinHidden = true, SkinKeep = true,
AntiRagdoll = false,
SpeedBoost = false, WalkSpeed = 60,
Noclip = false, Fly = false, FlySpeed = 120, InfJump = false,
}
local SKILL_KEYS = { "PointLaunch", "Slingshot", "Loop", "Tether", "WebWings", "WebDash" }
local R15_PARTS = {
"Head", "UpperTorso", "LowerTorso", "LeftHand", "RightHand",
"LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm",
"LeftFoot", "RightFoot", "LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg",
}
local function char() return LP.Character end
local function root()
local c = LP.Character
return c and c.PrimaryPart
end
local function alive()
local c = LP.Character
local h = c and c:FindFirstChildOfClass("Humanoid")
return c and c.PrimaryPart and h and h.Health > 0
end
local Aura = { fired = {}, misses = 0, busy = false }
local function serverRig(target)
local ref = target:FindFirstChild("ServerReference")
local rig = ref and ref.Value
if rig and rig.Parent and rig.PrimaryPart then return rig end
end
local function collectTargets(radius, crimeOnly)
local rp = root()
if not rp then return {} end
local origin, list = rp.Position, {}
for _, t in ipairs(Collection:GetTagged("Target")) do
local pp = t.PrimaryPart
local hum = t:FindFirstChildOfClass("Humanoid")
if pp and hum and hum.Health > 0 then
local rig = serverRig(t)
if rig and (not crimeOnly or rig:FindFirstAncestor("Crimes")) then
local d = (pp.Position - origin).Magnitude
if d <= radius then
table.insert(list, { rig = rig, dist = d })
end
end
end
end
table.sort(list, function(a, b) return a.dist < b.dist end)
return list
end
local function noteResponse(rig)
if Aura.fired[rig] then
Aura.misses = 0
Aura.fired[rig] = nil
end
end
track(R_Hurt.OnClientEvent:Connect(noteResponse))
track(R_Die.OnClientEvent:Connect(noteResponse))
track(R_Attack.OnClientEvent:Connect(function() Aura.misses = 0 end))
local function strikeRig(rig)
R_AttackStart:FireServer(rig)
task.wait(F.AuraDelay)
if Bin.dead or not rig.Parent then return end
R_Attack:FireServer(rig)
Aura.fired[rig] = true
Aura.misses += 1
end
local window
local function runAura(crimeOnly, radius)
if Aura.busy or not alive() then return end
Aura.busy = true
local list = collectTargets(radius, crimeOnly)
for _, entry in ipairs(list) do
if Bin.dead or not (F.KillAura or F.AutoCrime) then break end
strikeRig(entry.rig)
if Aura.misses >= 10 then
F.KillAura = false
F.AutoCrime = false
Aura.misses = 0
table.clear(Aura.fired)
if window then window:Notify("Web Rush", "Server stopped answering attacks, aura paused", 4) end
break
end
end
Aura.busy = false
end
task.spawn(function()
while not Bin.dead do
if F.KillAura then
runAura(F.AuraCrimeOnly, F.AuraRange)
end
task.wait(0.1)
end
end)
track(R_NPCMelee.OnClientEvent:Connect(function(rig, victim)
if not F.AutoDodge or Bin.dead then return end
if victim ~= LP.Character or not alive() then return end
task.delay(F.DodgeDelay, function()
if not F.AutoDodge or Bin.dead or not alive() then return end
local c = LP.Character
c:SetAttribute("Dodge", true)
R_Dodge:FireServer()
task.delay(0.45, function()
if LP.Character == c then c:SetAttribute("Dodge", false) end
end)
end)
end))
local Combat = require(Storage.Services.CombatService)
local originalSearch = Combat._SearchForTarget
local function wideSearch(self, character)
if not F.TargetRange then return originalSearch(self, character) end
local pp = character and character.PrimaryPart
if not pp then return end
local origin = pp.Position
local look = pp.CFrame.LookVector
local params = OverlapParams.new()
params.FilterDescendantsInstances = { character }
params.FilterType = Enum.RaycastFilterType.Exclude
local best, bestScore = nil, -1
for _, part in ipairs(workspace:GetPartBoundsInRadius(origin, F.TargetRadius, params)) do
local model = part.Parent
local hum = model and model:FindFirstChild("Humanoid")
if hum and model:HasTag("Target") and hum:GetState() ~= Enum.HumanoidStateType.Dead and model.PrimaryPart then
local pos = model.PrimaryPart.Position
local near = math.clamp(1 - (origin - pos).Magnitude / (F.TargetRadius * 1.111), 0, 1)
local facing = math.clamp((look:Dot((pos - origin).Unit) + 1) / 2, 0, 1)
local score = near + facing
if score > bestScore then best, bestScore = model, score end
end
end
self.target = best
if not self.outline then return end
if not best then
self.outline.Enabled = false
return
end
self.outline.Adornee = best
self.outline.Enabled = true
end
Combat._SearchForTarget = wideSearch
task.spawn(function()
local order = { "PointLaunch", "AirTricks", "WallRun", "SwingLow", "Dive", "SwingFast" }
while not Bin.dead do
if F.AutoMissions and alive() then
for _, name in ipairs(order) do
local remote = Missions:FindFirstChild(name)
if remote then pcall(function() remote:FireServer() end) end
end
end
local waited = 0
while waited < F.MissionRate and not Bin.dead do
task.wait(0.25)
waited += 0.25
end
end
end)
local function crimeAnchor(crime)
local sum, alive_, total = Vector3.zero, 0, 0
for _, ch in ipairs(crime:GetChildren()) do
if ch.Name == "Rig" then
total += 1
local pp = ch.PrimaryPart
local hum = ch:FindFirstChildOfClass("Humanoid")
if pp and hum and hum.Health > 0 then
sum += pp.Position
alive_ += 1
end
end
end
if alive_ == 0 then return nil, total end
return sum / alive_, alive_
end
local function nearestCrime()
local rp = root()
if not rp then return end
local best, bestDist, bestPos
for _, crime in ipairs(Collection:GetTagged("Crime")) do
local pos = crimeAnchor(crime)
if pos then
local d = (pos - rp.Position).Magnitude
if not bestDist or d < bestDist then best, bestDist, bestPos = crime, d, pos end
end
end
return best, bestDist, bestPos
end
task.spawn(function()
while not Bin.dead do
if F.AutoCrime and alive() then
local crime, dist, pos = nearestCrime()
if crime and dist and pos then
if dist > F.CrimeHold then
local rp = root()
if rp then
rp.CFrame = CFrame.new(pos + Vector3.new(0, 8, 0))
task.wait(1.2)
end
else
runAura(true, math.max(F.AuraRange, 40))
end
end
end
task.wait(0.35)
end
end)
local skillOwned = {}
do
local cfg = LP:FindFirstChild("Config")
for _, key in ipairs(SKILL_KEYS) do
skillOwned[key] = cfg and cfg:GetAttribute(key) == true
end
end
local function applySkills(on)
for _, key in ipairs(SKILL_KEYS) do
if not skillOwned[key] then
R_Settings:FireServer(key, on and true or false)
end
end
end
local function clearSkin()
local c = LP.Character
if not c then return end
local folder = c:FindFirstChild("KaliSkin")
if folder then folder:Destroy() end
local stash = c:FindFirstChild("KaliSkinStash")
if stash then
for _, item in ipairs(stash:GetChildren()) do item.Parent = c end
stash:Destroy()
end
for _, name in ipairs(R15_PARTS) do
local part = c:FindFirstChild(name)
if part then part.Transparency = 0 end
end
end
local function applySkin(suitName)
local c = LP.Character
local source = suitName and Storage.Suits:FindFirstChild(suitName)
if not (c and source and c.PrimaryPart) then return false end
clearSkin()
local model = source:Clone()
local base = {}
for _, name in ipairs(R15_PARTS) do
local part = model:FindFirstChild(name)
if part then base[name] = part end
end
if not next(base) then
model:Destroy()
return false
end
local folder = Instance.new("Folder")
folder.Name = "KaliSkin"
folder.Parent = c
local placed = 0
for _, piece in ipairs(model:GetDescendants()) do
if piece:IsA("MeshPart") and piece.Transparency < 1 and piece.Name ~= "Primary" and not base[piece.Name] then
local bestName, bestDist
for name, basePart in pairs(base) do
local d = (basePart.Position - piece.Position).Magnitude
if not bestDist or d < bestDist then bestName, bestDist = name, d end
end
local charPart = bestName and c:FindFirstChild(bestName)
if charPart then
local offset = base[bestName].CFrame:ToObjectSpace(piece.CFrame)
local clone = piece:Clone()
clone.Anchored = false
clone.CanCollide = false
clone.CanQuery = false
clone.CanTouch = false
clone.Massless = true
clone.Parent = folder
clone.CFrame = charPart.CFrame * offset
local weld = Instance.new("WeldConstraint")
weld.Part0 = charPart
weld.Part1 = clone
weld.Parent = clone
placed += 1
end
end
end
model:Destroy()
if placed == 0 then
folder:Destroy()
return false
end
for _, name in ipairs(R15_PARTS) do
local part = c:FindFirstChild(name)
if part then part.Transparency = 1 end
end
local stash = Instance.new("Folder")
stash.Name = "KaliSkinStash"
stash.Parent = c
for _, item in ipairs(c:GetChildren()) do
if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("Accessory") then item.Parent = stash end
end
return true
end
track(LP.CharacterAdded:Connect(function()
if F.SkinKeep and F.Skin then
task.delay(2.5, function()
if F.SkinKeep and F.Skin then pcall(applySkin, F.Skin) end
end)
end
end))
local GlobalsModule = require(Storage.Classes.Globals)
local TravFolder = Storage.Classes:WaitForChild("Traversal")
local PresetSaves = TravFolder:WaitForChild("PresetSaves")
local ActivePreset = TravFolder:WaitForChild("ActivePreset")
local stockPreset = ActivePreset.Value
local tunedPreset
local function ensureTuned()
if tunedPreset and tunedPreset.Parent then return tunedPreset end
local fullest = stockPreset or PresetSaves:FindFirstChild("Insomniac Recreation")
for _, preset in ipairs(PresetSaves:GetChildren()) do
local n = 0
for _ in pairs(preset:GetAttributes()) do n += 1 end
local best = 0
for _ in pairs(fullest:GetAttributes()) do best += 1 end
if n > best then fullest = preset end
end
tunedPreset = fullest:Clone()
tunedPreset.Name = "KaliTuned"
tunedPreset.Parent = PresetSaves
return tunedPreset
end
local function loadPreset(name)
local source = PresetSaves:FindFirstChild(name)
if not source then return false end
local tuned = ensureTuned()
for key, value in pairs(source:GetAttributes()) do
tuned:SetAttribute(key, value)
end
ActivePreset.Value = tuned
return true
end
local function tune(key, value)
local tuned = ensureTuned()
local current = tuned:GetAttribute(key)
if typeof(current) == "NumberRange" then
tuned:SetAttribute(key, NumberRange.new(current.Min, value))
else
tuned:SetAttribute(key, value)
end
ActivePreset.Value = tuned
if key == "GravityBase" then
local trav = GlobalsModule.traversal
if trav then trav.GRAVITY = value end
end
end
local function readTune(key, fallback)
local preset = stockPreset
local current = preset and preset:GetAttribute(key)
if typeof(current) == "NumberRange" then return current.Max end
if typeof(current) == "number" then return current end
return fallback
end
local function restorePhysics()
if stockPreset then ActivePreset.Value = stockPreset end
if tunedPreset then
tunedPreset:Destroy()
tunedPreset = nil
end
local trav = GlobalsModule.traversal
if trav then
trav.GRAVITY = trav:getAttribute("GravityBase")
end
end
local StateClass = require(Storage.Classes.State)
local stockSendTrigger = StateClass.sendTrigger
StateClass.sendTrigger = function(self, trigger, ...)
if not Bin.dead and F.AntiRagdoll and trigger == "Ragdoll" then return end
return stockSendTrigger(self, trigger, ...)
end
task.spawn(function()
while not Bin.dead do
if F.AntiRagdoll and GlobalsModule.disableAttack then
GlobalsModule.disableAttack = false
end
task.wait(1)
end
end)
track(RunS.Heartbeat:Connect(function()
if Bin.dead or not F.SwingBoost then return end
local trav = GlobalsModule.traversal
if not trav then return end
trav.aero = 1
local swing = trav._states and trav._states.Swing
if swing then swing.maxSpeed = F.SpeedCap end
end))
local Move = { mover = nil, collide = {} }
local function setTraversal(on)
pcall(function() TravFolder:SetAttribute("Disabled", not on) end)
end
local function stopFly()
if Move.mover then
pcall(function() Move.mover:Destroy() end)
Move.mover = nil
end
setTraversal(true)
end
local function startFly()
local rp = root()
if not rp then return end
stopFly()
setTraversal(false)
local mover = Instance.new("BodyVelocity")
mover.Name = "KaliFly"
mover.MaxForce = Vector3.one * 1e6
mover.Velocity = Vector3.zero
mover.Parent = rp
Move.mover = mover
end
local function restoreCollide()
for part, was in pairs(Move.collide) do
if part.Parent then part.CanCollide = was end
end
table.clear(Move.collide)
end
local function restoreSpeed()
local trav = GlobalsModule.traversal
if trav then trav.walkSpeed = 16 end
end
track(RunS.Heartbeat:Connect(function()
if Bin.dead then return end
local c = LP.Character
if not c then return end
if F.SpeedBoost then
local trav = GlobalsModule.traversal
if trav then
if trav.walkSpeed ~= F.WalkSpeed then trav.walkSpeed = F.WalkSpeed end
local state = trav._state and trav._state.TYPE
if state == "Ground" or state == "Land" then
local hum = c:FindFirstChildOfClass("Humanoid")
if hum and hum.WalkSpeed > 0 and hum.WalkSpeed < F.WalkSpeed then
hum.WalkSpeed = F.WalkSpeed
end
end
end
end
if F.Noclip then
for _, p in ipairs(c:GetDescendants()) do
if p:IsA("BasePart") and p.CanCollide then
if Move.collide[p] == nil then Move.collide[p] = true end
p.CanCollide = false
end
end
elseif next(Move.collide) then
restoreCollide()
end
if F.Fly and Move.mover and Move.mover.Parent then
local dir = Vector3.zero
if not UIS:GetFocusedTextBox() then
if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Cam.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Cam.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Cam.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Cam.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.yAxis end
end
Move.mover.Velocity = dir.Magnitude > 0 and dir.Unit * F.FlySpeed or Vector3.zero
end
end))
track(UIS.JumpRequest:Connect(function()
if Bin.dead or not F.InfJump then return end
local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end))
track(LP.CharacterAdded:Connect(function()
table.clear(Move.collide)
if F.Fly then
task.delay(1.5, function()
if F.Fly and not Bin.dead then startFly() end
end)
end
end))
local Esp = { enemy = {}, crime = {}, player = {} }
local function makeSet(store, key)
local set = store[key]
if set then return set end
set = {
box = newDraw("Square"),
name = newDraw("Text"),
dist = newDraw("Text"),
line = newDraw("Line"),
shown = false,
}
set.box.Thickness = 1
set.box.Filled = false
for _, t in ipairs({ set.name, set.dist }) do
t.Size = 13
t.Center = true
t.Outline = true
t.Font = 2
end
set.line.Thickness = 1
store[key] = set
return set
end
local function hideSet(set)
if not set.shown then return end
set.shown = false
set.box.Visible = false
set.name.Visible = false
set.dist.Visible = false
set.line.Visible = false
end
local function sweep(store, live)
for key, set in pairs(store) do
if not live[key] then
hideSet(set)
store[key] = nil
pcall(function()
set.box:Remove() set.name:Remove() set.dist:Remove() set.line:Remove()
end)
end
end
end
local function drawEntity(set, pos, label, distance, color, wantBox, wantName, wantDist, wantTracer, height)
local mid, onScreen = Cam:WorldToViewportPoint(pos)
if not onScreen then
hideSet(set)
return
end
set.shown = true
local top = Cam:WorldToViewportPoint(pos + Vector3.new(0, height, 0))
local bottom = Cam:WorldToViewportPoint(pos - Vector3.new(0, height, 0))
local h = math.abs(top.Y - bottom.Y)
local w = h * 0.6
set.box.Visible = wantBox
if wantBox then
set.box.Color = color
set.box.Size = Vector2.new(w, h)
set.box.Position = Vector2.new(mid.X - w / 2, mid.Y - h / 2)
end
set.name.Visible = wantName
if wantName then
set.name.Color = color
set.name.Text = label
set.name.Position = Vector2.new(mid.X, mid.Y - h / 2 - 16)
end
set.dist.Visible = wantDist
if wantDist then
set.dist.Color = color
set.dist.Text = string.format("%dm", math.floor(distance * 0.28))
set.dist.Position = Vector2.new(mid.X, mid.Y + h / 2 + 2)
end
set.line.Visible = wantTracer
if wantTracer then
set.line.Color = color
set.line.From = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y)
set.line.To = Vector2.new(mid.X, mid.Y + h / 2)
end
end
track(RunS.RenderStepped:Connect(function()
if Bin.dead then return end
local rp = root()
if F.EnemyEsp and rp then
local live = {}
for _, t in ipairs(Collection:GetTagged("Target")) do
local pp = t.PrimaryPart
local hum = t:FindFirstChildOfClass("Humanoid")
if pp and hum and hum.Health > 0 then
local d = (pp.Position - rp.Position).Magnitude
if d <= F.EnemyMax then
live[t] = true
local set = makeSet(Esp.enemy, t)
if not set.label then
local rig = serverRig(t)
set.label = (rig and rig:GetAttribute("Type")) or "Enemy"
end
drawEntity(set, pp.Position, set.label, d, F.EnemyColor,
F.EnemyBox, F.EnemyName, F.EnemyDist, F.EnemyTracer, 3)
end
end
end
sweep(Esp.enemy, live)
elseif next(Esp.enemy) then
sweep(Esp.enemy, {})
end
if F.CrimeEsp and rp then
local live = {}
for _, crime in ipairs(Collection:GetTagged("Crime")) do
local pos, rigs = crimeAnchor(crime)
if pos then
live[crime] = true
local d = (pos - rp.Position).Magnitude
drawEntity(makeSet(Esp.crime, crime), pos + Vector3.new(0, 8, 0),
string.format("Crime [%d]", rigs), d, F.CrimeColor, false, true, true, false, 10)
end
end
sweep(Esp.crime, live)
elseif next(Esp.crime) then
sweep(Esp.crime, {})
end
if F.PlayerEsp and rp then
local live = {}
for _, plr in ipairs(Players:GetPlayers()) do
local c = plr ~= LP and plr.Character
local pp = c and c.PrimaryPart
local hum = c and c:FindFirstChildOfClass("Humanoid")
if pp and hum and hum.Health > 0 then
local d = (pp.Position - rp.Position).Magnitude
if d <= F.PlayerMax then
live[plr] = true
drawEntity(makeSet(Esp.player, plr), pp.Position, plr.Name, d, F.PlayerColor,
F.PlayerBox, F.PlayerName, F.PlayerDist, false, 3)
end
end
end
sweep(Esp.player, live)
elseif next(Esp.player) then
sweep(Esp.player, {})
end
end))
getfenv().gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 150, MaxHeight = 600, InitialHeight = 500,
MinWidth = 350, MaxWidth = 800, InitialWidth = 580,
}
local guiParent = gethui()
local guiBefore = {}
for _, g in ipairs(guiParent:GetChildren()) do guiBefore[g] = true end
if getnilinstances then
local STUBS = { Toggle = "Frame", Title = "TextLabel", Keybind = "TextLabel" }
for _, orphan in ipairs(getnilinstances()) do
pcall(function()
if orphan:IsA("TextButton") and orphan.Name:sub(-2) == " T" then
for name, class in pairs(STUBS) do
if not orphan:FindFirstChild(name) then
local stub = Instance.new(class)
stub.Name = name
stub.Parent = orphan
end
end
end
end)
end
end
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
window = library:CreateWindow(getfenv().gui_config, guiParent)
library:SetWindowName("Kali Hub | Web Rush")
local tabMain = window:CreateTab("Main")
local tabVisuals = window:CreateTab("Visuals")
local tabConfig = window:CreateTab("Config")
local uiReady = false
local deps = {}
local function addDep(key, widget)
deps[key] = deps[key] or {}
table.insert(deps[key], widget)
widget:SetVisible(false)
end
local function showDeps(key, state)
for _, w in ipairs(deps[key] or {}) do w:SetVisible(state) end
end
do
local sec = tabMain:CreateSection("Combat", "left")
sec:CreateToggle("Kill Aura", false, function(v)
F.KillAura = v
Aura.misses = 0
showDeps("aura", v)
end):CreateKeybind("G", nil, "Toggle")
addDep("aura", sec:CreateSlider("Aura Range", 20, 150, 60, true, function(v) F.AuraRange = v end))
addDep("aura", sec:CreateSlider("Aura Delay", 10, 60, 28, true, function(v) F.AuraDelay = v / 100 end))
addDep("aura", sec:CreateToggle("Crime Enemies Only", false, function(v) F.AuraCrimeOnly = v end))
sec:CreateToggle("Auto Dodge", false, function(v)
F.AutoDodge = v
showDeps("dodge", v)
end):CreateKeybind("H", nil, "Toggle")
addDep("dodge", sec:CreateSlider("Dodge Delay", 0, 25, 12, true, function(v) F.DodgeDelay = v / 100 end))
sec:CreateToggle("Attack Range", false, function(v)
F.TargetRange = v
showDeps("range", v)
end)
addDep("range", sec:CreateSlider("Target Radius", 64, 250, 120, true, function(v) F.TargetRadius = v end))
end
do
local sec = tabMain:CreateSection("Farm", "right")
sec:CreateToggle("Auto Missions", false, function(v)
F.AutoMissions = v
showDeps("miss", v)
end):CreateKeybind("M", nil, "Toggle")
addDep("miss", sec:CreateSlider("Mission Rate", 50, 120, 52, true, function(v) F.MissionRate = v / 10 end))
sec:CreateToggle("Auto Crime", false, function(v)
F.AutoCrime = v
Aura.misses = 0
showDeps("crime", v)
end, "dangerous"):CreateKeybind("N", nil, "Toggle")
addDep("crime", sec:CreateSlider("Crime Hold Distance", 8, 60, 14, true, function(v) F.CrimeHold = v end))
end
do
local sec = tabMain:CreateSection("Player", "right")
sec:CreateToggle("Unlock Skills", false, function(v)
F.Skills = v
applySkills(v)
end)
sec:CreateToggle("Anti Ragdoll", false, function(v) F.AntiRagdoll = v end):CreateKeybind("R", nil, "Toggle")
sec:CreateToggle("Speed Boost", false, function(v)
F.SpeedBoost = v
showDeps("speed", v)
if not v then restoreSpeed() end
end)
addDep("speed", sec:CreateSlider("Walk Speed", 16, 250, 60, true, function(v) F.WalkSpeed = v end))
sec:CreateToggle("Noclip", false, function(v)
F.Noclip = v
if not v then restoreCollide() end
end):CreateKeybind("V", nil, "Toggle")
sec:CreateToggle("Fly", false, function(v)
F.Fly = v
showDeps("fly", v)
if v then startFly() else stopFly() end
end):CreateKeybind("F", nil, "Toggle")
addDep("fly", sec:CreateSlider("Fly Speed", 20, 400, 120, true, function(v) F.FlySpeed = v end))
sec:CreateToggle("Infinite Jump", false, function(v) F.InfJump = v end)
end
do
local sec = tabMain:CreateSection("Skin Changer", "left")
local names = {}
local function rebuild()
table.clear(names)
for _, suit in ipairs(Storage.Suits:GetChildren()) do
if suit.Name ~= "Default" and (F.SkinHidden or not suit:GetAttribute("Hidden")) then
table.insert(names, suit.Name)
end
end
table.sort(names)
if #names == 0 then table.insert(names, "-") end
return names
end
rebuild()
local list = sec:CreateDropdown("Suit", names, function(v)
if v ~= "-" then F.Skin = v end
end, names[1], false)
sec:CreateToggle("Include Hidden Suits", true, function(v)
F.SkinHidden = v
rebuild()
list:ChangeOptions(names, names[1])
end)
sec:CreateButton("Apply Skin", function()
if not F.Skin then return end
if applySkin(F.Skin) then
window:Notify("Web Rush", "Wearing " .. F.Skin, 3)
else
window:Notify("Web Rush", "Could not build " .. tostring(F.Skin), 4)
end
end)
sec:CreateButton("Reset Skin", function()
F.Skin = nil
clearSkin()
end)
sec:CreateToggle("Keep On Respawn", true, function(v) F.SkinKeep = v end)
end
do
local sec = tabMain:CreateSection("Swing Physics", "right")
local presets = {}
for _, preset in ipairs(PresetSaves:GetChildren()) do
if preset.Name ~= "KaliTuned" then table.insert(presets, preset.Name) end
end
table.sort(presets)
sec:CreateDropdown("Physics Preset", presets, function(v)
if uiReady and v and v ~= "-" then loadPreset(v) end
end, stockPreset and stockPreset.Name or presets[1], false)
sec:CreateSlider("Gravity", 40, 260, math.floor(readTune("GravityBase", 114)), true, function(v)
if uiReady then tune("GravityBase", v) end
end)
sec:CreateSlider("Swing Gravity", 40, 260, math.floor(readTune("SwingGravity", 114)), true, function(v)
if uiReady then tune("SwingGravity", v) end
end)
sec:CreateSlider("Dive Start Speed", 50, 400, math.floor(readTune("DiveStartSpeed", 114)), true, function(v)
if uiReady then tune("DiveStartSpeed", v) end
end)
sec:CreateSlider("Dive End Speed", 50, 500, math.floor(readTune("DiveEndSpeed", 214)), true, function(v)
if uiReady then tune("DiveEndSpeed", v) end
end)
sec:CreateSlider("Web Length", 80, 500, math.floor(readTune("LengthRange", 214)), true, function(v)
if uiReady then tune("LengthRange", v) end
end)
sec:CreateSlider("Turn Speed", 20, 400, math.floor(readTune("BaseTurnSpeed", 120)), true, function(v)
if uiReady then tune("BaseTurnSpeed", v) end
end)
sec:CreateSlider("Fast Fall Start", 100, 600, math.floor(readTune("FastFallStart", 285)), true, function(v)
if uiReady then tune("FastFallStart", v) end
end)
sec:CreateSlider("Fast Gravity", 40, 400, math.floor(readTune("GravityFast", 140)), true, function(v)
if uiReady then tune("GravityFast", v) end
end)
sec:CreateSlider("Swing Jump Force", 20, 300, math.floor(readTune("SwingJumpForce", 60)), true, function(v)
if uiReady then tune("SwingJumpForce", v) end
end)
sec:CreateSlider("Ledge Jump Force", 40, 400, math.floor(readTune("LedgeJumpForce", 120)), true, function(v)
if uiReady then tune("LedgeJumpForce", v) end
end)
sec:CreateSlider("Zip Forward Force", 10, 200, math.floor(readTune("ZipForwardForce", 30)), true, function(v)
if uiReady then tune("ZipForwardForce", v) end
end)
sec:CreateSlider("Zip Up Force", 10, 200, math.floor(readTune("ZipUpForce", 30)), true, function(v)
if uiReady then tune("ZipUpForce", v) end
end)
sec:CreateToggle("Swing Boost", false, function(v)
F.SwingBoost = v
showDeps("boost", v)
end)
addDep("boost", sec:CreateSlider("Speed Cap", 160, 357, 357, true, function(v) F.SpeedCap = v end))
sec:CreateButton("Reset Physics", function()
restorePhysics()
window:Notify("Web Rush", "Swing physics back to stock", 3)
end)
end
do
local sec = tabVisuals:CreateSection("Enemies", "left")
sec:CreateToggle("Enemy ESP", false, function(v)
F.EnemyEsp = v
showDeps("eesp", v)
end):CreateKeybind("B", nil, "Toggle")
addDep("eesp", sec:CreateToggle("Box", true, function(v) F.EnemyBox = v end))
addDep("eesp", sec:CreateToggle("Name", true, function(v) F.EnemyName = v end))
addDep("eesp", sec:CreateToggle("Distance", true, function(v) F.EnemyDist = v end))
addDep("eesp", sec:CreateToggle("Tracer", false, function(v) F.EnemyTracer = v end))
addDep("eesp", sec:CreateSlider("Max Distance", 100, 1200, 400, true, function(v) F.EnemyMax = v end))
addDep("eesp", sec:CreateColorpicker("Enemy Color", function(c) F.EnemyColor = c end, false, false))
end
do
local sec = tabVisuals:CreateSection("Crimes", "left")
sec:CreateToggle("Crime ESP", false, function(v)
F.CrimeEsp = v
showDeps("cesp", v)
end)
addDep("cesp", sec:CreateColorpicker("Crime Color", function(c) F.CrimeColor = c end, false, false))
end
do
local sec = tabVisuals:CreateSection("Players", "right")
sec:CreateToggle("Player ESP", false, function(v)
F.PlayerEsp = v
showDeps("pesp", v)
end)
addDep("pesp", sec:CreateToggle("Box", true, function(v) F.PlayerBox = v end))
addDep("pesp", sec:CreateToggle("Name", true, function(v) F.PlayerName = v end))
addDep("pesp", sec:CreateToggle("Distance", true, function(v) F.PlayerDist = v end))
addDep("pesp", sec:CreateSlider("Max Distance", 200, 2000, 900, true, function(v) F.PlayerMax = v end))
addDep("pesp", sec:CreateColorpicker("Player Color", function(c) F.PlayerColor = c end, false, false))
end
do
local sec = tabConfig:CreateSection("Script", "right")
sec:CreateButton("Unload", function()
if getgenv().KaliWebRush then getgenv().KaliWebRush() end
end, true)
end
local cm = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
cm:SetLibrary(library); cm:SetWindow(window); cm:SetFolder("Kali Hub")
cm:BuildConfigSection(tabConfig)
uiReady = true
cm:LoadAutoloadConfig()
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
window:SetTileScale(0.5)
getgenv().KaliWebRush = function()
if Bin.dead then return end
Bin.dead = true
F.KillAura = false; F.AutoDodge = false; F.TargetRange = false
F.AutoMissions = false; F.AutoCrime = false; F.SwingBoost = false
F.EnemyEsp = false; F.CrimeEsp = false; F.PlayerEsp = false
F.AntiRagdoll = false; F.SkinKeep = false
F.SpeedBoost = false; F.Noclip = false; F.Fly = false; F.InfJump = false
pcall(stopFly)
pcall(restoreCollide)
pcall(restoreSpeed)
if F.Skills then pcall(applySkills, false) end
pcall(clearSkin)
pcall(restorePhysics)
pcall(function() StateClass.sendTrigger = stockSendTrigger end)
pcall(function() GlobalsModule.disableAttack = false end)
pcall(function() Combat._SearchForTarget = originalSearch end)
for _, c in ipairs(Bin.conns) do pcall(function() c:Disconnect() end) end
pcall(function() sweep(Esp.enemy, {}); sweep(Esp.crime, {}); sweep(Esp.player, {}) end)
pcall(function() window:Destroy() end)
pcall(function()
for _, c in ipairs(library.Connections or {}) do
if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
end
table.clear(library.Connections or {})
end)
pcall(function()
for _, g in ipairs(guiParent:GetChildren()) do
if not guiBefore[g] and g:IsA("ScreenGui") then g:Destroy() end
end
end)
getgenv().KaliWebRush = nil
end
