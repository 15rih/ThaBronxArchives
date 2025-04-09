local honeypots = {
	game.ReplicatedStorage.InflictTargetDamage,
	game.ReplicatedStorage.AdminPanelAction,
	game.ReplicatedStorage.Money.CashCheck
}

local cache = require(game.ServerScriptService.ProfileCache)

local uses = {}

for i,v in pairs(honeypots) do
	
	local lolName = v.Name
	v.OnServerEvent:Connect(function(player)
		if lolName == "CashCheck" then
			if not cache[player].Data.poisoned and not uses[player] then
				uses[player] = true
				game.ReplicatedStorage.server:FireClient(player,"money","+$250")
				player.stored.Money.Value += 250
			else
				game.ReplicatedStorage.server:FireClient(player,"money","+$1,250")
			end
		end
		if not cache[player].Data.poisoned then
			cache[player].Data.poisoned = true
			game.ReplicatedStorage.SendEmbed:Fire("exploitLog2",`**{player.Name} {player.UserId}** has fallen for **{lolName}** honeypot`)
		end	
	end)
	
end
