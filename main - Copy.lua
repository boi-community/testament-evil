--MOD
local l = RegisterMod("Leon", 1)
local _log = {}
local game = Game()
local sfx = SFXManager()
local music = MusicManager()
local rng = RNG(); rng:SetSeed(Game():GetSeeds():GetStartSeed(), 0)
local config = Isaac.GetItemConfig()
local json = json or require("json")
local screensize = screensize or false
local isfullscreen = false
local cursorinbounds = true

--main data
l.data = {}; local gDAT = l.data
GUNMOD_VARS = {gunmode = false}; l.data.var = GUNMOD_VARS; local gVAR = GUNMOD_VARS;

--constants
pcall(require, "for lua/constants"); l.data.con = gunmod_CONST; local gCON = gunmod_CONST
	local EDF = gCON.EN.DF; local EAM = gCON.EN.AM; local ESP = gCON.EN.SP; local EIT = gCON.EN.IT;
	local EFM = gCON.EN.FM; local ECP = gCON.EN.CP;
	local CSP = gCON.Sprite;
	local ammo = gCON.Ammodat;
--user settings (move later)
pcall(require, "for lua/usersettings"); l.data.set = gunmod_SET; local gSET = gunmod_SET
--balance values
pcall(require, "for lua/balance"); l.data.bal = gunmod_BAL; local gBAL = gunmod_BAL
--sound effects
pcall(require, "for lua/sounds"); l.data.sfx = gunmod_SFX; local gSFX = gunmod_SFX; local snd = gSFX
--weapon data
pcall(require, "for lua/weapons"); l.data.wep = gunmod_WEP; local gWEP = gunmod_WEP
	local WEPT = gunmod_WEP.WeaponTypes
--item stats
pcall(require, "for lua/items"); l.data.itm = gunmod_ITEMS; local gITM = gunmod_ITEMS
--pocket items
pcall(require, "for lua/pocket"); l.data.poc = gunmod_POCKET; local gPOC = gunmod_POCKET
	local pocket = gPOC.dat
--characters
pcall(require, "for lua/isaacs"); l.data.chr = gunmod_CHR; local gCHR = gunmod_CHR

CL_white = Color(1, 1, 1, 1, 0, 0, 0)
CL_pencil = Color(54/255, 47/255, 45/255, 1, 0, 0, 0)
CL_pencil2 = Color(81/255, 70/255, 60/255, 1, 0, 0, 0)
CL_red = Color(94/255, 12/255, 12/255, 1, 0, 0, 0)
CL_blue = Color(44/255, 44/255, 60/255, 1, 0, 0, 0)
CL_green = Color(44/255, 60/255, 44/255, 1, 0, 0, 0)

local mouseinput = true
local padinput = false

local famcrit = {}
famcrit[3] = {3.5, 0} -- lil chubby
famcrit[6] = {4, 0} -- robo baby
famcrit[14] = {0, .5} -- dead bird
famcrit[15] = {0, .5} -- outline dead bird
famcrit[16] = {0, .5} -- daddy's foot
famcrit[17] = {0, .5} -- peeper's eye
famcrit[53] = {4, 0} -- robo baby 2.0
famcrit[59] = {10, .5} -- bob's brain
famcrit[61] = {10, 0} -- lil brimstone
famcrit[63] = {0, .33} -- lil haunt
famcrit[77] = {10, .5} -- ???'s only friend
famcrit[85] = {5, 0} -- lost fly
famcrit[87] = {5, 0} --- lil gurdy
famcrit[88] = {2, 0} -- bumbo
famcrit[96] = {2, 0} -- succubus
famcrit[118] = {2, 0} -- angry fly

--menu shit
local mfontdat = {}
mfontdat['a'] = {0,7,11};   mfontdat['b'] = {1,8,12};   mfontdat['c'] = {2,7,10};
mfontdat['d'] = {3,8,11};   mfontdat['e'] = {4,7,10};   mfontdat['f'] = {5,6,9};
mfontdat['g'] = {6,8,12};   mfontdat['h'] = {7,9,11};   mfontdat['i'] = {8,2,5};
mfontdat['j'] = {9,7,11};   mfontdat['k'] = {10,6,9};   mfontdat['l'] = {11,8,10};
mfontdat['m'] = {12,8,13};  mfontdat['n'] = {13,8,10};  mfontdat['o'] = {14,10,12};
mfontdat['p'] = {15,7,10};  mfontdat['q'] = {16,9,13};  mfontdat['r'] = {17,7,10};
mfontdat['s'] = {18,6,10};  mfontdat['t'] = {19,7,10};  mfontdat['u'] = {20,7,13};
mfontdat['v'] = {21,8,12};  mfontdat['w'] = {22,11,16}; mfontdat['x'] = {23,6,11};
mfontdat['y'] = {24,7,10};  mfontdat['z'] = {25,6,8};   mfontdat['0'] = {26,8,10};
mfontdat['1'] = {27,8,10};  mfontdat['2'] = {28,8,10};  mfontdat['3'] = {29,8,10};
mfontdat['4'] = {30,7,10};  mfontdat['5'] = {31,8,9};   mfontdat['6'] = {32,8,10};
mfontdat['7'] = {33,8,10};  mfontdat['8'] = {34,8,9};   mfontdat['9'] = {35,8,10};
mfontdat["'"] = {36,4,5};   mfontdat['"'] = {37,4,5};   mfontdat[':'] = {38,3,5};
mfontdat['/'] = {39,6,8};	  mfontdat['.'] = {40,2,4};  	mfontdat[','] = {41,3,5};
mfontdat['!'] = {42,4,6};   mfontdat['?'] = {43,6,8};	  mfontdat['['] = {44,4,6};
mfontdat[']'] = {45,4,6};   mfontdat['('] = {44,4,6};   mfontdat[')'] = {45,4,6};
mfontdat['$'] = {46,6,8};	  mfontdat['C'] = {47,6,8};   mfontdat['+'] = {48,6,8};
mfontdat['-'] = {49,6,8};  	mfontdat['X'] = {50,6,8};   mfontdat['D'] = {51,6,8};
mfontdat['%'] = {52,6,8}; 	mfontdat['_'] = {53,4,5};		mfontdat[' '] = {53,6,8};
mfontdat['B'] = {1,12,16};	mfontdat['='] = {1,8,12};

local mmenudir = {
	--LEVEL 1
	main = {
		title = 'paused!',
		valign = 0,
		buttons = {
			--{str = 'aabbccddeeffgg'},
			--{str = 'hhiijjkkllmmnn'},
			--{str = 'ooppqqrrssttuu'},
			--{str = 'vvwwxxyyzz1122'},
			--{str = '33445566778899'},
			--{str = '00:[]+-.,!'},
			{str = 'resume game', action = 'resume'},
			--{str = 'run stats', dest = 'stats'},
			{str = 'inventory', dest = 'inventory'},
			{str = 'settings', dest = 'settings'},
			--{str = 'achievements', dest = 'achievements'},
			{str = 'help', dest = 'help'},
			--{str = 'test', dest = 'test'},
		},
	},
	test = {
		title = 'item lore',
	},
	inventory = {
		title = 'inventory',
		inventory = true,
		valign = 1,
		buttons = {},
		pages = 0,
	},
	stats = {
		title = 'stats',
	},
	settings = {
		title = 'settings',
		buttons = {
			{str = 'gameplay', dest = 'gameplaysettings'},
			{str = 'hud', dest = 'hudsettings'},
			{str = 'misc', dest = 'miscsettings'},
		},
	},
	gameplaysettings = {
		title = 'gameplay settings',
		savesettings = true,
		buttons = {
			{str = 'difficulty',
				choices = {'wacky easy', 'easy', 'normal', 'hard', 'professional', 'impossible'},
				variable = 'Difficulty',
				setting = 3,
			},
			{str = 'darkness',
				choices = {'never', 'sometimes', 'always'},
				variable = 'CurseOfDarkness',
				setting = 2,
			},
			{str = 'damage spread',
				choices = {'off', 'low', 'high'},
				variable = 'DamageSpread',
				setting = 1,
			},
		},
	},
	hudsettings = {
		title = 'hud settings',
		savesettings = true,
		buttons = {
			{str = 'hud opacity',
				choices = {'off', '25%', '50%', '75%', '100%'},
				variable = 'HudOpacity',
				setting = 3,
			},
			{str = 'show stats',
				choices = {'never', 'in menu only', 'stat change', 'any change', 'always'},
				variable = 'ShowStats',
				setting = 3,
			},
			{str = 'custom cursor',
				choices = {'never', 'fullscreen', 'always in gm', 'always'},
				variable = 'ShowGunCursor',
				setting = 3,
			},
		},
	},
	miscsettings = {
		title = 'misc settings',
		savesettings = true,
		buttons = {
			{str = 'merchant voice',
				choices = {'never', 'some', 'spam', 'mega spam'},
				variable = 'MerchantVoice',
				setting = 2,
			},
			{str = 'light saturation',
				choices = {'0%', '50%', '75%', '100%', '150%', '200%'},
				variable = 'LightingSaturation',
				setting = 4,
			},
			{str = 'shot brightness',
				choices = {'0%', '25%', '50%', '75%', '100%'},
				variable = 'ShotFlashBrightness',
				setting = 4,
			},
		},
	},
	help = {
		title = 'help',
		buttons = {{str = "you're on"},{str = "your own kid"}},
	},
}

local mmenuvar = {
	open = false,
	item = mmenudir.main,
	idle = false,
	maskalpha = 1,
	hadgun = false,
	path = {},
}

local font1 = Font(); font1:Load("font/pftempestasevencondensed.fnt")

local Controller = {
    DPAD_LEFT = 0,
    DPAD_RIGHT = 1,
    DPAD_UP = 2,
    DPAD_DOWN = 3,
    BUTTON_LEFT = 4,
    BUTTON_RIGHT = 5,
    BUTTON_UP = 6,
    BUTTON_DOWN = 7,
    BUMPER_LEFT = 8,
    TRIGGER_LEFT = 9,
    ANALOGPRESS_LEFT = 10,
    BUMPER_RIGHT = 11,
    TRIGGER_RIGHT = 12,
    ANALOGPRESS_RIGHT = 13,
    SELECT = 14,
    START = 15
}


---LOCAL FUNCTIONS
local function log(...)
	local args = {...}
	for _, v in ipairs(args) do
		table.insert(_log, tostring(v))
	end
end

local function getScreenCenterPosition()
  local room = game:GetRoom()
  local centerOffset = (room:GetCenterPos()) - room:GetTopLeftPos()
  local pos = room:GetCenterPos()
  if centerOffset.X > 260 then
    pos.X = pos.X - 260
  end
  if centerOffset.Y > 140 then
    pos.Y = pos.Y - 140
  end
  return Isaac.WorldToRenderPosition(pos, false)
end

--good lerp
local function Lerp(aa, bb, cc)
	return (aa + (bb - aa) * cc)
end

local function TLerp(aa, bb, cc)
	local res = {}
	for i, v in ipairs(aa) do
		table.insert(res, (aa[i] + (bb[i] - aa[i]) * cc))
	end
	return res
end

--thing of math
local function approach(aa, bb, cc)
	cc = cc or 1
	if bb > aa then
		return math.min(aa + cc, bb)
	elseif bb < aa then
		return math.max(aa - cc, bb)
	else
		return bb
	end
end

--angular difference
local function angleDiff(aa, bb)
	return (((aa - bb) + 180) % 360) - 180
end

--insert first
local function insertFirst(table, newval)
	local cangrow = cangrow or false
	for i, val in ipairs(table) do
		if not val then
			table[i] = newval
			return i
		end
	end
	return (#table + 1)
end

local function stringSplit(str, sep)
	local ret = {}
	while str do
		local ind = string.find(str, sep)
		local len = string.len(sep)
		if ind then
			table.insert(ret, string.sub(str, 1, ind - 1))
			str = string.sub(str, ind + len, -1)
		else
			table.insert(ret, str)
			str = nil
		end
	end
	return ret
end

function isAny(func, ...)
	local args = {...}
	for i, arg in ipairs(args) do
		if func(arg) then
			return true
		end
	end
	return false
end


function unPack(t, i)
	i = i or 1
	if t[i] ~= nil then
		return t[i], unPack(t, i + 1)
	end
end

function l:leonCmd(cmd, params)
	local player = Isaac.GetPlayer(0)
	local d = player:GetData()
	local gun = d.mygun
	local multi = string.find(cmd..' '..params, '; ')
	if multi then
		local multicmd = stringSplit(cmd..' '..params, '; ')
		for i, newcmd in ipairs(multicmd) do
			Isaac.ExecuteCommand(newcmd)
			log(newcmd)
		end
	elseif cmd == 'ldebug' then
		local rstr = params == 'r' or false
		if gSET.DebugMode then
			gSET.DebugMode = false
			Isaac.ConsoleOutput('Debug mode off.')
		else
			gSET.DebugMode = true
			Isaac.ConsoleOutput('Debug mode on.')
		end
		if rstr then
			Isaac.ExecuteCommand("restart")
		end
	elseif cmd == 'lload' then
		local continue = params and params == 'true' and true or false
		l.loadData(continue)
	elseif cmd == 'stat' and gun then
		local params = stringSplit(params, ' ')
		local sub, mod = params[#params], {}

		for i = #params, 2, -1 do
			mod = {}
			mod[params[i - 1] ] = sub
			sub = mod
		end

		l.gunMod(gun, mod)
		l.gunSwitch(player, gun)
	elseif cmd == 'mod' and gun then
		local params = stringSplit(params, ' ')
		local all = params[1] == 'all'
		if all then
			table.remove(params, 1)
		end

		for i, mod in ipairs(params) do
			if all then
				for i = 1, 4 do
					gun = d.loadout[i]
					if gun then
						l.gunMod(gun, tonumber(mod))
						local upgrade = gun.upgrade[#gun.mods]
						if upgrade then
							l.gunMod(gun, upgrade, player)
						end
						gun.clip = gun.clipsize
					end
				end
			else
				l.gunMod(gun, tonumber(mod))
				local upgrade = gun.upgrade[#gun.mods]
				if upgrade then
					l.gunMod(gun, upgrade, player)
				end
				gun.clip = gun.clipsize
			end
		end

		l.gunSwitch(player, gun)
	elseif cmd == 'gun' then
		local params = stringSplit(params, ' ')
		local newgun = l.gunInit(params[1])

		newgun.playerowned = true
		if params[2] then for i = 1, tonumber(params[2]) do
			l.gunMod(newgun, gITM.modlist[1 + rng:RandomInt(#gITM.modlist)])
			local upgrade = newgun.upgrade[#newgun.mods]
			if upgrade then
				l.gunMod(newgun, upgrade, player)
			end
		end end
		newgun.clip = newgun.clipsize

		if not params[3] then
			insertFirst(d.loadout, newgun)
		else
			d.loadout[tonumber(params[3])] = newgun
		end
		l.gunSwitch(player, newgun)
	elseif cmd == 'toboss' then
		if params then
			Isaac.ExecuteCommand("stage "..params)
		end
		player:UseCard(5)
	elseif cmd == 'lspawn' then
		local spawns = {329, 118, 2, 245, 114, 360, 216, 8}
		local center = game:GetRoom():GetCenterPos()

		for i, spawn in ipairs(spawns) do
			Isaac.Spawn(5, 100, spawn, center + Vector(-40, -80) + Vector((i-1)*40, 0), Vector(0, 0), nil)
		end
		local check = {"hg", "hy", "hr"}
		for i = 1, 3 do
			for j, spawn in ipairs(check) do
				Isaac.Spawn(5, 300, pocket[spawn].id, center + Vector(-200, 60) + Vector((i-1)*40, (j-1)*30), Vector(0, 0), nil)
			end
		end
		check = {"am1", "am2", "am3", "am4", "am5", "am6", "am7"}
		for i, spawn in ipairs(check) do
			Isaac.Spawn(5, 300, pocket[spawn].id, center + Vector(-40, 120) + Vector((i-1)*40, 0), Vector(0, 0), nil)
		end
		check = {"gr", "gg", "gb"}
		for i, spawn in ipairs(check) do
			Isaac.Spawn(5, 300, pocket[spawn].id, center + Vector(80, 60) + Vector((i-1)*40, 0), Vector(0, 0), nil)
		end

		player.Position = center + Vector(-80, 0)
	elseif cmd == 'overachiever' then
		for i = 1, 999 do
			Isaac.ExecuteCommand("achievement "..i)
		end
	end
end
l:AddCallback(ModCallbacks.MC_EXECUTE_CMD, l.leonCmd)

local function getPrice(object, pricetype)
	local price = false
	local discount = Isaac.GetPlayer(0):HasCollectible(64)
	local bp = gBAL.buyprice
	local sp = gBAL.sellprice

	if pricetype == 'buy' then
		if object.kind == EIT.gun then
			price = bp.gun + (#object.id.mods * bp.gunmod)
			if object.id.name == "Rocket Launcher" then
				price = bp.rpg
			end
		elseif object.kind == EIT.mod then
			price = bp.mod
			price = math.max(price, 5)
		elseif object.kind == EIT.pocket then
			price = (pocket[object.id].price or bp.pocket) + ((pocket[object.id].type == 'herb' and gVAR.herbtax) or 0)
			price = math.max(price, 1)
		end
		if discount then
			price = price - 3
		end
		price = price + (object.sellmod or 0)
		price = math.max(price, 0)
	elseif pricetype == 'sell' then
		if object.kind == EIT.gun then
			price = sp.gun + (#object.id.mods * sp.gunmod)
			--for i, mod in ipairs(object.id.mods) do
			--	local mult = math.max(0, i-1)
			--	price = price + (mult * sp.gunlvl)
			--end
		elseif object.kind == EIT.mod then
			price = sp.mod
		elseif object.kind == EIT.pocket then
			price = (pocket[object.id].sell or sp.pocket)
		end
		price = math.max(price, 0)
		price = price * -1
	elseif pricetype == 'attach' then
		if object.kind == EIT.gun then
			price = bp.attach + (#object.id.mods * bp.attachlvl)
		elseif object.kind == EIT.mod then
			price = false
		end
	elseif pricetype == 'destroy' then
		price = bp.destroy
	end
	return math.ceil(price)
end

--bit ops
local function bit(x,p)
	return x * 2 ^ p
end
local function hasbit(x, p)
	return x % (p + p) >= p
end
local function setbit(x, p)
	return hasbit(x, p) and x or x + p
end
local function clearbit(x, p)
	return hasbit(x, p) and x - p or x
end

--goodest rounding
local function roundTo(fig, place)
	local result = math.floor((fig / place) + .5) * place
	return (result == math.floor(result) and math.floor(result)) or result
end

local acts = {}
acts[0] = ButtonAction.ACTION_LEFT
acts[1] = ButtonAction.ACTION_RIGHT
acts[2] = ButtonAction.ACTION_UP
acts[3] = ButtonAction.ACTION_DOWN
acts[4] = ButtonAction.ACTION_SHOOTLEFT
acts[5] = ButtonAction.ACTION_SHOOTRIGHT
acts[6] = ButtonAction.ACTION_SHOOTUP
acts[7] = ButtonAction.ACTION_SHOOTDOWN

local Controller = { -- thanks deadinfinity
	DPAD_LEFT = 0,
	DPAD_RIGHT = 1,
	DPAD_UP = 2,
	DPAD_DOWN = 3,
	BUTTON_LEFT = 4,
	BUTTON_RIGHT = 5,
	BUTTON_UP = 6,
	BUTTON_DOWN = 7,
	BUMPER_LEFT = 8,
	TRIGGER_LEFT = 9,
	ANALOGPRESS_LEFT = 10,
	BUMPER_RIGHT = 11,
	TRIGGER_RIGHT = 12,
	ANALOGPRESS_RIGHT = 13,
	SELECT = 14,
	START = 15
}

----FUNCTIONALITY
function l.getInput(pnum)
	local player = Isaac.GetPlayer(pnum)
	local d = player:GetData()
	--init
	if not d.input then
		d.input = {
			mode = 0,
			face = Vector(0, 0),
			timer = 0,
			lastframe = 0,
			numkey = false,
			action = 0,
			reload = false,
			actiontime = 0,
			aimdir = false,
			aimpress = false,
			shoot = false,
			swap = false,
			swappress = false,
			lastaimdir = Vector(0, 1),
			lastactiveaimdir = Vector(0, 1),
			mouse = mouseinput,
			pad = padinput,
			mousepress = 0,
			menu = {mousepos = Vector(0, 0), drag = Vector(0, 0), holdup = 0, holddown = 0, holdleft = 0, holdright = 0},
			movepressdir = Vector(0, 1),
			movepresstime = -100,
			doubletaptime = -100,
		}
	end
	local input = player:GetData().input
	local indx = player.ControllerIndex

	input.mode = 0;
	if (not mmenuvar.open) and CSP.Menu:IsFinished("Dissapear") then
		--welcome to hell
		input.mode = 1
		local sx = (Input.GetActionValue(acts[4], indx) * -1) + (Input.GetActionValue(acts[5], indx))
		local sy = (Input.GetActionValue(acts[6], indx) * -1) + (Input.GetActionValue(acts[7], indx))
		input.mode = 0
		--update frame
		local shootinput = Vector(sx, sy) --player:GetShootingInput()
		local shootinputang = shootinput:GetAngleDegrees()
		local likelygamepad = shootinputang % 45 ~= 0 or (sx + sy) % 1 ~= 0
		--log(player:GetMovementJoystick():Length() + player:GetShootingJoystick():Length() ~= 0)
		if likelygamepad then
			input.pad = true
			input.mouse = false
		end
		local shootkeys = {Keyboard.KEY_UP, Keyboard.KEY_DOWN, Keyboard.KEY_LEFT, Keyboard.KEY_RIGHT}
		for i = 1, 4 do
			if Input.IsButtonTriggered(shootkeys[i], indx) then
				input.pad = false
			end
		end

		--log(Input.IsActionPressed(ButtonAction.ACTION_BOMB, 0) or Input.IsActionPressed(ButtonAction.ACTION_BOMB, 1))

		local playerframe = false
		if input.lastframe ~= player.FrameCount then
			playerframe = true
		end
		input.lastframe = player.FrameCount
		--ignore inputs on pause
		if game:IsPaused() then
			input.cantact = true
			--input.cantshoot = true
		--not paused
		else
			local keyboard = false
			if (indx == 0 and gSET.Player1Keyboard) or (indx == 1 and gSET.Player2Keyboard) then
				keyboard = true
			end
			--get control method
			if keyboard then
				if Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT)
				or Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_MIDDLE)
				or Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_RIGHT) then
					input.mouse = true
					input.pad = false
				end
				if math.abs(shootinput.X) > gSET.DeadZone or math.abs(shootinput.Y) > gSET.DeadZone then
					input.mouse = false
				end
			else
				input.mouse = false
			end
			--main player only
			if pnum == 0 then
				--num keys
				local numkeys = {Keyboard.KEY_0, Keyboard.KEY_1, Keyboard.KEY_2, Keyboard.KEY_3, Keyboard.KEY_4, Keyboard.KEY_5, Keyboard.KEY_6, Keyboard.KEY_7, Keyboard.KEY_8, Keyboard.KEY_9}
				if playerframe then
					input.numkey = false
				end
				for i=1, #numkeys do
					if keyboard and Input.IsButtonTriggered(numkeys[i], indx) then
						input.numkey = i - 1
					end
				end
				--attache
				local action = false
				if Input.IsActionPressed(ButtonAction.ACTION_BOMB, indx) or (Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, indx) and keyboard) then
					action = true
				end
				if playerframe then
					input.actionpress = false
					input.actiontap = false
					input.actionrelease = false
				end
				if action then
					if input.action < 0 then
						input.actionpress = true
					end
						input.action = math.max(input.action + 1, 1)
				else
					if input.action > 0 then
						input.actiontime = input.action
						input.actionrelease = true
					end
					input.action = math.min(input.action - 1, -1)
				end
				--cancel action
				if playerframe and not action then
					input.cantact = false
				elseif input.cantact then
					input.cantact = true
					input.action = 0
					input.actionpress = false
					input.actionrelease = false
				end
			end
			--aim direction
			local shoot = false
			if Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT) and keyboard then
				input.mousepress = math.max(0, input.mousepress + 1)
			else
				input.mousepress = 0
			end
			local aim = shootinput:Normalized()
			local aimpress
			if math.abs(aim.X) <= gSET.DeadZone and math.abs(aim.Y) <= gSET.DeadZone then
				if input.mouse then
					aim = (Isaac.ScreenToWorld(Input.GetMousePosition()) - player.Position):Normalized()
				else
					aim = false
				end
			end
			if playerframe then
				input.aimpress = false
				input.shootpress = false
				input.shootrelease = false
			end
			if aim then
				if input.mouse then
					if input.mousepress > 0 then
						shoot = true
						aimpress = aim
						if input.mousepress == 1 then
							input.aimpress = true
							input.shootpress = true
						end
					end
				else
					shoot = true
					aimpress = aim
					if not input.aimdir then
						input.aimpress = true
						input.shootpress = true
					end
				end
			end
			if not shoot then
				if input.shoot then
					input.shootrelease = true
				end
			end
			input.shoot = shoot
			input.aimdir = aim
			input.lastaimdir = aim or input.lastaimdir
			input.lastactiveaimdir = aimpress or input.lastactiveaimdir
			--cancel shooting
			if playerframe and not (input.shoot or input.shootrelease) then
				input.cantshoot = false
			elseif input.cantshoot then
				input.cantshoot = true
				input.shootpress = false
				input.shoot = false
			end
			--swap
			if playerframe then
				input.swap = false
				input.swappress = false
			end
			if Input.IsActionPressed(ButtonAction.ACTION_DROP, indx) then
				input.swap = true
			end
			if Input.IsActionTriggered(ButtonAction.ACTION_DROP, indx) then
				input.swappress = true
			end
			--reload
			if playerframe then
				input.reload = false
			end
			if (Input.IsButtonTriggered(Keyboard.KEY_R, indx) and keyboard)
			or (Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_MIDDLE) and keyboard) then
				input.reload = true
			end
			--fullscreen
			if playerframe then
				input.fullscreen = false
			end
			if (Input.IsButtonTriggered(Keyboard.KEY_F, indx) and keyboard) then
				input.fullscreen = true
				isfullscreen = not isfullscreen
			end
			if (Input.IsButtonPressed(Keyboard.KEY_F, indx) and keyboard) then
				input.holdfullscreen = input.holdfullscreen or 0 + 1
				if input.holdfullscreen == 120 then
					isfullscreen = not isfullscreen
				end
			else
				input.holdfullscreen = 0
			end
			--quick knife
			if playerframe then
				input.knifepress = false
			end
			if input.mouse and Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_RIGHT) then
				if not input.knife then
					input.knifepress = true
				end
				input.knife = true
			else
				input.knife = false
			end
			--movement + knife special input
			local moveinput = player:GetMovementInput()
			if moveinput:Length() > .35 then
				if not input.movepress then
					local prevdir = input.movepressdir
					local prevtime = input.movepresstime

					input.movepressdir = moveinput
					input.movepresstime = game:GetFrameCount()

					if input.movepresstime - prevtime < 8 then
						local angdif = angleDiff(prevdir:GetAngleDegrees(), moveinput:GetAngleDegrees())
						if math.abs(angdif) < 15 then
							input.doubletaptime = game:GetFrameCount()
						end
					end
				end
				input.movepress = true
			else
				input.movepress = false
			end
			--scroll wheel
			if keyboard then
				--never mind I guess there's no scroll wheel support
			end
			--timer
			input.timer = input.timer + 1
			local lad = input.lastaimdir:Normalized()
			input.face = {
				math.max(lad.X * -1, 0),
				math.max(lad.X, 0),
				math.max(lad.Y * -1, 0),
				math.max(lad.Y, 0),
			}
			--
			mouseinput = input.mouse
			padinput = input.pad
		end
	end
	--menu
	if pnum == 0 then
		local menu = input.menu
		menu.toggle = false
		menu.up = false
		menu.down = false
		menu.left = false
		menu.right = false
		menu.dleft = false
		menu.dright = false
		menu.confirm = false
		menu.back = false
		menu.click = false
		menu.mousemove = false
		if not game:IsPaused() then
			if Input.GetMousePosition().X ~= menu.mousepos.X or Input.GetMousePosition().Y ~= menu.mousepos.Y then
				menu.mousemove = true
			end
			if Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT) then
				menu.drag = menu.drag + (Input.GetMousePosition() - menu.mousepos)
				if menu.drag.X < -25 then
					menu.drag = Vector(0, 0)
					menu.dright = true
				elseif menu.drag.X > 25 then
					menu.drag = Vector(0, 0)
					menu.dleft = true
				end
			else
				menu.drag = Vector(0, 0)
			end
			if Input.IsButtonTriggered(Keyboard.KEY_C, indx) or Input.IsButtonTriggered(Keyboard.KEY_I, indx) then
				menu.toggle = true
			end
			if Input.IsButtonTriggered(Keyboard.KEY_UP, indx) or
			Input.IsButtonTriggered(Keyboard.KEY_W, indx) or
			(menu.holdup >= 18 and menu.holdup % 6 == 0) then
				menu.up = true
			end
			if Input.IsButtonTriggered(Keyboard.KEY_DOWN, indx) or
			Input.IsButtonTriggered(Keyboard.KEY_S, indx) or
			(menu.holddown >= 18 and menu.holddown % 6 == 0)  then
				menu.down = true
			end
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT, indx) or
			Input.IsButtonTriggered(Keyboard.KEY_A, indx) or
			(menu.holdleft >= 18 and menu.holdleft % 6 == 0)  then
				menu.left = true
			end
			if Input.IsButtonTriggered(Keyboard.KEY_RIGHT, indx) or
			Input.IsButtonTriggered(Keyboard.KEY_D, indx) or
			(menu.holdright >= 18 and menu.holdright % 6 == 0)  then
				menu.right = true
			end
			if Input.IsButtonTriggered(Keyboard.KEY_ENTER, indx) or
			Input.IsButtonTriggered(Keyboard.KEY_E, indx) or
			Input.IsButtonTriggered(Keyboard.KEY_SPACE, indx) then
				menu.confirm = true
			end
			if Input.IsButtonTriggered(Keyboard.KEY_BACKSPACE, indx) or
			Input.IsButtonTriggered(Keyboard.KEY_Q, indx) or
			(Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_RIGHT) and not menu.mouse2) then
				menu.back = true
			end
			if (Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT) and not menu.mouse1) then
				menu.click = true
			end
			menu.holdup = ((Input.IsButtonPressed(Keyboard.KEY_UP, indx) or Input.IsButtonPressed(Keyboard.KEY_W, indx)) and menu.holdup + 1) or 0
			menu.holddown = ((Input.IsButtonPressed(Keyboard.KEY_DOWN, indx) or Input.IsButtonPressed(Keyboard.KEY_S, indx)) and menu.holddown + 1) or 0
			menu.holdleft = ((Input.IsButtonPressed(Keyboard.KEY_LEFT, indx) or Input.IsButtonPressed(Keyboard.KEY_A, indx)) and menu.holdleft + 1) or 0
			menu.holdright = ((Input.IsButtonPressed(Keyboard.KEY_RIGHT, indx) or Input.IsButtonPressed(Keyboard.KEY_D, indx)) and menu.holdright + 1) or 0
		end
		menu.mouse1 = Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT)
		menu.mouse2 = Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_RIGHT)
		menu.mousepos = Input.GetMousePosition()
	end
	--spawntest
	if not game:IsPaused() then
		if Input.IsButtonTriggered(Keyboard.KEY_X, indx) and pnum == 0 then
			local center = game:GetRoom():GetCenterPos()
			local guinea = Isaac.Spawn(231, 0, 0, Isaac.GetFreeNearPosition(center, 0), Vector(0, 0), nil)
			--l.gunUserInit(guinea)
			--local ggun = l.gunInit('smg', false)
			--l.gunSwitch(guinea, ggun)
		end
		if Input.IsButtonTriggered(Keyboard.KEY_V, indx) and pnum == 0 then
			local center = game:GetRoom():GetCenterPos()
			local guinea = Isaac.Spawn(10, 1, 0, Isaac.GetFreeNearPosition(center, 0), Vector(0, 0), nil)
			--l.gunUserInit(guinea)
			--local ggun = l.gunInit('smg', false)
			--l.gunSwitch(guinea, ggun)
		end
	end
end

--GUN MODE INIT
function l.gunModeInit()
	log('gun mode initialized')
	screensize = Isaac.WorldToScreen(game:GetRoom():GetCenterPos()) * 2
	local player = Isaac.GetPlayer(0)
	local level = game:GetLevel()

	--base
	gVAR = {}
	mmenuvar.open = false
	gVAR.gunmode = true
	gVAR.isgreed = game:IsGreedMode()
	gVAR.stats = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	gVAR.dstats = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	gVAR.cstats = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	gVAR.pstats = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	gVAR.tstats = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	gVAR.istats = {false, false, false, false, false, true, false, false, false, false, false, true, true}
	gVAR.guns = nil; gVAR.guns = {}
	gVAR.gunusers = {}
	gVAR.bullets = {}

	--level
	gVAR.waslabyrinth = false
	gVAR.islabyrinth = true--hasbit(game:GetLevel():GetCurses(), LevelCurse.CURSE_OF_LABYRINTH)
	--level:ApplyCompassEffect(true)

	--time
	gVAR.renderframe = 0
	gVAR.gametime = 0
	gVAR.pausedtime = 0
	gVAR.timerpause = true
	gVAR.roomframes = 0
	--gVAR.beatlasttimer = true
	gVAR.lastenemyframe = -100
	gVAR.stagetime = 0
	--gVAR.levellimbo = false
	if gVAR.islabyrinth then
		gVAR.partime = gBAL.partimel[1] * 60 * 30
	else
		gVAR.partime = gBAL.partime[1] * 60 * 30
	end

	--guns
	gVAR.shotnum = 0
	gVAR.bulletnum = 0
	gVAR.skillsecondslot = false
	gVAR.shotsounds = {}
	gVAR.sndloopguns = {}

	--economy
	gVAR.herbtax = 0
	gVAR.merchantinv = {{},{},{}}
	gVAR.merchantinit = false
	gVAR.needammo = {true, false, false, false, false, false, false}

	--pockets
	gVAR.roomcollectibles = {}
	gVAR.bosshp = 0
	gVAR.bossmaxhp = 0
	gVAR.bosssteals = 0
	gVAR.bossstealables = 0
	gVAR.bossdropherbmult = 1
	gVAR.bossdropammomult = 1
	gVAR.bossdropnademult = 1

	--gVAR.bossdrops = false
	--gVAR.bosscoins = false
	gVAR.bossteal = 0
	gVAR.ammodue = false
	gVAR.yellowherbs = 0
	gVAR.ammodue = nil
	gVAR.cashdrop = 1
	gVAR.grenadedrop = 1
	gVAR.pickupfade = false

	--misc
	--player:GetEffects():AddCollectibleEffect(21, false)
	mmenuvar.open = false
	gVAR.lastflame = -100
	gVAR.roomchanges = 0
	gVAR.damagespread = 1

	--gun sale sets
	gVAR.gunstock = {{},{},{}}
	for type, wep in pairs(WEPT) do
		if wep.meta and wep.meta.forsale then
			table.insert(gVAR.gunstock[wep.meta.rank or 1], type)
		end
	end
	l.shopUpdate()

	game:GetLevel():RemoveCurse(LevelCurse.CURSE_OF_MAZE)
	game:GetLevel():RemoveCurse(LevelCurse.CURSE_OF_THE_LOST)

	l.newLevelShit()
