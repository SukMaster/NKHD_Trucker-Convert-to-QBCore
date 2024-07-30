local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}

Citizen.CreateThread(function()
    while QBCore == nil do
        QBCore = exports['qb-core']:GetCoreObject()
        Citizen.Wait(0)
    end

    while QBCore.Functions.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = QBCore.Functions.GetPlayerData()
end)

-- Fungsi untuk menambahkan blip
function AddBlip(coords, name, color, sprite)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- Contoh koordinat dan detail blip
local blipCoords = vector3(-456.8723, -2753.6316, 6.0002)  -- Ubah koordinat sesuai kebutuhan
local blipName = "Kargo"
local blipColor = 5  -- Ubah warna sesuai kebutuhan (contoh: 3 = merah)
local blipSprite = 477  -- Ubah sprite sesuai kebutuhan (contoh: 1 = rumah)

-- Tambahkan blip ke peta
AddBlip(blipCoords, blipName, blipColor, blipSprite)

--local truckerPoint = vector3(1199.2227, -3250.5273, 7.0952)
--local inMarker = false

local notificationShown = false -- Variabel untuk melacak status notifikasi

local xp = 0

function OpenTruckerMenu()
    TriggerServerEvent('nkhd_trucker:getTruckerXP')
end

RegisterNetEvent('nkhd_trucker:TruckerXP')
AddEventHandler('nkhd_trucker:TruckerXP', function(truckerxp)
    xp = truckerxp
    OpenTruckerMenu2()
end)

function OpenTruckerMenu2()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openTruckerMenu",
        xp = xp
    })
end

