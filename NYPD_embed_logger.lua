local policeTeam = game:GetService("Teams"):WaitForChild("Police")
local groupId = 35671971

local http = game:GetService("HttpService")


local isInStudio = game:GetService("RunService"):IsStudio()

local hook = "https://webhook.newstargeted.com/api/webhooks/1131327388173750502/NnNhXnNwnV5mPwTJFxh1Epr5IiFypTzHK6dVAXN_o6pk3igZQP3Tfc6maDjUCx7GKT-Y"
local esuHook = "https://webhook.newstargeted.com/api/webhooks/1165776931761950750/E1oB5oQG5YdLNqnCE43i6lDpqNaXfgnMOtHKPVV4Gr0HfoXTi0kyDLzo007OtFIXl1Id"
local allLogsHook = "https://webhook.newstargeted.com/api/webhooks/1133478676688801873/hbq6OBbxJqHABK9H88WF46Rmv5fTS2Jg7qVO-W2qzvm0OLOfrp7SgLcgv3lqVb38iciG"
local fbihook = "https://webhook.newstargeted.com/api/webhooks/1165776691768078347/LzFzTxSoltRcabhQNI-KiDN6KNkMlKcq-G2d0p_WM-LdBYWYjLvNKTFl4fCCSApXQ4gP"

--local pdGate = game.Workspace.Map555555.PDGATEPART
--local pdGateBlock = game.Workspace.Map555555.PDGATEBLOCK
local pdGateBool = false

function generateBadgeID()

	local badge = ""

	local random1 = math.random(1,2)
	local random2 = math.random(1,2)
	local random3 = math.random(1,2)
	local random4 = math.random(1,2)

	if random1 == 1 then
		local randuppercase = string.char(math.random(65, 65 + 25))
		badge = badge..randuppercase
	else
		local randnumber = math.random(0,9)
		badge = badge..randnumber
	end
	if random2 == 1 then
		local randuppercase = string.char(math.random(65, 65 + 25))
		badge = badge..randuppercase
	else
		local randnumber = math.random(0,9)
		badge = badge..randnumber
	end
	if random3 == 1 then
		local randuppercase = string.char(math.random(65, 65 + 25))
		badge = badge..randuppercase
	else
		local randnumber = math.random(0,9)
		badge = badge..randnumber
	end
	if random4 == 1 then
		local randuppercase = string.char(math.random(65, 65 + 25))
		badge = badge..randuppercase
	else
		local randnumber = math.random(0,9)
		badge = badge..randnumber
	end

	return badge
end

function Format(Int)
	return string.format("%02i", Int)
end

function convertToHMS(Seconds)
	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return Format(Hours)..":"..Format(Minutes)..":"..Format(Seconds)
end

local policeSignOnTimes = {};
local esuSignOnTimes = {};
local fbiSignOnTimes = {};
local _FBI = {};

local function DoAction(plr, action)
	if (action == "signIn") then
		if (plr:GetRankInGroup(35671971) >= 2) or isInStudio then

			if policeSignOnTimes[plr] then return end
			if esuSignOnTimes[plr] then return end

			local badgeId = Instance.new("StringValue", plr)
			badgeId.Name = "BadgeId"
			local SignedOn = Instance.new("BoolValue", plr)
			SignedOn.Name = "SignedOn"

			policeSignOnTimes[plr] = tick()

			plr.Character:WaitForChild("Humanoid"):UnequipTools()

			plr.Team = policeTeam
			shared.LastTeleport[plr] = tick()
			plr.Character.HumanoidRootPart.CFrame = workspace:WaitForChild("policeSpawnLocation").CFrame

			local ui = script.Gui:Clone()
			ui.MainFrame.rank.Text = plr:GetRoleInGroup(35671971)
			ui.Parent = plr.Character.HumanoidRootPart.RootAttachment

			badgeId.Value = generateBadgeID()

			task.wait()

			ui.MainFrame.badge.Text = "BADGE ID: "..plr:FindFirstChild("BadgeId").Value
			print(ui.MainFrame.badge.Text)

			for i, v in pairs(plr.Backpack:GetChildren()) do
				if v:IsA("Tool") then
					v:Destroy()
				end
			end

			local data = {

				["content"] = plr.Name.." signed on.".." Badge Id: "..plr:FindFirstChild("BadgeId").Value	

			}
		end
	elseif (action == "signOut") then
		if plr:FindFirstChild("SignedOn") then
			plr:FindFirstChild("SignedOn"):Destroy()
			plr.Neutral = true
			wait()
			plr:LoadCharacter()

			local Time = tick() - policeSignOnTimes[plr]

			local data = {

				["content"] = plr.Name.." signed off |".." Badge Id: "..plr:FindFirstChild("BadgeId").Value.." | Time signed on: "..convertToHMS(Time)

			}

			policeSignOnTimes[plr] = nil
			plr:FindFirstChild("BadgeId"):Destroy()
		end
	end
