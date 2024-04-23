extends Node
class_name PlayerData
#MOVEMEMENT
@export var MoveSpeed = 2.5
@export var RunSpeed = MoveSpeed * 2
@export var JumpVelocity = 4.5

#HP
@export var current_health = 100
@export var max_health = 100

#AMMO
@export var current_ammo = 0

#MOUSE


func _ready():
	PlayerManager.register_player_data(self)
