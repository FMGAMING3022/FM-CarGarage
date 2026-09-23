local grantedTrunks = {}

RegisterNetEvent('FM-CarGarage:addTrunkItems', function(department, vehicleModel, netId)
    local src = source

    if type(department) ~= 'string' or type(vehicleModel) ~= 'string' or type(netId) ~= 'number' then return end

    local deptConfig = Config.Departments[department]
    if not deptConfig then return end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.name ~= deptConfig.job then return end
    local playerGrade = Player.PlayerData.job.grade.level
    local vehicleCfg
    for _, v in ipairs(deptConfig.Vehicles or {}) do
        if v.model == vehicleModel then
            vehicleCfg = v
            break
        end
    end
    if not vehicleCfg then return end
    if not hasRequiredGrade(vehicleCfg.grade, playerGrade) then return end
    if not vehicleCfg.trunkItems then return end

    local veh = NetworkGetEntityFromNetworkId(netId)
    if not veh or veh == 0 or not DoesEntityExist(veh) then return end
    if GetEntityType(veh) ~= 2 then return end

    local ped = GetPlayerPed(src)
    if #(GetEntityCoords(ped) - GetEntityCoords(veh)) > 5.0 then return end

    local plate = GetVehicleNumberPlateText(veh)

    if grantedTrunks[plate] then return end
    grantedTrunks[plate] = true

    local trunkId = 'trunk-' .. plate
    if GetResourceState('ox_inventory') == 'started' then
        for _, item in ipairs(vehicleCfg.trunkItems) do
            exports.ox_inventory:AddItem(trunkId, item.name, item.amount)
        end
    elseif GetResourceState('qb-inventory') == 'started' then
        if not exports['qb-inventory']:GetInventory(trunkId) then
            exports['qb-inventory']:CreateInventory(trunkId, 'Vehicle Trunk', 40, 100000)
        end
        for _, item in ipairs(vehicleCfg.trunkItems) do
            exports['qb-inventory']:AddItem(trunkId, item.name, item.amount, nil, item.info)
        end
    end
end)