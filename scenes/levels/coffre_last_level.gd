extends Node2D

var is_opened := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if is_opened:
		return
	
	if body is Player:
		print("someone want to take the chest")
		var is_dashed_on: bool = false
		for child in body.get_children():
			if child is DashComponent:
				is_dashed_on = child.is_dashing
		if not is_dashed_on:
			return
		
		var derpPakedScene = load("res://scenes/actors/enemies/impl/the_tresure_derp.tscn")
		var derp = derpPakedScene.instantiate()
		derp.the_derp = true
		derp.position = body.get_parent().current_level_node.global_position + Vector2(500, 400)
		%AnimatedSprite2D.play()
		body.get_parent().add_child(derp)
		is_opened = true
		
		if Global.challenge_mode == Global.ChallengeMode.PACIFIC:
			Global.win_game()