RegisterNUICallback('selectRoute', function(data, cb)
    local route = data.route
    local useOwnTruck = data.useOwnTruck

    if useOwnTruck then
        QBCore.Functions.Notify('You are using your own truck.', 'info')
    else
        if route == "short" then
            if xp >= Config.ShortRouteXPneeded then
                if Config.English == false then
                    QBCore.Functions.Notify('Du leihst einen LKW aus.', 'info')
                    QBCore.Functions.Notify('Du hast die Route ' .. route .. ' ausgewählt.', 'info')
                else
                    QBCore.Functions.Notify('You are renting a truck.', 'info')
                    QBCore.Functions.Notify('You have selected the route ' .. route .. '.', 'info')
                end
                SetNuiFocus(false, false)
                cb('ok')
                Shortroute()
            else
                if Config.English == false then
                    QBCore.Functions.Notify('~r~Du hast nicht genügend XP', 'error')
                else
                    QBCore.Functions.Notify('~r~You do not have enough XP', 'error')
                end
            end
        elseif route == "middle" then
            if xp >= Config.MiddleRouteXPneeded then
                if Config.English == false then
                    QBCore.Functions.Notify('Du leihst einen LKW aus.', 'info')
                    QBCore.Functions.Notify('Du hast die Route ' .. route .. ' ausgewählt.', 'info')
                else
                    QBCore.Functions.Notify('You are renting a truck.', 'info')
                    QBCore.Functions.Notify('You have selected the route ' .. route .. '.', 'info')
                end
                SetNuiFocus(false, false)
                cb('ok')
                Middleroute()
            else
                if Config.English == false then
                    QBCore.Functions.Notify('~r~Du hast nicht genügend XP', 'error')
                else
                    QBCore.Functions.Notify('~r~You do not have enough XP', 'error')
                end
            end
        elseif route == "long" then
            if xp >= Config.LongRouteXPneeded then
                if Config.English == false then
                    QBCore.Functions.Notify('Du leihst einen LKW aus.', 'info')
                    QBCore.Functions.Notify('Du hast die Route ' .. route .. ' ausgewählt.', 'info')
                else
                    QBCore.Functions.Notify('You are renting a truck.', 'info')
                    QBCore.Functions.Notify('You have selected the route ' .. route .. '.', 'info')
                end
                SetNuiFocus(false, false)
                cb('ok')
                Longroute()
            else
                if Config.English == false then
                    QBCore.Functions.Notify('~r~Du hast nicht genügend XP', 'error')
                else
                    QBCore.Functions.Notify('~r~You do not have enough XP', 'error')
                end
            end
        elseif route == "cayo" then
            if xp >= Config.CayoRouteXPneeded then
                if Config.English == false then
                    QBCore.Functions.Notify('Du leihst einen LKW aus.', 'info')
                    QBCore.Functions.Notify('Du hast die Route ' .. route .. ' ausgewählt.', 'info')
                else
                    QBCore.Functions.Notify('You are renting a truck.', 'info')
                    QBCore.Functions.Notify('You have selected the route ' .. route .. '.', 'info')
                end
                SetNuiFocus(false, false)
                cb('ok')
                Cayoroute()
            else
                if Config.English == false then
                    QBCore.Functions.Notify('~r~Du hast nicht genügend XP', 'error')
                else
                    QBCore.Functions.Notify('~r~You do not have enough XP', 'error')
                end
            end
        end
    end

    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- rute kota
function Shortroute()
    local haulerModelHash = "hauler"
    local trailerModelHash = "trailers2" -- Ganti dengan model trailer yang sesuai
    local blip = nil  -- Variabel untuk menyimpan blip

    -- Memastikan model hauler dan trailer terpasang
    if not IsModelInCdimage(haulerModelHash) or not IsModelInCdimage(trailerModelHash) then return end
    RequestModel(haulerModelHash)
    RequestModel(trailerModelHash)
    
    while not HasModelLoaded(haulerModelHash) or not HasModelLoaded(trailerModelHash) do
        Wait(0)
    end

    local x = -427.7141
    local y = -2716.2659
    local z = 6.0002
    local heading = 223.8048

    -- Membuat hauler
    local hauler = CreateVehicle(haulerModelHash, x, y, z, heading, true, false)
    -- Membuat trailer
    local trailer = CreateVehicle(trailerModelHash, x, y, z, heading, true, false)
    
    -- Menempelkan trailer ke hauler
    AttachVehicleToTrailer(hauler, trailer, 0.0)

    -- Menempatkan pemain ke dalam hauler
    local playerPed = PlayerPedId()
    TaskWarpPedIntoVehicle(playerPed, hauler, -1)

    -- Fungsi untuk membuat blip
    local function createBlip(x, y, z, color)
        if blip then
            RemoveBlip(blip)  -- Hapus blip sebelumnya jika ada
        end
        blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(blip, 1)  -- Pilih sprite blip yang sesuai
        SetBlipColour(blip, 5)  -- Ubah warna blip
        SetBlipScale(blip, 1.0)
        SetBlipRoute(blip, true)
    end

    -- Set blip untuk tujuan pemuatan
    createBlip(-59.1816, -1745.9379, 29.3488, 2)  -- Warna kuning untuk tujuan pemuatan

    local shortPoint = vector3(-59.1816, -1745.9379, 29.3488) 
    local shortPoint2 = vector3(-708.0349, -923.3867, 19.0139) 
    local Depot = vector3(-367.1936, -2661.5593, 6.0003) 

    local notloaded = true
    local Loaded = false
    local inJob = false

    while notloaded do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, shortPoint, true)
        
        if distance < 25.0 then
            DrawMarker(1, shortPoint.x, shortPoint.y, shortPoint.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zu beladen")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to load the truck")
                end
                if IsControlJustReleased(0, 38) then
                    if Config.English == false then
                        exports['progressBars']:startUI(10000, "Belade den Truck")
                    else
                        exports['progressBars']:startUI(10000, "Loading the truck")
                    end
                    Citizen.Wait(10000)
                    if Config.English == false then
                        ShowNotification('~g~Du hast den LKW Beladen.')
                    else
                        ShowNotification('~g~You have loaded the truck.')
                    end
                    notloaded = false
                    Loaded = true
                    if Config.English == false then
                        QBCore.Functions.Notify("Bringe die Ladung zum Ziel.", "success")
                    else
                        QBCore.Functions.Notify("Bring the cargo to the destination.", "success")
                    end
                    -- Hapus waypoint dan buat blip untuk tujuan
                    createBlip(-708.0349, -923.3867, 19.0139, 2)  -- Warna kuning untuk tujuan pengiriman
                end
            end
        end
    end

    while Loaded do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, shortPoint2, true)

        if distance < 25.0 then
            DrawMarker(1, shortPoint2.x, shortPoint2.y, shortPoint2.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zu entladen")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to unload the truck")
                end
                if IsControlJustReleased(0, 38) then
                    if Config.English == false then
                        exports['progressBars']:startUI(10000, "Entlade den Truck")
                    else
                        exports['progressBars']:startUI(10000, "Unload the truck")
                    end                            
                    Citizen.Wait(10000)
                    if Config.English == false then
                        ShowNotification('~g~Du hast den LKW entladen.')
                        ShowNotification('Bringe den LKW zum Depot.')
                    else
                        ShowNotification('~g~You have unloaded the truck.')
                        ShowNotification('Take the truck back to the depot.')
                    end                            
                    Loaded = false
                    inJob = true
                    -- Hapus waypoint dan buat blip untuk depot
                    createBlip(-367.1936, -2661.5593, 6.0003, 2)  -- Warna kuning untuk depot
                end
            end
        end
    end

    while inJob do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, Depot, true)
        local amount = Config.MoneyShort
        local amountxp = Config.XPShort
        
        if distance < 25.0 then
            DrawMarker(1, Depot.x, Depot.y, Depot.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zurück zu geben")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to return the truck")
                end                        
                if IsControlJustReleased(0, 38) then
                    -- Mengecek apakah trailer masih terpasang
                    local trailerAttached = IsVehicleAttachedToTrailer(hauler)
                    if trailerAttached then
                        if Config.English == false then
                            exports['progressBars']:startUI(10000, "Gebe den Truck zurück.")
                        else
                            exports['progressBars']:startUI(10000, "Returning the truck.")
                        end                            
                        Citizen.Wait(10000)
                        if Config.English == false then
                            ShowNotification('~b~Du hast ' ..amount.. '$ bekommen und ' ..amountxp..' Job XP')
                            ShowNotification('~g~Du hast den LKW zurück gegeben.')
                        else
                            ShowNotification('~b~You received ' ..amount.. '$ and ' ..amountxp..' Job XP')
                            ShowNotification('~g~You have returned the truck.')
                        end                            
                        TriggerServerEvent('nkhd_trucker:pay', amount, amountxp)
                    else
                        if Config.English == false then
                            ShowNotification('~r~Du musst den LKW mit dem Trailer zurückgeben, um bezahlt zu werden.')
                        else
                            ShowNotification('~r~You must return the truck with the trailer to get paid.')
                        end
                    end
                    inJob = false
                    -- Menghapus kendaraan setelah pekerjaan selesai
                    SetEntityAsMissionEntity(hauler, true, true)
                    DeleteVehicle(hauler)
                    SetEntityAsMissionEntity(trailer, true, true)
                    DeleteVehicle(trailer)
                    RemoveBlip(blip)  -- Hapus blip setelah pekerjaan selesai
                end
            end
        end
    end
