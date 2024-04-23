extends Node
class_name GameStateMachine

@export var initial_state : State

var current_state : State
var states :Dictionary = {}

func _ready():
	GameManager.register_game_state_machine(self)
	
	for child in get_children():
		states[child.name.to_lower()] = child
		child.Transitioned.connect(on_child_transition)
		
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		

func _process(delta):
	if current_state:
		current_state.update(delta)
	
func _input(event: InputEvent) -> void:
	if current_state.name == "Gameplay":
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
		
func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
	
	current_state = new_state

