extends RayCast3D

@export var prompt:Label;
var playerStateMachine : PlayerStateMachine
@onready var player: CharacterBody3D = $"../../.."

func _ready():
	playerStateMachine = PlayerManager.playerStateMachine
	add_exception(owner)
	enabled = true

func _physics_process(delta):
	prompt.text = ""
	if !player.is_on_floor():
		return
		
	if is_colliding():
		if get_collider() is Interactable: 
			var detected : Interactable = get_collider()
			if detected is Interactable:
				prompt.text = detected.GetPrompt()
				
				if playerStateMachine.current_state.name == "PlayerPausedState" :
					return
					

					
				if Input.is_action_just_pressed("Use_Weapon"):
					detected.Interact(detected)
