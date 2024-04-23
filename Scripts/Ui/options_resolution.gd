class_name resolutionOption extends Control

@onready var optionButton :OptionButton = $HboxContainer/OptionButton

const RES_DICT: Dictionary = {
	"320 x 240 (the best one!)": Vector2i(320,240),
	"1920 x 1080": Vector2i(1920,1080),
	"1280 x 720": Vector2i(1280,720),
	"2560 x 1440": Vector2i(2560,1440),
	"3840 x 2160": Vector2i(3840,2160),
	"1600 x 900": Vector2i(1600,900),
	"1366 x 768": Vector2i(1366,768),
	"1680 x 1050": Vector2i(1680,1050),
	"1440 x 900": Vector2i(1440,900),
	"1024 x 768": Vector2i(1024,768),
	"1600 x 1200": Vector2i(1600,1200),
	"800 x 600": Vector2i(800,600),
	"1280 x 1024": Vector2i(1280,1024),
	"2560 x 1600": Vector2i(2560,1600),
	"1152 x 864": Vector2i(1152,864),
	"1920 x 1200": Vector2i(1920,1200),
	"3440 x 1440": Vector2i(3440,1440),
	"2560 x 1080": Vector2i(2560,1080),
	"1280 x 800": Vector2i(1280,800),
	"2048 x 1536": Vector2i(2048,1536),
	"1600 x 1024": Vector2i(1600,1024)
};

var playerPrefs:PlayerPreferences

func _ready() -> void:
	playerPrefs = PlayerPreferences.instance()
	add_res_items()
	optionButton.item_selected.connect(on_res_select)
	LoadPreferences()
	
func add_res_items():
	for i in RES_DICT:
		optionButton.add_item(i)
		
func on_res_select(index:int):
	var selectedRes = RES_DICT.values()[index]
	DisplayServer.window_set_size(selectedRes)
	SavePreferences(selectedRes)
	
func LoadPreferences():
	var index = 0
	for key in RES_DICT:
		var value : Vector2i = RES_DICT[key]
		if value.x == playerPrefs.resolution_x and value.y == playerPrefs.resolution_y:
			optionButton.select(index)
			DisplayServer.window_set_size(value)
			break
		index+=1
	
func SavePreferences(size: Vector2i):
	playerPrefs.resolution_x = size.x
	playerPrefs.resolution_y = size.y
	
	playerPrefs.save()
