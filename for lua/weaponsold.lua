--
local basedata = {
  handgun = {Isaac.GetItemIdByName("Handgun"), "gun_pistol", 10},
	punishinghandgun = {Isaac.GetItemIdByName("Punishing Handgun"), "gun_punishme", 17},
	luckyburst = {Isaac.GetItemIdByName("Lucky Burst"), "gun_burstgun", 26},
	machinepistol = {Isaac.GetItemIdByName("Machine Pistol"), "gun_machinepistol", 16},
	pumpactionshotgun = {Isaac.GetItemIdByName("Pump-Action Shotgun"), "gun_shotgun", 20},
	autoshotgun = {Isaac.GetItemIdByName("Auto Shotgun"), "gun_autoshotgun", 24},
	assaultshotgun = {Isaac.GetItemIdByName("Assault Shotgun"), "gun_riotgun", 28},
	assaultrifle = {Isaac.GetItemIdByName("Assault Rifle"), "gun_assaultrifle", 32},
	rustytypewriter = {Isaac.GetItemIdByName("Rusty Typewriter"), "gun_tommy", 34},
	smg = {Isaac.GetItemIdByName("SMG"), "gun_smg", 18},
	boltsniper = {Isaac.GetItemIdByName("Bolt Sniper"), "gun_rifle", 28},
	heavysniper = {Isaac.GetItemIdByName("Heavy Sniper"), "gun_antimaterial", 45},
	magnum = {Isaac.GetItemIdByName("Magnum"), "gun_magnum", 20},
	dualrevolvers = {Isaac.GetItemIdByName("Dual Revolvers"), "gun_revolver", 16},
	minigun = {Isaac.GetItemIdByName("Minigun"), "gun_gatling", 42},
	machinegun = {Isaac.GetItemIdByName("Machine Gun"), "gun_machinegun", 38},
	--chainsaw = {Isaac.GetItemIdByName("Chainsaw"), "gun_chainsaw"},
	flamethrower = {Isaac.GetItemIdByName("Flamethrower"), "gun_flamethrower", 32},
	--grenadelauncher = {Isaac.GetItemIdByName("Grenade Launcher"), "gun_grenadelauncher"},
	--rocketlauncher = {Isaac.GetItemIdByName("Rocket Launcher"), "gun_rpg"},
}

gunmod_ACTIVEWEPS = {}

gunmod_WEP = {
  BaseId = {},
  BaseSprite = {},
  BaseLength = {},
}

for i, v in pairs(basedata) do
  gunmod_WEP.BaseId[i] = v[1] -- ultimately unneeded
  gunmod_WEP.BaseSprite[i] = gunmod_CONST.gungfxroot..v[2]..".png"
  gunmod_WEP.BaseLength[i] = v[3]
end

local EAM = gunmod_CONST.EN.AM; local EFM = gunmod_CONST.EN.FM
local ESP = gunmod_CONST.EN.SP

