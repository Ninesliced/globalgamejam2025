extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var acceleration = 1200.0
@export var friction = 900.0
@export var play_mode : Global.PlayMode = Global.PlayMode.MOUSE

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var Oxygen_component
var is_flip_h = false
var is_dashing = false

func _ready():
	Oxygen_component = %OxygenComponent

func _process(delta):
	move_and_slide()

	Global.hud.set_oxygen_bar($OxygenComponent.oxygen, $OxygenComponent.max_oxygen)

	sprite.flip_h = ($ShootComponent.aim_direction.x <= 0)

	$Label.text = str($OxygenComponent.oxygen)

	if $DashComponent.is_dashing:
		sprite.play("dash")
		is_dashing = true
	else:
		sprite.play("swim")
		is_dashing = false
