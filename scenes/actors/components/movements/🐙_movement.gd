extends MovementComponent

@export var movement_amplitude := 1.0
@export var movement_rate  	   := 3.0

@export var skid_rate          := 0.05
@export var skid_factor        := 0.8

@export var minion: PackedScene
@export var minion_spawn_rate := 6.0

@export var target_list: Array[PackedScene] = []

@onready var movement_timer 		 = $MovementTimer
@onready var minion_timer            = $MinionTimer
@onready var target_detection_circle = $Area2D

const PI_CIRCLE := 2.0 * PI / 3.0

var target_list_obj: Array[Node2D] = []

var movement_vec := Vector2(0.0, 0.0)

var skid_delta   := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for target in target_list:
		target_list_obj.append(target.instantiate())
	
	movement_vec = _get_next_direction_vec()
	
	movement_timer.set_wait_time(movement_rate)
	
	if minion == null:
		minion_timer.stop()
		return
	minion_timer.set_wait_time(minion_spawn_rate)


func _process(delta: float) -> void:
	parent.move_and_slide()

	
func _physics_process(delta: float) -> void:
	skid_delta += delta
	
	if skid_delta > skid_rate:
		parent.velocity *= skid_factor;
		skid_delta -= skid_rate


func _get_next_direction_vec():
	var overlapping_bodies: Array[Node2D] = target_detection_circle.get_overlapping_bodies()
	
	var nearest_body: Node2D = null
	var nearest_dist: float  = 100000000.0
	
	for body in overlapping_bodies:
		var found_target = false
		
		for target_obj in target_list_obj:
			if body.get_script() == target_obj.get_script():
				found_target = true
				break
		
		if not found_target:
			break
		
		var body_dist: float = body.position.distance_squared_to(self.position)
		if body_dist > nearest_dist:
			continue
			
		nearest_body = body
		nearest_dist = body_dist
	
	if nearest_body == null:
		return Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0) * movement_amplitude
	
	var direction_vec = (nearest_body.global_position - self.global_position).normalized()
	
	return direction_vec * movement_amplitude


func _on_timer_timeout() -> void:
	movement_vec = _get_next_direction_vec()
	parent.velocity += movement_vec * speed
	movement_timer.start()


func _on_minion_timer_timeout() -> void:
	var minion_instance = minion.instantiate()
	
	assert(minion_instance != null && minion_instance is Node2D, "Cannot spawn a minion")

	minion_instance = minion_instance as Node2D
	
	var minion_pos: Vector2 = self.global_position
	minion_pos.x += sin(randf_range(-PI_CIRCLE, PI_CIRCLE))
	minion_pos.y += cos(randf_range(-PI_CIRCLE, PI_CIRCLE))
	
	minion_instance.global_position = minion_pos
	get_tree().current_scene.add_child(minion_instance)
	
	minion_timer.start()
