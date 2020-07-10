local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:GetSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(200)
    end
end)

local CarryPackage = nil
local onDuty = false
Citizen.CreateThread(function ()
    local RecycleBlip = AddBlipForCoord(Config['delivery'].OutsideLocation.x, Config['delivery'].OutsideLocation.y, Config['delivery'].OutsideLocation.z)
    while true do
        Citizen.Wait(7)
        local pos = GetEntityCoords(GetPlayerPed(-1), true)

        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].OutsideLocation.x, Config['delivery'].OutsideLocation.y, Config['delivery'].OutsideLocation.z, true) < 1.3 then
            DrawText3D(Config['delivery'].OutsideLocation.x, Config['delivery'].OutsideLocation.y, Config['delivery'].OutsideLocation.z + 1, "Iceriye girmek icin [~g~E~w~]")
            --EN	DrawText3D(Config['delivery'].OutsideLocation.x, Config['delivery'].OutsideLocation.y, Config['delivery'].OutsideLocation.z + 1, "[~g~E~w~] to enter")
            if IsControlJustReleased(0, Keys["E"]) then
                DoScreenFadeOut(500)
                while not IsScreenFadedOut() do
                    Citizen.Wait(10)
                end
                SetEntityCoords(GetPlayerPed(-1), Config['delivery'].InsideLocation.x, Config['delivery'].InsideLocation.y, Config['delivery'].InsideLocation.z)
                DoScreenFadeIn(500)
            end
        end

        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].InsideLocation.x, Config['delivery'].InsideLocation.y, Config['delivery'].InsideLocation.z, true) < 15 and not IsPedInAnyVehicle(GetPlayerPed(-1), false) and not onDuty then
            DrawMarker(25, Config['delivery'].InsideLocation.x, Config['delivery'].InsideLocation.y, Config['delivery'].InsideLocation.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 98, 102, 185,100, 0, 0, 0,0)
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].InsideLocation.x, Config['delivery'].InsideLocation.y, Config['delivery'].InsideLocation.z, true) < 1.3 then
                DrawText3D(Config['delivery'].InsideLocation.x, Config['delivery'].InsideLocation.y, Config['delivery'].InsideLocation.z + 1, "Dısarıya cıkmak icin [~g~E~w~] ")
		        --EN	DrawText3D(Config['delivery'].InsideLocation.x, Config['delivery'].InsideLocation.y, Config['delivery'].InsideLocation.z + 1, "[~g~E~w~] to go out")
                if IsControlJustReleased(0, Keys["E"]) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(10)
                    end
                    SetEntityCoords(GetPlayerPed(-1), Config['delivery'].OutsideLocation.x, Config['delivery'].OutsideLocation.y, Config['delivery'].OutsideLocation.z + 1)
                    DoScreenFadeIn(500)
                end
            end
        end
        -- İŞBAŞI / ONDUTY
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 1049.15,-3100.63,-39.95, true) < 15 and not IsPedInAnyVehicle(GetPlayerPed(-1), false) and CarryPackage == nil then
            DrawMarker(25, 1049.15,-3100.63,-39.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 255, 0, 0,100, 0, 0, 0,0)
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 1049.15,-3100.63,-39.95, true) < 1.3 then
                if onDuty then
                    DrawText3D(1049.15,-3100.63,-39.95 + 1, "Mesai sonu vermek icin [~g~E~w~]")
			        --EN	DrawText3D(1049.15,-3100.63,-39.95 + 1, "[~g~E~w~] to give overtime")
                    else
                    DrawText3D(1049.15,-3100.63,-39.95 + 1, "Isbası yapmak icin [~g~E~w~]")
			        --EN	DrawText3D(1049.15,-3100.63,-39.95 + 1, "[~g~E~w~] for on the job")
                end
                if IsControlJustReleased(0, Keys["E"]) then
                    onDuty = not onDuty
                    if onDuty then
						exports['mythic_notify']:DoHudText('inform', 'Artık isbasındasın!')
				        --EN 	exports['mythic_notify']:DoHudText('inform', 'You are at the work!')
                        else
						exports['mythic_notify']:DoHudText('error', 'Zaman asımına ugradın!')
				        --EN	exports['mythic_notify']:DoHudText('error', 'You timeout!')
                    end
                end
            end
        end
    end
