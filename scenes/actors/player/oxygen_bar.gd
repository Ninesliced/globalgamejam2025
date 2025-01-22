extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var sign
var angle
var pos
var oxy_scale
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"..".is_flip_h:
		sign = -1

		if $"..".is_dashing:
			angle = 220.1
		else:
			angle = -118.0

	else:
		sign = 1
		if $"..".is_dashing:
			angle = -40.1
		else:
			angle = -62.0
	if $"..".is_dashing:
		pos = Vector2(sign*-41, -52)
		oxy_scale = 0.25
	else:
		pos = Vector2(sign*-64, -34)
		oxy_scale = 0.22
	position = pos
	scale.x = oxy_scale
	rotation = deg_to_rad(angle)
	
