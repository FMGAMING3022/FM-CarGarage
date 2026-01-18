local CarSpawned = false 

local spawnedPeds = {}

CreateThread(function()
    for department, data in pairs(Config.Departments) do
        for _, pedData in ipairs(data.Peds) do
            QBCore.Functions.LoadModel(pedData.model)
            local ped = CreatePed(4, pedData.model, pedData.location.x, pedData.location.y, pedData.location.z - 1.0, pedData.location.w, false, true)
            SetEntityAsMissionEntity(ped, true, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetEntityInvincible(ped, true)
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
            FreezeEntityPosition(ped, true)

            local options = {{
                label = "Open Garage",
                icon = "fas fa-car",
                action = function()
                    local playerJob = Framework == 'qb' and QBCore.Functions.GetPlayerData().job.name or
                                      Framework == 'esx' and ESX.GetPlayerData().job.name or "none"
                    local playerGrade = Framework == 'qb' and QBCore.Functions.GetPlayerData().job.grade.level or 0
                    if playerJob == data.job then
                        OpenGarageMenu(department, playerGrade)
                    else
                        Notify("Garage", "You don't have access to this garage.", "error")
                    end
                end,
                job = data.job
            }}

            AddTargetEntity(ped, options, 2.5)

            spawnedPeds[#spawnedPeds + 1] = ped
        end
    end
end)

function AddTargetEntity(ped, options, distance)
    distance = distance or 2.5

    if Config.Target == 'qb-target' and GetResourceState('qb-target') == 'started' then
        exports['qb-target']:AddTargetEntity(ped, {options = options, distance = distance})
    elseif Config.Target == 'ox_target' and GetResourceState('ox_target') == 'started' then
        local targets = {}
        for _, opt in ipairs(options) do
            table.insert(targets, {
                event = function() opt.action() end,
                icon = opt.icon or "fas fa-circle",
                label = opt.label,
                job = opt.job
            })
        end
        exports.ox_target:addEntity(ped, targets)
    else
        CreateThread(function()
            while true do
                local playerPed = PlayerPedId()
                local pos = GetEntityCoords(playerPed)
                local pedPos = GetEntityCoords(ped)
                if #(pos - pedPos) < distance then
                    DrawText3D(pedPos.x, pedPos.y, pedPos.z + 1.0, "[E] "..(options[1].label or "Interact"))
                    if IsControlJustReleased(0, 38) then
                        options[1].action()
                    end
                end
                Wait(0)
            end
        end)
    end
end


function OpenGarageMenu(department, playerGrade)
    local vehicles = Config.Departments[department].Vehicles or {}
    if Config.Menu == 'qb-menu' and GetResourceState('qb-menu') == 'started' then
        local menuOptions = {
            {header = 'Car Garage', icon = 'fas fa-car-on', isMenuHeader = true}
        }
        for _, vehicle in ipairs(vehicles) do
            if hasRequiredGrade(vehicle.grade, playerGrade) then
                menuOptions[#menuOptions + 1] = {
                    header = vehicle.label,
                    txt = "Select to spawn " .. vehicle.label,
                    params = {
                        event = 'FM-CarGarage:spawnVehicle',
                        args = {
                            vehicleModel = vehicle.model,
                            department = department,
                            license = vehicle.license,
                        }
                    }
                }
            end
        end
        menuOptions[#menuOptions + 1] = {
            header = 'Return',
            icon = "fas fa-car-burst",
            params = { event = 'FM-CarGarage:despawnVehicle' }
        }
        menuOptions[#menuOptions + 1] = {
            header = '❌ Close',
            params = { event = 'qb-menu:closeMenu' }
        }
        exports['qb-menu']:openMenu(menuOptions)
    elseif Config.Menu == 'ox_lib' and GetResourceState('ox_lib') == 'started' then
        local menuId = 'garage_menu_' .. department
        local menuOptions = {}
        for _, vehicle in ipairs(vehicles) do
            if hasRequiredGrade(vehicle.grade, playerGrade) then
                table.insert(menuOptions, {
                    title = vehicle.label,
                    description = "Select to spawn " .. vehicle.label,
                    icon = "car",
                    onSelect = function()
                        TriggerEvent('FM-CarGarage:spawnVehicle', {
                            vehicleModel = vehicle.model,
                            department = department,
                            license = vehicle.license
                        })
                    end
                })
            end
        end
        table.insert(menuOptions, {
            title = "Return",
            description = "Despawn current vehicle",
            icon = "car-burst",
            onSelect = function()
                TriggerEvent('FM-CarGarage:despawnVehicle')
            end
        })

        table.insert(menuOptions, {
            title = "Close",
            description = "",
            icon = "times",
            onSelect = function()
            end
        })

        lib.registerContext({
            id = menuId,
            title = "Car Garage",
            options = menuOptions
        })

        lib.showContext(menuId)

    elseif Config.Menu == 'wasabi_uikit' and GetResourceState('wasabi_uikit') == 'started' then
        local menuId = 'garage_menu_' .. department
        local menuOptions = {}

        for _, vehicle in ipairs(vehicles) do
            if hasRequiredGrade(vehicle.grade, playerGrade) then
                table.insert(menuOptions, {
                    title = vehicle.label,
                    description = "Select to spawn " .. vehicle.label,
                    icon = "car",
                    onSelect = function()
                        TriggerEvent('FM-CarGarage:spawnVehicle', {
                            vehicleModel = vehicle.model,
                            department = department,
                            license = vehicle.license
                        })
                    end
                })
            end
        end
        table.insert(menuOptions, {
            title = "Return",
            description = "Despawn current vehicle",
            icon = "car-burst",
            onSelect = function()
                TriggerEvent('FM-CarGarage:despawnVehicle')
            end
        })
        table.insert(menuOptions, {
            title = "Close",
            description = "",
            icon = "times",
            onSelect = function()
            end
        })
        exports.wasabi_uikit:RegisterContextMenu({
            id = menuId,
            title = "Car Garage",
            options = menuOptions
        })
        exports.wasabi_uikit:OpenContextMenu(menuId)

    else
        local msg = "Available Vehicles:\n"
        for _, vehicle in ipairs(vehicles) do
            if hasRequiredGrade(vehicle.grade, playerGrade) then
                msg = msg .. "- " .. vehicle.label .. "\n"
            end
        end
        Notify("Garage", msg, "error", 7000)
    end
end

function hasRequiredGrade(requiredGrades, playerGrade)
    for _, grade in ipairs(requiredGrades) do
        if grade == playerGrade then
            return true
        end
    end
    return false
end

RegisterNetEvent('FM-CarGarage:spawnVehicle', function(data)
    if not data or not data.department or not data.vehicleModel then return end

    local departmentConfig = Config.Departments[data.department]
    if not departmentConfig then return end

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local spawnLocation

    for _, pedData in pairs(departmentConfig.Peds) do
        if #(pedCoords - vec3(
            pedData.location.x,
            pedData.location.y,
            pedData.location.z
        )) < 2.0 then
            spawnLocation = pedData.spawnLocation
            break
        end
    end

    if not spawnLocation then
        Notify("Garage", "No valid spawn location found", "error")
        return
    end

    if IsAnyVehicleNearPoint(spawnLocation.x, spawnLocation.y, spawnLocation.z, 2.5) then
        Notify("Garage", "Vehicle spawn point is occupied", "error")
        return
    end

    local model = joaat(data.vehicleModel)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local vehicle = CreateVehicle(
        model,
        spawnLocation.x,
        spawnLocation.y,
        spawnLocation.z,
        spawnLocation.w,
        true,
        false
    )

    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleModKit(vehicle, 0)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)

    if GetResourceState('LegacyFuel') == 'started' then
        exports.LegacyFuel:SetFuel(vehicle, 100.0)
    else
        SetVehicleFuelLevel(vehicle, 100.0)
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    GiveKey(plate, vehicle)

    for _, v in ipairs(departmentConfig.Vehicles) do
        if v.model == data.vehicleModel then

            SetVehicleDirtLevel(vehicle, 0.0)
            if v.extras then
                for _, extra in ipairs(v.extras) do
                    SetVehicleExtra(vehicle, extra, 0)
                end
            end

            if v.mods then
                for _, mod in ipairs(v.mods) do
                    SetVehicleMod(vehicle, mod.modType, mod.modIndex, false)
                end
            end

            if v.colors and #v.colors == 2 then
                SetVehicleColours(vehicle, v.colors[1], v.colors[2])
            end

            if v.tint then
                SetVehicleWindowTint(vehicle, 1)
            end

            if v.livery then
                SetVehicleLivery(vehicle, v.livery)
            end

            if v.trunkItems then
                Wait(1000)
                TriggerServerEvent(
                    'FM-CarGarage:addTrunkItems',
                    GetVehicleNumberPlateText(vehicle),
                    v.trunkItems
                )
            end
        end
    end

    SetModelAsNoLongerNeeded(model)
    Notify("Garage", "Vehicle spawned successfully", "success")
