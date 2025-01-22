extends Area2D

var player : Node2D = null
var push_direction = Vector2.ZERO
var pushing = false
var push_distance = 500


func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		push_direction = (global_position - body.global_position).normalized()
		pushing = true
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		pushing = false
		player = null

func _process(delta: float) -> void:
	if pushing and player:
		var push_step = push_distance * (delta)
		player.global_position += push_direction * push_step