end

--SHOP GENERATION
function l.shopUpdate()
	local curstage = game:GetLevel():GetStage()

	local gunsets = gVAR.gunstock

	local modset = {}
	modset = gITM.modlist -- quick temp

	local maxguns = 4; local maxmods = 2;
	local numguns = 2; local nummods = 3;
	local gunrank = 1;

	--if gVAR.waslabyrinth then
	--	maxmods = maxmods * 2
	--	num = nummods * 2
	--end

	--stage:	1			2			3			4			5			6			7			8			9			10			11			12
	--norm:		1-1		1-2		2-1		2-2		3-1		3-2		4-1		4-2		bw		sh/ca		dr/ch		vo
	--greed: 	1			2			3			4			she		sho		ug
	if not gVAR.isgreed then
		--standard gun rank
		if curstage >= 8 then
			gunrank = 3
		elseif curstage >= 5 then
			gunrank = 2
		end
	end

	--guns

	if numguns > 0 then
		while #gVAR.merchantinv[1] + numguns > maxguns do
			table.insert(gunsets[gunrank], gVAR.merchantinv[1][1].id.meta.type)
			table.remove(gVAR.merchantinv[1], 1)
		end
		for i, object in ipairs(gVAR.merchantinv[1]) do
			local pickmod = modset[1 + rng:RandomInt(#modset)]
			l.gunMod(object.id, pickmod)
		end
		for i = 1, numguns do
			if #gunsets[gunrank] > 0 then
				local pick = 1 + rng:RandomInt(#gunsets[gunrank])
				local object = {id = l.gunInit(gunsets[gunrank][pick])}
				table.insert(gVAR.merchantinv[1], object)
				table.remove(gunsets[gunrank], pick)
			end
		end
	end
	--mods
	if nummods > 0 then for i = 1, nummods do
		local object = {id = modset[1 + rng:RandomInt(#modset)]}
		table.insert(gVAR.merchantinv[2], object)
	end end
	while #gVAR.merchantinv[2] > maxmods do
		table.remove(gVAR.merchantinv[2], 1)
	end
	--early bird mod
	for i = 1, (gVAR.waslabyrinth and false and 2 or 1) do
		local object = {id = modset[1 + rng:RandomInt(#modset)], sellmod = -gBAL.buyprice.earlydiscount}
		object.earlybird = gVAR.beatlasttimer
		object.soldout = not gVAR.beatlasttimer
		table.insert(gVAR.merchantinv[2], object)
	end

	--pockets (special)
	local drop = l.getDropTable()
	gVAR.merchantinv[3] = {
		{id = randWeight(drop, drop.merchherb)[3]},
		{id = randWeight(drop, drop.pickammo)[3]},
	}

	--early bird pocket
	local object = {id = randWeight(drop, drop.pickammo)[3], sellmod = -gBAL.buyprice.earlydiscount}
	object.earlybird = gVAR.beatlasttimer
	object.soldout = not gVAR.beatlasttimer
	table.insert(gVAR.merchantinv[3], object)

	--debug give stuff
	if gSET.DebugMode then
		gVAR.merchantinv[1] = {}
		for i, gun in pairs(WEPT) do
			if gun.meta.forsale then
				local object =  {id = l.gunInit(i)}
				table.insert(gVAR.merchantinv[1], object)
			end
		end
	end
end

--GET LAST OWNED GUN
function l.getLastGun(hist, gun)
	local res = false
	for i, pick in ipairs(hist) do
		if pick.playerowned and pick ~= gun then
			res = pick
			break
		end
	end
	return res
end

--CHECK GUN OWNERSHIP
function l.checkHasGuns(player)
	local d = player:GetData()
	for i, pick in ipairs(d.loadout) do
		if pick and not pick.playerowned then
			d.loadout[i] = false
			--table.remove(d.loadout, i)
			break
		end
	end
	if d.mygun and not d.mygun.playerowned then
		l.gunSwitch(player, l.getLastGun(d.gunhistory, d.mygun))
	end
end

--GUN PLAYER INIT
function l.gunUserInit(en)
	local d = en:GetData()
	table.insert(gVAR.gunusers, en)
	d.gunuser = true
	d.activeuntil = -100
	d.mygun = false
	d.guncontrol = {
		shoot = false,
		aiming = false,
		aim = Vector(0, 1),
		reload = false,
		dotaim = Vector(0, 0),
	}
	d.gunanim = {
		dir = 0,
		side = -1,
		aiming = false,
		rot = 0,
		dist = 0,
		recoil = 0,
		height = gCON.gunheight,
		size = en.Size
	}
	d.gunstat = {
		Damage = gCON.enstats.Damage,
		MaxFireDelay = gCON.enstats.MaxFireDelay,
		ShotSpeed = gCON.enstats.ShotSpeed,
		TearHeight = gCON.enstats.TearHeight,
		Luck = gCON.enstats.Luck,
	}
	d.gunners = {en}
	if en.Type == 1 and en.Variant == 0 then
		--get player type's data
		local playertype = en:GetPlayerType()
		log('player type '..playertype..' init')
		local getname = en:GetName()
		local pdat = gCHR['p'..en:GetPlayerType()] or gCHR[getname] or gCHR['Default']
		if not pdat.weapons then
			pdat = gCHR['Default']
		end
		--start variables
		d.mygun = false
		d.loadout = {}; d.passives = {}; d.mods = {}; d.perks = {}; d.gunhistory = {}
		d.modchar = playertype > 17; d.icon = gunmod_CHRICONS[playertype + 1] or pdat.icon or 'Unknown';
		gVAR.modall = pdat.modall
		d.descrip = pdat.skilldesc
		d.charstats = pdat.stats
		d.invstate = 'closed'
		d.knifespeedbonus = 0
		d.idle = true
		--give ammo
		local mx = gBAL.maxclips
		--d.clips = {mx[1], mx[2], mx[3], mx[4], 0, 0, 0, 0}
		d.clips = {mx[1], mx[2], mx[3], mx[4], mx[5], mx[6], mx[7], 0}

		--remove items
		if pdat.remove then for i, item in ipairs(pdat.remove) do
			en:RemoveCollectible(item)
		end end
		--give held mods
		if pdat.mods and #pdat.mods > 0 then for i, mod in ipairs(pdat.mods) do
			table.insert(d.mods, mod)
		end end
		--give perks
		if pdat.perks and #pdat.perks > 0 then for i, perk in ipairs(pdat.perks) do
			d.perks[perk] = true
		end end
		--give weapons
		for i, wep in ipairs(pdat.weapons) do
			local newgun = {}
			l.gunInit(wep[1], true, newgun)
			if wep[2] then
				l.gunMod(newgun, wep[2])
				local upgrade = newgun.upgrade[#newgun.mods]
				if upgrade then
					l.gunMod(newgun, upgrade, en)
				end
			end
			table.insert(d.loadout, newgun)
			newgun.playerowned = true
		end
		--remove redundant weapons from shops
		if pdat.nosale then
			for i, nos in ipairs(pdat.nosale) do
				for j, set in ipairs(gVAR.gunstock) do
					for k, type in ipairs(set) do
						if type == nos then
							table.remove(set, k)
							k = k - 1
						end
					end
				end
			end
		end
		--set initial gun use order
		for i = #d.loadout, 1, -1 do
			local gun = d.loadout[i]
			if gun then
				table.insert(d.gunhistory, 1, gun)
				l.gunSwitch(en, gun, false)
				gun.clip = gun.clipsize
			end
		end
		l.gunSwitch(en, d.loadout[1], false)
		for i = 1, 4 do
			d.loadout[i] = d.loadout[i] or false
		end
		--give schoolbag
		en:AddCollectible(534, 0, false)
		en:RemoveCostume(config:GetCollectible(534))
		--give passives
		if pdat.passives then for i, pas in ipairs(pdat.passives) do
			if config:GetCollectible(pas).Type ~= ItemType.ITEM_ACTIVE then
				table.insert(d.passives, pas)
			end
			en:AddCollectible(pas, 999, true)
		end end
		--en:AddCostume(config:GetCollectible(425), false)
		en:GetEffects():AddCollectibleEffect(425)
	else
		d.clips = {5, 5, 5, 5, 5, 5, 5, 0}
	end
end


--PLAYER INIT
function l:playerInit(player)
  local isleon = player:GetPlayerType() == gCON.Leon.Type
	if gVAR and gVAR.gunmode then
		log('gunmode off')
		gVAR.gunmode = false
		--if game:GetSeeds():HasSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LABYRINTH) then
		--	game:GetSeeds():RemoveSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LABYRINTH)
		--	Isaac.ExecuteCommand("stage 1")
		--end
		--game:GetSeeds():RemoveSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LABYRINTH)
		--Isaac.ExecuteCommand("stage 1")
	end
	if isleon then
		player:AddNullCostume(gCON.Leon.Costume)
		sfx:Play(SoundEffect.SOUND_ALGIZ, 1, 0, false, 1)
	end
end
l:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, l.playerInit)

--GAME START
function l:onGameStarted(continue)
	Isaac.ConsoleOutput('Game started\n')
	local player = Isaac.GetPlayer(0)
	local isleon = player:GetPlayerType() == gCON.Leon.Type

	rng = RNG()
	rng:SetSeed(Game():GetSeeds():GetStartSeed(), 0)

	if not continue then
		if (not vanillalabyrinth) and hasbit(game:GetLevel():GetCurses(), LevelCurse.CURSE_OF_LABYRINTH) then
			local suf = {'','a','b'}
			local exc = "stage 1"..suf[1 + game:GetLevel():GetStageType()]
			Isaac.ExecuteCommand(exc)
		end
	end

	gVAR = {gunmode = false}
	mmenuvar.open = false

	for i, en in ipairs(Isaac.GetRoomEntities()) do
		if en.Type == 3 and en.Variant == gCON.Variant.Weapon then
			en:Remove()
		end
	end

	-- NEW GAME
	if not continue then
		local center = game:GetRoom():GetCenterPos()
		Isaac.Spawn(5, 100, gCON.Id.AttacheCase, Isaac.GetFreeNearPosition(center + Vector(-200, -80), 0), Vector(0, 0), nil)
	-- CONTINUE GAME
	else
	end

	--PLAYING AS LEON
	if isleon then
		if not continue then
			player:AddMaxHearts(-2, false)
			player:SetCard(0, pocket.hg.id)
		else
			player:AddNullCostume(gCON.Leon.Costume)
		end
	end
	player:AddCacheFlags(CacheFlag.CACHE_ALL)
	player:EvaluateItems()

	--LOAD THING
	l.loadData(continue)

	--initialize menu settings variables
	for i, page in pairs(mmenudir) do
		if page.savesettings then
			for j, button in ipairs(page.buttons) do
				button.setting = gSET[button.variable] or button.setting or 1
				--Isaac.ConsoleOutput('loading '..button.variable..' as '..gSET[button.variable]..'\n')
			end
		end
	end

end
l:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, l.onGameStarted)

--GENERAL UPDATE
function l:post_update()
	if gVAR.gunmode then
		local player = Isaac.GetPlayer(0)
		local d = player:GetData()
		local room = game:GetRoom()
		--time itself

		if not (gVAR.timerpause or gVAR.inbossrush or mmenuvar.open or gVAR.levellimbo) then
			gVAR.gametime = gVAR.gametime + 1
			gVAR.stagetime = gVAR.stagetime + 1
		else
			gVAR.pausedtime = gVAR.pausedtime + 1
		end
		game.TimeCounter = gVAR.gametime
		game.BossRushParTime = 36000 + gVAR.pausedtime
		game.BlueWombParTime = 54000 + gVAR.pausedtime
		--player death
		if player:IsDead() then
			l.gunSwitch(player, nil)
			if player:WillPlayerRevive() then
			else
				log('you died lol haha')
				--gVAR.gunmode = false
				--game:GetSeeds():RemoveSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LABYRINTH)
			end
		end

		--gun management
		for i, gun in ipairs(gVAR.guns) do
			gun.firedelay = gun.firedelay - 1--math.max(0, gun.firedelay - 1)
			if gun.sp[ESP.laserp5] and rng:RandomFloat() < .5 then
				gun.firedelay = gun.firedelay - 1--math.max(0, gun.firedelay - 1)
			end
			if gun.firemode == EFM.auto then
				if gun.firedelay >= 0 then
					gun.spread = approach(gun.spread, gun.spreadmax, (gun.spreadmax * gun.spreadgain) / 30)
				else
					gun.spread = approach(gun.spread, gun.spreadmin, (gun.spreadmax * gun.spreadgain) / 30)
				end
			elseif gun.firemode == EFM.charge then
				if gun.chargescale then
				elseif gun.firingshots then
					gun.spread = approach(gun.spread, gun.spreadmax, (gun.spreadmax * gun.spreadgain) / (30 / 3))
				else
					gun.spread = math.max(gun.spreadmin, gun.spread - (gun.spreadloss or 0))
				end
			end
			if gun.revtime and not gun.using then
				gun.rev = approach(gun.rev or 0, 0, 1)
			end
			if gun.singleuse and not ((gun.chamber > 0 or gun.clip > 0) or (gun.specialbullet and gun.specialbullet:Exists())) then
				gun.untilremove = (gun.untilremove or 15) - 1
				if gun.untilremove == 0 then
					gun.playerowned = false
					l.checkHasGuns(player)
				end
			end
			if gun.juicetimer > 0 then
				gun.juicetimer = gun.juicetimer - 1
				if gun.juicetimer == 0 then
					gun.prejuice = gun.juice
				end
			end
			if gun.qdtime then
				gun.qdtime = gun.qdtime - 1
				if gun.qdtime == 0 or gVAR.roomchanged or (gun ~= d.mygun) then
					gun.qdtime = nil
					gun.ms.damage = gun.ms.damage / 3
					gun.as.movespeed = gun.as.movespeed - gun.qdspeed
					gun.qdspeed = nil
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
					player:AddCacheFlags(CacheFlag.CACHE_SPEED)
					player:EvaluateItems()
				end
			end
			if gun.protime then
				gun.protime = gun.protime - 1
				if gun.protime == 0 or gVAR.roomchanged or (gun ~= d.mygun) then
					gun.ms.maxfiredelay = gun.ms.maxfiredelay * 2
					gun.reloadbullet = gun.reloadbullet * 2
					gun.protime = nil
					player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
					player:EvaluateItems()
				end
			end
			if gVAR.roomchanged or (gun ~= d.mygun) then
				gun.ksvictims = nil
				gun.forcetarget = nil
				gun.refundableshots = nil
				--gun.freeshots = nil
			end
			--if gun ~= d.mygun then
			--	gun.freeshots = 0
			--end
		end
		--bullets
		for i, shot in ipairs(gVAR.bullets) do
			if not shot:Exists() then
				table.remove(gVAR.bullets, i)
				i = i - 1
			else
				local sd = shot:GetData()
				if shot.StickTarget and not shot.StickTarget:Exists() then
					shot.StickTarget = nil
				end
				if sd.framelife and not shot.StickTarget then
					if sd.framelife <= 0 and not sd.infrange then
						local poof = Isaac.Spawn(1000, 12, 0, shot.Position, Vector(0, 0), shot)
						poof.PositionOffset = shot.PositionOffset
						poof.SpriteScale = Vector(.7, .7) * shot.Scale
						if sd.enemy then
							poof.Color = Color(.8, 0, 0, 1, 0, 0, 0)
						else
							poof.Color = shot.Color
						end
						shot:Remove()
					end
					if not sd.enemy then
						if (not sd.antigravity) or (sd.spawner and (not sd.spawner:GetData().guncontrol.load)) then
							shot.WaitFrames = math.min(shot.WaitFrames, 1)
							sd.framelife = approach(sd.framelife, 0, 1)
							if sd.shrink then
								local scale = math.max(0, math.min(1, sd.framelife / sd.maxframelife))
								shot.Scale = scale + .25
								shot.CollisionDamage = sd.basecollisiondamage * (.5 + (scale * .5))
							end
							sd.antigravity = nil
						end
					end
					--rpg
					if sd.rpg then
						sd.gun.specialbullet = shot
						shot.SpriteRotation = shot.Velocity:GetAngleDegrees()
						if shot.FrameCount % 15 == 1 then
							sfx:Play(snd.shoot.flame.loop, 1, 0, false, 1)
						end
						if true then
							local smoke = Isaac.Spawn(1000, 88, 0, shot.Position + shot.Velocity:Normalized() * -15, (shot.Velocity * -.5):Rotated(-40 + (rng:RandomFloat() * 80)), shot)
							smoke:GetSprite().Color = Color(1, 1, 1, 1, 75, 75, 75)
							smoke.PositionOffset = shot.PositionOffset
						end
						if shot.Velocity:Length() < 15 then
							shot.Velocity = Lerp(shot.Velocity, shot.Velocity:Resized(15), .2)
						end
					end
				end
				if sd.gun and sd.gun.laserguide and sd.gun.laserdotent then
					local dot = sd.gun.laserdotent
					if not shot.StickTarget then
						local angtgt = (dot.Position - shot.Position):GetAngleDegrees()
						local diff = angleDiff(angtgt, shot.Velocity:GetAngleDegrees())
						local fix = diff
						local maxfix = math.min(15, shot.FrameCount)
						fix = math.max(maxfix * -1, math.min(maxfix, fix))
						shot.Velocity = shot.Velocity:Rotated(fix)
						if sd.gun.nikita and shot.Velocity:Length() > 6 and not (fix < 15 and fix > -15) then
							shot.Velocity = shot.Velocity:Resized(6)
						end
					else
						local ent = shot.StickTarget
						local usemass = math.min(50, math.max(ent.Mass, 10))
						local push = (dot.Position - shot.Position) / (usemass * 8)
						local maxvel = math.max(ent.Velocity:Length(), 10)
						ent.Velocity = ent.Velocity + push
						if ent.Velocity:Length() > maxvel then
							ent.Velocity = ent.Velocity:Resized(maxvel)
						end
					end
				end
			end
		end
		--gun users
		for i, en in ipairs(gVAR.gunusers) do
			if not en:Exists() then
				table.remove(gVAR.gunusers, i)
				i = i - 1
			else
				l.gunMaster(en)
			end
		end
		--detecting if a collectible was picked up
		if gVAR.roomcollectibles and #gVAR.roomcollectibles > 0 then
			for i, item in ipairs(gVAR.roomcollectibles or {}) do
				if item[2] ~= 0 and ((not item[1]:Exists()) or item[1].SubType == 0) then
					d.newitems = d.newitems or {}
					table.insert(d.newitems, item[2])
				end
			end
		end
		gVAR.roomcollectibles = {}
		gVAR.bosshp = 0; gVAR.bossmaxhp = 0
		gVAR.bosslives = false
		for i, en in ipairs(Isaac.GetRoomEntities()) do
			local type = en.Type
			local variant = en.Variant
			local subtype = en.SubType
			--ENMIESS
			if en:IsVulnerableEnemy() and en.MaxHitPoints > 0 and type ~= 33 then
				--LAST ENEMY SPOTTED
				gVAR.lastenemyframe = game:GetFrameCount()
				--contact damage
				if en.FrameCount == 20 then
					local ed = en:GetData()
					if ed.CollisionDamage then
						en.CollisionDamage = ed.CollisionDamage
						ed.CollisionDamage = nil
					end
				end
				--pro time slowdown
				if d.mygun and d.mygun.protime then
					if en:IsBoss() then
						en:AddSlowing(EntityRef(player), 5 * 30, 10, Color(.5, .5, .5, 1, 25, 25, 25))
					else
						en:AddSlowing(EntityRef(player), 1, .5, Color(.5, .5, .5, 1, 25, 25, 25))
					end
				end
				--portal nerf
				if type == 306 then
					if en:ToNPC().State == 8 then
						en.HitPoints = en.HitPoints - 5
					end
				end
			end
			--MERCHANT
			if type == 6 and variant == gCON.Variant.Merchant then
				l.merchantUpdate(en)
			end
			--BOSSES
			if en:IsBoss() then
				gVAR.bosslives = true
				gVAR.lastbosspos = en.Position
				gVAR.bosshp = gVAR.bosshp + en.HitPoints
				gVAR.bossmaxhp = gVAR.bossmaxhp + en.MaxHitPoints
				if type == 412 then
					gVAR.deliriumfight = true
				end
				if type == 406 or type == 407 or gVAR.deliriumfight then
					local ed = en:GetData()
					if ed.qdamage and ed.qdamage > 0 and (ed.lasthp - en.HitPoints) > 0 then
						local damagedif = ed.lasthp - en.HitPoints
						local damagedif2 = ed.qdamage - damagedif
						if damagedif2 > 0 then
							en.HitPoints = en.HitPoints - math.min(ed.qdamage, damagedif2)
						end
						ed.qdamage = 0
					end
				end
				-- mega boss drops
				if type == 406 or type == 407 or type == 412 then
					if not gVAR.superboss then
						gVAR.superboss = true
						local drop = l.getDropTable()
						gVAR.bossdrops = {}; gVAR.bosscoins = {}
						local dropclass = drop.bossdrop
						local dropnum = 13
						local coins = 20
						gVAR.bosssteals = 10; gVAR.bossstealables = 10
						for i = 1, dropnum do
							table.insert(gVAR.bossdrops, randWeight(drop, drop.superbossdrop))
						end
						for i = 1, coins do
							table.insert(gVAR.bosscoins, randWeight(drop, drop.bosscoin))
						end
					end
				end
			end
		end
		--leave room detect
		local ppos = player.Position
		local clamp = room:GetClampedPosition(ppos, player.Size)
		local clampdif = math.max(math.abs(ppos.X - clamp.X), math.abs(ppos.Y - clamp.Y))
		if clampdif > 1 then
			local shouldfade = false
			for i = 0, 7 do
				door = room:GetDoor(i)
				if door and door:IsOpen() and (door.Position - ppos):Length() < 40 then
					shouldfade = true
				end
			end
			if shouldfade then
				gVAR.pickupfade = true
				if gSET.Difficulty >= gBAL.temppickupsmindif then
					for i, en in ipairs(Isaac.GetRoomEntities()) do
						if clampdif >= 23 and game:IsPaused() then
							if en.Type == 5 and en.Variant ~= 100 then
								if en.Variant == 300 and en.SubType == pocket[gPOC.herblist[2] ].id then
									gVAR.yellowherbs = gVAR.yellowherbs - gBAL.yellowherb.failpity
									log('you left a yellow herb you dumbass')
									log(gVAR.yellowherbs..' / '..gBAL.yellowherbtgt[game:GetLevel():GetStage()]..' yellows')
								end
								en:Remove()
							elseif en.Type == 6 and en.Variant == gCON.Variant.Merchant then
								en:Remove()
							end
						end
					end
				end
			else
				gVAR.pickupfade = false
			end
		else
			gVAR.pickupfade = false
		end
		--boss rush thing
		if gVAR.bosslives and not gVAR.bosslived then
			if game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH then
				log('boss rush wave spawned')
				local drop = l.getDropTable()
				gVAR.bossdrops = {}; gVAR.bosscoins = {}
				local dropnum = 2 + rng:RandomInt(2)
				for i = 1, dropnum do
					table.insert(gVAR.bossdrops, randWeight(drop, drop.rushdrop) or nil)
				end
				gVAR.bosssteals = 1
				gVAR.bossstealables = 1
				local coins = 3 + rng:RandomInt(5)
				for i = 1, coins do
					table.insert(gVAR.bosscoins, randWeight(drop, drop.bosscoin))
				end
			end
		end
		--whats a shop
		for i = 0, 7 do
			local door = room:GetDoor(i)
			if door and door.TargetRoomType == RoomType.ROOM_SHOP then
				--door:SetLocked(true)
				door:Bar()
			end
		end
		-- a sound
		if game:GetFrameCount() - gVAR.lastflame < 2 then
			if not gVAR.flamesound then
				gVAR.flamesound = true
				sfx:Play(snd.misc.fireburn, 1, 0, true, 1)
			end
		elseif gVAR.flamesound then
			sfx:Stop(snd.misc.fireburn)
			gVAR.flamesound = false
		end
		--damage spread
		if gSET.DamageSpread and game:GetFrameCount() % 30 == 0 then
			local spread = gSET.DamageSpread - 1
			gVAR.DamageSpread = ((1 - (spread * .33)) + (rng:RandomFloat() * spread * .66)) * (1 + (spread * gBAL.damagespreadreward))
		end
		--these are variables
		gVAR.bosslived = gVAR.bosslives
		gVAR.roomchanged = false
		gVAR.isbosstitle = false
		gVAR.isstagetransition = false
		if not game:IsPaused() then
			gVAR.roomframes = gVAR.roomframes + 1
		end
		gVAR.roomwasclear = room:IsClear()

		--if game:GetDarknessModifier() == 0 then
			--game:Darken(2.2, 30)
		--end
	end
end
l:AddCallback(ModCallbacks.MC_POST_UPDATE, l.post_update)

function l:familiar_update(fam)
	if gVAR.gunmode then
		local variant = fam.Variant
		fam:ToFamiliar().FireCooldown = 30

		if variant == 80 or variant == gCON.Variant.Drone then -- temp
			local player = Isaac.GetPlayer(0)
			local fd = fam:GetData()
			local d = player:GetData()

			if d.gunners and not fd.ingunners then
				fd.ingunners = true
				table.insert(d.gunners, fam)
			end

			if not fd.gunanim then
				fd.gunanim = {
					dir = 0, side = -1,	aiming = false,
					rot = 0, dist = 0, recoil = 0,
					height = gCON.gunheight, size = fam.Size
				}
			end

			if not fd.guncontrol then
				fd.guncontrol = d.guncontrol
			end

			if d.perks and d.perks.superincubus then
				if variant == 80 or variant == gCON.Variant.Drone then
					if d.incdrone then
						fam.Variant = gCON.Variant.Drone
						fd.isincu = true
					else
						fam.Variant = 80
						fd.isdrone = false
						fd.famaimdir = false
					end
				end
			end

			if fd.linkgun then
				if fd.linkgun ~= d.mygun then
					fam:Remove()
					l.gunSpawn(fam, false)
				end
			else
				if fd.mygun ~= d.mygun then
					fd.mygun = d.mygun
					l.gunSpawn(fam, d.mygun)
				end
			end
		end

		if variant == gCON.Variant.Weapon then
			local fd = fam:GetData()
			if fd.wielder and ((fd.wielder.Type == 1 and fd.wielder:IsDead()) or not fd.wielder:Exists()) then
				if fd.bayonet then
					fd.bayonet:Remove()
				end
				if fd.lasersightent then
					fd.lasersightent:Remove()
				end
				fam:Remove()
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, l.familiar_update)

function l:pre_pickup_collision(pickup, collider, low)
	if gVAR.gunmode then
		local variant = pickup.Variant
		local subtype = pickup.SubType
		local player = Isaac.GetPlayer(0)
		if collider.Type == 1 and collider.Variant == 0 then
			if variant == 20 then
				if subtype == 2 then
					for i = 1, 5 do
						local pos = pickup.Position
						local dir = rng:RandomFloat() * 360
						local penny = Isaac.Spawn(5, 20, 1, pos, pickup.Velocity + (Vector(0, 8):Rotated(i * 72)), pickup)
					end
					sfx:Play(SoundEffect.SOUND_NICKELPICKUP, 1, 0, false, 1)
					pickup:Remove()
					return false
				elseif subtype == 3 then
					for i = 1, 10 do
						local pos = pickup.Position
						local dir = rng:RandomFloat() * 360
						local penny = Isaac.Spawn(5, 20, 1, pos, Vector(0, 4 + (rng:RandomFloat() * 4)):Rotated(i * 36), pickup)
					end
					sfx:Play(SoundEffect.SOUND_DIMEPICKUP, 1, 0, false, 1)
					pickup:Remove()
					return false
				end
			end
			if variant == 100 and subtype ~= 0 then
				if config:GetCollectible(subtype).Type == ItemType.ITEM_ACTIVE and gITM.skills[player:GetActiveItem()] then
					if not gITM.skills[player.SecondaryActiveItem] then
						player:SwapActiveItems()
					else
						pickup.Wait = math.max(pickup.Wait, 3)
					end
				end
			end
			if variant == 300 and pocket[subtype] and pocket[player:GetCard(0)] then
				if pickup.Wait == 0 and player:CanPickupItem() and player:IsExtraAnimationFinished() then
					local mixcard = false
					local newcard = pocket[subtype]
					local oldcard = pocket[player:GetCard(0)]
					if gPOC.herbmix[oldcard.name] then
						local mix = gPOC.herbmix[oldcard.name][newcard.name]
						if mix then
							mixcard = pocket[mix].id
						end
					end
					if mixcard then
						pickup:Morph(5, 300, mixcard, true)
						pickup:GetSprite().Color = Color(0, 0, 0, 0, 0, 0, 0)
						player:SetCard(0, 0)
					end
				end
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, l.pre_pickup_collision)

function l:pre_entity_spawn(type, variant, subtype, pos, vel, spawner, seed)
	if type == 5 and variant == 100 and subtype == gCON.Id.AttacheCase then
		if not game:GetRoom():IsFirstVisit() then
			return {1000, 87, 0}
		end
	end
	if gVAR.gunmode then
		local player = Isaac.GetPlayer(0)
		if spawner and spawner.Type == 6 then
			--return {1000, 87, 0}
		elseif type == 4 then
			if gVAR.gunswitched and spawner and spawner.Type == 1 then
				return {1000, 87, 0}
			end
		elseif type == 5 then
			if gVAR.merchantent and pos.X == gVAR.merchantent.Position.X and pos.Y == gVAR.merchantent.Position.Y then
				gVAR.merchantkilled = true
				return {1000, 87, 0}
			elseif gVAR.gunswitched and spawner and spawner.Type == 1 then
				return {1000, 87, 0}
			elseif variant == 0 then
				local drop = l.getDropTable()
				local newpick = randWeight(drop, drop.whatever)
				return {newpick[1], newpick[2], newpick[3], seed}
			--heart reroll
			elseif variant == 10 then
				if subtype <= 5 then
					local drop = l.getDropTable()
					local newpick = randWeight(drop, drop.heartdrop)
					return {newpick[1], newpick[2], newpick[3], seed}
				else
					local drop = l.getDropTable()
					local newpick = randWeight(drop, drop.heartdrop)
					return {newpick[1], newpick[2], newpick[3], seed}
				end
			--bomb reroll
			elseif variant == 40 then
				local drop = l.getDropTable()
				local newpick = randWeight(drop, drop.bombdrop)
				return {newpick[1], newpick[2], newpick[3], seed}
			--pill reroll
			elseif variant == 70 then
				if subtype >= 1 and subtype <= 13 then
					local drop = l.getDropTable()
					local newpick = randWeight(drop, drop.pilldrop)
					if newpick then
						return {newpick[1], newpick[2], newpick[3], seed}
					end
				end
			--battery reroll
			elseif variant == 90 then
				local drop = l.getDropTable()
				local newpick = randWeight(drop, drop.batterydrop)
				if newpick then
					return {newpick[1], newpick[2], newpick[3], seed}
				end
			--trinkets
			elseif variant == 350 then
				if subtype == 41 then
					if (not gVAR.matchstickspawned) and rng:RandomFloat() < .75 then
						return {1000, 87, 0}
					else
						gVAR.matchstickspawned = true
					end
				elseif subtype == 50 then
					if (not gVAR.burntpennyspawned) and rng:RandomFloat() < .75 then
						return {1000, 87, 0}
					else
						gVAR.burntpennyspawned = true
					end
				end
			end
		--elseif type == 3 and variant == 80 then
			--if player:GetData().incdrone then
				--return {1000, 87, 0} -- NOTHING
			--end
		elseif type == 33 and variant >= 2 then
			if game:GetRoom():GetType() == RoomType.ROOM_DEFAULT and not game:GetRoom():IsFirstVisit() then
				return {1000, 87, 0}
			end
		elseif type == 6 and variant == 301 then
			if not game:GetRoom():IsFirstVisit() then
				return {1000, 87, 0} -- falling ember particle
			end
		elseif type == 1000 then
			if false then --variant == 1 and ((not spawner) or spawner.Type ~= 1000 or spawner.Variant ~= gCON.Variant.MuzzleFlash) then
				--log('kaboom')
				--sfx:Play(snd.misc.bombexplosion, 1, 0, false, 1)
			elseif variant == 76 then
				if subtype == 0 or subtype >= 4 then
					local newsub = 1 + rng:RandomInt(3)
					return {1000, 76, newsub}
				end
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, l.pre_entity_spawn)

--[[
function l:familiar_init(fam)
	if gVAR.gunmode then
		local variant = fam.Variant
		if variant == 73 then
			fam.CollisionDamage = gBAL.knifedamage[game:GetLevel():GetStage()] * 2
		end
	end
end
l:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, l.familiar_init)--]]

