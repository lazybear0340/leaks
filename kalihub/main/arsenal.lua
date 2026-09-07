--this shit was unobfuscated


if getgenv().KaliArsenal and getgenv().KaliArsenal.Unload then
pcall(getgenv().KaliArsenal.Unload)
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local Camera = Workspace.CurrentCamera
local State = {
Connections = {},
Drawings = {},
Highlights = {},
OriginalWeaponStats = {},
Guis = {},
}
getgenv().KaliArsenal = State
local Config = {
AimbotEnabled = false,
AimbotKey = "Right Mouse",
AimbotPart = "Head",
AimbotSmoothing = 0,
AimbotTeamCheck = true,
AimbotWallCheck = true,
AimbotHitChance = 100,
SilentEnabled = false,
SilentPart = "Head",
SilentFOV = 120,
SilentTeamCheck = true,
SilentWallCheck = true,
SilentHitChance = 100,
SilentUpvalues = 35,
TriggerEnabled = false,
TriggerDelay = 0.05,
TriggerTeamCheck = true,
RageEnabled = false,
RageMode = "Silent",
RagePriority = "Crosshair",
RagePart = "Head",
RageMultipoint = true,
RageTeamCheck = true,
RageWallCheck = false,
RageAutoFire = true,
RageTargetLock = true,
RageMaxDistance = 2000,
RageLead = 0,
RageHitChance = 100,
FOVVisible = false,
FOVRadius = 120,
FOVFilled = false,
FOVColor = Color3.fromRGB(255, 255, 255),
ESPEnabled = false,
ESPBox = true,
ESPName = true,
ESPHealth = true,
ESPDistance = false,
ESPTracer = false,
ESPChams = false,
ESPTeamCheck = true,
ESPMaxDistance = 2000,
ESPTracerOrigin = "Bottom",
ESPSnapline = false,
ESPEnemyColor = Color3.fromRGB(255, 65, 65),
ESPAllyColor = Color3.fromRGB(65, 160, 255),
ESPPickups = false,
CustomFOVEnabled = false,
CustomFOVValue = 90,
CrosshairEnabled = false,
CrosshairSize = 10,
CrosshairGap = 4,
CrosshairThickness = 2,
CrosshairDot = false,
CrosshairColor = Color3.fromRGB(0, 255, 120),
Rainbow = false,
RainbowSpeed = 0.5,
BulletTracers = false,
BulletTracerLife = 0.25,
BulletTracerColor = Color3.fromRGB(255, 230, 90),
RapidFire = false,
RapidFireRate = 0.05,
InstantReload = false,
UnlimitedRange = false,
InstantEquip = false,
HitboxEnabled = false,
HitboxTarget = "Head",
HitboxSize = 5,
HitboxTeamCheck = true,
InfiniteJump = false,
AntiAFK = true,
}
local HIT_PARTS = {
"Head", "HeadHB", "UpperTorso", "LowerTorso", "HumanoidRootPart", "Hitbox",
"LeftUpperArm", "LeftLowerArm", "LeftHand",
"RightUpperArm", "RightLowerArm", "RightHand",
"LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
"RightUpperLeg", "RightLowerLeg", "RightFoot",
}
local function connect(signal, fn)
local conn = signal:Connect(fn)
table.insert(State.Connections, conn)
return conn
end
local function getHealth(player)
local nrpbs = player:FindFirstChild("NRPBS")
if not nrpbs then return 0, 100 end
local health = nrpbs:FindFirstChild("Health")
local maxHealth = nrpbs:FindFirstChild("MaxHealth")
return health and health.Value or 0, (maxHealth and maxHealth.Value ~= 0) and maxHealth.Value or 100
end
local function isAlive(player)
local character = player.Character
if not character or not character:FindFirstChild("Head") then return false end
return getHealth(player) > 0
end
local function isEnemy(player, teamCheck)
if not teamCheck then return true end
if not player.Team or not LocalPlayer.Team then return true end
return player.Team ~= LocalPlayer.Team
end
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
local function refreshRayFilter()
local ignore = { Camera }
if LocalPlayer.Character then table.insert(ignore, LocalPlayer.Character) end
local rayIgnore = Workspace:FindFirstChild("Ray_Ignore")
if rayIgnore then table.insert(ignore, rayIgnore) end
local debris = Workspace:FindFirstChild("Debris")
if debris then table.insert(ignore, debris) end
rayParams.FilterDescendantsInstances = ignore
end
refreshRayFilter()
local function isVisible(character, part)
local origin = Camera.CFrame.Position
local delta = part.Position - origin
local result = Workspace:Raycast(origin, delta, rayParams)
return result == nil or result.Instance:IsDescendantOf(character)
end
local function resolvePart(character, wanted)
return character:FindFirstChild(wanted)
or character:FindFirstChild("Head")
or character:FindFirstChild("HumanoidRootPart")
end
local function getClosestToCursor(partName, fovRadius, teamCheck, wallCheck)
local cursor = UserInputService:GetMouseLocation()
local best, bestDistance = nil, fovRadius
for _, player in Players:GetPlayers() do
if player ~= LocalPlayer and isAlive(player) and isEnemy(player, teamCheck) then
local character = player.Character
local part = resolvePart(character, partName)
if part then
local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
if onScreen then
local distance = (Vector2.new(screenPos.X, screenPos.Y) - cursor).Magnitude
if distance < bestDistance and (not wallCheck or isVisible(character, part)) then
bestDistance = distance
best = part
end
end
end
end
end
return best
end
local function pushSilentConfig()
PlayerScripts:SetAttribute("SA_Enabled", Config.SilentEnabled)
PlayerScripts:SetAttribute("SA_Part", Config.SilentPart)
PlayerScripts:SetAttribute("SA_FOV", Config.SilentFOV)
PlayerScripts:SetAttribute("SA_TeamCheck", Config.SilentTeamCheck)
PlayerScripts:SetAttribute("SA_WallCheck", Config.SilentWallCheck)
PlayerScripts:SetAttribute("SA_Chance", Config.SilentHitChance)
PlayerScripts:SetAttribute("SA_Upvalues", Config.SilentUpvalues)
PlayerScripts:SetAttribute("SA_Rage", Config.RageEnabled and Config.RageMode == "Silent")
PlayerScripts:SetAttribute("SA_RagePriority", Config.RagePriority)
PlayerScripts:SetAttribute("SA_RagePart", Config.RagePart)
PlayerScripts:SetAttribute("SA_RageMulti", Config.RageMultipoint)
PlayerScripts:SetAttribute("SA_RageTeamCheck", Config.RageTeamCheck)
PlayerScripts:SetAttribute("SA_RageWallCheck", Config.RageWallCheck)
PlayerScripts:SetAttribute("SA_RageMax", Config.RageMaxDistance)
PlayerScripts:SetAttribute("SA_RageLead", Config.RageLead)
PlayerScripts:SetAttribute("SA_RageChance", Config.RageHitChance)
PlayerScripts:SetAttribute("SA_RageLock", Config.RageTargetLock)
end
local SILENT_SOURCE = [[
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

    local function cfg(name, default)
        local value = PlayerScripts:GetAttribute(name)
        if value == nil then return default end
        return value
    end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local function getTarget(camera)
        local wantedPart = cfg("SA_Part", "Head")
        local fov = cfg("SA_FOV", 120)
        local teamCheck = cfg("SA_TeamCheck", true)
        local wallCheck = cfg("SA_WallCheck", true)
        local cursor = UserInputService:GetMouseLocation()
        local localTeam = LocalPlayer.Team

        if wallCheck then
            local ignore = { camera }
            if LocalPlayer.Character then table.insert(ignore, LocalPlayer.Character) end
            local rayIgnore = workspace:FindFirstChild("Ray_Ignore")
            if rayIgnore then table.insert(ignore, rayIgnore) end
            local debris = workspace:FindFirstChild("Debris")
            if debris then table.insert(ignore, debris) end
            rayParams.FilterDescendantsInstances = ignore
        end

        local best, bestDistance = nil, fov

        for _, player in Players:GetPlayers() do
            if player == LocalPlayer then continue end
            if teamCheck and localTeam and player.Team == localTeam then continue end

            local character = player.Character
            if not character then continue end

            local part = character:FindFirstChild(wantedPart) or character:FindFirstChild("Head")
            if not part then continue end

            local nrpbs = player:FindFirstChild("NRPBS")
            if not nrpbs then continue end
            local health = nrpbs:FindFirstChild("Health")
            if not health or health.Value <= 0 then continue end

            local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end

            local distance = (Vector2.new(screenPos.X, screenPos.Y) - cursor).Magnitude
            if distance >= bestDistance then continue end

            if wallCheck then
                local origin = camera.CFrame.Position
                local result = workspace:Raycast(origin, part.Position - origin, rayParams)
                if result and not result.Instance:IsDescendantOf(character) then continue end
            end

            bestDistance = distance
            best = part
        end

        return best
    end

    -- Ragebot target selection. No FOV, walks several hit parts per enemy and
    -- keeps the pick until it dies so a burst lands on one player.
    local RAGE_POINTS = { "HeadHB", "Head", "Hitbox", "UpperTorso", "HumanoidRootPart" }
    local rageLocked = nil

    local function rageFilter(camera)
        local ignore = { camera }
        if LocalPlayer.Character then table.insert(ignore, LocalPlayer.Character) end
        local rayIgnore = workspace:FindFirstChild("Ray_Ignore")
        if rayIgnore then table.insert(ignore, rayIgnore) end
        local debris = workspace:FindFirstChild("Debris")
        if debris then table.insert(ignore, debris) end
        rayParams.FilterDescendantsInstances = ignore
    end

    local function visible(camera, character, part)
        local origin = camera.CFrame.Position
        local result = workspace:Raycast(origin, part.Position - origin, rayParams)
        return result == nil or result.Instance:IsDescendantOf(character)
    end

    local function healthOf(player)
        local nrpbs = player:FindFirstChild("NRPBS")
        local value = nrpbs and nrpbs:FindFirstChild("Health")
        return value and value.Value or 0
    end

    local function ragePoint(camera, character, wallCheck)
        if not cfg("SA_RageMulti", true) then
            local part = character:FindFirstChild(cfg("SA_RagePart", "Head")) or character:FindFirstChild("Head")
            if part and (not wallCheck or visible(camera, character, part)) then return part end
            return nil
        end
        for _, name in RAGE_POINTS do
            local part = character:FindFirstChild(name)
            if part and (not wallCheck or visible(camera, character, part)) then return part end
        end
        return nil
    end

    local function rageCandidate(camera, player, wallCheck, maxDistance, teamCheck, localTeam)
        if player == LocalPlayer then return nil end
        if teamCheck and localTeam and player.Team == localTeam then return nil end
        local character = player.Character
        if not character or healthOf(player) <= 0 then return nil end
        local anchor = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
        if not anchor then return nil end
        if (anchor.Position - camera.CFrame.Position).Magnitude > maxDistance then return nil end
        return ragePoint(camera, character, wallCheck)
    end

    local function getRageTarget(camera)
        local wallCheck = cfg("SA_RageWallCheck", false)
        local maxDistance = cfg("SA_RageMax", 2000)
        local teamCheck = cfg("SA_RageTeamCheck", true)
        local localTeam = LocalPlayer.Team
        rageFilter(camera)

        if cfg("SA_RageLock", true) and rageLocked and rageLocked.Parent then
            local part = rageCandidate(camera, rageLocked, wallCheck, maxDistance, teamCheck, localTeam)
            if part then return part end
            rageLocked = nil
        end

        local priority = cfg("SA_RagePriority", "Crosshair")
        local cursor = UserInputService:GetMouseLocation()
        local best, bestPart, bestScore

        for _, player in Players:GetPlayers() do
            local part = rageCandidate(camera, player, wallCheck, maxDistance, teamCheck, localTeam)
            if part then
                local score
                if priority == "Distance" then
                    score = (part.Position - camera.CFrame.Position).Magnitude
                elseif priority == "Health" then
                    score = healthOf(player)
                else
                    local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                    -- Silent aim rewrites the whole camera CFrame, so a target behind the
                    -- player is still shootable. Rank it after everything on screen
                    -- instead of dropping it.
                    score = onScreen
                        and (Vector2.new(screenPos.X, screenPos.Y) - cursor).Magnitude
                        or camera.ViewportSize.Magnitude + (part.Position - camera.CFrame.Position).Magnitude
                end
                if score and (not bestScore or score < bestScore) then
                    best, bestPart, bestScore = player, part, score
                end
            end
        end

        rageLocked = best
        return bestPart
    end

    local function ragePosition(part)
        local lead = cfg("SA_RageLead", 0)
        if lead <= 0 then return part.Position end
        return part.Position + part.AssemblyLinearVelocity * (lead / 1000)
    end

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
        if index == "CoordinateFrame" and self == workspace.CurrentCamera
            and (cfg("SA_Enabled", false) or cfg("SA_Rage", false))
        then
            local source = debug.info(3, "s")
            local name = debug.info(3, "n")

            if source and string.find(source, "First") and name ~= "RotCamera" then
                local info = debug.getinfo(3)

                if info and info.nups == cfg("SA_Upvalues", 35) then
                    local camera = workspace.CurrentCamera
                    if cfg("SA_Rage", false) then
                        if math.random(1, 100) <= cfg("SA_RageChance", 100) then
                            local part = getRageTarget(camera)
                            if part then
                                return CFrame.new(oldIndex(camera, "CFrame").Position, ragePosition(part))
                            end
                        end
                    elseif math.random(1, 100) <= cfg("SA_Chance", 100) then
                        local part = getTarget(camera)
                        if part then
                            return CFrame.new(oldIndex(camera, "CFrame").Position, part.Position)
                        end
                    end
                end
            end
        end

        return oldIndex(self, index)
    end))

    PlayerScripts:SetAttribute("SA_Hooked", 4)
]]
local silentSupported = (getactors ~= nil and run_on_actor ~= nil)
local SILENT_VERSION = 4
local function installSilentAim()
if not silentSupported then return false, "Executor missing getactors/run_on_actor" end
if PlayerScripts:GetAttribute("SA_Hooked") == SILENT_VERSION then return true end
local actors = getactors()
local actor = actors and actors[1]
if not actor then return false, "No actor found (rejoin and run again)" end
pushSilentConfig()
local ok, err = pcall(run_on_actor, actor, SILENT_SOURCE)
if not ok then return false, tostring(err) end
return true
end
local function newDrawing(class, props)
local drawing = Drawing.new(class)
for key, value in props do
drawing[key] = value
end
table.insert(State.Drawings, drawing)
return drawing
end
local rainbowColor = Color3.new(1, 1, 1)
local function tint(color)
return Config.Rainbow and rainbowColor or color
end
local espCache = {}
local function createESP(player)
local set = {
box = newDrawing("Square", { Thickness = 1, Filled = false, Transparency = 1, Visible = false }),
boxOutline = newDrawing("Square", { Thickness = 3, Filled = false, Transparency = 1, Color = Color3.new(0, 0, 0), Visible = false }),
name = newDrawing("Text", { Size = 13, Center = true, Outline = true, Visible = false }),
distance = newDrawing("Text", { Size = 12, Center = true, Outline = true, Color = Color3.fromRGB(200, 200, 200), Visible = false }),
healthBar = newDrawing("Line", { Thickness = 3, Transparency = 1, Visible = false }),
healthBack = newDrawing("Line", { Thickness = 3, Transparency = 1, Color = Color3.new(0, 0, 0), Visible = false }),
tracer = newDrawing("Line", { Thickness = 1, Transparency = 1, Visible = false }),
snapline = newDrawing("Line", { Thickness = 1, Transparency = 1, Visible = false }),
}
espCache[player] = set
return set
end
local function hideESP(set)
for _, drawing in set do
drawing.Visible = false
end
end
local function removeESP(player)
local set = espCache[player]
if set then
for _, drawing in set do
pcall(function() drawing:Remove() end)
end
espCache[player] = nil
end
local highlight = State.Highlights[player]
if highlight then
highlight:Destroy()
State.Highlights[player] = nil
end
end
local function updateChams(player, character, color)
local highlight = State.Highlights[player]
if not Config.ESPEnabled or not Config.ESPChams or not character then
if highlight then highlight.Enabled = false end
return
end
if not highlight then
highlight = Instance.new("Highlight")
highlight.FillTransparency = 0.55
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Parent = PlayerGui
State.Highlights[player] = highlight
end
highlight.Adornee = character
highlight.FillColor = color
highlight.OutlineColor = color
highlight.Enabled = true
end
local function getBoxCorners(character)
local cframe, size = character:GetBoundingBox()
local minX, minY = math.huge, math.huge
local maxX, maxY = -math.huge, -math.huge
local anyOnScreen = false
for x = -1, 1, 2 do
for y = -1, 1, 2 do
for z = -1, 1, 2 do
local corner = cframe * CFrame.new(size.X * 0.5 * x, size.Y * 0.5 * y, size.Z * 0.5 * z)
local screenPos, onScreen = Camera:WorldToViewportPoint(corner.Position)
if onScreen then anyOnScreen = true end
minX = math.min(minX, screenPos.X)
maxX = math.max(maxX, screenPos.X)
minY = math.min(minY, screenPos.Y)
maxY = math.max(maxY, screenPos.Y)
end
end
end
if not anyOnScreen then return nil end
return minX, minY, maxX, maxY
end
local function updateESP()
for _, player in Players:GetPlayers() do
if player ~= LocalPlayer then
local set = espCache[player] or createESP(player)
local character = player.Character
if not Config.ESPEnabled or not character or not isAlive(player)
or not isEnemy(player, Config.ESPTeamCheck) then
hideESP(set)
updateChams(player, nil)
else
local root = (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")) :: any
local distance = root and (Camera.CFrame.Position - root.Position).Magnitude or math.huge
local corners = root and distance <= Config.ESPMaxDistance and { getBoxCorners(character) } or nil
if not corners or corners[1] == nil then
hideESP(set)
updateChams(player, nil)
else
local minX, minY, maxX, maxY = corners[1], corners[2], corners[3], corners[4]
local width, height = maxX - minX, maxY - minY
local color = tint(isEnemy(player, true) and Config.ESPEnemyColor or Config.ESPAllyColor)
set.box.Visible = Config.ESPBox
set.boxOutline.Visible = Config.ESPBox
if Config.ESPBox then
set.box.Position = Vector2.new(minX, minY)
set.box.Size = Vector2.new(width, height)
set.box.Color = color
set.boxOutline.Position = set.box.Position
set.boxOutline.Size = set.box.Size
end
set.name.Visible = Config.ESPName
if Config.ESPName then
set.name.Text = player.DisplayName
set.name.Position = Vector2.new(minX + width * 0.5, minY - 16)
set.name.Color = color
end
set.distance.Visible = Config.ESPDistance
if Config.ESPDistance then
set.distance.Text = string.format("%dm", distance)
set.distance.Position = Vector2.new(minX + width * 0.5, maxY + 2)
end
set.healthBar.Visible = Config.ESPHealth
set.healthBack.Visible = Config.ESPHealth
if Config.ESPHealth then
local health, maxHealth = getHealth(player)
local ratio = math.clamp(health / maxHealth, 0, 1)
local barX = minX - 5
set.healthBack.From = Vector2.new(barX, minY)
set.healthBack.To = Vector2.new(barX, maxY)
set.healthBar.From = Vector2.new(barX, maxY - height * ratio)
set.healthBar.To = Vector2.new(barX, maxY)
set.healthBar.Color = Color3.fromRGB(255 - 255 * ratio, 255 * ratio, 60)
end
set.tracer.Visible = Config.ESPTracer
if Config.ESPTracer then
local origin
if Config.ESPTracerOrigin == "Center" then
origin = Camera.ViewportSize * 0.5
elseif Config.ESPTracerOrigin == "Mouse" then
origin = UserInputService:GetMouseLocation()
else
origin = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y)
end
set.tracer.From = origin
set.tracer.To = Vector2.new(minX + width * 0.5, maxY)
set.tracer.Color = color
end
set.snapline.Visible = Config.ESPSnapline
if Config.ESPSnapline then
set.snapline.From = Vector2.new(Camera.ViewportSize.X * 0.5, 0)
set.snapline.To = Vector2.new(minX + width * 0.5, minY)
set.snapline.Color = color
end
updateChams(player, character, color)
end
end
end
end
end
local pickupCache = {}
local function updatePickupESP()
for instance, drawing in pickupCache do
if not instance.Parent then
drawing:Remove()
pickupCache[instance] = nil
else
drawing.Visible = false
end
end
if not Config.ESPEnabled or not Config.ESPPickups then return end
local debris = Workspace:FindFirstChild("Debris")
if not debris then return end
for _, instance in debris:GetChildren() do
local isHealth = instance.Name == "DeadHP"
if isHealth or instance.Name == "DeadAmmo" then
local drawing = pickupCache[instance]
if not drawing then
drawing = newDrawing("Text", { Size = 12, Center = true, Outline = true })
drawing.Text = isHealth and "Health" or "Ammo"
drawing.Color = isHealth and Color3.fromRGB(90, 255, 120) or Color3.fromRGB(255, 205, 90)
pickupCache[instance] = drawing
end
local screenPos, onScreen = Camera:WorldToViewportPoint(instance.Position)
if onScreen then
drawing.Position = Vector2.new(screenPos.X, screenPos.Y)
drawing.Visible = true
end
end
end
end
local fovCircle = newDrawing("Circle", {
Thickness = 1.5,
NumSides = 90,
Filled = false,
Transparency = 1,
Color = Config.FOVColor,
Visible = false,
})
local crosshairLines = {}
for _ = 1, 4 do
table.insert(crosshairLines, newDrawing("Line", { Thickness = 2, Transparency = 1, Visible = false }))
end
local crosshairDot = newDrawing("Circle", {
NumSides = 12,
Filled = true,
Transparency = 1,
Radius = 1.5,
Visible = false,
})
local function updateCrosshair()
local color = tint(Config.CrosshairColor)
local center = Camera.ViewportSize * 0.5
local gap, size = Config.CrosshairGap, Config.CrosshairSize
local offsets = {
{ Vector2.new(0, -gap), Vector2.new(0, -gap - size) },
{ Vector2.new(0, gap), Vector2.new(0, gap + size) },
{ Vector2.new(-gap, 0), Vector2.new(-gap - size, 0) },
{ Vector2.new(gap, 0), Vector2.new(gap + size, 0) },
}
for index, line in crosshairLines do
line.Visible = Config.CrosshairEnabled
if Config.CrosshairEnabled then
line.From = center + offsets[index][1]
line.To = center + offsets[index][2]
line.Thickness = Config.CrosshairThickness
line.Color = color
end
end
crosshairDot.Visible = Config.CrosshairEnabled and Config.CrosshairDot
if crosshairDot.Visible then
crosshairDot.Position = center
crosshairDot.Radius = Config.CrosshairThickness
crosshairDot.Color = color
end
end
local TRACER_POOL_SIZE = 24
local tracerPool = {}
local tracerShots = {}
local tracerCursor = 0
local lastTracerShot = 0
for _ = 1, TRACER_POOL_SIZE do
table.insert(tracerPool, newDrawing("Line", { Thickness = 1.5, Visible = false }))
end
local function equippedWeapon()
local nrpbs = LocalPlayer:FindFirstChild("NRPBS")
local equipped = nrpbs and nrpbs:FindFirstChild("EquippedTool")
return equipped and ReplicatedStorage.Weapons:FindFirstChild(equipped.Value) or nil
end
local function equippedFireRate()
local weapon = equippedWeapon()
local fireRate = weapon and weapon:FindFirstChild("FireRate")
return fireRate and fireRate.Value or 0.12
end
local function spawnTracer()
local character = LocalPlayer.Character
if not character then return end
local origin = Camera.CFrame.Position
local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("Head")
local ray = Workspace:Raycast(origin, Camera.CFrame.LookVector * 2000, rayParams)
tracerCursor = tracerCursor % TRACER_POOL_SIZE + 1
tracerShots[tracerCursor] = {
from = hand and hand.Position or origin,
to = ray and ray.Position or (origin + Camera.CFrame.LookVector * 2000),
born = os.clock(),
}
end
local function updateBulletTracers()
if Config.BulletTracers
and LocalPlayer.Character
and isrbxactive and isrbxactive()
and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
and os.clock() - lastTracerShot >= equippedFireRate()
then
lastTracerShot = os.clock()
spawnTracer()
end
local color = tint(Config.BulletTracerColor)
local now = os.clock()
for index, line in tracerPool do
local shot = tracerShots[index]
local age = shot and now - shot.born or math.huge
if not Config.BulletTracers or age >= Config.BulletTracerLife then
line.Visible = false
tracerShots[index] = nil
else
local fromPos, fromVisible = Camera:WorldToViewportPoint(shot.from)
local toPos, toVisible = Camera:WorldToViewportPoint(shot.to)
if fromVisible or toVisible then
line.From = Vector2.new(fromPos.X, fromPos.Y)
line.To = Vector2.new(toPos.X, toPos.Y)
line.Color = color
line.Transparency = 1 - age / Config.BulletTracerLife
line.Visible = true
else
line.Visible = false
end
end
end
end
local aimbotHeld = false
local AIM_KEYS = {
["Right Mouse"] = Enum.UserInputType.MouseButton2,
["Left Mouse"] = Enum.UserInputType.MouseButton1,
["Q"] = Enum.KeyCode.Q,
["E"] = Enum.KeyCode.E,
["C"] = Enum.KeyCode.C,
}
local function matchesAimKey(input)
local bind = AIM_KEYS[Config.AimbotKey]
if not bind then return false end
return input.UserInputType == bind or input.KeyCode == bind
end
connect(UserInputService.InputBegan, function(input, processed)
if processed then return end
if matchesAimKey(input) then aimbotHeld = true end
end)
connect(UserInputService.InputEnded, function(input)
if matchesAimKey(input) then aimbotHeld = false end
end)
local function runAimbot()
if not Config.AimbotEnabled then return end
if Config.AimbotKey ~= "Always" and not aimbotHeld then return end
if math.random(1, 100) > Config.AimbotHitChance then return end
local part = getClosestToCursor(Config.AimbotPart, Config.FOVRadius,
Config.AimbotTeamCheck, Config.AimbotWallCheck)
if not part then return end
local goal = CFrame.new(Camera.CFrame.Position, part.Position)
if Config.AimbotSmoothing > 0 then
Camera.CFrame = Camera.CFrame:Lerp(goal, 1 - Config.AimbotSmoothing)
else
Camera.CFrame = goal
end
end
local triggerReady = true
local function runTriggerbot()
if not Config.TriggerEnabled or not triggerReady then return end
if not isrbxactive or not isrbxactive() then return end
local center = Camera.ViewportSize * 0.5
local ray = Camera:ViewportPointToRay(center.X, center.Y)
local result = Workspace:Raycast(ray.Origin, ray.Direction * 2000, rayParams)
if not result then return end
local character = result.Instance:FindFirstAncestorOfClass("Model")
local player = character and Players:GetPlayerFromCharacter(character)
if not player or player == LocalPlayer then return end
if not isAlive(player) or not isEnemy(player, Config.TriggerTeamCheck) then return end
triggerReady = false
task.spawn(function()
mouse1click()
task.wait(Config.TriggerDelay + 0.03)
triggerReady = true
end)
end
local RAGE_POINTS = { "HeadHB", "Head", "Hitbox", "UpperTorso", "HumanoidRootPart" }
local rageLocked = nil
local rageFiring = false
local nextRageShot = 0
local function ragePoint(character)
if not Config.RageMultipoint then
local part = resolvePart(character, Config.RagePart)
if part and (not Config.RageWallCheck or isVisible(character, part)) then return part end
return nil
end
for _, name in RAGE_POINTS do
local part = character:FindFirstChild(name)
if part and (not Config.RageWallCheck or isVisible(character, part)) then return part end
end
return nil
end
local function rageCandidate(player)
if player == LocalPlayer or not isAlive(player) then return nil end
if not isEnemy(player, Config.RageTeamCheck) then return nil end
local character = player.Character
if not character then return nil end
local anchor = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
if not anchor then return nil end
if (anchor.Position - Camera.CFrame.Position).Magnitude > Config.RageMaxDistance then return nil end
return ragePoint(character)
end
local function getRageTarget()
if Config.RageTargetLock and rageLocked and rageLocked.Parent then
local part = rageCandidate(rageLocked)
if part then return part end
rageLocked = nil
end
local cursor = UserInputService:GetMouseLocation()
local origin = Camera.CFrame.Position
local best, bestPart, bestScore
for _, player in Players:GetPlayers() do
local part = rageCandidate(player)
if part then
local score
if Config.RagePriority == "Distance" then
score = (part.Position - origin).Magnitude
elseif Config.RagePriority == "Health" then
score = (getHealth(player))
else
local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
score = onScreen
and (Vector2.new(screenPos.X, screenPos.Y) - cursor).Magnitude
or Camera.ViewportSize.Magnitude + (part.Position - origin).Magnitude
end
if score and (not bestScore or score < bestScore) then
best, bestPart, bestScore = player, part, score
end
end
end
rageLocked = best
return bestPart
end
local function ragePosition(part)
if Config.RageLead <= 0 then return part.Position end
return part.Position + part.AssemblyLinearVelocity * (Config.RageLead / 1000)
end
local function releaseRageFire()
if not rageFiring then return end
rageFiring = false
pcall(mouse1release)
end
local function runRagebot()
if not Config.RageEnabled or not isAlive(LocalPlayer) then
releaseRageFire()
return
end
local part = getRageTarget()
if not part then
releaseRageFire()
return
end
if Config.RageMode == "Snap" then
Camera.CFrame = CFrame.new(Camera.CFrame.Position, ragePosition(part))
end
if not Config.RageAutoFire
or not isrbxactive or not isrbxactive()
or UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter
then
releaseRageFire()
return
end
if math.random(1, 100) > Config.RageHitChance then return end
local weapon = equippedWeapon()
local auto = weapon and weapon:FindFirstChild("Auto")
if auto and auto.Value then
if not rageFiring then
rageFiring = true
pcall(mouse1press)
end
return
end
releaseRageFire()
local now = os.clock()
if now < nextRageShot then return end
nextRageShot = now + equippedFireRate()
pcall(mouse1click)
end
local function setWeaponStat(statName, value)
for _, folder in ReplicatedStorage.Weapons:GetChildren() do
local stat = folder:FindFirstChild(statName)
if stat and stat:IsA("ValueBase") then
if value == nil then
if State.OriginalWeaponStats[stat] ~= nil then
stat.Value = State.OriginalWeaponStats[stat]
State.OriginalWeaponStats[stat] = nil
end
else
if State.OriginalWeaponStats[stat] == nil then
State.OriginalWeaponStats[stat] = stat.Value
end
stat.Value = value
end
end
end
end
local HITBOX_SETS = {
Head = { "HeadHB" },
Body = { "Hitbox" },
Both = { "HeadHB", "Hitbox" },
}
local hitboxOriginals = {}
local hitboxTouched = {}
local function restoreHitboxes()
for part, size in hitboxOriginals do
if part.Parent then part.Size = size end
hitboxOriginals[part] = nil
end
end
local function applyHitboxes()
table.clear(hitboxTouched)
if Config.HitboxEnabled then
local size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
local names = HITBOX_SETS[Config.HitboxTarget] or HITBOX_SETS.Head
for _, player in Players:GetPlayers() do
if player ~= LocalPlayer and isAlive(player) and isEnemy(player, Config.HitboxTeamCheck) then
local character = player.Character
for _, partName in names do
local part = character:FindFirstChild(partName)
if part and part:IsA("BasePart") then
if hitboxOriginals[part] == nil then
hitboxOriginals[part] = part.Size
end
if part.Size ~= size then
part.Size = size
part.CanCollide = false
part.Massless = true
end
hitboxTouched[part] = true
end
end
end
end
end
for part, original in hitboxOriginals do
if not hitboxTouched[part] then
if part.Parent then part.Size = original end
hitboxOriginals[part] = nil
end
end
end
connect(UserInputService.JumpRequest, function()
if not Config.InfiniteJump then return end
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end)
connect(LocalPlayer.Idled, function()
if not Config.AntiAFK then return end
VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)
connect(LocalPlayer.CharacterAdded, function()
task.wait(0.5)
Camera = Workspace.CurrentCamera
refreshRayFilter()
end)
connect(Players.PlayerRemoving, removeESP)
connect(RunService.RenderStepped, function()
Camera = Workspace.CurrentCamera
if Config.Rainbow then
rainbowColor = Color3.fromHSV((os.clock() * Config.RainbowSpeed) % 1, 1, 1)
end
fovCircle.Visible = Config.FOVVisible
if Config.FOVVisible then
fovCircle.Position = UserInputService:GetMouseLocation()
fovCircle.Radius = Config.FOVRadius
fovCircle.Filled = Config.FOVFilled
fovCircle.Color = tint(Config.FOVColor)
end
updateCrosshair()
updateBulletTracers()
applyHitboxes()
runAimbot()
runRagebot()
runTriggerbot()
updateESP()
updatePickupESP()
end)
local FOV_BIND = "KaliArsenalFOV"
RunService:UnbindFromRenderStep(FOV_BIND)
RunService:BindToRenderStep(FOV_BIND, Enum.RenderPriority.Camera.Value + 10, function()
if Config.CustomFOVEnabled then
Workspace.CurrentCamera.FieldOfView = Config.CustomFOVValue
end
end)
State.Unload = function()
for _, conn in State.Connections do
pcall(function() conn:Disconnect() end)
end
for _, drawing in State.Drawings do
pcall(function() drawing:Remove() end)
end
for _, highlight in State.Highlights do
pcall(function() highlight:Destroy() end)
end
for stat, value in State.OriginalWeaponStats do
pcall(function() stat.Value = value end)
end
pcall(restoreHitboxes)
pcall(releaseRageFire)
pcall(function() RunService:UnbindFromRenderStep(FOV_BIND) end)
PlayerScripts:SetAttribute("SA_Enabled", false)
PlayerScripts:SetAttribute("SA_Rage", false)
if State.Window then
pcall(function() State.Window:Destroy() end)
end
local libraryConnections = State.Library and State.Library.Connections
if libraryConnections then
for _, connection in libraryConnections do
if typeof(connection) == "RBXScriptConnection" then
pcall(function() connection:Disconnect() end)
end
end
table.clear(libraryConnections)
end
for _, gui in State.Guis do
pcall(function() gui:Destroy() end)
end
table.clear(State.Guis)
end
local storedFonts = {}
for _, font in Enum.Font:GetEnumItems() do
table.insert(storedFonts, font.Name)
end
gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 150,
MaxHeight = 620,
InitialHeight = 520,
MinWidth = 350,
MaxWidth = 800,
InitialWidth = 580,
}
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local parent = PlayerGui
local before = {}
for _, child in parent:GetChildren() do before[child] = true end
local ok, window = pcall(library.CreateWindow, library, getfenv().gui_config, parent)
if not ok then
parent = gethui()
before = {}
for _, child in parent:GetChildren() do before[child] = true end
window = library:CreateWindow(getfenv().gui_config, parent)
end
library:SetWindowName("Kali Hub | Arsenal")
State.Window = window
State.Library = library
for _, child in parent:GetChildren() do
if not before[child] and child:IsA("ScreenGui") then
child.ResetOnSpawn = false
table.insert(State.Guis, child)
end
end
local tabs = {
main = window:CreateTab("Main"),
visuals = window:CreateTab("Visuals"),
config = window:CreateTab("Config"),
}
local sections = {
aimbot = tabs.main:CreateSection("Aimbot", "left"),
silent = tabs.main:CreateSection("Silent Aim", "right"),
rage = tabs.main:CreateSection("Ragebot", "right"),
trigger = tabs.main:CreateSection("Triggerbot", "left"),
fov = tabs.main:CreateSection("FOV", "right"),
hitbox = tabs.main:CreateSection("Hitbox", "left"),
weapon = tabs.main:CreateSection("Weapon", "left"),
player = tabs.main:CreateSection("Player", "right"),
esp = tabs.visuals:CreateSection("Player ESP", "left"),
screen = tabs.visuals:CreateSection("Screen", "left"),
espColors = tabs.visuals:CreateSection("Colors", "right"),
world = tabs.visuals:CreateSection("World", "right"),
settings = tabs.config:CreateSection("Settings"),
}
sections.aimbot:CreateToggle("Aimbot", false, function(value)
Config.AimbotEnabled = value
end)
sections.aimbot:CreateDropdown("Aim Key", { "Right Mouse", "Left Mouse", "Q", "E", "C", "Always" }, function(value)
Config.AimbotKey = value
aimbotHeld = false
end, "Right Mouse", false)
sections.aimbot:CreateDropdown("Hit Part", HIT_PARTS, function(value)
Config.AimbotPart = value
end, "Head", false)
sections.aimbot:CreateSlider("Smoothing", 0, 0.95, 0, false, function(value)
Config.AimbotSmoothing = value
end)
sections.aimbot:CreateSlider("Hit Chance %", 0, 100, 100, true, function(value)
Config.AimbotHitChance = value
end)
sections.aimbot:CreateToggle("Team Check", true, function(value)
Config.AimbotTeamCheck = value
end)
sections.aimbot:CreateToggle("Wall Check", true, function(value)
Config.AimbotWallCheck = value
end)
sections.silent:CreateToggle("Silent Aim", false, function(value)
Config.SilentEnabled = value
pushSilentConfig()
if value then
local ok, err = installSilentAim()
if not ok then
Config.SilentEnabled = false
pushSilentConfig()
window:Notify("Silent Aim failed", tostring(err), 8)
end
end
end)
sections.silent:CreateDropdown("Hit Part", HIT_PARTS, function(value)
Config.SilentPart = value
pushSilentConfig()
end, "Head", false)
sections.silent:CreateSlider("FOV Limit", 10, 800, 120, true, function(value)
Config.SilentFOV = value
pushSilentConfig()
end)
sections.silent:CreateSlider("Hit Chance %", 0, 100, 100, true, function(value)
Config.SilentHitChance = value
pushSilentConfig()
end)
sections.silent:CreateToggle("Team Check", true, function(value)
Config.SilentTeamCheck = value
pushSilentConfig()
end)
sections.silent:CreateToggle("Wall Check", true, function(value)
Config.SilentWallCheck = value
pushSilentConfig()
end)
sections.silent:CreateTextBox("Camera Upvalues", "35", true, function(value)
Config.SilentUpvalues = tonumber(value) or 35
pushSilentConfig()
end)
sections.rage:CreateToggle("Rage Bot", false, function(value)
Config.RageEnabled = value
pushSilentConfig()
if value and Config.RageMode == "Silent" then
local ok, err = installSilentAim()
if not ok then
Config.RageEnabled = false
pushSilentConfig()
window:Notify("Rage Bot failed", tostring(err), 8)
end
end
if not value then releaseRageFire() end
end)
sections.rage:CreateDropdown("Mode", { "Silent", "Snap" }, function(value)
Config.RageMode = value
pushSilentConfig()
if Config.RageEnabled and value == "Silent" then
local ok, err = installSilentAim()
if not ok then window:Notify("Rage Bot failed", tostring(err), 8) end
end
end, "Silent", false)
sections.rage:CreateDropdown("Priority", { "Crosshair", "Distance", "Health" }, function(value)
Config.RagePriority = value
pushSilentConfig()
end, "Crosshair", false)
sections.rage:CreateToggle("Multipoint", true, function(value)
Config.RageMultipoint = value
pushSilentConfig()
end)
sections.rage:CreateDropdown("Hit Part", HIT_PARTS, function(value)
Config.RagePart = value
pushSilentConfig()
end, "Head", false)
sections.rage:CreateToggle("Auto Fire", true, function(value)
Config.RageAutoFire = value
if not value then releaseRageFire() end
end)
sections.rage:CreateToggle("Target Lock", true, function(value)
Config.RageTargetLock = value
rageLocked = nil
pushSilentConfig()
end)
sections.rage:CreateSlider("Max Distance", 100, 5000, 2000, true, function(value)
Config.RageMaxDistance = value
pushSilentConfig()
end)
sections.rage:CreateSlider("Lead (ms)", 0, 200, 0, true, function(value)
Config.RageLead = value
pushSilentConfig()
end)
sections.rage:CreateSlider("Hit Chance %", 0, 100, 100, true, function(value)
Config.RageHitChance = value
pushSilentConfig()
end)
sections.rage:CreateToggle("Team Check", true, function(value)
Config.RageTeamCheck = value
pushSilentConfig()
end)
sections.rage:CreateToggle("Wall Check", false, function(value)
Config.RageWallCheck = value
pushSilentConfig()
end)
sections.trigger:CreateToggle("Triggerbot", false, function(value)
Config.TriggerEnabled = value
end)
sections.trigger:CreateSlider("Delay", 0, 0.5, 0.05, false, function(value)
Config.TriggerDelay = value
end)
sections.trigger:CreateToggle("Team Check", true, function(value)
Config.TriggerTeamCheck = value
end)
sections.fov:CreateToggle("FOV Circle", false, function(value)
Config.FOVVisible = value
end)
sections.fov:CreateSlider("FOV Radius", 10, 800, 120, true, function(value)
Config.FOVRadius = value
end)
sections.fov:CreateToggle("Filled", false, function(value)
Config.FOVFilled = value
end)
sections.fov:CreateColorpicker("FOV Color", function(color)
Config.FOVColor = color
end)
sections.esp:CreateToggle("Enable ESP", false, function(value)
Config.ESPEnabled = value
end)
sections.esp:CreateToggle("Box", true, function(value)
Config.ESPBox = value
end)
sections.esp:CreateToggle("Name", true, function(value)
Config.ESPName = value
end)
sections.esp:CreateToggle("Health Bar", true, function(value)
Config.ESPHealth = value
end)
sections.esp:CreateToggle("Distance", false, function(value)
Config.ESPDistance = value
end)
sections.esp:CreateToggle("Tracer", false, function(value)
Config.ESPTracer = value
end)
sections.esp:CreateDropdown("Tracer Origin", { "Bottom", "Center", "Mouse" }, function(value)
Config.ESPTracerOrigin = value
end, "Bottom", false)
sections.esp:CreateToggle("Snapline", false, function(value)
Config.ESPSnapline = value
end)
sections.esp:CreateToggle("Chams", false, function(value)
Config.ESPChams = value
end)
sections.esp:CreateToggle("Team Check", true, function(value)
Config.ESPTeamCheck = value
end)
sections.esp:CreateSlider("Max Distance", 100, 5000, 2000, true, function(value)
Config.ESPMaxDistance = value
end)
sections.espColors:CreateColorpicker("Enemy Color", function(color)
Config.ESPEnemyColor = color
end)
sections.espColors:CreateColorpicker("Ally Color", function(color)
Config.ESPAllyColor = color
end)
sections.espColors:CreateToggle("Rainbow", false, function(value)
Config.Rainbow = value
end)
sections.espColors:CreateSlider("Rainbow Speed", 0.05, 3, 0.5, false, function(value)
Config.RainbowSpeed = value
end)
sections.screen:CreateToggle("Custom FOV", false, function(value)
Config.CustomFOVEnabled = value
end)
sections.screen:CreateSlider("FOV Value", 40, 120, 90, true, function(value)
Config.CustomFOVValue = value
end)
sections.screen:CreateToggle("Custom Crosshair", false, function(value)
Config.CrosshairEnabled = value
end)
sections.screen:CreateSlider("Crosshair Size", 1, 40, 10, true, function(value)
Config.CrosshairSize = value
end)
sections.screen:CreateSlider("Crosshair Gap", 0, 30, 4, true, function(value)
Config.CrosshairGap = value
end)
sections.screen:CreateSlider("Crosshair Thickness", 1, 8, 2, true, function(value)
Config.CrosshairThickness = value
end)
sections.screen:CreateToggle("Crosshair Dot", false, function(value)
Config.CrosshairDot = value
end)
sections.screen:CreateColorpicker("Crosshair Color", function(color)
Config.CrosshairColor = color
end)
sections.world:CreateToggle("Pickup ESP", false, function(value)
Config.ESPPickups = value
end)
sections.world:CreateToggle("Bullet Tracers", false, function(value)
Config.BulletTracers = value
end)
sections.world:CreateSlider("Tracer Lifetime", 0.05, 2, 0.25, false, function(value)
Config.BulletTracerLife = value
end)
sections.world:CreateColorpicker("Tracer Color", function(color)
Config.BulletTracerColor = color
end)
sections.hitbox:CreateToggle("Hitbox Expander", false, function(value)
Config.HitboxEnabled = value
if not value then restoreHitboxes() end
end)
sections.hitbox:CreateDropdown("Target", { "Head", "Body", "Both" }, function(value)
Config.HitboxTarget = value
end, "Head", false)
sections.hitbox:CreateSlider("Size", 2, 20, 5, true, function(value)
Config.HitboxSize = value
end)
sections.hitbox:CreateToggle("Team Check", true, function(value)
Config.HitboxTeamCheck = value
end)
sections.weapon:CreateToggle("No Recoil", false, function(value)
setWeaponStat("RecoilControl", value and 0 or nil)
end)
sections.weapon:CreateToggle("No Spread", false, function(value)
setWeaponStat("Spread", value and 0 or nil)
setWeaponStat("MaxSpread", value and 0 or nil)
end)
sections.weapon:CreateToggle("Rapid Fire", false, function(value)
Config.RapidFire = value
setWeaponStat("FireRate", value and Config.RapidFireRate or nil)
end)
sections.weapon:CreateSlider("Fire Rate", 0.01, 0.3, 0.05, false, function(value)
Config.RapidFireRate = value
if Config.RapidFire then
setWeaponStat("FireRate", value)
end
end)
sections.weapon:CreateToggle("Instant Reload", false, function(value)
Config.InstantReload = value
setWeaponStat("ReloadTime", value and 0 or nil)
end)
sections.weapon:CreateToggle("Unlimited Range", false, function(value)
Config.UnlimitedRange = value
setWeaponStat("Range", value and 100000 or nil)
end)
sections.weapon:CreateToggle("Instant Equip", false, function(value)
Config.InstantEquip = value
setWeaponStat("EquipTime", value and 0 or nil)
end)
sections.player:CreateToggle("Infinite Jump", false, function(value)
Config.InfiniteJump = value
end)
sections.player:CreateToggle("Anti AFK", true, function(value)
Config.AntiAFK = value
end)
sections.settings:CreateDropdown("Change Font", storedFonts, function(value)
window:SetFont(value)
end, "", false)
sections.settings:CreateLabel("Menu Key (PC): " .. tostring(gui_config.Keybind):gsub("Enum.KeyCode.", ""))
sections.settings:CreateButton("Unload", function()
State.Unload()
end)
local configManager = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
configManager:SetLibrary(library)
configManager:SetWindow(window)
configManager:SetFolder("Kali Hub")
configManager:BuildConfigSection(tabs.config)
configManager:LoadAutoloadConfig()
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
window:SetTileScale(0.5)
window:SetBackgroundColor(Color3.fromRGB(255, 255, 255))
window:SetBackgroundTransparency(0)
window:Notify("Kali Hub | Arsenal", "https://kalihub.xyz", 10)
local watermark = library:Hud()
connect(RunService.RenderStepped, function()
watermark:SetText("kalihub.xyz/discord | " .. os.date("%Y-%m-%d %H:%M:%S", os.time()))
end)
pushSilentConfig()
