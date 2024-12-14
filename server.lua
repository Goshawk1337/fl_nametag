local playerNames = {}
local joinTimes = {}

CreateThread(function()
	for _, player in pairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(player)
		if xPlayer then
			local vip = exports.fz_dashboard:getVip(xPlayer)
			if vip ~= nil then 	
				playerNames[tonumber(player)] = {name = xPlayer.getName(), vip = vip.title}
			else
				playerNames[tonumber(player)] = {name = xPlayer.getName(), vip = nil}

			end
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
	if vip ~= nil then 	
		playerNames[source] = {name = xPlayer.getName(), vip = vip.title}
	else
		playerNames[source] = {name = xPlayer.getName(), vip = nil}

	end

	TriggerClientEvent("receivePlayerNames", -1, playerNames, joinTimes)
end)

CreateThread(function()
	Wait(1000)

	for _, xPlayer in pairs(ESX.GetExtendedPlayers()) do
		local vip = exports.fz_dashboard:getVip(xPlayer)
		if vip ~= nil then 	
			playerNames[xPlayer.source] = {name = xPlayer.getName(), vip = vip.title}
		else
			playerNames[xPlayer.source] = {name = xPlayer.getName(), vip = nil}

		end


	end

	TriggerClientEvent("receivePlayerNames", -1, playerNames, joinTimes)
end)

AddEventHandler("esx:playerLoaded", function(player, xPlayer)
	local vip = exports.fz_dashboard:getVip(xPlayer)
	if vip ~= nil then 	
		playerNames[player] = {name = xPlayer.getName(), vip = vip.title}
	else
		playerNames[player] = {name = xPlayer.getName(), vip = nil}

	end

	TriggerClientEvent("receivePlayerNames", -1, playerNames, joinTimes)
end)