function l:post_pickup_update(pickup)
	if gVAR.gunmode then
		local variant = pickup.Variant
		local subtype = pickup.SubType
		local pd = pickup:GetData()
		local player = Isaac.GetPlayer(0)
		local gun = player:GetData().mygun
		if variant == 20 and pickup.FrameCount >= 20 and subtype ~= 6 and not pickup:IsShopItem() then
			local diff = Isaac.GetPlayer(0).Position - pickup.Position
			if diff:Length() < 200 then
				pickup.Velocity = Lerp(pickup.Velocity, diff:Resized(16), .18)
			end
		end
		if variant >= 70 then
			if gun and gun.using then
				pickup.Wait = math.max(pickup.Wait, 3)
			end
		end
		if gun and gun.magnetonshot and gun.shot and variant ~= 100 then
			local diff = player.Position - pickup.Position
			pickup.Velocity = pickup.Velocity + (diff:Normalized() * 2)
		end
		if variant == 100 then
			if subtype ~= 0 then
				if gITM.ban[subtype] then
					local tries = 0
					local replace = 0
					local pool = game:GetItemPool()
					local seed = game:GetSeeds():GetStartSeed()
					local roompool = pool:GetLastPool()--pool:GetPoolForRoom(game:GetRoom():GetType(), seed)
					while gITM.ban[subtype] and tries < 50 do
						replace = pool:GetCollectible(roompool, true, seed)
						subtype = replace
						tries = tries + 1
					end
					pickup.Wait = math.max(pickup.Wait, 3)
					pickup:Morph(5, 100, replace, true)
				end
				table.insert(gVAR.roomcollectibles, {pickup, subtype})
			end
		end
		--'carried' pickup
		if pd.daddy then
			if (not pd.daddy:Exists()) or pd.daddy:IsDead() or pd.daddy.HitPoints <= 0 then
				pickup.Velocity = pickup.Velocity + (pickup.Position - pd.daddy.Position):Resized(7)
				pd.daddy = nil
			else
				local diff = pd.daddy.Position - pickup.Position
				local len = diff:Length()
				if len + pd.daddy.Size > 125 then
					pd.daddy = nil
				elseif len > pd.daddy.Size + 10 then
					local target = pd.daddy.Position + (pd.daddy.Position - pickup.Position):Resized(pd.daddy.Size + 10)
					local diff2 = target - pickup.Position
					pickup.Velocity = Lerp(pickup.Velocity, diff2, .02)
				end
			end
		end
		--we all fade away
		if gSET.Difficulty >= gBAL.temppickupsmindif then
			if gVAR.pickupfade then
				pd.alpha = pd.alpha or 1
				pd.alpha = approach(pd.alpha, 0, .4)
				local ps = pickup:GetSprite()
				ps.Color = Color(1, 1, 1, pd.alpha, 0, 0, 0)
			elseif pd.alpha then
				pd.alpha = pd.alpha or 1
				pd.alpha = approach(pd.alpha, 1, .4)
				local ps = pickup:GetSprite()
				ps.Color = Color(1, 1, 1, pd.alpha, 0, 0, 0)
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, l.post_pickup_update)

function l:post_pickup_init(pickup)
	if gVAR.gunmode then
		local variant = pickup.Variant
		local subtype = pickup.SubType
		if variant == 300 then
			if pocket[subtype] then
				local pd = pickup:GetData()
				local ps = pickup:GetSprite()
				if not pd.pocketinit then
					pd.pocketinit = true
					ps:Load("gfx/pickup.anm2", true)
					ps:ReplaceSpritesheet(0, pocket[subtype].sprite)
					ps:LoadGraphics()
					ps:Play("Appear")
					if game:IsPaused() then
						ps:SetLastFrame()
					end
				end
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, l.post_pickup_init)

function l.stopSounds()
	local player = Isaac.GetPlayer(0)
	if sfx:IsPlaying(SoundEffect.SOUND_BOOK_PAGE_TURN_12) then
		if pocket[player:GetCard(0)] then
			local type = pocket[player:GetCard(0)] and pocket[player:GetCard(0)].type
			sfx:Stop(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
			if type == 'herb' then
				sfx:Play(SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1)
			elseif type == 'grenade' then
				sfx:Play(SoundEffect.SOUND_FETUS_LAND, 1, 0, false, 1)
			else
				sfx:Play(snd.misc.pack, 1, 0, false, 1)
			end
		end
	end
	if sfx:IsPlaying(SoundEffect.SOUND_BLOOD_LASER) then
		if gVAR.mutelightspawn then
			sfx:Stop(SoundEffect.SOUND_BLOOD_LASER)
			gVAR.mutelightspawn = nil
		end
	end
	if sfx:IsPlaying(SoundEffect.SOUND_BOSS1_EXPLOSIONS) then
		if gVAR.muteflashspawn then
			sfx:Stop(SoundEffect.SOUND_BOSS1_EXPLOSIONS)
		end
	end
	if sfx:IsPlaying(SoundEffect.SOUND_BATTERYCHARGE) then
		local active = player:GetActiveItem()
		if gITM.skills[active] and player:GetData().mygun.activecharge ~= config:GetCollectible(active).MaxCharges then
			sfx:Stop(SoundEffect.SOUND_BATTERYCHARGE)
		end
	end

	--don't need these
	if sfx:IsPlaying(SoundEffect.SOUND_BEEP) then
		sfx:Stop(SoundEffect.SOUND_BEEP)
	end
end

function l.merchantUpdate(en)
	local player = Isaac.GetPlayer(0)
	local pd = player:GetData()
	local d = en:GetData()
	local s = en:GetSprite()
	if not d.init then
		d.init = true
		gVAR.merchantent = en
		mmenuvar.loadinv = true
		l.shopUpdate()
		s:Play("Greet", true)
		if not gSET.DebugMode then
			d.voice = (rng:RandomFloat() < .66 and snd.merch.welcome) or snd.merch.goodthings
		end
		d.voicesaid = {}
		gVAR.timerpause = true
	end
	if gVAR.merchantkilled then
		Isaac.Spawn(1000, 2, 0, en.Position, Vector(0, 0), nil)
		local drop = l.getDropTable()
		local goods = {}
		for i = 1, 5 do
			table.insert(goods, randWeight(drop, drop.pickcoin))
		end
		table.insert(goods, 1 + rng:RandomInt(#goods), randWeight(drop, drop.merchkilled))
		table.insert(goods, 1 + rng:RandomInt(#goods), randWeight(drop, drop.whatever))
		for i, good in ipairs(goods) do
			local dir = Vector(10, 0):Rotated((i-1) * (360 / #goods))
			local pos = en.Position + Vector(0, -1)
			if good[1] == 5 and good[2] == 100 then
				Isaac.Spawn(good[1], good[2], good[3], pos, Vector(0, 0), nil)
			elseif good[1] == 5 and good[2] == 350 and good[3] == 53 then
				local dir = (player.Position - en.Position):Normalized() * 7
				Isaac.Spawn(good[1], good[2], good[3], pos, dir, nil)
			else
				Isaac.Spawn(good[1], good[2], good[3], pos, dir, nil)
			end
		end

		en:Kill()
		en:Remove()
		if d.lastvoice then
			sfx:Stop(d.lastvoice)
		end
		sfx:Play(snd.merch.killed, 1, 0, false, 1)
	else
		local touching = (player.Position - en.Position):Length() < player.Size + en.Size and player:IsItemQueueEmpty() and player:IsExtraAnimationFinished()
		local open = mmenuvar.open
		local wasopen = d.menuopen
		if touching then
			player.Velocity = (player.Position - en.Position):Resized(5)
		end
		if (touching and not open) or (open and not wasopen) then
			s:Play("ShopEnter", true)
			d.voice = (rng:RandomFloat() < .5 and snd.merch.buyin) or snd.merch.sellin
			mmenuvar.shop = true
			mmenuvar.open = true
			mmenuvar.openanim = true
			mmenuvar.loadinv = true
		end
		if wasopen and not open then
			if d.traded then
				s:Play("ShopExit2", true)
				d.voice = snd.merch.comeback
				d.traded = false
			else
				s:Play("ShopExit", true)
			end
		end

		if d.voice and gSET.MerchantVoice ~= 1 then
			if gSET.MerchantVoice == 3 or gSET.MerchantVoice == 4 or not d.voicesaid[d.voice] then
				if d.lastvoice and gSET.MerchantVoice ~= 4 then
					sfx:Stop(d.lastvoice)
				end
				sfx:Play(d.voice, 1, 0, false, 1)
				d.voicesaid[d.voice] = true
				d.lastvoice = d.voice
			end
			d.voice = false
		end

		if s:IsEventTriggered("Rustle") then
			sfx:Play(snd.misc.pack, 1, 0, false, 1)
		end
		d.menuopen = mmenuvar.open
		if game:GetRoom():GetType() == RoomType.ROOM_DEFAULT then
			game:Darken(.8, 1)
		end
	end
	if gVAR.pickupfade then
		d.alpha = d.alpha or 1
		d.alpha = approach(d.alpha, 0, .4)
		local ps = en:GetSprite()
		ps.Color = Color(1, 1, 1, d.alpha, 0, 0, 0)
	elseif d.alpha then
		d.alpha = d.alpha or 1
		d.alpha = approach(d.alpha, 1, .4)
		local ps = en:GetSprite()
		ps.Color = Color(1, 1, 1, d.alpha, 0, 0, 0)
	end
end

function l.convert_pickups()
	local player = Isaac.GetPlayer(0)
	local dif = gSET.Difficulty
	local mhp = player:GetMaxHearts(); local xmhp = gBAL.difftable[EDF.maxhp][dif] * 2
	local mbh = player:GetBoneHearts(); local xmbh = gBAL.difftable[EDF.maxhp][dif] * 2
	local msh = player:GetSoulHearts(); local xmsh = gBAL.difftable[EDF.maxshp][dif] * 2
	local bombs = player:GetNumBombs()
	if mhp > xmhp then
		player:AddMaxHearts(xmhp - mhp)
		gVAR.cashdrop = gVAR.cashdrop + ((mhp - xmhp) * gBAL.cashperhp)
	end
	if mbh > xmbh then
		player:AddMaxHearts(xmbh - mbh)
		gVAR.cashdrop = gVAR.cashdrop + ((mvh - xmbh) * gBAL.cashperhp * 2)
	end
	if msh > xmsh then
		player:AddSoulHearts(xmsh - msh)
		gVAR.cashdrop = gVAR.cashdrop + ((msh - xmsh) * gBAL.cashpersh)
	end
	if bombs > 0 then
		player:AddBombs(0 - bombs)
		gVAR.grenadedrop = gVAR.grenadedrop + (gBAL.grenadeperbomb * bombs)
	end
end

--PLAYER UPDATE
function l:post_peffect(player)
	if player.Variant == 0 then
		if game:GetFrameCount() == 10 and gSET.DebugMode then
			player:AddCollectible(gCON.Id.AttacheCase, 0, true)
		end
		if not gVAR.gunmode then
			if player.QueuedItem and player.QueuedItem.Item then
				local starting = player.QueuedItem.Item.ID == gCON.Id.AttacheCase
				if starting and not player:GetData().attachepickup then
					player:GetData().attachepickup = 1
					sfx:Stop(SoundEffect.SOUND_CHOIR_UNLOCK)
					sfx:Play(SoundEffect.SOUND_DOG_HOWELL, 1, 0, false, 1)
				end
			end
			if player:HasCollectible(gCON.Id.AttacheCase) then
				l.gunModeInit()
			end
		else--GUN MODE
			local d = player:GetData()
			if game:GetRoom():GetType() == RoomType.ROOM_SHOP then
				game:Darken(1, 30)
				if not d.warpoutofshop and gVAR.roomframes == 150 then
					Isaac.ConsoleOutput('Stay out.\n')
					player:UseActiveItem(419, false, false, false, falase)
					d.warpoutofshop = true
				end
			else
				d.warpoutofshop = nil
			end

			if not d.gunuser then
				l.gunUserInit(player)
				local ipos = player.Position
				local suf = {'','a','b'}
				local exc = "stage 1"..suf[1 + game:GetLevel():GetStageType()]
				Isaac.ExecuteCommand(exc)
				player.Position = ipos
				if gSET.DebugMode then
					local center = game:GetRoom():GetCenterPos()
					Isaac.Spawn(6, gCON.Variant.Merchant, 0, Isaac.GetFreeNearPosition(center + Vector(200, -80), 0), Vector(0, 0), nil)
				end

				if gSET.ShowDamageValues then
					Isaac.ExecuteCommand("debug 7")
				end
			end
			if d.gunuser then
				--knife speed bonus
				if game:GetRoom():IsClear() and gVAR.knifespeedbonusready then
					d.knifespeedbonus = d.knifespeedbonus + .45
					gVAR.knifespeedbonusready = false
				end
				--heart/bomb convert
				l.convert_pickups()
				--grenade a shit
				if d.grenadearm then
					player:AnimateCollectible(pocket[d.grenade].item, "LiftItem", "PlayerPickup")
					d.grenadearm = false
				end
				if player:IsExtraAnimationFinished() then
					d.grenade = false
				end
				if d.grenade then
					if d.input.aimdir and (d.input.aimpress or d.input.knifepress) then
						local aimdir = d.input.aimdir:Normalized()
						local vel = (d.input.aimpress and (player.Velocity) + (aimdir * 5)) or ((player.Velocity) + (aimdir * .1))
						local fallspeed = (d.input.aimpress and -8) or -15
						player:SetCard(0, 0)
						grenade = Isaac.Spawn(4, gCON.Variant.Grenade, 0, player.Position, vel, player)
						grenade.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
						grenade.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
						grenade.PositionOffset = Vector(0, -35)
						grenade:GetData().grenade = pocket[d.grenade].grenadetype
						grenade:ToBomb():GetData().fallspeed = fallspeed
						grenade:GetSprite():ReplaceSpritesheet(0, pocket[d.grenade].sprite2)
						grenade:GetSprite():LoadGraphics()
						grenade:GetSprite():Play("Idle")
						player:AnimateCollectible(pocket[d.grenade].item, "HideItem", "PlayerPickup")
						d.grenade = false
						sfx:Stop(SoundEffect.SOUND_FETUS_LAND)
						sfx:Play(snd.misc.whoosh, 1, 0, false, 1)
					end
				end
				--stat hud shit
				local gun = d.mygun
				if true or gun then
					local room = game:GetRoom()
					local level = game:GetLevel()
					local stage = level:GetStage()

					local mainchance = math.min(room:GetDevilRoomChance(), 1, stage - 1)
					local angelpct = .5
					local devil = mainchance * (1 - angelpct)
					local angel = mainchance * angelpct

					--local gunskill = gun and (1 / gun.clipperfill / math.max(.5, player.ShotSpeed)) or 0
					local gunskill = player.ShotSpeed

					local prevgun = gVAR.lastgun
					gVAR.lastgun = gun

					gVAR.stats[1] = roundTo(gVAR.cashdrop * 100, .01)
					gVAR.stats[2] = roundTo(gVAR.grenadedrop * 100, .01)
					gVAR.stats[3] = roundTo(devil * 100, .1)
					gVAR.stats[4] = roundTo(player.MoveSpeed, .01)
					gVAR.stats[5] = roundTo(player.TearHeight * -1, .1)
					gVAR.stats[6] = roundTo(player.MaxFireDelay, 1)
					gVAR.stats[7] = roundTo(gunskill, .01)
					gVAR.stats[8] = roundTo((gun and gun.fakedmg) or player.Damage, .01)
					gVAR.stats[9] = roundTo(player.Luck, 1)

					gVAR.stats[10] = gun and gun.clipsize or 0
					gVAR.stats[11] = gun and gun.maxchamber or 0
					gVAR.stats[12] = gun and roundTo(gun.reloadbullet or gun.reloadtime, .01) or 0
					gVAR.stats[13] = gun and roundTo((gun.spreadmin + gun.spreadmax) / 2, 1) or 0

					for i, st in ipairs(gVAR.stats) do
						local prev = gVAR.pstats[i]
						if prev ~= st and (prevgun == gun or gSET.ShowStats >= 3)  then
							gVAR.dstats[i] = st - gVAR.cstats[i]
							if gVAR.statinit then
								gVAR.tstats[i] = (gCON.statshowduration * 60) + 30
							end
						end

						if gVAR.tstats[i] > 0 and prevgun == gun then
							gVAR.tstats[i] = gVAR.tstats[i] - 1
						else
							gVAR.cstats[i] = st
						end
						gVAR.pstats[i] = st
					end

					gVAR.statinit = true
				end
				--light haha
				if gVAR.flashlightcolor then
					local darkmod = game:GetDarknessModifier()
					if (darkmod >= .3 and darkmod <= 1) or hasbit(game:GetLevel():GetCurses(), LevelCurse.CURSE_OF_DARKNESS) then
						l.flashLight(player, d, gVAR.flashlightcolor)
					else
						if d.plrlight and d.plrlight[1]:Exists() then
							d.plrlight[1]:Remove()
							d.plrlight = nil
						end
					end
				end

				--the bit where I put parts of the character skills
				if Input.IsButtonPressed(Keyboard.KEY_Z, 0) and d.mygun then
					player:SetActiveCharge(999)
					d.mygun.activecharge = 999
				end

				if d.perks then
					if d.perks.superincubus then
						if d.input.swappress then
							if d.incdrone then
								d.incdrone = false
								log('drone off')
							else
								d.incdrone = true
								log('drone on')
							end
						end
					end
				end
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, l.post_peffect)

function l.getFlashlightColor()
	local fclr = gCON.flashlightclr[gCON.lightfrombackdrop[game:GetRoom():GetBackdropType()] or gCON.lightfrombackdrop[1] ]
	local sats = {0, .5, .75, 1, 1.5, 2}
	local lsat = sats[gSET.LightingSaturation]
	local blend = TLerp({.5, 1, 1, 1.5, 0, 0, 0}, {fclr.R, fclr.G, fclr.B, fclr.A, fclr.RO, fclr.GO, fclr.BO}, lsat)
	return Color(blend[1], blend[2], blend[3], blend[4], blend[5], blend[6], blend[7])
end

function l.flashLight(player, data, fcolor)
	local d = data
	local light = false
	local ang = {0, -15, 15}
	if not (d.plrlight and d.plrlight[1]:Exists()) then
		d.lightangle = 90
		d.plrlight = {}
		for i = 1, 1 do
			light = Isaac.Spawn(7, 8, 1, player.Position, player.Velocity, player)
			light:ToLaser():SetTimeout(-1)
			light:GetSprite():ReplaceSpritesheet(0, "gfx/collectibles/collectible_blank.png")
			light:GetSprite():LoadGraphics()
			light.Visible = false
			light.CollisionDamage = 0
			light.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			light.GridCollisionClass = GridCollisionClass.COLLISION_NONE
			light = light:ToLaser()
			light.Color = gCON.flashlightclr.off
			d.lighthighlight = 0
			d.lightflicker = 0
			light.Radius = 1
			light.SpriteScale = Vector(1.5, 1.5)
			light.Angle = d.lightangle + ang[i]
			light.EndPoint = light.Position
			table.insert(d.plrlight, light)
		end
		gVAR.mutelightspawn = true
	else
		local lt = fcolor
		local clear = game:GetRoom():IsClear()
		local switch = rng:RandomFloat()
		local fcount = player.FrameCount % 240
		if d.lightflicker == 0 and not clear then
			d.lightflicker = (switch < .001 and 1) or 0
		elseif d.lightflicker == 1 then
			if fcount > 120 then
				d.lightflicker = (switch > .07 and 1) or 0
			end
			if (not clear) and fcount > 100 and fcount < 120 then
				d.lightflicker = (switch < .005 and 2) or 1
			end
		elseif d.lightflicker == 2 then
			if clear or (fcount < 60 and switch < .01) then
				d.lightflicker = 1
			end
		end
		d.lighthighlight = Lerp(d.lighthighlight, 50, .1)
		local hl = d.lighthighlight
		if d.lightflicker == 1 then
			hl = hl - (hl * (switch * .4))
		elseif d.lightflicker == 2 then
			hl = 0
		end
		if not d.idle then
			d.lightangle = d.input.lastaimdir:GetAngleDegrees()
		else
			local input = player:GetMovementInput()
			if input:Length() > .3 then
				local goal = input:GetAngleDegrees()
				local angdif = angleDiff(d.lightangle, goal)
				d.lightangle = Lerp(d.lightangle, d.lightangle - angdif, .35)
			end
		end
		for i = 1, 1 do
			light = d.plrlight[i]:ToLaser()
			light.Visible = true
			light.Color = Color(lt.R, lt.G, lt.B, lt.A * (1/20) * hl, 0, 0, 0)

			light.Position = player.Position
			light.Velocity = player.Velocity

			light.Angle = d.lightangle + ang[i]
			light.EndPoint = light.Position + (Vector.FromAngle(light.Angle) * 650)
		end
	end
end


function l:drone_update(drone)
	local d = drone:GetData()
	local s = drone:GetSprite()
	local owner = d.owner or Isaac.GetPlayer(0)
	local pd = owner:GetData()
	local input = d.input
	local room = game:GetRoom()
	local gun = d.mygun
	if not d.droneinit then
		if not d.isincu then
			drone.PositionOffset = Vector(0, -36)
		end
		d.droneinit = true
		d.isdrone = true
		d.famaimdir = Vector(0, -1)
		drone.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
		d.tgtpos = room:GetCenterPos()
		d.idletime = 0
	end
	if game:GetFrameCount() % 15 == 0 then
		--if not (d.tgt and d.tgt:Exists() and d.tgt:IsVulnerableEnemy()) then
		local tgt = false; local dist = 10000
		local boss = not d.isincu; local inv = true

		if gun and gun.laserdotent then
			tgt = gun.laserdotent
		else
			for i, en in ipairs(Isaac.GetRoomEntities()) do
				local type = en.Type
				if en:IsEnemy() and en.HitPoints > 0 and type ~= 33 and type ~= 292 then
					local mydist = (en.Position - drone.Position):Length()
					if (not tgt) or (inv and en:IsVulnerableEnemy()) or (boss and not en:IsBoss()) or mydist < dist then
						tgt = en
						dist = mydist
						inv = inv and not en:IsVulnerableEnemy()
						boss = boss and en:IsBoss()
					end
				end
			end
		end
		d.tgt = tgt
	end
	if d.tgt and not (d.tgt:Exists()) then
		d.tgt = false
	end
	if d.tgt then
		d.famaimdir = (d.tgt.Position - drone.Position):Normalized()
	end
	local speed = d.isincu and .3 or .12

	local overlap = false
	if pd.gunners and #pd.gunners > 1 then
		for i, fam in ipairs(pd.gunners) do
			if fam.Variant == gCON.Variant.Drone then
				local diff = (drone.Position - fam.Position)
				local len = diff:Length()
				if len > 1 and len < 100 then
					overlap = true
					local away = diff:Normalized()
					drone.Velocity = drone.Velocity + (away * .5)
				end
			end
		end
	end

	local newroom = false
	if gVAR.roomchanges ~= d.lastroom then
		newroom = true
		d.lastroom = gVAR.roomchanges
	end

	if d.tgt then
		if game:GetFrameCount() % 15 == 0 then
			local userange = math.min(180, (-pd.gunstat.TearHeight * 7))
			if d.isincu then
				userange = userange * 1.35
			end
			local posdif = drone.Position - d.tgt.Position
			local trypos = d.tgt.Position + (posdif:Normalized() * userange)
			local clamppos = room:GetClampedPosition(trypos, 0)
			d.tgtpos = trypos
			if trypos.X == clamppos.X and trypos.Y == clamppos.Y then
				d.tgtpos = trypos
			else
				d.tgtpos = d.tgt.Position + (posdif:Normalized() * -40)
			end
		end
	elseif (game:GetFrameCount() % 15 == 0 and d.idletime >= 60) or overlap or newroom then
		d.tgtpos = room:GetClampedPosition(owner.Position + (Vector(160, 0):Rotated(rng:RandomFloat() * 360)), 60)
		speed = .03
		if not overlap then
			d.famaimdir = (d.tgtpos - drone.Position):Normalized()
		end
	end

	local posdif = d.tgtpos - drone.Position
	drone.Velocity = Lerp(drone.Velocity, posdif:Normalized() * math.min(8, posdif:Length()), speed)
	if posdif:Length() < 20 then
		d.idletime = d.idletime + 1
	else
		d.idletime = 0
	end


	--[[
	if d.tgt then
		if not d.tgtent then
			d.tgtent = Isaac.Spawn(1000, 30, 0, d.tgt.Position, Vector(0, 0), drone)
		end
		d.tgtent.Position = d.tgt.Position + Vector(0, 1)
		d.tgtent.Velocity = d.tgt.Velocity
	else
		if d.tgtent then
			d.tgtent:Remove()
			d.tgtent = nil
		end
	end--]]

	if not d.isincu then
		local move = drone.Velocity / 10
		drone.SpriteRotation = approach(drone.SpriteRotation, move.X * 28, 5)
		d.ysize = approach((d.ysize or 1), 1 + (move.Y * .3), .1)
		drone.SpriteScale = Vector(1, d.ysize)
	else
		local floats = {'FloatUp', 'FloatSide', 'FloatDown', 'FloatSide'}
		local dirnum = math.floor((d.famaimdir:GetAngleDegrees()+45) / 90) + 2
		dirnum = (dirnum == 0 and 4) or dirnum

		drone:GetSprite():Play(floats[dirnum])
		if dirnum == 4 then
			drone.FlipX = true
		else
			drone.FlipX = false
		end
	end
end
l:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, l.drone_update, gCON.Variant.Drone)

function l:bomb_update(bomb)
	if gVAR.gunmode then
		local d = bomb:GetData()
		local player = Isaac.GetPlayer(0)
		if d.grenade then
			local s = bomb:GetSprite()
			if not d.init then
				d.init = true
				d.friction = d.friction or .75
				bomb.Friction = 2.5
				bomb.Mass = 6
				if false and bomb.Variant == gCON.Variant.Grenade and d.grenade == 2 then
					local newbomb = Isaac.GetPlayer(0):FireBomb(bomb.Position, bomb.Velocity)
					local nd = newbomb:GetData()
					nd.grenade = 2
					nd.fallspeed = d.fallspeed
					nd.friction = d.friction
					nd.blowonhit = d.blowonhit
					newbomb.Mass = bomb.Mass
					nbs = newbomb:GetSprite()
					nbs:Load("gfx/grenade.anm2", true)
					nbs:ReplaceSpritesheet(0, "gfx/pocket/gg2.png")
					nbs:LoadGraphics()
					bomb:Remove()
					return false
				else
					bomb:SetExplosionCountdown(600)
					d.fallspeed = d.fallspeed or -8
					d.height = -35
					bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					bomb.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
					s:Play("Idle")
				end
			end
			local land = false
			local homing = Isaac.GetPlayer(0):HasCollectible(125)
			local mega = Isaac.GetPlayer(0):HasCollectible(106)
			local explode = false
			local explodeearly = false
			if not d.landed and d.blowonhit and d.enemyhit and d.height > - 45 then
				d.landed = true
				land = true
				explode = true
				explodeearly = true
			elseif not d.landed then
				s:Play("Idle")
				if homing then
					bomb.Velocity = bomb.Velocity * (1 / .96)
				end
				d.fallspeed = d.fallspeed + 1.2
				d.height = math.min(-6, d.height + d.fallspeed)
				bomb.PositionOffset = Vector(0, d.height)
				bomb.SpriteRotation = bomb.SpriteRotation + bomb.Velocity.X + (bomb.Velocity.X < 0 and -4 or 4)
				if d.height == -6 then
					d.landed = true
					land = true
					if d.grenade ~= 2 then
						sfx:Play(snd.grenade.impact, 1.5, 0, false, 1)
					end

					---[[
					if d.grenade == 2 and not d.convert then
						local newbomb = Isaac.GetPlayer(0):FireBomb(bomb.Position, bomb.Velocity)
						local nd = newbomb:GetData()
						nd.grenade = 2
						nd.init = true
						nd.friction = d.friction or .75
						newbomb.Friction = 2.5
						newbomb.Mass = 6
						nd.fallspeed = d.fallspeed
						nd.friction = d.friction
						nd.blowonhit = d.blowonhit
						nd.height = d.height
						nd.convert = true
						newbomb.Mass = bomb.Mass
						nbs = newbomb:GetSprite()
						nbs:Load("gfx/grenade.anm2", true)
						nbs:ReplaceSpritesheet(0, "gfx/pocket/gg2.png")
						nbs:LoadGraphics()
						newbomb.SpriteRotation = bomb.SpriteRotation
						newbomb.Velocity = bomb.Velocity
						bomb:Remove()

						bomb = newbomb
						d = nd
					end--]]
				end
			else
				if not homing then
					bomb.Velocity = bomb.Velocity * d.friction
				end
			end
			bomb.SpriteRotation = bomb.SpriteRotation + bomb.Velocity.X
			--incendiary grenade
			if d.grenade == 1 then
				if land then
					explode = true
					local ang = rng:RandomFloat() * 90
					local vel = Vector(0, 14):Rotated(ang)
					local count = (mega and 7) or 4
					for i = 0, count + 1 do
						vel = (i <= count and vel:Rotated(360 / (count + 1))) or Vector(0, 0)
						local fire = Isaac.Spawn(1000, gCON.Variant.FlamethrowerFire, 0, bomb.Position, vel, nil)
						local fd = fire:GetData()
						fd.lifetime = 8 * 30
						fd.faderate = 1/30
						fd.damage = .05
						fd.burntime = 1--15
						fd.burndamage = 5
						fd.friction = .2
					end
					if d.enemyhit then
						d.enemyhit:TakeDamage(24, DamageFlag.DAMAGE_FIRE, EntityRef(bomb), 0)
					end
					--Isaac.Explode(bomb.Position, nil, 5)
					local poof = Isaac.Spawn(1000, 15, 0, bomb.Position, Vector(0, 0), nil)
					bomb:Remove()
					sfx:Play(snd.grenade.flameburst2, 1, 0, false, 1)
				end
			--frag grenade
			elseif d.grenade == 2 then
				if land then
					bomb.Friction = 1
					if not Isaac.GetPlayer(0):HasCollectible(137) then
						s:Play("Pulse")
					end
					explode = true
				end
				if explodeearly then
					bomb:SetExplosionCountdown(0)
					if d.enemyhit then
						d.enemyhit:TakeDamage(24, DamageFlag.DAMAGE_EXPLOSION, EntityRef(bomb), 0)
					end
				elseif s:IsEventTriggered("Explode") and not Isaac.GetPlayer(0):HasCollectible(137) then
					bomb:SetExplosionCountdown(0)
				end
			--flash grenade
			elseif d.grenade == 3 then
				if land then
					explode = true
					--Game():Darken(0, 8)
					local poof = Isaac.Spawn(1000, 15, 0, bomb.Position, Vector(0, 0), nil)
					poof.SpriteScale = Vector(1.5, 1.5)
					poof:GetSprite().Color = Color(1, 1, 1, 1, 150, 150, 150)
					bomb:Remove()
					sfx:Play(snd.grenade.flashbang, 1.5, 0, false, 1)
					if d.enemyhit then
						d.enemyhit:TakeDamage(24, 0, EntityRef(bomb), 0)
					end
				end
			end
			if explode then
				local bobcurse = Isaac.GetPlayer(0):HasCollectible(140)
				local butt = Isaac.GetPlayer(0):HasCollectible(209)
				local sad = Isaac.GetPlayer(0):HasCollectible(220)
				local range = false
				for i, en in ipairs(Isaac.GetRoomEntities()) do
					local isenemy = en:IsVulnerableEnemy() or (en:IsEnemy() and en.HitPoints > 0)
					if isenemy then
						local dist = (bomb.Position - en.Position):Length()
						if d.grenade == 1 and dist < 100 then
							en:AddBurn(EntityRef(bomb), 300, 1)
							en:GetData().burndamage = 1
							range = true
						elseif d.grenade == 2 and dist < 80 then
							range = true
						elseif d.grenade == 3 then
							range = true
							if en.Type == 310 or en.Type == 304 then
								en:Kill()
							else
								en:AddConfusion(EntityRef(player), ((mega and 10) or 6) * 30, false)
								if en.MaxHitPoints < 7 then
									en:TakeDamage(10, 0, EntityRef(player), 0)
								else
									en:TakeDamage(5, 0, EntityRef(player), 0)
								end
							end
						end
						if range then
							if bobcurse then
								en:AddPoison(EntityRef(bomb), 45, 3.5)
							end
							if butt and d.grenade ~= 2 then
								en:AddConfusion(EntityRef(bomb), 45, false)
							end
						end
					--non enemy
					else
						local type = en.Type; local variant = en.Variant
						if type == 6 then
							if variant <= 3 and d.grenade == 3 then
								Isaac.Explode(en.Position, bomb, 20)
								en:GetSprite():Play('Death')
							end
						end
					end
				end
				if sad and d.grenade ~= 2 then
					for i = 0, 9 do
						player:FireTear(bomb.Position, Vector(0, 8):Rotated(i * 36), false, true, false)
					end
				end
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, l.bomb_update)

function l:bomb_collision(bomb, ent, low)
	if gVAR.gunmode then
		local d = bomb:GetData()
		if ent:IsEnemy() and d.grenade and d.blowonhit and not d.enemyhit then
			d.enemyhit = ent
		end
	end
end
l:AddCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, l.bomb_collision)

function l:ffire_effect(ent)
	local ed = ent:GetData()
	local es = ent:GetSprite()
	local freq = gCON.firedetectfrequency
	local active = ent.FrameCount % freq == 0
	ent.Velocity = ent.Velocity * (1 - ed.friction)
	ent.Position = game:GetRoom():GetClampedPosition(ent.Position, 25)
	ed.strength = ed.strength or 1
	ed.lifetime = ed.lifetime - (.25 + (rng:RandomFloat() * 1.5))
	if not ed.init then
		ed.init = true
		es.Color = Color(.8, .9, 1, 1, 8, 10, 12)
		ed.size = ed.size or 1.2
	end
	if ed.lifetime <= 0 then
		ed.strength = ed.strength - ed.faderate
	else
		--Game():Darken(0, 5)
	end
	local scale = Lerp(.3, 1, ed.strength) * ed.size
	ent.SpriteScale = Vector(scale, scale)
	if ed.strength <= 0 then
		ent:Remove()
	else
		if active then
			for i, enemy in ipairs(Isaac.FindInRadius(ent.Position, 25 * ed.size, 1<<3)) do
				enemy:TakeDamage(ed.damage * freq, 0, EntityRef(ent), 0)
				enemy:GetData().burndamage = ed.burndamage
				enemy:AddBurn(EntityRef(ent), 300, 1)
				for i = 1, freq do
					enemy.Velocity = enemy.Velocity + (ent.Velocity / 2 / enemy.Mass)
					ent.Velocity = ent.Velocity * .9
				end
			end
		end
	end
	gVAR.lastflame = game:GetFrameCount()
end
l:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, l.ffire_effect, gCON.Variant.FlamethrowerFire)

function l:laserdot_update(ent)
	local ed = ent:GetData()
	local parent = ed.parent
	local gc = parent:GetData().guncontrol

	if gc then
		ent.Position = gc.dotaim
	end
end
l:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, l.laserdot_update, gCON.Variant.LaserDot)

--[[
function l:tear_init(tear)
	if gVAR.gunmode then
		local var = tear.Variant
		log(tear.SubType)
		if var == gCON.Variant.RpgTear then
			log('im rpg')
			tear.SpriteRotation = tear.Velocity:GetAngleDegrees()
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, l.tear_init)--]]

