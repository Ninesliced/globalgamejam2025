extends Node2D

@export var win_upgrade = "Increase oxygen capacity" 
@export var lose_upgrade = "You're speed is reduced" 

var is_usable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	%Bonus.text = win_upgrade
	%Malus.text = lose_upgrade

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var win_upgrades = {
	"Increase oxygen capacity": win_oxygen_capacity,
	"Refill the oxygen": win_oxygen_capacity,
	"The dash costs less": dash_cost_less,
	"The shoot costs less": dash_cost_less,
	"The dash is more powerfull": dash_cost_less,
	"Your speed is fastest": dash_cost_less
}

var lose_upgrades = {
	"Drain half of the oxygen reserve": lose_half_oxygen,
	"The dash is more expensive": dash_cost_more,
	"The shoot is more expensive": dash_cost_more,
	"Your speed is reduced": dash_cost_less,
	"Your vision is reduced": reduced_vision
}

# Oxygene
# capacité max d'oxygene
func win_oxygen_capacity(player):
	var oldMaxOxygen = player.Oxygen_component.max_oxygen
	player.Oxygen_component.max_oxygen += 0.5
	
func lose_half_oxygen(player):
	player.Oxygen_component.oxygen /= 2

func win_oxygen_capacity_(player):
	if player.Oxygen_component == null:
		print("OxygeneComoneent is null")
		return
	var oldMaxOxygen = player.Oxygen_component.max_oxygen
	player.Oxygen_component.max_oxygen *= 1.3
	var gainOxygen = player.Oxygen_component.max_oxygen - oldMaxOxygen
	player.Oxygen_component.oxygen += gainOxygen
	
func win_oxygen(player):
	print("hello")
	

func dash_cost_less(player):
	print("hello")
	
func dash_cost_more(player):
	pass

func reduced_vision(player):
	pass

func _on_area_2d_body_entered(body):
	if body is Player and is_usable:
		var is_dashed_on = false
		for child in body.get_children():
			if child is DashComponent:
				is_dashed_on = child.is_dashing
		if not is_dashed_on:
			return
		is_usable = false
		win_upgrades[win_upgrade].call(body)
		lose_upgrades[lose_upgrade].call(body)
		queue_free()
