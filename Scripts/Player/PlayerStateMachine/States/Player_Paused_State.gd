extends State
class_name PlayerPausedState

var playerMovement:PlayerMovement
var mouseLook:MouseLook

func _ready() -> void:
	playerMovement = PlayerManager.playerMovement
	mouseLook = PlayerManager.mouseLook

func enter():
	playerMovement.enabled = false
	mouseLook.enabled = false
	pass
	
func exit():
	playerMovement.enabled = true
	mouseLook.enabled = true
	pass
	
func update(_delta : float):
	pass
	
func physics_update(_delta : float):
	pass


