-- Lord Shadow Aimbot GUI - Enhanced 💀
-- Developed by @forged1234
-- ايم بوت فقط مع دائرة ار جي بي قابلة للتعديل واخفاء عند الإطفاء + قائمة قابلة للتحريك + دعم لجميع اللاعبين والبوتات

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- واجهة المستخدم
local gui = Instance.new("ScreenGui", game.CoreGui)

local popup = Instance.new("TextButton")
popup.Size = UDim2.new(0, 40, 0, 40)
popup.Position = UDim2.new(0, 10, 0, 10)
popup.Text = "S"
popup.Visible = false
popup.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
popup.TextColor3 = Color3.new(1, 1, 1)
popup.Font = Enum.Font.SourceSansBold
popup.TextSize = 22
popup.Parent = gui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 280)
mainFrame.Position = UDim2.new(0, 50, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🎯 Lord Shadow Aimbot - @forged1234"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 40)
toggleBtn.Text = "Toggle Aimbot: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.Parent = mainFrame

local radiusBox = Instance.new("TextBox")
radiusBox.Size = UDim2.new(1, -20, 0, 30)
radiusBox.Position = UDim2.new(0, 10, 0, 80)
radiusBox.PlaceholderText = "Radius (e.g. 100)"
radiusBox.Text = "150"
radiusBox.TextColor3 = Color3.new(1, 1, 1)
radiusBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
radiusBox.Font = Enum.Font.SourceSans
radiusBox.TextSize = 16
radiusBox.Parent = mainFrame

local toggleUIBtn = Instance.new("TextButton")
toggleUIBtn.Size = UDim2.new(0, 30, 0, 30)
toggleUIBtn.Position = UDim2.new(1, -35, 0, 0)
toggleUIBtn.Text = "-"
toggleUIBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleUIBtn.TextColor3 = Color3.new(1, 1, 1)
toggleUIBtn.Font = Enum.Font.SourceSansBold
toggleUIBtn.TextSize = 20
toggleUIBtn.Parent = mainFrame

local aimbotOn = false
local radius = 150

local hue = 0
local indicator = Drawing.new("Circle")
indicator.Visible = false
indicator.Color = Color3.fromHSV(hue, 1, 1)
indicator.Thickness = 2
indicator.Radius = radius
indicator.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

-- تفعيل/تعطيل ايم بوت
local function toggleAimbot()
    aimbotOn = not aimbotOn
    toggleBtn.Text = aimbotOn and "Toggle Aimbot: ON" or "Toggle Aimbot: OFF"
    toggleBtn.BackgroundColor3 = aimbotOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    indicator.Visible = aimbotOn
end

uis.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == Enum.KeyCode.T then
            toggleAimbot()
        end
    end
end)

toggleBtn.MouseButton1Click:Connect(toggleAimbot)

radiusBox.FocusLost:Connect(function()
    local val = tonumber(radiusBox.Text)
    if val and val > 0 then
        radius = val
        indicator.Radius = radius
    end
end)

toggleUIBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    popup.Visible = true
end)

popup.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    popup.Visible = false
end)

-- اقرب هدف (يشمل الجميع)
local function getClosestTarget()
    local closest, shortest = nil, math.huge
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, visible = camera:WorldToViewportPoint(plr.Character.Head.Position)
            if visible then
                local mag = (Vector2.new(pos.X, pos.Y) - uis:GetMouseLocation()).Magnitude
                if mag < shortest and mag < radius then
                    closest = plr.Character.Head
                    shortest = mag
                end
            end
        end
    end
    return closest
end

-- ايم بوت متغير اللون
rs.RenderStepped:Connect(function()
    indicator.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    hue = (hue + 0.005) % 1
    indicator.Color = Color3.fromHSV(hue, 1, 1)
    if aimbotOn then
        local head = getClosestTarget()
        if head then
            camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
        end
    end
end)

-- النهاية - Lord Shadow 💀
