-- [[ VIETNAM HUB BY NINH NGUYEN - V1.0 (BETA) DUAL WEBHOOK ENGINE ]] --

local CorrectKey = "3011"
local DiscordLink = "https://discord.gg/mAuVhG9HK"
local ConfigFileName = "VietnamHub_Config_v1_beta.json"

-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Local Caching
local Vector2_new = Vector2.new
local Vector3_new = Vector3.new
local Color3_fromRGB = Color3.fromRGB
local task_wait = task.wait

-- Config Structure
local HubConfig = {
    KeySaved = "",
    UltraFixLag = false,
    DisableRender3D = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    NoClip = false,
    AntiRagdoll = false,
    SelectedTrollTarget = "None",
    AutoPunch = false,
    FlingTarget = false,
    OrbitTarget = false,
    Aimbot = false,
    AimPart = "50% Head / 50% Body",
    AimSmooth = 0.1,
    AimPrediction = true,
    ESP_Skeleton = false,
    -- Webhook Config
    WebhookUrl = "",
    AutoSendStatus = false,
    AutoNotifyReward = true
}

local function SaveConfig()
    if writefile then
        pcall(function()
            writefile(ConfigFileName, HttpService:JSONEncode(HubConfig))
        end)
    end
end

local function LoadConfig()
    if readfile and isfile and isfile(ConfigFileName) then
        pcall(function()
            local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(ConfigFileName))
            if success and type(decoded) == "table" then
                for k, v in pairs(decoded) do HubConfig[k] = v end
            end
        end)
    end
end

LoadConfig()

-- Safe Rejoin
local function SafeRejoin()
    pcall(function()
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end)
end

if CoreGui:FindFirstChild("RobloxPromptGui") then
    CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then task_wait(1) SafeRejoin() end
    end)
end

