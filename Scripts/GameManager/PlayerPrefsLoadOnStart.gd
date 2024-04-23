extends Node

var playerPrefs:PlayerPreferences

func _ready() -> void:
	playerPrefs = PlayerPreferences.instance()
	setFullscreen()
	setPixelationAmount()
	setMouseScale()
	setAudioVolumes()
	
	GameManager.centerScreen()

func setFullscreen():
	var winMode
	var targetRes
	if playerPrefs.fullscreen:
		winMode = DisplayServer.WINDOW_MODE_FULLSCREEN
		targetRes = DisplayServer.window_get_size()
	else: 
		winMode = DisplayServer.WINDOW_MODE_WINDOWED
		targetRes = DisplayServer.window_get_size() / 1.5
		
	DisplayServer.window_set_mode(winMode)
	DisplayServer.window_set_size(targetRes)
		
func setPixelationAmount():
	RenderingServer.global_shader_parameter_set("PixalationAmount",playerPrefs.pixalationAmount)

func setMouseScale():
	PlayerManager.SENSITIVITY_SCALE = playerPrefs.mouseSensibilityMultiplier
	
func setAudioVolumes():
	var remapMaster = GameManager.remapValue(0,100,0,1, playerPrefs.masterVolume)
	AudioServer.set_bus_volume_db(0,linear_to_db(remapMaster))
	var remapBGM = GameManager.remapValue(0,100,0,1, playerPrefs.BGMVolume)
	AudioServer.set_bus_volume_db(1,linear_to_db(remapBGM))
	var remapSFX = GameManager.remapValue(0,100,0,1, playerPrefs.SFXVolume)
	AudioServer.set_bus_volume_db(2,linear_to_db(remapSFX))
