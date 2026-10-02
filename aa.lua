-- [[ VIETNAM HUB V1.0 (BETA) - SCRIPT BY NINH NGUYEN ]] --

local CorrectKey = "3011"
local ConfigFileName = "VietnamHub_Config_v1_beta.json"

-- Services
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

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
    NoClip = false,
    AntiRagdoll = false,
    AntiFling = true,
    SelectedTrollTarget = "None",
    AutoPunch = false,
    FlingTarget = false,
    OrbitTarget = false,
    Aimbot = false,
    AimPartMode = "50% Head / 50% Body",
    AimSmooth = 0.1,
    AimFOV = 200,
    ESP_Enabled = false,
    WebhookUrl = "",
    AutoNotifyReward = true
}

local function SaveConfig()
    if writefile then
        pcall(function() writefile(ConfigFileName, HttpService:JSONEncode(HubConfig)) end)
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

-- ENGLISH DICTIONARY TRANSLATIONS SYSTEM
local lang = {
    TabMain = "⚡ Performance Boost",
    TabTroll = "🎭 Super Troll Player",
    TabCombat = "🎯 Aimbot Pro",
    TabESP = "👁️ ESP Player",
    TabDefense = "🛡️ Defense & Anti-Fling",
    TabExploits = "⚡ Special Exploits",
    TabWebhook = "📢 Discord Webhook",

    SelectTarget = "🎯 Select Target Player",
    RefreshList = "🔄 Refresh Player List",
    ListRefreshed = "Updated player list successfully!",
    AutoPunch = "🥊 Auto Punch / Annoy Target",
    FlingTarget = "🌀 Ultra Void Fling Target (Sink & Instakill)",
    InstantFlingBtn = "💥 Instant Void Fling (One-Tap Kill)",
    OrbitTarget = "🛸 Orbit Target (Rotate Around Target)",

    EnableAimbot = "🎯 Enable Aimbot Pro",
    AimMode = "🎯 Hitbox Aim Mode (Target Ratio)",
    AimModeHead = "100% Head",
    AimModeBody = "100% Body",
    AimModeDefault = "Default (50% Head / 50% Body - Anti Ban)",
    AimSmoothness = "🎛️ Aimbot Smoothness",

    EnableESP = "👁️ Enable Player ESP (Wallhack)",

    AntiFling = "🛡️ Anti Fling Pro",
    AntiRagdoll = "🛡️ Anti Ragdoll",

    UltraFixLag = "⚡ Ultra Fix Lag Engine",
    Disable3D = "🖥️ Disable 3D Rendering (Max FPS)",
    WalkSpeed = "⚡ WalkSpeed Boost",

    WebhookInput = "🔗 Discord Webhook URL",
    WebhookPlaceholder = "Paste Discord Webhook URL...",
    WebhookSendStatus = "📊 Send Current Status",
    WebhookSentNotify = "Information sent to Discord!",

    ScriptLoaded = "Script loaded successfully by Ninh Nguyen!"
}

-- Safe Rejoin Engine
if CoreGui:FindFirstChild("RobloxPromptGui") then
    CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then 
            task_wait(1) 
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end)
end