function l.knifeMaster(player)
	local d = player:GetData()
	local gun = d.mygun
	if not d.knife then
		d.knife = {delay = 0}
	end
	local knife = d.knife
	local input = d.input
	if knife.delay == 0 and (input.knife or (input.shoot and not gun)) and player:IsExtraAnimationFinished() and not mmenuvar.open then
		local superslash = false
		if input.knifepress and game:GetFrameCount() - input.doubletaptime <= 8 then-- and math.abs(angleDiff(input.movepressdir:GetAngleDegrees(), input.lastaimdir:GetAngleDegrees())) < 45 then
			superslash = true
			--player.Velocity = input.lastaimdir:Resized(10)
			player.Velocity = input.movepressdir:Resized(10)
		end
		d.activeuntil = player.FrameCount + 30
		local angle = input.lastaimdir:GetAngleDegrees() - 15
		local effect = Isaac.Spawn(1000, gCON.Variant.Knife, 0, player.Position + player.Velocity + (input.lastaimdir * 5), Vector(0, 0), player)
		effect:GetData().offset = input.lastaimdir:Rotated(-15)
		if superslash then
			--effect.SpriteScale = Vector(1.25, 1.5)
			effect:GetData().superslash = true
		end
		--effect.FlipX = d.knifeback
		--d.knifeback = d.knifeback == false
		effect.PositionOffset = Vector(0, -20)
		--local basevec = Vector.FromAngle(angle)
		--effect.SpriteRotation = Vector(basevec.X * (d.knifeback and 1 or -1), basevec.Y):GetAngleDegrees() + 90
		effect.SpriteRotation = angle + 90
		effect = effect:ToEffect()
		effect.SpawnerEntity = player
		local kspeed = Isaac.GetPlayer(0):GetData().knifespeedbonus
		if d.fireslash then
			effect.Color = Color(1, 218/255, 148/255, 1, 0, 0, 0)
		end
		--effect.Color = Color(1, 1 - math.min(1, kspeed * .33), 1 - math.min(1, kspeed * .33), 1, 0, 0, 0)
		knife.delay = (30 / (1.8 + kspeed))
	else
		knife.delay = approach(knife.delay, 0, 1)
	end
end

function l:knife_effect(effect)
	local frame = effect:GetSprite():GetFrame()
	local rot = math.min(4, (frame - 1)) * 45
	local offset = effect:GetData().offset
	local offpos = offset:Rotated(rot - 90)
	local sd = effect.SpawnerEntity:GetData()
	local topos = effect.SpawnerEntity.Position + effect.SpawnerEntity.Velocity + (offpos * 5)
	local superslash = effect:GetData().superslash
	if superslash then
		--effect.SpriteScale = Vector(1, 1) + (Vector(.5, 1) * (Vector(1, 0):Rotated(rot).Y))
	end
	effect.Position = topos
	effect.Velocity = topos - effect.Position
	--effect.RenderZOffset = -10000000 --math.floor(offpos.Y * 100)
	if frame == 2 then
		local hit = false
		local hiten = false
		local hitcrit = false
		local hitproj = false
		local hitblock = false
		local gore = false
		local isfire = sd.fireslash or false
		sd.fireslash = false
		local wasfire = false
		local bdmg = gBAL.knifedamage[game:GetLevel():GetStage()] * (superslash and 1.5 or 1)
		local velmult = (superslash and 2 or 1)
		for i, en in ipairs(Isaac.GetRoomEntities()) do
			local type = en.Type
			local variant = en.Variant
			local subtype = en.SubType
			local dmg = bdmg
			if en:IsVulnerableEnemy() or (type == 33 and variant < 2) or type == 17 or type == 292 then
				local diff = en.Position - effect.Position
				local dist = diff:Length()
				local ang = diff:GetAngleDegrees()
				if Isaac.GetPlayer(0):GetPlayerType() == gCON.Leon.Type and en:IsBoss() then
					dmg = dmg + (gBAL.knifedamage2[game:GetLevel():GetStage()] * (superslash and 1.5 or 1))
				end
				if dist < 72 + en.Size and math.abs(angleDiff(offset:GetAngleDegrees(), ang)) <= 90 then
					local vel = (offset * (45 / en.Mass)) * velmult
					local gorevel = offset * 7 * velmult
					if type == 33 then
						if en.HitPoints > 0 then
							wasfire = true
							en.HitPoints = 0
						end
					elseif type ~= 292 then
						hit = true
						hiten = true
						gore = true
					end
					if en:IsVulnerableEnemy() and en:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
						dmg = dmg * 2.5
						vel = vel * 2
						gorevel = gorevel * 2
						hitcrit = true
					end
					if en:ToNPC().ParentNPC then
						dmg = dmg / 2
					end
					en:TakeDamage(dmg, 0, EntityRef(effect.SpawnerEntity), 0)
					en.Velocity = en.Velocity + vel
					if sd.perks and sd.perks.knifedmgammo then
						local gun = sd.mygun
						if gun then
							gun.dmgforammo = (gun.dmgforammo or 0) + dmg
						end
					end
					if isfire then
						en:AddBurn(EntityRef(effect.SpawnerEntity), 300, 1)
						en:GetData().burndamage = dmg / 2
					end
					if gore then
						l.goreMe(en, dmg, gorevel, 2)
					end
				end
			elseif type == 302 then
				local diff = en.Position - effect.Position
				local dist = diff:Length()
				local ang = diff:GetAngleDegrees()
				if dist < 72 + en.Size and math.abs(angleDiff(offset:GetAngleDegrees(), ang)) <= 90 then
					--en.Velocity = en.Velocity + ((offset * 30) * velmult)
					en:ToNPC().State = 16
					en:GetSprite():Play("Pant", true)
					hit = true
					hitblock = true
				end
			elseif en:IsEnemy() and type ~= 291 then
				local diff = en.Position - effect.Position
				local dist = diff:Length()
				local ang = diff:GetAngleDegrees()
				if dist < 72 + en.Size and math.abs(angleDiff(offset:GetAngleDegrees(), ang)) <= 90 then
					hit = true
					if type == 27 or type == 204 or (type == 212 and variant == 0) or type == 44 or type == 218 or type == 302 then
						hitblock = true
					end
				end
			elseif type == 4 then
				local diff = en.Position - effect.Position
				local dist = diff:Length()
				local ang = diff:GetAngleDegrees()
				if dist < 72 + en.Size and math.abs(angleDiff(offset:GetAngleDegrees(), ang)) <= 90 then
					if en:GetData().grenade then
						local ed = en:GetData()
						if en:GetData().height > -64 then
							ed.height = -30
							ed.fallspeed = -5
							ed.friction = .96
							ed.blowonhit = true
							en.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
							en.Velocity = en.Velocity + ((offset * 16) * velmult)
							hit = true
							hitblock = true
						end
					else
						en.Velocity = en.Velocity + ((offset * (90 / en.Mass)) * velmult)
						hit = true
						hitblock = true
					end
				end
			elseif type == 9 then
				local diff = en.Position - effect.Position
				local dist = diff:Length()
				local ang = diff:GetAngleDegrees()
				if dist < 72 and dist > 15 and math.abs(angleDiff(offset:GetAngleDegrees(), ang)) <= 90 then
					local proj = en:ToProjectile()
					if proj.Height > -40 then
						hit = true
						hitproj = true
						proj.Height = math.min(proj.Height, -10)
						en.Velocity = diff:Normalized() * 12
						proj.FallingSpeed = -2.5
					end
				end
			elseif type == 5 and variant ~= 100 then
				local diff = en.Position - effect.Position
				local dist = diff:Length()
				local ang = diff:GetAngleDegrees()
				if dist < 72 and dist > 15 and math.abs(angleDiff(offset:GetAngleDegrees(), ang)) <= 90 then
					if variant == 20 and subtype == 6 then
						en:ToPickup():Morph(5, 20, 2, true)
						--en:GetSprite():Play("Idle", true)
						--en:ToPickup().Wait = -1
						--en:ToPickup().Timeout = -1
						--en:ToPickup().State = 0
						hit = true
						hitblock = true
						subtype = 2
					end
					if variant == 52 or variant == 54 then
						en:ToPickup().Touched = true
						en:ToPickup():TryOpenChest()
						Isaac.Spawn(1000, 17, 0, en.Position, Vector(0, 0), nil)
						l.goreMe(en, dmg, gorevel, 2)
					end
					en.Velocity = en.Velocity + (offset * (20 / en.Mass))
				end
			elseif type == 1000 and variant == 51 then
				local diff = en.Position - effect.Position
				local dist = diff:Length()
				local ang = diff:GetAngleDegrees()
				if dist < 72 and dist > 15 and math.abs(angleDiff(offset:GetAngleDegrees(), ang)) <= 90 then
					en:Remove()
					wasfire = true
					sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1.5)
					sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
				end
			---[[
			elseif type == 1000 and variant == gCON.Variant.FlamethrowerFire then
				local diff = en.Position - effect.Position
				local dist = diff:Length()
				local ang = diff:GetAngleDegrees()
				if dist < 72 and dist > 15 and math.abs(angleDiff(offset:GetAngleDegrees(), ang)) <= 90 then
					en.Velocity = en.Velocity + (offset * 15)
				end--]]
			end
		end
		for i = 0, game:GetRoom():GetGridSize() - 1 do
			local grid = game:GetRoom():GetGridEntity(i)
			if grid ~= nil then
				local type = grid.Desc.Type
				if type == GridEntityType.GRID_TNT
				or type == GridEntityType.GRID_POOP
				or type == GridEntityType.GRID_SPIDERWEB then
					local diff = grid.Position - effect.Position
					local dist = diff:Length()
					local ang = diff:GetAngleDegrees()
					if grid.State ~= 4 and dist < 84 and math.abs(angleDiff(offset:GetAngleDegrees(), ang)) <= 90 then
						grid:Hurt(1)
						if type == GridEntityType.GRID_SPIDERWEB then
							grid:Destroy(false)
						else
							hit = true
							hiten = true
						end
					end
				end
			end
		end
		--sounds
		local pitch = .9 + (rng:RandomFloat() * .2)
		if hit then
			if hiten then
				if hitcrit then
					sfx:Play(snd.knife.crit, .8, 0, false, pitch)
				end
				if sd.mygun then
					local juicy = hitcrit and .5 or .3
					sd.mygun.juice = sd.mygun.juice + .3
					sd.mygun.prejuice = sd.mygun.prejuice + .3
				end
				sfx:Play(snd.knife.slash, .8, 0, false, -.1 + pitch)
			end
			if hitproj then
				sfx:Play(snd.knife.deflect, 1, 0, false, pitch)
			end
			if hitblock then
				sfx:Play(snd.knife.ding, 1, 0, false, pitch)
			end
			effect.SpawnerEntity.Velocity = effect.SpawnerEntity.Velocity + (offset * -3.5)
		end
		sfx:Play(snd.knife.swing, .8, 0, false, pitch)
		--fire thing
		if wasfire then
			sd.fireslash = true
		end
	end
	if effect:GetSprite():IsFinished("Slash") then
		effect:Remove()
	end
end
l:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, l.knife_effect, gCON.Variant.Knife)

