extends Sprite2D
class_name CaptureBubble

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_size(size: Vector2):
	var tween = get_tree().create_tween()

	tween.tween_property(self, "scale", size, 1.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	pass
