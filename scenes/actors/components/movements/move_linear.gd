extends MovementComponent
@export var direction = Vector2(1, 0)

@onready var right_ray_cast : RayCast2D = $Right
@onready var left_ray_cast : RayCast2D = $Left

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
