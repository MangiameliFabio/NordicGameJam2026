extends Control

func _ready() -> void:
	$VBoxContainer/Score.text = "%d" % Global.get_score()


func _on_restart_button_pressed() -> void:
	TransitionManager.change_scene("res://Character/CharacterTesting.tscn")


func _on_main_menu_pressed() -> void:
	TransitionManager.change_scene("res://Character/MainMenu.tscn")
