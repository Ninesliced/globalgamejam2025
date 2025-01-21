extends Component
var player : Player = null
var velocity = Vector2(0, 0)

@export var dash_consumption = 10
@export var dash_force = 1000
@export var dash_mode : Global.PlayMode = Global.PlayMode.EIGHT_WAY
@export var oxygen_component : OxygenComponent = null

signal on_dash

func _ready():
	super()
	var parent = get_parent()
	if parent is Player:
		player = parent
	else:
		assert(false, "dash component must be a child of Player")
	if oxygen_component == null:
		assert(false, "dash component must have an oxygen component")
	pass


func _process(delta):
	pass

func _physics_process(delta):
	handle_dash()
	pass

func handle_dash() -> void:
	if Input.is_action_just_pressed("dash"):
		oxygen_component.add_oxygen(-dash_consumption)
		player.velocity = dash(player.velocity)
		on_dash.emit()
		

func dash(velocity) -> Vector2:
	var vec = Vector2(0, 0)
	if player.play_mode == Global.PlayMode.MOUSE:
		var mouse_position = get_global_mouse_position()
		vec = (mouse_position - player.global_position).normalized()
	if player.play_mode == Global.PlayMode.EIGHT_WAY:
		vec = Input.get_vector("left", "right", "up", "down")
		if vec == Vector2.ZERO:
			vec = Vector2(1,0)
		vec = vec.normalized()
	return vec * dash_force
	
