extends MovementComponent

@export var direction : Vector2 = Vector2(0, 1)
@export var randomize_bounce = false
@export var random_direction_x = false

func _ready():
	super()
	if random_direction_x:
		var random_var = -1 if randf() > 0.5 else 1
		direction = Vector2(random_var * direction.x, direction.y)
	
	# var rand_x = 1 if randf() > 0.5 else -1
	movement_velocity = direction


func _process(delta):
	super(delta)


func _physics_process(delta):
	if parent is Enemy:
		var enemy = parent as Enemy
		if enemy.collision:
			if randomize_bounce:
				movement_velocity = handle_randomize_bounce(enemy)
			if !randomize_bounce:
				movement_velocity = movement_velocity.bounce(enemy.collision.get_normal())

	parent.rotate(1 * delta)
	parent.velocity = movement_velocity * speed
	if parent.position.x < -300 or parent.position.x > 3000:
		print("FEATURE_SHAPING")
		parent.queue_free()


func handle_randomize_bounce(enemy):
	var normal_collision = enemy.collision.get_normal()
	var rand_x = randf_range(-1, 1)
	var rand_y = randf_range(-1, 1)
	
	if normal_collision.x != 0 and sign(normal_collision.x) != sign(rand_x):
		rand_x = -rand_x
	if normal_collision.y != 0 and sign(normal_collision.y) != sign(rand_y):
		rand_y = -rand_y
	return Vector2(rand_x, rand_y).normalized()

func _on_area_2d_body_entered(body: Node) -> void:
	pass
