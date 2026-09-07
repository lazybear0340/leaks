--this shit was unobfuscated


local ConfigManager = {};
local cloneref = cloneref or function(v) return v; end;
local function getservice(v) return cloneref(game:GetService(v)); end;
local shared = (getgenv and getgenv()) or shared or _G

do
    local HttpService = getservice("HttpService");
    local RunService = getservice("RunService");
    
    ConfigManager.Folder = "Anka";
    ConfigManager.Ignore = {};
    ConfigManager.CurrentPlaceId = tostring(game.PlaceId);
    ConfigManager.CurrentGameId = tostring(game.GameId);
    shared.Anka = shared.Anka or {};
    shared.Anka.Elements = shared.Anka.Elements or {};

    local function DelayedCall(func, delay)
        local ti11 = tick()
        local connection; connection = RunService.Heartbeat:Connect(function()
            if tick() - ti11 >= delay then
                connection:Disconnect()
                func()
            end
        end)
    end

    local function BetterShitTable(tbl, indent)
        indent = indent or 0
        local spacing = string.rep("    ", indent)
        local result = "{\n"
        for key, value in pairs(tbl) do
            local keyStr = type(key) == "string" and string.format('"%s"', key) or tostring(key)
            result = result .. spacing .. "    [" .. keyStr .. "] = "
            if type(value) == "table" then
                result = result .. BetterShitTable(value, indent + 1)
            elseif type(value) == "string" then
                result = result .. string.format('"%s"', value)
            elseif type(value) == "boolean" or type(value) == "number" then
                result = result .. tostring(value)
            else
                result = result .. string.format('"%s"', tostring(value))
            end
            result = result .. ",\n"
        end
        result = result .. spacing .. "}"
        return result
    end

    local function DeBetterShitTable(str)
        local func, err = loadstring("return " .. str)
        if not func then
            return nil, "Failed to parse config: " .. (err or "unknown error")
        end
        local success, result = pcall(func)
        if not success then
            return nil, "Failed to execute config: " .. (result or "unknown error")
        end
        return result
    end

    ConfigManager.Parser = {
        Toggle = {
            Save = function(Idx: string, Object: Element)
                local Data = {
                    type = "Toggle",
                    idx = Idx,
                    value = Object:GetState()
                };
                if Object.GetKeybind then
                    local Keybind = Object:GetKeybind();
                    if Keybind then
                        local bindEnum = Keybind:GetBind()
                        if bindEnum and bindEnum ~= Enum.KeyCode.Unknown then
                            Data.keybind = tostring(bindEnum):gsub("Enum.KeyCode.", "");
                            Data.keybindMode = Keybind:GetMode();
                        end;
                    end;
                end;
                return Data;
            end,
            Load = function(Idx: string, Data: any)
                DelayedCall(function()
                    local element = shared.Anka.Elements[Idx]
                    if element and element.SetState then
                        element:SetState(Data.value);
                        if Data.keybind and element.GetKeybind then
                            local Keybind = element:GetKeybind();
                            if Keybind then
                                local Success, EnumValue = pcall(function()
                                    return Enum.KeyCode[Data.keybind];
                                end);
                                if Success and EnumValue then
                                    Keybind:SetBind(EnumValue);
                                    if Data.keybindMode then
                                        Keybind:SetMode(Data.keybindMode);
                                    end
                                end;
                            end;
                        end;
                    end;
                end, 0.1)
            end
        },
        Slider = {
            Save = function(Idx: string, Object: Element)
                return { 
                    type = "Slider", 
                    idx = Idx, 
                    value = Object:GetValue() 
                };
            end,
            Load = function(Idx: string, Data: any)
                if shared.Anka.Elements[Idx] then 
                    shared.Anka.Elements[Idx]:SetValue(tonumber(Data.value) or 0);
                end;
            end,
        },
        Dropdown = {
            Save = function(Idx: string, Object: Element)
                return { 
                    type = "Dropdown", 
                    idx = Idx, 
                    value = Object:GetOption()
                };
            end,
            Load = function(Idx: string, Data: any)
                if shared.Anka.Elements[Idx] then 
                    shared.Anka.Elements[Idx]:SetOption(Data.value);
                end;
            end,
        },
        MultiDropdown = {
            Save = function(Idx: string, Object: Element)
                return { 
                    type = "MultiDropdown", 
                    idx = Idx, 
                    value = Object:GetOption()
                };
            end,
            Load = function(Idx: string, Data: any)
                if shared.Anka.Elements[Idx] then 
                    local Options = type(Data.value) == "table" and Data.value or {Data.value};
                    shared.Anka.Elements[Idx]:SetOption(Options);
                end;
            end,
        },
        ColorPicker = {
            Save = function(Idx: string, Object: Element)
                local color, transparency = Object:GetValue()
                return { 
                    type = "ColorPicker", 
                    idx = Idx, 
                    value = {
                        r = color.R,
                        g = color.G,
                        b = color.B,
                        a = transparency or 0
                    },
                    rainbow = Object:IsRainbowEnabled()
                };
            end,
            Load = function(Idx: string, Data: any)
                if shared.Anka.Elements[Idx] then 
                    local colordata = Data.value
                    if colordata and colordata.r and colordata.g and colordata.b then
                        DelayedCall(function()
                            local element = shared.Anka.Elements[Idx]
                            element:UpdateColor(Color3.new(colordata.r, colordata.g, colordata.b), colordata.a)
                            if Data.rainbow then
                                element:SetRainbow(true)
                            end
                        end, 0.3)
                    end
                end
            end,
        },
        AttachedColorPicker = {
            Save = function(Idx: string, Object: Element)
                local color, transparency = Object:GetValue()
                return { 
                    type = "AttachedColorPicker", 
                    idx = Idx, 
                    value = {
                        r = color.R,
                        g = color.G,
                        b = color.B,
                        a = transparency or 0
                    },
                    rainbow = Object:IsRainbowEnabled()
                };
            end,
            Load = function(Idx: string, Data: any)
                if shared.Anka.Elements[Idx] then 
                    local colordata = Data.value
                    if colordata and colordata.r and colordata.g and colordata.b then
                        DelayedCall(function()
                            local element = shared.Anka.Elements[Idx]
                            if element and element.UpdateColor then
                                element:UpdateColor(Color3.new(colordata.r, colordata.g, colordata.b), colordata.a)
                                if Data.rainbow and element.SetRainbow then
                                    element:SetRainbow(true)
                                end
                            end
                        end, 0.3)
                    end
                end
            end,
        },
        TextBox = {
            Save = function(Idx: string, Object: Element)
                return { 
                    type = "TextBox", 
                    idx = Idx, 
                    value = Object:GetValue() 
                };
            end,
            Load = function(Idx: string, Data: any)
                if shared.Anka.Elements[Idx] then 
                    shared.Anka.Elements[Idx]:SetValue(tostring(Data.value));
                end;
            end,
        },
        Button = {
            Save = function(Idx: string, Object: Element)
                local Data = {
                    type = "Button",
                    idx = Idx
                };
                if Object.GetKeybind then
                    local Keybind = Object:GetKeybind();
                    if Keybind then
                        local bindEnum = Keybind:GetBind()
                        if bindEnum and bindEnum ~= Enum.KeyCode.Unknown then
                            Data.keybind = tostring(bindEnum):gsub("Enum.KeyCode.", "");
                        end;
                    end;
                end;
                return Data;
            end,
            Load = function(Idx: string, Data: any)
                DelayedCall(function()
                    local element = shared.Anka.Elements[Idx]
                    if element and Data.keybind and element.GetKeybind then
                        local Keybind = element:GetKeybind();
                        if Keybind then
                            local Success, EnumValue = pcall(function()
                                return Enum.KeyCode[Data.keybind];
                            end);
                            if Success and EnumValue then
                                Keybind:SetBind(EnumValue);
                            end;
                        end;
                    end;
                end, 0.1)
            end
        }
    };

    function ConfigManager:SetIgnoreIndexes(List: {string})
        for _, Key in next, List do
            self.Ignore[Key] = true;
        end;
    end;

    function ConfigManager:SetFolder(Folder: string)
        self.Folder = Folder;
        self:BuildFolderTree();
    end;

    function ConfigManager:Save(Name: string)
        if not Name then return false, "No config file selected" end;
        local Data = { objects = {} };
        for UniqueID, Element in next, shared.Anka.Elements do
            if self.Ignore[UniqueID] then continue end;
            if Element and Element.Type and self.Parser[Element.Type] then
                local SavedElement = self.Parser[Element.Type].Save(UniqueID, Element);
                SavedElement.idx = UniqueID;
                SavedElement.type = Element.Type;
                table.insert(Data.objects, SavedElement);
            end;
        end;
        local Success, Serialized = pcall(BetterShitTable, Data);
        if not Success then return false, "Failed to serialize data: " .. tostring(Serialized) end;
        local FileSuccess, FileError = pcall(writefile, self.Folder .. "/settings/" .. Name .. ".lua", Serialized);
        return FileSuccess or false, FileSuccess and true or "Failed to write file: " .. tostring(FileError);
    end;

    function ConfigManager:Load(Name: string)
        if not Name then return false, "No config file selected" end;
        local File = self.Folder .. "/settings/" .. Name .. ".lua";
        if not isfile(File) then return false, "Invalid file" end;
        local FileContent = readfile(File);
        if not FileContent or FileContent == "" then
            return false, "Config file is empty";
        end;
        local Success, Decoded = pcall(DeBetterShitTable, FileContent);
        if not Success or not Decoded then
            return false, "Failed to decode config: " .. tostring(Decoded);
        end;
        if not Decoded.objects then
            return false, "Invalid config format (missing objects)";
        end;
        for _, Obj in ipairs(Decoded.objects) do
            if Obj and Obj.type and Obj.idx then
                local Element = shared.Anka.Elements[Obj.idx];
                if Element and Element.Type == Obj.type then
                    local ProcessedObj = {
                        type = Obj.type,
                        idx = Obj.idx,
                        value = Obj.value,
                        text = Obj.text,
                        keybind = Obj.keybind,
                        keybindMode = Obj.keybindMode,
                        rainbow = Obj.rainbow
                    };
                    if self.Parser[Obj.type] and self.Parser[Obj.type].Load then
                        pcall(function()
                            self.Parser[Obj.type].Load(Obj.idx, ProcessedObj);
                        end);
                    end;
                end;
            end;
        end;
        return true;
    end;

    function ConfigManager:BuildFolderTree()
        local Paths = {
            self.Folder,
            self.Folder .. "/settings",
            self.Folder .. "/autoload",
            self.Folder .. "/gameautoload"
        };
        for i = 1, #Paths do
            local Str = Paths[i];
            if not isfolder(Str) then
                makefolder(Str);
            end;
        end;
    end;

    function ConfigManager:RefreshConfigList()
        local List = listfiles(self.Folder .. "/settings");
        local Out = {};
        for i = 1, #List do
            local File = List[i];
            if File:sub(-4) == ".lua" then
                local Pos = File:find(".lua", 1, true);
                local Start = Pos;
                local Char = File:sub(Pos, Pos);
                while Char ~= "/" and Char ~= "\\" and Char ~= "" do
                    Pos = Pos - 1;
                    Char = File:sub(Pos, Pos);
                end;
                if Char == "/" or Char == "\\" then
                    table.insert(Out, File:sub(Pos + 1, Start - 1));
                end;
            end;
        end;
        return Out;
    end;

    function ConfigManager:SetLibrary(Library)
        self.Library = Library;
    end;

	function ConfigManager:SetWindow(Window)
        self.Window = Window;
    end;

    function ConfigManager:GetPlaceAutoloadConfig()
        local AutoloadFile = self.Folder .. "/autoload/" .. self.CurrentPlaceId .. ".txt";
        if isfile(AutoloadFile) then
            return readfile(AutoloadFile);
        end;
        return nil;
    end;

    function ConfigManager:SetPlaceAutoloadConfig(ConfigName: string)
        local AutoloadFile = self.Folder .. "/autoload/" .. self.CurrentPlaceId .. ".txt";
        writefile(AutoloadFile, ConfigName);
    end;

    function ConfigManager:GetGameAutoloadConfig()
        local AutoloadFile = self.Folder .. "/gameautoload/" .. self.CurrentGameId .. ".txt";
        if isfile(AutoloadFile) then
            return readfile(AutoloadFile);
        end;
        return nil;
    end;

    function ConfigManager:SetGameAutoloadConfig(ConfigName: string)
        local AutoloadFile = self.Folder .. "/gameautoload/" .. self.CurrentGameId .. ".txt";
        writefile(AutoloadFile, ConfigName);
    end;

    function ConfigManager:GetGlobalAutoloadConfig()
        if isfile(self.Folder .. "/settings/autoload.txt") then
            return readfile(self.Folder .. "/settings/autoload.txt");
        end;
        return nil;
    end;

    function ConfigManager:SetGlobalAutoloadConfig(ConfigName: string)
        writefile(self.Folder .. "/settings/autoload.txt", ConfigName);
    end;

    function ConfigManager:LoadAutoloadConfig()
        local PlaceAutoload = self:GetPlaceAutoloadConfig();
        if PlaceAutoload then
            local Success, Err = self:Load(PlaceAutoload);
            if Success then
                self.Window:Notify("Success", string.format("Auto loaded place-specific config %q (Place ID: %s)", PlaceAutoload, self.CurrentPlaceId), 5);
                return;
            else
                self.Window:Notify("Warning", "Failed to load place-specific autoload config: " .. Err, 5);
            end;
        end;
        local GameAutoload = self:GetGameAutoloadConfig();
        if GameAutoload then
            local Success, Err = self:Load(GameAutoload);
            if Success then
                self.Window:Notify("Success", string.format("Auto loaded game-specific config %q (Game ID: %s)", GameAutoload, self.CurrentGameId), 5);
                return;
            else
                self.Window:Notify("Warning", "Failed to load game-specific autoload config: " .. Err, 5);
            end;
        end;
        local GlobalAutoload = self:GetGlobalAutoloadConfig();
        if GlobalAutoload then
            local Success, Err = self:Load(GlobalAutoload);
            if Success then
                self.Window:Notify("Success", string.format("Auto loaded global config %q", GlobalAutoload), 5);
            else
                self.Window:Notify("Error", "Failed to load global autoload config: " .. Err, 5);
            end;
        end;
    end;

    function ConfigManager:DeleteConfig(Name: string)
        if not Name then return false, "No config file selected" end;
        local Path = self.Folder .. "/settings/" .. Name .. ".lua";
        if not isfile(Path) then return false, "Config file doesn't exist" end;
        pcall(delfile, Path);
        return true;
    end;

    function ConfigManager:BuildConfigSection(Tab)
        assert(self.Library, "Must set ConfigManager.Library");
        local Section = Tab:CreateSection("Configuration");
        local ConfigList = Section:CreateDropdown("Config list", self:RefreshConfigList(), function(Value) end);
        local ConfigName = Section:CreateTextBox("Config name", "Enter name...", false, function(Value) end);

        Section:CreateButton("Create config", function()
            local Name = ConfigName:GetValue();
            if Name:gsub(" ", "") == "" then 
                return self.Window:Notify("Warning", "Please enter a valid config name", 5);
            end;
            local Success, Err = self:Save(Name);
            if not Success then
                return self.Window:Notify("Error", "Failed to save config: " .. tostring(Err), 5);
            end;
            ConfigList:ClearOptions();
            for _, Config in pairs(self:RefreshConfigList()) do
                ConfigList:AddOption(Config);
            end;
            ConfigName:SetValue("");
            self.Window:Notify("Success", string.format("Saved config %q", Name), 5);
        end);
        
        Section:CreateButton("Load config", function()
            local Name = ConfigList:GetOption();
            if not Name then return self.Window:Notify("Warning", "Please select a config", 5) end;
            local Success, Err = self:Load(Name);
            if not Success then
                return self.Window:Notify("Error", "Failed to load config: " .. tostring(Err), 5);
            end;
            self.Window:Notify("Success", string.format("Loaded config %q", Name), 5);
        end);

        Section:CreateButton("Overwrite config", function()
            local Name = ConfigList:GetOption();
            if not Name then return self.Window:Notify("Warning", "Please select a config", 5) end;
            local Success, Err = self:Save(Name);
            if not Success then
                return self.Window:Notify("Error", "Failed to overwrite config: " .. tostring(Err), 5);
            end;
            self.Window:Notify("Success", string.format("Overwrote config %q", Name), 5);
        end);
        
        Section:CreateButton("Set place autoload", function()
            local Name = ConfigList:GetOption();
            if not Name then return self.Window:Notify("Warning", "Please select a config", 5) end;
            self:SetPlaceAutoloadConfig(Name);
            self.PlaceAutoloadLabel:UpdateText("Place autoload (" .. self.CurrentPlaceId .. "): " .. Name);
            self.Window:Notify("Success", string.format("Set %q as autoload config for Place ID %s", Name, self.CurrentPlaceId), 5);
        end);

        Section:CreateButton("Set game autoload", function()
            local Name = ConfigList:GetOption();
            if not Name then return self.Window:Notify("Warning", "Please select a config", 5) end;
            self:SetGameAutoloadConfig(Name);
            self.GameAutoloadLabel:UpdateText("Game autoload (" .. self.CurrentGameId .. "): " .. Name);
            self.Window:Notify("Success", string.format("Set %q as autoload config for Game ID %s", Name, self.CurrentGameId), 5);
        end);

        Section:CreateButton("Set global autoload", function()
            local Name = ConfigList:GetOption();
            if not Name then return self.Window:Notify("Warning", "Please select a config", 5) end;
            self:SetGlobalAutoloadConfig(Name);
            self.GlobalAutoloadLabel:UpdateText("Global autoload: " .. Name);
            self.Window:Notify("Success", string.format("Set %q as global autoload config", Name), 5);
        end);

        Section:CreateButton("Delete config", function()
            local Name = ConfigList:GetOption();
            if not Name then return self.Window:Notify("Warning", "Please select a config", 5) end;
            local Success, Err = self:DeleteConfig(Name);
            if not Success then
                return self.Window:Notify("Error", "Failed to delete config: " .. tostring(Err), 5);
            end;
            ConfigList:ClearOptions();
            for _, Config in pairs(self:RefreshConfigList()) do
                ConfigList:AddOption(Config);
            end;
            self.Window:Notify("Success", string.format("Deleted config %q", Name), 5);
        end);

        Section:CreateButton("Refresh config list", function()
            ConfigList:ClearOptions();
            for _, Config in pairs(self:RefreshConfigList()) do
                ConfigList:AddOption(Config);
            end;
            self.Window:Notify("Info", "Refreshed config list", 5);
        end);

        self.PlaceAutoloadLabel = Section:CreateLabel("Place autoload (" .. self.CurrentPlaceId .. "): none", true);
        self.GameAutoloadLabel = Section:CreateLabel("Game autoload (" .. self.CurrentGameId .. "): none", true);
        self.GlobalAutoloadLabel = Section:CreateLabel("Global autoload: none", true);
        local PlaceAutoload = self:GetPlaceAutoloadConfig();
        if PlaceAutoload then
            self.PlaceAutoloadLabel:UpdateText("Place autoload (" .. self.CurrentPlaceId .. "): " .. PlaceAutoload);
        end;
        local GameAutoload = self:GetGameAutoloadConfig();
        if GameAutoload then
            self.GameAutoloadLabel:UpdateText("Game autoload (" .. self.CurrentGameId .. "): " .. GameAutoload);
        end;
        local GlobalAutoload = self:GetGlobalAutoloadConfig();
        if GlobalAutoload then
            self.GlobalAutoloadLabel:UpdateText("Global autoload: " .. GlobalAutoload);
        end;

        self:SetIgnoreIndexes({ 
            ConfigList.UniqueID, 
            ConfigName.UniqueID,
            self.PlaceAutoloadLabel.UniqueID,
            self.GameAutoloadLabel.UniqueID,
            self.GlobalAutoloadLabel.UniqueID
        });
    end;

    ConfigManager:BuildFolderTree();
end;

return ConfigManager;
