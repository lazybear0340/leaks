--unobfuscated


-- ==============================================================================
-- 1. LOAD MODUL DAN LIBRARY
-- ==============================================================================
local FuncsV3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrtokyo/refs/heads/main/FuncsV3"))()
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/putrachhh/ptrlibrary/refs/heads/main/tokyo-ontop"))()

-- ==============================================================================
-- 2. INISIALISASI WINDOW & TEMA
-- ==============================================================================
local Window = Speed_Library:CreateWindow({
    "Tokyo",
    "Steal A Chicken",
    120,
    nil, 
    "rbxassetid://91570350247074"
})

Speed_Library:AddTopInfo("All Tiers")

Speed_Library:SetCharacterArt("rbxassetid://95368690194608", {
    Size = UDim2.new(0, 420, 0, 420),
    Position = UDim2.new(0.5, 0, 0.68, 0),
    Transparency = 0.8
})

-- ==============================================================================
-- 3. SERVICES, VARIABLES & DATABASE HARGA AYAM
-- ==============================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")
local RS = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local targetNames = {"None"}
local targetAreas = {"None"}
local minRewardTarget = 0
local autoFarmActive = false

local autoSellEggActive = false
local autoSellChickenActive = false
local autoCollectEggActive = false
local autoEquipBestActive = false
local antiAfkConnection = nil

local function parseMultiSelect(val)
    local arr = {}
    if type(val) == "table" then
        for k, v in pairs(val) do
            if type(k) == "number" then table.insert(arr, tostring(v))
            elseif type(k) == "string" and v == true then table.insert(arr, k)
            elseif type(k) == "string" and type(v) == "string" then table.insert(arr, v)
            end
        end
    elseif type(val) == "string" then table.insert(arr, val) end
    if #arr == 0 then return {"None"} end
    return arr
end

local function tableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if string.lower(tostring(v)) == string.lower(tostring(val)) then return true end
    end
    return false
end

-- Helper buat cek UI beneran kelihatan (untuk Fail-Safe)
local function IsEffectivelyVisible(obj)
    local current = obj
    while current and current ~= game do
        if current:IsA("GuiObject") and current.Visible == false then
            return false
        end
        current = current.Parent
    end
    return true
end