function l.goreMe(en, dmg, vel, pow, noground)
	local noground = noground or false
	local killme = dmg > (en.HitPoints or 1)
	pow = math.floor(math.max(1, pow * ((killme and 2.5) or 1)))
	pow = math.min(pow, math.ceil((en.MaxHitPoints or 2) / 5))
	local bossbonus = false
	local roomtype = game:GetRoom():GetType()
	if en:IsBoss() and (roomtype == RoomType.ROOM_BOSS or roomtype == RoomType.ROOM_MINIBOSS or roomtype == RoomType.ROOM_BOSSRUSH) then
		local threshold = gVAR.bossmaxhp / (gVAR.bossstealables + 1)
		--log(gVAR.bosssteals..' boss steals at 1/'..(gVAR.bossstealables + 1)..' hp')
		if gVAR.bosssteals > 0 and gVAR.bosshp <= threshold * gVAR.bosssteals then
			if gVAR.bossdrops then
				bossbonus = true
				local dropme = 1 + rng:RandomInt(#gVAR.bossdrops)
				local dropid = gVAR.bossdrops[dropme]
				if dropid then
					local early = Isaac.Spawn(dropid[1], dropid[2], dropid[3], en.Position, vel:Rotated(-10 + (rng:RandomFloat() * 20)) * (.5 + (rng:RandomFloat() * .5)), nil)
					--early.GridCollisionClass = 6
					table.remove(gVAR.bossdrops, dropme)
					gVAR.bosssteals = gVAR.bosssteals - 1
				else
					log('boss drop expected but not found')
				end
			end
		end
	elseif killme then
		local coins = en:GetData().coins
		if coins and #coins > 0 then
			for i, coin in ipairs(coins) do
				Isaac.Spawn(coin[1], coin[2], coin[3], en.Position, vel:Rotated(-10 + (rng:RandomFloat() * 20)) * (1 + (rng:RandomFloat() * .25)), nil)
			end
			en:GetData().coins = nil
		end
	end
	if bossbonus then
		pow = pow * 3
	end
	for i = 1, pow do
		local gib = Isaac.Spawn(1000, 5, 0, en.Position, vel:Rotated(-10 + (rng:RandomFloat() * 20)) * (.5 + (rng:RandomFloat() * .5)), nil):ToEffect()
		gib.FallingSpeed = -2 - (rng:RandomFloat() * 2)
	end
	if not noground then
		Isaac.Spawn(1000, 17, 0, en.Position, Vector(0, 0), nil)
	end
end

function l.gunMaster(en)
	local ed = en:GetData()
	local gun = ed.mygun
	ed.aiming = angleDiff(ed.gunanim.rot, 0) == 0 and math.abs(angleDiff(((ed.input and ed.input.lastaimdir) or ed.guncontrol.aim):GetAngleDegrees(), ed.gunanim.dir)) < 10
	if en.Type == 1 then
		en.FireDelay = 9999
	else
		ed.clips = {5, 5, 5, 5, 5, 5, 5, 0}
	end
	if ed.gunners then
		for i, fam in ipairs(ed.gunners) do
			if not fam:Exists() then
				table.remove(ed.gunners, i)
				i = i - 1
			end
		end
	end
	if not mmenuvar.open then
		if en.Type == 1 and ed.input then
			ed.tearinherit = math.max(0, Vector.FromAngle(math.abs((ed.input.lastaimdir:GetAngleDegrees() + 360) - (en.Velocity:GetAngleDegrees() + 360))).X) * en.Velocity:Length()
			if en.Variant == 0 then
				l.gunCollect(en)
				l.gunInventory(en)
				ed.gunanim.size = en.Size
				if game:GetFrameCount() - gVAR.lastenemyframe > 2 then
					if game:GetRoom():IsClear() then
						ed.activeuntil = math.min(ed.activeuntil, en.FrameCount + 20)
					else
						ed.activeuntil = math.min(ed.activeuntil, en.FrameCount + 90)
					end
				elseif not en:IsExtraAnimationFinished() then
					ed.activeuntil = en.FrameCount - 1
				else
					ed.activeuntil = math.max(ed.activeuntil, en.FrameCount + 30)
				end
				ed.idle = (en.FrameCount >= ed.activeuntil)
			end
			--stuff
			if en:IsExtraAnimationFinished() then
				l.knifeMaster(en)
				l.gunControl(en)
			end
			l.gunUse(en, ed.mygun)
			l.gunFire(en, ed.mygun)
			if en:IsExtraAnimationFinished() then
			else
				if gun then
					gun.charge = 0
					gun.crit = false
					gun.shotstreak = 0
					gun.forceshot = false
					gun.clip = gun.clip + gun.chamber
					gun.chamber = 0
				end
			end
		elseif type ~= 3 then
			if gun then
				local gc = ed.guncontrol
				if en:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
					gc.reload = false
					gc.load = false
					gc.shoot = false
					gc.aiming = false
				else
					local pt = en:ToNPC():GetPlayerTarget()
					gc.aim = (pt.Position - en.Position):Normalized()
					if not gun.reloading then
						if gun.clip + gun.subclip == 0 and gun.chamber == 0 then
							gc.reload = true
							gc.aiming = false
						else
							gc.reload = false
							gc.load = true
							gc.shoot = true
							gc.aiming = true
						end
					end
				end
			end
			l.gunUse(en, ed.mygun)
			l.gunFire(en, ed.mygun)
		end
	end
end

--GUN/MOD COLLECTION HANDLING
function l.gunCollect(player) -- rewrite gay
	local d = player:GetData()
	if d.newitems then
		if not player:IsItemQueueEmpty() then
			local id = d.newitems[1]
			local fake = id < 0
			local useid = (fake and id * -1) or id
			d.hadhearts = player:GetMaxHearts()
			d.hadbones = player:GetBoneHearts()
			if gITM.type[useid] then
				if gITM.type[useid] == EIT.mod or gITM.type[useid] == EIT.gun then
					if not d.liftitem then
						d.liftitem = Isaac.Spawn(1000, gCON.Variant.DynamicCollectible, useid, player.Position, player.Velocity, player):ToEffect()
						d.liftitem.Parent = player
						player:AnimateCollectible(gCON.Id.Placeholder, "Pickup", "PlayerPickup")
					end
				end
			end
		else
			if d.newitems then
				for i, id in ipairs(d.newitems) do
					local fake = id < 0
					local useid = (fake and id * -1) or id
					if gITM.type[useid] then
						if gITM.type[useid] == EIT.gun then
							-- OLD OLD OLD
							--[[
							if not fake then
								local newgun = l.gunInit(useid, true)
								local clone = l.gunInit(useid, false)
								clone.isclone = true
								newgun.clone = clone.useid
								table.insert(d.loadout, newgun)
								l.gunSwitch(player, newgun)
							end
							player:RemoveCollectible(useid)--]]
						elseif gITM.type[useid] == EIT.mod then
							if not fake then
								table.insert(d.mods, useid)
							end
							player:RemoveCollectible(useid)
						else
							table.insert(d.passives, useid)
						end
					end
				end
				player:AddMaxHearts(d.hadhearts - player:GetMaxHearts())
				player:AddBoneHearts(d.hadbones - player:GetBoneHearts())
				l.convert_pickups()
			end
			d.newitems = nil
		end
	end
	if player:IsItemQueueEmpty() or not d.newitems then
		if d.liftitem then
			d.liftitem:Remove()
			d.liftitem = nil
		end
	end
end

function l.gunMod(gun, mod, player)
	player = player or false
	if type(mod) == 'number' then
		table.insert(gun.mods, mod)
		local moddat = gITM.moddat[mod]
		if moddat then
			l.gunMod(gun, moddat, player)
		end
	else
		local types = {'init', 'set', 'add', 'mult'}
		for i = 1, 4 do
			local modtype = types[i]
			local list = mod[modtype]
			if list then
				for var, value in pairs(list) do
					if var ~= 'meta' then
						if type(value) == 'table' then
							if modtype == 'init' then
								if var == 'sp' then
									gun.sp = gun.sp or {}
									for i, new in ipairs(value) do
										gun.sp[new] = gun.sp[new] or 0 + 1
									end
								else
									gun[var] = gun[var] or {}
									l.gunMod(gun[var], {init = value})
								end
							elseif modtype == 'set' then
								l.gunMod(gun[var], {set = value})
							elseif modtype == 'add' then
								if var == 'as' or var == 'ms' or var == 'copies' then
									l.gunMod(gun[var], {add = value})
								elseif var == 'sp' then
									for i, new in ipairs(value) do
										gun.sp[new] = gun.sp[new] or 0 + 1
									end
								elseif var == 'tf' then
									for i, new in ipairs(value) do
										local flags = {}
										for j, k in pairs(new) do
											flags[j] = k
										end
										table.insert(gun.tf, flags)
									end
								elseif var == 'mods' then
									if #value > 0 then
										for i, mod in ipairs(value) do
											l.gunMod(gun, mod)
										end
									end
								end
							elseif modtype == 'mult' then
								if var == 'as' or var == 'ms' or var == 'copies' then
									l.gunMod(gun[var], {mult = value})
								end
							end
						else
							if (modtype == 'init' and gun[var] == nil) or modtype == 'set' then
								gun[var] = value
							elseif modtype == 'add' then
								gun[var] = (gun[var] or 0) + value
							elseif modtype == 'mult' then
								gun[var] = (gun[var] or 0) * value
							end
						end
					end
				end
			end
		end
		--special conversions
		if gun.maxchamberpct and gun.clipsize then
			gun.maxchamber = math.ceil(math.max(2, math.min(gun.clipsize * gun.maxchamberpct)))
		end

		if gun.clip and gun.clipsize then
			gun.clip = math.min(gun.clip, gun.clipsize)
		end

		if player and player:GetData().mygun == gun then
			l.gunSwitch(player, gun)
		end
	end

	return gun
end

function l.gunInit(type, persistent, gun)
	local newgun = gun or {}
	newgun.meta = newgun.meta or {}
	newgun.meta.ready = false
	newgun.meta.type = type
	newgun.meta.rank = (WEPT[type].meta.rank or 1)

	l.gunMod(newgun, {init = WEPT[type]})
	local parent = WEPT[type].meta.parent or false;	local loops = 1
	while parent and loops < 30 do
		l.gunMod(newgun, {init = WEPT[parent]})
		parent = WEPT[parent].meta.parent or false
		loops = loops + 1
		if loops == 30 then
			log('Gun init failed. Parent loop detected.')
			l.gunMod(newgun, {init = WEPT['default']})
		end
	end

	if gVAR.modall then
		log('mod all')
		l.gunMod(newgun, gVAR.modall)
	end

	newgun.meta.ready = true
	newgun.persistent = persistent

	--dynamic stats
	newgun.charge = 0
	newgun.chamber = 0
	newgun.clip = newgun.clipsize
	newgun.subclip = 0
	newgun.activeammomult = 1
	newgun.freeshots = 0
	newgun.spread = newgun.spreadmin
	newgun.firedelay = 0
	newgun.charge = 0
	newgun.shotstreak = 0
	newgun.reloading = false
	newgun.reloadcount = 0
	newgun.firingshots = 0
	newgun.juice = 0--6 * gCON.juiceperpip
	newgun.prejuice = 0
	newgun.juicetimer = 0
	newgun.lastshot = 0
	newgun.tempfx = {}
	newgun.activecharge = 0

	newgun.fireevents = 0
	newgun.weaponsshot = 0

	--indexing
	newgun.id = #gVAR.guns + 1
	gVAR.guns[newgun.id] = newgun

	return newgun
end

function l.gunSwitch(en, gun, preview)
	local preview = preview or false
	local d = en:GetData()
	local player1 = (en.Type == 1 and en.Variant == 0 and en) or false
	gVAR.gunswitched = true

	if d.mygun then
		--reset shit
		d.mygun.charge = 0
		d.mygun.crit = false
		--the stuff
		if not gun then
			sfx:Play(snd.misc.pack, 1, 0, false, 1)
		end
		if d.gunhistory and gun and not preview then
			for i, pick in ipairs(d.gunhistory) do
				if pick == gun then
					table.remove(d.gunhistory, i)
					break
				end
			end
			table.insert(d.gunhistory, 1, gun)
		end
		if player1 then
			local mods = d.mygun.mods
			for i, mod in pairs(mods) do
				if gITM.disable[mod] then
					player1:RemoveCostume(config:GetCollectible(mod))
				else
					player1:RemoveCollectible(mod)
				end
			end
			--drones
			if d.drones then
				for i, drone in ipairs(d.drones) do
					if drone:Exists() then
						drone:Remove()
					end
				end
			end
			--gun skills
			if d.mygun.skill then
				if gITM.skills[player1:GetActiveItem()] then
					d.mygun.hadcharge = player1:GetActiveCharge()
					player1:RemoveCollectible(player1:GetActiveItem())
					gVAR.skillsecondslot = false
				elseif gITM.skills[player1.SecondaryActiveItem.Item] then
					d.mygun.hadcharge = player1.SecondaryActiveItem.Charge
					player1:RemoveCollectible(player1.SecondaryActiveItem.Item)
					gVAR.skillsecondslot = true
				end
			end
		end
	end
	if gun then
		if gun ~= d.mygun and not preview then
			sfx:Play(snd.misc.attach, 1, 0, false, 1)
		end
		gun.rendered = nil
		if player1 then
			local preadd = {
				maxhearts = player1:GetMaxHearts(),
				hearts = player1:GetHearts(),
				soulhearts = player1:GetSoulHearts(),
				blackhearts = player1:GetBlackHearts(),
				eternalhearts = player1:GetEternalHearts(),
				bonehearts = player1:GetBoneHearts(),
				coins = player1:GetNumCoins(),
				bombs = player1:GetNumBombs(),
				keys = player1:GetNumKeys(),
				spritescale = player1.SpriteScale,
				sizemulti = player1.SizeMulti
			}
			if #gun.mods > 0 then for i, mod in ipairs(gun.mods) do
				if gITM.disable[mod] then
					player1:AddCostume(config:GetCollectible(mod), false)
				else
					player1:AddCollectible(mod, 0, false)
				end
			end end
			player1:AddMaxHearts(preadd.maxhearts - player1:GetMaxHearts(), false)
			player1:AddHearts(preadd.hearts - player1:GetHearts())
			player1:AddSoulHearts(preadd.soulhearts - player1:GetSoulHearts())
			player1:AddBlackHearts(preadd.blackhearts - player1:GetBlackHearts())
			player1:AddEternalHearts(preadd.eternalhearts - player1:GetEternalHearts())
			player1:AddBoneHearts(preadd.bonehearts - player1:GetBoneHearts())
			player1:AddCoins(preadd.coins - player1:GetNumCoins())
			player1:AddBombs(preadd.bombs - player1:GetNumBombs())
			player1:AddKeys(preadd.keys - player1:GetNumKeys())
			player1.SpriteScale = preadd.spritescale
			player1.SizeMulti = preadd.sizemulti
			--gun skills
			if gun.skill then
				player1:AddCollectible(gun.skill, gun.hadcharge or 0, false)
				if gVAR.skillsecondslot then
					player1:SwapActiveItems()
				end
			end
		end
		--spawn attached familiar
		if gun.drones then
			for i = 1, gun.drones do
				local rot = rng:RandomFloat() * 360
				local drone = Isaac.Spawn(3, gCON.Variant.Drone, 0, en.Position + Vector(10, 0):Rotated(rot), Vector(0, 0):Rotated(rot), en)
				drone.PositionOffset = Vector(0, -36)
				local dd = drone:GetData()
				dd.owner = en
				dd.input = d.input
				dd.linkgun = gun
				dd.mygun = gun
				l.gunSpawn(drone, gun)
				d.drones = d.drones or {}
				table.insert(d.drones, drone)
			end
		end
	end
	l.gunSpawn(en, gun)
	d.mygun = gun
	if gun then
		gun.myuser = en
	end
	if player1 then
		player1:AddCacheFlags(CacheFlag.CACHE_ALL)
		player1:EvaluateItems()
	else
		if gun then
			d.gunstat = {
				Damage = (gCON.enstats.Damage + gun.as.damage) * gun.ms.damage,
				MaxFireDelay = (gCON.enstats.MaxFireDelay + gun.as.maxfiredelay) * gun.ms.maxfiredelay,
				ShotSpeed = (gCON.enstats.ShotSpeed + gun.as.shotspeed) * gun.ms.shotspeed,
				TearHeight = (gCON.enstats.TearHeight + gun.as.range) * gun.ms.range,
				Luck = (gCON.enstats.Luck + gun.as.luck) * gun.ms.luck,
			}
		else
			d.gunstat = {
				Damage = gCON.enstats.Damage,
				MaxFireDelay = gCON.enstats.MaxFireDelay,
				ShotSpeed = gCON.enstats.ShotSpeed,
				TearHeight = gCON.enstats.TearHeight,
				Luck = gCON.enstats.Luck,
			}
		end
	end
	return d.mygun
end

function l.gunSpawn(en, gun)
	local weapons = en:GetData().weapons
	local d = en:GetData()
	if weapons then
		for i, set in ipairs(weapons) do
			for j, wep in ipairs(set) do
				local wd = wep:GetData()
				if wd.bayonet then
					wd.bayonet:Remove()
				end
				if wd.lasersightent then
					wd.lasersightent:Remove()
				end
				if wd.gun.laserdotent then
					wd.gun.laserdotent:Remove()
					wd.gun.laserdotent = nil
				end
				wep:Remove()
			end
			weapons[i] = nil
		end

		en:GetData().weapons = nil
	end
	if gun and not (d.perks and d.perks.nogun) then
		en:GetData().weapons = {}
		for i = 1, 4 do
			local set = {}
			if gun.copies[i] > 0 then
				for j = 1, gun.copies[i] do
					local weapon = Isaac.Spawn(3, gCON.Variant.Weapon, 0, en.Position, Vector(0, 0), en)
					table.insert(set, weapon)
					local wd = weapon:GetData()
					local ws = weapon:GetSprite()
					wd.wielder = en or gun.myuser
					wd.gun = gun
					weapon.PositionOffset = Vector(0, gCON.gunheight)
					weapon.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					weapon.DepthOffset = 0
					wd.direction = Vector(1, 0)
					wd.tearspawn = weapon.Position
					wd.recoil = 0
					ws:ReplaceSpritesheet(0, gWEP.BaseSprite[gun.base])
					ws:ReplaceSpritesheet(1, gWEP.BaseSprite[gun.base])
					ws:LoadGraphics()
					ws.Color = Color(1, 1, 1, 0, 0, 0, 0)
					wd.alpha = 1
					if gun.sp[ESP.bayonet] then
						local bayonet = Isaac.Spawn(3, gCON.Variant.Bayonet, 0, en.Position, Vector(0, 0), en)
						weapon:GetData().bayonet = bayonet
						bayonet.PositionOffset = Vector(0, gCON.gunheight)
						bayonet:GetSprite().Scale = Vector(.5, .5)
						bayonet.DepthOffset = -(gWEP.BaseLength[gun.base] * .6)
						bayonet.CollisionDamage = Lerp(2 * gun.sp[ESP.bayonet], en:GetData().gunstat.Damage, .25) * .3
					end
				end
			end
			table.insert(en:GetData().weapons, set)
		end
	end
end

function l.gunMove(en, gun)
	local d = en:GetData()
	--with gun
	if gun and not game:IsPaused() then
		gun.rendered = true
		for h, fam in ipairs(d.gunners) do
			local fd = fam:GetData()
			local gc = d.guncontrol
			local aim = (fd.famaimdir or gc.aim):GetAngleDegrees()
			local animspeed = 1
			if gun.forcetarget then
				aim = (gun.forcetarget - fam.Position):GetAngleDegrees()
			end
			local anim = fd.gunanim or d.gunanim
			local gunready = false
			anim.aiming = false

			local stat = d.gunstat
			local mysize = anim.size / 2
			local myheight = gun.heightmod or 1

			local disttgt = mysize + 6 + gWEP.BaseLength[gun.base] + (gun.holddist or 0)
			if fd.isdrone and not fd.isincu then
				disttgt = 12
			end
			local rotanimtgt = 0
			local heighttgt = gCON.gunheight * myheight
			local idle = false
			local aimspeed = (gun.using and gun.aimspeed) or gCON.baseaimspeed

			local shakeoff = 0
			local shine = gun.crit and (en.FrameCount % 2) or 0

			if gc.aiming and not (gun.rev and gun.rev < gun.revtime) then
				local charge = math.min(1, gun.charge / stat.MaxFireDelay)
				local shake = gun.spreadmax > 0 and (Lerp(0, (gun.spreadmax) / 3, gun.spread / (gun.spreadmax) or 0)) or 0
				shakeoff = shake * Vector(0, 1):Rotated(en.FrameCount * 90).Y * (gun.shakemod or 1)
			end

			if gun.chainsaw and gun.firedelay <= -5 and (not gc.aiming) then
				idle = true
			end

			local length = gWEP.BaseLength[gun.base]
			if gun.reloading then
				disttgt = mysize + 2 + (length * .5)
				rotanimtgt = 65
				animspeed = .7
			elseif (idle or d.idle) and not fd.isdrone then
				idle = true
				disttgt = mysize + 10 + (length * .3)
				rotanimtgt = -80
				aim = anim.side
				heighttgt = (gCON.gunheight * myheight * .75) - (length / 2)
				animspeed = .6
			else
				gunready = true
				if math.abs(aim) < 90 then
					anim.side = 0
				elseif math.abs(aim) > 90 then
					anim.side = 180
				end
			end

			local angdif = angleDiff(aim, anim.dir)
			if gun.forcetarget then
				anim.dir = aim
				anim.rot = 0
				anim.dist = disttgt
				anim.height = heighttgt
			else
				anim.dir = anim.dir + approach(0, angdif, aimspeed / 2)
				anim.dir = ((anim.dir + 540) % 360) - 180
				anim.rot = approach(anim.rot, rotanimtgt, 15 * animspeed)
				anim.dist = approach(anim.dist, disttgt, 4 * animspeed)
				anim.height = approach(anim.height, heighttgt, 3 * animspeed)
			end


			local weapons = fam:GetData().weapons
			if weapons then
				for i = 1, 4 do
					local set = weapons[i]
					local midnum = (#set + 1) / 2
					local port = i * 90
					for j, wep in ipairs(set) do
						local wd = wep:GetData()
						local ws = wep:GetSprite()
						local spacing = 10
						local dual = (gun.sp[ESP.noarc] or #set == 2)
						if dual then
							spacing = 25
						end
						local offang = (spacing * (j - midnum))
						local spawnflash = false

						local myfan = anim.dir + offang
						local myrot = myfan + port
						wd.recoil = approach(wd.recoil, 0, 1)

						if gun.shotfx and (not gun.noshotfx) and ((not gun.alternatinggunfire) or (gun.fireevents % (gun.alternatinggunfire or 1) == (j % (gun.alternatinggunfire or 1)))) then
							wd.recoil = -8
							spawnflash = true
						end
						local distoff = anim.dist + wd.recoil

						local offset = Vector(distoff, 0):Rotated(myrot)
						if dual then
							myrot = anim.dir + port
						end
						local topos = fam.Position + offset + Vector(0, -1)

						local flip = math.abs(anim.dir) > 90
						if #set == 2 and not idle then
							flip = j == 1
						end
						local invert = 1 - (flip and 2 or 0)
						wd.alpha = approach(wd.alpha, 1, .2)
						ws.FlipY = flip
						ws.Color = Color(1, 1, 1, wd.alpha, math.floor(shine * 50), math.floor(shine * 50), math.floor(shine * 30))
						wep.Velocity = (topos - wep.Position) * .98
						wd.rotation = myrot + anim.rot
						wep.SpriteRotation = (myrot * invert) + anim.rot + shakeoff
						wep.PositionOffset = Vector(0, anim.height)

						wd.direction = Vector.FromAngle(myrot)
						wd.tearspawn = wep.Position + wep.Velocity + Vector(gWEP.BaseLength[gun.base] - wd.recoil, 0):Rotated(myrot)

						if gun.shotfx and not gun.noshotfx then
							if spawnflash and not gun.animminigun then
								if gun.animrpg then
									ws:Play("ShootRpg", true)
								else
									ws:Play("Shoot", true)
								end
								ws.PlaybackSpeed = 1
							end
							if spawnflash and not gun.sp[ESP.flamethrower] then
								local flash = Isaac.Spawn(1000, gCON.Variant.MuzzleFlash, 0, wep.Position, Vector(0, 0), wep)
								flash = flash:ToEffect()
								flash.SpriteRotation = myrot + (anim.rot * invert)
								flash.PositionOffset = wep.PositionOffset
								flash.Position = wep.Position + wep.Velocity + (Vector((gWEP.BaseLength[gun.base] - wd.recoil) - 4, 0):Rotated(myrot + (anim.rot * invert)))

								local light = Isaac.Spawn(7, 8, 1, flash.Position, Vector(0, 0), flash)
								light:GetSprite():ReplaceSpritesheet(0, "gfx/collectibles/collectible_blank.png")
								light:GetSprite():LoadGraphics()
								light.CollisionDamage = 0
								light.Visible = false
								light:ToLaser():SetTimeout(5)
								flash:GetData().light = light
								light = light:ToLaser()
								light.EndPoint = flash.Position
								light.Angle = flash.SpriteRotation
								flash:GetData().level = gSET.ShotFlashBrightness * .25
								light.Color = gVAR.flashlightcolor
								light.MaxDistance = 40
								light.SpriteScale = Vector(3, 3)

								gVAR.mutelightspawn = true
							end
						end

						if gun.animminigun then
							if game:GetFrameCount() - gun.lastshot < 2 then
								ws:Play("ShootMinigun", true)
							else
								ws:Play("IdleMinigun", true)
								--ws.PlaybackSpeed = ((gun.rev or 20) / 20)
							end
							ws.PlaybackSpeed = (gun.rev and gun.rev > 0 and 1) or 0
						end
						if gun.chainsaw then
							if gun.firedelay >= 0 then
								if not ws:IsPlaying("ShootChainsaw") then
									ws:Play("ShootChainsaw", true)
								end
							else
								ws:Play("Idle")
							end
						end

						local bayonet = wd.bayonet
						if bayonet then
							bayonet.SpriteRotation = wep.SpriteRotation - 90
							bayonet.PositionOffset = wep.PositionOffset
							bayonet.Position = wep.Position + Vector((gWEP.BaseLength[gun.base]) + 10, 0):Rotated(wep.SpriteRotation * invert)
							bayonet.Velocity = wep.Velocity
							bayonet:GetSprite().FlipY = flip
							bayonet:GetSprite().Color = ws.Color
						end
						if gun.lasersight or gSET.AlwaysLaserSight then
							if not (wd.lasersightent and wd.lasersightent:Exists()) then
								local laser = Isaac.Spawn(1000, gCON.Variant.LaserSight, 0, en.Position, Vector(0, 0), en)
								wd.lasersightent = laser
								laser.DepthOffset = -(gWEP.BaseLength[gun.base] * .6)
							end
							local laser = wd.lasersightent
							laser.SpriteRotation = wep.SpriteRotation
							laser.PositionOffset = wep.PositionOffset
							laser.Position = wep.Position + Vector((gWEP.BaseLength[gun.base] - (gun.nikita and 25 or 0)), 0):Rotated(wep.SpriteRotation * invert)
							laser.Velocity = wep.Velocity
							laser:GetSprite().FlipY = flip
							laser.SpriteScale = gSET.AlwaysLaserSight and Vector(3, 1) or Vector(2, 1)
							laser.Visible = gunready
							--laser:GetSprite().Color = Color(255, 0, 0, 1, 0, 0, 0)
						end
						if gun.laserguide then
							if not (gun.laserdotent and gun.laserdotent:Exists()) then
								local dot = Isaac.Spawn(1000, gCON.Variant.LaserDot, 0, en.Position, Vector(0, 0), nil)
								dot.SpriteScale = Vector(.7, .7)
								dot:GetData().parent = en
								gun.laserdotent = dot
							end
						end
					end
				end
			end
		end
		gun.shotfx = false
	end
end

function l:muzzleFlash(effect)
	local d = effect:GetData()
	local light = d.light
	if light and d.level then
		light.Visible = true
		light = light:ToLaser()
		d.level = Lerp(d.level, 0, .35)
		local level = d.level

		if level <= .005 then
			light:Remove()
			effect:Remove()
		else
			local fclr = gVAR.flashlightcolor
			light.Color = Color(fclr.R, fclr.G, fclr.B, d.level * gSET.ShotFlashBrightness, 0, 0, 0)
		end
	else
		if effect:GetSprite():IsFinished("Idle") then
			effect:Remove()
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, l.muzzleFlash, gCON.Variant.MuzzleFlash)


function l.gunControl(player)
	local d = player:GetData()
	local gc = d.guncontrol
	local input = d.input
	local gun = d.mygun
	if gun and input then
		local bpct = 1 / gun.clipsize
		local resammo = math.floor((d.clips[gun.ammotype] / bpct) + .001)
		local hasreserve = resammo >= 1
		local ischarge = gun.firemode == EFM.charge
		local hasshots = gun.clip > 0 or gun.chamber > 0
		local canshoot = d.aiming
		local reloading = gun.reloading

		gc.shooting = ((gc.shooting or gun.shot) and input.shoot)
		gc.shootqueue = hasshots and (gc.shootqueue and not gun.shot) or ((input.shootpress and not ischarge) or (input.shootrelease and ischarge))
		gc.shootqueue = gc.shootqueue and player:IsExtraAnimationFinished() and (not gun.reloading or (gun.firedelay > 10 and not ischarge))

		gc.using = input.shoot

		--reload
		gc.reload = input.reload and not gun.singleuse
		if gun.firingshots == 0 and gun.clip + gun.subclip == 0 and not gun.reloading then
			if gSET.AutoReload and resammo >= 1 and not (gun.singleuse or gun.refundableshots) then
				gc.reload = true
			end
		end

		--chambering / firing
		if ischarge then
			gc.charge = input.shoot or input.shootrelease
			gc.load = input.shoot
			gc.shoot = input.shootrelease
		else
			gc.charge = false
			gc.shoot = input.shoot
			gc.load = gc.shoot
		end

		gc.shootpress = input.shootpress
		gc.shoot = (canshoot or gc.shooting or gun.chamber > 0) and (gc.shoot or gc.shootqueue)
		gc.load = (canshoot and gc.load) or gc.shoot

		--aiming
		gc.aiming = gc.load or gc.shoot or gc.shootqueue
		gc.aim = input.lastaimdir

		--laser dot
		if gun.laserguide then
			if input.mouse then
				gc.dotaim = Isaac.ScreenToWorld(Input.GetMousePosition())
			else
				gc.dotaim = player.Position + (gc.aim * 160)
			end
		end
	end
end

function l.gunUse(en, gun)
	if gun then
		local d = en:GetData()
		local gc = d.guncontrol
		local stat = d.gunstat
		local player = (en.Type == 1 and en) or false

		local bpct = 1 / gun.clipsize
		local resammo = math.floor((d.clips[gun.ammotype] / bpct) + .001)
		local ischarge = gun.firemode == EFM.charge
		local allbullets = gun.clip + gun.chamber

		gun.shot = false
		if (not player) or player:IsExtraAnimationFinished() then
			--killer sight
			if gun.ksvictims and #gun.ksvictims == 0 then
				gun.ksvictims = nil; gun.forcetarget = nil
			end
			--RELOADING
			if gun.reloading then
				local reloadrate = math.max(.66, ((stat.ShotSpeed - 1) * 1) + 1)
				local bulletcost = gun.reloadtime / gun.clipsize
				local interrupt = (gun.reloadbullet ~= 0 and gc.shootpress)
				gun.refundableshots = nil
				gun.subclip = 0
				if not gun.wasreloading then
					sfx:Play(gun.sndrl1[1], gun.sndrl1[2], 0, false, gun.sndrl1[3])
					gun.reloadcount = 0
					gun.charge = 0
					gun.charged = false
					gun.crit = false
					gun.shotstreak = 0
					gun.forceshot = false
					if resammo < 1 then
						gun.reloading = false
						sfx:Play(snd.misc.empty, 1, 0, false, 1)
					elseif gun.reloadbullet == 0 then
						d.clips[gun.ammotype] = d.clips[gun.ammotype] + (gun.clip * bpct)
						gun.clip = 0
					end
				end
				d.activeuntil = en.FrameCount + 30
				gun.wasreloading = true
				if gun.reloading then
					gun.reloadcount = gun.reloadcount + reloadrate
					if gun.clip == gun.clipsize or resammo < 1 or interrupt then -- finished
						gun.reloading = false
						sfx:Stop(d.mygun.sndrl1[1])
						sfx:Play(gun.sndrl2[1], gun.sndrl2[2], 0, false, gun.sndrl2[3])
					elseif gun.reloadbullet ~= 0 then -- shell load
						if gun.reloadcount - gun.reloadtime > gun.reloadbullet then
							local bpoints = 1--math.min((1 / gun.ammoshots), gun.clipsize - gun.clip)
							gun.clip = gun.clip + bpoints
							sfx:Play(gun.sndshell[1], gun.sndshell[2], 0, false, gun.sndshell[3])
							gun.reloadcount = gun.reloadcount - gun.reloadbullet
							if d.clips then
								d.clips[gun.ammotype] = d.clips[gun.ammotype] - (bpct * bpoints)
							end
						end
					else -- clip load
						if gun.reloadcount >= bulletcost then
							local bpoints = 1--math.min((1 / gun.ammoshots), gun.clipsize - gun.clip)
							gun.clip = gun.clip + bpoints
							if d.clips then
								d.clips[gun.ammotype] = d.clips[gun.ammotype] - (bpct * bpoints)
							end
							gun.reloadcount = gun.reloadcount - bulletcost
						end
					end
				end
			end
			if not gun.reloading then
				if gun.wasreloading then
					sfx:Stop(d.mygun.sndrl1[1])
				end
				gun.wasreloading = false
				--not firing rounds
				if gun.firingshots == 0 then
					gun.forceshot = false
					if gc.reload and gun.chamber == 0 then
						gun.reloading = true
					else
						--rev
						if gun.revtime and (gc.load or gc.shootqueue) then
							if gun.rev then
								gun.rev = approach(gun.rev or 0, gun.revtime, 2)
							end
							if gun.rev < gun.revtime then
								gc.load = false
							end
						end
						--min shots
						if gun.shotstreak > 0 and gun.shotstreak < gun.minshots and gun.clip > 0 then
							if gun.firemode == EFM.auto then
								gun.forceshot = true
							end
						end
						if gc.load or gun.forceshot then
							--chambering bullets
							if gun.clip + gun.subclip > 0 then
								if gun.firedelay <= 0 and gun.chamber < gun.maxchamber then
									local prevchamber = gun.chamber
									local useclip = ((gun.clip * gun.ammoshots) + gun.subclip) / gun.activeammomult
									local burst = math.ceil(math.min(gun.burst, useclip, gun.maxchamber - gun.chamber))
									gun.subclip = gun.subclip - (burst * gun.activeammomult)
									--local cost = math.floor(gun.subclip / gun.ammoshots)
									--gun.clip = gun.clip - cost
									--gun.subclip = gun.subclip + (cost * gun.ammoshots)
									while gun.subclip < 0 do
										gun.subclip = gun.subclip + gun.ammoshots
										gun.clip = gun.clip - 1
									end
									gun.chamber = gun.chamber + burst
									gun.shotstreak = gun.shotstreak + burst
									gun.firedelay = stat.MaxFireDelay
									if ischarge and gun.chamber > prevchamber then
										local pitch = .9
										if gun.chamber == gun.maxchamber or gun.clip + gun.subclip == 0 then
											pitch = 1.1
										end
										sfx:Play(snd.misc.click, .6, 0, false, pitch)
									end
								end
							elseif gun.firedelay <= 0 and gun.chamber == 0 then
								sfx:Play(snd.misc.empty, 1, 0, false, 1)
								gun.firedelay = 10
							end
						else
							--if gun.subclip / gun.ammoshots < 1 then
							--gun.subclip = 0
							--end
						end
						if gun.firedelay <= 0 and gun.chamber == 0 then
							gun.shotstreak = 0
						end
						--CHARGING SHOTS
						if gun.chargescale then
							local charging = gc.charge and (gun.chamber > 0) and (gun.chamber == gun.maxchamber or gun.clip + gun.subclip == 0)
							if charging then
								gun.charge = gun.charge + .5
								local charged = charging and gun.charge >= stat.MaxFireDelay
								local crit = charged and gun.critframes > 0 and (gun.charge - stat.MaxFireDelay < gun.critframes / 2)
								if charged then
									gun.charged = true
									if crit then
										if not gun.crit then
											sfx:Play(snd.misc.charged, .6, 0, false, 1.1)
											gun.crit = true
											gun.chargebonus = gun.critbonus
										end
									else
										gun.crit = false
										gun.chargebonus = 1
									end
									gun.spread = gun.spreadmin
								else
									gun.crit = false
									gun.chargebonus = gun.chargemin
									gun.spread = gun.spreadmax
								end
							else
								gun.spread = gun.spreadmax
								gun.crit = false
								gun.charge = 0
								gun.charged = false
								gun.chargebonus = gun.chargemin or 1
							end
						else
							gun.charged = false
							gun.chargebonus = 1
							gun.crit = false
						end
						--BULLETS IN CHAMBER
						if gun.chamber > 0 then
							if gc.shoot or gun.forceshot then
								--bullet refunds
								if gun.refundshot then
									gun.refundableshots = (gun.refundableshots or 0) + 1
								end
								--can't shoot this many
								if gun.sp[ESP.fullcharge] and gun.clip > 0 and gun.chamber < gun.maxchamber then
									gun.clip = gun.clip + gun.chamber
									gun.chamber = 0
									gun.charge = 0
									gc.shootqueue = false
								elseif gun.mustcharge and gun.charge < stat.MaxFireDelay then
									gun.clip = gun.clip + gun.chamber
									gun.chamber = 0
									gun.charge = 0
									gc.shootqueue = false
								--to shoot
								else
									gun.firingshots = gun.chamber
									--local deduct = math.min(gun.chamber, gun.freeshots)
									--gun.clip = gun.clip + deduct
									--gun.freeshots = gun.freeshots - deduct
									--free shot items
									if gun.freeshotchance and gun.subclip == 0 then
										for i = 1, gun.chamber do
											local isfree = (rng:RandomFloat() * (1 + gun.freeshotchance)) > 1
											if isfree and gun.clip < gun.clipsize then
												gun.freeshots = math.min(gun.clipsize, gun.freeshots + 1)
											end
										end
									end
									if gun.sp[ESP.chargedamage] then
										gun.firingshots = 1
										gun.chargebonus = (gun.chargebonus or 1) * gun.chamber
									end
									if gun.sp[ESP.brimstone] then
										gun.firingshots = math.ceil((gun.chamber * (stat.Damage / .666) / 2))
									end
									if gun.ksvictims then
										gun.firingshots = gun.firingshots * #gun.ksvictims
									end

									gun.chamber = 0
									if gun.firemode == EFM.charge then
										gun.firedelay = 0
									end
								end
							end
						end
					end
				end
				--FIRING SHOTS
				if gun.firingshots > 0 then
					d.activeuntil = en.FrameCount + 60
					gun.shot = true; gun.shotfx = true
					gun.firingshots = gun.firingshots - 1
					gun.using = true

					if gun.ksvictims then
						local next = gun.ksvictims[1]
						while #gun.ksvictims > 0 and ((not next:Exists()) or next:IsDead()) do
							table.remove(gun.ksvictims, 1)
							next = gun.ksvictims[1]
						end
						if #gun.ksvictims > 0 then
							gun.forcetarget = next.Position
							table.remove(gun.ksvictims, 1)
						end
					end

					--jamming
					if gun.sp[ESP.jams] and (gun.clip / gun.clipsize) < .8 then
						if rng:RandomFloat() < .75 / (18 + stat.Luck) then
							sfx:Play(snd.misc.empty, 1, 0, false, 1)
							gun.reloading = true
						end
					end

					if gun.firingshots == 0 then
						gun.charge = 0
					end
					if player then
						gVAR.knifespeedbonusready = false
					end
				end
			end
		end

		if gun.freeshots > 0 and gun.clip + math.ceil(gun.subclip / gun.ammoshots) < gun.clipsize then
			gun.clip = gun.clip + gun.freeshots
			gun.freeshots = 0
			sfx:Play(gun.sndshell[1], gun.sndshell[2], 0, false, gun.sndshell[3])
		end

		--pip pip
		--if true or not (gun.qdtime or gun.ksvictims) then
		if player then
			local using = gun.qdtime or gun.protime or gun.ksvictims
			local rate = (using and .3) or 1
			local shotperfill = gun.clipsize * (gun.clipperfill / rate)
			local juiceperpip = (shotperfill / 12) / math.max(.5, stat.ShotSpeed)
			player.SecondaryActiveItem.Charge = player.SecondaryActiveItem.Charge + 1

			local active = player:GetActiveItem()
			local active2 = player.SecondaryActiveItem
			local isfirst = gITM.skills[active]
			local issecond = gITM.skills[active2.Item]
			local max1 = config:GetCollectible(active).MaxCharges
			local max2 = active2 and active2.Charge

			if gun.juice >= juiceperpip then
				local jpoints = math.floor(gun.juice / juiceperpip)
				local storecharge = 0
				gun.juice = gun.juice - (jpoints * juiceperpip)
				gun.prejuice = gun.prejuice - (jpoints * juiceperpip)

				gun.activecharge = math.min(gun.activecharge + 1, (isfirst and max1) or (issecond and max2) or 0)
			end

			if isfirst and player:GetActiveCharge() ~= gun.activecharge then
				if gun.activecharge == max1 then
					sfx:Play(SoundEffect.SOUND_BATTERYCHARGE, 1, 0, false, 1)
				end
				player:SetActiveCharge(gun.activecharge)
			end
			if issecond and player.SecondaryActiveItem.Charge ~= gun.activecharge then
				local storecharge = player:GetActiveCharge()
				player:RemoveCollectible(active)
				player:SetActiveCharge(gun.activecharge)
				if gun.activecharge == max2 then
					sfx:Play(SoundEffect.SOUND_BATTERYCHARGE, 1, 0, false, 1)
				end
				player:AddCollectible(active, storecharge, false)
			end


			local shotsused = allbullets - (gun.clip + gun.chamber)
			if not gun.reloading and shotsused > 0 then
				gun.prejuice = gun.prejuice + shotsused
			end
		end

		gun.activeammomult = 1

		--judge whether gun is 'active'
		if ((not gc.shootqueue) and (gc.load or gc.shoot)) or gc.using or gun.forceshot or gun.firinghsots or (gun.specialbullet and gun.specialbullet:Exists()) then
			gun.using = true
			d.activeuntil = en.FrameCount + 30
			en.Velocity = en.Velocity * (gun.aimmovemult or 1)
		elseif gun.reloading then
			gun.using = true
			d.activeuntil = en.FrameCount + 30
		else
			gun.using = false
		end

		--chainsaw
		if gun.chainsaw then
			if gun.firedelay >= 0 and gun.clip > 0 then
				gun.sawon = true
			else
				gun.sawon = false
			end
		end

		--knife damage ammo restore
		if gun.dmgforammo then
			if gun.dmgforammo >= stat.Damage then
				if gun.clip < gun.clipsize then
					--sfx:Play(SoundEffect.SOUND_BEEP, .7, 0, false, 1)
				end
				gun.clip = math.min(gun.clipsize, gun.clip + 1)
				gun.dmgforammo = gun.dmgforammo - (stat.Damage)
			end
		end

		if gun.sndloop then
			if ((gc.load or gc.shoot) and (not gc.shootqueue)) or ((gc.shoot or gc.shootqueue) and gun.revtime and gun.rev > 0) or gun.forceshot or gun.firinghsots then
				gun.loopactive = true
			else
				gun.loopactive = false
			end
		end

		--looping gun sound
		if gun.loopactive and gun.sndloop and not gVAR.sndloopguns[tostring(gun.id)] then
			gun.sndstate = gun.sndstate or 0
			gVAR.sndloopguns[tostring(gun.id)] = gun
		end
	end
end

function l.gunSndLoop()
	local remove = false
	for i, gun in pairs(gVAR.sndloopguns) do
		if (not gun) or (gun.playerowned and not (gun == gun.myuser:GetData().mygun)) then
			if sfx:IsPlaying(gun.sndloop[1]) then
				sfx:Play(gun.sndfinish[1], gun.sndfinish[2], 0, false, gun.sndfinish[3])
			end
			sfx:Stop(gun.sndloop[1])
			remove = i
		else
			if gun.sndstate == 0 then
				sfx:Play(gun.sndstart[1], gun.sndstart[2], 0, false, gun.sndstart[3])
				gun.sndstate = 1
			end
			if gun.sndstate == 1 then
				if gun.loopactive then
					if (not sfx:IsPlaying(gun.sndloop[1])) and (gun.sndloopearly or not (sfx:IsPlaying(gun.sndstart[1]))) then
						sfx:Play(gun.sndloop[1], gun.sndloop[2], 0, true, gun.sndloop[3])
					end
				else
					sfx:Stop(gun.sndloop[1])
					sfx:Play(gun.sndfinish[1], gun.sndfinish[2], 0, false, gun.sndfinish[3])
					gun.sndstate = 0
					remove = i
				end
			end
		end
	end
	if remove then
		gVAR.sndloopguns[remove] = nil
	end
end

function l:weaponUpdate(wep)
	local d = wep:GetData()
	local gun = d.gun

	if gun and gun.chainsaw then
		d.sawing = false
		d.sawvictim = false
		if gun.sawon then
			local user = gun.myuser
			local ud = user:GetData()
			local dir = ud.guncontrol.aimdir
			local pos = wep.Position
			local rot = d.rotation
			local rotvec = Vector.FromAngle(rot):Normalized()
			local sawpos = pos + (Vector.FromAngle(rot) * 16)
			--local sawpos = pos + Vector(rotvec.X * 16, rotvec.Y * 24)
			local tippos = pos + (Vector.FromAngle(rot) * 22)
			local sawrad = 16
			local enemieshit = 0
			local shouldgore = false
			local nearest = false
			local neardist = 1000

			--d.tgt = d.tgt or Isaac.Spawn(1000, 30, 0, Vector(0, 0), Vector(0, 0), nil)
			--d.tgt.Position = sawpos

			local smoke = Isaac.Spawn(1000, 88, 0, pos + rotvec:Normalized() * -12, (rotvec * -10):Rotated(-40 + (rng:RandomFloat() * 80)), wep)
			smoke:GetSprite().Color = Color(1, 1, 1, 1, 25, 25, 25)
			smoke.PositionOffset = wep.PositionOffset

			for i, en in ipairs(Isaac.GetRoomEntities()) do
				local type = en.Type
				local variant = en.Variant
				if type == 33 or type == 292 then
					local diff = (sawpos - en.Position)
					local len = diff:Length()
					if len < en.Size + sawrad then
						en.HitPoints = 0
					end
				elseif en:IsEnemy() then
					local diff = (sawpos - en.Position)
					local len = diff:Length()
					if len < en.Size + sawrad then
						enemieshit = enemieshit + 1
						if len < neardist then
							nearest = en
							neardist = len
						end

						if en:IsVulnerableEnemy() or (type == 27 and variant == 1) then
							if en.MaxHitPoints <= 7 then
								en:TakeDamage(10, 0, EntityRef(user), 0)
							else
								en.Velocity = Lerp(en.Velocity, Vector.FromAngle(rot) * 4, .18)
								local ed = en:GetData()
								ed.sawdamagemult = ed.sawdamagemult or 1
								en:TakeDamage((.5 * ud.gunstat.Damage * ed.sawdamagemult) / ud.gunstat.MaxFireDelay, 0, EntityRef(user), 0)
								ed.sawdamagemult = Lerp(ed.sawdamagemult, .2, .15)
								if not en:IsBoss() then
									en:AddFear(EntityRef(user), 1)
								end
							end
							shouldgore = true
						elseif en:IsEnemy() and (not en:IsBoss()) and
						(type == 27 or type == 204 or type == 302 or type == 202 or type == 42 or
						type == 44 or type == 218 or type == 221 or type == 60 or
						type == 235 or type == 236 or type == 93 or type == 212) then
							ed.rockbreakdmg = (ed.rockbreakdmg or 0) + (.3 * ud.gunstat.Damage)
							if ed.rockbreakdmg >= 50 then
								--[[if type == 27 and variant == 0 then
									en:ToNPC():Morph(27, 1, 0, en:ToNPC():GetChampionColorIdx())
									ed.rockbreakdmg = 0
									shouldgore = true
								elseif type == 204 and variant == 0 then
									en:ToNPC():Morph(247, 0, 0, en:ToNPC():GetChampionColorIdx())
									ed.rockbreakdmg = 0
									shouldgore = true
								else]]
									en:Kill()
								--end
							end
						end
					end
				end
			end
			--todo: add interaction for shopkeeps, stone chests, etc

			if shouldgore then
				d.sawing = true
				gun.activeammomult = math.max(gun.activeammomult, 20)
				d.sawvictim = nearest
				if rng:RandomFloat() > .5 then
					l.goreMe(nearest, 5, rotvec * 5, 1, rng:RandomFloat() > .1)
				end
			end

			local grid = game:GetRoom():GetGridEntityFromPos(tippos)
			if grid then
				local type = grid.Desc.Type
				if type == GridEntityType.GRID_TNT
				or type == GridEntityType.GRID_POOP
				or type == GridEntityType.GRID_SPIDERWEB then
					grid:Hurt(100)
					if type == GridEntityType.GRID_SPIDERWEB then
						grid:Destroy()
					end
				elseif type >= GridEntityType.GRID_ROCK and type <= GridEntityType.GRID_ROCK_ALT and grid.State == 1 then
					gun.activeammomult = math.max(gun.activeammomult, 20)
					if rng:RandomFloat() < .15 then
						grid:Destroy()
						--grid:Update()
					elseif type == GridEntityType.GRID_ROCK and rng:RandomFloat() < .3 then
						local ind = grid:GetGridIndex()
						local var = grid:GetVariant()
						grid:Destroy()
						game:GetRoom():SpawnGridEntity(ind, type, var, 0, 0)
					end
				end
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, l.weaponUpdate, gCON.Variant.Weapon)

function l.chainsawUse(en, saw)
	--[[
	local gun = saw
	local player = en.Type == 1 and en
	local d = en:GetData()
	local stat = d.gunstat
	local dir = en.guncontrol.aim
	local dmgpos = en.guncontrol.aim

	if saw.firedelay >= 0 then
		for i, victim in ipairs(Isaac.GetRoomEntities()) do
			local type = victim.Type
			local variant = victim.Variant
			if victim:IsVulnerableEnemy() then


			end

		end
	end--]]

end

function l.gunFire(en, gun)
	local d = en:GetData()

	if gun and gun.shot then
		local stat = d.gunstat
		gVAR.shotnum = gVAR.shotnum + 1
		gun.lastshot = game:GetFrameCount()
		gun.fireevents = gun.fireevents + 1
		if gun.forcetarget then
			l.gunMove(en, gun)
		end
		local screenshake = (gun.crit and gun.screenshakecrit) or (gun.chargescale and gun.chargebonus <1 and (gun.screenshakenocharge or 0)) or gun.screenshake
		game:ShakeScreen(screenshake)

		for h, fam in ipairs(d.gunners) do
			local weapons = fam:GetData().weapons
			if weapons then
				for i = 1, 4 do
					local set = weapons[i]
					for j, wep in ipairs(set) do
						local wd = wep:GetData()
						local recoil = (wd.direction * -gun.recoil * (10 / en.Size))
						if not gun.ksvictims then
							fam.Velocity = fam.Velocity + recoil * (fam:GetData().isdrone and 2.5 or 1)
						end
						local pelletextra = (gun.pellets - math.floor(gun.pellets) > rng:RandomFloat() and 1) or 0
						local pelletnum = math.floor(gun.pellets) + pelletextra
						for k = 1, pelletnum do
							local spreadrot = 0
							local usespread = ((1 / math.max(.66, stat.ShotSpeed)) * gun.spread) + (fam:GetData().isdrone and (not gun.fanshot) and 12 or 0)
							if pelletnum > 1 then
								usespread = math.max(8, usespread)
							end
							if gun.fanshot then
								spreadrot = Lerp(usespread / -2, usespread / 2, (k - 1) / (pelletnum - 1))
							else
								spreadrot = (rng:RandomFloat() * usespread) - (.5 * usespread)
							end

							if not ((gun.fireevents % (gun.alternatinggunfire or 1) ~= (j % (gun.alternatinggunfire or 1))) or (gun.chainsaw and not wd.sawing)) then

							--if (not gun.alternatinggunfire) or (gun.fireevents % (gun.alternatinggunfire or 1) == (j % (gun.alternatinggunfire or 1))) then
								gun.weaponsshot = gun.weaponsshot + 1

								local playertear = false
								local shooter = en
								local inherit = d.tearinherit or 0
								local flame = d.mygun.sp[ESP.flamethrower]
								local laser = d.mygun.sp[ESP.laser] or (d.mygun.sp[ESP.laser2] and gun.weaponsshot % 2 == 0) or (d.mygun.sp[ESP.laserp5] and rng:RandomFloat() < .5)
								local bullet = false
								local rangebonus = gBAL.difftable[EDF.range][gSET.Difficulty] / 100

								local sd = true
								gVAR.bulletnum = gVAR.bulletnum + 1
								if en.Type == 1 then
									local vel = ((wd.direction * inherit) + (wd.direction * gun.velocity * 10)):Rotated(spreadrot)
									if flame then
										vel = vel * (.8 + (rng:RandomFloat() * .4))
										shot = Isaac.Spawn(1000, gCON.Variant.FlamethrowerFire, 0, wd.tearspawn, vel, wd.wielder)
										shot.CollisionDamage = stat.Damage
										shot.SpriteScale = Vector(gun.flamesize or 1, gun.flamesize or 1)
										sd = shot:GetData()
										sd.size = gun.flamesize or 1
										sd.friction = .1
										sd.burntime = 1--stat.Damage * (d.mygun.sp[ESP.exafterburn] and 1.25 or 2)
										sd.faderate = 1/15
									elseif laser then
										shot = shooter:FireTechLaser(wd.tearspawn, 0, vel, true, true)
										sd = shot:GetData()
										local pitch = Lerp(.88, 1/.88, 1 - (gun.clip / gun.clipsize))
										gVAR.shotsounds[gun.sndlaser[1] ] = {gun.sndlaser[2], 0, false, gun.sndlaser[3] * pitch}
										--sfx:Play(gun.sndlaser[1], gun.sndlaser[2], 0, false, gun.sndlaser[3] * pitch)
									else
										bullet = true
										if gun.chainsaw and wd.sawvictim then
											--wd.tearspawn = Lerp(wd.tearspawn, wd.sawvictim.Position, .5)
											wd.tearspawn = wd.sawvictim.Position + (Vector(wd.sawvictim.Size, 0):Rotated(rng:RandomInt(360) * rng:RandomFloat()) * .4)
										end
										shot = shooter:FireTear(wd.tearspawn - vel, vel, true, true, true)
										sd = shot:GetData()
										playertear = true
										if gun.sawspray then
											rangebonus = rangebonus * 2
											shot.FallingAcceleration = 1.9
											shot.FallingSpeed = -4 - ((rng:RandomFloat() * 6) + (d.gunstat.TearHeight / -2))
											shot.Velocity = (shot.Velocity * (.8 + (rng:RandomFloat()*.6) )):Rotated(-22 + (rng:RandomFloat() * 44))
											shot:GetSprite().Color = Color(.75 + (rng:RandomFloat() * .25), .5 + (rng:RandomFloat() * .5), .5 + (rng:RandomFloat() * .5), .75 + (rng:RandomFloat() * .25), 1, 1, 1)
											shot.Scale = shot.Scale * (1 + (rng:RandomFloat() * .5) )
										else
											shot.FallingAcceleration = -.1
											shot.FallingSpeed = 0
										end
										shot.Mass = shot.Mass * .1
										sd.knockback = d.mygun.knockback * (gun.chargebonus or 1)
										if gun.bounces then
											sd.bounces = gun.bounces
										elseif hasbit(shot.TearFlags, TearFlags.TEAR_BOUNCE) then
											sd.bounces = 1
										end

										if #gun.tf > 0 then for i, set in ipairs(gun.tf) do
											if (not set.chance) or rng:RandomFloat() < set.chance then
												local valid = false
												local cond = set.cond
												if (not cond) or cond == ECP.every then
													valid = true
												elseif (cond == ECP.even and gun.weaponsshot % 2 == 0) or (cond == ECP.odd and gun.weaponsshot % 2 == 1) then
													valid = true
												end
												if valid then
													if set.prop then
														sd[set.prop] = true
													end
													if set.variant then
														shot:ChangeVariant(set.variant)
													end
													if set.flag then
														shot.TearFlags = setbit(shot.TearFlags, set.flag)
													end
													if set.dmgmult then
														shot.CollisionDamage = set.dmgmult
													end
													if set.sizemult then
														shot.Scale = shot.Scale * set.sizemult
													end
													if set.rangemult then
														rangebonus = rangebonus * set.rangemult
													end
												end
											end
										end end

										if gun.ksvictims then
											shot.Velocity = shot.Velocity * 1.75
											rangebonus = rangebonus * 3
											shot.Scale = shot.Scale * 1.5
											shot.TearFlags = setbit(shot.TearFlags, TearFlags.TEAR_PIERCING)
										end

										local pitch = Lerp(.88, 1/.88, 1 - ((gun.clip + (gun.subclip / gun.ammoshots)) / gun.clipsize))
										gVAR.shotsounds[gun.sndshoot[1] ] = {gun.sndshoot[2], 0, false, gun.sndshoot[3] * pitch}
										--sfx:Play(gun.sndshoot[1], gun.sndshoot[2], 0, false, gun.sndshoot[3] * pitch)
									end
								elseif en:IsEnemy() then
									bullet = true
									local params = ProjectileParams()
									local vel = (wd.direction * gun.velocity * 10):Rotated(spreadrot)
									local npc = en:ToNPC()
									shot = npc:FireBossProjectiles(1, wd.tearspawn + vel, 1, params)
									sd = shot:GetData()
									shot.Position = wd.tearspawn - vel
									shot.Velocity = vel
									shot = shot:ToProjectile()
									shot.Scale = 1
									shot.FallingAccel = -.1
									shot.FallingSpeed = 0
									sd.enemy = true
									local pitch = Lerp(.88, 1/.88, 1 - (gun.clip / gun.clipsize))
									gVAR.shotsounds[gun.sndshoot[1] ] = {gun.sndshoot[2], 0, false, gun.sndshoot[3] * pitch}
									--sfx:Play(gun.sndshoot[1], gun.sndshoot[2], 0, false, gun.sndshoot[3] * pitch)
								end

								sd.spawner = en
								sd.isshot = true
								sd.shotid = gVAR.shotnum
								sd.bulletid = gVAR.bulletnum
								sd.crit = gun.crit
								sd.gun = gun
								if gun.tearvariant and shot.Variant == 0 then
									shot:ChangeVariant(gun.tearvariant)
								end
								if gun.sp[ESP.brimstone] then
									shot.CollisionDamage = .666
								end
								if fam:GetData().isdrone and not fam:GetData().isincu then
									shot.CollisionDamage = shot.CollisionDamage * gBAL.dronedmg
								end

								shot.CollisionDamage = shot.CollisionDamage * gun.damagemult
								if gun.crit and gun.critconfuse > 0 then
									sd.confuse = math.max(15, math.ceil(gun.critconfuse + ((stat.ShotSpeed - 1) * 100)))
								end
								if bullet then
									shot.Height = gCON.tearheight
									shot.Scale = shot.Scale * gun.sizemult
									if shot.Variant == 0 then
										--shot:GetSprite():ReplaceSpritesheet(1, "gfx/tears/tears_gunshot.png")
										--shot:ChangeVariant(gCON.Variant.BulletTear)
										--shot:GetSprite():Play('RegularTear4')
										--shot:GetSprite().Color = Color(.8, .8, 0, 1, 255, 255, 0)
									end
								end
								if gun.chargescale and gun.chargebonus then
									shot.CollisionDamage = shot.CollisionDamage * gun.chargebonus
									if bullet then
										shot.Scale = Lerp(shot.Scale, gun.chargebonus, .33)
									end
								end

								if d.mygun.sp[ESP.antigravity] then
									sd.antigravity = true
								end

								if wd.sawvictim then
									sd.sawvictim = wd.sawvictim
								end

								if bullet then
									local framelife = ((d.gunstat.TearHeight * rangebonus) / gun.velocity) * -1
									sd.framelife = framelife
									sd.maxframelife = framelife
									if sd.shrink then
										sd.basecollisiondamage = shot.CollisionDamage
										--shot.CollisionDamage = shot.CollisionDamage * 2
									end
									table.insert(gVAR.bullets, shot)
								elseif flame then
									local framelife = ((d.gunstat.TearHeight * rangebonus) / gun.velocity) * -1.25
									sd.lifetime = framelife
									sd.damage = shot.CollisionDamage * .02
									sd.burndamage = (shot.CollisionDamage * ((d.mygun.sp[ESP.exafterburn] and 4) or 2)) / 5-- shot.CollisionDamage / 2
									shot.CollisionDamage = 0
								elseif laser then
									shot.PositionOffset = wep.PositionOffset
									shot:SetMaxDistance((d.gunstat.TearHeight * rangebonus) * -10)
								end
							end
						end
					end
				end
			end
		end
		--failsafe for recoil mega
		en.Velocity = en.Velocity:Resized(math.min(en.Velocity:Length(), 7))
	end
end

function l.gunInventory(player)
	local d = player:GetData()
	local hascase = Isaac.GetPlayer(0):HasCollectible(gCON.Id.AttacheCase)
	local free = false
	local curgun = d.mygun
	local input = d.input
	if player:IsExtraAnimationFinished() and player:IsItemQueueEmpty() then
		free = true
	end
	--number key switching
	local key = input.numkey
	if key and hascase and free and key <= 5 then
		if not input.swap then --switching
			local nextgun = d.loadout[key]
			if nextgun ~= d.mygun then
				l.gunSwitch(player, nextgun)
			end
		elseif d.mygun and key < 5 then --setting hotkey
			local oldind = 1
			for i, oldgun in ipairs(d.loadout) do
				if d.mygun == oldgun then
					oldind = i
				end
			end
			local movegun = d.loadout[key]
			d.loadout[key] = d.mygun
			d.loadout[oldind] = movegun
			sfx:Play(snd.misc.pack, 1, 0, false, 1)
		end
	end
	--press action
	if input.actionpress then
		if d.invstate == 'closed' and hascase and free then
			d.invstate = 'open'
			if d.mygun then
				d.heldgun = true
			else
				d.heldgun = false
			end
			--l.gunSwitch(player, false)
		elseif d.invstate == 'open' then
			d.invstate = 'closed'
		end
	--press release
	elseif input.actionrelease then
		if d.invstate == 'open' and hascase then
			if d.loadoutselect then
				l.gunSwitch(player, d.loadout[d.loadoutselect])
			else
				if input.mouse and d.softselect then
					l.gunSwitch(player, d.loadout[d.softselect])
				else
					l.gunSwitch(player, l.getLastGun(d.gunhistory, d.mygun))
				end
			end
			d.invstate = 'closed'
		end
	--holding action
elseif input.action > 0 then
	end
	--inventory is open
	if d.invstate == 'open' then
		input.cantshoot = true
		--button has been held for several frames
		if input.action > gSET.QuickSwitchFrames then
			--inventory is not displayed yet
			if not d.readyguns then
				--l.gunSwitch(player, false)
				l.gunSwitch(player, false)
				player:AnimateCollectible(gCON.Id.AttacheCase, "LiftItem", "PlayerPickup")
				d.readyguns = {0, 0, 0, 0}
				sfx:Play(snd.misc.unlatch, 1, 0, false, 1)
				for i = 1, 4 do
					local refgun = d.loadout[i]
					if refgun then
						local topos = player.Position + Vector(-40, 0):Rotated((i-1) * -90)
						local fam = Isaac.Spawn(3, gCON.Variant.Weapon, 0, topos, Vector(0, 0), player)
						d.readyguns[i] = fam
						local fd = fam:GetData()
						local fs = fam:GetSprite()
						fam.PositionOffset = Vector(0, gCON.gunheight)
						fs:ReplaceSpritesheet(0, gWEP.BaseSprite[refgun.base])
						fs:LoadGraphics()
					end
				end
			end
		end
		--inventory is displayed
		if d.readyguns then
			local keywas = d.loadoutselect
			if key and key < 5 then
				d.loadoutselect = key
				if keywas and keywas ~= d.loadoutselect then
					local movegun = d.loadout[key]
					local movespr = d.readyguns[key]
					d.loadout[key] = d.loadout[keywas]
					d.readyguns[key] = d.readyguns[keywas]
					d.loadout[keywas] = movegun
					d.readyguns[keywas] = movespr
					sfx:Play(snd.misc.pack, 1, 0, false, 1)

					d.loadoutselect = nil
					d.swaptime = 15
				end
			end
			d.softselect = (not keywas) and input.mouse and (((math.floor(((input.aimdir:GetAngleDegrees()+90) / -90) + 0.5) - 1) % 4) + 1)
			for i, fam in ipairs(d.readyguns) do
				local topos = player.Position + Vector(-40, 0):Rotated((i-1) * -90)
				if fam ~= 0 then
					local somegun = d.loadout[i]
					if d.swaptime then
						d.swaptime = d.swaptime - 1
						if d.swaptime == 0 then
							d.swaptime = nil
						end
						fam.Velocity = Lerp(fam.Velocity, topos - fam.Position, .25)
					else
						fam.Velocity = topos - fam.Position
					end
					local fullalpha = (keywas == i and 1) or (d.softselect == i and 1) or false
					if somegun.clip == 0 and d.clips[somegun.ammotype] < 1 / somegun.clipsize then
						fam.Color = Color(.1, .1, .1, fullalpha or .4, 0, 0, 0)
					else
						fam.Color = Color(1, 1, 1, fullalpha or .6, 0, 0, 0)
					end
					fam.SpriteRotation = Vector(1, 0):Rotated((i * 90) + (player.FrameCount * 4)).X * 12
				end
				--show hotkey number
				gVAR.hudwepselect = gVAR.hudwepselect or {}
				local pos = Isaac.WorldToScreen(topos + Vector(0, -44))
				table.insert(gVAR.hudwepselect, {i, pos, (i == keywas) or (i == d.softselect)})
			end
		end
		--selecting a weapon
		local select = false
		if not hascase then
			l.gunSwitch(player, false)
			d.invstate = 'closed'
		elseif input.aimdir and input.aimpress then
			select = ((math.floor(((input.aimdir:GetAngleDegrees()+90) / -90) + 0.5) - 1) % 4) + 1
			local nextgun = d.loadout[select]
			if nextgun and nextgun ~= 0 then
				l.gunSwitch(player, nextgun)
				--if settings.ReloadFromInventory and d.heldgun and nextgun.id == d.lastgun.id and nextgun.clip < gunstats[nextgun.temp].clipsize then
				--	d.guncontrol.reloadqueue = true
				--end
			end
			d.invstate = 'closed'
			sfx:Play(snd.misc.pack, 1, 0, false, 1)
		end
	--inventory is closed
	elseif d.invstate == 'closed' then
		--inventory is still displayed
		if d.readyguns then
			d.loadoutselect = nil
			d.softselect = nil
			input.cantshoot = true
			player:AnimateCollectible(gCON.Id.AttacheCase, "HideItem", "PlayerPickup")
			for i, fam in ipairs(d.readyguns) do
				if fam ~= 0 then
					fam:Remove()
				end
			end
			d.readyguns = nil
		end
	end
end

function l:onPocket(card)
	if gVAR.gunmode then
		local player = Isaac.GetPlayer(0)
		local d = player:GetData()
		if pocket[card] then
			local type = pocket[card].type
			local fail = false
			if type == 'herb' then
				if card == pocket.hgy.id or card == pocket.hgry.id then
					player:AddMaxHearts(2)
				end
				if card == pocket.hg.id or card == pocket.hgy.id then
					player:AddHearts(1)
				end
				if card == pocket.hgg.id then
					player:AddHearts(3)
				end
				if card == pocket.hggg.id or card == pocket.hgr.id or card == pocket.hgry.id then
					player:AddHearts(24)
				end
				if card == pocket.hy.id or card == pocket.hr.id or card == pocket.hry.id then
					player:AddCard(card)
					fail = true
				end
			elseif type == 'ammo' then
				local slot = pocket[card].ammotype
				d.clips[slot] = gBAL.maxclips[slot]
				sfx:Play(snd.misc.equip, 1, 0, false, 1)
				for i, gun in ipairs(d.loadout) do
					if gun and gun.ammotype == slot then
						gun.clip = gun.clipsize
						if gun == d.mygun and d.mygun.clip ~= d.mygun.clipsize then
							sfx:Play(d.mygun.sndrl2[1], d.mygun.sndrl2[2], 0, false, d.mygun.sndrl2[3])
						end
					end
				end
			elseif type == 'grenade' then
				if not d.grenade then
					d.grenadearm = true
					d.grenade = card
					sfx:Play(snd.grenade.pinpull, 1, 0, false, 1)
				else
					player:AnimateCollectible(pocket[d.grenade].item, "HideItem", "PlayerPickup")
					d.grenade = false
					d.grenadearm = false
					sfx:Play(snd.misc.pack, 1, 0, false, 1)
				end
				player:SetCard(0, card)
			end
			if type == 'herb' and not fail then
				sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
			end
		else -- standard cards
			if card == Card.CARD_CLUBS_2 then
				gVAR.grenadedrop = gVAR.grenadedrop + (gBAL.grenadedropfor2clubs - (gBAL.grenadeperbomb * 2))
				local drop = l.getDropTable()
				local grenade = randWeight(drop, drop.pickgrenade)
				Isaac.Spawn(grenade[1], grenade[2], grenade[3], Isaac.GetFreeNearPosition(player.Position, 40), Vector(0, 0), nil)
			end

		end
	else
		if card == Isaac.GetCardIdByName("hg") then
			local player = Isaac.GetPlayer(0)
			player:AddHearts(1)
			sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
		end
	end
end
l:AddCallback(ModCallbacks.MC_USE_CARD, l.onPocket)

function l:take_dmg(ent, damage, flags, ref, cooldown)
	if gVAR.gunmode then
		local player = Isaac.GetPlayer(0)
		local d = player:GetData()
		local gun = d.mygun
		local rtype = ref.Type
		local damage = damage
		--local negative = false
		--player taking damage
		if ent.Type == 1 and damage > 0 then
			--cursed charge shot teleport
			local gun = ent:GetData().mygun
			if gun and gun.sp[ESP.cursetp] and gun.chamber > 0 and gun.chamber < 4 and gun.clip > 0 then
				gun.chamber = 0; gun.charge = 0
				player:UseActiveItem(44, false, false, true, false)
			end
			--debug mode
			if gSET.DebugMode and damage >= player:GetHearts() + player:GetSoulHearts() and not hasbit(flags, DamageFlag.DAMAGE_FAKE) then
				ent:TakeDamage(damage, setbit(flags, DamageFlag.DAMAGE_FAKE), ref, cooldown)
				return false
			end
		--enemy taking damage
		elseif ent:IsVulnerableEnemy() and damage > 0 and not hasbit(flags, DamageFlag.DAMAGE_FAKE) then
			--boss vuln mult
			if ent:IsBoss() then
				damage = damage * gBAL.difftable[EDF.bossvulnmult][gSET.Difficulty] / 100
			end
			--damage spread
			local spread = gSET.DamageSpread
			if spread ~= 1 then
				damage = damage * gVAR.DamageSpread
			end
			--juice
			if gun then
				gun.juice = math.min(gun.juice + (damage / player.Damage), gun.prejuice)
				gun.juicetimer = 90
			end
			--custom fire damage
			if flags == 32768 then -- I guess this is fire?
				damage = ent:GetData().burndamage or 3.5
			--other damage
			else
				if ent:IsBoss() and rtype == 2 and gun and gun.qdtime then
					damage = damage / 2
				end
				local tally = true
				local player = Isaac.GetPlayer(0)
				--MINICRIT SHIT
				local fromfam = rtype == 3 or (rtype == 2 and ref.Entity.SpawnerType == 3)
				local ed = ent:GetData()
				local deathmarks = ed.deathmarks
				if fromfam then
					local bff = player:HasCollectible(247)
					local hivemind = player:HasCollectible(248)
					--spider and fly damage balance
					if rtype == 3 then
						if ref.Variant == 73 then -- spider
							damage = gBAL.knifedamage[game:GetLevel():GetStage()] * (hivemind and 1.5 or 1)
						elseif ref.Variant == 43 then -- fly
							damage = gBAL.knifedamage[game:GetLevel():GetStage()] * (hivemind and 1 or .75)
						end
					end
				--valid for minicrit
				else
					local exdamage = 0
					--confusing laser
					if rtype == 1 and hasbit(flags, DamageFlag.DAMAGE_LASER) then
						if gun and gun.critconfuse then
							local time = math.max(15, math.ceil(gun.critconfuse + ((d.gunstat.ShotSpeed - 1) * 100)))
							ent:AddConfusion(ref, time, false)
						end
					end

					if deathmarks then
						for i, mark in ipairs(deathmarks) do
							exdamage = exdamage + (mark[1] + (damage * mark[2]))
							mark[5]:Remove()
						end

						ent:TakeDamage(exdamage, setbit(flags, DamageFlag.DAMAGE_FAKE), ref, cooldown)
						if ed.oldcolor then
							ent:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 100000, 5, false, false)
						end
						ed.deathmarks = nil
						sfx:Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 1, 0, false, .5)
						--negative = true
					end
				end
			end
			if ent:IsBoss() then
				local type = ent.Type
				if type == 406 or type == 407 or (gVAR.deliriumfight and ent:IsBoss()) then
					local ed = ent:GetData()
					ed.qdamage = (ed.qdamage or 0) + damage
					ed.lasthp = ent.HitPoints
				end
			end
			--if negative then
			ent:TakeDamage(damage, setbit(flags, DamageFlag.DAMAGE_FAKE), ref, cooldown)
			return false
			--end
		end
	end
