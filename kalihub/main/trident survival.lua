--this shit was unobfuscated


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local stored_fonts = {}
gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 150,
MaxHeight = 600,
InitialHeight = 500,
MinWidth = 350,
MaxWidth = 800,
InitialWidth = 600
}
for _, v in Enum.Font:GetEnumItems() do
table.insert(stored_fonts, v.Name)
end
local config = (getfenv().gui_config) or nil
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(config, gethui())
library:SetWindowName("Kali Hub | Trident Survival")
local tabs = {
combat = window:CreateTab("Combat"),
settings = window:CreateTab("Settings")
}
local sections = {
silent_aim_section = tabs.combat:CreateSection("Silent Aim"),
hitbox_expander_section = tabs.combat:CreateSection("Hitbox Expander"),
player_esp_section = tabs.combat:CreateSection("Player ESP"),
ore_esp_section = tabs.combat:CreateSection("Ore ESP"),
settings_section = tabs.settings:CreateSection("Settings")
}
local hitboxSettings = {
Enabled = false,
Size = 5,
RainbowEnabled = true,
OriginalSizes = {},
OriginalTransparencies = {},
OriginalCanCollide = {},
Highlights = {}
}
local hitPartOptions = {
"Head",
"HumanoidRootPart",
"Torso"
}
local currentHitPart = "Head"
local fullbrightSettings = {
Enabled = false,
OriginalAmbient = nil,
OriginalOutdoorAmbient = nil,
OriginalBrightness = nil,
OriginalClockTime = nil,
OriginalFogEnd = nil,
OriginalEffectsEnabled = {}
}
local function cacheLightingIfNeeded()
if fullbrightSettings.OriginalAmbient ~= nil then return end
fullbrightSettings.OriginalAmbient = Lighting.Ambient
fullbrightSettings.OriginalOutdoorAmbient = Lighting.OutdoorAmbient
fullbrightSettings.OriginalBrightness = Lighting.Brightness
fullbrightSettings.OriginalClockTime = Lighting.ClockTime
fullbrightSettings.OriginalFogEnd = Lighting.FogEnd
fullbrightSettings.OriginalEffectsEnabled = {}
for _, effect in ipairs(Lighting:GetChildren()) do
if effect:IsA("PostEffect") then
fullbrightSettings.OriginalEffectsEnabled[effect] = effect.Enabled
end
end
end
local playerEspSettings = {
Enabled = false,
ShowBox = true,
ShowDistance = false,
BoxColor = Color3.fromRGB(194, 17, 17),
BoxThickness = 2,
BoxTransparency = 0.5
}
local tracerSettings = {
Enabled = false,
TracerPosition = "Bottom",
TracerColor = Color3.fromRGB(255, 255, 255),
TracerThickness = 1,
TracerTransparency = 1
}
local skeletonSettings = {
Enabled = false,
SkeletonColor = Color3.fromRGB(255, 255, 255),
SkeletonThickness = 1,
SkeletonTransparency = 1
}
local oreEspSettings = {
Enabled = false,
ShowName = true,
ShowDistance = false,
ShowTracers = false,
NameColor = Color3.fromRGB(255, 255, 255),
TracerColor = Color3.fromRGB(0, 255, 0),
NameSize = 14,
NameOutline = true,
TracerThickness = 1,
TracerTransparency = 1,
TracerPosition = "Bottom",
AllowedOres = {}
}
local oreESPObjects = {}
local ore_loaded = false
local ore_connections = {}
getgenv().silentAimEnabled = false
sections.silent_aim_section:CreateToggle("Silent Aim", getgenv().silentAimEnabled, function(value)
getgenv().silentAimEnabled = value
if value then
run_on_actor(getactors()[1], [[
            
            local camera = workspace.CurrentCamera
            local runService = game:GetService("RunService")

            getgenv().silentAim = {
                Enabled = true,
                HitPart = "Head", 
                Fov = {
                    Radius = 600
                },
                PlayersVelocity = {
                    Position = {},
                    Time = {}
                }
            }

            local createProjectile
            local players = {}

            for i, v in getgc() do
                if typeof(v) == "function" and not iscclosure(v) then
                    if debug.getconstants(v)[1] == "ProjectileSpeed" and string.match(debug.info(v, "s"), "RangedWeaponClient") then
                        createProjectile = v
                    elseif debug.info(v, "n") == "updatePlayers" and string.match(debug.info(v, "s"), "PlayerClient") then
                        players = debug.getupvalue(v, 1)
                    end
                end
            end

            
            if not getgenv().originalCreateProjectile then
                getgenv().originalCreateProjectile = createProjectile
            end

            
            local function getclosestPlayer()
                local closest, closestIndex, closestdistance = nil, 0, getgenv().silentAim.Fov.Radius

                for index, player in players do
                    if not player.model or player.sleeping then
                        continue
                    end

                    local hitPart = player.model:FindFirstChild(getgenv().silentAim.HitPart)
                    if not hitPart then
                        continue
                    end

                    local screenPosition = camera:WorldToViewportPoint(hitPart.Position)
                    if screenPosition.Z <= 0 then
                        continue
                    end

                    local distance = (camera.ViewportSize/2 - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude
                    if distance < closestdistance then
                        closestdistance = distance
                        closest = hitPart
                        closestIndex = index
                    end
                end

                return closest, closestIndex
            end

            local function calculateTime(from, to, muzzleVelocity)
                local distance = (to - from).Magnitude
                local time = distance / muzzleVelocity
                return time
            end

            
            if not getgenv().silentAimHook then
                getgenv().silentAimHook = hookfunction(getgenv().originalCreateProjectile, function(cFrame, weaponInfo, isLocal, p63, p64)
                    if isLocal and getgenv().silentAim and getgenv().silentAim.Enabled then
                        local hitPart, index = getclosestPlayer()
                        if hitPart then
                            local time = calculateTime(cFrame.Position, hitPart.Position, weaponInfo.ProjectileSpeed)
                            local playerVelocity = (getgenv().silentAim.PlayersVelocity.Position[index] and getgenv().silentAim.PlayersVelocity.Position[index][15] and (getgenv().silentAim.PlayersVelocity.Position[index][15] - getgenv().silentAim.PlayersVelocity.Position[index][1]) / (getgenv().silentAim.PlayersVelocity.Time[15] - getgenv().silentAim.PlayersVelocity.Time[1])) or Vector3.zero
                            local prediction = hitPart.Position + (playerVelocity * time)
                            time = calculateTime(cFrame.Position, prediction, weaponInfo.ProjectileSpeed)
                            cFrame = CFrame.new(cFrame.Position, prediction - Vector3.yAxis * (-weaponInfo.ProjectileDrop ^ (time * weaponInfo.ProjectileDrop) + 1))
                        end
                    end
                    return getgenv().silentAimHook(cFrame, weaponInfo, isLocal, p63, p64)
                end)
            end

            
            if not getgenv().silentAimConnection then
                getgenv().silentAimConnection = runService.Heartbeat:Connect(function()
                    if not getgenv().silentAim or not getgenv().silentAim.Enabled then
                        return
                    end
                    for index, player in players do
                        if not player.model or player.sleeping then
                            continue
                        end
                        getgenv().silentAim.PlayersVelocity.Position[index] = getgenv().silentAim.PlayersVelocity.Position[index] or {}
                        table.insert(getgenv().silentAim.PlayersVelocity.Position[index], 1, player.model.Torso.Position)
                        table.remove(getgenv().silentAim.PlayersVelocity.Position[index], 16)
                    end
                    table.insert(getgenv().silentAim.PlayersVelocity.Time, 1, tick())
                    table.remove(getgenv().silentAim.PlayersVelocity.Time, 16)
                end)
            end
        ]])
else
run_on_actor(getactors()[1], [[
            if getgenv().silentAimConnection then
                getgenv().silentAimConnection:Disconnect()
                getgenv().silentAimConnection = nil
            end
            if getgenv().silentAimHook and getgenv().originalCreateProjectile then
                hookfunction(getgenv().originalCreateProjectile, getgenv().silentAimHook)
                getgenv().silentAimHook = nil
            end
            getgenv().silentAim = nil
        ]])
end
end)
sections.silent_aim_section:CreateDropdown(
"Hit Part",
hitPartOptions,
function(value)
currentHitPart = value
run_on_actor(getactors()[1], [[
            if getgenv().silentAim then
                getgenv().silentAim.HitPart = "]] .. value .. [["
            end
        ]])
end,
currentHitPart,
false
)
local fovSettings = {
Enabled = false,
Radius = 150,
Color = Color3.fromRGB(255, 255, 255),
Transparency = 0.5,
Thickness = 2
}
local fovCircle = nil
local function updateFovCircle()
if fovSettings.Enabled then
if not fovCircle then
fovCircle = Drawing.new("Circle")
fovCircle.NumSides = 100
fovCircle.Radius = fovSettings.Radius
fovCircle.Color = fovSettings.Color
fovCircle.Thickness = fovSettings.Thickness
fovCircle.Transparency = fovSettings.Transparency
fovCircle.Filled = false
end
fovCircle.Position = Vector2.new(
workspace.CurrentCamera.ViewportSize.X / 2,
workspace.CurrentCamera.ViewportSize.Y / 2
)
fovCircle.Radius = fovSettings.Radius
fovCircle.Color = fovSettings.Color
fovCircle.Transparency = fovSettings.Transparency
fovCircle.Thickness = fovSettings.Thickness
fovCircle.Visible = true
elseif fovCircle then
fovCircle.Visible = false
end
end
local fovConnection
if not fovConnection then
fovConnection = RunService.RenderStepped:Connect(function()
updateFovCircle()
end)
end
local show_fov_toggle = sections.silent_aim_section:CreateToggle("Show FOV", fovSettings.Enabled, function(value)
fovSettings.Enabled = value
updateFovCircle()
end)
sections.silent_aim_section:CreateSlider(
"FOV Radius",
50,
600,
fovSettings.Radius,
false,
function(value)
fovSettings.Radius = value
updateFovCircle()
end
)
sections.silent_aim_section:CreateSlider(
"FOV Thickness",
1,
5,
fovSettings.Thickness,
false,
function(value)
fovSettings.Thickness = value
updateFovCircle()
end
)
local fov_color_toggle = sections.silent_aim_section:CreateToggle("FOV Color Picker", false, function(value) end)
sections.silent_aim_section:CreateColorpicker("FOV Color", function(color, transparency)
fovSettings.Color = color
fovSettings.Transparency = 1 - transparency
updateFovCircle()
end, false, false, fov_color_toggle)
local rainbowHue = 0
RunService.RenderStepped:Connect(function()
rainbowHue = (rainbowHue + 0.05) % 1
end)
local function expandHitbox(player)
if not player or not player:IsA("Model") then return end
local head = player:FindFirstChild("Head")
if not head then return end
if not hitboxSettings.OriginalSizes[head] then
hitboxSettings.OriginalSizes[head] = head.Size
hitboxSettings.OriginalTransparencies[head] = head.Transparency
hitboxSettings.OriginalCanCollide[head] = head.CanCollide
end
head.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
head.Transparency = 0.5
head.CanCollide = false
if not hitboxSettings.Highlights[head] then
local highlight = Instance.new("Highlight")
highlight.Parent = head
highlight.Adornee = head
highlight.FillColor = hitboxSettings.RainbowEnabled and Color3.fromHSV(rainbowHue, 1, 1) or Color3.fromRGB(255, 0, 0)
highlight.OutlineColor = hitboxSettings.RainbowEnabled and Color3.fromHSV(rainbowHue, 1, 1) or Color3.fromRGB(255, 0, 0)
highlight.FillTransparency = 0.5
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
hitboxSettings.Highlights[head] = highlight
end
end
local function restoreHitbox(player)
if not player or not player:IsA("Model") then return end
local head = player:FindFirstChild("Head")
if not head then return end
if hitboxSettings.Highlights[head] then
hitboxSettings.Highlights[head]:Destroy()
hitboxSettings.Highlights[head] = nil
end
if hitboxSettings.OriginalSizes[head] then
head.Size = hitboxSettings.OriginalSizes[head]
head.Transparency = hitboxSettings.OriginalTransparencies[head]
head.CanCollide = hitboxSettings.OriginalCanCollide[head]
hitboxSettings.OriginalSizes[head] = nil
hitboxSettings.OriginalTransparencies[head] = nil
hitboxSettings.OriginalCanCollide[head] = nil
end
end
local function updateAllHitboxes()
for _, player in pairs(Workspace:GetChildren()) do
if player:IsA("Model") and player.Name == "Model" and player:FindFirstChild("Head") and player:FindFirstChild("HumanoidRootPart") then
if player ~= LocalPlayer.Character then
if hitboxSettings.Enabled then
expandHitbox(player)
else
restoreHitbox(player)
end
end
end
end
end
Workspace.DescendantAdded:Connect(function(descendant)
if hitboxSettings.Enabled and descendant.Name == "Head" and descendant.Parent:IsA("Model") and descendant.Parent.Name == "Model" then
local player = descendant.Parent
if player ~= LocalPlayer.Character then
task.wait(0.1)
expandHitbox(player)
end
end
end)
RunService.Heartbeat:Connect(function()
if hitboxSettings.Enabled then
updateAllHitboxes()
for head, highlight in pairs(hitboxSettings.Highlights) do
if highlight and highlight.Parent then
if hitboxSettings.RainbowEnabled then
highlight.FillColor = Color3.fromHSV(rainbowHue, 1, 1)
highlight.OutlineColor = Color3.fromHSV(rainbowHue, 1, 1)
else
highlight.FillColor = Color3.fromRGB(255, 0, 0)
highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
end
end
end
end
end)
sections.hitbox_expander_section:CreateToggle("Enable Hitbox Expander", hitboxSettings.Enabled, function(value)
hitboxSettings.Enabled = value
if value then
updateAllHitboxes()
else
for _, player in pairs(Workspace:GetChildren()) do
if player:IsA("Model") and player.Name == "Model" and player:FindFirstChild("Head") then
restoreHitbox(player)
end
end
end
end)
sections.hitbox_expander_section:CreateToggle("Disable Rainbow", not hitboxSettings.RainbowEnabled, function(value)
hitboxSettings.RainbowEnabled = not value
for head, highlight in pairs(hitboxSettings.Highlights) do
if highlight and highlight.Parent then
if hitboxSettings.RainbowEnabled then
highlight.FillColor = Color3.fromHSV(rainbowHue, 1, 1)
highlight.OutlineColor = Color3.fromHSV(rainbowHue, 1, 1)
else
highlight.FillColor = Color3.fromRGB(255, 0, 0)
highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
end
end
end
end)
sections.hitbox_expander_section:CreateSlider(
"Hitbox Size",
1,
10,
hitboxSettings.Size,
false,
function(value)
hitboxSettings.Size = value
if hitboxSettings.Enabled then
updateAllHitboxes()
end
end
)
local EnhancedESP = {}
local ESPObjects = {}
function EnhancedESP.Create(Player)
local Box = Drawing.new("Square")
Box.Visible = false
Box.Color = playerEspSettings.BoxColor
Box.Filled = false
Box.Transparency = playerEspSettings.BoxTransparency
Box.Thickness = playerEspSettings.BoxThickness
local DistanceText = Drawing.new("Text")
DistanceText.Visible = false
DistanceText.Color = Color3.fromRGB(255, 255, 255)
DistanceText.Size = 14
DistanceText.Center = true
DistanceText.Outline = true
DistanceText.Font = 2
local Tracer = Drawing.new("Line")
Tracer.Visible = false
Tracer.Color = tracerSettings.TracerColor
Tracer.Thickness = tracerSettings.TracerThickness
Tracer.Transparency = tracerSettings.TracerTransparency
local SkeletonLines = {}
local skeletonPairs = {
{"Head", "Torso"},
{"Torso", "Left Arm"},
{"Torso", "Right Arm"},
{"Torso", "Left Leg"},
{"Torso", "Right Leg"}
}
for i = 1, #skeletonPairs do
local line = Drawing.new("Line")
line.Visible = false
line.Color = skeletonSettings.SkeletonColor
line.Thickness = skeletonSettings.SkeletonThickness
line.Transparency = skeletonSettings.SkeletonTransparency
table.insert(SkeletonLines, line)
end
local Updater
local function UpdateESP()
if Player and Player:IsA("Model") and Player:FindFirstChild("HumanoidRootPart") and Player:FindFirstChild("Head") then
local hrp = Player.HumanoidRootPart
local head = Player.Head
local Target2dPosition, IsVisible = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
local scale_factor = 1 / (Target2dPosition.Z * math.tan(math.rad(workspace.CurrentCamera.FieldOfView * 0.5)) * 2) * 100
local width, height = math.floor(40 * scale_factor), math.floor(62 * scale_factor)
if playerEspSettings.Enabled and IsVisible then
if playerEspSettings.ShowBox then
Box.Visible = true
Box.Size = Vector2.new(width, height)
Box.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2, Target2dPosition.Y - Box.Size.Y / 2)
Box.Color = playerEspSettings.BoxColor
Box.Transparency = playerEspSettings.BoxTransparency
Box.Thickness = playerEspSettings.BoxThickness
else
Box.Visible = false
end
if playerEspSettings.ShowDistance then
local distance = (workspace.CurrentCamera.CFrame.Position - hrp.Position).Magnitude
DistanceText.Visible = true
DistanceText.Text = string.format("%.1f studs", distance)
DistanceText.Position = Vector2.new(Target2dPosition.X, Target2dPosition.Y + height / 2 + 15)
else
DistanceText.Visible = false
end
if tracerSettings.Enabled then
Tracer.Visible = true
local tracerStart
if tracerSettings.TracerPosition == "Top" then
tracerStart = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 0)
elseif tracerSettings.TracerPosition == "Middle" then
tracerStart = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
else
tracerStart = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
end
Tracer.From = tracerStart
Tracer.To = Vector2.new(Target2dPosition.X, Target2dPosition.Y)
Tracer.Color = tracerSettings.TracerColor
Tracer.Thickness = tracerSettings.TracerThickness
Tracer.Transparency = tracerSettings.TracerTransparency
else
Tracer.Visible = false
end
if skeletonSettings.Enabled then
for i, pair in ipairs(skeletonPairs) do
local part1 = Player:FindFirstChild(pair[1])
local part2 = Player:FindFirstChild(pair[2])
if part1 and part2 and SkeletonLines[i] then
local pos1, vis1 = workspace.CurrentCamera:WorldToViewportPoint(part1.Position)
local pos2, vis2 = workspace.CurrentCamera:WorldToViewportPoint(part2.Position)
if vis1 and vis2 then
SkeletonLines[i].Visible = true
SkeletonLines[i].From = Vector2.new(pos1.X, pos1.Y)
SkeletonLines[i].To = Vector2.new(pos2.X, pos2.Y)
SkeletonLines[i].Color = skeletonSettings.SkeletonColor
SkeletonLines[i].Thickness = skeletonSettings.SkeletonThickness
SkeletonLines[i].Transparency = skeletonSettings.SkeletonTransparency
else
SkeletonLines[i].Visible = false
end
else
if SkeletonLines[i] then
SkeletonLines[i].Visible = false
end
end
end
else
for _, line in ipairs(SkeletonLines) do
line.Visible = false
end
end
else
Box.Visible = false
DistanceText.Visible = false
Tracer.Visible = false
for _, line in ipairs(SkeletonLines) do
line.Visible = false
end
end
else
Box.Visible = false
DistanceText.Visible = false
Tracer.Visible = false
for _, line in ipairs(SkeletonLines) do
line.Visible = false
end
if not Player then
Box:Remove()
DistanceText:Remove()
Tracer:Remove()
for _, line in ipairs(SkeletonLines) do
line:Remove()
end
Updater:Disconnect()
end
end
end
Updater = game:GetService("RunService").RenderStepped:Connect(UpdateESP)
return {
Box = Box,
DistanceText = DistanceText,
Tracer = Tracer,
SkeletonLines = SkeletonLines
}
end
local function EnableEnhancedESP()
for _, Player in pairs(game:GetService("Workspace"):GetChildren()) do
if Player:IsA("Model") and Player:FindFirstChild("HumanoidRootPart") and Player:FindFirstChild("Head") then
local esp = EnhancedESP.Create(Player)
table.insert(ESPObjects, esp)
end
end
end
game.Workspace.DescendantAdded:Connect(function(i)
if i:IsA("Model") and i:FindFirstChild("HumanoidRootPart") and i:FindFirstChild("Head") then
local esp = EnhancedESP.Create(i)
table.insert(ESPObjects, esp)
end
end)
EnableEnhancedESP()
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local FreeCamEnabled = false
local FreeCamSpeed = 150
local PITCH_LIMIT = math.rad(80)
local freecamPos
local freecamYaw = 0
local freecamPitch = 0
local oldWalkSpeed, oldJumpPower
local oldMouseBehavior, oldMouseIconEnabled
local moveKeys = {
[Enum.KeyCode.W] = Vector3.new(0, 0, -1),
[Enum.KeyCode.S] = Vector3.new(0, 0, 1),
[Enum.KeyCode.A] = Vector3.new(-1, 0, 0),
[Enum.KeyCode.D] = Vector3.new(1, 0, 0),
[Enum.KeyCode.Space] = Vector3.new(0, 1, 0),
[Enum.KeyCode.LeftShift] = Vector3.new(0, -1, 0)
}
local moveState = {}
local inputBeganConn, inputEndedConn
local function enableFreeCam()
if FreeCamEnabled then return end
FreeCamEnabled = true
local cf = Camera.CFrame
freecamPos = cf.Position
local look = cf.LookVector
freecamPitch = math.asin(-look.Y)
freecamYaw = math.atan2(-look.X, -look.Z)
Camera.CameraType = Enum.CameraType.Scriptable
local char = LocalPlayer.Character
if char then
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
oldWalkSpeed = hum.WalkSpeed
oldJumpPower = hum.JumpPower
hum.WalkSpeed = 0
hum.JumpPower = 0
end
end
oldMouseBehavior = UserInputService.MouseBehavior
oldMouseIconEnabled = UserInputService.MouseIconEnabled
UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
UserInputService.MouseIconEnabled = false
inputBeganConn = UserInputService.InputBegan:Connect(function(input, gpe)
if gpe then return end
if moveKeys[input.KeyCode] then
moveState[input.KeyCode] = true
end
end)
inputEndedConn = UserInputService.InputEnded:Connect(function(input)
if moveKeys[input.KeyCode] then
moveState[input.KeyCode] = false
end
end)
RunService:BindToRenderStep("KaliHub_FreeCam", Enum.RenderPriority.Camera.Value + 1, function(dt)
local delta = UserInputService:GetMouseDelta()
freecamYaw = freecamYaw - delta.X * 0.002
freecamPitch = math.clamp(freecamPitch - delta.Y * 0.002, -PITCH_LIMIT, PITCH_LIMIT)
local rot = CFrame.Angles(0, freecamYaw, 0) * CFrame.Angles(freecamPitch, 0, 0)
local moveDir = Vector3.zero
for key, vec in pairs(moveKeys) do
if moveState[key] then
moveDir += vec
end
end
if moveDir.Magnitude > 0 then
moveDir = rot:VectorToWorldSpace(moveDir).Unit
freecamPos += moveDir * FreeCamSpeed * dt
end
Camera.CFrame = CFrame.new(freecamPos) * rot
end)
end
local function disableFreeCam()
if not FreeCamEnabled then return end
FreeCamEnabled = false
RunService:UnbindFromRenderStep("KaliHub_FreeCam")
if inputBeganConn then inputBeganConn:Disconnect(); inputBeganConn = nil end
if inputEndedConn then inputEndedConn:Disconnect(); inputEndedConn = nil end
Camera.CameraType = Enum.CameraType.Custom
local char = LocalPlayer.Character
if char then
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
if oldWalkSpeed then hum.WalkSpeed = oldWalkSpeed end
if oldJumpPower then hum.JumpPower = oldJumpPower end
end
end
if oldMouseBehavior then
UserInputService.MouseBehavior = oldMouseBehavior
else
UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end
if oldMouseIconEnabled ~= nil then
UserInputService.MouseIconEnabled = oldMouseIconEnabled
else
UserInputService.MouseIconEnabled = true
end
end
sections.player_esp_section:CreateToggle("Freecam", false, function(value)
if value then
enableFreeCam()
else
disableFreeCam()
end
end)
sections.player_esp_section:CreateToggle("Enable Player ESP", playerEspSettings.Enabled, function(value)
playerEspSettings.Enabled = value
end)
sections.player_esp_section:CreateToggle("Show Box", playerEspSettings.ShowBox, function(value)
playerEspSettings.ShowBox = value
end)
sections.player_esp_section:CreateToggle("Show Distance", playerEspSettings.ShowDistance, function(value)
playerEspSettings.ShowDistance = value
end)
sections.player_esp_section:CreateSlider(
"Box Thickness",
1,
5,
playerEspSettings.BoxThickness,
false,
function(value)
playerEspSettings.BoxThickness = value
end
)
sections.player_esp_section:CreateSlider(
"Box Transparency",
0,
1,
playerEspSettings.BoxTransparency,
false,
function(value)
playerEspSettings.BoxTransparency = value
end
)
local function enableFullbright()
cacheLightingIfNeeded()
Lighting.Ambient = Color3.fromRGB(255, 255, 255)
Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
Lighting.Brightness = 2
Lighting.ClockTime = 12
Lighting.FogEnd = 100000
for _, effect in ipairs(Lighting:GetChildren()) do
if effect:IsA("PostEffect") then
effect.Enabled = false
end
end
end
local function disableFullbright()
if fullbrightSettings.OriginalAmbient == nil then return end
Lighting.Ambient = fullbrightSettings.OriginalAmbient
Lighting.OutdoorAmbient = fullbrightSettings.OriginalOutdoorAmbient
Lighting.Brightness = fullbrightSettings.OriginalBrightness
Lighting.ClockTime = fullbrightSettings.OriginalClockTime
Lighting.FogEnd = fullbrightSettings.OriginalFogEnd
for effect, wasEnabled in pairs(fullbrightSettings.OriginalEffectsEnabled) do
if effect and effect.Parent == Lighting then
effect.Enabled = wasEnabled
end
end
fullbrightSettings.OriginalAmbient = nil
fullbrightSettings.OriginalOutdoorAmbient = nil
fullbrightSettings.OriginalBrightness = nil
fullbrightSettings.OriginalClockTime = nil
fullbrightSettings.OriginalFogEnd = nil
fullbrightSettings.OriginalEffectsEnabled = {}
end
Lighting.Changed:Connect(function(property)
if fullbrightSettings.Enabled then
if property == "Ambient" or property == "OutdoorAmbient" or
property == "Brightness" or property == "ClockTime" or property == "FogEnd" then
enableFullbright()
end
end
end)
sections.player_esp_section:CreateToggle("Fullbright", fullbrightSettings.Enabled, function(value)
fullbrightSettings.Enabled = value
if value then
enableFullbright()
else
disableFullbright()
end
end)
local player_box_color_toggle = sections.player_esp_section:CreateToggle("Box Color Picker", false, function(value) end)
sections.player_esp_section:CreateColorpicker("Box Color", function(color, transparency)
playerEspSettings.BoxColor = color
end, false, false, player_box_color_toggle)
sections.player_esp_section:CreateToggle("Enable Tracers", tracerSettings.Enabled, function(value)
tracerSettings.Enabled = value
end)
sections.player_esp_section:CreateDropdown(
"Tracer Position",
{"Top", "Middle", "Bottom"},
function(value)
tracerSettings.TracerPosition = value
end,
tracerSettings.TracerPosition,
false
)
sections.player_esp_section:CreateSlider(
"Tracer Thickness",
1,
5,
tracerSettings.TracerThickness,
false,
function(value)
tracerSettings.TracerThickness = value
end
)
local tracer_color_toggle = sections.player_esp_section:CreateToggle("Tracer Color Picker", false, function(value) end)
sections.player_esp_section:CreateColorpicker("Tracer Color", function(color, transparency)
tracerSettings.TracerColor = color
tracerSettings.TracerTransparency = 1 - transparency
end, false, false, tracer_color_toggle)
sections.player_esp_section:CreateToggle("Enable Skeleton", skeletonSettings.Enabled, function(value)
skeletonSettings.Enabled = value
end)
sections.player_esp_section:CreateSlider(
"Skeleton Thickness",
1,
5,
skeletonSettings.SkeletonThickness,
false,
function(value)
skeletonSettings.SkeletonThickness = value
end
)
local skeleton_color_toggle = sections.player_esp_section:CreateToggle("Skeleton Color Picker", false, function(value) end)
sections.player_esp_section:CreateColorpicker("Skeleton Color", function(color, transparency)
skeletonSettings.SkeletonColor = color
skeletonSettings.SkeletonTransparency = 1 - transparency
end, false, false, skeleton_color_toggle)
local enttiyidentification = {}
for _, v in pairs(game:GetService("ReplicatedStorage").Shared.entities:GetChildren()) do
local model = v:FindFirstChild("Model")
if model and model.PrimaryPart then
enttiyidentification[v.Name] = {
CollisionGroup = model.PrimaryPart.CollisionGroup,
Material = model.PrimaryPart.Material,
Color = model.PrimaryPart.Color
}
end
end
local oreOptions = {"Stone", "Nitrate", "Iron"}
for name, _ in pairs(enttiyidentification) do
if not table.find(oreOptions, name) and name ~= "Player" and name ~= "Spawner" then
table.insert(oreOptions, name)
end
end
local function identify_model(model)
if model.ClassName ~= "Model" then
return false, false
end
local meshpart = model:FindFirstChildOfClass("MeshPart")
if meshpart and meshpart.MeshId == "rbxassetid://12939036056" then
if #model:GetChildren() == 1 then
return "Stone", model:GetChildren()[1]
else
for _, part in pairs(model:GetChildren()) do
if part.Color == Color3.fromRGB(248, 248, 248) then
return "Nitrate", part
elseif part.Color == Color3.fromRGB(199, 172, 120) then
return "Iron", part
end
end
end
end
if not model.PrimaryPart then
return false, false
end
local primpart = model.PrimaryPart
for name, entity in pairs(enttiyidentification) do
if entity.Color == primpart.Color and entity.Material == primpart.Material and entity.CollisionGroup == primpart.CollisionGroup then
return name, primpart
end
end
return false, false
end
local function create_ore_esp(model)
local espname, mainpart = identify_model(model)
if not (espname and mainpart) then
return
end
if not oreEspSettings.AllowedOres[espname] then
return
end
local NameText = Drawing.new("Text")
NameText.Visible = false
NameText.Color = oreEspSettings.NameColor
NameText.Size = oreEspSettings.NameSize
NameText.Center = true
NameText.Outline = oreEspSettings.NameOutline
NameText.OutlineColor = Color3.fromRGB(0, 0, 0)
NameText.Font = 2
NameText.Text = espname
local DistanceText = Drawing.new("Text")
DistanceText.Visible = false
DistanceText.Color = Color3.fromRGB(255, 255, 255)
DistanceText.Size = 14
DistanceText.Center = true
DistanceText.Outline = true
DistanceText.Font = 2
local Tracer = Drawing.new("Line")
Tracer.Visible = false
Tracer.Color = oreEspSettings.TracerColor
Tracer.Thickness = oreEspSettings.TracerThickness
Tracer.Transparency = oreEspSettings.TracerTransparency
local Updater = RunService.RenderStepped:Connect(function()
if not oreEspSettings.Enabled or not mainpart.Parent then
NameText.Visible = false
DistanceText.Visible = false
Tracer.Visible = false
return
end
local position3d = mainpart.Position
local position, onscreen = Workspace.CurrentCamera:WorldToViewportPoint(position3d)
if not onscreen then
NameText.Visible = false
DistanceText.Visible = false
Tracer.Visible = false
return
end
local scale_factor = 1 / (position.Z * math.tan(math.rad(workspace.CurrentCamera.FieldOfView * 0.5)) * 2) * 100
local part_size = mainpart.Size
local height = part_size.Y * scale_factor
if oreEspSettings.ShowName then
NameText.Visible = true
NameText.Position = Vector2.new(position.X, position.Y - height / 2 - NameText.TextBounds.Y / 2)
NameText.Color = oreEspSettings.NameColor
NameText.Size = oreEspSettings.NameSize
NameText.Outline = oreEspSettings.NameOutline
else
NameText.Visible = false
end
if oreEspSettings.ShowDistance then
local distance = (workspace.CurrentCamera.CFrame.Position - position3d).Magnitude
DistanceText.Visible = true
DistanceText.Text = string.format("%.1f studs", distance)
DistanceText.Position = Vector2.new(position.X, position.Y + height / 2 + 15)
else
DistanceText.Visible = false
end
if oreEspSettings.ShowTracers then
Tracer.Visible = true
local tracerStart
if oreEspSettings.TracerPosition == "Top" then
tracerStart = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 0)
elseif oreEspSettings.TracerPosition == "Middle" then
tracerStart = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
else
tracerStart = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
end
Tracer.From = tracerStart
Tracer.To = Vector2.new(position.X, position.Y)
Tracer.Color = oreEspSettings.TracerColor
Tracer.Thickness = oreEspSettings.TracerThickness
Tracer.Transparency = oreEspSettings.TracerTransparency
else
Tracer.Visible = false
end
end)
oreESPObjects[model] = {
NameText = NameText,
DistanceText = DistanceText,
Tracer = Tracer,
Updater = Updater,
espname = espname
}
end
local function destroy_ore_esp(model)
local ore_obj = oreESPObjects[model]
if ore_obj then
if ore_obj.Updater then
ore_obj.Updater:Disconnect()
end
if ore_obj.NameText then
ore_obj.NameText:Remove()
end
if ore_obj.DistanceText then
ore_obj.DistanceText:Remove()
end
if ore_obj.Tracer then
ore_obj.Tracer:Remove()
end
oreESPObjects[model] = nil
end
end
local function load_ore_esp()
if ore_loaded then return end
for _, model in pairs(Workspace:GetChildren()) do
if model:IsA("Model") then
create_ore_esp(model)
end
end
ore_connections.child_added = Workspace.ChildAdded:Connect(function(child)
if child:IsA("Model") then
create_ore_esp(child)
end
end)
ore_connections.child_removed = Workspace.ChildRemoved:Connect(function(child)
if child:IsA("Model") then
destroy_ore_esp(child)
end
end)
ore_loaded = true
end
local function unload_ore_esp()
if not ore_loaded then return end
for model, _ in pairs(oreESPObjects) do
destroy_ore_esp(model)
end
if ore_connections.child_added then
ore_connections.child_added:Disconnect()
end
if ore_connections.child_removed then
ore_connections.child_removed:Disconnect()
end
ore_loaded = false
end
local ore_esp_toggle = sections.ore_esp_section:CreateToggle("Enabled", oreEspSettings.Enabled, function(value)
oreEspSettings.Enabled = value
if value then
load_ore_esp()
else
unload_ore_esp()
end
end)
sections.ore_esp_section:CreateDropdown("Filter Ores", oreOptions, function(values)
oreEspSettings.AllowedOres = {}
for _, val in ipairs(values) do
oreEspSettings.AllowedOres[val] = true
end
unload_ore_esp()
if oreEspSettings.Enabled then
load_ore_esp()
end
end, {}, true)
sections.ore_esp_section:CreateToggle("Show Name", oreEspSettings.ShowName, function(value)
oreEspSettings.ShowName = value
end)
sections.ore_esp_section:CreateToggle("Show Distance", oreEspSettings.ShowDistance, function(value)
oreEspSettings.ShowDistance = value
end)
sections.ore_esp_section:CreateToggle("Show Tracers", oreEspSettings.ShowTracers, function(value)
oreEspSettings.ShowTracers = value
end)
sections.ore_esp_section:CreateSlider("Name Size", 10, 20, oreEspSettings.NameSize, false, function(value)
oreEspSettings.NameSize = value
for _, obj in pairs(oreESPObjects) do
if obj.NameText then
obj.NameText.Size = value
end
end
end)
sections.ore_esp_section:CreateSlider(
"Tracer Thickness",
1,
5,
oreEspSettings.TracerThickness,
false,
function(value)
oreEspSettings.TracerThickness = value
for _, obj in pairs(oreESPObjects) do
if obj.Tracer then
obj.Tracer.Thickness = value
end
end
end
)
sections.ore_esp_section:CreateToggle("Name Outline", oreEspSettings.NameOutline, function(value)
oreEspSettings.NameOutline = value
for _, obj in pairs(oreESPObjects) do
if obj.NameText then
obj.NameText.Outline = value
end
end
end)
window:Notify("Kali Hub", "https://kalihub.xyz", 15)
local cleanKeyName = tostring(config.Keybind):gsub("Enum.KeyCode.", "")
sections.settings_section:CreateLabel("Close Menu Key (PC): " .. cleanKeyName)
sections.settings_section:CreateDropdown("Change Font", stored_fonts, function(value)
window:SetFont(value)
end, "", false)
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
