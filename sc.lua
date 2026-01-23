-- SERVICES
--[[
AUTHOR : BRODXZZ
BY PLENGER TEAM IIP ]]--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

pcall(function()
    player.PlayerGui.BrodyGui:Destroy()
end)

local MIN_SPEED, MAX_SPEED = 16, 90
local speedEnabled = false
local noclipEnabled = false
local espEnabled = false
local currentSpeed = 16
local followEnabled = false
local followTarget = nil


local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "BrodyGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 230)
frame.Position = UDim2.new(0.5, -135, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local banner = Instance.new("TextLabel", frame)
banner.Size = UDim2.new(1,0,0,25)
banner.BackgroundColor3 = Color3.fromRGB(15,15,15)
banner.Text = "LAZY SCRIPT by BRODZ"
banner.TextColor3 = Color3.fromRGB(0,255,180)
banner.Font = Enum.Font.GothamBold
banner.TextSize = 14
banner.BorderSizePixel = 0
Instance.new("UICorner", banner).CornerRadius = UDim.new(0,12)

local mini = Instance.new("TextButton", banner)
mini.Size = UDim2.new(0,25,1,0)
mini.Position = UDim2.new(1,-25,0,0)
mini.Text = "-"
mini.BackgroundTransparency = 1
mini.TextColor3 = Color3.new(1,1,1)

local container = Instance.new("Frame", frame)
container.Position = UDim2.new(0,0,0,30)
container.Size = UDim2.new(1,0,1,-30)
container.BackgroundTransparency = 1

local box = Instance.new("TextBox", container)
box.Size = UDim2.new(0.8,0,0,30)
box.Position = UDim2.new(0.1,0,0,0)
box.Text = "16"
box.PlaceholderText = "Speed 16 - 90"
box.BackgroundColor3 = Color3.fromRGB(25,25,25)
box.TextColor3 = Color3.new(1,1,1)
box.BorderSizePixel = 0
Instance.new("UICorner", box)

local function makeBtn(text, y)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(0.8,0,0,32)
    b.Position = UDim2.new(0.1,0,y,0)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.new(1,1,1)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b)
    return b
end

local speedBtn = makeBtn("Kecepatan kilat OFF", 0.18)
local noclipBtn = makeBtn("Nembus OFF", 0.36)
local espBtn = makeBtn("ESP OFF", 0.54)
local tpBtn = makeBtn("Pepet Pemain", 0.72)

local function humanoid()
    return player.Character and player.Character:FindFirstChildOfClass("Humanoid")
end

local function waitForHRP(char, timeout)
	timeout = timeout or 5
	local start = tick()
	while tick() - start < timeout do
		if char and char:FindFirstChild("HumanoidRootPart") then
			return char.HumanoidRootPart
		end
		task.wait()
	end
	return nil
end


local function lockSpeed(h)
    h.WalkSpeed = currentSpeed
    h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if speedEnabled and h.WalkSpeed ~= currentSpeed then
            h.WalkSpeed = currentSpeed
        end
    end)
end

box.FocusLost:Connect(function()
    local v = tonumber(box.Text)
    if v then
        currentSpeed = math.clamp(v, MIN_SPEED, MAX_SPEED)
        box.Text = tostring(currentSpeed)
        if speedEnabled and humanoid() then
            humanoid().WalkSpeed = currentSpeed
        end
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    local h = humanoid()
    if not h then return end
    speedEnabled = not speedEnabled
    speedBtn.Text = speedEnabled and ("Kecepatan kilat ON ("..currentSpeed..")") or "Kecepatan kilat OFF"
    if speedEnabled then
        lockSpeed(h)
    else
        h.WalkSpeed = 16
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = noclipEnabled and "Nembus ON" or "Nembus OFF"
end)

local espCache = {}



