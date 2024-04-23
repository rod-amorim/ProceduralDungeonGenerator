extends Node3D

func _ready():
	PlayerManager.playerNode.position = global_position
	PlayerManager.playerNode.rotation.y = rotation.y + deg_to_rad(180)
