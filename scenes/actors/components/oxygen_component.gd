@icon("res://_engine/icons/node_2D/icon_o2.png")
extends Component
class_name OxygenComponent

signal run_out_of_oxygen	
	
@export var max_oxygen := 100.0
@export var initial_oxygen := 100.0
var oxygen := 0.0:
	set(value):
		oxygen = clamp(0.0, value, max_oxygen)
		# change_oxygen_bar()	

@export var consumption_speed := 30.0

func _ready():
	super()
	oxygen = initial_oxygen

func _process(delta):
	if get_parent().get_parent() is Map:
		var map: Map = get_parent().get_parent()
		if not map.is_on_a_level:
			return
	
	oxygen -= consumption_speed * delta
	if oxygen <= 0.0:
		run_out_of_oxygen.emit()

func add_oxygen(value: float):
	if get_parent().get_parent() is Map:
		var map: Map = get_parent().get_parent()
		if value <= 0 and not map.is_on_a_level:
			return
	
	oxygen += value

func change_oxygen_bar():
	var gradient = %OxygenBar.texture.gradient
	gradient.set_offset(1, oxygen/max_oxygen)
	# Les 2 oxygen bar ont la m^me texture
