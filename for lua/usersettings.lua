local debug = gunmod_SET and gunmod_SET.DebugMode or false

gunmod_SET = gunmod_SET or {
  DebugMode = debug,
  Difficulty = 4,
  CurseOfDarkness = 2, -- 'never', 'sometimes', 'always'
  DamageSpread = 1, -- off, low, high
  HudOpacity = 50, -- off, 25, 50, 75, 100
  ShowStats = 3, -- never, stat change, any change, always
  ShowGunCursor = 3, -- 'never', 'fullscreen', 'always', 'always+'
  QuickSwitchFrames = 15,
  MerchantVoice = 2, -- 'never', 'some', 'spam', 'superspam'
  LightingSaturation = 75,
  ShotFlashBrightness = 100, -- 0, 25, 50, 75, 100
  GoreLimit = 1,
  BarThin = 1,
  ScreenShake = 1,
  MenuPalette = 1, --classic, soy milk, phd, the pact, faded polaroid, missing page, delirious, fruitcake, birthright, impish, ice tray, barfworthy, BSOD

  AlwaysLaserSight = false,
	DeadZone = .7,
	ReapplyCostume = true,
	Player1Keyboard = true,
	Player2Keyboard = false,
	HudClipWidth = 42,
	AutoReload = true,
  ShowDamageValues = false,
}

error()
