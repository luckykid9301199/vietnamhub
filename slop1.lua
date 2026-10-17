-- ================================================================================
-- VIETNAM HUB BY NINH NGUYEN - SLOP TD ENTERPRISE SUITE (v8.5 PRO)
-- Mandatory Get-Key • 1-Click Auto Speed (x1-x6, Default x1) • Auto Pact Mode
-- Phase 1 Place ALL Units & Auto Upgrade MAX • Auto-Load on Teleport
-- ================================================================================

-- ==================== SERVICES ====================
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==================== AUTO-STARTUP & CONFIG STORAGE ====================
local StartupConfigFile = "VietnamHub_StartupV85.json"
local KeyVerifyFile = "VietnamHub_KeyVerifiedV85.txt"
local DiscordKeyLink = "https://discord.gg/3JrDAhT9k"
local ValidKey = "3011"

local StartupConfig = {
    ScriptURL = "",
    AutoLoadScript = true,
    AutoRunMode = "Auto Play AI", -- "None" | "Auto Play AI" | "Auto Play Macro"
    SelectedMacroFile = "VietnamHub_Macro.json",
    PlacementZone = "Đầu Map (Front - Mặc định)",
    TargetSpeed = "x1", -- Mặc định là x1 theo yêu cầu
    AutoSpeedOnce = true,
    AutoSelectPact = true,
    PlaceAllPhase1 = true,
    AutoMaxUpgrade = true,
    AutoSkipWave = true,
    AutoReplay = true
}

local function SaveStartupConfig()
    pcall(function()
        if writefile then
            writefile(StartupConfigFile, HttpService:JSONEncode(StartupConfig))
        end
    end)
end

local function LoadStartupConfig()
    pcall(function()
        if isfile and readfile and isfile(StartupConfigFile) then
            local decoded = HttpService:JSONDecode(readfile(StartupConfigFile))
            if type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    StartupConfig[k] = v
                end
            end
        end
    end)
end

LoadStartupConfig()

local function SetupAutoLoadTeleport()
    if queue_on_teleport and StartupConfig.AutoLoadScript then
        pcall(function()
            if StartupConfig.ScriptURL and StartupConfig.ScriptURL ~= "" then
                queue_on_teleport('loadstring(game:HttpGet("' .. StartupConfig.ScriptURL .. '"))()')
            end
        end)
    end
end
SetupAutoLoadTeleport()

-- Anti-AFK hệ thống
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

-- ==================== CORE UI CLICK & PARSER HELPERS ====================
local function IsVisibleOnScreen(guiObj)
    if not guiObj or not guiObj:IsA("GuiObject") then return false end
    if guiObj.AbsoluteSize.X <= 2 or guiObj.AbsoluteSize.Y <= 2 then return false end
    local curr = guiObj
    while curr and curr ~= LocalPlayer.PlayerGui do
        if curr:IsA("GuiObject") and not curr.Visible then return false end
        if curr:IsA("ScreenGui") and not curr.Enabled then return false end
        curr = curr.Parent
    end
    return true
end

local function ResolveClickableButton(obj)
    if not obj then return nil end
    if obj:IsA("TextButton") or obj:IsA("ImageButton") then return obj end
    local parentBtn = obj:FindFirstAncestorWhichIsA("GuiButton")
    if parentBtn then return parentBtn end
    if obj.Parent then
        local siblingBtn = obj.Parent:FindFirstChildWhichIsA("GuiButton")
        if siblingBtn then return siblingBtn end
    end
    local childBtn = obj:FindFirstChildWhichIsA("GuiButton", true)
    if childBtn then return childBtn end
    return obj
end

local function SmartClickGui(targetObj)
    local btn = ResolveClickableButton(targetObj)
    if not btn or not IsVisibleOnScreen(btn) then return false end

    pcall(function()
        if firesignal then
            pcall(function() firesignal(btn.Activated) end)
            pcall(function() firesignal(btn.MouseButton1Click) end)
            pcall(function() firesignal(btn.MouseButton1Down) end)
            pcall(function() firesignal(btn.MouseButton1Up) end)
        end

        if getconnections then
            for _, sig in pairs({btn.Activated, btn.MouseButton1Click, btn.MouseButton1Down, btn.TouchTap}) do
                if sig then
                    for _, conn in pairs(getconnections(sig)) do
                        pcall(function() conn:Fire() end)
                    end
                end
            end
        end

        local inset = GuiService:GetGuiInset()
        local centerX = btn.AbsolutePosition.X + (btn.AbsoluteSize.X / 2) + inset.X
        local centerY = btn.AbsolutePosition.Y + (btn.AbsoluteSize.Y / 2) + inset.Y
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
        task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
    end)
    return true
end

local function TapScreenPosition(screenX, screenY)
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(screenX, screenY, 0, true, game, 1)
        task.wait(0.03)
        VirtualInputManager:SendMouseButtonEvent(screenX, screenY, 0, false, game, 1)
    end)
    pcall(function()
        VirtualUser:Button1Down(Vector2.new(screenX, screenY))
        task.wait(0.03)
        VirtualUser:Button1Up(Vector2.new(screenX, screenY))
    end)
