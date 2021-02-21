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
	minigun = {Isaac.GetItemIdByName("Minigun"), "gun_gatling", 36},
	machinegun = {Isaac.GetItemIdByName("Machine Gun"), "gun_machinegun", 38},
	chainsaw = {Isaac.GetItemIdByName("Chainsaw"), "gun_chainsaw", 28},
	flamethrower = {Isaac.GetItemIdByName("Flamethrower"), "gun_flamethrower", 32},
	grenadelauncher = {Isaac.GetItemIdByName("Grenade Launcher"), "gun_grenadelauncher", 40},
	rocketlauncher = {Isaac.GetItemIdByName("Rocket Launcher"), "gun_rpg", 40},
}

gunmod_WEP = {
  BaseId = {},
  BaseSprite = {},
  BaseLength = {},
  IdList = {},
  TfList = {},
  TrigList = {},
}

local gWEP = gunmod_WEP

for i, v in pairs(basedata) do
  table.insert(gunmod_WEP.IdList, v[1])
  gunmod_WEP.BaseId[i] = v[1]
  gunmod_WEP.BaseSprite[i] = gunmod_CONST.gungfxroot..v[2]..".png"
  gunmod_WEP.BaseLength[i] = v[3]
end

local gCON = gunmod_CONST
local EAM = gunmod_CONST.EN.AM; local EFM = gunmod_CONST.EN.FM
local ESP = gunmod_CONST.EN.SP; local snd = gunmod_SFX
local ECP = gunmod_CONST.EN.CP;

