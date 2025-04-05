--// this still works but is trash

local LocalPlayer = cloneref(game:GetService("Players").LocalPlayer)

getgenv().Teleport = true
while getgenv().Teleport == true do
  task.wait(0.001)
  LocalPlayer.Character.Humanoid:ChangeState(5) --// freefall
  task.delay(1.9, function()
     LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-236, 284, -777)
     LocalPlayer.Character.Humanoid:ChangeState(7) --// landing
     task.delay(0.3, function()
        getgenv().Teleport = false
    end)
  end)
end
