local QBCore = exports['qb-core']:GetCoreObject()

isLoggedIn = true

local onDuty = true

local spawnedPeds = {}

PlayerJob = {}


----------------
-- Handlers
----------------

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = PlayerData.job
	if PlayerData.job.onduty then
	    if PlayerData.job.name == "vanilla" then
		TriggerServerEvent("QBCore:ToggleDuty")
	    end
	end
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)


-----------
--- Blip
-----------

Citizen.CreateThread(function()
	for _, info in pairs(Config.BlipLocation) do
		if Config.UseBlips then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipSprite(info.blip, info.id)
			SetBlipDisplay(info.blip, 4)
			SetBlipScale(info.blip, 0.6)	
			SetBlipColour(info.blip, info.colour)
			SetBlipAsShortRange(info.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(info.title)
			EndTextCommandSetBlipName(info.blip)
		end
	end	
end)

-----------
--- Ped
-----------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		for k,v in pairs(Config.PedList) do
			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = #(playerCoords - v.coords.xyz)

			if distance < Config.DistanceSpawn and not spawnedPeds[k] then
				local spawnedPed = NearPed(v.model, v.coords, v.gender, v.animDict, v.animName, v.scenario)
				spawnedPeds[k] = { spawnedPed = spawnedPed }
			end

			if distance >= Config.DistanceSpawn and spawnedPeds[k] then
				if Config.FadeIn then
					for i = 255, 0, -51 do
						Citizen.Wait(50)
						SetEntityAlpha(spawnedPeds[k].spawnedPed, i, false)
					end
				end
				DeletePed(spawnedPeds[k].spawnedPed)
				spawnedPeds[k] = nil
			end
		end
	end
end)

function NearPed(model, coords, gender, animDict, animName, scenario)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(50)
	end

	if Config.MinusOne then
		spawnedPed = CreatePed(Config.GenderNumbers[gender], model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
	else
		spawnedPed = CreatePed(Config.GenderNumbers[gender], model, coords.x, coords.y, coords.z, coords.w, false, true)
	end

	SetEntityAlpha(spawnedPed, 0, false)

	if Config.Frozen then
		FreezeEntityPosition(spawnedPed, true)
	end

	if Config.Invincible then
		SetEntityInvincible(spawnedPed, true)
	end

	if Config.Stoic then
		SetBlockingOfNonTemporaryEvents(spawnedPed, true)
	end

	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(50)
		end

		TaskPlayAnim(spawnedPed, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end

    if scenario then
        TaskStartScenarioInPlace(spawnedPed, scenario, 0, true)
    end

	if Config.FadeIn then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(spawnedPed, i, false)
		end
	end

	return spawnedPed
end

------------
-- Events
------------

RegisterNetEvent("ss-vanilla:Duty")
AddEventHandler("ss-vanilla:Duty", function()
    TriggerServerEvent("QBCore:ToggleDuty")
end)

RegisterNetEvent("ss-vanilla:shop", function(index)
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "vanilla", {
        label = "vanilla",
        items = Config.Items,
        slots = #Config.Items,
    })
end);

RegisterNetEvent("ss-vanilla:BossShop", function(index)
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "vanillaboss", {
        label = "Vanilla Boss Shop",
        items = Config.Boss,
        slots = #Config.Boss,
    })
end);

RegisterNetEvent("ss-vanilla:Storage")
AddEventHandler("ss-vanilla:Storage", function()
    TriggerEvent("inventory:client:SetCurrentStash", "vanillastorage")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "vanillastorage", {
        maxweight = 250000,
        slots = 40,
    })
end)

RegisterNetEvent('ss-vanilla:garage:SpawnVehicle')
AddEventHandler('ss-vanilla:garage:SpawnVehicle', function(vanilla)
    print("Made by Stormy Scratch")
    local vehicle = vanilla.vehicle 
    local coords = { ['x'] = 24.95, ['y'] = -1590.2, ['z'] = 29.09, ['h'] = 229.33 }
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "VANILLA"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        SetEntityHeading(veh, coords.h)
        SetVehicleModKit(Veh, 0)        
        SetVehicleLivery(Veh, 1)
        SetVehicleMod(Veh, 48, 3, false)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, false, false)
    end, coords, true)
end)

RegisterNetEvent('ss-vanilla:garage:StoreVehicle')
AddEventHandler('ss-vanilla:garage:StoreVehicle', function()
    print("Made by Stormy Scratch")
    QBCore.Functions.Notify('Vehicle Stored!')
    local car = GetVehiclePedIsIn(PlayerPedId(),true)
    DeleteVehicle(car)
    DeleteEntity(car)
end)

