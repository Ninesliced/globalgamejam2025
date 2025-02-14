extends Node2D
class_name AutodeleteNode

@export_range(0, 1000000000, 0.01, "suffix:s") var delete_time = 3.0

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = delete_time
	timer.start()
	timer.timeout.connect(func():
		queue_free()
	)
