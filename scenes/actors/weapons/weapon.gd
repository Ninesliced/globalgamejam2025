@icon("res://_engine/icons/node_2D/icon_gun.png")
extends Node2D
class_name Weapon

@export var weapon_resource: WeaponResource
var fire_rate_timer : Timer = Timer.new()
var can_shoot : bool = true
@onready var weapon_sprite : Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	fire_rate_timer.set_wait_time(weapon_resource.fire_rate)
	add_child(fire_rate_timer)
	fire_rate_timer.one_shot = true
	fire_rate_timer.timeout.connect(_shoot_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(direction: Vector2):
	# virtual method
	pass

func handle_shoot(vector: Vector2):
	if not can_shoot:
		return
	if weapon_resource.weapon_shoot_type == weapon_resource.ShootType.SEMI_AUTO:
		if Input.is_action_just_pressed("shoot"):
			shoot_and_reset_timer(vector)
	elif weapon_resource.weapon_shoot_type == weapon_resource.ShootType.AUTO:
		if Input.is_action_pressed("shoot"):
			shoot_and_reset_timer(vector)


func shoot_and_reset_timer(direction: Vector2):
	shoot(direction)
	set_shoot_timer()

func set_shoot_timer():
	fire_rate_timer.start()
	can_shoot = false

func _shoot_timer_timeout():
	can_shoot = true


func set_weapon_angle(direction: Vector2):
	var rotation_radians = direction.angle()
	weapon_sprite.rotation = rotation_radians
	pass