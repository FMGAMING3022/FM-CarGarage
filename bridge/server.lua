QBCore = nil

CreateThread(function()
    if Config.Framework == 'qb' and GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

function hasRequiredGrade(requiredGrades, playerGrade)
    for _, grade in ipairs(requiredGrades) do
        if grade == playerGrade then
            return true
        end
    end
    return false
end