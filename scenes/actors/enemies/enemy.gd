extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	move_and_slide()


func _on_hitbox_component_recieved_damage(damager_area:Area2D, damage_amount:float):
	print("I have been hit")