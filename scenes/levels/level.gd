extends Node2D
class_name Level

@export var associated_level = 0:
	set(value):
		associated_level = value 

var level_has_been_passed = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body is Player:
		get_parent().get_parent().next_current_level = associated_level
		get_parent().get_parent().next_is_on_a_level = true

func get_size_of_level(level_node):
	var size
	var LastLevelColisionShape = level_node.get_node("Area2D/CollisionShape2D")
	var LastLevelColisionShape_Shape = LastLevelColisionShape.get_shape()
	if LastLevelColisionShape_Shape is RectangleShape2D:
		size = LastLevelColisionShape_Shape.size
	else:
		size = Vector2(2,2)
		print("Is not a fucking shape")
	return size



func _on_area_2d_body_exited(body):
	if body is Player:
		get_parent().get_parent().current_level = get_parent().get_parent().next_current_level
		get_parent().get_parent().is_on_a_level = get_parent().get_parent().next_is_on_a_level
		level_has_been_passed = true
		# var camera = get_parent().get_parent().camera
		# var player = get_parent().get_parent().player
		# camera.put_y(player.global_position.y + get_viewport_rect().size.y / 2)
