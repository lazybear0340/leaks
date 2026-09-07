--unobfuscated


local FuncsV3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrtokyo/refs/heads/main/FuncsV3"))()
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrlibrary/refs/heads/main/tokyo-ontop"))()

local Window = Speed_Library:CreateWindow({
    "Tokyo",
    "+1 Cut Grass Adventure",
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local KnitServices = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.2"):WaitForChild("knit"):WaitForChild("Services")

-- ==============================================================================
-- AUTO SAVE SYSTEM (JSON)
-- ==============================================================================
local ConfigFile = "cutgras_tokyo.json"
local UIConfig = {}

if isfile and isfile(ConfigFile) then
    local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
    if success and type(decoded) == "table" then
        UIConfig = decoded
    end
end

local function SaveToJSON(key, value)
    UIConfig[key] = value
    if writefile then
        pcall(function()
            writefile(ConfigFile, HttpService:JSONEncode(UIConfig))
        end)
    end
end

-- Variables for Auto Farm
local autoFarmActive = false
local targetRarity = {"None"}
local targetItem = {"None"}

-- Variables for Misc & Progression
local autoClickActive = false
local autoUpgradeActive = false
local selectedUpgrade = {"None"}
local autoRebirthActive = false
local antiAfkActive = false

-- Variables for Shop
local selectedCutter = {"None"}
local selectedAura = {"None"}
local autoBuyCutterActive = false
local autoBuyBestCutterActive = false
local autoBuyAuraActive = false
local autoBuyBestAuraActive = false

-- ==============================================================================
-- MENGAMBIL LIST CUTTER & AURA OTOMATIS DARI EXPLORER
-- ==============================================================================
local CutterList = {
    "None", "Abyssal Claw", "Axe", "Big Sword", "Black Knife", "Blood Scythe", 
    "Briliant Spear", "Broken Sword", "Buster Blade", "Butcher Knife", 
    "Chainsaw", "Cosmic Sword", "Crimson Wingblade", "Dawnreaper Pick", 
    "Double Blade", "Frostcore Scepter", "Gold Machete", "Halberd", 
    "Katana", "Katana Dark", "Knife"
}

task.spawn(function()
    pcall(function()
        for _, v in pairs(ReplicatedStorage:WaitForChild("Weapons", 5):GetChildren()) do
            if (v:IsA("Model") or v:IsA("Folder")) and not table.find(CutterList, v.Name) then
                table.insert(CutterList, v.Name)
            end
        end
    end)
end)

local AuraList = {
    "None", "Blue_Aura", "Celestial_Aura", "Divine_Aura", "Eternal_Aura", 
    "Godly_Aura", "Green_Aura", "Mythic_Aura", "Purple_Aura", 
    "Red_Aura", "Transcendent_Aura"
}

task.spawn(function()
    pcall(function()
        for _, v in pairs(ReplicatedStorage:WaitForChild("Auras", 5):GetChildren()) do
            if (v:IsA("Model") or v:IsA("Folder")) and not table.find(AuraList, v.Name) then
                table.insert(AuraList, v.Name)
            end
        end
    end)
end)

local UpgradeList = {"None", "Range", "Agility", "Capacity", "Mobility"}
local UpgradeRemotes = {
    ["Range"] = "AttackRangeButtonClicked",
    ["Agility"] = "AttackSpeedButtonClicked",
    ["Capacity"] = "CarryButtonClicked",
    ["Mobility"] = "SpeedButtonClicked"
}

-- FUNGSI PARSE MULTI SELECT
local function parseMultiSelect(val)
    local arr = {}
    if type(val) == "table" then
        for k, v in pairs(val) do
            if type(k) == "number" and type(v) == "string" then 
                table.insert(arr, v)
            elseif type(k) == "string" and v == true then 
                table.insert(arr, k)
            end
        end
    elseif type(val) == "string" and val ~= "" then
        table.insert(arr, val)
    end
    if #arr == 0 then return {"None"} end
    return arr
end

-- ==============================================================================
-- FUNGSI CEK TAS (100% ANTI LAG)
-- ==============================================================================
local function isInventoryFull()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    
    local mainScreen = playerGui:FindFirstChild("MainScreenGui")
    if not mainScreen then return false end
    
    local currencies = mainScreen:FindFirstChild("Currencies")
    if not currencies then return false end
    
    local backpack = currencies:FindFirstChild("Backpack")
    if not backpack then return false end
    
    local valueLabel = backpack:FindFirstChild("Value")
    if valueLabel and valueLabel:IsA("TextLabel") then
        local current, max = string.match(valueLabel.Text, "^(%d+)/(%d+)$")
        if current and max then
            return tonumber(current) >= tonumber(max)
        end
    end
    
    return false
end

-- ==============================================================================
-- FUNGSI AUTO RETURN KE BASE
-- ==============================================================================
local function returnToBaseAndSellAll()
    pcall(function()
        KnitServices:WaitForChild("BaseTeleportService"):WaitForChild("RF"):WaitForChild("TeleportToSpawn"):InvokeServer()
        task.wait(0.5) 
        KnitServices:WaitForChild("LootInventoryService"):WaitForChild("RF"):WaitForChild("ResetBackpackLoadAtBase"):InvokeServer()
        task.wait(0.5)
        KnitServices:WaitForChild("GrassService"):WaitForChild("RE"):WaitForChild("ResetPlayerGrassState"):FireServer()
        task.wait(0.5)
    end)
end

-- ==============================================================================
-- ANTI AFK HANDLER
-- ==============================================================================
local VirtualInputManager = game:GetService("VirtualInputManager")

LocalPlayer.Idled:Connect(function()
    if antiAfkActive then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

task.spawn(function()
    while task.wait(120) do 
        if antiAfkActive then
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end
end)

task.spawn(function()
    pcall(function()
        local CoreGui = game:GetService("CoreGui")
        local setScriptable = sethiddenproperty or set_hidden_property or set_hidden_prop
        if setScriptable then
            CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if antiAfkActive and child.Name == "ErrorPrompt" then
                    child:Destroy()
                end
            end)
        end
    end)
end)

-- ==============================================================================
-- LIST RARITY & ITEM
-- ==============================================================================
local RarityList = {
    "None", "Common", "Uncommon", "Rare", "Epic", "Legendary",
    "Mythic", "Secret", "Godly", "Divine", "Celestial",
    "Eternal", "Transcendent", "Cosmic", "Ascendant", "Primordial",
    "Empyrean", "Omniversal", "Singularity"
}

local ItemList = {
    "None", "Button", "Rusty Nail", "Old Coin", "Pocket Watch", 
    "Copper Gear", "Silver Spoon", "Medallion", "Broken Compass", 
    "Dew Crystal", "Key", "Moon Flower", "Horseshoe", 
    "Violet Shard", "Royal Brooch", "Flaming Ring", "Ancient Goblet", 
    "Golden Feather", "Dragon Tooth", "Obelisk", "Sun Idol", 
    "Black Crystal", "Hourglass", "Retro Radio", "Ruby Leaf", 
    "Clover Prism", "Sealed Scroll", "Tiny Portal", "Angel Wing", 
    "Comet Heart", "Dawn Diadem", "Celestial Star", "Moon Fragment", 
    "Living Star", "Amber Beetle", "Shaman Mask", "Eternal Flower", 
    "Universe Core", "Divine Seal", "Light Blade", "Chest", 
    "Nebula Rose", "Wishstone", "Genesis Leaf", "Starlight Dandelion",
    "Star Nectar", "Aurora Egg", "Rainbow Snail", "Sunfire Orb",
    "Seraph Bell", "Storm Seed", "Rune Mushroom", "Celestial Antler",
    "Spider Charm", "Spirit Feather", "Chrono Moth", "Moondew Pearl",
    "Fate Dice", "Rift Scythe", "Nova Gauntlet", "Astral Map",
    "Moonfish Idol", "Zero Compass", "Star Sail", "Phoenix Harp",
    "Rebirth Mask", "Soul Anchor", "Infinity Blade", "Evernight Owl",
    "Timewheel", "Titan Hammer", "Origin Chalice", "Leviathan Scale",
    "Skyforge Anvil", "Genesis Gate", "Void Telescope", "Meteor Boots",
    "Orbit Drum", "Nebula Parasol", "Starcatcher Net", "Lunar Knight",
    "Verdant Shield", "Rebirth Bow", "Spirit Pagoda", "Chrono Codex",
    "Emerald Warhorn", "Guardian Scarab", "Abyss Trident", "Dawn Throne",
    "Colossus Helm", "World Cauldron", "Dragonbone Totem", "Reality Loom"
}

-- ==============================================================================
-- TABS (SIDEBAR)
-- ==============================================================================
local InfoTab = Window:CreateTab({ ["Name"] = "Info", ["Icon"] = "rbxthumb://type=Asset&id=17829948098&w=150&h=150" })
local MainTab = Window:CreateTab({ ["Name"] = "Main", ["Icon"] = "rbxthumb://type=Asset&id=170940874&w=150&h=150" })
local AutoTab = Window:CreateTab({ ["Name"] = "Auto", ["Icon"] = "rbxthumb://type=Asset&id=16326604165&w=150&h=150" })
local ShopTab = Window:CreateTab({ ["Name"] = "Shop", ["Icon"] = "rbxthumb://type=Asset&id=1570658638&w=150&h=150" })
local MiscTab = Window:CreateTab({ ["Name"] = "Misc", ["Icon"] = "rbxthumb://type=Asset&id=7059346386&w=150&h=150" })

-- ==============================================================================
-- TAB INFO
-- ==============================================================================
local InfoSection = InfoTab:AddSection("Information", true)

InfoSection:AddParagraph({
    "Welcome to Tokyo Hub!",
    "Developer: PTR"
})

InfoSection:AddParagraph({
    "Script Features",
    "Experience the ultimate automation! Features include Smart Auto Farm, 100% Precise Aura Clicker, Intelligent Auto Sell with Filters, and a seamless Auto-Save system that remembers your settings."
})

-- ==============================================================================
-- TAB MAIN (AUTO FARM)
-- ==============================================================================
local AutoFarmSection = MainTab:AddSection("Auto Farm", false)

AutoFarmSection:AddToggle({
    "Enable Auto Pickup",
    "Automatically teleport and pick up targeted items",
    UIConfig["Enable Auto Pickup"] or false,
    function(value)
        autoFarmActive = value
        SaveToJSON("Enable Auto Pickup", value)
        
        if autoFarmActive then
            task.spawn(function()
                while autoFarmActive do
                    pcall(function()
                        if isInventoryFull() then
                            returnToBaseAndSellAll()
                            task.wait(1)
                        end
                        
                        local filterNames = parseMultiSelect(targetItem)
                        local filterRarities = parseMultiSelect(targetRarity)
                        
                        local bypassName = true
                        for _, v in ipairs(filterNames) do if v ~= "None" then bypassName = false break end end
                        
                        local bypassRarity = true
                        for _, v in ipairs(filterRarities) do if v ~= "None" then bypassRarity = false break end end
                        
                        local myChar = LocalPlayer.Character
                        local zonesFolder = workspace:FindFirstChild("Zones") 
                        
                        if zonesFolder and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            for _, prompt in pairs(zonesFolder:GetDescendants()) do
                                if not autoFarmActive then break end
                                if isInventoryFull() then break end
                                
                                if prompt:IsA("ProximityPrompt") then
                                    local actionText = string.lower(tostring(prompt.ActionText))
                                    if string.find(actionText, "pickup") or actionText == "" then
                                        local itemModel = prompt:FindFirstAncestorOfClass("Model")
                                        if itemModel then
                                            local objName = string.lower(itemModel.Name)
                                            local isNameMatch = bypassName
                                            
                                            if not isNameMatch then
                                                for _, selectedName in ipairs(filterNames) do
                                                    if selectedName ~= "None" then
                                                        local formatUnder = string.lower(string.gsub(selectedName, " ", "_"))
                                                        if string.find(objName, formatUnder, 1, true) then 
                                                            isNameMatch = true break 
                                                        end
                                                    end
                                                end
                                            end

                                            local isRarityMatch = bypassRarity
                                            if isNameMatch and not isRarityMatch then
                                                for _, ui in pairs(itemModel:GetDescendants()) do
                                                    if ui:IsA("TextLabel") or ui:IsA("TextButton") then
                                                        local rawText = string.lower(string.gsub(tostring(ui.Text), "<[^>]+>", ""))
                                                        for _, r in ipairs(filterRarities) do
                                                            if r ~= "None" then
                                                                local targetRarity = string.lower(r)
                                                                if rawText == targetRarity or string.find(rawText, "%f[%w]" .. targetRarity .. "%f[%W]") then
                                                                    isRarityMatch = true
                                                                    break
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if isRarityMatch then break end
                                                end
                                            end

                                            -- =========================================
                                            -- HARDBLOCK KHUSUS GODLY
                                            -- =========================================
                                            if isNameMatch and isRarityMatch then
                                                local godlyAllowed = false
                                                for _, v in ipairs(filterRarities) do
                                                    if string.lower(v) == "godly" then godlyAllowed = true break end
                                                end

                                                if not godlyAllowed then
                                                    local isGodlyItem = false
                                                    for _, ui in pairs(itemModel:GetDescendants()) do
                                                        if ui:IsA("TextLabel") or ui:IsA("TextButton") then
                                                            local rawText = string.lower(string.gsub(tostring(ui.Text), "<[^>]+>", ""))
                                                            if string.find(rawText, "godly") then
                                                                isGodlyItem = true
                                                                break
                                                            end
                                                        end
                                                    end
                                                    -- JIKA INI ITEM GODLY TAPI TIDAK DICENTANG, BATALKAN!
                                                    if isGodlyItem then
                                                        isNameMatch = false
                                                        isRarityMatch = false
                                                    end
                                                end
                                            end
                                            -- =========================================

                                            if isNameMatch and isRarityMatch then
                                                local targetPart = prompt.Parent
                                                if targetPart:IsA("Attachment") then targetPart = targetPart.Parent end
                                                
                                                if targetPart:IsA("BasePart") then
                                                    myChar.HumanoidRootPart.CFrame = targetPart.CFrame
                                                    myChar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                                                    task.wait(0.2)
                                                    prompt.HoldDuration = 0 
                                                    fireproximityprompt(prompt)
                                                    task.wait(0.4) 
                                                end
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

AutoFarmSection:AddDropdown({ 
    "Target Rarity", 
    "Select the rarities you want to farm", 
    true, 
    RarityList, 
    UIConfig["Target Rarity"] or {"None"}, 
    function(value) 
        targetRarity = value 
        SaveToJSON("Target Rarity", value)
    end 
})

AutoFarmSection:AddDropdown({ 
    "Target Item", 
    "Select the specific items you want to farm", 
    true, 
    ItemList, 
    UIConfig["Target Item"] or {"None"}, 
    function(value) 
        targetItem = value 
        SaveToJSON("Target Item", value)
    end 
})

-- ==============================================================================
-- TAB AUTO (TRAIN, UPGRADE, REBIRTH)
-- ==============================================================================
local AutoTrainSection = AutoTab:AddSection("Auto Train", false)

AutoTrainSection:AddToggle({
    "Enable Auto Click",
    "Automatically click to gain strength",
    UIConfig["Enable Auto Click"] or false,
    function(value)
        autoClickActive = value
        SaveToJSON("Enable Auto Click", value)
        
        if autoClickActive then
            task.spawn(function()
                while autoClickActive do
                    pcall(function()
                        KnitServices:WaitForChild("StrengthService"):WaitForChild("RE"):WaitForChild("ClickRequested"):FireServer()
                    end)
                    task.wait(0.05) 
                end
            end)
        end
    end
})

local AutoProgressSection = AutoTab:AddSection("Auto Progression", false)

AutoProgressSection:AddDropdown({
    "Select Upgrade",
    "Select stats to automatically upgrade",
    true, 
    UpgradeList,
    UIConfig["Select Upgrade"] or {"None"},
    function(value) 
        selectedUpgrade = value 
        SaveToJSON("Select Upgrade", value)
    end
})

AutoProgressSection:AddToggle({
    "Enable Auto Upgrade",
    "Automatically upgrade the selected stats",
    UIConfig["Enable Auto Upgrade"] or false,
    function(value)
        autoUpgradeActive = value
        SaveToJSON("Enable Auto Upgrade", value)
        
        if autoUpgradeActive then
            task.spawn(function()
                while autoUpgradeActive do
                    local targets = parseMultiSelect(selectedUpgrade)
                    for _, target in ipairs(targets) do
                        pcall(function()
                            if target and target ~= "None" and UpgradeRemotes[target] then
                                KnitServices:WaitForChild("UpgradesService"):WaitForChild("RE"):WaitForChild(UpgradeRemotes[target]):FireServer()
                            end
                        end)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

AutoProgressSection:AddToggle({
    "Enable Auto Rebirth",
    "Automatically rebirth when requirements are met",
    UIConfig["Enable Auto Rebirth"] or false,
    function(value)
        autoRebirthActive = value
        SaveToJSON("Enable Auto Rebirth", value)
        
        if autoRebirthActive then
            task.spawn(function()
                while autoRebirthActive do
                    pcall(function()
                        KnitServices:WaitForChild("RebirtService"):WaitForChild("RE"):WaitForChild("RebirthButtonClicked"):FireServer()
                    end)
                    task.wait(5)
                end
            end)
        end
    end
})

-- ==============================================================================
-- TAB SHOP
-- ==============================================================================
local CutterShopSection = ShopTab:AddSection("Cutter Shop", false)

CutterShopSection:AddDropdown({
    "Select Cutter",
    "Select Cutters to auto-buy",
    true, 
    CutterList,
    UIConfig["Select Cutter"] or {"None"},
    function(value) 
        selectedCutter = value 
        SaveToJSON("Select Cutter", value)
    end
})

CutterShopSection:AddToggle({
    "Auto Buy Selected Cutter",
    "Automatically buy the selected Cutters",
    UIConfig["Auto Buy Selected Cutter"] or false,
    function(value)
        autoBuyCutterActive = value
        SaveToJSON("Auto Buy Selected Cutter", value)
        
        if autoBuyCutterActive then
            task.spawn(function()
                while autoBuyCutterActive do
                    local targets = parseMultiSelect(selectedCutter)
                    for _, target in ipairs(targets) do
                        pcall(function()
                            if target and target ~= "None" then
                                KnitServices:WaitForChild("CuttersShopService"):WaitForChild("RF"):WaitForChild("BuyCutter"):InvokeServer(target)
                            end
                        end)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

CutterShopSection:AddToggle({
    "Auto Buy Best Cutter",
    "Attempt to buy all available Cutters",
    UIConfig["Auto Buy Best Cutter"] or false,
    function(value)
        autoBuyBestCutterActive = value
        SaveToJSON("Auto Buy Best Cutter", value)
        
        if autoBuyBestCutterActive then
            task.spawn(function()
                while autoBuyBestCutterActive do
                    for _, cutter in ipairs(CutterList) do
                        if cutter ~= "None" then
                            pcall(function()
                                KnitServices:WaitForChild("CuttersShopService"):WaitForChild("RF"):WaitForChild("BuyCutter"):InvokeServer(cutter)
                            end)
                        end
                        if not autoBuyBestCutterActive then break end
                    end
                    task.wait(3)
                end
            end)
        end
    end
})

local AuraShopSection = ShopTab:AddSection("Aura Shop", false)

AuraShopSection:AddDropdown({
    "Select Aura",
    "Select Auras to auto-buy",
    true, 
    AuraList,
    UIConfig["Select Aura"] or {"None"},
    function(value) 
        selectedAura = value 
        SaveToJSON("Select Aura", value)
    end
})

AuraShopSection:AddToggle({
    "Auto Buy Selected Aura",
    "Automatically buy the selected Auras",
    UIConfig["Auto Buy Selected Aura"] or false,
    function(value)
        autoBuyAuraActive = value
        SaveToJSON("Auto Buy Selected Aura", value)
        
        if autoBuyAuraActive then
            task.spawn(function()
                while autoBuyAuraActive do
                    local targets = parseMultiSelect(selectedAura)
                    for _, target in ipairs(targets) do
                        pcall(function()
                            if target and target ~= "None" then
                                local formattedAura = string.gsub(target, "_", "")
                                KnitServices:WaitForChild("AuraService"):WaitForChild("RF"):WaitForChild("BuyOrToggleAura"):InvokeServer(formattedAura)
                            end
                        end)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

AuraShopSection:AddToggle({
    "Auto Buy Best Aura",
    "Attempt to buy all available Auras",
    UIConfig["Auto Buy Best Aura"] or false,
    function(value)
        autoBuyBestAuraActive = value
        SaveToJSON("Auto Buy Best Aura", value)
        
        if autoBuyBestAuraActive then
            task.spawn(function()
                while autoBuyBestAuraActive do
                    for _, aura in ipairs(AuraList) do
                        if aura ~= "None" then
                            pcall(function()
                                local formattedAura = string.gsub(aura, "_", "")
                                KnitServices:WaitForChild("AuraService"):WaitForChild("RF"):WaitForChild("BuyOrToggleAura"):InvokeServer(formattedAura)
                            end)
                        end
                        if not autoBuyBestAuraActive then break end
                    end
                    task.wait(3)
                end
            end)
        end
    end
})

-- ==============================================================================
-- TAB MISC
-- ==============================================================================
local MiscSection = MiscTab:AddSection("Miscellaneous", false)

MiscSection:AddToggle({
    "Enable Anti-AFK",
    "Prevent getting kicked for idling 20 minutes",
    UIConfig["Enable Anti-AFK"] or false,
    function(value) 
        antiAfkActive = value 
        SaveToJSON("Enable Anti-AFK", value)
    end
})

MiscSection:AddButton({ 
    "Boost FPS (Low Graphics)", 
    "Remove textures and shadows to boost performance", 
    "rbxassetid://10088146939", 
    function()
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.ShadowSoftness = 0
            
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0, 0)
                end
            end
        end)
    end 
})
