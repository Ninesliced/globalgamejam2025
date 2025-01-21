extends Node2D
class_name Weapon

@export var weapon_resource: WeaponResource

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(direction: Vector2):

	pass

func handle_shoot(vector: Vector2):
	print(weapon_resource.weapon_shoot_type)
	if weapon_resource.weapon_shoot_type == weapon_resource.ShootType.SEMI_AUTO:
		if Input.is_action_just_pressed("shoot"):
			shoot(vector)
			
	elif weapon_resource.weapon_shoot_type == weapon_resource.ShootType.AUTO:
		if Input.is_action_pressed("shoot"):
			print("shoot")
			shoot(vector)