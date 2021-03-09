local gCON = gunmod_CONST

local EAM = gunmod_CONST.EN.AM; local EFM = gunmod_CONST.EN.FM
local ESP = gunmod_CONST.EN.SP; local snd = gunmod_SFX

gunmod_CHRICONS = {'01_Isaac', '02_Magdalene', '03_Cain', '04_Judas',
  '05_Eve', '06_Bluebaby', '07_Samson', '08_Azazel', '09_Lazarus',
  '10_Eden', '11_TheLost', '09_Lazarus', '04_Judas', '12_Lilith',
  '13_Keeper', '15_Apollyon', '16_TheForgotten', '16_TheForgotten'}

gunmod_CHR = {
  --DEFAULT
  Default = {
    modchar = true,
    icon = 'Unknown',
    skilldesc = {"random discounts!"},
    weapons = {
      {'handgun'},
      {'pumpactionshotgun'},
    },
    nosale = {'handgun', 'pumpactionshotgun'},
    perks = {'randomdiscount'},
  },
  ---VANILLA
  p0 = { -- isaac
    icon = '01_Isaac',
    skilldesc = {"cheap shop rerolls!"},
    weapons = {
      {'handgun'},
      {'assaultrifle'},
    },
    perks = {'options'},
  },
  p1 = {}, -- maggy
  p2 = {}, -- cain
  p3 = {}, -- judas
  p4 = {}, -- blue baby
  p5 = {}, -- eve
  p6 = {}, -- samson
  p7 = {}, -- azazel
  p8 = {}, -- lazarus
  p9 = {}, -- eden
  p10 = {}, -- the lost
  p11 = {}, -- super lazarus
  p12 = {}, -- super judas
  p13 = { -- lilith
    skilldesc = {'mother of demons!'},
    weapons = {
      {'flamethrower'},
      {'assaultrifle', {add = {mods = {460, 330}}}},
    },
    modall = {
      set = {lasersight = true, laserguide = true},
      add = {spreadmin = 15, spreadmax = 20, tf = {{flag = TearFlags.TEAR_SPECTRAL}}},
      mult = {critconfuse = 1.75, critframes = 1.5},
    },
    --remove = {360},
    nosale = {'penalizer', 'pumpactionshotgun'},
    perks = {'superincubus', 'nogun'},
  },
  p14 = {}, -- keeper
  p15 = {}, -- apollyon
  p16 = {}, -- the forgotten
  p17 = {}, -- the soul
  ---LEON
  Leon = {
    icon = 'Leon',
    skilldesc = {"knife master!", "upgrading fills clip!"},
    stats = {
  		Damage = 0,	MoveSpeed = .15, MaxFireDelay = 0,
  		ShotSpeed = .15, TearHeight = 0, Luck = 1,
  	},
    weapons = {
      {'handgun', {set = {
        name = "Leon's Handgun",
        description = 'quick and lightweight',
        clipsize = 5,
        as = {maxfiredelay = -4}}}},
      {'pumpactionshotgun'},
      --{'autoshotgun'},
      --{'boltsniper'},
      --{'chainsaw'},
      --{'chainsaw', {add = {mods = {394, 245, 114, 110, 411}}}},
      {'machinepistol'},
    },
    mods = {1, 2, 3, 12},
    --passives = {35},
    --additems = {},
    nosale = {'handgun', 'pumpactionshotgun'},
    perks = {'upgradefill', 'knifeking'},
  },
  ---OTHER MODS
  Samael = {
    icon = 'Unknown',
  }
}

error()
