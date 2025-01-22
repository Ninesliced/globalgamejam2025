extends Node2D

@export var levels: Array[LevelData] = []
@export var bubble: PackedScene = preload("res://scenes/actors/bubbles/bubble.tscn")

@onready var spawnTimer : Timer = $SpawnDelay
@onready var bubbleTimer : Timer = $BubbleDelay

var map : Map


func _ready() -> void:
	if not get_parent() is Map:
		assert(false, "Spawner must be a child of a Map node")
	self.map = get_parent()

func get_level_data() -> LevelData:
	return levels[(map.current_level - 1) % len(levels)]


func _on_map_level_change(level: int) -> void:
	spawnTimer.wait_time = get_level_data().spawn_interval
	bubbleTimer.wait_time = get_level_data().bubble_spawn_interval
	spawnTimer.start()
	bubbleTimer.start()


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


func _on_spawn_delay_timeout() -> void:
	map.get_size_of_level(map.levels[0])
	
	spawnTimer.start()
	
	if not map.is_on_a_level:
		return
	
	var level_data: LevelData = get_level_data()
	for i in range(level_data.spawn_count):
		var enemy: Node2D       = get_random_spawnable(level_data).instantiate() as Node2D
		var viewport : Rect2 	= map.camera.get_viewport_rect()
		var camera_pos: Vector2 = map.camera.global_position
		var pos_x: float     	= randf_range(camera_pos.x - viewport.size.x / 2, viewport.size.x)
		enemy.global_position   = Vector2(pos_x, camera_pos.y + viewport.size.y / 2)
		get_tree().current_scene.add_child(enemy)


func _on_bubble_delay_timeout() -> void:
	bubbleTimer.start()
	
	if not map.is_on_a_level:
		return
	
	var level_data: LevelData = get_level_data()
	for i in range(level_data.bubble_spawn_count):
		var bubble_instance: Bubble = bubble.instantiate() as Node2D
		var viewport : Rect2 	= map.camera.get_viewport_rect()
		var camera_pos: Vector2 = map.camera.global_position
		var pos_x: float     	= randf_range(camera_pos.x - viewport.size.x / 2, viewport.size.x)
		get_tree().current_scene.add_child(bubble_instance)
		bubble_instance.global_position  = Vector2(pos_x, camera_pos.y + viewport.size.y / 2)
		bubble_instance.bubble_value = randi_range(level_data.bubble_air.x, level_data.bubble_air.y)
		print(bubble_instance.bubble_value)
