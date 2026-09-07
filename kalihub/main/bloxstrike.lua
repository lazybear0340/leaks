local genv = getgenv()
local _ = genv.debug
local _ = genv.debug
local _ = genv.debug
local Beta = false
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local RepStore = game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")
local LP = Players.LocalPlayer
local _rid = HS:GenerateGUID(false)
local _st = tick()
if getgenv().KaliHubCleanup then
getgenv().KaliHubCleanup()
end
local Conn, Drws = {}, {}
local originalHeadSizes = {}
local function AC(c)
if c then Conn[#Conn + 1] = c end
end
local function AD(d)
if d and type(d) ~= "number" then Drws[#Drws + 1] = d end
end
local function Safe(f)
return function(...)
pcall(f, ...)
end
end
local WorldESP = {DroppedWeapons = {}, Bomb = nil, Molotovs = {}, Smokes = {}}
local function DestroyWESP(e)
if not e then return end
for _, d in pairs(e.Box or {}) do
if d and type(d) ~= "number" then pcall(d.Remove, d) end
end
if e.Name and type(e.Name) ~= "number" then pcall(e.Name.Remove, e.Name) end
if e.HL then pcall(e.HL.Destroy, e.HL) end
if e.Radius and type(e.Radius) ~= "number" then pcall(e.Radius.Remove, e.Radius) end
end
getgenv().KaliHubCleanup = function()
for _, c in pairs(Conn) do pcall(function() c:Disconnect() end) end
for _, d in pairs(Drws) do pcall(function() if type(d) ~= "number" then d:Remove() end end) end
table.clear(Conn)
table.clear(Drws)
pcall(function()
if game:GetService("CoreGui"):FindFirstChild("KaliHubUI") then
game:GetService("CoreGui").KaliHubUI:Destroy()
end
end)
pcall(function()
if game:GetService("CoreGui"):FindFirstChild("ESP_Highlight_Container") then
game:GetService("CoreGui").ESP_Highlight_Container:Destroy()
end
end)
pcall(function()
if game:GetService("CoreGui"):FindFirstChild("Charms_Container") then
game:GetService("CoreGui").Charms_Container:Destroy()
end
end)
for _, eo in pairs(WorldESP.DroppedWeapons) do DestroyWESP(eo) end
if WorldESP.Bomb then DestroyWESP(WorldESP.Bomb) end
for _, eo in pairs(WorldESP.Molotovs) do DestroyWESP(eo) end
for _, eo in pairs(WorldESP.Smokes) do DestroyWESP(eo) end
table.clear(WorldESP.DroppedWeapons)
WorldESP.Bomb = nil
table.clear(WorldESP.Molotovs)
table.clear(WorldESP.Smokes)
pcall(function()
if workspace:FindFirstChild("_KaliHubActors") then
workspace._KaliHubActors:Destroy()
end
end)
pcall(function()
for head, size in originalHeadSizes do
if head and head.Parent then
head.Size = size
head.Transparency = 0
end
end
end)
end
local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local G = {
mousemoverel = mousemoverel or (mousemove and function(x, y) mousemove(x, y) end) or function() end,
mouse1click = mouse1click or mouse_click or function() end,
C3W = Color3.new(1, 1, 1),
C3B = Color3.new(0, 0, 0),
LastCharmVisCheck = 0,
LastCharmScan = 0,
LastCharmUpdate = 0,
FrameCount = 0,
lastFPSUpdate = tick(),
LastESPUpdate = 0,
lastTriggerTime = 0,
LocalCharacter = nil,
AimbotActive = false,
TriggerbotActive = false,
knifeChangerSupported = true,
executor = (identifyexecutor and identifyexecutor()) or "Unknown",
hasFileSystem = false,
inspectWarningShown = false,
LastMouseReleaseTime = 0,
skinApplyDebounce = false,
lastInvRefresh = 0,
LastWorldScan = 0,
WallbangCache = {},
}
pcall(function()
if writefile and readfile then G.hasFileSystem = true end
end)
local function SafeRequire(module)
if not module then return nil end
local success, result = pcall(function() return require(module) end)
if success and result and type(result) == "table" then return result end
return nil
end
local SD = {SkinsRoot = nil, SkinSelections = {}, GloveSelections = {}, GloveFolders = {}}
pcall(function()
SD.SkinsRoot = RepStore:FindFirstChild("Assets") and RepStore.Assets:FindFirstChild("Skins")
end)
if SD.SkinsRoot then
pcall(function()
for _, wf in ipairs(SD.SkinsRoot:GetChildren()) do
local skins = {}
for _, sf in ipairs(wf:GetChildren()) do skins[#skins + 1] = sf.Name end
table.sort(skins)
SD.SkinSelections[wf.Name] = skins
end
for _, folder in ipairs(SD.SkinsRoot:GetChildren()) do
if (folder.Name:match("Glove") or folder.Name:match("Gloves") or folder.Name == "Hand Wraps")
and not (folder.Name:match("T Glove") or folder.Name:match("CT Glove")
or folder.Name:match("T Gloves") or folder.Name:match("CT Gloves")) then
SD.GloveFolders[#SD.GloveFolders + 1] = folder
end
end
end)
end
for _, gf in ipairs(SD.GloveFolders) do
local skins = {"Default"}
for _, skin in ipairs(gf:GetChildren()) do skins[#skins + 1] = skin.Name end
SD.GloveSelections[gf.Name] = skins
end
if string.find(G.executor, "RonixExploit", 1, true)
or string.find(G.executor, "Xeno", 1, true)
or string.find(G.executor, "Solara", 1, true) then
G.knifeChangerSupported = false
end
if not RepStore:FindFirstChild("database") then
local db = Instance.new("Folder")
db.Name = "database"
db.Parent = RepStore
end
local function RunOnActor(func)
local success = false
pcall(function()
if not workspace:FindFirstChild("_KaliHubActors") then
local af = Instance.new("Folder")
af.Name = "_KaliHubActors"
af.Parent = workspace
end
task.defer(func)
success = true
end)
if not success then pcall(func) end
end
local function GetUIParent()
if gethui then return gethui() end
return game:GetService("CoreGui")
end
local Parent = GetUIParent()
for _, child in pairs(Parent:GetChildren()) do
if child.Name == "KaliHubUI" then child:Destroy() end
end
pcall(function()
if game:GetService("CoreGui"):FindFirstChild("ESP_Highlight_Container") then
game:GetService("CoreGui").ESP_Highlight_Container:Destroy()
end
end)
local UI = Instance.new("ScreenGui")
UI.Name = "KaliHubUI"
UI.IgnoreGuiInset = true
UI.Parent = Parent
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local Themes = {
Default = {Main=Color3.fromRGB(20,20,20), Item=Color3.fromRGB(30,30,30), Outline=Color3.fromRGB(60,60,60), Accent=Color3.fromRGB(255,105,180), Text=Color3.fromRGB(255,255,255), TextDim=Color3.fromRGB(150,150,150), TextStroke=Color3.fromRGB(0,0,0)},
Dark = {Main=Color3.fromRGB(15,15,15), Item=Color3.fromRGB(25,25,25), Outline=Color3.fromRGB(40,40,40), Accent=Color3.fromRGB(100,100,255), Text=Color3.fromRGB(240,240,240), TextDim=Color3.fromRGB(140,140,140), TextStroke=Color3.fromRGB(0,0,0)},
Light = {Main=Color3.fromRGB(240,240,240), Item=Color3.fromRGB(225,225,225), Outline=Color3.fromRGB(150,150,150), Accent=Color3.fromRGB(0,140,255), Text=Color3.fromRGB(255,255,255), TextDim=Color3.fromRGB(180,180,180), TextStroke=Color3.fromRGB(0,0,0)},
Blood = {Main=Color3.fromRGB(20,10,10), Item=Color3.fromRGB(30,15,15), Outline=Color3.fromRGB(60,30,30), Accent=Color3.fromRGB(220,40,40), Text=Color3.fromRGB(255,200,200), TextDim=Color3.fromRGB(150,100,100), TextStroke=Color3.fromRGB(20,0,0)},
Ocean = {Main=Color3.fromRGB(10,20,30), Item=Color3.fromRGB(15,30,45), Outline=Color3.fromRGB(30,60,90), Accent=Color3.fromRGB(0,190,255), Text=Color3.fromRGB(200,240,255), TextDim=Color3.fromRGB(100,140,160), TextStroke=Color3.fromRGB(0,10,20)},
Forest = {Main=Color3.fromRGB(20,30,20), Item=Color3.fromRGB(30,45,30), Outline=Color3.fromRGB(50,80,50), Accent=Color3.fromRGB(100,200,100), Text=Color3.fromRGB(220,255,220), TextDim=Color3.fromRGB(120,160,120), TextStroke=Color3.fromRGB(10,20,10)},
Midnight = {Main=Color3.fromRGB(15,15,30), Item=Color3.fromRGB(25,25,45), Outline=Color3.fromRGB(40,40,70), Accent=Color3.fromRGB(100,100,200), Text=Color3.fromRGB(220,220,255), TextDim=Color3.fromRGB(120,120,160), TextStroke=Color3.fromRGB(10,10,20)},
Sunset = {Main=Color3.fromRGB(30,20,20), Item=Color3.fromRGB(45,30,30), Outline=Color3.fromRGB(80,50,50), Accent=Color3.fromRGB(255,150,50), Text=Color3.fromRGB(255,230,220), TextDim=Color3.fromRGB(180,140,130), TextStroke=Color3.fromRGB(20,10,10)},
}
local CurrentTheme = Themes.Default
local ThemeRegistry = {}
local function AddThemeObject(obj, tt)
if not obj then return end
if not ThemeRegistry[tt] then ThemeRegistry[tt] = {} end
ThemeRegistry[tt][#ThemeRegistry[tt] + 1] = obj
pcall(function()
if tt == "Main" then obj.BackgroundColor3 = CurrentTheme.Main
elseif tt == "Item" then obj.BackgroundColor3 = CurrentTheme.Item
elseif tt == "Outline" then
if obj:IsA("UIStroke") then obj.Color = CurrentTheme.Outline
elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then obj.BorderColor3 = CurrentTheme.Outline end
elseif tt == "Accent" then
if obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextColor3 = CurrentTheme.Accent
else obj.BackgroundColor3 = CurrentTheme.Accent end
elseif tt == "Text" then
obj.TextColor3 = CurrentTheme.Text
if obj:IsA("TextLabel") or obj:IsA("TextButton") then
obj.TextStrokeTransparency = 0
obj.TextStrokeColor3 = CurrentTheme.TextStroke
end
elseif tt == "TextDim" then obj.TextColor3 = CurrentTheme.TextDim end
end)
end
local function CleanThemeRegistry()
for tt, objs in pairs(ThemeRegistry) do
local c = {}
for _, o in pairs(objs) do
local a = false
pcall(function() a = (o.Parent ~= nil) or (o.Visible ~= nil) end)
if a then c[#c + 1] = o end
end
ThemeRegistry[tt] = c
end
end
local function RefreshTheme()
for tt, objs in pairs(ThemeRegistry) do
for _, o in pairs(objs) do
pcall(function()
if tt == "Main" then o.BackgroundColor3 = CurrentTheme.Main
elseif tt == "Item" then o.BackgroundColor3 = CurrentTheme.Item
elseif tt == "Outline" then
if o:IsA("UIStroke") then o.Color = CurrentTheme.Outline
elseif o:IsA("Frame") or o:IsA("ScrollingFrame") then o.BorderColor3 = CurrentTheme.Outline end
elseif tt == "Accent" then
if o:IsA("TextLabel") or o:IsA("TextButton") then o.TextColor3 = CurrentTheme.Accent
else o.BackgroundColor3 = CurrentTheme.Accent end
elseif tt == "Text" then
o.TextColor3 = CurrentTheme.Text
if o:IsA("TextLabel") or o:IsA("TextButton") then
o.TextStrokeTransparency = 0
o.TextStrokeColor3 = CurrentTheme.TextStroke
end
elseif tt == "TextDim" then o.TextColor3 = CurrentTheme.TextDim end
end)
end
end
CleanThemeRegistry()
end
local function DeepCopy(orig)
local c = {}
for k, v in pairs(orig) do
if type(v) == "table" then v = DeepCopy(v) end
c[k] = v
end
return c
end
local SecondaryWeapons = {["USP-S"]=true,["Glock-18"]=true,["P250"]=true,["Five-SeveN"]=true,["Tec-9"]=true,["Dual Berettas"]=true,["Deagle"]=true,["R8 Revolver"]=true,["CZ75-Auto"]=true,["P2000"]=true}
local ScopedWeapons = {["AWP"]=true,["SSG 08"]=true,["G3SG1"]=true,["SCAR-20"]=true,["AUG"]=true,["SG 553"]=true}
local Camera = workspace.CurrentCamera
local Config = {
FOV = 100,
Aimbot = {
Enabled = false, TeamCheck = true, AliveCheck = true,
Smoothness = 4, TargetPart = "Head",
WallCheck = true, HoldKey = Enum.UserInputType.MouseButton2,
DrawFOV = true, Mode = "Hold"
},
Triggerbot = {Enabled = false, Delay = 0.05, TeamCheck = true, MobileSafe = IsMobile},
ESP = {
Enabled = true, Box = true, BoxOutline = false, BoxThickness = 1,
BoxFill = false, BoxFillColor1 = Color3.fromRGB(255,0,0), BoxFillColor2 = Color3.fromRGB(0,0,255),
BoxFillTransparency = 0.8, BoxFillFadeSpeed = 3,
Name = false, NameSize = 13, Health = true, Skeleton = true, SkeletonThickness = 2,
HeadDot = false, Highlight = false, Distance = false, TeamCheck = true,
VisibilityCheck = false, MaxDistance = 2000,
BoxColor = Color3.fromRGB(255,255,255),
BoxVisibleColor = Color3.fromRGB(0,255,0),
BoxNotVisibleColor = Color3.fromRGB(255,0,0),
NameColor = Color3.fromRGB(255,255,255),
NameVisibleColor = Color3.fromRGB(0,255,0),
NameNotVisibleColor = Color3.fromRGB(255,0,0),
SkeletonColor = Color3.fromRGB(255,255,255),
SkeletonVisibleColor = Color3.fromRGB(0,255,0),
SkeletonNotVisibleColor = Color3.fromRGB(255,0,0),
HeadDotColor = Color3.fromRGB(255,255,255),
HeadDotVisibleColor = Color3.fromRGB(0,255,0),
HeadDotNotVisibleColor = Color3.fromRGB(255,0,0),
HighlightFill = Color3.fromRGB(255,0,0),
HighlightOutline = Color3.fromRGB(255,255,255),
HighlightVisibleFill = Color3.fromRGB(0,255,0),
HighlightHiddenFill = Color3.fromRGB(255,0,0),
DistanceColor = Color3.fromRGB(255,255,255),
HealthBarCustom = false,
HealthBarColor = Color3.fromRGB(0,255,0),
CurrentWeapon = {Enabled = false, Color = Color3.fromRGB(255,255,255)},
Bomb = {Enabled = false, Box = true, Highlight = true, Name = true, Color = Color3.fromRGB(255,0,0)},
DroppedWeapons = {Enabled = false, Box = true, Highlight = true, Name = true, Color = Color3.fromRGB(255,255,255)},
Molotovs = {Enabled = false, Highlight = true, Color = Color3.fromRGB(255,165,0)},
Smokes = {Enabled = false, Highlight = true, Color = Color3.fromRGB(200,200,200)},
},
Charms = {Enabled=false, TeamCheck=true, VisibleColor=Color3.fromRGB(255,0,0), HiddenColor=Color3.fromRGB(255,255,255), Transparency=0.5, AlwaysOnTop=true},
SkinChanger = {Enabled=false, Skins={}},
KnifeChanger = {Enabled=false, Model="Karambit"},
GloveChanger = {Enabled=false, Gloves={}, Model="Sports Gloves", Skin="Default"},
AutoBhop = false,
BhopKey = Enum.KeyCode.Space,
Debug = false,
SpectatorList = false,
FlashRemover = false,
SmokeRemover = false,
Hitbox = {Enabled=false, Size=3},
Wallbang = false,
NoSpread = false,
NoRecoil = false,
InstantScope = false,
SilentAim = {Enabled=false, TargetPart="Head", TeamCheck=true, VisibleCheck=false, HitChance=100},
RageBot = {Enabled=false, TargetPart="Head", TeamCheck=true, VisibleCheck=false},
Rainbow = {Enabled=false, Speed=2, FOV=true, ESP=true, Weapon=false},
Theme = "Default",
Exploits = {GrenadePrediction = {Enabled=false, LineColor=Color3.new(1,1,1), DotColor=Color3.new(0,0,0)}},
}
local DefaultConfig = DeepCopy(Config)
local ESP_ = {Players = {}}
local CharmCache = {}
local CharmVisCache = {}
for w, s in pairs(SD.SkinSelections) do Config.SkinChanger.Skins[w] = s[1] or "Default" end
for _, gf in ipairs(SD.GloveFolders) do Config.GloveChanger.Gloves[gf.Name] = "Default" end
local function LiveRig(plr)
if not plr then return nil, nil end
local cf = workspace:FindFirstChild("Characters")
if cf then
local direct = cf:FindFirstChild(plr.Name)
if direct and direct:IsA("Model") then return direct, cf end
for _, folder in cf:GetChildren() do
local rig = folder:FindFirstChild(plr.Name)
if rig then return rig, folder end
end
end
local c = plr.Character
if c and c.Parent then return c, c.Parent end
return nil, nil
end
local function IsAlive(model)
if not (model and model.Parent) then return false end
if model:GetAttribute("Dead") == true then return false end
local hp = model:GetAttribute("Health")
if type(hp) == "number" then return hp > 0 end
local hum = model:FindFirstChildWhichIsA("Humanoid")
return hum ~= nil and hum.Health > 0
end
local function RigHealth(model)
local hp = model and model:GetAttribute("Health")
local mx = model and model:GetAttribute("MaxHealth")
if type(hp) == "number" then
return hp, (type(mx) == "number" and mx > 0) and mx or 100
end
local hum = model and model:FindFirstChildWhichIsA("Humanoid")
if hum then return hum.Health, hum.MaxHealth > 0 and hum.MaxHealth or 100 end
return 0, 100
end
local function PlayerTeam(plr)
if not plr then return nil end
local t = plr:GetAttribute("Team")
if type(t) == "string" and t ~= "" then return t end
if plr.Team then return plr.Team.Name end
end
local function is_enemy(plr)
if plr == Players.LocalPlayer then return false end
local mt, tt = PlayerTeam(Players.LocalPlayer), PlayerTeam(plr)
if mt and tt then return mt ~= tt end
if plr.Team and Players.LocalPlayer.Team then return plr.Team ~= Players.LocalPlayer.Team end
local _, mf = LiveRig(Players.LocalPlayer)
local _, tf = LiveRig(plr)
if not mf or not tf or mf == tf then return false end
return true
end
local Checkifbaseknife = {"CT Knife", "T Knife", "Knife"}
local function Checkknife(w)
if not w then return false end
for _, k in ipairs(Checkifbaseknife) do if w == k then return true end end
return false
end
local function MakeDraggable(obj, dh)
local handle = dh or obj
handle.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
local ds = input.Position
local sp = obj.Position
local ic, ie
ic = UIS.InputChanged:Connect(function(mi)
if mi.UserInputType == Enum.UserInputType.MouseMovement then
local d = mi.Position - ds
obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
end
end)
ie = input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
if ic then ic:Disconnect() end
if ie then ie:Disconnect() end
end
end)
end
end)
end
local function IsHoldKeyDown(key)
if not key then return false end
if typeof(key) == "EnumItem" then
if key.EnumType == Enum.KeyCode then return UIS:IsKeyDown(key) end
if key.EnumType == Enum.UserInputType then return UIS:IsMouseButtonPressed(key) end
end
return false
end
local RP_ = {
aimbot = RaycastParams.new(),
trigger = RaycastParams.new(),
esp = RaycastParams.new(),
aa = RaycastParams.new(),
}
RP_.aimbot.FilterType = Enum.RaycastFilterType.Exclude
RP_.trigger.FilterType = Enum.RaycastFilterType.Exclude
RP_.esp.FilterType = Enum.RaycastFilterType.Exclude
RP_.esp.IgnoreWater = true
RP_.aa.FilterType = Enum.RaycastFilterType.Exclude
for _, rp in pairs(RP_) do pcall(function() rp.CollisionGroup = "Bullet" end) end
local ESPFolder
pcall(function()
ESPFolder = Instance.new("Folder", game:GetService("CoreGui"))
ESPFolder.Name = "ESP_Highlight_Container"
end)
local function NewDrawing(dt, props)
local s, d = pcall(function()
local dr = Drawing.new(dt)
if dr and type(dr) ~= "number" then
for k, v in pairs(props) do pcall(function() dr[k] = v end) end
return dr
end
return nil
end)
if s and d and type(d) ~= "number" then AD(d); return d end
return nil
end
local function CreatePlayerESP()
local e = {Box={}, BoxOutline={}, Skeleton={}, Fill={}, LastVisCheck=0, IsVisible=false, Valid=false, Root=nil, HeadPart=nil, Hum=nil, Char=nil}
for i = 1, 4 do
local outline = NewDrawing("Line", {Thickness=3, Color=Color3.new(0,0,0), Visible=false, ZIndex=1})
if outline and type(outline) ~= "number" then e.BoxOutline[i] = outline end
local box = NewDrawing("Line", {Thickness=1, Visible=false, ZIndex=2})
if box and type(box) ~= "number" then e.Box[i] = box end
end
for i = 1, 2 do
pcall(function()
local tri = Drawing.new("Triangle")
if tri and type(tri) ~= "number" then
tri.Filled = true; tri.Visible = false; tri.Transparency = 0; tri.ZIndex = 0
AD(tri); e.Fill[i] = tri
end
end)
end
for i = 1, 20 do
local skel = NewDrawing("Line", {Thickness=2, Visible=false})
if skel and type(skel) ~= "number" then e.Skeleton[i] = skel end
end
local headDot = NewDrawing("Circle", {Thickness=1, NumSides=30, Filled=false, Visible=false})
if headDot and type(headDot) ~= "number" then e.HeadDot = headDot end
local hpBg = NewDrawing("Line", {Thickness=2, Visible=false, Color=Color3.new(0,0,0), Transparency=0.5, ZIndex=2})
if hpBg and type(hpBg) ~= "number" then e.HpBg = hpBg end
local hp = NewDrawing("Line", {Thickness=2, Visible=false, ZIndex=3})
if hp and type(hp) ~= "number" then e.Hp = hp end
local name = NewDrawing("Text", {Size=13, Center=true, Outline=true, Font=2, Visible=false})
if name and type(name) ~= "number" then e.Name = name end
local dist = NewDrawing("Text", {Size=11, Center=true, Outline=true, Font=2, Visible=false})
if dist and type(dist) ~= "number" then e.Dist = dist end
local weaponName = NewDrawing("Text", {Size=12, Center=false, Outline=true, Font=2, Visible=false})
if weaponName and type(weaponName) ~= "number" then e.WeaponName = weaponName end
pcall(function()
if ESPFolder then
e.HL = Instance.new("Highlight")
e.HL.FillTransparency = 0.5
e.HL.OutlineTransparency = 0
e.HL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
e.HL.Enabled = false
e.HL.Parent = ESPFolder
end
end)
return e
end
local function DestroyPlayerESP(e)
if not e then return end
for _, d in pairs(e.Box) do if d and type(d)~="number" then pcall(function() d:Remove() end) end end
for _, d in pairs(e.BoxOutline) do if d and type(d)~="number" then pcall(function() d:Remove() end) end end
for _, d in pairs(e.Skeleton) do if d and type(d)~="number" then pcall(function() d:Remove() end) end end
for _, d in pairs(e.Fill) do if d and type(d)~="number" then pcall(function() d:Remove() end) end end
if e.HeadDot and type(e.HeadDot)~="number" then pcall(function() e.HeadDot:Remove() end) end
if e.HpBg and type(e.HpBg)~="number" then pcall(function() e.HpBg:Remove() end) end
if e.Hp and type(e.Hp)~="number" then pcall(function() e.Hp:Remove() end) end
if e.Name and type(e.Name)~="number" then pcall(function() e.Name:Remove() end) end
if e.Dist and type(e.Dist)~="number" then pcall(function() e.Dist:Remove() end) end
if e.WeaponName and type(e.WeaponName)~="number" then pcall(function() e.WeaponName:Remove() end) end
if e.HL then pcall(function() e.HL:Destroy() end) end
end
local function HidePlayerESP(e)
if not e then return end
for _, d in pairs(e.Box) do if d and type(d)~="number" then pcall(function() d.Visible=false end) end end
for _, d in pairs(e.BoxOutline) do if d and type(d)~="number" then pcall(function() d.Visible=false end) end end
for _, d in pairs(e.Skeleton) do if d and type(d)~="number" then pcall(function() d.Visible=false end) end end
for _, d in pairs(e.Fill) do if d and type(d)~="number" then pcall(function() d.Visible=false end) end end
if e.HeadDot and type(e.HeadDot)~="number" then pcall(function() e.HeadDot.Visible=false end) end
if e.HpBg and type(e.HpBg)~="number" then pcall(function() e.HpBg.Visible=false end) end
if e.Hp and type(e.Hp)~="number" then pcall(function() e.Hp.Visible=false end) end
if e.Name and type(e.Name)~="number" then pcall(function() e.Name.Visible=false end) end
if e.Dist and type(e.Dist)~="number" then pcall(function() e.Dist.Visible=false end) end
if e.WeaponName and type(e.WeaponName)~="number" then pcall(function() e.WeaponName.Visible=false end) end
if e.HL then pcall(function() e.HL.Enabled=false end) end
end
local function CreateWorldESPObject(hasName, hasRadius)
local e = {Box={}, HL=nil, Model=nil}
if hasName then
local name = NewDrawing("Text", {Size=13, Center=true, Outline=true, Font=2, Visible=false})
if name and type(name)~="number" then e.Name = name end
end
if hasRadius then
local radius = NewDrawing("Circle", {Thickness=1.5, Filled=false, Visible=false, NumSides=60})
if radius and type(radius)~="number" then e.Radius = radius end
end
for i = 1, 4 do
local box = NewDrawing("Line", {Thickness=1, Visible=false, ZIndex=2})
if box and type(box)~="number" then e.Box[i] = box end
end
if ESPFolder then
pcall(function()
e.HL = Instance.new("Highlight")
e.HL.FillTransparency = 0.5
e.HL.OutlineTransparency = 0
e.HL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
e.HL.Enabled = false
e.HL.Parent = ESPFolder
end)
end
return e
end
local function HideWorldESPObject(e)
if not e then return end
for _, d in pairs(e.Box) do if d and type(d)~="number" then pcall(function() d.Visible=false end) end end
if e.Name and type(e.Name)~="number" then pcall(function() e.Name.Visible=false end) end
if e.Radius and type(e.Radius)~="number" then pcall(function() e.Radius.Visible=false end) end
if e.HL then pcall(function() e.HL.Enabled=false end) end
end
local function HideAllWorldESP()
for _, eo in pairs(WorldESP.DroppedWeapons) do HideWorldESPObject(eo) end
if WorldESP.Bomb then HideWorldESPObject(WorldESP.Bomb) end
for _, eo in pairs(WorldESP.Molotovs) do HideWorldESPObject(eo) end
for _, eo in pairs(WorldESP.Smokes) do HideWorldESPObject(eo) end
end
local BONES_R15 = {
{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","HumanoidRootPart"},
{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
{"HumanoidRootPart","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
{"HumanoidRootPart","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local BONES_R6 = {
{"Head","Torso"},{"Torso","HumanoidRootPart"},
{"Torso","Left Arm"},{"Torso","Right Arm"},
{"HumanoidRootPart","Left Leg"},{"HumanoidRootPart","Right Leg"},
}
local bonePosCache = {}
local InventoryController, GetWeaponProperties
local function InitInventory()
if not G.knifeChangerSupported then return end
if not InventoryController then
pcall(function()
local module = RepStore:FindFirstChild("Controllers") and RepStore.Controllers:FindFirstChild("InventoryController")
if module then local r = SafeRequire(module); if r then InventoryController = r end end
end)
end
if not GetWeaponProperties then
pcall(function()
local module = RepStore:FindFirstChild("Components") and RepStore.Components:FindFirstChild("Common")
and RepStore.Components.Common:FindFirstChild("GetWeaponProperties")
if module then local r = SafeRequire(module); if r then GetWeaponProperties = r end end
end)
end
end
InitInventory()
if not InventoryController then G.knifeChangerSupported = false end
local Router
pcall(function()
local module = RepStore:FindFirstChild("Database") and RepStore.Database:FindFirstChild("Security")
and RepStore.Database.Security:FindFirstChild("Router")
if module then Router = SafeRequire(module) end
end)
local function inspectWeapon(weapon, skin, float)
if not Router then return end
pcall(function()
Router.broadcastRouter("WeaponInspect", weapon, skin, float or 0.01,
nil, nil, nil, nil, "Weapon", nil, "fake_id", nil, false)
end)
end
local ShootRemote = nil
local function FindShootRemote()
local candidates = {
RepStore:FindFirstChild("Remotes"),
RepStore:FindFirstChild("Events"),
RepStore:FindFirstChild("Network"),
}
for _, folder in ipairs(candidates) do
if folder then
for _, child in ipairs(folder:GetChildren()) do
local n = child.Name:lower()
if child:IsA("RemoteEvent") and (n:find("shoot") or n:find("fire") or n:find("bullet") or n:find("attack")) then
return child
end
end
end
end
for _, child in ipairs(RepStore:GetDescendants()) do
local n = child.Name:lower()
if child:IsA("RemoteEvent") and (n:find("shoot") or n:find("fire") or n:find("bullet")) then
return child
end
end
return nil
end
task.spawn(function()
task.wait(2)
ShootRemote = FindShootRemote()
end)
local function SafeShoot()
if IsMobile and Config.Triggerbot.MobileSafe then
if ShootRemote then
pcall(function()
local cam = workspace.CurrentCamera
if not cam then return end
local rpShoot = RaycastParams.new()
rpShoot.FilterType = Enum.RaycastFilterType.Exclude
local ch = LiveRig(LP) or LP.Character
if ch then rpShoot.FilterDescendantsInstances = {ch, cam} end
local ro = cam.CFrame.Position
local rd = cam.CFrame.LookVector
local hit = workspace:Raycast(ro, rd * 1000, rpShoot)
if hit then
ShootRemote:FireServer(hit.Position, hit.Normal, hit.Instance)
else
ShootRemote:FireServer(ro + rd * 1000, -rd, nil)
end
end)
end
else
G.mouse1click()
end
end
local stored_fonts = {}
gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 100, MaxHeight = 600, InitialHeight = 420,
MinWidth = 300, MaxWidth = 800, InitialWidth = 520,
}
for _, v in Enum.Font:GetEnumItems() do table.insert(stored_fonts, v.Name) end
local kaliconfig = (getfenv().gui_config) or nil
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(kaliconfig, gethui())
library:SetWindowName("Kali Hub | BloxStrike")
local tabs = {
main = window:CreateTab("Main"),
visuals = window:CreateTab("Visuals"),
config = window:CreateTab("Config"),
}
local aim_parts = {"Head","HumanoidRootPart","UpperTorso","LowerTorso","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}
local sec_aim = tabs.main:CreateSection("Aimbot")
sec_aim:CreateToggle("Enabled", Config.Aimbot.Enabled, function(v) Config.Aimbot.Enabled = v; if not v then G.AimbotActive = false end end)
sec_aim:CreateToggle("Team Check", Config.Aimbot.TeamCheck, function(v) Config.Aimbot.TeamCheck = v end)
sec_aim:CreateToggle("Alive Check", Config.Aimbot.AliveCheck, function(v) Config.Aimbot.AliveCheck = v end)
sec_aim:CreateSlider("FOV (shared)", 0, 1000, Config.FOV, true, function(v) Config.FOV = v end)
sec_aim:CreateSlider("Smoothness", 1, 20, Config.Aimbot.Smoothness, true, function(v) Config.Aimbot.Smoothness = v end)
sec_aim:CreateDropdown("Target Part", {"Head","HumanoidRootPart","Torso"}, function(v) Config.Aimbot.TargetPart = v end, Config.Aimbot.TargetPart, false)
sec_aim:CreateToggle("Wall Check", Config.Aimbot.WallCheck, function(v) Config.Aimbot.WallCheck = v end)
sec_aim:CreateToggle("Show FOV", Config.Aimbot.DrawFOV, function(v) Config.Aimbot.DrawFOV = v end)
local aim_keys = {"MouseButton2","MouseButton1","LeftAlt","LeftShift","LeftControl","E","Q","F","V","X"}
sec_aim:CreateDropdown("Aimbot Hotkey", aim_keys, function(v)
pcall(function()
if Enum.UserInputType[v] then Config.Aimbot.HoldKey = Enum.UserInputType[v]
elseif Enum.KeyCode[v] then Config.Aimbot.HoldKey = Enum.KeyCode[v] end
end)
end, "MouseButton2", false)
sec_aim:CreateDropdown("Mode", {"Hold","Toggle"}, function(v) Config.Aimbot.Mode = v end, Config.Aimbot.Mode, false)
local sec_silent = tabs.main:CreateSection("Silent Aim")
sec_silent:CreateToggle("Enabled", Config.SilentAim.Enabled, function(v) Config.SilentAim.Enabled = v end)
sec_silent:CreateDropdown("Target Part", aim_parts, function(v) Config.SilentAim.TargetPart = v end, Config.SilentAim.TargetPart, false)
sec_silent:CreateToggle("Team Check", Config.SilentAim.TeamCheck, function(v) Config.SilentAim.TeamCheck = v end)
sec_silent:CreateToggle("Visible Check", Config.SilentAim.VisibleCheck, function(v) Config.SilentAim.VisibleCheck = v end)
sec_silent:CreateSlider("Hit Chance", 0, 100, Config.SilentAim.HitChance, true, function(v) Config.SilentAim.HitChance = v end)
local sec_rage = tabs.main:CreateSection("RageBot")
sec_rage:CreateToggle("Enabled", Config.RageBot.Enabled, function(v) Config.RageBot.Enabled = v end)
sec_rage:CreateDropdown("Target Part", aim_parts, function(v) Config.RageBot.TargetPart = v end, Config.RageBot.TargetPart, false)
sec_rage:CreateToggle("Team Check", Config.RageBot.TeamCheck, function(v) Config.RageBot.TeamCheck = v end)
sec_rage:CreateToggle("Visible Check", Config.RageBot.VisibleCheck, function(v) Config.RageBot.VisibleCheck = v end)
local sec_mov = tabs.main:CreateSection("Movement")
sec_mov:CreateToggle("Auto Bhop", Config.AutoBhop, function(v) Config.AutoBhop = v end)
local bhop_keys = {"Space","LeftShift","C","LeftControl"}
sec_mov:CreateDropdown("Bhop Hotkey", bhop_keys, function(v)
pcall(function() Config.BhopKey = Enum.KeyCode[v] end)
end, "Space", false)
local sec_trig = tabs.main:CreateSection("Triggerbot", "right")
sec_trig:CreateToggle("Enabled", Config.Triggerbot.Enabled, function(v) Config.Triggerbot.Enabled = v end)
sec_trig:CreateToggle("Team Check", Config.Triggerbot.TeamCheck, function(v) Config.Triggerbot.TeamCheck = v end)
sec_trig:CreateSlider("Delay (s)", 0, 1, Config.Triggerbot.Delay, false, function(v) Config.Triggerbot.Delay = v end)
local sec_wmod = tabs.main:CreateSection("Weapon Mods", "right")
sec_wmod:CreateToggle("No Spread", Config.NoSpread, function(v) Config.NoSpread = v end)
sec_wmod:CreateToggle("No Recoil", Config.NoRecoil, function(v) Config.NoRecoil = v end)
sec_wmod:CreateToggle("Instant Scope", Config.InstantScope, function(v) Config.InstantScope = v end)
local sec_hitbox = tabs.main:CreateSection("Hitbox & Wallbang", "right")
sec_hitbox:CreateToggle("Hitbox Expander", Config.Hitbox.Enabled, function(v) Config.Hitbox.Enabled = v end)
sec_hitbox:CreateSlider("Hitbox Size", 1, 10, Config.Hitbox.Size, false, function(v) Config.Hitbox.Size = v end)
G.WallbangStorage = G.WallbangStorage or Instance.new("Folder")
G.WallbangStorage.Name = "WallbangStorage"
sec_hitbox:CreateToggle("Wallbang", Config.Wallbang, function(v)
Config.Wallbang = v
pcall(function()
if v then
for _, part in ipairs(workspace:GetDescendants()) do
if part:IsA("BasePart") then
if part:FindFirstAncestorOfClass("Model") and part:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then continue end
if part:FindFirstAncestor("Shop") or part:FindFirstAncestor("UI") or part:FindFirstAncestor("StarterGui") then continue end
local n = string.lower(part.Name)
local isTarget = n:find("cube") or n:find("wall") or n:find("box") or n:find("crate")
or n:find("fence") or n:find("container") or n:find("concrete")
or n:find("cube.001") or n:find("ship") or n:find("invisible")
or n:find("plane.002") or n:find("plane.003") or n:find("ceiling.006")
or n:find("acprop") or n:find("cylinder.008") or n:find("doorarchway.001")
or n:find("door3_low") or n:find("cylinder.006")
if isTarget then
G.WallbangCache[part] = part.Parent
part.Parent = G.WallbangStorage
end
end
end
else
for part, originalParent in pairs(G.WallbangCache) do
if part then pcall(function() part.Parent = originalParent or workspace end) end
end
table.clear(G.WallbangCache)
end
end)
end)
local sec_misc = tabs.main:CreateSection("Misc", "right")
sec_misc:CreateToggle("No Flashbang", Config.FlashRemover, function(v) Config.FlashRemover = v end)
sec_misc:CreateToggle("No Smoke", Config.SmokeRemover, function(v) Config.SmokeRemover = v end)
local sec_esp = tabs.visuals:CreateSection("Player ESP")
sec_esp:CreateToggle("ESP", Config.ESP.Enabled, function(v)
Config.ESP.Enabled = v
if not v then for _, e in pairs(ESP_.Players) do pcall(function() HidePlayerESP(e) end) end end
end)
sec_esp:CreateToggle("Team Check", Config.ESP.TeamCheck, function(v) Config.ESP.TeamCheck = v end)
sec_esp:CreateToggle("Visibility Check", Config.ESP.VisibilityCheck, function(v) Config.ESP.VisibilityCheck = v end)
sec_esp:CreateSlider("Max Distance", 100, 5000, Config.ESP.MaxDistance, true, function(v) Config.ESP.MaxDistance = v end)
sec_esp:CreateButton("Reset     ESP", function()
pcall(function()
for plr, e in pairs(ESP_.Players) do pcall(function() DestroyPlayerESP(e) end); ESP_.Players[plr] = nil end
for _, p in pairs(Players:GetPlayers()) do if p ~= LP then ESP_.Players[p] = CreatePlayerESP() end end
end)
end)
local sec_espbox = tabs.visuals:CreateSection("Box Settings", "right")
sec_espbox:CreateToggle("Box", Config.ESP.Box, function(v) Config.ESP.Box = v end)
sec_espbox:CreateToggle("Box Outline", Config.ESP.BoxOutline, function(v) Config.ESP.BoxOutline = v end)
sec_espbox:CreateSlider("Thickness", 1, 5, Config.ESP.BoxThickness, true, function(v) Config.ESP.BoxThickness = v end)
sec_espbox:CreateColorpicker("Color", function(col) Config.ESP.BoxColor = col end)
sec_espbox:CreateColorpicker("Visible Color", function(col) Config.ESP.BoxVisibleColor = col end)
sec_espbox:CreateColorpicker("Hidden Color", function(col) Config.ESP.BoxNotVisibleColor = col end)
sec_espbox:CreateToggle("Box Fill", Config.ESP.BoxFill, function(v) Config.ESP.BoxFill = v end)
sec_espbox:CreateColorpicker("Fill Color 1", function(col) Config.ESP.BoxFillColor1 = col end)
sec_espbox:CreateColorpicker("Fill Color 2", function(col) Config.ESP.BoxFillColor2 = col end)
sec_espbox:CreateSlider("Fill Alpha", 0.1, 1, Config.ESP.BoxFillTransparency, false, function(v) Config.ESP.BoxFillTransparency = v end)
local sec_espext = tabs.visuals:CreateSection("ESP Elements")
sec_espext:CreateToggle("Name", Config.ESP.Name, function(v) Config.ESP.Name = v end)
sec_espext:CreateSlider("Name Size", 8, 24, Config.ESP.NameSize, true, function(v) Config.ESP.NameSize = v end)
sec_espext:CreateColorpicker("Name Color", function(col) Config.ESP.NameColor = col end)
sec_espext:CreateToggle("Health", Config.ESP.Health, function(v) Config.ESP.Health = v end)
sec_espext:CreateColorpicker("HP Color", function(col) Config.ESP.HealthBarColor = col end)
sec_espext:CreateToggle("Skeleton", Config.ESP.Skeleton, function(v) Config.ESP.Skeleton = v end)
sec_espext:CreateColorpicker("Skeleton Color", function(col) Config.ESP.SkeletonColor = col end)
sec_espext:CreateToggle("Head Dot", Config.ESP.HeadDot, function(v) Config.ESP.HeadDot = v end)
sec_espext:CreateColorpicker("Dot Color", function(col) Config.ESP.HeadDotColor = col end)
sec_espext:CreateToggle("Highlight", Config.ESP.Highlight, function(v) Config.ESP.Highlight = v end)
sec_espext:CreateColorpicker("HL Fill", function(col) Config.ESP.HighlightFill = col end)
sec_espext:CreateColorpicker("HL Outline", function(col) Config.ESP.HighlightOutline = col end)
sec_espext:CreateToggle("Distance", Config.ESP.Distance, function(v) Config.ESP.Distance = v end)
sec_espext:CreateColorpicker("Dist Color", function(col) Config.ESP.DistanceColor = col end)
sec_espext:CreateToggle("Current Weapon", Config.ESP.CurrentWeapon.Enabled, function(v) Config.ESP.CurrentWeapon.Enabled = v end)
sec_espext:CreateColorpicker("Weapon Color", function(col) Config.ESP.CurrentWeapon.Color = col end)
local sec_wesp = tabs.visuals:CreateSection("World ESP & Charms", "right")
sec_wesp:CreateToggle("Dropped Weapons", Config.ESP.DroppedWeapons.Enabled, function(v) Config.ESP.DroppedWeapons.Enabled = v end)
sec_wesp:CreateColorpicker("Dropped Color", function(col) Config.ESP.DroppedWeapons.Color = col end)
sec_wesp:CreateToggle("Bomb", Config.ESP.Bomb.Enabled, function(v) Config.ESP.Bomb.Enabled = v end)
sec_wesp:CreateColorpicker("Bomb Color", function(col) Config.ESP.Bomb.Color = col end)
sec_wesp:CreateToggle("Fire ESP", Config.ESP.Molotovs.Enabled, function(v) Config.ESP.Molotovs.Enabled = v end)
sec_wesp:CreateColorpicker("Fire Color", function(col) Config.ESP.Molotovs.Color = col end)
sec_wesp:CreateToggle("Smoke ESP", Config.ESP.Smokes.Enabled, function(v) Config.ESP.Smokes.Enabled = v end)
sec_wesp:CreateColorpicker("Smoke Color", function(col) Config.ESP.Smokes.Color = col end)
sec_wesp:CreateToggle("Charms", Config.Charms.Enabled, function(v)
Config.Charms.Enabled = v
if not v then
for plr, parts in pairs(CharmCache or {}) do
for _, box in pairs(parts) do pcall(function() box:Destroy() end) end
CharmCache[plr] = nil
end
CharmVisCache = {}
end
end)
sec_wesp:CreateToggle("Team Check (Charms)", Config.Charms.TeamCheck, function(v) Config.Charms.TeamCheck = v end)
sec_wesp:CreateColorpicker("Visible Color", function(col) Config.Charms.VisibleColor = col end)
sec_wesp:CreateColorpicker("Hidden Color", function(col) Config.Charms.HiddenColor = col end)
sec_wesp:CreateSlider("Transparency", 0.1, 1, Config.Charms.Transparency, false, function(v) Config.Charms.Transparency = v end)
sec_wesp:CreateToggle("Always On Top", Config.Charms.AlwaysOnTop, function(v) Config.Charms.AlwaysOnTop = v end)
local sec_rainbow = tabs.visuals:CreateSection("Rainbow")
sec_rainbow:CreateToggle("Enabled", Config.Rainbow.Enabled, function(v) Config.Rainbow.Enabled = v end)
sec_rainbow:CreateSlider("Speed", 1, 20, Config.Rainbow.Speed, true, function(v) Config.Rainbow.Speed = v end)
sec_rainbow:CreateToggle("FOV", Config.Rainbow.FOV, function(v) Config.Rainbow.FOV = v end)
sec_rainbow:CreateToggle("ESP", Config.Rainbow.ESP, function(v) Config.Rainbow.ESP = v end)
sec_rainbow:CreateToggle("Weapon", Config.Rainbow.Weapon, function(v) Config.Rainbow.Weapon = v end)
local sec_skins = tabs.visuals:CreateSection("Skins & Models")
sec_skins:CreateToggle("Enable Weapon Skins", Config.SkinChanger.Enabled, function(v) Config.SkinChanger.Enabled = v end)
local KM = {"Karambit","Butterfly Knife","Flip Knife","Gut Knife","M9 Bayonet"}
local EW = {"Driver Gloves","Sports Gloves","Operator Gloves","Hand Wraps"}
sec_skins:CreateButton("Force Apply Skin", function()
G.skinApplyDebounce = false
pcall(ApplySkin)
pcall(ApplyGloves)
end)
pcall(function()
for w, s in pairs(SD.SkinSelections or {}) do
if not table.find(KM, w) and not table.find(EW, w) then
sec_skins:CreateDropdown(w, s, function(v)
Config.SkinChanger.Skins[w] = v
G.skinApplyDebounce = false
pcall(ApplySkin)
end, Config.SkinChanger.Skins[w] or "", false)
end
end
end)
local sec_gloves = tabs.visuals:CreateSection("Gloves & Knives", "right")
sec_gloves:CreateToggle("Enable Gloves", Config.GloveChanger.Enabled, function(v) Config.GloveChanger.Enabled = v end)
if G.knifeChangerSupported then
local GM = {}
pcall(function()
for k in pairs(SD.GloveSelections or {}) do GM[#GM+1] = k end
table.sort(GM)
sec_gloves:CreateDropdown("Glove Model", GM, function(v) Config.GloveChanger.Model = v end, Config.GloveChanger.Model or "", false)
for _, g in ipairs(GM) do
local gs = SD.GloveSelections[g]
if gs then
sec_gloves:CreateDropdown(g.." Skin", gs, function(v)
Config.GloveChanger.Gloves[g] = v
pcall(ApplyGloves)
end, Config.GloveChanger.Gloves[g] or "Default", false)
end
end
end)
sec_gloves:CreateToggle("Enable Knife Changer", Config.KnifeChanger.Enabled, function(v) Config.KnifeChanger.Enabled = v end)
sec_gloves:CreateDropdown("Knife Model (next round)", KM, function(v)
Config.KnifeChanger.Model = v
G.skinApplyDebounce = false
pcall(ApplySkin)
end, Config.KnifeChanger.Model, false)
for _, kn in ipairs(KM) do
local ks = SD.SkinSelections[kn]
if ks then
sec_gloves:CreateDropdown(kn.." Skin", ks, function(v)
Config.SkinChanger.Skins[kn] = v
G.skinApplyDebounce = false
pcall(ApplySkin)
end, Config.SkinChanger.Skins[kn] or "Default", false)
end
end
end
local sec_set = tabs.config:CreateSection("UI Settings")
sec_set:CreateDropdown("Font", stored_fonts, function(v) window:SetFont(v) end, "", false)
sec_set:CreateLabel("Close Menu: RightAlt")
local sec_cfgmisc = tabs.config:CreateSection("HUD Overlays", "right")
sec_cfgmisc:CreateToggle("Spectator List", Config.SpectatorList, function(v)
Config.SpectatorList = v
if SpectatorList then SpectatorList.Visible = v end
end)
local config_manager = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
config_manager:SetLibrary(library)
config_manager:SetWindow(window)
config_manager:SetFolder("Kali Hub")
config_manager:BuildConfigSection(tabs.config)
config_manager:LoadAutoloadConfig()
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
window:SetTileScale(0.5)
window:SetBackgroundColor(Color3.fromRGB(255, 255, 255))
window:SetBackgroundTransparency(0)
AC(UIS.InputBegan:Connect(Safe(function(input)
local typing = UIS:GetFocusedTextBox() ~= nil
if not typing then
if Config.Aimbot.HoldKey and (input.KeyCode == Config.Aimbot.HoldKey or input.UserInputType == Config.Aimbot.HoldKey) then
if Config.Aimbot.Mode == "Toggle" then G.AimbotActive = not G.AimbotActive end
end
end
end)))
local WF_UI = Instance.new("ScreenGui")
WF_UI.Name = "KaliHub_Overlays"
local success = pcall(function() WF_UI.Parent = game:GetService("CoreGui") end)
if not success then WF_UI.Parent = LP:WaitForChild("PlayerGui") end
local SL = Instance.new("Frame")
SL.Size = UDim2.new(0, 200, 0, 30)
SL.Position = UDim2.new(0.98, -200, 0.02, 28)
SL.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SL.Parent = WF_UI
SL.Visible = Config.SpectatorList
Instance.new("UIStroke", SL).Color = Color3.fromRGB(255, 105, 180)
Instance.new("UICorner", SL).CornerRadius = UDim.new(0, 6)
local SLb = Instance.new("TextLabel", SL)
SLb.Size = UDim2.new(1, 0, 1, 0)
SLb.BackgroundTransparency = 1
SLb.Font = Enum.Font.GothamBold
SLb.TextSize = 14
SLb.TextColor3 = Color3.fromRGB(255, 255, 255)
local SpectatorList, SpecLabel = SL, SLb
local Circle
pcall(function()
local c = Drawing.new("Circle")
if c and type(c) ~= "number" then
c.Thickness = 1.6
c.Color = Color3.fromRGB(255, 255, 255)
c.Filled = false
c.Transparency = 0.7
AD(c)
Circle = c
end
end)
local V2 = Vector2.new
local V3 = Vector3.new
local function IsVisible(part)
if not part then return false end
local o = Camera.CFrame.Position
local d = (part.Position - o).Unit * 1000
pcall(function() RP_.aimbot.FilterDescendantsInstances = {G.LocalCharacter, Camera} end)
local r = workspace:Raycast(o, d, RP_.aimbot)
if r then
local hi; pcall(function() hi = r.Instance end)
if hi and part.Parent then
local id = false
pcall(function() id = hi:IsDescendantOf(part.Parent) end)
return id
end
return false
end
return true
end
local espF = {nil, nil}
local function ESP_IsVisible(char, pos)
if not G.LocalCharacter or not char or not char.Parent then return true end
local op = G.LocalCharacter:FindFirstChild("Head") or G.LocalCharacter.PrimaryPart or G.LocalCharacter:FindFirstChild("HumanoidRootPart")
if not op then return true end
local o = op.Position
espF[1] = G.LocalCharacter; espF[2] = char
pcall(function() RP_.esp.FilterDescendantsInstances = espF end)
for _, nm in ipairs({"Head","HumanoidRootPart"}) do
local pt = char:FindFirstChild(nm)
if pt and pt:IsA("BasePart") then
local dr = pt.Position - o
if dr.Magnitude > 1 then
if not workspace:Raycast(o, dr.Unit * (dr.Magnitude - 0.5), RP_.esp) then return true end
end
end
end
return false
end
local function GetColor(base, vis, nvis, visible)
if Config.ESP.VisibilityCheck then return visible and vis or nvis end
return base
end
RunOnActor(function()
task.spawn(function()
while true do
if Config.ESP.Enabled then
for plr, e in pairs(ESP_.Players) do
pcall(function()
local ch = LiveRig(plr)
if not ch or not ch.Parent then e.Valid = false; return end
local rt = ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart
if not rt or not IsAlive(ch) then e.Valid = false; return end
if Config.ESP.TeamCheck and not is_enemy(plr) then e.Valid = false; return end
e.Root = rt; e.HeadPart = ch:FindFirstChild("Head"); e.Hum = ch:FindFirstChildWhichIsA("Humanoid"); e.Char = ch; e.Valid = true
end)
end
end
task.wait(0.5)
end
end)
end)
local function Draw2DBox(eo, center, size, col, show)
local hw, hh = size.X/2, size.Y/2
local tl = V2(center.X-hw, center.Y-hh)
local tr = V2(center.X+hw, center.Y-hh)
local bl = V2(center.X-hw, center.Y+hh)
local br = V2(center.X+hw, center.Y+hh)
if show then
if eo.Box[1] and type(eo.Box[1])~="number" then eo.Box[1].From=tl; eo.Box[1].To=tr; eo.Box[1].Color=col; eo.Box[1].Visible=true end
if eo.Box[2] and type(eo.Box[2])~="number" then eo.Box[2].From=tr; eo.Box[2].To=br; eo.Box[2].Color=col; eo.Box[2].Visible=true end
if eo.Box[3] and type(eo.Box[3])~="number" then eo.Box[3].From=br; eo.Box[3].To=bl; eo.Box[3].Color=col; eo.Box[3].Visible=true end
if eo.Box[4] and type(eo.Box[4])~="number" then eo.Box[4].From=bl; eo.Box[4].To=tl; eo.Box[4].Color=col; eo.Box[4].Visible=true end
else
for i=1,4 do if eo.Box[i] and type(eo.Box[i])~="number" then eo.Box[i].Visible=false end end
end
return tl
end
local function GetFolderCenter(folder)
if not folder or not folder:IsA("Folder") then return nil end
local sum, count = V3(0,0,0), 0
for _, child in pairs(folder:GetChildren()) do
if child:IsA("BasePart") then sum = sum + child.Position; count = count + 1 end
end
if count == 0 then return nil end
return sum / count
end
local function GetFolderRadius(folder)
if not folder or not folder:IsA("Folder") then return 0 end
local minX, minZ, maxX, maxZ = math.huge, math.huge, -math.huge, -math.huge
local count = 0
for _, child in pairs(folder:GetChildren()) do
if child:IsA("BasePart") then
local p, s = child.Position, child.Size
minX = math.min(minX, p.X-s.X/2); maxX = math.max(maxX, p.X+s.X/2)
minZ = math.min(minZ, p.Z-s.Z/2); maxZ = math.max(maxZ, p.Z+s.Z/2)
count = count + 1
end
end
if count == 0 then return 0 end
return math.max(maxX-minX, maxZ-minZ) / 2
end
local function UpdateWorldESP()
if not Camera then HideAllWorldESP(); return end
local ch = G.LocalCharacter
if not ch or not IsAlive(ch) then HideAllWorldESP(); return end
local wtvp = Camera.WorldToViewportPoint
if Config.ESP.DroppedWeapons.Enabled then
for item, eo in pairs(WorldESP.DroppedWeapons) do
if not item or not item.Parent or not item.PrimaryPart then HideWorldESPObject(eo); continue end
local pos, on = wtvp(Camera, item.PrimaryPart.Position)
if not on or pos.Z <= 0 then HideWorldESPObject(eo); continue end
Draw2DBox(eo, V2(pos.X, pos.Y), V2(30,20), Config.ESP.DroppedWeapons.Color, Config.ESP.DroppedWeapons.Box)
if eo.Name and type(eo.Name)~="number" then
if Config.ESP.DroppedWeapons.Name then
eo.Name.Text = item:GetAttribute("Weapon") or "Weapon"
eo.Name.Size = 13
eo.Name.Position = V2(pos.X, pos.Y-25)
eo.Name.Color = Config.ESP.DroppedWeapons.Color
eo.Name.Visible = true
else eo.Name.Visible = false end
end
if eo.HL then eo.HL.Adornee=item; eo.HL.FillColor=Config.ESP.DroppedWeapons.Color; eo.HL.OutlineColor=G.C3W; eo.HL.Enabled=Config.ESP.DroppedWeapons.Highlight end
end
else for _, eo in pairs(WorldESP.DroppedWeapons) do HideWorldESPObject(eo) end end
if Config.ESP.Bomb.Enabled and WorldESP.Bomb and WorldESP.Bomb.Model and WorldESP.Bomb.Model.PrimaryPart then
local eo = WorldESP.Bomb; local item = eo.Model
local cf, sz = item:GetBoundingBox()
local pos, on = wtvp(Camera, cf.Position)
if on and pos.Z > 0 then
local topS = wtvp(Camera, cf.Position + V3(0, sz.Y/2, 0))
local botS = wtvp(Camera, cf.Position - V3(0, sz.Y/2, 0))
local sH = math.clamp(math.abs(topS.Y - botS.Y), 10, 80)
Draw2DBox(eo, V2(pos.X, (topS.Y+botS.Y)/2), V2(math.clamp(sH*0.8,10,60), sH), Config.ESP.Bomb.Color, Config.ESP.Bomb.Box)
if eo.Name and type(eo.Name)~="number" then
if Config.ESP.Bomb.Name then eo.Name.Text="C4"; eo.Name.Position=V2(pos.X,topS.Y-15); eo.Name.Color=Config.ESP.Bomb.Color; eo.Name.Visible=true
else eo.Name.Visible=false end
end
if eo.HL then eo.HL.Adornee=item; eo.HL.FillColor=Config.ESP.Bomb.Color; eo.HL.OutlineColor=G.C3W; eo.HL.Enabled=Config.ESP.Bomb.Highlight end
else HideWorldESPObject(eo) end
elseif WorldESP.Bomb then HideWorldESPObject(WorldESP.Bomb) end
if Config.ESP.Molotovs.Enabled then
for item, eo in pairs(WorldESP.Molotovs) do
if not item or not item.Parent then HideWorldESPObject(eo); continue end
local center = GetFolderCenter(item); local radius = GetFolderRadius(item)
if center and radius > 0 then
local pos, on = wtvp(Camera, center)
if on and pos.Z > 0 then
local edgePos = wtvp(Camera, center + Camera.CFrame.RightVector * radius)
local screenRadius = math.clamp((V2(edgePos.X,edgePos.Y)-V2(pos.X,pos.Y)).Magnitude, 5, 200)
if eo.Radius and type(eo.Radius)~="number" then eo.Radius.Position=V2(pos.X,pos.Y); eo.Radius.Radius=screenRadius; eo.Radius.Color=Config.ESP.Molotovs.Color; eo.Radius.Visible=true end
if eo.Name and type(eo.Name)~="number" then eo.Name.Text="Fire"; eo.Name.Position=V2(pos.X,pos.Y-15); eo.Name.Color=Config.ESP.Molotovs.Color; eo.Name.Visible=true end
else
if eo.Radius and type(eo.Radius)~="number" then eo.Radius.Visible=false end
if eo.Name and type(eo.Name)~="number" then eo.Name.Visible=false end
end
end
if eo.HL then
local fc; for _,c in pairs(item:GetChildren()) do if c:IsA("BasePart") then fc=c; break end end
if fc then eo.HL.Adornee=fc; eo.HL.FillColor=Config.ESP.Molotovs.Color; eo.HL.OutlineColor=G.C3W; eo.HL.Enabled=Config.ESP.Molotovs.Highlight
else eo.HL.Enabled=false end
end
for i=1,4 do if eo.Box[i] and type(eo.Box[i])~="number" then eo.Box[i].Visible=false end end
end
else for _, eo in pairs(WorldESP.Molotovs) do HideWorldESPObject(eo) end end
if Config.ESP.Smokes.Enabled then
for item, eo in pairs(WorldESP.Smokes) do
if not item or not item.Parent then HideWorldESPObject(eo); continue end
local center = GetFolderCenter(item); local radius = GetFolderRadius(item)
if center and radius > 0 then
local pos, on = wtvp(Camera, center)
if on and pos.Z > 0 then
local edgePos = wtvp(Camera, center + Camera.CFrame.RightVector * radius)
local screenRadius = math.clamp((V2(edgePos.X,edgePos.Y)-V2(pos.X,pos.Y)).Magnitude, 5, 200)
if eo.Radius and type(eo.Radius)~="number" then eo.Radius.Position=V2(pos.X,pos.Y); eo.Radius.Radius=screenRadius; eo.Radius.Color=Config.ESP.Smokes.Color; eo.Radius.Visible=true end
if eo.Name and type(eo.Name)~="number" then eo.Name.Text="Smoke"; eo.Name.Position=V2(pos.X,pos.Y-15); eo.Name.Color=Config.ESP.Smokes.Color; eo.Name.Visible=true end
else
if eo.Radius and type(eo.Radius)~="number" then eo.Radius.Visible=false end
if eo.Name and type(eo.Name)~="number" then eo.Name.Visible=false end
end
end
if eo.HL then
local fc; for _,c in pairs(item:GetChildren()) do if c:IsA("BasePart") then fc=c; break end end
if fc then eo.HL.Adornee=fc; eo.HL.FillColor=Config.ESP.Smokes.Color; eo.HL.OutlineColor=G.C3W; eo.HL.Enabled=Config.ESP.Smokes.Highlight
else eo.HL.Enabled=false end
end
for i=1,4 do if eo.Box[i] and type(eo.Box[i])~="number" then eo.Box[i].Visible=false end end
end
else for _, eo in pairs(WorldESP.Smokes) do HideWorldESPObject(eo) end end
end
local function UpdateESP()
if not Camera or not Config.ESP.Enabled then return end
if tick() - G.LastESPUpdate < 0.016 then return end
G.LastESPUpdate = tick()
local wtvp = Camera.WorldToViewportPoint
local camPos = Camera.CFrame.Position
local fillT = (math.sin(tick() * (Config.ESP.BoxFillFadeSpeed or 3)) + 1) / 2
local fillCol = Config.ESP.BoxFillColor1:Lerp(Config.ESP.BoxFillColor2, fillT)
for plr, e in pairs(ESP_.Players) do
if not plr or not plr.Parent then DestroyPlayerESP(e); ESP_.Players[plr] = nil; continue end
if not e.Valid then HidePlayerESP(e); continue end
local char, root, headPart = e.Char, e.Root, e.HeadPart
if not root or not root.Parent then HidePlayerESP(e); continue end
if not IsAlive(char) then HidePlayerESP(e); continue end
local dist = (camPos - root.Position).Magnitude
if dist > Config.ESP.MaxDistance then HidePlayerESP(e); continue end
local skip = false
pcall(function()
if Camera.CameraSubject then
local s = Camera.CameraSubject
if s == char or (s.Parent and s:IsDescendantOf(char)) then skip = true end
end
end)
if skip then HidePlayerESP(e); continue end
local rootScreen, onScreen = wtvp(Camera, root.Position)
if not onScreen or rootScreen.Z <= 0 then HidePlayerESP(e); continue end
local isVis = e.IsVisible
if Config.ESP.VisibilityCheck and (tick() - e.LastVisCheck > 0.1) then
isVis = ESP_IsVisible(char, headPart and headPart.Position or root.Position)
e.IsVisible = isVis; e.LastVisCheck = tick()
elseif not Config.ESP.VisibilityCheck then isVis = true; e.IsVisible = true end
local rP = root.Position
local hP = headPart and headPart.Position or (rP + V3(0,2,0))
local topScreen = wtvp(Camera, hP + V3(0,1,0))
local botScreen = wtvp(Camera, rP - V3(0,3,0))
if topScreen.Z <= 0 or botScreen.Z <= 0 then HidePlayerESP(e); continue end
local topY = topScreen.Y; local botY = botScreen.Y
local sH = math.abs(botY - topY)
local sW = sH * 0.55
local cx = rootScreen.X
local tl = V2(cx-sW/2, topY); local tr = V2(cx+sW/2, topY)
local bl = V2(cx-sW/2, botY); local br = V2(cx+sW/2, botY)
if Config.ESP.Box then
local col = GetColor(Config.ESP.BoxColor, Config.ESP.BoxVisibleColor, Config.ESP.BoxNotVisibleColor, isVis)
for i=1,4 do if e.Box[i] and type(e.Box[i])~="number" then e.Box[i].Thickness = Config.ESP.BoxThickness end end
if e.Box[1] and type(e.Box[1])~="number" then e.Box[1].From=tl; e.Box[1].To=tr; e.Box[1].Color=col; e.Box[1].Visible=true end
if e.Box[2] and type(e.Box[2])~="number" then e.Box[2].From=tr; e.Box[2].To=br; e.Box[2].Color=col; e.Box[2].Visible=true end
if e.Box[3] and type(e.Box[3])~="number" then e.Box[3].From=br; e.Box[3].To=bl; e.Box[3].Color=col; e.Box[3].Visible=true end
if e.Box[4] and type(e.Box[4])~="number" then e.Box[4].From=bl; e.Box[4].To=tl; e.Box[4].Color=col; e.Box[4].Visible=true end
if Config.ESP.BoxOutline then
for i=1,4 do
if e.BoxOutline[i] and type(e.BoxOutline[i])~="number" and e.Box[i] and type(e.Box[i])~="number" then
e.BoxOutline[i].From=e.Box[i].From; e.BoxOutline[i].To=e.Box[i].To
e.BoxOutline[i].Thickness=Config.ESP.BoxThickness+2; e.BoxOutline[i].Color=Color3.new(0,0,0)
e.BoxOutline[i].ZIndex=1; e.BoxOutline[i].Visible=true
end
end
else for i=1,4 do if e.BoxOutline[i] and type(e.BoxOutline[i])~="number" then e.BoxOutline[i].Visible=false end end end
else
for i=1,4 do
if e.Box[i] and type(e.Box[i])~="number" then e.Box[i].Visible=false end
if e.BoxOutline[i] and type(e.BoxOutline[i])~="number" then e.BoxOutline[i].Visible=false end
end
end
if Config.ESP.BoxFill and e.Fill[1] and e.Fill[2] then
pcall(function()
if type(e.Fill[1])~="number" then e.Fill[1].PointA=tl; e.Fill[1].PointB=tr; e.Fill[1].PointC=bl; e.Fill[1].Color=fillCol; e.Fill[1].Transparency=1-Config.ESP.BoxFillTransparency; e.Fill[1].Filled=true; e.Fill[1].Visible=true end
if type(e.Fill[2])~="number" then e.Fill[2].PointA=tr; e.Fill[2].PointB=br; e.Fill[2].PointC=bl; e.Fill[2].Color=fillCol; e.Fill[2].Transparency=1-Config.ESP.BoxFillTransparency; e.Fill[2].Filled=true; e.Fill[2].Visible=true end
end)
else for i=1,2 do if e.Fill[i] and type(e.Fill[i])~="number" then pcall(function() e.Fill[i].Visible=false end) end end end
local tY = tl.Y - 18
if Config.ESP.Name and e.Name and type(e.Name)~="number" then
e.Name.Size=Config.ESP.NameSize; e.Name.Text=plr.Name; e.Name.Position=V2(cx, tY)
e.Name.Color=GetColor(Config.ESP.NameColor, Config.ESP.NameVisibleColor, Config.ESP.NameNotVisibleColor, isVis); e.Name.Visible=true
tY = tY + Config.ESP.NameSize
elseif e.Name and type(e.Name)~="number" then e.Name.Visible=false end
if Config.ESP.CurrentWeapon.Enabled and e.WeaponName and type(e.WeaponName)~="number" then
local ea = plr:GetAttribute("CurrentEquipped")
if ea and type(ea)=="string" then
local s, ed = pcall(HS.JSONDecode, HS, ea)
if s and ed and ed.Name then
e.WeaponName.Text=ed.Name; e.WeaponName.Color=Config.ESP.CurrentWeapon.Color
e.WeaponName.Position=V2(tr.X+5, (tl.Y+bl.Y)/2); e.WeaponName.Visible=true
else e.WeaponName.Visible=false end
else e.WeaponName.Visible=false end
elseif e.WeaponName and type(e.WeaponName)~="number" then e.WeaponName.Visible=false end
if Config.ESP.HeadDot and e.HeadDot and type(e.HeadDot)~="number" then
local hp = wtvp(Camera, hP)
if hp.Z > 0 then
e.HeadDot.Position=V2(hp.X,hp.Y); e.HeadDot.Radius=math.max(sW/10,3)
e.HeadDot.Color=GetColor(Config.ESP.HeadDotColor, Config.ESP.HeadDotVisibleColor, Config.ESP.HeadDotNotVisibleColor, isVis); e.HeadDot.Visible=true
else e.HeadDot.Visible=false end
elseif e.HeadDot and type(e.HeadDot)~="number" then e.HeadDot.Visible=false end
if Config.ESP.Distance and e.Dist and type(e.Dist)~="number" then
e.Dist.Size=11; e.Dist.Text=math.floor(dist).."m"; e.Dist.Position=V2(cx, bl.Y+2); e.Dist.Color=Config.ESP.DistanceColor; e.Dist.Visible=true
elseif e.Dist and type(e.Dist)~="number" then e.Dist.Visible=false end
if Config.ESP.Health and char then
local hp, mhp = RigHealth(char)
if mhp <= 0 then mhp = 100 end; if hp > mhp then mhp = hp end
local hpF = math.clamp(hp/mhp, 0, 1)
local bx = tl.X - 5
local barH = sH * hpF
if e.HpBg and type(e.HpBg)~="number" then e.HpBg.From=V2(bx,bl.Y); e.HpBg.To=V2(bx,tl.Y); e.HpBg.Visible=true end
if e.Hp and type(e.Hp)~="number" then
e.Hp.From=V2(bx,bl.Y); e.Hp.To=V2(bx,bl.Y-barH)
e.Hp.Color = Config.ESP.HealthBarCustom and Config.ESP.HealthBarColor
or Color3.fromRGB(255,0,0):Lerp(Color3.fromRGB(0,255,0), hpF)
e.Hp.ZIndex=3; e.Hp.Visible=true
end
else
if e.HpBg and type(e.HpBg)~="number" then e.HpBg.Visible=false end
if e.Hp and type(e.Hp)~="number" then e.Hp.Visible=false end
end
if Config.ESP.Skeleton and char and dist < 300 then
local skelCol = GetColor(Config.ESP.SkeletonColor, Config.ESP.SkeletonVisibleColor, Config.ESP.SkeletonNotVisibleColor, isVis)
local isR15 = char:FindFirstChild("UpperTorso") ~= nil
local bones = isR15 and BONES_R15 or BONES_R6
table.clear(bonePosCache)
for i, pair in ipairs(bones) do
local ln = e.Skeleton[i]; if not ln or type(ln)=="number" then continue end
local p1, p2 = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
if p1 and p2 then
local s1 = bonePosCache[pair[1]]
if not s1 then local p = wtvp(Camera, p1.Position); if p.Z > 0 then s1=V2(p.X,p.Y) end; bonePosCache[pair[1]]=s1 end
local s2 = bonePosCache[pair[2]]
if not s2 then local p = wtvp(Camera, p2.Position); if p.Z > 0 then s2=V2(p.X,p.Y) end; bonePosCache[pair[2]]=s2 end
if s1 and s2 then ln.Color=skelCol; ln.From=s1; ln.To=s2; ln.Thickness=Config.ESP.SkeletonThickness; ln.Visible=true
else ln.Visible=false end
else ln.Visible=false end
end
for i = #bones+1, #e.Skeleton do if e.Skeleton[i] and type(e.Skeleton[i])~="number" then e.Skeleton[i].Visible=false end end
else for _, ln in pairs(e.Skeleton) do if ln and type(ln)~="number" then ln.Visible=false end end end
if Config.ESP.Highlight and e.HL then
pcall(function()
e.HL.Adornee = char
e.HL.FillColor = Config.ESP.VisibilityCheck and (isVis and Config.ESP.HighlightVisibleFill or Config.ESP.HighlightHiddenFill) or Config.ESP.HighlightFill
e.HL.OutlineColor = Config.ESP.HighlightOutline
e.HL.Enabled = true
end)
elseif e.HL then pcall(function() e.HL.Enabled=false end) end
end
end
local function SetupPlayer(p)
if p ~= LP then
if ESP_.Players[p] then DestroyPlayerESP(ESP_.Players[p]) end
ESP_.Players[p] = CreatePlayerESP()
AC(p.CharacterAdded:Connect(function() if ESP_.Players[p] then HidePlayerESP(ESP_.Players[p]) end end))
AC(p.CharacterRemoving:Connect(function() if ESP_.Players[p] then HidePlayerESP(ESP_.Players[p]) end end))
end
end
AC(Players.PlayerAdded:Connect(Safe(SetupPlayer)))
AC(Players.PlayerRemoving:Connect(Safe(function(p)
if ESP_.Players[p] then DestroyPlayerESP(ESP_.Players[p]); ESP_.Players[p] = nil end
if CharmCache[p] then
for _, box in pairs(CharmCache[p]) do pcall(function() box:Destroy() end) end
CharmCache[p] = nil; CharmVisCache[p] = nil
end
end)))
for _, p in pairs(Players:GetPlayers()) do SetupPlayer(p) end
G.CharmFolder = nil
pcall(function()
G.CharmFolder = Instance.new("Folder", game:GetService("CoreGui"))
G.CharmFolder.Name = "Charms_Container"
end)
G.AAD = {cachedThreat=nil, lastThreatCheck=0}
G.GPD = {
LinePool={}, ActiveLines={}, Dot=nil, LastCalc=0, CachedPts={}, CachedHit=false,
LastCam=CFrame.new(), LastVel=Vector3.new(),
PROPS = {
Default = {Restitution=0.5, Fuse=3.0, ExplodeOnTouch=false},
Flashbang = {Restitution=0.6, Fuse=2.0, ExplodeOnTouch=false},
Smoke = {Restitution=0.4, Fuse=3.0, ExplodeOnTouch=false},
Decoy = {Restitution=0.5, Fuse=15.0, ExplodeOnTouch=false},
HE = {Restitution=0.4, Fuse=3.0, ExplodeOnTouch=false},
Molotov = {Restitution=0.2, Fuse=10.0, ExplodeOnTouch=true},
Incendiary = {Restitution=0.2, Fuse=10.0, ExplodeOnTouch=true},
},
}
G.GPD_HoldState = {wasHolding=false, holdType=nil, holdStart=0, releaseTime=0, showAfterRelease=false}
local function UpdateCharms(evf)
if not Config.Charms.Enabled or not G.CharmFolder then
for plr, parts in pairs(CharmCache) do for _, box in pairs(parts) do pcall(function() box:Destroy() end) end end
table.clear(CharmCache); table.clear(CharmVisCache); return
end
local nt = tick()
local scv = (nt - G.LastCharmVisCheck) > 0.2; if scv then G.LastCharmVisCheck = nt end
local ds = (nt - G.LastCharmScan) > 1; if ds then G.LastCharmScan = nt end
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP then
local ch = LiveRig(plr)
if ch and (ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart) and IsAlive(ch) then
if Config.Charms.TeamCheck and not is_enemy(plr) then
if CharmCache[plr] then for _, box in pairs(CharmCache[plr]) do pcall(function() box:Destroy() end) end CharmCache[plr]=nil; CharmVisCache[plr]=nil end
continue
end
if not CharmCache[plr] then CharmCache[plr] = {} end
local chHead = ch:FindFirstChild("Head") or ch.PrimaryPart or ch:FindFirstChild("HumanoidRootPart")
local iv = CharmVisCache[plr]
if scv then iv=false; if chHead and evf then iv=evf(ch, chHead.Position) end; CharmVisCache[plr]=iv
elseif iv == nil then iv=false end
local col = iv and Config.Charms.VisibleColor or Config.Charms.HiddenColor
for pt, box in pairs(CharmCache[plr]) do
local isValid=false
pcall(function() if pt and pt.Parent and pt:IsDescendantOf(ch) and box and box.Parent then isValid=true end end)
if not isValid then pcall(function() box:Destroy() end); CharmCache[plr][pt]=nil end
end
for pt, box in pairs(CharmCache[plr]) do
pcall(function()
if pt.Parent and pt:IsDescendantOf(ch) and box:IsA("BoxHandleAdornment") then
box.Size=pt.Size+Vector3.new(0.05,0.05,0.05); box.Adornee=pt; box.CFrame=CFrame.new()
box.SizeRelativeOffset=Vector3.new(0,0,0); box.Color3=col
box.Transparency=Config.Charms.Transparency; box.AlwaysOnTop=Config.Charms.AlwaysOnTop; box.Visible=true
end
end)
end
if ds then
local validNames={"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}
for _, pt in ipairs(ch:GetDescendants()) do
pcall(function()
if pt:IsA("BasePart") and pt.Name~="HumanoidRootPart" and pt.Transparency<1 and not CharmCache[plr][pt] then
local validPart=false
for _, vn in ipairs(validNames) do if pt.Name==vn then validPart=true; break end end
if validPart then
local box=Instance.new("BoxHandleAdornment")
box.Name="Charm_"..pt.Name; box.Adornee=pt; box.Size=pt.Size+Vector3.new(0.05,0.05,0.05)
box.CFrame=CFrame.new(); box.SizeRelativeOffset=Vector3.new(0,0,0); box.Color3=col
box.Transparency=Config.Charms.Transparency; box.AlwaysOnTop=Config.Charms.AlwaysOnTop
box.ZIndex=5; box.Parent=G.CharmFolder; CharmCache[plr][pt]=box
end
end
end)
end
end
elseif CharmCache[plr] then
for _, box in pairs(CharmCache[plr]) do pcall(function() box:Destroy() end) end
CharmCache[plr]=nil; CharmVisCache[plr]=nil
end
end
end
for plr, parts in pairs(CharmCache) do
local valid=false
pcall(function()
local ch = LiveRig(plr)
if plr and plr.Parent and ch and (ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart) then valid=true end
end)
if not valid then for _,box in pairs(parts) do pcall(function() box:Destroy() end) end CharmCache[plr]=nil; CharmVisCache[plr]=nil end
end
end
pcall(function()
local d = Drawing.new("Circle")
if d and type(d) ~= "number" then d.Radius=5; d.Filled=true; d.Visible=false; AD(d); G.GPD.Dot=d end
end)
local function GetGPL()
local l = table.remove(G.GPD.LinePool)
if not l then l = NewDrawing("Line", {Thickness=2, Transparency=1, Visible=false}) end
if l and type(l)~="number" then G.GPD.ActiveLines[#G.GPD.ActiveLines+1] = l end
return l
end
local function ClearGPL()
for _, l in ipairs(G.GPD.ActiveLines) do if l and type(l)~="number" then l.Visible=false end; G.GPD.LinePool[#G.GPD.LinePool+1]=l end
table.clear(G.GPD.ActiveLines)
if G.GPD.Dot and type(G.GPD.Dot)~="number" then G.GPD.Dot.Visible=false end
end
local function UpdateGP()
if not Config.Exploits.GrenadePrediction.Enabled then ClearGPL(); G.GPD_HoldState.wasHolding=false; G.GPD_HoldState.showAfterRelease=false; return end
local cam = workspace.CurrentCamera; if not cam then return end
local function ggp()
for _, c in pairs(cam:GetChildren()) do
if c:IsA("Model") and not c.Name:find("Arm") then
local n = c.Name:lower()
if n:find("molotov") or n:find("incendiary") then return G.GPD.PROPS["Molotov"] end
if n:find("flash") then return G.GPD.PROPS["Flashbang"] end
if n:find("smoke") then return G.GPD.PROPS["Smoke"] end
if n:find("he") or n:find("grenade") then return G.GPD.PROPS["HE"] end
if n:find("decoy") then return G.GPD.PROPS["Decoy"] end
end
end
return nil
end
local gpp = ggp()
if not gpp then ClearGPL(); G.GPD_HoldState.wasHolding=false; G.GPD_HoldState.showAfterRelease=false; return end
local isLeftClick = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
local isRightClick = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
local isHolding = isLeftClick or isRightClick
local now = tick()
if isHolding and not G.GPD_HoldState.wasHolding then G.GPD_HoldState.holdStart=now; G.GPD_HoldState.holdType=isRightClick and "right" or "left"; G.GPD_HoldState.showAfterRelease=false end
if not isHolding and G.GPD_HoldState.wasHolding then G.GPD_HoldState.releaseTime=now; G.GPD_HoldState.showAfterRelease=true end
G.GPD_HoldState.wasHolding = isHolding
local shouldShow = isHolding
if G.GPD_HoldState.showAfterRelease and (now-G.GPD_HoldState.releaseTime) < 0.7 then shouldShow=true end
if G.GPD_HoldState.showAfterRelease and (now-G.GPD_HoldState.releaseTime) >= 0.7 then G.GPD_HoldState.showAfterRelease=false end
if shouldShow then
local ch = LP.Character; if not ch or not ch.PrimaryPart then ClearGPL(); return end
local gPos = cam.CFrame.Position; local gDir = cam.CFrame.LookVector
local cc = cam.CFrame; local pV = ch.PrimaryPart.AssemblyLinearVelocity
local throwType = G.GPD_HoldState.holdType or "left"
if isHolding then throwType = isRightClick and "right" or "left"; G.GPD_HoldState.holdType=throwType end
local cv = (now-G.GPD.LastCalc<0.033)
and (cc.Position-G.GPD.LastCam.Position).Magnitude<0.05
and (cc.LookVector-G.GPD.LastCam.LookVector).Magnitude<0.005
and (pV-G.GPD.LastVel).Magnitude<0.05
if not cv then
local throwSpeed = throwType=="right" and 60 or 125
local vel = (gDir*throwSpeed)+pV; local pts = {gPos}
local dts = 0.03; local grav = Vector3.new(0,-workspace.Gravity,0); local te = 0
local grp = RaycastParams.new(); grp.FilterType=Enum.RaycastFilterType.Exclude; grp.IgnoreWater=true
local gf = {ch, cam}; local db=workspace:FindFirstChild("Debris"); if db then gf[#gf+1]=db end
pcall(function() grp.FilterDescendantsInstances=gf end)
for i = 1, math.floor(4.0/dts) do
te = te + dts; vel = vel + (grav*dts); vel = vel * (1-0.02)
local np = gPos + (vel*dts)
local ray = workspace:Raycast(gPos, np-gPos, grp)
if ray then
if gpp.ExplodeOnTouch and ray.Normal.Y > 0.5 then gPos=ray.Position; break end
local n = ray.Normal; vel=(vel-(2*vel:Dot(n)*n))*gpp.Restitution
gPos=ray.Position+(n*0.05); if vel.Magnitude<5 then break end
else gPos=np end
pts[#pts+1] = gPos; if te >= gpp.Fuse then break end
end
G.GPD.CachedPts=pts; G.GPD.LastCalc=now; G.GPD.LastCam=cc; G.GPD.LastVel=pV
end
ClearGPL()
local pts = G.GPD.CachedPts
for i = 1, #pts-1 do
local s1,v1 = cam:WorldToViewportPoint(pts[i]); local s2,v2 = cam:WorldToViewportPoint(pts[i+1])
if v1 and v2 then
local l = GetGPL()
if l and type(l)~="number" then l.From=Vector2.new(s1.X,s1.Y); l.To=Vector2.new(s2.X,s2.Y); l.Color=Config.Exploits.GrenadePrediction.LineColor; l.Visible=true end
end
end
if #pts > 0 and G.GPD.Dot and type(G.GPD.Dot)~="number" then
local sp, so = cam:WorldToViewportPoint(pts[#pts])
if so then G.GPD.Dot.Position=Vector2.new(sp.X,sp.Y); G.GPD.Dot.Color=Config.Exploits.GrenadePrediction.DotColor; G.GPD.Dot.Visible=true
else G.GPD.Dot.Visible=false end
end
else ClearGPL() end
end
local function UpdateInventoryNames()
local invGui = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("MainGui")
if not invGui then return end
local gameplay = invGui:FindFirstChild("Gameplay"); if not gameplay then return end
local bottom = gameplay:FindFirstChild("Bottom"); if not bottom then return end
local inv = bottom:FindFirstChild("Inventory"); if not inv then return end
local meleeSlot = inv:FindFirstChild("Melee")
if meleeSlot and Config.KnifeChanger.Enabled then
local weapon = meleeSlot:FindFirstChild("Weapon")
if weapon then
local weaponName = weapon:FindFirstChild("WeaponName")
if weaponName and weaponName:IsA("TextLabel") then
local knifeModel = Config.KnifeChanger.Model
local sel = Config.SkinChanger.Skins[knifeModel]
local star = utf8.char(9733)
weaponName.Text = (sel and sel~="Default") and (star.." "..knifeModel.." | "..sel) or (star.." "..knifeModel)
end
local meleeImg = weapon:FindFirstChild("Melee")
if meleeImg and meleeImg:IsA("ImageLabel") then
pcall(function()
local knifeModel = Config.KnifeChanger.Model
local weaponDB = RepStore:FindFirstChild("Database") and RepStore.Database:FindFirstChild("Custom")
and RepStore.Database.Custom:FindFirstChild("Weapons")
if weaponDB then
local wm = weaponDB:FindFirstChild(knifeModel)
if wm then local wd = SafeRequire(wm); if wd and type(wd)=="table" and wd.Icon then meleeImg.Image=wd.Icon end end
end
end)
end
end
end
for _, child in ipairs(inv:GetDescendants()) do
if child:IsA("TextLabel") and child.Name=="WeaponName" then
if meleeSlot and child:IsDescendantOf(meleeSlot) then continue end
if not child.Text:find("|") then continue end
local baseName = child.Text:split(" | ")[1]:gsub("%s+$","")
local sel = Config.SkinChanger.Skins[baseName]
child.Text = (sel and sel~="Default") and (baseName.." | "..sel) or baseName
end
end
end
local function GetWeaponModel()
local cam = workspace.CurrentCamera; if not cam then return nil end
for _, ch in pairs(cam:GetChildren()) do
if ch:IsA("Model") and ch.Name~="Arms" and ch.Name~="Arms1" and ch.Name~="Arms2" and ch.Name~="Viewmodel" then return ch end
end
return nil
end
local function ApplySkin()
if not SD.SkinsRoot then return end
local wm = GetWeaponModel(); if not wm then return end
local ownName = wm.Name
local effectiveWeapon = ownName
local shouldApply = false
if Checkknife(ownName) then
if Config.KnifeChanger.Enabled then effectiveWeapon = Config.KnifeChanger.Model; shouldApply = true end
else
if Config.SkinChanger.Enabled then shouldApply = true end
end
if not shouldApply then return end
local selectedSkin = Config.SkinChanger.Skins[effectiveWeapon]
if not selectedSkin or selectedSkin == "Default" then return end
local currentSkin = wm:GetAttribute("KaliHubSkin")
if currentSkin == selectedSkin then return end
local weaponFolder = SD.SkinsRoot:FindFirstChild(effectiveWeapon)
if not weaponFolder then
for _, wf in ipairs(SD.SkinsRoot:GetChildren()) do
if wf.Name:lower() == effectiveWeapon:lower() then weaponFolder = wf; break end
end
end
if not weaponFolder then return end
local skinFolder = weaponFolder:FindFirstChild(selectedSkin)
if not skinFolder then return end
local function FindFactoryNew(folder)
local cam = folder:FindFirstChild("Camera")
if cam then local fn = cam:FindFirstChild("Factory New"); if fn then return fn end end
local fn = folder:FindFirstChild("Factory New"); if fn then return fn end
for _, child in ipairs(folder:GetChildren()) do
if child:IsA("Folder") or child:IsA("Model") then
local r = FindFactoryNew(child); if r then return r end
end
end
return nil
end
local factoryNew = FindFactoryNew(skinFolder)
if not factoryNew then return end
local skinMap = {}
for _, child in ipairs(factoryNew:GetChildren()) do
if child:IsA("SurfaceAppearance") then
skinMap["__all"] = child
elseif child:IsA("Folder") or child:IsA("Model") or child:IsA("BasePart") then
local sa = child:FindFirstChildOfClass("SurfaceAppearance")
if not sa then
for _, gc in ipairs(child:GetDescendants()) do
if gc:IsA("SurfaceAppearance") then sa = gc; break end
end
end
if sa then skinMap[child.Name] = sa end
end
end
if not next(skinMap) then return end
local applied = false
for _, part in ipairs(wm:GetDescendants()) do
if part:IsA("BasePart") or part:IsA("MeshPart") then
local sa = skinMap[part.Name] or skinMap["__all"]
if sa then
for _, old in ipairs(part:GetChildren()) do
if old:IsA("SurfaceAppearance") then pcall(function() old:Destroy() end) end
end
local ok = pcall(function() sa:Clone().Parent = part end)
if ok then applied = true end
end
end
end
if not applied and skinMap["__all"] then
for _, part in ipairs(wm:GetDescendants()) do
if part:IsA("MeshPart") then
pcall(function()
for _, old in ipairs(part:GetChildren()) do
if old:IsA("SurfaceAppearance") then old:Destroy() end
end
skinMap["__all"]:Clone().Parent = part
end)
applied = true
end
end
end
if applied then
wm:SetAttribute("KaliHubSkin", selectedSkin)
if Checkknife(ownName) and Config.KnifeChanger.Enabled then
pcall(function()
task.delay(0.1, function()
inspectWeapon(effectiveWeapon, selectedSkin, 0.01)
end)
end)
end
pcall(UpdateInventoryNames)
end
end
local function ApplyGloves()
if not Config.GloveChanger.Enabled then return end
local cam = workspace.CurrentCamera; if not cam then return end
local am
for _, ch in ipairs(cam:GetChildren()) do
if ch:IsA("Model") and (ch.Name:match("Arms") or ch:FindFirstChild("Right Arm")) then am=ch; break end
end
if not am then return end
local la = am:FindFirstChild("Left Arm"); local ra = am:FindFirstChild("Right Arm")
if not la or not ra then return end
local lg = la:FindFirstChild("Glove"); local rg = ra:FindFirstChild("Glove")
if not lg or not rg then return end
for _, old in pairs(lg:GetChildren()) do if old:IsA("SurfaceAppearance") then old:Destroy() end end
for _, old in pairs(rg:GetChildren()) do if old:IsA("SurfaceAppearance") then old:Destroy() end end
local selectedModel = Config.GloveChanger.Model; if not selectedModel then return end
local sel = Config.GloveChanger.Gloves[selectedModel]; if not sel or sel=="Default" then return end
if not SD.SkinsRoot then return end
local gsf = SD.SkinsRoot:FindFirstChild(selectedModel); if not gsf then return end
local sv = gsf:FindFirstChild(sel); if not sv then return end
local caf = sv:FindFirstChild("Camera"); if not caf then return end
local ffn = caf:FindFirstChild("Factory New"); if not ffn then return end
for _, sa in pairs(ffn:GetChildren()) do
if sa:IsA("SurfaceAppearance") then sa:Clone().Parent=lg; sa:Clone().Parent=rg end
end
end
local function TrySkinApply()
if G.skinApplyDebounce then return end
G.skinApplyDebounce = true
task.spawn(function()
task.wait(0.2)
pcall(function()
if Config.SkinChanger.Enabled or Config.KnifeChanger.Enabled then ApplySkin() end
if Config.GloveChanger.Enabled then ApplyGloves() end
end)
task.wait(0.3)
pcall(UpdateInventoryNames)
G.skinApplyDebounce = false
end)
end
task.spawn(function()
local lastWeapon = nil
while true do
task.wait(0.25)
pcall(function()
local wm = GetWeaponModel()
local name = wm and wm.Name or nil
if name ~= lastWeapon then
lastWeapon = name
if name and (Config.SkinChanger.Enabled or Config.KnifeChanger.Enabled or Config.GloveChanger.Enabled) then
task.wait(0.15)
G.skinApplyDebounce = false
pcall(ApplySkin)
pcall(ApplyGloves)
end
end
end)
end
end)
task.spawn(Safe(function()
while true do
local cam = workspace.CurrentCamera
if cam then
AC(cam.ChildAdded:Connect(Safe(function()
if Config.SkinChanger.Enabled or Config.KnifeChanger.Enabled or Config.GloveChanger.Enabled then
TrySkinApply()
end
end)))
break
end
task.wait(1)
end
end))
pcall(function()
AC(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(Safe(function()
local nc = workspace.CurrentCamera
if nc then
AC(nc.ChildAdded:Connect(Safe(function()
if Config.SkinChanger.Enabled or Config.KnifeChanger.Enabled or Config.GloveChanger.Enabled then
TrySkinApply()
end
end)))
end
end)))
end)
local function IsVisFromChar(o, tp, ac)
local d = (tp.Position - o)
pcall(function() RP_.aa.FilterDescendantsInstances = {ac} end)
local r = workspace:Raycast(o, d, RP_.aa)
if r then
local hi; pcall(function() hi = r.Instance end)
if hi and tp.Parent then
local id=false; pcall(function() id=hi:IsDescendantOf(tp.Parent) end); return id
end
return false
end
return true
end
local ttF = {}
AC(RS.RenderStepped:Connect(Safe(function()
G.FrameCount = G.FrameCount + 1
local ch = LiveRig(LP) or LP.Character
G.LocalCharacter = ch
local lHum = ch and ch:FindFirstChildWhichIsA("Humanoid")
local lRoot = ch and ch:FindFirstChild("HumanoidRootPart")
Camera = workspace.CurrentCamera
if not Camera then return end
if Config.AutoBhop and lHum and lRoot then
if IsHoldKeyDown(Config.BhopKey) then
if lHum.FloorMaterial ~= Enum.Material.Air then lHum.Jump = true end
end
end
if Config.ESP.Enabled then pcall(UpdateESP) end
pcall(UpdateWorldESP)
if Config.Charms.Enabled and (tick() - G.LastCharmUpdate > 0.1) then
G.LastCharmUpdate = tick(); pcall(UpdateCharms, ESP_IsVisible)
end
local SC = V2(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
if Circle and type(Circle) ~= "number" then
if Config.Aimbot.DrawFOV then
Circle.Visible = true
Circle.Radius = Config.FOV
Circle.Position = SC
else Circle.Visible = false end
end
local akd = (Config.Aimbot.Mode == "Hold") and IsHoldKeyDown(Config.Aimbot.HoldKey) or G.AimbotActive
if Config.Aimbot.Enabled and akd then
local bt, bd = nil, Config.FOV
for _, plr in pairs(Players:GetPlayers()) do
if plr == LP then continue end
local rig = LiveRig(plr)
if not rig then continue end
if Config.Aimbot.TeamCheck and not is_enemy(plr) then continue end
if Config.Aimbot.AliveCheck and not IsAlive(rig) then continue end
local pt = rig:FindFirstChild(Config.Aimbot.TargetPart)
if not pt then continue end
local sp, ao = Camera:WorldToViewportPoint(pt.Position)
if not ao then continue end
if Config.Aimbot.WallCheck and not IsVisible(pt) then continue end
local ad = (V2(sp.X,sp.Y) - SC).Magnitude
if ad < bd then bt=V2(sp.X,sp.Y); bd=ad end
end
if bt then
local sm = math.max(1, Config.Aimbot.Smoothness)
G.mousemoverel((bt.X - SC.X) / sm, (bt.Y - SC.Y) / sm)
end
end
if Config.Triggerbot.Enabled and (tick() - G.lastTriggerTime) > Config.Triggerbot.Delay then
local ro = Camera.CFrame.Position
local rd = Camera.CFrame.LookVector * 1000
RP_.trigger.FilterType = Enum.RaycastFilterType.Exclude
table.clear(ttF)
if ch then ttF[1]=ch end
if workspace.CurrentCamera then ttF[#ttF+1]=workspace.CurrentCamera end
pcall(function() RP_.trigger.FilterDescendantsInstances=ttF end)
local rr = workspace:Raycast(ro, rd, RP_.trigger)
local ss = false
if rr then
local hp; pcall(function() hp=rr.Instance end)
if hp then
local hc; pcall(function() hc=hp:FindFirstAncestorOfClass("Model") end)
if hc and (hc:FindFirstChild("HumanoidRootPart") or hc.PrimaryPart) and IsAlive(hc) then
local hpp = Players:GetPlayerFromCharacter(hc) or Players:FindFirstChild(hc.Name)
if hpp and hpp:IsA("Player") and (not Config.Triggerbot.TeamCheck or is_enemy(hpp)) then ss=true end
end
end
end
if ss then G.lastTriggerTime=tick(); SafeShoot() end
end
if Config.SpectatorList then
SpectatorList.Visible = true
local sc = 0; pcall(function() sc = LP:GetAttribute("Spectators") or 0 end)
SpecLabel.Text = "Spectators: " .. tostring(sc)
else SpectatorList.Visible = false end
end)))
AC(RS.Heartbeat:Connect(Safe(function()
if tick() - G.LastWorldScan < 0.2 then return end
G.LastWorldScan = tick()
local debris = workspace:FindFirstChild("Debris"); if not debris then return end
local cdw, cmol, csmk = {}, {}, {}; local bf = false
for _, item in ipairs(debris:GetChildren()) do
if Config.ESP.DroppedWeapons.Enabled and item:IsA("Model") and item:GetAttribute("Weapon") and item:GetAttribute("CanPickup")==true then
cdw[item]=true
if not WorldESP.DroppedWeapons[item] then WorldESP.DroppedWeapons[item]=CreateWorldESPObject(true,false); WorldESP.DroppedWeapons[item].Model=item end
end
if Config.ESP.Bomb.Enabled and item:IsA("Model") and item.Name=="Character" and item:GetAttribute("BombPlanted") then
bf=true
if WorldESP.Bomb and WorldESP.Bomb.Model~=item then DestroyWESP(WorldESP.Bomb); WorldESP.Bomb=nil end
if not WorldESP.Bomb then WorldESP.Bomb=CreateWorldESPObject(true,false); WorldESP.Bomb.Model=item end
end
if Config.ESP.Molotovs.Enabled and item:IsA("Folder") and item.Name:match("^VoxelFire") then
cmol[item]=true
if not WorldESP.Molotovs[item] then WorldESP.Molotovs[item]=CreateWorldESPObject(true,true); WorldESP.Molotovs[item].Model=item end
end
if Config.SmokeRemover and item.Name:match("^VoxelSmoke") then
pcall(function() item:ClearAllChildren(); item:Destroy() end); continue
end
if Config.ESP.Smokes.Enabled and item:IsA("Folder") and item.Name:match("^VoxelSmoke") then
csmk[item]=true
if not WorldESP.Smokes[item] then WorldESP.Smokes[item]=CreateWorldESPObject(true,true); WorldESP.Smokes[item].Model=item end
end
end
for item, eo in pairs(WorldESP.DroppedWeapons) do if not cdw[item] then DestroyWESP(eo); WorldESP.DroppedWeapons[item]=nil end end
for item, eo in pairs(WorldESP.Molotovs) do if not cmol[item] then DestroyWESP(eo); WorldESP.Molotovs[item]=nil end end
for item, eo in pairs(WorldESP.Smokes) do if not csmk[item] then DestroyWESP(eo); WorldESP.Smokes[item]=nil end end
if not bf and WorldESP.Bomb then DestroyWESP(WorldESP.Bomb); WorldESP.Bomb=nil end
end)))
pcall(function()
if LP:FindFirstChild("PlayerGui") then
AC(LP.PlayerGui.ChildAdded:Connect(Safe(function(child)
if Config.FlashRemover and child.Name=="FlashbangEffect" then pcall(function() child:Destroy() end) end
end)))
end
end)
pcall(function()
AC(game:GetService("Lighting").ChildAdded:Connect(Safe(function(child)
if Config.FlashRemover and child.Name=="FlashbangColorCorrection" then pcall(function() child:Destroy() end) end
end)))
end)
AC(RS.Heartbeat:Connect(Safe(function()
if (Config.SkinChanger.Enabled or Config.KnifeChanger.Enabled) and tick()-G.lastInvRefresh > 2 then
G.lastInvRefresh = tick(); pcall(UpdateInventoryNames)
end
end)))
AC(RS.Heartbeat:Connect(Safe(function()
for _, plr in ipairs(Players:GetPlayers()) do
if plr == LP then continue end
local char = LiveRig(plr)
if not char then continue end
local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
if not (head and IsAlive(char)) then continue end
if not originalHeadSizes[head] then originalHeadSizes[head] = head.Size end
if Config.Hitbox.Enabled and (not Config.Aimbot.TeamCheck or is_enemy(plr)) then
local s = Config.Hitbox.Size
head.Size = Vector3.new(s, s, s)
head.CanCollide = false
head.Transparency = 0.5
elseif originalHeadSizes[head] and head.Size ~= originalHeadSizes[head] then
head.Size = originalHeadSizes[head]
head.Transparency = 0
end
end
end)))
do
pcall(function()
local Bullet = require(RepStore.Components.Weapon.Classes.Bullet)
if type(Bullet) ~= "table" then return end
if type(rawget(Bullet, "getTrueSpread")) == "function" then
local orig = Bullet.getTrueSpread
Bullet.getTrueSpread = function(self, ...)
if Config.NoSpread then return 0 end
return orig(self, ...)
end
end
if type(rawget(Bullet, "getSpreadForConfig")) == "function" then
local orig = Bullet.getSpreadForConfig
Bullet.getSpreadForConfig = function(self, ...)
if Config.NoSpread then return 0 end
return orig(self, ...)
end
end
if type(rawget(Bullet, "_updateShotSpread")) == "function" then
local orig = Bullet._updateShotSpread
Bullet._updateShotSpread = function(self, ...)
if Config.NoSpread then return end
return orig(self, ...)
end
end
if type(rawget(Bullet, "create")) == "function" then
local orig = Bullet.create
Bullet.create = function(self, ...)
if Config.InstantScope then
local w = self.Weapon
if w then
w.ScopeStartTick = tick() - 1
w.IsSniperScoped = true
end
end
return orig(self, ...)
end
end
end)
pcall(function()
local CC = require(RepStore.Controllers.CameraController)
if type(CC) ~= "table" then return end
if type(rawget(CC, "setWeaponRecoil")) == "function" then
local orig = CC.setWeaponRecoil
CC.setWeaponRecoil = function(...)
if Config.NoRecoil then return end
return orig(...)
end
end
if type(rawget(CC, "weaponKick")) == "function" then
local orig = CC.weaponKick
CC.weaponKick = function(...)
if Config.NoRecoil then return end
return orig(...)
end
end
end)
end
do
local function hue()
return Color3.fromHSV((tick() * (Config.Rainbow.Speed or 2) * 0.05) % 1, 1, 1)
end
AC(RS.RenderStepped:Connect(Safe(function()
if not Config.Rainbow.Enabled then return end
local col = hue()
if Config.Rainbow.FOV then
if Circle and type(Circle) ~= "number" then Circle.Color = col end
end
if Config.Rainbow.ESP then
Config.ESP.BoxColor = col
Config.ESP.NameColor = col
Config.ESP.SkeletonColor = col
Config.ESP.HeadDotColor = col
Config.ESP.DistanceColor = col
Config.ESP.HighlightFill = col
end
if Config.Rainbow.Weapon then
local wm = GetWeaponModel()
if wm then
for _, p in ipairs(wm:GetDescendants()) do
if p:IsA("BasePart") then pcall(function() p.Color = col end) end
end
end
end
end)))
end
do
local function CharsFolder() return workspace:FindFirstChild("Characters") end
local acRmt
pcall(function()
for _, v in next, getgc(true) do
if type(v) == "table" and rawget(v, "ShootWeapon") then acRmt = v; break end
end
end)
local function Nearest(fov, part, teamCheck, visCheck)
local c = CharsFolder(); if not c then return end
local cam = workspace.CurrentCamera; if not cam then return end
local vp = cam.ViewportSize
local center = V2(vp.X / 2, vp.Y / 2)
local best, bestD = nil, fov
local function consider(e)
if not e:IsA("Model") or e.Name == LP.Name then return end
local hrp = e:FindFirstChild("HumanoidRootPart") or e.PrimaryPart
if not hrp or not IsAlive(e) then return end
local plr = Players:FindFirstChild(e.Name)
if teamCheck and plr and plr:IsA("Player") and not is_enemy(plr) then return end
local hp = e:FindFirstChild(part) or hrp
local sp, on = cam:WorldToViewportPoint(hp.Position)
if on then
local d = (V2(sp.X, sp.Y) - center).Magnitude
if d < bestD and (not visCheck or ESP_IsVisible(e, hp.Position)) then
bestD = d; best = {p = hp.Position, h = hp}
end
end
end
for _, f in next, c:GetChildren() do
if f:IsA("Folder") then
for _, e in next, f:GetChildren() do consider(e) end
else
consider(f)
end
end
return best
end
if acRmt and type(rawget(acRmt, "ShootWeapon")) == "table" then
local sw = acRmt.ShootWeapon
local orig = sw.Send
if type(orig) == "function" then
sw.Send = function(payload, ...)
if Config.SilentAim.Enabled and type(payload) == "table" and type(payload.Bullets) == "table" then
pcall(function()
local S = Config.SilentAim
if S.HitChance < 100 and math.random(1, 100) > S.HitChance then return end
local tg = Nearest(Config.FOV, S.TargetPart, S.TeamCheck, S.VisibleCheck)
if not tg then return end
for _, b in ipairs(payload.Bullets) do
local og = b.Origin or (workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position)
if og then
local dir = (tg.p - og).Unit
b.Direction = dir
b.Hits = {{
Distance = (tg.p - og).Magnitude,
Instance = tg.h,
Position = tg.p,
Normal = -dir,
Material = "Plastic",
Exit = false,
}}
end
end
end)
end
return orig(payload, ...)
end
end
end
local curWep, lastScan = nil, 0
local function IsWeapon(wp)
if not wp then return false end
local pr = rawget(wp, "Properties")
return pr and rawget(pr, "FireRate") and rawget(pr, "BulletsPerShot") and rawget(pr, "Rounds")
end
local function OwnsWeapon(v)
if rawget(v, "Player") == LP then return true end
local own = rawget(v, "OriginalOwner")
return own == LP.Name or own == LP.UserId
end
local function FindWeapon()
for _, v in next, getgc(true) do
if type(v) == "table" then
local ok, r = pcall(rawget, v, "IsEquipped")
if ok and r and rawget(v, "Identifier") and OwnsWeapon(v) and IsWeapon(v) then return v end
end
end
end
local function EnsureWeapon()
if curWep and rawget(curWep, "IsEquipped") and OwnsWeapon(curWep) then return curWep end
if tick() - lastScan > 0.4 then lastScan = tick(); curWep = FindWeapon() end
return curWep
end
local rbLast = 0
AC(RS.RenderStepped:Connect(Safe(function()
local rage = Config.RageBot.Enabled
if not rage then return end
local wep = EnsureWeapon()
if acRmt and acRmt.ShootWeapon and wep then
local mc = LiveRig(LP)
local hrp = mc and (mc:FindFirstChild("HumanoidRootPart") or mc.PrimaryPart)
if not hrp or not IsAlive(mc) then return end
local tg = Nearest(Config.FOV, Config.RageBot.TargetPart, Config.RageBot.TeamCheck, Config.RageBot.VisibleCheck)
if not tg then return end
local pr = rawget(wep, "Properties")
local rate = rawget(pr, "FireRate") or 0.1
if type(rate) ~= "number" or rate <= 0 then rate = 0.1 end
if rate < 0.055 then rate = 0.055 end
if tick() - rbLast < rate then return end
local cr = rawget(wep, "Rounds")
if not cr or cr <= 0 then return end
rbLast = tick()
local og = workspace.CurrentCamera.CFrame.Position
local dir = (tg.p - og).Unit
local seq = (rawget(wep, "ShotSeq") or 0) + 1
pcall(function() wep.ShotSeq = seq end)
wep.Rounds = cr - 1
acRmt.ShootWeapon.Send({
ShootingHand = "Right",
Identifier = wep.Identifier,
Seq = seq,
IsSniperScoped = rawget(wep, "IsSniperScoped") or false,
Bullets = {{
Direction = dir,
Origin = og,
Hits = {{
Instance = tg.h,
Position = tg.p,
Normal = -dir,
Material = "Plastic",
Distance = (tg.p - og).Magnitude,
Exit = false,
}}
}}
})
end
end)))
end
