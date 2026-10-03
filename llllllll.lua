-- ========================================================
-- VIETNAM HUB (VER 1.2) - KEY SYSTEM & OP FEATURES
-- ========================================================

-- KIỂM TRA TRÁNH LOAD TRÙNG
if game.CoreGui:FindFirstChild("VietnamHubKeyGui") or game.CoreGui:FindFirstChild("VietnamHub") then
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Vietnam Hub",
		Text = "GUI hoặc Bảng Key đã được mở!",
		Duration = 5
	})
	return
end

-- DANH SÁCH KEY HỢP LỆ
local ValidKeys = {
	["VIETNAM-HUB-2026"] = true,
	["VIETNAM-HUB-OP"] = true,
	["FREE-KEY"] = true
}

-- LINK DISCORD LẤY KEY
local DiscordLink = "https://discord.gg/3JrDAhT9k"

-- BIẾN HỆ THỐNG & DỊCH VỤ
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ========================================================
-- TẠO GIAO DIỆN HỆ THỐNG KEY (KEY SYSTEM UI)
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
KeyTitleLabel.Text = "★ VIETNAM HUB - KEY SYSTEM ★"
KeyTitleLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
KeyTitleLabel.TextSize = 16

local KeyInput = Instance.new("TextBox")
KeyInput.Parent = KeyFrame
KeyInput.Position = UDim2.new(0.08, 0, 0.28, 0)
KeyInput.Size = UDim2.new(0.84, 0, 0, 38)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInput.BorderSizePixel = 0
KeyInput.Font = Enum.Font.SourceSans
KeyInput.PlaceholderText = "Nhập Key vào đây..."
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
SubmitBtn.Text = "Nhập Key"
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
StatusLabel.Text = "Nhấn 'Get Key' để copy link Discord và lấy Key!"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 13

-- XỬ LÝ NÚT GET KEY (COPY LINK DISCORD)
GetKeyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(DiscordLink)
		StatusLabel.Text = "Đã copy Discord! Vui lòng dán vào trình duyệt để lấy Key."
		StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Vietnam Hub",
			Text = "Đã sao chép link Discord vào Clipboard!",
			Duration = 4
		})
	else
		StatusLabel.Text = "Executor không hỗ trợ sao chép tự động!"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
	end
end)

-- ========================================================
-- HÀM KÍCH HOẠT GUI CHÍNH KHI NHẬP ĐÚNG KEY
-- ========================================================
local function LoadMainHub()
	KeyGui:Destroy()

	-- CÁC HÀM BỔ TRỢ TÍNH NĂNG OP
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

	-- KHỞI TẠO GIAO DIỆN CHÍNH (VIETNAM HUB)
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
	TitleLabel.Text = "★ VIETNAM HUB ★"
	TitleLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
	TitleLabel.TextSize = 18
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
		Page.CanvasSize = UDim2.new(0, 0, 2, 0)

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

	local HomeTab = CreateTab("Trang Chủ")
	local MainTab = CreateTab("Tính Năng")
	local OPTab = CreateTab("OP Features")
	local MiscTab = CreateTab("Khác")

	Pages["Trang Chủ"].Visible = true
	Tabs[1].BackgroundColor3 = Color3.fromRGB(180, 0, 0)

	local function AddOPButton(title, callback)
		local Btn = Instance.new("TextButton")
		Btn.Parent = OPTab
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

	-- CÁC NÚT TÍNH NĂNG OP
	AddOPButton("Anti Ragdoll (Bật/Tắt)", function()
		ToggleRagdoll(true)
		game:GetService("StarterGui"):SetCore("SendNotification", {Title="Vietnam Hub", Text="Đã bật Anti-Ragdoll!"})
	end)

	AddOPButton("Push Aura (Xung quanh)", function()
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

	AddOPButton("Bảo Vệ Hố Vô Tận (Void Protection)", function()
		ToggleVoidProtection(true)
		game:GetService("StarterGui"):SetCore("SendNotification", {Title="Vietnam Hub", Text="Void Protection: BẬT"})
	end)

	AddOPButton("Bay (Fly System)", function()
		local BodyVel = Instance.new("BodyVelocity")
		BodyVel.Velocity = Vector3.new(0,0,0)
		BodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		BodyVel.Parent = GetRoot(plr)
		game:GetService("StarterGui"):SetCore("SendNotification", {Title="Vietnam Hub", Text="Đã kích hoạt Fly"})
	end)

	AddOPButton("Animation: Zombie FE", function() PlayAnim(616154730, 0, 1) end)
	AddOPButton("Animation: Vampire", function() PlayAnim(1083445855, 0, 1) end)

	AddOPButton("Anti AFK", function()
		local VirtualUser = game:GetService("VirtualUser")
		plr.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
		game:GetService("StarterGui"):SetCore("SendNotification", {Title="Vietnam Hub", Text="Anti-AFK Kích hoạt!"})
	end)

	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Vietnam Hub",
		Text = "Key hợp lệ! Đã đăng nhập thành công.",
		Duration = 5
	})
end

-- KIỂM TRA KEY KHI NHẤN NÚT NHẬP KEY
SubmitBtn.MouseButton1Click:Connect(function()
	local InputtedKey = KeyInput.Text
	if ValidKeys[InputtedKey] then
		StatusLabel.Text = "Key chính xác! Đang tải..."
		StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		task.wait(1)
		LoadMainHub()
	else
		StatusLabel.Text = "Key không hợp lệ! Vui lòng lấy key tại Discord."
		StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
	end
end)
