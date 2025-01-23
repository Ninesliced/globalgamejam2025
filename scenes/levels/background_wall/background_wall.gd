extends Node2D

# @export var is_left = true
# Called when the node enters the scene tree for the first time.
func _ready():
	var rand_image = randi_range(0, 3)
	%AnimatedSprite2D.frame = rand_image

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
