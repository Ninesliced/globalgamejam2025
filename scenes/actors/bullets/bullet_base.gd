extends Bullet

@export var friction = 300.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = move_toward(speed, 0, friction * delta)
	var velocity = _direction * speed
	position += velocity * delta
	pass
