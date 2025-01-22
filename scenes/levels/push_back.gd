extends Area2D

var player : Node2D = null
var push_direction = Vector2.ZERO
var push_timer = 0.0
var push_duration = 0.5
var push_distance = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		push_direction = (global_position - body.global_position).normalized()
		push_timer = push_duration
		player = body

func _process(delta: float) -> void:
	if push_timer > 0:
		push_timer -= delta
		var push_step = push_distance * (delta / push_duration)
		player.global_position += push_direction * push_step
