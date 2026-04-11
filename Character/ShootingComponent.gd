class_name ShootingComponent extends Node

@export var InputManager : InputManagerComponent
@export var BulletScene : PackedScene
@export var BulletSpawn : Marker3D
@export var BulletSpeed : float = 30
@export var ShootSpeed : float = 100
@export var FullAuto : bool = false

var _last_shoot = 0
var _previous_shoot_state : bool

func _process(delta: float) -> void:
	if InputManager.ShootPressState:
		if FullAuto:
			if _last_shoot + ShootSpeed < Time.get_ticks_msec():
				var bullet : Bullet = BulletScene.instantiate()
				get_tree().root.add_child(bullet)
				bullet._velocity = InputManager.ForwardDirection * BulletSpeed
				bullet.global_position = BulletSpawn.global_position
				_last_shoot = Time.get_ticks_msec()
		else:
			if _previous_shoot_state != InputManager.ShootPressState:
				var bullet : Bullet = BulletScene.instantiate()
				get_tree().root.add_child(bullet)
				bullet._velocity = InputManager.ForwardDirection * BulletSpeed
				bullet.global_position = BulletSpawn.global_position
				_last_shoot = Time.get_ticks_msec()
	_previous_shoot_state = InputManager.ShootPressState
