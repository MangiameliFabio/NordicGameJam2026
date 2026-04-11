extends Control

func _process(delta: float) -> void:
	$MarginContainer/Label.text = "Score: %d" % Global.get_score()
