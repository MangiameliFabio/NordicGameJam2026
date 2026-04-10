extends CharacterBody3D

@export var InputManager : InputManagerComponent
@export var PlayerGroundStateHandler : GroundStateHandler

@export var MaxMovementSpeed : float = 2.0
@export var JumpVelocity : float = 3.0

var _jumped : bool

func _ready() -> void:
	InputManager.JumpPressed.connect(_on_jump)

func _physics_process(delta: float) -> void:
	if InputManager == null:
		return
	
	if is_on_floor() and _jumped:
		_jumped = false

	var hMovement = InputManager.HMovementAxis
	var vMovement = InputManager.VMovementAxis
	var input_vector := Vector2(hMovement, vMovement)
	var new_velocity := Vector3.ZERO

	if input_vector.length_squared() > 0.0:
		input_vector = input_vector.normalized()
		var move_direction := (global_basis * Vector3(input_vector.x, 0.0, -input_vector.y)).normalized()
		new_velocity = move_direction * MaxMovementSpeed

	velocity.x = new_velocity.x
	velocity.z = new_velocity.z
	velocity.y += -9.81 * delta
	
	move_and_slide()

func _on_jump() -> void:
	if not _jumped:
		_jumped = true
		velocity.y = JumpVelocity
