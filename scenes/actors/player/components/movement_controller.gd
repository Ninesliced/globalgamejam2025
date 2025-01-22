extends Node

var player : Player = null
var velocity = Vector2(0, 0)

func _ready():
	var parent = get_parent()
	if parent is Player:
		player = parent
	else:
		assert(false, "MovementController must be a child of Player")
	pass # Replace with function body.

func _process(delta):
	pass

func _physics_process(delta):
	velocity = handle_movement(delta, player.velocity)
	player.velocity = velocity



func handle_movement(delta,velocity):
	var new_velocity = Vector2(0, 0)
	var vec = Input.get_vector("left", "right", "up", "down")

	vec = vec.normalized()
	if vec.x > 0:
		player.sprite.flip_h = false
		if %OxygenBar != null:
			%OxygenBar.visible = true
		if %OxygenBar2 != null:
			%OxygenBar2.visible = false
	else:
		player.sprite.flip_h = true
		if %OxygenBar != null:
			%OxygenBar.visible = false
		if %OxygenBar2 != null:
			%OxygenBar2.visible = true
	if vec != Vector2(0, 0):
		new_velocity = velocity.move_toward(vec * player.speed, player.acceleration * delta)
	else:
		new_velocity = velocity.move_toward(Vector2(0, 0), player.friction * delta)
	
	return new_velocity
