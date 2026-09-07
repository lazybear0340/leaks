--this shit was unobfuscated


local stored_fonts = {}
gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 100,
MaxHeight = 600,
InitialHeight = 400,
MinWidth = 300,
MaxWidth = 800,
InitialWidth = 500
}
for _, v in Enum.Font:GetEnumItems() do
table.insert(stored_fonts, v.Name)
end
local config = (getfenv().gui_config) or nil
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(config, gethui())
local window_name = library:SetWindowName("Kali Hub | The Strongest Battlegrounds")
local tabs = {
main = window:CreateTab("Main"),
visuals = window:CreateTab("Visuals"),
config = window:CreateTab("Config")
}
local sections = {
combat = tabs.main:CreateSection("Combat", "left"),
skills = tabs.main:CreateSection("Skills", "right"),
defense = tabs.main:CreateSection("Defense", "left"),
playerTools = tabs.main:CreateSection("Player Tools", "right"),
teleports = tabs.main:CreateSection("Teleports", "left"),
server = tabs.main:CreateSection("Server Tools", "right"),
esp = tabs.visuals:CreateSection("Player ESP", "left"),
iface = tabs.visuals:CreateSection("Interface", "right"),
config = tabs.config:CreateSection("Settings")
}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local flags = {
killAura = false,
autoM1 = true,
autoFace = false,
stayInRange = false,
targetRange = 15,
m1Speed = 8,
ignoreDummy = false,
autoSkills = false,
skillMode = "Combo Rotation",
singleSkill = "1",
tapHold = "Tap",
skillSpeed = 2,
autoUlt = false,
autoGrab = false,
grabKey = "G",
autoBlock = false,
blockMode = "On Hit",
blockRange = 12,
antiRagdoll = false,
antiStun = false,
autoDodge = false,
autoDash = false,
autoDashDelay = 2,
esp = false,
espHighlight = true,
espBoxes = true,
espNames = true,
espHealth = true,
espDistance = true,
espTracers = false,
espMaxDistance = 1000,
espColor = Color3.fromRGB(255, 60, 60),
walkLock = false, walkSpeed = 16,
jumpLock = false, jumpPower = 50,
infJump = false,
fly = false, flySpeed = 50,
noclip = false,
antiAfk = false,
keybindsPanel = true,
parryRange = 10,
parryHold = 0.6,
counterDelay = 0.15
}
local keyMap = {
["1"] = Enum.KeyCode.One, ["2"] = Enum.KeyCode.Two,
["3"] = Enum.KeyCode.Three, ["4"] = Enum.KeyCode.Four,
Q = Enum.KeyCode.Q, R = Enum.KeyCode.R, T = Enum.KeyCode.T,
Y = Enum.KeyCode.Y, G = Enum.KeyCode.G, H = Enum.KeyCode.H
}
local function getCharacter(plr)
plr = plr or LocalPlayer
return plr.Character
end
local function getHumanoid(char)
return char and char:FindFirstChildOfClass("Humanoid")
end
local function isAlive(char)
local hum = getHumanoid(char)
return hum ~= nil and hum.Health > 0
end
local function communicate(args)
local char = getCharacter()
if not char then return end
local remote = char:FindFirstChild("Communicate")
if not (remote and remote:IsA("RemoteEvent")) then return end
if (args.Goal == "LeftClick" or args.Goal == "RightClick" or args.Goal == "KeyPress") and args.MousePos == nil then
args.MousePos = LocalPlayer:GetMouse().Hit
end
remote:FireServer(args)
end
local function equippedToolName()
local char = getCharacter()
if not char then return nil end
local tool = char:FindFirstChildOfClass("Tool")
if tool then return tool:GetAttribute("Name") or tool.Name end
return nil
end
local function getPing()
local ok, ping = pcall(function()
return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
end)
if ok and type(ping) == "number" and ping > 0 then return ping end
return LocalPlayer:GetNetworkPing() * 1000
end
local function isDummy(model)
local n = model.Name:lower()
return n:find("dummy") ~= nil or n:find("training") ~= nil
end
local function getTargets()
local list = {}
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and plr.Character and isAlive(plr.Character) then
local root = plr.Character:FindFirstChild("HumanoidRootPart")
if root then list[#list + 1] = { char = plr.Character, root = root } end
end
end
if not flags.ignoreDummy then
for _, m in ipairs(workspace:GetChildren()) do
if m:IsA("Model") and m ~= LocalPlayer.Character and isDummy(m)
and not Players:GetPlayerFromCharacter(m) then
local root = m:FindFirstChild("HumanoidRootPart")
if root and isAlive(m) then list[#list + 1] = { char = m, root = root } end
end
end
end
return list
end
local function nearestEnemy(range)
local char = getCharacter()
local myRoot = char and char:FindFirstChild("HumanoidRootPart")
if not myRoot then return nil end
local best, bestD = nil, range
for _, t in ipairs(getTargets()) do
local d = (t.root.Position - myRoot.Position).Magnitude
if d <= bestD then bestD = d; best = t end
end
return best
end
local function faceTarget(targetRoot)
local char = getCharacter()
local root = char and char:FindFirstChild("HumanoidRootPart")
if not root then return end
local look = Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z)
root.CFrame = CFrame.new(root.Position, look)
end
local function approach(targetRoot)
local char = getCharacter()
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = getHumanoid(char)
if not (root and hum) then return end
local dist = (targetRoot.Position - root.Position).Magnitude
if dist > flags.targetRange * 0.6 then
local dir = (targetRoot.Position - root.Position).Unit
hum:MoveTo(root.Position + dir * (dist - flags.targetRange * 0.5))
end
end
RunService.RenderStepped:Connect(function()
if not (flags.autoFace or flags.stayInRange) then return end
local t = nearestEnemy(flags.targetRange)
if not t then return end
if flags.autoFace then faceTarget(t.root) end
if flags.stayInRange then approach(t.root) end
end)
task.spawn(function()
while true do
if flags.killAura then
local rate = 1 / math.clamp(flags.m1Speed, 1, 25)
local t = nearestEnemy(flags.targetRange)
if t then
local pos
if flags.autoM1 then
local part = t.char:FindFirstChild("Head") or t.root
pos = part.CFrame
end
communicate({ Goal = "LeftClick", ToolName = equippedToolName(), MousePos = pos })
end
task.wait(rate)
else
task.wait(0.1)
end
end
end)
local VirtualInputManager = game:GetService("VirtualInputManager")
local function sendKey(kc, holdTime)
VirtualInputManager:SendKeyEvent(true, kc, false, game)
task.wait(holdTime)
VirtualInputManager:SendKeyEvent(false, kc, false, game)
end
local function tapKey(kc)
sendKey(kc, 0.06)
end
local function pressSkill(slot)
local kc = keyMap[slot]
if not kc then return end
sendKey(kc, flags.tapHold == "Hold" and 0.35 or 0.06)
end
local comboOrder = { "1", "2", "3", "4" }
local comboIndex = 1
task.spawn(function()
while true do
if flags.autoSkills and nearestEnemy(flags.targetRange) then
if flags.skillMode == "Single Skill" then
pressSkill(flags.singleSkill)
else
pressSkill(comboOrder[comboIndex])
comboIndex = comboIndex % #comboOrder + 1
end
task.wait(1 / math.clamp(flags.skillSpeed, 0.5, 10))
else
task.wait(0.1)
end
end
end)
task.spawn(function()
while true do
if flags.autoUlt and (LocalPlayer:GetAttribute("Ultimate") or 0) >= 100 then
local char = getCharacter()
local hum = char and getHumanoid(char)
if hum then
communicate({ Goal = "KeyPress", Key = Enum.KeyCode.G, MoveDirection = hum.MoveDirection })
task.wait(2)
else
task.wait(0.3)
end
else
task.wait(0.3)
end
end
end)
task.spawn(function()
while true do
if flags.autoGrab then
local t = nearestEnemy(flags.targetRange)
if t and t.char:FindFirstChild("Ragdoll") then
local kc = keyMap[flags.grabKey]
if kc then tapKey(kc) end
end
task.wait(0.3)
else
task.wait(0.2)
end
end
end)
local lastDash = 0
local dodgeToggle = false
local function doDash(dirKey)
lastDash = tick()
VirtualInputManager:SendKeyEvent(true, dirKey, false, game)
task.wait(0.03)
VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
task.wait(0.03)
VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
task.wait(0.03)
VirtualInputManager:SendKeyEvent(false, dirKey, false, game)
end
local function dodgeKey()
dodgeToggle = not dodgeToggle
return dodgeToggle and Enum.KeyCode.A or Enum.KeyCode.D
end
task.spawn(function()
while true do
if flags.autoDash then
doDash(dodgeKey())
task.wait(math.max(flags.autoDashDelay, 0.5))
else
task.wait(0.1)
end
end
end)
local function canBlock()
local char = getCharacter()
if not (char and isAlive(char)) then return false end
if char:FindFirstChild("Ragdoll") or char:FindFirstChild("Freeze") then return false end
return true
end
local skillMoveNames = {}
do
local ok, info = pcall(function()
return require(game:GetService("ReplicatedStorage"):WaitForChild("Info", 10))
end)
if ok and typeof(info) == "table" and typeof(info.Skillsets) == "table" then
for _, style in pairs(info.Skillsets) do
if typeof(style) == "table" then
for _, group in ipairs({ style.Base, style.Ultimate }) do
if typeof(group) == "table" then
for _, moveName in pairs(group) do
if typeof(moveName) == "string" then skillMoveNames[moveName] = true end
end
end
end
if typeof(style.UltimateName) == "string" then skillMoveNames[style.UltimateName] = true end
end
end
end
end
local function attackingToward(enemyChar)
if not (enemyChar and isAlive(enemyChar)) then return false end
local char = getCharacter()
local mroot = char and char:FindFirstChild("HumanoidRootPart")
local eroot = enemyChar:FindFirstChild("HumanoidRootPart")
if not (mroot and eroot) then return false end
local delta = mroot.Position - eroot.Position
if delta.Magnitude > flags.parryRange then return false end
if eroot.CFrame.LookVector:Dot(delta.Unit) < 0.35 then return false end
if enemyChar:FindFirstChild("M1ing") then return true end
for _, ch in ipairs(enemyChar:GetChildren()) do
if ch:IsA("Tool") and (skillMoveNames[ch.Name] or skillMoveNames[ch:GetAttribute("Name")]) then
return true
end
end
return false
end
local function updateAutoTuning()
local pingSeconds = getPing() / 1000
flags.parryHold = math.clamp(0.3 + pingSeconds * 1.5, 0.35, 0.8)
flags.parryRange = math.clamp(flags.blockRange + pingSeconds * 6, flags.blockRange, flags.blockRange + 6)
end
updateAutoTuning()
task.spawn(function()
while true do updateAutoTuning(); task.wait(1) end
end)
local blockActive = false
local lastThreat = 0
RunService.Heartbeat:Connect(function()
local char = getCharacter()
local canAct = canBlock()
if canAct and ((flags.autoBlock and flags.blockMode == "On Hit") or flags.autoDodge) then
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and attackingToward(plr.Character) then
lastThreat = tick()
if flags.autoDodge and tick() - lastDash > 0.6 then
task.spawn(doDash, dodgeKey())
end
break
end
end
end
local want = false
if flags.autoBlock and canAct then
if flags.blockMode == "Always" then
want = true
elseif flags.blockMode == "Enemy Near" then
want = nearestEnemy(flags.blockRange) ~= nil
else
want = tick() - lastThreat < flags.parryHold
end
end
if want and char then
if not char:GetAttribute("Blocking") then
if char:FindFirstChild("DoingEmote") then communicate({ Goal = "CancelEmote" }) end
communicate({ Goal = "KeyPress", Key = Enum.KeyCode.F })
blockActive = true
end
elseif blockActive then
communicate({ Goal = "KeyRelease", Key = Enum.KeyCode.F })
blockActive = false
end
end)
RunService.Heartbeat:Connect(function()
if not flags.antiRagdoll then return end
local char = getCharacter()
if not char then return end
local rag = char:FindFirstChild("Ragdoll")
if rag then rag:Destroy() end
end)
local STUN_NAMES = { Freeze = true, Slowed = true, RootAnchor = true }
RunService.Heartbeat:Connect(function()
if not flags.antiStun then return end
local char = getCharacter()
if not char then return end
for _, c in ipairs(char:GetChildren()) do
if STUN_NAMES[c.Name] then c:Destroy() end
end
end)
local hasDrawing = pcall(function()
local d = Drawing.new("Line"); d:Remove()
end)
local espCache = {}
local function removeEsp(plr)
local e = espCache[plr]
if not e then return end
if e.highlight then e.highlight:Destroy() end
for _, k in ipairs({ "box", "name", "dist", "tracer", "healthBg", "healthBar" }) do
if e[k] then pcall(function() e[k]:Remove() end) end
end
espCache[plr] = nil
end
local function getEsp(plr)
local e = espCache[plr]
if e then return e end
e = {}
e.highlight = Instance.new("Highlight")
e.highlight.FillTransparency = 0.5
e.highlight.OutlineTransparency = 0
e.highlight.Enabled = false
e.highlight.Parent = game:GetService("CoreGui")
if hasDrawing then
e.box = Drawing.new("Square"); e.box.Thickness = 1; e.box.Filled = false; e.box.Visible = false
e.name = Drawing.new("Text"); e.name.Size = 13; e.name.Center = true; e.name.Outline = true; e.name.Visible = false
e.dist = Drawing.new("Text"); e.dist.Size = 12; e.dist.Center = true; e.dist.Outline = true; e.dist.Visible = false
e.tracer = Drawing.new("Line"); e.tracer.Thickness = 1; e.tracer.Visible = false
e.healthBg = Drawing.new("Line"); e.healthBg.Thickness = 3; e.healthBg.Color = Color3.new(0, 0, 0); e.healthBg.Visible = false
e.healthBar = Drawing.new("Line"); e.healthBar.Thickness = 3; e.healthBar.Visible = false
end
espCache[plr] = e
return e
end
local function hideEsp(e)
if e.highlight then e.highlight.Enabled = false end
for _, k in ipairs({ "box", "name", "dist", "tracer", "healthBg", "healthBar" }) do
if e[k] then e[k].Visible = false end
end
end
RunService.RenderStepped:Connect(function()
if not flags.esp then
for _, e in pairs(espCache) do hideEsp(e) end
return
end
local myChar = getCharacter()
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer then
local char = getCharacter(plr)
local root = char and char:FindFirstChild("HumanoidRootPart")
local e = getEsp(plr)
local show = char and root and isAlive(char)
local dist = 0
if show and myRoot then
dist = (root.Position - myRoot.Position).Magnitude
if dist > flags.espMaxDistance then show = false end
end
if not show then
hideEsp(e)
else
local col = flags.espColor
if e.highlight then
e.highlight.Adornee = char
e.highlight.FillColor = col
e.highlight.OutlineColor = col
e.highlight.Enabled = flags.espHighlight
end
if hasDrawing then
local cf, size = char:GetBoundingBox()
local onScreen = true
local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
for x = -1, 1, 2 do
for y = -1, 1, 2 do
for z = -1, 1, 2 do
local world = (cf * CFrame.new(size.X / 2 * x, size.Y / 2 * y, size.Z / 2 * z)).Position
local sp, vis = Camera:WorldToViewportPoint(world)
if not vis then onScreen = false end
minX = math.min(minX, sp.X); minY = math.min(minY, sp.Y)
maxX = math.max(maxX, sp.X); maxY = math.max(maxY, sp.Y)
end
end
end
if onScreen then
e.box.Color = col
e.box.Position = Vector2.new(minX, minY)
e.box.Size = Vector2.new(maxX - minX, maxY - minY)
e.box.Visible = flags.espBoxes
e.name.Color = col
e.name.Text = plr.DisplayName
e.name.Position = Vector2.new((minX + maxX) / 2, minY - 16)
e.name.Visible = flags.espNames
e.dist.Color = col
e.dist.Text = string.format("%d studs", math.floor(dist))
e.dist.Position = Vector2.new((minX + maxX) / 2, maxY + 2)
e.dist.Visible = flags.espDistance
e.tracer.Color = col
e.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
e.tracer.To = Vector2.new((minX + maxX) / 2, maxY)
e.tracer.Visible = flags.espTracers
local hum = getHumanoid(char)
local frac = hum and hum.MaxHealth > 0 and math.clamp(hum.Health / hum.MaxHealth, 0, 1) or 1
local hx = minX - 5
local h = maxY - minY
e.healthBg.From = Vector2.new(hx, minY)
e.healthBg.To = Vector2.new(hx, maxY)
e.healthBg.Visible = flags.espHealth
e.healthBar.From = Vector2.new(hx, maxY - h * frac)
e.healthBar.To = Vector2.new(hx, maxY)
e.healthBar.Color = Color3.fromRGB(math.floor(255 * (1 - frac)), math.floor(255 * frac), 0)
e.healthBar.Visible = flags.espHealth
else
hideEsp(e)
end
end
end
end
end
end)
Players.PlayerRemoving:Connect(removeEsp)
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local function myRoot()
local c = getCharacter()
return c and c:FindFirstChild("HumanoidRootPart")
end
RunService.Heartbeat:Connect(function()
local char = getCharacter()
if not char then return end
if flags.walkLock then
if char:GetAttribute("CustomBaseSpeed") ~= flags.walkSpeed then
char:SetAttribute("CustomBaseSpeed", flags.walkSpeed)
char:SetAttribute("CustomAwakenSpeed", flags.walkSpeed)
end
end
if flags.jumpLock then
if char:GetAttribute("CustomBaseJumpPower") ~= flags.jumpPower then
char:SetAttribute("CustomBaseJumpPower", flags.jumpPower)
char:SetAttribute("CustomAwakenJumpPower", flags.jumpPower)
end
end
end)
UserInputService.JumpRequest:Connect(function()
if not flags.infJump then return end
local hum = getHumanoid(getCharacter())
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
RunService.Stepped:Connect(function()
if not flags.noclip then return end
local char = getCharacter()
if not char then return end
for _, p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
end
end)
local flyVel
RunService.RenderStepped:Connect(function()
if not flags.fly then
if flyVel then
flyVel:Destroy(); flyVel = nil
local h = getHumanoid(getCharacter())
if h then h.PlatformStand = false end
end
return
end
local root = myRoot()
local hum = getHumanoid(getCharacter())
if not (root and hum) then return end
hum.PlatformStand = true
if not flyVel then
flyVel = Instance.new("BodyVelocity")
flyVel.MaxForce = Vector3.new(1, 1, 1) * math.huge
flyVel.P = 1e4
flyVel.Parent = root
end
local cam = Camera.CFrame
local dir = Vector3.zero
if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
flyVel.Velocity = dir.Magnitude > 0 and dir.Unit * flags.flySpeed or Vector3.zero
end)
LocalPlayer.Idled:Connect(function()
if not flags.antiAfk then return end
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)
local function resetChar()
local hum = getHumanoid(getCharacter())
if hum then hum.Health = 0 end
end
local function tpTo(cf)
local r = myRoot()
if r and cf then r.CFrame = cf end
end
local function behindCF(targetRoot)
local b = targetRoot.CFrame * CFrame.new(0, 0, 3)
return CFrame.new(b.Position, targetRoot.Position)
end
local function playerNames()
local t = {}
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer then t[#t + 1] = p.Name end
end
return t
end
local function rootOfPlayerName(name)
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Name == name and p.Character then
return p.Character:FindFirstChild("HumanoidRootPart")
end
end
end
local function findDummyRoot()
for _, m in ipairs(workspace:GetChildren()) do
if m:IsA("Model") and isDummy(m) then
local r = m:FindFirstChild("HumanoidRootPart")
if r then return r end
end
end
end
local function spawnCF()
local s = workspace:FindFirstChildWhichIsA("SpawnLocation", true)
if s then return s.CFrame * CFrame.new(0, 3, 0) end
return CFrame.new(0, 10, 0)
end
local waypoints = {}
local function wpNames()
local t = {}
for n in pairs(waypoints) do t[#t + 1] = n end
return t
end
local function rejoin()
TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end
local function serverHop()
local ok, body = pcall(function()
return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
end)
if not ok then window:Notify("Server Hop", "Request failed", 5); return end
local data = HttpService:JSONDecode(body)
for _, s in ipairs(data.data or {}) do
if s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
return
end
end
window:Notify("Server Hop", "No open server found", 5)
end
local function copyJobId()
if setclipboard then
setclipboard(game.JobId)
window:Notify("Server Tools", "Job ID copied", 4)
else
window:Notify("Server Tools", "setclipboard unavailable", 4)
end
end
local killAuraToggle = sections.combat:CreateToggle("Kill Aura", false, function(v) flags.killAura = v end)
killAuraToggle:CreateKeybind("K", function() end, "Toggle")
sections.combat:CreateToggle("Auto M1 (Nearest Enemy)", flags.autoM1, function(v) flags.autoM1 = v end)
sections.combat:CreateToggle("Auto Face Target", false, function(v) flags.autoFace = v end)
sections.combat:CreateToggle("Stay In Melee Range", false, function(v) flags.stayInRange = v end)
sections.combat:CreateSlider("Target Range", 5, 40, flags.targetRange, false, function(v) flags.targetRange = v end)
sections.combat:CreateSlider("M1 Speed", 1, 25, flags.m1Speed, true, function(v) flags.m1Speed = v end)
sections.combat:CreateToggle("Ignore Training Dummy", false, function(v) flags.ignoreDummy = v end)
local autoSkillsToggle = sections.skills:CreateToggle("Auto Use Skills (1-4)", false, function(v) flags.autoSkills = v end)
autoSkillsToggle:CreateKeybind("N", function() end, "Toggle")
sections.skills:CreateDropdown("Skill Mode", { "Combo Rotation", "Single Skill" }, function(v) flags.skillMode = v end, "Combo Rotation", false)
sections.skills:CreateDropdown("Single Skill", { "1", "2", "3", "4" }, function(v) flags.singleSkill = v end, "1", false)
sections.skills:CreateDropdown("Tap / Hold Mode", { "Tap", "Hold" }, function(v) flags.tapHold = v end, "Tap", false)
sections.skills:CreateSlider("Skill Uses Per Second", 1, 10, flags.skillSpeed, false, function(v) flags.skillSpeed = v end)
sections.skills:CreateButton("Send Skill Key Once", function()
if flags.skillMode == "Single Skill" then pressSkill(flags.singleSkill) else pressSkill(comboOrder[comboIndex]) end
end)
sections.skills:CreateToggle("Auto Grab", false, function(v) flags.autoGrab = v end)
sections.skills:CreateDropdown("Grab Key", { "G", "H", "T", "Y", "Q", "R" }, function(v) flags.grabKey = v end, "G", false)
local autoUltToggle = sections.skills:CreateToggle("Auto Ultimate (When Full)", false, function(v) flags.autoUlt = v end)
autoUltToggle:CreateKeybind("M", function() end, "Toggle")
local autoBlockToggle = sections.defense:CreateToggle("Auto Block", false, function(v) flags.autoBlock = v end)
autoBlockToggle:CreateKeybind("P", function() end, "Toggle")
sections.defense:CreateDropdown("Block Mode", { "Always", "Enemy Near", "On Hit" }, function(v) flags.blockMode = v end, "On Hit", false)
sections.defense:CreateSlider("Block Range", 5, 30, flags.blockRange, false, function(v) flags.blockRange = v end)
sections.defense:CreateToggle("Anti Ragdoll", false, function(v) flags.antiRagdoll = v end)
sections.defense:CreateToggle("Anti Stun", false, function(v) flags.antiStun = v end)
local autoDodgeToggle = sections.defense:CreateToggle("Auto Dodge", false, function(v) flags.autoDodge = v end)
autoDodgeToggle:CreateKeybind("J", function() end, "Toggle")
local autoDashToggle = sections.defense:CreateToggle("Auto Dash", false, function(v) flags.autoDash = v end)
autoDashToggle:CreateKeybind("H", function() end, "Toggle")
sections.defense:CreateSlider("Auto Dash Delay", 1, 8, flags.autoDashDelay, false, function(v) flags.autoDashDelay = v end)
sections.playerTools:CreateToggle("WalkSpeed", false, function(v)
flags.walkLock = v
if not v then
local c = getCharacter()
if c then c:SetAttribute("CustomBaseSpeed", nil); c:SetAttribute("CustomAwakenSpeed", nil) end
end
end)
sections.playerTools:CreateSlider("WalkSpeed", 16, 250, flags.walkSpeed, false, function(v) flags.walkSpeed = v end)
sections.playerTools:CreateToggle("JumpPower", false, function(v)
flags.jumpLock = v
if not v then
local c = getCharacter()
if c then c:SetAttribute("CustomBaseJumpPower", nil); c:SetAttribute("CustomAwakenJumpPower", nil) end
end
end)
sections.playerTools:CreateSlider("JumpPower", 50, 350, flags.jumpPower, false, function(v) flags.jumpPower = v end)
sections.playerTools:CreateToggle("Infinite Jump", false, function(v) flags.infJump = v end)
sections.playerTools:CreateToggle("Fly", false, function(v) flags.fly = v end)
sections.playerTools:CreateSlider("Fly Speed", 10, 250, flags.flySpeed, false, function(v) flags.flySpeed = v end)
sections.playerTools:CreateToggle("Noclip", false, function(v) flags.noclip = v end)
sections.playerTools:CreateToggle("Anti-AFK", false, function(v) flags.antiAfk = v end)
sections.playerTools:CreateButton("Reset Character", resetChar)
local tpTargetName = ""
local tpDrop = sections.teleports:CreateDropdown("Target Player", playerNames(), function(v) tpTargetName = v end, "", false)
sections.teleports:CreateButton("Teleport To Player", function()
local r = rootOfPlayerName(tpTargetName)
if r then tpTo(r.CFrame) end
end)
sections.teleports:CreateButton("Teleport Behind Player", function()
local r = rootOfPlayerName(tpTargetName)
if r then tpTo(behindCF(r)) end
end)
sections.teleports:CreateButton("Teleport To Nearest Enemy", function()
local t = nearestEnemy(math.huge)
if t then tpTo(t.root.CFrame) end
end)
sections.teleports:CreateButton("Teleport Behind Nearest Enemy", function()
local t = nearestEnemy(math.huge)
if t then tpTo(behindCF(t.root)) end
end)
sections.teleports:CreateButton("Teleport To Training Dummy", function()
local r = findDummyRoot()
if r then tpTo(r.CFrame * CFrame.new(0, 0, 4)) end
end)
sections.teleports:CreateButton("Teleport To Spawn", function()
tpTo(spawnCF())
end)
local wpNameInput = ""
sections.teleports:CreateTextBox("Waypoint Name", "", false, function(v) wpNameInput = v end)
local wpSelName = ""
local wpDrop = sections.teleports:CreateDropdown("Saved Waypoints", {}, function(v) wpSelName = v end, "", false)
local function refreshWps() wpDrop:ChangeOptions(wpNames(), wpSelName) end
sections.teleports:CreateButton("Save Waypoint", function()
local r = myRoot()
if not r then return end
local name = (wpNameInput ~= "" and wpNameInput) or ("Waypoint " .. (#wpNames() + 1))
waypoints[name] = r.CFrame
refreshWps()
window:Notify("Teleports", "Saved: " .. name, 3)
end)
sections.teleports:CreateButton("Teleport To Waypoint", function()
local cf = waypoints[wpSelName]
if cf then tpTo(cf) end
end)
sections.teleports:CreateButton("Delete Waypoint", function()
if wpSelName ~= "" and waypoints[wpSelName] then
waypoints[wpSelName] = nil
wpSelName = ""
refreshWps()
end
end)
local function refreshPlayers() tpDrop:ChangeOptions(playerNames(), tpTargetName) end
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
sections.server:CreateButton("Rejoin Server", rejoin)
sections.server:CreateButton("Server Hop", serverHop)
sections.server:CreateButton("Copy Job ID", copyJobId)
local infoLabel = sections.server:CreateLabel("Server Info: loading...")
task.spawn(function()
while true do
infoLabel:UpdateText(string.format(
"Players: %d/%d | Ping: %dms",
#Players:GetPlayers(), Players.MaxPlayers, math.floor(getPing())
))
task.wait(2)
end
end)
sections.esp:CreateToggle("Player ESP", false, function(v)
flags.esp = v
if not v then for _, e in pairs(espCache) do hideEsp(e) end end
end)
sections.esp:CreateToggle("Box ESP", flags.espBoxes, function(v) flags.espBoxes = v end)
sections.esp:CreateToggle("Name ESP", flags.espNames, function(v) flags.espNames = v end)
sections.esp:CreateToggle("Health Bar", flags.espHealth, function(v) flags.espHealth = v end)
sections.esp:CreateToggle("Distance", flags.espDistance, function(v) flags.espDistance = v end)
sections.esp:CreateToggle("Tracers", flags.espTracers, function(v) flags.espTracers = v end)
sections.esp:CreateToggle("Chams / Highlight", flags.espHighlight, function(v) flags.espHighlight = v end)
sections.esp:CreateSlider("ESP Max Distance", 50, 2000, flags.espMaxDistance, true, function(v) flags.espMaxDistance = v end)
sections.esp:CreateColorpicker("ESP Color", function(color) flags.espColor = color end)
local ACCENT = Color3.fromRGB(120, 170, 255)
local kbStatus = {
{ name = "Kill Aura", key = "K", get = function() return flags.killAura end, set = function(v) flags.killAura = v end },
{ name = "Auto Skills", key = "N", get = function() return flags.autoSkills end, set = function(v) flags.autoSkills = v end },
{ name = "Auto Ultimate", key = "M", get = function() return flags.autoUlt end, set = function(v) flags.autoUlt = v end },
{ name = "Auto Block", key = "P", get = function() return flags.autoBlock end, set = function(v) flags.autoBlock = v end },
{ name = "Auto Dodge", key = "J", get = function() return flags.autoDodge end, set = function(v) flags.autoDodge = v end },
{ name = "Auto Dash", key = "H", get = function() return flags.autoDash end, set = function(v) flags.autoDash = v end },
}
local panelGui
local function getPanelGui()
if panelGui and panelGui.Parent then return panelGui end
panelGui = Instance.new("ScreenGui")
panelGui.Name = "KB_" .. tostring(math.random(100000, 999999))
panelGui.ResetOnSpawn = false
panelGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
panelGui.IgnoreGuiInset = true
panelGui.DisplayOrder = 9999
panelGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
return panelGui
end
local function hexColor(c)
return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end
local function colored(text, color)
return string.format('<font color="%s">%s</font>', hexColor(color), text)
end
local function makeDraggable(frame, handle)
local dragging, dragStart, startPos
handle.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true; dragStart = input.Position; startPos = frame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then dragging = false end
end)
end
end)
UserInputService.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)
end
local function makePanel(title, position)
local frame = Instance.new("Frame")
frame.Name = title
frame.Position = position
frame.Size = UDim2.fromOffset(214, 30)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
frame.BackgroundTransparency = 0.06
frame.BorderSizePixel = 0
frame.Active = true
frame.Visible = false
frame.Parent = getPanelGui()
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0, 0, 0); stroke.Transparency = 0.35; stroke.Thickness = 1
local bar = Instance.new("Frame")
bar.Name = "Bar"; bar.Size = UDim2.new(1, 0, 0, 26)
bar.BackgroundColor3 = Color3.fromRGB(30, 30, 40); bar.BorderSizePixel = 0; bar.Parent = frame
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 6)
local accent = Instance.new("Frame")
accent.Size = UDim2.new(0, 3, 1, -8); accent.Position = UDim2.new(0, 6, 0, 4)
accent.BackgroundColor3 = ACCENT; accent.BorderSizePixel = 0; accent.Parent = bar
Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
local titleLabel = Instance.new("TextLabel")
titleLabel.BackgroundTransparency = 1; titleLabel.Position = UDim2.fromOffset(16, 0)
titleLabel.Size = UDim2.new(1, -20, 1, 0); titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13; titleLabel.TextColor3 = Color3.fromRGB(235, 235, 242)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.Text = title; titleLabel.Parent = bar
local content = Instance.new("Frame")
content.Name = "Content"; content.BackgroundTransparency = 1
content.Position = UDim2.fromOffset(0, 26); content.Size = UDim2.new(1, 0, 0, 0); content.Parent = frame
local layout = Instance.new("UIListLayout", content)
layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 3)
local pad = Instance.new("UIPadding", content)
pad.PaddingTop = UDim.new(0, 7); pad.PaddingBottom = UDim.new(0, 7)
pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
local h = layout.AbsoluteContentSize.Y + 14
content.Size = UDim2.new(1, 0, 0, h)
frame.Size = UDim2.fromOffset(frame.Size.X.Offset, 26 + h)
end)
makeDraggable(frame, bar)
return frame, content
end
local function makeRow(content, order)
local row = Instance.new("TextButton")
row.BackgroundTransparency = 1; row.Size = UDim2.new(1, 0, 0, 16); row.LayoutOrder = order
row.Font = Enum.Font.Gotham; row.TextSize = 12; row.RichText = true
row.TextColor3 = Color3.fromRGB(215, 215, 225); row.TextXAlignment = Enum.TextXAlignment.Left
row.Text = ""; row.AutoButtonColor = false; row.Parent = content
return row
end
local kbPanel, kbContent = makePanel("Keybinds", UDim2.fromOffset(20, 120))
local kbRows = {}
local function refreshKeybinds()
for i, kb in ipairs(kbStatus) do
local row = kbRows[i]
if row then
local on = kb.get()
row.Text = colored("[" .. kb.key .. "]", ACCENT) .. " " .. kb.name
.. "  " .. colored(on and "ON" or "OFF", on and Color3.fromRGB(120, 255, 150) or Color3.fromRGB(255, 110, 110))
end
end
end
for i, kb in ipairs(kbStatus) do
local row = makeRow(kbContent, i)
row.MouseButton1Click:Connect(function()
kb.set(not kb.get())
refreshKeybinds()
end)
kbRows[i] = row
end
refreshKeybinds()
RunService.RenderStepped:Connect(function()
if kbPanel.Visible ~= flags.keybindsPanel then kbPanel.Visible = flags.keybindsPanel end
if flags.keybindsPanel then refreshKeybinds() end
end)
sections.iface:CreateToggle("Keybinds Panel", true, function(v) flags.keybindsPanel = v end)
sections.iface:CreateLabel("On-screen ON/OFF readout. Tap a row to toggle (mobile).", true)
window:Notify("Kali Hub", "https://kalihub.xyz", 15)
sections.config:CreateDropdown(
"Change Font",
stored_fonts,
function(value)
window:SetFont(value)
end,
"",
false
)
local cleanKeyName = tostring(config.Keybind):gsub("Enum.KeyCode.", "")
sections.config:CreateLabel("Close Menu Key (PC): " .. cleanKeyName)
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
