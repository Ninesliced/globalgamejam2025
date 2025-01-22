@icon("res://_engine/icons/node_2D/icon_bubble.png")
extends Component
class_name OxygenComponent

signal run_out_of_oxygen

@export var max_oxygen := 100.0
@export var initial_oxygen := 100.0
var oxygen := 0.0:
	set(value):
		oxygen = max(0.0, value)

@export var consumption_speed := 30.0

func _ready():
	super()
	oxygen = initial_oxygen

func _process(delta):
	oxygen -= consumption_speed * delta
	if oxygen <= 0.0:
		run_out_of_oxygen.emit()

func add_oxygen(value: float):
	oxygen += value
