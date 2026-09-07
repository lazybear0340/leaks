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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
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
if getgenv().__KaliIlegalSoccerBootJob == game.JobId then
	return
end
getgenv().__KaliIlegalSoccerBootJob = game.JobId
local src
if isfile and isfile("Ilegal soccer.lua") then
	src = readfile("Ilegal soccer.lua")
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
ShotAimbot = false,
ShotPlacement = "Top Corner",
TargetPost = "Away From Keeper",
UnsavableShot = false,
PerfectCharge = false,
AutoPass = false,
AutoVolley = false,
AutoCallForPass = false,
TackleAimbot = false,
AutoDribble = false,
AutoGoalkeeper = false,
KeeperTolerance = 1,
KeeperClearAimbot = false,
ItemAimbot = false,
ItemAimFov = 90,
AutoUseItem = false,
InfiniteStamina = false,
NoBallSlowdown = false,
FullSpeedCharge = false,
AutoSprint = false,
FlightPath = false,
FlightPathSeconds = 2,
LandingMarker = false,
ShotPreview = false,
BallEsp = false,
PlayerEsp = false,
PlayerTracers = false,
PlayerChams = false,
ItemBoxEsp = false,
WorldItemEsp = false,
ProjectileEsp = false,
EspMaxDistance = 400,
}
local Shared = getgenv().__KaliIlegalSoccer
if type(Shared) ~= "table" then
Shared = { Hooked = false, Rewrite = nil }
getgenv().__KaliIlegalSoccer = Shared
end
Shared.Rewrite = nil
local moduleCache = {}
local function mod(path)
local cached = moduleCache[path]
if cached ~= nil then
return cached or nil
end
local node = ReplicatedStorage
for part in path:gmatch("[^%.]+") do
node = node and node:FindFirstChild(part)
end
local ok, result = pcall(require, node)
moduleCache[path] = (ok and type(result) == "table") and result or false
return moduleCache[path] or nil
end
local function character()
local model = LocalPlayer.Character
return (model and model.Parent) and model or nil
end
local function rootPart()
local model = character()
return model and model:FindFirstChild("HumanoidRootPart") or nil
end
local function teamName()
local model = character()
if not model then return nil end
local teams = mod("Client.Gameplay.ActorTeams")
if not teams then return nil end
local ok, name = pcall(teams.GetCharacterTeamName, model)
return ok and name or nil
end
local function characterModels()
local folder = Workspace:FindFirstChild("Characters")
local players = folder and folder:FindFirstChild("Players")
local npcs = folder and folder:FindFirstChild("NPCs")
local models = {}
if players then
for _, model in players:GetChildren() do
if model:IsA("Model") then table.insert(models, model) end
end
end
if npcs then
for _, model in npcs:GetChildren() do
if model:IsA("Model") then table.insert(models, model) end
end
end
return models
end
local function modelPosition(model)
local motion = mod("Modules.Characters.CharacterMotion")
if motion then
local ok, position = pcall(motion.GetPosition, model)
if ok and typeof(position) == "Vector3" then return position end
end
local root = model:FindFirstChild("HumanoidRootPart")
return root and root.Position or nil
end
local function isAlive(model)
local humanoid = model:FindFirstChildOfClass("Humanoid")
return humanoid ~= nil and humanoid.Health > 0
end
local goalCache = { boundaries = nil, world = nil }
local function boundaryWorld()
local renderer = mod("Client.Gameplay.Ball.Renderer")
if renderer then
local ok, _, live = pcall(renderer.GetAuthoritativeMovementState)
if ok and type(live) == "table" then return live end
end
local physics = mod("Modules.Ball.Physics")
local map = Workspace:FindFirstChild("Map")
local boundaries = map and map:FindFirstChild("Boundaries")
if not physics or not boundaries then return nil end
if goalCache.boundaries ~= boundaries then
local ok, world = pcall(physics.BuildBoundaryWorld, boundaries)
goalCache.boundaries = boundaries
goalCache.world = ok and world or nil
end
return goalCache.world
end
local function goalPart(attacking)
local map = Workspace:FindFirstChild("Map")
local data = map and map:FindFirstChild("Data")
if not data then return nil end
local mine = teamName()
local wanted
if mine == "Team1" then
wanted = attacking and "Team2" or "Team1"
elseif mine == "Team2" then
wanted = attacking and "Team1" or "Team2"
else
local root = rootPart()
if not root then return nil end
local best, bestDot
for _, name in { "Team1", "Team2" } do
local side = data:FindFirstChild(name)
local goal = side and side:FindFirstChild("Goal")
if goal then
local delta = goal.Position - root.Position
if delta.Magnitude > 1e-3 then
local dot = delta.Unit:Dot(Camera.CFrame.LookVector)
if not bestDot or (attacking and dot > bestDot) or (not attacking and dot < bestDot) then
best, bestDot = goal, dot
end
end
end
end
return best
end
local side = data:FindFirstChild(wanted)
return side and side:FindFirstChild("Goal") or nil
end
local function keeperOffset(mouth, goal)
local closest, closestDistance = nil, math.huge
local mine = teamName()
local teams = mod("Client.Gameplay.ActorTeams")
for _, model in characterModels() do
if model ~= character() and isAlive(model) then
local theirTeam = teams and select(2, pcall(teams.GetCharacterTeamName, model)) or nil
if not mine or not theirTeam or theirTeam ~= mine then
local position = modelPosition(model)
if position then
local distance = (position - goal.Position).Magnitude
if distance < closestDistance then
closest, closestDistance = position, distance
end
end
end
end
end
if not closest or closestDistance > 40 then return nil end
return (closest - mouth.Center):Dot(mouth.Lateral)
end
local function keeperLateralSign(mouth, goal)
local offset = keeperOffset(mouth, goal)
if not offset then return 1 end
return offset >= 0 and -1 or 1
end
local blockerParams = RaycastParams.new()
blockerParams.FilterType = Enum.RaycastFilterType.Include
blockerParams.RespectCanCollide = true
local blockers = {}
local function refreshBlockers()
table.clear(blockers)
local world = mod("Modules.Items.ItemWorld")
if world then
local okContainer, container = pcall(world.GetContainer)
if okContainer and typeof(container) == "Instance" then
for _, instance in container:GetChildren() do
if instance:GetAttribute("PlacedItemId") then
table.insert(blockers, instance)
end
end
end
end
blockerParams.FilterDescendantsInstances = blockers
end
local function laneBlocked(origin, target)
if #blockers == 0 then return false end
local delta = target - origin
if delta.Magnitude < 1e-3 then return false end
return Workspace:Raycast(origin, delta, blockerParams) ~= nil
end
local AUTO_LATERAL = { -1, -0.6, 0, 0.6, 1 }
local AUTO_HEIGHT = { 1, 0.65, 0.3, 0 }
local function autoShotTarget(origin, goal, mouth, clearance, halfWidth)
local dive = mod("Modules.Actions.GoalkeeperDive")
local saveHeight = mouth.BottomY + (dive and dive.Constants.MaximumSaveHeight or 7.75)
local bottom = mouth.BottomY + clearance
local top = mouth.TopY - clearance
local keeperLateral = keeperOffset(mouth, goal)
refreshBlockers()
local best, bestScore
for _, lateralAlpha in AUTO_LATERAL do
local lateral = halfWidth * lateralAlpha
for _, heightAlpha in AUTO_HEIGHT do
local height = bottom + (top - bottom) * heightAlpha
local point = mouth.Center + mouth.Lateral * lateral + Vector3.yAxis * (height - mouth.Center.Y)
if not laneBlocked(origin, point) then
local score = keeperLateral and math.abs(lateral - keeperLateral) or math.abs(lateral)
if height > saveHeight then score += 15 end
score += height - bottom
if not bestScore or score > bestScore then best, bestScore = point, score end
end
end
end
return best
end
local function shotTarget(origin, profile, side)
local assist = mod("Modules.Actions.ShotAimAssist")
local physics = mod("Modules.Ball.Physics")
local goal = goalPart(true)
if not assist or not physics or not goal then return nil end
local ok, mouth = pcall(assist.GetGoalMouth, goal, origin)
if not ok or type(mouth) ~= "table" then return nil end
local clearance = physics.BallRadius + assist.Constants.MouthClearanceStuds
local halfWidth = math.max(mouth.HalfWidth - clearance, 0)
if profile == "Auto" then
local auto = autoShotTarget(origin, goal, mouth, clearance, halfWidth)
if auto then return auto end
profile = "Top Corner"
end
local sign
if side == "Left" then
sign = 1
elseif side == "Right" then
sign = -1
else
sign = keeperLateralSign(mouth, goal)
end
local lateral, height
if profile == "Center" then
lateral, height = 0, mouth.Center.Y
elseif profile == "Bottom Corner" then
lateral, height = halfWidth * sign, mouth.BottomY + clearance
elseif profile == "Half Height" then
lateral, height = halfWidth * sign, mouth.Center.Y
else
lateral, height = halfWidth * sign, mouth.TopY - clearance
end
return mouth.Center + mouth.Lateral * lateral + Vector3.yAxis * (height - mouth.Center.Y)
end
local function ballState()
local renderer = mod("Client.Gameplay.Ball.Renderer")
if not renderer then return nil end
local root = rootPart()
if root then
local okId, id = pcall(renderer.GetNearestBallId, root.Position)
if okId and id then
local okState, state = pcall(renderer.GetMovementStateById, id)
if okState and type(state) == "table" and typeof(state.Position) == "Vector3" then
return state
end
end
end
local ok, state = pcall(renderer.GetMovementState)
if ok and type(state) == "table" and typeof(state.Position) == "Vector3" then
return state
end
return nil
end
local function goalkeeperState()
local renderer = mod("Client.Gameplay.Ball.Renderer")
if renderer then
local ok, state, world = pcall(renderer.GetAuthoritativeMovementState)
if ok and type(state) == "table" and typeof(state.Position) == "Vector3"
and typeof(state.Velocity) == "Vector3" and type(world) == "table" then
return state, world
end
end
return nil, nil
end
local function ballPath(horizon)
local physics = mod("Modules.Ball.Physics")
local sampling = mod("Modules.Ball.FlightSampling")
local state = ballState()
local world = boundaryWorld()
if not physics or not sampling or not state or not world then return nil, nil end
local now = Workspace:GetServerTimeNow()
local okState, live = pcall(physics.NewState, state.Position, state.Velocity, state.Radius or physics.BallRadius, now, state.Spin)
if not okState then return nil, nil end
local okPath, points = pcall(sampling.Sample, live, world, now, horizon, 0.05)
if not okPath or type(points) ~= "table" then return nil, state end
return points, state
end
local function sendAction(name, modulePath)
local controls = mod("Modules.Gameplay.Controls")
local handler = mod(modulePath)
if not controls or not handler or type(handler.HandleInputBegan) ~= "function" then return false end
local okAvailable, available = pcall(controls.IsAvailable, name)
if not okAvailable or not available then return false end
local okCooldown, remaining = pcall(controls.GetCooldownRemaining, name)
if okCooldown and type(remaining) == "number" and remaining > 0 then return false end
local okInput, input = pcall(controls.CreateInput, name)
if not okInput or type(input) ~= "table" then return false end
local okSent, sent = pcall(handler.HandleInputBegan, input, false)
return okSent and sent ~= false
end
local function ballCarrier()
local renderer = mod("Client.Gameplay.Ball.Renderer")
if not renderer then return nil end
local ok, userId = pcall(renderer.GetVisualOwnerUserId)
if not ok or type(userId) ~= "number" then return nil end
local actors = mod("Modules.Characters.Actors")
if not actors then return nil end
local okModel, model = pcall(actors.GetByUserId, userId)
return okModel and model or nil
end
local function holdsBall()
local renderer = mod("Client.Gameplay.Ball.Renderer")
local model = character()
if not renderer or not model then return false end
local ok, owned = pcall(renderer.IsBoundBallOwnedBy, model)
if ok and owned ~= nil then return owned and true or false end
local okBy, by = pcall(renderer.GetBallOwnedBy, model)
return okBy and by ~= nil
end
local function aimedDirection(origin, target)
local delta = target - origin
if delta.Magnitude < 1e-3 then return nil end
return delta.Unit
end
local function applyAim(command, direction)
local aim = command.AimDirection
if type(aim) == "table" then
local copy = table.clone(aim)
copy.Direction = direction
command.AimDirection = copy
elseif typeof(aim) == "Vector3" then
command.AimDirection = direction
else
return false
end
if typeof(command.KickDirection) == "Vector3" then
command.KickDirection = direction
end
return true
end
local function aimOrigin(command)
local aim = command.AimDirection
if type(aim) == "table" and typeof(aim.Origin) == "Vector3" then
return aim.Origin
end
local root = rootPart()
return root and root.Position or nil
end
local function passTarget(origin, direction)
local mine = teamName()
local teams = mod("Client.Gameplay.ActorTeams")
local assisted = mod("Modules.Actions.AssistedPass")
local maximum = assisted and assisted.Constants.MaximumTargetDistance or 110
local actors = mod("Modules.Characters.Actors")
local self = character()
local best, bestDot, bestId
for _, model in characterModels() do
if model ~= self and isAlive(model) then
local theirTeam = teams and select(2, pcall(teams.GetCharacterTeamName, model)) or nil
if mine and theirTeam == mine then
local position = modelPosition(model)
if position then
local delta = position - origin
local distance = delta.Magnitude
if distance > 1 and distance <= maximum then
local dot = direction and delta.Unit:Dot(direction) or 1
if not bestDot or dot > bestDot then
local player = Players:GetPlayerFromCharacter(model)
local userId = player and player.UserId or nil
if not userId and actors then
local ok, resolved = pcall(actors.GetUserId, model)
userId = ok and resolved or nil
end
best, bestDot, bestId = position, dot, userId
end
end
end
end
end
end
return best, bestId
end
local function opponentTarget(origin, direction, coneDegrees)
local mine = teamName()
local teams = mod("Client.Gameplay.ActorTeams")
local targeting = mod("Modules.Items.ActorTargeting")
local maximum = targeting and targeting.Constants.MaximumTargetDistance or 110
local minimumDot = math.cos(math.rad(math.clamp(coneDegrees, 1, 180) * 0.5))
local self = character()
local best, bestDot
for _, model in characterModels() do
if model ~= self and isAlive(model) then
local theirTeam = teams and select(2, pcall(teams.GetCharacterTeamName, model)) or nil
if not mine or not theirTeam or theirTeam ~= mine then
local position = modelPosition(model)
if position then
local delta = position - origin
local distance = delta.Magnitude
if distance > 1 and distance <= maximum then
local dot = direction and delta.Unit:Dot(direction) or 1
if dot >= minimumDot and (not bestDot or dot > bestDot) then
best, bestDot = position, dot
end
end
end
end
end
end
return best
end
local function interceptTarget(origin)
local points = ballPath(1)
if not points then return nil end
local best, bestDistance
for _, point in points do
local distance = (point - origin).Magnitude
if not bestDistance or distance < bestDistance then
best, bestDistance = point, distance
end
end
return best
end
local function itemRewrite(payload)
if not Settings.ItemAimbot then return nil end
if payload.Kind ~= "FireEquipped" and payload.Kind ~= "ContinueGunSequence" then return nil end
local ray = payload.AimRay
if type(ray) ~= "table" then return nil end
if typeof(ray.Origin) ~= "Vector3" or typeof(ray.Direction) ~= "Vector3" then return nil end
if ray.Direction.Magnitude < 1e-3 then return nil end
local target = opponentTarget(ray.Origin, ray.Direction.Unit, Settings.ItemAimFov)
local direction = target and aimedDirection(ray.Origin, target)
if not direction then return nil end
local aim = table.clone(ray)
aim.Direction = direction
aim.ClientHit = nil
local copy = table.clone(payload)
copy.AimRay = aim
return copy
end
local function keeperClearRewrite(payload)
if not Settings.KeeperClearAimbot then return nil end
local commands = mod("Modules.Actions.ActionCommands")
local throwType = commands and commands.PassTypes.Throw or "Throw"
if payload.Kind ~= "Kick" or payload.PassType ~= throwType then return nil end
local origin = aimOrigin(payload)
if not origin then return nil end
local aim = payload.AimDirection
local current = type(aim) == "table" and aim.Direction or (typeof(aim) == "Vector3" and aim or nil)
local target = passTarget(origin, typeof(current) == "Vector3" and current.Unit or nil)
local direction = target and aimedDirection(origin, target + Vector3.yAxis * 2)
if not direction then return nil end
local copy = table.clone(payload)
if not applyAim(copy, direction) then return nil end
return copy
end
local function firedByUs()
return type(checkcaller) == "function" and checkcaller()
end
local function computeRewrite(payload)
local command = payload.Command
if type(command) ~= "table" or payload.Protocol == nil then
if payload.Kind == "FireEquipped" or payload.Kind == "ContinueGunSequence" then
return itemRewrite(payload)
end
if firedByUs() then return nil end
return keeperClearRewrite(payload)
end
if firedByUs() then return nil end
local kind = command.Kind
local phase = payload.Phase
local isRelease = phase == nil or phase == "Release"
local isAimPhase = isRelease or phase == "Update"
if not isAimPhase then return nil end
local origin = aimOrigin(command)
if not origin then return nil end
local commands = mod("Modules.Actions.ActionCommands")
local shotType = commands and commands.PassTypes.Shot or "Shot"
local assistedType = commands and commands.PassTypes.AssistedPass or "AssistedPass"
local copy = table.clone(command)
local changed = false
if kind == "Kick" or kind == "Tackle" or kind == "RainbowFlick" then
local isShot = kind == "Kick" and (copy.PassType == shotType or copy.PassType == nil)
local isVolley = kind ~= "Kick" and (copy.Mode == "Volley" or copy.Mode == "Kick")
if Settings.UnsavableShot and isRelease and (isShot or isVolley) then
local target = shotTarget(origin, "Top Corner", "Away From Keeper")
local direction = target and aimedDirection(origin, target)
if direction and applyAim(copy, direction) then changed = true end
elseif Settings.ShotAimbot and (isShot or isVolley) then
local target = shotTarget(origin, Settings.ShotPlacement, Settings.TargetPost)
local direction = target and aimedDirection(origin, target)
if direction and applyAim(copy, direction) then changed = true end
elseif Settings.AutoPass and kind == "Kick" and not isShot and isRelease then
local aim = copy.AimDirection
local current = type(aim) == "table" and aim.Direction or (typeof(aim) == "Vector3" and aim or nil)
local target, userId = passTarget(origin, typeof(current) == "Vector3" and current.Unit or nil)
local direction = target and aimedDirection(origin, target + Vector3.yAxis * 2)
if direction and applyAim(copy, direction) then
copy.PassType = assistedType
if userId then copy.TargetUserId = userId end
copy.TargetPosition = target
changed = true
end
end
end
if Settings.TackleAimbot and kind == "Tackle" and copy.Mode == "Slide" then
local carrier = ballCarrier()
local target = carrier and carrier ~= character() and modelPosition(carrier) or nil
if not target then
local state = ballState()
target = state and state.Position or nil
end
local direction = target and aimedDirection(origin, target)
if direction and applyAim(copy, direction) then changed = true end
end
if Settings.AutoVolley and kind == "Tackle" and (copy.Mode == "Volley" or copy.Mode == "Kick") and not Settings.ShotAimbot and not Settings.UnsavableShot then
local target = interceptTarget(origin)
local direction = target and aimedDirection(origin, target)
if direction and applyAim(copy, direction) then changed = true end
end
if Settings.PerfectCharge and isRelease and kind ~= "CallForPass" then
local core = mod("Modules.Actions.KickCore")
local maximum = copy.MaximumChargeSeconds
if type(maximum) ~= "number" and core then
maximum = copy.PassType == shotType and core.Constants.MaximumChargeSeconds or core.PassConstants.MaximumChargeSeconds
end
if type(maximum) == "number" and type(copy.ChargeSeconds) == "number" and copy.ChargeSeconds < maximum then
copy.ChargeSeconds = maximum
changed = true
end
end
if not changed then return nil end
return { Protocol = payload.Protocol, Phase = payload.Phase, Command = copy }
end
local function rewriteAction(_, payload)
local method = getnamecallmethod()
local ok, replaced = pcall(computeRewrite, payload)
setnamecallmethod(method)
return ok and replaced or nil
end
if type(getnamecallmethod) == "function" and type(setnamecallmethod) == "function" then
Shared.Rewrite = rewriteAction
end
if Shared.HookVersion ~= 2 and type(hookmetamethod) == "function"
and type(getnamecallmethod) == "function" and type(setnamecallmethod) == "function" then
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
local method = getnamecallmethod()
if method == "FireServer" then
local rewrite = Shared.Rewrite
if rewrite then
local payload = ...
if type(payload) == "table" and (payload.Command ~= nil or payload.Kind ~= nil) then
local ok, replaced = pcall(rewrite, self, payload)
setnamecallmethod(method)
if ok and replaced then
return oldNamecall(self, replaced)
end
end
end
end
return oldNamecall(self, ...)
end)
Shared.HookVersion = 2
Shared.Hooked = true
end
local staminaApplied = false
local function applyStamina(state)
local sprint = mod("Modules.Actions.Sprint")
if not sprint then return end
if state then
pcall(sprint.SetUnlimitedStamina, LocalPlayer, "KaliHub", true)
local model = character()
if model then
pcall(sprint.SetUnlimitedStamina, model, "KaliHub", true)
end
staminaApplied = true
else
pcall(sprint.ClearUnlimitedStaminaSource, "KaliHub")
staminaApplied = false
end
end
table.insert(Kali.Restore, function()
if staminaApplied then applyStamina(false) end
end)
local movementOriginals = nil
local function movementConstants()
local movement = mod("Modules.Actions.ActionMovement")
if not movement then return nil end
if not movementOriginals then
movementOriginals = {
BallCarrierJogSpeedMultiplier = movement.Constants.BallCarrierJogSpeedMultiplier,
BallCarrierRunSpeedMultiplier = movement.Constants.BallCarrierRunSpeedMultiplier,
ChargingWalkSpeedMultiplier = movement.Constants.ChargingWalkSpeedMultiplier,
}
end
return movement.Constants
end
table.insert(Kali.Restore, function()
local movement = mod("Modules.Actions.ActionMovement")
if movement and movementOriginals then
for key, value in movementOriginals do
movement.Constants[key] = value
end
end
end)
local function applyMovement()
local constants = movementConstants()
if not constants then return end
constants.BallCarrierJogSpeedMultiplier = Settings.NoBallSlowdown and 1 or movementOriginals.BallCarrierJogSpeedMultiplier
constants.BallCarrierRunSpeedMultiplier = Settings.NoBallSlowdown and 1 or movementOriginals.BallCarrierRunSpeedMultiplier
constants.ChargingWalkSpeedMultiplier = Settings.FullSpeedCharge and 1 or movementOriginals.ChargingWalkSpeedMultiplier
end
local sprintToggled = false
local function releaseSprint()
if not sprintToggled then return end
sprintToggled = false
local sprint = mod("Client.Gameplay.Player.Sprint")
if not sprint then return end
local ok, toggled = pcall(sprint.IsSprintButtonToggled)
if ok and toggled then pcall(sprint.ToggleSprintButton) end
end
table.insert(Kali.Restore, releaseSprint)
local autoConnection = nil
local nextDribble, nextVolley, nextDive, nextMovement = 0, 0, 0, 0
local nextItem, nextCall, nextSprint = 0, 0, 0
local function autoWanted()
return Settings.AutoDribble or Settings.AutoVolley or Settings.AutoGoalkeeper
or Settings.NoBallSlowdown or Settings.FullSpeedCharge
or Settings.AutoUseItem or Settings.AutoCallForPass or Settings.AutoSprint
end
local function stepAutoDribble(now)
if now < nextDribble or not holdsBall() then return end
local hitboxes = mod("Modules.Gameplay.HitboxSettings")
local root = rootPart()
local self = character()
if not hitboxes or not root or not self then return end
local mine = teamName()
local teams = mod("Client.Gameplay.ActorTeams")
for _, model in characterModels() do
if model ~= self and isAlive(model) then
local theirTeam = teams and select(2, pcall(teams.GetCharacterTeamName, model)) or nil
if not mine or not theirTeam or theirTeam ~= mine then
local theirRoot = model:FindFirstChild("HumanoidRootPart")
if theirRoot and (theirRoot.Position - root.Position).Magnitude < 14 then
local okSlide, slide = pcall(hitboxes.ContainsPoint, theirRoot, hitboxes.SlideTackle, root.Position)
local okKick, kick = pcall(hitboxes.ContainsPoint, theirRoot, hitboxes.Kick, root.Position)
if (okSlide and slide) or (okKick and kick) then
if sendAction("Dribble", "Client.Gameplay.Actions.Dodge") then
nextDribble = now + 0.6
end
return
end
end
end
end
end
end
local function stepAutoVolley(now)
if now < nextVolley or holdsBall() then return end
local lockOn = mod("Modules.Ball.VolleyLockOn")
local root = rootPart()
if not root then return end
local state = ballState()
if not state or state.Mode ~= "Airborne" then return end
local minimumSpeed = lockOn and lockOn.Constants.MinimumBallSpeed or 20
if state.Velocity.Magnitude < minimumSpeed then return end
local reaction = lockOn and lockOn.Constants.ReactionSeconds or 0.25
local approach = lockOn and lockOn.Constants.MaximumApproachSeconds or 0.4
local points = ballPath(approach + reaction)
if not points then return end
for index, point in points do
if (point - root.Position).Magnitude <= 6 then
if (index - 1) * 0.05 <= reaction then
if sendAction("Tackle", "Client.Gameplay.Actions.SlideTackleInput") then
nextVolley = now + 0.5
end
end
return
end
end
end
local function defendedGoal()
local practice = mod("Client.Gameplay.PracticeSession")
if practice then
local ok, part = pcall(practice.GetDefendedGoalPart)
if ok and typeof(part) == "Instance" then return part end
end
return goalPart(false)
end
local function diveTowards(direction)
local model = character()
local humanoid = model and model:FindFirstChildOfClass("Humanoid")
local role = mod("Client.Gameplay.Player.GoalkeeperRole")
if not humanoid or not role then return false end
local restore = humanoid.MoveDirection
humanoid:Move(direction, false)
local okDive, dived = pcall(role.Dive)
humanoid:Move(restore, false)
return okDive and dived == true
end
local DIVE_DIRECTIONS = { "F", "LF", "L", "LB", "B", "RB", "R", "RF" }
local function freshDive(dive)
return {
CanExtendReach = true,
ElapsedSeconds = 0,
WarpedSeconds = 0,
TravelScale = 1,
Distance = dive.Constants.Distance,
GetVerticalOffset = dive.GetVerticalTravel,
}
end
local function assistedDive(dive, assist)
local velocity = assist.InitialVerticalVelocity or dive.Constants.InitialVerticalVelocity
local gravity = assist.Gravity or dive.Constants.GravityStudsPerSecondSquared
return {
CanExtendReach = false,
ElapsedSeconds = 0,
WarpedSeconds = 0,
TravelScale = assist.TravelScale or 1,
Distance = dive.Constants.Distance + (assist.ExtraDistance or 0),
GetVerticalOffset = function(seconds)
return velocity * seconds + 0.5 * gravity * seconds * seconds
end,
}
end
local function keeperLaunchDirections(dive, camera, flat)
local directions = {}
for _, name in DIVE_DIRECTIONS do
local choice = dive.GetDirectionChoiceByName(name)
local ok, direction = pcall(dive.GetWorldDirection, choice, camera, flat)
if ok and typeof(direction) == "Vector3" then
table.insert(directions, direction)
end
end
return directions
end
local function keeperGoalGuard(root, defended, attacking)
if not defended or not attacking then return nil end
local axis = defended.Position - attacking.Position
axis = Vector3.new(axis.X, 0, axis.Z)
if axis.Magnitude < 1e-3 then return nil end
local inward = axis.Unit
local cframe, size = defended.CFrame, defended.Size
local line = defended.Position:Dot(inward)
- math.abs(cframe.RightVector:Dot(inward)) * size.X * 0.5
- math.abs(cframe.UpVector:Dot(inward)) * size.Y * 0.5
- math.abs(cframe.LookVector:Dot(inward)) * size.Z * 0.5
local standing = root.Position:Dot(inward) - line
local limit = math.max(standing, 0)
return function(direction, distance)
return (root.Position + direction * distance):Dot(inward) - line <= limit
end
end
local function keeperDiveMiss(dive, diveAssist, state, world, root, direction, serverNow, live, allows)
local okAssist, assist = pcall(diveAssist.GetAssist, state, world, root, direction, serverNow)
if not okAssist or type(assist) ~= "table" then assist = nil end
local aimed, context = direction, freshDive(dive)
if assist then
pcall(diveAssist.DropBlockedLaunchYaw, root, direction, assist)
if type(assist.YawRadians) == "number" and assist.YawRadians ~= 0 then
aimed = dive.RotateFlatDirection(direction, assist.YawRadians)
end
context = assistedDive(dive, assist)
end
if allows and not allows(aimed, context.Distance) then return nil end
local ok, intercept = pcall(diveAssist.FindFlightIntercept,
state, world, root.CFrame, aimed, serverNow, context, live)
if ok and type(intercept) == "table" and type(intercept.MissDistance) == "number" then
return intercept.MissDistance
end
return nil
end
local function keeperBestDive(dive, diveAssist, state, world, root, directions, serverNow, live, allows)
local best, bestMiss
for _, direction in directions do
local miss = keeperDiveMiss(dive, diveAssist, state, world, root, direction, serverNow, live, allows)
if miss and (not bestMiss or miss < bestMiss) then
best, bestMiss = direction, miss
end
end
return best, bestMiss
end
local function stepAutoGoalkeeper(now)
local role = mod("Client.Gameplay.Player.GoalkeeperRole")
local prediction = mod("Modules.Gameplay.GoalkeeperPrediction")
local dive = mod("Modules.Actions.GoalkeeperDive")
local diveAssist = mod("Modules.Actions.GoalkeeperDiveAssist")
local sampling = mod("Modules.Ball.FlightSampling")
local physics = mod("Modules.Ball.Physics")
local hitboxes = mod("Modules.Gameplay.HitboxSettings")
local facing = mod("Modules.Actions.AimFacing")
local smoothing = mod("Client.Player.CharacterMotionSmoothing")
if not role or not prediction or not dive or not diveAssist or not sampling
or not physics or not hitboxes or not facing then return end
local okRole, isKeeper = pcall(role.IsGoalkeeper)
if not okRole or not isKeeper then return end
local root = rootPart()
local humanoid = root and root.Parent and root.Parent:FindFirstChildOfClass("Humanoid")
local goal = defendedGoal()
local state, world = goalkeeperState()
if not root or not humanoid or not goal or not state or not world then return end
local serverNow = Workspace:GetServerTimeNow()
if smoothing then
local okTime, smoothed = pcall(smoothing.GetSmoothedServerTime)
if okTime and type(smoothed) == "number" then serverNow = smoothed end
end
local window = dive.Constants.HitboxCurveSeconds
local okLive, live = pcall(physics.GetStateAtTime, state, serverNow, world)
if not okLive or type(live) ~= "table" then return end
local okFlight, flight = pcall(sampling.Sample, live, world, serverNow, window)
if not okFlight or type(flight) ~= "table" or #flight == 0 then return end
local airborne = humanoid.FloorMaterial == Enum.Material.Air
local resting = airborne and hitboxes.AirReceive or hitboxes.Receive
local closest = math.huge
for _, point in flight do
local okInside, inside = pcall(hitboxes.ContainsPoint, root, resting, point)
if okInside and inside then return end
local distance = (point - root.Position).Magnitude
if distance < closest then closest = distance end
end
local reach = dive.Constants.Distance + diveAssist.Constants.MaximumExtraReachStuds
+ hitboxes.AirReceive.Size.Y * 0.5
if closest > reach or now < nextDive then return end
local horizon = math.min(prediction.Constants.GoalCrossingMaximumPredictionSeconds, 2)
local okCrossing, crossing, crossingTime = pcall(prediction.GetGoalCrossing,
state, world, goal, serverNow, horizon)
if not okCrossing or typeof(crossing) ~= "Vector3" or type(crossingTime) ~= "number" then return end
if crossingTime <= serverNow then return end
local camera = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame or root.CFrame
local flat = facing.GetFlatDirection(root.CFrame.LookVector) or root.CFrame.LookVector
local directions = keeperLaunchDirections(dive, camera, flat)
local allows = keeperGoalGuard(root, goal, goalPart(true))
local direction, miss = keeperBestDive(dive, diveAssist, state, world, root,
directions, serverNow, live, allows)
if not direction or miss > Settings.KeeperTolerance then return end
if diveTowards(direction) then
nextDive = now + dive.Constants.RepeatDelaySeconds
end
end
local function aimedItemEquipped()
local model = character()
local held = mod("Modules.Items.HeldItems")
local ids = mod("Modules.Items.ItemIds")
local aim = mod("Modules.Items.ItemAim")
if not model or not held or not ids or not aim then return false end
local okModel, itemModel = pcall(held.FindModel, model)
if not okModel or not itemModel then return false end
local itemId = itemModel:GetAttribute(ids.AttributeName)
if type(itemId) ~= "string" then return false end
local okGun, usesGun = pcall(aim.UsesGunReticle, itemId)
if okGun and usesGun then return true end
local okCamera, usesCamera = pcall(aim.UsesCameraFacing, itemId)
return okCamera and usesCamera or false
end
local function stepAutoUseItem(now)
if now < nextItem then return end
local state = mod("Client.Gameplay.ItemUseState")
if not state then return end
local okEquipped, equipped = pcall(state.IsEquipped)
if not okEquipped or not equipped then return end
if aimedItemEquipped() then
local root = rootPart()
if not root then return end
if not opponentTarget(root.Position, Camera.CFrame.LookVector, Settings.ItemAimFov) then return end
end
nextItem = now + 0.4
pcall(state.ActivateEquipped)
end
local function stepAutoCallForPass(now)
if now < nextCall then return end
local caller = mod("Client.Gameplay.Actions.CallForPass")
local protocol = mod("Modules.Actions.ActionRemoteProtocol")
local commands = mod("Modules.Actions.ActionCommands")
if not caller or not protocol or not commands then return end
local okCan, can = pcall(caller.CanCallForPass)
if not okCan or not can then return end
local rules = mod("Modules.Actions.CallForPass")
nextCall = now + (rules and rules.Constants.CooldownSeconds or 2)
pcall(protocol.Send, commands.CallForPass())
end
local function stepAutoSprint(now)
if now < nextSprint then return end
nextSprint = now + 0.5
local sprint = mod("Client.Gameplay.Player.Sprint")
if not sprint then return end
local okToggled, toggled = pcall(sprint.IsSprintButtonToggled)
if not okToggled or toggled then return end
local okUsable, usable = pcall(sprint.IsSprintButtonUsable)
if not okUsable or not usable then return end
sprintToggled = true
pcall(sprint.ToggleSprintButton)
end
local function startAuto()
if autoConnection then return end
autoConnection = Kali.track(RunService.Heartbeat:Connect(function()
if not Kali.Running or not autoWanted() then return end
local now = os.clock()
if now >= nextMovement and (Settings.NoBallSlowdown or Settings.FullSpeedCharge) then
nextMovement = now + 0.5
applyMovement()
end
if Settings.AutoDribble then stepAutoDribble(now) end
if Settings.AutoVolley then stepAutoVolley(now) end
if Settings.AutoGoalkeeper then stepAutoGoalkeeper(now) end
if Settings.AutoUseItem then stepAutoUseItem(now) end
if Settings.AutoCallForPass then stepAutoCallForPass(now) end
if Settings.AutoSprint then stepAutoSprint(now) end
end))
end
local function stopAuto()
if not autoConnection then return end
pcall(function() autoConnection:Disconnect() end)
autoConnection = nil
end
local hasDrawing = pcall(function()
local probe = Drawing.new("Line")
probe:Remove()
end)
local function newDrawing(class, props)
if not hasDrawing then
return { Visible = false, Text = "", Remove = function() end }
end
local object = Drawing.new(class)
for key, value in props do
object[key] = value
end
object.Visible = false
table.insert(Kali.Drawings, object)
return object
end
local flightPathLines = {}
local flightPathUsed = 0
local landingMarker, landingLabel
local function flightPathLine(index)
local existing = flightPathLines[index]
if existing then return existing end
local made = newDrawing("Line", { Thickness = 2, Color = WHITE, Transparency = 0.85 })
flightPathLines[index] = made
return made
end
local espSlots = {}
local espUsed = 0
local function espSlot(index)
local existing = espSlots[index]
if existing then return existing end
local made = {
outline = newDrawing("Square", { Thickness = 3, Filled = false, Color = Color3.new() }),
box = newDrawing("Square", { Thickness = 1, Filled = false, Color = WHITE }),
name = newDrawing("Text", { Size = 13, Center = true, Outline = true, Color = WHITE }),
}
espSlots[index] = made
return made
end
local boxSlots = {}
local boxUsed = 0
local function boxSlot(index)
local existing = boxSlots[index]
if existing then return existing end
local made = newDrawing("Circle", { Thickness = 2, NumSides = 16, Radius = 5, Filled = false, Color = WHITE })
boxSlots[index] = made
return made
end
local function hideFlightPathFrom(index)
for i = index, flightPathUsed do
local line = flightPathLines[i]
if line then line.Visible = false end
end
flightPathUsed = math.max(index - 1, 0)
end
local function hideEspFrom(index)
for i = index, espUsed do
local entry = espSlots[i]
if entry then
for _, object in entry do object.Visible = false end
end
end
espUsed = math.max(index - 1, 0)
end
local function hideBoxesFrom(index)
for i = index, boxUsed do
local circle = boxSlots[i]
if circle then circle.Visible = false end
end
boxUsed = math.max(index - 1, 0)
end
local tracerSlots = {}
local tracerUsed = 0
local function tracerSlot(index)
local existing = tracerSlots[index]
if existing then return existing end
local made = newDrawing("Line", { Thickness = 1, Color = WHITE })
tracerSlots[index] = made
return made
end
local function hideTracersFrom(index)
for i = index, tracerUsed do
local line = tracerSlots[i]
if line then line.Visible = false end
end
tracerUsed = math.max(index - 1, 0)
end
local chamEntries = {}
local chamStamp = 0
local function chamEntry(model)
local existing = chamEntries[model]
if existing then return existing end
local highlight = Instance.new("Highlight")
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.FillTransparency = 0.65
highlight.OutlineTransparency = 0
highlight.Adornee = model
highlight.Parent = model
local made = { highlight = highlight, stamp = 0 }
chamEntries[model] = made
return made
end
local function sweepChams()
for model, entry in chamEntries do
if entry.highlight.Parent == nil then
chamEntries[model] = nil
elseif entry.stamp ~= chamStamp then
entry.highlight.Enabled = false
end
end
end
local worldSlots = {}
local worldUsed = 0
local function worldSlot(index)
local existing = worldSlots[index]
if existing then return existing end
local made = {
circle = newDrawing("Circle", { Thickness = 2, NumSides = 12, Radius = 6, Filled = false, Color = WHITE }),
name = newDrawing("Text", { Size = 12, Center = true, Outline = true, Color = WHITE }),
}
worldSlots[index] = made
return made
end
local function hideWorldFrom(index)
for i = index, worldUsed do
local entry = worldSlots[i]
if entry then
for _, object in entry do object.Visible = false end
end
end
worldUsed = math.max(index - 1, 0)
end
local shotMarker, ballMarker, ballLabel
local visualConnection = nil
local function visualsWanted()
return Settings.FlightPath or Settings.LandingMarker or Settings.ShotPreview or Settings.BallEsp
or Settings.PlayerEsp or Settings.PlayerTracers or Settings.PlayerChams
or Settings.ItemBoxEsp or Settings.WorldItemEsp or Settings.ProjectileEsp
end
local function drawFlightPath()
if not Settings.FlightPath then
if flightPathUsed > 0 then hideFlightPathFrom(1) end
return
end
local points = ballPath(Settings.FlightPathSeconds)
if not points or #points < 2 then
if flightPathUsed > 0 then hideFlightPathFrom(1) end
return
end
local index = 0
local previous, previousOn = Camera:WorldToViewportPoint(points[1])
for i = 2, #points do
local current, currentOn = Camera:WorldToViewportPoint(points[i])
if previousOn and currentOn then
index += 1
local line = flightPathLine(index)
line.From = Vector2.new(previous.X, previous.Y)
line.To = Vector2.new(current.X, current.Y)
line.Visible = true
end
previous, previousOn = current, currentOn
end
hideFlightPathFrom(index + 1)
flightPathUsed = index
end
local function drawLandingMarker()
if not Settings.LandingMarker then
if landingMarker then
landingMarker.Visible = false
landingLabel.Visible = false
end
return
end
local indicator = mod("Modules.Ball.LandingIndicator")
local state = ballState()
local world = boundaryWorld()
if not indicator or not state or not world then return end
if not landingMarker then
landingMarker = newDrawing("Circle", { Thickness = 2, NumSides = 24, Radius = 9, Filled = false, Color = WHITE })
landingLabel = newDrawing("Text", { Size = 13, Center = true, Outline = true, Color = WHITE })
end
local now = Workspace:GetServerTimeNow()
local okLanding, landing = pcall(indicator.GetLanding, state, world, now)
if not okLanding or type(landing) ~= "table" then
landingMarker.Visible = false
landingLabel.Visible = false
return
end
local okPosition, position = pcall(indicator.GetEffectPosition, state, landing)
if not okPosition or typeof(position) ~= "Vector3" then
landingMarker.Visible = false
landingLabel.Visible = false
return
end
local screen, onScreen = Camera:WorldToViewportPoint(position)
landingMarker.Visible = onScreen
landingLabel.Visible = onScreen
if onScreen then
landingMarker.Position = Vector2.new(screen.X, screen.Y)
landingLabel.Position = Vector2.new(screen.X, screen.Y + 12)
local seconds = type(landing.Time) == "number" and landing.Time - now or 0
landingLabel.Text = string.format("%.1fs", math.max(seconds, 0))
end
end
local function drawPlayers()
chamStamp += 1
if not (Settings.PlayerEsp or Settings.PlayerTracers or Settings.PlayerChams) then
if espUsed > 0 then hideEspFrom(1) end
if tracerUsed > 0 then hideTracersFrom(1) end
sweepChams()
return
end
local origin = Camera.CFrame.Position
local viewport = Camera.ViewportSize
local footing = Vector2.new(viewport.X * 0.5, viewport.Y)
local mine = teamName()
local teams = mod("Client.Gameplay.ActorTeams")
local self = character()
local index, tracerIndex = 0, 0
for _, model in characterModels() do
if model ~= self and isAlive(model) then
local position = modelPosition(model)
if position then
local distance = (position - origin).Magnitude
if distance <= Settings.EspMaxDistance then
local theirTeam = teams and select(2, pcall(teams.GetCharacterTeamName, model)) or nil
local colour = (mine and theirTeam == mine) and Color3.fromRGB(120, 200, 255) or Color3.fromRGB(255, 110, 110)
if Settings.PlayerChams then
local entry = chamEntry(model)
entry.highlight.FillColor = colour
entry.highlight.OutlineColor = colour
entry.highlight.Enabled = true
entry.stamp = chamStamp
end
local top, onScreen = Camera:WorldToViewportPoint(position + Vector3.new(0, 3.2, 0))
if onScreen then
local bottom = Camera:WorldToViewportPoint(position - Vector3.new(0, 3, 0))
local height = math.abs(top.Y - bottom.Y)
local width = height * 0.5
if Settings.PlayerEsp then
index += 1
local entry = espSlot(index)
entry.box.Color = colour
entry.box.Position = Vector2.new(top.X - width * 0.5, top.Y)
entry.box.Size = Vector2.new(width, height)
entry.box.Visible = true
entry.outline.Position = entry.box.Position
entry.outline.Size = entry.box.Size
entry.outline.Visible = true
entry.name.Color = colour
entry.name.Position = Vector2.new(top.X, top.Y - 15)
entry.name.Text = string.format("%s  %d", model.Name, distance)
entry.name.Visible = true
end
if Settings.PlayerTracers then
tracerIndex += 1
local line = tracerSlot(tracerIndex)
line.Color = colour
line.From = footing
line.To = Vector2.new(bottom.X, bottom.Y)
line.Visible = true
end
end
end
end
end
end
hideEspFrom(index + 1)
espUsed = index
hideTracersFrom(tracerIndex + 1)
tracerUsed = tracerIndex
sweepChams()
end
local function drawShotPreview()
if not Settings.ShotPreview then
if shotMarker then shotMarker.Visible = false end
return
end
local root = rootPart()
local profile = Settings.UnsavableShot and "Top Corner" or Settings.ShotPlacement
local side = Settings.UnsavableShot and "Away From Keeper" or Settings.TargetPost
local target = root and shotTarget(root.Position, profile, side)
if not target then
if shotMarker then shotMarker.Visible = false end
return
end
if not shotMarker then
shotMarker = newDrawing("Circle", { Thickness = 2, NumSides = 20, Radius = 7, Filled = false, Color = WHITE })
end
local screen, onScreen = Camera:WorldToViewportPoint(target)
shotMarker.Visible = onScreen
if onScreen then
shotMarker.Position = Vector2.new(screen.X, screen.Y)
end
end
local function drawBall()
if not Settings.BallEsp then
if ballMarker then
ballMarker.Visible = false
ballLabel.Visible = false
end
return
end
local state = ballState()
if not state then
if ballMarker then
ballMarker.Visible = false
ballLabel.Visible = false
end
return
end
if not ballMarker then
ballMarker = newDrawing("Circle", { Thickness = 2, NumSides = 20, Radius = 8, Filled = false, Color = WHITE })
ballLabel = newDrawing("Text", { Size = 13, Center = true, Outline = true, Color = WHITE })
end
local screen, onScreen = Camera:WorldToViewportPoint(state.Position)
ballMarker.Visible = onScreen
ballLabel.Visible = onScreen
if onScreen then
ballMarker.Position = Vector2.new(screen.X, screen.Y)
ballLabel.Position = Vector2.new(screen.X, screen.Y + 12)
local carrier = ballCarrier()
local distance = (state.Position - Camera.CFrame.Position).Magnitude
ballLabel.Text = carrier and string.format("%s  %d", carrier.Name, distance) or string.format("%d", distance)
end
end
local function drawWorldItems()
if not (Settings.WorldItemEsp or Settings.ProjectileEsp) then
if worldUsed > 0 then hideWorldFrom(1) end
return
end
local world = mod("Modules.Items.ItemWorld")
local okContainer, container = false, nil
if world then
okContainer, container = pcall(world.GetContainer)
end
if not okContainer or typeof(container) ~= "Instance" then
if worldUsed > 0 then hideWorldFrom(1) end
return
end
local origin = Camera.CFrame.Position
local index = 0
for _, instance in container:GetChildren() do
if not CollectionService:HasTag(instance, "GameplayItemBox") then
local placed = instance:GetAttribute("PlacedItemId")
if (placed and Settings.WorldItemEsp) or (not placed and Settings.ProjectileEsp) then
local position
if instance:IsA("BasePart") then
position = instance.Position
elseif instance:IsA("Model") then
position = instance:GetPivot().Position
end
if position and (position - origin).Magnitude <= Settings.EspMaxDistance then
local screen, onScreen = Camera:WorldToViewportPoint(position)
if onScreen then
index += 1
local entry = worldSlot(index)
local colour = placed and Color3.fromRGB(255, 140, 90) or Color3.fromRGB(180, 255, 140)
local label = placed or instance.Name
entry.circle.Color = colour
entry.circle.Position = Vector2.new(screen.X, screen.Y)
entry.circle.Visible = true
entry.name.Color = colour
entry.name.Position = Vector2.new(screen.X, screen.Y + 10)
if entry.name.Text ~= label then entry.name.Text = label end
entry.name.Visible = true
end
end
end
end
end
hideWorldFrom(index + 1)
worldUsed = index
end
local function drawItemBoxes()
if not Settings.ItemBoxEsp then
if boxUsed > 0 then hideBoxesFrom(1) end
return
end
local origin = Camera.CFrame.Position
local index = 0
for _, instance in CollectionService:GetTagged("GameplayItemBox") do
local position
if instance:IsA("BasePart") then
position = instance.Position
elseif instance:IsA("Model") then
position = instance:GetPivot().Position
end
if position and (position - origin).Magnitude <= Settings.EspMaxDistance then
local screen, onScreen = Camera:WorldToViewportPoint(position)
if onScreen then
index += 1
local circle = boxSlot(index)
circle.Position = Vector2.new(screen.X, screen.Y)
circle.Color = Color3.fromRGB(255, 215, 110)
circle.Visible = true
end
end
end
hideBoxesFrom(index + 1)
boxUsed = index
end
local function hideAllVisuals()
if flightPathUsed > 0 then hideFlightPathFrom(1) end
if espUsed > 0 then hideEspFrom(1) end
if tracerUsed > 0 then hideTracersFrom(1) end
chamStamp += 1
sweepChams()
if boxUsed > 0 then hideBoxesFrom(1) end
if worldUsed > 0 then hideWorldFrom(1) end
if landingMarker then
landingMarker.Visible = false
landingLabel.Visible = false
end
if shotMarker then shotMarker.Visible = false end
if ballMarker then
ballMarker.Visible = false
ballLabel.Visible = false
end
end
local function startVisuals()
if visualConnection then return end
visualConnection = Kali.track(RunService.RenderStepped:Connect(function()
if not Kali.Running or not visualsWanted() then
hideAllVisuals()
return
end
drawFlightPath()
drawLandingMarker()
drawShotPreview()
drawBall()
drawPlayers()
drawItemBoxes()
drawWorldItems()
end))
end
local function stopVisuals()
if not visualConnection then return end
pcall(function() visualConnection:Disconnect() end)
visualConnection = nil
hideAllVisuals()
end
Kali.track(LocalPlayer.CharacterAdded:Connect(function()
nextDive = 0
if Kali.Running and Settings.InfiniteStamina then
task.delay(1, function()
if Kali.Running and Settings.InfiniteStamina then applyStamina(true) end
end)
end
end))
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
local parent = (type(gethui) == "function" and gethui())
or LocalPlayer:FindFirstChildOfClass("PlayerGui")
or game:GetService("CoreGui")
local before = {}
for _, child in parent:GetChildren() do before[child] = true end
window = library:CreateWindow(gui_config, parent)
for _, child in parent:GetChildren() do
if not before[child] and child:IsA("ScreenGui") then
table.insert(Kali.Guis, child)
end
end
end
library:SetWindowName("Kali Hub | Ilegal Soccer")
local tabs = {
main = window:CreateTab("Main"),
config = window:CreateTab("Config"),
}
do
local shooting = tabs.main:CreateSection("Shooting", "left")
shooting:CreateToggle("Shot Aimbot", Settings.ShotAimbot, function(state)
Settings.ShotAimbot = state
end)
shooting:CreateDropdown("Shot Placement", { "Auto", "Top Corner", "Half Height", "Bottom Corner", "Center" }, function(profile)
Settings.ShotPlacement = profile
end, Settings.ShotPlacement)
shooting:CreateDropdown("Target Post", { "Away From Keeper", "Left", "Right" }, function(side)
Settings.TargetPost = side
end, Settings.TargetPost)
shooting:CreateToggle("Unsavable Shot", Settings.UnsavableShot, function(state)
Settings.UnsavableShot = state
end)
shooting:CreateToggle("Perfect Charge", Settings.PerfectCharge, function(state)
Settings.PerfectCharge = state
end)
end
do
local passing = tabs.main:CreateSection("Passing", "left")
passing:CreateToggle("Auto Pass", Settings.AutoPass, function(state)
Settings.AutoPass = state
end)
passing:CreateToggle("Auto Volley", Settings.AutoVolley, function(state)
Settings.AutoVolley = state
if state then startAuto() elseif not autoWanted() then stopAuto() end
end)
passing:CreateToggle("Auto Call For Pass", Settings.AutoCallForPass, function(state)
Settings.AutoCallForPass = state
if state then startAuto() elseif not autoWanted() then stopAuto() end
end)
end
do
local defense = tabs.main:CreateSection("Defense", "left")
defense:CreateToggle("Tackle Aimbot", Settings.TackleAimbot, function(state)
Settings.TackleAimbot = state
end)
defense:CreateToggle("Auto Dribble", Settings.AutoDribble, function(state)
Settings.AutoDribble = state
if state then startAuto() elseif not autoWanted() then stopAuto() end
end)
defense:CreateToggle("Auto Goalkeeper", Settings.AutoGoalkeeper, function(state)
Settings.AutoGoalkeeper = state
if state then startAuto() elseif not autoWanted() then stopAuto() end
end)
defense:CreateSlider("Dive Tolerance", 0, 6, Settings.KeeperTolerance, true, function(studs)
Settings.KeeperTolerance = studs
end)
defense:CreateToggle("Keeper Clear Aimbot", Settings.KeeperClearAimbot, function(state)
Settings.KeeperClearAimbot = state
end)
end
do
local items = tabs.main:CreateSection("Items", "left")
items:CreateToggle("Item Aimbot", Settings.ItemAimbot, function(state)
Settings.ItemAimbot = state
end)
items:CreateSlider("Item Aim FOV", 10, 180, Settings.ItemAimFov, true, function(degrees)
Settings.ItemAimFov = degrees
end)
items:CreateToggle("Auto Use Item", Settings.AutoUseItem, function(state)
Settings.AutoUseItem = state
if state then startAuto() elseif not autoWanted() then stopAuto() end
end)
end
do
local movement = tabs.main:CreateSection("Movement", "right")
movement:CreateToggle("Infinite Stamina", Settings.InfiniteStamina, function(state)
Settings.InfiniteStamina = state
applyStamina(state)
end)
movement:CreateToggle("No Ball Slowdown", Settings.NoBallSlowdown, function(state)
Settings.NoBallSlowdown = state
applyMovement()
if state then startAuto() elseif not autoWanted() then stopAuto() end
end)
movement:CreateToggle("Full Speed Charge", Settings.FullSpeedCharge, function(state)
Settings.FullSpeedCharge = state
applyMovement()
if state then startAuto() elseif not autoWanted() then stopAuto() end
end)
movement:CreateToggle("Auto Sprint", Settings.AutoSprint, function(state)
Settings.AutoSprint = state
if state then
startAuto()
else
releaseSprint()
if not autoWanted() then stopAuto() end
end
end)
end
do
local visuals = tabs.main:CreateSection("Visuals", "right")
visuals:CreateToggle("Flight Path", Settings.FlightPath, function(state)
Settings.FlightPath = state
if state then startVisuals() elseif not visualsWanted() then stopVisuals() end
end)
visuals:CreateSlider("Flight Path Seconds", 1, 5, Settings.FlightPathSeconds, true, function(seconds)
Settings.FlightPathSeconds = seconds
end)
visuals:CreateToggle("Landing Marker", Settings.LandingMarker, function(state)
Settings.LandingMarker = state
if state then startVisuals() elseif not visualsWanted() then stopVisuals() end
end)
visuals:CreateToggle("Shot Preview", Settings.ShotPreview, function(state)
Settings.ShotPreview = state
if state then startVisuals() elseif not visualsWanted() then stopVisuals() end
end)
visuals:CreateToggle("Ball ESP", Settings.BallEsp, function(state)
Settings.BallEsp = state
if state then startVisuals() elseif not visualsWanted() then stopVisuals() end
end)
visuals:CreateToggle("Player ESP", Settings.PlayerEsp, function(state)
Settings.PlayerEsp = state
if state then startVisuals() elseif not visualsWanted() then stopVisuals() end
end)
visuals:CreateToggle("Player Tracers", Settings.PlayerTracers, function(state)
Settings.PlayerTracers = state
if state then startVisuals() elseif not visualsWanted() then stopVisuals() end
end)
visuals:CreateToggle("Player Chams", Settings.PlayerChams, function(state)
Settings.PlayerChams = state
if state then startVisuals() elseif not visualsWanted() then stopVisuals() end
end)
visuals:CreateToggle("Item Box ESP", Settings.ItemBoxEsp, function(state)
Settings.ItemBoxEsp = state
if state then startVisuals() elseif not visualsWanted() then stopVisuals() end
end)
visuals:CreateToggle("World Item ESP", Settings.WorldItemEsp, function(state)
Settings.WorldItemEsp = state
if state then startVisuals() elseif not visualsWanted() then stopVisuals() end
end)
visuals:CreateToggle("Projectile ESP", Settings.ProjectileEsp, function(state)
Settings.ProjectileEsp = state
if state then startVisuals() elseif not visualsWanted() then stopVisuals() end
end)
visuals:CreateSlider("ESP Distance", 100, 800, Settings.EspMaxDistance, true, function(distance)
Settings.EspMaxDistance = distance
end)
end
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
Shared.Rewrite = nil
stopAuto()
stopVisuals()
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
for _, entry in chamEntries do
pcall(function() entry.highlight:Destroy() end)
end
table.clear(chamEntries)
table.clear(flightPathLines)
table.clear(espSlots)
table.clear(tracerSlots)
table.clear(boxSlots)
table.clear(worldSlots)
flightPathUsed, espUsed, tracerUsed, boxUsed, worldUsed = 0, 0, 0, 0, 0
landingMarker, landingLabel = nil, nil
shotMarker, ballMarker, ballLabel = nil, nil, nil
pcall(function() window:Destroy() end)
local libraryConnections = library.Connections
if libraryConnections then
for _, connection in libraryConnections do
if typeof(connection) == "RBXScriptConnection" then
pcall(function() connection:Disconnect() end)
end
end
table.clear(libraryConnections)
end
for _, gui in Kali.Guis do
pcall(function() gui:Destroy() end)
end
table.clear(Kali.Guis)
end
