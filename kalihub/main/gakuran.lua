--this shit was unobfuscated


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local function getHui()
local ok, res = pcall(function() return gethui() end)
if ok and typeof(res) == "Instance" then return res end
return LocalPlayer:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
end
local function safe(fn, ...)
local ok, res = pcall(fn, ...)
if ok then return res end
return nil
end
local function loadedModule(name)
if typeof(getloadedmodules) ~= "function" then return nil end
local ok, mods = pcall(getloadedmodules)
if not ok then return nil end
for _, m in ipairs(mods) do
if m.Name == name then return safe(require, m) end
end
return nil
end
local CombatFolder = safe(function()
return ReplicatedStorage:WaitForChild("CombatSystemClient", 10):WaitForChild("Combat", 10)
end)
local CombatConfig = safe(function()
return require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("CombatConfig"))
end)
local Remotes = safe(function() return ReplicatedStorage:WaitForChild("Remotes", 10) end)
local VIM = safe(function() return game:GetService("VirtualInputManager") end)
local CombatBroadcast = safe(function()
return require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Network"):WaitForChild("CombatBroadcast"))
end)
local movementUtils
local function getMovementUtils()
if movementUtils == nil then movementUtils = loadedModule("MovementServiceUtils") or false end
return movementUtils or nil
end
local combatAnimUtils
local function getCombatAnimUtils()
if combatAnimUtils == nil then combatAnimUtils = loadedModule("CombatAnimationUtils") or false end
return combatAnimUtils or nil
end
local movementGuard
local guardSuppressed = false
local function getMovementGuard()
if movementGuard == nil then movementGuard = loadedModule("MovementGuardClient") or false end
return movementGuard or nil
end
local function suppressMovementGuard(on)
local g = getMovementGuard()
if type(g) ~= "table" then return false end
if on then
if guardSuppressed then return true end
if type(g._step) ~= "function" then return false end
local ok = pcall(rawset, g, "_step", function() end)
guardSuppressed = ok
return ok
end
if not guardSuppressed then return false end
pcall(rawset, g, "_step", nil)
guardSuppressed = false
return true
end
local function styleOfPlayer(plr)
if not plr then return "Base" end
local U = getCombatAnimUtils()
if U and U.GetPlayerCombatStyle then
local s = safe(U.GetPlayerCombatStyle, plr)
if type(s) == "string" and s ~= "" then return s end
end
local c = plr.Character
local pd = c and c:FindFirstChild("PlayerData")
if pd then
local cs = pd:GetAttribute("CombatStyle")
if type(cs) == "string" and cs ~= "" then return cs end
local ct = pd:GetAttribute("CombatType")
if type(ct) == "string" and ct ~= "" then return ct end
end
return "Base"
end
local moduleCache = {}
local function getCombatStyleFolder()
local char = LocalPlayer.Character
local pd = char and char:FindFirstChild("PlayerData")
if pd then
local ct = pd:GetAttribute("CombatType")
if type(ct) == "string" and ct ~= "" then return ct end
end
return "Base"
end
local function getCombatModule(name)
if not CombatFolder then return nil end
local styleFolder = getCombatStyleFolder()
local key = styleFolder .. "/" .. name
if moduleCache[key] then return moduleCache[key] end
local sub = CombatFolder:FindFirstChild(styleFolder) or CombatFolder:FindFirstChild("Base")
local mod = sub and sub:FindFirstChild(name)
if not (mod and mod:IsA("ModuleScript")) then
local base = CombatFolder:FindFirstChild("Base")
mod = base and base:FindFirstChild(name)
end
if mod and mod:IsA("ModuleScript") then
local ok, res = pcall(require, mod)
if ok then moduleCache[key] = res; return res end
end
return nil
end
local function doBlock() local m = getCombatModule("Block"); if m and m.Block then safe(m.Block) end end
local function doUnblock() local m = getCombatModule("Block"); if m and m.Unblock then safe(m.Unblock) end end
local function doEvasive() local m = getCombatModule("Evasive"); if m and m.Evasive then safe(m.Evasive) end end
local function doM2() local m = getCombatModule("M2"); if m and m.OnM2Activated then safe(m.OnM2Activated) end end
local function doEquip() local m = getCombatModule("Equip"); if m and m.Equip then safe(m.Equip) end end
local function doM1Punch()
local m = getCombatModule("M1")
if m and m.Hold then
safe(m.Hold, "Start")
task.delay(0.06, function() safe(m.Hold, "Stop") end)
end
end
local function getChar(plr) return plr and plr.Character end
local function getHum(plr) local c = getChar(plr); return c and c:FindFirstChildOfClass("Humanoid") end
local function getHRP(plr) local c = getChar(plr); return c and c:FindFirstChild("HumanoidRootPart") end
local function isAlive(plr) local h = getHum(plr); return h and h.Health > 0 end
local function myHRP() return getHRP(LocalPlayer) end
local function myHum() return getHum(LocalPlayer) end
local function ping() return safe(function() return LocalPlayer:GetNetworkPing() end) or 0 end
local function equipped(char)
return char ~= nil and char:GetAttribute("Equip") == true
end
local function combatLocked(char)
return char ~= nil and (char:GetAttribute("Greenzone") == true or char:GetAttribute("RpCombatLocked") == true)
end
local function inFightMode()
local char = LocalPlayer.Character
return equipped(char) and not combatLocked(char)
end
local equipCd = 0
local function tryEquip()
local char = LocalPlayer.Character
if not (char and isAlive(LocalPlayer)) then return false end
if equipped(char) or combatLocked(char) then return false end
if os.clock() < equipCd then return false end
equipCd = os.clock() + 0.35
doEquip()
return true
end
local function styleOf(plr)
return styleOfPlayer(plr)
end
local GRAB_M2_STYLES = { kure = true, wrestling = true }
local function styleKey(plr)
local s = string.lower(styleOf(plr))
if CombatConfig and CombatConfig.NormalizeStyleKey then
local ok, n = pcall(CombatConfig.NormalizeStyleKey, s)
if ok and type(n) == "string" and n ~= "" then return n end
end
return s
end
local function isGrabM2(plr)
return GRAB_M2_STYLES[styleKey(plr)] == true
end
local function windupFor(plr, momentum)
if not CombatConfig then return 0.3 end
local style = styleKey(plr)
local ok, delay = pcall(function()
return CombatConfig.GetScaledHitboxDelay(CombatConfig.GetStyleM2HitboxDelay(style, momentum == true), 1)
end)
if ok and type(delay) == "number" then return delay end
return 0.3
end
local function windupM1For(plr, combo)
if not CombatConfig then return 0.24 end
local style = styleKey(plr)
local ok, d = pcall(function()
return CombatConfig.GetScaledStyleM1HitboxDelay(style, combo or 1, 1)
end)
if ok and type(d) == "number" then return d end
return 0.24
end
local Opt = {
AutoParry = false,
ParryMode = "Perfect Block",
ParryDistance = 22,
PingComp = 0.03,
OnlyIfFacing = true,
ParryM1 = true,
AntiParry = false,
AutoEvadeM2 = false,
AutoCounter = false, CounterLead = 0.45,
PunishRange = 16,
AutoEquip = false, AutoEquipDist = 18,
AutoPunish = false,
Whitelist = {},
NoRagdoll = false,
NoStun = false,
NoDodgeCooldown = false,
NoBlockCooldown = false,
NoAttackLockout = false,
InfStamina = false,
AutoAttack = false, AutoAttackDist = 8,
Noclip = false,
AntiRagdollFall = false,
CustomHeight = false, HeightVal = 0,
AlwaysSprint = false,
FastWalk = false, WalkVal = 24,
Fly = false, FlySpeed = 30,
FlingTime = 2,
FlingPower = 10000,
FlingLeash = 25,
FlingDir = Vector3.new(0, 1, 0),
FlingTouch = false,
AntiFling = false,
Camlock = false, CamlockDist = 60, CamlockSmooth = 0.35,
StaffAlert = true,
ESP = false,
ESPBoxes = true,
ESPNames = true,
ESPHealth = true,
ESPDist = true,
ESPTracers = false,
ESPStyle = true,
ESPTags = true,
ESPStaff = true,
ESPChams = false,
ESPHealthPercent = false,
ESPColor = Color3.fromRGB(235, 235, 235),
ESPMaxDist = 400,
AutoPlay = false,
AutoGreen = false,
PerfectShoot = false,
AutoRevive = false,
AntiAFK = false,
AutoPingComp = false,
}
local smoothPing = ping()
local avgDt = 1 / 60
local parryDebounce = setmetatable({}, { __mode = "k" })
local pendingParries = {}
local evadeCd = 0
local BLOCK_SUPPRESS_AFTER_PARRY = 0.6
local blockSuppressedUntil = 0
local blocking = false
local blockReleaseAt = 0
local lastStampAt = 0
local function doFreshBlock()
local now = os.clock()
if now - lastStampAt < 0.07 then
blocking = true
blockReleaseAt = math.max(blockReleaseAt, now + 0.21)
return
end
lastStampAt = now
local char = LocalPlayer.Character
if char and char:GetAttribute("Blocking") == true then doUnblock() end
doBlock()
blocking = true
blockReleaseAt = now + 0.15 + math.max(Opt.PingComp, 0) + 0.06
task.delay(0.07, function()
if not (blocking and Opt.AutoParry) then return end
local c = LocalPlayer.Character
if c and c:GetAttribute("Blocking") ~= true and c:GetAttribute("PerfectBlocking") ~= true then
lastStampAt = os.clock()
doBlock()
end
end)
end
local function releaseBlock()
if blocking then
doUnblock()
blocking = false
end
end
local function dashReady()
local char = LocalPlayer.Character
return os.clock() >= evadeCd and not (char and char:GetAttribute("IFRAMECD") == true)
end
local counterCd = 0
local function styleCanCounter()
if not (CombatConfig and CombatConfig.GetStyleBoolean) then return false end
local key = styleKey(LocalPlayer)
for _, flag in ipairs({ "M2GrantsIFrames", "M2GrantsHyperArmor", "M2RequiresCounterHit" }) do
local ok, v = pcall(CombatConfig.GetStyleBoolean, key, flag, false)
if ok and v == true then return true end
end
return false
end
local function counterReady(kind)
if not (Opt.AutoCounter and Opt.AutoParry) then return false end
if kind == "M2" then return false end
if os.clock() < counterCd then return false end
local char = LocalPlayer.Character
if not char then return false end
if char:GetAttribute("M2Cooldown") == true then return false end
if char:GetAttribute("CombatAttacking") == true then return false end
if char:GetAttribute("Stunned") == true or char:GetAttribute("GuardBroken") == true then return false end
if char:GetAttribute("Ragdoll") == true or char:GetAttribute("Grappling") == true then return false end
if char:GetAttribute("ParryAttackLockout") == true or char:GetAttribute("BlockAttackLockout") == true then return false end
if char:GetAttribute("GrappleWinnerStun") == true then return false end
if char:GetAttribute("CantAnything") == true and char:GetAttribute("CombatRecovery") ~= true then return false end
return styleCanCounter()
end
local function triggerParryResponse(targetPlr, kind, wantCounter)
if wantCounter then
if not counterReady(kind) then return end
counterCd = os.clock() + 0.25
releaseBlock()
doM2()
return
end
local mode = Opt.ParryMode
if Opt.AutoEvadeM2 and kind == "M2" then mode = "Evade Back" end
if kind == "M2" and isGrabM2(targetPlr) and dashReady() then mode = "Evade Back" end
if mode ~= "M1 Counter" and os.clock() < blockSuppressedUntil and dashReady() then
mode = "Evade Back"
end
if mode == "Evade Back" then
if not dashReady() then
doFreshBlock()
return
end
evadeCd = os.clock() + 0.5
doEvasive()
elseif mode == "M1 Counter" then
doM1Punch()
else
doFreshBlock()
end
end
local function windupOf(targetPlr, kind, combo, momentum)
if kind == "M1" then
return windupM1For(targetPlr, combo)
elseif kind == "M2" then
return windupFor(targetPlr, momentum)
end
return math.min(windupFor(targetPlr, false), windupM1For(targetPlr, 1))
end
local function fireParry(targetPlr, kind, wantCounter)
if not Opt.AutoParry then return end
if not (isAlive(LocalPlayer) and inFightMode()) then return end
if Opt.Whitelist[targetPlr.Name] then return end
local meHRP, hrp = myHRP(), getHRP(targetPlr)
if not (meHRP and hrp and isAlive(targetPlr)) then return end
local achar = getChar(targetPlr)
if achar and (achar:GetAttribute("Stunned") == true or achar:GetAttribute("Ragdoll") == true
or achar:GetAttribute("Downed") == true or achar:GetAttribute("GuardBroken") == true) then return end
if (hrp.Position - meHRP.Position).Magnitude > Opt.ParryDistance + 6 then return end
if Opt.OnlyIfFacing then
local dist = (hrp.Position - meHRP.Position).Magnitude
local d = hrp.CFrame.LookVector:Dot((meHRP.Position - hrp.Position).Unit)
if d < 0.15 and dist >= 7 then return end
end
triggerParryResponse(targetPlr, kind, wantCounter)
end
local function scheduleParry(targetPlr, kind, combo, momentum, elapsedHint, speedHint)
local char = getChar(targetPlr)
if not char then return end
local now = os.clock()
if parryDebounce[char] and now < parryDebounce[char] then return end
parryDebounce[char] = now + 0.12
local windup = windupOf(targetPlr, kind, combo, momentum)
if type(speedHint) == "number" and speedHint > 0.2 and speedHint < 1.05 then
windup = windup / speedHint
end
local elapsed = math.max(smoothPing, elapsedHint or 0)
elapsed = math.clamp(elapsed, 0, windup)
local wantCounter = counterReady(kind)
local lead = math.clamp(0.0325 + Opt.PingComp, 0.04, 0.105)
if wantCounter then lead = math.max(lead, Opt.CounterLead) end
local waitTime = windup - elapsed - lead
if waitTime <= avgDt * 0.5 then
fireParry(targetPlr, kind, wantCounter)
else
pendingParries[#pendingParries + 1] = { at = now + waitTime, plr = targetPlr, kind = kind, counter = wantCounter }
end
end
local function onIncomingAttack(plr, kind, combo, momentum, elapsedHint, speedHint)
if not Opt.AutoParry then return end
if kind == "M1" and not Opt.ParryM1 then return end
if Opt.Whitelist[plr.Name] then return end
local meHRP, hrp = myHRP(), getHRP(plr)
if not (meHRP and hrp and isAlive(LocalPlayer) and isAlive(plr)) then return end
if (hrp.Position - meHRP.Position).Magnitude > Opt.ParryDistance + 24 then return end
if not inFightMode() then
if Opt.AutoEquip then tryEquip() end
return
end
scheduleParry(plr, kind, combo, momentum, elapsedHint, speedHint)
end
local ATTACK_ANIMS = {}
do
local function comboFromName(n)
n = string.lower(n)
if n:find("2nd") then return 2 elseif n:find("3rd") then return 3 elseif n:find("4th") then return 4 end
return 1
end
local function classify(n)
n = string.lower(n)
if n:find("block") or n:find("hit") or n:find("evasive") or n:find("dodge") or n:find("perfect")
or n:find("guard") or n:find("stun") or n:find("ragdoll") or n:find("knock") or n:find("grab")
or n:find("grapple") or n:find("ehit") or n:find("success") or n:find("parry") then return nil end
if n:find("m2") then return "M2" end
if n:find("m1") then return "M1" end
return nil
end
local anims = ReplicatedStorage:FindFirstChild("Animations")
local roots = {}
if anims then
local bc = anims:FindFirstChild("BaseCombat"); if bc then table.insert(roots, bc) end
local cb = anims:FindFirstChild("Combat"); if cb then table.insert(roots, cb) end
end
for _, root in ipairs(roots) do
for _, d in ipairs(root:GetDescendants()) do
if d:IsA("Animation") and d.AnimationId ~= "" then
local kind = classify(d.Name)
if kind then
ATTACK_ANIMS[d.AnimationId] = {
kind = kind,
combo = comboFromName(d.Name),
momentum = string.find(string.lower(d.Name), "momentum") ~= nil,
}
end
end
end
end
end
local M2_HIGHLIGHT_NAME = "M2Highlight"
local IGNORED_HIGHLIGHT_NAMES = { IFRAMESHighlight = true, ParriedHighlight = true }
local M2_HIGHLIGHT_COLORS = {}
do
local shared = CombatConfig and CombatConfig.Shared
local colors = shared and shared.M2HighlightColors
if type(colors) == "table" then
for k, c in pairs(colors) do
if typeof(c) == "Color3" and k ~= "BoxingCounter" then M2_HIGHLIGHT_COLORS[c:ToHex()] = true end
end
end
if CombatConfig and type(CombatConfig.Styles) == "table" then
for _, st in pairs(CombatConfig.Styles) do
if type(st) == "table" then
local a, b = st.M2HighlightColor, st.HakariM2DoubleHighlightColor
if typeof(a) == "Color3" then M2_HIGHLIGHT_COLORS[a:ToHex()] = true end
if typeof(b) == "Color3" then M2_HIGHLIGHT_COLORS[b:ToHex()] = true end
end
end
end
end
local function wireAttackListener(plr)
local function onChar(char)
local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 10))
if animator then
animator.AnimationPlayed:Connect(function(track)
local a = track.Animation
local info = a and ATTACK_ANIMS[a.AnimationId]
if info then
local tpos, speed = 0, 1
pcall(function()
tpos = track.TimePosition
speed = track.Speed
end)
local elapsed = tpos / math.clamp(speed, 0.2, 1.05)
onIncomingAttack(plr, info.kind, info.combo, info.momentum, elapsed, speed)
end
end)
end
char:GetAttributeChangedSignal("CombatAttacking"):Connect(function()
if char:GetAttribute("CombatAttacking") ~= true then return end
task.delay(0.02, function()
if char:GetAttribute("CombatAttacking") == true then
onIncomingAttack(plr, nil, nil, false, 0.02)
end
end)
end)
char.ChildAdded:Connect(function(inst)
if not inst:IsA("Highlight") then return end
if IGNORED_HIGHLIGHT_NAMES[inst.Name] then return end
if inst.Name == M2_HIGHLIGHT_NAME or M2_HIGHLIGHT_COLORS[inst.FillColor:ToHex()] then
onIncomingAttack(plr, "M2", nil, false, 0)
end
end)
end
if plr.Character then task.spawn(onChar, plr.Character) end
plr.CharacterAdded:Connect(onChar)
end
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer then task.spawn(wireAttackListener, plr) end
end
Players.PlayerAdded:Connect(function(plr)
if plr ~= LocalPlayer then wireAttackListener(plr) end
end)
RunService.Heartbeat:Connect(function(dt)
avgDt = avgDt * 0.9 + dt * 0.1
smoothPing = smoothPing * 0.85 + ping() * 0.15
if #pendingParries > 0 then
local threshold = os.clock() + avgDt * 0.5
for i = #pendingParries, 1, -1 do
local e = pendingParries[i]
if e.at <= threshold then
table.remove(pendingParries, i)
fireParry(e.plr, e.kind, e.counter)
end
end
end
if blocking and os.clock() >= blockReleaseAt then releaseBlock() end
end)
LocalPlayer.CharacterAdded:Connect(function()
table.clear(pendingParries)
blocking = false
lastStampAt = 0
evadeCd = 0
blockSuppressedUntil = 0
equipCd = 0
counterCd = 0
end)
local punishCd = 0
local function faceTarget(hrp)
local meHRP = myHRP()
if not (meHRP and hrp) then return end
local from = meHRP.Position
local flat = Vector3.new(hrp.Position.X - from.X, 0, hrp.Position.Z - from.Z)
if flat.Magnitude < 0.15 then return end
meHRP.CFrame = CFrame.lookAt(from, from + flat.Unit)
end
local punishing = false
local function stopM1Hold()
local m = getCombatModule("M1")
if not (m and m.Hold) then return end
safe(m.Hold, "Stop")
task.delay(0.12, function()
local c = LocalPlayer.Character
if c and c:GetAttribute("M1Hold") == true then safe(m.Hold, "Stop") end
end)
end
local function punishInRange(plr)
local hrp, meHRP = getHRP(plr), myHRP()
if not (hrp and meHRP) then return nil end
if (hrp.Position - meHRP.Position).Magnitude > Opt.PunishRange then return nil end
return hrp
end
local function punishChain(plr, kind)
if punishing then return end
punishing = true
local function release()
safe(stopM1Hold)
punishing = false
punishCd = os.clock() + 0.25
end
task.delay(0.16, function()
local opened = safe(function()
if not (inFightMode() and isAlive(LocalPlayer) and isAlive(plr)) then return false end
local hrp = punishInRange(plr)
if not hrp then return false end
faceTarget(hrp)
if kind == "M2" and LocalPlayer.Character:GetAttribute("M2Cooldown") ~= true then
doM2()
return "heavy"
end
local m = getCombatModule("M1")
if not (m and m.Hold) then return false end
safe(m.Hold, "Start")
return "chain"
end)
if opened == "heavy" then
task.delay(0.35, function() punishing = false; punishCd = os.clock() + 0.25 end)
return
end
if opened ~= "chain" then return release() end
task.spawn(function()
local deadline = os.clock() + (kind == "M2" and 1.1 or 0.6)
while os.clock() < deadline do
task.wait(0.06)
local go = safe(function()
local myChar, achar = LocalPlayer.Character, getChar(plr)
if not (myChar and achar and isAlive(LocalPlayer) and isAlive(plr)) then return false end
if not inFightMode() then return false end
if myChar:GetAttribute("Stunned") == true or myChar:GetAttribute("Ragdoll") == true
or myChar:GetAttribute("Downed") == true or myChar:GetAttribute("GuardBroken") == true then return false end
if achar:GetAttribute("Stunned") ~= true then return false end
local h = punishInRange(plr)
if not h then return false end
faceTarget(h)
return true
end)
if go ~= true then break end
end
release()
end)
end)
end
local function onParrySuccess(attackerName, victimName, kind)
local myChar = LocalPlayer.Character
if not (myChar and victimName == myChar.Name) then return end
blockSuppressedUntil = os.clock() + BLOCK_SUPPRESS_AFTER_PARRY
blocking = false
if not (Opt.AutoPunish or Opt.AutoCounter) then return end
local plr = Players:FindFirstChild(attackerName)
if not (plr and plr ~= LocalPlayer and isAlive(plr)) then return end
if Opt.Whitelist[plr.Name] then return end
if os.clock() < punishCd then return end
punishChain(plr, kind)
end
if CombatBroadcast then
safe(function()
CombatBroadcast.On("M1PerfectBlocked", function(attacker, victim) onParrySuccess(attacker, victim, "M1") end)
CombatBroadcast.On("M2PerfectBlocked", function(attacker, victim) onParrySuccess(attacker, victim, "M2") end)
end)
end
RunService.Heartbeat:Connect(function()
if not Opt.AutoEquip then return end
local char = LocalPlayer.Character
if not (char and isAlive(LocalPlayer)) then return end
if equipped(char) or combatLocked(char) then return end
local meHRP = myHRP()
if not meHRP then return end
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and not Opt.Whitelist[plr.Name] and isAlive(plr) then
local other = getChar(plr)
local hrp = other and other:FindFirstChild("HumanoidRootPart")
if hrp and other:GetAttribute("Equip") == true
and (hrp.Position - meHRP.Position).Magnitude <= Opt.AutoEquipDist then
tryEquip()
return
end
end
end
end)
local antiParryCd = 0
RunService.Heartbeat:Connect(function()
if not Opt.AntiParry then return end
local meHRP = myHRP()
if not (meHRP and isAlive(LocalPlayer) and inFightMode()) then return end
if os.clock() < antiParryCd then return end
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and not Opt.Whitelist[plr.Name] then
local char = getChar(plr)
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if char and hrp and isAlive(plr) and char:GetAttribute("Blocking") == true then
local to = hrp.Position - meHRP.Position
if to.Magnitude <= 14 and meHRP.CFrame.LookVector:Dot(to.Unit) > 0.35 then
doM2()
antiParryCd = os.clock() + 0.6
break
end
end
end
end
end)
local m1Held = false
local m1ToggleAt = 0
RunService.Heartbeat:Connect(function()
local wantHold = false
if Opt.AutoAttack then
local meHRP = myHRP()
local myChar = LocalPlayer.Character
local parrying = blocking or (myChar and myChar:GetAttribute("Blocking") == true)
if meHRP and isAlive(LocalPlayer) and inFightMode() and not parrying then
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and not Opt.Whitelist[plr.Name] and isAlive(plr) then
local hrp = getHRP(plr)
if hrp then
local to = hrp.Position - meHRP.Position
if to.Magnitude <= Opt.AutoAttackDist and meHRP.CFrame.LookVector:Dot(to.Unit) > 0.4 then
wantHold = true
break
end
end
end
end
end
end
if wantHold ~= m1Held and os.clock() - m1ToggleAt > 0.25 then
m1Held = wantHold
m1ToggleAt = os.clock()
local m = getCombatModule("M1")
if m and m.Hold then safe(m.Hold, wantHold and "Start" or "Stop") end
end
end)
RunService.Heartbeat:Connect(function()
local char = LocalPlayer.Character
if not char then return end
if Opt.NoRagdoll then
if char:GetAttribute("Ragdoll") == true then char:SetAttribute("Ragdoll", nil) end
if char:GetAttribute("Downed") == true then char:SetAttribute("Downed", nil) end
local hum = char:FindFirstChildOfClass("Humanoid")
if hum and hum:GetState() == Enum.HumanoidStateType.Physics then
safe(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
end
end
if Opt.NoStun then
for _, a in ipairs({ "Stunned", "CantAnything", "GuardBroken" }) do
if char:GetAttribute(a) == true then char:SetAttribute(a, nil) end
end
end
if Opt.NoDodgeCooldown then
if char:GetAttribute("IFRAMECD") ~= nil then char:SetAttribute("IFRAMECD", nil) end
if char:GetAttribute("EvasiveCooldownRemaining") ~= nil then char:SetAttribute("EvasiveCooldownRemaining", nil) end
end
if Opt.NoBlockCooldown then
if char:GetAttribute("BlockCooldown") ~= nil then char:SetAttribute("BlockCooldown", nil) end
end
if Opt.NoAttackLockout then
if char:GetAttribute("ParryAttackLockout") ~= nil then char:SetAttribute("ParryAttackLockout", nil) end
end
if Opt.InfStamina then
if char:GetAttribute("Stamina") ~= nil then char:SetAttribute("Stamina", 100) end
local sv = char:FindFirstChild("Stamina")
if sv and sv:IsA("NumberValue") then sv.Value = sv.Value < 100 and 100 or sv.Value end
end
end)
local flinging = false
local RAGDOLL_STATES = {
[Enum.HumanoidStateType.Physics] = true,
[Enum.HumanoidStateType.FallingDown] = true,
[Enum.HumanoidStateType.Ragdoll] = true,
}
local noclipOff = setmetatable({}, { __mode = "k" })
local function restoreNoclip()
for p in pairs(noclipOff) do
if p.Parent then p.CanCollide = true end
noclipOff[p] = nil
end
end
local function ragdolling(char, hum)
if char:GetAttribute("Ragdoll") == true or char:GetAttribute("Downed") == true then return true end
if not hum then return false end
if RAGDOLL_STATES[hum:GetState()] then return true end
if not Opt.Fly then
if hum.PlatformStand then return true end
if hum:GetState() == Enum.HumanoidStateType.PlatformStanding then return true end
end
return false
end
RunService.Stepped:Connect(function()
local char = LocalPlayer.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not (char and hum) or flinging then
if next(noclipOff) ~= nil then restoreNoclip() end
return
end
local down = ragdolling(char, hum)
if down and Opt.AntiRagdollFall then
if next(noclipOff) ~= nil then restoreNoclip() end
for _, p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") and not p.CanCollide and p.Name ~= "HumanoidRootPart" then
p.CanCollide = true
end
end
return
end
if not Opt.Noclip or down then
if next(noclipOff) ~= nil then restoreNoclip() end
return
end
for _, p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") and p.CanCollide then
noclipOff[p] = true
p.CanCollide = false
end
end
end)
local function authorizedSpeedCap()
local mu = getMovementUtils()
local char, hum = LocalPlayer.Character, myHum()
if not (mu and char and hum) then return nil end
local ok, cap = pcall(mu.GetMaxAuthorizedMoveSpeed, char, hum)
return ok and type(cap) == "number" and cap or nil
end
RunService.Heartbeat:Connect(function()
local hum = myHum()
if not hum then return end
if Opt.CustomHeight then
if hum.HipHeight ~= Opt.HeightVal then hum.HipHeight = Opt.HeightVal end
end
if Opt.FastWalk and isAlive(LocalPlayer) then
local cap = authorizedSpeedCap()
local want = math.min(Opt.WalkVal, cap or Opt.WalkVal)
local mu = getMovementUtils()
if mu then
local ok, current = pcall(mu.GetCurrentSpeed, hum)
if not ok or math.abs((current or 0) - want) > 0.05 then safe(mu.SetSpeed, hum, want) end
elseif math.abs(hum.WalkSpeed - want) > 0.05 then
hum.WalkSpeed = want
end
end
end)
local sprintHeld = false
RunService.Heartbeat:Connect(function()
if Opt.AlwaysSprint and isAlive(LocalPlayer) then
if VIM and not sprintHeld then
safe(function() VIM:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game) end)
sprintHeld = true
end
elseif sprintHeld then
if VIM then safe(function() VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game) end) end
sprintHeld = false
end
end)
local flyVel
RunService.RenderStepped:Connect(function()
local hum, hrp = myHum(), myHRP()
if not Opt.Fly then
if flyVel then
flyVel:Destroy(); flyVel = nil
if hum then hum.PlatformStand = false end
end
return
end
if not (hum and hrp) then return end
hum.PlatformStand = true
if not flyVel or flyVel.Parent ~= hrp then
if flyVel then flyVel:Destroy() end
flyVel = Instance.new("BodyVelocity")
flyVel.MaxForce = Vector3.new(1, 1, 1) * math.huge
flyVel.P = 1e4
flyVel.Parent = hrp
end
local cam = Workspace.CurrentCamera.CFrame
local dir = Vector3.zero
if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
flyVel.Velocity = dir.Magnitude > 0 and dir.Unit * Opt.FlySpeed or Vector3.zero
end)
local camTarget
local function camlockPart(plr)
local char = getChar(plr)
if not char then return nil end
return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
end
local function camlockValid(plr)
if not (plr and plr.Parent and isAlive(plr) and not Opt.Whitelist[plr.Name]) then return false end
local part, meHRP = camlockPart(plr), myHRP()
if not (part and meHRP) then return false end
return (part.Position - meHRP.Position).Magnitude <= Opt.CamlockDist + 15
end
local function pickCamlockTarget()
local cam, meHRP = Workspace.CurrentCamera, myHRP()
if not (cam and meHRP) then return nil end
local center = cam.ViewportSize / 2
local best, bestScore
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and not Opt.Whitelist[plr.Name] and isAlive(plr) then
local part = camlockPart(plr)
if part and (part.Position - meHRP.Position).Magnitude <= Opt.CamlockDist then
local screen, onScreen = cam:WorldToViewportPoint(part.Position)
if onScreen then
local score = (Vector2.new(screen.X, screen.Y) - center).Magnitude
if not bestScore or score < bestScore then best, bestScore = plr, score end
end
end
end
end
return best
end
RunService:BindToRenderStep("KaliHubCamlock", Enum.RenderPriority.Camera.Value + 1, function()
if not (Opt.Camlock and isAlive(LocalPlayer)) then
camTarget = nil
return
end
if not camlockValid(camTarget) then camTarget = pickCamlockTarget() end
local part = camTarget and camlockPart(camTarget)
local cam = Workspace.CurrentCamera
if not (part and cam) then return end
local goal = CFrame.lookAt(cam.CFrame.Position, part.Position)
cam.CFrame = cam.CFrame:Lerp(goal, math.clamp(Opt.CamlockSmooth, 0.05, 1))
end)
local physOrig = setmetatable({}, { __mode = "k" })
local function neutralizeChar(char)
for _, p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") then
if physOrig[p] == nil then physOrig[p] = { p.Massless, p.CanCollide } end
if not p.Massless then p.Massless = true end
if p.CanCollide then p.CanCollide = false end
end
end
end
local function restorePhys(char)
for part, orig in pairs(physOrig) do
if char == nil or part:IsDescendantOf(char) then
if part.Parent then
part.Massless = orig[1]
part.CanCollide = orig[2]
end
physOrig[part] = nil
end
end
end
local function unseat(hum)
if not hum then return false end
if not (hum.Sit or hum.SeatPart) then return false end
local seat = hum.SeatPart
hum.Sit = false
if seat then safe(function() seat:Sit(nil) end) end
safe(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
for _ = 1, 30 do
if not (hum.Sit or hum.SeatPart) then return true end
RunService.Heartbeat:Wait()
end
return not (hum.Sit or hum.SeatPart)
end
local function selfPart()
local char = LocalPlayer.Character
return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end
local function flingLoop(getTarget)
if flinging then return false end
local hrp, hum = selfPart(), myHum()
if not (hrp and hum and isAlive(LocalPlayer)) then return false end
flinging = true
task.spawn(function()
local saved = hrp.CFrame
local savedRotate = hum.AutoRotate
local collideOrig = {}
local movel = 0.1
local deadline = os.clock() + Opt.FlingTime
local guarded = suppressMovementGuard(true)
local origin = nil
local function forceContact(char)
for _, p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") and not p.CanCollide then
if collideOrig[p] == nil then collideOrig[p] = false end
p.CanCollide = true
end
end
end
safe(function()
unseat(hum)
while flinging do
RunService.Heartbeat:Wait()
hrp = selfPart()
hum = myHum()
if not (hrp and hum and hum.Health > 0) then break end
if hrp.AssemblyRootPart ~= hrp then break end
local power = Opt.FlingPower
local vel = hrp.AssemblyLinearVelocity
local thrp
if getTarget then
if os.clock() >= deadline then break end
thrp = getTarget()
if not thrp then break end
origin = origin or thrp.Position
if (thrp.Position - origin).Magnitude > Opt.FlingLeash then break end
restorePhys(thrp.Parent)
forceContact(thrp.Parent)
forceContact(LocalPlayer.Character)
hum.AutoRotate = false
hrp.CFrame = thrp.CFrame
elseif not Opt.FlingTouch then
break
end
hrp.AssemblyLinearVelocity = vel * (power / 10000) + Opt.FlingDir * power
if getTarget then hrp.AssemblyAngularVelocity = Vector3.new(power, power, power) end
RunService.RenderStepped:Wait()
if hrp.Parent then
hrp.AssemblyLinearVelocity = vel
hrp.AssemblyAngularVelocity = Vector3.zero
if getTarget and thrp and thrp.Parent and origin
and (thrp.Position - origin).Magnitude <= Opt.FlingLeash then
hrp.CFrame = thrp.CFrame
end
end
RunService.Stepped:Wait()
if hrp.Parent then
hrp.AssemblyLinearVelocity = vel + Opt.FlingDir * movel
hrp.AssemblyAngularVelocity = Vector3.zero
movel = -movel
end
end
end)
safe(function()
for p in pairs(collideOrig) do
if p.Parent then p.CanCollide = false end
end
hrp = selfPart()
if hrp then
hrp.AssemblyAngularVelocity = Vector3.zero
hrp.AssemblyLinearVelocity = Vector3.zero
if getTarget then hrp.CFrame = saved end
end
local h = myHum()
if h then
h.AutoRotate = savedRotate
if h.PlatformStand then h.PlatformStand = false end
end
local char = LocalPlayer.Character
if char then
if char:GetAttribute("Ragdoll") == true then char:SetAttribute("Ragdoll", nil) end
if char:GetAttribute("Stunned") == true then char:SetAttribute("Stunned", nil) end
end
end)
if getTarget then
safe(function()
for _ = 1, 12 do
RunService.Heartbeat:Wait()
local h = selfPart()
local u = myHum()
if not h then break end
h.AssemblyLinearVelocity = Vector3.zero
h.AssemblyAngularVelocity = Vector3.zero
h.CFrame = saved
if u and u:GetState() == Enum.HumanoidStateType.Physics then
u:ChangeState(Enum.HumanoidStateType.GettingUp)
end
end
end)
end
safe(function()
local cam = Workspace.CurrentCamera
local u = myHum()
if cam and u then
cam.CameraSubject = u
cam.CameraType = Enum.CameraType.Custom
end
end)
if guarded then suppressMovementGuard(false) end
flinging = false
if Opt.FlingTouch and not getTarget then
task.delay(0.5, function()
if Opt.FlingTouch and not flinging then flingLoop(nil) end
end)
end
end)
return true
end
local function stopFling()
Opt.FlingTouch = false
while flinging do
task.wait()
end
end
local function flingPlayer(target)
if not getHRP(target) then return false end
stopFling()
return flingLoop(function() return getHRP(target) end)
end
local afSafePos = nil
local function antiFlingTick()
if not Opt.AntiFling or flinging then return end
local hrp, hum = myHRP(), myHum()
if not (hrp and hum and hum.Health > 0) then return end
local hit = false
if hrp.AssemblyAngularVelocity.Magnitude > 20 then
hrp.AssemblyAngularVelocity = Vector3.zero
hit = true
end
local v = hrp.AssemblyLinearVelocity
if v.Magnitude > 120 then
hrp.AssemblyLinearVelocity = Vector3.new(0, math.clamp(v.Y, -120, 120), 0)
hit = true
elseif v.Magnitude < 70 and hum.FloorMaterial ~= Enum.Material.Air then
afSafePos = hrp.Position
end
if not hit then return end
if hum:GetState() == Enum.HumanoidStateType.Physics then
safe(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
end
if hum.PlatformStand and not Opt.Fly then hum.PlatformStand = false end
if afSafePos and (hrp.Position - afSafePos).Magnitude > 80 then
hrp.CFrame = CFrame.new(afSafePos)
hrp.AssemblyLinearVelocity = Vector3.zero
hrp.AssemblyAngularVelocity = Vector3.zero
end
end
RunService.Stepped:Connect(antiFlingTick)
RunService.Heartbeat:Connect(antiFlingTick)
task.spawn(function()
while task.wait(0.5) do
if Opt.AntiFling and not flinging then
for _, plr in ipairs(Players:GetPlayers()) do
local char = plr ~= LocalPlayer and getChar(plr)
if char then safe(neutralizeChar, char) end
end
elseif next(physOrig) ~= nil then
restorePhys(nil)
end
end
end)
local reviveRemote = Remotes and Remotes:FindFirstChild("Revive")
task.spawn(function()
while task.wait(0.75) do
if Opt.AutoRevive and reviveRemote and reviveRemote:IsA("RemoteEvent") then
local char = LocalPlayer.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local downed = char and (char:GetAttribute("Downed") == true or char:GetAttribute("Knocked") == true)
if downed or (hum and hum.Health <= 0) then
safe(function() reviveRemote:FireServer() end)
end
end
end
end)
local VirtualUser = safe(function() return game:GetService("VirtualUser") end)
LocalPlayer.Idled:Connect(function()
if Opt.AntiAFK and VirtualUser then
safe(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)
end
end)
local rhythmService
local rhythmNextTry = 0
local session
local laneReleaseAt = {}
local function rhythmRelease(lane)
if laneReleaseAt[lane] == nil then return end
laneReleaseAt[lane] = nil
if not (session and session._lanes) then return end
safe(function()
if session._laneTouchActive then session._laneTouchActive[lane] = false end
session:_handleLaneRelease(lane)
end)
end
local function rhythmReleaseAll()
for lane in pairs(laneReleaseAt) do rhythmRelease(lane) end
end
RunService.RenderStepped:Connect(function(dt)
if not (Opt.AutoPlay or Opt.AutoGreen) then
if session then rhythmReleaseAll(); session = nil end
return
end
if not rhythmService and os.clock() >= rhythmNextTry then
rhythmNextTry = os.clock() + 1
rhythmService = loadedModule("RhythmServiceClient")
end
local live = rhythmService and rawget(rhythmService, "_session")
if live ~= session then
rhythmReleaseAll()
table.clear(laneReleaseAt)
session = live
end
if not (session and session._active and session._lanes) then return end
local now = safe(function() return session:_now() end)
if type(now) ~= "number" then return end
for lane, at in pairs(laneReleaseAt) do
if now >= at then rhythmRelease(lane) end
end
local slot = math.max(dt, 1 / 240) * 0.5
for _, note in ipairs(session._active) do
local lane = note.lane
if not note.attempted and not note.hit and type(lane) == "number"
and laneReleaseAt[lane] == nil and note.t - now <= slot then
safe(function()
if session._laneTouchActive then session._laneTouchActive[lane] = true end
session:_handleLanePress(lane)
end)
laneReleaseAt[lane] = note.t + (note.len or 0) + 0.02
end
end
end)
local mball
local mballOrigSend
local mballHooked = false
local mballNextTry = 0
local shotArmed = false
local shotSent = false
local shotSawStamp = false
local shotPrevStamp = nil
local shotDeadline = 0
local shotJitter = 0
local shotDt = 1 / 60
local function releaseShotNow()
shotArmed = false
if shotSent then return end
shotSent = true
if mball and mballOrigSend then
safe(mballOrigSend, mball, false)
end
end
local function hookMatchBasketball()
local inst = loadedModule("BasketballServiceClient")
if type(inst) ~= "table" then return end
local orig = inst._sendShoot
if type(orig) ~= "function" then return end
mball, mballOrigSend = inst, orig
rawset(inst, "_sendShoot", function(self, start)
if start then
shotArmed = Opt.PerfectShoot == true
shotSent = false
shotSawStamp = false
shotDeadline = os.clock() + 2
shotJitter = (math.random() - 0.5) * 0.004
local p = self._properties
shotPrevStamp = p and p:GetAttribute("Shooting")
return orig(self, true)
end
if shotArmed then return end
if shotSent then return end
shotSent = true
return orig(self, false)
end)
mballHooked = true
end
RunService.Heartbeat:Connect(function(dt)
shotDt = shotDt * 0.9 + dt * 0.1
if not mballHooked then
if Opt.PerfectShoot and os.clock() >= mballNextTry then
mballNextTry = os.clock() + 1
hookMatchBasketball()
end
return
end
if not shotArmed then return end
if not Opt.PerfectShoot then releaseShotNow() return end
local p = mball._properties
local s = p and p:GetAttribute("Shooting")
local t = p and p:GetAttribute("ShootTarget")
if typeof(s) == "number" and typeof(t) == "number" and t > 0 and s ~= shotPrevStamp then
shotSawStamp = true
if Workspace:GetServerTimeNow() + shotDt * 0.5 >= s + t + shotJitter then
releaseShotNow()
end
elseif shotSawStamp then
shotArmed = false
elseif os.clock() >= shotDeadline then
releaseShotNow()
end
end)
local function tpTo(cf)
local hrp = myHRP()
if hrp and cf then hrp.CFrame = cf end
end
local AreaHitboxes = Workspace:FindFirstChild("AreaHitboxes")
local LOCATIONS = {}
do
local biggest, volOf = {}, {}
for _, d in ipairs(AreaHitboxes and AreaHitboxes:GetDescendants() or {}) do
if d:IsA("BasePart") then
local vol = d.Size.X * d.Size.Y * d.Size.Z
if not biggest[d.Name] or vol > volOf[d.Name] then
biggest[d.Name], volOf[d.Name] = d, vol
end
end
end
for name, part in pairs(biggest) do LOCATIONS[#LOCATIONS + 1] = { name, part } end
table.sort(LOCATIONS, function(a, b) return a[1] < b[1] end)
end
local function locationNames()
local t = {}
for _, e in ipairs(LOCATIONS) do t[#t + 1] = e[1] end
return t
end
local function dropPoint(part)
local c, s = part.Position, part.Size
local bottom = c.Y - s.Y / 2
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = { LocalPlayer.Character, AreaHitboxes }
local floorY, anyY = nil, nil
local y = c.Y + s.Y / 2 + 2
for _ = 1, 12 do
local hit = Workspace:Raycast(Vector3.new(c.X, y, c.Z), Vector3.new(0, -(y - bottom + 8), 0), params)
if not hit then break end
if hit.Normal.Y > 0.7 then
anyY = anyY or hit.Position.Y
if hit.Position.Y >= bottom - 0.5 then floorY = hit.Position.Y end
end
y = hit.Position.Y - 0.3
if y < bottom - 8 then break end
end
return Vector3.new(c.X, (floorY or anyY or bottom) + 3, c.Z)
end
local function tpToLocation(name)
for _, e in ipairs(LOCATIONS) do
if e[1] == name and e[2].Parent then
if Workspace.StreamingEnabled then
safe(function() LocalPlayer:RequestStreamAroundAsync(e[2].Position) end)
task.wait(0.15)
end
tpTo(CFrame.new(dropPoint(e[2])))
return true
end
end
return false
end
gui_config = {
Color = Color3.fromRGB(255, 255, 255), Keybind = Enum.KeyCode.RightAlt, Assets = true,
MinHeight = 150, MaxHeight = 600, InitialHeight = 500, MinWidth = 350, MaxWidth = 800, InitialWidth = 580,
}
local config = getfenv().gui_config or nil
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local function cleanupPreviousGakuran()
if typeof(getgenv) == "function" then
for _, key in ipairs({ "GakuranWindow", "GakuranWindowV2" }) do
local prev = getgenv()[key]
if prev then
safe(function()
if typeof(prev.Destroy) == "function" then
prev:Destroy()
elseif typeof(prev.destroy) == "function" then
prev:destroy()
elseif typeof(prev.Close) == "function" then
prev:Close()
end
end)
end
getgenv()[key] = nil
end
for _, key in ipairs({ "GakuranEspCleanup", "GakuranEspCleanupV2", "GakuranGuardRestore" }) do
if getgenv()[key] then
safe(getgenv()[key])
getgenv()[key] = nil
end
end
for _, key in ipairs({
"GakuranRenderConn", "GakuranRenderConnV2",
"GakuranPlayerRemovingConn", "GakuranPlayerRemovingConnV2",
"GakuranDropdownAddedConn", "GakuranDropdownAddedConnV2",
"GakuranDropdownRemovedConn", "GakuranDropdownRemovedConnV2",
}) do
local conn = getgenv()[key]
if conn then
safe(function() conn:Disconnect() end)
getgenv()[key] = nil
end
end
end
local parent = getHui()
if parent then
for _, child in ipairs(parent:GetDescendants()) do
if child:IsA("Highlight") and child.Name == "GakuranESPChams" then
safe(function() child:Destroy() end)
end
end
for _, child in ipairs(parent:GetChildren()) do
if child:IsA("ScreenGui") then
for _, d in ipairs(child:GetDescendants()) do
if d:IsA("TextLabel") and d.Text == "Kali Hub | Gakuran" then
safe(function() child:Destroy() end)
break
end
end
end
end
end
end
cleanupPreviousGakuran()
if getgenv then
getgenv().GakuranGuardRestore = function() suppressMovementGuard(false) end
end
local window = library:CreateWindow(config, getHui())
if getgenv then getgenv().GakuranWindowV2 = window end
library:SetWindowName("Kali Hub | Gakuran")
safe(function() window:Notify("Kali Hub", "Gakuran build 08/18 loaded", 6) end)
local function playerNames(includeLocal)
local t = {}
for _, p in ipairs(Players:GetPlayers()) do
if includeLocal or p ~= LocalPlayer then table.insert(t, p.Name) end
end
table.sort(t, function(a, b) return a:lower() < b:lower() end)
return t
end
local function playerByName(n)
for _, p in ipairs(Players:GetPlayers()) do if p.Name == n then return p end end
return nil
end
local playerDropdowns = {}
local function updatePlayerDropdowns()
local names = playerNames(false)
for _, dropdown in ipairs(playerDropdowns) do
dropdown:ChangeOptions(names)
end
end
if getgenv then
getgenv().GakuranDropdownAddedConnV2 = Players.PlayerAdded:Connect(updatePlayerDropdowns)
getgenv().GakuranDropdownRemovedConnV2 = Players.PlayerRemoving:Connect(updatePlayerDropdowns)
else
Players.PlayerAdded:Connect(updatePlayerDropdowns)
Players.PlayerRemoving:Connect(updatePlayerDropdowns)
end
local STAFF_ATTRS = {
{ "IsCommandsOwnerTier", "Owner" },
{ "IsPrivateServerOwner", "Private Server Owner" },
{ "IsCommandsHeadOfStaff", "Head of Staff" },
{ "IsCommandsHeadOfLore", "Head of Lore" },
{ "IsCommandsLimitedModerator", "Moderator" },
{ "IsCommandsRestrictedModerator", "Trial Moderator" },
{ "IsCommandsContentCreatorManager","Content Creator Manager" },
{ "IsCommandsContentCreator", "Content Creator" },
{ "HasCommandsPanelAccess", "Command Panel Access" },
}
local function staffRoles(plr)
local roles = {}
for _, e in ipairs(STAFF_ATTRS) do
if plr:GetAttribute(e[1]) == true then roles[#roles + 1] = e[2] end
end
local rank = plr:GetAttribute("BillboardGroupRank")
local role = plr:GetAttribute("BillboardGroupRole")
if type(rank) == "number" and rank > 2 then
roles[#roles + 1] = string.format("Group %s (%d)", tostring(role), rank)
end
return roles
end
local staffSeen = {}
local function checkStaff(plr, announce)
if plr == LocalPlayer then return end
local roles = staffRoles(plr)
if #roles == 0 or staffSeen[plr] then return end
staffSeen[plr] = table.concat(roles, ", ")
if announce and Opt.StaffAlert then
window:Notify("Staff Detected", plr.Name .. " — " .. staffSeen[plr], 8)
end
end
local function watchStaff(plr, announce)
checkStaff(plr, announce)
plr.AttributeChanged:Connect(function() checkStaff(plr, true) end)
end
for _, plr in ipairs(Players:GetPlayers()) do watchStaff(plr, false) end
Players.PlayerAdded:Connect(function(plr) watchStaff(plr, true) end)
Players.PlayerRemoving:Connect(function(plr) staffSeen[plr] = nil end)
local drawingSupported = (function()
local ok, obj = pcall(function() return Drawing.new("Line") end)
if ok and obj then
pcall(function() obj:Remove() end)
return true
end
return false
end)()
do
local COL_WHITE = Color3.fromRGB(235, 235, 235)
local COL_STAFF = Color3.fromRGB(255, 70, 70)
local COL_ALLY = Color3.fromRGB(90, 255, 140)
local COL_TAGS = Color3.fromRGB(255, 220, 95)
local COL_M2 = Color3.fromRGB(255, 120, 40)
local RARITY_COLORS = {
basic = Color3.fromRGB(180, 180, 180),
karate = Color3.fromRGB(100, 220, 130),
muaythai = Color3.fromRGB(100, 220, 130),
slugger = Color3.fromRGB(100, 220, 130),
boxing = Color3.fromRGB(180, 110, 255),
hakari = Color3.fromRGB(180, 110, 255),
hakariother = Color3.fromRGB(180, 110, 255),
wrestling = Color3.fromRGB(255, 180, 40),
capoeira = Color3.fromRGB(255, 180, 40),
kure = Color3.fromRGB(255, 180, 40),
}
local TAG_ATTRS = {
{ "Downed", "DOWN" },
{ "GuardBroken", "GB" },
{ "Stunned", "STUN" },
{ "Ragdoll", "RAG" },
{ "Blocking", "BLOCK" },
{ "CombatAttacking", "ATK" },
}
local kits = {}
local styleCache = {}
local function newText(size, z)
local t = Drawing.new("Text")
t.Size = size
t.Center = true
t.Outline = true
t.Font = 2
t.ZIndex = z
t.Visible = false
return t
end
local function newSquare(filled, thickness, z)
local s = Drawing.new("Square")
s.Filled = filled
s.Thickness = thickness
s.ZIndex = z
s.Visible = false
return s
end
local function makeKit()
local D = {}
D.boxOut = newSquare(false, 3, 1)
D.boxOut.Color = Color3.new(0, 0, 0)
D.box = newSquare(false, 1, 2)
D.hpBack = newSquare(true, 1, 1)
D.hpBack.Color = Color3.new(0, 0, 0)
D.hpBack.Transparency = 0.5
D.hpBar = newSquare(true, 1, 2)
D.tracer = Drawing.new("Line")
D.tracer.Thickness = 1
D.tracer.ZIndex = 1
D.tracer.Visible = false
D.name = newText(13, 3)
D.dist = newText(12, 3)
D.hp = newText(12, 3)
D.style = newText(12, 3)
D.tags = newText(12, 3)
return D
end
local function hideDraw(D)
for _, d in pairs(D) do d.Visible = false end
end
local function destroyKit(plr)
local k = kits[plr]
if not k then return end
kits[plr] = nil
if k.draw then
for _, d in pairs(k.draw) do
pcall(function() d:Remove() end)
end
end
if k.cham then safe(function() k.cham:Destroy() end) end
end
local function clearAllEsp()
for plr in pairs(kits) do destroyKit(plr) end
end
local function styleInfo(plr)
local e = styleCache[plr]
if not e or os.clock() - e.at > 2 then
e = { disp = styleOf(plr), key = styleKey(plr), at = os.clock() }
styleCache[plr] = e
end
return e
end
local function chargingM2(char)
for _, inst in ipairs(char:GetChildren()) do
if inst:IsA("Highlight") and M2_HIGHLIGHT_COLORS[inst.FillColor:ToHex()] then return true end
end
return false
end
local function baseColor(plr)
if Opt.ESPStaff and staffSeen[plr] then return COL_STAFF, true end
if Opt.Whitelist[plr.Name] then return COL_ALLY, false end
return Opt.ESPColor or COL_WHITE, false
end
local conn = RunService.RenderStepped:Connect(function()
local camera = Workspace.CurrentCamera
local wantDraw = Opt.ESP and drawingSupported
local wantCham = Opt.ESPChams
if not camera or not (wantDraw or wantCham) then
if next(kits) ~= nil then clearAllEsp() end
return
end
local camPos = camera.CFrame.Position
local vp = camera.ViewportSize
local chamAllowed
if wantCham then
local eligible = {}
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer then
local char = plr.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if hum and hrp and hum.Health > 0 then
local d = (hrp.Position - camPos).Magnitude
if d <= Opt.ESPMaxDist then eligible[#eligible + 1] = { plr, d } end
end
end
end
table.sort(eligible, function(a, b) return a[2] < b[2] end)
chamAllowed = {}
for i = 1, math.min(#eligible, 31) do chamAllowed[eligible[i][1]] = true end
end
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer then
local char = plr.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local dist = hrp and (hrp.Position - camPos).Magnitude or math.huge
local show = hum ~= nil and hrp ~= nil and hum.Health > 0 and dist <= Opt.ESPMaxDist
local k = kits[plr]
if not k and show then
k = {}
kits[plr] = k
end
if k then
if wantCham and show and chamAllowed[plr] then
local col = baseColor(plr)
local cham = k.cham
if not cham then
cham = Instance.new("Highlight")
cham.Name = "GakuranESPChams"
cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
cham.FillTransparency = 0.55
cham.OutlineTransparency = 0
cham.Parent = getHui()
k.cham = cham
end
if cham.Adornee ~= char then cham.Adornee = char end
if cham.FillColor ~= col then
cham.FillColor = col
cham.OutlineColor = col
end
elseif k.cham then
safe(function() k.cham:Destroy() end)
k.cham = nil
end
if wantDraw and not k.draw then k.draw = makeKit() end
local D = k.draw
if D then
if not (wantDraw and show) then
hideDraw(D)
else
local head = char:FindFirstChild("Head")
local hip = hum.HipHeight > 0 and hum.HipHeight or 2
local topWorld = head and (head.Position + Vector3.new(0, head.Size.Y * 0.7, 0))
or (hrp.Position + Vector3.new(0, 2.6, 0))
local botWorld = hrp.Position - Vector3.new(0, hip + hrp.Size.Y * 0.5, 0)
local topP = camera:WorldToViewportPoint(topWorld)
local botP = camera:WorldToViewportPoint(botWorld)
if topP.Z <= 0 or botP.Z <= 0 then
hideDraw(D)
else
local h = math.max(botP.Y - topP.Y, 6)
local w = math.max(h * 0.55, 4)
local cx = (topP.X + botP.X) * 0.5
local x = cx - w * 0.5
local col, isStaff = baseColor(plr)
D.boxOut.Visible = Opt.ESPBoxes
D.box.Visible = Opt.ESPBoxes
if Opt.ESPBoxes then
D.boxOut.Position = Vector2.new(x, topP.Y)
D.boxOut.Size = Vector2.new(w, h)
D.box.Position = D.boxOut.Position
D.box.Size = D.boxOut.Size
D.box.Color = col
end
D.hpBack.Visible = Opt.ESPHealth
D.hpBar.Visible = Opt.ESPHealth
if Opt.ESPHealth then
local frac = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
local bh = h * frac
D.hpBack.Position = Vector2.new(x - 6, topP.Y)
D.hpBack.Size = Vector2.new(3, h)
D.hpBar.Position = Vector2.new(x - 6, topP.Y + h - bh)
D.hpBar.Size = Vector2.new(3, math.max(bh, 1))
D.hpBar.Color = Color3.fromHSV(frac * 0.32, 1, 1)
end
D.name.Visible = Opt.ESPNames
if Opt.ESPNames then
D.name.Text = isStaff and ("[STAFF] " .. plr.Name) or plr.Name
D.name.Color = col
D.name.Position = Vector2.new(cx, topP.Y - 16)
end
D.tracer.Visible = Opt.ESPTracers
if Opt.ESPTracers then
D.tracer.From = Vector2.new(vp.X * 0.5, vp.Y)
D.tracer.To = Vector2.new(cx, topP.Y + h)
D.tracer.Color = col
end
local y = topP.Y + h + 2
D.dist.Visible = Opt.ESPDist
if Opt.ESPDist then
D.dist.Text = string.format("%dm", dist)
D.dist.Color = COL_WHITE
D.dist.Position = Vector2.new(cx, y)
y += 13
end
D.hp.Visible = Opt.ESPHealthPercent
if Opt.ESPHealthPercent then
local frac = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
D.hp.Text = string.format("%d%%", math.floor(frac * 100 + 0.5))
D.hp.Color = Color3.fromHSV(frac * 0.32, 1, 1)
D.hp.Position = Vector2.new(cx, y)
y += 13
end
D.style.Visible = false
if Opt.ESPStyle then
local e = styleInfo(plr)
if e.disp ~= "" and string.lower(e.disp) ~= "base" then
D.style.Visible = true
D.style.Text = e.disp
D.style.Color = RARITY_COLORS[e.key] or COL_WHITE
D.style.Position = Vector2.new(cx, y)
y += 13
end
end
D.tags.Visible = false
if Opt.ESPTags then
local t = {}
local m2 = chargingM2(char)
if m2 then t[#t + 1] = "M2!" end
for _, e in ipairs(TAG_ATTRS) do
if char:GetAttribute(e[1]) == true then t[#t + 1] = e[2] end
end
if char:GetAttribute("Equip") == true then t[#t + 1] = "EQ" end
if #t > 0 then
D.tags.Visible = true
D.tags.Text = table.concat(t, " ")
D.tags.Color = m2 and COL_M2 or COL_TAGS
D.tags.Position = Vector2.new(cx, y)
end
end
end
end
end
end
end
end
end)
local rem = Players.PlayerRemoving:Connect(function(plr)
destroyKit(plr)
styleCache[plr] = nil
end)
if getgenv then
getgenv().GakuranRenderConnV2 = conn
getgenv().GakuranPlayerRemovingConnV2 = rem
getgenv().GakuranEspCleanupV2 = clearAllEsp
end
end
local deps = {}
local function showDeps(key, v)
for _, w in ipairs(deps[key] or {}) do
if w then safe(w.SetVisible, w, v) end
end
end
local function addDep(key, widget)
local t = deps[key]
if not t then t = {}; deps[key] = t end
t[#t + 1] = widget
safe(widget.SetVisible, widget, false)
return widget
end
local mainTab = window:CreateTab("Main")
local parrySec = mainTab:CreateSection("Auto Parry", "left")
local netLabel = parrySec:CreateLabel("Ping: -- ms  |  FPS: --")
do
local frames, elapsed = 0, 0
RunService.RenderStepped:Connect(function(dt)
frames += 1
elapsed += dt
if elapsed < 0.5 then return end
local fps = math.floor(frames / elapsed + 0.5)
frames, elapsed = 0, 0
local ms = math.clamp(math.round(smoothPing * 1000), 0, 9999)
if Opt.AutoPingComp then Opt.PingComp = math.clamp(smoothPing, 0, 0.2) end
local text = string.format("Ping: %d ms  |  FPS: %d", ms, fps)
if Opt.AutoPingComp then
text = text .. string.format("  |  Comp: %d ms", math.round(Opt.PingComp * 1000))
end
safe(netLabel.UpdateText, netLabel, text)
end)
end
parrySec:CreateToggle("Auto Parry", false, function(v)
Opt.AutoParry = v
showDeps("parry", v)
end)
addDep("parry", parrySec:CreateDropdown("Response", { "Perfect Block", "Evade Back", "M1 Counter" }, function(v)
Opt.ParryMode = v
end, "Perfect Block", false))
addDep("parry", parrySec:CreateSlider("Parry Distance", 5, 60, 22, false, function(v) Opt.ParryDistance = v end))
addDep("parry", parrySec:CreateSlider("Ping Compensation (ms)", 0, 200, 30, false, function(v)
if not Opt.AutoPingComp then Opt.PingComp = v / 1000 end
end))
parrySec:CreateToggle("Auto Ping Compensation", false, function(v) Opt.AutoPingComp = v end)
parrySec:CreateToggle("Only If Facing Me", true, function(v) Opt.OnlyIfFacing = v end)
parrySec:CreateToggle("Parry M1 Attacks", true, function(v) Opt.ParryM1 = v end)
parrySec:CreateToggle("Auto Evade Charged (M2)", false, function(v) Opt.AutoEvadeM2 = v end)
parrySec:CreateToggle("Auto Counter", false, function(v)
Opt.AutoCounter = v
showDeps("counter", v)
if not v then return end
if styleCanCounter() then
window:Notify("Auto Counter", "Armored heavy available - countering M1s with R", 5)
else
window:Notify("Auto Counter", "No armored heavy on this style - parry into punish chain instead", 5)
end
end)
addDep("counter", parrySec:CreateSlider("Counter Lead (ms)", 0, 600, 450, false, function(v) Opt.CounterLead = v / 1000 end))
parrySec:CreateToggle("Auto Punish After Parry", false, function(v)
Opt.AutoPunish = v
showDeps("punish", v)
end)
addDep("punish", parrySec:CreateSlider("Punish Range", 6, 30, 16, false, function(v) Opt.PunishRange = v end))
parrySec:CreateToggle("Auto Guardbreak", false, function(v) Opt.AntiParry = v end)
parrySec:CreateToggle("Auto Equip Near Enemies", false, function(v)
Opt.AutoEquip = v
showDeps("equip", v)
end)
addDep("equip", parrySec:CreateSlider("Auto Equip Range", 6, 40, 18, false, function(v) Opt.AutoEquipDist = v end))
local wlSel = {}
local wlDrop = parrySec:CreateDropdown("Whitelist (allies)", playerNames(false), function(v)
if type(v) == "string" and playerByName(v) then wlSel[v] = wlSel[v] and nil or true end
end, nil, true)
playerDropdowns[#playerDropdowns + 1] = wlDrop
parrySec:CreateButton("Add Selected To Whitelist", function()
for n in pairs(wlSel) do Opt.Whitelist[n] = true end
window:Notify("Auto Parry", "Whitelist updated", 3)
end)
parrySec:CreateButton("Clear Whitelist", function()
Opt.Whitelist = {}
window:Notify("Auto Parry", "Whitelist cleared", 3)
end)
parrySec:CreateButton("Refresh Players", function()
wlDrop:ChangeOptions(playerNames(false))
end)
local stateSec = mainTab:CreateSection("Combat State", "left")
stateSec:CreateToggle("No Ragdoll", false, function(v) Opt.NoRagdoll = v end)
stateSec:CreateToggle("No Stun", false, function(v) Opt.NoStun = v end)
stateSec:CreateToggle("No Dodge Cooldown", false, function(v) Opt.NoDodgeCooldown = v end)
stateSec:CreateToggle("No Block Cooldown", false, function(v) Opt.NoBlockCooldown = v end)
stateSec:CreateToggle("No Attack Lockout", false, function(v) Opt.NoAttackLockout = v end)
stateSec:CreateToggle("Infinite Stamina", false, function(v) Opt.InfStamina = v end)
local moveSec = mainTab:CreateSection("Movement", "left")
moveSec:CreateToggle("Noclip", false, function(v) Opt.Noclip = v end)
moveSec:CreateToggle("Anti Ragdoll Fall", false, function(v) Opt.AntiRagdollFall = v end)
moveSec:CreateToggle("Always Sprint", false, function(v) Opt.AlwaysSprint = v end)
moveSec:CreateToggle("Fast Walk", false, function(v)
Opt.FastWalk = v
showDeps("fastwalk", v)
end)
addDep("fastwalk", moveSec:CreateSlider("Walk Speed", 12, 30, 24, false, function(v) Opt.WalkVal = v end))
moveSec:CreateToggle("Custom Height", false, function(v)
Opt.CustomHeight = v
showDeps("height", v)
end)
addDep("height", moveSec:CreateSlider("Height (HipHeight)", 0, 10, 0, true, function(v) Opt.HeightVal = v end))
moveSec:CreateToggle("Fly", false, function(v)
Opt.Fly = v
showDeps("fly", v)
end)
addDep("fly", moveSec:CreateSlider("Fly Speed", 0, 30, 30, true, function(v) Opt.FlySpeed = v end))
moveSec:CreateToggle("Anti Fling", false, function(v) Opt.AntiFling = v end)
local basketSec = mainTab:CreateSection("Basket", "left")
basketSec:CreateToggle("Perfect Shoot", false, function(v) Opt.PerfectShoot = v end)
local autoSec = mainTab:CreateSection("Automation", "right")
autoSec:CreateToggle("Auto Attack", false, function(v)
Opt.AutoAttack = v
showDeps("autoattack", v)
end)
addDep("autoattack", autoSec:CreateSlider("Auto Attack Range", 4, 16, 8, false, function(v) Opt.AutoAttackDist = v end))
autoSec:CreateToggle("Auto Play", false, function(v) Opt.AutoPlay = v end)
autoSec:CreateToggle("Auto Perfect", false, function(v) Opt.AutoGreen = v end)
autoSec:CreateToggle("Auto Revive", false, function(v) Opt.AutoRevive = v end)
autoSec:CreateToggle("Anti AFK", false, function(v) Opt.AntiAFK = v end)
local tpSec = mainTab:CreateSection("Teleport", "right")
local tpTarget = nil
local tpDrop = tpSec:CreateDropdown("Player", playerNames(false), function(v)
if type(v) == "string" and playerByName(v) then tpTarget = v end
end, nil, false)
playerDropdowns[#playerDropdowns + 1] = tpDrop
tpSec:CreateButton("Teleport To Player", function()
local p = playerByName(tpTarget)
local hrp = p and getHRP(p)
if hrp then tpTo(hrp.CFrame * CFrame.new(0, 0, 3)) else window:Notify("Teleport", "No target", 3) end
end)
tpSec:CreateButton("Refresh Players", function() tpDrop:ChangeOptions(playerNames(false)) end)
local locTarget = LOCATIONS[1] and LOCATIONS[1][1]
local locDrop = tpSec:CreateDropdown("Location", locationNames(), function(v)
if type(v) == "string" then locTarget = v end
end, locTarget, false)
tpSec:CreateButton("Teleport To Location", function()
if not tpToLocation(locTarget) then window:Notify("Teleport", "Unknown location", 3) end
end)
do
local DIRS = {
{ "Up", Vector3.new(0, 1, 0) },
{ "Down", Vector3.new(0, -1, 0) },
{ "Left", Vector3.new(-1, 0, 0) },
{ "Right", Vector3.new(1, 0, 0) },
{ "Up Left", Vector3.new(-1, 1, 0) },
{ "Up Right", Vector3.new(1, 1, 0) },
{ "Down Left", Vector3.new(-1, -1, 0) },
{ "Down Right", Vector3.new(1, -1, 0) },
}
local names = {}
for _, e in ipairs(DIRS) do names[#names + 1] = e[1] end
local flingSec = mainTab:CreateSection("Fling", "right")
local flingTarget = nil
local flingDrop = flingSec:CreateDropdown("Target", playerNames(false), function(v)
if type(v) == "string" and playerByName(v) then flingTarget = v end
end, nil, false)
playerDropdowns[#playerDropdowns + 1] = flingDrop
flingSec:CreateSlider("Fling Duration (s)", 1, 10, 2, true, function(v) Opt.FlingTime = v end)
flingSec:CreateSlider("Fling Power", 5000, 200000, 10000, false, function(v) Opt.FlingPower = v end)
flingSec:CreateSlider("Follow Leash (studs)", 10, 150, 25, false, function(v) Opt.FlingLeash = v end)
flingSec:CreateDropdown("Direction", names, function(v)
for _, e in ipairs(DIRS) do
if e[1] == v then Opt.FlingDir = e[2] return end
end
end, "Up", false)
flingSec:CreateButton("Fling Selected", function()
local p = playerByName(flingTarget)
if not p then
window:Notify("Fling", "Select a target first", 3)
else
if Opt.FlingTouch and flinging then
Opt.FlingTouch = false
flinging = false
task.wait()
end
if not flingPlayer(p) then
window:Notify("Fling", "Could not start fling", 3)
end
end
end)
flingSec:CreateToggle("Touch Fling", false, function(v)
if v and flinging then
Opt.FlingTouch = false
flinging = false
task.wait()
end
Opt.FlingTouch = v
if v then flingLoop(nil) end
end)
flingSec:CreateButton("Refresh Players", function() flingDrop:ChangeOptions(playerNames(false)) end)
end
local staffSec = mainTab:CreateSection("Staff", "right")
staffSec:CreateToggle("Staff Join Alerts", true, function(v) Opt.StaffAlert = v end)
staffSec:CreateButton("List Staff In Server", function()
local found = {}
for _, plr in ipairs(Players:GetPlayers()) do
local roles = staffRoles(plr)
if #roles > 0 then found[#found + 1] = plr.Name .. " (" .. table.concat(roles, ", ") .. ")" end
end
window:Notify("Staff", #found > 0 and table.concat(found, "\n") or "No staff in this server", 8)
end)
local aimSec = mainTab:CreateSection("Aim", "right")
aimSec:CreateToggle("Camlock", false, function(v)
Opt.Camlock = v
showDeps("camlock", v)
end)
addDep("camlock", aimSec:CreateSlider("Camlock Range", 10, 200, 60, false, function(v) Opt.CamlockDist = v end))
addDep("camlock", aimSec:CreateSlider("Camlock Smoothness", 5, 100, 35, false, function(v) Opt.CamlockSmooth = v / 100 end))
do
local visualsTab = window:CreateTab("Visuals")
local espSec = visualsTab:CreateSection("ESP", "left")
espSec:CreateToggle("Enabled", false, function(v)
Opt.ESP = v
showDeps("esp", v)
if v and not drawingSupported then
window:Notify("ESP", "Drawing API not available on this executor", 5)
end
end)
espSec:CreateToggle("Boxes", true, function(v) Opt.ESPBoxes = v end)
espSec:CreateToggle("Names", true, function(v) Opt.ESPNames = v end)
espSec:CreateToggle("Health Bar", true, function(v) Opt.ESPHealth = v end)
espSec:CreateToggle("Distance", true, function(v) Opt.ESPDist = v end)
espSec:CreateToggle("Tracers", false, function(v) Opt.ESPTracers = v end)
addDep("esp", espSec:CreateSlider("Max Distance", 50, 1000, 400, false, function(v) Opt.ESPMaxDist = v end))
addDep("esp", espSec:CreateColorpicker("ESP Color", function(c)
if typeof(c) == "Color3" then Opt.ESPColor = c end
end, false, false))
local infoSec = visualsTab:CreateSection("Player Info", "right")
infoSec:CreateToggle("Health %", false, function(v) Opt.ESPHealthPercent = v end)
infoSec:CreateToggle("Fighting Style", true, function(v) Opt.ESPStyle = v end)
infoSec:CreateToggle("Combat State Tags", true, function(v) Opt.ESPTags = v end)
infoSec:CreateToggle("Staff Highlight", true, function(v) Opt.ESPStaff = v end)
local chamSec = visualsTab:CreateSection("Chams", "right")
chamSec:CreateToggle("Chams", false, function(v) Opt.ESPChams = v end)
end
local configTab = window:CreateTab("Config")
safe(function()
local ConfigManager = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
ConfigManager:SetLibrary(library)
ConfigManager:SetWindow(window)
ConfigManager:SetFolder("Kali Hub/Gakuran")
ConfigManager:BuildConfigSection(configTab)
ConfigManager:LoadAutoloadConfig()
end)
pcall(function()
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
end)
