local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HuuFPSMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- MAIN MENU
--------------------------------------------------

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 150)
main.Position = UDim2.new(0.5, -150, 0.35, 0)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = main

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "⚡ FPS MENU"
title.TextSize = 23
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.Parent = main

--------------------------------------------------
-- X BUTTON
--------------------------------------------------

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 38, 0, 38)
close.Position = UDim2.new(1, -45, 0, 6)
close.BackgroundColor3 = Color3.fromRGB(35,35,40)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.TextSize = 20
close.Font = Enum.Font.GothamBold
close.BorderSizePixel = 0
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1,0)
closeCorner.Parent = close

--------------------------------------------------
-- FPS TEXT
--------------------------------------------------

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 0, 55)
fpsLabel.Position = UDim2.new(0, 0, 0, 55)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.TextSize = 32
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextColor3 = Color3.fromRGB(255,0,0)
fpsLabel.Parent = main

--------------------------------------------------
-- NÚT NHỎ KHI MENU TẮT
--------------------------------------------------

local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0, 55, 0, 55)
mini.Position = UDim2.new(0, 25, 0.35, 0)
mini.BackgroundColor3 = Color3.fromRGB(8,8,8)
mini.Text = ""
mini.Visible = false
mini.BorderSizePixel = 0
mini.Parent = gui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1,0)
miniCorner.Parent = mini

-- Viền cầu vồng
local stroke = Instance.new("UIStroke")
stroke.Thickness = 4
stroke.Parent = mini

--------------------------------------------------
-- FPS
--------------------------------------------------

local frames = 0
local lastTime = os.clock()

RunService.RenderStepped:Connect(function()
	frames += 1

	local now = os.clock()

	if now - lastTime >= 0.5 then
		local fps = math.floor(frames / (now - lastTime))

		fpsLabel.Text = "FPS: " .. fps

		frames = 0
		lastTime = now
	end
end)

--------------------------------------------------
-- CẦU VỒNG CHẠY CHẬM
--------------------------------------------------

task.spawn(function()
	local hue = 0

	while gui.Parent do
		hue = (hue + 0.0015) % 1

		local rainbow = Color3.fromHSV(hue, 1, 1)

		fpsLabel.TextColor3 = rainbow
		title.TextColor3 = rainbow
		stroke.Color = rainbow

		task.wait(0.03)
	end
end)

--------------------------------------------------
-- ẨN / HIỆN MENU
--------------------------------------------------

close.MouseButton1Click:Connect(function()
	main.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	main.Visible = true
	mini.Visible = false
end)

--------------------------------------------------
-- KÉO MENU BẰNG CHUỘT / CẢM ỨNG
--------------------------------------------------

local function makeDraggable(object)

	local dragging = false
	local dragStart
	local startPosition

	local function update(input)
		local delta = input.Position - dragStart

		object.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end

	object.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPosition = object.Position

			input.Changed:Connect(function()

				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end

			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)

		if dragging and (
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		) then

			update(input)
		end
	end)
end

makeDraggable(main)
makeDraggable(mini)
