extends Component
class_name CaptureOxygenComponent

@export var hitbox: HitboxComponent
@export var oxygen_capture_threshold := 0.0
@onready var bubble : CaptureBubble = %Bubble

@export_range(0.0, 3.0, 0.01) var oxygen_scale_max := 1.0
@export_range(0.0, 5.0, 0.01) var oxygen_scale_threshold := 2.0
signal on_oxygen_captured(oxygen: float)

var oxygen_captured := 0.0

func _ready():
	super()

	assert(hitbox != null, "CaptureOxygenComponent: No hitbox defined")
	hitbox.recieved_damage.connect(_on_hitbox_recieved_damage)

func _on_hitbox_recieved_damage(damager_area: Area2D, damage_amount: float):
	oxygen_captured += damage_amount
	handle_bubble_size()
	
func handle_bubble_size():
	if oxygen_captured >= oxygen_capture_threshold:
		bubble.set_size(Vector2(oxygen_scale_threshold, oxygen_scale_threshold))
	else:
		var size = (oxygen_scale_max * oxygen_captured / oxygen_capture_threshold)
		bubble.set_size(Vector2(size, size))
	pass