local function addESP(plr)
    if plr == player then return end

    local function apply(char)
        if espCache[plr] then
            for _,v in pairs(espCache[plr]) do
                v:Destroy()
            end
        end

        local hl = Instance.new("Highlight")
        hl.Adornee = char
        hl.FillTransparency = 0.9
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char

        task.spawn(function()
            while espEnabled and char.Parent do
                local mySize = getSize(player)
                local enemySize = getSize(plr)

                hl.FillColor = Color3.fromRGB(255,0,0) -- MERAH
                hl.OutlineColor = Color3.fromRGB(255,0,0)

                task.wait(0.4)
            end
        end)

        espCache[plr] = {hl}
    end

    if plr.Character then apply(plr.Character) end
    plr.CharacterAdded:Connect(apply)
end

local function clearESP()
    for _,objs in pairs(espCache) do
        for _,v in pairs(objs) do
            v:Destroy()
        end
    end
    espCache = {}
end

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP ON" or "ESP OFF"

    if espEnabled then
        for _,p in pairs(Players:GetPlayers()) do
            addESP(p)
        end
        Players.PlayerAdded:Connect(addESP)
    else
        clearESP()
    end
end)

local function getHRP(plr, timeout)
	timeout = timeout or 10
	local start = tick()

	while tick() - start < timeout do
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			return plr.Character.HumanoidRootPart
		end
		task.wait(0.1)
	end

	return nil
end



local function getScore(plr)
    if not plr then return 0 end

    local stats = plr:FindFirstChild("leaderstats")
    if not stats then return 0 end

    -- PAKSA cari value yang bener
    local score = stats:FindFirstChild("Score")
        or stats:FindFirstChild("score")
        or stats:FindFirstChild("Size")
        or stats:FindFirstChild("Power")

    if score and score:IsA("NumberValue") then
        if score.Value == math.huge or score.Value ~= score.Value then
            return 0
        end
        return score.Value
    end

    return 0
end
local function parseSize(text)
	text = text:lower():gsub(",", "")
	local num = tonumber(text:match("[%d%.]+"))
	if not num then return 0 end

	if text:find("k") then
		return num * 1e3
	elseif text:find("m") then
		return num * 1e6
	elseif text:find("b") then
		return num * 1e9
	end

	return num
end

local function getPlayerSize(plr)
	if not plr.Character then return 0 end

	for _,v in pairs(plr.Character:GetDescendants()) do
		if v:IsA("TextLabel") then
			if v.Text and v.Text:find("%d") then
				local size = parseSize(v.Text)
				if size > 0 then
					return size
				end
			end
		end
	end

	return 0
end

local function getPlayerSize(plr)
	if not plr:FindFirstChild("PlayerGui") then return 0 end

	for _,v in pairs(plr.PlayerGui:GetDescendants()) do
		if v:IsA("TextLabel") and v.Name == "SizeText" then
			return parseSize(v.Text)
		end
	end

	return 0
end


