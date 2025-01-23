extends Node
class_name MovementComponent

@export var speed := 400.0
@export var parent : CharacterBody2D = null

var movement_velocity := Vector2(0, 0)
var disabled = false
func _ready():
	
	pass


func _process(delta):
	if disabled:
		return
	pass

func disable():
	disabled = true