RegisterNetEvent('ss-vanilla:Grab:Apple')
AddEventHandler('ss-vanilla:Grab:Apple', function(data)
    QBCore.Functions.Progressbar("grab", "Grabing An Apple...", 4000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@normal",
		anim = "pour_one",
		flags = 49,
	}, {}, {}, function()
		QBCore.Functions.Notify("You Grabed An Apple!", "success")
		TriggerServerEvent("QBCore:Server:AddItem", "apple", 1)
		TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["apple"], "add", 1)
	end, function()
		QBCore.Functions.Notify("Canceled...", "error")
	end)
end)

RegisterNetEvent('ss-vanilla:Grab:Banana')
AddEventHandler('ss-vanilla:Grab:Banana', function(data)
    QBCore.Functions.Progressbar("grab", "Grabing A Banana...", 4000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@normal",
		anim = "pour_one",
		flags = 49,
	}, {}, {}, function()
		QBCore.Functions.Notify("You Grabed A Banana!", "success")
		TriggerServerEvent("QBCore:Server:AddItem", "banana", 1)
		TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["banana"], "add", 1)
	end, function()
		QBCore.Functions.Notify("Canceled...", "error")
	end)
end)

RegisterNetEvent('ss-vanilla:Grab:Orange')
AddEventHandler('ss-vanilla:Grab:Orange', function(data)
    QBCore.Functions.Progressbar("grab", "Grabing A Orange...", 4000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@normal",
		anim = "pour_one",
		flags = 49,
	}, {}, {}, function()
		QBCore.Functions.Notify("You Grabed An Orange!", "success")
		TriggerServerEvent("QBCore:Server:AddItem", "orange", 1)
		TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["orange"], "add", 1)
	end, function()
		QBCore.Functions.Notify("Canceled...", "error")
	end)
end)

RegisterNetEvent('ss-vanilla:Grab:Ice')
AddEventHandler('ss-vanilla:Grab:Ice', function(data)
    QBCore.Functions.Progressbar("grab", "Grabing An Ice...", 4000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@normal",
		anim = "pour_one",
		flags = 49,
	}, {}, {}, function()
		QBCore.Functions.Notify("You Grabed An Ice!", "success")
		TriggerServerEvent("QBCore:Server:AddItem", "ice", math.random(2,5))
		TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["ice"], "add", math.random(2,5))
	end, function()
		QBCore.Functions.Notify("Canceled...", "error")
	end)
end)

RegisterNetEvent('ss-vanilla:OpenMenu')
AddEventHandler('ss-vanilla:OpenMenu', function()
  	SetNuiFocus(false, false)
  	SendNUIMessage({action = 'OpenMenu'})
	Citizen.CreateThread(function()
        while true do
			ShowHelpNotification("Press ~INPUT_FRONTEND_RRIGHT~ To Exit")
			if IsControlJustReleased(0, 177) then
				TriggerEvent("ss-vanilla:CloseMenu")
				PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
				break
			end
			Citizen.Wait(1)
		end
	end)
end)

RegisterNetEvent('ss-vanilla:CloseMenu')
AddEventHandler('ss-vanilla:CloseMenu', function()
  	SetNuiFocus(false, false)
  	SendNUIMessage({action = 'CloseMenu'})
end)

