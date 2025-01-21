extends Weapon


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(direction: Vector2):
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.position = global_position
	bullet_instance.direction = direction
	get_parent().add_child(bullet_instance)
	pass