local refreshPlayerList
local tpGui
local scoreConnections = {}
local function openTeleportGui()
	
	if tpGui then tpGui:Destroy() end
	tpGui = Instance.new("ScreenGui", player.PlayerGui)
	tpGui.Name = "TeleportPlayerGui"
	tpGui.ResetOnSpawn = false

	local frame = Instance.new("Frame", tpGui)
	frame.Size = UDim2.new(0,260,0,260)
	frame.Position = UDim2.new(0.55,0,0.45,0)
	frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
	frame.Active = true
	frame.Draggable = true
	frame.BorderSizePixel = 0
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

	-- ===== TOP BAR =====
	local top = Instance.new("Frame", frame)
	top.Size = UDim2.new(1,0,0,28)
	top.BackgroundColor3 = Color3.fromRGB(15,15,15)
	top.BorderSizePixel = 0
	Instance.new("UICorner", top).CornerRadius = UDim.new(0,12)

	local title = Instance.new("TextLabel", top)
	title.Size = UDim2.new(1,-60,1,0)
	title.Position = UDim2.new(0,10,0,0)
	title.Text = "PEPET SEKARANG JUGA!"
	title.TextColor3 = Color3.fromRGB(0,255,180)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 13
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left

	local close = Instance.new("TextButton", top)
	close.Size = UDim2.new(0,24,0,24)
	close.Position = UDim2.new(1,-26,0,2)
	close.Text = "X"
	close.BackgroundColor3 = Color3.fromRGB(180,60,60)
	close.TextColor3 = Color3.new(1,1,1)
	close.BorderSizePixel = 0
	Instance.new("UICorner", close)

	local mini = Instance.new("TextButton", top)
	mini.Size = UDim2.new(0,24,0,24)
	mini.Position = UDim2.new(1,-52,0,2)
	mini.Text = "-"
	mini.BackgroundColor3 = Color3.fromRGB(40,40,40)
	mini.TextColor3 = Color3.new(1,1,1)
	mini.BorderSizePixel = 0
	Instance.new("UICorner", mini)


	local list = Instance.new("ScrollingFrame", frame)
	list.Position = UDim2.new(0,10,0,38)
	list.Size = UDim2.new(1,-20,1,-48)
	list.CanvasSize = UDim2.new(0,0,0,0)
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y
	list.ScrollBarImageTransparency = 0.3
	list.BackgroundColor3 = Color3.fromRGB(25,25,25)
	list.BorderSizePixel = 0
	Instance.new("UICorner", list)

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,4)
	layout.Parent = list

    local followBtn = Instance.new("TextButton", frame)
    followBtn.Size = UDim2.new(1,-20,0,30)
    followBtn.Position = UDim2.new(0,10,1,-40)
    followBtn.Text = "PEPET : OFF"
    followBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
    followBtn.TextColor3 = Color3.new(1,1,1)
    followBtn.BorderSizePixel = 0
    Instance.new("UICorner", followBtn)
	close.MouseButton1Click:Connect(function()
    	if tpGui then
        	tpGui:Destroy()
        	tpGui = nil
        	list = nil
        	followTarget = nil
        	followEnabled = false
    	end
	end)
	local function getSortedPlayers()
		local temp = {}

		for _,plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				table.insert(temp, plr)
			end
		end

		table.sort(temp, function(a,b)
			return a.Name:lower() < b.Name:lower()
		end)

		return temp
	end
	refreshPlayerList = function()
	if not tpGui or not list then return end

	for _,v in ipairs(list:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	local players = Players:GetPlayers()

	for i, plr in ipairs(players) do
		if plr ~= player then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,0,0,30)
			btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
			btn.BorderSizePixel = 0
			btn.TextColor3 = Color3.new(1,1,1)
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 13
			btn.Parent = list
			Instance.new("UICorner", btn)
			btn.RichText = true
			btn.Text = string.format(
				'  <b>%d.</b> %s <font color="rgb(170,170,170)">| %s</font>',
				i,
				plr.DisplayName,
				plr.Name
			)

			btn.MouseButton1Click:Connect(function()
				followTarget = plr
				followEnabled = true
			end)
		end
	end
	
end

	refreshPlayerList()
	task.spawn(function()
		while tpGui do
			refreshPlayerList()
			task.wait(1)
		end
	end)
    followBtn.MouseButton1Click:Connect(function()
		followEnabled = not followEnabled

		if followEnabled then
			followBtn.Text = "MODE PEPET : ON"
			followBtn.BackgroundColor3 = Color3.fromRGB(40,160,80)
		else
			followBtn.Text = "MODE PEPET : OFF"
			followBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
		end
	end)
local minimized = false
	mini.MouseButton1Click:Connect(function()
		minimized = not minimized
		list.Visible = not minimized
		frame.Size = minimized and UDim2.new(0,260,0,30) or UDim2.new(0,260,0,260)
		mini.Text = minimized and "+" or "-"
	end)



end
RunService.Heartbeat:Connect(function()
	if followEnabled and followTarget then
		local myHRP = getHRP(player)
		local targetHRP = getHRP(followTarget)

		if myHRP and targetHRP then
			myHRP.CFrame = targetHRP.CFrame * CFrame.new(0,0,-2)
		end
	end
end)
tpBtn.MouseButton1Click:Connect(function()
	openTeleportGui()
	refreshPlayerList()

end)

local minimized = false
mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    container.Visible = not minimized
    frame.Size = minimized and UDim2.new(0,270,0,30) or UDim2.new(0,270,0,230)
    mini.Text = minimized and "+" or "-"
end)

player.CharacterAdded:Connect(function(c)
    if speedEnabled then lockSpeed(c:WaitForChild("Humanoid")) end
end)
