local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

CreateThread(function()
    -- initial fetch
    Wait(1000)
    PlayerData = QBCore.Functions.GetPlayerData()
end)

-- /gunplug (Config.Command)
RegisterCommand(Config.Command or 'gunplug', function()
    PlayerData = PlayerData.job and PlayerData or QBCore.Functions.GetPlayerData()
    if PlayerData.job and PlayerData.job.name == (Config.JobName or 'gunplug') then
        TriggerServerEvent('richies-gunplug:requestWeapons')
    else
        QBCore.Functions.Notify('You do not have permission to use this.', 'error')
    end
end, false)
