-- ================================================================================
-- KEY SYSTEM CONFIGURATION & VERIFICATION (VIETNAM HUB BY NINH NGUYEN)
-- ================================================================================
local CorrectKey = "3011"
local DiscordLink = "https://discord.gg/3JrDAhT9k"
local KeyFileName = "SlopTD_SavedKey.txt"

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Auto Queue Teleport (Tự động nạp lại script khi chuyển map/rejoin)
if queue_on_teleport then
    queue_on_teleport([[
        loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    ]])
end

-- Forward declaration cho hàm tải Main Script
local LoadMainScript

-- Kiểm tra Key đã lưu từ trước
local function CheckSavedKey()
    if isfile and readfile and isfile(KeyFileName) then
        local savedKey = readfile(KeyFileName)
        if savedKey == CorrectKey then
            return true
        end
    end
    return false
end

-- Nếu đã lưu Key hợp lệ -> Vào thẳng Main Script
if CheckSavedKey() then
    Rayfield:Notify({ Title = "Vietnam Hub Verified", Content = "Saved key auto-authenticated! Loading Vietnam Hub...", Duration = 3 })
    task.wait(0.5)
    LoadMainScript()
else
    -- Nếu chưa có Key -> Tạo giao diện Key System độc lập
    local KeyWindow = Rayfield:CreateWindow({
       Name = "Vietnam Hub by Ninh Nguyen | Key Verification",
       LoadingTitle = "Vietnam Hub Key Required",
       LoadingSubtitle = "Join Discord to get the access key",
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
       Callback = function(Text)
          EnteredKey = Text
       end,
    })

    KeyTab:CreateButton({
       Name = "Submit Key",
       Callback = function()
          if EnteredKey == CorrectKey then
             if writefile then
                 writefile(KeyFileName, CorrectKey)
             end
             Rayfield:Notify({ Title = "Access Granted", Content = "Correct Key! Launching Vietnam Hub...", Duration = 2 })
             task.wait(1)
             
             -- Destroy Key UI hoàn toàn trước khi khởi tạo Main UI
             KeyWindow:Destroy()
             task.wait(0.5)
             
             LoadMainScript()
          else
             Rayfield:Notify({ Title = "Access Denied", Content = "Incorrect Key! Please check Discord.", Duration = 3 })
          end
       end,
    })

    KeyTab:CreateButton({
       Name = "Get Key (Copy Discord Link)",
       Callback = function()
          if setclipboard or toclipboard then
              local copyFunc = setclipboard or toclipboard
              copyFunc(DiscordLink)
              Rayfield:Notify({ Title = "Link Copied!", Content = "Discord link copied to clipboard. Join to get key!", Duration = 3 })
          else
              Rayfield:Notify({ Title = "Copy Failed", Content = "Discord Link: " .. DiscordLink, Duration = 5 })
          end
       end,
    })
end


-- ================================================================================
-- MAIN SCRIPT EXECUTION ENGINE (VIETNAM HUB BY NINH NGUYEN)
-- ================================================================================
LoadMainScript = function()

