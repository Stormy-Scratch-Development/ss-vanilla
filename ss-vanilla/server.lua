local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("vumenu", function(source, item)
    local src = source
    TriggerClientEvent("ss-vanilla:OpenMenu", src)
end)

QBCore.Functions.CreateUseableItem("brandy", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

QBCore.Functions.CreateUseableItem("whiterum", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

QBCore.Functions.CreateUseableItem("appledrink", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

QBCore.Functions.CreateUseableItem("bananadrink", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

QBCore.Functions.CreateUseableItem("orangedrink", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

QBCore.Functions.CreateCallback('ss-vanilla:server:get:appledrink', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local ice = Ply.Functions.GetItemByName("ice")
    local brandy = Ply.Functions.GetItemByName("brandy")
    local apple = Ply.Functions.GetItemByName("apple")
    if ice ~= nil and brandy ~= nil and apple ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('ss-vanilla:server:get:bananadrink', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local ice = Ply.Functions.GetItemByName("ice")
    local whiterum = Ply.Functions.GetItemByName("whiterum")
    local banana = Ply.Functions.GetItemByName("banana")
    if ice ~= nil and whiterum ~= nil and banana ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('ss-vanilla:server:get:orangedrink', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local ice = Ply.Functions.GetItemByName("ice")
    local whiterum = Ply.Functions.GetItemByName("whiterum")
    local orange = Ply.Functions.GetItemByName("orange")
    if ice ~= nil and whiterum ~= nil and orange ~= nil then
        cb(true)
    else
        cb(false)
    end
end)