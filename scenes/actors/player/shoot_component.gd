extends Component

var _weapons : Array[Weapon] = []
var player : Player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	for node in get_children():
		if node is Weapon:
			add_weapon(node)
		else:
			print("Node is not a weapon: ", node)
		
		var parent = get_parent()
		if parent is Player:
			player = parent
		else:
			assert(false, "dash component must be a child of Player")
	pass # Replace with function body.

func _process(delta):
	handle_weapon_shoot()
	pass

func handle_weapon_shoot():
	if _weapons.size() == 0:
		return
	var weapon = _weapons[0]
	var direction : Vector2 = Vector2(1,0)

	if player.play_mode == Global.PlayMode.MOUSE:
		direction = global_position.direction_to(get_global_mouse_position())

	if player.play_mode == Global.PlayMode.EIGHT_WAY:
		var vec = Input.get_vector("left", "right", "up", "down") # SCOTCH FAIRE UNE FONC GLOBAL POUR CA
		direction = vec.normalized()
	weapon.handle_shoot(direction)
	pass

func add_weapon(weapon: Weapon):
	_weapons.append(weapon)
	pass

func remove_weapon(weapon: Weapon):
	_weapons.erase(weapon)
	pass

func shoot_weapon(weapon: Weapon, direction: Vector2):
	weapon.shoot(direction)
	pass
