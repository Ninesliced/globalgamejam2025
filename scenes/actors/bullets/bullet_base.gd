extends Bullet

@export var friction = 300.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = move_toward(speed, 0, friction * delta)
	velocity = _direction.normalized() * speed
	pass

func _physics_process(delta):
	move_and_slide()
	pass