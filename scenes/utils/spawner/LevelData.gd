extends Resource

class_name LevelData

@export var spawnables: Array[SpawnableChance] = []

@export var spawn_interval := 1.0
@export var spawn_count := 3

@export var bubble_spawn_interval := 1.0
@export var bubble_spawn_count := 3
@export var bubble_air := Vector2i(2, 10)
