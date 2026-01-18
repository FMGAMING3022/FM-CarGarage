RegisterNetEvent('FM-CarGarage:addTrunkItems', function(plate, items)
    if not plate or not items then return end
    local trunkId = 'trunk-' .. plate
    if GetResourceState('ox_inventory') == 'started' then
        for _, item in ipairs(items) do
            exports.ox_inventory:AddItem(trunkId, item.name, item.amount)
        end
    elseif GetResourceState('qb-inventory') == 'started' then
        if not exports['qb-inventory']:GetInventory(trunkId) then
            exports['qb-inventory']:CreateInventory(trunkId, 'Vehicle Trunk', 40, 100000 )
        end
        for _, item in ipairs(items) do
            exports['qb-inventory']:AddItem(trunkId, item.name, item.amount, nil, item.info)
        end
    end
end)
