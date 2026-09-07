--this shit was unobfuscated


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
Camera = Workspace.CurrentCamera
end)
local G = getgenv()
if G.OpOne and G.OpOne.cleanup then pcall(G.OpOne.cleanup) end
G.OpOne = G.OpOne or {}
local F = G.OpOne
F.conns = {}
local function track(c) table.insert(F.conns, c); return c end
local function resolvePlayer(char)
return Players:GetPlayerFromCharacter(char) or Players:FindFirstChild(char.Name)
end
local cfg = F.cfg or {
silent = false,
fov = 140,
fovCircle = true,
aimbot = false,
legit = false,
smoothness = 10,
adsOnly = false,
fireOnly = false,
turnRate = 220,
reactionMs = 120,
targetPart = "Head",
headOffset = 2.5,
teamCheck = true,
wallCheck = true,
sticky = false,
maxDist = 1000,
priority = "Crosshair",
prediction = 0,
noRecoil = false,
noSpread = false,
infAmmo = false,
esp = false, espBox = true, espName = true, espDist = true,
espHealth = true, espTracer = false, espHead = false,
espTeam = false, espMaxDist = 1500,
boxStyle = "Corner", boxOutline = true,
espObjects = false, espBomb = true, espCam = true, espDrone = true,
chams = false, chamsTeam = false, chamsXray = true, chamsFill = 0.5,
fullbright = false, noFog = false, noAtmosphere = false,
timeSet = false, clockTime = 14, brightnessSet = false, brightness = 2,
crosshair = false, crossSize = 10, crossGap = 4, crossThick = 2,
crossDot = false, crossChroma = false, crossColor = Color3.fromRGB(0,255,120),
fovMod = false, camFov = 90,
spinbot = false, spinSpeed = 20, antiAfk = true,
}
F.cfg = cfg
local bus = CoreGui:FindFirstChild("OpOneBus")
if not bus then
bus = Instance.new("Configuration")
bus.Name = "OpOneBus"
bus.Parent = CoreGui
end
F.bus = bus
local function pushCfg()
bus:SetAttribute("silent", cfg.silent)
bus:SetAttribute("noRecoil", cfg.noRecoil)
bus:SetAttribute("noSpread", cfg.noSpread)
bus:SetAttribute("infAmmo", cfg.infAmmo)
bus:SetAttribute("fov", cfg.fov)
bus:SetAttribute("teamCheck", cfg.teamCheck)
bus:SetAttribute("wallCheck", cfg.wallCheck)
bus:SetAttribute("aimHeight", cfg.targetPart == "Head" and cfg.headOffset or 0)
end
local function aimActive()
return (not cfg.adsOnly) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
end
local function partsOf(char)
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")
if hum and hum.Health > 0 and root then return hum, root end
end
local function enemyChars()
local out, myChar = {}, LocalPlayer.Character
for _, char in ipairs(CollectionService:GetTagged("Character")) do
if char ~= myChar and char.Name ~= LocalPlayer.Name and char:IsDescendantOf(Workspace) then
local pl = resolvePlayer(char)
local sameTeam = cfg.teamCheck and pl and pl.Team and LocalPlayer.Team and pl.Team == LocalPlayer.Team
if not sameTeam then out[#out+1] = { char = char, player = pl } end
end
end
return out
end
local function aimPointOf(root)
local p = root.Position
if cfg.targetPart == "Head" then p = p + Vector3.new(0, cfg.headOffset, 0) end
if cfg.prediction > 0 then p = p + root.AssemblyLinearVelocity * cfg.prediction end
return p
end
local function screenPos(pos)
local v = Camera:WorldToViewportPoint(pos)
return Vector2.new(v.X, v.Y), v.Z
end
local function visibleTo(pos, char)
if not cfg.wallCheck then return true end
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.RespectCanCollide = true
params.FilterDescendantsInstances = { LocalPlayer.Character, Camera, char, Workspace:FindFirstChild("Viewmodels") }
local origin = Camera.CFrame.Position
return Workspace:Raycast(origin, pos - origin, params) == nil
end
local function getTarget(fov, requireVisible)
local center = Camera.ViewportSize / 2
local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if cfg.sticky and F.lockChar and F.lockChar.Parent then
local hum, root = partsOf(F.lockChar)
if root then
local pos = aimPointOf(root)
local sp, z = screenPos(pos)
if z > 0 and (sp - center).Magnitude <= fov * 1.35
and (not requireVisible or visibleTo(pos, F.lockChar)) then
return F.lockChar, pos
end
end
F.lockChar = nil
end
local best, bestPos, bestScore
for _, e in ipairs(enemyChars()) do
local hum, root = partsOf(e.char)
if root then
local pos = aimPointOf(root)
local sp, z = screenPos(pos)
local screenDist = (sp - center).Magnitude
local worldDist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
if z > 0 and screenDist <= fov and worldDist <= cfg.maxDist then
if not requireVisible or visibleTo(pos, e.char) then
local score = (cfg.priority == "Distance" and worldDist)
or (cfg.priority == "Health" and hum.Health)
or screenDist
if not bestScore or score < bestScore then
best, bestPos, bestScore = e.char, pos, score
end
end
end
end
end
if best then F.lockChar = best end
return best, bestPos
end
local ACTOR_SRC = [==[
	if getgenv().__OpOneActor then return end
	if type(hookfunction) ~= "function" or type(getgc) ~= "function" then return end

	local Players = game:GetService("Players")
	local Workspace = game:GetService("Workspace")
	local CoreGui = game:GetService("CoreGui")
	local LocalPlayer = Players.LocalPlayer

	local CollectionService = game:GetService("CollectionService")
	local bus = CoreGui:WaitForChild("OpOneBus", 10)
	if not bus then return end
	getgenv().__OpOneActor = true

	
	
	
	
	local st = { fov = 140 }
	
	
	
	
	local function findController()
		for _, v in getgc(true) do
			if type(v) == "table" then
				local ok, mine = pcall(function()
					return rawget(v, "instance") == LocalPlayer.Character and rawget(v, "values") ~= nil
				end)
				if ok and mine then return v end
			end
		end
	end
	local function ensureController()
		local ch = getgenv().__OpChar
		
		if ch then
			local ok, valid = pcall(function() return rawget(ch, "instance") == LocalPlayer.Character end)
			if ok and valid then return ch end
			getgenv().__OpChar = nil
		end
		local c = findController()
		if c then getgenv().__OpChar = c end
		return c
	end
	local function localGun()
		local ch = getgenv().__OpChar
		local g = ch and ch.values and ch.values.equipped
		if type(g) == "table" and g.states then return g end
	end
	
	
	local function nset(state, val)
		if not state then return end
		if not pcall(function() state:set_no_replication(val) end) then
			pcall(function() state:set(val) end)
		end
	end
	task.spawn(function()
		while true do
			pcall(function()
				st.silent       = bus:GetAttribute("silent")
				st.noRecoil     = bus:GetAttribute("noRecoil")
				st.noSpread     = bus:GetAttribute("noSpread")
				st.infAmmo      = bus:GetAttribute("infAmmo")
				st.fov          = bus:GetAttribute("fov") or 140
				st.aimHeight    = bus:GetAttribute("aimHeight") or 2.5
				st.teamCheck    = bus:GetAttribute("teamCheck")
				st.wallCheck    = bus:GetAttribute("wallCheck")


				if (os.clock() - (st.lastScan or 0)) > 0.5 then
					st.lastScan = os.clock()
					ensureController()
				end

				local gun = localGun()
				if gun then
					local s = gun.states
					if st.infAmmo then
						if s.mag and s.mag_size then
							local ms = s.mag_size:get()
							if ms and ms > 0 then nset(s.mag, ms) end
						end
						if s.bullets then nset(s.bullets, 999) end   
					end
				end
			end)
			task.wait(0.03)
		end
	end)



	local function findTarget(fov)
		local cam = Workspace.CurrentCamera
		if not cam then return end
		local vp = cam.ViewportSize
		local center = Vector2.new(vp.X / 2, vp.Y / 2)
		local myChar = LocalPlayer.Character
		local bestPos, bestD
		for _, char in ipairs(CollectionService:GetTagged("Character")) do
			if char ~= myChar and char.Name ~= LocalPlayer.Name and char.Parent then
				local hum  = char:FindFirstChildOfClass("Humanoid")
				local root = char:FindFirstChild("HumanoidRootPart")
				if hum and hum.Health > 0 and root then
					local aim = root.Position + Vector3.new(0, st.aimHeight or 2.5, 0)
					local pl = Players:GetPlayerFromCharacter(char) or Players:FindFirstChild(char.Name)
					local sameTeam = st.teamCheck and pl and pl.Team and LocalPlayer.Team and pl.Team == LocalPlayer.Team
					if not sameTeam then
						local sp = cam:WorldToViewportPoint(aim)
						local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
						if sp.Z > 0 and d <= fov and (not bestD or d < bestD) then
							local clear = true
							if st.wallCheck then
								local rp = RaycastParams.new()
								rp.FilterType = Enum.RaycastFilterType.Exclude
								rp.RespectCanCollide = true
								rp.FilterDescendantsInstances = { myChar, char, Workspace:FindFirstChild("Viewmodels") }
								local o = cam.CFrame.Position
								clear = Workspace:Raycast(o, aim - o, rp) == nil
							end
							if clear then bestPos, bestD = aim, d end
						end
					end
				end
			end
		end
		return bestPos
	end


	
	
	
	local function installHooks(cls)
		if type(cls) ~= "table" or type(rawget(cls, "get_shoot_look")) ~= "function" then return false end

		
		
		local oldLook
		oldLook = hookfunction(cls.get_shoot_look, function(self, ...)
			local orig = oldLook(self, ...)
			if st.silent and typeof(orig) == "CFrame" then
				local tp = findTarget(st.fov)
				if tp then return CFrame.lookAt(orig.Position, tp) end
			end
			return orig
		end)

		
		
		if type(rawget(cls, "recoil_function")) == "function" then
			local oldRecoil
			oldRecoil = hookfunction(cls.recoil_function, function(self, ...)
				if st.noRecoil then
					local s = (self.object or self).states
					if s then nset(s.recoil_up, 0); nset(s.recoil_side, 0) end
				end
				return oldRecoil(self, ...)
			end)
		end

		
		if type(rawget(cls, "send_shoot")) == "function" then
			local oldSend
			oldSend = hookfunction(cls.send_shoot, function(self, ...)
				if st.noSpread then
					local s = (self.object or self).states
					if s then nset(s.spread, 0) end
				end
				return oldSend(self, ...)
			end)
		end

		
		if type(rawget(cls, "render")) == "function" then
			local oldRender
			oldRender = hookfunction(cls.render, function(self, ...)
				local o = self.owner
				if o and o.instance == LocalPlayer.Character then
					getgenv().__OpChar = o
				end
				return oldRender(self, ...)
			end)
		end
		return true
	end

	
	
	
	
	local function findGunClass()
		local ok, m = pcall(function()
			return require(game:GetService("ReplicatedStorage").Modules.Items.Item.Gun)
		end)
		if ok and type(m) == "table" and rawget(m, "get_shoot_look") then return m, "module" end
		local ok2, mods = pcall(function() return game:GetService("ReplicatedStorage"):GetDescendants() end)
		if ok2 then
			for _, d in ipairs(mods) do
				if d:IsA("ModuleScript") and d.Name == "Gun" then
					local ok3, m3 = pcall(require, d)
					if ok3 and type(m3) == "table" and rawget(m3, "get_shoot_look") then return m3, "search" end
				end
			end
		end
	end

	task.spawn(function()
		for _ = 1, 20 do
			local cls, how = findGunClass()
			if cls and installHooks(cls) then bus:SetAttribute("hookState", how); return end
			task.wait(0.5)
		end
		
		while true do
			for _, v in getgc(true) do
				if type(v) == "table" then
					local okI, res = pcall(installHooks, v)
					if okI and res then bus:SetAttribute("hookState", "getgc"); return end
				end
			end
			task.wait(1)
		end
	end)
]==]
local getActors = getactors or get_actors
local actorOk = type(run_on_actor) == "function"
local ensureActor
do
local function install()
local ran = false
local pa = LocalPlayer:FindFirstChildWhichIsA("Actor", true)
or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Actor", true))
if pa then pcall(run_on_actor, pa, ACTOR_SRC); ran = true end
if type(getActors) == "function" then
local ok, actors = pcall(getActors)
if ok and actors then
for _, actor in ipairs(actors) do
if actor ~= pa then pcall(run_on_actor, actor, ACTOR_SRC) end
end
ran = ran or #actors > 0
end
end
return ran
end
ensureActor = function()
if not actorOk or F.hooked then return end
pushCfg()
F.hooked = install()
if F.hooked then
track(LocalPlayer.CharacterAdded:Connect(function()
task.wait(1)
install()
end))
end
end
end
local fovCircle
if Drawing then
fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1; fovCircle.NumSides = 64; fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255,255,255); fovCircle.Transparency = 0.6; fovCircle.Visible = false
end
track(RunService.RenderStepped:Connect(function()
pushCfg()
if fovCircle then
fovCircle.Radius = cfg.fov
fovCircle.Position = Camera.ViewportSize / 2
fovCircle.Visible = cfg.fovCircle and (cfg.aimbot or cfg.legit or cfg.silent)
end
end))
local aim = { char = nil, since = 0, jitter = Vector3.zero, jitterAt = 0 }
local function humanPoint(pos, char)
local now = os.clock()
if char ~= aim.char then aim.char, aim.since = char, now end
if now - aim.since < cfg.reactionMs / 1000 then return end
if now - aim.jitterAt > 0.4 then
aim.jitterAt = now
aim.jitter = Vector3.new(math.random() - 0.5, (math.random() - 0.5) * 0.6, math.random() - 0.5) * 0.7
end
return pos + aim.jitter
end
pcall(RunService.UnbindFromRenderStep, RunService, "OpOneAim")
RunService:BindToRenderStep("OpOneAim", Enum.RenderPriority.Camera.Value + 1, function(dt)
if not (cfg.aimbot or cfg.legit) or not aimActive()
or (cfg.fireOnly and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
aim.char = nil
return
end
local char, pos = getTarget(cfg.fov, cfg.wallCheck)
if not (char and pos) then aim.char = nil; return end
pos = humanPoint(pos, char)
if not pos then return end
local cf = Camera.CFrame
local goal = CFrame.new(cf.Position, pos)
local angle = math.acos(math.clamp(cf.LookVector:Dot(goal.LookVector), -1, 1))
local alpha = cfg.aimbot and 1 or math.clamp(1 / math.max(cfg.smoothness, 1), 0, 1)
if angle > 0 then
alpha = math.min(alpha, math.rad(cfg.turnRate) * dt / angle)
end
Camera.CFrame = cf:Lerp(goal, alpha)
end)
local COLORS = { enemy = Color3.fromRGB(255, 80, 80), ally = Color3.fromRGB(90, 170, 255) }
local function mkd(kind, props)
local d = Drawing.new(kind); for k, v in pairs(props) do d[k] = v end; return d
end
local espCache, chamsCache, objCache = {}, {}, {}
local chamsFolder = CoreGui:FindFirstChild("OpChamsFolder") or Instance.new("Folder")
chamsFolder.Name = "OpChamsFolder"; chamsFolder.Parent = CoreGui
local function makeEsp()
local e = {
box = mkd("Square", { Thickness = 1, Filled = false, Visible = false }),
outline = mkd("Square", { Thickness = 3, Filled = false, Color = Color3.new(0,0,0), Visible = false }),
name = mkd("Text", { Size = 13, Center = true, Outline = true, Visible = false }),
dist = mkd("Text", { Size = 12, Center = true, Outline = true, Color = Color3.new(1,1,1), Visible = false }),
hpbg = mkd("Line", { Thickness = 3, Color = Color3.new(0,0,0), Visible = false }),
hp = mkd("Line", { Thickness = 1, Color = Color3.fromRGB(80,255,120), Visible = false }),
tracer = mkd("Line", { Thickness = 1, Visible = false }),
head = mkd("Circle", { Radius = 3, Filled = true, NumSides = 12, Visible = false }),
corners = {},
}
for i = 1, 8 do e.corners[i] = mkd("Line", { Thickness = 1, Visible = false }) end
return e
end
local ESP_KEYS = { "box", "outline", "name", "dist", "hpbg", "hp", "tracer", "head" }
local function hideEsp(e)
for _, k in ipairs(ESP_KEYS) do e[k].Visible = false end
for _, l in ipairs(e.corners) do l.Visible = false end
end
local function destroyEsp(e)
for _, k in ipairs(ESP_KEYS) do pcall(function() e[k]:Remove() end) end
for _, l in ipairs(e.corners) do pcall(function() l:Remove() end) end
end
local function projectBox(cf, size)
local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
for x = -1, 1, 2 do for y = -1, 1, 2 do for z = -1, 1, 2 do
local sp = Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2*x, size.Y/2*y, size.Z/2*z)).Position)
if sp.Z <= 0 then return end
minX = math.min(minX, sp.X); minY = math.min(minY, sp.Y)
maxX = math.max(maxX, sp.X); maxY = math.max(maxY, sp.Y)
end end end
if maxX > minX then return minX, minY, maxX - minX, maxY - minY end
end
local function charBox(hrp, head)
local root = hrp.Position
local rs = Camera:WorldToViewportPoint(root)
if rs.Z <= 0 then return end
local top = (head and head.Position or (root + Vector3.new(0, 2.2, 0))) + Vector3.new(0, 0.8, 0)
local bot = root - Vector3.new(0, 3.2, 0)
local ts = Camera:WorldToViewportPoint(top)
local bs = Camera:WorldToViewportPoint(bot)
if ts.Z <= 0 or bs.Z <= 0 then return end
local topY, botY = math.min(ts.Y, bs.Y), math.max(ts.Y, bs.Y)
local h = botY - topY
local vpY = Camera.ViewportSize.Y
if h ~= h or h < 1 or h > vpY * 3 then return end
local w = h * 0.62
local cx = rs.X
if cx ~= cx or cx < -vpY or cx > Camera.ViewportSize.X + vpY then return end
return cx - w / 2, topY, w, h
end
local function styleBox(e, x, y, w, h, col, show)
e.box.Visible = false; e.outline.Visible = false
for _, l in ipairs(e.corners) do l.Visible = false end
if not show then return end
if cfg.boxStyle == "Normal" then
e.box.Color = col; e.box.Position = Vector2.new(x, y); e.box.Size = Vector2.new(w, h); e.box.Visible = true
if cfg.boxOutline then
e.outline.Position = Vector2.new(x - 1, y - 1); e.outline.Size = Vector2.new(w + 2, h + 2); e.outline.Visible = true
end
return
end
local len = (cfg.boxStyle == "Bracket") and h * 0.5 or math.max(4, math.min(w, h) * 0.28)
local seg = {
{ Vector2.new(x, y), Vector2.new(x + len, y) }, { Vector2.new(x, y), Vector2.new(x, y + len) },
{ Vector2.new(x + w, y), Vector2.new(x + w - len, y) }, { Vector2.new(x + w, y), Vector2.new(x + w, y + len) },
{ Vector2.new(x, y + h), Vector2.new(x + len, y + h) }, { Vector2.new(x, y + h), Vector2.new(x, y + h - len) },
{ Vector2.new(x + w, y + h), Vector2.new(x + w - len, y + h) }, { Vector2.new(x + w, y + h), Vector2.new(x + w, y + h - len) },
}
for i, l in ipairs(e.corners) do
l.From = seg[i][1]; l.To = seg[i][2]; l.Color = col; l.Visible = true
end
end
local function espChars()
local out, myChar = {}, LocalPlayer.Character
for _, char in ipairs(CollectionService:GetTagged("Character")) do
if char ~= myChar and char.Name ~= LocalPlayer.Name and char:IsDescendantOf(Workspace)
and resolvePlayer(char) ~= LocalPlayer then
out[#out+1] = char
end
end
return out
end
local function updateEsp()
if not Drawing then return end
local vp = Camera.ViewportSize
local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local seen = {}
if cfg.esp then
for _, char in ipairs(espChars()) do
local ok = pcall(function()
local hrp = char:FindFirstChild("HumanoidRootPart")
local head = char:FindFirstChild("head") or char:FindFirstChild("Head")
local hum = char:FindFirstChildOfClass("Humanoid")
local pl = resolvePlayer(char)
local ally = pl and pl.Team and LocalPlayer.Team and pl.Team == LocalPlayer.Team
if hrp and hum and hum.Health > 0 and (not ally or cfg.espTeam) then
seen[char] = true
local e = espCache[char] or makeEsp(); espCache[char] = e
local col = ally and COLORS.ally or COLORS.enemy
local dist = myRoot and (hrp.Position - myRoot.Position).Magnitude or 0
local drawn = false
if dist <= cfg.espMaxDist then
local x, y, w, h = charBox(hrp, head)
if x then
drawn = true
styleBox(e, x, y, w, h, col, cfg.espBox)
e.name.Text = (pl and pl.Name) or char.Name; e.name.Color = col; e.name.Position = Vector2.new(x + w/2, y - 16); e.name.Visible = cfg.espName
e.dist.Text = string.format("%dm", math.floor(dist)); e.dist.Position = Vector2.new(x + w/2, y + h + 2); e.dist.Visible = cfg.espDist
if hum and cfg.espHealth then
local maxhp = (hum.MaxHealth > 0 and hum.MaxHealth) or 100
local pct = math.clamp(hum.Health / maxhp, 0, 1)
e.hpbg.From = Vector2.new(x - 4, y); e.hpbg.To = Vector2.new(x - 4, y + h); e.hpbg.Visible = true
e.hp.From = Vector2.new(x - 4, y + h); e.hp.To = Vector2.new(x - 4, y + h - h * pct); e.hp.Visible = true
else e.hpbg.Visible = false; e.hp.Visible = false end
e.tracer.Color = col; e.tracer.From = Vector2.new(vp.X/2, vp.Y); e.tracer.To = Vector2.new(x + w/2, y + h); e.tracer.Visible = cfg.espTracer
if cfg.espHead then
local hpv = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, cfg.headOffset, 0))
e.head.Color = col; e.head.Visible = hpv.Z > 0; e.head.Position = Vector2.new(hpv.X, hpv.Y)
else e.head.Visible = false end
end
end
if not drawn then hideEsp(e) end
end
end)
if not ok then
local e = espCache[char]
if e then hideEsp(e) end
end
end
end
for char, e in pairs(espCache) do
if not seen[char] then destroyEsp(e); espCache[char] = nil end
end
end
local function updateChams()
local seen = {}
if cfg.chams then
for _, char in ipairs(espChars()) do
local ok = pcall(function()
local pl = resolvePlayer(char)
local ally = pl and pl.Team and LocalPlayer.Team and pl.Team == LocalPlayer.Team
if not ally or cfg.chamsTeam then
seen[char] = true
local hl = chamsCache[char]
if not hl or not hl.Parent then
hl = Instance.new("Highlight")
hl.Parent = chamsFolder
chamsCache[char] = hl
end
hl.Enabled = true
hl.Adornee = char
hl.FillColor = ally and COLORS.ally or COLORS.enemy
hl.OutlineColor = Color3.new(1, 1, 1)
hl.FillTransparency = cfg.chamsFill
hl.OutlineTransparency = 0
hl.DepthMode = cfg.chamsXray and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
end
end)
if not ok then
local hl = chamsCache[char]
if hl then hl.Adornee = nil end
end
end
end
for char, hl in pairs(chamsCache) do
if not seen[char] then pcall(function() hl:Destroy() end); chamsCache[char] = nil end
end
end
local OBJ = {
{ key = "espBomb", label = "Bomb", color = Color3.fromRGB(255, 60, 255),
tags = { "Bomb", "Defuser" }, extra = function() return Workspace:FindFirstChild("Bomb") end },
{ key = "espCam", label = "Camera", color = Color3.fromRGB(190, 90, 255),
tags = { "BulletproofCamera", "StickyCamera", "DefaultCamera" } },
{ key = "espDrone", label = "Drone", color = Color3.fromRGB(90, 170, 255),
tags = { "Drone" } },
}
local function getBox(inst)
if inst:IsA("Model") then
local ok, cf, size = pcall(function() return inst:GetBoundingBox() end)
if ok and size and size.Magnitude > 0 then return cf, size end
local pp = inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
if pp then return pp.CFrame, pp.Size end
elseif inst:IsA("BasePart") then
return inst.CFrame, inst.Size
end
end
local function updateObjects()
if not Drawing then return end
local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local seen = {}
if cfg.espObjects then
for _, cat in ipairs(OBJ) do
if cfg[cat.key] then
local list = {}
for _, tag in ipairs(cat.tags) do
for _, i in ipairs(CollectionService:GetTagged(tag)) do
if i:IsDescendantOf(Workspace) then list[i] = true end
end
end
if cat.extra then local x = cat.extra(); if x then list[x] = true end end
for inst in pairs(list) do
local ok = pcall(function()
local cf, size = getBox(inst)
if cf then
local x, y, w, h = projectBox(cf, size)
if x then
seen[inst] = true
local e = objCache[inst] or makeEsp(); objCache[inst] = e
styleBox(e, x, y, w, h, cat.color, true)
local dist = myRoot and (cf.Position - myRoot.Position).Magnitude or 0
e.name.Text = cat.label; e.name.Color = cat.color; e.name.Position = Vector2.new(x + w/2, y - 16); e.name.Visible = true
e.dist.Text = string.format("%dm", math.floor(dist)); e.dist.Position = Vector2.new(x + w/2, y + h + 2); e.dist.Visible = true
end
end
end)
if not ok then
local e = objCache[inst]
if e then hideEsp(e) end
end
end
end
end
end
for inst, e in pairs(objCache) do
if not seen[inst] then destroyEsp(e); objCache[inst] = nil end
end
end
local Lighting = game:GetService("Lighting")
local worldSaved
local function applyWorld()
if not (cfg.fullbright or cfg.noFog or cfg.noAtmosphere or cfg.timeSet or cfg.brightnessSet) then return end
if not worldSaved then
worldSaved = {
Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
Brightness = Lighting.Brightness, FogEnd = Lighting.FogEnd,
ClockTime = Lighting.ClockTime, GlobalShadows = Lighting.GlobalShadows,
}
end
if cfg.fullbright then
Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1)
Lighting.Brightness = 2; Lighting.GlobalShadows = false
end
if cfg.noFog then Lighting.FogEnd = 1e9; Lighting.FogStart = 1e9 end
if cfg.timeSet then Lighting.ClockTime = cfg.clockTime end
if cfg.brightnessSet then Lighting.Brightness = cfg.brightness end
if cfg.noAtmosphere then local a = Lighting:FindFirstChildOfClass("Atmosphere"); if a then a.Density = 0 end end
end
local function restoreWorld()
if not worldSaved then return end
for k, v in pairs(worldSaved) do pcall(function() Lighting[k] = v end) end
worldSaved = nil
end
local chGui, chParts
local function buildCrosshair()
chGui = Instance.new("ScreenGui")
chGui.Name = "OpCross"; chGui.IgnoreGuiInset = true; chGui.ResetOnSpawn = false
chGui.DisplayOrder = 999
chGui.Parent = (gethui and gethui()) or CoreGui
local function seg()
local f = Instance.new("Frame"); f.BorderSizePixel = 0; f.AnchorPoint = Vector2.new(0.5, 0.5)
f.Visible = false; f.Parent = chGui; return f
end
chParts = { top = seg(), bottom = seg(), left = seg(), right = seg(), dot = seg() }
end
local function updateCrosshair()
if not chParts then return end
if not cfg.crosshair then for _, f in pairs(chParts) do f.Visible = false end return end
local vp = Camera.ViewportSize
local cx, cy = vp.X/2, vp.Y/2
local col = cfg.crossChroma and Color3.fromHSV((tick() % 5)/5, 1, 1) or cfg.crossColor
local t, g, len = cfg.crossThick, cfg.crossGap, cfg.crossSize
for _, f in pairs(chParts) do f.BackgroundColor3 = col; f.Visible = true end
chParts.top.Size = UDim2.fromOffset(t, len); chParts.top.Position = UDim2.fromOffset(cx, cy - g - len/2)
chParts.bottom.Size = UDim2.fromOffset(t, len); chParts.bottom.Position = UDim2.fromOffset(cx, cy + g + len/2)
chParts.left.Size = UDim2.fromOffset(len, t); chParts.left.Position = UDim2.fromOffset(cx - g - len/2, cy)
chParts.right.Size = UDim2.fromOffset(len, t); chParts.right.Position = UDim2.fromOffset(cx + g + len/2, cy)
chParts.dot.Size = UDim2.fromOffset(t + 2, t + 2); chParts.dot.Position = UDim2.fromOffset(cx, cy)
chParts.dot.Visible = cfg.crossDot
end
buildCrosshair()
local function charBits()
local c = LocalPlayer.Character
if not c then return end
return c, c:FindFirstChildOfClass("Humanoid"), c:FindFirstChild("HumanoidRootPart")
end
local VirtualUser = game:GetService("VirtualUser")
track(LocalPlayer.Idled:Connect(function()
if cfg.antiAfk then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end
end))
track(RunService.RenderStepped:Connect(function()
pcall(updateEsp)
pcall(updateChams)
pcall(updateObjects)
pcall(applyWorld)
pcall(updateCrosshair)
if cfg.fovMod then Camera.FieldOfView = cfg.camFov end
local _, _, hrp = charBits()
if hrp and cfg.spinbot then
hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(cfg.spinSpeed), 0)
end
end))
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local function rejoin() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end) end
local function serverHop()
local ok, res = pcall(function()
return HttpService:JSONDecode(game:HttpGet(
"https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
end)
if ok and res and res.data then
for _, s in ipairs(res.data) do
if s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer) end)
return
end
end
end
pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end
F.cleanup = function()
for _, c in ipairs(F.conns or {}) do pcall(function() c:Disconnect() end) end
F.conns = {}
pcall(RunService.UnbindFromRenderStep, RunService, "OpOneAim")
if F.bus then
for _, k in ipairs({ "silent","noRecoil","noSpread","infAmmo" }) do
F.bus:SetAttribute(k, false)
end
end
if fovCircle then pcall(function() fovCircle:Remove() end) end
for _, e in pairs(espCache) do destroyEsp(e) end
for _, e in pairs(objCache) do destroyEsp(e) end
for _, hl in pairs(chamsCache) do pcall(function() hl:Destroy() end) end
pcall(function() chamsFolder:ClearAllChildren() end)
if chGui then pcall(function() chGui:Destroy() end) end
pcall(restoreWorld)
end
local stored_fonts = {}
for _, v in ipairs(Enum.Font:GetEnumItems()) do table.insert(stored_fonts, v.Name) end
local gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 150, MaxHeight = 680, InitialHeight = 470,
MinWidth = 350, MaxWidth = 800, InitialWidth = 520
}
getgenv().gui_config = gui_config
local config = gui_config
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(config, gethui())
library:SetWindowName("Kali Hub | Operation One")
local tabs = {
main = window:CreateTab("Main"),
visuals = window:CreateTab("Visuals"),
config = window:CreateTab("Config"),
}
local sec = {
Silent = tabs.main:CreateSection("Silent Aim"),
Aim = tabs.main:CreateSection("Aimbot", "right"),
Target = tabs.main:CreateSection("Advanced Targeting"),
Mods = tabs.main:CreateSection("Weapon Mods", "right"),
Set = tabs.config:CreateSection("Settings"),
}
sec.Silent:CreateToggle("Silent Aim", cfg.silent, function(v) cfg.silent = v; if v then ensureActor() end; pushCfg() end)
sec.Silent:CreateSlider("Aim / Silent FOV", 20, 500, cfg.fov, true, function(v) cfg.fov = v end)
sec.Silent:CreateToggle("Show FOV Circle", cfg.fovCircle, function(v) cfg.fovCircle = v end)
sec.Aim:CreateToggle("Aimbot (hard lock)", cfg.aimbot, function(v) cfg.aimbot = v; if v then cfg.legit = false end end)
sec.Aim:CreateToggle("Aim Legit (smooth)", cfg.legit, function(v) cfg.legit = v; if v then cfg.aimbot = false end end)
sec.Aim:CreateSlider("Smoothness", 1, 25, cfg.smoothness, true, function(v) cfg.smoothness = v end)
sec.Aim:CreateSlider("Max Turn Rate (deg/s)", 40, 900, cfg.turnRate, true, function(v) cfg.turnRate = v end)
sec.Aim:CreateSlider("Reaction Delay (ms)", 0, 400, cfg.reactionMs, true, function(v) cfg.reactionMs = v end)
sec.Aim:CreateToggle("Only While Aiming", cfg.adsOnly, function(v) cfg.adsOnly = v end)
sec.Aim:CreateToggle("Only While Firing", cfg.fireOnly, function(v) cfg.fireOnly = v end)
sec.Target:CreateDropdown("Target Part", { "Head", "Torso" }, function(v) cfg.targetPart = v; pushCfg() end, cfg.targetPart, false)
sec.Target:CreateDropdown("Priority", { "Crosshair", "Distance", "Health" }, function(v) cfg.priority = v end, cfg.priority, false)
sec.Target:CreateToggle("Team Check", cfg.teamCheck, function(v) cfg.teamCheck = v end)
sec.Target:CreateToggle("Wall Check", cfg.wallCheck, function(v) cfg.wallCheck = v end)
sec.Target:CreateToggle("Sticky Target", cfg.sticky, function(v) cfg.sticky = v end)
sec.Target:CreateSlider("Max Distance", 100, 2000, cfg.maxDist, true, function(v) cfg.maxDist = v end)
sec.Target:CreateSlider("Prediction", 0, 30, math.floor(cfg.prediction*100), true, function(v) cfg.prediction = v/100 end)
sec.Mods:CreateToggle("No Recoil", cfg.noRecoil, function(v) cfg.noRecoil = v; if v then ensureActor() end; pushCfg() end)
sec.Mods:CreateToggle("No Spread", cfg.noSpread, function(v) cfg.noSpread = v; if v then ensureActor() end; pushCfg() end)
sec.Mods:CreateToggle("Infinite Ammo (risky)", cfg.infAmmo, function(v) cfg.infAmmo = v; if v then ensureActor() end; pushCfg() end)
local vEsp = tabs.visuals:CreateSection("Player ESP")
local vEspX = tabs.visuals:CreateSection("ESP Elements", "right")
local vObj = tabs.visuals:CreateSection("Object ESP")
local vCham = tabs.visuals:CreateSection("Chams", "right")
local vCross= tabs.visuals:CreateSection("Crosshair")
local wLight= tabs.visuals:CreateSection("World Visuals", "right")
local wCam = tabs.visuals:CreateSection("Camera")
vEsp:CreateToggle("ESP", cfg.esp, function(v) cfg.esp = v end)
vEsp:CreateToggle("Show Teammates", cfg.espTeam, function(v) cfg.espTeam = v end)
vEsp:CreateSlider("Max Distance", 100, 3000, cfg.espMaxDist, true, function(v) cfg.espMaxDist = v end)
vEspX:CreateToggle("Box", cfg.espBox, function(v) cfg.espBox = v end)
vEspX:CreateDropdown("Box Style", { "Normal", "Corner", "Bracket" }, function(v) cfg.boxStyle = v end, cfg.boxStyle, false)
vEspX:CreateToggle("Box Outline", cfg.boxOutline, function(v) cfg.boxOutline = v end)
vEspX:CreateToggle("Name", cfg.espName, function(v) cfg.espName = v end)
vEspX:CreateToggle("Distance", cfg.espDist, function(v) cfg.espDist = v end)
vEspX:CreateToggle("Health Bar", cfg.espHealth, function(v) cfg.espHealth = v end)
vEspX:CreateToggle("Tracer", cfg.espTracer, function(v) cfg.espTracer = v end)
vEspX:CreateToggle("Head Dot", cfg.espHead, function(v) cfg.espHead = v end)
vObj:CreateToggle("Object ESP", cfg.espObjects, function(v) cfg.espObjects = v end)
vObj:CreateToggle("Bomb / Defuser", cfg.espBomb, function(v) cfg.espBomb = v end)
vObj:CreateToggle("Cameras", cfg.espCam, function(v) cfg.espCam = v end)
vObj:CreateToggle("Drones", cfg.espDrone, function(v) cfg.espDrone = v end)
vCham:CreateToggle("Chams", cfg.chams, function(v) cfg.chams = v end)
vCham:CreateToggle("Show Teammates", cfg.chamsTeam, function(v) cfg.chamsTeam = v end)
vCham:CreateToggle("X-Ray (through walls)", cfg.chamsXray, function(v) cfg.chamsXray = v end)
vCham:CreateSlider("Fill Transparency", 0, 100, math.floor(cfg.chamsFill*100), true, function(v) cfg.chamsFill = v/100 end)
vCross:CreateToggle("Custom Crosshair", cfg.crosshair, function(v) cfg.crosshair = v end)
vCross:CreateSlider("Size", 0, 40, cfg.crossSize, true, function(v) cfg.crossSize = v end)
vCross:CreateSlider("Gap", 0, 30, cfg.crossGap, true, function(v) cfg.crossGap = v end)
vCross:CreateSlider("Thickness", 1, 8, cfg.crossThick, true, function(v) cfg.crossThick = v end)
vCross:CreateToggle("Dot", cfg.crossDot, function(v) cfg.crossDot = v end)
vCross:CreateToggle("Chroma", cfg.crossChroma, function(v) cfg.crossChroma = v end)
wLight:CreateToggle("Fullbright", cfg.fullbright, function(v) cfg.fullbright = v; if not v then restoreWorld() end end)
wLight:CreateToggle("No Fog", cfg.noFog, function(v) cfg.noFog = v; if not v then restoreWorld() end end)
wLight:CreateToggle("No Atmosphere", cfg.noAtmosphere, function(v) cfg.noAtmosphere = v end)
wLight:CreateToggle("Set Time", cfg.timeSet, function(v) cfg.timeSet = v; if not v then restoreWorld() end end)
wLight:CreateSlider("Time", 0, 24, cfg.clockTime, true, function(v) cfg.clockTime = v end)
wLight:CreateToggle("Set Brightness", cfg.brightnessSet, function(v) cfg.brightnessSet = v; if not v then restoreWorld() end end)
wLight:CreateSlider("Brightness", 0, 10, cfg.brightness, true, function(v) cfg.brightness = v end)
wCam:CreateToggle("Custom FOV", cfg.fovMod, function(v) cfg.fovMod = v end)
wCam:CreateSlider("Field of View", 40, 120, cfg.camFov, true, function(v) cfg.camFov = v end)
local mMisc = tabs.main:CreateSection("Misc")
mMisc:CreateToggle("Spinbot", cfg.spinbot, function(v) cfg.spinbot = v end)
mMisc:CreateSlider("Spin Speed", 5, 60, cfg.spinSpeed, true, function(v) cfg.spinSpeed = v end)
mMisc:CreateToggle("Anti-AFK", cfg.antiAfk, function(v) cfg.antiAfk = v end)
local pSrv = tabs.main:CreateSection("Server")
pSrv:CreateButton("Rejoin", rejoin)
pSrv:CreateButton("Server Hop", serverHop)
pSrv:CreateButton("Copy Job ID", function() if setclipboard then setclipboard(game.JobId) end end)
pSrv:CreateButton("Unload Script", function() pcall(F.cleanup); pcall(function() window:Destroy() end) end)
window:Notify("Kali Hub", actorOk and "Ready. Game code is only patched when you enable Silent Aim or Weapon Mods." or "No actor hooks (executor lacks run_on_actor).", 8)
local watermark = library:Hud()
track(RunService.RenderStepped:Connect(function()
watermark:SetText("kalihub.xyz/discord | Operation One | " .. os.date("%H:%M:%S"))
end))
sec.Set:CreateLabel("Close Menu Key (PC): " .. tostring(config.Keybind):gsub("Enum.KeyCode.", ""))
sec.Set:CreateDropdown("Change Font", stored_fonts, function(v) window:SetFont(v) end, "", false)
local ok_cm, config_manager = pcall(function() return loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))() end)
if ok_cm and config_manager then
config_manager:SetLibrary(library)
config_manager:SetWindow(window)
config_manager:SetFolder("Kali Hub")
config_manager:BuildConfigSection(tabs.config)
config_manager:LoadAutoloadConfig()
end
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
window:SetTileScale(0.5)
window:SetBackgroundColor(Color3.fromRGB(255, 255, 255))
window:SetBackgroundTransparency(0)
