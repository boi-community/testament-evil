local debug = gunmod_SET and gunmod_SET.DebugMode or false

gunmod_SET = gunmod_SET or {
  DebugMode = debug,
  Difficulty = 4,
  CurseOfDarkness = 1, -- 'never', 'sometimes', 'always'
  DamageSpread = 1, -- off, low, high
  HudOpacity = 3, -- off, 25, 50, 75, 100
  ShowStats = 3, -- never, stat change, any change, always
  ShowGunCursor = 3, -- 'never', 'fullscreen', 'always', 'always+'
  QuickSwitchFrames = 15,
  MerchantVoice = 2, -- 'never', 'some', 'spam', 'superspam'
  LightingSaturation = 4,
  ShotFlashBrightness = 4, -- 0, 25, 50, 75, 100
  GoreLimit = 1,
  BarThin = 1,

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
