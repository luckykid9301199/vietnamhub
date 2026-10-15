-- ================================================================================
-- VIETNAM HUB BY NINH NGUYEN - SLOP TD ENTERPRISE SUITE (DELTA MOBILE OPTIMIZED)
-- ================================================================================
local CorrectKey = "3011"
local DiscordLink = "https://discord.gg/3JrDAhT9k"
local KeyFileName = "SlopTD_SavedKey.txt"

-- Auto Queue Teleport
if queue_on_teleport then
    pcall(function()
        queue_on_teleport([[
            loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
        ]])
    end)
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local LoadMainScript

local function CheckSavedKey()
    local success, result = pcall(function()
        if isfile and readfile and isfile(KeyFileName) then
            return readfile(KeyFileName) == CorrectKey
        end
        return false
    end)
    return success and result
end

LoadMainScript = function()
    local Window = Rayfield:CreateWindow({
       Name = "Vietnam Hub by Ninh Nguyen | Delta Mobile Edition",
       LoadingTitle = "Loading Vietnam Hub Engine...",
       LoadingSubtitle = "Priority Queue • Delta Optimized • Auto AI Engine",
       ConfigurationSaving = { Enabled = true, FolderName = "VietnamHub_Config" },
       Discord = { Enabled = false },
       KeySystem = false
    })

    -- Services
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local VirtualUser = game:GetService("VirtualUser")
    local HttpService = game:GetService("HttpService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    -- Anti AFK Cấp Hệ Thống Cho Delta
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
        end)
    end)

    -- Hàm Kích Hoạt Nút UI Trực Tiếp Chuẩn Delta Executor
    local function ForceClickButton(btn)
        if not btn then return end
        pcall(function()
            if firesignal then
                firesignal(btn.MouseButton1Click)
                firesignal(btn.MouseButton1Down)
                firesignal(btn.Activated)
            elseif getconnections then
                for _, conn in pairs(getconnections(btn.MouseButton1Click or btn.Activated)) do
                    pcall(function() conn:Fire() end)
                end
            end
        end)
    end

    -- ================================================================================
    -- TAB 1: LAG & AFK CONFIG
    -- ================================================================================
    local MainTab = Window:CreateTab("Lag & AFK Config", 4483362458)
    local UltraPotatoEnabled = false
    local CurrentColor = Color3.fromRGB(0, 0, 0)

    local function DestroyModelVisuals(obj)
        pcall(function()
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
            elseif obj:IsA("Explosion") then
                obj.Visible = false
            end
        end)
    end

    MainTab:CreateToggle({
       Name = "Enable Ultra Potato Mode (Remove Model/Effect)",
       CurrentValue = false, Flag = "UltraPotatoToggle",
       Callback = function(Value)
          UltraPotatoEnabled = Value
          if UltraPotatoEnabled then
             pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
             Lighting.GlobalShadows = false
             Lighting.FogEnd = 9e9
             for _, obj in pairs(Workspace:GetDescendants()) do DestroyModelVisuals(obj) end
             Rayfield:Notify({ Title = "Ultra Potato Enabled", Content = "Hidden models & effects!", Duration = 3 })
          end
       end,
    })

    MainTab:CreateSlider({
       Name = "FPS Limit AFK (Reduce CPU)",
       Range = {5, 60}, Increment = 5, Suffix = "FPS", CurrentValue = 15, Flag = "FPSSlider",
       Callback = function(Value)
          if setfpscap then pcall(function() setfpscap(Value) end) end
       end,
    })


    -- ================================================================================
    -- TAB 2: MACRO & REPLAY (NÂNG CẤP CHO DELTA EXECUTOR)
    -- ================================================================================
    local MacroTab = Window:CreateTab("1. Macro & Replay", 4483362458)
    local IsRecording = false
    local IsReplaying = false
    local MacroData = {}
    local RecordStartTime = 0
    local AutoInGameReplayEnabled = true

    -- Lắng nghe cảm ứng bấm màn hình để lưu Macro trên Delta
    UserInputService.InputBegan:Connect(function(input)
        if IsRecording and input.UserInputType == Enum.UserInputType.MouseButton1 then
            pcall(function()
                local mousePos = UserInputService:GetMouseLocation()
                local timeOffset = tick() - RecordStartTime
                local viewSize = Camera.ViewportSize
                table.insert(MacroData, { 
                    Time = timeOffset, 
                    PctX = mousePos.X / viewSize.X, 
                    PctY = mousePos.Y / viewSize.Y 
                })
                Rayfield:Notify({ Title = "Delta Macro", Content = "Recorded action #" .. #MacroData, Duration = 0.8 })
            end)
        end
    end)

    MacroTab:CreateToggle({
       Name = "Record Macro Actions",
       CurrentValue = false, Flag = "RecordMacroToggle",
       Callback = function(Value)
          IsRecording = Value
          if IsRecording then
             IsReplaying = false
             MacroData = {}
             RecordStartTime = tick()
             Rayfield:Notify({ Title = "Macro", Content = "Started recording touch actions...", Duration = 2 })
          else
             Rayfield:Notify({ Title = "Macro", Content = "Stopped. Total steps: " .. #MacroData, Duration = 2 })
          end
       end,
    })

    MacroTab:CreateToggle({
       Name = "Replay Macro Loop",
       CurrentValue = false, Flag = "ReplayMacroToggle",
       Callback = function(Value)
          IsReplaying = Value
          if IsReplaying then
             IsRecording = false
             if #MacroData == 0 then
                 Rayfield:Notify({ Title = "Macro Error", Content = "No macro data recorded!", Duration = 3 })
                 IsReplaying = false return
             end
             
             task.spawn(function()
                 while IsReplaying do
                     local startTime = tick()
                     local currentView = Camera.ViewportSize
                     for _, step in ipairs(MacroData) do
                         if not IsReplaying then break end
                         local waitTime = step.Time - (tick() - startTime)
                         if waitTime > 0 then task.wait(waitTime) end
                         if not IsReplaying then break end
                         pcall(function()
                             VirtualUser:Button1Down(Vector2.new(step.PctX * currentView.X, step.PctY * currentView.Y))
                             task.wait(0.02)
                             VirtualUser:Button1Up(Vector2.new(step.PctX * currentView.X, step.PctY * currentView.Y))
                         end)
                     end
                     task.wait(1)
                 end
             end)
          end
       end,
    })

    MacroTab:CreateButton({
       Name = "Save Macro to File",
       Callback = function()
          pcall(function()
              if writefile and #MacroData > 0 then
                  writefile("VietnamHub_DeltaMacro.json", HttpService:JSONEncode(MacroData))
                  Rayfield:Notify({ Title = "Macro Saved", Content = "Saved to VietnamHub_DeltaMacro.json", Duration = 2 })
              end
          end)
       end,
    })

    MacroTab:CreateButton({
       Name = "Load Macro from File",
       Callback = function()
          pcall(function()
              if readfile and isfile and isfile("VietnamHub_DeltaMacro.json") then
                  MacroData = HttpService:JSONDecode(readfile("VietnamHub_DeltaMacro.json"))
                  Rayfield:Notify({ Title = "Macro Loaded", Content = "Loaded " .. #MacroData .. " steps successfully!", Duration = 2 })
              end
          end)
       end,
    })

    -- Auto Replay Fix Dựa Trên Video Thực Tế
    MacroTab:CreateToggle({
       Name = "Auto In-Game Replay (Never Return Lobby)",
       CurrentValue = true, Flag = "AutoInGameReplayToggle",
       Callback = function(Value)
          AutoInGameReplayEnabled = Value
          task.spawn(function()
              while AutoInGameReplayEnabled do
                  task.wait(1.5)
                  pcall(function()
                      local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                      if playerGui then
                          for _, btn in pairs(playerGui:GetDescendants()) do
                              if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Visible then
                                  local txt = ""
                                  if btn:IsA("TextButton") then txt = btn.Text:lower() end
                                  local label = btn:FindFirstChildOfClass("TextLabel")
                                  if label then txt = txt .. " " .. label.Text:lower() end
                                  
                                  if (txt:find("replay") or txt:find("play again") or txt:find("retry")) and not txt:find("lobby") then
                                      ForceClickButton(btn)
                                      Rayfield:Notify({ Title = "Auto Replay", Content = "Match restarted successfully!", Duration = 3 })
                                      task.wait(5)
                                      break
                                  end
                              end
                          end
                      end
                  end)
              end
          end)
       end,
    })


    -- ================================================================================
    -- TAB 3: AI HỖ TRỢ PLAY (AUTO SPEED, PACT, UPGRADE, PLACEMENT)
    -- ================================================================================
    local AITab = Window:CreateTab("2. AI Hỗ Trợ Play", 4483362458)
    local AntiImHereEnabled = true
    local AutoSpeedEnabled = true
    local SelectedMaxSpeed = "Max Possible"
    local AutoSkipWavesEnabled = true
    local AutoPactsEnabled = true
    local AutoUpgradeSingleEnabled = false
    local AutoUpgradeAllEnabled = false
    local AIEndlessBackroomEnabled = false

    -- AI Priority Engine Loop (Quét UI liên tục dựa trên video thực tế)
    task.spawn(function()
        while true do
            task.wait(0.4)
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if not playerGui then return end

                -- 1. Anti "I'm Here" (Chống AFK Check)
                if AntiImHereEnabled then
                    for _, desc in pairs(playerGui:GetDescendants()) do
                        if desc:IsA("TextButton") or desc:IsA("TextLabel") then
                            local txt = desc.Text:lower()
                            if txt:find("i'm here") or txt:find("im here") or txt:find("here") then
                                local btn = desc:IsA("TextButton") and desc or desc:FindFirstAncestorOfClass("TextButton") or desc.Parent
                                ForceClickButton(btn)
                            end
                        end
                    end
                end

                -- 2. Auto Select Safe Pacts (Dựa trên video bảng Seal a Pact)
                if AutoPactsEnabled then
                    for _, label in pairs(playerGui:GetDescendants()) do
                        if label:IsA("TextLabel") and label.Text:find("SEAL A PACT") then
                            local container = label.Parent
                            local safePactBtn = nil
                            for _, card in pairs(container:GetChildren()) do
                                local desc = ""
                                for _, child in pairs(card:GetDescendants()) do
                                    if child:IsA("TextLabel") then desc = desc .. " " .. child.Text end
                                end
                                -- Chọn pact không bị trừ phần thưởng (% rewards penalty)
                                if not desc:find("-%d+%% rewards") and not desc:find("rewards penalty") then
                                    local btn = card:FindFirstChildOfClass("TextButton") or card:FindFirstChild("PACT")
                                    if btn then safePactBtn = btn break end
                                end
                            end
                            if safePactBtn then
                                ForceClickButton(safePactBtn)
                                task.wait(1)
                            else
                                local refuse = container:FindFirstChild("Refuse") or container:FindFirstChild("Later")
                                if refuse then ForceClickButton(refuse) task.wait(1) end
                            end
                        end
                    end
                end

                -- 3. Auto Skip Waves
                if AutoSkipWavesEnabled then
                    for _, btn in pairs(playerGui:GetDescendants()) do
                        if btn:IsA("TextButton") and btn.Visible and (btn.Text:lower():find("skip") or btn.Name:lower():find("skip")) then
                            ForceClickButton(btn)
                            break
                        end
                    end
                end

                -- 4. Auto Upgrade Selected Unit (Single)
                if AutoUpgradeSingleEnabled then
                    for _, btn in pairs(playerGui:GetDescendants()) do
                        if btn:IsA("TextButton") and btn.Visible and btn.Text:find("Upgrade") and not btn.Text:find("All") then
                            ForceClickButton(btn)
                        end
                    end
                end

                -- 5. Auto Upgrade All Units
                if AutoUpgradeAllEnabled then
                    for _, btn in pairs(playerGui:GetDescendants()) do
                        if btn:IsA("TextButton") and btn.Text:find("Units") then
                            ForceClickButton(btn)
                            task.wait(0.2)
                            break
                        end
                    end
                    for _, btn in pairs(playerGui:GetDescendants()) do
                        if btn:IsA("TextButton") and btn.Visible and btn.Text:find("Upgrade All") then
                            ForceClickButton(btn)
                        end
                    end
                end
            end)
        end
    end)

    -- Auto Game Speed Loop (Dựa trên giao diện Game speed x1 -> x6 trong video)
    AITab:CreateSection("Speed Control (x1 - x6)")
    AITab:CreateToggle({
       Name = "Auto Game Speed Toggle",
       CurrentValue = true, Flag = "AutoSpeedToggle",
       Callback = function(Value)
          AutoSpeedEnabled = Value
          task.spawn(function()
              while AutoSpeedEnabled do
                  task.wait(1.5)
                  pcall(function()
                      local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                      if playerGui then
                          local targetSpeeds = (SelectedMaxSpeed == "Max Possible") and {"x6", "x5", "x4", "x3", "x2", "x1"} or {}
                          if SelectedMaxSpeed ~= "Max Possible" then
                              local num = tonumber(SelectedMaxSpeed:match("%d+"))
                              if num then for i = num, 1, -1 do table.insert(targetSpeeds, "x" .. i) end end
                          end

                          -- Quét các nút bấm đổi Speed hiển thị trên màn hình
                          local speedClicked = false
                          for _, spd in ipairs(targetSpeeds) do
                              for _, btn in pairs(playerGui:GetDescendants()) do
                                  if (btn:IsA("TextButton") or btn:IsA("ImageButton") or btn:IsA("TextLabel")) and btn.Visible then
                                      local txt = btn:IsA("TextLabel") and btn.Text or (btn:IsA("TextButton") and btn.Text or "")
                                      if txt:lower():find(spd) and not txt:lower():find("vip") then
                                          local targetBtn = btn:IsA("TextButton") and btn or btn.Parent
                                          ForceClickButton(targetBtn)
                                          speedClicked = true
                                          break
                                      end
                                  end
                              end
                              if speedClicked then break end
                          end
                      end
                  end)
              end
          end)
       end,
    })

    AITab:CreateDropdown({
       Name = "Select Max Game Speed",
       Options = {"Max Possible", "x6 Speed", "x5 Speed", "x4 Speed", "x3 Speed", "x2 Speed", "x1 Speed"},
       CurrentOption = "Max Possible", Flag = "SpeedDropdown",
       Callback = function(Option)
          SelectedMaxSpeed = Option
          Rayfield:Notify({ Title = "Speed Selected", Content = "Target Speed: " .. Option, Duration = 2 })
       end,
    })

    AITab:CreateSection("Automation Unit Upgrades")
    AITab:CreateToggle({
       Name = "Auto Upgrade Selected Unit",
       CurrentValue = false, Flag = "AutoUpgradeSingleToggle",
       Callback = function(Value) AutoUpgradeSingleEnabled = Value end,
    })

    AITab:CreateToggle({
       Name = "Auto Upgrade All Units",
       CurrentValue = false, Flag = "AutoUpgradeAllToggle",
       Callback = function(Value) AutoUpgradeAllEnabled = Value end,
    })

    AITab:CreateButton({
       Name = "Auto Redeem Active Slop TD Codes",
       Callback = function()
          local codes = {"SLOP", "3KCCU", "1MVISITS!", "MINIUPDATE", "AFK", "BUFFED"}
          Rayfield:Notify({ Title = "Code Redeemer", Content = "Redeeming working codes...", Duration = 3 })
          pcall(function()
              local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
              if playerGui then
                  for _, codeStr in ipairs(codes) do
                      for _, textBox in pairs(playerGui:GetDescendants()) do
                          if textBox:IsA("TextBox") and (textBox.Name:lower():find("code") or textBox.PlaceholderText:lower():find("code")) then
                              textBox.Text = codeStr
                              task.wait(0.2)
                              local submitBtn = textBox.Parent:FindFirstChildOfClass("TextButton") or textBox.Parent:FindFirstChild("Redeem")
                              if submitBtn then ForceClickButton(submitBtn) end
                              task.wait(0.5)
                          end
                      end
                  end
              end
          end)
       end,
    })

    -- AI Smart Corridor Placement (Endless Backroom Map)
    AITab:CreateSection("AI Strategy: Endless Backroom Map")
    local KeyCodes = {Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five}

    AITab:CreateToggle({
       Name = "AI Smart Auto Place Units (Backroom)",
       CurrentValue = false, Flag = "AIBackroomToggle",
       Callback = function(Value)
          AIEndlessBackroomEnabled = Value
          Rayfield:Notify({ Title = "AI Backroom", Content = AIEndlessBackroomEnabled and "AI Corridor Placement Active!" or "AI Deactivated.", Duration = 3 })
          
          task.spawn(function()
              local slotIndex = 1
              local offsetStep = 0
              while AIEndlessBackroomEnabled do
                  task.wait(2)
                  pcall(function()
                      local character = LocalPlayer.Character
                      if character and character:FindFirstChild("HumanoidRootPart") then
                          local currentKey = KeyCodes[slotIndex]
                          VirtualUser:Button1Down(Vector2.new(100, 100))
                          task.wait(0.05)
                          VirtualUser:Button1Up(Vector2.new(100, 100))
                          
                          local screenX = Camera.ViewportSize.X / 2 + (math.sin(offsetStep) * 90)
                          local screenY = Camera.ViewportSize.Y / 2 + (math.cos(offsetStep) * 70)
                          
                          VirtualUser:Button1Down(Vector2.new(screenX, screenY))
                          task.wait(0.02)
                          VirtualUser:Button1Up(Vector2.new(screenX, screenY))
                          
                          slotIndex = (slotIndex % 5) + 1
                          offsetStep = offsetStep + 0.4
                      end
                  end)
              end
          end)
       end,
    })

    Rayfield:Notify({
       Title = "Vietnam Hub Loaded",
       Content = "Delta Mobile Optimization Complete!",
       Duration = 4,
       Image = 4483362458,
    })
end

-- KEY VERIFICATION
if CheckSavedKey() then
    Rayfield:Notify({ Title = "Vietnam Hub Verified", Content = "Key Verified! Loading...", Duration = 2 })
    task.wait(0.5)
    LoadMainScript()
else
    local KeyWindow = Rayfield:CreateWindow({
       Name = "Vietnam Hub by Ninh Nguyen | Key Verification",
       LoadingTitle = "Vietnam Hub Key Required",
       LoadingSubtitle = "Join Discord to get key: " .. DiscordLink,
       ConfigurationSaving = { Enabled = false },
       Discord = { Enabled = false },
       KeySystem = false
    })

    local KeyTab = KeyWindow:CreateTab("Key System", 4483362458)
    local EnteredKey = ""

    KeyTab:CreateInput({
       Name = "Enter Access Key",
       PlaceholderText = "Paste key here...",
       RemoveTextOnFocus = false,
       Callback = function(Text) EnteredKey = Text end,
    })

    KeyTab:CreateButton({
       Name = "Submit Key",
       Callback = function()
          local cleanKey = string.gsub(EnteredKey or "", "%s+", "")
          if cleanKey == CorrectKey then
             pcall(function() if writefile then writefile(KeyFileName, CorrectKey) end end)
             Rayfield:Notify({ Title = "Access Granted", Content = "Correct Key! Launching...", Duration = 2 })
             task.spawn(function()
                 task.wait(0.5)
                 pcall(function() KeyWindow:Destroy() end)
                 task.wait(0.5)
                 LoadMainScript()
             end)
          else
             Rayfield:Notify({ Title = "Access Denied", Content = "Incorrect Key! Key is: 3011", Duration = 3 })
          end
       end,
    })

    KeyTab:CreateButton({
       Name = "Get Key (Copy Discord Link)",
       Callback = function()
          pcall(function()
              if setclipboard or toclipboard then
                  (setclipboard or toclipboard)(DiscordLink)
                  Rayfield:Notify({ Title = "Link Copied!", Content = "Discord link copied to clipboard!", Duration = 3 })
              else
                  Rayfield:Notify({ Title = "Copy Failed", Content = "Discord: " .. DiscordLink, Duration = 5 })
              end
          end)
       end,
    })
end