end

-- rute ss
function Middleroute()
    local haulerModelHash = "hauler"
    local trailerModelHash = "trailers2" -- Ganti dengan model trailer yang sesuai
    local blip = nil  -- Variabel untuk menyimpan blip

    -- Memastikan model hauler dan trailer terpasang
    if not IsModelInCdimage(haulerModelHash) or not IsModelInCdimage(trailerModelHash) then return end
    RequestModel(haulerModelHash)
    RequestModel(trailerModelHash)
    
    while not HasModelLoaded(haulerModelHash) or not HasModelLoaded(trailerModelHash) do
        Wait(0)
    end

    local x = -427.7141
    local y = -2716.2659
    local z = 6.0002
    local heading = 223.8048

    -- Membuat hauler
    local hauler = CreateVehicle(haulerModelHash, x, y, z, heading, true, false)
    -- Membuat trailer
    local trailer = CreateVehicle(trailerModelHash, x, y, z, heading, true, false)
    
    -- Menempelkan trailer ke hauler
    AttachVehicleToTrailer(hauler, trailer, 0.0)

    -- Menempatkan pemain ke dalam hauler
    local playerPed = PlayerPedId()
    TaskWarpPedIntoVehicle(playerPed, hauler, -1)

    -- Fungsi untuk membuat blip
    local function createBlip(x, y, z, color)
        if blip then
            RemoveBlip(blip)  -- Hapus blip sebelumnya jika ada
        end
        blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(blip, 1)  -- Pilih sprite blip yang sesuai
        SetBlipColour(blip, 5)  -- Ubah warna blip
        SetBlipScale(blip, 1.0)
        SetBlipRoute(blip, true)
    end

    -- Set blip untuk tujuan pemuatan
    createBlip(2565.4290, 377.9061, 108.4632, 2)  -- Warna kuning untuk tujuan pemuatan

    local shortPoint = vector3(2565.4290, 377.9061, 108.4632) 
    local shortPoint2 = vector3(549.4739, 2678.5344, 42.1174) 
    local Depot = vector3(-367.1936, -2661.5593, 6.0003) 

    local notloaded = true
    local Loaded = false
    local inJob = false

    while notloaded do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, shortPoint, true)
        
        if distance < 25.0 then
            DrawMarker(1, shortPoint.x, shortPoint.y, shortPoint.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zu beladen")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to load the truck")
                end
                if IsControlJustReleased(0, 38) then
                    if Config.English == false then
                        exports['progressBars']:startUI(10000, "Belade den Truck")
                    else
                        exports['progressBars']:startUI(10000, "Loading the truck")
                    end
                    Citizen.Wait(10000)
                    if Config.English == false then
                        ShowNotification('~g~Du hast den LKW Beladen.')
                    else
                        ShowNotification('~g~You have loaded the truck.')
                    end
                    notloaded = false
                    Loaded = true
                    if Config.English == false then
                        QBCore.Functions.Notify("Bringe die Ladung zum Ziel.", "success")
                    else
                        QBCore.Functions.Notify("Bring the cargo to the destination.", "success")
                    end
                    -- Hapus waypoint dan buat blip untuk tujuan
                    createBlip(549.4739, 2678.5344, 42.1174, 2)  -- Warna kuning untuk tujuan pengiriman
                end
            end
        end
    end

    while Loaded do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, shortPoint2, true)

        if distance < 25.0 then
            DrawMarker(1, shortPoint2.x, shortPoint2.y, shortPoint2.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zu entladen")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to unload the truck")
                end
                if IsControlJustReleased(0, 38) then
                    if Config.English == false then
                        exports['progressBars']:startUI(10000, "Entlade den Truck")
                    else
                        exports['progressBars']:startUI(10000, "Unload the truck")
                    end                            
                    Citizen.Wait(10000)
                    if Config.English == false then
                        ShowNotification('~g~Du hast den LKW entladen.')
                        ShowNotification('Bringe den LKW zum Depot.')
                    else
                        ShowNotification('~g~You have unloaded the truck.')
                        ShowNotification('Take the truck back to the depot.')
                    end                            
                    Loaded = false
                    inJob = true
                    -- Hapus waypoint dan buat blip untuk depot
                    createBlip(-367.1936, -2661.5593, 6.0003, 2)  -- Warna kuning untuk depot
                end
            end
        end
    end

    while inJob do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, Depot, true)
        local amount = Config.MoneyMiddle
        local amountxp = Config.XPMiddle
        
        if distance < 25.0 then
            DrawMarker(1, Depot.x, Depot.y, Depot.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zurück zu geben")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to return the truck")
                end                        
                if IsControlJustReleased(0, 38) then
                    -- Mengecek apakah trailer masih terpasang
                    local trailerAttached = IsVehicleAttachedToTrailer(hauler)
                    if trailerAttached then
                        if Config.English == false then
                            exports['progressBars']:startUI(10000, "Gebe den Truck zurück.")
                        else
                            exports['progressBars']:startUI(10000, "Returning the truck.")
                        end                            
                        Citizen.Wait(10000)
                        if Config.English == false then
                            ShowNotification('~b~Du hast ' ..amount.. '$ bekommen und ' ..amountxp..' Job XP')
                            ShowNotification('~g~Du hast den LKW zurück gegeben.')
                        else
                            ShowNotification('~b~You received ' ..amount.. '$ and ' ..amountxp..' Job XP')
                            ShowNotification('~g~You have returned the truck.')
                        end                            
                        TriggerServerEvent('nkhd_trucker:pay', amount, amountxp)
                    else
                        if Config.English == false then
                            ShowNotification('~r~Du musst den LKW mit dem Trailer zurückgeben, um bezahlt zu werden.')
                        else
                            ShowNotification('~r~You must return the truck with the trailer to get paid.')
                        end
                    end
                    inJob = false
                    -- Menghapus kendaraan setelah pekerjaan selesai
                    SetEntityAsMissionEntity(hauler, true, true)
                    DeleteVehicle(hauler)
                    SetEntityAsMissionEntity(trailer, true, true)
                    DeleteVehicle(trailer)
                    RemoveBlip(blip)  -- Hapus blip setelah pekerjaan selesai
                end
            end
        end
    end
