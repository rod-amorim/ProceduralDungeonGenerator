extends Node3D

@export var startRoom:Node3D

var playerStateMachine : PlayerStateMachine

func _ready() -> void:
	playerStateMachine =PlayerManager.playerStateMachine

func _on_static_body_3d_interacted(body):	
	playerStateMachine.current_state.Transitioned.emit(playerStateMachine.current_state,"PlayerPausedState")
	get_tree().current_scene.find_child("LadderSound").play()
	var lambda = func() : 	
		if startRoom:
			startRoom.queue_free()
		var mapGenerator = get_tree().current_scene.find_child("DungeonGenerator")
		mapGenerator.StartMapGeneration()
		playerStateMachine.current_state.Transitioned.emit(playerStateMachine.current_state,"PlayerIdle")
	
	GameManager.fadeScreen(lambda,1.5)