gunmod_WEP.WeaponTypes = {
  --DEFAULTS
  default = {
    --Basic Info
    meta = {},
    name = "New Gun",
    description = 'it shoots',
    base = 'assaultrifle',
    rank = 1,

    --Unique modifiers
    copies = {0, 0, 0, 1},
    sp = {}, mods = {}, tf = {},
    fx = {}, trig = {},

    --Additive Character Stats (first)
    as = {
      movespeed = 0, damage = 0, maxfiredelay = 0,
      shotspeed = 0, range = 0, luck = 0,
    },

    --Multiplicative Character Stats (second)
    ms = {
      movespeed = 1, damage = 1, maxfiredelay = 1,
      shotspeed = 1, range = .75, luck = 1,
    },

    --Bullet/Clip Stats
    ammotype = EAM.assault, firemode = EFM.auto,
    clipsize = 24, reloadtime = 30, reloadbullet = 0,
    maxchamber = 1, burst = 1, minshots = 0, pellets = 1, ammoshots = 1,
    clipperfill = 6, shotsmult = 1, maxactivecharge = 1,

    --Shot/Firing Stats
    damagemult = 1, sizemult = 1,
    spreadmin = 0, spreadmax = 15, spreadloss = 1, spreadgain = .5,
    velocity = 1.5, recoil = 1.5, knockback = .25,
    screenshake = 0,

    --Charging Stats
    chargescale = false, chargemin = .75,
    critframes = 0, critconfuse = 0,

    --sounds
    sndshoot = {snd.shoot.rapid.light2, 1, 1}, sndlaser = {snd.shoot.laser.light, .6, 1},
    sndrl1 = {snd.cock.start2, 1, 1}, sndrl2 = {snd.cock.finish2, 1, 1}, sndshell = {snd.cock.shell, 1, 1},

    --Upgrading Stats
    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'}, -- 1
      {add = {clipsize = 1}, str = 'clip +1'}, -- 2
      {add = {clipsize = 1}, str = 'clip +1'}, -- 3
      {add = {clipsize = 1}, str = 'clip +1'}, -- 4
      {add = {clipsize = 1}, str = 'clip +1'}, -- 5
    },
  },
  defaultauto = {
    meta = {parent = 'default'},
    name = "New Automatic Gun",
    skill = gCON.Id.WSQuad,

    as = {damage = 1.5, maxfiredelay = 0},
    ms = {damage = .5, maxfiredelay = .5},

    clipsize = 20, reloadtime = 50, spreadmax = 20, knockback = .25,
  },
  defaultcharge = {
    meta = {parent = 'default'},
    name = "New Charged Gun",
    base = 'handgun',
    skill = gCON.Id.WSSight,

    ammotype = EAM.pistol, firemode = EFM.charge,
    recoil = 3, screenshakenocharge = 0, screenshake = 3, screenshakecrit = 5,

    clipsize = 6, spreadmax = 7, knockback = .75,

    chargescale = true, chargemin = .75, critbonus = 1.5,
    critframes = 15, critconfuse = 35,--25,

    as = {damage = .5, maxfiredelay = 2},

    sndshoot = {snd.shoot.hand.med, 1, 1}
  },
  --BASICS
  handgun = {
    meta = {parent = 'defaultcharge', forsale = true, rank = 1},
    name = 'Handgun',
    base = 'handgun',
    description = 'a standard 9mm handgun',
    clipperfill = 9,

    clipsize = 6, critframes = 15, critconfuse = 35,--25,
    as = {maxfiredelay = 8 - 10},

    chargemin = 1,

    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'}, -- 1
      {add = {clipsize = 1}, str = 'clip +1'}, -- 2
      {add = {clipsize = 2}, str = 'clip +2'}, -- 3
      {add = {clipsize = 2}, str = 'clip +2'}, -- 4
      {add = {critconfuse = 35}, str = 'long stun!'}, -- 5
    },

    sndshoot = {snd.shoot.hand.light, 1, 1}, sndrl1 = {snd.cock.start4, 1, 1}, sndrl2 = {snd.cock.finish4, 1, 1},
  },
  machinepistol = {
    meta = {parent = 'defaultauto', forsale = true, rank = 1},
    name = "Machine Pistol",
    base = 'machinepistol',
    description = "A fully-automatic machine pistol",
    clipperfill = 6,

    ammotype = EAM.pistol,
    --tf = {{TearFlags.TEAR_SLOW, .5}},
    tf = {{flag = TearFlags.TEAR_SLOW, chance = .5}},

    slashbulletdmgmaxhits = 3,
    slashbulletdmgadd = 1,

    clipsize = 18, reloadtime = 30,
    spreadmin = 8, spreadmax = 16,

    as = {damage = 4 - 3.5, maxfiredelay = 6 - 10},

    upgrade = {
      {add = {clipsize = 2}, str = 'clip +2'}, -- 1
      {add = {clipsize = 2}, str = 'clip +2'}, -- 2
      {add = {clipsize = 2}, str = 'clip +2'}, -- 3
      {add = {clipsize = 2}, str = 'clip +2'}, -- 4
      {add = {tf = {{flag = TearFlags.TEAR_CONFUSION, chance = .25}}}, str = 'stun chance!'}, -- 5
    },

    sndshoot = {snd.shoot.hand.light, .7, 1}, sndrl1 = {snd.cock.start4, 1, 1}, sndrl2 = {snd.cock.finish4, 1, 1},
  },
  penalizer = {
    meta = {parent = 'defaultcharge', forsale = true, rank = 2},
    name = 'Penalizer',
    base = 'punishinghandgun',
    description = "Blast a hole through multiple enemies!",
    clipperfill = 7,

    clipsize = 10, spreadmax = 4,
    --tf = {{TearFlags.TEAR_PIERCING, 1}},
    tf = {{flag = TearFlags.TEAR_PIERCING}},

    chargescale = true, chargemin = 2.5/3, critbonus = 1.5,
    critframes = 10, critconfuse = 25, velocity = 1.65, -- 15

    reloadtime = 50,

    as = {damage = 3 - 3.5, maxfiredelay = -3},
    ms = {range = .9},

    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'}, -- 1
      {add = {clipsize = 1}, str = 'clip +1'}, -- 2
      {add = {clipsize = 1}, str = 'clip +1'}, -- 3
      {add = {clipsize = 2}, str = 'clip +2'}, -- 4
      {add = {critbonus = -.25, ms = {damage = .25}}, set = {chargemin = 1}, str = '+uncharged dmg!'}, -- 5
    },

    mcomment = snd.merch.com.penetrate,
    sndshoot = {snd.shoot.hand.med2, 1, 1}, sndrl1 = {snd.cock.start4, 1, 1}, sndrl2 = {snd.cock.finish4, 1, 1},
  },
  luckyburst = {
    meta = {parent = 'defaultauto', forsale = true, rank = 3},
    name = "Lucky Burst",
    base = 'luckyburst',
    description = "uses up ammo quickly...",
    clipperfill = 6,

    ammotype = EAM.pistol,

    clipsize = 12, reloadtime = 45,
    spreadmin = 3, spreadmax = 12,
    maxchamber = 3, burst = 3,
    screenshake = 3,

    as = {damage = 2.5 - 3.5, maxfiredelay = 12 - 10, luck = 3},
    ms = {damage = 1, maxfiredelay = 1, range = .65},

    upgrade = {
      {add = {clipsize = 3}, str = 'clip +3'}, -- 1
      {add = {clipsize = 3}, str = 'clip +3'}, -- 2
      {add = {clipsize = 3}, str = 'clip +3'}, -- 3
      {add = {clipsize = 3}, str = 'clip +3'}, -- 4
      {add = {as = {luck = 2}}, str = 'luck +2!'}, -- 5
    },

    mcomment = snd.merch.com.threeround,
    sndshoot = {snd.shoot.rapid.light2, 1, 1.2}, sndrl1 = {snd.cock.start4, 1, 1}, sndrl2 = {snd.cock.finish4, 1, 1},
  },
  pumpactionshotgun = {
    meta = {parent = 'defaultauto', forsale = true, rank = 1},
    name = 'Pump-Action Shotgun',
    base = 'pumpactionshotgun',
    description = "don't leave home without it",
    clipperfill = 8,

    ammotype = EAM.shotgun,
    tf = {{prop = 'shrink'}},

    clipsize = 5, reloadtime = 10, reloadbullet = 8,
    velocity = 1.25, recoil = 5, screenshake = 5, shakemod = 0,
    pellets = 5, fanshot = true, spreadmax = 30, spreadmin = 30,
    damagemult = 2/5, sizemult = 1, knockback = .33,

    as = {damage = 4.8 - 3.5, maxfiredelay = 8},
    ms = {damage = 1, maxfiredelay = 1, range = .5},

    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'}, -- 1
      {add = {clipsize = 1}, str = 'clip +1'}, -- 2
      {add = {clipsize = 1}, str = 'clip +1'}, -- 3
      {add = {clipsize = 2}, str = 'clip +2'}, -- 4
      {add = {pellets = 2}, str = 'pellets +2!'}, -- 5
    },

    sndlaser = {snd.shoot.laser.heavy, 1, .6},
    sndshoot = {snd.shoot.shotgun.heavy, 1, 1}, sndrl1 = {snd.cock.start, 1, 1}, sndrl2 = {snd.cock.finish, 1, 1},
  },
  assaultshotgun = {
    meta = {parent = 'defaultcharge', forsale = true, rank = 2},
    name = 'Assault Shotgun',
    base = 'assaultshotgun',
    description = "Low spread, high range",
    clipperfill = 8, skill = gCON.Id.WSQuad,

    ammotype = EAM.shotgun,

    clipsize = 8, reloadtime = 12, reloadbullet = 8,
    recoil = 5, screenshake = 5, shakemod = .5,
    pellets = 4, fanshot = true, spreadmax = 30, spreadmin = 13,
    damagemult = (1/4) / (3/5), sizemult = .7, knockback = .5,

    chargescale = true, chargemin = .75, critbonus = 1.5,
    critframes = 15, critconfuse = 30,--15,

    as = {damage = (5.5 * (3/5)) - 3.5, maxfiredelay = 10 - 10},
    ms = {damage = 1, maxfiredelay = 1, range = .65},

    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'}, -- 1
      {add = {clipsize = 1}, str = 'clip +1'}, -- 2
      {add = {clipsize = 2}, str = 'clip +2'}, -- 3
      {add = {clipsize = 2}, str = 'clip +2'}, -- 4
      {mult = {maxfiredelay = .6}, str = 'charge rate up!'}, -- 5
    },

    sndlaser = {snd.shoot.laser.heavy, 1, .6},
    sndshoot = {snd.shoot.shotgun.heavy, 1, 1.15}, sndrl1 = {snd.cock.start, 1, 1}, sndrl2 = {snd.cock.finish, 1, 1},
  },
  autoshotgun = {
    meta = {parent = 'defaultauto', forsale = true, rank = 3},
    name = 'Auto Shotgun',
    base = 'autoshotgun',
    description = "Wide shot, fast firing",
    clipperfill = 8,

    ammotype = EAM.shotgun,
    --tf = {{TearFlags.TEAR_SHRINK, 1}},
    tf = {{prop = 'shrink'}},

    clipsize = 8, reloadtime = 60,
    recoil = 4, screenshake = 5, shakemod = 0,
    pellets = 6, fanshot = true, spreadmax = 44, spreadmin = 44,
    damagemult = 2/6, sizemult = .7, knockback = .33,

    as = {damage = (4 * 2) - 3.5, maxfiredelay = 12 - 10},
    ms = {range = .5},

    upgrade = {
      {add = {clipsize = 2}, str = 'clip +2'}, -- 1
      {add = {clipsize = 2}, str = 'clip +2'}, -- 2
      {add = {clipsize = 2}, str = 'clip +2'}, -- 3
      {add = {clipsize = 2}, str = 'clip +2'}, -- 4
      {add = {clipsize = 8}, str = 'clip +8!'}, -- 5
    },

    sndlaser = {snd.shoot.laser.heavy, 1, .6},
    sndshoot = {snd.shoot.shotgun.med, 1, 1.1}, sndrl1 = {snd.cock.start2, 1, 1}, sndrl2 = {snd.cock.finish2, 1, 1},
  },
  assaultrifle = {
    meta = {parent = 'defaultauto', forsale = true, rank = 1},
    name = 'Assault Rifle',
    base = 'assaultrifle',
    description = "spray and pray",
    clipperfill = 5,

    clipsize = 16,

    as = {damage = (2.4 * 2) - 3.5},
    ms = {range = .85},

    upgrade = {
      {add = {clipsize = 2}, str = 'clip +2'}, -- 1
      {add = {clipsize = 2}, str = 'clip +2'}, -- 2
      {add = {clipsize = 2}, str = 'clip +2'}, -- 3
      {add = {clipsize = 2}, str = 'clip +2'}, -- 4
      {mult = {spreadmin = .4, spreadmax = .4}, str = 'low spread!'}, -- 5
    },
    sndshoot = {snd.shoot.hand.med, .8, 1}, sndrl1 = {snd.cock.start2, 1, 1}, sndrl2 = {snd.cock.finish2, 1, 1},
  },
  rustytypewriter = {
    meta = {parent = 'defaultauto', forsale = true, rank = 2},
    name = "Rusty Typewriter",
    base = 'rustytypewriter',
    description = "It might jam...",
    clipperfill = 5,

    sp = {ESP.jams},

    clipsize = 24, reloadtime = 50,
    spreadmin = 10, spreadmax = 25,
    knockback = .4, recoil = 1.5,

    as = {damage = (3 * 2) - 3.5, maxfiredelay = 8 - 10, luck = -3},

    upgrade = {
      {add = {clipsize = 3}, str = 'clip +3'}, -- 1
      {add = {clipsize = 3}, str = 'clip +3'}, -- 2
      {add = {clipsize = 3}, str = 'clip +3'}, -- 3
      {add = {clipsize = 3}, str = 'clip +3'}, -- 4
      {mult = {ms = {shotspeed = 1.5}}, str = 'reload up!'}, -- 5
    },

    sndshoot = {snd.shoot.rapid.med, .8, 1.1}, sndrl1 = {snd.cock.start2, 1, 1}, sndrl2 = {snd.cock.finish2, 1, 1},
  },
  smg = {
    meta = {parent = 'defaultauto', forsale = true, rank = 2},
    name = "SMG",
    base = 'smg',
    description = "Scary!",
    clipperfill = 4,

    clipsize = 16, reloadtime = 25,
    spreadmin = 15, spreadmax = 55, spreadgain = 3,
    recoil = 1, knockback = .15,
    minshots = 4,

    --tf = {{TearFlags.TEAR_FEAR, 1}},
    tf = {{flag = TearFlags.TEAR_FEAR}},

    as = {damage = (2.2 * 2) - 3.5, maxfiredelay = 4 - 10},

    upgrade = {
      {add = {clipsize = 2}, str = 'clip +2'}, -- 1
      {add = {clipsize = 2}, str = 'clip +2'}, -- 2
      {add = {clipsize = 2}, str = 'clip +2'}, -- 3
      {add = {clipsize = 2}, str = 'clip +2'}, -- 4
      {add = {tf = {{flag = TearFlags.TEAR_PIERCING}}}, str = 'piercing!'}, -- 5
    },

    sndshoot = {snd.shoot.rapid.light2, 1, 1}, sndrl1 = {snd.cock.start2, 1, 1}, sndrl2 = {snd.cock.finish2, 1, 1},
  },
  boltsniper = {
    meta = {parent = 'defaultcharge', forsale = true, rank = 1},
    name = "Bolt Sniper",
    base = 'boltsniper',
    description = "Aim for the head",
    clipperfill = 7, skill = gCON.Id.WSPro,

    clipsize = 4, ammotype = EAM.sniper,
    --tf = {{TearFlags.TEAR_PIERCING, 1}},
    tf = {{flag = TearFlags.TEAR_PIERCING}},

    velocity = 1.5, aimspeed = 15, aimmovepen = .5,
    recoil = 5, screenshake = 4, screenshakecrit = 6,
    chargemin = .5, critbonus = 2, critframes = 15, critconfuse = 0,
    spreadmax = 12, knockback = .75,

    as = {damage = 9 - 3.5, maxfiredelay = 16 - 10},
    ms = {range = 1.5},

    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {velocity = .3}, str = 'shotspeed +.3'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {velocity = .3}, str = 'shotspeed +.3'},
      {add = {aimmovepen = -.3}, str = '-weight!'},
    },

    sndlaser = {snd.shoot.laser.heavy, 1, .6},
    sndshoot = {snd.shoot.sniper.med, 1, 1}, sndrl1 = {snd.cock.start3, 1, 1}, sndrl2 = {snd.cock.finish3, 1, 1},
    sndshell = {snd.cock.shell2, 1, 1},
  },
  heavysniper = {
    meta = {parent = 'defaultcharge', forsale = true, rank = 2},
    name = "Heavy Sniper",
    base = 'heavysniper',
    description = "Aim for anything",
    clipperfill = 7, skill = gCON.Id.WSPro,

    clipsize = 4, ammotype = EAM.sniper,
    --tf = {{TearFlags.TEAR_ACID, 1}, {TearFlags.TEAR_PIERCING, 1}},
    tf = {{flag = TearFlags.TEAR_ACID}, {flag = TearFlags.TEAR_PIERCING}},
    holddist = -15,

    reloadtime = 5, reloadbullet = 30, knockback = .75,
    velocity = 1.5, aimspeed = 15, aimmovepen = .8,
    recoil = 10, screenshake = 4, screenshakecrit = 8,
    chargemin = .5, critbonus = 2, critframes = 12, critconfuse = 0,

    as = {damage = 12 - 3.5, maxfiredelay = 22 - 10},
    ms = {range = 2},

    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {velocity = .3}, str = 'shotspeed +.3'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {velocity = .3}, str = 'shotspeed +.3'},
      {add = {critframes = 6}, str = '+crit frames!'},
    },

    mcomment = snd.merch.com.elephant,
    sndlaser = {snd.shoot.laser.heavy, 1, .6},
    sndshoot = {snd.shoot.sniper.heavy, 1, 1}, sndrl1 = {snd.cock.start3, 1, 1}, sndrl2 = {snd.cock.finish3, 1, 1},
    sndshell = {snd.cock.shell2, 1, 1},
  },
  magnum = {
    meta = {parent = 'defaultauto', forsale = true, rank = 2},
    name = "Magnum",
    base = 'magnum',
    description = "Powerful against living things",
    clipperfill = 3,

    clipsize = 6, ammotype = EAM.magnum,

    reloadtime = 10, reloadbullet = 8,
    recoil = 3, screenshake = 5, knockback = .35,
    spreadmin = 2, spreadmax = 5,
    --refundshot = true,
    freeshotsfromkill = 1,

    sizemult = .75,

    as = {damage = 3 - 3.5, maxfiredelay = 15 - 10, luck = 1},
    ms = {damage = 1, maxfiredelay = 1},

    triggers = {
      {event = {maxknifestock = true}, cond = {'hitenemy'}},
      {
        mut = {add = {as = {damage = .5}}},
        max = 10, timer = 0, maxtime = 45,
        negfactor = -1,
        cache = CacheFlag.CACHE_DAMAGE,
        cond = {'slashenemy'},
        undo = {'timer'},
      }
    },

    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {set = {firemode = EFM.charge, chargescale = true, chargemin = 1, critbonus = 2, critframes = 10, critconfuse = 45}, str = 'charging!'},
    },

    sndlaser = {snd.shoot.laser.heavy, 1, .6},
    sndshoot = {snd.shoot.hand.light3, .7, 1.2}, sndrl1 = {snd.cock.start2, 1, 1}, sndrl2 = {snd.cock.full2, 1, 1},
    sndshell = {snd.cock.shell2, 1, 1},
  },
  dualrevolvers = {
    meta = {parent = 'defaultauto', forsale = true, rank = 1},
    name = "Dual Revolvers",
    base = 'dualrevolvers',
    description = "They're pretty good",
    clipperfill = 3,

    clipsize = 12, ammotype = EAM.magnum,

    copies = {0, 0, 0, 2},
  	sp = {ESP.noarc},
  	--tf = {{TearFlags.TEAR_BOUNCE, 1}},
    tf = {{flag = TearFlags.TEAR_BOUNCE}},
    freeshotsfromkill = 2,

    reloadtime = 20, reloadbullet = 12,
    recoil = 1, screenshake = 3, knockback = .15,
    spreadmin = 0, spreadmax = 0, velocity = 1.75,
    alternatinggunfire = 2,

    sizemult = .75,

    triggers = {
      {event = {maxknifestock = true}, cond = {'hitenemy'}},
      {
        mut = {add = {as = {range = 6}}},
        max = 12, timer = 0, maxtime = 45,
        negfactor = -1,
        cache = CacheFlag.CACHE_RANGE,
        cond = {'slashenemy'},
        undo = {'timer'},
      }
    },

    as = {damage = 3 - 3.5, maxfiredelay = 12 - 10},
    ms = {damage = 1, maxfiredelay = 1, range = 2.5},

    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {mult = {range = 2}, str = 'range X2!'},
    },

    sndlaser = {snd.shoot.laser.heavy, 1, .6},
    mcomment = snd.merch.com.reloading,
    sndshoot = {snd.shoot.hand.light3, 1, 1}, sndrl1 = {snd.cock.start2, 1, 1}, sndrl2 = {snd.misc.spin, 1, 1},
    sndshell = {snd.cock.shell2, 1, 1},
  },
  machinegun = {
    meta = {parent = 'defaultauto', forsale = true, rank = 3},
    name = "Machine Gun",
    base = 'machinegun',
    description = "Now that's what I call backup!",
    clipperfill = 3,

    clipsize = 20, ammoshots = 4, ammotype = EAM.nato,

    recoil = 3, reloadtime = 60,
    spreadmin = 5, spreadmax = 15, aimmovepen = .5,
    screenshake = 3, knockback = .4,

    as = {damage = 6 - 3.5, maxfiredelay = 8 - 10},

    upgrade = {
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {tf = {{flag = TearFlags.TEAR_ACID}, {flag = TearFlags.TEAR_BURN}, {flag = TearFlags.TEAR_EXPLOSIVE}}}, str = 'destruction!'},
    },

    sndshoot = {snd.shoot.rapid.heavy, .9, 1}, sndrl1 = {snd.cock.start2, 1, 1}, sndrl2 = {snd.cock.finish2, 1, 1},
  },
  minigun = {
    meta = {parent = 'defaultauto', forsale = true, rank = 3},
    name = "Minigun",
    base = 'minigun',
    description = "Eeeyaugh!",
    clipperfill = 3,

    animminigun = true,

    clipsize = 20, ammoshots = 8, ammotype = EAM.nato,
    holddist = -10,

    recoil = .4, reloadtime = 120,
    spreadmin = 10, spreadmax = 15, aimmovepen = .6,
    aimspeed = 10, screenshake = 3, knockback = .4,

    pellets = 1, damagemult = 1, countpellets = true,
    revtime = 20,

    as = {damage = 4.5 - 3.5, maxfiredelay = 4 - 10},
    ms = {movespeed = .75},

    upgrade = {
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {pellets = .25}, str = '+25% shots!'},
    },

  sndshoot = {snd.shoot.hand.med3, 1, 1}, sndrl1 = {snd.cock.start3, 1, 1}, sndrl2 = {snd.cock.finish3, 1, 1},
  sndstart = {snd.shoot.minigun.start, 1, 1}, sndloop = {snd.shoot.minigun.loop, 1, 1}, sndfinish = {snd.shoot.minigun.finish, 1, 1},
  },
  grenadelauncher = {
    meta = {parent = 'defaultauto', forsale = true, rank = 1},
    name = "Grenade Launcher",
    base = 'grenadelauncher',
    description = "Equipped with ballistics",
    clipperfill = 3,

    clipsize = 4, ammotype = EAM.fuel + 2, noammodrops = true,
    launchgrenade = 2,

    recoil = 10, reloadtime = 60,
    spreadmin = 5, spreadmax = 15,
    screenshake = 6, knockback = .5, velocity = .65,

    as = {damage = 5 - 3.5, maxfiredelay = 18 - 10},
    ms = {maxfiredelay = 1, damage = 1, range = .65},

    upgrade = {
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 1}, str = 'clip +1'},
      {add = {clipsize = 1}, str = 'clip +1'},
    },

    mcomment = snd.merch.com.elephant,
    sndlaser = {snd.shoot.laser.heavy, 1, .6},
    sndshoot = {snd.shoot.launcher.light, 1, 1}, sndrl1 = {snd.cock.start3, 1, 1}, sndrl2 = {snd.cock.finish3, 1, 1},
    sndshell = {snd.cock.shell2, 1, 1},
  },
  flamethrower = {
    meta = {parent = 'defaultauto', forsale = true, rank = 2},
    name = "Flamethrower",
    base = 'flamethrower',
    description = "Hasta luego",
    clipperfill = .05,

    ammotype = EAM.fuel, recoil = .35,
    clipsize = 20, ammoshots = 5,
    spreadmin = 15, spreadmax = 45, spreadgain = .75, shakemod = .3,
    aimspeed = 10, minshots = 5, flamesize = 1,

    sp = {ESP.flamethrower},

    as = {damage = 8 - 3.5, maxfiredelay = 4 - 10},
    ms = {range = .75},

    upgrade = {
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {flamesize = .5, range = .35}, str = '+immolation!'},
    },

    sndloopearly = true,
    sndshoot = {snd.shoot.rapid.light, 0, 1}, sndrl1 = {SoundEffect.SOUND_GASCAN_POUR, 1, 1}, sndrl2 = {snd.cock.finish2, 0, 1},
    sndstart = {snd.shoot.flame.start, 1, 1}, sndloop = {snd.shoot.flame.loop, 1, 1}, sndfinish = {snd.shoot.flame.finish, 1, 1},
  },
  --SPECIAL
  rpg = {
    meta = {parent = 'defaultcharge', forsale = true, rank = 2},
    name = "Rocket Launcher",
    base = 'rocketlauncher',
    description = "Single use",
    skill = false,

    clipsize = 1, ammotype = EAM.null,
    sp = {ESP.fullcharge},
    tf = {{variant = gunmod_CONST.Variant.RpgTear, prop = 'rpg'},{prop = 'infrange'}},

    reloadtime = 30, minspread = 0, maxspread = 0,
    velocity = 1, aimspeed = 15, aimmovepen = .2,
    recoil = 10, screenshake = 20, screenshakecrit = 20,
    chargemin = 1, critbonus = 1, critframes = 9999, critconfuse = 0,

    mustcharge = true, noammo = true, singleuse = true, cantmod = true,
    rpg = true, animrpg = true, fakedmg = 300,

    as = {maxfiredelay = 12 - 10},

    upgrade = {
      {str = 'cannot mod'},
      {str = 'cannot mod'},
      {str = 'cannot mod'},
      {str = 'cannot mod'},
      {str = 'cannot mod'},
    },

    mcomment = snd.merch.com.elephant,
    sndlaser = {snd.shoot.laser.heavy, 1, .6},
    sndshoot = {snd.shoot.launcher.heavy, 1, 1}, sndrl1 = {snd.cock.start3, 1, 1}, sndrl2 = {snd.cock.finish3, 1, 1},
    sndshell = {snd.cock.shell2, 1, 1},
  },
  chainsaw = {
    meta = {parent = 'defaultauto', forsale = true, rank = 2},
    name = "Chainsaw",
    base = 'chainsaw',
    description = "Where's everybody going? Bingo?",
    clipperfill = 2.75,

    chainsaw = true, heightmod = .65, sawspray = true, alwaysaimed = true,
    tf = {{variant = TearVariant.BLOOD, flag = TearFlags.TEAR_PIERCING}, {flag = TearFlags.TEAR_FEAR, chance = .35},
    {flag = TearFlags.TEAR_BOUNCE, chance = .35}},

    ammotype = EAM.fuel, recoil = 0, shakemod = .25, noshotfx = true,
    clipsize = 20, ammoshots = 240, reloadtime = 10, reloadbullet = 3,
    --clipsize = 5000, ammoshots = 1/500,
    spreadmin = 15, spreadmax = 15, spreadgain = 0, shakemod = .3,
    damagemult = .3, sizemult = .75, velocity = 1,-- revtime = 20,
    knockback = .15, minshots = 30,

    as = {damage = 12 - 3.5, maxfiredelay = 1 - 10},
    ms = {range = .65},

    upgrade = {
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
      {add = {clipsize = 5}, str = 'clip +5'},
    },

    sndshoot = {snd.knife.slash, .5, 1.25}, sndrl1 = {SoundEffect.SOUND_GASCAN_POUR, 1, 1}, sndrl2 = {snd.cock.start2, 1, 1},
    sndshell = {snd.cock.shell2, 0, 1},
    sndstart = {snd.shoot.chainsaw.runstart, 1, 1}, sndloop = {snd.shoot.chainsaw.runloop, 1, 1}, sndfinish = {snd.shoot.chainsaw.runfinish, 1, 1},
    sndidlestart = {snd.shoot.chainsaw.idlestart, 0, .6}, sndidleloop = {snd.shoot.chainsaw.idleloop, 1, .6}, sndidlefinish = {snd.shoot.chainsaw.idlefinish, 0, .6},
  },
  --FAMILIAR CUSTOMS
  fam_base = {
    meta = {parent = 'default'},
    name = "Familiar Sidearm",
    base = 'handgun',

    ammotype = EAM.pistol,
    skill = gCON.Id.WSQuad,
    as = {damage = 3.5 - 3.5, maxfiredelay = 10},

    clipsize = 20, reloadtime = 50, spreadmax = 10, knockback = .02,
    sndshoot = {snd.shoot.hand.light, .7, 1.5}, sndrl1 = {snd.cock.start4, .7, 1.5}, sndrl2 = {snd.cock.finish4, .7, 1.5},
  },
  --BOSS CUSTOMS
  boss_hauntshammer = {
    meta = {parent = 'dualrevolvers'},
  },
}

for i, wep in pairs(gWEP.WeaponTypes) do
  if wep.tf then
    local newtable = {}
    for j, flag in ipairs(wep.tf) do
      table.insert(gWEP.TfList, flag)
      newtable[#gWEP.TfList] = true
    end
    wep.tf = newtable
  end
end

for i, wep in pairs(gWEP.WeaponTypes) do
  if wep.triggers then
    local newtable = {}
    for i, trig in ipairs(wep.triggers) do
      table.insert(gWEP.TrigList, trig)
      table.insert(newtable, #gWEP.TrigList)
    end
    wep.triggers = newtable
  end
end

error()
