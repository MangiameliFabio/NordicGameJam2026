extends Node

var _high_score : int = 0
var _score : int = 0

func add_to_score(added_points: int) -> void:
	_score += added_points
	
func get_score() -> int:
	return _score
	
func get_high_score() -> int:
	return _high_score

func start_game() -> void:
	_score = 0
	TransitionManager.change_scene("res://Levels/FabioTest.tscn")

func end_game() -> void:
	if _high_score < _score:
		_high_score = _score
	TransitionManager.change_scene("res://UI/EndScreen.tscn")
