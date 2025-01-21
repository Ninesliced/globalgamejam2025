extends CharacterBody2D
class_name Player

@export var speed = 300.0

func _ready():
    pass

func _process(delta):
    move_and_slide()