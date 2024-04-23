extends Node

class_name PlayerMovement

@onready var playerAudioStreamer: AudioStreamPlayer3D = $"../PlayerAudioStreamer_Footsteps"
@onready var player_audio_streamer_jump: AudioStreamPlayer3D = $"../PlayerAudioStreamer_Jump"
@onready var player_audio_streamer_land: AudioStreamPlayer3D = $"../PlayerAudioStreamer_Land"

@export var characterBody3d: CharacterBody3D
@export var applyGravity: bool
@export var playerHead: Node3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const bob_freq = 3
const bob_amp = .08
var t_bob = 0

var moveSpeed
var jumpVelocity

var enabled = true

var canPlayFootstep : bool
var canPlayLandSound : bool

func _ready():
	PlayerManager.register_player_movement(self)
	moveSpeed = PlayerManager.playerData.MoveSpeed
	jumpVelocity = PlayerManager.playerData.JumpVelocity

func _physics_process(delta):
	if !enabled:
		playerHead.transform.origin = lerp(playerHead.transform.origin,Vector3.ZERO,delta*4 )
		return
		
	if Input.is_action_pressed("Sprint"):
		moveSpeed = PlayerManager.playerData.RunSpeed
	else:
		moveSpeed = PlayerManager.playerData.MoveSpeed
	
	if !characterBody3d.is_on_floor() && applyGravity:			
		characterBody3d.velocity.y -= gravity * delta
		
	if characterBody3d.is_on_floor() and canPlayLandSound:
		canPlayLandSound = false
		player_audio_streamer_land.play()

	if Input.is_action_just_pressed("Jump") and characterBody3d.is_on_floor():
		canPlayLandSound = true
		player_audio_streamer_jump.play()
		characterBody3d.velocity.y = jumpVelocity

	var input_dir = Input.get_vector("Strafe_Left", "Strafe_Right", "Move_Forward", "Move_Back")
	var direction = (characterBody3d.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if characterBody3d.is_on_floor():
		if direction:
			characterBody3d.velocity.x = direction.x * moveSpeed
			characterBody3d.velocity.z = direction.z * moveSpeed
		else:
			characterBody3d.velocity.x = 0
			characterBody3d.velocity.z = 0
	else:
		characterBody3d.velocity.x = lerp(characterBody3d.velocity.x, direction.x * moveSpeed, delta * 3)
		characterBody3d.velocity.z = lerp(characterBody3d.velocity.z, direction.z * moveSpeed, delta * 3)

	if direction == Vector3.ZERO:
		t_bob = 0
		playerHead.transform.origin = lerp(playerHead.transform.origin,Vector3.ZERO,delta*4 )
	else:
		t_bob += delta * characterBody3d.velocity.length() * float(characterBody3d.is_on_floor())
		playerHead.transform.origin = processBob()

	characterBody3d.move_and_slide()

func processBob() -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(t_bob * bob_freq) * bob_amp
	
	if pos.y < -0.05 and canPlayFootstep:
		canPlayFootstep = false
		playerAudioStreamer.play()
	elif pos.y > -0.05 and !canPlayFootstep:
		canPlayFootstep = true
		
	return pos
