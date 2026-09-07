--this shit was unobfuscated


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local AntiCheatConnections = {}
local AntiRagdollEnabled = true
local MAX_SAFE_WS = 40
local function disableAntiCheat()
local char = LocalPlayer.Character
if not char then
return
end
local hum = char:FindFirstChild("Humanoid")
if hum then
for _, conn in pairs(getconnections(hum.Changed)) do
conn:Disable()
end
for _, conn in pairs(getconnections(hum:GetPropertyChangedSignal("PlatformStand"))) do
conn:Disable()
end
end
for _, partName in pairs({
"HumanoidRootPart",
"Head"
}) do
local part = char:FindFirstChild(partName)
if part then
for _, conn in pairs(getconnections(part.Changed)) do
conn:Disable()
end
end
end
for _, child in pairs(char:GetChildren()) do
if child:IsA("Accessory") or child:IsA("Weld") or child:IsA("WeldConstraint") or child:IsA("ManualWeld") or child.Name == "Handle" then
for _, conn in pairs(getconnections(child.Changed)) do
conn:Disable()
end
end
end
end
local function setupAntiRagdoll()
local char = LocalPlayer.Character
if not char then
return
end
local hum = char:FindFirstChild("Humanoid")
if not hum then
return
end
if AntiCheatConnections["PlatformStand"] then
AntiCheatConnections["PlatformStand"]:Disconnect()
end
AntiCheatConnections["PlatformStand"] = hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
if AntiRagdollEnabled then
hum.PlatformStand = false
end
end)
end
LocalPlayer.CharacterAdded:Connect(function()
task.wait(0.5)
disableAntiCheat()
setupAntiRagdoll()
end)
disableAntiCheat()
setupAntiRagdoll()
local stored_fonts = {}
gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 150,
MaxHeight = 680,
InitialHeight = 470,
MinWidth = 350,
MaxWidth = 800,
InitialWidth = 520
}
for _, v in Enum.Font:GetEnumItems() do
table.insert(stored_fonts, v.Name)
end
local config = (getfenv().gui_config) or nil
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local guisBefore = {}
for _, child in ipairs(playerGui:GetChildren()) do
guisBefore[child] = true
end
local window = library:CreateWindow(config, playerGui)
for _, child in ipairs(playerGui:GetChildren()) do
if not guisBefore[child] and child:IsA("ScreenGui") then
child.ResetOnSpawn = false
end
end
library:SetWindowName("Kali Hub | ZO SAMURAI SWORD FIGHTING")
local tabs = {
main = window:CreateTab("Main"),
visuals = window:CreateTab("Visuals"),
settings = window:CreateTab("Settings")
}
local sections = {
combat = tabs.main:CreateSection("Combat"),
protections = tabs.main:CreateSection("Protections"),
movement = tabs.main:CreateSection("Movement"),
teleports = tabs.main:CreateSection("Teleports"),
farm = tabs.main:CreateSection("Farm"),
inventory = tabs.main:CreateSection("Inventory"),
esp = tabs.visuals:CreateSection("ESP"),
espStyle = tabs.visuals:CreateSection("Style"),
settings = tabs.settings:CreateSection("Settings")
}
local AutoParry = {
Enabled = false,
MaxDistance = 15,
HoldTime = 0.6
}
local cachedRemote, cachedRemoteName
local function getActionRemote()
local id = ReplicatedStorage:FindFirstChild("AirDensityMapIdentifier")
if not id or id.Value == "" or id.Value == "NLDEDYT" then
return nil
end
if cachedRemoteName ~= id.Value or not (cachedRemote and cachedRemote.Parent) then
cachedRemoteName = id.Value
cachedRemote = ReplicatedStorage:FindFirstChild(id.Value)
end
return cachedRemote
end
local function getEquippedTool()
local char = LocalPlayer.Character
return char and char:FindFirstChildOfClass("Tool") or nil
end
local guard = { down = false, holdUntil = 0, handler = nil }
local blockMouse = LocalPlayer:GetMouse()
local WEAPON_TOOL_UPVALUE = 10
local WEAPON_BLOCK_HELD_UPVALUE = 4
local function getBlockHandler()
local char = LocalPlayer.Character
if not char then
return nil
end
for _, connection in ipairs(getconnections(blockMouse.Button2Down)) do
local handler = connection.Function
if handler and tostring(debug.info(handler, "s")):find("Weapon") then
local gotTool, tool = pcall(debug.getupvalue, handler, WEAPON_TOOL_UPVALUE)
local gotHeld, held = pcall(debug.getupvalue, handler, WEAPON_BLOCK_HELD_UPVALUE)
if gotTool and gotHeld and type(held) == "boolean"
and typeof(tool) == "Instance" and tool:IsA("Tool") and tool.Parent == char then
return handler
end
end
end
return nil
end
local function guardDown()
if guard.down then
return
end
local handler = getBlockHandler()
if not handler then
return
end
guard.down = true
guard.handler = handler
task.spawn(handler)
end
local function guardUp()
if not guard.down then
return
end
guard.down = false
local handler = guard.handler
guard.handler = nil
if handler then
pcall(debug.setupvalue, handler, WEAPON_BLOCK_HELD_UPVALUE, false)
end
end
local function canGuard()
local char = LocalPlayer.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local tool = char and char:FindFirstChildOfClass("Tool")
return hum ~= nil and hum.Health > 0 and tool ~= nil and not tool:GetAttribute("Stunned")
end
local function inRange(char)
local myChar = LocalPlayer.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
local root = char and char:FindFirstChild("HumanoidRootPart")
if not (myRoot and root) then
return false
end
return (myRoot.Position - root.Position).Magnitude <= AutoParry.MaxDistance
end
local function armGuard(char)
if AutoParry.Enabled and inRange(char) then
guard.holdUntil = os.clock() + AutoParry.HoldTime
end
end
local watchers = {}
local function unwatch(player)
local conns = watchers[player]
if not conns then
return
end
for _, conn in ipairs(conns) do
conn:Disconnect()
end
watchers[player] = nil
end
local function watchCharacter(player, char)
unwatch(player)
local conns = {}
watchers[player] = conns
local hum = char:WaitForChild("Humanoid", 10)
local animator = hum and hum:WaitForChild("Animator", 10)
if animator then
table.insert(conns, animator.AnimationPlayed:Connect(function(track)
if track.Priority == Enum.AnimationPriority.Action2 and not track.Looped then
armGuard(char)
end
end))
end
local function watchTool(tool)
table.insert(conns, tool:GetAttributeChangedSignal("Parry"):Connect(function()
if tool:GetAttribute("Parry") then
armGuard(char)
end
end))
end
for _, child in ipairs(char:GetChildren()) do
if child:IsA("Tool") then
watchTool(child)
end
end
table.insert(conns, char.ChildAdded:Connect(function(child)
if child:IsA("Tool") then
watchTool(child)
end
end))
end
local function trackPlayer(player)
if player == LocalPlayer then
return
end
if player.Character then
task.spawn(watchCharacter, player, player.Character)
end
player.CharacterAdded:Connect(function(char)
task.spawn(watchCharacter, player, char)
end)
end
for _, player in ipairs(Players:GetPlayers()) do
trackPlayer(player)
end
Players.PlayerAdded:Connect(trackPlayer)
Players.PlayerRemoving:Connect(unwatch)
local parryConnection
local function startAutoParry()
if parryConnection then
return
end
parryConnection = RunService.Heartbeat:Connect(function()
if AutoParry.Enabled and os.clock() < guard.holdUntil and canGuard() then
guardDown()
else
guardUp()
end
end)
end
local function stopAutoParry()
if parryConnection then
parryConnection:Disconnect()
parryConnection = nil
end
guard.holdUntil = 0
guardUp()
end
LocalPlayer.CharacterAdded:Connect(function()
guard.down = false
guard.handler = nil
guard.holdUntil = 0
end)
local KillAura = {
Enabled = false,
Range = 14,
Interval = 0.5
}
local AutoKick = {
Enabled = false,
Range = 12,
Interval = 2.6
}
local HIT_TAG = "WOAH YOU HIT SOMEONE!"
local KICK_TAG = "KICKYWICKY"
local HIT_PARTS = { "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
local function isValidTarget(player)
if player == LocalPlayer then
return false
end
local char = player.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 or hum:GetAttribute("IsDead") then
return false
end
if char:FindFirstChild("Dissolved") then
return false
end
local myChar = LocalPlayer.Character
local safezone = player:FindFirstChild("IsInSafezone")
if safezone and safezone.Value and not (myChar and myChar:GetAttribute("CanDamageInSafezone")) then
return false
end
local ultSafe = player:FindFirstChild("IsUltimateSafe")
if ultSafe and ultSafe.Value then
return false
end
return true
end
local function pickHitPart(char)
for _, name in ipairs(HIT_PARTS) do
local part = char:FindFirstChild(name)
if part then
return part
end
end
return nil
end
local function combatOrigin()
local remote, tool = getActionRemote(), getEquippedTool()
local myChar = LocalPlayer.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
if not (remote and tool and myRoot) or tool:GetAttribute("Stunned") then
return nil
end
return remote, tool, myRoot :: BasePart
end
local killAuraLast = 0
RunService.Heartbeat:Connect(function()
if not KillAura.Enabled then
return
end
local now = os.clock()
if now - killAuraLast < KillAura.Interval then
return
end
local remote, tool, myRoot = combatOrigin()
if not remote then
return
end
local fired = false
for _, player in ipairs(Players:GetPlayers()) do
if isValidTarget(player) then
local char = player.Character
local root = char:FindFirstChild("HumanoidRootPart")
if root and (myRoot.Position - root.Position).Magnitude <= KillAura.Range then
local part = pickHitPart(char)
if part then
pcall(remote.FireServer, remote, HIT_TAG, tool, part, myRoot.CFrame)
fired = true
end
end
end
end
if fired then
killAuraLast = now
end
end)
local autoKickLast = 0
RunService.Heartbeat:Connect(function()
if not AutoKick.Enabled then
return
end
local now = os.clock()
if now - autoKickLast < AutoKick.Interval then
return
end
local remote, tool, myRoot = combatOrigin()
if not remote then
return
end
local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if not hum then
return
end
local state = hum:GetState()
if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
return
end
local closest, closestDist = nil, AutoKick.Range
for _, player in ipairs(Players:GetPlayers()) do
if isValidTarget(player) then
local root = player.Character:FindFirstChild("HumanoidRootPart")
if root then
local distance = (myRoot.Position - root.Position).Magnitude
if distance < closestDist then
closest, closestDist = player.Character, distance
end
end
end
end
if not closest then
return
end
autoKickLast = now
pcall(remote.FireServer, remote, KICK_TAG, tool, closest, myRoot.CFrame)
end)
local Weapons = {
"Odachi",
"Katana",
"Tanto",
"Kusarigama",
"Caestus",
"Kanabo",
"Naginata",
"Scythe"
}
local NetworkNew
do
local ok, module = pcall(function()
return require(ReplicatedStorage:WaitForChild("Utils"):WaitForChild("NetworkNew"))
end)
NetworkNew = ok and module or nil
end
local function notify(text, duration)
pcall(function()
window:Notify("Kali Hub", text, duration or 5)
end)
end
local EMPTY_OPTION = "-"
local function shrineTargets()
local list = {}
local shrines = Workspace:FindFirstChild("Shrines")
if shrines then
for _, child in ipairs(shrines:GetChildren()) do
if child:IsA("Model") then
table.insert(list, child.Name)
elseif child:IsA("Folder") then
for _, sub in ipairs(child:GetChildren()) do
if sub:IsA("Model") then
table.insert(list, sub.Name)
end
end
end
end
end
table.sort(list)
if #list == 0 then
table.insert(list, EMPTY_OPTION)
end
return list
end
local function serverHop()
if not NetworkNew then
notify("Network module unavailable")
return
end
local ok, list = pcall(function()
return NetworkNew:InvokeServer("GrabServerList")
end)
if not ok or type(list) ~= "table" then
notify("Could not fetch the server list")
return
end
local candidates = {}
for _, entry in pairs(list) do
if type(entry) == "table" and entry.JobId and entry.JobId ~= game.JobId and entry.ServerType == "Main" then
table.insert(candidates, entry)
end
end
if #candidates == 0 then
notify("No other main server available")
return
end
local pick = candidates[math.random(#candidates)]
pcall(function()
NetworkNew:FireServer("RequestTeleport", pick.PlaceId, pick.JobId, pick.ServerType)
end)
end
local function skinsFor(weaponType)
local list = {}
local shopData = ReplicatedStorage:FindFirstChild("ShopData")
local skins = shopData and shopData:FindFirstChild("Weapon Skins")
local folder = skins and skins:FindFirstChild(weaponType)
if folder then
for _, skin in ipairs(folder:GetChildren()) do
table.insert(list, skin.Name)
end
table.sort(list)
end
if #list == 0 then
table.insert(list, EMPTY_OPTION)
end
return list
end
local function networkFire(...)
if not NetworkNew then
return false
end
local args = table.pack(...)
return (pcall(function()
NetworkNew:FireServer(table.unpack(args, 1, args.n))
end))
end
local function redeemAllCodes()
local general = ReplicatedStorage:FindFirstChild("General")
local folder = general and general:FindFirstChild("Codes")
local remote = ReplicatedStorage:FindFirstChild("Code")
if not (folder and remote) then
notify("Codes data unavailable")
return
end
local redeemed = 0
for _, entry in ipairs(folder:GetChildren()) do
local stripped = entry.Name:gsub("%s+AFEF$", "")
for _, candidate in ipairs({ stripped, entry.Name }) do
local ok, result = pcall(function()
return remote:InvokeServer(string.upper(candidate))
end)
if ok and result == "Success" then
redeemed = redeemed + 1
break
end
end
task.wait(0.3)
end
notify(("Redeemed %d code(s)"):format(redeemed), 6)
end
local function claimPlaytimeRewards()
local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
local gui = playerGui and playerGui:FindFirstChild("PlaytimeRewards")
if not gui then
return 0
end
local claimed = 0
for _, frame in ipairs(gui:GetDescendants()) do
if frame:IsA("GuiObject") and frame.LayoutOrder > 0 then
local claim = frame:FindFirstChild("Claim")
local done = frame:FindFirstChild("Claimed")
if claim and done and claim.Visible and not done.Visible then
local label = claim:FindFirstChild("Amount")
if label and label:IsA("TextLabel") and label.Text == "CLAIM!" then
networkFire("ClaimPlaytimeReward", frame.LayoutOrder)
claimed = claimed + 1
end
end
end
end
return claimed
end
local function claimShurikenRewards()
local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
local gui = playerGui and playerGui:FindFirstChild("ShurikenMayhem")
if not gui then
return 0
end
local claimed = 0
for _, frame in ipairs(gui:GetDescendants()) do
local index = tonumber(frame.Name)
local button = index and frame:FindFirstChild("ClaimButton")
if button and button:IsA("GuiObject") and button.Visible then
networkFire("ClaimShurikenMayhem", index)
claimed = claimed + 1
end
end
return claimed
end
local function equipSkin(name, pair)
local equip = ReplicatedStorage:FindFirstChild("EquipWeapon")
if not equip then
return false
end
local ok, result = pcall(function()
return equip:InvokeServer(pair and { name, name } or name, "NoWepEquip")
end)
return ok and result == "Success"
end
sections.combat:CreateToggle("Kill Aura", false, function(state)
KillAura.Enabled = state
end)
sections.combat:CreateSlider("Kill Aura Range", 6, 25, 14, true, function(value)
KillAura.Range = value
end)
sections.combat:CreateSlider("Kill Aura Interval (ms)", 200, 1500, 500, true, function(value)
KillAura.Interval = value / 1000
end)
sections.combat:CreateToggle("Auto Parry", false, function(state)
AutoParry.Enabled = state
if state then
startAutoParry()
else
stopAutoParry()
end
end, nil, "Guards in reaction to an enemy swing")
sections.combat:CreateSlider("Parry Distance", 8, 25, 15, true, function(value)
AutoParry.MaxDistance = value
end)
sections.combat:CreateSlider("Parry Hold (ms)", 200, 1200, 600, true, function(value)
AutoParry.HoldTime = value / 1000
end)
sections.combat:CreateDropdown(
"Select Weapon",
Weapons,
function(choice)
local args = {
[1] = choice,
[2] = "DoWepSkin"
}
game:GetService("ReplicatedStorage"):WaitForChild("EquipWeapon"):InvokeServer(unpack(args))
end,
"",
false
)
local autoFinishEnabled = false
local HOLD_TIME = 5
local function autoHoldPrompt()
while autoFinishEnabled do
for _, prompt in pairs(game:GetService("Workspace"):GetDescendants()) do
if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Finish" then
if not prompt.Enabled then
continue
end
prompt:InputHoldBegin()
task.wait(HOLD_TIME)
prompt:InputHoldEnd()
end
end
task.wait(0.1)
end
end
sections.combat:CreateToggle("Auto Finish", false, function(state)
autoFinishEnabled = state
if state then
task.spawn(autoHoldPrompt)
end
end)
sections.combat:CreateToggle("Auto Kick", false, function(state)
AutoKick.Enabled = state
end)
sections.combat:CreateSlider("Auto Kick Range", 6, 20, 12, true, function(value)
AutoKick.Range = value
end)
sections.combat:CreateSlider("Auto Kick Interval (ms)", 2600, 6000, 2600, true, function(value)
AutoKick.Interval = value / 1000
end)
sections.protections:CreateToggle("Anti Moderator", false, function(state)
getgenv().AntiModerator = state
if state then
local ModIds = {
1434829778,
5278951968,
4709654828,
5843626,
3137690711,
3218293651,
186274604,
165042728,
3402041400,
194804309,
557355629,
90540189,
1700247314,
1204065092,
39619388,
523680050,
347032248
}
local plr = LocalPlayer
game.Players.PlayerAdded:Connect(function(newPlr)
if not getgenv().AntiModerator then
return
end
if table.find(ModIds, newPlr.UserId) then
plr:Kick("Anti Moderator: Staff/UserId detected!")
end
end)
task.spawn(function()
while getgenv().AntiModerator do
for _, p in pairs(game.Players:GetPlayers()) do
if table.find(ModIds, p.UserId) then
plr:Kick("Anti Moderator: Staff/UserId detected!")
end
end
task.wait(2)
end
end)
end
end)
sections.protections:CreateToggle("Anti Stun", false, function(state)
getgenv().AntiStun = state
while getgenv().AntiStun do
local player = LocalPlayer
local function disableStun(tool)
if tool:GetAttribute("Stunned") ~= nil then
tool:SetAttribute("Stunned", false)
tool:SetAttribute("Stunned", nil)
end
tool:GetAttributeChangedSignal("Stunned"):Connect(function()
tool:SetAttribute("Stunned", nil)
end)
end
for _, tool in pairs(player.Backpack:GetChildren()) do
if tool:IsA("Tool") then
disableStun(tool)
end
end
if player.Character then
for _, tool in pairs(player.Character:GetChildren()) do
if tool:IsA("Tool") then
disableStun(tool)
end
end
end
task.wait(0.1)
end
end)
sections.protections:CreateToggle("Anti Fall Damage", false, function(state)
getgenv().AntiFallDamage = state
if state and not getgenv().FallConnection then
local tookFall = ReplicatedStorage:WaitForChild("TookFallDamage")
getgenv().FallConnection = tookFall.OnClientEvent:Connect(function(p4)
if getgenv().AntiFallDamage then
p4 = 0
end
end)
end
end)
sections.protections:CreateToggle("Anti Ragdoll", true, function(state)
AntiRagdollEnabled = state
setupAntiRagdoll()
end)
local autoReviveEnabled = false
local autoReviveMode = "Respawn"
sections.protections:CreateToggle("Auto Revive", false, function(state)
autoReviveEnabled = state
if not state then
return
end
task.spawn(function()
while autoReviveEnabled do
local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if hum and hum.Health <= 0 then
local request = autoReviveMode == "Safezone" and _G.RequestSafeZone or _G.RequestSelfRevive
if type(request) == "function" then
pcall(request)
end
end
task.wait(1)
end
end)
end)
sections.protections:CreateDropdown(
"Revive Mode",
{ "Respawn", "Safezone" },
function(choice)
autoReviveMode = choice
end,
"Respawn",
false
)
local walkspeedEnabled = false
local originalWalkSpeed = nil
local currentWalkSpeed = 16
local walkSpeedLoop = nil
local function applyWalkSpeed()
local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
if hum and currentWalkSpeed and walkspeedEnabled then
if hum.WalkSpeed ~= currentWalkSpeed then
hum.WalkSpeed = currentWalkSpeed
end
end
end
sections.movement:CreateToggle("WalkSpeed", false, function(state)
walkspeedEnabled = state
local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
if hum and not originalWalkSpeed then
originalWalkSpeed = hum.WalkSpeed
end
if walkspeedEnabled then
if walkSpeedLoop then
walkSpeedLoop:Disconnect()
end
walkSpeedLoop = RunService.Heartbeat:Connect(function()
disableAntiCheat()
applyWalkSpeed()
end)
else
if walkSpeedLoop then
walkSpeedLoop:Disconnect()
end
walkSpeedLoop = nil
if hum and originalWalkSpeed then
hum.WalkSpeed = originalWalkSpeed
end
end
end)
sections.movement:CreateSlider("WalkSpeed Value", 12, MAX_SAFE_WS, 16, 1, function(value)
currentWalkSpeed = math.clamp(value, 12, MAX_SAFE_WS)
end)
LocalPlayer.CharacterAdded:Connect(function()
local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
if hum and not originalWalkSpeed then
originalWalkSpeed = hum.WalkSpeed
end
if walkSpeedLoop then
walkSpeedLoop:Disconnect()
end
if walkspeedEnabled and currentWalkSpeed then
walkSpeedLoop = RunService.Heartbeat:Connect(function()
disableAntiCheat()
applyWalkSpeed()
end)
end
end)
local function getNormalSpawns()
local spawnList = {}
local normalFolder = workspace:WaitForChild("Spawns"):FindFirstChild("Normal")
if normalFolder then
for _, spawn in ipairs(normalFolder:GetChildren()) do
if spawn:IsA("SpawnLocation") then
table.insert(spawnList, spawn.Name)
end
end
end
if #spawnList == 0 then
table.insert(spawnList, EMPTY_OPTION)
end
return spawnList
end
local function getPortals()
local portalList = {}
local portalFolder = workspace:WaitForChild("Spawns"):FindFirstChild("PortalKE")
if portalFolder then
for _, part in ipairs(portalFolder:GetChildren()) do
if part:IsA("BasePart") then
table.insert(portalList, part.Name)
end
end
end
if #portalList == 0 then
table.insert(portalList, EMPTY_OPTION)
end
return portalList
end
sections.teleports:CreateDropdown(
"Teleport to Normal Spawn",
getNormalSpawns(),
function(choice)
local normalFolder = workspace.Spawns:FindFirstChild("Normal")
local spawn = normalFolder and normalFolder:FindFirstChild(choice)
if spawn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character:PivotTo(spawn.CFrame + Vector3.new(0, 5, 0))
end
end,
"",
false
)
sections.teleports:CreateDropdown(
"Teleport to Portal",
getPortals(),
function(choice)
local portalFolder = workspace.Spawns:FindFirstChild("PortalKE")
local part = portalFolder and portalFolder:FindFirstChild(choice)
if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character:PivotTo(part.CFrame + Vector3.new(0, 5, 0))
end
end,
"",
false
)
sections.teleports:CreateDropdown(
"Teleport to Shrine",
shrineTargets(),
function(choice)
local shrines = Workspace:FindFirstChild("Shrines")
local shrine = shrines and shrines:FindFirstChild(choice, true)
if not shrine then
notify("Shrine not found: " .. tostring(choice))
return
end
pcall(function()
ReplicatedStorage:WaitForChild("ShrineTeleport"):InvokeServer(shrine)
end)
end,
"",
false
)
sections.teleports:CreateDropdown(
"Teleport to Zone",
{ "Main", "Duels", "Trade Zone" },
function(choice)
local ok, result = pcall(function()
return ReplicatedStorage:WaitForChild("Teleport"):InvokeServer(choice)
end)
if not ok or not result then
notify("Zone teleport refused: " .. tostring(choice))
end
end,
"",
false
)
sections.teleports:CreateButton("Teleport to Shuriken Event", function()
networkFire("TeleportToShuriken")
end)
sections.teleports:CreateButton("Server Hop", serverHop)
sections.farm:CreateButton("Redeem All Codes", function()
task.spawn(redeemAllCodes)
end)
sections.farm:CreateButton("Claim Referral Rewards", function()
networkFire("ClaimReferralRewards")
notify("Requested referral rewards")
end)
local autoPlaytimeEnabled = false
sections.farm:CreateToggle("Auto Playtime Rewards", false, function(state)
autoPlaytimeEnabled = state
if not state then
return
end
task.spawn(function()
networkFire("RequestSetupPlaytimeRewards")
while autoPlaytimeEnabled do
claimPlaytimeRewards()
task.wait(30)
end
end)
end)
local afkEnabled = false
sections.farm:CreateToggle("AFK Mode", false, function(state)
afkEnabled = state
if not state then
networkFire("RequestAFK", false)
return
end
task.spawn(function()
while afkEnabled do
if LocalPlayer:GetAttribute("AFK") ~= true then
networkFire("RequestAFK", true)
end
task.wait(5)
end
end)
end)
local bloodMoonEnabled = false
sections.farm:CreateToggle("Auto Blood Moon", false, function(state)
bloodMoonEnabled = state
if not state then
return
end
task.spawn(function()
local joined = false
while bloodMoonEnabled do
local sharedTime = ReplicatedStorage:FindFirstChild("SharedTime")
local start = sharedTime and sharedTime:FindFirstChild("BloodMoonStart")
if start and start.Value ~= -1 then
if not joined then
networkFire("JoinBloodMoon")
joined = true
task.wait(3)
end
networkFire("TeleportToBloodMoonChest")
task.wait(1)
networkFire("OpenBloodMoonChest")
else
joined = false
end
task.wait(10)
end
end)
end)
local shurikenEnabled = false
sections.farm:CreateToggle("Auto Shuriken Mayhem", false, function(state)
shurikenEnabled = state
if not state then
return
end
task.spawn(function()
networkFire("RequestShurikenTable")
while shurikenEnabled do
networkFire("RequestShurikenMayhemWeapon")
claimShurikenRewards()
task.wait(10)
end
end)
end)
local SkinChanger = {
Enabled = false,
Skin = nil,
cache = {},
applied = nil
}
local function fetchSkinTool(name)
if SkinChanger.cache[name] then
return SkinChanger.cache[name]
end
local remote = ReplicatedStorage:FindFirstChild("GetWeaponSkinPreview")
if not remote then
return nil
end
for _ = 1, 8 do
local ok, result = pcall(remote.InvokeServer, remote, name)
if ok and typeof(result) == "Instance" then
local clone = result:Clone()
SkinChanger.cache[name] = clone
return clone
end
if not (ok and result == "Ratelimited") then
break
end
task.wait(0.65)
end
return nil
end
local function hideForSkin(hidden, inst)
if inst:IsA("BasePart") or inst:IsA("Texture") or inst:IsA("Decal") then
table.insert(hidden, { inst, "Transparency", inst.Transparency })
inst.Transparency = 1
elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("Light") then
table.insert(hidden, { inst, "Enabled", inst.Enabled })
inst.Enabled = false
end
end
local function removeSkinVisual()
local applied = SkinChanger.applied
SkinChanger.applied = nil
if not applied then
return
end
for _, entry in ipairs(applied.hidden) do
if entry[1].Parent then
pcall(function()
entry[1][entry[2]] = entry[3]
end)
end
end
if applied.visual then
applied.visual:Destroy()
end
end
local function applySkinVisual()
removeSkinVisual()
local name = SkinChanger.Skin
if not (SkinChanger.Enabled and name) then
return
end
local src = fetchSkinTool(name)
local srcHandle = src and src:FindFirstChild("Handle")
if not srcHandle then
notify("Skin preview unavailable: " .. tostring(name))
return
end
local char = LocalPlayer.Character
local tool = char and char:FindFirstChildOfClass("Tool")
local arm = char and char:FindFirstChild(src:GetAttribute("SWAPHANDS") and "Left Arm" or "Right Arm")
if not (tool and arm) then
return
end
local hidden = {}
local function hideTree(root)
if not root then
return
end
hideForSkin(hidden, root)
for _, inst in ipairs(root:GetDescendants()) do
hideForSkin(hidden, inst)
end
end
hideTree(tool)
for _, partName in ipairs({ "Handle", "Handle2", "KusarigamaHandModel", "KusarigamaHandModel2" }) do
hideTree(char:FindFirstChild(partName))
end
local visual = srcHandle:Clone()
visual.Name = "Ornament"
for _, inst in ipairs(visual:GetDescendants()) do
if inst:IsA("BasePart") then
inst.CanCollide = false
inst.Massless = true
inst.Transparency = inst:GetAttribute("OverrideTransparency") or 0
elseif inst:IsA("Sound") or inst:IsA("BaseScript") then
inst:Destroy()
end
end
visual.CanCollide = false
visual.CanTouch = false
visual.Massless = true
visual.Transparency = visual:GetAttribute("OverrideTransparency") or 0
local weldCF = src:GetAttribute("ToolWeldCF") or CFrame.new()
local weld = Instance.new("Motor6D")
weld.C0 = weldCF
weld.Part0 = arm
weld.Part1 = visual
visual.CFrame = arm.CFrame * weldCF
weld.Parent = visual
visual.Parent = tool
SkinChanger.applied = { hidden = hidden, visual = visual }
end
local function watchSkinTool(char)
char.ChildAdded:Connect(function(child)
if (child:IsA("Tool") or child.Name == "Handle") and SkinChanger.Enabled then
task.spawn(function()
task.wait(0.1)
applySkinVisual()
end)
end
end)
end
if LocalPlayer.Character then
watchSkinTool(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(function(char)
SkinChanger.applied = nil
watchSkinTool(char)
end)
local skinDropdown
sections.inventory:CreateDropdown(
"Skin Weapon Type",
Weapons,
function(choice)
if skinDropdown then
skinDropdown:ChangeOptions(skinsFor(choice), "")
end
end,
"",
false
)
skinDropdown = sections.inventory:CreateDropdown(
"Skin",
skinsFor(Weapons[1]),
function(choice)
if not choice or choice == "" or choice == EMPTY_OPTION then
return
end
SkinChanger.Skin = choice
if SkinChanger.Enabled then
task.spawn(applySkinVisual)
end
end,
"",
false
)
sections.inventory:CreateToggle("Skin Changer", false, function(state)
SkinChanger.Enabled = state
if state then
task.spawn(applySkinVisual)
else
removeSkinVisual()
end
end, nil, "Client-side visual - other players see your real weapon")
sections.inventory:CreateButton("Equip Skin (Owned Only)", function()
local name = skinDropdown and skinDropdown:GetOption()
if not name or name == "" or name == EMPTY_OPTION then
notify("Pick a skin first")
return
end
notify(equipSkin(name, false) and ("Equipped " .. name) or ("Not owned: " .. name))
end)
sections.inventory:CreateButton("Dual Wield Selected Skin", function()
local name = skinDropdown and skinDropdown:GetOption()
if not name or name == "" then
notify("Pick a skin first")
return
end
notify(equipSkin(name, true) and ("Dual wielding " .. name) or "Dual wield refused - not purchased for this weapon", 6)
end)
local UserInputService = game:GetService("UserInputService")
local ESP = {
Enabled = false,
Box = true,
BoxFill = false,
Name = true,
HealthBar = true,
Distance = true,
Weapon = false,
CombatStatus = true,
Tracer = false,
Chams = false,
TracerOrigin = "Bottom",
MaxDistance = 500,
TextSize = 13,
BoxColor = Color3.fromRGB(255, 255, 255),
ChamsColor = Color3.fromRGB(140, 80, 255)
}
local espObjects = {}
local DRAWING_KEYS = { "boxOutline", "box", "fill", "healthBack", "healthBar", "tracer", "name", "combat", "weapon", "distance" }
local function newText()
local text = Drawing.new("Text")
text.Visible = false
text.Center = true
text.Outline = true
text.Font = Drawing.Fonts.Plex
text.Size = ESP.TextSize
text.Transparency = 1
return text
end
local function newSquare(thickness, filled)
local square = Drawing.new("Square")
square.Visible = false
square.Thickness = thickness
square.Filled = filled or false
square.Transparency = 1
return square
end
local function createEsp(player)
if espObjects[player] then
return
end
local o = {
boxOutline = newSquare(3),
box = newSquare(1),
fill = newSquare(1, true),
healthBack = newSquare(1, true),
healthBar = newSquare(1, true),
tracer = Drawing.new("Line"),
name = newText(),
combat = newText(),
weapon = newText(),
distance = newText()
}
o.boxOutline.Color = Color3.new(0, 0, 0)
o.healthBack.Color = Color3.new(0, 0, 0)
o.fill.Transparency = 0.25
o.tracer.Visible = false
o.tracer.Thickness = 1
o.tracer.Transparency = 1
espObjects[player] = o
end
local function destroyEsp(player)
local o = espObjects[player]
if not o then
return
end
for _, key in ipairs(DRAWING_KEYS) do
o[key]:Remove()
end
if o.highlight then
o.highlight:Destroy()
end
espObjects[player] = nil
end
local function updateChams(o, char, show)
if show then
local highlight = o.highlight
if not (highlight and highlight.Parent) or highlight.Adornee ~= char then
if highlight then
highlight:Destroy()
end
highlight = Instance.new("Highlight")
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.FillTransparency = 0.6
highlight.OutlineTransparency = 0
highlight.Adornee = char
highlight.Parent = char
o.highlight = highlight
end
highlight.FillColor = ESP.ChamsColor
highlight.OutlineColor = ESP.ChamsColor
highlight.Enabled = true
elseif o.highlight then
o.highlight.Enabled = false
end
end
local function tracerFrom()
local viewport = Camera.ViewportSize
if ESP.TracerOrigin == "Center" then
return Vector2.new(viewport.X / 2, viewport.Y / 2)
elseif ESP.TracerOrigin == "Mouse" then
return UserInputService:GetMouseLocation()
end
return Vector2.new(viewport.X / 2, viewport.Y)
end
RunService.RenderStepped:Connect(function()
local myChar = LocalPlayer.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
for player, o in pairs(espObjects) do
local char = player.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
local distance = (root and myRoot) and (myRoot.Position - root.Position).Magnitude or math.huge
local inRange = ESP.Enabled and hum and hum.Health > 0 and distance <= ESP.MaxDistance
updateChams(o, char, inRange and ESP.Chams or false)
local shown = false
if inRange then
local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
if onScreen then
shown = true
o.hidden = false
local top = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
local height = math.abs(bottom.Y - top.Y)
local width = height * 0.6
local x, y = pos.X - width / 2, top.Y
o.boxOutline.Visible = ESP.Box
o.box.Visible = ESP.Box
if ESP.Box then
o.boxOutline.Position = Vector2.new(x, y)
o.boxOutline.Size = Vector2.new(width, height)
o.box.Position = o.boxOutline.Position
o.box.Size = o.boxOutline.Size
o.box.Color = ESP.BoxColor
end
o.fill.Visible = ESP.BoxFill
if ESP.BoxFill then
o.fill.Position = Vector2.new(x, y)
o.fill.Size = Vector2.new(width, height)
o.fill.Color = ESP.BoxColor
end
o.healthBack.Visible = ESP.HealthBar
o.healthBar.Visible = ESP.HealthBar
if ESP.HealthBar then
local frac = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
local barHeight = height * frac
o.healthBack.Position = Vector2.new(x - 6, y)
o.healthBack.Size = Vector2.new(3, height)
o.healthBar.Position = Vector2.new(x - 6, y + height - barHeight)
o.healthBar.Size = Vector2.new(3, barHeight)
o.healthBar.Color = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), frac)
end
o.name.Visible = ESP.Name
if ESP.Name then
o.name.Size = ESP.TextSize
o.name.Color = Color3.new(1, 1, 1)
o.name.Text = player.Name
o.name.Position = Vector2.new(pos.X, y - ESP.TextSize - 3)
end
local tool = char:FindFirstChildOfClass("Tool")
local tag, tagColor
if ESP.CombatStatus and tool then
if tool:GetAttribute("Parry") then
tag, tagColor = "PARRYING", Color3.fromRGB(90, 200, 255)
elseif tool:GetAttribute("Blocking") then
tag, tagColor = "BLOCKING", Color3.fromRGB(255, 170, 0)
end
end
o.combat.Visible = tag ~= nil
if tag then
local nameOffset = ESP.Name and (ESP.TextSize + 3) or 0
o.combat.Size = ESP.TextSize
o.combat.Text = tag
o.combat.Color = tagColor
o.combat.Position = Vector2.new(pos.X, y - ESP.TextSize - 3 - nameOffset)
end
local under = y + height + 3
o.weapon.Visible = ESP.Weapon and tool ~= nil
if o.weapon.Visible then
o.weapon.Size = ESP.TextSize
o.weapon.Text = tool.Name
o.weapon.Color = Color3.fromRGB(200, 200, 200)
o.weapon.Position = Vector2.new(pos.X, under)
under = under + ESP.TextSize + 2
end
o.distance.Visible = ESP.Distance
if ESP.Distance then
o.distance.Size = ESP.TextSize
o.distance.Text = math.floor(distance) .. " studs"
o.distance.Color = Color3.fromRGB(200, 200, 200)
o.distance.Position = Vector2.new(pos.X, under)
end
o.tracer.Visible = ESP.Tracer
if ESP.Tracer then
o.tracer.Color = ESP.BoxColor
o.tracer.From = tracerFrom()
o.tracer.To = Vector2.new(pos.X, y + height)
end
end
end
if not shown and not o.hidden then
for _, key in ipairs(DRAWING_KEYS) do
o[key].Visible = false
end
o.hidden = true
end
end
end)
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
createEsp(player)
end
end
Players.PlayerAdded:Connect(function(player)
if player ~= LocalPlayer then
createEsp(player)
end
end)
Players.PlayerRemoving:Connect(destroyEsp)
sections.esp:CreateToggle("Enable ESP", false, function(state)
ESP.Enabled = state
end)
sections.esp:CreateToggle("Box", true, function(state)
ESP.Box = state
end)
sections.esp:CreateToggle("Box Fill", false, function(state)
ESP.BoxFill = state
end)
sections.esp:CreateToggle("Name", true, function(state)
ESP.Name = state
end)
sections.esp:CreateToggle("Health Bar", true, function(state)
ESP.HealthBar = state
end)
sections.esp:CreateToggle("Distance", true, function(state)
ESP.Distance = state
end)
sections.esp:CreateToggle("Weapon", false, function(state)
ESP.Weapon = state
end)
sections.esp:CreateToggle("Combat Status", true, function(state)
ESP.CombatStatus = state
end, nil, "Shows BLOCKING / PARRYING above enemies")
sections.esp:CreateToggle("Tracers", false, function(state)
ESP.Tracer = state
end)
sections.esp:CreateToggle("Chams", false, function(state)
ESP.Chams = state
end)
sections.espStyle:CreateSlider("Max Distance", 100, 2000, 500, true, function(value)
ESP.MaxDistance = value
end)
sections.espStyle:CreateSlider("Text Size", 10, 20, 13, true, function(value)
ESP.TextSize = value
end)
sections.espStyle:CreateDropdown(
"Tracer Origin",
{ "Bottom", "Center", "Mouse" },
function(choice)
ESP.TracerOrigin = choice
end,
"Bottom",
false
)
sections.espStyle:CreateColorpicker("Box Color", function(color)
ESP.BoxColor = color
end)
sections.espStyle:CreateColorpicker("Chams Color", function(color)
ESP.ChamsColor = color
end)
local cleanKeyName = tostring(config.Keybind):gsub("Enum.KeyCode.", "")
sections.settings:CreateLabel("Close Menu Key (PC): " .. cleanKeyName)
sections.settings:CreateDropdown(
"Change Font",
stored_fonts,
function(value)
window:SetFont(value)
end,
"",
false
)
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