-- WEBHOOK HELPER
local function SendDiscordWebhook(title, description, fields, color)
    if HubConfig.WebhookUrl == "" or not string.find(HubConfig.WebhookUrl, "discord.com/api/webhooks") then return end
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request
    if not requestFunc then return end

    local payload = {
        embeds = {{
            title = title or "🇻🇳 VIETNAM HUB NOTIFIER",
            description = description or "",
            fields = fields or {},
            color = color or 65280,
            footer = { text = "Vietnam Hub v1.0 (Beta) • Script by Ninh Nguyen • " .. os.date("%X") },
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
       Name = "VIETNAM HUB | BETA ENGINE v1.0 [ENGLISH]",
       LoadingTitle = "Vietnam Hub Loading...",
       LoadingSubtitle = "Script by Ninh Nguyen",
       ConfigurationSaving = { Enabled = false },
       Discord = { Enabled = false },
       KeySystem = false
    })

    -- Tabs
    local MainTab = Window:CreateTab(lang.TabMain, 4483362458)
    local TrollTab = Window:CreateTab(lang.TabTroll, 4483362458)
    local CombatTab = Window:CreateTab(lang.TabCombat, 4483362458)
    local ESPTab = Window:CreateTab(lang.TabESP, 4483362458)
    local RagdollTab = Window:CreateTab(lang.TabDefense, 4483362458)
    local ExploitsTab = Window:CreateTab(lang.TabExploits, 4483362458)
    local WebhookTab = Window:CreateTab(lang.TabWebhook, 4483362458)

    -- Local Variables
    local SelectedTrollTarget = HubConfig.SelectedTrollTarget
    local AutoPunchEnabled = HubConfig.AutoPunch
    local FlingTargetEnabled = HubConfig.FlingTarget
    local OrbitTargetEnabled = HubConfig.OrbitTarget
    
    local AimbotEnabled = HubConfig.Aimbot
    local AimPartMode = HubConfig.AimPartMode
    local AimSmoothness = HubConfig.AimSmooth
    local AimFOV = HubConfig.AimFOV

    local ESP_Enabled = HubConfig.ESP_Enabled
    local AntiFlingEnabled = HubConfig.AntiFling
    local AntiRagdollEnabled = HubConfig.AntiRagdoll

    -- Anti-AFK
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2_new(0,0), Camera.CFrame)
        task_wait(1)
        VirtualUser:Button2Up(Vector2_new(0,0), Camera.CFrame)
    end)

    -- Player List Helper
    local function GetPlayerList()
        local list = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then table.insert(list, plr.Name) end
        end
        if #list == 0 then table.insert(list, "None") end
        return list
    end

    -- ========================================================
    --               TAB: TROLL PLAYER ENGINE
    -- ========================================================
    local TrollDropdown = TrollTab:CreateDropdown({
       Name = lang.SelectTarget,
       Options = GetPlayerList(),
       CurrentOption = SelectedTrollTarget,
       Flag = "TrollTargetDropdown",
       Callback = function(Option)
          SelectedTrollTarget = Option[1] or Option
          HubConfig.SelectedTrollTarget = SelectedTrollTarget
          SaveConfig()
       end,
    })

    TrollTab:CreateButton({
       Name = lang.RefreshList,
       Callback = function()
          TrollDropdown:Refresh(GetPlayerList())
          Rayfield:Notify({ Title = "Troll Engine", Content = lang.ListRefreshed, Duration = 2 })
       end,
    })

    -- Auto Punch Engine
    task.spawn(function()
        while task_wait(0.03) do
            if AutoPunchEnabled and SelectedTrollTarget ~= "None" then
                pcall(function()
                    local targetPlr = Players:FindFirstChild(SelectedTrollTarget)
                    if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                        local myChar = LocalPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            local targetHRP = targetPlr.Character.HumanoidRootPart
                            myChar.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 1.8)
                            
                            local tool = myChar:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                            else
                                VirtualUser:Button1Down(Vector2_new(0, 0), Camera.CFrame)
                                task_wait(0.01)
                                VirtualUser:Button1Up(Vector2_new(0, 0), Camera.CFrame)
                            end
                        end
                    end
                end)
            end
        end
    end)

    TrollTab:CreateToggle({
       Name = lang.AutoPunch,
       CurrentValue = HubConfig.AutoPunch,
       Flag = "AutoPunchToggle",
       Callback = function(Value)
          AutoPunchEnabled = Value
          HubConfig.AutoPunch = Value
          SaveConfig()
       end,
    })

    -- Ultra Instakill & Sink Void Fling Helper Function
    local function PerformVoidFling(targetPlr)
        if not targetPlr or not targetPlr.Character then return end
        local targetHRP = targetPlr.Character:FindFirstChild("HumanoidRootPart")
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        
        if targetHRP and myHRP then
            myHRP.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
            myHRP.AssemblyLinearVelocity = Vector3_new(0, -50000, 0)
            myHRP.AssemblyAngularVelocity = Vector3_new(99999, 99999, 99999)
            
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, -2, 0)
            task_wait(0.1)
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, -4, 0)
        end
    end

    -- Instant Void Fling Button
    TrollTab:CreateButton({
       Name = lang.InstantFlingBtn,
       Callback = function()
          if SelectedTrollTarget ~= "None" then
             local targetPlr = Players:FindFirstChild(SelectedTrollTarget)
             if targetPlr then
                for i = 1, 15 do
                   PerformVoidFling(targetPlr)
                   task_wait(0.01)
                end
                Rayfield:Notify({ Title = "Void Fling Engine", Content = "Instant Void Fling executed!", Duration = 2 })
             end
          end
       end,
    })

    -- Auto Fling Loop Engine
    task.spawn(function()
        while task_wait(0.01) do
            if FlingTargetEnabled and SelectedTrollTarget ~= "None" then
                pcall(function()
                    local targetPlr = Players:FindFirstChild(SelectedTrollTarget)
                    if targetPlr then
                        PerformVoidFling(targetPlr)
                    end
                end)
            end
        end
    end)

    TrollTab:CreateToggle({
       Name = lang.FlingTarget,
       CurrentValue = HubConfig.FlingTarget,
       Flag = "FlingTargetToggle",
       Callback = function(Value)
          FlingTargetEnabled = Value
          HubConfig.FlingTarget = Value
          SaveConfig()
       end,
    })

    -- Orbit Engine
    task.spawn(function()
        local OrbitAngle = 0
        while task_wait(0.02) do
            if OrbitTargetEnabled and SelectedTrollTarget ~= "None" then
                pcall(function()
                    local targetPlr = Players:FindFirstChild(SelectedTrollTarget)
                    if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            OrbitAngle = OrbitAngle + 0.15
                            local radius = 6
                            local offset = Vector3_new(math.cos(OrbitAngle) * radius, 3, math.sin(OrbitAngle) * radius)
                            myHRP.CFrame = CFrame.new(targetPlr.Character.HumanoidRootPart.Position + offset, targetPlr.Character.HumanoidRootPart.Position)
                        end
                    end
                end)
            end
        end
    end)

    TrollTab:CreateToggle({
       Name = lang.OrbitTarget,
       CurrentValue = HubConfig.OrbitTarget,
       Flag = "OrbitTargetToggle",
       Callback = function(Value)
          OrbitTargetEnabled = Value
          HubConfig.OrbitTarget = Value
          SaveConfig()
       end,
    })

    -- ========================================================
    --            TAB: AIMBOT PRO ENGINE (ANTI-BAN RATIO)
    -- ========================================================
    CombatTab:CreateToggle({
       Name = lang.EnableAimbot,
       CurrentValue = HubConfig.Aimbot,
       Flag = "AimbotToggle",
       Callback = function(Value)
          AimbotEnabled = Value
          HubConfig.Aimbot = Value
          SaveConfig()
       end,
    })

    CombatTab:CreateDropdown({
       Name = lang.AimMode,
       Options = {
           lang.AimModeHead,
           lang.AimModeBody,
           lang.AimModeDefault
       },
       CurrentOption = AimPartMode,
       Flag = "AimPartDropdown",
       Callback = function(Option)
          AimPartMode = Option[1] or Option
          HubConfig.AimPartMode = AimPartMode
          SaveConfig()
       end,
    })

    CombatTab:CreateSlider({
       Name = lang.AimSmoothness,
       Range = {0.01, 1},
       Increment = 0.01,
       Suffix = "Smooth",
       CurrentValue = HubConfig.AimSmooth,
       Flag = "AimSmoothSlider",
       Callback = function(Value)
          AimSmoothness = Value
          HubConfig.AimSmooth = Value
          SaveConfig()
       end,
    })

    -- Dynamic Target Part Selector
    local function GetAimTargetPart(character)
        if not character then return nil end
        
        if string.find(AimPartMode, "Head") and not string.find(AimPartMode, "50%") then
            return character:FindFirstChild("Head")
        elseif string.find(AimPartMode, "Body") and not string.find(AimPartMode, "50%") then
            return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        else
            local isHead = (math.random(1, 100) <= 50)
            if isHead then
                return character:FindFirstChild("Head")
            else
                return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
            end
        end
    end

    -- Smooth Aimbot Engine Loop
    RunService.RenderStepped:Connect(function()
        if AimbotEnabled then
            local ClosestPart = nil
            local ShortestDistance = AimFOV

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local SelectedPart = GetAimTargetPart(player.Character)
                    if SelectedPart then
                        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(SelectedPart.Position)
                        if OnScreen then
                            local Distance = (Vector2_new(ScreenPos.X, ScreenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                            if Distance < ShortestDistance then
                                ClosestPart = SelectedPart
                                ShortestDistance = Distance
                            end
                        end
                    end
                end
            end

            if ClosestPart then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, ClosestPart.Position), AimSmoothness)
            end
        end
    end)

    -- ========================================================
    --               TAB: ESP PLAYER ENGINE
    -- ========================================================
    local ESPFolder = Instance.new("Folder", CoreGui)
    ESPFolder.Name = "VietnamHub_ESP"

    local function ClearESP()
        ESPFolder:ClearAllChildren()
    end

    local function UpdateESP()
        ClearESP()
        if not ESP_Enabled then return end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local Highlight = Instance.new("Highlight")
                Highlight.Name = plr.Name
                Highlight.Adornee = plr.Character
                Highlight.FillColor = Color3_fromRGB(255, 0, 0)
                Highlight.FillTransparency = 0.5
                Highlight.OutlineColor = Color3_fromRGB(255, 255, 255)
                Highlight.Parent = ESPFolder
            end
        end
    end

    ESPTab:CreateToggle({
       Name = lang.EnableESP,
       CurrentValue = HubConfig.ESP_Enabled,
       Flag = "ESPToggle",
       Callback = function(Value)
          ESP_Enabled = Value
          HubConfig.ESP_Enabled = Value
          SaveConfig()
          UpdateESP()
       end,
    })

    Players.PlayerAdded:Connect(function() if ESP_Enabled then task_wait(1) UpdateESP() end end)
    Players.PlayerRemoving:Connect(function() if ESP_Enabled then UpdateESP() end end)

    -- ========================================================
    --               TAB: DEFENSE & ANTI FLING
    -- ========================================================
    RunService.Stepped:Connect(function()
        if AntiFlingEnabled and LocalPlayer.Character then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    for _, part in pairs(plr.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end

            local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHRP then
                if myHRP.AssemblyLinearVelocity.Magnitude > 250 or myHRP.AssemblyAngularVelocity.Magnitude > 250 then
                    myHRP.AssemblyLinearVelocity = Vector3_new(0,0,0)
                    myHRP.AssemblyAngularVelocity = Vector3_new(0,0,0)
                end
            end
        end

        if AntiRagdollEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
        end
    end)

    RagdollTab:CreateToggle({
       Name = lang.AntiFling,
       CurrentValue = HubConfig.AntiFling,
       Flag = "AntiFlingToggle",
       Callback = function(Value)
          AntiFlingEnabled = Value
          HubConfig.AntiFling = Value
          SaveConfig()
       end,
    })

    RagdollTab:CreateToggle({
       Name = lang.AntiRagdoll,
       CurrentValue = HubConfig.AntiRagdoll,
       Flag = "AntiRagdollToggle",
       Callback = function(Value)
          AntiRagdollEnabled = Value
          HubConfig.AntiRagdoll = Value
          SaveConfig()
       end,
    })

    -- ========================================================
    --               TAB: DISCORD WEBHOOK ENGINE
    -- ========================================================
    WebhookTab:CreateInput({
       Name = lang.WebhookInput,
       PlaceholderText = lang.WebhookPlaceholder,
       RemoveTextOnFocus = false,
       Callback = function(Text)
          HubConfig.WebhookUrl = Text
          SaveConfig()
       end,
    })

    WebhookTab:CreateButton({
       Name = lang.WebhookSendStatus,
       Callback = function()
          local pos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3_new(0,0,0)
          local fields = {
              { name = "👤 Player Name", value = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")", inline = true },
              { name = "🎮 Game PlaceId", value = tostring(game.PlaceId), inline = true },
              { name = "📍 Location", value = string.format("X: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z), inline = false }
          }
          SendDiscordWebhook("📊 CURRENT STATUS", "Vietnam Hub v1.0 Notification", fields, 3447003)
          Rayfield:Notify({ Title = "Webhook Engine", Content = lang.WebhookSentNotify, Duration = 3 })
       end,
    })

    -- ========================================================
    --               TAB: PERFORMANCE & EXPLOITS
    -- ========================================================
    MainTab:CreateToggle({
       Name = lang.UltraFixLag,
       CurrentValue = HubConfig.UltraFixLag,
       Flag = "UltraFixLagToggle",
       Callback = function(Value)
          HubConfig.UltraFixLag = Value
          SaveConfig()
          if Value then
             settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
             Lighting.GlobalShadows = false
          end
       end,
    })

    MainTab:CreateToggle({
       Name = lang.Disable3D,
       CurrentValue = HubConfig.DisableRender3D,
       Flag = "Disable3DRendering",
       Callback = function(Value)
          HubConfig.DisableRender3D = Value
          SaveConfig()
          RunService:Set3dRenderingEnabled(not Value)
       end,
    })

    ExploitsTab:CreateSlider({
       Name = lang.WalkSpeed,
       Range = {16, 250},
       Increment = 1,
       Suffix = "Speed",
       CurrentValue = HubConfig.WalkSpeed,
       Flag = "WalkSpeedSlider",
       Callback = function(Value)
          HubConfig.WalkSpeed = Value
          SaveConfig()
       end,
    })

    RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = HubConfig.WalkSpeed
        end
    end)

    Rayfield:Notify({ Title = "Vietnam Hub v1.0 (Beta)", Content = lang.ScriptLoaded, Duration = 4 })
end

-- ========================================================
--                KEY SYSTEM ENGINE
-- ========================================================
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

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Position = UDim2.new(0, 0, 0.16, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Script by Ninh Nguyen"
    Subtitle.TextColor3 = Color3_fromRGB(180, 180, 180)
    Subtitle.TextSize = 13
    Subtitle.Font = Enum.Font.GothamItalic
    Subtitle.Parent = KeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.85, 0, 0, 42)
    KeyInput.Position = UDim2.new(0.075, 0, 0.32, 0)
    KeyInput.BackgroundColor3 = Color3_fromRGB(28, 28, 35)
    KeyInput.TextColor3 = Color3_fromRGB(255, 255, 255)
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.TextSize = 15
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.Parent = KeyFrame

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.85, 0, 0, 38)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0.68, 0)
    SubmitBtn.BackgroundColor3 = Color3_fromRGB(0, 180, 90)
    SubmitBtn.Text = "CONFIRM KEY"
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
