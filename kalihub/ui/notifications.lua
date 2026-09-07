--this shit was unobfuscated


local NotificationSystem = {}
NotificationSystem.__index = NotificationSystem
NotificationSystem.NotificationSize = UDim2.new(0, 300, 0, 70)
NotificationSystem.Spacing = 5
NotificationSystem.AnimationSpeed = 0.3
NotificationSystem.Font = Enum.Font.Gotham
NotificationSystem.TextSize = 14
NotificationSystem.TextColor = Color3.fromRGB(200, 200, 200)
NotificationSystem.BackgroundColor = Color3.fromRGB(50, 50, 50)
NotificationSystem.AccentColor = Color3.fromRGB(120, 120, 120)
NotificationSystem.BottomOffset = 10
NotificationSystem.ShowTimer = true -- Enable/disable timer display
NotificationSystem.TimerColor = Color3.fromRGB(150, 150, 150)

local cloneref = cloneref or function(v) return v; end
local function getservice(v) return cloneref(game:GetService(v)); end
local RunService = getservice("RunService")
local TextService = getservice("TextService")
local TweenService = getservice("TweenService")

function NotificationSystem.New(parent)
    local self = setmetatable({}, NotificationSystem)
    self.Container = Instance.new("Frame")
    self.Container.Name = "NotificationContainer"
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.Parent = parent
    self.Notifications = {}
    self.ActiveConnections = {}
    return self
end

function NotificationSystem:CalculatePosition(index)
    local yOffset = 0
    for i = 1, index - 1 do
        if self.Notifications[i] and self.Notifications[i].notification and self.Notifications[i].notification.Parent then
            yOffset = yOffset + self.Notifications[i].notification.Size.Y.Offset + self.Spacing
        end
    end
    return UDim2.new(1, -self.NotificationSize.X.Offset - 10, 1, -yOffset - self.NotificationSize.Y.Offset - self.BottomOffset)
end

function NotificationSystem:UpdatePositions()
    if not self.Container or not self.Container.Parent then
        return
    end
    local yOffset = 0
    for i, notificationData in ipairs(self.Notifications) do
        if not notificationData.notification or not notificationData.notification.Parent then
            continue
        end
        local notification = notificationData.notification
        local targetPosition = UDim2.new(1, -notification.Size.X.Offset - 10, 1, -yOffset - notification.Size.Y.Offset - self.BottomOffset)
        if notification.Position ~= targetPosition then
            TweenService:Create(
                notification,
                TweenInfo.new(self.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = targetPosition}
            ):Play()
        end
        yOffset = yOffset + notification.Size.Y.Offset + self.Spacing
    end
end

