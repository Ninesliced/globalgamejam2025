extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var acceleration = 1200.0
@export var friction = 900.0
@export var play_mode : Global.PlayMode = Global.PlayMode.MOUSE
@export var damage_screenshake = 20.0
@export var damage_invicibility_time := 2.0

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var Oxygen_component
var Dash_component
var Weapon_component
var is_flip_h = false
var is_dashing = false
var totalsize # Total size of the map

var _invincibility_time_left := 0.0

func _ready():
	Oxygen_component = %OxygenComponent
	Dash_component = %DashComponent
	Weapon_component = %Weapon
	totalsize = get_parent().level_size * get_parent().number_of_level + get_parent().betweenlevel_size * (get_parent().number_of_level+1)

func _process(delta):
	move_and_slide()

	Global.hud.set_oxygen_bar($OxygenComponent.oxygen, $OxygenComponent.max_oxygen)
	Global.hud.set_depth_bar(position.y, totalsize.y)
	
	sprite.flip_h = ($ShootComponent.aim_direction.x <= 0)
	is_flip_h = ($ShootComponent.aim_direction.x <= 0)
	
	$Label.text = str($OxygenComponent.oxygen)

	if $DashComponent.is_dashing:
		sprite.play("dash")
		is_dashing = true
	else:
		sprite.play("swim")
		is_dashing = false
	
	_update_invicibility(delta)


func do_death_animation():
	process_mode = PROCESS_MODE_DISABLED
	hide()

func _update_invicibility(delta):
	_invincibility_time_left = max(0.0, _invincibility_time_left - delta)
	if _invincibility_time_left > 0:
		var threshold = 0.15 if _invincibility_time_left < damage_invicibility_time/2 else 0.2
		if fmod(_invincibility_time_left, threshold) < threshold/2:
			modulate = Color("e43b44")
		else:
			modulate = Color("e8b796")
		modulate = modulate.lerp(Color("f19ea2"), 1 - _invincibility_time_left / damage_invicibility_time)

	else:
		modulate = Color.WHITE

func damage(amount: float):
	if _invincibility_time_left > 0 or amount == 0:
		return
	
	$OxygenComponent.add_oxygen(-amount)
	$DamageSound.play()

	_invincibility_time_left = damage_invicibility_time

	var camera = get_viewport().get_camera_2d()
	if camera is CameraManager:
		camera.shake(damage_screenshake)
