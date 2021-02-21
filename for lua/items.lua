local gCON = gunmod_CONST
local gWEP = gunmod_WEP
local ESP = gCON.EN.SP;
local ECP = gCON.EN.CP;
local EIT = gCON.EN.IT;
local EFM = gCON.EN.FM;

gunmod_ITEMS = {type = {}, disable = {}, ban = {}, moddat = {}, modlist = {}, skills = {}, attribs = {}}
local gITM = gunmod_ITEMS;
local moddat = gITM.moddat
local attribs = gITM.attribs

--ITEMS WHICH CAN BE COLLECTED NORMALLY
local nonmods = {9, 13, 17, 18, 20, 21, 53, 54, 60, 63, 64, 72, 73, 74, 75, 76, 81,
  91, 94, 98, 116, 117, 122, 131, 134, 139, 141, 142, 148, 156, 161, 162, 173, 178, 179,
  180, 187, 195, 198, 199, 202, 203, 204, 205, 207, 210, 211, 212, 215, 227, 236, 238,
  239, 246, 247, 248, 249, 250, 251, 252, 260, 262, 266, 271, 278, 280,
  281, 302, 303, 311, 321, 325, 327, 328, 333, 335, 337, 344, 356, 371, 375, 376, 377, 380, 388,
  391, 402, 409, 412, 413, 414, 416, 420, 423, 425, 428, 433, 446, 447, 448, 451, 452,
  454, 457, 458, 464, 468, 492, 497, 511, 514, 518, 525, 534, 535, 538, 539, 541, 542, 543,
  548, 549, 550, 551, 552,
  --bombs
  19, 37, 106, 125, 140, 190, 209, 220, 256, 353, 366, 367, 432, 517,
  --content
  gCON.Id.Placeholder, gCON.Id.AttacheCase,
}
for i, item in ipairs(nonmods) do
  gITM.type[item] = EIT.normal
end
for i, item in ipairs(gunmod_WEP.IdList) do
  gITM.type[item] = EIT.normal
end

--WEAPON SKILLS
local skills = {
  gCON.Id.WSSight, gCON.Id.WSQuad, gCON.Id.WSPro,
  gCON.Id.WSScary, gCON.Id.WSSuper, gCON.Id.WsDoom,
}
for i, item in ipairs(skills) do
  gITM.skills[item] = true
end

--ITEMS WHICH WILL NOT APPEAR TO BE PICKED UP IN GAME
local banlist = {
  10, -- halo of flies
  63, -- battery
  64, -- steam sale
  75, -- phd
  102, -- mom's bottle of pills
  107, -- pinking shears
  127, -- forget me now
  144, -- bum friend
  195, -- mom's coin purse
  203, -- humbling bundle
  206, -- guillotine
  218, -- placenta
  240, -- experimental treatment
  252, -- little baggy
  258, -- missingno
  272, -- bbf
  273, -- bob's brain
  283, -- d100
  284, -- d4
  286, -- blank card
  304, -- libra
  350, -- toxic shock
  376, -- restock
  381, -- eden's blessing
  392, -- zodiac
  406, -- d8
  422, -- glowing hourglass
  477, -- void
  478, -- pause
  481, -- dataminer
  482, -- clicker
  489, -- d afinigy
  528, -- angelic prism
  529, -- pop!
  530, -- death's list
  531, -- haemolacria
  539, -- mystery egg
  540, -- flat stone
  541, -- brittle bones
}
local banlist2 = { -- bans only on hard+ difficulty
  109, -- money = power
  210, -- gnawed leaf (smiling imp face)
  299, -- taurus
  424, -- sack head
  466, -- contagion
  467, -- finger!
  469, -- depression
}
for i, item in ipairs(banlist) do
  gITM.ban[item] = true
end
for i, item in ipairs(banlist2) do --wip
  gITM.ban[item] = true
end

gITM.defaultmoddesc = {"works as", "usual"}

