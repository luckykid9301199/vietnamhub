-- [[ VIETNAM HUB BY NINH NGUYEN - V7.1 AUTO REJOIN & CONFIG SAVER ]] --

local CorrectKey = "3011"
local DiscordLink = "https://discord.gg/mAuVhG9HK"
local ConfigFileName = "VietnamHub_Config_v7.json"

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

-- ========================================================
--                 CONFIG SAVER ENGINE (LƯU & ĐỌC)
-- ========================================================
local HubConfig = {
    KeySaved = "",
    RemoveAllVFX = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    NoClip = false,
    Aimbot = false,
    AimPart = "50% Head / 50% Body",
    AimSmooth = 0.15,
    ESP_Skeleton = false,
    ESP_Name = false,
    WebhookURL = "",
    AutoWebhook = false
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
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            for k, v in pairs(data) do
                HubConfig[k] = v
            end
        end)
    end
end

LoadConfig()

-- ========================================================
--         ADVANCED AUTO REJOIN (CHỐNG DISCONNECT/FREEZE)
-- ========================================================
local function SafeRejoin()
    pcall(function()
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end)
end

-- 1. Bắt lỗi Gui Prompt Disconnect của Roblox (Lỗi mạng/Lost connection)
if CoreGui:FindFirstChild("RobloxPromptGui") then
    CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then
            task.wait(1)
            SafeRejoin()
        end
    end)
end

GuiService.ErrorMessageChanged:Connect(function()
    task.wait(1)
    SafeRejoin()
end)

-- 2. Bắt Freeze Ping (Nếu Ping không thay đổi quá 15 giây = Mất mạng/Đơ Server)
task.spawn(function()
    local LastPing = -1
    local FreezeCounter = 0

    while task.wait(3) do
        pcall(function()
            local CurrentPing = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            if CurrentPing == LastPing then
                FreezeCounter = FreezeCounter + 1
            else
                FreezeCounter = 0
                LastPing = CurrentPing
            end

            -- Nếu Freeze quá 5 lần kiểm tra (~15s) -> Tự Rejoin
            if FreezeCounter >= 5 then
                SafeRejoin()
            end
        end)
    end
end)

