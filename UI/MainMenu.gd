extends Control

func _on_start_pressed() -> void:
	TransitionManager.change_scene("res://UI/LevelSelection.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
