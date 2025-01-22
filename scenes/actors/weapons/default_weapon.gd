extends Weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(direction: Vector2):
	var bullet_instance : Bullet = weapon_resource.bullet_scene.instantiate()
	var cannon_length = 100
	var cannon_end_position = global_position + direction.normalized() * cannon_length
	bullet_instance.global_position = cannon_end_position
	bullet_instance.set_direction(direction)
	get_tree().current_scene.add_child(bullet_instance)
	pass
