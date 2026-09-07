--unobfuscated


local FuncsV3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrtokyo/refs/heads/main/FuncsV3"))()
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrlibrary/refs/heads/main/tokyo-ontop"))()

local Window = Speed_Library:CreateWindow({
    "Tokyo",
    "Jump To Steal Soccer Players",
    120,
    nil, 
    "rbxassetid://91570350247074"
})

Speed_Library:AddTopInfo("All Rank")

Speed_Library:SetCharacterArt("rbxassetid://95368690194608", {
    Size = UDim2.new(0, 420, 0, 420),
    Position = UDim2.new(0.5, 0, 0.68, 0),
    Transparency = 0.8
})

-- ==============================================================================
-- SHARED SERVICES / VARIABLES
-- ==============================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local NetworkRemotes = ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
local PlaceRemote = NetworkRemotes:WaitForChild("Place Slime")
local OpenRemote = NetworkRemotes:WaitForChild("Open Lucky Block")
local PickupRemote = NetworkRemotes:WaitForChild("Pickup Slime")
local CollectRemote = NetworkRemotes:WaitForChild("Collect Earnings")
local UpgradeRemote = NetworkRemotes:WaitForChild("Upgrade Slime")
local SellRemote = NetworkRemotes:WaitForChild("Sell Slime From Inventory")
local CarryRemote = NetworkRemotes:WaitForChild("Upgrade Carry Limit")
local SpeedRemote = NetworkRemotes:WaitForChild("Buy Speed Upgrade")
local RebirthRemote = NetworkRemotes:WaitForChild("Rebirth")
local GiftRemote = NetworkRemotes:WaitForChild("Gift Slime")

local MAX_BASE_SLOTS = 30 

