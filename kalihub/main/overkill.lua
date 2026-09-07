--this shit was unobfuscated


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = g ame:GetService("ReplicatedFirst")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
if getgenv then
for _, name in ipairs({ "_OverkillCleanup", "_SkeletonESPCleanup" }) do
if getgenv()[name] then pcall(getgenv()[name]) end
end
getgenv()._SkeletonESPCleanup = nil
end
gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 150,
MaxHeight = 620,
InitialHeight = 500,
MinWidth = 350,
MaxWidth = 800,
InitialWidth = 580,
}
local library
if not pcall(function()
library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
end) or not library then
return
end
local guiParent = LocalPlayer:WaitForChild("PlayerGui")
local window
local created, createErr = pcall(function()
window = library:CreateWindow(getfenv().gui_config or gui_config, guiParent)
library:SetWindowName("Kali Hub | Overkill")
end)
if not created or not window then
warn("[Kali Hub] window failed: " .. tostring(createErr))
return
end
local Config = {
ESP = {
Enabled = true,
Box = true,
BoxFill = false,
Skeleton = true,
HeadDot = false,
HealthBar = true,
HealthText = false,
Name = true,
Distance = true,
Tracer = false,
Allies = false,
Dummies = false,
MaxDistance = 1000,
Thickness = 1.5,
Rate = 60,
},
Colors = {
Enemy = Color3.fromRGB(255, 65, 65),
Ally = Color3.fromRGB(80, 170, 255),
Skeleton = Color3.fromRGB(0, 255, 255),
Text = Color3.fromRGB(255, 255, 255),
Tracer = Color3.fromRGB(255, 255, 0),
HeadDot = Color3.fromRGB(255, 0, 0),
FOV = Color3.fromRGB(255, 0, 255),
SilentFOV = Color3.fromRGB(0, 200, 255),
RageFOV = Color3.fromRGB(255, 120, 0),
BulletTracer = Color3.fromRGB(255, 170, 0),
},
Aimbot = {
Enabled = false,
TargetPart = "Head",
FOV = 200,
Smoothness = 8,
WallCheck = true,
DrawFOV = true,
Key = "MouseButton2",
},
Silent = {
Enabled = false,
TargetPart = "Head",
FOV = 250,
HitChance = 100,
WallCheck = true,
FireOnly = false,
DrawFOV = false,
},
Rage = {
Enabled = false,
TargetPart = "Head",
FOV = 600,
WallCheck = false,
HoldKey = false,
Key = "MouseButton2",
DrawFOV = false,
MaxDistance = 550,
},
Triggerbot = {
Enabled = false,
Delay = 0.05,
},
Visuals = {
NoRecoil = false,
NoShake = false,
NoAimPunch = false,
NoKillKick = false,
BulletTracer = false,
FOVOverride = false,
FOV = 80,
},
Movement = {
TimeScale = false,
Scale = 1.5,
},
Skins = {},
}
local Bridge = { errors = {} }
local function need(label, fn)
local ok, res = pcall(fn)
if not ok or res == nil then
Bridge.errors[#Bridge.errors + 1] = label
return nil
end
return res
end
Bridge.neuron = need("neuron", function() return require(ReplicatedFirst.neuron) end)
Bridge.States = need("States", function() return require(ReplicatedStorage.Modules.States) end)
Bridge.Gameplay = need("Gameplay", function() return require(ReplicatedStorage.Modules.Handlers.GameplayHandler) end)
Bridge.CameraH = need("Camera", function() return require(ReplicatedStorage.Modules.Handlers.CameraHandler) end)
Bridge.Items = need("Items", function() return require(ReplicatedStorage.Milk.Directory.Items) end)
Bridge.Command = need("Command", function() return require(ReplicatedFirst.Examples.ClientMods.GenerateCommand) end)
Bridge.EyeOrig = need("EyeOrigin",function() return require(ReplicatedStorage.Modules.Shared.EyeOrigin) end)
Bridge.ClientM = need("Chicky", function() return require(ReplicatedFirst.Packages.Chickynoid.Client.ClientModule) end)
local MAX_PITCH = 1.567305668290908
local BTN_PRIMARY = 1
local function charOf(player)
if not Bridge.neuron then return nil end
local ok, char = pcall(function() return Bridge.neuron:get_character(player) end)
return ok and char or nil
end
local function playerOf(char)
if not Bridge.neuron then return nil end
local ok, plr = pcall(function() return Bridge.neuron:get_player(char) end)
return ok and plr or nil
end
local function stateValue(char, key, default)
if not Bridge.States then return default end
local ok, v = pcall(function() return Bridge.States:GetStateValue(char, key, default) end)
if not ok then return default end
return v
end
local function healthOf(char)
local hp = stateValue(char, "Health", -1)
local maxHp = stateValue(char, "MaxHealth", -1)
if maxHp <= 0 then maxHp = 150 end
return hp, maxHp
end
local function isAlive(char)
if type(stateValue(char, "Dead", false)) == "table" then return false end
local hp = stateValue(char, "Health", -1)
if hp < 0 then return true end
return hp > 0
end
local function rootOf(char)
return char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
end
local PART_ALIASES = {
Head = { "HitboxHead", "Head" },
Torso = { "HitboxTorso", "UpperTorso", "Torso" },
Root = { "HumanoidRootPart" },
}
local function partOf(char, want)
for _, name in ipairs(PART_ALIASES[want] or PART_ALIASES.Head) do
local p = char:FindFirstChild(name)
if p then return p end
end
return rootOf(char)
end
local function localChar()
return charOf(LocalPlayer)
end
local function eyePosition()
if Bridge.EyeOrig and Bridge.ClientM then
local ok, pos = pcall(function()
local sim = Bridge.ClientM.localChickynoid and Bridge.ClientM.localChickynoid.simulation
return sim and Bridge.EyeOrig.getAuthoritative(sim.state) or nil
end)
if ok and typeof(pos) == "Vector3" then return pos end
end
return Camera.CFrame.Position
end
local Targets = { list = {}, byChar = {}, inMatch = false, mode = "none" }
local function duelRoster()
if not Bridge.Gameplay then return nil end
local ok, duel = pcall(function() return (Bridge.Gameplay:GetLocalDuel()) end)
if not ok or type(duel) ~= "table" or type(duel.teams) ~= "table" then return nil end
local roster = { mode = duel.mode or "duel", entries = {} }
for _, team in pairs(duel.teams) do
if type(team) == "table" and type(team.players) == "table" then
local hostile = team.enemy == true
for _, plr in ipairs(team.players) do
if plr ~= LocalPlayer then
roster.entries[#roster.entries + 1] = { player = plr, enemy = hostile }
end
end
end
end
return roster
end
local function refreshTargets()
local list, byChar = {}, {}
local roster = duelRoster()
if roster then
Targets.inMatch = true
Targets.mode = roster.mode
for _, entry in ipairs(roster.entries) do
local char = charOf(entry.player)
if char and rootOf(char) then
local t = { player = entry.player, char = char, enemy = entry.enemy, dummy = false }
list[#list + 1] = t
byChar[char] = t
end
end
else
Targets.inMatch = false
Targets.mode = "free"
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer then
local char = charOf(plr)
local root = char and rootOf(char)
if root and root.Position.Magnitude < 1e6 then
local t = { player = plr, char = char, enemy = true, dummy = false }
list[#list + 1] = t
byChar[char] = t
end
end
end
end
if Config.ESP.Dummies then
local entities = Workspace:FindFirstChild("World")
entities = entities and entities:FindFirstChild("Entities")
if entities then
for _, model in ipairs(entities:GetChildren()) do
if model:IsA("Model") and rootOf(model) and not byChar[model] then
local t = { player = nil, char = model, enemy = true, dummy = true }
list[#list + 1] = t
byChar[model] = t
end
end
end
end
Targets.list, Targets.byChar = list, byChar
end
local function displayName(target)
if target.player then return target.player.DisplayName or target.player.Name end
return target.dummy and "Bot" or "Player"
end
local function newDrawing(class, props)
local ok, d = pcall(Drawing.new, class)
if not ok or not d then return nil end
d.Visible = false
if class ~= "Text" then d.Color = Color3.new(1, 1, 1) end
if props then
pcall(function()
for k, v in pairs(props) do d[k] = v end
end)
end
return d
end
local BONES = {
{ "UpperTorso", "Head" }, { "UpperTorso", "LowerTorso" },
{ "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
{ "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
{ "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
{ "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
}
local SINGLE_KEYS = { "box", "boxFill", "healthBg", "healthBar", "name", "distance", "healthText", "headDot", "tracer" }
local espPool = {}
local function newSlot()
local slot = {
box = newDrawing("Square", { Thickness = 1.5, Filled = false }),
boxFill = newDrawing("Square", { Filled = true, Transparency = 0.25 }),
healthBg = newDrawing("Square", { Filled = true, Color = Color3.new(0, 0, 0), Transparency = 0.6 }),
healthBar = newDrawing("Square", { Filled = true, Transparency = 1 }),
name = newDrawing("Text", { Size = 13, Center = true, Outline = true }),
distance = newDrawing("Text", { Size = 12, Center = true, Outline = true }),
healthText = newDrawing("Text", { Size = 12, Center = true, Outline = true }),
headDot = newDrawing("Circle", { Filled = true, Radius = 3, NumSides = 12, Transparency = 1 }),
tracer = newDrawing("Line", { Thickness = 1 }),
skeleton = {},
}
for i, pair in ipairs(BONES) do
slot.skeleton[i] = { a = pair[1], b = pair[2], line = newDrawing("Line", { Thickness = 1.5 }) }
end
return slot
end
local function hideSlot(slot)
for _, key in ipairs(SINGLE_KEYS) do
if slot[key] then slot[key].Visible = false end
end
for _, bone in ipairs(slot.skeleton) do
if bone.line then bone.line.Visible = false end
end
end
local function destroySlot(slot)
for _, key in ipairs(SINGLE_KEYS) do
if slot[key] then pcall(function() slot[key]:Remove() end) end
end
for _, bone in ipairs(slot.skeleton) do
if bone.line then pcall(function() bone.line:Remove() end) end
end
end
local function slotFor(index)
if not espPool[index] then espPool[index] = newSlot() end
return espPool[index]
end
local function hideUnusedSlots(from)
for i = from, #espPool do hideSlot(espPool[i]) end
end
local function toScreen(pos)
local v, on = Camera:WorldToViewportPoint(pos)
return Vector2.new(v.X, v.Y), on, v.Z
end
local function aimPoint()
if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
or not UserInputService.MouseIconEnabled then
return Camera.ViewportSize / 2
end
return Vector2.new(Mouse.X, Mouse.Y)
end
local visParams = RaycastParams.new()
visParams.FilterType = Enum.RaycastFilterType.Exclude
local function isVisible(part, char)
local me = localChar()
visParams.FilterDescendantsInstances = { me, char }
local origin = Camera.CFrame.Position
local result = Workspace:Raycast(origin, part.Position - origin, visParams)
return result == nil or result.Instance:IsDescendantOf(char)
end
local KEY_MAP = {
MouseButton1 = Enum.UserInputType.MouseButton1,
MouseButton2 = Enum.UserInputType.MouseButton2,
MouseButton3 = Enum.UserInputType.MouseButton3,
}
local KEYCODES = { E = Enum.KeyCode.E, Q = Enum.KeyCode.Q, C = Enum.KeyCode.C, V = Enum.KeyCode.V, X = Enum.KeyCode.X }
local function isKeyDown(name)
local mouse = KEY_MAP[name]
if mouse then
local down = false
pcall(function() down = UserInputService:IsMouseButtonPressed(mouse) end)
return down
end
local key = KEYCODES[name]
if not key then return false end
local down = false
pcall(function() down = UserInputService:IsKeyDown(key) end)
return down
end
local function computeBox(char, root)
local head = char:FindFirstChild("Head")
local topWorld = (head and head.Position or root.Position) + Vector3.new(0, head and 0.7 or 2.2, 0)
local botWorld = root.Position - Vector3.new(0, 3, 0)
local topS, _, topD = toScreen(topWorld)
local botS, _, botD = toScreen(botWorld)
if topD <= 0 or botD <= 0 then return nil end
local height = math.max(math.abs(botS.Y - topS.Y), 8)
local width = height * 0.55
local cx = (topS.X + botS.X) / 2
return cx - width / 2, math.min(topS.Y, botS.Y), width, height
end
local function drawTarget(slot, target)
local char = target.char
local root = rootOf(char)
if not root then hideSlot(slot); return end
if not target.dummy and not isAlive(char) then hideSlot(slot); return end
if not target.enemy and not Config.ESP.Allies then hideSlot(slot); return end
local dist = (Camera.CFrame.Position - root.Position).Magnitude
if dist > Config.ESP.MaxDistance then hideSlot(slot); return end
local rootS, _, rootD = toScreen(root.Position)
if rootD <= 0 then hideSlot(slot); return end
local color = target.enemy and Config.Colors.Enemy or Config.Colors.Ally
local x, y, w, h = computeBox(char, root)
local hasBox = x ~= nil
if Config.ESP.Box and hasBox then
slot.box.Position = Vector2.new(x, y)
slot.box.Size = Vector2.new(w, h)
slot.box.Color = color
slot.box.Thickness = Config.ESP.Thickness
slot.box.Visible = true
if Config.ESP.BoxFill then
slot.boxFill.Position = Vector2.new(x, y)
slot.boxFill.Size = Vector2.new(w, h)
slot.boxFill.Color = color
slot.boxFill.Visible = true
else
slot.boxFill.Visible = false
end
else
slot.box.Visible = false
slot.boxFill.Visible = false
end
local hp, maxHp = healthOf(char)
local hasHealth = hp >= 0
local frac = hasHealth and math.clamp(hp / maxHp, 0, 1) or 1
if Config.ESP.HealthBar and hasBox and hasHealth then
slot.healthBg.Position = Vector2.new(x - 6, y)
slot.healthBg.Size = Vector2.new(3, h)
slot.healthBg.Visible = true
slot.healthBar.Position = Vector2.new(x - 6, y + h * (1 - frac))
slot.healthBar.Size = Vector2.new(3, h * frac)
slot.healthBar.Color = Color3.fromRGB(255, 55, 55):Lerp(Color3.fromRGB(55, 255, 55), frac)
slot.healthBar.Visible = true
else
slot.healthBg.Visible = false
slot.healthBar.Visible = false
end
if Config.ESP.HealthText and hasBox and hasHealth then
slot.healthText.Text = string.format("%d", math.floor(hp + 0.5))
slot.healthText.Position = Vector2.new(x - 16, y)
slot.healthText.Color = Config.Colors.Text
slot.healthText.Visible = true
else
slot.healthText.Visible = false
end
if Config.ESP.Name then
slot.name.Text = displayName(target)
slot.name.Position = hasBox and Vector2.new(x + w / 2, y - 16) or Vector2.new(rootS.X, rootS.Y - 28)
slot.name.Color = Config.Colors.Text
slot.name.Visible = true
else
slot.name.Visible = false
end
if Config.ESP.Distance then
slot.distance.Text = string.format("%dm", math.floor(dist))
slot.distance.Position = hasBox and Vector2.new(x + w / 2, y + h + 2) or Vector2.new(rootS.X, rootS.Y + 18)
slot.distance.Color = Config.Colors.Text
slot.distance.Visible = true
else
slot.distance.Visible = false
end
local head = char:FindFirstChild("Head")
if Config.ESP.HeadDot and head then
local hS, _, hD = toScreen(head.Position)
if hD > 0 then
slot.headDot.Position = hS
slot.headDot.Color = Config.Colors.HeadDot
slot.headDot.Visible = true
else
slot.headDot.Visible = false
end
else
slot.headDot.Visible = false
end
if Config.ESP.Tracer then
local vp = Camera.ViewportSize
slot.tracer.From = Vector2.new(vp.X / 2, vp.Y)
slot.tracer.To = hasBox and Vector2.new(x + w / 2, y + h) or rootS
slot.tracer.Color = Config.Colors.Tracer
slot.tracer.Visible = true
else
slot.tracer.Visible = false
end
if Config.ESP.Skeleton then
for _, bone in ipairs(slot.skeleton) do
local pa, pb = char:FindFirstChild(bone.a), char:FindFirstChild(bone.b)
if pa and pb then
local va, _, da = toScreen(pa.Position)
local vb, _, db = toScreen(pb.Position)
if da > 0 and db > 0 then
bone.line.From = va
bone.line.To = vb
bone.line.Color = Config.Colors.Skeleton
bone.line.Thickness = Config.ESP.Thickness
bone.line.Visible = true
else
bone.line.Visible = false
end
else
bone.line.Visible = false
end
end
else
for _, bone in ipairs(slot.skeleton) do bone.line.Visible = false end
end
end
local function renderESP()
if not Config.ESP.Enabled then
hideUnusedSlots(1)
return
end
local used = 0
for _, target in ipairs(Targets.list) do
if target.char.Parent then
used = used + 1
drawTarget(slotFor(used), target)
end
end
hideUnusedSlots(used + 1)
end
local function pickTarget(fov, wantPart, wallCheck, maxDist)
local origin = aimPoint()
local best, bestDist, bestChar = nil, fov, nil
for _, target in ipairs(Targets.list) do
local char = target.char
if target.enemy and char.Parent and (target.dummy or isAlive(char)) then
local part = partOf(char, wantPart)
if part then
local screen, _, depth = toScreen(part.Position)
if depth > 0 and (not maxDist or depth <= maxDist) then
local d = (screen - origin).Magnitude
if d < bestDist and (not wallCheck or isVisible(part, char)) then
bestDist, best, bestChar = d, part, char
end
end
end
end
end
return best, bestChar
end
local Rage = getgenv and getgenv()._OverkillRage or {}
if getgenv then getgenv()._OverkillRage = Rage end
Rage.aim = Rage.aim or nil
Rage.fire = false
Rage.chance = 100
Rage.timeScale = 1
Rage.tick = 0
Rage.wasFiring = false
Rage.rollPassed = true
if Bridge.Command then
local realGenerate = Rage._original or Bridge.Command.GenerateCommand
if type(realGenerate) == "function" then
Rage._original = realGenerate
Bridge.Command.GenerateCommand = function(self, cmd, serverTime, dt)
local out = realGenerate(self, cmd, serverTime, dt)
if type(out) ~= "table" then return out end
if Rage.fire then
Rage.tick = (Rage.tick + 1) % 4
if Rage.tick ~= 0 then
out.buttons = bit32.bor(out.buttons or 0, BTN_PRIMARY)
else
out.buttons = bit32.band(out.buttons or 0, bit32.bnot(BTN_PRIMARY))
end
end
local firing = bit32.band(out.buttons or 0, BTN_PRIMARY) ~= 0
if firing and not Rage.wasFiring then
Rage.rollPassed = math.random(1, 100) <= (Rage.chance or 100)
end
Rage.wasFiring = firing
Rage.dbgTicks = (Rage.dbgTicks or 0) + 1
if firing then Rage.dbgFiring = (Rage.dbgFiring or 0) + 1 end
local aim = Rage.aim
if aim and Rage.rollPassed and (firing or not Rage.fireOnly) then
Rage.dbgApplied = (Rage.dbgApplied or 0) + 1
local eye = Rage.eye or Camera.CFrame.Position
local ok, pitch, yaw = pcall(function()
local p, y = CFrame.new(eye, aim):ToEulerAnglesYXZ()
return p, y
end)
if ok and pitch then
out.pitch = math.clamp(pitch, -MAX_PITCH, MAX_PITCH)
out.yaw = yaw
end
end
if Rage.timeScale and Rage.timeScale > 1 and out.deltaTime then
out.deltaTime = math.min(out.deltaTime * Rage.timeScale, 0.065)
end
return out
end
Rage._installed = true
end
end
if Bridge.CameraH then
local realAngles = Rage._origAngles or (Bridge.Command and Bridge.Command.GetCameraAngles)
if type(realAngles) == "function" then
Rage._origAngles = realAngles
Bridge.Command.GetCameraAngles = function(...)
if not Bridge.CameraH.firstPerson then return realAngles(...) end
local r = Rage.savedRot or Bridge.CameraH.currentRotation
return r.X, r.Y
end
end
pcall(function() RunService:UnbindFromRenderStep("OverkillAimApply") end)
RunService:BindToRenderStep("OverkillAimApply", 0 / 0, function()
Rage.savedRot = nil
local aim = Rage.aim
if not aim or not Bridge.CameraH.firstPerson then return end
if Rage.fireOnly and not Rage.wasFiring then return end
Rage.savedRot = Bridge.CameraH.currentRotation
local dir = (aim - Camera.CFrame.Position).Unit
Bridge.CameraH.currentRotation = Vector3.new(math.asin(dir.Y), math.atan2(-dir.X, -dir.Z), 0)
end)
pcall(function() RunService:UnbindFromRenderStep("OverkillAimRestore") end)
RunService:BindToRenderStep("OverkillAimRestore", 101, function()
if Rage.savedRot and Bridge.CameraH.firstPerson then
Bridge.CameraH.currentRotation = Rage.savedRot
Rage.savedRot = nil
end
end)
end
pcall(function()
local effects = require(ReplicatedStorage.Modules.Handlers.Effects)
local realIdentify = Rage._origIdentify or effects.Identify
if type(realIdentify) ~= "function" then return end
Rage._origIdentify = realIdentify
effects.Identify = function(self, effect, ...)
local aim = Rage.aim
if aim and effect == "Shot" then
local shooter = (select(1, ...))
local info = (select(4, ...))
if shooter == LocalPlayer and type(info) == "table" and info.origin and info.hitPos then
local origin = info.origin
info.hitPos = origin + (aim - Camera.CFrame.Position).Unit * (info.hitPos - origin).Magnitude
end
end
return realIdentify(self, effect, ...)
end
end)
local function updateShotRedirect()
Rage.aim = nil
Rage.fire = false
Rage.chance = 100
Rage.fireOnly = Config.Silent.FireOnly
Rage.timeScale = Config.Movement.TimeScale and Config.Movement.Scale or 1
if Config.Rage.Enabled and not (Config.Rage.HoldKey and not isKeyDown(Config.Rage.Key)) then
local part = pickTarget(Config.Rage.FOV, Config.Rage.TargetPart, Config.Rage.WallCheck, Config.Rage.MaxDistance)
if part then
Rage.eye = eyePosition()
Rage.aim = part.Position
Rage.fire = true
end
return
end
if Config.Silent.Enabled then
local part = pickTarget(Config.Silent.FOV, Config.Silent.TargetPart, Config.Silent.WallCheck, nil)
if part then
Rage.eye = eyePosition()
Rage.aim = part.Position
Rage.chance = Config.Silent.HitChance
end
end
end
local function updateAimbot()
if not Config.Aimbot.Enabled or not isKeyDown(Config.Aimbot.Key) then return end
local part = pickTarget(Config.Aimbot.FOV, Config.Aimbot.TargetPart, Config.Aimbot.WallCheck, nil)
if not part then return end
local screen, _, depth = toScreen(part.Position)
if depth <= 0 then return end
local origin = aimPoint()
local smooth = math.max(Config.Aimbot.Smoothness, 1)
pcall(mousemoverel, (screen.X - origin.X) / smooth, (screen.Y - origin.Y) / smooth)
end
local triggerParams = RaycastParams.new()
triggerParams.FilterType = Enum.RaycastFilterType.Exclude
local lastTrigger = 0
local function fireOnce()
if mouse1press and mouse1release then
pcall(mouse1press)
task.delay(0.03, function() pcall(mouse1release) end)
elseif mouse1click then
pcall(mouse1click)
else
local cur = aimPoint()
pcall(function() VirtualInputManager:SendMouseButtonEvent(cur.X, cur.Y, 0, true, game, 1) end)
task.delay(0.03, function()
pcall(function() VirtualInputManager:SendMouseButtonEvent(cur.X, cur.Y, 0, false, game, 1) end)
end)
end
end
local function updateTriggerbot()
if not Config.Triggerbot.Enabled then return end
if (os.clock() - lastTrigger) < Config.Triggerbot.Delay then return end
local origin = aimPoint()
local ray = Camera:ViewportPointToRay(origin.X, origin.Y)
triggerParams.FilterDescendantsInstances = { localChar() }
local result = Workspace:Raycast(ray.Origin, ray.Direction * Config.ESP.MaxDistance, triggerParams)
if not result then return end
local model = result.Instance:FindFirstAncestorWhichIsA("Model")
local target
while model do
target = Targets.byChar[model]
if target then break end
model = model:FindFirstAncestorWhichIsA("Model")
end
if not target or not target.enemy then return end
if not target.dummy and not isAlive(target.char) then return end
lastTrigger = os.clock()
if Rage._installed then
Rage.fire = true
else
fireOnce()
end
end
local TRACER_SLOTS = 40
local bulletTracers = {}
local bulletIdx = 0
for i = 1, TRACER_SLOTS do
bulletTracers[i] = { line = newDrawing("Line", { Thickness = 1 }), origin = nil, hitPos = nil, expire = 0 }
end
local function addBulletTracer(origin, hitPos)
bulletIdx = (bulletIdx % TRACER_SLOTS) + 1
local slot = bulletTracers[bulletIdx]
if not slot.line then return end
slot.origin, slot.hitPos, slot.expire = origin, hitPos, os.clock() + 0.35
end
local function updateBulletTracers()
local now = os.clock()
for _, slot in ipairs(bulletTracers) do
local line = slot.line
if line then
if slot.origin and now < slot.expire then
local a, _, da = toScreen(slot.origin)
local b, _, db = toScreen(slot.hitPos)
if da > 0 and db > 0 then
line.From, line.To = a, b
line.Color = Config.Colors.BulletTracer
line.Visible = true
else
line.Visible = false
end
else
line.Visible = false
end
end
end
end
local Visuals = { recoilBackup = {}, baseFOV = nil }
function Visuals.setNoRecoil(state)
if not Bridge.Items then return end
for _, item in pairs(Bridge.Items.all) do
local rc = type(item) == "table" and item.stats and item.stats.recoil
if rc then
if Visuals.recoilBackup[rc] == nil then
Visuals.recoilBackup[rc] = { base = rc.base }
end
pcall(function() rc.base = state and 0 or Visuals.recoilBackup[rc].base end)
end
end
end
function Visuals.applyFOV()
local ch = Bridge.CameraH
if not ch then return end
if Visuals.baseFOV == nil then Visuals.baseFOV = ch.baseFOV end
local want = Config.Visuals.FOVOverride and Config.Visuals.FOV or Visuals.baseFOV
if ch.baseFOV ~= want then
pcall(function() ch:setBaseFOV(want) end)
end
end
pcall(function()
local CameraShake = require(ReplicatedStorage.Modules.CameraShake)
local realShake = CameraShake.ShakeOnce
CameraShake.ShakeOnce = function(self, magnitude, ...)
if Config.Visuals.NoShake then magnitude = 0 end
return realShake(self, magnitude, ...)
end
end)
pcall(function()
local ch = Bridge.CameraH
if not ch then return end
local realPunch = ch.HitFOVPunch
if realPunch then
ch.HitFOVPunch = function(self, ...)
if Config.Visuals.NoAimPunch then return end
return realPunch(self, ...)
end
end
local realKick = ch.KillCameraKick
if realKick then
ch.KillCameraKick = function(self, ...)
if Config.Visuals.NoKillKick then return end
return realKick(self, ...)
end
end
local realSlide = ch.SlideJumpKick
if realSlide then
ch.SlideJumpKick = function(self, ...)
if Config.Visuals.NoKillKick then return end
return realSlide(self, ...)
end
end
end)
pcall(function()
local GunEffects = require(ReplicatedStorage.Modules.Handlers.Effects.gun.Gun)
local realShot = GunEffects.Shot
GunEffects.Shot = function(self, ...)
if Config.Visuals.BulletTracer then
local shooter, data
local args = table.pack(...)
for i = 1, args.n do
local a = args[i]
if typeof(a) == "Instance" and a:IsA("Player") then
shooter = a
elseif type(a) == "table" and a.origin and a.hitPos then
data = a
end
end
if shooter == LocalPlayer and data then
addBulletTracer(data.origin, data.hitPos)
end
end
return realShot(self, ...)
end
end)
local Skins = {}
pcall(function()
local Builder = require(ReplicatedStorage.Modules.WeaponECS.Render.Builder)
local Registry = require(ReplicatedStorage.Modules.WeaponECS.Render.Registry)
local ViewModel = require(ReplicatedStorage.Modules.WeaponECS.Render.ViewModel)
local Items = Bridge.Items
local realBuild = Builder.build
Builder.build = function(...)
local args = table.pack(...)
local weaponID, realSkin = args[3], args[4]
local want = weaponID and Config.Skins[weaponID]
local item = weaponID and Items and Items.all[weaponID]
if want and want ~= realSkin and item and type(item.skins) == "table" and item.skins[want] then
args[4] = want
local ctrl = realBuild(table.unpack(args, 1, args.n))
if type(ctrl) == "table" then ctrl.skin = realSkin end
return ctrl
end
return realBuild(table.unpack(args, 1, args.n))
end
function Skins.apply(weaponID)
pcall(function()
local char = localChar()
local vmcs = char and ViewModel.getControllers(char)
local vmc = vmcs and vmcs[weaponID]
if vmc and not vmc.destroying then ViewModel.destroy(vmc) end
end)
local drop = {}
pcall(function()
for owner, slots in pairs(Registry.instances) do
for slot, ctrl in pairs(slots) do
if type(ctrl) == "table" and ctrl.weaponID == weaponID and ctrl.isLocal then
drop[#drop + 1] = { owner, slot }
end
end
end
end)
for _, ref in ipairs(drop) do
pcall(function() Registry.despawn(ref[1], ref[2]) end)
end
end
end)
local fovCircle = newDrawing("Circle", { Thickness = 1.5, NumSides = 64, Filled = false, Transparency = 1 })
local silentCircle = newDrawing("Circle", { Thickness = 1.5, NumSides = 64, Filled = false, Transparency = 1 })
local rageCircle = newDrawing("Circle", { Thickness = 1.5, NumSides = 64, Filled = false, Transparency = 1 })
local connections = {}
local lastScan, lastDraw = 0, 0
refreshTargets()
connections[#connections + 1] = RunService.RenderStepped:Connect(function()
Camera = Workspace.CurrentCamera or Camera
local now = os.clock()
if now - lastScan >= 0.25 then
lastScan = now
pcall(refreshTargets)
end
local interval = 1 / math.max(Config.ESP.Rate, 1)
if now - lastDraw >= interval then
lastDraw = now
pcall(renderESP)
end
local origin = aimPoint()
if Config.Aimbot.Enabled and Config.Aimbot.DrawFOV and fovCircle then
fovCircle.Radius = Config.Aimbot.FOV
fovCircle.Position = origin
fovCircle.Color = Config.Colors.FOV
fovCircle.Visible = true
elseif fovCircle then
fovCircle.Visible = false
end
if Config.Silent.Enabled and not Config.Rage.Enabled and Config.Silent.DrawFOV and silentCircle then
silentCircle.Radius = Config.Silent.FOV
silentCircle.Position = origin
silentCircle.Color = Rage.aim and Color3.fromRGB(0, 255, 0) or Config.Colors.SilentFOV
silentCircle.Visible = true
elseif silentCircle then
silentCircle.Visible = false
end
if Config.Rage.Enabled and Config.Rage.DrawFOV and rageCircle then
rageCircle.Radius = Config.Rage.FOV
rageCircle.Position = origin
rageCircle.Color = Rage.aim and Color3.fromRGB(0, 255, 0) or Config.Colors.RageFOV
rageCircle.Visible = true
elseif rageCircle then
rageCircle.Visible = false
end
pcall(updateShotRedirect)
pcall(updateAimbot)
pcall(updateTriggerbot)
pcall(updateBulletTracers)
pcall(Visuals.applyFOV)
end)
local function cleanup()
for _, conn in ipairs(connections) do
pcall(function() conn:Disconnect() end)
end
for _, slot in ipairs(espPool) do destroySlot(slot) end
for _, slot in ipairs(bulletTracers) do
if slot.line then pcall(function() slot.line:Remove() end) end
end
if fovCircle then pcall(function() fovCircle:Remove() end) end
if silentCircle then pcall(function() silentCircle:Remove() end) end
if rageCircle then pcall(function() rageCircle:Remove() end) end
Config.Rage.Enabled = false
Config.Silent.Enabled = false
Config.Movement.TimeScale = false
Rage.aim, Rage.fire, Rage.timeScale = nil, false, 1
if Bridge.Command and Rage._original then
pcall(function() Bridge.Command.GenerateCommand = Rage._original end)
Rage._installed = false
end
if Bridge.Command and Rage._origAngles then
pcall(function() Bridge.Command.GetCameraAngles = Rage._origAngles end)
end
pcall(function() RunService:UnbindFromRenderStep("OverkillAimApply") end)
pcall(function() RunService:UnbindFromRenderStep("OverkillAimRestore") end)
Rage.savedRot = nil
Visuals.setNoRecoil(false)
if Bridge.CameraH and Visuals.baseFOV then
pcall(function() Bridge.CameraH:setBaseFOV(Visuals.baseFOV) end)
end
end
if getgenv then getgenv()._OverkillCleanup = cleanup end
local stored_fonts = {}
for _, font in ipairs(Enum.Font:GetEnumItems()) do
table.insert(stored_fonts, font.Name)
end
local AIM_KEYS = { "MouseButton1", "MouseButton2", "MouseButton3", "E", "Q", "C", "V", "X" }
local PARTS = { "Head", "Torso", "Root" }
local mainTab = window:CreateTab("Main")
local visualTab = window:CreateTab("Visuals")
local skinsTab = window:CreateTab("Skins")
local configTab = window:CreateTab("Config")
local secAim = mainTab:CreateSection("Aimbot", "left")
local secSilent = mainTab:CreateSection("Silent Aim", "left")
local secRage = mainTab:CreateSection("Ragebot", "left")
local secTrigger = mainTab:CreateSection("Triggerbot", "left")
local secMove = mainTab:CreateSection("Movement", "left")
local secEsp = mainTab:CreateSection("ESP", "right")
local secEspX = mainTab:CreateSection("ESP Config", "right")
local secColors = mainTab:CreateSection("Colors", "right")
secAim:CreateToggle("Aimbot", Config.Aimbot.Enabled, function(v) Config.Aimbot.Enabled = v end)
secAim:CreateDropdown("Target Part", PARTS, function(v) Config.Aimbot.TargetPart = v end, Config.Aimbot.TargetPart, false)
secAim:CreateDropdown("Aim Key", AIM_KEYS, function(v) Config.Aimbot.Key = v end, Config.Aimbot.Key, false)
secAim:CreateSlider("FOV Radius", 30, 500, Config.Aimbot.FOV, true, function(v) Config.Aimbot.FOV = v end)
secAim:CreateSlider("Smoothness", 1, 30, Config.Aimbot.Smoothness, true, function(v) Config.Aimbot.Smoothness = v end)
secAim:CreateToggle("Wall Check", Config.Aimbot.WallCheck, function(v) Config.Aimbot.WallCheck = v end)
secAim:CreateToggle("Draw FOV", Config.Aimbot.DrawFOV, function(v) Config.Aimbot.DrawFOV = v end)
local silentToggle = secSilent:CreateToggle("Silent Aim", Config.Silent.Enabled, function(v) Config.Silent.Enabled = v end)
silentToggle:CreateKeybind("G", function()
Config.Silent.Enabled = not Config.Silent.Enabled
window:Notify("Kali Hub", "Silent Aim: " .. (Config.Silent.Enabled and "ON" or "OFF"), 2)
end, "Toggle")
secSilent:CreateDropdown("Target Part", { "Head", "Torso" }, function(v) Config.Silent.TargetPart = v end, Config.Silent.TargetPart, false)
secSilent:CreateSlider("FOV Radius", 30, 1000, Config.Silent.FOV, true, function(v) Config.Silent.FOV = v end)
secSilent:CreateSlider("Hit Chance", 1, 100, Config.Silent.HitChance, true, function(v) Config.Silent.HitChance = v end)
secSilent:CreateToggle("Wall Check", Config.Silent.WallCheck, function(v) Config.Silent.WallCheck = v end)
secSilent:CreateToggle("Redirect On Fire Only", Config.Silent.FireOnly, function(v) Config.Silent.FireOnly = v end)
secSilent:CreateToggle("Draw FOV", Config.Silent.DrawFOV, function(v) Config.Silent.DrawFOV = v end)
secSilent:CreateLabel("Ragebot overrides this while enabled.", true)
local rageToggle = secRage:CreateToggle("Ragebot", Config.Rage.Enabled, function(v) Config.Rage.Enabled = v end)
rageToggle:CreateKeybind("H", function()
Config.Rage.Enabled = not Config.Rage.Enabled
window:Notify("Kali Hub", "Ragebot: " .. (Config.Rage.Enabled and "ON" or "OFF"), 2)
end, "Toggle")
secRage:CreateDropdown("Target Part", { "Head", "Torso" }, function(v) Config.Rage.TargetPart = v end, Config.Rage.TargetPart, false)
secRage:CreateSlider("FOV Radius", 30, 1200, Config.Rage.FOV, true, function(v) Config.Rage.FOV = v end)
secRage:CreateSlider("Max Range", 50, 1000, Config.Rage.MaxDistance, true, function(v) Config.Rage.MaxDistance = v end)
secRage:CreateToggle("Wall Check", Config.Rage.WallCheck, function(v) Config.Rage.WallCheck = v end)
secRage:CreateToggle("Hold Key Only", Config.Rage.HoldKey, function(v) Config.Rage.HoldKey = v end)
secRage:CreateDropdown("Hold Key", AIM_KEYS, function(v) Config.Rage.Key = v end, Config.Rage.Key, false)
secRage:CreateToggle("Draw FOV", Config.Rage.DrawFOV, function(v) Config.Rage.DrawFOV = v end)
secTrigger:CreateToggle("Triggerbot", Config.Triggerbot.Enabled, function(v) Config.Triggerbot.Enabled = v end)
secTrigger:CreateSlider("Fire Delay", 0, 0.5, Config.Triggerbot.Delay, false, function(v) Config.Triggerbot.Delay = v end)
secMove:CreateToggle("Time Scale", Config.Movement.TimeScale, function(v) Config.Movement.TimeScale = v end)
secMove:CreateSlider("Scale", 1, 3, Config.Movement.Scale, false, function(v) Config.Movement.Scale = v end)
secMove:CreateLabel("Experimental. Server may reject it.", true)
secEsp:CreateToggle("ESP", Config.ESP.Enabled, function(v) Config.ESP.Enabled = v end)
secEsp:CreateToggle("Box", Config.ESP.Box, function(v) Config.ESP.Box = v end)
secEsp:CreateToggle("Box Fill", Config.ESP.BoxFill, function(v) Config.ESP.BoxFill = v end)
secEsp:CreateToggle("Skeleton", Config.ESP.Skeleton, function(v) Config.ESP.Skeleton = v end)
secEsp:CreateToggle("Head Dot", Config.ESP.HeadDot, function(v) Config.ESP.HeadDot = v end)
secEsp:CreateToggle("Health Bar", Config.ESP.HealthBar, function(v) Config.ESP.HealthBar = v end)
secEsp:CreateToggle("Health Number", Config.ESP.HealthText, function(v) Config.ESP.HealthText = v end)
secEsp:CreateToggle("Name", Config.ESP.Name, function(v) Config.ESP.Name = v end)
secEsp:CreateToggle("Distance", Config.ESP.Distance, function(v) Config.ESP.Distance = v end)
secEsp:CreateToggle("Tracer", Config.ESP.Tracer, function(v) Config.ESP.Tracer = v end)
secEspX:CreateToggle("Show Teammates", Config.ESP.Allies, function(v) Config.ESP.Allies = v end)
secEspX:CreateToggle("Show Bots", Config.ESP.Dummies, function(v)
Config.ESP.Dummies = v
pcall(refreshTargets)
end)
secEspX:CreateSlider("Max Distance", 100, 5000, Config.ESP.MaxDistance, true, function(v) Config.ESP.MaxDistance = v end)
secEspX:CreateSlider("Line Thickness", 0.5, 5, Config.ESP.Thickness, false, function(v) Config.ESP.Thickness = v end)
secEspX:CreateSlider("Refresh Rate", 15, 144, Config.ESP.Rate, true, function(v) Config.ESP.Rate = v end)
secColors:CreateColorpicker("Enemy", function(c) if c then Config.Colors.Enemy = c end end)
secColors:CreateColorpicker("Ally", function(c) if c then Config.Colors.Ally = c end end)
secColors:CreateColorpicker("Skeleton", function(c) if c then Config.Colors.Skeleton = c end end)
secColors:CreateColorpicker("Text", function(c) if c then Config.Colors.Text = c end end)
secColors:CreateColorpicker("Tracer", function(c) if c then Config.Colors.Tracer = c end end)
secColors:CreateColorpicker("Head Dot", function(c) if c then Config.Colors.HeadDot = c end end)
secColors:CreateColorpicker("Aimbot FOV", function(c) if c then Config.Colors.FOV = c end end)
secColors:CreateColorpicker("Silent FOV", function(c) if c then Config.Colors.SilentFOV = c end end)
secColors:CreateColorpicker("Ragebot FOV", function(c) if c then Config.Colors.RageFOV = c end end)
secColors:CreateColorpicker("Bullet Tracer", function(c) if c then Config.Colors.BulletTracer = c end end)
local secGun = visualTab:CreateSection("Weapon", "left")
local secCamera = visualTab:CreateSection("Camera", "right")
secGun:CreateToggle("No Recoil Animation", Config.Visuals.NoRecoil, function(v)
Config.Visuals.NoRecoil = v
Visuals.setNoRecoil(v)
end)
secGun:CreateToggle("Bullet Tracers", Config.Visuals.BulletTracer, function(v) Config.Visuals.BulletTracer = v end)
secCamera:CreateToggle("No Camera Shake", Config.Visuals.NoShake, function(v) Config.Visuals.NoShake = v end)
secCamera:CreateToggle("No Hit Punch", Config.Visuals.NoAimPunch, function(v) Config.Visuals.NoAimPunch = v end)
secCamera:CreateToggle("No Kill Kick", Config.Visuals.NoKillKick, function(v) Config.Visuals.NoKillKick = v end)
secCamera:CreateToggle("Custom FOV", Config.Visuals.FOVOverride, function(v) Config.Visuals.FOVOverride = v end)
secCamera:CreateSlider("Field of View", 60, 120, Config.Visuals.FOV, true, function(v) Config.Visuals.FOV = v end)
local secSkins = skinsTab:CreateSection("Weapon Skins")
local skinWeaponNames, skinNameToId, skinsByWeapon = {}, {}, {}
pcall(function()
for id, item in pairs(Bridge.Items.all) do
if type(item) == "table" and type(item.skins) == "table" then
local list = {}
for skinName in pairs(item.skins) do list[#list + 1] = skinName end
if #list > 0 then
table.sort(list)
local disp = item.name or id
skinWeaponNames[#skinWeaponNames + 1] = disp
skinNameToId[disp] = id
skinsByWeapon[id] = list
end
end
end
table.sort(skinWeaponNames)
end)
if #skinWeaponNames > 0 then
local currentId = skinNameToId[skinWeaponNames[1]]
local skinDropdown
local suppress = false
local function refreshSkins()
if not (skinDropdown and currentId) then return end
local list = skinsByWeapon[currentId] or {}
suppress = true
skinDropdown:ChangeOptions(list, Config.Skins[currentId] or list[1] or "base")
suppress = false
end
secSkins:CreateDropdown("Weapon", skinWeaponNames, function(v)
currentId = skinNameToId[v] or currentId
refreshSkins()
end, skinWeaponNames[1], false)
skinDropdown = secSkins:CreateDropdown("Skin", skinsByWeapon[currentId] or {}, function(v)
if suppress then return end
if currentId and v then
Config.Skins[currentId] = v
if Skins.apply then Skins.apply(currentId) end
end
end, (skinsByWeapon[currentId] and skinsByWeapon[currentId][1]) or "base", false)
secSkins:CreateButton("Reset Skin", function()
if currentId then
Config.Skins[currentId] = nil
refreshSkins()
if Skins.apply then Skins.apply(currentId) end
end
end)
secSkins:CreateLabel("Local preview only. Applies to your equipped weapon instantly.", true)
else
secSkins:CreateLabel("No weapon skins found.")
end
local configSettings = configTab:CreateSection("Settings")
configSettings:CreateDropdown("Change Font", stored_fonts, function(v) window:SetFont(v) end, "", false)
if #Bridge.errors > 0 then
configSettings:CreateLabel("Unavailable: " .. table.concat(Bridge.errors, ", "), true)
end
pcall(function()
local config_manager = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
config_manager:SetLibrary(library)
config_manager:SetWindow(window)
config_manager:SetFolder("Kali Hub")
config_manager:BuildConfigSection(configTab)
config_manager:LoadAutoloadConfig()
end)
pcall(function()
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
end)
