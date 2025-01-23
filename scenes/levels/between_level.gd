extends Node2D

@export var associated_level = 0:
	set(value):
		associated_level = value 

func _ready():
	%CurrentLevel.text = str(associated_level)
	if associated_level == 8:
		%CollisionShape2D.disabled = false
		
	if associated_level == 0 or associated_level == get_parent().get_parent().number_of_level:
		%UpgradesButton.queue_free()
	
	if associated_level == get_parent().get_parent().number_of_level:
		var coffre_last_levelPackedScene = load("res://scenes/levels/coffre_last_level.tscn")
		var coffre_last_level = coffre_last_levelPackedScene.instantiate()
		coffre_last_level.position = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
		add_child(coffre_last_level)
		
func _on_area_2d_body_entered(body):
	if body is Player:		
		get_parent().get_parent().next_current_level = associated_level


func _on_area_2d_body_exited(body):
	if body is Player:
		get_parent().get_parent().current_level = get_parent().get_parent().next_current_level
