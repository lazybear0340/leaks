--unobfuscated


local FuncsV3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrtokyo/refs/heads/main/FuncsV3"))()
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrlibrary/refs/heads/main/tokyo-ontop"))()

local Window = Speed_Library:CreateWindow({
    "Tokyo",
    "Capybara VS Plants",
    120,
    nil, 
    "rbxassetid://91570350247074"
})

Speed_Library:AddTopInfo("Free")

Speed_Library:SetCharacterArt("rbxassetid://95368690194608", {
    Size = UDim2.new(0, 420, 0, 420),
    Position = UDim2.new(0.5, 0, 0.68, 0),
    Transparency = 0.8
})

-- ============================
-- SHARED SERVICES / STATE
-- ============================
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser       = game:GetService("VirtualUser")
local HttpService       = game:GetService("HttpService")
local Workspace         = game:GetService("Workspace")
local Lighting          = game:GetService("Lighting")

local LocalPlayer       = Players.LocalPlayer
local Remotes           = ReplicatedStorage:WaitForChild("Remotes")

local State = {
    IsAutoSelling = false, -- Mencegah tabrakan Auto Sell Capybara & Plant
}

-- ============================
-- SISTEM AUTO-SAVE CONFIG
-- ============================
local SaveFileName = "TokyoHub_SaveData.json"
local UserSettings = {
    AutoCollectCash = false,
    AutoEquipBest = false,
    AutoHatchEgg = false,
    AutoBountyProgress = false,
    AutoClaim = false,
    AutoSellCapybara = false,
    TargetCapybara = {},
    AutoSellPlant = false,
    TargetPlant = {},
    TargetPlantMultiplier = "",
    AutoBuyEgg = false,
    TargetEgg = {},
    AutoBuyGear = false,
    TargetGear = {},
    AutoBuyMerchant = false,
    TargetMerchant = {},
    AntiAFK = false,
    FPSBoost = false
}

if isfile and readfile and isfile(SaveFileName) then
    pcall(function()
        local decoded = HttpService:JSONDecode(readfile(SaveFileName))
        for k, v in pairs(decoded) do
            UserSettings[k] = v
        end
    end)
end

local function SaveConfig()
    if writefile then
        pcall(function()
            writefile(SaveFileName, HttpService:JSONEncode(UserSettings))
        end)
    end
end
-- ============================

local IsLoaded = false 
local NotifQueue = {} 
local IsNotifRunning = false 

local function processQueue()
    if IsNotifRunning then return end 
    IsNotifRunning = true
    
    while #NotifQueue > 0 do
        local currentNotif = table.remove(NotifQueue, 1) 
        pcall(function()
            Speed_Library:SetNotification({
                "Info",
                currentNotif.Title,
                currentNotif.Text
            })
        end)
        task.wait(2) 
    end
    
    IsNotifRunning = false 
end

local function notifyToggle(featureName, value)
    if not IsLoaded then return end 
    table.insert(NotifQueue, {
        Title = featureName,
        Text = value and (featureName .. " has been enabled!") or (featureName .. " has been disabled.")
    })
    task.spawn(processQueue)
end

-- ============================
-- TAB 1: INFO
-- ============================
local InfoTab = Window:CreateTab({
    Name = "Info",
    Icon = "rbxassetid://10734949856" 
})

local InfoSection = InfoTab:AddSection("Welcome to Tokyo", false)

InfoSection:AddParagraph({
    "",
    "Join our official Discord server to stay up to date with the latest announcements, updates, bug fixes, guides, and community discussions. Our development team is always working to improve Tokyo and provide the best experience possible."
})

InfoSection:AddButton({
    "Copy Discord Invite",
    "",
    "rbxassetid://7734010488",
    function()
        setclipboard("https://discord.gg/contoh")
        task.spawn(function()
            table.insert(NotifQueue, {
                Title = "Discord Invite",
                Text = "Discord invite link copied to clipboard!"
            })
            task.spawn(processQueue)
        end)
    end
})

-- ============================
-- TAB 2: MAIN
-- ============================
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://10734950020" 
})

