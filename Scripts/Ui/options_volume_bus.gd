extends Node
@onready 
var optionButton :HSlider = $HboxContainer/HSlider

@export
var busId : int

@export
var playerPrefsPropertyName : String

var playerPrefs:PlayerPreferences

func _ready() -> void:
	playerPrefs = PlayerPreferences.instance()
	optionButton.value_changed.connect(apply)
	LoadPreferences()

func apply(value : float):
	var remapValue = GameManager.remapValue(optionButton.min_value,optionButton.max_value,0,1,value)
	AudioServer.set_bus_volume_db(busId, linear_to_db(remapValue))
	SavePreferences()

func LoadPreferences():
	optionButton.value = playerPrefs.get(playerPrefsPropertyName)
	
func SavePreferences():
	playerPrefs.set(playerPrefsPropertyName,optionButton.value)
	playerPrefs.save()
