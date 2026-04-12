extends Control

func _ready() -> void:
	$HBoxContainer/VBoxContainer/HighScoreLevel1.text = "Highscore: %d" % Global.get_high_score(1)
	$HBoxContainer/VBoxContainer2/HighScoreLevel2.text = "Highscore: %d" % Global.get_high_score(2)

func _on_level_1_pressed() -> void:
	Global.start_game(1)


func _on_level_2_pressed() -> void:
	Global.start_game(2)