local MainFeaturesSection = MainTab:AddSection("Main Features", false)

local autoHatchEggActive = false
MainFeaturesSection:AddToggle({
    "Auto Hatch Egg",
    "Automatically hatches eggs available on your plot",
    UserSettings.AutoHatchEgg, 
    function(value)
        UserSettings.AutoHatchEgg = value
        SaveConfig()

        autoHatchEggActive = value
        notifyToggle("Auto Hatch Egg", value)
        
        if autoHatchEggActive then
            task.spawn(function()
                while autoHatchEggActive do
                    pcall(function()
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            -- Mencari objek telur yang formatnya "NamaTelur:IDUnik"
                            if obj.Name:match("Egg:[a-zA-Z0-9]+") then
                                Remotes:WaitForChild("Hatch"):FireServer(obj.Name)
                                task.wait(0.5) 
                            end
                        end
                    end)
                    task.wait(3)
                end
            end)
        end
    end
})

local autoBountyProgressActive = false

MainFeaturesSection:AddToggle({
    "Auto Turn In Bounty",
    "Smartly reads required plants & mutations to turn them in",
    UserSettings.AutoBountyProgress, 
    function(value)
        UserSettings.AutoBountyProgress = value
        SaveConfig()

        autoBountyProgressActive = value
        notifyToggle("Auto Turn In Bounty", value)
        
        if autoBountyProgressActive then
            task.spawn(function()
                while autoBountyProgressActive do
                    if not State.IsBusy then
                        State.IsBusy = true 

                        pcall(function()
                            local character = LocalPlayer.Character
                            local humanoid = character and character:FindFirstChild("Humanoid")
                            local backpack = LocalPlayer:WaitForChild("Backpack")
                            
                            -- 1. Ambil data Bounty dari server
                            local bountyData = Remotes:WaitForChild("RequestBounties"):InvokeServer()
                            local activeBounties = {}
                            
                            -- 2. Saring data Bounty yang belum di-claim
                            if type(bountyData) == "table" then
                                if bountyData.Easy and bountyData.EasyClaimed == false then
                                    table.insert(activeBounties, bountyData.Easy)
                                end
                                if bountyData.Hard and bountyData.HardClaimed == false then
                                    table.insert(activeBounties, bountyData.Hard)
                                end
                            end
                            
                            -- Fungsi pintar untuk mencocokkan nama tanaman dan mutasinya
                            local function isCorrectPlant(toolName, bountyReq)
                                -- Harus ada nama tanamannya (misal: "Watermelon")
                                if not string.find(toolName, bountyReq.PlantName) then 
                                    return false 
                                end
                                
                                -- Harus ada SEMUA mutasi yang diminta (misal: "Shocked")
                                if type(bountyReq.Mutations) == "table" then
                                    for _, mutation in pairs(bountyReq.Mutations) do
                                        if not string.find(toolName, mutation) then
                                            return false
                                        end
                                    end
                                end
                                
                                return true
                            end

                            -- 3. Cari barang di tas yang cocok dengan kriteria NPC
                            if humanoid and backpack and #activeBounties > 0 then
                                for _, tool in ipairs(backpack:GetChildren()) do
                                    if not autoBountyProgressActive then break end
                                    
                                    if tool:IsA("Tool") then
                                        -- Cek apakah tool ini cocok dengan salah satu permintaan Bounty
                                        local isMatch = false
                                        for _, bountyReq in ipairs(activeBounties) do
                                            if isCorrectPlant(tool.Name, bountyReq) then
                                                isMatch = true
                                                break
                                            end
                                        end
                                        
                                        -- Kalau cocok 100% (Nama + Mutasi), langsung gas setorkan!
                                        if isMatch then
                                            humanoid:EquipTool(tool)
                                            task.wait(0.3) 
                                            Remotes:WaitForChild("TurnInBounty"):InvokeServer()
                                            task.wait(0.2)
                                        end
                                    end
                                end
                                
                                -- Copot barang dari tangan biar rapi
                                humanoid:UnequipTools()
                            end
                        end)

                        State.IsBusy = false 
                    end
                    task.wait(5) 
                end
            end)
        end
    end
})

