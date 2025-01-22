@icon("res://_engine/icons/node_2D/icon_bullet.png")
extends CharacterBody2D
class_name Bullet

@export var speed : float = 300.0

var _direction : Vector2 = Vector2.ZERO

func _ready():
	$Timer.connect("timeout", _handle_timeout)
	$Timer.start()


func _process(delta):
	pass


func _handle_timeout():
	queue_free()


func set_direction(direction: Vector2):
	_direction = direction


func set_timeout(timeout: float):
	$Timer.set_wait_time(timeout)


func _on_hurtbox_component_damaged_other(damaged_area:Area2D):
	_remove()

func _remove():
	queue_free()
