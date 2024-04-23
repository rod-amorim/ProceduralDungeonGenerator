class_name ScreenModeOption extends Control

@onready var optionButton :CheckBox = $HboxContainer/CheckBox

var playerPrefs:PlayerPreferences

func _ready():
	playerPrefs = PlayerPreferences.instance()
	optionButton.button_up.connect(on_win_mode_selected)
	LoadPreferences()

func on_win_mode_selected():
	var winMode
	var targetRes
	if optionButton.button_pressed:
		winMode = DisplayServer.WINDOW_MODE_FULLSCREEN
		targetRes = DisplayServer.window_get_size()
	else: 
		winMode = DisplayServer.WINDOW_MODE_WINDOWED
		targetRes = DisplayServer.window_get_size() / 1.5
		
	DisplayServer.window_set_mode(winMode)
	DisplayServer.window_set_size(targetRes)
	GameManager.centerScreen()
	SavePreferences(winMode)

func LoadPreferences():
	optionButton.button_pressed = playerPrefs.fullscreen
	var winMode
	if playerPrefs.fullscreen:
		winMode = DisplayServer.WINDOW_MODE_FULLSCREEN
	else: 
		winMode = DisplayServer.WINDOW_MODE_WINDOWED
		
	DisplayServer.window_set_mode(winMode)

func SavePreferences(winModeId: int):
	playerPrefs.fullscreen = winModeId
	playerPrefs.save()
	

