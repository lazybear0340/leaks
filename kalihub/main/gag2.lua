--this shit was unobfuscated


gui_config = {
Color = Color3.fromRGB(255, 255, 255),
Keybind = Enum.KeyCode.RightAlt,
Assets = true,
MinHeight = 120,
MaxHeight = 640,
InitialHeight = 500,
MinWidth = 320,
MaxWidth = 820,
InitialWidth = 560,
}
local config = (getfenv().gui_config) or nil
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(config, (gethui and gethui()) or game:GetService("CoreGui"))
library:SetWindowName("Kali Hub | Grow a Garden 2")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer
local SharedModules = ReplicatedStorage:WaitForChild("SharedModules")
local net = require(SharedModules:WaitForChild("Networking"))
local Assets = ReplicatedStorage:WaitForChild("Assets")
local GardensF = Workspace:WaitForChild("Gardens")
local NightVal = ReplicatedStorage:FindFirstChild("Night")
local function fire(packet, ...)
if not packet then return end
local args = table.pack(...)
local ok, res = pcall(function()
return packet:Fire(table.unpack(args, 1, args.n))
end)
if ok then return res end
end
local function netPath(...)
local node = net
for _, key in ipairs({ ... }) do
if type(node) ~= "table" then return nil end
node = node[key]
if node == nil then return nil end
end
return node
end
local function namesFromFolder(folder)
local t = {}
if folder then
for _, c in ipairs(folder:GetChildren()) do
t[#t + 1] = c.Name
end
table.sort(t)
end
return t
end
local function multiToList(value)
if type(value) ~= "table" then return tostring(value or "") end
local parts = {}
for k, v in pairs(value) do
if type(v) == "string" then parts[#parts + 1] = v
elseif v == true and type(k) == "string" then parts[#parts + 1] = k end
end
return table.concat(parts, ",")
end
local function splitList(str)
local t = {}
if str then
for raw in string.gmatch(str, "([^,]+)") do
local v = raw:gsub("^%s+", ""):gsub("%s+$", "")
if v ~= "" then t[#t + 1] = v end
end
end
return t
end
local function setFromList(str)
local s = {}
for _, v in ipairs(splitList(str)) do s[v] = true end
return next(s) and s or nil
end
local function parseFilter(str)
if not str or str:gsub("%s", "") == "" then return nil end
local set = {}
for raw in string.gmatch(str, "([^,]+)") do
local v = raw:gsub("^%s+", ""):gsub("%s+$", ""):lower()
if v ~= "" then set[v] = true end
end
return next(set) and set or nil
end
local state = {
autoHarvest = false,
harvestTP = false,
harvestCrops = "",
harvestMuts = false,
autoSell = false,
sellInterval = 30,
sellOnFull = false,
sellCap = 200,
autoPlant = false,
plantSeeds = "",
plantSpacing = 6,
plantPerCycle = 40,
plantDelay = 0.12,
plantLoop = 1.0,
plantReserve = 0,
autoBuySeeds = false,
antiSteal = false,
antiShovel = false,
autoSteal = false,
stealReturn = true,
stealMult = 1,
autoExpand = false,
autoPetSlots = false,
petSlotCap = 10,
managePets = false,
petList = "",
autoEgg = false,
eggName = "",
autoCrate = false,
crateName = "",
autoPack = false,
packName = "",
autoBuyGear = false,
gearList = "",
autoBuyCrate = false,
crateBuyName = "",
autoDaily = false,
codeList = "",
seedFilter = "",
mutationFilter = "",
walkEnabled = false, walkSpeed = 16,
jumpEnabled = false, jumpPower = 50,
infJump = false,
noclip = false,
fly = false, flySpeed = 60,
antiAfk = true,
optimize = false,
hlReady = false,
hlRare = false,
webhookUrl = "",
whRareSeed = false,
whBigHarvest = false,
bigHarvestMin = 25,
autoHopRare = false,
}
local function getRoot()
local c = lp.Character
return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
local c = lp.Character
return c and c:FindFirstChildOfClass("Humanoid")
end
local function getMyPlot()
local pid = lp:GetAttribute("PlotId")
if pid then
local plot = GardensF:FindFirstChild("Plot" .. tostring(pid))
if plot then return plot end
end
for _, m in ipairs(GardensF:GetChildren()) do
if m:GetAttribute("OwnerUserId") == lp.UserId then return m end
end
return nil
end
local function getOwningPlot(inst)
local node = inst
while node and node ~= GardensF do
if node.Parent == GardensF then return node end
node = node.Parent
end
return nil
end
local function tpTo(pos, tween)
local root = getRoot()
if not root then return end
local goal = CFrame.new(pos + Vector3.new(0, 3, 0))
if tween then
TweenService:Create(root, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { CFrame = goal }):Play()
task.wait(0.22)
else
root.CFrame = goal
end
end
local function isNight()
return NightVal and NightVal.Value == true
end
local PSC, RC
task.spawn(function()
pcall(function() PSC = require(ReplicatedStorage.ClientModules.PlayerStateClient) end)
end)
task.spawn(function()
pcall(function() RC = require(ReplicatedStorage.ClientModules.ReplicaClient) end)
end)
local function getReplica()
if PSC then
local ok, r = pcall(function() return PSC:GetLocalReplica() end)
if ok and r then return r end
end
if RC and RC.Test then
local ok3, test = pcall(function() return RC.Test() end)
if ok3 and test and test.Replicas then
for _, rep in pairs(test.Replicas) do
if type(rep) == "table" and rep.Data and rep.Data.Inventory then return rep end
end
end
end
return nil
end
local function getData()
local r = getReplica()
return r and r.Data or nil
end
local function seedCount(name)
local d = getData()
if d and d.Inventory and d.Inventory.Seeds then
local s = d.Inventory.Seeds[name]
if type(s) == "number" then return s end
if type(s) == "table" then return tonumber(s.Count or s.Amount) end
end
return nil
end
local function ownedSeedNames()
local out, seen = {}, {}
local d = getData()
if d and d.Inventory and d.Inventory.Seeds then
for n, c in pairs(d.Inventory.Seeds) do
local cnt = (type(c) == "number" and c) or (type(c) == "table" and (c.Count or c.Amount)) or 0
if cnt and cnt > 0 and not seen[n] then seen[n] = true; out[#out + 1] = n end
end
end
if #out == 0 then
local function scan(cont)
if not cont then return end
for _, t in ipairs(cont:GetChildren()) do
if t:IsA("Tool") and t:GetAttribute("SeedTool") ~= nil then
local nm = tostring(t:GetAttribute("SeedTool"))
if not seen[nm] then seen[nm] = true; out[#out + 1] = nm end
end
end
end
scan(lp.Character); scan(lp:FindFirstChildOfClass("Backpack"))
end
return out
end
local function promptModel(prompt)
local p = prompt.Parent
return p and p:FindFirstAncestorWhichIsA("Model")
end
local function cropName(model)
return model:GetAttribute("SeedName") or model:GetAttribute("CorePartName")
end
local function getHarvestTargets()
local cropFilter = setFromList(state.harvestCrops)
local out = {}
for _, prompt in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
if prompt:IsDescendantOf(Workspace) and prompt.Enabled then
local model = promptModel(prompt)
if model then
local plantId = model:GetAttribute("PlantId")
local plot = getOwningPlot(model)
local mine = plot and plot:GetAttribute("OwnerUserId") == lp.UserId
if plantId and mine then
local okCrop = (not cropFilter) or (cropName(model) and cropFilter[cropName(model)] == true)
local okMut = (not state.harvestMuts) or (model:GetAttribute("Mutation") ~= nil)
if okCrop and okMut then
out[#out + 1] = {
model = model,
plantId = plantId,
fruitId = model:GetAttribute("FruitId") or "",
}
end
end
end
end
end
return out
end
local function fruitInInventory()
local n = 0
local function scan(cont)
if not cont then return end
for _, t in ipairs(cont:GetChildren()) do
if t:IsA("Tool") and (t:GetAttribute("HarvestedFruit") or t:GetAttribute("Fruit")
or t:GetAttribute("FruitId") or t:GetAttribute("PlantId")) then
n = n + 1
end
end
end
scan(lp.Character); scan(lp:FindFirstChildOfClass("Backpack"))
return n
end
local lastBigHarvest = 0
local sendWebhook
task.spawn(function()
while true do
RunService.Heartbeat:Wait()
if state.autoHarvest or state.antiSteal then
pcall(function()
local picked = 0
for _, t in ipairs(getHarvestTargets()) do
if state.harvestTP and state.autoHarvest then
local part = t.model.PrimaryPart or t.model:FindFirstChildWhichIsA("BasePart")
if part then tpTo(part.Position, false) end
end
net.Garden.CollectFruit:Fire(t.plantId, t.fruitId)
picked = picked + 1
end
if state.whBigHarvest and picked >= state.bigHarvestMin and (os.clock() - lastBigHarvest) > 5 then
lastBigHarvest = os.clock()
if sendWebhook then
sendWebhook(("Big harvest: collected **%d** fruit in one pass."):format(picked))
end
end
end)
else
task.wait(0.2)
end
end
end)
task.spawn(function()
local last = 0
while true do
task.wait(1)
if state.autoSell and (os.clock() - last) >= state.sellInterval then
last = os.clock()
fire(net.NPCS.SellAll)
elseif state.sellOnFull and fruitInInventory() >= state.sellCap then
fire(net.NPCS.SellAll)
task.wait(2)
end
end
end)
local function getSeedTool(wanted)
wanted = (wanted and wanted ~= "") and wanted:lower() or nil
local function scan(container)
if not container then return end
for _, tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and tool:GetAttribute("SeedTool") ~= nil then
local seedName = tostring(tool:GetAttribute("SeedTool"))
if not wanted or seedName:lower() == wanted then
return tool, seedName
end
end
end
end
local t, n = scan(lp.Character)
if t then return t, n, true end
t, n = scan(lp:FindFirstChildOfClass("Backpack"))
return t, n, false
end
local function getPlantRegion(plot)
local ref = plot:FindFirstChild("PlotSizeReference") or plot:FindFirstChild("SizeReference")
if ref and ref:IsA("BasePart") then
return ref.CFrame * CFrame.new(0, ref.Size.Y * 0.5, 0), Vector2.new(ref.Size.X * 0.5, ref.Size.Z * 0.5)
end
local areas = {}
for _, p in ipairs(CollectionService:GetTagged("PlantArea")) do
if p:IsA("BasePart") and p:IsDescendantOf(plot) then areas[#areas + 1] = p end
end
if #areas > 0 then
table.sort(areas, function(a, b) return (a.Size.X * a.Size.Z) > (b.Size.X * b.Size.Z) end)
local a = areas[1]
return a.CFrame * CFrame.new(0, a.Size.Y * 0.5, 0), Vector2.new(a.Size.X * 0.5, a.Size.Z * 0.5)
end
local ok, cf, size = pcall(function() return plot:GetBoundingBox() end)
if ok and cf and size then
return cf * CFrame.new(0, size.Y * 0.5, 0), Vector2.new(size.X * 0.45, size.Z * 0.45)
end
return nil
end
local function gridPositions(plot, spacing)
local topCF, half = getPlantRegion(plot)
if not topCF then return {} end
spacing = math.max(2, spacing or 6)
local out = {}
local mx = math.max(0, half.X - spacing * 0.5)
local mz = math.max(0, half.Y - spacing * 0.5)
local x = -mx
while x <= mx + 0.001 do
local z = -mz
while z <= mz + 0.001 do
out[#out + 1] = (topCF * CFrame.new(x, 0, z)).Position
z = z + spacing
end
x = x + spacing
end
return out
end
local function occupiedPositions(plot)
local out = {}
local plants = plot:FindFirstChild("Plants")
if plants then
for _, pl in ipairs(plants:GetChildren()) do
local ok, pivot = pcall(function() return pl:GetPivot().Position end)
if ok and pivot then out[#out + 1] = pivot end
end
end
return out
end
local function cellTaken(pos, occ, radius)
for _, o in ipairs(occ) do
if (Vector3.new(o.X, 0, o.Z) - Vector3.new(pos.X, 0, pos.Z)).Magnitude < radius then return true end
end
return false
end
task.spawn(function()
while true do
task.wait(state.plantLoop)
if state.autoPlant then
pcall(function()
local plot = getMyPlot()
if not plot then return end
local cells = gridPositions(plot, state.plantSpacing)
if #cells == 0 then return end
local occ = occupiedPositions(plot)
local empty = {}
for _, pos in ipairs(cells) do
if not cellTaken(pos, occ, state.plantSpacing * 0.55) then empty[#empty + 1] = pos end
end
if #empty == 0 then return end
local wanted = splitList(state.plantSeeds)
if #wanted == 0 then wanted = ownedSeedNames() end
if #wanted == 0 then return end
local hum = getHum()
local planted, idx = 0, 1
for _, seedName in ipairs(wanted) do
if planted >= state.plantPerCycle then break end
local tool, realName, equipped = getSeedTool(seedName)
if tool then
if not equipped and hum then hum:EquipTool(tool); task.wait(0.1) end
local have = seedCount(realName or seedName)
local budget = have and (have - state.plantReserve) or math.huge
while planted < state.plantPerCycle and budget > 0 and idx <= #empty do
local pos = empty[idx]; idx = idx + 1
net.Plant.PlantSeed:Fire(pos, realName or seedName, tool)
planted = planted + 1
budget = budget - 1
task.wait(state.plantDelay)
end
end
end
end)
end
end
end)
task.spawn(function()
local stockItems = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("SeedShop"):WaitForChild("Items")
while true do
task.wait(2)
if state.autoBuySeeds then
pcall(function()
local filter = parseFilter(state.seedFilter)
for _, v in ipairs(stockItems:GetChildren()) do
local stock = (v:IsA("ValueBase") and v.Value) or v:GetAttribute("Stock") or 0
local allow = (not filter) or filter[v.Name:lower()] == true
if allow and stock and stock > 0 then
net.SeedShop.PurchaseSeed:Fire(v.Name)
task.wait(0.1)
end
end
end)
end
end
end)
local function getStealTargets()
local out = {}
local mutFilter = parseFilter(state.mutationFilter)
for _, prompt in ipairs(CollectionService:GetTagged("StealPrompt")) do
if prompt:IsDescendantOf(Workspace) and prompt.Enabled then
local model = promptModel(prompt)
if model then
local plantId = model:GetAttribute("PlantId")
local plot = getOwningPlot(model)
local ownerId = plot and plot:GetAttribute("OwnerUserId")
if plantId and ownerId and ownerId ~= lp.UserId then
local ok = true
if mutFilter then
local mut = tostring(model:GetAttribute("Mutation") or ""):lower()
ok = mutFilter[mut] == true
end
if ok then
out[#out + 1] = {
model = model,
plantId = plantId,
fruitId = model:GetAttribute("FruitId") or "",
ownerId = ownerId,
hold = prompt.HoldDuration or 0,
}
end
end
end
end
end
return out
end
task.spawn(function()
while true do
task.wait(0.5)
if state.autoSteal and isNight() then
pcall(function()
local home = getRoot() and getRoot().Position
for _, t in ipairs(getStealTargets()) do
if not (state.autoSteal and isNight()) then break end
local part = t.model.PrimaryPart or t.model:FindFirstChildWhichIsA("BasePart")
if part then tpTo(part.Position, false) end
net.Steal.BeginSteal:Fire(t.ownerId, t.plantId, t.fruitId)
task.wait(math.max(0.15, (t.hold or 0) + 0.1))
for _ = 1, math.max(1, math.floor(state.stealMult)) do
net.Steal.CompleteSteal:Fire()
end
task.wait(0.05)
end
if state.stealReturn and home then tpTo(home, false) end
end)
end
end
end)
do
pcall(function()
if net.Ragdoll and net.Ragdoll.StartRagdoll then
net.Ragdoll.StartRagdoll.OnClientEvent:Connect(function()
if state.antiShovel then
fire(net.ShovelFX and net.ShovelFX.RagdollRecover)
fire(net.Ragdoll and net.Ragdoll.Disable)
end
end)
end
end)
task.spawn(function()
while true do
RunService.Heartbeat:Wait()
if state.antiShovel then
pcall(function()
local hum, char = getHum(), lp.Character
if hum and char then
local ragged = char:GetAttribute("Ragdolled") or char:GetAttribute("Ragdoll")
or hum:GetState() == Enum.HumanoidStateType.Physics
if ragged then
fire(net.ShovelFX and net.ShovelFX.RagdollRecover)
fire(net.Ragdoll and net.Ragdoll.Disable)
hum:ChangeState(Enum.HumanoidStateType.GettingUp)
end
end
end)
else
task.wait(0.2)
end
end
end)
end
task.spawn(function()
while true do
task.wait(1.5)
if state.autoExpand then
local ok = fire(net.Actions.ExpandGarden)
if ok == false then task.wait(8) end
end
end
end)
task.spawn(function()
while true do
task.wait(2)
if state.autoPetSlots then
pcall(function()
local equipped = fire(net.Pets.GetEquippedPets)
local slots = (type(equipped) == "table" and equipped.MaxSlots) or nil
if not slots or slots < state.petSlotCap then
net.Pets.RequestPurchasePetSlot:Fire()
end
end)
end
end
end)
task.spawn(function()
while true do
task.wait(3)
if state.managePets then
pcall(function()
for _, name in ipairs(splitList(state.petList)) do
net.Pets.RequestEquipByName:Fire(name)
task.wait(0.15)
end
end)
end
end
end)
task.spawn(function()
while true do
task.wait(1)
if state.autoEgg and state.eggName ~= "" then fire(net.Egg.OpenEgg, state.eggName) end
if state.autoCrate and state.crateName ~= "" then fire(net.Crate.OpenCrate, state.crateName) end
if state.autoPack and state.packName ~= "" then fire(net.SeedPack.OpenSeedPack, state.packName) end
end
end)
local function gearPurchasePacket()
local shop = netPath("GearShop")
if type(shop) ~= "table" then return nil end
if shop.PurchaseGear then return shop.PurchaseGear end
for k, v in pairs(shop) do
if type(k) == "string" and k:lower():find("purchase") and type(v) == "table" and v.Fire then return v end
end
for _, v in pairs(shop) do
if type(v) == "table" and v.Fire then return v end
end
return nil
end
local function crateBuyPacket()
local shop = netPath("CrateShop") or netPath("Crate")
if type(shop) ~= "table" then return nil end
for k, v in pairs(shop) do
if type(k) == "string" and k:lower():find("purchase") and type(v) == "table" and v.Fire then return v end
end
return nil
end
task.spawn(function()
while true do
task.wait(2)
if state.autoBuyGear then
pcall(function()
local pkt = gearPurchasePacket()
if not pkt then return end
local sv = ReplicatedStorage:FindFirstChild("StockValues")
sv = sv and sv:FindFirstChild("GearShop")
local items = sv and sv:FindFirstChild("Items")
local wanted = setFromList(state.gearList)
if items then
for _, v in ipairs(items:GetChildren()) do
local stock = (v:IsA("ValueBase") and v.Value) or v:GetAttribute("Stock") or 0
if (not wanted or wanted[v.Name]) and stock and stock > 0 then
fire(pkt, v.Name); task.wait(0.1)
end
end
end
end)
end
if state.autoBuyCrate and state.crateBuyName ~= "" then
local pkt = crateBuyPacket()
if pkt then fire(pkt, state.crateBuyName) end
end
end
end)
task.spawn(function()
while true do
task.wait(10)
if state.autoDaily then
pcall(function()
fire(net.NPCS.CheckDailyDeal)
fire(net.NPCS.UseDailyDealAll)
end)
end
end
end)
local redeemed = {}
local function redeemCodes(notify)
for _, code in ipairs(splitList(state.codeList)) do
if not redeemed[code] then
redeemed[code] = true
task.spawn(function()
local res = fire(net.Settings.SubmitCode, code)
if notify then
window:Notify("Grow a Garden 2", "Code '" .. code .. "': " .. tostring(res or "sent"), 5)
end
end)
task.wait(0.4)
end
end
end
task.spawn(function()
while true do
task.wait(0.4)
local hum = getHum()
if hum then
if state.walkEnabled then hum.WalkSpeed = state.walkSpeed end
if state.jumpEnabled then
hum.UseJumpPower = true
hum.JumpPower = state.jumpPower
end
end
end
end)
UserInputService.JumpRequest:Connect(function()
if state.infJump then
local hum = getHum()
if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end
end
end)
task.spawn(function()
while true do
RunService.Stepped:Wait()
if state.noclip then
local c = lp.Character
if c then
for _, p in ipairs(c:GetDescendants()) do
if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
end
end
else
task.wait(0.2)
end
end
end)
local flyConn
local function stopFly()
if flyConn then flyConn:Disconnect(); flyConn = nil end
local root = getRoot()
if root then
local bv = root:FindFirstChild("GAG_FlyVel"); if bv then bv:Destroy() end
local bg = root:FindFirstChild("GAG_FlyGyro"); if bg then bg:Destroy() end
end
end
local function startFly()
stopFly()
local root = getRoot()
local hum = getHum()
if not (root and hum) then return end
hum.PlatformStand = true
local bv = Instance.new("BodyVelocity")
bv.Name = "GAG_FlyVel"; bv.MaxForce = Vector3.new(1, 1, 1) * 9e9
bv.Velocity = Vector3.zero; bv.Parent = root
local bg = Instance.new("BodyGyro")
bg.Name = "GAG_FlyGyro"; bg.MaxTorque = Vector3.new(1, 1, 1) * 9e9; bg.P = 9e4
bg.CFrame = root.CFrame; bg.Parent = root
flyConn = RunService.RenderStepped:Connect(function()
if not state.fly then return end
local cam = Workspace.CurrentCamera
if not cam then return end
local dir = Vector3.zero
local function down(k) return UserInputService:IsKeyDown(k) end
if down(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
if down(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
if down(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
if down(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
if down(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
if down(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
bv.Velocity = (dir.Magnitude > 0 and dir.Unit or Vector3.zero) * state.flySpeed
bg.CFrame = cam.CFrame
end)
end
local function setFly(on)
state.fly = on
if on then startFly() else
stopFly()
local hum = getHum(); if hum then hum.PlatformStand = false end
end
end
lp.CharacterAdded:Connect(function()
task.wait(0.5)
if state.fly then startFly() end
end)
pcall(function()
local VirtualUser = game:GetService("VirtualUser")
lp.Idled:Connect(function()
if state.antiAfk then
pcall(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)
end
end)
end)
local function applyOptimize()
pcall(function() Lighting.GlobalShadows = false end)
pcall(function() Lighting.FogEnd = 9e9 end)
pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
pcall(function()
for _, d in ipairs(Workspace:GetDescendants()) do
if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") then
d.Enabled = false
end
end
end)
end
local hlFolder
local function hlParent()
if not hlFolder then
hlFolder = Instance.new("Folder")
hlFolder.Name = "GAG_Highlights"
hlFolder.Parent = (gethui and gethui()) or game:GetService("CoreGui")
end
return hlFolder
end
local hlMap = {}
local function clearHL()
for m, h in pairs(hlMap) do if h then h:Destroy() end end
table.clear(hlMap)
end
local function setHL(model, color)
local h = hlMap[model]
if not (h and h.Parent) then
h = Instance.new("Highlight")
h.FillTransparency = 0.6
h.OutlineTransparency = 0
h.Adornee = model
h.Parent = hlParent()
hlMap[model] = h
end
h.FillColor = color
h.OutlineColor = color
end
local READY_COLOR = Color3.fromRGB(80, 220, 130)
local RARE_COLOR = Color3.fromRGB(255, 200, 60)
task.spawn(function()
while true do
task.wait(0.6)
if state.hlReady or state.hlRare then
pcall(function()
local keep = {}
if state.hlReady then
for _, t in ipairs(getHarvestTargets()) do
setHL(t.model, READY_COLOR); keep[t.model] = true
end
end
if state.hlRare then
for _, tag in ipairs({ "HarvestPrompt", "StealPrompt" }) do
for _, prompt in ipairs(CollectionService:GetTagged(tag)) do
local model = promptModel(prompt)
if model and model:GetAttribute("Mutation") ~= nil then
setHL(model, RARE_COLOR); keep[model] = true
end
end
end
end
for m, h in pairs(hlMap) do
if not keep[m] or not m.Parent then h:Destroy(); hlMap[m] = nil end
end
end)
elseif next(hlMap) then
clearHL()
end
end
end)
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request
sendWebhook = function(content)
if state.webhookUrl == "" or not httpRequest then return end
pcall(function()
httpRequest({
Url = state.webhookUrl,
Method = "POST",
Headers = { ["Content-Type"] = "application/json" },
Body = HttpService:JSONEncode({
username = "Kali Hub | GaG2",
content = ("[%s] %s"):format(lp.DisplayName, content),
}),
})
end)
end
local function serverHop()
local ok, body = pcall(function()
return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId
.. "/servers/Public?sortOrder=Asc&limit=100")
end)
if ok and body then
local good, data = pcall(function() return HttpService:JSONDecode(body) end)
if good and data and data.data then
local pool = {}
for _, s in ipairs(data.data) do
if s.id ~= game.JobId and (s.playing or 0) < (s.maxPlayers or 0) then
pool[#pool + 1] = s.id
end
end
if #pool > 0 then
TeleportService:TeleportToPlaceInstance(game.PlaceId, pool[math.random(1, #pool)], lp)
return
end
end
end
TeleportService:Teleport(game.PlaceId, lp)
end
task.spawn(function()
local sv = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("SeedShop"):WaitForChild("Items")
local lastSeen = {}
while true do
task.wait(3)
if state.whRareSeed or state.autoHopRare then
local watch = setFromList(state.seedFilter) or {}
pcall(function()
for _, v in ipairs(sv:GetChildren()) do
local stock = (v:IsA("ValueBase") and v.Value) or v:GetAttribute("Stock") or 0
local isWatched = next(watch) and watch[v.Name]
if isWatched and stock and stock > 0 and not lastSeen[v.Name] then
lastSeen[v.Name] = true
if state.whRareSeed and sendWebhook then
sendWebhook(("Rare seed in stock: **%s** (x%s)"):format(v.Name, tostring(stock)))
end
if state.autoHopRare then
task.wait(0.5); serverHop()
end
elseif stock == 0 then
lastSeen[v.Name] = nil
end
end
end)
end
end
end)
local tabFarm = window:CreateTab("Farm")
local tabGarden = window:CreateTab("Garden")
local tabShop = window:CreateTab("Shop")
local tabPlayer = window:CreateTab("Player")
local tabVisuals = window:CreateTab("Visuals")
local tabMisc = window:CreateTab("Misc")
local seedNames = namesFromFolder(Assets:FindFirstChild("Seeds"))
local secHarvest = tabFarm:CreateSection("Harvest & Sell", "left")
local secPlant = tabFarm:CreateSection("Plant", "right")
secHarvest:CreateToggle("Auto Harvest", false, function(v) state.autoHarvest = v end)
secHarvest:CreateToggle("Teleport To Fruit", false, function(v) state.harvestTP = v end)
secHarvest:CreateDropdown("Harvest Crops (empty = all)", seedNames, function(value)
state.harvestCrops = multiToList(value)
end, "", true)
secHarvest:CreateToggle("Only Harvest Mutated", false, function(v) state.harvestMuts = v end)
secHarvest:CreateDivider()
secHarvest:CreateToggle("Auto Sell (interval)", false, function(v) state.autoSell = v end)
secHarvest:CreateSlider("Sell Interval (s)", 5, 120, 30, true, function(v) state.sellInterval = v end)
secHarvest:CreateToggle("Auto Sell When Full", false, function(v) state.sellOnFull = v end)
secHarvest:CreateSlider("Sell When Fruit >=", 20, 500, 200, true, function(v) state.sellCap = v end)
secPlant:CreateToggle("Auto Plant", false, function(v) state.autoPlant = v end)
secPlant:CreateDropdown("Seeds To Plant (empty = any owned)", seedNames, function(value)
state.plantSeeds = multiToList(value)
end, "", true)
secPlant:CreateSlider("Grid Spacing (studs)", 3, 14, 6, true, function(v) state.plantSpacing = v end)
secPlant:CreateSlider("Max Plant / Cycle", 5, 120, 40, true, function(v) state.plantPerCycle = v end)
secPlant:CreateSlider("Reserve Per Seed", 0, 50, 0, true, function(v) state.plantReserve = v end)
secPlant:CreateSlider("Plant Delay (ms)", 40, 500, 120, true, function(v) state.plantDelay = v / 1000 end)
secPlant:CreateLabel("Lays seeds on an even grid across your plot, skipping cells that already have a crop.", true)
secPlant:CreateDivider()
secPlant:CreateToggle("Auto Buy Seeds", false, function(v) state.autoBuySeeds = v end)
local secBuy = tabFarm:CreateSection("Seed / Mutation Filter", "left")
secBuy:CreateLabel("Nothing selected = everything.", true)
secBuy:CreateDropdown("Seed Filter (buy / rare watch)", seedNames, function(value)
state.seedFilter = multiToList(value)
end, "", true)
local mutationOptions = {}
pcall(function()
local set = {}
local mdInst = SharedModules:FindFirstChild("MutationData")
if mdInst then
for _, c in ipairs(mdInst:GetChildren()) do
if c:IsA("ModuleScript") then set[c.Name] = true end
end
local ok, md = pcall(require, mdInst)
if ok and type(md) == "table" then
for k, v in pairs(md) do
if type(k) == "string" and not k:find("^_") then set[k] = true end
if type(v) == "table" and type(v.Name) == "string" then set[v.Name] = true end
end
end
end
for n in pairs(set) do mutationOptions[#mutationOptions + 1] = n end
table.sort(mutationOptions)
end)
secBuy:CreateDropdown("Mutation Filter (steal)", mutationOptions, function(value)
state.mutationFilter = multiToList(value)
end, "", true)
local secDef = tabGarden:CreateSection("Defense", "left")
local secSteal = tabGarden:CreateSection("Stealing", "right")
secDef:CreateToggle("Anti Steal (panic harvest)", false, function(v) state.antiSteal = v end)
secDef:CreateToggle("Anti Shovel", false, function(v) state.antiShovel = v end)
secDef:CreateToggle("Auto Upgrade / Expand Garden", false, function(v) state.autoExpand = v end)
secSteal:CreateToggle("Auto Steal (Night)", false, function(v) state.autoSteal = v end)
secSteal:CreateToggle("Return After Steal", true, function(v) state.stealReturn = v end)
secSteal:CreateSlider("Carry Per Target", 1, 10, 1, true, function(v) state.stealMult = v end)
secSteal:CreateLabel("Only runs while it is Night. Use the Mutation Filter to target specific fruit.", true)
local secPets = tabGarden:CreateSection("Pets", "left")
secPets:CreateToggle("Auto Equip / Manage Pets", false, function(v) state.managePets = v end)
local petOptions = namesFromFolder(Assets:FindFirstChild("Pets"))
secPets:CreateDropdown("Pets To Equip", petOptions, function(value)
state.petList = multiToList(value)
end, "", true)
secPets:CreateButton("Equip Selected Now", function()
for _, name in ipairs(splitList(state.petList)) do net.Pets.RequestEquipByName:Fire(name) end
end)
secPets:CreateToggle("Auto Buy Pet Slots", false, function(v) state.autoPetSlots = v end)
secPets:CreateSlider("Max Pet Slots", 3, 30, 10, true, function(v) state.petSlotCap = v end)
local secEgg = tabShop:CreateSection("Eggs", "left")
local secCrate = tabShop:CreateSection("Crates", "right")
local secPack = tabShop:CreateSection("Seed Packs", "left")
local secGear = tabShop:CreateSection("Gear", "right")
local eggOptions = namesFromFolder(Assets:FindFirstChild("Eggs"))
secEgg:CreateDropdown("Egg", eggOptions, function(v) state.eggName = v end, eggOptions[1] or "", false)
secEgg:CreateToggle("Auto Open Eggs", false, function(v) state.autoEgg = v end)
secEgg:CreateButton("Open Once", function() if state.eggName ~= "" then fire(net.Egg.OpenEgg, state.eggName) end end)
local crateOptions = namesFromFolder(Assets:FindFirstChild("Crates"))
secCrate:CreateDropdown("Crate", crateOptions, function(v) state.crateName = v end, crateOptions[1] or "", false)
secCrate:CreateToggle("Auto Open Crates", false, function(v) state.autoCrate = v end)
secCrate:CreateButton("Open Once", function() if state.crateName ~= "" then fire(net.Crate.OpenCrate, state.crateName) end end)
secCrate:CreateDivider()
secCrate:CreateDropdown("Buy Crate", crateOptions, function(v) state.crateBuyName = v end, crateOptions[1] or "", false)
secCrate:CreateToggle("Auto Buy Crate", false, function(v) state.autoBuyCrate = v end)
local packOptions = namesFromFolder(Assets:FindFirstChild("SeedPacks"))
secPack:CreateDropdown("Seed Pack", packOptions, function(v) state.packName = v end, packOptions[1] or "", false)
secPack:CreateToggle("Auto Open Seed Packs", false, function(v) state.autoPack = v end)
secPack:CreateButton("Open Once", function() if state.packName ~= "" then fire(net.SeedPack.OpenSeedPack, state.packName) end end)
local gearOptions = namesFromFolder(Assets:FindFirstChild("Gear")) or {}
do
local sv = ReplicatedStorage:FindFirstChild("StockValues")
sv = sv and sv:FindFirstChild("GearShop")
local items = sv and sv:FindFirstChild("Items")
if #gearOptions == 0 and items then gearOptions = namesFromFolder(items) end
end
secGear:CreateDropdown("Gear To Buy (empty = all)", gearOptions, function(value)
state.gearList = multiToList(value)
end, "", true)
secGear:CreateToggle("Auto Buy Gear", false, function(v) state.autoBuyGear = v end)
secGear:CreateLabel("Buys in-stock gear from the Gear Shop.", true)
local secMove = tabPlayer:CreateSection("Movement", "left")
local secTweak = tabPlayer:CreateSection("Tweaks", "right")
local walkTog = secMove:CreateToggle("WalkSpeed", false, function(v)
state.walkEnabled = v
if not v then local h = getHum() if h then h.WalkSpeed = 16 end end
end)
secMove:CreateSlider("WalkSpeed Value", 16, 250, 16, true, function(v) state.walkSpeed = v end)
local jumpTog = secMove:CreateToggle("JumpPower", false, function(v)
state.jumpEnabled = v
if not v then local h = getHum() if h then h.UseJumpPower = true; h.JumpPower = 50 end end
end)
secMove:CreateSlider("JumpPower Value", 50, 350, 50, true, function(v) state.jumpPower = v end)
local infTog = secMove:CreateToggle("Infinite Jump", false, function(v) state.infJump = v end)
local noclipTog = secMove:CreateToggle("Noclip", false, function(v) state.noclip = v end)
local flyTog = secMove:CreateToggle("Fly", false, function(v) setFly(v) end)
secMove:CreateSlider("Fly Speed", 20, 250, 60, true, function(v) state.flySpeed = v end)
secMove:CreateLabel("Fly: W/A/S/D, Space up, Left-Ctrl down.", true)
pcall(function()
if flyTog and flyTog.CreateKeybind then
flyTog:CreateKeybind("F", function() setFly(not state.fly) end, "Toggle")
end
end)
pcall(function()
if noclipTog and noclipTog.CreateKeybind then
noclipTog:CreateKeybind("N", function() state.noclip = not state.noclip end, "Toggle")
end
end)
secTweak:CreateToggle("Anti AFK", true, function(v) state.antiAfk = v end)
secTweak:CreateToggle("Optimize (low graphics)", false, function(v)
state.optimize = v
if v then applyOptimize() end
end)
local secHl = tabVisuals:CreateSection("Highlights", "left")
secHl:CreateToggle("Highlight Ready Crops", false, function(v) state.hlReady = v end)
secHl:CreateToggle("Highlight Rare / Mutated", false, function(v) state.hlRare = v end)
secHl:CreateLabel("Green = ready to harvest, Gold = mutated fruit (anywhere in the gardens).", true)
local secDaily = tabMisc:CreateSection("Rewards", "left")
local secHook = tabMisc:CreateSection("Webhook & Server Hop", "right")
secDaily:CreateToggle("Auto Daily Rewards / Deals", false, function(v) state.autoDaily = v end)
secDaily:CreateButton("Claim Daily Deal Now", function() fire(net.NPCS.CheckDailyDeal); fire(net.NPCS.UseDailyDealAll) end)
secDaily:CreateTextBox("Codes (comma separated)", "", false, function(v) state.codeList = v end)
secDaily:CreateButton("Redeem Codes", function() redeemCodes(true) end)
secHook:CreateTextBox("Discord Webhook URL", "", false, function(v) state.webhookUrl = v end)
secHook:CreateToggle("Ping On Rare Seed", false, function(v) state.whRareSeed = v end)
secHook:CreateToggle("Ping On Big Harvest", false, function(v) state.whBigHarvest = v end)
secHook:CreateSlider("Big Harvest = Fruit >=", 5, 100, 25, true, function(v) state.bigHarvestMin = v end)
secHook:CreateButton("Test Webhook", function() sendWebhook("Webhook test from Kali Hub.") end)
secHook:CreateDivider()
secHook:CreateToggle("Auto Server Hop On Rare Seed", false, function(v) state.autoHopRare = v end)
secHook:CreateButton("Server Hop Now", function() serverHop() end)
secHook:CreateLabel("Rare watch uses the Seed Filter selection on the Farm tab.", true)
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100)
window:SetTileScale(0.5)
window:SetBackgroundColor(Color3.fromRGB(255, 255, 255))
window:SetBackgroundTransparency(0)
