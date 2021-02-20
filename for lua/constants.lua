local function enumerate(set)
  local result = {}
  for i, id in ipairs(set) do
    result[id] = i
  end
  return (result)
end

gunmod_CONST = {
  --Fake enums
  EN = {
    --Difficulty variables
    DF = enumerate({'herbs', 'ammo', 'money', 'range', 'maxhp', 'maxshp', 'herbtax', 'yherbs',
      'yadvance', 'fountain', 'bossvulnmult', 'bossvulncap'}),
    --Ammo types
    AM = enumerate({'pistol', 'shotgun', 'assault', 'sniper', 'magnum', 'nato', 'fuel', 'rgren', 'ggren', 'bgren', 'null'}),
    --Special gun attributes
    SP = enumerate({'noarc', 'nospread', 'bloodclot', 'bayonet', 'antigravity', 'laser',
      'laser2', 'brimstone', 'flamethrower', 'drone', 'dronespawn', 'noclip', 'jams',
      'cantstop', 'makecharge', 'fullcharge', 'chargedamage', 'digitalaim', 'convertcrit',
      'cursetp', 'exafterburn', 'multiknock', 'laserp5'}),
    --Bullet clip placement
    CP = enumerate({'every', 'first', 'firstfull', 'last', 'lastfull', 'odd', 'even',
      'charged', 'crit', 'postkill', 'postslash'}),
    --Inventory item types
    IT = enumerate({'gun', 'normal', 'mod', 'pocket'}),
    --Gun Fire Mode
    FM = enumerate({'auto', 'charge'}),
    --Player perks
    --PR = enumerate('upgradefill', 'knifeboss', 'poopkilla', 'soulherbs', 'shotparry'),
  },
  --Leon character data
  Leon = {
    Type = Isaac.GetPlayerTypeByName("Leon"),
    Costume = Isaac.GetCostumeIdByPath("gfx/characters/costume_leon.anm2"),
    Stats = {
  		Damage = 0,	MoveSpeed = .15, MaxFireDelay = 0,
  		ShotSpeed = .15, TearHeight = 0, Luck = 1,
  	},
    DefaultStats = {
  		Damage = 0,	MoveSpeed = 0, MaxFireDelay = 0,
  		ShotSpeed = 0, TearHeight = 0, Luck = 0,
  	},
  },
  --Content IDs
  Id = {
    Placeholder = Isaac.GetItemIdByName("Placeholder"),
    AttacheCase = Isaac.GetItemIdByName("Attache Case"),
    WSSight = Isaac.GetItemIdByName("Skill: Killer Sight"),
    WSQuad = Isaac.GetItemIdByName("Skill: Quad Damage"),
    WSPro = Isaac.GetItemIdByName("Skill: Professional Reflex"),
    WSScary = Isaac.GetItemIdByName("Skill: Scary Cherry"),
    WSSuper = Isaac.GetItemIdByName("Skill: Supercharge"),
    WSDoom = Isaac.GetItemIdByName("Skill: DOOM"),
  },
  --Content Types
  Type = {},
  --Content Variants
  Variant = {
    Weapon = Isaac.GetEntityVariantByName("Weapon"),
  	Drone = Isaac.GetEntityVariantByName("Drone"),
  	Bayonet = Isaac.GetEntityVariantByName("Bayonet"),
  	Knife = Isaac.GetEntityVariantByName("Leon's Knife"),
  	FlamethrowerFire = Isaac.GetEntityVariantByName("Flamethrower Fire"),
  	Grenade = Isaac.GetEntityVariantByName("Grenade"),
  	MuzzleFlash = Isaac.GetEntityVariantByName("Muzzle Flash"),
  	Minicrit = Isaac.GetEntityVariantByName("Minicrit Debuff"),
  	DynamicCollectible = Isaac.GetEntityVariantByName("Leon Collectible"),
  	Merchant = Isaac.GetEntityVariantByName("Weapon Merchant"),
    RpgTear = Isaac.GetEntityVariantByName("RPG Tear"),
    LaserSight = Isaac.GetEntityVariantByName("Laser Sight"),
    LaserDot = Isaac.GetEntityVariantByName("Laser Dot"),
    KnifeTgt = Isaac.GetEntityVariantByName("Knife Target"),
    LeonFam = Isaac.GetEntityVariantByName("Leon Familiar"),
  },
  --Ammo shit
  Ammodat = {
    {w = 4, h = 8}, -- pistol
    {w = 4, h = 6}, -- shotgun
    {w = 4, h = 11}, -- assault
    {w = 4, h = 13}, -- sniper
    {w = 4, h = 7}, -- magnum
    {w = 14, h = 8}, -- NATO
    {w = 6, h = 8}, -- fuel
    {w = 7, h = 10}, -- r gren
    {w = 7, h = 10}, -- g gren
    {w = 7, h = 10}, -- b gren
  },
  --UI Sprites
  Sprite = {
  	Menu = Sprite(),
  	MenuFont = Sprite(),
  	Player = Sprite(),
  	ModPlayer = Sprite(),
    Weapon = Sprite(),
  	Bullet = Sprite(),
  	Mod = Sprite(),
  	ModMini = Sprite(),
  	Pickup = Sprite(),
    Waldo = Sprite(),
    Cursor = Sprite(),
    ScreenFade = Sprite(),
    Bar = Sprite(),
    KnifeIcon = Sprite(),
  },
  --flashlight colors
  flashlightclr = {
    off = Color(0, 0, 0, 0, 0, 0, 0),
    white = Color(.5, 1, 1, 1.25, 0, 0, 0),
    natural = Color(.5, 1, .75, 1.25, 0, 0, 0),
    yellow = Color(.5, 1, .5, 1.25, 0, 0, 0),
    red = Color(1, 1, 1, 1.25, 0, 0, 0),
    pink = Color(.75, 1, 1, 1.25, 0, 0, 0),
    orange = Color(.66, 1, 0, 1.25, 0, 0, 0),
    blue = Color(.25, .75, 1, 1.25, 0, 0, 0),
    purple = Color(.45, .35, 1.5, 1.25, 0, 0, 0),
    brown = Color(.55, .85, .65, 1.25, 0, 0, 0),
  },
  flashlightpick = {
    {'natural','natural','orange'}, -- basement cellar burning
    false, --
    {'natural','blue','blue'}, -- caves catacombs flooded
    false, --
    {'blue','natural','purple'}, -- depths necropolis dank
    false, --
    {'pink','pink','brown'}, -- womb utero scarred
    false, --
    {'blue'}, -- bluewomb
    {'red','white'}, -- sheol cathedral
    {'purple','natural'}, -- darkroom chest
    {'natural'}, -- void
  },
  lightfrombackdrop = {
    'natural', 'natural', 'orange', -- basement cellar burning
    'natural', 'blue', 'blue', -- caves catacombs flooded
    'blue', 'natural', 'purple', -- depths necropolis dank
    'pink', 'pink', 'brown', -- womb utero scarred
    'blue', -- blue womb
    'red', 'white', -- sheol cathedral
    'purple', 'natural', -- darkroom chest
    'red', -- megasatan
    'natural', 'natural', 'blue', 'brown',-- library shop isaac barren
    'blue', 'red', 'yellow', 'purple',-- secret dice arcade error
    'blue', 'yellow',-- bluesecret ultragreedshop
  },
  --Bullshit
  gungfxroot = "gfx/familiars/",
	gunheight = -22,
	tearheight = -18,
	famteardmgbonus = 5/3.5,
	baseaimspeed = 45,
	juiceperpip = 30,
  ammodisplaywidth = 48,
  firedetectfrequency = 3,
  statshowduration = 1.5,
  knockback = 1.5,

  basestats = {
    Damage = 0, MoveSpeed = 0, MaxFireDelay = 0,
		ShotSpeed = 0, TearHeight = 0, Luck = 0,
  },
  enstats = {
    Damage = 3.5,	MoveSpeed = 1, MaxFireDelay = 10,
    ShotSpeed = 10,	TearHeight = -23.75, Luck = 0,
  },
}