function NotificationSystem:CreateNotification(title, content, duration)
    if not self.Container or not self.Container.Parent then
        return
    end
    duration = duration or 3
    local contentWidth = self.NotificationSize.X.Offset - 20
    local contentTextSize = TextService:GetTextSize(content, self.TextSize - 2, Enum.Font.Code, Vector2.new(contentWidth, math.huge))
    local titleHeight = 26
    local contentHeight = contentTextSize.Y
    local timerHeight = self.ShowTimer and 16 or 0
    local totalHeight = titleHeight + contentHeight + timerHeight + 20
    local notificationSize = UDim2.new(0, self.NotificationSize.X.Offset, 0, math.max(totalHeight, self.NotificationSize.Y.Offset))
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.BackgroundColor3 = self.BackgroundColor
    notification.BorderSizePixel = 0
    notification.Size = notificationSize
    notification.Position = UDim2.new(1, notificationSize.X.Offset + 10, 1, self.BottomOffset)
    notification.Parent = self.Container
    notification.ClipsDescendants = true

    local border1 = Instance.new("Frame")
    border1.Name = "Border1"
    border1.Size = UDim2.new(1, -2, 1, -2)
    border1.Position = UDim2.new(0, 1, 0, 1)
    border1.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    border1.BorderSizePixel = 0
    border1.Parent = notification

    local border2 = Instance.new("Frame")
    border2.Name = "Border2"
    border2.Size = UDim2.new(1, -2, 1, -2)
    border2.Position = UDim2.new(0, 1, 0, 1)
    border2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    border2.BorderSizePixel = 0
    border2.Parent = border1

    local border3 = Instance.new("Frame")
    border3.Name = "Border3"
    border3.Size = UDim2.new(1, -6, 1, -6)
    border3.Position = UDim2.new(0, 3, 0, 3)
    border3.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    border3.BorderSizePixel = 0
    border3.Parent = border2

    local inner = Instance.new("Frame")
    inner.Name = "Frame"
    inner.Size = UDim2.new(1, -2, 1, -2)
    inner.Position = UDim2.new(0, 1, 0, 1)
    inner.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    inner.BorderSizePixel = 0
    inner.Parent = border3

    local gradientFrame = Instance.new("Frame")
    gradientFrame.Size = UDim2.new(1, 0, 0, 1)
    gradientFrame.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    gradientFrame.BorderSizePixel = 0
    gradientFrame.Parent = inner

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120, 120, 120)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120, 120, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120))
    }
    gradient.Parent = gradientFrame

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 0, 0, 1)
    shadow.Position = UDim2.new(0, 0, 0, 1)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.2
    shadow.BorderSizePixel = 0
    shadow.Parent = inner

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = self.Font
    titleLabel.TextColor3 = self.TextColor
    titleLabel.TextSize = self.TextSize
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 6)
    titleLabel.Size = UDim2.new(1, -20, 0, titleHeight - 6)
    titleLabel.Parent = inner

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Text = content
    contentLabel.Font = Enum.Font.Code
    contentLabel.TextColor3 = self.TextColor
    contentLabel.TextSize = self.TextSize - 2
    contentLabel.TextWrapped = true
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.BackgroundTransparency = 1
    contentLabel.Position = UDim2.new(0, 10, 0, titleHeight)
    contentLabel.Size = UDim2.new(1, -20, 0, contentHeight)
    contentLabel.Parent = inner

    local timerLabel
    if self.ShowTimer then
        timerLabel = Instance.new("TextLabel")
        timerLabel.Name = "Timer"
        timerLabel.Text = string.format("%.1fs", duration)
        timerLabel.Font = Enum.Font.Code
        timerLabel.TextColor3 = self.TimerColor
        timerLabel.TextSize = self.TextSize - 4
        timerLabel.TextXAlignment = Enum.TextXAlignment.Right
        timerLabel.TextYAlignment = Enum.TextYAlignment.Center
        timerLabel.BackgroundTransparency = 1
        timerLabel.Position = UDim2.new(1, -60, 0, 6)
        timerLabel.Size = UDim2.new(0, 50, 0, titleHeight - 6)
        timerLabel.Parent = inner
    end

    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.BackgroundColor3 = self.AccentColor
    progressBar.BorderSizePixel = 0
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    progressBar.Position = UDim2.new(0, 0, 1, -2)
    progressBar.Parent = inner

    local slideIn = TweenService:Create(
        notification,
        TweenInfo.new(self.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = self:CalculatePosition(#self.Notifications + 1)}
    )
    slideIn:Play()

    local notificationData = {
        notification = notification,
        startTime = tick(),
        duration = duration,
        timerLabel = timerLabel
    }
    table.insert(self.Notifications, notificationData)
    self:UpdatePositions()

    local progressTween = TweenService:Create(
        progressBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 0, 2)}
    )
    progressTween:Play()

    local startTime = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not self.Container or not self.Container.Parent then
            if connection then
                connection:Disconnect()
            end
            return
        end
        local elapsed = tick() - startTime
        local remaining = duration - elapsed
        if timerLabel and remaining > 0 then
            timerLabel.Text = string.format("%.1fs", remaining)
        end
        if elapsed >= duration then
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
    table.insert(self.ActiveConnections, connection)

    task.delay(duration, function()
        if not self.Container or not self.Container.Parent then
            return
        end
        local fadeOut = TweenService:Create(
            notification,
            TweenInfo.new(self.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position = UDim2.new(1, notification.Size.X.Offset + 10, 1, notification.Position.Y.Offset - notification.Position.Y.Scale * self.BottomOffset)}
        )
        fadeOut:Play()
        task.wait(self.AnimationSpeed)
        for i, v in ipairs(self.Notifications) do
            if v.notification == notification then
                table.remove(self.Notifications, i)
                break
            end
        end
        self:UpdatePositions()
        notification:Destroy()
    end)
end

function NotificationSystem:Destroy()
    for _, connection in ipairs(self.ActiveConnections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    self.ActiveConnections = {}
    for _, notificationData in ipairs(self.Notifications) do
        if notificationData.notification and notificationData.notification.Parent then
            notificationData.notification:Destroy()
        end
    end
    self.Notifications = {}
    if self.Container and self.Container.Parent then
        self.Container:Destroy()
    end
end

return NotificationSystem
