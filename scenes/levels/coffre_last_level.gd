extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body is Player:
		print("someone want to take the chest")
		var is_dashed_on = false
		for child in body.get_children():
			if child is DashComponent:
				is_dashed_on = child.is_dashing
		if not is_dashed_on:
			return
		
		var derpPakedScene = load("res://scenes/actors/enemies/impl/the_tresure_derp.tscn")
		var derp = derpPakedScene.instantiate()
		derp.the_derp = true
		add_child(derp)
		
		
