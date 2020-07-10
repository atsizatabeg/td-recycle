ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

PlayerData = {}

local Items = {
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminium",
    "steel",
    "glass"
}

RegisterServerEvent("td-recycle:server:addItem")
AddEventHandler("td-recycle:server:addItem", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    for i = 1, math.random(1, 7), 1 do
        local RandomItem = Items[math.random(3, #Items)]
        local amount = math.random(5, 12)
		xPlayer.addInventoryItem(RandomItem, amount)
		TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Paketten ' ..amount.. ' adet '..RandomItem..' çıktı!'})
        -- EN:		TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Hey!' ..amount.. ..items.. 'came out of the package!'})
        Citizen.Wait(500)
    end
    
end)