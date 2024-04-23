class_name PlayerPreferences extends Resource

const FILE_PATH = "user://player_prefs.tres"

@export var resolution_x : int = 1920
@export var resolution_y : int = 1080

@export var fullscreen : bool = 1

@export var pixalationAmount : int = 60

@export var mouseSensibilityMultiplier : float = 1

@export var masterVolume : float = 100
@export var BGMVolume : float = 100
@export var SFXVolume : float = 100

func save() -> void:
	ResourceSaver.save(self, "user://player_prefs.tres")
	
static func instance() -> PlayerPreferences:
	var res : PlayerPreferences = load("user://player_prefs.tres") as PlayerPreferences
	if !res:
		res = PlayerPreferences.new()
	return res

