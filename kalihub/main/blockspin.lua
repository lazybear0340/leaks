--this shit was unobfuscated


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer
if getgenv and getgenv()._KaliHubBlockSpin then
pcall(getgenv()._KaliHubBlockSpin)
getgenv()._KaliHubBlockSpin = nil
end
local Net, Gun, Melee, Throwable, Sprint, Ragdoll, Vehicle, Crate, SliderMinigame
local ATM, Janitor, Steakhouse, ItemUtils, Data, JobBeacon, ProgressBar
if not pcall(function()
local Modules = ReplicatedStorage:WaitForChild("Modules", 15)
Net = require(Modules.Core.Net)
Gun = require(Modules.Game.ItemTypes.Gun)
Melee = require(Modules.Game.ItemTypes.Melee)
Throwable = require(Modules.Game.ItemTypes.Throwable)
Sprint = require(Modules.Game.Sprint)
Ragdoll = require(Modules.Game.Ragdoll)
Vehicle = require(Modules.Game.VehicleSystem.Vehicle)
Crate = require(Modules.Game.CrateSystem.Crate)
SliderMinigame = require(Modules.Game.Minigames.SliderMinigame)
ATM = require(Modules.Game.ATM.ATM)
Janitor = require(Modules.Game.Jobs.Janitor)
Steakhouse = require(Modules.Game.Jobs.SteakhouseCook)
ItemUtils = require(Modules.Game.Inventory.ItemUtils)
Data = require(Modules.Core.Data)
JobBeacon = require(Modules.Game.Jobs.JobApplicationBeacon)
ProgressBar = require(Modules.Game.UI.ProgressBar)
end) or type(Net) ~= "table" or type(Net.send) ~= "function" or type(Melee) ~= "table" then
return
end
gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 150,
MaxHeight = 600,
InitialHeight = 480,
MinWidth = 350,
MaxWidth = 800,
InitialWidth = 560,
}
local library
if not pcall(function()
library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
end) or not library then
return
end
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local guisBefore = {}
for _, gui in ipairs(playerGui:GetChildren()) do
guisBefore[gui] = true
end
local window
if not pcall(function()
window = library:CreateWindow(getfenv().gui_config or gui_config, playerGui)
library:SetWindowName("Kali Hub | Block Spin")
end) or not window then
return
end
for _, gui in ipairs(playerGui:GetChildren()) do
if not guisBefore[gui] and gui:IsA("ScreenGui") then
gui.ResetOnSpawn = false
end
end
local Config = {
SilentAim = {
Enabled = false,
Prediction = false,
HitChance = 100,
},
Targeting = {
UseFOV = true,
FOVRadius = 200,
ClosestPlayer = false,
MaxRange = true,
Range = 150,
UseBodyPart = true,
BodyPart = "Head",
VisibilityCheck = true,
TeamCheck = true,
FriendCheck = true,
IgnoreDowned = true,
IgnoreForcefield = true,
UseWhitelist = false,
FromCrosshair = true,
},
Aimbot = {
Enabled = false,
Smoothness = 5,
},
Player = {
SpeedBoost = false,
BoostAmount = 1,
NoSlowdown = false,
InfiniteStamina = false,
AutoRespawn = false,
AntiDeath = false,
FlyJump = false,
JumpVelocity = 50,
AutoHeal = false,
HealHealth = 50,
},
AntiEffects = {
NoRagdoll = false,
NoShellShock = false,
NoSmokeScreen = false,
},
GunMods = {
NoSpread = false,
NoRecoil = false,
RecoilPercent = 0,
Accuracy = false,
AccuracyValue = 1,
ReloadTime = false,
ReloadSpeed = 0.5,
Automatic = false,
},
Vehicle = {
Enabled = false,
ModifySpeed = false,
SpeedMultiplier = 1.25,
ModifyAcceleration = false,
AccelMultiplier = 1.25,
InstantBrake = false,
NoCrashDamage = false,
},
Autofarms = {
ATM = false,
TravelMethod = "Pathfinding",
HackTool = "Auto (Best Available)",
ToolsToBuy = 1,
Deposit = false,
BurgerJob = false,
SteakHouse = false,
ShelfJob = false,
Dumpsters = false,
Fish = false,
BuyBait = true,
BaitAmount = 5,
SellFish = true,
FishToSell = 15,
Airdrop = false,
},
Misc = {
SkipCrateAnimation = false,
FasterPrompts = false,
AutoMinigame = false,
AutoPickup = false,
PickupItems = true,
PickupRange = 10,
},
Melee = {
KillAura = false,
AuraRange = 15,
AuraSpeed = 5,
RangeExpander = false,
HitAllInRange = false,
RangeMultiplier = 1,
ConeMultiplier = 1,
ThrowableAura = false,
ThrowRange = 20,
},
Visuals = {
FOVCircle = false,
TargetLine = false,
PathPreview = true,
},
WorldESP = {
Enabled = false,
Items = true,
Money = true,
Dumpsters = false,
Airdrops = true,
ATMs = false,
Crates = false,
Range = 300,
},
ESP = {
Enabled = false,
Boxes = false,
Boxes3D = false,
BoxFill = false,
HealthBar = false,
HealthText = false,
HealthOutline = false,
Names = false,
Weapons = false,
Distance = false,
Tracers = false,
Arrows = false,
Chams = false,
},
BulletTracers = {
Enabled = false,
Width = 0.1,
Lifetime = 1,
},
Colors = {
FOV = Color3.fromRGB(255, 255, 255),
TargetLine = Color3.fromRGB(255, 65, 65),
},
}
local cleanupTasks = {}
local TARGET_PARTS = { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "Random" }
local RANDOM_PARTS = { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart" }
local whitelisted = {}
local friendCache = {}
local function isFriend(player)
local cached = friendCache[player.UserId]
if cached ~= nil then
return cached
end
friendCache[player.UserId] = false
task.spawn(function()
local ok, result = pcall(function()
return LocalPlayer:IsFriendsWith(player.UserId)
end)
friendCache[player.UserId] = ok and result or false
end)
return false
end
Players.PlayerRemoving:Connect(function(player)
friendCache[player.UserId] = nil
end)
local function sameGang(player)
local gang = LocalPlayer:GetAttribute("CurrentGangId")
return gang ~= nil and player:GetAttribute("CurrentGangId") == gang
end
local function livingCharacter(player, includeDowned)
local character = player.Character
if not character or not character.Parent then
return nil
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health <= 0 or humanoid:GetAttribute("IsDead") then
return nil
end
if not includeDowned and Config.Targeting.IgnoreDowned
and (humanoid:GetAttribute("HasBeenDowned") or humanoid:GetAttribute("PickedUpBy")) then
return nil
end
return character, humanoid
end
local function isProtected(player)
if player:GetAttribute("IsSafeZoneProtected") or player:GetAttribute("IsInSafeZone") then
return true
end
local character = player.Character
if not character then
return false
end
return character:GetAttribute("IsSpawnProtected") == true or character:FindFirstChildOfClass("ForceField") ~= nil
end
local function isTargetable(player)
local targeting = Config.Targeting
if player == LocalPlayer then
return false
end
if targeting.UseWhitelist and whitelisted[player.Name] then
return false
end
if targeting.IgnoreForcefield and isProtected(player) then
return false
end
if targeting.TeamCheck and sameGang(player) then
return false
end
if targeting.FriendCheck and isFriend(player) then
return false
end
return true
end
local visibilityParams = RaycastParams.new()
visibilityParams.FilterType = Enum.RaycastFilterType.Exclude
visibilityParams.IgnoreWater = true
local function isVisible(character, position)
local origin = Workspace.CurrentCamera.CFrame.Position
visibilityParams.FilterDescendantsInstances = { character, LocalPlayer.Character }
return Workspace:Raycast(origin, position - origin, visibilityParams) == nil
end
local function cursorPoint()
if Config.Targeting.FromCrosshair then
local viewport = Workspace.CurrentCamera.ViewportSize
local inset = GuiService:GetGuiInset()
return Vector2.new(viewport.X * 0.5 + inset.X, viewport.Y * 0.5 + inset.Y)
end
return UserInputService:GetMouseLocation()
end
local function screenPoint(position)
local point, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(position)
if not onScreen then
return nil
end
local inset = GuiService:GetGuiInset()
return Vector2.new(point.X + inset.X, point.Y + inset.Y)
end
local function screenOffset(position)
local point = screenPoint(position)
return point and (point - cursorPoint()).Magnitude or nil
end
local function resolvePart(character)
local wanted = Config.Targeting.UseBodyPart and Config.Targeting.BodyPart or "Head"
if wanted == "Random" then
wanted = RANDOM_PARTS[math.random(#RANDOM_PARTS)]
end
return character:FindFirstChild(wanted) or character:FindFirstChild("HumanoidRootPart")
end
local function resolvePosition(character, part)
if not Config.SilentAim.Prediction then
return part.Position
end
local root = character:FindFirstChild("HumanoidRootPart")
local velocity = root and root.AssemblyLinearVelocity or Vector3.zero
return part.Position + velocity * (LocalPlayer:GetAttribute("ServerPing") or 0)
end
local function selectTarget()
local targeting = Config.Targeting
local origin = Workspace.CurrentCamera.CFrame.Position
local maxRange = targeting.MaxRange and targeting.Range or math.huge
local best, bestScore
for _, player in ipairs(Players:GetPlayers()) do
if isTargetable(player) then
local character = livingCharacter(player)
local part = character and resolvePart(character)
if part then
local position = resolvePosition(character, part)
local distance = (position - origin).Magnitude
local offset = distance <= maxRange and screenOffset(position) or nil
local inFOV = offset and (not targeting.UseFOV or offset <= targeting.FOVRadius)
if inFOV and (not targeting.VisibilityCheck or isVisible(character, position)) then
local score = targeting.ClosestPlayer and distance or offset
if not bestScore or score < bestScore then
bestScore = score
best = { Part = part, Position = position }
end
end
end
end
end
return best
end
local function localRoot()
local character = LocalPlayer.Character
return character and character:FindFirstChild("HumanoidRootPart")
end
local function targetRootOf(player)
local character = livingCharacter(player)
return character and character:FindFirstChild("HumanoidRootPart")
end
local function closestPlayerWithin(radius)
local root = localRoot()
if not root then
return nil
end
local best, bestDistance
for _, player in ipairs(Players:GetPlayers()) do
if isTargetable(player) then
local targetRoot = targetRootOf(player)
local distance = targetRoot and (targetRoot.Position - root.Position).Magnitude
if distance and distance <= radius and (not bestDistance or distance < bestDistance) then
bestDistance = distance
best = player
end
end
end
return best
end
local GUN_STATES = { "accuracy", "reload_time", "automatic" }
local hashedNames = {}
local function hashedAttribute(name)
if hashedNames[name] then
return hashedNames[name]
end
local key = Workspace:GetAttribute("HashKey")
if not key then
return nil
end
local hash = 5381
for index = 1, #name do
hash = (hash * 33 + string.byte(name, index)) % 4294967296
end
hashedNames[name] = key .. tostring(hash)
return hashedNames[name]
end
local function gunAttributeName(tool, name)
if tool:GetAttribute(name) ~= nil then
return name
end
return hashedAttribute(name) or name
end
local function gunStateValue(tool, name)
local object = Gun.class.find(tool)
if object then
return object.states[name].get()
end
return tool:GetAttribute(gunAttributeName(tool, name))
end
local function setGunState(tool, name, value)
local object = Gun.class.find(tool)
if object then
object.states[name].set(value)
else
tool:SetAttribute(gunAttributeName(tool, name), value)
end
end
local function gunTools()
local tools = {}
for _, container in ipairs({ LocalPlayer:FindFirstChildOfClass("Backpack"), LocalPlayer.Character }) do
if container then
for _, item in ipairs(container:GetChildren()) do
if item:IsA("Tool") and item:HasTag("Gun") then
table.insert(tools, item)
end
end
end
end
return tools
end
local function moddedGunValues()
local mods = Config.GunMods
local values = {}
if mods.NoSpread then
values.accuracy = 1
elseif mods.Accuracy then
values.accuracy = mods.AccuracyValue
end
if mods.ReloadTime then
values.reload_time = mods.ReloadSpeed
end
if mods.Automatic then
values.automatic = true
end
return values
end
local gunOriginals = setmetatable({}, { __mode = "k" })
local function gunModsActive()
local mods = Config.GunMods
return mods.NoSpread or mods.NoRecoil or mods.Accuracy or mods.ReloadTime or mods.Automatic
end
local function applyGunMods()
local values = moddedGunValues()
for _, tool in ipairs(gunTools()) do
local original = gunOriginals[tool]
if not original then
original = {}
gunOriginals[tool] = original
end
if original.Recoil == nil then
original.Recoil = tool:GetAttribute("Recoil")
end
for _, name in ipairs(GUN_STATES) do
if original[name] == nil then
original[name] = gunStateValue(tool, name)
end
end
for _, name in ipairs(GUN_STATES) do
local wanted = values[name]
if wanted == nil then
wanted = original[name]
end
if wanted ~= nil and wanted ~= gunStateValue(tool, name) then
setGunState(tool, name, wanted)
end
end
if original.Recoil ~= nil then
local recoil = original.Recoil
if Config.GunMods.NoRecoil then
recoil = original.Recoil * Config.GunMods.RecoilPercent / 100
end
if tool:GetAttribute("Recoil") ~= recoil then
tool:SetAttribute("Recoil", recoil)
end
end
end
end
local function meleeAssistActive()
return Config.Melee.RangeExpander
end
local function playersWithin(radius)
local root = localRoot()
if not root then
return {}
end
local origin = root.Position
local found = {}
for _, player in ipairs(Players:GetPlayers()) do
if isTargetable(player) then
local targetRoot = targetRootOf(player)
if targetRoot and (targetRoot.Position - origin).Magnitude <= radius then
table.insert(found, player)
end
end
end
return found
end
local realGetHitPlayers = Melee.get_hit_players
local function meleeHitList(object)
local melee = Config.Melee
local root = localRoot()
if not meleeAssistActive() or not root or not object then
return realGetHitPlayers(object)
end
local range = object.states.range.get()
local cone = object.states.cone_angle.get()
range = range * melee.RangeMultiplier
cone = melee.HitAllInRange and 180 or math.min(cone * melee.ConeMultiplier, 180)
local origin = root.Position
local look = root.CFrame.LookVector
local limit = math.rad(cone)
local hit = {}
for _, player in ipairs(Players:GetPlayers()) do
if isTargetable(player) then
local targetRoot = targetRootOf(player)
if targetRoot then
local offset = targetRoot.Position - origin
local distance = offset.Magnitude
if distance > 0 and distance <= range and math.acos(math.clamp(look:Dot(offset.Unit), -1, 1)) <= limit then
table.insert(hit, player)
end
end
end
end
table.sort(hit, function(a, b)
local rootA, rootB = targetRootOf(a), targetRootOf(b)
if not rootA or not rootB then
return rootA ~= nil
end
return (rootA.Position - origin).Magnitude < (rootB.Position - origin).Magnitude
end)
return hit
end
Melee.get_hit_players = meleeHitList
local function facingCFrame(origin, player)
local targetRoot = targetRootOf(player)
if not targetRoot then
return nil
end
local flat = Vector3.new(targetRoot.Position.X, origin.Position.Y, targetRoot.Position.Z)
if (flat - origin.Position).Magnitude < 0.05 then
return nil
end
return CFrame.lookAt(origin.Position, flat)
end
local realSend = Net.send
local function rewriteShot(packed)
local target = selectTarget()
if not target then
return false
end
local hits = packed[3]
local rebuilt = table.create(#hits)
for index = 1, #hits do
rebuilt[index] = { { Instance = target.Part, Position = target.Position, Normal = Vector3.zero } }
end
packed[2] = CFrame.lookAt(packed[2].Position, target.Position)
packed[3] = rebuilt
return true
end
local function interceptSend(action, ...)
if action == "shoot_gun" and Config.SilentAim.Enabled then
local packed = table.pack(...)
if typeof(packed[2]) ~= "CFrame" or type(packed[3]) ~= "table" or #packed[3] == 0 then
return action, ...
end
if math.random(100) > Config.SilentAim.HitChance then
return action, ...
end
local ok, rewritten = pcall(rewriteShot, packed)
if ok and rewritten then
return action, table.unpack(packed, 1, packed.n)
end
elseif action == "melee_attack" and meleeAssistActive() then
local packed = table.pack(...)
if type(packed[2]) == "table" and #packed[2] > 0 and typeof(packed[3]) == "CFrame" then
local ok, faced = pcall(facingCFrame, packed[3], packed[2][1])
if ok and faced then
packed[3] = faced
return action, table.unpack(packed, 1, packed.n)
end
end
end
return action, ...
end
local blockedAction
do
local FLAG_ACTIONS = {
invalid_entry = true,
suspicious_logs = true,
bad_assets = true,
}
blockedAction = function(action)
if FLAG_ACTIONS[action] then
return true
end
return action == "crashed_car" and Config.Vehicle.Enabled and Config.Vehicle.NoCrashDamage
end
end
local sendHook = function(action, ...)
if blockedAction(action) then
return
end
return realSend(interceptSend(action, ...))
end
local realGet = Net.get
local getHook = function(...)
return realGet(...)
end
local EFFECT_HOOKS = {
NoRagdoll = { "apply_ragdoll", "apply_ragdoll_force" },
NoShellShock = { "explosion", "fire_cracker_explosion", "firework_explosion" },
NoSmokeScreen = { "area_fire" },
}
local hookTable
for index = 1, 8 do
local ok, value = pcall(debug.getupvalue, Net.hook, index)
if not ok then
break
end
if type(value) == "table" and type(value.ping) == "function" then
hookTable = value
break
end
end
local blockedHooks = {}
local function setHookBlocked(action, blocked)
if not hookTable then
return
end
if blocked then
if blockedHooks[action] == nil and type(hookTable[action]) == "function" then
blockedHooks[action] = hookTable[action]
hookTable[action] = function() end
end
elseif blockedHooks[action] then
hookTable[action] = blockedHooks[action]
blockedHooks[action] = nil
end
end
local function setEffectBlocked(key, blocked)
for _, action in ipairs(EFFECT_HOOKS[key]) do
setHookBlocked(action, blocked)
end
end
local function restoreHooks()
for action in pairs(blockedHooks) do
setHookBlocked(action, false)
end
end
do
local cleanEnvironment = setmetatable({}, { __index = getrenv and getrenv() or {} })
pcall(setfenv, sendHook, cleanEnvironment)
pcall(setfenv, getHook, cleanEnvironment)
end
Net.send = sendHook
local applyAntiCheat, restoreAntiCheat
do
local SCANNER_SOURCE = "ReplicatedFirst."
local FORWARDER_NAME = "ClientBase.Logs"
local LEAK_WORDS = {
"kali", "potassium", "synapse", "krnl", "fluxus", "wave", "executor",
"getgenv", "hookfunction", "getrawmetatable", "loadstring", "exploit", "rbxdev",
}
local LogService = game:GetService("LogService")
local forwarder, muted, watcher
local function matching(predicate)
local found = {}
if not getconnections then
return found
end
local ok, list = pcall(getconnections, LogService.MessageOut)
if not ok then
return found
end
for _, connection in ipairs(list) do
local gotFn, callback = pcall(function()
return connection.Function
end)
if gotFn and type(callback) == "function" then
local gotSource, source = pcall(debug.info, callback, "s")
if gotSource and type(source) == "string" and predicate(source) then
table.insert(found, connection)
end
end
end
return found
end
local function leaks(message)
local lowered = message:lower()
for _, word in ipairs(LEAK_WORDS) do
if lowered:find(word, 1, true) then
return true
end
end
return false
end
local function startFilter()
if muted then
return
end
local channel = ReplicatedStorage:FindFirstChild("ClientLog")
if not channel then
return
end
local originals = matching(function(source)
return source:find(FORWARDER_NAME, 1, true) ~= nil
end)
if #originals == 0 then
return
end
for _, connection in ipairs(originals) do
pcall(connection.Disable, connection)
end
muted = originals
forwarder = LogService.MessageOut:Connect(function(message, messageType)
if messageType == Enum.MessageType.MessageOutput or leaks(message) then
return
end
local level = messageType == Enum.MessageType.MessageInfo and 1
or (messageType == Enum.MessageType.MessageWarning and 2 or 3)
pcall(channel.FireServer, channel, level, tick(), message)
end)
end
local function stopFilter()
if forwarder then
pcall(function()
forwarder:Disconnect()
end)
forwarder = nil
end
if muted then
for _, connection in ipairs(muted) do
pcall(connection.Enable, connection)
end
muted = nil
end
end
local function silence(signal, on)
if not getconnections then
return
end
local ok, list = pcall(getconnections, signal)
if not ok then
return
end
for _, connection in ipairs(list) do
local gotFn, callback = pcall(function()
return connection.Function
end)
if gotFn and type(callback) == "function" then
local gotSource, source = pcall(debug.info, callback, "s")
if gotSource and source == SCANNER_SOURCE then
if on then
pcall(connection.Disable, connection)
else
pcall(connection.Enable, connection)
end
end
end
end
end
local function setScanner(silenced)
silence(LogService.MessageOut, silenced)
end
local function setBodyWatch(silenced)
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not humanoid then
return
end
silence(humanoid:GetPropertyChangedSignal("WalkSpeed"), silenced)
silence(character.DescendantAdded, silenced)
silence(character.ChildAdded, silenced)
end
applyAntiCheat = function()
startFilter()
setScanner(true)
setBodyWatch(true)
end
restoreAntiCheat = function()
if watcher then
pcall(watcher.Disconnect, watcher)
watcher = nil
end
stopFilter()
setScanner(false)
setBodyWatch(false)
end
watcher = LocalPlayer.CharacterAdded:Connect(function()
task.wait(1)
pcall(applyAntiCheat)
end)
end
pcall(applyAntiCheat)
local THROW_STAMINA = 10
local THROW_COOLDOWN = 0.75
local ANTI_DEATH_HEALTH = 0.3
local ANTI_DEATH_DEPTH = 25
local ANTI_DEATH_SPEED = 18
local RESPAWN_INTERVAL = 1
local VEHICLE_MOTOR_KEYS = { "forwardMaxSpeed", "reverseMaxSpeed", "acceleration" }
local running = true
local vehicleOriginals = setmetatable({}, { __mode = "k" })
local function applyVehicleMods()
local settings = Config.Vehicle
local car = Vehicle.get_car_player_is_in(LocalPlayer)
local motors = car and car:FindFirstChild("Motors")
if not motors then
return
end
local original = vehicleOriginals[motors]
if not original then
original = {}
for _, name in ipairs(VEHICLE_MOTOR_KEYS) do
original[name] = motors:GetAttribute(name)
end
vehicleOriginals[motors] = original
end
local speed = (settings.Enabled and settings.ModifySpeed) and settings.SpeedMultiplier or 1
local acceleration = (settings.Enabled and settings.ModifyAcceleration) and settings.AccelMultiplier or 1
for _, name in ipairs(VEHICLE_MOTOR_KEYS) do
local base = original[name]
if base then
local wanted = base * (name == "acceleration" and acceleration or speed)
if motors:GetAttribute(name) ~= wanted then
motors:SetAttribute(name, wanted)
end
end
end
if not (settings.Enabled and settings.InstantBrake) then
return
end
local chassis = car:FindFirstChild("Chassis")
local inputs = car:FindFirstChild("Inputs")
if not chassis or not inputs then
return
end
local throttle = inputs:GetAttribute("throttleInput") or 0
local forward = -chassis.CFrame:VectorToObjectSpace(chassis.AssemblyLinearVelocity).Z
if inputs:GetAttribute("handBrakeInput") or (throttle < 0 and forward > 1) or (throttle > 0 and forward < -1) then
chassis.AssemblyLinearVelocity = Vector3.zero
chassis.AssemblyAngularVelocity = Vector3.zero
end
end
local function restoreVehicleMods()
for motors, original in pairs(vehicleOriginals) do
if motors.Parent then
for name, value in pairs(original) do
motors:SetAttribute(name, value)
end
end
end
table.clear(vehicleOriginals)
end
local promptOriginals = setmetatable({}, { __mode = "k" })
local function applyPrompt(prompt)
if not prompt:IsA("ProximityPrompt") then
return
end
if Config.Misc.FasterPrompts then
if promptOriginals[prompt] == nil then
promptOriginals[prompt] = prompt.HoldDuration
end
if prompt.HoldDuration ~= 0 then
prompt.HoldDuration = 0
end
elseif promptOriginals[prompt] ~= nil then
prompt.HoldDuration = promptOriginals[prompt]
promptOriginals[prompt] = nil
end
end
local function refreshPrompts()
for _, descendant in ipairs(Workspace:GetDescendants()) do
applyPrompt(descendant)
end
end
local promptConnection = Workspace.DescendantAdded:Connect(function(descendant)
if Config.Misc.FasterPrompts then
applyPrompt(descendant)
end
end)
local function autoPickup()
local dropped = Workspace:FindFirstChild("DroppedItems")
local root = localRoot()
if not dropped or not root or LocalPlayer:GetAttribute("IsInPassiveMode") then
return
end
for _, item in ipairs(dropped:GetChildren()) do
local money = item:GetAttribute("item_type") == "money"
if (money or Config.Misc.PickupItems) and not item:GetAttribute("Locked") then
local ok, pivot = pcall(item.GetPivot, item)
if ok and (pivot.Position - root.Position).Magnitude <= Config.Misc.PickupRange then
pcall(getHook, "pickup_dropped_item", item)
end
end
end
end
task.spawn(function()
while running do
task.wait(0.25)
if Config.Misc.SkipCrateAnimation and Crate.spinning.get() and not Crate.skipping.get() then
Crate.skipping.set(true)
end
local autoMinigame = Config.Misc.AutoMinigame or Config.Autofarms.ATM or Config.Autofarms.Fish
if autoMinigame and SliderMinigame.enabled.get() then
SliderMinigame.level.set(SliderMinigame.level.get() + 1)
end
if Config.Misc.AutoPickup then
pcall(autoPickup)
end
end
end)
local realSetWalkSpeed = Sprint.set_walk_speed
Sprint.set_walk_speed = function(speed, duration)
if Config.Player.NoSlowdown then
return function() end
end
return realSetWalkSpeed(speed, duration)
end
local applySpeedBoost
do
local SPRINT_FACTOR = 3
local SPEED_EPSILON = 0.05
local baseSpeed = 8
pcall(function()
baseSpeed = game.StarterPlayer.CharacterWalkSpeed
end)
local release, current
local function drop()
if release then
pcall(release)
release, current = nil, nil
end
end
applySpeedBoost = function(player)
if not (player.SpeedBoost and player.BoostAmount > 1) then
drop()
return
end
local target = baseSpeed
* (LocalPlayer:GetAttribute("SpeedMultiplier") or 1)
* (Sprint.sprinting.get() and SPRINT_FACTOR or 1)
* player.BoostAmount
if current and math.abs(target - current) < SPEED_EPSILON then
return
end
drop()
local ok, remover = pcall(realSetWalkSpeed, target)
if ok and type(remover) == "function" then
release, current = remover, target
end
end
end
local antiDeathCFrame
local antiDeathOffset = 0
local lastRespawnRequest = 0
local wasJumping = false
local function restoreAntiDeath(root)
if not antiDeathCFrame then
return
end
if root then
root.Anchored = false
root.CFrame = antiDeathCFrame
end
antiDeathCFrame = nil
antiDeathOffset = 0
end
local function updateAntiDeath(root, deltaTime, hiding)
if hiding and not antiDeathCFrame then
antiDeathCFrame = root.CFrame
root.Anchored = true
end
if not antiDeathCFrame then
return
end
local target = hiding and ANTI_DEATH_DEPTH or 0
local step = ANTI_DEATH_SPEED * deltaTime
antiDeathOffset = antiDeathOffset + math.clamp(target - antiDeathOffset, -step, step)
root.CFrame = antiDeathCFrame - Vector3.new(0, antiDeathOffset, 0)
if not hiding and antiDeathOffset <= 0.05 then
restoreAntiDeath(root)
end
end
local playerConnection = RunService.Heartbeat:Connect(function(deltaTime)
local player = Config.Player
if player.InfiniteStamina and Sprint.sprint_bar.get() < 1 then
Sprint.sprint_bar.set(1)
end
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local root = character and character:FindFirstChild("HumanoidRootPart")
if not humanoid or not root then
return
end
if Config.AntiEffects.NoRagdoll and Ragdoll.is_ragdolling.get() then
pcall(sendHook, "end_ragdoll_early")
Ragdoll.is_ragdolling.set(false)
end
local downed = humanoid.Health <= 0 or humanoid:GetAttribute("IsDead") or humanoid:GetAttribute("HasBeenDowned")
if player.AutoRespawn and downed and os.clock() - lastRespawnRequest >= RESPAWN_INTERVAL then
lastRespawnRequest = os.clock()
pcall(sendHook, "death_screen_request_respawn")
end
local hiding = player.AntiDeath and humanoid.Health > 0 and humanoid.MaxHealth > 0
and humanoid.Health / humanoid.MaxHealth <= ANTI_DEATH_HEALTH
updateAntiDeath(root, deltaTime, hiding)
pcall(applyVehicleMods)
pcall(applySpeedBoost, player)
local jumping = humanoid:GetState() == Enum.HumanoidStateType.Jumping
if player.FlyJump and jumping and not wasJumping then
local velocity = root.AssemblyLinearVelocity
root.AssemblyLinearVelocity = Vector3.new(velocity.X, player.JumpVelocity, velocity.Z)
end
wasJumping = jumping
end)
task.spawn(function()
while running do
task.wait(0.5)
if gunModsActive() or next(gunOriginals) then
pcall(applyGunMods)
end
end
end)
task.spawn(function()
while running do
task.wait(1 / math.max(Config.Melee.AuraSpeed, 1))
if Config.Melee.KillAura then
local tool = Melee.equipped_melee.get()
local object = tool and Melee.class.find(tool)
local root = localRoot()
if object and root then
local speed = object.states.speed.get()
local swing = (speed * 0.75 + math.random() * speed * 0.25)
* (LocalPlayer:GetAttribute("SpeedMultiplier") or 1)
for _, player in ipairs(playersWithin(Config.Melee.AuraRange)) do
local faced = facingCFrame(root.CFrame, player)
if faced then
pcall(sendHook, "melee_attack", object.instance, { player }, faced, swing)
end
end
end
end
end
end)
task.spawn(function()
while running do
task.wait(0.1)
if Config.Melee.ThrowableAura then
local tool = Throwable and Throwable.equipped_throwable.get()
local target = tool and closestPlayerWithin(Config.Melee.ThrowRange)
local targetRoot = target and targetRootOf(target)
if targetRoot then
local origin = tool:GetPivot().Position
local offset = targetRoot.Position - origin
if offset.Magnitude > 0 and Sprint.consume_stamina(THROW_STAMINA) then
pcall(sendHook, "throw_item", tool, origin, offset.Unit)
task.wait(THROW_COOLDOWN)
end
end
end
end
end)
local fovCircle, targetLine
pcall(function()
fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Color = Config.Colors.FOV
fovCircle.Visible = false
targetLine = Drawing.new("Line")
targetLine.Thickness = 1
targetLine.Transparency = 1
targetLine.Color = Config.Colors.TargetLine
targetLine.Visible = false
end)
local renderConnection = RunService.RenderStepped:Connect(function()
if fovCircle then
fovCircle.Visible = Config.Visuals.FOVCircle
if fovCircle.Visible then
fovCircle.Position = cursorPoint()
fovCircle.Radius = Config.Targeting.FOVRadius
end
end
if targetLine then
local target = Config.Visuals.TargetLine and selectTarget() or nil
local point = target and screenPoint(target.Position) or nil
if point then
targetLine.From = cursorPoint()
targetLine.To = point
targetLine.Visible = true
else
targetLine.Visible = false
end
end
end)
do
local ShoulderCamera
pcall(function()
ShoulderCamera = require(ReplicatedStorage.Modules.Game.ShoulderCamera)
end)
local function mouseLocked()
if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
return true
end
return ShoulderCamera ~= nil and ShoulderCamera.lock_mouse_center.get() == true
end
local connection = RunService.RenderStepped:Connect(function()
if not Config.Aimbot.Enabled or not mousemoverel or not mouseLocked() then
return
end
local target = selectTarget()
local point = target and screenPoint(target.Position)
if not point then
return
end
local offset = point - cursorPoint()
local factor = math.max(Config.Aimbot.Smoothness, 1)
pcall(mousemoverel, offset.X / factor, offset.Y / factor)
end)
table.insert(cleanupTasks, function()
connection:Disconnect()
end)
end
local espCleanup
do
local BOX_EXTENTS = Vector3.new(2, 3.2, 1.4)
local CORNERS = {
Vector3.new(-1, -1, -1), Vector3.new(1, -1, -1), Vector3.new(1, -1, 1), Vector3.new(-1, -1, 1),
Vector3.new(-1, 1, -1), Vector3.new(1, 1, -1), Vector3.new(1, 1, 1), Vector3.new(-1, 1, 1),
}
local EDGES = {
{ 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 1 },
{ 5, 6 }, { 6, 7 }, { 7, 8 }, { 8, 5 },
{ 1, 5 }, { 2, 6 }, { 3, 7 }, { 4, 8 },
}
local ARROW_RADIUS = 200
local ARROW_LENGTH = 20
local ARROW_WIDTH = 9
local TEXT_SIZE = 13
local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(0, 0, 0)
local sets = {}
local highlights = {}
local anyShown = false
local function newText()
local text = Drawing.new("Text")
text.Size = TEXT_SIZE
text.Center = true
text.Outline = true
text.Color = WHITE
text.Visible = false
return text
end
local function newSquare(filled, color)
local square = Drawing.new("Square")
square.Thickness = 1
square.Filled = filled
square.Color = color
square.Visible = false
return square
end
local function acquire(player)
local set = sets[player]
if set then
return set
end
set = {
outline = newSquare(false, BLACK),
box = newSquare(false, WHITE),
fill = newSquare(true, WHITE),
healthBack = newSquare(true, BLACK),
healthBar = newSquare(true, WHITE),
healthText = newText(),
name = newText(),
weapon = newText(),
distance = newText(),
tracer = Drawing.new("Line"),
arrow = Drawing.new("Triangle"),
edges = {},
}
set.fill.Transparency = 0.35
set.tracer.Thickness = 1
set.tracer.Color = WHITE
set.tracer.Visible = false
set.arrow.Thickness = 1
set.arrow.Filled = true
set.arrow.Color = WHITE
set.arrow.Visible = false
for index = 1, #EDGES do
local line = Drawing.new("Line")
line.Thickness = 1
line.Color = WHITE
line.Visible = false
set.edges[index] = line
end
sets[player] = set
return set
end
local function hide(set)
set.outline.Visible = false
set.box.Visible = false
set.fill.Visible = false
set.healthBack.Visible = false
set.healthBar.Visible = false
set.healthText.Visible = false
set.name.Visible = false
set.weapon.Visible = false
set.distance.Visible = false
set.tracer.Visible = false
set.arrow.Visible = false
for _, line in ipairs(set.edges) do
line.Visible = false
end
end
local function destroySet(player)
local set = sets[player]
if set then
hide(set)
for _, line in ipairs(set.edges) do
pcall(line.Remove, line)
end
for key, object in pairs(set) do
if key ~= "edges" then
pcall(object.Remove, object)
end
end
sets[player] = nil
end
local highlight = highlights[player]
if highlight then
pcall(highlight.Destroy, highlight)
highlights[player] = nil
end
end
local function chamsFor(player, character, wanted)
local highlight = highlights[player]
if not wanted then
if highlight then
highlight.Enabled = false
end
return
end
if not highlight then
highlight = Instance.new("Highlight")
highlight.FillColor = WHITE
highlight.FillTransparency = 0.6
highlight.OutlineColor = WHITE
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Parent = playerGui
highlights[player] = highlight
end
highlight.Adornee = character
highlight.Enabled = true
end
local function hideAll()
for _, set in pairs(sets) do
hide(set)
end
for _, highlight in pairs(highlights) do
highlight.Enabled = false
end
end
local function drawPlayer(player, esp, camera, inset, viewport, localRootPosition)
local character, humanoid = livingCharacter(player, true)
local root = character and character:FindFirstChild("HumanoidRootPart")
if not root or not humanoid then
local existing = sets[player]
if existing then
hide(existing)
end
chamsFor(player, nil, false)
return
end
local set = acquire(player)
hide(set)
chamsFor(player, character, esp.Chams)
local center, onScreen = camera:WorldToViewportPoint(root.Position)
if not onScreen then
if esp.Arrows then
local screenCenter = viewport * 0.5
local direction = Vector2.new(center.X, center.Y) - screenCenter
if center.Z < 0 then
direction = -direction
end
if direction.Magnitude < 1 then
return
end
direction = direction.Unit
local tip = screenCenter + direction * ARROW_RADIUS
local side = Vector2.new(-direction.Y, direction.X)
set.arrow.PointA = tip + direction * ARROW_LENGTH
set.arrow.PointB = tip + side * ARROW_WIDTH
set.arrow.PointC = tip - side * ARROW_WIDTH
set.arrow.Visible = true
end
return
end
local cframe = root.CFrame
local minX, minY = math.huge, math.huge
local maxX, maxY = -math.huge, -math.huge
local points = {}
for index, corner in ipairs(CORNERS) do
local world = cframe * (corner * BOX_EXTENTS)
local projected = camera:WorldToViewportPoint(world)
local point = Vector2.new(projected.X + inset.X, projected.Y + inset.Y)
points[index] = point
minX = math.min(minX, point.X)
minY = math.min(minY, point.Y)
maxX = math.max(maxX, point.X)
maxY = math.max(maxY, point.Y)
end
local position = Vector2.new(minX, minY)
local size = Vector2.new(maxX - minX, maxY - minY)
if size.X > viewport.X or size.Y > viewport.Y then
return
end
if esp.BoxFill then
set.fill.Position = position
set.fill.Size = size
set.fill.Visible = true
end
if esp.Boxes then
set.outline.Position = position - Vector2.new(1, 1)
set.outline.Size = size + Vector2.new(2, 2)
set.outline.Visible = true
set.box.Position = position
set.box.Size = size
set.box.Visible = true
end
if esp.Boxes3D then
for index, edge in ipairs(EDGES) do
local line = set.edges[index]
line.From = points[edge[1]]
line.To = points[edge[2]]
line.Visible = true
end
end
local fraction = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
if esp.HealthBar then
local barHeight = size.Y * fraction
if esp.HealthOutline then
set.healthBack.Position = position - Vector2.new(7, 1)
set.healthBack.Size = Vector2.new(5, size.Y + 2)
set.healthBack.Visible = true
end
set.healthBar.Color = Color3.fromRGB(255 - fraction * 255, fraction * 255, 0)
set.healthBar.Position = Vector2.new(position.X - 6, position.Y + size.Y - barHeight)
set.healthBar.Size = Vector2.new(3, barHeight)
set.healthBar.Visible = true
end
if esp.HealthText then
set.healthText.Center = false
set.healthText.Position = Vector2.new(position.X + size.X + 4, position.Y)
set.healthText.Text = tostring(math.floor(humanoid.Health)) .. " HP"
set.healthText.Visible = true
end
local below = position.Y + size.Y + 2
if esp.Names then
set.name.Position = Vector2.new(position.X + size.X * 0.5, position.Y - TEXT_SIZE - 3)
set.name.Text = player.DisplayName ~= player.Name
and (player.DisplayName .. " (" .. player.Name .. ")")
or player.Name
set.name.Visible = true
end
if esp.Weapons then
local tool = character:FindFirstChildOfClass("Tool")
set.weapon.Position = Vector2.new(position.X + size.X * 0.5, below)
set.weapon.Text = tool and tool.Name or "Unarmed"
set.weapon.Visible = true
below = below + TEXT_SIZE + 1
end
if esp.Distance and localRootPosition then
set.distance.Position = Vector2.new(position.X + size.X * 0.5, below)
set.distance.Text = tostring(math.floor((root.Position - localRootPosition).Magnitude)) .. "m"
set.distance.Visible = true
end
if esp.Tracers then
set.tracer.From = Vector2.new(viewport.X * 0.5, viewport.Y)
set.tracer.To = Vector2.new(position.X + size.X * 0.5, position.Y + size.Y)
set.tracer.Visible = true
end
end
if Drawing then
local connection = RunService.RenderStepped:Connect(function()
local esp = Config.ESP
if not esp.Enabled then
if anyShown then
hideAll()
anyShown = false
end
return
end
anyShown = true
local camera = Workspace.CurrentCamera
if not camera then
return
end
local inset = GuiService:GetGuiInset()
local viewport = camera.ViewportSize
local root = localRoot()
local origin = root and root.Position or nil
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
pcall(drawPlayer, player, esp, camera, inset, viewport, origin)
end
end
end)
local removing = Players.PlayerRemoving:Connect(destroySet)
espCleanup = function()
pcall(connection.Disconnect, connection)
pcall(removing.Disconnect, removing)
for player in pairs(sets) do
destroySet(player)
end
end
end
end
local tracerCleanup
do
local tracerFolder
local wrapped
local function spawnTracer(gun)
local barrel = gun and gun:FindFirstChild("BarrelAttachment", true)
if not barrel then
return
end
local origin = barrel.WorldCFrame.Position
local direction = barrel.WorldCFrame.LookVector
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.IgnoreWater = true
params.FilterDescendantsInstances = { gun:FindFirstAncestorWhichIsA("Model") or gun, tracerFolder }
local result = Workspace:Raycast(origin, direction * 500, params)
local target = result and result.Position or origin + direction * 500
local length = (target - origin).Magnitude
if length < 1 then
return
end
local width = Config.BulletTracers.Width
local beam = Instance.new("Part")
beam.Anchored = true
beam.CanCollide = false
beam.CanQuery = false
beam.CanTouch = false
beam.CastShadow = false
beam.Material = Enum.Material.Neon
beam.Color = Color3.fromRGB(255, 255, 255)
beam.Size = Vector3.new(width, width, length)
beam.CFrame = CFrame.lookAt(origin, target) * CFrame.new(0, 0, -length * 0.5)
beam.Parent = tracerFolder
game:GetService("Debris"):AddItem(beam, Config.BulletTracers.Lifetime)
end
if hookTable then
tracerFolder = Instance.new("Folder")
tracerFolder.Parent = Workspace
local original = hookTable.gunshot
wrapped = function(...)
if Config.BulletTracers.Enabled then
pcall(spawnTracer, (...))
end
if original then
return original(...)
end
end
hookTable.gunshot = wrapped
tracerCleanup = function()
if hookTable.gunshot == wrapped then
hookTable.gunshot = original
end
pcall(tracerFolder.Destroy, tracerFolder)
end
end
end
do
local CollectionService = game:GetService("CollectionService")
local Dumpster, AirDropSystem
pcall(function()
Dumpster = require(ReplicatedStorage.Modules.Game.World.Dumpster)
AirDropSystem = require(ReplicatedStorage.Modules.Game.AirDrop)
end)
local REFRESH = 0.5
local DOT_SIZE = 4
local TEXT_SIZE = 13
local COLORS = {
money = Color3.fromRGB(120, 255, 140),
item = Color3.fromRGB(255, 255, 255),
dumpster = Color3.fromRGB(200, 165, 120),
airdrop = Color3.fromRGB(255, 190, 80),
atm = Color3.fromRGB(120, 200, 255),
crate = Color3.fromRGB(215, 135, 255),
}
local entries = {}
local pool = {}
local shown = false
local function widget(index)
local set = pool[index]
if not set then
local text = Drawing.new("Text")
text.Size = TEXT_SIZE
text.Center = true
text.Outline = true
text.Visible = false
local dot = Drawing.new("Square")
dot.Thickness = 1
dot.Filled = true
dot.Visible = false
set = { text = text, dot = dot }
pool[index] = set
end
return set
end
local function hideFrom(index)
for position = index, #pool do
pool[position].text.Visible = false
pool[position].dot.Visible = false
end
end
local function collect()
local settings = Config.WorldESP
local root = localRoot()
local origin = root and root.Position
local found = {}
local function add(instance, label, color)
if typeof(instance) ~= "Instance" or not instance:IsDescendantOf(Workspace) then
return
end
local ok, pivot = pcall(instance.GetPivot, instance)
if not ok or (origin and (pivot.Position - origin).Magnitude > settings.Range) then
return
end
table.insert(found, { instance = instance, text = label, color = color })
end
if settings.Items or settings.Money then
local dropped = Workspace:FindFirstChild("DroppedItems")
for _, item in ipairs(dropped and dropped:GetChildren() or {}) do
local money = item:GetAttribute("item_type") == "money"
if money and settings.Money then
add(item, "Money", COLORS.money)
elseif not money and settings.Items then
add(item, item.Name, COLORS.item)
end
end
end
if settings.Dumpsters and Dumpster then
for instance, object in pairs(Dumpster.dumpster_class.objects) do
if object.states.has_items.get() then
add(instance, "Dumpster", COLORS.dumpster)
end
end
end
if settings.Airdrops and AirDropSystem then
for instance, object in pairs(AirDropSystem.class.objects) do
if not object.states.opened.get() then
local remaining = object.states.landing_stamp.get() - os.time()
add(instance, remaining > 0 and ("Airdrop " .. math.floor(remaining) .. "s") or "Airdrop", COLORS.airdrop)
end
end
end
if settings.ATMs then
for instance, object in pairs(ATM.class.objects) do
local states = object and object.states
if states and not states.disabled.get() and not states.hacker.get() then
add(instance, "ATM", COLORS.atm)
end
end
end
if settings.Crates then
for _, instance in ipairs(CollectionService:GetTagged("Crate")) do
add(instance, "Crate", COLORS.crate)
end
end
entries = found
end
if Drawing then
task.spawn(function()
while running do
task.wait(REFRESH)
if Config.WorldESP.Enabled then
pcall(collect)
elseif #entries > 0 then
entries = {}
end
end
end)
local connection = RunService.RenderStepped:Connect(function()
if not Config.WorldESP.Enabled then
if shown then
hideFrom(1)
shown = false
end
return
end
local camera = Workspace.CurrentCamera
if not camera then
return
end
local inset = GuiService:GetGuiInset()
local root = localRoot()
local origin = root and root.Position
local index = 0
for _, entry in ipairs(entries) do
if entry.instance.Parent then
local ok, pivot = pcall(entry.instance.GetPivot, entry.instance)
if ok then
local point, onScreen = camera:WorldToViewportPoint(pivot.Position)
if onScreen then
index += 1
local set = widget(index)
local screen = Vector2.new(point.X + inset.X, point.Y + inset.Y)
set.text.Text = origin
and (entry.text .. "  " .. math.floor((pivot.Position - origin).Magnitude) .. "m")
or entry.text
set.text.Position = screen + Vector2.new(0, DOT_SIZE)
set.text.Color = entry.color
set.text.Visible = true
set.dot.Position = screen - Vector2.new(DOT_SIZE * 0.5, DOT_SIZE * 0.5)
set.dot.Size = Vector2.new(DOT_SIZE, DOT_SIZE)
set.dot.Color = entry.color
set.dot.Visible = true
end
end
end
end
hideFrom(index + 1)
shown = true
end)
table.insert(cleanupTasks, function()
connection:Disconnect()
for _, set in ipairs(pool) do
pcall(set.text.Remove, set.text)
pcall(set.dot.Remove, set.dot)
end
end)
end
end
local HACK_TOOL_OPTIONS = { "Auto (Best Available)", "HackToolBasic", "HackToolPro", "HackToolUltimate", "HackToolQuantum" }
local HACK_TOOLS = { "HackToolQuantum", "HackToolUltimate", "HackToolPro", "HackToolBasic" }
local TRAVEL_METHODS = { "Pathfinding", "Tween" }
local TRAVEL_TIMEOUT = 90
local TRAVEL_ATTEMPTS = 6
local APPROACH_STEPS = { 90, 60, 35, 18 }
local APPROACH_GAIN = 10
local SAME_FLOOR_HEIGHT = 8
local ESCAPE_RADII = { 6, 10, 14 }
local BEACON_TIMEOUT = 4
local BEACON_MATCH = 4
local MOP_START_TIMEOUT = 3
local MOP_TIMEOUT = 45
local WAYPOINT_TIMEOUT = 8
local FOOT_SPEED_CAP = 20
local WALK_SPEED = 20
local WAYPOINT_REACHED = 4
local WAYPOINT_ADVANCE = 3
local DOOR_APPROACH = 12
local SPRINT_FLOOR = 0.35
local PATH_DOT_SIZE = 0.7
local PATH_SPOT_SIZE = 2.5
local PATH_LINK_WIDTH = 0.15
local PATH_COLOR = Color3.fromRGB(255, 255, 255)
local PATH_SPOT_COLOR = Color3.fromRGB(90, 200, 255)
local STUCK_DISTANCE = 1.5
local STUCK_TIME = 1.5
local GLIDE_LIMIT = 12
local GLIDE_LIFT = Vector3.new(0, 5, 0)
local TARGET_OFFSETS = { Vector3.zero }
for _, radius in ipairs({ 4, 8 }) do
for angle = 0, 315, 45 do
table.insert(TARGET_OFFSETS, Vector3.new(math.cos(math.rad(angle)) * radius, 0, math.sin(math.rad(angle)) * radius))
end
end
local DEPOSIT_THRESHOLD = 1000
local MOPS = { "Diamond Mop", "Gold Mop", "Silver Mop", "Bronze Mop", "Mop" }
local function itemCount(itemType, name)
local ok, count = pcall(ItemUtils.get_item_count, Data, itemType, name)
return ok and tonumber(count) or 0
end
local groundParams = RaycastParams.new()
groundParams.FilterType = Enum.RaycastFilterType.Exclude
groundParams.IgnoreWater = true
pcall(function() groundParams.RespectCanCollide = true end)
local function groundNear(position, offset, up, down)
groundParams.FilterDescendantsInstances = { LocalPlayer.Character }
local origin = position + offset + Vector3.new(0, up or 12, 0)
local hit = Workspace:Raycast(origin, Vector3.new(0, -(down or 60), 0), groundParams)
return hit and hit.Position + Vector3.new(0, 3, 0) or nil
end
local function pathWaypoints(fromPosition, toPosition)
local path = PathfindingService:CreatePath({
AgentRadius = 2,
AgentHeight = 5,
AgentCanJump = true,
WaypointSpacing = 4,
})
local ok = pcall(path.ComputeAsync, path, fromPosition, toPosition)
if not ok or path.Status ~= Enum.PathStatus.Success then
return nil
end
return path:GetWaypoints()
end
local clearBetween, hopNeeded
do
local SIGHT_LIFT = Vector3.new(0, 2, 0)
local HOP_PROBE = 5
local HOP_WIDTH = 1.1
local HOP_CEIL = Vector3.new(0, 3.1, 0)
local HOP_BODY = {
Vector3.new(0, -1.7, 0),
Vector3.new(0, -0.9, 0),
Vector3.zero,
Vector3.new(0, 1.6, 0),
}
local sightParams = RaycastParams.new()
sightParams.FilterType = Enum.RaycastFilterType.Exclude
sightParams.IgnoreWater = true
pcall(function() sightParams.RespectCanCollide = true end)
local function aim()
sightParams.FilterDescendantsInstances = { LocalPlayer.Character }
return sightParams
end
clearBetween = function(fromPosition, toPosition)
local origin = fromPosition + SIGHT_LIFT
local finish = toPosition + SIGHT_LIFT
local hit = Workspace:Raycast(origin, finish - origin, aim())
return hit == nil or (finish - hit.Position).Magnitude < 2
end
hopNeeded = function(root, direction)
local flat = Vector3.new(direction.X, 0, direction.Z)
if flat.Magnitude < 0.1 then
return false
end
local forward = flat.Unit
local reach = forward * HOP_PROBE
local side = Vector3.new(-forward.Z, 0, forward.X) * HOP_WIDTH
for _, lane in ipairs({ Vector3.zero, side, -side }) do
local origin = root.Position + lane
if not Workspace:Raycast(origin + HOP_CEIL, reach, aim()) then
for _, level in ipairs(HOP_BODY) do
if Workspace:Raycast(origin + level, reach, aim()) then
return true
end
end
end
end
return false
end
end
local function pathToTarget(fromPosition, targetPosition, limit)
local tried = 0
for _, offset in ipairs(TARGET_OFFSETS) do
local candidate = groundNear(targetPosition, offset)
if candidate and clearBetween(candidate, targetPosition) then
local waypoints = pathWaypoints(fromPosition, candidate)
if waypoints then
return waypoints
end
tried += 1
if limit and tried >= limit then
return nil
end
end
end
return nil
end
local function pathTowards(fromPosition, targetPosition)
local offset = targetPosition - fromPosition
local distance = offset.Magnitude
if distance <= APPROACH_STEPS[1] then
return nil
end
local direction = offset.Unit
for _, step in ipairs(APPROACH_STEPS) do
if step < distance - APPROACH_GAIN then
local staging = fromPosition + direction * step
local waypoints = pathToTarget(fromPosition, staging)
if waypoints then
local landing = waypoints[#waypoints].Position
if (landing - targetPosition).Magnitude < distance - APPROACH_GAIN then
return waypoints
end
end
end
end
return nil
end
local function hasLineOfSight(mover, position)
return clearBetween(mover:GetPivot().Position, position)
end
local function escapeSpot(mover, targetPosition)
local goal = groundNear(targetPosition, Vector3.zero) or targetPosition
local origin = mover:GetPivot().Position
for _, radius in ipairs(ESCAPE_RADII) do
for angle = 0, 315, 45 do
local offset = Vector3.new(math.cos(math.rad(angle)) * radius, 0, math.sin(math.rad(angle)) * radius)
local spot = groundNear(origin + offset, Vector3.zero, 5, 30)
if spot and hasLineOfSight(mover, spot) and pathWaypoints(spot, goal) then
return spot
end
end
end
return nil
end
local function nearestReachable(instances, attempts)
local root = localRoot()
if not root or #instances == 0 then
return nil
end
table.sort(instances, function(a, b)
return (a:GetPivot().Position - root.Position).Magnitude < (b:GetPivot().Position - root.Position).Magnitude
end)
if (instances[1]:GetPivot().Position - root.Position).Magnitude > APPROACH_STEPS[1] then
return instances[1]
end
for _, instance in ipairs(instances) do
local goal = groundNear(instance:GetPivot().Position, Vector3.zero)
if goal and pathWaypoints(root.Position, goal) then
return instance
end
end
for index = 1, math.min(#instances, attempts or 4) do
if pathToTarget(root.Position, instances[index]:GetPivot().Position) then
return instances[index]
end
end
return nil
end
local function farmActive(farm)
return running and (farm == nil or Config.Autofarms[farm] == true)
end
local function awaitFarm(farm)
while running and not farmActive(farm) do
task.wait(0.1)
end
task.wait(0.1)
return farmActive(farm)
end
local doorRoute, pushThroughDoor
do
local DOOR_OFFSET = 5
local DOOR_PUSH_TIME = 5
local DOOR_ATTEMPTS = 6
local DOOR_CACHE_TTL = 20
local DOOR_REACHED = 2
local DOOR_PROGRESS = 2
local cache = {}
local cacheTime = 0
local function buildingOf(base)
local node = base
while node.Parent and node.Parent.Parent do
if node.Parent.Parent.Name == "Tiles" then
return node:IsA("Model") and node or nil
end
node = node.Parent
end
return nil
end
local function knownDoors()
if os.clock() - cacheTime < DOOR_CACHE_TTL and #cache > 0 then
return cache
end
cache = {}
for _, instance in ipairs(Workspace:GetDescendants()) do
if instance.Name == "DoorSystem" then
local base = instance:FindFirstChild("DoorBase", true)
if base and base:IsA("BasePart") and not base.Anchored then
local building = buildingOf(base)
local ok, pivot, size = pcall(function()
return building:GetBoundingBox()
end)
table.insert(cache, {
base = base,
pivot = ok and pivot or nil,
size = ok and size or nil,
})
end
end
end
cacheTime = os.clock()
return cache
end
local function encloses(entry, position)
if not entry.pivot then
return false
end
local offset = entry.pivot:PointToObjectSpace(position)
return math.abs(offset.X) <= entry.size.X / 2
and math.abs(offset.Y) <= entry.size.Y / 2
and math.abs(offset.Z) <= entry.size.Z / 2
end
doorRoute = function(fromPosition, targetPosition)
local candidates = {}
local owned = {}
for _, entry in ipairs(knownDoors()) do
if entry.base.Parent then
local item = {
base = entry.base,
cost = (entry.base.Position - targetPosition).Magnitude,
}
table.insert(candidates, item)
if encloses(entry, targetPosition) then
table.insert(owned, item)
end
end
end
if #owned == 0 then
return nil
end
candidates = owned
table.sort(candidates, function(a, b)
return a.cost < b.cost
end)
local stepNear, stepFar
for index = 1, math.min(#candidates, DOOR_ATTEMPTS) do
local base = candidates[index].base
local normal = base.CFrame.LookVector
local front = groundNear(base.Position + normal * DOOR_OFFSET, Vector3.zero, 8, 40)
local back = groundNear(base.Position - normal * DOOR_OFFSET, Vector3.zero, 8, 40)
if front and back then
for _, side in ipairs({ { front, back }, { back, front } }) do
local near, far = side[1], side[2]
local gain = (near - targetPosition).Magnitude - (far - targetPosition).Magnitude
if gain > DOOR_PROGRESS and pathWaypoints(fromPosition, near) then
if pathWaypoints(far, targetPosition) then
return near, far
elseif not stepNear then
stepNear, stepFar = near, far
end
end
end
end
end
return stepNear, stepFar
end
pushThroughDoor = function(humanoid, target, farm)
local root = localRoot()
if not root then
return false
end
local deadline = os.clock() + DOOR_PUSH_TIME
local nextJump = 0
while farmActive(farm) and os.clock() < deadline do
humanoid:MoveTo(target)
RunService.Heartbeat:Wait()
local offset = target - root.Position
if os.clock() > nextJump and humanoid.FloorMaterial ~= Enum.Material.Air
and hopNeeded(root, offset) then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
nextJump = os.clock() + 0.2
end
if Vector2.new(offset.X, offset.Z).Magnitude <= DOOR_REACHED then
return true
end
end
return false
end
end
local pathFolder
local function clearPath()
if pathFolder then
pathFolder:ClearAllChildren()
end
end
local function markPath(waypoints, destination)
clearPath()
if not Config.Visuals.PathPreview or not waypoints then
return
end
if not pathFolder then
pathFolder = Instance.new("Folder")
pathFolder.Name = "KaliPath"
pathFolder.Parent = Workspace
end
local function marker(position, size, color)
local part = Instance.new("Part")
part.Anchored = true
part.CanCollide = false
part.CanQuery = false
part.CanTouch = false
part.CastShadow = false
part.Shape = Enum.PartType.Ball
part.Material = Enum.Material.Neon
part.Color = color
part.Transparency = 0.3
part.Size = Vector3.new(size, size, size)
part.Position = position
part.Parent = pathFolder
end
local previous
for _, waypoint in ipairs(waypoints) do
marker(waypoint.Position, PATH_DOT_SIZE, PATH_COLOR)
if previous then
local offset = waypoint.Position - previous
local length = offset.Magnitude
if length > 0.5 then
local link = Instance.new("Part")
link.Anchored = true
link.CanCollide = false
link.CanQuery = false
link.CanTouch = false
link.CastShadow = false
link.Material = Enum.Material.Neon
link.Color = PATH_COLOR
link.Transparency = 0.6
link.Size = Vector3.new(PATH_LINK_WIDTH, PATH_LINK_WIDTH, length)
link.CFrame = CFrame.lookAt(previous, waypoint.Position) * CFrame.new(0, 0, -length * 0.5)
link.Parent = pathFolder
end
end
previous = waypoint.Position
end
if destination then
marker(destination, PATH_SPOT_SIZE, PATH_SPOT_COLOR)
end
end
local function glideTo(mover, position, speed, reached, farm)
local deadline = os.clock() + WAYPOINT_TIMEOUT
while farmActive(farm) and os.clock() < deadline do
local deltaTime = RunService.Heartbeat:Wait()
if not mover.Parent then
return false
end
local pivot = mover:GetPivot()
local offset = position - pivot.Position
if offset.Magnitude <= (reached or WAYPOINT_REACHED) then
return true
end
mover:PivotTo(pivot + offset.Unit * math.min(speed * deltaTime, offset.Magnitude))
end
return false
end
local function walkTo(humanoid, position, farm)
local root = localRoot()
if not root then
return false
end
local finished = false
local connection = humanoid.MoveToFinished:Connect(function(success)
finished = success
end)
humanoid:MoveTo(position)
local deadline = os.clock() + WAYPOINT_TIMEOUT
local lastPosition = root.Position
local lastProgress = os.clock()
local nextJump = 0
while farmActive(farm) and not finished and os.clock() < deadline do
RunService.Heartbeat:Wait()
local current = root.Position
local steering = humanoid.MoveDirection
if os.clock() > nextJump and humanoid.FloorMaterial ~= Enum.Material.Air
and hopNeeded(root, steering.Magnitude > 0.1 and steering or position - current) then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
nextJump = os.clock() + 0.2
end
if (current - lastPosition).Magnitude > STUCK_DISTANCE then
lastPosition = current
lastProgress = os.clock()
elseif os.clock() - lastProgress > STUCK_TIME then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
break
end
end
connection:Disconnect()
return finished
end
local function walkPath(humanoid, waypoints, distanceLeft, tolerance, deadline, farm)
local JUMP_RANGE = 7
local JUMP_COOLDOWN = 0.2
local STUCK_RETRIES = 2
local STALL_RATIO = 0.35
local STALL_TIME = 0.25
local root = localRoot()
if not root then
return false
end
local lastPosition = root.Position
local lastProgress = os.clock()
local nextJump = 0
for _, waypoint in ipairs(waypoints) do
if not farmActive(farm) then
humanoid:MoveTo(root.Position)
return false
end
if os.clock() > deadline or distanceLeft() <= tolerance then
return true
end
if not Sprint.sprinting.get() then
Sprint.sprinting.set(true)
end
local mustJump = waypoint.Action == Enum.PathWaypointAction.Jump
local stalls = 0
local grinding = 0
humanoid:MoveTo(waypoint.Position)
while farmActive(farm) do
local step = RunService.Heartbeat:Wait()
if os.clock() > deadline or distanceLeft() <= tolerance then
return true
end
if Config.Player.InfiniteStamina and Sprint.sprint_bar.get() < SPRINT_FLOOR then
Sprint.sprint_bar.set(SPRINT_FLOOR)
end
local current = root.Position
local offset = waypoint.Position - current
local flat = Vector2.new(offset.X, offset.Z).Magnitude
local steering = humanoid.MoveDirection
local heading = steering.Magnitude > 0.1 and steering or offset
local velocity = root.AssemblyLinearVelocity
if steering.Magnitude > 0.1
and Vector2.new(velocity.X, velocity.Z).Magnitude < humanoid.WalkSpeed * STALL_RATIO then
grinding += step
else
grinding = 0
end
if os.clock() > nextJump and humanoid.FloorMaterial ~= Enum.Material.Air
and (hopNeeded(root, heading)
or grinding > STALL_TIME
or (mustJump and flat <= JUMP_RANGE)) then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
grinding = 0
nextJump = os.clock() + JUMP_COOLDOWN
end
if flat <= WAYPOINT_ADVANCE then
break
end
if (current - lastPosition).Magnitude > STUCK_DISTANCE then
lastPosition = current
lastProgress = os.clock()
elseif os.clock() - lastProgress > STUCK_TIME then
stalls += 1
if stalls > STUCK_RETRIES then
return false
end
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
humanoid:MoveTo(waypoint.Position)
lastPosition = current
lastProgress = os.clock()
end
end
end
return true
end
local function travelOnce(position, speed, tolerance, farm)
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not character then
return false
end
local mover = character
local gliding = Config.Autofarms.TravelMethod == "Tween"
local moveSpeed = math.min(speed, FOOT_SPEED_CAP)
local function distanceLeft()
local offset = mover:GetPivot().Position - position
if math.abs(offset.Y) <= SAME_FLOOR_HEIGHT then
return Vector2.new(offset.X, offset.Z).Magnitude
end
return offset.Magnitude
end
if distanceLeft() <= tolerance then
return true
end
local function followPath(list, remaining, reach, limit)
if not gliding then
return walkPath(humanoid, list, remaining, reach, limit, farm)
end
for _, waypoint in ipairs(list) do
if not farmActive(farm) or os.clock() > limit or remaining() <= reach then
return true
end
local goal = waypoint.Position
local root = localRoot()
if root and hopNeeded(root, goal - root.Position) then
local lifted = root.Position + GLIDE_LIFT
glideTo(mover, lifted, moveSpeed, 1, farm)
goal = Vector3.new(goal.X, lifted.Y, goal.Z)
end
if not glideTo(mover, goal, moveSpeed, nil, farm) then
return false
end
end
return true
end
local waypoints = distanceLeft() > APPROACH_STEPS[1]
and pathTowards(mover:GetPivot().Position, position)
or nil
waypoints = waypoints or pathToTarget(mover:GetPivot().Position, position, 1)
if not waypoints and humanoid then
local near, far = doorRoute(mover:GetPivot().Position, position)
if near and far then
local approach = pathToTarget(mover:GetPivot().Position, near)
if approach then
markPath(approach, near)
local function toDoor()
local offset = mover:GetPivot().Position - near
return Vector2.new(offset.X, offset.Z).Magnitude
end
followPath(approach, toDoor, WAYPOINT_REACHED, os.clock() + TRAVEL_TIMEOUT)
end
local reach = mover:GetPivot().Position - near
if Vector2.new(reach.X, reach.Z).Magnitude <= DOOR_APPROACH then
if gliding then
glideTo(mover, far, moveSpeed, nil, farm)
else
pushThroughDoor(humanoid, far, farm)
end
end
clearPath()
return false
end
end
waypoints = waypoints or pathToTarget(mover:GetPivot().Position, position)
if not waypoints then
local spot = escapeSpot(mover, position)
if not spot then
return false
end
if humanoid and not gliding then
walkTo(humanoid, spot, farm)
end
if (mover:GetPivot().Position - spot).Magnitude > WAYPOINT_REACHED then
glideTo(mover, spot, moveSpeed, nil, farm)
end
waypoints = pathToTarget(mover:GetPivot().Position, position)
if not waypoints then
return false
end
end
markPath(waypoints, position)
local deadline = os.clock() + TRAVEL_TIMEOUT
if gliding or humanoid then
followPath(waypoints, distanceLeft, tolerance, deadline)
end
local remaining = distanceLeft()
if remaining > tolerance and remaining <= GLIDE_LIMIT and hasLineOfSight(mover, position) then
glideTo(mover, position, moveSpeed, tolerance, farm)
end
return distanceLeft() <= tolerance
end
local function stopTravel()
clearPath()
pcall(Sprint.sprinting.set, false)
end
local function travelTo(position, speed, tolerance, farm)
tolerance = tolerance or 10
local function gap()
local mover = LocalPlayer.Character
return mover and (mover:GetPivot().Position - position).Magnitude or math.huge
end
local attempts = TRAVEL_ATTEMPTS
for _ = 1, TRAVEL_ATTEMPTS * 5 do
if not farmActive(farm) or attempts <= 0 then
break
end
local before = gap()
if travelOnce(position, speed, tolerance, farm) then
stopTravel()
return true
end
if gap() < before - APPROACH_GAIN then
attempts = TRAVEL_ATTEMPTS
else
attempts -= 1
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
task.wait(0.5)
end
end
stopTravel()
return false
end
local function waitForMinigame(farm)
local startDeadline = os.clock() + 5
while farmActive(farm) and os.clock() < startDeadline and not SliderMinigame.enabled.get() do
task.wait(0.2)
end
local endDeadline = os.clock() + 20
while farmActive(farm) and os.clock() < endDeadline and SliderMinigame.enabled.get() do
task.wait(0.2)
end
end
local function ownedHackTool()
local wanted = Config.Autofarms.HackTool
if wanted ~= HACK_TOOL_OPTIONS[1] then
return itemCount("misc", wanted) > 0 and wanted or nil
end
for _, name in ipairs(HACK_TOOLS) do
if itemCount("misc", name) > 0 then
return name
end
end
return nil
end
local function buyFrom(shopName, itemName, amount, speed, farm)
local shop = Workspace:FindFirstChild(shopName, true)
if not shop then
return
end
local spot = shop:GetPivot().Position
local root = localRoot()
if root then
local closest
for _, item in ipairs(shop:GetDescendants()) do
local anchor = nil
if item:IsA("ProximityPrompt") and item.Parent and item.Parent:IsA("BasePart") then
anchor = item.Parent.Position
elseif item:IsA("Model") and item:FindFirstChildOfClass("Humanoid") then
anchor = item:GetPivot().Position
end
if anchor then
local distance = (anchor - root.Position).Magnitude
if not closest or distance < closest then
closest, spot = distance, anchor
end
end
end
end
travelTo(spot, speed, 5, farm)
for _ = 1, amount do
if not farmActive(farm) then
return
end
pcall(getHook, "purchase_consumable", shop, itemName)
task.wait(0.4)
end
end
local function buyHackTools()
local wanted = Config.Autofarms.HackTool
if wanted == HACK_TOOL_OPTIONS[1] then
wanted = "HackToolBasic"
end
local shopName = wanted == "HackToolQuantum" and "ShopZone_IllegalNightclub" or "ShopZone_Illegal"
buyFrom(shopName, wanted, Config.Autofarms.ToolsToBuy, WALK_SPEED, "ATM")
end
local function depositMoney()
local money = Data.money and Data.money.hand or 0
if money >= DEPOSIT_THRESHOLD then
pcall(getHook, "transfer_funds", "hand", "bank", money)
end
end
task.spawn(function()
while running do
awaitFarm("ATM")
if Config.Autofarms.ATM then
local tool = ownedHackTool()
if not tool then
buyHackTools()
tool = ownedHackTool()
end
local skipped = {}
local function nearestMachine()
local origin = localRoot()
if not origin then
return nil
end
local options = {}
for instance, entry in pairs(ATM.class.objects) do
if typeof(instance) == "Instance" and instance:IsDescendantOf(Workspace) and not skipped[instance] then
local states = entry and entry.states
if states and not states.disabled.get() and not states.hacker.get() then
options[#options + 1] = {
instance = instance,
cost = (instance:GetPivot().Position - origin.Position).Magnitude,
}
end
end
end
if #options == 0 then
return nil
end
table.sort(options, function(a, b)
return a.cost < b.cost
end)
for index = 1, math.min(#options, 4) do
local option = options[index]
local path = PathfindingService:CreatePath({ AgentRadius = 3, AgentHeight = 6, AgentCanJump = false })
local ok = pcall(path.ComputeAsync, path, origin.Position, option.instance:GetPivot().Position)
if ok and path.Status == Enum.PathStatus.Success then
local walked, previous = 0, nil
for _, waypoint in ipairs(path:GetWaypoints()) do
if previous then
walked += (waypoint.Position - previous).Magnitude
end
previous = waypoint.Position
end
if walked > 0 then
option.cost = walked
end
end
end
table.sort(options, function(a, b)
return a.cost < b.cost
end)
return options[1].instance
end
while tool and farmActive("ATM") do
local machine = nearestMachine()
if not machine then
break
end
skipped[machine] = true
local machinePos = machine:GetPivot().Position
if not travelTo(machinePos, WALK_SPEED, nil, "ATM") then
continue
end
pcall(sendHook, "request_begin_hacking_3", machine, tool)
waitForMinigame("ATM")
if Config.Autofarms.Deposit then
depositMoney()
end
break
end
elseif Config.Autofarms.Deposit then
depositMoney()
end
end
end)
local function findItem(predicate)
local found
pcall(ItemUtils.iterate_through_items, Data, function(item)
if not found and type(item) == "table" and predicate(item) then
found = item
end
end)
return found
end
local function ownedItem(names)
return findItem(function(item)
return item.name ~= nil and table.find(names, item.name) ~= nil
end)
end
local function equipItem(item)
if not item then
return false
end
if item.is_equipped then
return true
end
if type(item.name) == "string" then
for _, container in ipairs({ LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }) do
local tool = container and container:FindFirstChild(item.name)
if tool and tool:IsA("Tool") then
return true
end
end
end
pcall(getHook, "toggle_equip_item", item.guid)
task.wait(0.5)
return true
end
local function heldTool()
local character = LocalPlayer.Character
return character and character:FindFirstChildOfClass("Tool")
end
local function jobBeaconFor(jobIndex)
for instance, object in pairs(JobBeacon.class.objects) do
if typeof(instance) == "Instance" and instance:IsDescendantOf(Workspace) and object.states.JobIndex.get() == jobIndex then
return instance
end
end
return nil
end
local function ensureJob(jobIndex, farm)
if LocalPlayer:GetAttribute("Job") == jobIndex then
return true
end
local beacon = jobBeaconFor(jobIndex)
if not beacon or not travelTo(beacon:GetPivot().Position, WALK_SPEED, 8, farm) then
return false
end
pcall(sendHook, "apply_for_job", beacon)
task.wait(1.5)
return LocalPlayer:GetAttribute("Job") == jobIndex
end
local function holdingTagged(tag)
local tool = heldTool()
return tool ~= nil and tool:HasTag(tag)
end
local function cleaningPuddle()
return ProgressBar.bar_enabled.get() and ProgressBar.bar_type.get() == ProgressBar.all_bar_types.default
end
local function ensureMop()
if holdingTagged("Mop") then
return true
end
if equipItem(ownedItem(MOPS)) then
local deadline = os.clock() + 2
while running and os.clock() < deadline and not holdingTagged("Mop") do
task.wait(0.2)
end
end
return holdingTagged("Mop")
end
task.spawn(function()
while running do
awaitFarm("BurgerJob")
if Config.Autofarms.BurgerJob and ensureJob("janitor", "BurgerJob") and ensureMop() then
local puddles = {}
for instance, object in pairs(Janitor.class.objects) do
if typeof(instance) == "Instance" and instance:IsDescendantOf(Workspace) and not object.states.mopped.get() then
table.insert(puddles, instance)
end
end
local puddle = nearestReachable(puddles)
if puddle and travelTo(puddle:GetPivot().Position, WALK_SPEED, 4, "BurgerJob") then
local start = os.clock() + MOP_START_TIMEOUT
while farmActive("BurgerJob") and os.clock() < start and not cleaningPuddle() do
task.wait(0.2)
end
local finish = os.clock() + MOP_TIMEOUT
while farmActive("BurgerJob") and os.clock() < finish and cleaningPuddle() do
task.wait(0.3)
end
end
end
end
end)
local function promptPosition(prompt)
local parent = prompt.Parent
if parent:IsA("Attachment") then
return parent.WorldPosition
elseif parent:IsA("BasePart") then
return parent.Position
end
return nil
end
local function ownedSteak()
local found
pcall(ItemUtils.iterate_through_items_of_type, Data, "misc", function(item)
if not found and type(item) == "table" and type(item.name) == "string" and item.name:find("Steak") then
found = item
end
end)
return found
end
local function holdingCookable()
local tool = heldTool()
return tool ~= nil and tool:GetAttribute("IsCookable") == true
end
local function grabCookable()
if holdingCookable() then
return true
end
local steak = ownedSteak()
if steak then
return equipItem(steak)
end
for instance in pairs(Steakhouse.fridge_class.objects) do
if typeof(instance) == "Instance" and instance:IsDescendantOf(Workspace) then
local prompt = instance:FindFirstChildWhichIsA("ProximityPrompt", true)
local position = prompt and promptPosition(prompt)
if position then
travelTo(position, WALK_SPEED, 4, "SteakHouse")
local root = localRoot()
if root and fireproximityprompt and (root.Position - position).Magnitude <= prompt.MaxActivationDistance then
pcall(fireproximityprompt, prompt)
local deadline = os.clock() + 3
while farmActive("SteakHouse") and os.clock() < deadline and not holdingCookable() and not ownedSteak() do
task.wait(0.2)
end
end
end
break
end
end
return holdingCookable() or equipItem(ownedSteak())
end
local function grillStand(object)
local ok, area = pcall(object.get, "GrillArea")
if not ok or typeof(area) ~= "Instance" then
return nil
end
return area.Position - Vector3.new(0, area.Size.Y / 2, 0)
end
local function markedGrill()
local beacon = Workspace:FindFirstChild("Beacon")
local deadline = os.clock() + BEACON_TIMEOUT
while farmActive("SteakHouse") and not beacon and os.clock() < deadline do
task.wait(0.15)
beacon = Workspace:FindFirstChild("Beacon")
end
if not beacon or not beacon:IsA("Model") then
return nil
end
local beaconPosition = beacon:GetPivot().Position
for instance, object in pairs(Steakhouse.grill_class.objects) do
if typeof(instance) == "Instance" and instance:IsDescendantOf(Workspace) and object.states.user_id_assigned.get() == 0 then
local stand = grillStand(object)
if stand and (stand - beaconPosition).Magnitude <= BEACON_MATCH then
return instance, object, stand
end
end
end
return nil
end
local function cookingBar()
local screen = playerGui:FindFirstChild("ProgressBar")
local frame = screen and screen:FindFirstChild("ProgressBarFrame")
local main = frame and frame:FindFirstChild("MainFrame")
return main and main:FindFirstChild("BarAmount")
end
local function stopBarOnPerfect()
local amount = cookingBar()
if not amount then
return
end
local armed = false
local deadline = os.clock() + 120
while running and os.clock() < deadline and ProgressBar.bar_enabled.get() do
RunService.Heartbeat:Wait()
if not armed then
armed = amount.Size.X.Scale < 0.02
else
local ok, status = pcall(ProgressBar.get_status_from_ui)
if ok and status == "Perfect" then
ProgressBar.bar_enabled.set(false)
return
end
end
end
end
pcall(function()
ProgressBar.bar_enabled.hook(function(enabled)
if enabled and Config.Autofarms.SteakHouse and ProgressBar.bar_type.get() == ProgressBar.all_bar_types.cooking then
task.spawn(stopBarOnPerfect)
end
end)
end)
task.spawn(function()
while running do
awaitFarm("SteakHouse")
if Config.Autofarms.SteakHouse and ensureJob("steakhouse_cook", "SteakHouse") then
if grabCookable() then
local instance, object, stand = markedGrill()
if instance and object and stand and travelTo(stand, WALK_SPEED, 4, "SteakHouse") then
local assigned = object.states.user_id_assigned
local deadline = os.clock() + 3
while farmActive("SteakHouse") and os.clock() < deadline and assigned.get() ~= LocalPlayer.UserId do
task.wait(0.2)
end
if assigned.get() ~= LocalPlayer.UserId then
pcall(sendHook, "start_grilling_2", instance)
end
local cookDeadline = os.clock() + 120
while farmActive("SteakHouse") and os.clock() < cookDeadline and assigned.get() == LocalPlayer.UserId do
task.wait(0.3)
end
end
end
end
end
end)
do
local mod = {}
local farm = {}
pcall(function()
mod.shelf = require(ReplicatedStorage.Modules.Game.Jobs.ShelfStocking)
mod.rod = require(ReplicatedStorage.Modules.Game.ItemTypes.FishingRod)
mod.air = require(ReplicatedStorage.Modules.Game.AirDrop)
mod.bin = require(ReplicatedStorage.Modules.Game.World.Dumpster)
end)
function farm.working()
return ProgressBar.bar_enabled.get() and ProgressBar.bar_type.get() == ProgressBar.all_bar_types.default
end
function farm.firePrompt(prompt)
if not prompt then
return false
end
local hold = promptOriginals[prompt] or prompt.HoldDuration
local held = pcall(function()
prompt:InputHoldBegin()
if hold > 0 then
task.wait(hold + 0.25)
else
task.wait(0.1)
end
prompt:InputHoldEnd()
end)
if held then
return true
end
return fireproximityprompt ~= nil and pcall(fireproximityprompt, prompt)
end
function farm.reach(position, key, tolerance)
tolerance = tolerance or 6
local function gap()
local root = localRoot()
if not root then
return math.huge
end
local offset = position - root.Position
if math.abs(offset.Y) <= SAME_FLOOR_HEIGHT then
return Vector2.new(offset.X, offset.Z).Magnitude
end
return offset.Magnitude
end
if gap() <= tolerance then
return true
end
if travelTo(position, WALK_SPEED, tolerance, key) then
return true
end
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if humanoid and gap() <= 60 then
for _ = 1, 3 do
if not farmActive(key) or gap() <= tolerance then
break
end
walkTo(humanoid, position, key)
end
end
return gap() <= tolerance
end
function farm.goToPrompt(prompt, key, tolerance)
local position = promptPosition(prompt)
if not position or not farm.reach(position, key, tolerance) then
return false
end
return farm.firePrompt(prompt)
end
function farm.nearest(objects, accept)
local root = localRoot()
local best, bestCost
for instance, object in pairs(objects) do
if typeof(instance) == "Instance" and instance:IsDescendantOf(Workspace) and accept(instance, object) then
local ok, pivot = pcall(instance.GetPivot, instance)
if ok then
local cost = root and (pivot.Position - root.Position).Magnitude or 0
if not bestCost or cost < bestCost then
best, bestCost = instance, cost
end
end
end
end
return best
end
function farm.hold(tag)
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not humanoid then
return nil
end
local held = heldTool()
if held and held:HasTag(tag) then
return held
end
for _, container in ipairs({ character, LocalPlayer:FindFirstChildOfClass("Backpack") }) do
for _, tool in ipairs(container and container:GetChildren() or {}) do
if tool:IsA("Tool") and tool:HasTag(tag) then
pcall(humanoid.EquipTool, humanoid, tool)
task.wait(0.3)
return heldTool()
end
end
end
return nil
end
function farm.firstOfType(itemType, accept)
local found
pcall(ItemUtils.iterate_through_items_of_type, Data, itemType, function(item)
if not found and type(item) == "table" and (accept == nil or accept(item)) then
found = item
end
end)
return found
end
task.spawn(function()
local HEAL_COOLDOWN = 4
local nextHeal = 0
local templates = ReplicatedStorage:FindFirstChild("Items")
templates = templates and templates:FindFirstChild("consumable")
local function healTool()
for _, container in ipairs({ LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }) do
for _, tool in ipairs(container and container:GetChildren() or {}) do
if tool:IsA("Tool") and tool:GetAttribute("HealthRestoreAmount") then
return tool
end
end
end
return nil
end
while running do
task.wait(0.5)
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if Config.Player.AutoHeal and humanoid and humanoid.Health > 0 and os.clock() >= nextHeal
and humanoid.Health / math.max(humanoid.MaxHealth, 1) * 100 <= Config.Player.HealHealth then
local tool = healTool()
if not tool and templates then
equipItem(farm.firstOfType("consumable", function(item)
local template = type(item.name) == "string" and templates:FindFirstChild(item.name)
return template and template:GetAttribute("HealthRestoreAmount") ~= nil
end))
tool = healTool()
end
if tool then
nextHeal = os.clock() + HEAL_COOLDOWN
if tool.Parent ~= character then
pcall(humanoid.EquipTool, humanoid, tool)
task.wait(0.3)
end
pcall(getHook, "consume_power_up", tool)
end
end
end
end)
task.spawn(function()
local visited = {}
while running do
awaitFarm("Dumpsters")
if Config.Autofarms.Dumpsters and mod.bin then
local bin = farm.nearest(mod.bin.dumpster_class.objects, function(instance, object)
return object.states.has_items.get() and not visited[instance]
end)
if not bin then
table.clear(visited)
task.wait(1)
else
visited[bin] = true
local prompt = bin:FindFirstChildWhichIsA("ProximityPrompt", true)
if prompt and farm.goToPrompt(prompt, "Dumpsters", 5) then
local object = mod.bin.dumpster_class.objects[bin]
local deadline = os.clock() + 3
while farmActive("Dumpsters") and os.clock() < deadline
and object and object.states.has_items.get() do
task.wait(0.2)
end
end
end
end
end
end)
if hookTable then
local original = hookTable.direct_to_shelf
local wrapped
wrapped = function(part, ...)
if typeof(part) == "Instance" then
farm.shelf = part
end
if original then
return original(part, ...)
end
end
hookTable.direct_to_shelf = wrapped
table.insert(cleanupTasks, function()
if hookTable.direct_to_shelf == wrapped then
hookTable.direct_to_shelf = original
end
end)
end
task.spawn(function()
local failures = 0
local lastShelf, lastStock = nil, 0
local function holdingBox()
local character = LocalPlayer.Character
return character ~= nil and character:FindFirstChild("BoxTool") ~= nil
end
local function assignedShelf()
local shelves = mod.shelf.shelf_class.objects
local stale = (os.clock() - lastStock < 5) and lastShelf or nil
for instance, object in pairs(shelves) do
if typeof(instance) == "Instance" and instance ~= stale and instance:IsDescendantOf(Workspace) then
local owner = object.states.player_assigned.get()
if owner == LocalPlayer or owner == LocalPlayer.UserId or owner == LocalPlayer.Name then
return instance
end
end
end
if farm.shelf and farm.shelf:IsDescendantOf(Workspace) then
return farm.shelf
end
local beacon = Workspace:FindFirstChild("Beacon")
if beacon then
local spot = beacon:GetPivot().Position
for instance in pairs(shelves) do
if typeof(instance) == "Instance" and instance:IsDescendantOf(Workspace)
and (instance.Position - Vector3.new(0, instance.Size.Y * 0.5, 0) - spot).Magnitude <= 4 then
return instance
end
end
end
return nil
end
local function pressInto(shelf, seconds)
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local root = localRoot()
if not humanoid or not root then
return false
end
local deadline = os.clock() + seconds
while farmActive("ShelfJob") and os.clock() < deadline do
humanoid:MoveTo(Vector3.new(shelf.Position.X, root.Position.Y, shelf.Position.Z))
RunService.Heartbeat:Wait()
if farm.working() then
return true
end
end
if firetouchinterest then
pcall(firetouchinterest, root, shelf, 0)
task.wait(0.3)
end
return farm.working()
end
local function shelfLevel()
for instance in pairs(mod.shelf.shelf_class.objects) do
if typeof(instance) == "Instance" and instance:IsDescendantOf(Workspace) then
return instance.Position.Y
end
end
return nil
end
local function boxRun()
local level = shelfLevel()
local box = farm.nearest(mod.shelf.box_pickup_class.objects, function(instance)
return level == nil or math.abs(instance.Position.Y - level) <= SAME_FLOOR_HEIGHT
end)
local prompt = box and box:FindFirstChildWhichIsA("ProximityPrompt", true)
if not prompt or not farm.goToPrompt(prompt, "ShelfJob", 6) then
return false
end
local deadline = os.clock() + 4
while farmActive("ShelfJob") and os.clock() < deadline and not holdingBox() do
task.wait(0.2)
end
return holdingBox()
end
while running do
awaitFarm("ShelfJob")
if Config.Autofarms.ShelfJob and mod.shelf and ensureJob("shelf_stocker", "ShelfJob") then
if not holdingBox() then
farm.shelf = nil
boxRun()
end
if holdingBox() then
local deadline = os.clock() + 6
local shelf = assignedShelf()
while farmActive("ShelfJob") and not shelf and os.clock() < deadline do
task.wait(0.2)
shelf = assignedShelf()
end
if not shelf then
failures = 0
farm.shelf = nil
boxRun()
elseif farm.reach(shelf.Position, "ShelfJob", 4) then
if pressInto(shelf, 5) then
failures = 0
local finish = os.clock() + 45
while farmActive("ShelfJob") and os.clock() < finish and farm.working() do
task.wait(0.3)
end
lastShelf, lastStock = shelf, os.clock()
farm.shelf = nil
else
failures += 1
if failures >= 3 then
failures = 0
farm.shelf = nil
boxRun()
end
end
end
end
end
end
end)
task.spawn(function()
local BAITS = { "PrawntecUltimate", "WormtecUltimate", "PrawntecPro", "WormtecPro", "PrawntecRegular", "WormtecRegular" }
local RODS = { "FishingRodUltimate", "FishingRodAdvanced", "FishingRodPro", "FishingRodRegular" }
local WATER_STEPS = { 12, 20, 28, 36, 44, 52 }
local CATCH_TIMEOUT = 40
local function waterSpot(root, maxDistance)
local params = RaycastParams.new()
params.FilterDescendantsInstances = { LocalPlayer.Character }
for _, distance in ipairs(WATER_STEPS) do
if distance <= maxDistance then
for angle = 0, 315, 45 do
local offset = Vector3.new(math.cos(math.rad(angle)) * distance, 0, math.sin(math.rad(angle)) * distance)
local hit = Workspace:Raycast(root.Position + offset + Vector3.new(0, 25, 0), Vector3.new(0, -150, 0), params)
if hit and hit.Material == Enum.Material.Water then
return hit.Position
end
end
end
end
return nil
end
local function shorePoint()
local scene = Workspace:FindFirstChild("Map")
scene = scene and scene:FindFirstChild("Fishing")
scene = scene and scene:FindFirstChild("FishingScene")
if not scene then
return nil
end
local root = localRoot()
local best, bestCost
for _, model in ipairs(scene:GetChildren()) do
if model:IsA("Model") then
local ok, pivot = pcall(model.GetPivot, model)
if ok then
local cost = root and (pivot.Position - root.Position).Magnitude or 0
if not bestCost or cost < bestCost then
best, bestCost = pivot.Position, cost
end
end
end
end
return best
end
local function fishHeld()
local total = 0
pcall(ItemUtils.iterate_through_items_of_type, Data, "fish", function(item)
if type(item) == "table" then
total += item.amount or 1
end
end)
return total
end
local nextPurchase = 0
local function canBuy()
if not Config.Autofarms.BuyBait or os.clock() < nextPurchase then
return false
end
nextPurchase = os.clock() + 60
return true
end
while running do
awaitFarm("Fish")
if Config.Autofarms.Fish and mod.rod then
local rod = farm.hold("FishingRod")
if not rod then
local item = farm.firstOfType("rod")
if not item and canBuy() then
buyFrom("ShopZone_Hardware", RODS[#RODS], 1, WALK_SPEED, "Fish")
item = farm.firstOfType("rod")
end
if equipItem(item) then
rod = farm.hold("FishingRod")
end
end
local info = rod and ItemUtils.get_item_info(Data, rod:GetAttribute("ItemGUID"))
if info and (info.ammo_amount or 0) <= 0 then
local bait = farm.firstOfType("ammo", function(item)
return type(item.name) == "string" and table.find(BAITS, item.name) ~= nil
end)
if not bait and canBuy() then
buyFrom("ShopZone_Hardware", BAITS[#BAITS], Config.Autofarms.BaitAmount, WALK_SPEED, "Fish")
bait = farm.firstOfType("ammo", function(item)
return type(item.name) == "string" and table.find(BAITS, item.name) ~= nil
end)
end
if bait then
local ok, amount, ammoType = pcall(getHook, "equip_ammo_on_item", rod:GetAttribute("ItemGUID"), bait.guid)
if ok and amount then
info.ammo_amount = amount
info.override_ammo_type = ammoType
end
end
end
local object = rod and mod.rod.class.find(rod)
if object and info and (info.ammo_amount or 0) > 0 then
local root = localRoot()
local maxDistance = object.states.max_distance.get() or 60
local spot = root and waterSpot(root, maxDistance)
if not spot then
local shore = shorePoint()
if shore and travelTo(shore, WALK_SPEED, 12, "Fish") then
root = localRoot()
spot = root and waterSpot(root, maxDistance)
end
end
if spot then
object.states.bobber_position.set(spot)
object.states.has_thrown.set(true)
local ok, thrown = pcall(getHook, "throw_rod", rod, spot)
if ok and thrown then
local deadline = os.clock() + CATCH_TIMEOUT
while farmActive("Fish") and os.clock() < deadline and object.states.has_thrown.get() do
task.wait(0.25)
end
end
if object.states.has_thrown.get() then
object.states.has_thrown.set(false)
object.states.bobber_position.set(Vector3.new())
pcall(sendHook, "cancel_throw", rod)
task.wait(1)
end
else
task.wait(1)
end
else
task.wait(1)
end
if Config.Autofarms.SellFish and fishHeld() >= Config.Autofarms.FishToSell then
local beacon = Workspace:FindFirstChild("SellFishBeacon")
local touch = beacon and beacon:FindFirstChild("TouchPart", true)
if touch and travelTo(touch.Position, WALK_SPEED, 5, "Fish") then
pcall(getHook, "sell_all_fish")
task.wait(1)
end
end
end
end
end)
task.spawn(function()
while running do
awaitFarm("Airdrop")
if Config.Autofarms.Airdrop and mod.air then
local drop = farm.nearest(mod.air.class.objects, function(_, object)
return not object.states.opened.get() and object.states.landing_stamp.get() - os.time() <= 0
end)
local prompt = drop and drop:FindFirstChildWhichIsA("ProximityPrompt", true)
if prompt then
farm.goToPrompt(prompt, "Airdrop", 6)
end
task.wait(2)
end
end
end)
end
local mainTab = window:CreateTab("Main")
local visualTab = window:CreateTab("Visuals")
local configTab = window:CreateTab("Config")
do
local silentSection = mainTab:CreateSection("Silent Aim")
silentSection:CreateToggle("Silent Aim", Config.SilentAim.Enabled, function(value)
Config.SilentAim.Enabled = value
end)
silentSection:CreateToggle("Use Prediction", Config.SilentAim.Prediction, function(value)
Config.SilentAim.Prediction = value
end)
silentSection:CreateSlider("Hit Chance %", 0, 100, Config.SilentAim.HitChance, true, function(value)
Config.SilentAim.HitChance = value
end)
silentSection:CreateToggle("Show FOV Circle", Config.Visuals.FOVCircle, function(value)
Config.Visuals.FOVCircle = value
end)
silentSection:CreateToggle("Show Target Line", Config.Visuals.TargetLine, function(value)
Config.Visuals.TargetLine = value
end)
end
local function createLinkedToggle(section, name, default, setter, style)
local linked = {}
section:CreateToggle(name, default, function(value)
setter(value)
for _, widget in ipairs(linked) do
widget:SetVisible(value)
end
end, style)
return function(widget)
table.insert(linked, widget)
widget:SetVisible(default)
end
end
do
local targetingSection = mainTab:CreateSection("Targeting")
local linkUseFOV = createLinkedToggle(targetingSection, "Use FOV Circle", Config.Targeting.UseFOV, function(value)
Config.Targeting.UseFOV = value
end)
linkUseFOV(targetingSection:CreateSlider("FOV Radius", 50, 500, Config.Targeting.FOVRadius, true, function(value)
Config.Targeting.FOVRadius = value
end))
targetingSection:CreateToggle("Target Closest Player", Config.Targeting.ClosestPlayer, function(value)
Config.Targeting.ClosestPlayer = value
end)
local linkMaxRange = createLinkedToggle(targetingSection, "Max Range", Config.Targeting.MaxRange, function(value)
Config.Targeting.MaxRange = value
end)
linkMaxRange(targetingSection:CreateSlider("Range", 50, 350, Config.Targeting.Range, true, function(value)
Config.Targeting.Range = value
end))
local linkBodyPart = createLinkedToggle(targetingSection, "Target Body Part", Config.Targeting.UseBodyPart, function(value)
Config.Targeting.UseBodyPart = value
end)
linkBodyPart(targetingSection:CreateDropdown("Body Part", TARGET_PARTS, function(value)
Config.Targeting.BodyPart = value
end, Config.Targeting.BodyPart, false))
targetingSection:CreateToggle("Aim From Crosshair", Config.Targeting.FromCrosshair, function(value)
Config.Targeting.FromCrosshair = value
end)
targetingSection:CreateToggle("Visibility Check", Config.Targeting.VisibilityCheck, function(value)
Config.Targeting.VisibilityCheck = value
end)
targetingSection:CreateToggle("Team Check", Config.Targeting.TeamCheck, function(value)
Config.Targeting.TeamCheck = value
end)
targetingSection:CreateToggle("Friend Check", Config.Targeting.FriendCheck, function(value)
Config.Targeting.FriendCheck = value
end)
targetingSection:CreateToggle("Ignore Downed", Config.Targeting.IgnoreDowned, function(value)
Config.Targeting.IgnoreDowned = value
end)
targetingSection:CreateToggle("Ignore Forcefield", Config.Targeting.IgnoreForcefield, function(value)
Config.Targeting.IgnoreForcefield = value
end)
local names = {}
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
table.insert(names, player.Name)
end
end
if #names == 0 then
table.insert(names, "-")
end
local linkWhitelist = createLinkedToggle(targetingSection, "Whitelisted Players", Config.Targeting.UseWhitelist, function(value)
Config.Targeting.UseWhitelist = value
end)
local whitelistDropdown = targetingSection:CreateDropdown("Whitelist", names, function(value)
if value == "-" then
return
end
whitelisted[value] = not whitelisted[value] or nil
end, nil, true)
linkWhitelist(whitelistDropdown)
Players.PlayerAdded:Connect(function(player)
pcall(whitelistDropdown.AddOption, whitelistDropdown, player.Name)
end)
Players.PlayerRemoving:Connect(function(player)
whitelisted[player.Name] = nil
pcall(whitelistDropdown.RemoveOption, whitelistDropdown, player.Name)
end)
end
do
local aimbotSection = mainTab:CreateSection("Aimbot")
local smoothness
local aimbotToggle = aimbotSection:CreateToggle("Aimbot", Config.Aimbot.Enabled, function(value)
Config.Aimbot.Enabled = value
if smoothness then
smoothness:SetVisible(value)
end
end)
smoothness = aimbotSection:CreateSlider("Smoothness", 1, 20, Config.Aimbot.Smoothness, true, function(value)
Config.Aimbot.Smoothness = value
end)
smoothness:SetVisible(Config.Aimbot.Enabled)
pcall(function()
aimbotToggle:CreateKeybind(Enum.KeyCode.C)
end)
end
do
local playerSection = mainTab:CreateSection("Player")
local linkSpeedBoost = createLinkedToggle(playerSection, "Speed Boost", Config.Player.SpeedBoost, function(value)
Config.Player.SpeedBoost = value
end)
linkSpeedBoost(playerSection:CreateSlider("Boost Amount", 1, 1.4, Config.Player.BoostAmount, false, function(value)
Config.Player.BoostAmount = value
end))
playerSection:CreateToggle("No Slowdown", Config.Player.NoSlowdown, function(value)
Config.Player.NoSlowdown = value
end)
playerSection:CreateToggle("Infinite Stamina", Config.Player.InfiniteStamina, function(value)
Config.Player.InfiniteStamina = value
end)
playerSection:CreateToggle("Auto Respawn", Config.Player.AutoRespawn, function(value)
Config.Player.AutoRespawn = value
end)
local linkAutoHeal = createLinkedToggle(playerSection, "Auto Heal", Config.Player.AutoHeal, function(value)
Config.Player.AutoHeal = value
end)
linkAutoHeal(playerSection:CreateSlider("Heal Below %", 10, 90, Config.Player.HealHealth, true, function(value)
Config.Player.HealHealth = value
end))
playerSection:CreateToggle("Anti Death", Config.Player.AntiDeath, function(value)
Config.Player.AntiDeath = value
end, "dangerous")
local linkFlyJump = createLinkedToggle(playerSection, "Fly Jump", Config.Player.FlyJump, function(value)
Config.Player.FlyJump = value
end)
linkFlyJump(playerSection:CreateSlider("Jump Velocity", 20, 50, Config.Player.JumpVelocity, true, function(value)
Config.Player.JumpVelocity = value
end))
end
do
local gunSection = mainTab:CreateSection("Gun Mods")
gunSection:CreateToggle("No Spread", Config.GunMods.NoSpread, function(value)
Config.GunMods.NoSpread = value
end)
local linkNoRecoil = createLinkedToggle(gunSection, "No Recoil", Config.GunMods.NoRecoil, function(value)
Config.GunMods.NoRecoil = value
end)
linkNoRecoil(gunSection:CreateSlider("Recoil %", 0, 100, Config.GunMods.RecoilPercent, true, function(value)
Config.GunMods.RecoilPercent = value
end))
local linkAccuracy = createLinkedToggle(gunSection, "Accuracy", Config.GunMods.Accuracy, function(value)
Config.GunMods.Accuracy = value
end)
linkAccuracy(gunSection:CreateSlider("Accuracy Value", 0, 1, Config.GunMods.AccuracyValue, false, function(value)
Config.GunMods.AccuracyValue = value
end))
local linkReload = createLinkedToggle(gunSection, "Reload Time", Config.GunMods.ReloadTime, function(value)
Config.GunMods.ReloadTime = value
end)
linkReload(gunSection:CreateSlider("Reload Speed", 0.1, 3, Config.GunMods.ReloadSpeed, false, function(value)
Config.GunMods.ReloadSpeed = value
end))
gunSection:CreateToggle("Automatic", Config.GunMods.Automatic, function(value)
Config.GunMods.Automatic = value
end)
end
do
local meleeSection = mainTab:CreateSection("Melee")
local linkKillAura = createLinkedToggle(meleeSection, "Kill Aura", Config.Melee.KillAura, function(value)
Config.Melee.KillAura = value
end)
linkKillAura(meleeSection:CreateSlider("Aura Range", 5, 20, Config.Melee.AuraRange, true, function(value)
Config.Melee.AuraRange = value
end))
linkKillAura(meleeSection:CreateSlider("Aura Speed", 1, 20, Config.Melee.AuraSpeed, true, function(value)
Config.Melee.AuraSpeed = value
end))
local linkExpander = createLinkedToggle(meleeSection, "Range Expander", Config.Melee.RangeExpander, function(value)
Config.Melee.RangeExpander = value
end)
linkExpander(meleeSection:CreateToggle("Hit All In Range", Config.Melee.HitAllInRange, function(value)
Config.Melee.HitAllInRange = value
end))
linkExpander(meleeSection:CreateSlider("Range", 1, 10, Config.Melee.RangeMultiplier, true, function(value)
Config.Melee.RangeMultiplier = value
end))
linkExpander(meleeSection:CreateSlider("Cone Angle", 1, 10, Config.Melee.ConeMultiplier, true, function(value)
Config.Melee.ConeMultiplier = value
end))
local linkThrowable = createLinkedToggle(meleeSection, "Throwable Aura", Config.Melee.ThrowableAura, function(value)
Config.Melee.ThrowableAura = value
end)
linkThrowable(meleeSection:CreateSlider("Throw Range", 10, 100, Config.Melee.ThrowRange, true, function(value)
Config.Melee.ThrowRange = value
end))
end
do
local vehicleSection = mainTab:CreateSection("Vehicle Mods", "left")
local vehicleWidgets = {}
local function refreshVehicleWidgets()
for _, entry in ipairs(vehicleWidgets) do
entry.widget:SetVisible(Config.Vehicle.Enabled and (entry.requires == nil or Config.Vehicle[entry.requires]))
end
end
local function addVehicleWidget(widget, requires)
table.insert(vehicleWidgets, { widget = widget, requires = requires })
refreshVehicleWidgets()
end
vehicleSection:CreateToggle("Vehicle Mods", Config.Vehicle.Enabled, function(value)
Config.Vehicle.Enabled = value
refreshVehicleWidgets()
end)
addVehicleWidget(vehicleSection:CreateToggle("Modify Speed", Config.Vehicle.ModifySpeed, function(value)
Config.Vehicle.ModifySpeed = value
refreshVehicleWidgets()
end))
addVehicleWidget(vehicleSection:CreateSlider("Speed Multiplier", 1, 1.35, Config.Vehicle.SpeedMultiplier, false, function(value)
Config.Vehicle.SpeedMultiplier = value
end), "ModifySpeed")
addVehicleWidget(vehicleSection:CreateToggle("Modify Acceleration", Config.Vehicle.ModifyAcceleration, function(value)
Config.Vehicle.ModifyAcceleration = value
refreshVehicleWidgets()
end))
addVehicleWidget(vehicleSection:CreateSlider("Accel Multiplier", 1, 1.5, Config.Vehicle.AccelMultiplier, false, function(value)
Config.Vehicle.AccelMultiplier = value
end), "ModifyAcceleration")
addVehicleWidget(vehicleSection:CreateToggle("Instant Brake", Config.Vehicle.InstantBrake, function(value)
Config.Vehicle.InstantBrake = value
end))
addVehicleWidget(vehicleSection:CreateToggle("No Crash Damage", Config.Vehicle.NoCrashDamage, function(value)
Config.Vehicle.NoCrashDamage = value
end))
end
do
local farmSection = mainTab:CreateSection("Auto Farms")
farmSection:CreateDropdown("Travel Method", TRAVEL_METHODS, function(value)
Config.Autofarms.TravelMethod = value
end, Config.Autofarms.TravelMethod, false)
local linkATMFarm = createLinkedToggle(farmSection, "Auto ATM Farm", Config.Autofarms.ATM, function(value)
Config.Autofarms.ATM = value
end)
linkATMFarm(farmSection:CreateDropdown("Preferred Hack Tool", HACK_TOOL_OPTIONS, function(value)
Config.Autofarms.HackTool = value
end, Config.Autofarms.HackTool, false))
linkATMFarm(farmSection:CreateSlider("Tools to Buy", 1, 10, Config.Autofarms.ToolsToBuy, true, function(value)
Config.Autofarms.ToolsToBuy = value
end))
farmSection:CreateToggle("Auto Deposit", Config.Autofarms.Deposit, function(value)
Config.Autofarms.Deposit = value
end)
farmSection:CreateToggle("Auto Burger Job", Config.Autofarms.BurgerJob, function(value)
Config.Autofarms.BurgerJob = value
end)
farmSection:CreateToggle("Auto Steak House", Config.Autofarms.SteakHouse, function(value)
Config.Autofarms.SteakHouse = value
end)
farmSection:CreateToggle("Auto Shelf Stocking", Config.Autofarms.ShelfJob, function(value)
Config.Autofarms.ShelfJob = value
end)
farmSection:CreateToggle("Auto Dumpster Loot", Config.Autofarms.Dumpsters, function(value)
Config.Autofarms.Dumpsters = value
end)
local linkFishing = createLinkedToggle(farmSection, "Auto Fishing", Config.Autofarms.Fish, function(value)
Config.Autofarms.Fish = value
end)
linkFishing(farmSection:CreateToggle("Buy Rod and Bait", Config.Autofarms.BuyBait, function(value)
Config.Autofarms.BuyBait = value
end))
linkFishing(farmSection:CreateSlider("Bait to Buy", 1, 20, Config.Autofarms.BaitAmount, true, function(value)
Config.Autofarms.BaitAmount = value
end))
linkFishing(farmSection:CreateToggle("Sell Caught Fish", Config.Autofarms.SellFish, function(value)
Config.Autofarms.SellFish = value
end))
linkFishing(farmSection:CreateSlider("Fish to Sell", 5, 40, Config.Autofarms.FishToSell, true, function(value)
Config.Autofarms.FishToSell = value
end))
farmSection:CreateToggle("Auto Airdrop", Config.Autofarms.Airdrop, function(value)
Config.Autofarms.Airdrop = value
end)
local earnings = farmSection:CreateLabel("")
task.spawn(function()
local function cash(amount)
local text = tostring(math.floor(amount))
local swapped
repeat
text, swapped = text:gsub("^(%-?%d+)(%d%d%d)", "%1,%2")
until swapped == 0
return "$" .. text
end
local opening
while running do
local money = Data.money
local hand = money and money.hand or 0
local bank = money and money.bank or 0
opening = opening or (hand + bank)
earnings:UpdateText(("Cash %s  |  Bank %s  |  Session %s"):format(
cash(hand), cash(bank), cash(hand + bank - opening)))
task.wait(1)
end
end)
end
do
local effectsSection = mainTab:CreateSection("Anti-Effects")
effectsSection:CreateToggle("No Ragdoll", Config.AntiEffects.NoRagdoll, function(value)
Config.AntiEffects.NoRagdoll = value
setEffectBlocked("NoRagdoll", value)
end)
effectsSection:CreateToggle("No Shell Shock", Config.AntiEffects.NoShellShock, function(value)
Config.AntiEffects.NoShellShock = value
setEffectBlocked("NoShellShock", value)
end)
effectsSection:CreateToggle("No Smoke Screen", Config.AntiEffects.NoSmokeScreen, function(value)
Config.AntiEffects.NoSmokeScreen = value
setEffectBlocked("NoSmokeScreen", value)
end)
end
do
local miscSection = mainTab:CreateSection("Misc")
miscSection:CreateToggle("Skip Crate Animation", Config.Misc.SkipCrateAnimation, function(value)
Config.Misc.SkipCrateAnimation = value
end)
miscSection:CreateToggle("Faster Prompts", Config.Misc.FasterPrompts, function(value)
Config.Misc.FasterPrompts = value
if value or next(promptOriginals) then
task.spawn(refreshPrompts)
end
end)
miscSection:CreateToggle("Auto Minigame Win", Config.Misc.AutoMinigame, function(value)
Config.Misc.AutoMinigame = value
end)
local linkAutoPickup = createLinkedToggle(miscSection, "Auto Pickup", Config.Misc.AutoPickup, function(value)
Config.Misc.AutoPickup = value
end)
linkAutoPickup(miscSection:CreateToggle("Pickup Items", Config.Misc.PickupItems, function(value)
Config.Misc.PickupItems = value
end))
linkAutoPickup(miscSection:CreateSlider("Pickup Range", 5, 12, Config.Misc.PickupRange, true, function(value)
Config.Misc.PickupRange = value
end))
end
do
local espSection = visualTab:CreateSection("ESP")
local options = {
{ "ESP", "Enabled" },
{ "Standard Boxes", "Boxes" },
{ "3D Boxes", "Boxes3D" },
{ "Box Fill", "BoxFill" },
{ "Health Bar", "HealthBar" },
{ "Health Text", "HealthText" },
{ "Health Bar Outline", "HealthOutline" },
{ "Names", "Names" },
{ "Show Weapons", "Weapons" },
{ "Distance", "Distance" },
{ "Tracers", "Tracers" },
{ "Arrows", "Arrows" },
{ "Chams", "Chams" },
}
for _, option in ipairs(options) do
local key = option[2]
espSection:CreateToggle(option[1], Config.ESP[key], function(value)
Config.ESP[key] = value
end)
end
end
do
local worldSection = visualTab:CreateSection("World ESP")
local linkWorld = createLinkedToggle(worldSection, "World ESP", Config.WorldESP.Enabled, function(value)
Config.WorldESP.Enabled = value
end)
for _, option in ipairs({
{ "Dropped Items", "Items" },
{ "Money", "Money" },
{ "Dumpsters", "Dumpsters" },
{ "Airdrops", "Airdrops" },
{ "ATMs", "ATMs" },
{ "Crates", "Crates" },
}) do
local key = option[2]
linkWorld(worldSection:CreateToggle(option[1], Config.WorldESP[key], function(value)
Config.WorldESP[key] = value
end))
end
linkWorld(worldSection:CreateSlider("World ESP Range", 50, 800, Config.WorldESP.Range, true, function(value)
Config.WorldESP.Range = value
end))
end
do
local pathSection = visualTab:CreateSection("Pathfinding")
pathSection:CreateToggle("Show Path", Config.Visuals.PathPreview, function(value)
Config.Visuals.PathPreview = value
if not value then
clearPath()
end
end)
end
do
local tracerSection = visualTab:CreateSection("Bullet Tracers")
local linkTracers = createLinkedToggle(tracerSection, "Bullet Tracers", Config.BulletTracers.Enabled, function(value)
Config.BulletTracers.Enabled = value
end)
linkTracers(tracerSection:CreateSlider("Tracer Width", 0.05, 1, Config.BulletTracers.Width, false, function(value)
Config.BulletTracers.Width = value
end))
linkTracers(tracerSection:CreateSlider("Tracer Lifetime", 0.1, 5, Config.BulletTracers.Lifetime, false, function(value)
Config.BulletTracers.Lifetime = value
end))
end
do
local fonts = {}
for _, font in ipairs(Enum.Font:GetEnumItems()) do
table.insert(fonts, font.Name)
end
local configSettings = configTab:CreateSection("Settings")
configSettings:CreateDropdown("Change Font", fonts, function(value)
window:SetFont(value)
end, "", false)
configSettings:CreateLabel("Close Menu Key (PC): " .. (tostring(gui_config.Keybind):gsub("Enum.KeyCode.", "")))
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
if getgenv then
getgenv()._KaliHubBlockSpin = function()
for key in pairs(Config.Autofarms) do
if type(Config.Autofarms[key]) == "boolean" then
Config.Autofarms[key] = false
end
end
pcall(restoreHooks)
Config.Vehicle.Enabled = false
Config.Misc.FasterPrompts = false
Config.Misc.AutoPickup = false
Config.Misc.AutoMinigame = false
Config.Misc.SkipCrateAnimation = false
pcall(restoreVehicleMods)
pcall(refreshPrompts)
pcall(function() promptConnection:Disconnect() end)
for key in pairs(Config.Player) do
if type(Config.Player[key]) == "boolean" then
Config.Player[key] = false
end
end
restoreAntiDeath(LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
if Sprint.set_walk_speed ~= realSetWalkSpeed then
Sprint.set_walk_speed = realSetWalkSpeed
end
pcall(function() playerConnection:Disconnect() end)
for key in pairs(Config.GunMods) do
if type(Config.GunMods[key]) == "boolean" then
Config.GunMods[key] = false
end
end
pcall(applyGunMods)
running = false
Config.SilentAim.Enabled = false
Config.Melee.KillAura = false
Config.Melee.RangeExpander = false
Config.Melee.ThrowableAura = false
Config.Visuals.FOVCircle = false
Config.Visuals.TargetLine = false
if Net.send == sendHook then
Net.send = realSend
end
pcall(restoreAntiCheat)
if Melee.get_hit_players == meleeHitList then
Melee.get_hit_players = realGetHitPlayers
end
Config.Aimbot.Enabled = false
Config.ESP.Enabled = false
Config.WorldESP.Enabled = false
Config.BulletTracers.Enabled = false
Config.Visuals.PathPreview = false
for _, cleanup in ipairs(cleanupTasks) do
pcall(cleanup)
end
pcall(function() if pathFolder then pathFolder:Destroy() end end)
pcall(function() renderConnection:Disconnect() end)
pcall(function() if espCleanup then espCleanup() end end)
pcall(function() if tracerCleanup then tracerCleanup() end end)
pcall(function() if fovCircle then fovCircle:Remove() end end)
pcall(function() if targetLine then targetLine:Remove() end end)
pcall(function() library:Unload() end)
end
end