-- ==============================================================================
-- SISTEM AUTO-SAVE
-- ==============================================================================
local SaveFileName = "NewGame_TokyoHub.json"
local UserSettings = {
    AutoHarvestActive = false,
    TargetRarities = {"All"},
    AutoPlaceActive = false,
    AutoOpenActive = false,
    AutoPlaceRarities = {"All"},
    AutoCollectCashActive = false,
    AutoUpgradeActive = false,
    MaxUpgrade = "50",
    AutoSellActive = false,
    AutoSellRarities = {"None"},
    AutoSellItem = {"None"},
    AutoCarryActive = false,
    AutoSpeedActive = false,
    AutoRebirthActive = false,
    AutoTradeActive = false,
    TargetTradePlayer = {"None"},
    TargetTradeItem = {"None"},
    AntiAFKActive = false
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

local function ensureTable(val)
    if type(val) == "table" then return val end
    if val == nil then return {"None"} end
    return {val}
end

-- ==============================================================================
-- SHARED FUNCTIONS & LISTS
-- ==============================================================================
local RarityList = {
    "All", "None", "Common", "Rare", "Epic", "Legendary", 
    "Mythic", "Secret", "Slime God", "Exclusive", 
    "OG", "Champions", "Spain", "Divine", "Icons", "Ghost", "Poison", "Rainbow", "Waves"
}

local function parseMultiSelect(val)
    local arr = {}
    if type(val) == "table" then
        for k, v in pairs(val) do
            if type(k) == "number" then table.insert(arr, tostring(v))
            elseif type(k) == "string" and v == true then table.insert(arr, k)
            elseif type(k) == "string" and type(v) == "string" then table.insert(arr, v)
            end
        end
    elseif type(val) == "string" then
        table.insert(arr, val)
    end
    if #arr == 0 then return {"All"} end
    return arr
end

local function getBackpackItems()
    local items = {"None", "All"}
    local dict = {}
    pcall(function()
        for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and v:GetAttribute("slimeUID") then
                if not dict[v.Name] then
                    dict[v.Name] = true
                    table.insert(items, v.Name)
                end
            end
        end
    end)
    return items
end

local function getPlayerNames()
    local names = {"None"}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

-- ==============================================================================
-- TABS (SIDEBAR)
-- ==============================================================================
local InfoTab = Window:CreateTab({ ["Name"] = "Info", ["Icon"] = "rbxthumb://type=Asset&id=17829948098&w=150&h=150" })
local MainTab = Window:CreateTab({ ["Name"] = "Main", ["Icon"] = "rbxthumb://type=Asset&id=170940874&w=150&h=150" })
local AutoTab = Window:CreateTab({ ["Name"] = "Auto", ["Icon"] = "rbxthumb://type=Asset&id=16326604165&w=150&h=150" })
local MiscTab = Window:CreateTab({ ["Name"] = "Misc", ["Icon"] = "rbxthumb://type=Asset&id=7059346386&w=150&h=150" })

-- ==============================================================================
-- TAB 1: INFO (DEV & FEATURES)
-- ==============================================================================
local InfoSection = InfoTab:AddSection("Information", false)

InfoSection:AddParagraph({
    "Developer", 
    "PTR"
})

InfoSection:AddParagraph({
    "Features Overview", 
    "Welcome to the Ultimate Auto Farm Script!\n\n" ..
    "🟢 Smart Auto Harvest: Teleports to block, safely loots, and returns to your base.\n" ..
    "🟢 Auto Place & Open: Effortlessly places blocks on slots and breaks them.\n" ..
    "🟢 Progression Spammer: Auto buys Carry, Jump/Speed, and Auto Rebirths.\n" ..
    "🟢 Multi-Select Trading & Selling: Filter items easily to sell or stealthily gift them.\n" ..
    "🟢 Misc: FPS Boost & Anti-AFK included."
})

InfoSection:AddButton({
    "Copy Discord Link",
    "Join our community: https://discord.gg/ptrtokyo",
    "rbxassetid://10088146939",
    function()
        pcall(function()
            if setclipboard then
                setclipboard("https://discord.gg/ptrtokyo")
            end
        end)
    end
})

-- ==============================================================================
-- TAB 2: MAIN (AUTO FARM)
-- ==============================================================================
local AutoFarmSection = MainTab:AddSection("Auto Farm", false)

local autoHarvestActive = false
local activeRarityFilters = parseMultiSelect(UserSettings.TargetRarities)
local homeCFrame = nil 

local function getTargetFolders()
    local folders = {}
    local liveFolder = workspace:FindFirstChild("Live")
    if liveFolder then
        local slimesFolder = liveFolder:FindFirstChild("Slimes")
        if slimesFolder then table.insert(folders, slimesFolder) end
    end
    
    local plotsFolder = workspace:FindFirstChild("Plots")
    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local pad = plot:FindFirstChild("LuckyBlockPad")
            if pad then
                local showcase = pad:FindFirstChild("Showcase")
                if showcase then table.insert(folders, showcase) end
            end
        end
    end
    return folders
end

AutoFarmSection:AddToggle({
    "Enable Auto Pickup",
    "Stand at your base/claim spot before enabling! Automatically returns after grabbing a block.",
    UserSettings.AutoHarvestActive,
    function(value)
        UserSettings.AutoHarvestActive = value
        SaveConfig()
        autoHarvestActive = value

        if autoHarvestActive then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                homeCFrame = char.HumanoidRootPart.CFrame
            end

            task.spawn(function()
                while autoHarvestActive do
                    local foundAnyTarget = false
                    
                    pcall(function()
                        local myChar = LocalPlayer.Character
                        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

                        local targetFolders = getTargetFolders()
                        
                        for _, folder in ipairs(targetFolders) do
                            for _, block in ipairs(folder:GetChildren()) do
                                if not autoHarvestActive then break end

                                if block:IsA("Model") and string.find(string.lower(block.Name), "lucky block") then
                                    local isTarget = false
                                    if table.find(activeRarityFilters, "All") then
                                        isTarget = true
                                    else
                                        for _, rarity in ipairs(activeRarityFilters) do
                                            if string.find(string.lower(block.Name), string.lower(rarity)) then
                                                isTarget = true
                                                break
                                            end
                                        end
                                    end

                                    if isTarget then
                                        local rootPart = block:FindFirstChild("RootPart")
                                        if rootPart then
                                            local prompt = rootPart:FindFirstChildWhichIsA("ProximityPrompt")
                                            
                                            if prompt and prompt.Enabled then
                                                foundAnyTarget = true
                                                
                                                myChar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                                                myChar:PivotTo(rootPart.CFrame * CFrame.new(0, 1.5, 0)) 
                                                task.wait(0.15) 
                                                
                                                prompt.RequiresLineOfSight = false
                                                prompt.MaxActivationDistance = math.huge
                                                pcall(function() prompt.HoldDuration = 0 end)

                                                if fireproximityprompt then
                                                    -- [FIX]: Spam super cepat (20 kali tanpa delay besar)
                                                    for i = 1, 20 do
                                                        fireproximityprompt(prompt)
                                                        task.wait(0.01) -- Jeda sangat cepat (hampir instan)
                                                    end
                                                end
                                                
                                                -- Beri sedikit waktu untuk game mendaftarkan item ke tas sebelum balik
                                                task.wait(0.35) 
                                                
                                                if homeCFrame then
                                                    myChar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                                                    myChar:PivotTo(homeCFrame)
                                                    task.wait(0.6) 
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    
                    if not foundAnyTarget then task.wait(1) else task.wait(0.1) end
                end
            end)
        end
    end
})

AutoFarmSection:AddDropdown({
    "Target Rarities",
    "Pick specific block rarities the auto-collector should focus on.",
    true, 
    RarityList,
    ensureTable(UserSettings.TargetRarities),
    function(value)
        UserSettings.TargetRarities = value
        SaveConfig()
        activeRarityFilters = parseMultiSelect(value)
    end
})

-- ==============================================================================
-- TAB 3: AUTO (PLACE, OPEN, COLLECT, UPGRADE, SELL, PROGRESSION, TRADE)
-- ==============================================================================
local AutoPlaceSection = AutoTab:AddSection("Auto Place", false)

local autoPlaceActive = false
local autoOpenActive = false
local autoPlaceRarityFilters = parseMultiSelect(UserSettings.AutoPlaceRarities)

AutoPlaceSection:AddToggle({
    "Auto Place",
    "Equips blocks from your inventory and places them on your base slots.",
    UserSettings.AutoPlaceActive,
    function(value)
        UserSettings.AutoPlaceActive = value
        SaveConfig()
        autoPlaceActive = value

        if autoPlaceActive then
            task.spawn(function()
                local slotIndex = 1 
                while autoPlaceActive do
                    pcall(function()
                        local myChar = LocalPlayer.Character
                        local hum = myChar and myChar:FindFirstChild("Humanoid")
                        local backpackItems = LocalPlayer.Backpack:GetChildren()
                        
                        for _, item in ipairs(backpackItems) do
                            if not autoPlaceActive then break end
                            if item:IsA("Tool") then
                                local slimeUID = item:GetAttribute("slimeUID")
                                if slimeUID then
                                    local isTarget = false
                                    if table.find(autoPlaceRarityFilters, "All") then
                                        isTarget = true
                                    else
                                        for _, rarity in ipairs(autoPlaceRarityFilters) do
                                            if string.find(string.lower(item.Name), string.lower(rarity)) then
                                                isTarget = true
                                                break
                                            end
                                        end
                                    end

                                    if isTarget and hum then
                                        hum:EquipTool(item)
                                        task.wait(0.15) 
                                        PlaceRemote:FireServer(tostring(slotIndex), slimeUID)
                                        slotIndex = slotIndex + 1
                                        if slotIndex > MAX_BASE_SLOTS then slotIndex = 1 end
                                        task.wait(0.15) 
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

AutoPlaceSection:AddToggle({
    "Auto Open",
    "Automatically opens/breaks the blocks you placed on your base slots.",
    UserSettings.AutoOpenActive,
    function(value)
        UserSettings.AutoOpenActive = value
        SaveConfig()
        autoOpenActive = value

        if autoOpenActive then
            task.spawn(function()
                while autoOpenActive do
                    pcall(function()
                        for i = 1, MAX_BASE_SLOTS do
                            OpenRemote:FireServer(tostring(i))
                            task.wait(0.05)
                        end
                    end)
                    task.wait(0.3) 
                end
            end)
        end
    end
})

AutoPlaceSection:AddDropdown({
    "Target Rarities",
    "Select which block rarities to place and open.",
    true, 
    RarityList,
    ensureTable(UserSettings.AutoPlaceRarities),
    function(value)
        UserSettings.AutoPlaceRarities = value
        SaveConfig()
        autoPlaceRarityFilters = parseMultiSelect(value)
    end
})

AutoPlaceSection:AddButton({
    "Pickup All Player",
    "Instantly collects all placed blocks from slots 1 to 50 via remote.",
    "rbxassetid://10088146939", 
    function()
        pcall(function()
            for i = 1, 50 do
                PickupRemote:FireServer(tostring(i))
                task.wait(0.01) 
            end
        end)
    end
})

-- ==============================================================================
-- SECTION: AUTO COLLECT CASH
-- ==============================================================================
local AutoCollectSection = AutoTab:AddSection("Auto Collect Cash", false)
local autoCollectCashActive = false

AutoCollectSection:AddToggle({
    "Auto Collect Earnings",
    "Automatically loops slots 1 to 50 to collect generated cash.",
    UserSettings.AutoCollectCashActive,
    function(value)
        UserSettings.AutoCollectCashActive = value
        SaveConfig()
        autoCollectCashActive = value

        if autoCollectCashActive then
            task.spawn(function()
                while autoCollectCashActive do
                    pcall(function()
                        for i = 1, 50 do
                            CollectRemote:FireServer(tostring(i))
                            task.wait(0.02)
                        end
                    end)
                    task.wait(3) 
                end
            end)
        end
    end
})

-- ==============================================================================
-- SECTION: AUTO UPGRADE ALL PLAYER
-- ==============================================================================
local AutoUpgradeSection = AutoTab:AddSection("Auto Upgrade All Player", false)
local autoUpgradeActive = false
local maxUpgradeCount = tonumber(UserSettings.MaxUpgrade) or 50

AutoUpgradeSection:AddToggle({
    "Auto Upgrade",
    "Spams the upgrade remote up to the Max Upgrade limit for slots 1-50.",
    UserSettings.AutoUpgradeActive,
    function(value)
        UserSettings.AutoUpgradeActive = value
        SaveConfig()
        autoUpgradeActive = value

        if autoUpgradeActive then
            task.spawn(function()
                while autoUpgradeActive do
                    pcall(function()
                        for slot = 1, 50 do
                            if not autoUpgradeActive then break end
                            for upg = 1, maxUpgradeCount do
                                UpgradeRemote:FireServer(tostring(slot))
                                task.wait(0.02)
                            end
                        end
                    end)
                    task.wait(5)
                end
            end)
        end
    end
})

FuncsV3:Textbox(
    AutoUpgradeSection,
    "Max Upgrade Limit",
    "Set how many times to spam the upgrade button per slot (e.g. 50)",
    function(text)
        local num = tonumber(text)
        if num then
            maxUpgradeCount = num
            UserSettings.MaxUpgrade = tostring(num)
            SaveConfig()
        end
    end
)

-- ==============================================================================
-- SECTION: AUTO SELL
-- ==============================================================================
local AutoSellSection = AutoTab:AddSection("Auto Sell", false)
local autoSellActive = false
local autoSellRarityFilters = parseMultiSelect(UserSettings.AutoSellRarities)
local targetSellItem = type(UserSettings.AutoSellItem) == "table" and UserSettings.AutoSellItem[1] or UserSettings.AutoSellItem

AutoSellSection:AddToggle({
    "Enable Auto Sell",
    "Sells blocks from your backpack based on chosen rarity or specific item.",
    UserSettings.AutoSellActive,
    function(value)
        UserSettings.AutoSellActive = value
        SaveConfig()
        autoSellActive = value

        if autoSellActive then
            task.spawn(function()
                while autoSellActive do
                    pcall(function()
                        for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                            if not autoSellActive then break end
                            
                            if item:IsA("Tool") then
                                local slimeUID = item:GetAttribute("slimeUID")
                                if slimeUID then
                                    local isTarget = false
                                    
                                    if targetSellItem ~= "None" and item.Name == targetSellItem then
                                        isTarget = true
                                    end

                                    if not isTarget then
                                        if table.find(autoSellRarityFilters, "All") then
                                            isTarget = true
                                        else
                                            for _, rarity in ipairs(autoSellRarityFilters) do
                                                if rarity ~= "None" and string.find(string.lower(item.Name), string.lower(rarity)) then
                                                    isTarget = true
                                                    break
                                                end
                                            end
                                        end
                                    end

                                    if isTarget then
                                        SellRemote:FireServer(slimeUID)
                                        task.wait(0.1) 
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

AutoSellSection:AddDropdown({
    "Filter by Rarity",
    "Select block rarities you want to auto sell.",
    true, 
    RarityList,
    ensureTable(UserSettings.AutoSellRarities),
    function(value)
        UserSettings.AutoSellRarities = value
        SaveConfig()
        autoSellRarityFilters = parseMultiSelect(value)
    end
})

local InventoryDropdownSell = AutoSellSection:AddDropdown({
    "Select Specific Block",
    "Select a specific block from your inventory to sell.",
    false, 
    getBackpackItems(),
    ensureTable(UserSettings.AutoSellItem),
    function(value)
        UserSettings.AutoSellItem = value
        SaveConfig()
        targetSellItem = type(value) == "table" and value[1] or value
    end
})

AutoSellSection:AddButton({
    "Refresh Inventory List",
    "Updates the dropdown list above with your current backpack items.",
    "rbxassetid://10088146939", 
    function()
        local latestItems = getBackpackItems()
        pcall(function() InventoryDropdownSell:SetOptions(latestItems) end)
        pcall(function() InventoryDropdownSell:Refresh(latestItems) end)
    end
})

-- ==============================================================================
-- SECTION: AUTO TRADE (GIFT SLIME)
-- ==============================================================================
local AutoTradeSection = AutoTab:AddSection("Auto Trade", false)
local autoTradeActive = false
local targetTradePlayer = type(UserSettings.TargetTradePlayer) == "table" and UserSettings.TargetTradePlayer[1] or UserSettings.TargetTradePlayer
local targetTradeItemsList = parseMultiSelect(UserSettings.TargetTradeItem)

AutoTradeSection:AddToggle({
    "Enable Auto Trade",
    "Continuously sends the selected block(s) to the chosen player silently.",
    UserSettings.AutoTradeActive,
    function(value)
        UserSettings.AutoTradeActive = value
        SaveConfig()
        autoTradeActive = value

        if autoTradeActive then
            task.spawn(function()
                while autoTradeActive do
                    pcall(function()
                        if targetTradePlayer ~= "None" then
                            local tPlayer = Players:FindFirstChild(targetTradePlayer)
                            local myChar = LocalPlayer.Character
                            local hum = myChar and myChar:FindFirstChild("Humanoid")
                            
                            if tPlayer and hum then
                                local backpackItems = LocalPlayer.Backpack:GetChildren()
                                
                                for _, item in ipairs(backpackItems) do
                                    if not autoTradeActive then break end
                                    
                                    if item:IsA("Tool") then
                                        local isTarget = false
                                        
                                        if table.find(targetTradeItemsList, "All") then
                                            isTarget = true
                                        else
                                            for _, tItem in ipairs(targetTradeItemsList) do
                                                if tItem ~= "None" and item.Name == tItem then
                                                    isTarget = true
                                                    break
                                                end
                                            end
                                        end

                                        if isTarget then
                                            local slimeUID = item:GetAttribute("slimeUID")
                                            if slimeUID then
                                                hum:EquipTool(item)
                                                task.wait(0.15)
                                                
                                                GiftRemote:InvokeServer(tPlayer.Name, slimeUID)
                                                task.wait(0.3) 
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

local PlayerTradeDropdown = AutoTradeSection:AddDropdown({
    "Target Player",
    "Select a player from the server to trade with (Single Select).",
    false, 
    getPlayerNames(),
    ensureTable(UserSettings.TargetTradePlayer),
    function(value)
        UserSettings.TargetTradePlayer = value
        SaveConfig()
        targetTradePlayer = type(value) == "table" and value[1] or value
    end
})

AutoTradeSection:AddButton({
    "Refresh Player List",
    "Updates the player list above.",
    "rbxassetid://10088146939", 
    function()
        local latestPlayers = getPlayerNames()
        pcall(function() PlayerTradeDropdown:SetOptions(latestPlayers) end)
        pcall(function() PlayerTradeDropdown:Refresh(latestPlayers) end)
    end
})

local InventoryTradeDropdown = AutoTradeSection:AddDropdown({
    "Select Block(s) to Trade",
    "Select multiple blocks from your inventory to send.",
    true,
    getBackpackItems(),
    ensureTable(UserSettings.TargetTradeItem),
    function(value)
        UserSettings.TargetTradeItem = value
        SaveConfig()
        targetTradeItemsList = parseMultiSelect(value)
    end
})

AutoTradeSection:AddButton({
    "Refresh Inventory List",
    "Updates the inventory list above.",
    "rbxassetid://10088146939", 
    function()
        local latestItems = getBackpackItems()
        pcall(function() InventoryTradeDropdown:SetOptions(latestItems) end)
        pcall(function() InventoryTradeDropdown:Refresh(latestItems) end)
    end
})

-- ==============================================================================
-- SECTION: PROGRESSION
-- ==============================================================================
local ProgressionSection = AutoTab:AddSection("Progression", false)
local autoCarryActive = false
local autoSpeedActive = false
local autoRebirthActive = false

ProgressionSection:AddToggle({
    "Auto Carry Upgrade",
    "Continuously upgrades your carry limit.",
    UserSettings.AutoCarryActive,
    function(value)
        UserSettings.AutoCarryActive = value
        SaveConfig()
        autoCarryActive = value

        if autoCarryActive then
            task.spawn(function()
                while autoCarryActive do
                    pcall(function() CarryRemote:FireServer() end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

ProgressionSection:AddToggle({
    "Auto Speed/Jump Upgrade",
    "Continuously buys the speed upgrade (Arg: 3).",
    UserSettings.AutoSpeedActive,
    function(value)
        UserSettings.AutoSpeedActive = value
        SaveConfig()
        autoSpeedActive = value

        if autoSpeedActive then
            task.spawn(function()
                while autoSpeedActive do
                    pcall(function() SpeedRemote:FireServer(3) end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

ProgressionSection:AddToggle({
    "Auto Rebirth",
    "Automatically rebirths whenever possible.",
    UserSettings.AutoRebirthActive,
    function(value)
        UserSettings.AutoRebirthActive = value
        SaveConfig()
        autoRebirthActive = value

        if autoRebirthActive then
            task.spawn(function()
                while autoRebirthActive do
                    pcall(function() RebirthRemote:FireServer() end)
                    task.wait(3)
                end
            end)
        end
    end
})

-- ==============================================================================
-- TAB 4: MISC (ANTI AFK & FPS BOOST)
-- ==============================================================================
local MiscSection = MiscTab:AddSection("Miscellaneous", false)
local antiAfkActive = false
local idleConnection = nil

MiscSection:AddToggle({
    "Anti AFK",
    "Simulates user input to prevent being kicked for idling (20 mins).",
    UserSettings.AntiAFKActive or false,
    function(value)
        UserSettings.AntiAFKActive = value
        SaveConfig()
        antiAfkActive = value
        
        if antiAfkActive then
            if not idleConnection then
                idleConnection = LocalPlayer.Idled:Connect(function()
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
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

local FPSBoostSection = MiscTab:AddSection("FPS Boost", false)
local fpsBoostToggled = false

FPSBoostSection:AddButton({
    "Activate FPS Boost",
    "Removes shadows, textures, and particles to reduce lag. (Cannot be undone without rejoining)",
    "rbxassetid://10088146939",
    function()
        if not fpsBoostToggled then
            fpsBoostToggled = true
            pcall(function()
                local Lighting = game:GetService("Lighting")
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
                Lighting.ShadowSoftness = 0
                
                if sethiddenproperty then
                    pcall(function() sethiddenproperty(Lighting, "Technology", 2) end)
                end
                
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and not v:IsA("MeshPart") then
                        v.Material = Enum.Material.Plastic
                        v.Reflectance = 0
                    elseif v:IsA("Decal") or (v:IsA("Texture") and v.Texture ~= "http://www.roblox.com/asset/?id=1818") then
                        v.Transparency = 1
                    elseif v:IsA("ParticleEmitter") then
                        v.Lifetime = NumberRange.new(0) 
                    elseif v:IsA("Trail") then
                        v.Lifetime = 0 
                    elseif v:IsA("Explosion") then
                        v.BlastPressure = 1
                        v.BlastRadius = 1
                    end
                end
            end)
        end
    end
})
