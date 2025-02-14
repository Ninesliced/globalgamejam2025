extends CanvasLayer
class_name HUD

@export var low_oxygen_threshold: int = 20
var map_component

var _time := 0.0

func set_oxygen_bar(value: float, max_value: float):
	%OxygenBar.value = value
	%OxygenBar.max_value = max_value

func set_depth_bar(value: float, max_value: float):
	%ProgressionSlider.value = 1 - value/max_value

	var map := get_tree().current_scene
	%ProgressCounter.text = "{0} m".format([round(value/100),])
	if map:
		%ZoneCounter.text = "Zone {0}".format([map.current_level])

func set_timer(value: float):
	var minutes := int(value/60)
	var seconds := fmod(value, 60.0)
	%Timer.text = "TIMER : %d:%.2f" % [minutes, seconds]

func _process(delta):
	_time += delta

	if %OxygenBar.value <= low_oxygen_threshold:
		if fmod(_time, 0.2) < 0.1:
			%OxygenBar.modulate = Color("ff863b")
		else:
			%OxygenBar.modulate = Color("ffb282")
	else:
		%OxygenBar.modulate = Color.WHITE

	# Depth
	# TODO
	
