class_name DisappearingPlatform extends AnimatableBody3D

@export_category("Platform Movement")
@export var TimeTilCollapse : float = 2
@export var CollapseMaxSpeed : float = 5
@export var CollapseAcceleration : float = 2
@export var TimeTilDespawn : float = 5

@export_category("Platform Rumble")
@export var PlatformMesh: MeshInstance3D
@export var RumbleStrength := 0.04
@export var CollapseRumbleStrength := 0.08
@export var RumbleSpeed := 7.0

var _collapsing : bool = false
var _collapsing_triggered : bool = false
var _collapse_speed := 0.0
var _base_mesh_position: Vector3
var _noise := FastNoiseLite.new()
var _time := 0.0

func _ready() -> void:
	_base_mesh_position = PlatformMesh.position
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noise.frequency = 0.8

func CollapsePlatform() -> void:
	if _collapsing or _collapsing_triggered:
		return
	
	_collapsing_triggered = true
	
	await get_tree().create_timer(TimeTilCollapse).timeout

	_collapsing = true
	
	await get_tree().create_timer(TimeTilDespawn).timeout
	
	queue_free()


func _physics_process(delta: float) -> void:
	if _collapsing:
		_collapse_speed = min(_collapse_speed + CollapseAcceleration * delta, CollapseMaxSpeed)
		global_position += Vector3.DOWN * _collapse_speed * delta

func _process(delta: float) -> void:
	if _collapsing_triggered:
		_time += delta * RumbleSpeed
		var rumble_strength = CollapseRumbleStrength if _collapsing else RumbleStrength
		var shake = Vector3(
			_noise.get_noise_2d(_time, 0.0),
			_noise.get_noise_2d(0.0, _time + 17.3) * 0.2,
			_noise.get_noise_2d(_time + 43.7, 0.0)
		)

		# Add a small fast horizontal pulse so the shake reads as heavy rather than floaty.
		shake.x += sin(_time * 2.7) * 0.35
		shake.z += cos(_time * 3.1) * 0.35

		PlatformMesh.position = _base_mesh_position + shake * rumble_strength
	else:
		PlatformMesh.position = _base_mesh_position
