RegisterCommand('suicide', function()
	for _, g in ipairs(Config.Weapons) do
if HasPedGotWeapon(ped, GetHashKey(g.hash), false) then
OpenWatch()
suicideanim = true
else
	Config.NoWeaponInHands()
end
end
end)

local dict = 'mp_suicide'
local anim =  'pistol'
local displayWatch = false 




function OpenWatch()
    TaskPlayAnim(GetPlayerPed(-1), dict ,anim ,8.0, -8.0, -1, 0, 0, false, false, false)
    displayWatch = true
    closing = false
end

function CloseWatch()
ped = PlayerPedId()
wephash = GetSelectedPedWeapon(ped)
wepammo = GetAmmoInPedWeapon(ped, wephash)
if wepammo ~= 0 then
suicideanim = false
closing = true
coords = GetEntityCoords(ped)
rot = GetEntityRotation(ped)
suicideanim = false
ClearPedTasks(ped)
SetPedShootRate(ped, 1000)
SetPedShootsAtCoord(ped, 0, 0, 0, true)
TaskPlayAnimAdvanced(ped, dict, anim, coords, rot, 8.0, 8.0, 3000, 0, 0.28, 0, 0)
Wait(200)
SetEntityHealth(ped, 0)
displayWatch = false
else 
    PlaySoundFrontend(-1, 'Faster_Click', 'RESPAWN_ONLINE_SOUNDSET', 1)
end
end 

CreateThread(function()
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
      Citizen.Wait(1000)
    end
end)

CreateThread(function()
    while true do 
    Wait(100)
                
            if (IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3)) then
                currentTime = GetEntityAnimCurrentTime(PlayerPedId(), dict, anim);
                --pause when the currentTime arrive 0.12 (percent?)
                if currentTime >= 0.28 and not closing then --(currentTime >= 0.12 and currentTime <= 1.0) then
                	ped = PlayerPedId()
                    SetEntityAnimCurrentTime(PlayerPedId(), dict, anim, currentTime);
                    SetEntityAnimSpeed(PlayerPedId(), dict, anim, 0);
                end
            end
            
        end 
end)

CreateThread(function()
    while true do 
    Wait(0)
    ped = PlayerPedId()
    coords = GetEntityCoords(ped)
if suicideanim then
	DrawText3D(coords.x, coords.y, coords.z, 'Suicide: [E], Cancel: X')
end
if suicideanim and IsControlJustPressed(0, 38) then
	CloseWatch()
end
if suicideanim and IsControlJustPressed(0, 73) then
	StopAnimTask(PlayerPedId(), dict, anim, 1.1);
	suicideanim = false
end
end
end)

function DrawText3D(x, y, z, text, linecount)
    if not linecount or linecount == nil or linecount == 0 then
        linecount = 0.7
    end
    SetTextScale(0.325, 0.325)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 470
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03 * linecount, 0, 0, 0, 68)
    ClearDrawOrigin()
end

