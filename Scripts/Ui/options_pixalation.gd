extends Node
@onready var optionButton :HSlider = $HboxContainer/HSlider

var playerPrefs:PlayerPreferences

func _ready() -> void:
	playerPrefs = PlayerPreferences.instance()
	
	optionButton.value_changed.connect(applyPixelation)
	
	LoadPreferences()

func applyPixelation(_valueChanged : bool):
	RenderingServer.global_shader_parameter_set("PixalationAmount",optionButton.value)
	SavePreferences()

func LoadPreferences():
	optionButton.value = playerPrefs.pixalationAmount
	RenderingServer.global_shader_parameter_set("PixalationAmount",playerPrefs.pixalationAmount)
	
func SavePreferences():
	playerPrefs.pixalationAmount = optionButton.value
	playerPrefs.save()