-- ==============================================================================
-- HELPER: CUSTOM FLY (ANTI-STUCK + SPEED 900)
-- Menggunakan Lerp paksa agar tidak bisa diberhentikan oleh physics/anti-cheat
-- ==============================================================================
local function TweenTo(targetCFrame)
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = myChar.HumanoidRootPart
    local startCFrame = hrp.CFrame
    local distance = (startCFrame.Position - targetCFrame.Position).Magnitude
    
    -- KECEPATAN DIGASPOL KE 900
    local speed = 700 
    
    local duration = distance / speed
    if duration < 0.1 then duration = 0.1 end
    
    -- Mengaktifkan Noclip sementara saat terbang agar tidak nyangkut
    local noclipConnection = game:GetService("RunService").Stepped:Connect(function()
        for _, part in ipairs(myChar:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)

    -- Custom Tween Logic (Anti-Berhenti di jalan)
    local startTime = os.clock()
    while os.clock() - startTime < duration do
        local elapsed = os.clock() - startTime
        local alpha = elapsed / duration
        
        if hrp and hrp.Parent then
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.CFrame = startCFrame:Lerp(targetCFrame, alpha)
        else
            break -- Kalau tiba-tiba mati/reset, stop terbangnya
        end
        task.wait()
    end
    
    -- Pasang pas di titik tujuan
    if hrp and hrp.Parent then
        hrp.CFrame = targetCFrame
        hrp.Velocity = Vector3.new(0, 0, 0)
    end
    
    -- Matikan Noclip setelah sampai
    if noclipConnection then
        noclipConnection:Disconnect()
    end
end

-- Scraping Database Harga Ayam 
local ChickenDatabase = {}
task.spawn(function()
    local chickensFolder = RS:FindFirstChild("shared")
        and RS.shared:FindFirstChild("gameData")
        and RS.shared.gameData:FindFirstChild("chickens")
        and RS.shared.gameData.chickens:FindFirstChild("chickens")

    if chickensFolder then
        for _, obj in pairs(chickensFolder:GetChildren()) do
            if obj:IsA("ModuleScript") then
                pcall(function()
                    local data = require(obj)
                    if type(data) == "table" and data.variants then
                        local firstVar = next(data.variants)
                        if firstVar and data.variants[firstVar] then
                            local cName = data.variants[firstVar]._name
                            local cReward = data.variants[firstVar]._reward or 0
                            if cName then
                                ChickenDatabase[string.lower(cName)] = tonumber(cReward)
                            end
                        end
                    end
                end)
            end
        end
    end
end)

-- ==============================================================================
-- 4. MASTER LIST AREA & NAMA
-- ==============================================================================
local NameList = {
    "None", "Chicken", "Insane Chicken", 
    "Amethyst Chicken", "Ancient Chicken", "Bee Chicken", "Black Chicken", "Bronze Chicken",
    "Brown Chicken", "Candle Chicken", "Candy Chicken", "Carbon Chicken", "Cash Chicken",
    "Cheese Chicken", "Chocolate Chicken", "Crystal Chicken", "Cyber Chicken", "Demon King Chicken",
    "Diamond Chicken", "Dino Chicken", "DJ Chicken", "Dragon Chicken", "Easter Chicken",
    "Egypt Chicken", "Emerald Chicken", "Fish Chicken", "Galaxy Chicken", "Gold Chicken",
    "Grandpa Chicken", "Grass Chicken", "Gravity Chicken", "Green Chicken", "Honey Chicken",
    "Ice Chicken", "Keyboard Chicken", "King Chicken", "Lapis Chicken", "Lord Chicken",
    "Magma Chicken", "Ninja Chicken", "Obsidian Chicken", "Opal Chicken", "Orange Chicken",
    "Orca Chicken", "Penguin Chicken", "Pig Chicken", "Polar Bear Chicken", "Purple Chicken",
    "Quartz Chicken", "Rainbow Chicken", "Red Chicken", "Reptile Chicken", "Ruby Chicken",
    "Salamander Chicken", "Shark Chicken", "Silver Chicken", "Snake Chicken", "Solar Chicken",
    "Stone Chicken", "Strange Chicken", "Tech Chicken", "Tiger Chicken", "Toxic Chicken",
    "Turtle Chicken", "White Chicken", "Wood Chicken", "Zombie Chicken", "Royal Crystal Chicken", "Crown Crystal Chicken", "Shard Crystal Chicken", "Titan Crystal Chicken"
}

local AreaList = {"None", "Abyss", "Beach", "Cosmic", "Desert", "Forest", "Jungle", "Lake", "Snow", "Volcano", "Crystal"}

-- ==============================================================================
-- 5. PEMBUATAN TAB & SECTION 
-- ==============================================================================
local MainTab = Window:CreateTab({ Name = "Main", Icon = "rbxthumb://type=Asset&id=170940874&w=150&h=150" })
local AutoTab = Window:CreateTab({ Name = "Auto", Icon = "rbxthumb://type=Asset&id=16326604165&w=150&h=150" })
local MiscTab = Window:CreateTab({ Name = "Misc", Icon = "rbxthumb://type=Asset&id=7059346386&w=150&h=150" })

-- ==============================================================================
-- TAB MAIN: SECTION AUTO FARM
-- ==============================================================================
local AutoFarmSection = MainTab:AddSection("Auto Farm", true)

FuncsV3:Dropdown(
    AutoFarmSection, 
    "Select Target Area", 
    "Select the specific area or chicken spawn to farm.", 
    true, 
    AreaList, 
    {"None"}, 
    function(Value) 
        targetAreas = parseMultiSelect(Value) 
    end
)

FuncsV3:Textbox(
    AutoFarmSection,
    "Min Value Target",
    "Type a number and press ENTER! (e.g., 1 = 10k, 10 = 100k, 0 = All).",
    "0", 
    function(Value)
        minRewardTarget = (tonumber(Value) or 0) * 10000
    end
)

FuncsV3:Dropdown(
    AutoFarmSection, 
    "Select Specific Name (Optional)", 
    "Select manually. If chosen, the Min Value Filter above will be ignored.", 
    true, 
    NameList, 
    {"None"}, 
    function(Value) 
        targetNames = parseMultiSelect(Value) 
    end
)

FuncsV3:Toggle(
    AutoFarmSection, 
    "Auto Steal Chicken", 
    "Fast Tween + Smart Safezone Return!", 
    false, 
    function(State)
        autoFarmActive = State
        
        if autoFarmActive then
            task.spawn(function()
                local safezoneCFrame = CFrame.new(-34.94, 33.4, -298.99)
                local ignorePrompts = {} -- Blacklist ayam gagal sementara

                while autoFarmActive do
                    pcall(function()
                        local myChar = LocalPlayer.Character
                        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                        
                        -- =============================================================
                        -- FAIL-SAFE: Cek kalau kita lagi bawa ayam tapi berhenti/nyangkut
                        -- =============================================================
                        local isCarrying = false
                        for _, guiObj in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                            if (guiObj:IsA("TextLabel") or guiObj:IsA("TextButton")) and IsEffectivelyVisible(guiObj) then
                                local txt = string.lower(tostring(guiObj.Text))
                                if string.find(txt, "run!!!") then
                                    isCarrying = true
                                    break
                                end
                            end
                        end
                        
                        if isCarrying then
                            -- Lagi bawa ayam! Langsung gas ke safezone
                            myChar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            TweenTo(safezoneCFrame)
                            task.wait(1)
                            return -- Lewati sisa kode di bawah, langsung ulang loop while
                        end
                        -- =============================================================
                        
                        for _, prompt in pairs(workspace:GetDescendants()) do
                            if not autoFarmActive then break end
                            
                            if prompt:IsA("ProximityPrompt") and prompt.Enabled == true then
                                -- Cek apakah prompt ini sedang masuk cooldown gagal
                                if not ignorePrompts[prompt] or os.clock() > ignorePrompts[prompt] then
                                    
                                    local actionText = string.lower(prompt.ActionText)
                                    
                                    if string.find(actionText, "steal") or string.find(actionText, "chicken") then
                                        
                                        local promptParent = prompt.Parent
                                        local chickenModel = promptParent
                                        if chickenModel and chickenModel.Parent and chickenModel.Parent:IsA("Model") then
                                            chickenModel = chickenModel.Parent
                                        end
                                        
                                        local rawChickenName = chickenModel:GetAttribute("chickenName") or "chicken"
                                        
                                        local function normalize(str)
                                            return string.lower(string.gsub(tostring(str), "%s+", ""))
                                        end
                                        
                                        local normalizedChicken = normalize(rawChickenName)
                                        local isTargetMatch = false
                                        
                                        if not tableContains(targetNames, "None") then
                                            for _, name in ipairs(targetNames) do
                                                if normalizedChicken == normalize(name) then
                                                    isTargetMatch = true
                                                    break
                                                end
                                            end
                                        else
                                            local reward = 0
                                            for dbName, dbReward in pairs(ChickenDatabase) do
                                                if normalize(dbName) == normalizedChicken then
                                                    reward = dbReward
                                                    break
                                                end
                                            end
                                            
                                            if minRewardTarget == 0 then
                                                isTargetMatch = true
                                            elseif reward and reward >= minRewardTarget then
                                                isTargetMatch = true
                                            end
                                        end
                                        
                                        if isTargetMatch then
                                            local isCorrectArea = true
                                            
                                            if not tableContains(targetAreas, "None") then
                                                local inArea = false
                                                local currentParent = promptParent
                                                while currentParent and currentParent ~= workspace do
                                                    if tableContains(targetAreas, currentParent.Name) then
                                                        inArea = true
                                                        break
                                                    end
                                                    currentParent = currentParent.Parent
                                                end
                                                if not inArea then isCorrectArea = false end
                                            end
                                            
                                            if isCorrectArea then
                                                local targetPos = nil
                                                if promptParent:IsA("Attachment") then targetPos = promptParent.WorldCFrame.Position
                                                elseif promptParent:IsA("BasePart") then targetPos = promptParent.Position
                                                elseif promptParent:IsA("Model") and promptParent.PrimaryPart then targetPos = promptParent.PrimaryPart.Position end
                                                
                                                if targetPos then
                                                    -- 1. TWEEN (TERBANG) KE AYAM LALU DIAM
                                                    myChar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                                                    TweenTo(CFrame.new(targetPos) + Vector3.new(0, 1.5, 0))
                                                    task.wait(0.2) -- Tunggu karakter stabil
                                                    
                                                    pcall(function() 
                                                        prompt.RequiresLineOfSight = false
                                                        prompt.MaxActivationDistance = math.huge
                                                    end)
                                                    
                                                    local holdTime = prompt.HoldDuration
                                                    if holdTime <= 0 then holdTime = 1 end
                                                    
                                                    local success = false
                                                    
                                                    -- 2. TAHAN TOMBOL SELAMA PROGRESS BERJALAN
                                                    pcall(function() prompt:InputHoldBegin() end)
                                                    
                                                    local waitTicks = 0
                                                    local maxTicks = math.ceil((holdTime + 3) / 0.1) 
                                                    
                                                    while waitTicks < maxTicks do
                                                        task.wait(0.1)
                                                        waitTicks = waitTicks + 1
                                                        
                                                        if not prompt:IsDescendantOf(workspace) or prompt.Enabled == false then
                                                            success = true
                                                            break
                                                        end
                                                    end
                                                    
                                                    pcall(function() prompt:InputHoldEnd() end)
                                                    
                                                    if success then
                                                        -- 3. JIKA BERHASIL: Diam bentar, lalu TWEEN balik ke Safezone
                                                        task.wait(0.3)
                                                        myChar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                                                        TweenTo(safezoneCFrame)
                                                        task.wait(1) -- Istirahat di safezone
                                                    else
                                                        -- 4. JIKA GAGAL: Tunggu sebentar lalu coba lagi (Hapus fitur skip 5 detik)
                                                        task.wait(0.5) 
                                                    end
                                                    
                                                    break -- Keluar dari loop pencarian
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1) 
                end
            end)
        end
    end
)

-- ==============================================================================
-- TAB AUTO: SELL, COLLECT EGG & EQUIP
-- ==============================================================================
local AutoSellSection = AutoTab:AddSection("Auto Sell", true)

FuncsV3:Toggle(
    AutoSellSection, 
    "Auto Sell All Egg", 
    "Automatically sell all eggs in your backpack.", 
    false, 
    function(State)
        autoSellEggActive = State
        if autoSellEggActive then
            task.spawn(function()
                local sellRemote = RS:WaitForChild("packages"):WaitForChild("_Index"):WaitForChild("littensy_remo@1.5.3"):WaitForChild("remo"):WaitForChild("container"):WaitForChild("data.backpack.sellAllItems")
                while autoSellEggActive do
                    pcall(function() sellRemote:FireServer("egg") end)
                    task.wait(2) 
                end
            end)
        end
    end
)

FuncsV3:Toggle(
    AutoSellSection, 
    "Auto Sell All Chicken", 
    "Automatically sell all chickens in your backpack.", 
    false, 
    function(State)
        autoSellChickenActive = State
        if autoSellChickenActive then
            task.spawn(function()
                local sellRemote = RS:WaitForChild("packages"):WaitForChild("_Index"):WaitForChild("littensy_remo@1.5.3"):WaitForChild("remo"):WaitForChild("container"):WaitForChild("data.backpack.sellAllItems")
                while autoSellChickenActive do
                    pcall(function() sellRemote:FireServer("chicken") end)
                    task.wait(2) 
                end
            end)
        end
    end
)

local AutoEggSection = AutoTab:AddSection("Auto Collect Egg", true)

FuncsV3:Toggle(
    AutoEggSection, 
    "Auto Collect All Eggs", 
    "Automatically claim all generated eggs at your base.", 
    false, 
    function(State)
        autoCollectEggActive = State
        if autoCollectEggActive then
            task.spawn(function()
                local claimRemote = RS:WaitForChild("packages"):WaitForChild("_Index"):WaitForChild("littensy_remo@1.5.3"):WaitForChild("remo"):WaitForChild("container"):WaitForChild("data.base.claimAllEggs")
                while autoCollectEggActive do
                    pcall(function() claimRemote:FireServer() end)
                    task.wait(2) 
                end
            end)
        end
    end
)

local AutoEquipSection = AutoTab:AddSection("Auto Equip Best", true)

FuncsV3:Toggle(
    AutoEquipSection, 
    "Equip Best Chickens", 
    "Automatically equip your best chickens to your base.", 
    false, 
    function(State)
        autoEquipBestActive = State
        if autoEquipBestActive then
            task.spawn(function()
                local equipRemote = RS:WaitForChild("packages"):WaitForChild("_Index"):WaitForChild("littensy_remo@1.5.3"):WaitForChild("remo"):WaitForChild("container"):WaitForChild("data.base.equipBestChickens")
                while autoEquipBestActive do
                    pcall(function() equipRemote:FireServer() end)
                    task.wait(2) 
                end
            end)
        end
    end
)

-- ==============================================================================
-- TAB MISC
-- ==============================================================================
local MiscSection = MiscTab:AddSection("Misc Features", true)

FuncsV3:Toggle(
    MiscSection,
    "Anti AFK",
    "Prevent Roblox from automatically disconnecting you after 20 minutes.",
    false,
    function(State)
        if State then
            if not antiAfkConnection then
                antiAfkConnection = LocalPlayer.Idled:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        else
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
        end
    end
)

FuncsV3:Button(
    MiscSection, 
    "FPS Boost", 
    "Remove textures and shadows to reduce lag and improve performance.", 
    function()
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.ShadowSoftness = 0
        
        if sethiddenproperty then
            pcall(function() sethiddenproperty(Lighting, "Technology", 2) end)
        end
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsA("MeshPart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Lifetime = NumberRange.new(0)
            end
        end
    end
)

FuncsV3:Button(
    MiscSection, 
    "Rejoin Server", 
    "Leave and instantly reconnect to the same server.", 
    function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
)
