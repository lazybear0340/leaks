--this shit was unobfuscated


local stored_fonts = {}
gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 100,
MaxHeight = 600,
InitialHeight = 500,
MinWidth = 300,
MaxWidth = 800,
InitialWidth = 550
}
for _, v in Enum.Font:GetEnumItems() do
table.insert(stored_fonts, v.Name)
end
local config = (getfenv().gui_config) or nil
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(config, gethui())
local window_name = library:SetWindowName("Kali Hub | Jailbreak")
getgenv().debugOutput = false
if networkKeys and network then
else
if not game:IsLoaded() then
game.Loaded:Wait()
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer
if not player.Character then
player.CharacterAdded:Wait()
end
local setEvent = require(ReplicatedStorage:WaitForChild("Module").AlexChassis).SetEvent
local network = getupvalue(setEvent, 1)
while not network and task.wait() do
network = getupvalue(setEvent, 1)
end
local startTime = os.clock()
local CollectionService = game:GetService("CollectionService")
local keysList = getupvalue(getupvalue(network.FireServer, 1), 3)
local gameFolder = ReplicatedStorage.Game
local robloxEnvironment = getrenv()
local teamChooseUI = require(ReplicatedStorage.TeamSelect.TeamChooseUI)
local defaultActions = require(gameFolder.DefaultActions)
local itemSystem = require(gameFolder.ItemSystem.ItemSystem)
local networkKeys = {}
local keyFunctions = {}
local blacklistedConstants = {}
local keyCache = {}
local backupKeys = {
Arrest = true,
Breakout = true,
Eject = true
}
local exceptionKeys = {
PlaySound = function(checkFunction)
return getconstants(checkFunction)[1] == "Source"
end,
CameraUpdate = function(checkFunction)
return getconstants(checkFunction)[1] == "MakeSpring"
end
}
for index, value in getrenv() do
if index ~= "_G" and index ~= "shared" and typeof(value) == "table" then
for name in value do
table.insert(blacklistedConstants, name)
end
end
table.insert(blacklistedConstants, index)
end
local function fetchKey(callerFunction, keyIndex, multiSearch)
keyIndex = keyIndex or 1
if keyCache[callerFunction] then
local correctKey = keyCache[callerFunction][keyIndex]
return correctKey and correctKey[1] or "Failed to fetch key"
end
local constants = getconstants(callerFunction)
local originalConstants = table.clone(constants)
local prefixIndexes = {}
local foundKeys = {}
local constantCharacters = {}
for index, constant in constants do
if keysList[constant] then
table.insert(foundKeys, { constant, 0 })
constants[index] = nil
elseif typeof(constant) ~= "string" or constant == "" or constant:match("[%u%W]") or table.find(blacklistedConstants, constant) then
constants[index] = nil
else
for character in constant:gmatch("(%w)") do
table.insert(constantCharacters, character)
end
end
end
for key, remote in keysList do
local prefixPassed, prefixIndex = false
local keyLength = #key
for index, constant in constants do
local constantLength = #constant
if not prefixPassed and key:sub(1, constantLength) == constant then
prefixPassed, prefixIndex = constant, index
elseif prefixPassed and key:sub(keyLength - (constantLength - 1), keyLength) == constant then
local currentConstantCharacters = table.clone(constantCharacters)
local charactersValid = true
for character in key:gmatch("(%w)") do
if not table.find(currentConstantCharacters, character) then
charactersValid = false
break
end
table.remove(currentConstantCharacters, table.find(currentConstantCharacters, character))
end
if charactersValid then
table.insert(prefixIndexes, prefixIndex)
table.insert(foundKeys, { key, index })
end
break
end
end
end
for index, keyInfo in foundKeys do
if table.find(prefixIndexes, keyInfo[2]) then
table.remove(foundKeys, index)
end
end
keyCache[callerFunction] = foundKeys
if multiSearch then
return foundKeys, originalConstants, constants, prefixIndexes
end
local correctKey = foundKeys[keyIndex]
return correctKey and correctKey[1] or "Failed to fetch key"
end
local function errorHandle(callback)
local success, returnValue = pcall(callback)
if not success then
return warn(" " .. returnValue)
end
return returnValue
end
local function errorHandleMultiSearch(callerFunction, keyNames)
local success, foundKeys, orginalConstants, modifiedConstants, prefixIndexes = pcall(function()
return fetchKey(callerFunction, nil, true)
end)
if not success then
for _, keyName in keyNames do
networkKeys[keyName] = ("Failed to fetch key ( %s )"):format(foundKeys)
end
return false
end
return foundKeys, orginalConstants, modifiedConstants, prefixIndexes
end
do
keyFunctions.RedeemCode = function()
return getproto(require(gameFolder.Codes).Init, 8)
end
end
do
keyFunctions.Kick = function()
local doorRemovedFunction = getconnections(CollectionService:GetInstanceRemovedSignal("Door"))[1].Function
return getupvalue(getupvalue(getupvalue(getupvalue(doorRemovedFunction, 2), 2).Run, 1), 1)[4].c
end
end
do
keyFunctions.Damage = function()
local militaryAddedFunction = require(gameFolder.MilitaryTurret.MilitaryTurretBinder)._classAddedSignal._handlerListHead._fn
return getproto(militaryAddedFunction, 1)
end
end
do
keyFunctions.JoinTeam = function()
return getproto(teamChooseUI.Show, 3)
end
end
do
keyFunctions.SwitchTeam = function()
return getproto(getproto(getproto(require(gameFolder.SidebarUI).Init, 3), 1), 1)
end
end
do
keyFunctions.ExitCar = function()
return getupvalue(teamChooseUI.Init, 3)
end
end
do
keyFunctions.Taze = function()
return require(gameFolder.Item.Taser).Tase
end
end
do
keyFunctions.DropRope = function()
return getproto(require(gameFolder.Vehicle.Heli), 5)
end
end
do
keyFunctions.Punch = function()
return getupvalue(defaultActions.punchButton.onPressed, 1).attemptPunch
end
end
do
local characterInteractFunction = errorHandle(function()
return getupvalue(getupvalue(require(ReplicatedStorage.App.CharacterBinder)._classAddedSignal._handlerListHead._fn, 1), 2)
end)
keyFunctions.Arrest = function(backup)
if backup then
return getupvalue(getupvalue(characterInteractFunction, 1), 7)
else
return getupvalue(characterInteractFunction, 1)
end
end
keyFunctions.Pickpocket = function()
return getupvalue(characterInteractFunction, 4)
end
keyFunctions.Breakout = function(backup)
return characterInteractFunction
end
end
do
keyFunctions.BroadcastInputBegan = function()
return getproto(itemSystem._equip, 5)
end
keyFunctions.BroadcastInputEnded = function()
return getproto(itemSystem._equip, 6)
end
end
do
local seatInteractFunction = errorHandle(function()
return getupvalue(getconnections(CollectionService:GetInstanceAddedSignal("VehicleSeat"))[1].Function, 1)
end)
keyFunctions.Hijack = function()
return getupvalue(seatInteractFunction, 1)
end
keyFunctions.Eject = function(backup)
if backup then
return getupvalue(seatInteractFunction, 2)
else
return seatInteractFunction
end
end
keyFunctions.EnterCar = function()
return getupvalue(seatInteractFunction, 3)
end
end
do
local robFunction = errorHandle(function()
return getupvalue(getconnections(CollectionService:GetInstanceAddedSignal("SmallStore"))[1].Function, 1)
end)
local foundKeys, orginalConstants, modifiedConstants, prefixIndexes = errorHandleMultiSearch(robFunction, { "RobEnd", "RobStart" })
if foundKeys then
for index = 1, 2 do
local key = foundKeys[index] and foundKeys[index][1] or "Failed to fetch key"
local originalPrefixIndex = table.find(orginalConstants, modifiedConstants[prefixIndexes[index]])
local previousConstant = originalPrefixIndex and orginalConstants[originalPrefixIndex - 1]
networkKeys[previousConstant == "FireServer" and "RobEnd" or "RobStart"] = key
end
end
end
do
keyFunctions.OpenDoor = function()
local doorAddedFunction = getconnections(CollectionService:GetInstanceAddedSignal("Door"))[1].Function
return getupvalue(getproto(getupvalue(doorAddedFunction, 2), 1, true)[1], 7)
end
end
do
keyFunctions.FallDamage = function()
return getupvalue(defaultActions.onJumpPressed._handlerListHead._next._fn, 2)
end
end
do
local displayGunList = errorHandle(function()
return getproto(require(gameFolder.GunShop.GunShopUI).displayList, 1)
end)
local foundKeys, orginalConstants, modifiedConstants, prefixIndexes = errorHandleMultiSearch(displayGunList, { "UneqipGun", "EquipGun", "BuyGun" })
if foundKeys then
for index = 1, 3 do
local key = foundKeys[index] and foundKeys[index][1] or "Failed to fetch key"
local originalPrefixIndex = table.find(orginalConstants, modifiedConstants[prefixIndexes[index]])
local previousConstant = originalPrefixIndex and orginalConstants[originalPrefixIndex - 1]
if previousConstant == "GetEquipped" then
networkKeys.UnequipGun = key
elseif previousConstant == "doesPlayerOwn" then
networkKeys.EquipGun = key
else
networkKeys.BuyGun = key
end
end
end
end
do
keyFunctions.Ragdoll = function()
return require(gameFolder.Falling).StartRagdolling
end
end
do
local exceptionKeysFound, exceptionKeyCount = 0, 0
for _ in exceptionKeys do
exceptionKeyCount += 1
end
local success, errorMessage = pcall(function()
for key, clientFunction in getupvalue(teamChooseUI.Init, 2) do
if typeof(clientFunction) == "function" then
for keyName, keyCheck in exceptionKeys do
if keyCheck(clientFunction) then
exceptionKeysFound += 1
networkKeys[keyName] = key
break
end
end
if exceptionKeysFound == exceptionKeyCount then
break
end
end
end
end)
if not success then
local failedMessage = ("Failed to fetch key ( %s )"):format(errorMessage)
for keyName in exceptionKeys do
networkKeys[keyName] = failedMessage
end
end
end
for keyName, keyFunction in keyFunctions do
local success, errorMessage = pcall(function()
networkKeys[keyName] = fetchKey(keyFunction()) or "Failed to fetch key"
end)
if not success or networkKeys[keyName] == "Failed to fetch key" then
if backupKeys[keyName] then
success, errorMessage = pcall(function()
networkKeys[keyName] = fetchKey(keyFunction(true)) or "Failed to fetch key"
end)
end
if not success then
networkKeys[keyName] = ("Failed to fetch key ( %s )"):format(errorMessage)
end
end
end
local environment = getgenv()
environment.networkKeys, environment.network = networkKeys, network
if debugOutput or debugOutput == nil then
rconsolename("")
rconsolewarn(("\n"):format(os.clock() - startTime))
for index, key in networkKeys do
rconsoleprint(("%s : %s\n"):format(index, key))
end
else
warn((""):format(os.clock() - startTime))
end
local key = networkKeys
local jbremote = network
end
local oldjbremote = getupvalue(network.FireServer, 1)
configs = {
player = {
walktog = false;
walkval = 0;
infjump = false;
nofall = false;
norag = false;
noislow = false;
nosky = false;
nostun = false;
norwait = false;
nocslow = false;
nocircwait = false;
nopwait = false;
bypasskd = false;
alwayssilentp = false;
alwaysp = false;
juiced = false;
crawlequip = false;
backbone = false;
};
vehicle = {
fspeed = 10;
ftog = false;
fx = 0;
fy = 0;
fz = 0;
engine = false;
enginesp = 0;
brake = false;
brakesp = 0;
suspension = false;
suspensionhe = 0;
turnsp = 0;
turn = false;
tirepop = false;
infnitro = false;
rinfnitro = false;
autoflip = false;
helibreak = false;
helienginesp = 0;
heliengine = false;
heliheight = false;
instanttow = false;
driveonwater = false;
};
combat = {
hitboxradius = 3;
noequipt = false;
nospread = false;
norecoil = false;
nobulletg = false;
alwaysauto = false;
alwaysheadshot = false;
snipernoblur = false;
snipernogui = false;
wallbang = false;
nogrenadesmoke = false;
tasermodz = false;
instantrocketseek = false;
forcefieldnomiss = false;
increasetakedowndamage = false;
increaseforcedamage = false;
silentaim = {
enabled = false;
includetaser = false;
includeplasma = false;
radius = 250;
wallcheck = false;
fovcirc = false;
fovthick = 5;
fovtransp = 1;
};
arrestaura = {
enabled = false;
};
batonsword = {
noreloadtime = false;
spamlunge = false;
spamswoosh = false;
};
};
robberies = {
guardnodmg = false;
};
}
local client = {
ropedata = {};
lastvehiclestats = {
GarageEngineSpeed = nil;
Height = nil;
TurnSpeed = nil;
};
lastvehiclemodel = nil;
vehicleEntered = false;
originalequippeddata = {};
doorAddedFunction = getconnections(game:GetService"CollectionService":GetInstanceAddedSignal("Door"))[1].Function;
remoteid = {
};
activeaction = {};
ori = {
updateseeking = require(game:GetService("ReplicatedStorage").VehicleLink.VehicleLinkBinder)._constructor._updateSeeking;
hittargetwithspeed = require(game:GetService("ReplicatedStorage").Module.SimulatedPhysicsProjectile).HitTargetWithSpeed;
isflying = require(game:GetService("ReplicatedStorage").Game.Paraglide).IsFlying;
tase = require(game:GetService("ReplicatedStorage").Game.Item.Taser).Tase;
update = require(game:GetService("ReplicatedStorage").Module.UI).CircleAction.Update;
getequiptime = require(game:GetService("ReplicatedStorage").Game.GunShop.GunUtils).getEquipTime;
rayignorenon = require(game:GetService("ReplicatedStorage").Module.RayCast).RayIgnoreNonCollide;
plasmashootother = require(game:GetService("ReplicatedStorage").Game.Item.PlasmaGun).ShootOther;
pistolsetupmodel = require(game:GetService("ReplicatedStorage").Game.Item.Pistol).SetupModel;
rayignore = require(game:GetService("ReplicatedStorage").Module.RayCast).RayIgnoreNonCollideWithIgnoreList;
shoot = require(game:GetService("ReplicatedStorage").Game.Item.Gun).Shoot;
attemptToggleCrawling = getupvalue(require(game:GetService("ReplicatedStorage").Game.DefaultActions).crawlButton.onPressed,1).attemptToggleCrawling;
};
guardnpcbinder = require(game:GetService("ReplicatedStorage").GuardNPC.GuardNPCBinder);
combatconst = require(game:GetService("ReplicatedStorage").Combat.CombatConsts);
combatutils = require(game:GetService("ReplicatedStorage").Combat.CombatUtils);
playerutil = require(game:GetService("ReplicatedStorage").Game.PlayerUtils);
actionbuttonservice = require(game:GetService("ReplicatedStorage").ActionButton.ActionButtonService);
settingss = require(game:GetService("ReplicatedStorage").Resource.Settings);
characterutil = require(game:GetService("ReplicatedStorage").Game.CharacterUtil);
paraglide = require(game:GetService("ReplicatedStorage").Game.Paraglide);
alexchassis = require(game:GetService("ReplicatedStorage").Module.AlexChassis);
itemgun = require(game:GetService("ReplicatedStorage").Game.Item.Gun);
itemsys = require(game:GetService("ReplicatedStorage").Game.ItemSystem.ItemSystem);
gunutil = require(game:GetService("ReplicatedStorage").Game.GunShop.GunUtils);
pistolitem = require(game:GetService("ReplicatedStorage").Game.Item.Pistol);
smokegrenadeitem = require(game:GetService("ReplicatedStorage").Game.SmokeGrenade.SmokeGrenade);
circleac = require(game:GetService("ReplicatedStorage").Module.UI).CircleAction;
tase = require(game:GetService("ReplicatedStorage").Game.Item.Taser);
plasmagun = require(game:GetService("ReplicatedStorage").Game.Item.PlasmaGun);
duck = require(game:GetService("ReplicatedStorage").Game.Robbery.TombRobbery.TombRobberySystem).duck;
onvehicleentered = require(game:GetService("ReplicatedStorage").Vehicle.VehicleUtils).OnVehicleEntered;
onvehicleexited = require(game:GetService("ReplicatedStorage").Vehicle.VehicleUtils).OnVehicleExited;
onlocalitemequipped = require(game:GetService("ReplicatedStorage").Game.ItemSystem.ItemSystem).OnLocalItemEquipped;
onlocalitemunequipped = require(game:GetService("ReplicatedStorage").Game.ItemSystem.ItemSystem).OnLocalItemUnequipped;
bulletonlocalhitplayer = require(game:GetService("ReplicatedStorage").Game.Item.Gun).BulletEmitterOnLocalHitPlayer;
vehiclelinkbinder = require(game:GetService("ReplicatedStorage").VehicleLink.VehicleLinkBinder);
raycast = require(game:GetService("ReplicatedStorage").Module.RayCast);
}
getgenv().Circle = Drawing.new("Circle")
Circle.Color = Color3.new(1,1,1)
Circle.Thickness = configs.combat.silentaim.fovthick
Circle.Radius = configs.combat.silentaim.radius
Circle.Visible = configs.combat.silentaim.fovcirc
Circle.NumSides = 100
Circle.Filled = false
Circle.Transparency = configs.combat.silentaim.fovtransp
client.door = {
openDoor = getupvalue(getproto(getupvalue(client.doorAddedFunction, 2), 1, true)[1], 7);
doors = getupvalue(client.doorAddedFunction, 1);
}
client.hittargetwithspeed = require(game:GetService("ReplicatedStorage").Module.SimulatedPhysicsProjectile).HitTargetWithSpeed
client.driveOnWaterIndex = nil
for idx, const in getconstants(client.alexchassis.UpdateEngine) do
if const == 0.625 and typeof(const) == "number" then
client.driveOnWaterIndex = idx
break
end
end
local itemConfigClone = game:GetService("ReplicatedStorage").Game.ItemConfig:Clone()
itemConfigClone.Name = "ItemConfigBackup"
for i,v in next, getgc() do
if type(v) == "function" and islclosure(v) then
if tostring(getfenv(v).script) == "LocalScript" then
local infoname = tostring(getinfo(v).name)
if infoname == "StartRagdolling" then
client.stunnedragdoll = v
end
if infoname == "AttemptArrest" then
client.attemptarrest = v
end
if infoname == "StartNitro" then
client.startnitro = v
client.nitro = getupvalue(v, 8)
end
if infoname == "StopNitro" then
client.stopnitro = v
end
end
end
end
for i,v in next, getconnections(game:GetService("RunService").Heartbeat) do
if v.Function and islclosure(v.Function) then
if getconstants(v.Function)[13] == "Time/UI" then
client.walkspeedfun = getupvalue(v.Function,6)
end
if getconstants(v.Function)[3] == "Vehicle Heartbeat" then
client.heli = getupvalue(v.Function,1).Heli
client.ori.heliupdate = client.heli.Update
end
end
end
client.punchCorrection = (function()
repeat
if configs.player.alwayssilentp == true then
task.wait(0.5)
getupvalue(require(game:GetService("ReplicatedStorage").Game.DefaultActions).punchButton.onPressed,1).attemptPunch()
else
task.wait(0.3)
jbremote:FireServer(client.remoteid.punch)
end
until configs.player.alwaysp == false
end)
client.duckCorrection = (function()
repeat
client.duck()
task.wait(2)
until configs.player.backbone == false
end)
client.flipCorrection = (function()
repeat task.wait(.1)
pcall(function()
for i,v in next, client.actionbuttonservice.active do
if v.keyCodes and type(v.keyCodes) == "table" and table.find(v.keyCodes, Enum.KeyCode.V) then
v.onPressed(true)
end
end
end)
until configs.vehicle.autoflip == false
end)
client.hasKeyCorrection = (function(boolean)
if boolean then
hookfunction(client.playerutil.hasKey, function()
return true
end)
else
if isfunctionhooked(client.playerutil.hasKey) then restorefunction(client.playerutil.hasKey) end
end
end)
client.headshotCorrection = (function(boolean)
if boolean then
epichook = hookfunction(client.bulletonlocalhitplayer, function(...)
local bulletshot = {...}
bulletshot[15].isWallbang = false
bulletshot[15].isHeadshot = true
return epichook(...)
end)
else
if isfunctionhooked(client.bulletonlocalhitplayer) then restorefunction(client.bulletonlocalhitplayer) end
end
end)
client.smokeGrenadeHook = (function(boolean)
if boolean then
hookfunction(client.smokegrenadeitem._playExplosionFx, function() end)
else
if isfunctionhooked(client.smokegrenadeitem._playExplosionFx) then restorefunction(client.smokegrenadeitem._playExplosionFx) end
end
end)
client.isCrawlingCorrection = (function()
repeat task.wait(.1)
client.characterutil.IsCrawling = false
until configs.player.crawlequip == false
end)
client.nitroCorrection = (function()
getgenv().InfNitro = true
local nitroRef = client.nitro
if not nitroRef then
for _, v in getgc(true) do
if type(v) == "table" and rawget(v, "Nitro") then
nitroRef = v
client.nitro = v
break
end
end
end
task.spawn(function()
while getgenv().InfNitro do
if nitroRef then
nitroRef.Nitro = 250
else
for _, v in getgc(true) do
if type(v) == "table" and rawget(v, "Nitro") then
nitroRef = v
client.nitro = v
break
end
end
end
task.wait(1)
end
end)
end)
client.launchVehicleFlight = (function()
local BodyGyro = Instance.new("BodyGyro", game:GetService("Players").LocalPlayer.Character.HumanoidRootPart)
local BodyVelocity = Instance.new("BodyVelocity", game:GetService("Players").LocalPlayer.Character.HumanoidRootPart)
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
BodyGyro.D = 50000
BodyGyro.P = 1500000000
repeat task.wait()
BodyGyro.CFrame = Camera.CFrame * CFrame.Angles(math.rad(configs.vehicle.fx), math.rad(configs.vehicle.fy), math.rad(configs.vehicle.fz))
workspace.CurrentCamera.CameraType = Enum.CameraType.Track
BodyVelocity.Velocity = Vector3.new()
if UIS:IsKeyDown(Enum.KeyCode.W) then
BodyVelocity.Velocity = BodyVelocity.Velocity + Camera.CFrame.LookVector
end
if UIS:IsKeyDown(Enum.KeyCode.A) then
BodyVelocity.Velocity = BodyVelocity.Velocity - Camera.CFrame.RightVector
end
if UIS:IsKeyDown(Enum.KeyCode.S) then
BodyVelocity.Velocity = BodyVelocity.Velocity - Camera.CFrame.LookVector
end
if UIS:IsKeyDown(Enum.KeyCode.D) then
BodyVelocity.Velocity = BodyVelocity.Velocity + Camera.CFrame.RightVector
end
BodyVelocity.Velocity = BodyVelocity.Velocity * configs.vehicle.fspeed
until client.vehicleEntered == false or configs.vehicle.ftog == false
workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
BodyGyro:Destroy()
BodyVelocity:Destroy()
end)
client.getOldWeaponData = (function(name, dataname)
return rawget(require(itemConfigClone[name]), dataname)
end)
client.setBatonSwordTime = (function(bool)
local baton = require(game:GetService("ReplicatedStorage").Game.Item.Baton)
local sword = require(game:GetService("ReplicatedStorage").Game.Item.Sword)
getupvalue(baton.new,2).ReloadTime = bool and 0 or 0.5
getupvalue(sword.new,2).ReloadTime = bool and 0 or 0.5
end)
client.spamBatonSwordSwoosh = (function()
repeat task.wait()
local a = client.itemsys.GetLocalEquipped()
if a and (a.__ClassName == "Sword" or a.__ClassName == "Baton") then
require(game:GetService("ReplicatedStorage").Game.Item[a.__ClassName]).SwingSwoosh(a)
end
until configs.combat.batonsword.spamswoosh == false
end)
client.spamBatonSwordLunge = (function()
repeat task.wait()
local a = client.itemsys.GetLocalEquipped()
if a and (a.__ClassName == "Sword" or a.__ClassName == "Baton") then
require(game:GetService("ReplicatedStorage").Game.Item[a.__ClassName]).SwingLunge(a)
end
until configs.combat.batonsword.spamlunge == false
end)
client.notInWall = (function(i,v,wallCheck)
if wallCheck then
local ray = Ray.new(game:GetService("Workspace").CurrentCamera.CFrame.p, i - game:GetService("Workspace").CurrentCamera.CFrame.p)
local result = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, v)
return result == nil
else
return true
end
end)
client.isEnemies = (function(a,b)
local a, b = tostring(a), tostring(b)
if a == "Criminal" and b == "Police" then
return true
elseif a == "Criminal" and b == "Prisoner" then
return false
elseif a == "Police" and b == "Criminal" then
return true
elseif a == "Police" and b == "Prisoner" then
return false
elseif a == "Prisoner" and b == "Police" then
return true
elseif a == "Prisoner" and b == "Criminal" then
return false
end
end)
client.getNearestToCursor = (function()
local Target = nil
local notInWall = client.notInWall
local isEnemies = client.isEnemies
for i,v in next, game:GetService("Players"):GetPlayers() do
if isEnemies(game:GetService("Players").LocalPlayer.Team, v.Team) and v ~= game:GetService("Players").LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 then
local magnitude = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
if magnitude < 9e9 then
local Point, OnScreen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
if OnScreen and notInWall(v.Character.HumanoidRootPart.Position,{game:GetService("Players").LocalPlayer.Character, v.Character}, configs.combat.silentaim.wallcheck) then
local Distance = (Vector2.new(Point.X, Point.Y) - Vector2.new(game:GetService("Players").LocalPlayer:GetMouse().X, game:GetService("Players").LocalPlayer:GetMouse().Y)).magnitude
if Distance < configs.combat.silentaim.radius then
Target = v
end
end
end
end
end
return Target
end)
client.getNearestPlayerNoCuffed = (function()
local maxdistance = 18
local player = nil;
for i,v in next, game:GetService("Players"):GetPlayers() do
if tostring(v.Team) == "Criminal" then
local character = v.Character or nil
if character ~= nil and not v.Character:GetAttribute("Handcuffs") then
local hrp = character:FindFirstChild("Head") or nil
local hum = character:FindFirstChild("Humanoid") or nil
if hrp ~= nil and hum ~= nil then
local mag = (game:GetService("Players").LocalPlayer.Character:GetModelCFrame().Position - hrp.Position).magnitude
if mag < maxdistance then
player = v
if player ~= nil then
return player
end
end
end
end
end
end
return false
end)
client.launchArrestAura = (function()
local getNearestPlayerNoCuffed = client.getNearestPlayerNoCuffed
repeat task.wait(0.15)
local plr = getNearestPlayerNoCuffed()
if plr then
client.attemptarrest(game:GetService("Players"):FindFirstChild(tostring(plr)))
end
until configs.combat.arrestaura.enabled == false
end)
client.updateToOriginalChassisStats = (function()
local gvp = require(game:GetService("ReplicatedStorage").Vehicle.VehicleUtils).GetLocalVehiclePacket()
if gvp ~= nil and client.lastvehiclestats ~= nil and client.lastvehiclemodel ~= nil and gvp.Model ~= gvp.lastvehiclemodel then
local stats = client.lastvehiclestats
if configs.vehicle.engine == false then
gvp.GarageEngineSpeed = stats.GarageEngineSpeed
end
if configs.vehicle.suspension == false then
gvp.Height = stats.Height
end
if configs.vehicle.turn == false then
gvp.TurnSpeed = stats.TurnSpeed
end
end
end)
client.changeHitboxRadius = (function(radius)
setreadonly(client.combatconst, isreadonly(client.combatconst) and false)
client.combatconst.DEFAULT_ROOT_PART_HIT_RADIUS = radius
end)
client.hookNearestObj = (function()
local cframe = client.ropedata.nearestObj.PrimaryPart.CFrame:PointToObjectSpace(require(game:GetService("ReplicatedStorage"):WaitForChild("Std"):WaitForChild("GeomUtils")).closestPointInPart(client.ropedata.nearestObj.PrimaryPart, client.ropedata.obj.Position))
client.ropedata.manifest.reqLinkRemote:FireServer(client.ropedata.nearestObj, cframe)
end)
client.onHitSurfaceHook = (function()
if configs.combat.increasetakedowndamage then
local a = client.itemsys.GetLocalEquipped()
if a.FakeName ~= "Sniper" then
a.FakeName = "Sniper"
end
repeat wait() until a.BulletEmitter ~= nil
setconstant(a.BulletEmitter.OnHitSurface._handlerListHead._fn, 75, "FakeName")
end
end)
task.spawn(function()
client.hittargetwithspeed = (function(...)
local args = {...}
if configs.combat.forcefieldnomiss then
args[3] = 0
end
return client.ori.hittargetwithspeed(unpack(args))
end)
old2 = hookfunction(client.bulletonlocalhitplayer, function(...)
local args = {...}
if configs.combat.alwaysheadshot then
args[15].isHeadshot = true
args[15].isWallbang = false
end
return old2(unpack(args))
end)
client.itemgun.Shoot = (function(self,a)
if configs.combat.silentaim.enabled then
local character = client.getNearestToCursor() and client.getNearestToCursor().Character
local hrp = character and character:FindFirstChild("HumanoidRootPart")
if hrp then
self.TipDirection = (hrp.Position - self.Tip.Position).Unit
end
end
client.ori.shoot(self, a)
end)
client.plasmagun.ShootOther = (function(self,a)
if configs.combat.silentaim.enabled and configs.combat.silentaim.includeplasma then
local character = client.getNearestToCursor() and client.getNearestToCursor().Character
local hrp = character and character:FindFirstChild("HumanoidRootPart")
if hrp then
self.TipDirection = (hrp.Position - self.Tip.Position).Unit
end
end
client.ori.plasmashootother(self,a)
end)
client.raycast.RayIgnoreNonCollideWithIgnoreList = (function(...)
if debug.traceback():find("Taser") and configs.combat.silentaim.enabled and configs.combat.silentaim.includetaser then
local character = client.getNearestToCursor() and client.getNearestToCursor().Character
local hrp = character and character:FindFirstChild("HumanoidRootPart")
if hrp then
return hrp, hrp.Position, hrp.Position, ...
end
end
return client.ori.rayignore(...)
end)
client.raycast.RayIgnoreNonCollide = (function(...)
local args = {...}
if configs.vehicle.driveonwater and debug.traceback():find("AlexChassis") then
args[6] = true
end
return client.ori.rayignorenon(unpack(args))
end)
client.gunutil.getEquipTime = (function(...)
return configs.combat.noequipt and 0 or client.ori.getequiptime(...)
end)
client.circleac.Update = (function(...)
local mymom = ...
pcall(function()
client.ori.update(mymom)
if configs.player.nocircwait then
client.circleac.Spec.PressedAt = 0.01
end
end)
end)
client.paraglide.IsFlying = (function(...)
return configs.player.nosky and debug.traceback():find("Falling") and true or client.ori.isflying(...)
end)
client.vehiclelinkbinder._constructor._updateSeeking = (function(ropedata)
client.ropedata = ropedata
return client.ori.updateseeking(ropedata)
end)
game:GetService("Players").LocalPlayer:GetMouse().Move:Connect(function()
local Mouse = game:GetService"UserInputService":GetMouseLocation()
Circle.Position = Vector2.new(Mouse.X, Mouse.Y)
end)
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
local hrp = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
if hrp then
if configs.player.nofall then
hrp:AddTag("NoFallDamage")
end
if configs.player.norag then
hrp:AddTag("NoRagdoll")
end
end
end)
game:GetService("UserInputService").JumpRequest:Connect(function()
if configs.player.infjump then
game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
end
end)
game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(mama)
if mama.Name == "LoadingBarGui" then
if client.ropedata.nearestObj ~= nil then
if configs.vehicle.instanttow and client.ropedata.obj.Name == "MetalHook" then
client.hookNearestObj()
end
end
end
end)
game.Lighting.ChildAdded:connect(function(mama)
if configs.combat.snipernoblur and mama.Name == "Blur" then
mama:GetPropertyChangedSignal("Size"):connect(function()
mama.Enabled = false
end)
end
end)
client.onvehicleentered:Connect(function(arg1)
client.vehicleEntered = true
if arg1.Model ~= client.lastvehiclemodel and arg1.Type == "Chassis" then
client.lastvehiclemodel = arg1.Model
client.lastvehiclestats.GarageEngineSpeed = arg1.GarageEngineSpeed
client.lastvehiclestats.TurnSpeed = arg1.TurnSpeed
client.lastvehiclestats.Height = arg1.Height
end
if configs.vehicle.ftog then
client.launchVehicleFlight()
end
if arg1.Type == "Heli" then
arg1.MaxHeight = configs.vehicle.heliheight and 9e9 or 400
arg1.FallOutOfSkyDuration = configs.vehicle.helibreak and 0 or 10
arg1.DisableDuration = configs.vehicle.helibreak and 0 or 10
elseif arg1.Type == "Chassis" then
arg1.TirePopDuration = configs.vehicle.nopop and 0 or 7.5
arg1.DisableDuration = configs.vehicle.nopop and 0 or 7.5
arg1.TirePopProportion = configs.vehicle.nopop and 0 or 0.5
end
end)
client.onvehicleexited:Connect(function()
client.vehicleEntered = false
end)
client.onlocalitemequipped:Connect(function(equippeddata)
local getdata = client.getOldWeaponData
local a = client.itemsys.GetLocalEquipped()
if a.FakeName ~= "Sniper" then
a.FakeName = "Sniper"
end
task.spawn(function()
client.onHitSurfaceHook()
end)
if getdata(a.__ClassName, "EquipTime") ~= nil then
a.Config.EquipTime = configs.combat.noequipt and 0 or getdata(a.__ClassName, "EquipTime")
end
if getdata(a.__ClassName, "FireAuto") ~= nil then
a.Config.FireAuto = configs.combat.alwaysauto and true or getdata(a.__ClassName, "FireAuto")
end
if getdata(a.__ClassName, "BulletSpread") ~= nil then
a.Config.BulletSpread = configs.combat.nospread and 0 or getdata(a.__ClassName, "BulletSpread")
end
if getdata(a.__ClassName, "CamShakeMagnitude") ~= nil then
a.Config.CamShakeMagnitude = configs.combat.norecoil and 0 or getdata(a.__ClassName, "CamShakeMagnitude")
end
if a and a.BulletEmitter and a.BulletEmitter.GravityVector then
a.BulletEmitter.GravityVector = configs.combat.nobulletg and nil or Vector3.new(0, -workspace.Gravity / 10, 0)
end
end)
task.spawn(function()
while true do task.wait()
pcall(function()
local humanoid = game:GetService("Players").LocalPlayer.Character.Humanoid or nil
local gvp = require(game:GetService("ReplicatedStorage").Vehicle.VehicleUtils).GetLocalVehiclePacket() or nil
if humanoid ~= nil and gvp ~= nil and client.vehicleEntered then
if gvp.Type == "Chassis" then
if configs.vehicle.engine then
gvp.GarageEngineSpeed = configs.vehicle.enginesp
end
if configs.vehicle.suspension then
gvp.Height = configs.vehicle.suspensionhe
end
if configs.vehicle.turn then
gvp.TurnSpeed = configs.vehicle.turnsp
end
end
end
end)
end
end)
end)
local tabs = {
main = window:CreateTab("Players"),
vehicle = window:CreateTab("Vehicle"),
combat = window:CreateTab("Combat"),
settings = window:CreateTab("Settings")
}
local sections = {
character_section = tabs.main:CreateSection("Character"),
utilities_section = tabs.main:CreateSection("Utilities"),
vehicle_utilities = tabs.vehicle:CreateSection("Utilities"),
car_mods = tabs.vehicle:CreateSection("Car Mods"),
heli_mods = tabs.vehicle:CreateSection("Heli Mods"),
weapons_section = tabs.combat:CreateSection("Weapons"),
melee_section = tabs.combat:CreateSection("Melee"),
silentaim_section = tabs.combat:CreateSection("Silent Aim"),
arrestaura_section = tabs.combat:CreateSection("Arrest Aura"),
others_section = tabs.combat:CreateSection("Others"),
settings_section = tabs.settings:CreateSection("UI Settings")
}
local speedBoostAmount = 30
local SAB = {
MAX_PLAYER_SPEED = speedBoostAmount,
SpeedBoost = {
conn = nil,
active = false
}
}
function SAB:GetMaxSpeed()
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local l_Tool = character:FindFirstChildOfClass("Tool")
local speedMod = 1
if l_Tool and l_Tool:GetAttribute("SpeedModifier") then
speedMod *= l_Tool:GetAttribute("SpeedModifier")
end
if self:IsStealing() then
speedMod *= 0.6
end
return self.MAX_PLAYER_SPEED * speedMod
end
function SAB:IsStealing()
return false
end
function SAB.SpeedBoost:Toggle(boolean)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
if boolean and not self.conn then
self.conn = RunService.Stepped:Connect(function(_, dt)
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChild("Humanoid")
if not humanoid then
return
end
local root = character:WaitForChild("HumanoidRootPart")
local moveDir = humanoid.MoveDirection
local vel = root.AssemblyLinearVelocity
local maxSpeed = SAB:GetMaxSpeed()
local state = humanoid:GetState()
if not (state == Enum.HumanoidStateType.Running or
state == Enum.HumanoidStateType.RunningNoPhysics or
state == Enum.HumanoidStateType.Freefall or
state == Enum.HumanoidStateType.Jumping) then
return
end
if moveDir.Magnitude > 0 then
local horiz = moveDir.Unit * maxSpeed
local newY = vel.Y
if state == Enum.HumanoidStateType.Jumping then
newY = maxSpeed
end
root.AssemblyLinearVelocity = Vector3.new(horiz.X, newY, horiz.Z)
else
local newY = vel.Y
if state == Enum.HumanoidStateType.Jumping then
newY = maxSpeed
end
root.AssemblyLinearVelocity = Vector3.new(0, newY, 0)
end
end)
elseif not boolean and self.conn then
self.conn:Disconnect()
self.conn = nil
end
self.active = boolean
end
local speedBoostSlider = sections.character_section:CreateSlider(
"Speed Boost Amount",
30,
200,
30,
true,
function(value)
speedBoostAmount = value
SAB.MAX_PLAYER_SPEED = value
end
)
local bindable_toggle = sections.character_section:CreateToggle("Speed Boost", false, function(value)
getgenv().SpeedBoost = value
SAB.SpeedBoost:Toggle(value)
end)
task.spawn(function()
while true do
if getgenv().SpeedBoost ~= SAB.SpeedBoost.active then
SAB.SpeedBoost:Toggle(getgenv().SpeedBoost)
end
task.wait(0.2)
end
end)
sections.character_section:CreateToggle("Inf Jump", configs.player.infjump, function(value)
configs.player.infjump = value
end)
sections.utilities_section:CreateToggle("No Ragdoll", configs.player.norag, function(value)
configs.player.norag = value
local hrp = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart") or nil
if configs.player.norag == false and hrp ~= nil then
hrp:RemoveTag("NoRagdoll")
elseif configs.player.norag == true and hrp ~= nil then
hrp:AddTag("NoRagdoll")
end
end)
sections.utilities_section:CreateToggle("No Fall Injury", configs.player.nofall, function(value)
configs.player.nofall = value
local hrp = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart") or nil
if configs.player.nofall == false and hrp ~= nil then
hrp:RemoveTag("NoFallDamage")
elseif configs.player.nofall == true and hrp ~= nil then
hrp:AddTag("NoFallDamage")
end
end)
sections.utilities_section:CreateToggle("No Skydive", configs.player.nosky, function(value)
configs.player.nosky = value
end)
sections.utilities_section:CreateToggle("No Ragdoll Stun", configs.player.nostun, function(value)
configs.player.nostun = value
client.settingss.Time.Stunned = configs.player.nostun and 0 or 5
if client.stunnedragdoll then
setupvalue(client.stunnedragdoll, 1, configs.player.nostun and 0 or 5)
else
end
end)
sections.utilities_section:CreateToggle("No Crawling Slow", configs.player.nocslow, function(value)
configs.player.nocslow = value
setconstant(client.walkspeedfun, 16, configs.player.nocslow and 1 or 0.4)
end)
sections.utilities_section:CreateToggle("No Circle Hold", configs.player.nocircwait, function(value)
configs.player.nocircwait = value
end)
sections.utilities_section:CreateToggle("No Injury Slow", configs.player.noislow, function(value)
configs.player.noislow = value
setconstant(client.walkspeedfun, 8, configs.player.noislow and 1 or 0.5)
end)
sections.utilities_section:CreateToggle("No Spotlight Slow", configs.player.nospslow, function(value)
configs.player.nospslow = value
setconstant(client.walkspeedfun, 35, configs.player.nospslow and 1 or 0.8)
end)
sections.utilities_section:CreateToggle("Always Keycard", configs.player.bypasskd, function(value)
configs.player.bypasskd = value
client.hasKeyCorrection(configs.player.bypasskd)
end)
sections.utilities_section:CreateToggle("Allow Equip While Crawling", configs.player.crawlequip, function(value)
configs.player.crawlequip = value
if configs.player.crawlequip then
client.isCrawlingCorrection()
end
end)
sections.utilities_section:CreateToggle("Break Your Back Bone", configs.player.backbone, function(value)
configs.player.backbone = value
if configs.player.backbone then
client.duckCorrection()
end
end)
sections.vehicle_utilities:CreateSlider(
"Flight Speed",
10,
1000,
configs.vehicle.fspeed,
true,
function(value)
configs.vehicle.fspeed = value
end
)
sections.vehicle_utilities:CreateSlider(
"Flight Rotation X",
0,
360,
configs.vehicle.fx,
false,
function(value)
configs.vehicle.fx = value
end
)
sections.vehicle_utilities:CreateSlider(
"Flight Rotation Y",
0,
360,
configs.vehicle.fy,
false,
function(value)
configs.vehicle.fy = value
end
)
sections.vehicle_utilities:CreateSlider(
"Flight Rotation Z",
0,
360,
configs.vehicle.fz,
false,
function(value)
configs.vehicle.fz = value
end
)
sections.vehicle_utilities:CreateToggle("Vehicle Flight", configs.vehicle.ftog, function(value)
configs.vehicle.ftog = value
if configs.vehicle.ftog and client.vehicleEntered == true then
client.launchVehicleFlight()
end
end)
sections.vehicle_utilities:CreateToggle("Infinite Nitro", configs.vehicle.infnitro, function(value)
configs.vehicle.infnitro = value
getgenv().InfNitro = value
if value then
client.nitroCorrection()
end
end)
sections.vehicle_utilities:CreateToggle("Random Infinite Nitro", configs.vehicle.rinfnitro, function(value)
configs.vehicle.rinfnitro = value
end)
sections.car_mods:CreateSlider(
"Engine Speed",
1,
200,
configs.vehicle.enginesp,
false,
function(value)
configs.vehicle.enginesp = value
end
)
sections.car_mods:CreateToggle("Apply Engine Speed", configs.vehicle.engine, function(value)
configs.vehicle.engine = value
if configs.vehicle.engine == false then
client.updateToOriginalChassisStats()
end
end)
sections.car_mods:CreateSlider(
"Suspension Height",
1,
150,
configs.vehicle.suspensionhe,
false,
function(value)
configs.vehicle.suspensionhe = value
end
)
sections.car_mods:CreateToggle("Apply Suspension Height", configs.vehicle.suspension, function(value)
configs.vehicle.suspension = value
if configs.vehicle.suspension == false then
client.updateToOriginalChassisStats()
end
end)
sections.car_mods:CreateSlider(
"Turn Speed",
1,
5,
configs.vehicle.turnsp,
true,
function(value)
configs.vehicle.turnsp = value
end
)
sections.car_mods:CreateToggle("Apply Turn Speed", configs.vehicle.turn, function(value)
configs.vehicle.turn = value
if configs.vehicle.turn == false then
client.updateToOriginalChassisStats()
end
end)
sections.car_mods:CreateToggle("Anti Tire Pop", configs.vehicle.nopop, function(value)
configs.vehicle.nopop = value
end)
sections.car_mods:CreateToggle("Automatic Flip", configs.vehicle.autoflip, function(value)
configs.vehicle.autoflip = value
if configs.vehicle.autoflip then
client.flipCorrection()
end
end)
sections.car_mods:CreateToggle("Instant Tow", configs.vehicle.instanttow, function(value)
configs.vehicle.instanttow = value
end)
sections.car_mods:CreateToggle("Drive On Water", configs.vehicle.driveonwater, function(value)
configs.vehicle.driveonwater = value
if client.driveOnWaterIndex then
setconstant(client.alexchassis.UpdateEngine, client.driveOnWaterIndex, configs.vehicle.driveonwater and 1 or 0.625)
end
end)
sections.heli_mods:CreateSlider(
"Engine Speed",
1,
100,
configs.vehicle.helienginesp,
false,
function(value)
configs.vehicle.helienginesp = value / 1000
end
)
sections.heli_mods:CreateToggle("Infinite Height", configs.vehicle.heliheight, function(value)
configs.vehicle.heliheight = value
end)
sections.heli_mods:CreateToggle("Anti Heli Break", configs.vehicle.helibreak, function(value)
configs.vehicle.helibreak = value
end)
sections.heli_mods:CreateToggle("Instant Pickup", configs.vehicle.helipick, function(value)
configs.vehicle.helipick = value
end)
sections.weapons_section:CreateToggle("Always Auto", configs.combat.alwaysauto, function(value)
configs.combat.alwaysauto = value
end)
sections.weapons_section:CreateToggle("No Recoil", configs.combat.norecoil, function(value)
configs.combat.norecoil = value
end)
sections.weapons_section:CreateToggle("No Spread", configs.combat.nospread, function(value)
configs.combat.nospread = value
end)
sections.weapons_section:CreateToggle("No Bullet Gravity", configs.combat.nobulletg, function(value)
configs.combat.nobulletg = value
end)
sections.weapons_section:CreateToggle("No Equip Time", configs.combat.noequipt, function(value)
configs.combat.noequipt = value
end)
sections.weapons_section:CreateToggle("Wallbang", configs.combat.wallbang, function(value)
configs.combat.wallbang = value
end)
sections.weapons_section:CreateToggle("Headshot Only", configs.combat.alwaysheadshot, function(value)
configs.combat.alwaysheadshot = value
end)
sections.weapons_section:CreateToggle("Increase Takedown Damage", configs.combat.increasetakedowndamage, function(value)
configs.combat.increasetakedowndamage = value
end)
sections.weapons_section:CreateToggle("Forcefield Anti Misses", configs.combat.forcefieldnomiss, function(value)
configs.combat.forcefieldnomiss = value
end)
sections.weapons_section:CreateToggle("No Sniper Scope Gui", configs.combat.snipernogui, function(value)
configs.combat.snipernogui = value
end)
sections.weapons_section:CreateToggle("No Sniper Scope Blur", configs.combat.snipernoblur, function(value)
configs.combat.snipernoblur = value
end)
sections.weapons_section:CreateToggle("No Grenade Smoke", configs.combat.nogrenadesmoke, function(value)
configs.combat.nogrenadesmoke = value
client.smokeGrenadeHook(configs.combat.nogrenadesmoke)
end)
sections.weapons_section:CreateButton("Open Gunstore UI", function()
set_thread_identity(2)
require(game:GetService("ReplicatedStorage").Game.GunShop.GunShopUI).open()
set_thread_identity(10)
end)
sections.melee_section:CreateToggle("No Reload Time", configs.combat.batonsword.noreloadtime, function(value)
configs.combat.batonsword.noreloadtime = value
if configs.combat.batonsword.noreloadtime then
client.setBatonSwordTime(configs.combat.batonsword.noreloadtime)
end
end)
sections.melee_section:CreateToggle("Always Swoosh", configs.combat.batonsword.spamswoosh, function(value)
configs.combat.batonsword.spamswoosh = value
if configs.combat.batonsword.spamswoosh then
client.spamBatonSwordSwoosh()
end
end)
sections.melee_section:CreateToggle("Always Lunge", configs.combat.batonsword.spamlunge, function(value)
configs.combat.batonsword.spamlunge = value
if configs.combat.batonsword.spamlunge then
client.spamBatonSwordLunge()
end
end)
sections.silentaim_section:CreateToggle("Enabled", configs.combat.silentaim.enabled, function(value)
configs.combat.silentaim.enabled = value
end)
sections.silentaim_section:CreateToggle("Include Taser", configs.combat.silentaim.includetaser, function(value)
configs.combat.silentaim.includetaser = value
end)
sections.silentaim_section:CreateToggle("Include Plasma Gun", configs.combat.silentaim.includeplasma, function(value)
configs.combat.silentaim.includeplasma = value
end)
sections.silentaim_section:CreateSlider(
"Radius",
10,
1000,
configs.combat.silentaim.radius,
false,
function(value)
configs.combat.silentaim.radius = value
Circle.Radius = value
end
)
sections.silentaim_section:CreateToggle("Wallcheck", configs.combat.silentaim.wallcheck, function(value)
configs.combat.silentaim.wallcheck = value
end)
sections.silentaim_section:CreateToggle("FOV Circle", configs.combat.silentaim.fovcirc, function(value)
configs.combat.silentaim.fovcirc = value
Circle.Visible = value
end)
sections.silentaim_section:CreateSlider(
"Circle Thickness",
0,
10,
configs.combat.silentaim.fovthick,
true,
function(value)
configs.combat.silentaim.fovthick = value
Circle.Thickness = value
end
)
sections.silentaim_section:CreateSlider(
"Circle Transparency",
0,
1,
configs.combat.silentaim.fovtransp,
false,
function(value)
configs.combat.silentaim.fovtransp = value
Circle.Transparency = value
end
)
sections.arrestaura_section:CreateToggle("Enabled", configs.combat.arrestaura.enabled, function(value)
configs.combat.arrestaura.enabled = value
if configs.combat.arrestaura.enabled then
client.launchArrestAura()
end
end)
sections.others_section:CreateSlider(
"Hitbox Radius",
3,
50,
configs.combat.hitboxradius,
true,
function(value)
configs.combat.hitboxradius = value
client.changeHitboxRadius(configs.combat.hitboxradius)
end
)
sections.settings_section:CreateDropdown(
"Change Font",
stored_fonts,
function(value)
window:SetFont(value)
end,
"",
false
)
local cleanKeyName = tostring(config.Keybind):gsub("Enum.KeyCode.", "")
sections.settings_section:CreateLabel("Close Menu Key (PC): " .. cleanKeyName)
local config_manager = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
config_manager:SetLibrary(library)
config_manager:SetWindow(window)
config_manager:SetFolder("KaliHub_Folder")
config_manager:BuildConfigSection(tabs.settings)
config_manager:LoadAutoloadConfig()
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
window:SetTileScale(0.5)
window:SetBackgroundColor(Color3.fromRGB(255, 255, 255))
window:SetBackgroundTransparency(0)
