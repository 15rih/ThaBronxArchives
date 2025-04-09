local Folder = script:FindFirstAncestorWhichIsA("Folder");
local Prompt = script.Parent
local Cashier = Folder:WaitForChild("NPC Rob2");
local Alarm = Folder:WaitForChild("Cashier2"):WaitForChild("Alarm");

local Open = Folder.Cashier2:WaitForChild("Open");
local Scream = Cashier:WaitForChild("Scream");

local Money = game.ReplicatedStorage:WaitForChild("MoneyCloner");
local Humanoid = Cashier:WaitForChild("Humanoid");

local function CreateAnimation(Id)
	local Animation = Instance.new("Animation");
	Animation.AnimationId = ("rbxassetid://%s"):format(Id)
	return Animation
end

local HandsUp = Humanoid:LoadAnimation(CreateAnimation('15267577230'));
local OpenRegister = Humanoid:LoadAnimation(CreateAnimation('15267620924'));

local Start = 0
local Events = {
	["Robbed"] = Instance.new('BindableEvent'),
	["RobberyFinished"] = Instance.new('BindableEvent')
};

local function HasBeenSevenMinutes()
	return (tick() - Start) >= (60 * 7)
end

local Types = {"alert", "money", "lmsg"}
local function NotifyClient(Player, Type, Message)
	Type = Type:lower() or "alert"
	game.ReplicatedStorage.server:FireClient(Player, Type, Message)
end

local BeingRobbed = false
Events.Robbed.Event:Connect(function(Player)
	if (BeingRobbed) then
		NotifyClient(Player, "Alert", "Already Being Robbed")
		return
	end
	
	if (not HasBeenSevenMinutes()) then
		NotifyClient(Player, "Alert", "Cool Down")
		return
	end
	
	Start = tick()
	BeingRobbed = true
	
	Alarm:Play()
	Scream:Play()
	HandsUp:Play()
	task.delay(HandsUp.Length, function()
		HandsUp:Stop()
		
		Open:Play()
		OpenRegister:Play()
		
		task.delay(OpenRegister.Length, function()
			task.delay(10, function()
				Alarm:Stop()
			end)
			
			Events.RobberyFinished:Fire(Player)
		end)
	end)
end)

local function ShootCash(Character, Register, Int)
	Int = 5
	
	for i = 1, Int do
		local Cash = Money:Clone();
		local CashAmount = 450
		local ClickDetector = Instance.new("ClickDetector", Cash);

		Cash:WaitForChild("Gui"):WaitForChild("MainFrame"):WaitForChild('rank').Text = ("$%s"):format(tostring(CashAmount))

		local Activated = false
		local Connection; Connection = ClickDetector.MouseClick:Connect(function(Player)
			Connection:Disconnect()
			if (Activated) then
				return
			end

			Activated = true

			Player:WaitForChild("stored"):WaitForChild("Money").Value += CashAmount
			game.ReplicatedStorage.server:FireClient(Player, "money", "+$"..tostring(CashAmount).."!")

			Cash:Destroy()
		end)

		Cash.Anchored = false
		Cash.Massless = false
		Cash.CanCollide = true
		Cash.CollisionGroupId = 2
		Cash.Parent = workspace
		Cash.CFrame = Register.CFrame + Vector3.new(math.random(-100,100)/100, -0.5, math.random(-100,100)/100)
		Cash:ApplyAngularImpulse(Vector3.new(math.random(-4,4), 1, math.random(-4,4)))
		Cash:ApplyImpulse(Vector3.new(math.random(-4,4), 1, math.random(-4,4)))
		game:GetService("Debris"):AddItem(Cash, 35)
		task.wait()
	end
end

Events.RobberyFinished.Event:Connect(function(Player)
	if (not BeingRobbed) then
		return
	end
	
	BeingRobbed = false
	ShootCash(Player.Character, Folder.Cashier2)
end)

Prompt.Triggered:Connect(function(Player)
	if (not BeingRobbed) then
		local Distance = (Player.Character.HumanoidRootPart.Position - Prompt.Parent.Position).Magnitude
		if (Distance <= 13 and Player.Character.Humanoid.Health > 0) then
			Events.Robbed:Fire(Player)
		end
	end
end)
