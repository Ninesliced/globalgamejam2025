extends Camera2D

@export var player : Player = null
@export var scale_offset = 0.2
var _center = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null:
		return
	_center = get_screen_center_position()
	if player.global_position.y > _center.y - get_viewport_rect().size.y * scale_offset:
		global_position.y = player.global_position.y + get_viewport_rect().size.y * scale_offset
