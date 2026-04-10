extends Node3D

@export var Player : CharacterBody3D
@export var Camera : Camera3D
@export var InputManager : InputManagerComponent

@export_group("Bob")
@export var BobStrength : float = 0.045
@export var BobSideStrength : float = 0.02
@export var StepFrequency : float = 1.8
@export var MinSpeedForBob : float = 0.15
@export var BobLerpSpeed : float = 10.0

@export_group("Tilt")
@export var TiltStrength : float = 1.5
@export var TiltLerpSpeed : float = 8.0

var _step_phase : float = 0.0
var _was_on_floor : bool = false
var _landing_offset_y : float = 0.0
var _camera_base_position : Vector3 = Vector3.ZERO
var _camera_base_rotation : Vector3 = Vector3.ZERO

func _ready() -> void:
	if Camera == null:
		return

	_camera_base_position = Camera.position
	_camera_base_rotation = Camera.rotation

	if Player != null:
		_was_on_floor = Player.is_on_floor()

func _physics_process(delta: float) -> void:
	if Player == null or Camera == null or InputManager == null:
		return

	Player.rotation.y = InputManager.LookYaw
	rotation.x = InputManager.LookPitch

	var horizontal_velocity := Vector3(Player.velocity.x, 0.0, Player.velocity.z)
	var grounded := Player.is_on_floor()
	var speed := horizontal_velocity.length()
	var target_position := _camera_base_position
	var target_roll := _camera_base_rotation.z

	if grounded and speed > MinSpeedForBob:
		var local_velocity := Player.global_basis.inverse() * horizontal_velocity
		var move_alpha : float = clamp(speed / max(Player.MaxMovementSpeed, 0.001), 0.0, 1.0)

		_step_phase += delta * speed * StepFrequency

		target_position.x += cos(_step_phase * TAU * 0.5) * BobSideStrength * move_alpha
		target_position.y += sin(_step_phase * TAU) * BobStrength * move_alpha
		target_roll += deg_to_rad(-local_velocity.x * TiltStrength)
	else:
		_step_phase = 0.0

	_landing_offset_y = move_toward(_landing_offset_y, 0.0, delta * BobLerpSpeed)
	target_position.y += _landing_offset_y

	Camera.position = Camera.position.lerp(target_position, delta * BobLerpSpeed)
	Camera.rotation.z = lerp_angle(Camera.rotation.z, target_roll, delta * TiltLerpSpeed)

	_was_on_floor = grounded
