extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var acceleration = 1200.0
@export var friction = 900.0
@export var play_mode : Global.PlayMode = Global.PlayMode.MOUSE


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
func _ready():
	pass

func _process(delta):
	move_and_slide()

	Global.hud.set_oxygen_bar($OxygenComponent.oxygen)

	$Label.text = str($OxygenComponent.oxygen)