end

local function PressKey(keyCode)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.04)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    end)
end

local function FindAndClickTextButton(keywords, exactMatch)
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return false end
    for _, obj in pairs(playerGui:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and IsVisibleOnScreen(obj) then
            local txt = obj.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
            for _, kw in ipairs(keywords) do
                local kLower = kw:lower()
                local matched = exactMatch and (txt == kLower) or (txt:find(kLower, 1, true) ~= nil)
                if matched then
                    if SmartClickGui(obj) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Đọc số tiền hỗ trợ cả "$1,855" lẫn "345$", "8465$"
local function ParseCurrencyText(raw)
    if not raw or type(raw) ~= "string" then return nil end
    if not raw:find("%$") then return nil end
    local clean = raw:gsub("[%$,%s]", ""):lower()
    local mult = 1
    if clean:find("k") then
        mult = 1000
        clean = clean:gsub("k", "")
    elseif clean:find("m") then
        mult = 1000000
        clean = clean:gsub("m", "")
    end
    local val = tonumber(clean:match("^[0-9%.]+$"))
    if val then
        return val * mult
    end
    return nil
end

local function GetCurrentCash()
    local cash = 0
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end
        local vpY = Camera.ViewportSize.Y

        for _, lbl in pairs(playerGui:GetDescendants()) do
            if lbl:IsA("TextLabel") and IsVisibleOnScreen(lbl) then
                if lbl.AbsolutePosition.Y < (vpY * 0.65) then
                    local raw = lbl.Text
                    if raw:match("^%s*%$[0-9,%.kKmM]+%s*$") or raw:match("^%s*[0-9,%.kKmM]+%$%s*$") then
                        local parsed = ParseCurrencyText(raw)
                        if parsed and parsed >= 0 then
                            cash = parsed
                            return
                        end
                    end
                end
            end
        end
    end)
    return cash
end

local function GetCurrentWaveInfo()
    local currentWave, maxWave = 1, 999
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end
        for _, lbl in pairs(playerGui:GetDescendants()) do
            if lbl:IsA("TextLabel") and IsVisibleOnScreen(lbl) then
                local w, m = lbl.Text:match("[Ww]ave%s*:?%s*(%d+)%s*/%s*(%d+)")
                if w and m then
                    currentWave = tonumber(w) or 1
                    maxWave = tonumber(m) or 25
                    return
                end
                local wInf = lbl.Text:match("[Ww]ave%s*:?%s*(%d+)")
                if wInf then
                    currentWave = tonumber(wInf) or 1
                    return
                end
            end
        end
    end)
    return currentWave, maxWave
end

local function IsPlacingUnitMode()
    local placing = false
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end
        for _, obj in pairs(playerGui:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and IsVisibleOnScreen(obj) then
                if obj.Text:lower():find("cancel") then
                    placing = true
                    break
                end
            end
        end
    end)
    return placing
end


