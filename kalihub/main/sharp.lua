--this shit was unobfuscated


local WHITE, BLACK = Color3.new(1, 1, 1), Color3.new()
gui_config = {
Color = WHITE,
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 100, MaxHeight = 600, InitialHeight = 440,
MinWidth = 320, MaxWidth = 800, InitialWidth = 540,
}
local fonts = {}
for _, font in Enum.Font:GetEnumItems() do
table.insert(fonts, font.Name)
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
Camera = workspace.CurrentCamera
end)
local function safeRequire(inst)
if not inst then return nil end
local ok, mod = pcall(require, inst)
return ok and mod or nil
end
local rsClient = ReplicatedStorage:FindFirstChild("Client")
local GameCharacterController = rsClient and safeRequire(rsClient.Controllers.GameCharacterController)
local CombatClient = rsClient and safeRequire(rsClient.Madwork.CombatClient)
local CharacterController = rsClient and safeRequire(rsClient.Controllers.CharacterController)
local CharacterVisibility = rsClient and safeRequire(rsClient.Modules.Character.CharacterVisibility)
local Settings = {
TargetPart = "Head",
TeamCheck = true,
WallCheck = true,
Prediction = false,
FOVRadius = 200,
SilentAim = false,
SilentFOVOnly = true,
Aimbot = false,
AimbotKey = "Right Mouse",
AimbotSmoothness = 3,
Triggerbot = false,
TriggerbotDelay = 0.08,
Ragebot = false,
RageDelay = 0.05,
ShowFOV = true,
FOVColor = WHITE,
FOVTransparency = 0.7,
FOVFilled = false,
FOVSides = 64,
FOVThickness = 1,
ESP_Enabled = false,
ESP_ShowTeammates = false,
ESP_TeamColors = true,
ESP_Box = true,
ESP_Name = true,
ESP_Health = true,
ESP_Distance = true,
ESP_Tracers = false,
ESP_TracerOrigin = "Bottom",
ESP_Skeleton = false,
ESP_Highlight = false,
ESP_MaxDistance = 2500,
ESP_BoxColor = WHITE,
ESP_NameColor = WHITE,
ESP_DistanceColor = Color3.fromRGB(200, 200, 200),
ESP_TracerColor = WHITE,
ESP_SkeletonColor = WHITE,
ESP_EnemyColor = Color3.fromRGB(255, 64, 64),
ESP_AllyColor = Color3.fromRGB(64, 160, 255),
ESP_HighlightFillColor = Color3.fromRGB(138, 43, 226),
ESP_HighlightOutlineColor = WHITE,
ESP_HighlightFillTransparency = 0.7,
ESP_HighlightOutlineTransparency = 0,
SpeedEnabled = false,
SpeedValue = 32,
InfJump = false,
NoFog = false,
Fullbright = false,
}
local function draw(class, props)
local obj = Drawing.new(class)
for prop, value in props do
obj[prop] = value
end
return obj
end
local FOVCircle = draw("Circle", {
Visible = false,
Thickness = Settings.FOVThickness,
Radius = Settings.FOVRadius,
Transparency = Settings.FOVTransparency,
Color = Settings.FOVColor,
Filled = Settings.FOVFilled,
NumSides = Settings.FOVSides,
})
local function GetTargets()
local list = {}
if not GameCharacterController then return list end
local ok, chars = pcall(GameCharacterController.GetGameCharacters)
if not ok or type(chars) ~= "table" then return list end
local localGC = GameCharacterController.LocalGameCharacter
for _, gc in ipairs(chars) do
if gc ~= localGC then
local model = gc.Character and gc.Character.Model
if model and model.Parent then
local rel = "Neutral"
pcall(function() rel = gc.GamePlayer:GetLocalRelationship() end)
local plr = gc.Player or (gc.GamePlayer and gc.GamePlayer.Player)
table.insert(list, { gc = gc, model = model, player = plr, relationship = rel })
end
end
end
return list
end
local function IsAlive(model)
local humanoid = model and model:FindFirstChildOfClass("Humanoid")
return humanoid ~= nil and humanoid.Health > 0
end
local function GetAimPart(model)
if not (model and model.Parent) then return nil end
local part = model:FindFirstChild(Settings.TargetPart)
or model:FindFirstChild("Head")
or model:FindFirstChild("UpperTorso")
or model:FindFirstChild("HumanoidRootPart")
return (part and part:IsA("BasePart")) and part or nil
end
local function IsVisible(part, model)
local origin = Camera.CFrame.Position
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
local result = workspace:Raycast(origin, part.Position - origin, params)
return not result or result.Instance:IsDescendantOf(model)
end
local function TouchPrimary()
return UserInputService.PreferredInput == Enum.PreferredInput.Touch
end
local function AimScreenPoint()
if TouchPrimary() then
local viewport = Camera.ViewportSize
return Vector2.new(viewport.X / 2, viewport.Y / 2)
end
return UserInputService:GetMouseLocation()
end
local function GetAimTarget(maxDist)
maxDist = maxDist or Settings.FOVRadius
local mousePos = AimScreenPoint()
local bestEntry, bestPart, bestDist = nil, nil, maxDist
for _, e in ipairs(GetTargets()) do
if ((not Settings.TeamCheck) or e.relationship == "Enemy") and IsAlive(e.model) then
local part = GetAimPart(e.model)
if part then
local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
if onScreen then
local dist = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
if dist < bestDist and (not Settings.WallCheck or IsVisible(part, e.model)) then
bestEntry, bestPart, bestDist = e, part, dist
end
end
end
end
end
return bestEntry, bestPart
end
local function GetAimPosition(entry, part)
if Settings.Prediction and CharacterVisibility and entry then
local ok, vis = pcall(CharacterVisibility.GetVisibility, entry.gc)
if ok and vis and typeof(vis.Prediction) == "Vector3" then
return vis.Prediction
end
end
return part.Position
end
if CombatClient and CombatClient.NewLocalEvent then
local original = CombatClient.NewLocalEvent
CombatClient.NewLocalEvent = function(action, ...)
if type(action) == "table" and typeof(action.Position) == "Vector3" and typeof(action.Direction) == "Vector3"
and (Settings.SilentAim or Settings.Ragebot) then
local maxDist = (Settings.Ragebot or not Settings.SilentFOVOnly) and math.huge or Settings.FOVRadius
local entry, part = GetAimTarget(maxDist)
if part then
local dir = GetAimPosition(entry, part) - action.Position
if dir.Magnitude > 0 then
action.Direction = dir.Unit
end
end
end
return original(action, ...)
end
end
local function ClickFire()
local character = CharacterController and CharacterController.LocalCharacter
local tools = character and character.IsAlive and character.Backpack and character.Backpack._tools
if type(tools) ~= "table" then return end
for _, tool in tools do
if tool.Equipped then
local fsm = tool.Store and tool.Store.FSM
if fsm and fsm.State == "Idle" then
pcall(fsm.Set, fsm, "Fire")
end
return
end
end
end
local function AimbotActive()
if Settings.AimbotKey == "Always" or TouchPrimary() then return true end
if Settings.AimbotKey == "Right Mouse" then
return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
elseif Settings.AimbotKey == "Left Mouse" then
return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
end
return false
end
local function ApplyAimbot()
if not Settings.Aimbot or not AimbotActive() then return end
local entry, part = GetAimTarget()
if part then
local goal = CFrame.lookAt(Camera.CFrame.Position, GetAimPosition(entry, part))
Camera.CFrame = Camera.CFrame:Lerp(goal, 1 / math.max(Settings.AimbotSmoothness, 1))
end
end
local lastTrigger = 0
local function ApplyTriggerbot()
if not Settings.Triggerbot or os.clock() - lastTrigger < Settings.TriggerbotDelay then return end
local mousePos = AimScreenPoint()
local ray = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
local result = workspace:Raycast(ray.Origin, ray.Direction * Settings.ESP_MaxDistance, params)
if not result then return end
local model = result.Instance:FindFirstAncestorWhichIsA("Model")
while model do
for _, e in ipairs(GetTargets()) do
if e.model == model and ((not Settings.TeamCheck) or e.relationship == "Enemy") and IsAlive(model) then
ClickFire()
lastTrigger = os.clock()
return
end
end
model = model:FindFirstAncestorWhichIsA("Model")
end
end
local lastRage = 0
local function ApplyRagebot()
if not Settings.Ragebot or os.clock() - lastRage < Settings.RageDelay then return end
local _, part = GetAimTarget(math.huge)
if part then
ClickFire()
lastRage = os.clock()
end
end
local function LocalHumanoid()
local lc = CharacterController and CharacterController.LocalCharacter
local model = (lc and lc.Model) or LocalPlayer.Character
return model and model:FindFirstChildOfClass("Humanoid"), model
end
local defaultWalkSpeed = nil
local function ApplyMovement()
local humanoid = LocalHumanoid()
if not humanoid then return end
if defaultWalkSpeed == nil and humanoid.WalkSpeed > 0 then
defaultWalkSpeed = humanoid.WalkSpeed
end
if Settings.SpeedEnabled then
humanoid.WalkSpeed = Settings.SpeedValue
elseif defaultWalkSpeed and humanoid.WalkSpeed ~= defaultWalkSpeed then
humanoid.WalkSpeed = defaultWalkSpeed
end
end
UserInputService.JumpRequest:Connect(function()
if Settings.InfJump then
local humanoid = LocalHumanoid()
if humanoid then
pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
end
end
end)
local ESPObjects = {}
local HighlightObjects = {}
local SkeletonConnections = {
{ "Head", "UpperTorso" },
{ "UpperTorso", "LowerTorso" },
{ "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
{ "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
{ "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
{ "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
}
local function CreateESPDrawings()
local esp = {}
for _, name in { "BoxTop", "BoxBottom", "BoxLeft", "BoxRight" } do
esp[name .. "Line"] = draw("Line", { Color = WHITE, Thickness = 1, Transparency = 1 })
esp[name .. "Outline"] = draw("Line", { Color = BLACK, Thickness = 3, Transparency = 1 })
end
esp.Name = draw("Text", { Center = true, Outline = true, OutlineColor = BLACK, Size = 13, Font = 2 })
esp.Distance = draw("Text", { Center = true, Outline = true, OutlineColor = BLACK, Size = 13, Font = 2 })
esp.HealthText = draw("Text", { Outline = true, OutlineColor = BLACK, Size = 11, Font = 2 })
esp.HealthBarOutline = draw("Line", { Color = BLACK, Thickness = 5 })
esp.HealthBarFill = draw("Line", { Thickness = 3 })
esp.Tracer = draw("Line", { Thickness = 1, Transparency = 1 })
esp.TracerOutline = draw("Line", { Color = BLACK, Thickness = 3, Transparency = 1 })
esp.SkeletonLines, esp.SkeletonOutlines = {}, {}
for i = 1, #SkeletonConnections do
esp.SkeletonLines[i] = draw("Line", { Thickness = 1, Transparency = 1 })
esp.SkeletonOutlines[i] = draw("Line", { Color = BLACK, Thickness = 3, Transparency = 1 })
end
return esp
end
local function RemoveESPDrawings(esp)
if not esp then return end
for _, obj in esp do
if typeof(obj) == "table" then
for _, line in obj do pcall(function() line:Remove() end) end
elseif obj.Remove then
pcall(function() obj:Remove() end)
end
end
end
local function RemoveHighlight(model)
local hl = HighlightObjects[model]
if hl then
pcall(function() hl:Destroy() end)
HighlightObjects[model] = nil
end
end
local function SetAllVisible(esp, visible)
for _, obj in esp do
if typeof(obj) == "table" then
for _, line in obj do line.Visible = visible end
elseif obj.Visible ~= nil then
obj.Visible = visible
end
end
end
local function setLine(line, from, to, color)
line.From, line.To, line.Visible = from, to, true
if color then line.Color = color end
end
local function GetHealthColor(pct)
if pct > 0.5 then
return Color3.fromRGB(255 * (1 - (pct - 0.5) * 2), 255, 0)
end
return Color3.fromRGB(255, 255 * pct * 2, 0)
end
local function PrimaryColor(entry)
if Settings.ESP_TeamColors then
return entry.relationship == "Enemy" and Settings.ESP_EnemyColor or Settings.ESP_AllyColor
end
return Settings.ESP_BoxColor
end
local function UpdateESP(entry, esp)
local model = entry.model
local humanoid = model and model.Parent and model:FindFirstChildOfClass("Humanoid")
local rootPart = humanoid and model:FindFirstChild("HumanoidRootPart")
local head = rootPart and model:FindFirstChild("Head")
if not head or humanoid.Health <= 0 then
SetAllVisible(esp, false)
return RemoveHighlight(model)
end
local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
if not onScreen or distance > Settings.ESP_MaxDistance then
SetAllVisible(esp, false)
return RemoveHighlight(model)
end
local primary = PrimaryColor(entry)
local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
local footPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
local boxWidth = math.abs(headPos.Y - footPos.Y) * 0.6
local boxTopLeft = Vector2.new(rootPos.X - boxWidth / 2, headPos.Y)
local boxTopRight = Vector2.new(rootPos.X + boxWidth / 2, headPos.Y)
local boxBottomLeft = Vector2.new(rootPos.X - boxWidth / 2, footPos.Y)
local boxBottomRight = Vector2.new(rootPos.X + boxWidth / 2, footPos.Y)
if Settings.ESP_Box then
setLine(esp.BoxTopOutline, boxTopLeft, boxTopRight)
setLine(esp.BoxBottomOutline, boxBottomLeft, boxBottomRight)
setLine(esp.BoxLeftOutline, boxTopLeft, boxBottomLeft)
setLine(esp.BoxRightOutline, boxTopRight, boxBottomRight)
setLine(esp.BoxTopLine, boxTopLeft, boxTopRight, primary)
setLine(esp.BoxBottomLine, boxBottomLeft, boxBottomRight, primary)
setLine(esp.BoxLeftLine, boxTopLeft, boxBottomLeft, primary)
setLine(esp.BoxRightLine, boxTopRight, boxBottomRight, primary)
else
for _, key in { "BoxTopLine", "BoxBottomLine", "BoxLeftLine", "BoxRightLine", "BoxTopOutline", "BoxBottomOutline", "BoxLeftOutline", "BoxRightOutline" } do
esp[key].Visible = false
end
end
if Settings.ESP_Name then
esp.Name.Text = entry.player and (entry.player.DisplayName or entry.player.Name) or model.Name
esp.Name.Position = Vector2.new(rootPos.X, headPos.Y - 16)
esp.Name.Color = Settings.ESP_TeamColors and primary or Settings.ESP_NameColor
esp.Name.Visible = true
else
esp.Name.Visible = false
end
if Settings.ESP_Distance then
esp.Distance.Text = `[{math.floor(distance)} studs]`
esp.Distance.Position = Vector2.new(rootPos.X, footPos.Y + 2)
esp.Distance.Color = Settings.ESP_DistanceColor
esp.Distance.Visible = true
else
esp.Distance.Visible = false
end
if Settings.ESP_Health then
local pct = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
local barX = boxTopLeft.X - 5
local fillY = footPos.Y + (headPos.Y - footPos.Y) * pct
setLine(esp.HealthBarOutline, Vector2.new(barX, footPos.Y), Vector2.new(barX, headPos.Y))
setLine(esp.HealthBarFill, Vector2.new(barX, footPos.Y), Vector2.new(barX, fillY), GetHealthColor(pct))
if pct < 1 then
esp.HealthText.Text = tostring(math.floor(humanoid.Health))
esp.HealthText.Position = Vector2.new(barX - 3, fillY - 6)
esp.HealthText.Color = GetHealthColor(pct)
esp.HealthText.Visible = true
else
esp.HealthText.Visible = false
end
else
esp.HealthBarOutline.Visible = false
esp.HealthBarFill.Visible = false
esp.HealthText.Visible = false
end
if Settings.ESP_Tracers then
local viewport = Camera.ViewportSize
local tracerStart
if Settings.ESP_TracerOrigin == "Center" then
tracerStart = Vector2.new(viewport.X / 2, viewport.Y / 2)
elseif Settings.ESP_TracerOrigin == "Mouse" then
tracerStart = AimScreenPoint()
else
tracerStart = Vector2.new(viewport.X / 2, viewport.Y)
end
local tracerEnd = Vector2.new(rootPos.X, footPos.Y)
setLine(esp.TracerOutline, tracerStart, tracerEnd)
setLine(esp.Tracer, tracerStart, tracerEnd, Settings.ESP_TracerColor)
else
esp.Tracer.Visible = false
esp.TracerOutline.Visible = false
end
if Settings.ESP_Skeleton then
for i = 1, #SkeletonConnections do
local conn = SkeletonConnections[i]
local partA = model:FindFirstChild(conn[1])
local partB = model:FindFirstChild(conn[2])
if partA and partB then
local posA = Camera:WorldToViewportPoint(partA.Position)
local posB = Camera:WorldToViewportPoint(partB.Position)
setLine(esp.SkeletonOutlines[i], Vector2.new(posA.X, posA.Y), Vector2.new(posB.X, posB.Y))
setLine(esp.SkeletonLines[i], Vector2.new(posA.X, posA.Y), Vector2.new(posB.X, posB.Y), Settings.ESP_SkeletonColor)
else
esp.SkeletonOutlines[i].Visible = false
esp.SkeletonLines[i].Visible = false
end
end
else
for i = 1, #SkeletonConnections do
esp.SkeletonOutlines[i].Visible = false
esp.SkeletonLines[i].Visible = false
end
end
if Settings.ESP_Highlight then
local hl = HighlightObjects[model]
if not (hl and hl.Parent) then
hl = Instance.new("Highlight")
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
hl.Adornee = model
hl.Parent = model
HighlightObjects[model] = hl
end
hl.FillColor = Settings.ESP_TeamColors and primary or Settings.ESP_HighlightFillColor
hl.OutlineColor = Settings.ESP_HighlightOutlineColor
hl.FillTransparency = Settings.ESP_HighlightFillTransparency
hl.OutlineTransparency = Settings.ESP_HighlightOutlineTransparency
else
RemoveHighlight(model)
end
end
local LightingDefaults = {}
local visualsSaved, fogActive, brightActive = false, false, false
local function SaveVisualDefaults()
if visualsSaved then return end
visualsSaved = true
for _, prop in { "Brightness", "ClockTime", "GlobalShadows", "Ambient", "OutdoorAmbient", "FogStart", "FogEnd" } do
LightingDefaults[prop] = Lighting[prop]
end
end
local function ApplyWorldVisuals()
if Settings.NoFog or Settings.Fullbright then SaveVisualDefaults() end
if Settings.NoFog then
Lighting.FogStart, Lighting.FogEnd = 0, 1e9
fogActive = true
elseif fogActive then
fogActive = false
Lighting.FogStart, Lighting.FogEnd = LightingDefaults.FogStart, LightingDefaults.FogEnd
end
if Settings.Fullbright then
Lighting.Brightness, Lighting.ClockTime, Lighting.GlobalShadows = 2, 14, false
Lighting.Ambient, Lighting.OutdoorAmbient = WHITE, WHITE
brightActive = true
elseif brightActive then
brightActive = false
Lighting.Brightness, Lighting.ClockTime, Lighting.GlobalShadows = LightingDefaults.Brightness, LightingDefaults.ClockTime, LightingDefaults.GlobalShadows
Lighting.Ambient, Lighting.OutdoorAmbient = LightingDefaults.Ambient, LightingDefaults.OutdoorAmbient
end
end
RunService.RenderStepped:Connect(function()
pcall(ApplyAimbot)
if TouchPrimary() and UserInputService.MouseIconEnabled then
UserInputService.MouseIconEnabled = false
end
FOVCircle.Position = AimScreenPoint()
FOVCircle.Radius = Settings.FOVRadius
FOVCircle.Visible = Settings.ShowFOV and (Settings.Aimbot or Settings.SilentAim or Settings.Triggerbot or Settings.Ragebot)
FOVCircle.Color = Settings.FOVColor
FOVCircle.Transparency = Settings.FOVTransparency
FOVCircle.Filled = Settings.FOVFilled
FOVCircle.NumSides = Settings.FOVSides
FOVCircle.Thickness = Settings.FOVThickness
if not Settings.ESP_Enabled then
for model, esp in ESPObjects do
SetAllVisible(esp, false)
RemoveHighlight(model)
end
return
end
local active = {}
for _, entry in ipairs(GetTargets()) do
if Settings.ESP_ShowTeammates or entry.relationship == "Enemy" then
active[entry.model] = true
ESPObjects[entry.model] = ESPObjects[entry.model] or CreateESPDrawings()
pcall(UpdateESP, entry, ESPObjects[entry.model])
end
end
for model, esp in ESPObjects do
if not active[model] then
SetAllVisible(esp, false)
RemoveESPDrawings(esp)
RemoveHighlight(model)
ESPObjects[model] = nil
end
end
end)
RunService.Heartbeat:Connect(function()
pcall(ApplyTriggerbot)
pcall(ApplyRagebot)
pcall(ApplyMovement)
pcall(ApplyWorldVisuals)
end)
local config = gui_config
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(config, gethui())
library:SetWindowName("Kali Hub | SHARP")
local tabs = {
main = window:CreateTab("Main"),
config = window:CreateTab("Config"),
}
local sections = {
silent = tabs.main:CreateSection("Silent Aim"),
aimbot = tabs.main:CreateSection("Aimbot"),
aim = tabs.main:CreateSection("Aim Settings", "right"),
fov = tabs.main:CreateSection("FOV Circle", "right"),
auto = tabs.main:CreateSection("Trigger / Rage"),
esp = tabs.main:CreateSection("ESP"),
move = tabs.main:CreateSection("Movement"),
espColors = tabs.main:CreateSection("ESP Colors", "right"),
world = tabs.main:CreateSection("World", "right"),
}
local function toggle(section, label, key)
section:CreateToggle(label, Settings[key], function(value)
Settings[key] = value
end)
end
local function slider(section, label, min, max, key, precise)
section:CreateSlider(label, min, max, Settings[key], precise, function(value)
Settings[key] = value
end)
end
local function colorpicker(section, toggleLabel, pickerLabel, key)
local handle = section:CreateToggle(toggleLabel, true, function() end)
section:CreateColorpicker(pickerLabel, function(color)
Settings[key] = color
end, false, false, handle)
end
toggle(sections.silent, "Silent Aim", "SilentAim")
toggle(sections.silent, "FOV Only", "SilentFOVOnly")
toggle(sections.aimbot, "Aimbot", "Aimbot")
sections.aimbot:CreateDropdown("Aim Key", { "Always", "Right Mouse", "Left Mouse" }, function(value)
Settings.AimbotKey = value
end, Settings.AimbotKey, false)
slider(sections.aimbot, "Smoothness", 1, 15, "AimbotSmoothness", true)
toggle(sections.auto, "Triggerbot", "Triggerbot")
slider(sections.auto, "Trigger Delay", 0, 0.5, "TriggerbotDelay", false)
sections.auto:CreateDivider()
toggle(sections.auto, "Ragebot", "Ragebot")
slider(sections.auto, "Rage Delay", 0, 0.3, "RageDelay", false)
sections.aim:CreateDropdown("Target Part", { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart" }, function(value)
Settings.TargetPart = value
end, Settings.TargetPart, false)
toggle(sections.aim, "Team Check", "TeamCheck")
toggle(sections.aim, "Wall Check", "WallCheck")
toggle(sections.aim, "Prediction", "Prediction")
slider(sections.aim, "FOV Radius", 20, 500, "FOVRadius", true)
toggle(sections.fov, "Show FOV Circle", "ShowFOV")
toggle(sections.fov, "FOV Filled", "FOVFilled")
slider(sections.fov, "FOV Transparency", 0.1, 1, "FOVTransparency", false)
slider(sections.fov, "FOV Thickness", 1, 5, "FOVThickness", true)
slider(sections.fov, "FOV Sides", 3, 128, "FOVSides", true)
colorpicker(sections.fov, "FOV Color", "FOV Circle Color", "FOVColor")
toggle(sections.esp, "ESP Enabled", "ESP_Enabled")
toggle(sections.esp, "Show Teammates", "ESP_ShowTeammates")
toggle(sections.esp, "Team Colors", "ESP_TeamColors")
sections.esp:CreateDivider()
toggle(sections.esp, "Box", "ESP_Box")
toggle(sections.esp, "Name", "ESP_Name")
toggle(sections.esp, "Health Bar", "ESP_Health")
toggle(sections.esp, "Distance", "ESP_Distance")
toggle(sections.esp, "Tracers", "ESP_Tracers")
sections.esp:CreateDropdown("Tracer Origin", { "Bottom", "Center", "Mouse" }, function(value)
Settings.ESP_TracerOrigin = value
end, Settings.ESP_TracerOrigin, false)
toggle(sections.esp, "Skeleton", "ESP_Skeleton")
sections.esp:CreateToggle("Highlight (Chams)", Settings.ESP_Highlight, function(value)
Settings.ESP_Highlight = value
if not value then
for model in HighlightObjects do RemoveHighlight(model) end
end
end)
sections.esp:CreateDivider()
slider(sections.esp, "Max Distance", 100, 5000, "ESP_MaxDistance", true)
colorpicker(sections.espColors, "Enemy Color", "Enemy Team Color", "ESP_EnemyColor")
colorpicker(sections.espColors, "Ally Color", "Ally Team Color", "ESP_AllyColor")
sections.espColors:CreateDivider()
colorpicker(sections.espColors, "Box Color", "Box (no team colors)", "ESP_BoxColor")
colorpicker(sections.espColors, "Name Color", "Name (no team colors)", "ESP_NameColor")
colorpicker(sections.espColors, "Distance Color", "Distance Text", "ESP_DistanceColor")
colorpicker(sections.espColors, "Tracer Color", "Tracer Line", "ESP_TracerColor")
colorpicker(sections.espColors, "Skeleton Color", "Skeleton Lines", "ESP_SkeletonColor")
toggle(sections.world, "No Fog", "NoFog")
toggle(sections.world, "Fullbright", "Fullbright")
toggle(sections.move, "Speed", "SpeedEnabled")
slider(sections.move, "Walk Speed", 16, 120, "SpeedValue", true)
toggle(sections.move, "Infinite Jump", "InfJump")
local interfaceSection = tabs.config:CreateSection("Interface")
interfaceSection:CreateDropdown("Change Font", fonts, function(value)
window:SetFont(value)
end, "", false)
interfaceSection:CreateLabel("Menu Key (PC): " .. tostring(config.Keybind):gsub("Enum.KeyCode.", ""))
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
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
window:SetTileScale(0.5)
window:SetBackgroundColor(WHITE)
window:SetBackgroundTransparency(0)
