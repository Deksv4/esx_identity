local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

function getIdentity(source, callback)
	local user_id = vRP.getUserId({source})

	MySQL.Async.fetchAll("SELECT * FROM vrp_user_identities WHERE user_id = @user_Id", {user_id = user_id}, function(result)
		if result[1].firstname ~= nil then
			local data = {
				user_id		= result[1].user_id,
				firstname	= result[1].firstname,
				lastname	= result[1].name,
				age 		= result[1].age
			}
			callback(data)
		else
			local data = {
				user_id		= '',
				firstname	= '',
				lastname	= '',
				age 		= ''
			}
			
			callback(data)
		end
	end)
end

function setIdentity(user_id, data, callback)
	MySQL.Async.execute("UPDATE `vrp_user_identities` SET `firstname` = @firstname, `name` = @lastname, `age` = @age WHERE user_id = @user_id",
	{
		['@user_id']		= user_id,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@age']			= data.age,
	}, function(done)
		if callback then
			callback(true)
		end
	end)
end

function updateIdentity(identifier, data, callback)
	MySQL.Async.execute("UPDATE `vrp_user_identities` SET `firstname` = @firstname, `name` = @lastname, `age` = @age WHERE user_id = @user_id",
	{['@user_id'] = user_id, ['@firstname']	= data.firstname, ['@lastname']	= data.lastname, ['@age'] = data.age}, 
	function(done)
		if callback then
			callback(true)
		end
	end)
end

RegisterServerEvent('esx_identity:setIdentity')
AddEventHandler('esx_identity:setIdentity', function(data, myIdentifiers)
	setIdentity(myIdentifiers.user_id, data, function(callback)
		if callback then
			TriggerClientEvent('esx_identity:identityCheck', myIdentifiers.playerid, true)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^[IDENTITY]', 'Failed to set character, try again later or contact the server admin!' } })
		end
	end)
end)

AddEventHandler('vRP:playerSpawn', function(source)
	local myID = {
		steamid = vRP.getUserId({source}),
		playerid = source
	}
	
	TriggerClientEvent('esx_identity:saveID', source, myID)
	getIdentity(source, function(data)
		if data.firstname == '' then
			TriggerClientEvent('esx_identity:identityCheck', source, false)
			TriggerClientEvent('esx_identity:showRegisterIdentity', source)
		else
			TriggerClientEvent('esx_identity:identityCheck', source, true)
		end
	end)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(3000)
		
		-- Set all the client side variables for connected users one new time
		local xPlayers = vRP.getUsers({})
		for i=1, #xPlayers, 1 do
		
			local xPlayer = vRP.getUserId({xPlayers[i]})
			
			local myID = {
				steamid  = GetPlayerIdentifiers(source)[1],
				playerid = vRP.getUserSource({xPlayer})
			}
			
			TriggerClientEvent('esx_identity:saveID', vRP.getUserSource({xPlayer}), myID)
			
			getIdentity(vRP.getUserSource({xPlayer}), function(data)
				if data.firstname == '' then
					TriggerClientEvent('esx_identity:identityCheck', vRP.getUserSource({xPlayer}), false)
					TriggerClientEvent('esx_identity:showRegisterIdentity', vRP.getUserSource({xPlayer}))
				else
					TriggerClientEvent('esx_identity:identityCheck', vRP.getUserSource({xPlayer}), true)
				end
			end)
		end
	end
end)