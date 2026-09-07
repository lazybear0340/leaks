if getgenv().KaliHubLostFront then
pcall(getgenv().KaliHubLostFront.unload)
end
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local function currentCamera()
return workspace.CurrentCamera
end
local MODULE_SIGNATURES = {
bulletVM = { "calculateDirection", "makeSpread", "providers" },
registry = { "players", "isFriendly", "getEnemyTeam" },
weapon = { "fire", "reload", "input", "changeFireMode", "setReloading" },
config = { "items", "ammunition", "defaultLoadouts" },
recoilCam = { "new", "preset", "drive", "add" },
netLib = { "Any", "Buffer", "NumberF16" },
weaponFx = { "new", "ejectShell", "library", "items" },
}
local DRONE_CONTAINER_ID = "IllllII_iiii"
local function loadedModules()
local list = {}
if getloadedmodules then
local ok, modules = pcall(getloadedmodules)
if ok then
for _, instance in modules do
if instance:IsDescendantOf(ReplicatedStorage) then
table.insert(list, instance)
end
end
end
end
if #list == 0 then
for _, instance in ReplicatedStorage:GetChildren() do
if instance:IsA("ModuleScript") then
table.insert(list, instance)
end
end
end
return list
end
local function matches(exports, signature)
for _, key in signature do
if rawget(exports, key) == nil then return false end
end
return true
end
local function resolveModules()
local found = {}
local pending = 0
for _ in MODULE_SIGNATURES do pending += 1 end
for _, instance in loadedModules() do
if pending == 0 then break end
local ok, exports = pcall(require, instance)
if ok and type(exports) == "table" then
for name, signature in MODULE_SIGNATURES do
if not found[name] and matches(exports, signature) then
found[name] = exports
pending -= 1
end
end
end
end
return found
end
local Modules = resolveModules()
local BulletVM = Modules.bulletVM
local Registry = Modules.registry
local WeaponClass = Modules.weapon
local Config = Modules.config
local RecoilCam = Modules.recoilCam
local NetLib = Modules.netLib
local WeaponFx = Modules.weaponFx
if not (BulletVM and BulletVM.calculateDirection) then
return warn("[Kali Hub] Bullet module not found, the game was probably updated")
end
local function unlock(target)
if setreadonly then pcall(setreadonly, target, false) end
return target
end
local KH = {
enabled = false,
fov = 120,
targetPart = "Head",
visibleCheck = true,
showCircle = true,
prediction = true,
autoShoot = false,
forceHead = false,
grenadeAim = false,
noRecoil = false,
fullAuto = false,
autoReload = false,
fastReload = false,
reloadSpeed = 2.5,
noAdsSlow = false,
noMuzzle = false,
noDrop = false,
bulletSpeed = 0,
extraRange = 0,
extraFov = 0,
fullbright = false,
clearVision = false,
hitmarker = false,
espChams = false,
weapon = nil,
esp = false,
espBox = true,
espName = true,
espHealth = true,
espDistance = true,
espWeapon = false,
espTracer = false,
espTeammates = false,
espDrones = false,
espDistanceLimit = 1200,
locked = nil,
hitUntil = 0,
menuOpen = false,
connections = {},
}
getgenv().KaliHubLostFront = KH
local function isEnemy(player)
if not Registry or not Registry.isFriendly then return true end
local ok, friendly = pcall(Registry.isFriendly, player)
if not ok then return true end
return not friendly
end
local function registryEntry(player)
local players = Registry and Registry.players
return players and players[player] or nil
end
local function equippedName(player)
local entry = registryEntry(player)
local equipped = entry and entry.spawned and entry.spawned.equipped
local model = typeof(equipped) == "table" and equipped.model or nil
if typeof(model) == "Instance" then return model.Name end
return typeof(model) == "string" and model or nil
end
local function aimPart(character)
return character:FindFirstChild(KH.targetPart)
or character:FindFirstChild("Head")
or character:FindFirstChild("HumanoidRootPart")
end
local visionParams = RaycastParams.new()
visionParams.FilterType = Enum.RaycastFilterType.Exclude
visionParams.IgnoreWater = true
local function canSee(part, character)
if not KH.visibleCheck then return true end
local camera = currentCamera()
visionParams.FilterDescendantsInstances = { LocalPlayer.Character, character, camera }
local origin = camera.CFrame.Position
local hit = workspace:Raycast(origin, part.Position - origin, visionParams)
return hit == nil
end
local function mouseInViewport()
local mouse = UserInputService:GetMouseLocation()
local inset = GuiService:GetGuiInset()
return Vector2.new(mouse.X - inset.X, mouse.Y - inset.Y)
end
local function pickTarget()
local camera = currentCamera()
local mouse = mouseInViewport()
local best, bestDistance = nil, KH.fov
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer and isEnemy(player) then
local character = player.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local part = character and aimPart(character)
if part and humanoid and humanoid.Health > 0 then
local screen, onScreen = camera:WorldToViewportPoint(part.Position)
if onScreen then
local distance = (Vector2.new(screen.X, screen.Y) - mouse).Magnitude
if distance < bestDistance and canSee(part, character) then
best, bestDistance = part, distance
end
end
end
end
end
return best
end
local function currentAmmunition()
local weapon = KH.weapon
if weapon and typeof(weapon.data) == "table" and typeof(weapon.data.ammunition) == "table" then
return weapon.data.ammunition
end
local item = Config and Config.items and Config.items[equippedName(LocalPlayer) or ""]
return item and typeof(item.ammunition) == "table" and item.ammunition or nil
end
local function aimPosition(part)
if not KH.prediction then return part.Position end
local ammunition = currentAmmunition()
local speed = ammunition and ammunition.speed
if not speed or speed <= 0 then return part.Position end
local origin = currentCamera().CFrame.Position
local travel = (part.Position - origin).Magnitude / speed
local gravity = ammunition.gravity or Vector3.zero
return part.Position
+ part.AssemblyLinearVelocity * travel
- gravity * (travel * travel * 0.5)
end
local originalDirection = BulletVM.calculateDirection
BulletVM.calculateDirection = function(origin, aimCFrame, ...)
if KH.enabled and typeof(aimCFrame) == "CFrame" then
local target = pickTarget()
if target then
KH.locked = target
aimCFrame = CFrame.lookAt(aimCFrame.Position, aimPosition(target))
end
end
return originalDirection(origin, aimCFrame, ...)
end
local originalItems = {}
if Config and Config.items then
for _, item in pairs(Config.items) do
originalItems[item] = { kickback = item.kickback, fireModes = item.fireModes }
end
end
local originalRecoilNew = RecoilCam and RecoilCam.new
local originalFxNew = WeaponFx and WeaponFx.new
local function applyNoRecoil(enabled)
for item, saved in pairs(originalItems) do
if saved.kickback ~= nil then
unlock(item)
item.kickback = enabled and 0 or saved.kickback
end
end
if RecoilCam and originalRecoilNew then
unlock(RecoilCam)
RecoilCam.new = enabled and function() end or originalRecoilNew
end
end
local function applyNoMuzzle(enabled)
if not (WeaponFx and originalFxNew) then return end
unlock(WeaponFx)
WeaponFx.new = enabled and function() end or originalFxNew
end
local function applyFullAuto(enabled)
for item, saved in pairs(originalItems) do
local modes = saved.fireModes
if typeof(modes) == "table" and table.find(modes, "automatic") then
unlock(item)
item.fireModes = enabled and { "automatic" } or modes
end
end
end
local originalInput = WeaponClass and WeaponClass.input
if originalInput then
unlock(WeaponClass)
WeaponClass.input = function(self, action, state)
KH.weapon = self
if KH.menuOpen and action == "fire" then return end
return originalInput(self, action, state)
end
end
local originalReload = WeaponClass and WeaponClass.reload
if originalReload then
unlock(WeaponClass)
WeaponClass.reload = function(self, ...)
local result = originalReload(self, ...)
if self.reloading and typeof(self.animations) == "table" then
local speed = KH.fastReload and KH.reloadSpeed or 1
pcall(function() self.animations.reload:AdjustSpeed(speed) end)
pcall(function() self.animations.bolt:AdjustSpeed(speed) end)
end
return result
end
end
local ammunitionTables = {}
local originalAmmunition = {}
local function collectAmmunition(container)
if typeof(container) ~= "table" then return end
for _, entry in pairs(container) do
if typeof(entry) == "table" and entry.speed and entry.maxDistance and not originalAmmunition[entry] then
ammunitionTables[#ammunitionTables + 1] = entry
originalAmmunition[entry] = {
speed = entry.speed,
maxDistance = entry.maxDistance,
gravity = entry.gravity,
}
end
end
end
if Config then
collectAmmunition(Config.ammunition)
for _, item in pairs(Config.items or {}) do
if typeof(item.ammunition) == "table" then
collectAmmunition({ item.ammunition })
end
end
end
local function applyBallistics()
for _, ammunition in ipairs(ammunitionTables) do
local saved = originalAmmunition[ammunition]
unlock(ammunition)
ammunition.gravity = KH.noDrop and Vector3.zero or saved.gravity
ammunition.speed = saved.speed + KH.bulletSpeed
ammunition.maxDistance = saved.maxDistance + KH.extraRange
end
end
local stateTables = {}
local originalStates = {}
local idleSpeedForAimState = {}
for _, item in pairs((Config and Config.items) or {}) do
local states = item.states
if typeof(states) == "table" then
for name, state in pairs(states) do
if typeof(state) == "table" and not originalStates[state] then
stateTables[#stateTables + 1] = state
originalStates[state] = { walkspeed = state.walkspeed, fov = state.fov }
end
if name == "aim" and typeof(states.idle) == "table" then
idleSpeedForAimState[state] = states.idle.walkspeed
end
end
end
end
local function applyStates()
for _, state in ipairs(stateTables) do
local saved = originalStates[state]
unlock(state)
if saved.fov then
state.fov = math.clamp(saved.fov + KH.extraFov, 10, 120)
end
local idleSpeed = idleSpeedForAimState[state]
if saved.walkspeed then
state.walkspeed = (KH.noAdsSlow and idleSpeed) or saved.walkspeed
end
end
end
local hitSound = Instance.new("Sound")
hitSound.SoundId = "rbxassetid://6042053626"
hitSound.Volume = 1
hitSound.Parent = SoundService
local packetMeta, originalFire
if NetLib then
local ok, packet = pcall(NetLib, "event.lookvector", NetLib.NumberF16)
if ok and typeof(packet) == "table" then
packetMeta = getmetatable(packet)
end
end
if typeof(packetMeta) == "table" and typeof(packetMeta.Fire) == "function" then
originalFire = packetMeta.Fire
unlock(packetMeta)
packetMeta.Fire = function(self, ...)
if self.Name == "hitServer" then
if KH.hitmarker then
KH.hitUntil = os.clock() + 0.12
hitSound.TimePosition = 0
hitSound:Play()
end
if KH.forceHead then
local args = table.pack(...)
local part = args[2]
if typeof(part) == "Instance" and part.Parent then
local head = part.Parent:FindFirstChild("Head")
if head then
args[2] = head
return originalFire(self, table.unpack(args, 1, args.n))
end
end
end
elseif KH.grenadeAim and self.Name == "throwServer" then
local args = table.pack(...)
if typeof(args[1]) == "string" and typeof(args[2]) == "Vector3" and typeof(args[3]) == "Vector3" then
local target = pickTarget()
if target then
args[3] = (target.Position - args[2]).Unit
return originalFire(self, table.unpack(args, 1, args.n))
end
else
local shape = {}
for index = 1, args.n do
shape[index] = typeof(args[index])
end
KH.lastThrowShape = table.concat(shape, ", ")
end
end
return originalFire(self, ...)
end
end
local lightingDefaults = {
Brightness = Lighting.Brightness,
ClockTime = Lighting.ClockTime,
Ambient = Lighting.Ambient,
OutdoorAmbient = Lighting.OutdoorAmbient,
GlobalShadows = Lighting.GlobalShadows,
}
local function applyFullbright(enabled)
if enabled then
Lighting.Brightness = 3
Lighting.ClockTime = 13
Lighting.Ambient = Color3.new(1, 1, 1)
Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
Lighting.GlobalShadows = false
return
end
for property, value in pairs(lightingDefaults) do
Lighting[property] = value
end
end
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local damageEffect = Lighting:FindFirstChild("damage")
local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
local atmosphereDefaults = atmosphere
and { Density = atmosphere.Density, Haze = atmosphere.Haze, Glare = atmosphere.Glare }
or nil
local VIGNETTE_NAMES = { aim = true, vingette = true, ["vingette-stable"] = true }
local function applyClearVision()
local enabled = KH.clearVision
local blood = playerGui:FindFirstChild("blood")
local splatter = blood and blood:FindFirstChild("main")
if splatter then
splatter.Visible = not enabled
end
if damageEffect then
damageEffect.Enabled = not enabled
end
for _, gui in ipairs(playerGui:GetChildren()) do
if gui:IsA("ScreenGui") and VIGNETTE_NAMES[gui.Name] then
gui.Enabled = not enabled
end
end
if atmosphere then
atmosphere.Density = enabled and 0 or atmosphereDefaults.Density
atmosphere.Haze = enabled and 0 or atmosphereDefaults.Haze
atmosphere.Glare = enabled and 0 or atmosphereDefaults.Glare
end
end
table.insert(KH.connections, playerGui.ChildAdded:Connect(function(child)
if KH.clearVision and child:IsA("ScreenGui") and VIGNETTE_NAMES[child.Name] then
task.defer(applyClearVision)
end
end))
local ENEMY_COLOR = Color3.fromRGB(255, 70, 70)
local FRIENDLY_COLOR = Color3.fromRGB(90, 220, 120)
local DRONE_COLOR = Color3.fromRGB(255, 190, 60)
local espPool = {}
local function newDrawing(class, setup)
local object = Drawing.new(class)
object.Visible = false
setup(object)
return object
end
local function newBox()
return newDrawing("Square", function(object)
object.Thickness = 1
object.Filled = false
object.Transparency = 1
end)
end
local function newLabel()
return newDrawing("Text", function(object)
object.Size = 13
object.Center = true
object.Outline = true
end)
end
local function espFor(player)
local set = espPool[player]
if set then return set end
set = {
box = newBox(),
name = newLabel(),
info = newLabel(),
tracer = newDrawing("Line", function(object)
object.Thickness = 1
object.Transparency = 1
end),
}
set.highlight = Instance.new("Highlight")
set.highlight.FillTransparency = 0.65
set.highlight.OutlineTransparency = 0
set.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
set.highlight.Enabled = false
espPool[player] = set
return set
end
local function hideEsp(set)
for key, object in pairs(set) do
if key == "highlight" then
object.Enabled = false
else
object.Visible = false
end
end
end
local function releaseEsp(player)
local set = espPool[player]
if not set then return end
for key, object in pairs(set) do
if key == "highlight" then
pcall(function() object:Destroy() end)
else
pcall(function() object:Remove() end)
end
end
espPool[player] = nil
end
local function boxOnScreen(camera, model)
local ok, pivot, extents = pcall(function()
return model:GetBoundingBox()
end)
if not ok then return nil end
local half = extents / 2
local minX, minY = math.huge, math.huge
local maxX, maxY = -math.huge, -math.huge
local anyVisible = false
local anyInFront = false
for x = -1, 1, 2 do
for y = -1, 1, 2 do
for z = -1, 1, 2 do
local corner = pivot * CFrame.new(half.X * x, half.Y * y, half.Z * z)
local screen, onScreen = camera:WorldToViewportPoint(corner.Position)
if screen.Z > 0 then
anyInFront = true
if onScreen then anyVisible = true end
minX, maxX = math.min(minX, screen.X), math.max(maxX, screen.X)
minY, maxY = math.min(minY, screen.Y), math.max(maxY, screen.Y)
end
end
end
end
if not (anyVisible and anyInFront) then return nil end
return minX, minY, maxX - minX, maxY - minY
end
local function updateEsp(camera, origin, viewport)
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
local character = player.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
local enemy = isEnemy(player)
local show = KH.esp
and root
and humanoid
and humanoid.Health > 0
and (enemy or KH.espTeammates)
local distance = root and (root.Position - origin).Magnitude or math.huge
if show and distance > KH.espDistanceLimit then
show = false
end
if not show then
if espPool[player] then hideEsp(espPool[player]) end
else
local x, y, width, height = boxOnScreen(camera, character)
local set = espFor(player)
if not x then
hideEsp(set)
else
local color = enemy and ENEMY_COLOR or FRIENDLY_COLOR
set.highlight.Enabled = KH.espChams
if KH.espChams then
set.highlight.FillColor = color
set.highlight.OutlineColor = color
if set.highlight.Adornee ~= character then
set.highlight.Adornee = character
set.highlight.Parent = character
end
end
set.box.Visible = KH.espBox
set.box.Position = Vector2.new(x, y)
set.box.Size = Vector2.new(width, height)
set.box.Color = color
local title = player.DisplayName
if KH.espWeapon then
local weapon = equippedName(player)
if weapon then
title = title .. "  [" .. weapon .. "]"
end
end
set.name.Visible = KH.espName
set.name.Position = Vector2.new(x + width / 2, y - 16)
set.name.Text = title
set.name.Color = color
local details = {}
if KH.espHealth then
table.insert(details, ("%d HP"):format(math.floor(humanoid.Health)))
end
if KH.espDistance then
table.insert(details, ("%dm"):format(math.floor(distance)))
end
set.info.Visible = #details > 0
set.info.Position = Vector2.new(x + width / 2, y + height + 2)
set.info.Text = table.concat(details, "  ")
set.info.Color = color
set.tracer.Visible = KH.espTracer
set.tracer.From = Vector2.new(viewport.X / 2, viewport.Y)
set.tracer.To = Vector2.new(x + width / 2, y + height)
set.tracer.Color = color
end
end
end
end
end
local droneMarkers = {}
local function droneMarker(index)
local set = droneMarkers[index]
if set then return set end
set = { box = newBox(), label = newLabel() }
droneMarkers[index] = set
return set
end
local function droneModels()
local models = {}
local placeables = workspace:FindFirstChild("placeables")
if placeables then
for _, model in ipairs(placeables:GetChildren()) do
models[#models + 1] = model
end
end
local container = workspace:FindFirstChild(DRONE_CONTAINER_ID)
if container then
for _, model in ipairs(container:GetChildren()) do
models[#models + 1] = model
end
end
return models
end
local function updateDroneEsp(camera, origin)
local used = 0
if KH.esp and KH.espDrones then
for _, model in ipairs(droneModels()) do
if model:IsA("Model") and model:FindFirstChildWhichIsA("BasePart", true) then
local ownerId = tonumber(string.match(model.Name, "^(%d+)"))
local owner = ownerId and Players:GetPlayerByUserId(ownerId)
local enemy = (owner == nil) or isEnemy(owner)
if (enemy or KH.espTeammates) and owner ~= LocalPlayer then
local distance = (model:GetPivot().Position - origin).Magnitude
if distance <= KH.espDistanceLimit then
local x, y, width, height = boxOnScreen(camera, model)
if x then
used = used + 1
local set = droneMarker(used)
local color = enemy and DRONE_COLOR or FRIENDLY_COLOR
set.box.Visible = KH.espBox
set.box.Position = Vector2.new(x, y)
set.box.Size = Vector2.new(width, height)
set.box.Color = color
set.label.Visible = true
set.label.Position = Vector2.new(x + width / 2, y - 16)
set.label.Text = ("Drone %s  %dm"):format(owner and owner.DisplayName or "?", math.floor(distance))
set.label.Color = color
end
end
end
end
end
end
for index = used + 1, #droneMarkers do
droneMarkers[index].box.Visible = false
droneMarkers[index].label.Visible = false
end
end
table.insert(KH.connections, Players.PlayerRemoving:Connect(releaseEsp))
local circle = Drawing.new("Circle")
circle.Thickness = 1
circle.NumSides = 64
circle.Filled = false
circle.Transparency = 1
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Visible = false
local MARKER_CORNERS = {
Vector2.new(1, 1),
Vector2.new(-1, 1),
Vector2.new(1, -1),
Vector2.new(-1, -1),
}
local markerLines = {}
for index = 1, 4 do
markerLines[index] = newDrawing("Line", function(object)
object.Thickness = 2
object.Transparency = 1
object.Color = Color3.fromRGB(255, 255, 255)
end)
end
local function updateHitMarker()
if not (KH.hitmarker and os.clock() < KH.hitUntil) then
for _, line in ipairs(markerLines) do
line.Visible = false
end
return
end
local mouse = UserInputService:GetMouseLocation()
for index, line in ipairs(markerLines) do
local corner = MARKER_CORNERS[index]
line.From = mouse + corner * 4
line.To = mouse + corner * 11
line.Visible = true
end
end
local autoShooting = false
local function updateAutoShoot(hasTarget)
local weapon = KH.weapon
if not (KH.autoShoot and weapon) then
if autoShooting then
autoShooting = false
pcall(function() weapon:input("fire", Enum.UserInputState.End) end)
end
return
end
if hasTarget and not autoShooting then
autoShooting = true
pcall(function() weapon:input("fire", Enum.UserInputState.Begin) end)
elseif not hasTarget and autoShooting then
autoShooting = false
pcall(function() weapon:input("fire", Enum.UserInputState.End) end)
end
end
table.insert(KH.connections, RunService.RenderStepped:Connect(function()
if KH.autoShoot then
updateAutoShoot(pickTarget() ~= nil)
elseif autoShooting then
updateAutoShoot(false)
end
if KH.autoReload and KH.weapon then
local weapon = KH.weapon
local magazine = weapon.magazines and weapon.magazines[weapon.equippedMagazine]
if magazine and magazine.rounds ~= nil and magazine.rounds <= 0 and not weapon.reloading then
pcall(function() weapon:reload() end)
end
end
if KH.enabled and KH.showCircle then
local mouse = UserInputService:GetMouseLocation()
circle.Position = Vector2.new(mouse.X, mouse.Y)
circle.Radius = KH.fov
circle.Color = KH.locked and ENEMY_COLOR or Color3.fromRGB(255, 255, 255)
circle.Visible = true
KH.locked = nil
else
circle.Visible = false
end
updateHitMarker()
local camera = currentCamera()
local origin = camera.CFrame.Position
local ok, err = pcall(function()
updateEsp(camera, origin, camera.ViewportSize)
updateDroneEsp(camera, origin)
end)
if not ok then
warn("[Kali Hub] ESP error: " .. tostring(err))
end
end))
function KH.unload()
KH.enabled = false
KH.esp = false
KH.autoShoot = false
KH.autoReload = false
KH.forceHead = false
KH.grenadeAim = false
KH.hitmarker = false
KH.fastReload = false
if autoShooting and KH.weapon then
autoShooting = false
pcall(function() KH.weapon:input("fire", Enum.UserInputState.End) end)
end
for _, connection in ipairs(KH.connections) do
pcall(function() connection:Disconnect() end)
end
table.clear(KH.connections)
pcall(function() RunService:UnbindFromRenderStep("KaliHubCursor") end)
if KH.menuOpen then
KH.menuOpen = false
UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end
BulletVM.calculateDirection = originalDirection
if WeaponClass and originalInput then
WeaponClass.input = originalInput
end
if WeaponClass and originalReload then
WeaponClass.reload = originalReload
end
if packetMeta and originalFire then
packetMeta.Fire = originalFire
end
KH.noDrop, KH.bulletSpeed, KH.extraRange = false, 0, 0
KH.noAdsSlow, KH.extraFov = false, 0
KH.clearVision = false
applyBallistics()
applyStates()
applyNoRecoil(false)
applyNoMuzzle(false)
applyFullAuto(false)
applyFullbright(false)
applyClearVision()
pcall(function() circle:Remove() end)
pcall(function() hitSound:Destroy() end)
for _, line in ipairs(markerLines) do
pcall(function() line:Remove() end)
end
for _, set in ipairs(droneMarkers) do
pcall(function() set.box:Remove() end)
pcall(function() set.label:Remove() end)
end
table.clear(droneMarkers)
for player in pairs(espPool) do
releaseEsp(player)
end
getgenv().KaliHubLostFront = nil
end
gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 150,
MaxHeight = 600,
InitialHeight = 460,
MinWidth = 350,
MaxWidth = 800,
InitialWidth = 560,
}
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local existingGuis = {}
for _, child in ipairs(playerGui:GetChildren()) do
existingGuis[child] = true
end
local window = library:CreateWindow(getfenv().gui_config, playerGui)
local MENU_DISPLAY_ORDER = 2000000000
local menuFrames = {}
for _, child in ipairs(playerGui:GetChildren()) do
if not existingGuis[child] and child:IsA("ScreenGui") then
child.ResetOnSpawn = false
child.DisplayOrder = MENU_DISPLAY_ORDER
child.OnTopOfCoreBlur = true
local main = child:FindFirstChild("Main")
if main and main:IsA("GuiObject") then
menuFrames[#menuFrames + 1] = main
end
end
end
local mouseDefaults = {
sensitivity = UserInputService.MouseDeltaSensitivity,
icon = UserInputService.MouseIconEnabled,
}
local function menuIsOpen()
for _, frame in ipairs(menuFrames) do
if frame.Visible then return true end
end
return false
end
RunService:BindToRenderStep("KaliHubCursor", Enum.RenderPriority.Last.Value, function()
local open = menuIsOpen()
if open then
UserInputService.MouseBehavior = Enum.MouseBehavior.Default
UserInputService.MouseIconEnabled = true
UserInputService.MouseDeltaSensitivity = 0
elseif KH.menuOpen then
UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
UserInputService.MouseIconEnabled = mouseDefaults.icon
UserInputService.MouseDeltaSensitivity = mouseDefaults.sensitivity
end
KH.menuOpen = open
end)
library:SetWindowName("Kali Hub | The Lost Front")
local mainTab = window:CreateTab("Main")
local aimSection = mainTab:CreateSection("Silent Aim", "left")
local fovSection = mainTab:CreateSection("Field of View", "right")
local modSection = mainTab:CreateSection("Gun Mods", "left")
local ballisticsSection = mainTab:CreateSection("Ballistics", "right")
local visualSection = mainTab:CreateSection("Visuals", "left")
local espSection = mainTab:CreateSection("ESP", "right")
local espDetailSection = mainTab:CreateSection("ESP Details", "right")
local scriptSection = mainTab:CreateSection("Script", "left")
aimSection:CreateToggle("Silent Aim", false, function(value)
KH.enabled = value
end):CreateKeybind("E", function() end, "Toggle")
aimSection:CreateToggle("Auto Shoot", false, function(value)
KH.autoShoot = value
end):CreateKeybind("V", function() end, "Hold")
aimSection:CreateToggle("Force Headshot", false, function(value)
KH.forceHead = value
end)
aimSection:CreateToggle("Bullet Prediction", true, function(value)
KH.prediction = value
end)
aimSection:CreateToggle("Grenade Aim", false, function(value)
KH.grenadeAim = value
end)
aimSection:CreateDropdown("Target Part", { "Head", "Torso", "HumanoidRootPart" }, function(value)
KH.targetPart = value
end, "Head")
aimSection:CreateToggle("Visible Check", true, function(value)
KH.visibleCheck = value
end)
fovSection:CreateSlider("FOV Radius", 20, 600, 120, true, function(value)
KH.fov = value
end)
fovSection:CreateToggle("Show FOV Circle", true, function(value)
KH.showCircle = value
end)
modSection:CreateToggle("No Recoil", false, function(value)
KH.noRecoil = value
applyNoRecoil(value)
end)
modSection:CreateToggle("Full Auto", false, function(value)
KH.fullAuto = value
applyFullAuto(value)
end)
modSection:CreateToggle("Auto Reload", false, function(value)
KH.autoReload = value
end)
modSection:CreateToggle("Fast Reload", false, function(value)
KH.fastReload = value
end)
modSection:CreateSlider("Reload Speed %", 100, 400, 250, true, function(value)
KH.reloadSpeed = value / 100
end)
modSection:CreateToggle("No ADS Slowdown", false, function(value)
KH.noAdsSlow = value
applyStates()
end)
modSection:CreateSlider("FOV Offset", -30, 40, 0, true, function(value)
KH.extraFov = value
applyStates()
end)
ballisticsSection:CreateToggle("No Bullet Drop", false, function(value)
KH.noDrop = value
applyBallistics()
end)
ballisticsSection:CreateSlider("Extra Bullet Speed", 0, 4000, 0, true, function(value)
KH.bulletSpeed = value
applyBallistics()
end)
ballisticsSection:CreateSlider("Extra Range", 0, 4000, 0, true, function(value)
KH.extraRange = value
applyBallistics()
end)
visualSection:CreateToggle("Hitmarker", false, function(value)
KH.hitmarker = value
end)
visualSection:CreateToggle("Fullbright", false, function(value)
KH.fullbright = value
applyFullbright(value)
end)
visualSection:CreateToggle("Clear Vision", false, function(value)
KH.clearVision = value
applyClearVision()
end)
visualSection:CreateToggle("No Muzzle Flash", false, function(value)
KH.noMuzzle = value
applyNoMuzzle(value)
end)
espSection:CreateToggle("Enable ESP", false, function(value)
KH.esp = value
end):CreateKeybind("B", function() end, "Toggle")
espSection:CreateToggle("Boxes", true, function(value)
KH.espBox = value
end)
espSection:CreateToggle("Names", true, function(value)
KH.espName = value
end)
espSection:CreateToggle("Chams", false, function(value)
KH.espChams = value
end)
espSection:CreateToggle("Tracers", false, function(value)
KH.espTracer = value
end)
espSection:CreateToggle("Drones", false, function(value)
KH.espDrones = value
end)
espDetailSection:CreateToggle("Health", true, function(value)
KH.espHealth = value
end)
espDetailSection:CreateToggle("Distance", true, function(value)
KH.espDistance = value
end)
espDetailSection:CreateToggle("Weapon", false, function(value)
KH.espWeapon = value
end)
espDetailSection:CreateToggle("Show Teammates", false, function(value)
KH.espTeammates = value
end)
espDetailSection:CreateSlider("Max Distance", 100, 2000, 1200, true, function(value)
KH.espDistanceLimit = value
end)
scriptSection:CreateButton("Unload", function()
KH.unload()
window:Notify("Kali Hub", "Unloaded, the menu stays until you rejoin", 4)
end)
local configTab = window:CreateTab("Config")
local configManager = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
configManager:SetLibrary(library)
configManager:SetWindow(window)
configManager:SetFolder("Kali Hub")
configManager:BuildConfigSection(configTab)
configManager:LoadAutoloadConfig()
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
window:Notify("Kali Hub", "The Lost Front loaded", 4)
