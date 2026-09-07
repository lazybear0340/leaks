-- this shit was obfuscated with prometheus

local v1 = {}
v1["1"] = Instance.new("Folder")
v1["1"].Name = "Bracket"
v1["2"] = Instance.new("UIGradient", v1["1"])
v1["2"].Rotation = 90

v1["2"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
  ColorSequenceKeypoint.new(0.49, Color3.fromRGB(100, 100, 100)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150)),
})

v1["3"] = Instance.new("ScreenGui", v1["1"])
v1["3"].IgnoreGuiInset = true
v1["3"].ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
v1["3"].Name = "Bracket"
v1["3"].ResetOnSpawn = false
v1["4"] = Instance.new("Frame", v1["3"])
v1["4"].BorderSizePixel = 0
v1["4"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["4"].AnchorPoint = Vector2.new(0.5, 0.5)
v1["4"].Size = UDim2.new(0, 500, 0, 500)
v1["4"].Position = UDim2.new(0.5, 0, 0.5, 0)
v1["4"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["4"].Name = "Main"
v1["5"] = Instance.new("Frame", v1["4"])
v1["5"].ZIndex = 0
v1["5"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["5"].AnchorPoint = Vector2.new(0.5, 0.5)
v1["5"].Size = UDim2.new(1, 2, 1, 2)
v1["5"].Position = UDim2.new(0.5, 0, 0.5, 0)
v1["5"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["5"].Name = "Border"
v1["6"] = Instance.new("Frame", v1["4"])
v1["6"].BorderSizePixel = 0
v1["6"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["6"].AnchorPoint = Vector2.new(0.5, 0)
v1["6"].Size = UDim2.new(1, -10, 0, 15)
v1["6"].Position = UDim2.new(0.5, 0, 0, 0)
v1["6"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["6"].Name = "Topbar"
v1["6"].BackgroundTransparency = 1
v1["7"] = Instance.new("TextLabel", v1["6"])
v1["7"].TextStrokeTransparency = 0.75
v1["7"].BorderSizePixel = 0
v1["7"].TextXAlignment = Enum.TextXAlignment.Left
v1["7"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["7"].TextSize = 15

v1["7"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold,
  Enum.FontStyle.Normal
)

v1["7"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["7"].BackgroundTransparency = 1
v1["7"].AnchorPoint = Vector2.new(0.5, 0.5)
v1["7"].Size = UDim2.new(1, 0, 1, 0)
v1["7"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["7"].Text = "Window Name"
v1["7"].Name = "WindowName"
v1["7"].Position = UDim2.new(0.5, 0, 0.5, 0)
v1["8"] = Instance.new("TextLabel", v1["6"])
v1["8"].TextStrokeTransparency = 0.75
v1["8"].BorderSizePixel = 0
v1["8"].TextXAlignment = Enum.TextXAlignment.Right
v1["8"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["8"].TextSize = 15

v1["8"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["8"].TextColor3 = Color3.fromRGB(120, 120, 120)
v1["8"].BackgroundTransparency = 1
v1["8"].AnchorPoint = Vector2.new(0.5, 0.5)
v1["8"].Size = UDim2.new(1, 0, 1, 0)
v1["8"].Visible = false
v1["8"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["8"].Text = "Bracket"
v1["8"].Name = "LibraryName"
v1["8"].Position = UDim2.new(0.5, 0, 0.5, 0)
v1["9"] = Instance.new("TextBox", v1["6"])
v1["9"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["9"].PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
v1["9"].BorderSizePixel = 0
v1["9"].TextXAlignment = Enum.TextXAlignment.Left
v1["9"].TextWrapped = true
v1["9"].TextSize = 14
v1["9"].Name = "SearchBar"
v1["9"].BackgroundColor3 = Color3.fromRGB(40, 40, 40)

v1["9"].FontFace = Font.new(
  "rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["9"].AnchorPoint = Vector2.new(1, 0.5)
v1["9"].ClearTextOnFocus = false
v1["9"].ClipsDescendants = true
v1["9"].PlaceholderText = "Search"
v1["9"].Size = UDim2.new(0, 90, 0, 20)
v1["9"].Position = UDim2.new(0.95, -10, 0.6, 0)
v1["9"].Text = ""
v1["9"].BackgroundTransparency = 1
v1.a = Instance.new("TextButton", v1["9"])
v1.a.TextSize = 16
v1.a.TextColor3 = Color3.fromRGB(150, 150, 150)

v1.a.FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1.a.AnchorPoint = Vector2.new(1, 0.5)
v1.a.Size = UDim2.new(0, 20, 0, 20)
v1.a.BackgroundTransparency = 1
v1.a.Name = "ClearButton"
v1.a.Text = "✕"
v1.a.Visible = false
v1.a.Position = UDim2.new(1, -5, 0.5, 0)
v1.b = Instance.new("TextButton", v1["6"])
v1.b.TextSize = 20
v1.b.TextColor3 = Color3.fromRGB(150, 150, 150)
v1.b.AnchorPoint = Vector2.new(1, 0)
v1.b.Size = UDim2.new(0, 20, 0, 20)
v1.b.BackgroundTransparency = 1
v1.b.Name = "Close"
v1.b.Text = "×"
v1.b.Position = UDim2.new(1, 5, 0, 0)
v1.c = Instance.new("ImageLabel", v1["4"])
v1.c.ZIndex = 2
v1.c.BorderSizePixel = 0
v1.c.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1.c.ScaleType = Enum.ScaleType.Tile
v1.c.AnchorPoint = Vector2.new(0.5, 0)
v1.c.TileSize = UDim2.new(0, 500, 0, 500)
v1.c.Size = UDim2.new(1, -10, 1, -25)
v1.c.BorderColor3 = Color3.fromRGB(50, 50, 50)
v1.c.Name = "Holder"
v1.c.Position = UDim2.new(0.5, 0, 0, 20)
v1.d = Instance.new("Frame", v1.c)
v1.d.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1.d.AnchorPoint = Vector2.new(0.5, 0.5)
v1.d.Size = UDim2.new(1, 2, 1, 2)
v1.d.Position = UDim2.new(0.5, 0, 0.5, 0)
v1.d.BorderColor3 = Color3.fromRGB(0, 0, 0)
v1.d.Name = "Border"
v1.e = Instance.new("Frame", v1.c)
v1.e.ZIndex = 3
v1.e.BorderSizePixel = 0
v1.e.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1.e.AnchorPoint = Vector2.new(0.5, 0)
v1.e.Size = UDim2.new(1, -10, 0, 20)
v1.e.Position = UDim2.new(0.5, 0, 0, 5)
v1.e.BorderColor3 = Color3.fromRGB(50, 50, 50)
v1.e.Name = "TBContainer"
v1.f = Instance.new("Frame", v1.e)
v1.f.ZIndex = 2
v1.f.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1.f.AnchorPoint = Vector2.new(0.5, 0.5)
v1.f.Size = UDim2.new(1, 2, 1, 2)
v1.f.Position = UDim2.new(0.5, 0, 0.5, 0)
v1.f.BorderColor3 = Color3.fromRGB(0, 0, 0)
v1.f.Name = "Border"
v1["10"] = Instance.new("Frame", v1.e)
v1["10"].ZIndex = 3
v1["10"].BorderSizePixel = 0
v1["10"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["10"].AnchorPoint = Vector2.new(0.5, 0.5)
v1["10"].Size = UDim2.new(1, 0, 1, 0)
v1["10"].Position = UDim2.new(0.5, 0, 0.5, 0)
v1["10"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["10"].Name = "Holder"
v1["10"].BackgroundTransparency = 1
v1["11"] = Instance.new("UIListLayout", v1["10"])
v1["11"].VerticalAlignment = Enum.VerticalAlignment.Center
v1["11"].SortOrder = Enum.SortOrder.LayoutOrder
v1["11"].Name = "ListLayout"
v1["11"].FillDirection = Enum.FillDirection.Horizontal
v1["12"] = Instance.new("Frame", v1.c)
v1["12"].ZIndex = 2
v1["12"].BorderSizePixel = 0
v1["12"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["12"].AnchorPoint = Vector2.new(0.5, 0)
v1["12"].Size = UDim2.new(1, 0, 1, -25)
v1["12"].Position = UDim2.new(0.5, 0, 0, 25)
v1["12"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["12"].Name = "TContainer"
v1["12"].BackgroundTransparency = 1
v1["13"] = Instance.new("UIGradient", v1.c)
v1["13"].Rotation = 90

v1["13"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(0.534, Color3.fromRGB(80, 80, 80)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200)),
})

v1["14"] = Instance.new("TextLabel", v1["3"])
v1["14"].TextStrokeTransparency = 0.75
v1["14"].ZIndex = 5
v1["14"].BorderSizePixel = 0
v1["14"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["14"].TextSize = 15

v1["14"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["14"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["14"].BackgroundTransparency = 0.5
v1["14"].AnchorPoint = Vector2.new(0, 1)
v1["14"].Size = UDim2.new(0, 45, 0, 20)
v1["14"].Visible = false
v1["14"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["14"].Text = "ToolTip"
v1["14"].Name = "ToolTip"
v1["15"] = Instance.new("UICorner", v1["14"])
v1["15"].CornerRadius = UDim.new(0, 4)
v1["16"] = Instance.new("Frame", v1["1"])
v1["16"].BorderSizePixel = 0
v1["16"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["16"].Size = UDim2.new(0, 388, 0, 35)
v1["16"].Position = UDim2.new(1, -398, 0, 10)
v1["16"].Name = "Hud"
v1["17"] = Instance.new("Frame", v1["16"])
v1["17"].BorderSizePixel = 0
v1["17"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["17"].Size = UDim2.new(1, -2, 1, -2)
v1["17"].Position = UDim2.new(0, 1, 0, 1)
v1["17"].Name = "BorderFrame1"
v1["18"] = Instance.new("Frame", v1["17"])
v1["18"].BorderSizePixel = 0
v1["18"].BackgroundColor3 = Color3.fromRGB(60, 60, 60)
v1["18"].Size = UDim2.new(1, -2, 1, -2)
v1["18"].Position = UDim2.new(0, 1, 0, 1)
v1["18"].Name = "BorderFrame2"
v1["19"] = Instance.new("Frame", v1["18"])
v1["19"].BorderSizePixel = 0
v1["19"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["19"].Size = UDim2.new(1, -6, 1, -6)
v1["19"].Position = UDim2.new(0, 3, 0, 3)
v1["19"].Name = "BorderFrame3"
v1["1a"] = Instance.new("Frame", v1["19"])
v1["1a"].BorderSizePixel = 0
v1["1a"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
v1["1a"].Size = UDim2.new(1, -2, 1, -2)
v1["1a"].Position = UDim2.new(0, 1, 0, 1)
v1["1a"].Name = "InnerFrame"
v1["1b"] = Instance.new("Frame", v1["1a"])
v1["1b"].BorderSizePixel = 0
v1["1b"].BackgroundColor3 = Color3.fromRGB(120, 120, 120)
v1["1b"].Size = UDim2.new(1, 0, 0, 1)
v1["1b"].Name = "GradientFrame"
v1["1c"] = Instance.new("Frame", v1["1a"])
v1["1c"].BorderSizePixel = 0
v1["1c"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
v1["1c"].Size = UDim2.new(1, 0, 0, 1)
v1["1c"].Position = UDim2.new(0, 0, 0, 1)
v1["1c"].Name = "ShadowLine"
v1["1c"].BackgroundTransparency = 0.2
v1["1d"] = Instance.new("TextLabel", v1["1a"])
v1["1d"].TextSize = 14

v1["1d"].FontFace = Font.new(
  "rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["1d"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["1d"].BackgroundTransparency = 1
v1["1d"].RichText = true
v1["1d"].Size = UDim2.new(1, -12, 1, -4)
v1["1d"].Text = "<font color=\"rgb(200,200,200)\">game</font><font color=\"rgb(150,150,150)\">sense</font><font color=\"rgb(200,200,200)\"> | </font><font color=\"rgb(200,200,200)\">PerfectoExternal</font><font color=\"rgb(200,200,200)\"> | </font><font color=\"rgb(200,200,200)\">144fps</font><font color=\"rgb(200,200,200)\"> | </font><font color=\"rgb(200,200,200)\">72ms</font><font color=\"rgb(200,200,200)\"> | </font><font color=\"rgb(200,200,200)\">17:20</font>"
v1["1d"].Name = "InfoText"
v1["1d"].Position = UDim2.new(0, 6, 0, 2)
v1["1e"] = Instance.new("Frame", v1["1"])
v1["1e"].Visible = false
v1["1e"].ZIndex = 5
v1["1e"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["1e"].Size = UDim2.new(0, 150, 0, 240)
v1["1e"].Position = UDim2.new(0, 100, 0, 100)
v1["1e"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["1e"].Name = "Palette"
v1["1f"] = Instance.new("ImageButton", v1["1e"])
v1["1f"].AutoButtonColor = false
v1["1f"].BackgroundColor3 = Color3.fromRGB(150, 150, 150)
v1["1f"].ZIndex = 5
v1["1f"].Size = UDim2.new(1, -10, 0, 150)
v1["1f"].Name = "GradientPalette"
v1["1f"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["1f"].Position = UDim2.new(0, 5, 0, 5)
v1["20"] = Instance.new("Frame", v1["1f"])
v1["20"].ZIndex = 6
v1["20"].BorderSizePixel = 0
v1["20"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
v1["20"].Size = UDim2.new(1, 0, 1, 0)
v1["20"].Name = "SaturationOverlay"
v1["21"] = Instance.new("UIGradient", v1["20"])

v1["21"].Transparency = NumberSequence.new({
  NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1),
})

v1["22"] = Instance.new("Frame", v1["1f"])
v1["22"].ZIndex = 7
v1["22"].BorderSizePixel = 0
v1["22"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
v1["22"].Size = UDim2.new(1, 0, 1, 0)
v1["22"].Name = "BrightnessOverlay"
v1["23"] = Instance.new("UIGradient", v1["22"])
v1["23"].Rotation = 90

v1["23"].Transparency = NumberSequence.new({
  NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0),
})

v1["24"] = Instance.new("Frame", v1["1f"])
v1["24"].ZIndex = 8
v1["24"].BorderSizePixel = 2
v1["24"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
v1["24"].AnchorPoint = Vector2.new(0.5, 0.5)
v1["24"].Size = UDim2.new(0, 3, 0, 3)
v1["24"].Position = UDim2.new(1, 0, 0, 0)
v1["24"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["24"].Name = "Dot"
v1["24"].Rotation = 45
v1["25"] = Instance.new("TextButton", v1["1e"])
v1["25"].AutoButtonColor = false
v1["25"].TextSize = 14
v1["25"].TextColor3 = Color3.fromRGB(0, 0, 0)
v1["25"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

v1["25"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["25"].ZIndex = 5
v1["25"].AnchorPoint = Vector2.new(1, 0)
v1["25"].Size = UDim2.new(1, -10, 0, 10)
v1["25"].Name = "ColorSlider"
v1["25"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["25"].Text = ""
v1["25"].Position = UDim2.new(1, -5, 0, 160)
v1["26"] = Instance.new("UIGradient", v1["25"])
v1["26"].Name = "Gradient"

v1["26"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
  ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 0, 255)),
  ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 0, 255)),
  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
  ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 255, 0)),
  ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 255, 0)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
})

v1["27"] = Instance.new("TextButton", v1["1e"])
v1["27"].AutoButtonColor = false
v1["27"].TextSize = 14
v1["27"].TextColor3 = Color3.fromRGB(0, 0, 0)
v1["27"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

v1["27"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["27"].ZIndex = 5
v1["27"].AnchorPoint = Vector2.new(1, 0)
v1["27"].Size = UDim2.new(1, -10, 0, 10)
v1["27"].Name = "TransparencySlider"
v1["27"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["27"].Text = ""
v1["27"].Position = UDim2.new(1, -5, 0, 175)
v1["28"] = Instance.new("UIGradient", v1["27"])

v1["28"].Transparency = NumberSequence.new({
  NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1),
})

v1["28"].Name = "Gradient"
v1["29"] = Instance.new("Frame", v1["1e"])
v1["29"].ZIndex = 5
v1["29"].BackgroundColor3 = Color3.fromRGB(150, 150, 150)
v1["29"].AnchorPoint = Vector2.new(0.5, 0)
v1["29"].Size = UDim2.new(1, -10, 0, 20)
v1["29"].Position = UDim2.new(0.5, 0, 0, 190)
v1["29"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["29"].Name = "ColorPreview"
v1["2a"] = Instance.new("Frame", v1["1e"])
v1["2a"].ZIndex = 5
v1["2a"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["2a"].AnchorPoint = Vector2.new(0.5, 0)
v1["2a"].Size = UDim2.new(1, -10, 0, 20)
v1["2a"].Position = UDim2.new(0.5, 0, 0, 215)
v1["2a"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["2a"].Name = "InputFrame"
v1["2b"] = Instance.new("TextBox", v1["2a"])
v1["2b"].TextStrokeTransparency = 0.75
v1["2b"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["2b"].PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
v1["2b"].ZIndex = 5
v1["2b"].BorderSizePixel = 0
v1["2b"].TextWrapped = true
v1["2b"].TextSize = 12
v1["2b"].Name = "InputBox"
v1["2b"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["2b"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["2b"].PlaceholderText = "RGBA: 150, 150, 150, 255"
v1["2b"].Size = UDim2.new(1, 0, 1, 0)
v1["2b"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["2b"].Text = ""
v1["2b"].BackgroundTransparency = 1
v1["2c"] = Instance.new("Frame", v1["1"])
v1["2c"].ZIndex = 3
v1["2c"].BorderSizePixel = 0
v1["2c"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["2c"].Size = UDim2.new(1, 0, 0, 235)
v1["2c"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["2c"].Name = "Section"
v1["2d"] = Instance.new("Frame", v1["2c"])
v1["2d"].ZIndex = 2
v1["2d"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["2d"].AnchorPoint = Vector2.new(0.5, 0.5)
v1["2d"].Size = UDim2.new(1, 2, 1, 2)
v1["2d"].Position = UDim2.new(0.5, 0, 0.5, 0)
v1["2d"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["2d"].Name = "Border"
v1["2e"] = Instance.new("TextLabel", v1["2c"])
v1["2e"].TextStrokeTransparency = 0.75
v1["2e"].ZIndex = 3
v1["2e"].BorderSizePixel = 0
v1["2e"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["2e"].TextSize = 15

v1["2e"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["2e"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["2e"].Size = UDim2.new(0, 45, 0, 2)
v1["2e"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["2e"].Text = "Section"
v1["2e"].Name = "Title"
v1["2e"].Position = UDim2.new(0, 5, 0, -2)
v1["2f"] = Instance.new("Frame", v1["2c"])
v1["2f"].ZIndex = 3
v1["2f"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["2f"].AnchorPoint = Vector2.new(0.5, 0)
v1["2f"].Size = UDim2.new(1, 0, 1, -10)
v1["2f"].Position = UDim2.new(0.5, 0, 0, 10)
v1["2f"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["2f"].Name = "Container"
v1["2f"].BackgroundTransparency = 1
v1["30"] = Instance.new("UIListLayout", v1["2f"])
v1["30"].HorizontalAlignment = Enum.HorizontalAlignment.Center
v1["30"].Padding = UDim.new(0, 5)
v1["30"].SortOrder = Enum.SortOrder.LayoutOrder
v1["30"].Name = "ListLayout"
v1["31"] = Instance.new("UIGradient", v1["2c"])
v1["31"].Rotation = 90

v1["31"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
  ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120, 120, 120)),
  ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120, 120, 120)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["32"] = Instance.new("ScrollingFrame", v1["1"])
v1["32"].Active = true
v1["32"].ScrollingDirection = Enum.ScrollingDirection.Y
v1["32"].ZIndex = 2
v1["32"].BorderSizePixel = 0
v1["32"].CanvasSize = UDim2.new(0, 0, 0, 0)
v1["32"].ElasticBehavior = Enum.ElasticBehavior.Never
v1["32"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["32"].Name = "Tab"
v1["32"].AnchorPoint = Vector2.new(0.5, 0.5)
v1["32"].Size = UDim2.new(1, 0, 1, 0)
v1["32"].ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
v1["32"].Position = UDim2.new(0.5, 0, 0.5, 0)
v1["32"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["32"].ScrollBarThickness = 0
v1["32"].BackgroundTransparency = 1
v1["33"] = Instance.new("Frame", v1["32"])
v1["33"].ZIndex = 2
v1["33"].BorderSizePixel = 0
v1["33"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["33"].AnchorPoint = Vector2.new(1, 0)
v1["33"].Size = UDim2.new(0.5, -5, 1, 0)
v1["33"].Position = UDim2.new(1, -5, 0, 0)
v1["33"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["33"].Name = "RightSide"
v1["33"].BackgroundTransparency = 1
v1["34"] = Instance.new("UIPadding", v1["33"])
v1["34"].PaddingTop = UDim.new(0, 10)
v1["34"].Name = "Padding"
v1["34"].PaddingLeft = UDim.new(0, 3)
v1["35"] = Instance.new("UIListLayout", v1["33"])
v1["35"].HorizontalAlignment = Enum.HorizontalAlignment.Center
v1["35"].Padding = UDim.new(0, 10)
v1["35"].SortOrder = Enum.SortOrder.LayoutOrder
v1["35"].Name = "ListLayout"
v1["36"] = Instance.new("Frame", v1["32"])
v1["36"].ZIndex = 2
v1["36"].BorderSizePixel = 0
v1["36"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["36"].Size = UDim2.new(0.5, -5, 1, 0)
v1["36"].Position = UDim2.new(0, 5, 0, 0)
v1["36"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["36"].Name = "LeftSide"
v1["36"].BackgroundTransparency = 1
v1["37"] = Instance.new("UIPadding", v1["36"])
v1["37"].PaddingTop = UDim.new(0, 10)
v1["37"].PaddingRight = UDim.new(0, 3)
v1["37"].Name = "Padding"
v1["38"] = Instance.new("UIListLayout", v1["36"])
v1["38"].HorizontalAlignment = Enum.HorizontalAlignment.Center
v1["38"].Padding = UDim.new(0, 10)
v1["38"].SortOrder = Enum.SortOrder.LayoutOrder
v1["38"].Name = "ListLayout"
v1["39"] = Instance.new("TextButton", v1["1"])
v1["39"].TextStrokeTransparency = 0.75
v1["39"].AutoButtonColor = false
v1["39"].TextSize = 15
v1["39"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["39"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)

v1["39"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["39"].ZIndex = 3
v1["39"].Size = UDim2.new(1, -10, 0, 20)
v1["39"].Name = "Button"
v1["39"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["39"].Text = ""
v1["3a"] = Instance.new("TextLabel", v1["39"])
v1["3a"].TextStrokeTransparency = 0.75
v1["3a"].ZIndex = 3
v1["3a"].BorderSizePixel = 0
v1["3a"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["3a"].TextSize = 15

v1["3a"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["3a"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["3a"].BackgroundTransparency = 1
v1["3a"].Size = UDim2.new(1, 0, 1, 0)
v1["3a"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["3a"].Text = "Button"
v1["3a"].Name = "Title"
v1["3b"] = Instance.new("UIGradient", v1["39"])
v1["3b"].Rotation = 90
v1["3b"].Name = "Gradient"

v1["3b"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["3c"] = Instance.new("TextButton", v1["39"])
v1["3c"].TextStrokeTransparency = 0.75
v1["3c"].BorderSizePixel = 0
v1["3c"].TextXAlignment = Enum.TextXAlignment.Right
v1["3c"].TextSize = 15
v1["3c"].TextColor3 = Color3.fromRGB(120, 120, 120)
v1["3c"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["3c"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["3c"].ZIndex = 3
v1["3c"].AnchorPoint = Vector2.new(1, 0.5)
v1["3c"].Size = UDim2.new(0, 51, 1, 0)
v1["3c"].BackgroundTransparency = 1
v1["3c"].Name = "Keybind"
v1["3c"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["3c"].Text = " NONE "
v1["3c"].Visible = false
v1["3c"].Position = UDim2.new(1, 0, 0.5, 0)
v1["3d"] = Instance.new("TextButton", v1["1"])
v1["3d"].TextStrokeTransparency = 0.75
v1["3d"].BorderSizePixel = 0
v1["3d"].AutoButtonColor = false
v1["3d"].TextSize = 15
v1["3d"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["3d"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["3d"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["3d"].ZIndex = 3
v1["3d"].Size = UDim2.new(1, -10, 0, 20)
v1["3d"].BackgroundTransparency = 1
v1["3d"].Name = "Colorpicker"
v1["3d"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["3d"].Text = ""
v1["3e"] = Instance.new("TextLabel", v1["3d"])
v1["3e"].TextStrokeTransparency = 0.75
v1["3e"].ZIndex = 3
v1["3e"].BorderSizePixel = 0
v1["3e"].TextXAlignment = Enum.TextXAlignment.Left
v1["3e"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["3e"].TextSize = 15

v1["3e"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["3e"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["3e"].BackgroundTransparency = 1
v1["3e"].AnchorPoint = Vector2.new(0, 0.5)
v1["3e"].Size = UDim2.new(1, 0, 1, 0)
v1["3e"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["3e"].Text = "Colorpicker"
v1["3e"].Name = "Title"
v1["3e"].Position = UDim2.new(0, 0, 0.5, 0)
v1["3f"] = Instance.new("Frame", v1["3d"])
v1["3f"].ZIndex = 3
v1["3f"].BackgroundColor3 = Color3.fromRGB(150, 150, 150)
v1["3f"].AnchorPoint = Vector2.new(1, 0.5)
v1["3f"].Size = UDim2.new(0, 20, 0, 10)
v1["3f"].Position = UDim2.new(1, 0, 0.5, 0)
v1["3f"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["3f"].Name = "Color"
v1["40"] = Instance.new("UIGradient", v1["3f"])
v1["40"].Rotation = 90
v1["40"].Name = "Gradient"

v1["40"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["41"] = Instance.new("TextButton", v1["1"])
v1["41"].TextStrokeTransparency = 0.75
v1["41"].BorderSizePixel = 0
v1["41"].AutoButtonColor = false
v1["41"].TextSize = 15
v1["41"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["41"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["41"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["41"].ZIndex = 3
v1["41"].Size = UDim2.new(1, -10, 0, 40)
v1["41"].BackgroundTransparency = 1
v1["41"].Name = "Dropdown"
v1["41"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["41"].Text = ""
v1["42"] = Instance.new("TextLabel", v1["41"])
v1["42"].TextStrokeTransparency = 0.75
v1["42"].ZIndex = 3
v1["42"].BorderSizePixel = 0
v1["42"].TextXAlignment = Enum.TextXAlignment.Left
v1["42"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["42"].TextSize = 15

v1["42"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["42"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["42"].BackgroundTransparency = 1
v1["42"].Size = UDim2.new(1, 0, 0, 20)
v1["42"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["42"].Text = "Dropdown"
v1["42"].Name = "Title"
v1["43"] = Instance.new("Frame", v1["41"])
v1["43"].ZIndex = 3
v1["43"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["43"].Size = UDim2.new(1, 0, 0, 20)
v1["43"].Position = UDim2.new(0, 0, 0, 20)
v1["43"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["43"].Name = "Container"
v1["44"] = Instance.new("TextLabel", v1["43"])
v1["44"].TextStrokeTransparency = 0.75
v1["44"].ZIndex = 3
v1["44"].BorderSizePixel = 0
v1["44"].TextXAlignment = Enum.TextXAlignment.Left
v1["44"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["44"].TextSize = 15

v1["44"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["44"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["44"].BackgroundTransparency = 1
v1["44"].AnchorPoint = Vector2.new(0.5, 0)
v1["44"].Size = UDim2.new(1, -10, 0, 20)
v1["44"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["44"].Text = "..."
v1["44"].Name = "Value"
v1["44"].Position = UDim2.new(0.5, 0, 0, 0)
v1["45"] = Instance.new("Frame", v1["43"])
v1["45"].Visible = false
v1["45"].ZIndex = 3
v1["45"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["45"].AnchorPoint = Vector2.new(0.5, 0)
v1["45"].Size = UDim2.new(1, 0, 0, 0)
v1["45"].Position = UDim2.new(0.5, 0, 0, 25)
v1["45"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["45"].Name = "Holder"
v1["46"] = Instance.new("Frame", v1["45"])
v1["46"].ZIndex = 3
v1["46"].BorderSizePixel = 0
v1["46"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["46"].Size = UDim2.new(1, 0, 1, 0)
v1["46"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["46"].Name = "Container"
v1["46"].BackgroundTransparency = 1
v1["47"] = Instance.new("UIListLayout", v1["46"])
v1["47"].HorizontalAlignment = Enum.HorizontalAlignment.Center
v1["47"].SortOrder = Enum.SortOrder.LayoutOrder
v1["47"].Name = "ListLayout"
v1["48"] = Instance.new("UIGradient", v1["46"])
v1["48"].Rotation = 90

v1["48"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
  ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120, 120, 120)),
  ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120, 120, 120)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["49"] = Instance.new("UIGradient", v1["45"])
v1["49"].Rotation = 90
v1["49"].Name = "Gradient"

v1["49"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["4a"] = Instance.new("UIGradient", v1["43"])
v1["4a"].Rotation = 90
v1["4a"].Name = "Gradient"

v1["4a"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["4b"] = Instance.new("TextButton", v1["1"])
v1["4b"].TextStrokeTransparency = 0.75
v1["4b"].BorderSizePixel = 0
v1["4b"].AutoButtonColor = false
v1["4b"].TextSize = 15
v1["4b"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["4b"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

v1["4b"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["4b"].ZIndex = 4
v1["4b"].Size = UDim2.new(1, 0, 0, 20)
v1["4b"].BackgroundTransparency = 1
v1["4b"].Name = "Option"
v1["4b"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["4b"].Text = ""
v1["4c"] = Instance.new("TextLabel", v1["4b"])
v1["4c"].TextStrokeTransparency = 0.75
v1["4c"].ZIndex = 4
v1["4c"].BorderSizePixel = 0
v1["4c"].TextXAlignment = Enum.TextXAlignment.Left
v1["4c"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["4c"].TextSize = 15

v1["4c"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["4c"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["4c"].BackgroundTransparency = 1
v1["4c"].AnchorPoint = Vector2.new(0, 0.5)
v1["4c"].Size = UDim2.new(1, -10, 0, 20)
v1["4c"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["4c"].Text = "Option"
v1["4c"].Name = "Title"
v1["4c"].Position = UDim2.new(0, 0, 0.5, 0)
v1["4d"] = Instance.new("TextButton", v1["1"])
v1["4d"].TextStrokeTransparency = 0.75
v1["4d"].BorderSizePixel = 0
v1["4d"].AutoButtonColor = false
v1["4d"].TextSize = 15
v1["4d"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["4d"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["4d"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["4d"].ZIndex = 4
v1["4d"].Size = UDim2.new(1, -10, 0, 30)
v1["4d"].BackgroundTransparency = 1
v1["4d"].Name = "Slider"
v1["4d"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["4d"].Text = ""
v1["4e"] = Instance.new("TextLabel", v1["4d"])
v1["4e"].TextStrokeTransparency = 0.75
v1["4e"].ZIndex = 3
v1["4e"].BorderSizePixel = 0
v1["4e"].TextXAlignment = Enum.TextXAlignment.Left
v1["4e"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["4e"].TextSize = 15

v1["4e"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["4e"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["4e"].BackgroundTransparency = 1
v1["4e"].Size = UDim2.new(1, 0, 0, 20)
v1["4e"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["4e"].Text = "Slider"
v1["4e"].Name = "Title"
v1["4f"] = Instance.new("Frame", v1["4d"])
v1["4f"].ZIndex = 3
v1["4f"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["4f"].AnchorPoint = Vector2.new(0, 1)
v1["4f"].Size = UDim2.new(1, 0, 0, 10)
v1["4f"].Position = UDim2.new(0, 0, 1, 0)
v1["4f"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["4f"].Name = "Slider"
v1["50"] = Instance.new("Frame", v1["4f"])
v1["50"].ZIndex = 3
v1["50"].BorderSizePixel = 0
v1["50"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
v1["50"].AnchorPoint = Vector2.new(0, 0.5)
v1["50"].Size = UDim2.new(0.5, 0, 1, 0)
v1["50"].Position = UDim2.new(0, 0, 0.5, 0)
v1["50"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["50"].Name = "Bar"
v1["51"] = Instance.new("UIGradient", v1["50"])
v1["51"].Rotation = 90
v1["51"].Name = "Gradient"

v1["51"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["52"] = Instance.new("UIGradient", v1["4f"])
v1["52"].Rotation = 90
v1["52"].Name = "Gradient"

v1["52"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["53"] = Instance.new("TextBox", v1["4d"])
v1["53"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["53"].PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
v1["53"].ZIndex = 3
v1["53"].BorderSizePixel = 0
v1["53"].TextXAlignment = Enum.TextXAlignment.Right
v1["53"].TextWrapped = true
v1["53"].TextSize = 15
v1["53"].Name = "Value"
v1["53"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["53"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["53"].AnchorPoint = Vector2.new(0, 1)
v1["53"].PlaceholderText = "50"
v1["53"].Size = UDim2.new(1, 0, 0, 20)
v1["53"].Position = UDim2.new(0, 0, 1, -10)
v1["53"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["53"].Text = ""
v1["53"].BackgroundTransparency = 1
v1["54"] = Instance.new("TextButton", v1["1"])
v1["54"].TextWrapped = true
v1["54"].TextStrokeTransparency = 0.75
v1["54"].BorderSizePixel = 0
v1["54"].AutoButtonColor = false
v1["54"].TextSize = 15
v1["54"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["54"].BackgroundColor3 = Color3.fromRGB(200, 200, 200)

v1["54"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["54"].ZIndex = 3
v1["54"].Size = UDim2.new(0, 240, 1, 0)
v1["54"].Name = "TabButton"
v1["54"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["54"].Text = ""
v1["55"] = Instance.new("TextLabel", v1["54"])
v1["55"].TextWrapped = true
v1["55"].TextStrokeTransparency = 0.75
v1["55"].ZIndex = 3
v1["55"].BorderSizePixel = 0
v1["55"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["55"].TextSize = 15

v1["55"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["55"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["55"].BackgroundTransparency = 1
v1["55"].AnchorPoint = Vector2.new(0.5, 0.5)
v1["55"].Size = UDim2.new(1, 0, 1, 0)
v1["55"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["55"].Text = "Tab Button"
v1["55"].Name = "Title"
v1["55"].Position = UDim2.new(0.5, 0, 0.5, 0)
v1["56"] = Instance.new("UIGradient", v1["54"])
v1["56"].Rotation = 90
v1["56"].Name = "Gradient"

v1["56"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["57"] = Instance.new("TextButton", v1["1"])
v1["57"].TextStrokeTransparency = 0.75
v1["57"].BorderSizePixel = 0
v1["57"].AutoButtonColor = false
v1["57"].TextSize = 15
v1["57"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["57"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["57"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["57"].ZIndex = 4
v1["57"].Size = UDim2.new(1, -10, 0, 40)
v1["57"].BackgroundTransparency = 1
v1["57"].Name = "TextBox"
v1["57"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["57"].Text = ""
v1["58"] = Instance.new("TextLabel", v1["57"])
v1["58"].TextStrokeTransparency = 0.75
v1["58"].ZIndex = 3
v1["58"].BorderSizePixel = 0
v1["58"].TextXAlignment = Enum.TextXAlignment.Left
v1["58"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["58"].TextSize = 15

v1["58"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["58"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["58"].BackgroundTransparency = 1
v1["58"].Size = UDim2.new(1, 0, 0, 20)
v1["58"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["58"].Text = "TextBox"
v1["58"].Name = "Title"
v1["59"] = Instance.new("Frame", v1["57"])
v1["59"].ZIndex = 3
v1["59"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["59"].AnchorPoint = Vector2.new(0, 1)
v1["59"].Size = UDim2.new(1, 0, 0, 20)
v1["59"].Position = UDim2.new(0, 0, 1, 0)
v1["59"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["59"].Name = "Background"
v1["5a"] = Instance.new("TextBox", v1["59"])
v1["5a"].TextStrokeTransparency = 0.75
v1["5a"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["5a"].PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
v1["5a"].ZIndex = 4
v1["5a"].TextWrapped = true
v1["5a"].TextSize = 15
v1["5a"].Name = "Input"
v1["5a"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)

v1["5a"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["5a"].AnchorPoint = Vector2.new(0.5, 0.5)
v1["5a"].ClearTextOnFocus = false
v1["5a"].Size = UDim2.new(1, 0, 1, 0)
v1["5a"].Position = UDim2.new(0.5, 0, 0.5, 0)
v1["5a"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["5a"].Text = ""
v1["5a"].BackgroundTransparency = 1
v1["5b"] = Instance.new("UIGradient", v1["59"])
v1["5b"].Rotation = 90
v1["5b"].Name = "Gradient"

v1["5b"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["5c"] = Instance.new("TextButton", v1["1"])
v1["5c"].TextStrokeTransparency = 0.75
v1["5c"].BorderSizePixel = 0
v1["5c"].AutoButtonColor = false
v1["5c"].TextSize = 15
v1["5c"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["5c"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["5c"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["5c"].ZIndex = 3
v1["5c"].Size = UDim2.new(1, -10, 0, 20)
v1["5c"].BackgroundTransparency = 1
v1["5c"].Name = "Toggle"
v1["5c"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["5c"].Text = ""
v1["5d"] = Instance.new("Frame", v1["5c"])
v1["5d"].ZIndex = 3
v1["5d"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["5d"].AnchorPoint = Vector2.new(0, 0.5)
v1["5d"].Size = UDim2.new(0, 10, 0, 10)
v1["5d"].Position = UDim2.new(0, 0, 0.5, 0)
v1["5d"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["5d"].Name = "Toggle"
v1["5e"] = Instance.new("UIGradient", v1["5d"])
v1["5e"].Rotation = 90
v1["5e"].Name = "Gradient"

v1["5e"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["5f"] = Instance.new("TextLabel", v1["5c"])
v1["5f"].TextStrokeTransparency = 0.75
v1["5f"].ZIndex = 3
v1["5f"].BorderSizePixel = 0
v1["5f"].TextXAlignment = Enum.TextXAlignment.Left
v1["5f"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["5f"].TextSize = 15

v1["5f"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["5f"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["5f"].BackgroundTransparency = 1
v1["5f"].AnchorPoint = Vector2.new(0, 0.5)
v1["5f"].Size = UDim2.new(1, -66, 1, 0)
v1["5f"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["5f"].Text = "Toggle"
v1["5f"].Name = "Title"
v1["5f"].Position = UDim2.new(0, 15, 0.5, 0)
v1["60"] = Instance.new("TextButton", v1["5c"])
v1["60"].TextStrokeTransparency = 0.75
v1["60"].BorderSizePixel = 0
v1["60"].TextXAlignment = Enum.TextXAlignment.Right
v1["60"].TextSize = 15
v1["60"].TextColor3 = Color3.fromRGB(120, 120, 120)
v1["60"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["60"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["60"].ZIndex = 3
v1["60"].AnchorPoint = Vector2.new(1, 0.5)
v1["60"].Size = UDim2.new(0, 51, 1, 0)
v1["60"].BackgroundTransparency = 1
v1["60"].Name = "Keybind"
v1["60"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["60"].Text = " NONE "
v1["60"].Visible = false
v1["60"].Position = UDim2.new(1, 0, 0.5, 0)
v1["61"] = Instance.new("Frame", v1["5c"])
v1["61"].Visible = false
v1["61"].ZIndex = 23
v1["61"].BorderSizePixel = 0
v1["61"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["61"].Size = UDim2.new(0, 120, 0, 80)
v1["61"].Position = UDim2.new(0, 205, 1, 5)
v1["61"].Name = "ModePopup"
v1["62"] = Instance.new("Frame", v1["61"])
v1["62"].ZIndex = 24
v1["62"].BorderSizePixel = 0
v1["62"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["62"].Size = UDim2.new(1, -2, 1, -2)
v1["62"].Position = UDim2.new(0, 1, 0, 1)
v1["62"].Name = "BorderFrame1"
v1["63"] = Instance.new("Frame", v1["62"])
v1["63"].ZIndex = 25
v1["63"].BorderSizePixel = 0
v1["63"].BackgroundColor3 = Color3.fromRGB(60, 60, 60)
v1["63"].Size = UDim2.new(1, -2, 1, -2)
v1["63"].Position = UDim2.new(0, 1, 0, 1)
v1["63"].Name = "BorderFrame2"
v1["64"] = Instance.new("Frame", v1["63"])
v1["64"].ZIndex = 26
v1["64"].BorderSizePixel = 0
v1["64"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["64"].Size = UDim2.new(1, -6, 1, -6)
v1["64"].Position = UDim2.new(0, 3, 0, 3)
v1["64"].Name = "BorderFrame3"
v1["65"] = Instance.new("Frame", v1["64"])
v1["65"].ZIndex = 27
v1["65"].BorderSizePixel = 0
v1["65"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
v1["65"].Size = UDim2.new(1, -2, 1, -2)
v1["65"].Position = UDim2.new(0, 1, 0, 1)
v1["65"].Name = "InnerFrame"
v1["66"] = Instance.new("Frame", v1["65"])
v1["66"].ZIndex = 28
v1["66"].BorderSizePixel = 0
v1["66"].BackgroundColor3 = Color3.fromRGB(120, 120, 120)
v1["66"].Size = UDim2.new(1, 0, 0, 1)
v1["66"].Name = "GradientFrame"
v1["67"] = Instance.new("Frame", v1["65"])
v1["67"].ZIndex = 28
v1["67"].BorderSizePixel = 0
v1["67"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
v1["67"].Size = UDim2.new(1, 0, 0, 1)
v1["67"].Position = UDim2.new(0, 0, 0, 1)
v1["67"].Name = "ShadowLine"
v1["67"].BackgroundTransparency = 0.2
v1["68"] = Instance.new("TextLabel", v1["65"])
v1["68"].ZIndex = 28
v1["68"].TextXAlignment = Enum.TextXAlignment.Left
v1["68"].TextSize = 14

v1["68"].FontFace = Font.new(
  "rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["68"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["68"].BackgroundTransparency = 1
v1["68"].Size = UDim2.new(1, -10, 0, 20)
v1["68"].Text = "Keybind Mode"
v1["68"].Name = "Title"
v1["68"].Position = UDim2.new(0, 5, 0, 5)
v1["69"] = Instance.new("TextButton", v1["65"])
v1["69"].BorderSizePixel = 0
v1["69"].TextSize = 14
v1["69"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["69"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["69"].FontFace = Font.new(
  "rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["69"].ZIndex = 28
v1["69"].Size = UDim2.new(1, -10, 0, 10)
v1["69"].BackgroundTransparency = 1
v1["69"].Name = "ToggleMode"
v1["69"].BorderColor3 = Color3.fromRGB(150, 150, 150)
v1["69"].Text = "Toggle"
v1["69"].Position = UDim2.new(0, 5, 0, 25)
v1["6a"] = Instance.new("TextButton", v1["65"])
v1["6a"].BorderSizePixel = 0
v1["6a"].TextSize = 14
v1["6a"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["6a"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["6a"].FontFace = Font.new(
  "rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["6a"].ZIndex = 28
v1["6a"].Size = UDim2.new(1, -10, 0, 10)
v1["6a"].BackgroundTransparency = 1
v1["6a"].Name = "HoldMode"
v1["6a"].BorderColor3 = Color3.fromRGB(150, 150, 150)
v1["6a"].Text = "Hold"
v1["6a"].Position = UDim2.new(0, 5, 0, 40)
v1["6b"] = Instance.new("TextButton", v1["65"])
v1["6b"].BorderSizePixel = 0
v1["6b"].TextSize = 14
v1["6b"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["6b"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["6b"].FontFace = Font.new(
  "rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["6b"].ZIndex = 28
v1["6b"].Size = UDim2.new(1, -10, 0, 10)
v1["6b"].BackgroundTransparency = 1
v1["6b"].Name = "RemoveKeybind"
v1["6b"].BorderColor3 = Color3.fromRGB(150, 150, 150)
v1["6b"].Text = "Remove"
v1["6b"].Position = UDim2.new(0, 5, 0, 55)
v1["6c"] = Instance.new("TextButton", v1["1"])
v1["6c"].TextStrokeTransparency = 0.75
v1["6c"].BorderSizePixel = 0
v1["6c"].AutoButtonColor = false
v1["6c"].TextSize = 15
v1["6c"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["6c"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["6c"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["6c"].ZIndex = 3
v1["6c"].Size = UDim2.new(1, -10, 0, 20)
v1["6c"].BackgroundTransparency = 1
v1["6c"].Name = "ToggleWColorpicker"
v1["6c"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["6c"].Text = ""
v1["6d"] = Instance.new("Frame", v1["6c"])
v1["6d"].ZIndex = 3
v1["6d"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["6d"].AnchorPoint = Vector2.new(0, 0.5)
v1["6d"].Size = UDim2.new(0, 10, 0, 10)
v1["6d"].Position = UDim2.new(0, 0, 0.5, 0)
v1["6d"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["6d"].Name = "Toggle"
v1["6e"] = Instance.new("UIGradient", v1["6d"])
v1["6e"].Rotation = 90
v1["6e"].Name = "Gradient"

v1["6e"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["6f"] = Instance.new("TextLabel", v1["6c"])
v1["6f"].TextStrokeTransparency = 0.75
v1["6f"].ZIndex = 3
v1["6f"].BorderSizePixel = 0
v1["6f"].TextXAlignment = Enum.TextXAlignment.Left
v1["6f"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["6f"].TextSize = 15

v1["6f"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["6f"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["6f"].BackgroundTransparency = 1
v1["6f"].AnchorPoint = Vector2.new(0, 0.5)
v1["6f"].Size = UDim2.new(1, -66, 1, 0)
v1["6f"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["6f"].Text = "Toggle"
v1["6f"].Name = "Title"
v1["6f"].Position = UDim2.new(0, 15, 0.5, 0)
v1["70"] = Instance.new("TextButton", v1["6c"])
v1["70"].TextStrokeTransparency = 0.75
v1["70"].BorderSizePixel = 0
v1["70"].TextXAlignment = Enum.TextXAlignment.Right
v1["70"].TextSize = 15
v1["70"].TextColor3 = Color3.fromRGB(120, 120, 120)
v1["70"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["70"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["70"].ZIndex = 3
v1["70"].AnchorPoint = Vector2.new(1, 0.5)
v1["70"].Size = UDim2.new(0, 51, 1, 0)
v1["70"].BackgroundTransparency = 1
v1["70"].Name = "Keybind"
v1["70"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["70"].Text = " NONE "
v1["70"].Visible = false
v1["70"].Position = UDim2.new(1, 0, 0.5, 0)
v1["71"] = Instance.new("Frame", v1["6c"])
v1["71"].Visible = false
v1["71"].ZIndex = 23
v1["71"].BorderSizePixel = 0
v1["71"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["71"].Size = UDim2.new(0, 120, 0, 80)
v1["71"].Position = UDim2.new(0, 205, 1, 5)
v1["71"].Name = "ModePopup"
v1["72"] = Instance.new("Frame", v1["71"])
v1["72"].ZIndex = 24
v1["72"].BorderSizePixel = 0
v1["72"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["72"].Size = UDim2.new(1, -2, 1, -2)
v1["72"].Position = UDim2.new(0, 1, 0, 1)
v1["72"].Name = "BorderFrame1"
v1["73"] = Instance.new("Frame", v1["72"])
v1["73"].ZIndex = 25
v1["73"].BorderSizePixel = 0
v1["73"].BackgroundColor3 = Color3.fromRGB(60, 60, 60)
v1["73"].Size = UDim2.new(1, -2, 1, -2)
v1["73"].Position = UDim2.new(0, 1, 0, 1)
v1["73"].Name = "BorderFrame2"
v1["74"] = Instance.new("Frame", v1["73"])
v1["74"].ZIndex = 26
v1["74"].BorderSizePixel = 0
v1["74"].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
v1["74"].Size = UDim2.new(1, -6, 1, -6)
v1["74"].Position = UDim2.new(0, 3, 0, 3)
v1["74"].Name = "BorderFrame3"
v1["75"] = Instance.new("Frame", v1["74"])
v1["75"].ZIndex = 27
v1["75"].BorderSizePixel = 0
v1["75"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
v1["75"].Size = UDim2.new(1, -2, 1, -2)
v1["75"].Position = UDim2.new(0, 1, 0, 1)
v1["75"].Name = "InnerFrame"
v1["76"] = Instance.new("Frame", v1["75"])
v1["76"].ZIndex = 28
v1["76"].BorderSizePixel = 0
v1["76"].BackgroundColor3 = Color3.fromRGB(120, 120, 120)
v1["76"].Size = UDim2.new(1, 0, 0, 1)
v1["76"].Name = "GradientFrame"
v1["78"] = Instance.new("Frame", v1["75"])
v1["78"].ZIndex = 28
v1["78"].BorderSizePixel = 0
v1["78"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
v1["78"].Size = UDim2.new(1, 0, 0, 1)
v1["78"].Position = UDim2.new(0, 0, 0, 1)
v1["78"].Name = "ShadowLine"
v1["78"].BackgroundTransparency = 0.2
v1["79"] = Instance.new("TextLabel", v1["75"])
v1["79"].ZIndex = 28
v1["79"].TextXAlignment = Enum.TextXAlignment.Left
v1["79"].TextSize = 14

v1["79"].FontFace = Font.new(
  "rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["79"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["79"].BackgroundTransparency = 1
v1["79"].Size = UDim2.new(1, -10, 0, 20)
v1["79"].Text = "Keybind Mode"
v1["79"].Name = "Title"
v1["79"].Position = UDim2.new(0, 5, 0, 5)
v1["7a"] = Instance.new("TextButton", v1["75"])
v1["7a"].BorderSizePixel = 0
v1["7a"].TextSize = 14
v1["7a"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["7a"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["7a"].FontFace = Font.new(
  "rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["7a"].ZIndex = 28
v1["7a"].Size = UDim2.new(1, -10, 0, 10)
v1["7a"].BackgroundTransparency = 1
v1["7a"].Name = "ToggleMode"
v1["7a"].BorderColor3 = Color3.fromRGB(150, 150, 150)
v1["7a"].Text = "Toggle"
v1["7a"].Position = UDim2.new(0, 5, 0, 25)
v1["7b"] = Instance.new("TextButton", v1["75"])
v1["7b"].BorderSizePixel = 0
v1["7b"].TextSize = 14
v1["7b"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["7b"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["7b"].FontFace = Font.new(
  "rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["7b"].ZIndex = 28
v1["7b"].Size = UDim2.new(1, -10, 0, 10)
v1["7b"].BackgroundTransparency = 1
v1["7b"].Name = "HoldMode"
v1["7b"].BorderColor3 = Color3.fromRGB(150, 150, 150)
v1["7b"].Text = "Hold"
v1["7b"].Position = UDim2.new(0, 5, 0, 40)
v1["7c"] = Instance.new("TextButton", v1["75"])
v1["7c"].BorderSizePixel = 0
v1["7c"].TextSize = 14
v1["7c"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["7c"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)

v1["7c"].FontFace = Font.new(
  "rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["7c"].ZIndex = 28
v1["7c"].Size = UDim2.new(1, -10, 0, 10)
v1["7c"].BackgroundTransparency = 1
v1["7c"].Name = "RemoveKeybind"
v1["7c"].BorderColor3 = Color3.fromRGB(150, 150, 150)
v1["7c"].Text = "Remove"
v1["7c"].Position = UDim2.new(0, 5, 0, 55)
v1["7d"] = Instance.new("Frame", v1["6c"])
v1["7d"].ZIndex = 3
v1["7d"].BackgroundColor3 = Color3.fromRGB(150, 150, 150)
v1["7d"].AnchorPoint = Vector2.new(1, 0.5)
v1["7d"].Size = UDim2.new(0, 20, 0, 10)
v1["7d"].Position = UDim2.new(1, 0, 0.5, 0)
v1["7d"].BorderColor3 = Color3.fromRGB(0, 0, 0)
v1["7d"].Name = "Color"
v1["7e"] = Instance.new("UIGradient", v1["7d"])
v1["7e"].Rotation = 90
v1["7e"].Name = "Gradient"

v1["7e"].Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})

v1["7f"] = Instance.new("TextLabel", v1["1"])
v1["7f"].TextStrokeTransparency = 0.75
v1["7f"].ZIndex = 3
v1["7f"].BorderSizePixel = 0
v1["7f"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
v1["7f"].TextSize = 15

v1["7f"].FontFace = Font.new(
  "rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal
)

v1["7f"].TextColor3 = Color3.fromRGB(200, 200, 200)
v1["7f"].BackgroundTransparency = 1
v1["7f"].Size = UDim2.new(1, -10, 0, 15)
v1["7f"].BorderColor3 = Color3.fromRGB(50, 50, 50)
v1["7f"].Text = "Text Label"
v1["7f"].Name = "Label"

return v1["1"], require