-- ============================
-- TAB 3: AUTO
-- ============================
local AutoTab = Window:CreateTab({
    Name = "Auto",
    Icon = "rbxassetid://10734950309" 
})

local AutoFarmSection = AutoTab:AddSection("Auto Farm", false)

local autoCollectActive = false
AutoFarmSection:AddToggle({
    "Auto Collect Cash",
    "Automatically collects cash from the Collection Machine",
    UserSettings.AutoCollectCash, 
    function(value)
        UserSettings.AutoCollectCash = value
        SaveConfig()
        
        autoCollectActive = value
        notifyToggle("Auto Collect Cash", value)
        if autoCollectActive then
            task.spawn(function()
                while autoCollectActive do
                    pcall(function()
                        Remotes:WaitForChild("CollectionMachine"):FireServer()
                    end)
                    task.wait(5)
                end
            end)
        end
    end
})

local autoEquipBestActive = false
AutoFarmSection:AddToggle({
    "Auto Equip Best",
    "Automatically equips your best Plants every 1 minute",
    UserSettings.AutoEquipBest, 
    function(value)
        UserSettings.AutoEquipBest = value
        SaveConfig()
        
        autoEquipBestActive = value
        notifyToggle("Auto Equip Best", value)
        if autoEquipBestActive then
            task.spawn(function()
                while autoEquipBestActive do
                    pcall(function()
                        Remotes:WaitForChild("EquipBestPlants"):FireServer()
                    end)
                    task.wait(60) -- Ubah ke 60 detik (1 menit) biar gak spam
                end
            end)
        end
    end
})

local autoClaimActive = false
local PLAYTIME_REWARD_COUNT = 12

-- Kita buat fungsi pintar untuk membaca ModuleScript QuestData langsung dari game
local function getDynamicQuestList()
    local list = {}
    pcall(function()
        local questModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("QuestData"))
        -- Membaca semua isi modul dan mengambil namanya (keys)
        for questName, _ in pairs(questModule) do
            if type(questName) == "string" then
                table.insert(list, questName)
            end
        end
    end)
    
    -- Kalau gagal baca modulnya (misal gamenya ganti struktur), kita pakai fallback manual ini
    if #list == 0 then
        list = {"DailyDefeat50", "DailyDefeat100", "DailyDefeat150"}
    end
    
    return list
end

local function claimAllPlaytimeRewards()
    for i = 1, PLAYTIME_REWARD_COUNT do
        pcall(function()
            Remotes:WaitForChild("ClaimPlaytimeReward"):FireServer("Reward" .. tostring(i))
        end)
        task.wait(0.2) 
    end
end

local function claimAllQuestsAndDailies()
    -- 1. Klaim Daily Login Reward (Temuan baru dari file scanner!)
    pcall(function()
        Remotes:WaitForChild("ClaimDailyReward"):FireServer()
    end)
    task.wait(0.5)

    -- 2. Dapatkan daftar nama quest terbaru langsung dari data game
    local currentQuestList = getDynamicQuestList()
    
    -- 3. Klaim semua quest yang ada di daftar
    for _, questName in ipairs(currentQuestList) do
        pcall(function()
            Remotes:WaitForChild("ClaimQuest"):InvokeServer(questName)
        end)
        task.wait(0.2) -- Jeda halus biar gak di-kick server
    end
end

