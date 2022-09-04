local isMeldingVerstuurd = false -- puts isMeldingVerstuurd to false
local leaveMessage = 5000 -- Amount of miliseconds to show the "You just left the greenzone", feel free to change this to your liking!
local isLeaveMessagePresent = false -- The "You just left the redzone"
local isInCityZone = false -- turns isInCityZone to false

local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        local ped = GetEntityCoords(GetPlayerPed(-1))
        for zoneTitel, zoneData in pairs(Config.Greenzones) do
            if Vdist(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, ped) < zoneData.Radius then
                    DisableActions()
                if isMeldingVerstuurd == false then -- The moment you enter the circle (coords), it will check if isMeldingVerstuurd is false, if so it will set it to true. (If it remains false it will continue to run it)
                    
                    Wait(0)
                    isMeldingVerstuurd = true
                    EnteredGreenzone()   -- runs line 33
                end
            elseif Vdist(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, ped) < (zoneData.Radius + 30) and Vdist(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, ped) > zoneData.Radius then
                EnableDamage()
                if isMeldingVerstuurd then
                    
                    LeftGreenzone() -- runs line 43

                end
                isMeldingVerstuurd = false
            end

        end
    end
end)

function EnteredGreenzone()
    QBCore.Functions.Notify('You just entered the greenzone')
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)
    isLeaveMessagePresent = true
    Citizen.SetTimeout(leaveMessage, function() -- Wait the timer to be done
        isLeaveMessagePresent = false
    end)
    isInCityZone = true
end

function LeftGreenzone()
    QBCore.Functions.Notify('You just left the greenzone')
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)
    isLeaveMessagePresent = true
    Citizen.SetTimeout(leaveMessage, function() -- Wait the timer to be done
        isLeaveMessagePresent = false
    end)
    isInCityZone = false
end

function DisableActions()
    DisableControlAction(2, 37, true) -- Disable Weaponwheel
    DisablePlayerFiring(GetPlayerPed(-1),true) -- Disable firing
    DisableControlAction(0, 45, true) -- Disable reloading
    DisableControlAction(0, 24, true) -- Disable attacking
    DisableControlAction(0, 263, true) -- Disable melee attack 1
    DisableControlAction(0, 140, true) -- Disable light melee attack (r)
    DisableControlAction(0, 142, true) -- Disable left mouse button (pistol whack etc)
    SetPlayerInvincible(PlayerId(), true) -- Turns Player into "god mode"

    for k, v in pairs(GetActivePlayers()) do
        local ped = GetPlayerPed(v)
        SetEntityNoCollisionEntity(GetPlayerPed(-1), GetVehiclePedIsIn(ped, false), true)
        SetEntityNoCollisionEntity(GetVehiclePedIsIn(ped, false), GetVehiclePedIsIn(GetPlayerPed(-1), false), true)
    end
end

function EnableDamage()
    SetPlayerInvincible(PlayerId(), false) -- Turns Player into "god mode"
end

Citizen.CreateThread(function()
    for zoneTitel, zoneData in pairs(Config.Greenzones) do
      local GreenzoneBlip = AddBlipForRadius(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, zoneData.Radius)
      SetBlipColour(GreenzoneBlip, 2)
      SetBlipAlpha(GreenzoneBlip, 100)
    end
end)



function DrawTextOnScreen(text, x, y, r, g, b, a, s, font)
    SetTextColour(r, g, b, a)
    SetTextFont(font)   
    SetTextScale(s, s)
    SetTextCentre(false)     
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
