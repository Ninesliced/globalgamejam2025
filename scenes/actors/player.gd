extends CharacterBody2D

@export var speed = 300.0

func _ready():
    pass

func _process(delta):
    var vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

    velocity = vec * speed

    move_and_slide()