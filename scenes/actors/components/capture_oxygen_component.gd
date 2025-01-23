@tool
@icon("res://_engine/icons/node_2D/icon_o2_capture.png")
extends Component
class_name CaptureOxygenComponent

signal oxygen_recieved(oxygen: float)
signal captured

@export var hitbox: HitboxComponent
@export var capture_threshold := 10.0
@export var bubble_texture: Texture2D:
	set(value):
		bubble_texture = value
		%Bubble.texture = value

@onready var bubble : CaptureBubble = %Bubble

@export_range(0.0, 3.0, 0.01) var bubble_scale_max := 1.0
@export_range(0.0, 5.0, 0.01) var bubble_scale_threshold := 2.0

var oxygen_stored := 0.0
var is_captured = false

func _ready():
	if Engine.is_editor_hint(): return
	super()

	assert(hitbox != null, "CaptureOxygenComponent: No hitbox defined")
	hitbox.recieved_damage.connect(_on_hitbox_recieved_damage)


func _process(delta):
	if Engine.is_editor_hint(): return
	var old_is_captured = is_captured
	is_captured = (oxygen_stored >= capture_threshold)

	if is_captured:
		get_parent().rotate(delta * 0.3)

	if not old_is_captured and is_captured:
		captured.emit()


func _on_hitbox_recieved_damage(damager_area: Area2D, damage_amount: float):
	if not is_captured:
		oxygen_stored += damage_amount
	handle_bubble_size()

	$InflateSound.play()

func handle_bubble_size():
	if is_captured:
		bubble.set_size(Vector2(bubble_scale_threshold, bubble_scale_threshold))
	else:
		var size = (bubble_scale_max * oxygen_stored / capture_threshold)
		bubble.set_size(Vector2(size, size))
