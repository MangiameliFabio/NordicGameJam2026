extends Node3D

@export var ObjectToTrigger : Node
@export var TargetArea : Area3D
@export var DestroyAfterHit : bool = true
@export var PointTarget : bool = false
@export var AddedPoints : int = 30

func _ready() -> void:
	TargetArea.area_entered.connect(_on_area_entered)
	


func _on_area_entered(area: Node3D) -> void:
	if PointTarget:
		Global.add_to_score(AddedPoints)
		queue_free()
		return
	var trigger_object : Node = null
	if not is_instance_valid(ObjectToTrigger):
		return
	
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
