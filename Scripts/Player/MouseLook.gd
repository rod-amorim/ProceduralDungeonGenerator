extends Node

class_name MouseLook

@export var playerCamera:Camera3D 
@export var characterBody3d:CharacterBody3D 
@export var MIN_VERTICAL_VIEW_ANGLE = -45 
@export var MAX_VERTICAL_VIEW_ANGLE = 45
@export var SENSITIVITY = 0.005

var enabled = true

func _ready() -> void:
	PlayerManager.register_mouse_look(self)
	
func _input(event):
	if !enabled:
		return
		
	if event is InputEventMouseMotion:
		playerCamera.rotate_x(-event.relative.y * (SENSITIVITY * PlayerManager.SENSITIVITY_SCALE))
		characterBody3d.rotate_y(-event.relative.x * SENSITIVITY * PlayerManager.SENSITIVITY_SCALE)
		playerCamera.rotation.x = clamp(playerCamera.rotation.x,deg_to_rad(MIN_VERTICAL_VIEW_ANGLE),deg_to_rad(MAX_VERTICAL_VIEW_ANGLE))

