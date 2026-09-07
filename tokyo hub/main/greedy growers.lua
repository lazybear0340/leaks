--unobfuscated


local FuncsV3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrtokyo/refs/heads/main/FuncsV3"))()
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrlibrary/refs/heads/main/tokyo-ontop"))()

local Window = Speed_Library:CreateWindow({
    "Tokyo",
    "Greedy Growers",
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

-- ==============================================================================
-- GLOBAL ACTION LOCK (ANTI TABRAKAN)
-- ==============================================================================
_G.IsActionBusy = false 

-- ==============================================================================
-- LISTS (DYNAMIC & STATIC)
-- ==============================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local PlayerID = tostring(Player.UserId)

local SeedList = {"None"}
local successSeed, seedsFolder = pcall(function() return ReplicatedStorage.Assets.Greedy.Seeds end)
if successSeed and seedsFolder then
    for _, seed in pairs(seedsFolder:GetChildren()) do table.insert(SeedList, seed.Name) end
end

local FruitList = {"None"}
local successFruit, fruitsFolder = pcall(function() return ReplicatedStorage.Assets.Greedy.FruitModels end)
if successFruit and fruitsFolder then
    for _, fruit in pairs(fruitsFolder:GetChildren()) do table.insert(FruitList, fruit.Name) end
end

-- Bikin list gabungan khusus buat Auto Sell (Biar bisa jual Bibit atau Buah)
local SellableList = {"None"}
for _, v in ipairs(SeedList) do if v ~= "None" then table.insert(SellableList, v) end end
for _, v in ipairs(FruitList) do if v ~= "None" and not table.find(SellableList, v) then table.insert(SellableList, v) end end

local RarityList = {"None", "Common", "Rare", "Epic", "Legendary", "Mythic", "Celestial", "Secret", "Divine", "Ethereal", "Godly", "Ancient", "Rainbow", "Transcendent", "Majestic"}
local PlantList = {"None", "Apple Tree", "Astral Tree", "Avocado Tree", "Banana Tree", "Blooming Tree", "Cherry Tree", "Coconut Tree", "Diamond Tree", "DragonFruit Tree", "Elder Tree", "Fig Tree", "Glowing Tree", "Glowshroom Tree", "Inferno Tree", "Lemon Tree", "Magic Tree", "Mango Tree", "Money Tree", "Mushroom Tree", "Oak Tree", "Orange Tree", "Peach Tree", "Pine Tree", "Pizza Tree", "Prismatic Tree", "Spirit Tree", "Starfruit Tree", "Void Tree"}
local PickupFruitList = {"None", "Acorn", "Apple", "AstralFruit", "Avocado", "Banana", "Blooming", "Cherry", "Coconut", "Diamond", "DragonFruit", "ElderFruit", "Fig", "GlowingFruit", "Glowshroom", "InfernoFruit", "Lemon", "MagicFruit", "Mango", "MoneyFruit", "Mushroom", "Orange", "Peach", "Pinecone", "Pizza", "PrismaticFruit", "SpiritFruit", "Starfruit", "Void"}
local MutationList = {"None", "Charged", "Cosmic", "Dewy", "Dusty", "Frosted", "Golden", "Infested", "Ivory", "Radioactive", "Scaled", "Shocked", "Slimy"}
local PetsShopList = {"None", "EggCommon", "EggEpic", "EggLegendary", "EggMajestic", "EggMythic", "EggRare"}
local FertilizerList = {"None", "Basic", "Better", "Premium", "Super", "Magic"}
local PetList = {"None", "Dog", "Cat", "Bunny"}
local MarketList = {"None", "Watering Can", "Hoe"}
local FurnitureList = {"None", "Wooden Fence", "Scarecrow"}
local GearList = {"None", "Speed Boots", "Lucky Hat"}

-- ==============================================================================
-- TABS (SIDEBAR)
-- ==============================================================================
local MainTab = Window:CreateTab({ ["Name"] = "Main", ["Icon"] = "rbxthumb://type=Asset&id=170940874&w=150&h=150" })
local AutoTab = Window:CreateTab({ ["Name"] = "Auto", ["Icon"] = "rbxthumb://type=Asset&id=16326604165&w=150&h=150" })
local ShopTab = Window:CreateTab({ ["Name"] = "Shop", ["Icon"] = "rbxthumb://type=Asset&id=1570658638&w=150&h=150" })
local MiscTab = Window:CreateTab({ ["Name"] = "Misc", ["Icon"] = "rbxthumb://type=Asset&id=7059346386&w=150&h=150" })

-- ==============================================================================
-- TAB 1: MAIN
-- ==============================================================================
local FarmSection = MainTab:AddSection("Buy Seed", false)
local SelectedBuySeeds = {"None"}
local SelectedBuyRarities = {"None"}

FarmSection:AddDropdown({"Auto Buy Seed", "Select multiple seeds to automatically buy", true, SeedList, {"None"}, function(v) SelectedBuySeeds = v end})
FarmSection:AddDropdown({"Auto Buy Seed By Rarity", "Select multiple seed rarities to buy", true, RarityList, {"None"}, function(v) SelectedBuyRarities = v end})

FarmSection:AddToggle({"Enable Auto Buy Seed", "Toggle to automatically buy the selected seed or rarity", false, function(value)
    _G.AutoBuySeed = value
    if _G.AutoBuySeed then
        task.spawn(function()
            while _G.AutoBuySeed do
                task.wait(0.5) 
                pcall(function()
                    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    local conveyor = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("ConveyorSeeds")
                    if conveyor then
                        for _, prompt in ipairs(conveyor:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") and string.find(string.lower(prompt.ActionText), "buy") then
                                local seedPart = prompt.Parent
                                if seedPart and seedPart:IsA("BasePart") then
                                    local isTarget = false
                                    
                                    if not table.find(SelectedBuySeeds, "None") and #SelectedBuySeeds > 0 then
                                        local currentName = string.lower(string.gsub(string.gsub(tostring(seedPart:GetAttribute("SeedType") or ""), "seed", ""), " ", ""))
                                        for _, s in ipairs(SelectedBuySeeds) do
                                            local targetName = string.lower(string.gsub(string.gsub(tostring(s), "seed", ""), " ", ""))
                                            if currentName == targetName then isTarget = true; break end
                                        end
                                    end
                                    
                                    if not isTarget and not table.find(SelectedBuyRarities, "None") and #SelectedBuyRarities > 0 then
                                        local currentRarity = string.lower(tostring(seedPart:GetAttribute("Rarity") or ""))
                                        for _, r in ipairs(SelectedBuyRarities) do
                                            if currentRarity == string.lower(r) then isTarget = true; break end
                                        end
                                    end
                                    
                                    if isTarget then
                                        repeat task.wait(0.1) until not _G.IsActionBusy
                                        _G.IsActionBusy = true
                                        
                                        root.CFrame = seedPart.CFrame + Vector3.new(0, 3, 0)
                                        task.wait(0.2) 
                                        fireproximityprompt(prompt, 1, true)
                                        task.wait(0.5) 
                                        
                                        _G.IsActionBusy = false
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end})

local AutoPlantSection = MainTab:AddSection("Auto Plant", false)
local SelectedPlantSeeds = {"None"}
local SelectedFertilizer = "None"

-- [FIX] Fertilizer sekarang Single Select (Argumen = false)
AutoPlantSection:AddDropdown({"Select Seed", "Choose multiple seeds to automatically plant", true, SeedList, {"None"}, function(v) SelectedPlantSeeds = v end})
AutoPlantSection:AddDropdown({"Select Fertilizer", "Choose the fertilizer to use", false, FertilizerList, {"None"}, function(v) 
    SelectedFertilizer = type(v) == "table" and v[1] or v 
end})

AutoPlantSection:AddToggle({"Enable Auto Plant", "Toggle to automatically plant the selected seed", false, function(value)
    _G.AutoPlant = value
    if _G.AutoPlant then
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local StartRound = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.6.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PlantRoundService"):WaitForChild("RF"):WaitForChild("StartRound")
            local ToggleEquip = RS.Packages._Index["sleitnick_knit@1.6.0"].knit.Services.ToolService.RE.ToggleEquip

            while _G.AutoPlant do
                task.wait(1.5) 
                if table.find(SelectedPlantSeeds, "None") or #SelectedPlantSeeds == 0 then continue end

                pcall(function()
                    local char = Player.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                    local root = char.HumanoidRootPart
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    
                    local plotBusy = false
                    local bigField = workspace:FindFirstChild("BigField")
                    if bigField then
                        for _, model in ipairs(bigField:GetChildren()) do
                            if string.find(model.Name, "PlantRound_" .. PlayerID) then
                                local dist = (model:GetPivot().Position - root.Position).Magnitude
                                if dist < 15 then plotBusy = true; break end
                            end
                        end
                    end
                    if plotBusy then return end
                    
                    local PlayerGui = Player:FindFirstChild("PlayerGui")
                    local targetSlot = nil
                    local foundSeedName = nil
                    local hotbarSlots = PlayerGui and PlayerGui:FindFirstChild("HUD") and PlayerGui.HUD:FindFirstChild("Hotbar") and PlayerGui.HUD.Hotbar:FindFirstChild("LowerSection") and PlayerGui.HUD.Hotbar.LowerSection:FindFirstChild("LowerHotbarSlots")
                    
                    if hotbarSlots then
                        for _, slotFrame in ipairs(hotbarSlots:GetChildren()) do
                            if slotFrame:IsA("GuiObject") then
                                local isTarget = false
                                for _, desc in ipairs(slotFrame:GetDescendants()) do
                                    if desc:IsA("TextLabel") then
                                        local txtLower = string.lower(string.gsub(desc.Text, " ", ""))
                                        for _, s in ipairs(SelectedPlantSeeds) do
                                            local targetName = string.lower(string.gsub(s, " ", ""))
                                            targetName = string.gsub(targetName, "avacado", "avocado")
                                            if string.find(txtLower, targetName) then
                                                isTarget = true
                                                foundSeedName = s
                                                break
                                            end
                                        end
                                    end
                                    if isTarget then break end
                                end
                                
                                if isTarget then
                                    for _, desc in ipairs(slotFrame:GetDescendants()) do
                                        if desc:IsA("TextLabel") then
                                            local textVal = string.gsub(desc.Text, " ", "")
                                            local num = tonumber(textVal)
                                            if num and tostring(num) == textVal then targetSlot = num; break end
                                        end
                                    end
                                    if not targetSlot then targetSlot = tonumber(string.match(slotFrame.Name, "%d+")) end
                                    break
                                end
                            end
                        end
                    end
                    
                    if targetSlot and foundSeedName then
                        repeat task.wait(0.1) until not _G.IsActionBusy
                        _G.IsActionBusy = true
                        
                        if humanoid then humanoid:UnequipTools() end
                        task.wait(0.3)
                        ToggleEquip:FireServer(true, targetSlot)
                        
                        pcall(function()
                            local vim = game:GetService("VirtualInputManager")
                            local kc = Enum.KeyCode["Number" .. tostring(targetSlot)]
                            if kc then vim:SendKeyEvent(true, kc, false, game); task.wait(0.1); vim:SendKeyEvent(false, kc, false, game) end
                        end)
                        
                        task.wait(0.8) 
                        local finalSeedName = string.gsub(string.gsub(string.gsub(foundSeedName, " Seed", ""), "Seed", ""), " ", "")
                        finalSeedName = string.gsub(string.gsub(finalSeedName, "Avacado", "Avocado"), "avacado", "Avocado")
                        
                        StartRound:InvokeServer(finalSeedName, SelectedFertilizer)
                        
                        _G.IsActionBusy = false 
                    end
                end)
            end
        end)
    end
end})

local AutoPickupMultiplySection = MainTab:AddSection("Auto Harvest", false)
_G.TargetHarvestMultiplier = 2.0 

FuncsV3:Textbox(AutoPickupMultiplySection, "Minimum Harvest Multiplier", "Ketik angka lalu TEKAN ENTER (cth: 5)", "2", function(text) 
    local extractedNum = string.match(tostring(text), "[%d%.]+")
    if extractedNum then
        _G.TargetHarvestMultiplier = tonumber(extractedNum)
        warn("[AUTO HARVEST] Target Multiplier sukses diubah ke:", _G.TargetHarvestMultiplier)
    end
end)

AutoPickupMultiplySection:AddToggle({"Enable Auto Harvest", "Automatically harvest crops when they reach the target multiplier", false, function(value) 
    _G.AutoHarvest = value
    
    if _G.AutoHarvest then
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local StopPlant = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.6.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PlantRoundService"):WaitForChild("RF"):WaitForChild("StopPlant")

            while _G.AutoHarvest do
                task.wait(0.5) 
                pcall(function()
                    local harvested = false
                    local bigField = workspace:FindFirstChild("BigField")
                    
                    if bigField then
                        for _, model in ipairs(bigField:GetChildren()) do
                            if string.find(model.Name, "PlantRound_" .. PlayerID) then
                                local multLabel = model:FindFirstChild("MultDisplay") 
                                    and model.MultDisplay:FindFirstChild("BillboardGui") 
                                    and model.MultDisplay.BillboardGui:FindFirstChild("MainFrame") 
                                    and model.MultDisplay.BillboardGui.MainFrame:FindFirstChild("Mult")
                                
                                if multLabel then
                                    local extracted = string.match(multLabel.Text, "([%d%.]+)x")
                                    if extracted then
                                        local currentMulti = tonumber(extracted)
                                        
                                        if currentMulti and currentMulti >= _G.TargetHarvestMultiplier then
                                            repeat task.wait(0.1) until not _G.IsActionBusy
                                            _G.IsActionBusy = true
                                            
                                            StopPlant:InvokeServer()
                                            pcall(function() StopPlant:InvokeServer(model.Name) end)
                                            pcall(function()
                                                local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                if prompt then fireproximityprompt(prompt, 1, true) end
                                            end)
                                            
                                            harvested = true
                                            task.wait(1)
                                            
                                            _G.IsActionBusy = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if harvested then task.wait(2) end
                end)
            end
        end)
    end
end})

AutoPickupMultiplySection:AddToggle({"Collect Dead Plants", "Automatically clean up dead crops to free space", false, function(value)
    _G.AutoCollectDead = value
    if _G.AutoCollectDead then
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local CollectDeadTree = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.6.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PlantRoundService"):WaitForChild("RF"):WaitForChild("CollectDeadTree")

            while _G.AutoCollectDead do
                task.wait(1) 
                pcall(function()
                    local bigField = workspace:FindFirstChild("BigField")
                    if bigField then
                        for _, model in ipairs(bigField:GetChildren()) do
                            if string.find(model.Name, "PlantRound_" .. PlayerID) then
                                local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt and string.find(string.lower(prompt.ActionText), "collect") then
                                    CollectDeadTree:InvokeServer()
                                    pcall(function() CollectDeadTree:InvokeServer(model.Name) end)
                                    fireproximityprompt(prompt, 1, true)
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end})

-- ==============================================================================
-- TAB 2: AUTO
-- ==============================================================================
local AutoPlantPlotSection = AutoTab:AddSection("Auto Plant Plot", false)
local SelectedPlantPlots = {"None"}

AutoPlantPlotSection:AddDropdown({"Select Plant To Plot", "Choose multiple plants to place on your plot", true, PlantList, {"None"}, function(v) 
    SelectedPlantPlots = v
end})

AutoPlantPlotSection:AddToggle({"Enable Auto Plant Plot", "Automatically plants the selected crop on empty spaces", false, function(value) 
    _G.AutoPlantPlot = value
    
    if _G.AutoPlantPlot then
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local KnitRF = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.6.0"):WaitForChild("knit"):WaitForChild("Services")
            local PlantTree = KnitRF:WaitForChild("PlayerPlotService"):WaitForChild("RF"):WaitForChild("PlantTree")
            local ToggleEquip = RS.Packages._Index["sleitnick_knit@1.6.0"].knit.Services.ToolService.RE.ToggleEquip
            
            while _G.AutoPlantPlot do
                task.wait(2)
                if table.find(SelectedPlantPlots, "None") or #SelectedPlantPlots == 0 then continue end
                
                pcall(function()
                    local char = Player.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                    local root = char.HumanoidRootPart
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    
                    local PlayerGui = Player:FindFirstChild("PlayerGui")
                    local targetSlot = nil
                    local hotbarSlots = PlayerGui and PlayerGui:FindFirstChild("HUD") and PlayerGui.HUD:FindFirstChild("Hotbar") and PlayerGui.HUD.Hotbar:FindFirstChild("LowerSection") and PlayerGui.HUD.Hotbar.LowerSection:FindFirstChild("LowerHotbarSlots")
                    
                    if hotbarSlots then
                        for _, slotFrame in ipairs(hotbarSlots:GetChildren()) do
                            if slotFrame:IsA("GuiObject") then
                                local isTarget = false
                                for _, desc in ipairs(slotFrame:GetDescendants()) do
                                    if desc:IsA("TextLabel") then
                                        local txtLower = string.lower(string.gsub(desc.Text, " ", ""))
                                        for _, p in ipairs(SelectedPlantPlots) do
                                            local targetTargetName = string.lower(string.gsub(p, " ", ""))
                                            if string.find(txtLower, targetTargetName) then
                                                isTarget = true
                                                break
                                            end
                                        end
                                    end
                                    if isTarget then break end
                                end
                                
                                if isTarget then
                                    for _, desc in ipairs(slotFrame:GetDescendants()) do
                                        if desc:IsA("TextLabel") then
                                            local textVal = string.gsub(desc.Text, " ", "")
                                            local num = tonumber(textVal)
                                            if num and tostring(num) == textVal then targetSlot = num; break end
                                        end
                                    end
                                    if not targetSlot then targetSlot = tonumber(string.match(slotFrame.Name, "%d+")) end
                                    break
                                end
                            end
                        end
                    end
                    
                    if targetSlot then
                        repeat task.wait(0.1) until not _G.IsActionBusy
                        _G.IsActionBusy = true
                        
                        if humanoid then humanoid:UnequipTools() end
                        task.wait(0.3)
                        ToggleEquip:FireServer(true, targetSlot)
                        
                        pcall(function()
                            local vim = game:GetService("VirtualInputManager")
                            local kc = Enum.KeyCode["Number" .. tostring(targetSlot)]
                            if kc then vim:SendKeyEvent(true, kc, false, game); task.wait(0.1); vim:SendKeyEvent(false, kc, false, game) end
                        end)
                        
                        task.wait(1) 
                        
                        local equippedTool = char:FindFirstChildWhichIsA("Tool")
                        if equippedTool then
                            local targetUUID = equippedTool:GetAttribute("ItemId")
                            
                            if targetUUID then
                                local playerPlotsFolder = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("PlayerPlots")
                                local myPlotFolder = nil
                                local myDirt = nil
                                
                                if playerPlotsFolder then
                                    for _, plotDir in pairs(playerPlotsFolder:GetChildren()) do
                                        local plot1 = plotDir:FindFirstChild("Plot1")
                                        if plot1 and plot1:FindFirstChild("Dirt") then
                                            local dirt = plot1.Dirt
                                            if (dirt.Position - root.Position).Magnitude < 200 then
                                                myPlotFolder = plotDir
                                                myDirt = dirt
                                                break
                                            end
                                        end
                                    end
                                end

                                if myPlotFolder and myDirt then
                                    local emptyPos = nil
                                    local size = myDirt.Size
                                    local baseCF = myDirt.CFrame

                                    for x = -size.X/2 + 8, size.X/2 - 8, 12 do
                                        for z = -size.Z/2 + 8, size.Z/2 - 8, 12 do
                                            local testPos = (baseCF * CFrame.new(x, size.Y/2, z)).Position
                                            local occupied = false

                                            for _, obj in pairs(myPlotFolder:GetChildren()) do
                                                if string.find(obj.Name, "PlotTree") and obj:GetPivot() then
                                                    local treePos = obj:GetPivot().Position
                                                    local dist = (Vector3.new(treePos.X, 0, treePos.Z) - Vector3.new(testPos.X, 0, testPos.Z)).Magnitude
                                                    if dist < 8 then
                                                        occupied = true
                                                        break
                                                    end
                                                end
                                            end

                                            if not occupied then
                                                emptyPos = testPos
                                                break
                                            end
                                        end
                                        if emptyPos then break end
                                    end

                                    if emptyPos then
                                        root.CFrame = CFrame.new(emptyPos) + Vector3.new(0, 4, 0)
                                        task.wait(0.5)

                                        local args = { targetUUID, emptyPos, 0 }
                                        PlantTree:InvokeServer(unpack(args))
                                        task.wait(1.5) 
                                    end
                                end
                            end
                        end
                        _G.IsActionBusy = false
                    end
                end)
            end
        end)
    end
end})

local AutoPickupFruitSection = AutoTab:AddSection("Auto Pickup Fruit", false)
local SelectedPickupFruits = {"None"}
local SelectedPickupMutations = {"None"}
_G.TargetFruitMultiplier = 0 

AutoPickupFruitSection:AddDropdown({"Target Fruit", "Select multiple fruits to harvest", true, PickupFruitList, {"None"}, function(v) 
    SelectedPickupFruits = v 
end})

AutoPickupFruitSection:AddDropdown({"Target Mutation", "Select multiple mutations to filter (Optional)", true, MutationList, {"None"}, function(v) 
    SelectedPickupMutations = v 
end})

FuncsV3:Textbox(AutoPickupFruitSection, "Max Multiplier Limit", "Enter 0 to collect all, or set a maximum limit (e.g., 20)", "0", function(text) 
    local extractedNum = string.match(tostring(text), "[%d%.]+")
    if extractedNum then
        _G.TargetFruitMultiplier = tonumber(extractedNum)
        warn("[AUTO PICKUP] Max Multiplier set to:", _G.TargetFruitMultiplier)
    end
end)

AutoPickupFruitSection:AddToggle({"Enable Auto Pickup", "Automatically teleport and collect fruits matching your filters", false, function(value) 
    _G.AutoPickupFruit = value
    
    if _G.AutoPickupFruit then
        task.spawn(function()
            while _G.AutoPickupFruit do
                task.wait(0.5) 
                
                pcall(function()
                    local char = game.Players.LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local PlayerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if not root or not PlayerGui then return end
                    
                    local myPlotFolder = nil
                    local playerPlots = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("PlayerPlots")
                    
                    if playerPlots then
                        for _, plot in pairs(playerPlots:GetChildren()) do
                            local signName = plot:FindFirstChild("OwnerSign") 
                                and plot.OwnerSign:FindFirstChild("Sign") 
                                and plot.OwnerSign.Sign:FindFirstChild("SurfaceGui") 
                                and plot.OwnerSign.Sign.SurfaceGui:FindFirstChild("Frame") 
                                and plot.OwnerSign.Sign.SurfaceGui.Frame:FindFirstChild("PlayerName")
                            
                            if signName and signName:IsA("TextLabel") then
                                if signName.Text == game.Players.LocalPlayer.Name or signName.Text == game.Players.LocalPlayer.DisplayName then
                                    myPlotFolder = plot
                                    break
                                end
                            end
                        end
                        
                        if not myPlotFolder then
                            for _, plot in pairs(playerPlots:GetChildren()) do
                                local plot1 = plot:FindFirstChild("Plot1")
                                if plot1 and plot1:FindFirstChild("Dirt") then
                                    if (plot1.Dirt.Position - root.Position).Magnitude < 150 then
                                        myPlotFolder = plot
                                        break
                                    end
                                end
                            end
                        end
                    end
                    
                    if not myPlotFolder then return end 
                    
                    local plotBillboards = PlayerGui:FindFirstChild("PlotBillboards")
                    if not plotBillboards then return end

                    for _, billboard in pairs(plotBillboards:GetChildren()) do
                        if billboard:IsA("BillboardGui") and billboard.Adornee then
                            local fruitPart = billboard.Adornee
                            
                            if fruitPart:IsDescendantOf(myPlotFolder) then
                                local mainFrame = billboard:FindFirstChild("MainFrame")
                                local textLabel = mainFrame and mainFrame:FindFirstChild("Name")
                                
                                if textLabel and textLabel:IsA("TextLabel") then
                                    local allText = textLabel.Text
                                    local prompt = fruitPart:FindFirstChildWhichIsA("ProximityPrompt")
                                    
                                    if prompt and string.find(string.lower(prompt.ActionText), "collect") then
                                        
                                        local isValidFruit = false
                                        local isValidMutation = false
                                        local isValidMulti = true

                                        if table.find(SelectedPickupFruits, "None") or #SelectedPickupFruits == 0 then
                                            isValidFruit = true
                                        else
                                            for _, selectedFruit in ipairs(SelectedPickupFruits) do
                                                local cleanName = string.gsub(selectedFruit, "Fruit", "")
                                                if string.find(string.lower(allText), string.lower(cleanName)) then
                                                    isValidFruit = true
                                                    break
                                                end
                                            end
                                        end

                                        if table.find(SelectedPickupMutations, "None") or #SelectedPickupMutations == 0 then
                                            isValidMutation = true
                                        else
                                            for _, selectedMut in ipairs(SelectedPickupMutations) do
                                                if string.find(string.lower(allText), string.lower(selectedMut)) then
                                                    isValidMutation = true
                                                    break
                                                end
                                            end
                                        end

                                        if _G.TargetFruitMultiplier > 0 then
                                            local extractedMulti = string.match(allText, "([%d%.]+)x")
                                            if extractedMulti then
                                                if tonumber(extractedMulti) > _G.TargetFruitMultiplier then
                                                    isValidMulti = false
                                                end
                                            end
                                        end

                                        if isValidFruit and isValidMutation and isValidMulti then
                                            repeat task.wait(0.1) until not _G.IsActionBusy
                                            _G.IsActionBusy = true
                                            
                                            root.CFrame = fruitPart.CFrame + Vector3.new(0, 3, 0)
                                            task.wait(0.2)
                                            fireproximityprompt(prompt, 1, true)
                                            task.wait(0.3)
                                            
                                            _G.IsActionBusy = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end})

local AutoSellSection = AutoTab:AddSection("Auto Sell", false)
local SelectedSellItems = {"None"}

AutoSellSection:AddToggle({"Sell All Inventory", "Automatically sell all items in your inventory", false, function(value) 
    _G.AutoSellAll = value
    if _G.AutoSellAll then
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local SellAll = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.6.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("SellStandService"):WaitForChild("RF"):WaitForChild("SellAll")
            
            while _G.AutoSellAll do
                task.wait(2)
                pcall(function()
                    SellAll:InvokeServer()
                end)
            end
        end)
    end
end})

-- [FIX] SELL FILTER SEKARANG BERDASARKAN NAMA BARANG (BUAH / BIBIT)
AutoSellSection:AddDropdown({"Filter By Name", "Select multiple items (seeds/fruits) to automatically sell", true, SellableList, {"None"}, function(v) 
    SelectedSellItems = v 
end})

AutoSellSection:AddToggle({"Enable Name Sell", "Automatically sell items that match the selected names", false, function(value) 
    _G.AutoSellFilter = value
    if _G.AutoSellFilter then
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local SellTree = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.6.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("SellStandService"):WaitForChild("RF"):WaitForChild("SellTree")
            
            while _G.AutoSellFilter do
                task.wait(1)
                if table.find(SelectedSellItems, "None") or #SelectedSellItems == 0 then continue end
                
                pcall(function()
                    local tools = game.Players.LocalPlayer.Backpack:GetChildren()
                    for _, tool in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        if tool:IsA("Tool") then table.insert(tools, tool) end
                    end
                    
                    for _, tool in ipairs(tools) do
                        local itemName = tool.Name
                        local isSelected = false
                        
                        -- Cek apakah nama tool di backpack mengandung nama barang yang dipilih bos
                        for _, selectedItem in ipairs(SelectedSellItems) do
                            local cleanTarget = string.lower(string.gsub(selectedItem, "Fruit", ""))
                            if string.find(string.lower(itemName), cleanTarget) then
                                isSelected = true
                                break
                            end
                        end
                        
                        if isSelected then
                            local uuid = tool:GetAttribute("ItemId") or tool.Name
                            SellTree:InvokeServer(uuid)
                            task.wait(0.1)
                        end
                    end
                end)
            end
        end)
    end
end})

local AutoRebirthSection = AutoTab:AddSection("Rebirth", false)
AutoRebirthSection:AddToggle({"Auto Rebirth", "Automatically rebirth when you meet the requirements", false, function(value) 
    _G.AutoRebirth = value
    if _G.AutoRebirth then
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local DoRebirth = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.6.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("RebirthService"):WaitForChild("RF"):WaitForChild("DoRebirth")
            
            while _G.AutoRebirth do
                task.wait(3)
                pcall(function()
                    DoRebirth:InvokeServer()
                end)
            end
        end)
    end
end})

-- ==============================================================================
-- TAB 3: SHOP 
-- ==============================================================================
local PetsShopSection = ShopTab:AddSection("Pets Shop", false)
local SelectedPetEggs = {"None"}

PetsShopSection:AddDropdown({"Select Pet Egg", "Select multiple eggs to buy from the Pets Shop", true, PetsShopList, {"None"}, function(v) 
    SelectedPetEggs = v 
end})

PetsShopSection:AddToggle({"Enable Auto Buy Egg", "Automatically purchase the selected pet eggs", false, function(value) 
    _G.AutoBuyEgg = value
    if _G.AutoBuyEgg then
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local BuyEgg = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.6.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PetsService"):WaitForChild("RF"):WaitForChild("BuyEgg")
            
            while _G.AutoBuyEgg do
                task.wait(1)
                if not table.find(SelectedPetEggs, "None") and #SelectedPetEggs > 0 then
                    for _, egg in ipairs(SelectedPetEggs) do
                        pcall(function() BuyEgg:InvokeServer(egg) end)
                        task.wait(0.2)
                    end
                end
            end
        end)
    end
end})

-- ==============================================================================
-- TAB 4: MISC
-- ==============================================================================
local MiscSection = MiscTab:AddSection("Miscellaneous", false)
MiscSection:AddToggle({"Anti Afk", "Prevents you from being kicked for idling", false, function(value)
    _G.AntiAfk = value
    if _G.AntiAfk then
        local VirtualUser = game:GetService("VirtualUser")
        Player.Idled:Connect(function()
            if _G.AntiAfk then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end
end})

MiscSection:AddToggle({"FPS Boost", "Lowers graphics to improve game performance", false, function(value)
    if value then
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
    end
end})
