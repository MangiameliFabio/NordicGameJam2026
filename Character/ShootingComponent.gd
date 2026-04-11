class_name ShootingComponent extends Node

@export var InputManager : InputManagerComponent
@export var BulletScene : PackedScene

func _process(delta: float) -> void:
	if not InputManager.ShootPressState:
		pass
