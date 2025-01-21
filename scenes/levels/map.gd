extends Node2D

var levels = []
var next_to_load_is_level = false

var PackedScenelevel: PackedScene = preload("res://scenes/levels/level.tscn")
var PackedScenebetween_level: PackedScene = preload("res://scenes/levels/between_level.tscn")

var camera_depth = 0
var next_level_position = 0
var current_generate_level = 0

var current_level = 0:
	set(value):
		current_level = value
		print(current_level)
		
var is_on_a_level = false


# Called when the node enters the scene tree for the first time.
func _ready():
	load_next_level()
	load_next_level()
	load_next_level()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(levels) >= 3:
		var topLeft = $Camera2D.get_screen_center_position() - get_viewport_rect().size / 2  
		if levels[0].position.y + get_size_of_level(levels[0]).y < topLeft.y:
			load_next_level()
			print("Next level is loading")
	if Input.is_action_pressed("test_arkanyota"):
		down_the_screen()
		
func load_next_level():
	var level_to_delete
	var node
	
	if len(levels) >= 3:
		level_to_delete = levels.pop_front()
		level_to_delete.queue_free()
	
	if next_to_load_is_level:
		node = PackedScenelevel.instantiate()
		node.associated_level = current_generate_level
	else:
		node = PackedScenebetween_level.instantiate()
		node.associated_level = current_generate_level
		current_generate_level += 1

	if len(levels) != 0:
		var size = get_size_of_level(levels[-1])
		node.set_position(Vector2(0, levels[-1].position.y + size.y))
	else:
		var size = get_size_of_level(node)
		node.set_position(Vector2(0, 0))
		
	%Levels.add_child(node)
	levels.append(node)
	
	next_to_load_is_level = not next_to_load_is_level
	
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
	
func down_the_screen():
	# for level in levels:
	# 	level.set_position(level.get_position() - Vector2(0,1)
	$Camera2D.position.y += 1
	

	
