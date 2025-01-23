extends CanvasLayer
class_name HUD

@export var low_oxygen_threshold = 20
var map_component

var _time = 0.0

func set_oxygen_bar(value: float, max_value: float):
	%OxygenBar.value = value
	%OxygenBar.max_value = max_value

func set_depth_bar(value: float, max_value: float):
	print("depth ", value/100)#, " ", max_value)
	%ProgressionSlider.value = 1 - value/max_value
	%ProgressCounter.text = "{0} m".format([round(value/100)])

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
	
