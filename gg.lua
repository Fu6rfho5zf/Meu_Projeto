-- Load Wizard UI Library

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

-- Configuration

local DEFAULT_TP_INTERVAL = 25.05

local tpInterval = DEFAULT_TP_INTERVAL

local DISCORD_LINK = "https://discord.gg/ShGYzjuU"

-- Services

local Players = game:GetService("Players")

local TeleportService = game:GetService("TeleportService")

local Lighting = game:GetService("Lighting")

local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Create Main Window

local Window = Library:NewWindow("💠 UGC Helper GUI")

local MainSection = Window:NewSection("Main Features")

-- State variables

local tpActive = false

local tpLoop

-- 🥶 Auto TP Gold

MainSection:CreateToggle("Auto TP Gold", function(state)

	tpActive = state	if tpActive then

		if tpLoop then return end

		tpLoop = task.spawn(function()

			while tpActive do

				if workspace:FindFirstChild("GoldGiver") and LocalPlayer.Character then

					LocalPlayer.Character:PivotTo(workspace.GoldGiver.CFrame + Vector3.new(0, 3, 0))

				end

				task.wait(tpInterval)

			end

			tpLoop = nil

		end)

	end

end)

-- 🚀 FPS Booster

MainSection:CreateToggle("FPS Booster", function(state)

	local terrain = workspace:FindFirstChildOfClass("Terrain")

	Lighting.GlobalShadows = not state

	if terrain then

		terrain.WaterWaveSize = state and 0 or 1

	end

end)

-- 🔁 Rejoin Server

MainSection:CreateButton("Rejoin Server", function()

	TeleportService:Teleport(game.PlaceId)

end)

-- ⏱️ TP Interval Input

MainSection:CreateTextbox("TP Interval (sec)", function(input)

	local val = tonumber(input)

	if val and val > 0 then

		tpInterval = val

		StarterGui:SetCore("SendNotification", {

			Title = "TP Speed Updated",

			Text = "New interval: " .. val .. " sec",

			Duration = 2

		})

	else

		tpInterval = DEFAULT_TP_INTERVAL

		StarterGui:SetCore("SendNotification", {

			Title = "Invalid Input",

			Text = "Reset to default: 25.05 sec",

			Duration = 3

		})

	end

end)

-- 🛡️ Anti-AFK (supports various exploits)

task.spawn(function()

	local vu = game:GetService("VirtualUser")

	if vu then

		LocalPlayer.Idled:Connect(function()

			vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)

			task.wait(1)

			vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)

		end)

	else

		warn("VirtualUser not available. Anti-AFK may not work on this executor.")

	end

end)

-- 🔍 Glass Bridge ESP (real panels only)

MainSection:CreateToggle("Glass Bridge ESP", function(state)

	local ESP_NAME = "GlassBridgeESP"

	-- Cleanup Function

	local function clearESP()

		for _, panel in ipairs(workspace:GetDescendants()) do

			if panel:IsA("Part") and panel.Name == "Panel" then

				local existing = panel:FindFirstChild(ESP_NAME)

				if existing then

					existing:Destroy()

				end

			end

		end

	end

	if state then

		clearESP()

		local count = 0

		for _, panel in ipairs(workspace:GetDescendants()) do

			if panel:IsA("Part") and panel.Name == "Panel" then

				local isFake = panel:GetAttribute("Fake")

				if not isFake and count < 25 then

					count += 1

					local esp = Instance.new("BoxHandleAdornment")

					esp.Name = ESP_NAME

					esp.Size = panel.Size + Vector3.new(0.1, 0.1, 0.1)

					esp.Adornee = panel

					esp.Color3 = Color3.fromRGB(0, 255, 0)

					esp.AlwaysOnTop = true

					esp.ZIndex = 5

					esp.Transparency = 0.25 -- 25% transparent

					esp.Parent = panel

				end

			end

		end

	else

		clearESP()

	end

end)

-- 📣 Discord Section

local DiscordSection = Window:NewSection("📣 Community")

DiscordSection:CreateButton("📋 Copy Discord Link", function()

	setclipboard(DISCORD_LINK)

	StarterGui:SetCore("SendNotification", {

		Title = "Copied!",

		Text = "Discord link copied to clipboard.",

		Duration = 2,

	})

end)

-- Additional checks for specific executor support

if not game:GetService("Players") or not game:GetService("Workspace") then

    warn("Some features might not work on this executor. Please ensure you're using a compatible executor.")

end