end
l:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, l.take_dmg)

function randWeight(drop, table)
	local t = 0
	local res = false
	for i, pick in pairs(table) do
		t = t + pick[1]
	end
	local r = rng:RandomFloat() * t
	for i, pick in pairs(table) do
		r = r - pick[1]
		if r <= 0 then
			local mypick = pick[2]
			local key = pick[3]
			--yellow herb roll counter
			if key == 'yel' then
				gVAR.yellowherbs = gVAR.yellowherbs + 1
				log(gVAR.yellowherbs..' / '..gBAL.yellowherbtgt[game:GetLevel():GetStage()]..' yellow herbs dropped')
			elseif key == 'bherb' then
				gVAR.bossdropherbmult = gVAR.bossdropherbmult * .25
			elseif key == 'bammo' then
				gVAR.bossdropammomult = gVAR.bossdropammomult * .25
			elseif key == 'bnade' then
				gVAR.bossdropnademult = gVAR.bossdropnademult * .25
			end
			return((type(pick[2]) == 'string' and randWeight(drop, drop[pick[2]])) or mypick)
		end
	end
end

function l.getDropTable()
	local player = Isaac.GetPlayer(0)
	local diff = gSET.Difficulty
	local needammo = l.getNeededAmmo(player)
	local stage = game:GetLevel():GetStage()
		local yellowstage = math.max(1, stage - gBAL.difftable[EDF.yadvance][diff])
		local yellowtgt = gBAL.yellowherbtgt[yellowstage] * gBAL.difftable[EDF.yherbs][diff] / 100
	local yellowmult = ((gVAR.yellowherbs < yellowtgt) and gBAL.yellowherb.need) or gBAL.yellowherb.have
	local ammomult = gBAL.ammodropscale[stage]
		ammomult = ammomult * gBAL.difftable[EDF.ammo][diff] / 100
	local grenademult = gVAR.grenadedrop
		grenademult = Lerp(grenademult, ammomult, .5)
	local coinmult = gVAR.cashdrop
		coinmult = coinmult * gBAL.difftable[EDF.money][diff] / 100
	local herbmult = gBAL.herbdropscale[stage]
		herbmult = herbmult * gBAL.difftable[EDF.herbs][diff] / 100

	local drop = { --dropshit
		enemyherb = {{1 * herbmult, 'pickherb'},	{7, false}},
		enemycoin = {{7 * coinmult, 'pickcoin'}, {10, false}},
		enemygrenade = {{1 * grenademult, 'pickgrenade'},	{10, false}},
		dynamicammo = {
			{{1, false}, {1/gBAL.ammodrop[1], {5, 300, pocket[gPOC.ammolist[1] ].id}}}, -- pistol
			{{1, false}, {1/gBAL.ammodrop[2], {5, 300, pocket[gPOC.ammolist[2] ].id}}}, -- shotgun
			{{1, false}, {1/gBAL.ammodrop[3], {5, 300, pocket[gPOC.ammolist[3] ].id}}}, -- assault
			{{1, false}, {1/gBAL.ammodrop[4], {5, 300, pocket[gPOC.ammolist[4] ].id}}}, -- sniper
			{{1, false}, {1/gBAL.ammodrop[5], {5, 300, pocket[gPOC.ammolist[5] ].id}}}, -- magnum
			{{1, false}, {1/gBAL.ammodrop[6], {5, 300, pocket[gPOC.ammolist[6] ].id}}}, -- nato
			{{1, false}, {1/gBAL.ammodrop[7], {5, 300, pocket[gPOC.ammolist[7] ].id}}}, -- fuel
		},
		bossdrop = {
			{3 * herbmult * gVAR.bossdropherbmult, 'pickherb', 'bherb'},
			{4 * ammomult * gVAR.bossdropammomult, 'pickammo', 'bammo'},
			{3 * grenademult * gVAR.bossdropnademult, 'pickgrenade', 'bnade'},
			{.25 * coinmult, {5, 20, 2}}, -- nickel
		},
		superbossdrop = {
			{3 * herbmult, 'pickherb'},
			{12 * ammomult, 'pickammo'},
			{6 * grenademult, 'pickgrenade'},
			{.25 * coinmult, 'pickcoin'},
		},
		rushdrop = {
			{1 * herbmult, 'pickherb'},
			{3 * ammomult, 'pickammo'},
			{2 * grenademult, 'pickgrenade'},
			{.25 * coinmult, 'pickcoin'},
		},
		bosscoin = {
			{96, {5, 20, 1}}, -- penny
			{4, {5, 20, 0}}, -- random
		},
		heartdrop = {
			{10 * herbmult, 'pickherb'},
			{5 * coinmult, {5, 20, 2}}, -- nickel
			{5 * coinmult, {5, 20, 1}}, -- penny
		},
		soulheartdrop = {
			{20 * herbmult, 'pickherb'},
			{15 * ammomult, 'pickammo'},
			{10 * grenademult, 'pickgrenade'},
			{10, {5, 20, 2}}, -- nickel
			{10, {5, 20, 1}}, -- penny
			--{10, {1000, 33, 0}}, -- fly
		},
		bombdrop = {
			{10, 'pickgrenade'},
			--{9, {5, 20, 2}}, -- nickel
			--{1, {5, 20, 0}}, -- random coin
		},
		batterydrop = {
			{10, {5, 20, 0}}, -- random coin
			{3, false}, -- battery
			{5, 'whatever'},
		},
		pilldrop = {
			{10, {5, 20, 0}}, -- random coin
			{3, false}, -- pill
			{5, 'whatever'},
		},
		whatever = {
			{3 * herbmult, 'pickherb'},
			{3 * ammomult, 'pickammo'},
			{3 * grenademult, 'pickgrenade'},
			{3, {5, 20, 0}}, -- coin
			{1, {5, 20, 2}}, -- nickel
			{2, {5, 30, 0}}, -- key
		},
		pickammo = {},
		pickherb = {
			{34, {5, 300, pocket[gPOC.herblist[1] ].id}}, -- green
			{2 * yellowmult, {5, 300, pocket[gPOC.herblist[2] ].id}, 'yel'}, -- yellow (increases  yellow count when picked)
			{6, {5, 300, pocket[gPOC.herblist[3] ].id}}, -- red
		},
		pickcoin = {
			{1, {5, 20, 0}}, -- random
			{9, {5, 20, 1}}, -- penny
		},
		pickgrenade = {
			{15, {5, 300, pocket[gPOC.grenadelist[1] ].id}}, -- red
			{15, {5, 300, pocket[gPOC.grenadelist[2] ].id}}, -- green
			{20, {5, 300, pocket[gPOC.grenadelist[3] ].id}}, -- blue
		},
		fountain = {
			{1 * ammomult, 'pickammo'},
			{1 * grenademult, 'pickgrenade'},
		},
		gauntlet = {
			--{3, 'pickherb'},
			{2, 'pickgrenade'},
			--{3, {5, 20, 2}}, -- nickel
			{1, {5, 100, 0}}, -- collectible
		},
		merchherb = {
			{5, {5, 300, pocket[gPOC.herblist[1] ].id}}, -- green
			{1, {5, 300, pocket[gPOC.herblist[2] ].id}}, -- yellow
			{3, {5, 300, pocket[gPOC.herblist[3] ].id}}, -- red
		},
		merchkilled = {
			{3, {5, 350, 70}}, -- louse
			{1, {5, 350, 29}}, -- fish head
			{3, {5, 350, 53}}, -- tick
			{1, {5, 350, 56}}, -- judas' tongue
			{1, {5, 100, 246}}, -- blue map
			{1, {5, 350, 52}}, -- counterfeit penny
		},
	}

	local putammo = false
	for i = 1, 7 do if needammo[i] then
		putammo = true
		table.insert(drop.pickammo, drop.dynamicammo[i][2])
	end end
	if not putammo then
		table.insert(drop.pickammo, {1, {5, 20, 2}}) -- nickel
	end
	return drop
end

function l.leon_drop(en)
	if en:IsEnemy() then
		local mydrops = en:GetData().drops
		if mydrops then
			for i, spawn in ipairs(mydrops) do
				if spawn then
					local angle = math.random(360)
					Isaac.Spawn(spawn[1], spawn[2], spawn[3], en.Position, Vector((#mydrops * 4) * (1 + (rng:RandomFloat() * .3)), 0):Rotated((360 / #mydrops) + math.random(30) + angle), en)
				end
			end
		end
		local mycoins = en:GetData().coins
		if mycoins then
			for i, spawn in ipairs(mycoins) do
				if spawn then
					local angle = math.random(360)
					Isaac.Spawn(spawn[1], spawn[2], spawn[3], en.Position, Vector((#mycoins * 1.25) * (1 + (rng:RandomFloat() * .3)), 0):Rotated((360 / #mycoins) + math.random(30) + angle), en)
				end
			end
		end
	end
end

function l:ent_killed(en)
	if gVAR.gunmode then
		local player = Isaac.GetPlayer(0)
		local d = player:GetData()
		l.leon_drop(en)
		if d.mygun then
			if d.mygun.qdtime then
				d.mygun.qdtime = gBAL.skill.quaddamageframes
			end
			if d.mygun.protime then
				d.mygun.protime = gBAL.skill.promodeframes
			end
			if d.mygun.freeshotsfromkill then
				d.mygun.freeshots = math.min(d.mygun.clipsize, d.mygun.freeshots + d.mygun.freeshotsfromkill)
			end
			if d.mygun.deadeye then

			end
			--[[if d.mygun.refundableshots then
				d.mygun.clip = math.min(d.mygun.clipsize, d.mygun.clip + 1)
				d.mygun.refundableshots = d.mygun.refundableshots - 1
				if d.mygun.refundableshots == 0 then
					d.mygun.refundableshots = nil
				end
			end--]]
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, l.ent_killed)

function l:tear_collision(tear, ent, low)
	if gVAR.gunmode then
		local sd = tear:GetData()
		if sd.isshot then
			local entype = ent.Type
			local vel = tear.Velocity
			local ed = ent:GetData()
			local gun = sd.gun
			if sd.sawvictim then
				if sd.sawvictim.InitSeed == ent.InitSeed then
					return true
				end
			end
			if sd.crit and ent.Type == 292 then
				ent.HitPoints = 0
			end
			if entype ~= 33 and entype ~= 292 and ent:IsVulnerableEnemy() and not tear.StickTarget then
				local dmg = tear.CollisionDamage
				if ed.goreby ~= sd.bulletid then
					l.goreMe(ent, dmg, vel, .5)
					ed.goreby = bulletid
				end
			end
			if sd.confuse then
				if ent:IsVulnerableEnemy() then
					ent:AddConfusion(EntityRef(tear), sd.confuse, false)
				end
			end
			local canhit = true
			if tear.StickTarget then
				canhit = false
			elseif hasbit(tear.TearFlags, TearFlags.TEAR_PIERCING) then
				canhit = true
				if (not gun.multiknock) and (ed.hitbullet and sd.bulletid and ed.hitbullet == sd.bulletid) then
					canhit = false
				end
			end
			if canhit and not (gun.vanillaknockback or sd.confuse) then
				local usemass = math.min(gun.strongknock and 40 or 65, math.max(ent.Mass, 5))
				ent.Velocity = Lerp(ent.Velocity, vel * sd.knockback * gCON.knockback, math.min(.5, 100 / usemass))
			end
			if (sd.bounces or 0) > 0 then
				sd.bounces = sd.bounces - 1
				sd.framelife = sd.maxframelife
			end
			ed.hitbullet = sd.bulletid or -1
			ed.hitshot = sd.shotid or -1
			if gun.vanillaknockback then
				tear.Mass = tear.Mass * 10
			else
				return nil
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, l.tear_collision)

function l:entity_remove(ent)
	if gVAR.gunmode then
		local type = ent.Type
		if type == 2 then
			ed = ent:GetData()
			if ed.crit then
				grid = game:GetRoom():GetGridEntityFromPos(ent.Position)
				if grid then
					if grid.Desc.Type == GridEntityType.GRID_TNT then
						grid:Hurt(10)
					end
				end
			end
			if ed.rpg then
				local player = Isaac.GetPlayer(0)
				Isaac.Explode(ent.Position, ed.spawner, 25)
				game:ShakeScreen(30)
				sfx:Stop(snd.shoot.flame.loop, 1, 0, false, 1)
				if (ent.Position - player.Position):Length() < 75 then
					log('rocket hit player ..           dumbass')
					player:TakeDamage(4, DamageFlag.DAMAGE_EXPLOSION, EntityRef(ed.spawner), 0)
				end
				for i = 0, 7 do
					Isaac.Explode(ent.Position + Vector(45, 0):Rotated(i * (360 / 7)), ed.spawner, 25)
				end
				for i, enemy in ipairs(Isaac.FindInRadius(ent.Position, 115, 1<<3)) do
					if enemy:IsBoss() then
						local dodmg = math.min(2000, math.max(100, enemy.MaxHitPoints * .35))
						local prehp = enemy.HitPoints
						enemy:TakeDamage(dodmg, DamageFlag.DAMAGE_EXPLOSION, EntityRef(ed.spawner), 0)
						enemy.HitPoints = prehp - dodmg
					else
						enemy:TakeDamage(100, DamageFlag.DAMAGE_EXPLOSION, EntityRef(ed.spawner), 0)
						enemy:Kill()
					end
				end
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, l.entity_remove)

function l.markForDeath(victim, dat)
	local add = dat.add or 0
	local mult = dat.mult or 0
	local id = dat.id or false
	local cond = dat.cond or false

	local d = victim:GetData()

	if not d.deathmarks then
		local oldcolor = victim:GetColor()
		if oldcolor.R == 1 and oldcolor.G == 1 and oldcolor.B == 1 then
			d.oldcolor = oldcolor
			victim:SetColor(Color(1, .8, .8, 1, 90, 0, 1), 10000, 5, false, false)
		end
		d.deathmarks = {}
	end

	local canadd = true
	if id and #d.deathmarks > 0 then
		for i, mark in ipairs(d.deathmarks) do
			if id == mark.id then
				canadd = false
			end
		end
	end

	if canadd then
		local ent = Isaac.Spawn(1000, gCON.Variant.Minicrit, 0, victim.Position, Vector(0, 0), victim):ToEffect()
		ent.SpawnerEntity = victim
		ent:FollowParent(victim)
		ent.SpriteOffset = Vector(0, -victim.Size * 2.4)
		ent:GetSprite().Scale = Vector(0, 0)

		if #d.deathmarks > 0 then
			for i, mark in ipairs(d.deathmarks) do
				mark[5].SpriteOffset = Vector(0, mark[5].SpriteOffset.Y - 20)
			end
		end

		local newmark = {add, mult, id, cond, ent}
		table.insert(d.deathmarks, newmark)
	end
end

function l:minicrit_effect(ent)
	ent.RenderZOffset = 100
	if ent.Parent == nil or ent.Parent and not ent.Parent:Exists() then
		ent:Remove()
	else
		--ent.SpriteOffset = Vector(0, (-ent.Parent.Size * 3.2) + Vector(0, 3):Rotated(ent.FrameCount * 20).X)
		if ent.FrameCount % 6 < 3 then
			ent:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 100, 10, false, false)
		else
			ent:SetColor(Color(1, 1, 1, 1, 25, 15, 15), 100, 10, false, false)
		end
		local scale = math.min(1, ent.FrameCount / 5)
		ent:GetSprite().Scale = Vector(scale, scale)
	end
end
l:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, l.minicrit_effect, gCON.Variant.Minicrit)

function l:leon_collectible(ent)
	local d = ent:GetData()
	local s = ent:GetSprite()
	local player = ent.Parent
	local id = ent.SubType
	local type = gITM.type[id]

	if not d.init then
		d.init = true
		if type == EIT.mod then
			s:ReplaceSpritesheet(1, config:GetCollectible(id).GfxFileName)
		elseif type == EIT.gun then
			--s:ReplaceSpritesheet(3, gWEP.BaseSprite[gunstat[temp].base])
		end
		s:LoadGraphics()
	end

	if ent.FrameCount <= 1 then
		s:Play("Empty")
	else
		if type == EIT.mod then
			s:Play("PlayerPickupPack")
		elseif type == EIT.gun then
			s:Play("PlayerPickupPack2")
		end
		ent.PositionOffset = Vector(0, -36)
		ent.Position = player.Position + Vector(0, 1)
		ent.Velocity = player.Velocity
	end

	if ent.FrameCount == 20 then
		sfx:Play(snd.misc.pack, 1, 0, false, 1)
	end

	if s:IsFinished("PlayerPickupPack") or s:IsFinished("PlayerPickupPack2") then
		player:GetData().liftitem = nil
		ent:Remove()
	end
end
l:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, l.leon_collectible, gCON.Variant.DynamicCollectible)

function l:input_action(ent, hook, act)
	if gVAR.gunmode then
		if ent and ent.Type == 1 and ent:GetData().input then
			local input = ent:GetData().input
			if mmenuvar.open then
				if hook < 2 then
					return false
				else
					return 0
				end
			end
			if act >= 4 and act <= 7 then
				if input.mode == 0 then
					if not ent:GetData().idle then
						if hook < 2 then
							return input.face[act - 3] ~= 0
						else
							return input.face[act - 3]
						end
					end
				end
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_INPUT_ACTION, l.input_action)

--CACHE EVAL
function l:evaluate_cache(player,flag)
	--stat mods
	if gVAR.gunmode then
		local pd = player:GetData()
		local gs = pd.mygun
		local ps = pd.gunstat
		local stats = pd.charstats or gCON.basestats-- (player:GetPlayerType() == gCON.Leon.Type and gCON.Leon.Stats) or gCON.basestats
		local gspeed = 0
		if pd.loadout then for i, gun in ipairs(pd.loadout) do
			if gun then
				gspeed = gspeed + (gun.gspeed or 0)
			end
		end end
		if gs then
			if flag == CacheFlag.CACHE_DAMAGE then
				player.Damage = (stats.Damage + player.Damage + gs.as.damage) * gs.ms.damage
				ps.Damage = player.Damage
			elseif flag == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = (player.MoveSpeed + stats.MoveSpeed + gs.as.movespeed + gspeed) * gs.ms.movespeed
			elseif flag == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = math.max(1, math.floor(.5 + ((player.MaxFireDelay + stats.MaxFireDelay + gs.as.maxfiredelay) * gs.ms.maxfiredelay)))
				ps.MaxFireDelay = player.MaxFireDelay
			elseif flag == CacheFlag.CACHE_SHOTSPEED then
				player.ShotSpeed = (player.ShotSpeed + stats.ShotSpeed + gs.as.shotspeed) * gs.ms.shotspeed
				ps.ShotSpeed = player.ShotSpeed
			elseif flag == CacheFlag.CACHE_RANGE then
				player.TearHeight = math.min(-7.5, ((player.TearHeight + stats.TearHeight) - gs.as.range) * gs.ms.range)
				ps.TearHeight = player.TearHeight
			elseif flag == CacheFlag.CACHE_LUCK then
				player.Luck = math.floor(.5 + ((player.Luck + stats.Luck + gs.as.luck) * gs.ms.luck))
				ps.Luck = player.Luck
			elseif flag == CacheFlag.CACHE_FAMILIARS then
				if pd.perks and pd.perks.superincubus then
					for i, gunner in ipairs(pd.gunners) do
						if gunner.Type == 3 and gunner.Variant == gCON.Variant.Drone then
							if gunner:GetData().isincu then
								gunner.Variant = 80
							end
						end
					end
				end
			end
		else
			if flag == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + stats.Damage
			elseif flag == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + stats.MoveSpeed + gspeed
			elseif flag == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay + stats.MaxFireDelay
			elseif flag == CacheFlag.CACHE_SHOTSPEED then
				player.ShotSpeed = player.ShotSpeed + stats.ShotSpeed
			elseif flag == CacheFlag.CACHE_RANGE then
				player.TearHeight = player.TearHeight + stats.TearHeight
			elseif flag == CacheFlag.CACHE_LUCK then
				player.Luck = player.Luck + stats.Luck
			end
		end
	elseif player:GetPlayerType() == gCON.Leon.Type then
		local stats = gCON.Leon.Stats
		if flag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + stats.Damage
		elseif flag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + stats.MoveSpeed
		elseif flag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay + stats.MaxFireDelay
		elseif flag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + stats.ShotSpeed
		elseif flag == CacheFlag.CACHE_RANGE then
			player.TearHeight = player.TearHeight + stats.TearHeight
		elseif flag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + stats.Luck
		end
	end
