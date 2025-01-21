extends Weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(direction: Vector2):
	var bullet_instance : Bullet = weapon_resource.bullet_scene.instantiate()
	bullet_instance.global_position = global_position
	bullet_instance.set_direction(direction)
	get_tree().get_root().add_child(bullet_instance)
	pass
