extends Node2D

@export var win_upgrade = "Win 30% more oxygen" 
@export var lose_upgrade = "Lose half of oxygen" 

var is_usable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	%Bonus.text = win_upgrade
	%Malus.text = lose_upgrade

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var win_upgrades = {
	"Win 30% more oxygen": win_oxygen_capacity,
}

var lose_upgrades = {
	"Lose half of oxygen": lose_half_oxygen
}

# Oxygene
# capacité max d'oxygene
func win_oxygen_capacity(player):
	var oldMaxOxygen = player.Oxygen_component.max_oxygen
	player.Oxygen_component.max_oxygen *= 1.3
	var gainOxygen = player.Oxygen_component.max_oxygen - oldMaxOxygen
	player.Oxygen_component.oxygen += gainOxygen
	
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
	

func _on_area_2d_body_entered(body):
	if body is Player and is_usable:
		is_usable = false
		win_upgrades[win_upgrade].call(body)
		lose_upgrades[lose_upgrade].call(body)
		queue_free()
