extends Node
@onready var optionButton :HSlider = $HboxContainer/HSlider

var playerPrefs:PlayerPreferences

func _ready() -> void:
	playerPrefs = PlayerPreferences.instance()
	
	optionButton.drag_ended.connect(apply)
	
	LoadPreferences()

func apply(_valueChanged : float):
	PlayerManager.SENSITIVITY_SCALE = optionButton.value 
	SavePreferences()

func LoadPreferences():
	optionButton.value = playerPrefs.mouseSensibilityMultiplier
	
func SavePreferences():
	playerPrefs.mouseSensibilityMultiplier = optionButton.value
	playerPrefs.save()
