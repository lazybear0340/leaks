--unobfuscated


local FuncsV3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrtokyo/refs/heads/main/FuncsV3"))()
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrlibrary/refs/heads/main/tokyo-ontop"))()

local Window = Speed_Library:CreateWindow({
    "Tokyo",
    "Anime Card Farm",
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
local RunService        = game:GetService("RunService")
local VirtualUser       = game:GetService("VirtualUser")
local HttpService       = game:GetService("HttpService")
local workspace         = game:GetService("Workspace")
local CoreGui           = game:GetService("CoreGui")
local LocalPlayer       = Players.LocalPlayer

-- Lazy resolve Remotes
local _remotesCache = nil
local function getRemotes()
    if not _remotesCache then
        _remotesCache = ReplicatedStorage:WaitForChild("Remotes", 15)
    end
    return _remotesCache
end

-- GLOBAL FLAGS
local isPausedForCardBoxes = false
local _isBossActive = false -- PENGHUBUNG TOWER & BOSS

-- ============================
-- CUSTOM TOP RIGHT UI (BOSS TIMER)
-- ============================
local timerGuiName = "TokyoHubBossTimerGUI"
if CoreGui:FindFirstChild(timerGuiName) then
    CoreGui[timerGuiName]:Destroy()
end

local TimerGui = Instance.new("ScreenGui")
TimerGui.Name = timerGuiName
local success = pcall(function() TimerGui.Parent = CoreGui end)
if not success then TimerGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local TimerFrame = Instance.new("Frame")
TimerFrame.Size = UDim2.new(0, 220, 0, 45)
TimerFrame.Position = UDim2.new(1, -20, 0, 20)
TimerFrame.AnchorPoint = Vector2.new(1, 0)
TimerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TimerFrame.BackgroundTransparency = 0.2
TimerFrame.BorderSizePixel = 0
TimerFrame.Visible = false
TimerFrame.Parent = TimerGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = TimerFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 105, 180) 
UIStroke.Thickness = 2
UIStroke.Parent = TimerFrame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(1, -10, 1, -10)
TimerLabel.Position = UDim2.new(0, 5, 0, 5)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "Boss Status: Searching..."
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.TextScaled = true
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.Parent = TimerFrame

-- ============================
-- AUTO-SAVE CONFIG SYSTEM
-- ============================
local SaveFileName = "TokyoHub_ZeroDelay_SaveData.json"
local UserSettings = {
    AutoSpawn = false,
    AutoFarm = false,
    TargetPacks = {},
    TargetMutations = {},
    
    AutoBoss = false,
    TargetBossDifficulty = {},
    TargetBossCard = {}, 
    
    AutoTower = false,
    TargetTowerCard = {},
    TowerDelay = "15",
    
    AutoSell = false,
    SellTargetPacks = {},
    SellTargetMutations = {},
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
-- NOTIFICATION QUEUE SYSTEM
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
            Speed_Library:SetNotification({"Info", currentNotif.Title, currentNotif.Text})
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

-- ==============================================================================
-- DATABASE LIST 
-- ==============================================================================
local PackList = {
    "All",
    "Academy Pack", "Beast Pack", "Bizarre Pack", "Blaze Pack",
    "Chainsaw Pack", "Chaos Pack", "Conquest Pack", "Dark Pack",
    "Demon Pack", "Devour Pack", "Diamond Pack", "Dynasty", "Dynasty Pack",
    "Eclipse Pack", "Empyrean Pack", "Eternity Pack", "Evolved Pack", 
    "Galaxy Pack", "Gamer Pack", "Grail Pack", "Grimoire Pack", 
    "Heaven Pack", "Hightech Pack", "Hunter Pack", "Ice Pack", 
    "Inferno Pack", "Isekai Pack", "Lightning Pack", "Mage Pack", 
    "Manga Pack", "Monarch Pack", "Oni Pack", "Pirate King Pack", 
    "Revenge Pack", "Royal Pack", "Ruin Pack", "Sand Pack", 
    "Slayer Pack", "Soccer Pack", "Soul Pack", "Swordsman Pack", 
    "Titan Pack", "Viking Pack", "Void Pack", "Raven Pack", "Arcane Pack",
    "Nightfall Pack", "Smash Pack", "Emblem Pack", "Chrono Pack",
    "Dunk Pack", "Blossom Pack", "Zenith Pack", "Assassin Pack", "Power Pack", "Rebellion Pack",
    "Alchemy Pack", "Azure Pack", "Psychic Pack"
}

local MutationList = {
    "All",
    "Normal", "Golden", "Diamond", "Rainbow", "Glitch", 
    "Blessed", "Sakura", "Radioactive", "Candy", "Venomous",
    "Starfallen", "Admin", "Unknown", "Nullstar"
}

local BossDifficultyList = {"Easy", "Medium", "Hard", "Nightmare", "Insane"}

local function GetAvailableCards()
    local cards = {}
    local dict = {}
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local toolNameLower = string.lower(tool.Name)
                if not string.find(toolNameLower, "pack") and not string.find(toolNameLower, "box") then
                    if not dict[tool.Name] then
                        dict[tool.Name] = true
                        table.insert(cards, tool.Name)
                    end
                end
            end
        end
    end
    if #cards == 0 then table.insert(cards, "No Cards Found") end
    return cards
end

-- ==============================================================================
-- TAB 1: INFO
-- ==============================================================================
local InfoTab = Window:CreateTab({ Name = "Info", Icon = "rbxassetid://10734949856" })
local InfoSection = InfoTab:AddSection("Welcome", false)

InfoSection:AddParagraph({
    "Tokyo Hub",
    "Welcome to Tokyo Hub! Tower UI Simplified: Time-Based Claim System."
})

InfoSection:AddButton({
    "Copy Discord Invite",
    "",
    "rbxassetid://7734010488",
    function()
        setclipboard("https://discord.gg/4ua2YbvQY5")
        task.spawn(function()
            table.insert(NotifQueue, {Title = "Discord Invite", Text = "Discord invite link copied!"})
            task.spawn(processQueue)
        end)
    end
})

-- ==============================================================================
-- TAB 2: MAIN
-- ==============================================================================
local MainTab = Window:CreateTab({ Name = "Main", Icon = "rbxassetid://10734950020" })
local MainSection = MainTab:AddSection("Main Features", false)

local function getMyPlotButton()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closestButton = nil
    local shortestDistance = math.huge

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "ButtonPart" then
            local cd = obj:FindFirstChildOfClass("ClickDetector")
            if cd then
                local dist = (obj.Position - hrp.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestButton = obj
                end
            end
        end
    end
    
    return closestButton
end

-- 1. AUTO SPAWN PACK
local autoSpawnActive = false
local mySpawnButton = nil 

MainSection:AddToggle({
    "Auto Spawn Pack",
    "Auto teleports to Base, locks your plot button, and auto spawns",
    UserSettings.AutoSpawn, 
    function(value)
        UserSettings.AutoSpawn = value
        SaveConfig()
        autoSpawnActive = value
        
        if autoSpawnActive then
            task.spawn(function()
                pcall(function()
                    getRemotes():WaitForChild("TeleportButtonRE"):FireServer("Base")
                end)
                
                task.wait(1.5)
                
                mySpawnButton = getMyPlotButton()
                if mySpawnButton then
                    notifyToggle("Auto Spawn (Locked to Base)", true)
                else
                    notifyToggle("Error: Spawn Button Not Found!", false)
                    autoSpawnActive = false
                    return
                end
                
                while autoSpawnActive do
                    if not isPausedForCardBoxes then
                        pcall(function()
                            if mySpawnButton and mySpawnButton:FindFirstChildOfClass("ClickDetector") then
                                fireclickdetector(mySpawnButton:FindFirstChildOfClass("ClickDetector"))
                            end
                        end)
                    end
                    task.wait(1)
                end
            end)
        else
            notifyToggle("Auto Spawn Pack", false)
            mySpawnButton = nil
        end
    end
})

-- 2. AUTO FARM / BUY 
local selectedFarmPacks = UserSettings.TargetPacks or {}
local selectedFarmMutations = UserSettings.TargetMutations or {}
local autoFarmActive = UserSettings.AutoFarm 

local function processFastBuy(item)
    if not autoFarmActive then return end
    if isPausedForCardBoxes then return end
    
    task.spawn(function()
        local guiHolder = item:WaitForChild("GuiHolder", 3)
        if not guiHolder then return end
        
        local guiInfo = guiHolder:WaitForChild("BillboardGuiInfo", 3)
        if not guiInfo then return end
        
        local foundPack = ""
        local foundMutation = "Normal"
        local maxWait = 10
        
        while maxWait > 0 do
            local hasText = false
            for _, desc in pairs(guiInfo:GetDescendants()) do
                if (desc:IsA("TextLabel") or desc:IsA("TextButton")) and desc.Text ~= "" and desc.Text ~= "Label" then
                    hasText = true
                    if table.find(PackList, desc.Text) then 
                        foundPack = desc.Text 
                    end
                    if table.find(MutationList, desc.Text) then 
                        foundMutation = desc.Text 
                    end
                end
            end
            
            if foundPack ~= "" then break end
            
            task.wait(0.2)
            maxWait = maxWait - 1
        end
        
        if foundPack == "" then return end
        
        local packCocok = (#selectedFarmPacks == 0) or table.find(selectedFarmPacks, "All") or table.find(selectedFarmPacks, foundPack)
        local mutasiCocok = (#selectedFarmMutations == 0) or table.find(selectedFarmMutations, "All") or table.find(selectedFarmMutations, foundMutation)
        
        if packCocok and mutasiCocok then
            local mainPart = item:WaitForChild("Main", 3)
            if mainPart then
                local prompt = mainPart:WaitForChild("ProximityPrompt", 3)
                if prompt then
                    prompt.RequiresLineOfSight = false
                    prompt.MaxActivationDistance = math.huge
                    
                    local connection
                    connection = RunService.Heartbeat:Connect(function()
                        if not item or not item.Parent or not autoFarmActive or isPausedForCardBoxes then
                            connection:Disconnect()
                            return
                        end
                        if prompt.Enabled then
                            fireproximityprompt(prompt)
                            connection:Disconnect() 
                        end
                    end)
                end
            end
        end
    end)
end

workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") or descendant:IsA("Tool") then
        task.spawn(function()
            if descendant:WaitForChild("GuiHolder", 1) then
                processFastBuy(descendant)
            end
        end)
    end
end)

MainSection:AddToggle({
    "Auto Buy Pack / Card",
    "Scans holograms automatically for both Packs and Cards",
    UserSettings.AutoFarm, 
    function(value)
        UserSettings.AutoFarm = value
        SaveConfig()
        autoFarmActive = value
        notifyToggle("Auto Buy Pack / Card", value)
    end
})

MainSection:AddDropdown({
    "Select Target Category",
    "Choose which packs/categories you want to farm",
    true, PackList, UserSettings.TargetPacks, 
    function(value)
        UserSettings.TargetPacks = value
        SaveConfig()
        selectedFarmPacks = value
    end
})

MainSection:AddDropdown({
    "Select Target Mutation",
    "Choose which mutations you want to farm",
    true, MutationList, UserSettings.TargetMutations, 
    function(value)
        UserSettings.TargetMutations = value
        SaveConfig()
        selectedFarmMutations = value
    end
})

-- ==============================================================================
-- SECTION: AUTO BOSS
-- ==============================================================================
local BossSection = MainTab:AddSection("Auto Boss", false) 
local selectedBossDifficulty = UserSettings.TargetBossDifficulty or {}
local selectedBossCard = UserSettings.TargetBossCard or {}
local autoBossActive = false
local hasFoughtCurrentBoss = false
local isCurrentlyFighting = false

BossSection:AddToggle({
    "Enable Auto Boss",
    "Auto detects 'End in' text and starts the fight. Boss auto-claims itself.",
    UserSettings.AutoBoss, 
    function(value)
        UserSettings.AutoBoss = value
        SaveConfig()
        autoBossActive = value
        notifyToggle("Auto Boss", value)
        
        TimerFrame.Visible = value
        
        if autoBossActive then
            task.spawn(function()
                while autoBossActive do
                    local isOpen = false
                    local statusText = "Searching..."
                    
                    pcall(function()
                        for _, desc in pairs(workspace:GetDescendants()) do
                            if desc:IsA("TextLabel") and (string.find(desc.Text, "Open in") or string.find(desc.Text, "Closing in") or string.find(desc.Text, "End in") or desc.Text == "Open!" or desc.Text == "Open") then
                                statusText = desc.Text
                                if string.find(statusText, "Open in") then
                                    isOpen = false
                                else
                                    isOpen = true 
                                end
                                break
                            end
                        end
                    end)
                    
                    -- Jika Bos sudah tutup, reset status agar siap untuk Bos berikutnya
                    if not isOpen then
                        hasFoughtCurrentBoss = false
                    end
                    
                    -- Tower HANYA berhenti jika bos buka dan kita belum melawannya
                    _isBossActive = (isOpen and not hasFoughtCurrentBoss) or isCurrentlyFighting
                    
                    if isOpen and not hasFoughtCurrentBoss then
                        isCurrentlyFighting = true
                        if TimerLabel then TimerLabel.Text = "Syncing with Tower..." end
                        
                        task.wait(3) -- Jeda agar aman keluar dari tower
                        
                        pcall(function()
                            local char = LocalPlayer.Character
                            
                            local diffString = type(selectedBossDifficulty) == "table" and selectedBossDifficulty[1] or selectedBossDifficulty
                            if type(diffString) ~= "string" or diffString == "" then diffString = "Easy" end
                            
                            -- Tunggu kartu kembali ke Backpack (mungkin masih terkunci di Tower)
                            if TimerLabel then TimerLabel.Text = "Waiting for cards..." end
                            local teamArgs = {}
                            
                            for attempt = 1, 20 do -- retry sampai 10 detik (20 x 0.5s)
                                teamArgs = {}
                                local bp = LocalPlayer:FindFirstChild("Backpack")
                                if bp then
                                    for _, cardName in ipairs(selectedBossCard) do
                                        local cardTool = bp:FindFirstChild(cardName) or (char and char:FindFirstChild(cardName))
                                        if cardTool then 
                                            table.insert(teamArgs, cardTool) 
                                        end
                                    end
                                end
                                
                                if #teamArgs >= #selectedBossCard or #teamArgs > 0 then
                                    break
                                end
                                task.wait(0.5)
                            end
                            
                            if #teamArgs > 0 then
                                if TimerLabel then TimerLabel.Text = "Starting Boss Fight (" .. #teamArgs .. " cards)..." end
                                
                                local bossRemote = getRemotes():WaitForChild("BossRaidRE")
                                
                                -- 1. Start fight
                                bossRemote:FireServer("StartFight", {
                                    Team = teamArgs,
                                    Difficulty = diffString
                                })
                                
                                -- 2. Tunggu sebentar lalu kirim EndFight untuk claim kill
                                task.wait(5)
                                
                                if TimerLabel then TimerLabel.Text = "Finishing Boss..." end
                                
                                bossRemote:FireServer("EndFight", {
                                    DamageReported = 1e+30,
                                    Phase = 4
                                })
                                
                                hasFoughtCurrentBoss = true
                            else
                                if TimerLabel then TimerLabel.Text = "No Cards Found in Backpack!" end
                                task.wait(5)
                            end
                        end)
                        
                        isCurrentlyFighting = false
                    else
                        if TimerLabel then
                            if isOpen and hasFoughtCurrentBoss then
                                TimerLabel.Text = "Boss Done! " .. statusText
                            else
                                TimerLabel.Text = statusText
                            end
                        end
                        task.wait(1) 
                    end
                end
            end)
        end
    end
})

BossSection:AddDropdown({
    "Select Boss Difficulty",
    "Choose the difficulty of the boss you want to farm",
    true, BossDifficultyList, UserSettings.TargetBossDifficulty, 
    function(value)
        UserSettings.TargetBossDifficulty = value
        SaveConfig()
        selectedBossDifficulty = value
    end
})

local BossCardDropdown = BossSection:AddDropdown({
    "Select Your Cards (Max 4)",
    "Choose up to 4 cards you want to use against the boss",
    true, GetAvailableCards(), UserSettings.TargetBossCard, 
    function(value)
        if #value > 4 then
            local trimmed = {}
            for i = 1, 4 do table.insert(trimmed, value[i]) end
            value = trimmed
            task.spawn(function()
                table.insert(NotifQueue, {Title = "Limit Exceeded", Text = "You can only select up to 4 cards!"})
                task.spawn(processQueue)
            end)
        end
        UserSettings.TargetBossCard = value
        SaveConfig()
        selectedBossCard = value
    end
})

BossSection:AddButton({
    "Refresh Boss Cards",
    "Update the dropdown list with cards currently in your Backpack",
    "rbxassetid://10088146939",
    function()
        local newCards = GetAvailableCards()
        pcall(function() BossCardDropdown:Refresh(newCards) end)
        pcall(function() BossCardDropdown:SetOptions(newCards) end)
        
        task.spawn(function()
            table.insert(NotifQueue, {Title = "Refreshed", Text = "Boss Card list updated!"})
            task.spawn(processQueue)
        end)
    end
})

-- ==============================================================================
-- SECTION: INFINITY TOWER (DELAY-BASED CLAIM)
-- ==============================================================================
local TowerSection = MainTab:AddSection("Infinity Tower", false) 
local selectedTowerCard = UserSettings.TargetTowerCard or {}
local autoTowerActive = false

-- Sekarang kita hanya menggunakan TowerDelay murni!
local towerDelay = UserSettings.TowerDelay or "15"

TowerSection:AddToggle({
    "Enable Infinity Tower",
    "Starts battle -> Waits for delay -> Claims automatically.",
    UserSettings.AutoTower, 
    function(value)
        UserSettings.AutoTower = value
        SaveConfig()
        autoTowerActive = value
        notifyToggle("Auto Tower", value)
        
        if autoTowerActive then
            task.spawn(function()
                while autoTowerActive do
                    if _isBossActive then
                        -- Jika Bos sedang aktif, Tower ditahan dan tidak akan mulai
                        task.wait(5)
                    else
                        pcall(function()
                            local bp = LocalPlayer:FindFirstChild("Backpack")
                            local teamArgs = {}
                            
                            if bp then
                                for _, cardName in ipairs(selectedTowerCard) do
                                    local cardTool = bp:FindFirstChild(cardName)
                                    if cardTool then 
                                        table.insert(teamArgs, cardTool) 
                                    end
                                end
                            end
                            
                            if #teamArgs > 0 then
                                -- 1. Start Battle
                                getRemotes():WaitForChild("InfinityTowerRE"):FireServer("StartBattle", {Team = teamArgs})
                                
                                -- 2. Sistem Delay yang bisa diinterupsi oleh Bos
                                local safeDelay = tonumber(towerDelay) or 15
                                local elapsed = 0
                                
                                while elapsed < safeDelay and autoTowerActive do
                                    if _isBossActive then
                                        -- INTERUPSI: Bos muncul! Segera keluar dari Tower!
                                        getRemotes():WaitForChild("InfinityTowerRE"):FireServer("EndBattle", {FloorReached = 999})
                                        break
                                    end
                                    task.wait(1)
                                    elapsed = elapsed + 1
                                end
                                
                                -- 3. Jika loop di atas selesai tanpa interupsi bos (waktu murni habis / kartu mati), 
                                -- kita TIDAK memanggil EndBattle agar game mereset secara natural,
                                -- kecuali jika game ini memang butuh EndBattle manual (Anda bisa menyesuaikan jika diperlukan).
                                
                            else
                                warn("[Auto Tower] No cards selected for Tower!")
                            end
                        end)
                        task.wait(2)
                    end
                end
            end)
        end
    end
})

local TowerCardDropdown = TowerSection:AddDropdown({
    "Select Your Cards (Max 4)",
    "Choose up to 4 cards for Infinity Tower",
    true, GetAvailableCards(), UserSettings.TargetTowerCard, 
    function(value)
        if #value > 4 then
            local trimmed = {}
            for i = 1, 4 do table.insert(trimmed, value[i]) end
            value = trimmed
            task.spawn(function()
                table.insert(NotifQueue, {Title = "Limit Exceeded", Text = "You can only select up to 4 cards!"})
                task.spawn(processQueue)
            end)
        end
        UserSettings.TargetTowerCard = value
        SaveConfig()
        selectedTowerCard = value
    end
})

FuncsV3:Textbox(TowerSection, "Wait Before Claim (Seconds)", "Set delay before claiming (e.g. 15)", function(text)
    local num = tonumber(text)
    if num then
        towerDelay = tostring(num)
        UserSettings.TowerDelay = towerDelay
        SaveConfig()
        task.spawn(function()
            table.insert(NotifQueue, {Title = "Delay Saved", Text = "Claim Delay set to " .. tostring(towerDelay) .. "s"})
            task.spawn(processQueue)
        end)
    end
end)

TowerSection:AddButton({
    "Refresh Tower Cards",
    "Update the dropdown list with cards currently in your Backpack",
    "rbxassetid://10088146939",
    function()
        local newCards = GetAvailableCards()
        pcall(function() TowerCardDropdown:Refresh(newCards) end)
        pcall(function() TowerCardDropdown:SetOptions(newCards) end)
        
        task.spawn(function()
            table.insert(NotifQueue, {Title = "Refreshed", Text = "Tower Card list updated!"})
            task.spawn(processQueue)
        end)
    end
})

-- ==============================================================================
-- TAB 3: AUTO (SELL & MISC)
-- ==============================================================================
local AutoTab = Window:CreateTab({ Name = "Auto", Icon = "rbxassetid://10734950309" })
local AutoSellSection = AutoTab:AddSection("Auto Sell", false)

local selectedSellPacks = UserSettings.SellTargetPacks or {}
local selectedSellMutations = UserSettings.SellTargetMutations or {}
local autoSellActive = false

local function getToolMutation(tool)
    local attrMutation = tool:GetAttribute("Mutation")
    if attrMutation then return attrMutation end

    local mutationChild = tool:FindFirstChild("Mutation")
    if mutationChild and (mutationChild:IsA("StringValue") or mutationChild:IsA("TextLabel")) then
        local val = mutationChild.Value or mutationChild.Text
        if val and val ~= "" then return val end
    end

    return "Normal"
end

local function AutoSellLoop()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not character or not backpack then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local sellRemote = getRemotes():WaitForChild("SellRE", 10)
    if not sellRemote then
        warn("[AutoSell] Remote 'SellRE' not found")
        return
    end

    for _, tool in ipairs(backpack:GetChildren()) do
        if not autoSellActive then break end

        if tool:IsA("Tool") then
            local packCocok = (#selectedSellPacks == 0) or table.find(selectedSellPacks, "All") or table.find(selectedSellPacks, tool.Name)
            local toolMutation = getToolMutation(tool)
            local mutasiCocok = (#selectedSellMutations == 0) or table.find(selectedSellMutations, "All") or table.find(selectedSellMutations, toolMutation)

            if packCocok and mutasiCocok then
                pcall(function()
                    humanoid:EquipTool(tool)
                end)

                task.wait(0.15)

                pcall(function()
                    sellRemote:FireServer("SellHand")
                end)

                task.wait(0.15)
            end
        end
    end
end

AutoSellSection:AddToggle({
    "Auto Sell",
    "Automatically sell items based on selected pack and mutation",
    UserSettings.AutoSell, 
    function(value)
        UserSettings.AutoSell = value
        SaveConfig()
        autoSellActive = value
        notifyToggle("Auto Sell", value)
        
        if autoSellActive then
            task.spawn(function()
                while autoSellActive do
                    pcall(AutoSellLoop)
                    task.wait(1) 
                end
            end)
        end
    end
})

AutoSellSection:AddDropdown({
    "Select Sell Pack (Rarity)",
    "Choose which packs you want to automatically sell",
    true, PackList, UserSettings.SellTargetPacks, 
    function(value)
        UserSettings.SellTargetPacks = value
        SaveConfig()
        selectedSellPacks = value
    end
})

AutoSellSection:AddDropdown({
    "Select Sell Mutation",
    "Choose which mutations you want to automatically sell",
    true, MutationList, UserSettings.SellTargetMutations, 
    function(value)
        UserSettings.SellTargetMutations = value
        SaveConfig()
        selectedSellMutations = value
    end
})

-- ==============================================================================
-- SECTION: AUTO SELL CARD BOXES
-- ==============================================================================
local AutoSellCardBoxesSection = AutoTab:AddSection("Auto Sell Card Boxes", false)
local autoSellCardBoxesActive = false

local function findClosestPrompt(matchText)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closestPrompt = nil
    local shortestDistance = math.huge

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local text = (obj.ActionText or "") .. " " .. (obj.ObjectText or "")
            if string.find(string.lower(text), string.lower(matchText)) then
                local part = obj.Parent
                if part and part:IsA("BasePart") then
                    local dist = (part.Position - hrp.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestPrompt = obj
                    end
                elseif part and part:IsA("Model") and part.PrimaryPart then
                    local dist = (part.PrimaryPart.Position - hrp.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestPrompt = obj
                    end
                end
            end
        end
    end

    return closestPrompt
end

local function fireCardBoxPrompt(prompt, waitForEnabled)
    if not prompt then return false end
    pcall(function()
        prompt.MaxActivationDistance = math.huge
        prompt.RequiresLineOfSight = false
    end)

    if waitForEnabled then
        local waitStart = os.clock()
        while not prompt.Enabled do
            task.wait(0.1)
            if os.clock() - waitStart > 3 then
                warn("[AutoSellCardBoxes] Prompt not Enabled after 3 seconds:", prompt.ActionText or prompt.ObjectText)
                return false
            end
        end
    end

    local ok = pcall(function()
        fireproximityprompt(prompt)
    end)

    return ok
end

local function EquipCardBox()
    local character = LocalPlayer.Character
    if not character then return false end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end

    local function isCardBoxTool(tool)
        return tool:IsA("Tool") and string.find(string.lower(tool.Name), "box") ~= nil
    end

    local alreadyEquipped = character:FindFirstChildOfClass("Tool")
    if alreadyEquipped and isCardBoxTool(alreadyEquipped) then
        return true
    end

    local backpack = LocalPlayer:WaitForChild("Backpack", 2)
    if not backpack then return false end

    local targetTool = nil
    for attempt = 1, 8 do
        for _, tool in ipairs(backpack:GetChildren()) do
            if isCardBoxTool(tool) then
                targetTool = tool
                break
            end
        end
        if targetTool then break end
        task.wait(0.25)
    end

    if not targetTool then
        warn("[AutoSellCardBoxes] Card Box not found in Backpack")
        return false
    end

    pcall(function()
        humanoid:EquipTool(targetTool)
    end)

    for attempt = 1, 8 do
        local equippedNow = character:FindFirstChildOfClass("Tool")
        if equippedNow and equippedNow == targetTool then
            return true
        end
        task.wait(0.1)
    end

    warn("[AutoSellCardBoxes] Equip failed to verify")
    return false
end

local function getPromptWorldPosition(prompt)
    local part = prompt.Parent
    if part and part:IsA("BasePart") then
        return part.Position
    elseif part and part:IsA("Model") and part.PrimaryPart then
        return part.PrimaryPart.Position
    end
    return nil
end

local function teleportNear(targetPos)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetPos then return false end

    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
    task.wait(0.15) 
    return true
end

local function AutoSellCardBoxesLoop()
    local carryPrompt = findClosestPrompt("Carry")
    if carryPrompt then
        local carryPos = getPromptWorldPosition(carryPrompt)
        if carryPos then teleportNear(carryPos) end

        fireCardBoxPrompt(carryPrompt, false)
        task.wait(0.8)
    else
        warn("[AutoSellCardBoxes] Prompt 'Carry' not found")
    end

    local equipped = EquipCardBox()
    if not equipped then
        return
    end

    task.wait(0.6)

    local sellPrompt = findClosestPrompt("Sell Card Boxes")
    if not sellPrompt then
        warn("[AutoSellCardBoxes] Prompt 'Sell Card Boxes' not found")
        return
    end

    local sellPos = getPromptWorldPosition(sellPrompt)
    if sellPos then
        teleportNear(sellPos)
    else
        warn("[AutoSellCardBoxes] Cannot get Sell prompt position")
    end

    local fired = fireCardBoxPrompt(sellPrompt, true)
    if fired then
        -- Optional: print success
    else
        warn("[AutoSellCardBoxes] Failed to fire Sell prompt")
    end
end

AutoSellCardBoxesSection:AddToggle({
    "Enable Auto Sell",
    "Temporarily pauses Farm, sells card boxes, then returns (every 60s)",
    false,
    function(value)
        autoSellCardBoxesActive = value
        notifyToggle("Auto Sell Card Boxes", value)

        if autoSellCardBoxesActive then
            task.spawn(function()
                while autoSellCardBoxesActive do
                    local character = LocalPlayer.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    local returnCFrame = hrp and hrp.CFrame

                    isPausedForCardBoxes = true

                    pcall(AutoSellCardBoxesLoop)

                    task.wait(0.3)
                    if returnCFrame then
                        local charAfter = LocalPlayer.Character
                        local hrpAfter = charAfter and charAfter:FindFirstChild("HumanoidRootPart")
                        if hrpAfter then
                            hrpAfter.CFrame = returnCFrame
                            task.wait(0.15)
                        end
                    end

                    isPausedForCardBoxes = false

                    task.wait(60) 
                end

                isPausedForCardBoxes = false
            end)
        end
    end
})

-- ==============================================================================
-- TAB 4: MISC
-- ==============================================================================
local MiscTab = Window:CreateTab({ Name = "Misc", Icon = "rbxassetid://10734896206" })
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

local Lighting  = game:GetService("Lighting")
local savedStates = {}

local function setFpsBoost(enabled)
    task.spawn(function()
        if enabled then
            savedStates = {}
            
            for _, fx in ipairs(Lighting:GetDescendants()) do
                if fx:IsA("PostEffect") then
                    savedStates[fx] = fx.Enabled
                    pcall(function() fx.Enabled = false end)
                end
            end
            
            savedStates.GlobalShadows = Lighting.GlobalShadows
            pcall(function() Lighting.GlobalShadows = false end)

            savedStates.Effects = {}
            local descendants = workspace:GetDescendants()
            for i, obj in ipairs(descendants) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") then
                    table.insert(savedStates.Effects, {obj = obj, wasEnabled = obj.Enabled})
                    pcall(function() obj.Enabled = false end)
                end
                
                if i % 1000 == 0 then task.wait() end
            end
        else
            for fx, wasEnabled in pairs(savedStates) do
                if typeof(fx) == "Instance" and fx:IsA("PostEffect") then 
                    pcall(function() fx.Enabled = wasEnabled end) 
                end
            end
            
            if savedStates.GlobalShadows ~= nil then 
                pcall(function() Lighting.GlobalShadows = savedStates.GlobalShadows end) 
            end
            
            if savedStates.Effects then
                for _, entry in ipairs(savedStates.Effects) do
                    if entry.obj and entry.obj.Parent then 
                        pcall(function() entry.obj.Enabled = entry.wasEnabled end) 
                    end
                end
            end
            savedStates = {}
        end
    end)
end

MiscSection:AddToggle({
    "FPS Boost",
    "Disables heavy visual effects",
    UserSettings.FPSBoost, 
    function(value)
        UserSettings.FPSBoost = value
        SaveConfig()
        notifyToggle("FPS Boost", value)
        setFpsBoost(value)
    end
})

-- ==============================================================================
-- SCRIPT FINISHED LOADING
-- ==============================================================================
IsLoaded = true 

task.spawn(function()
    table.insert(NotifQueue, {
        Title = "Success",
        Text = "Script successfully loaded! Logic injected."
    })
    task.spawn(processQueue)
end)
