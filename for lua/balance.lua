gunmod_BAL = {
  diffnames = {'herbs', 'ammo', 'money', 'range', 'max_hp'},
  difftable = {
  -- xez    eaz    nrm    hrd    pro    imp
    {200,   175,   175,   100,   050,   010}, --herbs
    {250,   200,   150,   100,   065,   050}, --ammo
    {070,   075,   080,   100,   125,   150}, --money
    {200,   200,   150,   100,   080,   070}, --range
    {012,   012,   012,   006,   006,   005}, --maxhp
    {012,   012,   012,   001,   001,   001}, --maxshp
    {000,   000,   000,   000,   005,   005}, --herbtax
    {250,   200,   150,   100,   100,   075}, --yherbs
    {004,   003,   002,   000,   000,   000}, --yadvance
    {003,   002,   001,   000,   000,   000}, --fountain
    {100,   100,   100,   075,   070,   065}, --bossvulnmult (general boss damage res)
    {100,   100,   100,   040,   030,   020}, --bossvulncap (the other thing)
  },
  temppickupsmindif = 3,
  --                pis,  sho,  ass,  sni,  mag,  nat,  fue
  maxclips = {      4,    4,    4,    4,    4,    2,    2,  0,0,0,0,0},
  ammodrop =    {   8,   10,    15,   20,   20,   30,   25, 0,0,0,0,0},
  ammodropvar = .25,
          --stage:	1			2			3			4			5			6			7			8			9			10			11			12
	        --norm:		1-1		1-2		2-1		2-2		3-1		3-2		4-1		4-2		bw		sh/ca		dr/ch		vo
	        --greed: 	1			2			3			4			she		sho		ug
  knifedamage = {   4,    4,    5,    5,    6,    6,    7,    7,    8,    8,      8,      10},
  knifedamage2 = {  1,    1,    1,    1,    2,    2,    2,    2,    3,    3,      3,      4},
  partime = {       3,    4,    5,    5.5,  6,    6.5,  7,    7.5,  10,   8,      10,     15},
  partimel = {      5,    5,    8,    8,    10,   10,   10,   10,   10,   12,     12,     15},
  herbdropscale = { .5,   .5,   1,    .9,   .8,   .7,   .6,   .5,   1,    .5,     .5,     .4},
  ammodropscale = { .7,   .9,   .9,   .9,   .8,   .8,   .7,   .7,   1,    .7,     .9,     1},
  yellowherbtgt = { 0,    0,    1,    1,    1,    2,    2,    2,    3,    3,      4,      4},
  vulnratemult = {  .5,   .5,   .6,   .7,   .8,   .9,   1,    1,    1,    1,      1,      1},
  buyprice = {
    gun = 20, gunmod = 10, mod = 15, pocket = 3, attach = 10, attachlvl = 10,
    earlydiscount = 5, rpg = 50,
  },
  sellprice = {
    gun = 20, gunmod = 10, gunlvl = 10, mod = 10, scrap = 0, pocket = 3,
  },
  yellowherb = {need = 5, have = 1, failpity = .75},
  skill = {
    quaddamageframes = 120,
    promodeframes = 120,
  },
  cards = {
    grenadedropfor2clubs = 10,
  },
  gridreplace = {
    rocktnt = .04,
    poopblackpoop = .03,
    poopwhitepoop = .02,
  },
  bossscaler = {
    Monstro = 5, Gemini = 5, ['Larry Jr.'] = 3, Dingle = 5, Gurglings = 5, Steven = 5,
    Pin = 2, Widow = 6, Blighted_Ovum = 6, Fistula = 6, ['Gurdy Jr.'] = 8, The_Haunt = 6,
    The_Duke_of_Flies = 3, Famine = 5, Rag_Man = 7, Little_Horn = 5, Dangle = 7, Turdlings = 6,

    Chub = 5, Gurdy = 5, Mega_Maw = 7, Mega_Fatty = 7, ['C.H.A.D.'] = 6, Rag_Mega = 7,
    The_Hollow = 4, The_Husk = 5, Dark_One = 5, Polycephalus = 5, Carrion_Queen = 6, The_Wretched = 5,
    Peep = 7, Pestilence = 6, The_Frail = 3, The_Stain = 7, The_Forsaken = 3, Big_Horn = 7,

    The_Cage = 7, Monstro_II = 5, The_Gate = 6, Gish = 3,
    The_Adversary = 4, The_Bloat = 9, Mask_of_Infamy = 5,
    Loki = 5, War = 4, Brownie = 7, Sisters_Vis = 5,
    Mom = 15,

    ['Mr. Fred'] = 3, Scolex = 3,
    Mama_Gurdy = 5, Lokii = 5,
    The_Matriarch = 7,
    Blastocyst = 3, Daddy_Long_Legs = 4, Teratoma = 6, Triachnid = 4, Death = 4, Conquest = 5,
    ["Mom's Heart"] = 12, It_Lives = 12,

    Headless_Horseman = 5,

    Satan = 8, Isaac = 8,
    The_Lamb = 12, ['???'] = 12, Mega_Satan = 12,
  },
  explosiveenemies = {
    Boom_Fly = -1, Drowned_Boom_Fly = -1, Ticking_Spider = -1,
    Mulliboom = 2, Black_Bony = -1, Kamikaze_Leech = -1,
    Holy_Leech = -1, Movable_TNT = -1,
  },
  bosschampscaler = 1.25,
  bossdiffdamagescaler = .666,
  --misc
  multigundmgmult = .7,
  multigunbossdmgmult = .5,
  cashperhp = .025, cashpersh = .02, grenadeperbomb = .02,
  damagespreadreward = .05,
  labyrinthtime = 2,
  dronedmg = .35,
}

local newtable = {}
for name, diff in pairs(gunmod_BAL.bossscaler) do
  local bname = string.gsub(name, '_', ' ')
  newtable[Isaac.GetEntityTypeByName(bname)] = diff
end
gunmod_BAL.bossscaler = newtable

local newtable = {}
for name, v in pairs(gunmod_BAL.explosiveenemies) do
  local bname = string.gsub(name, '_', ' ')
  newtable[Isaac.GetEntityTypeByName(bname)] = v
end
newtable[292] = true
gunmod_BAL.explosiveenemies = newtable

error()
