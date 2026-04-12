extends Node

var _high_score_1 : int = 0
var _high_score_2 : int = 0
var _score : int = 0
var current_level : int = 0

func _ready() -> void:
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = load("res://Audio/Music/harp-nosink-musicv2.mp3")
	audio_player.play()
	audio_player.bus = "Music"

func add_to_score(added_points: int) -> void:
	_score += added_points
	
func get_score() -> int:
	return _score
	
func get_high_score(level: int) -> int:
	match level:
		1: return _high_score_1
		2: return _high_score_2
	return 0

func start_game(level: int) -> void:
	_score = 0
	match level:
		1:
			current_level = 1
			TransitionManager.change_scene("res://Levels/DomTest.tscn")
		2: 
			current_level = 2
			TransitionManager.change_scene("res://Levels/FabioTest.tscn")
	

func end_game() -> void:
	match current_level:
		1: if _high_score_1 < _score:
				_high_score_1 = _score
		2: if _high_score_2 < _score:
				_high_score_2 = _score
				
	TransitionManager.change_scene("res://UI/EndScreen.tscn")
