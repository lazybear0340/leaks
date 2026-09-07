--this shit was unobfuscated


local WHITE = Color3.new(1, 1, 1)
if type(getgenv().KaliUnload) == "function" then
pcall(getgenv().KaliUnload)
end
getgenv().KaliUnload = nil
local gui_config = {
Color = WHITE,
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 100, MaxHeight = 620, InitialHeight = 500,
MinWidth = 320, MaxWidth = 860, InitialWidth = 580,
}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Kali = {
Running = true,
Connections = {},
Drawings = {},
Guis = {},
Restore = {},
}
function Kali.track(connection)
table.insert(Kali.Connections, connection)
return connection
end
local AUTO_SRC = [[
if getgenv().__KaliRivalsBootJob == game.JobId then
	return
end
getgenv().__KaliRivalsBootJob = game.JobId
local src
if isfile and isfile("Rivals.lua") then
	src = readfile("Rivals.lua")
end
if type(src) ~= "string" or src == "" then
	src = game:HttpGet("https://kalihub.xyz/loader.lua")
end
local fn = loadstring(src)
if fn then
	fn()
end
]]
local Settings = {
SilentAim = false,
SilentHitPart = "Head",
SilentHitChance = 100,
SilentFov = 250,
SilentVisibleCheck = true,
Ragebot = false,
RageMode = "Crosshair",
RageHitPart = "Head",
RageFov = 700,
RageMaxDistance = 900,
RageVisibleCheck = true,
RageFireDelay = 0,
Aimbot = false,
AimHoldRight = true,
AimPart = "Head",
AimFov = 150,
AimSmoothing = 0,
AimVisibleCheck = true,
ShowFov = false,
FovColor = Color3.fromRGB(255, 255, 255),
Triggerbot = false,
TriggerRadius = 8,
TriggerDelay = 0.05,
NoRecoil = false,
NoSpread = false,
InstantAim = false,
NoSlowdown = false,
Esp = false,
EspBox = true,
EspName = true,
EspHealth = true,
EspDistance = false,
EspWeapon = false,
EspHeadDot = false,
EspTracer = false,
EspChams = false,
EspTeammates = false,
EspMaxDistance = 1500,
EspTextSize = 13,
EspEnemyColor = Color3.fromRGB(255, 80, 80),
EspAllyColor = Color3.fromRGB(90, 170, 255),
Fullbright = false,
NoFog = false,
CustomFov = false,
FovValue = 80,
}
local Camera = workspace.CurrentCamera
Kali.track(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
Camera = workspace.CurrentCamera
end))
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local function grab(container, name)
local module = container:FindFirstChild(name)
if not module then return nil end
local ok, value = pcall(require, module)
return ok and value or nil
end
local FighterController = grab(PlayerScripts.Controllers, "FighterController")
local CameraController = grab(PlayerScripts.Controllers, "CameraController")
local Utility = grab(ReplicatedStorage.Modules, "Utility")
if not (FighterController and CameraController and Utility) then
return warn("[Kali Hub] Rivals client not loaded")
end
local function localFighter()
return FighterController.LocalFighter
end
local function localTeam()
local fighter = localFighter()
local team = fighter and fighter.Data and fighter.Data.TeamID
return type(team) == "string" and team or ""
end
local function isAlly(fighter)
local mine = localTeam()
if mine == "" then return false end
local theirs = fighter.Data and fighter.Data.TeamID
return theirs == mine
end
local function isAlive(entity)
local humanoid = entity.Humanoid
return humanoid ~= nil and humanoid.Health > 0
end
local function enemies()
local list = {}
local mine = localFighter()
for _, entity in FighterController:GetEntities() do
local fighter = entity.ClientFighter
if fighter and fighter ~= mine and isAlive(entity) and entity.RootPart then
table.insert(list, entity)
end
end
return list
end
local losParams = RaycastParams.new()
losParams.FilterType = Enum.RaycastFilterType.Exclude
losParams.IgnoreWater = true
local function visible(origin, target, entity)
local mine = localFighter()
losParams.FilterDescendantsInstances = {
mine and mine.Entity and mine.Entity.Model,
entity.Model,
Camera,
}
local hit = workspace:Raycast(origin, target - origin, losParams)
return hit == nil
end
local function hitbox(entity, part)
local model = entity.Model
if not model then return nil end
if part == "Body" then
return model:FindFirstChild("HitboxBody") or model:FindFirstChild("HitboxBodySmall")
end
return model:FindFirstChild("HitboxHead") or model:FindFirstChild("HitboxHeadSmall")
end
local function pick(fov, wantPart, visibleCheck, mode, maxDistance)
local viewport = Camera.ViewportSize
local centre = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
local origin = Camera.CFrame.Position
local best, bestPart, bestScore
for _, entity in enemies() do
local fighter = entity.ClientFighter
if not isAlly(fighter) then
local part = hitbox(entity, wantPart)
if part then
local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
if onScreen then
local offset = (Vector2.new(screen.X, screen.Y) - centre).Magnitude
local range = (part.Position - origin).Magnitude
if offset <= fov and (not maxDistance or range <= maxDistance) then
local score = offset
if mode == "Closest" then
score = range
elseif mode == "Lowest Health" then
score = entity.Humanoid.Health
end
if not bestScore or score < bestScore then
if not visibleCheck or visible(origin, part.Position, entity) then
best, bestPart, bestScore = entity, part, score
end
end
end
end
end
end
end
return best, bestPart
end
local function currentTarget()
if Settings.Ragebot then
return pick(Settings.RageFov, Settings.RageHitPart, Settings.RageVisibleCheck,
Settings.RageMode, Settings.RageMaxDistance)
end
if Settings.SilentAim then
return pick(Settings.SilentFov, Settings.SilentHitPart, Settings.SilentVisibleCheck)
end
return nil, nil
end
local function parkGcProbe()
if not (hookfunction and newcclosure and restorefunction and getrenv) then return end
local env = getrenv()
local original
local done = false
original = hookfunction(env.setmetatable, newcclosure(function(target, meta)
if not done and typeof(meta) == "table" and rawget(meta, "__mode") == "kv" then
if debug.traceback():find("MiscellaneousController") then
done = true
return original({ 1, 2, 3 }, {})
end
end
return original(target, meta)
end))
task.spawn(function()
local deadline = os.clock() + 15
while not done and os.clock() < deadline do
task.wait(0.2)
end
pcall(restorefunction, env.setmetatable)
end)
table.insert(Kali.Restore, function()
pcall(restorefunction, env.setmetatable)
end)
end
parkGcProbe()
local aimHooked = false
local function installAimHook()
if aimHooked then return end
local fighter = localFighter()
if not fighter then return end
local class = rawget(getrawmetatable(fighter), "__index")
local original = rawget(class, "GetCameraData")
if type(original) ~= "function" then return end
local settings = Settings
local encode = Utility.EncodeCFrame
local utility = Utility
local controller = FighterController
local choose = currentTarget
local newCFrame = CFrame.new
local newVector = Vector3.new
local random = math.random
local clock = os.clock
local identity = encode(utility, CFrame.new())
local cachedPart, cachedUntil = nil, 0
local function redirect(self, ...)
local data, raycast = original(self, ...)
local active = settings.SilentAim or settings.Ragebot
if select("#", ...) == 0 and active and self == controller.LocalFighter and type(data) == "table" then
local eye = data["\0"]
local muzzle = data["\1"]
local chance = settings.Ragebot and 100 or settings.SilentHitChance
if eye and muzzle and random(1, 100) <= chance then
local now = clock()
if now >= cachedUntil then
cachedUntil = now + 0.05
local _entity, found = choose()
cachedPart = found
end
local part = cachedPart
if part and part.Parent then
local aim = part.Position
data["\0"] = encode(utility, newCFrame(newVector(eye["\0"], eye["\1"], eye["\2"]), aim))
data["\1"] = encode(utility, newCFrame(newVector(muzzle["\0"], muzzle["\1"], muzzle["\2"]), aim))
data["\2"] = part
data["\3"] = identity
end
end
end
return data, raycast
end
setfenv(redirect, getfenv(original))
rawset(class, "GetCameraData", redirect)
aimHooked = true
table.insert(Kali.Restore, function()
if rawget(class, "GetCameraData") == redirect then
rawset(class, "GetCameraData", original)
end
aimHooked = false
end)
end
local function rotationTo(target)
local direction = (target - Camera.CFrame.Position).Unit
return Vector2.new(math.asin(math.clamp(direction.Y, -1, 1)), math.atan2(-direction.X, -direction.Z))
end
local aimHeld = false
local combatLooped = false
local function canFire(item)
if not item then return false end
local info = item.Info
if not info or info.Type ~= "Gun" then return false end
local now = tick()
if now < (item._shoot_cooldown or 0) then return false end
if now < (item._shoot_cooldown_no_ammo or 0) then return false end
if now < (item._reload_cooldown or 0) then return false end
if now < (item._reload_cancel_cooldown or 0) then return false end
local gotState, equipping = pcall(item.IsEquipping, item)
if gotState and equipping then return false end
if info.MaxAmmo then
local gotAmmo, ammo = pcall(item.Get, item, "Ammo")
if gotAmmo and (ammo or 0) <= 0 and now < (item._reload_delay or 0) then
return false
end
end
return true
end
local function startCombatLoop()
if combatLooped then return end
combatLooped = true
local nextTrigger = 0
local nextRageShot = 0
Kali.track(RunService.RenderStepped:Connect(function()
if not Kali.Running then return end
if Settings.Aimbot and (aimHeld or not Settings.AimHoldRight) then
local _, part = pick(Settings.AimFov, Settings.AimPart, Settings.AimVisibleCheck)
if part then
local goal = rotationTo(part.Position)
local current = CameraController.Rotation
local alpha = Settings.AimSmoothing <= 0 and 1 or math.clamp(1 / Settings.AimSmoothing, 0.02, 1)
local deltaYaw = (goal.Y - current.Y + math.pi) % (math.pi * 2) - math.pi
CameraController:SetRotation(Vector2.new(
current.X + (goal.X - current.X) * alpha,
current.Y + deltaYaw * alpha
))
end
end
if Settings.Ragebot and mouse1click and os.clock() >= nextRageShot then
local fighter = localFighter()
local item = fighter and fighter.EquippedItem
if canFire(item) then
local _entity, part = currentTarget()
if part then
nextRageShot = os.clock() + math.max(Settings.RageFireDelay, 0.03)
mouse1click()
end
end
end
if Settings.Triggerbot and not Settings.Ragebot and mouse1click and os.clock() >= nextTrigger then
local _, part = pick(Settings.TriggerRadius, Settings.AimPart, true)
if part then
nextTrigger = os.clock() + Settings.TriggerDelay + 0.05
task.spawn(function()
if Settings.TriggerDelay > 0 then task.wait(Settings.TriggerDelay) end
if Kali.Running and Settings.Triggerbot then mouse1click() end
end)
end
end
end))
end
local baselines = setmetatable({}, { __mode = "k" })
local NONE = newproxy(false)
local MODS = {
NoRecoil = { ShootRecoil = 0 },
NoSpread = { ShootSpread = 0, ShootSpreadPerVelocityUnit = 0 },
InstantAim = { AimSpeed = 10 },
NoSlowdown = { WalkSpeedMultiplier = 1 },
}
local function applyMods()
local fighter = localFighter()
local item = fighter and fighter.EquippedItem
local info = item and item.Info
if type(info) ~= "table" then return end
local saved = baselines[info]
if not saved then
saved = {}
baselines[info] = saved
end
for setting, fields in MODS do
for key, value in fields do
if saved[key] == nil then
local original = info[key]
saved[key] = original == nil and NONE or original
end
if Settings[setting] then
info[key] = value
else
local original = saved[key]
info[key] = original ~= NONE and original or nil
end
end
end
end
local function restoreMods()
for info, saved in baselines do
for key, value in saved do
info[key] = value ~= NONE and value or nil
end
end
table.clear(baselines)
end
table.insert(Kali.Restore, restoreMods)
local modsLooped = false
local function startModsLoop()
if modsLooped then return end
modsLooped = true
local fighter = localFighter()
if fighter and fighter.EquippedItemChanged then
Kali.track(fighter.EquippedItemChanged:Connect(function()
if Kali.Running then applyMods() end
end))
end
applyMods()
end
local function newDrawing(class, props)
local object = Drawing.new(class)
for key, value in props do
object[key] = value
end
object.Visible = false
table.insert(Kali.Drawings, object)
return object
end
local espSlots = {}
local slotsUsed = 0
local function slot(index)
local existing = espSlots[index]
if existing then return existing end
local made = {
box = newDrawing("Square", { Thickness = 1, Filled = false, Color = WHITE }),
outline = newDrawing("Square", { Thickness = 3, Filled = false, Color = Color3.new() }),
name = newDrawing("Text", { Size = Settings.EspTextSize, Center = true, Outline = true, Color = WHITE }),
distance = newDrawing("Text", { Size = Settings.EspTextSize, Center = true, Outline = true, Color = WHITE }),
weapon = newDrawing("Text", { Size = Settings.EspTextSize, Center = true, Outline = true, Color = WHITE }),
health = newDrawing("Square", { Thickness = 1, Filled = true }),
healthBack = newDrawing("Square", { Thickness = 1, Filled = true, Color = Color3.new() }),
dot = newDrawing("Circle", { Thickness = 1, NumSides = 12, Radius = 3, Filled = true }),
tracer = newDrawing("Line", { Thickness = 1 }),
}
espSlots[index] = made
return made
end
local function hideSlot(entry)
for _, object in entry do
object.Visible = false
end
end
local function hideFrom(index)
for i = index, slotsUsed do
local entry = espSlots[i]
if entry then hideSlot(entry) end
end
slotsUsed = index - 1
end
local highlights = {}
local chamsHolder
local function chams(entity, colour)
local model = entity.Model
if not model then return end
local highlight = highlights[model]
if not highlight then
if not chamsHolder then
chamsHolder = Instance.new("Folder")
chamsHolder.Name = "KaliChams"
chamsHolder.Parent = gethui()
table.insert(Kali.Guis, chamsHolder)
end
highlight = Instance.new("Highlight")
highlight.FillTransparency = 0.6
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Adornee = model
highlight.Parent = chamsHolder
highlights[model] = highlight
end
highlight.FillColor = colour
highlight.OutlineColor = colour
highlight.Enabled = true
end
local function clearChams()
for model, highlight in highlights do
pcall(function() highlight:Destroy() end)
highlights[model] = nil
end
end
table.insert(Kali.Restore, clearChams)
local function weaponName(fighter)
local item = fighter.EquippedItem
return item and item.Name or ""
end
local espLooped = false
local function startEspLoop()
if espLooped then return end
espLooped = true
Kali.track(RunService.RenderStepped:Connect(function()
if not Kali.Running or not Settings.Esp then
if slotsUsed > 0 then hideFrom(1) end
if next(highlights) then clearChams() end
return
end
local origin = Camera.CFrame.Position
local viewport = Camera.ViewportSize
local index = 0
local seen = {}
for _, entity in enemies() do
local fighter = entity.ClientFighter
local ally = isAlly(fighter)
if ally and not Settings.EspTeammates then continue end
local root = entity.RootPart
local distance = (root.Position - origin).Magnitude
if distance > Settings.EspMaxDistance then continue end
local top, onScreen = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
if not onScreen then continue end
local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
local height = math.abs(top.Y - bottom.Y)
local width = height * 0.5
local left = top.X - width * 0.5
index += 1
local entry = slot(index)
local colour = ally and Settings.EspAllyColor or Settings.EspEnemyColor
seen[entity.Model] = true
entry.box.Visible = Settings.EspBox
entry.outline.Visible = Settings.EspBox
if Settings.EspBox then
entry.box.Color = colour
entry.box.Position = Vector2.new(left, top.Y)
entry.box.Size = Vector2.new(width, height)
entry.outline.Position = entry.box.Position
entry.outline.Size = entry.box.Size
end
entry.name.Visible = Settings.EspName
if Settings.EspName then
entry.name.Color = colour
entry.name.Size = Settings.EspTextSize
entry.name.Text = entity.Player and entity.Player.Name or "?"
entry.name.Position = Vector2.new(top.X, top.Y - Settings.EspTextSize - 2)
end
local footer = top.Y + height + 2
entry.distance.Visible = Settings.EspDistance
if Settings.EspDistance then
entry.distance.Color = colour
entry.distance.Size = Settings.EspTextSize
entry.distance.Text = ("%dm"):format(distance // 1)
entry.distance.Position = Vector2.new(top.X, footer)
footer += Settings.EspTextSize
end
entry.weapon.Visible = Settings.EspWeapon
if Settings.EspWeapon then
entry.weapon.Color = colour
entry.weapon.Size = Settings.EspTextSize
entry.weapon.Text = weaponName(fighter)
entry.weapon.Position = Vector2.new(top.X, footer)
end
local wantHealth = Settings.EspHealth
entry.health.Visible = wantHealth
entry.healthBack.Visible = wantHealth
if wantHealth then
local humanoid = entity.Humanoid
local ratio = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
local barX = left - 6
entry.healthBack.Position = Vector2.new(barX, top.Y)
entry.healthBack.Size = Vector2.new(3, height)
entry.health.Color = Color3.fromRGB(255 - 255 * ratio, 255 * ratio, 60)
entry.health.Position = Vector2.new(barX, top.Y + height * (1 - ratio))
entry.health.Size = Vector2.new(3, height * ratio)
end
entry.dot.Visible = Settings.EspHeadDot
if Settings.EspHeadDot then
local head = hitbox(entity, "Head")
local screen = Camera:WorldToViewportPoint((head or root).Position)
entry.dot.Color = colour
entry.dot.Position = Vector2.new(screen.X, screen.Y)
end
entry.tracer.Visible = Settings.EspTracer
if Settings.EspTracer then
entry.tracer.Color = colour
entry.tracer.From = Vector2.new(viewport.X * 0.5, viewport.Y)
entry.tracer.To = Vector2.new(top.X, top.Y + height)
end
if Settings.EspChams then
chams(entity, colour)
end
end
hideFrom(index + 1)
slotsUsed = index
if Settings.EspChams then
for model, highlight in highlights do
if not seen[model] then
highlight:Destroy()
highlights[model] = nil
end
end
elseif next(highlights) then
clearChams()
end
end))
end
local fovCircle
local fovLooped = false
local function startFovLoop()
if fovLooped then return end
fovLooped = true
fovCircle = newDrawing("Circle", { Thickness = 1, Filled = false, NumSides = 60 })
Kali.track(RunService.RenderStepped:Connect(function()
if not Kali.Running or not Settings.ShowFov then
fovCircle.Visible = false
return
end
local viewport = Camera.ViewportSize
fovCircle.Visible = true
fovCircle.Color = Settings.FovColor
fovCircle.Radius = (Settings.Ragebot and Settings.RageFov)
or (Settings.SilentAim and Settings.SilentFov)
or Settings.AimFov
fovCircle.Position = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
end))
end
local lightingBaseline = {
Ambient = Lighting.Ambient,
OutdoorAmbient = Lighting.OutdoorAmbient,
Brightness = Lighting.Brightness,
FogEnd = Lighting.FogEnd,
GlobalShadows = Lighting.GlobalShadows,
}
table.insert(Kali.Restore, function()
for key, value in lightingBaseline do
pcall(function() Lighting[key] = value end)
end
end)
local worldLooped = false
local function startWorldLoop()
if worldLooped then return end
worldLooped = true
Kali.track(RunService.Heartbeat:Connect(function()
if not Kali.Running then return end
if Settings.Fullbright then
Lighting.Ambient = WHITE
Lighting.OutdoorAmbient = WHITE
Lighting.Brightness = 3
Lighting.GlobalShadows = false
end
if Settings.NoFog then
Lighting.FogEnd = 1e6
end
if Settings.CustomFov then
CameraController._base_fov = Settings.FovValue
end
end))
end
local fovBaseline = CameraController._base_fov
table.insert(Kali.Restore, function()
CameraController._base_fov = fovBaseline
end)
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
pcall(function()
library.QueueAutoExecute = function()
if not library:IsAutoExecute() then return false end
local queue = queueonteleport or queue_on_teleport
if type(queue) ~= "function" then return false end
return pcall(queue, AUTO_SRC)
end
library:SetLoaderSource(AUTO_SRC)
end)
local window
do
local parent = gethui()
local before = {}
for _, child in parent:GetChildren() do before[child] = true end
window = library:CreateWindow(gui_config, parent)
for _, child in parent:GetChildren() do
if not before[child] and child:IsA("ScreenGui") then
table.insert(Kali.Guis, child)
end
end
end
library:SetWindowName("Kali Hub | Rivals")
local tabs = {
combat = window:CreateTab("Combat"),
visuals = window:CreateTab("Visuals"),
config = window:CreateTab("Config"),
}
do
local aiming = tabs.combat:CreateSection("Aiming", "left")
aiming:CreateToggle("Silent Aim", Settings.SilentAim, function(state)
Settings.SilentAim = state
if state then
installAimHook()
startFovLoop()
end
end)
aiming:CreateDropdown("Hit Part", { "Head", "Body" }, function(part)
Settings.SilentHitPart = part
end, Settings.SilentHitPart)
aiming:CreateSlider("Hit Chance", 1, 100, Settings.SilentHitChance, true, function(chance)
Settings.SilentHitChance = chance
end)
aiming:CreateSlider("Silent FOV", 20, 800, Settings.SilentFov, true, function(size)
Settings.SilentFov = size
end)
aiming:CreateToggle("Silent Visible Check", Settings.SilentVisibleCheck, function(state)
Settings.SilentVisibleCheck = state
end)
end
do
local assist = tabs.combat:CreateSection("Aim Assist", "right")
assist:CreateToggle("Aimbot", Settings.Aimbot, function(state)
Settings.Aimbot = state
if state then
startCombatLoop()
startFovLoop()
end
end)
assist:CreateToggle("Hold Right Mouse", Settings.AimHoldRight, function(state)
Settings.AimHoldRight = state
end)
assist:CreateDropdown("Aim Part", { "Head", "Body" }, function(part)
Settings.AimPart = part
end, Settings.AimPart)
assist:CreateSlider("Aim FOV", 20, 600, Settings.AimFov, true, function(size)
Settings.AimFov = size
end)
assist:CreateSlider("Smoothing", 0, 20, Settings.AimSmoothing, true, function(value)
Settings.AimSmoothing = value
end)
assist:CreateToggle("Aim Visible Check", Settings.AimVisibleCheck, function(state)
Settings.AimVisibleCheck = state
end)
assist:CreateToggle("Show FOV", Settings.ShowFov, function(state)
Settings.ShowFov = state
if state then startFovLoop() end
end)
assist:CreateColorpicker("FOV Color", function(colour)
Settings.FovColor = colour
end, false, false, nil, Settings.FovColor)
end
do
local rage = tabs.combat:CreateSection("Ragebot", "left")
rage:CreateToggle("Ragebot", Settings.Ragebot, function(state)
Settings.Ragebot = state
if state then
installAimHook()
startCombatLoop()
startFovLoop()
end
end)
rage:CreateDropdown("Target Priority", { "Crosshair", "Closest", "Lowest Health" }, function(mode)
Settings.RageMode = mode
end, Settings.RageMode)
rage:CreateDropdown("Rage Hit Part", { "Head", "Body" }, function(part)
Settings.RageHitPart = part
end, Settings.RageHitPart)
rage:CreateSlider("Rage FOV", 50, 1200, Settings.RageFov, true, function(size)
Settings.RageFov = size
end)
rage:CreateSlider("Rage Max Distance", 50, 2000, Settings.RageMaxDistance, true, function(value)
Settings.RageMaxDistance = value
end)
rage:CreateSlider("Extra Fire Delay", 0, 0.5, Settings.RageFireDelay, false, function(delay)
Settings.RageFireDelay = delay
end)
rage:CreateToggle("Rage Visible Check", Settings.RageVisibleCheck, function(state)
Settings.RageVisibleCheck = state
end)
end
do
local trigger = tabs.combat:CreateSection("Triggerbot", "right")
trigger:CreateToggle("Triggerbot", Settings.Triggerbot, function(state)
Settings.Triggerbot = state
if state then startCombatLoop() end
end)
trigger:CreateSlider("Trigger Radius", 2, 40, Settings.TriggerRadius, true, function(radius)
Settings.TriggerRadius = radius
end)
trigger:CreateSlider("Trigger Delay", 0, 0.5, Settings.TriggerDelay, false, function(delay)
Settings.TriggerDelay = delay
end)
end
do
local mods = tabs.combat:CreateSection("Weapon Mods", "right")
local function modToggle(label, key)
mods:CreateToggle(label, Settings[key], function(state)
Settings[key] = state
startModsLoop()
applyMods()
end)
end
modToggle("No Recoil", "NoRecoil")
modToggle("No Spread", "NoSpread")
modToggle("Instant Aim", "InstantAim")
modToggle("No Slowdown", "NoSlowdown")
end
do
local esp = tabs.visuals:CreateSection("Players", "left")
esp:CreateToggle("Enable ESP", Settings.Esp, function(state)
Settings.Esp = state
if state then startEspLoop() end
end)
esp:CreateToggle("Box", Settings.EspBox, function(state) Settings.EspBox = state end)
esp:CreateToggle("Name", Settings.EspName, function(state) Settings.EspName = state end)
esp:CreateToggle("Health Bar", Settings.EspHealth, function(state) Settings.EspHealth = state end)
esp:CreateToggle("Distance", Settings.EspDistance, function(state) Settings.EspDistance = state end)
esp:CreateToggle("Weapon", Settings.EspWeapon, function(state) Settings.EspWeapon = state end)
esp:CreateToggle("Head Dot", Settings.EspHeadDot, function(state) Settings.EspHeadDot = state end)
esp:CreateToggle("Tracers", Settings.EspTracer, function(state) Settings.EspTracer = state end)
esp:CreateToggle("Chams", Settings.EspChams, function(state) Settings.EspChams = state end)
esp:CreateToggle("Show Teammates", Settings.EspTeammates, function(state) Settings.EspTeammates = state end)
end
do
local style = tabs.visuals:CreateSection("ESP Style", "right")
style:CreateSlider("Max Distance", 100, 3000, Settings.EspMaxDistance, true, function(value)
Settings.EspMaxDistance = value
end)
style:CreateSlider("Text Size", 8, 24, Settings.EspTextSize, true, function(value)
Settings.EspTextSize = value
end)
style:CreateColorpicker("Enemy Color", function(colour)
Settings.EspEnemyColor = colour
end, false, false, nil, Settings.EspEnemyColor)
style:CreateColorpicker("Ally Color", function(colour)
Settings.EspAllyColor = colour
end, false, false, nil, Settings.EspAllyColor)
end
do
local world = tabs.visuals:CreateSection("World", "left")
world:CreateToggle("Fullbright", Settings.Fullbright, function(state)
Settings.Fullbright = state
startWorldLoop()
if not state then
for key, value in lightingBaseline do
pcall(function() Lighting[key] = value end)
end
end
end)
world:CreateToggle("No Fog", Settings.NoFog, function(state)
Settings.NoFog = state
startWorldLoop()
if not state then Lighting.FogEnd = lightingBaseline.FogEnd end
end)
world:CreateToggle("Custom Camera FOV", Settings.CustomFov, function(state)
Settings.CustomFov = state
startWorldLoop()
if not state then CameraController._base_fov = fovBaseline end
end)
world:CreateSlider("Camera FOV", 40, 120, Settings.FovValue, true, function(value)
Settings.FovValue = value
end)
end
Kali.track(UserInputService.InputBegan:Connect(function(input, processed)
if processed then return end
if input.UserInputType == Enum.UserInputType.MouseButton2 then aimHeld = true end
end))
Kali.track(UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton2 then aimHeld = false end
end))
do
local ok, configManager = pcall(function()
return loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
end)
if ok and configManager then
pcall(function()
configManager:SetLibrary(library)
configManager:SetWindow(window)
configManager:SetFolder("Kali Hub")
configManager:BuildConfigSection(tabs.config)
configManager:LoadAutoloadConfig()
end)
end
end
window:SetBackgroundColor(WHITE)
window:SetBackground("rbxassetid://133937513221602")
window:SetBackgroundTransparency(0)
getgenv().KaliUnload = function()
Kali.Running = false
for key, value in Settings do
if type(value) == "boolean" then Settings[key] = false end
end
for _, restore in Kali.Restore do
pcall(restore)
end
table.clear(Kali.Restore)
for _, connection in Kali.Connections do
pcall(function() connection:Disconnect() end)
end
table.clear(Kali.Connections)
for _, object in Kali.Drawings do
pcall(function() object:Remove() end)
end
table.clear(Kali.Drawings)
table.clear(espSlots)
slotsUsed = 0
pcall(function() window:Destroy() end)
for _, gui in Kali.Guis do
pcall(function() gui:Destroy() end)
end
table.clear(Kali.Guis)
end
