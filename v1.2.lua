-- ========================================================
-- VIETNAM HUB (VER 1.2) - BY NINH NGUYEN
-- KEY SYSTEM & OP FEATURES WITH AIMBOT, ESP, MOVEMENT & AUTOFARM
-- ========================================================

-- PREVENT DUPLICATE LOADING
if game.CoreGui:FindFirstChild("VietnamHubKeyGui") or game.CoreGui:FindFirstChild("VietnamHub") then
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Vietnam Hub by Ninh Nguyen",
		Text = "GUI or Key System is already open!",
		Duration = 5
	})
	return
end

-- VALID KEYS LIST
local ValidKeys = {
	["VIETNAM-HUB-2026"] = true,
	["VIETNAM-HUB-OP"] = true,
	["FREE-KEY"] = true
}

-- DISCORD LINK FOR KEYS
local DiscordLink = "https://discord.gg/3JrDAhT9k"

-- SERVICES & VARIABLES
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local Camera = workspace.CurrentCamera

-- ========================================================
-- KEY SYSTEM UI (BY NINH NGUYEN)
-- ========================================================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "VietnamHubKeyGui"
KeyGui.Parent = game.CoreGui
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = KeyGui
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyFrame.Size = UDim2.new(0, 380, 0, 230)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 8)
KeyCorner.Parent = KeyFrame

local KeyTitleBar = Instance.new("Frame")
KeyTitleBar.Parent = KeyFrame
KeyTitleBar.Size = UDim2.new(1, 0, 0, 35)
KeyTitleBar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

local KeyTitleCorner = Instance.new("UICorner")
KeyTitleCorner.CornerRadius = UDim.new(0, 8)
KeyTitleCorner.Parent = KeyTitleBar

local KeyTitleLabel = Instance.new("TextLabel")
KeyTitleLabel.Parent = KeyTitleBar
KeyTitleLabel.Size = UDim2.new(1, 0, 1, 0)
KeyTitleLabel.BackgroundTransparency = 1
KeyTitleLabel.Font = Enum.Font.SourceSansBold
KeyTitleLabel.Text = "★ VIETNAM HUB ★ | by Ninh Nguyen"
KeyTitleLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
KeyTitleLabel.TextSize = 15

local KeyInput = Instance.new("TextBox")
KeyInput.Parent = KeyFrame
KeyInput.Position = UDim2.new(0.08, 0, 0.28, 0)
KeyInput.Size = UDim2.new(0.84, 0, 0, 38)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInput.BorderSizePixel = 0
KeyInput.Font = Enum.Font.SourceSans
KeyInput.PlaceholderText = "Enter Key here..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 4)
KeyInputCorner.Parent = KeyInput

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Parent = KeyFrame
SubmitBtn.Position = UDim2.new(0.08, 0, 0.52, 0)
SubmitBtn.Size = UDim2.new(0.4, 0, 0, 35)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
SubmitBtn.BorderSizePixel = 0
SubmitBtn.Font = Enum.Font.SourceSansBold
SubmitBtn.Text = "Submit Key"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 14

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 4)
SubmitCorner.Parent = SubmitBtn

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Parent = KeyFrame
GetKeyBtn.Position = UDim2.new(0.52, 0, 0.52, 0)
GetKeyBtn.Size = UDim2.new(0.4, 0, 0, 35)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.Font = Enum.Font.SourceSansBold
GetKeyBtn.Text = "Get Key (Discord)"
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.TextSize = 14

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 4)
GetKeyCorner.Parent = GetKeyBtn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = KeyFrame
StatusLabel.Position = UDim2.new(0, 0, 0.78, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Click 'Get Key' to copy Discord link and get your Key!"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 13

-- GET KEY BUTTON ACTION
GetKeyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(DiscordLink)
		StatusLabel.Text = "Discord link copied! Paste it in your browser."
		StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Vietnam Hub by Ninh Nguyen",
			Text = "Discord link copied to clipboard!",
			Duration = 4
		})
	else
		StatusLabel.Text = "Your executor does not support setclipboard!"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
	end
end)