-- WEBHOOK SENDER HELPER
local function SendDiscordWebhook(title, description, fields, color)
    if HubConfig.WebhookUrl == "" or not string.find(HubConfig.WebhookUrl, "discord.com/api/webhooks") then
        return
    end

    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not requestFunc then return end

    local payload = {
        embeds = {{
            title = title or "🇻🇳 VIETNAM HUB NOTIFIER",
            description = description or "",
            fields = fields or {},
            color = color or 65280, -- Green
            footer = { text = "Vietnam Hub v1.0 (Beta) • " .. os.date("%X") },
            timestamp = DateTime.now():ToIsoDate()
        }}
    }

    pcall(function()
        requestFunc({
            Url = HubConfig.WebhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

-- MAIN LOAD ENGINE
local function LoadMainHub()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
       Name = "VIETNAM HUB | BETA ENGINE v1.0",
       LoadingTitle = "Đang nạp Vietnam Hub v1.0 (Beta)...",
       LoadingSubtitle = "Troll, Optimization & Webhook Engine",
       ConfigurationSaving = { Enabled = false },
       Discord = { Enabled = false },
       KeySystem = false
    })

    -- Tabs
    local MainTab = Window:CreateTab("Tối Ưu Siêu Cấp", 4483362458)
    local TrollTab = Window:CreateTab("🎭 Super Troll Player", 4483362458)
    local WebhookTab = Window:CreateTab("📢 Discord Webhook", 4483362458)
    local RagdollTab = Window:CreateTab("Ragdoll Engine", 4483362458)
    local ExploitsTab = Window:CreateTab("Tính Năng Đặc Biệt", 4483362458)
    local CombatTab = Window:CreateTab("Aimbot Prediction", 4483362458)

    -- Variables
    local UltraFixLagEnabled = HubConfig.UltraFixLag
    local WalkSpeedValue = HubConfig.WalkSpeed
    local JumpPowerValue = HubConfig.JumpPower
    local NoClipEnabled = HubConfig.NoClip
    local AntiRagdollEnabled = HubConfig.AntiRagdoll
    local SelectedTrollTarget = HubConfig.SelectedTrollTarget
    
    local AutoPunchEnabled = HubConfig.AutoPunch
    local FlingTargetEnabled = HubConfig.FlingTarget
    local OrbitTargetEnabled = HubConfig.OrbitTarget

    local AimbotEnabled = HubConfig.Aimbot
    local AimbotSmoothness = HubConfig.AimSmooth
    local AimFOV = 250

    -- Anti-AFK
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2_new(0,0), Camera.CFrame)
        task_wait(1)
        VirtualUser:Button2Up(Vector2_new(0,0), Camera.CFrame)
    end)

    -- Player List Helper
    local function GetPlayerList()
        local list = {"All Players (Tất Cả)"}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then table.insert(list, plr.Name) end
        end
        return list
    end

    -- ========================================================
    --               TAB: DISCORD WEBHOOK ENGINE
    -- ========================================================
    WebhookTab:CreateInput({
       Name = "🔗 Discord Webhook URL",
       PlaceholderText = "Dán URL Webhook Discord vào đây...",
       RemoveTextOnFocus = false,
       Callback = function(Text)
          HubConfig.WebhookUrl = Text
          SaveConfig()
       end,
    })

    -- FEATURE 1: Send Current Player Status
    WebhookTab:CreateButton({
       Name = "📊 Gửi Thông Tin Hiện Tại (Current Status)",
       Callback = function()
          local pos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3_new(0,0,0)
          local fields = {
              { name = "👤 Player Name", value = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")", inline = true },
              { name = "🎮 Game PlaceId", value = tostring(game.PlaceId), inline = true },
              { name = "⚡ WalkSpeed", value = tostring(WalkSpeedValue), inline = true },
              { name = "📍 Location CFrame", value = string.format("X: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z), inline = false }
          }
          SendDiscordWebhook("📊 TÌNH TRẠNG TÀI KHOẢN HIỆN TẠI", "Thông tin chi tiết nhân vật từ Vietnam Hub v1.0", fields, 3447003)
          Rayfield:Notify({ Title = "Webhook Engine", Content = "Đã gửi thông tin hiện tại về Discord!", Duration = 3 })
       end,
    })

    -- FEATURE 2: Auto Detect Items / Reward Popups
    local function MonitorRewardItems(container, sourceName)
        container.ChildAdded:Connect(function(child)
            if HubConfig.AutoNotifyReward then
                task_wait(0.2)
                local itemName = child.Name
                local fields = {
                    { name = "🎁 Tên Item / Phần Thưởng", value = itemName, inline = true },
                    { name = "📂 Nguồn Xuất Hiện", value = sourceName, inline = true },
                    { name = "👤 Người Nhận", value = LocalPlayer.Name, inline = true }
                }
                SendDiscordWebhook("🎉 PHÁT HIỆN ITEM / PHẦN THƯỞNG MỚI!", "Item mới xuất hiện trên màn hình hoặc trong túi đồ!", fields, 16766720)
            end
        end)
    end

    -- Hook Backpack (Túi đồ)
    LocalPlayer:WaitForChild("Backpack")
    MonitorRewardItems(LocalPlayer.Backpack, "Túi Đồ (Backpack)")

    -- Hook PlayerGui (Phần thưởng hiện lên màn hình)
    if LocalPlayer:FindFirstChild("PlayerGui") then
        MonitorRewardItems(LocalPlayer.PlayerGui, "Màn Hình (PlayerGui)")
    end

    WebhookTab:CreateToggle({
       Name = "🎁 Auto Webhook Khi Có Item / Phần Thưởng Mới",
       CurrentValue = HubConfig.AutoNotifyReward,
       Flag = "AutoNotifyRewardToggle",
       Callback = function(Value)
          HubConfig.AutoNotifyReward = Value
          SaveConfig()
       end,
    })

    -- ========================================================
    --               TAB: TROLL PLAYER ENGINE
    -- ========================================================
    local TrollDropdown = TrollTab:CreateDropdown({
       Name = "🎯 Chọn Nạn Nhân Để Troll (Troll Target)",
       Options = GetPlayerList(),
       CurrentOption = SelectedTrollTarget ~= "" and SelectedTrollTarget or "All Players (Tất Cả)",
       Flag = "TrollTargetDropdown",
       Callback = function(Option)
          SelectedTrollTarget = Option
          HubConfig.SelectedTrollTarget = Option
          SaveConfig()
       end,
    })

    Players.PlayerAdded:Connect(function() TrollDropdown:Refresh(GetPlayerList()) end)
    Players.PlayerRemoving:Connect(function() TrollDropdown:Refresh(GetPlayerList()) end)

    -- Auto Punch / Annoy Feature
    task.spawn(function()
        while task_wait(0.05) do
            if AutoPunchEnabled and SelectedTrollTarget ~= "None" then
                pcall(function()
                    local targetPlr = Players:FindFirstChild(SelectedTrollTarget)
                    if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                        local myChar = LocalPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            local targetHRP = targetPlr.Character.HumanoidRootPart
                            myChar.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)
                            
                            local tool = myChar:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                            else
                                VirtualUser:Button1Down(Vector2_new(500, 500), Camera.CFrame)
                                task_wait(0.02)
                                VirtualUser:Button1Up(Vector2_new(500, 500), Camera.CFrame)
                            end
                        end
                    end
                end)
            end
        end
    end)

    TrollTab:CreateToggle({
       Name = "🥊 Auto Punch / Annoy (Bay Tới Đấm/Tát Liên Tục)",
       CurrentValue = HubConfig.AutoPunch,
       Flag = "AutoPunchToggle",
       Callback = function(Value)
          AutoPunchEnabled = Value
          HubConfig.AutoPunch = Value
          SaveConfig()
       end,
    })

    -- Ultra Fling Feature Engine
    task.spawn(function()
        local Angle = 0
        while task_wait(0.02) do
            if FlingTargetEnabled and SelectedTrollTarget ~= "None" then
                pcall(function()
                    local targetPlr = Players:FindFirstChild(SelectedTrollTarget)
                    if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            Angle = Angle + 100
                            myHRP.Velocity = Vector3_new(0, 10000, 0)
                            myHRP.RotVelocity = Vector3_new(10000, 10000, 10000)
                            myHRP.CFrame = targetPlr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Angle), 0)
                        end
                    end
                end)
            end
        end
    end)

    TrollTab:CreateToggle({
       Name = "🌀 Ultra Fling Target (Hất Tung Nạn Nhân Bay Mất Tích)",
       CurrentValue = HubConfig.FlingTarget,
       Flag = "FlingTargetToggle",
       Callback = function(Value)
          FlingTargetEnabled = Value
          HubConfig.FlingTarget = Value
          SaveConfig()
       end,
    })

    -- Orbit Feature Engine
    task.spawn(function()
        local OrbitAngle = 0
        while task_wait(0.03) do
            if OrbitTargetEnabled and SelectedTrollTarget ~= "None" then
                pcall(function()
                    local targetPlr = Players:FindFirstChild(SelectedTrollTarget)
                    if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            OrbitAngle = OrbitAngle + 0.15
                            local radius = 5
                            local offset = Vector3_new(math.cos(OrbitAngle) * radius, 3, math.sin(OrbitAngle) * radius)
                            myHRP.CFrame = CFrame.new(targetPlr.Character.HumanoidRootPart.Position + offset, targetPlr.Character.HumanoidRootPart.Position)
                        end
                    end
                end)
            end
        end
    end)

    TrollTab:CreateToggle({
       Name = "🛸 Orbit Target (Bay Xoay Vòng Tròn Quanh Nạn Nhân)",
       CurrentValue = HubConfig.OrbitTarget,
       Flag = "OrbitTargetToggle",
       Callback = function(Value)
          OrbitTargetEnabled = Value
          HubConfig.OrbitTarget = Value
          SaveConfig()
       end,
    })

    TrollTab:CreateButton({
       Name = "🧲 Bring Target (Kéo Nạn Nhân Lại Gần Bạn)",
       Callback = function()
          pcall(function()
             local targetPlr = Players:FindFirstChild(SelectedTrollTarget)
             if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                 local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                 if myHRP then
                     targetPlr.Character.HumanoidRootPart.CFrame = myHRP.CFrame * CFrame.new(0, 0, -3)
                 end
             end
          end)
          Rayfield:Notify({ Title = "Troll Engine", Content = "Đã kéo nạn nhân về vị trí!", Duration = 2 })
       end,
    })

    -- ========================================================
    --               TAB: RAGDOLL ENGINE
    -- ========================================================
    RunService.Stepped:Connect(function()
        if AntiRagdollEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                if hum:GetState() == Enum.HumanoidStateType.Ragdoll then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
            end
        end
    end)

    RagdollTab:CreateToggle({
       Name = "🛡 Anti Ragdoll (Chống Té / Chống Bị Đẩy)",
       CurrentValue = HubConfig.AntiRagdoll,
       Flag = "AntiRagdollToggle",
       Callback = function(Value)
          AntiRagdollEnabled = Value
          HubConfig.AntiRagdoll = Value
          SaveConfig()
       end,
    })

    -- ========================================================
    --               TAB: TỐI ƯU SIÊU CẤP (FIX LAG)
    -- ========================================================
    MainTab:CreateToggle({
       Name = "⚡ Ultra Fix Lag Engine",
       CurrentValue = HubConfig.UltraFixLag,
       Flag = "UltraFixLagToggle",
       Callback = function(Value)
          UltraFixLagEnabled = Value
          HubConfig.UltraFixLag = Value
          SaveConfig()
          if UltraFixLagEnabled then
             settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
             Lighting.GlobalShadows = false
          end
       end,
    })

    MainTab:CreateToggle({
       Name = "🖥 Tắt Render 3D (Siêu Nhẹ Giảm RAM)",
       CurrentValue = HubConfig.DisableRender3D,
       Flag = "Disable3DRendering",
       Callback = function(Value)
          HubConfig.DisableRender3D = Value
          SaveConfig()
          RunService:Set3dRenderingEnabled(not Value)
       end,
    })

    -- ========================================================
    --               TAB: TÍNH NĂNG ĐẶC BIỆT
    -- ========================================================
    RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
        end
    end)

    ExploitsTab:CreateSlider({
       Name = "Tốc Độ Chạy (WalkSpeed)",
       Range = {16, 250},
       Increment = 1,
       Suffix = "Speed",
       CurrentValue = HubConfig.WalkSpeed,
       Flag = "WalkSpeedSlider",
       Callback = function(Value)
          WalkSpeedValue = Value
          HubConfig.WalkSpeed = Value
          SaveConfig()
       end,
    })

    RunService.Stepped:Connect(function()
        if NoClipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    ExploitsTab:CreateToggle({
       Name = "Đi Xuyên Tường (NoClip Pro)",
       CurrentValue = HubConfig.NoClip,
       Flag = "NoClipToggle",
       Callback = function(Value)
          NoClipEnabled = Value
          HubConfig.NoClip = Value
          SaveConfig()
       end,
    })

    -- ========================================================
    --             TAB: AIMBOT ULTRA PREDICTION
    -- ========================================================
    RunService.RenderStepped:Connect(function()
        if AimbotEnabled then
            local ClosestPart = nil
            local ShortestDistance = AimFOV
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local TargetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
                    if TargetPart then
                        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPart.Position)
                        if OnScreen then
                            local Distance = (Vector2_new(ScreenPos.X, ScreenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                            if Distance < ShortestDistance then
                                ClosestPart = TargetPart
                                ShortestDistance = Distance
                            end
                        end
                    end
                end
            end
            if ClosestPart then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, ClosestPart.Position), AimbotSmoothness)
            end
        end
    end)

    CombatTab:CreateToggle({
       Name = "Bật Aimbot Siêu Chuẩn",
       CurrentValue = HubConfig.Aimbot,
       Flag = "AimbotToggle",
       Callback = function(Value)
          AimbotEnabled = Value
          HubConfig.Aimbot = Value
          SaveConfig()
       end,
    })

    Rayfield:Notify({ Title = "Vietnam Hub v1.0 (Beta)", Content = "Đã nạp thành công v1.0 (Beta) + Dual Webhook!", Duration = 4 })
