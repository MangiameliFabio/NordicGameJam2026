extends AudioStreamPlayer3D

@export var RumbleAudio : AudioStream
@export var CollapseAudio : AudioStream
@export var Platform : DisappearingPlatform

func _ready() -> void:
	Platform.rumble_start.connect(_on_rumble_start)
	Platform.collapse_start.connect(_on_collapse_start)

func _on_rumble_start() -> void:
	stream = RumbleAudio
	pitch_scale = randf_range(0.9, 1.1)
	play(0.2)


func _on_collapse_start() -> void:
	stream = CollapseAudio
	pitch_scale = randf_range(0.9, 1.1)
	play()
