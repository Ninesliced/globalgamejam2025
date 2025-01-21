extends Component
class_name CaptureOxygenComponent

@export var hitbox: HitboxComponent
@export var oxygen_capture_threshold := 0.0

var oxygen_captured := 0.0

func _ready():
	super()

	assert(hitbox != null, "CaptureOxygenComponent: No hitbox defined")
	hitbox.recieved_damage.connect(_on_hitbox_recieved_damage)

func _on_hitbox_recieved_damage(damager_area: Area2D, damage_amount: float):
	oxygen_captured += damage_amount