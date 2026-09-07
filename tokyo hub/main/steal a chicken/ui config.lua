--unobfuscated


local FuncsV3 = {}

-- [FIX] Default-nya table kosong, bukan nil. Ini mencegah crash total
-- kalau ada orang lupa manggil SetTable() sebelum pakai Toggle/Dropdown/Textbox.
local SaveConfig = {}

-- [FIX] Versi lama pakai pola "A and B or C" yang punya jebakan klasik Lua:
-- kalau B (Val) itu tipe-nya benar tapi nilainya persis `false`, maka
-- "A and B" jadi false, sehingga fallback (Val2) yang malah dipakai,
-- padahal `false` itu valid. Sekarang dicek eksplisit pakai if/else.
local function Checker(Val, Val1, Val2)
  if typeof(Val) == Val1 then
    return Val
  end
  return Val2
end

-- [FIX] SafeGet: ambil value dari SaveConfig dengan aman.
-- Kalau SaveConfig nil atau key gak ada, balikin fallback tanpa error.
local function SafeGet(Key, Fallback)
  if SaveConfig == nil then
    return Fallback
  end

  local ok, Val = pcall(function()
    return SaveConfig[Key]
  end)

  if not ok or Val == nil then
    return Fallback
  end

  return Val
end

function FuncsV3:SetTable(path)
  SaveConfig = path or {}
end

function FuncsV3:Toggle(Tab, Name, Content, Default, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  Callback = Checker(Callback, "function", function() end)

  local _default = Default == "Save"
    and Checker(SafeGet(Name, false), "boolean", false)
    or Checker(Default, "boolean", false)

  return Tab:AddToggle({
    Title = Name,
    Content = Content,
    Default = _default,
    Callback = Callback
  })
end

function FuncsV3:Button(Tab, Name, Content, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  Callback = Checker(Callback, "function", function() end)

  return Tab:AddButton({
    Title = Name,
    Content = Content,
    Icon = "rbxassetid://16932740082",
    Callback = Callback
  })
end

function FuncsV3:Dropdown(Tab, Name, Content, multi, options, Default, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  multi = Checker(multi, "boolean", false)
  options = Checker(options, "table", { "" })
  Callback = Checker(Callback, "function", function() end)

  local _default

  if Default == "Save" then
    local Saved = SafeGet(Name, nil)
    if type(Saved) == "table" then
      _default = Saved
    elseif Saved ~= nil then
      _default = {Saved}
    else
      _default = {""}
    end
  else
    -- [FIX] Jangan baca SaveConfig kalau Default bukan "Save" -- dulu di sini
    -- selalu manggil SafeGet(Name, Default), jadi kalau ada leftover value di
    -- SaveConfig[Name] (misal dari config lama), itu diam-diam menimpa Default
    -- literal yang dikasih developer, padahal dia gak minta mode Save.
    if type(Default) == "table" then
      _default = Default
    else
      _default = {Default}
    end
  end

  return Tab:AddDropdown({
    Title = Name,
    Content = Content,
    Multi = multi,
    Options = options,
    Default = _default,
    Callback = Callback
  })
end

function FuncsV3:Textbox(Tab, Name, Content, Default, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  Callback = Checker(Callback, "function", function() end)

  local _default = Default == "Save"
    and Checker(SafeGet(Name, ""), "string", "")
    or Checker(Default, "string", "")

  return Tab:AddInput({
    Title = Name,
    Content = Content,
    Default = _default,
    Callback = Callback
  })
end

return FuncsV3
