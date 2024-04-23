extends State

class_name GamePlayState

var playerStateMachie:PlayerStateMachine
	
func _ready() -> void:
	playerStateMachie = PlayerManager.playerStateMachine
	
func enter():
	playerStateMachie.current_state.Transitioned.emit(playerStateMachie.current_state,"PlayerIdle")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func exit():
	pass
func update(delta):
	if Input.is_action_just_pressed("OpenMenu"):
		Transitioned.emit(self, "InOptionsMenu")

func physics_update(_delta : float):
	pass
