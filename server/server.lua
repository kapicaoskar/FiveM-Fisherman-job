ESX.RegisterServerCallback("fisher:removeMoney", function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getMoney() >= 500 then
        cb(true)
        xPlayer.removeMoney(500)
    else
        cb(false)
    end
end)



ESX.RegisterServerCallback("fisher:addMoney", function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addMoney(500)
end)

ESX.RegisterServerCallback("fisher:addWedka", function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addInventoryItem("wedka", 1)
end)


ESX.RegisterServerCallback("fisher:sellItems", function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem("ciernik").count == 0 and xPlayer.getInventoryItem("moliza").count == 0 and xPlayer.getInventoryItem("heterandria").count == 0 then
        xPlayer.showNotification('Nie posiadasz ryb')
    else
        local quantity = xPlayer.getInventoryItem("ciernik").count
        local money = quantity * 100
        xPlayer.addMoney(money)
        xPlayer.removeInventoryItem("ciernik", quantity)
        local quantity = xPlayer.getInventoryItem("moliza").count
        local money = quantity * 300
        xPlayer.addMoney(money)
        xPlayer.removeInventoryItem("moliza", quantity)
        xPlayer.showNotification('Sprzedano wszystkie ryby')
        local quantity = xPlayer.getInventoryItem("heterandria").count
        local money = quantity * 25
        xPlayer.addMoney(money)
        xPlayer.removeInventoryItem("heterandria", quantity)
        xPlayer.showNotification('Sprzedano wszystkie ryby')
    end
end)


ESX.RegisterServerCallback("fisher:removeWedka", function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local money = xPlayer.getMoney()
    if xPlayer.getInventoryItem("wedka").count == 0 then
        if money >= 200 then
            xPlayer.removeMoney(200)
            xPlayer.showNotification('Płacisz za zgubioną wędke')
        else
            xPlayer.showNotification('Następnym razemu nie zgub wędki bo dostaniesz karę w wysokości 200 dollarów')
        end
    else
        xPlayer.removeInventoryItem("wedka", 1)
    end
end)


ESX.RegisterServerCallback("fisher:addFishes", function(source, cb, fishQuan, fishType)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if exports['ox_inventory']:CanCarryItem(source, fishType, fishQuan) then
        xPlayer.addInventoryItem(fishType, fishQuan)
    else
        xPlayer.showNotification("Nie masz miejsca w ekwipunku")
    end
end)