end

-- KEY SYSTEM ENGINE
if HubConfig.KeySaved == CorrectKey then
    LoadMainHub()
else
    local KeyScreenGui = Instance.new("ScreenGui")
    KeyScreenGui.Name = "VietnamHub_KeySystem"
    KeyScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 380, 0, 230)
    KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -115)
    KeyFrame.BackgroundColor3 = Color3_fromRGB(18, 18, 22)
    KeyFrame.Parent = KeyScreenGui

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 12)
    KeyCorner.Parent = KeyFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Text = "🇻🇳 VIETNAM HUB V1.0 (BETA) - KEY SYSTEM"
    Title.TextColor3 = Color3_fromRGB(255, 205, 0)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.Parent = KeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.85, 0, 0, 42)
    KeyInput.Position = UDim2.new(0.075, 0, 0.26, 0)
    KeyInput.BackgroundColor3 = Color3_fromRGB(28, 28, 35)
    KeyInput.TextColor3 = Color3_fromRGB(255, 255, 255)
    KeyInput.PlaceholderText = "Nhập Key tại đây..."
    KeyInput.TextSize = 15
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.Parent = KeyFrame

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.85, 0, 0, 38)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
    SubmitBtn.BackgroundColor3 = Color3_fromRGB(0, 180, 90)
    SubmitBtn.Text = "XÁC NHẬN KEY"
    SubmitBtn.TextColor3 = Color3_fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = KeyFrame

    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text == CorrectKey then
            HubConfig.KeySaved = CorrectKey
            SaveConfig()
            KeyScreenGui:Destroy()
            LoadMainHub()
        end
    end)
end
