class_name ScreenModeOption extends Control

@onready var optionButton :OptionButton = $HboxContainer/OptionButton 

const WIN_MODE_ARRAY : Array[String] =[
	"Full-Screen",
	"Windown Mode",
	"Borderless Windown",
	"Borderless Full-screen",
]

var playerPrefs:PlayerPreferences

func _ready():
	playerPrefs = PlayerPreferences.instance()
	add_win_mode_item()
	optionButton.item_selected.connect(on_win_mode_selected)
	LoadPreferences()
	
func add_win_mode_item():
	for item in WIN_MODE_ARRAY:
		optionButton.add_item(item)

func on_win_mode_selected(index :int):
	var winMode:int = 0
	var borderless:bool = false
	
	match index:
		0: 
			winMode = DisplayServer.WINDOW_MODE_FULLSCREEN
			borderless = false
		1:
			winMode = DisplayServer.WINDOW_MODE_WINDOWED
			borderless = false
		2:
			winMode = DisplayServer.WINDOW_MODE_WINDOWED
			borderless = true
		3:
			winMode = DisplayServer.WINDOW_MODE_FULLSCREEN
			borderless = true
	
	DisplayServer.window_set_mode(winMode)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,borderless)
			
	SavePreferences(winMode, borderless)

func LoadPreferences():
	match playerPrefs.winModeIndex:
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			if playerPrefs.borderless:
				optionButton.select(3)
			else :
				optionButton.select(0)
		DisplayServer.WINDOW_MODE_WINDOWED:
			if playerPrefs.borderless:
				optionButton.select(2)
			else :
				optionButton.select(1)

func SavePreferences(winModeId: int, isBorderless: bool):
	playerPrefs.winModeIndex = winModeId
	playerPrefs.borderless = isBorderless
	
	playerPrefs.save()
