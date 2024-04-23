extends Node

var playerData : PlayerData
var playerNode : Node3D
var playerStateMachine : PlayerStateMachine
var playerMovement : PlayerMovement
var mouseLook : MouseLook

var SENSITIVITY_SCALE : float = 0

func register_player_data(instance):
	playerData = instance

func register_player_node(instance):
	playerNode = instance

func register_player_state_machine(instance):
	playerStateMachine = instance
	
func register_player_movement(instance):
	playerMovement = instance

func register_mouse_look(instance):
	mouseLook = instance