gunmod_ITEMS.attribs = {
  lightweight = {
    mult = {aimmovepen = .5, revtime = .5, ms = {maxfiredelay = .65, damage = .9}}
  },
  heavy = {
    mult = {
      recoil = 2, knockback = 2.5, screenshake = 2, screenshakecrit = 2,
      ms = {damage = 1.5, maxfiredelay = 1.4, shotspeed = .75}},
    add = {aimmovepen = .35},
  },
  ['shell-loaded'] = {
    set = {setshellload = true},
  },
  rusty = {
    mult = {ms = {damage = .75, maxfiredelay = 1.2, shotspeed = .8}},
  },
  pristine = {
    mult = {ms = {damage = 1.25, maxfiredelay = .8, shotspeed = 1.25}},
    add = {as = {luck = 1}},
  },
  dual = {
    add = {copies = {1, 0, 0, 0}},
  },
  glass = {
    mult = {ms = {damage = 2, shotspeed = 2}},
    add = {as = {luck = -1}},
  },
  cursed = {
    mult = {ms = {damage = 1.5}},
    add = {adduserdamage = 1},
  },
  sympathetic = {
    mult = {ms = {damage = .8}},
    add = {adduseriframes = 30, ammoonhit = 1},
  },
  gunslinger = {
    mult = {ms = {shotspeed = 2}},
  },
}

