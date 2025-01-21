extends Bullet

@export var friction = 300.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = move_toward(speed, 0, friction * delta)
	var velocity = _direction * speed
	position += velocity * delta
	pass
