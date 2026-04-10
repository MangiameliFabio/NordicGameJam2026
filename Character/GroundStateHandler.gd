class_name GroundStateHandler extends Area3D

enum GroundStates {
	Air,
	Ground
}

var _previous_state : GroundStates

signal state_change(state: GroundStateHandler)

var GroundState : GroundStates

func _physics_process(_delta: float) -> void:
	var bodies : Array[Node3D] = get_overlapping_bodies()
	
	if bodies.is_empty():
		GroundState = GroundStates.Air
	else:
		GroundState = GroundStates.Ground
	
	if _previous_state != GroundState:
		state_change.emit(GroundState)
	
	_previous_state = GroundState
