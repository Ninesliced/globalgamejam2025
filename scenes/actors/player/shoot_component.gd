extends Component

var _weapons : Array[Weapon] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	for node in get_children():
		if node is Weapon:
			add_weapon(node)
		else:
			print("Node is not a weapon: ", node)

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		var mouse_position = get_global_mouse_position()
		var direction = get_parent().global_position.direction_to(mouse_position)
		shoot_weapon(direction)

func add_weapon(weapon: Weapon):
	_weapons.append(weapon)

func remove_weapon(weapon: Weapon):
	_weapons.erase(weapon)

func shoot_weapon(direction: Vector2):
	if _weapons.size() == 0:
		print("No weapons to shoot")
		return
	_weapons[0].shoot(direction)
