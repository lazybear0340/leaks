--this shit was unobfuscated


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UIS = UserInputService
local RS = RunService
local stored_fonts = {}
for _, v in Enum.Font:GetEnumItems() do
table.insert(stored_fonts, v.Name)
end
local gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 100,
MaxHeight = 600,
InitialHeight = 430,
MinWidth = 350,
MaxWidth = 750,
InitialWidth = 620
}
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(gui_config, gethui())
library:SetWindowName("Kali Hub | Prison Life")
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
window:SetTileScale(0.5)
window:SetBackgroundColor(Color3.fromRGB(255, 255, 255))
window:SetBackgroundTransparency(0)
local tabs = {
combat = window:CreateTab("Combat"),
visuals = window:CreateTab("Visuals"),
world = window:CreateTab("World"),
settings = window:CreateTab("Settings")
}
local sections = {
weapon_giver = tabs.combat:CreateSection("Weapon Giver"),
weapon_mods = tabs.combat:CreateSection("Weapon Mods", "right"),
aimbot = tabs.combat:CreateSection("Aimbot"),
hitbox = tabs.combat:CreateSection("Hitbox Expander", "right"),
silent = tabs.combat:CreateSection("Silent Aim"),
trigger = tabs.combat:CreateSection("TriggerBot", "right"),
target_tools = tabs.combat:CreateSection("Target Tools"),
healthbar = tabs.visuals:CreateSection("Health Bar", "right"),
dot_esp = tabs.visuals:CreateSection("Dot ESP"),
auto_collect = tabs.world:CreateSection("Auto Collect"),
local_player = tabs.world:CreateSection("Local Player", "right"),
speed = tabs.world:CreateSection("Speed"),
cframe_speed = tabs.world:CreateSection("CFrame Speed", "right"),
teleport = tabs.world:CreateSection("Teleport", "right"),
settings_main = tabs.settings:CreateSection("Settings")
}
local TELEPORT_COOLDOWN = 5
local lastTeleport = 0
local function canTP()
local now = tick()
if now - lastTeleport >= TELEPORT_COOLDOWN then
lastTeleport = now
return true
end
local remain = math.ceil(TELEPORT_COOLDOWN - (now - lastTeleport))
return false
end
local function instantTP(cf)
if not canTP() then return end
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local root = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
if not root or not hum then return end
hum.Health = math.max(hum.Health, 1)
root.Anchored = true
root.CFrame = cf + Vector3.new(0,1,0)
task.wait(0.05)
root.Anchored = false
end
local PrisonAPI = {
Noclip = false,
InfiniteJump = false,
AutoAttack = false,
AutoRespawn = false,
AntiTaser = false,
AutoItems = { Enabled = false, GRAB_DISTANCE = 12 },
TpWalkEnabled = false,
TpStepSize = 0.25,
walkSpeedEnable = false,
speedAmount = 50,
AutoSprint = false,
Dots = { Enabled = false, DotSize = 10, FillColor = Color3.fromRGB(255,138,0), OutlineColor = Color3.fromRGB(0,0,0), FillTrans = 0.3, OutlineTrans = 0.1, OffsetY = 2 },
ChineseHat = { Enabled = false, Width = 1.6, Height = 1.6, Color = Color3.fromRGB(240,200,120), Transparency = 0.4, ShowSelf = false },
Aimbot = { Enabled = false, TeamCheck = false, WallCheck = false, FOV = 150, Smoothness = 0.22, TargetPart = "Head", ShowFOV = false, FOVColor = Color3.fromRGB(255,0,150), TargetInmates = false, TargetGuards = false, TargetCriminals = false },
SilentAim = { Enabled = false, TargetInmates = false, TargetGuards = false, TargetCriminals = false, WallCheck = false, DeathCheck = false, ForceFieldCheck = false, HitChance = 100, MissSpread = 5, FOV = 100, ShowFOV = false, ShowTargetLine = false, ShowHighlight = false, AimPart = "Head", RandomAimParts = false, AimPartsList = {"Head","Torso","HumanoidRootPart","LeftArm","RightArm","LeftLeg","RightLeg"} },
TargetKillAura = { Enabled = false, Target = nil, Connection = nil },
TargetArrest = { Enabled = false, Target = nil, Connection = nil },
Hitbox = { Enabled = false, HitboxSize = Vector3.new(15,15,15), Material = "Neon", PartType = "Ball", Transparency = 0.7 },
Guns = { ChangeGunColor = false, SelectedColor = Color3.fromRGB(255,255,255) }
}
UIS.JumpRequest:Connect(function()
if PrisonAPI.InfiniteJump then
local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end
end)
local function getGiverPosition(giver)
if giver:IsA("Model") then return giver:GetPivot().p end
if giver:IsA("BasePart") then return giver.Position end
return nil
end
local function GiveGun(gunName)
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local oldPos = hrp.CFrame
local oldCam = Camera.CFrame
local giver
for _, obj in ipairs(Workspace:GetDescendants()) do
if obj.Name == "TouchGiver" and obj:GetAttribute("ToolName") == gunName then
giver = obj; break
end
end
if not giver then return end
local giverPos = getGiverPosition(giver)
if not giverPos then return end
instantTP(CFrame.new(giverPos))
task.wait(1)
hrp.CFrame = oldPos
Camera.CFrame = oldCam
end
RS.RenderStepped:Connect(function()
if not PrisonAPI.TpWalkEnabled then return end
local char = LocalPlayer.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hum or not hrp then return end
local dir = hum.MoveDirection
if dir.Magnitude > 0 then
hrp.CFrame = hrp.CFrame + (dir * PrisonAPI.TpStepSize)
end
end)
do
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GiverPressed")
local grabbables = {}
local function is_owned(obj)
local a = obj.Parent
while a and a ~= Workspace do
if a:FindFirstChild("Humanoid") then return true end
if a.Name == "Backpack" then return true end
a = a.Parent
end
return false
end
local function get_part(model)
return model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
end
local function try_add(obj)
if not obj:IsA("Model") then return end
if obj:FindFirstChild("Humanoid") then return end
if obj.Parent ~= Workspace then return end
local part = get_part(obj)
if part and part.Size.Magnitude > 50 then return end
grabbables[obj] = true
end
for _, obj in ipairs(Workspace:GetChildren()) do try_add(obj) end
Workspace.ChildAdded:Connect(try_add)
Workspace.ChildRemoved:Connect(function(obj) grabbables[obj] = nil end)
local last_grab = 0
RS.Heartbeat:Connect(function()
if not PrisonAPI.AutoItems.Enabled then return end
local range = (PrisonAPI.AutoItems.GRAB_DISTANCE or 12)
local grab_dist_sq = range * range
local now = tick()
if now - last_grab < 0.05 then return end
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not root then return end
local my_pos = root.Position
for item,_ in pairs(grabbables) do
if not item.Parent then grabbables[item] = nil
elseif not is_owned(item) then
local part = get_part(item)
if part then
local d = (my_pos - part.Position)
local d2 = d.X*d.X + d.Y*d.Y + d.Z*d.Z
if d2 <= grab_dist_sq then
last_grab = now
pcall(remote.FireServer, remote, item)
end
end
end
end
end)
end
function PrisonAPI:StartTargetKill(plr)
if not plr or not plr:IsA("Player") then
return
end
if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or not plr.Character:FindFirstChildOfClass("Humanoid") or plr.Character.Humanoid.Health <= 0 then
return
end
if PrisonAPI.TargetKillAura.Connection then PrisonAPI.TargetKillAura.Connection:Disconnect() end
PrisonAPI.TargetKillAura.Target = plr
PrisonAPI.TargetKillAura.Enabled = true
PrisonAPI.TargetKillAura.Connection = RS.Heartbeat:Connect(function()
if not PrisonAPI.TargetKillAura.Enabled or not PrisonAPI.TargetKillAura.Target then return end
local myChar = LocalPlayer.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
local tChar = PrisonAPI.TargetKillAura.Target.Character
local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
if not myRoot or not tChar or not tRoot or not tHum or tHum.Health <= 0 then
PrisonAPI:StopTargetKill()
return
end
myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(0,-4,0), tRoot.Position)
pcall(function()
ReplicatedStorage.meleeEvent:FireServer(PrisonAPI.TargetKillAura.Target)
end)
end)
end
function PrisonAPI:StopTargetKill()
if PrisonAPI.TargetKillAura.Connection then PrisonAPI.TargetKillAura.Connection:Disconnect() end
PrisonAPI.TargetKillAura.Connection = nil
PrisonAPI.TargetKillAura.Target = nil
PrisonAPI.TargetKillAura.Enabled = false
end
function PrisonAPI:StartTargetArrest(playerName)
local targetPlr = Players:FindFirstChild(playerName)
if not targetPlr then
return
end
if not targetPlr.Character or not targetPlr.Character:FindFirstChild("HumanoidRootPart") then
return
end
if PrisonAPI.TargetArrest.Connection then PrisonAPI.TargetArrest.Connection:Disconnect() end
PrisonAPI.TargetArrest.Target = targetPlr
PrisonAPI.TargetArrest.Enabled = true
PrisonAPI.TargetArrest.Connection = RS.Heartbeat:Connect(function()
if not PrisonAPI.TargetArrest.Enabled or not PrisonAPI.TargetArrest.Target then return end
local myChar = LocalPlayer.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
if not myRoot then return end
local tChar = PrisonAPI.TargetArrest.Target.Character
if not tChar then
PrisonAPI:StopTargetArrest()
return
end
local tRoot = tChar:FindFirstChild("HumanoidRootPart")
local tHum = tChar:FindFirstChildOfClass("Humanoid")
if not tRoot or not tHum or tHum.Health <= 0 then
PrisonAPI:StopTargetArrest()
return
end
local offset = Vector3.new(math.random(-60,60)/100, 0, math.random(-60,60)/100)
myRoot.CFrame = CFrame.new(tRoot.Position + offset - Vector3.new(0,4,0), tRoot.Position)
if (myRoot.Position - tRoot.Position).Magnitude <= 14 then
pcall(function()
ReplicatedStorage.Remotes.ArrestPlayer:InvokeServer(PrisonAPI.TargetArrest.Target)
end)
end
end)
end
function PrisonAPI:StopTargetArrest()
if PrisonAPI.TargetArrest.Connection then PrisonAPI.TargetArrest.Connection:Disconnect() end
PrisonAPI.TargetArrest.Connection = nil
PrisonAPI.TargetArrest.Target = nil
PrisonAPI.TargetArrest.Enabled = false
end
function PrisonAPI.NoAntiJump()
local ch = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local s = ch:FindFirstChild("AntiJump")
if s and s:IsA("LocalScript") then pcall(function() s:Destroy() end) end
end
function PrisonAPI.EscapePrison() instantTP(CFrame.new(-927.7, 94.1, 2055.3)) end
function PrisonAPI.YardTP() instantTP(CFrame.new(791.5, 98, 2498.5)) end
function PrisonAPI.PoliceRoomTP() instantTP(CFrame.new(837.9, 99.8, 2267.3)) end
function PrisonAPI.CrimBaseTP() instantTP(CFrame.new(-927.7, 94.1, 2055.3)) end
function PrisonAPI.AmoryTP() instantTP(CFrame.new(831.171082, 99.9766693, 2244.44189, 0.999802053,0,-0.0198964812, 0,1,0, 0.0198964812,0,0.999802053)) end
function PrisonAPI.CafeteriaTP() instantTP(CFrame.new(916.811096, 99.9899521, 2307.43066, 0.999895096,-8.66796839e-08,0.014482338, 8.66391403e-08,1,3.42708861e-09, -0.014482338,-2.1719917e-09,0.999895096)) end
function PrisonAPI.VendingMachineTP() instantTP(CFrame.new(991.410889, 99.9899979, 2321.99438, -0.0407107919,1.13430545e-08,-0.999170959, -5.59741196e-08,1,1.3633108e-08, 0.999170959,5.64827296e-08,-0.0407107919)) end
function PrisonAPI.PrisonGateTP() instantTP(CFrame.new(497.42276, 98.0399323, 2216.06909, -0.0412250757,-1.19634265e-07,-0.999149859, -1.15097409e-09,1,-1.19688565e-07, 0.999149859,-3.78417475e-09,-0.0412250757)) end
function PrisonAPI.GuardTower1TP() instantTP(CFrame.new(709.189514, 122.039932, 2586.94189, 0.999998987,-5.93804783e-09,0.00144093169, 5.84527582e-09,1,6.43876135e-08, -0.00144093169,-6.43791225e-08,0.999998987)) end
function PrisonAPI.GuardTower2TP() instantTP(CFrame.new(757.935608, 122.039932, 2070.87012, 0.999729216,4.29960458e-08,-0.0232698675, -4.27907914e-08,1,9.31858857e-09, 0.0232698675,-8.32032931e-09,0.999729216)) end
function PrisonAPI.GasStationTP() instantTP(CFrame.new(-516.155884, 54.3937836, 1657.38525, 0.788011909,-1.05496625e-08,0.615659952, -7.40559969e-09,1,2.66143054e-08, -0.615659952,-2.55317225e-08,0.788011909)) end
function PrisonAPI.SecretRoomTP() instantTP(CFrame.new(694.221497, 99.9899979, 2354.8855, -0.00582610117,-1.05773928e-07,-0.999983013, -1.06532649e-08,1,-1.05713653e-07, 0.999983013,1.00371862e-08,-0.00582610117)) end
function PrisonAPI.BecomeCriminal()
local plr = LocalPlayer
local char = plr.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then
return
end
local root = char.HumanoidRootPart
local saved = { pos = root.CFrame, cam = Camera.CFrame }
instantTP(CFrame.new(-927.7, 94.1, 2055.3))
task.wait(0.5)
if plr.TeamColor and plr.TeamColor.Name == "Bright orange" then
pcall(function() ReplicatedStorage.Remote.TeamEvent:FireServer("Really red") end)
task.wait(1.2)
end
task.wait(0.3)
root.CFrame = saved.pos
Camera.CFrame = saved.cam
end
local AimbotConn = { main = nil, fov = nil }
local FOVCircle = nil
local function ensureFOV()
if FOVCircle then return end
FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false
end
local function UpdateFOVCircle()
ensureFOV()
FOVCircle.Visible = PrisonAPI.Aimbot.ShowFOV and PrisonAPI.Aimbot.Enabled
FOVCircle.Radius = PrisonAPI.Aimbot.FOV
FOVCircle.Color = PrisonAPI.Aimbot.FOVColor
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
end
local function IsTargetTeamValid(plr)
local teamName = plr.Team and plr.Team.Name or ""
if teamName == "Inmates" and PrisonAPI.Aimbot.TargetInmates then return true end
if teamName == "Guards" and PrisonAPI.Aimbot.TargetGuards then return true end
if teamName == "Criminals" and PrisonAPI.Aimbot.TargetCriminals then return true end
return false
end
local function IsValidTarget(plr)
if plr == LocalPlayer then return false end
if not IsTargetTeamValid(plr) then return false end
if PrisonAPI.Aimbot.TeamCheck and plr.Team == LocalPlayer.Team then return false end
local ch = plr.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 then return false end
return true
end
local function IsVisible(part)
if not PrisonAPI.Aimbot.WallCheck then return true end
local origin = Camera.CFrame.Position
local dir = (part.Position - origin)
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Blacklist
params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
local res = Workspace:Raycast(origin, dir, params)
if not res then return true end
return res.Instance:IsDescendantOf(part.Parent)
end
local function GetBestTarget()
local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
local closest, shortest = nil, PrisonAPI.Aimbot.FOV
for _,plr in ipairs(Players:GetPlayers()) do
if IsValidTarget(plr) then
local ch = plr.Character
local part = ch and (ch:FindFirstChild(PrisonAPI.Aimbot.TargetPart) or ch:FindFirstChild("Head"))
if part then
local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
if onScreen then
local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
if dist < shortest and IsVisible(part) then
shortest = dist; closest = part
end
end
end
end
end
return closest
end
local function AimAt(part)
if not part then return end
local cf = Camera.CFrame
local target = CFrame.new(cf.Position, part.Position)
local s = math.clamp(1 - PrisonAPI.Aimbot.Smoothness, 0.01, 1)
Camera.CFrame = cf:Lerp(target, s)
end
local function StartAimbot()
if AimbotConn.main then return end
AimbotConn.main = RS.RenderStepped:Connect(function()
if PrisonAPI.Aimbot.Enabled then
local t = GetBestTarget()
if t then AimAt(t) end
end
end)
AimbotConn.fov = RS.Heartbeat:Connect(UpdateFOVCircle)
end
local function StopAimbot()
if AimbotConn.main then AimbotConn.main:Disconnect() AimbotConn.main = nil end
if AimbotConn.fov then AimbotConn.fov:Disconnect() AimbotConn.fov = nil end
if FOVCircle then FOVCircle.Visible = false end
end
local function SetAimbotState(b) PrisonAPI.Aimbot.Enabled = b if b then StartAimbot() else StopAimbot() end end
local Settings = PrisonAPI.SilentAim
local GunRemotes = ReplicatedStorage:FindFirstChild("GunRemotes")
local ShootEvent = GunRemotes and GunRemotes:FindFirstChild("ShootEvent")
local Visuals = { Gui=nil, Circle=nil, Line=nil, Highlight=nil }
local CurrentTarget, LastShot, LastTargetUpdate = nil, 0, 0
local TARGET_UPDATE_INTERVAL = 0.05
local WallCheckParams = RaycastParams.new()
WallCheckParams.FilterType = Enum.RaycastFilterType.Exclude
WallCheckParams.IgnoreWater = true
WallCheckParams.RespectCanCollide = false
local function CreateSAVisuals()
if Visuals.Gui then return end
local sg = Instance.new("ScreenGui")
sg.Name = "Kali_SA_FOV"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
pcall(function() sg.Parent = game:GetService("CoreGui") end)
if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end
Visuals.Gui = sg
local c = Instance.new("Frame")
c.Name = "FOVCircle"
c.BackgroundTransparency = 1
c.AnchorPoint = Vector2.new(0.5,0.5)
c.Visible = false
c.Parent = sg
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Thickness = 1.5
stroke.Parent = c
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1,0)
corner.Parent = c
Visuals.Circle = c
local line = Instance.new("Frame")
line.Name = "TargetLine"
line.BackgroundColor3 = Color3.fromRGB(255,255,255)
line.BorderSizePixel = 0
line.AnchorPoint = Vector2.new(0.5,0.5)
line.Visible = false
line.Parent = sg
Visuals.Line = line
local hl = Instance.new("Highlight")
hl.Name = "SilentAimTargetHighlight"
hl.FillColor = Color3.fromRGB(255,80,80)
hl.FillTransparency = 0.45
hl.OutlineColor = Color3.fromRGB(255,255,255)
hl.OutlineTransparency = 0.15
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
hl.Enabled = false
Visuals.Highlight = hl
end
CreateSAVisuals()
RS.Heartbeat:Connect(function()
Visuals.Highlight.Enabled = false
if CurrentTarget and CurrentTarget.Character then
Visuals.Highlight.Adornee = CurrentTarget.Character
Visuals.Highlight.Enabled = Settings.ShowHighlight
end
end)
local PartMappings = {
["Torso"] = {"Torso","UpperTorso","LowerTorso"},
["LeftArm"] = {"Left Arm","LeftUpperArm","LeftLowerArm","LeftHand"},
["RightArm"]={"Right Arm","RightUpperArm","RightLowerArm","RightHand"},
["LeftLeg"] = {"Left Leg","LeftUpperLeg","LeftLowerLeg","LeftFoot"},
["RightLeg"]= {"Right Leg","RightUpperLeg","RightLowerLeg","RightFoot"},
}
local function GetBodyPart(character, partName)
if not character then return nil end
local p = character:FindFirstChild(partName)
if p then return p end
local map = PartMappings[partName]
if map then for _,n in ipairs(map) do local m = character:FindFirstChild(n) if m then return m end end end
return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
end
local function GetTargetPart(character)
if not character then return nil end
local partName = Settings.RandomAimParts and (Settings.AimPartsList and Settings.AimPartsList[math.random(1,#Settings.AimPartsList)] or "Head") or Settings.AimPart
return GetBodyPart(character, partName or "Head")
end
local function GetMissPosition(targetPos)
local x,y,z = math.random(-100,100),math.random(-100,100),math.random(-100,100)
local mag = math.sqrt(x*x + y*y + z*z)
if mag > 0 then x,y,z = x/mag,y/mag,z/mag end
return targetPos + Vector3.new(x*Settings.MissSpread, y*Settings.MissSpread, z*Settings.MissSpread)
end
local function IsPlayerDead(plr)
local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
return (not hum) or (hum.Health <= 0)
end
local function HasForceField(plr)
return plr.Character and plr.Character:FindFirstChildOfClass("ForceField") ~= nil
end
local function IsWallBetween(a, b, charB)
WallCheckParams.FilterDescendantsInstances = {LocalPlayer.Character}
local dir = b - a
local res = Workspace:Raycast(a, dir.Unit * dir.Magnitude, WallCheckParams)
if not res then return false end
if charB and res.Instance:IsDescendantOf(charB) then return false end
if res.Instance.Transparency >= 0.8 or not res.Instance.CanCollide then return false end
return true
end
local function ShouldSATarget(plr)
local teamName = (plr.Team and plr.Team.Name) or ""
if teamName == "Bright orange" then return Settings.TargetInmates end
if teamName == "Bright blue" then return Settings.TargetGuards end
if teamName == "Bright red" then return Settings.TargetCriminals end
return Settings.TargetCriminals
end
local function IsSATargetQuick(plr)
if not plr or not plr.Character then return false end
if not GetTargetPart(plr.Character) then return false end
if Settings.DeathCheck and IsPlayerDead(plr) then return false end
if Settings.ForceFieldCheck and HasForceField(plr) then return false end
if not ShouldSATarget(plr) then return false end
return true
end
local function IsSATargetFull(plr)
if not IsSATargetQuick(plr) then return false end
if Settings.WallCheck then
local myHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
local targetPart = GetTargetPart(plr.Character)
if myHead and targetPart then
if IsWallBetween(myHead.Position, targetPart.Position, plr.Character) then
return false
end
end
end
return true
end
local function SAHitChance()
if Settings.HitChance >= 100 then return true end
if Settings.HitChance <= 0 then return false end
return math.random(1,100) <= Settings.HitChance
end
local function GetClosestTarget()
local mousePos = UIS:GetMouseLocation()
local candidates = {}
for _,plr in ipairs(Players:GetPlayers()) do
if IsSATargetQuick(plr) then
local tp = GetTargetPart(plr.Character)
if tp then
local sp, on = Camera:WorldToViewportPoint(tp.Position)
if on then
local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
if d < Settings.FOV then
table.insert(candidates, {player=plr, dist=d})
end
end
end
end
end
table.sort(candidates, function(a,b) return a.dist < b.dist end)
for _,cand in ipairs(candidates) do
if IsSATargetFull(cand.player) then return cand.player end
end
return nil
end
local ActiveSounds = {}
local function PlayGunSound(g)
if not g then return end
local h = g:FindFirstChild("Handle")
if not h then return end
local s = h:FindFirstChild("ShootSound")
if s then
local key = g:GetFullName().."_shoot"
local snd = ActiveSounds[key]
if not snd or not snd.Parent then snd = s:Clone(); snd.Parent = h; ActiveSounds[key] = snd end
snd:Play()
end
end
local function CreateTracer(startPos, endPos, gun)
local dist = (endPos - startPos).Magnitude
local p = Instance.new("Part")
p.Anchored = true
p.CanCollide = false
p.CastShadow = false
p.Material = Enum.Material.Neon
p.BrickColor = BrickColor.Yellow()
p.Size = Vector3.new(0.2, 0.2, dist)
p.CFrame = CFrame.new(endPos, startPos) * CFrame.new(0, 0, -dist/2)
p.Parent = Workspace
game:GetService("TweenService"):Create(p, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
game:GetService("Debris"):AddItem(p, 0.2)
end
local function GetEquippedGun()
local ch = LocalPlayer.Character
if not ch then return nil end
for _,tool in ipairs(ch:GetChildren()) do
if tool:IsA("Tool") and tool:GetAttribute("ToolType") == "Gun" then
return tool
end
end
return nil
end
local CachedBulletsLabel = nil
local function UpdateAmmoGUI(ammo, maxAmmo)
pcall(function()
if not CachedBulletsLabel or not CachedBulletsLabel.Parent then
local pg = LocalPlayer:FindFirstChild("PlayerGui")
local home = pg and pg:FindFirstChild("Home")
local hud = home and home:FindFirstChild("hud")
local gunF = hud and hud:FindFirstChild("BottomRightFrame") and hud.BottomRightFrame:FindFirstChild("GunFrame")
CachedBulletsLabel = gunF and gunF:FindFirstChild("BulletsLabel")
end
if CachedBulletsLabel then
CachedBulletsLabel.Text = tostring(ammo) .. "/" .. tostring(maxAmmo or 0)
end
end)
end
local function FireSilentAim(gun)
if not ShootEvent then return false end
local ammo = gun:GetAttribute("Local_CurrentAmmo") or 0
if ammo <= 0 then return false end
local fireRate = gun:GetAttribute("FireRate") or 0.12
local now = tick()
if now - LastShot < fireRate then return false end
local char = LocalPlayer.Character
local myHead = char and char:FindFirstChild("Head")
if not myHead then return false end
local hitPos, hitPart
CurrentTarget = GetClosestTarget()
if CurrentTarget and CurrentTarget.Character and IsSATargetFull(CurrentTarget) then
local targetPart = GetTargetPart(CurrentTarget.Character)
if targetPart then
if SAHitChance() then
hitPos = targetPart.Position; hitPart = targetPart
else
hitPos = GetMissPosition(targetPart.Position)
hitPart = nil
end
end
end
if not hitPos then
local m = UIS:GetMouseLocation()
local ray = Camera:ViewportPointToRay(m.X, m.Y)
WallCheckParams.FilterDescendantsInstances = {char}
local res = Workspace:Raycast(ray.Origin, ray.Direction * 1000, WallCheckParams)
if res then
hitPos = res.Position; hitPart = res.Instance
else
hitPos = ray.Origin + (ray.Direction * 1000)
end
end
gun:SetAttribute("Local_IsShooting", true)
local muzzle = gun:FindFirstChild("Muzzle")
local visualStart = (muzzle and muzzle.Position) or myHead.Position
local projectileCount = gun:GetAttribute("ProjectileCount") or 1
local bullets = table.create(projectileCount)
for i=1,projectileCount do bullets[i] = { myHead.Position, hitPos, hitPart } end
LastShot = now
PlayGunSound(gun)
for i=1,projectileCount do CreateTracer(visualStart, hitPos, gun) end
ShootEvent:FireServer(bullets)
local newAmmo = ammo - 1
gun:SetAttribute("Local_CurrentAmmo", newAmmo)
UpdateAmmoGUI(newAmmo, gun:GetAttribute("MaxAmmo") or 0)
return true
end
local CAS = game:GetService("ContextActionService")
local IsShooting = false
local function HandleShoot(actionName, inputState)
if actionName ~= "Kali_SilentAimShoot" then return Enum.ContextActionResult.Pass end
if not Settings.Enabled then return Enum.ContextActionResult.Pass end
if inputState == Enum.UserInputState.Begin then
local g = GetEquippedGun()
if not g then return Enum.ContextActionResult.Pass end
if not g:GetAttribute("AutoFire") then
FireSilentAim(g)
else
IsShooting = true
end
return Enum.ContextActionResult.Sink
elseif inputState == Enum.UserInputState.End then
IsShooting = false
return Enum.ContextActionResult.Sink
end
return Enum.ContextActionResult.Pass
end
pcall(function()
CAS:BindActionAtPriority("Kali_SilentAimShoot", HandleShoot, false, 3000, Enum.UserInputType.MouseButton1)
end)
RS.RenderStepped:Connect(function()
local mousePos = UIS:GetMouseLocation()
if Visuals.Circle then
Visuals.Circle.Visible = Settings.ShowFOV and Settings.Enabled
if Visuals.Circle.Visible then
Visuals.Circle.Size = UDim2.new(0, Settings.FOV*2, 0, Settings.FOV*2)
Visuals.Circle.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
end
end
local now = tick()
if (now - LastTargetUpdate) >= TARGET_UPDATE_INTERVAL then
LastTargetUpdate = now
CurrentTarget = GetClosestTarget()
end
if Visuals.Line then
local show = Settings.ShowTargetLine and CurrentTarget and CurrentTarget.Character
Visuals.Line.Visible = show
if show then
local tp = GetTargetPart(CurrentTarget.Character)
if tp then
local sp, on = Camera:WorldToViewportPoint(tp.Position)
if on then
local startPos = mousePos
local endPos = Vector2.new(sp.X, sp.Y)
local distance = (endPos - startPos).Magnitude
local center = (startPos + endPos)/2
local rot = math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)
Visuals.Line.Size = UDim2.new(0, distance, 0, 2)
Visuals.Line.Position = UDim2.new(0, center.X, 0, center.Y)
Visuals.Line.Rotation = math.deg(rot)
else
Visuals.Line.Visible = false
end
end
end
end
end)
RS.Heartbeat:Connect(function()
if not IsShooting then return end
if not Settings.Enabled then return end
local g = GetEquippedGun()
if g and g:GetAttribute("AutoFire") then
FireSilentAim(g)
end
end)
LocalPlayer.CharacterAdded:Connect(function()
CachedBulletsLabel = nil; CurrentTarget = nil; IsShooting = false
for _,s in pairs(ActiveSounds) do if s and s.Parent then s:Destroy() end end
table.clear(ActiveSounds)
end)
local TEAM_COLORS = { Inmates = Color3.fromRGB(255,138,0), Guards = Color3.fromRGB(0,119,255), Criminals = Color3.fromRGB(255,51,51) }
local function createBillboardDot(character, color)
local head = character:FindFirstChild("Head"); if not head then return end
local oldGui = head:FindFirstChild("HeadDotGui"); if oldGui then oldGui:Destroy() end
local billboard = Instance.new("BillboardGui")
billboard.Name = "HeadDotGui"
billboard.Adornee = head
billboard.Size = UDim2.new(0, PrisonAPI.Dots.DotSize, 0, PrisonAPI.Dots.DotSize)
billboard.StudsOffset = Vector3.new(0, PrisonAPI.Dots.OffsetY, 0)
billboard.AlwaysOnTop = true
billboard.Parent = head
local outline = Instance.new("Frame")
outline.Size = UDim2.new(1,0,1,0)
outline.BackgroundColor3 = PrisonAPI.Dots.OutlineColor
outline.BackgroundTransparency = PrisonAPI.Dots.OutlineTrans
outline.BorderSizePixel = 0
outline.Parent = billboard
local fill = Instance.new("Frame")
fill.Size = UDim2.new(0.6,0,0.6,0)
fill.AnchorPoint = Vector2.new(0.5,0.5)
fill.Position = UDim2.new(0.5,0,0.5,0)
fill.BackgroundColor3 = color
fill.BackgroundTransparency = PrisonAPI.Dots.FillTrans
fill.BorderSizePixel = 0
fill.Parent = billboard
end
local function updateDot(plr)
if plr == LocalPlayer then return end
if not plr.Character or not plr.Team then return end
local col = TEAM_COLORS[plr.Team.Name]; if not col then return end
if PrisonAPI.Dots.Enabled then
createBillboardDot(plr.Character, col)
else
local head = plr.Character:FindFirstChild("Head")
if head then local old = head:FindFirstChild("HeadDotGui"); if old then old:Destroy() end end
end
end
for _,p in ipairs(Players:GetPlayers()) do
p.CharacterAdded:Connect(function() task.wait(0.2) updateDot(p) end)
end
RS.RenderStepped:Connect(function()
for _,p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then updateDot(p) end
end
end)
local Chams = { Enabled = false, FillTrans = 0.5, OutlineTrans = 0 }
local function removeHighlight(char) local h = char:FindFirstChild("TeamESP"); if h then h:Destroy() end end
local function createHighlight(char, outlineColor)
removeHighlight(char)
local h = Instance.new("Highlight")
h.Name = "TeamESP"
h.Adornee = char
h.FillColor = Color3.fromRGB(0,0,0)
h.OutlineColor = outlineColor
h.FillTransparency = Chams.FillTrans
h.OutlineTransparency = Chams.OutlineTrans
h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
h.Enabled = true
h.Parent = char
end
RS.RenderStepped:Connect(function()
for _,plr in ipairs(Players:GetPlayers()) do
local ch = plr.Character
if not ch then continue end
if plr == LocalPlayer then removeHighlight(ch) continue end
local hl = ch:FindFirstChild("TeamESP")
if not Chams.Enabled then if hl then hl.Enabled=false end continue end
if not plr.Team or not plr.Team.TeamColor then if hl then hl.Enabled=false end continue end
local teamColor = plr.Team.TeamColor.Color
if not hl then createHighlight(ch, teamColor)
else
hl.OutlineColor = teamColor
hl.FillColor = Color3.fromRGB(0,0,0)
hl.FillTransparency = Chams.FillTrans
hl.OutlineTransparency = Chams.OutlineTrans
hl.Enabled = true
end
end
end)
local originalProperties = {}
local function restoreHitboxes()
for plr, props in pairs(originalProperties) do
local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
if root then
root.Size = props.Size
pcall(function() root.Shape = props.Shape end)
root.Transparency = props.Transparency
root.CanCollide = props.CanCollide
root.BrickColor = props.BrickColor
end
end
end
RS.Stepped:Connect(function()
if not PrisonAPI.Hitbox.Enabled then
restoreHitboxes(); return
end
for _,plr in ipairs(Players:GetPlayers()) do
if plr == LocalPlayer then continue end
local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
if root then
if not originalProperties[plr] then
originalProperties[plr] = {
Size = root.Size,
Shape = (root.Shape or Enum.PartType.Block),
Transparency = root.Transparency,
CanCollide = root.CanCollide,
BrickColor = root.BrickColor
}
end
root.Size = PrisonAPI.Hitbox.HitboxSize
pcall(function() root.Shape = PrisonAPI.Hitbox.PartType end)
root.Transparency = PrisonAPI.Hitbox.Transparency
root.CanCollide = false
root.Material = Enum.Material[PrisonAPI.Hitbox.Material] or Enum.Material.Neon
end
end
end)
Players.PlayerRemoving:Connect(function(plr) originalProperties[plr] = nil end)
do
local cc = ReplicatedStorage:FindFirstChild("Scripts") and ReplicatedStorage.Scripts:FindFirstChild("CharacterCollision")
if cc then
cc:Destroy()
local Head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
if Head then
local signal = Head:GetPropertyChangedSignal("CanCollide")
local connections = getconnections and getconnections(signal) or {}
for _,conn in ipairs(connections) do pcall(function() if conn.Disable then conn:Disable() end end) end
end
end
end
getgenv().triggerbot = {
Settings = {
isEnabled = false,
clickDelay = 0.01,
lastClickTime = 0,
targetInmates = true,
targetGuards = true,
targetCriminals = true,
targetNeutral = false
},
Connections = {},
load = function()
for _,c in pairs(getgenv().triggerbot.Connections) do pcall(function() c:Disconnect() end) end
getgenv().triggerbot.Connections = {}
local mouse = LocalPlayer:GetMouse()
local function simulateClick()
if typeof(mouse1press) == "function" and typeof(mouse1release) == "function" then
mouse1press() task.wait() mouse1release()
else
local vp = Camera.ViewportSize
local cx, cy = vp.X/2, vp.Y/2
VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 0)
task.wait()
VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
end
end
local function shouldTarget(plr)
if plr == LocalPlayer then return false end
local teamName = plr.Team and plr.Team.Name or "Neutral"
if teamName == "Inmates" then return getgenv().triggerbot.Settings.targetInmates end
if teamName == "Guards" then return getgenv().triggerbot.Settings.targetGuards end
if teamName == "Criminals" then return getgenv().triggerbot.Settings.targetCriminals end
if teamName == "Neutral" then return getgenv().triggerbot.Settings.targetNeutral end
return false
end
local function isHoveringValidTarget()
local target = mouse.Target
if not target then return false end
local model = target:FindFirstAncestorOfClass("Model")
if not model then return false end
local plr = Players:GetPlayerFromCharacter(model)
if not plr then return false end
local hum = model:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 then return false end
return shouldTarget(plr)
end
table.insert(getgenv().triggerbot.Connections, mouse.Move:Connect(function()
if not getgenv().triggerbot.Settings.isEnabled then return end
if isHoveringValidTarget() then
local now = tick()
local delay = getgenv().triggerbot.Settings.clickDelay or 0.01
if now - getgenv().triggerbot.Settings.lastClickTime >= delay then
simulateClick()
getgenv().triggerbot.Settings.lastClickTime = now
end
end
end))
end
}
sections.weapon_giver:CreateButton("Get AK-47", function() GiveGun("AK-47") end)
sections.weapon_giver:CreateButton("Get Remington 870", function() GiveGun("Remington 870") end)
sections.weapon_giver:CreateButton("Get M4A1", function() GiveGun("M4A1") end)
sections.weapon_giver:CreateButton("Get MP5", function() GiveGun("MP5") end)
sections.weapon_mods:CreateButton("Auto Fire", function()
local namecall; namecall = hookmetamethod(game, "__namecall", function(self, ...)
local method = getnamecallmethod()
if method == "GetAttributes" then
local result = namecall(self, ...)
result.AutoFire = true
return result
end
return namecall(self, ...)
end)
end)
sections.weapon_mods:CreateButton("Rapid Fire", function()
local namecall; namecall = hookmetamethod(game, "__namecall", function(self, ...)
local method = getnamecallmethod()
if method == "GetAttributes" then
local result = namecall(self, ...)
result.FireRate = 0
return result
end
return namecall(self, ...)
end)
end)
sections.weapon_mods:CreateButton("Infinite Range", function()
local namecall; namecall = hookmetamethod(game, "__namecall", function(self, ...)
local method = getnamecallmethod()
if method == "GetAttributes" then
local result = namecall(self, ...)
result.Range = 999999999
return result
end
return namecall(self, ...)
end)
end)
sections.weapon_mods:CreateButton("Auto Fire", function()
task.spawn(function()
while task.wait(0.1) do
for _,v in ipairs(LocalPlayer.Backpack:GetChildren()) do
if v:GetAttribute("FireRate") ~= nil then
v:SetAttribute("AutoFire", true)
end
end
end
end)
end)
sections.weapon_mods:CreateButton("Rapid Fire", function()
task.spawn(function()
while task.wait(0.1) do
for _,v in ipairs(LocalPlayer.Backpack:GetChildren()) do
if v:GetAttribute("FireRate") ~= nil then
v:SetAttribute("FireRate", 0.02)
end
end
end
end)
end)
sections.weapon_mods:CreateButton("No Spread", function()
task.spawn(function()
while task.wait(0.1) do
for _,v in ipairs(LocalPlayer.Backpack:GetChildren()) do
if v:GetAttribute("FireRate") ~= nil then
v:SetAttribute("SpreadRadius", 0)
end
end
end
end)
end)
sections.weapon_mods:CreateButton("Mod All Guns", function()
task.spawn(function()
while task.wait(0.1) do
for _,v in ipairs(LocalPlayer.Backpack:GetChildren()) do
if v:GetAttribute("FireRate") ~= nil then
v:SetAttribute("FireRate", 0.02)
v:SetAttribute("AutoFire", true)
v:SetAttribute("SpreadRadius", 0)
end
end
end
end)
end)
sections.weapon_mods:CreateToggle("Change Tools Color", false, function(val)
PrisonAPI.Guns.ChangeGunColor = val
if not val then return end
task.spawn(function()
while PrisonAPI.Guns.ChangeGunColor do
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local tool = char:FindFirstChildOfClass("Tool")
if tool then
for _,v in ipairs(tool:GetDescendants()) do
if v:IsA("BasePart") or v:IsA("MeshPart") then
v.Material = Enum.Material.ForceField
v.Color = PrisonAPI.Guns.SelectedColor or Color3.fromRGB(255,0,0)
v.Reflectance = 0
if v:IsA("MeshPart") then v.TextureID = "" end
end
if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
if v:IsA("SpecialMesh") then v.TextureId = "" end
end
end
task.wait(0.25)
end
end)
end)
sections.weapon_mods:CreateDropdown("Tool Color", {
"Red","Green","Blue","Yellow","Cyan","Magenta","Pink","Orange","Purple",
"White","Black","Gray","Lime","Teal","Brown","Gold","Silver","Hot Pink","Neon Green"
}, function(choice)
local map = {
Red=Color3.fromRGB(255,0,0), Green=Color3.fromRGB(0,255,0), Blue=Color3.fromRGB(0,100,255),
Yellow=Color3.fromRGB(255,255,0), Cyan=Color3.fromRGB(0,255,255), Magenta=Color3.fromRGB(255,0,255),
Pink=Color3.fromRGB(255,105,180), Orange=Color3.fromRGB(255,140,50), Purple=Color3.fromRGB(138,43,226),
White=Color3.fromRGB(255,255,255), Black=Color3.fromRGB(20,20,20), Gray=Color3.fromRGB(150,150,150),
Lime=Color3.fromRGB(50,255,50), Teal=Color3.fromRGB(0,255,255), Brown=Color3.fromRGB(139,69,19),
Gold=Color3.fromRGB(255,215,0), Silver=Color3.fromRGB(220,220,220),
["Hot Pink"]=Color3.fromRGB(255,0,190), ["Neon Green"]=Color3.fromRGB(57,255,20)
}
PrisonAPI.Guns.SelectedColor = map[choice] or Color3.fromRGB(255,215,0)
end, "Red", false)
sections.aimbot:CreateToggle("Aimbot", false, function(v) SetAimbotState(v) end)
sections.aimbot:CreateToggle("Visibility Check", false, function(v) PrisonAPI.Aimbot.WallCheck = v end)
sections.aimbot:CreateSlider("Smoothness", 0.1, 1, PrisonAPI.Aimbot.Smoothness, false, function(v)
PrisonAPI.Aimbot.Smoothness = v
end)
sections.aimbot:CreateDropdown("Target Part", {"Head","HumanoidRootPart","UpperTorso","LowerTorso"}, function(v)
PrisonAPI.Aimbot.TargetPart = v
end, "Head", false)
sections.aimbot:CreateToggle("FOV Circle", false, function(v) PrisonAPI.Aimbot.ShowFOV = v end)
sections.aimbot:CreateSlider("FOV Radius", 50, 600, PrisonAPI.Aimbot.FOV, true, function(v)
PrisonAPI.Aimbot.FOV = v
end)
sections.aimbot:CreateToggle("Target Inmates", false, function(v) PrisonAPI.Aimbot.TargetInmates = v end)
sections.aimbot:CreateToggle("Target Guards", false, function(v) PrisonAPI.Aimbot.TargetGuards = v end)
sections.aimbot:CreateToggle("Target Criminals", false, function(v) PrisonAPI.Aimbot.TargetCriminals = v end)
sections.hitbox:CreateToggle("Hitbox Expander", false, function(v) PrisonAPI.Hitbox.Enabled = v end)
sections.hitbox:CreateSlider("Hitbox Size", 8, 25, 15, true, function(v)
PrisonAPI.Hitbox.HitboxSize = Vector3.new(v,v,v)
end)
sections.hitbox:CreateSlider("Hitbox Transparency", 0, 1, 0.7, false, function(v)
PrisonAPI.Hitbox.Transparency = v
end)
sections.hitbox:CreateDropdown("Material", {"Plastic","SmoothPlastic","Neon","Metal","Wood","Glass","ForceField"}, function(v)
PrisonAPI.Hitbox.Material = v
end, "Neon", false)
sections.hitbox:CreateDropdown("Part Type", {"Ball","Block"}, function(v)
PrisonAPI.Hitbox.PartType = v
end, "Ball", false)
sections.target_tools:CreateToggle("Auto Attack (Melee)", false, function(v)
PrisonAPI.AutoAttack = v
task.spawn(function()
local function getClosestPlayer()
local closestdist, closestplr = math.huge, nil
for _,p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer then
pcall(function()
local dist = LocalPlayer:DistanceFromCharacter(p.Character.PrimaryPart.Position)
if dist < 6 and dist < closestdist then closestdist, closestplr = dist, p end
end)
end
end
return closestplr
end
while PrisonAPI.AutoAttack do
local plr = getClosestPlayer()
if plr then pcall(function() ReplicatedStorage.meleeEvent:FireServer(plr) end) end
task.wait()
end
end)
end)
sections.silent:CreateToggle("Silent Aim", false, function(v) PrisonAPI.SilentAim.Enabled = v end)
sections.silent:CreateToggle("Wall Check", false, function(v) PrisonAPI.SilentAim.WallCheck = v end)
sections.silent:CreateToggle("Death Check", false, function(v) PrisonAPI.SilentAim.DeathCheck = v end)
sections.silent:CreateToggle("Forcefield Check", false, function(v) PrisonAPI.SilentAim.ForceFieldCheck = v end)
sections.silent:CreateDropdown("Target Part", {"Head","Torso","HumanoidRootPart","LeftArm","RightArm","LeftLeg","RightLeg"}, function(v)
PrisonAPI.SilentAim.AimPart = v
end, "Head", false)
sections.silent:CreateToggle("Random Aim Parts", false, function(v) PrisonAPI.SilentAim.RandomAimParts = v end)
sections.silent:CreateToggle("Show Target Line", false, function(v) PrisonAPI.SilentAim.ShowTargetLine = v end)
sections.silent:CreateSlider("Hit Chance", 0, 100, 100, true, function(v) PrisonAPI.SilentAim.HitChance = v end)
sections.silent:CreateSlider("Miss Spread", 0, 10, 5, true, function(v) PrisonAPI.SilentAim.MissSpread = v end)
sections.silent:CreateToggle("FOV Circle", false, function(v) PrisonAPI.SilentAim.ShowFOV = v end)
sections.silent:CreateSlider("FOV Size", 50, 500, 100, true, function(v) PrisonAPI.SilentAim.FOV = v end)
sections.silent:CreateToggle("Target Inmates", false, function(v) PrisonAPI.SilentAim.TargetInmates = v end)
sections.silent:CreateToggle("Target Guards", false, function(v) PrisonAPI.SilentAim.TargetGuards = v end)
sections.silent:CreateToggle("Target Criminals", false, function(v) PrisonAPI.SilentAim.TargetCriminals = v end)
sections.trigger:CreateButton("Load Trigger Bot", function()
getgenv().triggerbot.load()
end)
sections.trigger:CreateToggle("TriggerBot Enabled", false, function(v)
getgenv().triggerbot.Settings.isEnabled = v
end)
sections.trigger:CreateToggle("Target Inmates", true, function(v)
getgenv().triggerbot.Settings.targetInmates = v
end)
sections.trigger:CreateToggle("Target Guards", true, function(v)
getgenv().triggerbot.Settings.targetGuards = v
end)
sections.trigger:CreateToggle("Target Criminals", true, function(v)
getgenv().triggerbot.Settings.targetCriminals = v
end)
local AdvESP = {
Enabled = false,
MaxDistance = 2500,
Boxes = true,
BoxColor = Color3.fromRGB(255, 255, 255),
BoxThickness = 1,
BoxFilled = false,
BoxFillTrans = 0.5,
Names = true,
NameColor = Color3.fromRGB(255, 255, 255),
NameSize = 13,
Distance = true,
DistanceColor = Color3.fromRGB(255, 255, 255),
Tracers = true,
TracerColor = Color3.fromRGB(255, 255, 255),
TracerThickness= 1,
TracerOrigin = "Bottom",
HeadDot = false,
HeadDotColor = Color3.fromRGB(255, 255, 255),
HeadDotSize = 4,
HeadDotFilled = true,
TeamCheck = false,
VisibilityCheck= false
}
local AdvESP_Objects = {}
local hasDrawing = pcall(function() return Drawing and Drawing.new end)
local function AdvESP_CreateForPlayer(plr)
if plr == LocalPlayer then return end
if not hasDrawing then return end
if AdvESP_Objects[plr] then return end
local d = {}
d.box = Drawing.new("Square"); d.box.Visible = false
d.box.Thickness = AdvESP.BoxThickness
d.box.Color = AdvESP.BoxColor
d.box.Filled = false
d.boxFill = Drawing.new("Square"); d.boxFill.Visible = false
d.boxFill.Filled = true
d.boxFill.Color = AdvESP.BoxColor
d.boxFill.Transparency = AdvESP.BoxFillTrans
d.name = Drawing.new("Text"); d.name.Visible = false
d.name.Center = true
d.name.Outline = true
d.name.Color = AdvESP.NameColor
d.name.Size = AdvESP.NameSize
d.distance = Drawing.new("Text"); d.distance.Visible = false
d.distance.Center = true
d.distance.Outline = true
d.distance.Color = AdvESP.DistanceColor
d.distance.Size = 12
d.tracer = Drawing.new("Line"); d.tracer.Visible = false
d.tracer.Thickness = AdvESP.TracerThickness
d.tracer.Color = AdvESP.TracerColor
d.headDot = Drawing.new("Circle"); d.headDot.Visible = false
d.headDot.Color = AdvESP.HeadDotColor
d.headDot.Radius = AdvESP.HeadDotSize
d.headDot.Filled = AdvESP.HeadDotFilled
d.headDot.Thickness = 1
AdvESP_Objects[plr] = d
end
local function AdvESP_RemoveForPlayer(plr)
local d = AdvESP_Objects[plr]
if not d then return end
for _,obj in pairs(d) do
if obj and obj.Remove then pcall(function() obj:Remove() end) end
end
AdvESP_Objects[plr] = nil
end
local function AdvESP_IsVisible(character)
if not AdvESP.VisibilityCheck then return true end
local head = character:FindFirstChild("Head") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
if not head then return true end
local origin = Camera.CFrame.Position
local direction = (head.Position - origin)
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Blacklist
params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
local res = workspace:Raycast(origin, direction.Unit * direction.Magnitude, params)
if not res then return true end
if res.Instance:IsDescendantOf(character) then return true end
if res.Instance.Transparency >= 0.8 or not res.Instance.CanCollide then
return true
end
return false
end
local function AdvESP_ShouldDrawFor(plr)
if plr == LocalPlayer then return false end
if AdvESP.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
return false
end
local ch = plr.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 then return false end
return true
end
local function AdvESP_Update()
if not AdvESP.Enabled or not hasDrawing then
for _,d in pairs(AdvESP_Objects) do
d.box.Visible = false; d.boxFill.Visible = false
d.name.Visible = false; d.distance.Visible = false
d.tracer.Visible = false; d.headDot.Visible = false
end
return
end
local myChar = LocalPlayer.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart") or myChar and myChar:FindFirstChild("Torso") or myChar and myChar:FindFirstChild("Head")
local myPos = myRoot and myRoot.Position
local vp = Camera.ViewportSize
local centerX, centerY = vp.X/2, vp.Y/2
local mouseLoc = UIS:GetMouseLocation()
for plr,d in pairs(AdvESP_Objects) do
local ch = plr.Character
if not ch or not AdvESP_ShouldDrawFor(plr) or not myPos then
d.box.Visible = false; d.boxFill.Visible = false
d.name.Visible = false; d.distance.Visible = false
d.tracer.Visible = false; d.headDot.Visible = false
continue
end
local rootPart = ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso") or ch:FindFirstChild("Head")
local head = ch:FindFirstChild("Head") or ch:FindFirstChild("Torso") or rootPart
if not rootPart or not head then
d.box.Visible = false; d.boxFill.Visible = false
d.name.Visible = false; d.distance.Visible = false
d.tracer.Visible = false; d.headDot.Visible = false
continue
end
local dist3D = (rootPart.Position - myPos).Magnitude
if dist3D > (AdvESP.MaxDistance or 2500) then
d.box.Visible = false; d.boxFill.Visible = false
d.name.Visible = false; d.distance.Visible = false
d.tracer.Visible = false; d.headDot.Visible = false
continue
end
if AdvESP.VisibilityCheck and not AdvESP_IsVisible(ch) then
d.box.Visible = false; d.boxFill.Visible = false
d.name.Visible = false; d.distance.Visible = false
d.tracer.Visible = false; d.headDot.Visible = false
continue
end
local headPos, headOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
local rootPos, rootOn = Camera:WorldToViewportPoint(rootPart.Position)
if not headOn or not rootOn then
d.box.Visible = false; d.boxFill.Visible = false
d.name.Visible = false; d.distance.Visible = false
d.tracer.Visible = false; d.headDot.Visible = false
continue
end
local boxHeight = math.abs(headPos.Y - legPos.Y)
local boxWidth = boxHeight / 1.8
local boxX = rootPos.X - boxWidth/2
local boxY = headPos.Y
if AdvESP.Boxes then
d.box.Size = Vector2.new(boxWidth, boxHeight)
d.box.Position = Vector2.new(boxX, boxY)
d.box.Color = AdvESP.BoxColor
d.box.Thickness = AdvESP.BoxThickness
d.box.Visible = true
if AdvESP.BoxFilled then
d.boxFill.Size = Vector2.new(boxWidth, boxHeight)
d.boxFill.Position = Vector2.new(boxX, boxY)
d.boxFill.Color = AdvESP.BoxColor
d.boxFill.Transparency = AdvESP.BoxFillTrans
d.boxFill.Visible = true
else
d.boxFill.Visible = false
end
else
d.box.Visible = false
d.boxFill.Visible = false
end
if AdvESP.Names then
d.name.Text = plr.DisplayName or plr.Name
d.name.Position = Vector2.new(rootPos.X, headPos.Y - 14)
d.name.Color = AdvESP.NameColor
d.name.Size = AdvESP.NameSize
d.name.Visible = true
else
d.name.Visible = false
end
if AdvESP.Distance then
d.distance.Text = string.format("[%dm]", math.floor(dist3D))
d.distance.Position = Vector2.new(rootPos.X, legPos.Y + 2)
d.distance.Color = AdvESP.DistanceColor
d.distance.Visible = true
else
d.distance.Visible = false
end
if AdvESP.Tracers then
local from
if AdvESP.TracerOrigin == "Bottom" then
from = Vector2.new(centerX, vp.Y)
elseif AdvESP.TracerOrigin == "Top" then
from = Vector2.new(centerX, 0)
elseif AdvESP.TracerOrigin == "Center" then
from = Vector2.new(centerX, centerY)
elseif AdvESP.TracerOrigin == "Mouse" then
from = Vector2.new(mouseLoc.X, mouseLoc.Y)
else
from = Vector2.new(centerX, vp.Y)
end
d.tracer.From = from
d.tracer.To = Vector2.new(rootPos.X, legPos.Y)
d.tracer.Color = AdvESP.TracerColor
d.tracer.Thickness = AdvESP.TracerThickness
d.tracer.Visible = true
else
d.tracer.Visible = false
end
if AdvESP.HeadDot then
local hsp, hOn = Camera:WorldToViewportPoint(head.Position)
if hOn then
d.headDot.Position = Vector2.new(hsp.X, hsp.Y)
d.headDot.Color = AdvESP.HeadDotColor
d.headDot.Radius = AdvESP.HeadDotSize
d.headDot.Filled = AdvESP.HeadDotFilled
d.headDot.Visible = true
else
d.headDot.Visible = false
end
else
d.headDot.Visible = false
end
end
end
for _,p in ipairs(Players:GetPlayers()) do AdvESP_CreateForPlayer(p) end
Players.PlayerAdded:Connect(function(p) AdvESP_CreateForPlayer(p) end)
Players.PlayerRemoving:Connect(function(p) AdvESP_RemoveForPlayer(p) end)
RS.RenderStepped:Connect(function()
AdvESP_Update()
end)
local hbar = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stratxgy/Aura/refs/heads/main/Modules/ESP/hbar.lua"))()
sections.healthbar:CreateToggle("Health Bar", false, function(v)
getgenv().hbar = getgenv().hbar or {}
getgenv().hbar.enabled = v
end)
sections.healthbar:CreateButton("Show All Health", function()
local function ApplyESP(v)
if v.Character and v.Character:FindFirstChildOfClass('Humanoid') then
local hum = v.Character:FindFirstChildOfClass('Humanoid')
hum.NameDisplayDistance = 9e9
hum.NameOcclusion = Enum.NameOcclusion.NoOcclusion
hum.HealthDisplayDistance = 9e9
hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
hum.Health = hum.Health
end
end
for _,v in ipairs(Players:GetPlayers()) do
ApplyESP(v)
v.CharacterAdded:Connect(function() task.wait(0.33) ApplyESP(v) end)
end
Players.PlayerAdded:Connect(function(v)
ApplyESP(v)
v.CharacterAdded:Connect(function() task.wait(0.33) ApplyESP(v) end)
end)
end)
sections.dot_esp:CreateLabel("2D ESP", true)
sections.dot_esp:CreateToggle("ESP Enabled", false, function(v)
AdvESP.Enabled = v
end)
sections.dot_esp:CreateSlider("Max Distance", 100, 10000, AdvESP.MaxDistance, true, function(v)
AdvESP.MaxDistance = v
end)
sections.dot_esp:CreateToggle("Team Check", false, function(v)
AdvESP.TeamCheck = v
end)
sections.dot_esp:CreateToggle("Visibility Check", false, function(v)
AdvESP.VisibilityCheck = v
end)
sections.dot_esp:CreateDivider()
sections.dot_esp:CreateLabel("Boxes")
sections.dot_esp:CreateToggle("Boxes", AdvESP.Boxes, function(v)
AdvESP.Boxes = v
end)
sections.dot_esp:CreateColorpicker("Box Color", function(color)
AdvESP.BoxColor = color
end, false, false, nil, AdvESP.BoxColor)
sections.dot_esp:CreateSlider("Box Thickness", 1, 5, AdvESP.BoxThickness, true, function(v)
AdvESP.BoxThickness = v
end)
sections.dot_esp:CreateToggle("Box Filled", AdvESP.BoxFilled, function(v)
AdvESP.BoxFilled = v
end)
sections.dot_esp:CreateSlider("Box Fill Transparency", 0, 1, AdvESP.BoxFillTrans, false, function(v)
AdvESP.BoxFillTrans = v
end)
sections.dot_esp:CreateDivider()
sections.dot_esp:CreateLabel("Names & Distance")
sections.dot_esp:CreateToggle("Show Names", AdvESP.Names, function(v)
AdvESP.Names = v
end)
sections.dot_esp:CreateColorpicker("Name Color", function(color)
AdvESP.NameColor = color
end, false, false, nil, AdvESP.NameColor)
sections.dot_esp:CreateSlider("Name Size", 10, 20, AdvESP.NameSize, true, function(v)
AdvESP.NameSize = v
end)
sections.dot_esp:CreateToggle("Show Distance", AdvESP.Distance, function(v)
AdvESP.Distance = v
end)
sections.dot_esp:CreateColorpicker("Distance Color", function(color)
AdvESP.DistanceColor = color
end, false, false, nil, AdvESP.DistanceColor)
sections.dot_esp:CreateDivider()
sections.dot_esp:CreateLabel("Tracers")
sections.dot_esp:CreateToggle("Tracers", AdvESP.Tracers, function(v)
AdvESP.Tracers = v
end)
sections.dot_esp:CreateColorpicker("Tracer Color", function(color)
AdvESP.TracerColor = color
end, false, false, nil, AdvESP.TracerColor)
sections.dot_esp:CreateSlider("Tracer Thickness", 1, 5, AdvESP.TracerThickness, true, function(v)
AdvESP.TracerThickness = v
end)
sections.dot_esp:CreateDropdown("Tracer Origin", {"Bottom","Top","Center","Mouse"}, function(v)
AdvESP.TracerOrigin = v
end, AdvESP.TracerOrigin, false)
sections.dot_esp:CreateDivider()
sections.dot_esp:CreateLabel("Head Dot")
sections.dot_esp:CreateToggle("Head Dot", AdvESP.HeadDot, function(v)
AdvESP.HeadDot = v
end)
sections.dot_esp:CreateColorpicker("Head Dot Color", function(color)
AdvESP.HeadDotColor = color
end, false, false, nil, AdvESP.HeadDotColor)
sections.dot_esp:CreateSlider("Head Dot Size", 2, 10, AdvESP.HeadDotSize, true, function(v)
AdvESP.HeadDotSize = v
end)
sections.dot_esp:CreateToggle("Head Dot Filled", AdvESP.HeadDotFilled, function(v)
AdvESP.HeadDotFilled = v
end)
sections.dot_esp:CreateDivider()
sections.dot_esp:CreateLabel("Dot ESP 3D", true)
sections.dot_esp:CreateToggle("Dot ESP", false, function(v)
PrisonAPI.Dots.Enabled = v
end)
sections.dot_esp:CreateSlider("Dot Fill Transparency", 0, 1, 0.3, false, function(v)
PrisonAPI.Dots.FillTrans = v
end)
sections.dot_esp:CreateSlider("Dot Outline Transparency", 0, 1, 0.1, false, function(v)
PrisonAPI.Dots.OutlineTrans = v
end)
sections.auto_collect:CreateToggle("Auto Collect Items", false, function(v)
PrisonAPI.AutoItems.Enabled = v
end)
sections.auto_collect:CreateSlider("Collect Distance", 5, 12, 12, true, function(v)
PrisonAPI.AutoItems.GRAB_DISTANCE = v
end)
sections.local_player:CreateToggle("Auto Sprint", false, function(v)
PrisonAPI.AutoSprint = v
task.spawn(function()
while PrisonAPI.AutoSprint do
local ch = LocalPlayer.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hum and hum.WalkSpeed < 24 then hum.WalkSpeed = 24 end
task.wait(0.1)
end
end)
end)
local noclipConn
if not noclipConn then
noclipConn = RS.Stepped:Connect(function()
if PrisonAPI.Noclip then
local ch = LocalPlayer.Character
if ch then
for _,p in ipairs(ch:GetDescendants()) do
if p:IsA("BasePart") then p.CanCollide = false end
end
end
end
end)
end
sections.local_player:CreateToggle("Noclip", false, function(v) PrisonAPI.Noclip = v end)
sections.local_player:CreateToggle("Infinite Jump", false, function(v) PrisonAPI.InfiniteJump = v end)
sections.local_player:CreateButton("Headless (Client)", function()
local ch = LocalPlayer.Character
if ch and ch:FindFirstChild("Head") then
ch.Head.Transparency = 1
local face = ch.Head:FindFirstChild("face")
if face then face.Transparency = 1 end
end
end)
sections.local_player:CreateButton("Become Criminal", function()
PrisonAPI.BecomeCriminal()
end)
sections.speed:CreateLabel("Normal Speed")
sections.speed:CreateToggle("Walk Speed", false, function(v)
PrisonAPI.walkSpeedEnable = v
task.spawn(function()
while PrisonAPI.walkSpeedEnable do
local ch = LocalPlayer.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hum then hum.WalkSpeed = PrisonAPI.speedAmount end
task.wait(0.1)
end
end)
end)
sections.speed:CreateSlider("Speed Value", 16, 100, 50, true, function(v)
PrisonAPI.speedAmount = v
end)
sections.speed:CreateButton("Refresh Speed", function()
local ch = LocalPlayer.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hum then hum.WalkSpeed = 16 end
end)
sections.cframe_speed:CreateLabel("CFrame Speed")
sections.cframe_speed:CreateToggle("CFrame Speed", false, function(v)
PrisonAPI.TpWalkEnabled = v
end)
sections.cframe_speed:CreateSlider("CFrame Multiplier", 0, 5, 0.3, false, function(v)
PrisonAPI.TpStepSize = v
end)
sections.teleport:CreateButton("Criminal Base", function() PrisonAPI.CrimBaseTP() end)
sections.teleport:CreateButton("Yard", function() PrisonAPI.YardTP() end)
sections.teleport:CreateButton("Armory", function() PrisonAPI.AmoryTP() end)
sections.teleport:CreateButton("Cafeteria", function() PrisonAPI.CafeteriaTP() end)
sections.teleport:CreateButton("Gas Station", function() PrisonAPI.GasStationTP() end)
sections.teleport:CreateButton("Vending Machine", function() PrisonAPI.VendingMachineTP() end)
sections.teleport:CreateButton("Police Room", function() PrisonAPI.PoliceRoomTP() end)
sections.teleport:CreateButton("Guard Tower 1", function() PrisonAPI.GuardTower1TP() end)
sections.teleport:CreateButton("Guard Tower 2", function() PrisonAPI.GuardTower2TP() end)
sections.teleport:CreateButton("Secret Room", function() PrisonAPI.SecretRoomTP() end)
local executor_used = identifyexecutor and tostring(identifyexecutor()) or "Unknown"
sections.settings_main:CreateDropdown("Change Font", stored_fonts, function(value)
window:SetFont(value)
end, "", false)
local cleanKeyName = tostring(gui_config.Keybind):gsub("Enum.KeyCode.","")
sections.settings_main:CreateLabel("Menu Key: "..cleanKeyName)
sections.settings_main:CreateLabel("Executor: "..executor_used)
local config_manager = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
config_manager:SetLibrary(library)
config_manager:SetWindow(window)
config_manager:SetFolder("Kali Hub/PrisonLife")
config_manager:BuildConfigSection(tabs.settings)
config_manager:LoadAutoloadConfig()
