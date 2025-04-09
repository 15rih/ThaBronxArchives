local Car = script.Parent
local Window = Car:WaitForChild("WindowBreak");
local Lights = Car:WaitForChild("CarLightTurnOnOff");

-- Sounds
local Light = require(script.Lights);
local AlarmSound = Instance.new("Sound"); AlarmSound.SoundId = "rbxassetid://9113018507"
AlarmSound.Parent = Window
AlarmSound.Looped = true

-- Lights Setup
Light:Register(Lights:WaitForChild("SpotLight"))

-- Local Functions
local Types = {"alert", "money", "lmsg"}
local function NotifyClient(Player, Type, Message)
	Type = Type:lower() or "alert"
	game.ReplicatedStorage.server:FireClient(Player, Type, Message)
end

-- Prompts
local RobPrompt = Car:WaitForChild("E2Start"):WaitForChild("StartRobbery");
local TakeCash = Car:WaitForChild("Promt2"):WaitForChild("TakeCash");

-- Bools
local LastRob = 0
local CanRob = true

-- Setup
RobPrompt.Triggered:Connect(function(Player)
	if (not CanRob) then
		return NotifyClient(Player, "Alert", "You can not rob this right now. (Cooldown)")
	end
	
	CanRob = false
	Light:Play()
	AlarmSound:Play()
	
	task.delay(12, function()
		Light:Stop()
		AlarmSound:Stop()
	end)
	
	RobPrompt.Enabled = false
	TakeCash.Enabled = true
	
	Window.SoundWindow:Play()
	Window.Transparency = 1
	
	task.delay(20, function()
		Window.Transparency = 0
		TakeCash.Enabled = false
		
		task.delay(60 * 7, function()
			RobPrompt.Enabled = true
			CanRob = true
		end)
	end)
end)

TakeCash.Triggered:Connect(function(Player)
	if (CanRob) then
		return NotifyClient(Player, "Alert", "You may not take this right now.")
	end
	
	TakeCash.Enabled = false
	
	Player.stored.Money.Value += 275
	NotifyClient(Player, "Money", "+ $275")
end)