-- ========================================================
-- MAIN HUB LOADER
-- ========================================================
local function LoadMainHub()
	KeyGui:Destroy()

	-- ORIGINAL OP HELPER FUNCTIONS
	local function GetCharacter(Player) return Player and Player.Character end
	local function GetRoot(Player)
		local char = GetCharacter(Player)
		return char and char:FindFirstChild("HumanoidRootPart")
	end

	local function GetPush()
		local TempPush = nil
		pcall(function()
			if plr.Backpack:FindFirstChild("Push") then
				local PushTool = plr.Backpack.Push
				PushTool.Parent = plr.Character
				TempPush = PushTool
			end
			for i, v in pairs(Players:GetPlayers()) do
				if v.Character and v.Character:FindFirstChild("Push") then
					TempPush = v.Character.Push
				end
			end
		end)
		return TempPush
	end

	local function ToggleRagdoll(bool)
		pcall(function()
			plr.Character["Falling down"].Disabled = bool
			plr.Character["Swimming"].Disabled = bool
			plr.Character["StartRagdoll"].Disabled = bool
			plr.Character["Pushed"].Disabled = bool
			plr.Character["RagdollMe"].Disabled = bool
		end)
	end

	local function ToggleVoidProtection(bool)
		game.Workspace.FallenPartsDestroyHeight = bool and 0/0 or -500
	end

	local function PlayAnim(id, time, speed)
		pcall(function()
			plr.Character.Animate.Disabled = false
			local hum = plr.Character.Humanoid
			for i, track in pairs(hum:GetPlayingAnimationTracks()) do track:Stop() end
			plr.Character.Animate.Disabled = true
			local Anim = Instance.new("Animation")
			Anim.AnimationId = "rbxassetid://" .. id
			local loadanim = hum:LoadAnimation(Anim)
			loadanim:Play()
			loadanim.TimePosition = time
			loadanim:AdjustSpeed(speed)
		end)
	end

	-- AIMBOT, ESP, MOVEMENT & AUTOFARM LOGIC
	local AimbotEnabled = false
	local AimbotPart = "Head"
	local SmoothAimbot = false
	local Smoothness = 0.5
	local FOVCircleEnabled = false
	local FOVRadius = 150
	local WallCheck = false
	local TeamCheck = false

	local ESPEnabled = false
	local ESPBoxes = true
	local ESPNames = true
	local TracersEnabled = false

	local TriggerbotEnabled = false
	local TriggerbotDelay = 0.05
	local TriggerbotLastShot = 0

	local FlightEnabled = false
	local FlightSpeed = 50
	local SpeedEnabled = false
	local SpeedValue = 30
	local NoclipEnabled = false

	local FlightConnection, NoclipConnection = nil, nil
	local FlightAttachment, FlightVelocity = nil, nil
	local NoclipOriginal = {}

	local AutoFarmEnabled = false
	local SelectedStage = 1
	local StageDelay = 1
	local AutoFarmRunning = false

	-- DRAWING LIBRARY & FOV
	local DrawingLib, DrawingAvailable = nil, false
	pcall(function()
		if Drawing then
			DrawingLib = Drawing
			DrawingAvailable = true
		end
	end)

	local FOVCircle = nil
	if DrawingAvailable then
		pcall(function()
			FOVCircle = DrawingLib.new("Circle")
			FOVCircle.Visible = false
			FOVCircle.Filled = false
			FOVCircle.Thickness = 2
			FOVCircle.Color = Color3.fromRGB(255, 255, 255)
			FOVCircle.Radius = FOVRadius
		end)
	end

	local function UpdateFOVCircle()
		if not FOVCircle then return end
		local viewport = Camera.ViewportSize
		FOVCircle.Visible = FOVCircleEnabled
		FOVCircle.Radius = FOVRadius
		FOVCircle.Position = Vector2.new(viewport.X / 2, viewport.Y / 2)
	end

	local ESPCache, TracerCache = {}, {}
	local function RemoveDrawing(object)
		if not object then return end
		pcall(function() object:Remove() end)
		pcall(function() object:Destroy() end)
	end

	local function ClearESP()
		for _, object in ipairs(ESPCache) do RemoveDrawing(object) end
		table.clear(ESPCache)
	end

	local function ClearTracers()
		for _, object in ipairs(TracerCache) do RemoveDrawing(object) end
		table.clear(TracerCache)
	end

	local function IsEnemy(player)
		if not player or player == plr then return false end
		if not TeamCheck then return true end
		return player.Team ~= plr.Team
	end

	local function IsVisible(part)
		if not WallCheck then return true end
		if not part or not plr.Character then return false end
		local origin = Camera.CFrame.Position
		local direction = part.Position - origin
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {plr.Character}
		params.IgnoreWater = true
		local result = workspace:Raycast(origin, direction, params)
		if not result then return true end
		return result.Instance:IsDescendantOf(part.Parent)
	end

	local function GetNearestTarget()
		local viewport = Camera.ViewportSize
		local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
		local closest, closestDistance = nil, FOVRadius

		for _, player in ipairs(Players:GetPlayers()) do
			if IsEnemy(player) and player.Character then
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health > 0 then
					local part = player.Character:FindFirstChild(AimbotPart) or player.Character:FindFirstChild("HumanoidRootPart")
					if part then
						local screen, visible = Camera:WorldToViewportPoint(part.Position)
						if visible then
							local distance = (Vector2.new(screen.X, screen.Y) - center).Magnitude
							if distance <= FOVRadius and distance < closestDistance and IsVisible(part) then
								closest = part
								closestDistance = distance
							end
						end
					end
				end
			end
		end
		return closest
	end

	local function AimbotLoop()
		if not AimbotEnabled then return end
		local target = GetNearestTarget()
		if not target then return end
		local current = Camera.CFrame
		local desired = CFrame.lookAt(current.Position, target.Position)
		if SmoothAimbot then
			Camera.CFrame = current:Lerp(desired, math.clamp(Smoothness, 0, 1))
		else
			Camera.CFrame = desired
		end
	end

	local function GetCrosshairTarget()
		local viewport = Camera.ViewportSize
		local ray = Camera:ViewportPointToRay(viewport.X / 2, viewport.Y / 2)
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {plr.Character}
		params.IgnoreWater = true
		local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
		if not result then return nil end
		local model = result.Instance:FindFirstAncestorOfClass("Model")
		if not model then return nil end
		local player = Players:GetPlayerFromCharacter(model)
		if not player or not IsEnemy(player) then return nil end
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 or not IsVisible(result.Instance) then return nil end
		return player
	end

	local function TriggerbotLoop()
		if not TriggerbotEnabled then return end
		local now = os.clock()
		if now - TriggerbotLastShot < TriggerbotDelay then return end
		local target = GetCrosshairTarget()
		if not target or not plr.Character then return end
		local tool = plr.Character:FindFirstChildOfClass("Tool")
		if not tool then return end
		pcall(function() tool:Activate() end)
		TriggerbotLastShot = now
	end

	local function UpdateESP()
		if not DrawingAvailable then return end
		ClearESP()
		if not ESPEnabled then return end

		for _, player in ipairs(Players:GetPlayers()) do
			if IsEnemy(player) and player.Character then
				local character = player.Character
				local root = character:FindFirstChild("HumanoidRootPart")
				local head = character:FindFirstChild("Head")
				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if root and head and humanoid and humanoid.Health > 0 then
					local rootScreen, rootVisible = Camera:WorldToViewportPoint(root.Position)
					local headScreen, headVisible = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))

					if rootVisible and headVisible then
						local height = math.abs(rootScreen.Y - headScreen.Y) * 1.5
						local width = height / 2

						if ESPBoxes then
							local box = DrawingLib.new("Square")
							box.Visible = true
							box.Filled = false
							box.Thickness = 1
							box.Color = Color3.fromRGB(255, 0, 0)
							box.Size = Vector2.new(width, height)
							box.Position = Vector2.new(headScreen.X - width / 2, headScreen.Y)
							table.insert(ESPCache, box)
						end

						if ESPNames then
							local text = DrawingLib.new("Text")
							text.Visible = true
							text.Text = player.Name
							text.Size = 13
							text.Center = true
							text.Outline = true
							text.Color = Color3.fromRGB(255, 255, 255)
							text.Position = Vector2.new(headScreen.X, headScreen.Y - 15)
							table.insert(ESPCache, text)
						end
					end
				end
			end
		end
	end

	local function UpdateTracers()
		if not DrawingAvailable then return end
		ClearTracers()
		if not TracersEnabled or not plr.Character then return end
		local root = plr.Character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local localScreen, localVisible = Camera:WorldToViewportPoint(root.Position)
		if not localVisible then return end

		for _, player in ipairs(Players:GetPlayers()) do
			if IsEnemy(player) and player.Character then
				local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

				if targetRoot and humanoid and humanoid.Health > 0 then
					local targetScreen, visible = Camera:WorldToViewportPoint(targetRoot.Position)
					if visible then
						local line = DrawingLib.new("Line")
						line.Visible = true
						line.Thickness = 1
						line.Color = Color3.fromRGB(255, 255, 255)
						line.From = Vector2.new(localScreen.X, localScreen.Y)
						line.To = Vector2.new(targetScreen.X, targetScreen.Y)
						table.insert(TracerCache, line)
					end
				end
			end
		end
	end

	local function StopFlight()
		if FlightConnection then FlightConnection:Disconnect() FlightConnection = nil end
		if FlightVelocity then FlightVelocity:Destroy() FlightVelocity = nil end
		if FlightAttachment then FlightAttachment:Destroy() FlightAttachment = nil end
		if plr.Character then
			local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then humanoid.AutoRotate = true end
		end
	end

	local function StartFlight()
		StopFlight()
		if not plr.Character then return end
		local root = plr.Character:FindFirstChild("HumanoidRootPart")
		local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid then return end

		humanoid.AutoRotate = false
		FlightAttachment = Instance.new("Attachment")
		FlightAttachment.Parent = root
		FlightVelocity = Instance.new("LinearVelocity")
		FlightVelocity.Attachment0 = FlightAttachment
		FlightVelocity.MaxForce = math.huge
		FlightVelocity.VectorVelocity = Vector3.zero
		FlightVelocity.Parent = root

		FlightConnection = RunService.RenderStepped:Connect(function()
			if not FlightEnabled or not plr.Character then return end
			local currentRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local currentHumanoid = plr.Character:FindFirstChildOfClass("Humanoid")
			if not currentRoot or not currentHumanoid then return end

			local direction = currentHumanoid.MoveDirection
			direction = direction.Magnitude > 0 and direction.Unit * FlightSpeed or Vector3.zero

			local vertical = 0
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vertical = 1
			elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vertical = -1 end

			direction += Vector3.new(0, vertical * FlightSpeed, 0)
			if FlightVelocity then FlightVelocity.VectorVelocity = direction end
			currentRoot.AssemblyAngularVelocity = Vector3.zero
		end)
	end

	local function UpdateSpeed()
		if not plr.Character then return end
		local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = SpeedEnabled and SpeedValue or 16
		end
	end

	local function RestoreNoclip()
		for part, original in pairs(NoclipOriginal) do
			if part and part.Parent then part.CanCollide = original end
		end
		table.clear(NoclipOriginal)
	end

	local function StopNoclip()
		if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
		RestoreNoclip()
	end

	local function StartNoclip()
		StopNoclip()
		NoclipConnection = RunService.Stepped:Connect(function()
			if not NoclipEnabled or not plr.Character then return end
			for _, object in ipairs(plr.Character:GetDescendants()) do
				if object:IsA("BasePart") then
					if NoclipOriginal[object] == nil then NoclipOriginal[object] = object.CanCollide end
					object.CanCollide = false
				end
			end
		end)
	end

	-- AUTOFARM LOGIC
	local function ExtractStageNumber(name)
		if not name then return nil end
		local lower = string.lower(name)
		local number = string.match(lower, "stage%s*(%d+)") or string.match(lower, "room%s*(%d+)")
		return number and tonumber(number) or nil
	end

	local function FindStage(stageNumber)
		local exactNames = {
			"Stage " .. stageNumber, "Stage" .. stageNumber, "stage " .. stageNumber, "stage" .. stageNumber,
			"Room " .. stageNumber, "Room" .. stageNumber, "room " .. stageNumber, "room" .. stageNumber
		}
		for _, object in ipairs(workspace:GetDescendants()) do
			if object:IsA("Model") or object:IsA("Folder") then
				for _, name in ipairs(exactNames) do
					if object.Name == name then return object end
				end
				if ExtractStageNumber(object.Name) == stageNumber then return object end
			end
		end
		return nil
	end

	local function IsYellowPart(part)
		if not part:IsA("BasePart") then return false end
		local color = part.Color
		return color.R >= 0.75 and color.G >= 0.65 and color.B <= 0.45
	end

	local function IsPlatformName(name)
		local lower = string.lower(name)
		return string.find(lower, "yellow") or string.find(lower, "win") or string.find(lower, "goal") or string.find(lower, "finish") or string.find(lower, "trophy") or string.find(lower, "pad")
	end

	local function FindYellowPad(stage)
		if not stage then return nil end
		for _, object in ipairs(stage:GetDescendants()) do
			if object:IsA("BasePart") and IsPlatformName(object.Name) and IsYellowPart(object) then return object end
		end
		local candidates = {}
		for _, object in ipairs(stage:GetDescendants()) do
			if object:IsA("BasePart") and IsYellowPart(object) then table.insert(candidates, object) end
		end
		if #candidates == 0 then return nil end
		table.sort(candidates, function(a, b)
			return (a.Size.X * a.Size.Y * a.Size.Z) > (b.Size.X * b.Size.Y * b.Size.Z)
		end)
		return candidates[1]
	end

	local function FindStageStart(stage)
		if not stage then return nil end
		local names = {"Start", "StartPoint", "Spawn", "SpawnPoint", "Entrance", "Entry", "Begin", "Beginning"}
		for _, wanted in ipairs(names) do
			local object = stage:FindFirstChild(wanted, true)
			if object and object:IsA("BasePart") then return object end
		end
		return nil
	end

	local function WalkToPosition(position)
		if not plr.Character then return false end
		local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
		local root = plr.Character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not root then return false end

		local path = PathfindingService:CreatePath({AgentRadius = 2, AgentHeight = 5, AgentCanJump = true, AgentCanClimb = true, WaypointSpacing = 4})
		local success = pcall(function() path:ComputeAsync(root.Position, position) end)
		if not success or path.Status ~= Enum.PathStatus.Success then return false end

		for _, waypoint in ipairs(path:GetWaypoints()) do
			if not AutoFarmEnabled then return false end
			if waypoint.Action == Enum.PathWaypointAction.Jump then humanoid.Jump = true end
			humanoid:MoveTo(waypoint.Position)
			if not humanoid.MoveToFinished:Wait() then return false end
		end
		return true
	end

	local function GoToStage(stage)
		if not stage then return false end
		local start = FindStageStart(stage)
		if start then return WalkToPosition(start.Position + Vector3.new(0, 3, 0)) end
		return true
	end

	local function StartAutoFarm()
		if AutoFarmRunning then return end
		AutoFarmRunning = true
		task.spawn(function()
			local currentStage = SelectedStage
			while AutoFarmEnabled do
				local stage = FindStage(currentStage)
				if not stage then
					game:GetService("StarterGui"):SetCore("SendNotification", {Title="Autofarm", Text="Stage not found: " .. tostring(currentStage), Duration=3})
					break
				end
				local startSuccess = GoToStage(stage)
				if not startSuccess then task.wait(0.5) continue end
				local yellowPad = FindYellowPad(stage)
				if not yellowPad then task.wait(1) continue end
				local reached = WalkToPosition(yellowPad.Position + Vector3.new(0, 3, 0))
				if reached then
					task.wait(StageDelay)
					currentStage += 1
				else
					task.wait(0.5)
				end
			end
			AutoFarmRunning = false
		end)
	end

	-- MAIN LOOP & CONNECTIONS
	RunService.RenderStepped:Connect(function()
		pcall(AimbotLoop)
		pcall(TriggerbotLoop)
		pcall(UpdateFOVCircle)
		if ESPEnabled then pcall(UpdateESP) end
		if TracersEnabled then pcall(UpdateTracers) end
	end)

	plr.CharacterAdded:Connect(function()
		task.wait(0.5)
		ClearESP()
		ClearTracers()
		if FlightEnabled then pcall(StartFlight) end
		if NoclipEnabled then pcall(StartNoclip) end
		if SpeedEnabled then pcall(UpdateSpeed) end
		pcall(UpdateFOVCircle)
	end)

	-- ========================================================
	-- MAIN HUB GUI (WITH BY NINH NGUYEN)
	-- ========================================================
	local VietnamHub = Instance.new("ScreenGui")
	VietnamHub.Name = "VietnamHub"
	VietnamHub.Parent = game.CoreGui
	VietnamHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = VietnamHub
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 520, 0, 360)
	MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.Draggable = true

	local UICornerMain = Instance.new("UICorner")
	UICornerMain.CornerRadius = UDim.new(0, 8)
	UICornerMain.Parent = MainFrame

	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = MainFrame
	TitleBar.Size = UDim2.new(1, 0, 0, 35)
	TitleBar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

	local TitleCorner = Instance.new("UICorner")
	TitleCorner.CornerRadius = UDim.new(0, 8)
	TitleCorner.Parent = TitleBar

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Parent = TitleBar
	TitleLabel.Size = UDim2.new(1, -40, 1, 0)
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Font = Enum.Font.SourceSansBold
	TitleLabel.Text = "★ VIETNAM HUB ★ | by Ninh Nguyen"
	TitleLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
	TitleLabel.TextSize = 17
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.Position = UDim2.new(0, 0, 0, 35)
	Sidebar.Size = UDim2.new(0, 120, 1, -35)
	Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Sidebar.BorderSizePixel = 0

	local UIListLayoutSide = Instance.new("UIListLayout")
	UIListLayoutSide.Parent = Sidebar
	UIListLayoutSide.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayoutSide.Padding = UDim.new(0, 5)

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Parent = MainFrame
	ContentContainer.Position = UDim2.new(0, 125, 0, 40)
	ContentContainer.Size = UDim2.new(1, -130, 1, -45)
	ContentContainer.BackgroundTransparency = 1

	local Tabs, Pages = {}, {}

	local function CreateTab(name)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = name .. "_Tab"
		TabBtn.Parent = Sidebar
		TabBtn.Size = UDim2.new(1, -10, 0, 30)
		TabBtn.Position = UDim2.new(0, 5, 0, 0)
		TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		TabBtn.BorderSizePixel = 0
		TabBtn.Font = Enum.Font.SourceSans
		TabBtn.Text = name
		TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabBtn.TextSize = 14
		
		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 4)
		TabCorner.Parent = TabBtn

		local Page = Instance.new("ScrollingFrame")
		Page.Name = name .. "_Page"
		Page.Parent = ContentContainer
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 4
		Page.CanvasSize = UDim2.new(0, 0, 3, 0)

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Parent = Page
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 6)

		TabBtn.MouseButton1Click:Connect(function()
			for _, p in pairs(Pages) do p.Visible = false end
			for _, b in pairs(Tabs) do b.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end
			Page.Visible = true
			TabBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
		end)

		table.insert(Tabs, TabBtn)
		Pages[name] = Page
		return Page
	end

	-- ENGLISH TABS
	local HomeTab = CreateTab("Home")
	local MainTab = CreateTab("Features")
	local OPTab = CreateTab("OP Features")
	local AimbotTab = CreateTab("Aimbot & ESP")
	local MovementTab = CreateTab("Movement")
	local PlusOneTab = CreateTab("+1 Farm")
	local MiscTab = CreateTab("Misc")

	Pages["Home"].Visible = true
	Tabs[1].BackgroundColor3 = Color3.fromRGB(180, 0, 0)

	-- HELPER FUNCTIONS FOR CREATING UI ELEMENTS
	local function AddButton(parent, title, callback)
		local Btn = Instance.new("TextButton")
		Btn.Parent = parent
		Btn.Size = UDim2.new(1, -10, 0, 32)
		Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		Btn.BorderSizePixel = 0
		Btn.Font = Enum.Font.SourceSansBold
		Btn.Text = title
		Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		Btn.TextSize = 14
		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 4)
		Corner.Parent = Btn
		Btn.MouseButton1Click:Connect(callback)
		return Btn
	end

	local function AddToggle(parent, title, default, callback)
		local state = default
		local Btn = Instance.new("TextButton")
		Btn.Parent = parent
		Btn.Size = UDim2.new(1, -10, 0, 32)
		Btn.BackgroundColor3 = state and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
		Btn.BorderSizePixel = 0
		Btn.Font = Enum.Font.SourceSansBold
		Btn.Text = title .. ": " .. (state and "ON" or "OFF")
		Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		Btn.TextSize = 14
		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 4)
		Corner.Parent = Btn

		Btn.MouseButton1Click:Connect(function()
			state = not state
			Btn.BackgroundColor3 = state and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
			Btn.Text = title .. ": " .. (state and "ON" or "OFF")
			callback(state)
		end)
		return Btn
	end

	-- ORIGINAL OP FEATURES BUTTONS
	AddButton(OPTab, "Anti Ragdoll (Toggle)", function()
		ToggleRagdoll(true)
		game:GetService("StarterGui"):SetCore("SendNotification", {Title="Vietnam Hub", Text="Anti-Ragdoll Enabled!"})
	end)

	AddButton(OPTab, "Push Aura (Around)", function()
		task.spawn(function()
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= plr and GetRoot(p) then
					local dist = (GetRoot(plr).Position - GetRoot(p).Position).Magnitude
					if dist < 15 then
						local Push = GetPush()
						if Push then Push.PushTool:FireServer(p.Character) end
					end
				end
			end
		end)
	end)

	AddButton(OPTab, "Void Protection", function()
		ToggleVoidProtection(true)
		game:GetService("StarterGui"):SetCore("SendNotification", {Title="Vietnam Hub", Text="Void Protection: ON"})
	end)

	AddButton(OPTab, "Animation: Zombie FE", function() PlayAnim(616154730, 0, 1) end)
	AddButton(OPTab, "Animation: Vampire", function() PlayAnim(1083445855, 0, 1) end)

	AddButton(OPTab, "Anti AFK", function()
		local VirtualUser = game:GetService("VirtualUser")
		plr.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
		game:GetService("StarterGui"):SetCore("SendNotification", {Title="Vietnam Hub", Text="Anti-AFK Activated!"})
	end)

	-- INTEGRATED AIMBOT & ESP BUTTONS
	AddToggle(AimbotTab, "Aimbot", false, function(v) AimbotEnabled = v end)
	AddToggle(AimbotTab, "Smooth Aimbot", false, function(v) SmoothAimbot = v end)
	AddToggle(AimbotTab, "FOV Circle", false, function(v) FOVCircleEnabled = v UpdateFOVCircle() end)
	AddToggle(AimbotTab, "Wall Check", false, function(v) WallCheck = v end)
	AddToggle(AimbotTab, "Team Check", false, function(v) TeamCheck = v end)
	AddToggle(AimbotTab, "Triggerbot", false, function(v) TriggerbotEnabled = v end)
	AddToggle(AimbotTab, "ESP", false, function(v) ESPEnabled = v if not v then ClearESP() end end)
	AddToggle(AimbotTab, "ESP Boxes", true, function(v) ESPBoxes = v end)
	AddToggle(AimbotTab, "ESP Names", true, function(v) ESPNames = v end)
	AddToggle(AimbotTab, "Tracers", false, function(v) TracersEnabled = v if not v then ClearTracers() end end)

	-- INTEGRATED MOVEMENT BUTTONS
	AddToggle(MovementTab, "Flight", false, function(v)
		FlightEnabled = v
		if v then StartFlight() else StopFlight() end
	end)
	AddToggle(MovementTab, "Speed Hack", false, function(v)
		SpeedEnabled = v
		UpdateSpeed()
	end)
	AddToggle(MovementTab, "Noclip", false, function(v)
		NoclipEnabled = v
		if v then StartNoclip() else StopNoclip() end
	end)

	-- INTEGRATED +1 FARM BUTTON
	AddToggle(PlusOneTab, "Autofarm", false, function(v)
		AutoFarmEnabled = v
		if v then StartAutoFarm() end
	end)

	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Vietnam Hub by Ninh Nguyen",
		Text = "Valid Key! Logged in successfully.",
		Duration = 5
	})
end

-- KEY CHECK ON SUBMIT
SubmitBtn.MouseButton1Click:Connect(function()
	local InputtedKey = KeyInput.Text
	if ValidKeys[InputtedKey] then
		StatusLabel.Text = "Correct Key! Loading..."
		StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		task.wait(1)
		LoadMainHub()
	else
		StatusLabel.Text = "Invalid Key! Get key from Discord."
		StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
	end
end)
