--was obfuscated by wearedevs.net/obfuscator


local httpService = game:GetService("HttpService")
local players = game:GetService("Players")
local rbxAnalyticsService = game:GetService("RbxAnalyticsService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local teleportService = game:GetService("TeleportService")
local v1 = game:GetService("Workspace")
local starterGui = game:GetService("StarterGui")
local stats = game:GetService("Stats")
local guiService = game:GetService("GuiService")
local coreGui = game:GetService("CoreGui")
local floor = math.floor
local random = math.random
local remove = table.remove
local char = string.char
local v2 = 0
local v3 = 2
local v4 = {}
local v5 = {}

for i = 1, 256 do
  v4[i] = i
end

repeat
  local v6 = remove(v4, (random(1, #v4)))
  v5[v6] = char(v6 - 1)
until #v4 == 0

local v7 = {}

local function f1()
  if #v7 == 0 then
    v2 = (v2 * 69 + 32049522702923) % 35184372088832

    repeat
      v3 = v3 * 180 % 257
    until v3 ~= 1

    local v8 = v3 % 32
    local v9 = floor(v2 / 2 ^ (13 - (v3 - v8) / 32)) % 4294967296 / 2 ^ v8
    local v10 = floor(v9 % 1 * 4294967296) + floor(v9)
    local v11 = v10 % 65536
    local v12 = (v10 - v11) / 65536
    local v13 = v11 % 256
    local v14 = v12 % 256
    v7 = { v13, (v11 - v13) / 256, v14, (v12 - v14) / 256 }
  end

  return table.remove(v7)
end

local v15, f2

local function f3(p1)
  local instance = Instance[v15[f2("m~8", 13763112425736)]](v15[f2(
    "k[\157L\168\7\130\231\128", 1913598296955
  )])

  local instance2 = Instance[v15[f2("A\223\31", 8324416311076)]](v15[f2(
    "\21i\160\199\242", 10045026456133
  )])

  local instance3 = Instance[v15[f2("\30\229\241", 23790767139654)]](v15[f2(
    "\1883\251\164r_\228\r", 25158683094467
  )])

  local instance4 = Instance[v15[f2("\152Z\146", 29632369407462)]](v15[f2(
    "\212ȲF\149\250\145&\189", 27655071314509
  )])

  local instance5 = Instance[v15[f2("Zǟ", 8593770385313)]](v15[f2(
    "\7ED$>\185\237\140\207", 19402507461450
  )])

  local instance6 = Instance[v15[f2("\192\158\r", 20198652896445)]](v15[f2(
    "\155V2\166\201\n\129\145\161", 2394777846875
  )])

  local instance7 = Instance[v15[f2("\167\249\247", 11827549721987)]](v15[f2(
    "m\152ݲ\193\2031\212l\7", 25897374560027
  )])

  local instance8 = Instance[v15[f2("1\7\200", 28385727902626)]](v15[f2(
    "s\135\184\154K\2260\29", 21623919273813
  )])

  local instance9 = Instance[v15[f2("\139L\233", 14443013790277)]](v15[f2(
    "\r]\160\135A\168\155=\3\162\132\195P~\134Ɔ\15\224\249", 472008949979
  )])

  local instance10 = Instance[v15[f2("\224\23R", 5879123004081)]](v15[f2(
    ".\180\17{\227", 10728776897411
  )])

  local instance11 = Instance[v15[f2("\130,I", 22937265187256)]](v15[f2(
    "0\148\229àm+\6", 27964629955294
  )])

  local v16 = f2("C\155\216&l\199", 7932697415277)
  local v17 = game[v15[f2("\145|1\207\228\135\7", 24292500335664)]][v15[f2("\225\2273\209!kw\31\243\0\221", 21213059933846)]]

  instance[v15[v16]] = v17:WaitForChild(v15[f2("\19t\t\29\185Bz6\214", 10493340521238)])

  instance[v15[f2("Y\142\228!\2151̷\251\6\244\139&\152", 32876440157133)]] = Enum[v15[f2(
    "\170(\178\222\220(p1p\140\220A\146\232", 30601466181545
  )]][v15[f2(
    "R\137\136\138\130\161\169", 31408957471009
  )]]

  instance[v15[f2("\0\255\217\195ɪ\193\155s\235]\248D\n\240\6\19\22\5\14\198", 29741590754841)]] = Enum[v15[f2(
    "\167\146\2?\244\246\233\27\14i \21\29\134tlmSJ\208\26", 34739427589936
  )]][v15[f2(
    "\219#&\26", 9987697807914
  )]]

  instance[v15[f2("\n\202\240(\168\167\217ł],\154", 31655189068180)]] = Enum[v15[f2(
    "\158p\194^y\158{n\155\8\141\152", 7879471812181
  )]][v15[f2(
    "\224\189\30\248", 20032724264048
  )]]

  instance10[v15[f2("\219j\n\175", 20261584102619)]] = v15[f2(
    "\234\155g\205\230\228\174?\135=", 33038154906648
  )]

  instance10[v15[f2("\202nK\nw\230", 14480721566295)]] = instance

  instance10[v15[f2("\162|\21\25\132{\21\209A\200W\224H\168\127\127", 12732283311912)]] = Color3[v15[f2(
    "\172\164{l豝", 6447553203130
  )]](
    170, 0, 0
  )

  instance10[v15[f2("\202^\149\r\127v\127\138eXIv\230Ģ\210k\240\1554\24\224", 33883229027746)]] = 0.3

  instance10[v15[f2("UP\t\179U\29\164&9\18%+", 32930936208358)]] = Color3[v15[f2(
    "H\244\228\29\136\24#", 8842331050005
  )]](
    0, 0, 0
  )

  instance10[v15[f2("ᵺ\138\145\n\2'\178\170\159\167\206\236\t", 10526406644517)]] = 0

  instance10[v15[f2("[@@\202", 23643938663170)]] = UDim2[v15[f2("\209,\222", 2043686847415)]](
    1, 0, 1, 0
  )

  instance10[v15[f2("}\187\1328,*", 32150325934715)]] = 0

  instance2[v15[f2("\24\170ABХ", 2902580348231)]] = instance

  instance2[v15[f2("\19\232\253z\238\6X\159\224n\242U\221\217>\134", 2515695797395)]] = Color3[v15[f2(
    "\7\25\235[\200>\2", 2845076833580
  )]](
    12, 12, 14
  )

  instance2[v15[f2("\155\189\152z^\132\12\191\192\140\128\190\137&\24\132\229\t\24n\202%", 13631357245643)]] = 0.1

  instance2[v15[f2(";\246ܴ\171kB\246\\8&\246", 25452960984652)]] = Color3[v15[f2(
    "[&\147*\153\168\188", 30809706788874
  )]](
    0, 0, 0
  )

  instance2[v15[f2("\192\186ȃժ[Y\22_;q&\155\168", 21564054677305)]] = 0

  instance2[v15[f2("C\171Qb\208\0044Z", 14561089231484)]] = UDim2[v15[f2("͇{", 16838394633888)]](
    0.248725787, 0, 0.40242058, 0
  )

  instance2[v15[f2("b\8n\4", 32057395198543)]] = UDim2[v15[f2("q\129\225", 12253157283401)]](
    0.502548397, 0, 0.146747351, 0
  )

  instance3[v15[f2(")\176<\26|\18Z\207\5I\145\210", 12255488710218)]] = UDim[v15[f2(
    "9\250\r", 28281980580721
  )]](
    0.0500000007, 0
  )

  instance3[v15[f2("\129\0/\180\169\142", 6810375949411)]] = instance2

  instance11[v15[f2("\174O\191\188n\158", 11810544194939)]] = instance2

  instance11[v15[f2("Ǌ\186\159\203", 3085306283420)]] = Color3[v15[f2(
    "\204\255\25F/\224\246", 3281192912375
  )]](
    255, 255, 255
  )

  instance11[v15[f2("!\24\216mt\15j\127d", 19690016007120)]] = 1

  instance4[v15[f2("5\241x'", 23118030547469)]] = v15[f2("O\200\249\168\195", 23542777014994)]
  instance4[v15[f2("(\157\129\r\189\211", 17543798824937)]] = instance2

  instance4[v15[f2("e\213d\224\155KM\133\23\245\189\229\219\246\175\222", 2414380008548)]] = Color3[v15[f2(
    "x\217\242xt9\200", 1090688221691
  )]](
    255, 255, 255
  )

  instance4[v15[f2("\178.\8\147\1454\\fA}\239H\225\154\244\8yN\220\196o\28", 23991352028067)]] = 1

  instance4[v15[f2("\235\172\249\237=%\4\135\189\228Q\198", 1113236931078)]] = Color3[v15[f2(
    "\187\250\19\243\24۔", 34021624430050
  )]](
    0, 0, 0
  )

  instance4[v15[f2("\193\137\27\143)\2320\211N\141\21\191\236\220\198", 32833683078073)]] = 0

  instance4[v15[f2("\na\162b\225\149b@", 11639643575596)]] = UDim2[v15[f2("e\241\162", 22481190988004)]](
    0.198198214, 0, 0, 0
  )

  instance4[v15[f2("\179\218\209!", 34877369925489)]] = UDim2[v15[f2("\207d\133", 8605597405095)]](
    0.6006006, 0, 0.289151847, 0
  )

  instance4[v15[f2("\18\27ϔ", 25383771336236)]] = Enum[v15[f2("9V\240\132", 2208693617668)]][v15[f2("\140m9E6\136mMV\252", 11450674238676)]]

  instance4[v15[f2("\137K\222t", 3830756476663)]] = v15[f2(
    "^\139\30\188\250\1y\1858\23\12\133\27As\241\187\200", 27661654618704
  )]

  instance4[v15[f2("ԩ=C,\166ʼ\1543", 7076008938719)]] = Color3[v15[f2("oUk\146\188V\249", 25394811153969)]](
    255, 255, 255
  )

  instance4[v15[f2("\28[<8#6\244\156\240\177", 7038371744973)]] = true
  instance4[v15[f2("w\154\215,\216U\241\6", 23914403572608)]] = 14
  instance4[v15[f2("\5\229\133\7\127\31\1ј\197_", 22267834263681)]] = true

  instance5[v15[f2("\2414w\202", 19291529028375)]] = v15[f2("K-\23", 985520177610)]
  instance5[v15[f2("-n\243\141t\138", 15365442739187)]] = instance2

  instance5[v15[f2("z\6\151\170\208%\153\162a\28\209\255\177P\140\254", 26101904977786)]] = Color3[v15[f2(
    "1\140\168-\12\179S", 12796064372550
  )]](
    255, 255, 255
  )

  instance5[v15[f2(")>\127p\247f\241S\242\233\20\128\145o\206\216޵\172⿊", 18450749022607)]] = 1

  instance5[v15[f2("p\228+\173\226w\160<ᯩs", 29383097890162)]] = Color3[v15[f2(
    "\171\200*u\\\152\139", 32486080396055
  )]](
    0, 0, 0
  )

  instance5[v15[f2("n\146\196T\135\1575\133.2\191\179\204#\249", 6384407464860)]] = 0

  instance5[v15[f2("\240\168\197{\"c\133\180", 17741502799941)]] = UDim2[v15[f2(
    "\26O\250", 14845507115776
  )]](
    0.22862418, 0, 0.550000012, 0
  )

  instance5[v15[f2("\228\177!&", 8798787473409)]] = UDim2[v15[f2("+}\151", 18832191021633)]](
    0.533663452, 0, 0.154971421, 0
  )

  instance5[v15[f2("\154S\175\187", 3652487038628)]] = Enum[v15[f2("\5\190\233\19", 9912024404487)]][v15[f2(
    "\28\184\6Q\252\12k\183\182_", 17669443346467
  )]]

  instance5[v15[f2("\129\24\"\169", 1301798011486)]] = v15[f2(
    "C\142\214\195\241\28*\201߆\148\186P\142X\187˜\1526w", 21551667980083
  )]

  instance5[v15[f2("\131\179\128\194\1\246Qa\253\179", 4966262229256)]] = Color3[v15[f2(
    "\191$/#j\190\"", 994795831759
  )]](
    106, 106, 124
  )

  instance5[v15[f2("@\3c\190\\㿜\192\254", 30157265401563)]] = true
  instance5[v15[f2("\250\189\189+&=\215+", 30350033565492)]] = 14
  instance5[v15[f2("\147x\142\23n\0079\0 \30\203", 3203489449427)]] = true

  instance6[v15[f2("8%K\238", 6423567535023)]] = v15[f2(
    ".ˎ\222\0240\17\146I\235\233", 34180790058540
  )]

  instance6[v15[f2("\5\166\2\231Sn", 30865144068132)]] = instance2

  instance6[v15[f2("\23\242&\183\134\204S\149\"4\190\2414\154\189\30", 13499576473742)]] = Color3[v15[f2(
    "\236\8\217\4D\252\241", 24391229107294
  )]](
    255, 255, 255
  )

  instance6[v15[f2("\214~\t\200)\191\155\11q\1414\t/\n\254+S\5oH\152\192", 2719143707890)]] = 1

  instance6[v15[f2("\2@\168NPy\144\127\159ڒ\"", 2229607941134)]] = Color3[v15[f2(
    "\1618\180\139\140\147\11", 11474691265759
  )]](
    0, 0, 0
  )

  instance6[v15[f2("F\26\144\t)\166\2279܍ÿ\154\163\224", 22010672752649)]] = 0

  instance6[v15[f2("\238)k\25\134U\187\29", 3215128118745)]] = UDim2[v15[f2("(\227;", 26840134004946)]](
    0.060851898, 0, 0.306907117, 0
  )

  instance6[v15[f2("\229!EV", 12928205625220)]] = UDim2[v15[f2("\215\4i", 16011192507679)]](
    0.871821165, 0, 0.216986924, 0
  )

  instance6[v15[f2("\249\191\25\224", 10106510922338)]] = Enum[v15[f2("ԛ\230f", 7126931426550)]][v15[f2("I\31e0ı", 13312900798519)]]
  instance6[v15[f2("\189{-\250", 16490918387199)]] = p1

  instance6[v15[f2("\227\171h\183\29J'\217X\177", 24868434226492)]] = Color3[v15[f2(
    "\23\132\134k\189\135\168", 28158407914296
  )]](
    255, 255, 255
  )

  instance6[v15[f2("U!\222ͽ\177\139+\225e", 25289705860608)]] = true
  instance6[v15[f2("\4n\1281w\127\21<", 8516253159293)]] = 14
  instance6[v15[f2("\186\247\181\184q\27\28U\137Է", 31810894952925)]] = true

  instance7[v15[f2("\145\132m\195", 17358159880)]] = v15[f2(
    "\233U\158B\2272\236ຝ#", 26185696505761
  )]

  instance7[v15[f2("\188M\148\12\172\173", 33112692964411)]] = instance2

  instance7[v15[f2("\140\171h\154\232C#\132\255St\20D\29\252\206", 21569026156347)]] = Color3[v15[f2(
    "Q\172\252}|\130s", 31151958751402
  )]](
    170, 0, 0
  )

  instance7[v15[f2("ig\189a>\210_\157\221g\130\11", 34107488796170)]] = Color3[v15[f2(
    "\11́\232w\187\167", 16541919452694
  )]](
    0, 0, 0
  )

  instance7[v15[f2("\183El\177.\218\232?\198'\141q\206yf", 26317620211679)]] = 0

  instance7[v15[f2("\238\31^I\":.'", 2126606140382)]] = UDim2[v15[f2("_\144\141", 22965486987718)]](
    0.385395527, 0, 0.747835159, 0
  )

  instance7[v15[f2("E\183\172%", 25314038165003)]] = UDim2[v15[f2("\130\196D", 32991750224898)]](
    0.229208946, 0, 0.206185549, 0
  )

  instance7[v15[f2("\230\243\236\190", 1280691372628)]] = Enum[v15[f2("\244\1887\250", 14520895183465)]][v15[f2(
    "\249a\127\2177\135\233hY\30", 526521827573
  )]]

  instance7[v15[f2("\31\15N\189", 3510299313762)]] = v15[f2("\26\160?\249|", 25995586449225)]

  instance7[v15[f2("\15\199#\29ul\196i2\130", 22537194580222)]] = Color3[v15[f2(
    "\138\244- \1{\21", 6725427448891
  )]](
    255, 255, 255
  )

  instance7[v15[f2("\134\163ʼC\135ew\230\206", 17651348365339)]] = true
  instance7[v15[f2("\230\198jߋ\179\169\24", 281028116610)]] = 14
  instance7[v15[f2("Q\134\20[\205O\23\252\17\190\161", 22736619956571)]] = true

  instance8[v15[f2("tz\232\209Z\250\2507\1\233[\11", 27757859287677)]] = UDim[v15[f2(
    "\155\234\142", 7407959543161
  )]](
    1, 0
  )

  instance8[v15[f2("Q\20\20\167w\155", 865148649874)]] = instance7

  instance9[v15[f2("\220\19\192t\29c", 9064405586044)]] = instance7
  instance9[v15[f2("\156\234\246CRk\234\149D\166\177", 32276393769653)]] = 14

  instance7[v15[f2("\21rS,Ι\20k\226RO\174\25\244\207g[", 29023556564171)]]:Connect(function()
    instance:Destroy()
  end)
end

local v18 = {}
v15 = setmetatable({}, { __index = v18, __metatable = nil })

function f2(p2, p3)
  if v18[p3] then
  else
    v7 = {}
    v2 = p3 % 35184372088832
    v3 = p3 % 255 + 2
    local v19 = string.len(p2)
    v18[p3] = ""
    local v20 = 30

    for j = 1, v19 do
      v20 = (string.byte(p2, j) + f1() + v20) % 256
      v18[p3] = v18[p3] .. v5[v20 + 1]
    end
  end

  return p3
end

local localPlayer = players.LocalPlayer
local key = getgenv().Key or _G.Key
local privateKey = getgenv().PrivateKey or _G.PrivateKey

local f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, f19, f20, f21, f22,
  f23, v21, f24, f25, f26, f27, f28, f29, f30, f31, f32, f33, f34, f35, f36, f37,
  napoleonWindow, v22, v23, napoleonAntiAfkIdledConnections, f38, f39,
  httpsNapoleonnNetApiAuthModule, v24, v25, v26, v27, localPlayer2, v28, v29, connect, connect2,
  f40, f41, f42, connect3, v30, f43, v31, f44, f45, f46, v32, v33, v34, v35, zero, v36, v37,
  v38, v39, v40, v41, f47, v42, v43, v44, f48, f49, v45, vector, resolveHitDistance, f50, f51,
  v46, f52, v47, f53, f54, v48, v49, v50, f55, v51, v52, f56, v53, f57, f58,
  napoleonAntiAfkGeneration

if not key then
  f3("Key tidak ditemukan! Silahkan masukkan getgenv().Key")
  return
else
  local v54 = tostring(rbxAnalyticsService:GetClientId())

  function f5(p4)
    local v55, v56 = pcall(function() return game:HttpGet(p4) end)
    return v55 and v56 or nil
  end

  local function f59(p5)
    local v57, v58 = pcall(function() return httpService:JSONDecode(p5) end)
    return v57 and v58 or nil
  end

  function f38(p6)
    local v59 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

    return string.gsub(p6, "[^" .. v59 .. "=]", ""):gsub(".", function(p7)
      if p7 == "=" then
        return ""
      else
        local text = ""
        local v60 = v59:find(p7) - 1

        for k = 6, 1, -1 do
          text = text .. (v60 % 2 ^ k - v60 % 2 ^ (k - 1) > 0 and "1" or "0")
        end

        return text
      end
    end):gsub("%d%d%d%d%d%d%d%d", function(p8)
      if #p8 ~= 8 then
        return ""
      else
        local total = 0

        for m = 1, 8 do
          total = total + (p8:sub(m, m) == "1" and 2 ^ (8 - m) or 0)
        end

        return string.char(total)
      end
    end)
  end

  function f4(p9, p10, p11)
    return f39(p11 .. p9 .. "NAPOLEON") == p10
  end

  function f39(p12)
    local v61 = p12
    local v62

    pcall(function()
      if not v62 and syn and syn.crypto and syn.crypto.hash then
        if syn.crypto.hash("sha256", "test")
          == "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08" then
          v62 = syn.crypto.hash("sha256", v61)
        end
      end
    end)

    if v62 then
      return v62
    else
      local v63 = {
        1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748,
        2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206,
        2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983,
        1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671,
        3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372,
        1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411,
        3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734,
        506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779,
        1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479,
        3329325298,
      }

      local bxor = bit32.bxor
      local lshift = bit32.lshift
      local rshift = bit32.rshift
      local bnot = bit32.bnot
      local band = bit32.band
      local rrotate = bit32.rrotate

      local v64 = {
        1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635,
        1541459225,
      }

      local v65 = #v61 * 8
      v61 = v61 .. string.char(128)
      local v66 = 64 - #v61 % 64

      if v66 < 8 then
        v66 = v66 + 64
      end

      v61 = v61 .. string.rep("\0", v66 - 8)
      local v67 = math.floor(v65 / 4294967296)
      local v68 = v65 % 4294967296

      v61 = v61 .. string.char(
        band(rshift(v67, 24), 255), band(rshift(v67, 16), 255), band(rshift(v67, 8), 255),
        band(v67, 255), band(rshift(v68, 24), 255), band(rshift(v68, 16), 255),
        band(rshift(v68, 8), 255), band(v68, 255)
      )

      for n = 1, #v61, 64 do
        local v69 = {}

        for i6 = 0, 15 do
          local v70, v71, v72, v73 = string.byte(v61, n + i6 * 4, n + i6 * 4 + 3)
          v69[i6] = lshift(v70, 24) + lshift(v71, 16) + lshift(v72, 8) + v73
        end

        for i7 = 16, 63 do
          v69[i7] = (v69[i7 - 16] + bxor(
            rrotate(v69[i7 - 15], 7), rrotate(v69[i7 - 15], 18), rshift(v69[i7 - 15], 3)
          ) + v69[i7 - 7] + bxor(
            rrotate(v69[i7 - 2], 17), rrotate(v69[i7 - 2], 19), rshift(v69[i7 - 2], 10)
          )) % 4294967296
        end

        local v74 = v64[1]
        local v75 = v64[2]
        local v76 = v64[3]
        local v77 = v64[4]
        local v78 = v64[5]
        local v79 = v64[6]
        local v80 = v64[7]
        local v81 = v64[8]

        for i8 = 0, 63 do
          local v82 = v74

          local v83 = (v81 + bxor(rrotate(v78, 6), rrotate(v78, 11), rrotate(v78, 25))
              + bxor(band(v78, v79), band(bnot(v78), v80)) + v63[i8 + 1] + v69[i8])
            % 4294967296

          local v84 = bxor(rrotate(v74, 2), rrotate(v74, 13), rrotate(v74, 22))
          local v85 = band(v74, v75)
          local v86 = band(v74, v76)
          local v87 = { band(v75, v76) }
          v81 = v80
          v80 = v79
          v79 = v78
          v78 = (v77 + v83) % 4294967296
          v77 = v76
          v76 = v75
          v74 = (v83 + (v84 + bxor(v85, v86, unpack(v87))) % 4294967296) % 4294967296
          v75 = v82
        end

        v64[1] = (v64[1] + v74) % 4294967296
        v64[2] = (v64[2] + v75) % 4294967296
        v64[3] = (v64[3] + v76) % 4294967296
        v64[4] = (v64[4] + v77) % 4294967296
        v64[5] = (v64[5] + v78) % 4294967296
        v64[6] = (v64[6] + v79) % 4294967296
        v64[7] = (v64[7] + v80) % 4294967296
        v64[8] = (v64[8] + v81) % 4294967296
      end

      local text2 = ""

      for i9 = 1, 8 do
        text2 = text2 .. string.format("%08x", v64[i9])
      end

      return text2
    end
  end

  local function f60(p13)
    local v88, v89 = pcall(function() return httpService:JSONDecode(p13) end)

    if not v88 or not v89 then
      return nil, "Legacy"
    end

    local payload, v90

    if v89.sig and v89.server_key then
      if v89.server_key ~= "75dce92b8fcda87aa2e50eadd3c264f153d2f9953eb37b2870047daa0a42637f" then
        return nil, "Server key mismatch!"
      end

      payload = v89.data and v89.data.payload or ""

      if not f4(payload, v89.sig, v89.server_key) then
        return nil, "Invalid Signature! Server response tampered."
      elseif v89.ok == false then
        return nil, v89.data and v89.data.error or "Server error"
      elseif v89.data.is_base64 then
        local v91

        v91, v90 = pcall(function()
          if crypt and crypt.base64decode then
            return crypt.base64decode(payload)
          end

          return f38(payload)
        end)

        if v91 and v90 then
          local v92, v93 = pcall(function() return httpService:JSONDecode(v90) end)

          if v92 and v93 then
            return v93, nil
          end

          return nil, "Failed to decode base64 payload"
        end

        return nil, "Failed to decode base64 payload"
      else
        return v89.data, nil
      end
    else
      return nil, "Legacy"
    end
  end

  local function f61(p14, p15)
    local v94 = {}
    local count = 0
    local v95 = #p15
    local count2 = 0

    for match in string.gmatch(p14, "..") do
      local v96 = tonumber(match, 16)

      if not v96 then
        return nil
      else
        local byte = p15:byte(count % v95 + 1)
        table.insert(v94, string.char(bit32.bxor(v96, byte)))
        count = count + 1
        count2 = count2 + 1

        if count2 % 2500 == 0 then
          task.wait()
        end
      end
    end

    return table.concat(v94)
  end

  local generateGUID = httpService:GenerateGUID(false)
  local valid = false
  local message = ""

  if privateKey and privateKey ~= "" then
    local v97 = f5("https://napoleonn.net" .. "challenge?key=" .. key)

    if v97 then
      local v98 = f59(v97)

      if v98 and v98.ok and v98.crypto then
        httpsNapoleonnNetApiAuthModule = f5("https://napoleonn.net/api/auth_module")

        if httpsNapoleonnNetApiAuthModule then
          local v99
          v99, v24 = pcall(function() return loadstring(httpsNapoleonnNetApiAuthModule)() end)

          if v99 and v24 and v24.sign_safe then
            v25 = v98.challenge .. generateGUID
            local v100, v101 = pcall(function() return v24.sign_safe(privateKey, v25) end)

            if v100 and v101 then
              v26 = "https://napoleonn.net" .. "check" .. "?key=" .. key .. "&hwid=" .. v54
                .. "&nonce=" .. generateGUID .. "&challenge=" .. v98.challenge .. "&signature="
                .. v101 .. "&base64=true&hwid_lock=true"

              local v102, v103 = pcall(function() return f5(v26) end)

              if v102 and v103 then
                local v104, v105 = f60(v103)

                if v104 then
                  valid = v104.valid
                  message = v104.message or "Key verified"
                else
                  local v106 = f61(v103, SECRET_KEY)

                  if v106 then
                    local find = v106:find("|")

                    if find then
                      local v107 = f59(v106:sub(find + 1))

                      if v107 and type(v107) == "table" then
                        if v107.nonce ~= generateGUID then
                          localPlayer:Kick("Security: HTTP Spoofing!")
                        end

                        valid = v107.valid
                        message = v107.message or ""
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  if not valid and not privateKey then
    v27 = "https://napoleonn.net" .. "check?key=" .. key .. "&hwid=" .. v54 .. "&nonce="
      .. generateGUID .. "&base64=true&hwid_lock=true"

    local v108, v109 = pcall(function() return f5(v27) end)

    if v108 and v109 then
      local v110, v111 = f60(v109)

      if v110 then
        valid = v110.valid
        message = v110.message or ""
      else
        local v112 = f61(v109, SECRET_KEY)

        if v112 then
          local find2 = v112:find("|")

          if find2 then
            local v113 = tonumber((v112:sub(1, find2 - 1)))
            local getServerTimeNow = workspace:GetServerTimeNow()

            if v113 and math.abs(getServerTimeNow - v113) > 60 then
              f3("Sesi kadaluarsa / Time Mismatch!")
              return
            end

            local v114 = f59(v112:sub(find2 + 1))

            if v114 and type(v114) == "table" then
              if v114.nonce ~= generateGUID then
                localPlayer:Kick("Security: HTTP Spoofing!")
              end

              valid = v114.valid
              message = v114.message or ""
            end
          end
        end
      end
    end
  end

  if not valid then
    f3(message ~= "" and message or "Key tidak valid / Gagal verifikasi!")
    return
  else
    task.spawn(function()
      pcall(function()
        local getServerTimeNow2 = workspace:GetServerTimeNow()

        if isfile and readfile and writefile then
          if isfile("Napoleon_KICK-A-LUCKY-BLOCK_LastExec.txt") then
            local v115 = tonumber(readfile("Napoleon_KICK-A-LUCKY-BLOCK_LastExec.txt"))

            if v115 and getServerTimeNow2 - v115 < 3600 then
              return
            end
          end

          writefile("Napoleon_KICK-A-LUCKY-BLOCK_LastExec.txt", tostring(getServerTimeNow2))

          if localPlayer then
            local v116 = tostring(localPlayer.UserId)
            local v117 = tostring(game.PlaceId)

            f5("https://napoleonn.net" .. "track" .. "?script=Violence_District"
              .. "&userid=" .. v116 .. "&username=" .. localPlayer.Name .. "&executor="
              .. ("Unknown"):gsub(" ", "%%20") .. "&placeid=" .. v117 .. "&key=" .. key)
          end

          return
        end

        if getgenv()._Napoleon_ExecLogged_Slime then
          return
        end

        getgenv()._Napoleon_ExecLogged_Slime = true

        if localPlayer then
          local v118 = tostring(localPlayer.UserId)
          local v119 = tostring(game.PlaceId)

          f5("https://napoleonn.net" .. "track" .. "?script=Violence_District" .. "&userid="
            .. v118 .. "&username=" .. localPlayer.Name .. "&executor="
            .. ("Unknown"):gsub(" ", "%%20") .. "&placeid=" .. v119 .. "&key=" .. key)
        end
      end)
    end)

    print("Success!!")
    localPlayer2 = players.LocalPlayer

    function f6(p16, p17, p18)
      return type(p16) == "table" and rawget(p16, "Player") == localPlayer2
        and rawget(p16, "Character") == localPlayer2.Character
        and rawget(p16, "Humanoid") == p17 and rawget(p16, "RootPart") == p18
    end

    v28 = {
      "LastObservedSample", "LastSample", "LastGoodSample", "LastGameplayTrustedSample",
      "LastValidatedSample", "LastValidatedGroundedSample", "LastConfirmedGroundSample",
      "CandidateGroundedSample",
    }

    v29 = nil

    function f7()
      return getgenv and getgenv() or _G
    end

    v21 = tostring(math.random(100000, 999999))

    function f8(p19, p20, p21)
      local zero2, cframe, position

      if type(p19) ~= "table" then
        return false
      else
        local v120 = rawget(p19, "RootPart")
        cframe = v120 and v120.Parent and v120.CFrame or nil
        position = cframe and cframe.Position or nil
        zero2 = typeof(p21) == "Vector3" and p21 or Vector3.zero

        local function f62(p22)
          if type(p22) == "table" then
            rawset(p22, "WalkSpeed", p20)

            if cframe then
              rawset(p22, "CFrame", cframe)
              rawset(p22, "Position", position)
              rawset(p22, "LinearVelocity", zero2)
              rawset(p22, "AngularVelocity", Vector3.zero)
            end
          end
        end

        for index, value in ipairs(v28) do
          f62(rawget(p19, value))
        end

        rawget(p19, "SampleHistory")
        rawget(p19, "SafeGroundCheckpoints")

        local v121 = rawget(p19, "Evidence")

        if type(v121) == "table" then
          v121.Speed = 0
          v121.Teleport = 0
          v121.Flight = 0
        end

        local v122 = rawget(p19, "ImpulseContext")

        if type(v122) == "table" then
          local v123 = math.max(tonumber(v122.MaxHorizontalSpeed) or 0, p20)

          local v124 = math.max(
            (tonumber(v122.ExpiresAt) or 0) - (tonumber(v122.StartedAt) or 0), 0.15
          )

          v122.MaxHorizontalSpeed = v123

          if position then
            v122.OriginPosition = position
          end

          v122.MaxHorizontalDistance = math.max(
            tonumber(v122.MaxHorizontalDistance) or 0, v123 * v124 + 48
          )

          f62(v122.PreMovementSafeSample)
        end

        if rawget(p19, "CorrectionContext") == nil then
          rawset(p19, "FirstSuspiciousAt", nil)

          if rawget(p19, "ThreatLevel") == "Observing" then
            rawset(p19, "ThreatLevel", "Trusted")
          end
        end

        return true
      end
    end

    function f9(p23, p24, p25)
      local v125 = type(getcallbackvalue) == "function" and type(debug) == "table"
        and type(debug.getupvalue) == "function"

      local v126, f63

      if v125 then
        local signal = replicatedStorage:FindFirstChild("Packages")
          and replicatedStorage.Packages:FindFirstChild("Signal")

        if signal then
          local v127, v128 = pcall(require, signal)

          if v127 and type(v128) == "table" and type(v128.Invoked) == "function" then
            local v129, v130 = pcall(v128.Invoked, "ClientCharacter: GetDebugSnapshot")

            if v129 and v130 then
              local v131, v132 = pcall(getcallbackvalue, v130, "OnInvoke")

              if v131 and type(v132) == "function" then
                local v133, v134 = pcall(debug.getinfo, v132)

                if v133 then
                  function f63(p26, p27, p28)
                    if v126 or type(p26) ~= "table" or p27 > 3 or p28[p26] then
                      return
                    end

                    p28[p26] = true

                    if rawget(p26, "Player") == p23
                      and rawget(p26, "Character") == p23.Character
                      and rawget(p26, "Humanoid") == p24 and rawget(p26, "RootPart") == p25
                      and type(rawget(p26, "SampleHistory")) == "table"
                      and type(rawget(p26, "Evidence")) == "table" then
                      v126 = p26
                      return
                    else
                      local count3 = 0

                      for key2, value2 in pairs(p26) do
                        count3 = count3 + 1

                        if count3 > 128 then
                          break
                        elseif type(value2) == "table" then
                          f63(value2, p27 + 1, p28)
                        end
                      end

                      return
                    end
                  end

                  for i10 = 1, v134.nups or 0 do
                    local v135, v136 = pcall(debug.getupvalue, v132, i10)

                    if v135 and type(v136) == "table" then
                      f63(v136, 0, {})

                      if v126 then
                        break
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      if not v126 and type(getgc) == "function" then
        local v137, v138 = pcall(getgc, true)

        if v137 and type(v138) == "table" then
          for index2, value3 in ipairs(v138) do
            if type(value3) == "table" and rawget(value3, "Player") == p23
              and rawget(value3, "Character") == p23.Character
              and rawget(value3, "Humanoid") == p24 and rawget(value3, "RootPart") == p25
              and type(rawget(value3, "SampleHistory")) == "table"
              and type(rawget(value3, "Evidence")) == "table" then
              v126 = value3
              break
            end
          end
        end
      end

      return v126
    end

    connect = nil
    connect2 = nil

    function f10(p29)
      if not v29 or not v29.Parent then
        return false
      else
        local humanoidRootPart = localPlayer2.Character
          and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

        local position2 = p29 or humanoidRootPart and humanoidRootPart.Position

        if not position2 then
          return false
        end

        v29.CFrame = CFrame.new(position2.X, position2.Y - 2.5 - 0.5, position2.Z)
        return true
      end
    end

    function f40()
      for index3, value4 in ipairs(v1:GetChildren()) do
        if value4:IsA("BasePart") and value4.Name == "__FyyHoverPad" then
          if value4:GetAttribute("FyyStealRuntimeOwner") == v21 and value4 ~= v29 then
            pcall(value4.Destroy, value4)
          end
        end
      end
    end

    function f11()
      if connect then
        pcall(connect.Disconnect, connect)
        connect = nil
      end

      if connect2 then
        pcall(connect2.Disconnect, connect2)
        connect2 = nil
      end

      if v29 then
        pcall(v29.Destroy, v29)
        v29 = nil
      end

      f40()
    end

    function f41()
      if not v29 or not v29.Parent or v29:GetAttribute("FyyStealRuntimeOwner") ~= v21 then
        f40()

        if v29 and v29.Parent then
          pcall(v29.Destroy, v29)
        end

        local fyyHoverPad = Instance.new("Part")
        fyyHoverPad.Name = "__FyyHoverPad"
        fyyHoverPad:SetAttribute("FyyStealRuntimeOwner", v21)
        fyyHoverPad.Anchored = true
        fyyHoverPad.CanCollide = true
        fyyHoverPad.CanQuery = true
        fyyHoverPad.CanTouch = false
        fyyHoverPad.CastShadow = false
        fyyHoverPad.Transparency = 1
        fyyHoverPad.Material = Enum.Material.SmoothPlastic
        fyyHoverPad.Size = Vector3.new(8, 1, 8)

        v29 = fyyHoverPad
        fyyHoverPad.Parent = v1
      end

      f10()

      if not connect then
        connect = runService.PreSimulation:Connect(function()
          if not f10() then
            f41()
          end
        end)
      end

      if not connect2 then
        connect2 = runService.PostSimulation:Connect(function() f10() end)
      end
    end

    function f12(p30, p31)
      local v139 = f42()

      if not v139 then
        return false
      else
        local humanoid = p30 and p30:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart2 = p30 and p30:FindFirstChild("HumanoidRootPart")

        v139.Humanoid = humanoid
        v139.RootPart = humanoidRootPart2
        v139.WalkSpeed = math.clamp(tonumber(p31) or 500, 10, 1500)
        v139.Enabled = false

        return humanoid ~= nil and humanoidRootPart2 ~= nil
      end
    end

    function f42()
      local v140 = f7()
      local fyyStealAnEggMovementSpoof = v140.__FyyStealAnEggMovementSpoof

      if type(fyyStealAnEggMovementSpoof) ~= "table"
        or fyyStealAnEggMovementSpoof.Version ~= 436 then
        if type(fyyStealAnEggMovementSpoof) == "table" then
          fyyStealAnEggMovementSpoof.Enabled = false
        end

        fyyStealAnEggMovementSpoof = {
          Version = 436,
          Installed = false,
          Enabled = false,
          Mode = "StateBaseline",
          Humanoid = nil,
          RootPart = nil,
          WalkSpeed = 500,
        }

        v140.__FyyStealAnEggMovementSpoof = fyyStealAnEggMovementSpoof
      end

      return fyyStealAnEggMovementSpoof
    end

    function f13()
      local v141 = f7()
      local fyyStealAnEggIntegritySpoof = v141.__FyyStealAnEggIntegritySpoof

      if type(fyyStealAnEggIntegritySpoof) ~= "table" then
        fyyStealAnEggIntegritySpoof = {}
        v141.__FyyStealAnEggIntegritySpoof = fyyStealAnEggIntegritySpoof
      end

      return fyyStealAnEggIntegritySpoof
    end

    function f14(p32, p33, p34)
      local v142 = f13()
      local state = v142.State
      local v143

      if not f6(state, p32, p33) then
        local v144 = os.clock()

        if v144 < (v142.NextSearchAt or 0) then
          return false
        end

        v142.NextSearchAt = v144 + 0.2
        state = f9(localPlayer2, p32, p33)
        v143 = not state

        if v143 or not f6(state, p32, p33) then
          v142.Enabled = false
          v142.Humanoid = p32
          v142.RootPart = p33
          v142.State = state

          return false
        end

        v142.NextSearchAt = 0
        v142.Enabled = true
        v142.Humanoid = p32
        v142.RootPart = p33
        v142.State = state
        v142.WalkSpeed = math.clamp(p34 * 1.35, 10, 1500)
        v142.TravelVelocity = Vector3.zero

        f8(state, v142.WalkSpeed, v142.TravelVelocity)
        return true
      end

      v143 = not state

      if v143 or not f6(state, p32, p33) then
        v142.Enabled = false
        v142.Humanoid = p32
        v142.RootPart = p33
        v142.State = state

        return false
      end

      v142.NextSearchAt = 0
      v142.Enabled = true
      v142.Humanoid = p32
      v142.RootPart = p33
      v142.State = state
      v142.WalkSpeed = math.clamp(p34 * 1.35, 10, 1500)
      v142.TravelVelocity = Vector3.zero

      f8(state, v142.WalkSpeed, v142.TravelVelocity)
      return true
    end

    function f24(p35, p36, p37)
      return f6(p35, p36, p37)
    end

    function f15(p38, p39, p40, p41)
      local fyyStealAnEggIntegritySpoof2 = f7().__FyyStealAnEggIntegritySpoof

      if type(fyyStealAnEggIntegritySpoof2) ~= "table"
        or not fyyStealAnEggIntegritySpoof2.Enabled
        or fyyStealAnEggIntegritySpoof2.Humanoid ~= p38
        or fyyStealAnEggIntegritySpoof2.RootPart ~= p39
        or not f6(fyyStealAnEggIntegritySpoof2.State, p38, p39) then
        return false
      end

      fyyStealAnEggIntegritySpoof2.WalkSpeed = math.clamp(p40 * 1.35, 10, 1500)

      if typeof(p41) == "Vector3" then
        fyyStealAnEggIntegritySpoof2.TravelVelocity = p41
      elseif typeof(fyyStealAnEggIntegritySpoof2.TravelVelocity) ~= "Vector3" then
        fyyStealAnEggIntegritySpoof2.TravelVelocity = Vector3.zero
      end

      return f8(
        fyyStealAnEggIntegritySpoof2.State, fyyStealAnEggIntegritySpoof2.WalkSpeed,
        fyyStealAnEggIntegritySpoof2.TravelVelocity
      )
    end

    connect3 = nil

    task.spawn(function()
      if connect3 then
        return
      end

      connect3 = runService.PreSimulation:Connect(function()
        local character = localPlayer2.Character
        local humanoidRootPart3 = character and character:FindFirstChild("HumanoidRootPart")

        local humanoid2 = character
        humanoid2 = character and character:FindFirstChildOfClass("Humanoid")

        local v145 = not character
        local v146 = humanoid2

        if v145 or not humanoidRootPart3 or not v146 then
          return
        else
          local tweenSpeedMultiplier = Config and Config.TweenSpeedMultiplier or 500
          f12(character, tweenSpeedMultiplier * 1.35)

          if not f15(v146, humanoidRootPart3, tweenSpeedMultiplier) then
            f14(v146, humanoidRootPart3, tweenSpeedMultiplier)
          end

          return
        end
      end)
    end)

    v30 = false
    pcall(function() starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false) end)

    function f43(p42)
      local v147, v148, f64

      if not p42 then
        return
      else
        local waitForChild = p42:WaitForChild("Humanoid", 5)
          or p42:FindFirstChildOfClass("Humanoid")

        if not p42:WaitForChild("HumanoidRootPart", 5) then
          p42:FindFirstChild("HumanoidRootPart")
        end

        if not waitForChild then
          return
        end

        v147 = math.max(waitForChild.MaxHealth, 100)
        v148 = false

        function f64()
          if v148 or not waitForChild.Parent then
            return
          end

          v148 = false
        end

        f64()

        waitForChild.HealthChanged:Connect(function(p43)
          if p43 <= 0 or p43 < v147 then
            f64()
          end
        end)

        runService.RenderStepped:Connect(f64)
        return
      end
    end

    task.spawn(function() f43(localPlayer2.Character or localPlayer2.CharacterAdded:Wait()) end)
    localPlayer2.CharacterAdded:Connect(function(character2) f43(character2) end)

    v31 = {
      AutoSteal = false,
      StealMode = "Tween",
      AutoParasiteSteal = false,
      AutoParasiteClaim = false,
      ParasiteFeedRarities = { "All" },
      StealAreas = { "None" },
      StealRarities = { "None" },
      StealNamesFilter = { "None" },
      StealMinValue = 0,
      AntiAFK = true,
      AutoPlace = false,
      PlaceRarities = { "None" },
      AutoHatch = false,
      SellAll = false,
      AutoSell = false,
      SellNames = { "None" },
      SellRarities = { "None" },
      AutoSellEgg = false,
      SellEggRarities = { "None" },
      WebhookEnabled = false,
      WebhookURL = "",
      TweenSpeedMultiplier = 400,
      AntiTreadmillMount = true,
      AutoTreadmillIdle = false,
      AntiGuardKnockback = true,
      EggPredictUI = false,
      EggESP = false,
    }

    local v149 = require(replicatedStorage.Client.EggState)
    v149.GetAreaEggSnapshot = v149.ReadFieldEggs
    v149.GetAreaEggRecord = v149.ReadFieldEgg
    v149.RequestAreaEggSnapshot = v149.SyncFieldEggs
    v149.RequestCarryAreaEgg = v149.CarryFieldEgg
    v149.RequestDropHeldAreaEgg = v149.DropFieldEgg
    v149.AreaEggCarryStateChanged = v149.CarryChanged
    v149.AreaEggClaimed = v149.FieldClaimed
    v149.AreaEggUpdated = v149.FieldShifted
    v149.AreaEggRemoved = v149.FieldGone
    v149.GetOwnerRuntimeRecords = v149.ReadOwnerEggs
    v149.RequestEquipTool = v149.WearEggTool
    v149.RequestPlaceEgg = v149.PlantEgg
    v149.RequestHatchEgg = v149.BeginHatch
    v149.RequestCompleteHatchEgg = v149.FinishHatch
    v149.RequestRuntimeSnapshot = v149.SyncOwnedEggs
    v149.RuntimeOwnerUpdated = v149.OwnerRefreshed
    v149.RuntimeOwnerCleared = v149.OwnerCleared

    local v150 = require(replicatedStorage.Client.PlotState)
    v150.GetMySlot = v150.ResolveLocalSlot
    v150.GetPlotsFolder = v150.ResolveFolder
    v150.IsWorldPositionWithinLocalPlotBounds = v150.ContainsLocalPoint
    v150.GetPlotData = v150.ResolvePlot

    local v151 = require(replicatedStorage.Client.AreaEggResetWall)

    function f16()
      return math.clamp(tonumber(v31.TweenSpeedMultiplier) or 400, 1, 1000)
    end

    v151.IsClosed = v151.IsSealed

    function v31:applyStealValueInput(p44)
      local v152 = tostring
      local gsub = string.lower(v152(p44 or "")):gsub("[%s,]", "")

      if gsub == "" then
        self.StealMinValue = 0
        return true
      else
        local v153, v154 = string.match(gsub, "^([%d]+%.?[%d]*)([kmb]?)$")
        local v155 = tonumber(v153)

        if not v155 then
          return false
        else
          local v156 = 1

          if v154 == "k" then
            v156 = 1000
          elseif v154 == "m" then
            v156 = 1000000
          elseif v154 == "b" then
            v156 = 1000000000
          end

          self.StealMinValue = v155 * v156
          return true
        end
      end
    end

    function v31:getAreaEggValue(p45)
      if not self._assetGenerationUtil then
        self._assetGenerationUtil = require(replicatedStorage.Shared.Util.AssetEarnings)
      end

      local assetCategory = p45.AssetCategory
      local assetScale = p45.AssetScale or 1
      local mutationOnlyRatePerSecond = self._assetGenerationUtil.MutationOnlyRatePerSecond

      return mutationOnlyRatePerSecond({
        Category = assetCategory,
        Scale = assetScale,
        Mutations = p45.Mutations or {},
        BaseMutation = p45.BaseMutation,
        EyeColor = p45.AssetEyeColor,
        ColorSeed = p45.AssetColorSeed,
        ColorIndex = p45.AssetColorIndex,
        Gender = p45.Gender,
        Personality = p45.Personality or "Normal",
        HasBeenFirstPlaced = p45.HasBeenFirstPlaced == true,
      })
    end

    function f17()
      return v31.AutoSteal or v31.AutoParasiteSteal
    end

    function f44(p46)
      v31.StealPriorityUntil = math.max(v31.StealPriorityUntil or 0, os.clock() + (p46 or 5))
    end

    function f18(p47)
      local parasiteFeedRarities = v31.ParasiteFeedRarities

      if type(parasiteFeedRarities) ~= "table" or #parasiteFeedRarities == 0
        or table.find(parasiteFeedRarities, "None") then
        return false
      end

      return table.find(parasiteFeedRarities, "All") ~= nil
        or table.find(parasiteFeedRarities, p47) ~= nil
    end

    function f19(p48)
      if type(p48) ~= "table" then
        return false
      elseif p48.HasParasite == false then
        return false
      else
        if p48.HasParasite == true then
          return true
        end

        if p48.BaseMutation == "Monstrous" or p48.Mutation == "Monstrous" then
          return true
        end

        if type(p48.Mutations) ~= "table" then
          return false
        end

        for key3, value5 in pairs(p48.Mutations) do
          if value5 == "Monstrous" then
            return true
          end

          if key3 == "Monstrous" and value5 == true then
            return true
          end

          if type(value5) == "table" and (value5.Id == "Monstrous" or value5._id == "Monstrous") then
            return true
          end
        end

        return false
      end
    end

    function f20()
      if not v31.AutoParasiteSteal then
        return false
      else
        local v157 = require(replicatedStorage.Client.EggState).GetAreaEggSnapshot()

        for key4, value6 in pairs(v157 and v157.Records or {}) do
          if (value6.State == "Slot" or value6.State == "Dropped") and value6.BottomCFrame
            and f19(value6) then
            return true
          end
        end

        return false
      end
    end

    function f45()
      if not v31.AutoParasiteSteal then
        return nil
      else
        local v158 = require(replicatedStorage.Shared.Save).Get()
        local eggInventory = v158 and v158.EggInventory

        if type(eggInventory) ~= "table" then
          return nil
        else
          local directory = require(replicatedStorage.Data.Assets).Directory
          local v159 = nil
          local v160 = -1

          for key5, value7 in pairs(eggInventory) do
            if type(value7) == "table" and value7.Placement == nil and f19(value7) then
              local v161 = directory[value7.AssetCategory]
              local rarity = v161 and v161.Rarity
              local displayName = rarity and (rarity.DisplayName or rarity._id) or "Unknown"
              local v162 = rarity and tonumber(rarity.RarityNumber)
              local v163 = f18(displayName)
              local v164 = v162 or 0

              if v163 and v164 > v160 then
                v159 = key5
                v160 = v164
              end
            end
          end

          return v159
        end
      end
    end

    function f46()
      local v165 = require(replicatedStorage.Client.EggState).GetAreaEggSnapshot()
      local directory2 = require(replicatedStorage.Data.Assets).Directory

      for key6, value8 in pairs(v165 and v165.Records or {}) do
        if (value8.State == "Slot" or value8.State == "Dropped") and value8.BottomCFrame then
          local v166 = directory2[value8.AssetCategory]
          local rarity2 = v166 and v166.Rarity

          local displayName2 = rarity2
          displayName2 = rarity2 and (rarity2.DisplayName or rarity2._id)

          if displayName2 == "Secret" or displayName2 == "Eternal" or displayName2 == "Divine" then
            return true
          end
        end
      end

      return false
    end

    function f21(p49, p50)
      if not p49 then
        return
      end

      for index4, value9 in ipairs(p49:GetDescendants()) do
        local v167 = value9

        if v167:IsA("BasePart") then
          if p50 then
            if v32[v167] == nil then
              v32[v167] = v167.CollisionGroup
            end

            pcall(function() v167.CollisionGroup = "GuardsNoCollide" end)
          else
            local v168 = v32[v167]

            if v168 then
              pcall(function() v167.CollisionGroup = v168 end)
            end
          end
        end
      end
    end

    v32 = {}

    v33 = {
      [Enum.HumanoidStateType.Physics] = true,
      [Enum.HumanoidStateType.FallingDown] = true,
      [Enum.HumanoidStateType.Ragdoll] = true,
      [Enum.HumanoidStateType.PlatformStanding] = true,
      [Enum.HumanoidStateType.Seated] = true,
    }

    v34 = 0
    v35 = 0

    runService.Stepped:Connect(function()
      local humanoid3

      if not v31.AntiGuardKnockback then
        return
      else
        local v169 = os.clock()

        if v169 - v35 < 0.05 then
          return
        else
          v35 = v169
          local character3 = localPlayer2.Character

          if not character3 then
            return
          end

          humanoid3 = character3:FindFirstChildOfClass("Humanoid")

          if v169 - v34 >= 0.5 then
            local getDescendants = character3.GetDescendants
            v34 = v169

            for index5, value10 in ipairs(getDescendants(character3)) do
              local v170 = value10

              if v170:IsA("Motor6D") then
                if not v170.Enabled then
                  v170.Enabled = true
                end
              elseif v170:IsA("BallSocketConstraint") or v170:IsA("HingeConstraint") then
                if v170:GetAttribute("RagdollConstraint") or v170.Name:find("Ragdoll") then
                  pcall(function() v170:Destroy() end)
                end
              elseif v170:IsA("Attachment") then
                if v170:GetAttribute("RagdollAttachment") or v170.Name:find("Ragdoll") then
                  pcall(function() v170:Destroy() end)
                end
              end
            end
          end

          if humanoid3 then
            if humanoid3.PlatformStand then
              humanoid3.PlatformStand = false
            end

            if humanoid3.Sit then
              humanoid3.Sit = false
            end

            if v33[humanoid3:GetState()] then
              pcall(function() humanoid3:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
          end

          return
        end
      end
    end)

    zero = Vector3.zero
    v36 = 0

    runService.Heartbeat:Connect(function()
      if not v31.AntiGuardKnockback or v31.IsStealing then
        return
      else
        local v171 = os.clock()

        if v171 - v36 < 0.05 then
          return
        else
          v36 = v171
          local character4 = localPlayer2.Character
          local humanoidRootPart4 = character4 and character4:FindFirstChild("HumanoidRootPart")

          if not humanoidRootPart4 then
            return
          else
            local humanoid4 = character4:FindFirstChildOfClass("Humanoid")
            local walkSpeed = humanoid4 and humanoid4.WalkSpeed or 16
            local assemblyLinearVelocity = humanoidRootPart4.AssemblyLinearVelocity
            local v172 = f16()
            local v173 = math.max(v172 * 1.5, walkSpeed * 1.5, 100)
            local magnitude = (assemblyLinearVelocity - zero).Magnitude

            if assemblyLinearVelocity.Magnitude > v173 and magnitude > 40 then
              humanoidRootPart4.AssemblyLinearVelocity = Vector3.zero
              humanoidRootPart4.AssemblyAngularVelocity = Vector3.zero
              assemblyLinearVelocity = Vector3.zero
            end

            zero = assemblyLinearVelocity
            return
          end
        end
      end
    end)

    localPlayer2.CharacterAdded:Connect(function(character5)
      v32 = {}
      character5:WaitForChild("Humanoid", 5)

      if v31.AntiGuardKnockback then
        f21(character5, true)
      end

      character5.DescendantAdded:Connect(function(descendant)
        if v31.AntiGuardKnockback and descendant:IsA("BasePart") then
          if v32[descendant] == nil then
            v32[descendant] = descendant.CollisionGroup
          end

          pcall(function() descendant.CollisionGroup = "GuardsNoCollide" end)
        end
      end)
    end)

    task.spawn(function()
      local character6 = localPlayer2.Character or localPlayer2.CharacterAdded:Wait()
      character6:WaitForChild("Humanoid", 5)

      if v31.AntiGuardKnockback then
        f21(character6, true)
      end
    end)

    task.spawn(function() end)

    v37 = nil
    v38 = 0
    v39 = 0

    function f22()
      v37 = nil
      v38 = 0
      v39 = 0
    end

    v40 = nil
    v41 = false

    function f23(p51, p52, p53)
      local v174 = f47()

      if not v174 then
        return nil
      else
        local looksLikeFirstAreaUid = v174.LooksLikeFirstAreaUid or v174.IsFirstAreaUid
        local slotKey = v174.SlotKey or v174.BuildSlotKey
        local v175, v176 = pcall(looksLikeFirstAreaUid, tostring(p51))

        if v175 and v176 and type(p52) == "string" and type(p53) == "string" then
          local v177, v178 = pcall(slotKey, p52, p53)

          if v177 then
            return v178
          end

          return nil
        end

        return nil
      end
    end

    function f47()
      if v40 then
        return v40
      else
        local v179, v180 = pcall(function()
          return require(replicatedStorage.Shared.Util.AreaEggSlotIdentity)
        end)

        if v179 and v180 then
          v40 = v180
        elseif not v41 then
          v41 = true

          warn(
            "[SlotKey] Gagal require AreaEggSlotIdentity, FirstAreaSlotKey dipaksa nil (aman buat egg biasa):",
            v180
          )
        end

        return v40
      end
    end

    task.spawn(function()
      local v181 = require(replicatedStorage.Client.EggState)
      local v182 = 0

      while true do
        task.wait((v31.IsStealing or v37) and 0.1 or 0.5)

        if v31.AntiGuardKnockback then
          if not pcall(function()
            local v183

            if v37 then
              local v184 = v181.GetAreaEggRecord(v37.Uid)

              if v184 and v184.State == "Carried" and v184.CarrierUserId == localPlayer2.UserId then
                v183 = v184
              end
            elseif v31.IsStealing then
              local v185 = os.clock()

              if v185 >= v182 then
                v182 = v185 + 0.2
                local v186 = v181.GetAreaEggSnapshot()

                if v186 and v186.Records then
                  for key7, value11 in pairs(v186.Records) do
                    if value11.State == "Carried"
                      and value11.CarrierUserId == localPlayer2.UserId then
                      v183 = value11
                      break
                    end
                  end
                end
              end
            end

            local position3

            if v183 then
              v37 = v183
              v38 = 0
              v39 = 0
              return
            elseif not v37 then
              return
            else
              local v187 = os.clock()

              if v31.IsStealing then
                return
              elseif v187 < v39 then
                return
              elseif v38 >= 20 then
                f22()
                return
              else
                local v188 = v181.GetAreaEggRecord(v37.Uid)

                if v188 == nil or not (v188.State == "Slot" or v188.State == "Dropped") then
                  f22()
                  return
                else
                  v38 = v38 + 1
                  v39 = v187 + 0.1
                  local character7 = localPlayer2.Character

                  local humanoidRootPart5 = character7

                  humanoidRootPart5 = character7
                    and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

                  if humanoidRootPart5 and v188.BottomCFrame then
                    position3 = v188.BottomCFrame.Position

                    if (humanoidRootPart5.Position - position3).Magnitude > 10 then
                      pcall(function()
                        localPlayer2.Character:PivotTo(CFrame.new(position3 + Vector3.new(0, 3, 0)))
                      end)
                    end
                  end

                  local v189 = f23(v188.Uid, v188.AreaId, v188.NestId)
                  v181.RequestCarryAreaEgg(v188.Uid, v189)
                  return
                end
              end
            end
          end) then
            v38 = v38 + 1
            v39 = os.clock() + 0.1

            if v38 >= 20 then
              f22()
            end
          end
        end
      end
    end)

    v42 = {
      Common = 1,
      Uncommon = 2,
      Rare = 3,
      Epic = 4,
      Legendary = 5,
      Mythic = 6,
      Cosmic = 7,
      Secret = 8,
      Eternal = 9,
      Divine = 10,
      Prismatic = 11,
      Transcendent = 12,
    }

    local function f65()
      local napoleonNewUICachedV2Lua = isfile and readfile
        and isfile("Napoleon_NewUI_cached_v2.lua")

      local napoleonNewUICachedV2Lua2

      if napoleonNewUICachedV2Lua then
        pcall(function() napoleonNewUICachedV2Lua2 = readfile("Napoleon_NewUI_cached_v2.lua") end)
      end

      if not napoleonNewUICachedV2Lua2 or napoleonNewUICachedV2Lua2 == ""
        or string.len(napoleonNewUICachedV2Lua2) < 100 then
        for i11 = 1, 3 do
          local v190, v191 = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/iSylvesterr/library/refs/heads/main/NewUI.lua")
          end)

          if v190 and v191 and string.len(v191) > 100
            and not string.match(v191, "404: Not Found") then
            napoleonNewUICachedV2Lua2 = v191

            if writefile then
              pcall(function()
                writefile("Napoleon_NewUI_cached_v2.lua", napoleonNewUICachedV2Lua2)
              end)
            end

            break
          end

          task.wait(1)
        end
      end

      if napoleonNewUICachedV2Lua2 and string.len(napoleonNewUICachedV2Lua2) > 100 then
        napoleonNewUICachedV2Lua2 = string.gsub(
          napoleonNewUICachedV2Lua2, "game:GetService%(\"CoreGui\"%)",
          "game:GetService(\"Players\").LocalPlayer:WaitForChild(\"PlayerGui\")"
        )

        napoleonNewUICachedV2Lua2 = string.gsub(
          napoleonNewUICachedV2Lua2, "game:GetService%('CoreGui'%)",
          "game:GetService(\"Players\").LocalPlayer:WaitForChild(\"PlayerGui\")"
        )

        local v192, v193 = loadstring(napoleonNewUICachedV2Lua2)

        if v192 then
          local v194, v195 = pcall(v192)

          if v194 and v195 then
            return v195
          end

          warn("[NapoleonUI] Execution Error: " .. tostring(v195))
          return nil
        end

        warn("[NapoleonUI] Parse Error: " .. tostring(v193))
        return nil
      end

      return nil
    end

    local v196 = f65()

    if not v196 then
      warn("Failed to load Napoleon UI Library!")
      return
    else
      v43 = {}

      function f36(p54, p55)
        local v197 = {}

        if type(p54) == "table" then
          for key8, value12 in pairs(p54) do
            if type(key8) == "number" then
              table.insert(v197, value12)
            elseif type(key8) == "string" and value12 == true then
              table.insert(v197, key8)
            end
          end
        else
          v197 = { p54 }
        end

        if p55 and v43[p55] then
          return v197
        else
          local v198 = false

          if #v197 > 1 and table.find(v197, "None") then
            local v199 = {}

            for index6, value13 in ipairs(v197) do
              if value13 ~= "None" then
                table.insert(v199, value13)
              end
            end

            v197 = v199
            v198 = true
          elseif #v197 == 0 then
            v197 = { "None" }
            v198 = true
          end

          if v198 and p55 then
            v43[p55] = true
            pcall(function() p55:Set(v197) end)
            v43[p55] = nil
          end

          return v197
        end
      end

      function f25(p56)
        if type(p56) ~= "number" or p56 ~= p56 or p56 <= 0 then
          return
        end

        v44 = v44 + (p56 - v44) * 0.25

        if v44 > 1 then
          v44 = 1
        end
      end

      v44 = 0.016666666666667

      function f48(p57)
        local v200 = tonumber(p57)

        if not v200 then
          return
        else
          local v201 = math.clamp(v200, 1, 1000)

          if math.abs((v31.TweenSpeedMultiplier or 0) - v201) <= 0.001 then
            return
          else
            v31.TweenSpeedMultiplier = v201
            local character8 = localPlayer2.Character

            local humanoid5 = character8
            humanoid5 = character8 and localPlayer2.Character:FindFirstChildOfClass("Humanoid")

            local walkSpeed2 = humanoid5 and humanoid5.WalkSpeed or 0

            warn(string.format(
              "[Spoof] speed statis %d stud/detik (WalkSpeed %.0f, pengali x%.2f).", v201,
              walkSpeed2, walkSpeed2 > 0 and math.clamp(f16() / walkSpeed2, 1, 100) or 1
            ))

            return
          end
        end
      end

      function f49(p58, p59, p60, p61)
        local v202 = os.clock() + p60
        local v203 = 0
        local v204 = math.clamp(0.4, 0.4, 1)
        local v205

        while os.clock() < v202 do
          if p61 and p61() then
            return false
          end

          p58.AssemblyLinearVelocity = Vector3.zero
          p58.AssemblyAngularVelocity = Vector3.zero

          f25(runService.Heartbeat:Wait())

          if (p58.Parent and (p58.Position - p59.Position).Magnitude or math.huge) <= 1.5 then
            p58.CFrame = p59

            local v206 = v205
            v206 = v205 or os.clock()

            local v207 = v203 + 1
            v205 = v206
            v203 = v207

            if v203 >= 3 and os.clock() - v205 >= v204 then
              return true
            end
          else
            v205 = nil
            v203 = 0
          end
        end

        return false
      end

      function f26(p62, p63, p64, p65)
        if not p62 then
          return
        elseif p65 and p65() then
          return
        else
          local v208 = v45[p62]

          if v208 then
            v208.cancelled = true
            v45[p62] = nil
          end

          local magnitude2 = (p64.Position - p62.Position).Magnitude

          if magnitude2 < 0.1 then
            p62.CFrame = p64
            p62.AssemblyLinearVelocity = Vector3.zero
            return
          else
            local parent = p62.Parent
            local v209 = math.clamp(v31 and v31.TweenSpeedMultiplier or 500, 10, 1500)
            f12(parent, v209 * 1.35)
            local v210 = { cancelled = false }
            v45[p62] = v210
            f41()
            local autoRotate = p63 and p63.AutoRotate

            if p63 then
              p63.AutoRotate = false
            end

            local v211 = nil
            local v212 = nil
            local v213 = 0
            local v214 = os.clock() + math.max(magnitude2 / v209, 0.08) * 3 + 8

            while not v210.cancelled do
              if p65 and p65() then
                break
              elseif not p62.Parent then
                break
              elseif os.clock() >= v214 then
                break
              else
                local wait = runService.Heartbeat:Wait()
                local v215 = math.max(math.min(wait, 0.15), 0.0041666666666667)
                local v216 = math.clamp(v31 and v31.TweenSpeedMultiplier or 500, 10, 1500)
                f12(parent, v216 * 1.35)
                local fyyStealAnEggIntegritySpoof3 = f7().__FyyStealAnEggIntegritySpoof

                local state2 = type(fyyStealAnEggIntegritySpoof3) == "table"
                    and fyyStealAnEggIntegritySpoof3.State
                  or nil

                if not f24(state2, p63, p62) then
                  v212 = nil
                  v211 = nil

                  p62.AssemblyLinearVelocity = Vector3.zero
                  p62.AssemblyAngularVelocity = Vector3.zero

                  f10(p62.Position)

                  if f6(state2, p63, p62) then
                    f8(state2, v216 * 1.35, Vector3.zero)
                  else
                    f14(p63, p62, v216)
                  end
                else
                  local position4 = p62.Position
                  local v217 = p64.Position - position4
                  local magnitude3 = v217.Magnitude
                  local vector2 = Vector3.new(v217.X, 0, v217.Z)

                  if v212 and magnitude3 > v212 + 2 then
                    v213 = os.clock() + 0.5
                  end

                  v212 = magnitude3
                  local v218 = (os.clock() < v213 and math.max(10, v216 * 0.45) or v216) * v215

                  local vector3 = Vector3.new(
                    p62.CFrame.LookVector.X, 0, p62.CFrame.LookVector.Z
                  )

                  local unit = vector2.Magnitude > 0.001 and vector2.Unit
                    or vector3.Magnitude > 0.001 and vector3.Unit or Vector3.new(0, 0, -1)

                  if magnitude3 <= math.max(v218, 0.05) then
                    if magnitude3 > 0.5 then
                      v211 = nil
                    end

                    f10(p64.Position)

                    p62.CFrame = CFrame.lookAt(p64.Position, p64.Position + unit)
                    p62.AssemblyLinearVelocity = Vector3.zero

                    f10(p64.Position)
                    f15(p63, p62, v216, Vector3.zero)
                    v211 = v211 or os.clock()

                    if os.clock() - v211 >= 0.4 then
                      break
                    end
                  else
                    v211 = nil
                    local v219 = math.min(v218, magnitude3)
                    local v220 = position4 + v217.Unit * v219
                    local v221 = (v220 - position4) / v215
                    f10(v220)

                    p62.CFrame = CFrame.lookAt(v220, v220 + unit)
                    p62.AssemblyLinearVelocity = v221

                    f10(v220)

                    if not f15(p63, p62, v216, v221) then
                      f14(p63, p62, v216)
                      f15(p63, p62, v216, v221)
                    end
                  end
                end
              end
            end

            if v45[p62] == v210 then
              v45[p62] = nil
            end

            if p63 and autoRotate ~= nil then
              p63.AutoRotate = autoRotate
            end

            p62.AssemblyLinearVelocity = Vector3.zero
            p62.AssemblyAngularVelocity = Vector3.zero

            f11()
            return
          end
        end
      end

      v45 = {}
      vector = Vector3.new(545, 71, -365)
      local v222 = require(replicatedStorage.Shared.Modules.GuardAreas.GuardChasePolicy)

      function f27()
        local v223, v224 = pcall(require, replicatedStorage.Shared.Util.AreaEggCycle)

        if v223 and type(v224.IsNightPhase) == "function" then
          local v225 = workspace
          local v226, v227 = pcall(v224.IsNightPhase, v225:GetServerTimeNow())

          if v226 and v227 == true then
            return true
          end
        end

        local v228, v229 = pcall(require, replicatedStorage.Client.AreaEggResetWall)

        if v228 and v229 then
          if type(v229.IsSealed) == "function" then
            local v230, v231 = pcall(v229.IsSealed)

            if v230 and v231 == true then
              return true
            end
          end

          if type(v229.IsClosed) == "function" then
            local v232, v233 = pcall(v229.IsClosed)

            if v232 and v233 == true then
              return true
            end
          end

          local v234 = type(v229.ResolveWallPart) == "function" and v229.ResolveWallPart()

          if v234 and v234.CanCollide then
            return true
          end

          return false
        end

        return false
      end

      resolveHitDistance = v222.ResolveHitDistance

      function v222.ResolveHitDistance(p66)
        local v235 = resolveHitDistance(p66)
        return math.max(v235, 25)
      end

      function f50(p67, p68)
        if not p67 or typeof(p68) ~= "CFrame" then
          return false
        else
          pcall(function()
            p67.AssemblyLinearVelocity = Vector3.zero
            p67.AssemblyAngularVelocity = Vector3.zero
            p67.CFrame = p68
            p67.AssemblyLinearVelocity = Vector3.zero
            p67.AssemblyAngularVelocity = Vector3.zero
          end)

          f10(p68.Position)
          local parent2 = p67.Parent
          local humanoid6 = parent2 and parent2:FindFirstChildOfClass("Humanoid")

          if humanoid6 then
            f15(humanoid6, p67, 1000, Vector3.zero)
          end

          return true
        end
      end

      function f28(uid, p69)
        local humanoidRootPart6 = localPlayer2.Character
          and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart6 then
          pcall(function()
            humanoidRootPart6.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart6.AssemblyAngularVelocity = Vector3.zero
          end)
        end

        local getValue = 0
        pcall(function() getValue = stats.Network.ServerStats.Ping:GetValue() end)
        task.wait(math.max(0.3, getValue * 2.5 / 1000))
        local eggWorld = require(replicatedStorage.Shared.Remotes).EggWorld
        local v236 = { Uid = uid }

        if p69 then
          v236.FirstAreaSlotKey = p69
        end

        return eggWorld.AskFieldEggCarry:InvokeServer(v236) == true
      end

      function f51(p70, p71)
        if not p70 or typeof(p71) ~= "CFrame" then
          return false
        else
          local position5 = p70.Position
          local position6 = p71.Position
          local v237 = math.max(1, math.ceil((position6 - position5).Magnitude / 10000))

          for i12 = 1, v237 do
            local lerp = position5:Lerp(position6, i12 / v237)

            if not f50(p70, CFrame.new(lerp) * p71.Rotation) then
              return false
            elseif i12 < v237 then
              task.wait(0.02)
            end
          end

          return true
        end
      end

      function f29(p72)
        if not p72 then
          return false
        else
          local v238 = p72.Position - vector
          return Vector2.new(v238.X, v238.Z).Magnitude <= 30 and math.abs(v238.Y) <= 18
        end
      end

      v46 = {
        Script = true,
        LocalScript = true,
        BillboardGui = true,
        Sound = true,
      }

      function f52()
        local v239 = {}
        setmetatable(v239, { __mode = "k" })
        return v239
      end

      v47 = {}
      v47.__index = v47

      function v47.new()
        local v240 = setmetatable({}, v47)
        v240.enabled = false
        v240.running = false
        v240.phase = "idle"
        v240.primerUid = nil
        v240.targetUid = nil
        v240.activeTarget = nil
        v240.carryActive = false
        v240.carryUid = nil
        v240.arrivalHold = nil
        v240.hitTimer = nil
        v240.planGeneration = 0
        v240.connections = {}
        v240.records = {}
        v240.stats = { status = "Idle" }
        v240._decoy = nil
        v240._decoyCamera = nil
        v240._decoyCameraConnection = nil
        v240._decoyRealTransparency = nil
        v240:_connect()

        return v240
      end

      function v47:_connect()
        local v241 = require(replicatedStorage.Client.EggState)
        local fieldRefreshed = v241.FieldRefreshed

        table.insert(
          self.connections, fieldRefreshed:Connect(function(p73) self:_replaceSnapshot(p73) end)
        )

        local fieldShifted = v241.FieldShifted

        table.insert(self.connections, fieldShifted:Connect(function(p74)
          if p74 and p74.Uid then
            self.records[p74.Uid] = p74
          end

          self:_refreshCounts()
        end))

        local fieldGone = v241.FieldGone

        table.insert(self.connections, fieldGone:Connect(function(p75)
          self.records[p75] = nil

          if self.activeTarget and self.activeTarget.Uid == p75 then
            if self.phase == "hunting" then
              self:_finish("Target gone")
            end
          end

          self:_refreshCounts()
        end))

        local carryChanged = v241.CarryChanged

        table.insert(self.connections, carryChanged:Connect(function(p76)
          if p76.IsCarrying then
            if self.running and self.activeTarget and p76.Uid == self.activeTarget.Uid then
              self.carryActive = true
              self.carryUid = p76.Uid

              if self.phase == "priming" then
                self:_enterBaitWait()
              elseif self.phase == "hunting" then
                self:_returnToSafe()
              end
            end

            return
          elseif not self.carryActive then
            return
          else
            local uid2 = p76.Uid or self.carryUid or self.activeTarget and self.activeTarget.Uid

            self.carryActive = false
            self.carryUid = nil

            if not self.running or not self.activeTarget then
              return
            else
              local humanoidRootPart7 = localPlayer2.Character
                and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

              if humanoidRootPart7 and f29(humanoidRootPart7) then
                self:_finish("Safe return complete")
                return
              end

              if self.phase == "priming" and uid2 == self.primerUid then
                self:_startHunt()
                return
              end

              return
            end
          end
        end))

        local characterRemoving = localPlayer2.CharacterRemoving

        table.insert(self.connections, characterRemoving:Connect(function()
          self:_kbCancelTimer()
          self.running = false
          self.carryActive = false
          self.carryUid = nil
          self.arrivalHold = nil
          self:_removeDecoy()
        end))

        local heartbeat = runService.Heartbeat

        table.insert(self.connections, heartbeat:Connect(function()
          if self.running and typeof(f27) == "function" and f27() then
            self:_handleNightRetreat()
            return
          end

          self:_enforceArrivalHold()
        end))
      end

      function v47:_replaceSnapshot(p77)
        table.clear(self.records)

        for key9, value14 in pairs(p77 and (p77.Records or p77) or {}) do
          if type(value14) == "table" and type(value14.Uid) == "string" then
            self.records[value14.Uid] = value14
          elseif type(key9) == "string" and type(value14) == "table" then
            self.records[key9] = value14
          end
        end

        self:_refreshCounts()
      end

      function v47:_refreshCounts()
      end

      function v47:_setStatus(status)
        self.stats.status = status
      end

      function v47:_spawnDecoy()
        local parent3 = self._decoy and self._decoy.Parent
        local fyyDecoy, humanoid7

        if parent3 then
          return self._decoy
        else
          local character9 = localPlayer2.Character

          if not character9 then
            return nil
          else
            local archivable = character9.Archivable
            character9.Archivable = true

            local v242
            v242, fyyDecoy = pcall(character9.Clone, character9)

            character9.Archivable = archivable

            if not v242 or not fyyDecoy or typeof(fyyDecoy) ~= "Instance" then
              return nil
            end

            fyyDecoy.Name = "__FyyDecoy"

            for index7, value15 in ipairs(fyyDecoy:GetDescendants()) do
              if v46[value15.ClassName] then
                pcall(value15.Destroy, value15)
              elseif value15:IsA("BasePart") then
                value15.LocalTransparencyModifier = 0
                value15.Anchored = true
                value15.CanCollide = false
                value15.CanQuery = false
                value15.CanTouch = false
              end
            end

            humanoid7 = fyyDecoy:FindFirstChildOfClass("Humanoid")

            if not humanoid7 then
              fyyDecoy:Destroy()
              return nil
            else
              pcall(function()
                humanoid7.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                humanoid7.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
              end)

              fyyDecoy.Parent = workspace
              fyyDecoy:PivotTo(CFrame.new(vector))

              self._decoy = fyyDecoy
              local v243 = f52()

              for index8, value16 in ipairs(character9:GetDescendants()) do
                if value16:IsA("BasePart") or value16:IsA("Decal") or value16:IsA("Texture") then
                  v243[value16] = {
                    ltm = value16:IsA("BasePart") and value16.LocalTransparencyModifier or nil,
                    trans = value16.Transparency,
                  }

                  if value16:IsA("BasePart") then
                    value16.LocalTransparencyModifier = 1
                  end

                  value16.Transparency = 1
                elseif value16:IsA("ParticleEmitter") or value16:IsA("Trail")
                  or value16:IsA("Beam") or value16:IsA("Fire") or value16:IsA("Smoke")
                  or value16:IsA("Sparkles") then
                  v243[value16] = { enabled = value16.Enabled }
                  value16.Enabled = false
                end
              end

              self._decoyRealTransparency = v243
              local currentCamera = workspace.CurrentCamera

              if currentCamera then
                self._decoyCamera = currentCamera.CameraSubject
                currentCamera.CameraSubject = humanoid7

                self._decoyCameraConnection = runService.RenderStepped:Connect(function()
                  local currentCamera2 = workspace.CurrentCamera

                  if self._decoy == fyyDecoy and fyyDecoy.Parent and humanoid7.Parent
                    and currentCamera2 then
                    if currentCamera2.CameraSubject ~= humanoid7 then
                      currentCamera2.CameraSubject = humanoid7
                    end
                  end
                end)
              end

              return fyyDecoy
            end
          end
        end
      end

      function v47:_removeDecoy()
        if self._decoyCameraConnection then
          pcall(self._decoyCameraConnection.Disconnect, self._decoyCameraConnection)
          self._decoyCameraConnection = nil
        end

        local currentCamera3 = workspace.CurrentCamera
        local character10 = localPlayer2.Character
        local humanoid8 = character10 and character10:FindFirstChildOfClass("Humanoid")

        if currentCamera3 then
          pcall(function() currentCamera3.CameraSubject = humanoid8 or self._decoyCamera end)
        end

        self._decoyCamera = nil

        for key10, value17 in pairs(self._decoyRealTransparency or {}) do
          local v244 = key10
          local v245 = value17

          if typeof(v244) == "Instance" and v244.Parent then
            pcall(function()
              if v244:IsA("BasePart") then
                v244.LocalTransparencyModifier = v245.ltm or 0
              end

              if v245.trans ~= nil then
                v244.Transparency = v245.trans
              end

              if v245.enabled ~= nil then
                v244.Enabled = v245.enabled
              end
            end)
          end
        end

        self._decoyRealTransparency = nil

        if self._decoy then
          pcall(self._decoy.Destroy, self._decoy)
        end

        self._decoy = nil
      end

      function v47:_kbCancelTimer()
        if self.hitTimer then
          pcall(task.cancel, self.hitTimer)
          self.hitTimer = nil
        end
      end

      function v47:_handleNightRetreat()
        self.running = false
        self.phase = "idle"
        self.primerUid = nil
        self.targetUid = nil
        self.activeTarget = nil
        self.carryActive = false
        self.carryUid = nil
        self:_clearArrivalHold()
        self:_kbCancelTimer()

        local character11 = localPlayer2.Character
        local humanoidRootPart8 = character11 and character11:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart8 and not f29(humanoidRootPart8) then
          f50(humanoidRootPart8, (CFrame.new(vector + Vector3.new(0, 3.5, 0))))
        end

        self:_setStatus("Waiting for day (Safe)")
      end

      function v47:_choosePrimerEgg(p78)
        local v246 = require(replicatedStorage.Shared.Util.AssetItems)
        local v247 = require(replicatedStorage.Shared.Types.AreaEggs)

        local humanoidRootPart9 = localPlayer2.Character
          and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

        local v248, v249

        for key11, value18 in pairs(self.records) do
          if value18.State ~= v247.States.Slot then
          elseif value18.AreaId ~= "Forest" then
          elseif value18.Uid == p78 then
          else
            local magnitude4 = humanoidRootPart9
                and (value18.BottomCFrame.Position - humanoidRootPart9.Position).Magnitude
              or math.huge

            local v250 = -(v246.RarityRankForCategory(value18.AssetCategory) or 0) * 1000000
              - magnitude4

            if not v249 or v250 > v248 then
              v248 = v250
              v249 = value18
            end
          end
        end

        return v249
      end

      function f53(p79)
        return ({
          Common = 1,
          Uncommon = 2,
          Rare = 3,
          Epic = 4,
          Legendary = 5,
          Mythic = 6,
          Cosmic = 7,
          Secret = 8,
          Eternal = 9,
          Divine = 10,
        })[p79] or 0
      end

      function f54(p80)
        local v251 = require(replicatedStorage.Data.Assets)
        local directory3 = v251 and v251.Directory and v251.Directory[p80.AssetCategory]
        local rarity3 = directory3 and directory3.Rarity

        if not rarity3 then
          return "Unknown"
        elseif type(rarity3) == "string" then
          return rarity3
        else
          return rarity3.DisplayName or rarity3._id or tostring(rarity3)
        end
      end

      function v47:_chooseTarget()
        local v252 = require(replicatedStorage.Shared.Util.AssetItems)
        local v253 = require(replicatedStorage.Shared.Types.AreaEggs)

        local humanoidRootPart10 = localPlayer2.Character
          and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

        local stealNamesFilter = v31.StealNamesFilter or {}
        local stealAreas = v31.StealAreas or {}
        local stealRarities = v31.StealRarities or {}

        local v254 = #stealRarities > 0 and table.find(stealRarities, "None") == nil
          and table.find(stealRarities, "All") == nil

        local v255 = #stealAreas > 0 and table.find(stealAreas, "None") == nil
          and table.find(stealAreas, "All") == nil

        local v256 = #stealNamesFilter > 0 and table.find(stealNamesFilter, "None") == nil
          and table.find(stealNamesFilter, "All") == nil

        local v257 = require(replicatedStorage.Data.Assets)
        local directory4 = v257 and v257.Directory or {}
        local v258, v259, v260

        for key12, value19 in pairs(self.records) do
          if value19.State ~= v253.States.Slot and value19.State ~= v253.States.Dropped then
          elseif value19.Uid == self.primerUid then
          else
            local assetCategory2 = value19.AssetCategory or "Unknown"
            local areaId = value19.AreaId or "Unknown"
            local v261 = directory4[assetCategory2]
            local v262 = f54(value19)
            local displayName3 = v261 and v261.DisplayName or assetCategory2
            local v263 = not v255 or table.find(stealAreas, areaId) ~= nil
            local v264 = not v254

            local v265 = v264
            v265 = v264 or table.find(stealRarities, v262) ~= nil

            if v263
              and v265
              and (not v256 or table.find(stealNamesFilter, assetCategory2) ~= nil
                or table.find(stealNamesFilter, displayName3) ~= nil)
              and (not v31.StealMinValue or v31.StealMinValue <= 0
                or v31:getAreaEggValue(value19) > v31.StealMinValue) then
              local magnitude5 = humanoidRootPart10
                  and (value19.BottomCFrame.Position - humanoidRootPart10.Position).Magnitude
                or math.huge

              local v266 = f53(v262)
              local v267 = v266 > 0 and v266

              local v268 = v267
              v268 = v267 or v252.RarityRankForCategory(assetCategory2) or 0

              if not v259 or v268 > v260 or v268 == v260 and magnitude5 < v258 then
                v259 = value19
                v260 = v268
                v258 = magnitude5
              end
            end
          end
        end

        return v259
      end

      function v47:_schedule()
        local destroyed = self.destroyed or not self.enabled or self.running
        local v269

        if destroyed then
          return
        elseif not v30 then
          self:_setStatus("Waiting for UI")

          task.delay(0.5, function()
            if not self.destroyed and self.enabled and not self.running then
              self:_schedule()
            end
          end)

          return
        else
          local character12 = localPlayer2.Character

          local humanoidRootPart11 = character12
            and character12:FindFirstChild("HumanoidRootPart")

          if not humanoidRootPart11 then
            self:_setStatus("No character")

            task.delay(1, function()
              if not self.destroyed and self.enabled and not self.running then
                self:_schedule()
              end
            end)

            return
          end

          v269 = require(replicatedStorage.Client.EggState)

          pcall(function()
            local v270 = v269.GetAreaEggSnapshot()

            if v270 then
              self:_replaceSnapshot(v270)
            end
          end)

          if typeof(f27) == "function" and f27() then
            self:_handleNightRetreat()

            task.delay(1, function()
              if not self.destroyed and self.enabled and not self.running then
                self:_schedule()
              end
            end)

            return
          else
            local chooseTarget = self:_chooseTarget()

            if not chooseTarget then
              self:_setStatus("Waiting for target egg")

              task.delay(1, function()
                if not self.destroyed and self.enabled and not self.running then
                  self:_schedule()
                end
              end)

              return
            else
              local choosePrimerEgg = self:_choosePrimerEgg(chooseTarget.Uid)

              if not choosePrimerEgg then
                self:_setStatus("Waiting for Forest primer")

                task.delay(0.25, function()
                  if not self.destroyed and self.enabled and not self.running then
                    self:_schedule()
                  end
                end)

                return
              else
                self.phase = "priming"
                self.primerUid = choosePrimerEgg.Uid
                self.targetUid = chooseTarget.Uid
                self.activeTarget = choosePrimerEgg
                self.running = true
                self:_setStatus("Teleport to primer")

                local cframe2 = CFrame.new(choosePrimerEgg.BottomCFrame.Position)

                if not f51(humanoidRootPart11, cframe2) then
                  self:_finish("Teleport primer failed")
                  return
                else
                  self:_setArrivalHold(cframe2, choosePrimerEgg.Uid)
                  local v271 = os.clock() + 3

                  while self.running and not self.carryActive and os.clock() < v271 do
                    self:_requestCarry(choosePrimerEgg)
                    task.wait(0.3)
                  end

                  if not self.carryActive then
                    self:_finish("Primer carry timeout")
                    return
                  end

                  return
                end
              end
            end
          end
        end
      end

      function v47:_requestCarry(p81)
        local v272 = require(replicatedStorage.Shared.Util.AreaEggSlotIdentity)

        if not self.running then
          return
        else
          local uid3 = p81.Uid
          local looksLikeFirstAreaUid2 = v272.LooksLikeFirstAreaUid

          if not looksLikeFirstAreaUid2 and v272.IsFirstAreaUid then
            looksLikeFirstAreaUid2 = v272.IsFirstAreaUid
          end

          local v273 = nil

          if looksLikeFirstAreaUid2 and looksLikeFirstAreaUid2(uid3) then
            v273 = v272.SlotKey(p81.AreaId, p81.NestId)
          end

          self:_setStatus("Requesting carry")
          f28(uid3, v273)
          return
        end
      end

      function v47:_enterBaitWait()
        self:_setStatus("Waiting for guard hit")

        if self.hitTimer then
          return
        end

        self.hitTimer = task.delay(12, function()
          self.hitTimer = nil

          if self.destroyed or not self.enabled then
            return
          elseif self.phase ~= "priming" then
            return
          else
            self:_clearArrivalHold()
            self:_finish("Guard timeout")
            return
          end
        end)
      end

      function v47:_startHunt()
        local v274 = require(replicatedStorage.Client.EggState)
        local v275 = require(replicatedStorage.Shared.Types.AreaEggs)

        self:_kbCancelTimer()
        self.phase = "hunting"
        self.primerUid = nil
        self:_clearArrivalHold()

        local targetUid = self.targetUid
        self.targetUid = nil

        if not targetUid then
          self:_finish("No target")
          return
        else
          local v276 = nil

          if type(v274.ReadFieldEgg) == "function" then
            v276 = v274.ReadFieldEgg(targetUid)
          end

          if not v276 then
            v276 = self.records[targetUid]
          end

          if not v276 or v276.State ~= v275.States.Slot and v276.State ~= v275.States.Dropped then
            self:_finish("Target gone")
            return
          else
            local character13 = localPlayer2.Character

            local humanoidRootPart12 = character13
            humanoidRootPart12 = character13 and character13:FindFirstChild("HumanoidRootPart")

            if not humanoidRootPart12 then
              self:_finish("No character")
              return
            else
              self.activeTarget = v276
              self:_setStatus("Teleport to target")

              local cframe3 = CFrame.new(v276.BottomCFrame.Position)

              if not f51(humanoidRootPart12, cframe3) then
                self:_finish("Teleport target failed")
                return
              else
                self:_setArrivalHold(cframe3, v276.Uid)
                self:_setStatus("Stealing target")

                local v277 = os.clock() + 3

                while self.running and not self.carryActive and os.clock() < v277 do
                  self:_requestCarry(v276)
                  task.wait(0.3)
                end

                if not self.carryActive then
                  self:_finish("Target carry timeout")
                  return
                end

                return
              end
            end
          end
        end
      end

      function v47:_returnToSafe()
        if not self.carryActive then
          self:_finish("No carry")
          return
        else
          self:_clearArrivalHold()
          local character14 = localPlayer2.Character

          local humanoidRootPart13 = character14
            and character14:FindFirstChild("HumanoidRootPart")

          if not humanoidRootPart13 then
            self:_finish("No character")
            return
          elseif f29(humanoidRootPart13) then
            self:_finish("Safe return complete")
            return
          else
            self:_setStatus("Teleport to safe")
            local cframe4 = CFrame.new(vector)

            if not f51(humanoidRootPart13, cframe4) then
              self:_finish("Safe teleport failed")
              return
            else
              self:_setArrivalHold(cframe4)
              local v278 = os.clock() + 6

              while self.carryActive and os.clock() < v278 do
                local humanoidRootPart14 = localPlayer2.Character
                  and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart14 and f29(humanoidRootPart14) then
                  self:_setStatus("Waiting deposit")
                  task.wait(0.1)
                else
                  break
                end
              end

              self:_finish("Safe return complete")
              return
            end
          end
        end
      end

      function v47:_setArrivalHold(cframe5, uid4)
        self.arrivalHold = { CFrame = cframe5, Uid = uid4 }
      end

      function v47:_clearArrivalHold(p82)
        if not self.arrivalHold then
          return
        end

        if p82 == nil or self.arrivalHold.Uid == nil or self.arrivalHold.Uid == p82 then
          self.arrivalHold = nil
        end
      end

      function v47:_enforceArrivalHold()
        local arrivalHold = self.arrivalHold
        local v279 = not arrivalHold or typeof(arrivalHold.CFrame) ~= "CFrame"
        local humanoidRootPart15

        if v279 then
          return
        else
          local character15 = localPlayer2.Character
          humanoidRootPart15 = character15 and character15:FindFirstChild("HumanoidRootPart")

          if not humanoidRootPart15 or not humanoidRootPart15.Parent then
            self.arrivalHold = nil
            return
          end

          pcall(function()
            humanoidRootPart15.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart15.AssemblyAngularVelocity = Vector3.zero
            humanoidRootPart15.CFrame = arrivalHold.CFrame
          end)

          return
        end
      end

      function v47:_finish(p83)
        self.phase = "idle"
        self.primerUid = nil
        self.targetUid = nil
        self.activeTarget = nil
        self.carryActive = false
        self.carryUid = nil
        self.running = false
        self:_clearArrivalHold()
        self:_kbCancelTimer()
        self.planGeneration = self.planGeneration + 1
        self:_setStatus("Idle")

        local character16 = localPlayer2.Character

        local humanoidRootPart16 = character16
          and character16:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart16 and not f29(humanoidRootPart16) then
          f50(humanoidRootPart16, (CFrame.new(vector)))
        end

        if self.enabled and not self.destroyed then
          task.delay(0.5, function()
            if not self.destroyed and self.enabled then
              self:_schedule()
            end
          end)
        end
      end

      function v47:_startWatchdog()
        if self._watchdogRunning then
          return
        end

        self._watchdogRunning = true

        task.spawn(function()
          local v280 = 0

          while self.enabled and not self.destroyed do
            task.wait(0.5)

            if self.enabled and not self.destroyed then
              if self.running then
                if v280 == 0 then
                  v280 = os.clock()
                elseif os.clock() - v280 > 15 then
                  v280 = 0
                  self:_finish("Stuck recovery")
                end
              else
                v280 = 0

                if not (typeof(f27) == "function" and f27()) then
                  self:_schedule()
                else
                  local character17 = localPlayer2.Character

                  local humanoidRootPart17 = character17

                  humanoidRootPart17 = character17
                    and character17:FindFirstChild("HumanoidRootPart")

                  if humanoidRootPart17 and not f29(humanoidRootPart17) then
                    f50(humanoidRootPart17, (CFrame.new(vector + Vector3.new(0, 3.5, 0))))
                  end
                end
              end
            end
          end

          self._watchdogRunning = false
        end)
      end

      function v47:setEnabled(p84)
        self.enabled = p84 == true

        if self.enabled then
          local v281 = require(replicatedStorage.Client.EggState)

          self:_setStatus("Starting")
          self:_replaceSnapshot(v281.GetAreaEggSnapshot())
          self:_spawnDecoy()
          self:_startWatchdog()
          self:_schedule()
        else
          self:_removeDecoy()
          self:_finish("Disabled")
        end
      end

      function v47.destroy(p85)
        p85.destroyed = true
        p85.enabled = false
        p85:_removeDecoy()
        p85:_finish("Destroyed")

        for index9, value20 in ipairs(p85.connections) do
        end

        table.clear(p85.connections)
        table.clear(p85.records)
      end

      v48 = v47.new()

      getgenv().icRunner = v48
      getgenv().NapoleonConfig = v31

      function f37(p86, p87, p88, p89)
        local v282 = not p86 or not p86.Parent
        local v283

        if v282 then
          return false
        elseif p89 and p89() then
          return false
        else
          local animate = p86.Parent:FindFirstChild("Animate")
          local enabled = animate and animate:IsA("LocalScript") and animate.Enabled
          local autoRotate2 = p87 and p87.AutoRotate
          v283 = false

          local function f66()
            if v283 then
              return true
            end

            v283 = p89 and p89() or false
            return v283
          end

          if p87 then
            p87:Move(Vector3.zero, false)
            p87.AutoRotate = false

            local animator = p87:FindFirstChildOfClass("Animator")

            if animator then
              for index10, value21 in ipairs(animator:GetPlayingAnimationTracks()) do
                value21:Stop(0.1)
              end
            end
          end

          if enabled then
            animate.Enabled = false
          end

          local v284 = v45[p86]

          if v284 then
            v284.cancelled = true
          end

          local v285 = { cancelled = false }
          v45[p86] = v285
          local v286 = math.min(f16() * 1.5, 1500)
          local cframe6 = p86.CFrame
          local position7 = cframe6.Position
          local v287 = p88.Position - position7
          local magnitude6 = Vector3.new(v287.X, 0, v287.Z).Magnitude

          if magnitude6 < 0.1 then
            p86.CFrame = p88
            v45[p86] = nil

            if p87 and p87.Parent then
              p87:Move(Vector3.zero, false)
              p87.AutoRotate = autoRotate2
            end

            if enabled and animate.Parent then
              animate.Enabled = true
            end

            p86.AssemblyLinearVelocity = Vector3.zero
            p86.AssemblyAngularVelocity = Vector3.zero

            return true
          else
            local v288 = math.min(10, math.max(3, magnitude6 * 0.08))
            local v289 = math.min(24, math.max(4, v286 / 60))
            local v290 = false
            local v291 = math.max(v44, 0.016666666666667)
            local v292 = os.clock() + magnitude6 / math.max(v289 / v291, 1) * 3 + 4
            local total2 = 0

            while not v285.cancelled and not f66() do
              if os.clock() >= v292 then
                break
              else
                local wait2 = runService.Heartbeat:Wait()

                if type(wait2) ~= "number" or wait2 ~= wait2 or wait2 <= 0 then
                  wait2 = 0.016666666666667
                end

                f25(wait2)

                total2 = total2
                  + math.min(magnitude6 - total2, v286 * math.min(wait2, 0.15), v289)

                local v293 = total2 / magnitude6

                local v294 = position7 + v287 * v293
                  + Vector3.new(0, math.sin(math.pi * v293) * v288, 0)

                local lerp2 = cframe6.Rotation:Lerp(p88.Rotation, v293)

                if p87 and p87.Parent then
                  p87:Move(Vector3.zero, false)
                end

                p86.CFrame = CFrame.new(v294) * lerp2
                p86.AssemblyLinearVelocity = Vector3.zero
                p86.AssemblyAngularVelocity = Vector3.zero

                if v293 >= 1 then
                  v290 = true
                  break
                end
              end
            end

            if v290 and not v285.cancelled and not v283 then
              p86.CFrame = p88
            end

            if v45[p86] == v285 then
              v45[p86] = nil
            end

            if p87 and p87.Parent then
              p87:Move(Vector3.zero, false)
              p87.AutoRotate = autoRotate2
            end

            if enabled and animate.Parent then
              animate.Enabled = true
            end

            p86.AssemblyLinearVelocity = Vector3.zero
            p86.AssemblyAngularVelocity = Vector3.zero

            return v290 and not v285.cancelled and not v283
          end
        end
      end

      function f30()
        local v295, v296 = pcall(function()
          return require(replicatedStorage.Shared.Remotes).Treadmill.AskRenderSnapshot:InvokeServer()
        end)

        if not v295 or type(v296) ~= "table" then
          return nil
        end

        return table.find(v296, localPlayer2.UserId) ~= nil
      end

      function f31()
        local v297, v298, v299 = pcall(function()
          return require(replicatedStorage.Shared.Remotes).Treadmill.AskDoff:InvokeServer()
        end)

        if not v297 then
          return false, tostring(v298)
        end

        if v298 ~= true then
          return false, tostring(v299)
        end

        return true
      end

      function f32()
        local v300, v301 = pcall(function()
          local v302 = require(replicatedStorage.Client.PlotState).GetMySlot()

          if v302 == nil then
            return nil
          else
            local clientTreadmillRenders = workspace:FindFirstChild("__ClientTreadmillRenders")

            if not clientTreadmillRenders then
              return nil
            else
              local findFirstChild = clientTreadmillRenders:FindFirstChild("TreadmillRender_"
                .. tostring(v302))

              if not findFirstChild then
                return nil
              else
                local root = findFirstChild:FindFirstChild("Root")

                if root and root:IsA("BasePart") then
                  return root
                end

                return nil
              end
            end
          end
        end)

        if not v300 then
          return nil
        end

        return v301
      end

      task.spawn(function()
        local debris = workspace:FindFirstChild("__DEBRIS")
          or workspace:WaitForChild("__DEBRIS", 10)

        if not debris then
          warn("[AntiTrap] workspace.__DEBRIS gak ketemu, gak bisa mantau trap.")
          return
        end

        for index11, value22 in ipairs(debris:GetChildren()) do
        end

        debris.ChildAdded:Connect(function(child) end)
      end)

      v49 = nil
      v50 = false

      function f55()
        v50 = false

        if v49 == nil then
          return true
        elseif f30() == false then
          v49 = nil
          return true
        else
          local v303, v304 = f31()

          if not v303 then
            warn("[Treadmill] Gagal minta lepas dari treadmill sebelum steal:", v304)
          end

          local total3 = 0

          while true do
            if v49 ~= nil and total3 < 1.5 then
              task.wait(0.05)
              total3 = total3 + 0.05

              if not f17() then
                return false
              elseif f30() == false then
                break
              end
            else
              if v49 ~= nil then
                warn("[Treadmill] Lepas treadmill gak kekonfirmasi dalam 1.5s, steal dilanjut apa adanya.")
                return false
              end

              task.wait(0.12)
              return true
            end
          end

          v49 = nil

          if v49 ~= nil then
            warn("[Treadmill] Lepas treadmill gak kekonfirmasi dalam 1.5s, steal dilanjut apa adanya.")
            return false
          end

          task.wait(0.12)
          return true
        end
      end

      task.spawn(function()
        local v305, v306 = pcall(function()
          require(replicatedStorage.Shared.Remotes).Treadmill.RenderStateShifted.OnClientEvent:Connect(function(p90)
            v49 = p90

            if p90 == nil then
              return
            end

            if v50 and v31.AutoTreadmillIdle and not v31.IsStealing then
              return
            end

            if not v31.AntiTreadmillMount then
              return
            end

            task.spawn(function()
              task.wait(0.05)

              if not v31.AntiTreadmillMount then
                return
              else
                local v307, v308 = f31()

                if not v307 then
                  warn("[AntiTreadmill] Ke-detect ke-mount tapi gagal minta lepas:", v308)
                end

                return
              end
            end)
          end)
        end)

        if not v305 then
          warn("[AntiTreadmill] Gagal setup listener:", v306)
        end
      end)

      task.spawn(function()
        task.wait(3)

        while true do
          local v309 = f30()

          if v309 ~= nil then
            if not v309 then
              v49 = nil
            elseif v49 == nil then
              v49 = "unknown"
            end

            if v309 and v31.AntiTreadmillMount and not v50 then
              local v310, v311 = f31()

              if not v310 then
                warn(
                  "[AntiTreadmill] Rekonsiliasi: ke-detect mounted tapi gagal minta lepas:",
                  v311
                )
              end
            end
          end

          task.wait(30)
        end
      end)

      Color3.fromRGB(120, 120, 120)

      napoleonWindow = v196:Window({
        Title = "Napoleon",
        Footer = "Steal An Egg",
        Color = Color3.fromRGB(50, 50, 50),
        Color2 = Color3.fromRGB(20, 20, 20),
        ["Tab Width"] = 130,
        Image = "111895858615511",
        WindowIMG = "91334002283698",
        LogoHUB = "119958938217417",
      })

      function f33(p91)
        local objects = workspace:FindFirstChild("__OBJECTS")
        local areas = objects and objects:FindFirstChild("Areas")
        local guardAreas = areas and areas:FindFirstChild("GuardAreas")

        if not guardAreas then
          return false
        end

        for index12, value23 in ipairs(guardAreas:GetChildren()) do
          local bounds = value23:FindFirstChild("Bounds")

          if bounds and bounds:IsA("BasePart") then
            local pointToObjectSpace = bounds.CFrame:PointToObjectSpace(p91)

            if math.abs(pointToObjectSpace.X) <= bounds.Size.X * 0.5
              and math.abs(pointToObjectSpace.Z) <= bounds.Size.Z * 0.5 then
              return true
            end
          end
        end

        return false
      end

      v51 = {}

      function f34()
        return v31.AutoParasiteSteal or v31.AutoParasiteClaim
      end

      function f35()
        local v312 = v31.StealMode == "Teleport" or v31.StealMode == "Instant"
        local v313, v314, v315, v316, v317, v318, f67, v319, v320, v321

        if v312 then
          return
        else
          v315 = require(replicatedStorage.Client.EggState)

          if not v31._eggSyncState then
            v316 = { CarryState = nil, ClaimRevision = 0 }

            v316.CarryConnection = v315.AreaEggCarryStateChanged:Connect(function(p92)
              v316.CarryState = p92

              if p92.IsCarrying and p92.Uid then
                v316.LastCarryState = p92
              end
            end)

            v316.ClaimConnection = v315.AreaEggClaimed:Connect(function(lastClaim)
              v316.ClaimRevision = v316.ClaimRevision + 1
              v316.LastClaim = lastClaim
            end)

            v31._eggSyncState = v316
          end

          local v322

          v322, v317 = pcall(function()
            return require(replicatedStorage.Client.AreaEggResetWall)
          end)

          if not v322 then
            warn("[AutoSteal] Gagal require AreaEggResetWall, skip pengecekan wall:", v317)
            v317 = nil
          end

          local v323
          v323, v318 = pcall(function() return require(replicatedStorage.Data.Assets) end)

          if not v323 then
            warn(
              "[AutoSteal] Gagal require Directory.Assets, rarity semua egg dianggap Unknown:",
              v318
            )

            v318 = nil
          end

          local v324 = 0

          function f67(p93)
            local v325 = v318 and v318.Directory[p93.AssetCategory]
            local rarity4 = v325 and v325.Rarity

            if not rarity4 then
              return "Unknown"
            end

            return rarity4.DisplayName or rarity4._id or "Unknown"
          end

          v319 = {}
          local v326 = false
          v320 = 0
          v321 = false
          local v327 = 0
          local v328 = nil
          f44()

          while f17() do
            if v31.IsParasiteProcessing then
              v31.IsStealing = false
              runService.Heartbeat:Wait()
            else
              local v329 = os.clock()

              for key13, value24 in pairs(v319) do
                if v329 - value24 > 5 then
                  v319[key13] = nil
                end
              end

              local character18 = localPlayer2.Character

              local humanoidRootPart18 = character18
                and character18:FindFirstChild("HumanoidRootPart")

              local humanoid9 = character18 and character18:FindFirstChild("Humanoid")

              if character18 and humanoidRootPart18 then
                local v330 = os.clock()

                if v330 >= v324 or not v328 then
                  v324 = v330 + 0.2
                  v313 = v315.GetAreaEggSnapshot()
                  v328 = v313
                else
                  v313 = v328
                end

                local v331

                if v313 and v313.Records then
                  for key14, value25 in pairs(v313.Records) do
                    if not v319[value25.Uid] and value25.State == "Carried"
                      and value25.CarrierUserId == localPlayer2.UserId then
                      v331 = value25
                      v331.Rarity = f67(value25)
                      break
                    end
                  end
                end

                if not v331 and v313 and v313.Records then
                  local v332 = nil
                  local v333 = -1
                  local v334 = -1
                  local v335 = -1
                  local v336 = nil
                  local v337 = nil
                  local v338 = { Secret = true, Eternal = true, Divine = true }

                  for key15, value26 in pairs(v313.Records) do
                    local areaId2 = value26.AreaId
                    local v339 = f67(value26)

                    if not v319[value26.Uid]
                      and (value26.State == "Slot" or value26.State == "Dropped")
                      and value26.BottomCFrame then
                      local v340 = v42[v339] or 0

                      local v341 = not v31.AutoSteal or v31.StealMinValue <= 0
                        or v31:getAreaEggValue(value26) > v31.StealMinValue

                      if v338[v339] and v341 and v340 > v334 then
                        v334 = v340
                        v332 = value26
                      end

                      if v31.AutoParasiteSteal and f19(value26) and v340 > v335 then
                        v336 = value26
                        v335 = v340
                      end

                      if v31.AutoSteal then
                        local v342 = #v31.StealAreas == 0
                          or table.find(v31.StealAreas, "None") ~= nil
                          or table.find(v31.StealAreas, areaId2) ~= nil

                        local v343 = #v31.StealRarities == 0
                          or table.find(v31.StealRarities, "None") ~= nil
                          or table.find(v31.StealRarities, v339) ~= nil

                        local stealNamesFilter2 = v31.StealNamesFilter

                        if type(stealNamesFilter2) ~= "table" or #stealNamesFilter2 == 0
                          or table.find(stealNamesFilter2, "None") then
                          v314 = true
                        else
                          local assetCategory3 = value26.AssetCategory

                          if assetCategory3 and table.find(stealNamesFilter2, assetCategory3) then
                            v314 = true
                          else
                            local v344 = v318

                            local v345 = v344
                            v345 = v344 and assetCategory3 and v318.Directory[assetCategory3]

                            local displayName4 = v345 and v345.DisplayName

                            v314 = displayName4 ~= nil
                              and table.find(stealNamesFilter2, displayName4) ~= nil
                          end
                        end

                        if v342 and v343 and v314 and v341 and v340 > v333 then
                          v333 = v340
                          v337 = value26
                        end
                      end
                    end
                  end

                  v331 = v332 or v336
                    or not (f45() ~= nil or v31.PendingParasiteReward) and v337

                  if v331 then
                    v331.Rarity = f67(v331)
                  end
                end

                if v331 then
                  f44()
                  v320 = 0
                  v326 = false
                  v321 = false
                  v31.IsStealing = true
                  f55()
                  local v346 = {}

                  local function f68()
                    for i13 = #v346, 1, -1 do
                      function v23232()
                      end

                      v346[i13] = nil
                    end
                  end

                  local v347, v348 = pcall(function()
                    local humanoidRootPart19 = character18:FindFirstChild("HumanoidRootPart")
                    local humanoid10 = character18:FindFirstChild("Humanoid")
                    local v349 = not humanoidRootPart19 or not humanoid10
                    local v350, v351, getValue2, eggWorld2, v352

                    if v349 then
                      return
                    else
                      local function f69()
                        return not f17()
                      end

                      if f69() then
                        return
                      else
                        local v353 = v315.GetAreaEggRecord(v331.Uid)

                        local v354 = v353 ~= nil and v353.State == "Carried"
                          and v353.CarrierUserId == localPlayer2.UserId

                        if v354 then
                          v331 = v353
                          v331.Rarity = f67(v353)
                        elseif v353 == nil or v353.State ~= "Slot" and v353.State ~= "Dropped" then
                          v319[v331.Uid] = os.clock()
                          return
                        end

                        humanoid10:UnequipTools()

                        if (v31.StealMode == "Instant" or v31.StealMode == "Teleport")
                          and not v354 then
                          return
                        else
                          local v355 = CFrame.new(518.66, 70.57, -364.73) * CFrame.Angles(
                            math.rad(180), math.rad(-89.82), math.rad(180)
                          )

                          local v356 = v331.BottomCFrame * CFrame.new(0, 3, 0)

                          if v331.AssetCategory and v331.AreaId then
                            v51[v331.AssetCategory] = v331.AreaId
                          end

                          local v357 = f23(v331.Uid, v331.AreaId, v331.NestId)

                          if v317 and v317.IsClosed() then
                            while v317.IsClosed() and not f69() do
                              task.wait(0.2)
                            end

                            if f69() then
                              return
                            end
                          end

                          if not v354 and not f33(humanoidRootPart19.Position) then
                            if not f37(humanoidRootPart19, humanoid10, v355, f69) then
                              return
                            end

                            if f69() then
                              return
                            end

                            f49(humanoidRootPart19, v355, 1.5, f69)
                          end

                          if not v354 then
                            f26(humanoidRootPart19, humanoid10, v356, f69)
                          end

                          if f69() then
                            return
                          else
                            getValue2 = 0

                            pcall(function()
                              getValue2 = stats.Network.ServerStats.Ping:GetValue()
                            end)

                            task.wait(math.max(0.2, getValue2 * 2 / 1000))
                            eggWorld2 = require(replicatedStorage.Shared.Remotes).EggWorld
                            v352 = { Uid = v331.Uid }

                            if v357 then
                              v352.FirstAreaSlotKey = v357
                            end

                            local v358 = false
                            local v359 = os.clock() + 3

                            while os.clock() < v359 and not f69() do
                              humanoidRootPart19.AssemblyLinearVelocity = Vector3.zero
                              humanoidRootPart19.AssemblyAngularVelocity = Vector3.zero

                              local v360, v361 = pcall(function()
                                return eggWorld2.AskFieldEggCarry:InvokeServer(v352)
                              end)

                              if v360 and v361 == true then
                                v358 = true
                                break
                              end

                              task.wait(0.2)
                            end

                            task.wait(0.15)
                            local v362 = 19617369154479
                            local v363 = v315.GetAreaEggRecord(v331[v15[f2("\250\196\127", v362)]])
                            local v364 = v363

                            if v363 then
                              local v365 = 31882301094398
                              local v366 = "ؽ\4\19\18?y"
                              v350 = v15
                              v351 = f2
                              local v367 = v351(v366, v365)
                              v362 = v350[v367]
                              local v368 = v363.State == v362
                              local v369 = v368

                              if v368 then
                                v350 = localPlayer2
                                v367 = v15
                                v366 = f2
                                v365 = v366("\215:\127\160\174\n", 750125482333)
                                v351 = v367[v365]
                                v362 = v350[v351]
                                v369 = v363.CarrierUserId == v362
                              end

                              v364 = v369
                            end

                            if (v364 or v358) and not f69() then
                              f26(humanoidRootPart19, humanoid10, v355, f69)
                              v351 = 6784926895191
                              v350 = "\r\154\1312\230"
                              v362 = f2(v350, v351)
                              v319[v331.Uid] = os[v15[v362]]()
                            end

                            f68()
                            return
                          end
                        end
                      end
                    end
                  end)

                  f68()

                  if not v347 then
                    warn("[AutoSteal] Error saat mencuri:", v348)
                  end

                  v31.IsStealing = false
                  f44()
                elseif f45() ~= nil or v31.PendingParasiteReward then
                  v31.IsStealing = false
                else
                  local v370 = os.clock()

                  if v370 >= v327 then
                    v327 = v370 + 0.5
                    task.spawn(function() pcall(function() v315.RequestAreaEggSnapshot() end) end)
                  end

                  if not v326 then
                    pcall(function()
                      if humanoidRootPart18 then
                        local v371 = CFrame.new(518.66, 70.57, -364.73) * CFrame.Angles(
                          math.rad(180), math.rad(-89.82), math.rad(180)
                        )

                        if (humanoidRootPart18.Position - v371.Position).Magnitude > 5 then
                          f37(humanoidRootPart18, humanoid9, v371, function()
                            return not f17()
                          end)
                        end
                      end
                    end)

                    v326 = true
                  end

                  if v31.AutoTreadmillIdle then
                    if v320 == 0 then
                      v320 = os.clock()
                    elseif not v321 and os.clock() - v320 >= 10 and v49 == nil then
                      pcall(function()
                        local v372 = f32()

                        if not v372 or not humanoidRootPart18 then
                          return
                        end

                        v321 = true
                        v50 = true

                        f26(humanoidRootPart18, humanoid9, CFrame.new(v372.Position), function()
                          return not f17() or not v31.AutoTreadmillIdle or v31.IsStealing
                        end)

                        task.wait(0.2)

                        if f30() == true then
                          v49 = v49 or "idle"
                        else
                          v50 = false
                          v321 = false
                          v320 = os.clock()
                        end
                      end)
                    end
                  end
                end
              end

              runService.Heartbeat:Wait()
            end
          end

          return
        end
      end

      v52 = false

      function f56()
        if not f17() then
          return
        end

        if v52 then
          return
        end

        f44()
        v52 = true

        task.spawn(function()
          while f17() do
            local v373, v374 = pcall(f35)

            if not v373 then
              warn("[AutoSteal] Loop berhenti gara-gara error, auto-restart:", v374)
              task.wait(0.5)
            end

            if f17() then
              runService.Heartbeat:Wait()
            end
          end

          v52 = false
          v31.IsStealing = false

          if f17() then
            f56()
          end
        end)
      end

      v53 = false

      function f57()
        if not f34() or v53 then
          return
        end

        v53 = true

        task.spawn(function()
          local v375 = require(replicatedStorage.Shared.Save)
          local v376 = require(replicatedStorage.Client.EggState)
          local monsterParasite = require(replicatedStorage.Shared.Remotes).MonsterParasite

          local function f70()
            local v377, v378 = pcall(function()
              return monsterParasite.AskSnapshot:InvokeServer()
            end)

            return v377 and type(v378) == "table" and v378 or nil
          end

          local function f71(p94)
            local monsterParasiteMonsters = workspace:FindFirstChild("MonsterParasiteMonsters")

            local findFirstChild2 = monsterParasiteMonsters
              and monsterParasiteMonsters:FindFirstChild("Monster_" .. localPlayer2.UserId)

            local findFirstChild3 = findFirstChild2
              and findFirstChild2:FindFirstChild("RootPart", true)

            local character19 = localPlayer2.Character

            local humanoidRootPart20 = character19
              and character19:FindFirstChild("HumanoidRootPart")

            local humanoid11 = character19
            humanoid11 = character19 and character19:FindFirstChildOfClass("Humanoid")

            local v379 = not findFirstChild3
            local v380 = humanoid11

            if v379 or not humanoidRootPart20 or not v380 then
              return false
            else
              local position8 = (findFirstChild3.CFrame * CFrame.new(0, 0, 7)).Position

              local raycastParams = RaycastParams.new()
              raycastParams.FilterType = Enum.RaycastFilterType.Exclude
              raycastParams.FilterDescendantsInstances = { character19, findFirstChild2 }
              raycastParams.RespectCanCollide = true

              local raycast = workspace:Raycast(
                position8 + Vector3.new(0, 30, 0), Vector3.new(0, -100, 0), raycastParams
              )

              local v381 = v380.HipHeight + humanoidRootPart20.Size.Y * 0.5
              local v382 = (raycast and raycast.Position.Y or findFirstChild3.Position.Y) + v381
              local vector4 = Vector3.new(position8.X, v382, position8.Z)

              local vector5 = Vector3.new(
                findFirstChild3.Position.X, v382, findFirstChild3.Position.Z
              )

              f26(humanoidRootPart20, v380, CFrame.lookAt(vector4, vector5), p94)

              return not (p94 and p94())
                and (humanoidRootPart20.Position - findFirstChild3.Position).Magnitude <= 14
            end
          end

          local function f72()
            local pendingReward, generateGUID2

            if not f71(function() return not v31.AutoParasiteClaim end) then
              return false
            else
              local v383 = f70()
              pendingReward = v383 and v383.State and v383.State.PendingReward

              if type(pendingReward) == "table" and pendingReward.OpeningId then
                local v384, v385 = pcall(function()
                  return monsterParasite.AskChestRevealComplete:InvokeServer(pendingReward.OpeningId)
                end)

                return v384 and type(v385) == "table" and v385.Success == true
              else
                local function f73()
                  for index13, value27 in ipairs({
                    localPlayer2.Character, localPlayer2:FindFirstChild("Backpack"),
                  }) do
                    if value27 then
                      for index14, value28 in ipairs(value27:GetChildren()) do
                        if value28:IsA("Tool")
                          and value28:GetAttribute("ItemType") == "MonsterChest" then
                          return true
                        end
                      end
                    end
                  end

                  return false
                end

                if not f73() then
                  local v386, v387 = pcall(function()
                    return monsterParasite.AskChestTake:InvokeServer()
                  end)

                  if not v386 or type(v387) ~= "table" or v387.Success ~= true then
                    return false
                  end
                end

                task.wait(0.8)
                local v388 = nil

                for index15, value29 in ipairs({
                  localPlayer2.Character, localPlayer2:FindFirstChild("Backpack"),
                }) do
                  if value29 then
                    for index16, value30 in ipairs(value29:GetChildren()) do
                      if value30:IsA("Tool")
                        and value30:GetAttribute("ItemType") == "MonsterChest" then
                        v388 = value30
                        break
                      end
                    end
                  end

                  if v388 then
                    break
                  end
                end

                local character20 = localPlayer2.Character

                local humanoid12 = character20

                humanoid12 = character20
                  and localPlayer2.Character:FindFirstChildOfClass("Humanoid")

                if not v388 or not humanoid12 then
                  return false
                else
                  if v388.Parent ~= localPlayer2.Character then
                    humanoid12:EquipTool(v388)
                    task.wait(0.2)
                  end

                  generateGUID2 = httpService:GenerateGUID(false)

                  local v389, v390 = pcall(function()
                    return monsterParasite.AskChestClaim:InvokeServer(generateGUID2)
                  end)

                  if not v389 or type(v390) ~= "table" or v390.Success ~= true then
                    return false
                  else
                    generateGUID2 = v390.OpeningId or generateGUID2
                    task.wait(0.8)

                    local v391, v392 = pcall(function()
                      return monsterParasite.AskChestRevealComplete:InvokeServer(generateGUID2)
                    end)

                    return v391 and type(v392) == "table" and v392.Success == true
                  end
                end
              end
            end
          end

          local function f74()
            local v393 = f45()

            if not v393 then
              return false, "none"
            end

            if not v376.WearEggTool(v393) then
              return false, "equip"
            end

            task.wait(0.2)

            if not f71(function() return not v31.AutoParasiteSteal end) then
              return false, "movement"
            else
              local v394 = f70()
              local charge = v394 and v394.State and v394.State.Charge or 0

              local v395, v396 = pcall(function()
                return monsterParasite.AskFeed:InvokeServer()
              end)

              if not v395 or type(v396) ~= "table" or v396.Success ~= true then
                return false, "request"
              else
                local v397 = os.clock() + 4

                while os.clock() < v397 do
                  local v398 = v375.Get()
                  local eggInventory2 = v398 and v398.EggInventory and v398.EggInventory[v393]

                  if eggInventory2 and not f19(eggInventory2) then
                    return true
                  else
                    local v399 = f70()

                    if v399 and v399.State and v399.State.Charge ~= charge then
                      return true
                    end

                    task.wait(0.2)
                  end
                end

                return false, "timeout"
              end
            end
          end

          while f34() do
            local autoParasiteClaim = v31.AutoParasiteClaim and f70() or nil

            local pendingChests = autoParasiteClaim and autoParasiteClaim.State
                and (autoParasiteClaim.State.PendingChests or 0)
              or 0

            local pendingReward2 = autoParasiteClaim and autoParasiteClaim.State
              and autoParasiteClaim.State.PendingReward

            if v31.AutoParasiteClaim then
              v31.PendingParasiteReward = pendingChests > 0 or pendingReward2 ~= nil
            else
              v31.PendingParasiteReward = false
            end

            local v400 = f45() ~= nil

            if (v400 or v31.AutoParasiteClaim and (pendingChests > 0 or pendingReward2 ~= nil))
              and not f46() and not f20() and not v31.IsStealing and not v31.IsPlacing
              and not v31.IsParasiteProcessing then
              v31.IsParasiteProcessing = true

              local v401, v402 = pcall(function()
                local v403 = f70()

                while v31.AutoParasiteClaim and v403 and v403.State
                  and ((v403.State.PendingChests or 0) > 0 or v403.State.PendingReward ~= nil) do
                  if not f72() then
                    break
                  end

                  task.wait(0.5)
                  v403 = f70()
                end

                if v400 then
                  while v31.AutoParasiteSteal and not f46() and not f20() do
                    if not f74() then
                      break
                    else
                      task.wait(0.8)
                      local v404 = f70()

                      if v404
                        and v404.State
                        and ((v404.State.PendingChests or 0) > 0
                          or v404.State.PendingReward ~= nil) then
                        break
                      end
                    end
                  end
                end
              end)

              v31.IsParasiteProcessing = false

              if not v401 then
                warn("[AutoParasite] Error:", v402)
              elseif v400 and f45() ~= nil then
                warn("[AutoParasite] Feed belum selesai, retry otomatis dalam 1 detik.")
                task.wait(0.5)
              end
            end

            task.wait(0.5)
          end

          v31.IsParasiteProcessing = false
          v31.PendingParasiteReward = false

          v53 = false

          if f34() then
            f57()
          end
        end)
      end

      function f58()
        local mainAddTab = napoleonWindow:AddTab({
          Name = "Main",
          Icon = "rbxassetid://10734950309",
        })

        local autoFarm = mainAddTab:AddSection("Auto Farm")

        local addToggle = autoFarm:AddToggle({
          Title = "Auto Steal Egg",
          Content = "Automatically teleports and steals eggs based on filters",
          Default = false,
          Callback = function(value31)
            v31.AutoSteal = value31

            if value31 and v30 then
              if v31.StealMode == "Instant" or v31.StealMode == "Teleport" then
                v48:setEnabled(true)
              else
                f56()
              end
            elseif not f17() then
              v31.IsStealing = false
              v48:setEnabled(false)
            end
          end,
        })

        autoFarm:AddDropdown({
          Title = "Steal Mode",
          Content = "Choose steal movement method (Tween / Instant)",
          Options = { "Tween", "Instant", "Teleport" },
          Default = "Tween",
          Multi = false,
          Callback = function(value32)
            v31.StealMode = tostring(type(value32) == "table" and (value32[1] or value32.Value)
              or value32 or "Tween")

            if v31.AutoSteal then
              if v31.StealMode == "Instant" or v31.StealMode == "Teleport" then
                v48:setEnabled(true)
              else
                v48:setEnabled(false)
                f56()
              end
            end
          end,
        })

        local addInput = autoFarm:AddInput({
          Title = "Move Speed (studs/s)",
          Content = "Kecepatan langsung 1-1000 studs/s (default 400). FPS tinggi = bisa naik lebih tinggi; FPS rendah = turunkan kalau sering ketolak server / teleport balik.",
          Default = tostring(v31.TweenSpeedMultiplier),
          Callback = function(value33)
            local tweenSpeedMultiplier2 = tonumber(value33)

            if not tweenSpeedMultiplier2 then
              tweenSpeedMultiplier2 = v31.TweenSpeedMultiplier
            end

            f48(tweenSpeedMultiplier2)
          end,
        })

        autoFarm:AddInput({
          Title = "Steal By Value",
          Content = "Only steal eggs above this value per second. Supports k, m, b (example: 100m). Empty or 0 = disabled.",
          Default = "0",
          Callback = function(value34) v31:applyStealValueInput(value34) end,
        })

        getgenv().__napoleonSetSpeed = function(p95)
          if not tonumber(p95) then
            return false
          end

          if addInput and addInput.SetValue then
            pcall(function() addInput:SetValue(tostring(p95)) end)
          end

          f48(tonumber(p95))
          return true
        end

        local v405 = { "None" }

        if not pcall(function()
          local directory5 = require(replicatedStorage.Data.Areas).Directory
          local v406, v407 = pcall(function() return require(replicatedStorage.Data.Assets) end)

          if v406 and v407 and v407.Directory then
            local directory6 = v407.Directory
            local v408 = {}

            for key16, value35 in pairs(directory5) do
              if type(value35) == "table" and type(value35.DropTable) == "table" then
                for index17, value36 in ipairs(value35.DropTable) do
                  local v409 = value36[1]

                  if type(v409) == "string" and not v408[v409] then
                    v408[v409] = true
                    local v410 = directory6[v409]
                    local v411 = v405
                    local v412 = #v405 + 1
                    v411[v412] = v410 and v410.DisplayName or v409
                  end
                end
              end
            end
          end
        end) or #v405 <= 1 then
          v405 = { "None" }
        end

        table.sort(v405, function(p96, p97)
          if p96 == "None" then
            return true
          end

          if p97 == "None" then
            return false
          end

          return p96 < p97
        end)

        local addDropdown

        addDropdown = autoFarm:AddDropdown({
          Title = "Filter By Egg Name",
          Content = "Pick specific eggs to steal (e.g. Crane). None = no name filter.",
          Options = v405,
          Default = { "None" },
          Multi = true,
          Callback = function(value37) v31.StealNamesFilter = f36(value37, addDropdown) end,
        })

        local v413 = { "None" }

        if not pcall(function()
          for key17, value38 in pairs(require(replicatedStorage.Data.Areas).Directory) do
            if type(value38) == "table" and type(value38.DropTable) == "table" then
              v413[#v413 + 1] = key17
            end
          end
        end) or #v413 <= 1 then
          v413 = {
            "None", "Forest", "Lake", "Jungle", "Desert", "Snow", "Volcano", "Abyss Ocean",
            "Prehistoric", "Cosmic", "Cherry Blossom",
          }
        end

        table.sort(v413, function(p98, p99)
          if p98 == "None" then
            return true
          end

          if p99 == "None" then
            return false
          end

          return p98 < p99
        end)

        local selectAreaAddDropdown

        selectAreaAddDropdown = autoFarm:AddDropdown({
          Title = "Select Area",
          Content = "Choose which zone to farm eggs from",
          Options = v413,
          Default = { "None" },
          Multi = true,
          Callback = function(value39) v31.StealAreas = f36(value39, selectAreaAddDropdown) end,
        })

        local addDropdown2

        addDropdown2 = autoFarm:AddDropdown({
          Title = "Filter By Rarity (Steal)",
          Content = "Select which egg rarities to prioritize",
          Options = {
            "None", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic",
            "Secret", "Eternal", "Divine", "Prismatic", "Transcendent",
          },
          Default = { "None" },
          Multi = true,
          Callback = function(value40)
            v31.StealRarities = f36(value40, addDropdown2)

            if v30 then
              for index18, value41 in ipairs(v31.StealRarities) do
              end
            end
          end,
        })

        local autoParasiteMonster = mainAddTab:AddSection("Auto Parasite Monster")

        autoParasiteMonster:AddToggle({
          Title = "Auto Steal Parasite Egg",
          Content = "Steal semua egg Parasite dari semua area dan semua rarity. Prioritas: Secret/Eternal/Divine, lalu Parasite, lalu Auto Steal biasa.",
          Default = false,
          Callback = function(value42)
            v31.AutoParasiteSteal = value42

            if value42 and v30 then
              if v31.StealMode == "Instant" or v31.StealMode == "Teleport" then
                v48:setEnabled(true)
              else
                f56()
              end

              f57()
            elseif not f17() then
              v31.IsStealing = false
              v48:setEnabled(false)
            end
          end,
        })

        autoParasiteMonster:AddToggle({
          Title = "Auto Claim Parasite Reward",
          Content = "Claim, reveal, dan ambil Monster Chest saat Pending Chests tersedia.",
          Default = false,
          Callback = function(value43)
            v31.AutoParasiteClaim = value43
            v31.PendingParasiteReward = value43

            if value43 and v30 then
              f57()
            end
          end,
        })

        local addDropdown3

        addDropdown3 = autoParasiteMonster:AddDropdown({
          Title = "Feed Parasite Rarity V3",
          Content = "Hanya rarity yang dipilih yang akan di-feed. Default All agar inventory tidak tertahan.",
          Options = {
            "None", "All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic",
            "Cosmic", "Secret", "Eternal", "Divine", "Prismatic", "Transcendent",
          },
          Default = { "All" },
          Multi = true,
          Callback = function(value44)
            v31.ParasiteFeedRarities = f36(value44, addDropdown3)

            if v31.AutoParasiteSteal then
              if v30 then
                f57()
              end
            end
          end,
        })
      end

      local v414, v415 = pcall(function() f58() end)

      if not v414 then
        warn("[Napoleon] Error loading MainTab:", v415)
      end

      task.wait(0.05)
      task.wait(0.05)
      task.wait(0.05)
      task.wait(0.05)

      v22 = getgenv and getgenv() or _G
      v22.__NapoleonAntiAfkGeneration = (v22.__NapoleonAntiAfkGeneration or 0) + 1

      napoleonAntiAfkGeneration = v22.__NapoleonAntiAfkGeneration
      v22.__NapoleonAntiAfkEnabled = v31.AntiAFK
      v23 = getconnections or get_signal_cons
      napoleonAntiAfkIdledConnections = v22.__NapoleonAntiAfkIdledConnections or {}

      v22.__NapoleonAntiAfkIdledConnections = napoleonAntiAfkIdledConnections

      function v22.__NapoleonSetAntiAfkEnabled(p100)
        v22.__NapoleonAntiAfkEnabled = p100

        if p100 and v23 then
          for index19, value45 in ipairs(v23(localPlayer2.Idled)) do
            if not table.find(napoleonAntiAfkIdledConnections, value45) then
              table.insert(napoleonAntiAfkIdledConnections, value45)
            end
          end
        end

        for index20, value46 in ipairs(napoleonAntiAfkIdledConnections) do
          local v416 = value46

          pcall(function()
            if p100 then
              v416:Disable()
            else
              v416:Enable()
            end
          end)
        end
      end

      if v23 then
        v22.__NapoleonSetAntiAfkEnabled(v31.AntiAFK)
      end

      task.spawn(function()
        while v22.__NapoleonAntiAfkGeneration == napoleonAntiAfkGeneration do
          task.wait(1)
          guiService:GetErrorMessage()
        end
      end)

      pcall(function()
        for index21, value47 in ipairs((players.LocalPlayer:FindFirstChild("PlayerGui") or coreGui):GetDescendants()) do
          local v417 = value47

          if v417.Name == "ScrollSelect" and v417:IsA("ScrollingFrame") then
            local uiListLayout = v417:FindFirstChildOfClass("UIListLayout")

            if uiListLayout then
              local function f75()
                v417.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
              end

              f75()
              uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(f75)
            end
          end
        end
      end)

      v30 = true

      if f17() then
        if v31.StealMode == "Instant" or v31.StealMode == "Teleport" then
          v48:setEnabled(true)
        else
          f56()
        end
      end

      if f34() then
        f57()
      end

      if v31.AutoPlace then
        task.spawn(nil)
      end

      return
    end
  end
end
