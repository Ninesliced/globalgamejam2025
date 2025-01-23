extends MovementComponent

@export var capture_oxygen_component: CaptureOxygenComponent = null

var bubble_pop_scene: PackedScene = preload("res://scenes/actors/particles/bubble_pop_particle.tscn")
var is_bliking = false
var blink_time = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta):
	if capture_oxygen_component.is_captured:
		parent.modulate = Color(1, 1, 1)
		return
	if is_bliking and blink_time <= 0:
		if parent.modulate == Color(1, 1, 1):
			parent.modulate = Color(1, 0, 0)
		else:
			parent.modulate = Color(1, 1, 1)
		blink_time = 0.1
	blink_time -= delta
	pass

func _physics_process(delta):
	var player = get_tree().current_scene.get_node("Player")
	if player:
		var player_position = player.global_position
		var my_pos = parent.global_position
		var direction = (player_position - my_pos).normalized()
		parent.velocity = direction * speed
		parent.rotation = direction.angle()
		if (player_position - my_pos).length() < 400:
			is_bliking = true
		else:
			parent.modulate = Color(1, 1, 1)
			is_bliking = false
		if (player_position - my_pos).length() < 50 and not capture_oxygen_component.is_captured:
			player.Oxygen_component.add_oxygen(-10)
			var bubble_cloud = bubble_pop_scene.instantiate()
			get_parent().get_parent().add_child(bubble_cloud)
			bubble_cloud.global_position = my_pos
			bubble_cloud.play()
			get_parent().queue_free()
	pass
