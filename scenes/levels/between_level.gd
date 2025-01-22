extends Node2D

@export var associated_level = 0:
	set(value):
		associated_level = value 

func _on_area_2d_body_entered(body):
	if body is Player:
		get_parent().get_parent().next_current_level = associated_level
		get_parent().get_parent().next_is_on_a_level = false


func _on_area_2d_body_exited(body):
	if body is Player:
		get_parent().get_parent().current_level = get_parent().get_parent().next_current_level
		get_parent().get_parent().is_on_a_level = get_parent().get_parent().next_is_on_a_level
