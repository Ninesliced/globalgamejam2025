extends Node2D
class_name Bullet
@export var speed = 300.0
var _direction : Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = _direction * speed
	position += velocity * delta
	pass


func set_direction(direction: Vector2):
	_direction = direction
	pass