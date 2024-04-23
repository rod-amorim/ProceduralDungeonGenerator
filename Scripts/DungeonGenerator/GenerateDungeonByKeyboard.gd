extends Node

@export var dungeonGenerationScript:Node3D

func _process(delta):
	if Input.is_action_just_pressed("GenerateDungeon"):
		dungeonGenerationScript.Start()
