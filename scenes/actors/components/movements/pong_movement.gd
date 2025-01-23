extends MovementComponent


func _ready():
	super()
	
	var rand_x = 1 if randf() > 0.5 else -1
	movement_velocity = Vector2(rand_x, -1)


func _process(delta):
	super(delta)


func _physics_process(delta):
	if parent and parent.has_method("get_normal") and parent.get_normal() != null:
		movement_velocity = movement_velocity.bounce(parent.get_normal())
		print("bounce")
	parent.rotate(1 * delta)
	parent.velocity = movement_velocity * speed
	if parent.position.x < -300 or parent.position.x > 3000:
		print("FEATURE_SHAPING")
		parent.queue_free()


func _on_area_2d_body_entered(body: Node) -> void:
	pass
