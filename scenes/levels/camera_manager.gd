extends Camera2D
class_name CameraManager

@export var player : Player = null
@export var scale_offset = 0.2
@export var shake_deceleration_speed = 50.0

var _center = Vector2(0, 0)
var _rng = RandomNumberGenerator.new()
var shake_amount = 0.0

var camera_move_here = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null:
		return
	_center = get_screen_center_position()
	if player.global_position.y > _center.y - get_viewport_rect().size.y * scale_offset:
		if camera_move_here != null:
			global_position.y = max(player.global_position.y + get_viewport_rect().size.y * scale_offset, camera_move_here)
		else: 
			global_position.y = player.global_position.y + get_viewport_rect().size.y * scale_offset

	_update_shake(delta)


func _update_shake(delta):
	shake_amount = max(0.0, shake_amount - delta * shake_deceleration_speed)
	offset = Vector2(_rng.randf_range(0, shake_amount), 0).rotated(_rng.randf_range(0, TAU))


func shake(amount: float):
	shake_amount = max(shake_amount, amount)
