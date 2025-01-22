extends Area2D

var push_distance = 350

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var tween = get_tree().create_tween()
		var push_direction = (global_position - body.global_position).normalized()
		var target_position = body.global_position + push_direction * push_distance
		tween.tween_property(body, "global_position", target_position, 0.5)
