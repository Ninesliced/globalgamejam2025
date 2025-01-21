extends Node2D

var player : Player = null
var velocity = Vector2(0, 0)

enum DashMode {
	EIGHT_WAY,
	MOUSE,
}

@export var dash_consumption = 10
@export var dash_force = 1000
@export var dash_mode : DashMode = DashMode.MOUSE
func _ready():
	var parent = get_parent()
	if parent is Player:
		player = parent
	else:
		assert(false, "dash component must be a child of Player")
	pass


func _process(delta):
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("dash"):
		player.velocity = dash(player.velocity)
	pass

func dash(velocity) -> Vector2:
	var vec = Vector2(0, 0)
	if dash_mode == DashMode.MOUSE:
		var mouse_position = get_global_mouse_position()
		vec = (mouse_position - player.global_position).normalized()
	return velocity + vec * dash_force
	pass
	