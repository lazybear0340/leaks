--this shit was unobfuscated


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
if getgenv().KaliProjectSmash then
pcall(function() getgenv().KaliProjectSmash.unload() end)
end
local Hub = { connections = {}, drawings = {}, unloaded = false }
getgenv().KaliProjectSmash = Hub
local function track(connection)
table.insert(Hub.connections, connection)
return connection
end
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GameRemotes = Remotes:WaitForChild("game")
local Action = GameRemotes:WaitForChild("action")
local Net = {
block = Action:WaitForChild("block"),
mouse1 = Action:WaitForChild("mouse1"),
ability = Action:WaitForChild("ability"),
aerial = Action:WaitForChild("aerial"),
groundPound = Action:WaitForChild("groundPound"),
allClients = Remotes:WaitForChild("allClients"),
deploy = GameRemotes:WaitForChild("deploy"),
equip = Remotes:WaitForChild("inventory"):WaitForChild("equip"),
}
local Flags = {
AutoBlock = false,
BlockRange = 18,
BlockHold = 0.45,
BlockCooldown = 1.2,
CounterAfterBlock = false,
AntiKnockback = false,
AntiStun = false,
Abilities = { false, false, false, false, false },
AbilityAim = false,
RayAim = false,
AimRange = 60,
AbilityDelay = 0.3,
NoDashCooldown = false,
InfiniteAirJump = false,
AutoDash = false,
DashInterval = 0.5,
DashThroughStun = false,
SpeedEnabled = false,
SpeedValue = 32,
AntiRingOut = false,
RingOutRadius = 380,
AutoFarm = false,
FarmRadius = 400,
FarmDistance = 8,
AutoMelee = false,
AutoDeploy = false,
EspBox = false,
EspTracer = false,
EspName = false,
EspDistance = false,
EspPercent = false,
EspChams = false,
EspRange = 1000,
}
local State = {}
local function statusFolder()
local folders = ReplicatedStorage:FindFirstChild("statusFolders")
return folders and folders:FindFirstChild(LocalPlayer.Name .. "StatusFolder")
end
local function hasStatus(name)
local folder = State.status
return folder ~= nil and folder:FindFirstChild(name) ~= nil
end
local function isAlive(character)
if not character or character.Parent ~= Workspace:FindFirstChild("Living") then
return false
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
return humanoid ~= nil and humanoid.Health > 0
end
local function nearestEnemy(range)
local root = State.root
if not root then
return nil
end
local best, bestDistance = nil, range
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
local character = player.Character
if isAlive(character) then
local targetRoot = character:FindFirstChild("HumanoidRootPart")
if targetRoot then
local distance = (root.Position - targetRoot.Position).Magnitude
if distance < bestDistance then
best, bestDistance = character, distance
end
end
end
end
end
return best, bestDistance
end
local AttackSignals = { swingAudio = true, aerialSignal = true }
do
local modules = ReplicatedStorage:FindFirstChild("clientModules")
local vfx = modules and modules:FindFirstChild("clientVFX")
local generic = {
util = true,
movement = true,
GUI = true,
hitEffects = true,
kbConsistent = true,
SignalVfx = true,
}
if vfx then
for _, folder in ipairs(vfx:GetChildren()) do
if folder:IsA("Folder") and not generic[folder.Name] then
for _, effect in ipairs(folder:GetChildren()) do
AttackSignals[effect.Name] = true
end
end
end
end
end
local speedValue = nil
local function applySpeed()
if speedValue then
pcall(function() speedValue:Destroy() end)
speedValue = nil
end
if not Flags.SpeedEnabled then
return
end
local folder = State.status
if not folder then
return
end
local value = Instance.new("NumberValue")
value.Name = "changeSpeed"
value.Value = Flags.SpeedValue
value:SetAttribute("canJump", true)
value:SetAttribute("psplus", true)
value.Parent = folder
speedValue = value
end
local function resolveMovementHooks(handler)
State.dashFunction = nil
State.airJumpFunction = nil
State.movementHandler = handler
State.movementEnv = nil
if not handler or not getconnections or not debug or not debug.getupvalue then
return
end
if getsenv then
local ok, environment = pcall(getsenv, handler)
if ok and type(environment) == "table" then
State.movementEnv = environment
end
end
local dashEvent = handler:FindFirstChild("dash")
if dashEvent then
local ok, connections = pcall(getconnections, dashEvent.Event)
if ok and connections[1] then
local handlerFunction = connections[1].Function
local gotRemote, remote = pcall(debug.getupvalue, handlerFunction, 8)
if gotRemote and typeof(remote) == "Instance" and remote.Name == "dash" then
State.dashFunction = handlerFunction
end
end
end
local jumpEvent = handler:FindFirstChild("jump")
if jumpEvent then
local ok, connections = pcall(getconnections, jumpEvent.Event)
if ok and connections[1] then
local gotFunction, airFunction = pcall(debug.getupvalue, connections[1].Function, 10)
if gotFunction and type(airFunction) == "function" then
local gotRemote, remote = pcall(debug.getupvalue, airFunction, 13)
if gotRemote and typeof(remote) == "Instance" and remote.Name == "airJump" then
State.airJumpFunction = airFunction
end
end
end
end
end
local lastHookResolve = 0
local function ensureMovementHooks()
if State.dashFunction and State.airJumpFunction then
return
end
local now = os.clock()
if now - lastHookResolve < 0.5 then
return
end
lastHookResolve = now
local character = State.character
local movement = character and character:FindFirstChild("Movement")
resolveMovementHooks(movement and movement:FindFirstChild("movementHandler"))
end
local function bindCharacter(character)
State.character = character
State.humanoid = character:WaitForChild("Humanoid", 10)
State.root = character:WaitForChild("HumanoidRootPart", 10)
State.status = statusFolder()
State.dashFunction = nil
State.airJumpFunction = nil
State.movementHandler = nil
State.movementEnv = nil
lastHookResolve = 0
if Flags.SpeedEnabled then
applySpeed()
end
end
if LocalPlayer.Character then
bindCharacter(LocalPlayer.Character)
end
track(LocalPlayer.CharacterAdded:Connect(bindCharacter))
track(LocalPlayer.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))
local function meleeOnce()
local character, humanoid, root = State.character, State.humanoid, State.root
if not (character and humanoid and root) then
return
end
if hasStatus("stun") or hasStatus("noAttack") or hasStatus("primaryRecovery") then
return
end
local serverTime = Workspace:GetServerTimeNow()
if humanoid.FloorMaterial ~= Enum.Material.Air or character:GetAttribute("isClung") then
Net.mouse1:FireServer(true, serverTime)
task.delay(0.06, function()
if not Hub.unloaded then
Net.mouse1:FireServer(false, Workspace:GetServerTimeNow())
end
end)
return
end
local pitch = Camera.CFrame.LookVector.Unit:Dot(Vector3.yAxis)
if pitch >= -0.5 then
Net.aerial:FireServer(serverTime)
else
Net.groundPound:FireServer(serverTime)
end
end
local blockUntil, lastBlockStart, blocking = 0, 0, false
local function blockStep()
local now = os.clock()
if now < blockUntil then
blocking = true
if not (hasStatus("stun") or hasStatus("blockRecovery") or hasStatus("primaryRecovery")
or hasStatus("noAttack") or hasStatus("isBlocking")) then
Net.block:FireServer(true)
end
elseif blocking then
blocking = false
Net.block:FireServer(false)
if Flags.CounterAfterBlock then
task.delay(0.05, function()
if not Hub.unloaded then
meleeOnce()
end
end)
end
end
end
track(Net.allClients.OnClientEvent:Connect(function(model, effect)
if not Flags.AutoBlock then
return
end
if typeof(model) ~= "Instance" or type(effect) ~= "string" then
return
end
if not AttackSignals[effect] or model == State.character then
return
end
local root = State.root
local attackerRoot = model:FindFirstChild("HumanoidRootPart")
if not root or not attackerRoot then
return
end
local offset = root.Position - attackerRoot.Position
local distance = offset.Magnitude
if distance > Flags.BlockRange then
return
end
if distance > 0.1 and attackerRoot.CFrame.LookVector:Dot(offset.Unit) < 0.2 then
return
end
local now = os.clock()
if now - lastBlockStart < Flags.BlockCooldown then
return
end
lastBlockStart = now
blockUntil = now + Flags.BlockHold
end))
local gamepadModule, originalMouseRay = nil, nil
local function setRayAim(state)
if not gamepadModule then
local ok, module = pcall(require, ReplicatedStorage.Framework.Client.gamepad)
if not ok or type(module) ~= "table" then
return
end
gamepadModule = module
originalMouseRay = rawget(module, "getMouseRay")
end
if type(originalMouseRay) ~= "function" then
return
end
if not state then
rawset(gamepadModule, "getMouseRay", originalMouseRay)
return
end
rawset(gamepadModule, "getMouseRay", function(...)
local root = State.root
if root then
local target = nearestEnemy(Flags.AimRange)
local targetRoot = target and target:FindFirstChild("HumanoidRootPart")
if targetRoot then
local origin = Camera.CFrame.Position
local delta = targetRoot.Position - origin
if delta.Magnitude > 0.1 then
return Ray.new(origin, delta.Unit)
end
end
end
return originalMouseRay(...)
end)
end
local AbilitySlots = { "One", "Two", "Three", "Four", "Five" }
local lastAbility = { 0, 0, 0, 0, 0 }
local function abilityPayload()
local root, humanoid = State.root, State.humanoid
local cameraCFrame = Camera.CFrame
local aimPosition = cameraCFrame.Position + cameraCFrame.LookVector * 100
local aimVector = cameraCFrame.LookVector
if Flags.AbilityAim then
local target = nearestEnemy(Flags.AimRange)
local targetRoot = target and target:FindFirstChild("HumanoidRootPart")
if targetRoot then
aimPosition = targetRoot.Position
local delta = aimPosition - root.Position
if delta.Magnitude > 0.1 then
aimVector = delta.Unit
end
end
end
return {
mouseHit = aimPosition,
floorMaterial = humanoid.FloorMaterial,
lookVector = root.CFrame.LookVector,
clientRootPos = root.Position,
clientRootCFrame = root.CFrame,
cameraLookVector = aimVector,
inShiftLock = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter,
}
end
local function abilityStep()
local now = os.clock()
if hasStatus("stun") or hasStatus("noAttack") or hasStatus("knockout") then
return
end
for index = 1, 5 do
if Flags.Abilities[index]
and now - lastAbility[index] >= Flags.AbilityDelay
and not hasStatus(index .. "CD") then
lastAbility[index] = now
local slot = AbilitySlots[index]
local payload = abilityPayload()
Net.ability:FireServer(slot, true, payload, Workspace:GetServerTimeNow())
task.delay(0.05, function()
if not Hub.unloaded then
Net.ability:FireServer(slot, false, payload, Workspace:GetServerTimeNow())
end
end)
end
end
end
local StunStatuses = {
stun = true,
knockout = true,
noAttack = true,
noAj = true,
primaryRecovery = true,
blockRecovery = true,
moveRecovery = true,
noSprint = true,
cantCling = true,
noAutoRotate = true,
}
local function protectionStep()
if Flags.AntiKnockback then
local root = State.root
if root then
local knockbackVelocity = root:FindFirstChild("koVel")
if knockbackVelocity then
knockbackVelocity:Destroy()
end
end
end
if Flags.AntiStun then
local folder = State.status
if folder then
for _, child in ipairs(folder:GetChildren()) do
if StunStatuses[child.Name] then
child:Destroy()
elseif child.Name == "changeSpeed" and child ~= speedValue
and child.Value <= 8 and not child:GetAttribute("isRunning") then
child:Destroy()
end
end
end
end
end
local lastDash = 0
local function movementStep()
if not (Flags.NoDashCooldown or Flags.InfiniteAirJump or Flags.AutoDash or Flags.DashThroughStun) then
return
end
ensureMovementHooks()
if State.movementEnv then
if Flags.DashThroughStun then
State.movementEnv.evaded = true
elseif State.movementEnv.evaded then
State.movementEnv.evaded = nil
end
end
if Flags.AutoDash and State.movementHandler then
local now = os.clock()
if now - lastDash >= Flags.DashInterval then
lastDash = now
local dashEvent = State.movementHandler:FindFirstChild("dash")
if dashEvent then
dashEvent:Fire()
end
end
end
if Flags.NoDashCooldown and State.dashFunction then
pcall(debug.setupvalue, State.dashFunction, 2, true)
end
if Flags.InfiniteAirJump and State.airJumpFunction then
pcall(debug.setupvalue, State.airJumpFunction, 4, 3)
pcall(debug.setupvalue, State.airJumpFunction, 2, true)
local folder = State.status
local blocker = folder and folder:FindFirstChild("noAj")
if blocker then
blocker:Destroy()
end
end
end
local currentMap, mapCenter = nil, nil
local function ringOutStep()
local mapFolder = Workspace:FindFirstChild("Map")
local map = mapFolder and mapFolder:FindFirstChild("CurrentMap")
if not map then
currentMap, mapCenter = nil, nil
return
end
if map ~= currentMap then
currentMap = map
mapCenter = map:GetBoundingBox().Position
end
local root = State.root
if not root or not mapCenter then
return
end
local offset = root.Position - mapCenter
if offset.Magnitude > Flags.RingOutRadius then
root.AssemblyLinearVelocity = Vector3.zero
local safePosition = mapCenter + offset.Unit * (Flags.RingOutRadius - 10)
root.CFrame = CFrame.new(safePosition) * (root.CFrame - root.CFrame.Position)
end
end
local lastTeleport, lastMelee, lastDeploy = 0, 0, 0
local function farmStep()
local now = os.clock()
if Flags.AutoDeploy and Workspace:FindFirstChild("Lobby") and now - lastDeploy > 3 then
lastDeploy = now
task.spawn(function()
pcall(function() Net.deploy:InvokeServer() end)
end)
end
local root = State.root
if not root or not isAlive(State.character) then
return
end
if Flags.AutoFarm and now - lastTeleport >= 0.05 then
local target = nearestEnemy(Flags.FarmRadius)
local targetRoot = target and target:FindFirstChild("HumanoidRootPart")
if targetRoot then
lastTeleport = now
local goal = targetRoot.Position - targetRoot.CFrame.LookVector * Flags.FarmDistance
root.CFrame = CFrame.lookAt(goal, targetRoot.Position)
root.AssemblyLinearVelocity = Vector3.zero
end
end
if Flags.AutoMelee and now - lastMelee >= 0.25 and nearestEnemy(14) then
lastMelee = now
meleeOnce()
end
end
local espCache = {}
local function newText(size)
local text = Drawing.new("Text")
text.Visible = false
text.Size = size
text.Center = true
text.Outline = true
text.OutlineColor = Color3.new(0, 0, 0)
text.Font = Drawing.Fonts.UI
return text
end
local function getEsp(player)
local objects = espCache[player]
if objects then
return objects
end
objects = {}
objects.box = Drawing.new("Square")
objects.box.Visible = false
objects.box.Thickness = 1
objects.box.Filled = false
objects.box.Transparency = 1
objects.tracer = Drawing.new("Line")
objects.tracer.Visible = false
objects.tracer.Thickness = 1
objects.tracer.Transparency = 1
objects.name = newText(14)
objects.info = newText(13)
objects.name.Text = player.Name
espCache[player] = objects
table.insert(Hub.drawings, objects)
return objects
end
local chamsCache = {}
local chamsTemplate = ReplicatedStorage:FindFirstChild("assets")
chamsTemplate = chamsTemplate and chamsTemplate:FindFirstChild("Highlight")
local function clearChams(player)
local highlight = chamsCache[player]
if highlight then
pcall(function() highlight:Destroy() end)
chamsCache[player] = nil
end
end
local function applyChams(player, character, color)
if not chamsTemplate then
return
end
local highlight = chamsCache[player]
if not highlight or highlight.Parent ~= character then
clearChams(player)
highlight = chamsTemplate:Clone()
highlight.Name = "KaliCham"
highlight.OutlineTransparency = 0
highlight.FillTransparency = 0.55
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Parent = character
chamsCache[player] = highlight
end
highlight.FillColor = color
highlight.OutlineColor = color
end
local function releaseEsp(player)
clearChams(player)
local objects = espCache[player]
if not objects then
return
end
for _, object in pairs(objects) do
pcall(function() object:Remove() end)
end
espCache[player] = nil
end
local function hideEsp(objects)
objects.box.Visible = false
objects.tracer.Visible = false
objects.name.Visible = false
objects.info.Visible = false
end
local function hideAllEsp()
for _, objects in pairs(espCache) do
hideEsp(objects)
end
for player in pairs(chamsCache) do
clearChams(player)
end
end
local function damagePercent(player)
local folders = ReplicatedStorage:FindFirstChild("statusFolders")
local folder = folders and folders:FindFirstChild(player.Name .. "StatusFolder")
local value = folder and folder:FindFirstChild("dmgPercent")
return value and math.floor(value.Value) or 0
end
local function percentColor(percent)
local hue = math.clamp(1 - percent / 150, 0, 1) * 0.33
return Color3.fromHSV(hue, 1, 1)
end
local function espStep()
if Hub.unloaded then
return
end
local active = Flags.EspBox or Flags.EspTracer or Flags.EspName
or Flags.EspDistance or Flags.EspPercent or Flags.EspChams
local root = State.root
if not active or not root then
hideAllEsp()
return
end
local viewport = Camera.ViewportSize
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
local objects = getEsp(player)
local character = player.Character
local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
local head = character and character:FindFirstChild("Head")
local distance = targetRoot and (root.Position - targetRoot.Position).Magnitude or math.huge
if targetRoot and head and isAlive(character) and distance <= Flags.EspRange then
local percent = damagePercent(player)
local color = percentColor(percent)
if Flags.EspChams then
applyChams(player, character, color)
else
clearChams(player)
end
local headPoint, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.8, 0))
local footPoint = Camera:WorldToViewportPoint(targetRoot.Position - Vector3.new(0, 3.2, 0))
if onScreen then
local height = math.abs(footPoint.Y - headPoint.Y)
local width = height * 0.62
objects.box.Visible = Flags.EspBox
if Flags.EspBox then
objects.box.Color = color
objects.box.Size = Vector2.new(width, height)
objects.box.Position = Vector2.new(headPoint.X - width / 2, headPoint.Y)
end
objects.tracer.Visible = Flags.EspTracer
if Flags.EspTracer then
objects.tracer.Color = color
objects.tracer.From = Vector2.new(viewport.X / 2, viewport.Y)
objects.tracer.To = Vector2.new(footPoint.X, footPoint.Y)
end
objects.name.Visible = Flags.EspName
if Flags.EspName then
objects.name.Color = color
objects.name.Position = Vector2.new(headPoint.X, headPoint.Y - 16)
end
local info = {}
if Flags.EspPercent then
table.insert(info, percent .. "%")
end
if Flags.EspDistance then
table.insert(info, math.floor(distance) .. "m")
end
objects.info.Visible = #info > 0
if #info > 0 then
objects.info.Color = color
objects.info.Text = table.concat(info, "  ")
objects.info.Position = Vector2.new(headPoint.X, footPoint.Y + 2)
end
else
hideEsp(objects)
end
else
clearChams(player)
hideEsp(objects)
end
end
end
end
track(Players.PlayerRemoving:Connect(releaseEsp))
track(RunService.Heartbeat:Connect(function()
if Hub.unloaded then
return
end
local root = State.root
if not root or not root.Parent then
return
end
blockStep()
abilityStep()
protectionStep()
movementStep()
farmStep()
if Flags.AntiRingOut then
ringOutStep()
end
end))
track(RunService.RenderStepped:Connect(espStep))
local function ownedCharacters()
local ok, inventory = pcall(require, ReplicatedStorage.Framework.Client.inventory)
if not ok or not inventory.getInventory then
return { "-" }
end
local data = inventory.getInventory()
local owned = data and data.ownedCharacters
if not owned or #owned == 0 then
return { "-" }
end
local list = table.clone(owned)
table.sort(list)
return list
end
local stored_fonts = {}
for _, font in Enum.Font:GetEnumItems() do
table.insert(stored_fonts, font.Name)
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
local config = gui_config
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local existingGuis = {}
for _, gui in ipairs(playerGui:GetChildren()) do
existingGuis[gui] = true
end
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(config, playerGui)
library:SetWindowName("Kali Hub | Project Smash")
for _, gui in ipairs(playerGui:GetChildren()) do
if not existingGuis[gui] and gui:IsA("ScreenGui") then
gui.ResetOnSpawn = false
Hub.gui = gui
end
end
local tabs = {
main = window:CreateTab("Main"),
settings = window:CreateTab("Settings"),
}
local sections = {
blocking = tabs.main:CreateSection("Blocking"),
abilities = tabs.main:CreateSection("Abilities"),
protection = tabs.main:CreateSection("Protection"),
movement = tabs.main:CreateSection("Movement"),
survival = tabs.main:CreateSection("Survival"),
farm = tabs.main:CreateSection("Auto Farm"),
esp = tabs.main:CreateSection("Player ESP"),
character = tabs.main:CreateSection("Character"),
settings = tabs.settings:CreateSection("Settings"),
}
sections.blocking:CreateToggle("Auto Block", false, function(state)
Flags.AutoBlock = state
end)
sections.blocking:CreateSlider("Block Range", 5, 40, 18, true, function(value)
Flags.BlockRange = value
end)
sections.blocking:CreateSlider("Block Hold", 0.1, 2, 0.45, false, function(value)
Flags.BlockHold = value
end)
sections.blocking:CreateSlider("Block Cooldown", 0.2, 4, 1.2, false, function(value)
Flags.BlockCooldown = value
end)
sections.blocking:CreateToggle("Counter After Block", false, function(state)
Flags.CounterAfterBlock = state
end)
for index = 1, 5 do
sections.abilities:CreateToggle("Auto Ability " .. index, false, function(state)
Flags.Abilities[index] = state
end)
end
sections.abilities:CreateToggle("Ability Aim", false, function(state)
Flags.AbilityAim = state
end)
sections.abilities:CreateToggle("Ray Aim", false, function(state)
Flags.RayAim = state
setRayAim(state)
end, "dangerous")
sections.abilities:CreateSlider("Aim Range", 20, 200, 60, true, function(value)
Flags.AimRange = value
end)
sections.abilities:CreateSlider("Ability Rate Limit", 0.1, 3, 0.3, false, function(value)
Flags.AbilityDelay = value
end)
sections.protection:CreateToggle("Anti Knockback", false, function(state)
Flags.AntiKnockback = state
end)
sections.protection:CreateToggle("Anti Stun", false, function(state)
Flags.AntiStun = state
end)
local characterDropdown = sections.character:CreateDropdown("Owned Character", ownedCharacters(), function(value)
Flags.SelectedCharacter = value
end)
sections.character:CreateButton("Equip Character", function()
local selected = Flags.SelectedCharacter
if selected and selected ~= "-" then
Net.equip:FireServer(selected)
end
end)
sections.character:CreateButton("Refresh List", function()
characterDropdown:ChangeOptions(ownedCharacters(), Flags.SelectedCharacter)
end)
sections.movement:CreateToggle("No Dash Cooldown", false, function(state)
Flags.NoDashCooldown = state
end)
sections.movement:CreateToggle("Infinite Air Jump", false, function(state)
Flags.InfiniteAirJump = state
end)
sections.movement:CreateToggle("Dash Through Stun", false, function(state)
Flags.DashThroughStun = state
end)
sections.movement:CreateToggle("Auto Dash", false, function(state)
Flags.AutoDash = state
end)
sections.movement:CreateSlider("Auto Dash Interval", 0.2, 3, 0.5, false, function(value)
Flags.DashInterval = value
end)
sections.movement:CreateToggle("Speed Boost", false, function(state)
Flags.SpeedEnabled = state
applySpeed()
end)
sections.movement:CreateSlider("Speed Amount", 16, 120, 32, true, function(value)
Flags.SpeedValue = value
if speedValue then
speedValue.Value = value
end
end)
sections.survival:CreateToggle("Anti Ring Out", false, function(state)
Flags.AntiRingOut = state
end)
sections.survival:CreateSlider("Ring Out Radius", 150, 520, 380, true, function(value)
Flags.RingOutRadius = value
end)
sections.farm:CreateToggle("Auto Farm Nearest Player", false, function(state)
Flags.AutoFarm = state
end, "dangerous")
sections.farm:CreateSlider("Search Radius", 100, 1000, 400, true, function(value)
Flags.FarmRadius = value
end)
sections.farm:CreateSlider("Distance From Target", 3, 25, 8, true, function(value)
Flags.FarmDistance = value
end)
sections.farm:CreateToggle("Auto Melee", false, function(state)
Flags.AutoMelee = state
end)
sections.farm:CreateToggle("Auto Deploy", false, function(state)
Flags.AutoDeploy = state
end)
sections.esp:CreateToggle("Box", false, function(state)
Flags.EspBox = state
end)
sections.esp:CreateToggle("Tracers", false, function(state)
Flags.EspTracer = state
end)
sections.esp:CreateToggle("Names", false, function(state)
Flags.EspName = state
end)
sections.esp:CreateToggle("Distance", false, function(state)
Flags.EspDistance = state
end)
sections.esp:CreateToggle("Damage Percent", false, function(state)
Flags.EspPercent = state
end)
sections.esp:CreateToggle("Chams", false, function(state)
Flags.EspChams = state
end)
sections.esp:CreateSlider("ESP Range", 100, 2000, 1000, true, function(value)
Flags.EspRange = value
end)
local cleanKeyName = tostring(config.Keybind):gsub("Enum.KeyCode.", "")
sections.settings:CreateLabel("Close Menu Key (PC): " .. cleanKeyName)
sections.settings:CreateDropdown("Change Font", stored_fonts, function(value)
window:SetFont(value)
end, "", false)
function Hub.unload()
Hub.unloaded = true
for _, connection in ipairs(Hub.connections) do
pcall(function() connection:Disconnect() end)
end
Hub.connections = {}
setRayAim(false)
for player in pairs(chamsCache) do
clearChams(player)
end
if State.movementEnv and State.movementEnv.evaded then
State.movementEnv.evaded = nil
end
for _, objects in ipairs(Hub.drawings) do
for _, object in pairs(objects) do
pcall(function() object:Remove() end)
end
end
Hub.drawings = {}
espCache = {}
if speedValue then
pcall(function() speedValue:Destroy() end)
speedValue = nil
end
if Hub.gui then
pcall(function() Hub.gui:Destroy() end)
end
getgenv().KaliProjectSmash = nil
end
sections.settings:CreateButton("Unload Script", function()
Hub.unload()
end)
window:Notify("Kali Hub", "https://kalihub.xyz", 15)
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
