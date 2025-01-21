extends CharacterBody2D
class_name Bubble

@export var bubble_value := 20.0 

func _on_hitbox_body_entered(body:Node2D):
	if body.is_in_group("has_OxygenComponent"):
		for child in body.get_children():
			if child is OxygenComponent: 
				child.add_oxygen(bubble_value)
		
		_remove()

func _remove():
	queue_free()
