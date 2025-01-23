extends MovementComponent


# Called when the node enters the scene tree for the first time.
func _ready():
	var rand_x = 1 if randf() > 0.5 else -1
	movement_velocity = Vector2(rand_x, -1)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	pass

func _physics_process(delta):
	if parent is Enemy:
		var enemy = parent as Enemy
		if enemy.collision:
			movement_velocity = movement_velocity.bounce(enemy.collision.get_normal())
	parent.rotate(1 * delta)
	parent.velocity = movement_velocity * speed
	if parent.position.x < -300 or parent.position.x > 3000:
		print("FEATURE_SHAPING")
		parent.queue_free()
	pass

func _on_area_2d_body_entered(body: Node) -> void:
	pass

	pass # Replace with function body.
