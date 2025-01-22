extends MovementComponent
@export var direction = Vector2(1, 0)

@onready var right_ray_cast : RayCast2D = $Right
@onready var left_ray_cast : RayCast2D = $Left

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction.x > 0 and right_ray_cast.is_colliding():
		print("Colliding")
		direction.x = -1
	elif direction.x < 0 and left_ray_cast.is_colliding():
		direction.x = 1
	pass
	parent.velocity = direction.normalized() * speed
