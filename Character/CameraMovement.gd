#extends Camera3D
#
#@export var InputManager : InputManagerComponent
#@export var MouseSensitivity : float = 1
#@export var MaxTiltAngle : float = 3
#@export var TiltAcceleration : float = 1
#
#func _process(delta: float) -> void:
	#if InputManager == null:
		#return
#
	#var player_body := get_parent() as Node3D
	#if player_body != null:
		#player_body.rotation.y = InputManager.LookYaw
#
	#rotation.x = InputManager.LookPitch
#
	#var hMovement : float = InputManager.HMovementAxis
	#if not is_zero_approx(hMovement):
		#if hMovement > 0:
			#rotation.z -= delta * TiltAcceleration
		#elif hMovement < 0:
			#rotation.z += delta * TiltAcceleration
		#var max_tilt_rad = deg_to_rad(MaxTiltAngle)
		#rotation.z = clamp(rotation.z, -max_tilt_rad, max_tilt_rad)
	#else:
		#if is_zero_approx(rotation.z):
			#rotation.z = 0
		#elif rotation.z > 0:
			#rotation.z -= delta * TiltAcceleration
		#elif rotation.z < 0:
			#rotation.z += delta * TiltAcceleration
	#
	#position.y = sin(Time.get_unix_time_from_system()) * 0.1
	#
	#
extends Node3D

@export var player: CharacterBody3D
@export var camera: Camera3D
@export var InputManager : InputManagerComponent

@export var bob_strength: float = 0.045
@export var bob_side_strength: float = 0.02
@export var tilt_strength: float = 1.5
@export var step_frequency: float = 1.8
@export var min_speed_for_bob: float = 0.15

@export var pos_stiffness: float = 18.0
@export var pos_damping: float = 10.0
@export var rot_stiffness: float = 14.0
@export var rot_damping: float = 9.0

@export var landing_bounce_strength: float = 0.06
@export var landing_min_fall_speed: float = 4.0

var _step_phase := 0.0
var _was_on_floor := false

var _pos_offset := Vector3.ZERO
var _pos_velocity := Vector3.ZERO
var _rot_offset := Vector3.ZERO
var _rot_velocity := Vector3.ZERO

var _base_position := Vector3.ZERO
var _base_rotation := Vector3.ZERO

func _ready() -> void:
	_base_position = position
	_base_rotation = rotation
	if player:
		_was_on_floor = player.is_on_floor()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	if InputManager == null:
		return

	if player != null:
		player.rotation.y = InputManager.LookYaw
	
	rotation.x = InputManager.LookPitch

	var horizontal_velocity := Vector3(player.velocity.x, 0.0, player.velocity.z)
	var speed : float = horizontal_velocity.length()
	var grounded : bool = player.is_on_floor()

	if not _was_on_floor and grounded and player.velocity.y <= -landing_min_fall_speed:
		_pos_velocity.y -= landing_bounce_strength

	_was_on_floor = grounded

	var target_pos := Vector3.ZERO
	var target_rot := Vector3.ZERO

	if grounded and speed > min_speed_for_bob:
		var move_alpha : float = clamp(speed / 7.0, 0.0, 1.0)
		_step_phase += delta * speed * step_frequency

		var vertical_bob : float = sin(_step_phase * TAU) * bob_strength * move_alpha
		var lateral_bob : float = cos(_step_phase * TAU * 0.5) * bob_side_strength * move_alpha

		target_pos.y = vertical_bob
		target_pos.x = lateral_bob

		var local_vel := player.global_transform.basis.inverse() * horizontal_velocity
		target_rot.z = deg_to_rad(-local_vel.x * tilt_strength)
		target_rot.x = deg_to_rad(-vertical_bob * 20.0)
	else:
		_step_phase = fmod(_step_phase, 1.0)

	# Position spring
	var pos_force := (target_pos - _pos_offset) * pos_stiffness
	_pos_velocity += pos_force * delta
	_pos_velocity -= _pos_velocity * pos_damping * delta
	_pos_offset += _pos_velocity * delta

	# Rotation spring
	var rot_force := (target_rot - _rot_offset) * rot_stiffness
	_rot_velocity += rot_force * delta
	_rot_velocity -= _rot_velocity * rot_damping * delta
	_rot_offset += _rot_velocity * delta

	position = _base_position + _pos_offset
	rotation = _base_rotation + _rot_offset
