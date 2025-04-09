local character = script.Parent
local HRP = character:WaitForChild("HumanoidRootPart")

HRP.ChildAdded:Connect(function(v)
	if (v:IsA("BodyGyro") or v:IsA("BodyPosition") or v:IsA("BodyVelocity")) and not string.find(v.Name:lower(),"adonis") and not string.find(v.Name:lower(),"gun") then
		game.ReplicatedStorage.AE:FireServer(0013,v)
	end
end)

local humanoid = character:WaitForChild("Humanoid")

local m = 20
local f = false

function sendNotice()
	if f then return end 
	print("f")
	f = true
	game.ReplicatedStorage.AE:FireServer(0018,humanoid.WalkSpeed)
	wait(1)
	f = false
end

humanoid.Changed:Connect(function()
	if humanoid.WalkSpeed and humanoid.WalkSpeed >= 30 then
		sendNotice()
	end
end)
