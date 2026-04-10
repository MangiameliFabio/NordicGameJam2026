class_name InputManagerComponent extends Node

@export var LookSpeedH : float = 1.0
@export var LookSpeedV : float = 1.0
@export var LookAngleCapV : Vector2 = Vector2(-80, 80)

var HMovementAxis : float
var VMovementAxis : float
var JumpPressState : bool
var SprintPressState : bool
var ShootPressState : bool

var MouseRelative : Vector2
var ForwardDirection : Vector3 = Vector3.FORWARD
var LookYaw : float = 0.0
var LookPitch : float = 0.0

var _mouse_sensitivity : float = 0.001

signal JumpPressed

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_update_input_state()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		MouseRelative = event.relative
		LookYaw -= MouseRelative.x * LookSpeedH * _mouse_sensitivity
		LookPitch = clamp(
			LookPitch - MouseRelative.y * LookSpeedV * _mouse_sensitivity,
			deg_to_rad(LookAngleCapV.x),
			deg_to_rad(LookAngleCapV.y)
		)
		ForwardDirection = (
			Quaternion(Vector3.UP, LookYaw) *
			Quaternion(Vector3.RIGHT, LookPitch)
		) * Vector3.FORWARD

func _process(_delta: float) -> void:
	_update_input_state()

func _update_input_state() -> void:
	HMovementAxis = Input.get_axis(&"StrafeLeft", &"StrafeRight")
	VMovementAxis = Input.get_axis(&"Backward", &"Forward")
	JumpPressState = Input.is_action_pressed("Jump")
	if JumpPressState:
		JumpPressed.emit()
	SprintPressState = Input.is_action_pressed("Sprint")
	ShootPressState = Input.is_action_pressed("Shoot")