AutoFarmSection:AddToggle({
    "Auto Claim (Quests & Playtime)",
    "Automatically claims rewards and silently hides annoying spam popups",
    UserSettings.AutoClaim, 
    function(value)
        UserSettings.AutoClaim = value
        SaveConfig()

        autoClaimActive = value
        notifyToggle("Auto Claim", value)
        
        if autoClaimActive then
            -- PEKERJA 1: Tukang Klaim Hadiah (Jalan setiap 15 detik)
            task.spawn(function()
                while autoClaimActive do
                    -- Sapu bersih Playtime Rewards
                    claimAllPlaytimeRewards()
                    
                    -- Sapu bersih Daily Login & Quests
                    claimAllQuestsAndDailies()
                    
                    task.wait(15) 
                end
            end)

            -- PEKERJA 2: Tukang Sapu Layar (Versi Aman, Anti Error)
            task.spawn(function()
                while autoClaimActive do
                    pcall(function()
                        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
                        
                        for _, obj in ipairs(playerGui:GetDescendants()) do
                            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                                -- Pastikan objeknya masih ada
                                if obj.Parent then
                                    local txt = string.lower(obj.Text)
                                    
                                    -- Deteksi teks spam
                                    if string.find(txt, "already claimed") or string.find(txt, "please try again") or string.find(txt, "today's reward") then
                                        
                                        -- JANGAN DI-DESTROY! Cukup disembunyikan dan dikosongkan teksnya
                                        obj.Text = ""
                                        obj.Visible = false
                                        
                                        if obj.Parent:IsA("Frame") then
                                            obj.Parent.Visible = false
                                        end
                                        
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.5) 
                end
            end)
        end
    end
})

local AutoSellSection = AutoTab:AddSection("Auto Sell", false)

local CapybaraNames = {"Capybara", "Alpha Capybara", "Archer Capybara", "Magic Capybara", "Ghost Capybara", "Golem Capybara", "Robot Capybara", "Disco Capybara", "Angel Capybara", "Dragon Capybara Egg"}
local PlantNames = {}

do
    local assetsFolder = ReplicatedStorage:FindFirstChild("Assets")
    local plantsFolder = assetsFolder and assetsFolder:FindFirstChild("Plants")
    if plantsFolder then
        for _, plant in ipairs(plantsFolder:GetChildren()) do
            table.insert(PlantNames, plant.Name)
        end
    end
end
table.insert(PlantNames, 1, "All")

local selectedCapybara = {}
local selectedPlants = {}
local selectedPlantMultiplier = ""

-- Ambil multiplier dari tool name. Support format: "1.1x", "x1.1", "x1,1", "1,1x"
-- Return 1 kalau plant cocok tapi tidak ada multiplier. Return nil kalau bukan plant ini.
local function getToolMultiplier(toolName, plantName)
    -- Cek apakah tool ini mengandung nama plant
    if not string.find(toolName, plantName, 1, true) then
        return nil -- bukan plant ini
    end
    -- Cari multiplier format "N.Nx" atau "N,Nx" (angka sebelum x)
    local mult = string.match(toolName, "([%d%.,]+)x")
    if mult then
        return tonumber((mult:gsub(",", ".")))
    end
    -- Cari multiplier format "xN.N" atau "xN,N" (x sebelum angka)
    mult = string.match(toolName, "x([%d%.,]+)")
    if mult then
        return tonumber((mult:gsub(",", ".")))
    end
    -- Plant cocok tapi tidak ada multiplier = x1
    return 1
end

-- Parse angka batas dari input user (misal "1.8" -> 1.8, kosong -> 0)
local function parseMultiplier(multStr)
    if type(multStr) ~= "string" or multStr == "" then return 0 end
    return tonumber(multStr) or 0
end

-- Fungsi khusus Auto Sell Plant: jual semua plant â‰¤ multiplier yang dipilih
local function runAutoSellPlant(getActive, getPlantList, getMultiplierList)
    task.spawn(function()
        while getActive() do
            if not State.IsAutoSelling then
                State.IsAutoSelling = true

                pcall(function()
                    local character = LocalPlayer.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    local backpack = LocalPlayer:WaitForChild("Backpack")
                    local plantList = getPlantList()
                    local maxMult = parseMultiplier(getMultiplierList())

                    if humanoid and #plantList > 0 then
                        for _, tool in ipairs(backpack:GetChildren()) do
                            if not getActive() then break end

                            if tool:IsA("Tool") then
                                local toolName = tool.Name
                                local matched = false

                                local isAllSelected = table.find(plantList, "All")

                                for _, plantName in ipairs(plantList) do
                                    if isAllSelected then
                                        -- "All" dipilih: cek multiplier saja
                                        if maxMult == 0 then
                                            matched = true
                                        else
                                            -- Cari multiplier dari tool name langsung
                                            local mult = string.match(toolName, "([%d%.,]+)x")
                                            if not mult then mult = string.match(toolName, "x([%d%.,]+)") end
                                            local toolMult = mult and tonumber((mult:gsub(",", "."))) or 1
                                            if toolMult < maxMult then matched = true end
                                        end
                                        break
                                    end

                                    if plantName ~= "All" then
                                        if maxMult == 0 then
                                            if string.find(toolName, plantName, 1, true) then
                                                matched = true
                                                break
                                            end
                                        else
                                            local toolMult = getToolMultiplier(toolName, plantName)
                                            if toolMult and toolMult < maxMult then
                                                matched = true
                                                break
                                            end
                                        end
                                    end
                                end

                                if matched then
                                    humanoid:EquipTool(tool)
                                    task.wait(0.3)
                                    Remotes:WaitForChild("Sell"):FireServer("equippedItem")
                                    task.wait(0.3)
                                end
                            end
                        end
                    end
                end)

                State.IsAutoSelling = false
            end
            task.wait(1)
        end
    end)
