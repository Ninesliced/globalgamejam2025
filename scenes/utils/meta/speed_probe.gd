extends Node

@export var test_time: float = 0.5
@export var test_rate: float = 0.1
@export var framerate_threshold: int = 60

signal slowness_detected


@onready var timer = $Timer

var fps_average := 1.0
var fps_samples := 0
var tot_delta   := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = test_time
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer.is_stopped():
		return
		
	fps_samples += 1
	tot_delta   += delta
	
	fps_average = fps_samples / tot_delta / 1.0
	
	print("On average: ", fps_average, " with ", fps_samples, " samples")


func _on_timer_timeout() -> void:
	if fps_average > framerate_threshold:
		return

	slowness_detected.emit()
	print("Computer too slow, was doing ", fps_average, " FPS which is below ", framerate_threshold)