end)


function GetClosestVehicleBridge(coords, maxDistance)
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle = nil
    local closestDist = maxDistance or 10.0
    for _, veh in ipairs(vehicles) do
        if DoesEntityExist(veh) then
            local dist = #(coords - GetEntityCoords(veh))
            if dist < closestDist then
                closestDist = dist
                closestVehicle = veh
            end
        end
    end
    return closestVehicle, closestDist
end

RegisterNetEvent('FM-CarGarage:despawnVehicle', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle, distance = GetClosestVehicleBridge(coords, 10.0)
    if not vehicle then
        Notify("Garage", "No vehicle nearby", "error")
        return
    end
    local busy = true
    local vehicleCoords = GetEntityCoords(vehicle)
    CreateThread(function()
        while busy do
            DrawMarker(21, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.4, 0.4, 0.4, 247, 205, 17, 200, true, true, 2, false)
            Wait(0)
        end
    end)
    local dict = 'misscarsteal4@actor'
    local anim = 'actor_berating_loop'
    local animTime = 3000
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
    FreezeEntityPosition(ped, true)
    TaskPlayAnim( ped, dict, anim, 8.0, -8.0, animTime, 49, 0.0, false, false, false)
    Wait(animTime)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteEntity(vehicle)
    end
    busy = false
    Notify("Garage", "Vehicle returned successfully", "success")
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, ped in ipairs(spawnedPeds) do
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
        end
    end
end)
