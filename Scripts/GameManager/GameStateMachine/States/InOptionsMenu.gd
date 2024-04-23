extends State

class_name InOptionsMenu

@onready var optionsMenuAsset = preload("res://Scenes/UI/options_menu.tscn")
var optionsMenu:Node

var playerStateMachie:PlayerStateMachine

func _ready() -> void:
	playerStateMachie = PlayerManager.playerStateMachine
	
func enter():
	optionsMenu = optionsMenuAsset.instantiate()
	get_tree().current_scene.add_child(optionsMenu)
	
	playerStateMachie.current_state.Transitioned.emit(playerStateMachie.current_state,"PlayerPausedState")
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func exit():
	optionsMenu.queue_free()
	pass
func update(delta):
	if Input.is_action_just_pressed("OpenMenu"):
		Transitioned.emit(self, "Gameplay")

func physics_update(_delta : float):
	pass
	