end

-- rute paleto
function Longroute()
    local haulerModelHash = "hauler"
    local trailerModelHash = "trailers2" -- Ganti dengan model trailer yang sesuai
    local blip = nil  -- Variabel untuk menyimpan blip

    -- Memastikan model hauler dan trailer terpasang
    if not IsModelInCdimage(haulerModelHash) or not IsModelInCdimage(trailerModelHash) then return end
    RequestModel(haulerModelHash)
    RequestModel(trailerModelHash)
    
    while not HasModelLoaded(haulerModelHash) or not HasModelLoaded(trailerModelHash) do
        Wait(0)
    end

    local x = -427.7141
    local y = -2716.2659
    local z = 6.0002
    local heading = 223.8048

    -- Membuat hauler
    local hauler = CreateVehicle(haulerModelHash, x, y, z, heading, true, false)
    -- Membuat trailer
    local trailer = CreateVehicle(trailerModelHash, x, y, z, heading, true, false)
    
    -- Menempelkan trailer ke hauler
    AttachVehicleToTrailer(hauler, trailer, 0.0)

    -- Menempatkan pemain ke dalam hauler
    local playerPed = PlayerPedId()
    TaskWarpPedIntoVehicle(playerPed, hauler, -1)

    -- Fungsi untuk membuat blip
    local function createBlip(x, y, z, color)
        if blip then
            RemoveBlip(blip)  -- Hapus blip sebelumnya jika ada
        end
        blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(blip, 1)  -- Pilih sprite blip yang sesuai
        SetBlipColour(blip, 5)  -- Ubah warna blip
        SetBlipScale(blip, 1.0)
        SetBlipRoute(blip, true)
    end

    -- Set blip untuk tujuan pemuatan
    createBlip(-3234.9102, 1000.2996, 12.3454, 2)  -- Warna kuning untuk tujuan pemuatan

    local shortPoint = vector3(-3234.9102, 1000.2996, 12.3454) 
    local shortPoint2 = vector3(1730.3840, 6404.4331, 34.5518) 
    local Depot = vector3(-367.1936, -2661.5593, 6.0003) 

    local notloaded = true
    local Loaded = false
    local inJob = false

    while notloaded do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, shortPoint, true)
        
        if distance < 25.0 then
            DrawMarker(1, shortPoint.x, shortPoint.y, shortPoint.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zu beladen")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to load the truck")
                end
                if IsControlJustReleased(0, 38) then
                    if Config.English == false then
                        exports['progressBars']:startUI(10000, "Belade den Truck")
                    else
                        exports['progressBars']:startUI(10000, "Loading the truck")
                    end
                    Citizen.Wait(10000)
                    if Config.English == false then
                        ShowNotification('~g~Du hast den LKW Beladen.')
                    else
                        ShowNotification('~g~You have loaded the truck.')
                    end
                    notloaded = false
                    Loaded = true
                    if Config.English == false then
                        QBCore.Functions.Notify("Bringe die Ladung zum Ziel.", "success")
                    else
                        QBCore.Functions.Notify("Bring the cargo to the destination.", "success")
                    end
                    -- Hapus waypoint dan buat blip untuk tujuan
                    createBlip(1730.3840, 6404.4331, 34.5518, 2)  -- Warna kuning untuk tujuan pengiriman
                end
            end
        end
    end

    while Loaded do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, shortPoint2, true)

        if distance < 25.0 then
            DrawMarker(1, shortPoint2.x, shortPoint2.y, shortPoint2.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zu entladen")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to unload the truck")
                end
                if IsControlJustReleased(0, 38) then
                    if Config.English == false then
                        exports['progressBars']:startUI(10000, "Entlade den Truck")
                    else
                        exports['progressBars']:startUI(10000, "Unload the truck")
                    end                            
                    Citizen.Wait(10000)
                    if Config.English == false then
                        ShowNotification('~g~Du hast den LKW entladen.')
                        ShowNotification('Bringe den LKW zum Depot.')
                    else
                        ShowNotification('~g~You have unloaded the truck.')
                        ShowNotification('Take the truck back to the depot.')
                    end                            
                    Loaded = false
                    inJob = true
                    -- Hapus waypoint dan buat blip untuk depot
                    createBlip(-367.1936, -2661.5593, 6.0003, 2)  -- Warna kuning untuk depot
                end
            end
        end
    end

    while inJob do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, Depot, true)
        local amount = Config.MoneyLong
        local amountxp = Config.XPLong
        
        if distance < 25.0 then
            DrawMarker(1, Depot.x, Depot.y, Depot.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zurück zu geben")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to return the truck")
                end                        
                if IsControlJustReleased(0, 38) then
                    -- Mengecek apakah trailer masih terpasang
                    local trailerAttached = IsVehicleAttachedToTrailer(hauler)
                    if trailerAttached then
                        if Config.English == false then
                            exports['progressBars']:startUI(10000, "Gebe den Truck zurück.")
                        else
                            exports['progressBars']:startUI(10000, "Returning the truck.")
                        end                            
                        Citizen.Wait(10000)
                        if Config.English == false then
                            ShowNotification('~b~Du hast ' ..amount.. '$ bekommen und ' ..amountxp..' Job XP')
                            ShowNotification('~g~Du hast den LKW zurück gegeben.')
                        else
                            ShowNotification('~b~You received ' ..amount.. '$ and ' ..amountxp..' Job XP')
                            ShowNotification('~g~You have returned the truck.')
                        end                            
                        TriggerServerEvent('nkhd_trucker:pay', amount, amountxp)
                    else
                        if Config.English == false then
                            ShowNotification('~r~Du musst den LKW mit dem Trailer zurückgeben, um bezahlt zu werden.')
                        else
                            ShowNotification('~r~You must return the truck with the trailer to get paid.')
                        end
                    end
                    inJob = false
                    -- Menghapus kendaraan setelah pekerjaan selesai
                    SetEntityAsMissionEntity(hauler, true, true)
                    DeleteVehicle(hauler)
                    SetEntityAsMissionEntity(trailer, true, true)
                    DeleteVehicle(trailer)
                    RemoveBlip(blip)  -- Hapus blip setelah pekerjaan selesai
                end
            end
        end
    end