--WEAPON MODDING SPECIFICATIONS
moddat[2] = { -- inner eye
	add = {copies = {0, 0, 0, 2}},
  --mult = {ms = {damage = .65}},
}
moddat[15] = { -- <3
  rename = "less than three",
}
moddat[55] = { -- mom's eye
	add = {copies = {0, 1, 0, 0}},
}
moddat[68] = { -- technology
	add = {sp = {ESP.laser}},
}
moddat[69] = { -- chocolate milk
	disable = true,
	set = {firemode = EFM.charge, maxchamberpct = 1/3},
	add = {sp = {ESP.chargedamage}, as = {damage = 1}},
}
moddat[87] = { -- loki's horns
	add = {copies = {1, 1, 1, 0}},
}
moddat[114] = { -- mom's knife
	disable = true,
	add = {sp = {ESP.bayonet}},
}
moddat[118] = { -- brimstone
	disable = true,
	set = {brimstone = true, firemode = EFM.charge, maxchamberpct = 1/3, recoil = 1, screenshake = 3, screenshakecrit = 5, tearvariant = TearVariant.BLOOD},
	add = {spreadmin = 15, spreadmax = 15, sp = {ESP.fullcharge, ESP.brimstone, ESP.multiknock}, tf = {{flag = TearFlags.TEAR_PIERCING}}},
	mult = {damagemult = 1.666, knockback = .3},
}
moddat[120] = { -- odd mushroom fat
  disable = true,
  add = {as = {maxfiredelay = -3, damage = -.4}},
  mult = {ms = {damage = .9}}
}
moddat[121] = { -- odd mushroom thin
  disable = true,
  add = {as = {damage = .3, range = 4}},
}
moddat[149] = { -- ipecac
  disable = true,
  set = {firemode = EFM.charge, maxchamberpct = 1/4},
  add = {
    as = {range = 3}, sp = {ESP.fullcharge, ESP.chargedamage},
    tf = {{flag = TearFlags.TEAR_EXPLOSIVE + TearFlags.TEAR_POISON,
    color = Color(.7, 1, .75, 1, 0, 0, 0)}}
  },
  mult = {damagemult = 1/3, spreadmin = .8, spreadmax = .8, ms = {damage = 3, maxfiredelay = 2/3}},
}
moddat[152] = { -- technology 2
	disable = true,
	add = {copies = {0, 0, 0, 1}, sp = {ESP.laser2}},
	--mult = {ms = {damage = .75}},
}
moddat[153] = { -- mutant spider
	add = {copies = {0, 0, 0, 3}},
  --mult = {ms = {damage = .5}},
}
moddat[168] = { -- epic fetus
  disable = true,
  set = {epic = true, guncircle = true, alwaysaimed = true, firemode = EFM.charge, maxchamberpct = 1/5},
  add = {sp = {ESP.fullcharge, ESP.chargedamage}, copies = {4, 0, 0, 0}, tf = {{flag = TearFlags.TEAR_SPECTRAL}}, as = {range = 8}},
  mult = {aimmovepen = .5, recoil = 0, knockback = .25, velocity = 1.25, shotsmult = 6, damagemult = 1/6, ms = {maxfiredelay = .75, range = 1.5}},
}
moddat[221] = { -- rubber cement
  add = {bounces = 1}
}
moddat[222] = { -- antigravity
	add = {sp = {ESP.antigravity}},
	mult = {recoil = 0},
}
moddat[223] = { -- pyromaniac
  --ammo from taking explosion damage
}
moddat[233] = { -- tiny planet
  disable = true,
  set = {gunorbit = true, guncircle = true, facecorrect = true, bulletgrav = true},
  add = {copies = {2, 0, 0, 0}, as = {range = 35}},
  mult = {recoil = 0, velocity = 1.1},
}
moddat[245] = { -- 20/20
	add = {copies = {0, 0, 0, 1}, sp = {ESP.noarc}},
  --mult = {ms = {damage = .8}},
}
moddat[254] = { -- blood clot
  disable = true,
	add = {tf = {{variant = TearVariant.BLOOD, cond = ECP.even, dmgmult = 1.5, sizemult = 1.25, rangemult = 1.25}}},
}
moddat[229] = { -- monstro's lung
	disable = true,
	set = {firemode = EFM.charge, maxchamberpct = 1/2},
	mult = {ms = {damage = 1.25}},
}
moddat[237] = { -- death's touch
  set = {sizemult = .35},
}
moddat[244] = { -- tech.5
  disable = true,
  add = {sp = {ESP.laserp5}},
  mult = {ms = {maxfiredelay = 1.5}},
}
moddat[309] = { -- pisces
  add = {knockback = .35},
  mult = {knockback = 1.25},
  set = {multiknock = true},
  --set = {vanillaknockback = true},
}
moddat[315] = { -- strange attractor
  disable = true,
  set = {magnetonshot = true, strongknock = true},
  add = {knockback = .35},
  mult = {knockback = -1},
}
moddat[316] = { -- cursed eye
	disable = true,
	set = {firemode = EFM.charge, chargescale = true, maxchamber = 4},
	add = {sp = {ESP.fullcharge, ESP.cursetp}},
	mult = {ms = {maxfiredelay = .5}},
}
moddat[329] = { -- ludovico
	disable = true,
  add = {drones = 1, tf = {{flag = TearFlags.TEAR_SPECTRAL}}},
}
moddat[330] = { -- soy milk
  disable = true,
  add = {freeshotchance = .5, minspread = 5, maxspread = 5, as = {movespeed = .15}},
  mult = {burst = 3, pellets = 2.5, maxspread = 3, recoil = .35, aimmovepen = .5,
    ms = {damage = 1/13, maxfiredelay = .33, shotspeed = 1.5}},
  set = {fanshot = false},
}
moddat[358] = { -- the wiz
  mult = {copies = {2, 2, 2, 2}},
  set = {fanoffset = 35},
}
moddat[368] = { -- epiphoria
  disable = true,
  add = {as = {maxfiredelay = -3, damage = .5}},
  set = {lockrotwhenfiring = true},
}
moddat[373] = { -- dead eye
  disable = true,
  add = {
    triggers = {{
      mut = {add = {as = {damage = .1}}},
      max = 20, reset = .5,
      cache = CacheFlag.CACHE_DAMAGE,
      cond = {'hitenemy'},
      undo = {'missenemy'},
    }}
  }
}
moddat[394] = { -- marked
  disable = true,
  set = {lasersight = true, laserguide = true},
  add = {as = {range = 24}},
  mult = {velocity = .85, spreadmin = 2, spreadmax = 2},
}
moddat[397] = { -- tractor beam
	disable = true,
	add = {as = {maxfiredelay = -2}, as = {range = 5}},
	mult = {velocity = 1.2, spreadmin = .25, spreadmax = .25},
  set = {lasersight = true},
}
moddat[400] = { -- spear of destiny
  --chargeharpoons = true
}
moddat[411] = { -- bloody lust
  -- strong but resets when losing combo
}
moddat[465] = { -- analog stick
	add = {as = {range = 5}, velocity = .25, knockback = .3},
  set = {digitalaim = true},
}
moddat[472] = { -- king baby
  disable = true,
  set = {stickwhenfiring = true, donotslow = true},
  add = {tf = {{flag = TearFlags.TEAR_SPECTRAL}}},
  mult = {recoil = 0},
}

