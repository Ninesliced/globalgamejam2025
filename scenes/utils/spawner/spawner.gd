extends Node2D

@export var levels: Array[LevelData] = []
@export var bubble: PackedScene = preload("res://scenes/actors/bubbles/bubble.tscn")

@onready var bubbleTimer : Timer = $BubbleDelay

var map : Map
var padding : int = 250
var additional_top_padding : int = 400


func _ready() -> void:
	if not get_parent() is Map:
		assert(false, "Spawner must be a child of a Map node")
	self.map = get_parent()


func get_level_data() -> LevelData:
	return levels[(map.current_level - 1) % len(levels)]


func _on_map_level_change(level: int) -> void:
	var level_data : LevelData = get_level_data()
	bubbleTimer.wait_time = level_data.bubble_spawn_interval
	bubbleTimer.start()

	if not map.is_on_a_level:
		return

	var current_level : Level = map.current_level_node
	var level_pos := current_level.global_position
	var level_size := map.get_size_of_level(current_level)
	
	level_pos.x += padding
	level_size.x -= padding * 2
	level_pos.y += padding + additional_top_padding
	level_size.y -= padding * 2 + additional_top_padding
	
	for i in range(randi_range(level_data.spawn_count.x, level_data.spawn_count.y)):
		var scene = get_random_spawnable(level_data)
		if not scene is PackedScene:
			printerr("No enemy to spawn")
			continue
		var enemy_instance : Node2D = scene.instantiate() as Node2D
		var pos_x : float 			= randf_range(level_pos.x, level_pos.x + level_size.x)
		var pos_y : float 			= randf_range(level_pos.y, level_pos.y + level_size.y)
		get_tree().current_scene.add_child(enemy_instance)
		enemy_instance.global_position = Vector2(pos_x, pos_y)


func get_random_spawnable(level: LevelData) -> PackedScene:
	var enemyChances := level.spawnables
	var totalChance := 0

	for enemy in enemyChances:
		totalChance += enemy.chance

	var random := randf() * totalChance
	var current := 0

	for enemy in enemyChances:
		current += enemy.chance
		if random < current:
			return enemy.spawnable
	return null


func _on_bubble_delay_timeout() -> void:
	bubbleTimer.start()
	
	if not map.is_on_a_level:
		return
	
	var level_data: LevelData = get_level_data()
	for i in range(level_data.bubble_spawn_count):
		var bubble_instance: Bubble = bubble.instantiate() as Node2D
		var viewport : Rect2 	= map.camera.get_viewport_rect()
		var camera_pos: Vector2 = map.camera.global_position
		var pos_x: float     	= randf_range((camera_pos.x - viewport.size.x / 2) + padding, viewport.size.x - padding * 2)
		get_tree().current_scene.add_child(bubble_instance)
		bubble_instance.global_position  = Vector2(pos_x, camera_pos.y + viewport.size.y / 2)
		bubble_instance.bubble_value 	 = randi_range(level_data.bubble_air.x, level_data.bubble_air.y)
		# print(bubble_instance.bubble_value)