-- ========================================================
--               HÀM KHỞI CHẠY MAIN ENGINE (V7.1)
-- ========================================================
local function LoadMainHub()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
       Name = "VIETNAM HUB | By Ninh Nguyen v7.1",
       LoadingTitle = "Đang kết nối Vietnam Hub v7.1...",
       LoadingSubtitle = "Auto Rejoin & Config Saver Engine",
       ConfigurationSaving = { Enabled = false },
       Discord = { Enabled = false },
       KeySystem = false
    })

    -- Tabs
    local MainTab = Window:CreateTab("Siêu Tối Ưu AFK", 4483362458)
    local ExploitsTab = Window:CreateTab("Tính Năng Đặc Biệt", 4483362458)
    local CombatTab = Window:CreateTab("Aimbot & Combat", 4483362458)
    local ESPTab = Window:CreateTab("ESP & Visuals", 4483362458)
    local MonitorTab = Window:CreateTab("Dashboard Stats", 4483362458)
    local ToolsTab = Window:CreateTab("Công Cụ AFK Pro", 4483362458)

    -- Variables Global
    local RemoveAllEffectsEnabled = HubConfig.RemoveAllVFX
    local VFXConnection = nil
    local CurrentColor = Color3.fromRGB(0, 0, 0)
    local StartTime = tick()

    -- Player Exploits Variables
    local WalkSpeedValue = HubConfig.WalkSpeed
    local JumpPowerValue = HubConfig.JumpPower
    local InfJumpEnabled = HubConfig.InfJump
    local NoClipEnabled = HubConfig.NoClip

    -- Aimbot Variables
    local AimbotEnabled = HubConfig.Aimbot
    local AimPartMode = HubConfig.AimPart
    local AimbotSmoothness = HubConfig.AimSmooth
    local AimFOV = 200

    -- ESP Variables
    local ESP_SkeletonEnabled = HubConfig.ESP_Skeleton
    local ESP_NameEnabled = HubConfig.ESP_Name

    -- ANTI-AFK ENGINE
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)

    -- BACKGROUND RAM CLEANER
    task.spawn(function()
        while task.wait(60) do
            collectgarbage("step", 100)
        end
    end)

    -- HỆ THỐNG XÓA EFFECT / AURA / VFX SKILL
    local function PurgeVFXObject(obj)
        if not RemoveAllEffectsEnabled then return end
        if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") 
        or obj:IsA("Sparkles") or obj:IsA("Beam") or obj:IsA("Trail") 
        or obj:IsA("Highlight") or obj:IsA("Explosion") then
            pcall(function() obj.Enabled = false obj:Destroy() end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj:Destroy() end)
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        elseif obj:IsA("MeshPart") or obj:IsA("SpecialMesh") then
            obj.TextureID = ""
        end
    end

    local function ApplyFullVFXPurge()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        Lighting.Ambient = CurrentColor
        Lighting.OutdoorAmbient = CurrentColor
        
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then
                pcall(function() v.Enabled = false v:Destroy() end)
            end
        end

        for _, obj in pairs(Workspace:GetDescendants()) do
            PurgeVFXObject(obj)
        end
    end

    local function PurgeGameUIAndAudio()
        pcall(function()
            SoundService.Volume = 0
            for _, sound in pairs(game:GetDescendants()) do
                if sound:IsA("Sound") then
                    sound:Stop()
                    sound.Volume = 0
                end
            end
        end)

        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            for _, gui in pairs(pGui:GetChildren()) do
                if gui:IsA("ScreenGui") and not string.find(gui.Name, "Rayfield") and not string.find(gui.Name, "VietnamHub") then
                    pcall(function() gui:Destroy() end)
                end
            end
        end
    end

    -- ========================================================
    --                   TAB 1: SIÊU TỐI ƯU AFK
    -- ========================================================
    MainTab:CreateToggle({
       Name = "🔥 Xóa Toàn Bộ Effect Game, Hiệu Ứng Skill & Aura",
       CurrentValue = HubConfig.RemoveAllVFX,
       Flag = "RemoveAllVFXToggle",
       Callback = function(Value)
          RemoveAllEffectsEnabled = Value
          HubConfig.RemoveAllVFX = Value
          SaveConfig()

          if RemoveAllEffectsEnabled then
             settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
             ApplyFullVFXPurge()
             VFXConnection = Workspace.DescendantAdded:Connect(function(child)
                 if RemoveAllEffectsEnabled then task.wait() PurgeVFXObject(child) end
             end)
          else
             if VFXConnection then VFXConnection:Disconnect() VFXConnection = nil end
          end
       end,
    })

    MainTab:CreateButton({
       Name = "🧹 Khử Sạch Game UI & Âm Thanh (Chỉ Giữ Lại Script)",
       Callback = function()
          PurgeGameUIAndAudio()
          Rayfield:Notify({ Title = "Super Purge", Content = "Đã dọn dẹp sạch UI & Âm thanh Game!", Duration = 3 })
       end,
    })

    MainTab:CreateToggle({
       Name = "Tắt 3D Rendering (Siêu Tiết Kiệm GPU)",
       CurrentValue = false,
       Flag = "Disable3DRendering",
       Callback = function(Value)
          RunService:Set3dRenderingEnabled(not Value)
       end,
    })

    MainTab:CreateDropdown({
       Name = "Màu Màn Hình AFK",
       Options = {"Màn Hình Đen (Black Screen)", "Màn Hình Trắng (White Screen)"},
       CurrentOption = "Màn Hình Đen (Black Screen)",
       Flag = "ColorDropdown",
       Callback = function(Option)
          CurrentColor = (Option == "Màn Hình Đen (Black Screen)") and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
          if RemoveAllEffectsEnabled then ApplyFullVFXPurge() end
       end,
    })

    MainTab:CreateSlider({
       Name = "Khóa Giới Hạn FPS AFK",
       Range = {1, 60},
       Increment = 1,
       Suffix = "FPS",
       CurrentValue = 15,
       Flag = "FPSSlider",
       Callback = function(Value)
          if setfpscap then setfpscap(Value) end
       end,
    })

    -- ========================================================
    --               TAB 2: TÍNH NĂNG ĐẶC BIỆT (EXPLOITS)
    -- ========================================================
    RunService.Stepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
            if LocalPlayer.Character.Humanoid.UseJumpPower then
                LocalPlayer.Character.Humanoid.JumpPower = JumpPowerValue
            else
                LocalPlayer.Character.Humanoid.JumpHeight = JumpPowerValue / 3
            end
        end
    end)

    ExploitsTab:CreateSlider({
       Name = "Tốc Độ Chạy (WalkSpeed)",
       Range = {16, 200},
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

    ExploitsTab:CreateSlider({
       Name = "Lực Nhảy (JumpPower)",
       Range = {50, 300},
       Increment = 5,
       Suffix = "Power",
       CurrentValue = HubConfig.JumpPower,
       Flag = "JumpPowerSlider",
       Callback = function(Value)
          JumpPowerValue = Value
          HubConfig.JumpPower = Value
          SaveConfig()
       end,
    })

    UserInputService.JumpRequest:Connect(function()
        if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)

    ExploitsTab:CreateToggle({
       Name = "Nhảy Vô Tận (Infinity Jump)",
       CurrentValue = HubConfig.InfJump,
       Flag = "InfJumpToggle",
       Callback = function(Value)
          InfJumpEnabled = Value
          HubConfig.InfJump = Value
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
       Name = "Đi Xuyên Tường (NoClip)",
       CurrentValue = HubConfig.NoClip,
       Flag = "NoClipToggle",
       Callback = function(Value)
          NoClipEnabled = Value
          HubConfig.NoClip = Value
          SaveConfig()
       end,
    })

    -- ========================================================
    --                 TAB 3: AIMBOT & COMBAT
    -- ========================================================
    local function GetClosestPlayer()
        local ClosestPlayer = nil
        local ShortestDistance = AimFOV

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local TargetPartName = "Head"
                if AimPartMode == "Body Only" then
                    TargetPartName = "HumanoidRootPart"
                elseif AimPartMode == "50% Head / 50% Body" then
                    TargetPartName = (math.random(1, 2) == 1) and "Head" or "HumanoidRootPart"
                end

                local TargetPart = player.Character:FindFirstChild(TargetPartName) or player.Character:FindFirstChild("HumanoidRootPart")
                if TargetPart then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPart.Position)
                    if OnScreen then
                        local MousePos = UserInputService:GetMouseLocation()
                        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                        if Distance < ShortestDistance then
                            ClosestPlayer = TargetPart
                            ShortestDistance = Distance
                        end
                    end
                end
            end
        end
        return ClosestPlayer
    end

    RunService.RenderStepped:Connect(function()
        if AimbotEnabled then
            local Target = GetClosestPlayer()
            if Target then
                local CurrentCFrame = Camera.CFrame
                local TargetCFrame = CFrame.new(CurrentCFrame.Position, Target.Position)
                Camera.CFrame = CurrentCFrame:Lerp(TargetCFrame, AimbotSmoothness)
            end
        end
    end)

    CombatTab:CreateToggle({
       Name = "Bật Aimbot Khóa Góc Nhìn",
       CurrentValue = HubConfig.Aimbot,
       Flag = "AimbotToggle",
       Callback = function(Value)
          AimbotEnabled = Value
          HubConfig.Aimbot = Value
          SaveConfig()
       end,
    })

    CombatTab:CreateDropdown({
       Name = "Vị Trí Ngắm (Aimbot Target Part)",
       Options = {"50% Head / 50% Body", "Head Only (Chỉ Đầu)", "Body Only (Chỉ Thân)"},
       CurrentOption = HubConfig.AimPart,
       Flag = "AimPartDropdown",
       Callback = function(Option)
          AimPartMode = Option
          HubConfig.AimPart = Option
          SaveConfig()
       end,
    })

    CombatTab:CreateSlider({
       Name = "Độ Mượt Ngắm (Aimbot Smoothness)",
       Range = {0.05, 0.5},
       Increment = 0.05,
       Suffix = "Smooth",
       CurrentValue = HubConfig.AimSmooth,
       Flag = "AimSmoothSlider",
       Callback = function(Value)
          AimbotSmoothness = Value
          HubConfig.AimSmooth = Value
          SaveConfig()
       end,
    })

    -- ========================================================
    --                 TAB 4: ESP & VISUALS
    -- ========================================================
    local SkeletonColor = Color3.fromRGB(0, 255, 100)

    local function DrawSkeletonForPlayer(plr)
        local Lines = {}
        local function CreateLine()
            local line = Drawing.new("Line")
            line.Color = SkeletonColor
            line.Thickness = 1.5
            line.Transparency = 1
            line.Visible = false
            table.insert(Lines, line)
            return line
        end

        local l_Head_Torso = CreateLine()
        local l_Torso_LArm = CreateLine()
        local l_Torso_RArm = CreateLine()
        local l_Torso_LLeg = CreateLine()
        local l_Torso_RLeg = CreateLine()

        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if ESP_SkeletonEnabled and plr and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr ~= LocalPlayer then
                local char = plr.Character
                local head = char:FindFirstChild("Head")
                local torso = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                local l_arm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
                local r_arm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
                local l_leg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg")
                local r_leg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")

                if head and torso then
                    local function UpdateLine(line, part1, part2)
                        if part1 and part2 then
                            local pos1, vis1 = Camera:WorldToViewportPoint(part1.Position)
                            local pos2, vis2 = Camera:WorldToViewportPoint(part2.Position)
                            if vis1 and vis2 then
                                line.From = Vector2.new(pos1.X, pos1.Y)
                                line.To = Vector2.new(pos2.X, pos2.Y)
                                line.Visible = true
                                return
                            end
                        end
                        line.Visible = false
                    end

                    UpdateLine(l_Head_Torso, head, torso)
                    UpdateLine(l_Torso_LArm, torso, l_arm)
                    UpdateLine(l_Torso_RArm, torso, r_arm)
                    UpdateLine(l_Torso_LLeg, torso, l_leg)
                    UpdateLine(l_Torso_RLeg, torso, r_leg)
                else
                    for _, l in pairs(Lines) do l.Visible = false end
                end
            else
                for _, l in pairs(Lines) do l.Visible = false end
                if not plr or not plr.Parent then
                    for _, l in pairs(Lines) do l:Remove() end
                    Connection:Disconnect()
                end
            end
        end)
    end

    for _, plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer then DrawSkeletonForPlayer(plr) end end
    Players.PlayerAdded:Connect(function(plr) DrawSkeletonForPlayer(plr) end)

    ESPTab:CreateToggle({
       Name = "Bật ESP Khung Người Que Màu Xanh (Skeleton)",
       CurrentValue = HubConfig.ESP_Skeleton,
       Flag = "SkeletonESPToggle",
       Callback = function(Value)
          ESP_SkeletonEnabled = Value
          HubConfig.ESP_Skeleton = Value
          SaveConfig()
       end,
    })

    local function AddNameESP(plr)
        task.spawn(function()
            while task.wait(1) do
                if ESP_NameEnabled and plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                    if not plr.Character.Head:FindFirstChild("NameTagESP") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "NameTagESP"
                        billboard.Adornee = plr.Character.Head
                        billboard.Size = UDim2.new(0, 100, 0, 30)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.AlwaysOnTop = true

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = plr.Name
                        nameLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                        nameLabel.TextSize = 14
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.Parent = billboard

                        billboard.Parent = plr.Character.Head
                    end
                else
                    if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("NameTagESP") then
                        plr.Character.Head.NameTagESP:Destroy()
                    end
                end
            end
        end)
    end

    for _, plr in pairs(Players:GetPlayers()) do AddNameESP(plr) end
    Players.PlayerAdded:Connect(AddNameESP)

    ESPTab:CreateToggle({
       Name = "Hiện Tên Người Chơi (Name ESP)",
       CurrentValue = HubConfig.ESP_Name,
       Flag = "NameESPToggle",
       Callback = function(Value)
          ESP_NameEnabled = Value
          HubConfig.ESP_Name = Value
          SaveConfig()
       end,
    })

    -- ========================================================
    --                 TAB 5: DASHBOARD STATS
    -- ========================================================
    local FPSLabel = MonitorTab:CreateLabel("FPS Hiện Tại: Đang tính...")
    local PingLabel = MonitorTab:CreateLabel("Ping: Đang tính...")
    local RAMLabel = MonitorTab:CreateLabel("RAM Sử Dụng: Đang tính...")
    local UptimeLabel = MonitorTab:CreateLabel("Thời Gian Đã Treo: 00g 00p 00s")

    task.spawn(function()
        local FrameCount = 0
        local LastFPSUpdate = tick()
        local CurrentFPS = 60

        RunService.RenderStepped:Connect(function()
            FrameCount = FrameCount + 1
            if tick() - LastFPSUpdate >= 1 then
                CurrentFPS = FrameCount
                FrameCount = 0
                LastFPSUpdate = tick()
            end
        end)

        while task.wait(1) do
            pcall(function()
                local TotalSeconds = math.floor(tick() - StartTime)
                local Hours = math.floor(TotalSeconds / 3600)
                local Mins = math.floor((TotalSeconds % 3600) / 60)
                local Secs = TotalSeconds % 60
                
                local Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                local MemoryMB = math.floor(Stats:GetTotalMemoryUsageMb())

                FPSLabel:Set("FPS Hiện Tại: " .. tostring(CurrentFPS) .. " FPS")
                PingLabel:Set("Ping Hiện Tại: " .. tostring(Ping) .. " ms")
                RAMLabel:Set("RAM Game Ngốn: " .. tostring(MemoryMB) .. " MB")
                UptimeLabel:Set(string.format("Thời Gian Treo: %02dg %02dp %02ds", Hours, Mins, Secs))
            end)
        end
    end)

    -- ========================================================
    --                 TAB 6: CÔNG CỤ AFK PRO
    -- ========================================================
    ToolsTab:CreateButton({
       Name = "🧹 Smart RAM Cleaner (Giải Phóng Bộ Nhớ Ngay)",
       Callback = function()
          collectgarbage("collect")
          Rayfield:Notify({ Title = "RAM Cleaner", Content = "Đã dọn dẹp bộ nhớ RAM thừa thành công!", Duration = 3 })
       end,
    })

    ToolsTab:CreateButton({
       Name = "🌐 Auto Server Hop (Sang Server Ít Người)",
       Callback = function()
          Rayfield:Notify({ Title = "Server Hop", Content = "Đang tìm Server ít người nhất...", Duration = 3 })
          task.spawn(function()
             pcall(function()
                local PlaceId = game.PlaceId
                local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/0?sortOrder=Asc&limit=100")).data
                for _, server in pairs(Servers) do
                   if server.playing < server.maxPlayers and server.id ~= game.JobId then
                      TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                      break
                   end
                end
             end)
          end)
       end,
    })

    ToolsTab:CreateInput({
       Name = "Nhập Discord Webhook URL",
       PlaceholderText = HubConfig.WebhookURL ~= "" and HubConfig.WebhookURL or "https://discord.com/api/webhooks/...",
       RemoveTextOnFocus = false,
       Callback = function(Text)
          HubConfig.WebhookURL = Text
          SaveConfig()
       end,
    })

    local function SendDiscordWebhookAsync()
        local WebhookURL = HubConfig.WebhookURL
        if WebhookURL == "" or not string.find(WebhookURL, "http") then
            Rayfield:Notify({ Title = "Webhook Error", Content = "Vui lòng nhập Webhook URL hợp lệ!", Duration = 3 })
            return
        end

        task.spawn(function()
            pcall(function()
                local TotalSeconds = math.floor(tick() - StartTime)
                local Hours = math.floor(TotalSeconds / 3600)
                local Mins = math.floor((TotalSeconds % 3600) / 60)
                local MemoryMB = math.floor(Stats:GetTotalMemoryUsageMb())
                local Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

                local Payload = {
                    ["embeds"] = {{
                        ["title"] = "🇻🇳 Vietnam Hub v7.1 - Báo Cáo Trạng Thái AFK",
                        ["color"] = 65280,
                        ["fields"] = {
                            {["name"] = "👤 Tên Tài Khoản", ["value"] = LocalPlayer.Name, ["inline"] = true},
                            {["name"] = "🎮 Game Place ID", ["value"] = tostring(game.PlaceId), ["inline"] = true},
                            {["name"] = "⏳ Uptime (Đã Treo)", ["value"] = string.format("%02dg %02dp", Hours, Mins), ["inline"] = true},
                            {["name"] = "📊 RAM Ngốn", ["value"] = tostring(MemoryMB) .. " MB", ["inline"] = true},
                            {["name"] = "📶 Ping Server", ["value"] = tostring(Ping) .. " ms", ["inline"] = true}
                        },
                        ["footer"] = {["text"] = "Vietnam Hub Engine v7.1 Auto Recover"}
                    }}
                }

                local Request = (syn and syn.request) or (http and http.request) or http_request or request
                if Request then
                    Request({
                        Url = WebhookURL,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = HttpService:JSONEncode(Payload)
                    })
                    Rayfield:Notify({ Title = "Webhook", Content = "Đã gửi báo cáo ngầm về Discord!", Duration = 3 })
                end
            end)
        end)
    end

    ToolsTab:CreateButton({
       Name = "📡 Gửi Báo Cáo Trạng Thái Về Discord Ngay",
       Callback = function()
          SendDiscordWebhookAsync()
       end,
    })

    ToolsTab:CreateToggle({
       Name = "⏰ Tự Động Gửi Báo Cáo Discord Mọi 30 Phút",
       CurrentValue = HubConfig.AutoWebhook,
       Flag = "AutoWebhookToggle",
       Callback = function(Value)
          HubConfig.AutoWebhook = Value
          SaveConfig()
          if HubConfig.AutoWebhook then
             task.spawn(function()
                while HubConfig.AutoWebhook do
                   task.wait(1800)
                   if HubConfig.AutoWebhook then SendDiscordWebhookAsync() end
                end
             end)
          end
       end,
    })

    -- TỰ ĐỘNG CHẠY BẢO TRÌ BỎ EFFECT NẾU TRONG CONFIG ĐÃ BẬT SẴN
    if HubConfig.RemoveAllVFX then
        task.wait(1)
        ApplyFullVFXPurge()
    end

    Rayfield:Notify({ Title = "Vietnam Hub v7.1", Content = "Đã tải thành công Cấu hình Cũ của bạn!", Duration = 4 })
