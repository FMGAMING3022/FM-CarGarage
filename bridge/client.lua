Framework = nil
QBCore = nil
ESX = nil

CreateThread(function()
    local chosen = Config.Framework
    if chosen == 'qb' and GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        Framework = 'qb'
        print('[FM-Jobgarage] Framework selected: QBCore')
    elseif chosen == 'esx' and GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
        Framework = 'esx'
        print('[FM-Jobgarage] Framework selected: ESX')
    elseif chosen == 'ox_lib' and GetResourceState('ox_lib') == 'started' then
        Framework = 'ox_lib'
        print('[FM-Jobgarage] Framework selected: ox_lib')
    elseif chosen == 'wasabi_uikit' and GetResourceState('wasabi_uikit') == 'started' then
        Framework = 'wasabi_uikit'
        print('[FM-Jobgarage] Framework selected: Wasabi')
    else
        Framework = 'custom'
        print('[FM-Jobgarage] No supported framework found. Using custom fallback.')
    end
end)

function Notify(title, message, type, duration)
    type = type or 'info'
    duration = duration or 5000

    if Framework == 'qb' then
        QBCore.Functions.Notify(message, type, duration)
    elseif Framework == 'esx' then
        TriggerEvent('esx:showNotification', message)
    elseif Framework == 'ox_lib' then
        lib.notify({title = title or "Notification", description = message, type = type, duration = duration})
    elseif Framework == 'wasabi_uikit' then
        exports.wasabi_uikit:Notification({
            title = title,
            text = message,
            type = type,
            time = duration,
            id = nil,
            icon = nil,
            color = Config.Color
        })
    else
        print("["..(title or "Notify").."]: "..message)
    end
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function GiveKey(plate, vehicle)
    if GetResourceState('qb-vehiclekeys') == 'started' then
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
    elseif GetResourceState('wasabi_carlock') == 'started' then
        exports['wasabi_carlock']:GiveKey(plate)
    end
end
