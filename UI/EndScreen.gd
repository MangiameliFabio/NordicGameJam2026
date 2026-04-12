extends Control

func _ready() -> void:
	$VBoxContainer/Score.text = "%d" % Global.get_score()
	$VBoxContainer/Score2.text = "%d" % Global.get_high_score(Global.current_level)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_restart_button_pressed() -> void:
	Global.start_game(Global.current_level)


func _on_main_menu_pressed() -> void:
	TransitionManager.change_scene("res://UI/MainMenu.tscn")
