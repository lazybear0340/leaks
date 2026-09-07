--this shit was unobfuscated


local workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local Lighting = cloneref(game:GetService("Lighting"))
local UIS = cloneref(game:GetService("UserInputService"))
local GuiInset = cloneref(game:GetService("GuiService")):GetGuiInset()
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local _CFramenew = CFrame.new
local _Vector2new = Vector2.new
local _Vector3new = Vector3.new
local _IsDescendantOf = game.IsDescendantOf
local _FindFirstChild = game.FindFirstChild
local _FindFirstChildOfClass = game.FindFirstChildOfClass
local _WTV = Camera.WorldToViewportPoint
local _V3zmin = Vector3.zero.Min
local _V2zmin = Vector2.zero.Min
local _V3zmax = Vector3.zero.Max
local _V2zmax = Vector2.zero.Max
local _IsA = game.IsA
local mathfloor = math.floor
local mathround = math.round
gui_config = {
Color = Color3.fromRGB(255,255,255), Keybind = Enum.KeyCode.RightAlt, Assets = true,
MinHeight = 100, MaxHeight = 700, InitialHeight = 520,
MinWidth = 300, MaxWidth = 900, InitialWidth = 620,
}
local library = loadstring(game:HttpGet("https://kalihub.xyz/Module.lua"))()
local window = library:CreateWindow(gui_config, gethui())
library:SetWindowName("Kali Hub | Project Delta")
local tabs = { combat = window:CreateTab("Combat"), visuals = window:CreateTab("Visuals"), movement = window:CreateTab("Camera"), risky = window:CreateTab("Risky"), settings = window:CreateTab("Settings") }
local sec = {
silentaim = tabs.combat:CreateSection("Silent Aim"),
crosshair = tabs.combat:CreateSection("Crosshair"),
world = tabs.combat:CreateSection("World", "right"),
weaponmods= tabs.combat:CreateSection("Weapon Mods", "right"),
ragebot = tabs.combat:CreateSection("Rage Bot", "right"),
trigbot = tabs.combat:CreateSection("Triggerbot"),
othervis = tabs.combat:CreateSection("Other Visuals"),
playeresp = tabs.visuals:CreateSection("Player & NPC ESP"),
loot = tabs.visuals:CreateSection("Loot ESP", "right"),
bullettr = tabs.visuals:CreateSection("Bullet Tracers"),
intel = tabs.visuals:CreateSection("Target Intel", "right"),
cam = tabs.movement:CreateSection("Camera"),
aa_sec = tabs.risky:CreateSection("Anti-Aim"),
aa_opt = tabs.risky:CreateSection("AA Options", "right"),
tpk = tabs.risky:CreateSection("TP Kill", "right"),
pkt = tabs.risky:CreateSection("Packet Aim"),
settings = tabs.settings:CreateSection("Settings"),
}
local conn_h, conn_r = {}, {}
local function new_heartbeat(f) conn_h[f] = f return {Disconnect = function() conn_h[f] = nil end} end
local function new_renderstepped(f) conn_r[f] = f return {Disconnect = function() conn_r[f] = nil end} end
RunService.Heartbeat:Connect(function(dt) for _,f in pairs(conn_h) do f(dt) end end)
RunService.RenderStepped:Connect(function(dt) for _,f in pairs(conn_r) do f(dt) end end)
local rainbow_hue = 0
local function rgb() return Color3.fromHSV(rainbow_hue, 1, 1) end
new_renderstepped(function(dt) rainbow_hue = (rainbow_hue + dt * 0.35) % 1 end)
local silent_aim = {
enabled=false, target_ai=false, part="Head",
fov=false, fov_show=false, fov_color=Color3.new(1,1,1), fov_outline=false, fov_rainbow=false,
fov_size=100, indicator=false, indicator_text="",
nospread=false, target_part=nil, is_npc=false, isvisible=false, visible_check=false,
tracer=false, tracer_color=Color3.new(1,1,1), random_part=false,
}
local no_recoil = false
local forceauto = false
local rage = {enabled=false, autofire=false, trigger="While Aiming", fov=0, part="Head", target_npcs=false, visible_check=true, held=false}
local trigger = {on=false, visible_only=true}
local tpkill, packet, aa
local RAND_PARTS = {"Head","UpperTorso","LowerTorso","LeftUpperLeg","RightUpperLeg","LeftLowerArm","RightLowerArm"}
local rand_timer = 0
local function predict_velocity(Origin, Dest, DestVel, Speed)
local d = (Dest - Origin).Magnitude
local t = d / Speed
t = t + (Dest + DestVel * t - Origin).Magnitude / Speed
return Dest + DestVel * t
end
local vischeck_params = RaycastParams.new()
vischeck_params.FilterType = Enum.RaycastFilterType.Exclude
vischeck_params.CollisionGroup = "WeaponRay"
vischeck_params.IgnoreWater = true
local function is_visible(cframe, target, tp)
if not (target and tp and cframe) then return false end
vischeck_params.FilterDescendantsInstances = {workspace.NoCollision, Camera, LocalPlayer.Character}
local r = workspace:Raycast(cframe.p, tp.CFrame.p - cframe.p, vischeck_params)
return r and r.Instance and _IsDescendantOf(r.Instance, target)
end
local function get_closest_target(usefov, fov_size, aimpart, npc)
local part, isnpc, maxdist = nil, false, usefov and fov_size or math.huge
local mpos = _Vector2new(Mouse.X, Mouse.Y)
if npc then
for _, zone in pairs(workspace.AiZones:GetChildren()) do
for _, n in pairs(zone:GetChildren()) do
local p = _FindFirstChild(n, aimpart)
local h = _FindFirstChildOfClass(n, "Humanoid")
if p and h and h.Health > 0 then
local pos, on = _WTV(Camera, p.Position)
local d = (_Vector2new(pos.X, pos.Y - GuiInset.Y) - mpos).Magnitude
if (usefov and on or not usefov) and d < maxdist then part=p; maxdist=d; isnpc=true end
end
end
end
end
for _, plr in Players:GetPlayers() do
local ch = plr.Character
if plr ~= LocalPlayer and ch then
local p = _FindFirstChild(ch, aimpart)
local h = _FindFirstChildOfClass(ch, "Humanoid")
if p and h and h.Health > 0 then
local pos, on = _WTV(Camera, p.Position)
local d = (_Vector2new(pos.X, pos.Y - GuiInset.Y) - mpos).Magnitude
if (usefov and on or not usefov) and d <= maxdist then part=p; maxdist=d; isnpc=false end
end
end
end
return part, isnpc
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local bulletModule = require(ReplicatedStorage.Modules.FPS.Bullet)
local FireProjectile = ReplicatedStorage.Remotes.FireProjectile
local ProjectileInflict = ReplicatedStorage.Remotes.ProjectileInflict
local old_CreateBullet = clonefunction(bulletModule.CreateBullet)
bulletModule.CreateBullet = newcclosure(function(self, ...)
if checkcaller() then return old_CreateBullet(self, ...) end
local a, b, c, d
local vc = rage.enabled and rage.visible_check or silent_aim.visible_check
if (silent_aim.enabled or rage.enabled) and silent_aim.target_part and (not vc or silent_aim.isvisible) then
local args = {...}
local aim_idx, loadedammo
for i, v in ipairs(args) do
if typeof(v) == "Instance" and v.Name == "AimPart" then aim_idx = i end
if type(v) == "string" then
local ammo = ReplicatedStorage.AmmoTypes:FindFirstChild(v)
if ammo then loadedammo = ammo end
end
end
if loadedammo and aim_idx then
local Speed = loadedammo:GetAttribute("MuzzleVelocity") or 1000
local Dest = predict_velocity(Camera.CFrame.p, silent_aim.target_part.Position, silent_aim.target_part.Velocity, Speed)
args[aim_idx] = { CFrame = CFrame.new(Camera.CFrame.p, Dest) }
a, b, c, d = old_CreateBullet(self, unpack(args))
else
a, b, c, d = old_CreateBullet(self, ...)
end
else
a, b, c, d = old_CreateBullet(self, ...)
end
if no_recoil then a, b = 0, 0 end
return a, b, c, d
end)
local rapid = {enabled=false, mult=0.5, weap=nil, orig=nil}
local fps_state
local function get_fps_state()
local char = LocalPlayer.Character
if fps_state and rawget(fps_state, "character") == char then return fps_state end
fps_state = nil
for _, o in next, getgc(true) do
if type(o) == "table" and rawget(o, "springs") and rawget(o, "swayMult") ~= nil and rawget(o, "character") == char then
fps_state = o
break
end
end
return fps_state
end
new_heartbeat(function()
local s = get_fps_state()
if not s then rapid.weap, rapid.orig = nil, nil return end
if rapid.enabled then
if rapid.weap ~= s.weapon then rapid.weap, rapid.orig = s.weapon, s.FireRate end
local o = rapid.orig
if o then s.FireRate = math.max(o * rapid.mult, 0.02) end
elseif rapid.orig then
if rapid.weap == s.weapon then s.FireRate = rapid.orig end
rapid.weap, rapid.orig = nil, nil
end
end)
local af_held = false
new_heartbeat(function()
local tgt = silent_aim.target_part ~= nil
local rwant = rage.enabled and rage.autofire and tgt
local twant = trigger.on and tgt and (not trigger.visible_only or silent_aim.isvisible)
local tpwant = tpkill and tpkill.enabled and tpkill.autotbot and tgt
if not (rwant or twant or tpwant or af_held) then return end
local s = get_fps_state()
local fire = false
if twant or tpwant then fire = true end
if rwant and s and (rage.trigger == "Always" or s.RightMouseDown) then fire = true end
if fire and s then
s.MouseHeld = true; af_held = true
elseif af_held then
if s then s.MouseHeld = false end
af_held = false
end
end)
local instant = {reload=false, equip=false, aim=false}
new_heartbeat(function()
if not (instant.reload or instant.equip or instant.aim or forceauto) then return end
local s = get_fps_state(); if not s then return end
if instant.aim then s.AimInSpeed = 0; s.AimOutSpeed = 0 end
if forceauto then s.FireMode = "Auto" end
local ct, stt = rawget(s, "clientAnimationTracks"), rawget(s, "serverAnimationTracks")
if ct then
local function fast(tbl, name)
local t = tbl and tbl[name]
if t and t.IsPlaying then t:AdjustSpeed(100) end
end
if instant.equip then fast(ct, "Equip"); fast(stt, "Equip") end
if instant.reload and rawget(s, "reloading") then
for _, n in ipairs({"Reload", "ReloadChamber", "ReloadNoMag"}) do fast(ct, n); fast(stt, n) end
end
end
end)
local ibullet = {on=false, speed=3000, orig={}}
local function set_instant_bullet(on)
for _, a in ipairs(ReplicatedStorage.AmmoTypes:GetChildren()) do
local mv = a:GetAttribute("MuzzleVelocity")
if mv then
if on then
if ibullet.orig[a] == nil then ibullet.orig[a] = mv end
if mv < ibullet.speed then a:SetAttribute("MuzzleVelocity", ibullet.speed) end
elseif ibullet.orig[a] ~= nil then
a:SetAttribute("MuzzleVelocity", ibullet.orig[a]); ibullet.orig[a] = nil
end
end
end
end
local btracer = {force=false, custom=false, color=Color3.fromRGB(120,200,255), rainbow=false, ammo_orig={}, gun_orig={}}
local function set_force_tracers(on)
for _, a in ipairs(ReplicatedStorage.AmmoTypes:GetChildren()) do
if on then
if btracer.ammo_orig[a] == nil then btracer.ammo_orig[a] = a:GetAttribute("Tracer") == nil and false or a:GetAttribute("Tracer") end
a:SetAttribute("Tracer", true)
elseif btracer.ammo_orig[a] ~= nil then
local o = btracer.ammo_orig[a]; a:SetAttribute("Tracer", o == false and nil or o); btracer.ammo_orig[a] = nil
end
end
end
local function restore_tracer_color()
for w, o in pairs(btracer.gun_orig) do w:SetAttribute("ProjectileColor", o == false and nil or o) end
btracer.gun_orig = {}
end
new_heartbeat(function()
if not btracer.custom then return end
local col = btracer.rainbow and rgb() or btracer.color
for _, w in ipairs(ReplicatedStorage.RangedWeapons:GetChildren()) do
if btracer.gun_orig[w] == nil then btracer.gun_orig[w] = w:GetAttribute("ProjectileColor") or false end
w:SetAttribute("ProjectileColor", col)
end
end)
local nospread_orig = {}
local function set_no_spread(on)
for _, a in ipairs(ReplicatedStorage.AmmoTypes:GetChildren()) do
local pel = a:GetAttribute("Pellets")
if pel and pel > 1 then
if on then
if nospread_orig[a] == nil then nospread_orig[a] = a:GetAttribute("AccuracyDeviation") or false end
a:SetAttribute("AccuracyDeviation", 1)
elseif nospread_orig[a] ~= nil then
a:SetAttribute("AccuracyDeviation", nospread_orig[a] or nil)
nospread_orig[a] = nil
end
end
end
end
new_heartbeat(function()
if not (silent_aim.enabled or silent_aim.indicator or rage.enabled or trigger.on
or (packet and packet.autoshoot) or (tpkill and tpkill.enabled)
or (aa and aa.enabled and (aa.mode == "Reverse" or aa.mode == "Random"))) then
silent_aim.target_part, silent_aim.indicator_text = nil, ""
return
end
if silent_aim.random_part and tick() - rand_timer > 0.02 then
rand_timer = tick(); silent_aim.part = RAND_PARTS[math.random(#RAND_PARTS)]
end
local usefov, fovsz, part, npc
if rage.enabled then
usefov, fovsz, part, npc = true, (rage.fov > 0 and rage.fov or 9999), rage.part, rage.target_npcs
else
usefov, fovsz, part, npc = silent_aim.fov, silent_aim.fov_size, silent_aim.part, silent_aim.target_ai
end
silent_aim.target_part, silent_aim.is_npc = get_closest_target(usefov, fovsz, part, npc)
silent_aim.isvisible = silent_aim.target_part and is_visible(Camera.CFrame, silent_aim.target_part.Parent, silent_aim.target_part) or false
local t = ""
if silent_aim.target_part then
t = silent_aim.target_part.Parent.Name
if silent_aim.isvisible then t = t.." (visible)" end
if silent_aim.is_npc then t = t.." (ai)" end
end
silent_aim.indicator_text = t
end)
local fov_out = Drawing.new("Circle")
local fov_in = Drawing.new("Circle")
fov_in.Transparency=1; fov_in.Thickness=1; fov_in.ZIndex=2
fov_out.Thickness=3; fov_out.Color=Color3.new(); fov_out.ZIndex=1
new_renderstepped(function()
local p = _Vector2new(Mouse.X, Mouse.Y + GuiInset.Y)
fov_out.Position = p; fov_in.Position = p
fov_in.Radius = silent_aim.fov_size; fov_in.Color = silent_aim.fov_rainbow and rgb() or silent_aim.fov_color
fov_in.Visible = silent_aim.fov and silent_aim.fov_show
fov_out.Radius = silent_aim.fov_size
fov_out.Visible = silent_aim.fov and silent_aim.fov_show and silent_aim.fov_outline
end)
local esp_set = {
enemy = {
enabled=false, box=false, box_fill=false, realname=false, displayname=false,
health=false, dist=false, weapon=false, skeleton=false,
box_outline=false, realname_outline=false, displayname_outline=false,
health_outline=false, dist_outline=false, weapon_outline=false,
box_color={Color3.new(1,1,1),1}, box_fill_color={Color3.new(1,0,0),0.5},
box_outline_color={Color3.new(),1}, realname_color={Color3.new(1,1,1),1},
displayname_color={Color3.new(1,1,1),1}, health_color={Color3.new(1,1,1),1},
dist_color={Color3.new(1,1,1),1}, weapon_color={Color3.new(1,1,1),1},
skeleton_color={Color3.new(1,1,1),1},
realname_outline_color=Color3.new(), displayname_outline_color=Color3.new(),
health_outline_color=Color3.new(), dist_outline_color=Color3.new(), weapon_outline_color=Color3.new(),
chams=false, chams_visible_only=false,
chams_fill_color={Color3.new(1,1,1),0.5}, chamsoutline_color={Color3.new(1,1,1),0},
tracer=false, tracer_color={Color3.new(1,1,1),1}, tracer_from="Bottom",
show_players=true, show_npcs=true, rainbow=false,
}
}
local esp_main = { textSize=15, textFont=Drawing.Fonts.Monospace, infiniterange=false }
local VERTICES = {
_Vector3new(-1,-1,-1),_Vector3new(-1,1,-1),_Vector3new(-1,1,1),_Vector3new(-1,-1,1),
_Vector3new(1,-1,-1), _Vector3new(1,1,-1), _Vector3new(1,1,1), _Vector3new(1,-1,1),
}
local SKEL = {
LeftFoot="LeftLowerLeg",LeftLowerLeg="LeftUpperLeg",LeftUpperLeg="LowerTorso",
RightFoot="RightLowerLeg",RightLowerLeg="RightUpperLeg",RightUpperLeg="LowerTorso",
LeftHand="LeftLowerArm",LeftLowerArm="LeftUpperArm",LeftUpperArm="UpperTorso",
RightHand="RightLowerArm",RightLowerArm="RightUpperArm",RightUpperArm="UpperTorso",
LowerTorso="UpperTorso",UpperTorso="Head",
}
local function isBodyPart(n) return n=="Head" or n:find("Torso") or n:find("Leg") or n:find("Arm") end
local function getBoundingBox(parts)
local min, max
for _, p in parts do
local cf,sz = p.CFrame, p.Size
min = _V3zmin(min or cf.Position, (cf - sz*0.5).Position)
max = _V3zmax(max or cf.Position, (cf + sz*0.5).Position)
end
local c = (min+max)*0.5
return _CFramenew(c, _Vector3new(c.X,c.Y,max.Z)), max-min
end
local function wts(world)
local s, b = _WTV(Camera, world)
return _Vector2new(s.X,s.Y), b, s.Z
end
local function calcCorners(cf, size)
local corners = {}
for i=1,#VERTICES do corners[i] = wts((cf + size*0.5*VERTICES[i]).Position) end
local mn = _V2zmin(Camera.ViewportSize, unpack(corners))
local mx = _V2zmax(Vector2.zero, unpack(corners))
return {
topLeft=_Vector2new(mathfloor(mn.X),mathfloor(mn.Y)),
topRight=_Vector2new(mathfloor(mx.X),mathfloor(mn.Y)),
bottomLeft=_Vector2new(mathfloor(mn.X),mathfloor(mx.Y)),
bottomRight=_Vector2new(mathfloor(mx.X),mathfloor(mx.Y)),
}
end
local function esp_obj(t, args) local o=Drawing.new(t); for k,v in args do o[k]=v end; return o end
local function get_gun(plr)
local P = _FindFirstChild(game:GetService("ReplicatedStorage").Players, plr.Name)
if P and _FindFirstChild(P,"Status") and _FindFirstChild(P.Status,"GameplayVariables")
and _FindFirstChild(P.Status.GameplayVariables,"EquippedTool")
and P.Status.GameplayVariables.EquippedTool.Value then
return tostring(P.Status.GameplayVariables.EquippedTool.Value)
end
return "None"
end
local loaded_plrs = {}
local esp_container = Instance.new("Folder", game:GetService("CoreGui").RobloxGui)
local function esp_icaca()
for _,v in loaded_plrs do task.spawn(function() v:forceupdate() end) end
end
local function create_esp(player, isnpc)
if not player then return end
if player.ClassName == "Model" then isnpc = true end
loaded_plrs[player] = {
obj = {
box_fill = esp_obj("Square",{Filled=true,Visible=false}),
box_outline = esp_obj("Square",{Filled=false,Thickness=3,Visible=false,ZIndex=-1}),
box = esp_obj("Square",{Filled=false,Thickness=1,Visible=false}),
realname = esp_obj("Text",{Center=true,Visible=false,Text=player.Name}),
displayname = esp_obj("Text",{Center=true,Visible=false,Text=isnpc and "" or player.Name==player.DisplayName and "" or player.DisplayName}),
healthtext = esp_obj("Text",{Center=false,Visible=false}),
dist = esp_obj("Text",{Center=true,Visible=false}),
weapon = esp_obj("Text",{Center=true,Visible=false}),
tracer = esp_obj("Line",{Visible=false,Thickness=1}),
},
chams_object = Instance.new("Highlight", esp_container),
plr_instance = player,
}
for k in next, SKEL do loaded_plrs[player].obj["sk_"..k] = esp_obj("Line",{Visible=false}) end
local plr = loaded_plrs[player]; local obj = plr.obj; local cham = plr.chams_object
local box=obj.box; local box_ol=obj.box_outline; local box_fl=obj.box_fill
local ht=obj.healthtext; local rn=obj.realname; local dn=obj.displayname; local dt=obj.dist; local wp=obj.weapon
local tr=obj.tracer
local s = esp_set.enemy; local vis_cache = false
function plr:forceupdate()
cham.DepthMode=s.chams_visible_only and 1 or 0
cham.FillColor=s.chams_fill_color[1]; cham.OutlineColor=s.chamsoutline_color[1]
cham.FillTransparency=s.chams_fill_color[2]; cham.OutlineTransparency=s.chamsoutline_color[2]
box.Color=s.box_color[1]; box_ol.Color=s.box_outline_color[1]; box_fl.Color=s.box_fill_color[1]
for _,v in {rn,dn,ht,dt,wp} do v.Size=esp_main.textSize; v.Font=esp_main.textFont end
rn.Color=s.realname_color[1]; rn.Outline=s.realname_outline; rn.OutlineColor=s.realname_outline_color
dn.Color=s.displayname_color[1]; dn.Outline=s.displayname_outline; dn.OutlineColor=s.displayname_outline_color
ht.Color=s.health_color[1]; ht.Outline=s.health_outline; ht.OutlineColor=s.health_outline_color
dt.Color=s.dist_color[1]; dt.Outline=s.dist_outline; dt.OutlineColor=s.dist_outline_color
wp.Color=s.weapon_color[1]; wp.Outline=s.weapon_outline; wp.OutlineColor=s.weapon_outline_color
tr.Color=s.tracer_color[1]; tr.Transparency=s.tracer_color[2]
for k in next, SKEL do local sk=obj["sk_"..k]; if sk then sk.Color=s.skeleton_color[1]; sk.Transparency=s.skeleton_color[2] end end
box.Transparency=s.box_color[2]; box_ol.Transparency=s.box_outline_color[2]; box_fl.Transparency=s.box_fill_color[2]
rn.Transparency=s.realname_color[2]; dn.Transparency=s.displayname_color[2]; ht.Transparency=s.health_color[2]
dt.Transparency=s.dist_color[2]; wp.Transparency=s.weapon_color[2]
if vis_cache then
cham.Enabled=s.chams; box.Visible=s.box; box_ol.Visible=s.box_outline; box_fl.Visible=s.box_fill
rn.Visible=s.realname; dn.Visible=s.displayname; ht.Visible=s.health; dt.Visible=s.dist; wp.Visible=s.weapon
tr.Visible=s.tracer
for k in next, SKEL do local sk=obj["sk_"..k]; if sk then sk.Visible=s.skeleton end end
end
end
function plr:togglevis(bool)
if vis_cache == bool then return end; vis_cache = bool
if not bool then
for _,v in obj do v.Visible=false end; cham.Enabled=false
else
cham.Enabled=s.chams; box.Visible=s.box; box_ol.Visible=s.box_outline; box_fl.Visible=s.box_fill
rn.Visible=s.realname; dn.Visible=s.displayname; ht.Visible=s.health; dt.Visible=s.dist; wp.Visible=s.weapon
tr.Visible=s.tracer
for k in next, SKEL do local sk=obj["sk_"..k]; if sk then sk.Visible=s.skeleton end end
end
end
plr.connection = new_renderstepped(function()
local p2 = loaded_plrs[player]
if not s.enabled then return p2:togglevis(false) end
if (isnpc and not s.show_npcs) or (not isnpc and not s.show_players) then return p2:togglevis(false) end
local ch = isnpc and player or player.Character
local hum = ch and _FindFirstChildOfClass(ch, "Humanoid")
local hd = ch and _FindFirstChild(ch, "Head")
if not (ch and hd and hum and ch.Parent and hd.Parent and hum.Parent) then
rn.Visible=false; return p2:togglevis(false)
end
local _, onScreen = _WTV(Camera, hd.Position)
if not onScreen then return p2:togglevis(false) end
local dist_mag = (Camera.CFrame.p - hd.Position).Magnitude
local cache = {}
for _, part in ch:GetChildren() do
if _IsA(part,"BasePart") and isBodyPart(part.Name) then cache[#cache+1]=part end
end
if #cache == 0 then return p2:togglevis(false) end
local corners = calcCorners(getBoundingBox(cache))
p2:togglevis(true); cham.Adornee = ch
local pos = corners.topLeft; local size = corners.bottomRight - corners.topLeft
box.Position=pos; box.Size=size; box_ol.Position=pos; box_ol.Size=size; box_fl.Position=pos; box_fl.Size=size
local topMid = (corners.topLeft + corners.topRight) * 0.5 - Vector2.yAxis
rn.Position = topMid - Vector2.yAxis*rn.TextBounds.Y - _Vector2new(0,2)
dn.Position = topMid - Vector2.yAxis*dn.TextBounds.Y - (rn.Visible and Vector2.yAxis*rn.TextBounds.Y or Vector2.zero)
rn.Text = player.Name
local botMid = (corners.bottomLeft + corners.bottomRight) * 0.5
dt.Text=mathround(dist_mag/3).." meters"; dt.Position=botMid
wp.Text=isnpc and "" or get_gun(player)
wp.Position=botMid + (dt.Visible and Vector2.yAxis*dt.TextBounds.Y - _Vector2new(0,2) or Vector2.zero)
ht.Text=tostring(mathfloor(hum.Health))
ht.Position=corners.topLeft - _Vector2new(2,0) - Vector2.yAxis*(ht.TextBounds.Y*0.25) - Vector2.xAxis*ht.TextBounds.X
if s.tracer then
local vp = Camera.ViewportSize
local from = (s.tracer_from=="Top" and _Vector2new(vp.X*0.5, 0))
or (s.tracer_from=="Mouse" and _Vector2new(Mouse.X, Mouse.Y+GuiInset.Y))
or _Vector2new(vp.X*0.5, vp.Y)
tr.From=from; tr.To=botMid
end
if s.rainbow then
local rc=rgb()
box.Color=rc; box_ol.Color=rc; box_fl.Color=rc; rn.Color=rc; dn.Color=rc; ht.Color=rc; dt.Color=rc; wp.Color=rc; tr.Color=rc
for k in next, SKEL do local sk=obj["sk_"..k]; if sk then sk.Color=rc end end
end
if s.skeleton then
for _, part in next, ch:GetChildren() do
local pname = SKEL[part.Name]
local pinst = pname and _FindFirstChild(ch, pname)
local line = obj["sk_"..part.Name]
if pinst and line then
local a = _WTV(Camera, part.Position); local b = _WTV(Camera, pinst.Position)
line.From=_Vector2new(a.X,a.Y); line.To=_Vector2new(b.X,b.Y)
end
end
end
end)
plr:forceupdate()
end
local function destroy_esp(player)
if not loaded_plrs[player] then return end
loaded_plrs[player].connection:Disconnect()
for _,v in loaded_plrs[player].obj do v:Remove() end
if loaded_plrs[player].chams_object then loaded_plrs[player].chams_object:Destroy() end
loaded_plrs[player] = nil
end
do
local function sc(remove)
return function(model) (remove and destroy_esp or create_esp)(model) end
end
for _,v in next, Players:GetPlayers() do if v ~= LocalPlayer then create_esp(v) end end
for _,folder in next, workspace.AiZones:GetChildren() do
for _,npc in next, folder:GetChildren() do create_esp(npc, true) end
end
Players.PlayerAdded:Connect(sc(false)); Players.PlayerRemoving:Connect(sc(true))
for _,zone in pairs(workspace.AiZones:GetChildren()) do
zone.ChildAdded:Connect(sc(false)); zone.ChildRemoved:Connect(sc(true))
end
end
local loot = {
dropped = {on=false, col=Color3.fromRGB(90,255,140)},
containers = {on=false, col=Color3.fromRGB(255,190,70)},
quest = {on=false, col=Color3.fromRGB(255,110,255)},
maxdist=250, textsize=13, showdist=true,
tracer=false, tracer_col=Color3.new(1,1,1), rainbow=false,
}
local LOOT_MAX = 120
local loot_pool = {}
for i=1,LOOT_MAX do
loot_pool[i] = {
text = esp_obj("Text",{Center=true,Visible=false,Outline=true,Size=13,Font=Drawing.Fonts.Monospace}),
line = esp_obj("Line",{Visible=false,Thickness=1}),
}
end
local container_cache = {}
task.spawn(function()
while true do
if loot.containers.on then
local t = {}
for _,zone in ipairs(workspace.Containers:GetChildren()) do
for _,m in ipairs(zone:GetChildren()) do
if m:IsA("Model") or m:IsA("BasePart") then t[#t+1] = {m:GetPivot().Position, m.Name} end
end
end
container_cache = t
else
container_cache = {}
end
task.wait(2)
end
end)
new_renderstepped(function()
if not (loot.dropped.on or loot.containers.on or loot.quest.on) then
for i=1,LOOT_MAX do loot_pool[i].text.Visible=false; loot_pool[i].line.Visible=false end
return
end
local camp = Camera.CFrame.p
local vp = Camera.ViewportSize
local origin = _Vector2new(vp.X*0.5, vp.Y)
local rc = loot.rainbow and rgb() or nil
local idx = 0
local function put(pos, label, col)
if idx >= LOOT_MAX then return end
local d = (camp - pos).Magnitude
if d > loot.maxdist then return end
local sp, on = _WTV(Camera, pos)
if not on then return end
idx = idx + 1
local e = loot_pool[idx]; local sc = _Vector2new(sp.X, sp.Y); local c = rc or col
e.text.Size = loot.textsize; e.text.Color = c
e.text.Text = loot.showdist and (label.." ["..mathround(d/3).."m]") or label
e.text.Position = sc; e.text.Visible = true
if loot.tracer then
e.line.Color = rc or loot.tracer_col; e.line.From = origin; e.line.To = sc; e.line.Visible = true
else
e.line.Visible = false
end
end
if loot.dropped.on then
for _,m in ipairs(workspace.DroppedItems:GetChildren()) do
if m:IsA("Model") or m:IsA("BasePart") then put(m:GetPivot().Position, m:GetAttribute("DisplayName") or m.Name, loot.dropped.col) end
end
end
if loot.quest.on then
for _,m in ipairs(workspace.QuestItems:GetChildren()) do
if m:IsA("Model") or m:IsA("BasePart") then put(m:GetPivot().Position, m.Name, loot.quest.col) end
end
end
if loot.containers.on then
for _,c in ipairs(container_cache) do put(c[1], c[2], loot.containers.col) end
end
for i=idx+1, LOOT_MAX do loot_pool[i].text.Visible=false; loot_pool[i].line.Visible=false end
end)
local stats_p = {
enabled=false, fov=260, x=24, y=170, avatar=true,
accent=Color3.fromRGB(190,60,255), rainbow=false,
}
local STW, STH = 430, 128
local ST_PAD, ST_AV, ST_ROWH = 12, 76, 18
local function st_text(sz) return esp_obj("Text",{Visible=false,Size=sz,Font=Drawing.Fonts.Monospace,Outline=true,Color=Color3.new(1,1,1),ZIndex=93}) end
local st = {
bg = esp_obj("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(15,14,20),Transparency=0.92,ZIndex=90}),
accent = esp_obj("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(190,60,255),Transparency=1,ZIndex=91}),
border = esp_obj("Square",{Visible=false,Filled=false,Thickness=1,Color=Color3.fromRGB(190,60,255),Transparency=1,ZIndex=91}),
hp_bg = esp_obj("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(35,32,42),Transparency=1,ZIndex=91}),
hp_fl = esp_obj("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(80,220,110),Transparency=1,ZIndex=92}),
hp_txt = esp_obj("Text",{Visible=false,Size=13,Center=true,Font=Drawing.Fonts.Monospace,Outline=true,Color=Color3.new(1,1,1),ZIndex=93}),
}
local ST_LABELS = {"user","kd","playtime","tool","dist","status","reports","faction"}
st.cell = {}
for i=1,8 do st.cell[i] = { l=st_text(14), v=st_text(14) }; st.cell[i].l.Color=Color3.fromRGB(150,150,162) end
local st_gui, st_avatar
local function st_ensure_avatar()
if st_avatar then return end
st_gui = Instance.new("ScreenGui")
st_gui.Name = "Intel_"..tostring(math.random(100000,999999))
st_gui.IgnoreGuiInset = true; st_gui.ResetOnSpawn = false; st_gui.DisplayOrder = 9
pcall(function() st_gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
st_avatar = Instance.new("ImageLabel")
st_avatar.BackgroundColor3 = Color3.fromRGB(10,9,14); st_avatar.BackgroundTransparency = 0.1
st_avatar.BorderSizePixel = 0; st_avatar.Size = UDim2.fromOffset(ST_AV,ST_AV); st_avatar.Visible = false
st_avatar.Parent = st_gui
end
local function fmt_time(sec)
sec = tonumber(sec) or 0
local h = mathfloor(sec/3600); local m = mathfloor((sec%3600)/60)
if h > 0 then return h.."h "..m.."m" end
if m > 0 then return m.."m" end
return mathfloor(sec).."s"
end
local function target_stats(plr)
local P = _FindFirstChild(ReplicatedStorage.Players, plr.Name)
local status = P and _FindFirstChild(P,"Status")
local jr = status and _FindFirstChild(status,"Journey")
local sta = jr and _FindFirstChild(jr,"Statistics")
local uac = status and _FindFirstChild(status,"UAC")
local kills = sta and sta:GetAttribute("Kills") or 0
local deaths = sta and sta:GetAttribute("Deaths") or 0
local faction = jr and _FindFirstChild(jr,"Faction") and jr.Faction:GetAttribute("CurrentFaction")
local clan = jr and _FindFirstChild(jr,"Clan") and jr.Clan:GetAttribute("CurrentClan")
faction = (faction ~= nil and faction ~= "") and faction or (clan and clan ~= "nil" and clan ~= "" and clan) or "Solo"
return {
kills = kills, deaths = deaths,
kd = deaths > 0 and string.format("%.2f", kills/deaths) or tostring(kills),
playtime = fmt_time(sta and sta:GetAttribute("TimePlayed")),
reports = uac and _FindFirstChild(uac,"Reports") and #uac.Reports:GetChildren() or 0,
faction = faction,
}
end
local function st_target()
local best, bd = nil, stats_p.fov
local mp = _Vector2new(Mouse.X, Mouse.Y)
for _, plr in ipairs(Players:GetPlayers()) do
local ch = plr ~= LocalPlayer and plr.Character
local hd = ch and _FindFirstChild(ch,"Head")
local hum = ch and _FindFirstChildOfClass(ch,"Humanoid")
if hd and hum and hum.Health > 0 then
local sp, on = _WTV(Camera, hd.Position)
if on then
local d = (_Vector2new(sp.X, sp.Y - GuiInset.Y) - mp).Magnitude
if d < bd then best, bd = plr, d end
end
end
end
return best
end
local function st_hide()
for k, o in pairs(st) do
if k == "cell" then
for _, c in ipairs(o) do c.l.Visible = false; c.v.Visible = false end
elseif o.Visible ~= nil then o.Visible = false end
end
if st_avatar then st_avatar.Visible = false end
end
new_renderstepped(function()
if not stats_p.enabled then return st_hide() end
local plr = st_target()
if not plr then return st_hide() end
local ch = plr.Character
local hum = ch and _FindFirstChildOfClass(ch,"Humanoid")
local hd = ch and _FindFirstChild(ch,"Head")
if not (hum and hd) then return st_hide() end
local x, y = stats_p.x, stats_p.y
local ac = stats_p.rainbow and rgb() or stats_p.accent
local P, AV = ST_PAD, ST_AV
local d = target_stats(plr)
local dist = mathround((Camera.CFrame.p - hd.Position).Magnitude/3)
local vis = is_visible(Camera.CFrame, ch, hd)
st.bg.Position = _Vector2new(x,y); st.bg.Size = _Vector2new(STW,STH); st.bg.Visible = true
st.border.Position = _Vector2new(x,y); st.border.Size = _Vector2new(STW,STH); st.border.Color = ac; st.border.Visible = true
st.accent.Position = _Vector2new(x,y); st.accent.Size = _Vector2new(STW,3); st.accent.Color = ac; st.accent.Visible = true
if stats_p.avatar then
st_ensure_avatar()
if st_avatar then
st_avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..plr.UserId.."&w=150&h=150"
st_avatar.Position = UDim2.fromOffset(x+P, y+P)
st_avatar.Visible = true
end
elseif st_avatar then st_avatar.Visible = false end
local avOff = stats_p.avatar and (AV + 14) or 0
local rx = x + P + avOff
local colW = (x + STW - P - rx) / 2
local vals = { plr.DisplayName, d.kd.." ("..d.kills.."/"..d.deaths..")", d.playtime, get_gun(plr),
dist.."m", vis and "Visible" or "Hidden", tostring(d.reports), d.faction }
for i=1,8 do
local col = i <= 4 and 0 or 1
local row = (i-1) % 4
local labelX = rx + col*colW
local valRight = rx + (col+1)*colW - 10
local cy = y + P + 2 + row*ST_ROWH
local cell = st.cell[i]
cell.l.Text = ST_LABELS[i]; cell.l.Position = _Vector2new(labelX, cy); cell.l.Visible = true
cell.v.Text = vals[i]
cell.v.Position = _Vector2new(valRight - cell.v.TextBounds.X, cy)
cell.v.Color = (i==6 and (vis and Color3.fromRGB(90,220,110) or Color3.fromRGB(235,80,80)))
or (i==7 and d.reports > 0 and Color3.fromRGB(235,140,60))
or Color3.new(1,1,1)
cell.v.Visible = true
end
local hpPct = math.clamp(hum.Health / (hum.MaxHealth > 0 and hum.MaxHealth or 100), 0, 1)
local barX, barY, barW = x+P, y+P+AV+8, STW-2*P
st.hp_bg.Position = _Vector2new(barX, barY); st.hp_bg.Size = _Vector2new(barW, 16); st.hp_bg.Visible = true
st.hp_fl.Position = _Vector2new(barX, barY); st.hp_fl.Size = _Vector2new(barW*hpPct, 16)
st.hp_fl.Color = Color3.fromRGB(mathfloor(235*(1-hpPct))+20, mathfloor(200*hpPct)+30, 60); st.hp_fl.Visible = true
st.hp_txt.Text = mathfloor(hum.Health).." / "..mathfloor(hum.MaxHealth); st.hp_txt.Position = _Vector2new(x+STW*0.5, barY+1); st.hp_txt.Visible = true
end)
local cursor = {
Enabled=false, Speed=5, Radius=25, Color=Color3.fromRGB(180,50,255),
Thickness=1.7, Outline=false, Resize=false, Dot=false, Gap=10, TheGap=false,
Font=Drawing.Fonts.Monospace, rainbow=false,
Text={Logo=false,LogoColor=Color3.new(1,1,1),Name=false,NameColor=Color3.new(1,1,1),LogoFadingOffset=0}
}
local ch_lines = {}
local ch_ol = Drawing.new("Square"); ch_ol.Visible=true; ch_ol.Size=_Vector2new(4,4); ch_ol.Color=Color3.new(); ch_ol.Filled=true; ch_ol.ZIndex=1; ch_ol.Transparency=1
local ch_dot = Drawing.new("Square"); ch_dot.Visible=true; ch_dot.Size=_Vector2new(2,2); ch_dot.Color=cursor.Color; ch_dot.Filled=true; ch_dot.ZIndex=2; ch_dot.Transparency=1
local ch_logo = Drawing.new("Text"); ch_logo.Visible=false; ch_logo.Font=cursor.Font; ch_logo.Size=13; ch_logo.Color=Color3.fromRGB(138,128,255); ch_logo.ZIndex=3; ch_logo.Transparency=1; ch_logo.Text="kalihub.xyz"; ch_logo.Center=true; ch_logo.Outline=true
local ch_ind = Drawing.new("Text"); ch_ind.Visible=false; ch_ind.Font=cursor.Font; ch_ind.Size=13; ch_ind.Color=Color3.new(1,1,1); ch_ind.ZIndex=3; ch_ind.Transparency=1; ch_ind.Text=""; ch_ind.Center=true; ch_ind.Outline=true
for i=1,4 do
local l1=Drawing.new("Line"); l1.Visible=true; l1.From=_Vector2new(200,500); l1.To=_Vector2new(200,500); l1.Color=cursor.Color; l1.Thickness=cursor.Thickness; l1.ZIndex=2; l1.Transparency=1
local l2=Drawing.new("Line"); l2.Visible=true; l2.From=_Vector2new(200,500); l2.To=_Vector2new(200,500); l2.Color=Color3.new(); l2.Thickness=cursor.Thickness+2.5; l2.ZIndex=1; l2.Transparency=1
local l3=Drawing.new("Line"); l3.Visible=true; l3.From=_Vector2new(200,500); l3.To=_Vector2new(200,500); l3.Color=cursor.Color; l3.Thickness=cursor.Thickness; l3.ZIndex=2; l3.Transparency=1
ch_lines[i] = {l1, l2, l3}
end
local ch_ang,ch_tr,ch_rev,ch_rb = 0,0,false,0
local mcos,mpi,msin = math.cos,math.pi,math.sin
new_renderstepped(function(dt)
if not cursor.Enabled then
ch_dot.Visible=false; ch_ol.Visible=false; ch_logo.Visible=false; ch_ind.Visible=false
for _,l in pairs(ch_lines) do l[1].Visible=false; l[2].Visible=false; l[3].Visible=false end
return
end
ch_rb = (ch_rb + dt*0.5) % 1
local color = cursor.rainbow and Color3.fromHSV(ch_rb,1,1) or cursor.Color
local pos = _Vector2new(Mouse.X, Mouse.Y + GuiInset.Y)
local lfo = cursor.Text.LogoFadingOffset
if not ch_rev then
ch_tr = ch_tr + cursor.Speed*10*dt
if ch_tr >= 1.5+lfo then ch_rev=true end
else
ch_tr = ch_tr - cursor.Speed*10*dt
if ch_tr <= -lfo then ch_rev=false end
end
ch_logo.Position=_Vector2new(pos.X,(pos+_Vector2new(0,cursor.Radius+5)).Y)
ch_logo.Transparency=ch_tr; ch_logo.Visible=cursor.Text.Logo; ch_logo.Color=cursor.Text.LogoColor; ch_logo.Font=cursor.Font
ch_ind.Position=_Vector2new(pos.X,(pos+_Vector2new(0,cursor.Radius+(cursor.Text.Logo and 19 or 5))).Y)
ch_ind.Visible=silent_aim.indicator; ch_ind.Color=cursor.Text.NameColor; ch_ind.Font=cursor.Font; ch_ind.Text=silent_aim.indicator_text
ch_ang = (ch_ang + cursor.Speed*10*dt) % 90
ch_dot.Visible=cursor.Dot; ch_dot.Color=color; ch_dot.Position=_Vector2new(pos.X-1,pos.Y-1)
ch_ol.Visible=cursor.Outline and cursor.Dot; ch_ol.Position=_Vector2new(pos.X-2,pos.Y-2)
for idx, line in pairs(ch_lines) do
local R=cursor.Radius; local a=ch_ang+(idx*(mpi/2))
local gp = cursor.TheGap and (R-20)/cursor.Gap or (R-20)-cursor.Gap
local x,y,x1,y1
if cursor.Resize then
x={pos.X+mcos(a)*(R+R*msin(ch_ang)/9), pos.X+mcos(a)*((R-20)-(cursor.TheGap and (R-20)*mcos(ch_ang)/4 or (R-20)*mcos(ch_ang)-4))}
y={pos.Y+msin(a)*(R+R*msin(ch_ang)/9), pos.Y+msin(a)*((R-20)-(cursor.TheGap and (R-20)*mcos(ch_ang)/4 or (R-20)*mcos(ch_ang)-4))}
else
x={pos.X+mcos(a)*R, pos.X+mcos(a)*((R-20)-gp)}
y={pos.Y+msin(a)*R, pos.Y+msin(a)*((R-20)-gp)}
end
x1={pos.X+mcos(a)*(R+1), pos.X+mcos(a)*((R-19)-(cursor.TheGap and (R-19)/cursor.Gap or (R-19)-cursor.Gap))}
y1={pos.Y+msin(a)*(R+1), pos.Y+msin(a)*((R-19)-(cursor.TheGap and (R-19)/cursor.Gap or (R-19)-cursor.Gap))}
line[1].Visible=true; line[1].Color=color; line[1].From=_Vector2new(x[2],y[2]); line[1].To=_Vector2new(x[1],y[1]); line[1].Thickness=cursor.Thickness
line[2].Visible=cursor.Outline; line[2].From=_Vector2new(x1[2],y1[2]); line[2].To=_Vector2new(x1[1],y1[1]); line[2].Thickness=cursor.Thickness+2.5
line[3].Visible=false
end
end)
local no_shadows = false
local fullbright = false
new_heartbeat(function()
Lighting.GlobalShadows = not no_shadows
if fullbright then
Lighting.Ambient = Color3.new(1,1,1)
Lighting.OutdoorAmbient = Color3.new(1,1,1)
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.FogEnd = 100000
end
end)
local fov_en=false; local fov_sz=70
local arm_ch_en=false; local arm_ch_col=Color3.new(1,1,1); local arm_ch_mat="SmoothPlastic"; local arm_ch_rb=false
local gun_ch_en=false; local gun_ch_col=Color3.new(1,1,1); local gun_ch_mat="SmoothPlastic"; local gun_ch_rb=false
local function vmchams()
local vm = _FindFirstChildOfClass(Camera,"Model"); if not vm then return end
local Item = _FindFirstChild(vm,"Item")
if Item and gun_ch_en then
local gc = gun_ch_rb and rgb() or gun_ch_col
for _,v in pairs(Item:GetDescendants()) do
if v.ClassName=="MeshPart" or v.ClassName=="Part" then
v.Material=Enum.Material[gun_ch_mat]; v.Color=gc
end
local sa=_FindFirstChildOfClass(v,"SurfaceAppearance"); if sa then sa:Destroy() end
end
end
if arm_ch_en then
local ac = arm_ch_rb and rgb() or arm_ch_col
for _,item in pairs(vm:GetChildren()) do
if item.ClassName=="MeshPart" and (item.Name:find("Hand") or item.Name:find("Arm")) then
item.Material=Enum.Material[arm_ch_mat]; item.Color=ac
end
if item.ClassName=="Model" and (_FindFirstChild(item,"LL") or _FindFirstChild(item,"LH")) then
for _,sub in pairs(item:GetChildren()) do
local sa=_FindFirstChildOfClass(sub,"SurfaceAppearance"); if sa then sa:Destroy() end
sub.Material=Enum.Material[arm_ch_mat]; sub.Color=ac
end
end
end
end
end
Camera.DescendantAdded:Connect(function() vmchams() end)
new_renderstepped(function()
if (arm_ch_en and arm_ch_rb) or (gun_ch_en and gun_ch_rb) then vmchams() end
end)
local function get_char() local c = LocalPlayer.Character return c, c and _FindFirstChild(c,"HumanoidRootPart"), c and _FindFirstChildOfClass(c,"Humanoid") end
local tp = {on=false, dist=8, side=2, height=1}
local zoom = {on=false, fov=30, key=Enum.KeyCode.V, orig=nil}
local freecam = {on=false, speed=70, sens=0.4, yaw=0, pitch=0, pos=Vector3.zero, oldtype=nil}
local function freecam_set(on)
local _, hrp = get_char()
if on then
freecam.oldtype = Camera.CameraType
freecam.pos = Camera.CFrame.Position
local _, ry = Camera.CFrame:ToEulerAnglesYXZ()
freecam.yaw, freecam.pitch = ry, 0
Camera.CameraType = Enum.CameraType.Scriptable
if hrp then hrp.Anchored = true end
else
if freecam.oldtype then Camera.CameraType = freecam.oldtype end
if hrp then hrp.Anchored = false end
UIS.MouseBehavior = Enum.MouseBehavior.Default
end
end
new_renderstepped(function(dt)
if freecam.on then
if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
UIS.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
local md = UIS:GetMouseDelta()
freecam.yaw = freecam.yaw - md.X * freecam.sens * 0.01
freecam.pitch = math.clamp(freecam.pitch - md.Y * freecam.sens * 0.01, -1.5, 1.5)
else
UIS.MouseBehavior = Enum.MouseBehavior.Default
end
local rot = CFrame.fromEulerAnglesYXZ(freecam.pitch, freecam.yaw, 0)
local look = CFrame.new(freecam.pos) * rot
local mv = Vector3.zero
if UIS:IsKeyDown(Enum.KeyCode.W) then mv += look.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.S) then mv -= look.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then mv += look.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.A) then mv -= look.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.yAxis end
if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then mv -= Vector3.yAxis end
if mv.Magnitude > 0 then freecam.pos += mv.Unit * freecam.speed * dt end
Camera.CFrame = CFrame.new(freecam.pos) * rot
return
end
if tp.on then Camera.CFrame = Camera.CFrame * _CFramenew(tp.side, tp.height, tp.dist) end
end)
RunService:BindToRenderStep("KH_FOV", Enum.RenderPriority.Camera.Value + 1, function()
if fov_en then Camera.FieldOfView = fov_sz end
if zoom.on and UIS:IsKeyDown(zoom.key) then
if not zoom.orig then zoom.orig = Camera.FieldOfView end
Camera.FieldOfView = zoom.fov
elseif zoom.orig then
Camera.FieldOfView = zoom.orig
zoom.orig = nil
end
end)
local RS_Players = ReplicatedStorage:WaitForChild("Players")
local UpdateTilt = ReplicatedStorage.Remotes:FindFirstChild("UpdateTilt")
local notify_draw = esp_obj("Text", {Center=true, Outline=true, Size=18, Font=Drawing.Fonts.Monospace, Visible=false, ZIndex=200})
local notify_until = 0
local function Notify(txt, dur) notify_draw.Text = txt; notify_draw.Color = Color3.fromRGB(120,200,255); notify_until = tick() + (dur or 2.5) end
new_renderstepped(function()
if tick() < notify_until then
local vp = Camera.ViewportSize
notify_draw.Position = _Vector2new(vp.X*0.5, vp.Y*0.18); notify_draw.Visible = true
else notify_draw.Visible = false end
end)
local function get_local_weapon()
local P = _FindFirstChild(RS_Players, LocalPlayer.Name)
local gv = P and _FindFirstChild(P,"Status") and _FindFirstChild(P.Status,"GameplayVariables")
local et = gv and _FindFirstChild(gv,"EquippedTool")
if et and et.Value then return tostring(et.Value) end
return "None"
end
packet = {autoshoot=false, prediction=false, speed=1.0}
local packet_debounce = 0
local function shoot_weapon_packet()
local tgt = silent_aim.target_part; if not tgt then return end
local weapon = get_local_weapon(); if weapon == "None" then return end
local P = _FindFirstChild(RS_Players, LocalPlayer.Name)
local inv = P and _FindFirstChild(P, "Inventory")
local inv_weapon = inv and _FindFirstChild(inv, weapon)
local sm = inv_weapon and _FindFirstChild(inv_weapon, "SettingsModule")
if not sm then return end
local ok, settings = pcall(require, sm); if not ok then return end
local fr = rawget(settings, "FireRate")
if not fr or packet_debounce > tick() then return end
local origin = Camera.CFrame.p
local aim_pos = tgt.Position
if packet.prediction then aim_pos = predict_velocity(origin, tgt.Position, tgt.Velocity, 2000) end
local dir = (aim_pos - origin).Unit
local rnd = math.random(-100000, 100000)
local delay = tick() - ((aim_pos - origin).Magnitude / 1000)
if FireProjectile:InvokeServer(dir, rnd, delay) then
ProjectileInflict:FireServer(tgt, tgt.CFrame:ToObjectSpace(CFrame.new(0, 0.0001, 0)), rnd, tick())
end
packet_debounce = tick() + fr * packet.speed
end
new_heartbeat(function() if packet.autoshoot then shoot_weapon_packet() end end)
tpkill = {enabled=false, height=40, autolook=false, autotbot=false, last_used=0, orig=nil, target=nil, platform=nil}
local function tpkill_set(v)
local char = LocalPlayer.Character
local hrp = char and _FindFirstChild(char, "HumanoidRootPart")
if not hrp then tpkill.enabled = false; return end
if v then
if tick() - tpkill.last_used < 5 then tpkill.enabled = false; Notify("TP Kill on cooldown"); return end
local tgt = silent_aim.target_part
if not tgt then tpkill.enabled = false; Notify("TP Kill: no target"); return end
tpkill.enabled, tpkill.target, tpkill.orig, tpkill.start = true, tgt, hrp.CFrame, tick()
local plat = Instance.new("Part")
plat.Size = Vector3.new(10,1,10); plat.Anchored = true; plat.CanCollide = true; plat.Transparency = 1
plat.Position = tgt.Position + Vector3.new(0, tpkill.height - 3, 0); plat.Parent = workspace
tpkill.platform = plat
hrp.CFrame = CFrame.new(tgt.Position + Vector3.new(0, tpkill.height, 0)) * hrp.CFrame.Rotation
Notify("TP Kill: teleported")
else
local orig = tpkill.orig
if orig then
tpkill.last_used = tick()
hrp.CFrame = orig + Vector3.new(0, 2, 0)
hrp.AssemblyLinearVelocity = Vector3.zero
local hum = _FindFirstChildOfClass(char, "Humanoid"); if hum then hum:ChangeState(Enum.HumanoidStateType.Landed) end
tpkill.orig, tpkill.target = nil, nil
if tpkill.platform then tpkill.platform:Destroy(); tpkill.platform = nil end
Notify("TP Kill: returned")
end
tpkill.enabled = false
end
end
new_renderstepped(function()
if tpkill.enabled and tpkill.autolook and tpkill.target and tpkill.target.Parent then
Camera.CFrame = CFrame.new(Camera.CFrame.Position, tpkill.target.Position)
end
end)
aa = {enabled=false, mode="Reverse", yaw=0, pitch=0, fakelag=false, fakelag_int=0.4,
floor_clip=false, floor_depth=3, custom_offset=false, custom_radius=2,
visualize=false, vis_color=Color3.fromRGB(255,50,50), vis_trans=0.5, resolve_desync=false}
local aa_real_cf, aa_fakelag_cf, aa_last_fl, aa_dead, aa_vis = nil, nil, 0, false, nil
LocalPlayer.CharacterAdded:Connect(function() aa_dead = true; task.delay(0.5, function() aa_dead = false end) end)
RunService:BindToRenderStep("KH_AARestore", Enum.RenderPriority.Camera.Value + 1, function()
if not (aa.enabled or aa.fakelag) or aa_dead or freecam.on or tpkill.enabled then return end
local char = LocalPlayer.Character; local hrp = char and _FindFirstChild(char, "HumanoidRootPart")
if hrp and aa_real_cf then
local lv, av = hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity
hrp.CFrame = aa_real_cf; hrp.AssemblyLinearVelocity = lv; hrp.AssemblyAngularVelocity = av
end
end)
new_heartbeat(function()
if not (aa.enabled or aa.fakelag) or aa_dead or freecam.on or tpkill.enabled then return end
local char = LocalPlayer.Character; if not char then return end
local hum = _FindFirstChildOfClass(char, "Humanoid"); local hrp = _FindFirstChild(char, "HumanoidRootPart")
if not hum or not hrp then return end
if hum.Health <= 0 then aa_dead = true; aa_fakelag_cf = nil; return end
pcall(function()
if aa.enabled then
hum.AutoRotate = false
hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
end
aa_real_cf = hrp.CFrame
if aa.fakelag then
if tick() - aa_last_fl >= aa.fakelag_int then aa_last_fl = tick(); aa_fakelag_cf = hrp.CFrame end
else aa_fakelag_cf = nil end
local cam = Camera.CFrame.LookVector
local base = -math.atan2(cam.Z, cam.X)
local Angle = base + math.rad(-90)
if aa.mode == "Random" then Angle = base + math.rad(90) + math.rad(math.random(-120,120))
elseif aa.mode == "FlatRandom" then Angle = math.rad(math.random(0,360))
elseif aa.mode == "Spin" then Angle = base + tick()*100 % 360
elseif aa.mode == "Reverse" then Angle = base + math.rad(90) end
local Offset = math.rad(aa.yaw)
local Angled = CFrame.new(hrp.Position) * CFrame.Angles(0, Angle + Offset, 0)
if (aa.mode == "Reverse" or aa.mode == "Random") and silent_aim.target_part then
local ao = aa.mode == "Random" and math.rad(math.random(-120,120)) or 0
Angled = CFrame.new(hrp.Position, silent_aim.target_part.Position) * CFrame.Angles(0, math.rad(180) + Offset + ao, 0)
end
local pos_offset = aa.floor_clip and Vector3.new(0, -aa.floor_depth, 0) or Vector3.new(0, 0.2, 0)
if aa.custom_offset then
local rd = Vector3.new(math.random()-0.5, math.random()-0.5, math.random()-0.5)
if rd.Magnitude > 0 then pos_offset = pos_offset + rd.Unit * (math.random() * aa.custom_radius) end
end
local spoof_pos = (aa.fakelag and aa_fakelag_cf and aa_fakelag_cf.Position or hrp.Position) + pos_offset
if aa.enabled then
local _, Y = Angled:ToOrientation()
if aa.mode == "FlatRandom" then hrp.CFrame = CFrame.new(spoof_pos) * CFrame.Angles(0, Y, 0) * CFrame.Angles(math.rad(90), 0, 0)
else hrp.CFrame = CFrame.new(spoof_pos) * CFrame.Angles(0, Y, 0) end
elseif aa.fakelag and aa_fakelag_cf then hrp.CFrame = aa_fakelag_cf end
if aa.visualize then
if not aa_vis then aa_vis = Instance.new("Part"); aa_vis.Anchored=true; aa_vis.CanCollide=false; aa_vis.CanQuery=false; aa_vis.Material=Enum.Material.ForceField; aa_vis.Size=Vector3.new(2,5,1); aa_vis.Parent=workspace end
aa_vis.Color = aa.vis_color; aa_vis.Transparency = aa.vis_trans; aa_vis.CFrame = CFrame.new(spoof_pos)
elseif aa_vis then aa_vis.Transparency = 1 end
local pitch = aa.mode == "FlatRandom" and 250 or aa.pitch
if UpdateTilt then UpdateTilt:FireServer(pitch) end
end)
end)
new_renderstepped(function()
if not aa.resolve_desync then return end
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer then
local ch = plr.Character; local root = ch and _FindFirstChild(ch, "HumanoidRootPart")
local P = _FindFirstChild(RS_Players, plr.Name)
local uac = P and _FindFirstChild(P, "Status") and _FindFirstChild(P.Status, "UAC")
if root and uac then
local lp = uac:GetAttribute("LastVerifiedPos")
if lp then root.CFrame = (root.CFrame - root.Position) + lp end
end
end
end
end)
sec.silentaim:CreateToggle("Silent Aim", false, function(v) silent_aim.enabled=v end)
sec.silentaim:CreateToggle("Target NPCs", false, function(v) silent_aim.target_ai=v end)
sec.silentaim:CreateToggle("Randomize Hit Part",false, function(v) silent_aim.random_part=v end)
sec.silentaim:CreateToggle("Visible Check", false, function(v) silent_aim.visible_check=v end)
sec.silentaim:CreateToggle("Indicator", false, function(v) silent_aim.indicator=v end)
sec.silentaim:CreateDropdown("Aim Part", {"Head","FaceHitBox","HeadTopHitbox","UpperTorso","LowerTorso","HumanoidRootPart","LeftFoot","LeftLowerLeg","LeftUpperLeg","LeftHand","LeftLowerArm","LeftUpperArm","RightFoot","RightLowerLeg","RightUpperLeg","RightHand","RightLowerArm","RightUpperArm"}, function(v) silent_aim.part=v end, "Head", false)
sec.silentaim:CreateToggle("Use FOV", false, function(v) silent_aim.fov=v end)
sec.silentaim:CreateToggle("Show FOV", false, function(v) silent_aim.fov_show=v end)
sec.silentaim:CreateToggle("FOV Outline", false, function(v) silent_aim.fov_outline=v end)
sec.silentaim:CreateColorpicker("FOV Color", function(c) silent_aim.fov_color=c end)
sec.silentaim:CreateToggle("FOV Rainbow", false, function(v) silent_aim.fov_rainbow=v end)
sec.silentaim:CreateSlider("FOV Size", 10, 1000, 100, true, function(v) silent_aim.fov_size=v end)
sec.weaponmods:CreateToggle("No Recoil", false, function(v) no_recoil=v end)
sec.weaponmods:CreateToggle("No Spread", false, function(v) set_no_spread(v) end)
sec.weaponmods:CreateToggle("Rapid Fire", false, function(v) rapid.enabled=v end)
sec.weaponmods:CreateSlider("Fire Rate Mult %", 5, 100, 50, true, function(v) rapid.mult=v/100 end)
sec.weaponmods:CreateToggle("Instant Reload", false, function(v) instant.reload=v end)
sec.weaponmods:CreateToggle("Instant Equip", false, function(v) instant.equip=v end)
sec.weaponmods:CreateToggle("Instant Aim", false, function(v) instant.aim=v end)
sec.weaponmods:CreateToggle("Instant Bullet", false, function(v) set_instant_bullet(v) end)
sec.weaponmods:CreateToggle("Force Auto", false, function(v) forceauto=v end)
sec.trigbot:CreateToggle("Triggerbot", false, function(v) trigger.on=v end)
sec.trigbot:CreateToggle("Visible Only", true, function(v) trigger.visible_only=v end)
sec.ragebot:CreateToggle("Enable Ragebot", false, function(v) rage.enabled=v end)
sec.ragebot:CreateToggle("Auto Fire", false, function(v) rage.autofire=v end)
sec.ragebot:CreateDropdown("Fire Trigger", {"While Aiming","Always"}, function(v) rage.trigger=v end, "While Aiming", false)
sec.ragebot:CreateDropdown("Aim Part", {"Head","FaceHitBox","HeadTopHitbox","UpperTorso","LowerTorso","HumanoidRootPart"}, function(v) rage.part=v end, "Head", false)
sec.ragebot:CreateSlider("FOV (0 = full screen)", 0, 1000, 0, true, function(v) rage.fov=v end)
sec.ragebot:CreateToggle("Target NPCs", false, function(v) rage.target_npcs=v end)
sec.ragebot:CreateToggle("Visible Only", true, function(v) rage.visible_check=v end)
local ch_en_tog = sec.crosshair:CreateToggle("Enable Crosshair", false, function(v) cursor.Enabled=v end)
sec.crosshair:CreateColorpicker("Color", function(c) cursor.Color=c end, false, false, ch_en_tog)
sec.crosshair:CreateSlider("Speed", 0.1, 15, 3, false, function(v) cursor.Speed=v/10 end)
sec.crosshair:CreateSlider("Radius", 0.1, 100, 25, false, function(v) cursor.Radius=v end)
sec.crosshair:CreateSlider("Thickness", 0.1, 10, 1.5, false, function(v) cursor.Thickness=v end)
sec.crosshair:CreateSlider("Gap", 0, 50, 5, false, function(v) cursor.Gap=v end)
sec.crosshair:CreateToggle("Math Gap", false, function(v) cursor.TheGap=v end)
sec.crosshair:CreateToggle("Outline", false, function(v) cursor.Outline=v end)
sec.crosshair:CreateToggle("Resize Anim", false, function(v) cursor.Resize=v end)
sec.crosshair:CreateToggle("Dot", false, function(v) cursor.Dot=v end)
sec.crosshair:CreateToggle("Rainbow", false, function(v) cursor.rainbow=v end)
sec.crosshair:CreateToggle("Text Logo", false, function(v) cursor.Text.Logo=v end)
sec.crosshair:CreateColorpicker("Logo Color", function(c) cursor.Text.LogoColor=c end)
sec.crosshair:CreateToggle("Text Name", false, function(v) cursor.Text.Name=v end)
sec.crosshair:CreateColorpicker("Name Color", function(c) cursor.Text.NameColor=c end)
sec.crosshair:CreateSlider("Logo Fade Offset", 0, 5, 0, false, function(v) cursor.Text.LogoFadingOffset=v end)
sec.crosshair:CreateDropdown("Font", {"UI","System","Plex","Monospace"}, function(v) cursor.Font=Drawing.Fonts[v] end, "Monospace", false)
sec.world:CreateToggle("Fullbright", false, function(v) fullbright=v end)
sec.world:CreateToggle("No Fog", false, function(_) end)
sec.world:CreateToggle("No Grass", false, function(v) sethiddenproperty(_FindFirstChildOfClass(workspace,"Terrain"), "Decoration", not v) end)
sec.world:CreateToggle("No Shadows", false, function(v) no_shadows=v end)
local fov_tog = sec.othervis:CreateToggle("Custom FOV", false, function(v)
fov_en=v
if fov_en then Camera.FieldOfView = fov_sz end
end)
sec.othervis:CreateSlider("FOV Size", 0, 120, 70, true, function(v) fov_sz=v end)
sec.othervis:CreateToggle("Arm Chams", false, function(v) arm_ch_en=v end)
sec.othervis:CreateColorpicker("Arm Color", function(c) arm_ch_col=c end)
sec.othervis:CreateToggle("Arm Rainbow", false, function(v) arm_ch_rb=v end)
sec.othervis:CreateDropdown("Arm Material", {"ForceField","Neon","SmoothPlastic","Glass"}, function(v) arm_ch_mat=v end, "SmoothPlastic", false)
sec.othervis:CreateToggle("Gun Chams", false, function(v) gun_ch_en=v end)
sec.othervis:CreateColorpicker("Gun Color", function(c) gun_ch_col=c end)
sec.othervis:CreateToggle("Gun Rainbow", false, function(v) gun_ch_rb=v end)
sec.othervis:CreateDropdown("Gun Material", {"ForceField","Neon","SmoothPlastic","Glass"}, function(v) gun_ch_mat=v end, "SmoothPlastic", false)
sec.playeresp:CreateToggle("Enable ESP", false, function(v) esp_set.enemy.enabled=v; esp_icaca() end)
sec.playeresp:CreateToggle("Show Players", true, function(v) esp_set.enemy.show_players=v; esp_icaca() end)
sec.playeresp:CreateToggle("Show NPCs", true, function(v) esp_set.enemy.show_npcs=v; esp_icaca() end)
sec.playeresp:CreateToggle("Box", false, function(v) esp_set.enemy.box=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Box Color", function(c) esp_set.enemy.box_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Box Transparency", 0, 1, 0, false, function(v) esp_set.enemy.box_color[2]=1-v; esp_icaca() end)
sec.playeresp:CreateToggle("Box Fill", false, function(v) esp_set.enemy.box_fill=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Box Fill Color", function(c) esp_set.enemy.box_fill_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Box Fill Transparency", 0, 1, 0.5, false, function(v) esp_set.enemy.box_fill_color[2]=1-v; esp_icaca() end)
sec.playeresp:CreateToggle("Box Outline", false, function(v) esp_set.enemy.box_outline=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Box Outline Color", function(c) esp_set.enemy.box_outline_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Box Outline Transparency", 0, 1, 0, false, function(v) esp_set.enemy.box_outline_color[2]=1-v; esp_icaca() end)
sec.playeresp:CreateToggle("Name", false, function(v) esp_set.enemy.realname=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Name Color", function(c) esp_set.enemy.realname_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Name Transparency", 0, 1, 0, false, function(v) esp_set.enemy.realname_color[2]=1-v; esp_icaca() end)
sec.playeresp:CreateToggle("Name Outline", false, function(v) esp_set.enemy.realname_outline=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Name Outline Color", function(c) esp_set.enemy.realname_outline_color=c; esp_icaca() end)
sec.playeresp:CreateToggle("Display Name", false, function(v) esp_set.enemy.displayname=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Display Name Color", function(c) esp_set.enemy.displayname_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Display Name Transparency",0, 1, 0, false, function(v) esp_set.enemy.displayname_color[2]=1-v; esp_icaca() end)
sec.playeresp:CreateToggle("Health", false, function(v) esp_set.enemy.health=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Health Color", function(c) esp_set.enemy.health_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Health Transparency", 0, 1, 0, false, function(v) esp_set.enemy.health_color[2]=1-v; esp_icaca() end)
sec.playeresp:CreateToggle("Distance", false, function(v) esp_set.enemy.dist=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Distance Color", function(c) esp_set.enemy.dist_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Distance Transparency", 0, 1, 0, false, function(v) esp_set.enemy.dist_color[2]=1-v; esp_icaca() end)
sec.playeresp:CreateToggle("Weapon", false, function(v) esp_set.enemy.weapon=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Weapon Color", function(c) esp_set.enemy.weapon_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Weapon Transparency", 0, 1, 0, false, function(v) esp_set.enemy.weapon_color[2]=1-v; esp_icaca() end)
sec.playeresp:CreateToggle("Skeleton", false, function(v) esp_set.enemy.skeleton=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Skeleton Color", function(c) esp_set.enemy.skeleton_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Skeleton Transparency", 0, 1, 0, false, function(v) esp_set.enemy.skeleton_color[2]=v; esp_icaca() end)
sec.playeresp:CreateToggle("Tracer", false, function(v) esp_set.enemy.tracer=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Tracer Color", function(c) esp_set.enemy.tracer_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Tracer Transparency", 0, 1, 0, false, function(v) esp_set.enemy.tracer_color[2]=1-v; esp_icaca() end)
sec.playeresp:CreateDropdown("Tracer Origin", {"Bottom","Top","Mouse"}, function(v) esp_set.enemy.tracer_from=v end, "Bottom", false)
sec.playeresp:CreateToggle("Chams", false, function(v) esp_set.enemy.chams=v; esp_icaca() end)
sec.playeresp:CreateToggle("Chams Visible Only",false, function(v) esp_set.enemy.chams_visible_only=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Chams Fill Color", function(c) esp_set.enemy.chams_fill_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Chams Fill Transparency", 0, 1, 0.5, false, function(v) esp_set.enemy.chams_fill_color[2]=v; esp_icaca() end)
sec.playeresp:CreateColorpicker("Chams Outline Color",function(c) esp_set.enemy.chamsoutline_color[1]=c; esp_icaca() end)
sec.playeresp:CreateSlider("Chams Outline Transparency",0,1, 0, false, function(v) esp_set.enemy.chamsoutline_color[2]=v; esp_icaca() end)
sec.playeresp:CreateSlider("Font Size", 1, 30, 15, true, function(v) esp_main.textSize=v; esp_icaca() end)
sec.playeresp:CreateDropdown("Font", {"UI","System","Plex","Monospace"}, function(v) esp_main.textFont=Drawing.Fonts[v]; esp_icaca() end, "Monospace", false)
sec.playeresp:CreateToggle("Infinite Range", false, function(v) esp_main.infiniterange=v; esp_icaca() end)
sec.playeresp:CreateToggle("Rainbow", false, function(v) esp_set.enemy.rainbow=v; esp_icaca() end)
sec.loot:CreateToggle("Dropped Items", false, function(v) loot.dropped.on=v end)
sec.loot:CreateColorpicker("Dropped Color", function(c) loot.dropped.col=c end)
sec.loot:CreateToggle("Containers", false, function(v) loot.containers.on=v end)
sec.loot:CreateColorpicker("Container Color", function(c) loot.containers.col=c end)
sec.loot:CreateToggle("Quest Items", false, function(v) loot.quest.on=v end)
sec.loot:CreateColorpicker("Quest Color", function(c) loot.quest.col=c end)
sec.loot:CreateToggle("Show Distance", true, function(v) loot.showdist=v end)
sec.loot:CreateToggle("Tracers", false, function(v) loot.tracer=v end)
sec.loot:CreateColorpicker("Tracer Color", function(c) loot.tracer_col=c end)
sec.loot:CreateToggle("Rainbow", false, function(v) loot.rainbow=v end)
sec.loot:CreateSlider("Max Distance", 50, 1000, 250, true, function(v) loot.maxdist=v end)
sec.loot:CreateSlider("Text Size", 8, 24, 13, true, function(v) loot.textsize=v end)
sec.bullettr:CreateToggle("Force Tracers", false, function(v) btracer.force=v; set_force_tracers(v) end)
sec.bullettr:CreateToggle("Custom Color", false, function(v) btracer.custom=v; if not v then restore_tracer_color() end end)
sec.bullettr:CreateColorpicker("Tracer Color", function(c) btracer.color=c end)
sec.bullettr:CreateToggle("Rainbow", false, function(v) btracer.rainbow=v end)
sec.intel:CreateToggle("Enable Panel", false, function(v) stats_p.enabled=v end)
sec.intel:CreateToggle("Show Avatar", true, function(v) stats_p.avatar=v end)
sec.intel:CreateColorpicker("Accent Color", function(c) stats_p.accent=c end)
sec.intel:CreateToggle("Rainbow", false, function(v) stats_p.rainbow=v end)
sec.intel:CreateSlider("Detection FOV", 50, 600, 260, true, function(v) stats_p.fov=v end)
sec.intel:CreateSlider("Panel X", 0, 1920, 24, true, function(v) stats_p.x=v end)
sec.intel:CreateSlider("Panel Y", 0, 1080, 170, true, function(v) stats_p.y=v end)
sec.cam:CreateToggle("Third Person", false, function(v) tp.on=v end)
sec.cam:CreateSlider("TP Distance", 0, 25, 8, false, function(v) tp.dist=v end)
sec.cam:CreateSlider("TP Side", -10, 10, 2, false, function(v) tp.side=v end)
sec.cam:CreateSlider("TP Height", -10, 10, 1, false, function(v) tp.height=v end)
sec.cam:CreateToggle("Freecam", false, function(v) freecam.on=v; freecam_set(v) end)
sec.cam:CreateSlider("Freecam Speed", 10, 300, 70, true, function(v) freecam.speed=v end)
sec.cam:CreateSlider("Freecam Sensitivity", 1, 20, 4, false, function(v) freecam.sens=v/10 end)
sec.cam:CreateToggle("Zoom (hold key)", false, function(v) zoom.on=v end)
sec.cam:CreateSlider("Zoom FOV", 5, 70, 30, true, function(v) zoom.fov=v end)
sec.cam:CreateDropdown("Zoom Key", {"V","T","Y","H","N","B"}, function(v) zoom.key=Enum.KeyCode[v] end, "T", false)
local RISK = "Risky — high ban chance (UAC + reports). Your account, your risk."
sec.aa_sec:CreateToggle("Anti-Aim", false, function(v)
aa.enabled=v
if not v then local c=LocalPlayer.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); if h then h.AutoRotate=true end end
end, "dangerous", RISK)
sec.aa_sec:CreateDropdown("Mode", {"Reverse","Spin","Random","FlatRandom"}, function(v) aa.mode=v end, "Reverse", false)
sec.aa_sec:CreateSlider("Yaw Offset", -180, 180, 0, false, function(v) aa.yaw=v end)
sec.aa_sec:CreateSlider("Pitch Tilt", -250, 250, 0, false, function(v) aa.pitch=v end)
sec.aa_sec:CreateToggle("Fake Lag", false, function(v) aa.fakelag=v end, "dangerous", RISK)
sec.aa_sec:CreateSlider("Fake Lag Interval", 1, 7, 4, false, function(v) aa.fakelag_int=v/10 end)
sec.aa_sec:CreateToggle("Resolve Desync", false, function(v) aa.resolve_desync=v end, "dangerous", RISK)
sec.aa_opt:CreateToggle("Floor Clip", false, function(v) aa.floor_clip=v end)
sec.aa_opt:CreateSlider("Floor Clip Depth", 0, 50, 30, false, function(v) aa.floor_depth=v/10 end)
sec.aa_opt:CreateToggle("Custom Offset", false, function(v) aa.custom_offset=v end)
sec.aa_opt:CreateSlider("Offset Radius", 1, 50, 20, false, function(v) aa.custom_radius=v/10 end)
sec.aa_opt:CreateToggle("Visualize Server Pos", false, function(v) aa.visualize=v end)
sec.aa_opt:CreateColorpicker("Visualize Color", function(c) aa.vis_color=c end)
sec.aa_opt:CreateSlider("Visualize Transparency", 0, 100, 50, false, function(v) aa.vis_trans=v/100 end)
local tpk_tog = sec.tpk:CreateToggle("TP Kill", false, function(v) tpkill_set(v) end, "dangerous", RISK.." Teleports your character = extremely detectable.")
tpk_tog:CreateKeybind("F", function() end, "Toggle")
sec.tpk:CreateSlider("Height Offset", 5, 300, 40, true, function(v) tpkill.height=v end)
sec.tpk:CreateToggle("Auto Look At Target", false, function(v) tpkill.autolook=v end)
sec.tpk:CreateToggle("Auto Triggerbot", false, function(v) tpkill.autotbot=v end)
sec.pkt:CreateToggle("Auto Shoot Packet", false, function(v) packet.autoshoot=v end, "dangerous", RISK.." Fires straight through walls = obvious.")
sec.pkt:CreateToggle("Prediction", false, function(v) packet.prediction=v end)
sec.pkt:CreateSlider("Shoot Speed", 1, 30, 10, true, function(v) packet.speed=v/10 end)
local stored_fonts = {}
for _,v in Enum.Font:GetEnumItems() do table.insert(stored_fonts, v.Name) end
sec.settings:CreateDropdown("Change Font", stored_fonts, function(v) window:SetFont(v) end, "", false)
sec.settings:CreateLabel("Close Menu: " .. tostring(gui_config.Keybind):gsub("Enum.KeyCode.",""))
local config_manager = loadstring(game:HttpGet("https://kalihub.xyz/ConfigManager.lua"))()
config_manager:SetLibrary(library); config_manager:SetWindow(window)
config_manager:SetFolder("Kali Hub"); config_manager:BuildConfigSection(tabs.settings)
config_manager:LoadAutoloadConfig()
window:SetBackground("rbxassetid://133937513221602")
window:SetTileOffset(100); window:SetTileScale(0.5)
window:SetBackgroundColor(Color3.fromRGB(255,255,255)); window:SetBackgroundTransparency(0)
setthreadidentity(8)
