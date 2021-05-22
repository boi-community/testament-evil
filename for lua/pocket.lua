local herblist = {"hg", "hy", "hr", "hgg", "hggg", "hgr", "hgy", "hry", "hgry", "hb", "hbb", "hgb", "hby", "hgbb", "hgby", }
local herbprice = {10, 25, 15, 15, 20, 20, 20, 35, 40, 15, 20, 20, 35, 35, 40}
local herbsell = {3, 30, 6, 6, 9, 9, 33, 36, 39, 6, 9, 9, 36, 36, 39}
local ammolist = {"am1", "am2", "am3", "am4", "am5", "am6", "am7"}
--local ammoprice = {5, 10, 10, 10, 20, 20, 20}
--local ammoprice = {5, 5, 5, 5, 5, 5, 5}
local grenadelist = {"gr", "gg", "gb"}
local grenadeitem = {"Incendiary Grenade", "Hand Grenade", "Flash Grenade"}
local herbmix = {
	hg = {hg = "hgg", hr = "hgr", hy = "hgy", hgg = "hggg", hry = "hgry", hb = "hgb", hby = "hgby"},
	hgg = {hg = "hggg"},
	hr = {hg = "hgr", hy = "hry", hgy = "hgry"},
	hy = {hg = "hgy", hr = "hry", hb = "hby", hgr = "hgry", hgb = "hgby"},
	hb = {hb = "hbb", hg = "hgb", hy = "hby", hgb = "hgbb", hgy = "hgby"},
	hbb = {hg = "hgbb"},
	hgr = {hy = "hgry"},
	hgy = {hr = "hgry", hb = "hgby"},
	hgb = {hb = "hgbb", hy = "hgby"},
	hry = {hg = "hgry"},
}

local pocketdat = {}
for i=1, #herblist do
	local str = herblist[i]
	local id = Isaac.GetCardIdByName(str)
	pocketdat[id] = {
		name = str,
		type = 'herb',
		sprite = "gfx/pocket/"..str..".png",
		price = herbprice[i],
		sell = herbsell[i],
		id = id,
	}
	pocketdat[str] = pocketdat[id]
end
for i=1, #ammolist do
	local str = ammolist[i]
	local id = Isaac.GetCardIdByName(str)
	pocketdat[id] = {
		name = str,
		type = 'ammo',
		ammotype = i,
		--price = ammoprice[i],
		sprite = "gfx/pocket/"..str..".png",
		id = id,
	}
	pocketdat[str] = pocketdat[id]
end
for i=1, #grenadelist do
	local str = grenadelist[i]
	local id = Isaac.GetCardIdByName(str)
	local collectible = Isaac.GetItemIdByName(grenadeitem[i])
	pocketdat[id] = {
		name = str,
		type = 'grenade',
		grenadetype = i,
		item = collectible,
		sprite = "gfx/pocket/"..str..".png",
		sprite2 = "gfx/pocket/"..str.."2.png",
		id = id,
	}
	pocketdat[str] = pocketdat[id]
end

gunmod_POCKET = {}
gunmod_POCKET.herblist = herblist
gunmod_POCKET.herbmix = herbmix
gunmod_POCKET.ammolist = ammolist
gunmod_POCKET.grenadelist = grenadelist
gunmod_POCKET.dat = pocketdat