end
l:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, l.evaluate_cache)

function l:onItemUse(type)
	if gVAR.gunmode then
		local player = Isaac.GetPlayer(0)
		local d = player:GetData()
		local gun = d.mygun
		if gITM.skills[type] then
			if gun then
				gun.juice = 0
				gun.prejuice = 0
				gun.activecharge = 0
			end
			if type == gCON.Id.WSSight then
				log("It's MID DAY!!!")
				--local mustsort = Isaac.CountEnemies() > 12
				local victims = {}
				for i, en in ipairs(Isaac.GetRoomEntities()) do
					if en:IsEnemy() and en.HitPoints > 0 and en:ToNPC().CanShutDoors and not en:ToNPC().ParentNPC then
						table.insert(victims, en)
					end
				end
				for i, en in ipairs(victims) do
					l.markForDeath(en, {mult = gun.clipsize / 3})
				end
				if #victims > 0 then
					gun.ksvictims = victims
				else
					--local item = config:GetCollectible(type) -- todo: check this with battery
					--player:SetActiveCharge(item.MaxCharges)
				end
			elseif type == gCON.Id.WSQuad then
				gun.ms.damage = gun.ms.damage * 3
				local needspeed = math.max(0, 1.5 - player.MoveSpeed)
				gun.qdspeed = needspeed
				gun.as.movespeed = gun.as.movespeed + needspeed
				gun.qdtime = gBAL.skill.quaddamageframes
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				player:EvaluateItems()
			elseif type == gCON.Id.WSPro then
				gun.ms.maxfiredelay = gun.ms.maxfiredelay * .5
				gun.reloadbullet = gun.reloadbullet * .5
				gun.protime = gBAL.skill.promodeframes
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
				player:EvaluateItems()
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_USE_ITEM, l.onItemUse)

function l.getNeededAmmo(player)
	gVAR.needammo = {false, false, false, false, false, false, false, false}
	local hadtrue = false

	local loadout = player:GetData().loadout
	if loadout then
		for i, wep in ipairs(loadout) do
			if wep and not wep.noammo then
				gVAR.needammo[wep.ammotype] = true
				hadtrue = true
			end
		end
	end

	if not hadtrue then
		gVAR.needammo[1] = true
	end

	return gVAR.needammo
end

