extends Node2D

class_name Map

var levels: Array[Variant]      = []
var next_to_load_is_level: bool = false

var PackedScenelevel: PackedScene = preload("res://scenes/levels/level.tscn")
var PackedScenebetween_level: PackedScene = preload("res://scenes/levels/between_level.tscn")

@export var player : Player = null
@export var camera : Camera2D = null

var camera_depth: int           = 0
var next_level_position: int    = 0
var current_generate_level: int = 7

var current_level_node:
	set(value):
		current_level_node = value

signal level_change(level: int)
signal level_zone_change(level: Level, is_on_a_level: bool)

var current_level: int   = 0:
	set(value):
		current_level = value
		emit_signal("level_change", value)
		if not is_on_a_level and len(levels) >= 1 and levels[1] is Level and not levels[1].level_has_been_passed:
			next_light_effect()
			levels[1].level_has_been_passed = true
			print("level is passeds")

var number_of_level: int = 8

var next_current_level: int  = 0
var next_is_on_a_level: bool = false

var is_on_a_level: bool = false:
	set(value):
		is_on_a_level = value
		emit_signal("level_zone_change", value)

var light_gap: float    = 0.1
var light_radius: float = 0.7:
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

@onready var shaderedParallaxSprite = $ParallaxBackground/ParallaxLayer/Fond

func next_light_effect():
	light_radius = max(0.1, light_radius-0.9/number_of_level)

var level_size = get_size_of_level(PackedScenelevel.instantiate())
var betweenlevel_size = get_size_of_level(PackedScenebetween_level.instantiate())

# Called when the node enters the scene tree for the first time.
func _ready():
	light_radius = 0.7
	load_next_level()
	load_next_level()
	load_next_level()
	Global.hud.map_component = self
	# print(mapsize)
	pass # Replace with function body.


func get_current_level_node():
	for i in range(levels.size()-1, -1, -1):
		var level_elt = levels[i]
		if player.position.y > level_elt.position.y:
			return level_elt


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var camera_top_left: Vector2 = camera.get_screen_center_position() - get_viewport_rect().size / 2
	if len(levels) >= 3:
		if levels[0].position.y + get_size_of_level(levels[0]).y < camera_top_left.y:
			load_next_level()
			print("Next level is loading")
	if len(levels) != 0:
		var old_current_level_node = current_level_node
		current_level_node = get_current_level_node()
		if old_current_level_node != current_level_node and old_current_level_node != null:
			print("change_map")
			# if old_current_level_node.associated_level < current_level_node.associated_level:
			#	print("new_map")
				# camera.global_position.y = current_level_node.position.y + get_viewport_rect().size.y / 2
			camera.camera_move_here = current_level_node.position.y + get_viewport_rect().size.y / 2
		is_on_a_level = current_level_node is Level


	
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
		var size: Vector2 = get_size_of_level(levels[-1])
		node.set_position(Vector2(0, levels[-1].position.y + size.y))
	else:
		var size: Vector2 = get_size_of_level(node)
		node.set_position(Vector2(0, 0))
		
	%Levels.add_child(node)
	levels.append(node)
	
	next_to_load_is_level = not next_to_load_is_level
	
func get_size_of_level(level_node) -> Vector2:
	var size : Vector2
	var last_level_collision_shape = level_node.get_node("Area2D/CollisionShape2D")
	var last_level_collision_shape_shape = last_level_collision_shape.get_shape()
	if last_level_collision_shape_shape is RectangleShape2D:
		size = last_level_collision_shape_shape.size
	else:
		size = Vector2(2,2)
		print("Is not a fucking shape")
	return size

func get_current_level_bounds() -> Rect2:
	if current_level_node == null or not current_level_node is Level:
		return Rect2()
	
	var size := get_size_of_level(current_level_node)
	var pos := (current_level_node as Level).global_position
	return Rect2(pos, size)


func _on_slowness_detected() -> void:
	print("Disabled background shader")
	shaderedParallaxSprite.material = null