end

local function runAutoSell(getActive, getTargetList)
    task.spawn(function()
        while getActive() do
            if not State.IsAutoSelling then
                State.IsAutoSelling = true

                pcall(function()
                    local character = LocalPlayer.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    local backpack = LocalPlayer:WaitForChild("Backpack")
                    local targetList = getTargetList()

                    if humanoid and #targetList > 0 then
                        for _, tool in ipairs(backpack:GetChildren()) do
                            if not getActive() then break end

                            if tool:IsA("Tool") and table.find(targetList, tool.Name) then
                                humanoid:EquipTool(tool)
                                task.wait(0.3)
                                Remotes:WaitForChild("Sell"):FireServer("equippedItem")
                                task.wait(0.3)
                            end
                        end
                    end
                end)

                State.IsAutoSelling = false
            end
            task.wait(1)
        end
    end)
end

local autoSellCapybaraActive = false
AutoSellSection:AddToggle({
    "Auto Sell Capybara",
    "Automatically equips and sells Capybara",
    UserSettings.AutoSellCapybara, 
    function(value)
        UserSettings.AutoSellCapybara = value
        SaveConfig()
        
        autoSellCapybaraActive = value
        notifyToggle("Auto Sell Capybara", value)
        if autoSellCapybaraActive then
            runAutoSell(function() return autoSellCapybaraActive end, function() return selectedCapybara end)
        end
    end
})

AutoSellSection:AddDropdown({
    "Target Capybara (Sell)",
    "Select which Capybara to sell automatically",
    true, 
    CapybaraNames,
    UserSettings.TargetCapybara, 
    function(value)
        UserSettings.TargetCapybara = value
        SaveConfig()
        selectedCapybara = value
    end
})

local autoSellPlantActive = false
AutoSellSection:AddToggle({
    "Auto Sell Plant",
    "Automatically equips and sells Plant (filtered by multiplier)",
    UserSettings.AutoSellPlant, 
    function(value)
        UserSettings.AutoSellPlant = value
        SaveConfig()
        
        autoSellPlantActive = value
        notifyToggle("Auto Sell Plant", value)
        if autoSellPlantActive then
            runAutoSellPlant(
                function() return autoSellPlantActive end,
                function() return selectedPlants end,
                function() return selectedPlantMultiplier end
            )
        end
    end
})

AutoSellSection:AddDropdown({
    "Target Plant (Sell)",
    "Select which Plant to sell automatically",
    true,
    PlantNames,
    UserSettings.TargetPlant, 
    function(value)
        UserSettings.TargetPlant = value
        SaveConfig()
        selectedPlants = value
    end
})

AutoSellSection:AddInput({
    "Sell Below Multiplier",
    "Enter a number (e.g. 1.8). Plants below this will be sold. Leave empty = sell all.",
    UserSettings.TargetPlantMultiplier,
    function(value)
        UserSettings.TargetPlantMultiplier = value
        SaveConfig()
        selectedPlantMultiplier = value
    end
})

