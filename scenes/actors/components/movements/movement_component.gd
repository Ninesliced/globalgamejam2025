extends Node
class_name MovementComponent

@export var speed := 100.0
@export var parent : CharacterBody2D = null

var movement_velocity := Vector2(0, 0)

func _ready():
	pass


func _process(delta):
	pass
