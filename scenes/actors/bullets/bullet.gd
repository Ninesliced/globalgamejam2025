extends Node2D
class_name Bullet

@export var speed : float = 300.0

var _direction : Vector2 = Vector2.ZERO

func _ready():
	$Timer.connect("timeout", _handle_timeout)
	$Timer.start()


func _process(delta):
	pass


func _handle_timeout():
	# FIXME: Add an animation prior to destroying the object?
	queue_free()


func set_direction(direction: Vector2):
	_direction = direction


func set_timeout(timeout: float):
	$Timer.set_wait_time(timeout)
