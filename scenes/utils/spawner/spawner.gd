extends Node2D

@export var levels: Array[LevelData] = []

@onready var timer : Timer = $SpawnDelay

var map : Map


func _ready() -> void:
	if not get_parent() is Map:
		assert(false, "Spawner must be a child of a Map node")
	self.map = get_parent()

func get_level_data() -> LevelData:
	return levels[(map.current_level - 1) % len(levels)]


func _on_map_level_change(level: int) -> void:
	timer.wait_time = get_level_data().spawn_interval
	timer.start()


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
	timer.start()
	
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