end

-- ================================================================================
--              XỬ LÝ KEY SYSTEM & AUTO KEY BYPASS (NẾU ĐÃ LƯU)
-- ================================================================================
if HubConfig.KeySaved == CorrectKey then
    -- Tự chạy Script luôn không cần vẽ GUI Key
    LoadMainHub()
else
    -- Nếu chưa nhập thành công lần nào thì hiện UI Key
    local KeyScreenGui = Instance.new("ScreenGui")
    KeyScreenGui.Name = "VietnamHub_KeySystem"
    KeyScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    KeyScreenGui.ResetOnSpawn = false

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = "MainFrame"
    KeyFrame.Size = UDim2.new(0, 380, 0, 230)
    KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -115)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Active = true
    KeyFrame.Draggable = true
    KeyFrame.Parent = KeyScreenGui

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 12)
    KeyCorner.Parent = KeyFrame

    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Thickness = 2
    KeyStroke.Color = Color3.fromRGB(255, 205, 0)
    KeyStroke.Parent = KeyFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Text = "🇻🇳 VIETNAM HUB - KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(255, 205, 0)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = KeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.85, 0, 0, 42)
    KeyInput.Position = UDim2.new(0.075, 0, 0.26, 0)
    KeyInput.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.PlaceholderText = "Nhập Key tại đây..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    KeyInput.Text = ""
    KeyInput.TextSize = 15
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.Parent = KeyFrame

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = KeyInput

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0, 0, 0.49, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Vui lòng nhập key để tiếp tục"
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    StatusLabel.TextSize = 13
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.Parent = KeyFrame

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.41, 0, 0, 38)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    SubmitBtn.Text = "XÁC NHẬN KEY"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 14
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = KeyFrame

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 8)
    SubmitCorner.Parent = SubmitBtn

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0.41, 0, 0, 38)
    GetKeyBtn.Position = UDim2.new(0.515, 0, 0.7, 0)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 230)
    GetKeyBtn.Text = "GET KEY (DISCORD)"
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.TextSize = 14
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Parent = KeyFrame

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 8)
    GetKeyCorner.Parent = GetKeyBtn

    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DiscordLink)
        end
        StatusLabel.TextColor3 = Color3.fromRGB(255, 205, 0)
        StatusLabel.Text = "Đã copy Link Discord! Vui lòng dán vào trình duyệt."
    end)

    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text == CorrectKey then
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
            StatusLabel.Text = "Key chính xác! Đang tải Vietnam Hub v7.1..."
            HubConfig.KeySaved = CorrectKey
            SaveConfig()
            task.wait(1)
            KeyScreenGui:Destroy()
            LoadMainHub()
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
            StatusLabel.Text = "Key không đúng! Vui lòng kiểm tra lại."
        end
    end)
end