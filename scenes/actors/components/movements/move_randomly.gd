extends MovementComponent

@export var speed_range : Vector2i = Vector2i(400, 600)
@export var rotation_speed_interval : float = 0.5
@export var speed_change_interval : float = 1.0

@onready var timer : Timer = $Timer
@onready var panic_zone : CollisionShape2D = %Shape

var target_point : Vector2
var direction : float = 0.0


func _process(delta: float) -> void:
	if not parent:
		return
	
	if (target_point.x == 0 and target_point.y == 0) or parent.global_position.distance_to(target_point) < 100:
		target_point = find_new_target()

	var target_dir: float = (target_point - parent.global_position).angle()
	direction = lerp_angle(direction, target_dir, rotation_speed_interval * delta)
	
	speed = lerp(speed, randf_range(speed_range.x, speed_range.y), speed_change_interval * delta)
	
	var movement := Vector2(speed, 0).rotated(direction) * delta
	parent.position += movement
	parent.move_and_slide()


func get_camera_bounds() -> Rect2:
	var map : Map = get_tree().get_root().get_node("Map") as Map
	var viewport : Rect2 	= map.camera.get_viewport_rect()
	var camera_pos: Vector2 = map.camera.global_position
	return Rect2(camera_pos - viewport.size / 2, viewport.size)
	

func get_level_bounds() -> Rect2:
	var map : Map = get_tree().get_root().get_node("Map") as Map
	return map.get_current_level_bounds()


func find_new_target() -> Vector2:
	var bounds : Rect2 = get_level_bounds()
	return Vector2(randf_range(bounds.position.x, bounds.position.x + bounds.size.x),
					randf_range(bounds.position.y, bounds.position.y + bounds.size.y))
