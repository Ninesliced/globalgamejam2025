extends Node2D
class_name Component

func _ready():
    get_parent().add_to_group("has_" + name)