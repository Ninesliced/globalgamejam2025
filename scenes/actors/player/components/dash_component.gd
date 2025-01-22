@icon("res://_engine/icons/node_2D/icon_projectile.png")
extends Component

var player : Player = null
var velocity = Vector2(0, 0)

signal on_dash

@export var dash_consumption = 10
@export var dash_distance = 10000
@export var dash_duration = 0.5

var _dash_direction = Vector2(0, 0)
var is_dashing = false
var dash_timer : Timer = Timer.new()

@export var dash_mode : Global.PlayMode = Global.PlayMode.EIGHT_WAY
@export var oxygen_component : OxygenComponent = null
@export var minimum_dash_distance = 50

func _ready():
	super()
	var parent = get_parent()
	if parent is Player:
		player = parent
	else:
		assert(false, "dash component must be a child of Player")
	if oxygen_component == null:
		assert(false, "dash component must have an oxygen component")

	dash_timer.wait_time = dash_duration
	dash_timer.set_one_shot(true)
	add_child(dash_timer)
	dash_timer.timeout.connect(_disable_dash)
	pass


func _process(delta):
	pass


func _physics_process(delta):
	_dash_direction = handle_dash()
	if is_dashing:
		player.velocity = ((_dash_direction * dash_distance) / dash_duration) * delta
	pass

func handle_dash():
	if Input.is_action_just_pressed("dash") and not is_dashing:
		_dash_direction = get_dash_direction(player.velocity)
		if _dash_direction == Vector2.ZERO:
			return Vector2.ZERO
		oxygen_component.add_oxygen(-dash_consumption)
		on_dash.emit()

		is_dashing = true
		dash_timer.start()
		return _dash_direction
	return _dash_direction
		

func get_dash_direction(velocity) -> Vector2:
	var vec = Vector2(0, 0)
	if player.play_mode == Global.PlayMode.MOUSE:
		var mouse_position = get_global_mouse_position()
		var distance = (mouse_position - player.global_position).length()
		if distance < minimum_dash_distance:
			return Vector2.ZERO
		vec = (mouse_position - player.global_position).normalized()
	
	if player.play_mode == Global.PlayMode.EIGHT_WAY:
		vec = Input.get_vector("left", "right", "up", "down")
		if vec == Vector2.ZERO:
			vec = Vector2(1,0)
		vec = vec.normalized()
	return vec

func _disable_dash():
	is_dashing = false
	