function l:newRoom()
	if gVAR.gunmode then
		local player = Isaac.GetPlayer(0)
		local level = game:GetLevel()
		local room = game:GetRoom()
		local roomtype = room:GetType()
		local stage = level:GetStage()
		local ps = player:GetSprite()
		local pd = player:GetData()
		--update screen size
		if room:GetRoomShape() == 1 then
			screensize = Isaac.WorldToScreen(game:GetRoom():GetCenterPos()) * 2
		end
		--fixes costume desync bug usually I think
		local sframe = player:GetSprite():GetFrame()
		if ps:IsPlaying("WalkRight") then
			player:GetSprite():SetFrame("WalkRight", sframe)
		elseif ps:IsPlaying("WalkDown") then
			player:GetSprite():SetFrame("WalkDown", sframe)
		elseif ps:IsPlaying("WalkLeft") then
			player:GetSprite():SetFrame("WalkLeft", sframe)
		elseif ps:IsPlaying("WalkUp") then
			player:GetSprite():SetFrame("WalkUp", sframe)
		end
		--check boss rush
		gVAR.inbossrush = roomtype == RoomType.ROOM_BOSSRUSH
		--first visit
		if room:IsFirstVisit() then
			gVAR.bossdropherbmult = 1
			gVAR.bossdropammomult = 1
			gVAR.bossdropnademult = 1
			local drop = l.getDropTable()
			if roomtype == RoomType.ROOM_DEFAULT then
				--normal room enemy drops
				local enemies = {}
				for i, en in ipairs(Isaac.GetRoomEntities()) do
					local type = en.Type
					if en:IsEnemy() and en.HitPoints >= 0 and type ~= 33 and type ~= 292 then
						if en.HitPoints >= 7 and en:ToNPC().Pathfinder:HasPathToPos(player.Position, true) then
							table.insert(enemies, en)
						end
					end
				end

				if #enemies > 0 then
					local sizes = {1, .5, .5, 1.5, 1, 1.5, 1, 2, 1.5, 1.5, 1.5, 1.5}
					--1x1, ih, iv, 1x2, iiv, 2x1, iih, 2x2, ltl, ltr, lbl, lbr
					local size = sizes[room:GetRoomShape()]
					local rolls = 2 * size
					local roomdrops = {}
					local roomcoins = {}

					local needammo = l.getNeededAmmo(player)
					if not gVAR.ammodue then
						gVAR.ammodue = {}
						for i = 1, 7 do
							table.insert(gVAR.ammodue, (gBAL.ammodrop[i]/2) * ((1 - gBAL.ammodropvar) + (rng:RandomFloat() * gBAL.ammodropvar * 2)))
						end
					end

					local ammodropped = false
					for i = 1, rolls do
						table.insert(roomdrops, randWeight(drop, drop.enemyherb) or nil)
						table.insert(roomdrops, randWeight(drop, drop.enemygrenade) or nil)
						table.insert(roomcoins, randWeight(drop, drop.enemycoin) or nil)
						for j = 1, 7 do	if needammo[j] then
							gVAR.ammodue[j] = gVAR.ammodue[j] - ((size * gBAL.ammodropscale[stage]) * gBAL.difftable[EDF.ammo][gSET.Difficulty] / 100)
							if gVAR.ammodue[j] <= 0 and not ammodropped then
								ammodropped = true
								table.insert(roomdrops, {5, 300, pocket[gPOC.ammolist[j]].id})
								local add = (gBAL.ammodrop[j] * ((1 - gBAL.ammodropvar) + (rng:RandomFloat() * gBAL.ammodropvar * 2)))
								gVAR.ammodue[j] = gVAR.ammodue[j] + add
							end
						end	end
					end

					if #roomdrops > 0 then for i, roomdrop in ipairs(roomdrops) do
						local enemy = enemies[rng:RandomInt(#enemies)+1]
						local rot = rng:RandomFloat() * 360
						local attach = enemy:GetData().carry or enemy
						local carryme = Isaac.Spawn(roomdrop[1], roomdrop[2], roomdrop[3], attach.Position + (Vector(15, 0):Rotated(rng:RandomFloat())), Vector(0, 0), attach)
						carryme:GetData().daddy = attach
						attach:GetData().carry = carryme
					end end

					if #roomcoins > 0 then for i, roomcoin in ipairs(roomcoins) do
						local enemy = enemies[rng:RandomInt(#enemies)+1]
						if not enemy:GetData().coins then
							enemy:GetData().coins = {}
						end
						table.insert(enemy:GetData().coins, roomcoin)
					end end
				end

				--boss fountain
				local fountains = gBAL.difftable[EDF.fountain][gSET.Difficulty]
				if fountains > 0 then for d = 1, fountains do
					for i = 0, 7 do
						local door = room:GetDoor(i)
						if door and door.TargetRoomType == RoomType.ROOM_BOSS then
							local fountain = true
							if fountains > 1 and d == fountains then
								fountain = randWeight(drop, drop.pickherb)
							else
								fountain = randWeight(drop, drop.fountain)
							end
							Isaac.Spawn(fountain[1], fountain[2], fountain[3], Isaac.GetFreeNearPosition(door.Position, 80), Vector(0, 0), nil)
						end
					end
				end end

			--gauntlet temptation
			elseif roomtype == RoomType.ROOM_CHALLENGE then
				local center = room:GetCenterPos()
				local fountain = randWeight(drop, drop.gauntlet)
				Isaac.Spawn(fountain[1], fountain[2], fountain[3], Isaac.GetFreeNearPosition(center, 40), Vector(0, 0), nil)
			--boss drops
			elseif roomtype == RoomType.ROOM_BOSS or roomtype == RoomType.ROOM_MINIBOSS then
				local mini = roomtype == RoomType.ROOM_MINIBOSS
				gVAR.bossdrops = {}; gVAR.bosscoins = {}
				gVAR.superboss = false
				local dropnum = ((mini and 1) or 2)
				if stage > 3 then
					dropnum = dropnum + rng:RandomInt(2)
				end
				if roomtype == RoomType.ROOM_BOSS and stage == 6 then
					dropnum = dropnum + 2
				end
				local coins = ((mini and 5) or 8) + rng:RandomInt(3)
				gVAR.bosssteals = math.max(0, (mini and 1) or (dropnum - 1)); gVAR.bossstealables = gVAR.bosssteals
				for i = 1, dropnum do
					local mydrop = randWeight(drop, drop.bossdrop)
					table.insert(gVAR.bossdrops, mydrop)
				end
				for i = 1, coins do
					table.insert(gVAR.bosscoins, randWeight(drop, drop.bosscoin))
				end
			end
		end
		if roomtype == RoomType.ROOM_BOSS and room:IsFirstVisit() then
			gVAR.knifespeedbonusready = true
			gVAR.isbosstitle = true
		else
			gVAR.knifespeedbonusready = false
		end
		--shit
		--player:GetEffects():AddCollectibleEffect(21, false)
		gVAR.lastbosspos = room:GetCenterPos()
		--pd.fireslash = false
		gVAR.deliriumfight = false
		gVAR.roomcollectibles = {}
		gVAR.timerpause = false
		gVAR.merchantent = nil
		gVAR.roomchanges = gVAR.roomchanges + 1
		gVAR.roomchanged = true
		gVAR.roomframes = 0
		gVAR.pickupfade = false

		gVAR.flashlightcolor = l.getFlashlightColor()

		if gVAR.levellimbo then
			log('got par time for '..stage)
			--gVAR.partime = gBAL.partime[stage] * 60 * 30 * ((gVAR.islabyrinth and gBAL.labyrinthtime) or 1)
			--gVAR.levellimbo = false
			if gVAR.islabyrinth then
				gVAR.partime = gBAL.partimel[stage] * 60 * 30
			else
				gVAR.partime = gBAL.partime[stage] * 60 * 30
			end
			gVAR.stagetime = 0
			gVAR.levellimbo = false
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, l.newRoom)

function l:preRoomEntity(type, variant, subtype, gridindex, seed)
	if gVAR.gunmode then
		if game:GetRoom():IsFirstVisit() then
			if type == 1000 then
				if rng:RandomFloat() < gBAL.gridreplace.rocktnt then
					return {1300, 0, 0}
				end
			elseif type == 1500 then
				if rng:RandomFloat() < gBAL.gridreplace.poopblackpoop then
					return {1497, 0, 0}
				elseif rng:RandomFloat() < gBAL.gridreplace.poopwhitepoop then
					return {1498, 0, 0}
				end
			end
		end
		if game:GetRoom():GetType() == RoomType.ROOM_SHOP then
			return {273, 0, 0}
		end
	end
end
l:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, l.preRoomEntity)

function l:evaluateCurses(curses)
	if gVAR.gunmode then
		local stage = game:GetLevel():GetStage()
		vanillalabyrinth = hasbit(curses, LevelCurse.CURSE_OF_LABYRINTH)
		log('vanilla labyrinth '..(vanillalabyrinth and 'true' or 'false'))
		--if stage ~= 8 and stage ~= 9 and stage ~= 12 then
		if stage < 8 then
			curses = LevelCurse.CURSE_OF_LABYRINTH
		else
			curses = 0
		end
		local darkchances = {0, .3, 1}

		if rng:RandomFloat() < darkchances[gSET.CurseOfDarkness] or (gSET.CurseOfDarkness > 1 and (stage == 11 or stage == 12)) then
			curses = LevelCurse.CURSE_OF_DARKNESS + LevelCurse.CURSE_OF_LABYRINTH
		end
		return (curses)
	else
		return (0)
	end
end
l:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, l.evaluateCurses)

function l:npcDeath(npc)
	if gVAR.gunmode then
		local roomtype = game:GetRoom():GetType()
		if gVAR.bossdrops and npc:IsBoss() and (roomtype == RoomType.ROOM_BOSS or roomtype == RoomType.ROOM_MINIBOSS or roomtype == RoomType.ROOM_BOSSRUSH) then
			local bosscount = Isaac.CountBosses()
			if bosscount <= 1 then
				for i, reward in ipairs(gVAR.bossdrops) do
					local spos = gVAR.lastbosspos
					local angle = math.random(360)
					local reward = Isaac.Spawn(reward[1], reward[2], reward[3], Isaac.GetFreeNearPosition(spos, 0), Vector(5 * (1 + (rng:RandomFloat() * .3)), 0):Rotated((360 / #gVAR.bossdrops) + math.random(30) + angle), nil)
					--reward.GridCollisionClass = 6
				end
				for i, reward in ipairs(gVAR.bosscoins) do
					local spos = gVAR.lastbosspos
					local angle = math.random(360)
					local reward = Isaac.Spawn(reward[1], reward[2], reward[3], Isaac.GetFreeNearPosition(spos, 0), Vector(8 * (1 + (rng:RandomFloat() * .3)), 0):Rotated((360 / #gVAR.bosscoins) + math.random(30) + angle), nil)
					--reward.GridCollisionClass = 6
				end
				gVAR.bossdrops = false
				gVAR.bosscoins = false
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, l.npcDeath)

function l:useActive()
	if gVAR.gunmode then
		local player = Isaac.GetPlayer(0)
		local d = player:GetData()
		if d.perks and d.perks.superincubus then
			for i, gunner in ipairs(d.gunners) do
				if gunner.Type == 3 and gunner.Variant == gCON.Variant.Drone then
					if gunner:GetData().isincu then
						gunner.Variant = 80
					end
				end
			end
		end
	end
end
l:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, l.useActive)

function l:npcInit(npc)
	if gVAR.gunmode then
		if npc.CollisionDamage > 0 then
			npc:GetData().CollisionDamage = npc.CollisionDamage
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_NPC_INIT, l.npcInit)

function l.newLevelShit()
	local level = game:GetLevel()
	local stage = level:GetStage()
	local stagetype = level:GetStageType()
	if stage ~= 1 then
		l.saveData()
	end
	--merchant and his shit
	if game:GetLevel():GetStage() ~= 1 then
		local center = game:GetRoom():GetCenterPos()
		local topdoor = game:GetRoom():GetDoor(1)
		local tx = topdoor and -80 or 0

		if gSET.Difficulty < 3 or not gVAR.merchantkilled then
			trader = Isaac.Spawn(6, gCON.Variant.Merchant, 0, Isaac.GetFreeNearPosition(center + Vector(tx, -80), 0), Vector(0, 0), nil)
			music:Fadein(Isaac.GetMusicIdByName("Safety"), 0)
			music:UpdateVolume()
			Isaac.Spawn(33, 2, 0, Isaac.GetFreeNearPosition(center + Vector(200, -80), 0), Vector(0, 0), nil)
			Isaac.Spawn(33, 2, 0, Isaac.GetFreeNearPosition(center + Vector(-200, -80), 0), Vector(0, 0), nil)
			Isaac.Spawn(33, 2, 0, Isaac.GetFreeNearPosition(center + Vector(200, 80), 0), Vector(0, 0), nil)
			Isaac.Spawn(33, 2, 0, Isaac.GetFreeNearPosition(center + Vector(-200, 80), 0), Vector(0, 0), nil)
		end
	end
	--things
	level:ApplyCompassEffect(true)
	--variables
	gVAR.bossdrops = false
	gVAR.bosscoins = false
	gVAR.waslabyrinth = gVAR.islabyrinth
	gVAR.islabyrinth = hasbit(level:GetCurses(), LevelCurse.CURSE_OF_LABYRINTH)

	gVAR.beatlasttimer = (stage == 1 and true) or (gVAR.stagetime < gVAR.partime)
	gVAR.levellimbo = true
	gVAR.isstagetransition = true

	gVAR.flashlightcolor = l.getFlashlightColor()
end

function l:newLevel()
	if gVAR.gunmode then
		l.newLevelShit()
	end
end
l:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL , l.newLevel)

function l:gameExit(shouldsave)
	if gVAR.gunmode and shouldsave then
		l.saveData()
	end
end
l:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, l.gameExit)

function l.saveData()
	local debugwas = gSET.DebugMode
	gSET.DebugMode = false
	local gamesave = {
		settings = gSET,
	}
	Isaac.ConsoleOutput('Gun mode data saved\n')
	Isaac.SaveModData(l, json.encode(gamesave))
	gSET.DebugMode = debugwas
	--[[
	local player = Isaac.GetPlayer(0)
	local d = player:GetData()
	local playerdata = {
		loadout = d.loadout,
		shotsfired = d.shotsfired,
	}
	local saveguns = {}
	for i, gun in ipairs(guns) do
		if gun.persistent then
			table.insert(saveguns, gun)
		end
	end
	local gamesave = {
		guns = guns,
		player = playerdata,
	}
	Isaac.SaveModData(l, json.encode(gamesave))--]]
end

function l.loadData(continue)
	local debugwas = gSET.DebugMode
	if Isaac.HasModData(l) then
		local gamesave = json.decode(Isaac.LoadModData(l))
		for i, set in pairs(gamesave.settings) do
			gSET[i] = set
		end
		--gSET = gamesave.settings
		gSET.DebugMode = debugwas
		Isaac.ConsoleOutput('Gun mode data loaded\n')
	else
		Isaac.ConsoleOutput('No gun mode data detected\n')
	end

	--[[
	local player = Isaac.GetPlayer(0)
	local d = player:GetData()

	local gamesave = json.decode(Isaac.LoadModData(l))
	guns = gamesave.guns
	d.loadout = gamesave.player.loadout
	d.shotsfired = gamesave.player.shotsfired]]
end

function l.gunHud(gamelayer)
	if gVAR.gunmode then
		local player = Isaac.GetPlayer(0)
		local d = player:GetData()
		local gun = d.mygun
		local room = game:GetRoom()
		local level = game:GetLevel()
		local stage = level:GetStage()
		local coverhud = game:IsPaused() and (gVAR.isbosstitle or gVAR.isstagetransition)
		local hudopacity = ((gSET.HudOpacity - 1) * .25) or .5

		local KL_white = KColor(1, 1, 1, hudopacity, 0, 0, 0)
		local KL_ltred = KColor(1, .85, .85, hudopacity, 0, 0, 0)
		local KL_ltgreen = KColor(.78, 1, .78, hudopacity, 0, 0, 0)

		--CLIP AND BULLET HUD
		if gun and gamelayer and (not coverhud) and not (gun.noammo) then
			local pos = 'player' --gSET.HudPos
			local large = (pos == 'top' or pos == 'bottom')
			local scale = (large and 1) or .5
			local rot = 0
			local maxalpha = 1--gSET.HudMaxOpacity
			local scenter = getScreenCenterPosition()
			local ppos = Isaac.WorldToScreen(Isaac.GetPlayer(0).Position)
			local xx = 0
			local yy = 0
			local x1 = 0
			local y1 = 0
			local yo = 0
			local xo = 0
			local row = 0
			local reload = gun.reloading
			local ww = ((ammo[gun.ammotype].w) + 2) / 2
			local hh = ((ammo[gun.ammotype].h) + 2) / 2
			local spr = gun.ammotype
			local bullet = CSP.Bullet
			local frames = game:GetFrameCount()
			local rowsize = 0
			local width = 0

			--CLIP AND BULLETS
			local clip = math.max(gun.clip, gun.freeshots)-- * gun.ammoshots
			local chamber = gun.chamber-- * gun.ammoshots
			local clipsize = gun.clipsize-- * gun.ammoshots
			local bpct = 1 / gun.clipsize
			local resammo = math.floor((d.clips[gun.ammotype] / bpct) + .001)
			local maxclips = gBAL.maxclips[gun.ammotype]
			local curclips = math.min(d.clips[gun.ammotype], maxclips)
			local fullclips = math.floor(curclips + .001)
			local drawclips = (resammo > 0 and math.ceil(curclips + 1)) or 0
			local refunds = gun.refundableshots or 0
			local freeshots = gun.freeshots
			local nonfree = gun.clip-- * gun.ammoshots
			--local efclip = clip + freeshots
			--local efclipsize = clipsize + freeshots
			local numicons = clipsize + drawclips --efclipsize + drawclips
			local draw = true

			rowsize = math.min(numicons, math.floor(gCON.ammodisplaywidth / ww))
			rownum = math.ceil(numicons / rowsize)
			width = rowsize * ww
			x1 = ppos.X - (width / 2) + (ww / 2)
			y1 = (ppos.Y - (rownum * hh)) - 34

			for p = 1, 2 do
				local black = p == 1
				bullet:SetFrame('bullet', spr - 1 + (black and 7 or 0))
				bullet.Scale = Vector(.5, .5)
				bullet.Color = Color(1, 1, 1, maxalpha, 0, 0, 0)
				local inp = 0
				for i = 0, numicons - 1 do
					local inum = i - (clipsize + 1)
					local bico = i < clip+chamber+refunds--math.min(clipsize, clip+chamber+refunds)
					local bclrr = 1; local bclrg = 1; local bclrb = 1; local bclra = 1
					xx = x1 + (((i - inp) * ww) % width)
					yy = y1 + (hh * math.floor(i / rowsize)) + (bico and 0 or -.5)
					local ischamber = i >= clip and i < clip + chamber
					yo = (reload and (frames % 4 == i % 4) and bico and -.5 or 0) + ((ischamber and -.5) or 0)
					if i >= clip and i < clip+refunds and i < clipsize then
						bclrr = .5; bclrg = .5; bclrb = .5; bclra = .35
					end
					if i < freeshots then
						bclrr = .25; bclrg = 1; bclrb = .25
						if i >= nonfree then
							bclra = .25
						end
					end
					if i == math.ceil(clip + chamber + refunds) then
						bullet:SetFrame('icon', (black and 23) or (14 + spr - 1))
					end
					if i == clipsize then
						draw = false
						if xx == x1 then
							inum = inum + 1
							inp = 1
							bico = i < clip+chamber
						end
					end
					if inum == 0 then
					draw = true
						bullet:SetFrame('icon', (black and 21) or (spr - 1))
					end
					if inum == fullclips then
						bullet:SetFrame('icon', (black and 22) or (7 + spr - 1))
					end
					if draw then
						local critshine = ((not black) and ischamber and gun.crit and 100) or 0
						bullet.Color = Color(bclrr, bclrg, bclrb, maxalpha * bclra, critshine, critshine, critshine)
						bullet:RenderLayer(0, Vector(xx + xo, yy + yo))
					end
				end
			end
		end

		--COLLECTIBLES AND WEAPON MODS
		if screensize and (not coverhud) and not gamelayer then
			local modui = CSP.Mod
			local ind = 0
			local x1 = screensize.X - 46
			local y1 = 88
			local xx = 0
			local yy = 0
			local tempclr = Color(1, 1, 1, hudopacity, 0, 0, 0)

			if d.passives and #d.passives > 0 then
				font1:DrawStringScaled('Passives', x1+4, y1 - 20, .5, .5, KL_white, 0, false)
				for i, itm in ipairs(d.passives) do
					xx = (ind % 3) * 16
					yy = math.floor(ind / 3) * 16
					local sprit = Sprite()
					sprit:Load("gfx/005.100_collectible.anm2", true)
					sprit.Scale = Vector(.5, .5)
					sprit.Color = tempclr
					sprit:ReplaceSpritesheet(1, config:GetCollectible(itm).GfxFileName)
					sprit:LoadGraphics()
					sprit:Play("ShopIdle")
					sprit:RenderLayer(1, Vector(x1 + xx, y1 + yy))
					ind = ind + 1
				end

				y1 = y1 + yy + 30
				ind = 0
			end

			if gun and #gun.mods > 0 then
				font1:DrawStringScaled('Weapon Mods', x1-1, y1 - 20, .5, .5, KL_white, 0, false)
				for i, itm in ipairs(gun.mods) do
					xx = (ind % 3) * 16
					yy = math.floor(ind / 3) * 16
					local sprit = Sprite()
					sprit:Load("gfx/005.100_collectible.anm2", true)
					sprit.Scale = Vector(.5, .5)
					sprit.Color = tempclr
					sprit:ReplaceSpritesheet(1, config:GetCollectible(itm).GfxFileName)
					sprit:LoadGraphics()
					sprit:Play("ShopIdle")
					sprit:RenderLayer(1, Vector(x1 + xx, y1 + yy))
					ind = ind + 1
				end
			end
		end
		--GAME / FLOOR TIMERS
		if screensize and (not coverhud) and not gamelayer then
			local tpos = Vector(screensize.X / 2, 6)
			local time = math.floor(gVAR.gametime / 30)
			local nexttarget = ((stage < 8 and not gVAR.inbossrush) and (20 * 60)) or	(stage < 8 and (30 * 60)) or (45 * 60)
			local parstr = timeDisplay(nexttarget)
			local tcolor = (time < nexttarget and KL_white) or KL_ltred

			local tstr = timeDisplay(time)
			local tlen = font1:GetStringWidth(tstr)
			local soff = font1:GetStringWidth('/')/2
			local sdist = 7
			font1:DrawString(tstr, (tpos.X - tlen) - sdist, tpos.Y, tcolor, 0, false)
			font1:DrawString('/', tpos.X - soff, tpos.Y, tcolor, 0, false)
			font1:DrawString(parstr, tpos.X + sdist, tpos.Y, tcolor, 0, false)

			if stage > 1 or not gVAR.levellimbo then
				time = math.floor(gVAR.stagetime / 30)
				nexttarget = math.floor(gVAR.partime / 30)
				parstr = timeDisplay(nexttarget)
				local tcolor = (time < nexttarget and (gVAR.levellimbo and KL_ltgreen or KL_white)) or KL_ltred

				tstr = timeDisplay(time)
				tlen = font1:GetStringWidth(tstr)
				font1:DrawString(tstr, (tpos.X - tlen) - sdist, tpos.Y + 10, tcolor, 0, false)
				font1:DrawString('/', tpos.X - soff, tpos.Y + 10, tcolor, 0, false)
				font1:DrawString(parstr, tpos.X + sdist, tpos.Y + 10, tcolor, 0, false)
			end
		end

		--STATS
		if screensize and gSET.ShowStats ~= 1 and (not coverhud) and not gamelayer then
			local ico = CSP.Waldo
			local stat = d.gunstat

			local showstats = {}
			for i, st in ipairs(gVAR.stats) do
				if mmenuvar.open or i <= 3 or gVAR.tstats[i] > 0 or gSET.ShowStats == 4 then
					local plus = gVAR.dstats[i] >= 0
					table.insert(showstats, {i, gVAR.stats[i], plus, gVAR.dstats[i], gVAR.tstats[i]})
				end
			end

			local x1 = 8
			local y1 = 94

			ico.Scale = Vector(.5, .5)
			ico.Color = Color(1, 1, 1, .5, 0, 0, 0)
			for i, stat in ipairs(showstats) do
				local xx = x1
				local yy = y1 + ((i-1) * 10)
				--local alpha = .5 - (.5* (math.min(0, stat[5]) / -30))
				local alpha = (math.min(1, (stat[5] / 30))) * hudopacity
				local alpha2 = math.max(alpha, (((mmenuvar.open or gSET.ShowStats == 4) and 1) or 0) * hudopacity)
				local pct = stat[1] <= 3
				yy = yy + (i > 3 and 6 or 0)

				ico.Color = Color(1, 1, 1, pct and hudopacity or alpha2, 0, 0, 0)
				ico:SetFrame('Icon', stat[1] - 1)
				ico:RenderLayer(0, Vector(xx, yy))

				local string1 = stat[2]..(pct and '%' or '')
				local color = KColor(1, 1, 1, pct and hudopacity or alpha2, 0, 0, 0)
				font1:DrawStringScaled(string1, xx + 8, yy - 7, 1, 1, color, 0, false)

				if stat[5] > 0 then
					local string2 = (stat[3] and '+' or '')..stat[4]
					local isup = (gVAR.istats[stat[1] ] and not stat[3]) or (stat[3] and not gVAR.istats[stat[1] ])
					local color = gVAR.dstats[i] == 0 and KColor(1, 1, 1, alpha, 0, 0, 0) or isup and KColor(.5, 1, .5, alpha, 0, 0, 0) or KColor(1, .5, .5, alpha, 0, 0, 0)
					font1:DrawStringScaled(string2, xx + 38, yy - 7, 1, 1, color, 0, false)
				end
			end
		end

		--WEP SELECT NUMBERS
		if gVAR.hudwepselect and (not coverhud) and gamelayer then
			local isupdate = gVAR.renderframe % 2 == 1
			for i, num in ipairs(gVAR.hudwepselect) do
				local fcolor = KColor(1, 1, 1, .75 * hudopacity, 0, 0, 0)
				if num[3] then
					fcolor = KColor(1, 1, .5, 1 * hudopacity, 0, 0, 0)
				end
				local pos = num[2] + Vector(font1:GetStringWidth(num[1]) * -.5, 0)
				if not isupdate then
					pos = pos + (player.Velocity * .5)
				end
				font1:DrawStringScaled(num[1], pos.X, pos.Y, 1, 1, fcolor, 0, false)
			end
			if not isupdate then
				gVAR.hudwepselect = nil
			end
		end

		--guess fullscreen lol
		local mpos = Input.GetMousePosition(false)
		if gVAR.renderframe > 30 and mpos.X > screensize.X*2 or mpos.Y > screensize.Y*2 then
			if cursorinbounds then
				isfullscreen = true
			end
			cursorinbounds = false
		else
			cursorinbounds = true
		end
	end

	--cursor
	if gSET.ShowGunCursor == 4 or (gVAR.gunmode and gSET.ShowGunCursor ~= 1 and (isfullscreen or gSET.ShowGunCursor >= 3) and not (gamelayer or coverhud)) then
		local cursor = CSP.Cursor
		local cpos = Isaac.WorldToScreen(Input.GetMousePosition(true))
		local offset = Vector(0, 0)
		local clra = {1, 1, 1}
		local alpha = 1
		local clrb = {0, 0, 0}
		local player = Isaac.GetPlayer(0)
		local gun = gVAR.gunmode and player:GetData().mygun

		if mmenuvar and mmenuvar.open then
			cursor:SetFrame('Idle', 5)
			cursor.Color = Color(clra[1], clra[2], clra[3], alpha, clrb[1], clrb[2], clrb[3])
			cursor:RenderLayer(0, cpos)
		elseif gun then
			local d = player:GetData()
			local spreadmod = 2
			if gun.reloading then
				spreadmod = 4
			elseif gun.spreadmin < gun.spreadmax then
				local range = gun.spreadmax - gun.spreadmin
				local res = (gun.spread - gun.spreadmin) / range * 2.5
				spreadmod = 2 + math.floor(res)
			end

			if gun.crit then
				local flashmod = ((gVAR.renderframe % 4 < 2) and 0) or 1
				clra = {1, 1, 1 * flashmod}
				clrb = {50 * flashmod, 50 * flashmod, 0}
			elseif gun.charged then
				clra = {1, 1, .5}
			elseif d.guncontrol.load or d.guncontrol.shoot then
				clra = {1, .5, .5}
			end

			if gun.revtime and gun.rev then
				cursor.Rotation = math.min(1, (gun.rev / gun.revtime)) * 360
				offset = Vector(-.5, -.5):Rotated(cursor.Rotation)
			else
				cursor.Rotation = 0
			end

			cursor:SetFrame('Idle', 0)
			cursor:RenderLayer(0, cpos + offset)

			cursor:SetFrame('Idle', spreadmod)
			cursor.Color = Color(clra[1], clra[2], clra[3], alpha, clrb[1], clrb[2], clrb[3])
			cursor:RenderLayer(0, cpos + offset)
		else
			cursor:SetFrame('Idle', 0)
			cursor.Color = Color(clra[1], clra[2], clra[3], alpha, clrb[1], clrb[2], clrb[3])
			cursor:RenderLayer(0, cpos)

			cursor:SetFrame('Idle', 2)
			cursor:RenderLayer(0, cpos)
		end
	end
end

function timeDisplay(seconds)
	local minutes = math.floor(seconds / 60)
	local dseconds = seconds % 60
	dseconds = ((dseconds < 10 and 0) or '')..dseconds
	return (minutes..':'..dseconds)
end

function l.setOption(variable, setting)
	gSET[variable] = setting
	gVAR.settingschanged = true
	if variable == 'LightingSaturation' then
		gVAR.flashlightcolor = l.getFlashlightColor()
	end
end

function l.gunMenu(reload)
	--add mouse support
	local player = Isaac.GetPlayer(0)
	local d = player:GetData()
	local input = d.input.menu
	if reload then
		input = {}
	end
	local menuspr = CSP.Menu
	local scenter = getScreenCenterPosition()
	local ms1 = Vector(scenter.X - 40, scenter.Y + 10)
	local ms2 = Vector(scenter.X + 132, scenter.Y - 10)
	local tty = scenter.Y - 4
	local menuactive = false
	if gVAR.merchantent and not gVAR.merchantent:Exists() then
		gVAR.merchantent = nil
	end
	---INIT MENU
	if not mmenuvar.init then
		menuspr:Play("Dissapear")
		menuspr:SetLastFrame()
		mmenuvar.init = true
		mmenuvar.idle = false
	end
	---TOGGLE MENU
	if input.toggle then
		if mmenuvar.open then
			if mmenuvar.item ~= mmenudir.main then
				input.back = true
			else
				mmenuvar.open = false
			end
		else
			if game:GetRoom():IsClear() then
				mmenuvar.hadgun = d.mygun
				mmenuvar.open = true
				mmenuvar.openanim = true
				mmenuvar.loadinv = true
				mmenuvar.shop = true
			else
				sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ, .75, 0, false, 1.5)
			end
		end
	end
	---PLAYING BACKGROUND SPRITE
	menuspr.Color = CL_white
	if mmenuvar.open then
		if not (player:IsExtraAnimationFinished() or player:IsItemQueueEmpty()) then
			mmenuvar.open = false
		elseif menuspr:IsPlaying("Appear") or mmenuvar.openanim then
			mmenuvar.openanim = false
			menuspr:Play("Appear")
			mmenuvar.idle = false
		else
			mmenuvar.maskalpha = approach(mmenuvar.maskalpha, 0, .25)
			menuspr:Play("Idle")
			menuactive = true
			mmenuvar.idle = true
		end
		mmenuvar.pocket = player:GetCard(0)
	end
	if not mmenuvar.open then
		mmenuvar.maskalpha = approach(mmenuvar.maskalpha, 1, .25)
		mmenuvar.item = mmenudir.main
		mmenuvar.path = {}
		if mmenuvar.maskalpha == 1 then
			menuspr:Play("Dissapear") -- nicalis spelling, not mine
			mmenuvar.idle = false
		else
			menuspr:Play("Idle")
			menuactive = true
		end
		if gVAR.settingschanged then
			gVAR.settingschanged = false
			l.saveData()
		end
	end
	if not reload then
		menuspr:Render(ms1, Vector(0, 0), Vector(0, 0))
		menuspr:Update()
	end

	if menuactive then
		---OPERATION
		local item = mmenuvar.item
		local buttons = item.buttons
		local pages = item.pages
		local bsel = 1
		local psel = 1
		local action = false
		local dest = false
		local button = false
		local drawstuff = true
		local merchant = gVAR.merchantent
		local md = merchant and (merchant:GetData())
		local cantbuy = false
		--activate hover detection
		if input.mousemove then
			mmenuvar.checkmouse = true
		end
		--buttons
		if buttons and #buttons > 0 then
			--button selection
			item.bsel = math.min((item.bsel or 1), #buttons)
			if input.up then
				item.bsel = ((item.bsel - 2) % #buttons) + 1
			elseif input.down then
				item.bsel = (item.bsel % #buttons) + 1
			end
			for i, button in ipairs(buttons) do
				if (not input.mouse1) and input.mousemove and item.bhov == i then
					item.bsel = i
				end
			end
			bsel = item.bsel
			dest = mmenudir[buttons[bsel].dest]
			button = item.buttons[bsel]
			--button confirmation
			if input.confirm or (item.bhov == item.bsel and input.click) then
				if button and button.action then
					action = button.action
				end
				if dest then
					mmenuvar.checkmouse = false
					table.insert(mmenuvar.path, item)
					mmenuvar.item = dest
				end
			end
			--button choice selection
			if button.choices and #button.choices > 0 then
				button.setting = button.setting or 1
				if (input.right or input.dright) and button.setting < #button.choices then
					button.setting = button.setting + 1
					sfx:Play(SoundEffect.SOUND_PLOP, 1, 0, false, .9 + (.2 * (#button.choices / (#button.choices - (button.setting - 1)))))
					l.setOption(button.variable, button.setting)
				elseif (input.left or input.dleft) and button.setting > 1 then
					button.setting = button.setting - 1
					sfx:Play(SoundEffect.SOUND_PLOP, 1, 0, false, .9 + (.2 * (#button.choices / (#button.choices - (button.setting - 1)))))
					l.setOption(button.variable, button.setting)
				elseif input.confirm then
					button.setting = (button.setting % #button.choices) + 1
					sfx:Play(SoundEffect.SOUND_PLOP, 1, 0, false, .9 + (.2 * (#button.choices / (#button.choices - (button.setting - 1)))))
					l.setOption(button.variable, button.setting)
				end
			end
		end
		--menu regressing
		if input.back then
			if mmenuvar.item.inventory then
				if d.mygun and d.mygun ~= mmenuvar.hadgun then
					--l.gunSwitch(player, mmenuvar.hadgun, true)
					--l.checkHasGuns(player)
					--log('aa')
				end
			end
			if mmenuvar.mod then
				mmenuvar.mod = false
			elseif #mmenuvar.path > 0 then
				mmenuvar.item = mmenuvar.path[#mmenuvar.path]
				mmenuvar.path[#mmenuvar.path] = nil
				mmenuvar.checkmouse = false
			else
				mmenuvar.open = false
				mmenuvar.shop = false
			end
		end
		--pages
		if pages and pages > 0 then
			item.psel = math.min((item.psel or 1), pages)
			if item.phov ~= item.phovlast then
				item.phovlast = item.phov
				mmenuvar.loadinv = true
			end
			if item.phov and input.mouse1 then
				item.psel = item.phov
			end
			if input.left then
				item.psel = ((item.psel - 2) % pages) + 1
			elseif input.right then
				item.psel = (item.psel % pages) + 1
			end
			psel = item.psel
			phov = item.phov
			pselhov = psel--phov or psel
		end

		--pocket changed failsafe
		if mmenuvar.pocket ~= player:GetCard(0) then
			mmenuvar.loadinv = true
			mmenuvar.pocket = player:GetCard(0)
		end

		--can I buy it
		local price = button and button.price or 0
		if mmenuvar.inventory and button and button.price and (not gSET.DebugMode) and ((player:GetNumCoins() < price) or (mmenuvar.inventory[pselhov] and mmenuvar.inventory[pselhov].soldout)) then
			cantbuy = true
		end

		--BUTTON ACTIONS
		if action then
			price = button.price or 0
			mmenuvar.loadinv = true
			if not cantbuy then
				player:AddCoins(price * -1)
				local cache = false
				if action == 'resume' then
					mmenuvar.open = false
				elseif action == 'buy' then
					local object = mmenuvar.inventory[pselhov]
					object.merch = false
					if object.kind == EIT.mod then
						table.insert(d.mods, object.id)
						table.remove(gVAR.merchantinv[2], object.ind)
					elseif object.kind == EIT.gun then
						object.id.playerowned = true
						insertFirst(d.loadout, object.id)
						--table.insert(d.loadout, object.id)
						table.remove(gVAR.merchantinv[1], object.ind)
					elseif object.kind == EIT.pocket then
						if pocket[object.id].type == 'herb' then
							gVAR.herbtax = gVAR.herbtax + gBAL.difftable[EDF.herbtax][gSET.difficulty]
						end
						player:AddCard(object.id)
						table.remove(gVAR.merchantinv[3], object.ind)
					end
					item.psel = math.max(1, item.psel - 1)
					sfx:Play(SoundEffect.SOUND_DIMEDROP, 1, 0, false, 1)
					cache = true
					if merchant then
						--if object.kind == EIT.pocket and not md.traded then
							--md.voice = snd.merch.isthatall
						if object.kind == EIT.gun and object.id.mcomment then
							md.voice = object.id.mcomment
						elseif object.kind == EIT.gun and object.id.meta.rank == 3 then
							md.voice = (rng:RandomFloat() < .5 and snd.merch.com.avidcollector) or snd.merch.com.thatsaweapon
						else
							md.voice = (rng:RandomFloat() < .5 and snd.merch.thankyou or snd.merch.isthatall)
						end
						md.traded = true
					end
				elseif action == 'sell' then
					local object = mmenuvar.inventory[pselhov]
					object.merch = true
					if object.kind == EIT.mod then
						table.remove(d.mods, object.ind)
						--table.insert(gVAR.merchantinv[2], object)
					elseif object.kind == EIT.gun then
						object.id.playerowned = false
						l.checkHasGuns(player)
						mmenuvar.loadinv = true
						--table.insert(gVAR.merchantinv[1], object)
					elseif object.kind == EIT.pocket then
						--table.insert(gVAR.merchantinv[3], object)
						player:SetCard(0, 0)
					end
					sfx:Play(SoundEffect.SOUND_NICKELPICKUP, 1, 0, false, 1)
					cache = true
					if merchant then
						if (object.kind == EIT.gun and #object.id.mods >= 3) or (object.kind == EIT.pocket and object.id == pocket.hgry.id) then
							md.voice = snd.merch.highprice
						else
							md.voice = snd.merch.thankyou
						end
						md.traded = true
					end
				elseif action == 'pickmod' then
					mmenuvar.mod = mmenuvar.inventory[pselhov]
					mmenuvar.loadinv = true
					item.psel = 1
				elseif action == 'attach' then
					local object = mmenuvar.inventory[pselhov]
					l.gunMod(object.id, mmenuvar.mod.id, player)
					local upgrade = object.id.upgrade[#object.id.mods]
					if upgrade then
						l.gunMod(object.id, upgrade, player)
						if d.perks.upgradefill then
							object.id.clip = object.id.clipsize
						end
					end
					table.remove(d.mods, mmenuvar.mod.ind)
					mmenuvar.mod = false
					item.psel = item.psel + #gVAR.merchantinv[1] + #gVAR.merchantinv[2] + #gVAR.merchantinv[3]
					sfx:Play(snd.misc.attach, 1, 0, false, 1)
					sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 1)
					cache = true
				elseif action == 'destroy' then
					local object = mmenuvar.inventory[pselhov]
					for i, mod in ipairs(object.id.mods) do
						table.insert(d.mods, mod)
					end
					object.id.playerowned = false
					l.checkHasGuns(player)
					mmenuvar.loadinv = true
					sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1.2)
					cache = true
				end
				if cache then
					player:AddCacheFlags(CacheFlag.CACHE_ALL)
					player:EvaluateItems()
				end
			elseif action == 'buy' or action == 'attach' then
				if (mmenuvar.inventory[pselhov] and mmenuvar.inventory[pselhov].soldout) or not merchant then
					sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ, 1, 0, false, 1)
				else
					md.voice = snd.merch.notenoughcash
				end
			end
			psel = item.psel
			phov = item.phov
			pselhov = psel--phov or psel
		end

		--LOADING INVENTORY
		if input.confirm or input.back or input.up or input.down or input.left or input.right then
			mmenuvar.loadinv = true
		end
		if mmenuvar.loadinv then
			local hasplayerweps = false
			mmenuvar.loadinv = false
			local inv = {}
			--merchant
			if merchant and mmenuvar.shop and gVAR.merchantinv and not mmenuvar.mod then
				for i, minv in ipairs(gVAR.merchantinv) do
					if #minv > 0 then for j, obj in ipairs(minv) do
						obj.ind = j; obj.merch = true
						obj.kind = (i == 1 and EIT.gun) or (i == 2 and EIT.mod) or EIT.pocket
						table.insert(inv, obj)
					end end
				end
			end
			--user weps
			if #d.loadout > 0 then for i, obj in ipairs(d.loadout) do
				if obj then
					hasplayerweps = true
					table.insert(inv, {kind = EIT.gun, id = obj, ind = i, gunprev = true})
				end
			end	end
			--user mods
			if #d.mods > 0 and not mmenuvar.mod then for i, obj in ipairs(d.mods) do
				table.insert(inv, {kind = EIT.mod, id = obj, ind = i})
			end	end
			--user pocket
			local pocket0 = player:GetCard(0)
			if pocket0 ~= 0 and pocket[pocket0] and not mmenuvar.mod then
				table.insert(inv, {kind = EIT.pocket, id = pocket0, ind = 1})
			end
			mmenuvar.inventory = inv
			mmenudir.inventory.pages = #inv
			--inventory options
			mmenudir.inventory.buttons = {}
			if inv[pselhov] then
				if inv[pselhov].gunprev and inv[pselhov].id.playerowned then
					--l.gunSwitch(player, inv[pselhov].id, true)
				elseif mmenuvar.hadgun ~= d.mygun then
					--l.gunSwitch(player, mmenuvar.hadgun, true)
					--l.checkHasGuns(player)
				end
				if not mmenuvar.mod then
					if inv[pselhov].merch and mmenuvar.shop then
						mmenudir.inventory.title = 'shop!'
						if inv[pselhov].earlybird then
							mmenudir.inventory.title = 'early bird!'
						elseif inv[pselhov].soldout then
							mmenudir.inventory.title = 'sold out!'
						end
						if not (inv[pselhov].kind == EIT.gun and insertFirst(d.loadout, false) > 4) then
							table.insert(mmenudir.inventory.buttons, {str = 'buy', action = 'buy', price = getPrice(inv[pselhov], 'buy'), halign = -1})
						end
					else
						mmenudir.inventory.title = 'inventory!'
						if (gVAR.merchantent or gSET.DebugMode) and inv[pselhov].kind == EIT.mod and hasplayerweps then
							table.insert(mmenudir.inventory.buttons, {str = 'attach', action = 'pickmod', halign = -1})
						end
						if inv[pselhov].kind == EIT.gun and #inv[pselhov].id.mods > 0 and mmenuvar.shop then
							table.insert(mmenudir.inventory.buttons, {str = 'dismantle', action = 'destroy', price = getPrice(inv[pselhov], 'destroy'), halign = -1})
						end
						if gVAR.merchantent then
							table.insert(mmenudir.inventory.buttons, {str = 'sell', action = 'sell', price = getPrice(inv[pselhov], 'sell'), halign = -1})
						end
					end
				elseif inv[pselhov].kind == EIT.gun and #inv[pselhov].id.mods < #inv[pselhov].id.upgrade and not inv[pselhov].id.cantmod then
					mmenudir.inventory.title = 'attaching...'
					table.insert(mmenudir.inventory.buttons, {str = 'attach', action = 'attach', price = getPrice(inv[pselhov], 'attach'), halign = -1})
				end
			else

			end
			if not reload then
				l.gunMenu(true)
				drawstuff = false
			end
		end

		if drawstuff then
			--DRAWING MENU CONTENTS
			local drawings = {}
			--TITLE
			if item.title then
				table.insert(drawings, {type = 'str', str = item.title, size = 2, root = ms1, pos = Vector(0, -72), underline = true})
			end
			--PAGE INDICATORS
			if item.pages then
				if item.inventory and mmenuvar.inventory and #mmenuvar.inventory > 0 then
					local pageset1 = {type = 'pageset', set = {}, root = ms1, pos = Vector(0, -50), width = 190, spacing = 13}
					local pageset2 = {type = 'pageset', set = {}, root = ms1, pos = Vector(0, ((mmenuvar.shop) and -36) or -50), width = 190, spacing = 13}
					for i, obj in pairs(mmenuvar.inventory) do
						--page icons
						local alpha = (psel == i and 1) or (item.phov == i and .75) or .5
						local scale = (item.phov == i and Vector(1.25, 1.25)) or Vector(1, 1)
						if obj.merch then
							local clrme = (obj.earlybird and CL_green) or (obj.soldout and CL_red) or CL_blue
							table.insert(pageset1.set, {type = 'page', icon = ((obj.kind == EIT.gun) and 9) or (obj.kind == EIT.mod and 10) or 11, hover = i, scale = scale, alpha = alpha, color = clrme})
						else
							table.insert(pageset2.set, {type = 'page', icon = ((obj.kind == EIT.gun) and 9) or (obj.kind == EIT.mod and 10) or 11, hover = i, scale = scale, alpha = alpha})
						end
						--inventory display
						if pselhov == i then
							table.insert(drawings, {type = 'invdisplay', obj = obj, root = ms1, root2 = ms2, pos = Vector(0, ((mmenuvar.shop) and -14) or -28)})
						end
					end
					if #pageset1.set > 0 then
						table.insert(drawings, pageset1)
					end
					if #pageset2.set > 0 then
						table.insert(drawings, pageset2)
					end
				end
			end
			--BUTTONS
			if item.buttons then
				local strset = {type = 'strset', set = {}, valign = item.valign, root = ms1 + Vector(0, 12), height = 56}
				local strset2 = {type = 'strset', set = {}, valign = item.valign, root = ms1 + Vector(0, 12), height = 56}
				for i, button in ipairs(buttons) do
					local newstring = {type = 'str', str = button.str, halign = button.halign, width = 164, size = 2, spacing = 18, color = color, hover = i, select = bsel == i}
					if button.str == 'inventory' and merchant and mmenuvar.shop then
						newstring.color = CL_blue; newstring.str = 'merchant'
					end
					if item.bhov == i then
						newstring.color = CL_pencil2
					end
					table.insert(strset.set, newstring)
					--prices
					if item.inventory then
						table.insert(strset2.set, {type = 'str', halign = 1, width = 164, size = 2, spacing = 18,
						str = (button.price and tostring((button.price >= 0 and button.price) or (button.price * -1))..'_C') or '', alpha = (cantbuy and .5) or 1})
					--choices
					elseif button.choices then
						table.insert(strset.set, {type = 'str', str = button.choices[button.setting], size = 1, spacing = 16, pos = Vector(0, -4),
						dotsleft = button.setting - 1, dotsright = #button.choices - button.setting, dist = 54, width = 164, hover = i})
					end
				end
				table.insert(drawings, strset)
				if item.inventory then
					table.insert(drawings, strset2)
				end
			end

			--TIP BOX LOGIC
			--settings info
			if item == mmenudir.inventory then

			elseif false and item == mmenudir.settings then
				if bsel == 1 then
					local strset = {type = 'strset', set = {}, root = ms2}
					local strset2 = {type = 'strset', set = {}, root = ms2}
					for i, val in ipairs(gBAL.difftable) do
						local fudge = roundTo((val[button.setting] / val[3]) * 100, 1)
						if i <= 4 then
							--local desc = (i == EDF.ammo and val[button.setting] == 1 and 'inf') or (i == EDF.herbs and val[button.setting] == 6 and '???') or false
							table.insert(strset.set, {type = 'str', size = 1, halign = -1, width = 100, spacing = 14, str = gBAL.diffnames[i] or ''})
							table.insert(strset2.set, {type = 'str', size = 1, halign = 1, width = 100, spacing = 14, str = fudge..'%'})
						elseif i <= 5 then
							table.insert(strset.set, {type = 'str', size = 1, halign = -1, width = 100, spacing = 14, str = gBAL.diffnames[i] or ''})
							table.insert(strset2.set, {type = 'str', size = 1, halign = 1, width = 100, spacing = 14, str = (val[button.setting])})
						end
					end
					table.insert(drawings, strset)
					table.insert(drawings, strset2)
				elseif bsel == 2 then
					table.insert(drawings, {type = 'strset', size = 1, root = ms2, spacing = 14, set = {'position of', 'clip / ammo', 'indicator'}})
				elseif bsel == 3 then
					table.insert(drawings, {type = 'strset', size = 1, root = ms2, spacing = 14, set = {'what shows', 'up in this', 'box on the', 'main menu'}})
				elseif bsel == 4 then
					table.insert(drawings, {type = 'strset', size = 1, root = ms2, spacing = 14, set = {'change', 'gameplay', 'without', 'changing', 'balance'}})
				elseif bsel == 5 then
					table.insert(drawings, {type = 'strset', size = 1, root = ms2, spacing = 14, set = {'become a', 'no good', 'dirty', 'cheater'}})
				end
			--default player info
			else
				table.insert(drawings, {type = 'sprite', spr = (d.modchar and CSP.ModPlayer) or CSP.Player, anim = d.icon, str = d.icon, alpha = .5, color = CL_white, root = ms2, pos = Vector(0, 0)})
				table.insert(drawings, {type = 'str', size = 2, str = string.lower(player:GetName()), root = ms2, pos = Vector(0, -34)})
				local strset = {type = 'strset', set = {}, root = ms2, pos = Vector(0, 32)}
				for i, dstr in ipairs(d.descrip) do
					table.insert(strset.set, {type = 'str', size = 1, scale = Vector(.5, .5), spacing = 6, str = dstr})
				end
				table.insert(drawings, strset)
			end

			if item == mmenudir.test then
				table.insert(drawings, {type = 'test', root = ms1 + Vector(0, -20)})
				table.insert(drawings, {type = 'str', size = 2, root = ms1 + Vector(0, 10), str = 'rubber cement'})
				local theset = {"isaac thinks that", "cement is made out", "of rubber because he", "is so stupid"}
				table.insert(drawings, {type = 'strset', size = 1, root = ms1 + Vector(0, 50), width = 100, set = theset, spacing = 12})
			end

			item.phov = false
			item.bhov = false
			for i, draw in pairs(drawings) do
				l.drawMenu(draw)
			end
		end
	end
	---[[
	if mmenuvar.idle and mmenuvar.maskalpha > 0 then
		menuspr.Color = Color(1, 1, 1, mmenuvar.maskalpha, 0, 0, 0)
		menuspr:Play("Mask", true)
		menuspr:Render(ms1, Vector(0, 0), Vector(0, 0))
		menuspr.Color = CL_white
		menuspr:Play("Idle", true)
	end--]]
end

function l.drawMenu(table)
	local menuspr = CSP.Menu
	local wepui = CSP.Weapon
	local modui = CSP.Mod
	local modminiui = CSP.ModMini
	local font = CSP.MenuFont
	local pickupui = CSP.Pickup

	local scenter = getScreenCenterPosition()
	local root = table.root or Vector(scenter.X - 40, scenter.Y + 10)
	local root2 = table.root2 or Vector(scenter.X + 132, scenter.Y - 10)
	local dtype = table.type
	local pos = table.pos or Vector(0, 0)
	local scale = table.scale or Vector(1, 1)
	local color = table.color or CL_pencil
	local bright = table.glow == 2 and (Vector(.25, 0):Rotated(game:GetFrameCount() % 15 * (360 / 15)).X + 1.25) or 1
	color = Color(color.R * bright, color.G * bright, color.B * bright, table.alpha or 1, math.floor(color.RO), math.floor(color.GO), math.floor(color.BO))
	local hover = false
	local mpos = Isaac.WorldToScreen(Input.GetMousePosition(true))*2

	if dtype == 'dot' then
		menuspr.Color = color
		menuspr:SetFrame("Sym", 6)
		menuspr:RenderLayer(3, root + pos)
	elseif dtype == 'str' then
		local size = table.size or 1
		local layer = size - 1
		local ind = size + 1
		local fname = (table.size == 1 and '12') or '16'
		local str = table.str or 'nostring'
		local halign = table.halign or 0
		local width = table.width or 180
		font.Color = color
		menuspr.Color = color

		--horizontal offset
		local xoff = 0
		if halign >= 0 then
			for i = 1, string.len(str) do
				local sub = string.sub(str, i, i)
				local len = (mfontdat[sub][ind] * scale.X) + 1
				xoff = xoff - len
			end
			if halign == 0 then
				xoff = math.ceil(xoff * .5)
			else
				xoff = xoff + (width / 2)
			end
		else
			xoff = width / -2
		end
		--hovered
		if table.hover and mmenuvar.checkmouse then
			local rpos = mpos - ((root + pos) * 2)
			if math.abs(rpos.X) <= width and math.abs(rpos.Y) <= table.spacing then
				mmenuvar.item.bhov = table.hover
			end
		end
		--selection
		if table.select then
			menuspr:SetFrame("Sym", 1)
			menuspr:RenderLayer(3, root + pos + Vector(xoff - 12, 0))
		end
		--drawing string
		for i = 1, string.len(str) do
			local sub = string.sub(str, i, i)
			local len = mfontdat[sub][ind] * scale.X
			font.Color = color
			font.Scale = scale
			if sub == 'B' then -- sorry
				font.Color = CL_red
				font.Scale = Vector(1.3, 1.3)
			end
			font:SetFrame(fname, mfontdat[sub][1])
			font:RenderLayer(layer, root + pos + Vector(xoff + math.ceil(len / 2), 0))
			xoff = xoff + len + 1
		end
		--underline
		if table.underline then
			menuspr:SetFrame("Sym", 0)
			menuspr:RenderLayer(3, root + pos + Vector(0, 14))
		end
		--option dots
		menuspr:SetFrame("Sym", 6)
		if (table.dotsleft or 0) > 0 then for i = 0, table.dotsleft - 1 do
			menuspr:RenderLayer(3, root + pos - Vector((table.dist or 20) + (i * 8), 0))
		end end
		if (table.dotsright or 0) > 0 then for i = 0, table.dotsright - 1 do
			menuspr:RenderLayer(3, root + pos + Vector((table.dist or 20) + (i * 8), 0))
		end end
	elseif dtype == 'strset' then
		local valign = table.valign or 0
		local yoff = 0
		--vertical offset
		if valign == -1 then
			yoff = (table.height or 0) * -1
		else
			for i, string in pairs(table.set) do
				if i > 1 then
					yoff = yoff + (string.spacing or table.spacing or 18)
				end
			end
			if valign == 0 then
				yoff = math.floor(yoff * -.5)
			else
				yoff = (yoff * -1) + table.height
			end
		end
		--drawing string lines
		for i, string in pairs(table.set) do
			local newstring = string
			if type(string) == 'string' then
				newstring = {str = string}
				newstring.type = 'str'
			end
			newstring.root = newstring.root or table.root
			newstring.pos = (newstring.pos or Vector(0, 0)) + pos + Vector(0, yoff)
			--newstring.spacing = newstring.spacing or table.spacing
			newstring.halign = newstring.halign or table.halign
			newstring.width = newstring.width or table.width
			newstring.size = newstring.size or table.size or 1
			newstring.scale = newstring.scale or table.scale or Vector(1, 1)
			l.drawMenu(newstring)
			yoff = yoff + (string.spacing or table.spacing or 18)
		end
	elseif dtype == 'page' then
		menuspr.Color = color
		menuspr.Scale = scale
		menuspr:SetFrame("Sym", table.icon or 5)
		menuspr:RenderLayer(3, root + pos)
		if table.hover then
			local rpos = mpos - ((root + pos) * 2)
			if math.abs(rpos.X) <= 13 and math.abs(rpos.Y) <= 13 then
				mmenuvar.item.phov = table.hover
			end
		end
		menuspr.Scale = Vector(1, 1)
	elseif dtype == 'pageset' then
		for i, icon in pairs(table.set) do
			local newicon = icon
			local spacing = math.min(table.spacing, (table.width or 180) / #table.set)
			newicon.root = root
			newicon.pos = pos + Vector(math.floor((i - ((#table.set + 1) / 2)) * spacing), 0)
			l.drawMenu(newicon)
		end
	elseif dtype == 'test' then
		local minwob = (Vector(1.5, 0):Rotated(6 * game:GetFrameCount() % 360)).X
		modui.Scale = Vector(2, 2)
		modui:ReplaceSpritesheet(1, config:GetCollectible(221).GfxFileName)
		modui:LoadGraphics()
		modui:Play("ShopIdle")
		modui.Color = Color(0, 0, 0, .5, 54, 47, 45)
		modui:RenderLayer(1, root + pos + Vector(0, 8 + minwob) + Vector(2, 2))
		modui.Color = Color(1, 1, 1, 1, 0, 0, 0)
		modui:RenderLayer(1, root + pos + Vector(0, 8 + minwob))
	elseif dtype == 'invdisplay' then
		local obj = table.obj
		local id = obj.id
		local str = 'thingy'
		local str2 = 'thingy'
		local minwob = (Vector(1.5, 0):Rotated(6 * game:GetFrameCount() % 360)).X
		if obj.kind == EIT.gun then
			wepui:ReplaceSpritesheet(0, gWEP.BaseSprite[id.base])
			wepui:LoadGraphics()
			wepui:Play("Idle")
			wepui.Color = Color(0, 0, 0, .5, 54, 47, 45)
			wepui:Render(root + pos + Vector(id.noammo and 0 or -16, minwob) + Vector(2, 2), Vector(0, 0), Vector(0, 0))
			wepui.Color = Color(1, 1, 1, 1, 0, 0, 0)
			wepui:Render(root + pos + Vector(id.noammo and 0 or -16, minwob), Vector(0, 0), Vector(0, 0))
			if not id.noammo then
				pickupui:ReplaceSpritesheet(0, pocket[gPOC.ammolist[id.ammotype]].sprite); pickupui:LoadGraphics()
				pickupui:Play("Idle")
				pickupui.Color = Color(0, 0, 0, .5, 54, 47, 45)
				pickupui:RenderLayer(0, root + pos + Vector((gWEP.BaseLength[id.base]/2) + 4, 7 + minwob) + Vector(2, 2))
				pickupui.Color = Color(1, 1, 1, 1, 0, 0, 0)
				pickupui:RenderLayer(0, root + pos + Vector((gWEP.BaseLength[id.base]/2) + 4, 7 + minwob))
			end

			str = string.lower(id.name)
			str2 = string.lower(id.description)
			local cantmod = id.cantmod and 'cannot mod' or false
			local nextup = id.upgrade[#id.mods + 1] or false
			local clipmult = (id.countpellets and id.pellets) or 1
		 	local iconset = {{id.fakedmg or (id.as.damage..((id.ms.damage == 1 and "") or ("X"..roundTo(id.ms.damage*100,1).."%"))), Vector(-44, -32)}, {id.as.maxfiredelay..((id.ms.maxfiredelay == 1 and "") or ("X"..roundTo(id.ms.maxfiredelay*100,1).."%")), Vector(6, -32)},
											{math.floor(id.ms.range*100).."%", Vector(-44, -16)}, {(id.as.luck*id.ms.luck), Vector(6, -16)},
										 	{id.clip*clipmult.."/"..id.clipsize*clipmult, Vector(-44, 0)},{#id.mods.."/"..#id.upgrade, Vector(6, 0)},
											{cantmod or ("up: "..((nextup and nextup.str) or "max!")), Vector(0, 16)}}

			menuspr.Color = CL_pencil
			for i = 1, 6 do
				menuspr:SetFrame('Sym2', i-1)
				menuspr:RenderLayer(3, table.root2 + iconset[i][2] + Vector(0, 0))
				l.drawMenu({type = 'str', str = tostring(iconset[i][1]), size = 1, scale = Vector(.5, .5), halign = -1, width = 0, root = table.root2, pos = iconset[i][2] + Vector(10, 0)})
			end
			l.drawMenu({type = 'str', str = tostring(iconset[7][1]), size = 1, scale = Vector(.5, .5), halign = 0, width = 0, root = table.root2, pos = iconset[7][2] + Vector(0, 0)})
			if #id.mods > 0 then
				str = str.." +"..tostring(#id.mods)
				for i, mod in ipairs(id.mods) do
					--modminiui:Play('Diary')
					modminiui:SetFrame('Diary', mod - 1)
					modminiui:RenderLayer(6, root2 + Vector(-8 + (#id.mods * -8) + (16 * i), 32) + Vector(84, -20))
				end
			end
		elseif obj.kind == EIT.mod then
			modui:ReplaceSpritesheet(1, config:GetCollectible(id).GfxFileName)
			modui:LoadGraphics()
			modui:Play("ShopIdle")
			modui.Color = Color(0, 0, 0, .5, 54, 47, 45)
			modui:RenderLayer(1, root + pos + Vector(0, 8 + minwob) + Vector(2, 2))
			modui.Color = Color(1, 1, 1, 1, 0, 0, 0)
			modui:RenderLayer(1, root + pos + Vector(0, 8 + minwob))
			str = (gITM.moddat[id] and gITM.moddat[id].rename) or string.lower(config:GetCollectible(id).Name)
			str2 = string.lower(config:GetCollectible(id).Description)
			str3 = gITM.moddat[id] and gITM.moddat[id].desc or gITM.defaultmoddesc
		else
			pickupui:ReplaceSpritesheet(0, pocket[id].sprite); pickupui:LoadGraphics()
			pickupui:Play("Idle")
			pickupui.Color = Color(0, 0, 0, .5, 54, 47, 45)
			pickupui:RenderLayer(0, root + pos + Vector(0, 4 + minwob) + Vector(2, 2))
			pickupui.Color = Color(1, 1, 1, 1, 0, 0, 0)
			pickupui:RenderLayer(0, root + pos + Vector(0, 4 + minwob))
			str = string.lower(config:GetCard(id).Name)
			str2 = string.lower(config:GetCard(id).Description)
		end
		l.drawMenu({type = 'str', str = str, size = 1, root = table.root, pos = table.pos + Vector(0, 22)})
		l.drawMenu({type = 'str', str = str2, size = 1, scale = Vector(.5, .5), root = table.root, pos = table.pos + Vector(0, 32)})
		if obj.kind == EIT.mod then
			l.drawMenu({type = 'str', str = "weapon mod!", size = 1, root = table.root2, pos = Vector(0, -32)})
			l.drawMenu({type = 'strset', set = str3, size = 1, root = table.root2, valign = -1, spacing = 12, pos = Vector(0, -12)})
		end
	elseif dtype == 'sprite' then
		local sprite = table.spr
		sprite.Color = color
		sprite:SetFrame(table.anim, table.frame or 0)
		sprite:RenderLayer(table.layer or 0, root + pos)
	end
end

--POST RENDER
function l:post_render()
	if gVAR.gunmode then
		gVAR.renderframe = gVAR.renderframe + 1
		l.getInput(0)
		--l.getInput(1)
		for i, en in ipairs(gVAR.gunusers) do
			if not en:Exists() then
				table.remove(gVAR.gunusers, i)
				i = i - 1
			else
				l.gunMove(en, en:GetData().mygun)
			end
		end
		if gVAR.renderframe > 8 then
			l.gunHud(true)
			l.gunMenu()
		end
		for i, snd in pairs(gVAR.shotsounds) do
			sfx:Play(i, snd[1], snd[2], snd[3], snd[4])
			gVAR.shotsounds[i] = nil
		end
		l.gunSndLoop()
		l.stopSounds()
		gVAR.gunswitched = false
	end
	l.gunHud(false)
	if Isaac.GetPlayer(0):GetData().attachepickup then
		local d = Isaac.GetPlayer(0):GetData()
		--sfx:Stop(SoundEffect.SOUND_HOLY)
		if not game:IsPaused() then
			d.attachepickup = d.attachepickup + 1
		end
		local frames = d.attachepickup
		local framemod = math.abs(76 - frames)
		local fade = CSP.ScreenFade
		if framemod <= 6 then
			fade.Color = Color(0, 0, 0, (6 - framemod) / 3, 0, 0, 0)
			fade.Scale = Vector(5, 5)
			fade:SetFrame("Idle", 0)
			fade:RenderLayer(0, getScreenCenterPosition())
		end

		if frames == 2 then
			music:EnableLayer()
			music:PitchSlide(.7)
			--music:Fadeout()
		end
		if frames == 70 then
			game:ShakeScreen(10)
		end
		if d.attachepickup > 100 and gVAR and not gVAR.levellimbo then
			--music:Fadein(music:GetCurrentMusicID(), 1)
			d.attachepickup = nil
		end
	end
	--render log
	local min = math.max(1, #_log-10)
	for i = min, #_log do
		if gSET.DebugMode then
			Isaac.RenderText(i..": ".._log[i], 35, 20+(i-min)*10, 1, 1, 0.9, .25)
		end
	end
end
l:AddCallback(ModCallbacks.MC_POST_RENDER, l.post_render)