-- [[ VIETNAM HUB BY NINH NGUYEN - V5.0 SUPER AFK & ANTI-LAG ]] --

local CorrectKey = "3011"
local DiscordLink = "https://discord.gg/your-link-here"

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
--                      KEY SYSTEM UI
-- ========================================================
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
GetKeyBtn.Parent = GetKeyFrame or KeyFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 8)
GetKeyCorner.Parent = GetKeyBtn

GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DiscordLink)
    end
    StatusLabel.TextColor3 = Color3.fromRGB(255, 205, 0)
    StatusLabel.Text = "Đã copy Link! Vui lòng vào Discord lấy Key."
end)

-- ========================================================
--               HÀM KHỞI CHẠY MAIN ENGINE (V5.0)
-- ========================================================
local function LoadMainHub()
    KeyScreenGui:Destroy()
    
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
       Name = "VIETNAM HUB | By Ninh Nguyen v5.0",
       LoadingTitle = "Đang kết nối Vietnam Hub v5.0...",
       LoadingSubtitle = "Super Anti-Lag & Smooth Webhook System",
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
    local UltraPotatoEnabled = false
    local Connection = nil
    local CurrentColor = Color3.fromRGB(0, 0, 0)
    local StartTime = tick()
    local WebhookURL = ""
    local AutoWebhookEnabled = false

    -- Player Exploits Variables
    local WalkSpeedValue = 16
    local JumpPowerValue = 50
    local InfJumpEnabled = false
    local NoClipEnabled = false
    local InvisibleEnabled = false

    -- Aimbot Variables
    local AimbotEnabled = false
    local AimPartMode = "50% Head / 50% Body"
    local AimbotSmoothness = 0.15
    local AimFOV = 200

    -- ESP Variables
    local ESP_SkeletonEnabled = false
    local ESP_NameEnabled = false

    -- 1. AUTO REJOIN ENGINE
    local function SetupAutoRejoin()
        local function Rejoin()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
        if CoreGui:FindFirstChild("RobloxPromptGui") then
            CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == "ErrorPrompt" then
                    task.wait(2)
                    Rejoin()
                end
            end)
        end
        GuiService.ErrorMessageChanged:Connect(function()
            task.wait(2)
            Rejoin()
        end)
    end
    SetupAutoRejoin()

    -- 2. ANTI-AFK ENGINE
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)

    -- 3. AUTO RAM CLEANER THREAD (3 phút 1 lần)
    task.spawn(function()
        while task.wait(180) do
            collectgarbage("collect")
        end
    end)

    -- 4. POTATO CLEANER ENGINE
    local function SupremeCleanObject(obj)
        if not UltraPotatoEnabled then return end
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Color = CurrentColor
            obj.CastShadow = false
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then child:Destroy() end
            end
        elseif obj:IsA("MeshPart") or obj:IsA("SpecialMesh") then
            obj.TextureID = ""
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") 
            or obj:IsA("Sparkles") or obj:IsA("Beam") or obj:IsA("Trail") then
            obj.Enabled = false
            obj:Destroy()
        elseif obj:IsA("Highlight") then
            obj:Destroy()
        elseif obj:IsA("Explosion") then
            obj.Visible = false
        elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("Accessory") then
            obj:Destroy()
        end
    end

    local function ApplySuperPotato()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        Lighting.Ambient = CurrentColor
        Lighting.OutdoorAmbient = CurrentColor
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("SunRaysEffect") then
                pcall(function() v.Enabled = false v:Destroy() end)
            end
        end
        for _, obj in pairs(Workspace:GetDescendants()) do
            SupremeCleanObject(obj)
        end
    end

    -- 5. HÀM KHỬ SẠCH UI GAME VÀ ÂM THANH
    local function PurgeGameUIAndAudio()
        -- Tắt Volume Game
        pcall(function()
            SoundService.Volume = 0
            for _, sound in pairs(game:GetDescendants()) do
                if sound:IsA("Sound") then
                    sound:Stop()
                    sound.Volume = 0
                end
            end
        end)

        -- Ẩn/Xóa toàn bộ UI của Game trong PlayerGui (Trừ Script UI)
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
    MainTab:CreateButton({
       Name = "🧹 Khử Sạch Game UI & Âm Thanh (Chỉ Giữ Lại Script)",
       Callback = function()
          PurgeGameUIAndAudio()
          Rayfield:Notify({ Title = "Super Purge", Content = "Đã dọn dẹp sạch UI & Âm thanh Game!", Duration = 3 })
       end,
    })

    MainTab:CreateToggle({
       Name = "Bật Siêu Cấp Potato Mode (Xóa Hiệu Ứng / Skill)",
       CurrentValue = false,
       Flag = "UltraPotatoToggle",
       Callback = function(Value)
          UltraPotatoEnabled = Value
          if UltraPotatoEnabled then
             settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
             ApplySuperPotato()
             Connection = Workspace.DescendantAdded:Connect(function(child)
                 if UltraPotatoEnabled then task.wait() SupremeCleanObject(child) end
             end)
             Rayfield:Notify({ Title = "Vietnam Hub", Content = "Đã bật Potato Mode! Tối ưu cực hạn CPU/GPU.", Duration = 3 })
          else
             if Connection then Connection:Disconnect() Connection = nil end
             Rayfield:Notify({ Title = "Vietnam Hub", Content = "Đã tắt Potato Mode (Rejoin để hồi phục đồ họa)", Duration = 3 })
          end
       end,
    })

    MainTab:CreateToggle({
       Name = "Tắt 3D Rendering (Siêu Tiết Kiệm GPU)",
       CurrentValue = false,
       Flag = "Disable3DRendering",
       Callback = function(Value)
          RunService:Set3dRenderingEnabled(not Value)
          if Value then
              Rayfield:Notify({ Title = "Vietnam Hub: 3D OFF", Content = "Đã ngắt dựng hình 3D! GPU được giảm 90%.", Duration = 3 })
          else
              Rayfield:Notify({ Title = "Vietnam Hub: 3D ON", Content = "Đã mở lại 3D Rendering.", Duration = 3 })
          end
       end,
    })

    MainTab:CreateDropdown({
       Name = "Màu Màn Hình AFK",
       Options = {"Màn Hình Đen (Black Screen)", "Màn Hình Trắng (White Screen)"},
       CurrentOption = "Màn Hình Đen (Black Screen)",
       Flag = "ColorDropdown",
       Callback = function(Option)
          CurrentColor = (Option == "Màn Hình Đen (Black Screen)") and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
          if UltraPotatoEnabled then ApplySuperPotato() end
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
       CurrentValue = 16,
       Flag = "WalkSpeedSlider",
       Callback = function(Value) WalkSpeedValue = Value end,
    })

    ExploitsTab:CreateSlider({
       Name = "Lực Nhảy (JumpPower)",
       Range = {50, 300},
       Increment = 5,
       Suffix = "Power",
       CurrentValue = 50,
       Flag = "JumpPowerSlider",
       Callback = function(Value) JumpPowerValue = Value end,
    })

    UserInputService.JumpRequest:Connect(function()
        if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)

    ExploitsTab:CreateToggle({
       Name = "Nhảy Vô Tận (Infinity Jump)",
       CurrentValue = false,
       Flag = "InfJumpToggle",
       Callback = function(Value) InfJumpEnabled = Value end,
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
       CurrentValue = false,
       Flag = "NoClipToggle",
       Callback = function(Value) NoClipEnabled = Value end,
    })

    ExploitsTab:CreateToggle({
       Name = "Tàng Hình (Invisibility)",
       CurrentValue = false,
       Flag = "InvisToggle",
       Callback = function(Value)
          InvisibleEnabled = Value
          if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
             local char = LocalPlayer.Character
             if InvisibleEnabled then
                local savedCFrame = char.HumanoidRootPart.CFrame
                local clone = char.HumanoidRootPart:Clone()
                char.HumanoidRootPart:Destroy()
                clone.Parent = char
                char.HumanoidRootPart.CFrame = savedCFrame
                Rayfield:Notify({ Title = "Vietnam Hub", Content = "Đã bật tàng hình đối với Server!", Duration = 3 })
             else
                Rayfield:Notify({ Title = "Vietnam Hub", Content = "Hãy Reset nhân vật để trở lại bình thường.", Duration = 3 })
             end
          end
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
       CurrentValue = false,
       Flag = "AimbotToggle",
       Callback = function(Value) AimbotEnabled = Value end,
    })

    CombatTab:CreateDropdown({
       Name = "Vị Trí Ngắm (Aimbot Target Part)",
       Options = {"50% Head / 50% Body", "Head Only (Chỉ Đầu)", "Body Only (Chỉ Thân)"},
       CurrentOption = "50% Head / 50% Body",
       Flag = "AimPartDropdown",
       Callback = function(Option) AimPartMode = Option end,
    })

    CombatTab:CreateSlider({
       Name = "Độ Mượt Ngắm (Aimbot Smoothness)",
       Range = {0.05, 0.5},
       Increment = 0.05,
       Suffix = "Smooth",
       CurrentValue = 0.15,
       Flag = "AimSmoothSlider",
       Callback = function(Value) AimbotSmoothness = Value end,
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
       