Config = {};

Config.Invincible = true -- Is the ped going to be invincible?

Config.Frozen = true -- Is the ped frozen in place?

Config.Stoic = true -- Will the ped react to events around them?

Config.FadeIn = true -- Will the ped fade in and out based on the distance. (Looks a lot better.)

Config.DistanceSpawn = 20.0 -- Distance before spawning/despawning the ped. (GTA Units.)

Config.MinusOne = true -- Leave this enabled if your coordinates grabber does not -1 from the player coords.

Config.UseBlips = true -- Want to use blip on map?

Config.BlipLocation = {
    {title = "Vanilla", colour = 61, id = 121, x = 132.03, y = -1303.96, z = 29.22},  --Taco Blip
}

Config.Job = 'vanilla' -- Name for the job that can access the target etc

Config.Target = 'qb-target' -- Name of your target

Config.PolyZone = false -- Want to view all the qb-target poly zones?

Config.GenderNumbers = { -- No reason to touch these.
	['male'] = 4,
	['female'] = 5
}

Config.PedList = {
	{   -- Vanilla
		model = `s_m_m_movprem_01`, -- Model name as a hash.
		coords = vector4(135.85, -1279.08, 29.37, 300.77), -- Hawick Ave (X, Y, Z, Heading)
		gender = 'male' -- The gender of the ped, used for the CreatePed native.
	},
}

Config.Items = {
    [1] = {
        name = "whiterum",
        price = 0,
        amount = 10,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "brandy",
        price = 0,
        amount = 10,
        info = {},
        type = "item",
        slot = 2,
    },
    [3] = {
        name = "beer",
        price = 0,
        amount = 10,
        info = {},
        type = "item",
        slot = 3,
    },
}

Config.Boss = {
    [1] = {
        name = "beer",
        price = 0,
        amount = 10,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "whiskey",
        price = 0,
        amount = 10,
        info = {},
        type = "item",
        slot = 2,
    },
    [3] = {
        name = "vodka",
        price = 0,
        amount = 10,
        info = {},
        type = "item",
        slot = 3,
    },
    [4] = {
        name = "wine",
        price = 0,
        amount = 10,
        info = {},
        type = "item",
        slot = 4,
    },
}