RegisterNetEvent("ss-vanilla:MakeAppleDrink")
AddEventHandler("ss-vanilla:MakeAppleDrink", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('ss-vanilla:server:get:appledrink', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("make_drink", "Making An Apple Drink..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@normal",
					anim = "pour_one",
					flags = 8,
				}, {}, {}, function() -- Done
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					TriggerServerEvent('QBCore:Server:RemoveItem', "ice", 2)
					TriggerServerEvent('QBCore:Server:RemoveItem', "apple", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "brandy", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "appledrink", 1)
                    QBCore.Functions.Notify("You made a Apple Drink!", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	end  
end)

RegisterNetEvent("ss-vanilla:MakeBananaDrink")
AddEventHandler("ss-vanilla:MakeBananaDrink", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('ss-vanilla:server:get:bananadrink', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("make_drink", "Making A Banana Drink..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@normal",
					anim = "pour_one",
					flags = 8,
				}, {}, {}, function() -- Done
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					TriggerServerEvent('QBCore:Server:RemoveItem', "ice", 2)
					TriggerServerEvent('QBCore:Server:RemoveItem', "banana", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "whiterum", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "bananadrink", 1)
                    QBCore.Functions.Notify("You made a Banana Drink!", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	end  
end)

RegisterNetEvent("ss-vanilla:MakeOrangeDrink")
AddEventHandler("ss-vanilla:MakeOrangeDrink", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('ss-vanilla:server:get:orangedrink', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("make_drink", "Making An Orange Drink..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@normal",
					anim = "pour_one",
					flags = 8,
				}, {}, {}, function() -- Done
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					TriggerServerEvent('QBCore:Server:RemoveItem', "ice", 2)
					TriggerServerEvent('QBCore:Server:RemoveItem', "orange", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "whiterum", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "orangedrink", 1)
                    QBCore.Functions.Notify("You made an Orange Drink!", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	end  
end)

----------------
-- Functions
----------------

function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-------------
-- Target
-------------

Citizen.CreateThread(function()

	exports[Config.Target]:AddBoxZone("Duty", vector3(132.99, -1286.07, 29.27), 0.5, 0.5, {
		name="Duty",
		heading=30,
		debugPoly=Config.PolyZone,
		minZ=29.3,
		maxZ=30.0,
	}, {
		options = {
		    {  
			    event = "ss-vanilla:Duty",
			    icon = "far fa-clipboard",
			    label = "Clock On/Off",
                job = Config.Job,
		    },
		},
		distance = 1.5
	})

    exports[Config.Target]:AddBoxZone("BossMenu", vector3(93.78, -1294.56, 29.26), 2.5, 1, {
		name="BossMenu",
		heading=30,
		debugPoly=Config.PolyZone,
		minZ=28.26,
		maxZ=29.5,
	}, {
        options = {
            {
              event = "qb-bossmenu:client:OpenMenu",
              icon = "fas fa-th-list",
              label = "Access Boss Menu",
              type = "client",
              job = Config.Job,
              canInteract = function()
                  return QBCore.PlayerData.job.isboss
              end,
            },
        },
        distance = 1.5
    })

    exports[Config.Target]:AddBoxZone("BossShop", vector3(92.93, -1290.77, 29.26), 1, 1, {
        name="BossShop",
        heading=30,
        debugPoly=Config.PolyZone,
        minZ=28.26,
        maxZ=30.26,
    }, {
        options = {
            {
                event = "ss-vanilla:BossShop",
                icon = "fas fa-glass-cheers",
                label = "Open Boss Drink Menu",
                job = Config.Job,
                canInteract = function()
                    return QBCore.PlayerData.job.isboss
                end,
            },
        },
        distance = 1.5
    })

    exports[Config.Target]:AddBoxZone("Fridge", vector3(130.05, -1280.55, 29.27), 1, 1.5, {
        name="Fridge",
        heading=300,
        debugPoly=Config.PolyZone,
        minZ=28.27,
        maxZ=29.2,
    }, {
        options = {
            {
                event = "ss-vanilla:shop",
                icon = "fas fa-glass-cheers",
                label = "Open Shop",
                job = Config.Job,
            },
        },
        distance = 1.5
    })

    exports[Config.Target]:AddBoxZone("Storage", vector3(131.8, -1283.92, 29.27), 0.7, 0.7, {
        name="Storage",
        heading=30,
        debugPoly=Config.PolyZone,
        minZ=28.27,
        maxZ=29.2,
    }, {
        options = {
            {
                event = "ss-vanilla:Storage",
                icon = "fas fa-box",
                label = "Open Storage",
                job = Config.Job,
            },
        },
        distance = 1.5
    })

    exports[Config.Target]:AddBoxZone("MakeShot", vector3(16.14, -1597.64, 29.38), 0.7, 2, {
        name="MakeShot",
        heading=140,
        debugPoly=Config.PolyZone,
        minZ=28.0,
        maxZ=30.0,
    }, {
        options = {
            {
                event = "qb-menu:vanilla",
                icon = "fas fa-box",
                label = "Make vanilla",
                job = Config.Job,
            },
        },
        distance = 1.5
    })

    exports[Config.Target]:AddBoxZone("Garage", vector3(135.77, -1279.07, 29.36), 0.7, 0.7, {
        name="Garage",
        heading=30,
        debugPoly=Config.PolyZone,
        minZ=28.37,
        maxZ=30.4,
    }, {
        options = {
            {
                event = "qb-menu:vanillaGarage",
                icon = "fas fa-car",
                label = "vanilla Garage",
                job = Config.Job,
            },
        },
        distance = 3.5
    })

    exports[Config.Target]:AddBoxZone("Clothing", vector3(109.24, -1304.12, 28.79), 0.8, 2.4, {
        name="Clothing",
        heading=123.1,
        debugPoly=Config.PolyZone,
        minZ=28.0,
        maxZ=30.5,
    }, {
        options = {
            {
                event = "qb-clothing:client:openMenu",
                icon = "fas fa-tshirt",
                label = "Open Clothing Menu",
                job = Config.Job,
            },
        },
        distance = 1.5
    })

    exports[Config.Target]:AddBoxZone("GrabFruit", vector3(130.8, -1281.37, 29.27), 0.4, 0.5, {
        name="GrabFruit",
        heading=30,
        debugPoly=Config.PolyZone,
        minZ=29.0,
        maxZ=30.0,
    }, {
        options = {
            {
                event = "qb-menu:fruit:menu",
                icon = "fas fa-lemon",
                label = "Grab Fruits",
                job = Config.Job,
            },
        },
        distance = 1.5
    })

    exports[Config.Target]:AddBoxZone("GrabIce", vector3(127.77, -1281.96, 29.27), 0.8, 0.8, {
        name="GrabIce",
        heading=30,
        debugPoly=Config.PolyZone,
        minZ=28.27,
        maxZ=29.27,
    }, {
        options = {
            {
                event = "ss-vanilla:Grab:Ice",
                icon = "fas fa-cube",
                label = "Grab Ice",
                job = Config.Job,
            },
        },
        distance = 1.5
    })

    exports[Config.Target]:AddBoxZone("MakeDrink", vector3(128.15, -1283.06, 29.27), 0.35, 0.8, {
        name="MakeDrink",
        heading=300,
        debugPoly=Config.PolyZone,
        minZ=29.27,
        maxZ=29.8,
    }, {
        options = {
            {
                event = "qb-menu:drink:menu",
                icon = "fas fa-wine-glass",
                label = "Make Drink",
                job = Config.Job,
            },
        },
        distance = 1.5
    })

end)


------------
-- QB Menu
------------

RegisterNetEvent('qb-menu:fruit:menu', function(data)
    TriggerEvent('qb-menu:client:openMenu', {
        {
            id = 0,
            header = "🍉 | Available Fruits | 🍉",
            txt = "",
        },
        {
            id = 1,
            header = "🍌 • Banana",
            txt = "Grab A Banana",
            params = {
                event = "ss-vanilla:Grab:Banana"
            }
        },
        {
            id = 2,
            header = "🍏 • Apple",
            txt = "Grab An Apple",
            params = {
                event = "ss-vanilla:Grab:Apple"
            }
        },
        {
            id = 3,
            header = "🍊 • Orange",
            txt = "Grab An Orange",
            params = {
                event = "ss-vanilla:Grab:Orange"
            }
        },
        {
            id = 4,
            header = "⬅ Close",
            txt = '',
            params = {
                event = 'qb-menu:closeMenu',
            }
        }
    })
end)

RegisterNetEvent('qb-menu:drink:menu', function(data)
    TriggerEvent('qb-menu:client:openMenu', {
        {
            id = 0,
            header = "🍷 | Make Drinks | 🍷",
            txt = "",
        },
        {
            id = 1,
            header = "🍺 • Banana Drink",
            txt = "Banana, Ice, White Rum",
            params = {
                event = "ss-vanilla:MakeBananaDrink"
            }
        },
        {
            id = 2,
            header = "🍸 • Apple Drink",
            txt = "Apple, Ice, Brandy",
            params = {
                event = "ss-vanilla:MakeAppleDrink"
            }
        },
        {
            id = 3,
            header = "🍹 • Orange Drink",
            txt = "Orange, Ice, White Rum",
            params = {
                event = "ss-vanilla:MakeOrangeDrink"
            }
        },
        {
            id = 4,
            header = "⬅ Close",
            txt = '',
            params = {
                event = 'qb-menu:closeMenu',
            }
        }
    })
end)

RegisterNetEvent('qb-menu:vanillaGarage', function(data)
    TriggerEvent('qb-menu:client:openMenu', {
        {
            id = 1,
            header = "🍷 | Vanilla Garage | 🍷",
            txt = ""
        },
        {
            id = 2,
            header = "🚘 • Vanilla Car",
            txt = "Vanilla Car",
            params = {
                event = "ss-vanilla:garage:SpawnVehicle",
                args = {
                    vehicle = 'xa21',
                    
                }
            }
        },
        {
            id = 3,
            header = "🅿 Store Vehicle",
            txt = "Store Vehicle Inside Garage",
            params = {
                event = "ss-vanilla:garage:StoreVehicle",
                args = {
                    
                }
            }
        },      
        {
            id = 4,
            header = "⬅ Close Menu",
            params = {
                event = "qb-menu:client:closeMenu", 
            }
        },  
    })
end)
