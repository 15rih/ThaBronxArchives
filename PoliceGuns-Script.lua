local Folder = script.Parent

local Groups = {};
local GroupService = game:GetService("GroupService");

local DesiredGroup = 16324260

local DesiredToolRanks = {
	["Remington"] = {"SGT", "LT"};
	["AR15"] = {"LT"};
};

--Easier Way
local Ranks = {}; do 
	setmetatable(Ranks, {
		__index = function(self, key)
			key = tonumber(key)
			if (not key) then
				if (DesiredToolRanks[key]) then
					return DesiredToolRanks[key]
				end
				
				return false
			end
			
			if (key <= 1) then
				return "Suspended"
			end
			
			if (key > 1 and key < 8) then
				return "Clearance"
			elseif (key == 8) then
				return "SGT"
			elseif (key >= 9) then
				return "LT"
			end
		end,
	})
end

local function GiveTool(Player, Name)
	if (Player.Backpack:FindFirstChild(Name)) then
		return
	end
	
	local Tool = game.ServerStorage:FindFirstChild(Name);
	if (Tool) then
		Tool:Clone().Parent = Player.Backpack
	end
end

local function Setup(Crate)
	local ClickDetector = Crate:FindFirstChild("ClickDetector") or Crate:WaitForChild("ClickDetector", 4);
	if (not ClickDetector) then
		return
	end
	
	local Script = ClickDetector:FindFirstChild("Script") or ClickDetector:WaitForChild("Script", 4);
	if (Script) then
		Script.Enabled = false
		Script:Destroy()
	end
	
	local ToolValue = Crate:WaitForChild("ToolValue");
	ClickDetector.MouseClick:Connect(function(Player)
		local GroupRank = Groups[Player] or Player:GetRankInGroup(DesiredGroup);
		Groups[Player] = GroupRank
		
		task.delay(3, function()
			Groups[Player] = nil --Allow it to reset after to 3 seconds that way they don't have to rejoin if they get ranked up
		end)
		
		local Rank = Ranks[GroupRank];
		if (Rank) then
			if (Rank == "Suspended") then
				return
			end
			
			local Data = Ranks[ToolValue.Value];
			if (Data) then
				if (Data[Rank]) then
					GiveTool(Player, ToolValue.Value)
				end
			else
				if (Rank == "Clearance") then
					GiveTool(Player, ToolValue.Value)
				end
			end
		end
	end)
end
