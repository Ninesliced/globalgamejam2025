extends MovementComponent


var target : Player

func _ready() -> void:
	target = get_tree().current_scene.get_node("Player")
	assert(target != null, "No player in the scene")


func _process(_delta: float) -> void:
	if target == null:
		return
	
	var direction: Vector2 = (target.global_position - parent.global_position).normalized()
	parent.velocity = direction * speed
	
	if parent is Enemy:
		if direction.x > 0:
			parent.icon.flip_h = true
		else:
			parent.icon.flip_h = false
