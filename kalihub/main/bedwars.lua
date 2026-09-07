--this shit was unobfuscated


shared.KaliHubUnInjected = false
local ReplicatedStorageService = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local PlayerService = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local WorkSpace = game:GetService("Workspace")
local LocalPlayer = PlayerService.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = WorkSpace.CurrentCamera
local KaliHubSettings = {}
local KaliHubConnections= {}
local KaliHubInjected = true
local AnticheatBypassing = false
local DamageBoostValue = false
local JadeHammerTick = 0
local ZephyrOrb = 0
local ClientStore, Flamework, Network, EquippedKit
local BedwarsFunctions, BedwarsMetas, BedwarsRemotes
local BedwarsUtilities, BedwarsConstants, BedwarsModules
local BedwarsKnitControllers, BedwarsControllers
local DefaultRemotePath
local CollectionServiceBlocks = CollectionService:GetTagged("block")
local UnInjectEvent = Instance.new("BindableEvent")
local stored_fonts = {}
for _, v in Enum.Font:GetEnumItems() do
table.insert(stored_fonts, v.Name)
end
gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 100, MaxHeight = 600, InitialHeight = 450,
MinWidth = 300, MaxWidth = 900, InitialWidth = 550
}
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(gui_config, gethui())
library:SetWindowName("Kali Hub | BedWars")
local function CreateNotification(time, text)
window:Notify("Kali Hub", text, time)
end
local tabs = {
combat = window:CreateTab("Combat"),
blatant = window:CreateTab("Blatant"),
settings = window:CreateTab("Settings"),
}
local sec = {
melee = tabs.combat:CreateSection("Melee"),
ranged = tabs.combat:CreateSection("Ranged"),
utility = tabs.combat:CreateSection("Utility", "right"),
movement = tabs.blatant:CreateSection("Movement"),
blocks = tabs.blatant:CreateSection("Blocks & Items"),
bmisc = tabs.blatant:CreateSection("Misc"),
settings = tabs.settings:CreateSection("Settings"),
}
KaliHubSettings = {
ProjectileAura = {Value=false, Range={Value=150}, SwitchToItem={Value=true},
Projectiles={Snowballs={Value=true}, Fireballs={Value=true}, Arrows={Value=true}},
Targets={Entities={Value=false}, Players={Value=true}}},
NoClickDelay = {Value=false},
Autoclicker = {Value=false, Cps={Value=20}},
InstantKill = {Value=false, Speed={Value=10}, Method={InfernalSaber={Value=true}, SkyScythe={Value=true}}},
AimAssist = {Value=false, FaceMobs={Value=false}, Range={Value=19}},
Velocity = {Value=false, Horizontal={Value=0}, Vertical={Value=0}},
Killaura = {Value=false, ParticleEffect={Value=true},
SwitchToWeapon={Value=true}, ShowEnemy={Value=true}, WallCheck={Value=false},
HitChance={Value=100}, Speed={Value=100}, Range={Value=19}, Angle={Value=360},
Exeptions={MouseDown={Value=false}, GuiClosed={Value=false}},
Animations={KaliHubHeartbeat={Value=false}, KaliHubClassic={Value=true}, KaliHubOld={Value=false}},
TargetBoxColor={Value="1,0.278431,0.290196"}},
AntiHit = {Value=false, AntiHitEntities={Value=false}, Speed={Value=10}, Range={Value=19}},
Reach = {Value=false},
JadeHammerExploit = {Value=false, SpamSpeed={Value=100}},
NoPlacementCPS = {Value=false},
NoFallDamage = {Value=false},
DamageBoost = {Value=false},
InfiniteJump = {Value=false},
ChestStealer = {Value=false, Range={Value=30}},
AntiLagback = {Value=false, MovementMethod={Automatic={Value=false}, Manual={Value=true}}},
TargetStrafe = {Value=false, StrafeMode={FollowPlayer={Value=true}, CirclePlayer={Value=false}},
JumpAutomatically={Value=true}, TargetMobs={Value=false}, Range={Value=18}},
HighJump = {Value=false, Height={Value=200}},
Scaffold = {Value=false, Expand={Value=2}},
Spider = {Value=false, Speed={Value=60}},
Speed = {Value=false, Speed={Value=23}},
PickupItemRange = {Value=false, Range={Value=10}},
ChatSpammer = {Value=false, Speed={Value=50}},
EntityNotifier = {Value=false},
AutoSprint = {Value=false},
AntiStaff = {Value=false, UnInject={Value=true}, Kick={Value=false}},
AntiAfk = {Value=false},
Fov = {Value=false, Fov={Value=120}},
}
function IsAlive(Player)
if not Player.Character then return false end
if not Player.Character:FindFirstChildOfClass("Humanoid") then return false end
local health = Player.Character:GetAttribute("Health")
if not health or health <= 0 then return false end
if not Player.Character.PrimaryPart then return false end
return true
end
function HasItem(Name)
for i, v in next, GetInventory(LocalPlayer).items do
if v.itemType == Name then return v end
end
return nil
end
function GetInventory(Player)
local Player = Player or LocalPlayer
if not BedwarsFunctions or not BedwarsFunctions.GetInventory then return {items = {}} end
return BedwarsFunctions.GetInventory(Player)
end
function GetSpeed()
local Speed = 0
local SpeedBoost = LocalPlayer.Character:GetAttribute("SpeedBoost")
if SpeedBoost and SpeedBoost > 1 then Speed = Speed + (8 * (SpeedBoost - 1)) end
if LocalPlayer.Character:GetAttribute("GrimReaperChannel") then Speed = Speed + 20 end
if type(ZephyrOrb) == "number" and ZephyrOrb > 0 then Speed = Speed + 19 end
if (tick() - JadeHammerTick) <= 1.4 then Speed = Speed + 30 end
if DamageBoostValue == true then Speed = Speed + 20 end
Speed = ((Speed + KaliHubSettings.Speed.Speed.Value) - 20)
return Speed
end
local function GetBlock()
for i, v in next, GetInventory(LocalPlayer).items do
local ItemMeta = BedwarsFunctions.GetItemMeta(v.itemType)
if ItemMeta and ItemMeta.block and v.itemType:find("wool") then
return v.itemType
end
end
end
local function GetBestSword(Player)
local HighestDamage, Sword = -math.huge, nil
for i, v in next, GetInventory(Player).items do
local meta = BedwarsFunctions.GetItemMeta(v.itemType)
local SwordMetaGame = meta and meta.sword
if SwordMetaGame then
local SwordDamage = (SwordMetaGame.damage / SwordMetaGame.attackSpeed)
if SwordDamage > HighestDamage then
HighestDamage = SwordDamage
Sword = v
end
end
end
return HighestDamage, Sword
end
local function GetSnowball(Player)
for i, v in next, GetInventory(Player).items do
if v.itemType:find("snowball") then
local SnowballMeta = BedwarsMetas.ProjectileMeta[v.itemType]
local GgravitationalAcceleration = (SnowballMeta.gravitationalAcceleration and SnowballMeta.gravitationalAcceleration or WorkSpace.Gravity)
local LaunchVelocity = (SnowballMeta.launchVelocity and SnowballMeta.launchVelocity or 100)
return v, GgravitationalAcceleration, LaunchVelocity
end
end
return nil, 0, nil
end
local function GetFireball(Player)
for i, v in next, GetInventory(Player).items do
if v.itemType == "fireball" then
local FireballMeta = BedwarsMetas.ProjectileMeta[v.itemType]
local GgravitationalAcceleration = (FireballMeta.gravitationalAcceleration and FireballMeta.gravitationalAcceleration or WorkSpace.Gravity)
local LaunchVelocity = (FireballMeta.launchVelocity and FireballMeta.launchVelocity or 100)
return v, GgravitationalAcceleration, LaunchVelocity
end
end
return nil, 0, nil
end
function GetBestProjectile(Projectile, Player)
local BestProjectileGgravitationalAcceleration, BestProjectileDamage, BestProjectileLaunchVelocity, BestProjectile = 0, 0, nil
for i, v in GetInventory(Player).items do
if table.find(Projectile.ammoItemTypes, v.itemType) then
local ProjectileMeta = BedwarsMetas.ProjectileMeta[v.itemType]
local GgravitationalAcceleration = (ProjectileMeta.gravitationalAcceleration and ProjectileMeta.gravitationalAcceleration or WorkSpace.Gravity)
local LaunchVelocity = (ProjectileMeta.launchVelocity and ProjectileMeta.launchVelocity or 100)
if ProjectileMeta then
local ProjectileDamage = -1
pcall(function()
if ProjectileMeta.combat.damage then
ProjectileDamage = (ProjectileMeta.combat.damage and ProjectileMeta.combat.damage or -1)
end
end)
if ProjectileDamage > BestProjectileDamage then
BestProjectileGgravitationalAcceleration = GgravitationalAcceleration
BestProjectileLaunchVelocity = LaunchVelocity
BestProjectileDamage = ProjectileDamage
BestProjectile = v
end
end
end
end
return BestProjectile, BestProjectileDamage, BestProjectileLaunchVelocity, BestProjectileGgravitationalAcceleration
end
local function GetBestProjectileLauncher(Player)
local BestProjectileGgravitationalAcceleration, BestProjectileLaunchersDPS, BestProjectileLauncherCooldown, BestProjectileLaunchVelocity, BestProjectileLauncher, BestProjectileDamage, BestProjectileType, BestProjectile = 0, 0, 0, 0, nil, 0, nil, nil
for i, v in next, GetInventory(Player).items do
local ProjectileLauncher = BedwarsFunctions.GetItemMeta(v.itemType)
if ProjectileLauncher and ProjectileLauncher.projectileSource and ProjectileLauncher.projectileSource.ammoItemTypes then
local InventoryProjectile, InventoryProjectileDamage, InventoryProjectileLaunchVelocity, InventoryProjectileGgravitationalAcceleration = GetBestProjectile(ProjectileLauncher.projectileSource, Player)
local ProjectileCooldown = ProjectileLauncher.projectileSource.fireDelaySec
if InventoryProjectile and InventoryProjectileDamage > 0 and ProjectileCooldown then
local ProjectileLaunchersDPS = (InventoryProjectileDamage / ProjectileCooldown)
if ProjectileLaunchersDPS > BestProjectileLaunchersDPS then
BestProjectileLauncherCooldown = ProjectileCooldown
BestProjectileLaunchVelocity = InventoryProjectileLaunchVelocity
BestProjectileLaunchersDPS = ProjectileLaunchersDPS
BestProjectileLauncher = v
BestProjectileDamage = InventoryProjectileDamage
BestProjectileType = ProjectileLauncher.projectileSource.projectileType(InventoryProjectile.itemType)
BestProjectile = InventoryProjectile
end
end
end
end
return BestProjectileGgravitationalAcceleration, BestProjectileLauncherCooldown, BestProjectileLaunchVelocity, BestProjectileLauncher, BestProjectileType, BestProjectile
end
local function SwitchItem(Item)
if BedwarsRemotes and BedwarsRemotes.SetInvItemRemote then
BedwarsRemotes.SetInvItemRemote:InvokeServer({hand = Item})
end
end
local function GetMatchState()
if not ClientStore then return 0 end
local ok, result = pcall(function() return ClientStore:getState().Game.matchState end)
return ok and result or 0
end
function FindNearestPlayer(MaxDistance, RaycastCheck)
RaycastCheck = RaycastCheck or false
local NearestPlayerDistance = MaxDistance or math.huge
local NearestPlayer
for i, v in next, PlayerService:GetPlayers() do
if IsAlive(v) == true and v ~= LocalPlayer and IsAlive(LocalPlayer) == true and v.Team ~= LocalPlayer.Team then
local Distance = (v.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
if RaycastCheck == true then
local RaycastParameters = RaycastParams.new()
RaycastParameters.FilterDescendantsInstances = {LocalPlayer.Character:GetDescendants(), v.Character:GetDescendants()}
RaycastParameters.FilterType = Enum.RaycastFilterType.Exclude
local Raycast = WorkSpace:Raycast(LocalPlayer.Character.PrimaryPart.Position, (v.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position), RaycastParameters)
if (not Raycast or not Raycast.Position or not Raycast.Instance) and Distance < NearestPlayerDistance then
NearestPlayerDistance = Distance
NearestPlayer = v
end
else
if Distance < NearestPlayerDistance then
NearestPlayerDistance = Distance
NearestPlayer = v
end
end
end
end
return NearestPlayer, NearestPlayerDistance
end
local function FindNearestEntity(MaxDistance, FindAPlayer)
local NearestEntityDistance, NearestEntity = (MaxDistance and MaxDistance or math.huge), nil
local IsNotAPlayer = true
FindAPlayer = FindAPlayer and FindAPlayer or false
local tags = {"Titan", "GuardianOfDream", "GolemBoss", "jellyfish", "DiamondGuardian", "Monster"}
for _, tag in ipairs(tags) do
for i, v in next, CollectionService:GetTagged(tag) do
if v.PrimaryPart and (not v:GetAttribute("Team") or v:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team")) then
local Distance = (v.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
if Distance < NearestEntityDistance then
NearestEntityDistance = Distance
NearestEntity = v
end
end
end
end
if FindAPlayer == true then
for i, v in next, PlayerService:GetPlayers() do
if IsAlive(v) == true and v ~= LocalPlayer and v.Team ~= LocalPlayer.Team then
local Distance = (v.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
if Distance < NearestEntityDistance then
NearestEntityDistance = Distance
NearestEntity = v
IsNotAPlayer = false
end
end
end
end
if NearestEntity then
return (IsNotAPlayer == true and NearestEntity or NearestEntity.Character), NearestEntityDistance
end
return nil
end
local function FindNearestChest(MaxDistance)
local NearestChest = nil
local MaxDistance = MaxDistance or math.huge
for i, v in next, CollectionService:GetTagged("chest") do
if v:FindFirstChild("ChestFolderValue") and #v:FindFirstChild("ChestFolderValue").Value:GetChildren() >= 1 then
local Distance = (v.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
if Distance < MaxDistance then
NearestChest = v
MaxDistance = Distance
end
end
end
return NearestChest
end
function FindPlacedBlock(Position)
local BlockPosition = BedwarsControllers.BlockController:getBlockPosition(Position)
return BedwarsControllers.BlockController:getStore():getBlockAt(BlockPosition), BlockPosition
end
local function GetDevidedPosition(Position)
return Vector3.new(math.round(Position.X/3), math.round(Position.Y/3), math.round(Position.Z/3))
end
local function CreateClone(KeepCape)
LocalPlayer.Character.Archivable = true
local Clone = LocalPlayer.Character:Clone()
Clone.Parent = WorkSpace
Clone.Name = "Clone"
Clone.PrimaryPart.CFrame = LocalPlayer.Character.PrimaryPart.CFrame
Camera.CameraSubject = Clone.Humanoid
task.spawn(function()
for i, v in next, Clone:FindFirstChild("Head"):GetDescendants() do v:Destroy() end
for i, v in next, Clone:GetChildren() do
if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 1 end
if v:IsA("Accessory") then v:FindFirstChild("Handle").Transparency = 1 end
end
if KeepCape == false then
for i, v in next, Clone:GetDescendants() do
if v:IsA("BasePart") and v.Name == "Cape" then v:Destroy() end
end
end
end)
return Clone
end
task.spawn(function()
repeat task.wait() until LocalPlayer.PlayerScripts:FindFirstChild("TS") and LocalPlayer.PlayerScripts.TS:FindFirstChild("ui")
local ok, result = pcall(function()
return require(LocalPlayer.PlayerScripts.TS.ui.store).ClientStore
end)
if ok and result then ClientStore = result end
end)
task.spawn(function()
repeat task.wait() until LocalPlayer.PlayerScripts:FindFirstChild("TS") and LocalPlayer.PlayerScripts.TS:FindFirstChild("lib")
local ok, result = pcall(function()
return require(LocalPlayer.PlayerScripts.TS.lib.network)
end)
if ok and result then Network = result end
end)
task.spawn(function()
repeat task.wait() until ReplicatedStorageService:FindFirstChild("rbxts_include")
local ok, result = pcall(function()
return require(ReplicatedStorageService["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
end)
if ok and result then Flamework = result end
end)
task.spawn(function()
repeat task.wait() until ClientStore ~= nil
local ok, result = pcall(function()
return ClientStore:getState().Bedwars.kit
end)
if ok then EquippedKit = result end
end)
repeat task.wait() until ClientStore ~= nil and Network ~= nil and Flamework ~= nil
local KnitGotten, Knit
task.spawn(function()
repeat
task.wait()
pcall(function()
KnitGotten, Knit = pcall(function()
return debug.getupvalue(require(LocalPlayer.PlayerScripts.TS.knit).setup, 9)
end)
end)
until KnitGotten or shared.KaliHubUnInjected == true
end)
DefaultRemotePath = ReplicatedStorageService:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged")
task.wait(1)
BedwarsKnitControllers = {
WindWalkerController = (KnitGotten and Knit.Controllers.WindWalkerController or nil),
SprintController = (KnitGotten and Knit.Controllers.SprintController or nil),
SwordController = (KnitGotten and Knit.Controllers.SwordController or nil),
FovController = (KnitGotten and Knit.Controllers.FovController or nil),
}
BedwarsControllers = {
AbilityController = Flamework.resolveDependency("@easy-games/game-core:client/controllers/ability/ability-controller@AbilityController"),
BlockController = require(ReplicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out).BlockEngine
}
BedwarsUtilities = {
InventoryUtil = require(ReplicatedStorageService.TS.inventory["inventory-util"]).InventoryUtil,
KnockbackUtil = require(ReplicatedStorageService.TS.damage["knockback-util"]).KnockbackUtil
}
BedwarsConstants = {
CombatConstant = require(ReplicatedStorageService.TS.combat["combat-constant"]).CombatConstant,
CPSConstants = require(ReplicatedStorageService.TS["shared-constants"]).CpsConstants
}
BedwarsModules = {
ControlModule = require(game.Players.LocalPlayer.PlayerScripts.PlayerModule).controls
}
BedwarsMetas = {
ProjectileMeta = require(ReplicatedStorageService.TS.projectile["projectile-meta"]).ProjectileMeta,
ItemMeta = require(ReplicatedStorageService.TS.item["item-meta"]),
}
BedwarsFunctions = {
EntityDamageEventZap = (Network and Network.EntityDamageEventZap or nil),
GetInventory = BedwarsUtilities.InventoryUtil.getInventory,
GetItemMeta = BedwarsMetas.ItemMeta.getItemMeta,
}
if not BedwarsFunctions.EntityDamageEventZap then
task.spawn(function()
repeat task.wait() until Network ~= nil
BedwarsFunctions.EntityDamageEventZap = Network.EntityDamageEventZap
end)
end
local BedwarsRemotes = {}
local function GetRemote(Name, Path)
Path = Path or DefaultRemotePath
task.spawn(function()
local Remote = Path:WaitForChild(Name, 5)
if Remote then
local Key = Name:find("/") and Name:split("/")[2] or Name
BedwarsRemotes[Key .. "Remote"] = Remote
end
end)
end
GetRemote("SummonerClawAttackRequest")
GetRemote("Inventory/SetObservedChest")
GetRemote("HellBladeRelease")
GetRemote("ProjectileFire")
GetRemote("PickupItemDrop")
GetRemote("SkyScytheSpin")
GetRemote("Inventory/ChestGetItem")
GetRemote("PlaceBlock", ReplicatedStorageService:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@easy-games"):WaitForChild("block-engine"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"))
GetRemote("SetInvItem")
GetRemote("joinQueue", ReplicatedStorageService:WaitForChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events"))
GetRemote("SwordHit")
GetRemote("AfkInfo")
task.spawn(function()
BedwarsRemotes.JoinQueueRemote = ReplicatedStorageService:WaitForChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events"):WaitForChild("joinQueue", 5)
BedwarsRemotes.BlockPlacingRemote = ReplicatedStorageService:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@easy-games"):WaitForChild("block-engine"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("PlaceBlock", 5)
end)
task.spawn(function()
CollectionService:GetInstanceAddedSignal("block"):Connect(function()
CollectionServiceBlocks = CollectionService:GetTagged("block")
end)
end)
local LocalPlayerSpeed = 0
task.spawn(function()
task.wait(1)
local LastPosition = Vector3.new(LocalPlayer.Character.PrimaryPart.Position.X, 0, LocalPlayer.Character.PrimaryPart.Position.Z)
local LastTick = tick()
repeat
task.wait(0)
local CurrentTick = tick()
local DeltaTimeSinceLastUpdate = CurrentTick - LastTick
if DeltaTimeSinceLastUpdate >= 0.2 then
if IsAlive(LocalPlayer) == true then
local CurrentPosition = Vector3.new(LocalPlayer.Character.PrimaryPart.Position.X, 0, LocalPlayer.Character.PrimaryPart.Position.Z)
LocalPlayerSpeed = (CurrentPosition - LastPosition).Magnitude / DeltaTimeSinceLastUpdate
LastPosition = CurrentPosition
LastTick = CurrentTick
end
end
until shared.KaliHubUnInjected == true
end)
task.spawn(function()
if BedwarsKnitControllers.WindWalkerController then
repeat task.wait() until GetMatchState() ~= 0
local ZephyrUpdate = BedwarsKnitControllers.WindWalkerController.updateJump
BedwarsKnitControllers.WindWalkerController.updateJump = function(self, Orb, ...)
ZephyrOrb = (IsAlive(LocalPlayer) == true and Orb or 0)
return ZephyrUpdate(self, Orb, ...)
end
end
end)
local KillauraBox = nil
local function SwordHit(Entity, Weapon, NearestEntityDistance)
task.spawn(function()
if (not Weapon or not Entity or IsAlive(LocalPlayer) == false or KaliHubSettings.Killaura.ParticleEffect.Value == false) and KillauraParticleEffect then
pcall(function() KillauraParticleEffect:Destroy() KillauraParticleEffect = nil end)
end
if (not Weapon or not Entity or IsAlive(LocalPlayer) == false or KaliHubSettings.Killaura.ShowEnemy.Value == false) and KillauraBox then
pcall(function() KillauraBox:Destroy() KillauraBox = nil end)
end
if KaliHubSettings.Killaura.ParticleEffect.Value == true and not KillauraParticleEffect and Entity then
KillauraParticleEffect = Instance.new("Part")
KillauraParticleEffect.Parent = WorkSpace
KillauraParticleEffect.Transparency = 1
KillauraParticleEffect.CanCollide = false
KillauraParticleEffect.Anchored = true
KillauraParticleEffect.Size = Vector3.new(3.63, 4.27, 0.001)
local PE = Instance.new("ParticleEmitter")
PE.Parent = KillauraParticleEffect
PE.EmissionDirection = Enum.NormalId.Front
PE.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0), NumberSequenceKeypoint.new(0.5,0.125,0), NumberSequenceKeypoint.new(1,0.55,0)})
PE.Brightness = 1
PE.Lifetime = NumberRange.new(0.75, 1.75)
PE.Texture = "rbxassetid://98715730126785"
PE.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(113/255,4/85,1)), ColorSequenceKeypoint.new(1, Color3.new(113/255,4/85,1))})
PE.Speed = NumberRange.new(3)
PE.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.6,0), NumberSequenceKeypoint.new(1,0,0)})
PE.Rate = 23
end
if KaliHubSettings.Killaura.ShowEnemy.Value == true and not KillauraBox and Entity then
KillauraBox = Instance.new("Part")
KillauraBox.Parent = WorkSpace
KillauraBox.Name = "KillauraBox"
KillauraBox.Transparency = 0.6
KillauraBox.CanCollide = false
KillauraBox.CanQuery = false
KillauraBox.Anchored = true
KillauraBox.Material = Enum.Material.SmoothPlastic
KillauraBox.Size = Vector3.new(4,6,4)
local cs = string.split(KaliHubSettings.Killaura.TargetBoxColor.Value, ",")
KillauraBox.Color = Color3.new(tonumber(cs[1]), tonumber(cs[2]), tonumber(cs[3]))
end
if KillauraParticleEffect then
KillauraParticleEffect.CFrame = (Entity.PrimaryPart.CFrame - (Entity.PrimaryPart.CFrame.LookVector * 1.2))
end
if KillauraBox then
KillauraBox.CFrame = Entity.PrimaryPart.CFrame
local cs = string.split(KaliHubSettings.Killaura.TargetBoxColor.Value, ",")
KillauraBox.Color = Color3.new(tonumber(cs[1]), tonumber(cs[2]), tonumber(cs[3]))
end
end)
local LookVector = LocalPlayer.Character.PrimaryPart.CFrame.LookVector
local Unit = (Entity.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Unit
local Angle = math.acos(Unit:Dot(LookVector))
if Angle > math.rad((KaliHubSettings.Killaura.Angle.Value / 2)) then return end
if KaliHubSettings.Killaura.WallCheck.Value == true then
local RaycastParameters = RaycastParams.new()
RaycastParameters.FilterDescendantsInstances = {CollectionServiceBlocks}
RaycastParameters.FilterType = Enum.RaycastFilterType.Include
local Raycast = WorkSpace:Raycast(LocalPlayer.Character.PrimaryPart.Position, Entity.PrimaryPart.Position, RaycastParameters)
if Raycast and Raycast.Position then return end
end
if KaliHubSettings.Killaura.Exeptions.MouseDown.Value == true and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
task.spawn(function()
if KaliHubSettings.Killaura.SwitchToWeapon.Value == true and Weapon then SwitchItem(Weapon.tool) end
end)
local LocalPlayerHumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
local EntityPrimaryPart = Entity.PrimaryPart
local Magnitude = (LocalPlayerHumanoidRootPart.Position - EntityPrimaryPart.Position).Magnitude
local LookVector2 = CFrame.lookAt(LocalPlayerHumanoidRootPart.Position, EntityPrimaryPart.Position).LookVector
local SelfPosition = ((math.max(Magnitude - 14.39999, 0) * LookVector2) + LocalPlayer.Character.PrimaryPart.Position)
task.spawn(function()
if Weapon and BedwarsRemotes and BedwarsRemotes.SwordHitRemote then
BedwarsRemotes.SwordHitRemote:FireServer({
weapon = Weapon.tool,
chargedAttack = {chargeRatio = 0},
entityInstance = Entity,
validate = {
raycast = {
cameraPosition = {value = LocalPlayerHumanoidRootPart.Position},
cursorDirection = {value = CFrame.new(SelfPosition, EntityPrimaryPart.Position).lookVector}
},
targetPosition = {value = EntityPrimaryPart.Position},
selfPosition = {value = SelfPosition}
}
})
end
end)
task.spawn(function()
if EquippedKit == "summoner" and BedwarsRemotes and BedwarsRemotes.SummonerClawAttackRequestRemote then
BedwarsRemotes.SummonerClawAttackRequestRemote:FireServer({clientTime=tick(), direction=LocalPlayer.Character.PrimaryPart.CFrame.LookVector, position=LocalPlayer.Character.PrimaryPart.Position})
end
end)
end
KaliHubConnections["KillauraConnection"] = RunService.Heartbeat:Connect(function()
local HitChance = (KaliHubSettings.Killaura.HitChance.Value == 100 and 1 or math.random(1, math.max(1, math.floor(100 / KaliHubSettings.Killaura.HitChance.Value))))
if IsAlive(LocalPlayer) == true and GetMatchState() ~= 0 and HitChance == 1 and KaliHubSettings.Killaura.Value == true then
local NearestEntity, NearestEntityDistance = FindNearestEntity(KaliHubSettings.Killaura.Range.Value, true)
local HighestDamage, Sword = GetBestSword(LocalPlayer)
task.spawn(function()
if NearestEntity then SwordHit(NearestEntity, Sword, NearestEntityDistance) end
if not Sword or not NearestEntity or not IsAlive(LocalPlayer) then
pcall(function() if KillauraParticleEffect then KillauraParticleEffect:Destroy() KillauraParticleEffect = nil end end)
pcall(function() if KillauraBox then KillauraBox:Destroy() KillauraBox = nil end end)
end
end)
end
end)
UnInjectEvent.Event:Connect(function()
if KillauraParticleEffect then KillauraParticleEffect:Destroy() end
if KillauraBox then KillauraBox:Destroy() end
end)
task.spawn(function()
repeat task.wait() until BedwarsFunctions.EntityDamageEventZap ~= nil
BedwarsFunctions.EntityDamageEventZap.On(function(Player, Damage)
if IsAlive(LocalPlayer) == true and Player.Name == LocalPlayer.Name and Damage > 4 and GetMatchState() ~= 0 and KaliHubSettings.DamageBoost.Value == true and shared.KaliHubUnInjected == false and KaliHubInjected == true then
DamageBoostValue = true
task.wait(0.6)
DamageBoostValue = false
end
end)
end)
local FireDelays = {Snowballs=tick(), Fireballs=tick(), Arrows=tick()}
local function PredictMovement(GravitationalAcceleration, LaunchSpeed, TargetPosition, TargetVelocity, TargetHipHeight, TargetJump)
local PredictedEnemyPosition = TargetPosition
local VerticalOffset = Vector3.new(0, (TargetHipHeight + TargetJump), 0)
local Gravity = Vector3.new(0, -math.abs(GravitationalAcceleration), 0)
local Origin = (Camera and Camera.CFrame.Position or Vector3.zero)
local Distance = (TargetPosition - Origin).Magnitude
local Time = (Distance / math.max(LaunchSpeed, 1))
for i = 1, 40 do
task.spawn(function()
local FutureTargetPosition = (TargetPosition + VerticalOffset + (TargetVelocity * Time))
local Displacement = (FutureTargetPosition - Origin - (0.5 * Gravity * Time * Time))
local RequiredVelocity = (Displacement / Time)
local RequiredSpeed = RequiredVelocity.Magnitude
Time = (Time * (RequiredSpeed / math.max(LaunchSpeed, 0.001)))
end)
end
PredictedEnemyPosition = (TargetPosition + VerticalOffset + (TargetVelocity * Time))
return PredictedEnemyPosition
end
local function CreateProjectileGUID()
local GUID = HttpService:GenerateGUID(false)
return string.upper((GUID:split("-"))[1])
end
sec.melee:CreateToggle("Killaura", false, function(value)
KaliHubSettings.Killaura.Value = value
end)
sec.melee:CreateToggle("ParticleEffect", true, function(value)
KaliHubSettings.Killaura.ParticleEffect.Value = value
end)
sec.melee:CreateToggle("SwitchToWeapon", true, function(value)
KaliHubSettings.Killaura.SwitchToWeapon.Value = value
end)
sec.melee:CreateToggle("ShowEnemy", true, function(value)
KaliHubSettings.Killaura.ShowEnemy.Value = value
end)
sec.melee:CreateToggle("WallCheck", false, function(value)
KaliHubSettings.Killaura.WallCheck.Value = value
end)
sec.melee:CreateSlider("Killaura HitChance", 1, 100, 100, true, function(value)
KaliHubSettings.Killaura.HitChance.Value = value
end)
sec.melee:CreateSlider("Killaura Speed", 1, 100, 100, true, function(value)
KaliHubSettings.Killaura.Speed.Value = value
end)
sec.melee:CreateSlider("Killaura Range", 1, 19, 19, true, function(value)
KaliHubSettings.Killaura.Range.Value = value
end)
sec.melee:CreateSlider("Killaura Angle", 1, 360, 360, true, function(value)
KaliHubSettings.Killaura.Angle.Value = value
end)
sec.melee:CreateToggle("RequireMouseDown", false, function(value)
KaliHubSettings.Killaura.Exeptions.MouseDown.Value = value
end)
sec.melee:CreateColorpicker("Killaura TargetBoxColor", function(color, transparency)
KaliHubSettings.Killaura.TargetBoxColor.Value = tostring(color.R .. "," .. color.G .. "," .. color.B)
end)
sec.melee:CreateToggle("AntiHit", false, function(value)
KaliHubSettings.AntiHit.Value = value
if value then
task.spawn(function()
repeat
task.wait()
if IsAlive(LocalPlayer) == true and GetMatchState() ~= 0 and KaliHubSettings.AntiHit.Value == true then
local NearestPlayer = FindNearestPlayer(KaliHubSettings.AntiHit.Range.Value)
local NearestEntity = FindNearestEntity(KaliHubSettings.AntiHit.Range.Value, false)
if NearestPlayer then
local Clone = CreateClone(true)
LocalPlayer.Character.PrimaryPart.CFrame = (LocalPlayer.Character.PrimaryPart.CFrame + Vector3.new(0,10000,0))
task.spawn(function()
repeat task.wait()
if IsAlive(LocalPlayer) and Clone then Clone.PrimaryPart.Position = Vector3.new(LocalPlayer.Character.PrimaryPart.Position.X, Clone.PrimaryPart.Position.Y, LocalPlayer.Character.PrimaryPart.Position.Z) end
until KaliHubSettings.KaliHubUnInjected == true or KaliHubSettings.AntiHit.Value == false
end)
task.wait(1 / math.random(KaliHubSettings.AntiHit.Speed.Value / 1.3, KaliHubSettings.AntiHit.Speed.Value))
if IsAlive(LocalPlayer) then
LocalPlayer.Character.PrimaryPart.Velocity = Vector3.new(LocalPlayer.Character.PrimaryPart.Velocity.X, -1, LocalPlayer.Character.PrimaryPart.Velocity.Z)
LocalPlayer.Character.PrimaryPart.CFrame = Clone.PrimaryPart.CFrame
Camera.CameraSubject = LocalPlayer.Character
Clone:Destroy()
end
task.wait(0.1)
end
end
until shared.KaliHubUnInjected == true or KaliHubSettings.AntiHit.Value == false
end)
end
end)
sec.melee:CreateSlider("AntiHit Speed", 1, 10, 10, true, function(value)
KaliHubSettings.AntiHit.Speed.Value = value
end)
sec.melee:CreateSlider("AntiHit Range", 1, 19, 19, true, function(value)
KaliHubSettings.AntiHit.Range.Value = value
end)
task.spawn(function()
local OldSwingSwordAtMouse
local OldReach = BedwarsConstants.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE
sec.melee:CreateToggle("Reach", false, function(value)
KaliHubSettings.Reach.Value = value
if value then
task.spawn(function()
repeat
task.wait()
if IsAlive(LocalPlayer) == true then
local NearestEntity, NearestEntityDistance = FindNearestEntity(KaliHubSettings.Killaura.Range.Value, true)
if NearestEntity then BedwarsConstants.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = (NearestEntityDistance + 2) end
end
until shared.KaliHubUnInjected == true or KaliHubSettings.Reach.Value == false
BedwarsConstants.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = OldReach
end)
if BedwarsKnitControllers.SwordController then
OldSwingSwordAtMouse = BedwarsKnitControllers.SwordController.swingSwordAtMouse
BedwarsKnitControllers.SwordController.swingSwordAtMouse = function(Enabled, LastSwing, BufferedMobileAttack, ...)
BufferedMobileAttack = true
return OldSwingSwordAtMouse(Enabled, LastSwing, BufferedMobileAttack, ...)
end
end
else
BedwarsConstants.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = OldReach
if BedwarsKnitControllers.SwordController and OldSwingSwordAtMouse then
BedwarsKnitControllers.SwordController.swingSwordAtMouse = OldSwingSwordAtMouse
end
end
end)
UnInjectEvent.Event:Connect(function()
BedwarsConstants.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = OldReach
if BedwarsKnitControllers.SwordController and OldSwingSwordAtMouse then
BedwarsKnitControllers.SwordController.swingSwordAtMouse = OldSwingSwordAtMouse
end
end)
end)
task.spawn(function()
local OldApplyKnockback = BedwarsUtilities.KnockbackUtil.applyKnockback
sec.melee:CreateToggle("Velocity", false, function(value)
KaliHubSettings.Velocity.Value = value
if value then
OldApplyKnockback = BedwarsUtilities.KnockbackUtil.applyKnockback
BedwarsUtilities.KnockbackUtil.applyKnockback = function(Root, Mass, Direction, Knockback, ...)
Knockback = Knockback or {}
local Horizontal = (Knockback.horizontal and Knockback.horizontal or 1)
local Vertical = (Knockback.vertical and Knockback.vertical or 1)
Knockback.horizontal = (Horizontal * (KaliHubSettings.Velocity.Horizontal.Value / 100))
Knockback.vertical = (Vertical * (KaliHubSettings.Velocity.Vertical.Value / 100))
return OldApplyKnockback(Root, Mass, Direction, Knockback, ...)
end
else
BedwarsUtilities.KnockbackUtil.applyKnockback = OldApplyKnockback
end
end)
sec.melee:CreateSlider("Horizontal KB", 0, 100, 0, true, function(value)
KaliHubSettings.Velocity.Horizontal.Value = value
end)
sec.melee:CreateSlider("Vertical KB", 0, 100, 0, true, function(value)
KaliHubSettings.Velocity.Vertical.Value = value
end)
UnInjectEvent.Event:Connect(function()
BedwarsUtilities.KnockbackUtil.applyKnockback = OldApplyKnockback
end)
end)
task.spawn(function()
if BedwarsKnitControllers.SwordController then
local OldIsClickingTooFast
sec.melee:CreateToggle("NoClickDelay", false, function(value)
KaliHubSettings.NoClickDelay.Value = value
if value then
OldIsClickingTooFast = BedwarsKnitControllers.SwordController.isClickingTooFast
BedwarsKnitControllers.SwordController.isClickingTooFast = function(self)
self.lastSwing = tick()
return false
end
else
if OldIsClickingTooFast then
BedwarsKnitControllers.SwordController.isClickingTooFast = OldIsClickingTooFast
end
end
end)
end
end)
task.spawn(function()
if BedwarsKnitControllers.SwordController then
sec.melee:CreateToggle("Autoclicker", false, function(value)
KaliHubSettings.Autoclicker.Value = value
if value then
task.spawn(function()
repeat
task.wait(1 / KaliHubSettings.Autoclicker.Cps.Value)
BedwarsKnitControllers.SwordController:swingSwordAtMouse((1 / KaliHubSettings.Autoclicker.Cps.Value) + 0.01)
until shared.KaliHubUnInjected == true or KaliHubSettings.Autoclicker.Value == false
end)
end
end)
sec.melee:CreateSlider("Autoclicker CPS", 1, 100, 20, true, function(value)
KaliHubSettings.Autoclicker.Cps.Value = value
end)
end
end)
sec.ranged:CreateToggle("AimAssist", false, function(value)
KaliHubSettings.AimAssist.Value = value
if value then
task.spawn(function()
repeat
task.wait()
if IsAlive(LocalPlayer) == true and GetMatchState() ~= 0 then
local NearestPlayer = FindNearestPlayer(KaliHubSettings.AimAssist.Range.Value)
local NearestEntity = FindNearestEntity(KaliHubSettings.AimAssist.Range.Value, false)
if NearestPlayer or NearestEntity then
local NearestEntityPrimaryPart = (KaliHubSettings.AimAssist.FaceMobs.Value == true and (NearestEntity and NearestEntity.PrimaryPart or nil) or (NearestPlayer and NearestPlayer.Character.PrimaryPart or nil))
if NearestEntityPrimaryPart then
local LookVector = (NearestEntityPrimaryPart.Position - Camera.CFrame.Position).Unit
Camera.CFrame = CFrame.new(Camera.CFrame.Position, (Camera.CFrame.Position + LookVector))
end
end
end
until shared.KaliHubUnInjected == true or KaliHubSettings.AimAssist.Value == false
end)
end
end)
sec.ranged:CreateToggle("AimAssist FaceMobs", false, function(value)
KaliHubSettings.AimAssist.FaceMobs.Value = value
end)
sec.ranged:CreateSlider("AimAssist Range", 1, 19, 19, true, function(value)
KaliHubSettings.AimAssist.Range.Value = value
end)
sec.ranged:CreateToggle("ProjectileAura", false, function(value)
KaliHubSettings.ProjectileAura.Value = value
if value then
task.spawn(function()
repeat
task.wait(0)
local TargetEntity
if KaliHubSettings.ProjectileAura.Targets.Entities.Value == true then
local NearestEntity = FindNearestEntity(KaliHubSettings.ProjectileAura.Range.Value, false)
if NearestEntity then TargetEntity = {PrimaryPart=NearestEntity.PrimaryPart, Humanoid={HipHeight=(NearestEntity.Humanoid and NearestEntity.Humanoid.HipHeight or 0), Jump=(NearestEntity.Humanoid and NearestEntity.Humanoid.Jump or false)}} end
end
if KaliHubSettings.ProjectileAura.Targets.Players.Value == true then
local NearestPlayer = FindNearestPlayer(KaliHubSettings.ProjectileAura.Range.Value, true)
if NearestPlayer then TargetEntity = NearestPlayer.Character end
end
if TargetEntity then
task.spawn(function()
if KaliHubSettings.ProjectileAura.Projectiles.Snowballs.Value == true then
local Snowball, GgravitationalAcceleration, LaunchVelocity = GetSnowball(LocalPlayer)
if Snowball and (tick() - FireDelays.Snowballs) > 0.1 then
FireDelays.Snowballs = tick()
if KaliHubSettings.ProjectileAura.SwitchToItem.Value then SwitchItem(Snowball.tool) end
local Prediction = PredictMovement(GgravitationalAcceleration, LaunchVelocity, TargetEntity.PrimaryPart.Position, TargetEntity.PrimaryPart.Velocity, TargetEntity.Humanoid.HipHeight, (TargetEntity.Humanoid.Jump and 0.5 or 0))
local Direction = CFrame.lookAt(LocalPlayer.Character.PrimaryPart.Position, (Prediction - Vector3.new(0,4,0))).LookVector * LaunchVelocity
BedwarsRemotes.ProjectileFireRemote:InvokeServer(Snowball.tool, Snowball.itemType, Snowball.itemType, LocalPlayer.Character.Head.Position, LocalPlayer.Character.PrimaryPart.Position, Direction, CreateProjectileGUID(), {shotId=CreateProjectileGUID(), drawDurationSec=0}, WorkSpace:GetServerTimeNow()-0.045)
end
end
end)
task.spawn(function()
if KaliHubSettings.ProjectileAura.Projectiles.Fireballs.Value == true then
local Fireball, GgravitationalAcceleration, LaunchVelocity = GetFireball(LocalPlayer)
if Fireball and (tick() - FireDelays.Fireballs) > 0.1 then
FireDelays.Fireballs = tick()
if KaliHubSettings.ProjectileAura.SwitchToItem.Value then SwitchItem(Fireball.tool) end
local Prediction = PredictMovement(GgravitationalAcceleration, LaunchVelocity, TargetEntity.PrimaryPart.Position, TargetEntity.PrimaryPart.Velocity, TargetEntity.Humanoid.HipHeight, (TargetEntity.Humanoid.Jump and 0.5 or 0))
local Direction = CFrame.lookAt(LocalPlayer.Character.PrimaryPart.Position, (Prediction - Vector3.new(0,4,0))).LookVector * LaunchVelocity
BedwarsRemotes.ProjectileFireRemote:InvokeServer(Fireball.tool, Fireball.itemType, Fireball.itemType, LocalPlayer.Character.Head.Position, LocalPlayer.Character.PrimaryPart.Position, Direction, CreateProjectileGUID(), {shotId=CreateProjectileGUID(), drawDurationSec=0}, WorkSpace:GetServerTimeNow()-0.045)
end
end
end)
task.spawn(function()
if KaliHubSettings.ProjectileAura.Projectiles.Arrows.Value == true then
local BestProjectileGgravitationalAcceleration, BestProjectileLauncherCooldown, BestProjectileLaunchVelocity, BestProjectileLauncher, BestProjectileType, BestProjectile = GetBestProjectileLauncher(LocalPlayer)
if BestProjectileLauncherCooldown and BestProjectileLauncher and BestProjectile and (tick() - FireDelays.Arrows) > BestProjectileLauncherCooldown then
FireDelays.Arrows = tick()
if KaliHubSettings.ProjectileAura.SwitchToItem.Value then SwitchItem(BestProjectileLauncher.tool) end
local Prediction = PredictMovement(BestProjectileGgravitationalAcceleration, BestProjectileLaunchVelocity, TargetEntity.PrimaryPart.Position, TargetEntity.PrimaryPart.Velocity, TargetEntity.Humanoid.HipHeight, (TargetEntity.Humanoid.Jump and -6 or 0))
local Magnitude = (LocalPlayer.Character.PrimaryPart.Position - TargetEntity.PrimaryPart.Position).Magnitude
local MagnitudeAmplification = (TargetEntity.Humanoid.Jump and (Magnitude > 50 and Magnitude/150 or Magnitude > 100 and Magnitude/65 or Magnitude > 150 and Magnitude/30) or 0)
local Direction = CFrame.lookAt(LocalPlayer.Character.PrimaryPart.Position, (Prediction + Vector3.new(0,MagnitudeAmplification,0))).LookVector * BestProjectileLaunchVelocity
BedwarsRemotes.ProjectileFireRemote:InvokeServer(BestProjectileLauncher.tool, BestProjectile.itemType, BestProjectileType, LocalPlayer.Character.Head.Position, LocalPlayer.Character.PrimaryPart.Position, Direction, CreateProjectileGUID(), {shotId=CreateProjectileGUID(), drawDurationSec=(BestProjectileLauncher.itemType == "wood_bow" and 0.85 or 0)}, WorkSpace:GetServerTimeNow()-0.045)
end
end
end)
end
until KaliHubSettings.ProjectileAura.Value == false or shared.KaliHubUnInjected == true
end)
end
end)
sec.ranged:CreateToggle("PA SwitchToItem", true, function(value) KaliHubSettings.ProjectileAura.SwitchToItem.Value = value end)
sec.ranged:CreateToggle("PA Snowballs", true, function(value) KaliHubSettings.ProjectileAura.Projectiles.Snowballs.Value = value end)
sec.ranged:CreateToggle("PA Fireballs", true, function(value) KaliHubSettings.ProjectileAura.Projectiles.Fireballs.Value = value end)
sec.ranged:CreateToggle("PA Arrows", true, function(value) KaliHubSettings.ProjectileAura.Projectiles.Arrows.Value = value end)
sec.ranged:CreateToggle("PA Target Entities", false, function(value) KaliHubSettings.ProjectileAura.Targets.Entities.Value = value end)
sec.ranged:CreateToggle("PA Target Players", true, function(value) KaliHubSettings.ProjectileAura.Targets.Players.Value = value end)
sec.ranged:CreateSlider("PA Range", 1, 200, 150, true, function(value) KaliHubSettings.ProjectileAura.Range.Value = value end)
sec.ranged:CreateToggle("InstantKill", false, function(value)
KaliHubSettings.InstantKill.Value = value
if value then
task.spawn(function()
repeat
task.wait(1 / KaliHubSettings.InstantKill.Speed.Value)
if IsAlive(LocalPlayer) == true then
local NearestEntity = FindNearestEntity(18, true)
if GetMatchState() ~= 0 and NearestEntity then
if KaliHubSettings.InstantKill.Method.InfernalSaber.Value == true then
local InfernalSaber = HasItem("infernal_saber")
if InfernalSaber then BedwarsRemotes.HellBladeReleaseRemote:FireServer({chargeTime=1.2, player=LocalPlayer, weapon=InfernalSaber}) end
end
if KaliHubSettings.InstantKill.Method.SkyScythe.Value == true then
local SkyScythe = HasItem("sky_scythe")
if SkyScythe then BedwarsRemotes.SkyScytheSpinRemote:FireServer() end
end
end
end
until KaliHubSettings.InstantKill.Value == false or shared.KaliHubUnInjected == true
end)
end
end)
sec.ranged:CreateSlider("IK Speed", 1, 10, 10, true, function(value) KaliHubSettings.InstantKill.Speed.Value = value end)
sec.ranged:CreateToggle("IK InfernalSaber", true, function(value) KaliHubSettings.InstantKill.Method.InfernalSaber.Value = value end)
sec.ranged:CreateToggle("IK SkyScythe", true, function(value) KaliHubSettings.InstantKill.Method.SkyScythe.Value = value end)
sec.movement:CreateToggle("Speed", false, function(value)
KaliHubSettings.Speed.Value = value
if value then
KaliHubConnections["SpeedConnection"] = RunService.Heartbeat:Connect(function(Delta)
if IsAlive(LocalPlayer) == true then
local SpeedRaycastParameters = RaycastParams.new()
SpeedRaycastParameters.FilterDescendantsInstances = {CollectionServiceBlocks}
SpeedRaycastParameters.FilterType = Enum.RaycastFilterType.Include
local SpeedValue = GetSpeed()
local ExtraSpeedValue = ((LocalPlayerSpeed > 23 and LocalPlayerSpeed < 23.33) and 23.33 - LocalPlayerSpeed or 0)
local SpeedPosition = (LocalPlayer.Character.Humanoid.MoveDirection * ((SpeedValue + ExtraSpeedValue) * Delta))
local Raycast = WorkSpace:Raycast(LocalPlayer.Character.PrimaryPart.Position, SpeedPosition, SpeedRaycastParameters)
if not Raycast then
LocalPlayer.Character.PrimaryPart.CFrame = (LocalPlayer.Character.PrimaryPart.CFrame + SpeedPosition)
end
end
end)
else
if KaliHubConnections["SpeedConnection"] then KaliHubConnections["SpeedConnection"]:Disconnect() end
end
end)
sec.movement:CreateSlider("Speed Value", 1, 23, 23, true, function(value)
KaliHubSettings.Speed.Speed.Value = value
end)
sec.movement:CreateToggle("HighJump", false, function(value)
KaliHubSettings.HighJump.Value = value
if value and IsAlive(LocalPlayer) == true and AnticheatBypassing == false then
task.spawn(function()
for i = 1, 3 do
if IsAlive(LocalPlayer) == true then
LocalPlayer.Character.PrimaryPart.Velocity = Vector3.new(LocalPlayer.Character.PrimaryPart.Velocity.X, 0, LocalPlayer.Character.PrimaryPart.Velocity.Z)
LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(LocalPlayer.Character.PrimaryPart.Position + Vector3.new(0, (KaliHubSettings.HighJump.Height.Value / 3), 0))
task.wait(0.2)
end
end
KaliHubSettings.HighJump.Value = false
end)
end
end)
sec.movement:CreateSlider("HighJump Height", 1, 200, 200, true, function(value) KaliHubSettings.HighJump.Height.Value = value end)
sec.movement:CreateToggle("TargetStrafe", false, function(value)
KaliHubSettings.TargetStrafe.Value = value
if value then
local EnemyMoveDirection = "Nil"
local Angle = 0
task.spawn(function()
repeat
task.wait()
if IsAlive(LocalPlayer) == true and GetMatchState() ~= 0 then
local NearestPlayer = FindNearestPlayer(KaliHubSettings.TargetStrafe.Range.Value + 4)
if NearestPlayer then
Angle = Angle + (KaliHubSettings.TargetStrafe.StrafeMode.CirclePlayer.Value and 2 or -2)
local TargetPosition = NearestPlayer.Character.PrimaryPart.Position
local StrafeOffset = CFrame.Angles(0, math.rad(Angle), 0) * Vector3.new(KaliHubSettings.TargetStrafe.Range.Value, 0, 0)
LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(TargetPosition + StrafeOffset, TargetPosition)
if KaliHubSettings.TargetStrafe.JumpAutomatically.Value == true then
LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end
until shared.KaliHubUnInjected == true or KaliHubSettings.TargetStrafe.Value == false
end)
end
end)
sec.movement:CreateToggle("Strafe JumpAuto", true, function(value) KaliHubSettings.TargetStrafe.JumpAutomatically.Value = value end)
sec.movement:CreateToggle("Strafe TargetMobs", false, function(value) KaliHubSettings.TargetStrafe.TargetMobs.Value = value end)
sec.movement:CreateSlider("Strafe Range", 1, 18, 18, true, function(value) KaliHubSettings.TargetStrafe.Range.Value = value end)
sec.movement:CreateDropdown("StrafeMode", {"FollowPlayer","CirclePlayer"}, function(value)
KaliHubSettings.TargetStrafe.StrafeMode.FollowPlayer.Value = (value == "FollowPlayer")
KaliHubSettings.TargetStrafe.StrafeMode.CirclePlayer.Value = (value == "CirclePlayer")
end, "FollowPlayer", false)
sec.movement:CreateToggle("Spider", false, function(value)
KaliHubSettings.Spider.Value = value
if value then
KaliHubConnections["SpiderConnection"] = RunService.Heartbeat:Connect(function(Delta)
if IsAlive(LocalPlayer) == true then
local MoveDirection = LocalPlayer.Character.Humanoid.MoveDirection
local BlockRay = FindPlacedBlock(LocalPlayer.Character.PrimaryPart.Position + ((MoveDirection * 2) - Vector3.new(0, LocalPlayer.Character.Humanoid.HipHeight, 0)))
if BlockRay then
LocalPlayer.Character.PrimaryPart.Velocity = Vector3.new(0, KaliHubSettings.Spider.Speed.Value, LocalPlayer.Character.PrimaryPart.Velocity.Z)
end
end
end)
else
if KaliHubConnections["SpiderConnection"] then KaliHubConnections["SpiderConnection"]:Disconnect() end
end
end)
sec.movement:CreateSlider("Spider Speed", 1, 100, 60, true, function(value) KaliHubSettings.Spider.Speed.Value = value end)
sec.movement:CreateToggle("InfiniteJump", false, function(value)
KaliHubSettings.InfiniteJump.Value = value
if value then
KaliHubConnections["InfiniteJumpConnection"] = UserInputService.JumpRequest:Connect(function()
if not shared.KaliHubUnInjected and IsAlive(LocalPlayer) then
LocalPlayer.Character.Humanoid:ChangeState("Jumping")
end
end)
else
if KaliHubConnections["InfiniteJumpConnection"] then KaliHubConnections["InfiniteJumpConnection"]:Disconnect() end
end
end)
task.spawn(function()
local OldMoveFunction = BedwarsModules.ControlModule.moveFunction
local ALBClone
sec.movement:CreateToggle("AntiLagback", false, function(value)
KaliHubSettings.AntiLagback.Value = value
if value then
KaliHubConnections["AntiLagbackConnection"] = LocalPlayer:GetAttributeChangedSignal("LastTeleported"):Connect(function()
if IsAlive(LocalPlayer) == true and GetMatchState() ~= 0 and not LocalPlayer.Character:FindFirstChildWhichIsA("ForceField") then
CreateNotification(2, "Lagback Detected, Attempting Bypass")
AnticheatBypassing = true
ALBClone = CreateClone(false)
BedwarsModules.ControlModule.moveFunction = function(Self, Vec, ...)
local LookVector = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z).Unit
if ALBClone and ALBClone.PrimaryPart then
local RaycastParameters = RaycastParams.new()
RaycastParameters.FilterDescendantsInstances = {CollectionServiceBlocks}
RaycastParameters.FilterType = Enum.RaycastFilterType.Include
local Raycast = WorkSpace:Raycast((ALBClone.PrimaryPart.Position + LookVector), Vector3.new(0,-1000,0), RaycastParameters)
local Raycast2 = WorkSpace:Raycast(((ALBClone.PrimaryPart.Position - Vector3.new(0,15,0)) + (LookVector * 5)), Vector3.new(0,-1000,0), RaycastParameters)
if Raycast or Raycast2 then
ALBClone.PrimaryPart.CFrame = CFrame.new(ALBClone.PrimaryPart.Position + (LookVector / (11 / GetSpeed())))
Vec = LookVector
end
end
return OldMoveFunction(Self, Vec, ...)
end
task.wait(4.5)
BedwarsModules.ControlModule.moveFunction = OldMoveFunction
if IsAlive(LocalPlayer) == true then
Camera.CameraSubject = LocalPlayer.Character.Humanoid
if ALBClone then ALBClone:Destroy() end
AnticheatBypassing = false
CreateNotification(2, "Successfully Bypassed Lagback")
else
if ALBClone then ALBClone:Destroy() end
AnticheatBypassing = false
end
end
end)
else
if KaliHubConnections["AntiLagbackConnection"] then KaliHubConnections["AntiLagbackConnection"]:Disconnect() end
BedwarsModules.ControlModule.moveFunction = OldMoveFunction
end
end)
UnInjectEvent.Event:Connect(function()
BedwarsModules.ControlModule.moveFunction = OldMoveFunction
end)
end)
sec.blocks:CreateToggle("JadeHammerExploit", false, function(value)
KaliHubSettings.JadeHammerExploit.Value = value
if value then
task.spawn(function()
repeat
task.wait(1 / KaliHubSettings.JadeHammerExploit.SpamSpeed.Value)
if IsAlive(LocalPlayer) == true and GetMatchState() ~= 0 then
if HasItem("jade_hammer") and (tick() - JadeHammerTick) > 6 then
JadeHammerTick = tick()
BedwarsControllers.AbilityController:useAbility("jade_hammer_jump")
end
end
until KaliHubSettings.JadeHammerExploit.Value == false or shared.KaliHubUnInjected == true
end)
end
end)
sec.blocks:CreateSlider("JHE SpamSpeed", 1, 100, 100, true, function(value) KaliHubSettings.JadeHammerExploit.SpamSpeed.Value = value end)
task.spawn(function()
local OldBlockPlaceCPS = BedwarsConstants.CPSConstants.BLOCK_PLACE_CPS
sec.blocks:CreateToggle("NoPlacementCPS", false, function(value)
KaliHubSettings.NoPlacementCPS.Value = value
if value then
BedwarsConstants.CPSConstants.BLOCK_PLACE_CPS = math.huge
else
BedwarsConstants.CPSConstants.BLOCK_PLACE_CPS = OldBlockPlaceCPS
end
end)
UnInjectEvent.Event:Connect(function() BedwarsConstants.CPSConstants.BLOCK_PLACE_CPS = OldBlockPlaceCPS end)
end)
sec.blocks:CreateToggle("Scaffold", false, function(value)
KaliHubSettings.Scaffold.Value = value
if value then
task.spawn(function()
repeat
task.wait()
task.spawn(function()
if IsAlive(LocalPlayer) == true and GetMatchState() ~= 0 then
for i = 1, (KaliHubSettings.Scaffold.Expand.Value * 3) do
local BuildPosition = (LocalPlayer.Character.PrimaryPart.Position + ((LocalPlayer.Character.PrimaryPart.CFrame.LookVector * i) - Vector3.new(0, (LocalPlayer.Character.PrimaryPart.Size.Y / 2) + ((LocalPlayer.Character.Humanoid.HipHeight + (LocalPlayer.Character.Humanoid.HipHeight / 2))), 0)))
local RealBuildPosition = GetDevidedPosition(BuildPosition)
local Block = GetBlock()
if Block then BedwarsRemotes.BlockPlacingRemote:InvokeServer({blockType=Block, blockData=0, position=RealBuildPosition}) end
end
end
end)
until KaliHubSettings.Scaffold.Value == false or shared.KaliHubUnInjected == true
end)
end
end)
sec.blocks:CreateSlider("Scaffold Expand", 1, 4, 2, true, function(value) KaliHubSettings.Scaffold.Expand.Value = value end)
sec.blocks:CreateToggle("ChestStealer", false, function(value)
KaliHubSettings.ChestStealer.Value = value
if value then
task.spawn(function()
repeat
task.wait(0.1)
if IsAlive(LocalPlayer) == true then
local NearestChest = FindNearestChest(KaliHubSettings.ChestStealer.Range.Value)
if NearestChest then
local Chestitems = NearestChest:FindFirstChild("ChestFolderValue").Value:GetChildren()
BedwarsRemotes.SetObservedChestRemote:FireServer("BlockChest")
for i2, v2 in next, Chestitems do
if v2:IsA("Accessory") then
BedwarsRemotes.ChestGetItemRemote:InvokeServer(NearestChest:FindFirstChild("ChestFolderValue").Value, v2)
end
end
BedwarsRemotes.SetObservedChestRemote:FireServer(nil)
end
end
until shared.KaliHubUnInjected == true or KaliHubSettings.ChestStealer.Value == false
end)
end
end)
sec.blocks:CreateSlider("ChestStealer Range", 1, 30, 30, true, function(value) KaliHubSettings.ChestStealer.Range.Value = value end)
sec.bmisc:CreateToggle("NoFallDamage", false, function(value)
KaliHubSettings.NoFallDamage.Value = value
if value then
task.spawn(function()
repeat
task.wait(0)
if IsAlive(LocalPlayer) and GetMatchState() ~= 0 then
if LocalPlayer.Character.PrimaryPart.Velocity.Y < -80 then
LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
end
end
until shared.KaliHubUnInjected or not KaliHubSettings.NoFallDamage.Value
end)
end
end)
sec.bmisc:CreateToggle("DamageBoost", false, function(value)
KaliHubSettings.DamageBoost.Value = value
end)
sec.utility:CreateToggle("PickupItemRange", false, function(value)
KaliHubSettings.PickupItemRange.Value = value
if value then
task.spawn(function()
repeat
task.wait()
if IsAlive(LocalPlayer) == true and GetMatchState() ~= 0 then
for i, v in next, CollectionService:GetTagged("ItemDrop") do
local Magnitude = (v.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
if Magnitude <= KaliHubSettings.PickupItemRange.Range.Value then
BedwarsRemotes.PickupItemDropRemote:InvokeServer({itemDrop = v})
end
end
end
until KaliHubSettings.PickupItemRange.Value == false or shared.KaliHubUnInjected == true
end)
end
end)
sec.utility:CreateSlider("PickupRange", 1, 10, 10, true, function(value) KaliHubSettings.PickupItemRange.Range.Value = value end)
local ChatSpammerMessages = {"kalihub.xyz", "get kali hub", "kali on top"}
sec.utility:CreateToggle("ChatSpammer", false, function(value)
KaliHubSettings.ChatSpammer.Value = value
if value then
task.spawn(function()
repeat
task.wait()
for i, v in next, ChatSpammerMessages do
if KaliHubSettings.ChatSpammer.Value == true then
TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(v)
task.wait(500 / KaliHubSettings.ChatSpammer.Speed.Value)
end
end
until KaliHubSettings.ChatSpammer.Value == false or shared.KaliHubUnInjected == true
end)
end
end)
sec.utility:CreateSlider("ChatSpammer Speed", 1, 100, 50, true, function(value) KaliHubSettings.ChatSpammer.Speed.Value = value end)
sec.utility:CreateToggle("EntityNotifier", false, function(value)
KaliHubSettings.EntityNotifier.Value = value
if value then
local tags = {GuardianOfDream="A GuardianOfDream Has Spawned", DiamondGuardian="A DiamondGuardian Has Spawned", GolemBoss="A GolemBoss Has Spawned", skeleton="A Skeleton Has Spawned", Drone="A Drone Has Spawned"}
for tag, msg in pairs(tags) do
KaliHubConnections["EntityNotifier_"..tag] = CollectionService:GetInstanceAddedSignal(tag):Connect(function()
CreateNotification(3, msg)
end)
end
else
for k, v in pairs(KaliHubConnections) do
if k:find("EntityNotifier") then v:Disconnect() end
end
end
end)
task.spawn(function()
if BedwarsKnitControllers.SprintController then
local OldSprintFunction = BedwarsKnitControllers.SprintController.stopSprinting
sec.utility:CreateToggle("AutoSprint", false, function(value)
KaliHubSettings.AutoSprint.Value = value
if value then
OldSprintFunction = BedwarsKnitControllers.SprintController.stopSprinting
BedwarsKnitControllers.SprintController.stopSprinting = function(...)
local Function = OldSprintFunction(...)
BedwarsKnitControllers.SprintController:startSprinting()
return Function
end
task.spawn(function() BedwarsKnitControllers.SprintController:startSprinting() end)
else
BedwarsKnitControllers.SprintController.stopSprinting = OldSprintFunction
BedwarsKnitControllers.SprintController:stopSprinting()
end
end)
UnInjectEvent.Event:Connect(function()
BedwarsKnitControllers.SprintController.stopSprinting = OldSprintFunction
BedwarsKnitControllers.SprintController:stopSprinting()
end)
else
sec.utility:CreateToggle("AutoSprint", false, function(value)
KaliHubSettings.AutoSprint.Value = value
if value then
task.spawn(function()
repeat
task.wait()
LocalPlayer:SetAttribute("Sprinting", true)
if IsAlive(LocalPlayer) == true then
LocalPlayer.Character.Humanoid.WalkSpeed = 20
if KaliHubSettings.Fov.Value == false then Camera.FieldOfView = 77 end
end
until KaliHubSettings.AutoSprint.Value == false or shared.KaliHubUnInjected == true
end)
end
end)
end
end)
sec.utility:CreateToggle("AntiStaff", false, function(value)
KaliHubSettings.AntiStaff.Value = value
if value then
task.spawn(function()
task.wait(2)
for i, v in next, PlayerService:GetPlayers() do
if v:IsInGroup(5774246) and v:GetRankInGroup(5774246) > 1 then
CreateNotification(60, v.Name .. " - A Staff Is In Your Game!")
if KaliHubSettings.AntiStaff.UnInject.Value == true then UnInjectEvent:Fire() end
if KaliHubSettings.AntiStaff.Kick.Value == true then LocalPlayer:Kick(v.Name .. " A Staff In Your Game!") end
end
end
end)
KaliHubConnections["AntiStaffConnection"] = PlayerService.PlayerAdded:Connect(function(Player)
if KaliHubSettings.AntiStaff.Value == true and Player:IsInGroup(5774246) and Player:GetRankInGroup(5774246) > 1 then
CreateNotification(60, Player.Name .. " - A Staff Joined Your Game!")
if KaliHubSettings.AntiStaff.UnInject.Value == true then UnInjectEvent:Fire() end
if KaliHubSettings.AntiStaff.Kick.Value == true then LocalPlayer:Kick(Player.Name .. " A Staff Joined!") end
end
end)
else
if KaliHubConnections["AntiStaffConnection"] then KaliHubConnections["AntiStaffConnection"]:Disconnect() end
end
end)
sec.utility:CreateToggle("AntiStaff Kick", false, function(value) KaliHubSettings.AntiStaff.Kick.Value = value end)
sec.utility:CreateToggle("AntiAfk", false, function(value)
KaliHubSettings.AntiAfk.Value = value
if value then
task.spawn(function()
repeat
BedwarsRemotes.AfkInfoRemote:FireServer({afk = false})
task.wait(60)
until not KaliHubSettings.AntiAfk.Value or shared.KaliHubUnInjected == true
end)
end
end)
task.spawn(function()
if BedwarsKnitControllers.FovController then
local OldFov = BedwarsKnitControllers.FovController.fov
sec.utility:CreateToggle("Fov", false, function(value)
KaliHubSettings.Fov.Value = value
if value then
task.spawn(function()
repeat task.wait() BedwarsKnitControllers.FovController:setFOV(KaliHubSettings.Fov.Fov.Value) until shared.KaliHubUnInjected == true or KaliHubSettings.Fov.Value == false
BedwarsKnitControllers.FovController.fov = OldFov
end)
end
end)
sec.utility:CreateSlider("FOV Value", 1, 120, 120, true, function(value) KaliHubSettings.Fov.Fov.Value = value end)
else
local OldFov = Camera.FieldOfView
sec.utility:CreateToggle("Fov", false, function(value)
KaliHubSettings.Fov.Value = value
if value then
task.spawn(function()
repeat task.wait() Camera.FieldOfView = KaliHubSettings.Fov.Fov.Value until shared.KaliHubUnInjected == true or KaliHubSettings.Fov.Value == false
Camera.FieldOfView = OldFov
end)
else
Camera.FieldOfView = OldFov
end
end)
sec.utility:CreateSlider("FOV Value", 1, 120, 100, true, function(value) KaliHubSettings.Fov.Fov.Value = value end)
end
end)
sec.settings:CreateDropdown("Change Font", stored_fonts, function(value)
window:SetFont(value)
end, "", false)
local cleanKeyName = tostring(gui_config.Keybind):gsub("Enum.KeyCode.", "")
sec.settings:CreateLabel("Close Menu Key (PC): " .. cleanKeyName)
local config_manager = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
config_manager:SetLibrary(library)
config_manager:SetWindow(window)
config_manager:SetFolder("Kali Hub")
config_manager:BuildConfigSection(tabs.settings)
config_manager:LoadAutoloadConfig()
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
window:SetTileScale(0.5)
window:SetBackgroundColor(Color3.fromRGB(255, 255, 255))
window:SetBackgroundTransparency(0)
