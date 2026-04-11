extends Node

@export var PointsAddedWhenDestroyed : int = 250
@export var NeededTargets : int = 5

func Trigger(node: Node) -> void:
	
	NeededTargets -= 1
	
	if NeededTargets == 0:
		Global.add_to_score(PointsAddedWhenDestroyed)
		
		get_parent().queue_free()
