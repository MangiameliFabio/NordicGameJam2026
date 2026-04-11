extends Node3D

@export var ObjectToTrigger : Node
@export var TargetArea : Area3D
@export var DestroyAfterHit : bool = true

func _ready() -> void:
	TargetArea.area_entered.connect(_on_area_entered)
	


func _on_area_entered(area: Node3D) -> void:
	var trigger_object : Node = null
	if ObjectToTrigger.has_method("Trigger"):
		trigger_object = ObjectToTrigger
	else:
		for child in ObjectToTrigger.get_children():
			if child.has_method("Trigger"):
				trigger_object = child
	
	if trigger_object == null:
		printerr("Ther is not trigger function on the object to trigger")
		return
	
	trigger_object.Trigger(get_parent())
	
	if DestroyAfterHit:
		queue_free()