gunmod_WEP.WeaponTypes = {
  default = {
    meta = {
    },
    --Info
    name = "Nameless Gun",
    base = 'punishinghandgun',
    description = 'the primordial gun',
    rank = 1,
    --Special Modifiers
    copies = {0, 0, 0, 1},
    sp = {},
    mods = {},
    tf = {},
    --Additive Character Stats (first)
    as = {
      movespeed = 0, damage = 0, maxfiredelay = 0,
      shotspeed = 0, range = 0, luck = 0,
    },
    --Multiplicative Character Stats (second)
    ms = {
      movespeed = 1, damage = 1, maxfiredelay = 1,
      shotspeed = 1, range = 1, luck = 1,
    },
    --Clip Vars
    ammotype = EAM.assault,
    firemode = EFM.auto,
    clipsize = 24,
    reloadtime = 30,
    --Firing Vars
    burst = 1,
    maxchamber = 1,
    minshots = 1,
    pellets = 1,
    damagemult = 1,
    sizemult = 1,
    ammocost = 1,
    spreadmin = 0,
    spreadmax = 10,
    spreadloss = 1,
    spreadgain = .5,
    --Charge vars
    --chargemin = .5,
    --chargebonus = 1.25,
    --critconfuse = 0,
    critframes = 99999,
    --Physics Vars
    recoil = 1.5,
    screenshake = 1,
    knockback = .3,
    velocity = 1.5,
    aimspeed = 15,
    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 2}, str = 'clip +2'},
      {add = {clipsize = 3}, str = 'clip +3'},
      {add = {clipsize = 4}, str = 'clip +4'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 6}, str = 'clip +6'},
    },
  },
  handgun = {
    meta = {
      parent = 'default',
    },
  	name = "Handgun",
  	base = 'handgun',
  	description = "A standard 9mm handgun",
  	rank = 1,
  	ammotype = EAM.pistol,
  	recoil = 3,
  	screenshake = 3,
  	screenshakecrit = 5,
  	firemode = EFM.charge,

  	chargescale = true,
  	chargemin = 2.5/4,
  	critbonus = 8/4,
  	critframes = 15,
  	critconfuse = 45, -- + 15 from shotspeed

  	reloadtime = 55,
  	clipsize = 6,
  	spreadmin = 0,
  	spreadmax = 8,
  	velocity = 1.5,

  	as = {
  		damage = 4 - 3.5,
  		maxfiredelay = 8 - 10,
  	},
  	ms = {
  		range = .7,--16 / 23.75,
  	},
  	bonus = {
  		clipsize = {1, 1, 2, 2, 3, 3},
  	},
  },
  punishinghandgun = {
    meta = {
      parent = 'default',
    },
  	name = "Punishing Handgun",
  	base = 'punishinghandgun',
  	description = "Blast a hole through multiple enemies!",
  	rank = 1,
  	ammotype = EAM.pistol,
  	recoil = 3,
  	screenshake = 3,
  	screenshakecrit = 5,
  	firemode = EFM.charge,

  	tf = {TearFlags.TEAR_PIERCING},

  	chargescale = true,
  	chargemin = .75,
  	critbonus = 2,
  	critframes = 15,
  	critconfuse = 30,

  	reloadtime = 55,
  	clipsize = 18,
  	spreadmin = 0,
  	spreadmax = 6,
  	velocity = 1.6,

  	as = {
  		maxfiredelay = 12 - 10,
  	},
  	ms = {
  		range = .75,--20 / 23.75,
  	},
  },
  luckyburst = {
    meta = {
      parent = 'default',
    },
  	name = "Lucky Burst",
  	base = 'luckyburst',
  	description = "Uses up ammo quickly...",
  	rank = 2,
  	ammotype = EAM.pistol,
  	recoil = 1,
  	screenshake = 3,
  	screenshakecrit = 5,
  	firemode = EFM.auto,

  	maxchamber = 3,
  	burst = 3,

  	knockback = .05,
  	reloadtime = 45,
  	clipsize = 15,
  	spreadmin = 3,
  	spreadmax = 12,
  	velocity = 1.5,

  	as = {
  		maxfiredelay = 12 - 10,
  		luck = 4
  	},
  	ms = {
  		range = .65
  	},
  },
  machinepistol = {
    meta = {
      parent = 'default',
    },
  	name = "Machine Pistol",
  	base = 'machinepistol',
  	description = "A fully-automatic machine pistol",
  	rank = 3,
  	ammotype = EAM.pistol,
  	recoil = 2,
  	screenshake = 3,
  	screenshakecrit = 5,
  	firemode = EFM.auto,

  	knockback = .15,
  	reloadtime = 55,
  	clipsize = 20,
  	spreadmin = 0,
  	spreadmax = 15,
  	velocity = 1.5,

  	as = {
  		maxfiredelay = 4 - 10,
  	},
  	ms = {
  		range = .55,--13 / 23.75,
  	},
  },
  pumpactionshotgun = {
    meta = {
      parent = 'default',
    },
  	name = "Pump-Action Shotgun",
  	base = 'pumpactionshotgun',
  	description = "Don't leave home without it",
  	rank = 1,
  	ammotype = EAM.shotgun,
  	recoil = 5,
  	screenshake = 5,
  	firemode = EFM.auto,

  	shakemod = 0,
  	reloadtime = 13,
  	reloadbullet = 13,
  	clipsize = 6,
  	spreadmax = 30,
  	spreadmin = 30,
  	velocity = 1.4,
  	pellets = 5,
  	fanshot = true,
  	damagemult = (1/5) * 2,
  	sizemult = .7,
  	knockback = .05,

  	as = {
  		damage = 4.5 - 3.5,
  		maxfiredelay = 18 - 10,
  	},
  	ms = {
  		range = .5,--12 / 23.75,
  	},
  },
  autoshotgun = {
    meta = {
      parent = 'default',
    },
  	name = "Auto Shotgun",
  	base = 'autoshotgun',
  	description = "Wide shot, fast firing",
  	rank = 2,
  	ammotype = EAM.shotgun,
  	recoil = 5,
  	screenshake = 5,
  	firemode = EFM.auto,

  	shakemod = 0,
  	reloadtime = 100,
  	clipsize = 6,
  	spreadmax = 44,
  	spreadmin = 44,
  	velocity = 1.4,
  	pellets = 6,
  	fanshot = true,
  	damagemult = 1/6 * 2,
  	sizemult = .7,
  	knockback = .05,

  	as = {
  		damage = 4 - 3.5,
  		maxfiredelay = 6 - 10,
  	},
  	ms = {
  		range = .45,--10 / 23.75,
  	},
  	bonus = {
  		clipsize = {1, 1, 1, 1, 1, 9},
  	},
  },
  assaultshotgun = {
    meta = {
      parent = 'default',
    },
  	name = "Assault Shotgun",
  	base = 'assaultshotgun',
  	description = "Low spread, high range",
  	rank = 2,
  	ammotype = EAM.shotgun,
  	recoil = 5,
  	screenshake = 5,
  	firemode = EFM.charge,

  	chargescale = true,
  	chargemin = 1,
  	critbonus = 1.5,
  	critframes = 15,
  	critconfuse = 15,

  	shakemod = 0,
  	reloadtime = 6,
  	reloadbullet = 12,
  	clipsize = 8,
  	spreadmax = 30,
  	spreadmin = 13,
  	velocity = 1.4,
  	pellets = 4,
  	fanshot = true,
  	damagemult = 1/4 * 2,
  	sizemult = .7,
  	knockback = .05,

  	as = {
  		damage = 4 - 3.5,
  		maxfiredelay = 12 - 10,
  	},
  	ms = {
  		range = .65,--15 / 23.75,
  	},
  },
  assaultrifle = {
    meta = {
      parent = 'default',
    },
  	name = "Assault Rifle",
  	base = 'assaultrifle',
  	description = "Spray and pray",
  	rank = 2,
  	ammotype = EAM.assault,
  	recoil = 1.5,
  	screenshake = 1,
  	firemode = EFM.auto,

  	reloadtime = 50,
  	clipsize = 30,
  	spreadmax = 20,
  	knockback = .3,
  	velocity = 1.5,
  	aimspeed = 15,

  	as = {
  		damage = 5 - 3.5,
  		maxfiredelay = 12 - 10,
  	},
  	ms = {
  		damage = .5,
  		maxfiredelay = .5,
  		range = .85,--20 / 23.75,
  	},
  },
  rustytypewriter = {
    meta = {
      parent = 'default',
    },
  	name = "Rusty Typewriter",
  	base = 'rustytypewriter',
  	description = "It might jam...",
  	rank = 3,
  	ammotype = EAM.assault,
  	recoil = 1.5,
  	firemode = EFM.auto,

  	sp = {ESP.jams},

  	reloadtime = 50,
  	clipsize = 30,
  	spreadmax = 25,
  	knockback = .5,
  	velocity = 1.5,
  	aimspeed = 15,

  	as = {
  		damage = 7 - 3.5,
  		maxfiredelay = 8 - 10,
  		luck = -3,
  	},
  	ms = {
  		damage = .5,
  		maxfiredelay = .5,
  		range = .65,--16 / 23.75,
  	},
  },
  smg = {
    meta = {
      parent = 'default',
    },
  	name = "SMG",
  	base = 'smg',
  	description = "Many bullets!",
  	rank = 3,
  	ammotype = EAM.assault,
  	recoil = 1,
  	firemode = EFM.auto,

  	pellets = 2,
  	damagemult = 1/2,

  	reloadtime = 25,
  	clipsize = 20,
  	spreadmin = 5,
  	spreadmax = 55,
  	spreadgain = 1.25,
  	knockback = .15,
  	velocity = 1.5,
  	aimspeed = 15,

  	as = {
  		damage = 5 - 3.5,
  		maxfiredelay = 6 - 10,
  	},
  	ms = {
  		damage = .5,
  		maxfiredelay = .5,
  		range = .65,--15 / 23.75,
  	},
  },
  boltsniper = {
    meta = {
      parent = 'default',
    },
  	name = "Bolt Sniper",
  	base = 'boltsniper',
  	description = "Aim for the head",
  	rank = 1,
  	ammotype = EAM.sniper,
  	recoil = 6,
  	screenshake = 4,
  	screenshakecrit = 6,
  	firemode = EFM.charge,

  	chargescale = true,
  	chargemin = .5,
  	critbonus = 2.5,
  	critframes = 10,
  	critconfuse = 80,

  	reloadtime = 80,
  	clipsize = 5,
  	spreadmax = 15,
  	spreadmin = 0,
  	spreadloss = 2,
  	velocity = 1.8,
  	aimspeed = 10,

  	as = {
  		damage = 8 - 3.5,
  		maxfiredelay = 18 - 10,
  	},
  	ms = {
  		range = 1.25,--30 / 23.75,
  	},
  },
  heavysniper = {
    meta = {
      parent = 'default',
    },
  	name = "Heavy Sniper",
  	base = 'heavysniper',
  	description = "Aim for anything",
  	rank = 3,
  	ammotype = EAM.sniper,
  	recoil = 12,
  	screenshake = 4,
  	screenshakecrit = 8,
  	firemode = EFM.charge,

  	tf = {TearFlags.TEAR_ACID},

  	chargescale = true,
  	chargemin = .5,
  	critbonus = 2.5,
  	critframes = 10,
  	critconfuse = 120,

  	reloadtime = 80,
  	clipsize = 6,
  	spreadmax = 15,
  	spreadmin = 0,
  	velocity = 1.8,
  	aimspeed = 15,

  	as = {
  		damage = 10 - 3.5,
  		maxfiredelay = 28 - 10,
  	},
  	ms = {
  		range = 1.5,--30 / 23.75,
  	},
  },
  magnum = {
    meta = {
      parent = 'default',
    },
  	name = "Magnum",
  	base = 'magnum',
  	description = "Powerful against living things",
  	rank = 3,
  	ammotype = EAM.magnum,
  	recoil = 3,
  	screenshake = 5,
  	firemode = EFM.auto,

  	reloadtime = 90,
  	clipsize = 6,
  	spreadmin = 0,
  	spreadmax = 3,
  	velocity = 1.8,
  	sizemult = .5,

  	as = {
  		damage = 30 - 3.5,
  		maxfiredelay = 15 - 10,
  		luck = 1,
  	},
  	ms = {
  		range = .85,--20 / 23.75,
  	},
  },
  dualrevolvers = {
    meta = {
      parent = 'default',
    },
  	name = "Dual Revolvers",
  	base = 'dualrevolvers',
  	description = "They're pretty good",
  	rank = 3,
  	ammotype = EAM.magnum,
  	recoil = 2,
  	screenshake = 4,
  	firemode = EFM.auto,

  	copies = {0, 0, 0, 2},
  	sp = {ESP.noarc},
  	tf = {TearFlags.TEAR_BOUNCE},

  	reloadtime = 15,
  	reloadbullet = 10,
  	clipsize = 6,
  	spreadmin = 0,
  	spreadmax = 1,
  	velocity = 1.8,
  	sizemult = .75,

  	as = {
  		damage = 12 - 3.5,
  		maxfiredelay = 12 - 10,
  	},
  	ms = {
  		range = 3,--80 / 23.75,
  	},
  },
  minigun = {
    meta = {
      parent = 'default',
    },
  	name = "Minigun",
  	base = 'minigun',
  	description = "Eeeyaugh!",
  	rank = 3,
  	ammotype = EAM.nato,
  	recoil = .4,
  	firemode = EFM.auto,

  	reloadtime = 150,
  	clipsize = 20,
  	spreadmin = 15,
  	spreadmax = 20,
  	knockback = .4,
  	velocity = 1.5,
  	aimspeed = 8,
  	pellets = 3,
  	damagemult = 1/3,

  	revtime = 20,
  	ammocost = 1/8,

  	as = {
  		damage = 4 - 3.5,
  		maxfiredelay = 4 - 10,
  	},
  	ms = {
  		damage = .4,
  		movespeed = .35,
  		maxfiredelay = .5,
  		range = .75,--15 / 23.75,
  	},
  },
  machinegun = {
    meta = {
      parent = 'default',
    },
  	name = "Machine Gun",
  	base = 'machinegun',
  	description = "Now that's what I call backup!",
  	rank = 3,
  	ammotype = EAM.nato,
  	recoil = 4,
  	firemode = EFM.auto,

  	--sp = {ESP.cantstop},

  	reloadtime = 60,
  	clipsize = 20,
  	spreadmin = 5,
  	spreadmax = 15,
  	knockback = .3,
  	velocity = 1.5,
  	aimspeed = 10,

  	ammocost = 1/3,

  	as = {
  		damage = 6 - 3.5,
  		maxfiredelay = 8 - 10,
  	},
  	ms = {
  		damage = .5,
  		maxfiredelay = .5,
  		range = .75,--18 / 23.75,
  	},
  },
  flamethrower = {
    meta = {
      parent = 'default',
    },
  	name = "Flamethrower",
  	base = 'flamethrower',
  	description = "Hasta luego",
  	rank = 2,
  	ammotype = EAM.fuel,
  	recoil = .35,
  	firemode = EFM.auto,
  	shakemod = .2,

  	reloadtime = 35,
  	clipsize = 15,
  	spreadmax = 45,
  	spreadmin = 15,
  	spreadgain = .75,
  	velocity = 1.5,
  	aimspeed = 10,
  	ammocost = 1/8,

  	minshots = 8,

  	sp = {ESP.flamethrower},

  	as = {
  		damage = 10 - 3.5,
  		maxfiredelay = 4 - 10,
  	},
  	ms = {
  		maxfiredelay = .5,
  		damage = .5,
  		range = .85,--20 / 23.75,
  	},
  },
  --]]
}

error()