-- ============================
-- TAB 4: SHOP
-- ============================
local ShopTab = Window:CreateTab({
    Name = "Shop",
    Icon = "rbxassetid://10734923549" 
})

local function runAutoBuy(getActive, getTargetList, remoteName)
    task.spawn(function()
        while getActive() do
            pcall(function()
                local targetList = getTargetList()
                if #targetList > 0 then
                    for _, itemName in ipairs(targetList) do
                        if not getActive() then break end
                        Remotes:WaitForChild(remoteName):FireServer(itemName)
                        task.wait(0.5)
                    end
                end
            end)
            task.wait(1)
        end
    end)
end

local EggShopSection = ShopTab:AddSection("Egg Shop", false)
local EggNames = {"Capybara Egg", "Alpha Capybara Egg", "Archer Capybara Egg", "Magic Capybara Egg", "Ghost Capybara Egg", "Golem Capybara Egg", "Robot Capybara Egg", "Disco Capybara Egg", "Angel Capybara Egg", "Dragon Capybara"}
local selectedEggs = {}
local autoBuyEggActive = false

EggShopSection:AddToggle({
    "Auto Buy Egg",
    "Automatically buys the selected egg when it appears in the shop",
    UserSettings.AutoBuyEgg, 
    function(value)
        UserSettings.AutoBuyEgg = value
        SaveConfig()
        
        autoBuyEggActive = value
        notifyToggle("Auto Buy Egg", value)
        if autoBuyEggActive then
            runAutoBuy(function() return autoBuyEggActive end, function() return selectedEggs end, "BuyItem")
        end
    end
})

EggShopSection:AddDropdown({
    "Target Egg",
    "Select which egg to buy automatically",
    true, 
    EggNames,
    UserSettings.TargetEgg, 
    function(value)
        UserSettings.TargetEgg = value
        SaveConfig()
        selectedEggs = value
    end
})

local GearShopSection = ShopTab:AddSection("Gear Shop", false)
local GearNames = {"Hatch Hammer", "Nametag", "Mutation Sponge", "Boombox", "Bizarre Stopwatch", "Trading Ticket"}
local selectedGear = {}
local autoBuyGearActive = false

GearShopSection:AddToggle({
    "Auto Buy Gear",
    "Automatically buys the selected gear when it appears in the shop",
    UserSettings.AutoBuyGear, 
    function(value)
        UserSettings.AutoBuyGear = value
        SaveConfig()
        
        autoBuyGearActive = value
        notifyToggle("Auto Buy Gear", value)
        if autoBuyGearActive then
            runAutoBuy(function() return autoBuyGearActive end, function() return selectedGear end, "BuyItem")
        end
    end
})

GearShopSection:AddDropdown({
    "Target Gear",
    "Select which gear to buy automatically",
    true, 
    GearNames,
    UserSettings.TargetGear, 
    function(value)
        UserSettings.TargetGear = value
        SaveConfig()
        selectedGear = value
    end
})

local MerchantShopSection = ShopTab:AddSection("Merchant Shop", false)
local MerchantNames = {
    "Raygun", "Alien Tesla", "Totem Of Stars", "Totem Of Might", "Totem Of Marrow",
    "Rainbow Scroll", "Gilded Hatch Hammer", "Gold Scroll", "Totem Of Status",
    "Moonlit Scroll", "Chilly Scroll", "Toasty Scroll", "Tranquil Scroll",
    "Shocked Scroll", "Glitched Scroll"
}
local selectedMerchant = {}
local autoBuyMerchantActive = false

MerchantShopSection:AddToggle({
    "Auto Buy Merchant",
    "Automatically buys the selected item from the Traveling Merchant",
    UserSettings.AutoBuyMerchant, 
    function(value)
        UserSettings.AutoBuyMerchant = value
        SaveConfig()
        
        autoBuyMerchantActive = value
        notifyToggle("Auto Buy Merchant", value)
        if autoBuyMerchantActive then
            runAutoBuy(function() return autoBuyMerchantActive end, function() return selectedMerchant end, "BuyMerchantItem")
        end
    end
})