gunmod_CONST.Sprite.Bullet:Load("gfx/uibullets.anm2", true)
gunmod_CONST.Sprite.Weapon:Load("gfx/weapon.anm2", true)
gunmod_CONST.Sprite.Menu:Load("gfx/leon_menu2.anm2", true)
gunmod_CONST.Sprite.MenuFont:Load("gfx/menufont.anm2", true)
gunmod_CONST.Sprite.ModMini:Load("gfx/ui/death screen.anm2", true)
gunmod_CONST.Sprite.Mod:Load("gfx/005.100_collectible.anm2", true)
gunmod_CONST.Sprite.Player:Load("gfx/ui/main menu/characterportraits.anm2", true)
gunmod_CONST.Sprite.ModPlayer:Load("gfx/uicharacterportraits.anm2", true)
gunmod_CONST.Sprite.Pickup:Load("gfx/pickup.anm2", true)
gunmod_CONST.Sprite.Waldo:Load("gfx/waldohud.anm2", true)
gunmod_CONST.Sprite.Cursor:Load("gfx/leoncursor.anm2", true)
gunmod_CONST.Sprite.ScreenFade:Load("gfx/screenfade.anm2", true)
gunmod_CONST.Sprite.Bar:Load("gfx/uibar.anm2", true)
gunmod_CONST.Sprite.KnifeIcon:Load("gfx/uiknife.anm2", true)

--haha
error()
