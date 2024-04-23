extends ColorRect

@export var dungeonGenerator : Node3D
@export var offset : Vector2

func _process(delta):
	var playerPos =PlayerManager.playerNode.global_position
	var pos2d = Vector2i(playerPos.x *offset.x +1 ,playerPos.z*offset.y+1)
	set_position(pos2d)
