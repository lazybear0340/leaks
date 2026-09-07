--this shit was unobfuscated


if type(getgenv().KaliUnload) == "function" then
pcall(getgenv().KaliUnload)
end
getgenv().KaliUnload = nil
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local CenterPosition = Camera.ViewportSize / 2
local Kali = {Running = true, Connections = {}, Drawings = {}, Guis = {}, Restore = {}}
function Kali.track(connection)
table.insert(Kali.Connections, connection)
return connection
end
local AddDrawing
local GetClosest
local ApplyWeaponRainbow
local hasLineOfSight
local Drawings = {FovOutline = nil, FovInline = nil, AimbotFov = nil, TargetLine = nil}
local rainbow_config = {Speed = 1, Weapon = false, Fov = false, Crosshair = false, Esp = false}
local rainbowColor = Color3.new(1, 1, 1)
local DEFAULT_FOV = 70
local fov_config = {Enabled = false, Value = 90}
local Functions = {
GetClients = filtergc('function', {Name = 'GetClients', Constants = {'Clients'}}, false),
GetMuzzleCFrame = filtergc('function', {Name = 'GetMuzzleCFrame'}, true),
GetRecoil = filtergc('function', {Name = 'getRecoil'}, true)
}
local ClientService = nil
local CurrentFirearm = nil
local ActorService = nil
local nextActorScan = 0
local function GetActors()
if ActorService and type(ActorService.Actors) == 'table' then return ActorService.Actors end
if os.clock() < nextActorScan then return nil end
nextActorScan = os.clock() + 2
for _, v in getgc(true) do
if type(v) == 'table' and rawget(v, 'LocalActor') ~= nil and type(rawget(v, 'Actors')) == 'table' then
ActorService = v
return ActorService.Actors
end
end
return nil
end
local VehicleService = nil
local nextVehicleScan = 0
local function GetVehicles()
if VehicleService and type(VehicleService.Vehicles) == 'table' then return VehicleService.Vehicles end
if os.clock() < nextVehicleScan then return nil end
nextVehicleScan = os.clock() + 2
local best, bestCount = nil, 0
for _, v in getgc(true) do
if type(v) == 'table' and type(rawget(v, 'Vehicles')) == 'table' and rawget(v, 'Changed') ~= nil then
local count = 0
for _, Entry in rawget(v, 'Vehicles') do
if type(Entry) == 'table' and rawget(Entry, 'VehicleModel') ~= nil then count += 1 end
end
if count > bestCount then best, bestCount = v, count end
end
end
VehicleService = best
return best and best.Vehicles or nil
end
local VehicleMaxHealth = {}
local function VehicleHealth(Vehicle)
local Healths = Vehicle.Healths
if type(Healths) ~= 'table' then return 100 end
local Total = 0
for _, Value in Healths do
if type(Value) == 'number' then Total += Value end
end
if Total <= 0 then return 0 end
local Model = tostring(Vehicle.VehicleModel)
local Max = VehicleMaxHealth[Model]
if not Max or Total > Max then Max = Total; VehicleMaxHealth[Model] = Total end
return math.clamp(Total / Max * 100, 0, 100)
end
local function ActorKind(Actor)
if Actor.Zombie then return 'Zombie' end
if type(Actor.OwnerName) == 'string' then
return Actor.OwnerName == '???' and 'NPC' or 'Player'
end
return 'NPC'
end
local function ActorHealth(Actor)
local Health = Actor.Health
if type(Health) == 'number' then return math.clamp(Health, 0, 100) end
local Character = Actor.Character
local Humanoid = Character and Character:FindFirstChildOfClass('Humanoid')
if not Humanoid or Humanoid.MaxHealth <= 0 then return 100 end
return math.clamp(Humanoid.Health / Humanoid.MaxHealth * 100, 0, 100)
end
local function ActorLabel(Actor, Kind)
if Kind == 'Player' then return tostring(Actor.OwnerName) end
return Kind == 'Zombie' and 'Zombie' or 'NPC'
end
function AddDrawing(Type, Properties)
local DrawingObject = Drawing.new(Type)
for Property, Value in Properties do
DrawingObject[Property] = Value
end
table.insert(Kali.Drawings, DrawingObject)
return DrawingObject
end
local IsTouch = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local function PointerLocation()
if IsTouch then return Camera.ViewportSize / 2 end
return UserInputService:GetMouseLocation()
end
local crosshairSettings = {
Enabled = false,
Position = "Center",
Size = 10,
GapSize = 4,
Thickness = 1,
Color = Color3.fromRGB(0, 255, 0),
CenterDot = false
}
local CHLines = {
Top = AddDrawing("Line", {Thickness = 1, Visible = false}),
Bottom = AddDrawing("Line", {Thickness = 1, Visible = false}),
Left = AddDrawing("Line", {Thickness = 1, Visible = false}),
Right = AddDrawing("Line", {Thickness = 1, Visible = false}),
Dot = AddDrawing("Circle", {Radius = 2, Filled = true, Visible = false})
}
Kali.track(RunService.RenderStepped:Connect(function()
local mousePos = PointerLocation()
if Drawings.FovOutline then Drawings.FovOutline.Position = mousePos end
if Drawings.FovInline then Drawings.FovInline.Position = mousePos end
if Drawings.AimbotFov then Drawings.AimbotFov.Position = mousePos end
if crosshairSettings.Enabled then
local pos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
if crosshairSettings.Position == "Mouse" then
pos = PointerLocation()
end
local gap = crosshairSettings.GapSize
local size = crosshairSettings.Size
CHLines.Top.From = pos - Vector2.new(0, gap)
CHLines.Top.To = pos - Vector2.new(0, gap + size)
CHLines.Bottom.From = pos + Vector2.new(0, gap)
CHLines.Bottom.To = pos + Vector2.new(0, gap + size)
CHLines.Left.From = pos - Vector2.new(gap, 0)
CHLines.Left.To = pos - Vector2.new(gap + size, 0)
CHLines.Right.From = pos + Vector2.new(gap, 0)
CHLines.Right.To = pos + Vector2.new(gap + size, 0)
local chColor = rainbow_config.Crosshair and rainbowColor or crosshairSettings.Color
for k, line in CHLines do
if k ~= "Dot" then
line.Color = chColor
line.Thickness = crosshairSettings.Thickness
line.Visible = true
end
end
if crosshairSettings.CenterDot then
CHLines.Dot.Position = pos
CHLines.Dot.Color = chColor
CHLines.Dot.Visible = true
else
CHLines.Dot.Visible = false
end
else
for _, line in CHLines do line.Visible = false end
end
end))
local aim_config = {
SilentAim = false,
FovVisible = true,
FovRadius = 300,
FovColor = Color3.new(1, 1, 1),
FovThickness = 1.5,
FovTransparency = 1,
NoRecoil = false,
NoSpread = false,
Hitbox = "Head",
TeamCheck = true,
TargetPlayers = true,
TargetNPCs = true,
UseFov = true,
VisibleCheck = true,
HitChance = 100,
TargetLine = false,
TargetLineColor = Color3.fromRGB(255, 255, 255)
}
local HitboxParts = {
["Head"] = "Head",
["Upper Torso"] = "UpperTorso",
["Lower Torso"] = "LowerTorso",
["Left Arm"] = "LeftUpperArm",
["Right Arm"] = "RightUpperArm",
["Left Leg"] = "LeftUpperLeg",
["Right Leg"] = "RightUpperLeg"
}
local HitboxNames = {"Head", "Upper Torso", "Lower Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
Drawings.FovOutline = AddDrawing('Circle', {Visible = aim_config.FovVisible, Position = CenterPosition, Radius = aim_config.FovRadius, Thickness = aim_config.FovThickness + 2, Color = Color3.new(0, 0, 0)})
Drawings.FovInline = AddDrawing('Circle', {Visible = aim_config.FovVisible, Position = CenterPosition, Radius = aim_config.FovRadius, Thickness = aim_config.FovThickness, Color = aim_config.FovColor})
Drawings.AimbotFov = AddDrawing('Circle', {Visible = false, Position = CenterPosition, Radius = 120, Thickness = 1.5, Color = Color3.fromRGB(120, 200, 255)})
Drawings.TargetLine = AddDrawing('Line', {Visible = false, Thickness = 1, Color = aim_config.TargetLineColor})
Kali.track(RunService.RenderStepped:Connect(function()
if not aim_config.TargetLine then
Drawings.TargetLine.Visible = false
return
end
local HitboxPart = GetClosest()
if not HitboxPart then
Drawings.TargetLine.Visible = false
return
end
local Position = Camera:WorldToViewportPoint(HitboxPart.Position)
Drawings.TargetLine.From = PointerLocation()
Drawings.TargetLine.To = Vector2.new(Position.X, Position.Y)
Drawings.TargetLine.Color = rainbow_config.Esp and rainbowColor or aim_config.TargetLineColor
Drawings.TargetLine.Visible = true
end))
Kali.track(RunService.RenderStepped:Connect(function()
rainbowColor = Color3.fromHSV((tick() * rainbow_config.Speed * 0.2) % 1, 1, 1)
if rainbow_config.Fov and Drawings.FovInline then
Drawings.FovInline.Color = rainbowColor
end
if rainbow_config.Weapon then
ApplyWeaponRainbow(rainbowColor)
end
if fov_config.Enabled then
local Current = Camera.FieldOfView
if math.abs(Current - DEFAULT_FOV) < 0.5 or math.abs(Current - fov_config.Value) < 0.5 then
if math.abs(Current - fov_config.Value) > 0.01 then
Camera.FieldOfView = fov_config.Value
end
end
end
end))
local ARM_PARTS = {Root = true, Left = true, Right = true, Cam = true, L = true, R = true}
local WeaponColorBackup = setmetatable({}, {__mode = 'k'})
local function GunParts()
GetActors()
local Local = ActorService and ActorService.LocalActor
local ViewModel = Local and rawget(Local, 'ViewModel')
local Container = type(ViewModel) == 'table' and rawget(ViewModel, '_container')
if not (typeof(Container) == 'Instance' and Container.Parent) then return nil end
return Container:GetDescendants()
end
function ApplyWeaponRainbow(color)
local Parts = GunParts()
if not Parts then return end
for _, Part in Parts do
if Part:IsA('BasePart') and not ARM_PARTS[Part.Name] then
if WeaponColorBackup[Part] == nil then
WeaponColorBackup[Part] = {Color = Part.Color, Tex = Part:IsA('MeshPart') and Part.TextureID or nil}
if Part:IsA('MeshPart') and Part.TextureID ~= '' then Part.TextureID = '' end
end
Part.Color = color
end
end
end
local function RestoreWeaponColors()
for Part, Backup in WeaponColorBackup do
if Part.Parent then
Part.Color = Backup.Color
if Backup.Tex and Part:IsA('MeshPart') then Part.TextureID = Backup.Tex end
end
WeaponColorBackup[Part] = nil
end
end
table.insert(Kali.Restore, RestoreWeaponColors)
function GetClosest()
local ClosestPart, ClosestDistance = nil, math.huge
local Center = PointerLocation()
local Limit = aim_config.UseFov and aim_config.FovRadius or math.huge
if aim_config.TargetPlayers and ClientService and ClientService.Clients then
local LocalSquad = ClientService.LocalClient and ClientService.LocalClient.Squad
for Player, Data in ClientService.Clients do
if Player == LocalPlayer then continue end
if not Data.Actor or not Data.Actor.Alive or not Data.Actor.Parts then continue end
if aim_config.TeamCheck and LocalSquad and Data.Squad == LocalSquad then continue end
local HitboxPart = Data.Actor.Parts[aim_config.Hitbox] or Data.Actor.Parts.Head
if not HitboxPart then continue end
local Position, OnScreen = Camera:WorldToViewportPoint(HitboxPart.Position)
if not OnScreen then continue end
local Distance = (Vector2.new(Position.X, Position.Y) - Center).Magnitude
if Distance > Limit or Distance > ClosestDistance then continue end
if aim_config.VisibleCheck and not hasLineOfSight(HitboxPart) then continue end
ClosestPart = HitboxPart; ClosestDistance = Distance
end
end
if aim_config.TargetNPCs then
local Actors = GetActors()
if Actors then
for _, Actor in Actors do
if type(Actor) ~= 'table' or not Actor.Alive then continue end
if ActorKind(Actor) == 'Player' then continue end
local Parts = Actor.Parts
local HitboxPart = Parts and (Parts[aim_config.Hitbox] or Parts.Head)
if not (HitboxPart and HitboxPart.Parent) then continue end
local Position, OnScreen = Camera:WorldToViewportPoint(HitboxPart.Position)
if not OnScreen then continue end
local Distance = (Vector2.new(Position.X, Position.Y) - Center).Magnitude
if Distance > Limit or Distance > ClosestDistance then continue end
if aim_config.VisibleCheck and not hasLineOfSight(HitboxPart) then continue end
ClosestPart = HitboxPart; ClosestDistance = Distance
end
end
end
return ClosestPart, ClosestDistance
end
if type(Functions.GetClients) == 'table' then
local Match
for _, Function in Functions.GetClients do
local Ok, Info = pcall(getinfo, Function)
if Ok and Info and Info.source and Info.source:find('ClientService') then Match = Function break end
end
Functions.GetClients = Match
end
local function Hook(Target, Replacement)
if type(Target) ~= 'function' then return nil end
local Original = hookfunction(Target, newcclosure(Replacement))
table.insert(Kali.Restore, function() restorefunction(Target) end)
return Original
end
local OldClients; OldClients = Hook(Functions.GetClients, function(Self)
ClientService = Self; return OldClients(Self)
end)
local OldMuzzle; OldMuzzle = Hook(Functions.GetMuzzleCFrame, function(Self, Cast)
if type(Self) == 'table' and rawget(Self, '_firearm') then CurrentFirearm = Self end
local Origin, Barrel, CameraOut = OldMuzzle(Self, Cast)
if Kali.Running and aim_config.SilentAim and not Cast and Origin then
local HitboxPart = GetClosest()
if HitboxPart and (aim_config.HitChance >= 100 or math.random(1, 100) <= aim_config.HitChance) then
return CFrame.new(Origin.Position, HitboxPart.Position), Barrel, CameraOut
end
end
return Origin, Barrel, CameraOut
end)
local OldRecoil; OldRecoil = Hook(Functions.GetRecoil, function(...)
local Args = {...}
if type(Args[1]) == 'table' then
if aim_config.NoSpread then Args[1]['Barrel_Spread'] = 0 end
if aim_config.NoRecoil then
Args[1]['RecoilForce_Tap'] = 0
Args[1]['RecoilForce_Impulse'] = 0
Args[1]['RecoilForce_Out'] = 0
Args[1]['Recoil_Camera'] = 0
Args[1]['Recoil_KickBack'] = 0
Args[1]['Recoil_X'] = 0
Args[1]['Recoil_Z'] = 0
Args[1]['Recoil_Range'] = Vector2.zero
end
end
return OldRecoil(unpack(Args))
end)
Kali.track(Camera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
CenterPosition = Camera.ViewportSize / 2
end))
local esp_config = {
TeamCheck = true,
ShowPlayers = true,
ShowNPCs = true,
ShowVehicles = true,
LimitDistance = false,
MaxDistance = 1000,
TextSize = 13,
TracerOrigin = "Bottom"
}
local esp_categories = {
Enemy = {
Enabled = true,
Box = true, BoxFill = false, Box3D = false,
HealthBar = true, HealthText = true,
Name = true, Distance = true, Weapon = true,
Chams = false, Tracers = false, OffScreenArrow = false,
Color = Color3.fromRGB(255, 64, 64)
},
Team = {
Enabled = false,
Box = true, BoxFill = false, Box3D = false,
HealthBar = true, HealthText = false,
Name = true, Distance = true, Weapon = false,
Chams = false, Tracers = false, OffScreenArrow = false,
Color = Color3.fromRGB(64, 160, 255)
},
NPC = {
Enabled = true,
Box = true, BoxFill = false, Box3D = false,
HealthBar = true, HealthText = false,
Name = true, Distance = true, Weapon = false,
Chams = false, Tracers = false, OffScreenArrow = false,
Color = Color3.fromRGB(255, 200, 0)
},
Vehicle = {
Enabled = false,
Box = true, BoxFill = false,
HealthBar = true, HealthText = false,
Name = true, Distance = true,
Tracers = false, OffScreenArrow = false,
Color = Color3.fromRGB(120, 255, 160)
}
}
local espRunning = false
local function GetWeaponName(Actor)
local Equipped, Inventory = rawget(Actor, '_equipped'), rawget(Actor, '_inventory')
if type(Equipped) ~= 'string' or type(Inventory) ~= 'table' then return nil end
local Item = Inventory[Equipped]
local Firearm = type(Item) == 'table' and rawget(Item, '_firearm')
return type(Firearm) == 'table' and Firearm.Name or nil
end
local BOX_WIDTH_RATIO = 0.42
local RIG_SIZE = Vector3.new(2.2, 5.6, 1.6)
local MAX_TARGETS = IsTouch and 40 or 100
local espPool = {}
local function GetSlot(index)
local Slot = espPool[index]
if Slot then return Slot end
Slot = {
Box = AddDrawing('Square', {Thickness = 1, Filled = false, Visible = false}),
Fill = AddDrawing('Square', {Filled = true, Transparency = 0.35, Visible = false}),
HealthBack = AddDrawing('Square', {Filled = true, Color = Color3.new(0, 0, 0), Visible = false}),
HealthBar = AddDrawing('Square', {Filled = true, Visible = false}),
Tracer = AddDrawing('Line', {Thickness = 1, Visible = false}),
Box3D = {},
Texts = {}
}
for i = 1, 12 do Slot.Box3D[i] = AddDrawing('Line', {Thickness = 1, Visible = false}) end
for i = 1, 4 do Slot.Texts[i] = AddDrawing('Text', {Center = true, Outline = true, Visible = false}) end
pcall(function()
Slot.Arrow = AddDrawing('Triangle', {Filled = true, Visible = false})
end)
espPool[index] = Slot
return Slot
end
local function HideSlot(Slot)
Slot.Box.Visible = false
Slot.Fill.Visible = false
Slot.HealthBack.Visible = false
Slot.HealthBar.Visible = false
Slot.Tracer.Visible = false
if Slot.Arrow then Slot.Arrow.Visible = false end
for _, Line in Slot.Box3D do Line.Visible = false end
for _, Text in Slot.Texts do Text.Visible = false end
end
local espChams = {}
local function SetChams(Character, Color)
local Highlight = espChams[Character]
if not Color then
if Highlight then
if Highlight.Parent then Highlight:Destroy() end
espChams[Character] = nil
end
return
end
if not Highlight or not Highlight.Parent then
Highlight = Instance.new('Highlight')
Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
Highlight.FillTransparency = 0.55
Highlight.OutlineTransparency = 0
Highlight.Adornee = Character
Highlight.Parent = Character
espChams[Character] = Highlight
end
Highlight.FillColor = Color
Highlight.OutlineColor = Color
end
local function ClearChams()
for Character, Highlight in espChams do
if Highlight and Highlight.Parent then Highlight:Destroy() end
espChams[Character] = nil
end
end
table.insert(Kali.Restore, ClearChams)
local function TracerOrigin()
if esp_config.TracerOrigin == 'Top' then
return Vector2.new(Camera.ViewportSize.X / 2, 0)
elseif esp_config.TracerOrigin == 'Mouse' then
local Pointer = PointerLocation()
return Vector2.new(Pointer.X, Pointer.Y)
end
return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
end
local BOX3D_EDGES = {
{1,2},{2,4},{4,3},{3,1},
{5,6},{6,8},{8,7},{7,5},
{1,5},{2,6},{3,7},{4,8}
}
local function DrawSlot(Slot, Actor, Settings, Distance, Kind)
if rainbow_config.Esp then
Settings = setmetatable({Color = rainbowColor}, {__index = Settings})
end
local Parts = Actor.Parts
local Head = Parts and Parts.Head
local Root = Actor.RootPart
if not (Head and Root and Head.Parent and Root.Parent) then return false end
local TopPoint, TopOnScreen = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.7, 0))
local BottomPoint = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0, 3.2, 0))
if not TopOnScreen then
if not (Settings.OffScreenArrow and Slot.Arrow) then return false end
local Center = Camera.ViewportSize / 2
local Direction = (Vector2.new(TopPoint.X, TopPoint.Y) - Center)
if TopPoint.Z < 0 then Direction = -Direction end
if Direction.Magnitude < 1 then return false end
Direction = Direction.Unit
local Origin = Center + Direction * math.min(Center.X, Center.Y) * 0.8
local Side = Vector2.new(-Direction.Y, Direction.X)
Slot.Arrow.PointA = Origin + Direction * 14
Slot.Arrow.PointB = Origin - Direction * 6 + Side * 8
Slot.Arrow.PointC = Origin - Direction * 6 - Side * 8
Slot.Arrow.Color = Settings.Color
Slot.Arrow.Visible = true
return true
end
local Height = math.abs(BottomPoint.Y - TopPoint.Y)
local Width = Height * BOX_WIDTH_RATIO
local Left = TopPoint.X - Width / 2
local Top = math.min(TopPoint.Y, BottomPoint.Y)
if Settings.BoxFill then
Slot.Fill.Size = Vector2.new(Width, Height)
Slot.Fill.Position = Vector2.new(Left, Top)
Slot.Fill.Color = Settings.Color
Slot.Fill.Visible = true
end
if Settings.Box then
Slot.Box.Size = Vector2.new(Width, Height)
Slot.Box.Position = Vector2.new(Left, Top)
Slot.Box.Color = Settings.Color
Slot.Box.Visible = true
end
if Settings.Box3D then
local Base = Root.CFrame
local Half = RIG_SIZE / 2
local Corners, AllOn = {}, true
for i = 1, 8 do
local Offset = Vector3.new(
(i % 2 == 1) and -Half.X or Half.X,
(i <= 4) and Half.Y or -Half.Y,
((i - 1) % 4 < 2) and -Half.Z or Half.Z
)
local Point, OnScreen = Camera:WorldToViewportPoint(Base:PointToWorldSpace(Offset))
if not OnScreen then AllOn = false break end
Corners[i] = Vector2.new(Point.X, Point.Y)
end
if AllOn then
for i, Edge in BOX3D_EDGES do
local Line = Slot.Box3D[i]
Line.From = Corners[Edge[1]]
Line.To = Corners[Edge[2]]
Line.Color = Settings.Color
Line.Visible = true
end
end
end
local Health = ActorHealth(Actor)
local Ratio = Health / 100
if Settings.HealthBar then
Slot.HealthBack.Size = Vector2.new(3, Height)
Slot.HealthBack.Position = Vector2.new(Left - 6, Top)
Slot.HealthBack.Visible = true
Slot.HealthBar.Size = Vector2.new(3, Height * Ratio)
Slot.HealthBar.Position = Vector2.new(Left - 6, Top + Height * (1 - Ratio))
Slot.HealthBar.Color = Color3.fromHSV(Ratio * 0.33, 1, 1)
Slot.HealthBar.Visible = true
end
if Settings.Tracers then
Slot.Tracer.From = TracerOrigin()
Slot.Tracer.To = Vector2.new(TopPoint.X, Top + Height)
Slot.Tracer.Color = Settings.Color
Slot.Tracer.Visible = true
end
local Above, Below = {}, {}
if Settings.Name then
table.insert(Above, ActorLabel(Actor, Kind))
end
if Settings.HealthText then table.insert(Above, math.floor(Health) .. ' HP') end
if Settings.Distance then table.insert(Below, math.floor(Distance) .. 'm') end
if Settings.Weapon then
local Weapon = GetWeaponName(Actor)
if Weapon then table.insert(Below, Weapon) end
end
local Index = 0
for i, Line in Above do
Index += 1
local Text = Slot.Texts[Index]
if not Text then break end
Text.Text = Line
Text.Size = esp_config.TextSize
Text.Color = Settings.Color
Text.Position = Vector2.new(TopPoint.X, Top - (#Above - i + 1) * (esp_config.TextSize + 1))
Text.Visible = true
end
for i, Line in Below do
Index += 1
local Text = Slot.Texts[Index]
if not Text then break end
Text.Text = Line
Text.Size = esp_config.TextSize
Text.Color = Settings.Color
Text.Position = Vector2.new(TopPoint.X, Top + Height + (i - 1) * (esp_config.TextSize + 1) + 2)
Text.Visible = true
end
return true
end
local VehicleBox = setmetatable({}, {__mode = 'k'})
local function DrawVehicle(Slot, Vehicle, Settings, Distance)
local Main, Model = Vehicle.VehicleMain, Vehicle.Model
if typeof(Main) ~= 'Instance' or not Main.Parent then return false end
if typeof(Model) ~= 'Instance' or not Model.Parent then return false end
local Box = VehicleBox[Model]
if not Box then
local Ok, BoxCFrame, BoxSize = pcall(Model.GetBoundingBox, Model)
if not Ok then return false end
Box = {Offset = Main.CFrame:ToObjectSpace(BoxCFrame), Size = BoxSize}
VehicleBox[Model] = Box
end
local Base = Main.CFrame * Box.Offset
local Half = Box.Size / 2
local MinX, MinY, MaxX, MaxY = math.huge, math.huge, -math.huge, -math.huge
local OnScreen = false
for i = 1, 8 do
local Point, Visible = Camera:WorldToViewportPoint(Base:PointToWorldSpace(Vector3.new(
(i % 2 == 1) and -Half.X or Half.X,
(i <= 4) and Half.Y or -Half.Y,
((i - 1) % 4 < 2) and -Half.Z or Half.Z
)))
if Visible then OnScreen = true end
if Point.Z > 0 then
if Point.X < MinX then MinX = Point.X end
if Point.X > MaxX then MaxX = Point.X end
if Point.Y < MinY then MinY = Point.Y end
if Point.Y > MaxY then MaxY = Point.Y end
end
end
local Center = Camera.ViewportSize / 2
if not OnScreen then
if not (Settings.OffScreenArrow and Slot.Arrow) then return false end
local Point = Camera:WorldToViewportPoint(Main.Position)
local Direction = Vector2.new(Point.X, Point.Y) - Center
if Point.Z < 0 then Direction = -Direction end
if Direction.Magnitude < 1 then return false end
Direction = Direction.Unit
local Origin = Center + Direction * math.min(Center.X, Center.Y) * 0.8
local Side = Vector2.new(-Direction.Y, Direction.X)
Slot.Arrow.PointA = Origin + Direction * 14
Slot.Arrow.PointB = Origin - Direction * 6 + Side * 8
Slot.Arrow.PointC = Origin - Direction * 6 - Side * 8
Slot.Arrow.Color = Settings.Color
Slot.Arrow.Visible = true
return true
end
if MinX == math.huge then return false end
local Width, Height = MaxX - MinX, MaxY - MinY
if Width < 1 or Height < 1 then return false end
if Settings.BoxFill then
Slot.Fill.Size = Vector2.new(Width, Height)
Slot.Fill.Position = Vector2.new(MinX, MinY)
Slot.Fill.Color = Settings.Color
Slot.Fill.Visible = true
end
if Settings.Box then
Slot.Box.Size = Vector2.new(Width, Height)
Slot.Box.Position = Vector2.new(MinX, MinY)
Slot.Box.Color = Settings.Color
Slot.Box.Visible = true
end
local Health = VehicleHealth(Vehicle)
local Ratio = Health / 100
if Settings.HealthBar then
Slot.HealthBack.Size = Vector2.new(3, Height)
Slot.HealthBack.Position = Vector2.new(MinX - 6, MinY)
Slot.HealthBack.Visible = true
Slot.HealthBar.Size = Vector2.new(3, Height * Ratio)
Slot.HealthBar.Position = Vector2.new(MinX - 6, MinY + Height * (1 - Ratio))
Slot.HealthBar.Color = Color3.fromHSV(Ratio * 0.33, 1, 1)
Slot.HealthBar.Visible = true
end
if Settings.Tracers then
Slot.Tracer.From = TracerOrigin()
Slot.Tracer.To = Vector2.new((MinX + MaxX) / 2, MaxY)
Slot.Tracer.Color = Settings.Color
Slot.Tracer.Visible = true
end
local Index = 0
if Settings.Name then
Index += 1
local Text = Slot.Texts[Index]
Text.Text = tostring(Vehicle.VehicleModel)
Text.Size = esp_config.TextSize
Text.Color = Settings.Color
Text.Position = Vector2.new((MinX + MaxX) / 2, MinY - (esp_config.TextSize + 1))
Text.Visible = true
end
if Settings.HealthText then
Index += 1
local Text = Slot.Texts[Index]
Text.Text = math.floor(Health) .. '%'
Text.Size = esp_config.TextSize
Text.Color = Settings.Color
Text.Position = Vector2.new((MinX + MaxX) / 2, MaxY + 2)
Text.Visible = true
end
if Settings.Distance then
Index += 1
local Text = Slot.Texts[Index]
Text.Text = math.floor(Distance) .. 'm'
Text.Size = esp_config.TextSize
Text.Color = Settings.Color
Text.Position = Vector2.new((MinX + MaxX) / 2, MaxY + 2 + (Index - 2) * (esp_config.TextSize + 1))
Text.Visible = true
end
return true
end
local SquadByActor = {}
local LiveChams = {}
local function updateESP()
local Actors = GetActors()
local Used = 0
table.clear(LiveChams)
if Actors then
table.clear(SquadByActor)
local LocalSquad = nil
if ClientService and ClientService.Clients then
LocalSquad = ClientService.LocalClient and ClientService.LocalClient.Squad
for _, Data in ClientService.Clients do
if Data.Actor then SquadByActor[Data.Actor] = Data.Squad end
end
end
for Pass = 1, 2 do
local WantPlayer = Pass == 1
for _, Actor in Actors do
if Used >= MAX_TARGETS then break end
if type(Actor) ~= 'table' or Actor.IsLocalPlayer or not Actor.Alive then continue end
local Character = Actor.Character
if not (Character and Character.Parent) then continue end
local Kind = ActorKind(Actor)
if WantPlayer ~= (Kind == 'Player') then continue end
local Category
if Kind == 'Player' then
if not esp_config.ShowPlayers then continue end
local Squad = SquadByActor[Actor]
if esp_config.TeamCheck and Squad and LocalSquad and Squad == LocalSquad then
Category = 'Team'
else
Category = 'Enemy'
end
else
if not esp_config.ShowNPCs then continue end
Category = 'NPC'
end
local Settings = esp_categories[Category]
if not Settings.Enabled then continue end
local Root = Actor.RootPart
if not (Root and Root.Parent) then continue end
local Distance = (Camera.CFrame.Position - Root.Position).Magnitude
if esp_config.LimitDistance and Distance > esp_config.MaxDistance then continue end
if Settings.Chams then
SetChams(Character, Settings.Color)
LiveChams[Character] = true
end
local Slot = GetSlot(Used + 1)
HideSlot(Slot)
if DrawSlot(Slot, Actor, Settings, Distance, Kind) then Used += 1 end
end
end
end
local VehicleSettings = esp_categories.Vehicle
if esp_config.ShowVehicles and VehicleSettings.Enabled then
local Vehicles = GetVehicles()
if Vehicles then
for _, Vehicle in Vehicles do
if Used >= MAX_TARGETS then break end
if type(Vehicle) ~= 'table' or not Vehicle.Alive or Vehicle.VehicleModel == nil then continue end
local Main = Vehicle.VehicleMain
if typeof(Main) ~= 'Instance' or not Main.Parent then continue end
local Distance = (Camera.CFrame.Position - Main.Position).Magnitude
if esp_config.LimitDistance and Distance > esp_config.MaxDistance then continue end
local Slot = GetSlot(Used + 1)
HideSlot(Slot)
if DrawVehicle(Slot, Vehicle, VehicleSettings, Distance) then Used += 1 end
end
end
end
for i = Used + 1, #espPool do HideSlot(espPool[i]) end
for Character in espChams do
if not LiveChams[Character] then SetChams(Character, nil) end
end
end
local Lighting = game:GetService("Lighting")
local world_config = {NoLeaves = false, NoShadows = false, NoClouds = false, NoLighting = false}
local leafBackup = {}
local leafConnection = nil
local shadowBackup = nil
local cloudBackup = nil
local lightingBackup = {}
local function LeafHolder()
local best, bestHits = nil, 0
for _, Child in Workspace:GetChildren() do
if Child:IsA('Folder') or Child:IsA('Model') then
local hits = 0
for _, Model in Child:GetChildren() do
if Model:IsA('Model') then
local Leaves = Model:FindFirstChild('Leaves')
if Leaves and Leaves:IsA('MeshPart') then hits += 1 end
end
end
if hits > bestHits then best, bestHits = Child, hits end
end
end
return best
end
local function HideLeaves(Model)
if not Model:IsA('Model') then return end
local Leaves = Model:FindFirstChild('Leaves')
if not (Leaves and Leaves:IsA('MeshPart')) or leafBackup[Leaves] then return end
leafBackup[Leaves] = Leaves.Transparency
Leaves.Transparency = 1
end
local function toggleLeaves(state)
world_config.NoLeaves = state
if leafConnection then leafConnection:Disconnect(); leafConnection = nil end
if not state then
for Leaves, Transparency in leafBackup do
if Leaves.Parent then Leaves.Transparency = Transparency end
end
table.clear(leafBackup)
return
end
local Holder = LeafHolder()
if not Holder then return end
for _, Model in Holder:GetChildren() do HideLeaves(Model) end
leafConnection = Kali.track(Holder.ChildAdded:Connect(function(Child)
if world_config.NoLeaves then HideLeaves(Child) end
end))
end
local function toggleShadows(state)
world_config.NoShadows = state
if shadowBackup == nil then shadowBackup = Lighting.GlobalShadows end
Lighting.GlobalShadows = if state then false else shadowBackup
end
local function toggleClouds(state)
world_config.NoClouds = state
local Terrain = Workspace:FindFirstChildOfClass('Terrain')
local Clouds = Terrain and Terrain:FindFirstChildOfClass('Clouds')
if not Clouds then return end
if cloudBackup == nil then cloudBackup = Clouds.Enabled end
Clouds.Enabled = if state then false else cloudBackup
end
local LIGHTING_CLASSES = {
Sky = true, Atmosphere = true, BloomEffect = true, BlurEffect = true,
ColorCorrectionEffect = true, DepthOfFieldEffect = true, SunRaysEffect = true
}
local function toggleLighting(state)
world_config.NoLighting = state
if not state then
for _, Child in lightingBackup do
if Child then Child.Parent = Lighting end
end
table.clear(lightingBackup)
return
end
for _, Child in Lighting:GetChildren() do
if LIGHTING_CLASSES[Child.ClassName] then
table.insert(lightingBackup, Child)
Child.Parent = nil
end
end
end
table.insert(Kali.Restore, function()
toggleLeaves(false); toggleShadows(false); toggleClouds(false); toggleLighting(false)
end)
local function cleanupESP()
if espRunning then RunService:UnbindFromRenderStep("MaleESP"); espRunning = false end
for _, Slot in espPool do HideSlot(Slot) end
ClearChams()
ActorService = nil
nextActorScan = 0
VehicleService = nil
nextVehicleScan = 0
table.clear(VehicleMaxHealth)
end
local aimbotConfig = {
Enabled = false,
Keybind = Enum.UserInputType.MouseButton2,
Smoothing = 0.15,
Prediction = 0,
TargetPart = "Head",
WallCheck = true,
TeamCheck = true,
UseFov = true,
FovRadius = 120,
FovVisible = false,
StickToTarget = true
}
local aimbotTarget = nil
local aimbotTargetActor = nil
local aiming = false
function hasLineOfSight(part)
if not part then return false end
local targetModel = part
while targetModel.Parent and targetModel.Parent ~= Workspace do
targetModel = targetModel.Parent
end
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
local ignore = {Camera, targetModel}
if LocalPlayer.Character then table.insert(ignore, LocalPlayer.Character) end
rayParams.FilterDescendantsInstances = ignore
local o = Camera.CFrame.Position
local hit = Workspace:Raycast(o, part.Position - o, rayParams)
if not hit then return true end
if hit.Instance.Transparency >= 0.5 or not hit.Instance.CanCollide then return true end
return false
end
local function isVisible(part)
if not aimbotConfig.WallCheck then return true end
return hasLineOfSight(part)
end
local function stillValid(fovCenter, limit)
local part = aimbotTarget
if not (part and part.Parent) then return false end
if not (aimbotTargetActor and aimbotTargetActor.Alive) then return false end
if aimbotConfig.WallCheck and not isVisible(part) then return false end
local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
if not onScreen then return false end
return (Vector2.new(screenPos.X, screenPos.Y) - fovCenter).Magnitude <= limit
end
local function getClosestHead()
local Actors = GetActors()
if not Actors then return nil end
local closestPart, closestActor = nil, nil
local closestDist = aimbotConfig.UseFov and aimbotConfig.FovRadius or math.huge
local fovCenter = aimbotConfig.UseFov and PointerLocation() or Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
if aimbotConfig.StickToTarget and stillValid(fovCenter, closestDist) then
return aimbotTarget
end
local SquadByActor, LocalSquad = {}, nil
if ClientService and ClientService.Clients then
LocalSquad = ClientService.LocalClient and ClientService.LocalClient.Squad
for _, Data in ClientService.Clients do
if Data.Actor then SquadByActor[Data.Actor] = Data.Squad end
end
end
for _, Actor in Actors do
if type(Actor) ~= 'table' or Actor.IsLocalPlayer or not Actor.Alive then continue end
if aimbotConfig.TeamCheck then
local Squad = SquadByActor[Actor]
if Squad and LocalSquad and Squad == LocalSquad then continue end
end
local Parts = Actor.Parts
local targetPart = Parts and (Parts[aimbotConfig.TargetPart] or Parts.Head)
if not (targetPart and targetPart.Parent) then continue end
if aimbotConfig.WallCheck and not isVisible(targetPart) then continue end
local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
if not onScreen then continue end
local dist = (Vector2.new(screenPos.X, screenPos.Y) - fovCenter).Magnitude
if dist < closestDist then
closestDist = dist
closestPart = targetPart
closestActor = Actor
end
end
aimbotTargetActor = closestActor
return closestPart
end
local function checkKeybind(input, expected)
if typeof(expected) == "EnumItem" then
if expected.EnumType == Enum.UserInputType then return input.UserInputType == expected
elseif expected.EnumType == Enum.KeyCode then return input.KeyCode == expected end
end
return false
end
Kali.track(UserInputService.InputBegan:Connect(function(input, processed)
if processed then return end
if checkKeybind(input, aimbotConfig.Keybind) then aiming = true end
end))
Kali.track(UserInputService.InputEnded:Connect(function(input, processed)
if checkKeybind(input, aimbotConfig.Keybind) then
aiming = false
aimbotTarget = nil
aimbotTargetActor = nil
end
end))
Kali.track(RunService.RenderStepped:Connect(function(deltaTime)
if not aimbotConfig.Enabled or not aiming or not Camera then
aimbotTarget = nil
aimbotTargetActor = nil
return
end
aimbotTarget = getClosestHead()
if not aimbotTarget then return end
local targetPos = aimbotTarget.Position
if aimbotConfig.Prediction > 0 then
local velocity = aimbotTarget.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
targetPos = targetPos + velocity * math.clamp(aimbotConfig.Prediction, 0, 0.3)
end
local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
if not onScreen then
aimbotTarget = nil
aimbotTargetActor = nil
return
end
local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
local relX = screenPos.X - screenCenter.X
local relY = screenPos.Y - screenCenter.Y
local dist = math.sqrt(relX * relX + relY * relY)
if dist > 1 then
local smooth = math.clamp(aimbotConfig.Smoothing, 0.01, 1)
local frameSmooth = 1 - (1 - smooth) ^ (deltaTime * 60)
local moveX = relX * frameSmooth
local moveY = relY * frameSmooth
if math.abs(moveX) > math.abs(relX) then moveX = relX end
if math.abs(moveY) > math.abs(relY) then moveY = relY end
if mousemoverel then
mousemoverel(moveX, moveY)
elseif mousemoveabs then
local mousePos = UserInputService:GetMouseLocation()
mousemoveabs(mousePos.X + moveX, mousePos.Y + moveY)
end
end
end))
local gun_config = {
NoADS = false,
NoSway = false,
FireModeOverride = false,
FireMode = 2,
FastFireRate = false,
FireRateMultiplier = 2,
InstantHit = false,
NoShootDelay = false,
InstantEquip = false,
AutoShoot = false,
AutoShootDelay = 0,
AutoShootKey = nil,
AutoShootVisibleCheck = true,
TriggerBot = false,
TriggerRadius = 8,
TriggerDelay = 0.05,
TriggerVisibleCheck = true
}
local FiremodeIds = {Safe = 0, Semi = 1, Auto = 2, Burst = 3}
local function InstantVelocity() return 30000 end
local TuneBackup = setmetatable({}, {__mode = 'k'})
local CaliberBackup = setmetatable({}, {__mode = 'k'})
local SwayBackup = setmetatable({}, {__mode = 'k'})
do
local OldFiremode; OldFiremode = Hook(filtergc('function', {Name = '_getFiremode'}, true), function(Self)
if gun_config.FireModeOverride and type(Self) == 'table' and not rawget(Self, '_reloading') then
return gun_config.FireMode
end
return OldFiremode(Self)
end)
local OldAds; OldAds = Hook(filtergc('function', {Name = '_ads'}, true), function(Self, State, ...)
if gun_config.NoADS then State = false end
return OldAds(Self, State, ...)
end)
end
local function ApplyGunMods(Firearm)
local Tune = Firearm._firearm and Firearm._firearm.Tune
if Tune then
local Backup = TuneBackup[Tune]
if not Backup then
Backup = {RPM = Tune.RPM, Barrel_Spread = Tune.Barrel_Spread, Equip_Delay = Tune.Equip_Delay}
TuneBackup[Tune] = Backup
end
Tune.RPM = gun_config.FastFireRate and Backup.RPM * gun_config.FireRateMultiplier or Backup.RPM
Tune.Barrel_Spread = aim_config.NoSpread and 0 or Backup.Barrel_Spread
Tune.Equip_Delay = gun_config.InstantEquip and 0 or Backup.Equip_Delay
end
local Caliber = Firearm._caliber
if Caliber then
local Backup = CaliberBackup[Caliber]
if not Backup then
Backup = {Velocity = Caliber.Velocity, Drag = Caliber.Drag, Spread = Caliber.Spread}
CaliberBackup[Caliber] = Backup
end
Caliber.Velocity = gun_config.InstantHit and InstantVelocity or Backup.Velocity
Caliber.Drag = gun_config.InstantHit and 0 or Backup.Drag
Caliber.Spread = aim_config.NoSpread and 0 or Backup.Spread
end
local ViewModel = Firearm._actor and Firearm._actor.ViewModel
local Sway = ViewModel and rawget(ViewModel, '_swaySpring')
if Sway then
local Backup = SwayBackup[Sway]
if not Backup then
Backup = {Speed = rawget(Sway, '_speed'), Dampening = rawget(Sway, '_dampening')}
SwayBackup[Sway] = Backup
end
Sway.Speed = gun_config.NoSway and 1000 or Backup.Speed
Sway.Dampening = gun_config.NoSway and 1 or Backup.Dampening
end
if gun_config.NoShootDelay then Firearm._next = 0 end
end
table.insert(Kali.Restore, function()
for Tune, Backup in TuneBackup do
Tune.RPM = Backup.RPM
Tune.Barrel_Spread = Backup.Barrel_Spread
Tune.Equip_Delay = Backup.Equip_Delay
end
for Caliber, Backup in CaliberBackup do
Caliber.Velocity = Backup.Velocity
Caliber.Drag = Backup.Drag
Caliber.Spread = Backup.Spread
end
for Sway, Backup in SwayBackup do
Sway.Speed = Backup.Speed
Sway.Dampening = Backup.Dampening
end
end)
local autoShootHeld = false
local lastAutoShot = 0
Kali.track(UserInputService.InputBegan:Connect(function(input, processed)
if processed then return end
if gun_config.AutoShootKey and checkKeybind(input, gun_config.AutoShootKey) then autoShootHeld = true end
end))
Kali.track(UserInputService.InputEnded:Connect(function(input)
if gun_config.AutoShootKey and checkKeybind(input, gun_config.AutoShootKey) then autoShootHeld = false end
end))
local lastTriggerShot = 0
Kali.track(RunService.RenderStepped:Connect(function()
local Firearm = CurrentFirearm
if type(Firearm) ~= 'table' then return end
pcall(ApplyGunMods, Firearm)
if not Firearm.Equipped then return end
local Now = os.clock()
local triggerReady = gun_config.TriggerBot and Now - lastTriggerShot >= gun_config.TriggerDelay
local Tune = Firearm._firearm and Firearm._firearm.Tune
local MinDelay = (Tune and Tune.RPM) and 60 / Tune.RPM or 0.1
local autoReady = gun_config.AutoShoot
and not (gun_config.AutoShootKey and not autoShootHeld)
and Now - lastAutoShot >= math.max(gun_config.AutoShootDelay, MinDelay)
if not (triggerReady or autoReady) then return end
local Target, ScreenDistance = GetClosest()
if not Target then return end
if triggerReady and ScreenDistance and ScreenDistance <= gun_config.TriggerRadius then
if not (gun_config.TriggerVisibleCheck and not hasLineOfSight(Target)) then
lastTriggerShot = Now
mouse1click()
end
end
if not autoReady then return end
if gun_config.AutoShootVisibleCheck and not hasLineOfSight(Target) then return end
lastAutoShot = Now
pcall(function() Firearm:Discharge() end)
end))
local bullet_config = {
Enabled = false,
Width = 0.1,
Lifetime = 1,
Color = Color3.fromRGB(255, 220, 60)
}
local Debris = game:GetService('Debris')
local TweenService = game:GetService('TweenService')
local TRACER_RANGE = 2000
local BulletDischarge
for _, Function in filtergc('function', {Name = 'Discharge'}, false) do
for _, Constant in getconstants(Function) do
if Constant == 'OriginCFrame' then BulletDischarge = Function break end
end
if BulletDischarge then break end
end
local function DrawBulletTracer(Origin, Shooter)
local Params = RaycastParams.new()
Params.FilterType = Enum.RaycastFilterType.Exclude
Params.FilterDescendantsInstances = {Shooter, Camera}
local Result = Workspace:Raycast(Origin.Position, Origin.LookVector * TRACER_RANGE, Params)
local Finish = Result and Result.Position or (Origin.Position + Origin.LookVector * TRACER_RANGE)
local Length = (Finish - Origin.Position).Magnitude
if Length < 1 then return end
local Width = bullet_config.Width
local Lifetime = bullet_config.Lifetime
local Beam = Instance.new('Part')
Beam.Anchored = true
Beam.CanCollide = false
Beam.CanQuery = false
Beam.CanTouch = false
Beam.CastShadow = false
Beam.Material = Enum.Material.Neon
Beam.Color = bullet_config.Color
Beam.Size = Vector3.new(Width, Width, Length)
Beam.CFrame = CFrame.lookAt(Origin.Position:Lerp(Finish, 0.5), Finish)
Beam.Parent = Camera
TweenService:Create(Beam, TweenInfo.new(Lifetime), {Transparency = 1}):Play()
Debris:AddItem(Beam, Lifetime)
end
do
local OldBulletDischarge; OldBulletDischarge = Hook(BulletDischarge, function(Self, Origin, ...)
if Kali.Running and bullet_config.Enabled and typeof(Origin) == 'CFrame' then
local Shooter = select(7, ...)
task.spawn(DrawBulletTracer, Origin, typeof(Shooter) == 'Instance' and Shooter or nil)
end
return OldBulletDischarge(Self, Origin, ...)
end)
end
local player_config = {
WalkSpeed = false,
SpeedMultiplier = 1.5,
SprintMultiplier = 2,
Fly = false,
FlySpeed = 25,
InfiniteStamina = false,
NoJumpCooldown = false,
JumpPower = false,
JumpPowerValue = 35,
NoProneDelay = false
}
local function GetController()
GetActors()
local Local = ActorService and ActorService.LocalActor
local Controller = Local and rawget(Local, 'Controller')
return type(Controller) == 'table' and Controller or nil
end
local Accelerate = filtergc('function', {Name = '_accelerate', Constants = {'SPEED_MULT'}}, true)
local Exhaust = filtergc('function', {Name = '_exhaust', Constants = {'_exhaustStart'}}, true)
local ControllerJump= filtergc('function', {Name = 'Jump', Constants = {'DoJump'}}, true)
local HeightState = filtergc('function', {Name = 'SetHeightState', Constants = {'ProneDelay'}}, true)
do
local OldAccelerate; OldAccelerate = Hook(Accelerate, function(Self, ...)
local Result = OldAccelerate(Self, ...)
if player_config.WalkSpeed and type(Self) == 'table' and type(Self.MoveSpeed) == 'number' then
local Multiplier = player_config.SpeedMultiplier
if Self.IsSprinting then Multiplier *= player_config.SprintMultiplier end
Self.MoveSpeed *= Multiplier
end
return Result
end)
local OldExhaust; OldExhaust = Hook(Exhaust, function(Self, ...)
if player_config.InfiniteStamina and type(Self) == 'table' then
Self._exhausted = 0
return
end
return OldExhaust(Self, ...)
end)
local OldJump; OldJump = Hook(ControllerJump, function(Self, ...)
if player_config.NoJumpCooldown and type(Self) == 'table' then Self.IsGrounded = true end
local Result = OldJump(Self, ...)
if player_config.JumpPower and type(Self) == 'table'
and type(Self.VelocityGravity) == 'number' and Self.VelocityGravity > 0 then
Self.VelocityGravity = player_config.JumpPowerValue
end
return Result
end)
local OldHeightState; OldHeightState = Hook(HeightState, function(Self, ...)
local Result = OldHeightState(Self, ...)
if player_config.NoProneDelay and type(Self) == 'table' then
local Local = rawget(Self, '_localActor')
if type(Local) == 'table' then Local.ProneDelay = 0 end
end
return Result
end)
end
Kali.track(RunService.RenderStepped:Connect(function(deltaTime)
if not player_config.Fly then return end
if UserInputService:GetFocusedTextBox() then return end
local Controller = GetController()
if not Controller then return end
local Move = Vector3.zero
local Look = Camera.CFrame
if UserInputService:IsKeyDown(Enum.KeyCode.W) then Move += Look.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.S) then Move -= Look.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.D) then Move += Look.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.A) then Move -= Look.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Move += Vector3.yAxis end
if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Move -= Vector3.yAxis end
local Position = rawget(Controller, '_position')
if typeof(Position) ~= 'Vector3' then return end
if Move.Magnitude > 0 then
Position += Move.Unit * player_config.FlySpeed * deltaTime
end
pcall(function() Controller:Teleport(CFrame.new(Position)) end)
end))
local boxChamsSettings = {
Enabled = false,
Color = Color3.fromRGB(255, 0, 255),
Transparency = 0.5,
OutlineEnabled = true,
OutlineColor = Color3.fromRGB(0, 0, 0),
OutlineTransparency = 0.7,
OutlineScale = 1.15
}
local boxChamsParts = {
"Head", "LeftFoot", "LeftHand", "LeftLowerArm", "LeftLowerLeg", "LeftUpperArm", "LeftUpperLeg",
"LowerTorso", "RightFoot", "RightHand", "RightLowerArm", "RightLowerLeg", "RightUpperArm", "RightUpperLeg", "UpperTorso"
}
local boxChamsInstances = {}
local nextBoxChamsScan = 0
local function createBoxChams(part)
if not (part:IsA("MeshPart") or part:IsA("BasePart")) then return end
if boxChamsInstances[part] then return end
local box = Instance.new("BoxHandleAdornment")
box.Adornee = part; box.AlwaysOnTop = true; box.ZIndex = 10
box.Size = part.Size; box.Color3 = boxChamsSettings.Color
box.Transparency = boxChamsSettings.Transparency; box.Parent = part
local outlineBox = Instance.new("BoxHandleAdornment")
outlineBox.Adornee = part; outlineBox.AlwaysOnTop = false; outlineBox.ZIndex = 9
outlineBox.Size = part.Size * boxChamsSettings.OutlineScale
outlineBox.Color3 = boxChamsSettings.OutlineColor
outlineBox.Transparency = boxChamsSettings.OutlineTransparency
outlineBox.Parent = part; outlineBox.Visible = boxChamsSettings.OutlineEnabled
boxChamsInstances[part] = {main = box, outline = outlineBox}
end
local function removeBoxChams(part)
local pair = boxChamsInstances[part]
if pair then
if pair.main and pair.main.Parent then pair.main:Destroy() end
if pair.outline and pair.outline.Parent then pair.outline:Destroy() end
end
boxChamsInstances[part] = nil
end
local function updateAllBoxChams()
for part, pair in pairs(boxChamsInstances) do
if pair.main and pair.main.Parent then
pair.main.Color3 = boxChamsSettings.Color; pair.main.Transparency = boxChamsSettings.Transparency
end
if pair.outline and pair.outline.Parent then
pair.outline.Color3 = boxChamsSettings.OutlineColor; pair.outline.Transparency = boxChamsSettings.OutlineTransparency
pair.outline.Size = part.Size * boxChamsSettings.OutlineScale; pair.outline.Visible = boxChamsSettings.OutlineEnabled
end
end
end
local function disableBoxChams()
for part, pair in boxChamsInstances do
if pair.main and pair.main.Parent then pair.main:Destroy() end
if pair.outline and pair.outline.Parent then pair.outline:Destroy() end
end
table.clear(boxChamsInstances)
end
table.insert(Kali.Restore, disableBoxChams)
local function refreshBoxChams()
local Actors = GetActors()
if not Actors then return end
local Used = 0
for _, Actor in Actors do
if Used >= MAX_TARGETS then break end
if type(Actor) ~= 'table' or Actor.IsLocalPlayer or not Actor.Alive then continue end
local Parts = Actor.Parts
if type(Parts) ~= 'table' then continue end
Used += 1
for _, partName in boxChamsParts do
local part = Parts[partName]
if part and part.Parent and not boxChamsInstances[part] then createBoxChams(part) end
end
end
for part in boxChamsInstances do
if not part.Parent then removeBoxChams(part) end
end
end
local function toggleBoxChams(state)
boxChamsSettings.Enabled = state
nextBoxChamsScan = 0
if not state then disableBoxChams() end
end
pcall(function() RunService:UnbindFromRenderStep("MaleESP") end)
RunService:BindToRenderStep("MaleESP", Enum.RenderPriority.Camera.Value, function()
pcall(updateESP)
if boxChamsSettings.Enabled and os.clock() >= nextBoxChamsScan then
nextBoxChamsScan = os.clock() + 0.5
pcall(refreshBoxChams)
end
end)
espRunning = true
Kali.track(LocalPlayer.OnTeleport:Connect(function() cleanupESP() end))
local stored_fonts = {}
local gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 150, MaxHeight = 680, InitialHeight = 470,
MinWidth = 350, MaxWidth = 800, InitialWidth = 520
}
for _, v in Enum.Font:GetEnumItems() do table.insert(stored_fonts, v.Name) end
local library
local window
do
local parent = gethui()
local beforeGuis = {}
for _, child in parent:GetChildren() do beforeGuis[child] = true end
library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
window = library:CreateWindow(gui_config, parent)
for _, child in parent:GetChildren() do
if not beforeGuis[child] then table.insert(Kali.Guis, child) end
end
end
library:SetWindowName("Kali Hub | Blackhawk Rescue Mission 5")
local tabs = {
combat = window:CreateTab("Combat"),
visuals = window:CreateTab("Visuals"),
player = window:CreateTab("Player"),
settings = window:CreateTab("Settings")
}
local player_section = tabs.player:CreateSection("Player")
local m_aimbot_section = tabs.combat:CreateSection("Aimbot")
local combat_section = tabs.combat:CreateSection("Silent Aim", "right")
local gun_mods_section = tabs.combat:CreateSection("Gun Modifications", "right")
local fov_section = tabs.combat:CreateSection("FOV", "left")
local crosshair_section = tabs.combat:CreateSection("Crosshair", "left")
local enemy_esp_section = tabs.visuals:CreateSection("Enemy ESP")
local npc_esp_section = tabs.visuals:CreateSection("NPC ESP", "right")
local team_esp_section = tabs.visuals:CreateSection("Team ESP")
local esp_set_section = tabs.visuals:CreateSection("ESP Settings", "right")
local vehicle_section = tabs.visuals:CreateSection("Vehicle ESP")
local world_section = tabs.visuals:CreateSection("World", "right")
local chams_section = tabs.visuals:CreateSection("Chams")
local tracer_section = tabs.visuals:CreateSection("Bullet Tracers", "right")
local rainbow_section = tabs.visuals:CreateSection("Rainbow")
local camera_section = tabs.visuals:CreateSection("Camera", "right")
local settings_section = tabs.settings:CreateSection("Settings")
combat_section:CreateToggle("Silent Aim", aim_config.SilentAim, function(value)
aim_config.SilentAim = value
end)
combat_section:CreateToggle("Team Check", aim_config.TeamCheck, function(value)
aim_config.TeamCheck = value
end)
combat_section:CreateToggle("Target Players", aim_config.TargetPlayers, function(value)
aim_config.TargetPlayers = value
end)
combat_section:CreateToggle("Target NPCs", aim_config.TargetNPCs, function(value)
aim_config.TargetNPCs = value
end)
combat_section:CreateToggle("Use FOV", aim_config.UseFov, function(value)
aim_config.UseFov = value
end)
combat_section:CreateToggle("Visible Check", aim_config.VisibleCheck, function(value)
aim_config.VisibleCheck = value
end)
combat_section:CreateSlider("Hit Chance", 0, 100, aim_config.HitChance, true, function(value)
aim_config.HitChance = value
end)
combat_section:CreateDropdown("Target Part", HitboxNames,
function(value) aim_config.Hitbox = HitboxParts[value] or "Head" end,
"Head", false)
combat_section:CreateToggle("Show Target Line", aim_config.TargetLine, function(value)
aim_config.TargetLine = value
end)
combat_section:CreateColorpicker("Target Line Color", function(color)
aim_config.TargetLineColor = color
end)
m_aimbot_section:CreateToggle("Aimbot", aimbotConfig.Enabled, function(state)
aimbotConfig.Enabled = state
end)
m_aimbot_section:CreateToggle("Use FOV", aimbotConfig.UseFov, function(state)
aimbotConfig.UseFov = state
end)
m_aimbot_section:CreateToggle("Show Aimbot FOV", aimbotConfig.FovVisible, function(state)
aimbotConfig.FovVisible = state
Drawings.AimbotFov.Visible = state
end)
m_aimbot_section:CreateSlider("Aimbot FOV Size", 10, 1000, aimbotConfig.FovRadius, true, function(value)
aimbotConfig.FovRadius = value
Drawings.AimbotFov.Radius = value
end)
m_aimbot_section:CreateColorpicker("Aimbot FOV Color", function(color)
Drawings.AimbotFov.Color = color
end)
m_aimbot_section:CreateToggle("Stick to Target", aimbotConfig.StickToTarget, function(state)
aimbotConfig.StickToTarget = state
end)
m_aimbot_section:CreateDropdown("Keybind",
{"RightClick", "LeftClick", "Q", "E", "C", "F", "Shift"},
function(value)
if value == "RightClick" then aimbotConfig.Keybind = Enum.UserInputType.MouseButton2
elseif value == "LeftClick" then aimbotConfig.Keybind = Enum.UserInputType.MouseButton1
else aimbotConfig.Keybind = Enum.KeyCode[value] end
end, "RightClick", false)
m_aimbot_section:CreateDropdown("Target Part", HitboxNames,
function(value) aimbotConfig.TargetPart = HitboxParts[value] or "Head" end,
"Head", false)
m_aimbot_section:CreateSlider("Smoothing", 0.05, 1, aimbotConfig.Smoothing, false, function(value)
aimbotConfig.Smoothing = value
end)
m_aimbot_section:CreateSlider("Prediction", 0.02, 1, aimbotConfig.Prediction, false, function(value)
aimbotConfig.Prediction = value
end)
m_aimbot_section:CreateToggle("Wall Check", aimbotConfig.WallCheck, function(state)
aimbotConfig.WallCheck = state
end)
m_aimbot_section:CreateToggle("Team Check", aimbotConfig.TeamCheck, function(state)
aimbotConfig.TeamCheck = state
end)
gun_mods_section:CreateToggle("No Recoil", aim_config.NoRecoil, function(value)
aim_config.NoRecoil = value
end)
gun_mods_section:CreateToggle("No Spread", aim_config.NoSpread, function(value)
aim_config.NoSpread = value
end)
gun_mods_section:CreateToggle("No ADS", gun_config.NoADS, function(value)
gun_config.NoADS = value
end)
gun_mods_section:CreateToggle("No Sway", gun_config.NoSway, function(value)
gun_config.NoSway = value
end)
gun_mods_section:CreateToggle("Fire Mode Override", gun_config.FireModeOverride, function(value)
gun_config.FireModeOverride = value
end)
gun_mods_section:CreateDropdown("Fire Mode", {"Auto", "Semi", "Burst", "Safe"}, function(value)
gun_config.FireMode = FiremodeIds[value] or 2
end, "Auto", false)
gun_mods_section:CreateToggle("Fast Fire Rate", gun_config.FastFireRate, function(value)
gun_config.FastFireRate = value
end)
gun_mods_section:CreateSlider("Fire Rate Multiplier", 1, 10, gun_config.FireRateMultiplier, false, function(value)
gun_config.FireRateMultiplier = value
end)
gun_mods_section:CreateToggle("Instant Hit", gun_config.InstantHit, function(value)
gun_config.InstantHit = value
end)
gun_mods_section:CreateToggle("No Shoot Delay", gun_config.NoShootDelay, function(value)
gun_config.NoShootDelay = value
end)
gun_mods_section:CreateToggle("Instant Equip", gun_config.InstantEquip, function(value)
gun_config.InstantEquip = value
end)
gun_mods_section:CreateToggle("Auto Shoot", gun_config.AutoShoot, function(value)
gun_config.AutoShoot = value
end)
gun_mods_section:CreateToggle("Auto Shoot Visible Check", gun_config.AutoShootVisibleCheck, function(value)
gun_config.AutoShootVisibleCheck = value
end)
gun_mods_section:CreateSlider("Fire Delay", 0, 1, gun_config.AutoShootDelay, false, function(value)
gun_config.AutoShootDelay = value
end)
gun_mods_section:CreateDropdown("Auto Shoot Key",
{"None", "RightClick", "LeftClick", "Q", "E", "C", "F", "Shift"},
function(value)
if value == "None" then gun_config.AutoShootKey = nil
elseif value == "RightClick" then gun_config.AutoShootKey = Enum.UserInputType.MouseButton2
elseif value == "LeftClick" then gun_config.AutoShootKey = Enum.UserInputType.MouseButton1
else gun_config.AutoShootKey = Enum.KeyCode[value] end
end, "None", false)
local trigger_section = tabs.combat:CreateSection("Trigger Bot", "right")
trigger_section:CreateToggle("Trigger Bot", gun_config.TriggerBot, function(value)
gun_config.TriggerBot = value
end)
trigger_section:CreateToggle("Visible Check", gun_config.TriggerVisibleCheck, function(value)
gun_config.TriggerVisibleCheck = value
end)
trigger_section:CreateSlider("Trigger Radius", 1, 60, gun_config.TriggerRadius, true, function(value)
gun_config.TriggerRadius = value
end)
trigger_section:CreateSlider("Trigger Delay", 0, 1, gun_config.TriggerDelay, false, function(value)
gun_config.TriggerDelay = value
end)
trigger_section:CreateLabel("Fires only when your own crosshair is already on a target")
local function BuildESPSection(section, key, label, options)
local settings = esp_categories[key]
section:CreateToggle(label, settings.Enabled, function(state)
settings.Enabled = state
end)
for _, option in options do
local field = option[2]
section:CreateToggle(option[1], settings[field], function(state)
settings[field] = state
end)
end
section:CreateColorpicker(label .. " Color", function(color)
settings.Color = color
end)
end
BuildESPSection(enemy_esp_section, "Enemy", "Enemy ESP", {
{"Box", "Box"}, {"Box Fill", "BoxFill"}, {"3D Box", "Box3D"},
{"Health Bar", "HealthBar"}, {"Health Text", "HealthText"},
{"Name", "Name"}, {"Distance", "Distance"}, {"Weapon", "Weapon"},
{"Chams", "Chams"}, {"Tracers", "Tracers"}, {"Off Screen Arrow", "OffScreenArrow"}
})
BuildESPSection(npc_esp_section, "NPC", "NPC ESP", {
{"Box", "Box"}, {"Box Fill", "BoxFill"},
{"Health Bar", "HealthBar"}, {"Health Text", "HealthText"},
{"Name", "Name"}, {"Distance", "Distance"}, {"Weapon", "Weapon"},
{"Chams", "Chams"}, {"Tracers", "Tracers"}, {"Off Screen Arrow", "OffScreenArrow"}
})
BuildESPSection(team_esp_section, "Team", "Team ESP", {
{"Box", "Box"}, {"Box Fill", "BoxFill"}, {"3D Box", "Box3D"},
{"Health Bar", "HealthBar"}, {"Health Text", "HealthText"},
{"Name", "Name"}, {"Distance", "Distance"}, {"Weapon", "Weapon"},
{"Chams", "Chams"}, {"Tracers", "Tracers"}
})
esp_set_section:CreateToggle("Team Check", esp_config.TeamCheck, function(state)
esp_config.TeamCheck = state
end)
esp_set_section:CreateToggle("Show Players", esp_config.ShowPlayers, function(state)
esp_config.ShowPlayers = state
end)
esp_set_section:CreateToggle("Show NPCs", esp_config.ShowNPCs, function(state)
esp_config.ShowNPCs = state
end)
esp_set_section:CreateToggle("Show Vehicles", esp_config.ShowVehicles, function(state)
esp_config.ShowVehicles = state
end)
esp_set_section:CreateToggle("Limit Distance", esp_config.LimitDistance, function(state)
esp_config.LimitDistance = state
end)
esp_set_section:CreateSlider("Max Distance", 100, 5000, esp_config.MaxDistance, true, function(value)
esp_config.MaxDistance = value
end)
esp_set_section:CreateSlider("Text Size", 8, 24, esp_config.TextSize, true, function(value)
esp_config.TextSize = value
end)
esp_set_section:CreateDropdown("Tracer Origin", {"Bottom", "Top", "Mouse"}, function(value)
esp_config.TracerOrigin = value
end, "Bottom", false)
BuildESPSection(vehicle_section, "Vehicle", "Vehicle ESP", {
{"Box", "Box"}, {"Box Fill", "BoxFill"},
{"Health Bar", "HealthBar"}, {"Health Text", "HealthText"},
{"Name", "Name"}, {"Distance", "Distance"},
{"Tracers", "Tracers"}, {"Off Screen Arrow", "OffScreenArrow"}
})
vehicle_section:CreateLabel("Name shows the model, e.g. MD500 or Ural4320")
world_section:CreateToggle("No Leaves", world_config.NoLeaves, function(state)
toggleLeaves(state)
end)
world_section:CreateToggle("No Shadows", world_config.NoShadows, function(state)
toggleShadows(state)
end)
world_section:CreateToggle("No Clouds", world_config.NoClouds, function(state)
toggleClouds(state)
end)
world_section:CreateToggle("No Lighting", world_config.NoLighting, function(state)
toggleLighting(state)
end)
chams_section:CreateToggle("BoxChams", boxChamsSettings.Enabled, function(state)
toggleBoxChams(state)
end)
chams_section:CreateColorpicker("Chams Color", function(color, trans)
boxChamsSettings.Color = color; boxChamsSettings.Transparency = trans; updateAllBoxChams()
end)
chams_section:CreateToggle("Outline Enabled", boxChamsSettings.OutlineEnabled, function(state)
boxChamsSettings.OutlineEnabled = state; updateAllBoxChams()
end)
chams_section:CreateColorpicker("Outline Color", function(color, trans)
boxChamsSettings.OutlineColor = color; boxChamsSettings.OutlineTransparency = trans; updateAllBoxChams()
end)
chams_section:CreateSlider("Outline Scale", 1.01, 1.5, boxChamsSettings.OutlineScale, false, function(value)
boxChamsSettings.OutlineScale = value; updateAllBoxChams()
end)
tracer_section:CreateToggle("Bullet Tracers", bullet_config.Enabled, function(state)
bullet_config.Enabled = state
end)
tracer_section:CreateSlider("Width", 0.05, 0.5, bullet_config.Width, false, function(value)
bullet_config.Width = value
end)
tracer_section:CreateSlider("Lifetime", 0.1, 5, bullet_config.Lifetime, false, function(value)
bullet_config.Lifetime = value
end)
tracer_section:CreateColorpicker("Tracer Color", function(color)
bullet_config.Color = color
end)
rainbow_section:CreateToggle("Weapon", rainbow_config.Weapon, function(state)
rainbow_config.Weapon = state
if not state then RestoreWeaponColors() end
end)
rainbow_section:CreateToggle("FOV Circle", rainbow_config.Fov, function(state)
rainbow_config.Fov = state
end)
rainbow_section:CreateToggle("Crosshair", rainbow_config.Crosshair, function(state)
rainbow_config.Crosshair = state
end)
rainbow_section:CreateToggle("ESP / Target Line", rainbow_config.Esp, function(state)
rainbow_config.Esp = state
end)
rainbow_section:CreateSlider("Speed", 1, 20, rainbow_config.Speed, false, function(value)
rainbow_config.Speed = value
end)
camera_section:CreateToggle("Custom FOV", fov_config.Enabled, function(state)
fov_config.Enabled = state
if not state then Camera.FieldOfView = DEFAULT_FOV end
end)
camera_section:CreateSlider("FOV", 70, 120, fov_config.Value, true, function(value)
fov_config.Value = value
end)
player_section:CreateToggle("WalkSpeed", player_config.WalkSpeed, function(state)
player_config.WalkSpeed = state
end)
player_section:CreateSlider("Speed Multiplier", 1, 5, player_config.SpeedMultiplier, false, function(value)
player_config.SpeedMultiplier = value
end)
player_section:CreateSlider("Sprint Multiplier", 1, 5, player_config.SprintMultiplier, false, function(value)
player_config.SprintMultiplier = value
end)
player_section:CreateToggle("Fly", player_config.Fly, function(state)
player_config.Fly = state
end)
player_section:CreateSlider("Fly Speed", 10, 200, player_config.FlySpeed, true, function(value)
player_config.FlySpeed = value
end)
player_section:CreateToggle("Infinite Stamina", player_config.InfiniteStamina, function(state)
player_config.InfiniteStamina = state
end)
player_section:CreateToggle("No Jump Cooldown", player_config.NoJumpCooldown, function(state)
player_config.NoJumpCooldown = state
end)
player_section:CreateToggle("Jump Power", player_config.JumpPower, function(state)
player_config.JumpPower = state
end)
player_section:CreateSlider("Jump Power", 20, 100, player_config.JumpPowerValue, true, function(value)
player_config.JumpPowerValue = value
end)
player_section:CreateToggle("No Prone Delay", player_config.NoProneDelay, function(state)
player_config.NoProneDelay = state
end)
player_section:CreateLabel("Fly: WASD + Space / Left Ctrl")
local fov_toggle = fov_section:CreateToggle("Show FOV", aim_config.FovVisible, function(value)
aim_config.FovVisible = value
if Drawings.FovOutline then Drawings.FovOutline.Visible = value end
if Drawings.FovInline then Drawings.FovInline.Visible = value end
end)
fov_section:CreateColorpicker("FOV Color", function(color, transparency)
aim_config.FovColor = color; aim_config.FovTransparency = 1 - transparency
if Drawings.FovInline then
Drawings.FovInline.Color = color; Drawings.FovInline.Transparency = aim_config.FovTransparency
if Drawings.FovOutline then Drawings.FovOutline.Transparency = aim_config.FovTransparency end
end
end, false, false, fov_toggle)
fov_section:CreateSlider("FOV Size", 1, 1000, aim_config.FovRadius, true, function(value)
aim_config.FovRadius = value
if Drawings.FovOutline then Drawings.FovOutline.Radius = value end
if Drawings.FovInline then Drawings.FovInline.Radius = value end
end)
fov_section:CreateSlider("FOV Thickness", 1, 10, aim_config.FovThickness, false, function(value)
aim_config.FovThickness = value
if Drawings.FovOutline then Drawings.FovOutline.Thickness = value + 2 end
if Drawings.FovInline then Drawings.FovInline.Thickness = value end
end)
crosshair_section:CreateToggle("Crosshair", crosshairSettings.Enabled, function(state)
crosshairSettings.Enabled = state
end)
crosshair_section:CreateDropdown("Position", {"Center", "Mouse"}, function(value)
crosshairSettings.Position = value
end, "Center", false)
crosshair_section:CreateSlider("Size", 1, 25, crosshairSettings.Size, true, function(val)
crosshairSettings.Size = val
end)
crosshair_section:CreateSlider("Gap Size", 0, 25, crosshairSettings.GapSize, true, function(val)
crosshairSettings.GapSize = val
end)
crosshair_section:CreateSlider("Thickness", 1, 5, crosshairSettings.Thickness, true, function(val)
crosshairSettings.Thickness = val
end)
crosshair_section:CreateColorpicker("Crosshair Color", function(color, trans)
crosshairSettings.Color = color
end)
crosshair_section:CreateToggle("Center Dot", crosshairSettings.CenterDot, function(state)
crosshairSettings.CenterDot = state
end)
settings_section:CreateDropdown("Change Font", stored_fonts, function(value)
window:SetFont(value)
end, "", false)
local cleanKeyName = tostring(gui_config.Keybind):gsub("Enum.KeyCode.", "")
settings_section:CreateLabel("Close Menu (PC): " .. cleanKeyName)
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
getgenv().KaliUnload = function()
Kali.Running = false
for _, config in {aim_config, aimbotConfig, gun_config, bullet_config, player_config,
fov_config, rainbow_config, crosshairSettings, boxChamsSettings,
world_config} do
for key, value in config do
if type(value) == "boolean" then config[key] = false end
end
end
for _, category in esp_categories do category.Enabled = false end
espRunning = false
pcall(function() RunService:UnbindFromRenderStep("MaleESP") end)
for _, restore in Kali.Restore do pcall(restore) end
table.clear(Kali.Restore)
for _, connection in Kali.Connections do
pcall(function() connection:Disconnect() end)
end
table.clear(Kali.Connections)
for _, object in Kali.Drawings do
pcall(function() object:Remove() end)
end
table.clear(Kali.Drawings)
table.clear(espPool)
Camera.FieldOfView = DEFAULT_FOV
ActorService = nil
VehicleService = nil
ClientService = nil
CurrentFirearm = nil
pcall(function() window:Destroy() end)
for _, gui in Kali.Guis do
pcall(function() gui:Destroy() end)
end
table.clear(Kali.Guis)
end