-- ================================================================================
-- MANDATORY "GET KEY" GATE (BẮT BUỘC BẤM GET KEY TRƯỚC KHI NHẬP KEY)
-- ================================================================================
local function RunMandatoryKeyGate(onSuccessCallback)
    if isfile and readfile and isfile(KeyVerifyFile) then
        local saved = readfile(KeyVerifyFile)
        if saved == ValidKey then
            onSuccessCallback()
            return
        end
    end

    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "VietnamHub_KeyGate"
    KeyGui.ResetOnSpawn = false
    KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 380, 0, 230)
    Frame.Position = UDim2.new(0.5, -190, 0.5, -115)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Frame.BorderSizePixel = 0
    Frame.Parent = KeyGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 35)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = "Vietnam Hub | Key Verification"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Frame

    local StatusLbl = Instance.new("TextLabel")
    StatusLbl.Size = UDim2.new(1, -20, 0, 36)
    StatusLbl.Position = UDim2.new(0, 10, 0, 42)
    StatusLbl.BackgroundTransparency = 1
    StatusLbl.Text = "Bước 1: Bắt buộc bấm '1. Get Key' để lấy link.\nBước 2: Nhập Key vào ô bên dưới và bấm Verify."
    StatusLbl.TextColor3 = Color3.fromRGB(255, 200, 80)
    StatusLbl.Font = Enum.Font.Gotham
    StatusLbl.TextSize = 12
    StatusLbl.TextWrapped = true
    StatusLbl.Parent = Frame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 38)
    KeyInput.Position = UDim2.new(0, 20, 0, 88)
    KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.PlaceholderText = "Hãy bấm nút Get Key trước..."
    KeyInput.Text = ""
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 14
    KeyInput.Parent = Frame

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = KeyInput

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0.45, -15, 0, 40)
    GetKeyBtn.Position = UDim2.new(0, 20, 0, 142)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(55, 120, 220)
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.Text = "1. Get Key"
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 14
    GetKeyBtn.Parent = Frame

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 6)
    GetKeyCorner.Parent = GetKeyBtn

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0.55, -15, 0, 40)
    VerifyBtn.Position = UDim2.new(0.45, 5, 0, 142)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 95)
    VerifyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    VerifyBtn.Text = "2. Verify Key (Locked)"
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 14
    VerifyBtn.Parent = Frame

    local VerifyCorner = Instance.new("UICorner")
    VerifyCorner.CornerRadius = UDim.new(0, 6)
    VerifyCorner.Parent = VerifyBtn

    local HasClickedGetKey = false

    GetKeyBtn.MouseButton1Click:Connect(function()
        HasClickedGetKey = true
        pcall(function()
            if setclipboard then
                setclipboard(DiscordKeyLink)
            elseif toclipboard then
                toclipboard(DiscordKeyLink)
            end
        end)
        StatusLbl.Text = "Đã copy link Discord vào bộ nhớ tạm! Hãy nhập Key và bấm Verify."
        StatusLbl.TextColor3 = Color3.fromRGB(100, 255, 140)
        KeyInput.PlaceholderText = "Nhập Key tại đây..."
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 95)
        VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        VerifyBtn.Text = "2. Verify Key"
    end)

    VerifyBtn.MouseButton1Click:Connect(function()
        if not HasClickedGetKey then
            StatusLbl.Text = "CẢNH BÁO: Bạn bắt buộc phải bấm nút '1. Get Key' trước!"
            StatusLbl.TextColor3 = Color3.fromRGB(255, 90, 90)
            return
        end
        local entered = KeyInput.Text:gsub("%s+", "")
        if entered == ValidKey then
            pcall(function()
                if writefile then writefile(KeyVerifyFile, ValidKey) end
            end)
            KeyGui:Destroy()
            onSuccessCallback()
        else
            StatusLbl.Text = "Sai Key! Vui lòng kiểm tra lại Key trong Discord."
            StatusLbl.TextColor3 = Color3.fromRGB(255, 90, 90)
        end
    end)
end


