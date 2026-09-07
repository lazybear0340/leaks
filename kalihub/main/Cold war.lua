-- this shit was unobfuscated


local WHITE = Color3.new(1, 1, 1)
if type(getgenv().KaliUnload) == "function" then
pcall(getgenv().KaliUnload)
end
getgenv().KaliUnload = nil
if type(getgenv().Anka) == "table" then
local alive = false
for _, gui in gethui():GetChildren() do
if gui:IsA("ScreenGui") and gui:FindFirstChild("Main") then
alive = true
break
end
end
if not alive then getgenv().Anka = nil end
end
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
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Kali = {
Running = true,
Connections = {},
Guis = {},
Restore = {},
}
function Kali.track(connection)
table.insert(Kali.Connections, connection)
return connection
end
local AUTO_SRC = [[
if getgenv().__KaliColdWarBootJob == game.JobId then
	return
end
getgenv().__KaliColdWarBootJob = game.JobId
local src
if isfile and isfile("Cold War.lua") then
	src = readfile("Cold War.lua")
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
Ragebot = false,
AimPart = "Head",
Priority = "Crosshair",
AimFov = 250,
ShowFov = false,
MaxDistance = 1200,
VisibleCheck = true,
Prediction = true,
LeadScale = 1,
BulletDrop = true,
WallPenetration = false,
PenetrationPower = 6,
AutoReload = false,
ReloadAt = 0,
Noclip = false,
Esp = false,
EspBox = true,
EspName = true,
EspDistance = true,
EspHealth = true,
EspWeapon = false,
EspClass = false,
EspHeadDot = false,
EspTracer = false,
EspTracerFrom = "Bottom",
EspChams = false,
EspChamsFill = 0.55,
EspVehicles = false,
EspTeammates = false,
EspDimOccluded = true,
EspMaxDistance = 2000,
EspTextSize = 13,
EspEnemyColor = Color3.fromRGB(255, 80, 80),
EspAllyColor = Color3.fromRGB(90, 170, 255),
}
local ENEMY_TINT = Settings.EspEnemyColor
local ALLY_TINT = Settings.EspAllyColor
local VEHICLE_TINT = Color3.fromRGB(255, 200, 90)
local STUDS_PER_METRE = 3.57
local Camera = workspace.CurrentCamera
Kali.track(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
Camera = workspace.CurrentCamera
end))
local fireHooked, penetrationHooked, weaponHooked = false, false, false
local combatLooped, movementLooped, overlayLooped = false, false, false
local activeWeapon, rageFiring, lastShot
local collisionBaselines = setmetatable({}, { __mode = "k" })
local AIM_LIMBS = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
local losParams = RaycastParams.new()
losParams.FilterType = Enum.RaycastFilterType.Exclude
losParams.IgnoreWater = false
local function refreshLos()
local CollisionGroups = require(ReplicatedStorage.Shared:WaitForChild("CollisionGroups"))
local team = LocalPlayer.Team
losParams.FilterDescendantsInstances = { LocalPlayer.Character, workspace.Ignore }
losParams.CollisionGroup = CollisionGroups.teamRayGroup(team and team.Name)
end
local function reaches(eye, part)
local hit = workspace:Raycast(eye, part.Position - eye, losParams)
return hit == nil or hit.Instance:IsDescendantOf(part.Parent)
end
local function nearestPart(character, centre)
if Settings.AimPart ~= "Nearest" then
local part = character:FindFirstChild(Settings.AimPart)
if not part then return nil end
local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
if not onScreen then return nil end
return part, (Vector2.new(screen.X, screen.Y) - centre).Magnitude
end
local closest, smallest
for _, limb in AIM_LIMBS do
local part = character:FindFirstChild(limb)
if part then
local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
if onScreen then
local gap = (Vector2.new(screen.X, screen.Y) - centre).Magnitude
if not smallest or gap < smallest then
closest, smallest = part, gap
end
end
end
end
return closest, smallest
end
local function pickTarget()
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health <= 0 then return nil end
local team = LocalPlayer.Team
refreshLos()
local eye = Camera.CFrame.Position
local centre = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
local checkLine = Settings.VisibleCheck and not Settings.WallPenetration
local target, targetRoot, best
for _, player in Players:GetPlayers() do
if player ~= LocalPlayer and (not team or player.Team ~= team) then
local enemy = player.Character
local enemyHumanoid = enemy and enemy:FindFirstChildOfClass("Humanoid")
if enemyHumanoid and enemyHumanoid.Health > 0 then
local part, gap = nearestPart(enemy, centre)
if part and gap <= Settings.AimFov then
local range = (part.Position - eye).Magnitude
if range <= Settings.MaxDistance and (not checkLine or reaches(eye, part)) then
local score = Settings.Priority == "Distance" and range or gap
if not best or score < best then
target, targetRoot, best = part, enemy:FindFirstChild("HumanoidRootPart"), score
end
end
end
end
end
end
return target, targetRoot
end
local function aimDirection(tool, muzzleIndex, bulletIndex, origin)
local target, root = pickTarget()
if not target then return nil end
local Ballistics = ReplicatedStorage.Shared:WaitForChild("Ballistics")
local Trajectory = require(Ballistics:WaitForChild("Trajectory"))
local WeaponConfigManager = require(ReplicatedStorage.Shared:WaitForChild("WeaponConfigManager"))
local weaponName = typeof(tool) == "Instance" and tool.Name or tool
if type(weaponName) ~= "string" then return nil end
local muzzle = WeaponConfigManager:GetMuzzleConfig(weaponName, muzzleIndex or 1)
local bullet = muzzle and muzzle.BulletSettings and muzzle.BulletSettings[bulletIndex or 1]
if not bullet then return nil end
local arc = Trajectory.new({
Origin = origin,
Direction = Vector3.new(0, 0, -1),
MuzzleSpeed = bullet.MuzzleVelocity or 0,
K = bullet.Drag or 1,
})
local lead = Settings.Prediction and root and root.AssemblyLinearVelocity or nil
local drop = Settings.BulletDrop and workspace.Gravity * 0.5 or 0
local aim = target.Position
for _ = 1, 4 do
local flight = Trajectory.GetTimeForDistance(arc, (aim - origin).Magnitude)
if not flight then return nil end
aim = target.Position + Vector3.yAxis * (drop * flight * flight)
if lead then
aim += lead * (flight * Settings.LeadScale)
end
end
local offset = aim - origin
return offset.Magnitude > 1e-4 and offset.Unit or nil
end
local function installFireHook()
if fireHooked then return end
fireHooked = true
local ballisticsClient = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("BallisticsClient")
local ClientFire = require(ballisticsClient:WaitForChild("ClientFire"))
local fireVolley = ClientFire.fireVolley
ClientFire.fireVolley = function(tool, muzzleIndex, bulletIndex, origin, directions, options)
if (Settings.SilentAim or Settings.Ragebot) and type(directions) == "table" and #directions > 0 then
local solved, direction = pcall(aimDirection, tool, muzzleIndex, bulletIndex, origin)
if solved and direction then
for index = 1, #directions do
directions[index] = direction
end
end
end
return fireVolley(tool, muzzleIndex, bulletIndex, origin, directions, options)
end
table.insert(Kali.Restore, function() ClientFire.fireVolley = fireVolley end)
end
local function installPenetrationHook()
if penetrationHooked then return end
penetrationHooked = true
local Ballistics = ReplicatedStorage.Shared:WaitForChild("Ballistics")
local WeaponSource = require(Ballistics.Sources:WaitForChild("WeaponSource"))
local toFireParams = WeaponSource.toFireParams
WeaponSource.toFireParams = function(params)
local fireParams = toFireParams(params)
if Settings.WallPenetration and fireParams and fireParams.Weapon and params.Owner == LocalPlayer then
local power = math.max(fireParams.Weapon.Penetration or 0, Settings.PenetrationPower)
fireParams.Weapon.Penetration = power
fireParams.Weapon.PenetrationPower = power
end
return fireParams
end
table.insert(Kali.Restore, function() WeaponSource.toFireParams = toFireParams end)
end
local function findEquippedWeapon()
local character = LocalPlayer.Character
local tool = character and character:FindFirstChildOfClass("Tool")
if not tool or type(filtergc) ~= "function" then return nil end
for _, candidate in filtergc("table", { Keys = { "currentMuzzle", "muzzles", "tool" } }) or {} do
if candidate.tool == tool then return candidate end
end
return nil
end
local function installWeaponHook()
if weaponHooked then return end
weaponHooked = true
local WeaponClass = require(ReplicatedStorage.Client.Tools:WaitForChild("Weapon"))
local equip, unequip = WeaponClass.equip, WeaponClass.unequip
WeaponClass.equip = function(self, ...)
activeWeapon = self
return equip(self, ...)
end
WeaponClass.unequip = function(self, ...)
if activeWeapon == self then activeWeapon = nil end
return unequip(self, ...)
end
table.insert(Kali.Restore, function()
WeaponClass.equip = equip
WeaponClass.unequip = unequip
end)
activeWeapon = activeWeapon or select(2, pcall(findEquippedWeapon))
end
local function restoreCollision()
for part, baseline in collisionBaselines do
if part.Parent then part.CanCollide = baseline end
collisionBaselines[part] = nil
end
end
local function installMovementLoop()
if movementLooped then return end
movementLooped = true
Kali.track(RunService.Heartbeat:Connect(function()
if not Kali.Running then return end
local character = LocalPlayer.Character
if not character then
restoreCollision()
return
end
if Settings.Noclip then
for _, part in character:GetDescendants() do
if part:IsA("BasePart") then
if collisionBaselines[part] == nil then collisionBaselines[part] = part.CanCollide end
part.CanCollide = false
end
end
else
restoreCollision()
end
end))
end
local function stepReload(muzzle)
if muzzle.magazine:count() > Settings.ReloadAt then return end
local options = muzzle:getReloadOptions()
local bulletIndex = muzzle:getBulletIndex()
if not (bulletIndex and options[bulletIndex]) then
bulletIndex = next(options)
end
if bulletIndex then muzzle:reload(bulletIndex) end
end
local function stepRage(muzzle)
if not pickTarget() then
if rageFiring then
rageFiring = false
muzzle:stopFiring()
end
return
end
rageFiring = true
local mode = muzzle:getFireModeName()
if mode == "Automatic" or mode == "Slamfire" then
if not muzzle.fireController.isFiring then muzzle:startFiring() end
return
end
local now = os.clock()
if now - (lastShot or 0) < 60 / (muzzle.config.Firerate or 600) then return end
lastShot = now
muzzle:stopFiring()
muzzle:startFiring()
end
local function installCombatLoop()
if combatLooped then return end
combatLooped = true
local nextStep = 0
Kali.track(RunService.Heartbeat:Connect(function()
if not Kali.Running then return end
local now = os.clock()
if now < nextStep then return end
nextStep = now + 0.05
local muzzle = activeWeapon and activeWeapon.currentMuzzle
if not muzzle then return end
if Settings.AutoReload then pcall(stepReload, muzzle) end
if Settings.Ragebot then
pcall(stepRage, muzzle)
elseif rageFiring then
rageFiring = false
pcall(muzzle.stopFiring, muzzle)
end
end))
end
local overlay, fovRing, slotsDrawn = nil, nil, 0
local espSlots = {}
local highlights = {}
local vehicleExtents = setmetatable({}, { __mode = "k" })
local function ensureOverlay()
if overlay and overlay.Parent then return overlay end
overlay = Instance.new("ScreenGui")
overlay.Name = "Overlay"
overlay.ResetOnSpawn = false
overlay.DisplayOrder = 9
overlay.Parent = LocalPlayer:WaitForChild("PlayerGui")
table.insert(Kali.Guis, overlay)
return overlay
end
local function newElement(class, parent, props)
local element = Instance.new(class)
for key, value in props do
element[key] = value
end
element.Parent = parent
return element
end
local function espSlot(index)
local slot = espSlots[index]
if slot then return slot end
local gui = ensureOverlay()
local label = {
BackgroundTransparency = 1,
Font = Enum.Font.Code,
TextStrokeTransparency = 0,
Visible = false,
}
slot = {}
slot.box = newElement("Frame", gui, { BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false })
slot.outline = newElement("UIStroke", slot.box, { Thickness = 1 })
slot.name = newElement("TextLabel", gui, label)
slot.info = newElement("TextLabel", gui, label)
slot.bar = newElement("Frame", gui, {
BackgroundColor3 = Color3.new(),
BackgroundTransparency = 0.35,
BorderSizePixel = 0,
Visible = false,
})
slot.fill = newElement("Frame", slot.bar, {
BorderSizePixel = 0,
AnchorPoint = Vector2.new(0, 1),
Position = UDim2.fromScale(0, 1),
})
slot.dot = newElement("Frame", gui, {
BorderSizePixel = 0,
AnchorPoint = Vector2.new(0.5, 0.5),
Size = UDim2.fromOffset(4, 4),
Visible = false,
})
newElement("UICorner", slot.dot, { CornerRadius = UDim.new(1, 0) })
slot.tracer = newElement("Frame", gui, {
BorderSizePixel = 0,
AnchorPoint = Vector2.new(0, 0.5),
Visible = false,
})
espSlots[index] = slot
return slot
end
local function hideSlot(slot)
slot.box.Visible = false
slot.name.Visible = false
slot.info.Visible = false
slot.bar.Visible = false
slot.dot.Visible = false
slot.tracer.Visible = false
end
local function paintSlot(slot, top, bottom, width, tint, title, subtitle, alpha)
local height = math.abs(top.Y - bottom.Y)
local centre = (top.X + bottom.X) * 0.5
local upper = math.min(top.Y, bottom.Y)
local text = Settings.EspTextSize
slot.box.Visible = Settings.EspBox
if Settings.EspBox then
slot.box.Position = UDim2.fromOffset(centre - width * 0.5, upper)
slot.box.Size = UDim2.fromOffset(width, height)
slot.outline.Color = tint
end
slot.name.Visible = title ~= nil
if title then
slot.name.Text = title
slot.name.TextColor3 = tint
slot.name.TextSize = text
slot.name.Position = UDim2.fromOffset(centre - 110, upper - text - 2)
slot.name.Size = UDim2.fromOffset(220, text + 2)
end
slot.info.Visible = subtitle ~= nil
if subtitle then
slot.info.Text = subtitle
slot.info.TextColor3 = tint
slot.info.TextSize = text
slot.info.Position = UDim2.fromOffset(centre - 110, upper + height + 1)
slot.info.Size = UDim2.fromOffset(220, text + 2)
end
slot.bar.Visible = alpha ~= nil
if alpha then
local LimbHealth = require(ReplicatedStorage.Client:WaitForChild("LimbHealth"))
slot.bar.Position = UDim2.fromOffset(centre - width * 0.5 - 5, upper)
slot.bar.Size = UDim2.fromOffset(3, height)
slot.fill.Size = UDim2.new(1, 0, alpha, 0)
slot.fill.BackgroundColor3 = LimbHealth.colorFor(alpha)
end
slot.dot.Visible = Settings.EspHeadDot
if Settings.EspHeadDot then
slot.dot.Position = UDim2.fromOffset(centre, upper + height * 0.08)
slot.dot.BackgroundColor3 = tint
end
slot.tracer.Visible = Settings.EspTracer
if Settings.EspTracer then
local viewport = Camera.ViewportSize
local from
if Settings.EspTracerFrom == "Top" then
from = Vector2.new(viewport.X * 0.5, 0)
elseif Settings.EspTracerFrom == "Centre" then
from = viewport * 0.5
else
from = Vector2.new(viewport.X * 0.5, viewport.Y)
end
local reach = Vector2.new(centre, upper + height) - from
slot.tracer.Position = UDim2.fromOffset(from.X, from.Y)
slot.tracer.Size = UDim2.fromOffset(reach.Magnitude, 1)
slot.tracer.Rotation = math.deg(math.atan2(reach.Y, reach.X))
slot.tracer.BackgroundColor3 = tint
end
end
local function healthAlpha(character)
local current, maximum = 0, 0
for _, limb in AIM_LIMBS do
local part = character:FindFirstChild(limb)
local health = part and part:FindFirstChild("Health")
local cap = health and health:GetAttribute("MaxHealth")
if cap and cap > 0 then
current += health.Value
maximum += cap
end
end
if maximum <= 0 then return nil end
return math.clamp(current / maximum, 0, 1)
end
local function applyChams(character, tint)
local highlight = highlights[character]
if not highlight then
highlight = newElement("Highlight", ensureOverlay(), {
DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
Adornee = character,
})
highlights[character] = highlight
end
highlight.FillColor = tint
highlight.OutlineColor = tint
highlight.FillTransparency = 1 - Settings.EspChamsFill
end
local function labelsFor(player, character, range)
local title = Settings.EspName and player.DisplayName or nil
if Settings.EspClass then
local values = character:FindFirstChild("CharacterValues")
local class = values and values:FindFirstChild("ClassType")
if class then
title = title and (title .. "  [" .. class.Value .. "]") or class.Value
end
end
local line = {}
if Settings.EspDistance then
line[#line + 1] = ("%dm"):format(range / STUDS_PER_METRE)
end
if Settings.EspWeapon then
local tool = character:FindFirstChildOfClass("Tool")
if tool then line[#line + 1] = tool.Name end
end
return title, #line > 0 and table.concat(line, "  |  ") or nil
end
local function stepEsp(eye, wanted)
local team = LocalPlayer.Team
local used = 0
for _, player in Players:GetPlayers() do
if player ~= LocalPlayer then
local ally = team ~= nil and player.Team == team
if not ally or Settings.EspTeammates then
local character = player.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local head = character and character:FindFirstChild("Head")
local root = character and character:FindFirstChild("HumanoidRootPart")
if humanoid and humanoid.Health > 0 and head and root then
local range = (root.Position - eye).Magnitude
if range <= Settings.EspMaxDistance then
local top, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.yAxis * 0.8)
if onScreen then
local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.yAxis * 3.2)
local tint = ally and Settings.EspAllyColor or Settings.EspEnemyColor
if Settings.EspDimOccluded and not reaches(eye, head) then
tint = tint:Lerp(Color3.new(), 0.5)
end
local title, subtitle = labelsFor(player, character, range)
local height = math.abs(top.Y - bottom.Y)
used += 1
paintSlot(espSlot(used), top, bottom, height * 0.55, tint, title, subtitle,
Settings.EspHealth and healthAlpha(character) or nil)
if Settings.EspChams then
applyChams(character, tint)
wanted[character] = true
end
end
end
end
end
end
end
local vehicles = Settings.EspVehicles and workspace:FindFirstChild("Vehicles")
if vehicles then
for _, vehicle in vehicles:GetChildren() do
local root = vehicle.PrimaryPart or vehicle:FindFirstChild("RootPart")
if root then
local range = (root.Position - eye).Magnitude
if range <= Settings.EspMaxDistance then
local size = vehicleExtents[vehicle]
if not size then
size = vehicle:GetExtentsSize()
vehicleExtents[vehicle] = size
end
local half = size.Y * 0.5
local top, onScreen = Camera:WorldToViewportPoint(root.Position + Vector3.yAxis * half)
if onScreen then
local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.yAxis * half)
local spread = math.clamp(math.max(size.X, size.Z) / math.max(size.Y, 0.1), 0.5, 3)
used += 1
paintSlot(espSlot(used), top, bottom, math.abs(top.Y - bottom.Y) * spread, VEHICLE_TINT,
vehicle.Name, ("%dm"):format(range / STUDS_PER_METRE), nil)
end
end
end
end
end
return used
end
local function stepFovRing()
if not Settings.ShowFov then
if fovRing then fovRing.Visible = false end
return
end
if not fovRing then
fovRing = newElement("Frame", ensureOverlay(), {
BackgroundTransparency = 1,
BorderSizePixel = 0,
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromOffset(0, 0),
})
newElement("UICorner", fovRing, { CornerRadius = UDim.new(1, 0) })
newElement("UIStroke", fovRing, { Thickness = 1, Color = WHITE, Transparency = 0.4 })
end
fovRing.Visible = true
local mouse = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
fovRing.Position = UDim2.fromOffset(mouse.X, mouse.Y)
fovRing.Size = UDim2.fromOffset(Settings.AimFov * 2, Settings.AimFov * 2)
end
local function installOverlay()
if overlayLooped then return end
overlayLooped = true
ensureOverlay()
Kali.track(RunService.RenderStepped:Connect(function()
if not Kali.Running then return end
stepFovRing()
local used = 0
local wanted = Settings.EspChams and {} or nil
if Settings.Esp then
refreshLos()
local ok, drawn = pcall(stepEsp, Camera.CFrame.Position, wanted or {})
used = ok and drawn or 0
end
for index = used + 1, slotsDrawn do
hideSlot(espSlots[index])
end
slotsDrawn = used
for character, highlight in highlights do
if not (wanted and wanted[character]) then
highlight:Destroy()
highlights[character] = nil
end
end
end))
end
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
library:SetSaveFolder("Kali Hub")
pcall(function()
function library.QueueAutoExecute()
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
local guisBefore = {}
for _, child in parent:GetChildren() do guisBefore[child] = true end
window = library:CreateWindow(gui_config, parent)
for _, child in parent:GetChildren() do
if not guisBefore[child] and child:IsA("ScreenGui") then
table.insert(Kali.Guis, child)
end
end
end
library:SetWindowName("Kali Hub | Cold War")
local tabs = {
combat = window:CreateTab("Combat"),
visuals = window:CreateTab("Visuals"),
config = window:CreateTab("Config"),
}
local deps = {}
local function addDep(key, widget)
if not widget then return widget end
deps[key] = deps[key] or {}
table.insert(deps[key], widget)
pcall(function() widget:SetVisible(false) end)
return widget
end
local function showDeps(key, state)
for _, widget in deps[key] or {} do
pcall(function() widget:SetVisible(state) end)
end
end
do
local aiming = tabs.combat:CreateSection("Aiming", "left")
aiming:CreateToggle("Silent Aim", Settings.SilentAim, function(state)
Settings.SilentAim = state
if state then installFireHook() end
end)
aiming:CreateToggle("Ragebot", Settings.Ragebot, function(state)
Settings.Ragebot = state
if state then
installFireHook()
installWeaponHook()
installCombatLoop()
end
end, "dangerous")
aiming:CreateDropdown("Target Part", { "Head", "Torso", "Nearest" }, function(part)
Settings.AimPart = part
end, Settings.AimPart)
aiming:CreateDropdown("Priority", { "Crosshair", "Distance" }, function(mode)
Settings.Priority = mode
end, Settings.Priority)
aiming:CreateSlider("FOV", 30, 1000, Settings.AimFov, true, function(radius)
Settings.AimFov = radius
end)
aiming:CreateToggle("Show FOV", Settings.ShowFov, function(state)
Settings.ShowFov = state
if state then installOverlay() end
end)
aiming:CreateSlider("Max Distance", 50, 4000, Settings.MaxDistance, true, function(studs)
Settings.MaxDistance = studs
end)
aiming:CreateToggle("Visible Check", Settings.VisibleCheck, function(state)
Settings.VisibleCheck = state
end)
end
do
local ballistics = tabs.combat:CreateSection("Ballistics", "right")
ballistics:CreateToggle("Prediction", Settings.Prediction, function(state)
Settings.Prediction = state
showDeps("lead", state)
end)
addDep("lead", ballistics:CreateSlider("Lead Scale", 0, 200, Settings.LeadScale * 100, true, function(percent)
Settings.LeadScale = percent / 100
end))
ballistics:CreateToggle("Bullet Drop", Settings.BulletDrop, function(state)
Settings.BulletDrop = state
end)
showDeps("lead", Settings.Prediction)
end
do
local movement = tabs.combat:CreateSection("Movement", "left")
movement:CreateToggle("Noclip", Settings.Noclip, function(state)
Settings.Noclip = state
if state then installMovementLoop() else restoreCollision() end
end)
end
do
local players = tabs.visuals:CreateSection("Players", "left")
players:CreateToggle("ESP", Settings.Esp, function(state)
Settings.Esp = state
if state then installOverlay() end
end)
players:CreateToggle("Box", Settings.EspBox, function(state)
Settings.EspBox = state
end)
players:CreateToggle("Name", Settings.EspName, function(state)
Settings.EspName = state
end)
players:CreateToggle("Distance", Settings.EspDistance, function(state)
Settings.EspDistance = state
end)
players:CreateToggle("Health Bar", Settings.EspHealth, function(state)
Settings.EspHealth = state
end)
players:CreateToggle("Weapon", Settings.EspWeapon, function(state)
Settings.EspWeapon = state
end)
players:CreateToggle("Class", Settings.EspClass, function(state)
Settings.EspClass = state
end)
players:CreateToggle("Head Dot", Settings.EspHeadDot, function(state)
Settings.EspHeadDot = state
end)
players:CreateToggle("Tracer", Settings.EspTracer, function(state)
Settings.EspTracer = state
showDeps("tracer", state)
end)
addDep("tracer", players:CreateDropdown("Tracer From", { "Bottom", "Centre", "Top" }, function(origin)
Settings.EspTracerFrom = origin
end, Settings.EspTracerFrom))
players:CreateToggle("Chams", Settings.EspChams, function(state)
Settings.EspChams = state
showDeps("chams", state)
end)
addDep("chams", players:CreateSlider("Chams Fill", 0, 100, Settings.EspChamsFill * 100, true, function(percent)
Settings.EspChamsFill = percent / 100
end))
end
do
local world = tabs.visuals:CreateSection("World", "right")
world:CreateToggle("Vehicle ESP", Settings.EspVehicles, function(state)
Settings.EspVehicles = state
end)
world:CreateToggle("Show Teammates", Settings.EspTeammates, function(state)
Settings.EspTeammates = state
end)
world:CreateToggle("Dim Occluded", Settings.EspDimOccluded, function(state)
Settings.EspDimOccluded = state
end)
world:CreateSlider("ESP Distance", 100, 4000, Settings.EspMaxDistance, true, function(studs)
Settings.EspMaxDistance = studs
end)
world:CreateSlider("Text Size", 8, 24, Settings.EspTextSize, true, function(size)
Settings.EspTextSize = size
end)
world:CreateColorpicker("Enemy Color", function(colour)
Settings.EspEnemyColor = colour
end, false, false)
world:CreateColorpicker("Ally Color", function(colour)
Settings.EspAllyColor = colour
end, false, false)
end
do
local rounds = tabs.combat:CreateSection("Rounds", "left")
rounds:CreateToggle("Wall Penetration", Settings.WallPenetration, function(state)
Settings.WallPenetration = state
showDeps("penetration", state)
if state then installPenetrationHook() end
end)
addDep("penetration", rounds:CreateSlider("Penetration Power", 1, 30, Settings.PenetrationPower, true, function(power)
Settings.PenetrationPower = power
end))
rounds:CreateToggle("Auto Reload", Settings.AutoReload, function(state)
Settings.AutoReload = state
showDeps("reload", state)
if state then
installWeaponHook()
installCombatLoop()
end
end)
addDep("reload", rounds:CreateSlider("Reload At", 0, 15, Settings.ReloadAt, true, function(remaining)
Settings.ReloadAt = remaining
end))
end
do
local configOk, configManager = pcall(function()
return loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
end)
if configOk and configManager then
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
local muzzle = activeWeapon and activeWeapon.currentMuzzle
if muzzle and rageFiring then pcall(muzzle.stopFiring, muzzle) end
rageFiring = false
restoreCollision()
for _, restore in Kali.Restore do
pcall(restore)
end
table.clear(Kali.Restore)
for _, connection in Kali.Connections do
pcall(function() connection:Disconnect() end)
end
table.clear(Kali.Connections)
for _, highlight in highlights do
pcall(function() highlight:Destroy() end)
end
table.clear(highlights)
table.clear(espSlots)
slotsDrawn = 0
for _, gui in Kali.Guis do
pcall(function() gui:Destroy() end)
end
table.clear(Kali.Guis)
getgenv().Anka = nil
end