local gspeedups = {12, {14, .6}, 27, 28, {70, .4}, 71,
  {79, .2}, 82, {90, .2}, 101, 119, 120, {121, -.1},
  {129, -.2}, 143, {189, .2}, {230, .2}, {232, .3},
  {306, .2}, {307, .1}, {314, -.4}, 340}

local freeshots = {12, 15, {16, .24}, 22, 23, 24, 25, 26,
  92, 101, 119, 121, {129, .24}, 138, 176, 182, 184, 189,
  193, 218, 219, 226, 253, 307, 312, 314, {334, .36}, 342,
  346, 354, 456}

for i, item in ipairs(gspeedups) do
  local table = type(item) == 'table'
  local id = (table and item[1]) or item
  local val = (table and item[2]) or .3
  moddat[id] = moddat[id] or {}
  moddat[id].add = moddat[id].add or {}
  moddat[id].add.as = moddat[id].add.as or {}
  if not moddat[id].disable or moddat[id].add.as.movespeed then
    moddat[id].add.as.movespeed = 0 - val
  end
  moddat[id].add.gspeed = moddat[id].add.gspeed or val
end

for i, item in ipairs(freeshots) do
  local table = type(item) == 'table'
  local id = (table and item[1]) or item
  local val = (table and item[2]) or .12
  moddat[id] = moddat[id] or {}
  moddat[id].add = moddat[id].add or {}
  if not moddat[id].add.freeshotchance then
    moddat[id].add.freeshotchance = val
  end
end



--AAAAAAAAAHHH
local id = 1
local config = Isaac.GetItemConfig()
while id <= 999 or config:GetCollectible(id) do
  local item = config:GetCollectible(id)
	if item and item ~= 0 then
	  --(temp) ban all familiars
	  if item.Type == ItemType.ITEM_FAMILIAR then--hasbit(item.CacheFlags, CacheFlag.CACHE_FAMILIARS) then
      if id ~= 360 then -- temp incubus exception
  	    gITM.ban[id] = true
        gITM.type[id] = EIT.mod
      end
	  end
	  --(temp) consider all actives not mods
	  if item.Type == ItemType.ITEM_ACTIVE then
	    --gITM.ban[id] = true
      gITM.type[id] = EIT.normal
	  end
	  --vanilla
	  if id <= 552 then
	    if not gITM.type[id] then
	      gITM.type[id] = EIT.mod
	      if moddat[id] and moddat[id].disable then
	        moddat[id].disable = false
	        gITM.disable[id] = true
	      end
	    end
	  --guess whether non-vanilla item should be a mod
    elseif not gITM.type[id] then
	    if item.CacheFlags == 0 and not item.Special then
	      gITM.type[id] = EIT.normal
	    else
	      gITM.type[id] = EIT.mod
	    end
	  end
	  if gITM.type[id] == EIT.mod and not gITM.ban[id] then
	    table.insert(gITM.modlist, id)
	  end
    --trigger fuck
    if moddat[id] and moddat[id].add and moddat[id].add.triggers then
      local newtable = {}
      for i, trig in ipairs(moddat[id].add.triggers) do
        table.insert(gWEP.TrigList, trig)
        table.insert(newtable, #gWEP.TrigList)
        --newtable[#gWEP.TrigList] = true
      end
      moddat[id].add.triggers = newtable
      --table.insert(gWEP.TrigList, moddat[id].add.trigger)
      --moddat[id].add.trigger = 'alf'--#gWEP.TrigList
      --moddat[id].add.clipsize = 10
    end
    --tf fuck
    if moddat[id] and moddat[id].add and moddat[id].add.tf then
      local newtable = {}
      for i, flag in ipairs(moddat[id].add.tf) do
        table.insert(gWEP.TfList, flag)
        newtable[#gWEP.TfList] = true
      end
      moddat[id].add.tf = newtable
    end
	end
  id = id + 1
end

for hhh, trig in ipairs(gWEP.TrigList) do
  if trig.mut.add.tf then
    local newtable = {}
    for i, flag in ipairs(trig.mut.add.tf) do
      table.insert(gWEP.TfList, flag)
      newtable[#gWEP.TfList] = true
    end
    trig.mut.add.tf = newtable
  end
end

error()