-- ================================================================================
-- MAIN HUB INITIALIZATION
-- ================================================================================
RunMandatoryKeyGate(function()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
       Name = "Vietnam Hub by Ninh Nguyen | Slop TD v8.5",
       LoadingTitle = "Loading Vietnam Hub Engine v8.5...",
       LoadingSubtitle = "Phase 1 Place All & Max Upgrade • 1-Click Speed (x1-x6)",
       ConfigurationSaving = { Enabled = true, FolderName = "VietnamHub_Config" },
       Discord = { Enabled = false },
       KeySystem = false
    })

    -- ============================================================================
    -- MODULE 1: SMART LOADOUT SCANNER, PHASE 1 ALL-UNIT PLACER & MAX UPGRADER
    -- ============================================================================
    local HotbarUnits = {}
    local PlacedScreenPositions = {} -- Lưu các tọa độ đã đặt Unit để click nâng cấp MAX
    local PlacementStepCounter = 0
    local CurrentUnitRotateIdx = 1

    local function ScanPlayerLoadout()
        local foundSlots = {}
        pcall(function()
            local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if not playerGui then return end
            local vp = Camera.ViewportSize

            for _, lbl in pairs(playerGui:GetDescendants()) do
                if lbl:IsA("TextLabel") and IsVisibleOnScreen(lbl) then
                    if lbl.AbsolutePosition.Y > (vp.Y * 0.70) then
                        local raw = lbl.Text:gsub("%s+", "")
                        if raw:match("^%$?[0-9,%.kKmM]+%$?$") and raw:find("%$") then
                            local cost = ParseCurrencyText(raw)
                            local btn = ResolveClickableButton(lbl)
                            if cost and cost > 0 and btn then
                                local duplicate = false
                                for _, item in ipairs(foundSlots) do
                                    if math.abs(item.X - btn.AbsolutePosition.X) < 25 then
                                        duplicate = true
                                        break
                                    end
                                end
                                if not duplicate then
                                    table.insert(foundSlots, {
                                        Cost = cost,
                                        Button = btn,
                                        X = btn.AbsolutePosition.X,
                                        Y = btn.AbsolutePosition.Y
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end)

        -- Gán đúng thứ tự phím 1 -> 6 từ trái sang phải
        table.sort(foundSlots, function(a, b) return a.X < b.X end)
        local keyMap = {
            Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three,
            Enum.KeyCode.Four, Enum.KeyCode.Five, Enum.KeyCode.Six
        }
        for i, slot in ipairs(foundSlots) do
            slot.SlotNumber = i
            slot.KeyCode = keyMap[i] or Enum.KeyCode.One
        end

        -- Sắp xếp theo giá từ rẻ nhất đến đắt nhất
        table.sort(foundSlots, function(a, b) return a.Cost < b.Cost end)
        HotbarUnits = foundSlots
        return HotbarUnits
    end

    local function GetSmartPlacementScreenPos(zoneChoice)
        local vp = Camera.ViewportSize
        local baseCenterX = vp.X * 0.42
        local baseCenterY = vp.Y * 0.38

        pcall(function()
            local pathNodes = {}
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local n = obj.Name:lower()
                    if n:find("spawn") or n:find("start") or n:find("entrance") or n == "1" or n == "node1" or n == "waypoint1" then
                        table.insert(pathNodes, {Type = "Front", Pos = obj.Position})
                    elseif n:find("base") or n:find("exit") or n:find("end") then
                        table.insert(pathNodes, {Type = "Back", Pos = obj.Position})
                    end
                end
            end

            local target3D = nil
            for _, node in ipairs(pathNodes) do
                if zoneChoice:find("Đầu Map") and node.Type == "Front" then
                    target3D = node.Pos
                    break
                elseif zoneChoice:find("Cuối Map") and node.Type == "Back" then
                    target3D = node.Pos
                    break
                end
            end

            if target3D then
                local screenVec, onScreen = Camera:WorldToViewportPoint(target3D)
                if onScreen and screenVec.X > 80 and screenVec.X < (vp.X - 80) and screenVec.Y > 80 and screenVec.Y < (vp.Y * 0.70) then
                    baseCenterX = screenVec.X
                    baseCenterY = screenVec.Y
                end
            else
                if zoneChoice:find("Đầu Map") then
                    baseCenterX = vp.X * 0.42
                    baseCenterY = vp.Y * 0.38
                elseif zoneChoice:find("Giữa Map") then
                    baseCenterX = vp.X * 0.50
                    baseCenterY = vp.Y * 0.48
                elseif zoneChoice:find("Cuối Map") then
                    baseCenterX = vp.X * 0.58
                    baseCenterY = vp.Y * 0.58
                end
            end
        end)

        -- Lưới 20 điểm quanh khu vực đã chọn để đặt được TẤT CẢ các unit không trùng chỗ
        PlacementStepCounter = (PlacementStepCounter % 20) + 1
        local gridOffsets = {
            {0, 0}, {36, 0}, {-36, 0}, {0, 32}, {0, -32},
            {36, 32}, {-36, 32}, {36, -32}, {-36, -32},
            {72, 0}, {-72, 0}, {0, 64}, {0, -64},
            {72, 32}, {-72, 32}, {72, -32}, {-72, -32},
            {108, 0}, {-108, 0}, {0, 96}
        }
        local offset = gridOffsets[PlacementStepCounter] or {0, 0}
        local finalX = math.clamp(baseCenterX + offset[1], 65, vp.X - 65)
        local finalY = math.clamp(baseCenterY + offset[2], 75, vp.Y * 0.66)
        return finalX, finalY
    end

    -- Hàm nâng cấp MAX tất cả các Unit đã đặt trên bản đồ
    local UpgradeInspectIdx = 1
    local function UpgradePlacedUnitsToMax()
        if not StartupConfig.AutoMaxUpgrade then return end

        -- Bước 1: Nếu bảng Upgrade đang mở sẵn trên màn hình, bấm nâng cấp ngay
        FindAndClickTextButton({"upgrade", "level up", "max"}, false)
        PressKey(Enum.KeyCode.E)

        -- Bước 2: Xoay vòng click vào các vị trí đã đặt Unit để mở bảng Upgrade của từng con và nâng MAX
        if #PlacedScreenPositions > 0 then
            UpgradeInspectIdx = (UpgradeInspectIdx % #PlacedScreenPositions) + 1
            local pos = PlacedScreenPositions[UpgradeInspectIdx]
            if pos and not IsPlacingUnitMode() then
                TapScreenPosition(pos.X, pos.Y)
                task.wait(0.18)
                -- Bấm nút Upgrade / phím E liên tục để đẩy lên cấp cao nhất có thể
                for _ = 1, 3 do
                    FindAndClickTextButton({"upgrade", "level up"}, false)
                    PressKey(Enum.KeyCode.E)
                    task.wait(0.08)
                end
            end
        end
    end

    -- ============================================================================
    -- MODULE 2: 1-TIME AUTO SPEED (x1 -> x6, DEFAULT x1) & AUTO PACT MODE
    -- ============================================================================
    local SpeedAlreadySetThisMatch = false
    local PactAlreadySelectedThisMatch = false

    local function ExecuteOneTimeSpeed()
        if not StartupConfig.AutoSpeedOnce or SpeedAlreadySetThisMatch then return end
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end

        -- Kiểm tra xem cửa sổ "Game Speed" đang mở hay chưa
        local speedPopupOpen = false
        for _, obj in pairs(playerGui:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and IsVisibleOnScreen(obj) then
                local txt = obj.Text:lower():gsub("%s+", "")
                if txt:find("gamespeed") then
                    speedPopupOpen = true
                    break
                end
            end
        end

        -- Nếu bảng chưa mở, chỉ mở đúng 1 lần bằng cách bấm nút Tia Sét bên trái
        if not speedPopupOpen then
            for _, btn in pairs(playerGui:GetDescendants()) do
                if (btn:IsA("ImageButton") or btn:IsA("TextButton")) and IsVisibleOnScreen(btn) then
                    if btn.AbsolutePosition.X < 140 and btn.AbsolutePosition.Y > 120 and btn.AbsolutePosition.Y < 340 then
                        local isUnitsBtn = false
                        for _, c in pairs(btn:GetDescendants()) do
                            if c:IsA("TextLabel") and c.Text:lower():find("unit") then
                                isUnitsBtn = true
                            end
                        end
                        if not isUnitsBtn then
                            SmartClickGui(btn)
                            task.wait(0.35)
                            break
                        end
                    end
                end
            end
        end

        -- Bấm đúng 1 lần vào mức tốc độ người chơi đã chọn (mặc định: x1)
        local targetSpd = StartupConfig.TargetSpeed or "x1"
        if FindAndClickTextButton({targetSpd}, true) then
            SpeedAlreadySetThisMatch = true
            task.wait(0.25)
            -- Đóng bảng Game Speed bằng nút "X" màu đỏ để không che màn hình
            FindAndClickTextButton({"x"}, true)
            Rayfield:Notify({
                Title = "Auto Speed (1 Lần)",
                Content = "Đã chọn tốc độ " .. targetSpd .. " (1 lần duy nhất) và đóng bảng!",
                Duration = 3
            })
        end
    end

    local function ExecuteAutoPactMode()
        if not StartupConfig.AutoSelectPact then return end
        local wave, _ = GetCurrentWaveInfo()
        if wave <= 2 and not PactAlreadySelectedThisMatch then
            if FindAndClickTextButton({"pact mode", "pact", "glass base", "slop power", "confirm"}, false) then
                PactAlreadySelectedThisMatch = true
                Rayfield:Notify({
                    Title = "Auto Pact Mode",
                    Content = "Đã tự động chọn Pact Mode!",
                    Duration = 3
                })
            end
        elseif wave > 5 then
            PactAlreadySelectedThisMatch = false
        end
    end


    -- ============================================================================
    -- TAB 1: AUTO PLAY AI, PHASE 1 ALL-UNITS & SPEED (x1-x6)
    -- ============================================================================
    local AITab = Window:CreateTab("1. Auto Play AI & Speed", 4483362458)

    local LoadoutStatusParagraph = AITab:CreateParagraph({
        Title = "Trạng thái Loadout (6 Ô Tướng)",
        Content = "Đang chờ quét 6 ô tướng dưới đáy màn hình..."
    })

    local function UpdateLoadoutParagraph()
        local slots = ScanPlayerLoadout()
        if #slots == 0 then
            LoadoutStatusParagraph:Set({
                Title = "Trạng thái Loadout",
                Content = "Hãy vào trong trận đấu để AI đọc giá tiền của 6 ô tướng."
            })
        else
            local parts = {}
            for _, s in ipairs(slots) do
                table.insert(parts, string.format("Ô %d (%d$)", s.SlotNumber, math.floor(s.Cost)))
            end
            LoadoutStatusParagraph:Set({
                Title = "Loadout Đã Quét (Đặt Tất Cả & Nâng MAX)",
                Content = table.concat(parts, " | ")
            })
        end
    end

    AITab:CreateButton({
       Name = "Quét Lại Loadout Hiện Tại (Scan 6 Slots)",
       Callback = function()
          UpdateLoadoutParagraph()
          Rayfield:Notify({ Title = "Đã Quét Loadout", Content = "Sẵn sàng đặt tất cả Unit có thể đặt!", Duration = 2 })
       end,
    })

    AITab:CreateDropdown({
       Name = "Vị Trí Đặt Unit (Mặc định: Đầu Map)",
       Options = {
           "Đầu Map (Front - Mặc định)",
           "Giữa Map (Mid Map)",
           "Cuối Map (Back / Căn cứ)"
       },
       CurrentOption = StartupConfig.PlacementZone,
       Flag = "PlacementZoneDropdown",
       Callback = function(Option)
          StartupConfig.PlacementZone = type(Option) == "table" and Option[1] or Option
          SaveStartupConfig()
       end,
    })

    local AIAutoPlayRunning = (StartupConfig.AutoRunMode == "Auto Play AI")

    AITab:CreateToggle({
       Name = "Bật Smart AI (Đặt Tất Cả Unit Phase 1 & Nâng Cấp MAX)",
       CurrentValue = AIAutoPlayRunning,
       Flag = "SmartAIAutoPlayToggle",
       Callback = function(Value)
          AIAutoPlayRunning = Value
          if Value then
              UpdateLoadoutParagraph()
              Rayfield:Notify({
                  Title = "AI Auto Play Đã Bật",
                  Content = "Tự động đặt TẤT CẢ Unit đủ tiền và nâng cấp MAX tại: " .. StartupConfig.PlacementZone,
                  Duration = 3
              })
          end
       end,
    })

    AITab:CreateToggle({
       Name = "Auto Nâng Cấp MAX Tất Cả Unit Đã Đặt",
       CurrentValue = StartupConfig.AutoMaxUpgrade,
       Flag = "AutoMaxUpgradeToggle",
       Callback = function(Value)
          StartupConfig.AutoMaxUpgrade = Value
          SaveStartupConfig()
       end,
    })

    AITab:CreateDropdown({
       Name = "Chọn Tốc Độ Auto Speed (x1 -> x6 | Mặc định: x1)",
       Options = {"x1", "x2", "x3", "x4", "x5", "x6"},
       CurrentOption = StartupConfig.TargetSpeed,
       Flag = "TargetSpeedDropdown",
       Callback = function(Option)
          StartupConfig.TargetSpeed = type(Option) == "table" and Option[1] or Option
          SpeedAlreadySetThisMatch = false -- Mở bảng ấn đúng 1 lần khi người chơi đổi mức tốc độ
          SaveStartupConfig()
       end,
    })

    AITab:CreateToggle({
       Name = "Bật Auto Speed (Chỉ mở lên ấn 1 lần duy nhất)",
       CurrentValue = StartupConfig.AutoSpeedOnce,
       Flag = "AutoSpeedOnceToggle",
       Callback = function(Value)
          StartupConfig.AutoSpeedOnce = Value
          if Value then SpeedAlreadySetThisMatch = false end
          SaveStartupConfig()
       end,
    })

    AITab:CreateToggle({
       Name = "Auto Chọn Pact Mode Đầu Trận",
       CurrentValue = StartupConfig.AutoSelectPact,
       Flag = "AutoSelectPactToggle",
       Callback = function(Value)
          StartupConfig.AutoSelectPact = Value
          SaveStartupConfig()
       end,
    })

    AITab:CreateToggle({
       Name = "Auto Skip Wave & Auto Replay Khi Xong Trận",
       CurrentValue = StartupConfig.AutoSkipWave,
       Flag = "AutoSkipAndReplayToggle",
       Callback = function(Value)
          StartupConfig.AutoSkipWave = Value
          StartupConfig.AutoReplay = Value
          SaveStartupConfig()
       end,
    })

    -- Vòng lặp thực thi AI: Đặt TẤT CẢ Unit có thể đặt ở Phase 1 & Nâng cấp MAX
    task.spawn(function()
        while true do
            pcall(function()
                -- 1. Thực thi Auto Pact Mode & Auto Speed (chỉ ấn 1 lần)
                ExecuteAutoPactMode()
                ExecuteOneTimeSpeed()

                -- 2. Tự động Skip Wave & Replay
                if StartupConfig.AutoSkipWave then
                    FindAndClickTextButton({"skip", "vote", "ready"}, false)
                end
                if StartupConfig.AutoReplay then
                    if FindAndClickTextButton({"replay", "play again", "retry"}, false) then
                        SpeedAlreadySetThisMatch = false
                        PactAlreadySelectedThisMatch = false
                        PlacedScreenPositions = {}
                        task.wait(2)
                    end
                end

                -- 3. Đặt TẤT CẢ các Unit có thể đặt trong Loadout & Nâng cấp MAX
                if AIAutoPlayRunning then
                    local units = ScanPlayerLoadout()
                    local cash = GetCurrentCash()

                    if #units > 0 then
                        -- Lọc ra tất cả các ô tướng hiện tại người chơi đủ tiền đặt
                        local affordableSlots = {}
                        for _, u in ipairs(units) do
                            if cash >= u.Cost then
                                table.insert(affordableSlots, u)
                            end
                        end

                        -- Xoay vòng đặt TẤT CẢ các loại unit có thể đặt được (không bỏ sót ô nào)
                        if #affordableSlots > 0 then
                            CurrentUnitRotateIdx = (CurrentUnitRotateIdx % #affordableSlots) + 1
                            local targetUnit = affordableSlots[CurrentUnitRotateIdx]

                            if targetUnit then
                                -- Chọn tướng trên thanh Hotbar
                                SmartClickGui(targetUnit.Button)
                                PressKey(targetUnit.KeyCode)
                                task.wait(0.2)

                                -- Tính tọa độ đặt tại vùng đã chọn (Mặc định: Đầu Map)
                                local placeX, placeY = GetSmartPlacementScreenPos(StartupConfig.PlacementZone)
                                TapScreenPosition(placeX, placeY)
                                task.wait(0.22)

                                -- Nếu đặt thành công (hoặc không còn nút Cancel), lưu vị trí lại để nâng cấp MAX
                                if IsPlacingUnitMode() then
                                    FindAndClickTextButton({"cancel"}, false)
                                else
                                    if #PlacedScreenPositions < 25 then
                                        table.insert(PlacedScreenPositions, {X = placeX, Y = placeY})
                                    end
                                end
                            end
                        end

                        -- Sau mỗi lượt đặt, tiến hành nâng cấp MAX cho tất cả các Unit đã đặt trên sân
                        UpgradePlacedUnitsToMax()
                    end
                end
            end)
            task.wait(1.0)
        end
    end)


    -- ============================================================================
    -- TAB 2: MACRO & REPLAY (DELTA MOBILE RECORDER)
    -- ============================================================================
    local MacroTab = Window:CreateTab("2. Macro & Replay", 4483362458)

    local MacroState = {
        FileName = "VietnamHub_Macro",
        SelectedFile = StartupConfig.SelectedMacroFile,
        Recording = false,
        Playing = (StartupConfig.AutoRunMode == "Auto Play Macro"),
        StartTime = 0,
        Steps = {},
        AutoReplay = true
    }

    local function GetSavedMacroFiles()
        local files = {}
        pcall(function()
            if listfiles then
                for _, f in ipairs(listfiles("")) do
                    if (f:sub(-5) == ".json" or f:sub(-4) == ".txt")
                        and not f:find("KeyVerified") and not f:find("StartupV8") then
                        table.insert(files, f)
                    end
                end
            end
        end)
        if #files == 0 then table.insert(files, "No macros found") end
        return files
    end

    MacroTab:CreateInput({
       Name = "Tên File Macro",
       PlaceholderText = "Nhập tên file macro...",
       RemoveTextOnFocus = false,
       CurrentValue = MacroState.FileName,
       Callback = function(Text)
          if Text and Text ~= "" then
              MacroState.FileName = Text:gsub("%.json$", ""):gsub("%.txt$", "")
          end
       end,
    })

    local initMacroFiles = GetSavedMacroFiles()
    local MacroDropdown = MacroTab:CreateDropdown({
       Name = "Chọn File Macro Để Chạy",
       Options = initMacroFiles,
       CurrentOption = initMacroFiles[1],
       Flag = "MacroFileDropdownV85",
       Callback = function(Option)
          local picked = type(Option) == "table" and Option[1] or Option
          if picked and picked ~= "No macros found" then
              MacroState.SelectedFile = picked
              StartupConfig.SelectedMacroFile = picked
              SaveStartupConfig()
          end
       end,
    })

    local lastRecordTick = 0
    UserInputService.InputBegan:Connect(function(input)
        if not MacroState.Recording then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local now = os.clock()
            if (now - lastRecordTick) < 0.08 then return end
            lastRecordTick = now
            local wave, _ = GetCurrentWaveInfo()
            table.insert(MacroState.Steps, {
                Time = math.floor((now - MacroState.StartTime) * 100) / 100,
                Wave = wave,
                Cash = GetCurrentCash(),
                X = math.floor(input.Position.X),
                Y = math.floor(input.Position.Y)
            })
        end
    end)

    MacroTab:CreateToggle({
       Name = "Ghi Macro (Record Touch / Click)",
       CurrentValue = false,
       Callback = function(Value)
          MacroState.Recording = Value
          if Value then
              MacroState.Steps = {}
              MacroState.StartTime = os.clock()
              Rayfield:Notify({ Title = "Macro Recorder", Content = "Đang ghi thao tác chạm màn hình...", Duration = 3 })
          else
              Rayfield:Notify({ Title = "Macro Recorder", Content = "Đã dừng! Ghi được " .. #MacroState.Steps .. " bước.", Duration = 3 })
          end
       end,
    })

    MacroTab:CreateButton({
       Name = "Lưu Macro Ra File (.json)",
       Callback = function()
          if #MacroState.Steps == 0 then
              Rayfield:Notify({ Title = "Lỗi Lưu Macro", Content = "Chưa có bước nào được ghi!", Duration = 3 })
              return
          end
          pcall(function()
              if writefile then
                  local fName = MacroState.FileName .. ".json"
                  writefile(fName, HttpService:JSONEncode(MacroState.Steps))
                  MacroState.SelectedFile = fName
                  StartupConfig.SelectedMacroFile = fName
                  SaveStartupConfig()
                  MacroDropdown:Refresh(GetSavedMacroFiles(), true)
                  Rayfield:Notify({ Title = "Đã Lưu Macro", Content = "Đã lưu vào file: " .. fName, Duration = 3 })
              end
          end)
       end,
    })

    local function StartMacroPlaybackLoop()
        task.spawn(function()
            while MacroState.Playing do
                local stepsToPlay = MacroState.Steps
                if MacroState.SelectedFile and isfile and readfile and isfile(MacroState.SelectedFile) then
                    pcall(function()
                        stepsToPlay = HttpService:JSONDecode(readfile(MacroState.SelectedFile))
                    end)
                end

                if not stepsToPlay or #stepsToPlay == 0 then
                    Rayfield:Notify({ Title = "Macro Trống", Content = "Hãy chọn hoặc ghi 1 file Macro hợp lệ!", Duration = 3 })
                    MacroState.Playing = false
                    break
                end

                local playStart = os.clock()
                for _, step in ipairs(stepsToPlay) do
                    if not MacroState.Playing then break end
                    while MacroState.Playing and ((os.clock() - playStart) < (step.Time or 0)) do
                        task.wait(0.05)
                    end
                    while MacroState.Playing and step.Cash and GetCurrentCash() < (step.Cash * 0.85) do
                        task.wait(0.2)
                    end
                    if not MacroState.Playing then break end
                    TapScreenPosition(step.X, step.Y)
                    task.wait(0.05)
                end

                if not MacroState.AutoReplay then
                    MacroState.Playing = false
                    break
                end
                task.wait(3)
            end
        end)
    end

    if MacroState.Playing then
        StartMacroPlaybackLoop()
    end

    MacroTab:CreateToggle({
       Name = "Chạy Macro Đã Chọn (Play Macro)",
       CurrentValue = MacroState.Playing,
       Callback = function(Value)
          MacroState.Playing = Value
          if Value then StartMacroPlaybackLoop() end
       end,
    })


    -- ============================================================================
    -- TAB 3: AUTO LOAD SCRIPT & STARTUP MODE
    -- ============================================================================
    local StartupTab = Window:CreateTab("3. Auto Load & Startup", 4483362458)

    StartupTab:CreateInput({
       Name = "Link Raw Script (Dùng cho Auto Load Teleport)",
       PlaceholderText = "https://raw.githubusercontent.com/.../script.lua",
       RemoveTextOnFocus = false,
       CurrentValue = StartupConfig.ScriptURL,
       Callback = function(Text)
          StartupConfig.ScriptURL = Text
          SaveStartupConfig()
          SetupAutoLoadTeleport()
       end,
    })

    StartupTab:CreateToggle({
       Name = "Bật Auto Load Script Khi Teleport",
       CurrentValue = StartupConfig.AutoLoadScript,
       Callback = function(Value)
          StartupConfig.AutoLoadScript = Value
          SaveStartupConfig()
          SetupAutoLoadTeleport()
       end,
    })

    StartupTab:CreateDropdown({
       Name = "Chế Độ Tự Chạy Khi Khởi Động Script",
       Options = {
           "None (Tắt tự chạy)",
           "Auto Play AI",
           "Auto Play Macro"
       },
       CurrentOption = StartupConfig.AutoRunMode,
       Callback = function(Option)
          local picked = type(Option) == "table" and Option[1] or Option
          StartupConfig.AutoRunMode = picked
          SaveStartupConfig()

          if picked == "Auto Play AI" then
              AIAutoPlayRunning = true
              MacroState.Playing = false
          elseif picked == "Auto Play Macro" then
              AIAutoPlayRunning = false
              MacroState.Playing = true
              StartMacroPlaybackLoop()
          else
              AIAutoPlayRunning = false
              MacroState.Playing = false
          end
          Rayfield:Notify({ Title = "Đã Lưu Chế Độ Tự Chạy", Content = "Chế độ: " .. picked, Duration = 3 })
       end,
    })

    StartupTab:CreateButton({
       Name = "Reset Trạng Thái Key (Test lại bắt buộc bấm Get Key)",
       Callback = function()
          pcall(function()
              if delfile and isfile and isfile(KeyVerifyFile) then
                  delfile(KeyVerifyFile)
              end
          end)
          Rayfield:Notify({ Title = "Đã Reset Key", Content = "Lần chạy sau sẽ yêu cầu bấm Get Key lại!", Duration = 3 })
       end,
    })


    -- ============================================================================
    -- TAB 4: SUMMON, CRAFTING & POTATO LAG CONFIG
    -- ============================================================================
    local ExtraTab = Window:CreateTab("4. Summon, Craft & Lag", 4483362458)

    local AutoSummon = false
    ExtraTab:CreateToggle({
       Name = "Auto Summon / Mở Crate",
       CurrentValue = false,
       Callback = function(Value)
          AutoSummon = Value
          task.spawn(function()
              while AutoSummon do
                  FindAndClickTextButton({"10x", "x10", "summon", "open"}, false)
                  task.wait(0.4)
                  FindAndClickTextButton({"skip", "continue", "ok"}, false)
                  task.wait(0.8)
              end
          end)
       end,
    })

    local AutoCraft = false
    ExtraTab:CreateToggle({
       Name = "Auto Craft / Ghép Unit Tại Bàn Crafting",
       CurrentValue = false,
       Callback = function(Value)
          AutoCraft = Value
          task.spawn(function()
              while AutoCraft do
                  FindAndClickTextButton({"craft", "merge", "confirm"}, false)
                  task.wait(2)
              end
          end)
       end,
    })

    ExtraTab:CreateToggle({
       Name = "Bật Ultra Potato Mode (Giảm Lag Giả Lập Cloud)",
       CurrentValue = false,
       Callback = function(Value)
          if Value then
              pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
              Lighting.GlobalShadows = false
              for _, obj in pairs(Workspace:GetDescendants()) do
                  pcall(function()
                      if obj:IsA("BasePart") then
                          obj.Material = Enum.Material.SmoothPlastic
                          obj.CastShadow = false
                      elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                          obj.Enabled = false
                      end
                  end)
              end
          end
       end,
    })
end)
