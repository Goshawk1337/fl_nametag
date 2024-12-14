local playerNames = {}
local newbiePlayers = {}
local streamedPlayers = {}
local nameThread = false
local myName = true
local namesVisible = true

local localPed = nil

local txd = CreateRuntimeTxd("adminsystem")
local tx = CreateRuntimeTextureFromImage(txd, "logo", "assets/logo.png")

RegisterCommand("names", function()
	setNamesVisible(not namesVisible)
end)

RegisterCommand("togmyname", function()
	myName = not myName
end)

AddEventHandler("esx_skin:playerRegistered", function()
	Wait(1000)
	TriggerServerEvent("requestPlayerNames")
end)

RegisterNetEvent("receivePlayerNames", function(names, newbies)
	playerNames = names
	newbiePlayers = newbies
end)

function playerStreamer()
	while namesVisible do
		streamedPlayers = {}
		localPed = PlayerPedId()

		local localCoords <const> = GetEntityCoords(localPed)
		local localId <const> = PlayerId()

		for _, player in pairs(GetActivePlayers()) do
			local playerPed <const> = GetPlayerPed(player)

			if player == localId and myName or player ~= localId then
				if DoesEntityExist(playerPed) and HasEntityClearLosToEntity(localPed, playerPed, 17) and IsEntityVisible(playerPed) then
					local playerCoords = GetEntityCoords(playerPed)
					if IsSphereVisible(playerCoords, 0.0099999998) then
						local distance <const> = #(localCoords - playerCoords)

						local serverId <const> = tonumber(GetPlayerServerId(player))
						if serverId and distance <= STREAM_DISTANCE and playerNames[serverId] then

							local label = (playerNames[serverId].name or "")
							
							label = label .. " [" .. serverId .. "]"
							if playerNames[serverId].vip ~= nil then
								label =  " ~h~ ~o~[" .. playerNames[serverId].vip .. "] ~w~" .. label
							else
								label =   label

							end	

							streamedPlayers[serverId] = {
								playerId = player,
								ped = playerPed,
								label = label,
							}
						end
					end
				end
			end
		end

		if next(streamedPlayers) and not nameThread then
			CreateThread(drawNames)
		end

		Wait(500)
	end

	streamedPlayers = {}
end
CreateThread(playerStreamer)

function drawNames()
	nameThread = true

	while next(streamedPlayers) do
		local myCoords <const> = GetEntityCoords(localPed)

		for serverId, playerData in pairs(streamedPlayers) do
			local coords <const> = getPedHeadCoords(playerData.ped)

			local dist <const> = #(coords - myCoords)
			local scale <const> = 1 - dist / STREAM_DISTANCE

			if scale > 0 then
				local newbieVisible <const> = (playerData.newbie and not playerData.adminDuty)

				DrawText3D(coords, {
					{ text = playerData.label, color = { 255, 255, 255 } },
					nil,
					nil,
				}, scale, 255)

				
			end
		end

		Wait(0)
	end

	nameThread = false
end


function setMyNameVisible(state)
	myName = state
end
exports("setMyNameVisible", setMyNameVisible)

function getMyNameVisible()
	return myName
end
exports("getMyNameVisible", getMyNameVisible)

function setNamesVisible(state)
	namesVisible = state
	if namesVisible then
		CreateThread(playerStreamer)
	end
end
exports("setNamesVisible", setNamesVisible)

exports("isNamesVisible", function()
	return namesVisible
end)