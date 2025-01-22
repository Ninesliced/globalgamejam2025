extends Node
class_name MovementController

var player : Player = null
var velocity = Vector2(0, 0)
var can_accelerate = true
var can_decelerate = true
func _ready():
	var parent = get_parent()
	if parent is Player:
		player = parent
	else:
		assert(false, "MovementController must be a child of Player")

	
func _process(delta):
	pass

func _physics_process(delta):
	velocity = handle_movement(delta, player.velocity)
	player.velocity = velocity



func handle_movement(delta,velocity):
	var new_velocity = Vector2(0, 0)
	var vec = Input.get_vector("left", "right", "up", "down")

	vec = vec.normalized()
	# if vec.x > 0:
	# 	player.sprite.flip_h = false
	# 	$"..".is_flip_h = false
	# elif vec.x < 0:
	# 	player.sprite.flip_h = true
	# 	$"..".is_flip_h = true

	new_velocity = handle_acceleration_decceleration(delta, vec, velocity)
	return new_velocity

func handle_acceleration_decceleration(delta, vec, velocity):
	var new_velocity = Vector2(0, 0)
	if vec != Vector2(0, 0) and can_accelerate:
		new_velocity = velocity.move_toward(vec * player.speed, player.acceleration * delta)
	elif can_decelerate:
		new_velocity = velocity.move_toward(Vector2(0, 0), player.friction * delta)
	return new_velocity
