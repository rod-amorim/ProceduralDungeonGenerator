extends CharacterBody3D


func _ready():
	PlayerManager.register_player_node(self)
