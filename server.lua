local playerNames = {}
local joinTimes = {}

CreateThread(function()
	for _, player in pairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(player)
		if xPlayer then
			local vip = exports.fz_dashboard:getVip(xPlayer)
			playerNames[tonumber(player)] = {name = xPlayer.getName(), vip = vip.title}
		end
	end
end)

-- function getPlayerFirstJoin(player)
-- 	local xPlayer = ESX.GetPlayerFromId(player)
-- 	if not xPlayer then
-- 		return
-- 	end

-- 	local result = MySQL.query.await("SELECT firstJoin FROM users WHERE identifier = ?", { xPlayer.identifier })
-- 	return (result and #result > 0) and result[1].firstJoin or 0
-- end
-- exports("getPlayerFirstJoin", getPlayerFirstJoin)

RegisterNetEvent("requestPlayerNames", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local vip = exports.fz_dashboard:getVip(xPlayer)
	playerNames[source] = {name = xPlayer.getName(), vip = vip.title}
	

	TriggerClientEvent("receivePlayerNames", -1, playerNames, joinTimes)
end)

CreateThread(function()
	Wait(1000)

	for _, xPlayer in pairs(ESX.GetExtendedPlayers()) do
		local vip = exports.fz_dashboard:getVip(xPlayer)
		playerNames[xPlayer.source] = {name = xPlayer.getName(), vip = vip.title}


	end

	TriggerClientEvent("receivePlayerNames", -1, playerNames, joinTimes)
end)

AddEventHandler("esx:playerLoaded", function(player, xPlayer)
	local vip = exports.fz_dashboard:getVip(xPlayer)
	playerNames[player] = {name = xPlayer.getName(), vip = vip.title}

	TriggerClientEvent("receivePlayerNames", -1, playerNames, joinTimes)
end)
