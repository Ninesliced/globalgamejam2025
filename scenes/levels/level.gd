extends Node2D
class_name Level

@export var associated_level = 0:
	set(value):
		associated_level = value 

var level_has_been_passed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body is Player:
		get_parent().get_parent().current_level = associated_level
		get_parent().get_parent().is_on_a_level = true
		level_has_been_passed = true
