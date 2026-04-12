extends AudioStreamPlayer3D

@export var PlayerMovment : CharacterBody3D

var _last_step_time : float

func _process(delta: float) -> void:
	if PlayerMovment.velocity.length_squared() > 0 and PlayerMovment.is_on_floor():
		if _last_step_time + 250 < Time.get_ticks_msec():
			play()
			_last_step_time = Time.get_ticks_msec()