end

-- rute cayo
function Cayoroute()
    local haulerModelHash = "hauler"
    local trailerModelHash = "trailers2" -- Ganti dengan model trailer yang sesuai
    local blip = nil  -- Variabel untuk menyimpan blip

    -- Memastikan model hauler dan trailer terpasang
    if not IsModelInCdimage(haulerModelHash) or not IsModelInCdimage(trailerModelHash) then return end
    RequestModel(haulerModelHash)
    RequestModel(trailerModelHash)
    
    while not HasModelLoaded(haulerModelHash) or not HasModelLoaded(trailerModelHash) do
        Wait(0)
    end

    local x = -427.7141
    local y = -2716.2659
    local z = 6.0002
    local heading = 223.8048

    -- Membuat hauler
    local hauler = CreateVehicle(haulerModelHash, x, y, z, heading, true, false)
    -- Membuat trailer
    local trailer = CreateVehicle(trailerModelHash, x, y, z, heading, true, false)
    
    -- Menempelkan trailer ke hauler
    AttachVehicleToTrailer(hauler, trailer, 0.0)

    -- Menempatkan pemain ke dalam hauler
    local playerPed = PlayerPedId()
    TaskWarpPedIntoVehicle(playerPed, hauler, -1)

    -- Fungsi untuk membuat blip
    local function createBlip(x, y, z, color)
        if blip then
            RemoveBlip(blip)  -- Hapus blip sebelumnya jika ada
        end
        blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(blip, 1)  -- Pilih sprite blip yang sesuai
        SetBlipColour(blip, 5)  -- Ubah warna blip
        SetBlipScale(blip, 1.0)
        SetBlipRoute(blip, true)
    end

    -- Set blip untuk tujuan pemuatan
    createBlip(4435.2949, -4488.9863, 4.2354, 2)  -- Warna kuning untuk tujuan pemuatan

    local shortPoint = vector3(4435.2949, -4488.9863, 4.2354) 
    local shortPoint2 = vector3(5084.9966, -4681.3979, 2.3968) 
    local Depot = vector3(-367.1936, -2661.5593, 6.0003) 

    local notloaded = true
    local Loaded = false
    local inJob = false

    while notloaded do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, shortPoint, true)
        
        if distance < 25.0 then
            DrawMarker(1, shortPoint.x, shortPoint.y, shortPoint.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zu beladen")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to load the truck")
                end
                if IsControlJustReleased(0, 38) then
                    if Config.English == false then
                        exports['progressBars']:startUI(10000, "Belade den Truck")
                    else
                        exports['progressBars']:startUI(10000, "Loading the truck")
                    end
                    Citizen.Wait(10000)
                    if Config.English == false then
                        ShowNotification('~g~Du hast den LKW Beladen.')
                    else
                        ShowNotification('~g~You have loaded the truck.')
                    end
                    notloaded = false
                    Loaded = true
                    if Config.English == false then
                        QBCore.Functions.Notify("Bringe die Ladung zum Ziel.", "success")
                    else
                        QBCore.Functions.Notify("Bring the cargo to the destination.", "success")
                    end
                    -- Hapus waypoint dan buat blip untuk tujuan
                    createBlip(5084.9966, -4681.3979, 2.3968, 2)  -- Warna kuning untuk tujuan pengiriman
                end
            end
        end
    end

    while Loaded do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, shortPoint2, true)

        if distance < 25.0 then
            DrawMarker(1, shortPoint2.x, shortPoint2.y, shortPoint2.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zu entladen")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to unload the truck")
                end
                if IsControlJustReleased(0, 38) then
                    if Config.English == false then
                        exports['progressBars']:startUI(10000, "Entlade den Truck")
                    else
                        exports['progressBars']:startUI(10000, "Unload the truck")
                    end                            
                    Citizen.Wait(10000)
                    if Config.English == false then
                        ShowNotification('~g~Du hast den LKW entladen.')
                        ShowNotification('Bringe den LKW zum Depot.')
                    else
                        ShowNotification('~g~You have unloaded the truck.')
                        ShowNotification('Take the truck back to the depot.')
                    end                            
                    Loaded = false
                    inJob = true
                    -- Hapus waypoint dan buat blip untuk depot
                    createBlip(-367.1936, -2661.5593, 6.0003, 2)  -- Warna kuning untuk depot
                end
            end
        end
    end

    while inJob do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, Depot, true)
        local amount = Config.MoneyCayo
        local amountxp = Config.XPCayo
        
        if distance < 25.0 then
            DrawMarker(1, Depot.x, Depot.y, Depot.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if distance < 4.5 then
                if Config.English == false then
                    QBCore.Functions.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zurück zu geben")
                else
                    QBCore.Functions.ShowHelpNotification("Press ~INPUT_CONTEXT~ to return the truck")
                end                        
                if IsControlJustReleased(0, 38) then
                    -- Mengecek apakah trailer masih terpasang
                    local trailerAttached = IsVehicleAttachedToTrailer(hauler)
                    if trailerAttached then
                        if Config.English == false then
                            exports['progressBars']:startUI(10000, "Gebe den Truck zurück.")
                        else
                            exports['progressBars']:startUI(10000, "Returning the truck.")
                        end                            
                        Citizen.Wait(10000)
                        if Config.English == false then
                            ShowNotification('~b~Du hast ' ..amount.. '$ bekommen und ' ..amountxp..' Job XP')
                            ShowNotification('~g~Du hast den LKW zurück gegeben.')
                        else
                            ShowNotification('~b~You received ' ..amount.. '$ and ' ..amountxp..' Job XP')
                            ShowNotification('~g~You have returned the truck.')
                        end                            
                        TriggerServerEvent('nkhd_trucker:pay', amount, amountxp)
                    else
                        if Config.English == false then
                            ShowNotification('~r~Du musst den LKW mit dem Trailer zurückgeben, um bezahlt zu werden.')
                        else
                            ShowNotification('~r~You must return the truck with the trailer to get paid.')
                        end
                    end
                    inJob = false
                    -- Menghapus kendaraan setelah pekerjaan selesai
                    SetEntityAsMissionEntity(hauler, true, true)
                    DeleteVehicle(hauler)
                    SetEntityAsMissionEntity(trailer, true, true)
                    DeleteVehicle(trailer)
                    RemoveBlip(blip)  -- Hapus blip setelah pekerjaan selesai
                end
            end
        end
    end
end

function ShowNotification(text, type)
    QBCore.Functions.Notify(text, type or 'info')
end

RegisterNetEvent('koala_trucker:menujob')
AddEventHandler('koala_trucker:menujob', function(truckerxp)
    OpenTruckerMenu()
end)

exports['qtarget']:AddBoxZone("truck", vector3(-457.46, -2754.07, 5.0), 1.6, 1.0, {
    name="truck",
    heading=45,
    --debugPoly=true,
    minZ=3.8,
    maxZ=7.8
	}, {
		options = {
			{
                event = "koala_trucker:menujob",
				icon = "fas fa-truck",
				label = "Menu Kargo",
			},
		},
		distance = 2.5
})
