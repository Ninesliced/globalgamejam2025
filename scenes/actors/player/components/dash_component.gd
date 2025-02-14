@icon("res://_engine/icons/node_2D/icon_projectile.png")
extends Component
class_name DashComponent
var player : Player = null
var velocity = Vector2(0, 0)

signal dash_entered
signal dash_exited
@export var movement_controller : MovementController = null

@export var dash_consumption = 25
@export var dash_distance = 20000
@export var dash_duration = 0.1
@export var keep_velocity_scale = 1
@export var maximum_velocity_keep = 1000
var _dash_direction = Vector2(0, 0)
var is_dashing = false
var dash_timer : Timer = Timer.new()

@export var dash_mode : Global.PlayMode = Global.PlayMode.EIGHT_WAY
@export var oxygen_component : OxygenComponent = null
@export var minimum_dash_distance_to_mouse = 50

var old_acceleration = true
var old_decceleration = true

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


func _process(delta):
	pass


func _physics_process(delta):
	_dash_direction = handle_dash()
	if is_dashing:
		player.velocity = ((_dash_direction * dash_distance) / dash_duration) * delta
		# print(player.velocity)
	pass


func handle_dash():
	if Input.is_action_just_pressed("dash") and not is_dashing:
		_dash_direction = Global.get_direction(player.global_position, player.play_mode, get_global_mouse_position())
		if _dash_direction == Vector2.ZERO:
			return Vector2.ZERO
		if oxygen_component.oxygen < dash_consumption: # tolerance for dash
			var to_consumme = oxygen_component.oxygen - 4
			oxygen_component.add_oxygen(to_consumme)
		else:
			oxygen_component.add_oxygen(-dash_consumption)
		dash_entered.emit()

		enable_dash()
		return _dash_direction
	return _dash_direction

func enable_dash():
	if movement_controller:
		old_acceleration = movement_controller.can_accelerate
		old_decceleration = movement_controller.can_decelerate
		movement_controller.can_accelerate = false
		movement_controller.can_decelerate = false
	is_dashing = true
	dash_timer.start()

	$DashSound.play()
	$DashParticles.emitting = true


func _disable_dash():
	is_dashing = false
	player.velocity *= keep_velocity_scale
	dash_exited.emit()

	if player.velocity.length() > maximum_velocity_keep:
		player.velocity = player.velocity.normalized() * maximum_velocity_keep
	if movement_controller:
		movement_controller.can_accelerate = old_acceleration
		movement_controller.can_decelerate = old_decceleration
	
	$DashParticles.emitting = false
