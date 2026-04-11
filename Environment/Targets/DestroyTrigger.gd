extends Node

@export var PointsAddedWhenDestroyed : int = 50

func Trigger(node: Node) -> void:
	
	Global.add_to_score(PointsAddedWhenDestroyed)
	
	get_parent().queue_free()
