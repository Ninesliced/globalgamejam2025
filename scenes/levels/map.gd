extends Node2D

class_name Map

var levels = []
var next_to_load_is_level = false

var PackedScenelevel: PackedScene = preload("res://scenes/levels/level.tscn")
var PackedScenebetween_level: PackedScene = preload("res://scenes/levels/between_level.tscn")

@export var player : Player = null
@export var camera : Camera2D = null

var camera_depth = 0
var next_level_position = 0
var current_generate_level = 0

signal level_change(level: int)
signal level_zone_change(is_on_a_level: bool)

var current_level = 0:
	set(value):
		current_level = value
		emit_signal("level_change", value)
		if not is_on_a_level and len(levels) != 0 and levels[1] is Level and not levels[1].level_has_been_passed:
			next_light_effect()
			levels[1].level_has_been_passed = true

var number_of_level = 25

var next_current_level = 0
var next_is_on_a_level = false

var is_on_a_level = false:
	set(value):
		is_on_a_level = value
		emit_signal("level_zone_change", value)

var light_gap = 0.1
var light_radius = 0.7:
	set(value):
		light_radius = value
		if %PointLight2D != null:
			var gradient = %PointLight2D.texture.get_gradient()
			gradient.set_offset(1, 0.0)
			gradient.set_offset(2, max(light_radius, 0.0))
			gradient.set_offset(3, min(light_radius+light_gap, 1.0))
		else:
			printerr("No light in the scene")
		# gradient.set_offset(4, 1.0) #was out of bounds

func next_light_effect():
	light_radius = max(0.1, light_radius-0.9/number_of_level)

# Called when the node enters the scene tree for the first time.
func _ready():
	light_radius = 0.7
	load_next_level()
	load_next_level()
	load_next_level()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var CameraTopLeft = camera.get_screen_center_position() - get_viewport_rect().size / 2
	if len(levels) >= 3:
		if levels[0].position.y + get_size_of_level(levels[0]).y < CameraTopLeft.y:
			load_next_level()
			print("Next level is loading")

	# if Input.is_action_just_pressed("test_arkanyota"):
	# 	next_light_effect()
		


	
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