local Window = Rayfield:CreateWindow({
   Name = "Vietnam Hub by Ninh Nguyen | Slop TD Enterprise Suite",
   LoadingTitle = "Loading Vietnam Hub Engine...",
   LoadingSubtitle = "Priority Queue • Lifecycle Manager • Gaussian Jitter",
   ConfigurationSaving = { Enabled = true, FolderName = "VietnamHub_Config" },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Services
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==================== LIFECYCLE MANAGER (CHỐNG RÒ RỈ BỘ NHỚ) ====================
local ActiveConnections = {}

local function RegisterConnection(key, connection)
    if ActiveConnections[key] then
        ActiveConnections[key]:Disconnect()
    end
    ActiveConnections[key] = connection
end

local function DisconnectConnection(key)
    if ActiveConnections[key] then
        ActiveConnections[key]:Disconnect()
        ActiveConnections[key] = nil
    end
end

-- ==================== GAUSSIAN JITTER (ĐỘ TRỄ TỰ NHIÊN CHỐNG BOT) ====================
local function HumanLikeDelay()
    task.wait(math.random(50, 150) / 1000)
end

local function SafeClick(x, y)
    HumanLikeDelay()
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.02)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end


-- ================================================================================
-- TAB 1: LAG & AFK CONFIG (GIỮ NGUYÊN 100% LÕI SCRIPT MAIN GỐC)
-- ================================================================================
local MainTab = Window:CreateTab("Lag & AFK Config", 4483362458)

local UltraPotatoEnabled = false
local CurrentColor = Color3.fromRGB(0, 0, 0)
local PotatoEnabled = false

local function DestroyModelVisuals(obj)
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Color = CurrentColor
        obj.CastShadow = false
        for _, child in pairs(obj:GetChildren()) do
            if child:IsA("Decal") or child:IsA("Texture") then
                child:Destroy()
            end
        end
    elseif obj:IsA("MeshPart") or obj:IsA("SpecialMesh") then
        obj.TextureID = ""
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") 
        or obj:IsA("Sparkles") or obj:IsA("Beam") or obj:IsA("Trail") then
        obj.Enabled = false
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
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then
            v:Destroy()
        end
    end

    for _, obj in pairs(Workspace:GetDescendants()) do
        DestroyModelVisuals(obj)
    end
end

local function CleanObject(child)
    if child:IsA("ParticleEmitter") 
        or child:IsA("Smoke") 
        or child:IsA("Fire") 
        or child:IsA("Sparkles") 
        or child:IsA("Beam") 
        or child:IsA("Trail") then
        child.Enabled = false
    elseif child:IsA("Explosion") then
        child.Visible = false
    end
end

local function ClearAllEffects()
    for _, child in pairs(Workspace:GetDescendants()) do
        CleanObject(child)
    end
end

MainTab:CreateToggle({
   Name = "Enable Ultra Potato Mode (Remove Model/Effect)",
   CurrentValue = false, Flag = "UltraPotatoToggle",
   Callback = function(Value)
      UltraPotatoEnabled = Value
      if UltraPotatoEnabled then
         settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
         ApplySuperPotato()
         RegisterConnection("UltraPotato", Workspace.DescendantAdded:Connect(function(child)
             if UltraPotatoEnabled then
                 task.wait()
                 DestroyModelVisuals(child)
             end
         end))
         Rayfield:Notify({ Title = "Ultra Potato Enabled", Content = "Hidden all models & effects!", Duration = 3 })
      else
         DisconnectConnection("UltraPotato")
         Rayfield:Notify({ Title = "Notice", Content = "Ultra Potato Disabled (Rejoin needed)", Duration = 3 })
      end
   end,
})

MainTab:CreateDropdown({
   Name = "AFK Screen Color",
   Options = {"Black Screen", "White Screen"},
   CurrentOption = "Black Screen", Flag = "ColorDropdown",
   Callback = function(Option)
      CurrentColor = (Option == "Black Screen") and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
      if UltraPotatoEnabled then ApplySuperPotato() end
   end,
})

MainTab:CreateSlider({
   Name = "FPS Limit AFK (Reduce CPU)",
   Range = {5, 60}, Increment = 5, Suffix = "FPS", CurrentValue = 15, Flag = "FPSSlider",
   Callback = function(Value)
      if setfpscap then setfpscap(Value) end
   end,
})

MainTab:CreateToggle({
   Name = "Enable Potato Mode (Basic Effect Removal)",
   CurrentValue = false, Flag = "PotatoToggle",
   Callback = function(Value)
      PotatoEnabled = Value
      if PotatoEnabled then
         settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
         ClearAllEffects()
         RegisterConnection("PotatoMode", Workspace.DescendantAdded:Connect(function(child)
             if PotatoEnabled then CleanObject(child) end
         end))
         Rayfield:Notify({ Title = "Success", Content = "Potato Mode ENABLED!", Duration = 3 })
      else
         DisconnectConnection("PotatoMode")
         Rayfield:Notify({ Title = "Notice", Content = "Potato Mode DISABLED!", Duration = 3 })
      end
   end,
})

MainTab:CreateToggle({
   Name = "Disable Shadows & Fog",
   CurrentValue = true, Flag = "ShadowToggle",
   Callback = function(Value)
      Lighting.GlobalShadows = not Value
      if Value then
          Lighting.FogEnd = 9e9
          for _, v in pairs(Lighting:GetChildren()) do
              if v:IsA("PostEffect") or v:IsA("Atmosphere") then v.Enabled = false end
          end
      else
          Lighting.FogEnd = 1000
      end
   end,
})

MainTab:CreateButton({
   Name = "Force Clean Now (Script 1)",
   Callback = function()
      ApplySuperPotato()
      Rayfield:Notify({ Title = "Completed", Content = "Cleaned all extra elements!", Duration = 2 })
   end,
})

MainTab:CreateButton({
   Name = "Manual Clean Effects (Script 2)",
   Callback = function()
      ClearAllEffects()
      Rayfield:Notify({ Title = "Completed", Content = "Cleared all effects on map!", Duration = 2.5 })
   end,
})


-- ================================================================================
-- TAB 2: MACRO & REPLAY (DYNAMIC RESOLUTION & LIFECYCLE MANAGED)
-- ================================================================================
local MacroTab = Window:CreateTab("1. Macro & Replay", 4483362458)

local IsRecording = false
local IsReplaying = false
local MacroData = {}
local RecordStartTime = 0
local AutoInGameReplayEnabled = true

RegisterConnection("MacroInput", UserInputService.InputBegan:Connect(function(input)
    if IsRecording and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local timeOffset = tick() - RecordStartTime
        local viewSize = Camera.ViewportSize
        table.insert(MacroData, { 
            Time = timeOffset, 
            PctX = mousePos.X / viewSize.X, 
            PctY = mousePos.Y / viewSize.Y 
        })
        Rayfield:Notify({ Title = "Macro Recorder", Content = "Recorded action #" .. #MacroData, Duration = 1 })
    end
end))

MacroTab:CreateToggle({
   Name = "Record Macro Actions",
   CurrentValue = false, Flag = "RecordMacroToggle",
   Callback = function(Value)
      IsRecording = Value
      if IsRecording then
         IsReplaying = false
         MacroData = {}
         RecordStartTime = tick()
         Rayfield:Notify({ Title = "Macro", Content = "Started recording clicks...", Duration = 2 })
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
                     SafeClick(step.PctX * currentView.X, step.PctY * currentView.Y)
                 end
                 task.wait(0.8)
             end
         end)
      end
   end,
})

MacroTab:CreateButton({
   Name = "Save Macro to File",
   Callback = function()
      if writefile and #MacroData > 0 then
          writefile("VietnamHub_Macro.json", HttpService:JSONEncode(MacroData))
          Rayfield:Notify({ Title = "Macro Saved", Content = "Saved to VietnamHub_Macro.json", Duration = 2 })
      end
   end,
})

MacroTab:CreateButton({
   Name = "Load Macro from File",
   Callback = function()
      if readfile and isfile and isfile("VietnamHub_Macro.json") then
          MacroData = HttpService:JSONDecode(readfile("VietnamHub_Macro.json"))
          Rayfield:Notify({ Title = "Macro Loaded", Content = "Loaded " .. #MacroData .. " steps successfully!", Duration = 2 })
      end
   end,
})

MacroTab:CreateToggle({
   Name = "Auto In-Game Replay (Never Return Lobby)",
   CurrentValue = true, Flag = "AutoInGameReplayToggle",
   Callback = function(Value)
      AutoInGameReplayEnabled = Value
      task.spawn(function()
          while AutoInGameReplayEnabled do
              task.wait(1.5)
              local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
              if playerGui then
                  for _, btn in pairs(playerGui:GetDescendants()) do
                      if btn:IsA("TextButton") and btn.Visible then
                          local txt = btn.Text:lower()
                          if (txt:find("replay") or txt:find("play again") or txt:find("next map") or txt:find("retry")) and not txt:find("lobby") then
                              local pos = btn.AbsolutePosition + (btn.AbsoluteSize / 2)
                              SafeClick(pos.X, pos.Y)
                              Rayfield:Notify({ Title = "Auto Replay", Content = "In-game match restarted!", Duration = 3 })
                              task.wait(4)
                              break
                          end
                      end
                  end
              end
          end
      end)
   end,
})


-- ================================================================================
-- TAB 3: AI HỖ TRỢ PLAY (PRIORITY EVENT QUEUE & AUTO SPEED x1-x6)
-- ================================================================================
local AITab = Window:CreateTab("2. AI Hỗ Trợ Play", 4483362458)

local AntiImHereEnabled = true
local AutoSpeedEnabled = true
local SelectedMaxSpeed = "Max Possible" -- Mặc định chọn tốc độ nhiều nhất có thể
local AutoSkipWavesEnabled = true
local AutoUpgradeSingleEnabled = false
local AutoUpgradeAllEnabled = false
local AutoPactsEnabled = true
local AIEndlessBackroomEnabled = false

local function ClickGuiButton(btn)
    if not btn then return end
    pcall(function()
        if firesignal then
            firesignal(btn.MouseButton1Click)
            firesignal(btn.Activated)
        else
            local pos = btn.AbsolutePosition + (btn.AbsoluteSize / 2)
            SafeClick(pos.X, pos.Y)
        end
    end)
end

-- 1. Anti "I'm Here" (Priority 1)
AITab:CreateToggle({
   Name = "Auto Click 'I'm Here' (Anti-Macro Detection)",
   CurrentValue = true, Flag = "AntiImHereToggle",
   Callback = function(Value)
      AntiImHereEnabled = Value
      if AntiImHereEnabled then
         local playerGui = LocalPlayer:WaitForChild("PlayerGui")
         RegisterConnection("AntiImHere", playerGui.DescendantAdded:Connect(function(desc)
             if not AntiImHereEnabled then return end
             task.defer(function()
                 if desc:IsA("TextButton") or desc:IsA("ImageButton") or desc:IsA("TextLabel") then
                     local txt = desc:IsA("TextLabel") and desc.Text:lower() or (desc:IsA("TextButton") and desc.Text:lower() or "")
                     if txt:find("i'm here") or txt:find("im here") or txt:find("here") then
                         local btn = desc:IsA("TextButton") and desc or desc:FindFirstAncestorOfClass("TextButton") or desc.Parent
                         ClickGuiButton(btn)
                         Rayfield:Notify({ Title = "Priority 1: Anti AFK", Content = "Bypassed 'I'm Here' instantly!", Duration = 2.5 })
                     end
                 end
             end)
         end))
      else
         DisconnectConnection("AntiImHere")
      end
   end,
})

-- 2. PRIORITY EVENT QUEUE
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if not playerGui then return end

            -- [PRIORITY 2]: Xử lý Pact
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
                            if not desc:find("-%d+%% rewards") and not desc:find("rewards penalty") then
                                local btn = card:FindFirstChildOfClass("TextButton") or card:FindFirstChild("PACT")
                                if btn then safePactBtn = btn break end
                            end
                        end
                        if safePactBtn then
                            ClickGuiButton(safePactBtn)
                            task.wait(1)
                        else
                            local refuse = container:FindFirstChild("Refuse") or container:FindFirstChild("Later")
                            if refuse then ClickGuiButton(refuse) task.wait(1) end
                        end
                    end
                end
            end

            -- [PRIORITY 3]: Skip Waves
            if AutoSkipWavesEnabled then
                for _, btn in pairs(playerGui:GetDescendants()) do
                    if btn:IsA("TextButton") and btn.Visible and (btn.Text:lower():find("skip") or btn.Name:lower():find("skip")) then
                        ClickGuiButton(btn)
                        break
                    end
                end
            end
        end)
    end
end)

-- 3. Auto Game Speed (Chọn x1 - x6 & Max Possible)
AITab:CreateSection("Speed Control (x1 - x6)")

AITab:CreateToggle({
   Name = "Auto Game Speed Toggle",
   CurrentValue = true, Flag = "AutoSpeedToggle",
   Callback = function(Value)
      AutoSpeedEnabled = Value
      task.spawn(function()
          while AutoSpeedEnabled do
              task.wait(2)
              pcall(function()
                  local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                  if playerGui then
                      local targetSpeeds = {}
                      if SelectedMaxSpeed == "Max Possible" then
                          targetSpeeds = {"x6", "x5", "x4", "x3", "x2", "x1"}
                      else
                          local num = tonumber(SelectedMaxSpeed:match("%d+"))
                          if num then
                              for i = num, 1, -1 do
                                  table.insert(targetSpeeds, "x" .. i)
                              end
                          end
                      end

                      -- Quét và click nút đổi speed trong UI
                      local speedClicked = false
                      for _, spd in ipairs(targetSpeeds) do
                          for _, btn in pairs(playerGui:GetDescendants()) do
                              if (btn:IsA("TextButton") or btn:IsA("ImageButton") or btn:IsA("TextLabel")) and btn.Visible then
                                  local txt = btn:IsA("TextLabel") and btn.Text or (btn:IsA("TextButton") and btn.Text or "")
                                  if txt:lower():find(spd) and not txt:lower():find("vip") then
                                      local targetBtn = btn:IsA("TextButton") and btn or btn.Parent
                                      ClickGuiButton(targetBtn)
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
      Rayfield:Notify({ Title = "Speed Selected", Content = "Target Speed set to: " .. Option, Duration = 2.5 })
   end,
})

-- 4. Auto Upgrade Units
AITab:CreateSection("Automation Unit Upgrades")

AITab:CreateToggle({
   Name = "Auto Upgrade Selected Unit (Single)",
   CurrentValue = false, Flag = "AutoUpgradeSingleToggle",
   Callback = function(Value)
      AutoUpgradeSingleEnabled = Value
      task.spawn(function()
          while AutoUpgradeSingleEnabled do
              task.wait(0.4)
              local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
              if playerGui then
                  for _, btn in pairs(playerGui:GetDescendants()) do
                      if btn:IsA("TextButton") and btn.Visible and btn.Text:find("Upgrade") and not btn.Text:find("All") then
                          ClickGuiButton(btn)
                      end
                  end
              end
          end
      end)
   end,
})

AITab:CreateToggle({
   Name = "Auto Upgrade All Units (Units Menu)",
   CurrentValue = false, Flag = "AutoUpgradeAllToggle",
   Callback = function(Value)
      AutoUpgradeAllEnabled = Value
      task.spawn(function()
          while AutoUpgradeAllEnabled do
              task.wait(1.5)
              local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
              if playerGui then
                  for _, btn in pairs(playerGui:GetDescendants()) do
                      if btn:IsA("TextButton") and btn.Text:find("Units") then
                          ClickGuiButton(btn)
                          task.wait(0.3)
                          break
                      end
                  end
                  for _, btn in pairs(playerGui:GetDescendants()) do
                      if btn:IsA("TextButton") and btn.Visible and btn.Text:find("Upgrade All") then
                          ClickGuiButton(btn)
                      end
                  end
              end
          end
      end)
   end,
})

-- 5. Auto Redeem Codes
AITab:CreateButton({
   Name = "Auto Redeem Active Slop TD Codes",
   Callback = function()
      local codes = {"SLOP", "3KCCU", "1MVISITS!", "MINIUPDATE", "AFK", "BUFFED"}
      Rayfield:Notify({ Title = "Code Redeemer", Content = "Redeeming working Slop TD codes...", Duration = 3 })
      local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
      if playerGui then
          for _, codeStr in ipairs(codes) do
              for _, textBox in pairs(playerGui:GetDescendants()) do
                  if textBox:IsA("TextBox") and (textBox.Name:lower():find("code") or textBox.PlaceholderText:lower():find("code")) then
                      textBox.Text = codeStr
                      task.wait(0.2)
                      local submitBtn = textBox.Parent:FindFirstChildOfClass("TextButton") or textBox.Parent:FindFirstChild("Redeem")
                      if submitBtn then ClickGuiButton(submitBtn) end
                      task.wait(0.5)
                  end
              end
          end
      end
   end,
})

-- 6. AI Smart Corridor Placement (Endless Backroom Map)
AITab:CreateSection("AI Strategy: Endless Backroom Map")

local KeyCodes = {Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five}

AITab:CreateToggle({
   Name = "AI Smart Auto Place Units (Backroom Corridor)",
   CurrentValue = false, Flag = "AIBackroomToggle",
   Callback = function(Value)
      AIEndlessBackroomEnabled = Value
      Rayfield:Notify({ Title = "AI Backroom", Content = AIEndlessBackroomEnabled and "AI Corridor Placement Activated!" or "AI Deactivated.", Duration = 3 })
      
      task.spawn(function()
          local slotIndex = 1
          local offsetStep = 0
          
          while AIEndlessBackroomEnabled do
              task.wait(2)
              pcall(function()
                  local character = LocalPlayer.Character
                  if character and character:FindFirstChild("HumanoidRootPart") then
                      local currentKey = KeyCodes[slotIndex]
                      VirtualInputManager:SendKeyEvent(true, currentKey, false, game)
                      task.wait(0.05)
                      VirtualInputManager:SendKeyEvent(false, currentKey, false, game)
                      
                      local screenX = Camera.ViewportSize.X / 2 + (math.sin(offsetStep) * 90)
                      local screenY = Camera.ViewportSize.Y / 2 + (math.cos(offsetStep) * 70)
                      
                      SafeClick(screenX, screenY)
                      
                      slotIndex = (slotIndex % 5) + 1
                      offsetStep = offsetStep + 0.4
                  end
              end)
          end
      end)
   end,
})


-- ================================================================================
-- TAB 4: SETTINGS & DISCORD WEBHOOK (LIFECYCLE MANAGED)
-- ================================================================================
local SettingTab = Window:CreateTab("Settings & Webhook", 4483362458)

local DiscordWebhookURL = ""
local WebhookNotifierEnabled = true
local LastSentTime = 0

SettingTab:CreateInput({
   Name = "Discord Webhook URL",
   PlaceholderText = "Paste Webhook URL Here...",
   RemoveTextOnFocus = false, Flag = "WebhookInput",
   Callback = function(Text)
      DiscordWebhookURL = Text
   end,
})

local function SendMatchSummaryWebhook(cash, gems, xp, chests, status)
    if DiscordWebhookURL == "" or not (request or http_request) then return end
    local req = request or http_request
    
    local isVictory = status == "Victory"
    local embed = {
        ["title"] = isVictory and "🏆 Slop TD - Match Victory!" or "💀 Slop TD - Match Defeat!",
        ["color"] = isVictory and 65280 or 16711680,
        ["fields"] = {
            { ["name"] = "💵 Cash", ["value"] = cash, ["inline"] = true },
            { ["name"] = "💎 Gems", ["value"] = gems, ["inline"] = true },
            { ["name"] = "⭐ XP", ["value"] = xp, ["inline"] = true },
            { ["name"] = "📦 Chests", ["value"] = chests, ["inline"] = true },
            { ["name"] = "👤 Player", ["value"] = LocalPlayer.Name, ["inline"] = false }
        },
        ["footer"] = { ["text"] = "Vietnam Hub by Ninh Nguyen" },
        ["timestamp"] = DateTime.now():ToIsoDate()
    }
    
    req({
        Url = DiscordWebhookURL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({ embeds = { embed } })
    })
end

SettingTab:CreateToggle({
   Name = "Enable Match Rewards Webhook Notifier",
   CurrentValue = true, Flag = "WebhookToggle",
   Callback = function(Value)
      WebhookNotifierEnabled = Value
      if WebhookNotifierEnabled then
         local playerGui = LocalPlayer:WaitForChild("PlayerGui")
         RegisterConnection("WebhookNotifier", playerGui.DescendantAdded:Connect(function(desc)
             if not WebhookNotifierEnabled then return end
             
             if desc:IsA("TextLabel") and (desc.Text:find("Defeat") or desc.Text:find("Victory")) then
                 if tick() - LastSentTime < 15 then return end
                 
                 task.wait(1.5)
                 
                 local cash = "x0"
                 local gems = "x0"
                 local xp = "x0"
                 local chests = "x0"
                 local status = desc.Text:find("Defeat") and "Defeat" or "Victory"
                 
                 for _, label in pairs(playerGui:GetDescendants()) do
                     if label:IsA("TextLabel") and label.Visible then
                         local txt = label.Text
                         if txt:find("x") then
                             if txt:find("k") or txt:find("%$") then
                                 cash = txt
                             elseif tonumber(txt:match("%d+")) and not txt:find("XP") then
                                 if gems == "x0" then gems = txt else chests = txt end
                             elseif txt:find("XP") or label.Parent.Name:find("XP") then
                                 xp = txt
                             end
                         end
                     end
                 end
                 
                 SendMatchSummaryWebhook(cash, gems, xp, chests, status)
                 LastSentTime = tick()
             end
         end))
      else
         DisconnectConnection("WebhookNotifier")
      end
   end,
})

SettingTab:CreateButton({
   Name = "Test Discord Webhook Payload",
   Callback = function()
      if DiscordWebhookURL ~= "" then
          SendMatchSummaryWebhook("x5.38k", "x128", "x34", "x2", "Victory")
          Rayfield:Notify({ Title = "Webhook Test", Content = "Test payload sent to Discord successfully!", Duration = 3 })
      else
          Rayfield:Notify({ Title = "Error", Content = "Webhook URL is empty!", Duration = 3 })
      end
   end,
})

-- Loaded Notification
Rayfield:Notify({
   Title = "Vietnam Hub Loaded",
   Content = "Vietnam Hub by Ninh Nguyen Active!",
   Duration = 4,
   Image = 4483362458,
})

end
