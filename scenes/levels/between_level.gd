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

	%ExplicationText.visible = false
	%CurrentLevel.visible = true
	if associated_level == 0:
		%CheckpointElement.frame = 0
		%ExplicationText.visible = true
	elif associated_level <= 3:
		%CheckpointElement.frame = 1
	elif associated_level <= 5:
		%CheckpointElement.frame = 2
	elif associated_level <= 7:
		%CheckpointElement.frame = 3
	else:
		%CheckpointElement.frame = 4
		%CurrentLevel.visible = false


	if associated_level <= 3:
		%PipesElement.frame = 0
	elif associated_level <= 5:
		%PipesElement.frame = 1
	elif associated_level <= 7:
		%PipesElement.frame = 2
	else:
		%PipesElement.frame = 3	
		
	if %UpgradesButton:
		if associated_level <= 6:
			%UpgradesButton.position = Vector2(1296, 256)
			%UpgradesButton.rotation = deg_to_rad(8)
		else:
			%UpgradesButton.position = Vector2(1232, 344)
			%UpgradesButton.rotation = deg_to_rad(-19.7)

func _on_area_2d_body_entered(body):
	if body is Player:		
		get_parent().get_parent().next_current_level = associated_level


func _on_area_2d_body_exited(body):
	if body is Player:
		get_parent().get_parent().current_level = get_parent().get_parent().next_current_level
