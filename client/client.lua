local variables = {
    clothesOn = false,
    jobStarted = false,
    returnVehicle = false,
    vehiclePlate = "",
    vehicle = "",
    playerSkin = "",
    inZone = "",
    withoutTug = true,
    blip1 = "",
    blip2 = "",
    blip3 = ""
}


local function loadModel(model)
    RequestModel(model)
    local repeater = 0
    repeat
        Wait(1)
        repeater = HasModelLoaded(model)
    until (repeater == 1)
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    local repeater = 0
    repeat
        Wait(1)
        repeater = HasAnimDictLoaded(dict)
    until (repeater == 1)
end

Citizen.CreateThread(function()
    loadModel(Config.ped.model)
    local ped = CreatePed(4, Config.ped.model, Config.ped.coords.x, Config.ped.coords.y, Config.ped.coords.z,
        Config.ped.coords.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    loadModel(Config.ped2.model)
    local ped2 = CreatePed(4, Config.ped2.model, Config.ped2.coords.x, Config.ped2.coords.y, Config.ped2.coords.z,
        Config.ped2.coords.w, false, true)
    FreezeEntityPosition(ped2, true)
    SetEntityInvincible(ped2, true)
    SetBlockingOfNonTemporaryEvents(ped2, true)
end)


local function clothes(type)
    loadAnimDict("move_m@_idles@shake_off")
    if type == "on" then
        variables.clothesOn = true
        ESX.ShowNotification("Przebierasz się")
        TaskPlayAnim(PlayerPedId(), "move_m@_idles@shake_off", "shakeoff_1", 8.0, 8.0, -1, 0, 1, true, true, true)
        Wait(2000)
        TriggerEvent('skinchanger:getSkin', function(skin)
            variables.playerSkin = skin
            local uniformObject
            if skin.sex == 0 then
                uniformObject = Config.Clothes.male
            else
                uniformObject = Config.Clothes.female
            end
            if uniformObject then
                TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
            end
        end)
    else
        variables.clothesOn = false
        ESX.ShowNotification("Przebierasz się")
        TaskPlayAnim(PlayerPedId(), "move_m@_idles@shake_off", "shakeoff_1", 8.0, 8.0, -1, 0, 1, true, true, true)
        Wait(2000)
        TriggerEvent('skinchanger:loadClothes', variables.playerSkin)
    end
end


local function addBlips()
    if variables.jobStarted == true then
        variables.blip1 = AddBlipForCoord(-1900.65, 5369.18, 30)
        SetBlipSprite(variables.blip1, 317)
        SetBlipDisplay(variables.blip1, 4)
        SetBlipScale(variables.blip1, 0.8)
        SetBlipColour(variables.blip1, 66)
        SetBlipAsShortRange(variables.blip1, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Strefa łowienia 1")
        EndTextCommandSetBlipName(variables.blip1)

        variables.blip2 = AddBlipForCoord(-1675.64, 5860.24, 30)
        SetBlipSprite(variables.blip2, 317)
        SetBlipDisplay(variables.blip2, 4)
        SetBlipScale(variables.blip2, 0.8)
        SetBlipColour(variables.blip2, 66)
        SetBlipAsShortRange(variables.blip2, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Strefa łowienia 2")
        EndTextCommandSetBlipName(variables.blip2)

        variables.blip3 = AddBlipForCoord(-2599.71, 5705.81, 30)
        SetBlipSprite(variables.blip3, 317)
        SetBlipDisplay(variables.blip3, 4)
        SetBlipScale(variables.blip3, 0.8)
        SetBlipColour(variables.blip3, 66)
        SetBlipAsShortRange(variables.blip3, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Strefa łowienia 3")
        EndTextCommandSetBlipName(variables.blip3)
    end
end




local function startJob(type)
    if type == "start" then
        if IsAnyVehicleNearPoint(-1605.39, 5258.87, 2.09, 60.0) == false then
            ESX.TriggerServerCallback("fisher:removeMoney", function(validate)
                if validate then
                    variables.jobStarted = true
                    ESX.ShowNotification("Zabrano 500 dollarów w formie zaliczki")
                    ESX.ShowNotification("Udaj się na koniec molo weź swój kuter i udaj sie na łowy Powodzenia!")
                    addBlips()
                    ESX.TriggerServerCallback("fisher:addWedka", function()
                    end)
                    variables.withoutTug = false
                    ESX.Game.SpawnVehicle('tug', {
                        x = -1599.28,
                        y = 5260.1,
                        z = 0.17
                    }, 23.67, function(vehicle)
                        SetEntityAsMissionEntity(vehicle, true, true);
                        variables.vehiclePlate = GetVehicleNumberPlateText(vehicle)
                        variables.vehicle = vehicle
                    end)
                else
                    ESX.ShowNotification("Nie posiadasz pieniędzy na zaliczke!")
                end
            end)
        else
            ESX.ShowNotification("Niestety nie można rozpocząć pracy w momencie gdy miejsce na kutry jest zajęte!")
        end
    else
        variables.clothesOn = false
        variables.jobStarted = false
        variables.returnVehicle = false
        variables.vehiclePlate = ""
        variables.vehicleHash = ""
        variables.withoutTug = true
        RemoveBlip(variables.blip1)
        RemoveBlip(variables.blip2)
        RemoveBlip(variables.blip3)
        ESX.TriggerServerCallback("fisher:removeWedka", function()
        end)
        clothes("off")
    end
end


local function startJob2()
    variables.jobStarted = true
    addBlips()
    ESX.ShowNotification("Powodzenia w łowach wędkarzu!")
    ESX.TriggerServerCallback("fisher:addWedka", function()
    end)
end




local function returnVehicle()
    if DoesEntityExist(variables.vehicle) then
        DeleteEntity(variables.vehicle)
        ESX.ShowNotification("Otrzymałeś zwrot w wysokości 500 dollarów")
        ESX.TriggerServerCallback("fisher:addMoney", function()
        end)
    else
        ESX.ShowNotification("Nie posiadasz pojazdu do zwrotu")
    end
end


local function sellFishes()
    ESX.TriggerServerCallback("fisher:sellItems", function()
    end)
end


local function startFishing()
    ESX.ShowNotification("Zaczynasz łowy")
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_FISHING', 1, 0)
    SendNUIMessage({ action = "otworz", })
    SetNuiFocus(true, true)
end




RegisterNetEvent("fisher:startfish", function()
    if variables.jobStarted == true then
        if variables.inZone == 1 then
            local ped = PlayerPedId()
            local vehicle = variables.vehicle
            if GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehicle), true) <= 20.0 then
                startFishing()
            else
                if variables.withoutTug == true and IsPedSwimming(PlayerPedId()) == false then
                    startFishing()
                else
                    ESX.ShowNotification("Musisz byc na kutrze rybackim!")
                end
            end
        else
            ESX.ShowNotification("Nie możesz łowić w tym miejscu!")
        end
    else
        ESX.ShowNotification("Najpierw musisz zacząć prace!")
    end
end)

RegisterNUICallback('zamknij', function()
    local Ped = PlayerPedId()
    SendNUIMessage({ action = "zamknij" })
    ClearPedTasksImmediately(Ped)
    SetNuiFocus(false, false)
end)


RegisterNUICallback('sukces', function()
    local Ped = PlayerPedId()
    ClearPedTasksImmediately(Ped)
    SendNUIMessage({ action = "zamknij" })
    SetNuiFocus(false, false)
    local quantityFish = math.random(1, 5)
    local fishType1 = "Molinezja Ostrousta"
    local fishType2 = "Ciernik"
    local fishType3 = "Heterandria"
    local fishType = math.random(1, 100)
    if fishType < 50 then
        fishType = fishType2
    elseif fishType == 1 then
        fishType = fishType1
    elseif fishType > 50 then
        fishType = fishType3
    end

    ESX.ShowNotification("Po sprawdzeniu siatki wyszło że zdobyłeś " ..
        quantityFish .. " ryby ich gatunek to " .. fishType)
    if fishType == "Molinezja Ostrousta" then
        fishType = "moliza"
    end
    if fishType == "Ciernik" then
        fishType = "ciernik"
    end
    if fishType == "Heterandria" then
        fishType = "heterandria"
    end
    ESX.TriggerServerCallback("fisher:addFishes", function()
    end, quantityFish, fishType)
end)



exports['qtarget']:AddBoxZone("fisher_ped_poly", vector3(-1593.92, 5204.94, 4.31), 1, 0.8, {
    name = "fisher_ped_poly",
    heading = 115,
    minZ = 1.31,
    maxZ = 5.31
}, {
    options = {
        {
            action = function()
                clothes("on")
            end,
            icon = "fa-solid fa-shirt",
            label = "Ubierz się w strój roboczy",
            canInteract = function()
                return not variables.clothesOn
            end,
        },
        {
            action = function()
                startJob("start")
            end,
            icon = "fa-solid fa-briefcase",
            label = "Zacznij pracę",
            canInteract = function()
                return variables.clothesOn and not variables.jobStarted
            end,
        },
        {
            action = function()
                startJob2()
            end,
            icon = "fa-solid fa-briefcase",
            label = "Zacznij pracę bez kutra",
            canInteract = function()
                return variables.clothesOn and not variables.jobStarted
            end,
        },
        {
            action = function()
                clothes("off")
            end,
            icon = "fa-solid fa-xmark",
            label = "Anuluj",
            canInteract = function()
                return variables.clothesOn and not variables.jobStarted
            end,
        },
        {
            action = function()
                startJob("end")
            end,
            icon = "fa-solid fa-briefcase",
            label = "Zakończ pracę",
            canInteract = function()
                return variables.clothesOn and variables.jobStarted
            end,
        },
        {
            action = function()
                returnVehicle()
            end,
            icon = "fa-solid fa-sailboat",
            label = "Oddaj pojazd",
            canInteract = function()
                return variables.clothesOn and variables.jobStarted and not variables.withoutTug
            end,
        }
    },
    distance = 2.0
})




exports['qtarget']:AddBoxZone("fisher_ped_poly2", vector3(-1593.09, 5202.81, 4.31), 0.5, 1.0, {
    name = "fisher_ped_poly2",
    heading = 0,
    minZ = 1.31,
    maxZ = 5.31
}, {
    options = {
        {
            action = function()
                sellFishes()
            end,
            icon = "fa-solid fa-dollar-sign",
            label = "Sprzedaj ryby",
        }
    },
    distance = 2.0
})


CreateThread(function()
    for k, v in pairs(Config.FishZone) do
        local FishZone = PolyZone:Create(v.zones, {
            name = v.label,
            debugPoly = false
        })

        FishZone:onPlayerInOut(function(isPointInside)
            if isPointInside then
                variables.inZone = 1
            else
                variables.inZone = 0
            end
        end)
    end
end)
