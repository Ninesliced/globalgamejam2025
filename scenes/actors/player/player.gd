extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var acceleration = 1200.0
@export var friction = 900.0

func _ready():
    pass

func _process(delta):
    move_and_slide()