end

game.Players.PlayerAdded:Connect(function(plr)
	plr.Chatted:Connect(function(chat)
		local split = chat:split(' ')
		if split[1]:lower() == '/passto' and plr.Team == policeTeam then
			local data = {

				["content"] = "```diff\n- "..plr.Name.." USED /PASSTO | MESSAGE: "..chat.."\n```"

			}

			data = http:JSONEncode(data)
			http:PostAsync(allLogsHook, data)
			return
		end
		
		if chat == "/signin" or chat == "/signon" or chat == "/nypd" or chat == "/onduty" then
			if (plr:GetRankInGroup(35671971) >= 2) or isInStudio then
				
				if policeSignOnTimes[plr] then return end
				if esuSignOnTimes[plr] then return end
				
				local badgeId = Instance.new("StringValue", plr)
				badgeId.Name = "BadgeId"
				local SignedOn = Instance.new("BoolValue", plr)
				SignedOn.Name = "SignedOn"
				
				policeSignOnTimes[plr] = tick()
				
				plr.Character:WaitForChild("Humanoid"):UnequipTools()
				
				plr.Team = policeTeam
				shared.LastTeleport[plr] = tick()
				plr.Character.HumanoidRootPart.CFrame = workspace:WaitForChild("policeSpawnLocation").CFrame
				
				local ui = script.Gui:Clone()
				ui.MainFrame.rank.Text = plr:GetRoleInGroup(35671971)
				ui.Parent = plr.Character.HumanoidRootPart.RootAttachment
				
				badgeId.Value = generateBadgeID()
				
				task.wait()
				
				ui.MainFrame.badge.Text = "BADGE ID: "..plr:FindFirstChild("BadgeId").Value
				print(ui.MainFrame.badge.Text)
				
				for i, v in pairs(plr.Backpack:GetChildren()) do
					if v:IsA("Tool") then
						v:Destroy()
					end
				end
				
				local data = {
					
					["content"] = plr.Name.." signed on.".." Badge Id: "..plr:FindFirstChild("BadgeId").Value	
					
				}
				
				
			end
		end
		if chat == "/signoff" or chat == "/offduty" and plr.Team == policeTeam then
			if plr:FindFirstChild("SignedOn") then
				plr:FindFirstChild("SignedOn"):Destroy()
				plr.Neutral = true
				wait()
				plr:LoadCharacter()
				
				local Time = tick() - policeSignOnTimes[plr]

				local data = {

					["content"] = plr.Name.." signed off |".." Badge Id: "..plr:FindFirstChild("BadgeId").Value.." | Time signed on: "..convertToHMS(Time)

				}
				
				policeSignOnTimes[plr] = nil
				plr:FindFirstChild("BadgeId"):Destroy()
				
			end
		end
		if chat == "/esu" or chat == "/esusignon" or chat == "/esusignin" or chat == "/esuonduty" or chat == "/esuon" then
			if (plr:GetRankInGroup(16324260) == 5 or plr:GetRankInGroup(16324260) == 6 or plr:GetRankInGroup(16324260) == 8 or plr:GetRankInGroup(16324260) == 9 or plr:GetRankInGroup(32777330) >= 253) or isInStudio then
				
				if policeSignOnTimes[plr] then return end
				if _FBI[plr] then return end
				
				plr.Team = policeTeam
				shared.LastTeleport[plr] = tick()
				plr.Character.HumanoidRootPart.CFrame = workspace:WaitForChild("policeSpawnLocation").CFrame

				
				local badgeId = Instance.new("StringValue", plr)
				badgeId.Name = "BadgeId"
				
				esuSignOnTimes[plr] = tick()
				
				local ui = script.Gui:Clone()
				ui.MainFrame.rank.Text = plr:GetRankInGroup(16324260) == 5 and 'Emergency Service Unit' or plr:GetRankInGroup(16324260) == 6 and 'Sergeant' or plr:GetRankInGroup(16324260) == 8 and 'Captain' or plr:GetRankInGroup(16324260) == 9 and 'Commander' or plr:GetRankInGroup(32777330) >= 253 and 'Overseer'
				ui.Parent = plr.Character.HumanoidRootPart.RootAttachment
				
				plr.Character:WaitForChild("Humanoid"):UnequipTools()

				badgeId.Value = generateBadgeID()
				
				task.wait()
				
				ui.MainFrame.badge.Text = "[ESU] BADGE ID: "..plr:FindFirstChild("BadgeId").Value

				local data = {

					["content"] = plr.Name.." signed on.".." Badge Id: "..plr:FindFirstChild("BadgeId").Value	

				}

				data = http:JSONEncode(data)
				http:PostAsync(esuHook, data)

				

				for i, v in pairs(plr.Backpack:GetChildren()) do
					if v:IsA("Tool") then
						v:Destroy()
					end
				end
				
				
				
			end
		end
		if chat == "/esusignoff" or chat == "/esuoffduty"  or chat == "/esuoff" and plr.Team == policeTeam and (plr:GetRankInGroup(16324260) == 5 or isInStudio) then
			plr.Neutral = true
			wait()
			
			local Time = tick() - esuSignOnTimes[plr]
			
			local data = {

				["content"] = plr.Name.." signed off |".." Badge Id: "..plr:FindFirstChild("BadgeId").Value.." | Time signed on: "..convertToHMS(Time)

			}

			data = http:JSONEncode(data)
			http:PostAsync(esuHook, data)
			
			esuSignOnTimes[plr] = nil
			plr:FindFirstChild("BadgeId"):Destroy()
			
			plr:LoadCharacter()
		end
		if chat:lower() == "/fbi" and plr:GetRankInGroup(16324260) == 11 or chat:lower() == "/fbi" and isInStudio and not _FBI[plr] or chat:lower() == "/fbi" and plr:IsInGroup(32791156) then
			
			plr.Team = policeTeam
			plr.Character:WaitForChild("HumanoidRootPart").CFrame = workspace.fbiSpawn.CFrame
			
			fbiSignOnTimes[plr] = tick()
			_FBI[plr] = plr
			
			local ui = script.FBI_Gui:Clone()
			ui.Parent = plr.Character:WaitForChild("HumanoidRootPart").RootAttachment
			ui.MainFrame.rank.Text = "(REDACTED)"
			
			for i, v in pairs(plr.Backpack:GetChildren()) do
				if v:IsA("Tool") then
					v:Destroy()
				end
			end
			
			local data = {
				
				["content"] = plr.Name.." started shift!"
				
			}
			
			data = http:JSONEncode(data)
			http:PostAsync(fbihook, data)
		end
		if chat:lower() == "/fbioff" and _FBI[plr] then
			plr.Neutral = true
			task.wait()
			
			local data = {

				["content"] = plr.Name.." ended shift | Time signed on: "..convertToHMS(tick() - fbiSignOnTimes[plr])

			}

			data = http:JSONEncode(data)
			http:PostAsync(fbihook, data)
			
			fbiSignOnTimes[plr] = nil
			_FBI[plr] = nil
			
			plr:LoadCharacter()
		end
		--[[if chat == "/pdgate" or chat == "/gate" and plr.Team == game.Teams.Police or plr:GetRankInGroup(32791156) >= 3 and chat == "/pdgate" or chat == "/gate" then
			if pdGateBool == false then
				pdGateBool = true
				pdGate.Parent = game.ServerStorage.PdgateTemp
				pdGateBlock.Parent = game.ServerStorage.PdgateTemp
			elseif pdGateBool == true then
				pdGateBool = false
				pdGate.Parent = workspace
				pdGateBlock.Parent = workspace
			end
		end--]]
		
		if plr.Team == policeTeam and chat ~= "@everyone" and chat ~= "@here" and chat ~= "/signon" and chat ~= "/onduty" and chat ~= "/nypd" and chat ~= "/signin" and not _FBI[plr] and not esuSignOnTimes[plr] then
			local data = {
				
				["content"] = "``"..plr.Name.." said something: "..chat.."``"
				
			}
			data = http:JSONEncode(data)
			http:PostAsync(allLogsHook, data)
		end
		if _FBI[plr] and chat ~= "@everyone" and chat ~= "@here" and chat ~= "/fbi" then
			local data = {

				["content"] = "``"..plr.Name.." said something: "..chat.."``"

			}
			data = http:JSONEncode(data)
			http:PostAsync(fbihook, data)
		end
		if esuSignOnTimes[plr] and chat ~= "@everyone" and chat ~= "@here" and chat ~= "/esu" then
			local data = {

				["content"] = "``"..plr.Name.." said something: "..chat.."``"

			}
			data = http:JSONEncode(data)
			http:PostAsync(esuHook, data)
		end
	end)
	
	plr.CharacterAdded:Connect(function(char)
		if plr.Team == policeTeam and policeSignOnTimes[plr] then
			
			local ui = script:WaitForChild("Gui"):Clone()
			ui.MainFrame.rank.Text = plr:GetRoleInGroup(16324260)
			ui.MainFrame.badge.Text = "BADGE ID: "..plr:FindFirstChild("BadgeId").Value
			ui.Parent = char:WaitForChild("HumanoidRootPart").RootAttachment
			wait(0.3)
			char:WaitForChild("HumanoidRootPart").CFrame = workspace:WaitForChild("policeSpawnLocation").CFrame

		elseif plr.Team == policeTeam and esuSignOnTimes[plr] then
			local ui = script:WaitForChild("Gui"):Clone()
			ui.MainFrame.rank.Text = "Emergency Service Unit"
			ui.MainFrame.badge.Text = "[ESU] BADGE ID: "..plr:FindFirstChild("BadgeId").Value
			ui.Parent = char:WaitForChild("HumanoidRootPart").RootAttachment
			wait(0.3)
			char:WaitForChild("HumanoidRootPart").CFrame = workspace:WaitForChild("policeSpawnLocation").CFrame
			
		elseif _FBI[plr] then
			
			if not char:WaitForChild("Head"):FindFirstChild("FBI_Gui") then
				local ui = script:WaitForChild("FBI_Gui"):Clone()
				ui.MainFrame.rank.Text = "(REDACTED)"
				ui.Parent = char:WaitForChild("HumanoidRootPart").RootAttachment
				
				for i, v in pairs(plr.Backpack:GetChildren()) do
					if v:IsA("Tool") then
						v:Destroy()
					end
				end
			end
			task.wait(1)
			char:WaitForChild("HumanoidRootPart").CFrame = workspace.fbiSpawn.CFrame
			
		end
		
		char:WaitForChild("Humanoid").Died:Connect(function()
			if plr.Team == game.Teams.Police then
				local data = {

					["content"] = plr.Name.." has died"

				}
				data = http:JSONEncode(data)
				http:PostAsync(allLogsHook, data)
			end
		end)
	end)
end)