MerchantShopSection:AddDropdown({
    "Target Item",
    "Select which merchant item to buy automatically",
    true, 
    MerchantNames,
    UserSettings.TargetMerchant, 
    function(value)
        UserSettings.TargetMerchant = value
        SaveConfig()
        selectedMerchant = value
    end
})

-- ============================
-- TAB 5: MISC
-- ============================
local MiscTab = Window:CreateTab({
    Name = "Misc",
    Icon = "rbxassetid://10734896206" 
})

local MiscSection = MiscTab:AddSection("Miscellaneous", false)

local idleConnection = nil
MiscSection:AddToggle({
    "Anti AFK",
    "Prevents you from being kicked for being AFK",
    UserSettings.AntiAFK, 
    function(value)
        UserSettings.AntiAFK = value
        SaveConfig()
        
        notifyToggle("Anti AFK", value)
        if value then
            if not idleConnection then
                idleConnection = LocalPlayer.Idled:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        else
            if idleConnection then
                idleConnection:Disconnect()
                idleConnection = nil
            end
        end
    end
})

local fpsBoostActive = false
local savedStates = {} 

local function setFpsBoost(enabled)
    if enabled then
        savedStates = {}
        
        -- 1. Matikan PostEffects di Lighting
        for _, fx in ipairs(Lighting:GetChildren()) do
            if fx:IsA("PostEffect") then
                savedStates[fx] = fx.Enabled
                fx.Enabled = false
            end
        end
        savedStates.GlobalShadows = Lighting.GlobalShadows
        Lighting.GlobalShadows = false

        -- 2. Matikan Terrain Decoration 
        if Workspace:FindFirstChildOfClass("Terrain") then
            pcall(function()
                savedStates.TerrainDecoration = Workspace.Terrain.Decoration
                Workspace.Terrain.Decoration = false
            end)
        end

        -- 3. Matikan partikel dan efek visual di Workspace
        savedStates.Effects = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") then
                table.insert(savedStates.Effects, {obj = obj, wasEnabled = obj.Enabled})
                obj.Enabled = false
            end
        end

        -- 4. PERBAIKAN: Bungkus proses read & write StreamingTargetRadius di dalam pcall
        pcall(function() 
            savedStates.StreamingTargetRadius = Workspace.StreamingTargetRadius 
            Workspace.StreamingTargetRadius = 128 
        end)
        
    else
        -- KEMBALIKAN SEMUA PENGATURAN KE SEMULA
        for fx, wasEnabled in pairs(savedStates) do
            if typeof(fx) == "Instance" and fx:IsA("PostEffect") then
                fx.Enabled = wasEnabled
            end
        end
        if savedStates.GlobalShadows ~= nil then
            Lighting.GlobalShadows = savedStates.GlobalShadows
        end
        
        if savedStates.TerrainDecoration ~= nil and Workspace:FindFirstChildOfClass("Terrain") then
            pcall(function()
                Workspace.Terrain.Decoration = savedStates.TerrainDecoration
            end)
        end
        
        if savedStates.Effects then
            for _, entry in ipairs(savedStates.Effects) do
                if entry.obj and entry.obj.Parent then
                    entry.obj.Enabled = entry.wasEnabled
                end
            end
        end
        
        -- PERBAIKAN: Restore nilainya juga dengan aman
        if savedStates.StreamingTargetRadius then
            pcall(function() Workspace.StreamingTargetRadius = savedStates.StreamingTargetRadius end)
        end
        
        savedStates = {}
    end
end

MiscSection:AddToggle({
    "FPS Boost",
    "Disables heavy visual effects to improve FPS",
    UserSettings.FPSBoost, 
    function(value)
        UserSettings.FPSBoost = value
        SaveConfig()
        
        fpsBoostActive = value
        notifyToggle("FPS Boost", value)
        setFpsBoost(fpsBoostActive)
    end
})

-- ============================
-- SCRIPT SELESAI LOADING
-- ============================
IsLoaded = true 

task.spawn(function()
    table.insert(NotifQueue, {
        Title = "Success",
        Text = "Script successfully loaded! Your settings have been restored."
    })
    task.spawn(processQueue)
end)
