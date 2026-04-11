extends Node

var _score : int = 0

func add_to_score(added_points: int) -> void:
	_score += added_points
	
func get_score() -> int:
	return _score
