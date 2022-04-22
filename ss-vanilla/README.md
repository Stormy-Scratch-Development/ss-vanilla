## Dependencies :

QBCore Framework - https://github.com/QBCore-framework/qb-core

PolyZone - https://github.com/mkafrin/PolyZone

qb-target - https://github.com/BerkieBb/qb-target / https://github.com/loljoshie/qb-target

qb-menu - https://github.com/QBCore-framework/qb-menu / https://github.com/loljoshie/qb-menu

qb-management - https://github.com/QBCore-framework/qb-management

qb-smallresources - https://github.com/QBCore-framework/qb-smallresources

qb-clothing - https://github.com/QBCore-framework/qb-clothing

Gabz Vanilla mlo - https://fivem.gabzv.com/package/4724693


## Credits : 

ss-vanilla job script by Stormy Scratch https://discord.gg/BZnUFcUKRT

## Insert into #qb-core --> shared
1. Insert this lines to your qb-core/shared/items.lua

	--Vanilla 

	--Fruits
	["apple"] 	 				 	 = {["name"] = "apple",       	  				["label"] = "Apple",	 		["weight"] = 100, 		["type"] = "item", 		["image"] = "apple.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["banana"] 	 				 	 = {["name"] = "banana",       	  				["label"] = "Banana",	 		["weight"] = 100, 		["type"] = "item", 		["image"] = "banana.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["orange"] 	 				 	 = {["name"] = "orange",       	  				["label"] = "Orange",	 		["weight"] = 100, 		["type"] = "item", 		["image"] = "orange.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},

	--Ice
	["ice"] 	 				     = {["name"] = "ice",       	  				["label"] = "Ice", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "ice.png", 					["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},

	--Menu
	['vumenu'] 	         	 		 = {['name'] = 'vumenu', 						['label'] = 'Vanilla Unicorn Menu', 		['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'vumenu.png', 				['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Menu'},

	--Drinks
	["appledrink"] 			         = {["name"] = "appledrink", 					["label"] = "Apple Drink", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "appledrink.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "An Apple Drink."},
	["bananadrink"] 			     = {["name"] = "bananadrink", 					["label"] = "Banana Drink", 			["weight"] = 125, 		["type"] = "item", 		["image"] = "bananadrink.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "A Banana Drink."},
	["orangedrink"] 			     = {["name"] = "orangedrink", 					["label"] = "Orange Drink", 			["weight"] = 125, 		["type"] = "item", 		["image"] = "orangedrink.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "An Orange Drink."},
	["whiterum"] 			         = {["name"] = "whiterum", 						["label"] = "White Rum", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "whiterum.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "White Rum."},
	["brandy"] 					     = {["name"] = "brandy", 						["label"] = "Brandy", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "brandy.png", 					["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Brandy."},


2.  Insert this lines to your qb-core/shared/jobs.lua

	["vanilla"] = {
		label = "Vanilla Employee",
		defaultDuty = true,
		grades = {
			['1'] = {
                name = "Employee",
                payment = 75
            },
			['2'] = {
                name = "Shift Manager",
                payment = 100
            },
			['3'] = {
                name = "Manager",
                payment = 125
            },
			['4'] = {
                name = "CEO",
				isboss = true,
                payment = 150
            },
        },
	},

## Inventory images

drag and drop the image from ss-vanilla/images to qb-inventory\html\images (if the images is big for your inv just open a ticket on our discord server and we will help u!)

## Insert into #qb-smallresources --> config.lua
ConsumeablesAlcohol = {
    ["appledrink"] = math.random(50, 60),
    ["orangedrink"] = math.random(50, 60),
    ["bananadrink"] = math.random(50, 60),
    ["brandy"] = math.random(70, 80),
    ["whiterum"] = math.random(70, 80),
}

## Insert into #server.cfg
ensure ss-vanilla

restart your server and you are done! enjoy❤