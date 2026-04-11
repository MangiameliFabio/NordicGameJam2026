class_name Bullet extends Node3D

@export var BulletArea : Area3D

var _velocity : Vector3


func _ready() -> void:
	BulletArea.body_entered.connect(_on_body_entered)
	BulletArea.area_entered.connect(_on_area_entered)
	
	
	await get_tree().create_timer(5).timeout
	
	queue_free()


func _process(delta: float) -> void:
	look_at(global_position + _velocity, Vector3.UP)
	global_position += _velocity * delta


func _on_body_entered(body: Node3D) -> void:
	queue_free()

func _on_area_entered(area: Area3D) -> void:
	var parent : Node = area.get_parent()
	if parent.has_method("BulletEntered"):
		parent.BulletEntered(self)
