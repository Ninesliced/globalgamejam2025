extends Node2D

@export var win_upgrade = "Your speed is fastest"
@export var lose_upgrade = "Your speed is reduced" 

var is_usable = true
var bbc_default_string = "\n[outline_size=20][b][center][wave]{text}[/wave][/center][/b][/outline_size]"

var win_upgrades = {
	"Increase oxygen capacity": win_oxygen_capacity,
	"Refill the oxygen": refill_oxygen,
	"The dash costs less": dash_cost_less,
	"The shoot costs less": shoot_cost_less,
	"Your speed is faster": speed_fastest
}

var lose_upgrades = {
	"Halve the oxygen reserve": lose_half_oxygen,
	"The dash is more expensive": dash_cost_more,
	"Shooting is more expensive": shoot_cost_more,
	"Your vision is reduced": reduced_vision
}

# Called when the node enters the scene tree for the first time.
func _ready():
	win_upgrade = win_upgrades.keys().pick_random()
	lose_upgrade = lose_upgrades.keys().pick_random()
	var win_upgrade_text = "+ " + win_upgrade
	var lose_upgrade_text = "- " + lose_upgrade
	win_upgrade_text = "[color=#63c74d]" + win_upgrade_text + "[/color]"
	lose_upgrade_text = "[color=#ff0044]" + lose_upgrade_text + "[/color]"
	%Bonus.text = bbc_default_string.replace("{text}", win_upgrade_text)
	%Malus.text = bbc_default_string.replace("{text}", lose_upgrade_text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Oxygene
# capacité max d'oxygene
func win_oxygen_capacity(player):
	player.Oxygen_component.max_oxygen += 0.5
	
func refill_oxygen(player):
	player.Oxygen_component.oxygen = player.Oxygen_component.max_oxygen
	
func dash_cost_less(player):
	player.Dash_component.dash_consumption = max(0, player.Dash_component.dash_consumption - 5)
	
func shoot_cost_less(player):
	player.Weapon_component.weapon_resource.oxygen_comsuption = max(0.0, player.Weapon_component.weapon_resource.oxygen_comsuption - 0.2)
	
func speed_fastest(player):
	player.speed = min(player.speed + 100., 1000.)
	
func lose_half_oxygen(player):
	player.Oxygen_component.oxygen /= 2

func dash_cost_more(player):
	player.Dash_component.dash_consumption = min(player.Dash_component.dash_consumption + 5, 50)

func shoot_cost_more(player):
	player.Weapon_component.weapon_resource.oxygen_comsuption = min(10.0, player.Weapon_component.weapon_resource.oxygen_comsuption + 0.2)

func reduced_vision(player):
	player.get_parent().next_light_effect()

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
		%NotTaken.visible = false
		%NoItem.visible = true
