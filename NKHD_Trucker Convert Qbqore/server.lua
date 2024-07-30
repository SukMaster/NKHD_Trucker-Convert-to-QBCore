local QBCore = exports['qb-core']:GetCoreObject()

local function checkAndAddPlayer(identifier)
    MySQL.Async.fetchScalar('SELECT COUNT(*) FROM player_truckerxp WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result == 0 then
            MySQL.Async.execute('INSERT INTO player_truckerxp (identifier, truckerxp) VALUES (@identifier, @truckerxp)', {
                ['@identifier'] = identifier,
                ['@truckerxp'] = 0 
            })
        end
    end)
end

RegisterServerEvent('nkhd_trucker:pay')
AddEventHandler('nkhd_trucker:pay', function(amount, amountxp)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    MySQL.Async.fetchScalar('SELECT truckerxp FROM player_truckerxp WHERE identifier = @identifier', {
        ['@identifier'] = Player.PlayerData.citizenid
    }, function(truckerxp)
        local newTruckerXP = truckerxp + amountxp

        MySQL.Async.execute('UPDATE player_truckerxp SET truckerxp = @truckerxp WHERE identifier = @identifier', {
            ['@truckerxp'] = newTruckerXP,
            ['@identifier'] = Player.PlayerData.citizenid
        })

        Player.Functions.AddMoney('cash', amount)
    end)
end)

RegisterServerEvent('nkhd_trucker:getTruckerXP')
AddEventHandler('nkhd_trucker:getTruckerXP', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    MySQL.Async.fetchScalar('SELECT truckerxp FROM player_truckerxp WHERE identifier = @identifier', {
        ['@identifier'] = Player.PlayerData.citizenid
    }, function(truckerxp)
        if truckerxp then
            TriggerClientEvent('nkhd_trucker:TruckerXP', src, truckerxp)
        end
    end)
end)

local function syncPlayersWithDatabase()
    local players = QBCore.Functions.GetPlayers()

    for _, playerId in ipairs(players) do
        local Player = QBCore.Functions.GetPlayer(playerId)

        if Player then
            checkAndAddPlayer(Player.PlayerData.citizenid)
        end
    end
end

AddEventHandler('onServerResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        syncPlayersWithDatabase()
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(600000) 
        syncPlayersWithDatabase()
    end
end)
