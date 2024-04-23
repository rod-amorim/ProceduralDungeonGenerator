extends Label

@export var isPercentage:bool
@onready var slider:HSlider = $"../HSlider"

func _ready() -> void:
	if isPercentage:
		text = str(slider.value) + "%"
	else:
		text = str(slider.value)

func _on_h_slider_value_changed(value: float) -> void:
	if isPercentage:
		text = str(value) + "%"
	else:
		text = str(value)
