extends MeshInstance3D
@export var open_speed = 2.0
@onready var door_stream: AudioStreamPlayer3D = $"../DoorStream"

var door
var openDotProduct

func _on_static_body_3d_interacted(body: StaticBody3D):
	door = body.get_parent()
	var playerForwardDir: Vector3 = PlayerManager.playerNode.global_transform.basis.z.normalized()
	var thisDoorForward: Vector3 = door.global_transform.basis.z.normalized()
	openDotProduct = playerForwardDir.dot(thisDoorForward)
	openDoor()
	door_stream.play()

func openDoor():
	var tween = get_tree().create_tween()
	var targetRot
	if openDotProduct > 0:
		targetRot = Vector3(0,deg_to_rad(-90),0)
	else:
		targetRot = Vector3(0,deg_to_rad(90),0)
	
	tween.tween_property(door,"rotation",targetRot,2).set_ease(Tween.EASE_IN)