game.Players.PlayerRemoving:Connect(function(p)
	if p.Team == game.Teams.Police and policeSignOnTimes[p] then
		local Time = tick() - policeSignOnTimes[p]
		local data = {

			["content"] = p.Name.." left while signed on.".." Badge Id: "..p:FindFirstChild("BadgeId").Value.." | Time signed on: "..convertToHMS(Time)

		}

		data = http:JSONEncode(data)
		http:PostAsync(hook, data)
		
		policeSignOnTimes[p] = nil
	end
	
	if _FBI[p] then
		local Time = tick() - fbiSignOnTimes[p]
		local data = {

			["content"] = p.Name.." left while signed on. | Time signed on: "..convertToHMS(Time)

		}

		data = http:JSONEncode(data)
		http:PostAsync(fbihook, data)

		_FBI[p] = nil
		fbiSignOnTimes[p] = nil
	end
	
	if p.Team == policeTeam and esuSignOnTimes[p] then
		local Time = tick() - esuSignOnTimes[p]
		local data = {

			["content"] = "[ESU] "..p.Name.." left while signed on. Badge Id: "..p:FindFirstChild('BadgeId').Value.." | Time signed on: "..convertToHMS(Time)

		}

		data = http:JSONEncode(data)
		http:PostAsync(hook, data)

		esuSignOnTimes[p] = nil
	end
end)

local Remote = game.ReplicatedStorage:WaitForChild("NYPDRemote");
Remote.OnServerInvoke = function(Player, Action)
	if (Action == "SignIn") then
		DoAction(Player, "signIn")
	elseif (Action == "SignOut") then
		DoAction(Player, "signOut")
	end
end