end)

local packagePos = nil
Citizen.CreateThread(function ()
    for k, pickuploc in pairs(Config['delivery'].PackagePickupLocations) do
        local model = GetHashKey(Config['delivery'].WareHouseObjects[math.random(1, #Config['delivery'].WareHouseObjects)])
        RequestModel(model)
        while not HasModelLoaded(model) do Citizen.Wait(0) end
        local obj = CreateObject(model, pickuploc.x, pickuploc.y, pickuploc.z, false, true, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
    end
    while true do
        Citizen.Wait(7)
        if onDuty then
            if packagePos ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1), true)
                if CarryPackage == nil then
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, packagePos.x,packagePos.y,packagePos.z, true) < 2.3 then
                        DrawText3D(packagePos.x,packagePos.y,packagePos.z+ 1, "Paket almak icin [~g~E~w~]")
				        --EN	DrawText3D(packagePos.x,packagePos.y,packagePos.z+ 1, "[~g~E~w~] to receive the package")
                        if IsControlJustReleased(0, Keys["E"]) then
                            ScrapAnim()
                            exports['progressBars']:startUI(5000, "Paketi alıyorsun")
                                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                PickupPackage()
                        end
                        else
                        DrawText3D(packagePos.x, packagePos.y, packagePos.z + 1, "Paket")
                    end
                    else
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z, true) < 2.0 then
                        DrawText3D(Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z, "Paketi acmak icin [~g~E~w~]")
				        --EN	DrawText3D(Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z, "[~g~E~w~] to open the package")
                        if IsControlJustReleased(0, Keys["E"]) then
                            DropPackage()
                            ScrapAnim()
							exports['progressBars']:startUI(5000, "Paketi açıyorsun")
                                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
								Citizen.Wait(5000)
                                TriggerServerEvent('td-recycle:server:addItem')
                                GetRandomPackage()
                        end
                        else
                        DrawText3D(Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z, "Paketi teslim et")
				        --EN	DrawText3D(Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z, "Deliver the package")
                    end
                end
                else
                GetRandomPackage()
            end
        end
    end
end)
function ScrapAnim()
    local time = 5
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
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
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function GetRandomPackage()
    local randomPackage = math.random(1, #Config["delivery"].PackagePickupLocations)
    packagePos = {}
    packagePos.x = Config["delivery"].PackagePickupLocations[randomPackage].x
    packagePos.y = Config["delivery"].PackagePickupLocations[randomPackage].y
    packagePos.z = Config["delivery"].PackagePickupLocations[randomPackage].z
end

function PickupPackage()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_cs_cardbox_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
    CarryPackage = object
end

function DropPackage()
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(CarryPackage, true, true)
    DeleteObject(CarryPackage)
    CarryPackage = nil
end

Citizen.CreateThread(function()
	for k,v in pairs(Config.Recycle) do
		local RecycleBlip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (RecycleBlip, v.Blip.Sprite)
		SetBlipScale  (RecycleBlip, v.Blip.Scale) 
		SetBlipColour (RecycleBlip, v.Blip.Colour)
		SetBlipAsShortRange(RecycleBlip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('recycle_blip'))
		EndTextCommandSetBlipName(RecycleBlip)
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Drop) do
		local DropBlip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (DropBlip, v.Blip.Sprite)
		SetBlipScale  (DropBlip, v.Blip.Scale)
		SetBlipColour (DropBlip, v.Blip.Colour)
		SetBlipAsShortRange(DropBlip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('drop_blip'))
		EndTextCommandSetBlipName(DropBlip)
	end
end)