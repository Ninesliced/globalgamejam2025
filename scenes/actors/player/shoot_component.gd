@icon("res://_engine/icons/node_2D/canon_2.png")
extends Component

var _weapons : Array[Weapon] = []
var player : Player = null
var aim_direction = Vector2.RIGHT

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

func _process(delta):
	aim_direction = Global.get_direction(player.global_position, player.play_mode, get_global_mouse_position())
	handle_weapon_shoot(aim_direction)

func handle_weapon_shoot(direction) -> void:
	if _weapons.size() == 0:
		return
	var weapon: Weapon = _weapons[0]
	weapon.handle_shoot(direction)
	weapon.set_weapon_angle(direction)

func add_weapon(weapon: Weapon):
	_weapons.append(weapon)

func remove_weapon(weapon: Weapon):
	_weapons.erase(weapon)

func shoot_weapon(weapon: Weapon, direction: Vector2):
	weapon.shoot(direction)
